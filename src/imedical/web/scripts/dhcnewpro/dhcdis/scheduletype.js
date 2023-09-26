/** sufan 
  * 2018-04-09
  *
  * �����Ű�ά��
 */
var editRow = ""; 
var ParrefId = "";   //�ϼ�ID
/// ҳ���ʼ������
function initPageDefault(){

	initSchelist();       	/// ��ʼҳ��DataGrid�Ű��
	initShiftlist();		/// ���ά��
	initButton();           /// ҳ��Button���¼�	
}
///������ 
function initSchelist(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ���ڱ༭��
	var datebox={
		type: 'datebox',//���ñ༭��ʽ
		options: {
			required: false//���ñ༭��������
		}
	}

	// ����columns
	var columns=[[
		{field:"SchtCode",title:'�Ű����',width:200,align:'center',editor:textEditor},
		{field:"SchtDesc",title:'�Ű�����',width:200,align:'center',editor:textEditor},
		{field:"StartDate",title:'��ʼ����',width:150,align:'center',editor:datebox,hidden:true},
		{field:"StartTime",title:'��ʼʱ��',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"EndDate",title:'��������',width:150,align:'center',editor:datebox,hidden:true},
		{field:"EndTime",title:'����ʱ��',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"LastRowID",title:'LastRowID',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SchtId",title:'ID',width:20,hidden:true}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#schelist").datagrid('endEdit', editRow); 
            } 
            $("#schelist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           ParrefId = rowData.SchtId;
           $('#shiftlist').datagrid('reload',{params:"",LastRowId:rowData.SchtId});
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QuerySchType&params="+""+"&LastRowId="+0;
	new ListComponent('schelist', columns, uniturl, option).Init(); 
}

function initShiftlist()
{
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ���ڱ༭��
	var datebox={
		type: 'datebox',//���ñ༭��ʽ
		options: {
			required: false//���ñ༭��������
		}
	}

	// ����columns
	var columns=[[
		{field:"SchtCode",title:'��δ���',width:140,align:'center',editor:textEditor},
		{field:"SchtDesc",title:'�������',width:140,align:'center',editor:textEditor},
		{field:"StartDate",title:'��ʼ����',width:140,align:'center',editor:datebox},
		{field:"StartTime",title:'��ʼʱ��',width:140,align:'center',editor:textEditor},
		{field:"EndDate",title:'��������',width:140,align:'center',editor:datebox},
		{field:"EndTime",title:'����ʱ��',width:140,align:'center',editor:textEditor},
		{field:"LastRowID",title:'LastRowID',width:140,align:'center',editor:textEditor,hidden:true},
		{field:"SchtId",title:'ID',width:20,hidden:true}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#shiftlist").datagrid('endEdit', editRow); 
            } 
            $("#shiftlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QuerySchType";
	new ListComponent('shiftlist', columns, uniturl, option).Init(); 
}
/// ҳ�� Button ���¼�
function initButton(){
	
	///  �����Ű�����
	$('#insert').bind("click",insertRow);
	
	///  �����Ű�����
	$('#save').bind("click",saveRow);
	
	///  ɾ���Ű�����
	$('#delete').bind("click",delRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findSchelist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findSchelist(); //���ò�ѯ
    });
    
    //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findSchelist(); //���ò�ѯ
    }); 
    
    ///  ���Ӱ��
	$('#subinsert').bind("click",insertsubRow);
	
	///  ������
	$('#subsave').bind("click",savesubRow);
	
	///  ɾ�����
	$('#subdelete').bind("click",delsubRow);
    
 
}

/// �����Ű�����
function insertRow(){

	if(editRow>="0"){
		$("#schelist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#schelist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {SchtId: '',SchtCode:'',SchtDesc: '',StartDateTime:'',EndDateTime:''}
	});
    
	$("#schelist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///�����Ű�����
function saveRow(){
	
	if(editRow>="0"){
		$("#schelist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#schelist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SchtCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].SchtDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].SchtId +"^"+ rowsData[i].SchtCode +"^"+ rowsData[i].SchtDesc +"^"+ rowsData[i].StartDate +"^"+ rowsData[i].StartTime +"^"+ rowsData[i].EndDate +"^"+ rowsData[i].EndTime +"^"+ 0;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISScheduleType","SaveSchType",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#schelist').datagrid('reload');  //���¼���
	});
}

/// ɾ��
function delRow(){
	
	var rowsData = $("#schelist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISScheduleType","DelSchType",{"SchtId":rowsData.SchtId},function(jsonString){
					
					$('#schelist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ������
function insertsubRow(){
	var rowData = $("#schelist").datagrid('getSelected')
	if(rowData==null){
		$.messager.alert("��ʾ","����ѡ���Ű����ͣ�");
		return;
	}
	
	if(editRow>="0"){
		$("#shiftlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#shiftlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {SchtId: '',SchtCode:'',SchtDesc: '',StartDateTime:'',EndDateTime:''}
	});
    
	$("#shiftlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///�����Ű�����
function savesubRow(){
	
	var rowData = $("#schelist").datagrid('getSelected')
	var LastRowId=rowData.SchtId;
	if(editRow>="0"){
		$("#shiftlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#shiftlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SchtCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].SchtDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].SchtId +"^"+ rowsData[i].SchtCode +"^"+ rowsData[i].SchtDesc +"^"+ rowsData[i].StartDate +"^"+ rowsData[i].StartTime +"^"+ rowsData[i].EndDate +"^"+ rowsData[i].EndTime +"^"+ LastRowId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISScheduleType","SaveSchType",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#shiftlist').datagrid('reload');  //���¼���
	});
}

/// ɾ��
function delsubRow(){
	
	var rowsData = $("#shiftlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISScheduleType","DelSchType",{"SchtId":rowsData.SchtId},function(jsonString){
					
					$('#shiftlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ��ѯ
function findSchelist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#schelist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
