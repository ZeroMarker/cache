var BudgSchemAuditDeptYearUrl = 'herp.budg.budgschemauditdeptyearexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var UserID = session['LOGON.USERID'];
//alert(UserID);
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
	width:120,
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
	editable:true,
			listeners:{
            "select":function(combo,record,index){
	            BSMnameDs.removeAll();     
				BSMnameField.setValue('');
				BSMnameDs.proxy = new Ext.data.HttpProxy({url:BudgSchemAuditDeptYearUrl+'?action=bsmnamelist&&UserID='+ UserID+'&year='+combo.value,method:'POST'})  
				BSMnameDs.load({params:{start:0,limit:10}});      					
			}
	   }
});

//预算方案
var BSMnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

BSMnameDs.on('beforeload', function(ds, o){
	var year =yearField.getValue();
	ds.proxy=new Ext.data.HttpProxy({
	
		url: BudgSchemAuditDeptYearUrl+'?action=bsmnamelist&&UserID='+ UserID+'&year='+year,method:'POST'})
		});

var BSMnameField = new Ext.form.ComboBox({
	id: 'BSMnameField',
	fieldLabel: '方案名称',
	width:150,
	listWidth : 245,
	// allowBlank: false,
	store: BSMnameDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算方案...',
	name: 'BSMnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});


//是否是当前审批
var IscurStepStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','否'],['1','是']]
});
var IscurStepField = new Ext.form.ComboBox({
	id: 'IscurStepField',
	fieldLabel: '是否是当前审批',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: IscurStepStore,
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
	forceSelection:true
});
//审核状态
var ChkstateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','等待审批'],['2','同意'],['3','不同意']]
});
var ChkstateField = new Ext.form.ComboBox({
	id: 'Chkstate',
	fieldLabel: '审核状态',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: ChkstateStore,
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

//查询
var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();
	var BSMname=BSMnameField.getValue();
	
	//alert(UserID);
	
	if((BSMname=="")||(Year=="")){
		Ext.Msg.show({title:'注意',msg:'请选择年度和编制方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}

	itemMain.load(({params:{start:0, limit:25,Year:Year,BSMName:BSMname,UserID:UserID}}));
	
	}
});

var itemMain = new dhc.herp.Grid({
    title: '科室年度预算审核',
    //width: 400,
    region : 'north',
    //atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgschemauditdeptyearexe.csp',
    minSize : 350,
	maxSize : 450,
	height:225,

	tbar:['会计年度:',yearField,'-','方案名称:',BSMnameField,'-',searchButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
	    id : 'CompName',
	    header : '医疗单位',
        width : 90,
	    editable : false,
	    hidden: true,
        dataIndex : 'CompName'

	},{
        id:'bsmcode',
        header: '方案编号',
        dataIndex: 'bsmcode',
        width:120,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: true
    },{
        id:'bsaeditdeptdr',
        header: '科室ID',
        dataIndex: 'bsaeditdeptdr',
        width:150,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: true
    },{ 
        id:'bdeptname',
        header: '科室名称',
        dataIndex: 'bdeptname',
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
		css:'color:blue;',
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
    	id:'basriscurstep',
        header: '是否为当前审批',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'basriscurstep',
        type:IscurStepField
        	
    },{
    	id:'StepNO',
        header: '审批人审批号',
        width:110,   
	    editable:false,
	    update:true,
        dataIndex: 'StepNO',
        hidden:true
        	
    },{
    	id:'schemAuditDR',
        header: '方案归口表ID',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    hidden: true,
        dataIndex: 'schemAuditDR'
        	
    },{
    	id:'Chkstate',
        header: '本人审批状态',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    hidden: true,
        dataIndex: 'Chkstate',
        type:ChkstateField
        	
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

itemMain.btnAddHide();  //隐藏增加按钮
itemMain.btnSaveHide();  //隐藏保存按钮
itemMain.btnResetHide();  //隐藏重置按钮
itemMain.btnDeleteHide(); //隐藏删除按钮
itemMain.btnPrintHide();  //隐藏打印按钮



itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var bsmDr='';
	var bsmId='';
	var stepno='';
	var chkstep='';
	var deptdr='';
    //alert(rowIndex);
	var selectedRow = itemMain.getSelectionModel().getSelections();
	bsmId=selectedRow[0].data['rowid'];
	bsmDr=selectedRow[0].data['bsmcode'];
	stepno=selectedRow[0].data['bsarstepno'];
	chkstep=selectedRow[0].data['bsachkstep'];
	deptdr=selectedRow[0].data['bsaeditdeptdr'];
	var Year=yearField.getValue();
	var BITname=BITnameField.getValue();
	var BIDlevel=BIDlevelField.getValue();
	var BSDCode=bsdcodeField.getValue();
	//alert(Year);
	itemDetail.load({params:{start:0, limit:12,DeptDR:deptdr,Year:Year,BITName:BITname,BIDLevel:BIDlevel,BSDCode:BSDCode,SchemDR:bsmId}});
				
});


//单击gird的单元格事件
itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	if (columnIndex == 9) {
	
		var records = itemMain.getSelectionModel().getSelections();
		var childid = records[0].get("rowid");
		//alert(childid);
		
		// 维护数据页面
		ChildFun(childid);
		//connectFun(offshootID);
		
	}
	if (columnIndex == 10){
		
		var records = itemMain.getSelectionModel().getSelections();
		var schemAuditDR = records[0].get("schemAuditDR");
		var schemDr =  records[0].get("rowid");
		schemastatefun(schemAuditDR,UserID,schemDr);
		}
});
itemMain.on('rowclick', function() {

	var selectedRow = itemMain.getSelectionModel().getSelections();

	var selectedRow = itemMain.getSelectionModel().getSelections();
	var iscurstep=selectedRow[0].data['basriscurstep'];
	var bsarstepno=selectedRow[0].data['bsarstepno'];  //审批顺序号
	var StepNO=selectedRow[0].data['StepNO'];
	var bsachkstep=selectedRow[0].data['bsachkstep'];

		if(bsachkstep==99){
		 checkButton.disable(),
		 saveButton.disable();
		 }
		else if((bsarstepno=StepNO)&&(iscurstep=='1')) {
		checkButton.enable(),
		saveButton.enable();
		}
		else {
		 checkButton.disable(),
		 saveButton.disable();
		 }
})


