//����:	�������-�������

var url = 'dhcstm.inrequestaction.csp';
var CtLocId = session['LOGON.CTLOCID'];
var CompletedFlag='Y';
//��ʼ����������
if(gParam.length<1){
	GetParam(); 
}
//��ʼ����
var startDate = new Ext.ux.DateField({
	id:'startDate',
	//width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'��ʼ����',
	anchor:'95%',
	value:DefaultStDate()
});
//��ֹ����
var endDate = new Ext.ux.DateField({
	id:'endDate',
	//width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'��ֹ����',
	anchor:'95%',
	value:DefaultEdDate()
});

var Loc = new Ext.ux.LocComboBox({
	id:'Loc',
	anchor:'95%',
	fieldLabel:'������',
	emptyText:'������...',
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
	groupId:session['LOGON.GROUPID']
});

/*
var SupplyLoc = new Ext.ux.LocComboBox({
	id:'SupplyLoc',
	fieldLabel:'��������',
	anchor:'95%',
	emptyText:'��������...',
	defaultLoc:{}
});
*/

//var SupplyLoc = new Ext.ux.ComboBox({
//	id:'SupplyLoc',
//	fieldLabel:'��������',
//	anchor:'95%',
//	store:frLocListStore,
//	displayField:'Description',
//	valueField:'RowId',
//	listWidth:210,
//	emptyText:'��������...',
//	//groupId:gGroupId,
//	params:{LocId:'Loc'}
//});


var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','��ʱ����'],['C','����ƻ�']]
})
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'��������',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'��������...',
	triggerAction:'all',
	anchor:'95%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local'
});

var RecLocAudited= new Ext.form.Checkbox({
	id: 'RecLocAudited',
	boxLabel:'�����ͨ��',
	hideLabel : true
});

var INRQPreFlag= new Ext.form.Checkbox({     
	id: 'INRQPreFlag',
	boxLabel:'�ֿ�ܾ�',
	hideLabel : true
});
var includeDefLoc=new Ext.form.Checkbox({
		id: 'includeDefLoc',
		fieldLabel:'����֧�����',
		checked:true,
		allowBlank:true
});
var fB = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		
		var toLocId = Ext.getCmp('Loc').getValue();
		if((toLocId=="")||(toLocId==null)){
			Msg.info("error","��ѡ��������!");
			return false;
		}
//		var frLocId = Ext.getCmp('SupplyLoc').getValue();
//		var frLocId=toLocId  //ʹ�������������Ӧ���� zhwh 2014-02-20
		var frLocId="";
		var comp=CompletedFlag;
		
		var isRecLocAudited = (Ext.getCmp('RecLocAudited').getValue()==true?'Y':'N');
		var isProvLocAudited = "";
		var isINRQPreFlag = (Ext.getCmp('INRQPreFlag').getValue()==true?'Y':'N');
		var noTrans = 1, partTrans = 1, allTrans = 0;
		var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
		var reqtype=Ext.getCmp('reqType').getValue();
		
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?"Y":"");  //�Ƿ����֧�����
		//alert(reqtype)
		var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
				+"^"+tranStatus+"^"+isRecLocAudited+"^"+isProvLocAudited+"^"+reqtype+"^"+isINRQPreFlag+"^^^^^^"+includeDefLoc;
		OrderDs2.removeAll();
		OrderDs.removeAll();
		OrderDs.setBaseParam('sort','');
		OrderDs.setBaseParam('dir','desc');
		OrderDs.setBaseParam('strPar',strPar);
		OrderDs.load({params:{start:0,limit:pagingToolbar3.pageSize}});
	}
});

// �任����ɫ
function changeBgColor(row, color) {
	Grid.getView().getRow(row).style.backgroundColor = color;
}

var cB = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		clearData();
	}
});

function clearData() {
	Ext.getCmp("reqType").setValue("");
	Ext.getCmp("startDate").setValue(DefaultStDate());
	Ext.getCmp("endDate").setValue(DefaultEdDate());
	Ext.getCmp("RecLocAudited").setValue(false);
	Ext.getCmp("INRQPreFlag").setValue(false);
	OrderDs.removeAll();
	OrderDs2.removeAll();
}

