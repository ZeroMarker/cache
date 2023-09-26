// WhonetButEdit.js
// 用于维护WHONET码
// hulihua 2014-09-18(九一八事变日)
function WhonetButEdit(Input, Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;
	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	// 访问路径
	var WhonetInfoUrl = DictUrl	+ 'druginfomaintainaction.csp?actiontype=GetWhonetInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : WhonetInfoUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["AntCode","AntName", "AntEName"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "whonetinfo",
				fields : fields
			});
	// 数据集
	var WhonetStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	WhonetStore.load({
		params:{Input:Input,start:0,limit:85},
		callback : function(o,response,success) { 
			if (success == false){  
				Ext.MessageBox.alert("查询错误",WhonetStore.reader.jsonData.Error);  
			}
		}
	});
	var nm = new Ext.grid.RowNumberer();
	var WhonetInfoCm = new Ext.grid.ColumnModel([nm,{
				header : "代码",
				dataIndex : 'AntCode',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "中文描述",
				dataIndex : 'AntName',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "英文描述",
				dataIndex : 'AntEName',
				width : 150,
				align : 'left',
				sortable : true
			
	        }]);
	WhonetInfoCm.defaultSortable = true;
	        
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : WhonetStore,
					pageSize : 85,
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
					emptyMsg : "没有数据"
				});	
	var WhonetInfoGrid = new Ext.grid.GridPanel({
				id : 'WhonetInfoGrid',
				title : '',
				height : 170,
				ds: WhonetStore,
				cm : WhonetInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : WhonetStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});
			
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '点击关闭',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					flg = false;
					window.close();
				}
			});
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRows = WhonetInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择要返回的Whonet码信息！");
		} else if (selectRows.length > 1) {
			Msg.info("warning", "返回只允许选择一条记录！");
		} else {
			flg = true;
			window.close();
		}
	}
    // 双击行事件  
	WhonetInfoGrid.on('rowdblclick', function() {
				returnData();
			});
	// 回车事件
	WhonetInfoGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
				}
			});	
	var window = new Ext.Window({
				title : 'WHONET码信息----双击选择WHONET码',
				width : 460,
				height : 400,
				layout : 'border',
				items :[
				    {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: WhonetInfoGrid        
		               
		            }
	            ],
	            tbar : [closeBT]
	});
	window.show();
	
	window.on('close', function(panel) {
			var selectRows = WhonetInfoGrid.getSelectionModel()
					.getSelections();
			if (selectRows.length == 0) {
				Fn("");
			} else if (selectRows.length > 1) {
				Fn("");
			} else {
				if (flg) {
					var AntCode = selectRows[0].get("AntCode");				
				    Fn(AntCode);
				} else {
					Fn("");
				}
			}
		});
	}