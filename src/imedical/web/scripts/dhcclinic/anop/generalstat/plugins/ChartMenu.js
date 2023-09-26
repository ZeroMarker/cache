function InitChartMenu(obj)
{
	obj.statLegendMenu.addItem({
		text : "饼状图",
		id : "pieChartMenuItem",
		iconCls:'icon-chart_pie',
		handler:ShowPieChart
	});
	obj.statLegendMenu.addItem({
		text : "柱形图",
		id : "barChartMenuItem",
		iconCls:'icon-chart_bar',
		handler:ShowBarChart
	});
	obj.statLegendMenu.addItem({
		text : "折线图",
		id : "lineChartMenuItem",
		iconCls:'icon-chart_line',
		handler:ShowLineChart
	});
	obj.statLegendMenu.addItem({
		text : "时间序列图",
		id : "timeLineChartMenuItem",
		iconCls:'icon-chart_line_link',
		handler:ShowTimeLineChart
	});
	obj.statLegendMenu.addItem({
		text : "同比环比图",
		id : "ratioChartMenuItem",
		iconCls:'icon-chart_line_link',
		handler:ShowRatioChart
	});
	obj.statLegendMenu.doLayout();

	//饼状图
	function ShowPieChart()
	{
		if(!obj.CheckSelectInquiry()) return;
		var anciDesc = obj.comInquiry.getRawValue();
		var lnk = "dhcclinic.anop.piechartshow.csp?anciId="+obj.anciId+"&title="+escape("手术综合查询: "+anciDesc);
		window.open(lnk,"","height=650,width=1100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	//柱形图
	function ShowBarChart()
	{
		if(!obj.CheckSelectInquiry()) return;
		var anciDesc = obj.comInquiry.getRawValue();
		var lnk = "dhcclinic.anop.barchartshow.csp?anciId="+obj.anciId+"&title="+escape("手术综合查询: "+anciDesc);
		window.open(lnk,"","height=650,width=1100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	//折线图
	function ShowLineChart()
	{
		if(!obj.CheckSelectInquiry()) return;
		var anciDesc = obj.comInquiry.getRawValue();
		var lnk = "dhcclinic.anop.linechartshow.csp?anciId="+obj.anciId+"&title="+escape("手术综合查询: "+anciDesc);
		window.open(lnk,"","height=650,width=1100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	//时间序列图
	function ShowTimeLineChart()
	{
		if(!obj.CheckSelectInquiry()) return;
		var index = obj.comInquiryStore.indexOfId(obj.anciId);
		var record = obj.comInquiryStore.getAt(index);
		if(record && !Number(record.get("IfStartStoreTimeLine")))
		{
			alert("此查询项未储存时间序列数据!");
			return;
		}
		var anciDesc =  obj.comInquiry.getRawValue();
		var lnk = "dhcclinic.anop.timelinechartshow.csp?anciId="+obj.anciId+"&title="+escape("手术综合查询: "+anciDesc);
		window.open(lnk,"","height=650,width=1150,left="+((window.screen.width-10-1100)/2)+",toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	//环比图
	function ShowRatioChart()
	{
		if(!obj.CheckSelectInquiry()) return;
		var index = obj.comInquiryStore.indexOfId(obj.anciId);
		var record = obj.comInquiryStore.getAt(index);
		if(record && !Number(record.get("IfStartStoreTimeLine")))
		{
			alert("此查询项未储存时间序列数据!");
			return;
		}
		var anciDesc =  obj.comInquiry.getRawValue();
		var lnk = "dhcclinic.anop.ratiochartshow.csp?anciId="+obj.anciId;
		window.open(lnk,"","height=650,width=1150,left="+((window.screen.width-10-1100)/2)+",toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
	}
}