// /名称: 占用数量信息查询
// /描述: 占用数量信息查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.17

function DirtyQtyQuery(Inclb,IncInfo,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
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
		if (Inclb == null || Inclb.length <= 0) {
			Msg.info("warning", "请在主界面选择某一条记录查看其占用信息！");
			return;
		}
		
		DirtyQtyStore.load({params:{Params:Inclb}});

	}

	function renderType(value){
		if(value=='T'){
			return '出库单';
		}else if(value=='R'){
			return '退货单';
		}
	}
		var nm = new Ext.grid.RowNumberer();
		var Cm = new Ext.grid.ColumnModel([nm,  {
					header : "Rowid",
					dataIndex : 'Rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '单号',
					dataIndex : 'No',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "数量",
					dataIndex : 'Qty',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'Uom',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '单据日期',
					dataIndex : 'Date',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "单据类型",
					dataIndex : 'Type',
					width : 80,
					align : 'left',
					renderer:renderType,
					sortable : true
				}]);
		Cm.defaultSortable = false;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=GetDirtyQtyInfo';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["Rowid","No", "Qty", "Uom", "Date","Type"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : fields
				});
		// 数据集
		var DirtyQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
	    var Inclbinfo=new Ext.form.Label({
	    	html:IncInfo,
	    	id:'Inclbinfo',
			align:'center',
			cls: 'classImportant',
			style:'font-weight:bold'
	    });
	    Ext.getCmp('Inclbinfo').setText(IncInfo,false)
		var DirtyQtyGrid = new Ext.grid.GridPanel({
					cm : Cm,
					store : DirtyQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					tbar:[Inclbinfo],
					listeners:{'rowdblclick':function(grid,rowIndex,event){
							var Type = DirtyQtyStore.getAt(rowIndex).get("Type");
							var Rowid = DirtyQtyStore.getAt(rowIndex).get("Rowid");
							if(Type=='T'){
								Ext.Msg.confirm('提示','清除后将删除对应出库单明细,确定要清除出库占用数吗？',
	      						function(btn){
	        						if(btn=='yes'){
		        						clearReserveQty(Rowid)						
	        						}
	         	 						
	      						},this);
							}
						
	     				}}
				});
	var window = new Ext.Window({
				title : '占用单据信息<双击行清除占用>',
				width : 600,
				height : 600,
				layout:'fit',
				items : [ DirtyQtyGrid ]
			});
	///清除出库占用数
	function clearReserveQty(InItIRowId){
						var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=DeleteDetail&RowId="
						+ InItIRowId ;
						var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
						Ext.Ajax.request({
									url : url,
									method : 'POST',
									waitMsg : '查询中...',
									success : function(result, request) {
										var jsonData = Ext.util.JSON
												.decode(result.responseText);
										if (jsonData.success == 'true') {
											Msg.info("success", "清除成功!");
										} else {
											var ret=jsonData.info
											if(ret=="-1"){
												Msg.info("error", "清除失败,出库单为完成状态!");
											}else if(ret=="-2"){
												Msg.info("error", "清除失败,出库单为完成状态!");
											}else if(ret=="-3"){
												Msg.info("error", "清除失败,出库单为出库审核状态!");
											}else if(ret=="-4"){
												Msg.info("error", "清除失败,出库单为入库审核状态!");
											}else{
												Msg.info("error", "清除失败,"+jsonData.info);
											}
										
										}
									},
									scope : this
								});	
						loadMask.hide();
						searchData();
	}
	window.on('close', function(panel) {
		Fn()
	});
	window.show();
	searchData();
}