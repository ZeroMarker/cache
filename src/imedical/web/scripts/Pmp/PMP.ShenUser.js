//PMP.ShenUser.js
//����б�����ý���
//20150326
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var name=session['LOGON.USERNAME']
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    ChartInfoAddFun();
    function ChartInfoAddFun() {
	    var myPanel=new Ext.TabPanel({
				renderTo:Ext.getBody(),
				title:"������б�����",
				width:1000,
				height:400
	    })
	    
	    }
	   
})
