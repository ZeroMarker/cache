EditFun = function() {
		
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���޸ĵĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var isLast=rowObj[0].get("isLast");
	}	

//////////////////////�ֽⷽ��////////////////////['1', '��ʷ����'], ///////////
var SplitMethStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['2', '��ʷ����*���ڱ���'], ['3', '����ϵ��']]
		});
var SplitMethField = new Ext.form.ComboBox({
			id : 'SplitMethField',
			fieldLabel : '�ֽⷽ������',
			emptyText: 'ѡ��ֽⷽ��',
			width : 200,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : false,
			store : SplitMethStore,
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

	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			SplitMethField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�ֽⷽ������',
    width: 355,
    height:200,
    minWidth: 200,
    minHeight: 200,
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
      		var SplitMeth = SplitMethField.getValue();
      		SplitMeth = SplitMeth.trim();
      		
      		/*if(SplitMeth=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ֽⷽ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};*/
      		for(var i = 0; i < len; i++){
						Ext.Ajax.request({
							url: 'herp.budg.budgschsplitaccdeptexe.csp?action=SplitEdit&&rowid='+rowObj[i].get("rowid")+'&year='+rowObj[i].get("year")+'&isLast='+rowObj[i].get("isLast")+'&code='+rowObj[i].get("code")+'&SplitMeth='+SplitMeth,
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
								else
						{
								/*var message = "";
								message = "SQLErr: " + jsonData.info;
								
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});*/
								  window.close();
								}
							},
					  	scope: this
						});
      		}
        	}
//       	else{
//						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//					}
//	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });

    window.show();
};