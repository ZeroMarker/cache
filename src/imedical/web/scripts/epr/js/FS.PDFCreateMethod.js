//与.net交互接口
var WEBBROWSER = function () {
	///<summary>
	///调用WebBrowser方法封装类
	///</summary>
	this.CreateStart = function (msg, episodeID, patientID, aDetails) {
		window.external.CreateStart(msg, episodeID, patientID, aDetails);
	};
	this.CreateFinish = function (msg) {
		window.external.CreateFinish(msg);
	};
	this.CreateNoItemFinish = function (msg) {
		window.external.CreateNoItemFinish(msg);
	};
	this.ItemCreateStart = function (message, episodeID, patientID, categoryID, categoryDetail, mrItemID, invokeMethod) {
		window.external.ItemCreateStart(message, episodeID, patientID, categoryID, categoryDetail, mrItemID, invokeMethod);
	};
	this.ItemCreateFinish = function (message, episodeID, patientID, mrItemID ) {
		window.external.ItemCreateFinish(message, episodeID, patientID, mrItemID);
	};
	this.CheckPDFExist = function (msg) {
		window.external.CheckPDFExist(msg);
	};
	this.SetupDHCCPDFCreator = function () {
		window.external.SetupDHCCPDFCreator();
	};
	this.SetOutputFileName = function (value) {
		window.external.SetOutputFileName(value);
	};
	this.StartOp = function () {
		window.external.StartOp();
	};
	this.FTPOp = function (param, schemeType, versionTypeCode) {
		window.external.FTPOp(param, schemeType, versionTypeCode);
	};
	this.SpecialFTPOp = function (param, schemeType, versionTypeCode, specialFlag, specialParam) {
		window.external.SpecialFTPOp(param, schemeType, versionTypeCode, specialFlag, specialParam);
	};
	this.ClearRedundantItem = function (episodeID, versionNum, correctMRItemList, schemeID) {
		window.external.ClearRedundantItem(episodeID, versionNum, correctMRItemList, schemeID);
	};
	this.AllFinishedOp = function () {
		window.external.AllFinishedOp();
	};
	this.AppendPDF = function (origianlFileName, appendFileName) {
		window.external.AppendPDF(origianlFileName, appendFileName);
	};
	this.IsFileReleased = function (fileName) {
		return window.external.IsFileReleased(fileName);
	};
	this.IsFileCreated = function (fileName) {
		return window.external.IsFileCreated(fileName);
	};
	this.PlatformDownload = function (episodeID, patientID, typeCode, subFlag) {
		return window.external.PlatformDownload(episodeID, patientID, typeCode, subFlag);
	};
	this.ThirdPartyDownload = function (episodeID, patientID, typeCode, categoryDetail) {
		return window.external.ThirdPartyDownload(episodeID, patientID, typeCode, categoryDetail);
	};
	this.CMDPrint = function (episodeID, patientID, typeCode) {
		return window.external.CMDPrint(episodeID, patientID, typeCode);
	};
	this.EPRPrint = function (episodeID, patientID, categoryDetail, pageInfoID, privacylevel, fileName) {
		return window.external.EPRPrint(episodeID, patientID, categoryDetail, pageInfoID, privacylevel, fileName);
	};
	this.EMRPrint = function (episodeID, patientID, categoryDetail, fileName) {
		return window.external.EMRPrint(episodeID, patientID, categoryDetail, fileName);
	};
	this.LocalFile = function (episodeID, patientID, typeCode) {
		return window.external.LocalFile(episodeID, patientID, typeCode);
	};
	this.WriteLog = function (logMessage) {
		window.external.WriteLog(logMessage);
	};
	this.MediaDownload = function (episodeID, patientID, typeCode, categoryDetail) {
		window.external.MediaDownload(episodeID, patientID, typeCode, categoryDetail);
	};
	this.NURSEPrint = function (episodeID, patientID, typeCode, categoryDetail, pageInfoID) {
		window.external.NURSEPrint(episodeID, patientID, typeCode, categoryDetail, pageInfoID);
	};
	this.DLLPrint = function (episodeID, patientID, typeCode) {
		return window.external.DLLPrint(episodeID, patientID, typeCode);
	};
	//this.CreateTimeOut = function (message) {
		//return window.external.CreateTimeOut(message);
	//};
};

