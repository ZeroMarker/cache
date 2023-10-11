var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var unitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue()),method:'POST'});
});

var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '审批人科室',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室类别...',
	name: 'unitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var unituserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),method:'POST'});
});
var unituserField = new Ext.form.ComboBox({
	id: 'unituserField',
	fieldLabel: '审批人',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科审批人名称...',
	name: 'unituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var driectStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['2','否'],['1','是']]
});
var driectField = new Ext.form.ComboBox({
	id: 'driectField',
	fieldLabel: '是否是科主任',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	allowBlank: false,
	store: driectStore,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});

var detailGrid = new dhc.herp.Gridlyf({
        title:'审批流明细',
        region: 'east',
        layout:'fit',
        width:600,
        readerModel:'remote',
        url: 'herp.budg.budgcheckflowdetailexe.csp',
		atLoad : true, // 是否自动刷新
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'checkmainid',
            header: '审批流主表ID',
			edit:false,
			hidden:true,
            dataIndex: 'checkmainid'
        
        },{
            id:'stepno',
            header: '审批顺序号',
			allowBlank: false,
			width:100,
			edit:true,
            dataIndex: 'stepno'
        },{
           id:'procdesc',
            header: '审批功能描述',
			allowBlank: false,
			width:100,
			edit:true,
            dataIndex: 'procdesc'
        },{
            id:'chkname',
            header: '审批人',
			allowBlank: false,
			width:100,
            dataIndex: 'chkname',
            type: unituserField
        },{
           id:'deptname',
            header: '适用科室',
			allowBlank: false,
			width:100,
            dataIndex: 'deptname',
            type:unitField
        },{
            id:'isdirect',
            header: '是否是科主任',
			allowBlank: false,
			width:100,
			listWidth : 100,
			edit:true,
            dataIndex: 'isdirect',
            type:driectField
        }],
        
        atLoad : true, // 是否自动刷新
        trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		viewConfig: {forceFit:true} 
   });
   
