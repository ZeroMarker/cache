/// DHCPEPreIADM.GTEdit.js

var TFORM="";
function BodyLoadHandler() {

	var obj;
	//����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	
	// PGADM_AddOrdItem ������� 
	$('#AddOrdItem').checkbox({
		onCheckChange:function(e,value){
			AddOrdItem_click(value);
			
			}
			
	});

	// PGADM_AddOrdItemLimit ���������� 
	
	$('#AddOrdItemLimit').checkbox({
		onCheckChange:function(e,value){
			AddOrdItemLimit_click(value);
			
			}
			
	});
	

	// PGADM_AddPhcItem �����ҩ 
	$('#AddPhcItem').checkbox({
		onCheckChange:function(e,value){
			AddPhcItem_click(value);
			
			}
			
	});
   
   
	// PGADM_AddPhcItemLimit ��ҩ������� 
	$('#AddPhcItemLimit').checkbox({
		onCheckChange:function(e,value){
			AddPhcItemLimit_click(value);
			
			}
			
	});
	
	
	obj=document.getElementById("VIPLevel");	//	�б��ʱʹ��
	if (obj) {
		obj.onchange=VIPLevel_Change;
	}
	obj=document.getElementById("RowId");
	iniForm();
}
function VIPLevel_Change()
{
	obj=document.getElementById("VIPLevel");
	if (obj){
		var VIPLevel=obj.value;
		if (VIPLevel=="") return false;
		var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel)
		if (PatType!=""){
			var obj=document.getElementById("PatFeeType_DR_Name");
			if (obj) obj.value=PatType;
		}
	}
}
function iniForm(){
	
	var obj;
	
	//����:���ƿ�ҩ���  ��ҩ���
	/*
	$("#AddPhcItem").parent(".hischeckbox_square-blue").css("display","none");
	obj=document.getElementById("cAddPhcItem");
	if(obj){ obj.style.display="none";}
	*/
	
	$("#AddPhcItemLimit").parent(".hischeckbox_square-blue").css("display","none");
	obj=document.getElementById("cAddPhcItemLimit");
	if(obj){ obj.style.display="none";}
	obj=document.getElementById("cAddPhcItemAmount");
	if(obj){ obj.style.display="none";}
	
	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { 
		SetPatient_Sel(obj.value);
	}
		
}

//
function SetPatient_Sel(value) {
	var obj;
	var Data=value.split(";");
	
	//�Ǽ���Ϣ
	var PreIADMData=Data[1];
	
	if (""!=PreIADMData) { SetPreIADM(PreIADMData); }
	
}


