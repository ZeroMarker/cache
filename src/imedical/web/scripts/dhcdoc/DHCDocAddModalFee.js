Ext.onReady(function(){
	var lookup,tarInfo="";
	var genLookup  = function (){
		if(lookup&&lookup.store){
			lookup.doSearch([document.getElementById('windTarItemDesc').value,""]);
		}else{
			lookup  = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				resizeColumn:true,
				lookupPage: 'dhcdoc.ExecOrderNurse',
				lookupName: 'windTarItemDesc',
				listClassName: 'web.DHCIPBillInsExpItm',
				listQueryName: 'FindTariItem',
				displayField: 'TariDesc',
				listProperties: [document.getElementById('windTarItemDesc').value,""],
				listeners: {
					selectRow: function(str){
						tarInfo = str;														
					}
				}
			});
		}
	}
	var formPanel = new Ext.form.FormPanel({					
		title: '增加费用', 						
		labelAlign:'right',
		region:'center',
		frame:true,
		items: [{
			xtype:'textfield',id:'winqty',fieldLabel:'数量',width:200
		},{
			xtype:'textarea',id:'winCommit',fieldLabel:'原因',width:200
		},{
			xtype:'trigger',id: 'windTarItemDesc',fieldLabel:'收费项',triggerClass:'x-form-search-trigger',width:200,enableKeyEvents:true,
				onTriggerClick:genLookup,
				listeners: {
					specialkey: function(field, e){									
						if (e.getKey() == e.ENTER) {
							genLookup();
						}
					}
				}
			}
		],
		buttons: [{
				text:'增加',handler: function(t,e){																
					var qty = Ext.getCmp("winqty").getValue();
					if (!qty){Ext.Msg.alert("提示","没有写入数量"); return;} 
					if (!tarInfo){Ext.Msg.alert("提示","没有写入收费项目"); return;}
					var itemInfo = ( [qty].concat( tarInfo.split("^").splice(2,5) ) ).join("^")+"^B^"+Ext.getCmp("winCommit").getValue();															
					returnValue = {itemInfo:itemInfo};
					window.close();
				}
			},{ 
			text:'返回',handler: function(t,e){ window.close();}
		}]				
	});
	var view = new Ext.Viewport({
		layout:'border',
		items:[formPanel]
	});
})