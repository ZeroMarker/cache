//sufan 2018-02-06
//打印检验单或者病理单
//准备打印数据

function PrintBar(ExaReqID,Flag)
{
	runClassMethod("web.DHCAPPPrintCom","GetPathReqData",{"ExaReqID":ExaReqID,"Flag":Flag},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var ExaReqObj = jsonString;
			PrintBarCode(ExaReqObj);
		}
	},'json',false)
}
// 打印检验单或者病理单
function PrintBarCode(ExaReqObj)//print barcode
{
    var oeoriIdStr=ExaReqObj.OeordExeStr;				 //执行记录串,
    var LabNoStr=ExaReqObj.LabNoStr;   				 	 //标本号串
    var recLab = ""; 				 					 //接收标本存储  有无检验科接收
    var disposeStatCode=ExaReqObj.DisposeStatCode;		 //付费标志
    var queryTypeCode=ExaReqObj.BarType					 //区分病理和检验 病理:BLDO,检验:JYDO
    var WebIp=ExaReqObj.WebIP  							 //webip
    if (LabNoStr==""){
		$.messager.alert('提示','标本号为空!','danger');  
    	return;
    }
    if (disposeStatCode=="UnPaid") {
		$.messager.alert('提示','有未交费医嘱!不能打印!','danger');   
    	return;
    }	
	
    var sortStr = sortByLabNo(oeoriIdStr, LabNoStr)
    var sortStrArray = sortStr.split("@");
    oeoriIdStr= sortStrArray[0];
    LabNoStr = sortStrArray[1];
    //alert(oeoriIdStr+"##"+LabNoStr+"##"+queryTypeCode+"##"+WebIp)
    showNurseExcuteSheetPreview(oeoriIdStr, LabNoStr, "P", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")
}


// 按照执行记录id和标本号
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
			tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[i]   //值
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
///封装clickonce调用方法
///20170727 Songchao add by qqa 2017-08-25 win10打印
function showNurseExcuteSheetPreview(orderItemIdStr, seqNoStr, type, queryCode, webIp, savePrintHistory, printNum, xmlName) {
	var link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreview&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + webIp
		 + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName;
	if(typeof websys_writeMWToken=='function') link=websys_writeMWToken(link);
    window.open(link,"正在打印...", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}

/// 提取病理申请单标签打印内容 2018-03-12 bianshuai
/// 体检组 调用打条码函数
function PrintPisBarCode(Oeori){
	
	runClassMethod("web.DHCAPPPrintCom","GetPisPriBarContent",{"Oeori":Oeori},function(jsonString){
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var ExaReqObj = jsonString;
			PrintBarCode(ExaReqObj);
		}
	},'json',false)
}