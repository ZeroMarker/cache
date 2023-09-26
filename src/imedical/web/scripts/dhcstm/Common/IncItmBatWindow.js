// /����: ѡ���ʼ���Ӧ���δ���
// /����: ѡ���ʼ���Ӧ����
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.22

/**
 Input:���ʱ���¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G������
 Locdr:����id
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 ReqLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 IntrType : ҵ������(��Ӧ̨��type) 2014-08-31���
 StkCat : ������id 2016-11-29���
 QtyFlagBat:�Ƿ����0�������
 HV:��ֵ��־(Y:����ֵ,N:����ֵ,'':����)
*/
var gIncItmBatWindow = null;
var gRecArr = [];			//��ȡѡ�е�record����
var gInput,gStkGrpRowId, gStkGrpType, gLocdr, gNotUseFlag,
	gQtyFlag, gHospID, gReqLoc, gFn, gIntrType, gStkCat,gQtyFlagBat,gHV;
var gSelColor = "#51AD9D";	//ѡ����Ⱦɫ
IncItmBatWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, ReqLoc, Fn, IntrType, StkCat,QtyFlagBat,HV) {
	Ext.QuickTips.init();
	gInput=Input, gStkGrpRowId=StkGrpRowId, gStkGrpType=StkGrpType, gLocdr=Locdr, gNotUseFlag=NotUseFlag;
	gQtyFlag=QtyFlag, gHospID=HospID, gReqLoc=ReqLoc, gFn=Fn, gIntrType=IntrType, gStkCat=StkCat,gHV=HV;
	if(QtyFlagBat==""||QtyFlagBat==null||QtyFlagBat==undefined){gQtyFlagBat=QtyFlag;}else{gQtyFlagBat=QtyFlagBat;}
	if(gHV==""||gHV==null||gHV==undefined){gHV="";}

	var gInciRecord = null, gInciRowIndex = '';
	
	if(gIncItmBatWindow){
		gIncItmBatWindow.show();
		return;
	}
	var AllowQtyNegative = gIntrType=="A"?true:false;	//�Ƿ�����ҵ������¼�븺ֵ
	gStkCat = typeof(gStkCat)=='undefined'?'':gStkCat;
	
	var PhaOrderStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:DictUrl	+ 'drugutil.csp?actiontype=GetPhaOrderItemForDialog',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"InciDr",
		fields : ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark","GrpId","GrpDesc"],
		listeners : {
			load : function(store,records,options){
				ItmLcBtStore.removeAll();
				if(records.length > 0){
					sm.selectFirstRow();
					PhaOrderGrid.getView().focusRow(0);
					Ext.each(records,function(item,index,allItems){
						ChangeGridBgColor(PhaOrderGrid,index);
					});
				}
			}
		}
	});
	
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect : true,
		checkOnly : false,
		listeners:{
			'rowselect':function(selmod,rowIndex,record){
				if(ItmLcBtGrid.activeEditor != null){
					ItmLcBtGrid.activeEditor.completeEdit();		//���completeEdit,����afteredit,��ֹ����Ϊ0�����
				}
				gInciRowIndex = rowIndex;	//ȫ�ֱ�����¼��ʱrowIndex
				gInciRecord = record;		//ȫ�ֱ�����¼��ʱrecord
				var incid=record.get("InciDr");
				var pagesize=ItmBatPagingToolbar.pageSize;
				ItmLcBtStore.setBaseParam("IncId",incid);
				ItmLcBtStore.setBaseParam("ProLocId",gLocdr);
				ItmLcBtStore.setBaseParam("ReqLocId",gReqLoc);
				ItmLcBtStore.setBaseParam("QtyFlag",gQtyFlagBat);
				ItmLcBtStore.setBaseParam("StkType",App_StkTypeCode);
				ItmLcBtStore.removeAll();
				ItmLcBtStore.load({params:{start:0,limit:pagesize}});
			}
		}
	});
	var nm = new Ext.grid.RowNumberer();
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "����",
				dataIndex : 'InciCode',
				width : 140,
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
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "����(��ⵥλ)",
				dataIndex : 'pRp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "����(��ⵥλ)",
				dataIndex : 'PuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����(������λ)",
				dataIndex : 'bRp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�(������λ)",
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "����(������λ)",
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����(�Ƽ۵�λ)",
				dataIndex : 'BillRp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�(�Ƽ۵�λ)",
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "����(�Ƽ۵�λ)",
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header: '������',
				dataIndex: 'NotUseFlag',
				xtype: 'checkcolumn',
				width: 45
			}]);
	PhaOrderCm.defaultSortable = true;
	
	var PhaOrderToolbar = new Ext.PagingToolbar({
		store : PhaOrderStore,
		pageSize : 10,
		displayInfo : true
	});
	
	var PhaOrderGrid = new Ext.grid.GridPanel({
		id : 'PhaOrderGrid',
		cm : PhaOrderCm,
		store : PhaOrderStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		bbar : PhaOrderToolbar,
		deferRowRender : false,
		listeners :{
			keydown : function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if(ItmLcBtGrid.getStore().getCount()>0){
						ItmLcBtGrid.startEditing(0, gCol);
					}
				}
			}
		}
	});
	
	var ItmLcBtStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:DictUrl	+ 'drugutil.csp?actiontype=GetDrugBatInfo',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"Inclb",
		fields :  ["Inclb","BatExp", "Manf", "InclbQty", "PurUomDesc", "Sp", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty","RequrstStockQty", "IngrDate", 
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty","BatSp","HVFlag","SupplyAvaStockQty",
			{name:"OperQty",defaultValue:''},"RecallFlag", "Vendor", "VendorName","SterilizedBat","SpecDesc"],
		baseParams:{
			IncId:'',
			ProLocId:'',
			ReqLocId:'',
			QtyFlag:'',
			StkType:''
		},
		listeners :{
			load : function(store,records,options){
				Ext.each(records,function(item,index,allItems){
					Ext.each(gRecArr,function(rec,RecIndex,RecAllItems){
						if(rec.get('Inclb')==item.get('Inclb')){
							item.set('OperQty',rec.get('OperQty'));
						}
					});
				});
			}
		}
	});

	var ItmLcBtCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header : "����RowID",
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����~Ч��",
				dataIndex : 'BatExp',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���ο��",
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "���ο��ÿ��",
				dataIndex : 'AvaQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "ҵ������",
				dataIndex : 'OperQty',
				width : 90,
				align : 'right',
				hideable : false,
				editable : true,
				editor : new Ext.grid.GridEditor(
					new Ext.ux.NumberField({
						formatType : 'FmtQTY',
						selectOnFocus : true,
						allowBlank : true,
						allowNegative : AllowQtyNegative,
						listeners : {
							specialkey : function(field,e){
								if (e.getKey() == Ext.EventObject.ALT) {
									ItmLcBtGrid.activeEditor.completeEdit();
									sm.selectRow(gInciRowIndex + 1);
									PhaOrderGrid.getView().focusRow(gInciRowIndex + 1);
								}else if(e.getKey() == Ext.EventObject.ENTER){
									returnData();
								}
							}
						}
					}))
			}, {
				header : "��Ӧ��",
				dataIndex : 'VendorName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�����ۼ�",
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'ReqQty',
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
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��λ��",
				dataIndex : 'StkBin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ�����",
				dataIndex : 'SupplyStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��Ӧ�����ÿ��",
				dataIndex : 'SupplyAvaStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "���󷽿��",
				dataIndex : 'RequrstStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "ת����",
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				hidden : true,
				sortable : true
			}, {
				header : "����ռ�ÿ��",
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "��ֵ��־",
				dataIndex : 'HVFlag',
				width : 60,
				align : 'center',
				sortable : true,
				hidden : true
			},{
				header : "������־",
				dataIndex : 'RecallFlag',
				width : 60,
				align : 'center',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'SterilizedBat',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;
	
	var ItmBatPagingToolbar = new Ext.PagingToolbar({
		store : ItmLcBtStore,
		pageSize : 15,
		displayInfo : true
	});
	
	var ItmLcBtGrid = new Ext.grid.EditorGridPanel({
		id : 'ItmLcBtGrid',
		title : '���� -- Alt�����ؿ�����б�',
		cm : ItmLcBtCm,
		store : ItmLcBtStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.ux.CellSelectionModel(),
		loadMask : true,
		bbar : ItmBatPagingToolbar,
		deferRowRender : false,
		clicksToEdit : 1,
		listeners : {
			keydown : function(e) {
				if (e.getKey() == Ext.EventObject.ALT) {
					sm.selectRow(gInciRowIndex + 1);
					PhaOrderGrid.getView().focusRow(gInciRowIndex + 1);
				}
			},
			afterrender : function(grid){
				gCol = GetColIndex(grid,'OperQty');
			},
			afteredit : function(e){
				if(e.field=='OperQty'){
					if(gIntrType=='A'){
						if(accAdd(e.value,e.record.get('AvaQty'))<0){
							//��������¼�븺ֵ, ��ӿ���
							Msg.info("warning","��������Ϊ����ʱ���ܳ������ο��ÿ��!");
							e.record.set('OperQty',e.originalValue);
							return;
						}
					}else if(gIntrType!="G" && e.value>e.record.get('AvaQty')){	//������ⲻ��������
						Msg.info("warning","�������ɴ������ο�������");
						e.record.set('OperQty',e.originalValue);
						return;
					}
					var inclb = e.record.get('Inclb');
					var InclbExistFlag = false;
					Ext.each(gRecArr,function(item,index,allItems){
						if(item.get('Inclb')==inclb){
							InclbExistFlag = true;
							if(e.value!="" && parseFloat(e.value)!=0){
								item.set('OperQty',e.value);
							}else{
								gRecArr.remove(item);
							}
							return false;
						}
					});
					if(!InclbExistFlag){
						Ext.applyIf(e.record.data,gInciRecord.data);
						gRecArr.push(e.record);
					}
					ChangeGridBgColor(PhaOrderGrid,gInciRowIndex);
				}
			},
			beforeedit:function(e){
				if(e.record.get('RecallFlag')=="Y")
				{
					Msg.info("warning","�������� ������ʹ��!");
					return false;
				}
			},
			rowdblclick : function(){
				returnData();
			}
		}
	});
	
	function ChangeGridBgColor(grid, rowIndex){
		var InciExist = false;
		var InciId = grid.getStore().getAt(rowIndex).get('InciDr');
		Ext.each(gRecArr,function(rec,RecIndex,RecAllItems){
			if(rec.get('InciDr') == InciId){
				SetGridBgColor(grid,rowIndex,gSelColor);
				InciExist = true;
				return false;		//ֹͣ����
			}
		});
		if(!InciExist){
			SetGridBgColor(grid,rowIndex,'white');
		}
	}
	
	// ���ذ�ť
	var returnBT = {
		xtype : 'uxbutton',
		key : 'S',
		text : '������������',
		tooltip : '�������',
		iconCls : 'page_goto',
		height : 30,
		width : 70,
		handler : function() {
			returnData();
		}
	};
			
	/**
	 * ��������
	 */
	function returnData() {
		if(ItmLcBtGrid.activeEditor != null){
			ItmLcBtGrid.activeEditor.completeEdit();
		}
		var RecArrLen = gRecArr.length;
		if (RecArrLen == 0) {
			Msg.info("warning", "��ѡ�����Σ�����ҵ��������");
		}else{
			gFn(gRecArr);
			window.hide();
		}
	}
	
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����ر�',
		iconCls : 'page_delete',
		height : 30,
		width : 70,
		handler : function() {
			window.hide();		//keyMap����֮ǰ,�ݲ�ʹ��hide
		}
	});
	
	var window = new Ext.Window({
		title : '���ҿ����������Ϣ',
		width : 900,
		height : 600,
		layout : 'border',
		plain : true,
		tbar : [returnBT, '-', closeBT],
		modal : true,
		buttonAlign : 'center',
		closeAction : 'hide',	//keyMap����֮ǰ,�ݲ�ʹ��close
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
		}],
		listeners:{
			show:function(win){
				gRecArr = [];
				gIncItmBatWindow = window;
				RefreshGrid();
			},
			hide : function(){
				PhaOrderStore.removeAll();
				ItmLcBtStore.removeAll();
			},
			close:function(){
				gIncItmBatWindow = null;
			}
		}
	});
	
	function RefreshGrid(){
		PhaOrderStore.setBaseParam('Input', gInput);
		PhaOrderStore.setBaseParam('StkGrpRowId', gStkGrpRowId);
		PhaOrderStore.setBaseParam('StkGrpType', gStkGrpType);
		PhaOrderStore.setBaseParam('Locdr', gLocdr);
		PhaOrderStore.setBaseParam('NotUseFlag', gNotUseFlag);
		PhaOrderStore.setBaseParam('QtyFlag', gQtyFlag);
		PhaOrderStore.setBaseParam('HospID', gHospID);
		PhaOrderStore.setBaseParam('StkCat', gStkCat);
		PhaOrderStore.setBaseParam('toLoc', gReqLoc);
		PhaOrderStore.setBaseParam('HV', gHV);
		PhaOrderStore.load({
			params : {start:0,limit:PhaOrderToolbar.pageSize},
			callback : function(r, options, success) {
				if (success == false) {
					Msg.info('warning','û���κη��ϵļ�¼��');
					if(window){window.hide();}
				}
			}
		});
	}
	
	window.show();
}

