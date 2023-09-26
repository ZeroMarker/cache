// /名称: 根据转移请求制单
// /描述: 根据转移请求制单
// /编写者：zhangdongmei
// /编写日期: 2012.07.24
var TransferPageSize=9999;
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var userName=session['LOGON.USERNAME'];
	var gInitId='';
	var reqid=''; ///声明全局变量以保存请求单号到转移单
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
       //取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
	// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '请求部门',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				//anchor : '70%',				
				emptyText : '请求部门...',				
				listWidth : 250,
				//groupId:session['LOGON.GROUPID'],
				defaultLoc:""
			});
	
	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '供给部门',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				//anchor : '70%',
				emptyText : '供给部门...',
				listWidth : 250,
				groupId:session['LOGON.GROUPID']
			});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				width : 120,
				value : DefaultEdDate()
			});
	
	// 包含部分转移
	var PartlyStatus = new Ext.form.Checkbox({
				//fieldLabel : '包含部分转移',
				boxLabel:'包含部分转移',
				hideLable:true,
				id : 'PartlyStatus',
				name : 'PartlyStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
			
var TransStatus = new Ext.form.Checkbox({
				boxLabel : '包含已转移',
				id : 'TransStatus',
				name : 'TransStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
			
	// 查询转移单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询请求单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});

	// 导出按钮
	var ExportBT = new Ext.Toolbar.Button({
				id : "ExportBT",
				text : '另存',
				tooltip : '点击导出',
				width : 70,
				height : 30,
				iconCls : 'page_excel',
				handler : function() {
					ExportAllToExcel(DetailGrid);
					//gridSaveAsExcel(DetailGrid);
				}
			});
	// 打印按钮
	var PrintBT = new Ext.Toolbar.Button({
				id : "PrintBT",
				text : '打印',
				tooltip : '点击打印',
				width : 70,
				height : 30,
				iconCls : 'page_print',
				handler : function() {
						PrintTransReq();
				}
			});	
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清屏',
				tooltip : '点击清屏',
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
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.store.load({params:{start:0,limit:0,Parref:"0"}});
		DetailGrid.getView().refresh();
	}
	 // 全选
	 var AllBT = new Ext.form.Checkbox({
					boxLabel : '作废全选',
					id : 'AllBT',
					name : 'AllBT',
					anchor : '90%',
					width : 120,
					checked : false,
					handler : function() {
						AllBTSel();
					}
	 });
      function AllBTSel(){
	   var AllValue=Ext.getCmp("AllBT").getValue();
	   var rowCount = DetailGrid.getStore().getCount();
	   if (AllValue==true){
		    for (var i = 0; i < rowCount; i++) {
			  DetailStore.getAt(i).set("cancel",1);
			}  
		     }
	   if (AllValue==false){
		    for (var i = 0; i < rowCount; i++) {
			   DetailStore.getAt(i).set("cancel",0);
			}
		     }
	      }
	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				id : "SaveBT",
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					Ext.getCmp("SaveBT").disable();
					setTimeout(ChangeSaveBtn,3000);//三秒后执行
					// 保存转移单
					if(CheckDataBeforeSave()==true){
						saveOrder();
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
		
		// 1.判断转移药品是否为空
		var rowCount = DetailGrid.getStore().getCount();
		// 有效行数
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("incidr");
			if (item != undefined) {
				count++;
			}
		}
		if(rowCount<=0){
			Msg.info("warning", "没有需要保存的数据!");
			return false;
		}
		if (count <= 0) {
			Msg.info("warning", "需要保存的数据无效!");
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
					Msg.info("warning", "药品批次重复，请重新输入!");
					return false;
				}
			}
		}
		// 4.药品信息输入错误
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var code = rowData.get("incicode");
			if (code == null || code.length == 0) {
				continue;
			}
			var item = rowData.get("incidr");
			if (item == undefined) {
				Msg.info("warning", "药品信息输入错误!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var qty = DetailStore.getAt(i).get("qty");
			if ((item != undefined) && (qty == null || qty < 0)) {
				Msg.info("warning", "转移数量不能小于0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}

			var avaQty = DetailStore.getAt(i).get("avaqty");
			if ((item != undefined) && ((qty - avaQty) > 0)) {
				Msg.info("warning", "转移数量不能大于可用库存数量!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		 // var cancelList=QueryListDetailID()
              //if (cancelList!=""&&gParam[9]=='Y'){			
                  // Msg.info("warning","有勾选的作废项没有作废!");
			//return;
			//}
		return true;
	}
	

	/**
	 * 保存转移单
	 */
	function saveOrder() {
		//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var rowData=MasterGrid.getSelectionModel().getSelected();
		if(rowData==null || rowData==""){
			Msg.info("warning","没有选择的请求单!");
			return;
		}else{
			reqid=rowData.get('req');
		}
		var operatetype = "";	
		var Complete='N';
		var Status=10;
		var StkGrpId = "";
		var StkType = App_StkTypeCode;					
		var remark = "";
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				var Initi = rowData.get("initi");
				var Inclb = rowData.get("inclb");
				var Qty = rowData.get("qty");
				var UomId = rowData.get("uomdr");
				var ReqItmId =rowData.get("inrqi");
				var Remark ="";
		      if (Qty>0){
				var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
						+ ReqItmId + "^" + Remark;	
                         if (DetailStore.getAt(i).get("cancel")!=true){				
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
                         }
			   }
			
		}
		if(ListDetail==""){
			Msg.info("warning","没有需要保存的数据!");
			return;
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
							window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

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

	// 显示出库单数据
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供应部门!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var PartlyStatus = (Ext.getCmp("PartlyStatus").getValue()==true?1:0);
		var TransStatus = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+PartlyStatus+'^'+TransStatus;
		var Page=GridPagingToolbar.pageSize;
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	// 显示入库单明细数据
	function getDetail(InitRowid) {
		if (InitRowid == null || InitRowid=='') {
			return;
		}
		var PartlyStatus = (Ext.getCmp("PartlyStatus").getValue()==true?1:0);
		var TransStatus = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var strParam=InitRowid+"^"+PartlyStatus+'^'+TransStatus
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize}});
	}
	
	// 访问路径
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
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
				dataIndex : 'req',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "请求单号",
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "请求部门",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供给部门",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "请求日期",
				dataIndex : 'date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "单据类型",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer : renderReqType,
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "转移状态",
				dataIndex : 'transferStatus',
				width : 80,
				align : 'left',
				renderer : renderStatus,
				sortable : true
			},{
				header : "请求部门ID",
				dataIndex : 'toLoc',
				width : 120,
				align : 'left',
				sortable : true,
				hidden : true
			}]);
	MasterCm.defaultSortable = true;
	
	function renderStatus(value){
		var InstrfStatus='';
		if(value==0){
			InstrfStatus='未转移';			
		}else if(value==1){
			InstrfStatus='部分转移';
		}else if(value==2){
			InstrfStatus='全部转移';
		}
		return InstrfStatus;
	}
	function renderReqType(value){
		var ReqType='';
		if(value=='O'){
			ReqType='请领单';
		}else if(value=='C'){
			ReqType='申领计划';
		}else if(value=='1'){
			ReqType='基数药品补货';
		}else if(value=='2'){
			ReqType='精神毒麻补货';
		}else if(value=='3'){
			ReqType='大输液补货';
		}
		return ReqType;
	}
	
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
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
				bbar:[GridPagingToolbar],
				viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var transferStatus=record.get("transferStatus");
						switch(transferStatus){
							case "1":
								return 'classTransPart';
								break;
							case "2":
								return 'classSalmon';
								break;
						}
				}
				}
			});

	// 添加表格单击行事件
	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
		var ReqId = MasterStore.getAt(rowIndex).get("req"); 
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		addComboData(RequestPhaLoc.getStore(),ReqLocId,ReqLocDesc);    //GetGroupDeptStore  这个store未定义，重新获取 yangsj2019-11-13
		Ext.getCmp("RequestPhaLoc").setValue(ReqLocId);
		var strParam=ReqId
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
	});
   MasterStore.on('load',function(){
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if ((rowData==null)||(rowData==undefined))
		{
			DetailStore.setBaseParam("Params","");
			DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
		}
	})	
	// 转移明细
	// 访问路径
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryReqDetail&Parref=&start=0&limit=9999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	//initi_inrqi_incidr_incicode_incidesc_inclb_batexp_manfName_inclbqty_qty_uomdr_uomdesc_sp_rqty_reqstkqty_stkbin_rp_spec_geneDesc_formDesc_spamt_buomdr_confac_dirtyqty_avaqty_transqty_rpamt_newsp
	// 指定列参数
	var fields = ["cancel","initi", "inrqi", "incidr","incicode","incidesc", "inclb", "batexp", "manfName",
			 "inclbqty","qty", "uomdr","uomdesc", "sp","rqty","reqstkqty","stkbin","rp","spec","geneDesc","formDesc","spamt","buomdr", "confac","dirtyqty","avaqty","transqty","rpamt","newsp","colorlevel","prostkqty" 
			  
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
	var DetailCm = new Ext.grid.ColumnModel([nm,{
		              header : "作废",
		              width : 50,
		              sortable: false,             
		              dataIndex: 'cancel',//数据源中的状态列             
		              renderer: function (v) {
		                       return '<input type="checkbox"'+(v=="1"?"checked":"")+'/>';  //根据值返回checkbox是否勾选    
		                       },
		              listeners : {
			              'click':function(e,b,row){

				              if (DetailStore.getAt(row).get("cancel")==""||DetailStore.getAt(row).get("cancel")==0)
				               {DetailStore.getAt(row).set("cancel",1);}
				              else{DetailStore.getAt(row).set("cancel",0);} 
				               
				               
				               }
			              
			              },
			      hidden:(gParam[9]=='Y'?false:true)
			             
		                     
		        }, {
				header : "转移细项RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "请求细项RowId",
				dataIndex : 'inrqi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品RowId",
				dataIndex : 'incidr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '药品代码',
				dataIndex : 'incicode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '药品名称',
				dataIndex : 'incidesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "批次RowId",
				dataIndex : 'inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "转移数量",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true,
				renderer:BiggerRender,
				editor : new Ext.ux.NumberField({
					selectOnFocus : true,
					formatType:'FmtSQ',
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
								var cell = DetailGrid.getSelectionModel().getSelectedCell();
								var record = DetailGrid.getStore().getAt(cell[0]);
								var salePriceAMT = record.get("sp")* qty;
								record.set("spamt",	salePriceAMT);
								var AvaQty = record.get("avaqty");
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
				dataIndex : 'uomdesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批号/效期",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "可用数量",
				dataIndex : 'avaqty',
				width : 80,
				align : 'right',
				sortable : true
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
				dataIndex : 'rqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "请求方库存",
				dataIndex : 'reqstkqty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "供给方库存",
				dataIndex : 'prostkqty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'inclbqty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "占用数量",
				dataIndex : 'dirtyqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'newsp',
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
				header : "处方通用名",
				dataIndex : 'geneDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'formDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'spamt',
				width : 100,
				align : 'right',				
				sortable : true,
				renderer:FormatGridSpAmount
			}, {
				header : "转换率",
				dataIndex : 'confac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "基本单位",
				dataIndex : 'buomdr',
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
			}, {
				header : "colorlevel",
				dataIndex : 'colorlevel',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}]);
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : DetailStore,
					pageSize : TransferPageSize,
					displayInfo : true,
					displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
					prevText : "上一页",
					nextText : "下一页",
					refreshText : "刷新",
					lastText : "最后页",
					firstText : "第一页",
					beforePageText : "当前页",
					afterPageText : "共{0}页",
					emptyMsg : "没有数据"
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
				//sm :new Ext.grid.RowSelectionModel({singleSelect:true}),
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				bbar:[StatuTabPagingToolbar],
				viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var colorlevel=record.get("colorlevel");
						switch(colorlevel){
							/*case "0":
								return 'classSalmon';
								break;*/
							case "-1":
								return 'classTransPart';
								break;
						}
				}
				}
			});

	/**
	 * 单位展开事件
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("inci");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	
	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}
	function BiggerRender(val){
				return '<span style="font-size:13px;font-weight:bold">'+val+'</span>';

	}

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT,'-',PrintBT,'-',ExportBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			defaults: {border:false},    // Default config options for child items
			style:DHCSTFormStyle.FrmPaddingV,
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [SupplyPhaLoc,RequestPhaLoc]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',	
	        	labelWidth:10,        	
	        	items: [PartlyStatus,TransStatus]
	        }]
		}]
	});
	 function QueryListDetailID(){
	      //var sm=DetailGrid.getSelectionModel()
	      //var records=sm.getSelections()  //返回的是Ext.data.Record对象数组
	      //var count=records.length
	      var rowCount = DetailGrid.getStore().getCount();
	      var listdata=""
            for (var i=0;i<rowCount;i++) {
	         if (DetailStore.getAt(i).get("cancel")==true && listdata==""){
	              listdata=DetailStore.getAt(i).get("inrqi");
	         }
	         else if(DetailStore.getAt(i).get("cancel")==true && listdata!=""){
		       listdata=listdata+"^"+DetailStore.getAt(i).get("inrqi");
		      }
	       } 
		return  listdata;   
	   }
	   	 
		
	 
	 
	 //批量作废选中项函数 wyx 2014-06-23
	 function CancelDetailsAction(ListDetailID){
		    	// 访问路径
	         var url =DictUrl+
		        'inrequestaction.csp?actiontype=CancelReqItm';
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ListDetailID:ListDetailID},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {				
								Msg.info("success", "作废成功!");
								// 重新加载数据	
       						    MasterStore.reload();
       							DetailStore.reload();
       							DetailGrid.getView().refresh();
							} else {
								//var ret=jsonData.info;
									Msg.info("error", "作废失败!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
	
	function CancelSelectAll(){
		var toggleselect=(Ext.getCmp("AllBT").getValue()==false) ? true : false;
		Ext.getCmp("AllBT").setValue(toggleselect);

	}
		function CancelDetails() {
         // 用户对话框
                   Ext.Msg.show({
	                 title:'批量作废选中项',
	                 msg:'确定批量作废选中项？',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    var ListDetailID=QueryListDetailID();
		                    if (ListDetailID=="") {Msg.info("warning","没有勾选作废项!");}
		                    if (ListDetailID!=""){
		                        CancelDetailsAction(ListDetailID); 
		                    }
		                 }
                        
	                     }

	                 });
		}	
		function DeleteDetail()
		{
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "没有选中行!");
				return;
			}
			var row = cell[0];
			var thisrowData = DetailStore.getAt(row);	
			DetailGrid.getStore().remove(thisrowData);
			DetailGrid.getView().refresh();
		}
		///依据请求出库修改批次功能,yunhaibao20151117
		function ChangeInclb() {
			var rowMainData=MasterGrid.getSelectionModel().getSelected();
			var ReqLocId=""
			if(rowMainData==null || rowMainData==""){
				Msg.info("warning","没有选择的请求单!");
				return;
			}else{
				ReqLocId=rowMainData.get('toLoc');
			}
			if (ReqLocId=="")
			{
				Msg.info("warning", "没有选中行!");
				return
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "没有选中行!");
				return;
			}
			// 选中行
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var Inclb = record.get("inclb");
			INCItmLcBtInfo(Inclb, "", ReqLocId, ReplaceInclb)
		}	
		function ReplaceInclb(modifyrecord)
		{
			if (modifyrecord == null || modifyrecord == "") {
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			var thisrowData = DetailStore.getAt(selectRow);	
			for(var i=0;i<modifyrecord.length;i++){
				if (i!=0){
					insertNewRow(selectRow)	
				}
				var inclb = modifyrecord[i].data["Inclb"]
				var inci=modifyrecord[i].data["IncRowId"]
				var incidesc=modifyrecord[i].data["IncDesc"]
				var incicode=modifyrecord[i].data["IncCode"]
				var expdate=modifyrecord[i].data["BatExp"]
				var inclbqty=modifyrecord[i].data["InclbQty"]
				var reqlocqty=modifyrecord[i].data["RequrstStockQty"]
				var prolocqty=modifyrecord[i].data["SupplyStockQty"]
				var dirtyqty=modifyrecord[i].data["DirtyQty"]
				var avaqty=modifyrecord[i].data["AvaQty"]
				var initqty=modifyrecord[i].data["InitQty"]
				var confac=modifyrecord[i].data["ConFac"]
				var buomdr=modifyrecord[i].data["BUomId"]
				var requomdr=thisrowData.get("uomdr")
				if (requomdr==buomdr){//传过来的数量是入库单位数,如果请求单位为基本单位则需转换
					avaqty=avaqty*confac
					reqlocqty=reqlocqty*confac
					prolocqty=prolocqty*confac
					dirtyqty=dirtyqty*confac
					inclbqty=inclbqty*confac					
				}
				DetailStore.getAt(selectRow).set("inci", inci);
				DetailStore.getAt(selectRow).set("inclb", inclb);
				DetailStore.getAt(selectRow).set("batexp", expdate);
				DetailStore.getAt(selectRow).set("inclbqty", inclbqty);
				DetailStore.getAt(selectRow).set("reqstkqty", reqlocqty);
				DetailStore.getAt(selectRow).set("proLocStkQty", prolocqty);
				DetailStore.getAt(selectRow).set("dirtyqty", dirtyqty);
				DetailStore.getAt(selectRow).set("avaqty", avaqty);
				DetailStore.getAt(selectRow).set("qty", initqty);
				//复制原行数据
				DetailStore.getAt(selectRow).set("cancel", thisrowData.get("cancel"));
				DetailStore.getAt(selectRow).set("initi", thisrowData.get("initi"));
				DetailStore.getAt(selectRow).set("inrqi", thisrowData.get("inrqi"));
				DetailStore.getAt(selectRow).set("incidr", thisrowData.get("incidr"));
				DetailStore.getAt(selectRow).set("incicode", thisrowData.get("incicode"));
				DetailStore.getAt(selectRow).set("incidesc", thisrowData.get("incidesc"));
				DetailStore.getAt(selectRow).set("manfName", thisrowData.get("manfName"));
				DetailStore.getAt(selectRow).set("uomdr", thisrowData.get("uomdr"));
				DetailStore.getAt(selectRow).set("uomdesc", thisrowData.get("uomdesc"));
				DetailStore.getAt(selectRow).set("sp", thisrowData.get("sp"));
				DetailStore.getAt(selectRow).set("rqty", thisrowData.get("rqty"));
				DetailStore.getAt(selectRow).set("stkbin", thisrowData.get("stkbin"));
				DetailStore.getAt(selectRow).set("rp", thisrowData.get("rp"));
				DetailStore.getAt(selectRow).set("spec", thisrowData.get("spec"));
				DetailStore.getAt(selectRow).set("geneDesc", thisrowData.get("geneDesc"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));
				DetailStore.getAt(selectRow).set("buomdr", thisrowData.get("buomdr"));
				DetailStore.getAt(selectRow).set("confac", thisrowData.get("confac"));
				DetailStore.getAt(selectRow).set("newsp", thisrowData.get("newsp"));
			}	
			DetailGrid.getView().refresh();
		}
		//插入行,20150530,yunhaibao
		function insertNewRow(RowNum)
		{
			var record = Ext.data.Record.create([
			{
				name : 'cancel',
				type : 'string'
			}, {
				name : 'initi',
				type : 'string'
			}, {
				name : 'inrqi',
				type : 'string'
			}, {
				name : 'incidr',
				type : 'string'
			}, {
				name : 'incicode',
				type : 'string'
			}, {
				name : 'incidesc',
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
			},{	
				name : 'inclbqty',
				type : 'int'
			}, {
				name : 'qty',
				type : 'int'
			}, {
				name : 'uomdr',
				type : 'int'
			}, {
				name : 'uomdesc',
				type : 'string'
			}, {
				name : 'sp',
				type : 'double'
			}, {
				name : 'rqty',
				type : 'double'
			}, {
				name : 'reqstkqty',
				type : 'double'
			}, {
				name : 'stkbin',
				type : 'double'
			}, {
				name : 'rp',
				type : 'double'
			},{
				name:'spec',
				type:'string'
			},
			{
				name:'geneDesc',
				type:'string'	
			},
			{
				name:'formDesc',
				type:'string'	
			},
			{
				name:'spamt',
				type:'double'	
			},
			{
				name:'buomdr',
				type:'string'	
			},
			{
				name:'confac',
				type:'string'	
			},
			{
				name:'dirtyqty',
				type:'double'	
			},
			{
				name:'avaqty',
				type:'double'	
			},
			{
				name:'transqty',
				type:'double'	
			},
			{
				name:'rpamt',
				type:'double'	
			},
			{
				name:'newsp',
				type:'double'	
			},
			{
				name:'proLocStkQty',
				type:'double'	
			}
		]);
	
		var NewRecord = new record({
			cancel:'',
			initi:'',
			inrqi:'',
			incidr:'',
			incicode:'',
			incidesc:'',
			inclb:'',
			batexp:'', 
			manfName:'',
			inclbqty:'',
			qty:'',
			uomdr:'',
			uomdesc:'',
			sp:'',
			rqty:'',
			reqstkqty:'',
			stkbin:'',
			rp:'',
			spec:'',
			geneDesc:'',
			formDesc:'',
			spamt:'',
			buomdr:'',
			confac:'',
			dirtyqty:'',
			avaqty:'',
			transqty:'',
			rpamt:'',
			newsp:'',
			proLocStkQty:'' 
		});
					
		DetailStore.insert(RowNum,NewRecord);
		}
		function InsertNewInclbData(Record,newqty)
		{		
			if (Record == null || Record == "") {
				return;
			}
			var rowMainData=MasterGrid.getSelectionModel().getSelected();
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			var thisrowData = DetailStore.getAt(selectRow);	
			var ReqLocId=rowMainData.get('toLoc'); //供给科室
			var inci=Record.get("IncRowId");
			var inrqi=Record.get("inrqi");
			var inci=Record.get("IncRowId");
			var incidesc=Record.get("IncDesc");
			var incicode=Record.get("IncCode");
			var reqlocqty=Record.get("reqstkqty");
			var prolocqty=Record.get("proLocStkQty");
			var inclbstr=tkMakeServerCall("web.DHCST.DHCINIsTrfItm","UpdateNewInclbForReq",inrqi,newqty)  //根据inclb获取其他批次信息
			if (inclbstr=="")
		    {
				return
		    }
			var inclbstrarr
			var inclblen
			inclbstrarr=inclbstr.split("!!")
			inclblen=inclbstrarr.length
			for (i=0;i<inclblen;i++ )
			{
				if (i!=0)
				{
					insertNewRow(selectRow)	
				}
				var inclbinfo=inclbstrarr[i]
				var inclbinfoarr=inclbinfo.split("^")
				var inclb=inclbinfoarr[0]
			    var inclbqty=inclbinfoarr[1]
				var initqty=inclbinfoarr[4]
				var dirtyqty=inclbinfoarr[2]
				var availqty=inclbinfoarr[3]
				var batexp=inclbinfoarr[5]
				DetailStore.getAt(selectRow).set("inci", inci);
				DetailStore.getAt(selectRow).set("inclb", inclb);
				DetailStore.getAt(selectRow).set("batexp", batexp);
				DetailStore.getAt(selectRow).set("inclbqty", inclbqty);
				DetailStore.getAt(selectRow).set("reqstkqty", reqlocqty);
				DetailStore.getAt(selectRow).set("proLocStkQty", prolocqty);
				DetailStore.getAt(selectRow).set("dirtyqty", dirtyqty);
				DetailStore.getAt(selectRow).set("avaqty", availqty);
				DetailStore.getAt(selectRow).set("qty", initqty);
				//复制原行数据
				DetailStore.getAt(selectRow).set("cancel", thisrowData.get("cancel"));
				DetailStore.getAt(selectRow).set("initi", thisrowData.get("initi"));
				DetailStore.getAt(selectRow).set("inrqi", thisrowData.get("inrqi"));
				DetailStore.getAt(selectRow).set("incidr", thisrowData.get("incidr"));
				DetailStore.getAt(selectRow).set("incicode", thisrowData.get("incicode"));
				DetailStore.getAt(selectRow).set("incidesc", thisrowData.get("incidesc"));
				DetailStore.getAt(selectRow).set("manfName", thisrowData.get("manfName"));
				DetailStore.getAt(selectRow).set("uomdr", thisrowData.get("uomdr"));
				DetailStore.getAt(selectRow).set("uomdesc", thisrowData.get("uomdesc"));
				DetailStore.getAt(selectRow).set("sp", thisrowData.get("sp"));
				DetailStore.getAt(selectRow).set("rqty", thisrowData.get("rqty"));
				DetailStore.getAt(selectRow).set("stkbin", thisrowData.get("stkbin"));
				DetailStore.getAt(selectRow).set("rp", thisrowData.get("rp"));
				DetailStore.getAt(selectRow).set("spec", thisrowData.get("spec"));
				DetailStore.getAt(selectRow).set("geneDesc", thisrowData.get("geneDesc"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));
				DetailStore.getAt(selectRow).set("buomdr", thisrowData.get("buomdr"));
				DetailStore.getAt(selectRow).set("confac", thisrowData.get("confac"));
				DetailStore.getAt(selectRow).set("newsp", thisrowData.get("newsp"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));

			}
			DetailGrid.getView().refresh();
		}
			/***
		**添加右键菜单,wyx,2014-06-23***
		**/
		//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); //获取坐标
           
		}
		DetailGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mncancelSelectAll', 
					handler: CancelSelectAll, 
					text: '全选作废列',
					click:true
					 
				},{ 
					id: 'mncancelDetails', 
					handler: CancelDetails, 
					text: '批量作废',
					click:true,
					hidden:(gParam[9]=='Y'?false:true)
					 
				},{ 
					id: 'mnchangeInclb', 
					handler: ChangeInclb, 
					text: '修改批次',
					click:true					 
				},{ 
					id: 'mndelete', 
					handler: DeleteDetail, 
					text: '删除',
					click:true					 
				}
				]
		})
	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		            	title:'库存转移-依据请求单',
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: '请求单',
		                collapsible: true,
		                split: true,
		                width: 400, // give east and west regions a width
		                minSize: 175,
		                maxSize: 600,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: '请求单明细',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
			
	
	Query();
	
	
	/*
	* @creator: Huxt 2019-12-27
	* @desc: xml替代Excel打印
	*/
	function PrintTransReq(){
		var prtData = GetPrintData();
		if (prtData == null) {
			return;
		}
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHAINStockTransReq',
			data: prtData,
			listBorder: {style:4, startX:1, endX:190},
			aptListFields: ["label14", "printUserName", "label16", "perintDate"],
			page: {rows:28, x:4, y:4, fontname:'黑体', fontbold:'false', fontsize:'12', format:'第{1}页/共{2}页'},
		});
	}
	
	/*
	* @desc: 获取打印数据的json格式
	*/
	function GetPrintData(){
		var nowdate = new Date();
		var pritntimenow = nowdate.getFullYear()+"-"+(nowdate.getMonth()+1)+"-"+nowdate.getDate()+" "+(nowdate.getHours())+":"+(nowdate.getMinutes())+":"+(nowdate.getSeconds());
		var rowCount = DetailStore.getCount();
		if (rowCount == 0) {
			Msg.info("warning", "没有明细数据!");
			return null;
		}
		var gTotalNum = rowCount;
		
		//主信息
		var rowMainData = MasterGrid.getSelectionModel().getSelected();
		if(rowMainData == null || rowMainData==""){
			Msg.info("warning", "没有选择的请求单!");
			return null;
		} else {
			var prolocdesc = rowMainData.get('frLocDesc');
			var reqlocdesc = rowMainData.get('toLocDesc');
			var reqno = rowMainData.get('reqNo');
		}
		var Para = {
			title: App_LogonHospDesc + prolocdesc + "发放单",
			reqNo: reqno,
			reqlocdesc: reqlocdesc,
			printUserName: session['LOGON.USERNAME'],
			perintDate: pritntimenow
		}
		
		var sumspamt = 0;
		var List = [];
		for(var i=0; i<rowCount; i++){
			var rowData = DetailStore.getAt(i);
			var incidesc = rowData.get("incidesc"); //名称
			var formDesc = rowData.get("formDesc"); //剂型
			var rqty = rowData.get("rqty"); //请领数
			var qty = rowData.get("qty"); //实发数
			var uomdesc = rowData.get("uomdesc"); //单位
			var sp = rowData.get("sp");
			var spamt = rowData.get("spamt");
			var inclbqty = rowData.get("inclbqty");
			var diffflag = parseFloat(inclbqty)<parseFloat(rqty) ? "★" : "";
			List.push({
				num: i+1,
				incidesc: incidesc,
				formDesc: formDesc,
				rqty: rqty,
				qty: qty,
				uomdesc: uomdesc,
				sp: sp,
				spamt: spamt,
				diffflag: diffflag
			});
			sumspamt = sumspamt + parseFloat(spamt);
		}
		//合计行
		List.push({num: "",incidesc: "合计",formDesc: "",rqty: "",qty: "",uomdesc: "",sp: "",spamt: sumspamt.toFixed(2),diffflag: ""});
		
		return {
			Para: Para,
			List: List
		}
	}
	
})