/*
01.		检查报告    
02.		检验报告
04.		体温单
05.		住院证
06.		护理病历
06A              新版护理病历合并打印
06B              新版护理病历分项打印
07.		病历文书
08.		麻醉记录
09.		病理
10.		心电图
11.		费用清单
12.		临床路径
13.		输血申请单
14.		会诊记录
15.		手术清点单
17.		病理（FTP）
31.		长期医嘱单
32.		临时医嘱单
*/

//全局变量
//递归计数
var count = 0;
var globalArr = new Array();
var globalArrCount = 0;
var globalIsPageQueue = "";
var globalPageInfoID = 0;
var globalID = "";
var globalMRItemIDList = "";
var virtualPrinterName = "DHCC PDF Creator";
var fileNameGlobal = "";
var fileLogicPath = "";
var defaultPrinterNameGlobal = "";
var globalPrintItems = "";
var taskCount = 0;
var itemPrintJobCount = 0;

var openWindow = null;

//提交打印******************************************
function beginPDFCreate(){
	//debugger;
	globalPrintItems = "";
	globalMRItemIDList = "";
	//保存当前默认打印机名称，并把默认打印机指向虚拟打印机
	defaultPrinterNameGlobal = getDefPrinter();
	//检查是否安装虚拟打印机
	if (!checkPrinter(virtualPrinterName)){
		var myBrowser = new WEBBROWSER();
		myBrowser.SetupDHCCPDFCreator();
	}
	setDefPrinter(virtualPrinterName);
	
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		data: {
			EpisodeID: episodeID,
			PatientID: patientID,
			UserID: userID,
			SchemeID: schemeID,
			SpecialFlag: specialFlag,
			SpecialParam: specialParam,
			SelectItemID: selectItemID
		},
		type: 'post',
		async: false,
		dataType: 'json',
		timeout: 120000,
		success: function(data) {
			var arr = new Array();
			var arrAfterSort = new Array();
			if (data.TotalCount == 0) {
				alert("生成方案没有设置任何项目，请先设置生成方案");
				//var myBrowser = new WEBBROWSER(); 
				//myBrowser.CreateTimeOut("生成方案没有设置任何项目");
			}
			else {
				var aDetails = "";
				for (var i=0;i<data.Data.length;i++) {
					var record = data.Data[i];
					var id = record['id'];
					//var cgID = id.substring(0, 4);
					var cgID = id;
					var createType = record['createType'];
					var cdInfo = record['detailInfo'];
					var cdAttachType = record['detailAttachType'];
					var mrItemID = record['mrItemID'];
					var order = record['order'];
					var text = record['text'];
					var cspPath = record['cspPath'];
					var subFlag = record['subFlag'];
					
					var arrString = id + "|||" + cgID + "|||" + cdInfo + "|||" + order + "|||" + text + "|||" + cdAttachType + "|||" + cspPath + "|||" + mrItemID + "|||" + createType + "|||" + subFlag;
					var arrAfterSort = new Array();
					if (cdInfo != "") {
						arr.push(arrString);
					}
					
					if (globalMRItemIDList == "") {
						globalMRItemIDList = mrItemID;
					}
					else {
						globalMRItemIDList = globalMRItemIDList + "^" + mrItemID; 
					}
					if (aDetails=="") {
						aDetails = order + "^" + mrItemID + "^" + cgID;
					}
					else {
						aDetails = aDetails + "|||" + order + "^" + mrItemID + "^" + cgID;
					}
				}
				var myBrowser = new WEBBROWSER();
				//alert("CreateStart::"+aDetails);
				myBrowser.CreateStart("",episodeID,patientID,aDetails);
				//获取是否需要页码大排队
				if (needPageQueue == "Y") {
					printPageQueue(arr, true);
				}
				else {
					printPageQueue(arr, false);
				}
			}
		},
		error: function(jqXHR,textStatus) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(textStatus);
			alert(textStatus);
		}
	});
}

