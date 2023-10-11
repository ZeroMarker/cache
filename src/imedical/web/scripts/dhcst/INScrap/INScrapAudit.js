// ����:��汨�����
// ��д����:2012-08-22
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var mainRowId = "";
var needCompleted="Y";
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('����'),
	name:'locField',
	anchor:'90%',
	groupId:gGroupId
});

//=========================��汨�����=============================
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
//	width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:$g('��ʼ����'),
	value:new Date(),
	anchor:'90%'
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	//width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:$g('��������'),
	value:new Date(),
	anchor:'90%'
});
var includeAuditedCK = new Ext.form.Checkbox({
	id: 'includeAuditedCK',
	boxLabel:$g('�����'),
	anchor:'90%',
	allowBlank:true
});
//====================================================
var INScrapAuditGrid="";
//��������Դ
var INScrapAuditGridUrl = 'dhcst.inscrapaction.csp';
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
		{name:'spAmt'},
		{name:'rpAmt'}
	]),
    remoteSort:false
});

//ģ��
var INScrapAuditGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("����RowId"),
        dataIndex:'inscp',
        hidden:true
    },/*{
        header:"����RowId",
        dataIndex:'loc',
        width:100,
        align:'left',
        sortable:true
    },*/{
        header:$g("��������"),
        dataIndex:'locDesc',
        width:120,
        align:'left',
        sortable:true
    },{
    	 header:$g("���𵥺�"),
        dataIndex:'no',
        width:150,
        align:'center',
        sortable:true   
    }
    /*,{
        header:"�Ƶ���rowid",
        dataIndex:'user',
        width:100,
        align:'left',
        sortable:true
    }*/,{
        header:$g("�Ƶ���"),
        dataIndex:'userName',
        width:100,
        align:'left',
        sortable:true
    },	{
        header:$g("�Ƶ�����"),
        dataIndex:'date',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("�Ƶ�ʱ��"),
        dataIndex:'time',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("��ɱ�־"),
        dataIndex:'completed',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:$g("��˱�־"),
        dataIndex:'chkFlag',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }/*,{
        header:"�����rowid",
        dataIndex:'chkUser',
        width:100,
        align:'left',
        sortable:true
    }*/,{
        header:$g("�����"),
        dataIndex:'chkUserName',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("�������"),
        dataIndex:'chkDate',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("���ʱ��"),
        dataIndex:'chkTime',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("���۽��"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("�ۼ۽��"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    }
]);
//��ʼ��Ĭ��������
INScrapAuditGridCm.defaultSortable = true;

var findINScrapAudit = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
	query()
		
	}
});

function query(){
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("��ѡ����ʼ����!"));
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("��ѡ���ֹ����!"));
			return false;
		}
			
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("��ѡ�����벿��!"));
			return false;
		}
			
		var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
		
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited
		INScrapAuditGridDs.setBaseParam('strParam',strPar);
		INScrapAuditDetailGridDs.removeAll();
		INScrapAuditGridDs.load({params:{start:0,limit:InscrapAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar},
		callback : function(r,options, success){
			if(success==false){
				Msg.info("error",$g("��ѯ����!"));}
				else{
					if(r.length>=1){
						INScrapAuditGrid.getSelectionModel().selectFirstRow();
						INScrapAuditGrid.fireEvent('rowclick',this,0);}
						//=========
						INScrapAuditGrid.getView().focusRow(0);
						//=========
					}
			}
			});
	
	
	}
var auditINScrapAudit = new Ext.Toolbar.Button({
	text:$g('���'),
    tooltip:$g('���'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("��ѡ�����벿��!"));
			return false;
		}
		if((mainRowId!="")&&(mainRowId!=null)){
			Ext.Ajax.request({
				url: INScrapAuditGridUrl+'?actiontype=audit&inscrap='+mainRowId+'&userId='+UserId+'&locId='+locId,
				failure: function(result, request) {
					Msg.info("error",$g("������������!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success",$g("��˳ɹ�!"));
						
						//��˳ɹ���ˢ��ҳ��
						var startDate = Ext.getCmp('startDateField').getValue();
						if((startDate!="")&&(startDate!=null)){
							startDate = startDate.format(App_StkDateFormat);
						}else{
							Msg.info("error",$g("��ѡ����ʼ����!"));
							return false;
						}
						var endDate = Ext.getCmp('endDateField').getValue();
						if((endDate!="")&&(endDate!=null)){
							endDate = endDate.format(App_StkDateFormat);
						}else{
							Msg.info("error",$g("��ѡ���ֹ����!"));
							return false;
						}
						var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
						
						INScrapAuditGridDs.load({params:{start:0,limit:InscrapAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar}});
						INScrapAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("����rowidΪ��!"));
						}else if(jsonData.info==-2){
							Msg.info("error",$g("��¼�û�rowidΪ��!"));
						}else if(jsonData.info==-3){
							Msg.info("error",$g("�Ѿ���˹�!"));
						}else if(jsonData.info==-102){
							Msg.info("error",$g("��洦�����!"));
						}else if(jsonData.info==-103){
							Msg.info("error",$g("����̨�����ݳ���!"));
						}else{
							Msg.info("error",$g("���ʧ��!"));
						}
					}
				},
				scope: this
			});
		}
		else {Msg.info("warning",$g("û�е�����Ҫ���!"));return false;}
    }
});

