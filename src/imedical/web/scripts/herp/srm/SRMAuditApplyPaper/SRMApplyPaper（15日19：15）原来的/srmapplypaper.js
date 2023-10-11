var userdr = session['LOGON.USERID'];    
var projUrl = 'herp.srm.srmapplypaperexe.csp';

//alert(userdr)
// 定义起始时间控件
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		format : 'Y-m-d',
		fieldLabel:'开始日期',
		width : 100,
		editable:true,
		emptyText : '请选择开始日期...'
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		format : 'Y-m-d',
		fieldLabel:'结束日期',
		width : 100,
		editable:true,
		emptyText : '请选择结束日期...'
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
						//url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=deptList&userdr='+userdr,method:'POST'
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
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


// ///////////////////论文题目
var titleText = new Ext.form.TextField({
	width : 100,
	selectOnFocus : true
});

// ///////////////////期刊名称
var jnameText = new Ext.form.TextField({
	width :100,
	selectOnFocus : true
});

/////第一作者  
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

var user1Combo = new Ext.form.ComboBox({
			fieldLabel : '第一作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 110,
			listWidth : 110,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
var user2Combo = new Ext.form.ComboBox({
			fieldLabel : '通信作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

/////////////////// 查询按钮 
function srmFundApply(){
	    var startdate= PSField.getRawValue();
	    var enddate = PEField.getRawValue();
	    var dept  = deptCombo.getValue();
	    var title = titleText.getRawValue(); 
	    var jname = jnameText.getRawValue();
	    var FristAuthor= user1Combo.getValue();
      var CorrAuthor = user2Combo.getValue();
      var data=startdate+"^"+enddate+"^"+dept+"^"+title+"^"+jname+"^"+FristAuthor+"^"+CorrAuthor+"^"+userdr
     // alert(data)
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    SubDateStart:startdate,
		    SubDateEnd:enddate,
		    DeptDr:dept,
		    userdr:userdr,
		    Title:title,
		    JName:jname,
		    FristAuthor:FristAuthor,
		    CorrAuthor:CorrAuthor
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
						value:'<center><p style="font-weight:bold;font-size:150%">论文发表申请</p></center>',
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
						columnWidth:.08
					},
					PSField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.01
					},
					{
						xtype:'displayfield',
						value:' 至',
						columnWidth:.04
					},
					PEField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'科室:',
						columnWidth:.053
					},
					deptCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},{
						xtype:'displayfield',
						value:'论文题目:',
						columnWidth:.08
					},
					titleText
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'期刊名称:',
						columnWidth:.08
					},
					jnameText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.01
					},
					{
						xtype:'displayfield',
						value:'第一作者:',
						columnWidth:.08
					},
					user1Combo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.06
					},
					{
						xtype:'displayfield',
						value:'通信作者:',
						columnWidth:.08
					},
					user2Combo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},
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
var AddButton = new Ext.Toolbar.Button({
					text : '添加',
					iconCls : 'add',
					handler : function() {
						 AddPaperfun();
				   }
  });
   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '修改',
					iconCls : 'add',
					handler : function() {
						 EditPaperfun()
				   }
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	      text : '删除',
					iconCls : 'add',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			alert(state);
			if(state == "0" ){ 
				delFun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
  });
  
  var SubmitButton = new Ext.Toolbar.Button({
   	      text : '提交',
					iconCls : 'option',
					handler : function() {
						 SubmitPaperfun()
				   }
  });	
  	
var itemGrid = new dhc.herp.Grid({
		    //title: '论文申请',
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // 是否自动刷新
		    tbar:[AddButton,UpdateButton,DeleteButton,SubmitButton],
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RecordType',
						header : '被数据库收录',
						editable:false,
						width : 80,
						dataIndex : 'RecordType'
					},{
						id : 'Dept',
						header : '科室',
						width : 120,
						editable:false,
						dataIndex : 'Dept'

					},{
						id : 'Title',
						header : '论文题目',
						editable:false,
						width : 120,
						dataIndex : 'Title'

					}, {
						id : 'JName',
						header : '期刊名称',
						editable:false,
						width : 120,
						dataIndex : 'JName'
					}, {
						id : 'FristAuthorName',
						header : '第一作者',
						width : 60,
						editable : false,
						dataIndex : 'FristAuthorName'
						
					},{
						id : 'FAuthorDeptName',
						header : '第一作者科室',
						width : 120,
						editable:false,
						dataIndex : 'FAuthorDeptName'

					},{
						id : 'TFAuthorName',
						header : '并列第一作者',
						width : 80,
						editable:false,
						dataIndex : 'TFAuthorName'

					},{
						id : 'TFAuthorDept',
						header : '并列第一作者科室',
						width : 120,
						editable:false,
						dataIndex : 'TFAuthorDept'

					},{
						id : 'IsGraduate',
						header : '第一作者是否为在读研究生',
						width : 70,
						editable:false,
						dataIndex : 'IsGraduate'

					},{
						id : 'Mentor1Name',
						header : '导师1',
						width : 60,
						editable:false,
						dataIndex : 'Mentor1Name'

					},{
						id : 'IsInTwoYear',
						header : '第一作者是否为毕业两年内研究生',
						width : 100,
						editable:false,
						dataIndex : 'IsInTwoYear'

					},{
						id : 'Mentor2Name',
						header : '导师2',
						width : 120,
						editable:false,
						dataIndex : 'Mentor2Name'

					},{
						id : 'CorrAuthorName',
						header : '通讯作者',
						width : 100,
						editable:false,
						dataIndex : 'CorrAuthorName'

					},{
						id : 'CorrAuthorDept',
						header : '通讯作者科室',
						width : 100,
						editable:false,
						dataIndex : 'CorrAuthorDept'

					},{
						id : 'TCAuthorName',
						header : '并列通讯作者',
						width : 100,
						editable:false,
						dataIndex : 'TCAuthorName'

					},{
						id : 'TCAuthorDept',
						header : '并列通讯作者科室',
						width : 100,
						editable:false,
						dataIndex : 'TCAuthorDept'

					},{
						id : 'SubUserName',
						header : '申请人',
						editable:false,
						width : 60,
						dataIndex : 'SubUserName'
					},{
						id : 'SubDate',
						header : '申请时间',
						width : 100,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '提交状态',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'DataStatus'
					},{
						id : 'ChkResult',
						header : '审批结果',
						editable:false,
						width : 120,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '审批状态',
						editable:false,
						width : 120,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '审批意见',
						width : 120,
						editable:false,
						dataIndex : 'Desc'
					}]					
		});

 /**
  itemGrid.addButton('-');
  itemGrid.addButton(AddPaperButton);
  itemGrid.addButton('-');
**/

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  //itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

