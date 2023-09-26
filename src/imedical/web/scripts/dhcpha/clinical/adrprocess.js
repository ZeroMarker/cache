/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ������Ӧ�������̶���

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var dataArray = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];

$(function(){
	
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"StatusID",title:'StatusID',width:160,editor:texteditor,hidden:true},
		{field:"Status",title:'����',width:160,editor:{  //������Ϊ�ɱ༭
			type: 'combobox',//���ñ༭��ʽ
			options: {
				valueField: "val", 
				textField: "text",
				url: url+'?action=SelAdrStatus',
				onSelect:function(option){
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'StatusID'});
					$(ed.target).val(option.val);  //���ÿ���ID
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'Status'});
					$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
				}
			}
		}},
		{field:'NextStatusID',title:'NextStatusID',width:300,editor:texteditor,hidden:true},
		{field:'NextStatus',title:'��һ����',width:160,editor:{  //������Ϊ�ɱ༭
			type: 'combobox',//���ñ༭��ʽ
			options: {
				valueField: "val", 
				textField: "text",
				url: url+'?action=SelAdrStatus',
				onSelect:function(option){
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'NextStatusID'});
					$(ed.target).val(option.val);  //���ÿ���ID
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'NextStatus'});
					$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
				}
			}
		}},
		{field:'CombDepend',title:'������ϵ',width:120,
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //���������߶��Զ�����
					onSelect:function(option){
						///��������ֵ
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'CombDepend'});
						$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
					} 
				}
		}}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		//title:'���̶���',
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
            if ((editRow != "")||(editRow == "0")) {   //qunianpeng 2016-07-25
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
			
			
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'NextStatus'});
			var unitUrl='dhcpha.clinical.action.csp?action=SelAdrStatus';
			$(ed.target).combobox('reload',unitUrl);


        }
	});
	
	initScroll("#dg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    $('#dg').datagrid({
		url:url+'?action=QueryAdrProcess',	
		queryParams:{
			params:""}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: '',Category:''}
	});
	$("#dg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#dg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrProcess',{"params":rows[0].ID}, function(data){
					$('#dg').datagrid('reload'); //���¼���
				});
				//���һ������ɾ����ҳ��Ϊ�� duwensheng 2016-09-09
				if($("#dg").datagrid('getRows').length==1){
					$('#dg').datagrid('loadData',{total:0,rows:[]});
					$('#dg').datagrid('reload'); //���¼���
				}
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
		$("#dg").datagrid('endEdit', editRow);
	}

	var rows = $("#dg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
             if((rows[i].StatusID=="")||(rows[i].NextStatusID=="")||(rows[i].CombDepend=="")){
			$.messager.alert("��ʾ","���̻���һ���̻�������ϵ����Ϊ��!"); 
			return false;
		}
		
		var tmp=rows[i].ID+"^"+rows[i].StatusID+"^"+rows[i].NextStatusID+"^"+rows[i].CombDepend;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");   
	  //wangxuejian 2016-10-10
	$.post(url+'?action=SaveAdrProcess',{"params":rowstr},function(data){

		if(data==0)
		{
	        $.messager.alert("��ʾ","����ɹ�!");
		}
		if(data==1)
		{
				$.messager.alert("������ʾ","�����ظ�,��˶�!","error");
		}   
		$('#dg').datagrid('reload'); //���¼���
		});
	}
	/*//�������ݣ����������ͬ������ʧ�� duwensheng 2016-09-07
	var rowdata=$("#dg").datagrid('getRows'); //������
	var len=rowdata.length;
	var sum=0; //�����
	for(var m=1;m<len;m++){
		var dataold=rowdata[m].Status+','+rowdata[m].NextStatus+','+rowdata[m].CombDepend; //��������
		var datanew=rowdata[0].Status+','+rowdata[0].NextStatus+','+rowdata[0].CombDepend; //�²�����
		if(dataold!=datanew){
			var sum=sum+1; 
		}
	}
	if(sum==(len-1)){ //�������ظ�����,�ύ
		$.post(url+'?action=SaveAdrProcess',{"params":rowstr},function(data){
		$('#dg').datagrid('reload'); //���¼���
		});
	}
	else{
		alert("�����ظ�,��˶�!");
		$('#dg').datagrid('reload'); //���¼���
	}*/



var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}
