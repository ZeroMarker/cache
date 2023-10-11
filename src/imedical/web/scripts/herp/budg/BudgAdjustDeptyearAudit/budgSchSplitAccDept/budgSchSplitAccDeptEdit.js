EditFun = function() {
		
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var isLast=rowObj[0].get("isLast");
	}	

//////////////////////分解方法////////////////////['1', '历史数据'], ///////////
var SplitMethStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['2', '历史数据*调节比例'], ['3', '比例系数']]
		});
var SplitMethField = new Ext.form.ComboBox({
			id : 'SplitMethField',
			fieldLabel : '分解方法设置',
			emptyText: '选择分解方法',
			width : 200,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : false,
			store : SplitMethStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
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
  	title: '分解方法设置',
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
    	text: '保存',
		handler: function() {
      		// check form value
      		var SplitMeth = SplitMethField.getValue();
      		SplitMeth = SplitMeth.trim();
      		
      		/*if(SplitMeth=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'分解方法为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};*/
      		for(var i = 0; i < len; i++){
						Ext.Ajax.request({
							url: 'herp.budg.budgschsplitaccdeptexe.csp?action=SplitEdit&&rowid='+rowObj[i].get("rowid")+'&year='+rowObj[i].get("year")+'&isLast='+rowObj[i].get("isLast")+'&code='+rowObj[i].get("code")+'&SplitMeth='+SplitMeth,
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
								else
						{
								/*var message = "";
								message = "SQLErr: " + jsonData.info;
								
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});*/
								  window.close();
								}
							},
					  	scope: this
						});
      		}
        	}
//       	else{
//						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//					}
//	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};