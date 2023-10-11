var hospid = session['LOGON.HOSPID'];
BatchAddfun = function(itemGrid) {
	var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
	var batchUrl ='herp.budg.budgdeptauditexe.csp';	
	//用户
	var userDs2 = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'name'])
			});

	userDs2.on('beforeload', function(ds, o) {
	
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('userCombo2').getRawValue()),
							method : 'POST'
						});
			});

	var userCombo2 = new Ext.form.ComboBox({
				id:'userCombo2',
				fieldLabel : '用户',
				store : userDs2,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '请选择...',
				width : 150,
				listWidth : 260,
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});
			
	//科室名称
	var deptDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'name'])
			});

	deptDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
							method : 'POST'
						});
			});

	var deptCombo = new Ext.form.ComboBox({
				id: 'deptCombo',
				fieldLabel : '科室',
				store : deptDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '请选择...',
				width : 150,
				listWidth : 260,			
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});

	//安全组
	var groupDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'name'])
			});
		
	groupDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : batchUrl+'?action=groupList&flag=1&str='+encodeURIComponent(Ext.getCmp('groupCombo').getRawValue()),
							method : 'POST'
						});
			});

	var groupCombo = new Ext.form.ComboBox({
				id: 'groupCombo',
				fieldLabel : '安全组',
				store : groupDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '请选择人员所属安全组...',
				width : 150,
				listWidth : 260,			
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});

	//科室类别
	var typeDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid','name'])
			});

	typeDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=deptType',
							method : 'POST'
						});
			});

	var typeCombo = new Ext.form.ComboBox({
				fieldLabel : '科室类别',
				store : typeDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择科室所属类别',
				width : 150,
				listWidth : 260,
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});
			
	//////////////////医疗单位
	var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxUrl+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						//allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 150,
						listWidth : 260,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});			

	var colItems =	[
		  {
			  layout: 'column',
			  border: false,
			  defaults: {
				  columnWidth: '.5',
				  bodyStyle:'padding:5px 5px 0',
				  border: false
				  },
				  items: [
			  	{
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  userCombo2,
				  deptCombo,
				  AddCompDRCombo
				  ]
			  	},{
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  groupCombo,
				  typeCombo
				  ]
				}]

			
		 }
		 ]
			
				var queryPanel = new Ext.form.FormPanel({
					labelWidth: 80,
					frame: true,
					items: colItems
				});
	  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '批量添加',
    width: 600,
    height:200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    // atLoad : true, // 是否自动刷新
    items:  queryPanel,
    buttons: [{
    	text: '增加',
		handler: function() {
      		
      		//用户
           	var user    = userCombo2.getValue();
           	
           	//科室名称
           	var dept    = deptCombo.getValue();
           	
           	//安全组
           	var group   = groupCombo.getValue();
           
           	//科室类别
      		var type 	= typeCombo.getValue();
      		
      		//医疗单位
      		var CompName= AddCompDRCombo.getValue();
      		
      		if(CompName=="")
      		{
	      		Ext.Msg.show({title:'错误',msg:'医疗单位不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		if(user==""&&group=="")
      		{
	      		Ext.Msg.show({title:'错误',msg:'用户和安全组不能同时为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      	
           	
      		Ext.Ajax.request({
				url: batchUrl+'?action=batch&user='+user+'&group='+group+'&dept='+dept+'&type='+type+'&CompName='+CompName,
				
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({msg:'成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                        itemGrid.load({params:{start:0,limit:25}});                       
						window.close();
					}
					else {
						var tmpMsg =jsonData.info+"插入失败!";
						Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					
					}
				},
			  	scope: this
			});

	}
},
{
		text: '取消',
handler: function(){window.close();}
}]
});

window.show();
};