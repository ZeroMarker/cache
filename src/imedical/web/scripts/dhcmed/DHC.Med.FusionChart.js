
/*
1、Query的选项
单个系列的图表：
QueryInfo.ClassName   包含Query的类名：
QueryInfo.QueryName   Query的名字
QueryInfo.NameField   包含图表标签值的列名
QueryInfo.ValueField  包含图表中数值的列名


多系列的图表：
QueryInfo.ClassName   包含Query的类名：
QueryInfo.QueryName   Query的名字
QueryInfo.CategoryFieldName  包含类别的列名
QueryInfo.SeriesFieldName    包含系列名称的列名

2、图表的选项
ChartInfo.Target       图表绘制的位置，应该是某个DIV标签的ID值
ChartInfo.ChartType    图表的类别，可以是下面的值（文本，记得加引号哦~~）
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

//FusionChart的存放路径：
ChartTool.FlashPath = "../scripts_lib/FusionChartsFree/Charts"; 

//颜色表：
ChartTool.ColorArray = ['AFD8F8','F6BD0F','8BBA00','FF8E46','008E8E','D64646','8E468E','588526','B3AA00','008ED6','9D080D','A186BE','0000FF','DEB887','D2691E','DC143C','008B8B','00CED1','FF1493','90EE90','FFA07A','00FF00','FF00FF','FF4500','CD853F','4169E1','FFFF00','EE82EE','C0C0C0','F4A460'];

//创建单独系列图表
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

//运行Query
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


//创建多系列图表XML数据
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
	ChartConfig["exportFormats"] = "exportType=”PNG=Export as High Quality Image;JPG;PDF=Export as PDF File";
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
	ChartConfig["exportFormats"] = "exportType=”PNG=Export as High Quality Image;JPG;PDF=Export as PDF File";
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
	//横轴列表
	var objCategoryMaster = objDom.createElement("categories");
	objDom.documentElement.appendChild(objCategoryMaster);
	for (var strCategoryFileName in arryCategory)
	{
		var objCategory = 	objDom.createElement("category");
		objCategory.setAttribute("name", strCategoryFileName);
		objCategoryMaster.appendChild(objCategory);
	}
	//数据集
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
                dom = new ActiveXObject("Microsoft.XMLDOM");    //实例化dom对象
				dom.loadXML(xml);
                /*
                    这个地方很多朋友不明白，我写详细点
                    设置异步处理 
                    本函数不需要在XML文件读取完成之前进行任何操作， 
                    因此关闭异步处理功能。
                */
            }
            else if(document.implementation && document.implementation.createDocument)
            {
				try{
					//dom = document.implementation.createDocument("", "", null);         //火狐不支持ActiveXObject
					var objParser = new DOMParser(); 
					dom = objParser.parseFromString(xml, "text/xml");
                }catch(err)
				{
					alert(err.message);
				}
				/* 
                    这是火狐的另外一中加载xml的方式
                    var oXmlHttp = new XMLHttpRequest() ; 
                    oXmlHttp.open( "GET", "test.xml", false ) ; 
                    oXmlHttp.send(null) ; 
                    //oXmlHttp.responseXML就是xml对象了。
                */
            }
            else
            {
                window.alert('暂不识别该浏览器!');
                return;
            }
			return dom;

}
