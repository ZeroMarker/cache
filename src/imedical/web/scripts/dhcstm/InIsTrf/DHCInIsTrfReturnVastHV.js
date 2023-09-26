// /名称: 库存转移制单
// /描述: 库存转移制单
// /编写者：zhangdongmei
// /编写日期: 2012.07.18
		var userId = session['LOGON.USERID'];
		var gGroupId=session['LOGON.GROUPID'];
		var gLocId=session['LOGON.CTLOCID'];
		var gHVInIsTrf = true;
		var CURR_INIT = '';		//当前转移单rowidstr
		//取参数配置
		if(gParam==null ||gParam.length<1){			
			GetParam();		
		}
	
		//取高值管理参数
		var UseItmTrack="";
		if(gItmTrackParam.length<1){
			GetItmTrackParam();
			UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
		}
		//若使用高值跟踪,分一般入库和高值入库两个菜单,否则不需区分
		UseItmTrack=UseItmTrack&&gHVInIsTrf;
		
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '请求部门...',
					groupId:gGroupId
//					defaultLoc:{}
		});
	
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '供给部门...',
					defaultLoc:{},
					hidden : true
//					groupId:gGroupId
				});

		var VirtualFlag = new Ext.form.Checkbox({
			hideLabel:true,
			boxLabel : G_VIRTUAL_STORE,
			id : 'VirtualFlag',
			name : 'VirtualFlag',
			anchor : '90%',
			checked : false,
			listeners:{
				check:function(chk,bool){
					if(bool){
						var phaloc=Ext.getCmp("SupplyPhaLoc").getValue();
						var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
						var response=ExecuteDBSynAccess(url);
						var jsonData=Ext.util.JSON.decode(response);
						if(jsonData.success=='true'){
							var info=jsonData.info;
							var infoArr=info.split("^");
							var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
							addComboData(Ext.getCmp("SupplyPhaLoc").getStore(),vituralLoc,vituralLocDesc);
							Ext.getCmp("SupplyPhaLoc").setValue(vituralLoc);
						}
					}else{
						SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
					}
				}
			}
		});	
				
		// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 

		// 出库类型
		var OperateOutType = new Ext.ux.ComboBox({
			fieldLabel : '出库类型',
			id : 'OperateOutType',
			name : 'OperateOutType',
			store : OperateOutTypeStore,
			valueField : 'RowId',
			displayField : 'Description'
		});
		
		// 默认选中第一行数据
		OperateOutTypeStore.load({
			callback:function(r,options,success){
				if(success && r.length>0){
					OperateOutType.setValue(r[0].get(OperateOutType.valueField));
				}
			}
		});

		// 日期
		var InItDate = new Ext.ux.DateField({
					fieldLabel : '日期',
					id : 'InItDate',
					name : 'InItDate',
					anchor : '90%',
					
					width : 120,
					value : new Date(),
					disabled : true
				});

		// 完成
		var InItFlag = new Ext.form.Checkbox({
					fieldLabel : '完成',
					id : 'InItFlag',
					name : 'InItFlag',
					anchor : '90%',
					width : 120,
					checked : false,
					disabled : true
				});

		// 备注
		var Remark = new Ext.form.TextField({
					fieldLabel : '备注',
					id : 'Remark',
					name : 'Remark',
					anchor : '90%',
					width : 120,
					disabled : false
				});
				
		// 查询转移单按钮
		var SearchInItBT = new Ext.Toolbar.Button({
					id : "SearchInItBT",
					text : '查询',
					tooltip : '点击查询转移单',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						if(Ext.getCmp("RequestPhaLoc").getValue()==""){
							Msg.info("warning","请求部门不可为空!");
							return;
						}
						StockTransferSearchR(DetailStore,Query);
					}
				});


		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					id : "ClearBT",
					text : '清空',
					tooltip : '点击清空',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {
			CURR_INIT = '';
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("VirtualFlag").setValue(false);
			SetLogInDept(RequestPhaLoc.getStore(),"RequestPhaLoc");
			Ext.getCmp("RequestPhaLoc").setDisabled(0);
			Ext.getCmp("StkGrpType").setDisabled(0);
			
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			InitMasterStore.removeAll();
			InitMasterGrid.getView().refresh();
		}

		// 新建按钮
		var AddBT = new Ext.Toolbar.Button({
					id : "AddBT",
					text : '增加一条',
					tooltip : '点击增加',
					width : 70,
					height : 30,
					iconCls : 'page_add',
					handler : function() {
						if(gParam[7]=='Y'){
							Msg.info("warning","只能根据请求单转移制单,不可新增记录!");
							return;
						}
						// 判断转移单是否已审批
						var InitSel = InitMasterGrid.getSelectionModel().getSelected();
						if(InitSel != null){
							if (InitSel.get('comp')=='Y') {
								Msg.info("warning", "转移单已完成不能增加明细!");
								return;
							}
						}

						var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
						if (requestphaLoc == null || requestphaLoc.length <= 0) {
							Msg.info("warning", "请选择请求部门!");
							return;
						}

						var operatetype = Ext.getCmp("OperateOutType").getValue();
						if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", "请选择出库类型!");
							return;
						}
						// 新增一行
						addNewRow();
						//查询^清除^新建^保存^删除^完成^取消完成
//						changeButtonEnable("1^1^1^1^1^1^0");
					}
				});
		/**
		 * 新增一行
		 */
		function addNewRow() {
			var inciIndex=GetColIndex(DetailGrid,"inciDesc");
			var barcodeIndex=GetColIndex(DetailGrid,"HVBarCode");
			var col=UseItmTrack?barcodeIndex:inciIndex;
			// 判断是否已经有添加行
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("inci");	//initi --> inci
				if (data == null || data.length <= 0) {
					DetailGrid.startEditing(DetailStore.getCount() - 1, col);
					return;
				}
			}
			var NewRecord = CreateRecordInstance(DetailStore.fields);
			DetailStore.add(NewRecord);
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			SupplyPhaLoc.setDisabled(true);
			StkGrpType.setDisabled(true);
		}

		// 删除按钮
		var DeleteBT = new Ext.Toolbar.Button({
					id : "DeleteBT",
					text : '删除',
					tooltip : '点击删除',
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					handler : function() {
						deleteData();
					}
				});

		function deleteData() {
			var InitSel = InitMasterGrid.getSelectionModel().getSelected();
			if(InitSel == null){
				Msg.info('warning', '请选择需要删除的单据!');
				return false;
			}
			var CompFlag = InitSel.get('comp');
			if (CompFlag == 'Y') {
				Msg.info("warning", "转移单已完成不能删除!");
				return;
			}
			Ext.MessageBox.show({
						title : '提示',
						msg : '是否确定删除整张转移单?',
						buttons : Ext.MessageBox.YESNO,
						fn : showDeleteIt,
						icon : Ext.MessageBox.QUESTION
					});
		}

		/**
		 * 删除转移单提示
		 */
		function showDeleteIt(btn) {
			if (btn == "yes") {
				var InitSel = InitMasterGrid.getSelectionModel().getSelected();
				if(InitSel == null){
					Msg.info('warning', '请选择需要删除的单据!');
					return false;
				}
				var InitId = InitSel.get('init');
				var url = DictUrl + "dhcinistrfaction.csp?actiontype=Delete&Rowid=" + InitId;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '查询中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									// 删除单据
									Msg.info("success", "转移单删除成功!");
									var InitStrArr = CURR_INIT.split();
									InitStrArr.remove(InitId);
									CURR_INIT = InitStrArr.join();
									DetailGrid.store.removeAll();
									DetailGrid.getView().refresh();
									InitMasterStore.load({params:{InitStr : CURR_INIT}});
								} else {
									Msg.info("error", "转移单删除失败:"+jsonData.info);
								}
							},
							scope : this
						});
			}
		}

		/**
		 * 删除选中行物资
		 */
		function deleteDetail() {
			// 判断转移单是否已完成
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", "转移单已完成不能删除!");
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "没有选中行!");
				return;
			}
			// 选中行
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var InItIRowId = record.get("initi");
			if (InItIRowId == null || InItIRowId.length <= 0) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
			} else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该物资信息?',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
		}
		/**
		 * 删除提示
		 */
		function showResult(btn) {
			if (btn == "yes") {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var row = cell[0];
				var record = DetailGrid.getStore().getAt(row);
				var InItIRowId = record.get("initi");
				
				// 删除该行数据
				var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=DeleteDetail&RowId="
						+ InItIRowId ;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '查询中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "删除成功!");
									DetailGrid.getStore().remove(record);
									DetailGrid.getView().refresh();
								} else {
									Msg.info("error", "删除失败!");
								}
							},
							scope : this
						});
			}
		}

		// 完成按钮
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : '完成',
					tooltip : '点击完成',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Complete();
					}
				});

		/**
		 * 完成转移单
		 */
		function Complete() {
			var InitSel = InitMasterGrid.getSelectionModel().getSelected();
			if(InitSel == null){
				Msg.info("warning", "没有需要完成的转移单!");
				return;
			}
			var CompFlag = InitSel.get('comp');
			if (CompFlag == 'Y') {
				Msg.info("warning", "转移单已完成!");
				return;
			}
			var InitId = InitSel.get('init');
			if (InitId=='') {
				Msg.info("warning", "没有需要完成的转移单!");
				return;
			}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ InitId+'&Status=11&Complete=Y&GroupId='+gGroupId;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", "成功!");
								InitMasterStore.reload();
							} else {
								Msg.info("error", "失败:"+jsonData.info);
							}
						},
						scope : this
					});
		}

		// 取消完成按钮
		var CancelCmpBT = new Ext.Toolbar.Button({
					id : "CancelCmpBT",
					text : '取消完成',
					tooltip : '点击取消完成',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						CancelComplete();
					}
				});
		/**
		 * 取消完成转移单
		 */
		function CancelComplete() {
			var InitSel = InitMasterGrid.getSelectionModel().getSelected();
			if(InitSel == null){
				Msg.info("warning", "没有需要取消完成的转移单!");
				return;
			}
			var CompFlag = InitSel.get('comp');
			if (CompFlag != 'Y') {
				Msg.info("warning", "转移单尚未完成!");
				return;
			}
			var InitId = InitSel.get('init');
			if (InitId=='') {
				Msg.info("warning", "没有需要取消完成的转移单!");
				return;
			}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ InitId+'&Status=10&Complete=N';

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", "成功!");
								InitMasterStore.reload();
							} else {
								Msg.info("error", "失败："+jsonData.info);
							}
						},
						scope : this
					});
		}

		// 删除明细
		var DeleteDetailBT = new Ext.Toolbar.Button({
					id : "DeleteDetailBT",
					text : '删除一条',
					tooltip : '点击删除',
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					//disabled : true,
					handler : function() {
						deleteDetail();
					}
		});
		
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					text : '打印',
					tooltip : '点击打印',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						
						var InitSel = InitMasterGrid.getSelectionModel().getSelected();
						if(InitSel == null){
							Msg.info("warning", "没有需要完成的转移单!");
							return;
						}
						var InitId = InitSel.get('init');
						if (InitId =='') {
							Msg.info("warning", "没有需要打印的转移单!");
							return;
						}
						PrintInIsTrfReturn(InitId);
					}
				});
		// 打印按钮
		var PrintHVCol = new Ext.Toolbar.Button({
					text : '高值汇总打印',
					tooltip : '打印高值转移单票据',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						
						var InitSel = InitMasterGrid.getSelectionModel().getSelected();
						if(InitSel == null){
							Msg.info("warning", "没有需要完成的转移单!");
							return;
						}
						var InitId = InitSel.get('init');
						if (InitId =='') {
							Msg.info("warning", "没有需要打印的转移单!");
							return;
						}
						PrintInIsTrfHVCol(InitId);
					}
				});
				
		// 单位
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : '单位',
					id : 'CTUom',
					name : 'CTUom',
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
		CTUom.on('beforequery', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var InciDr = record.get("inci");
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ InciDr;
					CTUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							});
					CTUom.store.removeAll();
					CTUom.store.load();
				});

		/**
		 * 单位变换事件
		 */
		CTUom.on('select', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					
					var value = combo.getValue();        //目前选择的单位id
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFac");   //大单位到小单位的转换关系					
					var TrUom = record.get("uom");    //目前显示的出库单位
					var Sp = record.get("sp");
					var Rp = record.get("rp");
					var NewSp = record.get("newSp");
					var InclbQty=record.get("inclbQty");
					var ReqStkQty=record.get("reqLocStkQty");
					var inclbDirtyQty=record.get("inclbDirtyQty");
					var AvaQty=record.get("inclbAvaQty");
					var ReqQty=record.get("reqQty");
					var TrQty=record.get("qty");
					var dirtyQty=record.get("dirtyQty");
					if (value == null || value.length <= 0) {
						return;
					} else if (TrUom == value) {
						return;
					} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
						record.set("sp", accDiv(Sp,ConFac));
						record.set("newSp", accDiv(NewSp,ConFac));
						record.set("rp", accDiv(Rp,ConFac));
						record.set("inclbQty", accMul(InclbQty,ConFac));
						record.set("reqLocStkQty", accMul(ReqStkQty,ConFac));
						record.set("inclbDirtyQty", accMul(inclbDirtyQty,ConFac));
						record.set("inclbAvaQty", accMul(AvaQty,ConFac));
						record.set("reqQty", accMul(ReqQty,ConFac));
						record.set("dirtyQty",accMul(dirtyQty,ConFac));
					} else{  //新选择的单位为大单位，原先是单位为小单位
						record.set("sp", accMul(Sp,ConFac));
						record.set("newSp", accMul(NewSp,ConFac));
						record.set("rp", accMul(Rp,ConFac));
						record.set("inclbQty", accDiv(InclbQty,ConFac));
						record.set("reqLocStkQty", accDiv(ReqStkQty,ConFac));
						record.set("inclbDirtyQty", accDiv(inclbDirtyQty,ConFac));
						record.set("inclbAvaQty", accDiv(AvaQty,ConFac));
						record.set("reqQty", accDiv(ReqQty,ConFac));
						record.set("dirtyQty",accDiv(dirtyQty,ConFac));
					}
					record.set("uom", combo.getValue());
		});
		
		// 显示出库单数据
		function Query(InitRowid) {
			CURR_INIT = InitRowid;
			if (Ext.isEmpty(InitRowid)) {
				return;
			}
			InitMasterStore.load({
				params : {InitStr : InitRowid},
				callback : function(r, options, success){
					if(r.length > 0){
						InitMasterGrid.getSelectionModel().selectFirstRow();
					}
				}
			});
		}
		// 显示入库单明细数据
		function getDetail(InitRowid) {
			if (InitRowid == null || InitRowid=='') {
				return;
			}
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:999,Parref:InitRowid}});
		}
		
		// 转移明细
		// 访问路径
		var DetailUrl =DictUrl+
			'dhcinistrfaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		
		// 指定列参数
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc","dirtyQty","HVFlag","HVBarCode","BarCode"
				];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "转移细项RowId",
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "物资RowId",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '物资名称',
					dataIndex : 'inciDesc',
					width : 230,
					align : 'left',
					sortable : true
				}, {
					header : "高值标志",
					dataIndex : 'HVFlag',
					width : 80,
					align : 'center',
					sortable : true,
					hidden : true
				}, {
					header : "高值条码",
					dataIndex : 'HVBarCode',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : !UseItmTrack,
					editable : UseItmTrack,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								var Barcode=field.getValue();
								if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
									var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
									var findHVIndex=DetailStore.findExact('HVBarCode',Barcode,0);
									if(findHVIndex>=0 && findHVIndex!=row){
										Msg.info("warning","不可重复录入!");
										field.setValue("");
										return;
									}
									Ext.Ajax.request({
											url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
											method : 'POST',
											params : {Barcode:Barcode},
											waitMsg : '查询中...',
											success : function(result, request){
												var jsonData = Ext.util.JSON
														.decode(result.responseText);
												if(jsonData.success == 'true'){
													var itmArr=jsonData.info.split("^");
													var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
													var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
													var LocId=itmArr[18],LocDesc=itmArr[19];
													var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
//													if(Ext.getCmp("StkGrpType").getValue()!=scgID){
//														//Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
//														//DetailGrid.store.getAt(row).set("HVBarCode","");
//														//return;
//													}else 
													if(inclb==""){
														Msg.info("warning","该高值材料没有相应库存记录,不能制单!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(lastDetailAudit!="Y"){
														Msg.info("warning","该高值材料有未审核的"+lastDetailOperNo+",请核实!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(type=="T"){
														Msg.info("warning","该高值材料已经出库,不可制单!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(status!="Enable"){
														Msg.info("warning","该高值条码处于不可用状态,不可制单!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(LocId==phaLocRQ){
														Msg.info('warning', '本科室物资!');
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}
													var record = Ext.data.Record.create([{
																name : 'InciDr',
																type : 'string'
															}, {
																name : 'InciCode',
																type : 'string'
															}, {
																name : 'InciDesc',
																type : 'string'
															}]);
													var InciRecord = new record({
																InciDr : inciDr,
																InciCode : inciCode,
																InciDesc : inciDesc
															});
													
													var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
														+"&ProLocId="+LocId+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
													var LBResult=ExecuteDBSynAccess(url);
													var info=Ext.util.JSON.decode(LBResult);
													if(info.results=='0'){
														Msg.info("warning","该高值材料没有相应库存记录,不能制单!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}
													var inforows=info.rows[0];
													
													Ext.applyIf(InciRecord.data,inforows);
													returnInfo(InciRecord);
													
													/**
													 * 保存高值
													 */
													var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
													var reqid='';
													var operatetype = Ext.getCmp("OperateOutType").getValue();	
													var Complete='N';
													var Status=10;
													var StkGrpId = '';
													var StkType = App_StkTypeCode;					
													var remark = Ext.getCmp("Remark").getValue();
													
													var MainInfo = LocId + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
															+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
													var FrLocIndex = InitMasterStore.findExact("frLoc",LocId,0);
													if (FrLocIndex != -1){
														var init = InitMasterStore.getAt(FrLocIndex).get("init");
													}else{
														var init = tkMakeServerCall('web.DHCSTM.DHCINIsTrf','Update','',MainInfo);
														if(init < 0){
															Msg.info('error', Barcode + '保存失败!');
															return false;
														}
														if(CURR_INIT == ''){
															CURR_INIT = init;
														}else{
															CURR_INIT = CURR_INIT + ',' +init;
														}
														InitMasterStore.load({params : {InitStr : CURR_INIT}});
													}
													var Initi = '', ReqItmId = '', InitiQty = 1, Remark = '';
													var UomId = InciRecord.get("BUomId");
													var ListData = Initi + "^" + inclb + "^" + InitiQty + "^" + UomId + "^" + ReqItmId
															+ "^" + Remark + "^" + Barcode;
													var initi = tkMakeServerCall('web.DHCSTM.DHCINIsTrfItm','Save',init,ListData,MainInfo)
													if(initi != '0'){
														Msg.info('error', Barcode + '保存失败:'+initi);
														return false;
													}
												}else{
													Msg.info("warning","该条码尚未注册!");
													DetailGrid.store.getAt(row).set("HVBarCode","");
													return;
												}
											}
									});
								}
							}
						}
					}))
				}, {
					header : "批次RowId",
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "批号/效期",
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "生产厂商",
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				},
				/*{
					header : "可用数量",
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, */
				{
					header : "转移数量",
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
									// 判断转移单是否已完成
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning", "转移单已完成不可修改!");
										return;
									}
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", "转移数量不能为空!");
										return;
									}
									if (qty <= 0) {
										Msg.info("warning", "转移数量不能小于或等于0!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var salePriceAMT = record.get("sp")* qty;
									record.set("spAmt",	salePriceAMT);
									var AvaQty = record.get("inclbAvaQty");
									if (qty > AvaQty) {
										Msg.info("warning", "转移数量不能大于可用库存数量!");
										return;
									}

									// 新增一行
									addNewRow();
								}
							}
						}
					})
				}, {
					header : "转移单位",
					dataIndex : 'uom',
					width : 80,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","TrUomDesc"), // pass combo instance to reusable renderer					
					editor : new Ext.grid.GridEditor(CTUom)
				}, {
					header : "进价",
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					sortable : true,
					summaryType : 'sum'
				}, {
					header : "售价金额",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					sortable : true,
					summaryType : 'sum'
				}, {
					header : "请求数量",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "货位码",
					dataIndex : 'stkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "请求方库存",
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "批次库存",
					dataIndex : 'inclbQty',
					width : 90,
					align : 'right',
					sortable : true
				}, 
				/*{
					header : "本次占用数量",
					dataIndex : 'dirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "占用数量",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				},*/
				{
					header : "批次售价",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					hidden : true,
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "转换率",
					dataIndex : 'ConFac',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "基本单位",
					dataIndex : 'BUomId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "转移请求子表RowId",
					dataIndex : 'inrqi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}
			]);

		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title:'库存转移单',
					tbar:{items:[AddBT,'-',DeleteDetailBT,'-',{height:30,width:70,text:'列设置',iconCls:'page_gear',handler:function(){	GridColSet(DetailGrid,"DHCSTTRANSFERM");}}]},
					region : 'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					plugins : new Ext.grid.GridSummary(),
					listeners:{
						'beforeedit' : function(e){
							if(Ext.getCmp("InItFlag").checked==true){
								return false;
							}
							if(e.field=="inciDesc" || e.field=="qty" || e.field=="uom"){
								if(e.record.get("HVBarCode")!=""){
									e.cancel=true;
								}
							}
							if(e.field=="HVBarCode" && e.record.get("inclb")!=""){
								e.cancel=true;
							}
						}
					}
				});
		
		/***
		**添加右键菜单
		**/		
		DetailGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
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

		/**
		 * 返回数据信息
		 */
		function returnInfo(record) {
			if (record == null || record == "") {
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			var rowData = DetailStore.getAt(selectRow);
			// 检核重复批次
			var INITIINCLBDR = record.get("Inclb");
			var HVFlag=record.get("HVFlag");
			if(!UseItmTrack || HVFlag!='Y'){
				var findIndex=DetailStore.findExact('inclb',INITIINCLBDR,0);
				if(findIndex>=0 && findIndex!=selectRow){
					Msg.info("warning", "物资批次重复，请重新输入!");
					return;
				}
			}
			
			var BarCode=rowData.get("HVBarCode");
			var ItmTrack=gItmTrackParam[0]=='Y'?true:false;
			if(!(ItmTrack==gHVInIsTrf) && HVFlag=='Y'){
				Msg.info("warning","高值材料,请根据条码录入!");
				var index=GetColIndex(DetailGrid,"HVBarCode");
				rowData.set("InciDesc","");
				DetailGrid.startEditing(cell[0], index);
				return;
			}
			// DetailStore.getAt(selectRow).set("INITIRowId", "");
			rowData.set("inci", record.get("InciDr"));
			rowData.set("inciCode", record.get("InciCode"));
			rowData.set("inciDesc", record.get("InciDesc"));
			rowData.set("inclb",record.get("Inclb"));
			rowData.set("batexp",record.get("BatExp"));
			rowData.set("manfName",record.get("Manf"));
			rowData.set("inclbQty",record.get("InclbQty"));
			addComboData(CTUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
			rowData.set("uom",record.get("PurUomId"));
			rowData.set("rp",record.get("Rp"));
			rowData.set("sp",record.get("Sp"));
			//DetailStore.getAt(selectRow).set("reqQty", record.get("ReqQty"));
			rowData.set("stkbin", record.get("StkBin"));
			rowData.set("reqLocStkQty",record.get("RequrstStockQty"));
			rowData.set("newSp",record.get("BatSp"));
			rowData.set("spec", record.get("Spec"));
			rowData.set("ConFac", record.get("ConFac"));
			rowData.set("BUomId",record.get("BUomId"));
			rowData.set("inclbDirtyQty", record.get("DirtyQty"));
			rowData.set("inclbAvaQty", record.get("AvaQty"));
			rowData.set("HVFlag", record.get("HVFlag"));
			var HVFlag=record.get("HVFlag");
			if(UseItmTrack && HVFlag=='Y'){
				if(record.get("AvaQty")<1){
					Msg.info("warning","可用库存不足!");
					return;
				}else{
					rowData.set("qty", 1);
					rowData.set("spAmt", record.get("Sp"));
					addNewRow();
				}
			}else{
				var index=GetColIndex(DetailGrid,"qty");
				DetailGrid.startEditing(cell[0], index);
			}
		}

//		// 变换行颜色
//		function changeBgColor(row, color) {
//			DetailGrid.getView().getRow(row).style.backgroundColor = color;
//		}

		// 变更按钮是否可用
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			//查询^清除^新建^保存^删除^完成^取消完成
			SearchInItBT.setDisabled(list[0]);
			ClearBT.setDisabled(list[1]);
			//AddBT.setDisabled(list[2]);
			SaveBT.setDisabled(list[3]);
			DeleteBT.setDisabled(list[4]);			
			CheckBT.setDisabled(list[5]);
			CancelCmpBT.setDisabled(list[6]);
		}

		var HisListTab = new Ext.form.FormPanel({
			region : 'west',
			width : 800,
			id:'HisListTab',
			labelAlign : 'right',
			labelWidth : 80,
			height : 200,
			frame : true,
			title: '高值批量退库',
			autoScroll : false,
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [SearchInItBT, '-',  ClearBT, '-', DeleteBT, '-', CancelCmpBT, '-', CheckBT,'-',PrintBT,'-',PrintHVCol],
			items:[{
				xtype:'fieldset',
				title:'转移单信息',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:'padding: 5px 0px 0px 0px',
				defaults: {border:false},
				items : [{
						columnWidth: 0.3,
						xtype: 'fieldset',
						items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
					},
					/*{
						columnWidth: gHVInIsTrf?0.05:0.01,
						items: gHVInIsTrf?[VirtualFlag]:[]
					},
					*/
					{
						columnWidth: 0.3,
						xtype: 'fieldset',
						items: [InItDate,OperateOutType]
					},{
						columnWidth: 0.3,
						xtype: 'fieldset',
						items: [InItFlag,Remark]
					}]
			}]
		});

		var InitMasterStore = new Ext.data.JsonStore({
			url : DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryTrans',
			totalProperty : 'results',
			root : 'rows',
			fields : ["init", "initNo", "reqNo", "toLoc", "toLocDesc", "frLoc", "frLocDesc", "dd", "tt", "comp",
				"userName", "status", "RpAmt", "SpAmt", "MarginAmt", "Remark", "StatusCode"]
		});
		
		var InitMasterCm =  new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header : "RowId",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "单号",
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "库房",
				dataIndex : 'toLocDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "退库部门",
				dataIndex : 'frLocDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : '完成状态',
				dataIndex : 'comp',
				width : 60,
				align : 'center',
				sortable : true
			}, {
				header : '单据状态',
				dataIndex : 'StatusCode',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '日期',
				dataIndex : 'dd',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "时间",
				dataIndex : 'tt',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '制单人',
				dataIndex : 'userName',
				width : 100,
				align : 'left',
				sortable : true
			}
		]);
		
		var InitMasterGrid = new Ext.grid.GridPanel({
			region : 'center',
			id : 'InitMasterGrid',
			title : '',
			cm : InitMasterCm,
			sm : new Ext.grid.RowSelectionModel({
				singleSelect : true,
				listeners : {
					rowselect : function(sm, rowIndex, r){
						var InitId = r.get('init');
						getDetail(InitId);
					}
				}
			}),
			store : InitMasterStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true
		});
		
		var panel = new Ext.Panel({
			region : 'north',
			layout : 'border',
			height : 180,
			items : [HisListTab, InitMasterGrid]
		});
		
		Ext.onReady(function() {
			Ext.QuickTips.init();
			Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
			// 页面布局
			var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [panel, DetailGrid],
				renderTo : 'mainPanel'
			});
			RefreshGridColSet(DetailGrid,"DHCSTTRANSFERM");
		});