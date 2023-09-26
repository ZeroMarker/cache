///print.patcard.js  
///¥Ú”°“ª¿¿ø®
///Creator£∫      lvpeng
///CreatDate£∫    2016-08-23

$(document).ready(function() {
	
	$("#prtpatcard").on('click',function(){	
		//alert($("#EpisodeID").val())
		runClassMethod(
   			"web.DHCEMPatCard",
   			 "getData",
   			 {   
	   			 'EpisodeID':$("#EpisodeID").val()
	   		 },function(data){
		   		 
			   		 printBPC(data);
		   		 
		   		             },"json")
		
				
	});
	
	})

 ///CT				
function printBPC(data){
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_PatCard"); 
		   		 	   //var MyPara="";	
					   var MyPara="PatName"+String.fromCharCode(2)+data.PatName;
					   MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+data.PatSex;
					   MyPara=MyPara+"^PatInDep"+String.fromCharCode(2)+data.PatInDep;
					   MyPara=MyPara+"^PatSeat"+String.fromCharCode(2)+data.PatSeat;
					   MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+data.PatAge;
					   MyPara=MyPara+"^PatRegNo"+String.fromCharCode(2)+data.PatRegNo;
					   MyPara=MyPara+"^PatYear"+String.fromCharCode(2)+data.PatYear;				 					   
					   MyPara=MyPara+"^PatDiagnose"+String.fromCharCode(2)+data.PatDiagnose;
    		
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   		   
		   	
}
