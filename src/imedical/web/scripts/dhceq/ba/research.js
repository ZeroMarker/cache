var url="dhceq.jquery.operationtype.csp";
function initResearch()
{
	$('#tDHCEQResearch').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQResearch",
			QueryName:"GetResearch",
			Arg1:GlobalObj.EquipDR,
			ArgCnt:1
			},
    	border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddResearchGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){SaveResearchGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteResearchGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TName',title:'����',width:60,align:'center',editor:texteditor},
			{field:'TType',title:'����',width:80,align:'center',editor:typecomboboxeditor},
			{field:'TTypeDR',title:'TTypeDR',width:'80',align:'center',hidden:true,editor:texteditor},
			{field:'TBeginDate',title:'��ʼ����',width:100,align:'center',editor:'datebox'},
			{field:'TEndDate',title:'�������',width:100,align:'center',editor:'datebox'},
			{field:'TUser',title:'������',width:'80',align:'center',editor:usercomboboxeditor},
			{field:'TUserDR',title:'UserDR',width:'80',align:'center',hidden:true,editor:texteditor},
			{field:'TParticipant',title:'������',width:'80',align:'center',editor:texteditor},
			{field:'TLevel',title:'����',width:'60',align:'center',editor:texteditor},
			{field:'TRemark',title:'��ע',width:100,align:'center',editor:texteditor},
		]],
		pagination:true,
		pageSize:15,
		pageNumber:15,
		loadMsg: '���ڼ�����Ϣ...',
		pageList:[15,30,45,60,75],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQResearch').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQResearch').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	        }
        }
	});
}
function AddResearchGridData()
{
	var SourceType=$("#SourceType").val();
	var SourceID=$("#SourceID").val();
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	$('#tDHCEQResearch').datagrid('appendRow', {//��ָ����������ݣ�appendRow�������һ���������
		TRowID: '',TName:'',TType: '',TTypeDR:'',TBeginDate:'',TEndDate:'',TUser:'',TUserDR:'',TParticipant:'',TLevel:'',TRemark:''}
	);
	editFlag=0;
}

function SaveResearchGridData()
{
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQResearch').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+GlobalObj.EquipDR+"^"+rows[i].TName+"^"+rows[i].TTypeDR+"^"+rows[i].TBeginDate+"^"+rows[i].TEndDate+"^"+rows[i].TUserDR+"^"+rows[i].TParticipant+"^"+rows[i].TLevel+"^"+rows[i].TRemark;
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQResearch',
			MethodName:'SaveResearch',
			Arg1:CombineData,
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			if(data==0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tDHCEQResearch').datagrid('reload');
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}
//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteResearchGridData()
{
	var rows = $('#tDHCEQResearch').datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQResearch',
							MethodName:'DeleteData',
							Arg1:rows[0].TRowID,
							ArgCnt:1
						},
						beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alertShow(XMLHttpRequest.status);
							alertShow(XMLHttpRequest.readyState);
							alertShow(textStatus);
						},
						success:function(data,response,status)
						{
							$.messager.progress('close');
							data=data.replace(/\ +/g,"")	//ȥ���ո�
							data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
							if(data==0)
							{
								$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
								$('#tDHCEQResearch').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQResearch').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQResearch').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function AddResearchGridData()
{
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	//��ָ����������ݣ�appendRow�������һ���������
	$('#tDHCEQResearch').datagrid('appendRow', 
	{
		TRowID: '',
		TName:'',
		TType: '',
		TTypeDR:'',
		TBeginDate:'',
		TEndDate:'',
		TUser:'',
		TUserDR:'',
		TParticipant:'',
		TLevel:'',
		TRemark:''
	});
	editFlag=0;
}
var typecomboboxeditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		panelHeight:"auto",  //���������߶��Զ�����
		    valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '0',
				text: '������Ŀ'
			},{
				id: '1',
				text: '����'
			}],
		onSelect:function(option){
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TTypeDR'});
			jQuery(ed.target).val(option.id);  
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TType'});
			jQuery(ed.target).combobox('setValue', option.text);  
		}
	}
}
var usercomboboxeditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����
		url: url+'?action=GetUser',
		filter: function(q,row){  //modify by JYP20160926
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q)>-1;
			},
		onSelect:function(option){
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TUserDR'});
			jQuery(ed.target).val(option.id);  //����ID
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TUser'});
			jQuery(ed.target).combobox('setValue', option.text);  //����Desc
		}
	}
}

