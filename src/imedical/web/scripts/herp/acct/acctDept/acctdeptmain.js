//帐套名称数据源
var unitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.acct.acctdeptexe.csp'+'?action=CalAcctBook&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue()),method:'POST'});
});
var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '帐套名称',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择帐套名称...',
	name: 'unitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//是否当前帐套
var driectStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','否'],['1','是']]
});
var driectField = new Ext.form.ComboBox({
	id: 'driectField',
	fieldLabel: '是否当前帐套',
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
var itemGrid = new dhc.herp.Grid({
        title: '核算部门维护',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctdeptexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
	        id:'rowid',
            header: 'ID',
            dataIndex: 'rowid', //acctdeptID
			edit:false,
            hidden: true
        },{
            id:'AcctBookID',
            header: '帐套名称',
			calunit:true,
			allowBlank: false,
			width:90,
            dataIndex: 'AcctBookID',
			type:unitField
        },{
            id:'deptCode',
            header: '部门编号',
			allowBlank: false,
			width:80,
            dataIndex: 'deptCode'
        },{
            id:'deptName',
            header: '部门名称',
			allowBlank: false,
			width:90,
            dataIndex: 'deptName'
        },{
            id:'isValid',
            header: '是否有效',
			allowBlank:true,
			width:80,
			print:true,
            dataIndex: 'isValid',
            type:driectField
        }] 
});

   // itemGrid.hiddenButton(3);
	//itemGrid.hiddenButton(4);

