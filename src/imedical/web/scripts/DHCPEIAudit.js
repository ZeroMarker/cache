/// /// 对应组件 个人财务审核 
var CurrentSel=0
var SelectedRow=-1
var UserId=session['LOGON.USERID']
function BodyLoadHandler()
{	
	var obj;
	
	//通过审核
	obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;

	//取消审核
	obj=document.getElementById("BCancelAudit");
	if (obj) obj.onclick=BCancelAudit_Click;
	
	//查找
	obj=document.getElementById("Find");
	if (obj) obj.onclick=Find_Click;	
	
}

/////////////////////////////////////////////////////////////////
///////		根据组合条件 查询团体的收费情况					/////////
//	web.DHCPE.DHCPEIAdm		IAdm
function Find_Click() {

	var iPAPMINo="";				//登记号
	var iIADMName="";				//姓名
	var iAuditUserDRName=""; 		//审核人姓名
	var iAuditDateBegin_Find="";	//登记起始日期
	var iAuditDateEnd="";			//登记截止日期
	var iSTatusIsCheched="";		//显示已审核的单位
	var iSTatusIsCharged="";		//显示已结算
	var obj;
	
  	obj=document.getElementById("PAPMINo");
    if (obj){ iPAPMINo=obj.value; }	
    
   	obj=document.getElementById("Name");
    if (obj){ iIADMName=obj.value; }	   
	
  	obj=document.getElementById("AuditUserDR_Name_Find");
    if (obj){ iAuditUserDRName=obj.value; }
    
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
	 
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAudit"
			+"&PAPMINo="+iPAPMINo					//登记号
			+"&IADMName="+iIADMName					//姓名
			+"&AuditDateBegin="+iAuditDateBegin		//登记起始日期
			+"&AuditDateEnd="+iAuditDateEnd			//登记截止日期
			+"&STatusIsCheched="+iSTatusIsCheched	//显示已审核的单位
			+"&STatusIsCharged="+iSTatusIsCharged	//显示已结算
			;	
			
    location.href=lnk; 
	
}

// *************************************************************
// 患者列表
function SearchPAADM(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		obj=document.getElementById("Name");
		obj.value=aiList[0];
		obj=document.getElementById("RowId");
		obj.value=aiList[2];
	}		
}

//审核人列表
function SearchSSUSR(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		obj=document.getElementById("AuditUserDR_Name_Find");
		obj.value=aiList[0];
		obj=document.getElementById("AuditUserDR_Find");
		obj.value=aiList[1];
	}	
}

// ///////////////////////////////////////////////////////////////////////////////
//通过审核 
function BAudit_Click()
{	
	var IAdmRowId=""
  	var obj=document.getElementById("RowId");
    if (obj){
		IAdmRowId=obj.value
	}
	if (""==IAdmRowId){
		alert("请选择需要审批的记录");
		return false
  	} 
  	
  	var AuditAmount=""
  	var obj=document.getElementById("AuditAmount");
    if (obj){
		AuditAmount=obj.value
	}
	if (""==AuditAmount){
		alert("请输入审批金额");
		return false
  	} 
  	else{ 
    	var Ins=document.getElementById('AuditStatusBox');
        if (Ins) {var encmeth=Ins.value} 
         else {var encmeth=''};
         var flag=cspRunServerMethod(encmeth,'','',IAdmRowId,"CHECKED",AuditAmount,UserId)
         if ('0'==flag) {}
         else{
	        alert("Update error.ErrNo="+flag)
     	}
     location.reload();
     }
}

// 
//取消审核 
function BCancelAudit_Click()
{	
	var IAdmRowId=""
  	var obj=document.getElementById("RowId");
    if (obj){
		IAdmRowId=obj.value
	}
	
	if (""==IAdmRowId){
		alert("请选择需要审批的记录");
		return false
  	} 
  	
  	var AuditAmount=""
  	var obj=document.getElementById("AuditAmount");
    if (obj){
		AuditAmount=obj.value
	}
	
   	var Ins=document.getElementById('AuditStatusBox');
	if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    var flag=cspRunServerMethod(encmeth,'','',IAdmRowId,"REGISTERED","",UserId)
    if ('0'==flag) {}
    else{
		alert("Update error.ErrNo="+flag)
    }
    
    location.reload();
}

// **************************************************************
//查询当前人员的检验项目 
//触发条件 点击菜单 个人项目查询
function SearchIAdmOrderList() {

	var lnk;
	var iEpisodeID="";
	
	obj=document.getElementById("PAADM");
	iEpisodeID=obj.value;	
	if (""==iEpisodeID) {
		alert("请先选择一个患者");
		return false;
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmOrderList"
		+"&"+"EpisodeID="+iEpisodeID;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	window.open(lnk,"_blank",nwin)
		 
}

// **************************************************************
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TRowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;

	SelRowObj=document.getElementById('TPAADM'+'z'+selectrow);
	obj=document.getElementById("PAADM");
	obj.value=SelRowObj.innerText;	
	
	SelRowObj=document.getElementById('TFactAmount'+'z'+selectrow);
	obj=document.getElementById("AuditAmount");
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('TStatus'+'z'+selectrow);
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
	
	var objtbl=document.getElementById('tDHCPEIAudit');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);		
		SelectedRow = selectrow;
	}
	else { SelectedRow=0; }
	
}

document.body.onload = BodyLoadHandler;