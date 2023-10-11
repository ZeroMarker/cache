
var BudgSchemAuditWideHosDetailUrl = '../csp/herp.budg.budgschemauditwidehosdetailexe.csp';

//var selectedRow = itemMain.getSelectionModel().getSelections();
//bsmName=selectedRow[0].data['bsmname'];

//// 预算方案
//var BSMnameDs = new Ext.data.Store({
//	autoLoad:true,
//	proxy:"",
//	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
//});
//
//BSMnameDs.on('beforeload', function(ds, o){
//	ds.proxy=new Ext.data.HttpProxy({
//	
//		url: BudgSchemAuditWideHosDetailUrl+'?action=bsmnamelist',method:'POST'})
//		});
//
//var BSMnameField = new Ext.form.ComboBox({
//	id: 'BSMnameField',
//	fieldLabel: '预算方案',
//	width:120,
//	listWidth : 245,
//	// allowBlank: false,
//	store: BSMnameDs,
//	valueField: 'code',
//	displayField: 'name',
//	triggerAction: 'all',
//	emptyText:'预算方案...',
//	name: 'BSMnameField',
//	minChars: 1,
//	pageSize: 10,
//	selectOnFocus:true,
//	columnWidth:.15,
//	forceSelection:'true',
//	editable:true
//});


//预算项类别
var BITnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['bitcode','name'])
});

BITnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: BudgSchemAuditWideHosDetailUrl+'?action=bitnamelist',method:'POST'})
		});

var BITnameField = new Ext.form.ComboBox({
	id: 'BITnameField',
	fieldLabel: '预算项类别',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BITnameDs,
	valueField: 'bitcode',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算项类别...',
	name: 'BITnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});


//预算项级别
var BIDlevelDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['name','name'])
});

BIDlevelDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: BudgSchemAuditWideHosDetailUrl+'?action=bidlevellist',method:'POST'})
		});

