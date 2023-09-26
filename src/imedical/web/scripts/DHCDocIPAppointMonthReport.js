
var DateCondition = new Ext.form.DateField({
	id : 'DateCondition',
	format : 'Y-m',
	width : 100,
	height : 25,
	fieldLabel : '日期',
	anchor : '80%',
	altFormats : 'Y-m|m/Y',
	value : new Date()
});

var pConditionChild01 = new Ext.Panel({
	id : 'pConditionChild01'
	,buttonAlign : 'center'
	,labelAligh:'center'
	,columnWidth : .3
	,layout : 'form'
	,items : [DateCondition]
});

var Export = new Ext.Button({
	id : 'Export',
	height : 25,
	//iconCls : 'icon-find',
	text : '导出'
});

var pConditionChild02 = new Ext.Panel({
	id : 'pConditionChild02'
	,buttonAlign : 'center'
	,labelAligh:'center'
	,columnWidth : .2
	,layout : 'form'
	,items : [Export]
});

var Condition = new Ext.form.FormPanel({
	id : 'Condition',
	buttonAlign : 'center',
	labelAlign : 'center', 
	labelWidth : 100,
	bodyBorder : 'padding:0 0 0 0',
	layout : 'column',
	region : 'north',
	frame : true,
	height : 60,
	//,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
	//,columnWidth : .60 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
	//,layout : 'form' //布局方式
	items : [pConditionChild01, pConditionChild02]
});

var MonthReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
}));

var MonthReportStore = new Ext.data.Store({
		proxy: MonthReportStoreProxy,
		autoLoad:true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AppLocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'AppLocId', mapping: 'AppLocId'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'AveVisitCount', mapping: 'AveVisitCount'}
			,{name: 'LostCountMonth', mapping: 'LostCountMonth'}
		])
	});
	
var MonthReportCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });

var MonthReport = new Ext.grid.GridPanel({
		id : 'MonthReport'
		,store : MonthReportStore
		,region : 'center'
		,layout: 'fit'
		,autoHeight:true
		,buttonAlign : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [
			new Ext.grid.RowNumberer({header:"序号"	,width:30})
			,{header: 'AppLocId', width: 100, dataIndex: 'AppLocId', sortable: true,hidden:true}
			,{header: '科室名称', width: 100, dataIndex: 'LocDesc', sortable: true}
			,{header: '日均待床病人数', width: 100, dataIndex: 'AveVisitCount', sortable: true}
			,{header: '月流失病人总数', width: 100, dataIndex: 'LostCountMonth', sortable: true}		
		]
		//AppLocId:%String,LocDesc:%String,AveVisitCount:%String,LostCount:%String
		//,selModel:Ext.create('Ext.selection.CheckboxModel',{mode:"SIMPLE"})
	});

MonthReportStoreProxy.on('beforeload', function(objProxy, param){
	var dateCondition=DateCondition.getRawValue();
	//alert(dateCondition.value)
	param.ClassName = 'web.DHCDocIPAppointment';
	param.QueryName = 'IPAppointMonthReport';
	param.Arg1 = dateCondition ; 
	param.ArgCnt = 1;
	
});

Ext.onReady(function(){
	
	new Ext.Viewport({
		id : 'viewScreen'
		,enableTabScroll:true
		,collapsible:true
		,layout:"border"
		,items:[
			{region:"north",height:60,items:[Condition]},
			{region:"center",split:true,border:true,collapsible:true,autoScroll:true,title:"床位管理月报表",items:[MonthReport]}
		]
	});
	
	Ext.get('DateCondition').on("focus", function(){
		MonthReportStore.load({});
	});
	
	Ext.get('Export').on("click",Export_onclick);
});

function Export_onclick() {
	
	var Path=cspRunServerMethod(PathMethod,'','');
	
	var Template=Path+"DHCOPRegReportsZZ.xls";
	//DHCDocIPMonthReport.xls
	
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.Add(Template); 
	//xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet = xlBook.ActiveSheet; 
	
	var MonthReportReport = Ext.getCmp('MonthReport').getStore(); 
	var prtrows=4;
	for (var i = 0; i < MonthReportReport.getCount(); i++) {  
   		var LocDesc=MonthReportReport.getAt(i).get('LocDesc'); 
   		var AveVisitCount=MonthReportReport.getAt(i).get('AveVisitCount');
   		var LostCount=MonthReportReport.getAt(i).get('LostCount');
   		//alert("LocDesc=="+LocDesc+"  AveVisitCount=="+AveVisitCount+"  LostCount=="+LostCount);
   		xlsheet.cells(prtrows,2)=LocDesc;
   		xlsheet.cells(prtrows,3)=AveVisitCount;
   		xlsheet.cells(prtrows,4)=LostCount;
   		prtrows=++prtrows;
	}
	
	
	xlApp.Visible=true
	//xlsheet.PrintPreview();
   	xlApp.UserControl = true;
   	/*
   	xlBook.SaveAs("C:\\预约记录.xls");
    xlBook.Close (savechanges=false);
    
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	*/
	
}

