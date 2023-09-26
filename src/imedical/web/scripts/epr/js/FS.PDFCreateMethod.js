//��.net�����ӿ�
var WEBBROWSER = function () { 
	///<summary> 
	///����WebBrowser������װ�� 
	///</summary> 
	this.CreateStart = function (msg,episodeID,  patientID,aDetails) { 
		///<summary> 
		///������� 
		///</summary> 
		///<param name="msg">��Ϣ</param> 
		window.external.CreateStart(msg,episodeID,  patientID,aDetails); 
	};
	this.CreateFinish = function (msg) { 
		///<summary> 
		///������� 
		///</summary> 
		///<param name="msg">��Ϣ</param> 
		window.external.CreateFinish(msg); 
	};
	this.ItemCreateStart = function ( message, episodeID,  patientID,  categoryID,  categoryDetail,  mrItemID,  invokeMethod) {
		
		window.external.ItemCreateStart(message, episodeID,  patientID,  categoryID,  categoryDetail,  mrItemID,  invokeMethod);
	};
	this.ItemCreateFinish = function (message,episodeID,  patientID,mrItemID ) {
		
		window.external.ItemCreateFinish(message,episodeID,  patientID,mrItemID);
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
	this.SpecialFTPOp = function (param, schemeType, versionTypeCode,specialFlag,specialParam) {
		window.external.SpecialFTPOp(param, schemeType, versionTypeCode,specialFlag,specialParam);
	};
	this.ClearRedundantItem = function (episodeID,versionNum,correctMRItemList,schemeID) {
		window.external.ClearRedundantItem(episodeID,versionNum,correctMRItemList,schemeID);
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
	this.ThirdPartyDownload = function (episodeID, patientID, typeCode) {
		return window.external.ThirdPartyDownload(episodeID, patientID, typeCode);
	};
	this.CMDPrint = function (episodeID, patientID, typeCode) {
		return window.external.CMDPrint(episodeID, patientID, typeCode);
	};
	this.EPRPrint = function (episodeID, patientID, categoryDetail,pageInfoID,privacylevel,fileName) {
		return window.external.EPRPrint(episodeID, patientID, categoryDetail,pageInfoID,privacylevel,fileName);
	};
	this.EMRPrint = function (episodeID, patientID, categoryDetail,fileName) {
		return window.external.EMRPrint(episodeID, patientID, categoryDetail,fileName);
	};
	this.LocalFile = function (episodeID, patientID, typeCode) {
		return window.external.LocalFile(episodeID, patientID, typeCode);
	};
};

Ext.QuickTips.init();

/*
01.		��鱨��    
02.		���鱨��
04.		���µ�
05.		סԺ֤
06.		������
07.		��������
08.		�����¼
09.		����
10.		�ĵ�ͼ
11.		�����嵥
12.		�ٴ�·��
13.		��Ѫ���뵥
14.		�����¼
15.		������㵥
17.		����FTP��
31.		����ҽ����
32.		��ʱҽ����
*/

//ȫ�ֱ���
//�ݹ����
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

//�ύ��ӡ******************************************
function beginPDFCreate(){
	//debugger;
	globalPrintItems = "";
	globalMRItemIDList = "";
	//���浱ǰĬ�ϴ�ӡ�����ƣ�����Ĭ�ϴ�ӡ��ָ�������ӡ��
	defaultPrinterNameGlobal = getDefPrinter();
	//����Ƿ�װ�����ӡ��
	if (!checkPrinter(virtualPrinterName)){
		var myBrowser = new WEBBROWSER(); 
		myBrowser.SetupDHCCPDFCreator();
	}
    setDefPrinter(virtualPrinterName);
	
	var store = new Ext.data.JsonStore({
		url: "../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID + "&SchemeID=" + schemeID + "&SpecialFlag=" + specialFlag + "&SpecialParam=" + specialParam,
		root: 'Data',
		totalProperty: 'TotalCount',
		fields: [
			{name: 'id'},
			{name: 'text'},
			{name: 'cspPath'},
			{name: 'detailInfo'},
			{name: 'detailAttachType'},
			{name: 'mrItemID'},
			{name: 'order',type:'int'}
		],
		sortInfo: {field: 'order', direction: "ASC" }
	});

	store.on('load', function(){
		var arr = new Array();
		var arrAfterSort = new Array();
		if (store.getCount() == 0) {
			//alert("���ɷ���û�������κ���Ŀ�������������ɷ���");
			var myBrowser = new WEBBROWSER(); 
			myBrowser.CreateFinish("");
		}
		else {
			var aDetails="";
			store.each(function(record){
				var id = record.get('id');
				var cgID = id.substring(0, 4);
				var cdInfo = record.get('detailInfo');
				var cdAttachType = record.get('detailAttachType');
				var mrItemID = record.get('mrItemID');
				var order = record.get('order')
				var text = record.get('text');
				var cspPath = record.get('cspPath');
				//����MRItemID�������� 2017.1.12
				var arrString = id + "|||" + cgID + "|||" + cdInfo + "|||" + order + "|||" + text + "|||" + cdAttachType + "|||" + cspPath+"|||"+mrItemID;
				var arrAfterSort = new Array();
				if (cdInfo != "") {
					arr.push(arrString)
				}

				if (globalMRItemIDList == "") {
					globalMRItemIDList = mrItemID;
				}
				else {
					globalMRItemIDList = globalMRItemIDList + "^" + mrItemID; 
				}
				if (aDetails==""){
					aDetails=order + "^" + mrItemID + "^" + cgID
				}
				else{
					aDetails=aDetails + "|||" + order + "^" + mrItemID + "^" + cgID
				}
			});
			var myBrowser = new WEBBROWSER();
			//alert("CreateStart::"+aDetails);
			myBrowser.CreateStart("",episodeID,patientID,aDetails);
			//��ȡ�Ƿ���Ҫҳ����Ŷ�
			if (needPageQueue == "Y") {
				printPageQueue(arr, true);
			}
			else {
				printPageQueue(arr, false);
			}
		}
	});  

	//���ݼ����쳣
	store.on('loadexception', function (proxy, options, response, e) {
		alert(response.responseText);
	});
	store.load();	
}

//���ʱ��������������������ɺ������Ŀ
function timeOut(itemID){
	var store = new Ext.data.JsonStore({
		url: "../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID + "&SchemeID=" + schemeID + "&SpecialFlag=" + specialFlag + "&SpecialParam=" + specialParam,
		root: 'Data',
		totalProperty: 'TotalCount',
		fields: [
			{name: 'id'},
			{name: 'text'},
			{name: 'cspPath'},
			{name: 'detailInfo'},
			{name: 'detailAttachType'},
			{name: 'mrItemID'},
			{name: 'order',type:'int'}
		],
		sortInfo: {field: 'order', direction: "ASC" }
	});

	store.on('load', function(){
		var arr = new Array();
		var arrAfterSort = new Array();
		
		if (store.getCount() == 0) {
			alert("���ɷ���û�������κ���Ŀ�������������ɷ���");
		}
		else {
			var current = false;
			var printedItems = ""; 
			for (var i=0;i<store.getCount();i++){
				var id = store.getAt(i).data['id'];
				var cgID = id.substring(0, 4);
				var cdInfo = store.getAt(i).data['detailInfo'];
				var cdAttachType = store.getAt(i).data['detailAttachType'];
				var order = store.getAt(i).data['order'];
				var cspPath = record.get('cspPath');
				var mrItemID = record.get('mrItemID');
				//����MRItemID�������� 2017.1.12
				if (current) {
					var arrString = id + "|||" + cgID + "|||" + cdInfo + "|||" + order + "|||" + text + "|||" + cdAttachType + "|||" + cspPath+"|||"+mrItemID;
					var arrAfterSort = new Array();
					if (cdInfo != "") {
						arr.push(arrString)
					}
				}
				else{
					if (printedItems == ""){
						printedItems = id;
					} 
					else{
						printedItems = printedItems + "^" + id; 
					}
				}
			
				if (itemID == id){
					current = true;
				}
			}

			if (arr.length == 0) {
				return;
			}
			else {
				//��ȡ�Ƿ���Ҫҳ����Ŷ�
				var isPageQueue = true;
				
				if (isPageQueue) {
					printPageQueue(arr, true);
				}
				else {
					printPageQueue(arr, false);
				}
			}
		}
		
	});  
	//���ݼ����쳣
	store.on('loadexception', function (proxy, options, response, e) {
		alert(response.responseText);
	});
	store.load();	
}

//��ҳ����ʾ˳�����򣬷���ᰴ���û�ѡ����Ⱥ�˳�������ҳ����ʾ���Ⱥ�˳���ӡ������ҳ�롣
function swapArr(arr,firstIndex, secondIndex) {
	var temp = arr[firstIndex];
	arr[firstIndex] = arr[secondIndex];
	arr[secondIndex] = temp;
}

function splitString(arrString){
	var strs = new Array();
	strs = arrString.split("|||");
	
	return parseInt(strs[3]);
}

function sortArr(arr){
	var len = arr.length, min, i, j;

	for (i=0; i<len; i=i+1) {
		min = i;
		// �Ƚ���С��Ŀ�͵�i��֮���ʣ��������, ��Ѱ�Ҹ�С��
		for (j=i+1; j<len; j=j+1) {
			if (splitString(arr[min]) > splitString(arr[j])) {
				 min = j; 
			}
		}
		// �Ƚϳ�ʼ��С��͵�ǰ��С��, ��������, �򽻻�����λ��
		if (i !== min) { 
			swapArr(arr,i, min); 
		}
	}
	// ���ؾ������������
	return arr;
}

//�����ļ���
function getFileName(categoryID,text,categoryAttachType)
{
	var fileNameStr = "";

	if (categoryID == "CG07")	//07.��������
	{
		//07.��������
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
	else if (categoryID == "CG71")	//71.���没������
	{
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_" + text + "_" + text;
		return fileNameStr;
	}
	else if (categoryID == "CG15")
	{
		//����ϵͳ�������¼����������㵥��Ҫ���֣�������㵥TypeParamsΪ2
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_1_2";
		return fileNameStr;
	}
	else
	{
		//����������������
		fileNameStr = categoryID + "_" +"Single" + "_" + patientID + "_" + episodeID + "_1_1";
		return fileNameStr;
	}
}

//�߼��ļ���
function getLogicPath()
{
	var logicPathStr = "/" + patientID + "/" + episodeID + "/epr/" + fileNameGlobal + ".pdf";
	return logicPathStr;
}

//����ǰ���������ӡ��������ļ���
function startPrint(fileName)
{
	var myBrowser = new WEBBROWSER(); 
	myBrowser.SetOutputFileName(fileName);
	fileNameGlobal = fileName;
	myBrowser.StartOp();
}

//��һ���鵵��Ŀ�ڿ�ʼ��һ����ӡ��ҵǰ��������ļ���
function startPrintJob(fileName)
{
	var myBrowser = new WEBBROWSER(); 
	myBrowser.SetOutputFileName(fileName);
	//fileNameGlobal = fileName;
	myBrowser.StartOp();
}

//���ɵ��������������Ŀ�����Ƽӵ�ȫ�ֱ�����
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

//����ȫ����ɺ��ע�ᣬ�ϴ�����
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

//����ȫ����ɺ���ն����PDF�ļ�
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

//��ӡ********************************************
function printPageQueue(arr,isPageQueue) {
	//alert("01");
	var arrCount = arr.length;
    if (arrCount < 1) return;
	globalArr = arr;
	globalArrCount = arrCount;
	globalIsPageQueue = isPageQueue;

	//��ʼ��ҳ����Ϣ
	Ext.Ajax.request({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		timeout: 5000,
		params: {
			Action: "initpageinfo",
			IsPageQueue: isPageQueue
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//�ɹ�
				var pageInfoID = parseInt(response.responseText);	
				globalPageInfoID = pageInfoID;
				//�ݹ��ӡ������Ŀ
				printItem(arr,arrCount,isPageQueue,pageInfoID);
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("��ʾ", response.responseText);
		}
	});	
}

//�ݹ��ӡ������Ŀ
function printItem(arr, arrCount, isPageQueue, pageInfoID){
	//alert("02");
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
	
	globalID = id;
	var para = {EpisodeID: episodeID, PatientID: patientID, CategoryDetail: categoryDetail, PageInfoID: pageInfoID, CategoryID:categoryID,MRItemID:mrItemID};
	
	itemPrintJobCount = 0;

	//��������Ϣ
	var curnum = (count+1)/arrCount;
	var bartext = "�������ɡ�"+strs[4]+"������"+(count+1)+"���"+arrCount+"��";
	Ext.getCmp("pbar").updateProgress(curnum,bartext);	
	//��ȡ���ɵ��ļ���
	fileName = getFileName(categoryID, categoryDetail, categoryAttachType);
	//���������ӡ��������ļ���
	startPrint(fileName);
	if (categoryID == "PS"){
		printScan(para);
	}
	else{
		printCategory(para,categoryID,cspPath);
	}
}

//�ӿڣ���ӡ��һ��
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
	
	//ajax ��ӡ���¼��ӡ�����ҳ��
	Ext.Ajax.request({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		timeout: 6000000,
		params: {
			Action: "setpageinfo",
			IsPageQueue: isPageQueue,
			PageInfoID: pageInfoID,
			AID: id
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//�ɹ����ݹ��ӡ��һ��ѡ�д�ӡ���ˢ�´�ӡ������ʾҳ����Ϣ
				var myBrowser = new WEBBROWSER(); 
				var strs = new Array();
				strs=arr[count].split("|||");
				var aMRItemID = strs[7];
				myBrowser.ItemCreateFinish(arr[count],episodeID,patientID,aMRItemID);
				var myBrowser = new WEBBROWSER(); 
				myBrowser.CheckPDFExist(globalPrintItems);
				count = count + 1;
				if (count < arrCount) {
					finishPrint();
					printItem(arr, arrCount, isPageQueue, pageInfoID);
				}
				//�ݹ����һ���ӡ��ɺ�ˢ�´�ӡ���񣬲���count��0
				else {
					if (count = arrCount) {
						finishPrint();
						count = 0;
						//������ӡ��¼����ԭ��ӡ������
						afterPrint(arr, pageInfoID);
					}
				}
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("��ʾ", response.responseText);
		}
	});
}

var categoryDetail;
function getUrl(cspUrl,para){
	detail = para.CategoryDetail;
	//����get�����ַ�������
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
		//����?�����ʹ��&׷��
		url = cspUrl + "&EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CategoryDetail=" + detail + "&PageInfoID=" + para.PageInfoID + "&Privacylevel=" + privacyLevel + "&SpecialFlag=" + specialFlag + "&SpecialParam=" + specialParam + "&userID=" + userID;
	}
	else
	{
		//����?���һ������ʹ��?
		url = cspUrl + "?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CategoryDetail=" + detail + "&PageInfoID=" + para.PageInfoID + "&Privacylevel=" + privacyLevel + "&SpecialFlag=" + specialFlag + "&SpecialParam=" + specialParam + "&userID=" + userID;
	}
	return url;
}

function getCategoryDetail()
{
	return categoryDetail;
}

//�����ӡ�ӿ�********************************************
function printCategory(para,categoryID,cspPath)
{
    if ((categoryID == "CG24") || (categoryID == "CG25") || (categoryID == "CG01") || (categoryID == "CG10") || (categoryID == "CG08") || (categoryID == "CG18") || (categoryID == "CG81") || (categoryID == "CG17"))
	{
		//�ĵ�ͼ��������PDF�������ӡ��ֱ������
		var myBrowser = new WEBBROWSER(); 
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"")
		myBrowser.LocalFile(para.EpisodeID, para.PatientID, categoryID);
		printNext();
	}
	else if ((categoryID == "CG659") || (categoryID == "CG60") || (categoryID == "CG66") || (categoryID == "CG67") || (categoryID == "CG69") || (categoryID == "CG68") || (categoryID == "CG80") || (categoryID == "CG79") || (categoryID == "CG78") || (categoryID == "CG77") || (categoryID == "CG76") || (categoryID == "CG75") || (categoryID == "CG74") || (categoryID == "CG73") || (categoryID == "CG72") || (categoryID == "CG70") || (categoryID == "CG69") || (categoryID == "CG84") || (categoryID == "CG86") || (categoryID == "CG87") || (categoryID == "CG88") || (categoryID == "CG89") || (categoryID == "CG90") || (categoryID == "CG91") || (categoryID == "CG92")|| (categoryID == "CG93")|| (categoryID == "CG94")|| (categoryID == "CG95")|| (categoryID == "CG96")|| (categoryID == "CG97")|| (categoryID == "CG98")|| (categoryID == "CG99"))
	{
		var myBrowser = new WEBBROWSER(); 
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"")
		myBrowser.ThirdPartyDownload(para.EpisodeID, para.PatientID, categoryID);
		printNext();
	}
	else if ((categoryID == "CG21") || (categoryID == "CG22"))
	{
		//����cs���飬����ҽ��cs��Ѫ��
		var myBrowser = new WEBBROWSER(); 
		myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"")
		myBrowser.CMDPrint(para.EpisodeID, para.PatientID, categoryID);
		printNext();
	}
	else if (categoryID == "CG71")
	{
		try {
			var myBrowser = new WEBBROWSER(); 
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"")
			myBrowser.EMRPrint(para.EpisodeID, para.PatientID, para.CategoryDetail,fileNameGlobal);
			//openWindow = window.showModalDialog(iframeUrl,"","dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");
			printNext();
		} catch (e) {
			alert(e.message);
		}
	}
	else if (categoryID == "CG07")
	{

		try {
			var privatelevel = ""
			if (schemeType != "")
			{
				privatelevel = schemeType.substring(schemeType.length-2,schemeType.length);
			}

			var myBrowser = new WEBBROWSER(); 
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,"")
			myBrowser.EPRPrint(para.EpisodeID, para.PatientID, para.CategoryDetail,para.PageInfoID,privatelevel,fileNameGlobal);
			printNext();	
		} catch (e) {
			alert(e.message);
		}	
	}
	else if (categoryID == "CG83")
	{
		//Э���㽭���ڼ��鱨�棬����ie������ӡ��ʽ
		try {
			var episodeID = para.EpisodeID;
			Ext.Ajax.request({
				url: '../DHCEPRFS.web.eprajax.AjaxThirdParty.cls',
				timeout: 5000,
				params: {
					Action: "geturl",
					EpisodeID:episodeID
				},
				success: function(response, opts){
					if (response.responseText != "-1") {
						//�ɹ�
						var result = response.responseText;
						var myBrowser = new WEBBROWSER(); 
						myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,result)
						if (result != "0")
						{
							//0��ʾû�в����ţ���ʾ��������������������Ҫ���ɻ��鵥
							var url = result;
							openWindow = window.showModalDialog(url,"","dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");							
						}
						printNext();
					}
				},
				failure: function(response, opts){
					Ext.MessageBox.alert("��ʾ", response.responseText);
				}
			});		

		} catch (e) {
			alert(e.message);
		}	
	}
	else
	{
		try {
			var iframeUrl = getUrl(cspPath,para);
			var myBrowser = new WEBBROWSER(); 
			myBrowser.ItemCreateStart(globalArr[count],para.EpisodeID,para.PatientID,categoryID,para.CategoryDetail,para.MRItemID,iframeUrl)
			var i_div = document.getElementById("i_frame_div"); 
			i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
		} catch (e) {
			alert(e.message);
		}
	}
}

