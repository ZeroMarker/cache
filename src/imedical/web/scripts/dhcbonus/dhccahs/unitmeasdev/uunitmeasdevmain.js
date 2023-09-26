var unitsUrl = 'dhc.ca.unitsexe.csp';
var unitMeasDevUrl = 'dhc.ca.unitmeasdevexe.csp';
var allDataItemsUrl = 'dhc.ca.alldataitemsexe.csp';

//////////////////////////////////////
var mainUrl = 'dhc.ca.unitmeasdevexe.csp';
var unitDr = '';
var unitSelecter;
var itemSelecter;

var unitTrigger = new Ext.form.TriggerField({
	allowBlank:false,
	fieldLabel:'��������',
	emptyText:'ѡ��λ...'
});

var deptSelectWindow = function(){
	
	var typeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
	});
	
	typeDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('typeSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var typeSelecter = new Ext.form.ComboBox({
		id:'typeSelecter',
		fieldLabel:'�������',
		store: typeDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��λ���...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true
	});
	
	typeSelecter.on(
		"select",
		function(cmb,rec,id ){
			unitSelecter.setValue('');
			unitDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('unitSelecter').getRawValue()+'&unitTypeDr='+typeSelecter.getValue(), method:'GET'});
			unitDs.load({params:{start:0, limit:typeSelecter.pageSize}});
		}
	);
	
	var unitDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
	});
	
	unitDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('unitSelecter').getRawValue()+'&unitTypeDr='+typeSelecter.getValue(), method:'GET'});
		}
	);
	
	unitSelecter = new Ext.form.ComboBox({
		id:'unitSelecter',
		fieldLabel:'��λ����',
		store: unitDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��λ����...',
	  allowBlank: false,
		selectOnFocus: true,
		forceSelection: true
	});
		
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
	  labelWidth: 60,
	  items: [
	    typeSelecter,
	    unitSelecter
		]
	});
	
	var window = new Ext.Window({
		title: 'ѡ��λ',
	  width: 300,
	  height:200,
	  layout: 'fit',
	  plain:true,
	  modal:true,
	  bodyStyle:'padding:5px;',
	  buttonAlign:'center',
	  items: formPanel,
	  buttons: [{
	  	text: 'ȷ��',
	    handler: function() {
	    	unitDr = unitSelecter.getValue();
	    	unitTrigger.setValue(Ext.get('unitSelecter').getValue());
	    	if(itemDr!=''){
					unitMeasDevDs.proxy = new Ext.data.HttpProxy({url: unitMeasDevUrl + '?action=list&unitDr='+unitDr+'&dataItemDr='+itemDr});
					unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize}});
				}
	    	window.close();
	    }
	  },
	  {
			text: 'ȡ��',
	    handler: function(){
	    	window.close();
	    }
	  }]
	});
	window.show();
};

unitTrigger.onTriggerClick = deptSelectWindow;

////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////

	var itemTrigger = new Ext.form.TriggerField({
		allowBlank:false,
		fieldLabel:'��Ŀ����',
		emptyText:'ѡ����Ŀ...'
	});
	
	var itemDr = '';

	var selectItemWindow = function(){
		
		var itemTypeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
		});
		
		itemTypeDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItemType&searchField=shortcut&searchValue='+Ext.getCmp('itemTypeSelecter').getRawValue(), method:'GET'});
			}
		);
	  
		var itemTypeSelecter = new Ext.form.ComboBox({
			id:'itemTypeSelecter',
			fieldLabel:'��Ŀ����',
			store: itemTypeDs,
			valueField:'rowid',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'ѡ����Ŀ...',
			allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
		
		itemTypeSelecter.on(
			"select",
			function(cmb,rec,id ){
				itemSelecter.setValue('');
				itemDs.proxy = new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItem&searchField=itemShortCut&searchValue='+Ext.getCmp('itemSelecter').getRawValue()+'&dataTypeDr='+Ext.getCmp('itemTypeSelecter').getValue(), method:'GET'});
				itemDs.load({params:{start:0, limit:itemTypeSelecter.pageSize}});
			}
		);
		
		var itemDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['itemShortCut','rowid','itemDr'])
		});
		
		itemDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItem&searchField=itemShortCut&searchValue='+Ext.getCmp('itemSelecter').getRawValue()+'&dataTypeDr='+Ext.getCmp('itemTypeSelecter').getValue(), method:'GET'});
			}
		);
	  
		itemSelecter = new Ext.form.ComboBox({
			id:'itemSelecter',
			fieldLabel:'��Ŀ����',
			store: itemDs,
			valueField:'itemDr',
			displayField:'itemShortCut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'ѡ����Ŀ...',
			allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
			
		var formPanel = new Ext.form.FormPanel({
  		baseCls: 'x-plain',
  	  labelWidth: 60,
  	  items: [
				itemTypeSelecter,
  	    itemSelecter
			]
		});
		
		var window = new Ext.Window({
  		title: '�����Ŀ',
  	  width: 300,
  	  height:200,
  	  layout: 'fit',
  	  plain:true,
  	  modal:true,
  	  bodyStyle:'padding:5px;',
  	  buttonAlign:'center',
  	  items: formPanel,
  	  buttons: [{
  	  	text: 'ȷ��',
  	    handler: function() {
  	    	itemDr = itemSelecter.getValue();
  	    	itemTrigger.setValue(Ext.get('itemSelecter').getValue());
  	    	if(unitDr!=''){
						unitMeasDevDs.proxy = new Ext.data.HttpProxy({url: unitMeasDevUrl + '?action=list&unitDr='+unitDr+'&dataItemDr='+itemDr});
						unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize}});
					}
  	    	window.close();
  	    }
  	  },
  	  {
				text: 'ȡ��',
  	    handler: function(){
  	    	window.close();
  	    }
  	  }]
		});
		window.show();
	};

	itemTrigger.onTriggerClick = selectItemWindow;

