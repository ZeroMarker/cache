EditPaperfun = function() {

		var projUrl = 'herp.srm.srmapplypaperexe.csp';
		var userkdr   = session['LOGON.USERID'];	
		//var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		//var len = rowObj.length;


//论文题目
var addtitleText = new Ext.form.TextField({
	width : 300,
	selectOnFocus : true
});

var SubUserText = new Ext.form.TextField({
	width : 100,
	selectOnFocus : true
});
SubUserText.setValue(userkdr);




		
//收录数据库的类型
var RecordTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', 'SCIE'], ['2', 'CSTPCD'], ['3', '其他']]
		});
var RecordTypeField = new Ext.form.ComboBox({
			fieldLabel : '论文类型',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : RecordTypeStore,
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
		
//期刊名称
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=JournalList',
						method : 'POST'
					});
		});
var JournalField = new Ext.form.ComboBox({
			fieldLabel : '期刊名称',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : JournalDs,
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
//发表形式
var PTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '国内'], ['2', '国外']]
		});
var PTypeField = new Ext.form.ComboBox({
			fieldLabel : '发表形式',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : PTypeStore,
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
//作者		
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
//第一作者
var addFristAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '第一作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 110,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//并列第一作者		
var addTFAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '第一作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 110,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//第一作者是否为研究生
var IsGraduateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '是'], ['N', '否']]
		});
var IsGraduate = new Ext.form.ComboBox({
			fieldLabel : '第一作者是否为研究生',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : IsGraduateStore,
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
//导师1
var addMentor1Combo = new Ext.form.ComboBox({
			fieldLabel : '导师1 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 110,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//第一作者是否为毕业两年内研究生
var IsInTwoYearStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '是'], ['N', '否']]
		});
var IsInTwoYear = new Ext.form.ComboBox({
			fieldLabel : '第一作者是否为研究生',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : IsInTwoYearStore,
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
//导师2
var addMentor2Combo = new Ext.form.ComboBox({
			fieldLabel : '导师2 ',
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
//通信作者		
var addCorrAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '通信作者 ',
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
		
//并列通讯作者
	var addTCAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '并列通信作者 ',
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
		
		
//科室
var subdeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

subdeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&userdr='+userkdr, 
                        method:'POST'
					});
		});

var subdeptCombo = new Ext.form.ComboBox({
			fieldLabel : '申请人科室名称',
			store : subdeptDs,
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
		
//第一作者科室
var FAuthorDeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

FAuthorDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=UserDeptList&UserId='+addFristAuthorCombo.getvalue(), 
                        method:'POST'
					});
		});

var FAuthorDeptCombo = new Ext.form.ComboBox({
			fieldLabel : '第一作者科室',
			store : FAuthorDeptDs,
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

//并列第一作者科室
var TFAuthorDeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

TFAuthorDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=UserDeptList&UserId='+addTFAuthorCombo.getvalue(), 
                        method:'POST'                                 
					});
		});

var TFAuthorDeptCombo = new Ext.form.ComboBox({
			fieldLabel : '并列第一作者科室',
			store : TFAuthorDeptDs,
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
			
//通信作者科室
var CorrAuthorDeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

CorrAuthorDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=UserDeptList&UserId='+addCorrAuthorCombo.getvalue(), 
                        method:'POST'                                 
					});
		});

var CorrAuthorDeptCombo = new Ext.form.ComboBox({
			fieldLabel : '通信作者科室',
			store : CorrAuthorDeptDs,
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
	 
//并列通信作者科室
 var TCAuthorDeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

TCAuthorDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=UserDeptList&UserId='+addTCAuthorCombo.getvalue(), 
                        method:'POST'                                 
					});
		});

var TCAuthorDeptCombo = new Ext.form.ComboBox({
			fieldLabel : '并列通信作者科室',
			store : TCAuthorDeptDs,
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
	 
//申请日期
var DateField = new Ext.form.DateField({
		id : 'DateField',
		format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	}); 
	 
	 
	 
	 var formPanel = new Ext.form.FormPanel({
		labelWidth: 80,
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
						value:'<p style="font-weight:bold">论文题目:</p>',
						columnWidth:.1
					},
					addtitleText,
					{
						xtype:'displayfield',
						value:'<p style="font-weight:bold">申请人:</p>',
						columnWidth:.08
					},
					SubUserText,
					{
						xtype:'displayfield',
						value:'<p style="font-weight:bold">申请科室:</p>',
						columnWidth:.08
					},
					subdeptCombo,
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
				{
						xtype:'displayfield',
						value:'收录类型:',
						columnWidth:.08
					},
					RecordTypeField,
					{
						xtype:'displayfield',
						value:'期刊名称:',
						columnWidth:.08
					},
					JournalField,
					{
						xtype:'displayfield',
						value:'发表形式:',
						columnWidth:.08
					},
					PTypeField,
					]
					},{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'第一作者',
						columnWidth:.06
					},
					addFristAuthorCombo,
					{
						xtype:'displayfield',
						value:'第一作者科室:',
						columnWidth:.08
					},
					FAuthorDeptCombo,
					{
						xtype:'displayfield',
						value:'并列第一作者',
						columnWidth:.08
					},
					addTFAuthorCombo,
					{
						xtype:'displayfield',
						value:'并列第一作者科室:',
						columnWidth:.08
					},
					TFAuthorDeptCombo,
					{
						xtype:'displayfield',
						value:'第一作者是否为在读研究生',
						columnWidth:.05
					},
					IsGraduate
					
					
				]
			}
			]
		});
	
	
	
	
	
	
	
	
	addButton = new Ext.Toolbar.Button({
		text:'确定'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
		addHandler = function(){      			
						

		   var view= encodeURIComponent(Ext.getCmp('textArea').getRawValue()) 

		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:projUrl+'?action=noaudit'+'&rowid='+rowObj[i].get("rowid")+'&view='+view+'&usercheckdr='+usercheckdr,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'操作成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
								itemGrid.load({params:{start:0, limit:12,usercheckdr:usercheckdr}});	
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'操作失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else{
				Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
			addwin.close();
   }
	////// 添加监听事件 ////////////////	
		addButton.addListener('click',addHandler,false);

		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
		
		cancelHandler = function(){
			addwin.close();
		}
		
		cancelButton.addListener('click',cancelHandler,false);

		addwin = new Ext.Window({
			title: '论文申请',
			width: 800,
			height: 600,
			//autoHeight: true,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});		
		addwin.show();			
}


