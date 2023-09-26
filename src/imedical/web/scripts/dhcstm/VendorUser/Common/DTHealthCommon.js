// /名称: 全局变量及常用方法定义
// /描述: 全局变量及常用方法定义
// /编写者：zhangdongmei
// /编写日期: 2012.08.21

///添加了IE11的判断
Ext.apply(Ext, ((a = navigator.userAgent) && /Trident/.test(a) && /rv:11/.test(a)) ? {isIE11:true, ieVersion: 11} : {});
var PageSize = 30;
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var FieldDelim="^";  //字段间的分隔符
var gWinWidth="";
var gWinHeight="";
var BatSpFlag=0    ///批次售价标志   1为批次售价
var CommParObj=GetAppPropValue("DHCSTCOMMONM")
var PmRunQianUrl = "dhccpmrunqianreport.csp";   //润乾报表调用dhcstm.pmrunqianreport.csp 固定toolbar。dhccpmrunqianreport.csp，公司版本
var G_VIRTUAL_STORE = '暂存库';		//虚库,暂存库 全局变量
Ext.onReady(function(){
	gWinWidth=document.body.clientWidth*0.85;//默认弹出窗口的宽度高度   适应当前窗口的大小
	gWinHeight=document.body.clientHeight*0.85;
	gGridHeight = document.body.clientHeight * 0.3;
	//重写ux.Window的宽度,高度    ps:GetApplet调用影响了Ext.onEeady的调用时机
	if(!Ext.isEmpty(Ext.ux.Window)){
		Ext.ux.Window.prototype.width = gWinWidth;
		Ext.ux.Window.prototype.height = gWinHeight;
	}
});

Ext.lib.Ajax.getConnectionObject = function() {
	var activeX = ['MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP'];
	function createXhrObject(transactionId) {
		var http;
		try {
			http = new XMLHttpRequest();
		} catch (e) {
			for (var i = 0; i < activeX.length; ++i) {
				try {
					http = new ActiveXObject(activeX[i]);
					break;
				} catch (e) {
				}
			}
		} finally {
			return {
				conn : http,
				tId : transactionId
			};
		}
	}

	var o;
	try {
		if (o = createXhrObject(Ext.lib.Ajax.transactionId)) {
			Ext.lib.Ajax.transactionId++;
		}
	} catch (e) {
	} finally {
		return o;
	}
};

/**
 * 执行数据库同步访问
 * @param {} url 访问路径
 * @return {}
 */
ExecuteDBSynAccess = function(url) {
	var conn = Ext.lib.Ajax.getConnectionObject().conn;
	conn.open("POST", url, false);
	conn.send();
	//return conn.responseText;
	return conn.responseText.trim();
};

/**
 * 设置默认人员
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogUser = function(store, CmpName) {
	// 登录设置默认值
	var rowId = session['LOGON.USERID'];
	var name = session['LOGON.USERNAME'];
	var defaultData = {
		RowId : rowId,
		Description : name
	};
	var record = new store.recordType(defaultData);
	store.add(record);
	Ext.getCmp(CmpName).setValue(rowId);
};

/**
 * 设置登录科室
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogInDept = function(store, CmpName) {
	// 登录设置默认值
	var rowId = session['LOGON.CTLOCID'];
	//2016-11-09
	if(App_LogonLocDesc.indexOf('-')>-1){
		if(CommParObj.GetLocDesc=='1'){
			App_LogonLocDesc=App_LogonLocDesc.split('-')[0];
		}
		else if(CommParObj.GetLocDesc=='2'){
			App_LogonLocDesc=App_LogonLocDesc.split('-')[1];
		}
	}
	addComboData(store,rowId,App_LogonLocDesc);
	Ext.getCmp(CmpName).setValue(rowId);
};

/**
 * 为ComboBox赋值
 * 需留意id的类型要和RowId一致(目前程序中基本都是String)
 * 2015-10-12 添加combo参数, 用于区别valueField,displayField,修改后,第一个参数可传空
 * 2016-03-21 添加对于TreeCombo的处理, 调用时传入第4个combo参数
 */
function addComboData(store, id, desc, combo) {
	//2017-06-12 先格式化变量desc
	desc = Common_FormatJS(desc);
	var valueField = 'RowId';
	var displayField = 'Description';
	if(combo){
		valueField = combo.valueField;
		displayField =  combo.displayField;
		if(Ext.isEmpty(store)){
			store = combo.getStore();
		}
	}
	if(combo && combo.treeCombo === true){
		//TreeCombo-Store
		var node = combo.findNode(valueField, id);
		if(!node){
			var defaultDataStr = "{id:'" + id + "',text:'" + desc + "',"
				+ valueField + ":'" + id + "'," + displayField + ":'" + desc + "'}"
			var defaultData = eval("(" + defaultDataStr + ")");
			var TreeNode = new Ext.tree.TreeNode(defaultData);
			combo.tree.getRootNode().appendChild(TreeNode);
		}
	}else{
		//一般Combo-Store
		if(store.findExact(valueField,id)==-1){
			var defaultDataStr = "{" + valueField +":'"+id+"'," + displayField + ":'" + desc + "'}";
			var defaultData = eval("(" + defaultDataStr + ")");
			var r = new store.recordType(defaultData);
			store.add(r);
		}
	}
}

