


var serviceOrderStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	
//��ѯҽ����Ϣ
/*
serviceOrderStoreProxy.on('beforeload',serviceOrderProxyBeforeload);
	
//serviceOrderStore.on('load',serviceOrderStoreload);

function serviceOrderProxyBeforeload(objProxy,param){
	
	//alert(adm1);
	param.ClassName='web.DHCRisBookSelSeat';
	param.QueryName='QueryBookOrder';
	param.Arg1 = admSchedule;
	param.ArgCnt = 1;
};
*/



var serviceOrderStore = new Ext.data.GroupingStore({   //new Ext.data.Store({
		proxy : serviceOrderStoreProxy,
		reader : new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty:'Group'
		},
		[			
			{name:'oeOrdDr',mapping:'ExamOrder'},
			{name:'OrderName',mapping:'OrderName'},
			{name:'arcItmDr',mapping:'ArcItmId'},   //mapping:'',
			{name:'scheduleDr',mapping:'SchRowid'},
			{name:'orderDate',mapping:'datestr'},
			{name:'orderTime',mapping:'timestr'},
			{name:'bookRes',mapping:'BookRes'},
			{name:'bookDate',mapping:'BookDate'},
			{name:'bookTime',mapping:'BookTime'},
			{name:'recLocDr',mapping:'RecLocDR'},
			{name:'recLoc',mapping:'LocDesc'},
			{name:'Status',mapping:'Status'}
			//{name:'recLoc',mapping:'LocDesc'}
		]),
		//groupField:'status',
		sortInfo:{field:'orderDate',direction:'ASC'}
});


//var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:false,checkOnly:true});
var sm = new Ext.grid.CheckboxSelectionModel();
//var sm = new Ext.grid.CheckboxSelectionModel({
//  handleMouseDown:Ext.emtyFn
//  });



var serviceOrderGrid = new Ext.grid.GridPanel({
		id:'serviceOrderGrid',
		store:serviceOrderStore,
		title:'ҽ���б�',
		layout:"fit",
		height:260,
		sm:sm,
		//bodyStyle: 'background:#ffc; padding:10px;',
		style:'border: 1px solid #8db2e3;',
		loadMask:true,
		columns:[
			new Ext.grid.RowNumberer(),
			//{header:'ѡ��',width:100,dataIndex:'checked'},
			sm ,
			{header:'ҽ��Rowid',width:70,dataIndex:'oeOrdDr'},
			{header:'ҽ������',width:150,dataIndex:'OrderName'},
			{header:'ҽ������',width:100,dataIndex:'orderDate',sortable:true},
			{header:'ҽ��ʱ��',width:0,dataIndex:'orderTime',sortable:true},
			{header:'״̬',width:80,dataIndex:'Status'},   //Status
			{header:'���տ���',width:150,dataIndex:'recLoc',sortable:true},   //RecLocDR    recLoc
			{header:'ԤԼ����',width:100,dataIndex:'bookDate',sortable:true},
			{header:'ԤԼʱ��',width:100,dataIndex:'bookTime',sortable:true},
			{header:'ԤԼ��Դ',width:100,dataIndex:'bookRes',sortable:true},		
			{header:'�����Ŀrowid',width:80,dataIndex:'arcItmDr'},
			{header:'scheduleDr',width:80,dataIndex:'scheduleDr'}
					
		],
		items:[],
		listeners:{	
	         render:function(){
	         var hd_checker = this.getEl().select('div.x-grid3-hd-checker');
	         if (hd_checker.hasClass('x-grid3-hd-checker')) {  
	                hd_checker.removeClass('x-grid3-hd-checker'); // ȥ��ȫѡ�� 
	            } 
	         }         
		}
		
});


var orderListRegion = new Ext.FormPanel({
	//title:"ҽ���б�",
	region:'south',
	height:150,
	layout: 'anchor',
	//collapsible:true,
	//split:true,
	frame:false,
	autoScroll:true,
	items:[
		serviceOrderGrid  //,
		//pnButton
	]
});

