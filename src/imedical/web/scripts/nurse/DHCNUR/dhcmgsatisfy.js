/**
 * @author Qse
 */
var ord1url="dhcnuremrcomm.csp?EmrCode=DHCNURPatientList&CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
var ord1ur2="dhcnuremrcomm.csp?EmrCode=DHCMGNurSatistyList&CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
var ttab = new Ext.TabPanel({
	activeTab:0,
	items: [{
    border: false,region: 'center', layout: 'fit', 		title: "满意度",height:900,
    width: 900,
		//html:'<iframe id="Attentiontab" marginheight="0" marginwidth="0" height="100%" width="100%",src='+ord1url+'></iframe>'
		html:'<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src='+ord1ur2+' ></iframe>'
         },
        {
    border: false,region: 'center', layout: 'fit', title: "病人查询",
	height:900,
    width: 900,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1url+' ></iframe>'
         }
             ]
       }
)
Ext.onReady(function(){ 
 new Ext.form.FormPanel({
height:900,
width: 900,
id:'gform',
//autoScroll:true,
//layout: 'absolute',
items:ttab,
renderTo: Ext.getBody()
});


});


