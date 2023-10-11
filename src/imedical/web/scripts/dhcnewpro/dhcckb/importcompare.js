///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2020/01/09
//*	Description:	���յ������
///****************************************
/// ҳ���ʼ������
var DicCode="";
var DicDesc="";
var DicRowID="";
var spac  = "^"	 /// �ָ���
var rowFlag = "[row]"	 /// �ָ���
var mDel1 = "^"  //String.fromCharCode(1);  /// �ָ���
var mDel2 = "@@"  //String.fromCharCode(2);
function initPageDefault(){
	InitLinkList();
	InitCombobox();
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
/// ��ʼ��LookUp
function InitCombobox(){
	// ��ʼ�����Ϳ�
	var genType = $("#genType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CDRowID',
        textField:'CDDesc',
        columns:[[
        	{field:'CDRowID',title:'CDRowID',hidden:true},
            {field:'CDCode',title:'����',width:190},
			{field:'CDDesc',title:'����',width:190}
        ]], 
        pagination:true,
        panelWidth:420,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCCKBGenItem',QueryName: 'GetTypeList'},
	    onSelect:function(index, rec){
		    DicCode=rec["CDCode"];
		    DicDesc=rec["CDDesc"];
		    DicRowID=rec["CDRowID"]
		    //alert(DicCode+"  "+DicDesc+"  "+DicRowID)
		}
    });
    
    ///����Ժ��sufan 2020-07-15
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
	     url:uniturl,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
							
						}
	   })
}
/// ��������
function formImp(){
	if((DicCode=="")||(DicRowID=="")){$.messager.alert('��ʾ',"��ѡ�����������ͣ�");return; }
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
	debugger;
	var ReadLine="";
		for(k =1;k<=colcount;k++){
			var cellValue = "";
			if (typeof (oSheet.Cells(1, k).value) == "undefined") {
				cellValue = ""
			}else{
				cellValue = oSheet.Cells(1, k).value
			}
			ReadLine==""?ReadLine=cellValue:ReadLine=ReadLine+"^"+cellValue;
				
		}
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
			rowData==""?rowData=ReadLine.split("^")[k-1]+"^"+cellValue:rowData=rowData+"^"+ReadLine.split("^")[k-1]+"^"+cellValue;
			
		}
		
		Flag=SaveRowData(rowData,row,rowcount)
		
		//impAllData==""?impAllData=rowData:impAllData=impAllData+"@@"+rowData;
		if (Flag=="0"){
			if(errorRow!=""){
					errorRow=errorRow+","+(row-1)
				}else{
					errorRow=(row-1)
				}
			}
			/*else{			//sufan ����else�ж�
					$.messager.alert("��ʾ","��"+rowcount+"���������󣬴�����ϢΪ��"+Flag);
					return false;
			}
			*/  //else Ϊ1�ǳɹ�����������ʾ shy
			rowData=""
			progressText = "���ڵ���"+oSheet.name+"��ĵ�"+(row-1)+"����¼,�ܹ�"+(rowcount-1)+"����¼!";  
		    if(Flag=="0")  //������һ��������Ϣ �˳�������TMPERR ���س�������Ϣ
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
				progressText = "���ڵ���"+oSheet.name+"��ļ�¼,�ܹ�"+rowcount+"����¼!";  
				$('#pro').attr('text', progressText); 
				alert(errorMsg)
				oWB.Close(savechanges=false);
				CollectGarbage();
				oXL.Quit(); 
				oXL=null;
				oSheet=null;
    }
 
}
 	clearFiles();
}
	
 //����ļ��ϴ���·�� 
function clearFiles(){
      $('#filepath').filebox('clear');
     
} 

//�Ż��е��루��ν�����
function SaveRowData(rowData,row,rowcount){
		var value = $('#pro').progressbar('getValue');
			if (value < 100){
	   		 	value = ((row)/(rowcount-1))*100;
	   		 	value =parseInt(value)
	   		 	$('#pro').progressbar('setValue', value);
			}
			
	
	var ErrFlag = serverCall("web.DHCCKBImportCompare","SavedrugRowData",{"rowData":rowData,"hospDesc":LgHospDesc,"dicCode":DicCode,"dicRowID":DicRowID,"LgUserID":LgUserID,"LgHospID":LgHospID,"ClientIPAddress":ClientIPAdd})
	return 1;
}

/// �洢����-����������һ�η��ʺ�̨��
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

///����������Ϣ  sufan 2020-07-22
function formexport()
{
	if(DicCode == ""){
		$.messager.alert('��ʾ',"����ѡ��Ҫ���������ͣ�");
		return;
	}
	
	var excelName = "��������"+DicCode;
	var hosp = $HUI.combobox("#HospId").getValue();
	if(hosp == ""){
		$.messager.alert("��ʾ","��ѡ��Ժ����");
		return false;
	}
	var params = hosp+"^"+DicCode;
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:excelName, //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBIcdImport",
		QueryName:"QueryContraData",
		params:params
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
}
//����ӵ��� ���ݹȸ�
function formImpnew()
{
	debugger;
	var wb;				//��ȡ��ɵ�����
	var rABS = false;	//�Ƿ��ļ���ȡΪ�������ַ���
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("��ʾ:","��ѡ���ļ������ԣ�","warning");
		return;   
	} 
	var binary = "";
    var fileReader = new FileReader();
    fileReader.onload = function(ev) {
        try {
            //var data = ev.target.result;
			var bytes = new Uint8Array(ev.target.result);
			var length = bytes.byteLength;
			for(var i = 0; i < length; i++) {
				binary += String.fromCharCode(bytes[i]);
			}
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(binary)), {//�ֶ�ת��
					type: 'base64'
				});
			} else {
				wb = XLSX.read(binary, {
					type: 'binary'
				});
			}
    
        } catch (e) {
			$.messager.alert("��ʾ:","�ļ����Ͳ���ȷ��","warning");
			$.messager.progress('close');
			return;
        }

		var obj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
		if(!obj||obj==""){
			$.messager.alert("��ʾ:","��ȡ�ļ�����Ϊ�գ�","warning");
			$.messager.progress('close'); 
			return;
		}
		$('#pro').progressbar({
		text:"���ڴ����У����Ժ�...",
	    value: 0
		});
		//$.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
		var Ins = function(n){
			if (n >= obj.length){			  
				//Save();
				//$.messager.progress('close');
			}else{
							
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {	
	
					// json����ת����Ҫ��ʽ������
					var mListDataArr = JsonToArr(obj[m],mDel1);
					var num=obj[m].__rowNum__+1;
					mListDataArr.push("num"+mDel1+num)
					mListDataArr = mListDataArr.join(spac)	//{"a":1,"b":2} -> a$c(1)1 [next] b$c(1)2					
					TmpArr.push(mListDataArr+mDel2);
					debugger;
					//���ó�����
					var ResultFlag = SaveRowData(mListDataArr,m,obj.length);
					
					if(ResultFlag!="1")
					{
						$("#linklist").datagrid('reload');
						break;	
					}
					if((m+1)==obj.length)
					{
						$.messager.alert("��ʾ","����ɹ�!"+"���ε���"+m+1+"������!");
						$("#linklist").datagrid('reload');
						break;	
					}
								
				}
		
			}
		}
		Ins(0);	//�ӵ�һ�п�ʼ��		
  
   }
   fileReader.readAsArrayBuffer(files[0]);	
		
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
