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
			strMsg += "�Ƿ�򿪱����޸ģ�";
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
					strMsg += "�Ƿ�Ҫ���Դ���ǿ�Ƶ�����";
					if(window.confirm(strMsg))
					{
						ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ExportReport", objRec.get("RowID"));
						intCnt ++
					}
				}
			}
			else
			{
				var strMsg = "�Ƿ�Ҫ���Դ���ǿ�Ƶ�����";
				if(window.confirm(strMsg))
				{
					ret = ExtTool.RunServerMethod("DHCMed.EPDService.EpdExportInterface", "ExportReport", objRec.get("RowID"));
					intCnt ++
				}			
			}
		}
	}
	window.alert("�Ѿ��ɹ�����" + intCnt + "����Ⱦ�������¼��");
}

function FormatErrMsg(objRec, ret)
{
	var str = "����" + objRec.get("RegNo") + " " + objRec.get("PatientName") + "�Ĵ�Ⱦ�����淢�����´���\r\n";
	var arry = ret.split("^");
	for(var j = 0; j < arry.length; j ++)
	{
		if(arry[j] == "")
			continue;
		str += (j + 1) + "." + arry[j] + "\r\n";
	}
	return str;
}