var BIDlevelField = new Ext.form.ComboBox({
	id: 'BIDlevelField',
	fieldLabel: '预算项级别',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BIDlevelDs,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算项级别...',
	name: 'BIDlevelField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});



//科目编码
var bsdcodeField = new Ext.form.TextField({
	id: 'bsdcodeField',
	fieldLabel: '科目编码',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	//store: yearDs,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'bsdcodeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//编制方法
var bsdcalflagStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','公式计算-按计算公式字段中定义的公式计算数据'],['2','历史数据* 比例系数'],['3','历史数据']]
});
var bsdcalflagStoreField = new Ext.form.ComboBox({
	id: 'bsdcalflagStoreField',
	fieldLabel: '编制方法',
	width:120,
	listWidth : 245,
	selectOnFocus: true,
	allowBlank: false,
	store: bsdcalflagStore,
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

//编制模式
var bideditmodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','自上而下'],['2','自下而上'],['3','上下结合']]
});
var bideditmodStoreField = new Ext.form.ComboBox({
	id: 'bideditmodStoreField',
	fieldLabel: '编制模式',
	width:120,
	listWidth : 245,
	selectOnFocus: true,
	allowBlank: false,
	store: bideditmodStore,
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


//本年度预算
var bfplanvalueField = new Ext.form.NumberField({
	id: 'bfplanvalueField',
	//fieldLabel: '本年度预算',
	width:215,
	listWidth : 215,
	name: 'bfplanvalueField',
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
	
	var BITname=BITnameField.getValue();
	var BIDlevel=BIDlevelField.getValue();
	var BSDCode=bsdcodeField.getValue();
	
	var selectedRow = itemMain.getSelectionModel().getSelections();
	  bsmDr=selectedRow[0].data['bsmcode'];
	
	itemDetail.load(({params:{start:0, limit:25,Code:bsmDr,BITName:BITname,BIDLevel:BIDlevel,BSDCode:BSDCode}}));
	
	}
});

//审核
var submitButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'add',
    handler:function(){
	
	 var selectedRow = itemMain.getSelectionModel().getSelections();
	 bsmDr=selectedRow[0].data['bsmcode'];
	 stepno=selectedRow[0].data['bsarstepno'];
	 chkstep=selectedRow[0].data['bsachkstep'];
	 
     if (stepno==chkstep){	  
    	
	
	    
	    
	   //////////////////////
//	    var selectidDetail=itemDetail.getStore().getModifiedRecords();
//	    for(i=0;i<selectidDetail.length;i++){
//	    	var selectedid = selectidDetail[i].get("rowid");
//	    	var selectedcode = selectidDetail[i].get("bsdcode");
//	    	//alert(selectedRec);
//	    }
	    //alert(selectedid);
	    //alert(selectedcode);
	    
	    auditFun();
    	 
    	 
     }else{
    	 
    	 alert("当前步骤序号与登录人审批步骤序号不同不可操作");
     }
	

}
	
});
	



	
var itemDetail = new dhc.herp.Grid({
    title: '',
    region : 'center',
    
    layout:"fit",
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	viewConfig : {
		forceFit : true
	},		
	loadMask: true,
	atLoad: true,
	height : 250,
	trackMouseOver: true,
	stripeRows: true,

    atLoad : true, // 是否自动刷新
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
		//alert(columnIndex)
               var record = grid.getStore().getAt(rowIndex);
               var selectedRow = itemMain.getSelectionModel().getSelections();
        	   stepno=selectedRow[0].data['bsarstepno'];
        	   chkstep=selectedRow[0].data['bsachkstep'];
        	   //alert(columnIndex)
               // 根据条件设置单元格点击编辑是否可用
               if ((chkstep == stepno) && (columnIndex == 6)) {    
                      return true;
               } else 
                      {
                      return false;
                      }
        },        
        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
            var record = grid.getStore().getAt(rowIndex);
            var selectedRow = itemMain.getSelectionModel().getSelections();
     	   stepno=selectedRow[0].data['bsarstepno'];
            // alert(columnIndex)
            // 根据条件设置单元格点击编辑是否可用
            if ((chkstep ==stepno) && (columnIndex == 6) ) {          
                   return false;
            } else 
                   {
                   return true;
                   }
     }
},
    url: 'herp.budg.budgschemauditwidehosdetailexe.csp',
    
    tbar:['预算项类别:',BITnameField,'-','预算项级别:',BIDlevelField,'-','科目编码:',bsdcodeField,'-',findButton,submitButton,submitButton],
    fields: [
       //new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid'
        //hidden: true
    },{
        id:'bsdcode',
        header: '科目编码',
        dataIndex: 'bsdcode',
        width:75,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'bidname',
        header: '科目名称',
        dataIndex: 'bidname',
        width:150,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'bfhisvalue',
        header: '参考数据',
        width:75,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        dataIndex: 'bfhisvalue'
		
    }, {
        id:'bfrealvaluelast',
        header: '上年执行',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfrealvaluelast'
		
    }, {
        id:'bfplanvalue',
        header: '本年度预算',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:true,
        dataIndex: 'bfplanvalue',
//        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//        	var rd = record.data['rowid']
////        	var mod = record.data['bideditmod']  
////        	var step = record.data['bsachkstep']                     
//        	cellmeta.css="cellColor3";
//                if (rd!="") {
//                      cellmeta.css="cellColor1";// 设置可编辑的单元格背景色
//                       return '<span style="cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
//                } else {
//                       '<span style="cursor:hand"><u></u></span>';
//                }
//        	},
        type:bfplanvalueField
	
    }, {
        id:'sf',
        header: '差额',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'sf'
		
    },{
    	id:'scf',
        header: '差额率（%）',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'scf'
    },{
    	id:'bfplanvaluemodimid',
        header: '修改中间数',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bfplanvaluemodimid'
    },{
    	id:'bsdcalflag',
        header: '编制方法',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsdcalflag',
        type:bsdcalflagStoreField
    },{
    	id:'bideditmod',
        header: '编制模式',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
	    type:bideditmodStoreField,
        dataIndex: 'bideditmod'
    },{
    	id:'bfchkdesc',
        header: '审批意见',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bfchkdesc'
    },{
    	id:'bsdcaldesc',
        header: '参考方法',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsdcaldesc'
    },{
    	id:'bsachkstep',
        header: '审核步骤',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep',
        hidden: true
    }
	]

	

});


    itemDetail.btnAddHide();  //隐藏增加按钮
    itemDetail.btnSaveHide();  //隐藏保存按钮
    itemDetail.btnResetHide();  //隐藏重置按钮
    itemDetail.btnDeleteHide(); //隐藏删除按钮
    itemDetail.btnPrintHide();  //隐藏打印按钮

//单击gird的单元格事件
//itemDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
//	 
//	var a='';
//	var selectedRow = itemDetail.getSelectionModel().getSelections();
//	a= selectedRow[0].data['bsachkstep'];
//	alert (a);
//	//alert(detailID);
//	//alert(columnIndex);
//	// 维护数据
//	if(offshootID!=""){
//	//alert ("a");
//	if (columnIndex == 7) {
//		//alert(columnIndex);
////		var records = itemDetail.getSelectionModel().getSelections();
////		var detailID = records[0].get("rowid")
//
//		// 维护数据页面
//		findFun(offshootID);
//		connectFun(offshootID);
//		
//		
//		var bsmDr='';
//	    //alert(rowIndex);
//		var selectedRow = itemMain.getSelectionModel().getSelections();
//		bsmDr=selectedRow[0].data['bsmcode'];
//		//alert(bsmDr);
//		
//	}
//}
//})


