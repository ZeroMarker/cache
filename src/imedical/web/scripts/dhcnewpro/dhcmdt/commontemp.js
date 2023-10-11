/// author:    bianshuai
/// date:      2016-04-11
/// descript:  ��������״̬�ֵ�ά��

var editRow = ""; editDRow = "";
$(function(){
	init(); //ylp ��ʼ��ҽԺ //20230222
	
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})
function init(){
	
	hospComp = GenHospComp("DHC_MDTOpiTemp");  //hxy 2020-05-27 st //2020-05-31 add
	hospComp.options().onSelect = function(){///ѡ���¼�
		$("#dgMainList").datagrid('reload',{params:hospComp.getValue()});
	}

	$('#queryBTN').on('click',function(){
		$("#dgMainList").datagrid('reload',{params:hospComp.getValue()});
	 })
		
}
///��ʼ������Ĭ����Ϣ
function InitDefault(){

}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
}

///��ʼ�������б�
function InitDetList(){
	
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	/**
	 * ����columns
	 */
   var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Pointer',title:'mID',width:100,hidden:true},
		{field:'Title',title:'����',width:200,editor:textEditor},
		{field:'Text',title:'��������',width:820,editor:textEditor},
		{field:'HospID',title:'ҽԺID',width:820,editor:textEditor,hidden:true},
	
	]];
	/**
	 * ����datagrid
	 */
	var option = {
		//title:'��������״̬�ֵ�',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTCommonTemp&MethodName=QryOpiTemp&mID=0"+"&params="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	dgMainListComponent.Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((trim(rowsData[i].Title) == "")||(trim(rowsData[i].Text) == "")){
			$.messager.alert("��ʾ","��������ݲ���Ϊ��!",'warning'); 
			return false;
		}
//		if(rowsData[i].HospID==""){
//			$.messager.alert("��ʾ","ҽԺ����Ϊ��!",'warning'); 
//			return false;
//		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Title +"^"+ rowsData[i].Text+"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTCommonTemp","save",{"mParam":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
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
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Title:'', Text:'',HospID:hospComp.getValue()}
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
				runClassMethod("web.DHCMDTCommonTemp","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#dgMainList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}