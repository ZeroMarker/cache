/*
* Creator   : wk 
* CreatDate : 2018-11-01
* Desc      : 综合查询主页维护
*/

 var BODY_HEIGHT = getViewportOffset().y;   // 获取屏幕高度
 var BODY_WIDTH = getViewportOffset().x;   // 获取屏幕宽度

 /*--最近列表数组--*/
 var recentArrList = [];
 /*--记录已经打开的弹窗--*/
 var productWindowOpen = {};
 

/*--响应点击产品按钮事件--*/
function showThisTable(obj){
	var ID = obj.id;
	var title = productTabObj[ID].title;
	var url = productTabObj[ID].url;
	
	openNewWindow(url,ID,title);
	
	/*--记录用户点击产品更新常用、最近产品列表--*/
	$m({
		ClassName:'web.DHCWL.V1.HomeTab.ProFunction',
		MethodName:'AddProRecord',
		proID:ID
	},function(text){
		loadOftenProFun();
	})
	
	if(($("#recentProduct" ).children( "#button_" + ID).length) == 0){
		if ($("#recentProduct" ).children().length == 5){
			var removeID = $("#recentProduct").children()[4].id;
			$("#recentProduct" ).children( "#" + removeID).remove();
		}
	}else{
		$("#recentProduct" ).children( "#button_" + ID).remove();
	}
	$("#recentProduct").prepend("<div id='button_" + ID + "'class='showButtonList' onclick='clickButton(this)'>" + title + "</div>");
}

/*--响应点击常用/最近产品列表事件--*/
function clickButton(obj){
	var ID = obj.id;
	var newID = ID.split("_")[1];
	var title = productTabObj[newID].title;
	var url = productTabObj[newID].url;
	openNewWindow(url,newID,title);
}

/*--根据用户点击打开相应的窗口--*/
function openNewWindow(url,ID,title){
	var realUrl = "dhcwlredirect.csp?url=" + url;
	if (productWindowOpen.hasOwnProperty(ID)){
		obj = productWindowOpen[ID];
		if (!obj.closed){
			obj.focus();
			return;
		}
	}
	var obj = window.open(realUrl,title,' left=20,top=20,width='+ (screen.availWidth - 60) +',height='+ (screen.availHeight-90) +',scrollbars,resizable=no,toolbar=no,depended=yes, menubar=no,location=no, status=no');
	productWindowOpen[ID] = obj;
}


/*--界面刷新时加载常用产品列表--*/
function loadOftenProFun(){
	$("#ofterProduct").empty();
	$cm({
		ClassName:'web.DHCWL.V1.HomeTab.ProFunction',
		QueryName:'GetOftenPro'
	},function(jsonStr){
		var obj = jsonStr.rows;
		var len = jsonStr.rows.length;
		var proID = "",title="";
		for (var i = 0;i < len;i++){
			proID = obj[i].proID;
			title = productTabObj[proID].title;
			$("#ofterProduct").append("<div id='OfterButton_" + proID + "'class='showButtonList' onclick='clickButton(this)'>" + title + "</div>");
		}
	})
}
/*--界面刷新时加载最近产品列表--*/
function loadRecentProFun(){
	$cm({
		ClassName:'web.DHCWL.V1.HomeTab.ProFunction',
		QueryName:'GetRecentPro'
	},function(jsonStr){
		var obj = jsonStr.rows;
		var len = jsonStr.rows.length;
		var proID = "",title="";
		for (var i = 0;i < len;i++){
			proID = obj[i].proID;
			title = productTabObj[proID].title;
			$("#recentProduct").append("<div id='button_" + proID + "'class='showButtonList' onclick='clickButton(this)'>" + title + "</div>");
		}
	})
}
loadOftenProFun();
loadRecentProFun();


/*--设置界面组件的尺寸--*/
$('.my-interface div.productPanel').panel({
	width: (BODY_WIDTH-230) 
})

$('.my-interface #selectModule').panel({
	height:(BODY_HEIGHT)
})

$('.my-interface #recentProduct').panel({
	height:((BODY_HEIGHT - 5) / 2)
})

$('.my-interface #ofterProduct').panel({
	height:((BODY_HEIGHT - 5) / 2)
})		

 
/*--窗口刷新或者关闭时关闭弹出框--*/ 
window.onbeforeunload = function(){
	closeObj();
}
function closeNews(){
	closeObj();
	
}
function closeObj(){
	var obj = "";
	for (var prop in productWindowOpen){
		obj = productWindowOpen[prop];
		if (!obj.closed){
			obj.close();
		}
	}
	productWindowOpen = {};
}