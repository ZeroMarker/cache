var acctbookid;

var CheckTypeUrl = '../csp/herp.acct.acctaidcheckexe.csp';
//模糊查询
var strField = new Ext.form.TextField({
		id: 'StrField',
		name: 'StrField',
		// fieldLabel: '核算项目名称：',
		emptyMsg: '模糊查询……',
		minWidth: 100,
		triggerAction: 'all'
	});
//查询按钮
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询', //悬停提示
		iconCls: 'find',
		handler: function () {
			// 清除选择的数据行复选框
			rowidArr=[];
			
			var str = encodeURIComponent(strField.getValue());
			var selectedData = AcctCheckTypeBookGrid.getSelectionModel().getSelections();
			var AcctCheckTypeID = selectedData[0].get("AcctCheckTypeID");
			CheckItemDs.proxy = new Ext.data.HttpProxy({
					url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid
					 + '&AcctCheckTypeID=' + AcctCheckTypeID + '&str=' + str
				});
			CheckItemDs.load({
				params: {
					start: 0,
					limit: 25
				}
			});
		}
	});
//增加按钮
var addButton = new Ext.Toolbar.Button({
		text: '增加',
		tooltip: '增加', //悬停提示
		iconCls: 'add',

		handler: function () {
			additemfun();
		}
	});

//修改按钮
var editButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改',
		iconCls: 'edit',
		handler: function () {
			edititemfun();
		}
	});

//删除按钮
var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {

			var records = AcctCheckItemGrid.getSelectionModel().getSelections();
			var rowids="";
			var len=records.length ;
			if (records.length < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择需要删除的数据!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}else{
				for(var i=0;i<len;i++){
					var rowid=records[i].get("rowid");
					if(rowids==""){
						rowids=rowid;
					}else{
						rowids=rowids+","+rowid;
						
					}
					
				}
				//alert(rowids);
			}
			Ext.MessageBox.confirm('提示', '确定要删除选定的行吗?', function (btn) {
				if (btn == 'yes') {

					/* Ext.each(records, function(record) {
					if (Ext.isEmpty(record.get("rowid"))) {
					CheckItemDs.getStore().remove(record);
					return;
					} */
					// records[0].get("rowid")
					Ext.Ajax.request({
						url: CheckTypeUrl + '?action=CheckItemdel&rowid=' + rowids + '&AcctBookID=' + acctbookid,
						waitMsg: '删除中...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								var count=jsonData.count;
								//alert(count);
								if(count==0){
								Ext.Msg.show({
									title: '注意',
									msg: '删除成功!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								}else{
								   Ext.Msg.show({
									title: '注意',
									msg: '删除成功,其中有'+count+"条数据正在被使用，不可删除！",
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});	
									}
							var tbarnum = AcctCheckItemGrid.getBottomToolbar();  
                             tbarnum.doLoad(tbarnum.cursor);
							} else {
								var message = jsonData.info;
								Ext.Msg.show({
									title: '错误',
									msg: message,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}
						}

					});

				}
			});

		}
	});

//导入按钮
var uploadButton = new Ext.Toolbar.Button({
		text: '导入',
		tooltip: '导入',
		iconCls: 'in',
		handler: function () {
			doimport();

		}
	});

//主数据源
var CheckItemProxy = new Ext.data.HttpProxy({
		url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid
	});

// var CheckItemProxy;

var CheckItemDs = new Ext.data.Store({
		url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid,
		// proxy: CheckItemProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['rowid', 'AcctBookID', 'BookName', 'AcctCheckTypeID', 'CheckTypeName', 'CheckItemCode', 'CheckItemName', 'IsValid',
				'StartDate', 'EndDate', 'SpellCode']),
		remoteSort: true
	});

//存储选择行的rowid
var rowidArr = [];
var AcctCheckItemGridsm = new Ext.grid.CheckboxSelectionModel({
		// id:"CheckboxSelection",
		// checkOnly: true, //仅通过复选框选择
		singleSelect: false,
		// multiSelect:true,
		editable: false/* ,
		listeners: {
			rowselect: function (t, rowIndex, record) {
				if (rowidArr.indexOf(record.get("rowid")) == -1) {
					// console.log(record.get("rowid"));
					rowidArr.push(record.get("rowid"));
				}
				// console.log(rowidArr);
			},
			rowdeselect: function (t, rowIndex, record) {
				// console.log(record.get("rowid"))
				rowidArr.remove(record.get("rowid"));
				// console.log(rowidArr)
			}
		} */
	});

