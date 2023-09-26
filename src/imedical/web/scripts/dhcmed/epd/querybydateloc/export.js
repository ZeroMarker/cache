function ExportEPDInterface(obj, IsSkipMapping)
{
	var objGrid = Ext.getCmp("DataGridPanel");
	var objStore = objGrid.getStore();
	var intCnt = 0;
	var strRepList = "";
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		var objRec = objStore.getAt(i)
		if(!objRec.get("checked"))
			continue;		
		strRepList += objRec.get("RowID") + "^";
	}
	ExtTool.RunQuery(
		{
			ClassName : 'DHCMed.EPDService.EpdExportProblem',
			QueryName : 'QryValidateInfo',
			Arg1 : strRepList,
			Arg2 : "^",
			ArgCnt : 2
		},
		function(arryResult, arg)
		{
			if((arryResult.length == 0)||(arg.SkipMappingError == true))
			{
				ExportEPDList(arg.objParent)
			}
			else
			{
				var o = new InitwinProblem(arg.Replist, arg.Delimiter);
				o.winProblem.show();
			}
		},
		null,
		{
			objParent : obj,
			Replist : strRepList,
			Delimiter : "^",
			SkipMappingError : IsSkipMapping
		}
	)
}


function ExportEPDList(obj)
{
	var objGrid = Ext.getCmp("DataGridPanel");
	var objStore = objGrid.getStore();
	var intCnt = 0;
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		var objRec = objStore.getAt(i)
		if(!objRec.get("checked"))
			continue;
		var ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ValidateContent", objRec.get("RowID"));
		if(ret == "")
		{
			ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ExportReport", objRec.get("RowID"));
			intCnt ++;
		}
		else
		{
			var strMsg = FormatErrMsg(objRec, ret)
			strMsg += "是否打开报告修改？";
			if(window.confirm(strMsg))
			{
				obj.DataGridPanel_rowdblclick(objGrid, i)
				var ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ValidateContent", objRec.get("RowID"));
				if(ret == "")
				{
					ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ExportReport", objRec.get("RowID"));
				}	
				else
				{
					var strMsg = FormatErrMsg(objRec, ret)
					strMsg += "是否要忽略错误并强制导出？";
					if(window.confirm(strMsg))
					{
						ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ExportReport", objRec.get("RowID"));
						intCnt ++
					}
				}
			}
			else
			{
				var strMsg = "是否要忽略错误并强制导出？";
				if(window.confirm(strMsg))
				{
					ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ExportReport", objRec.get("RowID"));
					intCnt ++
				}			
			}
		}
	}
	window.alert("已经成功导出" + intCnt + "条传染病报告记录！");
}

function FormatErrMsg(objRec, ret)
{
	var str = "患者" + objRec.get("RegNo") + " " + objRec.get("PatientName") + "的传染病报告发现如下错误：\r\n";
	var arry = ret.split("^");
	for(var j = 0; j < arry.length; j ++)
	{
		if(arry[j] == "")
			continue;
		str += (j + 1) + "." + arry[j] + "\r\n";
	}
	return str;
}