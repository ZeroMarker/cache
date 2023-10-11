var BudgSchemAuditDeptYearDetailUrl = 'herp.budg.budgschemauditdeptyeardetailexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//预算项类别
var BITnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

BITnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: commonboxUrl+'?action=itemtype&flag=1',method:'POST'})
		});

var BITnameField = new Ext.form.ComboBox({
	id: 'BITnameField',
	fieldLabel: '预算项类别',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BITnameDs,
	valueField: 'code',
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
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['level','level'])
});

BIDlevelDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: commonboxUrl+'?action=itemlev',method:'POST'})
		});

var BIDlevelField = new Ext.form.ComboBox({
	id: 'BIDlevelField',
	fieldLabel: '预算项级别',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BIDlevelDs,
	valueField: 'level',
	displayField: 'level',
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
	listWidth : 145,
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
	data:[['1','公式计算'],['2','历史数据* 比例系数'],['3','历史数据']]
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


//科室预算
var bfvalueField = new Ext.form.TextField({
	id: 'bfvalueField',
	//fieldLabel: '本年度预算',
	width:215,
	listWidth : 215,
	name: 'bfvalueField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "只能输入数字",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//会计年度
var year1Ds  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','year'])
});

year1Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgSchemAuditDeptYearUrl+'?action=yearlist',method:'POST'});
		});

var year1Field  = new Ext.form.ComboBox({
	id: 'year1Field',
	fieldLabel: '会计年度',
	width:100,
	listWidth : 245,
	//allowBlank: false,
	store: year1Ds,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'year1Field',
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
    iconCls:'find',
	handler:function(){
	
	var BITname=BITnameField.getValue();
	var BIDlevel=BIDlevelField.getValue();
	var BSDCode=bsdcodeField.getValue();
	var Year=yearField.getValue();
	var selectedRow = itemMain.getSelectionModel().getSelections();
	  bsmId=selectedRow[0].data['rowid'];
	  bsmDr=selectedRow[0].data['bsmcode'];
	  deptdr=selectedRow[0].data['bsaeditdeptdr'];
	  
	itemDetail.load(({params:{start:0, limit:25,DeptDR:deptdr,Year:Year,Code:bsmId,BITName:BITname,BIDLevel:BIDlevel,BSDCode:BSDCode}}));
	
	}
});

