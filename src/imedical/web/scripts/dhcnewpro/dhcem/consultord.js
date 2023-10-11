/// author:    qqa
/// date:      2018-07-04
/// descript:  �����������ҽ����

var editRow = ""; editDRow = "";
$(function(){
    //��ʼ��ҽԺ hxy 2020-05-28
    InitHosp(); 
    
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})

function InitHosp(){
	hospComp = GenHospComp("DHC_EmConsOrdConfig");  //hxy 2020-05-28 st
	hospComp.options().onSelect = function(){///ѡ���¼�
		Query();
	}//ed
}

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	/*$('#hospDrID').combobox({ //hxy 2019-11-28 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto',
		onSelect:function(option){
		}
	 }) //ed*/ //hxy 2020-05-28 ע��
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
}

///��ʼ�������б�
function InitDetList(){
	/*
	 * ����columns
	 */
	var columns=[[
		{field:'ECOCRowID',title:'ID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ECOCHosp',title:'ҽԺ',width:100,editor:hospEditor,hidden:true}, //hxy 2019-12-24 //2020-05-28 hidden
		{field:'ECOCHospDr',title:'ҽԺID',width:80,editor:'text',hidden:true}, //hxy 2019-12-24
		{field:'ECOCLoc',title:'�������',width:100,editor:LocEditor,align:'center'},
		{field:'ECOCLocID',title:'����ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCArci',title:'����ҽ��',width:100,editor:ArciEditor,align:'center'},
		{field:'ECOCArciID',title:'ҽ��ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCType',title:'��������',width:100,editor:TypeEditor,align:'center'},
		{field:'ECOCTypeID',title:'����ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCProTp',title:'ְ��',width:100,editor:PrvTpEditor,align:'center'},
		{field:'ECOCProTpID',title:'ְ��ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCProp',title:'��������',width:100,editor:PropEditor,align:'center'},
		{field:'ECOCPropID',title:'��������ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCInsType',title:'���ɷ�ʽ',width:100,editor:InsertTypeEditor,align:'center'},
		{field:'ECOCInsTypeID',title:'��ʽID',width:100,editor:textEditor,align:'center',hidden:true},
	]];
	
	$HUI.datagrid("#dgMainList",{
		url: $URL+"?ClassName=web.DHCEMConsOrd&MethodName=QryEmConsOrd&params="+hospComp.getValue(), //hxy 2020-05-28 &params="+hospComp.getValue()
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		//title:'�����������ҽ����',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }	
	})
	

}

/// ����༭��
function saveRow(){
	
	if((editRow >= 0)||(editRow == "")){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].ECOCLocID==="")){
			$.messager.alert("��ʾ","���Ҳ���Ϊ��");     
			return false;
		}
		
		if((rowsData[i].ECOCArciID==="")){
			$.messager.alert("��ʾ","����ҽ������Ϊ��");     
			return false;
		}
		
		if((rowsData[i].ECOCTypeID==="")){
			$.messager.alert("��ʾ","�������Ͳ���Ϊ��");     
			return false;
		}
		/*
		if((rowsData[i].ECOCProTpID==="")){
			$.messager.alert("��ʾ","ְ�Ʋ���Ϊ��");     
			return false;
		}
		*/
		if((rowsData[i].ECOCInsTypeID==="")){
			$.messager.alert("��ʾ","���ɷ�ʽ����Ϊ��");     
			return false;
		}
		
		
	
		var tmp=rowsData[i].ECOCRowID+"^"+rowsData[i].ECOCLocID +"^"+ rowsData[i].ECOCArciID +"^"+ rowsData[i].ECOCTypeID +"^"+ rowsData[i].ECOCProTpID +"^"+ rowsData[i].ECOCInsTypeID +"^"+ rowsData[i].ECOCPropID;
		tmp=tmp+"^"+rowsData[i].ECOCHosp+"^"+rowsData[i].ECOCHospDr; //hxy 2019-12-24
		tmp=tmp+"^"+rowsData[i].ECOCProTp+"^"+rowsData[i].ECOCProp; //hxy 2020-03-02 ְ������^��������
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsOrd","Save",{"Params":params},function(string){
	
		if (string==1){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','error');	
		}
		
		if (string==0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}
		$('#dgMainList').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	var HospDr=hospComp.getValue(); //hxy 2020-05-28
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ECOCRowID:'', ECOCLoc:'', ECOCLocID:'', ECOCArci:'', ECOCArciID:'', ECOCType:'', ECOCTypeID:'', ECOCProTp:'', ECOCProTpID:'', ECOCInsType:'', ECOCInsTypeID:'',ECOCHosp:HospDr,ECOCHospDr:HospDr} //hxy 2019-12-24 ,ECOCHosp:LgHospID,ECOCHospDr:LgHospID //2020-05-28 LgHospID->HospDr
	});
	$("#dgMainList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsOrd","Delete",{"ID":rowsData.ECOCRowID},function(jsonString){
					if (jsonString != 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','info');
					}
					$('#dgMainList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','info');
		 return;
	}
}

