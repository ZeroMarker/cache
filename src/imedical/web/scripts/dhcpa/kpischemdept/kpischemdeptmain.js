///////////////////////////////////////////////////

var tmpData="";
Ext.ns('Ext.ux.grid');

var itemGridUrl = '../csp/dhc.pa.kpiSchemDeptexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'schemDr',
			'code',
			'name',
			'jxunitDr',
			'jname',
			'userDr',
			'userName'
		]),
	    remoteSort: true
});

//初始化搜索字段
var itemSearchField ='name';

//搜索过滤器
var itemFilterItem = new Ext.Toolbar.SplitButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '方案代码',
			value: 'code',
			checked: false ,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '方案名称',
			value: 'name',
			checked: false,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '归口科室',
			value: 'jname',
			checked: false,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '负责人',
			value: 'userName',
			checked: false,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		})
	]}
});

//定义搜索响应函数
function onitemItemCheck(item, checked){
	if(checked) {
		itemSearchField = item.value;
		itemFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var itemSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			itemGridDs.proxy = new Ext.data.HttpProxy({url: itemGridUrl + '?action=list'});
			itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			itemGridDs.proxy = new Ext.data.HttpProxy({
				url: itemGridUrl + '?action=list&searchField=' + itemSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
	        	itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
	    	}
	}
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',itemFilterItem,'-',itemSearchBox]

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid');

var tmpTitle='考核归口管理';	
var deptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=listDept',method:'POST'});
});	

var userDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


userDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=userList',method:'POST'});
});	
//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        
        {

            id:'rowid',
            header: '方案ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
			sortable: true,
            dataIndex: 'rowid'
       },{

            id:'code',
            header: '方案编号',
            allowBlank: false,
            width:100,
            editable:false,
			sortable: true,
            dataIndex: 'code'
       },{
            id:'name',
            header: '方案名称',
            allowBlank: false,
            width:150,
            editable:false,
			sortable: true,
            dataIndex: 'name'
            						
       },{	
            id:'userName',
            header: '负责人',
            width:150,
			editable:false,
			sortable: true,
            dataIndex: 'userName'
       },{	
            id:'jname',
            header: '归口科室',
            width:185,
			sortable: true,
            dataIndex: 'jname',
            editable:false	
       }			    
]);
var addButton = new Ext.Toolbar.Button({
					text : '添加',
					iconCls : 'add',
					handler : function() {
						 schemdeptAddFun(itemGridDs,itemGrid,itemGridPagingToolbar);
				   }
  	});
var saveButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler :function() {
					       schemdeptEditFun(itemGridDs,itemGrid,itemGridPagingToolbar);
						}		
				});


var itemGrid = new Ext.grid.EditorGridPanel({
			
		    region: 'center',
		    clicksToEdit:1,
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.pa.kpiSchemdeptexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			forms : [],
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.CheckboxSelectionModel({singelSelect:true}),
			loadMask: true,
			tbar:[addButton,saveButton],
			bbar:itemGridPagingToolbar
			

})

	
	

itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  