//审核
var checkButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'option',
    handler:function(){
	    var selectedRow = itemMain.getSelectionModel().getSelections();
	  	var len = selectedRow.length;
		if(len < 1){
           	Ext.Msg.show({title:'错误',msg:'请选择对应的方案',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
           	return false;
        }
        var rowIndex = itemMain.getSelectionModel().lastActive;//主表选中的行号
        
	 	var ChkState = selectedRow[0].get('bsachkstate');
	 	var checkChkstate = selectedRow[0].get('Chkstate');
	 	var StepNoS = selectedRow[0].get('bsarstepno');
	 	var StepNoC = selectedRow[0].get('StepNO');
	 	var IsCurStep = selectedRow[0].get('basriscurstep');
        
        if((StepNoS==StepNoC)&&(IsCurStep==1)&&((ChkState=="2")||(ChkState=="3")))
        {
	        auditFun();
	        var d = new Ext.util.DelayedTask(function(){  
            	itemMain.getSelectionModel().selectRow(rowIndex);
           	});  
            d.delay(1000); 
			itemMain.getSelectionModel().selectRow(rowIndex)		
        }else if(checkChkstate==2){
	    	Ext.Msg.show({title:'错误',msg:"不可重复审核！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
        	return;
        }else if(StepNoS!==StepNoC){
	    	Ext.Msg.show({title:'错误',msg:"不是权限指定的审核人！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});   
        	return;
        }else if(IsCurStep!==1){
	    	Ext.Msg.show({title:'错误',msg:"不是当前审核人！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});   
        	return;
        }
	
}});
	

//保存
var saveButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'保存',        
    iconCls:'save',
    handler:function(){
	
	 var selectedRow = itemMain.getSelectionModel().getSelections();
	 bsmDr=selectedRow[0].data['bsmcode'];
	 deptdr=selectedRow[0].data['bsaeditdeptdr'];
	 stepno=selectedRow[0].data['bsarstepno'];
	 chkstep=selectedRow[0].data['bsachkstep'];
	 
	 var selectidDetail=itemDetail.getStore().getModifiedRecords();
	    for(i=0;i<selectidDetail.length;i++){
	    	var selectedid = selectidDetail[i].get("rowid");
	    	var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
	    	var uur3 = BudgSchemAuditDeptYearDetailUrl+'?action=submit3&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
	    	itemDetail.saveurl(uur3);
	    }	

}	
});
	
var itemDetail = new dhc.herp.Gridwolf({
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
	atLoad: true,
	height : 250,
	/*
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
		//alert(columnIndex)
               var record = grid.getStore().getAt(rowIndex);
               var selectedRow = itemMain.getSelectionModel().getSelections();
        	   stepno=selectedRow[0].data['bsarstepno'];
        	   StepNO=selectedRow[0].data['StepNO'];
        	   //alert(columnIndex)     	   
    			//alert(stepno)
        	   
               // 根据条件设置单元格点击编辑是否可用
               if ((StepNO == stepno) &&((iscurstep=='1')||(iscurstep==''))&& ((columnIndex == 5)||(columnIndex == 6))) {    
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
     	   	StepNO=selectedRow[0].data['StepNO'];
     	   	bsachkstep=selectedRow[0].data['bsachkstep'];
            // alert(columnIndex)
            // 根据条件设置单元格点击编辑是否可用
            if (((StepNO ==stepno)||(bsachkstep<99))&&((iscurstep=='1')||(iscurstep=='')) && ((columnIndex == 5)||(columnIndex == 6)) ) {          
                   return true;
            } else 
                   {
                   return false;
                   }
     }//'年度:',year1Field,'-',
    },
    */
    url: 'herp.budg.budgschemauditdeptyeardetailexe.csp',   
    tbar:['预算项类别:',BITnameField,'预算项级别:',BIDlevelField,'-','科目编码:',bsdcodeField,'-',findButton,checkButton],
    fields: [
       //new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'Year',
        header: '年度',
        dataIndex: 'Year',
        width:80,
		editable:false,
		hidden: false
    },{
        id:'bsdcode',
        header: '科目编码',
        dataIndex: 'bsdcode',
        width:120,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'bidname',
        header: '科目名称',
        dataIndex: 'bidname',
        width:250,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
		id : 'PreLastPlanValue',
		header : '前年预算',
		width : 80,
		editable : false,
		xtype:'numbercolumn',
		align : 'right',
		dataIndex : 'PreLastPlanValue'
	}, {
		id : 'PreLast9ExeValue',
		header : '前年执行',
		width : 80,
		editable : false,
		xtype:'numbercolumn',
		align : 'right',
		dataIndex : 'PreLast9ExeValue'
	}, {
		id : 'LastPlanValue',
		header : '去年预算',
		width : 80,
		editable : false,
		xtype:'numbercolumn',
		align : 'right',
		dataIndex : 'LastPlanValue'
	}, {
		id : 'Last9ExeValue',
		header : '去年1-9月执行',
		width : 100,
		xtype:'numbercolumn',
		editable : false,
		align : 'right',
		dataIndex : 'Last9ExeValue'
	},{
        id:'bfcalcvalue',   
        header: '全院下达',
        align:'right',
        width:150,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        dataIndex: 'bfcalcvalue'		
    },{
        id:'bfplanvalue',
        header: '科室预算',
        width:150,
		//tip:true,
		allowBlank: true,
		align:'right',
		editable:false,
        dataIndex: 'bfplanvalue',
        type:bfvalueField	
    }, {
        id:'sf1',
        header: '差额',
        align:'right',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'sf1'	
    },{
    	id:'scf1',
        header: '差额率(%)',
        align:'right',
        width:120,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'scf1'
    },{
        id:'bfrealvaluelast',
        align:'right',
        header: '上年执行',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfrealvaluelast'
		
    }, {
        id:'sf2',
        header: '差额',
        align:'right',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'sf2'
		
    },{
    	id:'scf2',
        header: '差额率(%)',
        align:'right',
        width:120,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'scf2'
    },{
    	id:'bfplanvaluemodimid',
    	align:'right',
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
	    hidden:true,
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
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep',
        hidden: true
    }
	]
});