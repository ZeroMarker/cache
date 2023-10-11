var titleFun = function(VersionCostDR) {

			/////////////////////论文标题/////////////////////////
var TitleField  = new Ext.form.TextField({
			fieldLabel: '论文标题',
			width : 130,
			emptyText: '',
			selectOnFocus : true		
		});
		
////////发表刊物		
 JNameField = new Ext.form.TextField({
            fieldLabel: '发表刊物',
			width : 130,
			selectOnFocus : 'true'
			//value: JName
           });		
 DeptNameField = new Ext.form.TextField({
            fieldLabel: '科室',
			width : 130,
			selectOnFocus : true
			//value:  DeptName
           });	
///////////年	
PubYearField = new Ext.form.TextField({
            fieldLabel: '刊物具体信息',   
			width : 130,
			selectOnFocus : true
			//fieldLabel:  PubYear
           });	
           /////卷	
 RollField = new Ext.form.TextField({
			fieldLabel:'卷',
			width : 130,
			selectOnFocus : true
			
           });	
           /////期		
PeriodField = new Ext.form.TextField({
			fieldLabel: '期',
			width : 130,	
			selectOnFocus : true
           });	
           
           /////通信作者	
CorrAuthorNameField = new Ext.form.TextField({
			fieldLabel:'通信作者',
			width : 130,
			selectOnFocus : true
			
           });	
           /////起始页号	
 StartpageField = new Ext.form.TextField({
			fieldLabel:'起始页号',
			width : 130,
			selectOnFocus : true
			
           });	
           /////终止页号	
EndpageField = new Ext.form.TextField({
			fieldLabel:'终止页号',
			width : 130,
			selectOnFocus : true
			
           });	
           /////作者	
 FirstAuthorNameField = new Ext.form.TextField({
			fieldLabel: '作者',
			width : 130,
			selectOnFocus : true
			
           });	
           /////SN		
 SNField = new Ext.form.TextField({
			fieldLabel: 'SN',
			width : 130,
			selectOnFocus : true
			
           });	
      /////发表形式	
 PTypeField = new Ext.form.TextField({
			fieldLabel: '发表形式',
			width : 130,
			selectOnFocus : true
			
           });	
     /////文献类型	
 DocTypeField = new Ext.form.TextField({
			fieldLabel:'文献类型',
			width : 130,
			selectOnFocus : true
			
           });	
      /////入藏号
 WOSField = new Ext.form.TextField({
			fieldLabel: '入藏号',
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
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							
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
				title: '论文发表明细信息',
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