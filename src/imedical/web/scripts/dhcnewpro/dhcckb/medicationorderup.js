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
	EpisodeID=3
	setPatInfo(EpisodeID);
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
      	$("#DiagnosisNew").val(Data.PatDiag);
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
	initCombox("SoakingWater2","MedOrdSoakWaterVol")
	
	//����ʱ��
	initCombox("SoakingTime","MedOrdSoakTime")

	//�������
	initCombox("DecoctingTimes","MedOrdCookNum")

	//����ʱ��
	initCombox("DecoctionTime","MedOrdCookTime")
	initCombox("DecoctionTime2","MedOrdCookTime")
	
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
	//initCombox("StorageMethod","MedOrdStorageWay")
	
	//�������
	initCombox("SpecialObey","SpecialTakingMethod")
	
	//��ҩ��֪
	initCombox("MedicationNotification","MedicationNotification")
	
	if(hideFlag==1){
		$("#btnList").hide()
	}
	
	$("#StorageMethod").val("�뽫��Ƭ������������� ͨ�紦,��õ�ҩҺ���ڱ��������0~ 5�淶Χ�ڱ���");		
		
	$HUI.radio("[name='prescType']",{
        onChecked:function(e,value){
	        initCombox("SoakingTime","MedOrdSoakTime");
	        initCombox("DecoctingTemperature","MedOrdCookTemper");
	        initCombox("DecoctionTime","MedOrdCookTime");
			initCombox("DecoctionTime2","MedOrdCookTime");
            //alert($(e.target).attr("label"));  //�����ǰѡ�е�labelֵ
            //alert($(e.target).val());
        }
    });
	}
	
function initCombox(id,desc){
	
	var defaultValue = ""
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
				{field:'value',title:'����',width:200}
				]],
		onLoadSuccess:function(data){
			if (data.total == 1){ // ֻ��һ��ֵʱĬ��
				defaultValue = data.rows[0].value;				
			}
			SetDefaultCombobox(id,defaultValue,data);
		}	
	}); 
	
}	


function SaveData(){

	//�����^������^��ע
	var listData = EpisodeID+"^"+$("#PrescriptionNumber").val()+"^";
	
	//��������^����ˮ��^����ʱ��^�������
	listData = listData+"^"+$("#DecoctingVessel").combogrid("getText")+"^"+$("#SoakingWater").combogrid("getText")+"^"+$("#SoakingTime").combogrid("getText") +"^"+$("#DecoctingTimes").combogrid("getText");
	
	//����ʱ��^�����¶�^������󷽷�
	listData = listData+"^"+$("#DecoctionTime").combogrid("getText")+"^"+$("#DecoctingTemperature").combogrid("getText")+"^"+$("#DecoctingMethod").combogrid("getText");
	
	//��һ��^�ڶ���
	//listData = listData+"^"+$("#DecoctingMethodFirst").val()+"^"+$("#DecoctingMethodSecond").val();
	listData = listData+"^"+ "" +"^"+ "";
	
	//��ҩ�¶�^��ҩʱ��^��ҩ����^��ҩ����
	listData = listData+"^"+$("#MedicationTemperature").combogrid("getText")+"^"+$("#MedicationTime").combogrid("getText")+"^"+$("#MedicationTimes").combogrid("getText")+"^"+$("#Dosage").combogrid("getText");
	
	//��ҩʳ��^ҩ����^��ҩ��֪^���淽��^�������	
	listData = listData+"^"+$("#foodTaboo").combogrid("getText")+"^"+$("#PostDrugCare").combogrid("getText")+"^"+$("#MedicationNotification").val()+"^"+$("#StorageMethod").val()+"^"+$("#SpecialObey").combogrid("getText");
	
	//��������^����ˮ��2(����)^����ʱ��2(����)
	var checkedRadioJObj = $("input[name='prescType']:checked");
	var checkVal = checkedRadioJObj.val();
	if ((checkVal == "")||(checkVal == undefined)){
		$.messager.alert("��ʾ","��ѡ�񷽼����ͺ󱣴档")
		return;
	}
	listData = listData+"^"+checkVal+"^"+$("#SoakingWater").combogrid("getText")+"^"+$("#DecoctionTime").combogrid("getText");
	
	//ע������25^֤�����26^��ʳ����27
	listData = listData+"^"+$("#mattersAttention").val()+"^"+$("#SyndromeContraindication").val()+"^"+$("#DietaryTaboos").val()
	
	// �и��������ڸ�Ů��ҩ28^��ͯ��ҩ29^������ҩ30
	listData = listData+"^"+$("#pregMedication").val()+"^"+$("#childrenMedication").val()+"^"+$("#GeriatricMedication").val()
	
	// ҩ���໥����31^���ط���32^������ʾ33
	listData = listData+"^"+$("#DrugInteraction").val()+"^"+"^"+$("#ToxicityTips").val()
	
	//������ʾ 34^������� 35
	listData = listData+"^"+$("#HealthTips").val()+"^"+$("#PrescCompotion").val()
	
	// ���36^����37
	listData = listData+"^"+$("#PrescSpec").val()+"^"+$("#PrescNum").val()

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
			//$("#StorageMethod").combogrid("setValue",Data.MOStorageMethod);   		//���淽��
			$("#StorageMethod").val(Data.MOStorageMethod);   						//���淽��
			$("#SpecialObey").val(Data.MOSpecialObey); 								//�������
			$("#SoakingWater2").combogrid("setValue",Data.MOSoakWater2);  			//����ˮ��(����)
			$("#DecoctionTime2").combogrid("setValue",Data.MODecTime2);   			//����ʱ��(����)
			$HUI.radio("#"+Data.PrescType).setValue(true);							//��������
			
			
			$("#mattersAttention").val(Data.MOMattersAttention);   			//��ע�����
			$("#SyndromeContraindication").val(Data.MOSyndromeContion);   			//��֤����ɡ�
			$("#DietaryTaboos").val(Data.MODietaryTaboos);   			//����ʳ���ɡ� 
			$("#pregMedication").val(Data.MOPregMedication);   			//���и��������ڸ�Ů��ҩ�� 
			$("#childrenMedication").val(Data.MOChildMedication);   			//��ͯ��ҩ�� 
			$("#GeriatricMedication").val(Data.MOGeriatricMedication);   			//��������ҩ�� 
			$("#DrugInteraction").val(Data.MODrugInteraction);   			//��ҩ���໥���á�
			//$("#StorageMethod").val(Data.StorageMethod);   			//�����ط����� 
			$("#ToxicityTips").val(Data.MOToxicityTips);   			//��������ʾ�� 
			$("#HealthTips").val(Data.MOHealthTips);   			//��������ʾ�� 
			$("#PrescCompotion").val(Data.MOPrescCompotion);   			//������� 
			$("#PrescSpec").val(Data.PrescSpec);   			//�������
			$("#PrescNum").val(Data.PrescNum);   			//�������� 
			
			},"json",false)
		}
	}

