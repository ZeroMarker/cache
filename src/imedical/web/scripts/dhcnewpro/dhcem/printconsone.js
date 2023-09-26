var LODOP="";
$(document).ready(function(){
	setTimeout("DelayedPrint()","500");   ///����LODOP��׼��ʱ�� 
})

function DelayedPrint(){
	LODOP = getLodop();
	InitPage();
	PrintCons();
}

function InitPage(){
	if(CsType=="Nur"){
		$("#consSendDoc").html("���뻤ʿ:");
		$("#consReceiveDoc").html("���ﻤʿ:");	
	}	
}

function PrintCons(){
	try{
		runClassMethod("web.DHCEMConsultQuery","GetCstPrintCons",{"CstItmIDs":CstItmIDs},function(jsonString){	
			var jsonObjArr = jsonString;
			for(i in jsonObjArr){
				PrintCst(jsonObjArr[i]);
				UlcerPrint();
				PrintMethod();
			}
			
		},'json',true)	
	}catch(e){alert(e.message)}

	$('input,textarea').not("#print").attr("readonly","readonly");
}

function PrintMethod(){
	var LODOPPRTSTATS=LODOP.PRINT();
	if(LODOPPRTSTATS){
		window.close();	
	}
	return;	
}

//��ӡ
function UlcerPrint(){
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	LODOP.ADD_PRINT_HTM(0,0,"210mm","297mm",document.documentElement.innerHTML);
	return;
 }

function PrintCst(jsonObj){
	$("#tiCstTypeDesc").html(jsonObj.CstTypeDesc);
	$("#patName").html(jsonObj.PatName+"("+jsonObj.PatSex+")");
	$("#patInLoc").html(jsonObj.PatLoc);
	$("#inHospNo").html(jsonObj.MedicareNo);
	$("#patSeatNo").html(jsonObj.PatBed);
	
	$("#CstRLoc").html(jsonObj.CstRLoc);
	$("#CstRUser").html(jsonObj.CstRUser);
	
	$("#CstTrePro").html(jsonObj.CstTrePro.replace(/\r/g,"<br/>"));
	$("#CstPurpose").html(jsonObj.CstPurpose.replace(/\r/g,"<br/>"));
	$("#CsOpinion").html(jsonObj.CsOpinion.replace(/\r/g,"<br/>"));
	
	$("#CstNDateTime").html(jsonObj.CstNDate+"    "+jsonObj.CstNTime);  
	$("#CsLocDesc").html(jsonObj.CsLocDesc);  
	if(jsonObj.CsUser!="") $("#CstRDoctor").html(jsonObj.ConsPrvTp+"-"+jsonObj.CsUser);  
	//$("#CstCstType").html(jsonObj.CstCstType);
	$("#CstCstType").html(jsonObj.CsProp);  /// ��������

	$("#CstPhone").html(jsonObj.CstPhone);  
	$("#CstRPhone").html(jsonObj.CstRPhone);  
	$("#CstRDateTime").html(jsonObj.CstRDate+"    "+jsonObj.CstRTime);  	
}