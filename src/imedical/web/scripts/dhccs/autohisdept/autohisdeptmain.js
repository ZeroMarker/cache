/*
var testJsonHead = {
	results:13,
	rows:[
		//{rowid:'1',name:'date',title:'����'},
		//{rowid:'2',name:'person',title:'����Ա'},
		//{rowid:'3',name:'deptcode',title:'���Ҵ���'},
		//{rowid:'4',name:'deptname',title:'��������'},
		{rowid:'5',name:'allmoney',title:'����ϼ�'},
		{rowid:'6',name:'jiancha',title:'����'},
		{rowid:'7',name:'guahao',title:'�Һŷ�'},
		{rowid:'8',name:'huayan',title:'�����'},
		{rowid:'9',name:'zhenliao',title:'���Ʒ�'},
		{rowid:'10',name:'zhiliao',title:'���Ʒ�'},
		{rowid:'11',name:'shoushu',title:'������'}//,
		//{rowid:'12',name:'tempnumber',title:'��ʱƾ֤��'},
		//{rowid:'13',name:'cernumber',title:'ƾ֤���'}
	]
};

var testJsonData = {
	results:8,
	rows:[
		{rowid:'1',date:'2010-6-18',person:'����',deptcode:'1',deptname:'����1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'2',date:'2010-6-18',person:'����',deptcode:'2',deptname:'����2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'3',date:'2010-6-18',person:'����',deptcode:'1',deptname:'����1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'4',date:'2010-6-18',person:'����',deptcode:'2',deptname:'����2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100618',cernumber:'20100618'},
		{rowid:'5',date:'2010-6-19',person:'����',deptcode:'1',deptname:'����1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'},
		{rowid:'6',date:'2010-6-19',person:'����',deptcode:'2',deptname:'����2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'},
		{rowid:'7',date:'2010-6-19',person:'����',deptcode:'1',deptname:'����1',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'},
		{rowid:'8',date:'2010-6-19',person:'����',deptcode:'2',deptname:'����2',allmoney:'21',jiancha:'1',guahao:'2',huayan:'3',zhenliao:'4',zhiliao:'5',shoushu:'6',tempnumber:'20100619',cernumber:'20100619'}
	]
};

var cmItems = []; 
var cmConfig = {}; 
cmItems.push(new Ext.grid.RowNumberer()); 
var testJsonHeadNum = testJsonHead.results; 
var testJsonHeadList = testJsonHead.rows; 

var tmpDataMapping = []
cmItems.push({header : '���Ҵ���',dataIndex : 'deptcode',width : 100,sortable : true});
cmItems.push({header : '��������',dataIndex : 'deptname',width : 100,sortable : true});
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
			'�շ�ʱ��: ',
			tmpBDate,
			' �� ',
			tmpSDate
		]
	});

var unittypesMain = new Ext.grid.GridPanel({//���
		title: '�����һ���',
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
			title:'�����Ҳ�ѯ',
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