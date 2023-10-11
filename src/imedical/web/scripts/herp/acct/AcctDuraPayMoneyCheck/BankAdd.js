AddBank = function() {

		var rowObj=mainGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERNAME'];
	
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
var BankNoDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
	totalProperty : "results",
	root : 'rows'
	}, ['rowid', 'name'])
	});

    BankNoDs.on('beforeload', function(ds, o) {
     ds.proxy = new Ext.data.HttpProxy({
	url : 'herp.acct.acctPayMoneyCheckMainexe.csp?action=BankList&str='+encodeURIComponent(BankNoComb.getRawValue()),
	method : 'POST'
		});
		});

var BankNoComb = new Ext.form.ComboBox({
			id:'BankNoComb',
			fieldLabel: '银行名称',
			store : BankNoDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			width : 140,
			listWidth : 150,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
        var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			items : [BankNoComb]
		});
	addButton = new Ext.Toolbar.Button({
		text:'确定'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
		addHandler = function(){      			
						
 

		   if(formPanel.form.isValid()){
		      for(var i = 0; i < len; i++){
					var rowid=rowObj[i].get("rowid");
				
					var BankNo=BankNoComb.getValue();
					
					var username   = session['LOGON.USERNAME'];
					    Ext.Ajax.request({
						url:'herp.acct.acctPayMoneyCheckMainexe.csp'+'?action=AddBank&rowid='+rowid+'&BankNo='+BankNo,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0,limit:25,username:username}});
								
								
							}else{
								Ext.Msg.show({title:'错误',msg:'添加失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			title: '添加付款银行',
			width: 255,
			height: 100,
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