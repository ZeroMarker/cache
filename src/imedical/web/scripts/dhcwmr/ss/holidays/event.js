function InitViewportEvent(obj)
{
	obj.Holidays = ExtTool.StaticServerObject("DHCWMR.SS.Holidays");

	obj.LoadEvent = function(){
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.btnImport.on('click',obj.btnImport_click,obj);
		obj.btnSelect.on('click',obj.btnSelect_click,obj);
		obj.txtFilePath.on('kewdown', obj.txtFilePath_onKewDown, obj);
		obj.btnUpdate.on('click',obj.btnUpdate_click,obj);
		obj.btnDelete.on('click',obj.btnDelete_click,obj);
		obj.DetailGridPanel.on("rowclick",obj.DetailGridPanel_rowclick,obj);
	}

	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("InputDate","");
		Common_SetValue("InputName","");
		Common_SetValue("InputType","");
		Common_SetValue("InputHAlias","");
	}
	
	obj.DetailGridPanel_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.DetailGridPanel.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("InputDate",objRec.get("Date"));
			Common_SetValue("InputName",objRec.get("HName"));
			Common_SetValue("InputType",objRec.get("TypeCode"),objRec.get("TypeDesc"));
			Common_SetValue("InputHAlias",objRec.get("HAlias"));
		}
	}

	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var aDate = Common_GetValue("InputDate");
		var aName = Common_GetValue("InputName");
		var aType = Common_GetValue("InputType");
		var aHAlias = Common_GetValue("InputHAlias");
		if (!aDate) {
			errinfo = errinfo + "日期为空!<br>";
		}else{  //fix bug 6525 by pylian 2015-01-21 手动输入无效日期，点击【更新】，报错
			var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;	
			var ret=aDate.match(reg);
			if(ret==null){
				errinfo = errinfo + "请按正确的日期格式'Y-M-D'输入!<br>";
			}
		}
		if (!aName) {
			errinfo = errinfo + "节日名称为空!<br>";
		}
		if (!aType)
		{
			errinfo = errinfo + "类型为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID
		inputStr = inputStr + CHR_1 + aName;
		inputStr = inputStr + CHR_1 + aDate;
		inputStr = inputStr + CHR_1 + aType;
		inputStr = inputStr + CHR_1 + aHAlias;
		
		var flg = obj.Holidays.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (flg == '-100') {
				ExtTool.alert("错误提示","当前日期重复!");
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		obj.ClearFormItem();
		obj.DetailGridPanelStore.load({});
	}

	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("DetailGridPanel");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if((arrRec.length>0) && (obj.RecRowID!= "")){  //fix Bug 6548 by pylian 2015-01-20 取消选中的记录，仍能被删除
				Ext.MessageBox.confirm('提示', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var ID = objRec.get("ID");
							if (ID == '') {
								ExtTool.alert("提示","无选择记录!");
								continue;
							}
							
							var flg = obj.Holidays.DeleteById(ID);
							obj.ClearFormItem();   //add by pylian 修改删除一条记录后，控件中数据依然存在问题
							obj.DetailGridPanelStore.load({});
							
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}

	obj.btnQry_click = function()
	{
		obj.DetailGridPanelStore.load({});
	}

	obj.btnExport_click = function()
	{
		if (obj.DetailGridPanel.getStore().getCount() < 1) {
			ExtTool.alert("提示", "无数据记录，不允许导出!");
			return;
		}
		var strFileName = "节假日";
		//GridExportExcel(obj.DetailGridPanel, strFileName);
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
			var objExcelTool = Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.DetailGridPanel, strFileName);
		}else{
			ExprotGridStrNew(obj.DetailGridPanel, strFileName);
		}
	}

	obj.btnImport_click = function()
	{
		var filePath=obj.txtFilePath.getValue();
		var objChkFileLV=Ext.select('input[type=checkbox]').elements;
		var objLsFileList=obj.lsFileList.getStore();
		for (var i=0;i<objChkFileLV.length;i++){
			var chkFileLV=objChkFileLV[i];
			var tmpList=chkFileLV.id.split("chkFileLV");
			if ((chkFileLV.checked)&&(tmpList.length>=2)){
				var row=tmpList[1];
				var fileName=objLsFileList.getById(row).get('FileName');
				var excelFileName= filePath + '\\' + fileName;
				obj.ImportFileData(excelFileName);
			}
		}
	}
	
	obj.btnSelect_click = function()
	{
		var filePath=Ext.dhcc.DataToExcelTool.SelectDir();
		obj.txtFilePath.setValue(filePath);
		obj.txtFilePath_onKewDown();
	}

	obj.txtFilePath_onKewDown = function(){
		obj.lsFileListStore.loadData([]);
		var filePath=obj.txtFilePath.getValue();
		if (filePath){
			var fileNames=Ext.dhcc.DataToExcelTool.GetFiles(filePath);
			if (fileNames){
				var tmpList=fileNames.split("/");
				fileNames="";
				for (var i=0;i<tmpList.length;i++){
					var fileName=tmpList[i];
					tmpName=fileName.substr(fileName.lastIndexOf('.'),fileName.length);
					if (tmpName.toLowerCase()==".xls") {
						if (fileNames) {
							fileNames=fileNames+"/"+fileName;
						}else{
							fileNames=fileName;
						}
					}
				}
				if (fileNames) {
					tmpList=fileNames.split("/");
					var tmpArray=new Array(tmpList.length);
					for (var i=0;i<tmpList.length;i++){
						tmpArray[i]=[i,tmpList[i]];
					}
					obj.lsFileListStore.loadData(tmpArray);
				}
			}
		}
	}

	obj.ImportFileData = function(fileName)
	{
		var objHolidaysSrv = ExtTool.StaticServerObject("DHCWMR.SSService.HolidaysSrv");
		var arrSheetList;
		Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
		Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(fileName);
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet(arrSheetList[i]);
				var row = 2,flag = 1,tmpArg = "",strArg = "";
				while (flag>0)
				{
					var ID = ""
					var aName=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(row,1);
					var aDate=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(row,2);
					var aType=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(row,3);
					var aHAlias=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(row,4);
					if ((!aDate)||(!aType)||(!aHAlias)) 
					{
						flag =-1;
						break;
					}
					if ((aType!="节假日")&&(aType!="工作日"))
					{
						flag = -1;
						break;
					}
					if (aType=="节假日") aType="H"
					if (aType=="工作日") aType="W"
					tmpArg = "";
					tmpArg += "^" +aName;
					tmpArg += "^" + aDate;
					tmpArg += "^" + aType;
					tmpArg += "^" + aHAlias;
					strArg += tmpArg + "||";
					row ++;
				}
				if (!strArg) continue;
				ret = objHolidaysSrv.ImportData(strArg, "^" , "||");
				ExtTool.alert("提示",ret);
			}
		}
	    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	}
}