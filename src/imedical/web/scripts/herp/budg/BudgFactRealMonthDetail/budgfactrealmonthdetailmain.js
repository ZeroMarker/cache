var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var Url='herp.budg.budgfactrealmonthdetailexe.csp';

//ComboBox in an Editor Grid: create reusable renderer
//适用于渲染时combobox中数据已装载的情况
Ext.util.Format.comboRenderer = function(combo){
    return function(value){    	
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
    }
}

/**
 * 为ComboBox赋值
 * 需留意id的类型要和RowId一致(目前程序中基本都是String)
 */
function addComboData(store, id, desc) {
	if(store.findExact('rowid',id)==-1){
		var defaultData = {
			rowid : id,
			name : desc
		};
		var r = new store.recordType(defaultData);
		store.add(r);
	}
}

/*
 2012-09-06,zhangdongmei,渲染grid中combox,适用于渲染时下拉框中没有数据的情况
 combo：下拉框
 valuefield:record中对应的下拉框的rowid字段名,
 displaytext:record中对应的下拉框的displayText字段名,
 displaytext2:record中对应的下拉框的displayText字段名(用于displayText是由record中两个字段组成的情况),
 */
Ext.util.Format.comboRenderer2 = function(combo,valuefield,displaytext,displaytext2){
    return function(value, metaData, record, rowIndex, colIndex, store){
    	
    	if(value==null|| value==""){
    		return combo.valueNotFoundText;
    	}
    	var text="";
    	var rowid="";
    	if(record){
	    	rowid=record.get(valuefield);
			text=record.get(displaytext);
			if(displaytext2!=null & displaytext2!=""){				
				var text2=record.get(displaytext2);
				text=text+"~"+text2;
			}
		}
		var find = combo.findRecord(combo.valueField, value);
		if((find==null)&(text!="")){
			var comboxstore=combo.getStore();
			addComboData(comboxstore,rowid,text);
			find = combo.findRecord(combo.valueField, value);
		}
		//2013-12-05 add:给displaytext列赋值,否则界面取不到grid中combo列的描述
		if(find!=null){
			record.set(displaytext,find.get(combo.displayField));   
		}else{
			record.set(displaytext,""); 
		}
        //alert(find);
        return find ? find.get(combo.displayField) : combo.valueNotFoundText;
    }
}
//////////////////////////////查询条件下拉框///////////////////////////
//获取医疗单位
var gethospDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});	
gethospDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=hospital&rowid='+hospid+'',method:'POST'});
});	
var gethospField = new Ext.form.ComboBox({
		id: 'gethospField',
		fieldLabel: '医疗单位',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: gethospDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择医疗单位...',
		name: 'gethospField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
});

//查询年月
var yearmonDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
yearmonDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=yearmonth&str='+encodeURIComponent(Ext.getCmp('yearmonthField').getRawValue()),method:'POST'});
});

var yearmonField = new Ext.form.ComboBox({
	id: 'yearmonField',
	fieldLabel: '年月',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: yearmonDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年月...',
	name: 'yearmonField',
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//获取科室名称
var deptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=dept&str='+encodeURIComponent(Ext.getCmp('deptField').getRawValue()),method:'POST'});
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: deptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'deptField',
	minChars: 1,
	pageSize: 100,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//获取数据来源
var dataDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
dataDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=data&flag=1&str='+encodeURIComponent(Ext.getCmp('dataField').getRawValue()),method:'POST'});
});

