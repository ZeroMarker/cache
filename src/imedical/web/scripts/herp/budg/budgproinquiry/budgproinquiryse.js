
var BudgProInquirySEUrl = '../csp/herp.budg.budgproinquiryseexe.csp';

var UserID = session['LOGON.USERID'];


////预算项名称
//var BIDNameDs = new Ext.data.Store({
//	autoLoad:true,
//	proxy:"",
//	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['bitcode','name'])
//});
//
//BIDNameDs.on('beforeload', function(ds, o){
//	ds.proxy=new Ext.data.HttpProxy({
//	
//		url: BudgProAdditionalAuditDetailUrl+'?action=bidnamelist',method:'POST'})
//		});
//
//var BIDNameField = new Ext.form.ComboBox({
//	id: 'BIDNameField',
//	fieldLabel: '预算项名称',
//	width:120,
//	listWidth : 245,
//	// allowBlank: false,
//	store: BIDNameDs,
//	valueField: 'bitcode',
//	displayField: 'name',
//	triggerAction: 'all',
//	emptyText:'预算项名称...',
//	name: 'BIDNameField',
//	minChars: 1,
//	pageSize: 10,
//	selectOnFocus:true,
//	columnWidth:.15,
//	forceSelection:'true',
//	editable:true
//});

////本年度预算
//var bfplanvalueField = new Ext.form.NumberField({
//	id: 'bfplanvalueField',
//	//fieldLabel: '本年度预算',
//	width:215,
//	listWidth : 215,
//	name: 'bfplanvalueField',
//	minChars: 1,
//	pageSize: 10,
//	selectOnFocus:true,
//	forceSelection:'true',
//	editable:true
//});

	
var itemSE = new dhc.herp.Gridwolf({
    title: '',
    region : 'east',
    width:300,
    layout:"fit",
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
//	viewConfig : {
//		forceFit : true
//	},		
	loadMask: true,
	atLoad: true,
	height : 250,
	trackMouseOver: true,
	stripeRows: true,

    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgproinquiryseexe.csp',
    
    tbar:[],
    fields: [
//       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'bpitemcode',
        header: '预算向编码',
        dataIndex: 'bpitemcode',
        width:100,
        update:true,
        allowBlank: true,
		editable:false
    },{ 
        id:'bidlevel',
        header: '预算项级别',
        dataIndex: 'bidlevel',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: true
    }, {
        id:'bidname',
        header: '预算项名称',
        width:250,
        editable:false,
        allowBlank: true,
        dataIndex: 'bidname'
		
    }, {
        id:'bidislast',
        header: '是否末级',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bidislast',
        hidden: true
		
    }, {
        id:'bpbudgvalue',
        header: '预算金额',
        align:'right',
        width:120,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'bpbudgvalue'
    }
	]
//	,
//	viewConfig : {
//		forceFit : true
//	}
});

//itemDetail.btnAddHide();  //隐藏增加按钮
//itemDetail.btnSaveHide();  //隐藏保存按钮
//itemDetail.btnResetHide();  //隐藏重置按钮
//itemDetail.btnDeleteHide(); //隐藏删除按钮
//itemDetail.btnPrintHide();  //隐藏打印按钮







