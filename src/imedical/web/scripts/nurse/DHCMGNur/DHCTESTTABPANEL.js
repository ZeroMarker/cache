/**
 * @author Qse
 */
var attenitm=new Array();
add("a1","a2");
var subttab=new Ext.TabPanel({
	activeTab : 0,//
   autoTabs: true,
         frame:true,
   // resizeTabs:true,  
             height:1000,
             width:800,
			  enableTabScroll:true,
 	items:attenitm
});


Ext.onReady(function(){ 
new Ext.Viewport({
	enableTabScroll:true,
	items:subttab
})

});
function add(a1, a2){
	for( i=0;i<20;i++)
	{attenitm.push({
		xtype:'panel',
		id: "p1"+i,
		title: "xxxp2"+i,
		region:'center',
		height:1000,
		layout:'fit',
		//closable:true,
		html:"nnnnnnnnnnnnnnnnnnnnnnn"
	})
	}
	
}