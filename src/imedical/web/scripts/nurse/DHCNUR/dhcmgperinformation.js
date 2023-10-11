var fheight = document.body.offsetHeight;
var fwidth = document.body.offsetWidth;

var aa = "";
aa = cspRunServerMethod(GetPerLearningExperiences,RowId,PerName,PerID,fwidth, fheight);

var ttab = new Ext.TabPanel({
	renderTo: Ext.getBody(),
	activeTab : 0,
	width:fwidth,
	height:fheight,
	enableTabScroll:true,
	items : [eval(aa)]
})
Ext.onReady(function() {
	new Ext.form.FormPanel({
		height : fheight,
		width : fwidth,
		id : 'gform',
		layout: 'absolute',
		items : ttab,
		renderTo : Ext.getBody()
	});
});