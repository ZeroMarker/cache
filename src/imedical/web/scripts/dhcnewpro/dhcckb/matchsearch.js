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

	/// ���룬��Ʒ���س�
	//$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	$('#queryDesc').bind('keypress',InputPrese);
	
	

}

function InitDrugListGrid(){

	/// 
	var  columns=[[    
	       	{field:'num',title:'���',width:80},    
	     /*    {field:'dicCode',title:'����',width:140}, */
	        {field:'dicDesc',title:'ͨ������(������)',width:180},
	        {field:'generKey',title:'ͨ����',width:180},
	        /* {field:'proName',title:'��Ʒ��',width:200}, */
	        {field:'factory',title:'����',width:240},
	       {field:'matchFlag',title:'��ע',width:120}
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
	
	var uniturl = $URL+"?ClassName=web.DHCCKBMatchSearch&MethodName=QueryDrugList";
	new ListComponent('druglist', columns, uniturl, option).Init();
}


/// ��ѯ
function Query(){

	
	var code = "" //$("#queryCode").val().trim();
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
   
    //$.messager.progress({title:'���Ժ�',msg:'��������ƥ����.',text: 'ƥ����....'});   
   
    var errMsg="",dicFlag=0;
    pid=serverCall("web.DHCCKBMatchSearch","MatchDataPid");  
      
    for (var i = 1; i <= rowcount; i++) {
	    var tempStr = ""; //ÿ�����ݣ���һ��[next]�ڶ���[next]...��
		var row=i;
		var seqNo="";
		for(var j = 1; j <=4; j++){
			seqNo=oSheet.Cells(i+1, i).value;		// ���
			var cellValue = ""
        	if (typeof (oSheet.Cells(j, 1).value) == "undefined") {
           	 	cellValue = "";
       		}else {
            	cellValue = oSheet.Cells(i, j).value;
        	}  
        	
        	tempStr=(tempStr=="")?cellValue:tempStr+"[next]" + cellValue;
		}
        
		if(tempStr!=""){
			ret=serverCall("web.DHCCKBMatchSearch","MatchTmpData",{pid:pid,row:row,data:tempStr})
			
		}	
    }
    //$.messager.progress('close');	//���ݵ�����ɹرռ��ؿ�
		
    if(errMsg!=""){
	    
	}else{
		MatchSearch(pid);  	
	}
	
    clearFiles();
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

function MatchSearch(pid){
	ret=serverCall("web.DHCCKBMatchSearch","MatchSearch",{pid:pid});
    if(ret>0){
	    $.messager.alert("��ʾ","ƥ����ɣ�");
	}else{
		$.messager.alert("��ʾ","ƥ��ʧ�ܣ�");	
	}
	Query();
}


//����ļ��ϴ���·�� 
function clearFiles(){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })