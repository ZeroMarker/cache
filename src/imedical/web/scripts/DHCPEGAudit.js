///
///对应页面	团体财务审核
///
var CurrentSel=0
var SelectedRow=-1
var UserId=session['LOGON.USERID']

function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BAudit");
	if (obj) { obj.onclick=BAudit_Click; }
	
	obj=document.getElementById("BCancelAudit");
	if (obj) { obj.onclick=BCancelAudit_Click; }
	
	//查询按钮
	obj=document.getElementById("Find");
	if (obj) { obj.onclick=Find_Click; }
	
}
// *************************************************************
/// //////		根据指定的组合条件 显示符合条件团体的收费情况	////////
///web.DHCPE.DHCPEGAdm	bGADMQuery
function Find_Click() {
	var iGBIDesc="";				//单位名称
	var iAuditUserName="";			//审核人
	var iAuditDateBegin_Find="";	//登记起始日期
	var iAuditDateEnd=""			//登记截止日期
	var iSTatusIsCheched="";		//显示已审核的单位
	var iSTatusIsCharged="";		//显示已结算
	var obj;
	
  	obj=document.getElementById("GBI_Desc_Find");
    if (obj){ iGBIDesc=obj.value; }	
	
  	obj=document.getElementById("AuditUserDR_Name_Find");
    if (obj){ iAuditUserName=obj.value; }
    
  	obj=document.getElementById("AuditDateBegin_Find");
    if (obj){ iAuditDateBegin=obj.value; } 
       
  	obj=document.getElementById("AuditDateEnd_Find");
    if (obj){ iAuditDateEnd=obj.value; }    	
    
    
 	obj=document.getElementById("STatusIsCheched_Find");
	if (obj){
		if (obj.checked==true){ iSTatusIsCheched="1"; }
		else{ iSTatusIsCheched="0"; }
	}  
	
 	obj=document.getElementById("STatusIsCharged_Find");
	if (obj){
		if (obj.checked==true){ iSTatusIsCharged="1"; }
		else{ iSTatusIsCharged="0"; }
	} 	
	 
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGAudit"
			+"&GBIDesc="+iGBIDesc
			+"&AuditUser="+iAuditUserName
			+"&AuditDateBegin="+iAuditDateBegin
			+"&AuditDateEnd="+iAuditDateEnd
			+"&STatusIsCheched="+iSTatusIsCheched
			+"&STatusIsCharged="+iSTatusIsCharged
			;	
	
    location.href=lnk; 

}

//////////////////////       结果集处理        //////////////////////////
//通过审核
function BAudit_Click()
{	
	var GAdmRowId="";
	var encmeth="";
  	var obj=document.getElementById("RowId");
    if (obj){ GAdmRowId=obj.value; }
	
	if (""==GAdmRowId){
		alert("请选择需要审批的记录");
		return false
  	} 

	var AuditAmount="";
  	var obj=document.getElementById("AuditAmount");
    if (obj){ AuditAmount=obj.value; }
	if (""==AuditAmount){
		alert("请输入审批金额");
		return false;
  	} 
  	else{ 
    	var Ins=document.getElementById('AuditStutasBox');    	
        if (Ins) { encmeth=Ins.value; } 
        else { encmeth=''; };
        var flag=cspRunServerMethod(encmeth,'','',GAdmRowId,"CHECKED",UserId,AuditAmount);
        
        if ('0'==flag) {}
        else{
	        alert("Update error.ErrNo="+flag)
     	}
     	
     	location.reload();
     }
}
//取消审核
function BCancelAudit_Click()
{	
	var AuditAmount="";
	
  	var obj=document.getElementById("AuditAmount");
    if (obj){ AuditAmount=obj.value; }
	
	if (""==AuditAmount){ AuditAmount=0; }
	
	var GAdmRowId="";
  	var obj=document.getElementById("RowId");
    if (obj){ GAdmRowId=obj.value; }
    
	if (""==GAdmRowId){
		alert("请选择需要取消审批的记录");
		return false;
  	} 
	else{
		var Ins=document.getElementById('AuditStutasBox');
    	if (Ins) {var encmeth=Ins.value} 
    	else {var encmeth=''};
    	//alert(GAdmRowId+"^"+UserId+"^"+AuditAmount);
        var flag=cspRunServerMethod(encmeth,'','',GAdmRowId,"REGISTERED",UserId,AuditAmount)
        if ('0'==flag) {}
        else{
	    	alert("Update error.ErrNo="+flag)
     	}
     	
     	location.reload();
	}
}
// ----------------------------------------------------------------
//查询当前单位的人员的检验项目 
//触发条件 点击菜单 团体项目查询
function SrearchIAdmOrder() {
	
	var lnk;
		
	var GAdmRowId="";
  	var obj=document.getElementById("RowId");
    if (obj){ GAdmRowId=obj.value; }
	
	if (""==GAdmRowId){
		alert("请选择需要查询的团体");
		return false
  	} 
	
	lnk="DHCPEGRegQuery.csp"
		+"?"+"ParRef="+GAdmRowId;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';
	window.open(lnk,"_blank",nwin)

}
///////////////////////////////////////////////////////////////////////
//获取单位信息 单位名称
function SearchDHCPEGBaseInfo(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		//alert("aiList="+aiList);
		var obj;
		obj=document.getElementById("GBI_Desc_Find");
		obj.value=aiList[0];
		
		//obj=document.getElementById("GBI_RowId_Find");
		//obj.value=aiList[2];
	}	
}
//获取单位信息 单位名称
function SearchSSUSR(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		
		obj=document.getElementById("AuditUserDR_Name_Find");
		obj.value=aiList[0];
		
		//obj=document.getElementById("AuditUserDR_Find");
		//obj.value=aiList[1];
	}	
}
////////////////////////////////////////////////////////////////////////
function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TRowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=trim(SelRowObj.value);
	
	SelRowObj=document.getElementById('TGFactAmount'+'z'+selectrow);
	obj=document.getElementById("AuditAmount");
	obj.value=trim(SelRowObj.innerText);
	
	SelRowObj=document.getElementById('TGStatus'+'z'+selectrow);
	if(SelRowObj.innerText=="CHECKED"){
		ButtonDisabled("BAudit");
		//ButtonEnabled("BCancelAudit");
		obj=document.getElementById("BCancelAudit");
		obj.disabled=false;
		obj.onclick=BCancelAudit_Click;
		TextboxDisabled("AuditAmount");
	}
	if(SelRowObj.innerText=="REGISTERED"){
		//ButtonEnabled("BAudit");
		obj=document.getElementById("BAudit");
		obj.disabled=false;
		obj.onclick=BAudit_Click;
		ButtonDisabled("BCancelAudit");
		TextboxEnabled("AuditAmount");
	}

	if((SelRowObj.innerText!="REGISTERED")&&(SelRowObj.innerText!="CHECKED"))
	{
		ButtonDisabled("BAudit");
		ButtonDisabled("BCancelAudit");
		TextboxDisabled("AuditAmount");
	}
	
}

function SelectRowHandler(){  

	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEGAudit');
	
	if (objtbl){ var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	var GAdmRowId,GFactAmount;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);
		SelectedRow = selectrow;
	}

}

document.body.onload = BodyLoadHandler;