//创建者：李阳
//创建时间：2010-12-11
//临床路径维护主界面程序
var objScreenViewPort = null;
var isAdmin = false;
var objMain = null;
Ext.onReady(
	function () {     //最先执行这个方法
	    var obj = new Object();
	    objMain = obj;
	    obj.objLeftPane = new LeftMaintainPane();
	    obj.objPnFee = new Ext.Panel(
	    	{
	    		title:'住院费用',
	    		html:'<iframe src="./dhccpw.mr.controldetailfee.csp?Adm=' + document.getElementById("Adm").value + '" width="100%" height="100%" />'
	    	}
	    )
	    //-------------------------临床路径表单---------------------------
	    obj.pnCpwForm = new Ext.Panel({
	    		title:'临床路径表单',
	    		layout: 'fit',
	    		html:'<iframe src="./dhccpw.mr.formshow.csp?EpisodeID=&PathWayID=' + document.getElementById("PathWayID").value + '&NewPage=0" width="100%" height="100%" />'
	    })
		//-----------------------------------------------------------------
	    var objMainPane = new Ext.TabPanel({
	    	id : "cpwMainTab"
	        ,title: "Main Window"
            , region: "center"
            , activeTab: 0
            , items:
            [
            	obj.pnCpwForm,
            	obj.objLeftPane,
            	obj.objPnFee
            ]
        });
	    objScreenViewPort = new Ext.Viewport({
	        layout: 'fit',
	        items: [
                objMainPane
			 ]
	    });
	}
);