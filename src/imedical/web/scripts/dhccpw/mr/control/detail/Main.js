//�����ߣ�����
//����ʱ�䣺2010-12-11
//�ٴ�·��ά�����������
var objScreenViewPort = null;
var isAdmin = false;
var objMain = null;
Ext.onReady(
	function () {     //����ִ���������
	    var obj = new Object();
	    objMain = obj;
	    obj.objLeftPane = new LeftMaintainPane();
	    obj.objPnFee = new Ext.Panel(
	    	{
	    		title:'סԺ����',
	    		html:'<iframe src="./dhccpw.mr.controldetailfee.csp?Adm=' + document.getElementById("Adm").value + '" width="100%" height="100%" />'
	    	}
	    )
	    //-------------------------�ٴ�·����---------------------------
	    obj.pnCpwForm = new Ext.Panel({
	    		title:'�ٴ�·����',
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