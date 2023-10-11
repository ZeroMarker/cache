//重写resize
//2013-11-05 by lisen
Ext.BDP.Resizable = Ext.extend(Ext.Resizable, {
	onMouseMove : function(e){
        if(this.enabled && this.activeHandle){
            try{

            if(this.resizeRegion && !this.resizeRegion.contains(e.getPoint())) {
                return;
            }
			
            var curSize = this.curSize || this.startBox,
                x = this.startBox.x, y = this.startBox.y,
                ox = x,
                oy = y,
                w = curSize.width,
                h = curSize.height,
                ow = w,
                oh = h,
                mw = this.minWidth,
                mh = this.minHeight,
                mxw = this.maxWidth,
                mxh = this.maxHeight,
                wi = this.widthIncrement,
                hi = this.heightIncrement,
                eventXY = e.getXY(),
                diffX = -(this.startPoint[0] - Math.max(this.minX, eventXY[0])),
                diffY = -(this.startPoint[1] - Math.max(this.minY, eventXY[1])),
                pos = this.activeHandle.position,
                tw,
                th;

            switch(pos){
                case 'east':
                    w += diffX;
                    w = Math.min(Math.max(mw, w), mxw);
                    Ext.getCmp('TextW').setValue(w);
                    break;
                case 'south':
                    h += diffY;
                    h = Math.min(Math.max(mh, h), mxh);
                    Ext.getCmp('TextH').setValue(h);
                    break;
                case 'southeast':
                    w += diffX;
                    h += diffY;
                    w = Math.min(Math.max(mw, w), mxw);
                    h = Math.min(Math.max(mh, h), mxh);
                    Ext.getCmp('TextW').setValue(w);
                    Ext.getCmp('TextH').setValue(h);
                    break;
                case 'north':
                    diffY = this.constrain(h, diffY, mh, mxh);
                    y += diffY;
                    h -= diffY;
                    break;
                case 'west':
                    diffX = this.constrain(w, diffX, mw, mxw);
                    x += diffX;
                    w -= diffX;
                    break;
                case 'northeast':
                    w += diffX;
                    w = Math.min(Math.max(mw, w), mxw);
                    diffY = this.constrain(h, diffY, mh, mxh);
                    y += diffY;
                    h -= diffY;
                    break;
                case 'northwest':
                    diffX = this.constrain(w, diffX, mw, mxw);
                    diffY = this.constrain(h, diffY, mh, mxh);
                    y += diffY;
                    h -= diffY;
                    x += diffX;
                    w -= diffX;
                    break;
               case 'southwest':
                    diffX = this.constrain(w, diffX, mw, mxw);
                    h += diffY;
                    h = Math.min(Math.max(mh, h), mxh);
                    x += diffX;
                    w -= diffX;
                    break;
            }

            var sw = this.snap(w, wi, mw);
            var sh = this.snap(h, hi, mh);
            if(sw != w || sh != h){
                switch(pos){
                    case 'northeast':
                        y -= sh - h;
                    break;
                    case 'north':
                        y -= sh - h;
                        break;
                    case 'southwest':
                        x -= sw - w;
                    break;
                    case 'west':
                        x -= sw - w;
                        break;
                    case 'northwest':
                        x -= sw - w;
                        y -= sh - h;
                    break;
                }
                w = sw;
                h = sh;
            }

            if(this.preserveRatio){
                switch(pos){
                    case 'southeast':
                    case 'east':
                        h = oh * (w/ow);
                        h = Math.min(Math.max(mh, h), mxh);
                        w = ow * (h/oh);
                       break;
                    case 'south':
                        w = ow * (h/oh);
                        w = Math.min(Math.max(mw, w), mxw);
                        h = oh * (w/ow);
                        break;
                    case 'northeast':
                        w = ow * (h/oh);
                        w = Math.min(Math.max(mw, w), mxw);
                        h = oh * (w/ow);
                    break;
                    case 'north':
                        tw = w;
                        w = ow * (h/oh);
                        w = Math.min(Math.max(mw, w), mxw);
                        h = oh * (w/ow);
                        x += (tw - w) / 2;
                        break;
                    case 'southwest':
                        h = oh * (w/ow);
                        h = Math.min(Math.max(mh, h), mxh);
                        tw = w;
                        w = ow * (h/oh);
                        x += tw - w;
                        break;
                    case 'west':
                        th = h;
                        h = oh * (w/ow);
                        h = Math.min(Math.max(mh, h), mxh);
                        y += (th - h) / 2;
                        tw = w;
                        w = ow * (h/oh);
                        x += tw - w;
                       break;
                    case 'northwest':
                        tw = w;
                        th = h;
                        h = oh * (w/ow);
                        h = Math.min(Math.max(mh, h), mxh);
                        w = ow * (h/oh);
                        y += th - h;
                        x += tw - w;
                        break;

                }
            }
            this.proxy.setBounds(x, y, w, h);
            if(this.dynamic){
                this.resizeElement();
            }
            }catch(ex){}
        }
    }
});