var recLocAuditB = new Ext.Toolbar.Button({
	iconCls:'page_gear',
	height:30,
	width:70,
	text:'���ͨ��',
	tooltip:'�������ͨ��',
	handler:function(){
		var rec=Grid.getSelectionModel().getSelected();
		if (!rec) return;
		var req=rec.get('req');
		reclocAudit(req);
	}
});
var recLocDeniedB = new Ext.Toolbar.Button({
	iconCls:'page_delete',
	height:30,
	width:70,
	text:'��˲�ͨ��',
	tooltip:'������˲�ͨ��',
	handler:function(){
		var rec=Grid.getSelectionModel().getSelected();
		if (!rec) return;
		var req=rec.get('req');
		reclocDeny(req);
	}
});

var OrderProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
var OrderDs = new Ext.data.Store({
	proxy:OrderProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'req'},
		{name:'reqNo'},
		{name:'toLoc'},
		{name:'toLocDesc'},
		{name:'frLoc'},
		{name:'frLocDesc'},
		{name:'reqUser'},
		{name:'userName'},
		{name:'date'},
		{name:'time'},
		{name:'status'},
		{name:'comp'},
		{name:'RecLocAudited'},
		{name:'ProvLocAudited'},
		{name:'remark'},
		{name:'reqType'},
		{name:'scgDesc'},
		{name:'Auditdate'},
		{name:'preFlag'}
	]),
	remoteSort: false,
	listeners : {
		load : function(store,records,options){
			if (records.length > 0){
				Grid.getSelectionModel().selectFirstRow();
				Grid.getView().focusRow(0);
				for (var i = 0, rowCount = records.length; i < rowCount; i++) {
					var rowData = OrderDs.getAt(i);
					var preFlag = rowData.get("preFlag");
					if (preFlag == "Y") {
						changeBgColor(i, "red");
					}
				}
			}
		}
	}
});


var OrderCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'rowid',
		dataIndex: 'req',
		width: 100,
		hidden:true,
		align: 'left'
	},{
		header: '��������',
		dataIndex: 'reqType',
		width: 80,
		sortable:true,
		align: 'left',
		renderer:function(v){
			//alert(v);
			if (v=='O') {return "��ʱ����";}
			if (v=='C') {return '����ƻ�';}
			return '����';
		}
	},{
		header: '���󵥺�',
		dataIndex: 'reqNo',
		width: 140,
		sortable:true,
		align: 'left'
	},{
		header: '������',
		dataIndex: 'toLocDesc',
		width: 120,
		sortable:true,
		align: 'left'
	},{
		header: "��������",
		dataIndex: 'frLocDesc',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "�Ƶ���",
		dataIndex: 'userName',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "����",
		dataIndex: 'date',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "ʱ��",
		dataIndex: 'time',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "ת��״̬",
		dataIndex: 'status',
		width: 80,
		align: 'left',
		renderer:function(value){
			var status="";
			if(value==0){
				status="δת��";
			}else if(value==1){
				status="����ת��";
			}else if(value==2){
				status="ȫ��ת��";
			}
			return status;
		},
		sortable: true
	},{
		header:'�������',
		dataIndex:'RecLocAudited',
		align:'center',
		width:80,
		xtype : 'checkcolumn'
	},{
		header: "�������",
		dataIndex: 'Auditdate',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header:'��Ӧ�����',
		dataIndex:'ProvLocAudited',
		align:'center',
		width:80,
		xtype : 'checkcolumn'
	},{
		header:'��ע',
		dataIndex:'remark',
		width:130,
		align:'left'
	},{
		header:'�ֿ��Ƿ�ܾ�',
		dataIndex:'preFlag',
		width:80,
		align:'center',
		xtype : 'checkcolumn'
	}
]);

var pagingToolbar3 = new Ext.PagingToolbar({
	store:OrderDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��'
});

var Grid = new Ext.grid.GridPanel({
	region:'center',
	store:OrderDs,
	cm:OrderCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	bbar:pagingToolbar3
});

