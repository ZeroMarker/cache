var loginuser = session['LOGON.USERID'];
var tmpData="";
var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var budgprojectdictDs=function(){
		itemGridDs.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgprojectdictexe.csp?action=list&year='+ 
							yearField.getValue().trim()+ 
							'&deptdr='+ deptField.getValue().trim()+ 
							'&property='+ propertycomb.getValue().trim()+ 
							'&state='+ statecomb.getValue().trim()+  
							'&isgovbuy='+ isgovbuycomb.getValue().trim()+
							'&budgdept='+ budgdeptField.getValue().trim()+
							'&userdr='+loginuser,
							method : 'GET'
						});
				itemGridDs.load({
							params : {
								start : 0,
								limit : itemGridPagingToolbar.pageSize,
								userdr:loginuser
							}
						});
};
var itemGridUrl = '../csp/herp.budg.budgprojectdictexe.csp';

//配件数据源

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list&userdr='+loginuser});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [                        'CompName',
                         
		'rowid',
		'code',
		'name',
		'year',
		'yearlist',
		'deptdr',
		'deptname',
		'userdr',
		'username',
		'goal',
		'property',
		'propertylist',
		'isgovbuy',
		'isgovbuylist',
		'state',
		'statelist',
		/*'isaddedit',
		'isaddeditlist',
		'brand1',
		'spec1',
		'brand2',
		'spec2',
		'brand3',
		'spec3',*/
		'plansdate',
		'planedate',
		'realsdate',
		'realedate',
		'alert',
		'filedesc',
		'budgDeptDR',
		'bdeptname'
		
	]),
    remoteSort: true
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 15,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');


//查询年度
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl + '?action=year&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
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
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询责任科室名称
var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojectdictexe.csp'+'?action=calItemdept&str='+encodeURIComponent(Ext.getCmp('deptField').getRawValue()),method:'POST'});
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: deptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询科室名称 
var budgdeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

budgdeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl + '?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('budgdeptField').getRawValue()),method:'POST'});
});