//单项超时后跳过错误项和完成项，生成后面的项目
function timeOut(itemID){
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		data: {
			EpisodeID: episodeID,
			PatientID: patientID,
			UserID: userID,
			SchemeID: schemeID,
			SpecialFlag: specialFlag,
			SpecialParam: specialParam,
			SelectItemID: selectItemID
		},
		type: 'post',
		async: false,
		dataType: 'json',
		timeout: 120000,
		success: function(data) {
			var arr = new Array();
			var arrAfterSort = new Array();
			
			if (data.TotalCount == 0) {
				var myBrowser = new WEBBROWSER();
				myBrowser.WriteLog("生成方案没有设置任何项目，请先设置生成方案");
				alert("生成方案没有设置任何项目，请先设置生成方案");
			}
			else {
				var current = false;
				var printedItems = "";
				for (var i=0;i<data.Data.length;i++) {
					var record = data.Data[i];
					var id = record['id'];
					//var cgID = id.substring(0, 4);
					var cgID = id;
					var createType = record['createType'];
					var cdInfo = record['detailInfo'];
					var cdAttachType = record['detailAttachType'];
					var mrItemID = record['mrItemID'];
					var order = record['order'];
					var text = record['text'];
					var cspPath = record['cspPath'];
					var subFlag = record['subFlag'];
					
					if (current) {
						var arrString = id + "|||" + cgID + "|||" + cdInfo + "|||" + order + "|||" + text + "|||" + cdAttachType + "|||" + cspPath+"|||" + mrItemID + "|||" + createType + "|||" + subFlag;
						var arrAfterSort = new Array();
						if (cdInfo != "") {
							arr.push(arrString)
						}
					}
					else {
						if (printedItems == "") {
							printedItems = id;
						}
						else {
							printedItems = printedItems + "^" + id; 
						}
					}
					
					if (itemID == id) {
						current = true;
					}
				}
				
				if (arr.length == 0) {
					return;
				}
				else {
					//获取是否需要页码大排队
					var isPageQueue = true;
					
					if (isPageQueue) {
						printPageQueue(arr, true);
					}
					else {
						printPageQueue(arr, false);
					}
				}
			}
		},
		error: function(jqXHR,textStatus) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(textStatus);
			alert(textStatus);
		}
	});
}

//按页码显示顺序排序，否则会按照用户选择的先后顺序而不是页面显示的先后顺序打印和排序页码。
function swapArr(arr,firstIndex,secondIndex) {
	var temp = arr[firstIndex];
	arr[firstIndex] = arr[secondIndex];
	arr[secondIndex] = temp;
}

function splitString(arrString) {
	var strs = new Array();
	strs = arrString.split("|||");
	return parseInt(strs[3]);
}

function sortArr(arr) {
	var len = arr.length, min, i, j;

	for (i=0; i<len; i=i+1) {
		min = i;
		// 比较最小项目和第i项之后的剩余数组项, 以寻找更小项
		for (j=i+1; j<len; j=j+1) {
			if (splitString(arr[min]) > splitString(arr[j])) {
				 min = j; 
			}
		}
		// 比较初始最小项和当前最小项, 如果不想等, 则交换两者位置
		if (i !== min) { 
			swapArr(arr,i, min); 
		}
	}
	// 返回经过排序的数组
	return arr;
}

