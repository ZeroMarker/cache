CopyFun = function(itemGrid,deptname) {
	
	var editrUrl ='../csp/herp.budg.budgitemdictexe.csp';
	var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
	var smYearDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['year', 'year'])
			});

	smYearDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxURL+'?action=year&flag=',
							method : 'POST'
						});
			});

	var Year1Field = new Ext.form.ComboBox({
				fieldLabel : '往年年度',
				store : smYearDs,
				displayField : 'year',
				valueField : 'year',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText:'请选择往年年度...',
				width : 120,
				listWidth : 245,
				pageSize : 10,
				minChars : 1,
				anchor: '95%',
				selectOnFocus : true
			});

	var smYear2Ds = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['year', 'year'])
			});
			
			
	smYear2Ds = new Ext.data.Store({
						
						url : commonboxURL+'?action=year&flag=&start=0&limit=10&str=',
						autoLoad : true,  
						fields: ['year','year'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['year', 'year'])
	});

	var Year2Field = new Ext.form.ComboBox({
				fieldLabel : '预算年度',
				store : smYear2Ds,
				displayField : 'year',
				valueField : 'year',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText:'预算年度大于往年年度...',
				width : 120,
				listWidth : 245,
				pageSize : 10,
				minChars : 1,
				anchor: '95%',
				selectOnFocus : true
			});
			
	smYear2Ds.on("load", function(){
	
				var Num=smYear2Ds.getCount();
			    if (Num!=0){
			        var id=smYear2Ds.getAt(0).get('year');
				    Year2Field.setValue(id); 
			    } 

	});
		
	var bonusTypeDs = new Ext.data.Store({
		//autoLoad : true,
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : 'results',
			root : 'rows'
			}, ['code', 'name'])
	});

	bonusTypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : commonboxURL+'?action=itemtype&flag=1',
			method : 'POST'
		})
	});

	var TypeCodeField = new Ext.form.ComboBox({
		fieldLabel : '科目类别',
		width : 120,
		listWidth : 245,
		//allowBlank : true,
		store : bonusTypeDs,
		valueField : 'code',
		displayField : 'name',
		triggerAction : 'all',
		emptyText : '为空默认复制所有科目...',
		minChars : 1,
		anchor: '95%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : 'true',
		editable : true
	});
	

	var colItems =	[
	  {
		  layout: 'column',
		  border: false,
		  defaults: {
			  columnWidth: 1,
			  bodyStyle:'padding:5px 5px 0',
			  border: false
			  },
			  items: [
			  {  
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
					  Year1Field,
					  Year2Field,
					  TypeCodeField
				  ]
			  }]
	 }
	 ]
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 60,
				layout: 'form',
				frame: true,
				items: colItems
			});
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '复制科目',
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
      		// year, type, year2
      		var year 		= Year1Field.getValue();
      		var year2 		= Year2Field.getValue();
      		var type 		= TypeCodeField.getValue();

      		if(year=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'往年年度不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
      			return;
      		}
      		if(year2=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'目标年度不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
      			return;
      		}
      		if(year2<=year)
      		{
      			Ext.Msg.show({title:'警告',msg:'目标年度不能小于往年年度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
      			return;
      		}
      		Ext.Ajax.request({
				url: editrUrl+'?action=copy&year='+year+'&toyear='+year2+'&typeCode='+type,
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'提示',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                                mainGrid.root.reload();
						window.close();
					}
					else {
						var tmpMsg = jsonData.info+"处理失败!";
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