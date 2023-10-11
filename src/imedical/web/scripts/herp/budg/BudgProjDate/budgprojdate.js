var loginuser = session['LOGON.USERID'];
var budgprojectdictDs=function(){
		itemGrid.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgprojectdictexe.csp?action=list&year='+ 
							yearField.getValue().trim()+ 
							'&deptdr='+ deptField.getValue().trim()+ 
							'&property='+ propertycomb.getValue().trim()+ 
							'&state='+ statecomb.getValue().trim()+  
							'&isgovbuy='+ isgovbuycomb.getValue().trim()+'&userdr='+loginuser,
							method : 'GET'
						});
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								userdr:loginuser,
								year:yearField.getValue().trim(),
								deptdr:deptField.getValue().trim(),
								property:propertycomb.getValue().trim(),
								state:statecomb.getValue().trim(),
								isgovbuy:isgovbuycomb.getValue().trim()
							}
						});
};

setdatefun=function(){
		var proj = projField.getValue();	
		var budgDeptDR = dept2Field.getValue();
		var deptdr = dept1Field.getValue();		
		var realedate = endDateField.getValue();
		if(realedate=="")
		{
			Ext.Msg.show({title:'注意',msg:'请设置截止时间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var realedate = endDateField.getValue().format("Y-m-d");
		if((proj=="")&&(budgDeptDR=="")&&(deptdr==""))
		{
			Ext.Msg.show({title:'注意',msg:'请至少选择一个设置条件!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			Ext.MessageBox.confirm('提示','确定要设置吗?',function(btn){
			if(btn == 'yes'){
			Ext.Ajax.request({
				url:'herp.budg.budgprojdateexe.csp?action=updatedate&rowid='+proj+'&budgDeptDR='+budgDeptDR+'&deptdr='+deptdr+'&realedate='+realedate,
				waitMsg:'审核中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0,limit:25}});
					}else{
						Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});   	
				}
				} 
			)	
		}
};

//查询年度
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojectdictexe.csp'+'?action=year&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: yearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//查询科室名称
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
	minChars: 1,
	pageSize: 10,
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
	minChars: 1,
	pageSize: 10,
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
	minChars: 1,
	pageSize: 10,
	store: isgovbuyStore,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'是否政府采购...',
	mode: 'local', //本地模式
	selectOnFocus:true,
	forceSelection:true
});
//查询项目名称
var projDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

projDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojdateexe.csp'+'?action=proj&userdr='+loginuser+'&str='+encodeURIComponent(Ext.getCmp('projField').getRawValue()),method:'POST'});
});

var projField = new Ext.form.ComboBox({
	id: 'projField',
	fieldLabel: '项目名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: projDs,
	valueField: 'rowid',
	displayField:'name',
	triggerAction: 'all',
	emptyText:'请选择需要设置的项目...',
	name: 'projField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var endDateField= new Ext.form.DateField({
	format:'Y-m-d',
	width:150,
	emptyText:'结束时间...',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	},
	minChars: 1
});
//查询预算科室名称
var dept2Ds = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

dept2Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojdateexe.csp'+'?action=getdept2&str='+encodeURIComponent(Ext.getCmp('dept2Field').getRawValue()),method:'POST'});
});

var dept2Field = new Ext.form.ComboBox({
	id: 'dept2Field',
	fieldLabel: '责任科室',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: dept2Ds,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'dept2Field',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询责任科室名称
var dept1Ds = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

dept1Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojdateexe.csp'+'?action=getdept&str='+encodeURIComponent(Ext.getCmp('dept1Field').getRawValue()),method:'POST'});
});

var dept1Field = new Ext.form.ComboBox({
	id: 'dept1Field',
	fieldLabel: '预算科室',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: dept1Ds,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'dept1Field',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var sencondname="----------------------------------------------------------------------------------分割线-------------------------------------------------------------------------------"
var queryPanel = new Ext.FormPanel({
	height : 230,
	region : 'north',
	frame:true,
	defaults: {bodyStyle:'padding:5px'},
		items:[{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'<center><p style="font-weight:bold;font-size:140%">项目截止时间设置</p></center>',
				columnWidth:1,
				height:'31'
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
				columnWidth:.18
			},
			yearField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.1
			},{
				xtype:'displayfield',
				value:'责任科室:',
				columnWidth:.16
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
				columnWidth:.16
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
				columnWidth:.12
			},
			statecomb,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.07
			},
			{
				xtype:'displayfield',
				value:'政府采购:',
				columnWidth:.11
			},
			isgovbuycomb,
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
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">'+sencondname+'</p>',
			columnWidth : 1,
			height : '25'
		}]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'项目名称:',
				columnWidth:.18
			},
			projField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.088
			},
			{
				xtype:'displayfield',
				value:'预算科室:',
				columnWidth:.18
			},
			dept1Field,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.085
			},
			{
				xtype:'displayfield',
				value:'责任科室:',
				columnWidth:.18
			},
			dept2Field
		]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'截止时间:',
				columnWidth:.1
			},
			endDateField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
			},
			{
				columnWidth:.1,
				xtype:'button',
				text: '设置',
				handler:function(b){
					setdatefun();
				},
				iconCls: 'add'
			}/**/		
		]
	}
	]
});

