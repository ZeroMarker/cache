/// Creator: bianshuai
/// CreateDate: 2015-04-23
//  Descript: ҩѧ�໤����ά��

var editRow="";editparamRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[˫���м��ɱ༭]</span>';
var dataArray = [{"value":"G","text":'��ȫ��'}, {"value":"L","text":'����'}, {"value":"U","text":'��Ա'}]; //, {"value":"D","text":'ȫԺ'}
var monSubClassID = "";
var LgHospID=session['LOGON.HOSPID']
$(function(){
	
	// ����columns
	var columns=[[
		{field:"monSubClassID",title:'ID',width:90,align:'center',hidden:true},
		{field:"monSubClassCode",title:'����',width:160,editor:texteditor},
		{field:'monSubClassDesc',title:'ѧ�Ʒ���',width:300,editor:texteditor}
	]];
	// ����datagrid
	$('#discatdg').datagrid({
		title:'ѧ�Ʒ���'+titleNotes,
		url:url+'?action=QueryMonSubClass',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#discatdg").datagrid('endEdit', editRow); 
            } 
            $("#discatdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        if ((editRow != "")||(editRow == "0")) { 			//������ĳ�У��ر�֮ǰ�Ĵ򿪱༭��  qunianpeng 2016-09-22s
              	  $("#discatdg").datagrid('endEdit', editRow); 
                } 
	    	monSubClassID=rowData.monSubClassID;    ///״̬ID
	    	$('#locdg').datagrid('loadData',{total:0,rows:[]});
			$('#locdg').datagrid({
				url:'dhcpha.clinical.action.csp?action=QueryMonSubClassItm',	
				queryParams:{
					monSubClassID:monSubClassID,
					hospID:LgHospID
				}
			});
	    }
	});
	
	initScroll("#discatdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    $('#discatdg').datagrid({
		url:url+'?action=QueryMonSubClass',	
		queryParams:{
			params:''}
	});
	
	InitMonSubClassItm();
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#discatdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#discatdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {monSubClassID: '',monSubClassCode:'',monSubClassDesc: ''}
	});
	$("#discatdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	/*$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">�������ɾ������,����ϵ��Ϣ�ƣ�лл��</font>','warning');
	return;*/
	
	var rows = $("#discatdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelMonSubClass',{"params":rows[0].monSubClassID}, function(data){
					$('#discatdg').datagrid('reload'); //���¼���
					$('#locdg').datagrid('reload'); //���¼���
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
		$("#discatdg").datagrid('endEdit', editRow);
	}

	var rows = $("#discatdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].monSubClassCode=="")||(rows[i].monSubClassDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#discatdg').datagrid('reload'); //���¼���
			return false;
		}
		var tmp=rows[i].monSubClassID+"^"+rows[i].monSubClassCode+"^"+rows[i].monSubClassDesc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveMonSubClass',{"params":rowstr},function(data){
		if(data==1){
		$.messager.alert("��ʾ","��ѧ�Ʒ����Ѿ�����!");
		}
		else{
	    $.messager.alert("��ʾ","����ɹ�!");
		}
		$('#discatdg').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

//������Ϊ�ɱ༭
var monLocEditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//required: true,//���ñ༭��������
		valueField: "value", 
		textField: "text",
		mode:'remote',	
		url: url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'',	//qunianpeng 2017/8/14 ֧��ƴ����ͺ���
		onSelect:function(option){
			var ed=$("#locdg").datagrid('getEditor',{index:editparamRow,field:'monLocID'});
			$(ed.target).val(option.value);  //���ÿ���ID
			var ed=$("#locdg").datagrid('getEditor',{index:editparamRow,field:'monLocDesc'});
			$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
		}
	}
}
/// =====================================��ʼ��ѧ�Ʒ���=============================
function InitMonSubClassItm()
{	
	// ����columns
	var columns=[[
		{field:"monSubClassItmID",title:'monSubClassItmID',width:100,align:'center',hidden:true},
		{field:'monLocID',title:'����id',width:110,editor:'text'},
		{field:"monLocDesc",title:'����',width:320,
			editor: monLocEditor
		}
	]];
	
	// ����datagrid
	$('#locdg').datagrid({
		title:'��������',
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
	    	if ((editparamRow != "")||(editparamRow == "0")) {  //qunianpeng  2016-08-09
               		 $("#locdg").datagrid('endEdit', editparamRow); 
           	 } 
           	 $("#locdg").datagrid('beginEdit', rowIndex); 
           	 editparamRow = rowIndex; 
           	 var ed=$("#locdg").datagrid('getEditor',{index:editparamRow,field:'monLocID'}); //����ID�в��ɱ༭ qunianpeng 2016-09-22
		$(ed.target).attr("disabled",true);
            }
	});
	
	initScroll("#locdg");//��ʼ����ʾ���������
	$('#locdg').datagrid('loadData',{total:0,rows:[]});
	//��ť���¼�
    $('#insparam').bind('click',insparamRow); 
    $('#delparam').bind('click',delparamRow);
    $('#savparam').bind('click',savparamRow);
    
}

// ��������
function insparamRow()
{
	if(editparamRow>="0"){
		$("#locdg").datagrid('endEdit', editparamRow);//�����༭������֮ǰ�༭����
	}
	$("#locdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {monSubClassItmID: '',monLocDesc:'',monLocID: ''}
	});
	$("#locdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editparamRow=0;
}

// ɾ��ѡ����
function delparamRow()
{
	var rows = $("#locdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelMonSubClassItm',{"params":rows[0].monSubClassItmID}, function(data){
					$('#locdg').datagrid('reload'); //���¼���
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
		$("#locdg").datagrid('endEdit', editparamRow);
	}

	var rows = $("#locdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];

	var subClassRows=$("#discatdg").datagrid('getSelections'); //qunianpeng 2016-08-09
	if(subClassRows.length<=0){
		$.messager.alert("��ʾ","��ѡ��ѧ�Ʒ���!");
		return;
	}
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].monLocID == "")||(rows[i].monLocDesc == undefined)){  // qunianpeng  2016-08-09
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#locdg').datagrid('reload'); 
			return false;
		}
		var tmp=rows[i].monSubClassItmID+"^"+monSubClassID+"^"+rows[i].monLocID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("%");
	if(rowstr==""){
		$('#locdg').datagrid('reload'); //���¼���
	}
	//��������
	$.post('dhcpha.clinical.action.csp?action=SaveMonSubClassItm',{"params":rowstr},function(data){
		if(data==1){
			 $.messager.alert("��ʾ","�ù��������Ѿ�����!");
		}	
		$('#locdg').datagrid('reload'); //���¼���
		
	});
}
