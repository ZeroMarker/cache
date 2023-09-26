// /名称: 专业组物资分配
// /描述: 专业组领到的物资根据权重将费用分配到医生个人
// /编写者：	wangjiabin
// /编写日期:2013-12-23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';	//用于展开明细时的参数
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
		
		var ToPhaLoc = new Ext.ux.ComboBox({
			id:'ToPhaLoc',
			fieldLabel:'接收科室',
			emptyText:'接收科室...',
			triggerAction : 'all',
			store : LeadLocStore,
			valueParams : {groupId : gGroupId},
			filterName : '',
			childCombo : ['UserGroup']
		});
		SetLogInDept(ToPhaLoc.getStore(),'ToPhaLoc');
		
		var lastMon = new Date().add(Date.MONTH,-1);
		var firstDay = lastMon.getFirstDateOfMonth();
		var lastDay = lastMon.getLastDateOfMonth();
		
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			
			value : firstDay
		});
		
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '截止日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			
			value : lastDay
		});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId
		});
		
		//专业组
		var UserGroup = new Ext.ux.ComboBox({
			fieldLabel : '专业组',
			id : 'UserGroup',
			name : 'UserGroup',
			store:UserGroupStore,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'ToPhaLoc'}
		});
		
		UserGroupStore.load({
			params:{start:0,limit:UserGroup.pageSize,SubLoc:Ext.getCmp('ToPhaLoc').getValue()},
			callback:function(r,options,success){
				if(success && r.length>0){
					UserGroup.setValue(r[0].get(UserGroup.valueField))
				}
			}
		});
		
		var lastMonDesc = lastMon.format(ARG_DATEFORMAT);
		var AllotMon = new Ext.form.TextField({
			fieldLabel : '分配单月份',
			id : 'AllotMon',
			name : 'AllotMon',
			anchor : '90%',
			value : lastMonDesc.slice(0,7),
			regex : /^\d{4}-(0[1-9])|(1[0|1|2])$/,
			regexText : '月份格式错误'
		});
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				searchData();
			}
		});

		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var LUG=Ext.getCmp("UserGroup").getValue();		//专业组
			if(LUG==""){
				Msg.info("warning","专业组不可为空!");
				return;
			}
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate==""){
				Msg.info("warning","起始日期不可为空!");
				Ext.getCmp("StartDate").focus();
				return;
			}else{
				StartDate = StartDate.format(ARG_DATEFORMAT).toString();
			}
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(EndDate==""){
				Msg.info("warning","截止日期不可为空!");
				Ext.getCmp("EndDate").focus();
				return;
			}else{
				EndDate = EndDate.format(ARG_DATEFORMAT).toString();
			}
			if(StartDate>EndDate){
				Msg.info("warning","起始日期大于截止日期!");
				return;
			}
			
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			
//			if (StkGrpRowId == null || StkGrpRowId.length <= 0) {
//				Msg.info("warning", "类组不能为空！");
//				Ext.getCmp("StkGrpType").focus();
//				return;
//			}
			
			var IncludeRet=1,userDr="",inciDr="",StkCatDr="";
			var ToPhaLoc = Ext.getCmp("ToPhaLoc").getValue();
			//sd^ed^包含退回标志(0:不包含,1:包含)^loc^userID^专业组^inci^scg^stkcat
			var strParam = StartDate+"^"+EndDate+"^"+IncludeRet+"^"+phaLoc+"^"+userDr
						+"^"+LUG+"^"+inciDr+"^"+StkGrpRowId+"^"+StkCatDr+"^"+ToPhaLoc;
			
			MasterStore.removeAll();
			DetailGrid.store.removeAll();
			AllotStore.removeAll();
			MasterStore.setBaseParam("strPar",strParam);
			var pageSize=MasterPagingBar.pageSize;
			MasterStore.load({
				params:{start:0,limit:pageSize},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","查询有误, 请查看日志!");
					}else if(r.length>0){
						gStrParam = StartDate+"^"+EndDate+"^"+phaLoc+"^"+LUG+"^"+""
							+"^"+StkGrpRowId+"^^"+IncludeRet+"^"+ToPhaLoc;
     					MasterGrid.getSelectionModel().selectFirstRow();
     					MasterGrid.getView().focusRow(0);
					}
				}
			});
			ScaleStore.removeAll();
			ScaleStore.load({
				params:{UserGrpId:LUG}
			});
		}
				
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			iconCls : 'page_clearscreen',
			width : 70,
			height : 30,
			handler : function() {
				clearData();
			}
		});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),"PhaLoc");
			SetLogInDept(ToPhaLoc.getStore(),"ToPhaLoc");
			Ext.getCmp("UserGroup").setValue("");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp("EndDate").setValue(new Date());
			
			MasterStore.removeAll();
			Common_ClearPaging(MasterPagingBar);
			DetailStore.removeAll();
			AllotStore.removeAll();
			ScaleStore.removeAll();
		}

		// 保存按钮
		var SaveBT = new Ext.Toolbar.Button({
			text : '保存',
			tooltip : '点击保存',
			id : 'SaveBT',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				if(ScaleGrid.activeEditor != null){
					ScaleGrid.activeEditor.completeEdit();
				}
				saveData();
			}
		});
		
		function saveData(){
			var locId = Ext.getCmp('PhaLoc').getValue();
			var grpId = Ext.getCmp('UserGroup').getValue();
			var comp = 'N';
			var count = AllotStore.getCount();
			var StkGrpType = Ext.getCmp('StkGrpType').getValue();
			var AllotMon = Ext.getCmp("AllotMon").getValue();
			AllotMon = AllotMon+"-"+"01";
			var MainData = locId+"^"+grpId+"^"+gUserId+"^"+comp+"^"+StkGrpType+"^"+AllotMon;
			var listIndsiId = "";
			for(var k=0;k<count;k++){
				if(listIndsiId==""){
					listIndsiId = AllotStore.getAt(k).get('IndsiStr');
				}else{
					listIndsiId = listIndsiId +"^"+ AllotStore.getAt(k).get('IndsiStr');
				}
			}
			var ScaleCount = ScaleStore.getCount();
			var ListScaleStr="";
			for(var n=0;n<ScaleCount;n++){
				var UserScale = "^"+ScaleStore.getAt(n).get('UserId')+"^"+ScaleStore.getAt(n).get('ScaleValue');
				if(ListScaleStr==""){
					ListScaleStr = UserScale;
				}else{
					ListScaleStr = ListScaleStr +RowDelim+ UserScale;
				}
			}
			if(listIndsiId==""){
				Msg.info("warning","请选择需要生成分配单的数据!");
				return;
			}
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
				url: DictUrl+"sublocgrpallotaction.csp?actiontype=CreateAllotByDsi",
				method:'POST',
				waitMsg : '处理中...',
				params:{MainData:MainData,ListDsiId:listIndsiId,ListScaleStr:ListScaleStr},
				success:function(result,request) {
					loadMask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if(jsonData.success=='true'){
						Msg.info("success","保存成功!");
						var AllotId=jsonData.info;
						window.location.href='dhcstm.sublocgrpallot.csp?gAllotId='+AllotId;
					}else{
						Msg.info("error","保存失败"+jsonData.info);
					}
				}
			});
		}
		
		var nm = new Ext.grid.RowNumberer();
		var MasterSm = new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect : function(sm, rowIndex, r) {
					var inci = MasterStore.getAt(rowIndex).get("inci");
					var tmpArr = gStrParam.split("^");
					tmpArr[6] = inci;
					gStrParam = tmpArr.join("^");
					DetailStore.setBaseParam('strPar',gStrParam);
					DetailStore.load({
						params:{start:0,limit:999},
						callback:function(r,options,success){
							if(!success){
								Msg.info("error","明细查询有误, 请查看日志!");
							}else{
								RefreshDetailSm(inci);
							}
						}
					});
				}
			}
		});
		
		function RefreshDetailSm(inci){
			var allotIndex = AllotStore.findExact('inci',inci);
			if(allotIndex>=0){
				var IndsiStr = AllotStore.getAt(allotIndex).get('IndsiStr');
				var IndsiArr = IndsiStr.split("^");
				for(var i=0;i<IndsiArr.length;i++){
					var indsiDetailIndex = DetailStore.findExact('pointer',IndsiArr[i]);
					DetailSm.selectRow(indsiDetailIndex,true);
				}
			}
		}
		
		var MasterCm = new Ext.grid.ColumnModel([nm,{
					header : "库存项id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'InciCode',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'InciDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "简称",
					dataIndex : 'Abbrev',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : '品牌',
					dataIndex : 'Brand',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "型号",
					dataIndex : 'Model',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'RpAmt',
					width : 60,
					align : 'right',
					sortable : false
				}, {
					header : '发放数量',
					dataIndex : 'QtyUom',
					width : 80,
					align : 'left',
					sortable : false
				}
		]);
		MasterCm.defaultSortable = true;

		// 访问路径
		var MasterUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=INDispStat';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["inci","InciCode","InciDesc","Abbrev","Spec","Model","Brand","QtyUom","RpAmt"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inci",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						ExcludeAlloted:1	//过滤已经制作分配单的数据
					}
				});

		var MasterPagingBar = new Ext.PagingToolbar({
					store : MasterStore,
					pageSize : PageSize,
					displayInfo : true
				});
		
		var MasterGrid = new Ext.ux.GridPanel({
					id:'MasterGrid',
					region:'west',
					title: '发放数据统计',
					width:700,
					cm : MasterCm,
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : MasterSm,
					loadMask : true,
					bbar : [MasterPagingBar]
				});
		
		var	DetailSm = new Ext.grid.CheckboxSelectionModel({
			listeners:{
				rowselect : function(sm,rowIndex,record){
					var inci = record.get('inci');
					var allotIndex = AllotStore.findExact('inci',inci);
					//明细Id
					var indsi = record.get('pointer');
					if(allotIndex>=0){
						var AllotRecord = AllotStore.getAt(allotIndex);
						var IndsiArr = AllotRecord.get('IndsiStr').split("^");
						if(IndsiArr.indexOf(indsi)==-1){
							IndsiArr.push(indsi);
							var IndsiStr = IndsiArr.join("^");
							AllotRecord.set('IndsiStr',IndsiStr);
							var AllotRpAmt = parseFloat(AllotRecord.get('AllotRpAmt'))+parseFloat(record.get('rpAmt'));
							AllotRecord.set('AllotRpAmt',AllotRpAmt);
						}
					}else{
						addNewAllotRow();
						var rowData = AllotStore.getAt(AllotStore.getCount()-1);
						rowData.set('inci',record.get('inci'));
						rowData.set('InciCode',record.get('inciCode'));
						rowData.set('InciDesc',record.get('inciDesc'));
						rowData.set('AllotRpAmt',parseFloat(record.get('rpAmt')));
						rowData.set('IndsiStr',indsi);
					}
				},
				rowdeselect : function(sm,rowIndex,record){
					var inci = record.get('inci');
					var allotIndex = AllotStore.findExact('inci',inci);
					//明细Id
					var indsi = record.get('pointer');
					var AllotRecord = AllotStore.getAt(allotIndex);
					var IndsiArr = AllotRecord.get('IndsiStr').split("^");
					var indsiArrIndex = IndsiArr.indexOf(indsi);
					IndsiArr.splice(indsiArrIndex,1);
					if(IndsiArr.length==0){
						AllotStore.remove(AllotRecord);
					}else{
						IndsiStr = IndsiArr.join("^");
						AllotRecord.set('IndsiStr',IndsiStr);
						var AllotRpAmt = parseFloat(AllotRecord.get('AllotRpAmt'))-parseFloat(record.get('rpAmt'));
						AllotRecord.set('AllotRpAmt',AllotRpAmt);
					}
				}
			}
		});
		
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([
				nm,DetailSm, {
					header : "indsi",
					dataIndex : 'pointer',
					width : 60,
					align : 'left',
					hidden : true,
					sortable : true
				},{
					header : "业务类型",
					dataIndex : 'trType',
					width : 60,
					align : 'left',
					hidden : true,
					sortable : true,
					renderer:function(v){
						if(v=="C"){
							return "发放";
						}else if(v=="L"){
							return "退回";
						}else{
							return v;
						}
					}
				},{
					header : "库存项id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "批号~效期",
					dataIndex : 'batInfo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'manf',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "数量",
					dataIndex : 'qty',
					width : 50,
					align : 'right',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'uomDesc',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "进价(包装单位)",
					dataIndex : 'rp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'rpAmt',
					width : 80,
					align : 'right',
					sortable : true
				},{
					header : "发放单号",
					dataIndex : 'indsNo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "发放日期",
					dataIndex : 'dispDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "发放时间",
					dataIndex : 'dispTime',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "请领单号",
					dataIndex : 'dsrqNo',
					width : 140,
					align : 'left',
					sortable : true
				}
		]);
		DetailCm.defaultSortable = false;
		
		// 访问路径
		var DetailUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=LocUserMatStat';
		// 通过AJAX方式调用后台数据
		var DetailProxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fieldsDetail = ["pointer","trType","inci","inciCode","inciDesc","spec","manf","batInfo",
				{name:"qty",convert:Negative},
				"uomDesc","rp",
				{name:"rpAmt",convert:Negative},
				"dispDate","dispTime","receiver","indsNo","dsrqNo","dsrqDate"
			];
		// 支持分页显示的读取方式
		var DetailReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsDetail
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : DetailProxy,
					reader : DetailReader,
					baseParams:{
						ExcludeAlloted:1	//过滤已经制作分配单的数据
					}
				});
				
		var DetailGrid = new Ext.ux.GridPanel({
					id : 'DetailGrid',
					region:'center',
					title:'发放明细',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : DetailSm,
					loadMask : true				
				});
		
		function Negative(v,rec){
			return -parseFloat(v);
		}
		
		
		var nmAllot = new Ext.grid.RowNumberer();
		var AllotCm = new Ext.grid.ColumnModel([nmAllot, {
					header : "库存项id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "物资代码",
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'InciDesc',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "分配金额(进价)",
					dataIndex : 'AllotRpAmt',
					width : 90,
					align : 'right',
					sortable : true
				},{
					header : "分配金额(售价)",
					dataIndex : 'AllotSpAmt',
					width : 90,
					align : 'right',
					hidden : true,
					sortable : true
				}, {
					header : "发放明细rowid",
					dataIndex : 'IndsiStr',
					width : 90,
					align : 'left',
					sortable : true,
					hidden : true
				}
		]);
		AllotCm.defaultSortable = false;
		
		var AllotStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : '',
			fields : ["inci","AllotValue","AllotRpAmt","IndsiStr"]
		});

		var AllotGrid = new Ext.ux.GridPanel({
			id : 'AllotGrid',
			region:'west',
			width:700,
			title:'专业组公支明细',
			cm : AllotCm,
			store : AllotStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true				
		});

		function addNewAllotRow() {
			var AllotRecord = Ext.data.Record.create([
				{
					name : 'inci',
					type : 'int'
				},{
					name : 'InciCode',
					type : 'string'
				}, {
					name : 'InciDesc',
					type : 'string'
				}, {
					name : 'AllotRpAmt',
					type : 'double'
				}, {
					name : 'IndsiStr',
					type : 'string'
				}
			]);
							
			var AllotRecord = new AllotRecord({
				inci:'',
				InciCode:'',
				InciDesc:'',
				UomId:'',
				Uom:'',
				AllotRpAmt:'',
				IndsiStr:''
			});
				
			AllotStore.add(AllotRecord);
			AllotGrid.getSelectionModel().selectRow(AllotStore.getCount()-1,true); 
		}
		
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
					sortable : true,
					editable : true,
					editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false
					})
				}
		]);
		ScaleCm.defaultSortable = false;
		
		var ScaleStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : DictUrl + 'sublocgrpallotaction.csp?actiontype=GetGroupUser',
			fields : ["UserId","UserName","ScaleValue","ScaleRpAmt","ScaleSpAmt"],
			root:'rows'
		});
		
		var ScaleGrid = new Ext.ux.EditorGridPanel({
			id : 'ScaleGrid',
			region:'center',
			title:'专业组公支权重',
			cm : ScaleCm,
			store : ScaleStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			clicksToEdit : 1
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			id : 'HisListTab',
			title: '专业组发放数据分配',
			tbar : [SearchBT, '-', ClearBT, '-', SaveBT],
			items:[{
				xtype : 'fieldset',
				title : '分配单信息',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults:{border:false,columnWidth:0.25,xtype:'fieldset'},
				items:[{
						items:[PhaLoc,ToPhaLoc]
					},{
						items:[StkGrpType,UserGroup]
					},{
						items:[StartDate,EndDate]
					},{
						items:[AllotMon]
					}]
			}]
		});
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,MasterGrid,DetailGrid,{
					region : 'south',
					height : gGridHeight,
					layout : 'border',
					items:[AllotGrid,ScaleGrid]
				}
				
			],
			renderTo : 'mainPanel'
		});
	}
})