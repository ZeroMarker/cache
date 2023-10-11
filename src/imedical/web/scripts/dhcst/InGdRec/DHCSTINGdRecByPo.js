// /名称: 根据订单入库
// /描述: 根据订单入库
// /编写者：zhangdongmei
// /编写日期: 2012.07.31
var IngrTypeId
var RecByPoPageSize=999;
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('科室'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : $g('订购科室...'),
				groupId:session['LOGON.GROUPID']
			});
	OperateInTypeStore.load();
		// 默认选中第一行数据
	OperateInTypeStore.on('load', function() {
					//OperateInType.setValue(1);
				setDefaultInType();
		  });
	 function setDefaultInType()
	    {
		if (OperateInTypeStore.getTotalCount() > 0){
                IngrTypeId=OperateInTypeStore.getAt(0).data.RowId;
          }

	  }
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('起始日期'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('截止日期'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : $g('未入库'),
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : $g('部分入库'),
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	/*
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : '全部入库',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : false
	});
	*/
	// 经营企业
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : $g('经营企业'),
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%'
	});
		
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : $g('查询'),
				tooltip : $g('点击查询订单'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
	    Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		
		MasterGrid.store.removeAll();
		DetailGrid.store.removeAll();
		DetailGrid.store.load({params:{start:0,limit:0}})
		DetailGrid.getView().refresh();
		
	}

	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				id : "SaveBT",
				text :$g( '保存'),
				tooltip : $g('点击保存'),
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(CheckDataBeforeSave()==true){
						save();						
					}
				}
			});

	/**
	 * 保存入库单前数据检查
	 */		
	function CheckDataBeforeSave() {
		var nowdate = new Date();
		var record = MasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", $g("没有需要保存的数据!"));				
			return false;
		}
		
		var Status = record.get("PoStatus");				
		if (Status ==2) {
			Msg.info("warning", $g("该订单已经全部入库，不能再入库!"));				
			return false;
		}			
		
		// 判断入库部门和供货商是否为空
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning",$g("请选择入库部门!"));
			return false;
		}
		
		// 1.判断入库药品是否为空
		var rowCount = DetailGrid.getStore().getCount();
		// 有效行数
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("IncId");
			if (item != "") {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", $g("请输入入库明细!"));
			return false;
		}
		// 2.重新填充背景
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		// 3.判断重复输入药品
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = DetailStore.getAt(i).get("IncId");;
				var item_j = DetailStore.getAt(j).get("IncId");;
				if (item_i != "" && item_j != ""
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", $g("药品重复，请重新输入!"));
					return false;
				}
			}
		}
		// 4.药品信息输入错误
		for (var i = 0; i < rowCount; i++) {
			var expDateValue = DetailStore.getAt(i).get("ExpDate");
			var item = DetailStore.getAt(i).get("IncId");
			var incDesc=DetailStore.getAt(i).get("IncDesc");
			var ExpDate = new Date(Date.parse(expDateValue));
			var freedrugflag=DetailStore.getAt(i).get('FreeDrugFlag');
			
			if ((item != "")	&& (ExpDate.format("Y-m-d") <= nowdate.format("Y-m-d"))) {
				Msg.info("warning", incDesc+$g("，有效期不能小于或等于当前日期!"));
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var qty = DetailStore.getAt(i).get("PurQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", incDesc+$g("，入库数量不能小于或等于0!"));
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var realPrice = DetailStore.getAt(i).get("Rp");
			var sPrice = DetailStore.getAt(i).get("Sp");
			if(sPrice==0&&gParam[15]==1){
				Msg.info("warning", incDesc+$g("，请维护定价类型!"));
				return false;
			}
			if (freedrugflag!="Y"){
				if((item != "")&&(realPrice == null || realPrice <= 0)) {
					Msg.info("warning", incDesc+$g("，入库进价不能小于或等于0!"));
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					DetailGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}else{
				if((item != "")&&(realPrice == null || realPrice < 0)){
					Msg.info("warning", incDesc+$g("，入库进价不能小于0!"));
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					DetailGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			if ((item != "")&& (Number(realPrice))>Number(sPrice)) {
				Msg.info("warning", incDesc+$g("，入库进价不能大于售价!"));
				var cell = DetailGrid.getSelectionModel()
						.getSelectedCell();
				//DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var expDate = DetailStore.getAt(i).get("ExpDate").format('Y-m-d');
			var flag=ExpDateValidator(expDate);									
			if(flag==false){
				Msg.info('warning',incDesc+$g('，该药品距离失效期少于'+gParam[2]+'天!'));								    	
				var cell = DetailGrid.getSelectionModel()
						.getSelectedCell();
				//DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
				 }
			//新增入库数量是否允许小数判断 2020-02-21 yangsj
            if(gParam[19]!="Y")  //1 允许录入小数
            {
        		var record = DetailStore.getAt(i)
                var buomId=record.get("BUomId")
                var purUomId=record.get("PurUomId")
                var buomQty=qty
                if(buomId!=purUomId)
                {
                    var fac=record.get("ConFac")
                    buomQty=Number(fac).mul(qty);
                }
                if((buomQty.toString()).indexOf(".")>=0)
                {
                    Msg.info("warning", record.get("IncDesc")+$g("入库数量换算成基本单位之后存在小数，不能入库！请核对入库配置：入库数量换算为基本单位是否允许小数!"));
                    return;
                }
                
            }	 
			
		}
		
		return true;
	}
	
	/**
	 * 保存入库单
	 */
	function save() {
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		var record = selectRecords[0];	
		var IngrNo = '';
		var VenId = record.get("VenId");
		var Completed = 'N';
		var LocId = Ext.getCmp("PhaLoc").getValue();
		var CreateUser = userId;
		var ExchangeFlag ='N';
		var PresentFlag = 'N';
		//var IngrTypeId = 1;    //正常入库		
		var PurUserId = record.get("PurUserId");
		var StkGrpId = record.get("StkGrpId");
		var PoId=record.get("PoId");  //订单id
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
				+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+PoId;
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
								
			var Ingri='';
			var IncId = rowData.get("IncId");
			var BatchNo = rowData.get("BatNo");
			var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),App_StkDateFormat);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("PurUomId");
			var RecQty = rowData.get("AvaQty");
			var Rp = rowData.get("Rp");
			var NewSp =rowData.get("Sp");
			var SxNo ='';
			var InvNo ='';
			var InvDate ='';
			var PoItmId=rowData.get("PoItmId");
			
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^"
					+ ManfId + "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^"
					+ SxNo + "^" + InvNo + "^" + InvDate+"^"+PoItmId;	
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
			
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : {IngrNo:IngrNo,MainInfo:MainInfo,ListDetail:ListDetail},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var IngrRowid = jsonData.info;
							Msg.info("success", $g("保存成功!"));
							// 7.显示入库单数据
							// 跳转到入库制单界面
							window.location.href='dhcst.ingdrec.csp?Rowid='+IngrRowid+'&QueryFlag=1';

						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", $g("加锁失败,不能保存!"));
							}else if(ret==-2){
								Msg.info("error", $g("生成入库单号失败,不能保存!"));
							}else if(ret==-3){$g(
								Msg.info("error", "保存入库单失败!"));
							}else if(ret==-4){
								Msg.info("error", $g("未找到需更新的入库单,不能保存!"));
							}else if(ret==-5){
								Msg.info("error", $g("保存入库单明细失败!"));
							}else {
								Msg.info("error", $g("部分明细保存不成功：")+ret);
							}
							
						}
					},
					scope : this
				});
		
	}

	/**
	 * 删除选中行药品
	 */
	function deleteDetail() {
		// 判断转移单是否已完成
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", $g("没有选中行!"));
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
	
	}
	

	// 单位
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : $g('单位'),
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : ItmUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : $g('单位...'),
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});

	// 生产生产企业
	var Phmnf = new Ext.form.ComboBox({
				fieldLabel : $g('生产企业'),
				id : 'Phmnf',
				name : 'Phmnf',
				anchor : '90%',
				width : 100,
				store : PhManufacturerStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : $g('生产企业...'),
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				listeners : {
					'beforequery' : function(e) {
						var filter=Ext.getCmp('Phmnf').getRawValue();
						PhManufacturerStore.reload({
							params : {
										start : 0,
										limit : 20,
										PHMNFName:filter
							}
						});
						
					}
				}
			});


	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", $g("请选择订购部门!"));
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		//var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Status=notimp+","+partlyimp;
		var Vendor = Ext.getCmp("Vendor").getValue();

		//开始日期^截止日期^订单号^经营企业id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^^'+Status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam("ParamStr",ListParam);
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(success==false){
     				Msg.info("error", $g("查询错误，请查看日志!"));
     			}else{
     				if(r.length>0){
	     				MasterGrid.getSelectionModel().selectFirstRow();
	     				MasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
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
		var strParam=Parref
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus=$g('未入库');			
		}else if(value==1){
			PoStatus=$g('部分入库');
		}else if(value==2){
			PoStatus=$g('全部入库');
		}
		return PoStatus;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("订单号"),
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("订购科室"),
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("经营企业"),
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("订单状态"),
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : $g("订单日期"),
				dataIndex : 'PoDate',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 添加表格单击行事件
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		var strParam=PoId
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize}});
	});
	
	// 订单明细
	// 访问路径
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryPoDetailForRec&Parref=';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp","ManfId", "Manf", "Sp","BatNo",
			 {name:"ExpDate",type:"date",dateFormat:App_StkDateFormat}, "BUomId", "ConFac","PurQty","ImpQty",'FreeDrugFlag'];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	/**
	 * 显示明细前，装载必要的combox
	 */
	DetailStore.on('beforeload',function(store,options){
		//装载所有单位
		var url = DictUrl
						+ 'drugutil.csp?actiontype=CTUom&CTUomDesc=&start=0&limit=9999';
		CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
		CTUomStore.load();
		
		//装载所有生产企业
		PhManufacturerStore.reload({
			params : {
						start : 0,
						limit : 9999,
						PHMNFName:''
			}
		})
	});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : $g("订单明细id"),
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("药品RowId"),
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('药品代码'),
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('药品名称'),
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : $g("数量"),
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					allowNegative:false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", $g("数量不能为空!"));
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", $g("数量不能小于或等于0!"));
									return;
								}
								
								//新增入库数量是否允许小数判断 2020-02-21 yangsj
	                            if(gParam[19]!=1)  //1 允许录入小数
	                            {
		                            var cell = DetailGrid.getSelectionModel().getSelectedCell();
                            		var record = DetailGrid.getStore().getAt(cell[0]);
		                            var buomId=record.get("BUomId")
		                            var purUomId=record.get("PurUomId")
		                            var buomQty=qty
		                            if(buomId!=purUomId)
		                            {
			                            var fac=record.get("ConFac")
			                            buomQty=Number(fac).mul(qty);
		                            }
		                            if((buomQty.toString()).indexOf(".")>=0)
		                            {
			                            Msg.info("warning", $g("入库数量换算成基本单位之后存在小数，不能入库！请核对入库配置：入库数量换算为基本单位是否允许小数!"));
		                                return;
		                            }
		                            
	                            }
																	
							}
						}
					}
				})
			}, {
				header : $g("单位"),
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer :  Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUom"), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : $g("进价"),
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
			
				sortable : true,
				editor : new Ext.form.NumberField({
							selectOnFocus : true,
							allowBlank : false,
							listeners : {
								specialkey : function(field, e) {
									if (e.getKey() == Ext.EventObject.ENTER) {
										var cost = field.getValue();
										if (cost == null
												|| cost.length <= 0) {
											Msg.info("warning", $g("进价不能为空!"));
											return;
										}
										if (cost <= 0) {
											Msg.info("warning",
													$g("进价不能小于或等于0!"));
											return;
										}
										
										var cell = DetailGrid.getSelectionModel().getSelectedCell();
										DetailGrid.startEditing(cell[0], 10);
									}
								}
							}
				})
			}, {
				header : $g("售价"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			},{
				header :$g( "生产企业"),
				dataIndex : 'ManfId',
				width : 180,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(Phmnf),
				renderer : Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf") // pass combo instance to reusable renderer					
			}, {
				header : $g("批号"),
				dataIndex : 'BatNo',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var batchNo = field.getValue();
								if (batchNo == null || batchNo.length <= 0) {
									Msg.info("warning", $g("批号不能为空!"));
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								DetailGrid.startEditing(cell[0], 11);
							}
						}
					}
				}))
			}, {
				header : $g("有效期"),
				dataIndex : 'ExpDate',
				width : 100,
				align : 'center',
				sortable : true,	
				renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
				editor : new Ext.form.DateField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var expDate = field.getValue();
								if (expDate == null || expDate.length <= 0) {
									Msg.info("warning", $g("有效期不能为空!"));
									return;
								}
								var nowdate = new Date();
								if (expDate.format("Y-m-d") <= nowdate
										.format("Y-m-d")) {
									Msg.info("warning", $g("有效期不能小于或等于当前日期!"));
									return;
								}
									var expDate = field.getValue().format('Y-m-d');
									var flag=ExpDateValidator(expDate);									
								    if(flag==false){
								    	Msg.info('warning',$g('该药品距离失效期少于')+gParam[2]+$g('天!'));								    	
								    }
																
							}
						}
					}
				})
				
			}, {
				header :$g( "订购数量"),
				dataIndex : 'PurQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("已入库数量"),
				dataIndex : 'ImpQty',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : $g("转换率"),
				dataIndex : 'ConFac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("基本单位"),
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
	            header: $g("免费药标识"),
	            dataIndex: 'FreeDrugFlag',
	            width: 80,
	            align: 'left',
	            sortable: true
        	}]);
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : DetailStore,
					pageSize : RecByPoPageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
					prevText : $g("上一页"),
					nextText :$g( "下一页"),
					refreshText : $g("刷新"),
					lastText : $g("最后页"),
					firstText : $g("第一页"),
					beforePageText : $g("当前页"),
					afterPageText : $g("共{0}页"),
					emptyMsg : $g("没有数据")
				});
	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				bbar:[StatuTabPagingToolbar]
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
				text: $g('删除' )
			}
		] 
	}); 
	
	//右键菜单代码关键部分 
	function rightClickFn(grid,rowindex,e){ 
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}

	/**
	 * 单位展开事件
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
				ItmUomStore.removeAll();
				ItmUomStore.load({params:{ItmRowid:InciDr}});
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
				var PurUom = record.get("PurUomId");    //目前显示的入库单位
				var Sp = record.get("Sp");
				var Rp = record.get("Rp");
				
				if (value == null || value.length <= 0) {
					return;
				} else if (PurUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("Sp", Sp/ConFac);
					record.set("Rp", Rp/ConFac);					
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("Sp", Sp*ConFac);
					record.set("Rp", Rp*ConFac);						
				}
				record.set("PurUomId", combo.getValue());
	});

	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		title:$g('入库制单-依据订单'),
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:$g('查询条件'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [PhaLoc,Vendor]
				
			},{ 				
				columnWidth: 0.33,
	        	xtype: 'fieldset',
	        	items: [StartDate,EndDate]
				
			},{ 				
				columnWidth: 0.33,
				xtype: 'fieldset',
	        	items: [NotImp,PartlyImp]
				
			}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: $g('订单'),
		                collapsible: true,
		                split: true,
		                width: document.body.clientWidth*0.3, // give east and west regions a width
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: $g('订单明细'),
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
	//页面加载完成后自动检索订单
	Query();
	
})
