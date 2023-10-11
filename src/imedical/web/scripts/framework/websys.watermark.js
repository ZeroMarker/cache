 /**
 * 20230131
 * @author  wanghc
 */
(function(){
    var Websyswatermark = function(elem){
        this.elem = elem;
    }
    Websyswatermark.prototype = {
        defaults : {
            texts : ['water mark texts'],
            width : 100, 
            height : 100, 
            textRotate : -30 ,
            textColor : '#e5e5e5', 
            textFont : '14px sans-serif', 
			opacity:0.5,
			startTop : 20,
			startLeft: 20
        },
        options : {
            
        },
        init : function(options){
			if ('undefined'!=typeof options){
				this.options = options;
				for(var i in this.defaults){
					if(this.defaults.hasOwnProperty(i)){
						if (!options.hasOwnProperty(i)){
							this.options[i] = this.defaults[i];
						}
					}
				}
				//$.extend(this.options, this.defaults, options);
			}
			var cnttObj = document.getElementById("#z_wm_cntt");
			if (cnttObj){
				var p = cnttObj.parentElement||cnttObj.parentNode;
				p.removeChild(cnttObj);
			}	
            var w = this.elem.scrollWidth,h = this.elem.scrollHeight;
			var container = '';
			var mask_div = document.createElement('div');
			mask_div.id="z_wm_cntt";
			mask_div.style.userSelect="none";
			mask_div.style.pointerEvents="none";
			mask_div.style.userSelect="none";
			mask_div.style.position="absolute";
			mask_div.style.width=w+"px";
			mask_div.style.height=h+"px";
			mask_div.style.overflow="hidden";
			mask_div.style.backgroundColor="rgba(255, 255, 255, 0)";
			mask_div.style.top="0px";
			mask_div.style.left="0px";
			mask_div.style.zIndex=666667;
			
			var html = [];
			//html.push('<div id="z_wm_cntt" style="user-select:none;pointer-events:none;position:absolute;width:'+w+'px;height:'+h+'px;overflow: hidden;background-color:rgba(255, 255, 255, 0);top:0px;left:0px;z-index:666667;">')
			var mytop = this.options.startTop,myleft = this.options.startLeft;
			for (var i=0;i<1000;i++){
				if (mytop>h) break;
				if (myleft>w) {
					mytop += this.options.height;
					myleft = this.options.startLeft;
				}
				html.push('<div style="left:'+myleft+'px;top:'+mytop+'px;width:'+this.options.width+'px;height:'+this.options.height+'px;color:'+this.options.textColor+';font:'+this.options.textFont+';position:absolute;z-index:666667;opacity:'+this.options.opacity+';pointer-events:none;transform:rotate('+this.options.textRotate+'deg);user-select:none;">');
				html.push(this.options.texts.join('<br>'));
				html.push('</div>');
				myleft += this.options.width;
			}
			//html.push('</div>');
			//$(this.elem).append(html.join(''));
			mask_div.innerHTML=(html.join(''));
			this.elem.appendChild(mask_div);
        }
        
    }
    var genWatermark = function(elem,options){
	    //options = {texts:["ys01","ys02"],textColor:'#d2d2d2','textFont':'14px ???ик????',width:200,height:200,opacity:0.7,textRotate:-30};
		var websyswm = new Websyswatermark(elem);
	    if ("undefined"==typeof options){
        	var cfgJsonStr = tkMakeServerCall("BSP.SYS.SRV.WaterMark","GetCfg");
        	if (cfgJsonStr!=0 && cfgJsonStr!=""){
        		eval("var cfgJson = "+cfgJsonStr);
        		options = cfgJson ;
        	}
        }
	    if (options) {
		    websyswm.init(options);
		    window.addEventListener('resize',function(){
				websyswm.init();
			});
		    }
	}
	
	
	var isTopWin=true;
	if(typeof websys_getTop=='function') {
		if (websys_getTop()!=window) isTopWin=false;
	}else if(top!=window){
		isTopWin=false;
	}
	
	if (typeof window.addEventListener != "undefined") { 
		window.addEventListener("load",function(){
		    setTimeout(function(){
			    if(isTopWin) genWatermark(document.body);
			},1000);
		},false); 
	} else { 
		window.attachEvent("onload",function(){
			setTimeout(function(){
			    if(isTopWin) genWatermark(document.body);
			},1000);
		}) 
	} 

})();