var dataField = new Ext.form.ComboBox({
	id: 'dataField',
	fieldLabel: '数据来源',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: dataDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择数据来源...',
	name: 'dataField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//获取科目分类
var codeDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
codeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=itemtype&flag=1',
	method:'POST'});
});
var codeField = new Ext.form.ComboBox({
	id: 'codeField',
	fieldLabel: '科目分类',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: codeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科目分类...',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//获取科目名称
var descDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
descDs.on('beforeload', function(ds, o){
	var yearmonth=yearmonField.getValue();
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=desc&Year='+yearmonth+'&str='+encodeURIComponent(Ext.getCmp('itemdescField').getRawValue()),method:'POST'});
});
var descField = new Ext.form.ComboBox({
	id: 'descField',
	fieldLabel: '科目名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: descDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科目名称...',
	name: 'descField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//////////////////////////////表格嵌套下拉框///////////////////////////
//获取年月
var yearmonthDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});
yearmonthDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgcommoncomboxexe.csp'+'?action=year&flag=1',method:'POST'});
});
var yearmonthField = new Ext.form.ComboBox({
	id: 'yearmonthField',
	fieldLabel: '年月',
	width:200,
	listWidth : 300,
	//allowBlank: false,
	store: yearmonthDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'',
	name: 'yearmonthField',
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            itemdescDs.removeAll();     
				itemdescField.setValue('');
				itemdescDs.proxy = new Ext.data.HttpProxy({	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=desc&Year='+combo.value,method:'POST'});  
				itemdescDs.load({params:{start:0,limit:100}});      					
			}
	}
    //+'&str='+encodeURIComponent(Ext.getCmp('itemdescField').getRawValue())
});
var deptnameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
deptnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=dept&flag=&str='+encodeURIComponent(Ext.getCmp('deptnameField').getRawValue()),method:'POST'});
});
var deptnameField = new Ext.form.ComboBox({
	id: 'deptnameField',
	fieldLabel: '科室名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: deptnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'deptnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//获取科目名称
var itemdescDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
itemdescDs.on('beforeload', function(ds, o){
	var yearmonth=yearmonField.getValue();
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=desc&Year='+yearmonthField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('itemdescField').getRawValue()),method:'POST'});
});
var itemdescField = new Ext.form.ComboBox({
	id: 'itemdescField',
	fieldLabel: '科目名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: itemdescDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'itemdescField',
	minChars: 1,
	pageSize: 100,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//获取数据来源
var datafromDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
datafromDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=data&flag=&str='+encodeURIComponent(Ext.getCmp('datafromField').getRawValue()),method:'POST'});
});
var datafromField = new Ext.form.ComboBox({
	id: 'datafromField',
	fieldLabel: '数据来源',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: datafromDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'datafromField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//编制状态
var ChkStateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','未审核'],['1','已审核']]
});
var ChkStateStoreField = new Ext.form.ComboBox({
	id: 'ChkStateStoreField',
	fieldLabel: '是否审核',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: ChkStateStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'选择模块名称...',
	mode: 'local', // 本地模式
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

var tmpTitle='科目预算执行数据维护';
var combos = new Ext.FormPanel({
	height:150,
	region:'north',
	frame:true,
	defaults: {bodyStyle:'padding:5px'},
		items:[{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'<center><p style="font-weight:bold;font-size:150%">'+tmpTitle+'</p></center>',
				columnWidth:1,
				height:'50'
			}
		]
	   },{
	    columnWidth:1,
	    xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'年月:',
				columnWidth:.085
			},
			yearmonField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.18
			},{
				xtype:'displayfield',
				value:'科室名称:',
				columnWidth:.1
			},
			deptField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.2
			},
			{
				xtype:'displayfield',
				value:'数据来源:',
				columnWidth:.1
			},
			dataField
		]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'科目分类:',
				columnWidth:.07
			},
			codeField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.15
			},
			{
				xtype:'displayfield',
				value:'科目名称:',
				columnWidth:.08
			},
			descField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.2
			},
			{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){
					Search();
				},
				iconCls: 'add'
			}		
		]
	}
	]
});

//查询
var Search=function(){
	var yearmonth=Ext.getCmp('yearmonField').getValue();
	var deptdr=Ext.getCmp('deptField').getValue();
	var datafrom=Ext.getCmp('dataField').getValue();
	var typecode=Ext.getCmp('codeField').getValue();
	var itemcode=Ext.getCmp('descField').getValue();

	if((yearmonth=="")||(deptdr=="")){
		Ext.Msg.show({
			title:'注意',
			msg:'请选择年月和科室！',
			buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING
			});
			return;
		}
	itemGridDs.load(({
		params:{
			yearmonth:yearmonth
			,deptdr:deptdr
			,datafrom:datafrom
			,typecode:typecode
			,itemcode:itemcode
			,start:0
			,limit:itemGridPagingToolbar.pageSize
		}}));
};

