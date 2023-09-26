var PJXBaseDataUrl = 'dhc.pa.pjxbasedataexe.csp';
var PJXBaseDataProxy = new Ext.data.HttpProxy({url:PJXBaseDataUrl+'?action=list'});

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'考核周期',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
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
	listWidth : 200,
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
	listWidth : 200,
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
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var PJXBaseDataDs = new Ext.data.Store({
	proxy: PJXBaseDataProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','userName','periodType','KPICode','KPIDr','KPIName','actualValue','auditDate','auditUserName'
 
		]),
    // turn on remote sorting
    remoteSort: true
});

PJXBaseDataDs.setDefaultSort('rowid', 'DESC');


var addPJXBaseDataButton = new Ext.Toolbar.Button({
		text: '导入',
		tooltip: '导入相应期间的数据',
		iconCls: 'add',
		handler: function(){
		addPJXBaseDataFun(PJXBaseDataDs,PJXBaseDataMain,PJXBaseDataPagingToolbar);
		}
});

var editButton = new Ext.Toolbar.Button({
	text: '删除',
	tooltip: '根据选择的期间删除',
	iconCls: 'add',
	handler: function(){
		delFun(PJXBaseDataDs,PJXBaseDataMain,PJXBaseDataPagingToolbar);
	}
});


var editPJXBaseDataButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的年度',
		iconCls: 'remove',
		handler: function(){editPJXBaseDataFun(PJXBaseDataDs,PJXBaseDataMain,PJXBaseDataPagingToolbar);}
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
var PJXBaseDataCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '内部人员',
			dataIndex: 'userName',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '指标代码',
			dataIndex: 'KPICode',
			width: 100,
			align: 'left',
			sortable: true

		},
		{
			header: '指标名称',
			dataIndex: 'KPIName',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: '指标实际值',
			dataIndex: 'actualValue',
			width: 100,
			align: 'left',
			sortable: true

		},{
			header: '审核时间',
			dataIndex: 'auditDate',
			width: 100,
			align: 'left',
			sortable: true

		},{
			header: '审核人',
			dataIndex: 'auditUserName',
			width: 100,
			align: 'left',
			sortable: true

		}
	]);



	
var PJXBaseDataSearchField = 'Name';

var PJXBaseDataFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '内部人员',value: 'userName',checked: false,group: 'PJXBaseDataFilter',checkHandler: onPJXBaseDataItemCheck }),
				new Ext.menu.CheckItem({ text: '指标实际值',value: 'actualValue',checked: false,group: 'PJXBaseDataFilter',checkHandler: onPJXBaseDataItemCheck }),
				new Ext.menu.CheckItem({ text: '审核时间',value: 'auditDate',checked: false,group: 'PJXBaseDataFilter',checkHandler: onPJXBaseDataItemCheck })
		]}
});

function onPJXBaseDataItemCheck(item, checked){
		if(checked) {
				PJXBaseDataSearchField = item.value;
				PJXBaseDataFilterItem.setText(item.text + ':');
		}
};

var PJXBaseDataSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				PJXBaseDataDs.proxy = new Ext.data.HttpProxy({url: PJXBaseDataUrl + '?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue()});
				PJXBaseDataDs.load({params:{start:0, limit:PJXBaseDataPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				PJXBaseDataDs.proxy = new Ext.data.HttpProxy({
				url: PJXBaseDataUrl + '?action=list&searchField=' + PJXBaseDataSearchField + '&searchValue=' + this.getValue()+'&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue()});
				PJXBaseDataDs.load({params:{start:0, limit:PJXBaseDataPagingToolbar.pageSize}});
	    	}
		}
});
PJXBaseDataDs.each(function(record){
    alert(record.get('tieOff'));

});
var PJXBaseDataPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: PJXBaseDataDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',PJXBaseDataFilterItem,'-',PJXBaseDataSearchBox]
});

var PJXBaseDataMain = new Ext.grid.GridPanel({//表格
		title: '个人基本数据',
		store: PJXBaseDataDs,
		cm: PJXBaseDataCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//plugins:checkColumn,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: ['年度:',cycleField,'-','期间类型:',periodTypeField,'-','期间:',periodField,'-',editButton],
		bbar: PJXBaseDataPagingToolbar

});
periodField.on('select', function(cmb,rec,id){
	PJXBaseDataDs.proxy=new Ext.data.HttpProxy({
	url:PJXBaseDataUrl+'?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue(),method:'POST'
	});
	PJXBaseDataDs.load({params:{start:0, limit:PJXBaseDataPagingToolbar.pageSize}});
});
////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
PJXBaseDataDs.load({params:{start:0, limit:PJXBaseDataPagingToolbar.pageSize}});
