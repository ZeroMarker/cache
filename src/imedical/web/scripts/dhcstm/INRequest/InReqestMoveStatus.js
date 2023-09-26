// /名称: 请求单执行情况查询
// /描述: 请求单执行情况查询
// /编写者：zhangxiao
// /编写日期: 2014.02.28
Ext.onReady(function(){
	
	 var userId = session['LOGON.USERID'];
	 var gGroupId=session['LOGON.GROUPID'];
	 var gLocId=session['LOGON.CTLOCID'];
     var gIncId='';
     Ext.QuickTips.init();
     Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
     
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		anchor:'95%',
		fieldLabel:'请求部门',
		emptyText:'请求部门...',
		groupId:gGroupId,
		protype : INREQUEST_LOCTYPE,
		linkloc:gLocId,
		listeners:
		{
			'select':function(cb)
			{
				var requestLoc=cb.getValue();
				var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
				var mainArr=defprovLocs.split("^");
		        var defprovLoc=mainArr[0];
		        var defprovLocdesc=mainArr[1];
				addComboData(Ext.getCmp('SupplyLoc').getStore(),defprovLoc,defprovLocdesc);
				Ext.getCmp("SupplyLoc").setValue(defprovLoc);
				var provLoc=Ext.getCmp('SupplyLoc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}	
	});
	var SupplyLoc = new Ext.ux.ComboBox({
		id:'SupplyLoc',
		fieldLabel:'供给部门',
		anchor:'95%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'供给部门...',
		params:{LocId:'Loc'},
		filterName : 'FilterDesc',
		listeners:
		{
			'select':function(cb)
			{
				var provLoc=cb.getValue();
				var requestLoc=Ext.getCmp('Loc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}	
	});
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date().add(Date.DAY,-7)
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'95%',
		value:new Date()
	});
	// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%'
		}); 
		
	    //自动加载登陆科室的默认供给部门
	    Loc.fireEvent('select',Loc);
		// 物资名称
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
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
			gIncId = record.get("InciDr");
			Ext.getCmp("InciDesc").setValue(record.get("InciDesc"));
		}		
    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
	               text : '查询',
	               tooltip : '点击查询',
	               width : 70,
	               height : 30,
	               iconCls:'page_find',
	               handler : function() {
		        	  Query();
		           }
	           });
	 //查询函数
	 function Query(){
		 var Loc=Ext.getCmp("Loc").getValue();
		 if(Loc==null||Loc.length<=0){
			 Msg.info("warning","请选择请求部门!");
			 return;
			 }
		 var SupplyLoc=Ext.getCmp("SupplyLoc").getValue(); 
		 var startDate=Ext.getCmp("startDate").getValue();
		 var endDate=Ext.getCmp("endDate").getValue();
		 
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		 var StkGrpType=Ext.getCmp("StkGrpType").getValue();
		 if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
		 var ListParam=Loc+'^'+SupplyLoc+'^'+startDate+'^'+endDate+'^'+StkGrpType+'^'+gIncId	
		 var Page=GridPagingToolbar.pageSize;
		 MasterStore.setBaseParam('ParamStr',ListParam);
		 MasterStore.removeAll();
		 MasterStore.load({
			params:{start:0,limit:Page},
			callback:function(r,options,success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				}else if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		});
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
	//清空函数
	function clearData(){
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp("SupplyLoc").setValue("");
		Ext.getCmp("startDate").setValue(new Date().add(Date.DAY,-7))
		Ext.getCmp("endDate").setValue(new Date())
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
		}			
	// 访问路径
	var MasterUrl ='dhcstm.inrequestmovestatusaction.csp?actiontype=QueryReq';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus","comp"];
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
				width : 160,
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
				header : "请求时间",
				dataIndex : 'time',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "单据类别",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer: renderReqType,
				sortable : true
			},{
				header:'完成状态',
				dataIndex:'comp',
				align:'center',
				width:100,
				sortable:true,
				xtype : 'checkcolumn'
			}, {
				header : "制单人",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}]);
	
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
	var MasterGrid = new Ext.ux.GridPanel({
				    region: 'center',
				    title: '请求单',	
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					bbar:GridPagingToolbar
				});			
     
     // 添加表格单击行事件
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ReqId = MasterStore.getAt(rowIndex).get("req");
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',ReqId);
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize}});
	});
	
	// 请求明细
	// 访问路径
	var DetailUrl ='dhcstm.inrequestmovestatusaction.csp?actiontype=QueryReqDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["rowid","inci","code","desc","qty","uomdesc","spec","refuseflag","RD","RA","EA","PD","PA",
				"POD","POA","IMD","IMA","ID","IO","IIR","II","SpecDesc"];
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
	function Render(val,cellmeta){
			if(val=="Y"){
				cellmeta.css="colorY"
				return '<span style="color:red;">'+val+'</span>';
			}else{
				cellmeta.css="colorN"
				return '<span style="color:red;">'+val+'</span>';
			}
		}
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
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
			}, {
				header : '物资代码',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'desc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "具体规格",
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "单位",
				dataIndex : 'uomdesc',
				width : 60,
				align : 'center',
				sortable : true
			}, {
				header : "库存转移是否拒绝",
				dataIndex : 'refuseflag',
				width : 80,
				align : 'center',
				renderer:Render,
				//xtype : 'checkcolumn',
				useRenderExport : false,
				sortable : true
			}, {
				header : "请求单完成",
				dataIndex : 'RD',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "请求单请求方审核完成",
				dataIndex : 'RA',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "请求单供应方审核完成",
				dataIndex : 'EA',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "采购单完成",
				dataIndex : 'PD',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "采购单审核完成",
				dataIndex : 'PA',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "订单完成",
				dataIndex : 'POD',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "订单审核完成",
				dataIndex : 'POA',
				width : 80,
				align : 'center',
				//hidden : true,
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "入库制单完成",
				dataIndex : 'IMD',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "入库单审核完成",
				dataIndex : 'IMA',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "出库制单完成",
				dataIndex : 'ID',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "出库审核完成",
				dataIndex : 'IO',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "拒绝接收完成",
				dataIndex : 'IIR',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}, {
				header : "接收完成",
				dataIndex : 'II',
				width : 80,
				align : 'center',
				xtype : 'checkcolumn',
				sortable : true
			}
			]);
	var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true
	});

	var DetailGrid = new Ext.ux.GridPanel({
				id : 'DetailGrid',
				region: 'south',			               
			    title: '请求单明细',
			    height: gGridHeight,
				cm : DetailCm,
				store : DetailStore,
				bbar:GridDetailPagingToolbar,
				sm : new Ext.grid.RowSelectionModel({singleSelect:true})
			});
	
    var HisListTab = new Ext.ux.FormPanel({
			region: 'north',
			autoHeight : true,
			title:'请求单追踪查询',
			tbar : [SearchBT, '-', ClearBT],			
			items : [{
				xtype:'fieldset',
				title:'查询条件',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false},    // Default config options for child items
				items:[{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	items: [Loc,SupplyLoc]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            
	            	items: [startDate,endDate]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [StkGrpType,InciDesc]					
				}]
			}]			
		});

     // 页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [HisListTab,MasterGrid,DetailGrid]
				});

})

