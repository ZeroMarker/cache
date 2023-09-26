//DHCPEGroupChartgcom.js
var CurrentSel=0;
var targeURL="";		//目标页面
var URLParamName="";	//参数名称
var URLOtherParem="";

function BodyLoadHandler() {

	iniForm();
	
	}
//*********************************************************	

function GetCookieVal(cookieName) {
  var cookieString = document.cookie;
  var start = cookieString.indexOf(cookieName + '=');
  if (start == -1) // 找不到
    return null;
  start += cookieName.length + 1;
  var end = cookieString.indexOf(';', start);
  if (end == -1) return unescape(cookieString.substring(start));
  return unescape(cookieString.substring(start, end));
}
//*************************************************************** 
function iniForm() {
	var obj; 
	var ltargeURL="";
	var lURLParamName="";
	//获取目标URL  
	obj=document.getElementById('TargetURLBox');
	ltargeURL=obj.value;

	if (""!=ltargeURL) {		
		targeURL=ltargeURL;
		document.cookie="DHCPEGroupChatgcom"+"TargetURLBox"+"="+escape(targeURL);
	}
	else{
		targeURL=GetCookieVal("DHCPEGroupChatgcom"+"TargetURLBox");
	}

	//获取传递参数名	
	obj=document.getElementById('ParamNameBox');
	lURLParamName=obj.value;
	
	if (""!=lURLParamName) {		
		URLParamName=lURLParamName;
		document.cookie="DHCPEGroupChatgcom"+"URLParamName"+"="+escape(URLParamName);
		
	}
	else{
		URLParamName=GetCookieVal("DHCPEGroupChatgcom"+"URLParamName");

	}	
	
	ShowCurRecord(1);

}
function SearchOrderDetailCom_click() {
 
	var iRowId="",iDesc="";
	var objParam;
	var lnk="";
	iRowId=document.getElementById("RowId").value;
	
	iDesc=document.getElementById("Desc").value;

	objParam=document.getElementById('TargetURLBox');
	if (""!=objParam.value) { targeURL=objParam.value;  }

	objParam=document.getElementById('ParamNameBox');
	URLParamName=objParam.value;
	
	objParam=document.getElementById('OtherParamBox');
	URLOtherParem=objParam.value;	
	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
			+"&"+URLParamName+"="+iRowId;

	if (""!=iDesc) { lnk=lnk+"&"+URLParamName+"Name"+"="+iDesc; }
	if (""!=URLOtherParem) { lnk=lnk+URLOtherParem; }
   
	parent.frames[targeURL].location.href=lnk; 

}


//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('SSGRP_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;


	SelRowObj=document.getElementById('SSGRP_Desc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	obj.value=SelRowObj.innerText;

	//提取 选择记录函数中 选择显示部分 为了使在页面在载入时自动调取第一条记录 
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById('tDHCPEGroupChartgcom');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
//	if (selectrow==CurrentSel) {	    
//		CurrentSel=0
//		return;
//	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;



