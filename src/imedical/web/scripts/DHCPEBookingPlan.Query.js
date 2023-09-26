/// DHCPEBookingPlan.Query.js
/// 

/// 创建时间		2006.03.16
/// 创建人		xuwm
/// 主要功能		编辑站点基本信息
/// 对应表		DHC_PE_Station
/// 最后修改时间	
/// 最后修改人	
/// 完成
function BodyLoadHandler() {
	
	// tree.js
	CreateTreeFromXMLObject(Tree,GList);
	
	SBookingDate=""
	SetDate("BookingDate","ldBookingDate");
	
	var obj;
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=BQuery_Click; }	
}

// 点击查询按钮
function BQuery_Click() {

	var obj;
	var iQType="G";
	
	var iBookingDate="", iBookingName="";

	//obj=document.getElementById("GADM");
	//if (obj && obj.checked) { iQType="G"; }
	
	//obj=document.getElementById("IADM");
	//if (obj && obj.checked) { iQType="I"; }
	//if (""==iQType) { return ; }
	
	// 按日期查找
	obj=document.getElementById("BookingDate");
	if (obj && ""!=obj.value) {
		iQType='G';
		iBookingDate=obj.value;
	}
	
	// 按预约人查找
	obj=document.getElementById("BookingName");
	if (obj && ""!=obj.value) {
		iQType='A';
		iBookingName=obj.value;
	}
	
	if ((''==iBookingDate)&&(''==iBookingName)) { return false; }
	
	BookingPlanQuery(iQType+"^"+iBookingDate+"^"+iBookingName);	

}
// 接口函数?查询预约的团体/团体组
function BookingPlanQuery(Condition) {

	var Params=Condition.split("^");
	var SType="";
	
	var SBookingDate='', SBookingName='';
	
	if (Params[0]) { SType=Params[0];} 	
	
	if (Params[1]) { SBookingDate=Params[1];} 
	
	if (Params[2]) { SBookingName=Params[2];} 
	
	// 按预约日期查找?先查找团体
	if ('G'==SType) {
		var Ins=document.getElementById('ClassBox');
    	if (Ins) {var encmeth=Ins.value} 
    	else {var encmeth=''};
    	var ret=cspRunServerMethod(encmeth,SBookingDate);
		GList.innerHTML=ret;
		CreateTreeFromXMLObject(Tree,GList);
	}
	
	// 按预约人查找?直接查找
	if ('A'==SType) {
		showDetail('0', SBookingDate, SBookingName, SType);
		GList.innerHTML='';
		CreateTreeFromXMLObject(Tree,GList);
	}
	
}

// 用户定义的点击树型结构时的执行函数
function TreeOnClick(entity) {
	var param=entity.URL;
	var iBookingDate='', iBookingName='';
 	
	obj=document.getElementById("BookingDate");
	if (obj && ""!=obj.value) { iBookingDate=obj.value; }
	
	obj=document.getElementById("BookingName");
	if (obj && ""!=obj.value) {iBookingName=obj.value; }
	if (param && ""!=param) {
		params=param.split("^");
		showDetail(params[0], iBookingDate, iBookingName, params[1]);
	}
}

function showDetail(GTId, SBookingDate, SBookingName, SearchType) {
	//alert("GTId:"+GTId+'  SBookingName:'+SBookingName+'  SearchType:'+SearchType);
	if (""==GTId) { return false; };
	if ((""==SBookingDate)&&(''==SBookingName)) { return false; };
	
	var URL="DHCPEBookingPlan.Result.csp?a=a"
			+"&SearchType="+SearchType
			+"&GTId="+GTId
			+"&BookingDate="+SBookingDate
			+"&BookingName="+SBookingName
			;
	
	OpenIFRAMEWindow("dataframe",URL);
}

document.body.onload = BodyLoadHandler;

/// chartbook.operator.js

// /////////////////////////////////////////////////////////

//在嵌套框架内 打开新的窗口
function OpenIFRAMEWindow(IfFrameName,lnk) {
	var df=document.getElementById(IfFrameName);
	if (df) { df.src=lnk; }
}

// 在嵌套框架内 刷新窗口
function ReloadIFRAMEWindow(lnk) {

	var df=document.getElementById("dataframe");
	if (df) { df.src=lnk; }

}

// //////////////////////////////////////////////////////////////////////////////
// 以下函数 参考 epr.chartbook.show.csp 
	var offsetWdt = document.body.offsetWidth - document.body.clientWidth;
	var offsetHgt = document.body.offsetHeight - document.body.clientHeight;
	var remainHgt;
	var remainWdt;
	
