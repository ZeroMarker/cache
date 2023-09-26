var personUrl = '../csp/dhc.qm.uDeptProjectexe.csp';
var personProxy;

//外部指标
var personDs = new Ext.data.Store({
	proxy: personProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'RowId',
		'Code',
		'name',
		'deptCode'
	]),
	remoteSort: true
});

personDs.setDefaultSort('deptCode', 'name');
var personCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '科室ID',
		dataIndex: 'RowId',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},{
		header: "科室代码",
		dataIndex: 'deptCode',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "科室名称",
		dataIndex: 'name',
		width: 120,
		align: 'left',
		sortable: true
	}
]);


//添加按钮



	
var addButton = new Ext.Toolbar.Button({
		text: '添加科室',
		tooltip: '添加',
		iconCls: 'add',
		handler: function(){addSchemFun(personDs,personGrid,personPagingToolbar, RowId );
		}
});


//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){
		var rowObj = personGrid.getSelections();
		var len = rowObj.length;
		var jxUnitDr=0;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择科室项目记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			jxUnitDr=rowObj[0].get("RowId");
		}
		
		var rowObj = personGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的科室记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.qm.uDeptProjectexe.csp?action=del&RowId='+rowObj[0].get("RowId"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:personPagingToolbar.cursor,limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,sort:"RowId",dir:"asc"}});
								}else{
									Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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

var CalUnitSearchField = 'name';

var CalUnitFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'Code',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck }),
		]}
});

function onCalUnitItemCheck(item, checked)
{
		if(checked) {
				CalUnitSearchField = item.value;
				CalUnitFilterItem.setText(item.text + ':');
		}
};


var personSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=list2&Code='+itemGrid.getSelections()[0].get("Rowid")});
				personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				personDs.proxy = new Ext.data.HttpProxy({
				url: personUrl+'?action=list2&Code='+itemGrid.getSelections()[0].get("Rowid")+'&searchField=' + CalUnitSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				personDs.load({params:{start:0,limit:personPagingToolbar.pageSize}});
			}
		}
	});
	var personPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store:personDs,
		displayInfo:true,
		displayMsg:'当前显示{0} - {1}，共计{2}',
		emptyMsg:"没有数据",
		buttons:['-',CalUnitFilterItem,'-',personSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['jxUnitDr']=itemGrid.getSelections()[0].get("RowId");
			B['dir']="asc";
			B['sort']="RowId";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	/*var personPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: personDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});*/
	var personGrid = new Ext.grid.GridPanel({//表格
		
		region: 'center',
		xtype: 'grid',
		store: personDs,
		cm: personCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',delButton],
		bbar: personPagingToolbar
	});