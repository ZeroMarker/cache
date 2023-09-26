function diagnosesBtQuote(obj){
	var operationsStr = GetQueryValue1("operationsStr")
	if (operationsStr != "")
	{
		var operationsObj = JSON.parse(unescape(utf8to16(base64decode(operationsStr)))); 
	}
	
	///取引用加载格式
	function getScheme(operations)
	{
		var name = "";
		if (operations.Url.name)
		{
			name = operations.Url.name;
		}
		else
		{
			name = operations.Url;
		}
		jQuery.ajax({
			type: "get",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.HyperLink",
				"Method":"GetUnitScheme",
				"p1":name
			},
			success: function(d) {
				if (d == "") return;
				g_xml = convertToXml(d);
				
			},
			error : function(d) {alert(" error");}
		});		
	}
	
	function diagnosesBtQuote_click(selectedobj){	


		g_refScheme = getRefScheme(g_xml,"scheme>reference>items>item")
		g_separate = $(g_xml).find("scheme>reference>separate").text();
		g_separate = g_separate=="enter"?"\n":g_separate;
		g_schemetype = $(g_xml).find("scheme>reference>style").text();
		g_memosep = $(g_xml).find("scheme>reference>memosep").text();
		var interpunction = $(g_xml).find("scheme>reference>interpunction").text();
		g_interpunction = interpunction.split("^");
		var displaycategory = $(g_xml).find("scheme>reference>category>display").text();
		var categoryseparate = $(g_xml).find("scheme>reference>category>separate").text();
		categoryseparate = categoryseparate=="enter"?"\n":categoryseparate;
		var displaytype = $(g_xml).find("scheme>reference>type>display").text();
		var typeseparate = $(g_xml).find("scheme>reference>type>separate").text();
		typeseparate = typeseparate=="enter"?"\n":typeseparate;
		var tmpnamedate = $(g_xml).find("scheme>reference>namedate").text();
		
		var result = "";
		
	
		
		debugger;
		if (selectedobj.length >0)
		{
			
			var typeList = new Array();
			$.each(selectedobj, function(index, item){
				if ($.inArray(item.TypeDesc,typeList)== -1) 
				{
					typeList.push(item.TypeDesc);
				}
			});
			
			for (var i=0;i<typeList.length;i++)
			{
				
				var type = ""
				var typeItems = $.grep(selectedobj,function(item,a){return item.TypeDesc == typeList[i]});
				if (typeItems.length>0 && displaytype == "y")
				{
					type = typeList[i];
					result = result + type + ":" + typeseparate;
				}
				
				var categoryList = new Array();
				$.each(typeItems, function(index, item){if ($.inArray(item.BillFlag,categoryList)== -1) categoryList.push(item.BillFlag);});	
			
				for (var j=0;j< categoryList.length;j++)
				{
					var category = "";
					var categoryItems = $.grep(typeItems,function(item,a){return item.BillFlag == categoryList[j]});
					if (categoryList.length >1 && displaycategory == "y") 
					{
						if (type !="") result = result + "    ";
						if (categoryList[j]=="0") 
						{
							result = result + "西医诊断:";
						}
						else
						{
							result = result + "中医诊断:";
						}
						category = categoryList[j];
						result = result + categoryseparate;
					}
					if (tmpnamedate == "y")
					{
						result = result + getDiagnosesDataByDateName(categoryItems,type,category);
					}
					else
					{
						result = result + getDiagnosesData(categoryItems,type,category);	
					}			
				}	
			}
		}
		return result;

	}
	///按分类输出诊断
	function getDiagnosesData(Items,type,category)
	{
		var result = "";
        var seqLevel1 = "";
        var preDiagLevel = ""
        var subseq=""
		for (var i=0;i< Items.length;i++)
		{
			if (type != "") result = result + "    ";
            if ("" !== category) result = result + "    ";

            var level = Items[i].Level;
            space = getSpace(level);
            result = result + space;

            if (level == 1) 
            {
                seqLevel1 = seqLevel1=="" ? 1:seqLevel1+1
            }
            else 
            {
                subseq = preDiagLevel == level ? subseq+1 : 1 
            }
            
            
            result = result + (level == 1 ? seqLevel1 : subseq)
            
			if (g_interpunction.length >0) result = result + g_interpunction[level-1];
			result = result + Items[i].ICDDesc;
			if (Items[i].EvaluationDesc == "疑诊")
			{
				result = result + "?";
			}
			if (Items[i].MemoDesc != "")
			{
				if (g_memosep == "()")
				{
					if (Items[i].ICDID == "")
					{
						result = result + Items[i].MemoDesc;
					}
					else
					{
						result = result + "("+Items[i].MemoDesc+")";
					}
				}
				else
				{
					result = result + g_memosep + Items[i].MemoDesc;
				}
            }
            
            result = result + g_separate;
            //定义上一个诊断的级别，用来计数
            preDiagLevel = level
		}
		if(g_schemetype == "row")
		{
			result = result.substring(0,result.length-g_separate.length) + "。";
		}
		alert(result);
		return result;
	}

	///按日期医生输出诊断
	function getDiagnosesDataByDateName(Items,type,category)
	{
		var result = "";
		var dateList = new Array();
		$.each(Items, function(index, item){if ($.inArray(item.Date,dateList)== -1) dateList.push(item.Date);});	

		for (var k=0;k< dateList.length;k++)
		{
			var dateItems = $.grep(Items,function(item,a){return item.Date == dateList[k]});
			var nameList = new Array();
			$.each(dateItems, function(index, item){if ($.inArray(item.UserName,nameList)== -1) nameList.push(item.UserName);});	
		
			for (var l=0;l<nameList.length;l++)
			{
				var nameItems = $.grep(dateItems,function(item,a){return item.UserName == nameList[l]});
			    var seq = "";
			    var date = "";
			    var name = "";
			    for (var m=0;m<nameItems.length;m++)
			    {
				    if (type != "") result = result + "    ";
			    	if (category != "") result = result + "    ";

				    if (nameItems.length > 1) seq = m +1; 
				    result = result + seq
				    if (seq != "" && g_interpunction.length >0) result = result + g_interpunction[0];
				    result = result + nameItems[m].ICDDesc;
				    if (nameItems[m].EvaluationDesc == "疑诊")
				    {
					     result = result + "?";
					}
			 		if (nameItems[m].MemoDesc != "")
					{
						if (g_memosep == "()")
						{
							if (nameItems[m].ICDID == "")
							{
								result = result + nameItems[m].MemoDesc;
							}
							else
							{
								result = result + "("+nameItems[m].MemoDesc+")";
							}
						}
						else
						{
							result = result + nameItems[m].MemoDesc;
						}
					}
				    var child = getSubData(nameItems[m].children,nameItems[m].BillFlag)
				    if (nameItems[m].BillFlag == 1 && child != "") 
				    {
					    result = result +"("+child+")";
					}
					else
					{
						if (g_schemetype == "layer" && child != "")
						{
							result = result + "\n" + child;
						}
						else if(g_schemetype == "row")
						{
							result = result +  child;
						}
					}
					result = result + g_separate;
				}
				if (nameItems.length>0)
				{
					date = "                      " + nameItems[0].Date + "\n";
					name = "                      " + nameItems[0].UserName +"\n";
					result = result + name + date;
				}
			}					
		}
		return result;	
	}


	function getSpace(level)
	{
		var result = "";
		if (level == 1) return result;
		result = g_schemetype == "row"?"":"    ";
		for (var i=1;i<level;i++ )
		{
			result += g_schemetype == "row"?"":"      ";
		}
		return result
	}
	
	//Cache 处理诊断格式
	
	function DiagRefFormatFromCache(operations)
    {
	    var result="";
	    if (operations.Url.name)
		{
			name = operations.Url.name;
			type = operations.Url.type;
		}
		else
		{
			name = operations.Url;
			type = "PRE";
		}
		//医生站参数对象
		var episodeid = ServerObj.EpisodeID
		
	   	jQuery.ajax({
			type: "GET",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class" : "EMRservice.BL.BLDiagRefFormatData",
				"Method" : "GetDiagRefFormatData",
				"p1":episodeid,
				"p2":name,
				"p3":type
			},
			success: function(d) {
				
				result=d;

				
			},
			error : function(d) { alert(action + " error");}
		});

	    return result;		
	}
	
	///end
	
	
		
	//Web+Cache 处理诊断格式
	
	function DiagRefFormatFromCacheDataWeb(selectedobj,operations)
    {

	    debugger;
	    var result="";
	    if (operations.Url.name)
		{
			name = operations.Url.name;
			type = operations.Url.type;
		}
		else
		{
			name = operations.Url;
			type = "PRE";
		}
		//医生站参数对象
		var episodeid = ServerObj.EpisodeID;
		var diagJsonString = JSON.stringify(selectedobj);
	   	jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class" : "EMRservice.BL.BLDiagRefFormatData",
				"Method" : "GetDiagRefFormatData",
				"p1":episodeid,
				"p2":name,
				"p3":type,
				"p4":diagJsonString
			},
			success: function(d) {
				
				result=d;

				
			},
			error : function(d) { alert(action + " error");}
		});

	    return result;		
	}
	
	function getFormatServer()
    {

		var result ="";
	   	jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class" : "EMRservice.SystemParameter",
				"Method" : "DiagRefFormatServer",
			},
			success: function(d) {
				
				result=d;

				
			},
			error : function(d) { alert( " get FormatServer error");}
		});	
		return result;
	}
	
	
	var g_diagnosetypes = new Array(); 
	var g_xml=""
	var g_refScheme,g_separate,g_schemetype,g_interpunction,g_memosep,g_infectionsource,g_hasCheck;
	
	//"Cache",后台实现诊断值获取，诊断格式拼组输出
	//"Web"  ,医生站传入诊断，前端格式输出 [ 现行代码使用模式 ]
	//"Web+Cache" ,医生站传入诊断，通过json传入后台，后端进行诊断格式拼组输出
	//默认 Cache
	var FormatServer = getFormatServer();
	
	if (FormatServer=="Web")
	{
		getScheme(operationsObj);
	
		returnValue=diagnosesBtQuote_click(obj)
		
	}
	
	if (FormatServer=="Cache")
	{
		
		returnValue=DiagRefFormatFromCache(operationsObj)
		//处理后台数据未实现换行
		returnValue = returnValue.replace(/\\n/g,"\n")
	}
	
	if (FormatServer=="Web+Cache")
	{
		debugger ;
		returnValue=DiagRefFormatFromCacheDataWeb(obj,operationsObj)
		//处理后台数据未实现换行
		returnValue = returnValue.replace(/\\n/g,"\n")
	}
	parent.closeDialog("dialogLinkV8");
	return returnValue;
	
	//获取url中的参数
	function GetQueryValue1(queryName) {
	    var reg = new RegExp("(^|&)" + queryName + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if ( r != null ){
	       return decodeURI(r[2]);
	    }else{
	       return null;
    }
 }
}
