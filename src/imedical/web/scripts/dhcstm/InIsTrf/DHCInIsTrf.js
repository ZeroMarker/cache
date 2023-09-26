// 2015-06-09 添加签字确认弹窗
// /名称: 库存转移制单
// /描述: 库存转移制单
// /编写者：zhangdongmei
// /编写日期: 2012.07.18

	//取高值管理参数
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	//若使用高值跟踪,分一般入库和高值入库两个菜单,否则不需区分
	UseItmTrack=UseItmTrack&&gHVInIsTrf;

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gHospId=session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
	//2015-06-09 csp添加签字标志变量(控制出库审核,入库接收按钮是否可见,BCFlag参数,已经查询界面参数)
	gHVSignFlag = typeof(gHVSignFlag)=='undefined'? '' : gHVSignFlag;
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					emptyText : '请求部门...',
					defaultLoc:{},
					childCombo : 'ReqLocUser',
					listeners:{
						'beforeselect' : function(combo, record, index){
							var requestLoc = record.get(combo.valueField);
							var provLoc = Ext.getCmp('SupplyPhaLoc').getValue();
							return CheckMainLoc(provLoc, requestLoc);
						},
						'select':function(cb)
						{
							var requestLoc=cb.getValue();
							var provLoc=Ext.getCmp('SupplyPhaLoc').getValue();
							Ext.getCmp("StkGrpType").setFilterByLoc(provLoc,requestLoc);
						}
					}
		});
		/*
		var ReqLocUser = new Ext.ux.ComboBox({
			id : 'ReqLocUser',
			fieldLabel : '接收人',
			store : AllUserStore,
			filterName : 'Desc'
		});*/
		var ReqLocUser = new Ext.ux.ComboBox({
			id : 'ReqLocUser',
			fieldLabel : '接收人',
			store : DeptUserStore,
			filterName : 'Desc',
			listeners:{
				'beforequery':function(e){
					DeptUserStore.removeAll();
					var Loc=Ext.getCmp('RequestPhaLoc').getValue();
					DeptUserStore.setBaseParam('locId',Loc);
				}
			}
		});
		
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					emptyText : '供给部门...',
					groupId:gGroupId,
					listeners:{
						'beforeselect' : function(combo, record, index){
							var requestLoc = Ext.getCmp('RequestPhaLoc').getValue();
							var provLoc = record.get(combo.valueField);
							if(CheckMainLoc(provLoc, requestLoc) == false){
								Ext.getCmp('RequestPhaLoc').setValue('');
							}
						},
						'select':function(cb)
						{
							var provLoc=cb.getValue();
							var requestLoc=Ext.getCmp('RequestPhaLoc').getValue();
							Ext.getCmp("StkGrpType").setFilterByLoc(provLoc,requestLoc);
						}
					}
				});

		var VirtualFlag = new Ext.form.Checkbox({
			hideLabel:true,
			boxLabel : '虚库',
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
					fieldLabel : '完成',
					id : 'InItFlag',
					name : 'InItFlag',
					anchor : '90%',
					width : 120,
					checked : false,
					disabled : true
				});
		//20180914
		var ExpressFlag=new Ext.form.Checkbox({
			id: 'ExpressFlag',
			fieldLabel:'送货',
			anchor:'100%',
			allowBlank:true
		});

		// 出库备注
		var Remark = new Ext.form.TextField({
					fieldLabel : '出库备注',
					id : 'Remark',
					name : 'Remark',
					anchor : '90%',
					width : 120,
					disabled : false
				});

		// 请求备注
		var ReqRemark = new Ext.form.TextField({
					fieldLabel : '请求备注',
					id : 'ReqRemark',
					name : 'ReqRemark',
					anchor : '90%',
					width : 120,
					disabled : true
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
				
		// 请求单ID
		var ReqNoID = new Ext.form.TextField({
					fieldLabel : '请求单ID',
					id : 'ReqNoID',
					name : 'ReqNoID',
					anchor : '90%',
					width : 120,
					hidden:true,
					disabled : true
				});
		
		var InitStatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', '未完成'], ['11', '已完成'],
					['20', '出库审核不通过'], ['21', '出库审核通过'],
					['30','拒绝接收'], ['31','入库接收']]
		});
		
		var InitStatus = new Ext.form.ComboBox({
			fieldLabel : '单据状态',
			id : 'InitStatus',
			anchor:'90%',
			store : InitStatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			editable : false,
			valueNotFoundText : '',
			disabled : true,
			hidden : gHVSignFlag!='Y'
		});
		Ext.getCmp("InitStatus").setValue('10');
		
		// 查询转移单按钮
		var SearchInItBT = new Ext.Toolbar.Button({
					id : "SearchInItBT",
					text : '查询',
					tooltip : '点击查询转移单',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						if(Ext.getCmp("SupplyPhaLoc").getValue()==""){
							Msg.info("warning","供给部门不可为空!");
							return;
						}
						StockTransferSearch(DetailStore,Query,gHVSignFlag);
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
				if (isDataChanged(panel,DetailGrid)){
					Ext.Msg.show({
						title:'提示',
						msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
						buttons: Ext.Msg.YESNO,
						fn: function(btn){
							if (btn=='yes') {
								clearData();
								SetFormOriginal(panel);
							}
						}
					})
				}else{
					clearData(); 
					SetFormOriginal(panel);
				}
			}
		});
		/**
		 * 清空方法
		 */
		function clearData() {
			var InitStatus = Ext.getCmp('InitStatus').getValue();
			if(gHVSignFlag && gInitId!='' && InitStatus!=31){
				if(!confirm('当前单据尚未完全处理, 是否继续清空?')){
					return false;
				}
			}
			
			Ext.getCmp("ReqLocUser").setValue("");
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItNo").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("ReqRemark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("VirtualFlag").setValue(false);
			SetLogInDept(SupplyPhaLoc.getStore(),"SupplyPhaLoc");
			Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			Ext.getCmp("RequestPhaLoc").setDisabled(0);
			Ext.getCmp("StkGrpType").setDisabled(0);
			Ext.getCmp("ReqNo").setValue("");
			Ext.getCmp("ReqNoID").setValue("");
			Ext.getCmp('InitStatus').setValue('10');
			Ext.getCmp('ExpressFlag').setValue(false);
			gInitId="";
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// 变更按钮是否可用
			//查询^清除^新建^保存^删除^完成^取消完成
			changeButtonEnable("1^1^1^0^0^0^0^0^0");
			//清除可能存在href变量
			CheckLocationHref();
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
							Msg.info("warning", "请选择请求部门!");
							return;
						}
						var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
								.getValue();
						if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
							Msg.info("warning", "请选择供应部门!");
							return;
						}
						if (requestphaLoc == supplyphaLoc) {
							Msg.info("warning", "请求部门和供应部门不能相同!");
							return;
						}

						var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
						if (InitParamObj.OutTypeNotNull == 'Y' && Ext.isEmpty(operatetype)) {
							Msg.info("warning", "请选择出库类型!");
							return;
						}
						var stkgrptype= Ext.getCmp("StkGrpType")
								.getValue();
						if (stkgrptype== null || stkgrptype.length <= 0) {
							Msg.info("warning", "类组未选择,请谨慎核实数据!");
							//return;
						}
						// 新增一行
						addNewRow();
						//查询^清除^新建^保存^删除^完成^取消完成
						changeButtonEnable("1^1^1^1^1^1^0^0^0");
					}
				});
		/**
		 * 新增一行
		 */
		function addNewRow() {
			var NewGridFlag = (DetailGrid.getStore().getCount() == 0);
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
			RequestPhaLoc.setDisabled(true);
			if(!NewGridFlag){
				StkGrpType.setDisabled(true);
			}
		}

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
							changeButtonEnable("1^1^1^1^1^1^0^0^0");
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
				Msg.info("warning", "请选择请求部门!");
				return false;
			}
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
					.getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "请选择供应部门!");
				return false;
			}
			if (requestphaLoc == supplyphaLoc) {
				Msg.info("warning", "请求部门和供应部门不能相同!");
				return false;
			}

			var operatetype = Ext.getCmp("OperateOutType")
					.getValue();
			if (InitParamObj.OutTypeNotNull == 'Y' && Ext.isEmpty(operatetype)) {
				Msg.info("warning", "请选择出库类型!");
				return false;
			}
			var reqid=Ext.getCmp("ReqNoID").getValue();
			var ifTrfbyReq=tkMakeServerCall("web.DHCSTM.DHCINIsTrf","GetReqStaus",reqid);
			var ReqNo=Ext.getCmp("ReqNo").getValue();
			if ((reqid!="")&&(ifTrfbyReq!="Y")) {
				Msg.info("warning", "请求单"+ReqNo+"状态已发生改变，请重新选取!");
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
							&& item_i == item_j && !(UseItmTrack && HVFlag=='Y')) {
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
				if ((item != undefined) && (qty == null || qty <= 0)) {
					Msg.info("warning", "转移数量不能小于或等于0!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}

				var avaQty = DetailStore.getAt(i).get("inclbAvaQty");
				var dirtyQty=DetailStore.getAt(i).get("dirtyQty");    //本次占用数量
				if ((item != undefined) && ((qty - avaQty-dirtyQty) > 0)) {
					Msg.info("warning", "转移数量不能大于可用库存数量!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
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
			var ReqLocUser = Ext.getCmp("ReqLocUser").getValue();
			var ExpressFlag=Ext.getCmp('ExpressFlag').getValue()?'Y':'N';//20180914
			var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^" + Complete
					+ "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark
					+ "^" + "" + "^" + ReqLocUser+"^"+ExpressFlag;
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
					var UomId = rowData.get("uom");
					var ReqItmId = rowData.get("inrqi");
					var Remark = rowData.get("remark");
					var BarCode = rowData.get("HVBarCode");
					var SpecDesc=rowData.get("SpecDesc");
					var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
							+ ReqItmId + "^" + Remark + "^" + BarCode+"^^"+SpecDesc;	
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+xRowDelim()+str;
					}
				}
			}

			if(!IsFormChanged(HisListTab) && ListDetail==""){
				Msg.info("warning","没有需要保存的数据!");
				return false;
			}
			var ReqNo=Ext.getCmp("ReqNo").getValue();
			var initreqifallow=tkMakeServerCall("web.DHCSTM.DHCINIsTrfItm","IfAllowTrf",gInitId,ListDetail,MainInfo);
			if ((reqid!="")&&(initreqifallow!=0)){
				Msg.info("warning", "请求单"+ReqNo+"状态已发生改变，请重新选取!");
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
							loadMask.hide();
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
									PrintInIsTrf(InitRowid, 'Y');
								}
							} else {
								var ret=jsonData.info;								
								Msg.info("error", "保存不成功："+ret);								
							}
						},
						scope : this
					});
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
			var allowDelete = tkMakeServerCall('web.DHCSTM.DHCINIsTrf', 'AllowDel', gInitId);
			if(allowDelete < 0){
				Msg.info('error', '单据已完成, 不可删除!');
			}
			var message = (allowDelete == 1)? '单据已打印或有其他处理信息,仅进行作废处理,是否继续?' : '是否确定删除整张转移单?'
			Ext.MessageBox.show({
						title : '提示',
						msg : message,
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
									var TGridIndex = TGrid.getStore().findExact('init',gInitId);
									if(TGridIndex != -1){
										TGrid.getStore().removeAt(TGridIndex);
										TGrid.getView().refresh();
									}
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
									//若没有请领明细了,但还有请领单号,置空
									var inrqiIndex = DetailStore.find('inrqi', /^\d+\|\|\d+$/, 0);
									if(inrqiIndex == -1 && !Ext.isEmpty(Ext.getCmp('ReqNoID').getValue())){
										Ext.getCmp('ReqNoID').setValue('');
										Ext.getCmp('ReqNo').setValue('');
										Ext.getCmp('ReqRemark').setValue('');
									}
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
						if((InitParamObj.UseLocLimitAmt=="Y")||(GetAppPropValue('DHCSTINREQM').UseLocLimitQty=="Y")){
							if (CheckDataBeforeComplete()){Complete();}
						}else{Complete();}
					}
				});
		// 完成前控额判断提示
		function CheckDataBeforeComplete() {
			var checkret=tkMakeServerCall("web.DHCSTM.LocLimitAmt","CheckIfExcess",gInitId); //检查科室申请额度
			var checqtykret=tkMakeServerCall("web.DHCSTM.LocLimitAmt","CheckIfExcessQty",gInitId);  ///检查科室限领数量
			if ((checkret=="")&&(checqtykret=="")){return true;}
			var checkret="^"+checkret+"^";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			var count=0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var initi = rowData.get("initi");
				var chl=initi.split("||")[1];
				var tmpchl="^"+chl+"^";
				if (checkret.indexOf(tmpchl)>=0) {
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					count=count+1;
					continue;
				}
			}
			if (count>0){
				Msg.info("warning", "以下汇总明细金额已超过科室限定额度!");
				return false;
			}
			var checqtykret=","+checqtykret+",";
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			var countqty=0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var initi = rowData.get("initi");
				var chl=initi.split("||")[1];
				var tmpchl=","+chl+",";
				if (checqtykret.indexOf(tmpchl)>=0) {
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					countqty=countqty+1;
					continue;
				}
			}
			if (countqty>0){
				Msg.info("warning", "以下黄颜色背景的记录总数超过科室限定申领数量!");
				return false;
			}
			return true;
		}

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
			
			//预算结余判断
			var HRPBudgResult = HRPBudg();
			if(HRPBudgResult === false){
				return;
			}
			
			var BCFlag = gHVSignFlag == 'Y'? 'N' : '';		//签字时,BCFlag传N
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=11&Complete=Y&GroupId='+gGroupId+'&BCFlag='+BCFlag;

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
								Ext.getCmp("InitStatus").setValue('11');
								var TGridIndex = TGrid.getStore().findExact('init',gInitId);
								if(TGridIndex!=-1){
									TGrid.getStore().getAt(TGridIndex).set('comp', 'Y');
								}
								//完成后自动打印 或 完成后自动出库审核，出库审核后自动打印
								if((InitParamObj.AutoPrintAfterComp=='Y') || (InitParamObj.AutoAckOutAfterCompleted=='Y' && InitParamObj.AutoPrintAfterAckOut=='Y')){
									PrintInIsTrf(gInitId, 'Y');
								}
								
								//查询^清除^新建^保存^删除^完成^取消完成
								changeButtonEnable("1^1^0^0^0^0^1^1^0");
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
								Ext.getCmp("InitStatus").setValue('10');
								var TGridIndex = TGrid.getStore().findExact('init',gInitId);
								if(TGridIndex!=-1){
									TGrid.getStore().getAt(TGridIndex).set('comp', 'N');
								}
								//查询^清除^新建^保存^删除^完成^取消完成
								changeButtonEnable("1^1^1^1^1^1^0^0^0");
								
							} else {
								Msg.info("error", "操作失败,请检查单据状态："+jsonData.info);
							}
						},
						scope : this
					});
		}

		// 审批按钮
		var AuditYesBT = new Ext.Toolbar.Button({
					id : "AuditYesBT",
					text : '审核通过',
					tooltip : '点击审核通过',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						var LocId = Ext.getCmp('SupplyPhaLoc').getValue();
						var UserCode = session['LOGON.USERCODE'];
						var StrParam = LocId + '^' + userId + '^' + UserCode;
						VerifyPassWord(StrParam, AuditOutYes);
					}
				});

		/**
		 * 审批转移单出库
		 */
		function AuditOutYes(OperUserId) {
			if (Ext.isEmpty(gInitId)) {
				Msg.info("warning", "请选择审核的转移单!");
				return;
			}
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag == false) {
				Msg.info("warning", "转移单尚未完成!");
				return;
			}

			///检查高值材料标签录入情况
			if(UseItmTrack && CheckHighValueLabels("T",gInitId)==false){
				return;
			}
			var BCFlag = gHVSignFlag == 'Y'? 'N' : '';		//签字时,BCFlag传N
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Audit&Rowid="
					+ gInitId + "&User=" + OperUserId + "&BCFlag=" + BCFlag;		//2015-06-09 设置BCFlag为N
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", "出库审核成功!");
								Query(gInitId);
								//根据参数设置, 打印单据
								if(gParam[4]=='Y'){
									PrintInIsTrf(Init, gHVSignFlag);
								}
							} else {
								var Ret=jsonData.info;
								if(Ret==-100){
									Msg.info("error", "出库单不是待审核状态!");
								}else if(Ret==-99){
									Msg.info("error", "加锁失败!");
								}else if(Ret==-1){
									Msg.info("error", "更新出库单状态失败!");
								}else if(Ret==-3){
									Msg.info("error", "处理库存失败!");
								}else if(Ret==-4){
									Msg.info("error", "插入台帐失败!");
								}else if(Ret==-5){
									Msg.info("error", "更新子表状态失败!");
								}else if(Ret==-6){
									Msg.info("error", "处理占用数量失败!");
								}else if(Ret==-7){
									Msg.info("error", "自动接收出库单失败，请手动接收!");
								}else{
									Msg.info("error", "审核失败:"+Ret);
								}
							}
						},
						scope : this
					});
		}
	
		var AuditInYesBT = new Ext.Toolbar.Button({
				id : "AuditInYesBT",
				text : '入库接收',
				tooltip : '点击接收',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				disabled : true,
				handler : function() {
					var LocId = Ext.getCmp('RequestPhaLoc').getValue();
					var StrParam = LocId + '^^';
					VerifyPassWord(StrParam, AuditInYes);
				}
			});

		/**
		 * 审批转移单入库
		 */
		function AuditInYes(OperUserId) {
			if (Ext.isEmpty(gInitId)) {
				Msg.info("warning", "请选择要接收的转移单!");
				return;
			}
			var InitStatus = Ext.getCmp('InitStatus').getValue();
			if (InitStatus != "21") {
				Msg.info("warning", "转移单不是待接收状态，请核实!");
				return;
			}
		
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ gInitId + "&User=" + OperUserId;
			Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", "接收成功!");
							Query(gInitId);
							//根据参数设置自动打印
							if(gParam[5]=='Y'){
								PrintInIsTrf(gInitId, 'Y');
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", "出库单不是待接收状态!");
							}else if(Ret==-99){
								Msg.info("error", "加锁失败!");
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", "更新出库单状态失败!");
							}else if(Ret==-3){
								Msg.info("error", "处理库存失败!");
							}else if(Ret==-4){
								Msg.info("error", "插入台帐失败!");
							}else{
								Msg.info("error", "接收失败:"+Ret);
							}
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
	
		// 请求单按钮
		var SelReqBT = new Ext.Toolbar.Button({
				id : "SelReqBT",
				text : '选取请求单',
				tooltip : '点击查询请求单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
					if(FrLoc==null){
						Msg.info("warning","请选择供应科室!")
						return;
					}
					SelReq(FrLoc,getlistReq,queryTrans);
				}
		});
		
		function getlistReq(datastr,strinfo){
			var list = datastr.split("^");
			var ReqNoID=Ext.getCmp("ReqNoID").getValue();
			if (ReqNoID==list[0]){
				Msg.info("warning","该请领单已存在!")
				return;
			}
			if(ReqNoID!="" && ReqNoID!=list[0]){   //新的请领单重新填充
				clearData(); 
			}
			if (list.length > 0) {
				addComboData(Ext.getCmp('SupplyPhaLoc').getStore(),list[4],list[5])
				Ext.getCmp("SupplyPhaLoc").setValue(list[4]);
				addComboData(RequestPhaLoc.getStore(),list[2],list[3]);
				Ext.getCmp("RequestPhaLoc").setValue(list[2]);
				addComboData(null,list[12],list[13],StkGrpType);
				Ext.getCmp("StkGrpType").setValue(list[12]);
				Ext.getCmp("ReqRemark").setValue(handleMemo(list[10],xMemoDelim()));
				Ext.getCmp("ReqNo").setValue(list[1]);		
				Ext.getCmp("ReqNoID").setValue(list[0]);	
				Ext.getCmp("ExpressFlag").setValue(list[14]=='Y'?true:false)
				//查询^清除^新增^保存^删除^完成^取消完成
				changeButtonEnable("1^1^1^1^1^1^0");
				SupplyPhaLoc.setDisabled(true);
				RequestPhaLoc.setDisabled(true);
				StkGrpType.setDisabled(true);
				// 显示请求单明细数据
				getReqDetaill(strinfo)
			}		
		};
		//请求单明细数据
		function getReqDetaill(strinfo){
			var url='dhcstm.dhcinistrfaction.csp?actiontype=GetInclbByReq&strinfo='+strinfo
			var responsetext=ExecuteDBSynAccess(url);
			var jsonData = Ext.util.JSON.decode(responsetext);
			if(jsonData.success=="true"){
				var info=jsonData.info;
				var infoArr=info.split(xRowDelim());   //行info分割
				if(infoArr.length>0){
					for(i=0;i<infoArr.length;i++){
						var dataArr=infoArr[i]  
						var datainfo=dataArr.split("^");
						var InciDr = datainfo[0];  //inci
			            var Incicode = datainfo[1];   //库存项代码
			            var Incidesc = datainfo[2]; //库存项描述
			            var HVFlag = datainfo[3];     //转移数量
			            var Inclb =datainfo[4];
			   
			            var batexp = datainfo[5];
			            var manf = datainfo[6];
			            var ProLocAllAvaQty = datainfo[7];
			            var Qty = datainfo[8];  
			            var UomDr = datainfo[9];   
			   
			            var Rp = datainfo[10]; 
			            var Sp = datainfo[11]; 
			            var RpAmt = datainfo[12]; 
			            var SpAmt = datainfo[13];
			            var ReqQty = datainfo[14]; 
			   
			            var stkbin = datainfo[16];
			            var reqPuomQty = datainfo[17];
						var stkQty= datainfo[18];
						var NewSp= datainfo[19];
						var spec= datainfo[20];
						
						var Fac= datainfo[21];
						var uom= datainfo[22];
						var Inrqi= datainfo[23];
						var BarCode= datainfo[24];
						var remark= datainfo[26];
						
						var SpecDesc= datainfo[27];
						var VendorName= datainfo[28];
				        var uomDesc=datainfo[29];
				        var defaData = {
					        inci:InciDr,
					        inciCode:Incicode,
					        inciDesc:Incidesc,
					        HVFlag:HVFlag,
					        inclb:Inclb,
					        batexp:batexp,   
					        manfName:manf,
					        inclbAvaQty:ProLocAllAvaQty,
					        qty:Qty,
					        rp:Rp,  
					        remark:remark,
					        reqLocStkQty:reqPuomQty,
					        sp:Sp,
					        rpAmt:RpAmt,
					        spAmt:SpAmt,
					        reqQty:ReqQty,
					        qtyApproved:Qty,
					        reqLocStkQty:reqPuomQty,
					        inclbQty:stkQty,
					        newSp:NewSp,
					        spec:spec,
					        ConFac:Fac,
					        inrqi:Inrqi,
					        BarCode:BarCode,
					        AllAvaQty:stkQty,
					        reqremark:remark,
					        SpecDesc:SpecDesc,
					        VendorName:VendorName
					     };
					     var DataRecord = CreateRecordInstance(DetailGrid.getStore().fields,defaData);
					     if(Qty>0){
						     DetailGrid.getStore().add(DataRecord)
						     var Rowcount=DetailGrid.getStore().getCount()
						     var rowData = DetailGrid.getStore().getAt(Rowcount-1);
						     addComboData(CTUomStore,uom,uomDesc);
						     rowData.set("uom",uom);
						     }
						}
					}
				}        	
		};
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
						if((gParam[13]=="N")&&(Ext.getCmp('InItFlag').getValue()==false)){
							Msg.info('warning','不允许打印未完成的转移单!');
							return;
						}
						PrintInIsTrf(gInitId);
					}
				});
		var CreateBarCode = new Ext.Toolbar.Button({
			text: '生成条码',
			iconCls: 'page_print',
			width: 70,
			height: 30,
			handler: function (button, e) {
				if (gInitId==""){Msg.info("warning","单据未保存，不允许生成条码");return false;}
				var count = DetailGrid.getStore().getCount();
				var initidstr="";
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var RowData = DetailGrid.getStore().getAt(rowIndex);
					var print = RowData.get('print');
					if (print != "Y") {
						continue;
					}
					var initmid=RowData.get('initi');
					if (initidstr==""){
						initidstr=initmid;
					}else{
						initidstr=initidstr+"^"+initmid;
					}
				}
				if (initidstr==""){Msg.info("warning","请选择需要生成条码的明细");return false;}
				var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=CreateBarCode";
				var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
				Ext.Ajax.request({
							url : url,
							params:{initidstr:initidstr},
							method : 'POST',
							waitMsg : '处理中...',
							success : function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									var retinfo = jsonData.info;
									var infoArr=retinfo.split(",");
									var InitRowid=infoArr[0];
									var total=infoArr[1];
									var succount=infoArr[2];
									Msg.info("success", "共"+total+"条，"+"保存成功"+succount+"条");
									Query(InitRowid);
								}
							},
							scope : this
						});
			}
		});
		var printBarCode = new Ext.Toolbar.Button({
			text: '打印条码',
			iconCls: 'page_print',
			width: 70,
			height: 30,
			handler: function (button, e) {
				DHCP_GetXMLConfig("DHCSTM_ILBBarcode");
				var count = DetailGrid.getStore().getCount();
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var RowData = DetailGrid.getStore().getAt(rowIndex);
					var print = RowData.get('print');
					if (print != "Y") {
						continue;
					}
					var inititmid=RowData.get('initi');
					var qty=RowData.get('qty');
					var BarCode = tkMakeServerCall("web.DHCSTM.DHCINIsTrf","GetBarCodeByInititmid",inititmid);
					if (Ext.isEmpty(BarCode)) {
						continue;
					}
					var inciDesc=RowData.get('inciDesc');
					var spec=RowData.get('spec');
					var MyPara = 'BarCode' + String.fromCharCode(2) + "*" + BarCode + "*"
					+ '^IncDesc' + String.fromCharCode(2) + inciDesc
					+ '^Spec' + String.fromCharCode(2) + spec;
					for (var i=0;i<qty;i++){
						DHCP_PrintFun(MyPara, "");
					}
				}
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
					var AllAvaQty=record.get("AllAvaQty");
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
						record.set("AllAvaQty",accMul(AllAvaQty,ConFac));
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
						record.set("AllAvaQty",accDiv(AllAvaQty,ConFac));
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
									//addComboData(PhaDeptStore,list[6],list[26]);
									addComboData(Ext.getCmp('SupplyPhaLoc').getStore(),list[6],list[26])
									Ext.getCmp("SupplyPhaLoc").setValue(list[6]);
									addComboData(RequestPhaLoc.getStore(),list[12],list[27]);
									Ext.getCmp("RequestPhaLoc").setValue(list[12]);
									Ext.getCmp("InitStatus").setValue(list[15]);
									addComboData(OperateOutType.getStore(),list[21],list[32]);
									Ext.getCmp("OperateOutType").setValue(list[21]);
									addComboData(null,list[24],list[36],StkGrpType);
									Ext.getCmp("StkGrpType").setValue(list[24]);
									Ext.getCmp("InItDate").setValue(list[29]);	
									Ext.getCmp("InItFlag").setValue(list[14]=='Y'?true:false);
									Ext.getCmp("Remark").setValue(list[9]);
									Ext.getCmp("ReqNo").setValue(list[28]);		
									Ext.getCmp("ReqNoID").setValue(list[30]);	
									Ext.getCmp("ReqRemark").setValue(handleMemo(list[35],xMemoDelim()));  //请求单备注
									addComboData(ReqLocUser.getStore(), list[38], list[39]);
									Ext.getCmp("ReqLocUser").setValue(list[38]);
									Ext.getCmp("ExpressFlag").setValue(list[40]=='Y'?true:false)
									// 变更按钮是否可用
									//查询^清除^新增^保存^删除^完成^取消完成
									var CompFlag =list[14];
									if(CompFlag=="Y"){
										var InitStatus = list[15];
										if(InitStatus == '21'){
											changeButtonEnable("1^1^0^0^0^0^0^0^1");
										}else if(InitStatus == '31'){
											changeButtonEnable("1^1^0^0^0^0^0^0^0");
										}else{
											changeButtonEnable("1^1^0^0^0^0^1^1^0");
										}
									}else{
										changeButtonEnable("1^1^1^1^1^1^0^0^0");
									}
									SupplyPhaLoc.setDisabled(true);
									RequestPhaLoc.setDisabled(true);
									StkGrpType.setDisabled(true);
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
				 "qty", "uom", "sp","status","remark","AllAvaQty",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty",
				"TrUomDesc","dirtyQty","HVFlag","HVBarCode","BarCode","reqremark","SpecDesc",
				"Vendor","VendorName","AllDirtyQty","qtyApproved","SterilizedBat",
				{name:"BatchNo",convert:function(v,rec){return rec.batexp.split('~')[0];}},
				{name:"ExpDate",convert:function(v,rec){return rec.batexp.split('~')[1];}},"inclbbarcode"
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
		var print = new Ext.grid.CheckColumn({
			header:'打印/条码',
			dataIndex:'print',
			width : 70,
			sortable:true
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
					renderer :Ext.util.Format.InciPicRenderer('inci'),
					sortable : true
				}, {
					header : '物资名称',
					dataIndex : 'inciDesc',
					width : 230,
					align : 'left',
					sortable : true,
					editable : !UseItmTrack,
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
											url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
											method : 'POST',
											waitMsg : '查询中...',
											success : function(result, request){
												var jsonData = Ext.util.JSON
														.decode(result.responseText);
												if(jsonData.success == 'true'){
													var itmArr=jsonData.info.split("^");
													var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
													var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
													if(Ext.getCmp("StkGrpType").getValue()!=scgID){
														Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(inclb==""){
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
													var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
													var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
													var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
														+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
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
					editor : new Ext.ux.NumberField({
						formatType : 'FmtQTY',
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
									var AvaQty = record.get("inclbAvaQty");
									var dirtyQty=record.get("dirtyQty");
									if (qty - AvaQty-dirtyQty > 0) {
										//Msg.info("warning", "转移数量不能大于可用库存数量!");
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
					header : "供应方批准数量",
					dataIndex : 'qtyApproved',
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
				}, {
					header : "本次占用数量",
					dataIndex : 'dirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "本批次占用数量",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
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
				},{
					header : "条码",
					dataIndex : 'BarCode',
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
									var Barcode=field.getValue();
									GetPhaOrderInfo2(Barcode, stkgrp);
								}
							}
						}
					})
				}, {
					header : "库存总量",
					dataIndex : 'AllAvaQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "库存占用总量",
					dataIndex : 'AllDirtyQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "出库备注",
					dataIndex : 'remark',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : false,
					editor:new Ext.form.TextField({
									id:'remarkField',
									listeners:{
										specialKey:function(field, e) {
											if (e.getKey() == Ext.EventObject.ENTER) {
												var cell = DetailGrid.getSelectionModel().getSelectedCell();
												if(DetailStore.getAt(cell[0]).get('qty')==0){
													Msg.info("error","转移数量不能为0!");
													
													var colIndex=GetColIndex(DetailGrid,"qty");
													if (!DetailGrid.getColumnModel().isHidden(colIndex))
													{
														DetailGrid.startEditing(DetailStore.getCount() - 1, colIndex);
													}
													return false;
												}else{
													//增加一行
													addNewRow();
												}
											}
										}
									}
						  })
				}, {
					header : "请求备注",
					dataIndex : 'reqremark',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : false
				},{
					header:"具体规格",
					dataIndex:'SpecDesc',
					width:100,
					align:'left',
					sortable:true
				}, {
					header : "供应商",
					dataIndex : 'VendorName',
					width : 180,
					align : 'left',
					sortable : true
				},{
					  header:"灭菌批号",
					  dataIndex:'SterilizedBat',
					  width:100,
					  align:'left',
					  sortable:true
			    }, {
					header : "批号",
					dataIndex : 'BatchNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "效期",
					dataIndex : 'ExpDate',
					width : 80,
					align : 'left',
					sortable : true
				}, print,{
					header : "批次条码",
					dataIndex : 'inclbbarcode',
					width : 100,
					align : 'left',
					sortable : true
				}
				]);
		var gridsumm=new Ext.grid.GridSummary();
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
					plugins : [print,gridsumm],
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
						},
						'afteredit' : function(e){
							if(e.field == 'qty'){
								var qty = e.value;
								var AvaQty = e.record.get("inclbAvaQty");
								var dirtyQty = e.record.get("dirtyQty");
								if (qty - AvaQty - dirtyQty > 0) {
									Msg.info("warning", "转移数量不能大于可用库存数量!");
									e.record.set('qty', e.originalValue);
									return false;
								}
								var spAmt = accMul(e.record.get("sp"),qty);
								e.record.set("spAmt", spAmt);
								var rpAmt = accMul(e.record.get("rp"),qty);
								e.record.set("rpAmt", rpAmt);
								
								// 出库预算结余
								var InciId = e.record.get('inci');
								HRPBudg(InciId);
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

		/*
		 * 预算结余,调用HRP预算接口
		 */
		function HRPBudg(CurrInciId){
			CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
			var LocId = Ext.getCmp('SupplyPhaLoc').getValue();
			if(Ext.isEmpty(LocId)){
				return;
			}
			var DataStr = '';
			var Count = DetailGrid.getStore().getCount();
			for(i = 0; i < Count; i++){
				var RowData = DetailGrid.getStore().getAt(i);
				var Initi = RowData.get('initi');
				var InciId = RowData.get('inci');
				var RpAmt = RowData.get('rpAmt');
				if ((InciId == '') || !(RpAmt > 0)){
					continue;
				}
				var Data = Initi + '^' + InciId + '^' + RpAmt;
				if(DataStr == ''){
					DataStr = Data;
				}else{
					DataStr = DataStr + RowDelim + Data;
				}
			}
			if(DataStr != ''){
				var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'InitBalance', CurrInciId, LocId, DataStr);
				if(!Ext.isEmpty(Result)){
					Msg.info('error', '当前采购超出预算,请核实修改:' + Result);
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", gHospId,phaLocRQ,
						returnInfo,"","","1","N");
			}
		}
		
		//根据库存项条码获取物资信息
		function GetPhaOrderInfo2(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatByBarcodeWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", gHospId,phaLocRQ,
						returnInfo);
			}
		}
		/**
		 * 返回数据信息
		 */
		function returnInfo(records) {
			records = [].concat(records);
			if (records == null || records == "") {
				return;
			}
			Ext.each(records,function(record,index,allItems){
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
				
				var ItmTrack=gItmTrackParam[0]=='Y'?true:false;
				if(!(ItmTrack==gHVInIsTrf) && HVFlag=='Y'){
					Msg.info("warning","高值材料,请根据条码录入!");
					var index=GetColIndex(DetailGrid,"HVBarCode");
					rowData.set("InciDesc","");
					DetailGrid.startEditing(cell[0], index);
					return;
				}
				rowData.set("inci", record.get("InciDr"));
				rowData.set("inciCode", record.get("InciCode"));
				rowData.set("inciDesc", record.get("InciDesc"));
				rowData.set("inclb",record.get("Inclb"));
				rowData.set("batexp",record.get("BatExp"));
				var BatExp = record.get("BatExp");
				var BatchNo = BatExp.split('~')[0];
				var ExpDate = BatExp.split('~')[1];
				rowData.set("BatchNo", BatchNo);
				rowData.set("ExpDate", ExpDate);
				rowData.set("manfName",record.get("Manf"));
				rowData.set("VendorName",record.get("VendorName"));
				rowData.set("inclbQty",record.get("InclbQty"));
				rowData.set("AllAvaQty",record.get("SupplyAvaStockQty"));
				addComboData(CTUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
				rowData.set("uom",record.get("PurUomId"));
				rowData.set("rp",record.get("Rp"));
				rowData.set("sp",record.get("Sp"));
				rowData.set("stkbin", record.get("StkBin"));
				rowData.set("reqLocStkQty",record.get("RequrstStockQty"));
				rowData.set("newSp",record.get("BatSp"));
				rowData.set("spec", record.get("Spec"));
				rowData.set("ConFac", record.get("ConFac"));
				rowData.set("BUomId",record.get("BUomId"));
				rowData.set("inclbDirtyQty", record.get("DirtyQty"));
				rowData.set("inclbAvaQty", record.get("AvaQty"));
				rowData.set("HVFlag", record.get("HVFlag"));
				rowData.set("qty", record.get("OperQty"));
				rowData.set("spAmt", accMul(record.get("Sp"),record.get("OperQty"))); 
				rowData.set("rpAmt", accMul(record.get("Rp"),record.get("OperQty"))); 
				if (Ext.getCmp("StkGrpType").getValue()==""){
				addComboData(null,record.get("GrpId"),record.get("GrpDesc"),StkGrpType);
				Ext.getCmp("StkGrpType").setValue(record.get("GrpId"));
				}
				rowData.set("SterilizedBat", record.get("SterilizedBat"));
				rowData.set("SpecDesc", record.get("SpecDesc"));
				var lastIndex = DetailStore.getCount()-1;
				if(DetailStore.getAt(lastIndex).get('inclb')!=""){
					addNewRow();
				}else{
					var col=GetColIndex(DetailGrid,'inciDesc')
					DetailGrid.startEditing(lastIndex,col);
				}
				
				//预算结余判断
				var InciId = rowData.get("inci");
				HRPBudg(InciId);
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
			AuditYesBT.setDisabled(list[7]);
			AuditInYesBT.setDisabled(list[8]);
		}
		// 转移明细
	
		// 指定列参数
		var Tfields = ["init", "frLocDesc", "toLocDesc","initNo","reqNo","comp"];

		// 数据集
		var TStore = new Ext.data.JsonStore({
			storeId: 'TStore',
			url : 'dhcstm.dhcinistrfaction.csp?actiontype=QueryTrans',
			root : 'rows',
			fields:Tfields
		});
		
		var nm = new Ext.grid.RowNumberer();
		var TCm = new Ext.grid.ColumnModel([nm, {
					header : "",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden:true
				},{
					header : "完成",
					dataIndex : 'comp',
					width : 30,
					align : 'center',
					xtype : 'checkcolumn'
				},{
					header : "出库单号",
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true	
				},{
					header : "请求单号",
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				},{
					header : "请求科室",
					dataIndex : 'toLocDesc',
					width : 80,
					align : 'left',
					sortable : true	
				},{
					header : "出库科室",
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}
			]);
		
		function queryTrans(InitStr){
			TStore.removeAll();
			TStore.load({
				params:{InitStr:InitStr},
				callback : function(r,options, success){
					if(success==false){
						Msg.info("error", "查询错误，请查看日志!");
					}else{
						if(r.length>0){
							TGrid.getSelectionModel().selectFirstRow();
						}
					}
				}
			})
		}
		
		var sm1=new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				'rowselect':function(sm,index,r){
					var init=r.get('init');
					Query(init);
				}
			}
		});
		
		//显示新生成的转移单
		var TGrid = new Ext.ux.GridPanel({
			id : 'TGrid',
			title:'批量生成的转移单',
			cm:TCm,
			region : 'center',
			store : TStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			sm : sm1
		});
	
		var HisListTab = new Ext.form.FormPanel({
			id:'HisListTab',
			labelAlign : 'right',
			frame : true,
			region : 'west',
			labelWidth : 60,
			width:900,
			title:gHVSignFlag=='Y'?'库存转移制单(双签字)':'库存转移制单',
			autoScroll : false,
			bodyStyle : 'padding:5px 0px 0px 5px;',
			tbar : [SearchInItBT, '-',  ClearBT, '-', SaveBT, '-', DeleteBT, '-', CheckBT, '-', CancelCmpBT,
				gHVSignFlag=='Y'?'-':'', gHVSignFlag=='Y'?AuditYesBT:'', gHVSignFlag=='Y'?'-':'', gHVSignFlag=='Y'?AuditInYesBT:'',
				'-',PrintBT,!gHVInIsTrf?'-':"",!gHVInIsTrf?SelReqBT:"",CreateBarCode,printBarCode],
			items:[{
				xtype:'fieldset',
				title:'转移单信息',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:'padding: 5px 0px 0px 0px',
				defaults: {xtype: 'fieldset', border:false},
				items : [{
						columnWidth: 0.3,
						items: [SupplyPhaLoc,RequestPhaLoc,ReqLocUser,StkGrpType]
					},{
						labelWidth : 40,
						columnWidth: 0.15,
						items:[gHVInIsTrf?[VirtualFlag,InItFlag]:[InItFlag],ExpressFlag]
					},{
						columnWidth: 0.3,
						items: [InItNo,InItDate,OperateOutType,InitStatus]
					},{
						columnWidth: 0.25,
						items: [Remark,ReqNo,ReqRemark,ReqNoID]
					}]
			}]
		});
		var panel=new Ext.Panel({
			height : 220,
			region : 'north',
			layout : 'border',
			items : [HisListTab, TGrid]
		})
		
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [panel, DetailGrid],
					renderTo : 'mainPanel'
				});
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFERM");
		// 登录设置默认值
		SetLogInDept(PhaDeptStore, "SupplyPhaLoc");		
		if(gInitId!=undefined && gInitId!='' && gFlag==1){
			Query(gInitId);
		}
		//打开库存转移制单界面时，根据配置确定是否需自动显示待出库的请求单
		if(gFlag!=1 && gParam[6]=='Y'){
			var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
			if(FrLoc!=null && FrLoc!=""){
				//SelReq(FrLoc,queryTrans);
                SelReq(FrLoc,getlistReq,Query);
			}			
		}		
	}
})

window.onbeforeunload = function(){
	var InitStatus = Ext.getCmp('InitStatus').getValue();
	if(gHVSignFlag && gInitId!='' && InitStatus!=31){
		return '当前单据尚未完全处理, 是否离开?';
	}
};