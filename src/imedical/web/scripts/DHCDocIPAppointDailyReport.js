
var DateCondition = new Ext.form.DateField({
	id : 'DateCondition',
	format : 'Y-m-d',
	width : 100,
	height : 25,
	fieldLabel : '日期',
	anchor : '80%',
	altFormats : 'Y-m-d|d/m/Y',
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
var Condition = new Ext.form.FormPanel({
	id : 'Condition',
	buttonAlign : 'center',
	labelAlign : 'right', 
	labelWidth : 100,
	bodyBorder : 'padding:0 0 0 0',
	layout : 'column',
	region : 'north',
	frame : true,
	height : 60,
	//,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
	//,columnWidth : .60 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
	//,layout : 'form' //布局方式
	items : [pConditionChild01]
});
var DailyReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
}));

var DailyReportStore = new Ext.data.Store({
		proxy: DailyReportStoreProxy,
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
			,{name: 'AppCount', mapping: 'AppCount'}
			,{name: 'ArriveCount', mapping: 'ArriveCount'}
			,{name: 'OverCount', mapping: 'OverCount'}
			,{name: 'LostCount', mapping: 'LostCount'}
			,{name: 'PreWaitCount', mapping: 'PreWaitCount'}
		])
	});

	
var DailyReportCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });

var DailyReport = new Ext.grid.GridPanel({
		id : 'DailyReport'
		,store : DailyReportStore
		,region : 'center'
		,layout: 'fit'
		,autoHeight:true
		,buttonAlign : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [
			new Ext.grid.RowNumberer({header:"序号"	,width:30})
			,{header: 'AppLocId', width: 100, dataIndex: 'AppLocId', sortable: true,hidden:true}
			,{header: '科室名称', width: 100, dataIndex: 'LocDesc', sortable: true}
			,{header: '收住院证人数', width: 100, dataIndex: 'AppCount', sortable: true}
			,{header: '收入院人数', width: 100, dataIndex: 'ArriveCount', sortable: true}
			,{header: '积压数', width: 100, dataIndex: 'OverCount', sortable: true}
			,{header: '住院证流失数', width: 100, dataIndex: 'LostCount', sortable: true}
			,{header: '日平均待床数', width: 100, dataIndex: 'PreWaitCount', sortable: true}		
		]
		//AppLocId,LocDesc,AppCount,ArriveCount,OverCount,LostCount,PreWaitCount
		//,selModel:Ext.create('Ext.selection.CheckboxModel',{mode:"SIMPLE"})
	});
	
DailyReportStoreProxy.on('beforeload', function(objProxy, param){
	var dateCondition=DateCondition.getRawValue();
	param.ClassName = 'web.DHCDocIPAppointment';
	param.QueryName = 'IPAppointDailyReport';
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
			{region:"center",split:true,border:true,collapsible:true,autoScroll:true,title:"住院管理中心工作统计表",items:[DailyReport]}
		]
	});
		Ext.get('DateCondition').on("focus", function(){
		DailyReportStore.load({});
		});
})
