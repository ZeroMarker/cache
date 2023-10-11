// /名称: 全局变量及常用方法定义
// /描述: 全局变量及常用方法定义
// /编写者：zhangdongmei
// /编写日期: 2012.08.21

var PageSize = 30;
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var FieldDelim="^";  //字段间的分隔符

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

if(document.addEventListener){
		document.addEventListener("keydown",maskBackspace, true);
	}else{
		document.attachEvent("onkeydown",maskBackspace);
}	

/**
 * 执行数据库同步访问
 * @param {} url 访问路径
 * @return {}
 */
ExecuteDBSynAccess = function(url) {
	var conn = Ext.lib.Ajax.getConnectionObject().conn;
	conn.open("POST", url, false);
	conn.send();
	return conn.responseText;
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
//	var arr = window.status.split(":");
//	var length = arr.length;
//	var name = arr[length-1];
	var defaultData = {
		RowId : rowId,
		Description : App_LogonLocDesc
	};
	var record = new store.recordType(defaultData);
	store.add(record);
	Ext.getCmp(CmpName).setValue(rowId);
};

/**
 * 为ComboBox赋值
 * 需留意id的类型要和RowId一致(目前程序中基本都是String)
 */
function addComboData(store, id, desc) {
	if(store.findExact('RowId',id)==-1){
		var defaultData = {
			RowId : id,
			Description : desc
		};
		var r = new store.recordType(defaultData);
		store.add(r);
	}
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
		if(value.indexOf('-')){
			value=value.replace(/-/g,"/");
			var newValue=new Date(Date.parse(value));
			//newValue=newValue.format('Y-m-d');
		}
	}
	
	return newValue;
}

 //屏蔽编辑页面上BackSpace键
function maskBackspace(event){
	var event = event || window.event; //
	var obj = event.target || event.srcElement;
	var keyCode = event.keyCode ? event.keyCode : event.which ?
		event.which : event.charCode;
	if(keyCode == 8){
	if(obj!=null && obj.tagName!=null && (obj.tagName.toLowerCase() == "input" || obj.tagName.toLowerCase() == "textarea"))
	{
		event.returnValue = true ;
		if(Ext.getCmp(obj.id)){
			if(Ext.getCmp(obj.id).readOnly || (Ext.getCmp(obj.id).getXType()=='combo' &&  Ext.getCmp(obj.id).editable==false) ) {
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
 		else
 		{xx=xx+'\n\r'+ss[i];}
 	}
	return xx	
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

//合并某列中相同的行数据
function cellMerge(value, meta, record, rowIndex, colIndex, store,fieldName) {
    var first = !rowIndex || value !== store.getAt(rowIndex - 1).get(fieldName),
    last = rowIndex >= store.getCount() - 1 || value !== store.getAt(rowIndex + 1).get(fieldName);
    meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && value === store.getAt(i).get(fieldName)) {
            i++;
        }
        var rowHeight = 20, padding = 6,
            height = (rowHeight * (i - rowIndex) - padding) + 'px';
        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
    }
    return first ? value : '';
}

/*  保存grid中的数据到excel文件 
 *  要求：
 *     浏览器允许执行ActiveX控件
 * 
 * */
function gridSaveAsExcel(grid)
{
  	if (grid.getStore().getCount()==0)
	{
		Msg.info('warning','没有需要保存的数据！');
		return;
	};  

    var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	
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

	/*for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //只存没有隐藏的列
		}
	}*/
	
	for (i=1;i<colCount;i++)
	{	
			temp_obj.push(i);  //显示所有的列，包括隐藏的列  2015.8.18	
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
/*  保存store中的数据到excel文件 
 *  要求：
 *     浏览器允许执行ActiveX控件
 * 
 * */
function StoreSaveAsExcel(store,cm)
{
  	if (store.getCount()==0)
	{
		Msg.info('warning','没有需要保存的数据！');
		return;
	};  
    var fd;
    fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	
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
	var colCount=cm.getColumnCount();
	var temp_obj=[];
	var arr_obj=[];  ///存放原始record所有name

	for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //只存没有隐藏的列
		}
	}
	var temrecord=store.getAt(0)
	for (m in temrecord.data)
	{
		arr_obj.push(m);  //存原始序列
	}
	//Excel第一行存放标题
	for (l=0;l<arr_obj.length;l++)
	{
		for (n=0;n<temp_obj.length;n++)
		{
			if(arr_obj[l]==cm.getDataIndex(temp_obj[n]))
			{
				xlSheet.Cells(1,l+1).Value=cm.getColumnHeader(temp_obj[n]);
			}
		}
	}
	
	var recordCount=store.getCount();
	for (k=0;k<recordCount;k++)
	{
		var arrrecord=store.getAt(k)
		for (j=0;j<arr_obj.length;j++)
		{
			var indexname=arr_obj[j]
			xlSheet.Cells(k+2,j+1).Value=arrrecord.get(indexname)
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
/** 分页导出所有Execl导出方法 **/
function ExportAllToExcel(gridPanel) {
    if (gridPanel) {
        var tmpStore = gridPanel.getStore();
       
        //以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
        var tmpParam = tmpStore.lastOptions //此处克隆了原网格数据源的参数信息

        if (tmpParam && tmpParam.params) {
            tmpParam.params[tmpStore.paramNames.start]=0; //
            tmpParam.params[tmpStore.paramNames.limit]=999999; //重置分页信息
        }
        var tmpAllStore = new Ext.data.GroupingStore({//重新定义一个数据源
            proxy: tmpStore.proxy,
            reader: tmpStore.reader
        });
        tmpAllStore.on('load', function (store) {
            StoreSaveAsExcel(store,gridPanel.getColumnModel())
        });
        tmpAllStore.load(tmpParam); //获取所有数据
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

 ///清除panel下的item的值
function clearPanel(panel)
{
	var i=0;
	var p=Ext.getCmp(panel);
	if (p) {
		var pp = p.items;
		var cnt = pp.getCount();
		
		for (var i=0;i<cnt;i++) {
			var xtype = pp.item(i).getXType();
//			alert(xtype);
			if (xtype) {
				if ((xtype == 'textfield') || (xtype == 'datefield') || (xtype == 'numberfield') || (xtype == 'textarea') || (xtype == 'timefield')) {
					pp.item(i).setValue('');
				}
				if (xtype == 'combo') {
					pp.item(i).clearValue();
				}
				
				if ((xtype == 'checkbox') || (xtype == 'radio')) {
					pp.item(i).setValue(false);
				}
				
				if (xtype=='panel') {
					var panelId=pp.item(i).getId();
					if (panelId) {clearPanel(panelId);//此处递归
					}
				}
			}
		}
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
