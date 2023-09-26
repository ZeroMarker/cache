(function(){
	Ext.ns("dhcwl.mkpi");
	/*
	//导入所需JS文件列表；
	dhcwl.mkpi.Util.importScript("../scripts/dhcwl/MaintainKpiDim.js");
	//导入所需JS文件列表；
	dhcwl.mkpi.Util.importScript("../scripts/dhcwl/ShowKpiWin.js");
	//导入纬度放大镜
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/MaintainDim.js");
    //导入指标类型放大镜
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/MaintainKpifl.js");
    //导入指标区间放大镜
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/MaintainSection.js");
    //导入指标任务区间维护程序
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/MaintainKpiTasks.js");
    //导入指标导入导出程序列表
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/KpiInput.js");
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/KpiOutput.js");
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/KpiIO.js");
    //导入指标数据预览程序
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/PreviewKpiData.js");
	//结束导入所需JS文件列表；
    //导入执行代码窗口文件
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/TaskExectCode.js");
     //导入执行代码窗口文件
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/util/XML.js");
    
    dhcwl.mkpi.Util.importScript("../scripts/dhcwl/MaintainDimProperty.js");
    */
})();
dhcwl.mkpi.MaintainKpis=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintainKpisMain',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        //width:1000,
        //heitht:800,
        items: [this.mainTabs]
    });
    
};
Ext.onReady(function(){
	dhcwl_mkpi_kpiDimTemplate=null;
	dhcwl_mkpi_kpiTaskTemplate=null;
	dhcwl_mkpi_dimPropertyWin=null;
	dhcwl_mkpi_executeCodeWin=null;
	dhcwl_mkpi_previewKpiData=null;
	dhcwl_mkpi_mantainKpiDim=null;
	dhcwl_mkpi_seDimPropertyWin=null;
	dhcwl_mkpi_maintain=new dhcwl.mkpi.MaintainKpis();
	dhcwl_mkpi_mantainKpiDim=new dhcwl.mkpi.MaintainKpiDim();
	dhcwl_mkpi_showKpiWin=new dhcwl.mkpi.ShowKpiWin();
	dhcwl_mkpi_taskWin=new dhcwl.mkpi.MaintainKpiTasks();
	dhcwl_mkpi_taskIO=new dhcwl.mkpi.KpiIO();
	//dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.PreviewKpiData();
	dhcwl_mkpi_maintain.mainTabs.add(dhcwl_mkpi_showKpiWin.getKpiShowWin());
	dhcwl_mkpi_maintain.mainTabs.add(dhcwl_mkpi_taskWin.getTaskPanel());
	dhcwl_mkpi_maintain.mainTabs.add(dhcwl_mkpi_taskIO.getIOPanel());
	dhcwl_mkpi_maintain.mainTabs.add(new dhcwl.mkpi.MaintainSection().getSectionPanel());
	dhcwl_mkpi_maintain.mainTabs.add(new dhcwl.mkpi.MaintainKpifl().getKpiflPanel());
	dhcwl_mkpi_maintain.mainTabs.add(new dhcwl.mkpi.MaintainDim().getDimPanel());
	
	dhcwl_mkpi_maintain.mainTabs.add(new dhcwl.mkpi.KpiModeManager().getModeManagerPanel());
	dhcwl_mkpi_maintain.mainTabs.add(new dhcwl.mkpi.ShowKpiLoginInfo().getKpiLoginInfoPanel());
	dhcwl_mkpi_maintain.mainTabs.add(new dhcwl.mkpi.KpiLoginInfoCfg().getKpiLoginInfoCfgPanel());

	dhcwl_mkpi_maintain.mainTabs.setActiveTab(0);
	dhcwl_mkpi_maintain.mainTabs.setActiveTab(1);
	dhcwl_mkpi_maintain.mainTabs.setActiveTab(2);
	dhcwl_mkpi_maintain.mainTabs.setActiveTab(0);
	
});