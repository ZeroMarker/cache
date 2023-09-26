
Ext.QuickTips.init();

/*
集中打印
01.	检查报告    
02.	检验报告
03.	医嘱单
04.	体温单
05.	住院证
06.	护理病历
07.	病历文书
71. 病历文书新版
08.	麻醉记录
09.	病理
10.	心电图
11.	费用清单
12.	临床路径
13.	输血申请单
31.	长期医嘱单
32.	临时医嘱单
*/

//递归计数
var count = 0;
var url = "../web.eprajax.CentralizedPrintDisplay.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID + "&CTLocID=" + ctlocid + "&SSGroupID=" + ssgroupid;
var globalArr = new Array();
var globalArrCount = 0;
var globalIsPageQueue = "";
var globalPageInfoID = 0;
var globalStartDateTime = "";
var globalID = "";
var virtualPrinterName = "Foxit PDF Printer";

function showPrintRecordInfo()
{
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintRecord.cls',
		timeout: 5000,
		params: {
			Action: "checkprinted",
			UserID: userID,
			EpisodeID: episodeID
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
			
				if (response.responseText == "1")
				{
					var winshowRecord = new Ext.Window({
						id: 'showRecordWin',
						layout: 'fit', // 自动适应Window大小
						width: 550,
						height: 300,
						title: '打印记录',
						closeAction: 'close',
						// raggable: true, 		//不可拖动
						modal: true, //遮挡后面的页面
						resizable: true, // 重置窗口大小
						autoScroll:true,
						html: '<iframe id="frmShowRecord" style="width:100%; height:100%" src="dhc.epr.centralizedprintwin.csp?EpisodeID='+episodeID+'&UserID='+userID+'"></iframe>'
					});
	
					winshowRecord.show();
				}
				else
				{
					printClick();
				}
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});	
}

//提交打印******************************************
function printClick(){
	//保存当前默认打印机名称，并把默认打印机指向虚拟打印机
	Ext.getCmp("currentDefPrinter").setValue(getDefPrinter());
	//检查是否安装虚拟打印机
	if (checkPrinter(virtualPrinterName)) {
		setDefPrinter(virtualPrinterName);
	}
	
    var arr = new Array();
    
	var grid = Ext.getCmp('grid');
	var selectedRows = grid.getSelectionModel().getSelections();
	
    for(var i = 0; i<selectedRows.length; i++){
		var row = selectedRows[i];
		
		var id = row.get('id');
		var cgID = id.substring(0,4);
		var cdInfo = row.get('detailInfo'); 
		var order = row.get('order')
		var text = row.get('text');
		
		arrItems= cdInfo.split("^");
		if (arrItems[0] == "PS") {
			cgID = "PS";
		}
		
		var arrString = id +"|||"+ cgID +"|||"+ cdInfo +"|||"+ order +"|||"+ text;
		
		var arrAfterSort = new Array();
		if (cdInfo != "") {
			arr.push(arrString)
			arrAfterSort = sortArr(arr);
		}
	}
    
	if (arr.length < 1){
    	Ext.MessageBox.alert('操作提示','请选择打印范围');
       	return;
   	}

	//打印份数
	var copies = Ext.getCmp('txtCopies').getValue();
	if (copies == ""){
		copies = 1;
	}

	//获取是否需要页码大排队
	var isPageQueue = Ext.getCmp('chkIsPageQueue').getValue();
	
	for (var i = 0; i<copies; i++) {
		if (isPageQueue){
			printPageQueue(arrAfterSort,true);
		}
		else{
			printPageQueue(arrAfterSort,false);
		}
	}
}

//按页码显示顺序排序，否则会按照用户选择的先后顺序而不是页面显示的先后顺序打印和排序页码。
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

//打印********************************************
function printPageQueue(arr,isPageQueue) {
	Ext.getCmp("pbar").setVisible(true);
	
	var arrCount = arr.length;
    if (arrCount < 1) return;
	globalArr = arr;
	globalArrCount = arrCount;
	globalIsPageQueue = isPageQueue;

	//初始化页码信息
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 5000,
		params: {
			Action: "initpageinfo",
			UserID: userID,
			IsPageQueue:isPageQueue
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//成功，传回开始打印的时间（打印记录用）
				var strs = new Array();
				strs = (response.responseText).split("###");
				var pageInfoID = parseInt(strs[0]);
				var startDateTime = strs[1];
				globalPageInfoID = pageInfoID;
				globalStartDateTime = startDateTime;
				//递归打印所有项目
				printItem(arr,arrCount,isPageQueue,pageInfoID,startDateTime);
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});	
}

