/**
*	Author: 		Qunianpeng
*	Create: 		2019/07/04
*	Description:	������
*/
//var mDel1 = String.fromCharCode(1);  /// �ָ���
//var mDel2 = String.fromCharCode(2);  /// �ָ���
var spac  = "[next]"	 /// �ָ���
var rowFlag = "[row]"	 /// �ָ���
var mDel1 = String.fromCharCode(1);  /// �ָ���
var pid="";
var mDel2=String.fromCharCode(2);
/// ҳ���ʼ������
function initPageDefault(){

	InitButton();			/// ��ʼ����ť���¼�
	InitDrugListGrid();		/// ��ʼ��ҩƷ�б�
	
}


/// ��ʼ����ť���¼�
function InitButton(){

	/// ���룬��Ʒ���س�	
	//$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	//$('#queryDesc').bind('keypress',InputPrese);
}

/// ��ʼ��ҩƷ�б�
function InitDrugListGrid(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[    
	       	{field:'num',title:'���',width:80},    
	     	{field:'itmCode',title:'����',width:140},
	        {field:'itmGeneName',title:'ͨ������(������)',width:180},
	        {field:'itmProName',title:'��Ʒ��',width:180},
	        {field:'itmIngre',title:'�ɷ�',width:180},
	        {field:'itmExcipient',title:'����',width:180},
	        {field:'itmForm',title:'����',width:120},
	        {field:'itmLibary',title:'��ϵ',width:100},
	       	{field:'errMsg',title:'��ע',width:160}
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
	    nowrap:false,
	    pageList:[20,40,100],
		//showHeader:false,		
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBExport&MethodName=QueryDrugList&params="+pid;
	new ListComponent('druglist', columns, uniturl, option).Init();
}


/// ��������
function UploadData(){
	
  var wb;				//��ȡ��ɵ�����
	var rABS = false;	//�Ƿ��ļ���ȡΪ�������ַ���
    //var files = $("#articleImageFile")[0].files;
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("��ʾ:","��ѡ���ļ������ԣ�","warning");
		return;   
	}
	
	//$.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
	pid=(new Date()).valueOf(); //serverCall("web.DHCCKBMatchSearch","MatchDataPid");  

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
                //persons = []; // �洢��ȡ��������
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
		$.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
		var Ins = function(n){
			if (n >= obj.length){			  
				Save();
				$.messager.progress('close');
			}else{
							
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {
					
					// json����ת����Ҫ��ʽ������
					var mListDataArr = JsonToArr(obj[m],mDel1);
					var num=obj[m].__rowNum__+1;
					mListDataArr.push("num"+mDel1+num)
					mListDataArr = mListDataArr.join(spac)	//{"a":1,"b":2} -> a$c(1)1 [next] b$c(1)2					
					TmpArr.push(mListDataArr+mDel2);
	
					if ((m != 0)&(m%100 == 0)){	// ��̨����ƴ����������,��ʱ��2�д�һ��(���޸���ɶ�100��)
					//if (m%2 == 0){	
						/// ��ʱ�洢����
						InsTmpGlobal(TmpArr.join(rowFlag), Ins, m+1,pid);
						TmpArr.length=0;
						break;
					}				
				}
				var testString=TmpArr.join(rowFlag);
				if (testString != ""){
					/// ��ʱ�洢����
					InsTmpGlobal(testString, Ins, m,pid);
				}
			}
		}
		Ins(0);	//�ӵ�һ�п�ʼ��		
  
   }
  
   fileReader.readAsArrayBuffer(files[0]);
}

//�ļ���תBinaryString
function fixdata(data) { 
	var o = "",
		l = 0,
		w = 10240;
	for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	return o;
}

/// ��ʱ�洢����
function InsTmpGlobal(mListData, Fn, m,pid){

	var ErrFlag = 0;
	runClassMethod("web.DHCCKBRuleImport","TmpImportData",{"pid":pid, "mListData":mListData},function(val){
		Fn(m);
	})
	
	return ErrFlag;
}

/// �洢����
function Save(){

	var ErrFlag = 0;

	runClassMethod("web.DHCCKBRuleImport","SaveRule",{"pid":pid,loginInfo:LoginInfo},function(val){
		//var retObj = JSON.parse(val);
		var retObj=val
		if (retObj.code =="success"){
			$.messager.alert("��ʾ:","����ɹ�."+"����"+retObj.total+"����,  �ɹ���"+retObj.successNum+"����.  "+"ʧ�ܡ�"+retObj.errNum+"����","info");
		}
		else{
			$.messager.alert("��ʾ:","����ʧ��."+"ʧ��ԭ��"+retObj.msg,"info");
			ErrFlag=1
		}
		$.messager.progress('close');
		$("#druglist").datagrid("load",{"params":pid});
	},"json",false)
	
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

/// �����������ݣ���̨�������أ�
function ExportDataErrMsg(){
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"������־", 		//Ĭ��DHCCExcel
		ClassName:"web.DHCCKBExport",
		QueryName:"ExportDataErrMsg",
		pid:pid
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
	
}

/// ��������̨�������ز��ԣ�
function ExportMatchDataNew(){
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:formatDate(0)+"ҩƷƥ������", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBMatchSearch",
		QueryName:"ExportMatchDataNew",
		pid:pid
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:formatDate(0)+"ҩƷƥ������", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBExport",
		QueryName:"ExportTmpData",
		pid:pid
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
