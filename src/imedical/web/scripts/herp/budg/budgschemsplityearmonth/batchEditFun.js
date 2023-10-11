﻿//批量处理--分解方法+调节比例
batchEditFun = function(itemGrid) {
	var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
	var editrUrl ='herp.budg.budgschemsplityearmonthdetailexe.csp';
	
	//预算年度
	var yearDs  = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
	});
	yearDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:commonboxUrl+'?action=year',method:'POST'})
			});
	var YearField  = new Ext.form.ComboBox({
		id: 'YearField',
		name: 'YearField',
		fieldLabel: '预算年度',
		width:120,
		listWidth : 285,
		anchor: '95%',
		allowBlank: false,
		store: yearDs,
		valueField: 'year',
		displayField: 'year',
		triggerAction: 'all',
		emptyText:'预算年度...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	//预算项类别
	var bonusTypeDs = new Ext.data.Store({
		autoLoad : true,
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : 'results',
			root : 'rows'
			}, ['rowid', 'code', 'name'])
	});
	bonusTypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'herp.budg.budgcommoncomboxexe.csp?action=itemtype&flag=1',
			method : 'POST'
		})
	});
	var TypeCodeField = new Ext.form.ComboBox({
		fieldLabel : '预算项类别',
		listWidth:285,
		allowBlank : true,
		store : bonusTypeDs,
		valueField : 'code',
		displayField : 'name',
		triggerAction : 'all',
		emptyText : '预算项类别...',
		minChars : 1,
		anchor: '95%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : 'true',
		editable : true
	});

	//分解方法
	var splitmethodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data : [['1', '历史数据'], ['2', '历史数据*调节比例'], ['3', '比例系数'],
				['4', '全面贯彻'], ['5', '均摊']]
	});
	
	var splitmethodField = new Ext.form.ComboBox({
		id: 'splitmethodField',
		fieldLabel: '分解方法',
		listWidth:285,
		allowBlank: false,
		emptyText: '分解方法...',
		store: splitmethodStore,
		valueNotFoundText:'',
	    displayField: 'keyValue',
	    valueField: 'key',
	    triggerAction: 'all',
	    mode: 'local', //本地模式
	    editable:false,
	    pageSize: 10,
	    minChars: 1,
	    selectOnFocus:true,
	    forceSelection:true,
		anchor: '95%'
	});
	
	//调节比例	
	var RateField = new Ext.form.NumberField({
		id: 'bssdrateField1',
		fieldLabel: '调节比例',
		allowBlank: false,
		emptyText:'0.**',
		anchor: '95%'
	});

var colItems =	[
	  {
		  layout: 'column',
		  border: false,
		  defaults: {
			  columnWidth: '1',
			  bodyStyle:'padding:5px 5px 0',
			  border: false
			  },
			  items: [
			  {
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  YearField,
				  TypeCodeField,
				  splitmethodField,
				  RateField
				  ]
			  }]
	 }
	 ]
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});

  var window = new Ext.Window({
  	title: '批量设置',
    width: 400,
    height:250,
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

      		var year 		= YearField.getValue();
      		var Itype 		= TypeCodeField.getValue();
      		var splitmeth 	= splitmethodField.getValue();
      		var rate 		= RateField.getValue();

      		if(splitmeth=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'分解方法不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		if(rate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'调节比例不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      				
      		Ext.Ajax.request({
				url: editrUrl+'?action=editr&year='+year+'&Itype='+Itype+'&splitmeth='+splitmeth+'&rate='+rate+'&flag=1',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGrid.load({params:{start:0, limit:25}});
						window.close();
					}
					else {
						var tmpMsg = jsonData.info+"处理失败!";
						Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
			  	scope: this
			});	}
		},{
			text: '取消',
			handler: function(){window.close();}
		}]
	});
	window.show();
};