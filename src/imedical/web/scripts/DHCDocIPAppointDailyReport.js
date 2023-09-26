
var DateCondition = new Ext.form.DateField({
	id : 'DateCondition',
	format : 'Y-m-d',
	width : 100,
	height : 25,
	fieldLabel : '����',
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
	//,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
	//,columnWidth : .60 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
	//,layout : 'form' //���ַ�ʽ
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
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
		,columns: [
			new Ext.grid.RowNumberer({header:"���"	,width:30})
			,{header: 'AppLocId', width: 100, dataIndex: 'AppLocId', sortable: true,hidden:true}
			,{header: '��������', width: 100, dataIndex: 'LocDesc', sortable: true}
			,{header: '��סԺ֤����', width: 100, dataIndex: 'AppCount', sortable: true}
			,{header: '����Ժ����', width: 100, dataIndex: 'ArriveCount', sortable: true}
			,{header: '��ѹ��', width: 100, dataIndex: 'OverCount', sortable: true}
			,{header: 'סԺ֤��ʧ��', width: 100, dataIndex: 'LostCount', sortable: true}
			,{header: '��ƽ��������', width: 100, dataIndex: 'PreWaitCount', sortable: true}		
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
			{region:"center",split:true,border:true,collapsible:true,autoScroll:true,title:"סԺ�������Ĺ���ͳ�Ʊ�",items:[DailyReport]}
		]
	});
		Ext.get('DateCondition').on("focus", function(){
		DailyReportStore.load({});
		});
})
