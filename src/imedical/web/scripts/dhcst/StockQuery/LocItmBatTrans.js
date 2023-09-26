// /名称: 批次追踪信息查询（库存查询界面调用）
// /描述: 批次追踪信息查询（库存查询界面调用）
// /编写者：hulihua
// /编写日期: 2016.01.10

function BatTransQuery(Inclb,StkDate,InclbInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
	var HospId=session['LOGON.HOSPID'];
	
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	InclbInfo=replaceAll(InclbInfo," ","　"); //用全角空格代替半角空格，防止label展示的时候自动将半角空格过滤掉
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 200,
			value : new Date()
	});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
			fieldLabel : '结束日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 200,
			value : StkDate
	});
	
    var Inclbinfo=new Ext.form.Label({
    	text:'',
    	id:'Inclbinfo',
		align:'center',
		cls: 'classImportant'
    })
    Ext.getCmp('Inclbinfo').setText(InclbInfo,false)
    // 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '另存',
				tooltip : '另存为Excel',
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(DetailInfoGrid);
				}
			});
	
	// 检索按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询药品台账',
				iconCls : 'page_find',
				handler : function() {
					searchData();
				}
			});
			
	/**
	 * 查询方法
	 */
	function searchData() {
		// 必选条件
		if (Inclb == null || Inclb.length <= 0) {
			Msg.info("warning", "请在批次界面选择某一批次记录查看其追踪信息！");
			return;
		}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var size=StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({params:{start:0,limit:size,inclb:Inclb,startdate:StartDate,enddate:EndDate,hospId:HospId}});
	}

	
	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmBatTransDetail&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// 指定列参数
	//业务ID^业务日期^摘要^增减数量^结余数量^进价(库存单位)^售价(库存单位)^增减金额(进价)^增减金额(售价)
	//处理号^处理人^操作人^备注
	var fields = ["TrId","TrDate","TrMsg","TrQtyUom","EndQtyUom","PurUomRp","PurUomSp","TrRpAmt", "TrSpAmt"
			,"TrNo","TrAdm","TrMark","TrQtyB","OperateUser","EndRpAmt","EndSpAmt"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "TrId",
				fields : fields
			});
	// 数据集
	var DetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "日期",
				dataIndex : 'TrDate',
				width : 130,
				align : 'left',
				sortable : true
			}, {
				header : "摘要",
				dataIndex : 'TrMsg',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'TrQtyUom',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "结余数量",
				dataIndex : 'EndQtyUom',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'PurUomRp',
				width : 80,
				
				align : 'right'
			}, {
				header : "售价",
				dataIndex : 'PurUomSp',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'TrRpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'TrSpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "结余进价金额",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "结余售价金额",
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "处理号",
				dataIndex : 'TrNo',
				width : 180,
				align : 'right',
				sortable : true
			}, {
				header : "处理相关部门(人)",
				dataIndex : 'TrAdm',
				width : 120,
				align : 'right',
				sortable : true
			},{
				header : "操作人",
				dataIndex : 'OperateUser',
				width : 65,
				align : 'left',				
				sortable : true
			},{
				header : "备注",
				dataIndex : 'TrMark',
				width : 65,
				align : 'left',				
				sortable : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : DetailInfoStore,
			pageSize : PageSize,
			displayInfo : true,
			displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
			emptyMsg : "No results to display",
			prevText : "上一页",
			nextText : "下一页",
			refreshText : "刷新",
			lastText : "最后页",
			firstText : "第一页",
			beforePageText : "当前页",
			afterPageText : "共{0}页",
			emptyMsg : "没有数据",
			doLoad:function(C){
				var B={},
				A=this.getParams();
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B[A.sort]='TrId';
				B[A.dir]='desc';
				B['inclb']=Inclb;
				B['startdate']=Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();
				B['enddate']=Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}
		});
	var DetailInfoGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				region:'center',
				cm : DetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : DetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar : StatuTabPagingToolbar
			});
	var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			height : 160,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT,'-',SaveAsBT],		
			items : [{
				autoHeight : true,
					items : [{
						xtype : 'fieldset',
						title : '查询条件',
						autoHeight : true,
						items : [{
							layout : 'column',
							items : [
								{columnWidth:.4,layout:'form',items:[StartDate]},
								{columnWidth:.4,layout:'form',items:[EndDate]}
							]}]
						},Inclbinfo]
			}]	
		});

	var window = new Ext.Window({
				title : '批次信息追踪',
				width : 800,
				height : 600,
				layout:'border',
				items : [HisListTab, DetailInfoGrid]
			});
	window.show();
	
}