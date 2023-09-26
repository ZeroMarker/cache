var personUrl = 'dhc.pa.jxinpersonexe.csp';
var personProxy;

//外部指标
var personDs = new Ext.data.Store({
	proxy: personProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'jxUnitDr',
		'rowid',
		'userDr',
		'userCode',
		'userName',
		'remark',
		'active'
	]),
	remoteSort: true
});

personDs.setDefaultSort('rowid', 'asc');
var personCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '人员代码',
		dataIndex: 'userCode',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "人员名称",
		dataIndex: 'userName',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "人员备注",
		dataIndex: 'remark',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "有效标志",
		dataIndex: 'active',
		width: 80,
		align: 'center',
		sortable: true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);


//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加内部人员',
    tooltip:'添加内部人员',        
    iconCls:'add',
	handler:function(){
		var rowObj = JXUnitGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择绩效单元记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var jxUnitDr=rowObj[0].get("rowid");
			addFun(jxUnitDr,personDs,personGrid,personPagingToolbar);
		}
	}
});

//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改内部人员',
    tooltip:'修改内部人员',        
    iconCls:'add',
	handler:function(){
		var rowObj = JXUnitGrid.getSelections();
		var len = rowObj.length;
		var jxUnitDr=0;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择绩效单元记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			jxUnitDr=rowObj[0].get("rowid");
		}
		
		editFun(jxUnitDr,personDs,personGrid,personPagingToolbar);
	}
});

//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除内部人员',
    tooltip:'删除内部人员',        
    iconCls:'remove',
	handler:function(){
		var rowObj = JXUnitGrid.getSelections();
		var len = rowObj.length;
		var jxUnitDr=0;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择绩效单元记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			jxUnitDr=rowObj[0].get("rowid");
		}
		
		var rowObj = personGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的内部人员记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxinpersonexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:personPagingToolbar.cursor,limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,sort:"rowid",dir:"asc"}});
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

var personSearchField = 'userName';

var personFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'userCode',checked: false,group: 'personFilter',checkHandler: onCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'userName',checked: true,group: 'personFilter',checkHandler: onCheck })
	]}
});
function onCheck(item, checked)
{
	if(checked) {
		personSearchField = item.value;
		personFilterItem.setText(item.text + ':');
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
				personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=personlist&jxUnitDr='+JXUnitGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=asc'});
				personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				personDs.proxy = new Ext.data.HttpProxy({
				url: personUrl+'?action=personlist&jxUnitDr='+JXUnitGrid.getSelections()[0].get("rowid")+'&searchField='+personSearchField+'&searchValue='+this.getValue()+'&sort=rowid&dir=asc'});
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
		buttons:[personFilterItem,'-',personSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['jxUnitDr']=JXUnitGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var personGrid = new Ext.grid.GridPanel({//表格
		title: '内部人员信息',
		region: 'center',
		xtype: 'grid',
		store: personDs,
		cm: personCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: personPagingToolbar
	});