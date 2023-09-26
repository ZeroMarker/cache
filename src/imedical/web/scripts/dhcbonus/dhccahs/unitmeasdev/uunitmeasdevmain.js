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
	fieldLabel:'部门名称',
	emptyText:'选择单位...'
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
		fieldLabel:'类别名称',
		store: typeDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择单位类别...',
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
		fieldLabel:'单位名称',
		store: unitDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择单位名称...',
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
		title: '选择单位',
	  width: 300,
	  height:200,
	  layout: 'fit',
	  plain:true,
	  modal:true,
	  bodyStyle:'padding:5px;',
	  buttonAlign:'center',
	  items: formPanel,
	  buttons: [{
	  	text: '确定',
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
			text: '取消',
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
		fieldLabel:'项目名称',
		emptyText:'选择项目...'
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
			fieldLabel:'项目名称',
			store: itemTypeDs,
			valueField:'rowid',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'选择项目...',
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
			fieldLabel:'项目名称',
			store: itemDs,
			valueField:'itemDr',
			displayField:'itemShortCut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'选择项目...',
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
  		title: '添加项目',
  	  width: 300,
  	  height:200,
  	  layout: 'fit',
  	  plain:true,
  	  modal:true,
  	  bodyStyle:'padding:5px;',
  	  buttonAlign:'center',
  	  items: formPanel,
  	  buttons: [{
  	  	text: '确定',
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
				text: '取消',
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
    		header: '序号',
        dataIndex: 'order',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
    		header: '代码',
        dataIndex: 'code',
        width: 60,
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
        header: "启用时间",
        dataIndex: 'startTime',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: formatDate
    },
    {
        header: "停用时间",
        dataIndex: 'stop',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: formatDate
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

var addUnitMeasDevButton = new Ext.Toolbar.Button({
		text: '添加',
    tooltip:'添加新计量表计信息',        
    iconCls:'add',
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else{
				addFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitDr,itemDr);
			}
		}
});

var editUnitMeasDevButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的计量表计信息',
		iconCls:'remove',        
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再修改计量表计信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(unitMeasDevDs,main,unitMeasDevPagingToolbar);
			}
		}
});

var measDevDeptsButton  = new Ext.Toolbar.Button({
		text: '维护部门',        
		tooltip: '维护选定单位计量表计的部门',
		iconCls: 'remove',
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再修改计量表计信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				measDevDeptsFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitSelecter,itemSelecter);
			}
		}
});

var deptMeasDevButton  = new Ext.Toolbar.Button({
		text: '按部门查看计量表计',        
		tooltip: '查看部门计量表计',
		iconCls: 'remove',
		handler: function(){			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再修改计量表计信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				deptMeasDevFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitSelecter,itemSelecter);
			}
		}
});

var measDevLeftButton  = new Ext.Toolbar.Button({
		text: '查看没有部门的计量表计',        
		tooltip: '查看没有部门的计量表计',
		iconCls: 'remove',
		handler: function(){
			var unitDr = unitSelecter.getValue();
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			type=0;
			unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize,id:unitSelecter.getValue(),type:type}});
		}
});

var delUnitMeasDevButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的计量表计',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(unitMeasDevDs,main,unitMeasDevPagingToolbar);}
});

var unitMeasDevSearchField = 'order';

var unitMeasDevFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '序号',value: 'order',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: '开始时间',value: 'startTime',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: '停止时间',value: 'stop',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '有效',value: 'active',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck })
		]}
});

function onUnitsItemCheck(item, checked)
{
		if(checked) {
				unitMeasDevSearchField = item.value;
				unitMeasDevFilterItem.setText(item.text + ':');
		}
};

var unitMeasDevSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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

var unitMeasDevPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
    store: unitMeasDevDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
		buttons: [unitMeasDevFilterItem,'-',unitMeasDevSearchBox]
});

var checkMenu = new Ext.menu.Menu({
	items:[{
		text: '按部门查看计量表计',        
		tooltip: '查看部门计量表计',
		iconCls: 'remove',
		handler: function(){			
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再修改计量表计信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				deptMeasDevFun(unitMeasDevDs,main,unitMeasDevPagingToolbar,unitSelecter,itemSelecter);
			}
		}
	},{
		text: '查看没有部门的计量表计',        
		tooltip: '查看没有部门的计量表计',
		iconCls: 'remove',
		handler: function(){
			if(unitDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if(itemDr==""){
				Ext.Msg.show({title:'注意',msg:'请选择数据类别后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			type=0;
			unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize,id:unitSelecter.getValue(),type:type}});
		}
	}]
});

var main = new Ext.grid.GridPanel({//表格
		title: '计量表计码表',
		store: unitMeasDevDs,
		cm: unitMeasDevCm,
		trackMouseOver: true,///////no use
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['选择单位：',unitTrigger,'-','选择数据：',itemTrigger,'-',measDevDeptsButton,'-',{
            text:'查看',
            iconCls: 'add',
            menu: checkMenu
        },'-',delUnitMeasDevButton],
		bbar: unitMeasDevPagingToolbar
});