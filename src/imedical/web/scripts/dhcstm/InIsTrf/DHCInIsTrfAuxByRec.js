// /名称: 根据入库单出库
// /描述: 根据入库单出库
// /编写者：zhangdongmei
// /编写日期: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gInitId='';
var timer=null; ///定义全局变量定时器   防止全选的时候 执行多次查询的问题
	var reqidstr='';
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	//取高值管理参数
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	
	// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '请求部门',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '90%',
				emptyText : '请求部门...',
				listWidth : 250,
				defaultLoc:''
			});
		
	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '供给部门',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '90%',
				emptyText : '供给部门...',
				listWidth : 250,
				groupId : session['LOGON.GROUPID'],
				childCombo : 'Vendor'
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
			
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				value : DefaultEdDate()
			});
	
	var TransStatus = new Ext.form.Checkbox({
				fieldLabel : '包含已转移',
				id : 'TransStatus',
				name : 'TransStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
	// 供货厂商
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '供应商',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			listWidth : 250,
			params : {LocId : 'SupplyPhaLoc'}
		});
		
	// 查询转移单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询入库单',
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
		Ext.getCmp("VirtualFlag").setValue(false);
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("TransStatus").setValue(false);
		MasterGrid.store.removeAll();
		DetailGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
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
					if(DetailGrid.activeEditor!=null){
						DetailGrid.activeEditor.completeEdit();
					}
					save();
				}
			});

	/**
	 * 保存转移单
	 */
	function save() {
	var recarr=MasterGrid.getSelectionModel().getSelections();
		var count=recarr.length;
		var HVInIsTrfFlag = false;		//高值转移单标志,缺省false
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		if(selectRecords=="" || selectRecords=='undefined'){
			Msg.info("warning","没有选中的入库单!");
			return;
		}
		var record = selectRecords[0];
		var Status = record.get("Status");				
		if (Status =="已转移") {
			Msg.info("warning", "该入库单已经出库，不能再出库!");
			
			return;
		}			
		
		//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if(requestPhaLoc==null || requestPhaLoc.length<1){
			Msg.info("warning", "请选择请求科室!");
			return;
		}
		if(supplyPhaLoc==requestPhaLoc){
			Msg.info("warning", "请求科室不能和供给科室相同!");
			return;
		}
	var reqidstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('IngrId');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				
		}
		var ingrid=record.get("IngrId");
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId =record.get("StkGrpId");	
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark+"^"+reqidstr;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Ingri = rowData.get("Ingri");
			var Inclb = rowData.get("Inclb");
			var Qty = rowData.get("TrQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("TrUomId");
			var BUomId = rowData.get("BUomId");
			/*
			if(BUomId==UomId && (Qty!=0 && Qty%1!=0)){
				Msg.info("warning","转移单位是基本单位时数量不可再做拆分!");
				return;
			}
			*/
			var ReqItmId = '';
			var Remark ='';
			var HVFlag = rowData.get("HVFlag");
			var HVBarCode = rowData.get("HVBarCode");
			if(HVBarCode!=""){
				if(Qty!=0 && Qty!=1){
					Msg.info("warning","高值材料数量只能为1或0!");
					return;
				}else if(!CheckBarcode(HVBarCode)){
					return;
				}else{
					HVInIsTrfFlag = true;
				}
			}
			var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^" + ReqItmId
					+ "^" + Remark + "^" + HVBarCode + "^^^" + Ingri;
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+xRowDelim()+str;
			}				
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					params:{Rowid:'',MainInfo:MainInfo,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : '处理中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var InitRowid = jsonData.info;
							Msg.info("success", "保存成功!");
							// 跳转到出库制单界面
							if(HVInIsTrfFlag){
								window.location.href='dhcstm.dhcinistrfhv.csp?Rowid='+InitRowid+'&QueryFlag=1';
							}else{
								window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';
							}
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "加锁失败,不能保存!");
							}else if(ret==-2){
								Msg.info("error", "生成出库单号失败,不能保存!");
							}else if(ret==-1){
								Msg.info("error", "保存出库单失败!");
							}else if(ret==-5){
								Msg.info("error", "保存出库单明细失败!");
							}else {
								Msg.info("error", "部分明细保存不成功："+ret);
							}
							
						}
					},
					scope : this
				});			
	}

	/*
	 * 检查条码是否可以转移出库
	 */
	function CheckBarcode(Barcode) {
		var url='dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode;
		var itmResult=ExecuteDBSynAccess(url);
		var itmInfo=Ext.util.JSON.decode(itmResult);
		if(itmInfo.success == 'true'){
			var itmArr=itmInfo.info.split("^");
			var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
			var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
			if(inclb==""){
				Msg.info("warning",Barcode+"没有相应库存记录,不能制单!");
				return false;
			}else if(lastDetailAudit!="Y"){
				Msg.info("warning",Barcode+"有未审核的"+lastDetailOperNo+",请核实!");
				return false;
			}else if(type=="T"){
				Msg.info("warning",Barcode+"已经出库,不可制单!");
				return false;
			}else if(status!="Enable"){
				Msg.info("warning",Barcode+"处于不可用状态,不可制单!");
				return false;
			}
			
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
				+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
			var LBResult=ExecuteDBSynAccess(url);
			var info=Ext.util.JSON.decode(LBResult);
			if(info.results=='0'){
				Msg.info("warning",Barcode+"没有相应库存记录,不能制单!");
				return false;
			}
			return true;
		}else{
			Msg.info("error",Barcode+"尚未注册!");
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
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
	
	}
	
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
			
	CTUom.on('beforequery', function(e) {
				CTUom.store.removeAll();
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
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
				var BUom = record.get("BUomId");
				var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系					
				var TrUom = record.get("TrUomId");    //目前显示的出库单位
				var Sp = record.get("Sp");
				var Rp = record.get("Rp");
				var InclbQty=record.get("StkQty");
				var DirtyQty=record.get("DirtyQty");
				var AvaQty=record.get("AvaQty");
				var TrQty=record.get("TrQty");
				if (value == null || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("Sp", accDiv(Sp,ConFac));
					record.set("Rp", accDiv(Rp,ConFac));
					record.set("StkQty", accMul(InclbQty,ConFac));
					record.set("DirtyQty", accMul(DirtyQty,ConFac));
					record.set("AvaQty", accMul(AvaQty,ConFac));
					record.set("TrQty", accMul(TrQty,ConFac));
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("Sp", accMul(Sp,ConFac));
					record.set("Rp", accMul(Rp,ConFac));
					record.set("StkQty", accDiv(InclbQty,ConFac));
					record.set("DirtyQty", accDiv(DirtyQty,ConFac));
					record.set("AvaQty", accDiv(AvaQty,ConFac));
					record.set("TrQty", accDiv(TrQty,ConFac));
				}
				record.set("TrUomId", combo.getValue());
	});
	
	// 显示入库单数据
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供给部门!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var status = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var Vendor = Ext.getCmp("Vendor").getValue();
		
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+supplyphaLoc+'^'+status+'^'+requestphaLoc;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam("ParamStr",ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "查询错误，请查看日志!");
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
	
	// 访问路径
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryImport';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["IngrId", "IngrNo", "RecLoc", "ReqLoc", "Vendor","CreateUser", "CreateDate","Status","StkGrpId","StkGrpDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
var	sm1=new Ext.grid.CheckboxSelectionModel({checkOnly:true})
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1, {
				header : "RowId",
				dataIndex : 'IngrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "入库单号",
				dataIndex : 'IngrNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "请求部门",
				dataIndex : 'ReqLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供给部门",
				dataIndex : 'RecLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "入库日期",
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "入库人",
				dataIndex : 'CreateUser',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "转移状态",
				dataIndex : 'Status',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'StkGrpDesc',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
 id:'MasterGrid',
				region: 'west',
				title: '入库单',
				collapsible: true,
				split: true,
				width: 300,
				minSize: 175,
				maxSize: 400,
				cm : MasterCm,
				sm:sm1,
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});
	// 添加表格单击行事件
	MasterGrid.getSelectionModel().on('selectionchange', function(ssm){
	clearTimeout(timer)
	timer=change.defer(100,this,[ssm])
	});
	
	function change(ssm){
		var recarr=ssm.getSelections();
		var count=recarr.length;
		var reqidstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('IngrId');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				//alert(reqidstr)
		}
		reqidstr=reqidstr
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',reqidstr);
		//DetailStore.setBaseParam('refuseflag',0);
		DetailStore.load({params:{Parref:reqidstr}});
	
	}
	
	// 转移明细
	// 访问路径
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryImportDetail&Parref=&start=0&limit=999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["Ingri", "BatchNo", "TrUomId","TrUom","ExpDate", "Inclb", "TrQty", "IncId",
			 "IncCode", "IncDesc", "Manf","Rp","RpAmt", "Sp", "SpAmt", "BUomId",
			 "ConFacPur", "StkQty", "DirtyQty","AvaQty","BatExp","HVFlag","HVBarCode"
			];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "入库明细id",
				dataIndex : 'Ingri',
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
				header : "批次RowId",
				dataIndex : 'Inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批号~效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "高值标志",
				dataIndex : 'HVFlag',
				width : 80,
				align : 'center',
				sortable : true,
				hidden : true
			},{
				header : "高值条码",
				dataIndex : 'HVBarCode',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'StkQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "转移数量",
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
								
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "转移数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "转移数量不能小于或等于0!");
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var record = DetailGrid.getStore()
										.getAt(cell[0]);
								var salePriceAMT = record
										.get("Sp")
										* qty;
								record.set("SpAmt",
										salePriceAMT);
								var AvaQty = record.get("AvaQty");
								if (qty > AvaQty) {
									Msg.info("warning", "转移数量不能大于可用库存数量!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "转移单位",
				dataIndex : 'TrUomId',
				width : 50,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(CTUom,"TrUomId","TrUom"),
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "占用数量",
				dataIndex : 'DirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "可用数量",
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "转换率",
				dataIndex : 'ConFacPur',
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
			}]);

	var DetailGrid = new Ext.ux.GridPanel({
				region : 'center',
				title : '入库单明细',
				id : 'DetailGrid',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				plugins : new Ext.grid.GridSummary()
			});

	DetailGrid.on('beforeedit',function(e){
		if(e.field=="TrQty" || e.field=="TrUomId"){
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if(rowData!=null && rowData!=""){
				if(rowData.get('Status')=='已转移'){
					e.cancel=true;	//已转移的单据,不可修改转移数量
				}
			}
			if(e.record.get('HVBarCode')!=""){
				e.cancel=true;
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

	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.ux.FormPanel({
		title:'库存转移-依据入库单',
		labelWidth: 80,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px',
			defaults: {width: 220, border:false},    // Default config options for child items
			items:[{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [SupplyPhaLoc,Vendor]
			},{
				columnWidth: UseItmTrack?0.1:0.01,
				xtype: 'fieldset',
				items: UseItmTrack?[VirtualFlag]:[]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [StartDate,EndDate]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [RequestPhaLoc,TransStatus]
			}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, DetailGrid],
				renderTo : 'mainPanel'
			});
})