/*
 * 格式化js变量,处理转义字符
 */
function Common_FormatJS(value){
	return value.replace(/\\/g, '\\\\').replace(/\'/g, '\\\'');
}

/**
 * 根据dateindex取grid列index
 */
function GetColIndex(grid,dateIndex){
	var columnModel=grid.getColumnModel();
	var index=-1;
	if(columnModel){
		index=columnModel.findColumnIndex(dateIndex);
	}
	
	return index;
}

function ShowLoadMask(target,msg){
	var mk = new Ext.LoadMask(target, {
		msg: msg,
		removeMask: true //完成后移除
	});
	mk.show();
	return mk;
}

/**
 * 计算两个日期之间间隔的天数,参数格式必须为Y-m-d
 */
function DaysBetween(dateFrom,dateTo){
	//一天的毫秒数
	var oneDay=24*60*60*1000   
	
	//将两个日期转换为毫秒数
	var dateFrom_ms=Date.parse(dateFrom.replace(/-/g,"/"));   //dateFrom.getTime();  	
	var dateTo_ms=Date.parse(dateTo.replace(/-/g,"/"));   //dateTo.getTime();
	
	//// Calculate the difference in milliseconds
	var dateDiff_ms=Math.abs(dateTo_ms-dateFrom_ms);
	var dateDiff=Math.round(dateDiff_ms/oneDay); 
	
	return dateDiff;
}

/**
 * 将日期格式的字符串转换成Date类型
 */
function toDate(value){
	if(value==null || value==''){
		return value;
	}
	if(Ext.isDate(value)==true){
		return value;
	}
	var newValue=value;
	if(typeof value=='string'){
		//使用websys定义的DateFormat, 时间暂使用H:i:s	(ps:目前componts.js定义在DTHealthCommon.js之后...)
		var parseFormat = DateFormat;
		if(value.indexOf(' ') != -1){
			parseFormat = parseFormat + ' H:i:s';
		}
		var newValue = Date.parseDate(value, parseFormat);
	}
	
	return newValue;
}

if(document.addEventListener){
	document.addEventListener("keydown",maskBackspace, true);
}else{
	document.attachEvent("onkeydown",maskBackspace);
}

//屏蔽编辑页面上BackSpace键
function maskBackspace(event){
	var event = event || window.event;
	var obj = event.target || event.srcElement;
	var keyCode = event.keyCode ? event.keyCode : event.which ?
		event.which : event.charCode;
	if(keyCode == 8){
		if(obj!=null && obj.tagName!=null && (obj.tagName.toLowerCase() == "input" || obj.tagName.toLowerCase() == "textarea")){
			event.returnValue = true;
			if(Ext.getCmp(obj.id)){
				var objXType = Ext.getCmp(obj.id).getXType();
				if(Ext.getCmp(obj.id).readOnly || objXType.indexOf('radio')>=0 || objXType=='checkbox' || (objXType.indexOf('combo')>=0 && Ext.getCmp(obj.id).editable==false) ) {
					if(window.event)
						event.returnValue = false ; //or event.keyCode=0
					else
						event.preventDefault(); //for ff[/b]
				}
			}
		}else{
			if(window.event)
				event.returnValue = false ; // or event.keyCode=0
			else
				event.preventDefault();   //[/b] //for ff
		}
	}
}


 //返回取备注类型字段时，备注行之间的设定分隔符$c(3) 
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return realkey;
}

//对后台返回的备注字段加以处理-即使用回车换行符 $c(13,10) 替换$c(3)
function handleMemo(memo,token) 
{
	var xx='';
	var ss=memo.split(token);
	for (var i=0;i<ss.length;i++)
	{
		if (xx=='') {xx=ss[i];}
		else if(Ext.isIE11){
			//2015-10-12 IE11下TextArea仅有换行符,没有回车符
			xx=xx+'\n'+ss[i];
		}else{
			xx=xx+'\r\n'+ss[i];
		}
	}
	return xx;
}

function xRowDelim(){
	var realkey  = String.fromCharCode(1);  
	return realkey;	
}

function DecimalFormat(value,decimalLen){
	//如果不是数字的话原值返回
	if(/^\d*\.{0,1}\d*$/.test(value)==false){
		return value;
	}
	var newValue=Number(value).toFixed(decimalLen);
	return newValue;
}

/**
 * GridPanel中单元格合并功能, fieldName指合并单元格的依据字段,比如库存项rowid
 * ps:当前CellMerge仅支持简单的单元格合并,与润乾的Group功能功能差距较大
 * 后续可将参数fieldName改成多个参数的形式,类似于当前月报明细的中的处理...
 */
