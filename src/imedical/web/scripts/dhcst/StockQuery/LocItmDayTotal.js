// /名称: 全院库存查询（库存查询界面调用）
// /描述: 全院库存查询（库存查询界面调用）
// /编写者：hulihua
// /编写日期: 2013.12.31

function DayTotalQuery(Incil,IncInfo) {
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
	
    var Inc=new Ext.form.Label({
    	text:IncInfo,
		align:'center',
		cls: 'classImportant'
    })
			
	/**
	 * 查询方法
	 */
	function searchData() {
		// 必选条件
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", $g("请在主界面选择某一条记录查看其全院库存信息！"));
			return;
		}
		
		var size=StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({params:{start:0,limit:size,incil:Incil}});
	}

	
	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmDayTotalDetail&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// 指定列参数
	//科室^单位^数量(基本单位)
	var fields = ["TrId","loc", "pctuom", "qty"];
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
			},{
				header : $g('科室'),
				dataIndex : 'loc',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : $g("单位"),
				dataIndex : 'pctuom',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("数量"),
				dataIndex : 'qty',
				width : 120,
				align : 'right',
				sortable : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : DetailInfoStore,
			pageSize : PageSize,
			displayInfo : true,
			displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
			emptyMsg : "No results to display",
			prevText : $g("上一页"),
			nextText : $g("下一页"),
			refreshText : $g("刷新"),
			lastText : $g("最后页"),
			firstText : $g("第一页"),
			beforePageText : $g("当前页"),
			afterPageText : $g("共{0}页"),
			emptyMsg :$g( "没有数据"),
			doLoad:function(C){
				var B={},
				A=this.getParams();
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B[A.sort]='Rowid';
				B[A.dir]='desc';
				B['incil']=Incil;
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
			height : 50,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			layout : 'fit', 
		    items:[Inc] 
		});

	var window = new Ext.Window({
				title : $g('全院科室库存'),
				width : 550,
				height : 500,
				layout:'border',
				items : [ HisListTab, DetailInfoGrid]
			});
	window.show();
	
	searchData();
	
}