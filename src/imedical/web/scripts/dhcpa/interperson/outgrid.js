var outUrl = '../csp/dhc.pa.interpersonexe.csp';
var outProxy;

//外部指标
var outDs = new Ext.data.Store({
	proxy: outProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'userDr',
		'code',
		'name',
		'inLocSetDr',
		'LocSetName',
		'remark',
		'active'
	]),
	remoteSort: true
});

outDs.setDefaultSort('rowid', 'asc');
var outCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '接口人员代码',
		dataIndex: 'code',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "接口人员名称",
		dataIndex: 'name',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "所属接口套",
		dataIndex: 'LocSetName',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "备注",
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
	text: '添加接口人员',
    tooltip:'添加接口人员',        
    iconCls:'add',
	handler:function(){
		var rowObj = InGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择内部人员记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var userDr=rowObj[0].get("userDr");
			addFun(userDr,outDs,outPagingToolbar);
		}
	}
});

//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改接口人员',
    tooltip:'修改接口人员',        
    iconCls:'add',
	handler:function(){
		var rowObj = InGrid.getSelections();
		var len = rowObj.length;
		var userDr=0;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择内部人员记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			userDr=rowObj[0].get("userDr");
		}
		
		editFun(userDr,outDs,OutGrid,outPagingToolbar);
	}
});

//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除接口人员',
    tooltip:'删除接口人员',        
    iconCls:'remove',
	handler:function(){
		var rowObj = InGrid.getSelections();
		var len = rowObj.length;
		var userDr=0;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择内部人员记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			userDr=rowObj[0].get("userDr");
		}
		
		var rowObj = OutGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的接口人员记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.interpersonexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									outDs.load({params:{start:outPagingToolbar.cursor,limit:outPagingToolbar.pageSize,inDr:userDr,sort:"rowid",dir:"asc"}});
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

var outSearchField = 'name';

var outFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'outFilter',checkHandler: onCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'outFilter',checkHandler: onCheck }),
		new Ext.menu.CheckItem({ text: '接口套',value: 'LocSetName',checked: false,group: 'outFilter',checkHandler: onCheck })
	]}
});
function onCheck(item, checked)
{
	if(checked) {
		outSearchField = item.value;
		outFilterItem.setText(item.text + ':');
	}
};

var outSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				outDs.proxy = new Ext.data.HttpProxy({url:outUrl+'?action=outlist&inDr='+InGrid.getSelections()[0].get("userDr")+'&sort=rowid&dir=asc'});
				outDs.load({params:{start:0, limit:outPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outDs.proxy = new Ext.data.HttpProxy({
				url: outUrl+'?action=outlist&inDr='+InGrid.getSelections()[0].get("userDr")+'&searchField='+outSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=asc'});
				outDs.load({params:{start:0, limit:outPagingToolbar.pageSize}});
			}
		}
	});
	var outPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store:outDs,
		displayInfo:true,
		displayMsg:'当前显示{0} - {1}，共计{2}',
		emptyMsg:"没有数据",
		buttons:[outFilterItem,'-',outSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['inDr']=InGrid.getSelections()[0].get("userDr");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var OutGrid = new Ext.grid.GridPanel({//表格
		title: '接口人员信息',
		region: 'center',
		xtype: 'grid',
		store: outDs,
		cm: outCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: outPagingToolbar
	});