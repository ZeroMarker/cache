var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
function InitWinControlEvent(obj){
	obj.intChartHeight = 350;
	obj.intChartWidth = 500;
	obj.arryData = null;
	obj.objDefaultColumnChartConfig = {
						Name : "Column3D",
						 //caption : '��Ժ����',
						  xAxisName : "����/����", 
						 //yAxisName : "��Ժ����" ,
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
			title : 'ͼ��Ԥ��',
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
		obj.winChartPreview.setTitle("ͼ��Ԥ��--" + objMnuConfig.text);
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
						'<th>����/��������</th>',
						'<th>��Ⱦ����</th>',
						'<th>��Ժ����</th>',
						'<th>��Ⱦ��</th>',
						'<th>ǧ����Ⱦ��</th>',
						'<th>�ξ�����</th>',
						'<th>������ʹ����</th>',
						'<th>�ͼ���</th>',
						'<th>������</th>',
						'<th>�ξ�סԺ��</th>',
						'<th>����������</th>',
						'<th>�������ظ�Ⱦ</th>',
						'<th>�����ùܸ�Ⱦ��</th>',
						'<th>������λ��Ⱦ��</th>',
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
			obj.RenderChart("chart1", "Column3D", "��Ⱦ����״ͼ", "", "DepName", "InfPercent");
			obj.RenderChart("chart2", "Column3D", "ǧ����Ⱦ����״ͼ", "", "DepName", "InfPercent1000");
			obj.RenderChart("chart3", "Column3D", "����ҩ��ʹ������״ͼ", "", "DepName", "Anti");
			obj.RenderChart("chart3", "Column3D", "�걾�ͼ�����״ͼ", "", "DepName", "SendLabs");
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