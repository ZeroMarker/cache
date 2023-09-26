/// author:    bianshuai
/// date:      2018-08-28
/// descript:  ������רҵ/ָ֢����ά��

var editRow = "";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
/// ҳ���ʼ������
function initPageDefault(){
	
	//��ʼ��ҽԺ hxy 2020-05-28
    InitHosp();
    
	//��ʼ���б�
	InitMainList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
}

function InitHosp(){
	hospComp = GenHospComp("DHC_EmConsHosLoc");  //hxy 2020-05-28 st
	hospComp.options().onSelect = function(){///ѡ���¼�
		Query();
	}//ed
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
}

///��ʼ���б�
function InitMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ҽԺ�༭��
	var HospEditor = {
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			//url: $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID, //hxy 2020-05-28 ע��
			enterNullValueClear:false,
			onShowPanel:function(){ //hxy 2020-05-28 st
		        var url = $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+hospComp.getValue();
		        var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmHosp'});
				$(ed.target).combobox('reload', url);
			}, //ed
			onSelect:function(option) {
				/// ҽԺID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmHosID'});
				$(ed.target).val(option.value);
				/// ҽԺ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmHosp'});
				$(ed.target).combobox('setValue', option.text);
				
//				///���ü���ָ��
//				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLoc'});
//				var unitUrl=$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=LOC&HospID="+LgHospID;
//				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// ���ұ༭��
	var LocEditor = {
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			url: '',
			enterNullValueClear:false,
			onSelect:function(option) {
				/// ����ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLocID'});
				$(ed.target).val(option.value);
				/// ����
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLoc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				
				///���ü���ָ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLoc'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=LOC&HospID="+hospComp.getValue(); //hxy 2020-05-28 ԭ��LgHospID
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'itmHosID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'itmHosp',title:'ҽԺ',width:300,editor:HospEditor,align:'center'},
		{field:'itmLocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'itmLoc',title:'����',width:300,editor:LocEditor,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=QryEmConsHosLoc&params="+hospComp.getValue(); //hxy 2020-05-28 &params="+hospComp.getValue()
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}
	
	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].itmHosID == ""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].itmHosID +"^"+ rowsData[i].itmLocID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsHosLoc","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}

	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].itmHosID == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}

	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', itmHosID:'', itmHosp:'', itmLocID:'', itmLoc:''}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsHosLoc","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function Query()
{
	var HospDr=hospComp.getValue();  
    $('#main').datagrid('load',{params:HospDr}); 		
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })