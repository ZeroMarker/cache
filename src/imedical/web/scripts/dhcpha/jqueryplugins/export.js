/*
 *creator:yunhaibao
 *createdate:2016-05-20
 *description:easyui datagrid����
 */
 //exportwayΪ��:����д����,Ϊ1����Ԫ��д����
function ExportAllToExcel(exportGrid){
	if (exportGrid==""){
		return;
	}
	if ($('#'+exportGrid).datagrid("getRows").length<=0){
		$.messager.alert('��ʾ',"û������!","info");
		return;
	}
	var exportway=""
	var exportwaydiv="<div><form>"+
					 "<p><span><input style='vertical-align:middle' type='checkbox' class='ui-checkbox' id='chkFast' onclick='ChangeExportWay(1)' checked='true'></input></span><span style='vertical-align:middle'><font color='#0e2d5f'><b>���ٵ���</b></font>����������д������,�ٶȽϿ�,���޷�������ǰ���㣾</span></p>"+
					 "<p><span><input style='vertical-align:middle' type='checkbox' class='ui-checkbox' id='chkNormal' onclick='ChangeExportWay(2)'></input></span><span style='vertical-align:middle'><font color='#0e2d5f'><b>��������</b></font>����������Ԫ��д������,�����������ݽ�����</span></p>"+
					 "</form></div>";
	$dialog = $(exportwaydiv).dialog({     
		title: '������ʽ',     
		width: 375,     
		height: 165,     
		iconCls : '',    
		closed: true,     
		cache: false,         
		modal: true,               
		buttons : [ 
			{    
				text : 'ȷ��',    
				iconCls : 'icon-ok',    
				handler : function() { 
					var exportway="";
					if ($("input[id=chkFast]").prop("checked")){
						exportway=1;
					}
					if ($("input[id=chkNormal]").prop("checked")){
						exportway=2;
					}
					if (exportway==""){
						$.messager.alert("��ʾ","����ѡ�񵼳���ʽ","info");
						return;
					}
					ExportAllToExcelHandler(exportGrid,exportway);
					$dialog.dialog('close');                                               
				}    
			},{    
				text : 'ȡ��',    
				iconCls : 'icon-cancel',    
				handler : function() {    
					$dialog.dialog('close');    
				}    
			} 
		]  
	});  
	$("input[id=chkNormal]").prop("checked", false);  
	$("input[id=chkFast]").prop("checked", true);     
	$dialog.dialog('open'); 
}
//exportway=1:���е���,exportway=2:����Ԫ�񵼳�
function ExportAllToExcelHandler(exportGrid,exportway){
	if (exportway=="1"){
		try{
			var mscd = new ActiveXObject("MSComDlg.CommonDialog");
			mscd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
			mscd.FilterIndex = 1;
			// ��������MaxFileSize. �������
			mscd.MaxFileSize = 32767;
			// ��ʾ�Ի���
			mscd.ShowSave();
			var fileName=mscd.FileName;
			mscd=null;
		}
		catch(e)
		{
				if (confirm("��ǰϵͳ��֧�ִ���·��,�Ƿ������ļ�����?\n����ɹ���,�����������Ч!"))
				{
					var fso = new ActiveXObject("Scripting.FileSystemObject");
					var sTextfile = fso.CreateTextFile("C:\\MSCommonDialog.reg",true)
					sTextfile.WriteLine("Windows Registry Editor Version 5.00")
					sTextfile.WriteLine("[HKEY_CLASSES_ROOT\\Licenses\\4D553650-6ABE-11cf-8ADB-00AA00C00905]")
					sTextfile.WriteLine("@=\"gfjmrfkfifkmkfffrlmmgmhmnlulkmfmqkqj\"")
					sTextfile.Close();
					sTextfile=null;
					fso=null;
					var shell = new ActiveXObject("WScript.Shell"); 
					shell.Run("C:\\MSCommonDialog.reg");
					return;
					
				}
				else{
					return;					
				}
		}
	}
	if ((exportway=="1")&&(fileName=='')){return;}
	var exportGridOption=$('#'+exportGrid).datagrid("options")
	var exportGridparams=exportGridOption.queryParams.params;
	var exportGridUrl=exportGridOption.url;
	var exportGridColumn="" //�кð�
	/*$.messager.show({
		title:"��ʾ",
		msg:"���ڴ������Ժ�...'",
		timeout:3000,
		showType:'slide'
	});*/
	$.messager.progress({ 
	    title: '��ȴ�', 
	    msg: '����������...', 
	    text: '������.......' 
	});
	$.ajax({
		type: "GET",
		url: exportGridUrl+"&page=1&rows=9999&params="+exportGridparams,
		async:false,
		dataType: "json",
		success: function(exportdata){
			if (exportway=="1"){
				ExportToExcelFromJsonData(exportdata,fileName,exportGrid); 
			}else{
				ExportToExcelFromJsonDataCell(exportdata,exportGrid);
			}
			$.messager.progress('close');
		}
	});
}
function ExportToExcelFromJsonData(exportdata,fileName,exportGrid){
	//��ȡ��Ӧgrid��������
	var exportGridColumns = $('#'+exportGrid).datagrid("options").columns;
	var exportGridColumnsStr=$('#'+exportGrid).datagrid('getColumnFields',false);
	var exportGridTitleLength=exportGridColumnsStr.length;
	var exportGridTitle="",exportGridField="";
	for (var exporti=0;exporti<exportGridTitleLength;exporti++){
		var exportGridFieldi=exportGridColumnsStr[exporti]
	    var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",exportGridFieldi)
		var titleDesc=exportGridColumnOption.title;
		if (exportGridColumnOption.hidden==true){
			continue;
		}
		if (exportGridTitle==""){
			exportGridTitle=titleDesc;
			exportGridField=exportGridFieldi;
		}else{
			exportGridTitle=exportGridTitle+String.fromCharCode(9)+titleDesc;
			exportGridField=exportGridField+String.fromCharCode(9)+exportGridFieldi;
		}
	}
	var FSO=new ActiveXObject("Scripting.FileSystemObject");
	var fs = FSO.CreateTextFile(fileName,true);
	//д����
	fs.write(exportGridTitle + '\r\n');
	var tmpjsonObject = JSON.stringify(exportdata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var str = '';
    var exportGridFieldArr=exportGridField.split(String.fromCharCode(9))
    var exportGridFieldLen=exportGridFieldArr.length;
    for (var i = 0; i < colarray.length; i++) {
        var line = "";
        for (var j = 0; j < exportGridFieldLen; j++) {
	        var index=exportGridFieldArr[j];		    
	        var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",index);
			if (line != '') line +=String.fromCharCode(9);	//to xls
			var colvalue=colarray[i][index];
			//var regExpPattern=/^(-?\d*)(.?\d*)$/; 
			//if(colvalue!="" && regExpPattern.test(colvalue)){
			//	colvalue="/"+colvalue
			//}
            line +=colvalue;
        }
        fs.write(line + '\r\n');
    }
	fs.close();
}

function ExportToExcelFromJsonDataCell(exportdata,exportGrid){
	//��ȡ��Ӧgrid��������
	var oXL = new ActiveXObject("Excel.application");  
    var oWB = oXL.Workbooks.Add(); 
    var oSheet = oWB.ActiveSheet; 
    //oSheet.Cells(2,2).NumberFormatLocal = "@" 
	var exportGridColumns = $('#'+exportGrid).datagrid("options").columns;
	var exportGridColumnsStr=$('#'+exportGrid).datagrid('getColumnFields',false);
	var exportGridTitleLength=exportGridColumnsStr.length;
	var exportGridTitle="",exportGridField="",exportcol=0;
	for (var exporti=0;exporti<exportGridTitleLength;exporti++){
		var exportGridFieldi=exportGridColumnsStr[exporti]
	    var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",exportGridFieldi)
		var titleDesc=exportGridColumnOption.title;
		if (exportGridColumnOption.hidden==true){
			continue;
		}
		exportcol=exportcol+1;
		oSheet.Cells(1,exportcol).value=titleDesc; //д����
		if (exportGridField==""){
			exportGridField=exportGridFieldi;
		}else{
			exportGridField=exportGridField+String.fromCharCode(9)+exportGridFieldi;
		}
	}
	var tmpjsonObject = JSON.stringify(exportdata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var str = '';
    var exportGridFieldArr=exportGridField.split(String.fromCharCode(9))
    var exportGridFieldLen=exportGridFieldArr.length;
    for (var i = 0; i < colarray.length; i++) {
        for (var j = 0; j < exportGridFieldLen; j++) {
	        var index=exportGridFieldArr[j];		    
	        var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",index);
			var colvalue=colarray[i][index];
			var regExpPattern=/^(-?\d*)(.?\d*)$/; 
			if(colvalue!="" && regExpPattern.test(colvalue)){
				oSheet.Cells(i+2,j+1).NumberFormatLocal = "@" 
			}
            oSheet.Cells(i+2,j+1).value=colvalue; //д����
        }
    }
	oXL.Visible = true; 
	oXL.UserControl = true; 
    //�ֶ����������ռ���  
    //CollectGarbage(); 
}
function ChangeExportWay(exportway){
	if (exportway=="1"){
		$("input[id=chkNormal]").prop("checked", false);  
		$("input[id=chkFast]").prop("checked", true);  
	}else if (exportway=="2"){
		$("input[id=chkNormal]").prop("checked", true);  
		$("input[id=chkFast]").prop("checked", false); 
	}
}