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
			
		$("#PatName").html("PatName : "+Data.PatName);				// ��������
       	//$("#PatNo").html(Data.PatNo);							// �ǼǺ�
       	$("#PatSex").html("Sex :"+Data.PatSex);				// �Ա�
       	$("#PatAge").html("Age : "+Data.PatAge);				// ����
      	$("#AdmDate").html("AdmTime��"+Data.AdmDate);    		//��������
      	$("#AdmLoc").html("AdmLoc��"+Data.AdmLoc);
      	$("#Adress").html("Address : "+Data.Address);
      	$("#Number").html("SysNo : "+Data.MOSysNo);			//ϵͳ���
		$("#DecoctingVessel").html(Data.MODecVessel);   		//��������.
		//$("#SoakingWater").html(Data.MOSoakWater);  			//����ˮ��.
		$("#SoakingTime").html(Data.MOSoakTime);  				//����ʱ��.
		$("#SoakingTimes").html(Data.MODecTimes);  				//�������.
		$("#DecoctingMethod").html(Data.MODecMethod);   		//������󷽷�.
		//$("#DecoctingMethodFirst").html(Data.MODecFirFried);   	//��һ��.
		//$("#DecoctingMethodSecond").html(Data.MODecSecFried);   //�ڶ���.
		$("#DecoctingMethodFirst").html("<strong>[Decoction water consumption]</strong>"+"&nbsp;"+Data.MOSoakWater+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<strong>[Decoction time]</strong>"+"&nbsp;"+Data.MOSoakTime);   	//��һ��.
		$("#DecoctingMethodSecond").html("<strong>[Decoction water consumption]</strong>"+"&nbsp;"+Data.MOSoakWater2+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<strong>[Decoction time]</strong>"+"&nbsp;"+Data.MOSoakTime2);   	//�ڶ���.
		$("#MedicationTemperature").html(Data.MOMedTemp);   	//��ҩ�¶�.
		$("#MedicationTime").html(Data.MOMedTime);   			//��ҩʱ��.
		$("#MedicationTimes").html(Data.MOMedTimes);  			//��ҩ����.
		$("#Dosage").html(Data.MODosage);   					//��ҩ����.
		$("#SpecialObey").html(Data.MOSpecialObey);   			//�������.
		$("#StorageMethod").html(Data.MOStorageMethod);   		//���淽��.
		$("#MODecTemp").html(Data.MODecTemp);  					//�����¶�
		$("#title").html(LgHospDesc+"Hospital Drug Order Service Sheet")
			
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