//保存按钮
var saveButton = new Ext.Toolbar.Button({
	text: '保存',  
    id:'saveButton', 
    iconCls:'save',
	handler:function(){
		if(CheckDataBeforeSave()==true){
			saveOrder();
		}else{
			return;
		}	
	}
});

//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',  
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		if(CheckDataBeforeDel()==true){
			del()			
		}else{
			return;
		}
	}
});

var auditButton  = new Ext.Toolbar.Button({
	text:'审核',  
    id:'auditButton', 
    iconCls:'option',
    handler:function(){
		if(CheckDataBeforeAudit()==true){
			Audit();
		}else{
			return;
		}	
    }
});

var noauditButton  = new Ext.Toolbar.Button({
	text:'取消审核',  
    id:'noauditButton', 
    iconCls:'remove',
    handler:function(){
		if(CheckDataBeforeNoAudit()==true){
			NoAudit();
		}else{
			return;
		}	
    }
});

var calculateButton  = new Ext.Toolbar.Button({
	text:'统计计算',  
    id:'calculateButton', 
    iconCls:'option',
    handler:function(){
		if(CheckDataBeforeCalculate()==true){
			Calculate();
		}else{
			return;
		}	
    }
});

/////////////////按年统计///////////////////
var yearcalButton  = new Ext.Toolbar.Button({
	text:'按年统计',  
	id:'yearcalButton', 
	iconCls:'option',
	handler:function(){
		if(CheckDataBeforeCalculate()==true){
			YearCalculate();
		}else{
			return;
		}	
	}
})

/////////////////执行数据重新导入///////////////////
var exedataButton  = new Ext.Toolbar.Button({
	text:'数据重新导入',  
	id:'exedataButton', 
	iconCls:'option',
	handler:function(){
		if(CheckDataBeforeExeData()==true){
			ExeData();
		}else{
			return;
		}	
	}
})

//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:Url+'?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
	    'compname',
		'rowid',
		'yearmonth',
		'deptdr',
		'deptname',
		'itemcode',
		'itemname',
		'value',
		'datafrom',
		'datafromco',
		'datafromna',
		'chkstate',
		'oprator',
		'optime'
	]),
    remoteSort: true
});


//复选框选择模式  
var checkboxSM = new Ext.grid.CheckboxSelectionModel({  
    checkOnly: false,  
    singleSelect: false  
});  
  
var cellSM = new Ext.grid.CellSelectionModel();  
//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(), 
    checkboxSM,
	{
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
	    id : 'compname',
		header : '医疗单位',
		width : 90,
		dataIndex : 'compname'
	},{
        id:'yearmonth',
        header: '年月',
        editable:true,
        width:100,
        allowBlank: false,
        dataIndex: 'yearmonth'
    },{
        id:'deptdr',
        header: '科室名称',
        width:200,
        dataIndex: 'deptdr',
        allowBlank: false,
		//editor : new Ext.grid.GridEditor(deptnameField),
		renderer :Ext.util.Format.comboRenderer2(deptnameField,"deptdr","deptname")	 
    },{
        id:'itemcode',
        header: '科目名称',
        dataIndex: 'itemcode',
        width:150,
        allowBlank: false,
        edit:false,
		//editor : new Ext.grid.GridEditor(itemdescField),
		renderer :Ext.util.Format.comboRenderer2(itemdescField,"itemcode","itemname")	 
    },{
        id:'datafromco',
        header: '数据来源编码',
        width:120,
		align:'right',
        dataIndex: 'datafromco',
        hidden: true
    },{
        id:'datafrom',
        header: '数据来源',
        width:120,
        //allowBlank: false,
		align:'right',
        dataIndex: 'datafrom',
		//editor : new Ext.grid.GridEditor(datafromField),
		renderer :Ext.util.Format.comboRenderer2(datafromField,"datafrom","datafromna")	 
    },{ 
        id:'value',
        header: '执行金额',
        dataIndex: 'value',
        align:'right',
        width:120,
        allowBlank: false,
		editor : new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true		
		})
    },{
        id:'chkstate',   
        header: '审核状态',
        align:'right',
        width:90,
        editable:false,
        allowBlank: true,
        dataIndex: 'chkstate',
		renderer :Ext.util.Format.comboRenderer(ChkStateStoreField)	 
    },{
        id:'oprator',
        header: '操作员',
        align:'right',
        width:120,
		allowBlank: true,
		editable:false,
        dataIndex: 'oprator'
    },{
        id:'optime',
        header: '操作时间',
        align:'right',
        width:120,
		allowBlank: true,
		editable:false,
        dataIndex: 'optime'
    }
]);

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});


