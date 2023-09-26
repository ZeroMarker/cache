// /名称: 台账信息查询（库存查询界面调用）
// /描述: 台账信息查询（库存查询界面调用）
// /编写者：zhangdongmei
// /编写日期: 2012.08.10

function TransQuery(Incil,StkDate,IncInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
	
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo=replaceAll(IncInfo," ","　"); //用全角空格代替半角空格，防止label展示的时候自动将半角空格过滤掉
	
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
	
    var Inc=new Ext.form.Label({
    	text:IncInfo,
		align:'center',
		cls: 'classImportant'
    })
	
	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
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
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", "请在主界面选择某一条记录查看其台账信息！");
			return;
		}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var size=StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({params:{start:0,limit:size,incil:Incil,startdate:StartDate,enddate:EndDate}});
	}

	
	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// 指定列参数
	//业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
	//^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理人^摘要
	//^期末金额(进价)^期末金额(售价)^供应商^厂商^操作人	
	var fields = ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser"];
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
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '批号效期',
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'PurUom',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 65,
				align : 'right',
				
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 65,
				
				align : 'right'
			}, {
				header : "结余数量",
				dataIndex : 'EndQtyUom',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'TrQtyUom',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "处理号",
				dataIndex : 'TrNo',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : "处理信息",
				dataIndex : 'TrAdm',
				width : 65,
				align : 'right',
				sortable : true
			}, {
				header : "业务类型",
				dataIndex : 'TrMsg',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "结余金额(进价)",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "结余金额(售价)",
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',				
				sortable : true
			}, {
				header : "操作人",
				dataIndex : 'OperateUser',
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
				B[A.sort]='Rowid';
				B[A.dir]='desc';
				B['incil']=Incil;
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
			height : 150,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [searchBT],		
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
						},Inc]
			}]	
		});

	var window = new Ext.Window({
				title : '台账信息',
				width : 800,
				height : 600,
				layout:'border',
				items : [HisListTab, DetailInfoGrid]
			});
	window.show();
	
}