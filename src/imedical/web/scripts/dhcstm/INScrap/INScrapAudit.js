// ����:��汨�����
// ��д����:2012-08-22
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var mainRowId = "";
var needCompleted="Y";

//�������ֵ��object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'��Ӧ����',
	name:'locField',
	anchor:'90%',
	groupId:gGroupId
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	allowBlank:false,
	fieldLabel:'��ʼ����',
	value:new Date(),
	anchor:'90%'
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	allowBlank:false,
	fieldLabel:'��������',
	value:new Date(),
	anchor:'90%'
});
var includeAuditedCK = new Ext.form.Checkbox({
	id: 'includeAuditedCK',
	fieldLabel:'�����',
	anchor:'90%',
	allowBlank:true
});

var findINScrapAudit = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		mainRowId=""
		INScrapAuditDetailGridDs.removeAll();
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
		var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
		INScrapAuditGridDs.setBaseParam('strParam',strPar);
		INScrapAuditGridDs.load({params:{start:0,limit:InscrapAuditPagingToolbar.pageSize}});
	}
});

var auditINScrapAudit = new Ext.Toolbar.Button({
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
		if((mainRowId!="")&&(mainRowId!=null)){
			
			///����ֵ���ϱ�ǩ¼�����
			if(CheckHighValueLabels("D",mainRowId)==false){
				return;
			}
			
			Ext.Ajax.request({
				url: INScrapAuditGridUrl+'?actiontype=audit&inscrap='+mainRowId+'&userId='+UserId+'&locId='+locId,
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
						var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
						
						INScrapAuditGridDs.reload();
						INScrapAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","����rowidΪ��!");
						}else if(jsonData.info==-2){
							Msg.info("error","��¼�û�rowidΪ��!");
						}else if(jsonData.info==-3){
							Msg.info("error","�Ѿ����!");
						}else if(jsonData.info==-102){
							Msg.info("error","��洦�����!");
						}else if(jsonData.info==-103){
							Msg.info("error","����̨�����ݳ���!");
						}else if(jsonData.info==-104){
							Msg.info("error","���ο�治��,���ܽ��б������!");
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
var canauditINScrapAudit = new Ext.Toolbar.Button({
	text:'�������',
	tooltip:'�������',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����벿��!");
			return false;
		}
		if((mainRowId!="")&&(mainRowId!=null)){
						
			Ext.Ajax.request({
				url: INScrapAuditGridUrl+'?actiontype=canaudit&inscrap='+mainRowId+'&userId='+UserId,
				failure: function(result, request) {
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","��˳ɹ�!");
						
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
						var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
						
						INScrapAuditGridDs.reload();
						INScrapAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","����rowidΪ��!");
						}else if(jsonData.info==-2){
							Msg.info("error","��¼�û�rowidΪ��!");
						}else if(jsonData.info==-3){
							Msg.info("error","�Ѿ���˹�!");
						}else if(jsonData.info==-4){
							Msg.info("error","�ѽ�����!");
						}else if(jsonData.info==-5){
							Msg.info("error","�������±�!");							
						}else{
							Msg.info("error","����ʧ��!"+jsonData.info);
						}
					}
				},
				scope: this
			});
		}
	}
});
var clearINScrapAudit = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		//Ext.getCmp('startDateField').setValue("");
		//Ext.getCmp('endDateField').setValue("");
		//Ext.getCmp('locField').setValue("");
		//Ext.getCmp('locField').setRawValue("");
		Ext.getCmp('includeAuditedCK').setValue(false);
		
		INScrapAuditGridDs.removeAll();
		INScrapAuditDetailGridDs.removeAll();
	}
});

var printINScrapAudit = new Ext.Toolbar.Button({
	text : '��ӡ',
	tooltip : '��ӡ����',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=INScrapAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ�ı���!");
			return;
		}
		var inscrap = rowData.get("inscp");
		PrintINScrap(inscrap);
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'��汨�����',
	tbar:[findINScrapAudit,'-',auditINScrapAudit,'-',clearINScrapAudit,'-',printINScrapAudit,'-',canauditINScrapAudit],
	items : [{
		xtype : 'fieldset',
		title : '����ѡ��',
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
				items : [includeAuditedCK]
			}]
		}]

	}]
});

