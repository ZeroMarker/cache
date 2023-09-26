var InterLocUrl = 'dhc.bonus.interlocexe.csp';
var InterLocSetTabUrl = 'dhc.bonus.interlocsetexe.csp';
var InterLocProxy = new Ext.data.HttpProxy({url:InterLocUrl+'?action=list'});

var interLocSetDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

interLocSetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.bonus.intermethodexe.csp?action=getScheme',method:'POST'})
});

var UnitTypeStore = new Ext.data.SimpleStore({
	fields: ['rowid','name'],
	data:[['1','�������'],['4','his����'],['2','ҽ����'],['3','������Ա']]
});
var interLocSetField = new Ext.form.ComboBox({
	id: 'interLocSetField',
	fieldLabel:'��Ԫ���',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store:UnitTypeStore,
	//store: interLocSetDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	//name: 'interLocSetField',
	mode: 'local', //����ģʽ
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6�ϰ���'],['2','7~12�°���']];
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
	emptyText:'',
	mode: 'local', //����ģʽ
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
            'rowid','order','jxUnitDr','jxUnitName','code','name','Type','patType','inLocSetDr','remark','active','EmployeeNo','BonusUnitCode'
 
		]),
    // turn on remote sorting EmployeeNo_"^"_BonusUnitCode
    remoteSort: true
});

InterLocDs.setDefaultSort('order', 'ASC');


var addInterLocButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µĽӿڵ�Ԫ',
		iconCls: 'add',
		handler: function(){
		addInterLocFun(InterLocDs,InterLocMain,InterLocPagingToolbar);
		}
});

var editButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
	tooltip: '����ѡ����ڼ�ɾ��',
	iconCls: 'remove',
	handler: function(){
		delFun(InterLocDs,InterLocMain,InterLocPagingToolbar);
	}
});


var editInterLocButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		disable:false,
		tooltip: '�޸�ѡ���Ľӿڵ�Ԫ',
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
    header: "��Ч��־",
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
			header: '˳���',
			dataIndex: 'order',
			width: 100,
			align: 'left',
			sortable: true
		}, //'EmployeeNo','BonusUnitCode'
		{
			header: '���㵥Ԫ����',
			dataIndex: 'BonusUnitCode',
			width: 80,
			align: 'left',
			sortable: true

		},{
			header: '��Ԫ�ڲ�����',
			dataIndex: 'EmployeeNo',
			width: 80,
			align: 'left',
			sortable: true

		},{
			header: '���㵥Ԫ����',
			dataIndex: 'jxUnitName',
			width: 150,
			align: 'left',
			sortable: true

		},
		{
			header: '�ӿڵ�Ԫ����',
			dataIndex: 'code',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: '�ӿڵ�Ԫ����',
			dataIndex: 'name',
			width: 150,
			align: 'left',
			sortable: true

		}/*,{
			header: '��������',
			dataIndex: 'patType',
			width: 100,
			align: 'left',
			sortable: true

		}*/,{
			header: '��ע',
			dataIndex: 'remark',
			width: 250,
			align: 'left',
			sortable: true

		}
	]);



	
var InterLocSearchField = 'Name';

var InterLocFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '˳���',value: 'order',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck }),
				new Ext.menu.CheckItem({ text: '�ӿڵ�Ԫ����',value: 'code',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck }),
				new Ext.menu.CheckItem({ text: '�ӿڵ�Ԫ����',value: 'name',checked: false,group: 'InterLocFilter',checkHandler: onInterLocItemCheck })
		]}
});

function onInterLocItemCheck(item, checked){
		if(checked) {
				InterLocSearchField = item.value;
				InterLocFilterItem.setText(item.text + ':');
		}
};

var InterLocSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
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
				url: InterLocUrl + '?action=list&searchField=' + InterLocSearchField + '&searchValue=' + this.getValue()+'&interLocSetDr='+interLocSetField.getValue()});
				InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
	    	}
		}
});
InterLocDs.each(function(record){
    alert(record.get('tieOff'));

});
var InterLocPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: InterLocDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',InterLocFilterItem,'-',InterLocSearchBox]
});

var InterLocMain = new Ext.grid.GridPanel({//���
		title: '��Ԫ�ӿ�ά��',
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
		tbar: ['��Ԫ���:',interLocSetField,'-',addInterLocButton,'-',editInterLocButton,'-',editButton],
		bbar: InterLocPagingToolbar
        //,'-',editButton
});
interLocSetField.on('select', function(cmb,rec,id){
//	InterLocDs.proxy=new Ext.data.HttpProxy({
//	url:InterLocUrl+'?action=list&interLocSetDr='+interLocSetField.getValue(),method:'POST'
//	});
//	
	var ajobsUrl= InterLocUrl+'?action=list&interLocSetDr='+interLocSetField.getValue()
	
	InterLocDs.proxy=new Ext.data.HttpProxy(new Ext.data.Connection({ url: ajobsUrl,timeout: 120000, method:'POST'}));
	
	InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
});


function isEdit(value,record){   
    //���̨�ύ����   
   return value;   
  }  
InterLocDs.load({params:{start:0, limit:InterLocPagingToolbar.pageSize}});
