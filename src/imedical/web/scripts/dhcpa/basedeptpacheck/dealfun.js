//�ύ
submitFun = function(itemGrid,result){
   
    var userdr = session['LOGON.USERID'];
	var rowObj = itemGrid.getSelectionModel().getSelections();
	
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;

for(var i=0;i<len;i++){
var schemrowid = rowObj[i].get("srowid");



        var rowid = rowObj[i].get("rowid"); 
        var addPeriod = rowObj[i].get("period"); 
        var srowid=rowObj[i].get("srowid"); 
        var addSchem=rowObj[i].get("name"); 
        var state=rowObj[i].get("auditstate"); 

var addUser=session['LOGON.USERNAME'];

///////////////////�����ڼ�/////////////////////////////  
var addPeriodDate = new Ext.form.TextField({
				fieldLabel: '�����ڼ�',
				width:100,
				value:addPeriod,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
///////////////////���㷽��/////////////////////////////  
var addSchemText = new Ext.form.TextField({
				fieldLabel: '���㷽��',
				width:180,
				value:addSchem,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
///////////////////�ύ��/////////////////////////////  
var addUserText = new Ext.form.TextField({
				fieldLabel: '������',
				width:180,
				value:addUser,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	

///////////////////����/////////////////////////////  	
var DeptDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['deptdr','deptname'])
	});
	
DeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.basicuintpacaluexe.csp?action=listschemdepts&schemrowid='+schemrowid,method:'POST'});
				});
var DeptField  = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '����',
	width : 180,
	anchor:'100%',
	store: DeptDs,
	valueField: 'deptdr',
	displayField: 'deptname',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
///////////////////��������/////////////////////////////  
var addProcDescText = new Ext.form.TextField({
                id:'addProcDescText',
				fieldLabel: '��������',
				width:180,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});			
/////////// �������
var textArea = new Ext.form.TextArea({
				id : 'textArea',
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
									addPeriodDate,
					                addSchemText,
					                addUserText,
									
									addProcDescText,
									textArea							
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
						

		   var view= encodeURIComponent(Ext.getCmp('addProcDescText').getRawValue());
           var procdesc = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		   //var deptdr = DeptField.getValue();
		   var procdesc = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			     Ext.Ajax.request({
				url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
				+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+result+"&desc="+procdesc,
		
				waitMsg:'�����...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					findButton.handler();
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
			title: '��¼����',
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
}	
};