//设置文件名
function getFileName(categoryID,text,categoryAttachType)
{
	var fileNameStr = "";

	if (categoryID == "CG07")	//07.病历文书
	{
		//07.病历文书
		var fileNameStr = categoryID;
		var allStr = new Array();
		allStr = text.split('!');
		var strsAL = "";
		if (allStr.length > 1) {
			if (categoryAttachType == "1")
			{
				strsAL = allStr[1];
			}
			else
			{
				strsAL = allStr[0];
			}
		}
		else {
			strsAL = allStr[0];
		}
		var strs = strsAL.split('^');
		var printType = strs[0];
		var aPatientID = strs[1];
		var aEpisodeID = strs[2];
		var aUserID = strs[3];
		var printTemplateID = strs[4];
		var aPrintTemplateDocID = strs[5];
		var instanceDataIDs = strs[6];
		fileNameStr = fileNameStr + "_" + printType + "_" + aPatientID + "_" + aEpisodeID + "_" + printTemplateID + "_" + aPrintTemplateDocID;
		return fileNameStr;
	}
	else if (categoryID == "CG71")	//71.三版病历文书
	{
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_" + text + "_" + text;
		return fileNameStr;
	}
	else if (categoryID == "CG36")	//36.龙岩二院住院病案首页(编目)
	{
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_" + text + "_" + text;
		return fileNameStr;
	}
	else if (categoryID == "CG15")
	{
		//手麻系统的麻醉记录单和手术清点单需要区分，手术清点单TypeParams为2
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_1_2";
		return fileNameStr;
	}
	else if (categoryID == "CGPI")
	{
		//这个类型是指需要归档的图片，比如png、jpeg、tiff等，这里的text就是typeParams
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_" + text + "_" + text;
		return fileNameStr;
	}
	else if (categoryID == "CG37")
	{
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_" + text + "_" + text;
		return fileNameStr;
	}
	else if (categoryID == "CG06B")
	{
		//新版护理分项打印，确保生成的文件名不重复
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_" + text + "_" + text;
		return fileNameStr;
	}
	else
	{
		//除病历文书外其他
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_1_1";
		return fileNameStr;
	}
}

//逻辑文件名
function getLogicPath()
{
	var logicPathStr = "/" + patientID + "/" + episodeID + "/epr/" + fileNameGlobal + ".pdf";
	return logicPathStr;
}

//生成前设置虚拟打印机的输出文件名
function startPrint(fileName)
{
	//alert("00");
	var myBrowser = new WEBBROWSER();
	myBrowser.SetOutputFileName(fileName);
	fileNameGlobal = fileName;
	myBrowser.StartOp();
}

//在一个归档项目内开始下一个打印作业前设置输出文件名
function startPrintJob(fileName)
{
	var myBrowser = new WEBBROWSER();
	myBrowser.SetOutputFileName(fileName);
	//fileNameGlobal = fileName;
	myBrowser.StartOp();
}

//生成单项结束后将生成项目的名称加到全局变量中
function finishPrint()
{
	var fileLogicPath = getLogicPath();
	if (globalPrintItems == ""){
		globalPrintItems = fileNameGlobal + "|" + fileLogicPath;
	}
	else{
		globalPrintItems = globalPrintItems + "#" + fileNameGlobal + "|" + fileLogicPath;
	}
}

//生成全部完成后的注册，上传操作
function upLoadFTP()
{
	var myBrowser = new WEBBROWSER();
	if (specialFlag == "")
	{
		myBrowser.FTPOp(globalPrintItems, schemeType, versionTypeCode);
	}
	else
	{
		myBrowser.SpecialFTPOp(globalPrintItems, schemeType, versionTypeCode, specialFlag, specialParam);
	}
}

//生成全部完成后清空多余的PDF文件
function clearRedundantItem()
{
	var myBrowser = new WEBBROWSER();
	myBrowser.ClearRedundantItem(episodeID,schemeType,globalMRItemIDList,schemeID);
}

function appendLocalFile(episodeID,patientID)
{
	setDefPrinter(virtualPrinterName);
	var myBrowser = new WEBBROWSER();
	myBrowser.LocalFile(episodeID, patientID, "CG08");
}

//打印********************************************
function printPageQueue(arr,isPageQueue) {
	var arrCount = arr.length;
    if (arrCount < 1) return;
	globalArr = arr;
	globalArrCount = arrCount;
	globalIsPageQueue = isPageQueue;
	
	//初始化页码信息
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		data: {
			Action: 'initpageinfo',
			IsPageQueue: isPageQueue
		},
		type: 'post',
		async: false,
		timeout: 5000,
		success: function(data) {
			if (data != '-1') {
				//成功
				var pageInfoID = parseInt(data);
				globalPageInfoID = pageInfoID;
				//递归打印所有项目
				printItem(arr,arrCount,isPageQueue,pageInfoID);
			}
		},
		error: function(jqXHR,textStatus) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(textStatus);
			alert(textStatus);
		}
	});
}

