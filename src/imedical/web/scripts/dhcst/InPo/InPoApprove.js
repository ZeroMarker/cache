// /����: ��������
// /����: ��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.08

	var gGroupId = session['LOGON.GROUPID'];
	var userId = session['LOGON.USERID'];
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		groupId : gGroupId
	});
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '������',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '������...',
					defaultLoc:{}
		});	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		value : new Date().add(Date.DAY, - 7)
	});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		value : new Date()
	});

	var inpoNoField = new Ext.form.TextField({
		id:'inpoNoField2',
		fieldLabel:'������',
		allowBlank:true,
		emptyText:'������...',
		anchor:'90%',
		selectOnFocus:true
	});
	// ��������
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		width : 150,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = '';
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});
	var IncId = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'IncId',
		name : 'IncId',
		hidden:true
	});
		/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, stktype) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
		}
	}
	
	/**
	 * ���ط���
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var InciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(InciDesc);
		Ext.getCmp("IncId").setValue(inciDr);
	}
	// ��Ӧ��
	var apcVendorField = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor : '90%',
		emptyText : '��Ӧ��...'
	});

		var approveStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', 'ȫ��'],['1', '�������'], ['2', '���վܾ�'],['3', 'δ����']]
		});
		
		var approveflag = new Ext.form.ComboBox({
			fieldLabel : '����״̬',
			id : 'approveflag',
			name : 'approveflag',
			anchor:'90%',
			width : 120,
			store : approveStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
	Ext.getCmp("approveflag").setValue("3");
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'includeDefLoc',
			fieldLabel:'����֧�����',
			anchor:'90%',
			width:150,
			checked:true,
			allowBlank:true
	});
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '��ѯ',
		tooltip : '�����ѯ����',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});


	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	var cancelBt=new Ext.Toolbar.Button({
		id : "cancelBT",
		text : '���ղ�ͨ��',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			approve("N")
		}
	})
	// ����
	var ApproveBT = new Ext.Toolbar.Button({
				id : "ApproveBT",
				text : '����',
				tooltip : '����',
				width : 70,
				height : 30,
				iconCls : 'page_refresh',
				handler : function() {approve("Y")}
			});
	
     function approve(flag){

				var recarr=MasterGrid.getSelectionModel().getSelections();
				var count=recarr.length;
				if(count==0){Msg.info("warning","��ѡ����Ķ���!");return};
				var poistr=""
				for (i=0;i<count;i++)
				{
					var rec=recarr[i];
					var poi=rec.get('PoId');
					var Approveed=rec.get('Approveed');
					if(Approveed!=""){Msg.info("warning","�����Ѿ����յ��ݣ������ظ�����!");return};
					if (poistr=="")
			 		{poistr=poi}
			 		else
			 		{poistr=poistr+','+poi}
				}
				
			    var url = DictUrl+ "inpoaction.csp?actiontype=Approve";
			    Ext.Ajax.request({
						url : url,
						params:{poistr:poistr,user:userId,flag:flag},
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ˢ�½���
								var ret=jsonData.info;
								Msg.info("success","�ɹ�!");	
								MasterStore.reload();
							}else{
								if(jsonData.info==-1){
									Msg.info("error","�˵���û����ɣ���������!");
								}else{
								   Msg.info("error",jsonData.info);
								}
									
							}
						},
						scope : this
					});
				}			
			
	
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("inpoNoField2").setValue("");
		Ext.getCmp("IncId").setValue("");
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp('approveflag').setValue(false);
		Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp('EndDate').setValue(new Date());
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		
	}

	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var venDesc=Ext.getCmp("apcVendorField").getValue();
		if (venDesc==""){
			Ext.getCmp("apcVendorField").setValue("");
		}
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var PoNo = Ext.getCmp('inpoNoField2').getValue();
		var Status='';
		var AuditFlag = Ext.getCmp('approveflag').getValue();
		
		var inciDesc=Ext.getCmp("InciDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var InciId=Ext.getCmp("IncId").getRawValue();
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?1:0);  //�Ƿ����֧�����
		var  RequestPhaLoc=Ext.getCmp("RequestPhaLoc").getValue();
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)^����id
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+Vendor+'^'+phaLoc+'^'+''+'^'+AuditFlag+'^'+Status+'^'+InciId+'^'+includeDefLoc+'^'+RequestPhaLoc;
		
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	// ��ʾ������ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
		
	function renderPoStatus(value){
		var PoStatus='';
		if(value=="Y"){
			PoStatus='���ճɹ�';			
		}else if(value=="N"){
			PoStatus='���վܾ�';
		}else{
			PoStatus='δ����';
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","CmpFlag","Approveed","ApproveedUser","ApproveedDate","ReqLocDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				listeners:{
					'load':function(ds){
						DetailGrid.store.removeAll();
						DetailGrid.getView().refresh();
						
//						if (ds.getCount()>0)
//						{
//							MasterGrid.getSelectionModel().selectFirstRow();
//							MasterGrid.getView().focusRow(0);
//						}
					}
				
					
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var sm1=new Ext.grid.CheckboxSelectionModel({})
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1, {
		header : "RowId",
		dataIndex : 'PoId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "������",
		dataIndex : 'PoNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'PoLoc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "�������",
		dataIndex : 'ReqLocDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "��Ӧ��",
		dataIndex : 'Vendor',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "����״̬",
		dataIndex : 'Approveed',
		width : 90,
		align : 'left',
		sortable : true,
		renderer:renderPoStatus
	}, {
		header : "��������",
		dataIndex : 'PoDate',
		width : 80,
		align : 'right',
		sortable : true
	},{
	
		header : "������",
		dataIndex : 'ApproveedUser',
		width : 80,
		align : 'right',
		sortable : true
	},{
	
		header : "��������",
		dataIndex : 'ApproveedDate',
		width : 80,
		align : 'right',
		sortable : true
	}
	
	]);
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var MasterGrid = new Ext.grid.GridPanel({
		cm : MasterCm,
		sm : sm1,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar
		
	});

	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
		var PoId = rec.get("PoId");
		var Size=DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('Parref',PoId);
		DetailStore.load({params:{start:0,limit:Size}}); 
	});				
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// ָ���в���
	//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty","CerNo","CerExpDate","Cancleflag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "PoItmId",
		fields : fields
	});
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "������ϸid",
		dataIndex : 'PoItmId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "����RowId",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '���ʴ���',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "ע��֤��",
		dataIndex : 'CerNo',
		width : 240,
		align : 'right',
		sortable : true
	}, {
		header : "ע��֤Ч��",
		dataIndex : 'CerExpDate',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'PurUom',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'PurQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'ImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "δ��������",
		dataIndex : 'NotImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "�Ƿ���",
		dataIndex : 'Cancleflag',
		width : 80,
		align : 'left',
		sortable : true
	}]);
var rightClick = new Ext.menu.Menu({
	id : 'rightClick',
	items: [
		{
			id : 'Pack',
			handler : PackLink,
			text : '����ϸ'
		}
	] 
});
function PackLink(item,e){
	var Record = DetailGrid.getSelectionModel().getSelected();
	var PackrowId=Record.get("IncId")
	PackLink(PackrowId)
	
}
	var DetailGrid = new Ext.ux.GridPanel({
		id : 'DetailGrid',
		region : 'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:DetailPagingToolbar,
		listeners : {
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().selectRow(rowindex);
			rightClick.showAt(e.getXY());
		}
	}
	});
	
	var HisListTab = new Ext.ux.FormPanel({
		    title:'��������',
			region:'north',
			tbar : [SearchBT, '-',ApproveBT,'-', ClearBT,'-',cancelBt],
			height: 160,
			items : [{
				xtype : 'fieldset',
				title : '��ѯ��Ϣ',
				layout : 'column',					
				items : [{
					columnWidth : .2,
					layout : 'form',
					items : [PhaLoc,apcVendorField]
				}, {
					columnWidth : .2,
					layout : 'form',
					items : [StartDate,EndDate]
				}, {
					columnWidth : .2,
					layout : 'form',
					items : [inpoNoField,InciDesc]
				},{
					columnWidth : .2,
					layout : 'form',
					items : [approveflag,RequestPhaLoc]
				},{
					columnWidth : .2,
					layout : 'form',
					items : [includeDefLoc]
				}]
				
			}]		
						
		});
				
	
	// ҳ�沼��
	var mainPanel = new Ext.form.FormPanel({
		region:'center',
		layout:'border',
		items : [{
			region:'west',		
			title:'����',
			collapsible:true,
	        split:true,
			layout:'fit',
			width:550,
	        minSize:0,
	        maxSize:550,
			items:[MasterGrid]     			
		},{
			region:'center',
			layout:'fit',
			title:'������ϸ',
			region:'center',
			items:[DetailGrid]    				
		}]

	});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab,mainPanel]
	});
});