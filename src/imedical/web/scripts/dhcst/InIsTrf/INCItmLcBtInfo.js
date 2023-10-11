/**
 * ����: ���ҿ��������
 * 
 * ����: ���ҿ�������� ��д�ߣ�zhangyong ��д����: 2012.1.11
 * ������:yunhaibao,20151202,�޸Ľ����Լ�����,��������������Ҽ��޸�������
 */
INCItmLcBtInfo = function(InciDr, PhaLoc, PhaLocRQ, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	var ItmLcBtUrl = DictUrl
			+ 'dhcinistrfaction.csp?actiontype=GetDrugInvInfo&IncId='
			+ InciDr + '&ProLocId=' + PhaLoc + '&ReqLocId=' + PhaLocRQ
			+ '&start=' + 0 + '&limit=' + 15;;

	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : ItmLcBtUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["Inclb", "IncRowId", "IncCode", "IncName",
			"BatExp", "Manf", "InclbQty", "InitQty",
			"PurUomDesc", "Sp", "Transfer", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty",
			"RequrstStockQty", "IngrDate", "Sepc", "GeneDesc", "FormDesc",
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty",
			"BatSp","InclbWarnFlag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Inclb",
				fields : fields
			});
	// ���ݼ�
	var ItmLcBtStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
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
				afterPageText : $g("��{0}ҳ"),
				emptyMsg : $g("û������")
			});

	var nm = new Ext.grid.RowNumberer();
	//var sm = new Ext.grid.CheckboxSelectionModel();
    var sm =  new Ext.grid.CellSelectionModel({});
	var ItmLcBtCm = new Ext.grid.ColumnModel([nm, {
				header : $g("����RowID"),
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("ҩƷ���RowId"),
				dataIndex : 'IncRowId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'IncName',
				width : 230,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����/Ч��"),
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : $g("���ο��"),
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("���ο��ÿ��"),
				dataIndex : 'AvaQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("ת������"),
				dataIndex : 'InitQty',
				width : 80,
				align : 'right',
				sortable : true,
				renderer:BiggerRender,
				editor: new Ext.form.NumberField({
		            allowBlank:false,
		            selectOnFocus : true,
		            listeners : {
						specialkey : function(field, e) {
							if(e.getKey()==Ext.EventObject.UP){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=38;} 
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								var row=cell[0]-1;
								if(row>=0){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.DOWN){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=40;}
								var rowCount=ItmLcBtGrid.getStore().getCount();
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								var row=cell[0]+1;
								if(row<rowCount){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.ENTER){
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								returnData();
							}
							
						}
					}

				})
			}, {
				header : $g("������ҵ"),
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("��λRowId"),
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("��λ"),
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("�ۼ�"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',				
				sortable : true
			}, {
				header : $g("�����ۼ�"),
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',				
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'Transfer',
				width : 80,
				align : 'center',
				sortable : true,
				hidden : true
			}, {
				header : $g("��������"),
				dataIndex : 'ReqQty',
				width : 80,
				align : 'right',
				sortable : true,
				hidden : true
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
				hidden : true
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
				sortable : true,
				hidden : true
			}, {
				header : $g("��Ӧ�����"),
				dataIndex : 'SupplyStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("���󷽿��"),
				dataIndex : 'RequrstStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("�������"),
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true,
				hidden : true
			}, {
				header : $g("���"),
				dataIndex : 'Sepc',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����ͨ����"),
				dataIndex : 'GeneDesc',
				width : 120,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����"),
				dataIndex : 'FormDesc',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("ת����"),
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����ռ�ÿ��"),
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("��ʾ����"),
				dataIndex : 'InclbWarnFlag',
				width : 90,
				align : 'right',
				sortable : true,
				hidden:true
			}]);
	ItmLcBtCm.defaultSortable = true;
	function BiggerRender(val){
			return '<span style="font-size:13px;font-weight:bold">'+val+'</span>';

	}
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
			Msg.info("warning", $g("������ת������!"));
		}else{
			var rowslen=0
			var modifylen=rowsModified.length;
			var inclbwarnflag=""
			for (rowslen=0;rowslen<modifylen;rowslen++)
			{
				 inclbwarnflag=rowsModified[rowslen].data["InclbWarnFlag"]
				 var expbatinfo=rowsModified[rowslen].data["BatExp"]
				 if (inclbwarnflag=="1"){
					 if (confirm(expbatinfo+$g("Ϊ����ҩƷ,�Ƿ����?"))){continue;}
					 else{return}
				 }
				 else if (inclbwarnflag=="2"){
					 if (confirm(expbatinfo+$g("Ϊ���β�����,�Ƿ����?"))){continue}
					 else{return}
				 }
			}
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

	var ItmLcBtGrid = new Ext.grid.EditorGridPanel({
				cm : ItmLcBtCm,
				store : ItmLcBtStore,
				trackMouseOver : true,
				region:'center',
				stripeRows : true,
				loadMask : true,
				tbar : [returnBT, '-', closeBT],
				bbar : StatuTabPagingToolbar,
				deferRowRender : false,
				clicksToEdit:1,
				viewConfig:{
			    	getRowClass : function(record,rowIndex,rowParams,store){ 
						var InciWarnFlag=record.get("InclbWarnFlag");
						switch(InciWarnFlag){
							case "1":
								return 'classOrange';
								break;
							case "2":
								return 'classSalmon';
								break;
						}
					}
		        }
			});
	ItmLcBtGrid.on('afteredit',function(e){
		if(e.field=="InitQty"){
			if (e.value==0){
				e.record.dirty=false
				e.record.commit(); 
			}
		}
	})
	// ˫���¼�
	ItmLcBtGrid.on('rowdblclick', function() {
					//��֤�Ƿ�������ڻ�ͣ��
				returnData();
			});
	// �س��¼�
	ItmLcBtGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {

					returnData();
				}
			});

	var IncInfo=new Ext.form.Label({
		id:'IncInfo',
		align:'center',
		cls: 'classImportant'
    })

	var HisItmLcBtTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			height : 50,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			layout : 'fit', 
		    items:[IncInfo] 
		});
	var window = new Ext.Window({
				title : $g("ҩƷ���ο����Ϣ"),
				width : document.body.clientWidth*0.65,
				height : document.body.clientHeight*0.75,
				layout : 'border',
				plain : true,
				modal : true,
				buttonAlign : 'center',
				autoScroll : true,
				items : [HisItmLcBtTab,ItmLcBtGrid]
			});
	window.show();

	window.on('close', function(panel) {
			var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
			if (rowsModified.length==0){
				Fn("")
			}else{
				if (flg){

					Fn(rowsModified)
				}else{
					Fn("")
				}
		
			}

		});
	ItmLcBtGrid.getView().on('refresh',function(Grid){
		 if (ItmLcBtGrid.getStore().getCount()>0)
		 {
			var ItmLcBtRowData = ItmLcBtStore.getAt(0);
			var IncCode = ItmLcBtRowData.get("IncCode"); 
			var IncDesc=ItmLcBtRowData.get("IncName"); 
			var IncSpec=ItmLcBtRowData.get("Sepc"); 
			var IncPuomDesc=ItmLcBtRowData.get("PurUomDesc"); 
			var IncBuomDesc=ItmLcBtRowData.get("BUomDesc"); 
			var IncInfoMain=$g('ҩƷ����:')+IncCode+$g('����ҩƷ����:')+IncDesc;
			var IncInfoOther=$g("���:")+IncSpec+$g("������ⵥλ:")+IncPuomDesc+$g("����������λ:")+IncBuomDesc;
	   	 	var IncInfoStr=IncInfoMain+'������'+IncInfoOther;
	   	 	
		 }
		 else
		 {
			var IncInfoStr=$g("��ҩƷû����Ч������Ϣ!")
		 }
		 Ext.getCmp("IncInfo").setText(IncInfoStr,false);
	})
	ItmLcBtStore.load({
				callback : function(r, options, success) {
					if (success == false) {

					} else {
							var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
							ItmLcBtGrid.startEditing(0, colIndex);
					}
				}
			});
}
