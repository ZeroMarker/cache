// 床位图
// 2013-11-04 by lisen
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};

// escape编码解码会报错	likefan	2021-08-27
getUrlParamFun = function(param) { 
    var params = Ext.urlDecode(location.search.substring(1)); 
	var resultparam=params[param];
	var DecodeParam=decodeURIComponent(decodeURIComponent(resultparam));
	return DecodeParam;
};

var ctloc=getUrlParamFun('ctloc');	//Ext.getUrlParam('ctloc'); 
var CTLOCDesc=getUrlParamFun('CTLOCDesc');	//Ext.getUrlParam('CTLOCDesc'); 

document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/App/Locations/BedMap/PAC_BedMap.css" />');
document.write('<script type="text/javascript" src="../scripts/bdp/App/Locations/BedMap/BDPResize.js"> </script>');
document.title = CTLOCDesc+" -- 床位图";

Ext.onReady(function(){
	//获取div位置
	function getel(el){
		var _t=0;
		var _l=0;
		if (document.documentElement.getBoundingClientRect){
			var box = el.getBoundingClientRect();
			var oDoc = el.ownerDocument;
			//alert(navigator.appVersion);
			if(navigator.userAgent.indexOf("MSIE 6.0") >= 0){
				_t = box.top  -2+ getScrollTop(oDoc);
				_l = box.left  -2+ getScrollLeft(oDoc);
			}else {
				_t = box.top  + getScrollTop(oDoc);
				_l = box.left  + getScrollLeft(oDoc);
			}
		}else{
			while (el.offsetParent) {
				_t += el.offsetTop;
				_l += el.offsetLeft;
				el = el.offsetParent;
			}
		}
		return {top:_t,left:_l};
	}
	function getScrollTop(doc){
		doc = doc || document;
		return Math.max(doc.documentElement.scrollTop, doc.body.scrollTop);
	}function getScrollLeft(doc){
		doc = doc || document;
		return Math.max(doc.documentElement.scrollLeft, doc.body.scrollLeft);
	}
	function mousePos(e){
		var x,y;
		var e = e||window.event;
		return {
			x:e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,
			y:e.clientY+document.body.scrollTop+document.documentElement.scrollTop
		}
	}
	
///////////////////床位区，按序号排列；等候区在最左边 2021-01-25///////////////////
	//alert(Ext.getBody().getViewSize().height);
	//alert(Ext.getBody().getViewSize().width);
	var PX=40;		//床位横向间隔
	var PY=20;		//床位纵向间隔
	var PW=160;		// 床宽
	var PH=60;		//床高
	var PWW=140;	//等候区宽
	var PWH=Ext.getBody().getViewSize().height-PX-PX	//等候区高，根据界面高度调节
	var PColumn=5;	//每排的床数
	var PLeft=0;	//初始化x坐标
	var PTop=0;		//初始化y坐标
	
	//床位区部分
	var objPortlet = tkMakeServerCall("web.DHCBL.CT.PACBed","GetPACBedInfoAsSeq",ctloc);
	var arryTmp = objPortlet.split("<$C1>");
	for(var intRow = 0; intRow < arryTmp.length; intRow ++)
	{
		var myPortlet = arryTmp[intRow];
		if(myPortlet == "") continue;
		var arryField = myPortlet.split("^");
		var PId=arryField[0];		//床id
		var PName=arryField[1];		//床描述
		var PRcFlag=arryField[2];	//是否激活
		if(PRcFlag=="Y") //床位激活时，显示该床位对应的textfield
		{
			var DivId = "PACBed^"+PId;
			var BedDiv = document.createElement("div");
			BedDiv.id = DivId;
			BedDiv.style.position = 'absolute';
			BedDiv.style.borderStyle = 'solid';
			BedDiv.style.borderWidth = '1px';
			BedDiv.style.borderColor = '#6D739A';
			BedDiv.style.background = '#CCD9E8';
			BedDiv.innerHTML = PName;
			
			//根据窗口大小计算每行床位数
			PColumn=parseInt((Ext.getBody().getViewSize().width-PWW-PX)/(PX+PW))
			//根据顺序计算坐标
			PLeft=(PX+PW)*(intRow%PColumn)+PX;		//床位横坐标
			PTop=(PY+PH)*parseInt(intRow/PColumn)+PY;		//床位纵坐标
			PLeft=PLeft+PWW+PX		//加上等候区宽
			
			BedDiv.style.top = PTop+'px';
			BedDiv.style.left = PLeft+'px';
			BedDiv.style.width = PW+'px';
			BedDiv.style.height = PH+'px';
			
			BedDiv.onmousemove = function(){
				var objPosition = getel(this);
				Ext.getCmp('TextX').setValue(objPosition.left);
				Ext.getCmp('TextY').setValue(objPosition.top);
				Ext.getCmp('TextW').setValue(this.offsetWidth);
				Ext.getCmp('TextH').setValue(this.offsetHeight);
			}
			document.body.appendChild(BedDiv);
		}
	}
	
	//等候区部分
	var WaitingDiv = document.createElement("div");
	WaitingDiv.id = "PACWardRoomId";
	WaitingDiv.style.position = 'absolute';
	WaitingDiv.style.borderStyle = 'solid';
	WaitingDiv.style.borderWidth = '1px';
	WaitingDiv.style.borderColor = '#6D739A';
	WaitingDiv.style.background = '#CCD9E8';
	WaitingDiv.innerHTML = "等候区";
	//等候区坐标
	WaitingDiv.style.top = PY+'px';
	WaitingDiv.style.left = PX+'px';
	WaitingDiv.style.width = PWW+'px';
	WaitingDiv.style.height = PTop-PY+PH+'px';	//等候区高度跟随床位变化
	
	WaitingDiv.onmousemove = function(){
		var objPosition = getel(this);
		Ext.getCmp('TextX').setValue(objPosition.left);
		Ext.getCmp('TextY').setValue(objPosition.top);
		Ext.getCmp('TextW').setValue(this.offsetWidth);
		Ext.getCmp('TextH').setValue(this.offsetHeight);
	}
	document.body.appendChild(WaitingDiv);
	
	
	//床位区
	/*
	var objPortlet = tkMakeServerCall("web.DHCBL.CT.PACBed","GetPACBedPanelInfo",ctloc);
	var arryTmp = objPortlet.split("<$C1>");
	var dd = [];
	var resizer = [];
	for(var intRow = 0; intRow < arryTmp.length; intRow ++)
	{
		var myPortlet = arryTmp[intRow];
		if(myPortlet == "") continue;
		var arryField = myPortlet.split("^");
		/// 1 BEDRowID ,  2 BEDRoomDR_"-"_BEDCode, 3 BEDRcFlag 
		/// 4 BEDPositionLeft, 5 BEDPositionTop ,6 BEDPositionHeight ,7 BEDPositionWidth
		var PId=arryField[0];
		var PName=arryField[1];
		var PRcFlag=arryField[2];
		
		var PLeft=arryField[3];			
		var PTop=arryField[4];  //坐标为空时，默认坐标为0
		var PH=arryField[5];
		var PW=arryField[6];
		
		if(PLeft=="") var PLeft=0;
		var PLeft=parseInt(PLeft);
		
		if(PTop=="") var PTop=0;
		var PTop=parseInt(PTop);
		
		if(PH=="") var PH=0;
		var PH=parseInt(PH);
		
		if(PW=="") var PW=0;
		var PW=parseInt(PW);
		
		if(PRcFlag=="Y") //床位激活时，显示该床位对应的textfield
		{
			var DivId = "PACBed^"+PId;
			var BedDiv = document.createElement("div");
			BedDiv.id = DivId;
			BedDiv.style.position = 'absolute';
			BedDiv.style.top = PTop+'px';
			BedDiv.style.left = PLeft+'px';
			BedDiv.style.width = PW+'px';
			BedDiv.style.height = PH+'px';
			BedDiv.style.borderStyle = 'solid';
			BedDiv.style.borderWidth = '1px';
			BedDiv.style.borderColor = '#6D739A';
			BedDiv.style.background = '#CCD9E8';
			BedDiv.innerHTML = PName;
			BedDiv.onmousemove = function(){
				var objPosition = getel(this);
				Ext.getCmp('TextX').setValue(objPosition.left);
				Ext.getCmp('TextY').setValue(objPosition.top);
				Ext.getCmp('TextW').setValue(this.offsetWidth);
				Ext.getCmp('TextH').setValue(this.offsetHeight);
			}
			document.body.appendChild(BedDiv);
		}
	}
	*/
	
	/*
	//等候区
	var objPortletWaiting = tkMakeServerCall("web.DHCBL.CT.PACWardRoom","GetPACWardRoomPanelInfo",ctloc);
	//alert(objPortletWaiting);
	var arryTmpWaiting = objPortletWaiting.split("<$C1>");
	var ddWaiting = [];
	var rezWaiting = [];
	for(var intRow = 0; intRow < arryTmpWaiting.length; intRow ++)
	{
		var myPortletW = arryTmpWaiting[intRow];
		if(myPortletW == "") continue;
		var arryField = myPortletW.split("^");
		/// 1 BEDRowID , 2 ROOM_Room_DR->Desc, 3 ROOMPositionLeft,
		///4 ROOMPositionTop ,5 ROOMPositionHeight ,6 ROOMPositionWidth
		var PId=arryField[0];
		var PName=arryField[1];
		
		var PLeft=arryField[2];
		if(PLeft=="") var PLeft=0;
		var PLeft=parseInt(PLeft);
		
		var PTop=arryField[3];  //坐标为空时，默认坐标为0
		if(PTop=="") var PTop=0;
		var PTop=parseInt(PTop);
		
		var PH=arryField[4];
		if(PH=="") var PH=0;
		var PH=parseInt(PH);
		
		var PW=arryField[5];
		if(PW=="") var PW=0;
		var PW=parseInt(PW);
		
		var DivId = "PACWardRoom^"+PId;
		var WaitingDiv = document.createElement("div");
		WaitingDiv.id = DivId;
		WaitingDiv.style.position = 'absolute';
		WaitingDiv.style.top = PTop+'px';
		WaitingDiv.style.left = PLeft+'px';
		WaitingDiv.style.width = PW+'px';
		WaitingDiv.style.height = PH+'px';
		WaitingDiv.style.borderStyle = 'solid';
		WaitingDiv.style.borderWidth = '1px';
		WaitingDiv.style.borderColor = '#6D739A';
		WaitingDiv.style.background = '#CCD9E8';
		WaitingDiv.innerHTML = PName;
		WaitingDiv.onmousemove = function(){
			var objPosition = getel(this);
			Ext.getCmp('TextX').setValue(objPosition.left);
			Ext.getCmp('TextY').setValue(objPosition.top);
			Ext.getCmp('TextW').setValue(this.offsetWidth);
			Ext.getCmp('TextH').setValue(this.offsetHeight);
		}
		document.body.appendChild(WaitingDiv);
	}
	*/
	
	//坐标显示
	var form = new Ext.FormPanel({
		labelAlign : 'right',
		labelWidth : 50,
		defaultType : 'textfield',
		bodyStyle : 'padding:8px 2px 2px 2px',
		baseCls : 'x-plain',
		items : [{
			fieldLabel : 'X坐标',
			width : 60,
			readOnly : true,
			id : 'TextX'
		},{
			fieldLabel : 'Y坐标',
			width : 60,
			readOnly : true,
			id : 'TextY'
		},{
			fieldLabel : '宽度',
			width : 60,
			readOnly : true,
			id : 'TextW'
		},{
			fieldLabel : '高度',
			width : 60,
			readOnly : true,
			id : 'TextH'
		}]
	});
	var win = new Ext.Window({
		title : '位置/宽高(单位:cm)',
		x : Ext.getBody().getViewSize().width,
		y : Ext.getBody().getViewSize().height,
		height : 180,
		width : 150,
		layout : 'fit',
		frame : true,
		closable : false,
		constrain : true,
		items : [form]
	});
	win.show();
	window.onscroll = function(){
		var x = document.body.scrollLeft+1110;
		var y = document.body.scrollTop+30;
		win.setPosition(x, y);
	}
	window.onunload = function(){
		window.returnValue = "closed";
	}
	//窗口大小变动时重新加载床位排列
	window.onresize = function(){
		location.reload();
	}
});