///filename: DHCPEGRegister.JS
///脚本名称 团体登记
///对应页面 团体登记

var CurrentSel=0;
var SelectedRow= "-1";

var UserId=session['LOGON.USERID'];
var LocId=session['LOGON.CTLOCID'];

//页面初始化
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BGetData");
	if (obj) obj.onclick=BGetData_Click;
}

//单位项目信息获取 
function BGetData_Click()
{	
	
	var	CrmGrpId=GetCtlValueById("RowId");
	
	//var myObject=document.getElementById("RowId");
	//if (myObject){
	//	CrmGrpId=myObject.value;
	//	}
		
	var	CrmGRegId=GetCtlValueById("RegId");
	//var myObject=document.getElementById("RegId");
	//if (myObject){
	//	CrmGRegId=myObject.value;
	//	}
	
	//alert("GAdmCrmId:"+GAdmCrmId+"GRegId:"+GRegId+"UserId:"+UserId+"LocId:"+LocId);
	if (""==CrmGrpId){
		alert(t['NoSelected']);
		return false
  	} 

    //从CRM中取数据
	var encmeth=GetCtlValueById('GetDataBox',1);   
	//alert(encmeth + "\n" + CrmGrpId+ "\n"+CrmGRegId+"\n"+UserId+"\n"+LocId);     
	var flag=cspRunServerMethod(encmeth,CrmGrpId,CrmGRegId,UserId,LocId)///////////
	//alert("0724mlh");
    if (flag!='') {
        alert(t['FailsTrans']+"  error="+flag);
        return false
    }
    
    //设置到达状态
	encmeth=GetCtlValueById('GAdmArrived',1);        
    var flag=cspRunServerMethod(encmeth,CrmGRegId)
    if (flag!='0') {
        alert(t['FailsArrived']+"  error="+flag);
        return false
    }

    alert(t['Completed']);
    location.reload();

     
}

//查询当前单位的人员的检验项目 
//触发条件 点击菜单?获取当前团体项目?
function SearchIAdmOrder() {
	
	var lnk;
	var GAdmRowId="";
	var iStatus="";
	
	obj=document.getElementById("RegId");
	if (obj) { GAdmRowId=obj.value; }
	if (""==GAdmRowId) {
		alert('请先选择一个团体,再查询');
		return false;
	}
	/*
	else
	{
		
	
		obj=document.getElementById("Status");
		if (obj) { iStatus=obj.value; }
		if ("PREREG"==iStatus) {
			alert('此单位处于预登记状态,请先获取,再查询');
			return false;
		}	
			
		var Ins=document.getElementById('ADMIdBox');
		if (Ins) {var encmeth=Ins.value} 
		else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,"","",GAdmRowId)
		if (''!=flag) {
			GAdmRowId=flag;
		}
		else{
			alert("未在系统中找到对应的团体");
			return false;
		}
	
	}
	*/
	lnk="DHCPEGTeamRegQuery.csp"
		+"?"+"ParRef="+GAdmRowId	
	//	+"&"+"sType"+"G"		//查询类型按?团体查询
		+"&"+"sType="+"GT"		//查询类型按团体查询
		;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';
	
	window.open(lnk,"_blank",nwin)

}
// ----------------------------------------------------------------
//显示当前单位的全体人员的报告状态
//触发条件 点击菜单 团体报告查询
function SearchGReport() {
	
	var lnk;
	var GAdmRowId="";
	var iStatus="";
	
	obj=document.getElementById("RegId");
	if (obj) { GAdmRowId=obj.value; }
	if (""==GAdmRowId) {
		alert('请先选择一个团体,再查询');
		return false;
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGReport"
		+"&"+"aGADMDR="+GAdmRowId	
		+"&"+"aIADMDesc="+""		
		+"&"+"aSTatus="+""	
		;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	window.open(lnk,"_blank",nwin)

}
// ******************************************************
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
 }

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TGroupId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (obj) { obj.value=SelRowObj.innerText; }	

	SelRowObj=document.getElementById('TGroupRegId'+'z'+selectrow);
	obj=document.getElementById("RegId");
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('TStatus'+'z'+selectrow);
	obj=document.getElementById("Status");
	if (obj) { obj.value=SelRowObj.innerText; }

}
function SelectRowHandler() {  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEGRegister');
	
	if (objtbl){
		var rows=objtbl.rows.length;
	}

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	
	if (!selectrow) return;

	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);
		SelectedRow = selectrow;
	}
}

document.body.onload = BodyLoadHandler;