function CellMerge(fieldName) {
	return function(value, meta, record, rowIndex, colIndex, store){
		var lastRowValue;
		if(rowIndex > 0){
			lastRowValue = store.getAt(rowIndex - 1).get(fieldName);
		}
		var thisRowValue = record.get(fieldName);
		var nextRowValue = '';
		if(rowIndex < store.getCount() - 1){
			nextRowValue = store.getAt(rowIndex + 1).get(fieldName);
		}
		var first = !rowIndex || (thisRowValue !== lastRowValue),
			last = rowIndex >= store.getCount() - 1 || (thisRowValue !== nextRowValue);
			meta.css += 'row-span' + (first ? ' row-span-first' : '') + (last ? ' row-span-last' : '');
		if (first) {
			var i = rowIndex + 1;
			while (i < store.getCount() && thisRowValue == store.getAt(i).get(fieldName)) {
				i++;
			}
			var rowHeight = 25, padding = 6,
				height = (rowHeight * (i - rowIndex) - padding) + 'px';
				meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
		}
		return first ? value : '';
	}
}

/*  保存grid中的数据到excel文件 
 *  要求：
 *     浏览器允许执行ActiveX控件
 * 
 * */
function gridSaveAsExcel(grid,name){
	if(typeof grid === 'string'){
		grid = Ext.getCmp(grid);
	}
	if(!name){
		//grid--title添加button后的特殊处理
		var gridPanelTitle = Ext.isEmpty(grid.title)? '' : grid.title.split('&nbsp')[0];
		name = gridPanelTitle + new Date().format('Y-m-d-His');
	}
	if(document.all.ExportExcel== null){
		StoreSaveAsExcel(grid.getStore(),grid.getColumnModel(),name)
	}else{
		StoreSaveAsExcelByOwc(grid.getStore(),grid.getColumnModel(),name)
	}
}
/*
function gridSaveAsExcel(grid,name)
{
  	if (grid.getStore().getCount()==0)
	{
		Msg.info('warning','没有需要保存的数据！');
		return;
	};  

    var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	fd.FileName=name
	// 必须设置MaxFileSize. 否则出错
	fd.MaxFileSize = 32767;
	// 显示对话框
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fileName=='') return;
	//
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return "";
	}
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('文件"'+fileDesc+'"已经存在，是否替换原有文件？')==false){
		 	xlApp.Quit(); 
			xlApp=null;
			return;
		}
	}
	
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	var temp_obj=[];

	for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //只存没有隐藏的列
		}
	}

	//Excel第一行存放标题
	for (l=1;l<=temp_obj.length;l++)
	{
		xlSheet.Cells(1,l).Value=cm.getColumnHeader(temp_obj[l-1]);
	}

	var store=grid.getStore();
	var recordCount=store.getCount();
	var view=grid.getView();
	for (k=1;k<=recordCount;k++)
	{
		for (j=1;j<=temp_obj.length;j++)
		{
			var cellValue=view.getCell(k-1,temp_obj[j-1]).innerText;
			//判断是否数字格式,避免"001"导出成"1"
			var regExpPattern=/^(-?\d*)(.?\d*)$/;
			if(cellValue!="" && regExpPattern.test(cellValue)){
				xlSheet.Cells(k+1,j).Value="\'"+cellValue;	//全数字转换成字符串
			}else{
				xlSheet.Cells(k+1,j).Value=cellValue;
			}
		}
	}
	try
	{
		var ss = xlBook.SaveAs(fileName);  
		if (ss==false)
		{
			Msg.info('error','另存失败！') ;
		}
	}
	catch(e){
		Msg.info('error','另存失败！') ;
	}

 	xlApp.Quit(); 
	xlApp=null;
	xlBook=null;
	xlSheet=null;
}
*/

/*  保存store中的数据到excel文件 
 *  要求：
 *     浏览器允许执行ActiveX控件
 * 
 * */
