// ����:�����˻ص����
// ��д����:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var mainRowId = "";

//�������ֵ��object
var InDispReqRetParamObj = GetAppPropValue('DHCSTINDISPRETM');

//����
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'����',
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
	boxLabel : '�����'
});

//��������Դ
var DsrAuditGridUrl = 'dhcstm.indispretaction.csp';
var DsrAuditGridProxy= new Ext.data.HttpProxy({url:DsrAuditGridUrl+'?actiontype=query',method:'GET'});
var DsrAuditGridDs = new Ext.data.Store({
	proxy:DsrAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'dsr'},
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
		{name:'grpDesc'}
	]),
	remoteSort:false,
	listeners:{
		'beforeload':function(ds){
			var startDate = Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT);
			//var locId = Ext.getCmp('locField').getValue();
			var locId = '';
			var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y";	//Ҫ�����Ѿ���ɵ�
			var RetToLoc = Ext.getCmp('locField').getValue();
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag+"^"+RetToLoc;
			
			ds.baseParams={start:0,limit:DsrAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar};
		},
		'load':function(ds){
			if (ds.getCount()>0){
				DsrAuditGrid.getSelectionModel().selectFirstRow();
				DsrAuditGrid.getView().focusRow(0);
			}
		}
	}
});

//ģ��
var DsrAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
        header:"dsr",
        dataIndex:'dsr',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"�˻ص���",
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
        width:80,
        align:'left',
       // sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"��˱�־",
        dataIndex:'chkFlag',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
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
DsrAuditGridCm.defaultSortable = true;

var findDsrAudit = new Ext.Toolbar.Button({
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

		DsrAuditDetailGrid.store.removeAll();
		DsrAuditGridDs.load();
	}
});

var auditDsrAudit = new Ext.Toolbar.Button({
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
			Ext.Ajax.request({
				url: DsrAuditGridUrl+'?actiontype=audit&dsr='+mainRowId+'&userId='+UserId,
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
						
						DsrAuditGridDs.load();
						DsrAuditDetailGridDs.removeAll();
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
							Msg.info("error","���ʧ��!");
						}
					}
				},
				scope: this
			});
		}
    }
});

var printDsrAudit = new Ext.Toolbar.Button({
	id : "printDsrAudit",
	text : '��ӡ',
	tooltip : '��ӡ�˻ص�',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=DsrAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ���˻ص�!");
			return;
		}
		var dsr = rowData.get("dsr");
		PrintDsr(dsr);
	}
});

var DsrAuditPagingToolbar = new Ext.PagingToolbar({
	store:DsrAuditGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='NO';
		B['dir']='desc';
		B['strParam']=Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('locField').getValue()+"^"+(Ext.getCmp('AuditedCK').getValue()==true?'Y':'N')+"^N";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
var DsrAuditGrid = new Ext.ux.EditorGridPanel({
	title: '�˻ص�',
	region:'center',
	id : 'DsrAuditGrid',
	store:DsrAuditGridDs,
	cm:DsrAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true,
		listeners:{'rowselect':function(sm,rowIndex,rec){
			var dsr = DsrAuditGridDs.data.items[rowIndex].data["dsr"];
			if (dsr!=''){
				mainRowId = dsr;
				DsrAuditDetailGridDs.setBaseParam('dsr',dsr)
				DsrAuditDetailGridDs.load({params:{start:0,limit:DsrAuditItmPagingToolbar.pageSize}});
			}
		}}
	}),
	loadMask:true,
	clicksToEdit:1,
	bbar:DsrAuditPagingToolbar
});

//��������Դ
var DsrAuditDetailGridUrl = 'dhcstm.indispretaction.csp';
var DsrAuditDetailGridProxy= new Ext.data.HttpProxy({url:DsrAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var DsrAuditDetailGridDs = new Ext.data.Store({
	proxy:DsrAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
	}, [
		{name:'dsritm'},
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
		"Brand","Model","Abbrev","indsNo","dsrqNo"
	]),
	remoteSort:false
});

//ģ��
var DsrAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
			header: '��ϸrowid',
			dataIndex: 'dsritm',
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
			dataIndex:'Abbrev',
			align:'left',
			width:100,
			sortable:true
		},{
			header:'Ʒ��',
			dataIndex:'Brand',
			align:'left',
			width:100,
			sortable:true
		},{
			header:'�ͺ�',
			dataIndex:'Model',
			align:'left',
			width:100,
			sortable:true
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
			header: "�˻�����",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
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
			hidden:true,
			sortable:true
		},{
			header:'�ۼ۽��',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			hidden:true,
			sortable:true
		},{
			header : '���ŵ���',
			dataIndex : 'indsNo',
			width : 150
		},{
			header : '���쵥��',
			dataIndex : 'dsrqNo',
			width : 150
		}
]);
//��ʼ��Ĭ��������
DsrAuditDetailGridCm.defaultSortable = true;

var DsrAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:DsrAuditDetailGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
});

//���
var DsrAuditDetailGrid = new Ext.ux.EditorGridPanel({
	title : '�˻ص���ϸ',
	region : 'south',
	height : 240,
	id : 'DsrAuditDetailGrid',
	collapsible : true,
	store:DsrAuditDetailGridDs,
	cm:DsrAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:DsrAuditItmPagingToolbar
});

var formPanel = new Ext.ux.FormPanel({
	title:'�˻ص����',
    tbar:[findDsrAudit,'-',auditDsrAudit,'-',printDsrAudit],
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

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,DsrAuditGrid,DsrAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findDsrAudit.handler();
});
//===========ģ����ҳ��=============================================