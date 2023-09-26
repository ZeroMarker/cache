var gGroupId=session['LOGON.GROUPID'];
var gCtLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
//var gUserInitial = session['LOGON.USERCODE'];		//ͳһʹ�ù���!!!
/// ��Ӧ��BPMģ�ͱ�ʶ
var G_BPMCode = "InHosp";
/// ϵͳ��ʶ
var G_SysCode = "sys_DHCSTM";
var G_Bpm_DATEFORMAT = "Y-m-d H:i:s";

//��BPMʱ���ʽ��ͬ,���е�����ʽ��
function TimeStampRender(value){
	if(value.length > 11){
		//BPM���ص���YYYY-mm-dd hh:ii:ss��ʽ
		var TimeArr = value.split(' ');
		var DateStr = TimeArr[0], TimeStr = TimeArr[1];
		var RenderDate = new Date(DateStr).format(DateFormat);
		return RenderDate + ' ' + TimeStr;
	}
	return value;
}

var NI_fields = ["taskId","taskName","businessId","title","beginDate",
	"endDate","assignee","owner","taskDefKey","procInsId",
	"procDefId","procDefKey","beginDateStr","endDateStr","excutionId",
	"taskName"];

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ʼ����</font>',
	id : 'DateFrom',
	anchor : '90%',
	value : new Date().add(Date.DAY,-15)
});

var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ֹ����</font>',
	id : 'DateTo',
	anchor : '90%',
	value : new Date()
});

/**
 * �����ϸ�����Ϣ
 */
function ClearData(){
	newitmGrid.getStore().removeAll();
	newitmaduGrid.getStore().removeAll();
}

var toDoGridDs = new Ext.data.JsonStore({
	url : 'dhcstm.newitmaction.csp?actiontype=todoList',
	totalProperty : "total",
	pruneModifiedRecords:true,
	root : 'listData',
	fields : NI_fields
});

var toDoGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : '����id',
		dataIndex : 'taskId',
		hidden : true
	},{
		header : "��������",
		dataIndex : 'taskName',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������",
		dataIndex : 'businessId',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "����������",
		dataIndex : 'title',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������ʱ��",
		dataIndex : 'beginDateStr',
		renderer : TimeStampRender,
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var toDoGrid = new Ext.grid.GridPanel({
	title:'�����б�',
	id : 'toDoGrid',
	store:toDoGridDs,
	cm:toDoGridCm,
	sm : new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var Parref = r.get('businessId');
				
				newitmGrid.getStore().removeAll();
				newitmGrid.getStore().load({
					params : {Parref : Parref}
				});
				
				newitmaduGrid.getStore().removeAll();
				newitmaduGrid.getStore().load({
					params : {Parref : Parref}
				});
			}
		}
	}),
	listeners:{
		expand :function(p){
			ClearData();
			
			var StartDate=Ext.getCmp("DateFrom").getValue().format(G_Bpm_DATEFORMAT).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format('Y-m-d') + ' 23:59:59';
			var ParamObj={};
			ParamObj.allParams={};
			ParamObj.pageNo=1;
			ParamObj.pageSize=-1;						//����ҳ
//			ParamObj.sort = 'businessId';
//			ParamObj.order = 'desc';
			
			ParamObj.businessId = '';
			ParamObj.businessIdLike = '';
			ParamObj.title = '';
			ParamObj.titleLike = '';
			ParamObj.allParams.beginDate=StartDate;
			ParamObj.allParams.endDate=EndDate;
			ParamObj.allParams.userId=gUserId;
			ParamObj.assignee = '';
			ParamObj.assigneeLike = '';
			ParamObj.owner = '';
			ParamObj.ownerLike = '';
			ParamObj.allParams.tenantId = G_SysCode;
			var Param=Ext.encode(ParamObj);
			p.store.setBaseParam("Param",Param);
			p.store.load({
				callback : function(r,options,success){
				}
			});
		},
		rowdblclick : function(Grid, rowIndex, e){
			var RowData = this.getStore().getAt(rowIndex);
			var NIRowId = RowData.get('businessId');
			var taskDefKey = RowData.get('taskDefKey');
			CreateNewItmRequest('BPMPass', NIRowId, taskDefKey, RowData);
		}
	}
});

var firDoGridDs = new Ext.data.JsonStore({
	url : 'dhcstm.newitmaction.csp?actiontype=draftByMeList',
	totalProperty : "total",
	pruneModifiedRecords:true,
	root : 'listData',
	fields : NI_fields
});

var firDoGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : '����id',
		dataIndex : 'taskId',
		hidden : true
	},{
		header : "��������",
		dataIndex : 'taskName',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������",
		dataIndex : 'businessId',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "����������",
		dataIndex : 'title',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������ʱ��",
		dataIndex : 'beginDateStr',
		renderer : TimeStampRender,
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var firDoGrid = new Ext.grid.GridPanel({
	title:'�ҵ����',
	id : 'firDoGrid',
	store:firDoGridDs,
	cm:firDoGridCm,
	sm : new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var Parref = r.get('businessId');
				newitmGrid.getStore().removeAll();
				newitmGrid.getStore().load({
					params : {Parref : Parref}
				});
				
				newitmaduGrid.getStore().removeAll();
				newitmaduGrid.getStore().load({
					params : {Parref : Parref}
				});
			}
		}
	}),
	listeners:{
		expand : function(p){
			ClearData();
			
			var StartDate=Ext.getCmp("DateFrom").getValue().format(G_Bpm_DATEFORMAT).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format('Y-m-d') + ' 23:59:59';
			var ParamObj={};
			ParamObj.allParams={};
			ParamObj.pageNo=1;
			ParamObj.pageSize=-1;		//����ҳ
			ParamObj.allParams.beginDate=StartDate;
			ParamObj.allParams.endDate=EndDate;
			ParamObj.allParams.userId=gUserId;
			ParamObj.allParams.tenantId=G_SysCode;
			
			ParamObj.allParams.businessId = '';		//���������",
			ParamObj.allParams.businessIdLike = '';	//���������ģ����ѯ
			ParamObj.allParams.title = '';			//����������					 
			ParamObj.allParams.titleLike = '';		//����������ģ����ѯ
			
			var Param=Ext.encode(ParamObj);
			p.store.setBaseParam("Param",Param);
			p.store.load({
				callback : function(r,options,success){
				}
			});
		}
	}
});

var didGridDs = new Ext.data.JsonStore({
	url : 'dhcstm.newitmaction.csp?actiontype=finishList',
	totalProperty : "total",
	pruneModifiedRecords:true,
	root : 'listData',
	fields : NI_fields
});

var didGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : '����id',
		dataIndex : 'taskId',
		hidden : true
	},{
		header : "��������",
		dataIndex : 'taskName',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������",
		dataIndex : 'businessId',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "����������",
		dataIndex : 'title',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������ʱ��",
		dataIndex : 'beginDateStr',
		renderer : TimeStampRender,
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var didGrid = new Ext.grid.GridPanel({
	title:'�Ѱ��б�',
	id : 'didGrid',
	store:didGridDs,
	cm:didGridCm,
	sm : new Ext.grid.RowSelectionModel({
	listeners : {
			rowselect : function(sm, rowIndex, r){
				var Parref = r.get('businessId');
				
				newitmGrid.getStore().removeAll();
				newitmGrid.getStore().load({
					params : {Parref : Parref}
				});
				
				newitmaduGrid.getStore().removeAll();
				newitmaduGrid.getStore().load({
					params : {Parref : Parref}
				});
			}
		}
	}),
	listeners:{
		expand :function(p){
			ClearData();
			
			var StartDate=Ext.getCmp("DateFrom").getValue().format(G_Bpm_DATEFORMAT).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format('Y-m-d') + ' 23:59:59';
			var ParamObj={};
			ParamObj.allParams={};
			ParamObj.pageNo=1;
			ParamObj.pageSize=-1;						//����ҳ
//			ParamObj.sort = 'businessId';
//			ParamObj.order = 'desc';
			
			ParamObj.businessId = '';
			ParamObj.businessIdLike = '';
			ParamObj.title = '';
			ParamObj.titleLike = '';
			ParamObj.allParams.beginDate=StartDate;
			ParamObj.allParams.endDate=EndDate;
			ParamObj.allParams.userId=gUserId;
			ParamObj.assignee = '';
			ParamObj.assigneeLike = '';
			ParamObj.owner = '';
			ParamObj.ownerLike = '';
			ParamObj.allParams.tenantId = G_SysCode;
			var Param=Ext.encode(ParamObj);
			p.store.setBaseParam("Param",Param);
			p.store.load({
				callback : function(r,options,success){
				}
			});
		}
	}
});

var savedGridDs = new Ext.data.JsonStore({
	url : 'dhcstm.newitmaction.csp?actiontype=myDraftList',
	totalProperty : "total",
	pruneModifiedRecords:true,
	root : 'listData',
	fields : NI_fields
});

var savedGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : '����id',
		dataIndex : 'taskId',
		hidden : true
	},{
		header : "��������",
		dataIndex : 'taskName',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������",
		dataIndex : 'businessId',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "����������",
		dataIndex : 'title',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "���������ʱ��",
		dataIndex : 'beginDateStr',
		renderer : TimeStampRender,
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var savedGrid = new Ext.grid.GridPanel({
	title : '�ҵĲݸ�',
	id : 'savedGrid',
	store : savedGridDs,
	cm : savedGridCm,
	sm : new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var Parref = r.get('businessId');
				
				newitmGrid.getStore().removeAll();
				newitmGrid.getStore().load({
					params : {Parref : Parref}
				});
				
				newitmaduGrid.getStore().removeAll();
				newitmaduGrid.getStore().load({
					params : {Parref : Parref}
				});
			}
		}
	}),
	listeners:{
		expand :function(p){
			ClearData();
			
			var StartDate=Ext.getCmp("DateFrom").getValue().format(G_Bpm_DATEFORMAT).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format('Y-m-d') + ' 23:59:59';
			var ParamObj={};
			ParamObj.allParams={};
			ParamObj.pageNo=1;
			ParamObj.pageSize=-1;						//����ҳ
//			ParamObj.sort = 'businessId';
//			ParamObj.order = 'desc';
			ParamObj.allParams.beginDate=StartDate;
			ParamObj.allParams.endDate=EndDate;
			ParamObj.allParams.userId=gUserId;
			ParamObj.allParams.tenantId=G_SysCode;
			var Param=Ext.encode(ParamObj);
			p.store.setBaseParam("Param",Param);
			p.store.load({
				callback : function(r,options,success){
				}
			});
		},
		rowdblclick : function(Grid, rowIndex, e){
			var RowData = this.getStore().getAt(rowIndex);
			var NIRowId = RowData.get('businessId');
			var taskDefKey = RowData.get('taskDefKey');
			CreateNewItmRequest('BPMSubmit', NIRowId, taskDefKey, RowData);
		}
	}
});
var ItmRequestButton = new Ext.Toolbar.Button({
	text : '�������뵥',
	tooltip : '�������뵥',
	iconCls : 'page_add',
	width : 70,
	height : 30,
	handler : function() {
		CreateNewItmRequest('BPMSave', '', G_BPM_INITIATOR);
	}
});

