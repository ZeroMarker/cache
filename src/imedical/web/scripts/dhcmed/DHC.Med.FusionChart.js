
/*
1��Query��ѡ��
����ϵ�е�ͼ��
QueryInfo.ClassName   ����Query��������
QueryInfo.QueryName   Query������
QueryInfo.NameField   ����ͼ���ǩֵ������
QueryInfo.ValueField  ����ͼ������ֵ������


��ϵ�е�ͼ��
QueryInfo.ClassName   ����Query��������
QueryInfo.QueryName   Query������
QueryInfo.CategoryFieldName  ������������
QueryInfo.SeriesFieldName    ����ϵ�����Ƶ�����

2��ͼ���ѡ��
ChartInfo.Target       ͼ����Ƶ�λ�ã�Ӧ����ĳ��DIV��ǩ��IDֵ
ChartInfo.ChartType    ͼ�����𣬿����������ֵ���ı����ǵü�����Ŷ~~��
Area2D
Bar2D
Candlestick
Column2D
Column3D
Doughnut2D
Funnel
Gantt
Line
MSArea2D
MSBar2D
MSColumn2D
MSColumn2DLineDY
MSColumn3D
MSColumn3DLineDY
MSLine
Pie2D
Pie3D
StackedArea2D
StackedBar2D
StackedColumn2D
StackedColumn3D


*/

var ChartTool = new Object();

//FusionChart�Ĵ��·����
ChartTool.FlashPath = "../scripts_lib/FusionChartsFree/Charts"; 

//��ɫ��
ChartTool.ColorArray = ['AFD8F8','F6BD0F','8BBA00','FF8E46','008E8E','D64646','8E468E','588526','B3AA00','008ED6','9D080D','A186BE','0000FF','DEB887','D2691E','DC143C','008B8B','00CED1','FF1493','90EE90','FFA07A','00FF00','FF00FF','FF4500','CD853F','4169E1','FFFF00','EE82EE','C0C0C0','F4A460'];

//��������ϵ��ͼ��
ChartTool.CreateChart = function(ChartInfo, QueryInfo)
{
	ChartTool.RunQuery(QueryInfo, 
		function(objData)
		{
			for(var i = 0; i < objData.length; i ++)
			{
				if((objData[i].color == null) || (objData[i].color == ""))
				{
					objData[i].color = ChartTool.ColorArray[i % ChartTool.ColorArray.length];
				}
			}
			var strXML = ConvertXMLSingleSeries(ChartInfo, QueryInfo, objData);
			var strFlashFileName = "FCF_" + ChartInfo.ChartType + ".swf";
			var chart = new FusionCharts(ChartTool.FlashPath + "/" + strFlashFileName, ChartInfo.ChartID, ChartInfo.Width, ChartInfo.Height);
			chart.setDataXML(strXML);
			chart.render(ChartInfo.Target);
			
		},
		null
	);
	
	
}

