var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var BudgProAdditionalAuditUrl = '../csp/herp.budg.budgproadditionalauditmainexe.csp';
var UserID = session['LOGON.USERID'];

//立项年度
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
	width:100,
	listWidth : 200,
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

//责任科室
var deptDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgProAdditionalAuditUrl+'?action=deptlist&&UserID='+ UserID,method:'POST'});
		});

var deptField  = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '责任科室',
	width:100,
	listWidth : 200,
	//allowBlank: false,
	store: deptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//项目名称
var projectnameDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['name','name'])
});

projectnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgProAdditionalAuditUrl+'?action=projectnamelist&&UserID='+ UserID,method:'POST'});
		});

var projectnameField  = new Ext.form.ComboBox({
	id: 'projectnameField',
	fieldLabel: '项目名称',
	width:100,
	listWidth : 225,
	//allowBlank: false,
	store: projectnameDs,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择项目...',
	name: 'projectnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//资金来源类型   
var fundrestypeStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','财政资金'],['2','预算外资金'],['3','其他资金']]
});
var fundrestypeStoreField = new Ext.form.ComboBox({
	id: 'fundrestypeStoreField',
	fieldLabel: '资金来源类型',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store:fundrestypeStore,
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

//项目状态
var stateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','新建'],['1','执行'],['2','完成'],['3','取消']]
});
var stateStoreField = new Ext.form.ComboBox({
	id: 'stateStoreField',
	fieldLabel: '项目状态',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: stateStore,
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

//审批状态  
var chkstateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','待提交'],['1','提交'],['2','审核通过']]
});
var chkstateStoreField = new Ext.form.ComboBox({
	id: 'chkstateStoreField',
	fieldLabel: '审批状态',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: chkstateStore,
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
    iconCls:'find',
	handler:function(){
	
	var Year=yearField.getValue();
	var Dept=deptField.getValue();
	var ProjectName=projectnameField.getValue();
    itemDetail.getStore().removeAll();
	itemMain.load(({params:{start:0, limit:25,Year:Year,Dept:Dept,ProjectName:ProjectName,UserID:UserID}}));
	
	}
});

var auditButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'option',
	handler:function(){
	var rowObj=itemMain.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择审核的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var rowid = rowObj[0].get("rowid");
		var parowid = rowObj[0].get("parowid");
		var pachkstate = rowObj[0].get("pachkstate");
	}
	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("pachkstate")!="1")
		   {     
			      Ext.Msg.show({title:'注意',msg:'未提交或已审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		   if(rowObj[j].get("IsAudit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有审核权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	
	//var selectidDetail=itemDetail.getStore().getModifiedRecords();
	//if(selectidDetail.length<"1") 
	//if(itemDetail.getStore().getCount()<2)
	//{     
	 //     Ext.Msg.show({title:'注意',msg:'项目明细为空，不能进行“审核”!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	  //     return;
	  //    }
	
	function handler(id){
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgproadditionalauditmainexe.csp?action=audit&RowID='+rowObj[i].get("rowid")+'&PArowid='+rowObj[i].get("parowid")+'&UserID='+UserID,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							// itemDetail.load(({params:{start:0, limit:25}}));
							 itemMain.load(({params:{start:0, limit:25,UserID:UserID}}));
						}else{
							Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要审核吗?',handler);
}
});


var cancleauditButton = new Ext.Toolbar.Button({
	text: '取消审核',
    tooltip:'取消审核',        
    iconCls:'remove',
	handler:function(){
	var rowObj=itemMain.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择取消审核的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var rowid = rowObj[0].get("rowid");
		var parowid = rowObj[0].get("parowid");
		var pachkstate = rowObj[0].get("pachkstate");
	}
	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("pachkstate")!="2")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不是“审核”状态,不能进行“取消审核”!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		   if(rowObj[j].get("IsAudit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有取消审核权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	
	//var selectidDetail=itemDetail.getStore().getModifiedRecords();
	//if(selectidDetail.length<"1") 
	//{     
	//      Ext.Msg.show({title:'注意',msg:'子表为空，不能进行“取消审核”!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	//       return;
	//       }
	
	function handler(id){
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgproadditionalauditmainexe.csp?action=cancelaudit&RowID='+rowObj[i].get("rowid")+'&PArowid='+rowObj[i].get("parowid")+'&UserID='+UserID,
					waitMsg:'取消审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'取消审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							// itemDetail.load(({params:{start:0, limit:25}}));
							 itemMain.load(({params:{start:0, limit:25,UserID:UserID}}));
						}else{
							Ext.Msg.show({title:'错误',msg:'取消审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要取消审核吗?',handler);
}
});

var itemMain = new dhc.herp.Grid({
    title: '项目预算审核',
    //width: 400,
    region : 'north',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgproadditionalauditmainexe.csp',
    minSize : 350,
	maxSize : 450,
	height:225,
	
	tbar:['立项年度:',yearField,'-','责任科室:',deptField,'-','项目名称:',projectnameField,'-',searchButton,'-',auditButton,'-',cancleauditButton],
	
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
         dataIndex : 'CompName'

	    },{
        id:'projyear',
        header: '立项年度',
        dataIndex: 'projyear',
        width:75,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'projcode',
        header: '项目编码',
        dataIndex: 'projcode',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'projname',
        header: '项目名称',
        width:250,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        dataIndex: 'projname'
		
    }, {
        id:'projdutydr',
        header: '项目负责人(号)',
        width:80,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'projdutydr',	
        hidden: true
    }, {
        id:'projdeptdr',
        header: '项目责任科室(号)',
        width:80,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'projdeptdr',	
        hidden: true
    }, {
        id:'username',
        header: '项目负责人',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'username'
    }, {
        id:'deptname',
        header: '项目责任科室',
        width:200,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'deptname'
    },  {
        id:'projstate',
        header: '项目状态',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
		hidden:true,
        dataIndex: 'projstate',
        type:stateStoreField
		
    },{
    	id:'pabudgvaluebegin',
        header: '期初预算',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pabudgvaluebegin'
    },{
    	id:'pabudgvalue',
        header: '追加预算',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pabudgvalue'
    },{
    	id:'sumvalue',
        header: '追加预算总和',
        width:180,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'sumvalue'
        
    }
    ,{
    	id:'pafundrestype',
        header: '资金来源类型',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pafundrestype',
        type:fundrestypeStoreField
    },{
    	id:'sf',
        header: '调整后预算',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'sf'
        
    },{
    	id:'parowid',
        header: '调整序号',
        width:75,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'parowid',
        hidden: false
        
    },{
    	id:'padesc',
        header: '预算调整说明',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'padesc',
        hidden: true
        
    },{
    	id:'pachkstate',
        header: '审批状态',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pachkstate',
        type:chkstateStoreField
        	
    },{
    	id:'pachangedate',
        header: '预算申请时间',
        width:150,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pachangedate'	
    },{
    	id:'projfiledesc',
        header: '附件',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'projfiledesc',
        hidden: true
    },{
    	id:'pachangefag',
        header: '变更标记',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pachangefag',
        hidden: true
    },{
        id:'IsSubmit',
        header: '能否提交',
        dataIndex: 'IsSubmit',
        width:60,
        hidden:true,
		editable:false
    },{
        id:'IsAudit',
        header: '能否审核',
        dataIndex: 'IsAudit',
        width:60,
        hidden:true,
		editable:false
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
//	viewConfig : {
//		forceFit : true
//	},
	
	height:230,
	trackMouseOver: true,
	stripeRows: true

});
itemMain.load(({params:{start:0, limit:25, UserID:UserID}}));

itemMain.btnAddHide();  //隐藏增加按钮
itemMain.btnSaveHide();  //隐藏保存按钮
itemMain.btnResetHide();  //隐藏重置按钮
itemMain.btnDeleteHide(); //隐藏删除按钮
itemMain.btnPrintHide();  //隐藏打印按钮

itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var id='';
	var ID='';
    //alert(rowIndex);
	var selectedRow = itemMain.getSelectionModel().getSelections();
	//alert(selectedRow);
	id=selectedRow[0].data['rowid'];
	ID=selectedRow[0].data['parowid'];
	//alert(stepno);
	
	IsAudit=selectedRow[0].data['IsAudit'];
	
	if(IsAudit!=="Y"){
		auditButton.disable();
		cancleauditButton.disable();
		
	}
	else{
		auditButton.enable();
		cancleauditButton.enable();
		
	}
	
	itemDetail.load({params:{start:0, limit:12,Rowid:id,ID:ID}});
				
});

//itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
//	
//	var paid='';
//    //alert(rowIndex);
//	var selectedRow = itemMain.getSelectionModel().getSelections();
//	paid=selectedRow[0].data['parowid'];
//	//alert(stepno);
//	itemDetail.load({params:{start:0, limit:12,ID:paid}});
//				
//});


////单击gird的单元格事件
//itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
//	//alert(columnIndex);
//	if (columnIndex == 7) {
//		//alert(columnIndex);
//		var records = itemMain.getSelectionModel().getSelections();
//		var childid = records[0].get("rowid");
//		//alert(childid);
//
//		// 维护数据页面
//		ChildFun(childid);
//		//connectFun(offshootID);
//		
//	}
//});

//itemMain.on('rowclick', function() {
//	var iscurstep='';
//	var selectedRow = itemMain.getSelectionModel().getSelections();
//	iscurstep=selectedRow[0].data['basriscurstep'];
//		if(iscurstep=='0') {
//		submitButton.disable(),
//		saveButton.disable();
//		}
//		else 
//		 submitButton.enable(),
//		 saveButton.enable();
//	}
//)

