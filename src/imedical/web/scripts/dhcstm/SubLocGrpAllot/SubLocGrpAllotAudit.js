// /名称: 分配单审核
// /编写者：wangjiabin
// /编写日期: 2014.02.22
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 科室
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '科室...',
				groupId:session['LOGON.GROUPID'],
				stkGrpId : 'StkGrpType'
			});

		var uGroupList=new Ext.data.Store({		 
			url:"dhcstm.sublocusergroupaction.csp?actiontype=FilterLocGroupList",
			reader:new Ext.data.JsonReader({
				totalProperty:'results',
				root:"rows",
				idProperty:'RowId'
			},['RowId','Description']),
			baseParams:{'SubLoc':Ext.getCmp('PhaLoc').getValue()}
		});
		//专业组
		var UserGrp = new Ext.ux.ComboBox({
			fieldLabel : '专业组',
			id : 'UserGrp',
			name : 'UserGrp',
			store : uGroupList,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'PhaLoc'}
		});
			
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				anchor : '90%',
				value : new Date().add(Date.DAY, -30)
			});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				value : new Date()
			});
	//类组
	var StkGrpType = new Ext.ux.StkGrpComboBox({ 
				id : 'StkGrpType',
				name : 'StkGrpType',
				StkType:App_StkTypeCode,
				anchor : '90%',
				LocId:gLocId,
				UserId:gUserId
			});
	
	var AuditFlag = new Ext.form.Checkbox({
				hiddenLabel : true,
				boxLabel : '已审核',
				id : 'AuditFlag',
				name : 'AuditFlag',
				anchor : '90%',
				checked : false,
				listeners : {
					check : function(chk,checked){
						Ext.getCmp("DateFlag").setDisabled(!checked);
						if(!checked){
							Ext.getCmp("DateFlag").setValue(false);
						}
					}
				}
			});

	var DateFlag = new Ext.form.Checkbox({
				hiddenLabel : true,
				boxLabel : '按审核日期统计',
				id : 'DateFlag',
				anchor : '90%',
				disabled : true
			});
			
	// 检索按钮
	var SearchBT = new Ext.Toolbar.Button({
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
		var StartDate = Ext.getCmp("StartDate").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		var EndDate = Ext.getCmp("EndDate").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		var UserGrp = Ext.getCmp("UserGrp").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择科室!");
			return;
		}
		
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		var Comp="Y";
		var Audit=Ext.getCmp("AuditFlag").getValue()==true?"Y":"N";
		var StkGrpId=Ext.getCmp("StkGrpType").getValue();
		var DateFlag=Ext.getCmp("DateFlag").getValue()?"Y":"N";
		var ListParam=StartDate+'^'+EndDate+'^'+PhaLoc+'^'+UserGrp+'^'+Comp+'^'+Audit+"^"+StkGrpId+"^"+DateFlag;
		var Page=MasterToolbar.pageSize;
		MasterStore.setBaseParam('StrParam',ListParam)
		MasterStore.removeAll();
		DetailStore.removeAll();
		ScaleStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(!success){
     				Msg.info("error", "查询错误，请查看日志!");
     			}else{
     				if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
     				}
     			}
			}
		});
	}
	
	// 审核确认按钮
	var AuditBT = new Ext.Toolbar.Button({
				id:'AuditBT',
				text : '审核通过',
				tooltip : '点击审核通过',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					var SelRecords=MasterGrid.getSelectionModel().getSelections();
					if (SelRecords==null) {
						Msg.info("warning", "请选择需要审核的分配单!");
						return;
					}
					Ext.each(SelRecords,function(item){
						Audit(item);
					});
				}
			});
		
	function Audit(rowData) {
		var AuditFlag = rowData.get("AuditFlag");
		if (AuditFlag == "Y") {
			Msg.info("warning", "分配单已审核!");
			return;
		}
		var slga = rowData.get("slga");
		var loadMask=ShowLoadMask(document.body,"审核中...");
		
		var url = DictUrl
				+ "sublocgrpallotaction.csp?actiontype=Audit&slga="
				+ slga + "&userId=" + gUserId;
		Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					loadMask.hide();
					if(jsonData.success == 'true') {
						Msg.info("success", "审核通过成功!");
						MasterStore.removeAll();
						DetailStore.removeAll();
						ScaleStore.removeAll();
						MasterStore.reload();
					}else{
						var Ret=jsonData.info;
						if(Ret==-101){
							Msg.info("error", "分配单不存在!");
						}else if(Ret==-100){
							Msg.info("error", "加锁失败!");
						}else if(Ret==-102){
							Msg.info("error", "分配单尚未完成，不能审核!");
						}else if(Ret==-103){
							Msg.info("error", "分配权重不能全部为零!");
						}else{
							Msg.info("error", "审核失败:"+Ret);
						}
					}
				},
				scope : this
			});
		}
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : 'ClearBT',
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("UserGrp").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, -30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("AuditFlag").setValue(false);
		MasterStore.removeAll();
		DetailStore.removeAll();
	}
	
	var HisListTab = new Ext.ux.FormPanel({
		title : '分配单审核',
		id : "HisListTab",
		tbar : [SearchBT, '-', ClearBT, '-', AuditBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,columnWidth: 0.25,xtype:'fieldset'},
			items:[{
				items: [PhaLoc,UserGrp]
			},{
				items: [StartDate,EndDate]
			},{
				items: [StkGrpType]
			},{
				items: [AuditFlag,DateFlag]
			}]
		}]
	});
			
	// 访问路径
	var MasterUrl = DictUrl + 'sublocgrpallotaction.csp?actiontype=query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["slga","slgaNo","LocId","LocDesc","LUGId","LUGDesc","CreateDate","CreateTime","UserName","CompFlag",
				"DataStr","AuditFlag","AuditDate","AuditTime","AuditUserName","ScgDesc","AllotMon"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "slga",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					Sort:'',
					Dir:''
				}
			});
			
	var MasterSm = new Ext.grid.CheckboxSelectionModel({
		singleSelect : false,
		checkOnly : true,
		listeners:{
			'rowselect':function(sm,rowIndex,r){
				var slga = MasterStore.getAt(rowIndex).get("slga");
				var pagesize=DetailToolbar.pageSize;
				DetailStore.setBaseParam('slga',slga);
				DetailStore.removeAll();
				DetailStore.load({params:{start:0,limit:pagesize}});
				ScaleStore.removeAll();
				ScaleStore.load({params:{start:0,limit:999,sort:'',dir:'',slga:slga,ExcludeZero:1}});
			}
		}
	});
			
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm,MasterSm,
			{
				header : "slga",
				dataIndex : 'slga',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '分配单号',
				dataIndex : 'slgaNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : '科室',
				dataIndex : 'LocDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "专业组",
				dataIndex : 'LUGDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '分配单月份',
				dataIndex : 'AllotMon',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "制单日期",
				dataIndex : 'CreateDate',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "制单时间",
				dataIndex : 'CreateTime',
				width : 70,
				align : 'left',
				hidden : true,
				sortable : true
			}, {
				header : "完成标志",
				dataIndex : 'CompFlag',
				width : 60,
				align : 'center',
				hidden : true,
				sortable : true,
				renderer:function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}, {
				header : "审核标志",
				dataIndex : 'AuditFlag',
				width : 60,
				align : 'center',
				sortable : true,
				renderer:function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}, {
				header : "审核日期",
				dataIndex : 'AuditDate',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "审核时间",
				dataIndex : 'CreateTime',
				width : 70,
				align : 'left',
				hidden : true,
				sortable : false
			}, {
				header : "审核人",
				dataIndex : 'AuditUserName',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'ScgDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	
	var MasterToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
		id : 'MasterGrid',
		region: 'west',
		title: '分配单',
		width : 800,
		cm : MasterCm,
		sm : MasterSm,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:MasterToolbar
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
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([
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
	DetailCm.defaultSortable = true;
	
	var DetailToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var DetailGrid = new Ext.ux.GridPanel({
		id : 'DetailGrid',
		region: 'south',
		split: true,
		collapsible: true,
		title: '分配单明细',
		height : gGridHeight,
		cm : DetailCm,
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
		}),
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:DetailToolbar
	});

		var nmScale = new Ext.grid.RowNumberer();
		var ScaleCm = new Ext.grid.ColumnModel([
				nmScale, {
					header : "人员id",
					dataIndex : 'UserId',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "人员",
					dataIndex : 'UserName',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "分配权重",
					dataIndex : 'ScaleValue',
					width : 140,
					align : 'right',
					sortable : true
				},{
					header : "分配金额(进价)",
					dataIndex : 'ScaleRpAmt',
					width : 100,
					align : 'right',
					sortable : true
				},{
					header : "分配金额(售价)",
					dataIndex : 'ScaleSpAmt',
					width : 100,
					align : 'right',
					sortable : true
				}
		]);
		ScaleCm.defaultSortable = false;
		
		var ScaleStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : DictUrl + 'sublocgrpallotaction.csp?actiontype=queryScale',
			fields : ["UserId","UserName","ScaleValue","ScaleRpAmt","ScaleSpAmt"],
			root:'rows'
		});
		
		var ScaleGrid = new Ext.ux.GridPanel({
			id : 'ScaleGrid',
			region: 'center',
			title: '分配权重',
			cm : ScaleCm,
			store : ScaleStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			clicksToEdit : 1
		});			
			
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,MasterGrid,ScaleGrid,DetailGrid]
		});

})