///����: ѡҩƷ����Ӧ���δ���
///����: ѡҩƷ����Ӧ����
///��д�ߣ�yunhaibao
///��д����: 20150515
///�������ɶ�ѡ������Ϣ����
/**
 Input:ҩƷ����¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G��ҩƷ
 Locdr:����id
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 ReqLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 *////yunhaibao20150501�������ҩƷ��־,���ֶ�����Ϣ      //,RestrictedFlag,gHospNoUse
IncItmBatMutiSelectWindow =function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, ReqLoc,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	/*ҩƷ����------------------------------*/
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input='
			+ encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15+'&ReqLocDr='+ReqLoc;        

	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			"PhcFormDesc", "GoodName", "GeneName", {name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark", "PuomQtyO"];
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
				displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
				emptyMsg : "No results to display",
				prevText : $g("��һҳ"),
				nextText : $g("��һҳ"),
				refreshText : $g("ˢ��"),
				lastText : $g("���ҳ"),
				firstText : $g("��һҳ"),
				beforePageText : $g("��ǰҳ"),
				afterPageText :$g( "��{0}ҳ"),
				emptyMsg : $g("û������")
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
					ItmLcBtStore.setBaseParam("ProLocId",Locdr);
					ItmLcBtStore.setBaseParam("ReqLocId",ReqLoc);
					ItmLcBtStore.setBaseParam("QtyFlag",QtyFlag);
					ItmLcBtStore.load({params:{start:0,limit:pagesize}});
				
			}
		}
	});
	
	
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: $g('������'),
   		dataIndex: 'NotUseFlag',
   		width: 45
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
				header : $g("����"),
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('����'),
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g("���"),
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("������ҵ"),
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g('��ⵥλ'),
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g("�ۼ�(��ⵥλ)"),
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("����(��ⵥλ)"),
				dataIndex : 'PuomQty',
				width : 120,
				align : 'right',
				sortable : true,
			}, {
				header : $g("������λ"),
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : $g("�ۼ�(������λ)"),
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
			
				sortable : true
			}, {
				header : $g("����(������λ)"),
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("�Ƽ۵�λ"),
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("�ۼ�(�Ƽ۵�λ)"),
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("����(�Ƽ۵�λ)"),
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'PhcFormDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : $g("��Ʒ��"),
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("����ͨ����"),
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
			//ItmLcBtGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
			row = ItmLcBtGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
					var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
					ItmLcBtGrid.startEditing(0, colIndex);
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
			ItmLcBtStore.setBaseParam("ProLocId",Locdr);
			ItmLcBtStore.setBaseParam("ReqLocId",ReqLoc);
			ItmLcBtStore.load({params:{start:0,limit:pagesize},
			callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning',$g('û���κμ�¼��'));
			 	if(window){window.focus();}
			} else {
				//ItmLcBtGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
				row = ItmLcBtGrid.getView().getRow(0);
				if (row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
						var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
						ItmLcBtGrid.startEditing(0, colIndex);
					}	
				}
			}
		}});
		}
	});
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning',$g('û���κη��ϵļ�¼��'));
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
		url:DictUrl	+ 'drugutil.csp?actiontype=GetDrugBatInfo',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"Inclb",
		fields :  ["Inclb","BatExp", "Manf", "InclbQty", "PurUomDesc", "Sp", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty","RequrstStockQty", "IngrDate", 
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty","BatSp","InclbQtyO","SupplyStockQtyO"],
		baseParams:{
			IncId:'',
			ProLocId:'',
			ReqLocId:'',
			QtyFlag:''
		}
	});

	var ItmBatPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
				emptyMsg : "No results to display",
				prevText : $g("��һҳ"),
				nextText : $g("��һҳ"),
				refreshText : $g("ˢ��"),
				lastText :$g( "���ҳ"),
				firstText : $g("��һҳ"),
				beforePageText : $g("��ǰҳ"),
				afterPageText : $g("��{0}ҳ"),
				emptyMsg :$g( "û������")
			});

	var nm2 = new Ext.grid.RowNumberer();
	//var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
    var sm2 =  new Ext.grid.CellSelectionModel({});
	var ItmLcBtCm = new Ext.grid.ColumnModel([nm2, {
				header : $g("����RowID"),
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����/Ч��"),
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			} ,{
				header : $g("���ο��"),
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true,
				hidden : true
				
			}, {
				header : $g("������ҵ"),
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : $g("�ۼ�"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("���ο��ÿ��"),
				dataIndex : 'AvaQty',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'ReqQty',
				width : 80,
				align : 'right',
				sortable : true,
				MaxLength:30,
				editor: new Ext.form.NumberField({
		            allowBlank:false,
		            selectOnFocus : true,
		            formatType:'FmtSQ',
		            //allowDecimals: false, // ����С����
					allowNegative: true, // ������
		            listeners : {
						specialkey : function(field, e) {
							if(e.getKey()==Ext.EventObject.UP){
								///yunhaibao20150515,��������������������������
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
								var row=cell[0]-1;
								if(row>=0){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.DOWN){
								var rowCount=ItmLcBtGrid.getStore().getCount();
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
								var row=cell[0]+1;
								if(row<rowCount){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.ENTER){
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								returnData();
							}
							
						}
					}

				})
			} ,{
				header : $g("��λ"),
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("������λRowId"),
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("������λ"),
				dataIndex : 'BUomDesc',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : $g("����"),
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("��λ��"),
				dataIndex : 'StkBin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("�������"),
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : $g("ת����"),
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("����ռ�ÿ��"),
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;
	var ItmLcBtGrid = new Ext.grid.EditorGridPanel({
		cm : ItmLcBtCm,
		store : ItmLcBtStore,
		trackMouseOver : true,
		stripeRows : true,
		//sm : sm2,	//new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
		loadMask : true,
		bbar : ItmBatPagingToolbar,
		deferRowRender : false,
		clicksToEdit:1
	});
	// �س��¼�
	/*ItmLcBtGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
				returnData();
		}
	});*/
	// ˫���¼�
	ItmLcBtGrid.on('rowdblclick', function() {
				returnChoiceData();
	});		
	// ���ذ�ť
	var returnBT = new Ext.Toolbar.Button({
		text : $g('����'),
		tooltip : $g('�������'),
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});
			
	/**
	 * ��������
	 */
	function returnData() {
		var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
		if (rowsModified.length==0){
			Msg.info("warning", $g("�������������!"));
		}else{
			flg = true;
			window.close();
		}
	}
	
	    // ��������
    function returnChoiceData() {
	    var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info("warning", $g("û��ѡ����!"));
            return;
        }
        else {
            flg = true;
            window.close();
        }
    }
	


	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : $g('�ر�'),
		tooltip : $g('����ر�'),
		iconCls : 'page_delete',
		handler : function() {
			flg = false;
			window.close();
		}
	});

if(!window){
	var window = new Ext.Window({
			title : $g('���ҿ����������Ϣ'),
			width : 1000,
			height : 600,
			layout : 'border',
			plain : true,
			tbar : [returnBT, '-', closeBT],
			modal : true,
			buttonAlign : 'center',
			autoScroll : true,
			items : [{
				region:'north',
				height:300,
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
		var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
		if(flg){
			var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
			if (rowsModified.length==0){
				var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
		        if (cell == null) {
		            Fn("","")
		        }
		        // ѡ����
		        var row = cell[0];
		        var rowsModified = ItmLcBtGrid.getStore().getAt(row);
				Fn([rowsModified],itmRecord)
			}	
			else {
				Fn(rowsModified,itmRecord)
			}
		}
		else {
			Fn("","")
		}
		
		
		/*
		///�����༭��
		var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
		if (rowsModified.length==0){
			Fn("","")
		}else{
			if (flg){
				///���ؼ�¼
				var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
				Fn(rowsModified,itmRecord)	  //modify��Ҫѭ����,Ӱ���ٶ�
				
			}else{
				
			}
		
		}
		Fn("","")
		*/

	});
}