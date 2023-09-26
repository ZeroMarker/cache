
$(function(){ 
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	
	$(":radio").click(function(){
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
  	});
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'style':'input'}})
}

function save(){
	saveByDataGrid("web.DHCADVFormName","save","#datagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�');
			$("#datagrid").datagrid('reload'); 
		}else{
		 	if((data=11)||(data=12)){
				$.messager.alert('��ʾ','����ʧ��:�������Ѵ���!')
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
		}
		
	});	
}

function formItm(){
	window.location.href="dhcadv.formdic.csp"	
}
function edit(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	window.open("dhcadv.layout.csp?id="+rowsData.ID)
	//window.location.href="layout.csp?id="+rowsData.ID	
}

function remove(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ������", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFormName",
				    "remove",
					{
		 				'id':rowsData.ID
		 			},
		 			function(data){
			 			$("#datagrid").datagrid('reload'); 
					},"text");
            } 
    }); 
}
function formCat(){
	window.location.href="dhcadv.formcat.csp"
}

//���Ʊ�
function formCopy(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	$("#copyCode").val("");
	$("#copyName").val("");
	$('#copy').dialog("open");

}

function saveFormCopy(){
	if($("#copyForm").form('validate')){
		var rowsData = $("#datagrid").datagrid('getSelected')
		runClassMethod(
		"web.DHCADVFormCopy",
		"copyForm",
		{
		 'id':rowsData.ID,
		 'code':$("#copyCode").val(),
		 'name':$("#copyName").val()},
		 function(data){
			 if(data==1){
				$.messager.alert("��ʾ","�����ظ�")
			 	return;
			 }
			 if(data==2){
				$.messager.alert("��ʾ","����ʧ��")
			 	return;
			 }
			 $.messager.alert("��ʾ","����ɹ�")
			 $('#copy').dialog("close");
			 $("#datagrid").datagrid('reload'); 
		},"text");
	}
	
}


function formExp()
{

  	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}

	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
        $.messager.alert('��ʾ','����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
        return;
	}
	$.messager.progress({   //���ݵ�����ʾ
		title:'���Ժ�', 
		msg:'�������ڵ�����...' 
	}); 
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	    

	ret=serverCall("web.DHCADVFormExport","exportFormName",{id:rowsData.ID})

	retArr=ret.split(",");
	if(retArr[1]>0){
		pid=retArr[0];
		xlSheet.Cells(1,1).Value=retArr[3];
		for (k=1;k<=retArr[1];k++)
		{
			xlSheet.Cells(k+1,1).Value=serverCall("web.DHCADVFormExport","exportForm",{pid:pid,count:k});
		
		}
		xlSheet.Cells(parseInt(retArr[1])+2,1).Value="dicstart";
		for (k=1;k<=retArr[2];k++)
		{
			xlSheet.Cells(parseInt(k)+parseInt(retArr[1])+2,1).Value=serverCall("web.DHCADVFormExport","exportFormDic",{pid:pid,count:k});
		}
	}
 	
 	 $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
 	
 	  
	try
	{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
		if(fileName){
			 var ss = xlBook.SaveAs(fileName);  
		 	if (ss==false)
			{
				 $.messager.alert('��ʾ','����ʧ�ܣ�') ;
			}else{
				 $.messager.alert('��ʾ','�����ɹ���') ;
			}
		}else{
			$.messager.alert('��ʾ','����ȡ����') ;
		}
		
	}
	catch(e){
		  $.messager.alert('��ʾ','����ʧ�ܣ�') ;
	}


	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;
 	   
}


//����ļ��ϴ���·�� 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}
function formImp(){
	
	var efilepath = $("input[name=filepath]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) {alert("����IE��ִ�е��룡"); return; }
    if (efilepath.indexOf(".xls") <= 0) { alert("��ѡ��excel����ļ���"); return; }
    //var kbclassname = ""  //����
    var sheetcount = 1  //ģ���б�ĸ���
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('��ʾ', '�ļ�ѡ��Ĳ���ȷ��');
        return;
    }

	try {
	        var oXL = new ActiveXObject("Excel.application");
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
	        return;
	}
    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({title:'���Ժ�',msg:'�������ڵ�����...'}); 
    
    var errMsg="",dicFlag=0;
    pid=serverCall("web.DHCADVFormExport","importPid")
    for (var j = 1; j <= rowcount; j++) {
        var cellValue = ""
        if (typeof (oSheet.Cells(j, 1).value) == "undefined") {
            cellValue = ""
        } else {
            cellValue = oSheet.Cells(j, 1).value
        }
		if(cellValue!=""){
			if(cellValue=="dicstart"){
				dicFlag=1
			}
			ret=serverCall("web.DHCADVFormExport","importData",{pid:pid,row:j,data:cellValue,dicFlag:dicFlag})
			if(ret==1){
				errMsg=errMsg+j+"��,";
			}	
		}	
    }
    $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�

    if(errMsg!=""){
	     $.messager.confirm("������ʾ", "��"+errMsg+"���ֵ�����ϵͳ�ظ�,���Ḳ��ϵͳ�ֵ�,ȷ�ϼ�����", function (data) {  
            if (data) {  
               saveData(pid);  
            } 
        }); 
	}else{
		saveData(pid);  	
	}
	
    clearFiles ()
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

function saveData(pid){
	ret=serverCall("web.DHCADVFormExport","import",{pid:pid}) 
    if(ret==0){
	    $.messager.alert("��ʾ","����ɹ�");
	}else if(ret==1){
	    $.messager.alert("��ʾ","�������Դ���,���޸ı������ٵ���!");
	}else{
		$.messager.alert("��ʾ","����ʧ��");
	}
}
