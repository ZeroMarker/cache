// /����: ������ⵥ�˻�
// /��д����: 2015.07.28
	var IngrtUrl = DictUrl + 'ingdretaction.csp';
	var gUserId = session['LOGON.USERID'];
	GetParam();
	// ��������
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		listWidth : 250,
		groupId : session['LOGON.GROUPID']
	});

	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date().add(Date.DAY, - 7)
	});

	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});
	
	var TransStatus = new Ext.form.Checkbox({
		fieldLabel : '�������˻�',
		id : 'TransStatus',
		anchor : '90%',
		width : 120,
		checked : false,
		disabled : false
	});

	var Vendor = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'Vendor',
		anchor : '90%',			
		listWidth : 250
	});
		
	// ��ѯת�Ƶ���ť
	var SearchBT = new Ext.Toolbar.Button({
		id : 'SearchBT',
		text : '��ѯ',
		tooltip : '�����ѯ��ⵥ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});

	var ClearBT = new Ext.Toolbar.Button({
		id : 'ClearBT',
		text : '���',
		tooltip : '������',
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
		text : '����',
		tooltip : '�������',
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
		var HVIngrtFlag = false;		//��ֵת�Ƶ���־,ȱʡfalse
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		if(selectRecords=='' || selectRecords=='undefined'){
			Msg.info('warning','û��ѡ�е���ⵥ!');
			return;
		}
		var record = selectRecords[0];
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		var ingrid = record.get('IngrId');
		var StkGrpId = record.get('StkGrpId');
		var VendorId = record.get('VendorId');
		var adjChequeFlag = 'N';

		var MainInfo = PhaLoc + '^' + VendorId + '^' + gUserId + '^' + StkGrpId + '^' + adjChequeFlag;
		//��ϸid^����id^����^��λ^������ϸid^��ע
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
					Msg.info('warning', '��' + (i + 1) + '���˻������ڿ��ÿ��!');
					return false;
				}
			}
			var UomId = rowData.get('TrUomId');
			var BUomId = rowData.get('BUomId');
			if(BUomId==UomId && (Qty!=0 && Qty%1!=0)){
				Msg.info('warning','ת�Ƶ�λ�ǻ�����λʱ���������������!');
				return;
			}
			var Rp = rowData.get('Rp');
			var Sp = rowData.get('Sp');
			var InvAmt = rowData.get('RpAmt');			//ʹ�ý��۽��
			var RetReason = rowData.get('RetReason');
			if(Ext.isEmpty(RetReason)&&(gParam[8]!="Y")){
				Msg.info('warning', '��' + (i + 1) + '���˻�ԭ��Ϊ��!');
				return false;
			}
			var HVFlag = rowData.get('HVFlag');
			var HVBarCode = rowData.get('HVBarCode');
			if(HVBarCode!=''){
				if(Qty!=0 && Qty!=1){
					Msg.info('warning','��ֵ��������ֻ��Ϊ1��0!');
					return;
				}else if(!CheckBarcode(HVBarCode,VendorId,Ingri)){
					return;
				}else{
					HVIngrtFlag = true;
				}
			}
			var invNo = '', invDate = '', sxNo = '';		//�˽����ݲ���ά��
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
			Msg.info('warning', 'û����Ҫ�������ϸ!');
			return false;
		}
		var url = IngrtUrl + '?actiontype=save';
		Ext.Ajax.request({
					url : url,
					params:{ret:'', MainData:MainInfo, Detail:ListDetail},
					method : 'POST',
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							var Ingrt = jsonData.info;
							Msg.info('success', '����ɹ�!');
							// ��ת���˻��Ƶ����� //��ʱû�����ָ�ֵ�˻��˵�
							if(HVIngrtFlag){
								window.location.href='dhcstm.ingdrethv.csp?gIngrtId=' + Ingrt;
							}else{
								window.location.href='dhcstm.ingdret.csp?gIngrtId=' + Ingrt;
							}
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info('error', '����ʧ��,���ܱ���!');
							}else if(ret==-2){
								Msg.info('error', '���ɳ��ⵥ��ʧ��,���ܱ���!');
							}else if(ret==-1){
								Msg.info('error', '������ⵥʧ��!');
							}else if(ret==-5){
								Msg.info('error', '������ⵥ��ϸʧ��!');
							}else {
								Msg.info('error', '������ϸ���治�ɹ���'+ret);
							}
						}
					},
					scope : this
				});
	}

	/**
	 * ��������Ƿ����ת�Ƴ���
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
				Msg.info('warning', Barcode + '��ֵ����û����Ӧ����¼,�����Ƶ�!');
				return false;
			}else if(lastDetailAudit!='Y'){
				Msg.info('warning', Barcode + '��ֵ������δ��˵�'+lastDetailOperNo+',���ʵ!');
				return false;
			}else if(type=='T'){
				Msg.info('warning', Barcode + '��ֵ�����Ѿ�����,�����Ƶ�!');
				return false;
			}else if(status!='Enable'){
				Msg.info('warning',Barcode + '��ֵ���봦�ڲ�����״̬,�����Ƶ�!');
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
				Msg.info('warning', Barcode + '�����Ӧ���Ϊ�㣬�����˻�!');
				return;
			}
			return true;
		}else{
			Msg.info('error', Barcode��+ '������δע��!');
			return false;
		}
	}

	/**
	 * ɾ��ѡ��������
	 */
	function deleteDetail() {
		// �ж�ת�Ƶ��Ƿ������
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info('warning', 'û��ѡ����!');
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		DetailGrid.getStore().remove(record);
		DetailGrid.getView().refresh();
	}

	// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '��λ...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});

	/**
	 * ��λչ���¼�
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
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				
				var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
				var BUom = record.get('BUomId');
				var ConFac = record.get('ConFacPur');   //��λ��С��λ��ת����ϵ
				var TrUom = record.get('TrUomId');    //Ŀǰ��ʾ�ĳ��ⵥλ
				var Sp = record.get('Sp');
				var Rp = record.get('Rp');
				var InclbQty=record.get('StkQty');
				var DirtyQty=record.get('DirtyQty');
				var AvaQty=record.get('AvaQty');
			
				if (value == null || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set('Sp', Sp/ConFac);
					record.set('Rp', Rp/ConFac);
					record.set('StkQty', InclbQty*ConFac);
					record.set('DirtyQty', DirtyQty*ConFac);
					record.set('AvaQty', AvaQty*ConFac);
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set('Sp', Sp*ConFac);
					record.set('Rp', Rp*ConFac);
					record.set('StkQty', InclbQty/ConFac);
					record.set('DirtyQty', DirtyQty/ConFac);
					record.set('AvaQty', AvaQty/ConFac);
				}
				record.set('TrUomId', combo.getValue());
	});
			
	// ��ʾ��ⵥ����
	function Query() {
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if (PhaLoc =='' || PhaLoc.length <= 0) {
			Msg.info('warning', '��ѡ�����!');
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
					Msg.info('error', '��ѯ������鿴��־!');
				}else{
					if(r.length>=1){
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			}
		});
	}
	// ��ʾ��ⵥ��ϸ����
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
			header : '��ⵥ��',
			dataIndex : 'IngrNo',
			width : 140,
			align : 'left',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'RecLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : '��Ӧ��',
			dataIndex : 'Vendor',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'CreateUser',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : 'ת��״̬',
			dataIndex : 'Status',
			width : 80,
			align : 'right',
			sortable : true
			,hidden : true
		}, {
			header : '����',
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
		title: '��ⵥ',
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
	 * �˻�ԭ��
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
			header : '�����ϸid',
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '����RowId',
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '����RowId',
			dataIndex : 'Inclb',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '����~Ч��',
			dataIndex : 'BatExp',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : '��ֵ��־',
			dataIndex : 'HVFlag',
			width : 80,
			align : 'center',
			sortable : true,
			hidden : true
		},{
			header : '��ֵ����',
			dataIndex : 'HVBarCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '���ο��',
			dataIndex : 'StkQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '�˻�����',
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
			header : '��λ',
			dataIndex : 'TrUom',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '�˻�ԭ��',
			dataIndex : 'RetReason',
			width : 100,
			align : 'left',
			editor : new Ext.grid.GridEditor(RetReason),
			renderer : Ext.util.Format.comboRenderer(RetReason)
		}, {
			header : '����',
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '�ۼ�',
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'Manf',
			width : 140,
			align : 'left',
			sortable : true
		}, {
			header : 'ռ������',
			dataIndex : 'DirtyQty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'AvaQty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '���۽��',
			dataIndex : 'RpAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '�ۼ۽��',
			dataIndex : 'SpAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'ConFacPur',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '������λ',
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
		title : '��ⵥ��ϸ',
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
						Msg.info('warning', '�˻��������ܴ��ڿ��ÿ������!');
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
				text: 'ɾ��'
			}
		]
	});
	
	//�Ҽ��˵�����ؼ�����
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY());
	}

	var HisListTab = new Ext.ux.FormPanel({
		title:'�˻�(������ⵥ)',
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',
			xtype:'fieldset',
			title:'��ѯ����',
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