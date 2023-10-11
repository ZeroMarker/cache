/**
 * @author Qse
 */
var fheight=document.body.offsetHeight;
var fwidth=document.body.offsetWidth;
//alert(122)
var ord1url="DHCNurEmrComm.csp?EmrCode=DHCNURXHSBList_pf&EpisodeID="+EpisodeID;
var ord1ur2="DHCNurEmrComm.csp?EmrCode=DHCNURXHSBList_geiyao&EpisodeID="+EpisodeID;
var ord1ur3="DHCNurEmrComm.csp?EmrCode=DHCNURXHSBList_glhuatuo&EpisodeID="+EpisodeID;
var ord1ur5="DHCNurEmrComm.csp?EmrCode=DHCNURXHSBList_ywsh&EpisodeID="+EpisodeID;
var ord1ur6="DHCNurEmrComm.csp?EmrCode=DHCNURXHSBList_dulou&EpisodeID="+EpisodeID;
var ord1ur7="DHCNurEmrComm.csp?EmrCode=DHCNURXHSBList_syfy&EpisodeID="+EpisodeID;

var ttab = new Ext.TabPanel({
	activeTab:0,
	
	items: [{
    border: false,region: 'center', layout: 'fit', 		title: "皮肤压疮护理报告单",height:fheight,
width: fwidth,
		//html:'<iframe id="Attentiontab" marginheight="0" marginwidth="0" height="100%" width="100%",src='+ord1url+'></iframe>'
		html:'<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src='+ord1url+' ></iframe>'
         },
         {
    border: false,region: 'center', layout: 'fit', title: "护理给药缺陷报告单",
	  height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1ur2+' ></iframe>'
         }
        ,
         {
    border: false,region: 'center', layout: 'fit', title: "管路滑脱报告单",
	height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1ur3+' ></iframe>'
         }
        ,
        {
    border: false,region: 'center', layout: 'fit', title: "意外伤害事件报告单",
	height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1ur5+' ></iframe>'
         },  
        {
    border: false,region: 'center', layout: 'fit', title: "医疗护理风险防范(堵漏)报告表",
	height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1ur6+' ></iframe>'
         }   
        ,
        {
    border: false,region: 'center', layout: 'fit', title: "输液(血)反应报告单",
	height:fheight,
    width: fwidth,
		html:'<iframe id ="southTab1" name="ddd1" style="width:100%; height:100%" src='+ord1ur7+' ></iframe>'
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


