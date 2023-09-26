function initBillItem()
{
	$('#tDHCEQBillItem').datagrid({
	    url:'dhceq.jquery.csp',
	    queryParams:{
			ClassName:"web.DHCEQBillItem",
			QueryName:"GetBillItem",
			Arg1:"2",
			Arg2:GlobalObj.EquipDR,
			ArgCnt:2
	    },
		fit:true,
		border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddBillItemData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){SaveBillItemData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteBillItemData();}
			}
		],
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
				{field:'TCode',title:'����',width:100,align:'center',editor:texteditor},
				{field:'TDesc',title:'����',width:100,align:'center',editor:texteditor},
				{field:'TSourceType',title:'��Դ����',width:100,align:'center',hidden:true},
				{field:'TSourceID',title:'��Դ',width:100,align:'center',hidden:true},
				{field:'TPrice',title:'�շѼ۸�',width:100,align:'center',editor:texteditor},
				{field:'TCost',title:'�ɱ�',width:100,align:'center',editor:texteditor},
				{field:'TWorkLoadNum',title:'Ԥ�ƹ�����',width:100,align:'center',editor:texteditor},
				{field:'TDevelopStatusDR',title:'TDevelopStatusDR',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TDevelopStatus',title:'�¿������ܱ��',width:100,align:'center',editor:comboboxeditor},
				{field:'TUsedFlag',title:'ʹ�ñ��',width:60,align:'center',formatter:function(value,row,index){return checkBox(value,"checkboxChange",this,index)}},
			]],
			pageSize:20,  // ÿҳ��ʾ�ļ�¼����
			pageList:[20],   // ��������ÿҳ��¼�������б�
	        singleSelect:true,
			loadMsg: '���ڼ�����Ϣ...',
			pagination:true,
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQBillItem').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }
	});
}
// ����༭��
function SaveBillItemData()
{
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQBillItem').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+rows[i].TCode+"^"+rows[i].TDesc+"^2^"+GlobalObj.EquipDR+"^"+rows[i].TPrice+"^"+rows[i].TCost+"^"+rows[i].TWorkLoadNum+"^"+rows[i].TDevelopStatusDR+"^"+rows[i].TUsedFlag;
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQBillItem',
			MethodName:'SaveBillItem',
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
			var list=data.split("^");
			if(list[0]==0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tDHCEQBillItem').datagrid('reload');
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+list[0]+",ԭ��:"+list[1], 'warning');
		}
	});
}
// ��������
function AddBillItemData()
{
	var SourceType=$("#SourceType").val();
	var SourceID=$("#SourceID").val();
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	//��ָ����������ݣ�appendRow�������һ���������
	$('#tDHCEQBillItem').datagrid('appendRow', 
	{
		TRowID: '',
		TCode:'',
		TDesc: '',
		TPrice:'',
		TCost:'',
		TWorkLoadNum:'',
		TDevelopStatusDR:'',
		TDevelopStatus:'',
		TUsedFlag:''
	});
	editFlag=0;
}
//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteBillItemData()
{
	var rows = $('#tDHCEQBillItem').datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQBillItem',
							MethodName:'DeleteBillItem',
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
								$('#tDHCEQBillItem').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQBillItem').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQBillItem').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
var comboboxeditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		panelHeight:"auto",  //���������߶��Զ�����
		    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '0',
				text: 'ԭ�й���'
			},{
				id: '1',
				text: '�ɿ�������'
			},{
				id: '2',
				text: '�ѿ�������'
			}],
		onSelect:function(option){
			var ed=$('#tDHCEQBillItem').datagrid('getEditor',{index:editFlag,field:'TDevelopStatusDR'});
			jQuery(ed.target).val(option.id);  //����ID
			var ed=$('#tDHCEQBillItem').datagrid('getEditor',{index:editFlag,field:'TDevelopStatus'});
			jQuery(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
		}
	}
}
function checkboxChange(TUsedFlag,rowIndex)
{
	var row = $('#tDHCEQBillItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
		if (TUsedFlag==key)
			{
				if (((val=="N")||val=="")) row.TUsedFlag="Y"
				else row.TUsedFlag="N"
			}
		})
	}
}
