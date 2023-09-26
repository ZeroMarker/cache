// ����:�����������
// ��д����:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var mainRowId = "";

//�������ֵ��object
var InAdjParamObj = GetAppPropValue('DHCSTSTOCKADJM');

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
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	allowBlank:false,
	fieldLabel:'��������',
	value:new Date()
});

var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	fieldLabel:'�����',
	anchor:'100%',
	allowBlank:true
});

var findInadjAudit = new Ext.Toolbar.Button({
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

		InadjAuditDetailGrid.store.removeAll();
		InadjAuditGridDs.load();
	}
});

var auditInadjAudit = new Ext.Toolbar.Button({
	text:'���ͨ��',
	tooltip:'������ͨ��',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����벿��!");
			return false;
		}
		//alert(mainRowId);
		if((mainRowId!="")&&(mainRowId!=null)){
			
			///����ֵ���ϱ�ǩ¼�����
			if(CheckHighValueLabels("A",mainRowId)==false){
				return;
			}
			
			Ext.Ajax.request({
				url: InadjAuditGridUrl+'?actiontype=audit&adj='+mainRowId+'&userId='+UserId,
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
						var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^N";
						
						InadjAuditGridDs.reload();
						InadjAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","�����!");
						}else if(jsonData.info==-2){
							Msg.info("error","��¼�û�rowidΪ��!");
						}else if(jsonData.info==-5){
							Msg.info("error","���ο�治�㣬���ܽ������!");
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
    }
});

var printInadjAudit = new Ext.Toolbar.Button({
	id : "printInadjAudit",
	text : '��ӡ',
	tooltip : '��ӡ������',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=InadjAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ�ĵ�����!");
			return;
		}
		var inadj = rowData.get("adj");
		PrintInAdj(inadj);
	}
});

var formPanel = new Ext.ux.FormPanel({
	title : '�����������',
	tbar:[findInadjAudit,'-',auditInadjAudit,'-',printInadjAudit],
	layout:'fit',
	items : [{
		xtype : 'fieldset',
		title : '����ѡ��',
		//width:1330,
		autoHeight : true,
		items : [{
			layout : 'column',
			items : [{
				columnWidth : .25,
				layout : 'form',
				items : [locField]
			}, {
				columnWidth : .2,
				layout : 'form',
				items : [startDateField]
			}, {
				columnWidth : .2,
				layout : 'form',
				items : [endDateField]
			}, {
				columnWidth : .25,
				layout : 'form',
				items : [AuditedCK]
			}]
		}]
	}]
});

//��������Դ
var InadjAuditGridUrl = 'dhcstm.inadjaction.csp';
var InadjAuditGridProxy= new Ext.data.HttpProxy({url:InadjAuditGridUrl+'?actiontype=query',method:'GET'});
var InadjAuditGridDs = new Ext.data.Store({
	proxy:InadjAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'adj'},
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
		{name:'remarks'},
		{name:'RpAmt'},
		{name:'SpAmt'}
	]),
	remoteSort:false,
	listeners:{
		'beforeload':function(ds)
		{
			var startDate = Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT);
			var locId = Ext.getCmp('locField').getValue();
		
			var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y"  //Ҫ�����Ѿ���ɵ�
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag;

			ds.baseParams={start:0,limit:InadjAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar};
		},
		'load':function(ds)
		{
			if (ds.getCount()>0){
				InadjAuditGrid.getSelectionModel().selectFirstRow();
				InadjAuditGrid.getView().focusRow(0);
			}
		}
	}
});

//ģ��
var InadjAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"rowid",
		dataIndex:'adj',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"��������",
		dataIndex:'no',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
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
		width:60,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
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
	},{
		header:"��ע",
		dataIndex:'remarks',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"���ۺϼ�",
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�ۼۺϼ�",
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:true
	}
]);
//��ʼ��Ĭ��������
InadjAuditGridCm.defaultSortable = true;

var InadjAuditPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditGridDs,
	pageSize:15,
	displayInfo:true
});

//���
InadjAuditGrid = new Ext.grid.GridPanel({
	region : 'center',
	store:InadjAuditGridDs,
	cm:InadjAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true,
		listeners:{
			'rowselect':function(sm,rowIndex,rec){
				var adj = InadjAuditGridDs.data.items[rowIndex].data["adj"];
				if (adj!=''){
					mainRowId = adj;
					InadjAuditDetailGridDs.setBaseParam('adj',adj);
					InadjAuditDetailGridDs.load({params:{start:0,limit:InadjAuditItmPagingToolbar.pageSize}});
				}
			}
		}
	}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditPagingToolbar
});

//��������Դ
var InadjAuditDetailGridUrl = 'dhcstm.inadjaction.csp';
var InadjAuditDetailGridProxy= new Ext.data.HttpProxy({url:InadjAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var InadjAuditDetailGridDs = new Ext.data.Store({
	proxy:InadjAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'adjitm'},
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
		{name:'qtyBUOM'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'insti'},'HVBarCode'
	]),
	remoteSort:false
});

//ģ��
var InadjAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
			header: '��ϸrowid',
			dataIndex: 'adjitm',
			width: 72,
			sortable:true,
			align: 'center',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'center'
		},{
			header: '����rowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'center'
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
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "��������",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
			sortable: true
		},{
			header: "��ֵ����",
			dataIndex: 'HVBarCode',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header:'��λ',
			dataIndex:'uomDesc',
			align:'right',
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
			sortable:true
		},{
			header:'�ۼ۽��',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			sortable:true
		}
]);
//��ʼ��Ĭ��������
InadjAuditDetailGridCm.defaultSortable = true;

var InadjAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditDetailGridDs,
	pageSize:15,
	displayInfo:true
});

//���
InadjAuditDetailGrid = new Ext.grid.GridPanel({
	region:'south',
	height:240,
	store:InadjAuditDetailGridDs,
	cm:InadjAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditItmPagingToolbar
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,InadjAuditGrid,InadjAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findInadjAudit.handler();
});
