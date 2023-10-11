﻿batchSettingFun = function(year,curSchemeDr,itemGrid) {
	var editrUrl ='herp.budg.budgchemdetailexe.csp';
	var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
	
	var YearField = new Ext.form.TextField({
				fieldLabel: '会计年度',
				width:180,
				value:year,
				anchor: '95%',
				emptyText:'为空默认当前年',
				selectOnFocus:'true'
	});

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
			url : commonboxURL+'?action=itemtype&flag=1',
			method : 'POST'
		})
	});
	var TypeCodeField = new Ext.form.ComboBox({
		fieldLabel : '科目类别',
		//width : 180,
		allowBlank : true,
		store : bonusTypeDs,
		valueField : 'code',
		displayField : 'name',
		triggerAction : 'all',
		emptyText : '为空默认显示所有科目',
		minChars : 1,
		anchor: '95%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : 'true',
		editable : true
	});
	
	var SplitMethDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['1', '历史数据'], ['2', '历史数据*调节比例'], ['3', '比例系数'],
						['4', '全面贯彻'], ['5', '均摊']]
			});
	var SplitMethCombo = new Ext.form.ComboBox({
				fieldLabel : '分解方法',
				store : SplitMethDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				width : 100,
				listWidth : 250,
				anchor: '95%',
				pageSize : 10,
				minChars : 1,
				columnWidth : .12,
				mode : 'local', // 本地模式
				selectOnFocus : true
			});
			
	var calmethodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data : [['1', '公式计算'], ['2', '历史数据* 比例系数'], ['3', '历史数据']]  
	});
	var calmethodField = new Ext.form.ComboBox({
		id: 'calmethodField',
		fieldLabel: '计算方法',
		//allowBlank: false,
		emptyText: '计算方法...',
		store: calmethodStore,
		valueNotFoundText:'',
	    displayField: 'keyValue',
	    valueField: 'key',
	    triggerAction: 'all',
	    emptyText:'',
	    mode: 'local', //本地模式
	    editable:false,
	    pageSize: 10,
	    minChars: 1,
	    selectOnFocus:true,
	    forceSelection:true,
		anchor: '95%'
	});
	calmethodField.on("select", function(cmb, rec, id) {
		if((isCalCompb.checked)&&(cmb.getValue()==1)){
			formulaField.enable();
		}else{
			formulaField.setValue("");
			formulaField.disable();
		}
	});
	
	var formulaField = new Ext.form.TextField({
		id: 'formulaField',
		fieldLabel: '公式描述',
		allowBlank: true,
		emptyText:'',
		anchor: '95%'
	});
	formulaField.on('focus', function(f){
		var year=YearField.getValue();
		if(year!==""){
			budgformula(1, year, formulaField);
		}else{
			Ext.Msg.show({title:'提示',msg:'会计年度不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		}
	});	

/////////////////////////是否分解////////////////////////////	
var isSplitCompbox = new Ext.form.Checkbox({												
				fieldLabel: '是否分解'
			});						
	isSplitCompbox.on('check', function( c , checked ){
				if(checked){
					TypeCodeField.enable();
					SplitMethCombo.enable();
				}else{
					SplitMethCombo.setValue("");
					TypeCodeField.disable();
					SplitMethCombo.disable();
				}
			});
	
/////////////////////////是否计算////////////////////////////			
	var isCalCompb = new Ext.form.Checkbox({												
				fieldLabel: '是否计算'
			});						
	isCalCompb.on('check', function( c , checked ){
				if(checked){
					TypeCodeField.enable();
					calmethodField.enable();
				}else{
					calmethodField.setValue("");
					formulaField.setValue("");
					TypeCodeField.disable();
					calmethodField.disable();
					formulaField.disable();
				}
			});
			
	YearField.disable();
	TypeCodeField.disable();
	SplitMethCombo.disable();
	calmethodField.disable();		
	formulaField.disable();


	var colItems =	[{
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
				  isSplitCompbox,
				  isCalCompb
				  ]
			  },{   
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  YearField,
				  TypeCodeField,
				  SplitMethCombo,
				  calmethodField,
				  formulaField
				  ]
			}]
	 }]
			
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 80,
		frame: true,
		items: colItems
	});

  var window = new Ext.Window({
  	title: '批量设置',
    width: 600,
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
      		var calmethod	= calmethodField.getValue();
      		var isSplit 	= isSplitCompbox.getValue();
      		if(isSplit){
					isSplit = 1
				}else{
					isSplit = 0
				}
      		var split	 	= SplitMethCombo.getValue();
			if((isSplit=='1')&&(split=="")){
				Ext.Msg.show({title:'提示',msg:'分解方法不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}

      		var isCal 		= isCalCompb.getValue();
      		if(isCal)
      		{
	      		isCal = 1
	      	}else{ 
	      		isCal = 0 
      		}
      		var formula 	= formulaField.getValue().split("=")[1];
      		var formuladesc = formulaField.getValue().split("=")[0];
      		
      		var data=""
      		data=curSchemeDr+"|"+year+"|"+Itype+"|"+calmethod+"|"+isSplit
      				+"|"+split+"|"+isCal+"|"+encodeURI(formula).replace(/\+/g,'%2B')+"|"+encodeURI(formuladesc).replace(/\+/g,'%2B')  
      			
      		Ext.Ajax.request({
				url: editrUrl+'?action=editr&data='+data,
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
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
	},{
		text: '取消',
		handler: function(){window.close();}
	}]
});
	window.show();
};