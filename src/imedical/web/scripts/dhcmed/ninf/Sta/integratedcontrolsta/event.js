var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
function InitWinControlEvent(obj){
	obj.intChartHeight = 350;
	obj.intChartWidth = 500;
	obj.arryData = null;
	obj.objDefaultColumnChartConfig = {
						Name : "Column3D",
						 //caption : '出院人数',
						  xAxisName : "科室/病区", 
						 //yAxisName : "出院人数" ,
						 // ChartID : 'firstChart',
						  Width : obj.intChartWidth,
						  Height : obj.intChartHeight,
						 // Target : 'chart1',
						  decimalPrecision : '0'
			};
	
	
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.radioDepTypeD.fireEvent("check");
		obj.btnQuery_click();
	}
	
	obj.radioDepTypeD.on("check", 
		function(){
			if(obj.radioDepTypeD.getValue())
			{
				obj.cboWard.disable();
				obj.cboWard.clearValue();
				obj.cboLoc.enable();
			}
			else
			{
			obj.cboLoc.disable();
			obj.cboLoc.clearValue();
			obj.cboWard.enable();			
			}
		}
	, obj);
	
	obj.btnQuery_click = function()
	{
		var objIFrame = document.getElementById("iframeResult");
		var strUrl = "./dhccpmrunqianreport.csp?reportName=DHCMed.NINF.CC.ControlSta.raq " +
			"&FromDate=" + obj.dfDateFrom.getRawValue() +
			"&ToDate=" + obj.dfDateTo.getRawValue() +
			"&LocList=" + obj.cboLoc.getValue() +
			"&WardList=" + obj.cboWard.getValue();
			if(obj.radioAdmitDate.getValue())
				strUrl += "&DateType=1";
			if(obj.radioDisDate.getValue())
				strUrl += "&DateType=2";
			if(obj.radioInHospital.getValue())
				strUrl += "&DateType=3";				
			if(obj.radioDepTypeD.getValue())
				strUrl += "&DepType=1";
			if(obj.radioDepTypeW.getValue())
				strUrl += "&DepType=2";	
		objIFrame.src = strUrl;
	}
	
	/*
	obj.mnuChartType_show = function(){
		obj.winChartPreview = new Ext.Window({
			title : '图表预览',
			html : '<div id="chartPreview" />',
			height : 370,
			width : 720,
			closable : false
		});
		Ext.getCmp("pnChartArea").collapse(true);
	}
	obj.mnuChartType_hide = function(){
		obj.winChartPreview.close();
		obj.winChartPreview.destroy(true);
	}	
	
	
	obj.mnuChartType_mouseover = function(objMenu, objEvent, objMenuItem){
		if(objMenuItem == null)
			return;
		var objMnuConfig = objMenuItem.initialConfig;
		var objChartConfig = obj.objDefaultColumnChartConfig;
		objChartConfig.Target = "chartPreview";
		objChartConfig.ChartID = "chartPreview";
		objChartConfig.caption = objMnuConfig.text;
		objChartConfig.yAxisName = objMnuConfig.yAxisName;
		var objDataConfig = {
			NameField : objMnuConfig.NameField,
			ValueField : objMnuConfig.ValueField
		}
				obj.winChartPreview.show();
		ChartTool.CreateChartFromData(objChartConfig, objDataConfig, obj.arryData);
		obj.winChartPreview.setTitle("图表预览--" + objMnuConfig.text);
	}
	
	obj.mnuChartType_click = function(objMenu, objMenuItem, objEvent){
		if(objMenuItem == null)
			return;
		var objMnuConfig = objMenuItem.initialConfig;
		var objChartConfig = obj.objDefaultColumnChartConfig;
		objChartConfig.Target = "chartArea";
		objChartConfig.ChartID = "chartArea";
		objChartConfig.caption = objMnuConfig.text;
		objChartConfig.yAxisName = objMnuConfig.yAxisName;
		var objDataConfig = {
			NameField : objMnuConfig.NameField,
			ValueField : objMnuConfig.ValueField
		}
		Ext.getCmp("pnChartArea").expand(true);
		Ext.getCmp("pnChartArea").setTitle(objMnuConfig.text);
		obj.winChartPreview.show();
		ChartTool.CreateChartFromData(objChartConfig, objDataConfig, obj.arryData);
	}	
	
	
	obj.displaySummaryInfo = function(arryResult)
		{
			obj.arryData = arryResult;
		
			var objTpl = new Ext.XTemplate(
				'<table>',
					'<tr>',
						'<th>科室/病房名称</th>',
						'<th>感染人数</th>',
						'<th>出院人数</th>',
						'<th>感染率</th>',
						'<th>千床感染率</th>',
						'<th>次均费用</th>',
						'<th>抗生素使用率</th>',
						'<th>送检率</th>',
						'<th>阳性率</th>',
						'<th>次均住院日</th>',
						'<th>呼吸机肺炎</th>',
						'<th>导尿管相关感染</th>',
						'<th>静脉置管感染率</th>',
						'<th>手术部位感染率</th>',
					'</tr>',
					'<tpl for=".">',
						'<tr>',
							'<td>{DepName}</td>',
							'<td>{InfNumber}</td>',
							'<td>{DisNumber}</td>',
							'<td>{InfPercent}</td>',
							'<td>{InfPercent1000}</td>',
							'<td>{Fee}</td>',
							'<td>{Anti}</td>',
							'<td>{SendLabs}</td>',
							'<td>{Bacteria}</td>',
							'<td>{AvgDays}</td>',
							'<td>{Ventilator}</td>',
							'<td>{Catheter}</td>',
							'<td>{VenousCatheter}</td>',
							'<td>{OpePos}</td>',
						'</tr>',						
					'</tpl>',
				'</table>',
				'<br/>',
				'<div id="chart1">chart1</div>',
				'<br/>',
				'<div id="chart2">chart2</div>',
				'<br/>',
				'<div id="chart3">chart3</div>',
				'<br/>',
				'<div id="chart3">chart4</div>',
				'<br/>'
			);
			objTpl.overwrite(obj.pnDisplay.body, arryResult);
			obj.RenderChart("chart1", "Column3D", "感染率柱状图", "", "DepName", "InfPercent");
			obj.RenderChart("chart2", "Column3D", "千床感染率柱状图", "", "DepName", "InfPercent1000");
			obj.RenderChart("chart3", "Column3D", "抗菌药物使用率柱状图", "", "DepName", "Anti");
			obj.RenderChart("chart3", "Column3D", "标本送检率柱状图", "", "DepName", "SendLabs");
		}
	
	obj.RenderChart = function(ChartID, ChartName, Caption, yAxisName, NameField, ValueField)
	{
		var objChartConfig = new Object();
		objChartConfig.Target = ChartID;
		objChartConfig.ChartID = ChartID;
		objChartConfig.caption = Caption;
		objChartConfig.yAxisName = yAxisName;
		objChartConfig.Width = obj.intChartWidth;
		objChartConfig.Height = obj.intChartHeight;
		objChartConfig.decimalPrecision = '0';
		objChartConfig.Name = ChartName;
		
		var objDataConfig = new Object();
		objDataConfig.NameField = NameField;
		objDataConfig.ValueField = ValueField;
		ChartTool.CreateChartFromData(objChartConfig, objDataConfig, obj.arryData);		
	}
	
	obj.btnQuery_click = function(){
		var param = new Object();
		param.ClassName = 'DHCMed.CCService.IntegratedCtrl.INFControlSta';
		param.QueryName = 'StaByDate';
		param.Arg1 = obj.dfDateFrom.getRawValue();
		param.Arg2 = obj.dfDateTo.getRawValue();
		if(obj.radioAdmitDate.getValue())
			param.Arg3 = 1;
		if(obj.radioDisDate.getValue())
			param.Arg3 = 2;
		if(obj.radioInHospital.getValue())
			param.Arg3 = 3;			
		param.Arg4 = obj.cboLoc.getValue();
		param.Arg5 = obj.cboWard.getValue();		
		param.Arg6 = (obj.radioDepTypeD.getValue() ? 1 : 2);		
		param.ArgCnt = 6;
		ChartTool.RunQuery(param, obj.displaySummaryInfo, obj);		
		//obj.gridResultStore.load({});

	}
	*/
}