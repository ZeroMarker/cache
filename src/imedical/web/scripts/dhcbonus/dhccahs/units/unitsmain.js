var unitsUrl = 'dhc.ca.unitsexe.csp';



//var unitTypeProxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes'});
//var unitTypeProxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});

unitTypeDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
	}
);
/*		
var assLocDs = new Ext.data.Store({
autoLoad: true,
proxy: "",
reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['Loc_Name','Loc_Rowid','Loc_Desc','Loc_Code'])
});
assLocDs.on('beforeload', function(ds, o){
ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhccacommtab.csp?action=loclist&recname='+Ext.getCmp('assLoc').getRawValue(),method:'GET'});
});
var assLoc = new Ext.form.ComboBox({
id: 'assLoc',
fieldLabel: '承担科室',
width:150,
listWidth : 260,
allowBlank: false,
store: assLocDs,
valueField: 'Loc_Code',
displayField: 'Loc_Desc',
triggerAction: 'all',
emptyText:'选择承担科室...',
pageSize: 10,
minChars: 1,
value:Ext.getCmp('assLocCode').getValue(),
selectOnFocus: true,
forceSelection: true
});
*/
//定义选择UnitType的ComboBox//fucking piece of shit
var unitTypeSelecter = new Ext.form.ComboBox({
				id:'unitTypeSelecter',
			  fieldLabel:'名称',
			  store: unitTypeDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择...',
	      allowBlank: false,
			  name:'unitTypeSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

//unitTypeSelecter.on("beforequery",function(o){o.query = 'query';});

unitTypeSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
	}
);


var unitTypeRowid = "";

function searchFun(unitTypeDr)
{
		unitTypeRowid = unitTypeDr;
		unitsDs.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=list&unitTypeDr='+unitTypeDr});
		unitsDs.load({params:{start:0, limit:unitsPagingToolbar.pageSize}});
};

var unitsDs = new Ext.data.Store({
		proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
						'code',
						'name',
						'shortcut',
						'address',
						'phone',
						'contact',
						'remark',
						'unitTypeDr',
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

unitsDs.setDefaultSort('rowId', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '代码',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
        header: "名称",
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
    	 	{
        header: "地址",
        dataIndex: 'address',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "电话",
        dataIndex: 'phone',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "联系人",
        dataIndex: 'contact',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "备注",
        dataIndex: 'remark',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "有效",
        dataIndex: 'active',
        width: 50,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
    }
]);

//StatuTabCm.defaultSortable = true;

var addUnitsButton = new Ext.Toolbar.Button({
		text: '添加',
    tooltip:'添加新单位信息',        
    iconCls:'add',
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位类别再添加单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(unitsDs,unitsMain,unitsPagingToolbar,unitTypeRowid);
			}
		}
});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的单位信息',
		iconCls:'remove',        
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位类别再修改单位信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(unitsDs,unitsMain,unitsPagingToolbar);
			}
		}
});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的单位',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(unitsDs,unitsMain,unitsPagingToolbar);}
});

var unitsSearchField = 'name';

var unitsFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '地址',value: 'address',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '电话',value: 'phone',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '联系人',value: 'contact',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '有效',value: 'active',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck })
		]}
});

function onUnitsItemCheck(item, checked)
{
		if(checked) {
				unitsSearchField = item.value;
				unitsFilterItem.setText(item.text + ':');
		}
};

var unitsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
							unitsDs.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=list&unitTypeDr='+unitTypeRowid});
							unitsDs.load({params:{start:0, limit:unitsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						unitsDs.proxy = new Ext.data.HttpProxy({
						url: unitsUrl + '?action=list&unitTypeDr='+unitTypeRowid+'&searchField=' + unitsSearchField + '&searchValue=' + this.getValue()});
	        	unitsDs.load({params:{start:0, limit:unitsPagingToolbar.pageSize}});
	    	}
		}
});

var unitsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
    store: unitsDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
		buttons: [unitsFilterItem,'-',unitsSearchBox]
});

var unitsMain = new Ext.grid.GridPanel({//表格
		title: '单位码表',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['单位类别：',unitTypeSelecter,'-',addUnitsButton,'-',editUnitsButton,'-',delUnitsButton],
		bbar: unitsPagingToolbar
});