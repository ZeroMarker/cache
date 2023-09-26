var PageLogicObj={
	m_AdmReasonListTabDataGrid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	RegReturnListTabDataGridLoad();
	$("#InsuranceNo").focus();
})
function InitEvent(){
	$("#Confirm").click(ConfirmClickHandle);
	$("#Quit").click(function(){window.parent.destroyDialog("ChgAdmReason")});
}
function Init(){
	PageLogicObj.m_AdmReasonListTabDataGrid=InitAdmReasonListTabDataGrid();
}
function InitAdmReasonListTabDataGrid(){
	var Columns=[[ 
		{field:'SSRowId',hidden:true,title:''},
		{field:'SSDesc',title:'费别',width:590}
    ]]
	var AdmReasonListTabDataGrid=$("#AdmReasonListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : false,  
		rownumbers : true,  
		idField:'SSRowId',
		columns :Columns,
		onSelect:function(index, row){
			if (row["SSDesc"].indexOf('本院')>=0){
				$("#EmployeeNo,#cEmployeeNo").show();
			}else{
				$("#EmployeeNo,#cEmployeeNo").hide();
			}
		}
	});
	return AdmReasonListTabDataGrid;
}
function RegReturnListTabDataGridLoad(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.PACADM",
	    QueryName : "GetCTSocialstatusList",
	    HospId:session['LOGON.HOSPID'],
	    rows:99999
	},function(GridData){
		PageLogicObj.m_AdmReasonListTabDataGrid.datagrid('loadData',GridData);
	}); 
}
function PageHandle(){
	$.cm({
	    ClassName : "web.DHCOPChgAdmreason",
	    MethodName : "FindPatInfo",
	    dataType:"text",
	    FID:ServerObj.RegNo
	},function(retcode){
		var Subretcode=retcode.split(",");
	  	var PatBisicInfo=Subretcode[0]+"  "+Subretcode[1];
	  	$("#PatInfo").val(PatBisicInfo);
	  	$("#InsuranceNo").val(Subretcode[2])
	});
	var row=window.parent.PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	$.cm({
	    ClassName : "web.DHCOPChgAdmreason",
	    MethodName : "FindAdmInfo", 
	    dataType:"text",
	    AdmId:ServerObj.EpisodeID
	},function(AdmInformStr){
		AdmInformStr=row["Dept"] + " " + row["Doctor"]+"   "+AdmInformStr;
		$("#AdmInfo").val(AdmInformStr);
	});
}
function ConfirmClickHandle(){
	var row=PageLogicObj.m_AdmReasonListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("提示","请选择费别!");
		return false;
	}
	var PatTypeRowid=row["SSRowId"];
	var PatOtherInfoOld=$.cm({
	    ClassName : "web.DHCOPChgAdmreason",
	    MethodName : "GetPatOtherInfo", 
	    dataType:"text",
	    PapmiNo:ServerObj.RegNo
	},false);
    var EmployeeNoFlag=CheckEmployeeNo();
    if (!EmployeeNoFlag) return false;
	var YBFlag=checkPatYBCode();
	if (!YBFlag) return false;
	var Rtn=CheckMedNo();
    if (!Rtn){return false;} 
	//修改病人基本类型
	var GetDetail=document.getElementById('Commit');
	var ret=$.cm({
	    ClassName : "web.DHCOPChgAdmreason",
	    MethodName : "SetPattype", 
	    dataType:"text",
	    itmjs:"",itmjsex:"",
	    PatTypeRowid:PatTypeRowid, AdmRowid:ServerObj.EpisodeID,InsuranceNo:$("#InsuranceNo").val()
	},false);
	if (ret==0){
		$.messager.alert("提示","更新成功!","info",function(){
			//病人基本信息-病人类型修改日志-------修改后的病人基本类型
			var PatOtherInfoNew=$.cm({
			    ClassName : "web.DHCOPChgAdmreason",
			    MethodName : "GetPatOtherInfo", 
			    dataType:"text",
			    PapmiNo:ServerObj.RegNo
			},false);
			var UPPuserDr=session['LOGON.USERID'];
			var parrow=window.parent.PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
			var PatTypeLog=$.cm({
			    ClassName : "web.DHCOPChgAdmreason",
			    MethodName : "PatInformLog", 
			    dataType:"text",
			    CardNo:$("#CardNo",parent.document).val(), PatName:parrow["PatName"], PatOtherInfoOld:PatOtherInfoOld, PatOtherInfoNew:PatOtherInfoNew, 
			    UPPuserDr:UPPuserDr, PatientID:ServerObj.PatientID
			},false);
			if (PatTypeLog!=0){
				$.messager.alert("提示","修改病人类型日志失败,请联系管理员!","info",function(){
					window.parent.destroyDialog("ChgAdmReason");
				});
				return false;
			}
			window.parent.destroyDialog("ChgAdmReason");
		});
	}else{
		$.messager.alert("提示","更新失败!");
		return false;
	}
}
function CheckEmployeeNo()
{
	var row=PageLogicObj.m_AdmReasonListTabDataGrid.datagrid("getSelected");
	var AdmReasonDesc=row["SSDesc"]
  	if (AdmReasonDesc.indexOf('本院')>=0){
	  	var EmployeeNo=$("#EmployeeNo").val();
			if (EmployeeNo==""){
				$.messager.alert("提示","本院职工工号不能为空","info",function(){
					$('#EmployeeNo').focus();
				});
				return false;
			}
			var curPAPMIRowID=$.cm({
			    ClassName : "web.DHCBL.CARDIF.ICardPaPatMasInfo",
			    MethodName : "GetPAPMIRowIDByEmployeeNo", 
			    dataType:"text",
			    EmployeeNo:EmployeeNo
			},false);
			var name=curPAPMIRowID.split("^")[1];
			var UserName=curPAPMIRowID.split("^")[2];
			curPAPMIRowID=curPAPMIRowID.split("^")[0];
			if (curPAPMIRowID=="0"){
				$.messager.alert("提示","工号不正确,请核实工号!","info",function(){
					$('#EmployeeNo').focus();
				});
				return false;
			}
			if ((ServerObj.PatientID!=curPAPMIRowID)&&(curPAPMIRowID!="")){
				$.messager.alert("提示","此工号已经被'"+name+"'所用,请首先核实工号","info",function(){
					$('#EmployeeNo').focus();
				});
				return false;
			}
			var GetPatInfo=$("#PatInfo").val();
		    var Name=GetPatInfo.split("   ")[1]
			if (UserName!=Name){
				$.messager.alert("提示","此工号对应姓名为'"+UserName+"'和所录入姓名不一致","info",function(){
					$('#EmployeeNo').focus();
				});
				return false;
			}
	}
	return true;
}
///判断是否需要填写医保号
function checkPatYBCode()
{
	var row=PageLogicObj.m_AdmReasonListTabDataGrid.datagrid("getSelected");
	var myPatType=row["SSDesc"];
	var Rowid=row["SSRowId"];
	var PatYBCode=$("#InsuranceNo").val();
	var rtn=$.cm({
	    ClassName : "web.DHCBL.CARD.UCardRefInfo",
	    MethodName : "GetInsurFlag", 
	    dataType:"text",
	    PatypeDr:Rowid
	},false);
	if ((rtn==0)&&(PatYBCode!="")) {
		$.messager.alert("提示","非医保病人，医保卡号不可填","info",function(){
			$("#InsuranceNo").focus();
		})
		return false;
	}
	if((rtn!=0)&&(PatYBCode=="")) {
		$.messager.alert("提示","医保病人，请填写正确的医保卡号","info",function(){
			$("#InsuranceNo").focus();
		})
		return false;
	}
	return true;
}
function CheckMedNo()
{
	var InsuranceNo=$("#InsuranceNo").val();
	if ((InsuranceNo!="")&&(InsuranceNo!="99999999999S")&&(InsuranceNo!="99999999999s")) {
		var rtn=$.cm({
		    ClassName : "web.DHCBL.Patient.DHCPatient",
		    MethodName : "PatUniInfoQuery", 
		    dataType:"text",
		    PatientDr:ServerObj.PatientID,
		    Type:"InsuNo",
		    NoStr:InsuranceNo
		},false);
		if (rtn>0){
			$.messager.alert("提示","医保手册号重复");
			return false;
		}
	}
	return true
}