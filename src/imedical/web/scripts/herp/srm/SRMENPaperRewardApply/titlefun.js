var titleFun = function(VersionCostDR) {

			/////////////////////���ı���/////////////////////////
var TitleField  = new Ext.form.TextField({
			fieldLabel: '���ı���',
			width : 130,
			emptyText: '',
			selectOnFocus : true		
		});
		
////////������		
 JNameField = new Ext.form.TextField({
            fieldLabel: '������',
			width : 130,
			selectOnFocus : 'true'
			//value: JName
           });		
 DeptNameField = new Ext.form.TextField({
            fieldLabel: '����',
			width : 130,
			selectOnFocus : true
			//value:  DeptName
           });	
///////////��	
PubYearField = new Ext.form.TextField({
            fieldLabel: '���������Ϣ',   
			width : 130,
			selectOnFocus : true
			//fieldLabel:  PubYear
           });	
           /////��	
 RollField = new Ext.form.TextField({
			fieldLabel:'��',
			width : 130,
			selectOnFocus : true
			
           });	
           /////��		
PeriodField = new Ext.form.TextField({
			fieldLabel: '��',
			width : 130,	
			selectOnFocus : true
           });	
           
           /////ͨ������	
CorrAuthorNameField = new Ext.form.TextField({
			fieldLabel:'ͨ������',
			width : 130,
			selectOnFocus : true
			
           });	
           /////��ʼҳ��	
 StartpageField = new Ext.form.TextField({
			fieldLabel:'��ʼҳ��',
			width : 130,
			selectOnFocus : true
			
           });	
           /////��ֹҳ��	
EndpageField = new Ext.form.TextField({
			fieldLabel:'��ֹҳ��',
			width : 130,
			selectOnFocus : true
			
           });	
           /////����	
 FirstAuthorNameField = new Ext.form.TextField({
			fieldLabel: '����',
			width : 130,
			selectOnFocus : true
			
           });	
           /////SN		
 SNField = new Ext.form.TextField({
			fieldLabel: 'SN',
			width : 130,
			selectOnFocus : true
			
           });	
      /////������ʽ	
 PTypeField = new Ext.form.TextField({
			fieldLabel: '������ʽ',
			width : 130,
			selectOnFocus : true
			
           });	
     /////��������	
 DocTypeField = new Ext.form.TextField({
			fieldLabel:'��������',
			width : 130,
			selectOnFocus : true
			
           });	
      /////��غ�
 WOSField = new Ext.form.TextField({
			fieldLabel: '��غ�',
			width : 130,
			selectOnFocus : true
			
           });	
     /////IF
 IFField = new Ext.form.TextField({
			fieldLabel: 'IF',
			width : 130,
			selectOnFocus : true
			
           });
			
Ext.Ajax.request({
					url: '../csp/herp.srm.srmauditversioncostsexee.csp?action=gettitle&RecId='+VersionCostDR,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcodes = jsonData.info;
							//alert(bcodes);
							var arr = bcodes.split("^");
							var Title=arr[0];
							TitleField.setValue(Title);
							var JName=arr[1];
							JNameField.setValue(JName);
							var DeptName=arr[2];
							DeptNameField.setValue(DeptName);
							var PubYear=arr[3];
							PubYearField.setValue(PubYear);
							//var Roll=arr[4];
							//RollField.setValue(Roll);
							//var Period=arr[5];
							//PeriodField.setValue(Period);
							var CorrAuthorName=arr[4];
							CorrAuthorNameField.setValue(CorrAuthorName);
							var Startpage=arr[5];
							StartpageField.setValue(Startpage);
							var Endpage=arr[6];
							EndpageField.setValue(Endpage);
							var FirstAuthorName=arr[7];
							FirstAuthorNameField.setValue(FirstAuthorName);
							//alert(FirstAuthorName);
							var SN=arr[8];
							SNField.setValue(SN);
							var PType=arr[9];
							PTypeField.setValue(PType);
							var DocType=arr[10];
								
							if (DocType==1) {DocType="article"} 
    						if (DocType==2) {DocType="review"} 
							if (DocType==3) {DocType="letter"} 
							if (DocType==4) {DocType="Editorial"} 
							if (DocType==5) {DocType="Materia" }
	
							
							
							DocTypeField.setValue(DocType);
							var WOS=arr[11];
							WOSField.setValue(WOS);
							var IF=arr[12];
							IFField.setValue(IF);
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
									TitleField,	
									DeptNameField,
									CorrAuthorNameField,	
									FirstAuthorNameField,	
									SNField,	
									DocTypeField,
									IFField																								
									//RollField,	
									//PeriodField,
									
									
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									JNameField,
									PubYearField,
									StartpageField,		
									EndpageField,								
									PTypeField,													
									WOSField													
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
				title: '���ķ�����ϸ��Ϣ',
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