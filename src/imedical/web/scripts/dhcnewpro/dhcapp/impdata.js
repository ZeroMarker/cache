
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
	
	///  ������������
	$('#ImpTree').bind("click",ImpTreeTimeOut);
	
	///  �������Ӧҽ����Ͳ�λ����
	$('#ImpArc').bind("click",ImpArcTimeOut);
	
	///  ��鲿λ����
	/// $('#ImpPart').bind("click",ImpPartTimeOut);
	
		$('#ImpPart').bind("click",ImportDataPart);   ///add by sufan 2018-12-15
		
	///  ��������ģ�嵼��
	$('#ExpTreeTemp').bind("click",ExpTreeTemp);
	
	///  �������Ӧҽ����Ͳ�λģ�嵼��
	$('#ExpArcTemp').bind("click",ExpArcTemp);
	
	///  ��鲿λģ�嵼��
	$('#ExpPartTemp').bind("click",ExpPartTemp);
	
}

///  �������Ӧҽ����Ͳ�λ����
function ImpTreeTimeOut(){
	
    $.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
	setTimeout(function(){ ImpTree()},1000)
}

///  ������������
function ImpTree(){
	
	var efilepath = $("input[name=catuploadfile]").val();
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
	$.messager.progress('close'); 
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
function ImpArc(){

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
    var colcount = 4;  //oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
	
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
}

/// ��ʱ�洢��������
function InsTmpArcGlobal(mListData){

	var ErrFlag = 0;
	runClassMethod("web.DHCEMImpTools","InsTmpArcGlobal",{"pid":pid, "mListData":mListData},function(val){
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
	objSheet=null;
}

/// �����������Ӧҽ����Ͳ�λģ��
function ExpArcTemp(){
	
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
	objSheet=null;
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
function ImpPartTree()
{
	//var efilepath = $("#filepath").val();
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
	$.messager.progress('close'); 
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
