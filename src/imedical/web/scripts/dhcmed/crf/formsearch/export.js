/************************
创建者：李阳
创建日期：2013-11-25
功能：根据Excel表的定义，导出自定义表单数据
**************************/


FormExport = new Object();
FormExport.ExcelApp = null;
FormExport.TemplateFileName = "";
FormExport.ExportFieldArry = null;
FormExport.CFName = "";
FormExport.GetExportField = function(objSheet)
{
	var intRow = 3;
	var arry = new Array();
	var strContent = "";
	for(var intCol = 1; intCol <= objSheet.UsedRange.Columns.Count; intCol ++)
	{
		strContent = objSheet.UsedRange.Cells(intRow, intCol).Value
		if(strContent == null)
			continue;
		if(strContent.match(/<.*>/))
		{
			arry[arry.length] = strContent.substr(1, strContent.length - 2);
		}
		else
		{
			arry[arry.length] = "";
		}
	}
	FormExport.ExportFieldArry = arry;
	return arry;
}

FormExport.LoadDataToArray = function(Class,objStore,callback,scope)
{
	
	Ext.MessageBox.progress( '准备数据', '开始读取数据，请稍后...');
	//debugger;
	this.tmpArry = new Array();
	var objRec = null;
	for(var i = 0; i < objStore.getCount(); i ++)
	{
		objRec = objStore.getAt(i);
		Ext.Ajax.request({
			url: ExtToolSetting.RunQueryPageURL,
			params : {
				ClassName : Class,
				QueryName : 'QryByID',
				Arg1 : objRec.get("DataId"),
				ArgCnt : 1,
				DataIndex : i
			},
			success: function(response, opts) {
			  var objResult = Ext.decode(response.responseText);
			  var objData = new Object();
			  for(var i = 0; i < objResult.total; i ++)
			  {
				objData[objResult.record[i].FieldName] = objResult.record[i].FieldValue;
			  }
			  FormExport.tmpArry[opts.params.DataIndex] = objData;
			  Ext.MessageBox.updateProgress(
				FormExport.tmpArry.length / objStore.getCount(),
				FormExport.tmpArry.length + "/" + objStore.getCount(),
				"正在读取数据，请稍后..."
			  );
			  if(FormExport.tmpArry.length  == objStore.getCount())
			  {
				Ext.MessageBox.hide();
				if(callback)
					callback.call(scope);
			  }
		   }
		});
	}
}


FormExport.ExportToExcel = function(){

	//if(FormExport.ExcelApp)
	//	return;
	
	var strPath = window.location.href.match(/http.*csp\//)[0];
	strPath = strPath + FormExport.TemplateFileName;
	var objApp = new ActiveXObject("Excel.Application");
	FormExport.ExcelApp = objApp;
	var objBook = objApp.Workbooks.Add(strPath);
	var objSheet = objBook.Worksheets.Item(1);
	this.GetExportField(objSheet);
	var intPos = 0;
	for(var intRow = 0; intRow < this.tmpArry.length; intRow ++)
	{
		intPos = intRow + 3;
		for(var i = 0; i < this.ExportFieldArry.length; i ++)
		{
			if(this.ExportFieldArry[i] == "")
			{
				objSheet.Cells(intPos, i + 1).Value = ""
				continue;
			}
			if(this.tmpArry[intRow][this.ExportFieldArry[i]] != null)
			{
				objSheet.Cells(intPos, i + 1).Value = this.tmpArry[intRow][this.ExportFieldArry[i]];
			}
			else
			{
				objSheet.Cells(intPos, i + 1).Value = "";
			}

		}
		Ext.MessageBox.updateProgress(
			(i + 1) / this.tmpArry.length,
			(i + 1) + "/" + this.tmpArry.length,
			"正在生成到Excel文档，请稍后..."
		 );
		  
	}
	Ext.MessageBox.hide();
	objApp.Visible = true;
	//FormExport.ExcelApp = null;
}