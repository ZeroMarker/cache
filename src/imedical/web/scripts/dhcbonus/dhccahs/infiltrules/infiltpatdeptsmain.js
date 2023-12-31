var inFiltPatDeptsUrl = 'dhc.ca.infiltrulesexe.csp';
var inFiltPatDeptsProxy = new Ext.data.HttpProxy({url: inFiltPatDeptsUrl + '?action=listpatdept'});

//特殊数据单元数据源
var inFiltPatDeptsDs = new Ext.data.Store({
	proxy: inFiltPatDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'deptDr',
	'deptCode',
	'deptName'
	]),
	// turn on remote sorting
	remoteSort: true
});

inFiltPatDeptsDs.setDefaultSort('rowid', 'Desc');

var inFiltPatDeptsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '部门代码',
	dataIndex: 'deptCode',
	width: 80,
	sortable: true
},
{
	header: "部门名称",
	dataIndex: 'deptName',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var inFiltPatDeptsSearchField = 'Name';

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
		inFiltPatDeptsSearchField = item.value;
		busdingFilterItem.setText(item.text + ':');
	}
};

var inFiltPatDeptsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				inFiltPatDeptsDs.proxy = new Ext.data.HttpProxy({url: inFiltPatDeptsUrl + '?action=list&active=Y'});
				inFiltPatDeptsDs.load({params:{start:0, limit:inFiltPatDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				inFiltPatDeptsDs.proxy = new Ext.data.HttpProxy({
				url: inFiltPatDeptsUrl + '?action=list&activey&searchfield=' + inFiltPatDeptsSearchField + '&searchvalue=' + this.getValue()});
				inFiltPatDeptsDs.load({params:{start:0, limit:inFiltPatDeptsPagingToolbar.pageSize}});
			}
		}
	});

	var inFiltPatDeptsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 10,
		store: inFiltPatDeptsDs,
		//displayInfo: true,
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
        		tooltip:'添加部门',
				id:'locadd',
        		iconCls:'add',
				//disabled:true,
		        handler: function(){                     
		        	inFiltPatDeptsAddFun(inFiltPatDeptsDs, specialParamPanel ,inFiltPatDeptsPagingToolbar);        
		        }
        },'-',
		{
		        text:'删除',
		        tooltip:'删除选定的部门',
		        iconCls:'remove',
				//disabled:true,
				id:'locdel',
		        handler: function(){            
	    				var selectedRow = inFiltPatDeptsGrid.getSelections();				
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
										url:'dhc.ca.infiltrulesexe.csp?action=delpatdept&id='+tmpRowid,
										waitMsg:'删除中...',
										failure: function(result, request) {
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {		
												message='删除成功!';
												Ext.Msg.show({title:'注意', msg:message, icon:Ext.MessageBox.INFO, buttons:Ext.Msg.OK});
												inFiltPatDeptsDs.load({params:{start:0, limit:inFiltPatDeptsPagingToolbar.pageSize,parRef:inFiltRulesId}});
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
	var inFiltPatDeptsGrid = new Ext.grid.GridPanel({//表格
		title: '过滤病人科室',
		region: 'center',
		//width: 200,
		height:300,
		split: true,
		collapsible: true,
		maskDisabled:false,
		containerScroll: true,
		xtype: 'grid',
		store: inFiltPatDeptsDs,
		cm: inFiltPatDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: menubar,
		bbar: inFiltPatDeptsPagingToolbar
	});
	//inFiltPatDeptsDs.load({params:{start:0, limit:inFiltPatDeptsPagingToolbar.pageSize}});

	var inFiltPatDeptsRowId = "";
	var inFiltPatDeptsName = "";


	

