var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var userid = session['LOGON.USERID'];

//查询年度
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=year&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});

//保存按钮
var updateButton = new Ext.Toolbar.Button({
	text: '保存',
	id:'updateButton',    
    iconCls:'save',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要保存的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	function handler(id){
		if(id=="yes"){	
			for(var i = 0; i < len; i++){
				//alert(rowObj[i].get("fundown"))
				Ext.Ajax.request({
					url:  encodeURI('../csp/herp.budg.budgprojestablishmainexe.csp?action=edit&rowid='+rowObj[i].get("rowid")
					+'&fundown='+rowObj[i].get("fundown").replace(/,/g,'')+'&fundgov='+rowObj[i].get("fundgov").replace(/,/g,'')),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){		
						var jsonData =	 Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load(({params:{start:0, limit:25,userid:userid}}));
							 
						}else{
							Ext.Msg.show({title:'错误',msg:'保存失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
		}	
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要保存吗?',handler);
}
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:200,
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

//预算科室
	var deptnameBs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	deptnameBs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept&str='+encodeURIComponent(Ext.getCmp('BudgdeptNameField').getRawValue()),method:'POST'});
	});
	var BudgdeptNameField = new Ext.form.ComboBox({
		id: 'BudgdeptNameField',
		fieldLabel: '预算科室',
		width:200,
		listWidth:200,
		store: deptnameBs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室名称...',
		name: 'BudgdeptNameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
//项目性质
var propertyStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','一般性项目'],['2','基建项目'],['3','科研项目']]
});
var propertycomb = new Ext.form.ComboBox({
	//id: 'property',
	fieldLabel: '项目性质',
	width:150,
	listWidth : 150,
	store: propertyStore,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择项目性质...',
	name: 'propertycomb',
	mode: 'local', //本地模式
	selectOnFocus:true,
	forceSelection:'true'
});

//项目状态
var stateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','新建'],['2','执行'],['3','完成'],['4','取消']]
});
var statecomb = new Ext.form.ComboBox({
	//id: 'state',
	fieldLabel: '项目状态',
	width:150,
	listWidth : 150,
	store: stateStore,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择项目状态...',
	mode: 'local', //本地模式
	selectOnFocus:true,
	forceSelection:true
});

//政府采购
var isgovbuyStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','是'],['2','否']]
});
var isgovbuycomb = new Ext.form.ComboBox({
	//id: 'isgovbuy',
	fieldLabel: '政府采购',
	width:150,
	listWidth : 150,
	store: isgovbuyStore,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'是否政府采购...',
	mode: 'local', //本地模式
	selectOnFocus:true,
	forceSelection:true
});

//审批状态  
var chkstateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','提交'],['2','审核通过'],['3','审核不通过']]
});
var chkstateStoreField = new Ext.form.ComboBox({
	id: 'chkstateStoreField',
	fieldLabel: '审批状态',
	width:100,
	listWidth : 100,
	selectOnFocus: true,
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
	forceSelection:true,
	editable:true
});

var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
  	  var year=yearField.getValue();
  	  var budgdept=BudgdeptNameField.getValue();
  	  var checkstate=chkstateStoreField.getValue();
	  itemGrid.load(({params:{start:0, limit:25,year:year,userid:userid,budgdept:budgdept,checkstate:checkstate}}));
	
	}
});

