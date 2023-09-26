///////////////////////////////////////////////////

var tmpData="";
Ext.ns('Ext.ux.grid');

var itemGridUrl = '../csp/dhc.pa.kpiSchemDeptexe.csp';
//�������Դ
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

//��ʼ�������ֶ�
var itemSearchField ='name';

//����������
var itemFilterItem = new Ext.Toolbar.SplitButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '��������',
			value: 'code',
			checked: false ,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '��������',
			value: 'name',
			checked: false,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '��ڿ���',
			value: 'jname',
			checked: false,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '������',
			value: 'userName',
			checked: false,
			group: 'itemFilter',
			checkHandler: onitemItemCheck 
		})
	]}
});

//����������Ӧ����
function onitemItemCheck(item, checked){
	if(checked) {
		itemSearchField = item.value;
		itemFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var itemSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
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
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',itemFilterItem,'-',itemSearchBox]

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid');

var tmpTitle='���˹�ڹ���';	
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
//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        
        {

            id:'rowid',
            header: '����ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
			sortable: true,
            dataIndex: 'rowid'
       },{

            id:'code',
            header: '�������',
            allowBlank: false,
            width:100,
            editable:false,
			sortable: true,
            dataIndex: 'code'
       },{
            id:'name',
            header: '��������',
            allowBlank: false,
            width:150,
            editable:false,
			sortable: true,
            dataIndex: 'name'
            						
       },{	
            id:'userName',
            header: '������',
            width:150,
			editable:false,
			sortable: true,
            dataIndex: 'userName'
       },{	
            id:'jname',
            header: '��ڿ���',
            width:185,
			sortable: true,
            dataIndex: 'jname',
            editable:false	
       }			    
]);
var addButton = new Ext.Toolbar.Button({
					text : '���',
					iconCls : 'add',
					handler : function() {
						 schemdeptAddFun(itemGridDs,itemGrid,itemGridPagingToolbar);
				   }
  	});
var saveButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
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
		    atLoad : true, // �Ƿ��Զ�ˢ��
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
  
