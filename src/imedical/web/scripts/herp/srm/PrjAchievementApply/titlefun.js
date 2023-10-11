var titleFun = function(title) {

    var records = itemGrid.getSelectionModel().getSelections();
	var IdentifyLevels  = records[0].get("IdentifyLevel");
	var IdentifyUnits  = records[0].get("IdentifyUnit");
	var IdentifyDates  = records[0].get("IdentifyDate");
	var CompleteUnits = records[0].get("CompleteUnit");
	
/////////////////////鉴定级别/////////////////////////
var IdentifyLevelField  = new Ext.form.TextField({
			fieldLabel: '鉴定级别',
			width:180,
			value:IdentifyLevels,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
        //emptyText: '科目名称......',
			selectOnFocus:'true'
		});
		
////////鉴定单位
 IdentifyUnitField = new Ext.form.TextField({
            fieldLabel: '鉴定单位',
			width:180,
			value:IdentifyUnits,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
        //emptyText: '科目名称......',
			selectOnFocus:'true'
           });		
 ////////鉴定日期
 IdentifyDateField = new Ext.form.TextField({
            fieldLabel: '鉴定日期',
			width : 180,
			value:IdentifyDates,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
			selectOnFocus : 'true'
           });	
/////////我院单位位次          
 CompleteUnitField = new Ext.form.TextField({
            fieldLabel: '我院单位位次',
			width:180,
			value:CompleteUnits,
			disabled:true,
			allowBlank : true, 
			anchor: '95%',
        //emptyText: '科目名称......',
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
				title: title+'--明细信息',
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