//递归打印所有项目
function printItem(arr, arrCount, isPageQueue, pageInfoID, startDateTime){
	var strs = new Array();
	strs = arr[count].split("|||");

	var categoryID = strs[1];
	var categoryDetail =strs[2];
	var id = strs[0];
	globalID = id;
	var para = {EpisodeID: episodeID, PatientID: patientID, CategoryDetail: categoryDetail, PageInfoID: pageInfoID, CategoryID:categoryID};
	//进度条信息
	var curnum = (count+1)/arrCount;
	var bartext = "正在打印《"+strs[4]+"》，第"+(count+1)+"项，共"+arrCount+"项";
	Ext.getCmp("pbar").updateProgress(curnum,bartext);
	if (categoryID == "CG01") {
		print01(para);
    }
	else if (categoryID == "CG02") {
		print02(para);
	}
	else if (categoryID == "CG03") {
		print03(para);
	}
	else if (categoryID == "CG04") {
		print04(para);
	}
	else if (categoryID == "CG05") {
		print05(para);
	}
	else if (categoryID == "CG06") {
		print06(para);
	}
	else if (categoryID == "CG07") {
		print07(para);
	}
	else if (categoryID == "CG71") {
		print71(para);
	}
	else if (categoryID == "CG08") {
		print08(para);
	}
	else if (categoryID == "CG09") {
		print09(para);
	}
	else if (categoryID == "CG10") {
		print10(para);
	}
	else if (categoryID == "CG11") {
		print11(para);			
	}
	else if (categoryID == "CG12") {
		print12(para);			
	}
	else if (categoryID == "CG13") {
		print13(para);			
	}
	else if (categoryID == "CG31") {
		print31(para);
	}
	else if (categoryID == "CG32") {
		print32(para);
	}
	else if (categoryID == "PS"){
		printScan(para);
	}
}
function printNext(){
	var arr = globalArr;
	var arrCount = globalArrCount;
	var isPageQueue = globalIsPageQueue;
	var pageInfoID = globalPageInfoID;
	var startDateTime = globalStartDateTime;
	var id = globalID;
	
	//ajax 打印完记录打印项结束页码
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 6000000,
		params: {
			Action: "setpageinfo",
			UserID: userID,
			IsPageQueue: isPageQueue,
			PageInfoID: pageInfoID,
			AID: id
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//成功，递归打印下一个选中打印项，并刷新打印项表格显示页码信息
				count = count + 1;
				if (count < arrCount) {
					printItem(arr, arrCount, isPageQueue, pageInfoID, startDateTime);
				}
				//递归最后一项，打印完成后刷新打印项表格，并将count置0
				else {
					if (count = arrCount) {
						var s = Ext.getCmp('grid').getStore();
						s.proxy.conn.url = url + "&PageInfoID=" + pageInfoID;
						s.load();
						count = 0;
						//清理，打印记录，还原打印机设置
						afterPrint(arr, pageInfoID, startDateTime);
					}
				}
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});
}

// 执行完一次打印作业
// 集中打印中不需要做任何处理，直接返回即可，仅为与无纸化集成兼容
function finishOneItemJob()
{
	return 1;
}

// 执行完一次打印作业
// 集中打印中不需要做任何处理，直接返回即可，仅为与无纸化集成兼容
function finishOneItemJobAsyn()
{
	return 1;
}

