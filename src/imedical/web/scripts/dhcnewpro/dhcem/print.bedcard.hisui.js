///print.bedcard.hisui.js  
///打印床头卡
///Creator：      huaxiaoying
///CreatDate：    2016-08-22
///Modify:zhouxin
///ModifDate:2018-06-25
function printBedCard(){
	$.ajax({
		  dataType:'json',	 
          url : "websys.Broker.cls", 
          data : {ClassName:"web.DHCEMBedCard",
          		  MethodName:"getData",
          		  EpisodeID:$("#EpisodeID").val(),
          		  RegNo:$("#RegNo").val(),
          		  LgHospID:LgHospID}, 
          success : function(data){
	          	if(data==""){
		        	$.messager.alert("提示:","获取数据为空！");  		
		        	return;
		        }
		        if(data==-1){
		        	$.messager.alert("提示:","当前病人非留观病人！");  		
		        	return;
		        }
		        
		        if(data==-2){
		        	$.messager.alert("提示:","患者已经离院！");  		
		        	return;
		        }
				printBHC(data)
          } 
    }); 
}			
function printBHC(data){	
	var MyPara="PatName"+String.fromCharCode(2)+data.PatName;
	MyPara=MyPara+"^PatNum"+String.fromCharCode(2)+data.PatNum;
	MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+data.PatSex;
	MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+data.PatAge;
	MyPara=MyPara+"^PatInDep"+String.fromCharCode(2)+data.PatInDep;
	MyPara=MyPara+"^PatCost"+String.fromCharCode(2)+data.PatCost;
	MyPara=MyPara+"^PatDate"+String.fromCharCode(2)+data.PatDate;
	MyPara=MyPara+"^PatDiagnose"+String.fromCharCode(2)+data.PatDiagnose;
	MyPara=MyPara+"^HosName2"+String.fromCharCode(2)+data.HospDesc; //2017-01-19

	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_BedCard"); 
	if (typeof getLodop ==="function") {
		var LODOP = getLodop();
		LODOP.PRINT_INIT("CST PRINT");
		DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
		var printRet = LODOP.PRINT();
	}else{
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFunHDLP(myobj,MyPara,"");
	}
	return;
	   	   	
}

//hxy 2019-11-19 PDA 信息条码
function printPDACard(seatFlag){
	$.ajax({
		  dataType:'json',	 
          url : "websys.Broker.cls", 
          data : {ClassName:"web.DHCEMBedCard",
          		  MethodName:"getData",
          		  EpisodeID:$("#EpisodeID").val(),
          		  RegNo:$("#RegNo").val(),
          		  SeatFlag:seatFlag, //hxy 2019-12-03
          		  LgCtLocID:LgCtLocID, //hxy 2019-12-03
          		  LgHospID:LgHospID}, 
          success : function(data){ 
				  printPDA(data)
          } 
    }); 
}			
function printPDA(data){
 	   DHCP_GetXMLConfig("InvPrintEncrypt","PDACardE"); 	
	   var MyPara="PatName"+String.fromCharCode(2)+data.PatName;
	   MyPara=MyPara+"^PatNum"+String.fromCharCode(2)+data.PatNum;
	   MyPara=MyPara+"^PatNumBar"+String.fromCharCode(2)+data.PatNum;
	   MyPara=MyPara+"^Hosp"+String.fromCharCode(2)+data.HospDesc;
	   MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+data.PatSex;
	   MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+data.PatAge;
	   var NowTime=(new Date().Format("hh:mm:ss"));
	   var NowDate=(new Date().Format("yyyy-MM-dd"));
	   var PatDate=NowDate+" "+NowTime;
	   MyPara=MyPara+"^DateTime"+String.fromCharCode(2)+PatDate;
	   MyPara=MyPara+"^Queue"+String.fromCharCode(2)+data.Queue;
	   var myobj=document.getElementById("ClsBillPrint");
	   DHCP_PrintFunHDLP(myobj,MyPara,"");
}

