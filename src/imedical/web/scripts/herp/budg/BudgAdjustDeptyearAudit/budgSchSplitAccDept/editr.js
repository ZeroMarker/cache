editrFun = function(itemGrid) {
	
	var editrUrl ='../csp/herp.budg.budgschemsplityearmonthdetailexe.csp';
	
	var YearField = new Ext.form.TextField({
				fieldLabel: '������',
				width:180,
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
	
	///////////////////////�������///////////////////////////
	var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptTypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitymeditrexe.csp?action=deptTypeist',method:'POST'});
		
	});
		
	var deptTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'�������',
		store: deptTypeDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'Ϊ��Ĭ����ʾ���п���...',
		width: 110,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		anchor: '95%',
		selectOnFocus:true
	});

/////////////////////////�Ƿ��������////////////////////////////			
var isAlCompStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var isAlCompbox = new Ext.form.ComboBox({
			id : 'isAlCompbox',
			fieldLabel : '�Ƿ��������',
			width : 200,
			//listWidth : 200,
			//allowBlank : false,
			store : isAlCompStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			anchor: '95%',
			selectOnFocus : true,
			forceSelection : true
		});	
	var splitmethodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['2','��ʷ����*���ڱ���'],['3','����ϵ��']]  
	});
	
	var splitmethodField = new Ext.form.ComboBox({
		id: 'splitmethodField',
		fieldLabel: '�ֽⷽ��',
		allowBlank: false,
		emptyText: '�ֽⷽ��...',
		store: splitmethodStore,
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
		
	var RateField = new Ext.form.NumberField({
		id: 'bssdrateField1',
		fieldLabel: '���ڱ���',
		allowBlank: false,
		emptyText:'0.**',
		anchor: '95%'
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
				  YearField,
				  splitmethodField,
				  RateField
				  ]
			  },{
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  TypeCodeField,
				  deptTypeCombo,
				  isAlCompbox
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
      		// year, Itype, dtype,splitmeth,rate,IsAlComp, flag
      		var year 		= YearField.getValue();
      		var Itype 		= TypeCodeField.getValue();
      		var splitmeth 	= splitmethodField.getValue();
      		var rate 		= RateField.getValue();
      		var dtype 		= deptTypeCombo.getValue();
      		var IsAlComp 	= isAlCompbox.getValue();

      		if(splitmeth=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ֽⷽ������Ϊ�գ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      		if(rate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���ڱ�������Ϊ�գ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      				
      		Ext.Ajax.request({
				url: editrUrl+'?action=editr&&year='+year+'&IsAlComp='+IsAlComp+'&dtype='+dtype+'&Itype='+Itype+'&splitmeth='+splitmeth+'&rate='+rate+'&flag=2',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGrid.load({params:{start:0, limit:25}});
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