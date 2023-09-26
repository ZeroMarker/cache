(function(){
	Ext.ns("dhcwl.KDQ.CreateRptCfgInfo");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.CreateRptCfgInfo=function(createR){
	var createRpt=createR;
	var serviceUrl="dhcwl/kpidataquery/createrptcfginfo.csp";
	var outThis=this;
	var inParam;
	var filterStr="";
	var html = [];
	
	var createInfoPanel = new Ext.Panel({   
		layout:'fit'
	})

	this.loadMgmtData=function() {
		html.length=0;
		html.push('<p><b>配置信息汇总</b></p>');
		html.push('<hr>');
		html.push('<ul>');
		html.push('<li><strong>报表维度统计项:</strong> '+ createRpt.getRptDimDesc()   +'  </li>');
		html.push('<br>');
		html.push('<li><strong>报表度量统计项:</strong> '+ createRpt.getRptKPIDesc() +'  </li>');
		html.push('<br>');				
		
		html.push('<li><strong>查询项:</strong> '+ createRpt.getRptFilterItemDesc()   +'  </li>');	
		html.push('<br>');			
		html.push('<li><strong>过滤条件:</strong> '+ createRpt.getFilterText()   +'  </li>');
		html.push('<br>');
		
		
		html.push('</ul>');
		
		//createInfoPanel.removeAll(true);
		var component=createInfoPanel.get(0);
		if (!!component) createInfoPanel.remove(component);
		var templatePanel=new Ext.Panel({
			preventBodyReset: true,
			autoScroll : true,
			//width: 400,
			html: html.join('')
		});				
		
		createInfoPanel.add(templatePanel);
		createInfoPanel.doLayout();
	}	

	this.getCreateInfoPanel=function(){
		return createInfoPanel;
	}

}

