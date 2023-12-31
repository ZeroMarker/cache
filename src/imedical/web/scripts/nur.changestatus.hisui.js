$(document).ready(function() {
	
	//入院科室下拉框
	$('#Inhospitalarea').combobox({
	    url:'websys.Broker.cls?ClassName=web.DHCEMPatChange&MethodName=LookUpCtlocTojson&admType=W&hospId='+LgHospID
	});
	//撤销结算下拉框
	$('#backoutpay').combobox({
	    url:'websys.Broker.cls?ClassName=web.DHCEMPatChange&MethodName=PayoutreasonTojson'
	});	
})	

//更新病人状态
function opPatStatus(type){
	
	initChangeStatus()
	
	//撤销结算
	if(type=="cancel"){
		var resStr=serverCall("web.DHCEMPatChange","GetFinalStat",{'EpisodeID':$("#EpisodeID").val()});
		if(resStr!="0"){
			$.messager.alert('提示',resStr);
			return;
		}
		$('#backoutarea').show();
		$('#changeStatusCode').val("payout");
		setAccordionTitle("#changeStatusdialog","撤销结算( 变更急诊病人状态 )")
		$HUI.dialog('#changeStatusdialog').open()
		return;
	}
	
	var retflag=serverCall("web.DHCEMPatChange","GetAbnormalOrder",{'EpisodeID':$("#EpisodeID").val()});	
	if (retflag!="{rowData:[]}")
	{
	 	$.messager.alert('提示',"有需关注医嘱!"); 
        return;
	}
	var retflag=serverCall("web.DHCEMPatChange","GetAbnormalConsultAlert",{'EpisodeID':$("#EpisodeID").val()});
	if (retflag!='0') {
		$.messager.alert('提示',retflag); 
		return;
	}	
	
	//离院
	if(type=="Discharge"){
		$('#changedate').show();
		$('#changetime').show();
		$('#Disinputdate').show();
		$('#Disinputtime').show();
		$('#changeStatusCode').val("Discharge");
		setAccordionTitle("#changeStatusdialog","离院( 变更急诊病人状态 )")
	}
	//入本院
	if(type=="Inhospital"){
		$('#changedate').show();
		$('#changetime').show();
		$('#patarea').css("display","");
		$('#changeStatusCode').val("Inhospital");
		setAccordionTitle("#changeStatusdialog","入本院( 变更急诊病人状态 )")
	}
	//转外院
	if(type=="Displace"){
		$('#changedate').show();
		$('#changetime').show();
		$('#changeStatusCode').val("Displace");
		setAccordionTitle("#changeStatusdialog","转外院( 变更急诊病人状态 )")
	}
	//死亡
	if(type=="Death"){
		$('#changedate').show();
		$('#changetime').show();
		$('#changeStatusCode').val("Death");
		setAccordionTitle("#changeStatusdialog","死亡( 变更急诊病人状态 )")
	}
	$HUI.dialog('#changeStatusdialog').open()
}
function initChangeStatus(){
	
	$('#changedate').hide();
	$('#changetime').hide();
	$('#patarea').hide();
	$('#backoutarea').hide();
	$('#Disinputdate').hide();
	$('#Disinputtime').hide();
	
	$('#Statusdate').datebox('setValue',new Date().Format(DateFormat));
	$('#Statustime').timespinner('setValue',new Date().Format('hh:mm'));
	$('#DischargeState').datebox('setValue',new Date().Format(DateFormat));
	$('#DischargeTime').timespinner('setValue',new Date().Format('hh:mm'));

}

//改变病人状态按钮
function changeStatusAction(){
	var retStr=serverCall("web.DHCEMPatChange","GetAdmType",{'admId':$("#EpisodeID").val()});
	if (retStr!="E") {
		$.messager.alert('提示',"只能对急诊病人操作"); 
		return;
	}
	var type=$("#changeStatusCode").val();
	
	if(type=="Inhospital"){
		InUpdateClick(type);	
	}if(type=="Discharge"){
		DisUpdateClick(type);	
	}if(type=="Displace"){
		TrfUpdateClick(type);
	}if(type=="Death"){
		DedUpdateClick(type);	
	}if(type=="payout"){
		PayoutUpdateClick();
	}	
}