//�Ǽ���Ϣ
function SetPreIADM(value){
   
	var obj;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	
	if ('0'==iRowId) { return false; }
		// ��ť ԤԼ��Ŀ
		obj=document.getElementById("BNewItem");
		if (obj){ obj.disabled=false; }		
		
		// ������
		//obj=document.getElementById("BSaveAmount");
		//if (obj){ obj.disabled=false; }		
	
	
	obj=document.getElementById("RowId");
	if (obj) { obj.value=iRowId; }
	iLLoop=iLLoop+1;
	
	//Ԥ�ǼǸ��˻�����Ϣ�� PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_RowId");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;	
	// 1.1
	obj=document.getElementById("PIBI_DR_Name");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;

	//��Ӧ�����ADM PIADM_PGADM_DR 2
	obj=document.getElementById("PGADM_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	if (Data[iLLoop]!="")
	{
		var encmeth=document.getElementById("GetGADMInfo");
		if (encmeth) encmeth=encmeth.value;
		var GADMInfo=cspRunServerMethod(encmeth,Data[iLLoop]);
		GADMInfo=GADMInfo.split("^");
		
		setValueById("GStartDate",GADMInfo[0])
		setValueById("GEndDate",GADMInfo[1])
		setValueById("GDelayDate",GADMInfo[2])
	}
	iLLoop=iLLoop+1;
	
	// ��Ӧ���� 2.1
	//obj=document.getElementById("PGADM_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//��Ӧ������ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("PGTeam_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// ��Ӧ������ 3.1
	//obj=document.getElementById("PGTeam_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//ԤԼ������ڿ�ʼ PIADM_PEDateBegin 4
	$('#PEDateBegin').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// ԤԼ������ڽ��� PIADM_PEDateEnd 27
   $('#PEDateEnd').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//ԤԼ���ʱ�� PIADM_PETime 5
	obj=document.getElementById("PETime");
	setValueById("PETime",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	// ԤԼ�Ӵ���Ա PIADM_PEDeskClerk_DR 6
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// ԤԼ�Ӵ���Ա 6.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;	

	// PIADM_Status 7
	obj=document.getElementById("Status");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	

	//��ͬ�շ� PIADM_AsCharged 8
	obj=document.getElementById("AsCharged");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { setValueById("AsCharged",true); }
		else { setValueById("AsCharged",false);  }
	}	
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
	
	// ���˱��淢��	PIADM_IReportSend 25
	setValueById("IReportSend",Data[iLLoop]);
	iLLoop=iLLoop+1;
	
	// ���㷽ʽ	PIADM_DisChargedMode 26
	setValueById("DisChargedMode",Data[iLLoop]);
	iLLoop=iLLoop+1;
	
	//  PIADM_VIP 28
	setValueById("VIPLevel",Data[iLLoop]);
	iLLoop=iLLoop+1;
	//  PIADM_DelayDate 28
	setValueById("DelayDate",Data[iLLoop]);
	iLLoop=iLLoop+1;
	
	
	
	//  PIADM_Remark 28
	obj=document.getElementById("Remark");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	// ҵ��Ա PIADM_PEDeskClerk_DR 6
	obj=document.getElementById("Sales_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// ҵ��Ա 6.1
	obj=document.getElementById("Sales");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	
	//����
	obj=document.getElementById("Type");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//ȡ��������
	$('#GetReportDate').datebox('setValue',Data[iLLoop])
	iLLoop=iLLoop+1;
	//ȡ����ʱ��
	setValueById("GetReportTime",Data[iLLoop]);
	iLLoop=iLLoop+4;
	//ȡ�����������
	setValueById("PatFeeType_DR_Name",Data[iLLoop]);

}
//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
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
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	���Ѽ���	PIADM_AddOrdItem	19
	obj=document.getElementById("AddOrdItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			setValueById("AddOrdItem",true);
			iAddOrdItem=true;
			
		}
		else { 
			setValueById("AddOrdItem",false);
			iAddOrdItem=false;
		}
				
	}
	iLLoop=iLLoop+1;	
	
	var iAddOrdItemLimit=false;
	//	����������	PIADM_AddOrdItemLimit	20
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) { 
		if (iAddOrdItem) {
			
			obj.disabled=false;
			if ("Y"==Data[iLLoop]) {
				setValueById("AddOrdItemLimit",true);
				iAddOrdItemLimit=true;
			}
			else {
				setValueById("AddOrdItemLimit",false);
				iAddOrdItemLimit=false;
			}
			
			
		}
		else {
			obj.disabled=true;
			
			setValueById("AddOrdItemLimit",false);
			iAddOrdItemLimit=false;
						
		}
	}
	iLLoop=iLLoop+1;	
	
	//	���Ѽ�����	PIADM_AddOrdItemAmount	21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) {
		if (iAddOrdItemLimit) {
			
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
		}
		else{
			obj.disabled=true;
			
			obj.value="";
			
		}
		
	}
	iLLoop=iLLoop+1;	
	
	//	�����ҩ	PIADM_AddPhcItem	22
	var iAddPhcItem=false;
	obj=document.getElementById("AddPhcItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			setValueById("AddPhcItem",true);
			iAddPhcItem=true;
		}
		else {
			setValueById("AddPhcItem",false);
			iAddPhcItem=false
		}

	}
	iLLoop=iLLoop+1;	
	
	//	��ҩ�������	PIADM_AddPhcItemLimit	23
	var iAddPhcItemLimit=false;
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) {
		if (iAddPhcItem) {
			obj.disabled=false;
			
			if ("Y"==Data[iLLoop]) {
				setValueById("AddPhcItemLimit",true);
				iAddPhcItemLimit=true;
				
			}
			else {
				setValueById("AddPhcItemLimit",false);
				iAddPhcItemLimit=false;
			}
			
			
		}
		else{
			obj.disabled=true;
			setValueById("AddPhcItemLimit",false);
			iAddPhcItemLimit=false;
		}	

	}
	iLLoop=iLLoop+1;
	
	//	�����ҩ���	PIADM_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");		
	if (obj) {
		if (iAddPhcItemLimit) {
			obj.disabled=false;
			
			obj.value=Data[iLLoop];		
		}
		else{
			obj.disabled=true;
			obj.value="";
		}
	}
	
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function Update_click() {
	var iPEDate="", iPETime=""
	var obj,DataStr="",OneData="",iRowId
	obj=document.getElementById("RowId");
	if (obj) { OneData=obj.value; }
	iRowId=OneData
	DataStr=OneData
	OneData=""
	//Ԥ�ǼǸ��˻�����Ϣ�� PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_RowId");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//��Ӧ�����ADM PIADM_PGADM_DR 2
	obj=document.getElementById("PGADM_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//��Ӧ��ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("PGTeam_DR");
	if (obj) { OneData=obj.value; }
	var PGTeam=obj.value;
	DataStr=DataStr+"^"+OneData
	OneData=""
	//ԤԼ������ڿ�ʼ PIADM_PEDateBegin 4
	  OneData=$("#PEDateBegin").datebox('getValue')
	
	if (""==OneData) {
		$.messager.alert("��ʾ","�����ʼ���ڲ���Ϊ��","info");
		websys_setfocus('PEDateBegin');
		return false;
	}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// ԤԼ������ڽ��� PIADM_PEDateEnd 4
	OneData=$('#PEDateEnd').datebox('getValue')
	if (""==OneData) {
		$.messager.alert("��ʾ","��ֹ���ڲ���Ϊ��","info");
		websys_setfocus('PEDateEnd');
		return false;
	}
	iPEDate=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	//ԤԼ���ʱ�� PIADM_PETime
	obj=document.getElementById("PETime");
	if (obj) {
		if ('clsInvalid'==obj.className) { 
			$.messager.alert("��ʾ","��Чʱ���ʽ","info");
			return false;
		}
		OneData=obj.value;
		if ((OneData!="")&&(OneData.indexOf(":")!="-1")){
			if((OneData.split(":")[0]>=24)||(OneData.split(":")[1]>59)||(OneData.split(":")[2]>59)){
				$.messager.alert("��ʾ","��Чʱ���ʽ");
				return false;
			}
		}

	}
	iPETime=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	//ԤԼ�Ӵ���Ա PIADM_PEDeskClerk_DR
	OneData=getValueById("PEDeskClerk_DR");
	DataStr=DataStr+"^"+OneData
	OneData=""
	// PIADM_Status
	//obj=document.getElementById("Status");
	//if (obj) { OneData=obj.value; }
	OneData="PREREG"
	DataStr=DataStr+"^"+OneData
	OneData=""
	//��ͬ�շ� PIADM_AsCharged
	iAsCharged=getValueById("AsCharged")
	if (iAsCharged) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// �������	PIADM_AddOrdItem
	iAsCharged=getValueById("AddOrdItem")
	if (iAsCharged) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// ����������	PIADM_AddOrdItemLimit
	iAsCharged=getValueById("AddOrdItemLimit")
	if (iAsCharged) { OneData="Y"; }
	else { OneData="N"; }
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// ���������	PIADM_AddOrdItemAmount
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { OneData=obj.value; }
	if ((iAsCharged)&&(OneData=="")){
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
	
	// �����ҩ	PIADM_AddPhcItem
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData="N"
	// ��ҩ�������	PIADM_AddPhcItemLimit
	//obj=document.getElementById("AddPhcItemLimit");
	//if (obj && obj.checked) { OneData="Y"; }
	//else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// �����ҩ���	PIADM_AddPhcItemAmount
	//obj=document.getElementById("AddPhcItemAmount");
	//if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// ���˱��淢��	PIADM_IReportSend
	OneData=getValueById("IReportSend")
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// ���㷽ʽ	PIADM_DisChargedMode
	OneData=getValueById("DisChargedMode")
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 	PIADM_VIP
	OneData=getValueById("VIPLevel")
	DataStr=DataStr+"^"+OneData
	OneData=""
	//�������� PIADM_DelayDate
	//obj=document.getElementById("DelayDate");
	//if (obj) { iDelayDate=obj.value; }
	OneData="";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//��ע PIADM_Remark
	obj=document.getElementById("Reamrk");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	
	OneData=getValueById("Sales_DR");
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	
	//����
	obj=document.getElementById("Type");
	if (obj) { OneData=obj.value; }
	
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
	
	obj=document.getElementById("Position");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^^^^^^^^"+OneData
	OneData=""
	OneData=getValueById("PatFeeType_DR_Name")
	DataStr=DataStr+"^"+OneData
	OneData=""
	//alert(DataStr)
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',DataStr)
	if (flag=="Err Date")
	{
		$.messager.alert("��ʾ","�������ڲ������ڿ�ʼ����","info");
		return false;
	}
	if ('0'==flag) {
		$.messager.alert("��ʾ","���³ɹ�","sunccess");
		if(parent)
		{
			window.parent.$('#GIAdmEditWin').window('close');
			window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:PGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
			
		}
		if (opener) {
			
			// ���ø����� DHCPEPreGTeam.List �ķ��غ���
			opener.ChilidWindowReturn(iRowId+"^"+iPEDate+"^"+iPETime);
			close();
			
		}
		
	}else if('100'==flag) {
		$.messager.alert("��ʾ",t['Err 100'],"info");
		//alert(t['Err 100']);
		close();
	}
	else if('Err 05'==flag) {
		$.messager.alert("��ʾ","��¼�Ѳ���Ԥ�Ǽ�״̬,�����޸�!","info");
		//alert(['Err 05']);
		close();
	}	
	else {
		$.messager.alert("��ʾ","���´��� �����:"+flag,"info");
		//alert(t['02']+flag);
		close();
		return false;
	}

	//ˢ��ҳ��
	//location.reload(); 
	return true;
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
//  �������(PIADM_AddOrdItem)
function AddOrdItem_click(value) {
	
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (value) {
		// PIADM_AddOrdItemLimit ���������� 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.disabled=false;
			setValueById("AddOrdItemLimit",true)
		}
		
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.disabled=false;
			obj.value="";
		}
		
	}
	else{
		// PIADM_AddOrdItemLimit ���������� 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.disabled=true;
			setValueById("AddOrdItemLimit",false)
		}
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.disabled=true;
			obj.value="";
		}
	}

}
// PIADM_AddOrdItemLimit ���������� 
function AddOrdItemLimit_click(value) {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItemLimit");
	var obj;
	if (value) {
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.disabled=false;
			obj.value="";
		}
		
	}
	else{
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.disabled=true;
			obj.value="";
		}
			
	}
	
}
// PIADM_AddPhcItem �����ҩ 
function AddPhcItem_click(value) {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (value) {
		// PIADM_AddPhcItemLimit ��ҩ������� 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.disabled=false;
			setValueById("AddPhcItemLimit",true)
		}
		
		// PIADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled=false;
			obj.value="";
		}
		
	}
	else{
		// PIADM_AddPhcItemLimit ��ҩ������� 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.disabled=true;
			setValueById("AddPhcItemLimit",false)
		}
		
		// PIADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled=true;
			obj.value="";
		}	
	}
	
}
// PIADM_AddPhcItemLimit ��ҩ������� 
function AddPhcItemLimit_click(value) {
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (value) {
		// PIADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = false;
			obj.value="";
		}
	}
	else{
		// PIADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = true;
			obj.value="";
		}
				
	}

}
// /////////////////////////////////////////////////////////////
// ѡ��Ӵ���
function SearchUser(value) {

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PEDeskClerk_DR_Name");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("PEDeskClerk_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}

function UpdatePreAudit()
{
	var Type="I";
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}



  //����
function UpdateTeam()
{   var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEChangeTeam.Edit&id="+ID;
	var wwidth=250;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

function ModifyDelayDate()
{
	var Type="Pre";
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=250;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function UpdateAsCharged()
{
	var Type="I";
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("UpdateAsCharged");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID,Type)
	if (Return==""){alert("Status Err");}
	else if (Return=="SQLErr"){alert("Update Err");}
	else{alert("Update Success!");}
}
document.body.onload = BodyLoadHandler;