//递归打印所有项目
function printItem(arr, arrCount, isPageQueue, pageInfoID){
	var myBrowser = new WEBBROWSER(); 
	//myBrowser.ItemCreateStart(arr[count]);
	var strs = new Array();
	strs = arr[count].split("|||");
	
	var categoryID = strs[1];
	var categoryDetail =strs[2];
	var id = strs[0];
	var categoryAttachType = strs[5];
	var cspPath = strs[6];
	var mrItemID= strs[7];
	var createType = strs[8];
	var subFlag = strs[9];
	
	globalID = id;
	var para = {EpisodeID: episodeID, PatientID: patientID, CategoryDetail: categoryDetail, PageInfoID: pageInfoID, CategoryID: categoryID, MRItemID: mrItemID};
	
	itemPrintJobCount = 0;
	
	//进度条信息
	var curnum = (count+1)/arrCount;
	var bartext = "正在生成《"+strs[4]+"》，第"+(count+1)+"项，共"+arrCount+"项";
	$('#progressText').text(bartext);
	//获取生成的文件名
	fileName = getFileName(categoryID, categoryDetail, categoryAttachType);
	//设置虚拟打印机的输出文件名
	startPrint(fileName);
	if (categoryID == "PS"){
		printScan(para);
	}
	else{
		printCategory(para,categoryID,cspPath,createType,subFlag);
	}
}

//接口，打印下一项
function printNext(){
	if (openWindow != null)
	{
		openWindow.close();
	}
	var arr = globalArr;
	var arrCount = globalArrCount;
	var isPageQueue = globalIsPageQueue;
	var pageInfoID = globalPageInfoID;
	var id = globalID;
	
	//ajax 打印完记录打印项结束页码
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		data: {
			Action: 'setpageinfo',
			IsPageQueue: isPageQueue,
			PageInfoID: pageInfoID,
			AID: id
		},
		type: 'post',
		async: false,
		timeout: 6000000,
		success: function(data) {
			if (data != '-1') {
				//成功，递归打印下一个选中打印项，并刷新打印项表格显示页码信息
				var myBrowser = new WEBBROWSER();
				var strs = new Array();
				strs = arr[count].split("|||");
				var aMRItemID = strs[7];
				myBrowser.ItemCreateFinish(arr[count],episodeID,patientID,aMRItemID);
				var myBrowser = new WEBBROWSER();
				myBrowser.CheckPDFExist(globalPrintItems);
				count = count + 1;
				if (count < arrCount) {
					finishPrint();
					printItem(arr, arrCount, isPageQueue, pageInfoID);
				}
				//递归最后一项，打印完成后刷新打印项表格，并将count置0
				else {
					if (count = arrCount) {
						finishPrint();
						count = 0;
						//清理，打印记录，还原打印机设置
						afterPrint(arr, pageInfoID);
					}
				}
			}
		},
		error: function(jqXHR,textStatus) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(textStatus);
			alert(textStatus);
		}
	});
}

var categoryDetail;
function getUrl(cspUrl,para){
	detail = para.CategoryDetail;
	//避免get方法字符串超长
	if (detail.length > 1000)
	{
		categoryDetail = detail;
		detail = "";
	}
	
	var privacyLevel = ""
	if (schemeType != "")
	{
		privacyLevel = schemeType.substring(schemeType.length-2,schemeType.length);
	}
	
	var url = "";
	if (cspUrl.indexOf("?") > 0)
	{
		//含有?则后面使用&追加
		url = cspUrl + "&EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CategoryDetail=" + detail + "&PageInfoID=" + para.PageInfoID + "&Privacylevel=" + privacyLevel + "&SpecialFlag=" + specialFlag + "&SpecialParam=" + specialParam + "&userID=" + userID;
	}
	else
	{
		//不含?则第一个参数使用?
		url = cspUrl + "?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CategoryDetail=" + detail + "&PageInfoID=" + para.PageInfoID + "&Privacylevel=" + privacyLevel + "&SpecialFlag=" + specialFlag + "&SpecialParam=" + specialParam + "&userID=" + userID;
	}
	if (para.CategoryID == 'CG06B') {
		url = url + '&Type=' + detail;
	}
	return url;
}

function getCategoryDetail()
{
	return categoryDetail;
}

