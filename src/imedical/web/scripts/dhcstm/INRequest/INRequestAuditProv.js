// ����:���ܲ������

var ctLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var url = 'dhcstm.inrequestaction.csp';
var jReq = "";
var CompletedFlag='Y';
var gGroupId=session['LOGON.GROUPID'];

//ȡ��������
if(gParam==null ||gParam.length<1){
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
	value:new Date().add(Date.DAY, -7)
});

//��ֹ����
var endDate = new Ext.ux.DateField({
	id:'endDate',
	//width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'��ֹ����',
	anchor:'95%',
	value:new Date()
});

//����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:ctLocId,
	anchor:'90%',
	UserId:session['LOGON.USERID']
});

var linkLocStore=new Ext.data.Store({
	url:'dhcstm.orgutil.csp?actiontype=GetLinkLocations&start=0&limit=999&LocId='+ctLocId,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	},['RowId','Description']),
	autoLoad:true
});
/*
linkLocStore.load({
			callback:function(r,options,success){
				if(success && r.length>0){
					var rec=linkLocStore.getAt(0);
					if(rec){
						var rowid=rec.get("RowId");		
						SupplyLoc.setValue(rowid);
					}
				}
			}
		});

var SupplyLoc = new Ext.ux.ComboBox({
	id:'SupplyLoc',
	anchor:'95%',
	fieldLabel:'��Ӧ����',
	emptyText:'��Ӧ����...',
	store:linkLocStore,
	displayField:'Description',
	filterName:'Desc',
	valueField:'RowId',
	triggerAction:'all'
});
*/
var SupplyLoc = new Ext.ux.LocComboBox({
	id:'SupplyLoc',
	anchor:'95%',
	fieldLabel:'��Ӧ����',
	emptyText:'��Ӧ����...',
	groupId:gGroupId,
	triggerAction:'all'
});
var Loc = new Ext.ux.LocComboBox({
	id:'Loc',
	fieldLabel:'������',
	anchor:'95%',
	emptyText:'������...',
	defaultLoc:{}
});

var Over = new Ext.form.Checkbox({
	id: 'Over',
	fieldLabel:'���',
	checked:true,
	allowBlank:true
});

var ProvLocAudited= new Ext.form.Checkbox({
	id: 'ProvLocAudited',
	boxLabel:'�����ͨ��',
	hideLabel : true
});

var INRQPreFlag= new Ext.form.Checkbox({
	id: 'INRQPreFlag',
	boxLabel:'�ֿ�ܾ�',
	hideLabel : true
});

var fB = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var scgStr=""   ///getScgStr();  ///���鴮
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
		var frLocId = Ext.getCmp('SupplyLoc').getValue();
		if((frLocId=="")||(frLocId==null)){
			Msg.info("error","��ѡ��Ӧ����!");
			return false;
		}
		var comp=CompletedFlag;
		
		var noTrans = 1, partTrans = 1, allTrans = 0;
		var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
		var isRecLocAudited='Y';	//�̶�ΪY, δ����������˵��Ѿ��Զ����(����auditDate�ж�)
		var isProvLocAudited= (Ext.getCmp('ProvLocAudited').getValue()==true?'Y':'N');
		var isINRQPreFlag= (Ext.getCmp('INRQPreFlag').getValue()==true?'Y':'N');
		var reqType='';				//����ƻ���־

		var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
				+"^"+tranStatus+"^"+isRecLocAudited+"^"+isProvLocAudited+"^"+reqType+"^"+isINRQPreFlag
				+"^"+scgStr+"^"+UserId+"^"+ctLocId;
		OrderDs.setBaseParam('sort','');
		OrderDs.setBaseParam('dir','');
		OrderDs.setBaseParam('strPar',strPar);
		
		OrderDs2.removeAll();
		OrderDs.removeAll();
		OrderDs.load({
			params:{start:0,limit:pagingToolbar3.pageSize},
			callback:function(r,options,success){
				if(!success){
					Msg.info("warning","��ѯ����,��鿴��־!");
					return;
				}else if(r.length>0){
					Grid.getSelectionModel().selectFirstRow();
					Grid.getView().focusRow(0);
				}
				var rowCount = Grid.getStore().getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = OrderDs.getAt(i);
					var preFlag = rowData.get("preFlag");
					if (preFlag == "Y") {
						changeBgColor(i, "red");
					}
				}
			}
		});
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
	Ext.getCmp("Loc").setValue("");
	Ext.getCmp("startDate").setValue(new Date());
	Ext.getCmp("endDate").setValue(new Date());
	Ext.getCmp("ProvLocAudited").setValue(false);
	Ext.getCmp("INRQPreFlag").setValue(false);
	OrderDs.removeAll();
	OrderDs2.removeAll();
}

