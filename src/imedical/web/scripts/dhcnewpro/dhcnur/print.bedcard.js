///print.bedcard.js  
///¥Ú”°¥≤Õ∑ø®
///Creator£∫      huaxiaoying
///CreatDate£∫    2016-08-22

$(document).ready(function() {
	
	$("#prtbedcard").on('click',function(){	
		//alert($("#EpisodeID").val())
		runClassMethod(
   			"web.DHCEMBedCard",
   			 "getData",
   			 {   
	   			 'EpisodeID':$("#EpisodeID").val(),
	   			 'RegNo':$("#RegNo").val(),
	   			 'LgHospID':LgHospID //2017-01-23
	   		 },function(data){
		   		     
			   		 printBHC(data);
		   		 
		   		             },"json")
		
				
	});
	
	})

 ///CT				
function printBHC(data){
  
   //alert(data.PatName)
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_BedCard"); 
		   		 	   //var MyPara="";	
					   var MyPara="PatName"+String.fromCharCode(2)+data.PatName;
					   MyPara=MyPara+"^PatNum"+String.fromCharCode(2)+data.PatNum;
					   MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+data.PatSex;
					   MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+data.PatAge;
					   MyPara=MyPara+"^PatInDep"+String.fromCharCode(2)+data.PatInDep;
					   MyPara=MyPara+"^PatCost"+String.fromCharCode(2)+data.PatCost;
					   MyPara=MyPara+"^PatDate"+String.fromCharCode(2)+data.PatDate;
					   MyPara=MyPara+"^PatDiagnose"+String.fromCharCode(2)+data.PatDiagnose;
					   MyPara=MyPara+"^HosName2"+String.fromCharCode(2)+data.HospDesc; //2017-01-19
    		
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   		   
		   	
}
