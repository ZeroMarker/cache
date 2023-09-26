/*
var testJsonHead = {
	results:13,
	rows:[
		//{rowid:'1',name:'date',title:'日期'},
		//{rowid:'2',name:'person',title:'结算员'},
		//{rowid:'3',name:'deptcode',title:'科室代码'},
		//{rowid:'4',name:'deptname',title:'科室名称'},
		{rowid:'5',name:'allmoney',title:'收入合计'},
		{rowid:'6',name:'jiancha',title:'检查费'},
		{rowid:'7',name:'guahao',title:'挂号费'},
		{rowid:'8',name:'huayan',title:'化验费'},
		{rowid:'9',name:'zhenliao',title:'诊疗费'},
		{rowid:'10',name:'zhiliao',title:'治疗费'},
		{rowid:'11',name:'shoushu',title:'手术费'}//,
		//{rowid:'12',name:'tempnumber',title:'临时凭证号'},
		//{rowid:'13',name:'cernumber',title:'凭证编号'}
	]
};

var testJsonData = {
	results:8,
	rows:[
		{rowid:'1',date:'2010-6-18',person:'张三',deptcode:'1',deptname:'科室1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'2',date:'2010-6-18',person:'张三',deptcode:'2',deptname:'科室2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'3',date:'2010-6-18',person:'李四',deptcode:'1',deptname:'科室1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'4',date:'2010-6-18',person:'李四',deptcode:'2',deptname:'科室2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'5',date:'2010-6-19',person:'张三',deptcode:'1',deptname:'科室1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'},
		{rowid:'6',date:'2010-6-19',person:'张三',deptcode:'2',deptname:'科室2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'},
		{rowid:'7',date:'2010-6-19',person:'李四',deptcode:'1',deptname:'科室1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'},
		{rowid:'8',date:'2010-6-19',person:'李四',deptcode:'2',deptname:'科室2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'}
	]
};

var cmItems = []; 
var cmConfig = {}; 
cmItems.push(new Ext.grid.RowNumberer()); 
var testJsonHeadNum = testJsonHead.results; 
var testJsonHeadList = testJsonHead.rows; 

var tmpDataMapping = []
cmItems.push({header : '科室代码',dataIndex : 'deptcode',width : 100,sortable : true});
cmItems.push({header : '科室名称',dataIndex : 'deptname',width : 100,sortable : true});
tmpDataMapping.push('deptcode');
tmpDataMapping.push('deptname');
for(var i=0;i<testJsonHeadList.length;i++){ 
     cmConfig = {header : testJsonHeadList[i].title,dataIndex : testJsonHeadList[i].name,width : 100,sortable : true} 
     cmItems.push(cmConfig); 
     tmpDataMapping.push(testJsonHeadList[i].name);  
} 
var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);

var tmpStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(testJsonData),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, tmpDataMapping
    )
    //remoteSort: true
});

var myTB = new Ext.Toolbar({
		height:24,
		items:[
			'收费时间: ',
			tmpBDate,
			' 至 ',
			tmpSDate
		]
	});

var unittypesMain = new Ext.grid.GridPanel({//表格
		title: '按科室汇总',
		store: tmpStore,
		cm: tmpColumnModel,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: myTB
});

tmpStore.load({params:{start:0}});
*/
OPReportCatDetailByLocFun = function(sdate, bdate) {

	var purchasestorageformWin = new Ext.Window({
			title:'按科室查询',
			width:1050,
			height:600,  
			minWidth:1050,
			minHeight:600,
			layout:'border',
			plain:true,
			modal:true,
			items: []
		});
		
	purchasestorageformWin.show();
	
};