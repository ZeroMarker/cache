noauditfun = function() {
        ///alert(33333333);
		var projUrl = 'herp.srm.projectmidchecknewdetailauditexe.csp';
		var checker =session['LOGON.USERCODE'];
		var rowObj=DetailGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
       /////////// ���ı���
	    var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
				height : 120,
				anchor: '100%',
				fieldLabel : '�������',
				allowBlank :false,
				selectOnFocus:'true',
				labelSeparator:''
				//emptyText : '����д�����������'
			});

	// ����˵�����ı���
	  var viewFieldSet = new Ext.form.FieldSet({
				title : '�������',
				height : 180,
				labelSeparator : '��',
				items : textArea
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
							textArea
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
		text:'����',iconCls: 'save'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
		addHandler = function(){      			
						

		   var view= encodeURIComponent(Ext.getCmp('textArea').getRawValue()) 

		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:projUrl+'?action=noaudit'+'&RowID='+rowObj[i].get("RowID")+'&view='+view+'&checker='+checker,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
							    DetailGrid.load({params:{start:0, limit:12}});		
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
	////// ���Ӽ����¼� ////////////////	
		addButton.addListener('click',addHandler,false);

		cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',iconCls : 'cancel'
		});
		
		cancelHandler = function(){
			addwin.close();
		}
		
		cancelButton.addListener('click',cancelHandler,false);

		addwin = new Ext.Window({
			title: '�������',
			iconCls : 'updateinfo',
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

