function desc = computeHaarLike(img)

iimg = integralImage(single(img));
dp.haarSizes = [8 16 32 64];       % must be even number
dp.unittest = false;
p.nDim = numel(size(iimg));
dp.haarDescIndices = 1:(2*p.nDim)+1;
p = defaultParams(p,dp);



wavelets = cell(1,length(p.haarSizes));

for sInd = 1:length(p.haarSizes)
    if p.nDim==2
        wavelets{sInd} = cell(1,4);
        waveletRegion = [-0.5 0.5;
            -0.5 0.5];
        wavelets{1} = [ 0    0.5;
            -0.5  0.5];
        wavelets{2} = [-0.5  0.5;
            0    0.5];
        wavelets{3} = [-1/4  1/4;
            -0.5  0.5];
        wavelets{4} = [-0.5  0.5;
            -1/4  1/4];
        wavelets{5} = [0  0;
            0  0];
    else
        wavelets{sInd} = cell(1,6);
        waveletRegion = [-0.5 0.5;
            -0.5  0.5;
            -0.5  0.5];
        
        wavelets{1} = [ 0    0.5;
            -0.5  0.5;
            -0.5  0.5];
        wavelets{2} = [-0.5  0.5;
            0    0.5;
            -0.5  0.5];
        wavelets{3} = [-0.5  0.5;
            -0.5  0.5;
            0    0.5];
        wavelets{4} = [-1/4  1/4;
            -0.5  0.5;
            -0.5  0.5];
        wavelets{5} = [-0.5  0.5;
            -1/4  1/4;
            -0.5  0.5];
        wavelets{6} = [-0.5  0.5;
            -0.5  0.5;
            -1/4  1/4];
        wavelets{7} = [0  0;
            0  0;
            0  0];
    end
end



%desc = zeros(4*length(sizes),size(points,2));

% for i = 1:size(points,2)
%     for s = 1:length(sizes)
%         d = zeros(1,4);
%         try
%             for w = 1:4
%                 W = round(wavelets{w}{1}*sizes(s)+[points(:,i) points(:,i)]);
%                 negsum = iimg(W(2,1),W(1,1)) + iimg(W(2,2),W(1,2)) - iimg(W(2,2),W(1,1)) - iimg(W(2,1),W(1,2));
%                 W = round(wavelets{w}{2}*sizes(s)+[points(:,i) points(:,i)]);
%                 doublesum = iimg(W(2,1),W(1,1)) + iimg(W(2,2),W(1,2)) - iimg(W(2,2),W(1,1)) - iimg(W(2,1),W(1,2));
%                 d(w) = -negsum+2*doublesum;
%             end
%         catch
%         end
%         desc((s-1)*4+(1:4),i)=d;
%     end
% end

[sy, sx, sz] = size(iimg);

[X,Y] = meshgrid(1:sx,1:sy);
points = [X(:)'; Y(:)'];

nPoints = size(points,2);
sums{2} = zeros(1,nPoints);
sums{1} = zeros(1,nPoints);
negsum    = zeros(1,nPoints);
doublesum = zeros(1,nPoints);
desc = zeros(numel(p.haarDescIndices)*numel(p.haarSizes),size(points,2));

%progressHandle = [];

