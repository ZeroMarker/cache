var inFiltfDeptsUrl = 'dhc.ca.indistrulesexe.csp';
var inFiltfDeptsProxy = new Ext.data.HttpProxy({url: inFiltfDeptsUrl + '?action=listdept'});

//特殊数据单元数据源
var inFiltfDeptsDs = new Ext.data.Store({
	proxy: inFiltfDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'deptDr',
	'deptName',
	'percent'
	]),
	// turn on remote sorting
	remoteSort: true
});

inFiltfDeptsDs.setDefaultSort('rowid', 'Desc');

var inFiltfDeptsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '部门名称',
	dataIndex: 'deptName',
	width: 80,
	sortable: true
},
{
	header: "比率",
	dataIndex: 'percent',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var inFiltfDeptsSearchField = 'Name';

var busdingFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'Code',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'Name',checked: true,group: 'busdingFilter',checkHandler: onBusdingItemCheck })
	]}
});

function onBusdingItemCheck(item, checked)
{
	if(checked) {
		inFiltfDeptsSearchField = item.value;
		busdingFilterItem.setText(item.text + ':');
	}
};

var inFiltfDeptsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				inFiltfDeptsDs.proxy = new Ext.data.HttpProxy({url: inFiltfDeptsUrl + '?action=list&active=Y'});
				inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				inFiltfDeptsDs.proxy = new Ext.data.HttpProxy({
				url: inFiltfDeptsUrl + '?action=list&activey&searchfield=' + inFiltfDeptsSearchField + '&searchvalue=' + this.getValue()});
				inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize}});
			}
		}
	});

	var inFiltfDeptsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 10,
		store: inFiltfDeptsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		doLoad:function(C){
			var tmpRow = specialParamPanel.getSelections();
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
	var menubar = [
    		{
				text: '添加',
        		tooltip:'添加科室分配规则',
				id:'locadd',
        		iconCls:'add',
				//disabled:true,
		        handler: function(){                     
		        	inFiltfDeptsAddFun(inFiltfDeptsDs, specialParamPanel ,inFiltfDeptsPagingToolbar);        
		        }
        },'-',
		{
		        text:'删除',
		        tooltip:'删除选定的科室分配规则',
		        iconCls:'remove',
				//disabled:true,
				id:'locdel',
		        handler: function(){            
	    				var selectedRow = inFiltfDeptsGrid.getSelections();				
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
									var tmpRow = specialParamPanel.getSelections();
									var tmpSRowid=tmpRow[0].get("rowid");	
									Ext.Ajax.request({
										url:'dhc.ca.indistrulesexe.csp?action=deldept&id='+tmpRowid,
										waitMsg:'删除中...',
										failure: function(result, request) {
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {		
												message='删除成功!';
												Ext.Msg.show({title:'注意', msg:message, icon:Ext.MessageBox.INFO, buttons:Ext.Msg.OK});
												inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize,parRef:inFiltRulesId}});
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
	var inFiltfDeptsGrid = new Ext.grid.GridPanel({//表格
		title: '科室分配规则',
		region: 'center',
		//width: 200,
		height:300,
		split: true,
		collapsible: true,
		maskDisabled:false,
		containerScroll: true,
		xtype: 'grid',
		store: inFiltfDeptsDs,
		cm: inFiltfDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: menubar,
		bbar: inFiltfDeptsPagingToolbar
	});
	//inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize}});

	var inFiltfDeptsRowId = "";
	var inFiltfDeptsName = "";


	

