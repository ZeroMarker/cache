/// Creator: bianshuai
/// CreateDate: 2014-09-18��
//  Descript: ������Ӧ����״̬��Ȩά��

var editRow="";editparamRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫���м��ɱ༭]</span>';
var dataArray = [{"value":"G","text":'��ȫ��'}, {"value":"L","text":'����'}, {"value":"U","text":'��Ա'}]; //, {"value":"D","text":'ȫԺ'}
var AdrStatusId = "";
$(function(){
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'����',width:160,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];
	
	// ����datagrid
	$('#adrstatusdg').datagrid({
		title:'������Ӧ����״̬��Ȩ'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           if ((editRow != "")||(editRow=="0")) { 
                $("#adrstatusdg").datagrid('endEdit', editRow); 
            } 
            $("#adrstatusdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	    	AdrStatusId=rowData.ID;    ///״̬ID
 			var params=AdrStatusId;
			$('#adrstatusparamdg').datagrid({
				url:'dhcpha.clinical.action.csp?action=QueryAdrStatusGrant',	
				queryParams:{
					params:params
				}
			});
	    }
	});
	
	initScroll("#adrstatusdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
            findAdrStatus(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findAdrStatus(); //���ò�ѯ
    });
    
    $('#adrstatusdg').datagrid({
		url:url+'?action=QueryAdrStatus',	
		queryParams:{
			params:''}
	});
	
	InitAdrStatusParam();
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#adrstatusdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#adrstatusdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrstatusdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#adrstatusdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		/*$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {*/
			$.messager.alert('��ʾ','ɾ����ѡ�����������ȷ���������̶������ɾ���ɾ�������ɾ��������','warning');  //wangxuejian 2016 08 26
				$.post(url+'?action=DelAdrStatus',{"params":rows[0].ID}, function(data){
					$('#adrstatusdg').datagrid('reload'); //���¼���
                                        $('#adrstatusparamdg').datagrid('reload'); //���¼���   //wangxuejian 2016-09-08
					
				});
			//}
		//});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveRow()
{
	if(editRow>="0"){
		$("#adrstatusdg").datagrid('endEdit', editRow);
	}

	var rows = $("#adrstatusdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#adrstatusdg').datagrid('reload'); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveAdrStatus',{"params":rowstr},function(data){
		$('#adrstatusdg').datagrid('reload'); //���¼���
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
	var adrStatusCode=$('#code').val();
	var adrStatusDesc=$('#desc').val();
	var params=adrStatusCode+"^"+adrStatusDesc;
	$('#adrstatusdg').datagrid('load',{params:params}); 
}

/// =====================================��������=============================
function InitAdrStatusParam()
{
	//������Ϊ�ɱ༭
	var editPoint={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			url: '',
			onSelect:function(option){
				var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'PointID'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			}
		}
	}
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'����',width:110,editor:texteditor,
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //���������߶��Զ�����
					onSelect:function(option){
						///��������ֵ
						var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'TypeID'});
						$(ed.target).val(option.value);  //���ÿ���ID
						var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
						///���ü���ָ��
						var paramType=option.value+"^"+LgGroupID;  //����^��ȫ��
						var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Pointer'});
						var unitUrl='dhcpha.clinical.action.csp?action=GetSSPPoint&params='+paramType;
						$(ed.target).combobox('reload',unitUrl);
					} 
				}
			}
		},
		{field:'Pointer',title:'ָ��',width:300,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true}
	]];
	
	// ����datagrid
	$('#adrstatusparamdg').datagrid({
		title:'Ȩ������'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
      
	        var row = $('#adrstatusparamdg').datagrid('getData').rows[rowIndex];

			if ((editparamRow != "")||(editparamRow=="0")) { 
                $("#adrstatusparamdg").datagrid('endEdit', editparamRow); 
            } 
            $("#adrstatusparamdg").datagrid('beginEdit', rowIndex); 

            editparamRow = rowIndex;
		
			 //˫���༭ֱ�ӿ���ѡ������ָ�� duwensheng 2016-09-08
			var paramType=row.TypeID+"^"+LgGroupID;  //����^��ȫ��
			var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Pointer'});
			var unitUrl='dhcpha.clinical.action.csp?action=GetSSPPoint&params='+paramType;
			$(ed.target).combobox('reload',unitUrl);


        }
	});
	
	initScroll("#adrstatusparamdg");//��ʼ����ʾ���������
	
	//��ť���¼�
    $('#insparam').bind('click',insparamRow); 
    $('#delparam').bind('click',delparamRow);
    $('#savparam').bind('click',savparamRow);
}

// ��������
function insparamRow()
{
		var ttt=$("#adrstatusparamdg").datagrid('selectRow',editparamRow)

	if(editparamRow>="0"){
		$("#adrstatusparamdg").datagrid('endEdit', editparamRow);//�����༭������֮ǰ�༭����
	}
	$("#adrstatusparamdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrstatusparamdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editparamRow=0;
}

// ɾ��ѡ����
function delparamRow()
{
	var rows = $("#adrstatusparamdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrStatusGrant',{"params":rows[0].ID}, function(data){
					$('#adrstatusparamdg').datagrid('reload'); //���¼���
				});
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
	if(editparamRow>="0"){
		$("#adrstatusparamdg").datagrid('endEdit', editparamRow);
	}

	var rows = $("#adrstatusparamdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if((rows[i].TypeID=="")||(rows[i].PointID=="")){
			$.messager.alert("��ʾ","���ͻ�ָ����Ϊ��!"); 
			$('#adrstatusparamdg').datagrid('reload');
			return false;
		}
		
		var tmp=rows[i].ID+"^"+AdrStatusId+"^"+rows[i].TypeID+"^"+rows[i].PointID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("!!");
	//��������
	$.post('dhcpha.clinical.action.csp?action=SaveAdrStatusGrant',{"params":rowstr},function(data){
		if(data==0){
			//$.messager.alert("��ʾ","����ɹ�!");
			$('#adrstatusparamdg').datagrid('reload'); //���¼���
		}
	});
}

/// ==========================================================================
