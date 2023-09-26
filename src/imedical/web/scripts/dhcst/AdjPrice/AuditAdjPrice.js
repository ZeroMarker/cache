// /名称: 审核调价单
// /描述: 审核调价单
// /编写者：zhangdongmei
// /编写日期: 2012.02.10
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth需要改一下
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		var InciDr = new Ext.form.TextField({
					fieldLabel : '药品RowId',
					id : 'InciDr',
					name : 'InciDr',
					anchor : '90%',
					width : 140,
					valueNotFoundText : ''
				});

		var ItmDesc = new Ext.form.TextField({
					fieldLabel : '药品名称',
					id : 'ItmDesc',
					name : 'ItmDesc',
					anchor:'90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								GetPhaOrderInfo(field.getValue(),
													'');
							}
						}
					}
				});

		// 调价单号
		var AdjSpNo = new Ext.form.TextField({
					fieldLabel : '调价单号',
					id : 'AdjSpNo',
					name : 'AdjSpNo',
					anchor:'90%',
					width : 100
				});

		// 起始日期
		var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor:'90%',
				width : 120,
				value : new Date().add(Date.DAY,-1)
			});

		// 结束日期
		var EndDate= new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor:'90%',
				width : 120,
				value : new Date()
			});

		var TypeStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['No', '未审核'], ['Audit', '已审核未生效']]
					//['Yes', '已生效']
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : '调价单状态',
					id : 'Type',
					name : 'Type',
					width : 100,
					anchor:'90%',
					store : TypeStore,
					triggerAction : 'all',
					mode : 'local',
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					editable : false,
					valueNotFoundText : ''
				});
		Ext.getCmp("Type").setValue("No");
		
		ReasonForAdjSpStore.load();
		var AdjSpReason = new Ext.form.ComboBox({
					fieldLabel : '调价原因',
					id : 'AdjSpReason',
					name : 'AdjSpReason',
					anchor:'90%',
					width : 100,
					store : ReasonForAdjSpStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '调价原因...',
					selectOnFocus : true,
					forceSelection : true,
					listWidth : 150,
					minChars : 1,
					valueNotFoundText : ''
				});
		
		// 查询未审核调价单按钮
		var SearchBT = new Ext.Toolbar.Button({
					id : "SearchBT",
					text : '查询',
					tooltip : '点击查询',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						getAspDetail();
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
			Ext.getCmp("InciDr").setValue("");
			Ext.getCmp("AdjSpNo").setValue("");
			Ext.getCmp("ItmDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1).format(App_StkDateFormat));
			Ext.getCmp("EndDate").setValue(new Date().format(App_StkDateFormat));
            Ext.getCmp("Type").setValue("No");
			//Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// 变更按钮是否可用
			//changeButtonEnable("1^1^1^1^1^0^0^0");
		}

		// 审核按钮
		var AuditBT = new Ext.Toolbar.Button({
					id : "AuditBT",
					text : '审核',
					tooltip : '点击审核',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						
						// 审核调价单
						//auditOrder();
						CheckPreDate();
						// 变更按钮是否可用
						//changeButtonEnable("0^0^1^1^1^1^1^1");
					}
				});
		/// 检查计划生效日期
		function CheckPreDate()
		{
			var DateFlag=0;
			var StrAspId="";
			//获得选择项
			var sm = DetailGrid.getSelectionModel();
			var store = DetailGrid.getStore();
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {				
				//循环每条选择的数据
				if(sm.isSelected(i)){
					var record = store.getAt(i);
					
					var detailId = record.get('AspId');	
					var PreExecuteDate = record.get('PreExecuteDate');	
					var ret=tkMakeServerCall("web.DHCST.INAdjSalePrice","CheckDateAndCur",PreExecuteDate)
					if(ret==0) DateFlag=-1
					if(ret!=0) continue;
					if(StrAspId==""){
						StrAspId=detailId;
					}
					else{
						StrAspId=StrAspId+"^"+detailId;
					}
				}
			}
			if(DateFlag==-1) 
			{
				    Ext.Msg.confirm('提示:计划生效日期校验','计划生效日期 <font color="yellow"> (黄色日期)</font>小于或者等于今日，审核后任务无法生效，是否修改计划日期为明天再审核？',
					      function(btn){
						if(btn=='yes'){
						  var ret=tkMakeServerCall("web.DHCST.INAdjSalePrice","UpDateAspPreDate",StrAspId)
						  if(ret==0) auditOrder();	
						  else {
									Msg.info("warning", "更新计划生效日期失败!");
									return;
								}				
						}else{
						  return;
						}
					 },this);
			}
			else auditOrder();	
					
		}
				
			

		/**
		 * 审核调价单
		 */
		function auditOrder() {
		
			//获得选择项
			var sm = DetailGrid.getSelectionModel();
			var store = DetailGrid.getStore();
			var rowCount = DetailGrid.getStore().getCount();
			var StrAspId="";
			
			for (var i = 0; i < rowCount; i++) {				
				//循环每条选择的数据
				if(sm.isSelected(i)){
					var record = store.getAt(i);
					var detailId = record.get('AspId');	
					
					if(StrAspId==""){
						StrAspId=detailId;
					}
					else{
						StrAspId=StrAspId+"^"+detailId;
					}
				}
			}
			
			if(StrAspId==""){
				Msg.info("warning","未勾选需要审核的记录!");
				return;
			}		
			var mask=ShowLoadMask(Ext.getBody(),"处理中...");
			//提交数据库执行审核
			Ext.Ajax.request({
				url : DictUrl+'inadjpriceaction.csp?actiontype=AuditAsp'
				+'&StrAspId='+StrAspId+'&AuditUser='+userId,
				method : 'POST',
				success : function(response) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					mask.hide();
					if(jsonData.info==0){
						Msg.info("success", "审核成功！");
					}
					else if(jsonData.info==-1){
						Msg.info("warning", "错误：存在已审核或已生效的调价记录!");
						return;
					}else if(jsonData.info==-2){
						Msg.info("warning", "错误：计划生效日期不能为空!");
						return;
					}else if(jsonData.info==-3){
						Msg.info("warning", "错误：存在已经过期调价单!");
						return;
					}else if(jsonData.info==-4){
						Msg.info("error", "错误：更新调价单状态失败!");
						return;
					}else if(jsonData.info==-5){
						Msg.info("error", "错误：调价单生效失败!");
						return;
					}else{
						Msg.info("error", "错误:"+jsonData.info);
						return;
					}
					
					getAspDetail();
				},
				failure : function(response){
					Msg.info("error", "审核发生错误："+response.responseText);					
					return;
				}
			});		
		}
		
		// 取消审核按钮
		var CancelAuditBT = new Ext.Toolbar.Button({
					id : "CancelAuditBT",
					text : '取消审核',
					tooltip : '点击取消审核',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						cancelAuditOrder();
					}
				});
		
		function cancelAuditOrder(){
			//获得选择项
			var sm = DetailGrid.getSelectionModel();
			var store = DetailGrid.getStore();
			var rowCount = DetailGrid.getStore().getCount();
			var StrAspId="";
			for (var i = 0; i < rowCount; i++) {				
				//循环每条选择的数据
				if(sm.isSelected(i)){
					var record = store.getAt(i);
					var detailId = record.get('AspId');	
					if(StrAspId==""){
						StrAspId=detailId;
					}
					else{
						StrAspId=StrAspId+"^"+detailId;
					}
				}
			}
			if(StrAspId==""){
				Msg.info("warning","未勾选需要取消审核的记录!");
				return;
			}		
			var mask=ShowLoadMask(Ext.getBody(),"处理中...");
			//提交数据库执行审核
			Ext.Ajax.request({
				url : DictUrl+'inadjpriceaction.csp?actiontype=CancelAuditAsp'
				+'&StrAspId='+StrAspId+'&CancelUser='+userId,
				method : 'POST',
				success : function(response) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					mask.hide();
					if(jsonData.info==0){
						Msg.info("success", "取消审核成功！");
					}
					else if(jsonData.info==-1){
						Msg.info("warning", "错误：存在不是审核状态的调价记录!");
						return;
					}else if(jsonData.info==-2){
						Msg.info("error", "错误：更新调价单状态失败!");
						return;
					}else{
						Msg.info("error", "错误:"+jsonData.info);
						return;
					}
					getAspDetail();
				},
				failure : function(response){
					Msg.info("error", "取消审核发生错误："+response.responseText);					
					return;
				}
			});
		}
				
		// 调价明细
		// 访问路径
		var DetailUrl =DictUrl+ 'inadjpriceaction.csp?actiontype=QueryAspInfo';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
						
		// 指定列参数
		var fields = ["AspId", "AspNo","StkCatDesc", "InciId", "InciCode","InciDesc", 
				 "AspUomDesc","PriorSpUom", "ResultSpUom", "DiffSpUom",
				"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate","Status","ExecuteDate",
				"PreExecuteDate", "AdjReasonId", "AdjReason","Remark",  "AdjUserName","MarkType", "PriceFileNo", "MaxSp"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "AspId",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{
						StartDate:'',
						EndDate:'',
						Others:''
					}
				});
		var detailSM = new Ext.grid.CheckboxSelectionModel();
		//注册选择监听事件
		/*
		detailSM.on('selectionchange',function(thisSM){
				var selRows=thisSM.getCount();
				if(selRows<=0){
					deleteBT.disable();
				}else{
					deleteBT.enable();
				}
		});
		*/
		function DateColorRenderer(val,meta){
			var ret=tkMakeServerCall("web.DHCST.INAdjSalePrice","CheckDateAndCur",val)
			if(ret==0)
			meta.css='classYellow';
			return val
		
		}
		
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, detailSM,{
					header : "AdjSpRowId",
					dataIndex : 'AspId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "调价单号",
					dataIndex : 'AspNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "状态",
					dataIndex : 'Status',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "库存分类",
					dataIndex : 'StkCatDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '药品代码',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '药品名称',
					dataIndex : 'InciDesc',
					width : 230,
					align : 'left',
					sortable : true
				}, {
					header : "调价单位",
					dataIndex : 'AspUomDesc',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "调前售价",
					dataIndex : 'PriorSpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "调后售价",
					dataIndex : 'ResultSpUom',
					width : 80,
					align : 'right',
					sortable : true		
				}, {
					header : "差价(售价)",
					dataIndex : 'DiffSpUom',
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
					sortable : true
				}, {
					header : "差价(进价)",
					dataIndex : 'DiffRpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "制单日期",
					dataIndex : 'AdjDate',
					width : 100,
					align : 'left',
					sortable : true				
				}, {
					header : "计划生效日期",
					dataIndex : 'PreExecuteDate',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:DateColorRenderer,
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							///specialkey : function(field, e) {
							'change' :function(field, e) {
								///if (e.getKey() == Ext.EventObject.ENTER) {
									
									var expDate = field.getValue();
									if (expDate == null || expDate.length <= 0) {
										Msg.info("warning", "计划生效日期不能为空!");
										return;
									}

									var nowdate = new Date();
									if (expDate.format("Y-m-d") <= nowdate
											.format("Y-m-d")) {
										Msg.info("warning", "计划生效日期不能小于或等于当前日期!");
										return;
									}
									///addNewRow();
								///}
							},
							'specialkey': function(field, e) {
								
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
										addNewRow();
									}

									
								}
							}
						}
					})
				}, {
					header : "实际生效日期",
					dataIndex : 'ExecuteDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "调价原因",
					dataIndex : 'AdjReasonId',
					width : 100,
					align : 'left',					
					sortable : true,
					renderer : Ext.util.Format.comboRenderer(AdjSpReason)
				}, {
					header : "调价人",
					dataIndex : 'AdjUserName',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "定价类型",
					dataIndex : 'MarkType',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "物价文件号",
					dataIndex : 'PriceFileNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "最高售价",
					dataIndex : 'MaxSp',
					width : 90,
					align : 'right',
					sortable : true
				}]);

		var DetailPageToolBar=new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:'没有记录',
			firstText:'第一页',
			lastText:'最后一页',
			nextText:'下一页',
			prevText:'上一页'		
		});
		DetailPageToolBar.addListener('beforechange',function(ptbar,params){
			var selrows=DetailGrid.getSelectionModel().getCount();
			if(selrows>0){
				Msg.info("warning","当前页选择了要审核的记录，请先审核后再翻页！");
				return false;
			}
		})
		var DetailGrid = new Ext.grid.GridPanel({
					id : 'DetailGrid',
					region : 'center',
					title : '调价单明细',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm :detailSM,
					bbar:DetailPageToolBar
				});

		/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, group) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
						getDrugList);
			}
		}

		/**
		 * 返回方法
		*/
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			;
			Ext.getCmp("ItmDesc").setValue(inciDesc);
			Ext.getCmp('InciDr').setValue(inciDr);			
			;			
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
			/*
			SearchInItBT.setDisabled(list[0]);
			SearchRqNoBT.setDisabled(list[1]);
			ClearBT.setDisabled(list[2]);
			AddBT.setDisabled(list[3]);
			SaveBT.setDisabled(list[4]);
			DeleteBT.setDisabled(list[5]);
			DeleteDrugBT.setDisabled(list[6]);
			CheckBT.setDisabled(list[7]);
			*/
		}

		// 显示调价单数据
		function getAspDetail() {
			var InciDesc=Ext.getCmp("ItmDesc").getValue();
			var InciRowid="";
			if(InciDesc!=null & InciDesc!="" & InciDesc.length >0){
				InciRowid=Ext.getCmp("InciDr").getValue();
			}			
			var AspNo=Ext.getCmp("AdjSpNo").getValue();
			var StartDate=Ext.getCmp("StartDate").getValue();
			var EndDate=Ext.getCmp("EndDate").getValue();
			var Status=Ext.getCmp("Type").getValue();
			var Others=AspNo+"^"+Status+"^"+InciRowid+"^"
			if (StartDate == null || StartDate.length <= 0 ) {
				Msg.info("warning", "开始日期不能为空！");
				Ext.getCmp("StartDate").focus();
				return;
			}
			else{
				StartDate=StartDate.format("Y-m-d");
			}
			if (EndDate == null || EndDate.length <= 0 ) {
				Msg.info("warning", "截止日期不能为空！");
				Ext.getCmp("EndDate").focus();
				return;
			}
			else{
				EndDate=EndDate.format("Y-m-d");
			}
			DetailStore.setBaseParam("StartDate",StartDate);
			DetailStore.setBaseParam("EndDate",EndDate);
			DetailStore.setBaseParam("Others",Others);
			var pagesize=DetailPageToolBar.pageSize;
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:pagesize}});
	
			// 变更按钮是否可用
			//changeButtonEnable("0^0^1^1^1^1^1^1");
		}
		
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 80,
			labelAlign : 'right',
			frame : true,
			title:'调价单审核',
			autoHeight:true,
			//bodyStyle : 'padding:5px;',
			tbar : [SearchBT, '-', ClearBT, '-',  AuditBT, '-', CancelAuditBT],
			items : [{					
					xtype : 'fieldset',
					title : '查询条件',
					autoHeight : true,
					style: DHCSTFormStyle.FrmPaddingV,
					defaults:{border:false},
					layout : 'column',									
					items : [{
						columnWidth : .25,
						xtype : 'fieldset',
						items : [StartDate,EndDate]
					},{
						columnWidth : .3,
						xtype : 'fieldset',
						items : [AdjSpNo,ItmDesc]
					},{
						columnWidth : .25,
						xtype : 'fieldset',
						items : [Type]
					}]								
			}]
					
		});

		// 页签
		var panel = new Ext.Panel({
					activeTab : 0,
					height : DHCSTFormStyle.FrmHeight(2),
					region : 'north',
					layout:'fit',
					items : [HisListTab]
				});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [panel, DetailGrid],
					renderTo : 'mainPanel'
				});
				
		getAspDetail();    //页面加载后显示未审核单据

})