function IncBatSearch(inci){
	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '检索',
				tooltip : '点击检索批次信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					var locid=session['LOGON.CTLOCID'];
					BatInfoStore.load({params:{start:0,limit:15,InciId:inci,LocId:locid}});
				}
			});
	// 保存按钮
	var saveBT = new Ext.Toolbar.Button({
				text : '保存',
				tooltip : '点击保存批次信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					saveBatInfo();
				}
			});
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '点击关闭',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	function saveBatInfo(){
		var rowCount = BatInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = BatInfoStore.getAt(i);
			var Inclb = rowData.get("Inclb");
			var NotUseFlag = rowData.get("NotUseFlag");
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=SaveBatInfo";
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Inclb:Inclb,NotUseFlag:NotUseFlag},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								//Msg.info("success", "保存成功!");
								window.close();
							} else {
								var ret=jsonData.info;
								if(ret=="-1"){
								Msg.info("error", "保存失败!");
								}
							}
						},
						scope : this
					});
			loadMask.hide();	
		}
		}
	// 访问路径
	var BatInfoUrl = DictUrl	+ 'druginfomaintainaction.csp?actiontype=GetBatInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : BatInfoUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["Inclb","Inci", "InciCode", "InciDesc","StockQty","StkBin","Btno", "Expdate", "PurStockQty",
			"Spec","NotUseFlag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "batinfo",
				fields : fields
			});
	// 数据集
	var BatInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var locid=session['LOGON.CTLOCID'];
	BatInfoStore.load({params:{start:0,limit:15,InciId:inci,LocId:locid}});
	var nm = new Ext.grid.RowNumberer();
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '不可用',
   		dataIndex: 'NotUseFlag',
   		width: 45,
   		sortable:true,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
		    return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var BatInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "Inclb",
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "Inci",
				dataIndex : 'Inci',
				width : 120,
				align : 'left',
				sortable : true,
			    hidden : true,
				hideable : false
	        }
	        , {
				header : "代码",
				dataIndex : 'InciCode',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "名称",
				dataIndex : 'InciDesc',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "库存数量(基本单位)",
				dataIndex : 'StockQty',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "货位",
				dataIndex : 'StkBin',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "批号",
				dataIndex : 'Btno',
				width : 120,
				align : 'left',
				sortable : true
			
	        }, {
				header : "效期",
				dataIndex : 'Expdate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "库存数量(入库单位)",
				dataIndex : 'PurStockQty',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "规格",
				dataIndex : 'Spec',
				width : 120,
				align : 'left',
				sortable : true
			
	        },ColumnNotUseFlag]);
	var BatInfoGrid = new Ext.grid.GridPanel({
				id : 'BatInfoGrid',
				title : '',
				height : 170,
				cm : BatInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : BatInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				plugins:ColumnNotUseFlag
				//bbar:[GridPagingToolbar]
			});
	BatInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : BatInfoStore,
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
						B['InciId']=InciId;
						B['LocId']=LocId;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
	var window = new Ext.Window({
				title : '批次信息',
				width : 1100,
				height : 600,
				layout : 'border',
				items :[
				    {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: BatInfoGrid        
		               
		            }
	            ],
	            tbar : [saveBT,'-',closeBT]
	});
	window.show();
	}