//工具栏
var gridBbar = new Ext.PagingToolbar({
		store: CheckItemDs,
		pageSize: 25,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"/* ,
		listeners: {
			change: function (pageData) {
				// 取当前页的所有数据
				var allData = pageData.store.data.items;
				// console.log(allData);
				var curRowidArr = [];
				// 将所有数据行的rowid存储
				
				Ext.each(allData, function (v) { //方案二
					curRowidArr.push(v.data.rowid);
				});

				// curRowidArr = allData.map(function (v) { //方案三
				// return v.data.rowid;
				// });
				// console.log(curRowidArr);
				// 与已选择的进行比较，跳转到有选中的页时，使其成选中状态。
				var rowNo = [];
				for (var i = 0; i < rowidArr.length; i++) {
					//判断遍历的rowid在已选的rowid数组中的位置（行号）
					var pos = curRowidArr.indexOf(rowidArr[i])
						if (pos !== -1) {
							// alert(rowidArr[i]);
							rowNo.push(pos);
							// console.log(rowNo)
						};

				}
				// var selModel = AcctCheckItemGrid.getSelectionModel();
				// selModel.selectRows(rowNo);
				AcctCheckItemGridsm.selectRows(rowNo);
				
			}
		} */
	});
	/* //重写工具栏刷新按钮的方法
	gridBbar.refresh.handler=function(){
		// alert(12314);
		rowidArr=[];	//刷新前清空复选框选中的数据行
		this.doLoad(this.cursor);
		
	}; */
	
	//console.log(gridBbar.refresh.listeners)
	
	
var AcctCheckItemGrid = new Ext.grid.EditorGridPanel({
		title: '会计核算项字典维护',
		region: 'center',
		iconCls:'maintain',
		// height: 600,	//Ext.getBody().getHeight()
		atLoad: true,
		// collapsible : true,	//向上收起
		store: CheckItemDs,
		trackMouseOver: true,
		stripeRows: true,
		/* viewConfig:{
		forceFit:true,
		scrollOffset : 0
		},  */
		sm: AcctCheckItemGridsm,
		loadMask: true,
		cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
				// AcctCheckItemGridsm, 
				{
					header: '<div style="text-align:center">ID</div>',
					dataIndex: 'rowid',
					Width: 40,
					align: 'center',
					tdCls: 'tdValign',
					hidden: true
				}, {
					header: '<div style="text-align:center">单位账套代码</div>',
					dataIndex: 'AcctBookID',
					Width: 40,
					align: 'center',
					hidden: true
				}, {
					id: 'AcctBookName',
					header: '<div style="text-align:center">单位账套名称</div>',
					dataIndex: 'BookName',
					width: 120,
					/* renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
					cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
					return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
					}, */
					//align:'center',
					editable: true
				}, {
					header: '<div style="text-align:center">会计核算类别代码</div>',
					dataIndex: 'AcctCheckTypeID',
					Width: 40,
					align: 'center',
					hidden: true
				}, {
					id: 'CheckTypeName',
					header: '<div style="text-align:center">会计核算类别</div>',
					dataIndex: 'CheckTypeName',
					width: 120,
					align: 'center'
				}, {
					id: 'CheckItemCode',
					header: '<div style="text-align:center">核算项目编码</div>',
					dataIndex: 'CheckItemCode',
					width: 100
					//align:'center'
				}, {
					id: 'CheckItemName',
					header: '<div style="text-align:center">核算项目名称</div>',
					dataIndex: 'CheckItemName',
					width: 240,
					renderer: function (value, meta, record) {
						meta.attr = 'style="white-space:normal;"'; //长度超出宽度时换行。vertical-align:middle;
						return value;
					}
					//align:'center'
				}, {
					id: 'IsValid',
					header: '<div style="text-align:center">是否有效</div>',
					dataIndex: 'IsValid',
					//minwidth:20,
					width: 65,
					align: 'center'
				}, {
					id: 'StartDate',
					header: '<div style="text-align:center">起始时间</div>',
					dataIndex: 'StartDate',
					width: 90,
					align: 'center'
				}, {
					id: 'EndDate',
					header: '<div style="text-align:center">终止时间</div>',
					dataIndex: 'EndDate',
					width: 90,
					align: 'center'
				}, {
					id: 'SpellCode',
					header: '<div style="text-align:center">拼音码</div>',
					dataIndex: 'SpellCode',
					width: 150,
					align: 'center',
					hidden: true
				}
			]),
		tbar: ['核算项目名称：', strField, '-', findButton, '-', addButton, '-', editButton, '-', delButton, '-', uploadButton],
		bbar:gridBbar

	});
	
	
	