CopyFun = function(fromschemdr) {
	
var URL='herp.budg.budgschemauditexe.csp';
	
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : URL+'?action=Yearlist',
						method : 'POST'
					});
		});

var YearCombo = new Ext.form.ComboBox({
			fieldLabel : '目标年度',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText:'把选择目标年度...',
			width : 180,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			anchor: '95%',
			selectOnFocus : true,
			listeners:{
	            "select":function(combo,record,index){
		            schemDs.removeAll();     
					schemCombo.setValue('');
					schemDs.proxy = new Ext.data.HttpProxy({url: URL+'?action=deptschem&flag=2&year='+combo.value,method:'POST'})  
					schemDs.load({params:{start:0,limit:10}});      					
				}
	   		}
});

		
var schemDs = new Ext.data.Store({
		autoLoad : true,
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : 'results',
			root : 'rows'
			}, ['rowid','name'])
	});

schemDs.on('beforeload', function(ds, o) {  
		var year=YearCombo.getValue();
		ds.proxy = new Ext.data.HttpProxy({
				url : URL+'?action=deptschem&flag=2&year='+year,
				method : 'POST'
		})
	});

var schemCombo = new Ext.form.ComboBox({
		fieldLabel : '目标方案',
		allowBlank : true,
		store : schemDs,
		valueField : 'rowid',
		displayField : 'name',
		triggerAction : 'all',
		emptyText : '把选择目标方案...',
		width : 180,
		listWidth : 220,
		anchor: '95%',
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true,
		forceSelection : 'true',
		editable : true,
		listeners:{
	    	"focus":function(combo){
					var year=YearCombo.getValue();
					if(year=="")
					{
						Ext.Msg.show({title:'注意',msg:'请先选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:'160'});
						return;
					}
			}
	   	}
	});
	

var colItems =	[
	  {
		  layout: 'column',
		  border: false,
		  defaults: {
			  bodyStyle:'padding:5px 5px 0',
			  border: false
			  },
			  items: [
			  {  
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  YearCombo,
				  schemCombo
				  ]
			  }]
	 }
	 ]
			
var formPanel = new Ext.form.FormPanel({
				labelWidth: 80,
				frame: true,
				items: colItems
});


  // define window and show it in desktop
var window = new Ext.Window({
  	title: '复制方案归口科室',
    width: 300,
    height:200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    // atLoad : true, // 是否自动刷新
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		var year=YearCombo.getValue();
      		var toschemdr=schemCombo.getValue();

      		if(year=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'年度不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		if(toschemdr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'方案不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}	
      		Ext.Ajax.request({
				url: URL+'?action=copy&fromschemdr='+fromschemdr+'&toschemdr='+toschemdr+'&year='+year,
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                        //mainGrid.root.reload();
						window.close();
					}
					else {
						var tmpMsg = jsonData.info+"处理失败!";
						if(jsonData.info=="done"){
							var	tmpMsg="表中已存在,勿重复!"
						}
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