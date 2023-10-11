auditFun = function() {
	
	
//	var rowObj=itemDetail.getSelectionModel().getSelections();
//	//定义并初始化行对象长度变量
//	var  = rowObj.length;
//	
//	var rowid="";
	
	//审批结果
	var bsarchkresultStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','未通过'],['1','通过']]
	});
	var bsarchkresultStoreField = new Ext.form.ComboBox({
		id: 'bsarchkresultStoreField',
		fieldLabel: '审批结果',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: bsarchkresultStore,
		anchor: '90%',
		// value:'key', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'选择模块名称...',
		mode: 'local', // 本地模式
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});

	
	//判断是否选择了要修改的数据
//	if(len < 1){
//		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//		return;
//	}
//	else{
//		var rowid = rowObj[0].get("rowid");
//		var bidcode = rowObj[0].get("bidcode");
//		var bidyear = rowObj[0].get("bidyear");
//		var bidislast = rowObj[0].get("bidislast");
//	}	

	//审批意见 
	var bsardescField = new Ext.form.TextField({
		id: 'bsardescField',
		fieldLabel: '审批意见',
		width:215,
		listWidth : 215,
		name: 'bsardescField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
   


	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			bsarchkresultStoreField,
			
			bsardescField
			
			
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '审批意见',
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
    	text: '确认处理',
		handler: function() {
      		// check form value
      		var bsarchkresult = bsarchkresultStoreField.getValue();
      		
      		var bsardesc = bsardescField.getValue();
      		
      		

      		if(bsarchkresult=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'审批结果不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
      		var selectedRow = itemMain.getSelectionModel().getSelections();
    	    bsmDr=selectedRow[0].data['bsmcode'];
    	    curstep=selectedRow[0].data['bsachkstep'];
    	    var uur1 = BudgSchemAuditWideHosDetailUrl+'?action=submit1&&SchemDr='+ bsmDr+'&bsarchkresult='+bsarchkresult+'&bsardesc='+bsardesc;
    	    itemDetail.saveurl(uur1);
    	    var uur2 = BudgSchemAuditWideHosDetailUrl+'?action=submit2&&SchemDr='+ bsmDr+'&bsarchkresult='+bsarchkresult;
    	    itemDetail.saveurl(uur2);
    	
    	    var selectidDetail=itemDetail.getStore().getModifiedRecords();
    	    for(i=0;i<selectidDetail.length;i++){
    	    	var selectedid = selectidDetail[i].get("rowid");
    	    	var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
    	    	
    	    	var uur3 = BudgSchemAuditWideHosDetailUrl+'?action=submit3&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
    	    	itemDetail.saveurl(uur3);
    	    	//alert(selectedRec);
    	    }
    	   
    	    window.close();
    	    itemDetail.load({params:{start:0, limit:25,Code:bsmDr}})
    	    itemMain.load(({params:{start:0, limit:25}}));
      		
      					
//			if (formPanel.form.isValid()) {
//    		for(var i = 0; i < ; i++){
      		        
      			
      					
//						Ext.Ajax.request({
//							url: BudgSchemAuditWideHosDetailUrl+'?action=edit&&rowid='+rowObj[i].get("rowid")+'&bidcode='+rowObj[i].get("bidcode")+'&bidyear='+rowObj[i].get("bidyear")+'&bidislast='+rowObj[i].get("bidislast")+'&bssmsplitmeth='+bssmsplitmeth,
//							failure: function(result, request) {
//								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//							},
//							success: function(result, request) {
//								var jsonData = Ext.util.JSON.decode( result.responseText );
//						  	if (jsonData.success=='true') {
//						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
//						  		//itemGrid.load({params:{start:0, limit:25}});
//									window.close();
//								}
//						  	else{
//						  		window.close();
//						  	}
//							},
//					  	scope: this
//						});
////      		}

	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });
  //itemMain.load({params:{start:0, limit:12}});
  itemDetail.load({params:{start:0, limit:12,Code:bsmDr}});
    window.show();
};