Ext.namespace('dhcc.icare');
dhcc.icare.tabPanelConfig = {	
	divId:"bodyTablePanelComponentId",		//body内的div的id
	divDom :''							//全局的div dom对象 id为dhcc.icare.tabPanelConfig.divId	
};
function prop(n){return n&&n.constructor==Number?n+'px':n;}
function createTabPanelBodyDiv(){
	var s ,html;
	dhcc.icare.tabPanelConfig.divDom = document.createElement("div");
	dhcc.icare.tabPanelConfig.divDom.id = dhcc.icare.tabPanelConfig.divId ;
	dhcc.icare.tabPanelConfig.divDom.style.display = "none";
	dhcc.icare.tabPanelConfig.divDom.style.zIndex = 1000;	
	dhcc.icare.tabPanelConfig.divDom.style.position = "absolute";			
	document.body.appendChild(dhcc.icare.tabPanelConfig.divDom);
	if(Ext.isIE6){
		s = {top:'auto',left:'auto',width:'auto',height:'auto',opacity:true,src:'javascript:false;'};
		html= '<iframe class="bgiframe"frameborder="0"tabindex="-1"src="'+s.src+'"'+
	                   'style="display:block;position:absolute;z-index:-1;'+
	                       (s.opacity !== false?'filter:Alpha(Opacity=\'0\');':'')+
	                       'top:'+(s.top=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderTopWidth)||0)*-1)+\'px\')':prop(s.top))+';'+
	                       'left:'+(s.left=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderLeftWidth)||0)*-1)+\'px\')':prop(s.left))+';'+
	                       'width:'+(s.width=='auto'?'expression(this.parentNode.offsetWidth+\'px\')':prop(s.width))+';'+
	                       'height:'+(s.height=='auto'?'expression(this.parentNode.offsetHeight+\'px\')':prop(s.height))+';'+
	                '"/>';
		dhcc.icare.tabPanelConfig.divDom.insertBefore(document.createElement(html));
	}
}

Ext.onReady(createTabPanelBodyDiv);
dhcc.icare.TabPanel = Ext.extend(Ext.TabPanel, {	
	/**
	* x {Number} left 
	*/
	/**
	* y {Number} top
	*/
	draggable: {
        insertProxy: false,
        onDrag : function(e){
            var pel = this.proxy.getEl();
            this.x = pel.getLeft(true);
            this.y = pel.getTop(true);
            var s = this.panel.getEl().shadow;
            if (s) {
                s.realign(this.x, this.y, pel.getWidth(), pel.getHeight());
            }
        },
        endDrag : function(e){
            dhcc.icare.tabPanelConfig.divDom.style.pixelLeft = this.x;
			dhcc.icare.tabPanelConfig.divDom.style.pixelTop = this.y ;
        }
    },
	initComponent : function() {
		Ext.EventManager.addListener(this.srcElementId,"click",function(){		
			if(this.isVisible()) {this.hide();}
			else {this.show();}
		},this);	
		this.collapsible = true;		
		this.renderTo = dhcc.icare.tabPanelConfig.divId;
		//dhcc.icare.tabPanelConfig.divDom.style.pixelLeft = this.x || 10;
		//dhcc.icare.tabPanelConfig.divDom.style.pixelTop = this.y || 10;		
		dhcc.icare.TabPanel.superclass.initComponent.call(this);
    },
	isVisible : function(){
		if(dhcc.icare.tabPanelConfig.divDom.style.display == "none"){
			return false;
		}else {
			return true;
		}
	},	
	getOffset : function(o){
		var ntLeft = o.offsetLeft ;
		var ntTop = o.offsetTop + o.offsetHeight ;
		var width = o.offsetWidth;
		var height = o.offsetHeight		
		while(o = o.offsetParent){
			ntLeft += o.offsetLeft;
			ntTop += o.offsetTop;
		}		
		return [ntLeft,ntTop,width,height];		
	},
	posiAndSizeResize: function(){
		var xy = this.getOffset(document.getElementById(this.srcElementId));
		var bodyHeight = document.body.clientHeight; // window.screen.height ;
		var bodyWidth = document.body.clientWidth;
		var topBlank = xy[1] - xy[3];
		var bottomBlank = bodyHeight - xy[1];
		var leftBlank = xy[0];
		var rightBlank = bodyWidth - xy[0] - xy[2];
		var height = this.height || 600;
		var width = this.width || 600;
		if ( rightBlank < width && width < leftBlank){	//右边不能显示 但左边能显示
			dhcc.icare.tabPanelConfig.divDom.style.pixelRight = rightBlank + xy[2]; 
			dhcc.icare.tabPanelConfig.divDom.style.pixelTop = xy[1];
		}else if((bodyHeight-height-xy[1]<0)){//下面不能显示
			if (xy[1]-xy[3]>height){	//上面能显示
				dhcc.icare.tabPanelConfig.divDom.style.pixelLeft = xy[0] ; 
				dhcc.icare.tabPanelConfig.divDom.style.pixelBottom = bottomBlank + xy[3];		
			}else {
				if(topBlank>bottomBlank){
					height = topBlank;
					//this.setHeight(topBlank);
					dhcc.icare.tabPanelConfig.divDom.style.pixelLeft = xy[0] ; 
					dhcc.icare.tabPanelConfig.divDom.style.pixelBottom = bottomBlank + xy[3];		
				}else{
					height = bottomBlank;
					//this.setHeight(bottomBlank);
					dhcc.icare.tabPanelConfig.divDom.style.pixelLeft = xy[0] ; 
					dhcc.icare.tabPanelConfig.divDom.style.pixelTop = xy[1];
				}
			}
		}else{
			dhcc.icare.tabPanelConfig.divDom.style.pixelLeft = xy[0] ; 
			dhcc.icare.tabPanelConfig.divDom.style.pixelTop = xy[1];
		}
		dhcc.icare.tabPanelConfig.divDom.style.display = "";
		//this.setHeight(height);
	},
	show : function(){
		this.posiAndSizeResize();
		dhcc.icare.tabPanelConfig.divDom.style.display = "";
		document.getElementById(this.srcElementId).style.backgroundColor = "red";
	},
	hide : function(){
		dhcc.icare.tabPanelConfig.divDom.style.display = "none";
		document.getElementById(this.srcElementId).style.backgroundColor = "";
	},
	collapse : function(b){
		this.hide();
	}
})