function StoreSaveAsExcel(store,cm,name)
{
	if (store.getCount()==0)
	{
		Msg.info('warning','没有需要导出的数据！');
		return;
	}
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	fd.FileName=name
	// 必须设置MaxFileSize. 否则出错
	fd.MaxFileSize = 32767;
	// 显示对话框
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fd.Flags == 0 || fileName==''){
		return;
	}
	//
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return "";
	}
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('文件"'+fileDesc+'"已经存在，是否替换原有文件？')==false){
			xlApp.Quit();
			xlApp=null;
			return;
		}
	}
	
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var colCount=cm.getColumnCount();
	var temp_obj=[];	//存放需要导出的columns
	var arr_obj=[];		//存放原始record所有name
	
	var temp_obj=cm.getColumnsBy(function(c){
		return !(c.hidden || c.dataIndex=="" || c.IFExport===false);
	});
	
	//Excel第一行存放标题
	for (var n=0;n<temp_obj.length;n++){
		xlSheet.Cells(1,n+1).Value=temp_obj[n].header;
	}
	
	var recordCount=store.getCount();
	for (var k=0;k<recordCount;k++){
		var arrRecord=store.getAt(k);
		for (var j=0, colLen = temp_obj.length; j<colLen; j++){
			var colDataIndex=temp_obj[j].dataIndex;
			var colRenderer = temp_obj[j].renderer;
			var cellValue=arrRecord.get(colDataIndex);
			//column定义中, useRenderExport : false, 则在导出时不使用该column的renderer
			if(colRenderer.toString().replace(/\s/g,'')!="function(value){returnvalue;}"
			&& temp_obj[j].xtype!="checkcolumn" && temp_obj[j].useRenderExport!==false){
				var cellValue = temp_obj[j].renderer(cellValue,{},arrRecord,k,j,store);
			}
			cellValue = Ext.util.Format.stripTags(cellValue);
			var regExpPattern=/^(-?\d*)(.?\d*)$/;
			if(cellValue!="" && regExpPattern.test(cellValue)){
				xlSheet.Cells(k+2,j+1).Value="\'"+cellValue;	//全数字转换成字符串
			}else{
				xlSheet.Cells(k+2,j+1).Value=cellValue;
			}
		}
	}
	xlSheet.Columns.AutoFit;
	xlApp.ActiveWindow.Zoom = 75;
	try{
		var ss = xlBook.SaveAs(fileName);  
		if (ss==false)
		{
			Msg.info('error','另存失败！') ;
		}else{
			Msg.info('success', 'Excel导出成功!');
		}
	}
	catch(e){
		Msg.info('error','另存失败！') ;
	}

	xlApp.Quit();
	xlApp=null;
	xlBook=null;
	xlSheet=null;
}

function StoreSaveAsExcelByOwc(store,cm,name)
{
	if (store.getCount()==0)
	{
		Msg.info('warning','没有需要导出的数据！');
		return;
	}
	
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	fd.FileName = name;
	// 必须设置MaxFileSize. 否则出错
	fd.MaxFileSize = 32767;
	// 显示对话框
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fd.Flags == 0 || fileName==''){
		return;
	}
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('文件"'+fileDesc+'"已经存在，是否替换原有文件？')==false){
			return false;
		}
	}
	
	var gridID = 'ExcelObj';
	var sheetHtml = '<OBJECT id="' + gridID + '" height="100%" width="100%" ' +
	'classid="clsid:0002E559-0000-0000-C000-000000000046">'+
	'<PARAM NAME="Caption" VALUE="东华物资管理">' +
	'<PARAM NAME="DisplayTitleBar" VALUE="False">'+
	'<PARAM NAME="DisplayToolbar" VALUE="False">' +
	'<PARAM NAME="ViewableRange" VALUE="1:65536">'+
	'</OBJECT>';
	var win = new Ext.Window({
		title:'Excel预览',
		closable:true,
		width:800,
		height:550,
		plain:true,
		html:sheetHtml
	});
	win.show(this);
	
	var xlBook = document.getElementById(gridID);
	xlBook.DisplayOfficeLogo="True"
	var colCount=cm.getColumnCount();
	var temp_obj=[];	//存放需要导出的columns
	var arr_obj=[];		//存放原始record所有name
	
	var temp_obj=cm.getColumnsBy(function(c){
		return !(c.hidden || c.dataIndex=="" || c.IFExport===false);
	});
	var tableHtml = "<table><tr>"
	//Excel第一行存放标题
	for (var n=0;n<temp_obj.length;n++){
		tableHtml += "<td>" + temp_obj[n].header + "</td>"
	}
	tableHtml += "</tr>"
	var recordCount=store.getCount();
	for (var k=0;k<recordCount;k++){
		var arrRecord=store.getAt(k);
		var tmpTR = "";
		tmpTR += "<tr>";
		for (var j=0;j<temp_obj.length;j++){
			var tmpTD = "";
			var colDataIndex=temp_obj[j].dataIndex;
			var colRenderer = temp_obj[j].renderer;
			var cellValue=arrRecord.get(colDataIndex);
			//column定义中, useRenderExport : false, 则在导出时不使用该column的renderer
			if(colRenderer.toString().replace(/\s/g,'')!="function(value){returnvalue;}"
			&& temp_obj[j].xtype!="checkcolumn" && temp_obj[j].useRenderExport!==false){
				var cellValue = temp_obj[j].renderer(cellValue,{},arrRecord,k,j,store);
			}
			cellValue = Ext.util.Format.stripTags(cellValue);
			var regExpPattern=/^(-?\d*)(.?\d*)$/;
			if(cellValue!="" && regExpPattern.test(cellValue)){
				tmpTD = "<td>"+"\'"+cellValue+"</td>";
			}else{
				tmpTD = "<td>"+cellValue+"</td>";
			}
			tmpTR += tmpTD;
		}
		tmpTR += "</tr>";
		tableHtml += tmpTR;
	}
	tableHtml += "</table>";
	xlBook.HTMLData = tableHtml;
	xlBook.Export(fileName, xlBook.Constants.ssExportActionNone);
	xlBook=null;
	win.close();
	Msg.info('success', 'Excel导出成功!');
}
/** 分页导出所有Execl导出方法 **/
function ExportAllToExcel(gridPanel,name) {
	if(typeof gridPanel === 'string'){
		gridPanel = Ext.getCmp(gridPanel);
	}
	if (gridPanel) {
		var tmpStore = gridPanel.getStore();
		//以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
		var tmpParam = tmpStore.lastOptions //此处克隆了原网格数据源的参数信息
		if (tmpParam && tmpParam.params) {
			tmpParam.params[tmpStore.paramNames.start]=0;
			tmpParam.params[tmpStore.paramNames.limit]=999999; //重置分页信息
		}else{
			Msg.info('warning','没有需要导出的数据！');
			return false;
		}
		var tmpAllStore = new Ext.data.Store({	//重新定义一个数据源
			proxy: tmpStore.proxy,
			reader: tmpStore.reader
		});
		tmpAllStore.on('load', function (store) {
			if(!name){
				//grid--title添加button后的特殊处理
				var gridPanelTitle = Ext.isEmpty(gridPanel.title)? '' : gridPanel.title.split('&nbsp')[0];
				name = gridPanelTitle + new Date().format('Y-m-d-His');
			}
			if(document.all.ExportExcel == null || document.all.ExportExcel.object == null){
				StoreSaveAsExcel.defer(10,this,[store,gridPanel.getColumnModel(),name]);
			}else{
				StoreSaveAsExcelByOwc.defer(10,this,[store,gridPanel.getColumnModel(),name]);
			}
		});
		//获取所有数据
		tmpAllStore.load({
			params : tmpParam.params,
			callback : function(r,options,success){
				if(!success){
					Msg.info('error', '数据加载错误!');
				}
			}
		});
	}
};

