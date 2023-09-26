var preRowID=0
var GlobalObj = {
	MapTypeID : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="ESourceID") this.ItemDR="";
	},
	ClearAll : function()
	{
		this.MapTypeID = "";
	}
}

$(document).ready(function()
{
	initDocument();
	$('#tdhceqmccasereasondealmap').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		fit:'true',
		queryParams:{
			ClassName:"web.DHCEQM.DHCEQMCCaseReasonDealMap",
			QueryName:"GetCaseReasonDealMap",
			Arg1:$("#MapType").val(),
			Arg2:$("#SourceID").combogrid("getValue"),
			Arg3:$("#MapSourceID").combogrid("getValue"),
			ArgCnt:3
			},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){UpdateGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-search',
				text:'��ѯ',
				handler:function(){FindGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TMapTypeID',title:'��Ҫ����ID',width:100,align:'center',hidden:true}, 
			{field:'TMapType',title:'��Ҫ����',width:150,align:'center'},
			{field:'TSourceID',title:'��ԴID',width:50,align:'center',hidden:true}, 
			{field:'TSource',title:'��Դ����',width:100,align:'center'},
			{field:'TMapSourceID',title:'����ID',width:100,align:'center',hidden:true},
			{field:'TMapSource',title:'��������',width:150,align:'center'},
		]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});

	
});
function initDocument()
{
	GlobalObj.ClearAll();
	if (jQuery("#MapType").prop("type")!="hidden")
	{
		document.getElementById('TDSourceID').innerHTML="��Դ����"
		document.getElementById('TDMapSourceID').innerHTML="��������"
		jQuery("#MapType").combobox({
			width:150,
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '1',
				text: '�������������ԭ�����'
			},{
				id: '2',
				text: '����ԭ��������������'
			}],
			onSelect: function() {GlobalObj.MapTypeID=jQuery("#MapType").combobox("getValue");
			if (GlobalObj.MapTypeID==1)
			{
				document.getElementById('TDSourceID').innerHTML="��������"
				document.getElementById('TDMapSourceID').innerHTML="����ԭ��"
				$("#SourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'FaultCase',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'��λ',width:30,align:'center',hidden:true},
					{field:'TCode',title:'����',width:30,align:'center'},
					{field:'TName',title:'����',width:170,align:'center'}
				]],
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]

			});
				$("#MapSourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'Faultreason',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'��λ',width:30,align:'center',hidden:true},
					{field:'TCode',title:'����',width:30,align:'center'},
					{field:'TName',title:'����',width:170,align:'center'}
				]],
				//fit:'true',
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
			});			
			}
			else if(GlobalObj.MapTypeID==2) 
			{
				document.getElementById('TDSourceID').innerHTML="����ԭ��"
				document.getElementById('TDMapSourceID').innerHTML="�������"			
				$("#SourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'Faultreason',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'��λ',width:30,align:'center',hidden:true},
					{field:'TCode',title:'����',width:30,align:'center'},
					{field:'TName',title:'����',width:170,align:'center'}
				]],
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]

			});			
				$("#MapSourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'DealMethod',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'��λ',width:30,align:'center',hidden:true},
					{field:'TCode',title:'����',width:30,align:'center'},
					{field:'TName',title:'����',width:170,align:'center'}
				]],
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
			});		
			}
			}
		});
	}
}

function OnclickRow()
{
	var selected=$('#tdhceqmccasereasondealmap').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			$('#RowID').val(selected.TRowID);					
			$('#MapTypeID').val(selected.TMapTypeID);
			GlobalObj.MapTypeID=selected.TMapTypeID;
			$('#MapType').combobox('setText',selected.TMapType);
			$('#SourceID').combogrid('setValue',selected.TSourceID);
			$('#SourceID').combogrid('setText',selected.TSource);
			//$('#Source').combogrid('setValue',selected.TSource);
			$('#MapSourceID').combogrid('setValue',selected.TMapSourceID);
			$('#MapSourceID').combogrid('setText',selected.TMapSource);
			if(GlobalObj.MapTypeID==1)
			{
				document.getElementById('TDSourceID').innerHTML="��������"
				document.getElementById('TDMapSourceID').innerHTML="����ԭ��"

			}
			else if(GlobalObj.MapTypeID==2)
			{
				document.getElementById('TDSourceID').innerHTML="����ԭ��"
				document.getElementById('TDMapSourceID').innerHTML="�������"			
	
			}
			preRowID=selectedRowID;

		}
		else
		{
			ClearElement();
			$('#tdhceqmccasereasondealmap').datagrid('unselectAll');
				document.getElementById('TDSourceID').innerHTML="��Դ����"
				document.getElementById('TDMapSourceID').innerHTML="��������"			
			selectedRowID = 0;
			preRowID=0;
		}
	}
}
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+GlobalObj.MapTypeID;
	val+="^"+$("#SourceID").combogrid("getValue");
	val+="^"+$("#MapSourceID").combogrid("getValue");
	
	return val;
}

function FindGridData() 
{
	$('#tdhceqmccasereasondealmap').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
			QueryName:'GetCaseReasonDealMap',
			Arg1:$("#MapType").val(),
			Arg2:$("#SourceID").combogrid("getValue"),
			Arg3:$("#MapSourceID").combogrid("getValue"),
			ArgCnt:3
		}
	});
	ClearElement();
}

function ClearElement()
{
	$('#RowID').val('');
	GlobalObj.MapTypeID="";
	$('#MapType').combobox('setValue',''); 
	$('#SourceID').combogrid('setValue','');
	$('#MapSourceID').combogrid('setValue','');

}

function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if(GlobalObj.MapTypeID==""){$.messager.alert('��ʾ','����ʧ��,��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#SourceID").combogrid('getValue')==""){$.messager.alert('��ʾ','����ʧ��,����ID����Ϊ�գ�','warning');return;}
	if($("#MapSourceID").combogrid('getValue')==""){$.messager.alert('��ʾ','����ʧ��,��ԴID����Ϊ�գ�','warning');return;}
    $.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
			MethodName:'SaveData',
			Arg1:CombineData(),
			ArgCnt:1
			
		},		
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})		
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			if(data>0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tdhceqmccasereasondealmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}

function UpdateGridData()
{
	//messageShow("","","",CombineData())
	if($("#RowID").val()==""){$.messager.alert('��ʾ','��ѡ��һ�����ݣ�','warning');return;}
	//if(GlobalObj.MapTypeID==""){$.messager.alert('��ʾ','��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#SourceID").combogrid('getValue')==""){$.messager.alert('��ʾ','����ID����Ϊ�գ�','warning');return;}
	//if(GlobalObj.ESourceTypeID==""){$.messager.alert('��ʾ','��Դ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#MapSourceID").combogrid('getValue')==""){$.messager.alert('��ʾ','��ԴID����Ϊ�գ�','warning');return;}
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
			MethodName:'SaveData',
			Arg1:CombineData(),
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			if(data>0)
			{
				$.messager.show({title: '��ʾ',msg: '���³ɹ�'});
				$('#tdhceqmccasereasondealmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}

function DeleteGridData()
{
	if($("#RowID").val()==""){$.messager.alert('��ʾ','��ѡ��һ�����ݣ�','warning');return;}
	$.messager.confirm('ȷ��', '��ȷ��Ҫɾ����ѡ������', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
				ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
				MethodName:'DeleteData',
				Arg1:$("#RowID").val(),
				ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data==0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					$('#tdhceqmccasereasondealmap').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}