$(function(){
	setTimeout("DelayedPrint()","500");   ///����LODOP��׼��ʱ�� 	
})
function DelayedPrint(){
	InitParams();
	PrintData();
}

function InitParams(){
	PrtTemp	= getPrtTempDomObj();
}

function PrintData(){
	
	LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	for(i in jsonObjArr){
		i==0?"":LODOP.NEWPAGEA(); //NEWPAGE->NEWPAGEA
		PrintCst(jsonObjArr[i]);
	}
	var PrintRet = LODOP.PRINT();
	if(PrintRet){
		parent.printNext();	
	}
	
	return;
	
	runClassMethod("web.DHCEMConsultQuery","GetCstPrintConsByAdm",{"AdmID":EpisodeID},function(jsonString){	 //GetCstPrintCons
		if(jsonString==""){return;}
		var jsonObjArr = jsonString;
		LODOP = getLodop();
		LODOP.PRINT_INIT("CST PRINT");
		LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
		for(i in jsonObjArr){
			i==0?"":LODOP.NEWPAGEA(); //NEWPAGE->NEWPAGEA
			PrintCst(jsonObjArr[i]);
		}
		var PrintRet = LODOP.PRINT();
		if(PrintRet){
			parent.printNext();	
		}
	},'json',true)	
}

function PrintCst(jsonObj){
	$("body").html(PrtTemp);
	
	$("#tiCstTypeDesc").html(jsonObj.CstTypeDesc);
	$("#patName").html(jsonObj.PatName+"("+jsonObj.PatSex+")");
	$("#patInLoc").html(jsonObj.PatLoc);
	$("#inHospNo").html(jsonObj.MedicareNo);
	$("#patSeatNo").html(jsonObj.PatBed);
	$("#patAge").html(jsonObj.PatAge); //hxy 2022-09-02
	
	$("#CstRLoc").html(jsonObj.CstRLoc);
	$("#CstRUser").html(jsonObj.CstRUser);
	
	$("#CstTrePro").html(jsonObj.CstTrePro.replace(/\r/g,"<br/>"));
	$("#CstPurpose").html(jsonObj.CstPurpose.replace(/\r/g,"<br/>"));
	$("#CsOpinion").html(jsonObj.CsOpinion.replace(/\r/g,"<br/>"));
	
	$("#CstNDateTime").html(jsonObj.CstNDate+"    "+jsonObj.CstNTime);  
	$("#CsLocDesc").html(jsonObj.CsLocDesc);  
	if(jsonObj.CsUser!="") $("#CstRDoctor").html(jsonObj.ConsPrvTp+"-"+jsonObj.CsUser);  
	$("#CstCstType").html(jsonObj.CsProp);  /// ��������

	$("#CstPhone").html(jsonObj.CstPhone);  
	$("#CstRPhone").html(jsonObj.CstRPhone);  
	$("#CstRDateTime").html(jsonObj.CstRDate+"    "+jsonObj.CstRTime); 
	LODOP.ADD_PRINT_HTM(0,0,"210mm","297mm",$("body").html());
	$("body").html("");
	return; 
}

