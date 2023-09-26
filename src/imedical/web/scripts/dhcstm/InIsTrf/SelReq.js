// /名称: 根据转移请求制单
// /描述: 根据转移请求制单
// /编写者：zhangdongmei
// /编写日期: 2012.10.12
var timer=null; ///定义全局变量定时器   防止全选的时候 执行多次查询的问题
var SelReq=function(SupplyLocId,Fn,Fn1) {
	var userId = session['LOGON.USERID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ReqHosp = new Ext.ux.ComboBox({
	fieldLabel : '请求科室院区',
	id : 'ReqHosp',
	anchor : '90%',
	store : HospStore
});
	// 请求部门
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : '请求部门',
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:'请求部门',
		anchor : '90%',
		defaultLoc:{}
	}); 
	
	// 起始日期
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDateS',
				name : 'StartDate',
				anchor : '90%',
				value : DefaultStDate()
			});
	// 截止日期
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDateS',
				name : 'EndDate',
				anchor : '90%',
				value : DefaultEdDate()
			});
	
	// 包含部分转移
	var PartlyStatusS = new Ext.form.Checkbox({
				boxLabel : '包含部分转移',
				hideLabel : true,
				id : 'PartlyStatusS',
				name : 'PartlyStatus',
				anchor : '90%',
				checked : false,
				disabled : false
			});
	
	// 显示已完成转移的请求明细
	var ShowTransfered = new Ext.form.Checkbox({
				boxLabel : '显示转移完成',
				hideLabel : true,
				id : 'ShowTransfered',
				name : 'ShowTransfered',
				anchor : '90%',
				checked : false,
				disabled : false
			});
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'includeDefLoc',
			boxLabel : '包含支配科室',
			hideLabel : true,
			allowBlank:true
	});
	var reqTypeGroup=new Ext.form.RadioGroup({
		id:'reqTypeGroup',
		columns: 1,
		anchor : '90%',
		fieldLabel:'请领类型',
		defaults : {height : 20},
		items:[
			{boxLabel: '全部', name: 'reqType', inputValue: 'OC'},
			{boxLabel: '临时请求', name: 'reqType', inputValue: 'O',checked:true},
			{boxLabel: '申领计划', name: 'reqType', inputValue: 'C'}
		 ]
	});
	var ifShowTrf=new Ext.form.Checkbox({
			id: 'ifShowTrf',
			boxLabel :'显示已出库明细',
			checked : true,
			allowBlank:true
	});
	// 物资名称
		var inciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'inciDesc',
			name : 'inciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo(field.getValue(),"");
					}
				}
			}
		});

		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("inciDesc").setValue(InciDesc);
		}
		
	// 3关闭按钮
	var closeBTS = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findWin.close();
				}
			});
			
	// 查询请求单按钮
	var SearchBTS = new Ext.Toolbar.Button({
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
    // 退回申请按钮
	var returnDataBT = new Ext.Toolbar.Button({
				text : '退回申请',
				tooltip : '点击退回转移信息',
				iconCls : 'page_gear',
				height:30,
				width:70,
				handler : function() {
					returnDurgData();				
				}
			});	
	// 拒绝申请按钮
	var refDetailBT = new Ext.Toolbar.Button({
				text : '拒绝一条明细',
				tooltip : '点击拒绝转移信息',
				iconCls : 'page_gear',
				height:30,
				width:70,
				handler : function() {
					refDetail();
				}
			});	
	/////拒绝申请明细
	function refDetail(){		
		var selectRow=DetailGridS.getSelectionModel().getSelected();
		if (Ext.isEmpty(selectRow)){
			  Msg.info("warning", "请选择要拒绝的明细记录!");
			  return;
		}
		var reqi=selectRow.get("rowid");
		var mask=ShowLoadMask('findWin',"正在退回申请单...");
		var url=DictUrl+"inrequestaction.csp?actiontype=refuse&reqi="+reqi;
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// 刷新界面
          Msg.info("success", "拒绝申请单明细成功!");
			DetailStore.reload()

		} else {
			Msg.info("error", "拒绝申请单失败!");
		
		}	
	 }
	// 清空按钮
	var ClearBTS = new Ext.Toolbar.Button({
				id : "ClearBTSR",
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
		Ext.getCmp("RequestPhaLocS").setValue("");
		Ext.getCmp("inciDesc").setValue("");
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		Ext.getCmp("PartlyStatusS").setValue(false);
		Ext.getCmp("ShowTransfered").setValue(false);
		MasterGridS.store.removeAll();
		MasterGridS.getView().refresh();
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();		
	}

	// 保存按钮
	var SaveBTS = new Ext.ux.Button({
				id : "SaveBTS",
				text : '生成出库单',
				tooltip : '该功能可以选择多个请求单一起生成出库单',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {

					// 保存转移单
					if(CheckDataBeforeSave()==true){
						save();
					}
				}
			});

	
	/**
	 * 保存出库单前数据检查
	 */		
	function CheckDataBeforeSave() {
		if (SupplyLocId == null || SupplyLocId.length <= 0) {
			Msg.info("warning", "请关闭窗口，选择供应部门!");
			return false;
		}
		return true;
	}
	
 /**
	 * 退回请求单
	 */	
 function returnDurgData(){
		var InitRowid="";
		var supplyPhaLoc =SupplyLocId;
		var requestPhaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var selectRow=MasterGridS.getSelectionModel().getSelected();
		if(typeof(selectRow) == "undefined"){
			Msg.info("warning","没有要出库的请求单!");
			return;
		}
		var reqid=selectRow.get("req");
		if(reqid==null || reqid==""){
			Msg.info("warning","请选择要出库的请求单!");
			return;
		}
		var mask=ShowLoadMask('findWin',"正在退回申请单...");
		var url=DictUrl+"inrequestaction.csp?actiontype=CancelComp&req="+reqid+"&flag=T";
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// 刷新界面
			Msg.info("success", "退回申请单成功!");
			Query()
		} else {
			var Ret=jsonData.info;
			if(Ret==-11){
				Msg.info("error", "请求单已审核,不能退回申请!");
			}else if(Ret==-12){
				Msg.info("error", "请求方已审核,不能退回申请!");
			}else if(Ret==-13){
				Msg.info("error", "供应方已审核,不能退回申请!");
			}else if(Ret==-1){
				Msg.info("error", "该请求单已处理,不能退回申请!");
			}else{
				Msg.info("error", "退回申请单失败!"+Ret);
			}
		}
	 }
	/**
	 * 保存转移单
	 */
	function save() {
		var recarr=MasterGridS.getSelectionModel().getSelections();
		var count=recarr.length;
		if(count==0){Msg.info("warning","请选择要出库的请求单!");return};
		
		var reqidstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('req');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				
		}
		//供应科室RowId^请求科室RowId^制单人RowId
		var InitRowid="";
		var supplyPhaLoc =SupplyLocId;
		var requestPhaLoc = ""  ///Ext.getCmp("RequestPhaLocS").getValue();
		
		var issplit=IsSplit();
		var outType=OutType();
		
		var mask=ShowLoadMask(findWin.body, "正在生成出库单...");
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + userId +"^"+issplit+"^"+outType;
		if(UseItmTrack){
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CreateTransferByReqStrHV&MainInfo=" + MainInfo+"&ReqIdStr="+reqidstr;
		}else{
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CreateTransferByReqStr&MainInfo=" + MainInfo+"&ReqIdStr="+reqidstr;
		}
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// 刷新界面
			InitRowidStr = jsonData.info;
			//Msg.info("success", "生成出库单成功!");
			findWin.close();
			Fn1(InitRowidStr);
		} else {
			var ret=jsonData.info;
			if(ret==-99){
				Msg.info("error", "加锁失败,不能生成出库单!");
			}else if(ret==-2){
				Msg.info("error", "生成出库单号失败!");
			}else if(ret==-1){
				Msg.info("error", "生成出库单失败!");
			}else if(ret==-5){
				Msg.info("error", "生成出库单明细失败!");
			}else if(ret==-7){
				Msg.info("error", "没有需要转移的明细数据或可用库存不足!");
			}else if(ret==-101){
				Msg.info("error", "该请领单已经取消完成了!!");
			}else {
				Msg.info("error", "生成出库单失败："+ret);
			}
		}
	}
	
	//选取按钮
	var SelectBTS = new Ext.ux.Button({
		id : "SelectBTS",
		text : '选取',
		tooltip : '该功能只能选择一个请求单',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			var selectRows = MasterGridS.getSelectionModel().getSelections();
			if (selectRows.length > 1) {
				Ext.MessageBox.show({
								title : '提示',
								msg : '该功能只能选一个请求单是否继续操作?',
								buttons : Ext.MessageBox.YESNO,
								fn: function(b,t,o){
									if (b=='yes'){
										SelectReq();
									}
								},
								icon : Ext.MessageBox.QUESTION
							});
			}else{
				SelectReq();
			}
		}
	});	
	
	//选取方法
	function SelectReq(){
		var selectRows = MasterGridS.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择要返回的转移单信息！");
			return;
		}
		var Reqstore = DetailGridS.getStore();
		if(Reqstore.getCount()<0 ){
			Msg.info("warning", "转移单明细为空！");
			return;
		}
		var req = selectRows[0].get("req");
		var reqNo = selectRows[0].get("reqNo");
		var toLoc = selectRows[0].get("toLoc");
		var toLocDesc = selectRows[0].get("toLocDesc");
		var frLoc = selectRows[0].get("frLoc");
		var frLocDesc = selectRows[0].get("frLocDesc");
		var comp = selectRows[0].get("comp");
		var userName = selectRows[0].get("userName");
		var status = selectRows[0].get("status");
		var transferStatus = selectRows[0].get("transferStatus");
		var Remarks = selectRows[0].get("Remarks");
		var HVFlag = selectRows[0].get("HVFlag");
		var reqscg = selectRows[0].get("reqscg");  
		var reqscgdesc = selectRows[0].get("reqscgdesc");
		var ExpressFlag=selectRows[0].get("ExpressFlag");
        var datastr=req+"^"+reqNo+"^"+toLoc+"^"+toLocDesc+"^"+frLoc+"^"+frLocDesc+"^"+comp+"^"+userName+"^"+status+"^"+transferStatus+"^"+Remarks+"^"+HVFlag+"^"+reqscg+"^"+reqscgdesc+"^"+ExpressFlag
		var requestPhaLoc = ""  
		var issplit=IsSplit();
		var outType=OutType();
        var Mainstr = SupplyLocId + "^" + requestPhaLoc + "^" + userId +"^"+issplit+"^"+outType;
        var strinfo=Mainstr+"^"+req
        if(datastr!=""){
    		Fn(datastr,strinfo)
        }else 
        	{
        	   Msg.info("warning", "请选择要返回的转移单信息！");
        	}
		findWin.close();
	}

	// 显示请求单数据
	function Query() {
		var provlocAuditRequired=ProvLocAuditRequired();
		var issplit=IsSplit();
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();  //SupplyLocId;
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供应部门!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var inciDesc = Ext.getCmp("inciDesc").getValue();
		var startDate = Ext.getCmp("StartDateS").getValue();
		var endDate = Ext.getCmp("EndDateS").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var partlyStatus = (Ext.getCmp("PartlyStatusS").getValue()==true?1:0);
		var allStatus = (Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		var reqType=Ext.getCmp("reqTypeGroup").getValue().getGroupValue();
		var HV = gHVInIsTrf? "Y" : UseItmTrack? "N" : "";
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?1:0);  //是否包含支配科室
		var ReqHosp=Ext.getCmp("ReqHosp").getValue();
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+partlyStatus
				+'^'+allStatus+"^"+provlocAuditRequired+'^'+reqType+'^'+issplit+'^'+inciDesc
				+'^'+HV+'^'+userId+"^"+includeDefLoc+"^"+ReqHosp;
		
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
					if(success==false){
						Msg.info("error", "查询错误，请查看日志!");
					}else{
						if(r.length>0){
							MasterGridS.getSelectionModel().selectFirstRow();
							MasterGridS.getView().focusRow(0);
						}
					}
				}
		});
	
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();
	}
	
	// 访问路径
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["req", "reqNo", "toLoc","toLocDesc","frLoc","frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus","HVFlag","Remarks","reqscg","reqscgdesc","ExpressFlag"];
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
	var	sm1=new Ext.grid.CheckboxSelectionModel({
		singleSelect : gHVInIsTrf,	//2016-04-29 高值制单暂时按单选设置(如需求,要注意'选取'处理时的后台程序)
		checkOnly:true
	});
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1,{
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
				header : "转移状态",
				dataIndex : 'transferStatus',
				width : 80,
				align : 'left',
				renderer: renderStatus,
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
				header : "请求时间",
				dataIndex : 'time',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "单据状态",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer: renderReqType,
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "高值标志",
				dataIndex : 'HVFlag',
				width : 80,
				align : 'left'
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

	var MasterGridS = new Ext.ux.GridPanel({
		id:'MasterGridS',
		region: 'west',
		title: '请求单',
		collapsible: true,
		split: true,
		width: 230,
		margins: '0 5 0 0',
		layout: 'fit',
		cm : MasterCm,
		sm: sm1,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar
	});

	// 添加表格单击行事件
	MasterGridS.getSelectionModel().on('selectionchange', function(ssm){
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
			var reqid=rec.get('req');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				
		}
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',reqidstr);
		DetailStore.setBaseParam('refuseflag',0);
		if(IsSplit()=="Y"){
			DetailStore.setBaseParam('handletype',0);
		}
		DetailStore.setBaseParam('canceled',"Y");
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();  //SupplyLocId;
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?1:0);  //是否包含支配科室
		var ListParam=supplyphaLoc+"^"+includeDefLoc+"^"+userId;
		DetailStore.setBaseParam('ListParam',ListParam);
		if(Ext.getCmp('ifShowTrf').getValue()){
			DetailStore.setBaseParam('TransferedFlag',1);
		}else{
			DetailStore.setBaseParam('TransferedFlag',0);
		}
		
		DetailStore.load({
			params:{start:0,limit:GridDetailPagingToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info('error', '查询有误!');
				}
			}
		});
	}
	// 请求明细
	// 访问路径