var auditButton = new Ext.Toolbar.Button({
	text: '审核',
	id:'auditButton',    
    iconCls:'option',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要审核的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("chkstate")=="2")
		   {     
			      Ext.Msg.show({title:'注意',msg:'数据已审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		   if(rowObj[j].get("IsAudit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有审核权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	function handler(id){
		if(id=="yes"){	
			for(var i = 0; i < len; i++){
			//alert(rowObj[i].get("fundown"));
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojestablishauditmainexe.csp?action=audit&projadjdr='+rowObj[i].get("projadjdr")+'&userid='+userid,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
                   
					success: function(result, request){			
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
					     	//alert(fundown)
							Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load(({params:{start:0, limit:25,userid:userid}}));	
							 
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

var cancelauditButton = new Ext.Toolbar.Button({
	text: '取消审核',      
    iconCls:'option',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择取消审核的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("chkstate")=="1")
		   {     
			      Ext.Msg.show({title:'注意',msg:'数据已取消审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		   if(rowObj[j].get("IsAudit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有取消审核权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	function handler(id){
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojestablishauditmainexe.csp?action=cancelaudit&projadjdr='+rowObj[i].get("projadjdr")+'&userid='+userid,
					waitMsg:'取消审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'取消审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
							 itemGrid.load(({params:{start:0, limit:25,userid:userid}}));
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

var unauditButton = new Ext.Toolbar.Button({
	text: '审核不通过',      
    iconCls:'option',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择审核不通过的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("chkstate")=="3")
		   {     
			      Ext.Msg.show({title:'注意',msg:'数据已审核不通过!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	function handler(id){
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojestablishauditmainexe.csp?action=unaudit&projadjdr='+rowObj[i].get("projadjdr")+'&userid='+userid,
					waitMsg:'审核不通过中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'审核不通过成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
							 itemGrid.load(({params:{start:0, limit:25,userid:userid}}));
						}else{
							Ext.Msg.show({title:'错误',msg:'审核不通过失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
		}	
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要审核不通过吗?',handler);
}
});

var itemGrid = new dhc.herp.Gridlyf({
    title: '项目预算审核',
    region : 'north',
    url: 'herp.budg.budgprojestablishauditmainexe.csp',
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '项目ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'projadjdr',
        header: '主表ID',
        editable:false,
        dataIndex: 'projadjdr',
        hidden: true
    }, {
        id : 'CompName',
        header : '医疗单位',
        width : 100,
        editable : false,
        dataIndex : 'CompName'

    },{
        id:'code',
        header: '项目编码',
        dataIndex: 'code',
        width:100,
		editable:false
    },{
        id:'name',
        header: '项目名称',
        dataIndex: 'name',
        width:200,
        editable:false  
    },{
        id:'year',
        header: '年度',
        dataIndex: 'year',
        width:60,
		editable:false
    },{
        id:'deptdr',
        header: '责任科室id',
        width:100,
		editable:false,
        dataIndex: 'deptdr',	
        hidden: true
    },{
        id:'deptname',
        header: '责任科室',
        dataIndex: 'deptname',
        width:100,
		//tip:true,
		editable:false
    },{
        id:'bdeptname',
        header: '预算科室',
        dataIndex: 'bdeptname',
        width:100,
		//tip:true,
		editable:false
    },{
        id:'dutydr',
        header: '项目负责人',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'dutydr',	
        hidden: true
    }, {
        id:'username',
        header: '项目负责人',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'username'
    },{
	    id:'property',
    	header: '项目性质',
        dataIndex: 'property',
        width: 100,		
        hidden:true,  
         editable:false,
        sortable: true,
        type:propertycomb
    },{
	    id:'propertylist',
    	header: '项目性质',
        dataIndex: 'propertylist',
        width: 100,		  
        sortable: true,
        editable:false,
        type:propertycomb
        
    },{ 
        id:'isgovbuy',
    	header: '政府采购',
        dataIndex: 'isgovbuy',
        width: 75,
        hidden:true,		  
        sortable: true,
        editable:false,
        type:isgovbuycomb
    },{ 
        id:'isgovbuylist',
    	header: '政府采购',
        dataIndex: 'isgovbuylist',
        width: 75,		  
        sortable: true,
        editable:false,
        type:isgovbuycomb
    },{
    	id:'fundtotal',
        header: '总预算',
        width:120,
	    editable:false,
	    align:'right',
	    update:true,
        dataIndex: 'fundtotal'
    },{
    	id:'fundown',
        header: '自筹资金',
        width:120,
        align:'right',
	    allowBlank: true,
        dataIndex: 'fundown'
    },{
    	id:'fundgov',
        header: '政府拨款',
        width:120,
	    align:'right',
	    allowBlank: true,
        dataIndex: 'fundgov'
    },{
    	id:'chkstate',
        header: '项目审批状态',
        width:90,
	    hidden: true,
        dataIndex: 'chkstate'
        	
    },{
         id:'chkstatelist',
         header: '审批状态',
	     editable:false,
	     width:100,
         dataIndex: 'chkstatelist'
    },{
       id:'state',
       header: '项目状态',
       width:100,
	   hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: 'state',
       type:statecomb
		
  },{           
       id:'statelist',
       header: '项目状态',
       allowBlank: false,
       width:75,
       editable:false,
       dataIndex: 'statelist'
  },{
 	 id:'filedesc',
     header: '附件',
     width:110,
	 allowBlank: true,
	 editable:false,
     dataIndex: 'filedesc',
     hidden: true
    },{
   	id:'changefag',
    header: '变更标记',
    width:110,
    //tip:true,
    allowBlank: true,
    editable:false,
    update:true,
    dataIndex: 'changefag',
    hidden: true
    }/*,{
        id:'brand1',
        header: '推荐品牌1',
        dataIndex: 'brand1',
        width:100,
        editable:false  
    },{
        id:'spec1',
        header: '规格型号1',
        dataIndex: 'spec1',
        width:100,
        editable:false  
    },{
        id:'brand2',
        header: '推荐品牌2',
        dataIndex: 'brand2',
        width:100,
        editable:false  
    },{
        id:'spec2',
        header: '规格型号2',
        dataIndex: 'spec2',
        width:100,
        editable:false  
    },{
        id:'brand3',
        header: '推荐品牌3',
        dataIndex: 'brand3',
        width:100,
        editable:false  
    },{
        id:'spec3',
        header: '规格型号3',
        dataIndex: 'spec3',
        width:100,
        editable:false  
    }*/,{
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
    },{           
	         id:'realedate',
	         header: '实际结束时间',
	         allowBlank: false,
	         width:120,
	         dataIndex: 'realedate',
	    	 hidden: true
	}],
	layout:"fit",
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
	//viewConfig : {forceFit : true},
	tbar:['立项年度:',yearField,'-','预算科室:',BudgdeptNameField,'-','审核状态:',chkstateStoreField,'-',searchButton,'-',auditButton,'-',cancelauditButton,'-',unauditButton,'-',updateButton],
    atLoad : true, // 是否自动刷新
	height:300,
	trackMouseOver: true,
	stripeRows: true

});
/*
    itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮

*/


itemGrid.load(({params:{start:0, limit:25, userid:userid}}));

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
    var projadjdr="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	projadjdr=selectedRow[0].data['projadjdr'];
	IsSubmit=selectedRow[0].data['IsSubmit'];
	IsAudit=selectedRow[0].data['IsAudit'];
	realedate=selectedRow[0].data['realedate'];
	var date = new Date(new Date()); //Date();
	var today=date.format('Y-m-d');
	var chkstate=selectedRow[0].data['chkstate'];
	//alert(today); 
	//alert(realedate);
	//date= Date.parse(date);
	//realedate= Date.parse(realedate);
	//alert(today); 
	//alert(realedate);
	if((IsSubmit!=="Y")&&(IsAudit!=="Y")&&(today>=realedate)&&(realedate!=="")){
		updateButton.hide();
		saveButton.hide();
		}
	else if(chkstate=="2"){
	updateButton.hide();
		saveButton.hide();
		}
	else{
		updateButton.show();
		saveButton.show();
		}
	
	if(IsAudit!=="Y"){
		auditButton.disable();
		cancelauditButton.disable();
		unauditButton.disable();
	}
	else{
		auditButton.enable();
		cancelauditButton.enable();
		unauditButton.disable();
	}
	
	itemDetail.load({params:{start:0, limit:25,projadjdr:projadjdr}});	
				
});

