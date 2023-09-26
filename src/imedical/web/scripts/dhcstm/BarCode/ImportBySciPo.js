// /名称: 订单
function ImportBySciPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];

	// 入库单号
	var SxNo = new Ext.form.TextField({
		fieldLabel : '随行条码',
		id : 'SxNo',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					PoQuery();
				}
			}
		}
	});

	var SCIPoReqLoc = new Ext.ux.LocComboBox({
		fieldLabel : '申购科室',
		id : 'SCIPoReqLoc',
		emptyText : '申购科室...',
		defaultLoc : {},
		disabled : true
	});

	var SCIPoNo = new Ext.form.TextField({
		fieldLabel : '订单号',
		readOnly:true,
		id : 'SCIPoNo',
		anchor : '90%'
	});

	var SCIPoVendor = new Ext.ux.VendorComboBox({
		id : 'SCIPoVendor',
		fieldLabel : '供应商',
		disabled : true
	});
	var SCIPoDate = new Ext.form.TextField({
		fieldLabel : '订单日期',
		readOnly:true,
		id : 'SCIPoDate',
		anchor : '90%'
	});
	// 查询订单按钮
	var PoSearchBT = new Ext.ux.Button({
				id : "PoSearchBT",
				text : '查询',
				tooltip : '点击查询订单',
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// 清空按钮
	var PoClearBT = new Ext.ux.Button({
				id : "PoClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					PoclearData();
				}
			});
	/**
	 * 清空方法
	 */
	function PoclearData() {
		SciPoDetailGrid.store.removeAll();
		SciPoDetailGrid.getView().refresh();
		clearPanel(PoHisListTab);
	}

	/**
	 * 关闭方法
	 */
	var PoDeleteBT = new Ext.Toolbar.Button({
				id : "PoDeleteBT",
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					//var flg = false;
					Powin.close();
				}
			});
	// 保存按钮
	var PoSaveBT = new Ext.ux.Button({
				id : "PoSaveBT",
				text : '导入',
				tooltip : '点击导入',
				iconCls : 'page_save',
				handler : function() {
					if(SciPoDetailGrid.activeEditor != null){
						SciPoDetailGrid.activeEditor.completeEdit();
					}
					if(PoCheckDataBeforeSave()==true){
						Posave();
					}
				}
			});

	/**
	 * 保存入库单前数据检查
	 */
	function PoCheckDataBeforeSave() {
		// 1.判断入库物资是否为空
		var rowCount = SciPoDetailGrid.getStore().getCount();
		if (rowCount <= 0) {
			Msg.info("warning", "无明细!");
			return false;
		}
		return true;
	}

	/**
	 * 保存入库单
	function Posave() {
		var selectRecords = SciPoDetailGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(selectRecords)){
			Msg.info('warning', '请选择需要导入的数据!');
			return false;
		}
		var venid=arrinfo[1]
		var vendesc=arrinfo[2]
		addComboData(Ext.getCmp("ImpVendor").getStore(),venid,vendesc);
		Ext.getCmp("ImpVendor").setValue(venid);
		var phaloc = Ext.getCmp("PhaLoc").getValue();
		var SxNo = Ext.getCmp("SxNo").getValue();
		Fn(selectRecords,phaloc,SxNo);
		Powin.close()
	}*/
	/**
	 * 导入随行单并且保存
	 */
	function Posave() {
		var selectRecords = SciPoDetailGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(selectRecords)){
			Msg.info('warning', '请选择需要导入的数据!');
			return false;
		}
		var maindatalist=gUserId+"^"+gLocId;
		var detaildatalist="";
		var vendorid=Ext.getCmp("SCIPoVendor").getValue();
		var SxNo = Ext.getCmp("SxNo").getValue();
		for (j=0;j<selectRecords.length;j++)
		{
			//s data=InPoI+"^"+IncId+"^"+BarCode+"^"+Qty+"^"+BatchNo+"^"+Expdate+"^"+SpecDesc+"^"+CertNo+"^"+CertExpDate+"^"+Rp+"^"+ManfId+"^"+VendorId+"^"+OrderDetailSubId;
			var record=selectRecords[j];
			var Poid=record.get("PoItmId");
			var inci=record.get("IncId");
			var barcode=record.get("BarCode");
			var qty=record.get("AvaBarcodeQty");
			var batchno=record.get("BatNo");
			var expdate=Ext.util.Format.date(record.get("ExpDate"),ARG_DATEFORMAT);
			var specdesc=record.get("SpecDesc");
			var certno=record.get("CerNo");
			var certexpdate=Ext.util.Format.date(record.get("CerExpDate"),ARG_DATEFORMAT);
			var rp=record.get("Rp");
			var manfid=record.get("ManfId");
			var orddetailsubid=record.get("OrderDetailSubId");
			var OriginalCode = record.get('OriginalCode');
			var data=Poid+"^"+inci+"^"+barcode+"^"+qty+"^"+batchno
				+"^"+expdate+"^"+specdesc+"^"+certno+"^"+certexpdate+"^"+rp
				+"^"+manfid+"^"+vendorid+"^"+orddetailsubid+"^"+SxNo+"^"+OriginalCode;
			if (detaildatalist==""){
				detaildatalist=data;
			}else{
				detaildatalist=detaildatalist+RowDelim+data;
			}
		}
		if(detaildatalist==""){
				Msg.info("warning","没有需要导入的数据!");
				return false;
		}
		var mask=ShowLoadMask(Powin.body, "正在导入数据...");
		var url = "dhcstm.barcodeaction.csp?actiontype=SaveBySciPo";
		Ext.Ajax.timeout=240000;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{MainInfo: maindatalist,ListDetail: detaildatalist},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					var datetimeinfo = jsonData.info;
					var SCIPoVendorId=Ext.getCmp("SCIPoVendor").getValue();
					var SCIPoVendorDesc=Ext.getCmp("SCIPoVendor").getRawValue();
					Powin.close();
					Fn(datetimeinfo,SCIPoVendorId,SCIPoVendorDesc);
				} else {
					var ret=jsonData.info;
					Msg.info("error", "导入高值数据失败!"+ret);
				}
				mask.hide();
			},
			scope : this
		});
	}
	// 显示订单数据
	function PoQuery() {
		var SxNo = Ext.getCmp("SxNo").getValue();
		var HVFlag = 'Y';		//仅获取高值数据
		var mask = ShowLoadMask(Powin.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: 'dhcstm.sciaction.csp?actiontype=getOrderDetail',
			params: {SxNo : SxNo, HVFlag : HVFlag},
			waitMsg: '处理中...',
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if(!Ext.isEmpty(jsonData)){
					if(!Ext.isEmpty(jsonData['Main']) && !Ext.isEmpty(jsonData['Detail'])){
						if(jsonData['Detail']['results'] > 0){
							PoHisListTab.getForm().setValues(jsonData['Main']);
							SciPoDetailGrid.getStore().loadData(jsonData['Detail']);
						}else{
							Msg.info('warning', '未找到符合的单据明细,请确认是否高值订单!');
						}
					}else{
						Msg.info('warning', '该单据已处理!');
					}
				}else{
					Msg.info("warning", "未找到符合的单据!");
				}
			},
			scope: this
		});
	}
	// 访问路径
	var DetailUrl =DictUrl+
		'sciaction.csp?actiontype=getOrderDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:'ExpDate',type:'date',dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo",
			 {name:'CerExpDate',type:'date',dateFormat:DateFormat},
			 "HighValueFlag","BarCode","OrderDetailSubId","OriginalCode"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				fields : fields
			});
	// 数据集
	var SciPoDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				pruneModifiedRecords:true
			});
	var sm2=new Ext.grid.CheckboxSelectionModel({
			listeners : {
				beforerowselect :function(sm,rowIndex,keepExisting ,record  ) {
					var hvflag=record.get("HighValueFlag")
					if (hvflag!='Y'){Msg.info("warning","请选择高值材料!");return false}
				}
			}
	})
	var nm = new Ext.grid.RowNumberer();
	var SciPoDetailCm = new Ext.grid.ColumnModel([nm,sm2,{
				header : "订单明细id",
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资RowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : '规格',
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '具体规格',
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '高值标志',
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'AvaBarcodeQty',
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
									Msg.info("warning", "数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "数量不能小于或等于0!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "条码",
				dataIndex : 'BarCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "出厂自带条码",
				dataIndex : 'OriginalCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批号",
				dataIndex : 'BatNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "效期",
				dataIndex : 'ExpDate',
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			},{
				header : "订购数量",
				dataIndex : 'PurQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "已入库数量",
				dataIndex : 'ImpQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "已生成数量",
				dataIndex : 'BarcodeQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "注册证号码",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "注册证效期",
				dataIndex : 'CerExpDate',
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				width : 80,
				align : 'left',
				sortable : true
			}]);

	var SciPoDetailGrid = new Ext.ux.EditorGridPanel({
				id:'SciPoDetailGrid',
				region: 'center',
				title: '订单明细',
				cm : SciPoDetailCm,
				store : SciPoDetailStore,
				sm:sm2,
				clicksToEdit:1
			});
	var PoHisListTab = new Ext.ux.FormPanel({
		region: 'north',
		tbar : [PoSearchBT,'-',PoClearBT, '-',PoSaveBT,'-',PoDeleteBT],
		layout: 'column',
		items:[{
			columnWidth: 0.3,
			layout: 'column',
			xtype:'fieldset',
			title:'查询条件',
			defaults: {xtype: 'fieldset', border:false},
			items:[{
				columnWidth: 1,
				items: [SxNo]
			}]
		},{
			columnWidth: 0.7,
			layout: 'column',
			xtype:'fieldset',
			title:'订单信息',
			defaults: {xtype: 'fieldset', border:false},
			items:[{
				columnWidth: 0.5,
				items: [SCIPoNo,SCIPoVendor]
			},{
				columnWidth: 0.5,
				items: [SCIPoReqLoc,SCIPoDate]
			}]
		}]
	});

	// 页面布局
	var Powin = new Ext.ux.Window({
				title:'条码打印-依据云平台订单条码',
				width : gWinWidth,
				height : gWinHeight,
				layout : 'border',
				items : [PoHisListTab,SciPoDetailGrid]
			});
	//页面加载完成后自动检索订单
	Powin.show()
	SxNo.focus(true,100)

}