//各组打印接口********************************************
function printCategory(para,categoryID,cspPath,createType,subFlag)
{
	if (createType == "CREATETYPEFTP")
	{
		//心电图，本身是PDF，无需打印，直接下载
		var myBrowser = new WEBBROWSER();
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
		myBrowser.LocalFile(para.EpisodeID, para.PatientID, categoryID);
		printNext();
	}
	else if (createType == "CREATETYPEPLATFORMFTP")
	{
		var myBrowser = new WEBBROWSER();
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
		myBrowser.PlatformDownload(para.EpisodeID, para.PatientID, categoryID, subFlag);
		printNext();
	}
	else if (createType == "CREATETYPETHIRDPARTYFTP")
	{
		var myBrowser = new WEBBROWSER();
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
		myBrowser.ThirdPartyDownload(para.EpisodeID, para.PatientID, categoryID, para.CategoryDetail);
		printNext();
	}
	else if (createType == "CREATETYPEEXE")
	{
		//妇产cs检验，沈阳医大cs输血单
		var myBrowser = new WEBBROWSER();
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
		myBrowser.CMDPrint(para.EpisodeID, para.PatientID, categoryID);
		printNext();
	}
	else if (createType == "CREATETYPEEMR3")
	{
		try {
			var myBrowser = new WEBBROWSER();
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
			myBrowser.EMRPrint(para.EpisodeID, para.PatientID, para.CategoryDetail, fileNameGlobal);
			//openWindow = window.showModalDialog(iframeUrl,"","dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");
			printNext();
		} catch (e) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(e.message);
			alert(e.message);
		}
	}
	else if (createType == "CREATETYPEEPR2")
	{
		try {
			var privatelevel = ""
			if (schemeType != "")
			{
				privatelevel = schemeType.substring(schemeType.length-2,schemeType.length);
			}
			var myBrowser = new WEBBROWSER();
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
			myBrowser.EPRPrint(para.EpisodeID, para.PatientID, para.CategoryDetail, para.PageInfoID, privatelevel, fileNameGlobal);
			printNext();
		} catch (e) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(e.message);
			alert(e.message);
		}
	}
	else if (createType == "CREATETYPETHIRDPARTYURL")
	{
		//协和浙江联众检验报告，采用ie弹窗打印方式
		try {
			var episodeID = para.EpisodeID;
			$.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxThirdParty.cls',
				data: {
					Action: 'geturl',
					EpisodeID: episodeID
				},
				type: 'post',
				async: false,
				timeout: 5000,
				success: function(data) {
					if (data != '-1') {
						//成功
						var result = data;
						var myBrowser = new WEBBROWSER();
						myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,result);
						if (result != "0")
						{
							//0表示没有病案号，表示新生儿，而新生儿不需要生成化验单
							var url = result;
							openWindow = window.showModalDialog(url,"","dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");
						}
						printNext();
					}
				},
				error: function(jqXHR,textStatus) {
					alert(textStatus);
				}
			});
		} catch (e) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(e.message);
			alert(e.message);
		}
	}
	else if (createType == "CREATETYPEEMR3FP")
	{
		try {
			var iframeUrl = getUrl(cspPath,para);
			var myBrowser = new WEBBROWSER();
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,iframeUrl);
			openWindow = window.showModalDialog(iframeUrl,"","dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");
			printNext();
		} catch (e) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(e.message);
			alert(e.message);
		}
	}
	else if (createType == "CREATETYPEMEDIA")
	{
		//媒体下载，目前只支持图片
		var myBrowser = new WEBBROWSER();
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
		myBrowser.MediaDownload(para.EpisodeID, para.PatientID, categoryID, para.CategoryDetail);
		printNext();
	}
	else if (createType =="CREATETYPENURSE")
	{
		try {
			var myBrowser = new WEBBROWSER();
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
			myBrowser.NURSEPrint(para.EpisodeID, para.PatientID, categoryID, para.CategoryDetail, para.PageInfoID);
			printNext();
		} catch (e) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(e.message);
			alert(e.message);
		}
	}
	else if (createType == "CREATETYPEDLL")
	{
		//检验报告，直接引用dll
		var myBrowser = new WEBBROWSER();
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"");
		myBrowser.DLLPrint(para.EpisodeID, para.PatientID, categoryID);
		printNext();
	}
	else
	{
		try {
			var iframeUrl = getUrl(cspPath,para);
			var myBrowser = new WEBBROWSER();
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,iframeUrl);
			var i_div = document.getElementById("i_frame_div");
			i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';
		} catch (e) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(e.message);
			alert(e.message);
		}
	}
}