var INScrapAuditGrid="";
//��������Դ
var INScrapAuditGridUrl = 'dhcstm.inscrapaction.csp';
var INScrapAuditGridProxy= new Ext.data.HttpProxy({url:INScrapAuditGridUrl+'?actiontype=query',method:'GET'});
var INScrapAuditGridDs = new Ext.data.Store({
	proxy:INScrapAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'inscp'},
		{name:'no'},
		{name:'date'},
		{name:'time'},
		{name:'user'},
		{name:'userName'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'chkDate'},
		{name:'chkTime'},
		{name:'chkUser'},
		{name:'chkUserName'},
		{name:'completed'},
		{name:'chkFlag'},
		{name:'stkType'},
		{name:'scg'},
		{name:'scgDesc'},
		{name:'reason'},
		{name:'reasonDesc'},
		{name:'RpAmt'},
		{name:'SpAmt'},
		{name:'canchkFlag'}
	]),
	remoteSort:false,
	listeners : {
		load : function(store,records,options){
			if(records.length>0){
				INScrapAuditGrid.getSelectionModel().selectFirstRow();
				INScrapAuditGrid.getView().focusRow(0);
			}
		}
	}
});

//ģ��
var INScrapAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����RowId",
		dataIndex:'inscp',
		hidden:true
	},{
		header:"��������",
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		 header:"���𵥺�",
		dataIndex:'no',
		width:100,
		align:'center',
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
		align:'left',
		sortable:true
	},{
		header:"�Ƶ�ʱ��",
		dataIndex:'time',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��ɱ�־",
		dataIndex:'completed',
		width:100,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"��˱�־",
		dataIndex:'chkFlag',
		width:100,
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
		align:'left',
		sortable:true,
		hidden:false
	},{
		header:"���ʱ��",
		dataIndex:'chkTime',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"���ۺϼ�",
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		xtype:'numbercolumn'
	},{
		header:"�ۼۺϼ�",
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		xtype:'numbercolumn'
	},{
		header:"������˱�־",
		dataIndex:'canchkFlag',
		width:100,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	}
]);
//��ʼ��Ĭ��������
INScrapAuditGridCm.defaultSortable = true;

var InscrapAuditPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditGridDs,
	pageSize:15,
	displayInfo:true
});

//���
INScrapAuditGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	store:INScrapAuditGridDs,
	cm:INScrapAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InscrapAuditPagingToolbar
});

var INScrapAuditDetailGrid="";
//��������Դ
var INScrapAuditDetailGridUrl = 'dhcstm.inscrapaction.csp';
var INScrapAuditDetailGridProxy= new Ext.data.HttpProxy({url:INScrapAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var INScrapAuditDetailGridDs = new Ext.data.Store({
	proxy:INScrapAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'inspi'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'pp'},
		{name:'ppAmt'},
		{name:'batNo'},
		{name:'expDate'}
	]),
	remoteSort:false
});

//ģ��
var INScrapAuditDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"��ϸRowId",
		dataIndex:'inspi',
		width:100,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"����RowId",
		dataIndex:'inclb',
		width:100,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"����RowId",
		dataIndex:'inci',
		width:120,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"���ʴ���",
		dataIndex:'code',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'desc',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"���",
		dataIndex:'spec',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'manf',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"����~Ч��",
		dataIndex:'batNo',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'qty',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"��λ",
		dataIndex:'uomDesc',
		width:100,
		align:'left'
	},{
		header:"����",
		dataIndex:'rp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�ۼ�",
		dataIndex:'sp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"���۽��",
		dataIndex:'rpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�ۼ۽��",
		dataIndex:'spAmt',
		width:100,
		align:'right',
		sortable:true
	}
]);
//��ʼ��Ĭ��������
INScrapAuditDetailGridCm.defaultSortable = true;

var InscrapAuditDetailPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditDetailGridDs,
	pageSize:15,
	displayInfo:true
});
//���
INScrapAuditDetailGrid = new Ext.grid.GridPanel({
	region:'south',
	height:240,
	store:INScrapAuditDetailGridDs,
	cm:INScrapAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:InscrapAuditDetailPagingToolbar,
	clicksToEdit:1
});

INScrapAuditGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,r){
	var inscrap = INScrapAuditGridDs.data.items[rowIndex].data["inscp"];
	mainRowId = inscrap;
	INScrapAuditDetailGridDs.setBaseParam('inscrap',inscrap);
	INScrapAuditDetailGridDs.load({params:{start:0,limit:InscrapAuditDetailPagingToolbar.pageSize}});
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INScrapAuditGrid,INScrapAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findINScrapAudit.handler();
});
