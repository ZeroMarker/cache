
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERCODE'];	   

var projUrl = 'herp.srm.srmprojectsapplyexe.csp';

// 定义起始时间控件
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});

	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	
 ///科室名称
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList', 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///课题来源
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList', 
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
			fieldLabel : '课题来源',
			store : SubSourceDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////////科研审批结果
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '等待审批'], ['1', '通过'], ['2', '不通过']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '科研审批结果',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

//////课题负责人
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
// ////////////课题名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});
		

/////////////////// 查询按钮 
function srmFundApply(){
		var startdate= PSField.getValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    var enddate= PEField.getValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var SubSource= SubSourceCombo.getValue();
	    var ResAudit  = ChkResultField.getValue();
	    var HeadDr= userCombo.getValue();
	    var PName = titleText.getValue();     
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    ApplyStart: startdate,
		    Applyend: enddate,
		    deptdr: dept,
		    SubSource: SubSource,
		    ResAudit: ResAudit,
		    HeadDr: HeadDr,
		    PName: PName   
		   }
	  });
  }


var queryPanel = new Ext.FormPanel({
			height:150,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					     {   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:150%">项目申请材料</p></center>',
						columnWidth:1,
						height:'50'
					 }]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'申请时间:',
						columnWidth:.1
					},
					PSField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.06
					},{
						xtype:'displayfield',
						value:'至',
						columnWidth:.07
					},
					PEField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'科室:',
						columnWidth:.08
					},
					deptCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.05
					},{
						xtype:'displayfield',
						value:'课题来源:',
						columnWidth:.1
					},
					SubSourceCombo
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'审核状态:',
						columnWidth:.09
					},
					ChkResultField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						xtype:'displayfield',
						value:'课题负责人:',
						columnWidth:.09
					},
					userCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.05
					},
					{
						xtype:'displayfield',
						value:'课题名称:',
						columnWidth:.1
					},
					titleText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.05
					},
					{
						columnWidth:0.05,
						xtype:'button',
						text: '查询',
						handler:function(b){
							srmFundApply();
						},
						iconCls: 'add'
					}		
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    //title: '论文申请审批',
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // 是否自动刷新
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '课题ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Dept',
						header : '科室',
						width : 120,
						editable:false,
						dataIndex : 'Dept'

					},{
						id : 'Name',
						header : '课题名称',
						editable:false,
						width : 150,
						dataIndex : 'Name'
					},{
						id : 'Head',
						header : '项目负责人',
						editable:false,
						width : 90,
						dataIndex : 'Head'

					}, {
						id : 'Sex',
						header : '性别',
						editable:false,
						width : 60,
						dataIndex : 'Sex'
					},{
						id : 'BirthDay',
						header : '出生年月',
						width : 100,
						editable:false,
						dataIndex : 'BirthDay'
					}, {
						id : 'TName',
						header : '技术职称',
						width : 100,
						editable : false,
						dataIndex : 'TName'
						
					},{
						id : 'Phone',
						header : '联系电话',
						width : 120,
						editable:false,
						dataIndex : 'Phone'

					},{
						id : 'EMail',
						header : '邮箱地址',
						width : 150,
						editable:false,
						dataIndex : 'EMail'

					},{
						id : 'Participants',
						header : '课题参加人员',
						width : 200,
						editable:false,
						dataIndex : 'Participants'

					},{
						id : 'PTName',
						header : '课题来源',
						width : 120,
						editable:false,
						dataIndex : 'PTName'

					},{
						id : 'RelyUnit',
						header : '课题依托单位',
						width : 200,
						editable:false,
						dataIndex : 'RelyUnit'

					},{
						id : 'AppFunds',
						header : '申请经费（万元）',
						width : 120,
						editable:false,
						dataIndex : 'AppFunds'

					},{
						id : 'StartDate',
						header : '开始时间',
						width :120,
						editable:false,
						dataIndex : 'StartDate'

					},{
						id : 'EndDate',
						header : '截止时间',
						width : 120,
						editable:false,
						dataIndex : 'EndDate'

					},{
						id : 'Remark',
						header : '备注',
						width :180,
						editable:false,
						dataIndex : 'Remark'

					},{
						id : 'SubUser',
						header : '申请人',
						width : 100,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '申请时间',
						width : 100,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'DataStatuslist',
						header : '状态',
						width : 60,
						editable:false,
						//hidden:true,
						dataIndex : 'DataStatuslist'

					},{
						id : 'ChkResult',
						header : '科研科审核状态',
						editable:false,
						width : 120,
						
						hidden:true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '科研科审核状态',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ChkResultlist']
						if (sf == "等待审核") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "审核通过") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "审核不通过"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						width : 120,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '科研科审批意见',
						width : 120,
						editable:false,
						dataIndex : 'Desc'
					},{
						id : 'ProjStatus',
						header : '项目状态',
						width : 60,
						editable:false,
						dataIndex : 'ProjStatus'
					}]					
		});



 
///////////////////添加按钮///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '添加',
    	tooltip: '添加新的专利成果',        
    	iconCls: 'add',
		handler: function(){addFun();}
});

/////////////////修改按钮/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的专利成果',
		iconCls: 'remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var InventorsIDs = rowObj[0].get("InventorsIDs");
				//alert(InventorsIDs);			
				if(state == "未提交" ){editFun(InventorsIDs);}
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////删除按钮//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的专利成果',
		iconCls: 'remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'提示',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");			
				if(state == "未提交" ){delFun();}
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////提交按钮//////////////////////////
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'提交',
		tooltip:'提交选定的专利成果',
		iconCls:'add',
		handler:function(){subFun();}	
});


  itemGrid.addButton('-');
  itemGrid.addButton(addPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(subPatentInfoButton);



  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
 


