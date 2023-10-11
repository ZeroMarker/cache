EditPaperfun = function() {

		var projUrl = 'herp.srm.srmapplypaperexe.csp';
		var userkdr   = session['LOGON.USERID'];	
		//var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		//var len = rowObj.length;


//������Ŀ
var addtitleText = new Ext.form.TextField({
	width : 300,
	selectOnFocus : true
});

var SubUserText = new Ext.form.TextField({
	width : 100,
	selectOnFocus : true
});
SubUserText.setValue(userkdr);




		
//��¼���ݿ������
var RecordTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', 'SCIE'], ['2', 'CSTPCD'], ['3', '����']]
		});
var RecordTypeField = new Ext.form.ComboBox({
			fieldLabel : '��������',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : RecordTypeStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
//�ڿ�����
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
			fieldLabel : '�ڿ�����',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : JournalDs,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//������ʽ
var PTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����'], ['2', '����']]
		});
var PTypeField = new Ext.form.ComboBox({
			fieldLabel : '������ʽ',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : PTypeStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//����		
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
//��һ����
var addFristAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '��һ���� ',
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
//���е�һ����		
var addTFAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '��һ���� ',
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
//��һ�����Ƿ�Ϊ�о���
var IsGraduateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '��'], ['N', '��']]
		});
var IsGraduate = new Ext.form.ComboBox({
			fieldLabel : '��һ�����Ƿ�Ϊ�о���',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : IsGraduateStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//��ʦ1
var addMentor1Combo = new Ext.form.ComboBox({
			fieldLabel : '��ʦ1 ',
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
//��һ�����Ƿ�Ϊ��ҵ�������о���
var IsInTwoYearStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '��'], ['N', '��']]
		});
var IsInTwoYear = new Ext.form.ComboBox({
			fieldLabel : '��һ�����Ƿ�Ϊ�о���',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : IsInTwoYearStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//��ʦ2
var addMentor2Combo = new Ext.form.ComboBox({
			fieldLabel : '��ʦ2 ',
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
//ͨ������		
var addCorrAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : 'ͨ������ ',
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
		
//����ͨѶ����
	var addTCAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '����ͨ������ ',
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
		
		
//����
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
			fieldLabel : '�����˿�������',
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
		
//��һ���߿���
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
			fieldLabel : '��һ���߿���',
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

//���е�һ���߿���
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
			fieldLabel : '���е�һ���߿���',
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
			
//ͨ�����߿���
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
			fieldLabel : 'ͨ�����߿���',
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
	 
//����ͨ�����߿���
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
			fieldLabel : '����ͨ�����߿���',
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
	 
//��������
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
						value:'<center><p style="font-weight:bold;font-size:150%">���ķ�������</p></center>',
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
						value:'<p style="font-weight:bold">������Ŀ:</p>',
						columnWidth:.1
					},
					addtitleText,
					{
						xtype:'displayfield',
						value:'<p style="font-weight:bold">������:</p>',
						columnWidth:.08
					},
					SubUserText,
					{
						xtype:'displayfield',
						value:'<p style="font-weight:bold">�������:</p>',
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
						value:'��¼����:',
						columnWidth:.08
					},
					RecordTypeField,
					{
						xtype:'displayfield',
						value:'�ڿ�����:',
						columnWidth:.08
					},
					JournalField,
					{
						xtype:'displayfield',
						value:'������ʽ:',
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
						value:'��һ����',
						columnWidth:.06
					},
					addFristAuthorCombo,
					{
						xtype:'displayfield',
						value:'��һ���߿���:',
						columnWidth:.08
					},
					FAuthorDeptCombo,
					{
						xtype:'displayfield',
						value:'���е�һ����',
						columnWidth:.08
					},
					addTFAuthorCombo,
					{
						xtype:'displayfield',
						value:'���е�һ���߿���:',
						columnWidth:.08
					},
					TFAuthorDeptCombo,
					{
						xtype:'displayfield',
						value:'��һ�����Ƿ�Ϊ�ڶ��о���',
						columnWidth:.05
					},
					IsGraduate
					
					
				]
			}
			]
		});
	
	
	
	
	
	
	
	
	addButton = new Ext.Toolbar.Button({
		text:'ȷ��'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
		addHandler = function(){      			
						

		   var view= encodeURIComponent(Ext.getCmp('textArea').getRawValue()) 

		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:projUrl+'?action=noaudit'+'&rowid='+rowObj[i].get("rowid")+'&view='+view+'&usercheckdr='+usercheckdr,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
								itemGrid.load({params:{start:0, limit:12,usercheckdr:usercheckdr}});	
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:'����ʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else{
				Ext.Msg.show({title:'����',msg:'������ҳ���ϵĴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
			addwin.close();
   }
	////// ��Ӽ����¼� ////////////////	
		addButton.addListener('click',addHandler,false);

		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
		
		cancelHandler = function(){
			addwin.close();
		}
		
		cancelButton.addListener('click',cancelHandler,false);

		addwin = new Ext.Window({
			title: '��������',
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


