/// Creator: bianshuai
/// CreateDate:2014-06-20
/// Descript:������ά��JS

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp"
var dataArray = [{ "value": "Y", "text": "��" }, { "value": "N", "text": "��" }]
$(function()
{
	$("#dg").datagrid({
		idField:"ID",
		url: url+"?actiontype=SelAuditPreCon",
		rownumbers:true,
		striped: true,
		pageList : [15, 30, 45],   // ��������ÿҳ��¼�������б�
		pageSize : 15 ,  // ÿҳ��ʾ�ļ�¼����
		//fitColumns:true,
		sortName: "RowID", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		columns: [[
		{	
			field:"ID",
			title:"ID",
			width:60,
			align:"center",
			hidden:true
		},{	
			field:"LocDr",
			title:"LocDr",
			width:60,
			align:"center",
			editor:'text' //,
			//hidden:true
		},{
			field:"LocDesc",
			title:"����",
			width:200,
			align:"left",
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					required: true,//���ñ༭��������
					valueField: "value", 
					textField: "text",
					url: url+'?actiontype=SelAllLoc&loctype=E',
					onSelect:function(option){
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'LocDr'});
						$(ed.target).val(option.value);  //���ÿ���ID
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'LocDesc'});
						$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
					}
				}
			}
		},{
			field:"ChargeFlag",
			title:"�Ʒѿ���",
			width:80,
			align:"center",
			editable:true,
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					//required: true//���ñ༭��������
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto"  //���������߶��Զ����� 
				}
			},
			formatter:function(val,rec){
				return unitformatter(val);
				}
		},{
			field:"DispenFlag",
			title:"��ҩ����",
			width:80,
			align:"center",
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					//required: true//���ñ༭��������
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto"  //���������߶��Զ����� 
					}
			},
			formatter:function(val,rec){
				return unitformatter(val);
				}
		},{
			field:"UserCode",
			title:"����",
			width:100,
			align:"center",
			editor:'text'
		},{
			field:"UserName",
			title:"�û�",
			width:100,
			align:"left",
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					required: true,//���ñ༭��������
					valueField:"value", 
					textField: "text",
					url: url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'],
					onSelect:function(option){
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'UserCode'});
						$(ed.target).val(option.value);  //�����û�����
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'UserName'});
						$(ed.target).combobox('setValue', option.text); //�����û����� 
					}
				}
			}
		}]],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})

	//����
	$('#dept').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		  url:url+'?actiontype=SelAllLoc&loctype=E'
	}); 

	//�û�
	$('#user').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'] 
	});  
	
	//���÷�ҳ�ؼ�   
	$('#dg').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		afterPageText: 'ҳ    �� {pages} ҳ',   
		displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	});
})

// ��ʽ��
function unitformatter(value, rowData, rowIndex){
    for (var i = 0; i < dataArray.length; i++){ 
        if (dataArray[i].value == value){ 
			if(value=="Y"){color="green";
			}else{
				color="red";}
			return '<span style="font-weight:bold;color:'+color+'">'+dataArray[i].text+'</span>';
        } 
    } 
}

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',LocDr:'',LocDesc: '',ChargeFlag:'Y',DispenFlag: 'N',UserCode:"",UserName:''}
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
				$.post(url+'?actiontype=Delete',{"index":rows[0].ID}, function(data){
					$('#dg').datagrid('reload'); //���¼���
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
		if((rows[i].LocDr=="")||(rows[i].UserCode=="")){
			$.messager.alert("��ʾ","���һ��û�������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].LocDr+"^"+rows[i].ChargeFlag+"^"+rows[i].DispenFlag;
		tmp=tmp+"^"+rows[i].UserCode;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//��������
	$.post(url+'?actiontype=Update',{"datelist":rowstr},function(data){
		$('#dg').datagrid('reload'); //���¼���
	});
}

// �޸�ѡ����
function modifyRow()
{
	var rows = $("#dg").datagrid('getSelections'); //ѡ��һ�н��б༭
	//ѡ��һ�еĻ������¼�
	if (rows.length == 1)
	{
		if(editRow!=""){
			$("#dg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
		}
		var index = $("#dg").datagrid('getRowIndex', rows[0]);//��ȡѡ���е�����
		$("#dg").datagrid('beginEdit',index);
		editRow=index;  //��¼��ǰ�༭��
	}else{
		$.messager.alert("��ʾ","��ѡ����༭��!");
	}
}

// ��ѯ
function query()
{
	var dept=$('#dept').combobox('getValue'); 
	var usercode=$('#user').combobox('getValue');
	//combobox ɾ�����ݺ�Ϊundefined
	if (dept== undefined){dept="";}
	if (usercode== undefined){usercode="";}
	var params=dept+"^"+usercode;
	$('#dg').datagrid('load',{params:params}); 
}
  
