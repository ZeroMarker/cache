// /名称:封面管理
// /描述: 封面管理
// /编写者：zhangxiao
// /编写日期: 2017.10.20
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var actionUrl = DictUrl+"paycoveraction.csp"
	
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// 入库部门
		var PhaLoc=new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			width : 120,
			emptyText : '入库部门...',
			groupId:gGroupId
		});
		
		
		
		
		
		// 起始日期
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 100,
			value:new Date()		
		});

		// 截止日期
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '截止日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 100,
			value:new Date()
		});

		
		var CreateUser = new Ext.ux.ComboBox({
			id : 'CreateUser',
			fieldLabel : '制单人',
			store : UStore,
			params : {locId : 'PhaLoc'},
			filterName : 'name'
		});
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			id:"SearchBT",
			text : '查询',
			tooltip : '点击查询',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				MasterGrid.load();
			}
		});
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			id:'ClearBT',
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});
		// 删除按钮
		var DeleteBT = new Ext.Toolbar.Button({
			id:'DeleteBT',
			text : '删除',
			tooltip : '点击删除',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
					var selections=MasterGrid.getSelectionModel().getSelections();
					if(selections.length<1){
					Msg.info("warning", "请选择需要删除的付款封面!");
					return;
				}else{
					Ext.MessageBox.show({
						title : '提示',
						msg : '是否删除该付款封面?',
						buttons : Ext.MessageBox.YESNO,
						fn: function(b,t,o){
							if (b=='yes'){
								Delete();
							}
						},
						icon : Ext.MessageBox.QUESTION
					});
				  }
				}
		});
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
			id:'PrintBT',
			text : '库存分类打印',
			tooltip : '点击打印',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "请选择需要打印的入库单!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var CoverId=record.get("CoverId");
					PrintPayCover(CoverId);
				}
			}
		});

		
		// 打印按钮
		var PrintBT2 = new Ext.Toolbar.Button({
			id:'PrintBT2',
			text : '供应商明细打印',
			tooltip : '供应商明细打印',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "请选择需要打印的入库单!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var CoverId=record.get("CoverId");
					PrintPayCover2(CoverId);
				}
			}
		});
		
		/**
		 * 清空方法
		 */
		function clearData() {
			clearPanel(HisListTab);
			//HisListTab.getForm().setValues({StartDate:DefaultStDate(),EndDate:DefaultEdDate()});
			MasterGrid.removeAll();
			DetailGrid.removeAll();
			//DeleteBT.setDisabled(true);
			//PrintBT.setDisabled(true);

		}
		
		/**
		 * 审核方法
		 */
		function Delete() {
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择需要删除的付款封面!");
				return;
			}
			
			var CoverId = rowData.get("CoverId");
			var loadMask=ShowLoadMask(document.body,"删除中...");
			var url = DictUrl
					+ "paycoveraction.csp?actiontype=Delete&CoverId="+ CoverId;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					loadMask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success", "删除成功!");
						MasterGrid.reload();
						
					} else {
						var Ret=jsonData.info;
						var arr=Ret.split("^");
						Ret=arr[0];
						var IncDesc=arr[1];
						if(Ret==-1){
							Msg.info("error", "入库单修改失败!");
						}else if(Ret==-2){
							Msg.info("error", "退货单修改失败!");
						}else if(Ret==-3){
							Msg.info("error", "删除付款封面失败!");
						}else{
							Msg.info("error", "审核失败:"+Ret);
						}
					}
				},
				scope : this
			});
		}
		
		var MasterCm = [ {
					header : "rowid",
					dataIndex : 'CoverId',
					width : 60,
					hidden : true
				}, {
					header : "单号",
					dataIndex : 'CoverNo',
					width : 220,
					align : 'left',
					sortable : true
				}, {
					header : '科室',
					dataIndex : 'LocDesc',
					width : 200,
					align : 'left',
					sortable : true
				},  {
					header : "封面日期",
					dataIndex : 'CreateDate',
					width : 80,
					align : 'left'
				}, {
					header : "制单人",
					dataIndex : 'CreateUser',
					width : 60,
					align : 'left'
				}, {
					header : "月份",
					dataIndex : 'Month',
					width : 70,
					align : 'left'
				}, {
					header : "票据张数",
					dataIndex : 'VoucherCount',
					width : 80,
					align : 'left'
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 100,
					xtype:'numbercolumn'
				}, {
					header : "售价金额",
					dataIndex : 'SpAmt',
					xtype : 'numbercolumn',
					width : 100,
					align : 'right'
				}];
		
		var MasterGrid = new Ext.dhcstm.EditorGridPanel({
			region : 'center',
			title: '付款封面',
			id:'MasterGrid',
			childGrid : "DetailGrid",
			region : 'center',
			editable : false,
			contentColumns : MasterCm,
			smType : 'checkbox',
			singleSelect : false,
			checkOnly : true,
			smRowSelFn : rowSelFn,
			autoLoadStore : true,
			actionUrl : actionUrl,
			queryAction : "Query",
			paramsFn : GetMasterParams,
			idProperty : 'IngrId',
			showTBar : false
		});
		function Types(value){
            if (value=="G"){
	          return  '入库' ;
	       }else if (value=="R"){
		    return  '退货' ;
	     }
       }
		function rowSelFn(sm, rowIndex, r) {
			var rowData = sm.grid.getAt(rowIndex);
			var CoverId = rowData.get("CoverId");
			DetailGrid.load({params:{Parref:CoverId}});

		}
				
		function GetMasterParams(){
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			var StartDate = Ext.getCmp("StartDate").getValue();
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(PhaLoc==""){
				Msg.info("warning", "请选择入库部门!");
				return false;
			}
			if(StartDate==""){
				Msg.info("warning", "请选择开始日期!");
				return false;
			}else{
				StartDate=StartDate.format(ARG_DATEFORMAT).toString();
			}
			if(EndDate==""){
				Msg.info("warning", "请选择截止日期!");
				return false;
			}else{
				EndDate=EndDate.format(ARG_DATEFORMAT).toString();
			}
			var CreateUser = Ext.getCmp("CreateUser").getValue();
			var ListParam=StartDate+'^'+EndDate+'^'+PhaLoc+'^'+CreateUser
			
			return {"ParamStr":ListParam};
		}
	

		var DetailCm = [{
					header : "RecRetId",
					dataIndex : 'RecRetId',
					width : 80,
					hidden : true
				}, {
					header : "单号",
					dataIndex : 'gdNo',
					width : 200,
					align : 'left',
					//hidden : true,
					sortable : true
				}, {
					header : "类型",
					dataIndex : 'type',
					width : 70,
					align : 'left',
					renderer:Types,
					sortable : true
				}, {
					header : '供应商',
					dataIndex : 'vendorName',
					width : 260,
					align : 'left',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'gdRpAmt',
					width : 100,
					xtype : 'numbercolumn'
				}, {
					header : "售价金额",
					dataIndex : 'gdSpAmt',
					width : 100,
					xtype : 'numbercolumn'
				}];
		
		var DetailGrid = new Ext.dhcstm.EditorGridPanel({
			region: 'south',
			height : gGridHeight,
			split: true,
			minSize: 200,
			maxSize: 350,
			collapsible: true,
			title: '入库/退货单',
			id : 'DetailGrid',
			contentColumns : DetailCm,
			actionUrl : actionUrl,
			queryAction : "QueryCoverRec",
			selectFirst : false,
			idProperty : "RecRetId",
			//checkProperty : "IncId",
			paging : false,
			showTBar : false
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			labelWidth : 60,
			title:'付款封面管理',
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [SearchBT, '-', ClearBT, '-', DeleteBT, '-', PrintBT,'-',PrintBT2],
			items:[{
				xtype:'fieldset',
				title:'查询条件',
				layout: 'column',
				style:'padding:5px 0px 0px 0px;',
				defaults: {width: 220, border:false},
				items : [{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [PhaLoc]
					},{
						columnWidth: 0.2,
						xtype: 'fieldset',
						items: [StartDate]
					},{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [EndDate]
					},{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [CreateUser]
					}]
			}]
		});

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterGrid, DetailGrid],
			renderTo : 'mainPanel'
		});
	}
})