//初始化页码信息********************************************
function initPageInfo(isPageQueue){
	//ajax
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		data: {
			Action: 'initpageinfo',
			IsPageQueue: isPageQueue
		},
		type: 'post',
		async: false,
		timeout: 5000,
		success: function(data) {
			if (data != '-1') {
				//成功
			}
		},
		error: function(jqXHR,textStatus) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(textStatus);
			alert(textStatus);
		}
	});
}

//打印全部结束后清理********************************************
function afterPrint(arr,pageInfoID){
	//将默认打印机设定回原来的默认打印机
	setDefPrinter(defaultPrinterNameGlobal);
	
	//更新进度条信息
	var curnum = arr.length/arr.length;
	var bartext = "注册上传PDF文件";
	$('#progressText').text(bartext);
	
	//上传
	upLoadFTP();

	//更新进度条信息
	var curnum = arr.length/arr.length;
	var bartext = "清空多余PDF文件";
	$('#progressText').text(bartext);
	
	//清空多余的PDF文件
	if (selectItemID =="")
	{
		clearRedundantItem();
	}

	//清理操作和记录打印记录
	var printItemsID = "";
	for (i=0;i<arr.length;i++){
		var strs = new Array();
		strs = arr[i].split("|||");
		var id = strs[0];
		if (printItemsID == ""){
			printItemsID = id
		}
		else{
			printItemsID = printItemsID + "^" +id
		}
	}
	//ajax
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		data: {
			Action: 'afterprint',
			PageInfoID: pageInfoID
		},
		type: 'post',
		async: false,
		timeout: 5000,
		success: function(data) {
			if (data != '-1') {
				//成功
				var myBrowser = new WEBBROWSER();
				myBrowser.AllFinishedOp();
				myBrowser.CreateFinish(episodeID+"|"+patientID+"|"+patName+"|"+userID+"|"+ctlocid+"|"+ssgroupid+"|"+printItemsID);
				//更新进度条信息
				var curnum = arr.length/arr.length;
				var bartext = "生成完成";
				$('#progressText').text(bartext);
			}
		},
		error: function(jqXHR,textStatus) {
			var myBrowser = new WEBBROWSER();
			myBrowser.WriteLog(textStatus);
			alert(textStatus);
		}
	});
}

//打印机管理********************************************
 function PrinterManager(){
	this.localtor=null;
	try{
		if(!this.localtor){
			this.localtor = new ActiveXObject("WbemScripting.SWbemLocator");
		}
	}catch(e){
		var myBrowser = new WEBBROWSER();
		myBrowser.WriteLog(e.message);
		alert(e.message);
	}
	var _this = this;
	
	this.getItems = function(){
		if(!_this.e){
			var service = _this.localtor.ConnectServer(".");
			var properties = service.ExecQuery("SELECT * FROM Win32_Printer");
			_this.e = new Enumerator(properties);
		}
		return _this.e;
	};
	
	this.getDefPrinterName = function(){
		if(!_this.defPrintName){
			var service = _this.localtor.ConnectServer(".");
			var properties = service.ExecQuery("SELECT * FROM Win32_Printer Where Default = TRUE");
			_this.defaultEnu = new Enumerator(properties);
			var po = _this.defaultEnu.item();
			if(po){
				return po;
			}
			return null;
		}
		return _this.defPrintName;
	};
	
	this.setDefPrinter = function(printName){
		if(printName){
			var e = _this.getItems();
			while(!e.atEnd()){
				var p = e.item();
				if(p.name == printName){
					p.setDefaultPrinter();
				}
				e.moveNext();
			}
		}
	};
	
	this.distory = function(){
		this.localtor=null;
	};
}