//入院更新按钮事件
function InUpdateClick(statuscode){
	//判断日期和时间
	var Statusdate=$('#Statusdate').datebox('getValue');
	var Statustime=$('#Statustime').timespinner('getValue');

	if ((Statusdate=="" )||(Statustime==""))
	{
		$.messager.alert('提示',"日期与时间不能为空"); 	
		return ;
	}
	//获取病人状态
	var data=serverCall("web.DHCEMPatChange","GetPatCurStat",{"EpisodeID":$("#EpisodeID").val()});
	var tmpList=data.split("^");
	if (tmpList[0]=="Stay"){		//留观
		var ret=serverCall("web.DHCEMPatChange","GetIfHaveNoPayOrder",{"Adm":$("#EpisodeID").val()})
		if(ret==1){
			$.messager.alert('提示',"病人有未结算的急诊留观账单，请先到【急诊留观结算】进行结算"); 
			return;
		}
	}if(tmpList[0]=="Inhospital"){
		$.messager.alert('提示',"病人已经入院,不能再次办理入院!");
		return;	
	}else{
	 	//入院病区
		var fDesc=$('#Inhospitalarea').combobox('getText');
		var restr=serverCall("web.DHCEMPatChange","InsertVis",{'EpisodeID':$("#EpisodeID").val(),'visStatCode':statuscode,'avsDateStr':Statusdate,'avsTimeStr':Statustime,'userId':LgUserID,'wardDesc':fDesc})
		if(restr!=0){
			$.messager.alert('提示',"插入状态错误!");	
		}else{
			$.messager.alert('提示',"更新成功!");
		}
	}
}

//离院更新按钮事件
function DisUpdateClick(statuscode){
	//var statuscode="Discharge"
	//判断改变、离院日期和时间
	var Statusdate=$('#Statusdate').datebox('getValue');
	var Statustime=$('#Statustime').timespinner('getValue');
	var DischargeState=$('#DischargeState').datebox('getValue');
	var DischargeTime=$('#DischargeTime').timespinner('getValue');
	if ((Statusdate=="" )||(Statustime==""))
	{
		$.messager.alert('提示',"日期与时间不能为空");	
		return ;
	}
	//获取病人状态
	var data=serverCall("web.DHCEMPatChange","GetPatCurStat",{"EpisodeID":$("#EpisodeID").val()});
	var tmpList=data.split("^");
	if ((tmpList[0]=="Stay")||(tmpList[0]=="SalDeath")||(tmpList[0]=="Death")||(tmpList[0]=="Salvage")){		//留观
		var ret=serverCall("web.DHCEMPatChange","GetIfHaveNoPayOrder",{"Adm":$("#EpisodeID").val()})
		if(ret==1){
			$.messager.alert('提示',"病人有未结算的急诊留观账单，请先到【急诊留观结算】进行结算");
			return;
		}
	}if(tmpList[0]=="Discharge"){
		$.messager.alert('提示',"病人已经离院,不能再次办理离院!");
		return;	
	}else{
		var retStr=serverCall("web.DHCEMPatChange","InsertVis",{'EpisodeID':$("#EpisodeID").val(),'visStatCode':statuscode,'avsDateStr':Statusdate,'avsTimeStr':Statustime,'userId':LgUserID,'wardDesc':""})
		
		if (retStr!=0){
			$.messager.alert('提示',"插入状态错误!");
			return;
		}
		
		var restr=serverCall("web.DHCEMPatChange","PAAdmFinalDischarge",{'EpisodeID':$("#EpisodeID").val(),'userId':LgUserID})
		if(restr!=0){
			$.messager.alert('提示',"插入状态错误!");			
		}else{
			$.messager.alert('提示',"更新成功!");
			queryPatList();			
		}
	}	
}