//	var DetailUrl =DictUrl+
//		'inrequestaction.csp?actiontype=queryDetail';
	var DetailUrl =DictUrl+'dhcinistrfaction.csp?actiontype=GetReqDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["rowid", "inci", "code","desc","qty", "uom", "uomDesc", "spec",
			 "manf", "sp", "spAmt","generic","drugForm", "remark","transQty","NotTransQty",
			 "stkQty","reqno","reqlocdesc","ProLocAllAvaQty","qtyApproved","remark","rp","reqPuomQty","rpAmt"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,{
				header : "请求明细RowId",
				dataIndex : 'rowid',
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
			},{
				header : '请求单号',
				dataIndex : 'reqno',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '请求科室',
				dataIndex : 'reqlocdesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资代码',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'desc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "供应方库存",
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "供应方可用库存",
				dataIndex : 'ProLocAllAvaQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "请求数量",
				dataIndex : 'qty',
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
				header : "已转移数量",
				dataIndex : 'transQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "未转移数量",
				dataIndex : 'NotTransQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "单位",
				dataIndex : 'uomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}]);
	var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});

	var DetailGridS = new Ext.ux.GridPanel({
				id : 'DetailGridS',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridDetailPagingToolbar,
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
				viewConfig:{
					getRowClass : function(record,rowIndex,rowParams,store){ 
						var stkQty=parseFloat(record.get("stkQty"));
						var reqQty=parseFloat(record.get("qty"));
						var ProLocAllAvaQty=parseFloat(record.get("ProLocAllAvaQty"));
						var complete=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
						if(complete==0){
							if(ProLocAllAvaQty<=0){   //该情况不能出库 用红色表示
								return 'classRed';
							}
							if(ProLocAllAvaQty<reqQty){   //该情况能出库但是是部分出库 用黄色表示警示作用
								return 'classYellow';
							}
							
						}
					}
				}
			});
			
		DetailGridS.on('render', function(grid) {    	
			var view = grid.getView();
			 DetailGridS.tip = new Ext.ToolTip({    
		        target: view.mainBody,    // The overall target element.    
		    
		        delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.    
		    
		        trackMouse: true,         // Moving within the row should not hide the tip.    
		    
		        renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.    
		    
		        listeners: {              // Change content dynamically depending on which element triggered the show.    
		    
		            beforeshow: function updateTipBody(tip) { 
		            	//alert("tip")
		                   var rowIndex = view.findRowIndex(tip.triggerElement);
		                   record=DetailGridS.getStore().getAt(rowIndex);
		 					var stkQty=parseFloat(record.get("stkQty"));
							var reqQty=parseFloat(record.get("qty"));
							var ProLocAllAvaQty=parseFloat(record.get("ProLocAllAvaQty"));
							var complete=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
							if(complete==0){
								if(ProLocAllAvaQty<=0){
									tip.body.dom.innerHTML = "可用库存为0，不能出库";
								}else if(ProLocAllAvaQty<reqQty){
								    tip.body.dom.innerHTML = "请求数量大于供应科室可用库存，只能部分出库";
								}else{
									tip.body.dom.innerHTML = "库存可用足量可以完全出库";
								}
							}
		            }    
		        }    
		    });    
			
		});
	
	
	var HisListTab = new Ext.ux.FormPanel({
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			defaults: {border:false}, 
			style:"padding:5px 0px 0px 0px",
			layout: 'column',
			items : [{
				labelWidth:100,
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [ReqHosp,RequestPhaLocS,inciDesc]
			},{
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [StartDateS,EndDateS,ifShowTrf]
			},{
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [ShowTransfered,PartlyStatusS,includeDefLoc]
			},{
				columnWidth: 0.2,
	        	hideLables:true,
	        	items: [reqTypeGroup]
			}]
		}]
	});

	var findWin = new Ext.Window({
		title:'选取请求单',
		id:'findWin',
		width:gWinWidth,
		height:gWinHeight,
		plain:true,
		modal:true,
		layout : 'border',
		items : [HisListTab,MasterGridS,DetailGridS],
		tbar : [SearchBTS, '-',  ClearBTS,'-',((gHVInIsTrf)&&(InitParamObj.HVReqScanInit=="Y"))?"":SaveBTS, '-',((gHVInIsTrf)&&(InitParamObj.HVReqScanInit!="Y"))?"":SelectBTS,'-',returnDataBT,'-',refDetailBT, '-', closeBTS] //, '-', gHVInIsTrf?"":SelectBTS
		
	});
		
	//显示窗口
	findWin.show();
	Query();		
}