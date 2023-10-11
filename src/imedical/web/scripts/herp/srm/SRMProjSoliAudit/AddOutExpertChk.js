AddOutExpertChk = function(viewrowid)
{
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var expertinfo = rowObj[0].get("OutExpertResult");
	var ethicexpertinfo=rowObj[0].get("OutEthicResult");
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ���Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
///////////////////////Ժ��ר�����//////////////////////////////
var OutExpertInfoField = new Ext.form.TextArea({
		id : 'OutExpertInfoField',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : 'Ժ��ר����˽��',
		allowBlank :true,
		selectOnFocus:'true',
		value:expertinfo,
		emptyText : '����дԺ��ר����˽������'
	});
	///////////////////////Ժ������ר�����//////////////////////////////
var OutEthicExpertInfoField = new Ext.form.TextArea({
		id : 'OutEthicExpertInfoField',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : 'Ժ������ר����˽��',
		allowBlank :true,
		selectOnFocus:'true',
		value:ethicexpertinfo,
		emptyText : '����дԺ��ר����˽������'
	});		
var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.9',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
				                     OutExpertInfoField,
				                     OutEthicExpertInfoField
								]	 
							}]
					}
				]			
	// create form panel
  	var viewFormPanel = new Ext.form.FormPanel
  	({  	
   		labelWidth: 80,
		frame: true,
    	items: colItems
	});
	
	viewFormPanel.on('afterlayout', function(panel, layout)
	{
		this.getForm().loadRecord(rowObj[0]);
	});

  	// define window and show it in desktop
 	var viewWindow = new Ext.Window
 	({
  		title: 'Ժ��ר����˽��',
    	width: 500,
    	//height:430,
    	//layout: 'fit',
    	plain:true,
    	modal:true,
    	bodyStyle:'padding:5px;',
    	buttonAlign:'center',
    	items: viewFormPanel,
		buttons: [{		 
				text : '����',
				iconCls: 'save', 
				handler : function() {
				if (viewFormPanel.form.isValid()) {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var rowid = rowObj[0].get("rowid");

				var outexpert = OutExpertInfoField.getValue();
				var outethicexpert = OutEthicExpertInfoField.getValue();
					
				Ext.Ajax.request({
					url:'herp.srm.srmprosoliauditexe.csp?action=addoutexpertinfo&rowid='+encodeURIComponent(rowid)
					+'&outexpert='+encodeURIComponent(outexpert)+'&outethicexpert='+encodeURIComponent(outethicexpert),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({	params:{start:0, limit:25}});
						}
						else
						{	var message="�ظ����";
						/*
						    if(jsonData.info=='RecordExist') message="��¼�ظ�";
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepID') message="���֤�����ظ���";
							if(jsonData.info=='RepBirthDay') message="���ղ��ܴ��ڵ�ǰ���ڣ�";
						*/	
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  viewWindow.close();
				} 
				}					
			},
			{
				text: '�ر�',
				iconCls : 'cancel',
				handler : function() {
					viewWindow.close();
				}
			}]
    });
    viewWindow.show();
};
