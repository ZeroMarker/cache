var userdr = session['LOGON.USERCODE'];    
var projUrl = 'herp.srm.srmauditapplypaperexe.csp';
/**
Ext.Ajax.request({
					url: projUrl+'?action=GetUserdr&userdr='+userdr,			
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcodes = jsonData.info;													
						}else{
						    message="�Բ�����û�����Ȩ��!";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
 });
**/
///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
//////////////////////������ʼʱ��ؼ�
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		width : 120
		//emptyText : ''
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		width : 120
		//emptyText : ''	
	});
	
/////////////////////��������
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
            id:'deptCombo',
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''

		});


/////////////////////������Ŀ///////////
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true,
	labelSeparator:''

});

//////////////////��һ����///////////  
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('user1Combo').getRawValue()), 
						method : 'POST'
					});
		});

var user1Combo = new Ext.form.ComboBox({
            id:'user1Combo',
			fieldLabel : '��һ���� ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''

		});
		
//////////////����///////////  
/*
var user2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

user2Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('AuthorName').getRawValue()), 
						method : 'POST'
					});
		});

var AuthorName = new Ext.form.ComboBox({
            id:'AuthorName',
			fieldLabel : '���� ',
			store : user2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			name:'AuthorName',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
*/	
//////////////�������///////////////
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�ȴ�����'], ['2', 'ͨ��'], ['3', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''

         });

// ///////////////////�ڿ�����
var JournalNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


JournalNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.paperpublishregisterexe.csp'+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('JournalName').getRawValue()),method:'POST'});
});

var JournalName = new Ext.form.ComboBox({
	id: 'JournalName',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:JournalNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���ڿ�����...',
	name: 'JournalName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});

///////////��ѯ��ť////////////// 
function srmFundApply(){
	    var startdate= PSField.getRawValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    //alert(startdate);
	    var enddate = PEField.getRawValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var title = titleText.getValue(); 
	   	//var AuthorName = AuthorNameText.getValue();
	    var FristAuthor= user1Combo.getValue();
        //var CorrAuthor = user2Combo.getValue();
      var jname = JournalName.getRawValue();
      var ChkResult  = ChkResultField.getValue();
	  var type  = TypeCombox.getValue();
		itemGrid.load({
		    params:{
			sortField:'',
			sortDir:'',
		    start:0,
		    limit:25,
		    startdate:startdate,
		    enddate:enddate,
		    dept:dept,
		    userdr:userdr,
		    title:title,
		    jname:jname,
		    FristAuthor:FristAuthor,
		    ChkResult:ChkResult,
			Type:type
		   }
	  });
  }


var queryPanel = new Ext.FormPanel({
			autoHeight : true,
	region : 'north',
	frame : true,
	title : '����Ͷ�������Ϣ��ѯ',
	iconCls : 'search',	
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">����</p>',
						width : 30			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					TypeCombox,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">������Ŀ</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					titleText,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">�ڿ�����</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					JournalName,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��������</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PSField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:center;">��</p>',
						width : 20			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PEField,
					{
						xtype : 'displayfield',
						value : '',
						width : 30
					},
					{
						width : 30,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							srmFundApply();
						},
						iconCls : 'search'
					}
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">����</p>',
						width : 30			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					deptCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��һ����</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					user1Combo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">�������</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					ChkResultField
					
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    title: '����Ͷ�������Ϣ�б�',
			iconCls: 'list',
		    region : 'center',
		    url: projUrl,
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '�����ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '����',
						editable:false,
						width : 40,
						dataIndex : 'Type'

					}, {
						id : 'Title',
						header : '��������',
						editable:false,
						width : 180,
						dataIndex : 'Title',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
						id : 'FristAuthorName',
						header : '��һ����(ͨѶ����)',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
						
					},{
						id : 'JName',
						header : '�ڿ�����',
						editable:false,
						width : 180,
						dataIndex : 'JName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, {
						id : 'PressName',
						header : '������',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'JName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, {
						id : 'Content',
						header : '����',
						editable:false,
						width : 60,
						dataIndex : 'Content'
					},{
						id : 'ParticipantsName',
						header : '��������',
						width : 120,
						hidden : true,
						editable:false,
						dataIndex : 'ParticipantsName'

					},{
						id : 'IsMultiContribution',
						header : 'һ���Ͷ',
						width : 60,
						editable:false,
						dataIndex : 'IsMultiContribution'

					},{
						id : 'IsKeepSecret',
						header : '�漰����',
						width : 60,
						editable:false,
						dataIndex : 'IsKeepSecret'

					},{
						id : 'PrjName',
						header : '���л�������',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjName'

					},{
						id : 'PrjCN',
						header : '��ͬ��',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjCN'

					},{
						id : 'SubUserDR',
						header : '������ID',
						editable:false,
						width : 120,
						hidden: true,
						dataIndex : 'SubUserDR'
					},{
						id : 'SubUserName',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'SubUserName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'Dept',
						header : '�����˿���',
						width : 120,
						editable:false,
						dataIndex : 'Dept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '�ύ״̬',
						editable:false,
						width : 60,
						dataIndex : 'DataStatus'
					},{
						id : 'Chercker',
						header : '�����',
						editable:false,
						width : 60,
						dataIndex : 'Chercker',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'CheckDate'
					},{
						id : 'ChkResult',
						header : '�������',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '����״̬',
						editable:false,
						width : 100,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '�������',
						width : 100,
						editable:false,
						dataIndex : 'Desc'
						
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					}]					
		});
		
var AuditButton  = new Ext.Toolbar.Button({
		text: 'ͨ��',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("ChkResult")!='�ȴ�����')
		    
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){		
					    Ext.Ajax.request({
						url:'herp.srm.srmauditapplypaperexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
});


  var NoAuditButton = new Ext.Toolbar.Button({
					text : '��ͨ��',
					iconCls: 'pencil',
					handler : function() {
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("ChkResult")!='�ȴ�����')
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
  
  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


downloadMainFun(itemGrid,'rowid','P001',24);
