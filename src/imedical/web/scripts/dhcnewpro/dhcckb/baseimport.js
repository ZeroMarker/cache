//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-05-15
// ����:	   ֪ʶ��������ݵ���
//===========================================================================================

var pid = 1;
var mDel1 = String.fromCharCode(1);  /// �ָ���
var mDel2 = String.fromCharCode(2);  /// �ָ���
/// ҳ���ʼ������
function initPageDefault(){

	/// ��ʼ�����ز����б�
	InitPatList();
	
	/// ��ʼ�����˻�����Ϣ
	InitPagePanel();
}

/// ��ʼ�����˻�����Ϣ
function InitPagePanel(){


}

/// ��ʱ�洢����
function InsTmpGlobal(mListData, Fn, m){

	var ErrFlag = 0;
	runClassMethod("web.DHCCKBBaseImport","InsTmpGlobal",{"pid":pid, "mListData":mListData},function(val){
		Fn(m);
	})

	return ErrFlag;
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	///  ����columns
	var columns=[[
		{field:'itmIndex',title:'���',width:40,align:'center',hidden:true},
		{field:'itmCode',title:'����',width:100},
		{field:'itmGeneric',title:'ͨ����',width:100,styler: function(value, rowData, index){
//	        if (rowData.itmErrMsg != ""){
//				return 'background-color:pink;';
//			}
		}},
		{field:'itmEnglish',title:'Ӣ����',width:100},
		{field:'itmGoodName',title:'��Ʒ����',width:100},
		{field:'itmIngr',title:'�ɷ�',width:100},
		{field:'itmInd',title:'��Ӧ֢',width:300},
		{field:'itmUsage',title:'�÷�����',width:100},
		{field:'itmEffects',title:'������Ӧ',width:300},
		{field:'itmTaboo',title:'����',width:100},
		{field:'itmAttent',title:'ע������',width:400},
		{field:'itmInter',title:'ҩ���໥����',width:300},
		{field:'itmToxi',title:'�����о�',width:100},
		{field:'itmAppNum',title:'��׼�ĺ�',width:100},
		{field:'itmManf',title:'������ҵ',width:100},
		{field:'itmClass',title:'ҩ�����',width:100},
		{field:'itmErrMsg',title:'������Ϣ',width:300}
	]];

	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		},
        rowStyler:function(rowIndex, rowData){
	        if (rowData.itmErrMsg != ""){
				return 'background-color:pink;';
			}
		}
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCCKBBaseImport&MethodName=QryDataWaitToImp&pid="+pid;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ��������
function InsTmp(){
	
	var wb;//��ȡ��ɵ�����
	var rABS = false; //�Ƿ��ļ���ȡΪ�������ַ���
    //var files = $("#articleImageFile")[0].files;
    var files = $("#articleImageFile").filebox("files");
    if (files.length == 0){
		$.messager.alert("��ʾ:","��ѡ���ļ������ԣ�","warning");
		return;   
	}

	$.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
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
		
		var Ins = function(n){
			if (n >= obj.length){
				$("#bmDetList").datagrid("reload");   /// ˢ��ҳ������
				$.messager.progress('close');
				InsTmpDic();
			}else{
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {
					var mListData = mDel1 + obj[m].itmCode +"^"+ ChangeValue(obj[m].itmGeneric) +"^"+ (obj[m].itmEnglish||"") +"^"+ (ChangeValue(obj[m].itmGoodName)||"") +"^"+ (obj[m].itmIngr||"") +"^"+ (obj[m].itmInd||"") +"^"+ (obj[m].itmUsage||"");
					   mListData = mListData +"^"+ (obj[m].itmEffects||"") +"^"+ (obj[m].itmTaboo||"") +"^"+ (obj[m].itmAttent||"") +"^"+ (obj[m].itmInter||"") +"^"+ (obj[m].itmToxi||"") +"^"+ (obj[m].itmAppNum||"") +"^"+ (obj[m].itmManf||"") +"^"+ (obj[m].itmClass||"");
					TmpArr.push(mDel1 + mListData);
					if ((m != 0)&(m%100 == 0)){
						/// ��ʱ�洢����
						InsTmpGlobal(TmpArr.join(mDel2), Ins, m+1);
						TmpArr.length=0;
						break;
					}
				}
				if (TmpArr.join(mDel2) != ""){
					/// ��ʱ�洢����
					InsTmpGlobal(TmpArr.join(mDel2), Ins, m);
				}
			}
		}
		Ins(0);
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

/// �������
function clrPanel(){
	
	$.messager.confirm('ȷ�϶Ի���',"ȷ��Ҫ�����ʱ������", function(r){
		if (r){
			killTmpGlobal(); /// ɾ����ʱglobal
			$("#bmDetList").datagrid("reload");   /// ˢ��ҳ������
		}
	})
}

/// ��ѯ
function Query(){
	
	var itemCode = $("#itemCode").val();    			/// ����
	var itemDesc = $("#itemDesc").val();    			/// ����
	var params = itemCode +"^"+ itemDesc;
	$("#bmDetList").datagrid("load",{"Params":params}); /// ˢ��ҳ������
}

/// ����洢����
function InsTmpDic(){

	runClassMethod("web.DHCCKBBaseImport","InsTmpDic",{"pid":pid},function(obj){
		if (obj != null){
			$.messager.alert("��ʾ:","������ɣ��ɹ���¼����"+ obj.SuccessNum +"����ʧ�ܼ�¼����"+ obj.ErrorNum +"��","warning");
			$("#bmDetList").datagrid("reload");   /// ˢ��ҳ������
			return;
		}
	},'json',false)
}

/// У��ɹ�
function checkData(){
	
	$.messager.alert("��ʾ:","У��ɹ��������κβ���","warning");
	$("#bmDetList").datagrid("reload");   /// ˢ��ҳ������
}

/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCCKBBaseImport","killTmpGlobal",{"pid":pid},function(jsonString){},'',false)
}


function ChangeValue(val){

	if (val === undefined){
		val = ""
	}
	return val;
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    //killTmpGlobal();  /// �����ʱglobal
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })