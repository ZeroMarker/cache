editFun = function() {
	
	
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	
	var rowid="";
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���޸ĵĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var bidcode = rowObj[0].get("bidcode");
		var bidyear = rowObj[0].get("bidyear");
		var bidislast = rowObj[0].get("bidislast");
	}	


    var bssmsplitmethStore1 = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['2','��ʷ����*���ڱ���'],['3','����ϵ��']]  
	});
	
	var bssmsplitmethStore1Field = new Ext.form.ComboBox({
		id: 'bssmsplitmethStore1Field',
		fieldLabel: '�ֽⷽ��',
		allowBlank: false,
		emptyText: '�ֽⷽ��...',
		store: bssmsplitmethStore1,
		valueNotFoundText:'',
	    displayField: 'keyValue',
	    valueField: 'key',
	    triggerAction: 'all',
	    //emptyText:'ѡ��ģ������...',
	    mode: 'local', //����ģʽ
	    editable:false,
	    pageSize: 10,
	    minChars: 1,
	    selectOnFocus:true,
	    forceSelection:true,
		anchor: '90%'
	});


	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			bssmsplitmethStore1Field
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ķֽⷽ��',
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
      		var bssmsplitmeth = bssmsplitmethStore1Field.getValue();
		
			
      		//bssmsplitmeth = bssmsplitmeth.trim();

      		if(bssmsplitmeth=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ֽⷽ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
      					
        	//var data = bssmsplitmeth;
//			if (formPanel.form.isValid()) {
      		for(var i = 0; i < len; i++){
      		        
      			
      					
						Ext.Ajax.request({
							url: BudgSchemSplitYearMonthUrl+'?action=edit&&rowid='+rowObj[i].get("rowid")+'&bidcode='+rowObj[i].get("bidcode")+'&bidyear='+rowObj[i].get("bidyear")+'&bidislast='+rowObj[i].get("bidislast")+'&bssmsplitmeth='+bssmsplitmeth,
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
						  		window.close();
						  	}
							},
					  	scope: this
						});
      		}

	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });

    window.show();
};