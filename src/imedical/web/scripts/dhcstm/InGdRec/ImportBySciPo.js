// /名称: 订单
function ImportBySciPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var SCIPoLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'SCIPoLoc',
		emptyText : '科室...',
		groupId : gGroupId,
		disabled : true
	});
	// 入库单号
	var SxNo = new Ext.form.TextField({
		fieldLabel : '随行条码',
		id : 'SxNo',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.getCmp("SxNo").setValue(GetRealSynNo( Ext.getCmp("SxNo").getValue()));
					PoQuery();
				}
			}
		}
	});
	/*
* 解析随行单号
**/
function GetRealSynNo(syno){
    
    if(syno.indexOf("{")==-1){
        return syno;
    }else{
        var len=syno.length
        var ffa=syno.substring(len-2,len);
        var tmp=eval('('+syno+')');
        
        return tmp.text
    }
    
}
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
		id : 'SCIPoDate',
		readOnly : true,
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
		
	}
	/**
	 * 关闭方法
	 */
	var PocloseBT = new Ext.Toolbar.Button({
				id : "PocloseBT",
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
	 */
	function Posave() {
		var Ingr = '';
		var VenId =Ext.getCmp("SCIPoVendor").getValue();
		var Completed = 'N';
		var LocId = Ext.getCmp("SCIPoLoc").getValue();
		var CreateUser = gUserId;
		var ExchangeFlag ='N';
		var PresentFlag = 'N';
		var IngrTypeId = "";    //正常入库(2014-01-27:传参改为空,类中处理)
		var PurUserId ="";
		var StkGrpId = "";
		var PoId="";  //订单id
		var ReqLoc=Ext.getCmp("SCIPoReqLoc").getValue();  //申购科室
		var SxNo = Ext.getCmp("SxNo").getValue();  //随行单号
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
				+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+PoId+"^^^"+ReqLoc;
		var ListDetail="";
		var rowCount = SciPoDetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = SciPoDetailStore.getAt(i);
			var Ingri='';
			var IncId = rowData.get("IncId");
			var BatchNo = rowData.get("BatNo");
			var ExpDate = Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("PurUomId");
			//var RecQty = rowData.get("AvaQty");
			var RecQty = rowData.get("AvaBarcodeQty"); 
			var Rp = rowData.get("Rp");
			var Sp = rowData.get("Sp");
			var NewSp = Sp;
			var InvNo ='';
			var InvDate ='';
			var PoItmId=rowData.get("PoItmId");
			var OrderDetailSubId=rowData.get("OrderDetailSubId");
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
					+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
					+ "^" + InvNo + "^" + InvDate+"^"+PoItmId+"^^"
					+ "^^^^^"
					+ "^^^^"+OrderDetailSubId + "^"
					+ "^" + Sp;
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : {Ingr:Ingr,MainInfo:MainInfo,ListDetail:ListDetail},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var IngrRowid = jsonData.info;
							Msg.info("success", "保存成功!");
							// 7.显示入库单数据
							// 跳转到入库制单界面
							Fn(IngrRowid);
							Powin.close();
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "加锁失败,不能保存!");
							}else if(ret==-2){
								Msg.info("error", "生成入库单号失败,不能保存!");
							}else if(ret==-3){
								Msg.info("error", "保存入库单失败!");
							}else if(ret==-4){
								Msg.info("error", "未找到需更新的入库单,不能保存!");
							}else if(ret==-5){
								Msg.info("error", "保存入库单明细失败!");
							}else {
								Msg.info("error", "部分明细保存不成功："+ret);
							}
						}
					},
					scope : this
				});
	}
	// 显示订单数据
	function PoQuery() {
		var SxNo = Ext.getCmp("SxNo").getValue();
		var HVFlag = 'N';
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
							Msg.info('warning', '未找到符合的单据明细,请确认是否低值订单!');
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
			 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo","CerExpDate","HighValueFlag","BarCode","OrderDetailSubId"];
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
					if (hvflag=='Y'){Msg.info("warning","高值材料请去高值注册界面导入订单!");return false}
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
			},{
				header : "注册证号码",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "注册证效期",
				dataIndex : 'CerExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "条码",
				dataIndex : 'BarCode',
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
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "生成日期",
				dataIndex : 'BarCode',
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
		labelWidth : 60,
		tbar : [PoSearchBT,'-',PoClearBT, '-',PoSaveBT, '-',PocloseBT],
		layout: 'column',
		items:[{
				columnWidth: 0.3,
				xtype:'fieldset',
				style : 'padding:5px 0px 0px 5px',
				title:'查询条件',
				items: [SxNo]
			},{
				columnWidth: 0.7,
				layout: 'column',
				xtype:'fieldset',
				style : 'padding:5px 0px 0px 5px;margin:0px 0px 0px 5px;',
				title:'订单信息',
				defaults: {layout : 'form'},
				items:[{
					columnWidth: 0.33,
					items: [SCIPoLoc]
				},{
					columnWidth: 0.33,
					items: [SCIPoNo,SCIPoVendor]
				},{
					columnWidth: 0.33,
					items: [SCIPoReqLoc,SCIPoDate]
				}]
			}]
	});

	// 页面布局
	var Powin = new Ext.Window({
				title : '云平台订单导入',
				modal : true,
				width : gWinWidth,
				height : gWinHeight * 0.9,
				layout : 'border',
				items : [PoHisListTab,SciPoDetailGrid]
			});
	//页面加载完成后自动检索订单
	Powin.show()
	SxNo.focus(true,100)
	
}