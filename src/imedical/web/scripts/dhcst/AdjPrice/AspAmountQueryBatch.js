// /名称:调价损益批次查询
// /描述:调价损益批次查询
// /编写者：zhangdongmei
// /编写日期: 2013.01.08

Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	var InciDr = new Ext.form.TextField({
				fieldLabel : '药品RowId',
				id : 'InciDr',
				name : 'InciDr',
				anchor:'90%',
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
							var item=field.getValue();
							if (item != null && item.length > 0) {
								GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",getDrugList);
							}
						}
					}
				}
			});

	// 调价单号
	var AspBatNo = new Ext.form.TextField({
				fieldLabel : '调价单号',
				id : 'AspBatNo',
				name : 'AspBatNo',
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
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>开始时间</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});	

	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>截止时间</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});
	// 科室
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'Loc',
		name : 'Loc',
		anchor:'90%',
		width : 120,
		emptyText : '科室...',
		groupId:gGroupId,
		defaultLoc:{}
	});
	SetLogInDept(Ext.getCmp("Loc").getStore(),"Loc");
	ReasonForAdjSpStore.load();
	var AspReason=new Ext.form.ComboBox({
		id:'AspReason',
		fieldLabel:'调价原因',
		name:'AspReason',
		width:100,
		anchor:'90%',
		emptyText:'调价原因',
		store:ReasonForAdjSpStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	
	var OptType=new Ext.form.RadioGroup({
		id:'OptType',
		columns:1,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'全部',name:'type',inputValue:0,checked:true},
			{boxLabel:'差额为正',name:'type',inputValue:1},
			{boxLabel:'差额为负',name:'type',inputValue:-1}
		]
	});
	
	// 查询
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					getAspBatAmount();
				}
			});

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清屏',
				tooltip : '点击清屏',
				width : 70,
				height : 30,
				iconCls : 'page_refresh',
				handler : function() {
					clearData();
				}
			});
	/**
	 * 清空方法
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("Loc").getStore(),'Loc');
		Ext.getCmp("InciDr").setValue("");
		Ext.getCmp("AspBatNo").setValue("");
		Ext.getCmp("ItmDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1).format(App_StkDateFormat));
		Ext.getCmp("EndDate").setValue(new Date().format(App_StkDateFormat));
		Ext.getCmp("OptType").setValue(0);
		Ext.getCmp("StartTime").setValue("");
		Ext.getCmp("EndTime").setValue("");
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	function priceRender(val){
		var val = Ext.util.Format.number(val,'0.00');
		if(val<0){
			return '<span style="color:red;">'+val+'</span>';
		}else if(val>0){
			return '<span style="color:green;">'+val+'</span>';
		}
		return val;
	}
	
	// 调价明细
	// 访问路径
	var DetailUrl =DictUrl+ 'inadjpriceactionbatch.csp?actiontype=QueryAspBatchAmount';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["AspaId", "IncCode","IncDesc", "Spec", "AspUom","StkLbQty", 
			 "PriorSp","ResultSp", "DiffSp", "PriorRp",
			"ResultRp", "DiffRp", "SpLbAmt", "RpLbAmt","AspReason","ExecuteDate",
			"AspUser","LocDesc","BatExp","Incib"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "AspaId",
		fields : fields
	});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					StartDate:'',
					EndDate:'',
					Others:'',
					StartTime:'',
					EndTime:''
				},
				remoteSort:true
			});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "AspaId",
				dataIndex : 'AspaId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {   
			       header : "Incib",
				dataIndex : 'Incib',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品代码",
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "药品名称",
				dataIndex : 'IncDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
			       header : "批次/效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			},{
				header : "规格",
				dataIndex : 'Spec',
				width : 80,
				align : 'left'
			}, {
				header : '调价单位',
				dataIndex : 'AspUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "库存量",
				dataIndex : 'StkLbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "调前售价",
				dataIndex : 'PriorSp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "调后售价",
				dataIndex : 'ResultSp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "差价(售价)",
				dataIndex : 'DiffSp',
				width : 80,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "调前进价",
				dataIndex : 'PriorRp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header:"调后进价",
				dataIndex:"ResultRp",
				width : 90,
				renderer:priceRender,
				align : 'right'
			},{
				header : "差价(进价)",
				dataIndex : 'DiffRp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "损益金额(售价)",
				dataIndex : 'SpLbAmt',
				width : 80,
				align : 'right',
				renderer:priceRender,
				sortable : true				
			}, {
				header : "损益金额(进价)",
				dataIndex : 'RpLbAmt',
				width : 80,
				align : 'right',
				renderer:priceRender,
				sortable : true
			}, {
				header : "科室",
				dataIndex : 'LocDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "调价原因",
				dataIndex : 'AspReason',
				width : 80,
				align : 'left'
			}, {
				header : "生效日期",
				dataIndex : 'ExecuteDate',
				width : 100,
				align : 'left'
			}, {
				header : "调价人",
				dataIndex : 'AspUser',
				width : 80,
				align : 'left'
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

	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '损益明细(批次)',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm :new Ext.grid.RowSelectionModel({singleSelect:true}),
				bbar:DetailPageToolBar
			});
			
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
	
	// 显示调价单数据
	function getAspBatAmount() {
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		var InciRowid="";
		if(InciDesc!=null & InciDesc!="" & InciDesc.length >0){
			InciRowid=Ext.getCmp("InciDr").getValue();
		}			
		var AspBatNo=Ext.getCmp("AspBatNo").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
		
		var LocId=Ext.getCmp("Loc").getValue();
		var AspReasonId=Ext.getCmp("AspReason").getValue();
		var optType=Ext.getCmp("OptType").getValue().getGroupValue();
		var Others=LocId+"^"+AspBatNo+"^"+AspReasonId+"^"+optType+"^"+InciRowid;
		if (StartDate == null || StartDate.length <= 0 ) {
			Msg.info("warning", "开始日期不能为空！");
			Ext.getCmp("StartDate").focus();
			return;
		}
		else{
			StartDate=StartDate.format(App_StkDateFormat);
		}
		if (EndDate == null || EndDate.length <= 0 ) {
			Msg.info("warning", "截止日期不能为空！");
			Ext.getCmp("EndDate").focus();
			return;
		}
		else{
			EndDate=EndDate.format(App_StkDateFormat);
		}
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		DetailStore.setBaseParam("StartTime",startTime);
		DetailStore.setBaseParam("EndTime",endTime);
		var pagesize=DetailPageToolBar.pageSize;
		DetailStore.removeAll();
		DetailStore.load({params:{start:0,limit:pagesize}});
	}
	
	var MainForm = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		title:'调价损益查询(批次)',
		tbar : [SearchBT, '-', ClearBT],
		items : [{					
				xtype : 'fieldset',
				title : '查询条件',
				autoHeight : true,
				style:'padding:5px 0px 0px 0px',
				defaults:{border:false},
				layout : 'column',									
				items : [{
					columnWidth : .2,
					xtype : 'fieldset',
					items : [StartDate,StartTime]
				},{
					columnWidth : .2,
					xtype : 'fieldset',
					items : [EndDate,EndTime]
				},{
					columnWidth : .2,
					xtype : 'fieldset',
					defaults:{width:120},
					items : [Loc,AspBatNo]
				},{
					columnWidth : .25,
					xtype : 'fieldset',
					defaults:{width:150},
					items : [ItmDesc]
				},{
					columnWidth : .15,
					xtype : 'fieldset',
					items : [OptType]					
				}]								
		}]
				
	});

	// 页签
	var panel = new Ext.Panel({
				activeTab : 0,
				height : 190,
				region : 'north',
				layout:'fit',
				items : [MainForm]
			});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [panel, DetailGrid]
			});			
		
});

