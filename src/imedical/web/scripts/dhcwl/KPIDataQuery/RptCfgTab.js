(function(){
	Ext.ns("dhcwl.KDQ.DataQryCfg");
})();
//////////////////////////////////////////////////////////////////////
///描述: 		“配置报表”功能框架类，在这个类中加载交叉报表和明细报表
///编写者：		WZ
///编写日期: 	2017-6
//////////////////////////////////////////
dhcwl.KDQ.DataQryCfg=function(){
	var rptDimSelector=null;
	var serviceUrl="dhcwl/kpidataquery/rptcfg.csp";
	var outThis=this;

	var rptDetailCfgObj=new dhcwl.KDQ.RptDetailCfg(outThis);	//明细报表对象
	var rptDetailCfgPanel=rptDetailCfgObj.getRptDetailDataCfgPanel();
	var rptCrossCfgObj=new dhcwl.KDQ.RptCrossCfg(outThis);		//交叉报表对象
	var rptCrossCfgPanel=rptCrossCfgObj.getRptCrossCfgObjPanel();
	
	
	//tab页，items分别是明细和交叉报表的配置页面
	var rptCfgTabPanel = new Ext.TabPanel({
		activeTab: 0,
		tabPosition :'bottom',
		items: [rptDetailCfgPanel
		,rptCrossCfgPanel]
	});	

    var rptCfgPanel =new Ext.Panel({
		title:'配置报表',
		closable:true,
		layout:'border',	
		items:[{
			region:'center',
			//height:400,
			items:rptCfgTabPanel,
			layout:'fit'
		}]	
    });


    this.getRptCfgPanel=function(){
    	return rptCfgPanel;
    }       
}

