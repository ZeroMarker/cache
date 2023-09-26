// ����:��淢�ŵ����
// ��д����:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];

//�������ֵ��object
var InDispParamObj = GetAppPropValue('DHCSTINDISPM');

//����
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'����',
	anchor:'90%',
	groupId:gGroupId
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	allowBlank:false,
	fieldLabel:'��ʼ����',
	value:new Date().add(Date.DAY,-30)
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	allowBlank:false,
	fieldLabel:'��������',
	value:new Date()
});

var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	boxLabel : '�����',
	allowBlank:true
});

var findIndsAudit = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
			
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����벿��!");
			return false;
		}
		
		IndsAuditDetailGrid.store.removeAll();
		IndsAuditGridDs.load({
			params : {start:0, limit:IndsAuditPagingToolbar.pageSize}
		});
	}
});

var auditIndsAudit = new Ext.Toolbar.Button({
	text:'���ͨ��',
	tooltip:'������ͨ��',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var SelReocrds = IndsAuditGrid.getSelectionModel().getSelections();
		if(SelReocrds==null || SelReocrds==undefined){
			Msg.info("warning","��ѡ����Ҫ��˵ķ��ŵ�!");
			return;
		}
		Ext.each(SelReocrds,function(selectedRec){
			Audit(selectedRec);
		});
	}
});

function Audit(selectedRec){
	var mainRowId = selectedRec.get("inds");
	var ACKFlag = selectedRec.get("chkFlag");
	if (ACKFlag=="Y"){
		Msg.info('error','�õ����Ѿ���ˣ�');
		return;
	}
	Ext.Ajax.request({
		url: IndsAuditGridUrl+'?actiontype=audit&disp='+mainRowId+'&userId='+UserId,
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","���ͨ���ɹ�!");
						
				//��˳ɹ���ˢ��ҳ��
				var startDate = Ext.getCmp('startDateField').getValue();
				if((startDate!="")&&(startDate!=null)){
					startDate = startDate.format(ARG_DATEFORMAT);
				}else{
					Msg.info("error","��ѡ����ʼ����!");
					return false;
				}
				var endDate = Ext.getCmp('endDateField').getValue();
				if((endDate!="")&&(endDate!=null)){
					endDate = endDate.format(ARG_DATEFORMAT);
				}else{
					Msg.info("error","��ѡ���ֹ����!");
					return false;
				}
				var locId=Ext.getCmp('locField').getValue();
				var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
					
				var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^N";
				
				IndsAuditDetailGridDs.removeAll();
				IndsAuditGridDs.reload();
			}else{
				if(jsonData.info==-1){
					Msg.info("error","�����!");
				}else if(jsonData.info==-2){
					Msg.info("error","��¼�û�rowidΪ��!");
				}else if(jsonData.info==-102){
					Msg.info("error","��洦�����!");
				}else if(jsonData.info==-103){
					Msg.info("error","����̨�����ݳ���!");
				}else{
					Msg.info("error","���ʧ��!"+jsonData.info);
				}
			}
		},
		scope: this
	});
}

var printIndsAudit = new Ext.Toolbar.Button({
	id : "printIndsAudit",
	text : '��ӡ',
	tooltip : '��ӡ���ŵ�',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var SelReocrds = IndsAuditGrid.getSelectionModel().getSelections();
		if(SelReocrds==null || SelReocrds==undefined){
			Msg.info("warning","��ѡ����Ҫ��ӡ�ķ��ŵ�!");
			return;
		}
		Ext.each(SelReocrds,function(selectedRec){
			var Inds = selectedRec.get("inds");
			PrintInDisp(Inds);
		});
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'���ŵ����',
	tbar:[findIndsAudit,'-',auditIndsAudit,'-',printIndsAudit],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .25,
				items : [locField]
			}, {
				columnWidth : .2,
				items : [startDateField]
			}, {
				columnWidth : .2,
				items : [endDateField]
			}, {
				columnWidth : .25,
				items : [AuditedCK]
		}]
	}]
});

//��������Դ
var IndsAuditGridUrl = 'dhcstm.indispaction.csp';
var IndsAuditGridProxy= new Ext.data.HttpProxy({url:IndsAuditGridUrl+'?actiontype=query',method:'GET'});
var IndsAuditGridDs = new Ext.data.Store({
	proxy:IndsAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'inds'},
		{name:'no'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'date'},
		{name:'time'},
		{name:'user'},
		{name:'userName'},
		{name:'chkDate'},
		{name:'chkTime'},
		{name:'chkUser'},
		{name:'chkUserName'},
		{name:'scg'},
		{name:'scgDesc'},
		{name:'comp'},
		{name:'state'},
		{name:'chkFlag'},
		{name:'stkType'},
		{name:'dispmode'},
		{name:'recUser'},
		{name:'recUserName'},
		{name:'grp'},
		{name:'grpDesc'},
		'dsrqNo','indsToLoc'
	]),
	remoteSort:false,
	listeners:{
		'beforeload':function(ds){
			var startDate = Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT);
			var locId = Ext.getCmp('locField').getValue();
			var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y"  //Ҫ�����Ѿ���ɵ�
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag;
			ds.setBaseParam('sort','NO');
			ds.setBaseParam('dir','desc');
			ds.setBaseParam('strParam', strPar);
		},
		'load':function(ds){
			if (ds.getCount()>0){
				//IndsAuditGrid.getSelectionModel().selectFirstRow();
				//IndsAuditGrid.getView().focusRow(0);
			}
		}
	}
});