var OrderProxy2= new Ext.data.HttpProxy({url:url+'?actiontype=queryDetail',method:'GET'});
var OrderDs2 = new Ext.data.Store({
	proxy:OrderProxy2,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'rowid'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'spec'},
		{name:'manf'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'rp'},
		{name:'rpAmt'},		
		{name:'generic'},
		{name:'drugForm'},
		{name:'remark'}
	]),
	remoteSort: false
});

var OrderCm2 = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '����',
		dataIndex: 'code',
		width: 72,
		sortable:true,
		align: 'left'
	},{
		header: '����',
		dataIndex: 'desc',
		width: 140,
		sortable:true,
		align: 'left'
	},{
		header:'���',
		dataIndex:'spec',
		align:'left',
		width:80,
		sortable:true
	},{
		header: "����",
		dataIndex: 'manf',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "��������",
		dataIndex: 'qty',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "��λ",
		dataIndex: 'uomDesc',
		width: 72,
		align: 'left',
		sortable: true
	},{
		header:'�ۼ�',
		dataIndex:'sp',
		xtype:'numbercolumn',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "�ۼ۽��",
		dataIndex: 'spAmt',
		xtype:'numbercolumn',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header:'����',
		dataIndex:'rp',
		xtype:'numbercolumn',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "���۽��",
		dataIndex: 'rpAmt',
		xtype:'numbercolumn',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header:'��ע',
		dataIndex:'remark',
		align:'left',
		width:80,
		sortable:true
	}
]);
var pagingToolbar4=new Ext.PagingToolbar({
				store:OrderDs2,
				pageSize:20,
				displayInfo:true,
				displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��'
		});

var Grid2 = new Ext.grid.GridPanel({
	region:'south',
	height:240,
	store:OrderDs2,
	cm:OrderCm2,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask: true,
	bbar:pagingToolbar4
});

Grid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
	OrderDs2.removeAll();
	var jReq =  OrderDs.data.items[rowIndex].data["req"];
	OrderDs2.setBaseParam('req',jReq);
	OrderDs2.setBaseParam('sort','rowid');
	OrderDs2.setBaseParam('dir','desc');
	OrderDs2.setBaseParam('canceled','N');
	OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
});

var conPanel = new Ext.ux.FormPanel({
	tbar:[fB,'-',cB,'-',recLocAuditB,'-',recLocDeniedB],
	title:'�������(������)',
	bodyStyle:'padding:5px 0 0 0',
	labelWidth: 100,
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		bodyStyle:'padding:5px 0 0 5px;',
		layout:'column',
		items:[
			{columnWidth:.2,layout:'form',items:[startDate,endDate]},
			{columnWidth:.3,layout:'form',items:[Loc,reqType]},
			{columnWidth:.1,layout:'form',items:[RecLocAudited,INRQPreFlag]},
			{columnWidth:.3,layout:'form',items:[includeDefLoc]}
		]
	}]
});

function reclocAudit(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ReqSideAudit&req="+req,
		success:function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true'){
				Msg.info('success','���ͨ���ɹ�!');
				OrderDs2.removeAll();
				Grid.getStore().reload();
			}else{
				var info=jsonData.info;
				switch (info)
				{
					case '-1':{
						Msg.info('error','�õ��Ѿ���ˣ�');break;
					}
					case '-2':{
						Msg.info('error','���ʧ��!');break;
					}
					case '-9':{
						Msg.info('error','�����ӱ�ʧ��!');break;
					}
					default:{
						Msg.info('error','���ʧ��!');break;
					}
				}
			 }
		},
		failure:function(){Msg.info('failure','���ʧ��!');}
	})
}
/*�ܾ�*/
function reclocDeny(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ReqSideDeny&req="+req,
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','��˲�ͨ���ɹ�!');
			 	OrderDs2.removeAll();
			 	Grid.getStore().reload();
			}else{
				var info=jsonData.info;
				switch (info){
					case '-1':
						Msg.info('error','�õ��Ѿ���ˣ�');
						break;
					case '-99':
						Msg.info('error','���ʧ��!');
						break;
			 		default:
			 			Msg.info('error','���ʧ��!');
			 			break;
				}
			}
		},
		failure:function(){Msg.info('failure','���ʧ��!');}
	})
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[conPanel, Grid, Grid2],
		renderTo:'mainPanel'
	});
});	
	
