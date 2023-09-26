var InterLocUrl = 'dhc.pa.interlocexe.csp';
var InterLocSetTabUrl = 'dhc.pa.interlocsetexe.csp';
var InterLocProxy = new Ext.data.HttpProxy({url:InterLocUrl+'?action=list'});

var interLocSetDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

interLocSetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:InterLocSetTabUrl+'?action=list&searchValue='+encodeURIComponent(interLocSetField.getRawValue())+'&searchField=name',method:'POST'})
});

var interLocSetField = new Ext.form.ComboBox({
	id: 'interLocSetField',
	fieldLabel:'接口套',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: interLocSetDs,
	valueField: 'rowid',
	displayField: 'shortcut',
	triggerAction: 'all',
	emptyText:'请选择接口套...',
	//name: 'interLocSetField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6上半年'],['2','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['1','00']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var InterLocDs = new Ext.data.Store({
	proxy: InterLocProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','order','jxUnitDr','jxUnitName','code','name','Type','patType','inLocSetDr','remark','active'
 
		]),
    // turn on remote sorting
    remoteSort: true
});

InterLocDs.setDefaultSort('order', 'DESC');


var addInterLocButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的接口科室',
		iconCls: 'add',
		handler: function(){
		addInterLocFun(InterLocDs,InterLocMain,InterLocPagingToolbar);
		}
});

var editButton = new Ext.Toolbar.Button({
	text: '删除',
	tooltip: '根据选择的期间删除',
	iconCls: 'remove',
	handler: function(){
		delFun(InterLocDs,InterLocMain,InterLocPagingToolbar);
	}
});


var editInterLocButton  = new Ext.Toolbar.Button({
		text: '修改',
		disable:false,
		tooltip: '修改选定的接口科室',
		iconCls: 'add',
		handler: function(){editInterLocFun(InterLocDs,InterLocMain,InterLocPagingToolbar);}
});
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
             e.stopEvent();   
            var index = this.grid.getView().findRowIndex(t);   
            var cindex = this.grid.getView().findCellIndex(t);   
            var record = this.grid.store.getAt(index);   
            var field = this.grid.colModel.getDataIndex(cindex);   
            var e = {   
                grid : this.grid,   
                record : record,   
                field : field,   
                originalValue : record.data[this.dataIndex],   
                value : !record.data[this.dataIndex],   
                row : index,   
                column : cindex,   
                cancel : false  
            };   
            if (this.grid.fireEvent("validateedit", e) !== false && !e.cancel) {   
                delete e.cancel;   
                record.set(this.dataIndex, !record.data[this.dataIndex]);   
                this.grid.fireEvent("afteredit", e);   
            }
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
	};

	/*
var checkColumn=new Ext.grid.CheckColumn({
    header: "有效标志",
    dataIndex: 'active',
    width: 55
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	} 
});
*/
var InterLocCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '顺序号',
			dataIndex: 'order',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '考核单元名称',
			dataIndex: 'jxUnitName',
			width: 150,
			align: 'left',
			sortable: true

		},
		{
			header: '接口科室代码',
			dataIndex: 'code',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: '接口科室名称',
			dataIndex: 'name',
			width: 100,
			align: 'left',
			sortable: true

		}/*,{
			header: '病人类型',
			dataIndex: 'patType',
			width: 100,
			align: 'left',
			sortable: true

		}*/,{
			header: '备注',
			dataIndex: 'remark',
			width: 120,
			align: 'left',
			sortable: true

		}
	]);



	
var InterLocSearchField = 'Name';

var InterLocFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '考核单元名称',value: 'jxUnitName',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck }),
				new Ext.menu.CheckItem({ text: '接口科室代码',value: 'code',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck }),
				new Ext.menu.CheckItem({ text: '接口科室名称',value: 'name',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck })
		]}
});

function onInterLocItemCheck(item, checked){
		if(checked) {
				InterLocSearchField = item.value;
				InterLocFilterItem.setText(item.text + ':');
		}
};

var InterLocSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				InterLocDs.proxy = new Ext.data.HttpProxy({url: InterLocUrl + '?action=list&interLocSetDr='+interLocSetField.getValue()});
				InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				InterLocDs.proxy = new Ext.data.HttpProxy({
				url: InterLocUrl + '?action=list&searchField=' + InterLocSearchField + '&searchValue=' + encodeURIComponent(this.getValue())+'&interLocSetDr='+interLocSetField.getValue()});
				InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
	    	}
		}
});
InterLocDs.each(function(record){
    alert(record.get('tieOff'));

});
var InterLocPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: InterLocDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',InterLocFilterItem,'-',InterLocSearchBox]
});

var InterLocMain = new Ext.grid.GridPanel({//表格
		title: '科室接口维护',
		store: InterLocDs,
		cm: InterLocCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//plugins:checkColumn,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: ['接口套:',interLocSetField,'-',addInterLocButton,'-',editInterLocButton],
		bbar: InterLocPagingToolbar
        //,'-',editButton
});
interLocSetField.on('select', function(cmb,rec,id){
	InterLocDs.proxy=new Ext.data.HttpProxy({
	url:InterLocUrl+'?action=list&interLocSetDr='+interLocSetField.getValue(),method:'POST'
	});
	InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
});
////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
