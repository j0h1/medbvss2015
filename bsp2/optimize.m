function best = optimize(f, mi, ma, drawFunction)

assert(size(mi,2)==1);
assert(size(ma,2)==1);
assert(isequal(size(mi),size(ma)));
assert(all(ma>mi));
assert(isa(f,'function_handle'))

if nargin<4
    drawFunction = [];
end
figHandles = [];

n = 100;
mi = mi(:);
ma = ma(:);
pop = bsxfun(@times, randn(numel(mi),n)/6, ma-mi);
pop = bsxfun(@plus, pop, mean([ma mi],2));
pop = clamp(pop, mi, ma);
cs = zeros(1,size(pop,2));
for i = 1:size(pop,2)
    cs(i) = feval(f, pop(:,i));
end
nStableIter = 0;
i = 0;
maxIter = 1e6;

lastCosts = realmax*ones(1,10000);
while i<maxIter && nStableIter<1e4
    i = i + 1;
    ind = randi(100,1,3);
    newPos = pop(:,ind(1)) + 0.85*(pop(:,ind(3))-pop(:,ind(2)));
    newPos = clamp(newPos,mi,ma);
    if all(newPos>mi) && all(newPos<ma)
        newCost = feval(f, newPos);
        %hold on
        %plot(pop(end-1,ind(1)),pop(end,ind(1)),'ko');
        %plot(pop(end-1,ind(1)),pop(end,ind(1)),'b.');
        if newCost<cs(ind(1))
            %plot(newPos(end-1),newPos(end),'g.');
            %plot(newPos(end-1),newPos(end),'wo');
            cs(ind(1)) = newCost;
            pop(:,ind(1)) = newPos;
            nStableIter = 0;
        end
        nStableIter = nStableIter + 1;
        %fprintf('i: %d  stable for: %d\n',i,nStableIter);
        %fprintf('newCost: %f\n',newCost);
        lastInd = mod(i,size(lastCosts,2))+1;
        if lastCosts(lastInd)-newCost<1e-6
            break;
        end
        lastCosts(lastInd)=newCost;
    end
    
    [~, sortInd] = sort(cs);
    if not(isempty(drawFunction))
        hold on
        for handleInd = 1:numel(figHandles)
            try
            delete(figHandles(handleInd));
            catch %#ok<CTCH>
            end
        end
        figHandles = feval(drawFunction,pop,sortInd(1));
        drawnow
    end
    
    % replace worst members
    worstInd = sortInd(round(end*0.8):end);
    copiesOfBest = repmat(pop(:,sortInd(1)), 1, numel(worstInd));
    range = 0.01*abs(ma-mi)/2;
    copiesOfBest = copiesOfBest + bsxfun(@times,randn(size(copiesOfBest)),range);
    pop(:,worstInd) = copiesOfBest;
    
end
[~, minInd] = min(cs);
best = pop(:,minInd);
end

function r = clamp(r, mi, ma)
for i = 1:numel(mi)
    r(i,:) = min(max(r(i,:), mi(i)), ma(i));
end

end




