EditRateFun = function(budgDetailGrid) {

var rowObj=budgDetailGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���޸ĵĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var isAlComp=rowObj[0].get("isAlComp");
		
	}	


/////////////////�������/////////////////////////////////
var BudgetRate = new Ext.form.TextField({
		id: 'BudgetRate',
		fieldLabel: '�������',
		allowBlank: true,
		emptyText:'����д���ڱ���...',
		width:180
	});
	
/////////////////////////�Ƿ��������////////////////////////////			
var isAlCompStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var isAlCompbox = new Ext.form.ComboBox({
			id : 'isAlCompbox',
			fieldLabel : '�Ƿ��������',
			width : 180,
			allowBlank : false,
			store : isAlCompStore,
			//anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : 'ѡ���ǻ��߷�',
			mode : 'local', // ����ģʽ
			editable : true,
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
			BudgetRate,
			isAlCompbox
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '���ڱ�������',
    width: 320,
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
      		
      		var Rate = BudgetRate.getValue();
      		//alert(Rate)
      		Rate = Rate.trim();
      		var isAlComp = isAlCompbox.getValue();
      		//alert(isAlComp)
      		isAlComp = isAlComp.trim();
      		if(Rate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���ڱ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		for(var i = 0; i < len; i++){
						Ext.Ajax.request({
							url: 'herp.budg.budgschsplitaccdeptdetailexe.csp?action=RateEdit&&rowid='+rowObj[i].get("rowid")+'&Rate='+Rate+'&isAlComp='+isAlComp,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});		
								budgDetailGrid.load({params:{start:0, limit:25}});
								window.close();
								}
//								else
//								{
//									var message = "";
//									message = "SQLErr: " + jsonData.info;
//									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
//									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
//									if(jsonData.info=='RepName') message='����������Ѿ�����!';
//								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//								}
							},
					  	scope: this
						});
      		}
		    window.close();
        	//}
//        	else{
//						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//					}
	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });

    window.show();
};