function SetFieldOriginal(field){
	if(field.items!=null){
		field.items.each(function(subField){
			SetFieldOriginal(subField);
		});
	}else{
		field.originalValue=String(field.getValue());
	}
}
/**
 * 清空前的判断
 */
function isDataChanged(panel,grid){
	var changed=false;
	var count= grid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = grid.getStore().getAt(index);
		if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

///设置表单初始值, 在查询返回表单信息之后调用
///panel:表单所在的panel名称
function SetFormOriginal(panel){
	var panelId=panel.getId();
	Ext.getCmp(panelId).getForm().items.each(function(f){
		SetFieldOriginal(f);
	});
}

///判断表单是否发生改变
///return: true, false
function IsFormChanged(panel){
	var panelId=panel.getId();
	var isMainChanged=Ext.getCmp(panelId).getForm().isDirty();
	return isMainChanged;
}

/*使Enter键按Tab键执行
 * 
 * */
function setEnterTab(panel)
{
	panel.getForm().items.each(function(f){
		f.on('specialkey',function(id,e){
			var keyCode=e.getKey();
			if(keyCode==e.ENTER)
			{				
				var evt = (event)?event:window.event;
				var element=evt.srcElement || evt.target;
				
				var isIe = (document.all) ? true : false;
				if (isIe)  //IE浏览器的处理
				{
					if (evt.srcElement.nodeName != "TEXTAREA" && evt.srcElement.type != "submit")
						evt.keyCode=9;
				}
				else  ///费IE浏览器的处理目前空缺
				{ 
				
				}			   
			}		
		})
	})
}


/**
 * 清空FormPanel上的各field内容
 * @param {FormPanel} panel
 */
function clearPanel(panel){
	panel.getForm().items.each(function(field,index,length){ 
		clearItem(field);
	});
}

function clearItem(field){
	if(field.items){
		field.items.each(function(child,index,length){
			clearItem(child);
		});
	}else{
		var xtype = field.getXType();
		if(xtype=='loccombo' && !Ext.isEmpty(field.groupId)){				//科室combo
			SetLogInDept(field.getStore(),field.getId());
		}else if(xtype=='stkgrpcombo'){		//类组combo
			field.getStore().load();
		}else if(xtype.indexOf('combo')>=0){
			field.clearValue();				//其他一般combo
		}else if(xtype=='checkbox' || xtype=='radio'){
			field.setValue(false);
		}else if(xtype!='displayfield'){	//displayfield不处理
			field.setValue("");
		}
		field.originalValue = field.getValue();
	}
}

///分析Ext.form.ComboBox中录入的值是否有匹配项，若有，则将值匹配，否则将值置为空。	
///此函数适合用在combobox组件，在焦点离开时的验证与判断
function chkInputOfCombo(cb) 
{
	var store=cb.getStore();
	var displayField=cb.displayField;
	var valueField=cb.valueField;
	var inputs=cb.getRawValue();
	
	var ind=store.findExact(displayField,inputs,0,false,false);
	
	if (ind>-1)
	{
		var rec=store.getAt(ind);
		var value=rec.get(valueField);

		cb.setValue(value);
	}
	else{
		cb.clearValue();
	}
}

///根据科室的变化,修改类组combo取值
///input:	类组combo
function GetSCGbyLoc(locCombo,scgCombo){
	var loc=locCombo.getValue();
	scgCombo.setValue('');
	var scgStore=scgCombo.getStore();
	scgStore.removeAll();
	scgStore.setBaseParam('type',App_StkTypeCode);
	scgStore.setBaseParam('locId',loc);
	scgStore.setBaseParam('userId',session['LOGON.USERID']);
	scgStore.load({
		callback:function(r,options,success){
			if(success==true){
				scgCombo.fireEvent('change');
			}
		}
	});
}

/**
 * 实例化record
 * 简化record实例化代码,返回实例化的record
 * @param {} RecordObject	:Record结构,可以用store.fields
 * @param {} NewRecord		:特殊赋值,形如{fieldA:valueA,fieldB:valueB,...}
 * 							该值传入"",null,{},或者不传,都可以
 * 例如库存调整中:var NewRecord=CreateRecordInstance(INAdjMGridDs.fields);
 */
function CreateRecordInstance(RecordObject,SpecialValue){
	SpecialValue = SpecialValue||{};
	var record = new Ext.data.Record.create(RecordObject);
	var NewRecord = new record(SpecialValue);
	for(var n=0;n<RecordObject.items.length;n++){
		var tmpField=RecordObject.items[n];
		if(NewRecord.data[tmpField.name]==undefined){
			//这里是set空,还是set缺省值呢?
			NewRecord.set(tmpField.name,tmpField.defaultValue);
		}
	}
	return NewRecord;
}

/**
 * 改造成显示打印需调用的字符串
 * @param {String} str: 直接打印的润乾命令字符串
 * TranslateRQStr("{a.raq(a1=b1;a2=b2;a3=b3;a4=b4)}")
 */
function TranslateRQStr(str){
	var rqReg = /^\{.+\.raq\((.+\=.*)(;.+\=.*)*\)\}$/;
	if(!rqReg.test(str)){
		Ext.MessageBox.alert("提示","润乾表达式错误, 请核实!");
		return;
	}
	str = str.substring(1,str.length-1);
	var raqNameIndex = str.indexOf(".raq(")+4;
	var raqName = str.substring(0,raqNameIndex);
	var parStr = str.substring(raqNameIndex+1,str.length-1)
	var newParStr = parStr.replace(/;/g,"&");
	var newStr = raqName+"&"+newParStr;
	return newStr;
}

/**
 * 处理url中特殊字符(+,空格,/,?,#,&,=,%)
 * @param {String} str
 * @return {String}
 */
function TranslateUrlValue(str){
	//% 放在obj最后一个位置, 以替换之前因替换而出现的%
	var specialObj = {'+':'%2B', ' ':'%20', '/':'%2F', '?':'3F%', '#':'%23',
					'&':'%26', '=':'%3D', '%':'%25'};
	//正则表达式特殊字符
	var regSpecialChars = '*.?+$^[](){}|/\\';
	for (var specialChar in specialObj){
		if(str.indexOf(specialChar)>=0){
			if (regSpecialChars.indexOf(specialChar)>=0){
				var reg = new RegExp('\\'+specialChar,'g');
			}else{
				var reg = new RegExp(specialChar,'g');
			}
			str = str.replace(reg,specialObj[specialChar]);
		}
	}
	return str;
}

/**
 * GridPanel行染色
 * @param {GridPanel} grid
 * @param {RowIndex} row
 * @param {} color
 */
function SetGridBgColor(grid, row, color) {
	grid.getView().getRow(row).style.backgroundColor = color;
}
/**
 * 设置回车跳转的顺序
 * @param {} grid 
 * @param {} proIndexName
 */
function setEnterSort(grid,colArr) {
	var addRowFlag=true;
	if(colArr.length<0) return;
	var cel=grid.getSelectionModel().getSelectedCell()
	var indexName=grid.getColumnModel().getDataIndex(cel[1]);
	for(var i=0; i<colArr.length;i++){
		var tempcol = colArr[i];
		if(tempcol.dataIndex==indexName){
			if(i<colArr.length-1){
				var nextIndex=colArr[i+1].dataIndex
				var cell = grid.getSelectionModel().getSelectedCell();
				var col=GetColIndex(grid,nextIndex);
				grid.startEditing(cell[0], col);
				addRowFlag=false;
			}
		}
	}
	return addRowFlag;
}
/**
 * 初始化跳转顺序
 * @param {} grid
 * @return {}
 */
function sortColoumByEnterSort(grid){
	var columnModel=grid.getColumnModel();
	var colArr=[];
	for(var a=0; a<columnModel.getColumnCount();a++){
		var col=grid.getColumnModel().config[a];
		/*alert(col.header+";"+col.editable)
		if(typeof(col.editable) == "undefined" || !col.editable){
			//alert(col.editable)
		 continue;
		}*/
		if(col.hidden) {
			//alert(col.hidden)
			continue;
		}
		if(col.enterSort>0){
			colArr.push(col)
		}
	}
	//按enterSort进行排序
	colArr.sort(function(obj1,obj2){
            return obj1.enterSort-obj2.enterSort});
	return colArr;
} 
//Ext.Container 的 findByType 方法并不能获取容器下级的所有的任意类型的控件，
//比如获取按钮，它不能获取 panel 的 toolbar 里面的按钮，所以我想自己做一个findByType方法。


//获取当前容器下所有封装按钮(uxbutton)
function findUxBtn(c){
	var array = [];
	if( c.toolbars ){
		Ext.each(c.toolbars, function(i){
			var j = i.items.items;
			Ext.each(j,function(k){
				if( k.getXType()=='uxbutton' || k.xtype=='uxbutton'){
					array.push(k);
				}
			})
		});
	}
	if( c.items && c.items.items ){
		var i = c.items.items;
		Ext.each(i,function(j){
			if(j.getXType()=='uxbutton' || j.xtype=='uxbutton'){
				array.push(j);
			}
		});
	}
	return array;
}

//获取当前容器，以及下级所有容器的所有封装按钮(uxbutton)（递归）
var AllbtnArray=[];
function findAllUxBtn(c){
	//如果c不是叶子节点
	if( (c.items && c.items.items) || (c.toolbars) ){
		var btnArray = findUxBtn(c);
		AllbtnArray = AllbtnArray.concat(btnArray)
		if(c.items && c.items.items){
			Ext.each( c.items.items, function(i){
				findAllUxBtn(i);
			});
		}
	}
}

//var url='dhcstm.extux.csp?actiontype=GetBatSpFlag&GroupId='
//+session['LOGON.GROUPID']+'&LocId='+session['LOGON.CTLOCID']+'&UserId='+session['LOGON.USERID'];
//var responseText=ExecuteDBSynAccess(url);
//var jsonData=Ext.util.JSON.decode(responseText);
//if(jsonData.success=='true'){
//	BatSpFlag=jsonData.info.split("^")[7];
//}

/**
 * 获取ftp上传的参数,保存在gFtpParam数组中. 自启动.
 * 数组元素: ftpip,ftpuser,ftppass,ftpsrc,ftpport,ftphttpsrc
 */
//(function GetFtpParam() {
//	var userId = session['LOGON.USERID'];
//	var groupId = session['LOGON.GROUPID'];
//	var locId = session['LOGON.CTLOCID'];
//	var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp';
//	var response = ExecuteDBSynAccess(url);
//	var jsonData = Ext.util.JSON.decode(response);
//	if (jsonData.success == 'true') {
//		var info = jsonData.info;
//		if (info != null || info != '') {
//			gFtpParam = info.split('^');
//		}
//	}
//	return;
//})()

/**
 * 设置登录安全组
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogGroup = function(store, CmpName) {
	// 登录设置默认值
	var rowId = session['LOGON.GROUPID'];
	var desc = session['LOGON.GROUPDESC'];
	addComboData(store,rowId,desc);
	Ext.getCmp(CmpName).setValue(rowId);
};

/*将panel内的item全都disable*/
function disablePanel(panel){
	panel.getForm().items.each(function(field,index,length){ 
		disableItem(field);
	});
}

function disableItem(field){
	if(field.items){
		field.items.each(function(child,index,length){
			disableItem(child);
		});
	}else{
		field.setDisabled(true);
	}
}

/*将panel内的item全都设置为ReadOnly*/
function SetPanelReadOnly(panel){
	panel.getForm().items.each(function(field,index,length){ 
		ReadOnlyItem(field);
	});
}

function ReadOnlyItem(field){
	if(field.items){
		field.items.each(function(child,index,length){
			ReadOnlyItem(child);
		});
	}else{
		field.setReadOnly(true);
	}
}

/*将panel内的item全都设置为Disabled*/
function setPanelDisabled(panel){
	panel.getForm().items.each(function(field,index,length){ 
		disabledItem(field);
	});
}

function disabledItem(field){
	if(field.items){
		field.items.each(function(child,index,length){
			disabledItem(child);
		});
	}else{
		field.setDisabled(true);
	}
}

/*复制值到粘贴版*/
function copyToClipboard(txt) {    
     if(window.clipboardData) {     
             window.clipboardData.clearData();     
             window.clipboardData.setData("Text", txt);     
     } else if(navigator.userAgent.indexOf("Opera") != -1) {     
          window.location = txt;     
     } else if (window.netscape) {     
          try {     
               netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");     
          } catch (e) {     
               alert("被浏览器拒绝！\n请在浏览器地址栏输入'about:config'并回车\n然后将'signed.applets.codebase_principal_support'设置为'true'");     
          }     
          var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);     
          if (!clip)     
               return;     
          var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);     
          if (!trans)     
               return;     
          trans.addDataFlavor('text/unicode');     
          var str = new Object();     
          var len = new Object();     
          var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);     
          var copytext = txt;     
          str.data = copytext;     
          trans.setTransferData("text/unicode",str,copytext.length*2);     
          var clipid = Components.interfaces.nsIClipboard;     
          if (!clip)     
               return false;     
          clip.setData(trans,null,clipid.kGlobalClipboard);     
     }     
} 

