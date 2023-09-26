// /名称: 科室管理组维护
// /描述: 科室管理组维护
// /编写者：zhangdongmei
// /编写日期: 2012.08.23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var groupId=session['LOGON.GROUPID'];
	var gLocId=null;


	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});

		/**
		 * 查询方法
		 */
		function Query() {
			// 必选条件
			var Code = Ext.getCmp("LocCode").getValue();
			var Desc = Ext.getCmp("LocDesc").getValue();

			gStrParam=Code+"^"+Desc;
			var PageSize=LocPagingToolbar.pageSize;
			LocStore.load({params:{start:0,limit:PageSize,StrParam:gStrParam,GroupId:groupId}});

		}

		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			gLocId="";
			Ext.getCmp("LocCode").setValue('');
			Ext.getCmp("LocDesc").setValue('');
			LocManGrpGrid.store.removeAll();
			LocGrid.store.removeAll();
			LocGrid.getView().refresh();
		}

		//新建
		var AddBT=new Ext.Toolbar.Button({
			id:'AddBT',
			text:'新增',
			tooltip:'点击增加',
			width:70,
			height:30,
			iconCls:'page_add',
			handler:function(){

				if(gLocId==null || gLocId.length<1){
					Msg.info("warning","请先选择科室!");
					return;
				}

				AddNewRow();
			}
		});

		function AddNewRow(){
			var record=Ext.data.Record.create([{name:'Rowid'},{name:'Code'},{name:'Desc'}]);
			var newRecord=new Ext.data.Record({
				Rowid:'',
				Code:'',
				Desc:''
			});

			LocManGrpStore.add(newRecord);
			var lastRow=LocManGrpStore.getCount()-1;
			LocManGrpGrid.startEditing(lastRow,2);
		}
		// 保存按钮
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '保存',
					tooltip : '点击保存',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// 保存科室库存管理信息
						save();
					}
				});
		function save(){
			if(gLocId==null || gLocId.length<1){
				Msg.info("warning","科室不能为空!")
				return;
			}
			var ListDetail="";
			var rowCount = LocManGrpGrid.getStore().getCount();

			for (var i = 0; i < rowCount; i++) {
				var rowData = LocManGrpStore.getAt(i);
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					var Rowid = rowData.get("Rowid");
					var Code = rowData.get("Code").trim();
					var Desc=rowData.get("Desc").trim();
					if(Code!="" && Desc!=""){
						var str = Rowid + "^" + Code+"^"+Desc;
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if(ListDetail==""){
				Msg.info("warning","没有修改或添加新数据!");
				return false;
			}
			var url = DictUrl
					+ "locmangrpaction.csp?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
						url : url,
						params: {LocId:gLocId,Detail:ListDetail},
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {

								Msg.info("success", "保存成功!");
								// 刷新界面
								LocManGrpStore.load({params:{LocId:gLocId}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "没有需要保存的数据!");
								}else {
									Msg.info("error", "部分明细保存不成功："+ret);
								}

							}
						},
						scope : this
					});

		}

	var DeleteBT=new Ext.Toolbar.Button({
		id:'DeleteBT',
		text:'删除',
		width:'70',
		height:'30',
		tooltip:'点击删除',
		iconCls:'page_delete',
		handler: function(){
			Delete();
		}
	});

	function Delete(){
		var cell=LocManGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择要删除的记录！");
			return;
		}
		var row=cell[0];
		var record=LocManGrpStore.getAt(row);
		var rowid=record.get("Rowid");
		if(rowid==null || rowid.length<1){
			Msg.info("warning","所选记录尚未保存，不能删除!");
			return;
		}else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该管理组信息',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}

		function showResult(btn) {
			if (btn == "yes") {
		var url = DictUrl	+ "locmangrpaction.csp?actiontype=Delete";
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			method:'post',
			waitMsg:'处理中...',
			params:{Rowid:rowid},
			success: function(response,opts){

				var jsonData=Ext.util.JSON.decode(response.responseText);
				  mask.hide();
				if (jsonData.success=='true'){
					Msg.info("success","删除成功!");
					LocManGrpStore.load({params:{LocId:gLocId}});
				}else {
					Msg.info("error","删除失败!");
				}

			}
		});

	}}}
	//配置数据源
	var locUrl =DictUrl+'locmangrpaction.csp?actiontype=QueryLoc';
	var LocGridProxy= new Ext.data.HttpProxy({url:locUrl,method:'POST'});
	var LocStore = new Ext.data.Store({
		proxy:LocGridProxy,
	    reader:new Ext.data.JsonReader({
			totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'Rowid'},
			{name:'Code'},
			{name:'Desc'}
		]),
	    remoteSort:true
	});

	//模型
	var LocGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"代码",
	        dataIndex:'Code',
	        width:200,
	        align:'left',
	        sortable:true
	    },{
	        header:"名称",
	        dataIndex:'Desc',
	        width:200,
	        align:'left',
	        sortable:true
	    }
	]);
	//初始化默认排序功能
	LocGridCm.defaultSortable = true;
	var LocPagingToolbar = new Ext.PagingToolbar({
	    store:LocStore,
		pageSize:PageSize,
	    displayInfo:true,
	    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	    emptyMsg:"没有记录",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B[A.sort]='Rowid';
			B[A.dir]='desc';
			B['StrParam']=gStrParam;
			B['GroupId']=groupId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});

	var LocCode=new Ext.form.TextField({
		id:'LocCode',
		name:'LocCode',
		width:100
	});

	var LocDesc=new Ext.form.TextField({
		id:'LocDesc',
		name:'LocDesc',
		width:120
	});

	//表格
	LocGrid = new Ext.grid.GridPanel({
		store:LocStore,
		cm:LocGridCm,
		trackMouseOver:true,
		height:500,
		stripeRows:true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask:true,
		bbar:LocPagingToolbar,
		tbar:['代码:',LocCode,'名称:',LocDesc,'-',SearchBT,'-',RefreshBT]
	});

	LocGrid.addListener("rowclick",function(grid,rowindex,e){
		var selectRow=LocStore.getAt(rowindex);
		gLocId=selectRow.get("Rowid");
		LocManGrpStore.load({params:{LocId:gLocId}});
	});

		var nm = new Ext.grid.RowNumberer();
		var LocManGrpCm = new Ext.grid.ColumnModel([nm, {
					header : "Rowid",
					dataIndex : 'Rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'Code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : false,
					editor:new Ext.form.TextField({
						allowBlank:false,
						listeners:{
							specialkey: function(field,e){
								var keycode=e.getKey();
								if(keycode==e.ENTER){
									var cell=LocManGrpGrid.getSelectionModel().getSelectedCell();
									var row=cell[0];
									LocManGrpGrid.startEditing(row,3);
								}
							}
						}
					})
				}, {
					header : "描述",
					dataIndex : 'Desc',
					width : 200,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
						allowBlank:false,
						listeners:{
							specialkey: function(field,e){
								var keycode=e.getKey();
								if(keycode==e.ENTER){
									AddNewRow();
								}
							}
						}
					})
			}]);
		LocManGrpCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locmangrpaction.csp?actiontype=Query&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : ["Rowid","Code","Desc"]
				});
		// 数据集
		var LocManGrpStore = new Ext.data.Store({
					pruneModifiedRecords:true,
					proxy : proxy,
					reader : reader
				});
		var LocManGrpGrid = new Ext.grid.EditorGridPanel({
					id:'LocManGrpGrid',
					cm : LocManGrpCm,
					store : LocManGrpStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					tbar:[AddBT,'-',SaveBT],		//,'-',DeleteBT
					loadMask : true
				});

		// 5.2.页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 500,
                			minSize: 450,
                			maxSize: 550,
                			collapsible: true,
			                title: '科室',
			                layout: 'fit', // specify layout manager for items
			                items: LocGrid

			            }, {
			                region: 'center',
			                title: '管理组',
			                layout: 'fit', // specify layout manager for items
			                items: LocManGrpGrid

			            }
	       			],
					renderTo : 'mainPanel'
				});
	Query();
})