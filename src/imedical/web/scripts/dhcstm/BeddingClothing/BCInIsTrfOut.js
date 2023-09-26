// /名称: 被服类转出制单
// /描述: 被服类转出制单
// /编写者：wangjiabin
// /编写日期: 2013-12-30

//保存参数值的object
var BCInIsTrfOutParamObj = GetAppPropValue('DHCSTBCM');

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gHospId = session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gInclbFlag = true;		//加载批次信息参数
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		// 接收部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '接收部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '接收部门...',
					defaultLoc:{}
		});
	
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '供给部门...',
					groupId:gGroupId,
					listeners : {
						select : function(){
							QueryInclbInfo();
						}
					}
				});

		// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:gUserId,
			anchor:'90%',
			width : 200,
			listeners : {
				select : function(){
					QueryInclbInfo();
				}
			}
		});
		StkGrpType.getStore().on('load',function(){
			QueryInclbInfo();
		})
		
		// 出库类型
		var OperateOutType = new Ext.ux.ComboBox({
			fieldLabel : '出库类型',
			id : 'OperateOutType',
			name : 'OperateOutType',
			store : OperateOutTypeStore,
			valueField : 'RowId',
			displayField : 'Description'
		});
		SetDefaultType();
		
		function SetDefaultType(){
			// 默认选中第一行数据
			OperateOutTypeStore.load({
				callback:function(r,options,success){
					if(success && r.length>0){
						OperateOutType.setValue(r[0].get(OperateOutType.valueField));
					}
				}
			});
		}

		// 转移单号
		var InItNo = new Ext.form.TextField({
					fieldLabel : '转移单号',
					id : 'InItNo',
					name : 'InItNo',
					anchor : '90%',
					width : 120,
					disabled : true
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
					id : 'InItFlag',
					boxLabel : '完成',
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

		//请求单号
		var ReqNo = new Ext.form.TextField({
					fieldLabel : '请求单号',
					id : 'ReqNo',
					name : 'ReqNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});
				
				//请求单号
		var ReqNoID = new Ext.form.TextField({
					fieldLabel : '请求单号ID',
					id : 'ReqNoID',
					name : 'ReqNoID',
					anchor : '90%',
					width : 120,
					hidden:true,
					disabled : true
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
//						if(Ext.getCmp("SupplyPhaLoc").getValue()==""){
//							Msg.info("warning","供给部门不可为空!");
//							return;
//						}
						BCInIsTrfFind(0,Query);
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
						SetFormOriginal(HisListTab);
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {
			SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(),"SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItNo").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("ReqNo").setValue("");
			Ext.getCmp("ReqNoID").setValue("");
			gInitId="";
			gInclbFlag=true;
			Ext.getCmp('SupplyPhaLoc').setDisabled(false);
			Ext.getCmp('StkGrpType').setDisabled(false);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// 变更按钮是否可用
			//查询^清除^新建^保存^删除^完成^取消完成
			changeButtonEnable("1^1^1^1^0^0^0");
			Ext.getCmp("StkGrpType").getStore().load();		//注意load事件触发QueryInclbInfo
			SetDefaultType();
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
						var initFlag = Ext.getCmp("InItFlag").getValue();
						if (gInitId!="" && initFlag != null && initFlag != 0) {
							Msg.info("warning", "转移单已完成不能增加明细!");
							return;
						}

						var requestphaLoc = Ext.getCmp("RequestPhaLoc")
								.getValue();
						if (requestphaLoc == null || requestphaLoc.length <= 0) {
							Msg.info("warning", "请选择接收部门!");
							return;
						}
						var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
								.getValue();
						if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
							Msg.info("warning", "请选择供应部门!");
							return;
						}
						if (requestphaLoc == supplyphaLoc) {
							Msg.info("warning", "接收部门和供应部门不能相同!");
							return;
						}

						var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
						if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", "请选择出库类型!");
							return;
						}
						if(gInclbFlag===true){
							DetailStore.removeAll();
							gInclbFlag = false;
						}
						// 新增一行
						addNewRow();
						//查询^清除^新建^保存^删除^完成^取消完成
						changeButtonEnable("1^1^1^1^1^1^0");
					}
				});
		/**
		 * 新增一行
		 */
		function addNewRow() {
			var col=GetColIndex(DetailGrid,"inciDesc");
			// 判断是否已经有添加行
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("inci");
				if (data == null || data.length <= 0) {
					
					DetailGrid.startEditing(DetailStore.getCount() - 1, col);
					return;
				}
			}
			
			var NewRecord = CreateRecordInstance(DetailStore.fields);
			DetailStore.add(NewRecord);
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			SupplyPhaLoc.setDisabled(true);
		};

		// 保存按钮
		var SaveBT = new Ext.ux.Button({
					id : "SaveBT",
					text : '保存',
					tooltip : '点击保存',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {
						if(gParam[7]=='Y'){
							Msg.info("warning","只能根据请求单转移制单,不可保存新记录!");
							return;
						}
						if(DetailGrid.activeEditor != null){
							DetailGrid.activeEditor.completeEdit();
						}
						// 保存转移单
						if(CheckDataBeforeSave()==true){
							saveOrder();
							// 变更按钮是否可用
							//查询^清除^新建^保存^删除^完成^取消完成
							//changeButtonEnable("1^1^1^1^1^1^0");
						}
					}
				});
				
		/**
		 * 保存出库单前数据检查
		 */		
		function CheckDataBeforeSave() {
					
			// 判断转移单是否已完成
			var initFlag = Ext.getCmp("InItFlag").getValue();
			if (initFlag != null && initFlag != 0) {
				Msg.info("warning", "转移单已完成不可修改!");
				return false;
			}

			var requestphaLoc = Ext.getCmp("RequestPhaLoc")
					.getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", "请选择接收部门!");
				return false;
			}
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
					.getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "请选择供应部门!");
				return false;
			}
			if (requestphaLoc == supplyphaLoc) {
				Msg.info("warning", "接收部门和供应部门不能相同!");
				return false;
			}

			var operatetype = Ext.getCmp("OperateOutType")
					.getValue();
			if (operatetype == null || operatetype.length <= 0) {
				Msg.info("warning", "请选择出库类型!");
				return false;
			}
			// 1.判断转移物资是否为空
			var rowCount = DetailGrid.getStore().getCount();
			// 有效行数
			var count = 0;
			for (var i = 0; i < rowCount; i++) {
				var item = DetailStore.getAt(i).get("inci");
				if (item != undefined && item !='') {
					count++;
				}
			}
			if (rowCount <= 0 || count <= 0) {
				Msg.info("warning", "请输入转移明细!");
				return false;
			}
			// 2.重新填充背景
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			// 3.判断重复输入批次库存物资--对于高值材料,不判断是否重复
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var item_i = DetailStore.getAt(i).get("inclb");
					var HVFlag = DetailStore.getAt(i).get("HVFlag");
					var item_j = DetailStore.getAt(j).get("inclb");
					if (item_i != undefined && item_j != undefined
							&& item_i == item_j) {
						changeBgColor(i, "yellow");
						changeBgColor(j, "yellow");
						Msg.info("warning", "物资批次重复，请重新输入!");
						return false;
					}
				}
			}
			// 4.物资信息输入错误
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var code = rowData.get("inciCode");
				if (code == null || code.length == 0) {
					continue;
				}
				var item = rowData.get("inci");
				if (item == undefined) {
					Msg.info("warning", "物资信息输入错误!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				var qty = DetailStore.getAt(i).get("qty");
				if ((item != undefined) && (qty != '')) {
					//填写数量的才判断, 避免可用库存为负值时的提示情况
					var avaQty = DetailStore.getAt(i).get("inclbAvaQty");
					var dirtyQty=DetailStore.getAt(i).get("dirtyQty");    //本次占用数量
					if ((item != undefined) && ((qty - avaQty-dirtyQty) > 0)) {
						Msg.info("warning", "转移数量不能大于可用库存数量!");
						DetailGrid.getSelectionModel().select(i, 1);
						changeBgColor(i, "yellow");
						return false;
					}else if(qty%1 != 0){
						//仅提示,不控制
						Msg.info('warning', '第' + (i+1) + '行数量为小数, 敬请核实!');
					}
				}
			}
			
			return true;
		}
		

		/**
		 * 保存转移单
		 */
		function saveOrder() {
			//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
			var inItNo = Ext.getCmp("InItNo").getValue();
			var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			var reqid=Ext.getCmp("ReqNoID").getValue();
			//alert(reqid)
			var operatetype = Ext.getCmp("OperateOutType").getValue();	
			var Complete='N';
			var Status=10;
			var StkGrpId = Ext.getCmp("StkGrpType").getValue();
			var StkType = App_StkTypeCode;					
			var remark = Ext.getCmp("Remark").getValue();
			
			var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
					+ Complete + "^" + Status + "^" + gUserId + "^"+StkGrpId+"^"+StkType+"^"+remark;
			//明细id^批次id^数量^单位^请求明细id^备注
			var ListDetail="";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					var Initi = rowData.get("initi");
					var Inclb = rowData.get("inclb");
					if(Inclb==null || Inclb==""){continue;}
					var Qty = rowData.get("qty");
					if(Qty==0){continue;}
					var UomId = rowData.get("uom");
					var ReqItmId = rowData.get("inrqi");
					var Remark = rowData.get("remark");
					var BarCode = rowData.get("HVBarCode");
					
					var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
							+ ReqItmId + "^" + Remark + "^" + BarCode;	
					if(ListDetail==""){
						ListDetail=str;
					}else{
						ListDetail=ListDetail+xRowDelim()+str;
					}
				}
			}
			if((gInitId=="")&&(ListDetail=="")){
				Msg.info("warning","没有需要保存的明细数据!");
				return;
			}
			if(!IsFormChanged(HisListTab) && ListDetail==""){
				Msg.info("warning","没有需要保存的数据!");
				return false;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Save";
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						params:{Rowid:gInitId,MainInfo:MainInfo,ListDetail:ListDetail},
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 刷新界面
								var InitRowid = jsonData.info;
								Msg.info("success", "保存成功!");
								// 7.显示出库单数据
								Query(InitRowid);
								//根据参数设置自动打印
								if(gParam[3]=='Y'){
									PrintInIsTrf(InitRowid);
								}
							} else {
								var ret=jsonData.info;								
								Msg.info("error", "保存不成功："+ret);								
							}
						},
						scope : this
					});
			loadMask.hide();
		}

		// 删除按钮
		var DeleteBT = new Ext.Toolbar.Button({
					id : "DeleteBT",
					text : '删除',
					tooltip : '点击删除',
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					disabled : true,
					handler : function() {
						deleteData();
					}
				});

		function deleteData() {
			// 判断转移单是否已完成
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", "转移单已完成不能删除!");
				return;
			}

			var inItNo = Ext.getCmp("InItNo").getValue();
			if (inItNo == null || inItNo.length <= 0) {
				Msg.info("warning", "没有需要删除的转移单!");
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
				var inItNo = Ext.getCmp("InItNo").getValue();
				var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=Delete&Rowid="
						+ gInitId;

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
									clearData();
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
					disabled : true,
					handler : function() {
						Complete();
					}
				});

		/**
		 * 完成转移单
		 */
		function Complete() {
			// 判断转移单是否已完成
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", "转移单已完成!");
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", "没有需要完成的转移单!");
				return;
			}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=11&Complete=Y';

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
								Ext.getCmp("InItFlag").setValue(1);
								
								//查询^清除^新建^保存^删除^完成^取消完成
								changeButtonEnable("1^1^0^0^0^0^1");
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
					disabled : true,
					handler : function() {
						CancelComplete();
					}
				});
		/**
		 * 取消完成转移单
		 */
		function CancelComplete() {
			// 判断转移单是否已完成
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 1) {
				Msg.info("warning", "转移单尚未完成!");
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", "没有需要取消完成的转移单!");
				return;
			}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=10&Complete=N';

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
								Ext.getCmp("InItFlag").setValue(0);
								
								//查询^清除^新建^保存^删除^完成^取消完成
								changeButtonEnable("1^1^1^1^1^1^0");
								
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
		
		// 根据转入单制作出库, 查询转入到本科室的单据
		var SelTransBT = new Ext.Toolbar.Button({
				id : "SelTransBT",
				text : '选取转入单',
				tooltip : '点击查询转入单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
					if(FrLoc==null){
						Msg.info("warning","请选择供应科室!")
						return;
					}
					SelInIsTrfIn(FrLoc,Query);
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
						if (gInitId ==null || gInitId=="") {
							Msg.info("warning", "没有需要打印的转移单!");
							return;
						}
						PrintInIsTrf(gInitId);
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
			if (InitRowid == null || InitRowid =='') {
				return;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Select&Rowid="
					+ InitRowid;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								var list = jsonData.info.split("^");
								if (list.length > 0) {
									gInitId=InitRowid;
									Ext.getCmp("InItNo").setValue(list[8]);
									addComboData(Ext.getCmp("SupplyPhaLoc").getStore(),list[6],list[26]);
									Ext.getCmp("SupplyPhaLoc").setValue(list[6]);
									addComboData(RequestPhaLoc.getStore(),list[12],list[27]);
									Ext.getCmp("RequestPhaLoc").setValue(list[12]);
									//OperateOutTypeStore.load();
									addComboData(OperateOutType.getStore(),list[21],list[32]);
									Ext.getCmp("OperateOutType").setValue(list[21]);
									addComboData(null,list[24],list[36],StkGrpType);
									Ext.getCmp("StkGrpType").setValue(list[24]);
									Ext.getCmp("InItDate").setValue(list[29]);	
									Ext.getCmp("InItFlag").setValue(list[14]=='Y'?true:false);
									Ext.getCmp("Remark").setValue(list[9]);
									Ext.getCmp("ReqNo").setValue(list[28]);		
									Ext.getCmp("ReqNoID").setValue(list[30]);	
										
									// 变更按钮是否可用
									//查询^清除^新增^保存^删除^完成^取消完成
									var CompFlag =list[14];
									if(CompFlag=="Y"){
										changeButtonEnable("1^1^0^0^0^0^1");
									}else{
										changeButtonEnable("1^1^1^1^1^1^0");
									}
									// 显示入库单明细数据
									getDetail(InitRowid);
								}
							} else {
								Msg.info("warning", jsonData.info);
							}
							SetFormOriginal(HisListTab);
						},
						scope : this
					});				
		}
		// 显示入库单明细数据
		function getDetail(InitRowid) {
			if (InitRowid == null || InitRowid=='') {
				return;
			}
			var DetailUrl =DictUrl+
				'dhcinistrfaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
			DetailStore.proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
			DetailStore.removeAll();
			DetailStore.load({
				params:{start:0,limit:999,Parref:InitRowid},
				callback : function(r,options,success){
					gInclbFlag = false;
					Ext.getCmp('SupplyPhaLoc').setDisabled(true);
					Ext.getCmp('StkGrpType').setDisabled(true);
				}
			});
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
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec","newSp", "spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty",
				"inclbAvaQty","TrUomDesc","dirtyQty","HVFlag","HVBarCode"
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
					sortable : true,
					editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									// 判断转移单是否已完成
									var initFlag = Ext.getCmp("InItFlag")
											.getValue();
									if (initFlag != null && initFlag != 0) {
										Msg.info("warning", "转移单已完成不可修改!");
										return;
									}

									var stkgrp = Ext.getCmp("StkGrpType")
											.getValue();
									GetPhaOrderInfo(field.getValue(), stkgrp);
								}
							}
						}
					})
				}, {
					header : "高值标志",
					dataIndex : 'HVFlag',
					width : 80,
					align : 'center',
					sortable : true,
					hidden : true
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
				}, {
					header : "可用数量",
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移数量",
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true,
					renderer : function(value, metadata, record, rowIndex, colIndex, store){
						if(value % 1 != 0){
							metadata.attr = 'style="color:red;"';
						}
						return value;
					},
					editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : true,
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
					header : "请求数量",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					hidden : true,
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
				}, {
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
				}, {
					header : "批次售价",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "售价金额",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					
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
				}]);

		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title:'库存转移单',
					tbar:[AddBT,'-',DeleteDetailBT],
					region : 'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					listeners:{
						'beforeedit' : function(e){
							if(Ext.getCmp("InItFlag").checked==true){
								return false;
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
			grid.getSelectionModel().select(rowindex,0);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}

		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", gHospId,phaLocRQ,
						returnInfo);
			}
		}
		
		/**
		 * 返回数据信息
		 */
		function returnInfo(records) {
			if (records == null || records == "") {
				return;
			}
			Ext.each(records,function(record,index,allItems){
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var selectRow = cell[0];
				var rowData = DetailStore.getAt(selectRow);
				// 检核重复批次
				var INITIINCLBDR = record.get("Inclb");
				var findIndex=DetailStore.findExact('inclb',INITIINCLBDR,0);
				if(findIndex>=0 && findIndex!=selectRow){
					Msg.info("warning", "物资批次重复，请重新输入!");
					return;
				}
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
				//rowData.set("reqQty", record.get("ReqQty"));
				rowData.set("stkbin", record.get("StkBin"));
				rowData.set("reqLocStkQty",record.get("RequrstStockQty"));
				rowData.set("newSp",record.get("BatSp"));
				rowData.set("spec", record.get("Sepc"));
				rowData.set("ConFac", record.get("ConFac"));
				rowData.set("BUomId",record.get("BUomId"));
				rowData.set("inclbDirtyQty", record.get("DirtyQty"));
				rowData.set("inclbAvaQty", record.get("AvaQty"));
				rowData.set("HVFlag", record.get("HVFlag"));
				rowData.set("qty", record.get("OperQty"));
				rowData.set("spAmt", accMul(record.get("Sp"),record.get("OperQty")));
				var lastIndex = DetailStore.getCount()-1;
				if(DetailStore.getAt(lastIndex).get('inclb')!=""){
					addNewRow();
				}else{
					var col=GetColIndex(DetailGrid,'inciDesc')
					DetailGrid.startEditing(lastIndex,col);
				}
			});
		}
		
		// 变换行颜色
		function changeBgColor(row, color) {
			DetailGrid.getView().getRow(row).style.backgroundColor = color;
		}

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

		var HisListTab = new Ext.ux.FormPanel({
			title:'被服类转出',
			tbar : [SearchInItBT, '-', ClearBT, '-', SaveBT, '-', DeleteBT, '-', CancelCmpBT, '-', CheckBT,'-',PrintBT,'-',SelTransBT],
			items:[{
				xtype : 'fieldset',
				title : '转移单信息',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults:{border:false,columnWidth : .33,xtype:'fieldset'},
				items : [{
					items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
				},{
					items: [InItNo,InItDate,OperateOutType]
				},{
					items: [Remark,InItFlag,ReqNoID]
				}]
			}]
		});

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, DetailGrid],
			renderTo : 'mainPanel'
		});
		
		// 登录设置默认值
		SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
		
		if(gInitId!=undefined && gInitId!='' && gFlag==1){
			Query(gInitId);
		}
		
		//因类组加载的异步机制, 放在类组.store的load事件中
		function QueryInclbInfo(){
			if(!gInclbFlag){
				return false;
			}
			DetailStore.removeAll();
			var PhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if(PhaLoc==""){
				return;
			}
			var Scg = Ext.getCmp("StkGrpType").getValue();
			var NotUseFlag = "N", QtyFlag="1";
			var StrParam = PhaLoc+"^"+Scg+"^"+NotUseFlag+"^"+QtyFlag+"^"+gUserId;
			var DetailUrl = DictUrl+ 'dhcinistrfaction.csp?actiontype=QueryInclbDetail&StrParam='+StrParam;
			DetailStore.proxy = new Ext.data.HttpProxy({
					url:DetailUrl,
					method:'GET'
				});
			DetailStore.load({params:{start:0,limit:999}})
		}
	}
})