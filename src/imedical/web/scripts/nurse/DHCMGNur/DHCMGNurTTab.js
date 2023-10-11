/**
 * @author Qse
 */
var ttab = new Ext.TabPanel({
	items: [{
  border: false,region: 'center', layout: 'fit', 		title: "关注信息",
		html:'<iframe id="Attentiontab" marginheight="0" marginwidth="0" height="100%" width="100%",src="dhcmgwardattenion.csp?Ward='+WardTree+'"></iframe>'
}
]
}
)


Ext.onReady(function(){ 
new Ext.Viewport({
	items:ttab
})

});


