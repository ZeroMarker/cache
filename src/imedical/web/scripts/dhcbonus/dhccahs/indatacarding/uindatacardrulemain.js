var busdingUrl = 'dhc.ca.indatacardingexe.csp';
var inDataCardRuleProxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=listCardRule'});

//特殊数据单元数据源
var inDataCardRuleDs = new Ext.data.Store({
	proxy: inDataCardRuleProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'itemDr',
		'itemCode',
		'itemName',
		'srDeptDr',
		'srDeptCode',
		'srDeptName',
		'deDeptDr',
		'deDeptCode',
		'deDeptName'
	]),
	// turn on remote sorting
	remoteSort: true
});

inDataCardRuleDs.setDefaultSort('rowid', 'Desc');

var twoCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '业务项代码',
	dataIndex: 'itemCode',
	width: 80,
	sortable: true
},
{
	header: "业务项名称",
	dataIndex: 'itemName',
	width: 150,
	align: 'left',
	sortable: true
},
{
	header: '目标科室代码',
	dataIndex: 'deDeptCode',
	width: 80,
	sortable: true
},
{
	header: "目标科室名称",
	dataIndex: 'deDeptName',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var threeCm= new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '源科室代码',
	dataIndex: 'srDeptCode',
	width: 80,
	sortable: true
},
{
	header: "源科室名称",
	dataIndex: 'srDeptName',
	width: 150,
	align: 'left',
	sortable: true
},
{
	header: '目标科室代码',
	dataIndex: 'deDeptCode',
	width: 80,
	sortable: true
},
{
	header: "目标科室名称",
	dataIndex: 'deDeptName',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var oneCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '源科室代码',
	dataIndex: 'srDeptCode',
	width: 80,
	sortable: true
},
{
	header: "源科室名称",
	dataIndex: 'srDeptName',
	width: 150,
	align: 'left',
	sortable: true
}
]);
var inDataCardRuleSearchField = '';
var inDataCardRuleFilterItem = "";
	if(selectedCode==RULEONE){
		inDataCardRuleSearchField="srDeptName";
		inDataCardRuleFilterItem=new Ext.Toolbar.MenuButton({
			text: '过滤器',
			tooltip: '关键字所属类别',
			menu: {items: [
				new Ext.menu.CheckItem({ text: '源科室代码',value: 'srDeptCode',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '源科室名称',value: 'srDeptName',checked: true,group: 'busdingFilter',checkHandler: onBusdingItemCheck })
			]}
		});
	}else if(selectedCode==RULETWO){
		inDataCardRuleSearchField="deDeptName";
		inDataCardRuleFilterItem=new Ext.Toolbar.MenuButton({
			text: '过滤器',
			tooltip: '关键字所属类别',
			menu: {items: [
				new Ext.menu.CheckItem({ text: '业务项代码',value: 'itemCode',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '业务项名称',value: 'itemName',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '目标科室代码',value: 'deDeptCode',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '目标科室名称',value: 'deDeptName',checked: true,group: 'busdingFilter',checkHandler: onBusdingItemCheck })
			]}
		});
	}else{
		inDataCardRuleSearchField="srDeptName";
		inDataCardRuleFilterItem=new Ext.Toolbar.MenuButton({
			text: '过滤器',
			tooltip: '关键字所属类别',
			menu: {items: [
				new Ext.menu.CheckItem({ text: '业务项代码',value: 'itemCode',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '业务项名称',value: 'itemName',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '源科室代码',value: 'srDeptCode',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '源科室名称',value: 'srDeptName',checked: true,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '目标科室代码',value: 'deDeptCode',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
				new Ext.menu.CheckItem({ text: '目标科室名称',value: 'deDeptName',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck })
			]}
		});
	}



function onBusdingItemCheck(item, checked)
{
	if(checked) {
		inDataCardRuleSearchField = item.value;
		inDataCardRuleFilterItem.setText(item.text + ':');
	}
};

var inDataCardRuleSearchBox = new Ext.form.TwinTriggerField({//查找按钮
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {fn:function(field, e) {
			var key = e.getKey();
		if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				inDataCardRuleDs.proxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=listCardRule'});
				inDataCardRuleDs.load({params:{start:0, limit:inDataCardRulePagingToolbar.pageSize,parRef:inDataCardingId}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				inDataCardRuleDs.proxy = new Ext.data.HttpProxy({
				url: busdingUrl + '?action=listCardRule&searchField=' + inDataCardRuleSearchField + '&searchValue=' + this.getValue()});
				inDataCardRuleDs.load({params:{start:0, limit:inDataCardRulePagingToolbar.pageSize,parRef:inDataCardingId}});
			}
		}
	});

	var inDataCardRulePagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 10,
		store: inDataCardRuleDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		//buttons: [, '-', inDataCardRuleSearchBox],
		doLoad:function(C){
			var tmpRow = inDataCardingPanel.getSelections();
			var tmpSRowid=tmpRow[0].get("rowid");	
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['parRef']=tmpSRowid;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});

	inDataCardRulePagingToolbar.on({
		render:function(){
		inDataCardRulePagingToolbar.add(inDataCardRuleFilterItem);
		inDataCardRulePagingToolbar.add('-', inDataCardRuleSearchBox);
		}
	});
	var menubar = [
    		{
				text: '添加',
        		tooltip:'添加收入梳理规则',
				id:'locadd',
        		iconCls:'add',
				//disabled:true,
		        handler: function(){                     
		        	inDataCardRuleAddFun(inDataCardRuleDs, inDataCardingPanel ,inDataCardRulePagingToolbar);        
		        }
        },'-',
		{
		        text:'删除',
		        tooltip:'删除选定的收入梳理规则',
		        iconCls:'remove',
				//disabled:true,
				id:'locdel',
		        handler: function(){            
	    				var selectedRow = inDataCardRuleGrid.getSelections();				
    					if (selectedRow.length < 1){
     						Ext.MessageBox.show({title: '提示',msg: '请选择一个数据！',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
    						return false;
    					}  
						var tmpRowid=selectedRow[0].get("rowid");						
						Ext.MessageBox.confirm('提示', 
							'确定要删除选中的数据?', 
							function(btn) {
								if(btn == 'yes')
								{		
									var tmpRow = inDataCardingPanel.getSelections();
									var tmpSRowid=tmpRow[0].get("rowid");	
									Ext.Ajax.request({
										url:busdingUrl+'?action=delCardRule&id='+tmpRowid,
										waitMsg:'删除中...',
										failure: function(result, request) {
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {		
												message='删除成功!';
												Ext.Msg.show({title:'注意', msg:message, icon:Ext.MessageBox.INFO, buttons:Ext.Msg.OK});
												inDataCardRuleDs.load({params:{start:0, limit:inDataCardRulePagingToolbar.pageSize,parRef:tmpSRowid}});
											}else{		
												Ext.Msg.show({
													title:'错误',
													msg:jsonData.info,
													buttons: Ext.Msg.OK,
													icon:Ext.MessageBox.ERROR
												});
													
											}
										},
										scope: this
									});	
									
								}
							} 
						);
		        }
        }];
	var inDataCardRuleGrid = new Ext.grid.GridPanel({//表格
		title: '收入梳理规则',
		region: 'center',
		//width: 200,
		height:300,
		split: true,
		collapsible: true,
		maskDisabled:false,
		containerScroll: true,
		xtype: 'grid',
		store: inDataCardRuleDs,
		cm: oneCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		//tbar: menubar,
		bbar: inDataCardRulePagingToolbar
	});
	//inDataCardRuleDs.load({params:{start:0, limit:inDataCardRulePagingToolbar.pageSize}});

	var inDataCardRuleRowId = "";
	var inDataCardRuleName = "";

	

