var UserId = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var bookID= IsExistAcctBook();

var projUrl="herp.acct.acctunentrycompexe.csp"
//��ʼ����
var SaveAmtBal  = new Ext.Toolbar.Button({
		text: '����',  
        iconCls:'save',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		var SubName=deptCombo.getValue();
		if(SubName=="")
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ�����п�Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;			
		}
        var amtbal=amtbalField.getValue();
		if(amtbal==""||amtbal==0)
		{	
			Ext.Msg.show({title:'ע��',msg:'����д���! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;		
		}
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
					url:projUrl+'?action=saveamtbal&amtbal='+amtbal+'&SubName='+SubName+'&bookID='+bookID,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,UserId:UserId}});							
						}else{
							Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�������������?',handler);
    }
});	


//ɾ����ť
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : 'ɾ��',
			iconCls : 'remove',
            handler :function( ) {
				itemGrid.del();				
            }
});

//���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
    text: '����',
    tooltip:'����',        //��ͣ��ʾ
    iconCls: 'add',
    handler:function(){	
		itemGrid.add();  
	}   
});

//���水ť
var saveButton = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'�������',
	iconCls: 'save',
	handler:function(){
		//���ñ��溯��
		itemGrid.save();
		//alert("11");
		}
	});
	
	
// ������ʼʱ��ؼ�
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		fieldLabel:'��ʼ����',
		width : 120,
		editable:true,
		emptyText : '��ѡ��ʼ����...'
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		fieldLabel:'��������',
		width : 120,
		editable:true,
		emptyText : '��ѡ���������...'
	});
//gridʱ����ʾ	
/* 	var dateField = new Ext.form.DateField({
		id : 'dateField',
		//format : 'Y-m-d',
		fieldLabel:'ҵ��ʱ��',
		width : 120,
		editable:true
	}); */	
 ///���п�Ŀ
var bankDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['subjCode','subjName', 'subjCodeName'])
		});

bankDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetCashSubj&bookID='+bookID,method:'POST'
					});
		});
var bankCombo = new Ext.form.ComboBox({
			fieldLabel : '���п�Ŀ',
			store : bankDs,
			displayField : 'subjName',
			valueField : 'subjCode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '��Ŀ�ֵ���ĩ�����п�Ŀ',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			//allowBlank: false,
			selectOnFocus : true
		});
//ĩ�����п�Ŀ
var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '���п�Ŀ',
			store : bankDs,
			displayField : 'subjCodeName',
			valueField : 'subjCode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��Ŀ�ֵ���ĩ�����п�Ŀ',
			width : 220,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners: {
               select: function(){ 
			         var SubName=Ext.getCmp('deptCombo').getValue();
					 Ext.Ajax.request({
						url : projUrl+'?action=GetAmtBal&bookID='+bookID+'&SubName='+SubName,
						failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
							    var resultstr = result.responseText;
								amtbalField.setValue(resultstr);								
								},
										scope : this
							});		
			         
			   }
            }
		});		
//���㷽ʽ

var typeDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
typeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

						url : projUrl+'?action=GetSysChequeType',method:'POST'
					});
		});
var CheqTypeNameCombo = new Ext.form.ComboBox({
			fieldLabel : '���㷽ʽ',
			store : typeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 80,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			editable:true,
			selectOnFocus : true
	});
		

		//��ʼ���
var amtbalField = new Ext.form.TextField({
    id: 'amtbal',
    width:140,
    //triggerAction: 'all',
    fieldLabel: '��ʼ���', 
    style:'text-align:right', 		
    name: 'amtbal' ,
	//type:'numberField',
    //editable:true,
	selectOnFocus : true
});

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip:'��ѯ', 
		iconCls: 'find',	       //����ť��ͼ��
		width:55,
		handler:function(){	
			//��ѯ����List()��JS�ļ�
					var startdate= PSField.getValue();
					if(startdate!==""){
						startdate=startdate.format('Y-m-d');
					}
					var enddate = PEField.getValue();
					if(enddate!==""){
						enddate=enddate.format('Y-m-d');
					}
					var dept  = deptCombo.getValue();
					itemGrid.load({
						 params:{						 
						        //start : 0,
								//limit : 25,
								StartDate:startdate,
		    					EndDate:enddate,
		    					SubName:dept,
								bookID:bookID
								}
					});
		}
});

  	
	var queryPanel = new Ext.FormPanel({
	    title:'��λδ����ά��',
		iconCls:'maintain',
		region: 'north',
		height: 73,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��ʼʱ��',
						style: 'padding:0 5px;'
						//width: 70
					}, PSField, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '����ʱ��',
						style: 'padding:0 5px;'
						//width: 70
					}, PEField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '���п�Ŀ',
						style: 'padding:0 5px;'
						//width: 70
					}, deptCombo, {
						xtype: 'displayfield',
						value: '',
						width: 15
					},
					findButton,{
						xtype: 'displayfield',
						value: '',
						width: 15
					},{
						xtype: 'displayfield',
						value: '��ʼ���',
						style: 'padding:0 5px;'
						//width: 70
					},amtbalField,{
						xtype: 'displayfield',
						value: '',
						width: 15
					},SaveAmtBal
				]
			}]

	});