//��ʼ��ҳ����Ϣ********************************************
function initPageInfo(isPageQueue){
	//ajax
	Ext.Ajax.request({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		timeout: 5000,
		params: {
			Action: "initpageinfo",
			IsPageQueue:isPageQueue
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//�ɹ�
				;
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("��ʾ", response.responseText);
		}
	});		
}

//��ӡȫ������������********************************************
function afterPrint(arr,pageInfoID){
	//��Ĭ�ϴ�ӡ���趨��ԭ����Ĭ�ϴ�ӡ��
	setDefPrinter(defaultPrinterNameGlobal);
	
	//���½�������Ϣ
	var curnum = arr.length/arr.length;
	var bartext = "ע���ϴ�PDF�ļ�";
	Ext.getCmp("pbar").updateProgress(curnum,bartext);
	
	//�ϴ�
	upLoadFTP();

	//���½�������Ϣ
	var curnum = arr.length/arr.length;
	var bartext = "��ն���PDF�ļ�";
	Ext.getCmp("pbar").updateProgress(curnum,bartext);
	
	//��ն����PDF�ļ�
	clearRedundantItem();

	//��������ͼ�¼��ӡ��¼
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
	Ext.Ajax.request({
		url: '../DHCEPRFS.web.eprajax.GetPDFCreateScheme.cls',
		timeout: 5000,
		params: {
			Action: "afterprint",
			PageInfoID: pageInfoID
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//�ɹ�
				var myBrowser = new WEBBROWSER(); 
				myBrowser.AllFinishedOp();
				myBrowser.CreateFinish(episodeID +"|"+patientID+"|"+patName+"|"+userID+"|"+ctlocid+"|"+ssgroupid+"|"+printItemsID);
				//���½�������Ϣ
				var curnum = arr.length/arr.length;
				var bartext = "�������";
				Ext.getCmp("pbar").updateProgress(curnum,bartext);
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("��ʾ", response.responseText);
		}
	});
}