function setDataFrameSize() {

		var posLeft=0;
		
		remainHgt = document.body.offsetHeight -3 -offsetHgt;
		remainWdt = document.body.offsetWidth -3 -offsetWdt;
		
		//set data frame to length and width of remaining page, and widen to fit charttabs
		//var obj=document.getElementById("charttabs");
		//posLeft = obj.offsetWidth;
		//obj.style.width = posLeft;
	
		//var obj=document.getElementById("chartbook");
		//remainHgt -= obj.offsetTop;
		//remainWdt -= obj.offsetLeft;
	
		//posLeft += obj.offsetWidth;
		var obj=document.getElementById("data");
		obj.style.left = posLeft;
		remainWdt -= posLeft;
		
		resizeframe(remainWdt,remainHgt)

}

function resizeframe(remainWdt,remainHgt)
{
	try {
		document.frames["dataframe"].window.resizeTo(remainWdt,remainHgt);
	}
	catch (e) {
		setDataFrameSize();
	}
}

function SetWinsowSize() {
	var  s = "";
	var obj=document.getElementById("WinsowSize");
	var tobj=document.getElementById("TWinsowSize");
	s += "网页可见区域宽(clientWidth):"+ document.body.clientWidth;
	s += "\r\n网页可见区域宽(offsetWidth):"+ document.body.offsetWidth  +" (包括边线和滚动条的宽)";
	s += "\r\n网页正文全文宽(scrollWidth):"+ document.body.scrollWidth;
	s += "\r\n屏幕可用工作区宽度(availWidth):"+ window.screen.availWidth;
	s += "\r\n屏幕分辨率的宽(width):"+ window.screen.width;

	s += "\r\n\r\n网页可见区域高(clientHeight):"+ document.body.clientHeight;
	s += "\r\n网页可见区域高(offsetHeight):"+ document.body.offsetHeight +" (包括边线的宽)";
	s += "\r\n网页正文全文高(scrollHeight):"+ document.body.scrollHeight;
	s += "\r\n屏幕可用工作区高度(availHeight):"+ window.screen.availHeight;
	s += "\r\n屏幕分辨率的高(height):"+ window.screen.height;

	s += "\r\n网页被卷去的高(scrollTop):"+ document.body.scrollTop;
	s += "\r\n网页正文部分上(screenTop):"+ window.screenTop;

	s += "\r\n网页被卷去的左(scrollLeft):"+ document.body.scrollLeft;
	s += "\r\n网页正文部分左(screenLeft):"+ window.screenLeft;

	s += "\r\n你的屏幕设置是 "+ window.screen.colorDepth +" 位彩色";
	s += "\r\n你的屏幕设置 "+ window.screen.deviceXDPI +" 像素/英寸";
	
	s += "\r\n \r\n 控件 可见区域宽(clientWidth):"+ obj.clientWidth;
	s += "\r\n 控件 可见区域宽(offsetWidth):"+ obj.offsetWidth  +" (包括边线和滚动条的宽)";
	s += "\r\n 控件 正文全文宽(scrollWidth):"+ obj.scrollWidth;

	s += "\r\n 控件 可见区域高(clientHeight):"+ obj.clientHeight;
	s += "\r\n 控件 可见区域高(offsetHeight):"+ obj.offsetHeight +" (包括边线的宽)";
	s += "\r\n 控件 正文全文高(scrollHeight):"+ obj.scrollHeight;	
	
	s += "\r\n \r\n DIV 可见区域宽(clientWidth):"+ tobj.clientWidth;
	s += "\r\n DIV 可见区域宽(offsetWidth):"+ tobj.offsetWidth  +" (包括边线和滚动条的宽)";
	s += "\r\n DIV 正文全文宽(scrollWidth):"+ tobj.scrollWidth;

	s += "\r\n DIV 可见区域高(clientHeight):"+ tobj.clientHeight;
	s += "\r\n DIV 可见区域高(offsetHeight):"+ tobj.offsetHeight +" (包括边线的宽)";
	s += "\r\n DIV 正文全文高(scrollHeight):"+ tobj.scrollHeight;

	s += "\r\n DIV 正文空白(padding):"+ tobj.padding;
	s += "\r\n DIV 正文边框(border):"+ tobj.border;
	if (obj) { obj.value=s }
}
//window.onresize=SetWinsowSize;
//window.onresize = setDataFrameSize;
