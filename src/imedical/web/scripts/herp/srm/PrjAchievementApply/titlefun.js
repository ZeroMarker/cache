var titleFun = function(title) {

    var records = itemGrid.getSelectionModel().getSelections();
	var IdentifyLevels  = records[0].get("IdentifyLevel");
	var IdentifyUnits  = records[0].get("IdentifyUnit");
	var IdentifyDates  = records[0].get("IdentifyDate");
	var CompleteUnits = records[0].get("CompleteUnit");
	
/////////////////////��������/////////////////////////
var IdentifyLevelField  = new Ext.form.TextField({
			fieldLabel: '��������',
			width:180,
			value:IdentifyLevels,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
        //emptyText: '��Ŀ����......',
			selectOnFocus:'true'
		});
		
////////������λ
 IdentifyUnitField = new Ext.form.TextField({
            fieldLabel: '������λ',
			width:180,
			value:IdentifyUnits,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
        //emptyText: '��Ŀ����......',
			selectOnFocus:'true'
           });		
 ////////��������
 IdentifyDateField = new Ext.form.TextField({
            fieldLabel: '��������',
			width : 180,
			value:IdentifyDates,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
			selectOnFocus : 'true'
           });	
/////////��Ժ��λλ��          
 CompleteUnitField = new Ext.form.TextField({
            fieldLabel: '��Ժ��λλ��',
			width:180,
			value:CompleteUnits,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
        //emptyText: '��Ŀ����......',
			selectOnFocus:'true'
           });	
				
		var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				height: 200,
				layout: 'form',
				frame: true,
				items: [IdentifyLevelField,IdentifyUnitField,IdentifyDateField,CompleteUnitField]
			});		
	
			addwin = new Ext.Window({
				title: title+'--��ϸ��Ϣ',
				width: 300,
				height: 200,
				//autoHeight: true,
				atLoad: true,
				//layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'sorth',
				items: formPanel
			});
		
			addwin.show();

}