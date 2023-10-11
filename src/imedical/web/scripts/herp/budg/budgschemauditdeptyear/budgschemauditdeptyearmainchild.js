auditFun = function() {
	
	var UserID = session['LOGON.USERID'];
	var rowObj=itemMain.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	
	//alert(len);
	
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var bsaeditdeptdr = rowObj[0].get("bsaeditdeptdr");
	}	
	
	

	
	//审批结果
	var bsarchkresultStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','未通过'],['1','通过']]
	});
	var bsarchkresultStoreField = new Ext.form.ComboBox({
		id: 'bsarchkresultStoreField',
		fieldLabel: '审批结果',
		width:120,
		//listWidth : 245,
		selectOnFocus: true,
		allowBlank: false,
		store: bsarchkresultStore,
		anchor: '90%',
		value:1, //默认值
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

	
	

	//审批意见 
	var bsardescField = new Ext.form.TextField({
		id: 'bsardescField',
		fieldLabel: '审批意见',
		width:215,
		anchor: '90%',
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
      		///alert(bsardesc)
      		var BSMName = BSMnameField.getValue();
      		var Year = yearField.getValue();
      		if(bsarchkresult=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'审批结果不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
      		var selectedRow = itemMain.getSelectionModel().getSelections();
			var len = selectedRow.length;
			var dataid="";
    	    if(len < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要审核的科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
    	    else{
	    	    bsmId=selectedRow[0].data['rowid'];
    	    	bsmDr=selectedRow[0].data['bsmcode'];
    	    	curstep=selectedRow[0].data['bsachkstep'];
				for(var i = 0; i < len; i++)
			 	{
				 	var auditdr = rowObj[i].get("auditdr");
				 	if(dataid==""){var dataid=auditdr}
				 	else{var dataid=dataid+"^"+auditdr;}
			 	}
    	    var uur1 = BudgSchemAuditDeptYearUrl+'?action=submit1&&SchemDr='+ bsmId+'&bsarchkresult='+bsarchkresult+'&bsardesc='+bsardesc+'&UserID='+UserID+'&auditdr='+dataid;
    	    //itemDetail.saveurl(uur1);
    	    
    	    Ext.Ajax.request({
			url: uur1,
			waitMsg:'保存中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
				}
				else{
					if(jsonData.info=='RepName'){
						Ext.Msg.show({title:'错误',msg:'条件不符合!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
					}
				}
			itemMain.load(({params:{start:0, limit:25,BSMName:BSMName,Year:Year}}));	
			},
			scope: this
		});	    
    	    }	   
    	    window.close();
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};