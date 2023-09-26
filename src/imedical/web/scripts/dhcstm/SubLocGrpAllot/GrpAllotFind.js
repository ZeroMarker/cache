// /名称: 分配单查询界面
// /编写者：wangjiabin
// /编写日期: 2014.02.20
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
function GrpAllotFind(Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// 入库部门
	var PhaLocFind = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PhaLocFind',
				name : 'PhaLocFind',
				anchor : '90%',
				emptyText : '科室...',
				groupId:session['LOGON.GROUPID'],
				stkGrpId : 'FindStkGrpType',
				childCombo : 'UserGrpFind'
			});

		var FindGroupList=new Ext.data.Store({		 
			url:"dhcstm.sublocusergroupaction.csp?actiontype=FilterLocGroupList",
			reader:new Ext.data.JsonReader({
				totalProperty:'results',
				root:"rows",
				idProperty:'RowId'
			},['RowId','Description']),
			baseParams:{'SubLoc':Ext.getCmp('PhaLocFind').getValue()}
		});
		//专业组
		var UserGrpFind = new Ext.ux.ComboBox({
			fieldLabel : '专业组',
			id : 'UserGrpFind',
			name : 'UserGrpFind',
			store : FindGroupList,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'PhaLocFind'}
		});
			
	// 起始日期
	var StartDateFind = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDateFind',
				name : 'StartDateFind',
				anchor : '90%',
				
				anchor : '90%',
				value : new Date().add(Date.DAY, -30)
			});

	// 结束日期
	var EndDateFind = new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDateFind',
				name : 'EndDateFind',
				anchor : '90%',
				
				value : new Date()
			});
	//类组
	var FindStkGrpType = new Ext.ux.StkGrpComboBox({ 
				id : 'FindStkGrpType',
				name : 'FindStkGrpType',
				StkType:App_StkTypeCode,
				anchor : '90%',
				LocId:gLocId,
				UserId:gUserId
			});
	
	var FindForm = new Ext.ux.FormPanel({
				id : "FindForm",
				labelWidth: 60,
				items : [{
					layout: 'column',
					xtype:'fieldset',
					title:'查询条件',
					style:'padding:5px 0px 0px 0px',
					defaults: {border:false},
					items:[{
						columnWidth: 0.33,
						xtype: 'fieldset',
						defaultType: 'textfield',
						items: [PhaLocFind,UserGrpFind]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [StartDateFind,EndDateFind]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [FindStkGrpType]
					}]
				}]
			});

	// 检索按钮
	var FindSearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询分配单信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate = Ext.getCmp("StartDateFind").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		var EndDate = Ext.getCmp("EndDateFind").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		var PhaLoc = Ext.getCmp("PhaLocFind").getValue();
		var UserGrp = Ext.getCmp("UserGrpFind").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择入库部门!");
			return;
		}
		
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		var Comp="",Audit="N";
		var StkGrpId=Ext.getCmp("FindStkGrpType").getValue();
		var ListParam=StartDate+'^'+EndDate+'^'+PhaLoc+'^'+UserGrp+'^'+Comp+'^'+Audit+"^"+StkGrpId;
		var Page=FindMasterToolbar.pageSize;
		FindMasterStore.setBaseParam('StrParam',ListParam)
		FindMasterStore.removeAll();
		FindDetailGrid.store.removeAll();
		FindMasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(!success){
     				Msg.info("error", "查询错误，请查看日志!");
     			}else{
     				if(r.length>0){
	     				FindMasterGrid.getSelectionModel().selectFirstRow();
	     				FindMasterGrid.getView().focusRow(0);
     				}
     			}
			}
		});
	}

	// 选取按钮
	var FindreturnBT = new Ext.Toolbar.Button({
				text : '选取',
				tooltip : '点击选取',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

	// 清空按钮
	var FindClearBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		Ext.getCmp("PhaLocFind").setValue("");
		SetLogInDept(PhaLocFind.getStore(),"PhaLocFind");
		Ext.getCmp("UserGrpFind").setValue("");
		Ext.getCmp("StartDateFind").setValue(new Date().add(Date.DAY, -30));
		Ext.getCmp("EndDateFind").setValue(new Date());
		Ext.getCmp("FindStkGrpType").getStore().load();
		FindMasterGrid.store.removeAll();
		FindDetailGrid.store.removeAll();
	}

	// 3关闭按钮
	var FindCloseBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});

	// 访问路径
	var FindMasterUrl = DictUrl + 'sublocgrpallotaction.csp?actiontype=query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : FindMasterUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["slga","slgaNo","LocId","LocDesc","LUGId","LUGDesc","CreateDate","CreateTime","UserName","CompFlag",
				"DataStr","AuditFlag","AuditDate","AuditTime","AuditUserName","ScgDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// 数据集
	var FindMasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					Sort:'',
					Dir:''
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var FindMasterCm = new Ext.grid.ColumnModel([nm, {
				header : "slga",
				dataIndex : 'slga',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '分配单号',
				dataIndex : 'slgaNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '科室',
				dataIndex : 'LocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "专业组",
				dataIndex : 'LUGDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "制单日期",
				dataIndex : 'CreateDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "制单时间",
				dataIndex : 'CreateTime',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "完成标志",
				dataIndex : 'CompFlag',
				width : 80,
				align : 'center',
				sortable : true,
				renderer:function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}, {
				header : "类组",
				dataIndex : 'ScgDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	FindMasterCm.defaultSortable = true;
	
	var FindMasterToolbar = new Ext.PagingToolbar({
		store:FindMasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var FindMasterGrid = new Ext.grid.GridPanel({
				region: 'west',
				title: '分配单',
				collapsible: true,
				split: true,
				width: 225,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				id : 'FindMasterGrid',
				cm : FindMasterCm,
				sm : new Ext.grid.RowSelectionModel({
					singleSelect : true,
					listeners:{
						'rowselect':function(sm,rowIndex,r){
							var slga = FindMasterStore.getAt(rowIndex).get("slga");
							var pagesize=FindDetailToolbar.pageSize;
							GrDetailInfoStore.setBaseParam('slga',slga);
							GrDetailInfoStore.removeAll();
							GrDetailInfoStore.load({params:{start:0,limit:pagesize}});
						}
					}
				}),
				store : FindMasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:FindMasterToolbar
			});

	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'sublocgrpallotaction.csp?actiontype=queryItem';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["slgai","inci","inciCode","inciDesc","qty","uom","uomDesc","rpAmt","spAmt","Abbrev","Brand","Model","Spec"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "slgai",
				fields : fields
			});
	// 数据集
	var GrDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var FindDetailCm = new Ext.grid.ColumnModel([
				nm,{
					header : "库存项id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'inciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'inciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "简称",
					dataIndex : 'Abbrev',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '品牌',
					dataIndex : 'Brand',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "型号",
					dataIndex : 'Model',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					sortable : false
				}, {
					header : '售价金额',
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					sortable : false
				}
			]);
	FindDetailCm.defaultSortable = true;
	
	var FindDetailToolbar = new Ext.PagingToolbar({
		store:GrDetailInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	
	var FindDetailGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '分配单明细',
				cm : FindDetailCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:FindDetailToolbar
			});

	// 双击事件
	FindMasterGrid.on('rowdblclick', function() {
				returnData();
			});

	
	var window = new Ext.Window({
				modal : true,
				title : '分配单查询',
				width : gWinWidth,
				height : gWinHeight,
				layout : 'border',
				items : [FindForm, FindMasterGrid, FindDetailGrid],
				tbar : [FindSearchBT, '-', FindreturnBT, '-', FindClearBT, '-', FindCloseBT]
			});
	window.show();

	function returnData() {
		var selectRows = FindMasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning","请选择要返回的分配单信息!");
		} else {
			var slga = selectRows[0].get("slga");
			Fn(slga);
			window.close();
		}
	}
}