//Ext.grid.EditorGridPanel的 selModel：默认为Ext.grid.CellSelectionModel
var itemGrid = new Ext.grid.EditorGridPanel({
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    atLoad : true, // 是否自动刷新
	tbar:[saveButton,'-',delButton,'-',auditButton,'-',noauditButton,'-',calculateButton,'-',yearcalButton],  //,'-',exedataButton  重新采集数据
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: checkboxSM,
	loadMask: true,
	clicksToEdit : 1, //单击进入编辑模式		            
	bbar:itemGridPagingToolbar,
	listeners : {
	    beforeedit : function(e) {
		    //数据来源编码为"MI" 或者为空，执行金额列可编辑，否则不可编辑 
	        if((e.field=="value")){
		        if((e.record.get("datafromco")== "MI")
			        ||(e.record.get("datafromco")== ""))
			    {
		            return true;
			    }else{
		            return false;
			    }
	        }
	    }
	}
});

itemGridDs.on('beforeload',function(){  
    itemGridDs.baseParams = {
	    yearmonth:yearmonField.getValue()
	    ,deptdr:deptField.getValue()
	    ,datafrom:dataField.getValue()
	    ,typecode:codeField.getValue()
	    ,itemcode:descField.getValue()
		,start:0
		,limit:itemGridPagingToolbar.pageSize
	};  
});

/***********************保存函数*************************/		
function CheckDataBeforeSave() {
	//取到发生变化的记录对象
	var records = itemGridDs.getModifiedRecords();
	if (!records.length) {
		Ext.Msg.show({title:'提示',msg:'没有内容需要保存!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}
	var rtn=0
	//跳出Ext.each循环需要语句return false;
	Ext.each(records, function(r) {
		// 数据完整性验证Beging
		for (var i = 2; i < itemGridCm.getColumnCount() ; i++) {
				var indx = itemGridCm.getColumnId(i)
				var tmobj = itemGridCm.getColumnById(indx)
				if (tmobj != null) {
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")
								|| (parseInt(r.data[indx].toString()) == 0)) {

							var info = "[" + title + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn=-1	
							return false;  //跳出Ext.each循环
						}
					}
				}
		}
		// 数据完整性验证END
	}, this);
	
	if(rtn==0){
		return true;
	}else{
		return false;
	}
		
}

//保存函数		
function saveOrder() {
		var data="";
		var rowCount = itemGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
				var rowData = itemGridDs.getAt(i);	
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					var rowid = rowData.get("rowid");
					var yearmonth=rowData.get("yearmonth");
					var deptdr=rowData.get('deptdr');
					var itemcode=rowData.get('itemcode');
					var value = rowData.get("value");
					var datafrom = rowData.get("datafrom");

					//var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),'Y-m-d');
					var dataStr = rowid+"^"+yearmonth+"^"+deptdr
						+"^"+itemcode+"^"+value+"^"+datafrom
					if(data==""){
						data=dataStr;
					}else{
						data=data+"|"+dataStr;
					}
				}
		}
		//alert(data)
		Ext.Ajax.request({
			url : Url+"?action=save",
			method : 'POST',
			params:{data:data},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGridDs.reload();	
				}else{
					var ret=jsonData.info;
					Ext.Msg.show({title:'错误',msg:'保存失败!Error:'+ret,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},scope : this
		});
}
 	
