var Paramstr=""

function ShowInfo(){
	var selectRows = TasksGrid.getSelectionModel().getSelected();
	var Type=selectRows.get("Type")
	var Status=selectRows.get("Status")
	var HVFlag=selectRows.get("HVFlag")
	if(Type=="Req"){
		ShowReqWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Pur"){
		ShowPurWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Po"){
		ShowPoWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Rec"){
		ShowRecWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Ret"){
		ShowRetWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Trf"){
		ShowTrfWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Adj"){
		ShowAdjWin(Status,HVFlag,Paramstr,TasksDs);
	}else if(Type=="Scrap"){
		ShowScrapWin(Status,HVFlag,Paramstr,TasksDs);
	}
}
var TasksUrl = 'dhcstm.deskaction.csp';
var TasksProxy= new Ext.data.HttpProxy({url:TasksUrl+'?actiontype=QueryTasks',method:'GET'});
var TasksDs = new Ext.data.Store({
	pruneModifiedRecords : true,
	proxy:TasksProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Type'},
		{name:'TypeDesc'},
		{name:'Status'},
		{name:'StatusDesc'},
		{name:'LocId'},
		{name:'LocDesc'},
		{name:'Qty'},
		{name:'HVFlag'}
	]),
	remoteSort:false
});

//ģ��
var TasksCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"RowId",
		dataIndex:'RowId',
		hidden : true,
		width:80
	},{
		header:"LocId",
		dataIndex:'LocId',
		width:80,
		align:'left',
		hidden : true,
		sortable:true
	},{
		header:"��ǰ����",
		dataIndex:'LocDesc',
		width:80,
		align:'left',
		hidden : true,
		sortable:true
	},{
		header:"Type",
		dataIndex:'Type',
		width:80,
		align:'left',
		hidden : true,
		sortable:true
	},{
		header:"ҵ��",
		dataIndex:'TypeDesc',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"Status",
		dataIndex:'Status',
		width:80,
		align:'left',
		hidden : true,
		sortable:true
	},{
		header:"״̬",
		dataIndex:'StatusDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'Qty',
		width:80,
		align:'right',
		sortable:true
	},{
		header:"��ֵ��־",
		dataIndex:'HVFlag',
		width:80,
		align:'left',
		hidden : true,
		sortable:true
	}
]);

//��ʼ��Ĭ��������
TasksCm.defaultSortable = true;

//���
TasksGrid = new Ext.grid.EditorGridPanel({
	title : '��������',
	store:TasksDs,
	cm:TasksCm,
	trackMouseOver:true,
	stripeRows:true,
	clicksToEdit:1,
	sm:new Ext.grid.RowSelectionModel({
	}),
	loadMask:true,
	listeners : {
		'rowdblclick' : function() {
			ShowInfo();
		}
	}
});

Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	Paramstr=gHospId+"^"+gGroupId+"^"+gLocId+"^"+gUserId
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'fit',
		items:[TasksGrid]
	});
	TasksDs.load({params:{ParamStr:Paramstr}});
});