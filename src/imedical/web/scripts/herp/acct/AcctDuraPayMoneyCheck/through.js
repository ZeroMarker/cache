throughfun = function() {

		var rowObj=mainGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERNAME'];
		var CheckResult=rowObj[0].get("CheckResult");
		alert(CheckResult);
		if(CheckResult!="δ���")
		{
			Ext.Msg.show({title:'ע��',msg:'��������ˣ������ٴ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
       
/////////// ���ı���
	   var textArea2 = new Ext.form.TextArea({
				id : 'textArea2',
				width : 500,
				height : 120,
				anchor: '100%',
				fieldLabel : '�������',
				allowBlank :false,
				selectOnFocus:'true',
				emptyText : '����д�����������'
			});

	// ����˵�����ı���
	  var viewFieldSet = new Ext.form.FieldSet({
				title : '�������',
				height : 180,
				labelSeparator : '��',
				items : textArea2
			});
			
	 var colItems =	[
			   {
				layout: 'column',
				border: false,
				defaults: {
					columnWidth: '1.0',
					bodyStyle:'padding:5px 5px 0',
					border: false
				},            
				items: [
					{
						xtype: 'fieldset',
						autoHeight: true,
						items: [																
							viewFieldSet
						]
					}]
			 }
	 ]			
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 80,
		frame: true,
		items: colItems
	});
	
	addButton = new Ext.Toolbar.Button({
		text:'ȷ��'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
		addHandler = function(){      			
						

		   var CheckDesc= encodeURIComponent(Ext.getCmp('textArea2').getRawValue()) 

		   if(formPanel.form.isValid()){
		      for(var i = 0; i < len; i++){
					var PayMoneyMainID=rowObj[i].get("rowid");
					var PayBillNo=rowObj[i].get("PayBillNo");
					var NextCheckNo=rowObj[i].get("NextCheckNo");
					var CheckNo=rowObj[i].get("CheckNo");
					var CheckResult=rowObj[i].get("CheckResult");
					if(CheckResul!="δ���")
				    continue;
					
					var CheckDesc=textArea2.getValue();
					
					var username   = session['LOGON.USERNAME'];
					var IsCheck=rowObj[i].get("IsCheck");
					var IsLastCheck=rowObj[i].get("IsLastCheck");
					if(IsCheck==2){
			        Ext.Msg.show({title:'ע��',msg:'���������󣬲��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			        return;
		            }
					
					    Ext.Ajax.request({
						url:'herp.acct.acctPayMoneyCheckMainexe.csp'+'?action=through&PayMoneyMainID='+PayMoneyMainID+'&PayBillNo='+PayBillNo+'&CheckNo='+CheckNo+'&CheckDesc='+encodeURIComponent(CheckDesc)+'&username='+encodeURIComponent(username),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0,limit:25,username:username}});
								if(IsLastCheck=="0")
								{
									LogMain.getStore().removeAll();
							    }
							    if (IsLastCheck=="1")
							    {
								    LogMain.load({params:{start:0,limit:25,rowid:PayMoneyMainID}});
								}
								
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
	   }
	   else{
				Ext.Msg.show({title:'����',msg:'����д��ͨ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			title: '�������',
			width: 400,
			height: 300,
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