var sm = new Ext.grid.CheckboxSelectionModel({
	singleSelect:false,
	checkOnly:true,
	listeners:{
		'rowselect':function(sm,rowIndex,rec){
			var inds = IndsAuditGridDs.data.items[rowIndex].data["inds"];
			if (inds!=''){
				mainRowId = inds;
				ACKFlag=IndsAuditGridDs.data.items[rowIndex].data["chkFlag"];
				IndsAuditDetailGridDs.setBaseParam('disp',inds);
				IndsAuditDetailGridDs.load({params:{start:0,limit:IndsAuditItmPagingToolbar.pageSize}});
			}
		}
	}
});

//ģ��
var IndsAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	sm,
	{
		header:"rowid",
		dataIndex:'inds',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"���ŵ���",
		dataIndex:'no',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"���쵥��",
		dataIndex:'dsrqNo',
		width:140,
		align:'left'
	},{
		header:"���տ���",
		dataIndex:'indsToLoc',
		width:140,
		align:'left'
	},{
		header:"�Ƶ���",
		dataIndex:'userName',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"�Ƶ�����",
		dataIndex:'date',
		width:100,
		align:'center',
		sortable:true
	},{
		header:"�Ƶ�ʱ��",
		dataIndex:'time',
		width:100,
		align:'center',
		sortable:true
	},{
		header:"��ɱ�־",
		dataIndex:'comp',
		width:80,
		align:'left',
		xtype : 'checkcolumn'
	},{
		header:'������',
		dataIndex:'recUserName',
		width:60
	},{
		header:'רҵ��',
		dataIndex:'grpDesc',
		width:120
	},{
		header:"��˱�־",
		dataIndex:'chkFlag',
		width:60,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"�����",
		dataIndex:'chkUserName',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"�������",
		dataIndex:'chkDate',
		width:100,
		align:'center',
		sortable:true
	},{
		header:"���ʱ��",
		dataIndex:'chkTime',
		width:100,
		align:'center',
		sortable:true
	}
]);
//��ʼ��Ĭ��������
IndsAuditGridCm.defaultSortable = true;

var IndsAuditPagingToolbar = new Ext.PagingToolbar({
	store:IndsAuditGridDs,
	pageSize:15,
	displayInfo:true
});

//���
IndsAuditGrid = new Ext.ux.GridPanel({
	title : '���ŵ���Ϣ',
	id : 'IndsAuditGrid',
	region : 'center',
	store:IndsAuditGridDs,
	cm:IndsAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : sm,
	loadMask:true,
	clicksToEdit:1,
	bbar:IndsAuditPagingToolbar
});

//��������Դ
var IndsAuditDetailGridUrl = 'dhcstm.indispaction.csp';
var IndsAuditDetailGridProxy= new Ext.data.HttpProxy({url:IndsAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var IndsAuditDetailGridDs = new Ext.data.Store({
	proxy:IndsAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'indsitm'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		'AvaQty'
	]),
	remoteSort:false
});

//ģ��
var IndsAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
			header: '��ϸrowid',
			dataIndex: 'indsitm',
			width: 72,
			sortable:true,
			align: 'left',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'left'
		},{
			header: '����rowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'left'
		},{
			header: '���ʴ���',
			dataIndex: 'code',
			width: 100,
			sortable:true,
			align: 'left'
		},{
			header: '��������',
			dataIndex: 'desc',
			width: 200,
			sortable:true,
			align: 'left'
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:100,
			sortable:true
		},{
			header: "����",
			dataIndex: 'manf',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "����~Ч��",
			dataIndex: 'batNo',
			width: 140,
			align: 'left',
			sortable: true
		},{
			header: "��������",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
			sortable: true
		},{
			header:'��λ',
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:100,
			sortable:true
		},{
			header:'���۽��',
			dataIndex:'rpAmt',
			align:'right',
			width:100,
			sortable:true
		},{
			header:'�ۼ�',
			dataIndex:'sp',
			align:'right',
			width:100,
			sortable:true,
			hidden:true,
			hideable:false
		},{
			header:'�ۼ۽��',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			sortable:true,
			hidden:true,
			hideable:false
		}
]);
//��ʼ��Ĭ��������
IndsAuditDetailGridCm.defaultSortable = true;

var IndsAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:IndsAuditDetailGridDs,
	pageSize:15,
	displayInfo:true
});

//���
IndsAuditDetailGrid = new Ext.ux.GridPanel({
	title : '���ŵ���ϸ',
	id: 'IndsAuditDetailGrid',
	region:'south',
	height:240,
	store:IndsAuditDetailGridDs,
	cm:IndsAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IndsAuditItmPagingToolbar
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IndsAuditGrid,IndsAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findIndsAudit.handler();
});
