var LODOP="";
$(document).ready(function(){
	setTimeout("DelayedPrint()","500");   ///����LODOP��׼��ʱ�� 
	$("#Print").on("click",function(){
		print();// ���ô�ӡ
	}) 
})

function DelayedPrint(){
	LODOP = getLodop();
	PrintCons();
}
//Ԥ��ȡ���ݷ���
function PrintCons(){
	
	runClassMethod("web.DHCCKBMedicationOrder","getMedOrder",{ID:medOrderID},function(Data){
			
		$("#PatName").html("���� : "+Data.PatName);				// ��������
       	//$("#PatNo").html(Data.PatNo);							// �ǼǺ�
       	$("#PatSex").html("�Ա� : "+Data.PatSex);				// �Ա�
       	$("#PatAge").html("���� : "+Data.PatAge);				// ����
      	$("#AdmDate").html("�������ڣ�"+Data.AdmDate);    		//��������
      	$("#AdmLoc").html("������� ��"+Data.AdmLoc);
      	$("#Adress").html("סַ : "+Data.Address);
      	$("#Number").html("ϵͳ��� : "+Data.MOSysNo);			//ϵͳ���
      	$("#PatDiag").html("���ٴ���ϡ� "+Data.PatDiag);			//ϵͳ���
      	$("#MOPrescCompotion").html("��������ɡ� "+Data.MOPrescCompotion);			//�������
      	$("#MOPrescSpec").html("����� "+Data.MOPrescSpec);			//���
      	$("#MOPrescNum").html("�������� "+Data.MOPrescNum);			//����
      	
		$("#DecoctingVessel").html(Data.MODecVessel);   		//��������.
		//$("#SoakingWater").html(Data.MOSoakWater);  			//����ˮ��.
		$("#SoakingTime").html(Data.MOSoakTime);  				//����ʱ��.
		$("#SoakingTimes").html(Data.MODecTimes);  				//�������.
		$("#DecoctingMethod").html(Data.MODecMethod);   		//������󷽷�.
		$("#MODecMethod").html(Data.MODecMethod);   		//������󷽷�.

		//$("#DecoctingMethodFirst").html(Data.MODecFirFried);   	//��һ��.
		//$("#DecoctingMethodSecond").html(Data.MODecSecFried);   //�ڶ���.
		$("#DecoctingMethodFirst").html("<strong>[����ˮ��]</strong>"+"&nbsp;"+Data.MOSoakWater+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<strong>[����ʱ��]</strong>"+"&nbsp;"+Data.MODecTime);   	//��һ��.
		$("#DecoctingMethodSecond").html("<strong>[����ˮ��]</strong>"+"&nbsp;"+Data.MOSoakWater2+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<strong>[����ʱ��]</strong>"+"&nbsp;"+Data.MODecTime2);   	//�ڶ���.
		$("#MedicationTemperature").html("[�����¶�] "+Data.MOMedTemp);   	//��ҩ�¶�.
		$("#MedicationTime").html("[����ʱ��] "+Data.MOMedTime);   			//��ҩʱ��.
		$("#MedicationTimes").html("[���ô���] "+Data.MOMedTimes);  			//��ҩ����.
		$("#Dosage").html("[���ü���] "+Data.MODosage);   					//��ҩ����.
		$("#SpecialObey").html(Data.MOSpecialObey);   			//�������.
		$("#StorageMethod").html(Data.MOStorageMethod);   		//���淽��.
		$("#MODecTemp").html(Data.MODecTemp);  					//�����¶�
		$("#title").html(LgHospDesc+"ҽԺҩ������")
		
		$("#MOMattersAttention").html(Data.MOMattersAttention);   			//��ע�����
		$("#MOSyndromeContion").html(Data.MOSyndromeContion);   			//��֤����ɡ�
		$("#MODietaryTaboos").html(Data.MODietaryTaboos);   			//����ʳ���ɡ� 
		$("#MOPregMedication").html(Data.MOPregMedication);   			//���и��������ڸ�Ů��ҩ�� 
		$("#MOChildMedication").html(Data.MOChildMedication);   			//��ͯ��ҩ�� 
		$("#MOGeriatricMedication").html(Data.MOGeriatricMedication);   			//��������ҩ�� 
		$("#MODrugInteraction").html(Data.MODrugInteraction);   			//��ҩ���໥���á�
		$("#MOStorMethod").html(Data.MOStorMethod);   			//�����ط����� 
		$("#MOToxicityTips").html(Data.MOToxicityTips);   			//��������ʾ�� 
		$("#MOHealthTips").html(Data.MOHealthTips);   			//��������ʾ�� 
		
		
	},"json",false)

}

function PrintMethod(){
	var LODOPPRTSTATS=LODOP.PRINT();
	if(LODOPPRTSTATS){
		window.close();	
	}
	return;	
}

//lodop��ӡ
function UlcerPrint(){
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	LODOP.ADD_PRINT_HTM(0,0,"210mm","297mm",document.documentElement.innerHTML);
	return;
 }
 
 //��ӡ
 function print(){
	 UlcerPrint();
	 PrintMethod();

 }