//转院更新按钮事件
function TrfUpdateClick(statuscode){

	var Statusdate=$('#Statusdate').datebox('getValue');
	var Statustime=$('#Statustime').timespinner('getValue');
	if ((Statusdate=="" )||(Statustime==""))
	{
		$.messager.alert('提示',"日期与时间不能为空");	
		return;
	}
	
	//获取病人状态
	var data=serverCall("web.DHCEMPatChange","GetPatCurStat",{"EpisodeID":$("#EpisodeID").val()});
	//alert(data);
	var tmpList=data.split("^");
	if (tmpList[0]=="Stay"){		//留观
		var ret=serverCall("web.DHCEMPatChange","GetIfHaveNoPayOrder",{"Adm":$("#EpisodeID").val()})
		if(ret==1){
			$.messager.alert('提示',"病人有未结算的急诊留观账单，请先到【急诊留观结算】进行结算");
			return;
		}
	}if(tmpList[0]=="Displace"){
		$.messager.alert('提示',"病人已经转院,不能再次办理转院!");
		return;	
	}else{
		var retStr=serverCall("web.DHCEMPatChange","InsertVis",{'EpisodeID':$("#EpisodeID").val(),'visStatCode':statuscode,'avsDateStr':Statusdate,'avsTimeStr':Statustime,'userId':LgUserID,'wardDesc':""})

		if(retStr!=0){
			$.messager.alert('提示',"插入状态错误!");	
		}else{
			$.messager.alert('提示',"更新成功!");
		}
	}	
	
		
}

//死亡更新按钮事件
function DedUpdateClick(statuscode){
	//判断改变日期和时间
	var Statusdate=$('#Statusdate').datebox('getValue');
	var Statustime=$('#Statustime').timespinner('getValue');
	if ((Statusdate=="" )||(Statustime==""))
	{
		$.messager.alert('提示',"日期与时间不能为空");		
		return;
	}
	
	//获取病人状态
	var data=serverCall("web.DHCEMPatChange","GetPatCurStat",{"EpisodeID":$("#EpisodeID").val()});
	var tmpList=data.split("^");
	if (tmpList[0]=="Stay"){		//留观
		var ret=serverCall("web.DHCEMPatChange","GetIfHaveNoPayOrder",{"Adm":$("#EpisodeID").val()})
		if(ret==1){
			$.messager.alert('提示',"病人有未结算的急诊留观账单，请先到【急诊留观结算】进行结算");
			return;
		}
	}if(tmpList[0]=="Death"){
		$.messager.alert('提示',"病人已经死亡,无法变更状态!");
		return;	
	}else{
		var retStr=serverCall("web.DHCEMPatChange","InsertVis",{'EpisodeID':$("#EpisodeID").val(),'visStatCode':statuscode,'avsDateStr':Statusdate,'avsTimeStr':Statustime,'userId':LgUserID,'wardDesc':""})
		
		if (retStr!=0){
			$.messager.alert('提示',"插入状态错误!");
			return;
		}
		
		var restr=serverCall("web.DHCEMPatChange","SetDeceasedStatus",{'EpisodeID':$("#EpisodeID").val(),'avsDateStr':Statusdate,'avsTimeStr':Statustime,'userId':LgUserID})
		if(restr!=0){
			$.messager.alert('提示',"插入状态错误!");	
		}else{
			$.messager.alert('提示',"更新成功!");	
		}
	}
	
} 
//撤销结算按钮事件
function PayoutUpdateClick()
{
	var RFDDesc=$('#backoutpay').combobox('getText');	//撤销结算原因
	
	var retStr=serverCall("web.DHCEMPatChange","DelDisorReversePay",{'Adm':$("#EpisodeID").val(),'userId':LgUserID,'reverseDesc':RFDDesc})

	if(retStr!=0){
		$.messager.alert('提示',retStr);
		return;	
	}else{
		$.messager.alert('提示',"更新成功!");
		queryPatList();	
	}
}