function getUrl(cspUrl,para){
	if (para.CategoryID == "CG07")
	{
		return cspUrl + "?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CategoryDetail=" + encodeURI(para.CategoryDetail) + "&PageInfoID=" + para.PageInfoID;
	}
	else if (para.CategoryID == "CG71")
	{
		para.CategoryDetail = para.CategoryDetail.replace(/#/g,'_');
		return cspUrl + "?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CategoryDetail=" + para.CategoryDetail + "&PageInfoID=" + para.PageInfoID;
	}
	else
	{
		return cspUrl + "?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&PageInfoID=" + para.PageInfoID + "&CategoryDetail=" ;    //+ para.CategoryDetail;
	}
}

//各组打印接口********************************************
//01.	检查报告
function print01(para) {
    try {
    		//var iframeUrl = getUrl("DHCRISReport.Print.csp",para);
				var iframeUrl = getUrl("DHCRISReport.PrintCentral.csp",para);
				var i_div = document.getElementById("i_frame_div"); 
				i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } 
}

//02.	检验报告
function print02(para) {
	  try {
		    var iframeUrl = getUrl("dhclabprintresultemr.csp",para);
        var i_div = document.getElementById("i_frame_div"); 
        i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } 
}

//03.	医嘱单


function print03(para) {
	try {
		var iframeUrl = getUrl("DHCNurseIPCommOrdPrintNew.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    }
}

//04.	体温单
function print04(para) {
	try {
		/*var iframeUrl = getUrl("DHCNurseIPTemperatureCOMMJZ.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } */
        window.showModalDialog("DHCNurseIPTemperatureCOMM.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }
}

//05.	住院证
function print05(para) {
    //alert("住院证,episodeID: "+episodeID+" patientID: "+patientID);
    try {
		var iframeUrl = getUrl("DHCDocIPBookNew.Print.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } 
}

//06.	护理病历
function print06(para) {
    //alert("护理病历,episodeID: "+episodeID+" patientID: "+patientID);
    try {
		var iframeUrl = getUrl("DHCNurseIPhulibingliCOMM.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } 
}

//07.	病历文书
function print07(para) {
	try {
        if (para.CategoryDetail == "") return; 	
		var iframeUrl = getUrl("dhc.epr.centralizedprintepr.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    }  	
}

//07.	病历文书
function print71(para) {
	try {
		window.showModalDialog("emr.interface.print.csp?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CatalogID=" + para.CategoryDetail,para,"dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");		
		printNext();
    } catch (e) {
        alert(e.message);
    }  	
}

//08.	麻醉记录
function print08(para) {
    //alert("麻醉记录,episodeID: "+episodeID+" patientID: "+patientID);
	try
	{
		var iframeUrl = getUrl("DHCANOneStepPrint.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
		//window.showModalDialog("DHCANOneStepPrint.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;"); 
   	}
  	catch(e){
		alert(e.message)
	}  
}

//09.	病理
function print09(para) {
	try {
        if (para.CategoryDetail == "") return; 	
		var iframeUrl = getUrl("DHCPISReport.Print.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    }  	
}

//10.	心电图
function print10(para) {
	//心电图本身为pdf，判断是否是虚拟打印，若是虚拟打印，则不打印直接拷贝相应的pdf文件。
	setDefPrinter(Ext.getCmp("currentDefPrinter").getValue());
	var isVirtualPrint = false;
	var defaultPrinter = getDefPrinter();
	//虚拟打印
	if (defaultPrinter == virtualPrinterName){
		isVirtualPrint = true;
	}
	try {
        if (para.CategoryDetail == "") return; 	
		var iframeUrl = getUrl("EKGAkeyPrint.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl + "&IsVirtualPrint=" + isVirtualPrint +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    }  
}

//11.	费用清单
function print11(para) {
		try {
			var iframeUrl = getUrl("dhcipbillbilldetailsprint.csp",para);
			var i_div = document.getElementById("i_frame_div"); 
			i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
		} catch (e) {
	        alert(e.message);
	    } 	
	
}

//12.	临床路径
function print12(para) {
		try {
			var iframeUrl = getUrl("dhccpw.mr.printpathwayform.csp",para);
			var i_div = document.getElementById("i_frame_div"); 
			i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
		} catch (e) {
	        alert(e.message);
	    } 	
	
}

//13.	输血申请单
function print13(para) {
		try {
			var iframeUrl = getUrl("dhclabprintappbloodemr.csp",para);
			var i_div = document.getElementById("i_frame_div"); 
			i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
		} catch (e) {
	        alert(e.message);
	    } 	
	
}

//31.	长期医嘱单
function print31(para) {
    try {
		var iframeUrl = getUrl("DHCNurseIPCommOrdPrintJZCQ.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } 
}

//32.	临时医嘱单
function print32(para) {
    try {
		var iframeUrl = getUrl("DHCNurseIPCommOrdPrintJZLS.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    } 
}

//打印扫描
function printScan(para){
	try {
        if (para.CategoryDetail == "") return; 	
		var iframeUrl = getUrl("dhc.epr.onestepprintscan.csp",para);
		var i_div = document.getElementById("i_frame_div"); 
		i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
    } catch (e) {
        alert(e.message);
    }
}

//初始化页码信息********************************************
function initPageInfo(isPageQueue){
	//ajax
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 5000,
		params: {
			Action: "initpageinfo",
			UserID: userID,
			IsPageQueue:isPageQueue
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//成功
				;
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});		
}

//打印全部结束后清理********************************************
function afterPrint(arr,pageInfoID,startDateTime){
	//将默认打印机设定回原来的默认打印机
	setDefPrinter(Ext.getCmp("currentDefPrinter").getValue());
	
	//更新进度条信息
	var curnum = arr.length/arr.length;
	var bartext = "打印全部完成";
	Ext.getCmp("pbar").updateProgress(curnum,bartext);
	Ext.getCmp("pbar").setVisible(false);
	
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
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 5000,
		params: {
			Action: "afterprint",
			EpisodeID: episodeID,
			PatientID: patientID,
			ItemIDs: printItemsID,
			StartDateTime: startDateTime,
			UserID: userID,
			PageInfoID: pageInfoID
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//成功
				;
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});
}

//当前打印方案信息********************************************
function getSchemeInfo(){
	//ajax
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 5000,
		params: {
			Action: "getschemeinfo"
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//成功
				var schemeInfo = response.responseText;
				if (schemeInfo != "nodefault"){
					var strs = new Array();
					strs = schemeInfo.split("^");
					Ext.getCmp('schemeName').setText(strs[0]);
					Ext.getCmp('schemeDesc').setText(strs[1]);
					Ext.getCmp('createUserID').setText(strs[2]);
					Ext.getCmp('createDateTime').setText(strs[3]);
					Ext.getCmp('modifyDateTime').setText(strs[4]);
				}
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
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


