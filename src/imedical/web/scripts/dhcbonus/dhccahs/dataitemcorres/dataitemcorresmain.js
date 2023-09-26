var dataItemCorresUrl = 'dhc.ca.dataitemcorresexe.csp';

var dataTypeDr="";
var dataItemCorresProxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=list'});

var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
});

unitTypeDs.on('beforeload',function(ds, o){
	ds.proxy = new Ext.data.HttpProxy({url:dataItemCorresUrl+'?action=listtype&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
});

var unitTypeSelecter = new Ext.form.ComboBox({
	id:'unitTypeSelecter',
	fieldLabel:'名称',
	store: unitTypeDs,
	valueField:'rowid',
	displayField:'shortcut',
	//typeAhead:true,
	pageSize:10,
	minChars:1,
	width:100,
	listWidth:260,
	triggerAction:'all',
	emptyText:'选择数据项类别...',
	allowBlank: false,
	name:'unitTypeSelecter',
	selectOnFocus: true,
	forceSelection: true 
});



function formatDate(value){
    return value ? value.dateFormat('Y-m-d') : '';
};
    
//数据项对应数据源
var dataItemCorresDs = new Ext.data.Store({
		proxy: dataItemCorresProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'typeDr',
			'typeName',
			'typeShortCut',
			'order',
			'itemDr',
			'itemCode',
			'itemName',
			'itemShortCut',
			'itemUnit'
		]),
    // turn on remote sorting
    remoteSort: true
});

dataItemCorresDs.setDefaultSort('Rowid', 'Desc');

var dataItemCorresCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
        header: "序号",
        dataIndex: 'order',
        width: 50,
        align: 'left',
        sortable: true
    },
    {
        header: "数据项代码",
        dataIndex: 'itemCode',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: "数据项名称",
        dataIndex: 'itemName',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "数据项单位",
        dataIndex: 'itemUnit',
        width: 200,
        align: 'left',
        sortable: true
    }
	
]);

//StatuTabCm.defaultSortable = true;

var addLocButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip:'添加新数据项对应信息',        
		iconCls:'add',
		handler: function(){
			if(dataTypeDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据项类别在添加数据项对应!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(dataItemCorresDs,dataItemCorresMain,dataItemCorresPagingToolbar,dataTypeDr);
			}
		}
});

var editLocButton  = new Ext.Toolbar.Button({
		text:'修改序号',        
		tooltip:'修改选定的数据项对应信息',
		iconCls:'remove',        
		handler: function(){
			if(dataTypeDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据项类别在修改数据项对应信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(dataItemCorresDs,dataItemCorresMain,dataItemCorresPagingToolbar);
			}
		}
});

var delLocButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的数据项对应',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			if(dataTypeDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据项类别在删除数据项对应信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				delFun(dataItemCorresDs,dataItemCorresMain,dataItemCorresPagingToolbar);
			}
		}
});

var dataItemCorresSearchField = 'itemName';
var searchField="";
var dataItemCorresFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '序号',value: 'order',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '数据项名称',value: 'itemName',checked: true,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '数据项单元',value: 'itemUnit',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck })
		]}
});

function onLocItemCheck(item, checked)
{
		if(checked) {
				dataItemCorresSearchField = item.value;
				dataItemCorresFilterItem.setText(item.text + ':');
		}
};

var dataItemCorresSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
					dataItemCorresDs.proxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=list&searchField='+Ext.getCmp('unitTypeSelecter').getRawValue()});
					dataItemCorresDs.load({params:{start:0, limit:dataItemCorresPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
					dataItemCorresDs.proxy = new Ext.data.HttpProxy({
					url: dataItemCorresUrl + '?action=list&searchField=' + dataItemCorresSearchField + '&searchValue=' + this.getValue()});
					dataItemCorresDs.load({params:{start:0, limit:dataItemCorresPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
	    	}
		}
});

var dataItemCorresPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: dataItemCorresDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: [dataItemCorresFilterItem,'-',dataItemCorresSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['dataTypeDr']=dataTypeDr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
});

var dataItemCorresMain = new Ext.grid.GridPanel({//表格
		title: '数据项对应码表',
		store: dataItemCorresDs,
		cm: dataItemCorresCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['数据项类别：',unitTypeSelecter,'-',addLocButton,'-',editLocButton,'-',delLocButton],
		bbar: dataItemCorresPagingToolbar
});
unitTypeSelecter.on("select",function(cmb,rec,id ){
	dataTypeDr=unitTypeSelecter.getValue();
	dataItemCorresDs.load({params:{start:0, limit:dataItemCorresPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
});