for s = 1:length(p.haarSizes)
    ok = ones(1,size(points,2))>0;
    x = 1;
    y = 2;
    z = 3;
    if p.nDim == 2
        for wInd = 1:length(p.haarDescIndices)
            w = p.haarDescIndices(wInd);
            W = waveletRegion*p.haarSizes(s);
            % -1 offsets necessary to measure the block like a
            % sum(block(:)) would do
            w1 = round([W(x,2)+points(x,:)  ; W(y,2)+points(y,:)  ]);
            w2 = round([W(x,1)+points(x,:)-1; W(y,1)+points(y,:)-1]);
            w3 = round([W(x,1)+points(x,:)-1; W(y,2)+points(y,:)  ]);
            w4 = round([W(x,2)+points(x,:)  ; W(y,1)+points(y,:)-1]);
            ok = ok & ...
                w1(x,:) >  0   &  w2(x,:) >  0   &  w3(x,:) >  0   &  w4(x,:) >  0   & ...
                w1(x,:) <= sx  &  w2(x,:) <= sx  &  w3(x,:) <= sx  &  w4(x,:) <= sx  & ...
                w1(y,:) >  0   &  w2(y,:) > 0    &  w3(y,:) >  0   &  w4(y,:) >  0 & ...
                w1(y,:) <= sy  &  w2(y,:) <= sy  &  w3(y,:) <= sy  &  w4(y,:) <= sy;
            w1i = sub2ind(size(iimg),w1(y,ok),w1(x,ok));
            w2i = sub2ind(size(iimg),w2(y,ok),w2(x,ok));
            w3i = sub2ind(size(iimg),w3(y,ok),w3(x,ok));
            w4i = sub2ind(size(iimg),w4(y,ok),w4(x,ok));
            
            negsum(ok) = iimg(w1i) + iimg(w2i) - iimg(w3i) - iimg(w4i);
            
            if p.unittest
                for i = 1:length(ok)
                    if ok(i)
                        block = img((W(y,1):W(y,2))+points(y,i), ...
                            (W(x,1):W(x,2))+points(x,i));
                        assert(negsum(i)==sum(block(:)));
                    end
                end
            end
            
            W = wavelets{w}*p.haarSizes(s);
            w1 = round([W(x,2)+points(x,:); W(y,2)+points(y,:)]);
            w2 = round([W(x,1)+points(x,:); W(y,1)+points(y,:)]);
            w3 = round([W(x,1)+points(x,:); W(y,2)+points(y,:)]);
            w4 = round([W(x,2)+points(x,:); W(y,1)+points(y,:)]);
            ok = ok & ...
                w1(x,:) >  0   &  w2(x,:) >  0   &  w3(x,:) >  0   &  w4(x,:) >  0   & ...
                w1(x,:) <= sx  &  w2(x,:) <= sx  &  w3(x,:) <= sx  &  w4(x,:) <= sx  & ...
                w1(y,:) >  0   &  w2(y,:) > 0    &  w3(y,:) >  0   &  w4(y,:) >  0   & ...
                w1(y,:) <= sy  &  w2(y,:) <= sy  &  w3(y,:) <= sy  &  w4(y,:) <= sy;
            w1i = sub2ind(size(iimg),w1(y,ok),w1(x,ok));
            w2i = sub2ind(size(iimg),w2(y,ok),w2(x,ok));
            w3i = sub2ind(size(iimg),w3(y,ok),w3(x,ok));
            w4i = sub2ind(size(iimg),w4(y,ok),w4(x,ok));
            doublesum(ok) = iimg(w1i) + iimg(w2i) - iimg(w3i) - iimg(w4i);
            if p.unittest
                for i = 1:length(ok)
                    if ok(i)
                        block = img((W(y,1):W(y,2))+points(y,i), ...
                            (W(x,1):W(x,2))+points(x,i));
                        assert(doublesum(i)==sum(block(:)));
                    end
                end
            end
            
            desc((s-1)*4+w,ok) = (-negsum(ok)+2*doublesum(ok)) / (p.haarSizes(s)+1)^2;
        end
    else
        sxy = sx*sy;
        W = waveletRegion * p.haarSizes(s);
        
        Wx1 = (W(x,1)+points(x,:)-2);
        Wx2 = (W(x,2)+points(x,:)-1);
        Wy1 = (W(y,1)+points(y,:)-1);
        Wy2 = (W(y,2)+points(y,:));
        Wz1 = (W(z,1)+points(z,:)-2);
        Wz2 = (W(z,2)+points(z,:)-1);
        
        ok = Wx1>=0 & Wx2<sx & Wy1>0 & Wy2<=sy & Wz1>=0 & Wz2<sz;
        
        Wx1 = Wx1(ok);
        Wx2 = Wx2(ok);
        Wy1 = Wy1(ok);
        Wy2 = Wy2(ok);
        Wz1 = Wz1(ok);
        Wz2 = Wz2(ok);
        
        wZ1i = Wy2 + sy*Wx2 + sxy*Wz2;
        wZ2i = Wy1 + sy*Wx1 + sxy*Wz2;
        wZ3i = Wy1 + sy*Wx2 + sxy*Wz2;
        wZ4i = Wy2 + sy*Wx1 + sxy*Wz2;
        wz1i = Wy2 + sy*Wx2 + sxy*Wz1;
        wz2i = Wy1 + sy*Wx1 + sxy*Wz1;
        wz3i = Wy1 + sy*Wx2 + sxy*Wz1;
        wz4i = Wy2 + sy*Wx1 + sxy*Wz1;
        
        sums{1}(ok) =  iimg(wZ1i) + iimg(wZ2i) - iimg(wZ3i) - iimg(wZ4i) ...
            -iimg(wz1i) - iimg(wz2i) + iimg(wz3i) + iimg(wz4i);
        if p.unittest
            for i = 1:length(ok)
                if ok(i)
                    block = img((W(y,1):W(y,2))+points(y,i), ...
                        (W(x,1):W(x,2))+points(x,i), ...
                        (W(z,1):W(z,2))+points(z,i));
                    assert(sums{1}(i)==sum(block(:)));
                end
            end
        end
        
        for wInd = 1:length(p.haarDescIndices)
            %printProgressAndTime('computing haar Descriptors', (s-1)*length(p.haarDescIndices)+wInd, size(desc,1), progressHandle);
            w = p.haarDescIndices(wInd);
            W = wavelets{w}   * p.haarSizes(s);
            
            % -1 offsets necessary to measure the block like a
            % sum(block(:)) would do
            
            Wx1 = (W(x,1)+points(x,ok)-2);
            Wx2 = (W(x,2)+points(x,ok)-1);
            Wy1 = (W(y,1)+points(y,ok)-1);
            Wy2 = (W(y,2)+points(y,ok));
            Wz1 = (W(z,1)+points(z,ok)-2);
            Wz2 = (W(z,2)+points(z,ok)-1);
            
            %                 wZ1 = round([W(x,2)+points(x,:)  ; W(y,2)+points(y,:)  ; W(z,2)+points(z,:)  ]);
            %                 wZ2 = round([W(x,1)+points(x,:)-1; W(y,1)+points(y,:)-1; W(z,2)+points(z,:)  ]);
            %                 wZ3 = round([W(x,2)+points(x,:)  ; W(y,1)+points(y,:)-1; W(z,2)+points(z,:)  ]);
            %                 wZ4 = round([W(x,1)+points(x,:)-1; W(y,2)+points(y,:)  ; W(z,2)+points(z,:)  ]);
            %                 wz1 = round([W(x,2)+points(x,:)  ; W(y,2)+points(y,:)  ; W(z,1)+points(z,:)-1]);
            %                 wz2 = round([W(x,1)+points(x,:)-1; W(y,1)+points(y,:)-1; W(z,1)+points(z,:)-1]);
            %                 wz3 = round([W(x,2)+points(x,:)  ; W(y,1)+points(y,:)-1; W(z,1)+points(z,:)-1]);
            %                 wz4 = round([W(x,1)+points(x,:)-1; W(y,2)+points(y,:)  ; W(z,1)+points(z,:)-1]);
            
            %                 wZ1 = [Wx2; Wy2; Wz2];
            %                 wZ2 = [Wx1; Wy1; Wz2];
            %                 wZ3 = [Wx2; Wy1; Wz2];
            %                 wZ4 = [Wx1; Wy2; Wz2];
            %                 wz1 = [Wx2; Wy2; Wz1];
            %                 wz2 = [Wx1; Wy1; Wz1];
            %                 wz3 = [Wx2; Wy1; Wz1];
            %                 wz4 = [Wx1; Wy2; Wz1];
            
            %                 ok = ok & ...
            %                     wZ1(x,:) >  0   &  wZ2(x,:) >  0   &  wZ3(x,:) >  0   &  wZ4(x,:) >  0   & ...
            %                     wz1(x,:) >  0   &  wz2(x,:) >  0   &  wz3(x,:) >  0   &  wz4(x,:) >  0   & ...
            %                     wZ1(x,:) <= sx  &  wZ2(x,:) <= sx  &  wZ3(x,:) <= sx  &  wZ4(x,:) <= sx  & ...
            %                     wz1(x,:) <= sx  &  wz2(x,:) <= sx  &  wz3(x,:) <= sx  &  wz4(x,:) <= sx  & ...
            %                     wZ1(y,:) >  0   &  wZ2(y,:) > 0    &  wZ3(y,:) >  0   &  wZ4(y,:) >  0   & ...
            %                     wz1(y,:) >  0   &  wz2(y,:) > 0    &  wz3(y,:) >  0   &  wz4(y,:) >  0   & ...
            %                     wZ1(y,:) <= sy  &  wZ2(y,:) <= sy  &  wZ3(y,:) <= sy  &  wZ4(y,:) <= sy  & ...
            %                     wz1(y,:) <= sy  &  wz2(y,:) <= sy  &  wz3(y,:) <= sy  &  wz4(y,:) <= sy  & ...
            %                     wZ1(z,:) >  0   &  wZ2(z,:) > 0    &  wZ3(z,:) >  0   &  wZ4(z,:) >  0   & ...
            %                     wz1(z,:) >  0   &  wz2(z,:) > 0    &  wz3(z,:) >  0   &  wz4(z,:) >  0   & ...
            %                     wZ1(z,:) <= sz  &  wZ2(z,:) <= sz  &  wZ3(z,:) <= sz  &  wZ4(z,:) <= sz  & ...
            %                     wz1(z,:) <= sz  &  wz2(z,:) <= sz  &  wz3(z,:) <= sz  &  wz4(z,:) <= sz;
            
            
            
            %                 wZ1i = sub2ind(size(iimg),wZ1(y,ok),wZ1(x,ok),wZ1(z,ok));
            %                 wZ2i = sub2ind(size(iimg),wZ2(y,ok),wZ2(x,ok),wZ2(z,ok));
            %                 wZ3i = sub2ind(size(iimg),wZ3(y,ok),wZ3(x,ok),wZ3(z,ok));
            %                 wZ4i = sub2ind(size(iimg),wZ4(y,ok),wZ4(x,ok),wZ4(z,ok));
            %                 wz1i = sub2ind(size(iimg),wz1(y,ok),wz1(x,ok),wz1(z,ok));
            %                 wz2i = sub2ind(size(iimg),wz2(y,ok),wz2(x,ok),wz2(z,ok));
            %                 wz3i = sub2ind(size(iimg),wz3(y,ok),wz3(x,ok),wz3(z,ok));
            %                 wz4i = sub2ind(size(iimg),wz4(y,ok),wz4(x,ok),wz4(z,ok));
            
            
            %                 wZ1i = sub2ind(size(iimg),Wy2(ok),Wx2(ok),Wz2(ok));
            %                 wZ2i = sub2ind(size(iimg),Wy1(ok),Wx1(ok),Wz2(ok));
            %                 wZ3i = sub2ind(size(iimg),Wy1(ok),Wx2(ok),Wz2(ok));
            %                 wZ4i = sub2ind(size(iimg),Wy2(ok),Wx1(ok),Wz2(ok));
            %                 wz1i = sub2ind(size(iimg),Wy2(ok),Wx2(ok),Wz1(ok));
            %                 wz2i = sub2ind(size(iimg),Wy1(ok),Wx1(ok),Wz1(ok));
            %                 wz3i = sub2ind(size(iimg),Wy1(ok),Wx2(ok),Wz1(ok));
            %                 wz4i = sub2ind(size(iimg),Wy2(ok),Wx1(ok),Wz1(ok));
            
            wZ1i = Wy2 + sy*Wx2 + sxy*Wz2;
            wZ2i = Wy1 + sy*Wx1 + sxy*Wz2;
            wZ3i = Wy1 + sy*Wx2 + sxy*Wz2;
            wZ4i = Wy2 + sy*Wx1 + sxy*Wz2;
            wz1i = Wy2 + sy*Wx2 + sxy*Wz1;
            wz2i = Wy1 + sy*Wx1 + sxy*Wz1;
            wz3i = Wy1 + sy*Wx2 + sxy*Wz1;
            wz4i = Wy2 + sy*Wx1 + sxy*Wz1;
            
            %                 assert(isequal(wZ1i,wZ1i2));
            %                 assert(isequal(wZ2i,wZ2i2));
            %                 assert(isequal(wZ3i,wZ3i2));
            %                 assert(isequal(wZ4i,wZ4i2));
            %                 assert(isequal(wz1i,wz1i2));
            %                 assert(isequal(wz2i,wz2i2));
            %                 assert(isequal(wz3i,wz3i2));
            %                 assert(isequal(wz4i,wz4i2));
            
            sums{2}(ok) =  iimg(wZ1i) + iimg(wZ2i) - iimg(wZ3i) - iimg(wZ4i) ...
                -iimg(wz1i) - iimg(wz2i) + iimg(wz3i) + iimg(wz4i);
            
            if p.unittest
                for i = 1:length(ok)
                    if ok(i)
                        block = img((W(y,1):W(y,2))+points(y,i), ...
                            (W(x,1):W(x,2))+points(x,i), ...
                            (W(z,1):W(z,2))+points(z,i));
                        assert(sums{2}(i)==sum(block(:)));
                    end
                end
            end
            
            desc((s-1)*length(p.haarDescIndices)+wInd,ok) = (-sums{1}(ok)+2*sums{2}(ok)) / (p.haarSizes(s)+1)^3;
        end
    end
end
end
%assert(isequal(desc,desc2))























