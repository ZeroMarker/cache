
//名称 DHCPEPreIADM.GTEdit.hisui.js
//功能 团体人员预约信息修改
//创建 2021.01.04
//创建人 xy
$(function(){

	//  允许加项 
	$('#AddOrdItem').checkbox({
		onCheckChange:function(e,value){
			AddOrdItem_click(value);
			}
			
	});

	//  加项金额限制 
	$('#AddOrdItemLimit').checkbox({
		onCheckChange:function(e,value){
			AddOrdItemLimit_click(value);
		}
			
	});
	
 InitCombobox();
 
 iniForm();
 
 //更新
$("#BUpdate").click(function() {	
	Update_click();		
  });
 	
	
})


function iniForm(){
	
	 $("#PAPMINo").val(RegNo);
	 $("#Name").val(Name);
	
	
	 var ret=tkMakeServerCall("web.DHCPE.PreIADM","DocListBroker","","",ID+"^");
	 var Data=ret.split(";");
	//登记信息
	var PreIADMData=Data[1];
	if (""!=PreIADMData) { SetPreIADM(PreIADMData); }
}

//登记信息
function SetPreIADM(value){
  	//alert(value)
	var Data=value.split("^");
	var iLLoop=0;
		
	var iRowId=Data[iLLoop];
	if ('0'==iRowId) { return false; }
	
	$("#RowId").val(iRowId);
	iLLoop=iLLoop+1;
	
	$("#PIBI_RowId").val(Data[iLLoop]);
	iLLoop=iLLoop+1;
		

	iLLoop=iLLoop+1;
	
	$("#PGADM_DR").val(Data[iLLoop]);
	
	if (Data[iLLoop]!="")
	{
		var GADMInfo=tkMakeServerCall("web.DHCPE.PreIADM","GetGADMInfo",Data[iLLoop])
		GADMInfo=GADMInfo.split("^");
		
		$("#GStartDate").datebox('setValue',GADMInfo[0]);
		$("#GEndDate").datebox('setValue',GADMInfo[1]);
		$("#GDelayDate").datebox('setValue',GADMInfo[2]);
	
	}
	iLLoop=iLLoop+1;
	
	iLLoop=iLLoop+1;	

	//对应团体组ADM PIADM_PGTeam_DR 3
	$("#PGTeam_DR").val(Data[iLLoop]);
	iLLoop=iLLoop+1;
	
	// 对应团体组 3.1
	//obj=document.getElementById("PGTeam_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//预约体检日期开始 
	$('#PEDateBegin').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// 预约体检日期结束
   $('#PEDateEnd').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//预约体检时间 PIADM_PETime 5
	setValueById("PETime",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// 预约接待人员 PIADM_PEDeskClerk_DR 6
	//obj=document.getElementById("PEDeskClerk_DR");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约接待人员 6.1
	$("#PEDeskClerkDRName").combogrid('grid').datagrid('reload',{'q':Data[iLLoop]});
	setValueById("PEDeskClerkDRName",Data[iLLoop-1])

	//$("#PEDeskClerkDRName").combogrid('setValue',Data[iLLoop]);
	//$("#PEDeskClerkDRNameDR").val(Data[iLLoop])
	iLLoop=iLLoop+1;
	

	// PIADM_Status 7
	//obj=document.getElementById("Status");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	

	//视同收费 PIADM_AsCharged 8
	
	if ("Y"==Data[iLLoop]) {$("#AsCharged").checkbox('setValue',true);}
	else { $("#AsCharged").checkbox('setValue',false);  }
	
	iLLoop=iLLoop+1;
	var fillData
	fillData=Data[iLLoop];
	var strLine=""
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	SetAddItem(strLine);
	
	
	// 个人报告发送 
	$("#IReportSend").combobox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// 结算方式	
	$("#DisChargedMode").combobox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//  PIADM_VIP 
	$("#VIPLevel").combobox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//  PIADM_DelayDate 
	 $('#DelayDate').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	
	
	//  PIADM_Remark 
	//obj=document.getElementById("Remark");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	// 业务员 
    //obj=document.getElementById("Sales_DR");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	
	// 业务员 6.1
	//obj=document.getElementById("Sales");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//s val=%request.Get("ID") if val'="" s val=$G(^DHCPEDataEx("DHCPEPreIADM","Position",val))
	
	//类型
	$("#Type").val(Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//取报告日期
	$('#GetReportDate').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//取报告时间
	setValueById("GetReportTime",Data[iLLoop]);
	iLLoop=iLLoop+4;
	
	//费用类型
	$("#PatFeeTypeName").combobox('setValue',Data[iLLoop])
	
	var iPosition=tkMakeServerCall("web.DHCPE.PreCommon","GetPosition","PreADM",iRowId);
	$("#Position").val(iPosition);
	
	
}

//  允许加项
function AddOrdItem_click(value) {
	
	var iAddOrdItem=$("#AddOrdItem").checkbox('getValue');
	
	if(iAddOrdItem){
			
		$("#AddOrdItemLimit").checkbox('setValue',true);
		$("#AddOrdItemLimit").checkbox("enable");
		$("#AddOrdItemAmount").attr('disabled',false);
		
	}else{
		$("#AddOrdItemLimit").checkbox('setValue',false);
		$("#AddOrdItemLimit").checkbox("disable");
		$("#AddOrdItemAmount").val("");
		$("#AddOrdItemAmount").attr('disabled',true);
	}
	

	

}
// 加项金额限制 
function AddOrdItemLimit_click(value) {
	
	var iAddOrdItemLimit=$("#AddOrdItemLimit").checkbox('getValue');
	if(iAddOrdItemLimit){
		$("#AddOrdItemLimit").checkbox('setValue',true);
		$("#AddOrdItemAmount").attr('disabled',false);
		$("#AddOrdItemAmount").val("");
		
	}else{
		$("#AddOrdItemLimit").checkbox('setValue',false);
		$("#AddOrdItemAmount").val("");
		$("#AddOrdItemAmount").attr('disabled',true);
	}
	
	
}
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	//	公费加项
	
	if ("Y"==Data[iLLoop]){
		
		$("#AddOrdItem").checkbox('setValue',true);
		$("#AddOrdItemLimit").checkbox("enable");
	}else{
		$("#AddOrdItem").checkbox('setValue',false);
		$("#AddOrdItemLimit").checkbox("disable");
	}
	
 
	iLLoop=iLLoop+1;
	var iAddOrdItem=$("#AddOrdItem").checkbox('getValue');	
	if(iAddOrdItem){
		if ("Y"==Data[iLLoop]){
			//加项金额限制
			$("#AddOrdItemLimit").checkbox('setValue',true);
		}else{
			$("#AddOrdItemLimit").checkbox('setValue',false);
		}
	}else{
		$("#AddOrdItemLimit").checkbox('setValue',false);
	}


	iLLoop=iLLoop+1;	
	
	//	公费加项金额	
	var iAddOrdItemLimit=$("#AddOrdItemLimit").checkbox('getValue');
	if(iAddOrdItemLimit){
		$("#AddOrdItemAmount").val(Data[iLLoop]);
		$("#AddOrdItemAmount").attr('disabled',false);
	}else{
		$("#AddOrdItemAmount").val("");
		$("#AddOrdItemAmount").attr('disabled',true);
	}

	iLLoop=iLLoop+1;	
	
	//	允许加药
	if ("Y"==Data[iLLoop]){
		$("#AddPhcItem").checkbox('setValue',true);
	}else{
		$("#AddPhcItem").checkbox('setValue',false);
	}
	
	
}


function Update_click() {
	
	var DataStr="",OneData="",iRowId
	
	var OneData=$("#RowId").val();
	iRowId=OneData
	DataStr=OneData
	
	OneData=""
	//个人基本信息 
	var OneData=$("#PIBI_RowId").val();
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	var OneData=$("#PGADM_DR").val();
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	var OneData=$("#PGTeam_DR").val();
	var PGTeam=OneData;
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//预约体检日期开始 
	 OneData=$("#PEDateBegin").datebox('getValue')
	if (""==OneData) {
		$.messager.alert("提示","体检起始日期不能为空","info");
		websys_setfocus('PEDateBegin');
		return false;
	}
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 预约体检日期结束 
	OneData=$('#PEDateEnd').datebox('getValue')
	if (""==OneData) {
		$.messager.alert("提示","截止日期不能为空","info");
		websys_setfocus('PEDateEnd');
		return false;
	}
	iPEDate=OneData
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//预约体检时间
	OneData=getValueById("PETime");
	iPETime=OneData;
	if ((OneData!="")&&(OneData.indexOf(":")!="-1")){
			if((OneData.split(":")[0]>=24)||(OneData.split(":")[1]>59)||(OneData.split(":")[2]>59)){
				$.messager.alert("提示","无效时间格式");
				return false;
			}
		}
		
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//预约接待人员
	var iPEDeskClerkDRName=$("#PEDeskClerkDRName").combogrid('getValue');
	if (($("#PEDeskClerkDRName").combogrid('getValue')==undefined)||($("#PEDeskClerkDRName").combogrid('getValue')=="")){var iPEDeskClerkDRName="";} 
	var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(OneData)))&&(OneData!="")){var iPEDeskClerkDRName=$("#PEDeskClerkDRNameDR").val();}
	OneData=iPEDeskClerkDRName;
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	OneData="PREREG"
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//视同收费
	iAsCharged=$("#AsCharged").checkbox('getValue');
	if (iAsCharged) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 允许加项	
	iAddOrdItem=$("#AddOrdItem").checkbox('getValue');
	if (iAddOrdItem) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 加项金额限制	
	iAddOrdItemLimit=$("#AddOrdItemLimit").checkbox('getValue');
	if (iAddOrdItemLimit) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 允许加项金额	
     OneData=$("#AddOrdItemAmount").val() 
	if ((iAddOrdItemLimit)&&(OneData=="")){
		$.messager.alert('提示','限制加项金额时，加项金额不允许为空',"info");
		  	return false;
		
	}
	if((OneData!="")&&(OneData<=0)){
			$.messager.alert('提示','加项金额应大于0',"info");
		  	return false;
		}
	
	
	 if(!IsFloat(OneData)){
		  $.messager.alert('提示','加项金额格式不正确',"info");
		  return false;
	  }
	if((OneData!="")&&(OneData.indexOf(".")!="-1")&&(OneData.toString().split(".")[1].length>2)) {
			$.messager.alert("提示","加项金额小数点后不能超过两位","info");
			return false;
		}


	DataStr=DataStr+"^"+OneData
	
	
	OneData=""
	// 允许加药	
	var iAddPhcItem=$("#AddPhcItem").checkbox('getValue');
	if (iAddPhcItem) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData="N"
	// 加药金额限制	
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 允许加药金额	
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 个人报告发送	
	OneData=$("#IReportSend").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// 结算方式
	OneData=$("#DisChargedMode").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// VIP
	OneData=$("#VIPLevel").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//延期日期 PIADM_DelayDate
	//obj=document.getElementById("DelayDate");
	//if (obj) { iDelayDate=obj.value; }
	OneData="";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//备注 PIADM_Remark
	//obj=document.getElementById("Reamrk");
	//if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//OneData=getValueById("Sales_DR");
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	
	//类型
	OneData=$("#Type").val();
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//取报告日期
	OneData=$('#GetReportDate').datebox('getValue')
	if(OneData!=""){
		var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",$("#PEDateBegin").datebox('getValue'))
		var GetReportDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",OneData)
		
		if(GetReportDateLogical<=BookDateBeginLogical){
			$.messager.alert("提示","取报告日期应大于体检起始日期","info");
			return false;
		}
	}


	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//取报告时间
	OneData=getValueById("GetReportTime")
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	OneData=$("#Position").val();
	
	DataStr=DataStr+"^^^^^^^^"+OneData
	OneData=""
	OneData=$("#PatFeeTypeName").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	OneData=""
	//alert(DataStr)
	
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","Save",'','',DataStr)
	if (flag=="Err Date")
	{
		$.messager.alert("提示","结束日期不能早于开始日期","info");
		return false;
	}
	
	if ('0'==flag) {
		$.messager.alert("提示","更新成功","success");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
			window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:PGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
			
		}
		
		
	}else if('100'==flag) {
		$.messager.alert("提示",t['Err 100'],"info");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
			//window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:PGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
			
		}
	}
	else if('Err 05'==flag) {
		$.messager.alert("提示","记录已不是预登记状态,不能修改!","info");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
		
		}
	}	
	else {
		$.messager.alert("提示","更新错误 错误号:"+flag,"info");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
		
		}
		return false;
	}

	
	return true;
}

function InitCombobox(){
	
	  //VIP等级 
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});

		
	//体检类别
	var PatFeeTypeNameObj = $HUI.combobox("#PatFeeTypeName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
		valueField:'id',
		textField:'Desc',
		panelHeight:'70'
	});
		
		//结算方式
	var DisChargedModeObj = $HUI.combobox("#DisChargedMode",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'GD',text:'统结'},
            {id:'ID',text:'自结'}
           
        ]

	}); 
	
	//个人报告领取方式
	var IReportSendObj = $HUI.combobox("#IReportSend",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'GS',text:'统取'},
            {id:'IS',text:'自取'}
           
        ]

	}); 
	
	//接待人
		var PEDeskClerkDRNameObj = $HUI.combogrid("#PEDeskClerkDRName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
		mode:'remote',
		delay:200,
		idField:'HIDDEN',
		textField:'姓名',
		onBeforeLoad:function(param){
			
			param.Desc = param.q;
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'工号',title:'工号',width:100},
			{field:'姓名',title:'姓名',width:200}
			
		]]
	});

		
}



//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==$.trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}
	
