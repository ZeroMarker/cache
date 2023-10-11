/*-------˵��-------------
���ߣ�������
���ڣ�2016-1-7
���ܣ������ƺ���δ��¼����
-------------------------*/
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];

//�жϵ�ǰ�����Ƿ����
function IsExistAcctBook(){
 //��û�ƺ�������  zhaoliguo 2016-1-7
// var frm = dhcsys_getmenuform(); //�÷�����websys.js��
 var frm = dhcsys_getsidemenuform(); //���ò�˵�
 var currBookID= frm.AcctBookID.value;
 if(currBookID==""){
	 InitAcctBook();
 }
return currBookID;
}

//��õ�ǰ����ID,����¼ʱ��������¼����
function GetAcctBookID(){

 var frm = dhcsys_getmenuform(); //�÷�����websys.js��
 return frm.AcctBookID.value;


}
//��ʼ��ʱ��ӻ�ƺ�������
function InitAcctBook(){
 setTimeout("AddAcctBook()",3500); 
}

//��ӻ�ƺ�������
function AddAcctBook(){

		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '�û�����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			//valueNotFoundText:userName,
			//emptyText:userName,
			anchor: '90%',
			selectOnFocus:'false',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'����',msg:'�û�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '��������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		
		// ----------��������------------------------------

		var acctbookDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		acctbookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.acct.acctbookidexe.csp?action=getAcctBook&start=0&limit=25',
				method : 'POST'
			})
		});

		var acctbookField = new Ext.form.ComboBox({
					id : 'acctbookField',
					fieldLabel : '�������',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : acctbookDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'acctbookField',
					minChars : 1,
					pageSize : 10,
					anchor: '90%',
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});


		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 60,
			items: [
				cField,
				acctbookField
			]
		});
	
			//������ zlg1
	
		formPanel.on('afterlayout', function(panel, layout){

			cField.setValue(userCode);
			//n1Field.setValue(rowObj[0].get("name"));	
		});
		
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
					
			var code = cField.getValue();
			var bookid = acctbookField.getValue();
			var bookName = acctbookField.getRawValue();
			
			if(code==""){
				Ext.Msg.show({title:'����',msg:'�û�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(bookid==""){
				Ext.Msg.show({title:'����',msg:'���ײ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			//��ӻ�ƺ�������ȫ�ֱ��� zhaoliguo 2016-1-7
			//var frm = dhcsys_getmenuform();
			//frm.AcctBookID=bookid
			var frm =dhcsys_getsidemenuform(); 
			frm.AcctBookID.value=bookid
			frm.AcctBookName.value=bookName
			
			//encodeURI zlg4
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctbookidexe.csp?action=add&useid='+code+'&bookid='+bookid),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){nField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){nField.focus();}
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						//TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
						addwin.close();
					}
					else
							{
								var message="";
								if(jsonData.info=='RepCode') message='����ı����Ѿ�����!';
								if(jsonData.info=='RepName') message='����������Ѿ�����!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			location.reload(true);
		}
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '�������',
			width: 300,
			height:160,
			minWidth: 290, 
			minHeight: 150,
			closable:false,  //�����Ͻ���ʾС���Ĺرհ�ť��Ĭ��Ϊtrue
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:3px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton
			]
		});
	
		//������ʾ
		addwin.show();
		 //var frm = dhcsys_getsidemenuform(); //���ò�˵�
		 //return frm.AcctBookID;
 
	}


	
//��ӻ�ƺ�������
function GetAcctBookInfo(){


			   //var rowObj = scheme1Main.getSelections();
				var total = 0
				var rowid = 0
				//alert(33)
				var rtndata =""
				Ext.Ajax.request({
							url : '../csp/herp.acct.acctbookidexe.csp?action=getBookID',
							// method: "GET",
							async: false,   //ASYNC �Ƿ��첽( TRUE �첽 , FALSE ͬ��)
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								//alert(jsonData.success );
								if (jsonData.success == 'true') {
									/*
									Ext.Msg.show({
												title : '��ʾ',
												msg : '��֤�ɹ�!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									*/
											
										alert("dddd="+jsonData.info)
										rtndata= jsonData.info;
								
								} else {
									Ext.Msg.show({
												title : '����',
												msg : jsonData.info,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						});
						
	return "last="+rtndata;
			
}
	
		
 
	