var clearINScrapAudit = new Ext.Toolbar.Button({
	text:$g('���'),
    tooltip:$g('���'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('includeAuditedCK').setValue(false);
		INScrapAuditGridDs.load({params:{start:0,limit:0}})
		INScrapAuditDetailGridDs.load({params:{start:0,limit:0}})
		INScrapAuditGridDs.removeAll();
		INScrapAuditDetailGridDs.removeAll();
		mainRowId=""
		SetLogInDept(locField.getStore(),'locField');
		Ext.getCmp("startDateField").setValue(new Date());
		Ext.getCmp("endDateField").setValue(new Date());
	}
});

var printINScrapAudit = new Ext.Toolbar.Button({
	text : $g('��ӡ'),
	tooltip : $g('��ӡ����'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=INScrapAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", $g("��ѡ����Ҫ��ӡ�ı���!"));
			return;
		}
		var inscrap = rowData.get("inscp");
		PrintINScrap(inscrap);
	}
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	autoScroll:true,
	labelAlign : 'right',
	autoHeight:true,
	region:'north',
	frame : true,
    tbar:[findINScrapAudit,'-',clearINScrapAudit,'-',auditINScrapAudit,'-',printINScrapAudit],
	items : [{
		xtype : 'fieldset',
		title : $g('����ѡ��'),
		layout : 'column',
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{
			xtype : 'fieldset',
			columnWidth : .25,
        	border: false,
			items : [locField]
		}, {
			xtype : 'fieldset',
			columnWidth : .25,
        	border: false,
			items : [startDateField]
		}, {
			xtype : 'fieldset',
			columnWidth : .25,
        	border: false,
			items : [endDateField]
		}, {
			xtype : 'fieldset',
			columnWidth : .2,
        	border: false,
        	labelWidth:10,
			items : [includeAuditedCK]
		}]

	}]
});

var InscrapAuditPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
	emptyMsg:$g("û�м�¼")
});

//���
INScrapAuditGrid = new Ext.grid.EditorGridPanel({
	store:INScrapAuditGridDs,
	cm:INScrapAuditGridCm,
	trackMouseOver:true,
	region:'north',
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InscrapAuditPagingToolbar
});
//=========================��汨�����=============================

var INScrapAuditDetailGrid="";
//��������Դ
var INScrapAuditDetailGridUrl = 'dhcst.inscrapaction.csp';
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
	 /*{
        header:"��ϸRowId",
        dataIndex:'inspi',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����RowId",
        dataIndex:'inclb',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"ҩƷRowId",
        dataIndex:'inci',
        width:120,
        align:'left',
        sortable:true
    },*/{
        header:$g("ҩƷ����"),
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("���"),
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("������ҵ"),
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("����~Ч��"),
        dataIndex:'batNo',
        width:180,
        align:'left',
        sortable:true
    },{
        header:$g("��������"),
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("��λ"),
        dataIndex:'uomDesc',
        width:75,
        align:'left'
    },{
        header:$g("����"),
        dataIndex:'rp',
        width:75,
        align:'right',
        sortable:true
    },{
        header:$g("�ۼ�"),
        dataIndex:'sp',
        width:75,
        align:'right',
        sortable:true
    },{
        header:$g("���۽��"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("�ۼ۽��"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    }
]);
//��ʼ��Ĭ��������
INScrapAuditDetailGridCm.defaultSortable = true;

var InscrapAuditDetailPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditDetailGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
	emptyMsg:$g("û�м�¼")
});
//���
INScrapAuditDetailGrid = new Ext.grid.EditorGridPanel({
	store:INScrapAuditDetailGridDs,
	cm:INScrapAuditDetailGridCm,
	trackMouseOver:true,
	region:'center',
	height:300,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:InscrapAuditDetailPagingToolbar,
	clicksToEdit:1
});

INScrapAuditGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,r){
	var inscrap = INScrapAuditGridDs.data.items[rowIndex].data["inscp"];
	mainRowId = inscrap;
	INScrapAuditDetailGridDs.setBaseParam('inscrap',inscrap)
	INScrapAuditDetailGridDs.load({params:{start:0,limit:InscrapAuditDetailPagingToolbar.pageSize}});
});
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}	
	var panel = new Ext.Panel({
		title:$g('��汨�����'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	var panel2 = new Ext.Panel({		
		//activeTab:0,
		region:'center',
		///height:100,
		layout:'fit',
		items:[INScrapAuditGrid]                                 
	});
	var panel3 = new Ext.Panel({		
		activeTab:0,
		region:'south',
		height:document.body.clientHeight*0.45,
		layout:'fit',
		items:[INScrapAuditDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,panel2,panel3],
		renderTo:'mainPanel'
	});
	query()
});
//===========ģ����ҳ��=============================================