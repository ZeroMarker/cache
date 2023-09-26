// /名称: 实盘：录入方式一（根据帐盘数据按批次填充实盘数）
// /描述:  实盘：录入方式一（根据帐盘数据按批次填充实盘数）
// /编写者：zhangdongmei
// /编写日期: 2012.08.30
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParams='';
	var gStrDetailParams='';
	var gRowid='';
	var url=DictUrl+'instktkaction.csp';
	var PhaLoc = new Ext.form.ComboBox({
				fieldLabel : '科室',
				id : 'PhaLoc',
				name : 'PhaLoc',
				//anchor : '95%',
				width : 140,
				store : GetGroupDeptStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '科室...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				hideLabel:true,
				valueNotFoundText : ''
			});
	// 登录设置默认值
	SetLogInDept(GetGroupDeptStore, "PhaLoc");
	
	var LocManaGrp = new Ext.form.ComboBox({
				fieldLabel : '管理组',
				id : 'LocManaGrp',
				name : 'LocManaGrp',
				//anchor : '95%',
				width : 140,
				store : LocManGrpStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				emptyText : '管理组...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				listeners:{
					'expand':function(combox){
							var LocId=Ext.getCmp('PhaLoc').getValue();
							LocManGrpStore.load({params:{start:0,limit:20,locId:LocId}});	
					}
				}
			});		
		
	var PhaWindow = new Ext.form.ComboBox({
			fieldLabel : '实盘窗口',
			id : 'PhaWindow',
			name : 'PhaWindow',
			//anchor : '95%',
			width : 140,
			store : PhaWindowStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			emptyText : '实盘窗口...',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			listeners:{
				'beforequery':function(e){
					var desc=Ext.getCmp('PhaWindow').getRawValue();
					if(desc!=null || desc.length>0){
						PhaWindowStore.load({params:{start:0,limit:20,Desc:desc}});
					}
				}
			}
		});	
		
	var Complete=new Ext.form.Checkbox({
		fieldLabel:'完成',
		id:'Complete',
		name:'Complete',
		width:80,
		disabled:true
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:"G",     //标识类组类型
		width : 140
	}); 

	var DHCStkCatGroup = new Ext.form.ComboBox({
				fieldLabel : '库存分类',
				id : 'DHCStkCatGroup',
				name : 'DHCStkCatGroup',
				anchor : '90%',
				width : 140,
				store : StkCatStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				valueNotFoundText : ''
			});

	StkGrpType.on('select', function(e) {
		Ext.getCmp('DHCStkCatGroup').setValue("");
		StkCatStore.proxy = new Ext.data.HttpProxy({
			url : 'dhcst.drugutil.csp?actiontype=StkCat&StkGrpId='+ Ext.getCmp('StkGrpType').getValue()+ '&start=0&limit=999'
		});
		StkCatStore.reload();
	});
		
	var StkBin = new Ext.form.ComboBox({
		fieldLabel : '货位',
		id : 'StkBin',
		name : 'StkBin',
		anchor : '90%',
		width : 140,
		store : LocStkBinStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		enableKeyEvents : true,
		listeners : {
			'expand' : function(e) {
				var LocId=Ext.getCmp("PhaLoc").getValue();
				LocStkBinStore.load({params:{LocId:LocId,Desc:Ext.getCmp('StkBin').getRawValue(),start:0,limit:20}});					
			}
		}
	});	
	
	// 起始日期
	var StartDate = new Ext.form.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				format : 'Y-m-d',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// 结束日期
	var EndDate = new Ext.form.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				format : 'Y-m-d',
				width : 80,
				value : new Date()
			});
			
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					QueryDetail();
				}
			});
	
	// 查询按钮
	var QueryBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});
	
	//设置未填数等于帐盘数
	var SetDefaultBT2 = new Ext.Toolbar.Button({
				text : '设置未填数等于帐盘数',
				tooltip : '点击设置未填数等于帐盘数',
				iconCls : 'page_save',
				width : 70,
				height : 30,
				handler : function() {
					SetDefaultQty(2);
				}
			});
			
	//设置未填数等于0
	var SetDefaultBT = new Ext.Toolbar.Button({
				text : '设置未填数等于0',
				tooltip : '点击设置未填数等于0',
				iconCls : 'page_save',
				width : 70,
				height : 30,
				handler : function() {
					SetDefaultQty(1);
				}
			});
	
	//设置未填实盘数
	function SetDefaultQty(flag){
		if(gRowid==''){
			Msg.info('Warning','没有选中的盘点单！');
			return;
		}
		var UserId=session['LOGON.USERID'];
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'SetDefaultQty',Inst:gRowid,UserId:UserId,Flag:flag},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					Msg.info('success','成功!');
					QueryDetail();
				}else{
					var ret=jsonData.info;					
					Msg.info('error','设置未填记录实盘数失败:'+ret);
					
				}
			}		
		});
	}
	
	//查询盘点单
	function Query(){
	
		var StartDate = Ext.getCmp("StartDate").getValue().format('Y-m-d').toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format('Y-m-d').toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择盘点科室!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		var CompFlag='Y';
		var TkComplete='N';  //实盘完成标志
		var AdjComplete='N';	//调整完成标志
		var Page=GridPagingToolbar.pageSize;
		gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.load({params:{actiontype:'Query',start:0, limit:Page,sort:'instNo',dir:'asc',Params:gStrParams}});
	}
	
	// 清空按钮
	var RefreshBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_refresh',
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
		
		gStrParams='';
		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("StkBin").setValue('');
		Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("PhaWindow").setValue('');
		Ext.getCmp("LocManaGrp").setValue('');
		
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}

	var SaveBT=new Ext.Toolbar.Button({
		text:'保存',
		tooltip:'点击保存',
		iconCls:'page_add',
		width:70,
		height:30,
		handler:function(){
			save();
		}
	});
	
	//保存实盘数据
	function save(){
		var rowCount=InstDetailStore.getCount();
		var ListDetail='';
		for(var i=0;i<rowCount;i++){
			var rowData=InstDetailStore.getAt(i);
			//新增或修改过的数据
			if(rowData.dirty || rowData.data.newRecord){
				var Parref=rowData.get('insti');
				var Rowid=rowData.get('instw');
				var UserId=session['LOGON.USERID'];
				var CountQty=rowData.get('countQty');
				var CountUomId=rowData.get('uom');
				var StkBin='';
				var PhaWin=Ext.getCmp('PhaWindow').getValue();
				var Detail=Parref+'^'+Rowid+'^'+UserId+'^'+CountQty+'^'+CountUomId+'^'+StkBin+'^'+PhaWin;
				if(ListDetail==''){
					ListDetail=Detail;
				}else{
					ListDetail=ListDetail+','+Detail;
				}
			}
		}
		if(ListDetail==''){
			Msg.info('Warning','没有需要保存的数据!');
			return;
		}
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'SaveTkItmWd',Params:ListDetail},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData=='true'){
					Msg.info('success','保存成功!');
					QueryDetail();
				}else{
					var ret=jsonData.info;
					if(ret=='-1'){
						Msg.info('warning','没有需要保存的数据!');
					}else if(ret=='-2'){
						Msg.info('error','保存失败!');
					}else{
						Msg.info('error','部分数据保存失败:'+ret);
					}
				}
			}		
		});
	}
	
	//根据帐盘数据插入实盘列表
	function create(inst){
		if(inst==null || inst==''){
			Msg.info('warning','请选择盘点单');
			return;
		}
		var UserId=session['LOGON.USERID'];
	
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'CreateTkItmWd',Inst:inst,UserId:UserId},
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					QueryDetail(inst);    //查找实盘列表
				}else{
					var ret=jsonData.info;					
					Msg.info("error","提取实盘列表失败："+ret);					
				}
			}			
		});
	}
		
	//查找盘点单及明细信息
	function QueryDetail(){
		
		//查询盘点单明细
		var StkGrpId=Ext.getCmp('StkGrpType').getValue();
		var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
		var StkBinId=Ext.getCmp('StkBin').getValue();
		var PhaWinId=Ext.getCmp('PhaWindow').getValue();
		var ManaGrpId=Ext.getCmp('LocManaGrp').getValue();
		var size=StatuTabPagingToolbar.pageSize;
		
		gStrDetailParams=gRowid+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
		InstDetailStore.load({params:{actiontype:'INStkTkItmWd',start:0,limit:size,sort:'desc',dir:'ASC',Params:gStrDetailParams}});
	}
	
	var CompleteBT=new Ext.Toolbar.Button({
		text:'确认完成',
		tooltip:'点击确认完成',
		iconCls:'page_gear',
		width:70,
		height:30,
		handler:function(){
			InstComplete();
		}
	});
	
	//确认完成
	function InstComplete(){
		if(gRowid==null){
			Msg.info("warning","没有需要完成的盘点单!");
			return;
		}
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'ChangeInputStatus',Inst:gRowid,Complete:'Y'},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					Msg.info("success","操作成功!");
					Ext.getCmp('Complete').setValue(true);
					Ext.getCmp('Save').setDisabled(true);
					Ext.getCmp('SetDefaultQty').setDisabled(true);
					Ext.getCmp('SetDefaultQty2').setDisabled(true);
				}else{
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error","加锁失败!");
					}else if(ret==-2){
						Msg.info("error","盘点单已经调整!");
					}else if(ret==-3){
						Msg.info("error","盘点单帐盘尚未完成!");
					}else if(ret==-4){
						Msg.info("error","存在未录入实盘数的记录，请核实!");
					}else{
						Msg.info("error","操作失败!");
					}
				}
			}			
		});
	}

	// 指定列参数
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// 数据集
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : url,
				method : "POST"
			});
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});	
	
	function renderCompFlag(value){
		if(value=='Y'){
			return '完成';
		}else{
			return '未完成'
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return '管理药';
		}else{
			return '非管理药'
		}	
	}
	function renderYesNo(value){
		if(value=='Y'){
			return '是';
		}else{
			return '否'
		}	
	}
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "盘点单号",
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "盘点日期",
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '盘点时间',
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '盘点人',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '帐盘完成标志',
				dataIndex : 'comp',
				width : 50,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '管理药标志',
				dataIndex : 'manFlag',
				width : 50,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "帐盘单位",
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return '入库单位';
					}else{
						return '基本单位';
					}
				},
				sortable : true
			}, {
				header : "包含不可用",
				dataIndex : 'includeNotUse',
				width : 50,
				align : 'left',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "仅不可用",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 50,
				align : 'right',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "开始货位",
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "截止货位",
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
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
						B['Params']=gStrParams;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
	var MasterInfoGrid = new Ext.grid.GridPanel({
				id : 'MasterInfoGrid',
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 双击事件
	MasterInfoGrid.on('rowdblclick', function(grid,rowindex,e) {
		Ext.Msg.show({
		   title:'提示',
		   msg: '该盘点单尚未录入实盘数据，需要录入吗？',
		   buttons: Ext.Msg.YESNOCANCEL,
		   fn: function(btn,text,opt){
		   		if(btn=='yes'){
		   			var selectRow=MasterInfoStore.getAt(rowindex);
					gRowid=selectRow.get('inst');
					Create(gRowid);
		   		}
		   },
		   animEl: 'elId',
		   icon: Ext.MessageBox.QUESTION
		});
		
	});
	
	MasterInfoGrid.on('rowclick',function(grid,rowindex,e){
		var selectRow=MasterInfoStore.getAt(rowindex);
		gRowid=selectRow.get('inst');
		QueryDetail();
	});
			
	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
				header : "rowid",
				dataIndex : 'instw',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "parref",
				dataIndex : 'insti',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header:"inclb",
				dataIndex:'inclb',
				width:80,
				align:'left',
				sortable:true,
				hidden:true				
			},{
				header : '代码',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "名称",
				dataIndex : 'desc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'批号',
				dataIndex:'batNo',
				width:80,
				align:'right',
				sortable:true
			}, {
				header:'效期',
				dataIndex:'expDate',
				width:100,
				align:'right',
				sortable:true
			}, {
				header : "单位",
				dataIndex : 'uomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : '冻结数量',
				dataIndex : 'freQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header:'实盘数量',
				dataIndex:'countQty',
				width:80,
				align:'right',
				sortable:true,
				editor:new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners:{
						'specialkey':function(field,e){
								var keyCode=e.getKey();
								var col=GetColIndex(InstDetailGrid,'countQty');
								var cell=InstDetailGrid.getSelectionModel().getSelectedCell();
								var rowCount=InstDetailGrid.getStore().getCount();
								if(keyCode==Ext.EventObject.ENTER){
									var qty=field.getValue();
									if(qty<0){
										Msg.info('warning','实盘数量不能小于零!');
										return;
									}
									var row=cell[0]+1;
									if(row<rowCount){
										InstDetailGrid.startEditing(row,col);
									}
								}
								if(keyCode==Ext.EventObject.UP){
									var row=cell[0]-1;
									if(row>=0){
										InstDetailGrid.startEditing(row,col);
									}
								}
								if(keyCode==Ext.EventObject.DOWN){
									var row=cell[0]+1;
									if(row<rowCount){
										InstDetailGrid.startEditing(row,col);
									}
								}
						}
					}
				})
			},{
				header : "产地",
				dataIndex : 'manf',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header:'实盘日期',
				dataIndex:'countDate',
				width:80,
				align:'right',
				sortable:true
			},{
				header : "实盘时间",
				dataIndex : 'countTime',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'实盘人',
				dataIndex:'userName',
				width:80,
				align:'right',
				sortable:true
			}]);
	InstDetailGridCm.defaultSortable = true;

	// 数据集
	var InstDetailStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
					url : url,
					method : "POST"
				}),
				reader :  new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "instw",
					fields : ["instw","insti", "inclb", "code", "desc","spec", "manf", "batNo", "expDate",
							"freQty", "uom", "uomDesc","buom","buomDesc", "rp", "sp", "countQty",
							"countDate","countTime","userName"]
				})
	});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : InstDetailStore,
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
					B['Params']=gStrDetailParams;
					B['actiontype']='INStkTkItmWd';
					if(this.fireEvent("beforechange",this,B)!==false){
						this.store.load({params:B});
					}
				}
			});
		
	StatuTabPagingToolbar.addListener('beforechange',function(toolbar,params){
		var records=InstDetailStore.getModifiedRecords();
		var nextPage=true;
		if(records.length>0){
			Ext.Msg.show({
			   title:'提示',
			   msg: '本页数据发生改变，是否需要保存？',
			   buttons: Ext.Msg.YESNOCANCEL,
			   fn: function(btn,text,opt){
			   		if(btn=='yes'){
			   			save();
			   			nextPage=false;
			   		}
			   },
			   animEl: 'elId',
			   icon: Ext.MessageBox.QUESTION
			});
		}
		
		if(nextPage==false){
			return false;
		}
	});
	
	var InstDetailGrid = new Ext.grid.EditorGridPanel({
				id:'InstDetailGrid',
				region : 'center',
				cm : InstDetailGridCm,
				store : InstDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : new Ext.grid.CellSelectionModel(),
				loadMask : true,
				bbar : StatuTabPagingToolbar,
				clicksToEdit:1
			});
	
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			style: 'padding:0 0 0 0;',
			tbar:[SearchBT,'-',SaveBT,'-',CompleteBT,'-',RefreshBT,'-',SetDefaultBT,'-',SetDefaultBT2],
			items:[{
					xtype:'fieldset',
					//title:'查询条件',
					layout: 'column',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:5px 0 0 0;',
					items : [{ 				
						columnWidth: 0.34,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 180, border:false},    // Default config options for child items
		            	//defaultType: 'textfield',
		            	autoHeight: true,
		            	boderStyle: 'padding:0 0 0 0;',
		            	style: 'padding:0 0 0 0;',
		            	border: false,
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
		               	//	"margin-bottom": "10px"
		            	//},
		            	items: [LocManaGrp,StkBin]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [StkGrpType,DHCStkCatGroup]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [PhaWindow,Complete]
						
					}]
				}]  	
		});
	
		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [{
			                region: 'west',
			                split: true,
                			width: 420,
                			minSize: 200,
                			maxSize: 420,
                			//collapsible: true,                			
                			tbar:[PhaLoc,'日期:',StartDate,EndDate,QueryBT],
			                layout: 'fit', // specify layout manager for items
			                items: MasterInfoGrid      
			               
			            }, {             
			                region: 'center',	                	
		                	layout: 'border', // specify layout manager for items
		                	items: [{
		                		region:'north',
		                		height:140,
		                		layout:'fit',
		                		items:[form ]
		                	},{
		                		region:'center',
		                		layout:'fit',
		                		items:[InstDetailGrid]
		                	}]    
			            
			            }
	       			],
					renderTo : 'mainPanel'
		});
		
	//自动加载盘点单
	Query();
})