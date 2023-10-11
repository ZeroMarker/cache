//////////////////////////////////////////////////
var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
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
var U8field = new Ext.form.TextField({
		id: 'U8field',
		fieldLabel: '其他系统科室编码',
		allowBlank: true,
		emptyText:'编码或者名称...',
		width:100,
	    listWidth : 100
	});
///////////////////////预算科室类别/////////////////////////////////
			var bonusTargetTypeDs = new Ext.data.Store({
				proxy: "",
				reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
			});
			bonusTargetTypeDs.on('beforeload', function(ds, o){
		
				ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=deptType',method:'POST'});
		
			});
			var TypeCodeField = new Ext.form.ComboBox({
				fieldLabel : '预算科室类别',
				width : 120,
				allowBlank : true,
				store : bonusTargetTypeDs,
				displayField:'name',
				valueField:'rowid',
				typeAhead: true,
				forceSelection: true,
				triggerAction: 'all',
				emptyText:'请选择...',
				width: 200,
				listWidth : 245,
				pageSize: 10,
				minChars: 1,
				selectOnFocus:true
			});
			
///////////////////////预算科室名称///////////////////////////
var HerpDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['code','name1'])
	});
	HerpDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=dept',method:'POST'});
		
	});
	var HerpCombo = new Ext.form.ComboBox({
		fieldLabel:'预算科室',
		store: HerpDs,
		displayField:'name1',
		valueField:'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'请选择...',
		width: 200,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});
///////////////////////预算科室名称///////////////////////////
var Herp2Ds = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['name1','name1'])
	});
	Herp2Ds.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=dept',method:'POST'});
		
	});
	var Herp2Combo = new Ext.form.ComboBox({
		fieldLabel:'预算科室',
		store: Herp2Ds,
		displayField:'name1',
		valueField:'name1',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'请选择...',
		width: 200,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

///////////////////////预算科室名称///////////////////////////
var Herp2Ds = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['name1','name1'])
	});
	Herp2Ds.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=dept',method:'POST'});
		
	});
	var Herp2Combo = new Ext.form.ComboBox({
		fieldLabel:'预算科室',
		store: Herp2Ds,
		displayField:'name1',
		valueField:'name1',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'请选择...',
		width: 200,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

//获取数据来源
var dataDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});
dataDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=data&str='+encodeURIComponent(Ext.getCmp('dataField').getRawValue()),method:'POST'});
});
var dataField = new Ext.form.ComboBox({
	id: 'dataField',
	fieldLabel: '数据来源',
	width:100,
	listWidth : 300,
	//allowBlank: false,
	store: dataDs,
	valueField: 'code',
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
//获取数据来源
var datafromDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});
datafromDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=data&str='+encodeURIComponent(Ext.getCmp('datafromField').getRawValue()),method:'POST'});
});
var datafromField = new Ext.form.ComboBox({
	id: 'datafromField',
	fieldLabel: '数据来源',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: datafromDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择数据来源...',
	name: 'datafromField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//获取科室部门类别
var DeptTypeDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['id','name'])
});
DeptTypeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgsubjcontrastexe.csp'+'?action=depttype&str='+encodeURIComponent(Ext.getCmp('DeptTypeField').getRawValue()),method:'POST'});
});
var DeptTypeField = new Ext.form.ComboBox({
	id: 'DeptTypeField',
	fieldLabel: '科室部门类别',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: DeptTypeDs,
	valueField: 'id',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'DeptTypeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
                           
		var CodeU=U8field.getValue();
		var TypeH=TypeCodeField.getValue();
		var CodeH=HerpCombo.getValue();
		var SYSNo=dataField.getValue();
		itemGrid.load({params:{start:0, limit:25, CodeU:CodeU, TypeH:TypeH, CodeH:CodeH,SYSNo:SYSNo}});
	}
});		


var itemGrid = new dhc.herp.Grid({
        title: '其他系统科室与预算科室对照关系',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: 'herp.budg.budgu8herpexe.csp',
		atLoad : true, // 是否自动刷新 rowid^CodeU^NameU^CodeH^NameH
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        },{
	        id : 'CompName',
	        header : '医疗单位',
            width : 90,
            dataIndex : 'CompName',
			editable:false,
            hidden: false
	    }, {
            id:'SYSNo',
            header: '对应系统',
			allowBlank: false,
			width:150,
            dataIndex: 'SYSNo',
            type:datafromField
        },{
            id:'TypeU',
            header: '对应类别',
			width:60,
            dataIndex: 'TypeU',
			editable:false            
        }, {
            id:'CodeU',
            header: '其他系统科室编码',
			allowBlank: false,
			width:210,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['flag']
							if (sf == "新") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
            dataIndex: 'CodeU'
        },{
           id:'NameU',
            header: '其他系统科室名称',
			allowBlank: false,
			width:200,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['flag']
							if (sf == "新") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
            dataIndex: 'NameU'
        },{
            id:'CodeH',
            header: '预算科室编码',
			width:120,
			hidden:true,
            dataIndex: 'CodeH'
        },{
            id:'TypeH',
            header: '预算科室类别',
			allowBlank: true,
			width:120,
			editable:false,
            dataIndex: 'TypeH'
        },{
            id:'NameH',
            header: '预算科室名称',
			allowBlank: true,
			width:250,
            dataIndex: 'NameH',
            editable:true,
			type:Herp2Combo
        },{
            id:'DTypeID',
            header: '执行部门类别',
			allowBlank: false,
			width:100,
            dataIndex: 'DTypeID',
            editable:true,
			type:DeptTypeField
        },{
            id:'flag',
            header: '标记',
			width:100,
            dataIndex: 'flag',
            hidden:true
        }],
    tbar:['系统:',dataField,'-','其他科室:',U8field,'-','预算科室类别:',TypeCodeField,'-','预算科室名称:',HerpCombo,'-',findButton]
    });
    
	itemGrid.btnResetHide() 	//隐藏重置按钮
	itemGrid.btnPrintHide() 	//隐藏打印按钮