//ȡ���ύ
CancelSubmitfun = function(itemGrid){

var userdr = session['LOGON.USERID'];
var deptdr = session['CTLOCID'];
	
var rowObj = itemGrid.getSelectionModel().getSelections();
var len = rowObj.length;
var schemrowid = rowObj[0].get("schemrowid");

var cancelPeriod=rowObj[0].get("checkperiod");
var cancelSchem=rowObj[0].get("schemname");
var cancelUser=session['LOGON.USERNAME'];

///////////////////�����ڼ�/////////////////////////////  
var cancelPeriodDate = new Ext.form.TextField({
				fieldLabel: '�����ڼ�',
				width:180,
				value:cancelPeriod,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
///////////////////���㷽��/////////////////////////////  
var cancelSchemText = new Ext.form.TextField({
				fieldLabel: '���㷽��',
				width:180,
				value:cancelSchem,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
///////////////////�ύ��/////////////////////////////  
var cancelUserText = new Ext.form.TextField({
				fieldLabel: '�ύ��',
				width:180,
				value:cancelUser,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
			
/* ///////////////////����/////////////////////////////  	
var cancelDeptDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['deptdr','deptname'])
	});
	
cancelDeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.basicuintpacaluexe.csp?action=listschemdepts&schemrowid='+schemrowid,method:'POST'});
				});
var cancelDeptField  = new Ext.form.ComboBox({
	id: 'cancelDeptField',
	fieldLabel: '����',
	width : 180,
	anchor:'100%',
	store: cancelDeptDs,
	valueField: 'deptdr',
	displayField: 'deptname',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'cancelDeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
}); */
///////////////////��������/////////////////////////////  
var cancelProcDescText = new Ext.form.TextField({
                id:'cancelProcDescText',
				fieldLabel: '��������',
				width:180,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});		
/////////// �������
var canceltextArea = new Ext.form.TextArea({
				id : 'canceltextArea',
				width : 500,
				height : 120,
				anchor: '100%',
				fieldLabel : '�������',
				allowBlank :false,
				selectOnFocus:'true',
				emptyText : '����д�����������'
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
						items: [{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									cancelPeriodDate,
					                cancelSchemText,
					                cancelUserText,
									cancelProcDescText,
									canceltextArea							
								]
							 }]
					}
				]				
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 80,
		frame: true,
		items: colItems
	});
	
	addButton = new Ext.Toolbar.Button({
		text:'ȷ��'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
		addHandler = function(){      			
						

		   var view= encodeURIComponent(Ext.getCmp('canceltextArea').getRawValue());
           var procdesc=encodeURIComponent(Ext.getCmp('cancelProcDescText').getRawValue());
		   //var deptdr = cancelDeptField.getValue();
		  
		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:'dhc.pa.basicuintpacaluexe.csp'+'?action=cancelsubmit&schemrowid='+rowObj[i].get("schemrowid")+'&sprrowid='+rowObj[i].get("sprrowid")+'&userid='+userdr+'&procdesc='+procdesc+'&desc='+view,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'ȡ���ύ�ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:'ȡ���ύʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else{
				Ext.Msg.show({title:'����',msg:'������ҳ���ϵĴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
			addwin.close();
   }
	////// ��Ӽ����¼� ////////////////	
		addButton.addListener('click',addHandler,false);

		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
		
		cancelHandler = function(){
			addwin.close();
		}
		
		cancelButton.addListener('click',cancelHandler,false);

		addwin = new Ext.Window({
			title: 'ȡ���ύ',
			width: 450,
			height: 400,
			//autoHeight: true,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});		
		addwin.show();		
};		