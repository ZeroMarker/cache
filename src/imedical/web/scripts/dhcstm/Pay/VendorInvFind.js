//����: ��ⵥ��Ʊ����Ƶ���ѯ
//��д����: 2014.09.11
var invWindow = null;
function QueryVendorInv(LocRowId,Fn){
	var URL="dhcstm.vendorinvaction.csp";
	var UserId = session['LOGON.USERID'];
	var GroupId=session['LOGON.GROUPID']

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
	
	var FindVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'FindVendor',
		name : 'FindVendor',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		params : {ScgId : 'FindStkGrpType'},
		valueParams : {LocId : LocRowId}
	});
	
	// ����
	var FindStkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'FindStkGrpType',
		name : 'FindStkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     
		LocId:LocRowId,
		UserId:UserId
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
		text : 'ȷ��',
		tooltip : 'ȷ��',
		width : 70,
		height : 30,
		iconCls : 'page_edit',
		handler : function() {
			returnData();
		}
	});
	
	var CancelBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����˳�������',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			invWindow.close();
		}
	});
	
	/**
	 * ��ѯ����
	 */
	function Query() {
		if (LocRowId == null || LocRowId.length <= 0) {
			return;
		}
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		var vendor = Ext.getCmp('FindVendor').getValue();
		var stkGrp = Ext.getCmp('FindStkGrpType').getValue();
		var completed = Ext.getCmp("invStatus").getValue().getGroupValue();
		if(sd!=""){
			sd = sd.format(ARG_DATEFORMAT);
		}
		if(ed!=""){
			ed = ed.format(ARG_DATEFORMAT);
		}
		if(stkGrp==""){
			Msg.info("warning", "��ѡ������!");
			return;
		}
		if(sd==""||ed==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return; 
		}
		var StrParam=sd+"^"+ed+"^"+LocRowId+"^"+vendor+"^"+completed+"^"+stkGrp+"^^^^";
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
		Ext.getCmp("FindVendor").setValue("");
		Ext.getCmp("FindStkGrpType").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("invStatus").setValue("N");
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		MastPagingToolbar.getComponent(4).setValue(1);   //���õ�ǰҳ��
		MastPagingToolbar.getComponent(5).setText("ҳ,�� 1 ҳ");//���ù���ҳ
		MastPagingToolbar.getComponent(12).setText("û�м�¼"); //���ü�¼����
		this.ginvRowId="";
	}
	
	var invStatus = new Ext.form.RadioGroup({
		id : 'invStatus',
		columns : 3,
		items:[
			{boxLabel:'ȫ��',name:'invStatus',inputValue:""},
			{boxLabel:'�����',name:'invStatus',inputValue:"Y"},
			{boxLabel:'δ���',name:'invStatus',inputValue:"N",checked:true}
		]
	});
	var FindMasterGrid="";
	var FindMasterGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=query',method:'GET'});
	var fields = ["inv","assemNo","loc","locDesc","vendor","vendorName","UserName",
				  "invDate","invTime","invComp","scgdr","scgDesc","rpamt","spamt","invNo"];
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
    	displayInfo:true,
    	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    	emptyMsg:"û�м�¼"
	});

	var FindMasterGrid = new Ext.grid.EditorGridPanel({
		store:FindMasterGridDs,
		cm:FindMasterColumns,
		sm:new Ext.grid.RowSelectionModel({singleSelect : true}),
		trackMouseOver:true,
		height:220,
		stripeRows:true,
		loadMask:true,
		bbar:[MastPagingToolbar],
		listeners : {
			dblclick : function(){
				returnData();
			}
		}
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
			header : "����˻�Id",
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
	
	function returnData() {
		var ginvRowId = FindMasterGrid.getSelectionModel().getSelected().get("inv");
		if (ginvRowId!=""){
			Fn(ginvRowId); 
			invWindow.close();
		}else{
			Msg.info("warning","��ѡ��Ҫ���صķ�Ʊ��ϵ���Ϣ!");
		}
	}
	
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding-top:5px;',
		tbar : [SearchBT, '-', ClearBT,'-',selectBT,'-',CancelBT],
		layout: 'fit',
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',
			autoHeight : true,
			defaults: {columnWidth: 0.33,layout:'form'},
			items : [
				{
					items: [StartDate,EndDate]
				},{
					items: [FindVendor,FindStkGrpType]  
				},{
					items: [invStatus]
				}
			]
		}]
	});
	
	var invWindow =  new Ext.Window({
		title : '��Ʊ��ϵ���ѯ',
		width : 1000,
		height : 600,
		modal : true,
		layout : 'border',
		items : [
			{
				region: 'north',
				height: 130,
				layout: 'fit',
				items:HisListTab
			}, {
				region: 'center',
				title: '��Ʊ��ϵ�',
				layout: 'fit',
				items: FindMasterGrid
			}, {
				region: 'south',
				split: true,
				height: 200,
				collapsible: true,
				title: '��Ʊ��ϵ���ϸ',
				layout: 'fit',
				items: FindDetailGrid
			}
		]
	});
	invWindow.show();
}