function getPrtTempDomObj(){
	var prtTmpHtml="";
	prtTmpHtml=prtTmpHtml+"<style>";
	prtTmpHtml=prtTmpHtml+" .prtTitleDiv{width:210mm;} ";
	prtTmpHtml=prtTmpHtml+"	.textOver{white-space: nowrap;overflow: hidden;text-overflow: ellipsis;} ";
	prtTmpHtml=prtTmpHtml+"	table,table tr th, table tr td { border:2px solid #000000;font-size:5mm;box-sizing:border-box;text-overflow: ellipsis;} ";
	prtTmpHtml=prtTmpHtml+"	table {line-height:8mm;max-height:8mm;text-align: center;border-collapse:collapse;table-layout: fixed;border-spacing: 0;} ";
	prtTmpHtml=prtTmpHtml+"	.td1{width:36mm;max-width:36mm;min-width:36mm;} ";
	prtTmpHtml=prtTmpHtml+"	.td2{width:60mm;max-width:60mm;min-width:60mm;}";
	prtTmpHtml=prtTmpHtml+"	.td3{width:36mm;max-width:36mm;min-width:36mm;} ";
	prtTmpHtml=prtTmpHtml+"	.td4{width:60mm;max-width:60mm;min-width:60mm;} ";
	prtTmpHtml=prtTmpHtml+"	.tdText{text-align: left;} ";
	prtTmpHtml=prtTmpHtml+"	.imgDiv,.img{width:81mm;height:13.5mm;	} ";
	prtTmpHtml=prtTmpHtml+"	.imgDiv{padding-left:60mm;	} ";
	prtTmpHtml=prtTmpHtml+"	.prtTitleDiv{height:15mm;line-height:15mm;} ";
	prtTmpHtml=prtTmpHtml+"	.prtTitle{font-size:7.38mm;font-weight:bold;} ";
	prtTmpHtml=prtTmpHtml+"	.CstCstType{font-size:4.83mm;} ";	
	prtTmpHtml=prtTmpHtml+" .CstTrePro{height:45mm;max-height:45mm;min-height:45mm;width:156mm;max-width:156mm;min-width:156mm;padding:3mm;word-break:break-all;white-space:normal;} ";
	prtTmpHtml=prtTmpHtml+"	.CstPurpose{height:45mm;max-height:45mm;min-height:45mm;width:156mm;max-width:156mm;min-width:156mm;padding:3mm;word-break:break-all;white-space:normal;} ";
	prtTmpHtml=prtTmpHtml+"	.CsOpinion{height:100mm;max-height:100mm;min-height:100mm;width:156mm;max-width:156mm;min-width:156mm;padding:3mm;word-break:break-all;white-space:normal;} ";
	prtTmpHtml=prtTmpHtml+"	#CsOpinion{white-space: pre-wrap;} ";
	prtTmpHtml=prtTmpHtml+"</style>";
	
	prtTmpHtml=prtTmpHtml+"<div class='bodyDiv' style='width: 195mm;'>";
	prtTmpHtml=prtTmpHtml+	"<div style='text-align: center;' class='prtTitleDiv textOver'>"+
								"<span class='prtTitle' style=' '>�����¼(</span>"+
								"<span class='prtTitle' id='tiCstTypeDesc'></span>"+
								"<span class='prtTitle'>)</span>"+
								"<span class='CstCstType' id='CstCstType'></span>"+
							"</div>"+
							"<div>"+
								"<table cellspacing='0' cellpadding='0'>"+
									"<tr>"+
										"<td class='td1'>��������:</td>"+
										"<td class='td2 tdText' id='patName'></td>"+
										"<td class='td3'>�������:</td>"+
										"<td class='td4 tdText' id='patInLoc'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'>���ߴ���:</td>"+
										"<td class='td2 tdText'  id='patSeatNo'></td>"+
										"<td class='td3'>סԺ��:</td>"+
										"<td class='td4 tdText' id='inHospNo'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'>��������:</td>"+
										"<td class='td2 tdText' id='patAge'></td>"+
										"<td class='td3' id='consSendDoc'>�������:</td>"+
										"<td class='td4 tdText' id='CstRLoc'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'  id='consSendDoc'>����ҽ��:</td>"+
										"<td class='td2 tdText' id='CstRUser'></td>"+
										"<td class='td3'>��ϵ�绰:</td>"+
										"<td class='td4 tdText' id='CstPhone'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'>��Ҫ����:</td>"+
										"<td class='tdText CstTrePro textOver' id='CstTrePro' colspan='3'></td>"+
									"</tr>"+
									
									"<tr>"+
										"<td>����Ŀ��:</td>"+
										"<td class='tdText CstPurpose textOver' id='CstPurpose' colspan='3'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'>�������:</td>"+
										"<td class='tdText CsOpinion textOver'  id='CsOpinion' colspan='3'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'>����ʱ��:</td>"+
										"<td class='tdText'  id='CstNDateTime' colspan='3'></td>"+
									"</tr>"+
									"<tr id='LocTr'>"+
										"<td class='td1'>�������:</td>"+
										"<td class='td2 tdText' id='CsLocDesc'></td>"+
										"<td class='td3' id='consReceiveDoc'>����ҽ��:</td>"+
										"<td class='td4 tdText' id='CstRDoctor'></td>"+
									"</tr>"+
									"<tr>"+
										"<td class='td1'>��ϵ�绰:</td>"+
										"<td class='td2 tdText' id='CstRPhone'></td>"+
										"<td class='td3'>����ʱ��:</td>"+
										"<td class='td4 tdText' id='CstRDateTime'></td>"+
									"</tr>"+
								"<table>"+
							"</div>"
	prtTmpHtml=prtTmpHtml+"</div>";	
	return prtTmpHtml;
}