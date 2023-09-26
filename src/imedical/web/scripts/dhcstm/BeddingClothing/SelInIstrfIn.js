// /����: ������--����ת�뵥�������ⵥ
// /����: 
// /��д�ߣ�	wangjiabin
// /��д����: 2013-12-30
var SelInIsTrfIn=function(SupplyLocId,Fn) {
	var gUserId = session['LOGON.USERID'];

	// ���ղ���
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : '��Դ����',
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:'��Դ����',
		anchor : '90%',
		width : 120,
		defaultLoc:{}
	}); 
	
	// ��ʼ����
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDateS',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDateS',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});
	
	// 3�رհ�ť
	var CloseBTIn = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findInWin.close();
				}
			});
			
	// ��ѯ���󵥰�ť
	var SearchBTIn = new Ext.Toolbar.Button({
				id : "SearchBTIn",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					QueryIn();
				}
			});

	// ��հ�ť
	var ClearBTIn = new Ext.Toolbar.Button({
				id : "ClearBTIn",
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		Ext.getCmp("RequestPhaLocS").setValue("");
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		InMasterGrid.store.removeAll();
		InDetailGrid.store.removeAll();	
	}

	// ���水ť
	var SaveBTIn = new Ext.ux.Button({
				id : "SaveBTIn",
				text : '����',
				tooltip : '�������ת����',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(InDetailGrid.activeEditor!=null){
						InDetailGrid.activeEditor.completeEdit();
					}
					save();
				}
			});
	
	/**
	 * ����ת�Ƶ�
	 */
	function save() {
		var InitRowid="";
		var selectRow=InMasterGrid.getSelectionModel().getSelected();
		if(selectRow==null || selectRow==""){
			Msg.info("warning","��ѡ��Ҫ���������!");
			return;
		}
		var init=selectRow.get("init");
		
//		var frLocIn = selectRow.get("toLoc");	//���ݳ��ⵥ��ת�뵥, ������ҶԵ�
//		var toLocIn = selectRow.get("frLoc");
//		
//		var scg=selectRow.get("scg");
//		var reqid="",operatetype="",Complete="N",Status=10;
//		var styType=App_StkTypeCode;
//		var remark="";
//		var MainInfo = frLocIn + "^" + toLocIn + "^"+ reqid + "^" + operatetype + "^" + Complete
//					+ "^" + Status + "^" + gUserId + "^" + scg + "^" + styType + "^" + remark;
		
		var rowCount=DetailInStore.getCount();
		var ListDetail="";
		for(var i=0;i<rowCount;i++){
			var rowData = DetailInStore.getAt(i);
			var initi = rowData.get("initi");
			var qty = rowData.get("qty");
			if(qty=="" || qty==null){continue;}
			var detailData=initi+"^"+qty;
			if(ListDetail==""){
				ListDetail=detailData;
			}else{
				ListDetail=ListDetail+xRowDelim()+detailData;
			}
		}
		if(ListDetail==""){
			Msg.info("warning","û����Ҫ�������ϸ����!");
			return;
		}
		
		var mask=ShowLoadMask(findInWin.body,"��������ת�뵥...");
		Ext.Ajax.request({
			url : DictUrl+ "dhcinistrfaction.csp?actiontype=CreateInIsTrf",
			method : 'POST',
			params : {InIt:init,ListDetail:ListDetail,UserId:gUserId},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success","����ɹ�!");
					InitRowid = jsonData.info;
					findInWin.close();
					Fn(InitRowid);
				}else{
					var ret=jsonData.info;
					Msg.info("error", "���治�ɹ���"+ret);
				}
				mask.hide();
			}
		});
	}
	
	// ��ʾ��������
	function QueryIn() {
		var toLoc = Ext.getCmp("SupplyPhaLoc").getValue();	//������"��������"
		if (toLoc =='' || toLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񹩸�����!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLocS").getValue();		
		var startDate = Ext.getCmp("StartDateS").getValue();
		var endDate = Ext.getCmp("EndDateS").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var comp="Y",status="31";
		var UserScgPar = toLoc + '%' + gUserId;
		var ListParam=startDate+'^'+endDate+'^'+requestphaLoc+'^'+toLoc+'^'+comp
			+"^"+status+'^^^^'
			+'^^^^'+UserScgPar;
		MasterInStore.setBaseParam('ParamStr',ListParam);
		DetailInStore.removeAll();
		MasterInStore.removeAll();
		MasterInStore.load({
			params:{start:0, limit:MasterInToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info("error", "��ѯ����, ��鿴��־!");
				}else{
					if(r.length>0){
						InMasterGrid.getSelectionModel().selectFirstRow();
					}
				}
			}
		});
	}
	
	// ����·��
	var MasterInUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["init", "initNo", "toLoc","toLocDesc","frLoc", "frLocDesc", "dd","tt", "comp", "userName","status","StatusCode",
					"scg","scgDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
				fields : fields
			});
	// ���ݼ�
	var MasterInStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInCm = new Ext.grid.ColumnModel([nm, {
				header : "���ⵥid",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ת�뵥��",
				dataIndex : 'initNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "��Դ����",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "���ղ���",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'dd',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����ʱ��",
				dataIndex : 'tt',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'scgDesc',
				width : 80,
				align : 'left',
				sortable : true
			}
		/*	, {
				header : "����״̬",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}	*/
			]);
	MasterInCm.defaultSortable = true;
	
	var MasterInToolbar= new Ext.PagingToolbar({
		store:MasterInStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var smIn = new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners:{
			rowselect:function(sm,rowIndex,r){
				var InIt = MasterInStore.getAt(rowIndex).get("init");
				DetailInStore.setBaseParam('Parref',InIt);
				DetailInStore.removeAll();
				DetailInStore.load({params:{start:0,limit:999}});
			}
		}
	});
	
	var InMasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterInCm,
				sm : smIn,
				store : MasterInStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:MasterInToolbar
			});
			
	// ����·��
	var DetailUrl =DictUrl+'dhcinistrfaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin","pp", "spec","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var DetailInStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var DetailInCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header : "ת��ϸ��RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'inciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'inciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����id",
				dataIndex : 'inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ת������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "��������Ϊ��!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "��������С�ڻ����0!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "ת�Ƶ�λ",
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����~Ч��",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manfName',
				width : 140,
				align : 'left'
			}, {
				header : "����",
				dataIndex : 'rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "��λ��",
				dataIndex : 'stkbin',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�����ۼ�",
				dataIndex : 'newSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'spAmt',
				width : 80,
				align : 'right',
				sortable : true
			}]);

	var InDetailGrid = new Ext.grid.EditorGridPanel({
				id : 'InDetailGrid',
				region : 'center',
				title : '',
				cm : DetailInCm,
				store : DetailInStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel(),
				clicksToEdit : 1,
				listeners : {
					//�Ҽ��˵�����ؼ�����
					'rowcontextmenu': rightClickFn
				}
			});
			
	var rightClick = new Ext.menu.Menu({
		id:'InRightClickCont',
		items: [
			{
				id: 'mnuDelete',
				handler: deleteDetail,
				text: 'ɾ��'
			}
		]
	});
	//�Ҽ��˵�����ؼ�����
	function rightClickFn(grid,rowindex,e){
		grid.getSelectionModel().select(rowindex,1);
		e.preventDefault();
		rightClick.showAt(e.getXY());
	}
	/**
	 * ɾ��ѡ��������
	 */
	function deleteDetail() {
		// �ж�ת�Ƶ��Ƿ������
		var cell = InDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = InDetailGrid.getStore().getAt(row);
		InDetailGrid.getStore().remove(record);
	}
	
	var HisListTab = new Ext.form.FormPanel({
		labelwidth : 60,
		labelAlign : 'right',
		frame : true,
		height : 100,
		bodyStyle : 'padding:0px 0px 0px 0px;',
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			defaults: {border:false}, 
			style:"padding:5px 0px 0px 0px",
			layout: 'column',
			items : [{
				columnWidth: 0.34,
				xtype: 'fieldset',
				defaults: {width: 220},
				defaultType: 'textfield',
				autoHeight: true,
				items: [RequestPhaLocS]	
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				defaults: {width: 140},
				defaultType: 'textfield',
				autoHeight: true,
				items: [StartDateS,EndDateS]
			}]
		}]		
	});

//	// ˫���¼�
//	InMasterGrid.on('rowdblclick', function() {
//		// ����ת�Ƶ�
//		if(CheckDataBeforeSave()==true){
//			save();
//		}
//	});

	var findInWin = new Ext.Window({
		title:'ѡȡת�뵥',
		id:'findInWin',
		width:1000,
		height:520,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'border',
		items : [
			{
				region: 'north',
				height: 110,
				layout: 'fit',
				items:HisListTab
			}, {
				region: 'west',
				title: 'ת�뵥',
				collapsible: true,
				split: true,
				width: 300,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				layout: 'fit',
				items: InMasterGrid
			}, {
				region: 'center',
				title: 'ת�뵥��ϸ',
				layout: 'fit',
				items: InDetailGrid
			}
		],
		tbar : [SearchBTIn, '-',  ClearBTIn, '-', SaveBTIn, '-', CloseBTIn]
	});
		
	//��ʾ����
	findInWin.show();
	QueryIn();
}