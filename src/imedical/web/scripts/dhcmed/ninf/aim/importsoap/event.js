
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
	
	//���ٴ�·�����ļ������ݱ�������ʱ����
	//�����ٴ�·��������ģ���ʽ��������
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
				var InfoFileTitle=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(1,1); //�ļ����� �������XXXX��XX��
				if(InfoFileTitle=="")
				{
					alert("���ⲻ��Ϊ��!!");	
					return;
				}
				var ImportDataDate=InfoFileTitle.split("��")[0];
				if((ImportDataDate.length!=6)&&(ImportDataDate.length!=7))
				{
					alert("Excel�������²��ԣ��밴��XXXX��XX��....��ʽ");	
					return;
				}
				
				var StartCol=2;
				while (colNull!=-1)
				{
						var SoapCode=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(2,StartCol);
						var SoapName=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(3,StartCol);
						var SoapHlVolume=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(4,StartCol);
						var SoapHlUnit=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(5,StartCol);
						
						if(SoapCode!="�ܼ�")
						{
							if((SoapName=="")||(SoapHlVolume=="")||(SoapHlUnit==""))
							{
								alert("ϴ��Һ��������λ�����ƶ�����Ϊ��!!");	
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
					alert("Excel����������������!!");
					return;
				}
				
				var StartRow=6,rowNull="",LocSoapStr="",TotalLocSoapStr="";
				while(rowNull!=-1)
				{
					var SoapTypeNum=StartCol-1,LocSoapStr="";
					var LocStr=Ext.dhcc.DataToExcelTool.ExcelApp.ReadData(StartRow,1); //���Ҵ��롢����
					var len=LocStr.split("��").length;

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
				if(ret<0) alert("��������ʧ�ܣ�����excel��ʽ�Ƿ���ȷ!!");
				else alert("�������ݳɹ�!!");
			}
		}
	  Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	
}
	//���ٴ�·�����ļ������ݱ�������ʱ����
	//�����ٴ�·��������ģ���ʽ��������
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
				}
			}
		}
		obj.lsTempFormStore.load({});  //ˢ����ʱ������
	}
	
}

