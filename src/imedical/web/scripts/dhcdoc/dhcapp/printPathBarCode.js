//sufan 2018-02-06
//��ӡ���鵥���߲���
//׼����ӡ����

function PrintBar(ExaReqID,Flag)
{
	runClassMethod("web.DHCAPPPrintCom","GetPathReqData",{"ExaReqID":ExaReqID,"Flag":Flag},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var ExaReqObj = jsonString;
			PrintBarCode(ExaReqObj);
		}
	},'json',false)
}
// ��ӡ���鵥���߲���
function PrintBarCode(ExaReqObj)//print barcode
{
    var oeoriIdStr=ExaReqObj.OeordExeStr;				 //ִ�м�¼��,
    var LabNoStr=ExaReqObj.LabNoStr;   				 	 //�걾�Ŵ�
    var recLab = ""; 				 					 //���ձ걾�洢  ���޼���ƽ���
    var disposeStatCode=ExaReqObj.DisposeStatCode;		 //���ѱ�־
    var queryTypeCode=ExaReqObj.BarType					 //���ֲ���ͼ��� ����:BLDO,����:JYDO
    var WebIp=ExaReqObj.WebIP  							 //webip
    if (LabNoStr==""){
		$.messager.alert('��ʾ','�걾��Ϊ��!','danger');  
    	return;
    }
    if (disposeStatCode=="UnPaid") {
		$.messager.alert('��ʾ','��δ����ҽ��!���ܴ�ӡ!','danger');   
    	return;
    }	
	
    var sortStr = sortByLabNo(oeoriIdStr, LabNoStr)
    var sortStrArray = sortStr.split("@");
    oeoriIdStr= sortStrArray[0];
    LabNoStr = sortStrArray[1];
    //alert(oeoriIdStr+"##"+LabNoStr+"##"+queryTypeCode+"##"+WebIp)
    showNurseExcuteSheetPreview(oeoriIdStr, LabNoStr, "P", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")
}


// ����ִ�м�¼id�ͱ걾��
function sortByLabNo(oeorIdStr, labNoStr) {
	var oeordIdArray = oeorIdStr.split("$")
	var labNoArray = labNoStr.split("$")
	var tmpLabNo = ""
	var tmpOeordId = "";
	var index = "";
	var tmpLabNoArray = [];
	var tmpOrderIdArray = [];
	var tmpCollectArray = [];
	for (var i = 0; i < oeordIdArray.length; i++) {
		if (!tmpCollectArray[i]) {
			tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[i]   //ֵ
			tmpLabNoArray[tmpLabNoArray.length] = labNoArray[i]
		} else {
			continue;
		}
		for (var j = i + 1; j < oeordIdArray.length; j++) {
			if ((labNoArray[i] == labNoArray[j]) && (!tmpCollectArray[j])) {
				tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[j]
				tmpLabNoArray[tmpLabNoArray.length] = labNoArray[j]
				tmpCollectArray[j] = 1	
			}
		}
	}
	return tmpOrderIdArray.join("^") + "@" + tmpLabNoArray.join("^")
}
///��װclickonce���÷���
///20170727 Songchao add by qqa 2017-08-25 win10��ӡ
function showNurseExcuteSheetPreview(orderItemIdStr, seqNoStr, type, queryCode, webIp, savePrintHistory, printNum, xmlName) {
	var link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreview&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + webIp
		 + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName;
	if(typeof websys_writeMWToken=='function') link=websys_writeMWToken(link);
    window.open(link,"���ڴ�ӡ...", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}

/// ��ȡ�������뵥��ǩ��ӡ���� 2018-03-12 bianshuai
/// ����� ���ô����뺯��
function PrintPisBarCode(Oeori){
	
	runClassMethod("web.DHCAPPPrintCom","GetPisPriBarContent",{"Oeori":Oeori},function(jsonString){
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var ExaReqObj = jsonString;
			PrintBarCode(ExaReqObj);
		}
	},'json',false)
}