//��ӡ
function PrintData(){
	var url="dhcckb.printmedicationorderup.csp?medOrderID="+medOrderID
	window.open(url,"_blank");

}
/// ��ӻ�ȡ���˲˵���Ϣ����
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
	var url="dhcckb.querymedorderup.csp"
	window.open(url,"_blank");

	}
	
/// ����combobox��Ĭ��ֵ
function SetDefaultCombobox(id,defaultValue,data){

	// ��������,������� Ĭ��
	// ��ҩ�¶� Ĭ�ϡ��·�������ѡ���޸�
	// ��ҩʱ�� Ĭ�ϡ�����������޸�ѡ��
	// ��ҩ���� Ĭ�ϡ�һ�����Ρ������޸�
	// ��ҩ���� Ĭ�ϡ����ˡ������޸�
	// ���淽�� Ĭ�ϡ��뽫��Ƭ������������� ͨ�紦,��õ�ҩҺ���ڱ��������0~ 5�淶Χ�ڱ��桱
	if (defaultValue != ""){
		$('#'+id).combogrid('setValue', defaultValue);
	};
	
	var checkedRadioJObj = $("input[name='prescType']:checked");
	var checkVal = checkedRadioJObj.val()
	var checkText = checkedRadioJObj.attr("label");
          
	switch(id){
		case "MedicationTemperature":
			$('#'+id).combogrid('setValue', "�·�");
			break;
			
		case "MedicationTime":
			$('#'+id).combogrid('setValue', "�����");
			break;
			
		case "MedicationTimes":
			$('#'+id).combogrid('setValue', "һ������");
			break;

		case "Dosage":
			$('#'+id).combogrid('setValue', "����");
			break;	
		
		case "SoakingTime":
			if (checkText == "�����"){
				$('#'+id).combogrid('setValue', "������");
			}else{
				$('#'+id).combogrid('setValue', checkText);
			}			
			break;	
			
		case "DecoctingTemperature":			
			$('#'+id).combogrid('setValue', checkText);					
			break;			
			
		case "SoakingWater":
			$('#'+id).combogrid('setValue', "һ��");
			break;	
			
		case "SoakingWater2":
			$('#'+id).combogrid('setValue', "����");
			break;	
			
		case "DecoctionTime":
			$.each(data.rows, function(){
				if (this.value == checkText){
					if (this.text.indexOf("ͷ��")!=-1){
						$('#'+id).combogrid('setValue',this.text);
						return false; // = break
					}
				}
			});			
			break;	
		case "DecoctionTime2":
			$.each(data.rows, function(){
				if (this.value == checkText){
					if (this.text.indexOf("����")!=-1){
						$('#'+id).combogrid('setValue',this.text);
						return false; // = break
					}
				}
			});	
			break;	
			
		default:
			break;	
	}
	

}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })