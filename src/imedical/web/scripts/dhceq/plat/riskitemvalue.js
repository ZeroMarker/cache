var preRowID=0
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	//showBtnIcon('BFind',false); //modified by LMH 20230202 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	//initButtonWidth();  //modified by LMH 20230302 UI
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  �޸ĵ�����ʾundefined
	setRequiredElements("Weight^Desc")
	initDHCEQCRiskItemValue();			//��ʼ�����

}	
function BFind_Clicked()
{
	initDHCEQCRiskItemValue()
}
function initDHCEQCRiskItemValue()
{
	$HUI.datagrid("#tDHCEQCRiskItemValue",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.CTItem",
	        QueryName:"GetRiskItemValue",
	        RiskItem:getElementValue("RiskItem"),
	        Weight:getElementValue("Weight"),
			Desc:getElementValue("Desc"),
	    },
	    //border : false,
	    singleSelect:true,
		//fitColumns:true, //modified by LMH 20230202  ����ʱĬ���������
		pagination:true,
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TDesc',title:'����',width:250,align:'center'},
			{field:'TWeight',title:'Ȩ��',width:100,align:'center'},
			{field:'TRemark',title:'��ע',width:100,align:'center'},
		]],
    	toolbar:[
			{
				id:"add",
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddGridData();}
			},
			{
				id:"update",
				iconCls:'icon-update',
				text:'����',
				handler:function(){UpdateGridData();}
			},
			{
				id:"delete",
				iconCls:'icon-cancel',  //modify by zc0062 2020-04-03 UI����ťͼ�����
				text:'ɾ��',
				handler:function(){DeleteGridData();}
			}
		], 
		onClickRow:function(rowIndex,rowData){OnclickRow();},

});
}
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+$("#RiskItem").val();
	val+="^"+$("#Weight").val();
	val+="^"+$("#Desc").val();
	val+="^"+$("#Remark").val();
	return val;
}

function OnclickRow()
{
	var selected=$('#tDHCEQCRiskItemValue').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			FillData(selectedRowID)
			$("#RowID").val(selectedRowID)
			preRowID=selectedRowID;
		}
		else
		{
			ClearElement();
			$('#tDHCEQCRiskItemValue').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
		}
	}
}
function FillData(rowid)
{
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTItem',
			MethodName:'GetOneRiskItemValue',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			//messageShow("","","",list)
			$('#Weight').val(list[1]);
			$('#Desc').val(list[2]);
			$('#Remark').val(list[3]);
		}
	});
}
function ClearElement()
{
	$('#RowID').val("");
	$('#Weight').val("");
	$('#Desc').val("");
	$('#Remark').val("");
}
function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTItem',
			MethodName:'SaveRiskItemValue',
			Arg1:CombineData(),
			Arg2:'',
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			data=data.split("^");
			if(data>0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tDHCEQCRiskItemValue').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
			}
		}
	});
}
function UpdateGridData()
{
	if($("#RowID").val()==""){$.messager.alert('��ʾ','����ʧ��,��Ҫѡ��һ����¼��','warning');return;}
	if (checkMustItemNull()) return;

	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTItem',
			MethodName:'SaveRiskItemValue',
			Arg1:CombineData(),
			Arg2:'',
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			data=data.split("^");
			if(data>0)
			{
				$.messager.show({title: '��ʾ',msg: '���³ɹ�'});
				$('#tDHCEQCRiskItemValue').datagrid('reload');
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
					ClassName:'web.DHCEQ.Risk.CTItem',
					MethodName:'SaveRiskItemValue',
					Arg1:CombineData(),
					Arg2:'1',
					ArgCnt:2
			},
			beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data>0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					$('#tDHCEQCRiskItemValue').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}

