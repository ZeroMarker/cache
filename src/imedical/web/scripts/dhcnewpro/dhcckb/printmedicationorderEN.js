var LODOP="";
$(document).ready(function(){
	setTimeout("DelayedPrint()","500");   ///给与LODOP的准备时间 
	$("#Print").on("click",function(){
		print();// 调用打印
	}) 
})

function DelayedPrint(){
	LODOP = getLodop();
	PrintCons();
}
//预留取数据方法
function PrintCons(){
	
	runClassMethod("web.DHCCKBMedicationOrder","getMedOrder",{ID:medOrderID},function(Data){
			
		$("#PatName").html("PatName : "+Data.PatName);				// 患者姓名
       	//$("#PatNo").html(Data.PatNo);							// 登记号
       	$("#PatSex").html("Sex :"+Data.PatSex);				// 性别
       	$("#PatAge").html("Age : "+Data.PatAge);				// 年龄
      	$("#AdmDate").html("AdmTime："+Data.AdmDate);    		//就诊日期
      	$("#AdmLoc").html("AdmLoc："+Data.AdmLoc);
      	$("#Adress").html("Address : "+Data.Address);
      	$("#Number").html("SysNo : "+Data.MOSysNo);			//系统编号
		$("#DecoctingVessel").html(Data.MODecVessel);   		//煎煮器皿.
		//$("#SoakingWater").html(Data.MOSoakWater);  			//浸泡水量.
		$("#SoakingTime").html(Data.MOSoakTime);  				//浸泡时间.
		$("#SoakingTimes").html(Data.MODecTimes);  				//煎煮次数.
		$("#DecoctingMethod").html(Data.MODecMethod);   		//特殊煎煮方法.
		//$("#DecoctingMethodFirst").html(Data.MODecFirFried);   	//第一煎.
		//$("#DecoctingMethodSecond").html(Data.MODecSecFried);   //第二煎.
		$("#DecoctingMethodFirst").html("<strong>[Decoction water consumption]</strong>"+"&nbsp;"+Data.MOSoakWater+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<strong>[Decoction time]</strong>"+"&nbsp;"+Data.MOSoakTime);   	//第一煎.
		$("#DecoctingMethodSecond").html("<strong>[Decoction water consumption]</strong>"+"&nbsp;"+Data.MOSoakWater2+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<strong>[Decoction time]</strong>"+"&nbsp;"+Data.MOSoakTime2);   	//第二煎.
		$("#MedicationTemperature").html(Data.MOMedTemp);   	//服药温度.
		$("#MedicationTime").html(Data.MOMedTime);   			//服药时间.
		$("#MedicationTimes").html(Data.MOMedTimes);  			//服药次数.
		$("#Dosage").html(Data.MODosage);   					//服药剂量.
		$("#SpecialObey").html(Data.MOSpecialObey);   			//特殊服法.
		$("#StorageMethod").html(Data.MOStorageMethod);   		//储存方法.
		$("#MODecTemp").html(Data.MODecTemp);  					//煎煮温度
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

//lodop打印
function UlcerPrint(){
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	LODOP.ADD_PRINT_HTM(0,0,"210mm","297mm",document.documentElement.innerHTML);
	return;
 }
 
 //打印
 function print(){
	 UlcerPrint();
	 PrintMethod();

 }