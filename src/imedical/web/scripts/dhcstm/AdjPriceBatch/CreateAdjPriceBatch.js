// /名称: 批次调价单
// /描述: 编辑批次调价单
// /编写者：zhangdongmei
// /编写日期: 2015.1.22

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var HospId = session['LOGON.HOSPID'];
	var LocId = session['LOGON.CTLOCID'];
	var GroupId = session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// 类组
	var StkGrpType = new Ext.ux.StkGrpComboBox({
				id : 'StkGrpType',
				name : 'StkGrpType',
				fieldLabel : '<font color=blue>类     组</font>',
				StkType : App_StkTypeCode, //标识类组类型
				LocId : LocId,
				UserId : userId,
				anchor : '90%'
			});

	// 调价单号
	var AspBatNo = new Ext.ux.TextField({
				fieldLabel : '调价单号',
				id : 'AspBatNo',
				name : 'AspBatNo'

			});

	var StartDate = new Ext.ux.DateField({
				id : 'StartDate',
				name : 'StartDate',
				fieldLabel : '开始日期',
				value : new Date().add(Date.DAY, -1)
			})

	var EndDate = new Ext.ux.DateField({
				id : 'EndDate',
				name : 'EndDate',
				fieldLabel : '截止日期',
				value : new Date()
			})

	var IncId = new Ext.ux.TextField({
				id : 'IncId',
				name : 'IncId',
				value : ''
			});

	var IncDesc = new Ext.ux.TextField({
				id : 'IncDesc',
				name : 'IncDesc',
				fieldLabel : '物资名称',
				listeners : {
					'specialkey' : function(field, e) {
						var keycode = e.getKey();
						if (keycode == 13) {
							var input = field.getValue();
							var stkgrpid = Ext.getCmp("StkGrpType").getValue();
							GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode,
									"", "N", "", HospId, getDrugList);
						}
					}
				}
			});

	/**
	 * 返回方法
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode = record.get("InciCode");
		var inciDesc = record.get("InciDesc");
		Ext.getCmp("IncId").setValue(inciDr);
		Ext.getCmp("IncDesc").setValue(inciDesc);
	}
	// 查询
	var SearchBT = new Ext.ux.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				handler : function() {
					
					if (isDataChanged(HisListTab,DetailGrid)){
						Ext.Msg.show({
							title:'提示',
							msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
							buttons: Ext.Msg.YESNO,
							fn: function(btn){
								if (btn=='yes') {
									clearData();
									SetFormOriginal(HisListTab);
									AdjPriceSearch();
								}
							}
						})
					}
					else{
						AdjPriceSearch();
					}
					
				}
			});

	//查询调价信息
	function AdjPriceSearch() {
		var stkgrpid = Ext.getCmp("StkGrpType").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		    var EndDate=Ext.getCmp("EndDate").getValue();
		    if(StartDate==""||EndDate==""){
			    Msg.info("warning","开始日期或截止日期不能为空！");
			    return;
			    
		    }
		var stdate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT);
		var eddate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT);
		var inciDesc = Ext.getCmp("IncDesc").getValue();
		if (inciDesc == ""){
			Ext.getCmp("IncId").setValue("");
		}
		var incid = Ext.getCmp("IncId").getValue();
		if(incid!=""&incid!=null){
			inciDesc="";
		}
		var aspno = Ext.getCmp("AspBatNo").getValue();
		var params = aspno + "^N^" + incid + "^" + stkgrpid+"^"+inciDesc;
		DetailStore.load({
					params : {
						start : 0,
						limit : 999,
						StartDate : stdate,
						EndDate : eddate,
						Others : params
					}
				});
	}
	// 清空按钮
	var ClearBT = new Ext.ux.Button({
				id : "ClearBT",
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_clearscreen',
				handler : function() {
					if (isDataChanged(HisListTab,DetailGrid)){
						Ext.Msg.show({
							title:'提示',
							msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
							buttons: Ext.Msg.YESNO,
							fn: function(btn){
								if (btn=='yes') {
									clearData();
									SetFormOriginal(HisListTab);
								}
							}
						})
					}else{
						clearData(); 
						SetFormOriginal(HisListTab);
					}
				}
			});
	/**
	 * 清空方法
	 */
	function clearData() {
		StkGrpType.setDisabled(false);
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, -1));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").setValue("");
		StkGrpType.store.load();
		Ext.getCmp("AspBatNo").setValue("");
		Ext.getCmp("IncDesc").setValue("");
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	var AddDetailBT = new Ext.ux.Button({
				text : '增加一条',
				iconCls : 'page_add',
				handler : function() {
                                        var stkgrptype=Ext.getCmp("StkGrpType").getValue();
		                        if (stkgrptype==""||stkgrptype.length<=0){
			                    Msg.info("warning","类组不能为空！");
                                            return false;
                                            }
                                        addNewRow();
				}
			});

	var DelDetailBT = new Ext.ux.Button({
				text : '删除一条',
				tooltip : '',
				iconCls : 'page_delete',
				handler : function() {
					deleteDrug();
				}
			});

	// 新建按钮
	var AddBT = new Ext.ux.Button({
				id : "AddBT",
				text : '新建',
				iconCls : 'page_add',
				handler : function() {
                                        var stkgrptype=Ext.getCmp("StkGrpType").getValue();
		                        if (stkgrptype==""||stkgrptype.length<=0){
			                    Msg.info("warning","类组不能为空！");
                                            return false;
                                            }
					addNewRow(); // 新增一行

				}
			});
	/**
	 * 新增一行
	 * 
	 */
	function addNewRow() {
		StkGrpType.setDisabled(true);
		// 判断是否已经有添加行
		var aspReasonId = "";
		var aspReason = "";
		var colindex=GetColIndex(DetailGrid,"InciDesc");
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("InciId");
				if (data == null || data.length <= 0) {
					DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
					return;
				}
				var aspno=rowData.get("AspBatNo");
				var curaspno=Ext.getCmp("AspBatNo").getValue();
				if(aspno!="" & aspno!=null & (curaspno==null || curaspno=="")){
					Msg.info("warning","不能追加，请选择某一调价单进行追加，如果要新建调价单，请先清空！");
					return;
				}
			}
		var defaData = {
				PriorSpUom : 0,
				MaxSp : 0,
				ResultSpUom : 0,
				DiffSpUom : 0,
				PriorRpUom : 0,
				ResultRpUom : 0,
				DiffRpUom : 0,
				PreExecuteDate : new Date().add(Date.DAY,1),
				AdjReasonId : "",
				AdjReason : ""
			};
			var NewRecord = CreateRecordInstance(DetailStore.fields,defaData)
			DetailStore.add(NewRecord);
			DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);

	};

	// 保存按钮
	var SaveBT = new Ext.ux.Button({
				id : "SaveBT",
				text : "保存",
				iconCls : 'page_save',
				handler : function() {
					if (CheckDataBeforeSave() == true) {
						// 保存调价单
						save();
					}
				}
			});

	function CheckDataBeforeSave() {
		if(DetailGrid.activeEditor != null){
				DetailGrid.activeEditor.completeEdit();
			}
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount <= 0) {
			Msg.info("warning", "没有调价记录!");
			return false;
		}

		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);

			//新增或数据发生变化时执行下述操作
			if (rowData.data.newRecord || rowData.dirty) {

				var Incib=rowData.get("Incib");
				var ResultSp = rowData.get("ResultSpUom");
				var ResultRp = rowData.get("ResultRpUom");
				var AdjSpReasonId = rowData.get("AdjReasonId");
				var AdjSpUomId = rowData.get("AspUomId");
				var PriceFileDate = Ext.util.Format.date(rowData
								.get("PreExecuteDate"), ARG_DATEFORMAT);;
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "第" + (i + 1) + "行调后售价不能为空!");
					return false;
					break;
				}

				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "第" + (i + 1) + "行调后售价不能为空!");
					return false;
					break;
				}
				if (Incib!=""&&(AdjSpUomId == null || AdjSpUomId.length <= 0)) {
					Msg.info("warning", "第" + (i + 1) + "行单位不能为空!");
					return false;
					break;
				}
				if (PriceFileDate == null || PriceFileDate.length <= 0) {
					Msg.info("warning", "第" + (i + 1) + "行计划生效日期不能为空!");
					return false;
					break;
				}
				var nowdate = new Date();
				if (PriceFileDate <= nowdate.format(ARG_DATEFORMAT)) {
					Msg.info("warning", "第" + (i + 1) + "行计划生效日期不能小于或等于当前日期!");
					return false;
					break;
				}
				if (Incib!=""&&(AdjSpReasonId == null || AdjSpReasonId.length <= 0)) {
					Msg.info("warning", "第" + (i + 1) + "行调价原因不能为空!");
					return false;
					break;
				}

			}
		}
		return true;
	}

	/**
	 * 保存调价单
	 */
	function save() {
		//调价单号
		var AspBatNo = Ext.getCmp("AspBatNo").getValue();
		var StkGrp = Ext.getCmp("StkGrpType").getValue();
		var list = "";
		//保存明细
		var rowCount = DetailGrid.getStore().getCount();

		if (rowCount == 0)

		{
			Msg.info("warning", "没有调价记录!");
			return;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);

			//新增或数据发生变化时执行下述操作
			if (rowData.data.newRecord || rowData.dirty) {

				var AspBatId = rowData.get("AspBatId");
				var Incib = rowData.get("Incib");
				var IncRowid = rowData.get("InciId");
				if(IncRowid=="" || IncRowid.length<=0){
						continue;
					}

				var PreExecuteDate = Ext.util.Format.date(rowData
								.get("PreExecuteDate"), ARG_DATEFORMAT);
				var IncDesc = rowData.get("InciDesc");
				var AdjSpUomId = rowData.get("AspUomId");
				var ResultSp = rowData.get("ResultSpUom");
				var Maxsp = rowData.get("MaxSp");
				if ((Maxsp!=0 || Maxsp!='') && ResultSp>Maxsp){
					Msg.info("warning", "存在调后售价高于最高售价的批次记录!");
			        return;
					}
				var ResultRp = rowData.get("ResultRpUom");
				var AdjSpReasonId = rowData.get("AdjReasonId");

				var PriceFileNo = rowData.get("WarrentNo");
				var PriceFileDate = Ext.util.Format.date(
						rowData.get("WnoDate"), ARG_DATEFORMAT);;
				var Remark = rowData.get("Remark");
				var PriorRp = rowData.get("PriorRpUom");
				var PriorSp = rowData.get("PriorSpUom");
				var data = AspBatId + "^" + Incib + "^" + PreExecuteDate + "^"
						+ IncRowid + "^" + AdjSpUomId + "^" + ResultSp + "^"
						+ ResultRp + "^" + userId + "^" + AdjSpReasonId + "^"
						+ HospId + "^" + PriceFileNo + "^" + PriceFileDate
						+ "^" + Remark + "^" + PriorRp + "^" + PriorSp;

				if (list == "") {
					list = data;
				} else {
					list = list + xRowDelim() + data;
				}
			}
		}
		if (list == "") {
			Msg.info("warning", "没有需要保存的数据");
			return;
		}
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		var url = DictUrl + "inadjpricebatchaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : {
						AspNo : AspBatNo,
						StkGrp : StkGrp,
						LocId : LocId,
						list : list
					},
					waitMsg : '保存中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						mask.hide();
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							// 回传
							if (AspBatNo == "") {
								AspBatNo = jsonData.info;
								Ext.getCmp("AspBatNo").setValue(AspBatNo);
							}
							AdjPriceSearch();

						} else {
							var ret = jsonData.info;
							var arr = ret.split("^");
							ret = arr[0];
							var InciBtNo = arr[1];
							var IncDesc = arr[2];
							if (ret == -5) {
								Msg.info("error", "批次为" + InciBtNo + "的" + IncDesc+ "存在未生效的调价单，不能新建调价单！");
							} else if (ret == -7) {
								Msg.info("error", "批次为" + InciBtNo + "的" + IncDesc + "当天已调价，不能再建调价单！");
							} else if (ret == -1) {
								Msg.info("error", "批次为" + InciBtNo + "的" + IncDesc + "Id不能为空！");
							} else if (ret == -2) {
								Msg.info("error", "批次为" + InciBtNo + "的" + IncDesc + "无效！");
							} else if (ret == -3) {
								Msg.info("error", IncDesc);
							} else if (ret == -4) {
								Msg.info("error", "计划生效日期不能为空！");
							} else {
								Msg.info("error", IncDesc + "保存失败："
												+ jsonData.info);
							}
						}
					},
					scope : this
				});

	}

	/**
	 * 删除选中行药品
	 */
	function deleteDrug() {

		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var AspBatId = record.get("AspBatId");
		if (AspBatId == null || AspBatId.length <= 0) {
			DetailGrid.getStore().remove(record);
			DetailGrid.getView().refresh();
		} else {
			Ext.MessageBox.show({
						title : '提示',
						msg : '是否确定删除该物资调价信息',
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
			var AspBatId = record.get("AspBatId");;
			// 删除该行数据
			var url = DictUrl
					+ "inadjpricebatchaction.csp?actiontype=DeleteAspBatItm&AspBatId="
					+ AspBatId;
			var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '删除中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();
							if (jsonData.success == 'true') {
								Msg.info("success", "删除成功!");
								DetailGrid.getStore().remove(record);
								DetailGrid.getView().refresh();
							} else {
								Msg.info("error", "删除失败：" + jsonData.info);
							}
						},
						scope : this
					});
		}
	}

		// 单位
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : '单位',
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 120,
					store : ItmUomStore,
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
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var IncRowid = record.get("InciId");
					ItmUomStore.removeAll();
					ItmUomStore.load({params:{ItmRowid:IncRowid}});
				});

		/**
		 * 单位变换事件
		 */
		CTUom.on('select', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					
					var value = combo.getValue();        //目前选择的单位id
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系
					var AdjUom = record.get("AspUomId");    //目前显示的调价单位
					var PriorSpUom = Number(record.get("PriorSpUom"));
					var PriorRpUom = Number(record.get("PriorRpUom"));
					var ResultSpUom = Number(record.get("ResultSpUom"));
					var ResultRpUom = Number(record.get("ResultRpUom"));
					
					if (value == null || value.length <= 0) {
						return;
					} else if (AdjUom == value) {
						return;
					} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
						record.set("PriorSpUom", PriorSpUom.div(ConFac));
						record.set("PriorRpUom", PriorRpUom.div(ConFac));
						record.set("ResultSpUom", ResultSpUom.div(ConFac));
						record.set("ResultRpUom", ResultRpUom.div(ConFac));
						record.set("DiffRpUom", (ResultRpUom.add(-PriorRpUom.div(ConFac))));
						record.set("DiffSpUom", (ResultSpUom.add(-PriorSpUom.div(ConFac))));
					} else{  //新选择的单位为大单位，原先是单位为小单位
						record.set("PriorSpUom", PriorSpUom.mul(ConFac));
						record.set("PriorRpUom", PriorRpUom.mul(ConFac));
						record.set("ResultSpUom", ResultSpUom.mul(ConFac));
						record.set("ResultRpUom", ResultRpUom.mul(ConFac));
						record.set("DiffRpUom", (ResultRpUom.add(-PriorRpUom.mul(ConFac))));
						record.set("DiffSpUom", (ResultSpUom.add(-PriorSpUom.mul(ConFac))));
					}
					record.set("AspUomId", combo.getValue());
				});
				
		ReasonForAdjSpStore.load();
		var AdjSpReason = new Ext.form.ComboBox({
					fieldLabel : '调价原因',
					id : 'AdjSpReason',
					name : 'AdjSpReason',
					anchor : '90%',
					width : 100,
					store : ReasonForAdjSpStore,
					valueField : 'RowId',
					displayField : 'Description',
					//allowBlank : false,
					triggerAction : 'all',
					emptyText : '调价原因...',
					selectOnFocus : true,
					forceSelection : true,
					listWidth : 150,
					minChars : 1,
					valueNotFoundText : '',
					listeners:{
						specialKey:function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addNewRow();
							}
						}
					}
				});


	//录入调后进价后设置调后售价
	function SetMtSp(Rp) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
		var uomId = record.get("AspUomId");
		var inci = record.get("InciId");
		if (inci == null || inci == "") {
			return;
		}
		if (uomId == null || uomId == "") {
			return;
		}
		if (Rp == null || Rp == "") {
			return;
		}

		//根据定价类型计算售价
		if (GetCalSpFlag() == 1) {
            //var url=DictUrl+"inadjpriceaction.csp?actiontype=GetMtSp&InciId="+inci+"&UomId="+uomId+"&Rp="+Rp;
			var sp=tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMtSp",inci,uomId,Rp);      //ExecuteDBSynAccess(url); 返回值有空格导致数据保存不成功
			if (sp == 0) {
				Msg.info("warning", "调后售价为0，请检查定价类型是否正确！");
			}
			record.set("ResultSpUom", sp);
		}
	}
	// 调价明细
	// 访问路径
	var DetailUrl = DictUrl
			+ "inadjpricebatchaction.csp?actiontype=QueryAspBatInfo";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "GET"
			});

	// 指定列参数
	var fields = ["AspBatId", "AspBatNo", "BatExp", "Incib", "StkCatDesc",
			"InciId", "InciCode", "InciDesc", "AspUomId", "AspUomDesc",
			"PriorSpUom", "MaxSp", "ResultSpUom", "DiffSpUom", "PriorRpUom",
			"ResultRpUom", "DiffRpUom", {
				name : 'AdjDate',
				type : 'date',
				dateFormat:DateFormat
			}, {
				name : 'PreExecuteDate',
				type : 'date',
				dateFormat:DateFormat
			}, "MarkType", "WarrentNo", {
				name : "WnoDate",
				type : 'date',
				dateFormat:DateFormat
			}, "AdjReasonId", "AdjReason", "Remark", "AdjUserName", "BUomId",
			"ConFacPur"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "AspBatId",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	DetailStore.on("update", function(store, record, opt) {
				var priorsp = record.get("PriorSpUom");
				var resultsp = record.get("ResultSpUom");
				var priorrp = record.get("PriorRpUom");
				var resultrp = record.get("ResultRpUom");
				record.set("DiffSpUom", Math
								.round((resultsp - priorsp) * 10000)
								/ 10000);
				record.set("DiffRpUom", Math
								.round((resultrp - priorrp) * 10000)
								/ 10000);
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "AspBatId",
				dataIndex : 'AspBatId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "调价单号",
				dataIndex : 'AspBatNo',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "Incib",
				dataIndex : 'Incib',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "RowId",
				dataIndex : 'InciId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'InciDesc',
				width : 230,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField({
							selectOnFocus : true,
							allowBlank : false,
							listeners : {
								specialkey : function(field, e) {
									if (e.getKey() == Ext.EventObject.ENTER) {
										var stkgrp = Ext.getCmp("StkGrpType")
												.getValue();
										IncItmBatWindowAll(field.getValue(),
												stkgrp, App_StkTypeCode, "",
												"N", "0", HospId, "",
												getDrugList2);
									}
								}
							}
						}))
			}, {
				header : "批次/效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "调价单位",
				dataIndex : 'AspUomId',
				width : 80,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(CTUom),
				renderer : Ext.util.Format.comboRenderer2(CTUom, "AspUomId",
						"AspUomDesc")				
			}, {
				header : "调前售价",
				dataIndex : 'PriorSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "调前进价",
				dataIndex : 'PriorRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "调后进价",
				dataIndex : 'ResultRpUom',
				width : 90,
				align : 'right',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.ux.NumberField({
					formatType : 'FmtRP',
					selectOnFocus : true,
					allowBlank : false,
					allowNegative : false,
					listeners : {
						'specialkey' : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var colindex = GetColIndex(DetailGrid,
										"ResultSpUom");
								DetailGrid.startEditing(cell[0], colindex);

							}
						}
					}
				}))
			}, {
				header : "调后售价",
				dataIndex : 'ResultSpUom',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.ux.NumberField({
					formatType : 'FmtSP',
					selectOnFocus : true,
					allowBlank : false,
					allowNegative : false,
					listeners : {
						'specialkey' : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell()

								var colindex = GetColIndex(DetailGrid,
										"PreExecuteDate")
								DetailGrid.startEditing(cell[0], colindex);

							}
						}
					}
				}))
			}, {
				header : "差价(售价)",
				dataIndex : 'DiffSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "差价(进价)",
				dataIndex : 'DiffRpUom',
				width : 90,
				align : 'right',

				sortable : true
			}, {
				header : "最高售价",
				dataIndex : 'MaxSp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "计划生效日期",
				dataIndex : 'PreExecuteDate',
				align : 'right',
				sortable : true,
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				editor : new Ext.ux.DateField({
							selectOnFocus : true,
							allowBlank : false,
							listeners : {
								'specialkey' : function(field, e) {

									if (e.getKey() == Ext.EventObject.ENTER) {
										var cell = DetailGrid
												.getSelectionModel()
												.getSelectedCell();
										var colindex = GetColIndex(DetailGrid,
												"AdjReasonId")
										DetailGrid.startEditing(cell[0],
												colindex);

									}
								}
							}
						})
			}, {
				header : "制单日期",
				dataIndex : 'AdjDate',
				width : 80,
				align : 'right',
				sortable : true,
				renderer : Ext.util.Format.dateRenderer(DateFormat)
			}, {
				header : '实际生效日期',
				width : 80,
				dataIndex : 'ExeDate',
				align : 'right',
				renderer : Ext.util.Format.dateRenderer(DateFormat)
			}, {
				header : "定价类型",
				dataIndex : 'MarkType',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "物价文件号",
				dataIndex : 'WarrentNo',
				width : 80,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField({
							allowBlank : true
						}),
				'specialkey' : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel()
											.getSelectedCell();
							var col = GetColIndex(DetailGrid,'WnoDate');
							DetailGrid.startEditing(cell[0], col);

					}
				}
			}, {
				header : "物价文件日期",
				dataIndex : 'WnoDate',
				width : 60,
				align : 'right',
				sortable : true,
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				editor : new Ext.ux.DateField({
							selectOnFocus : true,
							allowBlank : false
						}),
				'specialkey' : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = DetailGrid.getSelectionModel()
								.getSelectedCell();
						DetailGrid.startEditing(cell[0], 19);

					}
				}
			}, {
				header : "调价原因",
					dataIndex : 'AdjReasonId',
					width:80,
					align:'left',
					sortable:true,
					editor:new Ext.grid.GridEditor(AdjSpReason),
					renderer : Ext.util.Format.comboRenderer2(AdjSpReason,'AdjReasonId','AdjReason')
		}	, {
				header : "制单人",
				dataIndex : 'AdjUserName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'StkCatDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);

	var DetailGrid = new Ext.ux.EditorGridPanel({
				id : 'DetailGrid',
				title : '调价单明细(批次)',
				region : 'center',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				tbar : [AddDetailBT, '-', DelDetailBT],
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				listeners:{
						'beforeedit':function(e){
							if (e.field=='AdjReasonId'){
								if (e.record.data['AdjReasonId']!='') AdjSpReason.setValue(e.record.data['AdjReasonId']);
							}
						},
						'afteredit':function(e){
							if(e.field=='ResultRpUom'){
								var resultRpNew = e.value;
								if (resultRpNew == null || resultRpNew.length <= 0) {
									Msg.info("warning", "调后进价不能为空!");
									return;
								}else if (resultRpNew<0) {
									Msg.info("warning", "调后进价不能小于0!");
									return;
								}else{
									SetMtSp(resultRpNew);
								}
							}else if(e.field=='ResultSpUom'){
								var resultSpNew = e.value;
								if(resultSpNew == null || resultSpNew.length <= 0) {
									Msg.info("warning", "调后售价不能为空!");
									return;
								}else if(resultSpNew<0) {
									Msg.info("warning", "调后售价不能小于0!");
									return;
								}else{
									var resultRpNew = e.record.get("ResultRpUom");
									if(resultSpNew<resultRpNew){
										Msg.info("error", "第"+(e.row+1)+"行调后售价小于调后进价!");
									}
								}
							}else if(e.field=='PreExecuteDate'){
								var PreExeDate = e.value;
								if (Ext.isEmpty(PreExeDate)) {
									Msg.info("warning", "计划生效日期不能为空!");
									e.record.set('PreExecuteDate', e.originalValue);
								}else if (PreExeDate.format(ARG_DATEFORMAT) <= new Date().format(ARG_DATEFORMAT)) {
									Msg.info("warning", "计划生效日期不能小于或等于当前日期!");
									e.record.set('PreExecuteDate', e.originalValue);
								}
							}
						}
						
					}
			});

	DetailGrid.addListener("rowclick", function(grid, rowindex, e) {
				if (rowindex >= 0) {
					var record = DetailGrid.getStore().getAt(rowindex);
					var aspno = record.get("AspBatNo");
					if (aspno != null & aspno != "") {
						Ext.getCmp("AspBatNo").setValue(aspno);
					}
				}
			});

	//检查是否已经录入了某药品的调价记录
	function CheckRepeatItm(incib) {
		var flag = false; //不重复
		var rowCount = DetailGrid.getStore().getCount() - 1;
		for (var i = rowCount - 1; i >= 0; i--) {
			var rowData = DetailGrid.getStore().getAt(i);
			var incIB = rowData.get("Incib");
			if (incIB == incib) {
				flag = true;
				break;
			}
		}

		return flag;
	}
	
	/**
	 * 返回方法
	 */
	function getDrugList2(records) {
		records = [].concat(records);
		if (records == null || records == "") {
			return;
		}
		Ext.each(records, function(record, index, allItems) {
			var incib = record.get("Incib");
			var inciDr = record.get("InciDr");
			var inciCode = record.get("InciCode");
			var inciDesc = record.get("InciDesc");
			var batExp = record.get("BatExp");
			var rp = record.get("Rp");
			var sp = record.get("Sp");
			var ResultRp=record.get("ResultRp")
			var ResultBatSp=record.get("ResultBatSp")
			if(Ext.isEmpty(ResultRp)){ResultRp=0}
			if(Ext.isEmpty(ResultBatSp)){ResultBatSp=0}
			
			var Rowcount=DetailGrid.getStore().getCount();
			if (Rowcount==1){
				var AdjReasonId=record.get("AdjReasonId");
				var AdjReason=record.get("AdjReason");
			}else{
				var AdjReasonId=record.get("AdjReasonId");
				var AdjReason=record.get("AdjReason");
				if(IfSetAspReason()=='Y' && Ext.isEmpty(AdjReasonId)){
					var rowData = DetailStore.data.items[Rowcount - 2];
					AdjReasonId=rowData.get("AdjReasonId");
					AdjReason=rowData.get("AdjReason");
				}
			}
			if (CheckRepeatItm(incib) == true) {
				Msg.info("warning", "批次为"+batExp+"的"+inciDesc+"调价记录已经录入，不能重复录入");
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			// 选中行
			var row = cell[0];
			var rowData = DetailGrid.getStore().getAt(row);
			rowData.set("Incib", incib);
			rowData.set("InciId", inciDr);
			rowData.set("InciCode", inciCode);
			rowData.set("InciDesc", inciDesc);
			rowData.set("BatExp", batExp)
			rowData.set("PriorSpUom", sp);
			rowData.set("PriorRpUom", rp);
			rowData.set("ResultSpUom", ResultBatSp);
			rowData.set("ResultRpUom", ResultRp);
			addComboData(ReasonForAdjSpStore, AdjReasonId, AdjReason);
			rowData.set("AdjReasonId", AdjReasonId);
			
			//取其它药品信息//modify 由于价格信息都从in_adjpricebatch调取，此处调用的都是药品的辅助信息故不用再重写
			var url = DictUrl
					+ "inadjpriceaction.csp?actiontype=GetItmInfo&InciId="
					+ inciDr + "&Params=" + GroupId + "^" + LocId + "^"
					+ userId;
			var response=ExecuteDBSynAccess(url);
			var jsonData=Ext.util.JSON.decode(response);
				if (jsonData.success == 'true') {
				//alert(jsonData)
				var data = jsonData.info.split("^");
				rowData.set("StkCatDesc", data[3]);
				rowData.set("MarkType", data[5]);
				rowData.set("WarrentNo", data[10]);
				rowData.set("MaxSp", data[13]);
				var BUomId = data[6];
				var BUomDesc = data[7];
				var PurUomId = data[8];
				var PurUomDesc = data[9];
				var ConFacPur = data[14]; //大单位到小单位之间的转换关系

				addComboData(ItmUomStore, PurUomId, PurUomDesc);
				rowData.set("AspUomId", PurUomId); //默认为大单位调价
				//rowData.set("PriorSpUom", data[11]); 
				//rowData.set("PriorRpUom", data[12]); 
				rowData.set("BUomId", BUomId);
				rowData.set("ConFacPur", ConFacPur);

				var ss = new Date().format(ARG_DATEFORMAT)
				rowData.set("AdjDate", Date.parseDate(ss,
								ARG_DATEFORMAT));
				var lastIndex = DetailStore.getCount()-1;
				if(DetailStore.getAt(lastIndex).get('incib')!=""){
				addNewRow();
				}else{
				var col=GetColIndex(DetailGrid,'inciDesc')
				DetailGrid.startEditing(lastIndex,col);
				}
			}
						
		})
	}

	
	var HisListTab = new Ext.ux.FormPanel({
		region : 'north',
		height : 180,
		title : '调价单录入(批次)',
		tbar : [SearchBT, '-', ClearBT, '-', AddBT, '-', SaveBT],
		items : [{
					xtype : 'fieldset',
					title : '查询信息--<font color=blue>蓝色字体显示的项目既是查询条件也是调价录入限制条件</font>',
					layout : 'column',
					defaults : {
						border : false
					},
					items : [{
								columnWidth : .3,
								xtype : 'fieldset',
								items : [StartDate, EndDate]
							}, {
								columnWidth : .3,
								xtype : 'fieldset',
								items : [StkGrpType, AspBatNo]
							}, {
								columnWidth : .4,
								xtype : 'fieldset',
								items : [IncDesc]
							}]

				}]

	});

	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, DetailGrid],
				renderTo : 'mainPanel'
			});
})