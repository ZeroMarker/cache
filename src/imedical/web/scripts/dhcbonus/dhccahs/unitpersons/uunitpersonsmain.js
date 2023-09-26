var UnitPersonsUrl = 'dhc.ca.unitpersonsexe.csp';
var UnitPersonsProxy = new Ext.data.HttpProxy({url: UnitPersonsUrl + '?action=list'});
var type="";
function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};

var UnitPersonsDs = new Ext.data.Store({
	proxy: UnitPersonsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'shortcut',
			'gender',
			'national',
			'birthPlace',
			'education',
			'title',
			'duty',
			'state',
			'preparation',
			'phone',
			'remark',
			{name:'birthday',type:'date',dateFormat:'Y-m-d'},
			{name:'start',type:'date',dateFormat:'Y-m-d'},
			{name:'stop',type:'date',dateFormat:'Y-m-d'},
			'unitDr',
			'unitName',
			'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

UnitPersonsDs.setDefaultSort('rowid', 'DESC');

var UnitPersonsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '代码',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
	{
        header: '名称',
        dataIndex: 'name',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '性别',
        dataIndex: 'gender',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
		header: "出生日期",
		dataIndex: 'birthday',
		renderer:formatDate,
		align: 'left',
		width: 90,
		sortable: true
	},
	{
        header: '民族',
        dataIndex: 'national',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '籍贯',
        dataIndex: 'birthPlace',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '学历',
        dataIndex: 'education',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '职称',
        dataIndex: 'title',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '职务',
        dataIndex: 'duty',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '状态',
        dataIndex: 'state',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '编制',
        dataIndex: 'preparation',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '电话',
        dataIndex: 'phone',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '备注',
        dataIndex: 'remark',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
		header: "入职日期",
		dataIndex: 'start',
		renderer:formatDate,
		align: 'left',
		width: 90,
		sortable: true
	},
	{
		header: "离职日期",
		dataIndex: 'stop',
		renderer:formatDate,
		align: 'left',
		width: 90,
		sortable: true
	},
	{
        header: '有效标志',
        dataIndex: 'active',
        width: 60,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    		}
    }
]);

var addUnitPersonsButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的单位人员',        
		iconCls: 'add',
		handler: function(){addFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});

var editUnitPersonsButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的单位人员',
		iconCls: 'remove',
		handler: function(){editFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});

var delUnitPersonsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的单位人员',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});
var deptPersonsButton  = new Ext.Toolbar.Button({
		text: '维护人员部门',        
		tooltip: '维护选定单位人员的部门',
		iconCls: 'remove',
		handler: function(){CommFindFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});
var personsFindButton  = new Ext.Toolbar.Button({
		text: '查看部门人员',        
		tooltip: '查看部门人员',
		iconCls: 'remove',
		handler: function(){personFindFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});
var personsButton  = new Ext.Toolbar.Button({
		text: '查看没有部门的人员',        
		tooltip: '查看没有部门的人员',
		iconCls: 'remove',
		handler: function(){
			var unitDr=units.getValue();
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单元后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			type=0;
			UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:units.getValue(),type:type}});
		}
});


		
var unitTypeDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
});
var unitType = new Ext.form.ComboBox({
	id: 'unitType',
	fieldLabel: '单元类别',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: unitTypeDs,
	valueField: 'rowId',
	displayField: 'shortcut',
	triggerAction: 'all',
	emptyText:'选择单元类别...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
unitTypeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'GET'});
});

var unitsDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
});
var units = new Ext.form.ComboBox({
	id: 'units',
	fieldLabel: '单元',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: unitsDs,
	valueField: 'rowId',
	displayField: 'shortcut',
	triggerAction: 'all',
	emptyText:'选择单元...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

unitsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'GET'});
});

var UnitPersonsSearchField = 'name';

var UnitPersonsFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '性别',value: 'gender',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '出生日期',value: 'birthday',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '民族',value: 'national',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '籍贯',value: 'birthPlace',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '学历',value: 'education',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '职称',value: 'title',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '职务',value: 'duty',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '状态',value: 'state',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '编制',value: 'preparation',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '电话',value: 'phone',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '入职时间',value: 'startDate',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '离职时间',value: 'endDate',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '有效',value: 'active',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck })
		]}
});

function onUnitPersonsItemCheck(item, checked)
{
		if(checked) {
				UnitPersonsSearchField = item.value;
				UnitPersonsFilterItem.setText(item.text + ':');
		}
};

var UnitPersonsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				var unitDr=units.getValue();
				if(unitDr==""){
					Ext.Msg.show({title:'注意',msg:'请选择单元后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				this.setValue('');    
				UnitPersonsDs.proxy = new Ext.data.HttpProxy({url: UnitPersonsUrl + '?action=list'});
				UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:unitDr,type:type}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				var unitDr=units.getValue();
				if(unitDr==""){
					Ext.Msg.show({title:'注意',msg:'请选择单元后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				UnitPersonsDs.proxy = new Ext.data.HttpProxy({
				url: UnitPersonsUrl + '?action=list&searchField=' + UnitPersonsSearchField + '&searchValue=' + this.getValue()});
				UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:unitDr,type:type}});
	    	}
		}
});

var UnitPersonsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: UnitPersonsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',UnitPersonsFilterItem,'-',UnitPersonsSearchBox],
		doLoad:function(C){
					var B={},
					A=this.paramNames;
					B[A.start]=C;
					B[A.limit]=this.pageSize;
					B['id']=units.getValue();
					B['type']=type;
					if(this.fireEvent("beforechange",this,B)!==false){
						this.store.load({params:B});
					}
				}
});

var UnitPersonsMain = new Ext.grid.GridPanel({//表格
		title: '单位人员',
		store: UnitPersonsDs,
		cm: UnitPersonsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['单元类别:',unitType,'-','单元:',units,'-',deptPersonsButton,'-',personsFindButton,'-',personsButton],
		bbar: UnitPersonsPagingToolbar
});
unitType.on("select",function(cmb,rec,id ){
		units.setRawValue("");
		units.setValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	
});
units.on("select",function(cmb,rec,id ){
		type="";
		UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:cmb.getValue(),type:type}});
});