//��ӡ������********************************************
 function PrinterManager(){
	this.localtor=null;
	try{
		if(!this.localtor){
			this.localtor = new ActiveXObject("WbemScripting.SWbemLocator");
		}
	}catch(e){
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

//��ȡϵͳĬ�ϴ�ӡ�� 
function getDefPrinter(){
	var printMger = new PrinterManager();
	var defPrinter = printMger.getDefPrinterName();
  	printMger.distory();
	if (defPrinter == null) return "";
	return defPrinter.name;
}

//����ϵͳĬ�ϴ�ӡ�� 
function setDefPrinter(printName){
	var printMger = new PrinterManager();
	printMger.setDefPrinter(printName);
	printMger.distory();
}

//���ϵͳ���Ƿ�װ�д˴�ӡ��
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

// ����PDF����
function appendPDF(origFile, appendFile){
	var myBrowser = new WEBBROWSER(); 
	myBrowser.CheckPDFExist(globalPrintItems);			
	myBrowser.AppendPDF(origFile, appendFile);
}

// ���PDF�ļ��Ƿ��Ѿ��ͷ�
function checkPDFReleased(fileName){
	var myBrowser = new WEBBROWSER(); 
	var isReleased = myBrowser.IsFileReleased(fileName);
	return isReleased;
}

// ���PDF�ļ��Ƿ��Ѿ�����
function checkPDFCreated(fileName){
	var myBrowser = new WEBBROWSER(); 
	var isFileCreated = myBrowser.IsFileCreated(fileName);
	return isFileCreated;
}

// ÿ��������Ŀ�ڲ��ж����ӡ��ҵ,��ִ����һ����ӡ��ҵʱ���ô˷���,������й���:
// ��ӡ��ҵ�Ƿ���ɵļ��\PDF�ļ��Ƿ����ɵļ��\�޸���һ����ӡ��ҵ������ļ�����
function finishOneItemJob(){
	//debugger;
  	try {
		itemPrintJobCount = itemPrintJobCount + 1;
		
		//���pdf��ҵ�Ƿ����
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
        alert("finishOneItemJob:" +��e.message);    
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
