noauditfun = function() {

		var projUrl = 'herp.acct.acctPayMoneyCheckMainexe.csp';
		var userdr   = session['LOGON.USERNAME'];	
		var rowObj=mainGrid.getSelectionModel().getSelections();
		var checker = session['LOGON.USERNAME'];
		var CheckResult=rowObj[0].get("CheckResult");
		var IsCheck=rowObj[0].get("IsCheck");
         if(CheckResult!="未审核")
		{
			Ext.Msg.show({title:'注意',msg:'数据已审核，不能再次审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }
	    if(IsCheck==2){
			        Ext.Msg.show({title:'注意',msg:'数据已终审，不能再审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			        return;
		            }  
		//定义并初始化行对象长度变量
		var len = rowObj.length;
/////////// 多文本域
	   var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
				height : 120,
				anchor: '100%',
				fieldLabel : '审批意见',
				allowBlank :false,
				selectOnFocus:'true',
				emptyText : '请填写审批意见……'
			});

	// 导入说明多文本域
	  var viewFieldSet = new Ext.form.FieldSet({
				title : '审批意见',
				height : 180,
				labelSeparator : '：',
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
		text:'确定'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
		addHandler = function(){      			
						

		   var CheckDesc= encodeURIComponent(Ext.getCmp('textArea').getRawValue()) 

		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			  	    var PayMoneyMainID=rowObj[i].get("rowid");
					var PayBillNo=rowObj[i].get("PayBillNo");
					var CheckNo=rowObj[i].get("CheckNo");
					var username   = session['LOGON.USERNAME']; 
					var IsCheck=rowObj[i].get("IsCheck");
					var CheckResult=rowObj[i].get("CheckResult");
					
					if(CheckResult!="未审核")
				    continue;
		            if(IsCheck==2)
		            continue;
			    Ext.Ajax.request({
					url:projUrl+'?action=notthrough&PayMoneyMainID='+PayMoneyMainID+'&PayBillNo='+PayBillNo+'&CheckNo='+CheckNo+'&CheckDesc='+CheckDesc+'&username='+encodeURIComponent(username),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'操作成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
								mainGrid.load({params:{start:0, limit:12,username:username}});
								if(IsLastCheck=="0")
								{
									LogMain.getStore().removeAll();
							    }
							    if (IsLastCheck=="1")
							    {
								    LogMain.load({params:{start:0,limit:25,rowid:PayMoneyMainID}});
								}
									
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'操作失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else{
				Ext.Msg.show({title:'错误',msg:'请填写不通过理由!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
			addwin.close();
   }
	////// 添加监听事件 ////////////////	
		addButton.addListener('click',addHandler,false);

		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
		
		cancelHandler = function(){
			addwin.close();
		}
		
		cancelButton.addListener('click',cancelHandler,false);

		addwin = new Ext.Window({
			title: '审批意见',
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