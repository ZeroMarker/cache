// /名称: 批次信息查询
// /描述: 批次信息查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.08

function BatchQuery(Incil,StkDate,IncInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
	
		/**
	* 全部替换方法
	*
	* @param {}
	* str
	* @param {}
	* rgExp
	* @param {}
	* replaceStr
	*/
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo=replaceAll(IncInfo," ","　"); //用全角空格代替半角空格，防止label展示的时候自动将半角空格过滤掉

	/**
	 * 查询方法
	 */
	function searchData() {
		// 必选条件
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", "请在主界面选择某一条记录查看其批次信息！");
			return;
		}
		
		gStrParam=Incil+"^"+StkDate;
		
		var pageSize=StatuTabPagingToolbar.pageSize;
		BatchStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

	}

	
		var nm = new Ext.grid.RowNumberer();
		var BatchCm = new Ext.grid.ColumnModel([nm,  {
					header : "Inclb",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '批号',
					dataIndex : 'BatNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "效期",
					dataIndex : 'ExpDate',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "批次库存",
					dataIndex : 'QtyUom',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '进价(基本单位)',
					dataIndex : 'BRp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "进价(包装单位)",
					dataIndex : 'PRp',
					width : 80,
					align : 'left',
					
					sortable : true
				}]);
		BatchCm.defaultSortable = false;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=Batch&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["BatNo", "ExpDate", "QtyUom", "BRp","PRp", "Inclb"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fields
				});
		// 数据集
		var BatchStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : BatchStore,
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
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var BatchGrid = new Ext.grid.GridPanel({
					cm : BatchCm,
					store : BatchStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					tbar:[{
							xtype:'label',
							text:IncInfo,
							align:'center',
							cls: 'classDiv2',
							style:{
								//font:'padding-left:12px'
							}
						}
					]
				});
	var window = new Ext.Window({
				title : '批次信息',
				width : 600,
				height : 600,
				layout:'fit',
				items : [ BatchGrid ]
			});
	window.show();
	//document.write( ' <font   id= "AAA "   style= "font-family:宋体;font-size:8pt; "> '+IncInfo+'</font> ');
	searchData();
}