///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2020/01/09
//*	Description:	ICD��϶��յ��뵼��
///****************************************
/// ҳ���ʼ������
function initPageDefault(){
	InitLinkList();
}
/// ��ʼ��������
function InitLinkList(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[    
	       	{field:'AllNum',title:'�ļ���������',width:140},    
	     	{field:'msg',title:'������Ϣ',width:200}
	        
	    ]]
	
	///  ����datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:20,
	    pageList:[20,40,100],
	    fit:true,	
	    //checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
     
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBIcdImport&MethodName=GetErrList";
	new ListComponent('linklist', columns, uniturl, option).Init();
}

/// ��������
function formImp(){
	var efilepath = $("input[name=filepath]").val();
    if (efilepath.indexOf("fakepath") > 0) {$.messager.alert('��ʾ',"����IE��ִ�е��룡"); return; }
    if (efilepath.indexOf(".xls") <= 0) { $.messager.alert('��ʾ',"��ѡ��excel����ļ���"); return; }
    var sheetcount = 1  //ģ���б�ĸ���
    var file = efilepath.split("\\");
    var filename = file[file.length - 1]; //����ѡ���ϴ��ļ��ĸ�ʽ�������ָ�ʽ��excl�ļ�
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('��ʾ', '�ļ�ѡ��Ĳ���ȷ��');
        return;
    }
	try {
	        var oXL = new ActiveXObject("Excel.application"); //ͨ��ActiveX��ʽ��ȡexcl�ļ�
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
	        return;
	}
    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(1).select();//Ĭ��ѡ�еı��sheet1
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
	var ProgressText='';
	$('#pro').progressbar({
		text:"���ڴ����У����Ժ�...",
	    value: 0
	});
	alert("��ʼ����!");
	var impAllData="";
    for (var j = 2; j <= rowcount; j++) {
        var rowData="";
        var row = j;
		for(k =1;k<=colcount;k++){
			var cellValue = "";
			if (typeof (oSheet.Cells(j, k).value) == "undefined") {
				cellValue = ""
			}else{
				cellValue = oSheet.Cells(j, k).value
			}
			rowData==""?rowData=cellValue:rowData=rowData+"^"+cellValue;
			
		}
		
		Flag=SaveRowData(rowData,row,rowcount)
		console.log(Flag);
		//impAllData==""?impAllData=rowData:impAllData=impAllData+"@@"+rowData;
		if (Flag=="0"){
				errorRow=errorRow	
			}else{
				if(errorRow!=""){
					errorRow=errorRow+","+(row-1)
				}else{
					errorRow=(row-1)
				}
			}
			rowData=""
			progressText = "���ڵ���"+oSheet.name+"��ĵ�"+(row-1)+"����¼,�ܹ�"+(rowcount-1)+"����¼!";  

			//$('#pro').attr('text', progressText);

		    //$('#pro').attr('text', progressText);
		    if(errorRow!="")  //������һ��������Ϣ �˳�������TMPERR ���س�������Ϣ
		    {
			    
				  runClassMethod("web.DHCCKBIcdImport","SaveErr",{"errorRow":(row-1)},function(val){
				  })
			} 
			if(row==rowcount) //���������һ���˳�
			{
				if(errorRow!=""){
					errorMsg=oSheet.name+"������ɣ���"+errorRow+"�в���ʧ��!" ;
					$("#linklist").datagrid('reload'); 			
				}else{
					errorMsg=oSheet.name+"�������!"
				}
				$('#pro').progressbar('setValue', 100); 
				debugger;
				progressText = "���ڵ���"+oSheet.name+"��ļ�¼,�ܹ�"+rowcount+"����¼!";  
				$('#pro').attr('text', progressText); 
				alert(errorMsg)
				oWB.Close(savechanges=false);
				CollectGarbage();
				oXL.Quit(); 
				oXL=null;
				oSheet=null;
    }
   
	//name,10;name2,20...
	//Save(impAllData,rowcount)
   // $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
 
}
 	clearFiles();
}
	
 //����ļ��ϴ���·�� 
function clearFiles(){
      $('#filepath').filebox('clear');
     
} 

//�Ż��е���
function SaveRowData(rowData,row,rowcount){
	var value = $('#pro').progressbar('getValue');
			if (value < 100){
	   		 	value = ((row-1)/(rowcount-1))*100;
	   		 	value =parseInt(value)
	   		 	$('#pro').progressbar('setValue', value);
			}
	var ErrFlag = "";

	runClassMethod("web.DHCCKBIcdImport","SaveIcdRowData",{"rowData":rowData,"hospID":LgHospID},function(val){
		var retObj=val
		if (retObj.code == "success"){
			ErrFlag=0
		}
		else{
			ErrFlag=1
		}
		//$("#linklist").datagrid("reload");
	},"json",false)
	
	return ErrFlag;}

/// �洢����
function Save(impAllData,rowcount){
   
	var ErrFlag = 0;

	runClassMethod("web.DHCCKBIcdImport","SaveIcd",{"impAllData":impAllData,"rowcount":rowcount},function(val){
		//var retObj = JSON.parse(val);
		//$.messager.progress('close');
		
		var retObj=val
		if (retObj.code =="success"){
			$.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
			$.messager.alert("��ʾ:","����ɹ�."+"����"+retObj.total+"����,  �ɹ���"+retObj.successNum+"����.  "+"ʧ�ܡ�"+retObj.errNum+"����","info");
		}
		else{
			$.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
			$.messager.alert("��ʾ:","����ʧ��."+"ʧ��ԭ��"+retObj.msg,"info");
			ErrFlag=1
		}
		$("#linklist").datagrid("reload");
	},"json")
	
	return ErrFlag;
}


function JsonToArr(obj,spec){

	// ����typeof�ж϶���Ҳ��̫׼ȷ
	/*
	���ʽ	                      ����ֵ
	typeof undefined	       'undefined'
	typeof null	               'object'
	typeof true	               'boolean'
	typeof 123	               'number'
	typeof "abc"	           'string'
	typeof function() {}	   'function'
	typeof {}	               'object'
	typeof []	               'object'
	*/
	
	var val=(Object.prototype.toString.call(obj) === '[Object Object]')?0:1;
	val=(JSON.stringify(obj) == "{}")?1:0;
	
	if (val){
		return "";
	}
	var strArr = [];
	for (k in obj){
		var tmpStr = k + spec + obj[k];		// {"test":"1"}-> test$c(1)1
		strArr.push(tmpStr);
	}
	
	return strArr;
	
}




/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
