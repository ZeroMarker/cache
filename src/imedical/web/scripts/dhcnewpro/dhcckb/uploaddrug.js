/**
*	Author: 		Qunianpeng
*	Create: 		2019/05/15
*	Description:	ҩƷ��Ϣ���뼰��ѯ
*/

/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();		/// ��ʼ�����ز��˾���ID
	InitButton();			/// ��ʼ����ť���¼�
	//InitPatInfo();			/// ��ʼ��������Ϣ
	InitDrugList();			/// ��ʼ��ҩƷ�б�
	InitDrugListGrid();		/// ��ʼ��ҩƷ�б�
	
}


/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");	
}

/// ��ʼ����ť���¼�
function InitButton(){

	/// ����
	//$('#calc').on("click",CalcClick); 

	/// ���
	$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	
	

}

/// ��ʼ��ҩƷ�б�
function InitDrugList(){
	
	runClassMethod("web.DHCCKBTpnPresc","GetDrugProjet",{},function(jsonString){
				
	},'json',false);	
}

function InitDrugListGrid(){

	/// 
	var  columns=[[    
	       	{field:'dicId',title:'ͨ����id',width:80,hidden:true},    
	        {field:'dicCode',title:'����',width:140},
	        {field:'dicDesc',title:'ͨ������(������)',width:180},
	        {field:'generKey',title:'ͨ����',width:180},
	        {field:'proName',title:'��Ʒ��',width:200},
	        {field:'factory',title:'����',width:240}
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
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBUpLoadDrug&MethodName=QueryDrugList";
	new ListComponent('druglist', columns, uniturl, option).Init();
}


/// ��ѯ
function Query(){

	var code = $("#queryCode").val().trim();
	var desc = $("#queryDesc").val().trim();
	var params = code +"^"+ desc;

	$("#druglist").datagrid("load",{"params":params});

}


/// ���룬�����س��¼�
function InputPrese(e){

	 if(e.keyCode == 13){
		Query();
	}
}

/// ��������
function UploadData(){
	
	var efilepath = $("input[name=filepath]").val();
    
    if (efilepath.indexOf("fakepath") > 0) {
	    $.messager.alert("��ʾ","����IE��ִ�е��룡","info"); 
	    return; 
	}
    if (efilepath.indexOf(".xls") <= 0) {  
    	$.messager.alert("��ʾ","��ѡ��excel����ļ���","info"); 
    	return; 
    }
    //var kbclassname = ""  // ����
    var sheetcount = 1  	// ģ���б�ĸ���
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('��ʾ', '�ļ�ѡ��Ĳ���ȷ��',"info");
        return;
    }

	try {
		var oXL = new ActiveXObject("Excel.application");
	    var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	    $.messager.alert("��ʾ",'����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!',"info");
	    return;
	}
    var errorRow = "";	//û�в������
    var errorMsg = "";	//������Ϣ
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({title:'���Ժ�',msg:'�������ڵ�����...'}); 
    
    var errMsg="",dicFlag=0;
    pid=serverCall("web.DHCCKBUpLoadDrug","UploadPid");
   
        
    for (var i = 1; i <= rowcount; i++) {
	    var tempStr = ""; //ÿ�����ݣ���һ��[next]�ڶ���[next]...��
		var row=i;
		for(var j = 1; j <=colcount; j++){
			var cellValue = ""
        	if (typeof (oSheet.Cells(j, 1).value) == "undefined") {
           	 	cellValue = "";
       		}else {
            	cellValue = oSheet.Cells(i, j).value;
        	}  
        	
        	tempStr=(tempStr=="")?cellValue:tempStr+"[next]" + cellValue;
		}
        
		if(tempStr!=""){
			console.log(tempStr)
			ret=serverCall("web.DHCCKBUpLoadDrug","UploadTmpData",{pid:pid,row:i,data:tempStr})
			
		}	
    }
    $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�

    if(errMsg!=""){
	    
	}else{
		saveData(pid);  	
	}
	
    clearFiles();
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

function saveData(pid){
	ret=serverCall("web.DHCCKBUpLoadDrug","UploadData",{pid:pid}) 
    if(ret==0){
	    $.messager.alert("��ʾ","����ɹ�");
	}else if(ret==1){
	    $.messager.alert("��ʾ","�������Դ���,���޸ı������ٵ���!");
	}else{
		$.messager.alert("��ʾ","����ʧ��");
	}
}


//����ļ��ϴ���·�� 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })