// /名称: 库存转移制单
// /描述: 库存转移制单
// /编写者：zhangdongmei
// /编写日期: 2012.07.18
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
	var ProType=GetRecTransType();
	ChartInfoAddFun();
	function ChartInfoAddFun() {
		
	
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('供给部门'),
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('供给部门...'),
					groupId:gGroupId,
		                     listeners : {
			                 'select' : function(e) {
                                      var SelLocId=Ext.getCmp('SupplyPhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
                                      StkGrpType.getStore().removeAll();
                                      StkGrpType.getStore().setBaseParam("locId",SelLocId)
                                      StkGrpType.getStore().setBaseParam("userId",userId)
                                      StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                                      StkGrpType.getStore().load();
                                      GetParam(e.value);	//修改供给科室后,以供给科室配置为准
                                      
			               }
	                        }
				});
		SupplyPhaLoc.on('change', function(e) {
	    Ext.getCmp("RequestPhaLoc").setValue("");
       });
        // 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('请求部门'),
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('请求部门...'),
					defaultLoc:{},
					relid:Ext.getCmp("SupplyPhaLoc").getValue(),
					protype:ProType,
					params : {relid:'SupplyPhaLoc'}
		});
		// 药品类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200,
			fieldLabel : $g('类　　组')
		}); 

		// 出库类型
		var OperateOutType = new Ext.ux.ComboBox({
			fieldLabel : $g('出库类型'),
			id : 'OperateOutType',
			name : 'OperateOutType',
			store : OperateOutTypeStore,
			valueField : 'RowId',
			displayField : 'Description'
		});
		OperateOutTypeStore.load();
		// 默认选中第一行数据
		OperateOutTypeStore.on('load', function() {
               setDefaultOutType();
		});
	  function setDefaultOutType()
	  {
		var operatecount=OperateOutTypeStore.getTotalCount();
		if (operatecount > 0){	
			var operatei=0;
			for (operatei = 0; operatei < operatecount; operatei++) {
				var defaultflag=OperateOutTypeStore.getAt(operatei).data.Default;
				if (defaultflag == "Y") {
					OperateOutType.setValue(OperateOutTypeStore.getAt(operatei).data.RowId);
				}
			}
			if (OperateOutType.getValue() == "") {  //没有默认默认第一条
				OperateOutType.setValue(OperateOutTypeStore.getAt(0).data.RowId);
			}
		}
	  }
		// 转移单号
		var InItNo = new Ext.form.TextField({
					fieldLabel : $g('转移单号'),
					id : 'InItNo',
					name : 'InItNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});
			//=========统计添加=======		
		// 当页条数
		var NumAmount = new Ext.form.TextField({
					emptyText : $g('当页条数'),
					id : 'NumAmount',
					name : 'NumAmount',
					anchor : '90%',
					width:200
				});	
		// 进价合计
		var RpAmount = new Ext.form.TextField({
					emptyText : $g('进价合计'),
					id : 'RpAmount',
					name : 'RpAmount',
					width:200,
					anchor : '90%'
				});			
		// 售价合计
		var SpAmount = new Ext.form.TextField({
					emptyText : $g('售价合计'),
					id : 'SpAmount',
					name : 'SpAmount',
					anchor : '90%',
					width:200
				});
		//zhangxiao20130815			
		function GetAmount(){
			var RpAmt=0
			var SpAmt=0
			var Count = DetailGrid.getStore().getCount();
			for (var i = 0; i < Count; i++) {
				var rowData = DetailStore.getAt(i);
				var RecQty = rowData.get("qty");
				var Rp = rowData.get("rp");
				var Sp = rowData.get("sp");
				var RpAmt1=accMul(Rp,RecQty);
				var SpAmt1=accMul(Sp,RecQty);
			    RpAmt=RpAmt+RpAmt1;
			    SpAmt=SpAmt+SpAmt1;
				}
			Count=$g("当前条数:")+" "+Count	
			RpAmt=$g("进价合计:")+" "+FormatGridRpAmount(RpAmt)+" "+$g("元")
			SpAmt=$g("售价合计:")+" "+FormatGridRpAmount(SpAmt)+" "+$g("元")
			Ext.getCmp("NumAmount").setValue(Count)	
			Ext.getCmp("RpAmount").setValue(RpAmt)	
			Ext.getCmp("SpAmount").setValue(SpAmt)	
			}		
		//=========统计添加=======	

		// 日期
		var InItDate = new Ext.form.DateField({
					fieldLabel : $g('制单日期'),
					id : 'InItDate',
					name : 'InItDate',
					anchor : '90%',
					width : 120,
					value : new Date(),
					disabled : true
				});

		// 完成
		var InItFlag = new Ext.form.Checkbox({
					fieldLabel : $g('完　　成'),
					id : 'InItFlag',
					name : 'InItFlag',
					anchor : '90%',
					width : 120,
					checked : false,
					disabled : true
				});

		// 备注
		var Remark = new Ext.form.TextField({
					fieldLabel : $g('备　　注'),
					id : 'Remark',
					name : 'Remark',
					anchor : '90%',
					width : 120,
					disabled : false
				});

		//请求单号
		var ReqNo = new Ext.form.TextField({
					fieldLabel : $g('请求单号'),
					id : 'ReqNo',
					name : 'ReqNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});
				
				//请求单号
		var ReqNoID = new Ext.form.TextField({
					fieldLabel : $g('请求单号ID'),
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
					text : $g('查询'),
					tooltip : $g('点击查询转移单'),
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						if(Ext.getCmp("SupplyPhaLoc").getValue()==""){
							Msg.info("warning",$g("供给部门不可为空!"));
							return;
						}
						StockTransferSearch(DetailStore,Query);
					}
				});


		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					id : "ClearBT",
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
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
			SetLogInDept(SupplyPhaLoc.getStore(),'SupplyPhaLoc');
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItNo").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			Ext.getCmp("ReqNo").setValue("");
			Ext.getCmp("ReqNoID").setValue("");
			Ext.getCmp("StkGrpType").setDisabled(false);
			gInitId="";
			//=====zhangxiao20130816===
			Ext.getCmp("NumAmount").setValue("");
			Ext.getCmp("RpAmount").setValue("");
			Ext.getCmp("SpAmount").setValue("");
			//=====zhangxiao20130816===
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// 变更按钮是否可用
			//查询^清除^新建^保存^删除^完成^取消完成
			changeButtonEnable("1^1^1^0^0^0^0");
		}

		// 新建按钮
		var AddBT = new Ext.Toolbar.Button({
					id : "AddBT",
					text : $g('增加一条'),
					tooltip : $g('点击增加'),
					width : 70,
					height : 30,
					iconCls : 'page_add',
					handler : function() {
						if(gParam[7]=='Y'){
							Msg.info("warning",$g("只能根据请求单转移制单,不可新增记录!"));
							return;
						}
						// 判断转移单是否已完成
						var initFlag = Ext.getCmp("InItFlag").getValue();
						if (initFlag != null && initFlag != 0) {
							Msg.info("warning", $g("转移单已完成不可修改!"));
							return;
						}

						var requestphaLoc = Ext.getCmp("RequestPhaLoc")
								.getValue();
						if (requestphaLoc == null || requestphaLoc.length <= 0) {
							Msg.info("warning", $g("请选择请求部门!"));
							return;
						}
						var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
								.getValue();
						if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
							Msg.info("warning", $g("请选择供应部门!"));
							return;
						}
						if (requestphaLoc == supplyphaLoc) {
							Msg.info("warning", $g("请求部门和供应部门不能相同!"));
							return;
						}
		                var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();			
                
                                          //var StkGrpType = Ext.getCmp("StkGrpType").getValue();
                        if ((StkGrpType == null || StkGrpType.length <= 0)&(gParamCommon[9]=="N")) {
			            	Msg.info("warning", $g("请选择类组!"));
			                return;
			            }
						var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
						if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", $g("请选择出库类型!"));
							return;
						}

						// 判断是否已经有添加行
						var rowCount = DetailGrid.getStore().getCount();
						if (rowCount > 0) {
							var rowData = DetailStore.data.items[rowCount - 1];
							var data = rowData.get("inci");	//initi --> inci
							if (data == null || data.length <= 0) {
								//Msg.info("warning", "已存在新建行!");
								DetailGrid.startEditing(DetailStore.getCount() - 1, 4);
								return;
							}
						}
						Ext.getCmp("StkGrpType").setDisabled(true);
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
			// 判断是否已经有添加行
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("inci");
				if (data == null || data.length <= 0) {
					var colindex=GetColIndex(DetailGrid,"inciDesc");
					DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
					return;
				}
			}
			var record = Ext.data.Record.create([{
						name : 'initi',
						type : 'string'
					}, {
						name : 'inrqi',
						type : 'string'
					}, {
						name : 'inci',
						type : 'string'
					}, {
						name : 'inciCode',
						type : 'string'
					}, {
						name : 'inciDesc',
						type : 'string'
					}, {
						name : 'inclb',
						type : 'string'
					}, {
						name : 'batexp',
						type : 'string'
					}, {
						name : 'manfName',
						type : 'string'
					}, {
						name : 'inclbQty',
						type : 'double'
					}, {
						name : 'qty',
						type : 'double'
					}, {
						name : 'uom',
						type : 'string'
					}, {
						name : 'sp',
						type : 'double'
					}, {
						name : 'reqQty',
						type : 'double'
					}, {
						name : 'stkbin',
						type : 'string'
					}, {
						name : 'reqLocStkQty',
						type : 'double'
					}, {
						name : 'spec',
						type : 'string'
					}, {
						name : 'gene',
						type : 'string'
					}, {
						name : 'formDesc',
						type : 'string'
					}, {
						name : 'spAmt',
						type : 'double'
					}, {
						name : 'rp',
						type : 'double'
					}, {
						name : 'ConFac',
						type : 'double'
					}, {
						name : 'BUomId',
						type : 'string'
					}, {
						name : 'inclbDirtyQty',
						type : 'double'
					}, {
						name : 'dirtyQty',
						type : 'double'
					},{
						name : 'inclbAvaQty',
						type : 'double'
					}, {
						name : 'remark',
						type : 'string'
					}, {
						name : 'InsuCode',
						type : 'string'
					}, {
						name : 'InsuDesc',
						type : 'string'
					}
					
					]);
			var NewRecord = new record({
						initi : '',
						inrqi : '',
						inci : '',
						inciCode : '',
						inciDesc : '',
						inclb : '',
						batexp : '',
						manfName : '',
						inclbQty : '',
						qty : '',
						uom : '',
						sp : '',
						reqQty : '',
						stkbin : '',
						reqLocStkQty : '',
						spec : '',
						gene : '',
						formDesc : '',
						spAmt : '',
						rp : '',
						ConFac : 0,
						BUomId : '',
						dirtyQty:0,
						inclbDirtyQty : '',
						inclbAvaQty : '',
						remark : '',
						InsuCode:'',
						InsuDesc:''
					});
			DetailStore.add(NewRecord);
			var colindex=GetColIndex(DetailGrid,"inciDesc");
			DetailGrid.getSelectionModel().select(DetailStore.getCount() - 1, colindex);
			DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
			changeElementEnable();
		};

		// 保存按钮
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : $g('保存'),
					tooltip : $g('点击保存'),
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {
						Ext.getCmp("SaveBT").disable();
						setTimeout(ChangeSaveBtn,3000);//三秒后执行
						if(gParam[7]=='Y'){
							Msg.info("warning",$g("只能根据请求单转移制单,不可保存新记录!"));
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
		function ChangeSaveBtn()
		{
			Ext.getCmp("SaveBT").enable();
		}		
		/**
		 * 保存出库单前数据检查
		 */		
		function CheckDataBeforeSave() {
					
			// 判断转移单是否已完成
			var initFlag = Ext.getCmp("InItFlag").getValue();
			if (initFlag != null && initFlag != 0) {
				Msg.info("warning", $g("转移单已完成不可修改!"));
				return false;
			}

			var requestphaLoc = Ext.getCmp("RequestPhaLoc")
					.getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", $g("请选择请求部门!"));
				return false;
			}
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
					.getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", $g("请选择供应部门!"));
				return false;
			}
			if (requestphaLoc == supplyphaLoc) {
				Msg.info("warning", $g("请求部门和供应部门不能相同!"));
				return false;
			}
		       var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();			
                
                     //var StkGrpType = Ext.getCmp("StkGrpType").getValue();
                      if ((StkGrpType == null || StkGrpType.length <= 0)&(gParamCommon[9]=="N")) {
			   Msg.info("warning", $g("请选择类组!"));
			    return;
			  }
			var operatetype = Ext.getCmp("OperateOutType")
					.getValue();
			if (operatetype == null || operatetype.length <= 0) {
				Msg.info("warning", $g("请选择出库类型!"));
				return false;
			}
			// 1.判断转移药品是否为空
			var rowCount = DetailGrid.getStore().getCount();
			// 有效行数
			var count = 0;
			for (var i = 0; i < rowCount; i++) {
				var item = DetailStore.getAt(i).get("inci");
				if (item != undefined) {
					count++;
				}
			}
			if (rowCount <= 0 || count <= 0) {
				Msg.info("warning", $g("请输入转移明细!"));
				return false;
			}
			// 2.重新填充背景
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			// 3.判断重复输入批次库存药品
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var item_i = DetailStore.getAt(i).get("inclb");;
					var item_j = DetailStore.getAt(j).get("inclb");;
					if (item_i != undefined && item_j != undefined
							&& item_i == item_j) {
						changeBgColor(i, "yellow");
						changeBgColor(j, "yellow");
						Msg.info("warning", $g("药品批次重复，请重新输入!"));
						return false;
					}
				}
			}
			// 4.药品信息输入错误
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var code = rowData.get("inciCode");
				if (code == null || code.length == 0) {
					continue;
				}
				var item = rowData.get("inci");
				if (item == undefined) {
					Msg.info("warning", $g("药品信息输入错误!"));
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				var qty = DetailStore.getAt(i).get("qty");
				if ((item != undefined) && (qty == null || qty <= 0)) {
					Msg.info("warning", $g("转移数量不能小于或等于0!"));
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				var initi = DetailStore.getAt(i).get("initi") || '';
				var avaQty = DetailStore.getAt(i).get("inclbAvaQty");
				var dirtyQty=DetailStore.getAt(i).get("dirtyQty");    //本次占用数量
				var inclbQty=DetailStore.getAt(i).get("inclbQty");    //批次数量
				var inclbDirtyQty=DetailStore.getAt(i).get("inclbDirtyQty");    //占用总数
				var NewAvaQty=inclbQty-(inclbDirtyQty-dirtyQty)
				//alert(initi+"^"+qty+"^"+NewAvaQty)
				if ((item != undefined) && ( (initi==""&&(qty - avaQty-dirtyQty) > 0)) ||(initi!=""&&(qty-NewAvaQty)>0)) {
					Msg.info("warning", $g("转移数量不能大于可用库存数量!"));
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				
				//新增转移数量是否允许小数判断 2020-02-20 yangsj
                if(gParam[11]!="Y")  //Y 允许录入小数
                {
	                
                    var buomId=rowData.get("BUomId")
                    var uom=rowData.get("uom")
                    var buomQty=qty
                    if(buomId!=uom)
                    {
                        var fac=rowData.get("ConFac")
                        buomQty=Number(fac).mul(qty);
                    }
                    if((buomQty.toString()).indexOf(".")>=0)
                    {
	                    Msg.info("warning", rowData.get("inciDesc")+$g(" 转移数量换算成基本单位之后存在小数，不能转移出库！请核对转移出库配置：转移数量换算为基本单位是否允许小数!"));
	                    return;
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
		//alert(remark)	
			var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
					+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
			//明细id^批次id^数量^单位^请求明细id^备注
			var ListDetail="";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				//新增或数据发生变化时执行下述操作

				if(rowData.data.newRecord || rowData.dirty){
					var Initi = rowData.get("initi");
					var Inclb = rowData.get("inclb");
					if((Inclb!="")&&(Inclb!=null)){
						var Qty = rowData.get("qty");
						var UomId = rowData.get("uom");
						var ReqItmId = rowData.get("inrqi");
						var Remark = rowData.get("remark");
					
						var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
								+ ReqItmId + "^" + Remark;	
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if ((gInitId=="")&&(ListDetail==""))
			{
					Msg.info("warning",$g("没有需要保存的数据!"));
					return false;
			}
			if(!IsFormChanged(HisListTab) && (ListDetail=="")){
				Msg.info("warning",$g("没有需要保存的数据!"));
				return false;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Save";
			var loadMask=ShowLoadMask(Ext.getBody(),$g("处理中..."));
			Ext.Ajax.request({
						url : url,
						params:{Rowid:gInitId,MainInfo:MainInfo,ListDetail:ListDetail},
						method : 'POST',
						waitMsg : $g('处理中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 刷新界面
								var InitRowid = jsonData.info;
								Msg.info("success", $g("保存成功!"));
								// 7.显示出库单数据
								Query(InitRowid);
								//根据参数设置自动打印
								if(gParam[3]=='Y'){
									PrintInIsTrf(InitRowid,gParam[8]);
								}
							} else {
								var ret=jsonData.info;								
								Msg.info("error", $g("保存不成功：")+ret);								
							}
						},
						scope : this
					});
			loadMask.hide();
		}

		// 删除按钮
		var DeleteBT = new Ext.Toolbar.Button({
					id : "DeleteBT",
					text : $g('删除'),
					tooltip : $g('点击删除'),
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
				Msg.info("warning", $g("转移单已完成不能删除!"));
				return;
			}

			var inItNo = Ext.getCmp("InItNo").getValue();
			if (inItNo == null || inItNo.length <= 0) {
				Msg.info("warning", $g("没有需要删除的转移单!"));
				return;
			}

			Ext.MessageBox.show({
						title : $g('提示'),
						msg : $g('是否确定删除整张转移单?'),
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
							waitMsg : $g('查询中...'),
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									// 删除单据
									Msg.info("success", $g("转移单删除成功!"));
									clearData();
								} else {
									Msg.info("error", $g("转移单删除失败:")+jsonData.info);
								}
							},
							scope : this
						});
			}
		}

		/**
		 * 删除选中行药品
		 */
		function deleteDetail() {
			// 判断转移单是否已完成
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", $g("转移单已完成不能删除!"));
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", $g("没有选中行!"));
				return;
			}
			// 选中行
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var InItIRowId = record.get("initi");
			if (InItIRowId == null || InItIRowId.length <= 0) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
				changeElementEnable();
				GetAmount();
			} else {
				Ext.MessageBox.show({
							title : $g('提示'),
							msg :$g( '是否确定删除该药品信息?'),
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
							waitMsg : $g('查询中...'),
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", $g("删除成功!"));
									DetailGrid.getStore().remove(record);
									DetailGrid.getView().refresh();
									changeElementEnable();
									GetAmount();
								} else {
									Msg.info("error", $g("删除失败!"));
								}
							},
							scope : this
						});
			}
		}

		// 完成按钮
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : $g('完成'),
					tooltip : $g('点击完成'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						var InItFlag = Ext.getCmp('InItFlag').getValue();
			            var mod = isDataChanged();
			            if (mod && (!InItFlag)) {
			                Ext.Msg.confirm($g('提示'), $g('数据已发生改变,是否需要保存后完成?'),
			                    function(btn) {
			                        if (btn == 'yes') {
			                            return;
			                        } else {
			                            Complete();
			                        }

			                    }, this);
			            } else {
			                Complete();
			            }
					}
				});

		function isDataChanged() {
	        var changed = false;
	        var count1 = DetailGrid.getStore().getCount();
	        //看主表数据是否有修改
	        //修改为主表有修改且子表有数据时进行提示
	        if ((IsFormChanged(HisListTab)) && (count1 != 0)) {
	            changed = true;
	        };
	        if (changed) return changed;
	        //看明细数据是否有修改
	        var count = DetailGrid.getStore().getCount();
	        for (var index = 0; index < count; index++) {
	            var rec = DetailGrid.getStore().getAt(index);
	            //新增或数据发生变化时执行下述操作
	            if (rec.data.newRecord || rec.dirty) {
	                changed = true;
	            }
	        }
	        return changed;
	    }
	    
		/**
		 * 完成转移单
		 */
		function Complete() {
			// 判断转移单是否已完成
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", $g("转移单已完成!"));
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", $g("没有需要完成的转移单!"));
				return;
			}
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount<1){
				Msg.info('warning',$g('转移单明细无数据,无需完成!'));
				return;
			}
			var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();			
			//var StkGrpType = Ext.getCmp("StkGrpType").getValue();
			if ((StkGrpType == null || StkGrpType.length <= 0)&(gParamCommon[9]=="N")) {
				Msg.info("warning", $g("请选择类组!"));
				return;
			}
			var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
		    if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", $g("请选择出库类型!"));
							return;
						}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=11&Complete=Y&Type='+operatetype;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('查询中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", $g("成功!"));
								Ext.getCmp("InItFlag").setValue(1);
								
								//查询^清除^新建^保存^删除^完成^取消完成
								changeButtonEnable("1^1^0^0^0^0^1");
							} else {
								Msg.info("error", $g("失败:")+jsonData.info);
							}
						},
						scope : this
					});
		}

		// 取消完成按钮
		var CancelCmpBT = new Ext.Toolbar.Button({
					id : "CancelCmpBT",
					text : $g('取消完成'),
					tooltip : $g('点击取消完成'),
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
				Msg.info("warning",$g( "转移单尚未完成!"));
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", $g("没有需要取消完成的转移单!"));
				return;
			}
			var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
		    if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", $g("请选择出库类型!"));
							return;
						}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=10&Complete=N'+'&Type='+operatetype;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('查询中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", $g("成功!"));
								Ext.getCmp("InItFlag").setValue(0);
								
								//查询^清除^新建^保存^删除^完成^取消完成
								changeButtonEnable("1^1^1^1^1^1^0");
								
							} else {
								Msg.info("error", $g("失败：")+jsonData.info);
							}
						},
						scope : this
					});
		}

		// 删除明细
		var DeleteDetailBT = new Ext.Toolbar.Button({
					id : "DeleteDetailBT",
					text : $g('删除一条'),
					tooltip : $g('点击删除'),
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					//disabled : true,
					handler : function() {
						deleteDetail();
					}
		});
		
		// 请求单按钮
		var SelReqBT = new Ext.Toolbar.Button({
				id : "SelReqBT",
				text : $g('选取请求单'),
				tooltip : $g('点击查询请求单'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
					if(FrLoc==null){
						Msg.info("warning",$g("请选择供应科室!"))
						return;
					}
					SelReq(FrLoc,Query);
				}
		});
		
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					text : $g('打印'),
					tooltip : $g('点击打印'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						if (gInitId ==null || gInitId=="") {
							Msg.info("warning", $g("没有需要打印的转移单!"));
							return;
						}
						PrintInIsTrf(gInitId,gParam[8]);
					}
				});
				
		// 单位
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : $g('单位'),
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
						waitMsg : $g('查询中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								var list = jsonData.info.split("^");
								//alert("jsonData.info="+jsonData.info)
								if (list.length > 0) {
									gInitId=InitRowid;
									Ext.getCmp("InItNo").setValue(list[8]);
									addComboData(SupplyPhaLoc.getStore(),list[6],list[26]);
									Ext.getCmp("SupplyPhaLoc").setValue(list[6]);
									addComboData(RequestPhaLoc.getStore(),list[12],list[27]);
									Ext.getCmp("RequestPhaLoc").setValue(list[12]);
								    //OperateOutTypeStore.load();
								    addComboData(OperateOutType.getStore(),list[21],list[33]);
									Ext.getCmp("OperateOutType").setValue(list[21]);
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
		// 显示出库单明细数据
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
		'dhcinistrfaction.csp?actiontype=QueryInIsTrfDetail&Parref=&start=0&limit=999';
			//'dhcinistrfaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
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
				"pp", "spec", "gene", "formDesc","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", 
				"inclbDirtyQty", "inclbAvaQty","TrUomDesc","dirtyQty","InsuCode",
				"InsuDesc"
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
		DetailStore.on('load', function() {
              changeElementEnable();
		});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : $g("转移细项RowId"),
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("药品RowId"),
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('药品代码'),
					dataIndex : 'inciCode',
					width : 80,
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
										Msg.info("warning", $g("转移单已完成不可修改!"));
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
					header : $g('药品名称'),
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
										Msg.info("warning", $g("转移单已完成不可修改!"));
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
					header : $g("批次RowId"),
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("批号/效期"),
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("生产企业"),
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("可用数量"),
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("转移数量"),
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.ux.NumberField({
						selectOnFocus : true,
						formatType:'FmtSQ',
						allowBlank : false,
						allowNegative: false, 
						listeners : {
							specialkey : function(field, e) {
								var rowCount = DetailGrid.getStore().getCount();
								if (e.getKey() == Ext.EventObject.ENTER) {
									// 判断转移单是否已完成
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning", $g("转移单已完成不可修改!"));
										return;
									}
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", $g("转移数量不能为空!"));
										return;
									}
									if (qty <= 0) {
										Msg.info("warning",$g( "转移数量不能小于或等于0!"));
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var salePriceAMT = accMul(record.get("sp"),qty);
									record.set("spAmt",	salePriceAMT);
									var AvaQty = record.get("inclbAvaQty");
									
									var initi = record.get("initi") || '';
									var dirtyQty=record.get("dirtyQty");    //本次占用数量
									var inclbQty=record.get("inclbQty");    //批次数量
									var inclbDirtyQty=record.get("inclbDirtyQty");    //总占用数
									var NewAvaQty=inclbQty-(inclbDirtyQty-dirtyQty)
									//alert(initi+"^"+qty+"^"+NewAvaQty)
									
									if ((initi==""&&qty > AvaQty)||(initi!=""&&qty>NewAvaQty)) {
										Msg.info("warning", $g("转移数量不能大于可用库存数量!"));
										return;
									}
									
									//新增转移数量是否允许小数判断 2020-02-20 yangsj
		                            if(gParam[11]!="Y")  //"Y" 允许录入小数
		                            {
			                            var buomId=record.get("BUomId")
			                            var uom=record.get("uom")
			                            var buomQty=qty
			                            if(buomId!=uom)
			                            {
				                            var fac=record.get("ConFac")
				                            buomQty=Number(fac).mul(qty);
			                            }
			                            if((buomQty.toString()).indexOf(".")>=0)
			                            {
				                            Msg.info("warning", $g("转移数量换算成基本单位之后存在小数，不能转移出库！请核对转移出库配置：转移数量换算为基本单位是否允许小数!"));
			                                return;
			                            }
			                            
		                            }
									
									
									// 新增一行
									addNewRow();
									GetAmount();
								}
								if(e.getKey()==Ext.EventObject.UP){  //yunhaibao,20160420
									if(event.keyCode==38){
										if(event.preventDefault){event.preventDefault();}
										else {event.keyCode=38;} 
									}
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning", $g("转移单已完成不可修改!"));
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
                                    var row=cell[0]-1;
									var col=GetColIndex(DetailGrid,"qty");
                                    if(row>=0){
                                        DetailGrid.getSelectionModel().select(row,col);
                                        DetailGrid.startEditing(row,col);
                                    }
                                }
						
                                if(e.getKey()==Ext.EventObject.DOWN){
									if(event.keyCode==40){
										if(event.preventDefault){event.preventDefault();}
										else {event.keyCode=40;} 
									}
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning",$g( "转移单已完成不可修改!"));
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
                                    var row=cell[0]+1;
									var col=GetColIndex(DetailGrid,"qty");
                                    if(row<rowCount){
                                        DetailGrid.getSelectionModel().select(row,col);
                                        DetailGrid.startEditing(row,col);
                                    }
                                }
							}
						}
					})
				}, {
					header : $g("转移单位"),
					dataIndex : 'uom',
					width : 80,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","TrUomDesc"), // pass combo instance to reusable renderer					
					editor : new Ext.grid.GridEditor(CTUom)
				}, {
					header :$g("进价"),
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("售价"),
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("请求数量"),
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("货位码"),
					dataIndex : 'stkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("请求方库存"),
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("批次库存"),
					dataIndex : 'inclbQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : $g("本次占用数量"),
					dataIndex : 'dirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("占用数量"),
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("批次售价"),
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("处方通用名"),
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("剂型"),
					dataIndex : 'formDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("售价金额"),
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',					
					sortable : true,
        			renderer:FormatGridSpAmount
				}, {
					header : $g("转换率"),
					dataIndex : 'ConFac',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "基本单位"),
					dataIndex : 'BUomId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "转移请求子表RowId"),
					dataIndex : 'inrqi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "国家医保编码"),
					dataIndex : 'InsuCode',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "国家医保名称"),
					dataIndex : 'InsuDesc',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}
				
				 ]);
		var GridColSetBT = new Ext.Toolbar.Button({
			text:$g('列设置'),
			tooltip:$g('列设置'),
			iconCls:'page_gear',
			handler:function(){
			GridColSet(DetailGrid,"DHCSTTRANSFER");
			}
		});
		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title:$g('库存转移单'),
					tbar:[AddBT,'-',DeleteDetailBT,'-',GridColSetBT],
					region : 'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					bbar:new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]}),
					clicksToEdit : 1
				});
		 DetailGrid.getView().on('refresh',function(Grid){
			GetAmount();
			})
		DetailGrid.on('afteredit',function(e){    //yunhaibao,处理上下键修改数量验证计算金额问题
			if(e.field=="qty"){
				/*if (e.value == null || e.value.length <= 0) {
					Msg.info("warning", "转移数量不能为空!");
					return;
				}
				if (e.value <= 0) {
					Msg.info("warning", "转移数量不能小于或等于0!");
					return;
				}
				if (e.record.get("inclbAvaQty")<e.value)
				{
					Msg.info("warning", "转移数量不能大于可用数量!");
					return;
				}*/
				var salePriceAMT = e.record.get("sp")* e.value;
				//var realPriceAMT = e.record.get("rp")* e.value;
				e.record.set("spAmt",salePriceAMT);	
				//e.record.set("rpAmt",realPriceAMT);	
				GetAmount();
			}
		})
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
					text: $g('删除' )
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
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", "",phaLocRQ,
						returnInfo);
			}
		}
		
		/**
		 * 返回数据信息
		 */
		function returnInfo(record) {
			if (record == null || record == "") {
				return;
			}
		//for(var i=0;i<record.length;i++){
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			// 检核重复批次
			var INITIINCLBDR = record.get("Inclb");
			var INCLBWARNFLAG= record.get("InclbWarnFlag");
			if (INCLBWARNFLAG=="1"){
				if (gParam[10]=="Y"){
					Msg.info("warning", $g("此药品该批次已过期,请重新录入"));  //提示+限制
					var colindex=GetColIndex(DetailGrid,"inciDesc");
					if(colindex>0){
						DetailGrid.getSelectionModel().select(selectRow, colindex);
						DetailGrid.startEditing(selectRow, colindex);
					}
					return;
				}
				else{
					Msg.info("warning",$g( "此药品该批次已过期!"));  //仅提示
				}
			}
			else if (INCLBWARNFLAG=="2"){
				Msg.info("warning", $g("此药品该批次状态为不可用!"));
				return;
			}
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var item = DetailStore.getAt(i).get("inclb");
				if (i == selectRow) {
					continue;
				}
				if (item != undefined && INITIINCLBDR == item) {
					Msg.info("warning",$g( "药品批次重复，请重新输入!"));
					return;
				}
			}

			// DetailStore.getAt(selectRow).set("INITIRowId", "");
			DetailStore.getAt(selectRow).set("inci", record.get("InciDr"));
			DetailStore.getAt(selectRow).set("inciCode", record.get("InciCode"));
			DetailStore.getAt(selectRow).set("inciDesc", record.get("InciDesc"));
			DetailStore.getAt(selectRow).set("inclb",record.get("Inclb"));
			DetailStore.getAt(selectRow).set("batexp",record.get("BatExp"));
			DetailStore.getAt(selectRow).set("manfName",record.get("Manf"));
			DetailStore.getAt(selectRow).set("inclbQty",record.get("InclbQty"));
			addComboData(CTUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
			DetailStore.getAt(selectRow).set("uom",	record.get("PurUomId"));
			DetailStore.getAt(selectRow).set("rp",record.get("Rp"));
			DetailStore.getAt(selectRow).set("sp",record.get("Sp"));
			//DetailStore.getAt(selectRow).set("reqQty", record.get("ReqQty"));
			DetailStore.getAt(selectRow).set("stkbin", record.get("StkBin"));
			DetailStore.getAt(selectRow).set("reqLocStkQty",record.get("RequrstStockQty"));
			DetailStore.getAt(selectRow).set("newSp",record.get("BatSp"));
			DetailStore.getAt(selectRow).set("spec", record.get("Spec"));
			DetailStore.getAt(selectRow).set("gene",record.get("GeneName"));
			DetailStore.getAt(selectRow).set("formDesc", record.get("PhcFormDesc"));
			DetailStore.getAt(selectRow).set("ConFac", record.get("ConFac"));
			DetailStore.getAt(selectRow).set("BUomId",record.get("BUomId"));
			DetailStore.getAt(selectRow).set("inclbDirtyQty", record.get("DirtyQty"));
			DetailStore.getAt(selectRow).set("inclbAvaQty", record.get("AvaQty"));
			DetailStore.getAt(selectRow).set("InsuCode", record.get("InsuCode"));
			DetailStore.getAt(selectRow).set("InsuDesc", record.get("InsuDesc"));

			var index=GetColIndex(DetailGrid,"qty");
			if(index>0){
				DetailGrid.getSelectionModel().select(cell[0], index);
				DetailGrid.startEditing(cell[0], index);
			}
			GetAmount();
		}

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
					var DirtyQty=record.get("inclbDirtyQty");
					var AvaQty=record.get("inclbAvaQty");
					var ReqQty=record.get("reqQty");
					var TrQty=record.get("qty");
					var NowDirtyQty = record.get("dirtyQty");
					if (value == null || value.length <= 0) {
						return;
					} else if (TrUom == value) {
						return;
					} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
						//record.set("sp",Number(Sp).div(ConFac));
						//record.set("newSp",Number(NewSp).div(ConFac));
						//record.set("rp", Number(Rp).div(ConFac));
						//record.set("inclbQty", Number(InclbQty).mul(ConFac) );
						record.set("reqLocStkQty", Number(ReqStkQty).mul(ConFac));
						//record.set("inclbDirtyQty", Number(DirtyQty).mul(ConFac));
						//record.set("inclbAvaQty", Number(AvaQty).mul(ConFac) );
						record.set("reqQty", Number(ReqQty).mul(ConFac) );
						//record.set("dirtyQty", Number(NowDirtyQty).mul(ConFac));
					} else{  //新选择的单位为大单位，原先是单位为小单位
						//record.set("sp", Number(Sp).mul(ConFac) ); 
						//record.set("newSp", Number(NewSp).mul(ConFac) );
						//record.set("rp", Number(Rp).mul(ConFac) );
						//record.set("inclbQty", Number(InclbQty).div(ConFac));
						record.set("reqLocStkQty", Number(ReqStkQty).div(ConFac));
						//record.set("inclbDirtyQty",  Number(DirtyQty).div(ConFac));
						//record.set("inclbAvaQty", Number(AvaQty).div(ConFac));
						record.set("reqQty", Number(ReqQty).div(ConFac));
						//record.set("dirtyQty", Number(NowDirtyQty).div(ConFac));
					}
					var Inclb=record.get("inclb");
					var QtyAndPriceInfo = tkMakeServerCall("web.DHCST.Util.DrugUtil","GetIncilbInfo",Inclb,value)
					if (QtyAndPriceInfo=="") return;
					var InfoArr = QtyAndPriceInfo.split("^")
					record.set("sp", InfoArr[0] ); 
					record.set("rp", InfoArr[1] );
					record.set("inclbQty", InfoArr[2]);
					record.set("inclbDirtyQty",  InfoArr[3]);
					record.set("inclbAvaQty", InfoArr[4]);
					var initi = record.get("initi");
					var dirtyQtyUom= tkMakeServerCall("web.DHCST.DHCINIsTrfItm","GetDirtyQtyBuUom",initi,value)
					record.set("dirtyQty", dirtyQtyUom);
					record.set("uom", combo.getValue());
		});

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
		function changeElementEnable()
		{
			if (DetailGrid.getStore().getCount()==0){
				Ext.getCmp("StkGrpType").setDisabled(false);
				SupplyPhaLoc.setDisabled(false);
			}
			else{
				Ext.getCmp("StkGrpType").setDisabled(true);
				SupplyPhaLoc.setDisabled(true);
			}
		}
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
//			id:'HisListTab',
			labelAlign : 'right',
			frame : true,
			region : 'north',
			height:DHCSTFormStyle.FrmHeight(3),
			title:$g('库存转移制单'),
			autoScroll : false,
			//bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [SearchInItBT, '-',  ClearBT, '-', SaveBT, '-', CheckBT, '-', CancelCmpBT,'-',SelReqBT,'-',PrintBT, '-', DeleteBT],
			items:[{
				xtype:'fieldset',
				title:$g('转移单信息'),
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 220, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
	               	//	"margin-bottom": "10px"
	            	//},
	            	items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
					
				},{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 140, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [InItNo,InItDate,OperateOutType]
					
				},{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 140, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [ReqNo,ReqNoID,Remark,InItFlag]
					
				}]
			}]
		});

		// 双击事件
		DetailGrid.on('rowdblclick', function() {
					// 判断转移单是否已完成
					var initFlag = Ext.getCmp("InItFlag").getValue();
					if (initFlag != null && initFlag != 0) {
						Msg.info("warning", $g("转移单已完成不可修改!"));
						return;
					}
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var selectRow = cell[0];
					var item = DetailStore.getAt(selectRow).get("IncName");
					GetPhaOrderInfo(item, "");
				});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [HisListTab, DetailGrid],
					renderTo : 'mainPanel'
				});
		
		// 登录设置默认值
		SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFER"); 
		if(gInitId!=undefined && gInitId!='' && gFlag==1){
			Query(gInitId);
		}
		//打开库存转移制单界面时，根据配置确定是否需自动显示待出库的请求单
		if(gFlag!=1 && gParam[6]=='Y'){
			var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
			if(FrLoc!=null && FrLoc!=""){
				SelReq(FrLoc,Query,1);			}			
		}
		
	}
	 
})
