//===========================================================================================
// Author��      yuliping
// Date:		 2021-06-01
// Description:	 ҩ����¼��
//===========================================================================================
/// ҳ���ʼ������
var medOrderID =""
var EpisodeID = ""
function initPageDefault(){
	
	InitPatInfo();		// ��ť��Ӧ�¼���ʼ��
	setCombox()			// ҩ�����ֵ�����
	initMedOrder()
}

function InitPatInfo(){
	if ((medOrderID=="")){
		var frm = dhcadvdhcsys_getmenuform();
	
		if (frm) {
	        var adm = frm.EpisodeID.value;
	       
		    EpisodeID=adm;
	        setPatInfo(adm);//��ȡ������Ϣ
		}
	}

	}
//��ȡ������Ϣ
function setPatInfo(EpisodeID){
	if(EpisodeID==""){return;}
	runClassMethod("web.DHCCKBMedicationOrder","GetPatInfoJson",{'PatNo':'','EpisodeID':EpisodeID},
	function(Data){ 
      	$("#PatName").val(Data.PatName);				// ��������
       	$("#PatNo").val(Data.PatNo);					// �ǼǺ�
       	$("#PatSex").val(Data.PatSex);					// �Ա�
       	$("#PatAge").val(Data.PatAge);					// ����
      	$("#AdmDate").datebox("setValue",Data.AdmDate);    //��������
      	$("#AdmLoc").val(Data.AdmLoc);
      	$("#Doctor").val(Data.AdmDoctor);
      	$("#Diagnosis").val(Data.PatDiag);
      	$("#IDCard").val(Data.IDCard);
      	$("#PatBDay").datebox("setValue",Data.Birthday);
      	$("#Adress").val(Data.Address);
      	$("#Phone").val(Data.PatTelH);
	},"json",false);

	
}

//��ʼ��������
function setCombox(){
	//��������
	initCombox("DecoctingVessel","MedOrdCookCistern")
	
	//���ݼ�ˮ��
	initCombox("SoakingWater","MedOrdSoakWaterVol")
	
	//����ʱ��
	initCombox("SoakingTime","MedOrdSoakTime")

	//�������
	initCombox("DecoctingTimes","MedOrdCookNum")

	//����ʱ��
	initCombox("DecoctionTime","MedOrdCookTime")
	
	//�����¶�
	initCombox("DecoctingTemperature","MedOrdCookTemper")
	
	//������󷽷�
	initCombox("DecoctingMethod","MedOrdCookWay")
	
	//��ҩ�¶�
	initCombox("MedicationTemperature","MedOrdUseTemper")
	
	//��ҩʱ��
	initCombox("MedicationTime","MedOrdUseTime")
	
	//��ҩ����
	initCombox("MedicationTimes","MedOrdUseNum")
	
	//��ҩ����
	initCombox("Dosage","MedOrdUseDose")
	
	//��ҩʳ��
	initCombox("foodTaboo","MedOrdTaboo")

	//ҩ����
	initCombox("PostDrugCare","MedOrdNursing")
	
	//�洢����
	initCombox("StorageMethod","MedOrdStorageWay")
	if(hideFlag==1){
		$("#btnList").hide()
		}
	}
	
function initCombox(id,desc){
	$('#'+id).combogrid({ 
		idField:'value',
	    textField:'text',
	    fitColumns:true,
	    fit: true,//�Զ���С  
		pagination : true,
		panelWidth:1000,								
		mode:'remote', 	
		enterNullValueClear:false,
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBMedicationOrder&MethodName=jsonMedical&desc='+desc,
		columns:[[
				{field:'text',title:'���',width:50},
				{field:'value',title:'����',width:200},	
				]]   
	}); 
}


