costDeptsFun = function(dataStore,grid,pagingTool,deptLevelSetsDr,order) {

	//============================================================面板控件=============================================================
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var deptSetDr="";
	var layerDr="";
	var active="";
	var myRowid="";
	var myType="";
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择成本分摊方法后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		active=rowObj[0].get("active"); 
		deptSetDr= rowObj[0].get("deptSetDr"); 
		layerDr= rowObj[0].get("layerDr"); 
		myRowid = rowObj[0].get("rowid"); 
	}
	if(active !="Y")
	{
		Ext.Msg.show({title:'注意',msg:'不能为无效数据添加分摊方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//20090612
	var tmpUId="";
	var findCommTabProxy = new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
	var tmpMonth="";
	var myAct="";
	
	var costDeptsStore = new Ext.data.SimpleStore({//成本分摊套成本分摊套据源
		fields: ['type','rowid'],
		data : [['包含成本科室','inc'],['不包含成本科室','outc']]
	});
	var costDepts = new Ext.form.ComboBox({
		id: 'costDepts',
		fieldLabel: '受众科室类型',
		width: 100,
		listWidth : 260,
		hidden:true,
		allowBlank: false,
		store: costDeptsStore,
		valueField: 'rowid',
		displayField: 'type',
		name:'distFlag',
		triggerAction: 'all',
		emptyText:'成本科室类型...',
		mode: 'local',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	costDepts.on('select', function(combo,record,index){
		if(combo.getValue()=="inc"){
			myType="inc";
			formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
			window.setTitle("包含成本科室");
		}
		else{
			myType="outc";
			formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
			window.setTitle("不包含成本科室");
		}
		costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
		costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
		
	});
	

	var recDeptsStore = new Ext.data.SimpleStore({//成本分摊套成本分摊套据源
		fields: ['type','rowid'],
		data : [['包含受众科室','inr'],['不包含受众科室','outr']]
	});
	var recDepts = new Ext.form.ComboBox({
		id: 'recDepts',
		fieldLabel: '受众科室类型',
		width: 100,
		hidden:true,
		listWidth : 260,
		allowBlank: false,
		store: recDeptsStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'受众科室类型...',
		mode: 'local',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	recDepts.on('select', function(combo,record,index) {
		if(combo.getValue()=="inr"){
			myType="inr";
			formPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
			window.setTitle("包含受众科室");
		}
		else{
			myType="outr";
			formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
			window.setTitle("不包含受众科室");
		}
		costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
		costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
	});
	
	
	var costDeptsTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		'rowid',
		'deptDr',
		'deptCode',
		'deptName',
		'rate'
		]),
		remoteSort: true
	});

	costDeptsTabDs.setDefaultSort('RowId', 'Desc');

	var distFlagStore = new Ext.data.SimpleStore({//成本分摊套成本分摊套据源
		fields: ['type','rowid'],
		data : [['成本科室','cost'],['受众科室','rec']]
	});
	var distFlag = new Ext.form.ComboBox({
		id: 'distFlag',
		fieldLabel: '科室类型',
		width: 100,
		listWidth : 260,
		allowBlank: false,
		store: distFlagStore,
		valueField: 'rowid',
		displayField: 'type',
		name:'distFlag',
		triggerAction: 'all',
		emptyText:'科室类型...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	distFlag.on('select', function(combo,record,index) {
		var comboValue=combo.getValue();
		if(comboValue=="cost"){
			costDepts.show();
			recDepts.setVisible(false);
			//costDepts
			Ext.Ajax.request({
				url: costDistSetsUrl+'?action=checkDepts&id='+myRowid,
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						if(jsonData.info=="outc"){
							myType="outc";
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							costDepts.disable();
							costDepts.setValue("不包含成本科室");
							
						}else if(jsonData.info=="inc"){
							myType="inc";
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							costDepts.disable();
							costDepts.setValue("包含成本科室");
						}else{
							myType="inc";
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							costDepts.enable();
							costDepts.setValue("包含成本科室");
						}
						costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
						costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
					}
				},
				scope: this
			});
		}else{
			recDepts.setVisible(true);
			costDepts.setVisible(false);
			Ext.Ajax.request({
				url: costDistSetsUrl+'?action=checkRecDepts&id='+myRowid,
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						if(jsonData.info=="outr"){
							myType="outr";
							recDepts.disable();
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							recDepts.setValue("不包含受众科室");
							
						}else if(jsonData.info=="inr"){
							myType="inr";
							recDepts.disable();
							formPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
							recDepts.setValue("包含受众科室");
						}else{
							myType="inr";
							recDepts.enable();
							formPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
							recDepts.setValue("包含受众科室");
						}
						costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
						costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
					}
				},
				scope: this
			});

		}
	});
	var addMethodsButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加成本分摊方法',        
		iconCls: 'add',
		handler: function(){addCostDeptsFun(costDeptsTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,costDepts,recDepts,order,deptLevelSetsDr,layerDr);}
	});

	var editMethodsButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改成本分摊方法',
		iconCls: 'remove',
		handler: function(){editCostDeptsFun(costDeptsTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,costDepts,recDepts,order,deptLevelSetsDr,layerDr);}
	});
	
	var delMethodsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除成本分摊方法',
		iconCls: 'remove',
		handler: function(){delCostDeptsFun(costDeptsTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '部门代码',
			dataIndex: 'deptCode',
			width: 150,
			sortable: true
		},
		{
			header: '部门名称',
			dataIndex: 'deptName',
			width: 150,
			sortable: true
		}
	]);
		
	var InRecDeptsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '部门代码',
			dataIndex: 'deptCode',
			width: 150,
			sortable: true
		},
		{
			header: '部门名称',
			dataIndex: 'deptName',
			width: 150,
			sortable: true
		},
		{
			header: '比率',
			dataIndex: 'rate',
			width: 150,
			sortable: true
		}
	]);
	
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 15,
			store: costDeptsTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				//B['layerDr']=layerDr;
				B['id']=myRowid;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});
	
		//==========================================================面板==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: costDeptsTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['科室类型:',distFlag,'-',costDepts,recDepts],
			bbar: findCommTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '成本科室',
			width: 680,
			height:500,
			minWidth: 680,
			minHeight:500,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				{
					text: '取消',
					handler: function(){window.close();}
				}]
			});
			
			window.show();
		};