// /����: ��ֵ�˿�--���ݳ��ⵥ����ת�뵥/�˿ⵥ
// /����: 
// /��д�ߣ�	wangjiabin

var SelInIsTrfOut=function(SupplyLocId,Fn) {
	var gUserId = session['LOGON.USERID'];

	// ���ղ���
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : '���ղ���',
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:'������',
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
	var CloseBTOut = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findOutWin.close();
				}
			});
			
	// ��ѯ���󵥰�ť
	var SearchBTOut = new Ext.Toolbar.Button({
				id : "SearchBTOut",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					QueryOut();
				}
			});

	// ��հ�ť
	var ClearBTOut = new Ext.Toolbar.Button({
				id : "ClearBTOut",
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
		OutMasterGrid.store.removeAll();
		OutDetailGrid.store.removeAll();
	}

	// ���水ť
	var SaveBTOut = new Ext.ux.Button({
				id : "SaveBTOut",
				text : '����',
				tooltip : '�������ת�뵥',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(OutDetailGrid.activeEditor!=null){
						OutDetailGrid.activeEditor.completeEdit();
					}
					save();
				}
			});
	
	/**
	 * ����ת�Ƶ�
	 */
	function save() {
		var InitRowid="";
		var selectRow=OutMasterGrid.getSelectionModel().getSelected();
		if(selectRow==null || selectRow==""){
			Msg.info("warning","��ѡ��Ҫ���������!");
			return;
		}
		var init=selectRow.get("init");		
		var rowCount=DetailOutStore.getCount();
		var ListDetail="";
		for(var i=0;i<rowCount;i++){
			var rowData = DetailOutStore.getAt(i);
			var initi = rowData.get("initi");
			var qty = rowData.get("qty");
			if(qty=="" || qty==null){continue;}
			var HVBarCode = rowData.get("HVBarCode");
			var detailData=initi+"^"+qty+"^"+HVBarCode;
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
		
		var mask=ShowLoadMask(findOutWin.body,"��������ת�뵥...");
		Ext.Ajax.request({
			url : DictUrl+ "dhcinistrfaction.csp?actiontype=CreateInIsTrf",
			method : 'POST',
			params : {InIt:init,ListDetail:ListDetail,UserId:gUserId},
			success : function(result, request) {
				
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success","����ɹ�!");
					InitRowid = jsonData.info;
					
					findOutWin.close();
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
	function QueryOut() {
		var PhaLoc = Ext.getCmp("RequestPhaLoc").getValue();	//������"����"
		if (PhaLoc =='' || PhaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�����!");
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
		var UserScgPar = PhaLoc + '%' + gUserId;
		var HVPro = 'Y';		//����û�п�������Ŀյ�
		var ListParam=startDate+'^'+endDate+'^'+PhaLoc+'^'+requestphaLoc+'^'+comp
			+"^"+status+'^^^^'
			+'^^^^'+UserScgPar+'^'
			+'^^'+HVPro;
		MasterOutStore.setBaseParam('ParamStr',ListParam);
		DetailOutStore.removeAll();
		MasterOutStore.removeAll();
		MasterOutStore.load({
			params:{start:0, limit:MasterOutToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info("error", "��ѯ����, ��鿴��־!");
				}else{
					if(r.length>0){
						OutMasterGrid.getSelectionModel().selectFirstRow();
					}
				}
			}
		});
	}
	
	// ����·��
	var MasterOutUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterOutUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["init", "initNo", "toLoc","toLocDesc","frLoc", "frLocDesc", "dd","tt", "comp", "userName","status","StatusCode",
					"scg","scgDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "init",
				fields : fields
			});
	// ���ݼ�
	var MasterOutStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterOutCm = new Ext.grid.ColumnModel([nm, {
				header : "���ⵥid",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���ⵥ��",
				dataIndex : 'initNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "���ղ���",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Դ����",
				dataIndex : 'frLocDesc',
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
		]);
	
	var MasterOutToolbar= new Ext.PagingToolbar({
		store:MasterOutStore,
		pageSize:PageSize,
		displayInfo:true
	});
	
	var smOut = new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners:{
			rowselect:function(sm,rowIndex,r){
				var InIt = MasterOutStore.getAt(rowIndex).get("init");
				DetailOutStore.setBaseParam('Parref',InIt);
				DetailOutStore.removeAll();
				DetailOutStore.load({params:{start:0,limit:999}});
			}
		}
	});
	
	var OutMasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterOutCm,
				sm : smOut,
				store : MasterOutStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:MasterOutToolbar
			});
			
	// ����·��
	var DetailUrl =DictUrl+'dhcinistrfaction.csp?actiontype=QueryDetailHV';
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
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc", "HVBarCode"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var DetailOutStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var DetailOutCm = new Ext.grid.ColumnModel([
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
				header : "��ֵ����",
				dataIndex : 'HVBarCode',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true,
				editable : !UseItmTrack,
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

	var OutDetailGrid = new Ext.grid.EditorGridPanel({
				id : 'OutDetailGrid',
				region : 'center',
				title : '',
				cm : DetailOutCm,
				store : DetailOutStore,
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
		id:'OutRightClickCont',
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
		var cell = OutDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = OutDetailGrid.getStore().getAt(row);			
		OutDetailGrid.getStore().remove(record);
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
//	OutMasterGrid.on('rowdblclick', function() {			
//		// ����ת�Ƶ�
//		if(CheckDataBeforeSave()==true){
//			save();
//		}		
//	});

	var findOutWin = new Ext.Window({
		title:'ѡȡ���ⵥ',
		id:'findOutWin',
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
	            title: '���ⵥ',
	            collapsible: true,
	            split: true,
	            width: 300,
	            minSize: 175,
	            maxSize: 400,
	            margins: '0 5 0 0',
	            layout: 'fit',
	            items: OutMasterGrid
	        }, {
	            region: 'center',
	            title: '���ⵥ��ϸ',
	            layout: 'fit',
	            items: OutDetailGrid
	        }
		],
		tbar : [SearchBTOut, '-',  ClearBTOut, '-', SaveBTOut, '-', CloseBTOut]
	});
	
	//��ʾ����
	findOutWin.show();
	QueryOut();		
}