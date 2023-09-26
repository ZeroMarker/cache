//����: ��ⵥ��Ʊ��¼��
//��д����: 2014.09.17
	var URL="dhcstm.vendorinvaction.csp";
	var UserId = session['LOGON.USERID'];
	var GroupId=session['LOGON.GROUPID']
	var CtLocId = session['LOGON.CTLOCID'];
	
	//�������ֵ��object
    var PayParamObj = GetAppPropValue('DHCSTPAYM');
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date().add(Date.DAY, - 30)
	});
	
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});
	
	var Vendor = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		emptyText : '��Ӧ��...'
	});
	
	// ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     
		LocId:CtLocId,
		UserId:UserId
	});
	
	var INVAssemNo=new Ext.form.TextField({
		fieldLabel : '��Ʊ��ϵ���',
		id : 'INVAssemNo',
		name : 'INVAssemNo',
		anchor : '90%',
		width : 120
	});
	
	var INVRpAmt=new Ext.form.TextField({
		id : 'INVRpAmt',
		fieldLabel:'��Ͻ����ܶ�',
		anchor : '90%'
	});	
	
	var INVNo=new Ext.form.TextField({
		fieldLabel : '��Ʊ��',
		id : 'INVNo',
		name : 'INVNo',
		anchor : '90%',
		width : 120
	});
	
	var filledFlag = new Ext.form.Checkbox({
		fieldLabel : '��¼��',
		id : 'filledFlag',
		name : 'filledFlag',
		anchor : '90%',
		checked : false
	});

	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '�����ѯ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	// ȷ����ť
	var selectBT = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '����',
		width : 70,
		height : 30,
		iconCls : 'page_edit',
		handler : function() {
			save();
		}
	});
	
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '�����ӡ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var rec=FindMasterGrid.getSelectionModel().getSelected();
			if (!rec) return;
			var inv=rec.get('inv');
			Printinv(inv);
		}
	});	
	/**
	 * ���淽��
	 */
	function save() {
		if(FindMasterGrid.activeEditor != null){
			FindMasterGrid.activeEditor.completeEdit();
		}
		var ListDetail="";
		var rowCount = FindMasterGrid.getStore().getCount();

		for (var i = 0; i < rowCount; i++) {
			var rowData = FindMasterGridDs.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Inv=rowData.get("inv");
				var InvNo=rowData.get("invNo");
				var Invrpamt=rowData.get("invrpamt");
				var InvNoDate=Ext.util.Format.date(rowData.get("invNoDate"),ARG_DATEFORMAT);
				var str = Inv + "^" + InvNo + "^" + Invrpamt + "^" + InvNoDate;
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		if(ListDetail==""){
			Msg.info("warning", "����û�з����仯������Ҫ����!");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"������...");
		var url = URL+ '?actiontype=SaveInvNo';
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					Ext.getCmp("filledFlag").setValue(true);
					Query();
				}else {
					var Ret=jsonData.info;
					if(Ret==-1){
						Msg.info("error", "����ʧ��,��������Ҫ���������!");
					}else if(Ret==-2){
						Msg.info("error", "����ʧ��,��Ʊ��ϵ�IdΪ�ջ�Ʊ��ϵ�������!");
					}else if(Ret==-52){
						Msg.info("error", "�Ѹ���,���ܸ��·�Ʊ��Ϣ!");
					}else {
						Msg.info("error", "����ʧ��!");
					}
				}
				mask.hide();
			},
			scope : this
		});
	}	
	/**
	 * ��ѯ����
	 */
	function Query() {
		if (CtLocId == null || CtLocId.length <= 0) {
			return;
		}
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if(sd!=""){
			sd = sd.format(ARG_DATEFORMAT);
		}
		if(ed!=""){
			ed = ed.format(ARG_DATEFORMAT);
		}
		var vendor = Ext.getCmp('Vendor').getValue();
		var stkGrp = Ext.getCmp('StkGrpType').getValue();
		var assemNo = Ext.getCmp('INVAssemNo').getRawValue();
		var rpAmt = Ext.getCmp('INVRpAmt').getValue();
		var invNo = Ext.getCmp('INVNo').getValue();
		var filledFlag = Ext.getCmp('filledFlag').getValue()==true?'Y':'N';
		var completed = "Y"
		/*
		if(vendor==""){
			Msg.info("warning", "��ѡ��Ӧ��!");
			return;
		}
		if(stkGrp==""){
			Msg.info("warning", "��ѡ������!");
			return;
		}*/
		if(sd==""||ed==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return; 
		}
		var StrParam=sd+"^"+ed+"^"+CtLocId+"^"+vendor+"^"+completed+"^"+stkGrp+"^"+assemNo+"^"+rpAmt+"^"+invNo+"^"+filledFlag;
		FindMasterGridDs.setBaseParam('StrParam',StrParam);
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		FindMasterGridDs.load({params:{start:0,limit:MastPagingToolbar.pageSize,sort:'inv',dir:'Desc'}});
		FindMasterGridDs.on('load',function(){
			if (FindMasterGridDs.getCount()>0){
				FindMasterGrid.getSelectionModel().selectFirstRow();
				FindMasterGrid.getView().focusRow(0);
			}
		});
	}
	
	/**
	 * ��շ���
	 */
	function clearData() {
		Ext.getCmp("Vendor").setValue("");
		//Ext.getCmp("StkGrpType").setValue("");
		
		StkGrpType.store.load();
		Ext.getCmp("INVAssemNo").setValue("");
		Ext.getCmp("INVRpAmt").setValue("");
		Ext.getCmp("INVNo").setValue("");
		Ext.getCmp("filledFlag").setValue("");
		
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		this.ginvRowId="";
	}
	
	var FindMasterGrid="";
	var FindMasterGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=query',method:'GET'});
	var fields = ["inv","assemNo","loc","locDesc","vendor","vendorName","UserName",{name:'invNoDate',type:'date',dateFormat:DateFormat},
				  "invDate","invTime","invComp","scgdr","scgDesc","rpamt","spamt","invNo","invrpamt","invspamt"];
	var FindMasterGridDs = new Ext.data.Store({
		proxy:FindMasterGridProxy,
    	reader:new Ext.data.JsonReader({
	    	totalProperty : "results",
        	root:'rows',
   			id : "inv",
			fields : fields
		})
	});

	var FindMasterColumns = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		{
			header : "RowId",
			dataIndex : 'inv',
			hidden : true
		}, {
			header : "��Ʊ��ϵ���",
			dataIndex : 'assemNo',
			width : 120
		}, {
			header : "��Ӧ��",
			dataIndex : 'vendorName',
			width : 200
		}, {
			header : "�Ƶ�����",
			dataIndex : 'invDate',
			width : 90,
			align : 'center'
		}, {
			header : "�Ƶ�ʱ��",
			dataIndex : 'invTime',
			width : 90,
			align : 'center'
		}, {
			header : "�Ƶ���",
			dataIndex : 'UserName',
			width : 90
		}, {
			header : "��Ͻ��۽��",
			dataIndex : 'rpamt',
			xtype : 'numbercolumn',
			width : 90
		}, {
			header : "����ۼ۽��",
			dataIndex : 'spamt',
			xtype : 'numbercolumn',
			width : 90
		},{
			header : "��ɱ�־",
			dataIndex : 'invComp',
			width :60,
			xtype : 'checkcolumn'
		}, {
			header : "��Ʊ��",
			dataIndex : 'invNo',
			width : 120,
			editor:new Ext.form.TextField({selectOnFocus:true})
		}, {
			header : "��Ʊ���",
			dataIndex : 'invrpamt',
			xtype : 'numbercolumn',
			width : 90,
			editor:new Ext.form.NumberField({selectOnFocus:true})
		}, {
			header : "��Ʊ����",
			dataIndex : 'invNoDate',
			
			width : 100,
			align : 'center',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
			})
		}, {
			header : "����˻�����",
			dataIndex : 'locDesc',
			width : 120,
			hidden:true
		}, {
			header : "����",
			dataIndex : 'scgDesc',
			width : 120,
			hidden:true
		}
	]);
	
	var MastPagingToolbar = new Ext.PagingToolbar({
    	store:FindMasterGridDs,
		pageSize:PageSize,
    	displayInfo:true
	});

	var FindMasterGrid = new Ext.grid.EditorGridPanel({
		region: 'center',
		title: '��Ʊ��ϵ�',
		store:FindMasterGridDs,
		cm:FindMasterColumns,
		sm:new Ext.grid.RowSelectionModel({singleSelect : true}),
		trackMouseOver:true,
		stripeRows:true,
		loadMask:true,
		bbar:[MastPagingToolbar]
	});
	
	FindMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ginvRowId = FindMasterGridDs.getAt(rowIndex).get("inv");
		FindDetailGrid.load({params:{parref:ginvRowId}}); 
	});

	var FindDetailColumns = [{
			header : "RowId",
			dataIndex : 'invi',
			hidden : true
		}, {
			header : "����˻���ϸId",
			dataIndex : 'ingridr',
			width : 80,
			hidden : true
		}, {
			header : "����Id",
			dataIndex : 'IncId',
			width : 80,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 180
		}, {
			header : "���",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "����",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			header : "��λ",
			dataIndex : 'UomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "����",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "�ۼ�",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "���۽��",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "�ۼ۽��",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "����",
			dataIndex : 'TransType',
			width : 70,
			align : 'left',
			sortable : true	
		}, {
			header : "����",
			dataIndex : 'manf',
			width : 150
		}];
	
	var FindDetailGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'south',
		split: true,
		height: 220,
		collapsible: true,
		title: '��Ʊ��ϵ���ϸ',
		id : 'FindDetailGrid',
		editable : false,
		contentColumns : FindDetailColumns,
		smType : "row",
		autoLoadStore : false,
		actionUrl : URL,
		queryAction : "queryItem",
		idProperty : "invi",
		remoteSort : false,
		showTBar : false,
		paging : true
	});
	
	var HisListTab = new Ext.ux.FormPanel({
		title:'��ⵥ���˻�����Ϸ�Ʊ��¼��',
		labelWidth : 100,
		tbar : [SearchBT, '-', ClearBT,'-',selectBT,'-',PrintBT],
		layout: 'column',
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			columnWidth : 1,
			layout : 'column',			
			autoHeight : true,
			defaults: {columnWidth: 0.25,layout:'form'},
			items : [
				{
					items: [StartDate,EndDate]
				},{
					items: [Vendor,StkGrpType]  
				},{
					items: [INVAssemNo,INVRpAmt]
				},{
					items: [INVNo,filledFlag]
			}]
			
		}]
	});
Ext.onReady(function(){
	
	//ȡ�Ƿ���Ҫ��������
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, FindMasterGrid, FindDetailGrid]
	});
})