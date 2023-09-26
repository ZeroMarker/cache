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
		title: '请填写或选择原因', 						
		labelAlign:'right',
		region:'center',
		frame:true,
		
		items: [
		{
			xtype:'trigger',id: 'reasonDesc',fieldLabel:'填写或选择原因',width:250,enableKeyEvents: true,
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
				text:'确定',iconCls:'icon-ok-custom',handler: function(t,e){
					var id = tarInfo.split("^")[0];					
					var reasonDesc = Ext.getCmp("reasonDesc").getValue();
					if(reasonDesc == ""){Ext.Msg.alert("没有填写原因!"); return ;}
					returnValue = {reasonId: id,comment: reasonDesc};
					window.close();
				}
			},{ 
			text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ window.close();}
		}]				
	});
	var view = new Ext.Viewport({
		layout:'border',
		items:[formPanel]
	});
})