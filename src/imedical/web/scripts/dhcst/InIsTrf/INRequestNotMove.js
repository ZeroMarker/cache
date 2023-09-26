// /名称: 查询未转移项
// /描述: 出库后查询未转移项
// /编写者：yunhaibao
// /编写日期: 20150711
var TransNotMove=function(transno,reqno) {
	var CreateTimes=0;
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	var CreateReqBT = new Ext.Toolbar.Button({
				text : '生成请求单',
				tooltip : '生成请求单',
				iconCls : 'page_save',
				anchor : '90%',
				width : 120,
				handler : function() {
					var count= NotMoveDetailGridS.getStore().getCount();
					if(count==0){
					    Msg.info("warning", "明细为空!无可用数据!");
						return false;
					}
					if(CreateTimes>0){
						Msg.info("warning", "已重新申请过一次!");
						return false;
					}
					var reqitmstr
					reqitmstr=""
					for(var index=0;index<count;index++)
					{
						var reqdata = NotMoveDetailStore.getAt(index);
						var	reqid=reqdata.data['rowid']
						var reqqty=reqdata.data['NotTransQty']
						if (reqitmstr==""){reqitmstr=reqid+"^"+reqqty;}
						else {reqitmstr=reqitmstr+xRowDelim()+reqid+"^"+reqqty;}
					}
					var url = 'dhcst.inrequestaction.csp?actiontype=InsertReqByNotMove';
					var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
					Ext.Ajax.request({
								url : url,
								method : 'POST',
								params:{ReqItmStr:reqitmstr},
								waitMsg : '处理中...',
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										CreateTimes=CreateTimes+1;
										Ext.Msg.show({
													title : '生成请求单成功!',
													msg : "请求单号:"+jsonData.info,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.SUCCESS
												});	
										NotMoveWin.close()

									} else {
										Msg.info("error",jsonData.info);
									}
								},
								scope : this
							});
					
					loadMask.hide();
				}
	});
	
	var ExportBTS = new Ext.Toolbar.Button({
				text : '另存',
				tooltip : '另存为Excel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(NotMoveDetailGridS)
				}
			});
	var ExportBTS = new Ext.Toolbar.Button({
			text : '删除',
			iconCls : 'page_delete',
			width : 70,
			height : 30,
			handler : function() {
				var selectlist=NotMoveDetailGridS.getSelectionModel().getSelections();
				if ((selectlist.length==null)||(selectlist.length<0)){
					Msg.info("error","请选择数据!");
					return false;
				}
				Ext.MessageBox.confirm('提示','确定要删除记录?',
					function(btn) {
						if(btn == 'yes'){
							var selectlength=selectlist.length
							for (var selecti=0;selecti<selectlength;selecti++){
								var selectrecord=selectlist[selecti];
								NotMoveDetailStore.remove(selectrecord);				
							}
							NotMoveDetailGridS.getView().refresh();
						}
					}
				 )

			}
		});
	var CloseBTS = new Ext.Toolbar.Button({
				id : "CloseBTS",
				text : '关闭',
				tooltip : '点击关闭',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					NotMoveWin.close()
				}
			});
	
	// 请求明细
	// 访问路径
	var DetailUrl =DictUrl+
		'inrequestaction.csp?actiontype=queryDetail';  //选取请求单的csp
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["rowid", "inci", "code","desc","qty","NotTransQty","uomDesc", "spec",
			 "manf","sp","reqqty"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// 数据集
	var NotMoveDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var NotMoveDetailCm = new Ext.grid.ColumnModel([
			{
				header : "RowId",
				dataIndex : 'rowid',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品RowId",
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '药品代码',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '药品名称',
				dataIndex : 'desc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "未转移数量",
				dataIndex : 'NotTransQty',
				width : 100,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {								
								var transqty = field.getValue();
								if (transqty == null || transqty.length <= 0) {
									Msg.info("warning", "转移数量不能为空!");
									return;
								}
								if (transqty <= 0) {
									Msg.info("warning", "转移数量不能小于或等于0!");
									return;
								}
							}
							//上下键操作
							if(e.getKey()==Ext.EventObject.UP){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=38;} 
								var rowrecord = NotMoveDetailGridS.getSelectionModel().getSelected();
								var recordrow = NotMoveDetailStore.indexOf(rowrecord)
								var colIndex=GetColIndex(NotMoveDetailGridS,"NotTransQty");
								var row=recordrow-1;
								if(row>=0){
									//NotMoveDetailGridS.getSelectionModel().select(row, colIndex);
									NotMoveDetailGridS.getSelectionModel().selectRow(row);
									NotMoveDetailGridS.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.DOWN){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=40;} 
								var rowCount=NotMoveDetailGridS.getStore().getCount();
								var rowrecord = NotMoveDetailGridS.getSelectionModel().getSelected();
								var recordrow = NotMoveDetailStore.indexOf(rowrecord)
								var colIndex=GetColIndex(NotMoveDetailGridS,"NotTransQty");
								var row=recordrow+1;
								if(row<rowCount){
									//NotMoveDetailGridS.getSelectionModel().select(row, colIndex);
									NotMoveDetailGridS.getSelectionModel().selectRow(row);
									NotMoveDetailGridS.startEditing(row, colIndex);
								}
							}

						}
						}
					})
			
			}, {
				header : "单位",
				dataIndex : 'uomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "请求方库存",
				dataIndex : 'reqqty',
				width : 180,
				align : 'left',
				sortable : true
			}]);
 var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:NotMoveDetailStore,
		pageSize:999,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});

	var NotMoveDetailGridS = new Ext.grid.EditorGridPanel({
				id : 'NotMoveDetailGridS',
				region : 'center',
				title : '',
				cm : NotMoveDetailCm,
				sm:new Ext.grid.RowSelectionModel({}),
				store : NotMoveDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1,
				bbar:GridDetailPagingToolbar,
				listeners:{
						'beforeedit':function(e)
						{
							if (e.field=='NotTransQty'){	
								var currecord=e.record
								var recordrow = NotMoveDetailStore.indexOf(currecord)
								NotMoveDetailGridS.getSelectionModel().selectRow(recordrow);
							}
						}
				}

			});

	var NotMoveWin = new Ext.Window({
		title:'<font size=3 color=Blue><p>'+'转移单号:'+transno+'-----------请求单号:'+reqno+'</p></font>',
		id:'NotMoveWin',
		width:1000,
		height:520,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'border',
		items : [            // create instance immediately
			{
	            region: 'center',
	            title: '请求单明细',
	            layout: 'fit', // specify layout manager for items
	            items: NotMoveDetailGridS       
	           
	        }
		],
		tbar : [CreateReqBT,'-',ExportBTS,'-',CloseBTS]
		
	});
		
	//显示窗口
	NotMoveWin.show();
	var ReqId = tkMakeServerCall("web.DHCST.INRequest","GetInReqIdByNo",reqno)
	var show=0  //是否显示已转移完成的请求明细（1：显示；0：不显示）
	NotMoveDetailStore.removeAll();
	NotMoveDetailStore.setBaseParam('req',ReqId);
	NotMoveDetailStore.setBaseParam('TransferedFlag',show);
	NotMoveDetailStore.load({params:{start:0,limit:999,sort:'req',dir:'Desc'}});
	
}