//����Query
ChartTool.RunQuery = function(QueryInfo, callback, objScope)
{
	var arryArgs = new Array();
	var params = new Object();
	params.ClassName = QueryInfo.ClassName;
	params.QueryName = QueryInfo.QueryName;
	for(var i = 0; i < QueryInfo.ArgCnt ; i ++)
	{
		params["Arg" + (i + 1)] = QueryInfo["Arg" + (i + 1)];
	}
	params.ArgCnt = QueryInfo.ArgCnt;
	Ext.Ajax.request({   
		params : params,
		url: ExtToolSetting.RunQueryPageURL,
	    success: function(response, params) {
		  var obj = Ext.decode(response.responseText);
		  
		  var arryResult = new Array();
		  for(var i = 0; i < obj.total; i ++)
		  {
			arryResult[arryResult.length] = obj.record[i];
		  }
		  callback.call(objScope, arryResult);
		},
	    failure: function(response, params) {
		  ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	});	


}


//������ϵ��ͼ��XML����
ChartTool.CreateMultiSeriesChart = function(ChartInfo, QueryInfo)
{
	ChartTool.RunQuery(QueryInfo, 
		function(objData)
		{
			for(var i = 0; i < objData.length; i ++)
			{
				if((objData[i].color == null) || (objData[i].color == ""))
				{
					objData[i].color = ChartTool.ColorArray[i % ChartTool.ColorArray.length];
				}
			}
			var strXML = ConvertXMLMultiSeries(ChartInfo, QueryInfo, objData);
			//return;
			var strFlashFileName = "FCF_" + ChartInfo.ChartType + ".swf"; //Modified By LiYang 2012-12-10
			var chart = new FusionCharts(ChartTool.FlashPath + "/" + strFlashFileName, ChartInfo.ChartID, ChartInfo.Width, ChartInfo.Height);
			chart.setDataXML(strXML);
			chart.render(ChartInfo.Target); //Modified By LiYang 2012-12-10
			
			
			//window.alert(ConvertXMLSingleSeries(ChartInfo, QueryInfo, objData));
		},
		null
	);
}

ChartTool.CreateChartFromData = function(objChartConfig, objDataConfig, ArryData)
{
	var strXML = ConvertXMLSingleSeries(objChartConfig, objDataConfig, ArryData);
	var strFlashFileName = "FCF_" + objChartConfig.ChartType + ".swf";
	var objChart = new FusionCharts(ChartTool.FlashPath + "/" + strFlashFileName, objChartConfig.ChartID, objChartConfig.Width, objChartConfig.Height); 
	objChart.setDataXML(strXML);
	objChart.render(objChartConfig.Target);
	return objChart;
}


ChartTool.CreateChartFromDataMS = function(objChartConfig, objDataConfig, ArryData)
{
	var strXML = ConvertXMLMultiSeries(objChartConfig, objDataConfig, ArryData);
	var strFlashFileName = "FCF_" + objChartConfig.ChartType + ".swf";
	var objChart = new FusionCharts(ChartTool.FlashPath + "/" + strFlashFileName, objChartConfig.ChartID, objChartConfig.Width, objChartConfig.Height); 
	objChart.setDataXML(strXML);
	objChart.render(objChartConfig.Target);
	return objChart;
}


function ConvertXMLSingleSeries(ChartConfig, QueryInfo, objData)
{
	var strXMLBody = '<?xml version="1.0" encoding="gb2312" ?><graph/>';
	var objDom = GetDomObject(strXMLBody);
	ChartConfig["exportEnabled"] = 1;
	ChartConfig["exportAtClient"] = 1;
	ChartConfig["exportFormats"] = "exportType=��PNG=Export as High Quality Image;JPG;PDF=Export as PDF File";
	ChartConfig["exportShowMenuItem"] = 1;
	for (var strkey in ChartConfig)
	{
		objDom.documentElement.setAttribute(strkey, ChartConfig[strkey]);
	}
	var dataObj = null;
	var objElement = null;
	for(var i = 0; i < objData.length; i ++)
	{
		dataObj = objData[i];
		if((dataObj.color == null) || (dataObj.color == ""))
		{
			dataObj.color = ChartTool.ColorArray[i % ChartTool.ColorArray.length];
		}
		objElement = objDom.createElement("set");
		objElement.setAttribute("name", dataObj[QueryInfo.NameField]);
		objElement.setAttribute("value", dataObj[QueryInfo.ValueField]);
		objElement.setAttribute("color", dataObj.color);
		//objElement.setAttribute("hoverText", dataObj[QueryInfo.HoverTextField]);
		//objElement.setAttribute("link", dataObj[QueryInfo.LinkField]);
		objDom.documentElement.appendChild(objElement);
	}	
	if(objDom.documentElement.xml)
	{
		return objDom.documentElement.xml;
	}
	else
	{
		var p = new XMLSerializer();
		return p.serializeToString(objDom);
	}
}


function ConvertXMLMultiSeries(ChartConfig, QueryInfo, objData)
{
	var strXMLBody = '<?xml version="1.0" encoding="utf-8" ?><graph/>';
	var objDom = GetDomObject(strXMLBody);
	ChartConfig["exportEnabled"] = 1;
	ChartConfig["exportAtClient"] = 1;
	ChartConfig["exportFormats"] = "exportType=��PNG=Export as High Quality Image;JPG;PDF=Export as PDF File";
	ChartConfig["exportShowMenuItem"] = 1;
	for (var strkey in ChartConfig)
	{
		objDom.documentElement.setAttribute(strkey, ChartConfig[strkey]);
	}
	
	var objTmpData = new Object();
	var dataObj = null;
	var objElement = null;
	var arryData = new Object();
	var arryCategory = new Object();
	
	
	for(var i = 0; i < objData.length; i ++)
	{
		dataObj = objData[i];
		arryCategory[dataObj[QueryInfo.CategoryFieldName]] = "";
		if(arryData[dataObj[QueryInfo.SeriesFieldName]] == null)
			arryData[dataObj[QueryInfo.SeriesFieldName]] = new Object();
		if(arryData[dataObj[QueryInfo.SeriesFieldName]].Category == null)
			arryData[dataObj[QueryInfo.SeriesFieldName]].Category = new Object();
		arryData[dataObj[QueryInfo.SeriesFieldName]].Category[dataObj[QueryInfo.CategoryFieldName]] = dataObj[QueryInfo.ValueField];
			
	}	
	//�����б�
	var objCategoryMaster = objDom.createElement("categories");
	objDom.documentElement.appendChild(objCategoryMaster);
	for (var strCategoryFileName in arryCategory)
	{
		var objCategory = 	objDom.createElement("category");
		objCategory.setAttribute("name", strCategoryFileName);
		objCategoryMaster.appendChild(objCategory);
	}
	//���ݼ�
	var objDataSet = objDom.createElement("dataset");

	var objSeries = null;
	var objDataSet = null;
	var objSetValue = null;
	var intCounter = 0;
	for(var strSeriesName in arryData)
	{
		objSeries = arryData[strSeriesName];
		objDataSet = objDom.createElement("dataset");
		objDataSet.setAttribute("seriesname", strSeriesName);
		objDataSet.setAttribute("color", ChartTool.ColorArray[intCounter % ChartTool.ColorArray.length]);
		objDataSet.setAttribute("showValue", "1");
		objDataSet.setAttribute("showAnchors", "0");
		objDataSet.setAttribute("alpha", "80");
		for(var strCategoryName in objSeries.Category)
		{
			objSetValue = objDom.createElement("set");
			objSetValue.setAttribute("value", objSeries.Category[strCategoryName]);
			objDataSet.appendChild(objSetValue);
		}	
		objDom.documentElement.appendChild(objDataSet);
		intCounter ++;
	}
	if(objDom.documentElement.xml)
	{
		return objDom.documentElement.xml;
	}
	else
	{
		var p = new XMLSerializer();
		return p.serializeToString(objDom);
	}	
}


function GetDomObject(xml){
      
            var dom = null;
			if(navigator.userAgent.indexOf("MSIE")>0)
            {
                dom = new ActiveXObject("Microsoft.XMLDOM");    //ʵ����dom����
				dom.loadXML(xml);
                /*
                    ����ط��ܶ����Ѳ����ף���д��ϸ��
                    �����첽���� 
                    ����������Ҫ��XML�ļ���ȡ���֮ǰ�����κβ����� 
                    ��˹ر��첽�����ܡ�
                */
            }
            else if(document.implementation && document.implementation.createDocument)
            {
				try{
					//dom = document.implementation.createDocument("", "", null);         //�����֧��ActiveXObject
					var objParser = new DOMParser(); 
					dom = objParser.parseFromString(xml, "text/xml");
                }catch(err)
				{
					alert(err.message);
				}
				/* 
                    ���ǻ��������һ�м���xml�ķ�ʽ
                    var oXmlHttp = new XMLHttpRequest() ; 
                    oXmlHttp.open( "GET", "test.xml", false ) ; 
                    oXmlHttp.send(null) ; 
                    //oXmlHttp.responseXML����xml�����ˡ�
                */
            }
            else
            {
                window.alert('�ݲ�ʶ��������!');
                return;
            }
			return dom;

}