///���������ȡ������Ϣ������������Ϣ
// /����: ���������ȡ������Ϣ������������Ϣ
// /����: ѡ���ʼ���Ӧ����
// /��д�ߡGzhangxiao
// /��д����: 2013.12.05

/**
 Input:����
 StkGrpRowId�G����id
 StkGrpType�G�������͡AG�G����
 Locdr:����id
 NotUseFlag�G�����ñ�־
 QtyFlag�G�Ƿ����0�����Ŀ
 HospID�GҽԺid
 ReqLoc:�������id(�������idΪ��ʱ�A������ҿ����ʾΪ��)
 Fn�G�ص�����
 */
IncItmBatByBarcodeWindow =function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, ReqLoc,Fn,IntrType) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;
	// �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		//Input = Input.substring(0,Input.indexOf("*"));
	}
   var AllowQtyNegative = IntrType=="A"?true:false;	//�Ƿ�����ҵ������¼�븺ֵ
	/*���ʴ���------------------------------*/
	var PhaOrderUrl = 'dhcstm.drugutil.csp?actiontype=GetPhaOrderItemByBarcode&Input='
			+ Input + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciItem",
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
				displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼'
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
					ItmLcBtStore.setBaseParam("StkType",App_StkTypeCode);
					ItmLcBtStore.load({params:{start:0,limit:pagesize}});
				
			}
		}
	});
	
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
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
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "����(��ⵥλ)",
				dataIndex : 'PuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(������λ)",
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
			
				sortable : true
			}, {
				header : "����(������λ)",
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(�Ƽ۵�λ)",
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "����(�Ƽ۵�λ)",
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
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
				header : "ͨ����",
				dataIndex : 'GeneName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header: '������',
				dataIndex: 'NotUseFlag',
				xtype: 'checkcolumn',
				width: 45
			}]);
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
				}	
			}
		}
	}); 
