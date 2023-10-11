
var BudgSchemAuditWideHosUrl = '../csp/herp.budg.budgschemauditwidehosexe.csp';

//会计年度
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgSchemAuditWideHosUrl+'?action=yearlist',method:'POST'});
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '会计年度',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//是否是当前审批
var basriscurstepStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','否'],['1','是']]
});
var bsarchkresultStoreField = new Ext.form.ComboBox({
	id: 'basriscurstepStoreField',
	fieldLabel: '是否是当前审批',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: basriscurstepStore,
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

//编制状态
var bsachkstateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','未通过'],['1','通过']]
});
var bsachkstateStoreField = new Ext.form.ComboBox({
	id: 'bsachkstateStoreField',
	fieldLabel: '是否是当前审批',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: bsachkstateStore,
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


var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();

	itemMain.load(({params:{start:0, limit:25,Year:Year}}));
	
	}
});

var itemMain = new dhc.herp.Grid({
    title: '全院年度预算审核',
    //width: 400,
    region : 'north',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgschemauditwidehosexe.csp',
    minSize : 350,
	maxSize : 450,
	height:225,
	/*
	split : true,
	collapsible : true,
	containerScroll : true,
	trackMouseOver : true,
	stripeRows : true,
		sm : new Ext.grid.RowSelectionModel({
		singleSelect : true
	}),
	viewConfig : {forceFit : true},
	*/
	tbar:['会计年度:',yearField,'-',searchButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid'
        //hidden: true
    },{
        id:'bsmcode',
        header: '方案编号',
        dataIndex: 'bsmcode',
        width:75,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'bsmname',
        header: '方案名称',
        dataIndex: 'bsmname',
        width:150,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'bsmorderby',
        header: '编制顺序',
        width:75,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        dataIndex: 'bsmorderby'
		
    }, {
        id:'bidname',
        header: '结果对应预算项',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bidname'	
		
    }, {
        id:'bmsuupschemdr',
        header: '前置方案',
        width:75,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'bmsuupschemdr',
        renderer : function(v, p, r) {
		return '<span style="color:blue;cursor:hand"><u>查询</u></span>';									
        }
	
    }, {
        id:'bsachkstate',
        header: '编制状态',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:false,
		type:bsachkstateStoreField,
        dataIndex: 'bsachkstate'
		
    },{
    	id:'bsachkstep',
        header: '编制步骤',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep'
    },{
    	id:'bcfmchkflowname',
        header: '审批流',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bcfmchkflowname'
    },{
    	id:'bsmfile',
        header: '说明文件',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsmfile'
    },{
    	id:'bsarstepno',
        header: '审批顺序号',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsarstepno',
        hidden: true
        
    },{
    	id:'bsachkstep',
        header: '审批步骤',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep',
        hidden: true
        
    },{
    	id:'basriscurstep',
        header: '是否为当前审批',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'basriscurstep',
        type:bsarchkresultStoreField
        	
    }
	],
	
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	viewConfig : {
		forceFit : true
	},
	
	height:200,
	trackMouseOver: true,
	stripeRows: true

});

itemMain.btnAddHide();  //隐藏增加按钮
itemMain.btnSaveHide();  //隐藏保存按钮
itemMain.btnResetHide();  //隐藏重置按钮
itemMain.btnDeleteHide(); //隐藏删除按钮
itemMain.btnPrintHide();  //隐藏打印按钮

//itemMain.load({
//	params:{start:0, limit:12},
//
//	callback:function(record,options,success ){
//		itemMain.fireEvent('rowclick',this,0);
//	}
//});

itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var bsmDr='';
	var bsmName='';
	var stepno='';
	var chkstep='';
    //alert(rowIndex);
	var selectedRow = itemMain.getSelectionModel().getSelections();
	bsmDr=selectedRow[0].data['bsmcode'];
	bsmName=selectedRow[0].data['bsmname'];
	stepno=selectedRow[0].data['bsarstepno'];
	chkstep=selectedRow[0].data['bsachkstep'];
	//alert(stepno);
	itemDetail.load({params:{start:0, limit:12,Code:bsmDr}});
				
});


//单击gird的单元格事件
itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	if (columnIndex == 7) {
		//alert(columnIndex);
		var records = itemMain.getSelectionModel().getSelections();
		var childid = records[0].get("bsmcode");
		//alert(childid);

		// 维护数据页面
		ChildFun(childid);
		//connectFun(offshootID);
		
	}
});
itemMain.on('rowclick', function() {
	var iscurstep='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	iscurstep=selectedRow[0].data['basriscurstep'];
		if(iscurstep=='0') {
		submitButton.disable();
		}
		else 
		 submitButton.enable();
	}
)