/// �ı��༭��
var textEditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}
	
// ���ұ༭��
var LocEditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsLoc",
		valueField: "value", 
		textField: "text",
		mode:'remote',
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLoc'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLocID'});
			$(ed.target).val(option.value);
		},
		onShowPanel:function(){ //hxy 2019-12-24 st
			/*var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHospDr'}); 
			var HospID=$(ed.target).val(); 
			if(HospID==undefined){HospID=""}
			if(HospID==""){
				$.messager.alert('��ʾ',"����ѡ��ҽԺ!");
				return;
			}*/ //hxy 2020-05-28 ע��
	        //var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsLoc&HospID="+hospComp.getValue(); //hxy 2020-05-28 ԭ��HospID
	        var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsLocNew&HospID="+hospComp.getValue(); //hxy 2020-09-22
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLoc'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLocID'});
				$(ed.target).val("");
			}
		}
	}
}

// ְ�Ʊ༭��
var PrvTpEditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTpBak",
		valueField: "value", 
		textField: "text",
		editable:true,
		enterNullValueClear:false,
		//panelHeight:"auto",  //���������߶��Զ�����
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProTp'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProTpID'});
			$(ed.target).val(option.value);
		},
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProTpID'});
				$(ed.target).val("");
			}
		}
	}
}

// ҽ���༭��
var ArciEditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsArci", //hxy 2019-12-24
		valueField: "value", 
		textField: "text",
		mode:'remote',
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArci'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArciID'});
			$(ed.target).val(option.value);
		},
		onShowPanel:function(){ //hxy 2019-12-24 st
			/*var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHosp'}); 
			var HospID=$(ed.target).combobox('getValue'); //ed
			if(isNaN(HospID)){ //hxy 2020-03-04
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHospDr'}); 
				var HospID=$(ed.target).val(); 
			}//ed
			if(HospID==undefined){HospID=""}
			if(HospID==""){
				$.messager.alert('��ʾ',"����ѡ��ҽԺ!");
				return;
			}*/
	        var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsArci&HospID="+hospComp.getValue(); //hxy 2020-05-28
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArci'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArciID'});
				$(ed.target).val("");
			}
		}
	}
}


// ���ɷ�ʽ�༭��
var InsertTypeEditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsInsType",
		valueField: "value", 
		textField: "text",
		mode:'remote',
		data:[
			{value:"A",text:"�������"},
			{value:"E",text:"��ɲ���"}
		],
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCInsType'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCInsTypeID'});
			$(ed.target).val(option.value);
		},
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCInsTypeID'});
				$(ed.target).val("");
			}
		}
	}
}


// ��������
var TypeEditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		valueField: "value", 
		textField: "text",
		mode:'remote',
		/*data:[
			{value:"I",text:"Ժ�ڻ���"},
			{value:"O",text:"Ժ�����"}
		],*/
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCType'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCTypeID'});
			$(ed.target).val(option.value);
			
		},
		onShowPanel:function(){ //hxy 2021-02-27 st
	        var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+hospComp.getValue() //+"&Ord=Y";
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCType'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCTypeID'});
				$(ed.target).val("");
			}
		}
	}
}

// ��������
var PropEditor = {  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//url: $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=CNAT&HospID="+session['LOGON.HOSPID'], //hxy 2020-05-28 ע��
		valueField: "value", 
		textField: "text",
		mode:'remote',
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProp'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCPropID'});
			$(ed.target).val(option.value);
			
		},
		onShowPanel:function(){ //hxy 2020-05-28 st
	        var url = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=CNAT&HospID="+hospComp.getValue();
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProp'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCPropID'});
				$(ed.target).val("");
			}
		}
	}
}

//ҽԺ //hxy 2019-12-24
var hospEditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
		valueField: "value", 
		textField: "text",
		required:true,
		editable:false, 
		panelHeight:"auto", //���������߶��Զ�����
		onSelect:function(option){
			var Hosped=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHosp'});
			$(Hosped.target).val(option.text);  //����ҽԺ
			var HospIDed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHospDr'});
			$(HospIDed.target).val(option.value);  //����ҽԺID
			
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLoc'});
			$(ed.target).combobox("setValue","");
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLocID'});
			$(ed.target).val("");
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArci'});
			$(ed.target).combobox("setValue","");
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArciID'});
			$(ed.target).val("");
		}
	}
}

//��ѯ //hxy 2019-12-24
function Query()
{
	var hospDrID=hospComp.getValue(); //hxy 2020-05-28 ԭ��$('#hospDrID').combobox('getValue');  
	if(hospDrID==undefined){hospDrID=""}               
	var params=hospDrID;
    $('#dgMainList').datagrid('load',{params:params}); 		
}