/** ������ */
var westpanel = new Ext.Panel({
	id:'westpanel',
	region:"west",
	title:'�����б�',
	split:true,
	width:430,
	minSize: 320,
	maxSize: 500,
	layout:"accordion",
	layoutConfig: {animate: true},
	tbar:[ItmRequestButton,'-',"��ʼ����",DateFrom,'-','��������',DateTo],
	items:[toDoGrid,didGrid,firDoGrid,savedGrid]
});


var newitmGridDs = new Ext.data.JsonStore({
	url : 'dhcstm.newitmaction.csp?actiontype=GetNewItmInfo',
	totalProperty : "results",
	pruneModifiedRecords:true,
	root : 'rows',
	fields : ['Desc', 'Value']
});

var newitmGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : '�ֶ�',
		dataIndex : 'Desc',
		width : 150
	},{
		header : "�ֶ�ֵ",
		dataIndex : 'Value',
		width : 150,
		align : 'center',
		sortable : true
	}
]);

var newitmGrid = new Ext.grid.GridPanel({
	region : "north",
	height : 300,
	title : '��ǰ��ϸ��Ϣ',
	id : 'newitmGrid',
	store : newitmGridDs,
	cm : newitmGridCm,
	sm : new Ext.grid.RowSelectionModel({})
});

var newitmaduGridDs = new Ext.data.JsonStore({
	url : 'dhcstm.newitmaction.csp?actiontype=GetNewItmAudRec',
	totalProperty : "results",
	root : 'rows',
	pruneModifiedRecords : true,
	fields : ['NIId', 'NICh', 'ARUser', 'ARDate', 'ARTime', 'AROpinion']
});

var newitmaduGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'ҵ��id',
		dataIndex : 'NIId',
		width : 50,
		hidden : true
	},{
		header : "��ϸid",
		dataIndex : 'NICh',
		width : 50,
		hidden : true
	},{
		header : "�����",
		dataIndex : 'ARUser',
		width : 80,
		align : 'left'
	},{
		header : "����",
		dataIndex : 'ARDate',
		width : 100,
		align : 'left'
	},{
		header : "ʱ��",
		dataIndex : 'ARTime',
		width : 100,
		align : 'left'
	},{
		header : "���",
		dataIndex : 'AROpinion',
		width : 300,
		align : 'left'
	}
]);

var newitmaduGrid = new Ext.grid.GridPanel({
	title : '������ϸ��˼�¼',
	region : "center",
	id : 'newitmaduGrid',
	store : newitmaduGridDs,
	cm : newitmaduGridCm,
	sm : new Ext.grid.RowSelectionModel({})
});

var centerpanel = new Ext.Panel({
	region : 'center',
	layout : 'border',
	items : [newitmGrid, newitmaduGrid]
});

Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.QuickTips.init();
	var viewport = new Ext.Viewport({
		layout:'border',
		items:[westpanel,centerpanel]
	});
	
	//���ص�ǰչ����grid
	toDoGrid.fireEvent('expand', toDoGrid);
});
