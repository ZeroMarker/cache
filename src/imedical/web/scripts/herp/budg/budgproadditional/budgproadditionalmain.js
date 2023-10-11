
var BudgProAdditionalUrl = '../csp/herp.budg.budgproadditionalmainexe.csp';
var userid = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
///////////////// 立项年度 ///////////////////////
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
	listWidth : 225,
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

//////////////// 责任科室 //////////////////////
var deptDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgProAdditionalUrl+'?action=deptlist&userid='+ userid,method:'POST'});
		});

var deptField  = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '责任科室',
	width:100,
	listWidth : 225,
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

/////////////////// 项目名称 ///////////////////
var projectnameDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

projectnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgProAdditionalUrl+'?action=projectnamelist&userid='+userid,method:'POST'});
		});

var projectnameField  = new Ext.form.ComboBox({
	id: 'projectnameField',
	fieldLabel: '项目名称',
	width:100,
	listWidth : 225,
	store: projectnameDs,
	valueField: 'rowid',
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

/////////////////////// 资金来源类型  ////////////////////
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
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', // 本地模式
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

//////////////////////// 项目状态 ///////////////////////////
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
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', // 本地模式
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

///////////////////////// 审批状态  //////////////////////////
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
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
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
	
	var year=yearField.getValue();
	var deptdr=deptField.getValue();
	var projdr=projectnameField.getValue();
    itemDetail.getStore().removeAll();
	itemMain.load(({params:{start:0, limit:25,year:year,deptdr:deptdr,projdr:projdr,userid:userid}}));
	}
});

var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	 addFun();
	 }
});

var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'option',
	handler:function(){
	  editFun();
	  }
});

