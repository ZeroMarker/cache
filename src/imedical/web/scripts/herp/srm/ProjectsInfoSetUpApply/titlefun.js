var titleFun = function(ProjectDR,RelyUnitsIDs) {
//alert(ProjectDR);
/////////////////////��������/////////////////////////
var NameField  = new Ext.form.TextField({
			fieldLabel: '��������',
			width : 160,
			emptyText: '',
			selectOnFocus : true		
		});
		
////////��Ŀ������
 HeadField = new Ext.form.TextField({
            fieldLabel: '��Ŀ������',
			width : 160,
			selectOnFocus : 'true'
           });		
 ////////����
 DeptField = new Ext.form.TextField({
            fieldLabel: '����',
			width : 160,
			selectOnFocus : 'true'
           });	
                     
 CompleteUnitField = new Ext.form.TextField({
            fieldLabel: '��Ժ��λλ��',
			width : 160,
			selectOnFocus : true
           });	

 PTNameField = new Ext.form.TextField({
            fieldLabel: '��������',   
			width : 160,
			selectOnFocus : true
           });	

var RelyUnitsGrid = new Ext.grid.GridPanel({
        fieldLabel: '���е�λ', 
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=RelyUnitsID&start='+0+'&limit='+25+'&RelyUnitsIDs='+RelyUnitsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 100,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '��λID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '��λ����', dataIndex: 'name',align:'center',width: 160}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 162,
    height: 100
});
	
 StartDateField = new Ext.form.TextField({
			fieldLabel: '��ʼ����',
			width : 160,	
			selectOnFocus : true
           });	
           
           /////��������
  EndDateField = new Ext.form.TextField({
			fieldLabel:'��������',
			width : 160,
			selectOnFocus : true
			
           });	
           /////�Ƿ�������Ŀ
 IsGovBuyField = new Ext.form.TextField({
			fieldLabel:'�Ƿ�������Ŀ',
			width : 160,
			selectOnFocus : true
			
           });	
           /////�Ƿ���������	
 IsEthicalApprovalField = new Ext.form.TextField({
			fieldLabel:'�Ƿ���Ҫ��������',
			width : 160,
			selectOnFocus : true
			
           });	
                      /////�Ƿ���������	
 RemarkField = new Ext.form.TextField({
			fieldLabel:'��ע',
			width : 160,
			selectOnFocus : true
			
           });	
	
Ext.Ajax.request({
					url: '../csp/herp.srm.srmprojectsinfoexe.csp?action=gettitle&rowid='+ProjectDR,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcodes = jsonData.info;
							//alert(jsonData.info);
							//alert(bcodes);
							var arr = bcodes.split("^");
							var Name=arr[0];
							NameField.setValue(Name);
							var Head=arr[1];
							HeadField.setValue(Head);
							var CompleteUnit=arr[2];
							CompleteUnitField.setValue(CompleteUnit);
							var PTName=arr[3];
							PTNameField.setValue(PTName);
							var StartDate=arr[4];
							StartDateField.setValue(StartDate);
							var EndDate=arr[5];
							EndDateField.setValue(EndDate);
							var IsGovBuy=arr[6];
							IsGovBuyField.setValue(IsGovBuy);
						    var IsEthicalApproval=arr[7];
							IsEthicalApprovalField.setValue(IsEthicalApproval);
							var Remark=arr[8];
							RemarkField.setValue(Remark);
							var Dept=arr[9];
							DeptField.setValue(Dept);
							
						}else{
							var message="";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});						
						}
					},
					scope: this
					});

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:8px 8px 3',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									NameField,	
									DeptField,
									HeadField,
									CompleteUnitField,	
									PTNameField,
									StartDateField,
									EndDateField
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								    RelyUnitsGrid,
									//IsGovBuyField,		
									IsEthicalApprovalField,								
									RemarkField
																			
								]
							}]
					}
				]	
				
				var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				height: 280,
				layout: 'form',
				frame: true,
				items: colItems
			});		
	
			addwin = new Ext.Window({
				title: '��Ŀ������ϸ��Ϣ',
				width: 600,
				height: 330,
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