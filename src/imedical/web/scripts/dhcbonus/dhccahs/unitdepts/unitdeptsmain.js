var unitsUrl = 'dhc.ca.unitsexe.csp';
var unitDeptsUrl = 'dhc.ca.unitdeptsexe.csp';

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
			  emptyText:'选择单位类别...',
	      allowBlank: false,
			  name:'unitTypeSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

var unitTypeRowid = "";


var unitDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});
var unitTypeDr="";

var unitRowid = "";

unitTypeSelecter.on(
	"select",
	function(cmb,rec,id ){
		//unitSelecter.reset();
		unitSelecter.setRawValue('');
    unitSelecter.setValue('');
    unitRowid = "";
		unitDeptsDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listAll'});
		unitDeptsDs.load({params:{start:0, limit:0}});
		unitTypeDr = cmb.getValue();
		unitTypeRowid = unitTypeDr;
		unitDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listunits&searchField=shortcut&unitTypeDr='+unitTypeDr+'&searchValue='+Ext.getCmp('unitSelecter').getRawValue()});
		//alert(unitTypeDr);
		unitDs.load({params:{start:0, limit:9}});
	}
);

unitDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listunits&searchField=shortcut&unitTypeDr='+unitTypeDr+'&searchValue='+Ext.getCmp('unitSelecter').getRawValue()});
	}
);

var unitSelecter = new Ext.form.ComboBox({
				id:'unitSelecter',
			  fieldLabel:'名称',
			  store: unitDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择单位...',
	      allowBlank: false,
			  name:'unitSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});


unitSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
	}
);




function searchFun(unitDr)
{
		unitRowid = unitDr;
		unitDeptsDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listAll&unitDr='+unitDr});
		unitDeptsDs.load({params:{start:0, limit:unitDeptsPagingToolbar.pageSize}});
};

var unitDeptsDs = new Ext.data.Store({
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
						'remark',
						{name:'startTime',type:'date',dateFormat:'Y-m-d'},
						{name:'stop',type:'date',dateFormat:'Y-m-d'},
						'unitDr',
						'propertyDr',
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

unitDeptsDs.setDefaultSort('rowId', 'Desc');

function formatDate(value){
    return value ? value.dateFormat('Y-m-d') : '';
};

var unitDeptsCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '代码',
        dataIndex: 'code',
        width: 120,
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

//新增导出功能
var _Excel = new Herp.Excel(
    {
	 url:ServletURL,
     sql:'SELECT UnitDepts_code as 科室代码 ,UnitDepts_name as 科室名称,UnitDepts_remark as 备注,UnitDepts_start as 启用时间,UnitDepts_stop as 停用时间,UnitDepts_active as 有效性,UnitDepts_unitDr->Units_name as 医院 FROM dhc_ca_cache_data.UnitDepts WHERE UnitDepts_unitDr=?  ORDER BY UnitDepts_code ',
     fileName:"医院科室"     
    });
 
var exportButton = {
    text: '导出医院科室',
    tooltip: '导出数据',
    iconCls: 'remove',
    handler: function() { _Excel.download(unitRowid); }
};


//StatuTabCm.defaultSortable = true;

var addUnitDeptsButton = new Ext.Toolbar.Button({
		text: '添加',
    tooltip:'添加新单位部门信息',        
    iconCls:'add',
		handler: function(){
			if(unitRowid==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再添加单位部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(unitDeptsDs,unitDeptsMain,unitDeptsPagingToolbar,unitRowid);
			}
		}
});

var editUnitDeptsButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的单位部门信息',
		iconCls:'remove',        
		handler: function(){
			if(unitRowid==""){
				Ext.Msg.show({title:'注意',msg:'请选择单位再修改单位部门信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(unitDeptsDs,unitDeptsMain,unitDeptsPagingToolbar);
			}
		}
});

var delUnitDeptsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的单位部门',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(unitDeptsDs,unitDeptsMain,unitDeptsPagingToolbar);}
});

var unitDeptsSearchField = 'name';

var unitDeptsFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '地址',value: 'address',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: '开始时间',value: 'startTime',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: '停止时间',value: 'stop',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '有效',value: 'active',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck })
		]}
});

function onUnitsItemCheck(item, checked)
{
		if(checked) {
				unitDeptsSearchField = item.value;
				unitDeptsFilterItem.setText(item.text + ':');
		}
};

var unitDeptsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
							unitDeptsDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listAll&unitDr='+unitRowid});
							unitDeptsDs.load({params:{start:0, limit:unitDeptsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						unitDeptsDs.proxy = new Ext.data.HttpProxy({
						url: unitDeptsUrl + '?action=listAll&unitDr='+unitRowid+'&searchField=' + unitDeptsSearchField + '&searchValue=' + this.getValue()});
	        	unitDeptsDs.load({params:{start:0, limit:unitDeptsPagingToolbar.pageSize}});
	    	}
		}
});

var unitDeptsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
    store: unitDeptsDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
		buttons: [unitDeptsFilterItem,'-',unitDeptsSearchBox]
});

var unitDeptsMain = new Ext.grid.GridPanel({//表格
		title: '单位部门码表',
		store: unitDeptsDs,
		cm: unitDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['单位类别：',unitTypeSelecter,'-','单位：',unitSelecter,'-',addUnitDeptsButton,'-',editUnitDeptsButton,'-',delUnitDeptsButton,'-',exportButton],
		bbar: unitDeptsPagingToolbar
});