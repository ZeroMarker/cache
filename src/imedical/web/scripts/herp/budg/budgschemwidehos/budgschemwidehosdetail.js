
var BudgSchemWideHosDetailUrl = '../csp/herp.budg.budgschemwidehosdetailexe.csp';
var UserID = session['LOGON.USERID'];
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

//会计年度
var yearDs1 = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','year'])
});

yearDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgSchemWideHosUrl+'?action=yearlist',method:'POST'});
		});

var yearField1  = new Ext.form.ComboBox({
	id: 'yearField1',
	fieldLabel: '会计年度',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: yearDs1,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField1',
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
/////////////////////科目名称/////////////////////////////
var ItemCodefield = new Ext.form.TextField({
		id: 'ItemCodefield',
		fieldLabel: '科目名称',
		allowBlank: true,
	    //name:'',  
	                valueField: '',
	                value:'',
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});
/////////////////////是否末级/////////////////////////////
var IsLastField = new Ext.form.Checkbox({												
				fieldLabel: '末级'
				});





///查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var BITname=BITnameField.getValue();
	//alert(BITname);
	var itemcode=ItemCodefield.getValue();
	//alert(itemcode)
	var islast =IsLastField.getValue();
	//alert(islast)
	if(islast){	islast = "1"
		}else{
		islast = "0"
		}	
	var selectedRow = itemMain.getSelectionModel().getSelections();
	bsmDr=selectedRow[0].data['bsmcode'];
	var Year=selectedRow[0].data['bsmyear'];
	
	//alert(bsmcode);
	
	itemDetail.load(({params:{start:0, limit:25,Code:bsmDr,Year:Year,BITname:BITname,itemcode:itemcode,islast:islast}}));
	
	}
});


