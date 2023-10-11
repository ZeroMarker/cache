editFun=function(rowid,CompDR,Year, AdjustNo, AdjustDate, AdjustFile,Memo,IsApprove, IsElast,ElastMonth)
{
	var yearField = new Ext.form.TextField({
			id: 'yearField',
			fieldLabel: '������',
			allowBlank: false,
			value:Year,
			emptyText: '������...',
			anchor: '90%'
		});
	var adjustNoField = new Ext.form.TextField({
		id: 'adjustNoField',
		fieldLabel: '�������',
		value:AdjustNo,
		allowBlank: false,
		emptyText: '�������...',
		anchor: '90%'
	});
	var adjustDateField = new Ext.form.DateField({
		id:'adjustDateField',
		fieldLabel: '��������',
		value:AdjustDate,
		width:120,
		allowBlank:true,
		format:'Y-m-d',
		selectOnFocus:'true'
	});
	var adjustFileField = new Ext.form.TextField({
		id: 'adjustFileField',
		fieldLabel: '�����ĺ�',
		value:AdjustFile,
		allowBlank: false,
		emptyText: '�����ĺ�...',
		anchor: '90%'
	});	
	var memoField = new Ext.form.TextField({
		id: 'memoField',
		fieldLabel: '����˵��',
		value:Memo,
		allowBlank: false,
		emptyText: '����˵��...',
		anchor: '90%'
	});
	// create form panel
  	var formPanel = new Ext.form.FormPanel({
  		baseCls: 'x-plain',
    	labelWidth: 80,
    	items: [
    		yearField,
			adjustNoField,
    		adjustDateField,
    		adjustFileField,
    		memoField
      		]
	});
  	// define window and show it in desktop
  	var window = new Ext.Window({
  		title: '�޸�Ԥ�����',
    	width: 400,
    	height:300,
    	minWidth: 400,
    	minHeight: 300,
    	layout: 'fit',
    	plain:true,
    	modal:true,
    	bodyStyle:'padding:5px;',
    	buttonAlign:'center',
    	items: formPanel,
    	buttons: [{
    		text: '����',
			handler: function() {
    			// check form value
    			var newYear = yearField.getValue();
    			var newAdjustNo = adjustNoField.getValue();
    			var newAdjustDate = adjustDateField.getRawValue();
				var newAdjustFile = adjustFileField.getValue();
				var newMemo = encodeURIComponent(memoField.getValue());
				//alert(adjustDate);		
    			newAdjustNo = newAdjustNo.trim();
    			//adjustDate = adjustDate.trim();
				newAdjustFile = newAdjustFile.trim();
				newMemo = newMemo.trim();
				if(newYear=="")
    			{
    				Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
				if(newAdjustNo=="")
    			{
    				Ext.Msg.show({title:'����',msg:'�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
    			if(newAdjustFile=="")
    			{
    				Ext.Msg.show({title:'����',msg:'�����ĺ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
    			if(newMemo=="")
    			{
    				Ext.Msg.show({title:'����',msg:'����˵��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
      			//var data = adjustNo+'^'+adjustDate+'^'+adjustFile+'^'+meno;
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: adjustUrl+'?action=edit&rowid='+rowid+'&Year='+newYear+'&AdjustNo='+AdjustNo+'&newAdjustNo='+newAdjustNo+'&AdjustFile='+newAdjustFile+'&Memo='+newMemo+'&IsApprove='+IsApprove+'&IsElast='+IsElast+'&ElastMonth='+ElastMonth,
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
					  		if (jsonData.success=='true') {
					  			Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25}});
								window.close();
							}
							else{
								var message = "";
								message = "SQLErr: " + jsonData.info;
								if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
								if(jsonData.info=='RepName') message='����ĵ�������Ѿ�����!';
								else  message='�޸�ʧ��!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						}//,scope: this
					});
       			}
       			else{
					Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
	   		}
    	},{
			text: 'ȡ��',
       		handler: function(){window.close();}
    	}]
    });
    window.show();
};	