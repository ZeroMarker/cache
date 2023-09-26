var mainUrl = 'dhc.ca.ritemsexe.csp';

var roleDs = new Ext.data.Store({
	autoLoad: true,
	proxy: '',
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
});

roleDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.rolesexe.csp?action=list&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('roleSelecter').getRawValue(), method:'GET'});
	}
);

var roleSelecter = new Ext.form.ComboBox({
	id:'roleSelecter',
	fieldLabel:'角色名称',
	store: roleDs,
	valueField:'rowId',
	displayField:'shortcut',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	width:150,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择角色...',
	allowBlank: false,
	selectOnFocus: true,
	forceSelection: true
});

roleSelecter.on(
	"select",
	function(cmb,rec,id ){
		mainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+cmb.getValue()});
		mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});
	}
);

var mainDs = new Ext.data.Store({
		proxy: '',
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
            'order',
						'itemDr',
						'itemCode',
						'itemName'
		]),
    remoteSort: true
});

mainDs.setDefaultSort('order', 'Asc');

var mainCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '项目顺序',
        dataIndex: 'order',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "项目代码",
        dataIndex: 'itemCode',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "项目名称",
        dataIndex: 'itemName',
        width: 200,
        align: 'left',
        sortable: true
    }
]);

var mainAddButton = new Ext.Toolbar.Button({
		text: '添加',
    tooltip:'添加新部门信息',        
    iconCls:'add',
		handler: function(){
			if(roleSelecter.getValue()==""){
				Ext.Msg.show({title:'注意',msg:'请先选择角色信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				addFun(mainDs,mainPanel,mainPagingToolbar);
			}
		}
});

var mainEditButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的部门信息',
		iconCls:'remove',        
		handler: function(){
			if(roleSelecter.getValue()==""){
				Ext.Msg.show({title:'注意',msg:'请先选择角色信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				editFun(mainDs,mainPanel,mainPagingToolbar);
			}
		}
});

var mainDelButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的部门',
		iconCls: 'remove',
		handler: function(){
			if(roleSelecter.getValue()==""){
				Ext.Msg.show({title:'注意',msg:'请先选择角色信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				delFun(mainDs,mainPanel,mainPagingToolbar);
			}
		}
});

var mainSearchField = 'itemName';

var mainFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '项目顺序',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '项目代码',value: 'itemCode',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '项目名称',value: 'itemName',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
		]}
});

function onMainItemCheck(item, checked)
{
		if(checked) {
				mainSearchField = item.value;
				mainFilterItem.setText(item.text + ':');
		}
};

var unitsSearchBox = new Ext.form.TwinTriggerField({
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
							mainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+roleSelecter.getValue()});
							mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						mainDs.proxy = new Ext.data.HttpProxy({
						url: mainUrl + '?action=list&parRef='+roleSelecter.getValue()+'&searchField=' + mainSearchField + '&searchValue=' + this.getValue()});
	        	mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});
	    	}
		}
});

var mainPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
    store: mainDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
		buttons: [mainFilterItem,'-',unitsSearchBox]
});

var mainPanel = new Ext.grid.GridPanel({
		title: '可用项目表',
		store: mainDs,
		cm: mainCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['选择角色：',roleSelecter,'-',mainAddButton,'-',mainEditButton,'-',mainDelButton],
		bbar: mainPagingToolbar
});

mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});