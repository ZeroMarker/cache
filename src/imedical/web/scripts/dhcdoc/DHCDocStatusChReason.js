Ext.onReady(function(){
	var lookup,tarInfo="";
	var genLookup = function(){
		if(lookup&&lookup.store){
			lookup.doSearch([document.getElementById('reasonDesc').value,""]);
		}else{
			lookup  = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: 'dhcdoc.DHCDocStatusChReason',
				lookupName: 'reasonDesc',
				listClassName: 'web.DHCDocMain',
				listQueryName: 'FindOECStatusChReason',
				displayField: 'ASCRDesc',
				listProperties: [document.getElementById('reasonDesc').value,""],
				listeners:{
					selectRow: function(str){
						tarInfo = str;												
					}
				}
			});
		}
	}
	var formPanel = new Ext.form.FormPanel({					
		title: '����д��ѡ��ԭ��', 						
		labelAlign:'right',
		region:'center',
		frame:true,
		
		items: [
		{
			xtype:'trigger',id: 'reasonDesc',fieldLabel:'��д��ѡ��ԭ��',width:250,enableKeyEvents: true,
			labelStyle: 'width:200;',
			onTriggerClick:genLookup,
			triggerClass:'x-form-search-trigger',
			listeners: {
				specialkey: function(field, e){									
					if (e.getKey() == e.ENTER) {
						genLookup();
					}
				}
			}
		}],
		buttons: [{
				text:'ȷ��',iconCls:'icon-ok-custom',handler: function(t,e){
					var id = tarInfo.split("^")[0];					
					var reasonDesc = Ext.getCmp("reasonDesc").getValue();
					if(reasonDesc == ""){Ext.Msg.alert("û����дԭ��!"); return ;}
					returnValue = {reasonId: id,comment: reasonDesc};
					window.close();
				}
			},{ 
			text:'����',iconCls:'icon-undo-custom',handler: function(t,e){ window.close();}
		}]				
	});
	var view = new Ext.Viewport({
		layout:'border',
		items:[formPanel]
	});
})