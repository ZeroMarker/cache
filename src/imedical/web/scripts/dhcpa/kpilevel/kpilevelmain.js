var KPILvelUrl = 'dhc.pa.kpilevelexe.csp';
var KPILvelProxy = new Ext.data.HttpProxy({url:KPILvelUrl+'?action=list'});


var KPILvelDs = new Ext.data.Store({
	proxy: KPILvelProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'KpiDr',
			'KPIName',
			'levelDr',
			'LevelName',
			'levelScore'
 
		]),
    remoteSort: true
});

KPILvelDs.setDefaultSort('rowid', 'DESC');


var addKPILvelButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的对照',
		iconCls: 'add',
		handler: function(){addKPILvelFun(KPILvelDs,KPILvelMain,KPILvelPagingToolbar);}
});

var editKPILvelButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的对照',
		iconCls: 'remove',
		handler: function(){editKPILvelFun(KPILvelDs,KPILvelMain,KPILvelPagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = KPILvelMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:KPILvelUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
								}else{
									var message="删除错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});
var KPILvelCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '指标名称',
			dataIndex: 'KPIName',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: '等级名称',
			dataIndex: 'LevelName',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: '分数',
			dataIndex: 'levelScore',
			width: 100,
			align: 'left',
			sortable: true
		}
	]);
	
var KPILvelSearchField = 'Name';

var KPILvelFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '等级名称',value: 'KPIName',checked: false,group: 'KPILvelFilter',checkHandler: onKPILvelItemCheck }),
				new Ext.menu.CheckItem({ text: '指标名称',value: 'LevelName',checked: false,group: 'KPILvelFilter',checkHandler: onKPILvelItemCheck }),
				new Ext.menu.CheckItem({ text: '分数',value: 'levelScore',checked: false,group: 'KPILvelFilter',checkHandler: onKPILvelItemCheck })
		]}
});

function onKPILvelItemCheck(item, checked)
{
		if(checked) {
				KPILvelSearchField = item.value;
				KPILvelFilterItem.setText(item.text + ':');
		}
};

var KPILvelSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				KPILvelDs.proxy = new Ext.data.HttpProxy({url: KPILvelUrl + '?action=list'});
				KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KPILvelDs.proxy = new Ext.data.HttpProxy({
				url: KPILvelUrl + '?action=list&searchField=' + KPILvelSearchField + '&searchValue=' + this.getValue()});
				KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
	    	}
		}
});
KPILvelDs.each(function(record){
    alert(record.get('tieOff'));

});
var KPILvelPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: KPILvelDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',KPILvelFilterItem,'-',KPILvelSearchBox]
});

var KPILvelMain = new Ext.grid.EditorGridPanel({//表格
		title: '等级与指标对照',
		store: KPILvelDs,
		cm: KPILvelCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addKPILvelButton,'-',delButton],
		bbar: KPILvelPagingToolbar
});


KPILvelMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});


KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
