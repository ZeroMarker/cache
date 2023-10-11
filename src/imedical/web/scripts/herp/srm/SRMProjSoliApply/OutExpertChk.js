OutExpertChk = function(rowid,OutExpertResult,EthicChkResult)
{
	if((rowid < 1)||(rowid=""))
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��Ҫ�鿴����Ŀ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		value:OutExpertResult,
		//emptyText : '����дԺ��ר����˽������',
		labelSeparator:''
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
		value:EthicChkResult,
		//emptyText : '����дԺ��ר����˽������',
		labelSeparator:''
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
		//this.getForm().loadRecord(rowObj[0]);
	});

  	// define window and show it in desktop
 	var viewWindow = new Ext.Window
 	({
  		title: 'Ժ��ר����˽���б�',
  		iconCls : 'popup_list',
		width:380,
    	//height:400,
    	//layout: 'fit',
    	plain:true,
    	modal:true,
    	bodyStyle:'padding:5px;',
    	buttonAlign:'center',
    	items: viewFormPanel,
		buttons: [
			{
				text : '�ر�',
				iconCls : 'cancel',
				handler : function() {
					viewWindow.close();
				}
			}]
    });
    viewWindow.show();
};