var provlocAuditB = new Ext.Toolbar.Button({
	iconCls:'page_gear',
	height:30,
	width:70,
	text:'���ͨ��',
	tooltip:'���ܲ������ͨ��',
	handler:function(){
		var sm=Grid.getSelectionModel();
		var records=sm.getSelections();		
		if (records.length==0)
		{
			Msg.info('erro','��ѡ������!');
			return;
		}
		for (var i=0;i<records.length;i++)
		{
//			var rec=Grid.getSelectionModel().getSelected();
			var rec=records[i];
			if (!rec) return;
			var req=rec.get('req');
			var provLocAudited=rec.get('ProvLocAudited');
			
			if ((provLocAudited==false)||(provLocAudited=="N"))
			{provlocAudit(req);	}
			/*������׼�����޸�*/
		}

	}
});

var provLocDeniedB = new Ext.Toolbar.Button({
	iconCls:'page_delete',
	height:30,
	width:70,
	text:'��˲�ͨ��',
	tooltip:'���ܲ�����˲�ͨ��',
	handler:function(){
		var rec=Grid.getSelectionModel().getSelected();
		if (!rec) return;
		var req=rec.get('req');
		provlocDeny(req);
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
		{name:'preFlag'}
	]),
	remoteSort: false
});


var sm=new Ext.grid.CheckboxSelectionModel({
//	checkOnly:true
});

var OrderCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),sm,
	{
		header: 'rowid',
		dataIndex: 'req',
		width: 100,
		hidden:true,
		align: 'left'
	},{
		header: '���󵥺�',
		dataIndex: 'reqNo',
		width: 100,
		sortable:true,
		align: 'left'
	},{
		header: '������',
		dataIndex: 'toLocDesc',
		width: 100,
		sortable:true,
		align: 'left'
	},{
		header: "��Ӧ����",
		dataIndex: 'frLocDesc',
		width: 100,
		align: 'left',
		sortable: true
		//hidden:true
	},{
		header:'�Ƶ���',
		dataIndex: 'userName',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "����",
		dataIndex: 'date',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "ʱ��",
		dataIndex: 'time',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header:'����',
		dataIndex:'scgDesc',
		width:100,
		aligh:'left'	
	},{
		header: "����״̬",
		dataIndex: 'status',
		width: 100,
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
		header:'��������',
		dataIndex:'reqType',		
		renderer:function(v){
			//alert(v);
			if (v=='O') {return "��ʱ����";}
			if (v=='C') {return '����ƻ�';}
			return '����';
		}
		
	},{
		header:'���ܲ������',
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
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
});

