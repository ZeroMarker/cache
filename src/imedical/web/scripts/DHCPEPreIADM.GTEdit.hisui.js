
//���� DHCPEPreIADM.GTEdit.hisui.js
//���� ������ԱԤԼ��Ϣ�޸�
//���� 2021.01.04
//������ xy
$(function(){

	//  ������� 
	$('#AddOrdItem').checkbox({
		onCheckChange:function(e,value){
			AddOrdItem_click(value);
			}
			
	});

	//  ���������� 
	$('#AddOrdItemLimit').checkbox({
		onCheckChange:function(e,value){
			AddOrdItemLimit_click(value);
		}
			
	});
	
 InitCombobox();
 
 iniForm();
 
 //����
$("#BUpdate").click(function() {	
	Update_click();		
  });
 	
	
})


function iniForm(){
	
	 $("#PAPMINo").val(RegNo);
	 $("#Name").val(Name);
	
	
	 var ret=tkMakeServerCall("web.DHCPE.PreIADM","DocListBroker","","",ID+"^");
	 var Data=ret.split(";");
	//�Ǽ���Ϣ
	var PreIADMData=Data[1];
	if (""!=PreIADMData) { SetPreIADM(PreIADMData); }
}

//�Ǽ���Ϣ
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

	//��Ӧ������ADM PIADM_PGTeam_DR 3
	$("#PGTeam_DR").val(Data[iLLoop]);
	iLLoop=iLLoop+1;
	
	// ��Ӧ������ 3.1
	//obj=document.getElementById("PGTeam_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//ԤԼ������ڿ�ʼ 
	$('#PEDateBegin').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// ԤԼ������ڽ���
   $('#PEDateEnd').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//ԤԼ���ʱ�� PIADM_PETime 5
	setValueById("PETime",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// ԤԼ�Ӵ���Ա PIADM_PEDeskClerk_DR 6
	//obj=document.getElementById("PEDeskClerk_DR");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// ԤԼ�Ӵ���Ա 6.1
	$("#PEDeskClerkDRName").combogrid('grid').datagrid('reload',{'q':Data[iLLoop]});
	setValueById("PEDeskClerkDRName",Data[iLLoop-1])

	//$("#PEDeskClerkDRName").combogrid('setValue',Data[iLLoop]);
	//$("#PEDeskClerkDRNameDR").val(Data[iLLoop])
	iLLoop=iLLoop+1;
	

	// PIADM_Status 7
	//obj=document.getElementById("Status");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	

	//��ͬ�շ� PIADM_AsCharged 8
	
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
	
	
	// ���˱��淢�� 
	$("#IReportSend").combobox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// ���㷽ʽ	
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
	// ҵ��Ա 
    //obj=document.getElementById("Sales_DR");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	
	// ҵ��Ա 6.1
	//obj=document.getElementById("Sales");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//s val=%request.Get("ID") if val'="" s val=$G(^DHCPEDataEx("DHCPEPreIADM","Position",val))
	
	//����
	$("#Type").val(Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//ȡ��������
	$('#GetReportDate').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//ȡ����ʱ��
	setValueById("GetReportTime",Data[iLLoop]);
	iLLoop=iLLoop+4;
	
	//��������
	$("#PatFeeTypeName").combobox('setValue',Data[iLLoop])
	
	var iPosition=tkMakeServerCall("web.DHCPE.PreCommon","GetPosition","PreADM",iRowId);
	$("#Position").val(iPosition);
	
	
}

//  �������
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
// ���������� 
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
	
	//	���Ѽ���
	
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
			//����������
			$("#AddOrdItemLimit").checkbox('setValue',true);
		}else{
			$("#AddOrdItemLimit").checkbox('setValue',false);
		}
	}else{
		$("#AddOrdItemLimit").checkbox('setValue',false);
	}


	iLLoop=iLLoop+1;	
	
	//	���Ѽ�����	
	var iAddOrdItemLimit=$("#AddOrdItemLimit").checkbox('getValue');
	if(iAddOrdItemLimit){
		$("#AddOrdItemAmount").val(Data[iLLoop]);
		$("#AddOrdItemAmount").attr('disabled',false);
	}else{
		$("#AddOrdItemAmount").val("");
		$("#AddOrdItemAmount").attr('disabled',true);
	}

	iLLoop=iLLoop+1;	
	
	//	�����ҩ
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
	//���˻�����Ϣ 
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
	//ԤԼ������ڿ�ʼ 
	 OneData=$("#PEDateBegin").datebox('getValue')
	if (""==OneData) {
		$.messager.alert("��ʾ","�����ʼ���ڲ���Ϊ��","info");
		websys_setfocus('PEDateBegin');
		return false;
	}
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// ԤԼ������ڽ��� 
	OneData=$('#PEDateEnd').datebox('getValue')
	if (""==OneData) {
		$.messager.alert("��ʾ","��ֹ���ڲ���Ϊ��","info");
		websys_setfocus('PEDateEnd');
		return false;
	}
	iPEDate=OneData
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//ԤԼ���ʱ��
	OneData=getValueById("PETime");
	iPETime=OneData;
	if ((OneData!="")&&(OneData.indexOf(":")!="-1")){
			if((OneData.split(":")[0]>=24)||(OneData.split(":")[1]>59)||(OneData.split(":")[2]>59)){
				$.messager.alert("��ʾ","��Чʱ���ʽ");
				return false;
			}
		}
		
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//ԤԼ�Ӵ���Ա
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
	//��ͬ�շ�
	iAsCharged=$("#AsCharged").checkbox('getValue');
	if (iAsCharged) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// �������	
	iAddOrdItem=$("#AddOrdItem").checkbox('getValue');
	if (iAddOrdItem) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// ����������	
	iAddOrdItemLimit=$("#AddOrdItemLimit").checkbox('getValue');
	if (iAddOrdItemLimit) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// ���������	
     OneData=$("#AddOrdItemAmount").val() 
	if ((iAddOrdItemLimit)&&(OneData=="")){
		$.messager.alert('��ʾ','���Ƽ�����ʱ�����������Ϊ��',"info");
		  	return false;
		
	}
	if((OneData!="")&&(OneData<=0)){
			$.messager.alert('��ʾ','������Ӧ����0',"info");
		  	return false;
		}
	
	
	 if(!IsFloat(OneData)){
		  $.messager.alert('��ʾ','�������ʽ����ȷ',"info");
		  return false;
	  }
	if((OneData!="")&&(OneData.indexOf(".")!="-1")&&(OneData.toString().split(".")[1].length>2)) {
			$.messager.alert("��ʾ","������С������ܳ�����λ","info");
			return false;
		}


	DataStr=DataStr+"^"+OneData
	
	
	OneData=""
	// �����ҩ	
	var iAddPhcItem=$("#AddPhcItem").checkbox('getValue');
	if (iAddPhcItem) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	
	OneData="N"
	// ��ҩ�������	
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// �����ҩ���	
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// ���˱��淢��	
	OneData=$("#IReportSend").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// ���㷽ʽ
	OneData=$("#DisChargedMode").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	// VIP
	OneData=$("#VIPLevel").combobox('getValue');
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//�������� PIADM_DelayDate
	//obj=document.getElementById("DelayDate");
	//if (obj) { iDelayDate=obj.value; }
	OneData="";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//��ע PIADM_Remark
	//obj=document.getElementById("Reamrk");
	//if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""
	//OneData=getValueById("Sales_DR");
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	
	//����
	OneData=$("#Type").val();
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//ȡ��������
	OneData=$('#GetReportDate').datebox('getValue')
	if(OneData!=""){
		var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",$("#PEDateBegin").datebox('getValue'))
		var GetReportDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",OneData)
		
		if(GetReportDateLogical<=BookDateBeginLogical){
			$.messager.alert("��ʾ","ȡ��������Ӧ���������ʼ����","info");
			return false;
		}
	}


	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//ȡ����ʱ��
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
		$.messager.alert("��ʾ","�������ڲ������ڿ�ʼ����","info");
		return false;
	}
	
	if ('0'==flag) {
		$.messager.alert("��ʾ","���³ɹ�","success");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
			window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:PGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
			
		}
		
		
	}else if('100'==flag) {
		$.messager.alert("��ʾ",t['Err 100'],"info");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
			//window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:PGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
			
		}
	}
	else if('Err 05'==flag) {
		$.messager.alert("��ʾ","��¼�Ѳ���Ԥ�Ǽ�״̬,�����޸�!","info");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
		
		}
	}	
	else {
		$.messager.alert("��ʾ","���´��� �����:"+flag,"info");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
		
		}
		return false;
	}

	
	return true;
}

function InitCombobox(){
	
	  //VIP�ȼ� 
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});

		
	//������
	var PatFeeTypeNameObj = $HUI.combobox("#PatFeeTypeName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
		valueField:'id',
		textField:'Desc',
		panelHeight:'70'
	});
		
		//���㷽ʽ
	var DisChargedModeObj = $HUI.combobox("#DisChargedMode",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'GD',text:'ͳ��'},
            {id:'ID',text:'�Խ�'}
           
        ]

	}); 
	
	//���˱�����ȡ��ʽ
	var IReportSendObj = $HUI.combobox("#IReportSend",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'GS',text:'ͳȡ'},
            {id:'IS',text:'��ȡ'}
           
        ]

	}); 
	
	//�Ӵ���
		var PEDeskClerkDRNameObj = $HUI.combogrid("#PEDeskClerkDRName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
		mode:'remote',
		delay:200,
		idField:'HIDDEN',
		textField:'����',
		onBeforeLoad:function(param){
			
			param.Desc = param.q;
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'����',title:'����',width:100},
			{field:'����',title:'����',width:200}
			
		]]
	});

		
}



//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==$.trim(Value)) { 
		//����Ϊ��
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
	
