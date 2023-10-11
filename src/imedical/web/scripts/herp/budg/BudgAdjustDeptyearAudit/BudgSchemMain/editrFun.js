editrFun = function(year,curSchemeDr,itemGrid) {
	
	var editrUrl ='../csp/herp.budg.budgchemdetailexe.csp';
	
	var YearField = new Ext.form.TextField({
				fieldLabel: '������',
				width:180,
				value:year,
				anchor: '95%',
				emptyText:'Ϊ��Ĭ�ϵ�ǰ��',
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
			url : 'herp.budg.budgitemdictexe.csp?action=listType',
			method : 'POST'
		})
	});

	var TypeCodeField = new Ext.form.ComboBox({
		fieldLabel : '��Ŀ���',
		//width : 180,
		allowBlank : true,
		store : bonusTypeDs,
		valueField : 'code',
		displayField : 'name',
		triggerAction : 'all',
		emptyText : 'Ϊ��Ĭ����ʾ���п�Ŀ',
		minChars : 1,
		anchor: '95%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : 'true',
		editable : true
	});

	var calmethodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data : [['1', '��ʽ����'], ['2', '��ʷ����* ����ϵ��'], ['3', '��ʷ����']]  
	});
	
	var calmethodField = new Ext.form.ComboBox({
		id: 'calmethodField',
		fieldLabel: '���㷽��',
		allowBlank: false,
		emptyText: '���㷽��...',
		store: calmethodStore,
		valueNotFoundText:'',
	    displayField: 'keyValue',
	    valueField: 'key',
	    triggerAction: 'all',
	    value:2,
	    emptyText:'',
	    mode: 'local', //����ģʽ
	    editable:false,
	    pageSize: 10,
	    minChars: 1,
	    selectOnFocus:true,
	    forceSelection:true,
		anchor: '95%'
	});
	
	/////////////////////////�Ƿ����////////////////////////////			
	var isCalCompb = new Ext.form.Checkbox({												
				fieldLabel: '�Ƿ����'
			});						
			
	isCalCompb.on('check', function( c , checked ){
				if(checked){
					formulaField.enable();
				}else{
					formulaField.setValue("");
					formulaField.disable();
				}
			});
		
	var formulaField = new Ext.form.TextField({
		id: 'formulaField',
		fieldLabel: '��ʽ����',
		allowBlank: true,
		emptyText:'',
		anchor: '95%'
	});
	formulaField.on('focus', function(f){
				formula(1, this, formulaField);
			});	
	formulaField.disable();
/////////////////////////�Ƿ�ֽ�////////////////////////////	
var isSplitCompbox = new Ext.form.Checkbox({												
				fieldLabel: '�Ƿ�ֽ�'
			});						
			
	isSplitCompbox.on('check', function( c , checked ){
				if(checked){
					SplitMethCombo.enable();
				}else{
					SplitMethCombo.setValue("");
					SplitMethCombo.disable();
				}
			});
	var SplitMethDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['1', '��ʷ����'], ['2', '��ʷ����*���ڱ���'], ['3', '����ϵ��'],
						['4', 'ȫ��᳹'], ['5', '��̯']]
			});

	var SplitMethCombo = new Ext.form.ComboBox({
				fieldLabel : '�ֽⷽ��',
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
				mode : 'local', // ����ģʽ
				selectOnFocus : true
			});
	SplitMethCombo.disable();		
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
				  YearField,
				  isSplitCompbox,
				  isCalCompb,
				  calmethodField
				  ]
			  },{   
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  TypeCodeField,
				  SplitMethCombo,
				  formulaField
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
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��������',
    width: 600,
    height:200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    // atLoad : true, // �Ƿ��Զ�ˢ��
    items: formPanel,
    buttons: [{
    	text: '����',
		handler: function() {
      		// YearField TypeCodeField isSplitCompbox isCalCompb calmethodField SplitMethCombo formulaField
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
      		var isCal 		= isCalCompb.getValue();
      		if(isCal)
      		{
	      		isCal = 1
	      	}else{ 
      		isCal = 0 
      		}
      		var formula 	= formulaField.getValue();
      				
      		Ext.Ajax.request({
				url: editrUrl+'?action=editr&&schemdr='+curSchemeDr+'&year='+year+'&calmethod='+calmethod+'&isSplit='+isSplit+'&Itype='+Itype+'&split='+split+'&isCal='+isCal+'&formula='+formula,
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
						window.close();
					}
					else {
						var tmpMsg = jsonData.info+"����ʧ��!";
						Ext.Msg.show({title:'����',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
			  	scope: this
			});

	}
},
{
		text: 'ȡ��',
handler: function(){window.close();}
}]
});

window.show();
};