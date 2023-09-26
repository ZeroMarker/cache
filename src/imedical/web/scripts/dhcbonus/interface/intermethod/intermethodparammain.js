var InterMethodParamUrl = 'dhc.bonus.intermethodexe.csp';
var InterLocSetTabUrl = 'dhc.bonus.interlocsetexe.csp';
var InterLocProxy = new Ext.data.HttpProxy({url:InterMethodParamUrl+'?action=list'});



var interLocSetDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

interLocSetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:InterLocSetTabUrl+'?action=list&searchValue=Y&searchField=active',method:'POST'})
});

var interLocSetField = new Ext.form.ComboBox({
	id: 'interLocSetField',
	fieldLabel:'接口套',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: interLocSetDs,
	valueField: 'rowid',
	displayField: 'shortcut',
	triggerAction: 'all',
	emptyText:'',
	//name: 'interLocSetField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var InterMethodParamDs = new Ext.data.Store({
	proxy: InterLocProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','ParamCode','ParamName','ParamValue','ParamOrder','InterLocMethodDr'
  		]),
    // turn on remote sorting
    remoteSort: true
});

InterMethodParamDs.setDefaultSort('ParamCode', 'ASC');


var addInterParamButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新接口方法',
		iconCls: 'add',
		handler: function(){
			//testFun();
		  //addMethodParamFun('','','');
		addMethodParamFun(InterMethodParamDs,InterMethodMain,InterParamPagingToolbar);
			//alert('aaaa')
		}
});

var deleteParamButton = new Ext.Toolbar.Button({
	text: '删除',
	tooltip: '根据选择的期间删除',
	iconCls: 'remove',
	handler: function(){
		delInterParamFun(InterMethodParamDs,InterParamMain,InterParamPagingToolbar);
	}
});


var editInterLocButton  = new Ext.Toolbar.Button({
		text: '修改',
		disable:false,
		tooltip: '修改选定的接口单元',
		iconCls: 'add',
		handler: function(){editInterParamFun(InterMethodParamDs,InterParamMain,InterParamPagingToolbar);}
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

	

var InterMethodParamCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		  {
			header: '顺序号',
			dataIndex: 'ParamOrder',
			width: 50,
			align: 'left',
			sortable: true

		},  
		{
			header: '参数名称',
			dataIndex: 'ParamName',
			width: 100,
			align: 'left',
			sortable: true

		},
		{
			header: '默认值',
			dataIndex: 'ParamValue',
			width: 180,
			align: 'left',
			sortable: true

		}
	]);



/*	
var InterLocSearchField = 'Name';

var InterLocFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '顺序号',value: 'order',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck }),
				new Ext.menu.CheckItem({ text: '接口单元代码',value: 'code',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck }),
				new Ext.menu.CheckItem({ text: '接口单元名称',value: 'name',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck })
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
				InterMethodParamDs.proxy = new Ext.data.HttpProxy({url: InterMethodParamUrl + '?action=list&interLocSetDr='+interLocSetField.getValue()});
				InterMethodParamDs.load({params:{start:0, limit:InterParamPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				InterMethodParamDs.proxy = new Ext.data.HttpProxy({
				url: InterMethodParamUrl + '?action=list&interLocSetDr='+interLocSetField.getValue()});
				InterMethodParamDs.load({params:{start:0, limit:InterParamPagingToolbar.pageSize}});
	    	}
		}
});
*/
var InterParamPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: InterMethodParamDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"
		//buttons: ['-',InterLocFilterItem,'-',InterLocSearchBox]
});




var InterParamMain = new Ext.grid.GridPanel({//表格
		title: '方法参数维护',
		store: InterMethodParamDs,
		height :560,
		width: 400,
		cm: InterMethodParamCm,
		trackMouseOver: true,
		region: 'east',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: false,
		//plugins:checkColumn,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: ['-',addInterParamButton,'-',editInterLocButton,'-',deleteParamButton],
		bbar: InterParamPagingToolbar
        //,'-',deleteParamButton
});