/*
	// ˫���¼�
	PhaOrderGrid.on('rowclick', function(grid,rowindex,e) {
		if(rowindex>0){
			var record=PhaOrderGrid.getStore().getAt(rowindex);
			var incid=record.get("InciDr");
			var pagesize=StatuTabPagingToolbar.pageSize;
			ItmLcBtStore.setBaseParam("IncId",incid);
			ItmLcBtStore.setBaseParam("ProLocId",Locdr);
			ItmLcBtStore.setBaseParam("ReqLocId",ReqLoc);
			ItmLcBtStore.load({params:{start:0,limit:pagesize}});
		}
	}); */
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning','û���κη��ϵļ�¼�I');
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
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty","BatSp","HVFlag",
			{name:"OperQty",defaultValue:''},"RecallFlag", "Vendor", "VendorName"],
		baseParams:{
			IncId:'',
			ProLocId:'',
			ReqLocId:'',
			QtyFlag:'',
			StkType:''
		}
	});

	var ItmBatPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '��ǰ��¼ {0} -- {1} ��, �� {2} ����¼'
			});

	var nm2 = new Ext.grid.RowNumberer();
	var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});

	var ItmLcBtCm = new Ext.grid.ColumnModel([nm2, sm2, {
				header : "����RowID",
				dataIndex : 'Inclb',
				width : 100,
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
				header : "���ο��",
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�����ۼ�",
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'VendorName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'ReqQty',
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
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "��λ��",
				dataIndex : 'StkBin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ�����",
				dataIndex : 'SupplyStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "���󷽿��",
				dataIndex : 'RequrstStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "ת����",
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����ռ�ÿ��",
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "���ο��ÿ��",
				dataIndex : 'AvaQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "��ֵ��־",
				dataIndex : 'HVFlag',
				width : 60,
				align : 'center',
				sortable : true,
				hidden : true
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
			Msg.info("warning", "��ѡ��һ��������Ϣ�I");
		}else if(selectRows.length>1){
			Msg.info("warning", "ֻ��ѡ��һ��������Ϣ�I");
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
			width : 700,
			height : 600,
			layout : 'border',
			plain : true,
			tbar : [returnBT, '-', closeBT],
			modal : true,
			buttonAlign : 'center',
			autoScroll : true,
			items : [{
				region:'north',
				height:350,
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