////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////



var unitMeasDevDs = new Ext.data.Store({
		proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
            'unitDr',
            'dataItemDr',
            'order',
						'code',
						'remark',
						{name:'startTime',type:'date',dateFormat:'Y-m-d'},
						{name:'stop',type:'date',dateFormat:'Y-m-d'},
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

unitMeasDevDs.setDefaultSort('order', 'Desc');

function formatDate(value){
    return value ? value.dateFormat('Y-m-d') : '';
};

var unitMeasDevCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '���',
        dataIndex: 'order',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
    		header: '����',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
    {
        header: "��ע",
        dataIndex: 'remark',
        width: 200,
        align: 'left',
        sortable: true
    },
        {
        header: "����ʱ��",
        dataIndex: 'startTime',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: formatDate
    },
    {
        header: "ͣ��ʱ��",
        dataIndex: 'stop',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: formatDate
    },
    {
        header: "��Ч",
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

var addUnitMeasDevButton = new Ext.Toolbar.Button({
		text: '���',
    tooltip:'����¼��������Ϣ',        
    iconCls:'add',
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else{
				addFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitDr,itemDr);
			}
		}
});

var editUnitMeasDevButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���ļ��������Ϣ',
		iconCls:'remove',        
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ���޸ļ��������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(unitMeasDevDs,main,unitMeasDevPagingToolbar);
			}
		}
});

var measDevDeptsButton  = new Ext.Toolbar.Button({
		text: 'ά������',        
		tooltip: 'ά��ѡ����λ������ƵĲ���',
		iconCls: 'remove',
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ���޸ļ��������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				measDevDeptsFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitSelecter,itemSelecter);
			}
		}
});

var deptMeasDevButton  = new Ext.Toolbar.Button({
		text: '�����Ų鿴�������',        
		tooltip: '�鿴���ż������',
		iconCls: 'remove',
		handler: function(){			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ���޸ļ��������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				deptMeasDevFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitSelecter,itemSelecter);
			}
		}
});

var measDevLeftButton  = new Ext.Toolbar.Button({
		text: '�鿴û�в��ŵļ������',        
		tooltip: '�鿴û�в��ŵļ������',
		iconCls: 'remove',
		handler: function(){
			var unitDr = unitSelecter.getValue();
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			type=0;
			unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize,id:unitSelecter.getValue(),type:type}});
		}
});

var delUnitMeasDevButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ļ������',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(unitMeasDevDs,main,unitMeasDevPagingToolbar);}
});

var unitMeasDevSearchField = 'order';

var unitMeasDevFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '���',value: 'order',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: '��ʼʱ��',value: 'startTime',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: 'ֹͣʱ��',value: 'stop',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ч',value: 'active',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck })
		]}
});

function onUnitsItemCheck(item, checked)
{
		if(checked) {
				unitMeasDevSearchField = item.value;
				unitMeasDevFilterItem.setText(item.text + ':');
		}
};

var unitMeasDevSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							unitMeasDevDs.proxy = new Ext.data.HttpProxy({url: unitMeasDevUrl + '?action=list&unitDr='+unitDr+'&dataItemDr='+itemDr});
							unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						unitMeasDevDs.proxy = new Ext.data.HttpProxy({
						url: unitMeasDevUrl + '?action=list&unitDr='+unitDr+'&dataItemDr='+itemDr+'&searchField=' + unitMeasDevSearchField + '&searchValue=' + this.getValue()});
	        	unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize}});
	    	}
		}
});

var unitMeasDevPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
    store: unitMeasDevDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
		buttons: [unitMeasDevFilterItem,'-',unitMeasDevSearchBox]
});

var checkMenu = new Ext.menu.Menu({
	items:[{
		text: '�����Ų鿴�������',        
		tooltip: '�鿴���ż������',
		iconCls: 'remove',
		handler: function(){			
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ���޸ļ��������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				deptMeasDevFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitSelecter,itemSelecter);
			}
		}
	},{
		text: '�鿴û�в��ŵļ������',        
		tooltip: '�鿴û�в��ŵļ������',
		iconCls: 'remove',
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if(itemDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			type=0;
			unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize,id:unitSelecter.getValue(),type:type}});
		}
	}]
});

var main = new Ext.grid.GridPanel({//���
		title: '����������',
		store: unitMeasDevDs,
		cm: unitMeasDevCm,
		trackMouseOver: true,///////no use
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['ѡ��λ��',unitTrigger,'-','ѡ�����ݣ�',itemTrigger,'-',measDevDeptsButton,'-',{
            text:'�鿴',
            iconCls: 'add',
            menu: checkMenu
        },'-',delUnitMeasDevButton],
		bbar: unitMeasDevPagingToolbar
});