var budgdeptField = new Ext.form.ComboBox({
	id: 'budgdeptField',
	fieldLabel: '预算科室名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: budgdeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择预算科室名称...',
	name: 'budgdeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询项目性质
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

//查询项目状态
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
var tmpTitle='项目信息管理';
var combos = new Ext.FormPanel({
	height:140,
	region:'north',
	frame:true,
	defaults: {bodyStyle:'padding:5px'},
		items:[{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'<center><p style="font-weight:bold;font-size:150%">'+tmpTitle+'</p></center>',
				columnWidth:1,
				height:'40'
			}
		]
	   },{
	    columnWidth:1,
	    xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'年度:',
				columnWidth:.1
			},
			yearField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.1
			},{
				xtype:'displayfield',
				value:'责任科室:',
				columnWidth:.1
			},
			deptField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.1
			},
			{
				xtype:'displayfield',
				value:'项目性质:',
				columnWidth:.1
			},
			propertycomb
		]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'项目状态:',
				columnWidth:.08
			},
			statecomb,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.088
			},
			{
				xtype:'displayfield',
				value:'政府采购:',
				columnWidth:.08
			},
			isgovbuycomb,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.085
			},
			{
				xtype:'displayfield',
				value:'预算科室:',
				columnWidth:.08
			},
			budgdeptField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.085
			},
			{
				columnWidth:.1,
				xtype:'button',
				text: '查询',
				handler:function(b){
					budgprojectdictDs();
					//alert(itemGridPagingToolbar.pageSize+","+loginuser);
				},
				iconCls: 'add'
			}		
		]
	}
	]
});
//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(), 
		{
	            id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
	       hidden: true,
                     dataIndex : 'CompName'

	    },{
		    id:'rowid',
	    	header: 'id',
	        dataIndex: 'rowid',
	        width: 80,		  
	        hidden: true,
	        sortable: true
	    },{ 
	        id:'code',
	    	header: '项目编号',
	        dataIndex: 'code',
	        width: 100,	
	        edit:true,	  
	        sortable: true
	    },{
	        id:'name',
	    	header: '项目名称',
	        dataIndex: 'name',
	        width: 200,
	        sortable: true
	    },{           
	         id:'year',
	         header: '年度',
	         width:60,
	         hidden:true,
	         dataIndex: 'year',
	         sortable: true
	    },{           
	         id:'yearlist',
	         header: '年度',
	         width:60,
	         dataIndex: 'yearlist',
	         sortable: true
	    },{           
	         id:'budgDeptDR',
	         header: '预算科室id',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'budgDeptDR',
	         hidden: true
	    },{           
	         id:'bdeptname',
	         header: '预算科室',
	         allowBlank: false,
	         width:100,
	         dataIndex: 'bdeptname'
	    },{
		    id:'deptdr',
	    	header: '责任科室id',
	        dataIndex: 'deptdr',
	        width: 60,		  
	        hidden: true,
	        sortable: true
	    },{
		    id:'deptname',
	    	header: '责任科室',
	        dataIndex: 'deptname',
	        width: 100,		  
	        sortable: true
	    },{ 
	        id:'userdr',
	    	header: '负责人',
	        dataIndex: 'userdr',
	        width: 100	,  
	        hidden:true,
	        sortable: true
	    },{ 
	        id:'username',
	    	header: '负责人',
	        dataIndex: 'username',
	        width: 100,		  
	        sortable: true
	    },{           
	         id:'goal',
	         header: '项目说明',
	         allowBlank: false,
	         width:100,
	         dataIndex: 'goal'
	    },{
		    id:'property',
	    	header: '项目性质',
	        dataIndex: 'property',
	        width: 80,		
	        hidden:true,  
	        sortable: true
	    },{
		    id:'propertylist',
	    	header: '项目性质',
	        dataIndex: 'propertylist',
	        width: 100,		  
	        sortable: true
	    },{ 
	        id:'isgovbuy',
	    	header: '政府采购',
	        dataIndex: 'isgovbuy',
	        width: 60,
	        hidden:true,		  
	        sortable: true
	    },{ 
	        id:'isgovbuylist',
	    	header: '政府采购',
	        dataIndex: 'isgovbuylist',
	        width: 60,		  
	        sortable: true
	    },{           
	         id:'state',
	         header: '项目状态',
	         allowBlank: false,
	         width:60,
	         hidden:true,
	         dataIndex: 'state'
	    },{           
	         id:'statelist',
	         header: '项目状态',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'statelist'
	    },{           
	         id:'isaddedit',
	         header: '新增/更新id',
	         allowBlank: false,
	         width:60,
	         hidden:true,
	         dataIndex: 'isaddedit'
	    }/*,{           
	         id:'isaddeditlist',
	         header: '新增/更新',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'isaddeditlist'
	    },{           
	         id:'brand1',
	         header: '推荐品牌1',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'brand1'
	    },{           
	         id:'spec1',
	         header: '规格型号1',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'spec1'
	    },{           
	         id:'brand2',
	         header: '推荐品牌2',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'brand2'
	    },{           
	         id:'spec2',
	         header: '规格型号2',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'spec2'
	    },{           
	         id:'brand3',
	         header: '推荐品牌3',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'brand3'
	    },{           
	         id:'spec3',
	         header: '规格型号3',
	         allowBlank: false,
	         width:60,
	         dataIndex: 'spec3'
	    }*/,{
		    id:'plansdate',
	    	header: '计划启动时间',
	        dataIndex: 'plansdate',
	        width: 120,		  
	        sortable: true,
	        hidden: false
	    },{ 
	        id:'planedate',
	    	header: '计划结束时间',
	        dataIndex: 'planedate',
	        width: 120,		  
	        sortable: true,
	        hidden: false
	    },{
	        id:'realsdate',
	    	header: '实际开始时间',
	        dataIndex: 'realsdate',
	        width: 120,
	        sortable: true,
	        hidden: false
	    },{           
	         id:'realedate',
	         header: '实际结束时间',
	         allowBlank: false,
	         width:120,
	         dataIndex: 'realedate',
	    	 hidden: false
	    },{
	        id:'alert',
	    	header: '预警线%',
	        dataIndex: 'alert',
	        width: 80,
	        align:'right',
	        sortable: true,
	        hidden: true
	    },{           
	         id:'filedesc',
	         header: '附件',
	         width:150,
	         dataIndex: 'filedesc',
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
	    
]);