/***********************删除函数*************************/		
function CheckDataBeforeDel() {
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'提示',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		//检查数据合法性
		for (var i = 0; i < len; i++) {
				var billstate = rowObj[i].get("chkstate");
				var datafromco = rowObj[i].get("datafromco");
				if ((billstate!=="0")||(datafromco!=="MI")){
		        	Ext.Msg.show({title : '警告',msg :"请选择手工录入、未审核单据!",buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return false;
				}
		}	
		return true;
};

function del() {
	    Ext.MessageBox.confirm('提示', '确定要删除选定的数据吗？', function(btn) {
		if (btn == 'yes') {
			var rowObj=itemGrid.getSelectionModel().getSelections();
			//定义并初始化行对象长度变量
			var len = rowObj.length;
			var data="";
			for (var i = 0; i < len; i++) {
				if(data==""){
					data=rowObj[i].get('rowid');
				}else{
					data=data+"^"+rowObj[i].get('rowid');
				}
			}
			Ext.Ajax.request({
					url: Url+'?action=del&data='+data,
					waitMsg : '处理中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
									title : '提示',
									msg : '删除成功',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
							itemGridDs.reload();	
						}else{
							Ext.Msg.show({
									title : '错误',
									msg : '错误信息:'+jsonData.info,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						}
					},
					scope : this
			});
			
		}
	})

};


/***********************审核函数*************************/		
function CheckDataBeforeAudit() {
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'提示',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		//检查数据合法性
		for (var i = 0; i < len; i++) {
				var billstate = rowObj[i].get("chkstate");
				var datafromco = rowObj[i].get("datafromco");
				if ((billstate!=="0")||(datafromco!=="MI")){
		        	Ext.Msg.show({title : '警告',msg :"请选择手工录入、未审核单据!",buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return false;
				}
		}	
		return true;
};

function Audit() {
	    Ext.MessageBox.confirm('提示', '确定要审核选定的数据吗？', function(btn) {
		if (btn == 'yes') {
			var rowObj=itemGrid.getSelectionModel().getSelections();
			//定义并初始化行对象长度变量
			var len = rowObj.length;
			var data="";
			for (var i = 0; i < len; i++) {
				if(data==""){
					data=rowObj[i].get('rowid');
				}else{
					data=data+"^"+rowObj[i].get('rowid');
				}
			}
			Ext.Ajax.request({
					url: Url+'?action=audit&data='+data,
					waitMsg : '处理中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
									title : '提示',
									msg : '审核成功',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
							itemGridDs.reload();	
						}else{
							Ext.Msg.show({
									title : '错误',
									msg : '错误信息:'+jsonData.info,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						}
					},
					scope : this
			});
			
		}
	})

};

/***********************取消审核函数*************************/		
function CheckDataBeforeNoAudit() {
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'提示',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		//检查数据合法性
		for (var i = 0; i < len; i++) {
				var billstate = rowObj[i].get("chkstate");
				var datafromco = rowObj[i].get("datafromco");
				if ((billstate!=="1")||(datafromco!=="MI")){
		        	Ext.Msg.show({title : '警告',msg :"请选择手工录入、已审核单据!",buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return false;
				}
		}	
		return true;
};

function NoAudit() {
	    Ext.MessageBox.confirm('提示', '确定要取消审核选定的数据吗？', function(btn) {
		if (btn == 'yes') {
			var rowObj=itemGrid.getSelectionModel().getSelections();
			//定义并初始化行对象长度变量
			var len = rowObj.length;
			var data="";
			for (var i = 0; i < len; i++) {
				if(data==""){
					data=rowObj[i].get('rowid');
				}else{
					data=data+"^"+rowObj[i].get('rowid');
				}
			}
			Ext.Ajax.request({
					url: Url+'?action=noaudit&data='+data,
					waitMsg : '处理中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
									title : '提示',
									msg : '取消审核成功',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
							itemGridDs.reload();	
						}else{
							Ext.Msg.show({
									title : '错误',
									msg : '错误信息:'+jsonData.info,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						}
					},
					scope : this
			});
			
		}
	})

};

/***********************统计计算函数*************************/		
function CheckDataBeforeCalculate() {
	var yearmonth=yearmonField.getValue();
	if(yearmonth==""){
		Ext.Msg.show({title:'注意',msg:'请选择年月！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		return true;
	}
}

function Calculate() {
	var yearmonth=yearmonField.getValue();
	Ext.MessageBox.confirm('提示','确实要统计记录吗?', function(btn) {
		if (btn == 'yes') {
			var progressBar = Ext.Msg.show({
				title : "执行数据汇总",
				msg : "'数据正在处理中...",
				width : 300,
				wait : true,
				closable : true
			});
			Ext.Ajax.request({
				timeout : 30000000,
				url:Url+'?&action=calculate&yearmonth='+yearmonth,
				waitMsg:'取消中...',
				failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
				Ext.Msg.show({title:'注意',msg:'统计成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}else{
				Ext.Msg.show({title:'错误',msg:'统计失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				},
				scope: this
			});			
		}else{
			return;
		}
	})
};

function YearCalculate() {
	var yearmonth=yearmonField.getValue();
	Ext.MessageBox.confirm('提示','确实要统计记录吗?', function(btn) {
		if (btn == 'yes') {
			var progressBar = Ext.Msg.show({
				title : "执行数据汇总",
				msg : "'数据正在处理中...",
				width : 300,
				wait : true,
				closable : true
			});
			Ext.Ajax.request({
				timeout : 30000000,
				url:Url+'?&action=yearcal&yearmonth='+yearmonth,
				waitMsg:'取消中...',
				failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
				Ext.Msg.show({title:'注意',msg:'统计成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}else{
				Ext.Msg.show({title:'错误',msg:'统计失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				},
				scope: this
			});			
		}else{
			return;
		}
	})
};

/***********************执行数据重新导入函数*************************/		
function CheckBeforeExeData() {
	var yearmonth=yearmonField.getValue();
	if(yearmonth==""){
		Ext.Msg.show({title:'注意',msg:'请选择年月！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else if(datafrom==""){
		Ext.Msg.show({title:'注意',msg:'请选择数据来源！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		return true;
	}
}

function ExeData() {
	
    var yearmonth=yearmonField.getValue();
	var datafrom2=dataField.getRawValue();
	var arr = datafrom2.split("_");
	var datafromname=arr[0];
	var datafrom=arr[1];
	
	var ExeAction="";
	if(datafrom=='HISO'){
		//HIS门、急诊收入
		ExeAction='HISOExeData';
	}else if(datafrom=='HISI'){
		//HIS住院收入
		ExeAction='HCHISIExeData';
	}else if(datafrom=='OPI'){
		//物资入库
		ExeAction='OPIExeData';
	}else if(datafrom=='OP'){
		//物资出库
		ExeAction='OPExeData';
	}else if(datafrom=='HISDI'){
		//HIS药品入库
		ExeAction='HCHISDIExeData';
	}else if(datafrom=='HISD'){
		//HIS药品出库消耗成
		ExeAction='HCHISDExeData';
	}else if(datafrom=='FA'){
		//固定资产
		ExeAction='FAExeData';
	}else if(datafrom=='HR'){
		//人力资源
		ExeAction='HRExeData';
	}else if(datafrom=='U8'){
		//用友
		ExeAction='U8ExeData';
	}else{
		Ext.Msg.show({title:'注意',msg:'此系统不能重新导入！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	Ext.MessageBox.confirm('提示','确实要统计记录吗?', function(btn) {
		if(id=="yes"){
			var progressBar = Ext.Msg.show({
			title : "各系统执行数据重新导入",
			msg : "'数据正在处理中...",
			width : 300,
			wait : true,
			closable : true
			});
			Ext.Ajax.request({
				timeout : 30000000,
				url:Url+'?action='+ExeAction+'&yearmonth='+yearmonth,
				waitMsg:'取消中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'获取成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}else{
						Ext.Msg.show({title:'错误',msg:'获取失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
		}else{
			return;
		}
	})
}