var itemGrid = new dhc.herp.Grid({
			width : 400,
			region : 'center',
			url : 'herp.budg.budgprojdateexe.csp',
			listeners : {
		    'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                 var record = grid.getStore().getAt(rowIndex);
		                 if ((record.get('rowid') =="审核")&&((columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==12)||(columnIndex==13)||(columnIndex==14))) {
		                      return false;
		                  } else if((record.get('rowid')=="")&&((columnIndex==9)||(columnIndex==10)||(columnIndex==11))){
		                  		return false;
		                  }
		                  else {return true;}
		               },
		    'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
					if ((record.get('rowid') =="审核")&&((columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==12)||(columnIndex==13)||(columnIndex==14))) {
		                      return false;
					} else if((record.get('rowid')=="")&&((columnIndex==9)||(columnIndex==10)||(columnIndex==11))){
		                 return false;
		           }
		           else {
							return true;
					}
				}
        	},
			fields : [{
		    id:'rowid',
	    	header: 'id',
	        dataIndex: 'rowid',
	        width: 80,		  
	        hidden: true,
	        sortable: true
	    },{
            id:'CompName',
            header: '医疗单位',
			calunit:true,
			allowBlank: false,
			width:120,
			hidden: true,
            dataIndex: 'CompName'
        },{           
	         id:'year',
	         header: '年度',
	         width:60,
	         editable:false,
	         dataIndex: 'year',
	         sortable: true
	    },{ 
	        id:'code',
	    	header: '项目编号',
	        dataIndex: 'code',
	        width: 100,	
	        editable:false,	  
	        sortable: true
	    },{
	        id:'name',
	    	header: '项目名称',
	        dataIndex: 'name',
	        editable:false,
	        width: 200,
	        sortable: true
	    },{           
	         id:'budgDeptDR',
	         header: '预算科室id',
	         editable:false,
	         width:60,
	         dataIndex: 'budgDeptDR',
	         hidden: true
	    },{           
	         id:'bdeptname',
	         header: '预算科室',
	         editable:false,
	         width:100,
	         dataIndex: 'bdeptname'
	    },{
		    id:'deptdr',
	    	header: '责任科室id',
	        dataIndex: 'deptdr',
	        width: 60,		  
	        hidden: true,
	        editable:false,
	        sortable: true
	    },{
		    id:'deptname',
	    	header: '责任科室',
	        dataIndex: 'deptname',
	        width: 100,		
	        editable:false,  
	        sortable: true
	    },{ 
	        id:'userdr',
	    	header: '负责人',
	        dataIndex: 'userdr',
	        width: 100	,  
	        hidden:true,
	        editable:false,
	        sortable: true
	    },{ 
	        id:'username',
	    	header: '负责人',
	        dataIndex: 'username',
	        editable:false,
	        width: 70,		  
	        sortable: true
	    },{           
	         id:'statelist',
	         header: '项目状态',
	         allowBlank: false,
	         width:70,
	         dataIndex: 'statelist'
	    },{
	        id:'realsdate',
	    	header: '实际开始时间',
	        dataIndex: 'realsdate',
	        width: 120,
	        sortable: true,
	        hidden: true
	    },{           
	         id:'realedate',
	         header: '实际结束时间',
	         allowBlank: false,
	         width:120,
	         dataIndex: 'realedate'
	    }],
					viewConfig : {forceFit : true},
					atLoad : true//, // 是否自动刷新					
//
		});
// 主页面查询
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'find',
			handler : function() {
				// var billMakerTimeEnd
				// =((billMakerTimeTo.getValue()=='')?'':billMakerTimeTo.getValue().format('Y-m-d'));
				var syear = yearCombo.getValue();
				var sSchemType = schemTypeCombo.getValue();
				//alert(sSchemType);
				var sSchemeName = schemNo.getValue();

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								byear : syear,
								schemtype : sSchemType,
								str : sSchemeName
							}
						});

			}
			
		})

// 给主页面添加查询按钮
	//itemGrid.addButton(findButton);
	//itemGrid.addButton('-');
	itemGrid.btnAddHide() 	//隐藏增加按钮
	itemGrid.btnSaveHide() 	//隐藏保存按钮
	itemGrid.btnResetHide() 	//隐藏重置按钮
	itemGrid.btnDeleteHide() //隐藏删除按钮
	itemGrid.btnPrintHide() 	//隐藏打印按钮
// itemgrid.hiddenbutton(3);
