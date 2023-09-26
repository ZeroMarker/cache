/// Creator: congyue
/// CreateDate: 2018-01-15
//  Descript: ����1����2 ά������

var editRow=""; editmuliRow=""; //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var AutLocID = "";
$(function(){	
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#autlocdg").datagrid('getEditor',{index:editRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[  
		{field:"Code",title:'����',width:150,editor:texteditor},
		{field:'Desc',title:'����',width:150,editor:texteditor},
		{field:'Parent',title:'����',width:150,editor:editor},
		{field:'Active',title:'�Ƿ����',width:150,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center'}
	]];
	
	// ����datagrid
	$('#autlocdg').datagrid({
		title:'����1',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVAUTLOC&MethodName=QueryAutLoc&params='+"",
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
            	$("#autlocdg").datagrid('endEdit', editRow); 
			}
            $("#autlocdg").datagrid('beginEdit', rowIndex);
            
            var edc = $("#autlocdg").datagrid('getEditor', {index:rowIndex, field:'Code'});
		 	
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	    	AutLocID=rowData.ID;    ///������ID
 			var params=AutLocID;
				$('#autlocitmdg').datagrid({
					url:'dhcapp.broker.csp?ClassName=web.DHCADVAUTLOC&MethodName=QueryAutLocItm&AutLParentID='+params
				});
 			
        } 
	});
	
	//initScroll("#autlocdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
     //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMedUseLink(); //���ò�ѯ
        }
    });
    
   
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findMedUseLink(); //���ò�ѯ
    });
    
   /*  $('#autlocdg').datagrid({
		url:url+'?action=QueryMedUseLink',	
		queryParams:{
			params:''}
	}); */
	InitAutLocItmParam();
	
	//��datagridһ��������      
	$('#autlocitmdg').datagrid({		//�����  2016/7/13
		url:url+'?action=JoeClearPage',	
		queryParams:{
			params:''}
	});
	
	
})  //������functions����


// ��������
function insertRow()
{	
	if(editRow>="0"){
		$("#autlocdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#autlocdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		
		row: {ID: '',Code:'',Desc: '',Parent:'',Active:'Y'}
	});
	
	$("#autlocdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	var ed = $("#autlocdg").datagrid('getEditor', {index:0, field:'Code'});
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#autlocdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (!rows.length>0){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (rows.length>1){
		$.messager.alert("��ʾ:","��ѡ��һ������,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			runClassMethod("web.DHCADVAUTLOC","DelAutLoc",{'AutLID':rows[0].ID},function(data){ 
	 			if(data==0){
					$.messager.alert('��ʾ','ɾ���ɹ�');	
				}else if(data==-1){
					$.messager.alert('��ʾ','�����ݴ��й�ϵ��Ϣ������ɾ��');	
				}else{
					$.messager.alert('��ʾ','ɾ��ʧ��');
				}
				$('#autlocdg').datagrid('reload'); //���¼���
				$('#autlocitmdg').datagrid('reload'); //���¼��� 
	 		})
		}
	});
}
// ����༭��
function saveRow()
{
	if(editRow>="0"){
		$("#autlocdg").datagrid('endEdit', editRow);
	}

	var rows = $("#autlocdg").datagrid('getChanges');
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
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Parent+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");

	//��������
	runClassMethod("web.DHCADVAUTLOC","SaveAutLocList",{'DataList':rowstr},function(data){ 
		
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
		$('#autlocdg').datagrid('reload'); //���¼���
		
	});
}

// �༭��
var texteditor={
	type: 'validatebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}
// �༭��
var editor={
	type: 'validatebox'//���ñ༭��ʽ

}


// ��ѯ
function findMedUseLink()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#autlocdg').datagrid('load',{params:params}); 
}
/// =====================================��ҩ������Ŀ����=============================
function InitAutLocItmParam()
{
		//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				
				var ed=$("#autlocitmdg").datagrid('getEditor',{index:editmuliRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}

	// ����columns
	var columns=[[
		{field:'Code',title:'����',width:150,editor:texteditor},
		{field:"Desc",title:'����',width:150,editor:texteditor},
		{field:'Parent',title:'����',width:150,editor:texteditor},
		{field:'Active',title:'�Ƿ����',width:100,editor:activeEditor},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#autlocitmdg').datagrid({
		title:'����2',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVAUTLOC&MethodName=QueryAutLocItm&AutLParentID='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			if ((editmuliRow != "")||(editmuliRow == "0")) {
            	 $("#autlocitmdg").datagrid('endEdit', editmuliRow); 
			}            
            $("#autlocitmdg").datagrid('beginEdit', rowIndex); 
            editmuliRow = rowIndex; 
        }
       
	});
	
	//initScroll("#autlocitmdg");//��ʼ����ʾ���������
	
	//��ť���¼�
    $('#insali').bind('click',insaliRow); 
    $('#delali').bind('click',delaliRow);
    $('#savali').bind('click',savaliRow);
	

}
// ��������
function insaliRow()
{

	if( editmuliRow>="0"){
		$("#autlocitmdg").datagrid('endEdit',  editmuliRow);//�����༭������֮ǰ�༭����
	}
	$("#autlocitmdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: '',Parent:AutLocID,Active: 'Y'}
	});
	$("#autlocitmdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	 editmuliRow=0;
}

// ɾ��ѡ����
function delaliRow()
{
	var rows = $("#autlocitmdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (!rows.length>0){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (rows.length>1){
		$.messager.alert("��ʾ:","��ѡ��һ������,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			runClassMethod("web.DHCADVAUTLOC","DelAutLoc",{'AutLID':rows[0].ID},function(data){ 
				if(data==0){
					$.messager.alert('��ʾ','ɾ���ɹ�');	
				}else if(data==-1){
					$.messager.alert('��ʾ','�����ݴ���ʹ����Ϣ������ɾ��');	
				}else{
					$.messager.alert('��ʾ','ɾ��ʧ��');
				}
				$('#autlocitmdg').datagrid('reload'); //���¼���
			});
		}
	});
}

// ����༭��
function savaliRow()
{
	if( editmuliRow>="0"){
		$("#autlocitmdg").datagrid('endEdit',  editmuliRow);
	}
	var rows = $("#autlocitmdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(AutLocID==""){
			$.messager.alert("��ʾ","��ѡ��һ����ҩ��������!"); 
			return false;
		}
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].Active=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Parent+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&")
	
	//��������
	runClassMethod("web.DHCADVAUTLOC","SaveAutLocList",{'DataList':rowstr},function(data){ 
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
		$('#autlocitmdg').datagrid('reload'); //���¼���
		
	});
	
}

