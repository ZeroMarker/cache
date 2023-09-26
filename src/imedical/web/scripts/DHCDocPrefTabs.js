//DHCDocPrefTabs.js
var tabsGridPanel,lookup,objRefValue;
var genLookup  = function (){
	if(lookup&&lookup.store){
		lookup.doSearch([Ext.getCmp("objtype").getValue(),Ext.getCmp("objvalue").getValue()]);
	}else{
		lookup  = new dhcc.icare.Lookup({
			lookupListComponetId: 1872,			
			lookupName: 'objvalue',
			listClassName: 'web.DHCDocPrefTabs',
			listQueryName: 'FindObjValue',
			displayField: 'objValue',
			listProperties: [Ext.getCmp("objtype").getValue(),Ext.getCmp("objvalue").getValue()],
			listeners: {
				selectRow:function(str){					
					var tmpList=str.split("^");					
					objRefValue = tmpList[2];
				}
			}
		});
	}
}
var init = function(){
	tabsGridPanel = new dhcc.icare.MixGridPanel({
		title: "模版",
		viewConfig: {
			forceFit: true
		},
		listClassName: 'web.DHCDocPrefTabs',
		listQueryName: 'FindPrefTabs',
		columnModelFieldJson: CMFJson || "",
		region: 'center',
		split:true,
		pageSize:30,		
		tbar:[
			'类型',{
				xtype:'combo',
				id:'objtype',
				mode:'local',
				value:"User.SSUser",
				store: new Ext.data.ArrayStore({
					data:objTypeJson,
					fields:['desc','code']
				}),			
				triggerAction: 'all',
				displayField: 'desc',
				valueField: 'code',
				allowBlank:false,
				listeners: {
					 select:function(combo,record,value){
						 Ext.getCmp("objvalue").setValue('');
						 objRefValue="";
					 }
				}				
			},
			'值', {xtype:'trigger',id:'objvalue',triggerClass:'x-form-search-trigger',enableKeyEvents:true,
				listeners: {
					specialkey: function(field, e){									
						if (e.getKey() == e.ENTER) {
							genLookup();
						}
					}
				},
			onTriggerClick:genLookup},			
			{
				text:'查询',handler:function(){
					var objType=Ext.getCmp("objtype").getValue();
					if ((objType=="")||(objRefValue=="")||(objRefValue==undefined)){
						alert("请选择完整的查询条件!");
						return false;
					}
					var store = tabsGridPanel.store;
					store.baseParams.P1 = objType; //Ext.getCmp("objtype").getValue();					
					store.baseParams.P2 = objRefValue;
					store.load();
			}}
		]
	});
	var vp = new Ext.Viewport({
		layout:'border',
		items:[tabsGridPanel]
	});
}
Ext.onReady(init);