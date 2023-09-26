/// 
//名称	DHCPEDayList.js
//功能	体检人员列表
//组件	
//对象	
//创建	2007.01.10
//最后修改时间	
//最后修改人
//完成

var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("Print");
	if (obj) { obj.onclick=Print_click; }
	
	iniForm();
}

function iniForm(){

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}


function Print_click() {
	//alert('Print_click');
	var obj,PEDate='';
	obj=document.getElementById("PEDate")
	if (obj) { PEDate=obj.value; }

	PrintPEDayList(PEDate); // DHCPEDayListImport.js
}

document.body.onload = BodyLoadHandler;