/**
 * 获取打印模式
 * @param {科室} Loc
 * @param {类组} Scg
 * @return {String}	MM,MO,MF等类组集合
 */
function GetPrintMode(Loc,Scg){
	var Mode="";
	if(Loc==""){
		return "";
	}
	
	var url='dhcstm.stklocgrpaction.csp?actiontype=GetMode&LocId='+Loc+'&Scg='+Scg;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		Mode=jsonData.info;
	}
	
	return Mode;
}

/**
 * 获取当前模块的参数值(object格式), 参数值 = PropValueObj.参数名称
 * @param {} AppName
 * @param {} LocId
 * @return {} 参数值的object格式数据
 */
function GetAppPropValue(AppName, LocId){
	if(Ext.isEmpty(LocId)){
		var LocId = session['LOGON.CTLOCID'];
	}
	var LogUser= session['LOGON.USERID'];
	var LogGroup= session['LOGON.GROUPID'];
	var Param=LogGroup+"^"+LocId+"^"+LogUser;
	var PropValue = tkMakeServerCall('web.DHCSTM.Common.AppCommon', 'GetAppPropStr', AppName, Param);
	var PropValueObj = Ext.decode(PropValue);
	return PropValueObj;
}

/*获取请求科室是否使用关联科室的参数值*/
function GetReqLikLocPropValue()
{
	var reqparams=GetAppPropValue("DHCSTINREQM");
	var ReqLocifuseLikeLoc=reqparams.ReqLocUseLinkLoc;
	return ReqLocifuseLikeLoc;
}
///Extjs的grid表格的复制、粘贴
if (!Ext.grid.GridView.prototype.templates) {
   Ext.grid.GridView.prototype.templates = {};
}
Ext.grid.GridView.prototype.templates.cell = new Ext.Template(
   '<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} x-selectable {css}"  style="{style}" tabIndex="0" {cellAttr}>',
   '<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>',
   '</td>'
);

