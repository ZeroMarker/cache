var userdr = session['LOGON.USERID'];    
var projUrl = 'herp.srm.srmapplypaperexe.csp';

//alert(userdr)
// ������ʼʱ��ؼ�
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		format : 'Y-m-d',
		fieldLabel:'��ʼ����',
		width : 100,
		editable:true,
		emptyText : '��ѡ��ʼ����...'
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		format : 'Y-m-d',
		fieldLabel:'��������',
		width : 100,
		editable:true,
		emptyText : '��ѡ���������...'
	});
		
		
 ///��������
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
			fieldLabel : '��������',
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


// ///////////////////������Ŀ
var titleText = new Ext.form.TextField({
	width : 100,
	selectOnFocus : true
});

// ///////////////////�ڿ�����
var jnameText = new Ext.form.TextField({
	width :100,
	selectOnFocus : true
});

/////��һ����  
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
			fieldLabel : '��һ���� ',
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
			fieldLabel : 'ͨ������ ',
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

/////////////////// ��ѯ��ť 
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
						value:'����ʱ��:',
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
						value:' ��',
						columnWidth:.04
					},
					PEField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'����:',
						columnWidth:.053
					},
					deptCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},{
						xtype:'displayfield',
						value:'������Ŀ:',
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
						value:'�ڿ�����:',
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
						value:'��һ����:',
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
						value:'ͨ������:',
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
						text: '��ѯ',
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
					text : '���',
					iconCls : 'add',
					handler : function() {
						 AddPaperfun();
				   }
  });
   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '�޸�',
					iconCls : 'add',
					handler : function() {
						 EditPaperfun()
				   }
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	      text : 'ɾ��',
					iconCls : 'add',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			alert(state);
			if(state == "0" ){ 
				delFun();}
			else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
  });
  
  var SubmitButton = new Ext.Toolbar.Button({
   	      text : '�ύ',
					iconCls : 'option',
					handler : function() {
						 SubmitPaperfun()
				   }
  });	
  	
var itemGrid = new dhc.herp.Grid({
		    //title: '��������',
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    tbar:[AddButton,UpdateButton,DeleteButton,SubmitButton],
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '�����ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RecordType',
						header : '�����ݿ���¼',
						editable:false,
						width : 80,
						dataIndex : 'RecordType'
					},{
						id : 'Dept',
						header : '����',
						width : 120,
						editable:false,
						dataIndex : 'Dept'

					},{
						id : 'Title',
						header : '������Ŀ',
						editable:false,
						width : 120,
						dataIndex : 'Title'

					}, {
						id : 'JName',
						header : '�ڿ�����',
						editable:false,
						width : 120,
						dataIndex : 'JName'
					}, {
						id : 'FristAuthorName',
						header : '��һ����',
						width : 60,
						editable : false,
						dataIndex : 'FristAuthorName'
						
					},{
						id : 'FAuthorDeptName',
						header : '��һ���߿���',
						width : 120,
						editable:false,
						dataIndex : 'FAuthorDeptName'

					},{
						id : 'TFAuthorName',
						header : '���е�һ����',
						width : 80,
						editable:false,
						dataIndex : 'TFAuthorName'

					},{
						id : 'TFAuthorDept',
						header : '���е�һ���߿���',
						width : 120,
						editable:false,
						dataIndex : 'TFAuthorDept'

					},{
						id : 'IsGraduate',
						header : '��һ�����Ƿ�Ϊ�ڶ��о���',
						width : 70,
						editable:false,
						dataIndex : 'IsGraduate'

					},{
						id : 'Mentor1Name',
						header : '��ʦ1',
						width : 60,
						editable:false,
						dataIndex : 'Mentor1Name'

					},{
						id : 'IsInTwoYear',
						header : '��һ�����Ƿ�Ϊ��ҵ�������о���',
						width : 100,
						editable:false,
						dataIndex : 'IsInTwoYear'

					},{
						id : 'Mentor2Name',
						header : '��ʦ2',
						width : 120,
						editable:false,
						dataIndex : 'Mentor2Name'

					},{
						id : 'CorrAuthorName',
						header : 'ͨѶ����',
						width : 100,
						editable:false,
						dataIndex : 'CorrAuthorName'

					},{
						id : 'CorrAuthorDept',
						header : 'ͨѶ���߿���',
						width : 100,
						editable:false,
						dataIndex : 'CorrAuthorDept'

					},{
						id : 'TCAuthorName',
						header : '����ͨѶ����',
						width : 100,
						editable:false,
						dataIndex : 'TCAuthorName'

					},{
						id : 'TCAuthorDept',
						header : '����ͨѶ���߿���',
						width : 100,
						editable:false,
						dataIndex : 'TCAuthorDept'

					},{
						id : 'SubUserName',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'SubUserName'
					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 100,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '�ύ״̬',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'DataStatus'
					},{
						id : 'ChkResult',
						header : '�������',
						editable:false,
						width : 120,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '����״̬',
						editable:false,
						width : 120,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '�������',
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

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  //itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

