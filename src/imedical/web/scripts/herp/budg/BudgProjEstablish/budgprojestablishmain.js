var userid = session['LOGON.USERID'];

var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//查询年度
var yearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=year&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'yearField',
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
	//id: 'propertycomb',
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
	id: 'statecomb',
	name :'statecomb',
	fieldLabel: '项目状态',
	width:150,
	listWidth : 150,
	store: stateStore,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	//emptyText:'选择项目状态...',
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
//查询条件--预算科室budgdeptField
var budgdeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


budgdeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('budgdeptField').getRawValue()),method:'POST'});
});

var budgdeptField = new Ext.form.ComboBox({
	id: 'budgdeptField',
	fieldLabel: '预算科室',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: budgdeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择预算科室...',
	name: 'budgdeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var year=yearField.getValue();
	var budgdept = budgdeptField.getValue();
	var state = statecomb.getValue();
	//alert(userid+"---"+budgdept);
	itemGrid.load(({params:{start:0, limit:25,year:year,userid:userid,budgdept:budgdept,state:state}}));
	}
});

var updateButton = new Ext.Toolbar.Button({
	text: '保存',
	id:'updateButton',    
    iconCls:'add',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要保存的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	var rowIndex = itemGrid.getSelectionModel().lastActive;//行号
	function handler(id){
		if(id=="yes"){	
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url:  encodeURI('../csp/herp.budg.budgprojestablishmainexe.csp?action=edit&rowid='+rowObj[i].get("rowid")
					+'&fundown='+rowObj[i].get("fundown")+'&fundgov='+rowObj[i].get("fundgov")+'&fundtotal='+rowObj[i].get("fundtotal")),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){			
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load(({params:{start:0, limit:25,userid:userid}}));
							 
						}else{
							Ext.Msg.show({title:'错误',msg:'保存失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
						var d = new Ext.util.DelayedTask(function(){  
                			itemGrid.getSelectionModel().selectRow(rowIndex);
           				});  
            			d.delay(1000); 
						itemGrid.getSelectionModel().selectRow(rowIndex)
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

var submitButton = new Ext.Toolbar.Button({
	text: '提交',
	id:'submitButton',    
    iconCls:'add',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要提交的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("chkstate")=="1")
		   {     
			      Ext.Msg.show({title:'注意',msg:'已提交,不能再次提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		   if(rowObj[j].get("IsSubmit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有提交权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	var rowIndex = itemGrid.getSelectionModel().lastActive;//行号	
	function handler(id){
		if(id=="yes"){	
			for(var i = 0; i < len; i++){
			//alert(rowObj[i].get("fundown"));
				Ext.Ajax.request({
					url:  encodeURI('../csp/herp.budg.budgprojestablishmainexe.csp?action=submit&rowid='+rowObj[i].get("rowid")
					+'&userid='+userid+'&fundown='+rowObj[i].get("fundown")+'&fundgov='+rowObj[i].get("fundgov")),
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
                   
					success: function(result, request){			
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
					     	//alert(fundown)
							Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load(({params:{start:0, limit:25,userid:userid}}));
							 
						}else{
							Ext.Msg.show({title:'错误',msg:'提交失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				var d = new Ext.util.DelayedTask(function(){  
                itemGrid.getSelectionModel().selectRow(rowIndex);
           		});  
            	d.delay(1000); 
						itemGrid.getSelectionModel().selectRow(rowIndex);
						var tbar = itemDetail.getTopToolbar();
						var addbutton = tbar.get('herpAddId');
						var deletbutton = tbar.get('herpDeleteId');
						updateButton.hide();
						saveButton.hide();
						deletbutton.hide();
						addbutton.hide();
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


var cancelsubmitButton = new Ext.Toolbar.Button({
	text: '取消提交',
    tooltip:'取消提交',        
    iconCls:'add',
	handler:function(){
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要审核的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择取消提交的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
	for(var j = 0; j < len; j++){
		   if(rowObj[j].get("chkstate")=="0")
		   {     
			      Ext.Msg.show({title:'注意',msg:'数据未提交,不能取消提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		    if(rowObj[j].get("IsSubmit")!=="Y")
		   {     
			      Ext.Msg.show({title:'注意',msg:'不具有取消提交权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
	var rowIndex = itemGrid.getSelectionModel().lastActive;//行号
	function handler(id){
		if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojestablishmainexe.csp?action=cancelsubmit&rowid='+rowObj[i].get("rowid")+'&userid='+userid,
					waitMsg:'取消提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'取消提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							 itemGrid.load(({params:{start:0, limit:25,userid:userid}}));
						}else{
							Ext.Msg.show({title:'错误',msg:'取消提交失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				var d = new Ext.util.DelayedTask(function(){  
                itemGrid.getSelectionModel().selectRow(rowIndex);
           		});  
            	d.delay(1000); 
						itemGrid.getSelectionModel().selectRow(rowIndex);
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

var itemGrid = new dhc.herp.Gridlyfmain({
    title: '项目预算编制',
    region : 'north',
    url: 'herp.budg.budgprojestablishmainexe.csp',
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
               var record = grid.getStore().getAt(rowIndex);
               // 根据条件设置单元格点击编辑是否可用
               if ((record.get('chkstate') == '1') &&((columnIndex == 16)||(columnIndex == 17))) {    
                      Ext.Msg.show({title:'注意',msg:'已提交,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                      return false;
               } else 
                      {
                      return true;
                      }
        },        
        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
            var record = grid.getStore().getAt(rowIndex);
            // 根据条件设置单元格点击编辑是否可用
        
            if ((record.get('chkstate') == '1') &&((columnIndex == 16)||(columnIndex == 17))) {          
                   return false;
            } else 
                   {
                   return true;
                   }
     	}},
     
	
	
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
    },{
        id : 'CompName',
        header : '医疗单位',
        width : 90,
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
    	id:'chkstate',
        header: '项目审批状态',
        width:90,
	    hidden: true,
        dataIndex: 'chkstate'
        	
    },{
         id:'chkstatelist',
         header: '审批状态',
	     editable:false,
	     width:80,
         dataIndex: 'chkstatelist'
    },{
    	id:'fundtotal',
        header: '总预算',
        width:120,
	    editable:false,
	    xtype:'numbercolumn',
	    align:'right',
        dataIndex: 'fundtotal'
    },{
    	id:'fundown',
        header: '自筹资金',
        width:120,
        align:'right',
        xtype:'numbercolumn',
	    allowBlank: true,
	    renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
			cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
			return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
        dataIndex: 'fundown'
    },{
    	id:'fundgov',
        header: '政府拨款',
        width:120,
	    align:'right',
	    allowBlank: true,
	    xtype:'numbercolumn',
	    renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
			cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
			return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
        dataIndex: 'fundgov'
    },{
	    id:'property',
    	header: '项目性质',
        dataIndex: 'property',
        width: 100,		
        hidden:true,  
        editable:false,
        type:propertycomb
    },{
	    id:'propertylist',
    	header: '项目性质',
        dataIndex: 'propertylist',
        width: 100,
        editable:false,
        type:propertycomb
    },{ 
        id:'isgovbuy',
    	header: '政府采购',
        dataIndex: 'isgovbuy',
        width: 50,
        hidden:true,
        editable:false,
        type:isgovbuycomb
    },{ 
        id:'isgovbuylist',
    	header: '政府采购',
        dataIndex: 'isgovbuylist',
        width: 75,
        editable:false,
        type:isgovbuycomb
    },{
        id:'deptdr',
        header: '责任科室',
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
     width:100,
  //tip:true,
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
        width:60,
		editable:false
    },{
        id:'spec1',
        header: '规格型号1',
        dataIndex: 'spec1',
        width:60,
		editable:false
    },{
        id:'brand2',
        header: '推荐品牌2',
        dataIndex: 'brand2',
        width:60,
		editable:false
    },{
        id:'spec2',
        header: '规格型号2',
        dataIndex: 'spec2',
        width:60,
		editable:false
    },{
        id:'brand3',
        header: '推荐品牌3',
        dataIndex: 'brand3',
        width:60,
		editable:false
    },{
        id:'spec3',
        header: '规格型号3',
        dataIndex: 'spec3',
        width:60,
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
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	//loadMask : true,
	tbar:['立项年度:',yearField,'预算科室：',budgdeptField,'状态：',statecomb,'-',searchButton,'-',submitButton,'-',cancelsubmitButton,'-',updateButton],
    //atLoad : true, // 是否自动刷新
	height:300,
	trackMouseOver: true,
	stripeRows: true

});


itemGrid.load({	
	params:{start:0, limit:25,userid:userid}
	/*,

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}*/
});

var row="";

itemGrid.on('rowclick',function(grid,rowIndex,e){	
	row=rowIndex;
    var projadjdr="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	projadjdr=selectedRow[0].data['projadjdr'];
	
	IsSubmit=selectedRow[0].data['IsSubmit'];
	IsAudit=selectedRow[0].data['IsAudit'];
	chkstate=selectedRow[0].data['chkstate'];
	realedate=selectedRow[0].data['realedate'];
	var date = new Date(new Date()); //Date();
	var today=date.format('Y-m-d'); 
	
	
	var tbar = itemDetail.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletbutton = tbar.get('herpDeleteId');
	
	if((IsSubmit!=="Y")&&(IsAudit!=="Y")&&(today>=realedate)&&(realedate!=="")){
		updateButton.hide();
		saveButton.hide();
		deletbutton.hide();
		addbutton.hide();
		}
	else if(chkstate=="1"){
		updateButton.hide();
		saveButton.hide();
		deletbutton.hide();
		addbutton.hide();
		}
	else{
		updateButton.show();
		saveButton.show()
		deletbutton.show();
		addbutton.show();
		}
			
	if(IsSubmit!=="Y"){
		submitButton.disable();
		cancelsubmitButton.disable();
	}
	else{
		submitButton.enable();
		cancelsubmitButton.enable();
	}
	
	
    //alert("projadjdr"+projadjdr);
	itemDetail.load({params:{start:0, limit:25,projadjdr:projadjdr}});	
});


