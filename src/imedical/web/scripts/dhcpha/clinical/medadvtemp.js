/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: �û���ҩ����ģ��

var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[˫�����]</span>';
var titleNotes2='<span style="font-weight:bold;color:red;">[˫��ɾ��]</span>';
var dataArray = [{"val":"L","text":'����'}, {"val":"U","text":'��Ա'}];
var editparamRow="";

$(function(){
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'����',width:100,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];
	
	// ����datagrid
	$('#medadvdicdg').datagrid({
		title:'��ҩ�����ֵ�'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			/*
			if(adrEvtEditRow>="0"){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//�����༭������֮ǰ�༭����
			}
			*/
			var tmpMedAdvID=rowData.ID;
			var tmpMedAdvCode=rowData.Code;
			var tmpMedAdvDesc=rowData.Desc;
			var rowData=$('#medadvtempdg').datagrid('getData');   //sufan 2016/9/12
			for(var i=0;i<rowData.rows.length;i++){
				var sugdesc=rowData.rows[i].Desc
				if (tmpMedAdvDesc==sugdesc){
					$.messager.alert("��ʾ","�ü�¼�Ѵ��ڣ�")
					return;
					}
				} 
			 $('#medadvtempdg').datagrid('insertRow',{
				 index: 0,	// index start with 0
				 row: {
					ID: tmpMedAdvID,
					Code: tmpMedAdvCode,
					Desc: tmpMedAdvDesc
				}
	         });
		}
	});
	
	initScroll("#medadvdicdg");//��ʼ����ʾ���������
     
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findAdrStatus(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findAdrStatus(); //���ò�ѯ
    });
    
    $('#medadvdicdg').datagrid({
		url:url+'?action=QueryDrgSugDic',	
		queryParams:{
			params:''}
	});
	
	InitAdrStatusParam();
	
	//��������
	$('#type').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:dataArray
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#medadvdicdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#medadvdicdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#medadvdicdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#medadvdicdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrStatus',{"params":rows[0].ID}, function(data){
					$('#medadvdicdg').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveRow()
{
	if(editRow>="0"){
		$("#medadvdicdg").datagrid('endEdit', editRow);
	}

	var rows = $("#medadvdicdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveAdrStatus',{"params":rowstr},function(data){
		$('#medadvdicdg').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ��ѯ
function findAdrStatus()
{
	var adrStatusCode="";  //$('#code').val();
	var adrStatusDesc=$('#desc').val();
	var params=adrStatusCode+"^"+adrStatusDesc;
	$('#medadvdicdg').datagrid('load',{params:params}); 
}

/// =====================================��������=============================
function InitAdrStatusParam()
{	
	// ����columns
	var columns=[[
		{field:"medAdvID",title:'medAdvID',width:90,align:'center',hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'����',width:100,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];
	
	// ����datagrid
	$('#medadvtempdg').datagrid({
		title:'����/���˽���ģ��'+titleNotes2,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			delparamRow();
        }
	});
	
	initScroll("#medadvtempdg");//��ʼ����ʾ���������
	
	$('#medadvtempdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',	
		queryParams:{
			params:session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']}
	});
	
	//��ť���¼�
    $('#insparam').bind('click',insparamRow); 
    $('#delparam').bind('click',delparamRow);
    $('#savparam').bind('click',savparamRow);
}

// ��������
function insparamRow()
{
	var ttt=$("#medadvtempdg").datagrid('selectRow',editparamRow)

	if(editparamRow>="0"){
		$("#medadvtempdg").datagrid('endEdit', editparamRow);//�����༭������֮ǰ�༭����
	}
	$("#medadvtempdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#medadvtempdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editparamRow=0;
}

// ɾ��ѡ����
function delparamRow()
{
	var rows = $("#medadvtempdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				if(typeof rows[0].medAdvID!="undefined"){
					//ɾ�����¼
					$.post(url+'?action=DelMedAdvTemp',{"params":rows[0].medAdvID}, function(data){
						$('#medadvtempdg').datagrid('reload'); //���¼���
					});
				}else{
					//ɾ��������
					var index = $('#medadvtempdg').datagrid('getRowIndex',rows[0]); 
					$('#medadvtempdg').datagrid('deleteRow',index);  
				}
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function savparamRow()
{
	/*
	if(editparamRow>="0"){
		$("#medadvtempdg").datagrid('endEdit', editparamRow);
	}
	*/
	var rows = $("#medadvtempdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		/*
		if((rows[i].ID=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		*/
		///��������Ƿ�������
		var tmp="U"+"^"+session['LOGON.USERID']+"^"+rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post('dhcpha.clinical.action.csp?action=SaveMedAdvTemp',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert("��ʾ","����ɹ�!");
			$('#medadvtempdg').datagrid('reload'); //���¼���
		}
	});
}

/// ==========================================================================