function SaveData(){
	EpisodeID=3
	//�����^������^��ע
	var listData = EpisodeID+"^"+$("#PrescriptionNumber").val()+"^"+$("#Remarks").val();
	
	//��������^����ˮ��^����ʱ��^�������
	listData = listData+"^"+$("#DecoctingVessel").combogrid("getText")+"^"+$("#SoakingWater").combogrid("getText")+"^"+$("#SoakingTime").combogrid("getText") +"^"+$("#DecoctingTimes").combogrid("getText");
	
	//����ʱ��^�����¶�^������󷽷�
	listData = listData+"^"+$("#DecoctionTime").combogrid("getText")+"^"+$("#DecoctingTemperature").combogrid("getText")+"^"+$("#DecoctingMethod").combogrid("getText");
	
	//��һ��^�ڶ���
	listData = listData+"^"+$("#DecoctingMethodFirst").val()+"^"+$("#DecoctingMethodSecond").val();
	
	//��ҩ�¶�^��ҩʱ��^��ҩ����^��ҩ����
	listData = listData+"^"+$("#MedicationTemperature").combogrid("getText")+"^"+$("#MedicationTime").combogrid("getText")+"^"+$("#MedicationTimes").combogrid("getText")+"^"+$("#Dosage").combogrid("getText");
	
	//��ҩʳ��^ҩ����^��ҩ��֪^���淽��^	
	listData = listData+"^"+$("#foodTaboo").combogrid("getText")+"^"+$("#PostDrugCare").combogrid("getText")+"^"+$("#MedicationNotification").val()+"^"+$("#StorageMethod").combogrid("getText")+"^"+$("#SpecialObey").val()
	
	runClassMethod("web.DHCCKBMedicationOrder","saveOrUpdateMedOrder",{ID:medOrderID, DataList:listData},function(ret){
		
		if(ret>0){
			$.messager.alert("��ʾ","����ɹ�")
			medOrderID = ret;
			}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�������룺"+ret)
				}
		},"text",false)
	}
	
//����ҩ��������
function initMedOrder(){
	if(medOrderID!=""){
		
		runClassMethod("web.DHCCKBMedicationOrder","getMedOrder",{ID:medOrderID},function(Data){
			
			$("#PatName").val(Data.PatName);				// ��������
	       	$("#PatNo").val(Data.PatNo);					// �ǼǺ�
	       	$("#PatSex").val(Data.PatSex);					// �Ա�
	       	$("#PatAge").val(Data.PatAge);					// ����
	      	$("#AdmDate").datebox("setValue",Data.AdmDate);    //��������
	      	$("#AdmLoc").val(Data.AdmLoc);
	      	$("#Doctor").val(Data.AdmDoctor);
	      	$("#Diagnosis").val(Data.PatDiag);
	      	$("#IDCard").val(Data.IDCard);
	      	$("#PatBDay").datebox("setValue",Data.Birthday);
	      	$("#Adress").val(Data.Address);
	      	$("#Phone").val(Data.PatTelH);
	      	$("#Number").val(Data.MOSysNo);											//ϵͳ���
			$("#PrescriptionNumber").val(Data.MOPrescripNo);  						//������
			$("#Remarks").val(Data.MORemarks);   									//��ע
			$("#DecoctingVessel").combogrid("setValue",Data.MODecVessel);   		//��������
			$("#SoakingWater").combogrid("setValue",Data.MOSoakWater);  			//����ˮ��
			$("#SoakingTime").combogrid("setValue",Data.MOSoakTime);  				//����ʱ��
			$("#DecoctingTimes").combogrid("setValue",Data.MODecTimes);  			//�������
			$("#DecoctionTime").combogrid("setValue",Data.MODecTime);   			//����ʱ��
			$("#DecoctingTemperature").combogrid("setValue",Data.MODecTemp);   		//�����¶�
			$("#DecoctingMethod").combogrid("setValue",Data.MODecMethod);   		//������󷽷�
			$("#DecoctingMethodFirst").val(Data.MODecFirFried);   					//��һ��
			$("#DecoctingMethodSecond").val(Data.MODecSecFried);   					//�ڶ���
			$("#MedicationTemperature").combogrid("setValue",Data.MOMedTemp);   	//��ҩ�¶�
			$("#MedicationTime").combogrid("setValue",Data.MOMedTime);   			//��ҩʱ��
			$("#MedicationTimes").combogrid("setValue",Data.MOMedTimes);  			//��ҩ����
			$("#Dosage").combogrid("setValue",Data.MODosage);   					//��ҩ����
			$("#foodTaboo").combogrid("setValue",Data.MOFoodTaboo);   				//��ҩʳ��
			$("#PostDrugCare").combogrid("setValue",Data.MOPostDrugCare);   		//ҩ����
			$("#MedicationNotification").val(Data.MOMedNotify);   					//��ҩ��֪
			$("#StorageMethod").combogrid("setValue",Data.MOStorageMethod);   		//���淽��
			$("#SpecialObey").val(Data.MOSpecialObey); 								//�������
			
			},"json",false)
		}
	}

//��ӡ
function PrintData(){
	var url="dhcckb.printmedicationorder.csp?medOrderID="+medOrderID
	window.open(url,"_blank");

}
/// ���ӻ�ȡ���˲˵���Ϣ����
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//���´��ڴ򿪵Ľ���
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}
function ListData(){
	var url="dhcckb.querymedorder.csp"
	window.open(url,"_blank");

	}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })