YMRateFun = function(YMDetailGrid,SpltMainDR1,deptname) {

var rowObj=YMDetailGrid.getSelectionModel().getSelections();
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
		width:180,
	    listWidth : 180
	});

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			BudgetRate
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
      		var Rate = BudgetRate.getValue();
      		Rate = Rate.trim();
      		if(Rate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'调节比例为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		for(var i = 0; i < len; i++){
						Ext.Ajax.request({
							url: 'herp.budg.budgschsplitymdetailexe.csp?action=editrate&&rowid='+rowObj[i].get("rowid")+'&SpltMainDR1='+SpltMainDR1+'&mcode='+rowObj[i].get("mcode")+'&Rate='+Rate,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});		
								YMDetailGrid.load({params:{start:0, limit:25}});
								window.close();
								}
							},
					  	scope: this
						});
      		}
		    window.close();
	    	}
    	},
    	{text: '取消',handler: function(){window.close();}
      }]
    });

    window.show();
};