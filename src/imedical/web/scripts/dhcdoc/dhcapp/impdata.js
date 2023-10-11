
//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2017-07-13
// ����:	   ������뵼�����
//===========================================================================================

var pid = "1";
/// ҳ���ʼ������
function initPageDefault(){
	initBlButton();       ///  ҳ��Button���¼�
}

/// ҳ�� Button ���¼�
function initBlButton(){
	$("#ImpTrePath").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			//readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
		}
	})
	///  ������������
	//$('#ImpTree').bind("click",ImpTreeTimeOut);
	$('#ImpTree').click(function() {
		var files = $("#ImpTrePath").filebox("files")
		if (files.length == 0) {
			$.messager.alert("��ʾ", "��ѡ�� Excel �ļ�!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], ImpTree)
	})
	///  �������Ӧҽ����Ͳ�λ����
	$("#ImpArcPath").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			//readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
		}
	})
	//$('#ImpArc').bind("click",ImpArcTimeOut);
	$('#ImpArc').click(function() {
		var files = $("#ImpArcPath").filebox("files")
		if (files.length == 0) {
			$.messager.alert("��ʾ", "��ѡ�� Excel �ļ�!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], ImpArc)
	})
	///  ��鲿λ����
	/// $('#ImpPart').bind("click",ImpPartTimeOut);
	$("#ImpPartPath").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			//readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
		}
	})
	//$('#ImpPart').bind("click",ImportDataPart);   ///add by sufan 2018-12-15
	$('#ImpPart').click(function() {
		var files = $("#ImpPartPath").filebox("files")
		if (files.length == 0) {
			$.messager.alert("��ʾ", "��ѡ�� Excel �ļ�!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], ImpPartTree)
	})	
	///  ��������ģ�嵼��
	$('#ExpTreeTemp').bind("click",ExpTreeTemp);
	
	///  �������Ӧҽ����Ͳ�λģ�嵼��
	$('#ExpArcTemp').bind("click",ExpArcTemp);
	
	///  ��鲿λģ�嵼��
	$('#ExpPartTemp').bind("click",ExpPartTemp);
	
	/// ������������
	$('#ExpTree').bind("click",ExpAPPTree);
	
}

///  �������Ӧҽ����Ͳ�λ����
function ImpTreeTimeOut(){
	
    $.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
	setTimeout(function(){ ImpTree()},1000)
}
function readWorkbookFromLocal(file, callBackFun) {
	var reader = new FileReader()
	if (reader.readAsBinaryString) {
		reader.readAsBinaryString(file)
		reader.onload = function(e) {
			const data = e.target.result
			var workbook = XLSX.read(data, { type: 'binary' })
            callBackFun(workbook)
		}
	} else {
		reader.readAsArrayBuffer(file)
		reader.onload = function(e) {
			const data = e.target.result
			var workbook = XLSX.read(data, { type: 'array' })
			callBackFun(workbook)
		}
	}
}
///  ������������
function ImpTree(workbook){
	$.messager.progress({
		title: "��ʾ",
		msg: '���ڵ�������',
		text: '������....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var success = 0
	var rows = csv.split("\n")
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			var resVal = InsTmpGlobal(excelRow);
			if (resVal == -2){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ�ҽԺ��Ϣ�쳣");
			}else if (resVal == -3){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ������ظ������ʵ");
			}else if (resVal < 0){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ����ݴ������ʵ");
			}
			if (resVal != 0){
				success = -1;
				//break;
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('��ʾ', "��" + blackLines.length + "���У����ȴ���Excel���У�", "info")
		$.messager.progress("close");
		return false;
	}
	if (success == "-1"){
		killTmpGlobal();  /// �����ʱglobal
		/// �رռ��ؿ�
		$.messager.progress('close'); 
		return;
	}
	InsTreeData(pid);
	$.messager.progress("close");
	
	/*var efilepath = $("input[name=catuploadfile]").val();
    if (efilepath.indexOf("fakepath") > 0){
	   $.messager.alert('��ʾ',"����IE��ִ�е��룡");
	   $.messager.progress('close'); 
	   return;
	}
    if ((efilepath.indexOf(".xls") == "-1")&(efilepath.indexOf(".xlsx") == "-1")) {
	   $.messager.alert('��ʾ',"��ѡ��excel����ļ���");
	   $.messager.progress('close'); 
	   return;
	}

	try {
		var oXL = new ActiveXObject("Excel.application");
		var oWB = oXL.Workbooks.open(efilepath);
	}catch (e) {
		$.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
		$.messager.progress('close'); 
		return;
	}

    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = 6; //oXL.Worksheets(1).UsedRange.Cells.Columns.Count;

	var success = 0;
	/// �������
	for(var i=2; i <= rowcount; i++){
		
		//$("#messager-p-msg").text("���ڵ����" + (i - 1) + "������...")
		/// ҽԺ����Ϊ��,�˳�������һ��
		if (typeof (oSheet.Cells(i, 1).value) == "") break;
		var mListArr = [];
		for(var j=1; j <= colcount; j++){
	        var cellValue = ""
            if (typeof (oSheet.Cells(i, j).value) != "undefined") {
                cellValue = oSheet.Cells(i, j).value
            }
            mListArr.push(cellValue);
		}
		
		var resVal = InsTmpGlobal(mListArr.join("^"));
		if (resVal == -2){
			$.messager.alert('��ʾ',"��"+ i +"�����ݣ�ҽԺ��Ϣ�쳣");
		}else if (resVal == -3){
			$.messager.alert('��ʾ',"��"+ i +"�����ݣ������ظ������ʵ");
		}else if (resVal < 0){
			$.messager.alert('��ʾ',"��"+ i +"�����ݣ����ݴ������ʵ");
		}
		
		if (resVal != 0){
			success = -1;
			break;
		}
	}
	
	if (success == "-1"){
		/// �رչ�����
		oWB.Close(savechanges = false);
		oXL.Quit();
		oXL = null;
		oSheet = null;
		killTmpGlobal();  /// �����ʱglobal
		/// �رռ��ؿ�
		$.messager.progress('close'); 
		return;
	}
	
	/// ��������
	InsTreeData(pid);
	
	/// �رչ�����
	oWB.Close(savechanges = false);
	oXL.Quit();
	oXL = null;
	oSheet = null;
            
	/// �رռ��ؿ�
	$.messager.progress('close'); */
	
}

/// ��ʱ�洢������Ŀ
function InsTmpGlobal(mListData){

	var ErrFlag = 0;
	runClassMethod("web.DHCEMImpTools","InsTmpGlobal",{"pid":pid, "mListData":mListData},function(val){
		ErrFlag = val;
	},'',false)

	return ErrFlag;
}

/// ��ʱ�洢������Ŀ
function InsTreeData(pid){

	runClassMethod("web.DHCEMImpTools","InsTreeData",{"pid":pid},function(val){
		if (val != 0){
			$.messager.alert('��ʾ',val);
		}else{
			$.messager.alert('��ʾ','����ɹ���');
		}
	},'',false)

}

///  �������Ӧҽ����Ͳ�λ����
function ImpArcTimeOut(){
	
    $.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
	setTimeout(function(){ ImpArc() },1000)
}
///  �������Ӧҽ����Ͳ�λ����
function ImpArc(workbook){
	$.messager.progress({
		title: "��ʾ",
		msg: '���ڵ�������',
		text: '������....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var rows = csv.split("\n")
	var success=0
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			var resVal = InsTmpArcGlobal(excelRow);
			if (resVal == "-1"){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ��������Ʋ�����");
			}else if ((resVal == "-2")||(resVal == "-3")){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ������Ŀ������");
			}else if (resVal == "-4"){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ������Ŀ���ܶ���һ����λ");
			}else if (resVal == "-5"){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ�ҽԺ����ά��");
			}else if (resVal == "-6"){
				$.messager.alert('��ʾ',"��"+ row +"�����ݣ������Ŀ���ܺ�ҽԺ��Ӧ");
			}
			
			if (resVal != 0){
				success = -1;
				//break;
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('��ʾ', "��" + blackLines.length + "���У����ȴ���Excel���У�", "info")
		$.messager.progress("close");
		return false;
	}
	if (success == "-1"){
		killTmpGlobal();  /// �����ʱglobal
		/// �رռ��ؿ�
		$.messager.progress('close'); 
		return;
	}
	InsTreeArcData(pid);
	$.messager.progress("close");
	
	/*
	var efilepath = $("input[name=arcuploadfile]").val();
    if (efilepath.indexOf("fakepath") > 0){
	   $.messager.alert('��ʾ',"����IE��ִ�е��룡");
	   $.messager.progress('close'); 
	   return;
	}
	
    if ((efilepath.indexOf(".xls") == "-1")&(efilepath.indexOf(".xlsx") == "-1")) {
	   $.messager.alert('��ʾ',"��ѡ��excel����ļ���");
	   $.messager.progress('close'); 
	   return;
	}

	try {
		var oXL = new ActiveXObject("Excel.application");
		var oWB = oXL.Workbooks.open(efilepath);
	}catch (e) {
		$.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
		$.messager.progress('close'); 
		return;
	}

    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = 5;  //oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
	
	var success = 0;
	/// �������
	for(var i=2; i <= rowcount; i++){
		
		/// ��Ŀ����Ϊ��,�˳�������һ��
		if (typeof (oSheet.Cells(i, 1).value) == "") break;
		var mListArr = [];
		for(var j=1; j <= colcount; j++){
	        var cellValue = ""
            if (typeof (oSheet.Cells(i, j).value) != "undefined") {
                cellValue = oSheet.Cells(i, j).value
            }
            mListArr.push(cellValue);
		}

		var resVal = InsTmpArcGlobal(mListArr.join("^"));
		if (resVal == "-1"){
			$.messager.alert('��ʾ',"��"+ (i-1) +"�����ݣ��������Ʋ�����");
		}else if ((resVal == "-2")||(resVal == "-3")){
			$.messager.alert('��ʾ',"��"+ (i-1) +"�����ݣ������Ŀ������");
		}else if (resVal == "-4"){
			$.messager.alert('��ʾ',"��"+ (i-1) +"�����ݣ������Ŀ���ܶ���һ����λ");
		}else if (resVal == "-5"){
			$.messager.alert('��ʾ',"��"+ (i-1) +"�����ݣ�ҽԺ����ά��");
		}else if (resVal == "-6"){
			$.messager.alert('��ʾ',"��"+ (i-1) +"�����ݣ������Ŀ���ܺ�ҽԺ��Ӧ");
		}
		
		if (resVal != 0){
			success = -1;
			break;
		}
	}

	if (success == "-1"){
		/// �رչ�����
		oWB.Close(savechanges = false);
		oXL.Quit();
		oXL = null;
		oSheet = null;
		killTmpGlobal();  /// �����ʱglobal
		/// �رռ��ؿ�
		$.messager.progress('close'); 
		return;
	}
	
	/// ��������
	InsTreeArcData(pid);
	
	/// �رչ�����
	oWB.Close(savechanges = false);
	oXL.Quit();
	oXL = null;
	oSheet = null;
            
	/// �رռ��ؿ�
	$.messager.progress('close'); 
	*/
}

/// ��ʱ�洢��������
function InsTmpArcGlobal(mListData){

	var ErrFlag = 0;
	var HospID = session['LOGON.HOSPID']
	runClassMethod("web.DHCEMImpTools","InsTmpArcGlobal",{"pid":pid, "mListData":mListData,"HospID":HospID},function(val){
		ErrFlag = val;
	},'',false)

	return ErrFlag;
}

/// ��ʱ�洢������Ŀ
function InsTreeArcData(pid){

	runClassMethod("web.DHCEMImpTools","InsTreeArcData",{"pid":pid},function(val){
		if (val != 0){
			$.messager.alert('��ʾ',val);
		}else{
			$.messager.alert('��ʾ','����ɹ���');
		}
	},'',false)

}

//����ļ��ϴ���·�� 
function clearFiles(FilePath){
	var file = $("#"+ FilePath);
	file.after(file.clone().val(""));      
	file.remove();
}

/// ������������ģ��
function ExpTreeTemp(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// ��ʾͨ��DLL����Excel����֧��IE��Chromeϵ��Chromeϵ������밲װ�м��
		// ResultSetTypeDo:"Print",    		// Ĭ��Export����������Ϊ��PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\��ʾ�̶��ļ�·��, "Self"��ʾ�û�����ʱѡ�񱣴�·����Ĭ�ϱ��浽����
		ExcelName: "��������ģ��",
		PageName: "web.DHCEMImpTools:FindAPPTreeTemp",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindAPPTreeTemp",
	    rows:10
	},function(data){
		$.messager.popover({
			msg: 'ģ�����سɹ�����������������',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
	/*
	//1������·��
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","��ѡ��·����,���ԣ�","error");
		return;
	}
	
	//2����ȡXLS��ӡ·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCAPP_TreeTemp.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;

	//3��ҳ��ֱ�Ӵ�
	//xlApp.Visible = true;
	//xlApp=null;
	//objSheet=null;
	
	xlBook.SaveAs(filePath+"DHCAPP_TreeTemp.xlsx");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;*/
	
}

/// �����������Ӧҽ����Ͳ�λģ��
function ExpArcTemp(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// ��ʾͨ��DLL����Excel����֧��IE��Chromeϵ��Chromeϵ������밲װ�м��
		// ResultSetTypeDo:"Print",    		// Ĭ��Export����������Ϊ��PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\��ʾ�̶��ļ�·��, "Self"��ʾ�û�����ʱѡ�񱣴�·����Ĭ�ϱ��浽����
		ExcelName: "���ҽ����Ͳ�λģ��",
		PageName: "web.DHCEMImpTools:FindArcTemp",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindArcTemp",
	    rows:10
	},function(data){
		$.messager.popover({
			msg: 'ģ�����سɹ�����������������',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
	/*
	//1������·��
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","��ѡ��·����,���ԣ�","error");
		return;
	}
	
	//2����ȡXLS��ӡ·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCAPP_ArcTemp.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	//3��ҳ��ֱ�Ӵ�
	//xlApp.Visible = true;
	//xlApp=null;
	//objSheet=null;
	
	xlBook.SaveAs(filePath+"DHCAPP_ArcTemp.xlsx");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;*/
}

///  �������Ӧҽ����Ͳ�λ���� 
function ImpPartTimeOut(){
	
    $.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
	setTimeout(function(){ ImpPart() },1000)
}

///  �������Ӧҽ����Ͳ�λ����
function ImpPart(){
	
	var efilepath = $("input[name=partuploadfile]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) 
	{
		alert("����IE��ִ�е��룡"); 
		$.messager.progress('close');    ///sufan add 2017-12-10
		return; 
	}
    if (efilepath.indexOf(".xls") <= 0) 
	{ 
		alert("��ѡ��excel����ļ���"); 
		$.messager.progress('close');    ///sufan add 2017-12-10
		return; 
	}
    //var kbclassname = ""  //����
    var sheetcount = 1  //ģ���б�ĸ���
	/*
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename != "DHCAPP_PartTemp.xlsx")&&(filename != "DHCAPP_PartTemp.xls")) {
	    clearFiles ("ImpPartPath")
        $.messager.alert('��ʾ', '�ļ�ѡ��Ĳ���ȷ��');
		$.messager.progress('close');    ///sufan add 2017-12-10
        return;
    }
	*/

  try {
        var oXL = new ActiveXObject("Excel.application");
        var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
  }catch (e) {
        $.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
		$.messager.progress('close');    ///sufan add 2017-12-10
        return;
  }

    var sheet_id = 1
    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(sheet_id).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count;
    var colcount = 5;  /// oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({   //���ݵ�����ʾ
		title:'���Ժ�', 
		msg:'�������ڵ�����...' 
	}); 
    
    var inserToDB = function (i) { 
        if (i == rowcount+1) {
            //if (errorRow != "") {
               // errorMsg = oSheet.name + "������ɣ���" + errorRow + "�в���ʧ��!";
            //} else {
	            clearFiles ("ImpPartPath")
                errorMsg = oSheet.name + "�������!"
                $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
           // }
            //alert(errorMsg)

            oWB.Close(savechanges = false);
            //CollectGarbage();
            oXL.Quit();
            oXL = null;
            oSheet = null;
        }else {
			var tempStr = ""; //ÿ�����ݣ���һ��[next]�ڶ���[next]...��
			var row=i
            for (var j = 1; j <= colcount; j++) {
                var cellValue = ""
                if (typeof (oSheet.Cells(i, j).value) == "undefined") {
                    cellValue = ""
                } else {
                    cellValue = oSheet.Cells(i, j).value
                }

                tempStr += (cellValue + "[next]")
               
            }
              runClassMethod(
                    "web.DHCEMImpTools",
                    "SaveData",
                    { "dataStr": tempStr, "sheetid": sheet_id, "row": row, "HospID": LgHospID},
                    function (Flag) {
                             //alert(Flag)
                        if (Flag == true) {  
                            errorRow = errorRow             

                        } else {
                            if (errorRow != "") {
                                errorRow = errorRow + "," + i
                            } else {
                                errorRow = i
                            }
                            
                        }
                           i=i+1;
                           inserToDB(i);    
         
                });

        }
       
    } 
    inserToDB(1);
  
}

/// �����������Ӧҽ����Ͳ�λģ��
function ExpPartTemp(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// ��ʾͨ��DLL����Excel����֧��IE��Chromeϵ��Chromeϵ������밲װ�м��
		// ResultSetTypeDo:"Print",    		// Ĭ��Export����������Ϊ��PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\��ʾ�̶��ļ�·��, "Self"��ʾ�û�����ʱѡ�񱣴�·����Ĭ�ϱ��浽����
		ExcelName: "��鲿λģ��",
		PageName: "web.DHCEMImpTools:FindPartTemp",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindPartTemp",
	    rows:9999
	},function(data){
		$.messager.popover({
			msg: 'ģ�����سɹ�����������������',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
	/*
	//1������·��
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","��ѡ��·����,���ԣ�","error");
		return;
	}
	
	//2����ȡXLS��ӡ·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCAPP_PartTemp.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	//3��ҳ��ֱ�Ӵ�
	//xlApp.Visible = true;
	//xlApp=null;
	//objSheet=null;
	
	xlBook.SaveAs(filePath+"DHCAPP_PartTemp.xlsx");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
	*/
}

/// ����·��ѡ���
function browseFolder(){
	  
  try {  
	  var Message = "��ѡ��·��"; //ѡ�����ʾ��Ϣ  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//��ʼĿ¼Ϊ���ҵĵ���  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // ���� FolderItems ����  
		  Folder = Folder.item();  // ���� Folderitem ����  
		  Folder = Folder.Path;    // ����·��  
		  if (Folder.charAt(Folder.length - 1) != "\\"){  
			  Folder = Folder + "\\";  
		  }    
		  return Folder;  
	  }  
  }catch(e){  
	  alert(e.message);  
  }  
}


// ���벿λ�е�����  add by sufan 2018-12-15
function ImportDataPart() {
   $.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
   setTimeout(function(){ ImpPartTree()},1000)
  
}
function ImpPartTree(workbook)
{
	$.messager.progress({
		title: "��ʾ",
		msg: '���ڵ�������',
		text: '������....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var rows = csv.split("\n")
	var success=0
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			var resVal = InsPartTmpGlobal(excelRow);
			if (resVal == "-1"){
				$.messager.alert('��ʾ',"��"+ i +"�����ݣ������ظ������ʵ");
			}else if (resVal == "-2"){
				$.messager.alert('��ʾ',"��"+ i +"�����ݣ������ظ������ʵ");
			}else if (resVal == "-5"){
				$.messager.alert('��ʾ',"��"+ i +"�����ݣ�����Ϊ�գ����ʵ");
			}
			
			if (resVal != 0){
				success = -1;
				//break;
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('��ʾ', "��" + blackLines.length + "���У����ȴ���Excel���У�", "info")
		$.messager.progress("close");
		return false;
	}
	if (success == "-1"){
		killTmpGlobal();  /// �����ʱglobal
		/// �رռ��ؿ�
		$.messager.progress('close'); 
		return;
	}
	InsPartData(pid)
	$.messager.progress("close");
	
	
	//var efilepath = $("#filepath").val();
	/*
	var efilepath = $("input[name=partuploadfile]").val();
    if (efilepath.indexOf("fakepath") > 0){
	   $.messager.alert('��ʾ',"����IE��ִ�е��룡");
	   $.messager.progress('close'); 
	   return;
	}

    if ((efilepath.indexOf(".xls") == "-1")&(efilepath.indexOf(".xlsx") == "-1")) {
	   $.messager.alert('��ʾ',"��ѡ��excel����ļ���");
	   $.messager.progress('close'); 
	   return;
	}

	try {
		var oXL = new ActiveXObject("Excel.application");
		var oWB = oXL.Workbooks.open(efilepath);
	}catch (e) {
		$.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
		$.messager.progress('close'); 
		return;
	}

    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;

	var success = 0;
	/// �������
	for(var i=2; i <= rowcount; i++){
		var mListArr = [];
		for(var j=1; j <= colcount; j++){
	        var cellValue = ""
            if (typeof (oSheet.Cells(i, j).value) != "undefined") {
                cellValue = oSheet.Cells(i, j).value
            }
            if(cellValue=="") break;
            mListArr.push(cellValue);
		}
		
		var resVal = InsPartTmpGlobal(mListArr.join("^"));
		if (resVal == "-1"){
			$.messager.alert('��ʾ',"��"+ i +"�����ݣ������ظ������ʵ");
		}else if (resVal == "-2"){
			$.messager.alert('��ʾ',"��"+ i +"�����ݣ������ظ������ʵ");
		}else if (resVal == "-5"){
			$.messager.alert('��ʾ',"��"+ i +"�����ݣ�����Ϊ�գ����ʵ");
		}
		
		if (resVal != 0){
			success = -1;
			break;
		}
	}
	
	if (success == "-1"){
		/// �رչ�����
		oWB.Close(savechanges = false);
		oXL.Quit();
		oXL = null;
		oSheet = null;
		killTmpGlobal();  /// �����ʱglobal
		/// �رռ��ؿ�
		$.messager.progress('close'); 
		return;
	}
	
	/// ��������
	InsPartData(pid)
	/// �رչ�����
	oWB.Close(savechanges = false);
	oXL.Quit();
	oXL = null;
	oSheet = null;
            
	/// �رռ��ؿ�
	$.messager.progress('close'); */
}
/// ��λ���ݴ洢
function InsPartTmpGlobal(mListData){
	//alert(mListData)
	var ErrFlag = 0;
	runClassMethod("web.DHCEMImpTools","InsPartTmpGlobal",{"pid":pid, "mListData":mListData},function(val){
	//alert(val+"sufan")
		ErrFlag = val;
	},'text',false)

	return ErrFlag;
}
/// ����
function InsPartData(pid){
	
	runClassMethod("web.DHCEMImpTools","InsPartData",{"pid":pid},function(val){
		//alert(val+"daoru")
		if (val != 0){
			$.messager.alert('��ʾ',val);
		}else{
			$.messager.alert('��ʾ','����ɹ���');
		}
	},'text',false)

}
/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCEMImpTools","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    killTmpGlobal();  /// �����ʱglobal
}
function ExpAPPTree(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// ��ʾͨ��DLL����Excel����֧��IE��Chromeϵ��Chromeϵ������밲װ�м��
		// ResultSetTypeDo:"Print",    		// Ĭ��Export����������Ϊ��PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\��ʾ�̶��ļ�·��, "Self"��ʾ�û�����ʱѡ�񱣴�·����Ĭ�ϱ��浽����
		ExcelName: "���������",
		PageName: "web.DHCEMImpTools:FindAPPTree",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindAPPTree",
		HospID:session['LOGON.HOSPID'],
	    rows:9999
	},function(data){
		$.messager.popover({
			msg: 'ģ�����سɹ�����������������',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