/**
 * 菜单跳转后,href中可能传递一些变量
 * 此方法在清空过程后方调用
 * 改动location后界面会重新加载
 */
function CheckLocationHref(){
	var pathname = location.pathname;
	var search = location.search;
	var mainmenuflag = pathname.indexOf('dhcstm.menu.csp') != -1? true : false;
	var websysflag = pathname.indexOf('websys.csp') != -1? true : false;
	//dhcstm.menu.csp是侧菜单模式用到的
	//websys.csp是头菜单模式用到的
	//若为界面跳转的菜单,使用的是明文csp(诸如dhcstm.ingdrec.csp)
	if((!mainmenuflag && !websysflag) && (search != '?' && search.indexOf('MENU') == -1)){
		location.search = '';
	}
}

/**基础数据平台功能授权判断
 * @param {} btnids:各个控件id拼成的串,如:var btnids="btnSearch^TextDesc";
*/
function Authorization(btnids){
	if (btnids == null || btnids == "") {
		return;
	}
	var btnid=btnids.split("^");
	try{
		for (var i = 0; i < btnid.length; i++) {
			if (BDPAutDisableFlag(btnid[i])==true) {
				Ext.getCmp(btnid[i]).setDisabled(BDPAutDisableFlag(btnid[i]));
			} else {
				//return;
			}
		}
	}
	catch(e){
	}
}
/**Grid Cell Tip 提示
 * @param {} grid
 *Creator:xuchao
 *Date: 2017-3-28
*/
function gridTip(grid){
    var view = grid.getView();
    var store = grid.getStore();
    var cm=grid.getColumnModel();
    grid.tip = new Ext.ToolTip({
        target: view.mainBody,
        delegate: '.x-grid3-cell',
        trackMouse: true,
        renderTo: document.body,
        anchor: 'top',
        listeners: {
            beforeshow: function(tip) {
                var rowIndex = view.findRowIndex(tip.triggerElement);
                var cellIndex = view.findCellIndex(tip.triggerElement);
                var Index=cm.getDataIndex(cellIndex);
                var column = cm.getColumnAt(cellIndex);
                var colRenderer = column.renderer;
                var innerHTML = store.getAt(rowIndex).get(Index);
                if(colRenderer.toString().replace(/\s/g,'') != "function(value){returnvalue;}"
                && column.xtype!='checkcolumn' && column.id != 'checker'){
                	innerHTML = column.renderer(innerHTML,{},store.getAt(rowIndex),rowIndex,cellIndex,store);
                }
                if(Ext.isEmpty(innerHTML)){
                	return false;
                }else{
                	tip.body.dom.innerHTML = innerHTML;
                }
            }
        }
    });
}
