
function InitWinImportClinPathWayEvent(obj){
	
	obj.LoadEvent = function(args){
		obj.btnSelect.on('click', obj.btnSelect_onClick, obj);
		obj.txtFilePath.on('kewdown', obj.txtFilePath_onKewDown, obj);
		obj.btnImportFile.on('click', obj.btnImportFile_click, obj);
	};
	
	obj.btnSelect_onClick = function(){
		var filePath=Ext.dhcc.DataToExcelTool.SelectDir();
		obj.txtFilePath.setValue(filePath);
		obj.txtFilePath_onKewDown();
	};
	
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
	};
	
	obj.btnImportFile_click = function(){
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
	
	//导临床路径表单文件，数据保存在临时表单中
	//按照临床路径表单数据模板格式做表单数据
	obj.ImportFileData = function(fileName)
	{
		var objImport = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.HandHealthSrv");
		var arrSheetList;
		Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
		Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(fileName);
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet(arrSheetList[i]);
				
				var row=1,rowNull=0,formCode="",SaveTempFormErr="",colNull=0 ,ExcelCode="";
				var InfoFileTitle=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(1,1); //文件标题 必须包含XXXX年XX月
				if(InfoFileTitle=="")
				{
					alert("标题不能为空!!");	
					return;
				}
				var ImportDataDate=InfoFileTitle.split("月")[0];
				if((ImportDataDate.length!=6)&&(ImportDataDate.length!=7))
				{
					alert("Excel标题年月不对，请按照XXXX年XX月....格式");	
					return;
				}
				
				var StartCol=2;
				while (colNull!=-1)
				{
						var SoapCode=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(2,StartCol);
						var SoapName=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(3,StartCol);
						var SoapHlVolume=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(4,StartCol);
						var SoapHlUnit=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(5,StartCol);
						
						if(SoapCode!="总计")
						{
							if((SoapName=="")||(SoapHlVolume=="")||(SoapHlUnit==""))
							{
								alert("洗手液容量、单位、名称都不能为空!!");	
								return;
							}
						}
						var cellInfo= SoapCode + "^" + SoapName + "^" + SoapHlVolume + "^" + SoapHlUnit;
						if(SoapName=="") colNull=-1;
					if(colNull!=-1)
					{
						if(ExcelCode!="") ExcelCode =ExcelCode + String.fromCharCode(10) + cellInfo;
						else ExcelCode=cellInfo;
						
					}
					StartCol++;
				}
				
				if(StartCol<4)
				{
					alert("Excel数据有误，请检查数据!!");
					return;
				}
				
				var StartRow=6,rowNull="",LocSoapStr="",TotalLocSoapStr="";
				while(rowNull!=-1)
				{
					var SoapTypeNum=StartCol-1,LocSoapStr="";
					var LocStr=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(StartRow,1); //科室代码、名称
					var len=LocStr.split("　").length;

					for(var k=2 ; k < SoapTypeNum ; k++)
					{
							var SoapCode=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(2,k);		
							var SoapName=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(3,k);		
							var SoapVolume=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(4,k);		
							var SoapUnit=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(5,k);	
							var SoapInfo=	SoapCode+"^"+SoapName+"^"+SoapVolume+"^"+SoapUnit;
							var SoapNum=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(StartRow,k);
							if((SoapNum>0)&&(rowNull!=-1)) 
							{
						 		if(LocSoapStr!="") 	LocSoapStr = LocSoapStr + String.fromCharCode(9) + SoapInfo + String.fromCharCode(10) + SoapNum;
						 		else LocSoapStr = SoapInfo + String.fromCharCode(10) + SoapNum;
							}
					}
					if((LocStr!="")&&(len==2))
					{ 
						if(TotalLocSoapStr!="") TotalLocSoapStr = TotalLocSoapStr + String.fromCharCode(11)+ LocStr + String.fromCharCode(12) + LocSoapStr;
						else TotalLocSoapStr=LocStr + String.fromCharCode(12) + LocSoapStr;
					}else 
					{
						rowNull=-1;
					}
					StartRow++;
				}

				var ret=objImport.ImportHandHealthData(ImportDataDate,ExcelCode,TotalLocSoapStr);
				if(ret<0) alert("导入数据失败，请检查excel格式是否正确!!");
				else alert("导入数据成功!!");
			}
		}
	  Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	
}
	//导临床路径表单文件，数据保存在临时表单中
	//按照临床路径表单数据模板格式做表单数据
	obj.ImportFileData1 = function(fileName)
	{
		var objImport = ExtTool.StaticServerObject("web.DHCCPW.MRC.ImportPathWay");
		var col=10;
		var arrSheetList;
		Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
		Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(fileName);
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet(arrSheetList[i]);
				
				var row=1,rowNull=0,formCode="",SaveTempFormErr="";
				while (rowNull<5){
					var rowInfo="",colNull=0;
					for (var j=1;j<=col;j++){
						var cellInfo=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(row,j);
						rowInfo = rowInfo + cellInfo + String.fromCharCode(9);
						if (cellInfo=='') colNull++;
					}
					if (colNull==col){
						rowNull++;
					}else{
						rowNull=0;
						var ret = objImport.SaveTempForm(formCode,rowInfo);
						if(parseFloat(ret)<0) {
							SaveTempFormErr="Row=" + row + ",ErrCode=" + ret + "!" + String.fromCharCode(13) + String.fromCharCode(10);
							break;
						}else{
							formCode=ret;
						}
					}
					row++;
				}
				
				if (formCode) {
					if (SaveTempFormErr){
						SaveTempFormErr="保存临床路径表单初始数据错误!File="+fileName+",Sheet="+arrSheetList[i] + "!" + String.fromCharCode(13) + String.fromCharCode(10) + SaveTempFormErr;
						alert(SaveTempFormErr);
					}else{
						var tmp=".."+fileName.substr(fileName.lastIndexOf('\\'),fileName.length);
						alert("导入临床路径表单初始数据成功!File="+tmp+",Sheet="+arrSheetList[i] + "!");
					}
				}
			}
		}
	    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	    obj.lsTempFormStore.load({});  //刷新临时表单数据
	}
	
	//删除临床路径临时表单
	obj.btnDeleteForm_click = function(formCode)
	{
		var objImport = ExtTool.StaticServerObject("web.DHCCPW.MRC.ImportPathWay");
		var objChkTempFormLV=Ext.select('input[type=checkbox]').elements;
		var objlsTempForm=obj.lsTempForm.getStore();
		for (var i=0;i<objChkTempFormLV.length;i++){
			var chkTempFormLV=objChkTempFormLV[i];
			var tmpList=chkTempFormLV.id.split("chkTempFormLV");
			if ((chkTempFormLV.checked)&&(tmpList.length>=2)){
				var row=tmpList[1];
				var formCode=objlsTempForm.getById(row).get('Code');
				var flg=objImport.DeleteTempForm(formCode)
				if (parseFloat(flg)<0){
					alert("删除临时表单失败!Code="+formCode);
				}
			}
		}
		obj.lsTempFormStore.load({});  //刷新临时表单数据
	}
	
	//导临床路径临时表单，生成正式表单
	obj.btnImportForm_click = function(formCode)
	{
		//alert("请后台执行web.DHCCPW.MRC.ImportPathWay.SaveForm("",临时表单编号).");
		var objImport = ExtTool.StaticServerObject("web.DHCCPW.MRC.ImportPathWay");
		var objChkTempFormLV=Ext.select('input[type=checkbox]').elements;
		var objlsTempForm=obj.lsTempForm.getStore();
		for (var i=0;i<objChkTempFormLV.length;i++){
			var chkTempFormLV=objChkTempFormLV[i];
			var tmpList=chkTempFormLV.id.split("chkTempFormLV");
			if ((chkTempFormLV.checked)&&(tmpList.length>=2)){
				var row=tmpList[1];
				var formCode=objlsTempForm.getById(row).get('Code');
				var flg=objImport.SaveForm("",formCode)
				if (parseFloat(flg)<0){
					alert("保存正式表单失败!Code="+formCode+"Error:"+flg);
				}else{
					alert("保存正式表单成功!");
				}
			}
		}
		obj.lsTempFormStore.load({});  //刷新临时表单数据
	}
	
}

