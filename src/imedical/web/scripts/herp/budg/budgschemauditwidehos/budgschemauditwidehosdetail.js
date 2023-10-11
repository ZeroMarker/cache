
var BudgSchemAuditWideHosDetailUrl = '../csp/herp.budg.budgschemauditwidehosdetailexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var UserID = session['LOGON.USERID'];


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
	listWidth : 120,
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


//本年度预算
var bfplanvalueField = new Ext.form.TextField({
	id: 'bfplanvalueField',
	//fieldLabel: '本年度预算',
	width:215,
	listWidth : 215,
	name: 'bfplanvalueField',
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
	
		url:BudgSchemAuditWideHosUrl+'?action=yearlist',method:'POST'});
		});

var year1Field  = new Ext.form.ComboBox({
	id: 'year1Field',
	fieldLabel: '会计年度',
	width:100,
	listWidth : 100,
	//allowBlank: false,
	store: year1Ds,
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
	var bsmDr=selectedRow[0].data['bsmcode'];
	var year=selectedRow[0].data['bsmyear'];
	itemDetail.load(({params:{start:0, limit:25,Year:year,Code:bsmDr,BITName:BITname,BIDLevel:BIDlevel,BSDCode:BSDCode}}));
	
	}
});

//审核
var checkButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'add',
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
	

var saveButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'保存',        
    iconCls:'add',
    handler:function(){
	    
	    var selectedRow = itemMain.getSelectionModel().getSelections();
	    var len = selectedRow.length;
		if(len < 1){
           	Ext.Msg.show({title:'错误',msg:'请选择对应的方案',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
           	return false;
        }
        var rowIndex = itemMain.getSelectionModel().lastActive;//主表选中的行号
        
        var IsCurStep = selectedRow[0].get('basriscurstep');
        var checkChkstate = selectedRow[0].get('Chkstate');
        if(checkChkstate==2){
			Ext.Msg.show({title:'错误',msg:"已审核，不能修改！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
        	return;
        }
        if(IsCurStep!==1){
	    	Ext.Msg.show({title:'错误',msg:"不是当前审核人！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});   
        	return;
        }
       	Ext.MessageBox.confirm('提示', '确定要保存吗？', function(btn) {
			if (btn == 'yes') { 
	    		var bsmDr=selectedRow[0].data['bsmcode'];
	    		var selectidDetail=itemDetail.getStore().getModifiedRecords();
	    		for(i=0;i<selectidDetail.length;i++){
	    			var selectedid = selectidDetail[i].get("rowid");
	    			var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
	    			var uur3 = BudgSchemAuditWideHosDetailUrl+'?action=save&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
	    			itemDetail.saveurl(uur3);
	    		}	
	    		var d = new Ext.util.DelayedTask(function(){  
            		itemMain.getSelectionModel().selectRow(rowIndex);
           		});  
            	d.delay(1000); 
				itemMain.getSelectionModel().selectRow(rowIndex)   
	   		itemDetail.load({params:{start:0, limit:25,Code:bsmDr}})
	    	}	
		});
}	
});
	
var itemDetail = new dhc.herp.Gridwolf({
    //title: '',
    region : 'center',   
    layout:"fit",
	split : true,
	collapsible : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
//	viewConfig : {forceFit : true},	
	atLoad: true,
	height : 250,
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
		//alert(columnIndex)
               var record = grid.getStore().getAt(rowIndex);
               var selectedRow = itemMain.getSelectionModel().getSelections();
        	   var stepno=selectedRow[0].data['bsarstepno'];
        	   var StepNO=selectedRow[0].data['StepNO'];
        	   var iscur=selectedRow[0].data['basriscurstep'];
        	   //alert(columnIndex)
               // 根据条件设置单元格点击编辑是否可用
               if ((StepNO == stepno)&&(iscur==1) && (columnIndex == 6)) {    
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
     	    var iscur=selectedRow[0].data['basriscurstep'];
            // 根据条件设置单元格点击编辑是否可用
            if ((StepNO ==stepno)&&(iscur==1)&&(columnIndex == 6) ) {          
                   return false;
            } else 
                   {
                   return true;
                   }
     }
},
    url: 'herp.budg.budgschemauditwidehosdetailexe.csp',
    
    tbar:['预算项类别:',BITnameField,'-','预算项级别:',BIDlevelField,'-','科目编码:',bsdcodeField,'-',findButton,saveButton,checkButton],
    fields: [
       //new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
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
        id:'bfhisvalue',
        header: '参考数据',
        width:150,
		align:'right',
        editable:false,
        allowBlank: true,
        dataIndex: 'bfhisvalue'
		
    }, {
        id:'bfrealvaluelast',
        header: '上年执行',
        align:'right',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfrealvaluelast'
		
    }, {
        id:'bfplanvalue',
        header: '本年度预算',
        width:150,
        align:'right',
		//tip:true,
		allowBlank: true,
		editable:true,
        dataIndex: 'bfplanvalue',
        type:bfplanvalueField
	
    }, {
        id:'sf',
        header: '差额',
        align:'right',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'sf'
		
    },{
    	id:'scf',
        header: '差额率(%)',
        align:'right',
        width:120,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'scf'
    },{
    	id:'bfplanvaluemodimid',
        header: '修改中间数',
        align:'right',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bfplanvaluemodimid'
    },{
    	id:'bsdcalflag',
        header: '编制方法',
        width:200,
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
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep',
        hidden: true
    }
	]
//	,
//	viewConfig : {
//		forceFit : true
//	}
});






