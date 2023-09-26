var OutKPIDataUrl = 'dhc.pa.outkpidataexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({url: OutKPIDataUrl+'?action=list'});

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
	width:100,
	listWidth : 100,
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
	width:100,
	listWidth : 100,
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
	width:100,
	listWidth : 100,
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

var OutKPIDataDs = new Ext.data.Store({
	proxy: OutKPIDataProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'outUnitCode',
			'outUnitName',
			'outUnitLocCode',
			'outUnitLocName',
			'unitType',
			'outKpiCode',
			'outKpiName',
			'period',
			'periodType',    
			'actValue',
			'active',
			'handFlag'
 
		]),
    // turn on remote sorting
    remoteSort: true
});

OutKPIDataDs.setDefaultSort('rowid', 'DESC');


var addOutKPIDataButton = new Ext.Toolbar.Button({
		text: '导入Excel',
		tooltip: '导入相应期间的数据',
		iconCls: 'add',
		handler: function(){
		importExcel();
		}
});

var editButton = new Ext.Toolbar.Button({
	text: '删除',
	tooltip: '根据选择的期间删除',
	iconCls: 'add',
	handler: function(){
		delFun(OutKPIDataDs,OutKPIDataMain,OutKPIDataPagingToolbar);
	}
});


var editOutKPIDataButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的年度',
		iconCls: 'remove',
		handler: function(){editOutKPIDataFun(OutKPIDataDs,OutKPIDataMain,OutKPIDataPagingToolbar);}
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
var OutKPIDataCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '外部单位代码',
			dataIndex: 'outUnitCode',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '外部单位名称',
			dataIndex: 'outUnitName',
			width: 150,
			align: 'left',
			sortable: true

		},
		{
			header: '外部单位所属科室代码',
			dataIndex: 'outUnitLocCode',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: '外部单位所属科室名称',
			dataIndex: 'outUnitLocName',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: '单位类别',
			dataIndex: 'unitType',
			width: 100,
			align: 'left',
			sortable: true

		},{
			header: '外部指标代码',
			dataIndex: 'outKpiCode',
			width: 120,
			align: 'left',
			sortable: true

		},{
			header: '外部指标名称',
			dataIndex: 'outKpiName',
			width: 120,
			align: 'left',
			sortable: true

		},{
			header: '指标实际值',
			dataIndex: 'actValue',
			width: 100,
			align: 'left',
			sortable: true

		},{
			header: "处理标志",
			dataIndex: 'handFlag',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		}
	]);



	
var OutKPIDataSearchField = 'Name';

var OutKPIDataFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '外部单位代码',value: 'outUnitCode',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '外部单位名称',value: 'outUnitName',checked: true,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '外部单位所属科室代码',value: 'outUnitLocCode',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '外部单位所属科室名称',value: 'outUnitLocName',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '外部指标代码',value: 'outKpiCode',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '外部指标名称',value: 'outKpiName',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '指标实际值',value: 'actValue',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '处理标志',value: 'handFlag',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck })
		]}
});

function onOutKPIDataItemCheck(item, checked){
		if(checked) {
				OutKPIDataSearchField = item.value;
				OutKPIDataFilterItem.setText(item.text + ':');
		}
};

var OutKPIDataSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				OutKPIDataDs.proxy = new Ext.data.HttpProxy({url: OutKPIDataUrl + '?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue()});
				OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				OutKPIDataDs.proxy = new Ext.data.HttpProxy({
				url: OutKPIDataUrl + '?action=list&searchField=' + OutKPIDataSearchField + '&searchValue=' + this.getValue()+'&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue()});
				OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
	    	}
		}
});
OutKPIDataDs.each(function(record){
    alert(record.get('tieOff'));

});
var OutKPIDataPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: OutKPIDataDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',OutKPIDataFilterItem,'-',OutKPIDataSearchBox]
});
var importHZButton = new Ext.Toolbar.Button({
	text: '导入系统数据',
	tooltip: '导入系统数据',
	iconCls: 'add',
	handler: function(){
		var data3="";
	var freStore="";
	
		var cyDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
	});

	cyDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cy').getRawValue()+'&active=Y',method:'POST'})
	});

	var cy = new Ext.form.ComboBox({
		id: 'cy',
		fieldLabel:'考核周期',
		//width:180,
		//listWidth : 180,
		allowBlank: false,
		store: cyDs,
		valueField: 'code',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择考核周期...',
		name: 'cycleField',
		minChars: 1,
		anchor: '90%',
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	
	var perTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
	});
	var perType = new Ext.form.ComboBox({
		id: 'perType',
		fieldLabel: '期间类型',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: perTypeStore,
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

	perType.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data3=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
		}
		if(cmb.getValue()=="Q"){
			data3=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
		}
		if(cmb.getValue()=="H"){
			data3=[['1','1~6上半年'],['2','7~12下半年']];
		}
		if(cmb.getValue()=="Y"){
			data3=[['0','全年']];
		}
		perStore.loadData(data3);
	});
	perStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});

	var Period = new Ext.form.ComboBox({
		id: 'Period',
		fieldLabel: '期间值',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: perStore,
		anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'请选择期间值...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

		var formPanel = new Ext.form.FormPanel({
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:515,
			width:515,
			frame:true,
			fileUpload:false,
			//applyTo:'form',
			items: [cy,perType,Period]
		});
				
		//定义按钮
		var importSYS = new Ext.Toolbar.Button({
			text:'数据导入'
		});
	
	
		
    	var handler2 = function(btn){
			var cycleName=Ext.getCmp('cy').getRawValue();
			if(cycleName==""){
				Ext.Msg.show({title:'提示',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			var periodType=Ext.getCmp('perType').getValue();
			if(periodType==""){
				Ext.Msg.show({title:'提示',msg:'请选择区间类别!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			var period=Ext.getCmp('Period').getValue();
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'请选择区间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
					var uploadUrl = "http://132.147.160.114:8080/uploadexcel/importsys";
					var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&cycleName="+cycleName;
//alert(upUrl);
						formPanel.getForm().submit({
							url:upUrl,
							method:'POST',
							waitMsg:'数据导入中, 请稍等...',
							success:function(form, action, o) {
								Ext.MessageBox.alert("提示信息","数据成功导入!");
								//Ext.MessageBox.alert("Information",action.result.mess);
							},
							failure:function(form, action) {
								Ext.MessageBox.alert("Error",action.result.mess);
							}
						});		
		}
		
		//添加按钮的响应事件
	importSYS.addListener('click',handler2,false);

	var window = new Ext.Window({
		title: '导入基本指标数据',
		width: 400,
		height:200,
		minWidth: 400,
		minHeight: 200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			importSYS
		]
	});
	window.show();
	}
});
var OutKPIDataMain = new Ext.grid.GridPanel({//表格
		title: '指标数据采集表',
		store: OutKPIDataDs,
		cm: OutKPIDataCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//plugins:checkColumn,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: ['年度:',cycleField,'-','期间类型:',periodTypeField,'-','期间:',periodField,'-',addOutKPIDataButton,'-',importHZButton,'-',editButton],
		bbar: OutKPIDataPagingToolbar

});
periodField.on('select', function(cmb,rec,id){
	OutKPIDataDs.proxy=new Ext.data.HttpProxy({
	url:OutKPIDataUrl+'?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue(),method:'POST'
	});
	OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
});
////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
