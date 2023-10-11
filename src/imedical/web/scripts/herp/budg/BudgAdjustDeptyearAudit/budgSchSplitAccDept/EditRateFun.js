EditRateFun = function(budgDetailGrid) {

var rowObj=budgDetailGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var isAlComp=rowObj[0].get("isAlComp");
		
	}	


/////////////////调解比例/////////////////////////////////
var BudgetRate = new Ext.form.TextField({
		id: 'BudgetRate',
		fieldLabel: '调解比例',
		allowBlank: true,
		emptyText:'请填写调节比例...',
		width:180
	});
	
/////////////////////////是否独立核算////////////////////////////			
var isAlCompStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var isAlCompbox = new Ext.form.ComboBox({
			id : 'isAlCompbox',
			fieldLabel : '是否独立核算',
			width : 180,
			allowBlank : false,
			store : isAlCompStore,
			//anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '选择是或者否',
			mode : 'local', // 本地模式
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
  	title: '调节比例设置',
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
    	text: '保存',
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
      			Ext.Msg.show({title:'错误',msg:'调节比例为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		for(var i = 0; i < len; i++){
						Ext.Ajax.request({
							url: 'herp.budg.budgschsplitaccdeptdetailexe.csp?action=RateEdit&&rowid='+rowObj[i].get("rowid")+'&Rate='+Rate+'&isAlComp='+isAlComp,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});		
								budgDetailGrid.load({params:{start:0, limit:25}});
								window.close();
								}
//								else
//								{
//									var message = "";
//									message = "SQLErr: " + jsonData.info;
//									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
//									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
//									if(jsonData.info=='RepName') message='输入的名称已经存在!';
//								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//								}
							},
					  	scope: this
						});
      		}
		    window.close();
        	//}
//        	else{
//						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//					}
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};