var Grid = new Ext.grid.GridPanel({
	region:'center',
	store:OrderDs,
	cm:OrderCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:sm,
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
		{name:'remark'},
		{name:"qtyApproved"}
	]),
	remoteSort: false,
	listeners:{
		'update':function(ds,rec,updresult){
			var record=Grid.getSelectionModel().getSelected();
			var provLocAudited=record.get('ProvLocAudited');
			if ((provLocAudited==true)||(provLocAudited=="Y")){
				Msg.info('error','�����,�����޸�');
				ds.reload();
				return;
			}
			//ִ�и���
			var inrqi=rec.get("rowid");
			var qtyApproved=rec.get("qtyApproved");
			if(qtyApproved<0){Msg.info('error','��������С��0');;return;}
			Ext.Ajax.request({
				url:url+'?actiontype=ModifyQtyApproved&inrqi='+inrqi+'&qtyApproved='+qtyApproved,
				success:function(){
					Msg.info('success','�޸ĳɹ�');
					ds.reload();
				},
				failure:function(){
					Msg.info('error','�޸�ʧ��');
				}
			})
		},
		'load':function(ds){
			var r=Grid.getSelectionModel().getSelected();
			var cnt=ds.getCount();
			for ( var i=0;i<cnt;i++)
			{
				var rec=ds.getAt(i);
				if  (rec.get('qty')!=rec.get('qtyApproved')){
					Grid2.getView().getRow(i).style.backgroundColor = '#FFFF00';
				}
			}
		}
	}
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
		header: "��׼����",
		dataIndex: 'qtyApproved',
		id:'qtyApproved',
		width: 80,
		align: 'right',
		editor:new Ext.form.NumberField({selectOnFocus:true})
	},{
		header: "��λ",
		dataIndex: 'uomDesc',
		width: 72,
		align: 'left',
		sortable: true
	},{
		header:'�ۼ�',
		dataIndex:'sp',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "�ۼ۽��",
		dataIndex: 'spAmt',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header:'����',
		dataIndex:'rp',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "���۽��",
		dataIndex: 'rpAmt',
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
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
});

var Grid2 = new Ext.grid.EditorGridPanel({
	region:'south',
	height:240,
	store:OrderDs2,
	cm:OrderCm2,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask: true,
	bbar:pagingToolbar4,
	clicksToEdit:true,
	listeners : {
		beforeedit : function(e){
			if(e.field=='qtyApproved' && e.record.get('ProvLocAudited')=='Y'){
				e.cancel = true;
			}
		}
	}
});

Grid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
	OrderDs2.removeAll();
	jReq =  OrderDs.data.items[rowIndex].data["req"];
	jReq = jReq;
	OrderDs2.setBaseParam('req',jReq);
	OrderDs2.setBaseParam('sort','');
	OrderDs2.setBaseParam('dir','');
	OrderDs2.setBaseParam('canceled','N');
	if(IsSplit()=="Y"){
		OrderDs2.setBaseParam('handletype','0');
		}
	
	OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
});

var conPanel = new Ext.ux.FormPanel({
	title:'�������(���ܲ���)',
	tbar:[fB,'-',cB,'-',provlocAuditB,'-',provLocDeniedB],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		style : 'padding:5px 0px 0px 5px',
		layout:'column',
		items:[
			{columnWidth:.2,layout:'form',items:[startDate,endDate]},
			{columnWidth:.3,layout:'form',items:[SupplyLoc,Loc]},
			{columnWidth:.4,layout:'form',items:[ProvLocAudited,INRQPreFlag]}			
		]
	}]
});

function provlocAudit(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ProvSideAudit&req="+req,
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','���ͨ���ɹ�!');
			 	OrderDs2.removeAll();
			 	Grid.getStore().reload();
			 }
			 else
			 {
			 	Msg.info('error','���ͨ��ʧ��!');
			 }			 
		},
		failure:function(){Msg.info('error','���ͨ��ʧ��!');}
	})
}
/*��˲�ͨ��*/
function provlocDeny(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ProvSideDeny&req="+req,
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','��˲�ͨ���ɹ�!');
			 	OrderDs2.removeAll();
			 	Grid.getStore().reload();
			 }
			 else
			 {
			 	Msg.info('error','��˲�ͨ��ʧ��!');
			 }
			 
		},
		failure:function(){Msg.info('error','��˲�ͨ��ʧ��!');}
	})
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[conPanel,Grid,Grid2],
		renderTo:'mainPanel'
	});
});