var itemGrid = new dhc.herp.Grid({
		    //title: '��λδ���˲�ѯ�б�',
			//iconCls:'list',
		    region : 'center',
		    url: projUrl,
		    //atLoad : true, // �Ƿ��Զ�ˢ��
		    tbar:[addButton,'-',delButton,'-',saveButton],
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '�����ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">���п�Ŀ</div>',
						width : 150,
						allowBlank: false,
						type:bankCombo,
						dataIndex : 'AcctSubjName'
					},{
						id : 'OccurDate',
						header: '<div style="text-align:center">ҵ��ʱ��</div>',
						width : 100,
						allowBlank: true,						
						align: 'center',
						dataIndex : 'OccurDate',
						type: 'dateField'
					},{
						id : 'CheqTypeName',
						header: '<div style="text-align:center">���㷽ʽ</div>',
						width : 90,
						type:CheqTypeNameCombo,
						align: 'center',
						allowBlank: true,
						dataIndex : 'CheqTypeName'
					},{
						id : 'CheqNo',
						header: '<div style="text-align:center">Ʊ�ݺ�</div>',
						width : 180,
						allowBlank: true,
						dataIndex : 'CheqNo'
					}, {
						id : 'summary',
						header: '<div style="text-align:center">ժҪ</div>',
						width : 300,
						allowBlank: true,
						dataIndex : 'summary'
					}, {
						id : 'AmtDebit',
						header: '<div style="text-align:center">�跽���</div>',
						width : 150,
						align: 'right',
						type:'numberField',
						allowBlank: false,
						dataIndex : 'AmtDebit'
					},{
						id : 'AmtCredit',
						header: '<div style="text-align:center">�������</div>',
						width : 150,
						align: 'right',
						allowBlank: false,
						type:'numberField',
						dataIndex : 'AmtCredit'
					}]					
		});
		itemGrid.load({params:{start:0, limit:12,bookID:bookID}});

//-----------InitBankFlag==1ʱ����ɾ�İ�ť������
itemGrid.store.on('load',function(){
	Ext.Ajax.request({
		url: projUrl+'?action=GetInitBankFlag&bookID=' + bookID,method:'POST',
		success: function (result, request) {
			var respText = Ext.decode(result.responseText);
			var str = respText.info;
			InitBankFlag = str;
			if (InitBankFlag == 1) {			
				addButton.disable();
				delButton.disable();
				saveButton.disable();
				SaveAmtBal.disable();
			}
		}
	});
});  
//��ť��־Ϊ1ʱ�����ɽ����б༭
itemGrid.on('beforeedit',function(editor, e){		
	if (InitBankFlag == 1) {
		return false;
	}
});
 //���������޸�һ������һ����Ϊ0
itemGrid.on('afteredit', afterEdit, this );
function afterEdit(e) {
    if(e.field=="AmtDebit"){
    	if(e.value!=0){e.record.set("AmtCredit",0);}
    }else if(e.field=="AmtCredit"){
    	if(e.value!=0){e.record.set("AmtDebit",0);}
    }     
};



 	itemGrid.btnAddHide()     //�������Ӱ�ť
    itemGrid.btnSaveHide()    //���ر��水ť
    itemGrid.btnDeleteHide()  //����ɾ����ť
    itemGrid.btnResetHide()     //�������ð�ť
    itemGrid.btnPrintHide()     //���ش�ӡ��ť