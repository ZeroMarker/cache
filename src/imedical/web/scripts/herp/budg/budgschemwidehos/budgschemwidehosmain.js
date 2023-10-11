
var BudgSchemWideHosUrl = '../csp/herp.budg.budgschemwidehosexe.csp';
var UserID = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//会计年度
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=year',method:'POST'});
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


//var schemNo = new Ext.form.TextField({
//	columnWidth : .1,
//	width : 70,
//	columnWidth : .12,
//	selectOnFocus : true
//
//});
/*
var queryPanel = new Ext.FormPanel({
    height : 205,
    region : 'north',
    frame : true,

    defaults : {
    bodyStyle : 'padding:5px'
},
    items : [{
    xtype : 'panel',
    layout : "column",
    items : [{
	xtype : 'displayfield',
	value : '<center><p style="font-weight:bold;font-size:110%"></p></center>',
	columnWidth : 1,
	height : '25'
}]
}, {
    columnWidth : 1,
    xtype : 'panel',
    layout : "column",
    items : [

        {
			xtype : 'displayfield',
			value : '会计年度:',
			columnWidth : .03
		}, yearField,

		{
			xtype : 'displayfield',
			value : '',
			columnWidth : .02
		}, 
		{
			columnWidth:.05,
			xtype:'button',
			text: '查询',
			handler:function(){
			var Year = yearField.getValue();
			//var schName = schemNo.getValue();

			itemMain.load({
						params : {
							start : 0,
							limit : 25,
							Year : Year
						}
					});
	    },
		iconCls: 'add'
		}

]
}]
});
	*/


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
	data:[['1','新建'],['2','提交'],['3','通过'],['4','完成']]
});
var bsachkstateStoreField = new Ext.form.ComboBox({
	id: 'bsachkstateStoreField',
	fieldLabel: '编制状态',
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
	forceSelection:true,
	renderer : function(v, p, r) {
		return '<span style="color:blue;cursor:hand"><u>'+v+'</u></span>';}
});

var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();

	itemMain.load(({params:{start:0, limit:25,Year:Year,UserID:UserID}}));
	//itemDetail.load(({params:{start:0, limit:25,Code:bsmDr,BITname:BITname}}));
	
	}
});

var itemMain = new dhc.herp.Grid({
    title: '全院年度预算编制',
    //width: 400,
    region : 'north',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgschemwidehosexe.csp',
    minSize : 350,
	maxSize : 450,
	//height:225,
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
        dataIndex: 'rowid',
        hidden: true
    },{
	     id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
                     dataIndex : 'CompName',
                     hidden: true

	    },{
        id:'bsmyear',
        header: '年度',
        dataIndex: 'bsmyear',
        width:80,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
        id:'bsmcode',
        header: '方案编号',
        dataIndex: 'bsmcode',
        width:120,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'bsmname',
        header: '方案名称',
        dataIndex: 'bsmname',
        width:250,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'bsmorderby',
        header: '编制顺序',
        width:100,
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
        width:100,
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
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
		css : 'color: blue; ', 
		type:bsachkstateStoreField,
        dataIndex: 'bsachkstate'
		
    },{
    	id:'bsachkstep',
        header: '编制步骤',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep'
    },{
    	id:'bcfmchkflowname',
        header: '审批流',
        width:100,
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
    	id:'basriscurstep',
        header: '是否为当前审批',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'basriscurstep',
        hidden: true,
        type:bsarchkresultStoreField
        	
    },{
    	id:'schemAuditDR',
        header: '方案归口表ID',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    hidden: true,
        dataIndex: 'schemAuditDR',
        type:bsarchkresultStoreField
        	
    },{
    	id:'CurStepNO',
        header: '当前审批顺序号',
        width:110,
	    editable:false,
	    hidden: true,
        dataIndex: 'CurStepNO'
        	
    },{
    	id:'bsarstepno',
        header: '本人审批顺序号',
        width:110,
	    editable:false,
	    hidden: true,
        dataIndex: 'bsarstepno'
        	
    },{
    	id:'StepNO',
        header: '本人审批流顺序号',
        width:150,
	    editable:false,
	    hidden: true,
        dataIndex: 'StepNO'
        	
    }],
	
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
//	viewConfig : {
//		forceFit : true
//	},
	
	height:230,
	trackMouseOver: true,
	stripeRows: true

});

itemMain.load(({params:{start:0, limit:25,UserID:UserID}}));

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

//单击gird的单元格事件
itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	if (columnIndex == 9) {
		//alert(columnIndex);
		var records = itemMain.getSelectionModel().getSelections();
		var childid = records[0].get("rowid");
		//alert(childid);

		// 维护数据页面
		ChildFun(childid);
		//connectFun(offshootID);	
	}
	if (columnIndex == 10) {
		var records = itemMain.getSelectionModel().getSelections();
		var schemAuditDR = records[0].get("schemAuditDR");
		var schemDr =  records[0].get("rowid");
		schemastatefun(schemAuditDR,UserID,schemDr);
		}
	
	var bsmDr='';
	var bsmName='';
	var chkstep='';
	var iscurstep='';
	
	var selectedRow = itemMain.getSelectionModel().getSelections();
	bsmDr=selectedRow[0].data['bsmcode'];
	bsmName=selectedRow[0].data['bsmname'];
	chkstep=selectedRow[0].data['bsachkstep'];
	iscurstep=selectedRow[0].data['basriscurstep'];
	var year=selectedRow[0].data['bsmyear'];
	//alert(bsmDr);
	itemDetail.load({params:{start:0, limit:12,Code:bsmDr,Year:year}});
	
});
itemMain.on('rowclick', function() {
	var iscurstep='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	var iscurstep=selectedRow[0].data['basriscurstep'];
	var StepNO=selectedRow[0].data['bsarstepno'];  //审批顺序号
	var CurStepNO=selectedRow[0].data['CurStepNO'];
	var bsachkstep=selectedRow[0].data['bsachkstep'];
	var BillState=selectedRow[0].data['bsachkstate'];
		if(BillState=='2'){
			backoutButton.enable();
			saveButton.disable();
		 	submitButton.disable()
		}
		if((StepNO>=CurStepNO)&&(BillState!=='1')&&((StepNO!=="")&&(CurStepNO!==""))) {
			backoutButton.enable();
			submitButton.disable();
		 	saveButton.disable();
		}if(BillState=='1'){
			backoutButton.disable();
			submitButton.enable();
		 	saveButton.enable();
		}
		 
	}
)
