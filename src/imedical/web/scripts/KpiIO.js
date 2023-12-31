(function(){
	Ext.ns("dhcwl.mkpi.KpiIO");
})();
dhcwl.mkpi.KpiIO=function(){
	var outputPanel=null,inputPanel=null;
	var outputObj=null,inputObj=null;
	outputObj=new dhcwl.mkpi.KpiOutput();
	inputObj=new dhcwl.mkpi.KpiInput();
	outputPanel=outputObj.getOutputPanel();
	inputPanel=inputObj.getInputPanel();
	var kpiIOPanel=new Ext.Panel({
    	//layout:'table',
    	title:'指标导入和导出',
    	layout:'table',
        layoutConfig: {columns:2},
        items: [{
        	width:500,
        	height:800,
        	autoScroll:true,
            items:outputPanel
        },{
        	autoScroll:true,
        	width:620,
        	height:800,
            items:inputPanel
    	}]
    });
	/*
	var kpiIOPanel=new Ext.Panel({
    	layout:'accordion',
    	margins:'5 5',
    	title:'指标导入和导出',
    	layoutConfig: {
        	titleCollapse: false,
        	animate: true,
        	activeOnTop: true
    	},
        items: [outputPanel, inputPanel]
    });
    */
    this.getIOPanel=function(){
    	return kpiIOPanel;
    }
    this.getInputObj=function(){
    	return inputObj;
    }
    this.getOutputObj=function(){
    	return outputObj;
    }
}