//提交
var submitButton = new Ext.Toolbar.Button({
	text: '提交',
    tooltip:'提交',        
    iconCls:'add',
    handler:function(){
		    
		    var selectedRow = itemMain.getSelectionModel().getSelections();
		    var len = selectedRow.length;
		    if(len < 1){
            	Ext.Msg.show({title:'错误',msg:'请选择对应的方案',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	return false;
        	}
        	var rowIndex = itemMain.getSelectionModel().lastActive;//主表选中的行号
        	
		    var bsmDr=selectedRow[0].data['bsmcode'];
		    var schemAuditDR=selectedRow[0].data['schemAuditDR'];
		    var bsmId=selectedRow[0].data['rowid'];
		    var curstep=selectedRow[0].data['bsachkstep'];
		    var BillState=selectedRow[0].data['bsachkstate'];//1:新建,2:提交,3:通过,4:不通过,5:完成
			if((BillState!=='1')&&(BillState!==''))
			{
				Ext.Msg.show({
						title : '',
						msg : '只有新建状态的单据需要提交',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
				return;
			}
		Ext.MessageBox.confirm('提示', '确定要提交吗？', function(btn) {
		if (btn == 'yes') {
		    var selectidDetail=itemDetail.getStore().getModifiedRecords();
		    for(i=0;i<selectidDetail.length;i++){
		    	var selectedid = selectidDetail[i].get("rowid");
		    	var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
	    	
	    	var uur3 = BudgSchemWideHosDetailUrl+'?action=save&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
	    	itemDetail.saveurl(uur3);
	    	}

	    	var uur2 = BudgSchemWideHosDetailUrl+'?action=submit&&SchemDr='+ bsmId+'&UserID='+UserID+'&schemAuditDR='+schemAuditDR;
	    	itemDetail.saveurl(uur2);
		
	    	itemDetail.load({params:{start:0, limit:25,Code:bsmDr}})
	   		itemMain.load(({params:{start:0, limit:25}}));
	   		backoutButton.enable();
	   		//backoutButton.disable();
			submitButton.disable();
		 	saveButton.disable();
		 	var d = new Ext.util.DelayedTask(function(){  
            	itemMain.getSelectionModel().selectRow(rowIndex);
           	});  
            	d.delay(1000); 
				itemMain.getSelectionModel().selectRow(rowIndex)
       }	
	}); 
	}
	
});
//撤销
var backoutButton = new Ext.Toolbar.Button({
	text: '撤销',
    tooltip:'撤销',        
    iconCls:'add',
    handler:function(){
		    
		    var selectedRow = itemMain.getSelectionModel().getSelections();
		    var len = selectedRow.length;
		    if(len < 1){
            	Ext.Msg.show({title:'错误',msg:'请选择对应的方案',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	return false;
        	}
        	var rowIndex = itemMain.getSelectionModel().lastActive;//主表选中的行号
        	
		    var bsmDr=selectedRow[0].data['bsmcode'];
		    var schemAuditDR=selectedRow[0].data['schemAuditDR'];
		    var BillState=selectedRow[0].data['bsachkstate'];//1:新建,2:提交,3:通过,4:不通过,5:完成
		    var CurStepNO=selectedRow[0].data['CurStepNO'];
		   // alert(CurStepNO)
		    var StepNO=selectedRow[0].data['bsarstepno'];
		   // alert(StepNO)
			if((BillState=='1')&&(BillState==''))
			{
				Ext.Msg.show({title : '',msg : '方案未提交,不能撤销！',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
				return;
			}
			 else if((StepNO<=CurStepNO)&&(BillState!=='1'))
        	{
	        	Ext.MessageBox.confirm('提示', '确定要撤销吗？', function(btn) {
					if (btn == 'yes') {
	       				var uur2 = BudgSchemWideHosDetailUrl+'?action=backout&&UserID='+UserID+'&schemAuditDR='+schemAuditDR;
	    				itemDetail.saveurl(uur2);
	    				itemDetail.load({params:{start:0, limit:25,Code:bsmDr}})
	   					itemMain.load(({params:{start:0, limit:25}}));
	   					backoutButton.disable();
	   					submitButton.enable();
	   					saveButton.enable();
	   					var d = new Ext.util.DelayedTask(function(){  
            				itemMain.getSelectionModel().selectRow(rowIndex);
           				});  
            			d.delay(1000); 
						itemMain.getSelectionModel().selectRow(rowIndex)
	   				}	
				}); 
        	}else if(StepNO=="")
        	{
	        	//表示这个人没有审核权限
	        	Ext.Msg.show({title:'注意',msg:'已审核，不可撤销！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        	return;
        	}else
        	{
	        	Ext.Msg.show({title:'注意',msg:'不是当前权限人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        	return;
        	}
	    	
       }	
	
});
	
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
        var BillState=selectedRow[0].data['bsachkstate'];//1:新建,2:提交,3:通过,4:不通过,5:完成
        //alert(BillState)
		if((BillState!=='1')&&(BillState!==''))
		{
			Ext.Msg.show({
					title : '',
					msg : '已提交或审核，不可修改',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
			return;
		}
		Ext.MessageBox.confirm('提示', '确定要保存吗？', function(btn) {
			if (btn == 'yes') {
	   			bsmDr=selectedRow[0].data['bsmcode'];
	   			bsmId=selectedRow[0].data['rowid'];
	    		curstep=selectedRow[0].data['bsachkstep'];
	    		var selectidDetail=itemDetail.getStore().getModifiedRecords();
	    		for(i=0;i<selectidDetail.length;i++){
	    			var selectedid = selectidDetail[i].get("rowid");
	    			var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
	    			var uur3 = BudgSchemWideHosDetailUrl+'?action=save&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
	    			itemDetail.saveurl(uur3);
	    		}
	    		itemDetail.load({params:{start:0, limit:25,Code:bsmDr}});
	    		var d = new Ext.util.DelayedTask(function(){  
            		itemMain.getSelectionModel().selectRow(rowIndex);
           		});  
            	d.delay(1000); 
				itemMain.getSelectionModel().selectRow(rowIndex)
	    	}	
		});
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
//	viewConfig : {
//		forceFit : true
//	},		
	atLoad: true,
	height : 250,
    //atLoad : true, // 是否自动刷新
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
		//alert(columnIndex)
               var record = grid.getStore().getAt(rowIndex);
                //alert(columnIndex)
                //alert(record.get('bideditmod'));
               // 根据条件设置单元格点击编辑是否可用
               var selectedRow = itemMain.getSelectionModel().getSelections();
               var BillState=selectedRow[0].data['bsachkstate'];//1:新建,2:提交,3:通过,4:不通过,5:完成
               if ((BillState==1)&& (columnIndex ==10)&&((record.get('bideditmod') == '1')||(record.get('bideditmod') == '3'))) {    
                      return true;
               } else 
                      {
                      return false;
                      }
        },        
        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
            var record = grid.getStore().getAt(rowIndex);
            // alert(columnIndex)
            // 根据条件设置单元格点击编辑是否可用
            var selectedRow = itemMain.getSelectionModel().getSelections();
            var BillState=selectedRow[0].data['bsachkstate'];//1:新建,2:提交,3:通过,4:不通过,5:完成
            if ((BillState==1) && (columnIndex ==10)&&((record.get('bideditmod') == '1')||(record.get('bideditmod') == '3'))) {          
                   return true;
            } else 
                   {
                   return false;
                   }
     }
},
    url: 'herp.budg.budgschemwidehosdetailexe.csp',
    
    tbar:['预算项类别:',BITnameField,'-','科目编码:',ItemCodefield,'-','是否末级:',IsLastField,'-',findButton,saveButton,submitButton,backoutButton],
    fields: [
       //new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'Year',
        header: '年度',
        dataIndex: 'Year',
        width:80,
        allowBlank: true,
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
        id:'bfhisvalue',
        header: '参考数据',
        width:150,
		align:'right',
        editable:false,
        allowBlank: true,
        dataIndex: 'bfhisvalue'
		
    }, {
        id:'prebfrealvaluelast',
        header: '前年预算',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false
        ,dataIndex: 'prebfrealvaluelast'
		
    }, {
        id:'prebfrealvaluelastexe',
        header: '前年执行',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'prebfrealvaluelastexe'
		
    }, {
        id:'bfrealvaluelast',
        header: '去年预算',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfrealvaluelast'
		
    }, {
        id:'bfrealvaluelastexe',
        header: '去年执行',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfrealvaluelastexe'
		
    }, {
        id:'bfplanvalue',
        header: '本年度预算',
        align:'right',
        width:150,
		//tip:true,
		allowBlank: true,
		editable:true,
        dataIndex: 'bfplanvalue',
        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
    	    cellmeta.css="cellColor3";
        	var mod = record.data['bideditmod']; 
        	var step = record.data['bsachkstep'];  
                if (((mod == "1")||(mod == "3"))&& ((step=="0")||(step==""))) {
                	cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
                    return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
              }else{
					return '<span style="color:black;cursor:hand">'+value+'</span>';
				}

        	},
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

	

});


//    itemDetail.btnAddHide();  //隐藏增加按钮
//    itemDetail.btnSaveHide();  //隐藏保存按钮
//    itemDetail.btnResetHide();  //隐藏重置按钮
//    itemDetail.btnDeleteHide(); //隐藏删除按钮
//    itemDetail.btnPrintHide();  //隐藏打印按钮

//单击gird的单元格事件
//itemDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
//	 
//	var records = itemDetail.getSelectionModel().getSelections();
//	var offshootID = records[0].get("bmsuupschemdr")
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


