var LODOP="";
$(document).ready(function(){
	setTimeout("DelayedPrint()","2200");   ///给与LODOP的准备时间 
})

function DelayedPrint(){
	LODOP = getLodop();
	InitPage();
	PrintCons();
}

function InitPage(){
	if(CsType=="Nur"){
		$("#consSendDoc").html("申请护士:");
		$("#consReceiveDoc").html("会诊护士:");	
	}	
}

function PrintCons(){
	try{
		runClassMethod("web.DHCEMConsultQuery","GetCstPrintCons",{"CstItmIDs":CstItmIDs,"LgHospID":LgHospID},function(jsonString){	
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

//打印
function UlcerPrint(){
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	if(PRINTHEADER==1){ //hxy 2022-09-02
		LODOP.ADD_PRINT_TABLE("3mm","3mm","210mm","297mm",document.documentElement.innerHTML);
	}else{
		LODOP.ADD_PRINT_HTM("3mm","3mm","210mm","297mm",document.documentElement.innerHTML);
	}
	
	return;
 }

function PrintCst(jsonObj){
	$("#HospDesc").html(LgHospDesc);
	$("#tiCstTypeDesc").html(jsonObj.CstTypeDesc);
	$("#patName").html(jsonObj.PatName+"("+jsonObj.PatSex+")");
	$("#patInLoc").html(jsonObj.PatLoc);
	$("#inHospNo").html(jsonObj.MedicareNo);
	$("#patSeatNo").html(jsonObj.PatBed);
	$("#patAge").html(jsonObj.PatAge);
	
	$("#CstRLoc").html(jsonObj.CstRLoc);
	if(jsonObj.CstRUserImg!=""){ //hxy 2020-09-25 st
		$("#CstRUserImg").attr("src",jsonObj.CstRUserImg);
	}else{ //ed
	$("#CstRUser").html(jsonObj.CstRUser);
	}
	
	$("#CstTrePro").html($_TrsTxtToSymbol(jsonObj.CstTrePro.replace(/\r/g,"<br/>"))); //hxy 2022-04-01 st
	$("#CstPurpose").html($_TrsTxtToSymbol(jsonObj.CstPurpose.replace(/\r/g,"<br/>")));
	$("#CsOpinion").html($_TrsTxtToSymbol(jsonObj.CsOpinion.replace(/\r/g,"<br/>"))); //ed
	
	$("#CstNDateTime").html(jsonObj.CstNDate+"    "+jsonObj.CstNTime);  
	$("#CsLocDesc").html(jsonObj.CsLocDesc);  
	//if(jsonObj.CsUser!="") $("#CstRDoctor").html(jsonObj.ConsPrvTp+"-"+jsonObj.CsUser);  //hxy 2020-09-25 st
	if(jsonObj.CsUserImg!="") { 
		$("#CstRDoctorImg").attr("src",jsonObj.CsUserImg); 
	}else{
		if(jsonObj.CsUser!="") $("#CstRDoctor").html(jsonObj.ConsPrvTp+"-"+jsonObj.CsUser); 
	} //ed
	//$("#CstCstType").html(jsonObj.CstCstType);
	$("#CstCstType").html(jsonObj.CsProp);  /// 会诊性质

	$("#CstPhone").html(jsonObj.CstPhone);  
	$("#CstRPhone").html(jsonObj.CstRPhone);  
	$("#CstRDateTime").html(jsonObj.CstRDate+"    "+jsonObj.CstRTime);  
	
	if(jsonObj.OtherLocDoc=="")return; //hxy 2021-03-05 st
	var OtherNum=jsonObj.OtherLocDoc.split("#").length; 
	var OtherArr=jsonObj.OtherLocDoc.split("#"); 
	var LocHtml="";
	if(OtherNum>0){
		for (i = 0; i < OtherNum; i++) {
		   	LocHtml=LocHtml+'<tr> <td class="td1">会诊科室:</td>';
			LocHtml=LocHtml+'<td class="td2 tdText">'+OtherArr[i].split("@")[0]+'</td>';
			if(CsType=="Nur"){
				LocHtml=LocHtml+'<td class="td3">会诊护士:</td>';
			}else{
			LocHtml=LocHtml+'<td class="td3">会诊医生:</td>';
			}
			if(OtherArr[i].split("@")[2]!=""){ //hxy 2021-06-04 st
				LocHtml=LocHtml+'<td class="td4 tdText"><img width="80" height="28" src="'+OtherArr[i].split("@")[2]+'" alt=""/></td></tr>  '			
			}else{ //ed
				LocHtml=LocHtml+'<td class="td4 tdText">'+OtherArr[i].split("@")[1]+'</td></tr>  '			
			}
		}
		$("#LocTr").before(LocHtml);
	} //ed	
}