var addButton = new Ext.Toolbar.Button({
			text : '添加',
			tooltip : '添加',
			iconCls : 'add',
			handler : function() {
				budgprojectdictAddFun(loginuser);
			}
		});

var editButton = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '修改',
			iconCls : 'option',
			handler : function() {
				budgprojectdictEditFun(loginuser);
			}
		});

var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";

		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要删除的数据!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
				if (btn == 'yes') {
					Ext.Ajax.request({
						url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
						waitMsg : '删除中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								itemGridDs.load({
											params : {
												start : 0,
												limit : itemGridPagingToolbar.pageSize
											}
										});
							} else {
								var message = "错误";
							message = "SQLErr: " + jsonData.info;
							if (jsonData.info == 'emp')
								message = '该项目已产生预算金额，请清除后再删除!';
								
								Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				}
			})
		}
	}
});
/******
var UploadButton = new Ext.Toolbar.Button({
			text : '上传图片',
			tooltip : '上传图片',
			iconCls : 'upload',
			handler : function() {
				var rowObj=itemGrid.getSelectionModel().getSelections();
        		var rowid = rowObj[0].get("rowid");  
        		//alert(rowid);  
				projuploadFun(rowid);
				
			}
			
		});
****/		
		
var UploadButton = new Ext.Toolbar.Button({
        text:'上传图片',
        tooltip:'上传图片',
        iconCls:'option',
        handler:function(){
        	
            var rowObj = itemGrid.getSelectionModel().getSelections(); 
            var len = rowObj.length;
            var message="请选择对应的项目！";  
            if(len < 1){
                Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                return false;
            }else{
                var rowid = rowObj[0].get('rowid');
                var dialog = new Ext.ux.UploadDialog.Dialog({
                url: 'herp.budg.budgprojectdictexe.csp?action=Upload&rowid='+rowid,
                reset_on_hide: false, 
                permitted_extensions:['gif','jpeg','jpg','png','bmp'],
                allow_close_on_upload: true,
                upload_autostart: false,
                title:'上传项目信息图片'
                //post_var_name: 'file'
          });
          dialog.show();
            }
        }
});

var excelButton = {
		text: '导入Excel数据',
	    tooltip:'导入',
		//disabled:userCode=='demo1'?false:true,	
	    iconCls:'add',
		handler:function(){importExcel()}
				
	};

var itemGrid = new Ext.grid.GridPanel({
	title: '项目信息管理',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    url: 'herp.budg.budgprojectdict.csp',
    atLoad : true, // 是否自动刷新
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton,UploadButton,'-',excelButton],
	bbar:itemGridPagingToolbar
});



  itemGridDs.load({	
	//params:{start:0, limit:itemGridPagingToolbar.pageSize},
    params:{start:0, limit:itemGridPagingToolbar.pageSize,userdr:loginuser}
    /* callback:function(record,options,success ){
	itemGrid.fireEvent('rowclick',this,0);
	}*/
	
});
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	row=rowIndex;
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var IsSubmit=selectedRow[0].data['IsSubmit'];
	var IsAudit=selectedRow[0].data['IsAudit'];
	var realedate=selectedRow[0].data['realedate'];
	var state=selectedRow[0].data['state'];
	//alert(IsSubmit+"^"+IsAudit+"^"+realedate+"^"+state);
	var date = new Date(new Date()); //Date();
	var today=date.format('Y-m-d'); 
	if((IsSubmit=="Y")&&(IsAudit=="Y")&&(today>=realedate)&&(realedate!=="")){
		addButton.hide();
		editButton.hide();
		delButton.hide();
		UploadButton.hide();
		}
	else if(state!=="1"){
		addButton.hide();
		editButton.hide();
		delButton.hide();
		UploadButton.hide();
		}
	else{
		addButton.show();
		editButton.show()
		delButton.show();
		UploadButton.show();
		}
	
});
