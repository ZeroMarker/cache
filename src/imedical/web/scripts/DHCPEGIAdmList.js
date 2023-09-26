///Create by Malihua2006-03-25
///脚本名称 个人项目查询
///对应页面 个人项目查询
var CurrentSel=0;

var targeURL="";		//目标页面
var URLParamName="";	//参数名称

var UserId=session['LOGON.USERID']

function BodyLoadHandler() {

	iniForm();
	
	}

function iniForm() {
	var SelRowObj;
	var obj;

	//获取本页父站点
	//SelRowObj=document.getElementById('ParRefBox');	
	//obj=document.getElementById("ParRef");
	//obj.value=SelRowObj.value;

	ShowCurRecord(1);

}


function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('TPAADM'+'z'+selectrow);
	obj=document.getElementById("EpisodeID");
	obj.value=SelRowObj.innerText;

	//提取 选择记录函数中 选择显示部分 为了使在页面在载入时自动调取第一条记录 
	SearchOrderDetailCom_click();
}

function SearchOrderDetailCom_click() {
	    
	var iRowId="";
	var objParam;
	
	iRowId=document.getElementById("EpisodeID").value;
	objParam=document.getElementById('TargetURLBox');
	targeURL=objParam.value;  
	//alert(targeURL);

	objParam=document.getElementById('ParamNameBox');
	URLParamName=objParam.value;
	//alert(URLParamName);
	
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL+"&"+URLParamName+"="+iRowId;

	parent.frames[targeURL].location.href=lnk; 

}

		
function SelectRowHandler() {


	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById('tDHCPEGIAdmList');
	
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

