// /描述: 根据入库单退货
// /编写日期: 2015.07.28
	var IngrtUrl = DictUrl + 'ingdretaction.csp';
	var gUserId = session['LOGON.USERID'];
	GetParam();
	// 供给部门
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		listWidth : 250,
		groupId : session['LOGON.GROUPID']
	});

	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date().add(Date.DAY, - 7)
	});

	var EndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});
	
	var TransStatus = new Ext.form.Checkbox({
		fieldLabel : '包含已退货',
		id : 'TransStatus',
		anchor : '90%',
		width : 120,
		checked : false,
		disabled : false
	});

	var Vendor = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'Vendor',
		anchor : '90%',			
		listWidth : 250
	});
		
	// 查询转移单按钮
	var SearchBT = new Ext.Toolbar.Button({
		id : 'SearchBT',
		text : '查询',
		tooltip : '点击查询入库单',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});

	var ClearBT = new Ext.Toolbar.Button({
		id : 'ClearBT',
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	function clearData() {
		Ext.getCmp('PhaLoc').setDisabled(0);
		Ext.getCmp('Vendor').setValue('');
		Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp('EndDate').setValue(new Date());
		Ext.getCmp('TransStatus').setValue(false);
		MasterGrid.store.removeAll();
		DetailGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	var SaveBT = new Ext.Toolbar.Button({
		id : 'SaveBT',
		text : '保存',
		tooltip : '点击保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			if(DetailGrid.activeEditor!=null){
				DetailGrid.activeEditor.completeEdit();
			}
			save();
		}
	});

	function save() {
		var HVIngrtFlag = false;		//高值转移单标志,缺省false
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		if(selectRecords=='' || selectRecords=='undefined'){
			Msg.info('warning','没有选中的入库单!');
			return;
		}
		var record = selectRecords[0];
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		var ingrid = record.get('IngrId');
		var StkGrpId = record.get('StkGrpId');
		var VendorId = record.get('VendorId');
		var adjChequeFlag = 'N';

		var MainInfo = PhaLoc + '^' + VendorId + '^' + gUserId + '^' + StkGrpId + '^' + adjChequeFlag;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail='';
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var Ingrti = '';
			var Ingri = rowData.get('Ingri');
			var Qty = rowData.get('TrQty');
			if(Qty==0){
				continue;
			}else{
				var AvaQty = rowData.get('AvaQty');
				if(parseFloat(Qty) > parseFloat(AvaQty)){
					Msg.info('warning', '第' + (i + 1) + '行退货量大于可用库存!');
					return false;
				}
			}
			var UomId = rowData.get('TrUomId');
			var BUomId = rowData.get('BUomId');
			if(BUomId==UomId && (Qty!=0 && Qty%1!=0)){
				Msg.info('warning','转移单位是基本单位时数量不可再做拆分!');
				return;
			}
			var Rp = rowData.get('Rp');
			var Sp = rowData.get('Sp');
			var InvAmt = rowData.get('RpAmt');			//使用进价金额
			var RetReason = rowData.get('RetReason');
			if(Ext.isEmpty(RetReason)&&(gParam[8]!="Y")){
				Msg.info('warning', '第' + (i + 1) + '行退货原因为空!');
				return false;
			}
			var HVFlag = rowData.get('HVFlag');
			var HVBarCode = rowData.get('HVBarCode');
			if(HVBarCode!=''){
				if(Qty!=0 && Qty!=1){
					Msg.info('warning','高值材料数量只能为1或0!');
					return;
				}else if(!CheckBarcode(HVBarCode,VendorId,Ingri)){
					return;
				}else{
					HVIngrtFlag = true;
				}
			}
			var invNo = '', invDate = '', sxNo = '';		//此界面暂不做维护
			var str =  Ingrti + '^'+ Ingri + '^' + Qty + '^' + UomId + '^' + Rp
					+ '^' + Sp + '^' + invNo + '^' + invDate + '^' + InvAmt + '^' + sxNo
					+ '^' + RetReason + '^' + HVBarCode;
			if(ListDetail == ''){
				ListDetail = str;
			}else{
				ListDetail = ListDetail + xRowDelim() + str;
			}				
		}
		if(ListDetail == ''){
			Msg.info('warning', '没有需要保存的明细!');
			return false;
		}
		var url = IngrtUrl + '?actiontype=save';
		Ext.Ajax.request({
					url : url,
					params:{ret:'', MainData:MainInfo, Detail:ListDetail},
					method : 'POST',
					waitMsg : '处理中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var Ingrt = jsonData.info;
							Msg.info('success', '保存成功!');
							// 跳转到退货制单界面 //暂时没有区分高值退货菜单
							if(HVIngrtFlag){
								window.location.href='dhcstm.ingdrethv.csp?gIngrtId=' + Ingrt;
							}else{
								window.location.href='dhcstm.ingdret.csp?gIngrtId=' + Ingrt;
							}
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info('error', '加锁失败,不能保存!');
							}else if(ret==-2){
								Msg.info('error', '生成出库单号失败,不能保存!');
							}else if(ret==-1){
								Msg.info('error', '保存出库单失败!');
							}else if(ret==-5){
								Msg.info('error', '保存出库单明细失败!');
							}else {
								Msg.info('error', '部分明细保存不成功：'+ret);
							}
						}
					},
					scope : this
				});
	}

	/**
	 * 检查条码是否可以转移出库
	 */
	function CheckBarcode(Barcode,VendorId,Ingri) {
		var url='dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode;
		var itmResult=ExecuteDBSynAccess(url);
		var itmInfo=Ext.util.JSON.decode(itmResult);
		if(itmInfo.success == 'true'){
			var itmArr=itmInfo.info.split('^');
			var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
			var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
			if(inclb==''){
				Msg.info('warning', Barcode + '高值材料没有相应库存记录,不能制单!');
				return false;
			}else if(lastDetailAudit!='Y'){
				Msg.info('warning', Barcode + '高值材料有未审核的'+lastDetailOperNo+',请核实!');
				return false;
			}else if(type=='T'){
				Msg.info('warning', Barcode + '高值材料已经出库,不可制单!');
				return false;
			}else if(status!='Enable'){
				Msg.info('warning',Barcode + '高值条码处于不可用状态,不可制单!');
				return false;
			}
			var PhaLoc = Ext.getCmp('PhaLoc').getValue();
			var zeroFlag = '0';
			var strPar = PhaLoc + '^' + inciDr + '^' + VendorId + '^' + zeroFlag + '^' + Ingri
					+ '^' + inclb;
			var url = 'dhcstm.ingdretaction.csp?actiontype=selectBatch&strPar='+strPar+'&start=0&limit=1';
			var result=ExecuteDBSynAccess(url);
			var info=Ext.util.JSON.decode(result);
			var inforesults=info.results;
			if(inforesults=='0'){
				Msg.info('warning', Barcode + '条码对应库存为零，不能退货!');
				return;
			}
			return true;
		}else{
			Msg.info('error', Barcode　+ '条码尚未注册!');
			return false;
		}
	}

	/**
	 * 删除选中行物资
	 */
	function deleteDetail() {
		// 判断转移单是否已完成
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info('warning', '没有选中行!');
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		DetailGrid.getStore().remove(record);
		DetailGrid.getView().refresh();
	}

	// 单位
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '单位',
				id : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '单位...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});

	/**
	 * 单位展开事件
	 */
	CTUom.on('expand', function(combo) {
				CTUom.store.removeAll();
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get('IncId');
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	/**
	 * 单位变换事件
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				
				var value = combo.getValue();        //目前选择的单位id
				var BUom = record.get('BUomId');
				var ConFac = record.get('ConFacPur');   //大单位到小单位的转换关系
				var TrUom = record.get('TrUomId');    //目前显示的出库单位
				var Sp = record.get('Sp');
				var Rp = record.get('Rp');
				var InclbQty=record.get('StkQty');
				var DirtyQty=record.get('DirtyQty');
				var AvaQty=record.get('AvaQty');
			
				if (value == null || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set('Sp', Sp/ConFac);
					record.set('Rp', Rp/ConFac);
					record.set('StkQty', InclbQty*ConFac);
					record.set('DirtyQty', DirtyQty*ConFac);
					record.set('AvaQty', AvaQty*ConFac);
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set('Sp', Sp*ConFac);
					record.set('Rp', Rp*ConFac);
					record.set('StkQty', InclbQty/ConFac);
					record.set('DirtyQty', DirtyQty/ConFac);
					record.set('AvaQty', AvaQty/ConFac);
				}
				record.set('TrUomId', combo.getValue());
	});
			
	// 显示入库单数据
	function Query() {
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if (PhaLoc =='' || PhaLoc.length <= 0) {
			Msg.info('warning', '请选择科室!');
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var status = Ext.getCmp('TransStatus').getValue()==true?1:0;
		var Vendor = Ext.getCmp('Vendor').getValue();
		
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+PhaLoc+'^'+status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
					Msg.info('error', '查询错误，请查看日志!');
				}else{
					if(r.length>=1){
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			}
		});
	}
	// 显示入库单明细数据
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	var MasterStore = new Ext.data.JsonStore({
		url : IngrtUrl + '?actiontype=QueryIngr',
		root : 'rows',
		totalProperty : 'results',
		fields : ['IngrId', 'IngrNo', 'RecLoc', 'ReqLoc', 'Vendor', 'VendorId',
			'CreateUser', 'CreateDate','Status','StkGrpId','StkGrpDesc']
	});
	
	var MasterCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'RowId',
			dataIndex : 'IngrId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '入库单号',
			dataIndex : 'IngrNo',
			width : 140,
			align : 'left',
			sortable : true
		}, {
			header : '入库科室',
			dataIndex : 'RecLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '入库日期',
			dataIndex : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : '供应商',
			dataIndex : 'Vendor',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '入库人',
			dataIndex : 'CreateUser',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : '转移状态',
			dataIndex : 'Status',
			width : 80,
			align : 'right',
			sortable : true
			,hidden : true
		}, {
			header : '类组',
			dataIndex : 'StkGrpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}
	]);
	
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	
	var MasterGrid = new Ext.grid.GridPanel({
		region: 'west',
		title: '入库单',
		collapsible: true,
		split: true,
		width: 300,
		minSize: 175,
		maxSize: 400,
		cm : MasterCm,
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true,
			listeners:{
				rowselect:function(sm,rowIndex,rec){
					var IngrId = rec.get('IngrId');
					DetailStore.load({params:{start:0,limit:999,Parref:IngrId}});
				}
			}
		}),
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar]
	});

	var DetailStore = new Ext.data.JsonStore({
		url : IngrtUrl + '?actiontype=QueryIngrDetail',
		root : 'rows',
		totalProperty : 'results',
		fields :['Ingri', 'BatchNo', 'TrUomId','TrUom','ExpDate', 'Inclb', 'TrQty', 'IncId',
			 'IncCode', 'IncDesc', 'Manf','InvAmt', 'Rp','RpAmt', 'Sp', 'SpAmt', 'BUomId',
			 'ConFacPur', 'StkQty', 'DirtyQty','AvaQty','BatExp','HVFlag','HVBarCode'
			]
	});

	/**
	 * 退货原因
	 */
	var RetReason = new Ext.ux.ComboBox({
		id : 'RetReason',
		anchor : '90%',
		store : ReasonForReturnStore,
		valueField : 'RowId',
		displayField : 'Description',
		listeners:{
			specialKey:function(field, e) {
				if(e.getKey() == Ext.EventObject.ENTER){
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					if(cell[0] < DetailGrid.getStore().getCount() - 1){
						var col=GetColIndex(DetailGrid, 'TrQty');
						DetailGrid.startEditing(cell[0] + 1, col);
					}
				}
			}
		}
	});
	
	var DetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : '入库明细id',
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资RowId',
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '批次RowId',
			dataIndex : 'Inclb',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '批号~效期',
			dataIndex : 'BatExp',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : '高值标志',
			dataIndex : 'HVFlag',
			width : 80,
			align : 'center',
			sortable : true,
			hidden : true
		},{
			header : '高值条码',
			dataIndex : 'HVBarCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '批次库存',
			dataIndex : 'StkQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '退货数量',
			dataIndex : 'TrQty',
			width : 80,
			align : 'right',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var col = GetColIndex(DetailGrid, 'RetReason');
							DetailGrid.startEditing(cell[0], col);
						}
					}
				}
			})
		}, {
			header : '单位',
			dataIndex : 'TrUom',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '退货原因',
			dataIndex : 'RetReason',
			width : 100,
			align : 'left',
			editor : new Ext.grid.GridEditor(RetReason),
			renderer : Ext.util.Format.comboRenderer(RetReason)
		}, {
			header : '进价',
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '售价',
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '生产厂商',
			dataIndex : 'Manf',
			width : 140,
			align : 'left',
			sortable : true
		}, {
			header : '占用数量',
			dataIndex : 'DirtyQty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '可用数量',
			dataIndex : 'AvaQty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '进价金额',
			dataIndex : 'RpAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '售价金额',
			dataIndex : 'SpAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '转换率',
			dataIndex : 'ConFacPur',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '基本单位',
			dataIndex : 'BUomId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}
	]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '入库单明细',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.ux.CellSelectionModel({}),
		clicksToEdit : 1,
		listeners : {
			afteredit : function(e){
				if(e.field=='TrQty'){
					var qty = e.value;
					var AvaQty = e.record.get('AvaQty');
					if (qty > AvaQty) {
						Msg.info('warning', '退货数量不能大于可用库存数量!');
						e.record.set('TrQty', e.originalValue);
					}else{
						var RpAmt = accMul(e.record.get('Rp'), qty);
						var SpAmt = accMul(e.record.get('Sp'), qty);
						e.record.set('RpAmt', RpAmt);
						e.record.set('SpAmt', SpAmt);
					}
				}
			},
			rowcontextmenu : rightClickFn
		}
	});
	
	var rightClick = new Ext.menu.Menu({
		id:'rightClickCont',
		items: [
			{
				id: 'mnuDelete',
				handler: deleteDetail,
				text: '删除'
			}
		]
	});
	
	//右键菜单代码关键部分
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY());
	}

	var HisListTab = new Ext.ux.FormPanel({
		title:'退货(依据入库单)',
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px',
			defaults: {width: 220, border:false},
			items:[{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [PhaLoc,Vendor]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [StartDate,EndDate]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [TransStatus]
			}]
		}]
	});

	Ext.onReady(function(){
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterGrid, DetailGrid],
			renderTo : 'mainPanel'
		});
	});