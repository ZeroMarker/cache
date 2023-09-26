
function InitWinImportClinPathWayEvent(obj){
	
	obj.LoadEvent = function(args){
		obj.btnSelect.on('click', obj.btnSelect_onClick, obj);
		obj.txtFilePath.on('kewdown', obj.txtFilePath_onKewDown, obj);
		obj.btnImportFileNew.on('click', obj.btnImportFileNew_click, obj);
		obj.btnImportFile.on('click', obj.btnImportFile_click, obj);
		obj.btnImportForm.on('click', obj.btnImportForm_click, obj);
		obj.btnDeleteForm.on('click', obj.btnDeleteForm_click, obj);
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
	obj.btnImportFileNew_click = function(){
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
				obj.ImportFileDataNew(excelFileName);
			}
		}
	}
	
	//���ٴ�·�����ļ������ݱ�������ʱ����
	//�����ٴ�·��������ģ���ʽ��������
	obj.ImportFileDataNew = function(fileName)
	{
		var objImport = ExtTool.StaticServerObject("web.DHCCPW.MRC.ImportPathWay");
		var col=5;  //col��ʼֵ��Ϊ5
		var arrSheetList; 
		Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
		Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(fileName);
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();

		var formCode=""
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet(arrSheetList[i]);
				
				var row=1,rowNull=0,SaveTempFormErr="";
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
						//alert(rowInfo)
						var ret = objImport.SaveTempFormNew(formCode,rowInfo);
						
						if(parseFloat(ret)<0) {
							SaveTempFormErr="Row=" + row + ",ErrCode=" + ret + "!" + String.fromCharCode(13) + String.fromCharCode(10);
							break;
						}else{
							formCode=ret;
						}
					}
					row++;
					col++;  //col����,·���׶β�������
				}
				
				if (formCode) {
					if (SaveTempFormErr){
						SaveTempFormErr="�����ٴ�·������ʼ���ݴ���!File="+fileName+",Sheet="+arrSheetList[i] + "!" + String.fromCharCode(13) + String.fromCharCode(10) + SaveTempFormErr;
						alert(SaveTempFormErr);
					}else{
						var tmp=".."+fileName.substr(fileName.lastIndexOf('\\'),fileName.length);
						alert("�����ٴ�·������ʼ���ݳɹ�!File="+tmp+",Sheet="+arrSheetList[i] + "!");
					}
				}
			}
		}
	    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	    obj.lsTempFormStore.load({});  //ˢ����ʱ������
	}
	
	//���ٴ�·�����ļ������ݱ�������ʱ����
	//�����ٴ�·��������ģ���ʽ��������
	obj.ImportFileData = function(fileName)
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
					col++; //col����,·���׶β�������
				}
				
				if (formCode) {
					if (SaveTempFormErr){
						SaveTempFormErr="�����ٴ�·������ʼ���ݴ���!File="+fileName+",Sheet="+arrSheetList[i] + "!" + String.fromCharCode(13) + String.fromCharCode(10) + SaveTempFormErr;
						alert(SaveTempFormErr);
					}else{
						var tmp=".."+fileName.substr(fileName.lastIndexOf('\\'),fileName.length);
						alert("�����ٴ�·������ʼ���ݳɹ�!File="+tmp+",Sheet="+arrSheetList[i] + "!");
					}
				}
			}
		}
	    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	    obj.lsTempFormStore.load({});  //ˢ����ʱ������
	}
	
	//ɾ���ٴ�·����ʱ��
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
					alert("ɾ����ʱ��ʧ��!Code="+formCode);
				}
			}
		}
		obj.lsTempFormStore.load({});  //ˢ����ʱ������
	}
	
	//���ٴ�·����ʱ����������ʽ��
	obj.btnImportForm_click = function(formCode)
	{
		//alert("���ִ̨��web.DHCCPW.MRC.ImportPathWay.SaveForm("",��ʱ�����).");
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
					alert("������ʽ��ʧ��!Code="+formCode+"Error:"+flg);
				}else{
					alert("������ʽ���ɹ�!");
					//window.parent.RefreshLeftTree();  //add by zf 20120408
				}
			}
		}
		obj.lsTempFormStore.load({});  //ˢ����ʱ������
	}
	
}