//获取系统默认打印机 
function getDefPrinter(){
	var printMger = new PrinterManager();
	var defPrinter = printMger.getDefPrinterName();
	printMger.distory();
	if (defPrinter == null) return "";
	return defPrinter.name;
}

//设置系统默认打印机 
function setDefPrinter(printName){
	var printMger = new PrinterManager();
	printMger.setDefPrinter(printName);
	printMger.distory();
}

//检查系统中是否安装有此打印机
function checkPrinter(printName){
	var hasThisPrinter = false;
	var printMger = new PrinterManager();
	var printers = printMger.getItems();
	while (!printers.atEnd()) {
		var printer = printers.item();
		if (printName == printer.name) {
			hasThisPrinter = true;
		}
		printers.moveNext();
	}
	printMger.distory();
	return hasThisPrinter;
}

// 附加PDF操作
function appendPDF(origFile, appendFile){
	var myBrowser = new WEBBROWSER();
	myBrowser.CheckPDFExist(globalPrintItems);
	myBrowser.AppendPDF(origFile, appendFile);
}

// 检查PDF文件是否已经释放
function checkPDFReleased(fileName){
	var myBrowser = new WEBBROWSER();
	var isReleased = myBrowser.IsFileReleased(fileName);
	return isReleased;
}

// 检查PDF文件是否已经创建
function checkPDFCreated(fileName){
	var myBrowser = new WEBBROWSER();
	var isFileCreated = myBrowser.IsFileCreated(fileName);
	return isFileCreated;
}

// 每个集成项目内部有多个打印作业,当执行完一个打印作业时调用此方法,完成下列工作:
// 打印作业是否完成的检查\PDF文件是否生成的检查\修改下一个打印作业的输出文件名称
function finishOneItemJob(){
	//debugger;
	try {
		itemPrintJobCount = itemPrintJobCount + 1;
		
		//检查pdf作业是否完成
		var myBrowser = new WEBBROWSER();
		myBrowser.CheckPDFExist(globalPrintItems);
		
		if (itemPrintJobCount == 1)
		{
			var strs = new Array();
			strs = globalArr[count].split("|||");
			
			var categoryID = strs[1];
			var categoryDetail =strs[2];
			var id = strs[0];
			
			var file1 = getFileName(categoryID, categoryDetail, "0");
			var file2 = file1 + "_append" + itemPrintJobCount;
			checkPDFReleased(file1);
			startPrintJob(file2);
		}
		else
		{
			var strs = new Array();
			strs = globalArr[count].split("|||");
			
			var categoryID = strs[1];
			var categoryDetail =strs[2];
			var id = strs[0];
			
			var file1 = getFileName(categoryID, categoryDetail, "0");
			var file2 = file1 + "_append" + (itemPrintJobCount - 1);
			appendPDF(file1, file2);
			
			var fileName = file1 + "_append" + itemPrintJobCount;
			startPrintJob(fileName);
		}
	} catch (e) {
		var myBrowser = new WEBBROWSER();
		myBrowser.WriteLog(e.message);
		alert("finishOneItemJob:" +　e.message);
	}
}

function finishOneItemJobAsyn(){
	var strs = new Array();
	strs = globalArr[count].split("|||");
	
	var categoryID = strs[1];
	var categoryDetail =strs[2];
	var id = strs[0];
	var file1 = getFileName(categoryID, categoryDetail, "0");
	
	if (itemPrintJobCount == 0)
	{
		var curFile = file1;
	}
	else
	{
		var curFile = file1 + "_append" + itemPrintJobCount;
	}
	
	var hasException = 0;
	var sleepCount = 0;
	var sleepTotCount = 300;
	var sleepTime = 1000;
	var sleepPara = {SleepTime:1000};
	while (true)
	{
		window.showModalDialog("dhc.epr.fs.sleeppage.csp",sleepPara,"dialogHeight:0px;dialogWidth:0px;dialogLeft:10000px;dialogTop:10000px;dialogHide:no;");
		sleepCount = sleepCount + 1;
		if (sleepCount > sleepTotCount)
		{
			hasException = 1;
			break;
		}
		
		var isCreated = checkPDFCreated(curFile);
		if (isCreated)
		{
			break;
		}
	}
	
	finishOneItemJob();
}
