// /����: ѡҩƷ����Ӧȫ��ҩƷ���δ���
// /����: ѡҩƷ����Ӧȫ��ҩƷ����
// /��д�ߣ�wyx 
// /��д����: 2014.03.19

/**
 Input:ҩƷ����¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G��ҩƷ
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 Fn���ص�����
 */
IncItmBatWindowAll =function(Input, StkGrpRowId,LocId, StkGrpType, NotUseFlag,
		 HospID,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	/*ҩƷ����------------------------------*/
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialogAll&Input='
			+ Input + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&NotUseFlag=' + NotUseFlag
			+  '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "BuomDesc", "BillUomDesc",
			"PhcFormDesc", "GoodName", "GeneName", {name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "Remark"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciDr",
				fields : fields
			});
	// ���ݼ�
	var PhaOrderStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});


	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : PhaOrderStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
				emptyMsg : "No results to display",
				prevText : "��һҳ",
				nextText : "��һҳ",
				refreshText : "ˢ��",
				lastText : "���ҳ",
				firstText : "��һҳ",
				beforePageText : "��ǰҳ",
				afterPageText : "��{0}ҳ",
				emptyMsg : "û������"
			});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(selmod,rowindex,record){
				
					var record=PhaOrderGrid.getStore().getAt(rowindex);
					var incid=record.get("InciDr");
					var pagesize=ItmBatPagingToolbar.pageSize;
					ItmLcBtStore.setBaseParam("IncId",incid);
					ItmLcBtStore.setBaseParam("LocId",LocId);
					ItmLcBtStore.load({params:{start:0,limit:pagesize}});
				
			}
		}
	});
	
	
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '������',
   		dataIndex: 'NotUseFlag',
   		width: 45
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm,  {
				header : "����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'PhcFormDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʒ��",
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����ͨ����",
				dataIndex : 'GeneName',
				width : 80,
				align : 'left',
				sortable : true
			}, ColumnNotUseFlag]);
	PhaOrderCm.defaultSortable = true;
	var PhaOrderGrid = new Ext.grid.GridPanel({
				cm : PhaOrderCm,
				store : PhaOrderStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : sm,
				loadMask : true,
				bbar : StatuTabPagingToolbar,
				deferRowRender : false
			});
// �س��¼�
	PhaOrderGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			ItmLcBtGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
			row = ItmLcBtGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
					ItmLcBtGrid.getView().focusRow(0);
				}	
			}
		}
	}); 
	// ˫���¼�
	PhaOrderGrid.on('rowclick', function(grid,rowindex,e) {
		if(rowindex>0){
			var record=PhaOrderGrid.getStore().getAt(rowindex);
			var incid=record.get("InciDr");
			var pagesize=StatuTabPagingToolbar.pageSize;
			ItmLcBtStore.setBaseParam("IncId",incid);
			ItmLcBtStore.load({params:{start:0,limit:pagesize},
			callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning','û���κμ�¼��');
			 	if(window){window.focus();}
			} else {
				/*
				ItmLcBtGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
				row = ItmLcBtGrid.getView().getRow(0);
				if (row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
					}	
				}*/
			}
		}});
		}
	});
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning','û���κη��ϵļ�¼��');
			 	        if(window){window.hide();}
			} else {
				PhaOrderGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
				row = PhaOrderGrid.getView().getRow(0);
				if (row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
						PhaOrderGrid.getView().focusRow(0);
					}	
				}
			}
		}
	});
	
	/*���δ���------------------------------*/	
	// ָ���в���
	// ���ݼ�
	var ItmLcBtStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:DictUrl	+ 'drugutil.csp?actiontype=GetDrugBatInfoAll',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"Incib",
		fields :  ["Incib","InciDr","InciCode","InciDesc","BatExp","PurUomId","PurUomDesc", "Rp", "Sp",
			"BUomId","BUomDesc"],
		baseParams:{
			IncId:'',
                     LocId:'' 
		}
	});

	var ItmBatPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
				emptyMsg : "No results to display",
				prevText : "��һҳ",
				nextText : "��һҳ",
				refreshText : "ˢ��",
				lastText : "���ҳ",
				firstText : "��һҳ",
				beforePageText : "��ǰҳ",
				afterPageText : "��{0}ҳ",
				emptyMsg : "û������"
			});

	var nm2 = new Ext.grid.RowNumberer();
	//var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
    var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});   
	var ItmLcBtCm = new Ext.grid.ColumnModel([nm2,  {
				header : "����RowID",
				dataIndex : 'Incib',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "InciDr",
				dataIndex : 'InciDr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '����',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����/Ч��",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��λID",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "��λ",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "���ν���",
				dataIndex : 'Rp',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "�����ۼ�",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "������λRowId",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������λ",
				dataIndex : 'BUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;
	var ItmLcBtGrid = new Ext.grid.GridPanel({
		cm : ItmLcBtCm,
		store : ItmLcBtStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm2,	//new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
		loadMask : true,
		bbar : ItmBatPagingToolbar,
		deferRowRender : false
	});
	// �س��¼�
	ItmLcBtGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			returnData();
		}
	});
	// ˫���¼�
	ItmLcBtGrid.on('rowdblclick', function() {
				returnData();
	});		
	// ���ذ�ť
	var returnBT = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '�������',
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});
			
	/**
	 * ��������
	 */
	function returnData() {
		var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ��һ��������Ϣ��");
		}else if(selectRows.length>1){
			Msg.info("warning", "ֻ��ѡ��һ��������Ϣ��");
		} else {
			flg = true;
			window.close();
		}
	}


	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����ر�',
		iconCls : 'page_delete',
		handler : function() {
			flg = false;
			window.close();
		}
	});

if(!window){
	var window = new Ext.Window({
			title : '���ҿ����������Ϣ',
			width : document.body.clientWidth*0.7,
			height : document.body.clientHeight*0.9,
			layout : 'border',
			plain : true,
			tbar : [returnBT, '-', closeBT],
			modal : true,
			buttonAlign : 'center',
			autoScroll : true,
			items : [{
				region:'north',
				height:document.body.clientHeight*0.9*0.4,
				split:true,
				layout:'fit',
				items:PhaOrderGrid
			},{
				region:'center',
				layout:'fit',
				items:ItmLcBtGrid
			}]
	});
}

	window.show();
	
	window.on('close', function(panel) {
		var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Fn("");
		}  else {
			if (flg) {
				var batRecord=selectRows[0];
				var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
				Ext.applyIf(batRecord.data,itmRecord.data);
				Fn(batRecord);
			} else {
				Fn("");
			}
		}
	});
}