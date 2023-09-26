	// 信息列表
		// 访问路径
		var MasterUrl = DictUrl	+ 'datainputaction.csp?actiontype=QueryError';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ['IngrId','DataInputErrDate','DataInputErrTime','DataInputErrNo','DataInputErrDesc'];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "IngrId",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
					
				});
				
			 	var nm = new Ext.grid.RowNumberer();
		        var MasterCm = new Ext.grid.ColumnModel([nm,{
					header : "rowid",
					dataIndex : 'IngrId',
					width : 60,
					align : 'right',
					sortable : true,
					hidden : true
				}, {
					header : "导入日期",
					dataIndex : 'DataInputErrDate',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '导入时间',
					dataIndex : 'DataInputErrTime',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '错误行数',
					dataIndex : 'DataInputErrNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '错误原因',
					dataIndex : 'DataInputErrDesc',
					width : 600,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;	
		
		
//create grid
		var ErrorGrid = new Ext.grid.GridPanel({
					id : 'ErrorGrid',
			        title: '错误数据查询',
			        frame:true,
			        tbar:[
			        	{
    		               text:"查询",
    	 	               iconCls:'page_find',
    	 	               handler:function()
    	 		           {		
    	 			          Query();
    	 		           }
    		            }
    		            ,'-' ,
    		            {
    		               text:"删除全部",
    		               iconCls:'page_delete',
    		                handler:function()
    	 		           {		
    	 			          Delete();
    	 		           }
    		            } 
    		       ],
					
					cm : MasterCm,
					store : MasterStore	
				});
				
	//查询导入的错误数据						
	function Query(){
			MasterStore.removeAll();
			MasterStore.load({		
			
				callback:function(r,options, success){
					if(success==false){
	     				Msg.info("error", "查询错误，请查看日志!");
	     			}
	     			}
				});
	}
	//删除全部错误数据
	function Delete(){
			var url = DictUrl+ "datainputaction.csp?actiontype=DeleteErrorData";
               var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '删除中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
									mask.hide();
								if (jsonData.success == 'true') {
									Msg.info("success", "删除成功!");
									MasterStore.removeAll();
								} else {
									Msg.info("error", "删除失败!");
								}
						
							},
							scope : this
						});
		
	}
	
	
	
	
	
	