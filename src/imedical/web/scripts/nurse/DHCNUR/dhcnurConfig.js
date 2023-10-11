/**
 * @author Qse
 */
var fheight=document.body.offsetHeight;
var fwidth=document.body.offsetWidth;

var ord1url="DHCNurEmrComm.csp?EmrCode=DHCNURBG_NurEmrConfig&EpisodeID="+EpisodeID;
var ord1ur2="DHCNurEmrComm.csp?EmrCode=DHCNURPGD_LockSub&EpisodeID="+EpisodeID;
var ord1ur3="DHCNurEmrComm.csp?EmrCode=DHCNURPGD_switch&EpisodeID="+EpisodeID;

var ttab = new Ext.TabPanel({
	activeTab:0,
	
	items: [{
    border: false,region: 'center', layout: 'fit', 		title: "出入液量统计时间设置",height:fheight,
width: fwidth,
		//html:'<iframe id="Attentiontab" marginheight="0" marginwidth="0" height="100%" width="100%",src='+ord1url+'></iframe>'
		html:'<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src='+ord1url+' ></iframe>'
         },
         {
    border: false,region: 'center', layout: 'fit', title: "解模板异常锁",
	  height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1ur2+' ></iframe>'
         },
         {
    border: false,region: 'center', layout: 'fit', title: "更新开关",
	  height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab2" name="ddd2" style="width:100%; height:100%" src='+ord1ur3+' ></iframe>'
         }
          ]
       }
)
Ext.onReady(function(){ 
 new Ext.form.FormPanel({
height:fheight,
width: fwidth,
id:'gform',
//autoScroll:true,
//layout: 'absolute',
items:ttab,
renderTo: Ext.getBody()
});


});


