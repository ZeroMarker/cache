var hospid = session['LOGON.HOSPID'];
editFun=function(rowid,CompDR,CompName,Year, AdjustNo, AdjustDate, AdjustFile,Memo,IsApprove, IsElast,ElastMonth)
{
	//alert(Year+"^"+AdjustNo)
	var adjustURL='herp.budg.budgadjustexe.csp';
	var EditCompDRDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			EditCompDRDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
									url : commonboxURL+'?action=hospital&rowid='+hospid+'',
									method : 'POST'
								});
					});
			var EditCompDRCombo = new Ext.form.ComboBox({
						fieldLabel : '医疗单位',
						store : EditCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText: CompName,   
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});	
	EditCompDRCombo.setValue(CompDR);					
					
	var yearField = new Ext.form.TextField({
			id: 'yearField',
			fieldLabel: '会计年度',
			allowBlank: false,
			value:Year,
			emptyText: '会计年度...',
			anchor: '90%'
		});
	var adjustNoField = new Ext.form.TextField({
		id: 'adjustNoField',
		fieldLabel: '调整序号',
		value:AdjustNo,
		allowBlank: false,
		emptyText: '调整序号...',
		anchor: '90%'
	});
	var adjustDateField = new Ext.form.DateField({
		id:'adjustDateField',
		fieldLabel: '调整日期',
		value:AdjustDate,
		width:120,
		allowBlank:true,
		format:'Y-m-d',
		selectOnFocus:'true'
	});
	var adjustFileField = new Ext.form.TextField({
		id: 'adjustFileField',
		fieldLabel: '调整文号',
		value:AdjustFile,
		allowBlank: false,
		emptyText: '调整文号...',
		anchor: '90%'
	});	
	var memoField = new Ext.form.TextField({
		id: 'memoField',
		fieldLabel: '调整说明',
		value:Memo,
		allowBlank: false,
		emptyText: '调整说明...',
		anchor: '90%'
	});
	// create form panel
  	var formPanel = new Ext.form.FormPanel({
  		baseCls: 'x-plain',
    	labelWidth: 80,
    	items: [
    		EditCompDRCombo,
    		yearField,
			adjustNoField,
    		adjustDateField,
    		adjustFileField,
    		memoField
      		]
	});
  	// define window and show it in desktop
  	var window = new Ext.Window({
  		title: '修改预算调整',
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
    		text: '保存',
			handler: function() {
    			// check form value
    			var newCompDR = EditCompDRCombo.getValue();
    			//alert(newCompDR)
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
				if(newCompDR=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'医疗单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
				if(newYear=="")
    			{
    				Ext.Msg.show({title:'错误',msg:'会计年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
				if(newAdjustNo=="")
    			{
    				Ext.Msg.show({title:'错误',msg:'调整序号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
    			if(newAdjustFile=="")
    			{
    				Ext.Msg.show({title:'错误',msg:'调整文号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
    			if(newMemo=="")
    			{
    				Ext.Msg.show({title:'错误',msg:'调整说明为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    				return;
    			};
      			//var data = adjustNo+'^'+adjustDate+'^'+adjustFile+'^'+meno;
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: adjustURL+'?action=edit&rowid='+rowid+'&CompDR='+newCompDR+'&Year='+newYear+'&AdjustNo='+AdjustNo+'&newAdjustNo='+newAdjustNo+'&AdjustFile='+newAdjustFile+'&Memo='+newMemo+'&IsApprove='+IsApprove+'&IsElast='+IsElast+'&ElastMonth='+ElastMonth,
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
					  		if (jsonData.success=='true') {
					  			Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25}});
								window.close();
							}
							else{
								var message = "";
								message = "SQLErr: " + jsonData.info;
								if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
								if(jsonData.info=='RepName') message='输入的调整序号已经存在!';
								else  message='修改失败!';
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						}//,scope: this
					});
       			}
       			else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
	   		}
    	},{
			text: '取消',
       		handler: function(){window.close();}
    	}]
    });
    window.show();
};	