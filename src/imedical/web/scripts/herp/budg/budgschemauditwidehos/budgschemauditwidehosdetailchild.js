auditFun = function() {
	
	var UserID = session['LOGON.USERID'];
	

	
	//�������
	var bsarchkresultStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','δͨ��'],['1','ͨ��']]
	});
	var bsarchkresultStoreField = new Ext.form.ComboBox({
		id: 'bsarchkresultStoreField',
		fieldLabel: '�������',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: bsarchkresultStore,
		//anchor: '90%',
		// value:'key', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'ѡ��ģ������...',
		mode: 'local', // ����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});

	
	

	//������� 
	var bsardescField = new Ext.form.TextField({
		id: 'bsardescField',
		fieldLabel: '�������',
		width:215,
		listWidth : 215,
		name: 'bsardescField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		allowBlank : false,
		forceSelection:'true',
		editable:true
	});
   
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			bsarchkresultStoreField,			
			bsardescField			
		]
	});

  var window = new Ext.Window({
  	title: '�������',
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
    	text: 'ȷ�ϴ���',
		handler: function() {

      		var bsarchkresult = bsarchkresultStoreField.getValue();    		
      		var bsardesc = bsardescField.getValue();
      		//alert(bsardesc);
      		if(bsarchkresult=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�����������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(bsardesc=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
	    	
	    	var selectidDetail=itemDetail.getStore().getModifiedRecords();
    	    var len=selectidDetail.length;
    	    if(len>1){
    	    for(i=0;i<len;i++){
    	    	var selectedid = selectidDetail[i].get("rowid");
    	    	var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
    	    	
    	    	var uur3 = BudgSchemAuditWideHosDetailUrl+'?action=submit3&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
    	    	itemDetail.saveurl(uur3);
    	    	}
    	   }
    	   
      		var selectedRow = itemMain.getSelectionModel().getSelections();
      		bsmId=selectedRow[0].data['rowid'];
    	    bsmDr=selectedRow[0].data['bsmcode'];
    	    curstep=selectedRow[0].data['bsachkstep'];
    	    var uur2 = BudgSchemAuditWideHosDetailUrl+'?action=submit2&&SchemDr='+ bsmId+'&bsarchkresult='+bsarchkresult+'&bsardesc='+encodeURI(bsardesc)+'&UserID='+UserID;
    	    itemDetail.saveurl(uur2);
 
    	    window.close();
    	    itemDetail.load({params:{start:0, limit:25,Code:bsmDr}})
    	    itemMain.load(({params:{start:0, limit:25}}));
      		

	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });
  itemDetail.load({params:{start:0, limit:12,Code:bsmDr}});
  window.show();
};