var submitButton = new Ext.Toolbar.Button({
	text: '提交',
    tooltip:'提交',        
    iconCls:'option',
	handler:function(){
	var rowObj=itemMain.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择提交的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
		
	function handler(id){
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				if(rowObj[i].get("pachkstate")!="0")
		   		{     
			      	Ext.Msg.show({title:'注意',msg:'不是“待提交”状态，不能进行“提交”!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			        continue;
		   		}if(rowObj[i].get("IsSubmit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有提交权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgproadditionalmainexe.csp?action=submit&parowid='+rowObj[i].get("parowid")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemMain.load(({params:{start:0, limit:25,userid:userid}}));
						}else{
							Ext.Msg.show({title:'错误',msg:'提交失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要提交吗?',handler);
}
});


var canclesubmitButton = new Ext.Toolbar.Button({
	text: '取消提交',
    tooltip:'取消提交',        
    iconCls:'remove',
	handler:function(){
	var rowObj=itemMain.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择取消提交的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}

	function handler(id){
		
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				 if(rowObj[i].get("pachkstate")!="1")
		 		 {     
			      Ext.Msg.show({title:'注意',msg:'不是“提交”状态，不能进行“取消提交”!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       continue;
		   		 }
		   	if(rowObj[i].get("IsSubmit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有取消提交权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgproadditionalmainexe.csp?action=cancelsubmit&parowid='+rowObj[i].get("parowid")+'&userid='+userid,
					waitMsg:'取消提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'取消提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							 itemMain.load(({params:{start:0, limit:25,userid:userid}}));
						}else{
							Ext.Msg.show({title:'错误',msg:'取消提交失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要取消提交吗?',handler);
}
});

var deleteButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){
	//定义并初始化行对象
	var rowObj=itemMain.getSelectionModel().getSelections();
    //定义并初始化行对象长度变量
    var len = rowObj.length;
    //判断是否选择了要修改的数据	   
    if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择删除的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	Ext.MessageBox.confirm('提示','确实要删除吗?',function(btn){
		if(btn=="yes")
		{
			Ext.MessageBox.confirm('提示','确实要连同子表一起删除吗?',function(btn1){
				if(btn1=="yes")// 级联删除表中数据
				{
						for(var i = 0; i < len; i++){
						var projdr=rowObj[i].get("rowid");
						var parowid=rowObj[i].get("parowid")
						 if(rowObj[i].get("pachkstate")!="0")
		   				 {     
			     		 	Ext.Msg.show({title:'注意',msg:'不是“待提交”状态,不能进行“删除”!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			      			 continue;
		  				 }
		  				 Ext.Ajax.request({
    						url: '../csp/herp.budg.budgproadditionalmainexe.csp?action=del&parowid='+rowObj[i].get("parowid"),
    						waitMsg:'处理中...',
    						failure: function(result, request){
    							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    						},
    						success: function(result, request){
    							var jsonData = Ext.util.JSON.decode( result.responseText );
    							if (jsonData.success=='true'){
    		    					itemMain.load(({params:{start:0, limit:25,userid:userid}}));
    		    					Ext.Msg.show({title:'注意',msg:'删除成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});


    							}
    							else{
    							if(jsonData.info=='RepName'){
    								Ext.Msg.show({title:'错误',msg:'条件不符合!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    								}
    							}
    						},
							scope: this
						});
						
					itemDetail.load({params:{start:0, limit:12,projdr:projdr,parowid:parowid}});

					}
				}
				else // 
				{
					return ;		
				}				
				
				});			
		}
		else
		{
			return ;
		}		
		
		});
	
	}
	
});
	

var itemMain = new dhc.herp.Gridhb({
    title: '项目预算追加',
    region : 'north',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgproadditionalmainexe.csp',
  
	
	tbar:['立项年度:',yearField,'-','责任科室:',deptField,'-','项目名称:',projectnameField,'-',searchButton,'-',addButton,'-',editButton,'-',submitButton,'-',canclesubmitButton,'-',deleteButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '项目ID',
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
        width:120,
        editable:false,
        allowBlank: true,
        dataIndex: 'projname'
    }, {
        id:'projdutydr',
        header: '项目负责人(号)',
        width:80,
		allowBlank: false,
		editable:false,
        dataIndex: 'projdutydr',	
        hidden: true
    }, {
        id:'projdeptdr',
        header: '项目责任科室(号)',
        width:80,
		allowBlank: true,
		editable:false,
        dataIndex: 'projdeptdr',	
        hidden: true
    }, {
        id:'username',
        header: '项目负责人',
        width:100,
		allowBlank: false,
		editable:false,
        dataIndex: 'username'
    }, {
        id:'deptname',
        header: '项目责任科室',
        width:120,
		allowBlank: true,
		editable:false,
        dataIndex: 'deptname'
    },{
    	id:'pachkstate',
        header: '审批状态',
        width:100,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pachkstate',
        type:chkstateStoreField
        	
    },{
    	id:'pabudgvaluebegin',
        header: '期初预算',
        width:120,
        align:'right',
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pabudgvaluebegin'
    },{
    	id:'pabudgvaluebegin1',
        header: '期初预算(1)',
        width:120,
        align:'right',
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pabudgvaluebegin1',
        hidden: true
    },{
    	id:'pabudgvalue',
        header: '追加预算',
        width:120,
        align:'right',
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pabudgvalue'
    },{
    	id:'pafundrestype',
        header: '资金来源类型',
        width:100,
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
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'sf'
        
    },{
    	id:'sumvalue',
        header: '追加预算总和',
        width:150,
        align:'right',
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'sumvalue'
        
    },{
    	id:'parowid',
        header: '调整序号',// 项目预算主表ID
        width:75,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'parowid',
        hidden: false
        
    },{
    	id:'padesc',
        header: '预算调整说明',
        width:150,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'padesc',
        hidden: true
        
    },{
    	id:'pachangedate',
        header: '预算申请时间',
        width:150,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'pachangedate'	
    }, {
        id:'projstate',
        header: '项目状态',
        width:100,
		allowBlank: true,
		editable:false,
		hidden:true,
        dataIndex: 'projstate',
        type:stateStoreField
		
    },{
    	id:'projfiledesc',
        header: '附件',
        width:100,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'projfiledesc',
        hidden: true
    },{
    	id:'pachangefag',
        header: '变更标记',
        width:110,
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
	height:230,
	trackMouseOver: true,
	stripeRows: true

});
itemMain.load(({params:{start:0,limit:25,userid:userid}}));

itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {

	var selectedRow = itemMain.getSelectionModel().getSelections();
	var projdr=selectedRow[0].data['rowid'];
	var parowid=selectedRow[0].data['parowid'];
	var year=selectedRow[0].data['projyear'];
	
	IsSubmit=selectedRow[0].data['IsSubmit'];
	chkstate=selectedRow[0].data['pachkstate'];
	//alert(chkstate);
	if(IsSubmit!=="Y"){
		submitButton.disable();
		canclesubmitButton.disable();
	}
	else{
		submitButton.enable();
		canclesubmitButton.enable();
	}
	if(chkstate==1||chkstate==2){
		deleteButton.disable();
		submitButton.disable();
		editButton.disable();
		
		if(chkstate==2){
			canclesubmitButton.disable();
			}
		
		}
	else{
		deleteButton.enable();
		submitButton.enable();
		editButton.enable();
		}
	
	BIDNameDs.removeAll();     
	BIDNameDs.proxy = new Ext.data.HttpProxy({url:BudgProAdditionalDetailUrl+'?action=bidnamelist&projdr='+projdr+'&year='+year,method:'POST'})  
	BIDNameDs.load({params:{start:0,limit:10}});   
	
	itemDetail.load({params:{start:0, limit:12,projdr:projdr,parowid:parowid}});
				
});

