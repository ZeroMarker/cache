/**
 * @author Qse
 */
//alert(document.body);
//var fheight = document.body.offsetHeight;
//var fwidth = document.body.offsetWidth;
var fheight = document.body.clientHeight;
var fwidth = document.body.clientWidth;
var aa = "";

if ((CheckTyp == "SafeCheck")||(CheckTyp == "SafeSelfCheck")) {
	aa = cspRunServerMethod(GetSafetyCheck, CheckRoomId, CheckTyp,fwidth, fheight); 
}
if ((CheckTyp=="QualCheck")||(CheckTyp=="SpecCheck")||(CheckTyp=="QualSelfCheck")||(CheckTyp=="SpecSelfCheck")) {
	//alert("js");
	aa = cspRunServerMethod(GetQualCheck, CheckRoomId,CheckTyp, fwidth, fheight);
}
//alert(aa)
if (aa == ""){
	aa = cspRunServerMethod(GetTypQualItem, LocTyp, fwidth, fheight);
}
var ttab = new Ext.TabPanel({
	activeTab : 0,
	items : eval(aa)
})

Ext.onReady(function() {
	new Ext.form.FormPanel({
		height : fheight,
		width : fwidth,
		id : 'gform',
		// autoScroll:true,
		// layout: 'absolute',
		items : ttab,
		renderTo : Ext.getBody()
	});
});
var aaa=[{border: false,region: 'center', layout: 'fit', title: '医院药品管理核查表',height:704,html:'<iframe id ="southTab" name="ddd" style="width:100%;height:100%" src="dhcnuremrcomm.csp?EmrCode=DHCMGNurSafetyList&CheckCode=Qual20&CheckTitle=医院药品管理核查表" ></iframe>'},{border: false,region: 'center', layout: 'fit', title: '医院护理计划核查表',height:704,html:'<iframe id ="southTab" name="ddd" style="width:100%;height:100%" src="dhcnuremrcomm.csp?EmrCode=DHCMGNurSafetyList&CheckCode=Qual22&CheckTitle=医院护理计划核查表" ></iframe>'},{border: false,region: 'center', layout: 'fit', title: '医院围手术护理核查表',height:704,html:'<iframe id ="southTab" name="ddd" style="width:100%;height:100%" src="dhcnuremrcomm.csp?EmrCode=DHCMGNurSafetyList&CheckCode=Qual21&CheckTitle=医院围手术护理核查表" ></iframe>'}]