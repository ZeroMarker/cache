var preRowID=0
var t=[]
t[-3003]="�����ظ�"
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
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  �޸ĵ�����ʾundefined
	setRequiredElements("Code^Desc")
	initDHCEQCRiskItem();			//��ʼ�����

}	
function BFind_Clicked()
{
	initDHCEQCRiskItem()
}
function initDHCEQCRiskItem()
{
	$HUI.datagrid("#tDHCEQCRiskItem",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.CTItem",
	        QueryName:"GetRiskItem",
	        Code:getElementValue("Code"),
			Desc:getElementValue("Desc"),
	    },
	    //border : false,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TCode',title:'����',width:100,align:'center'},
			{field:'TDesc',title:'����',width:250,align:'center'},
			{field:'TRemark',title:'��ע',width:100,align:'center'},
			{field:'TOpt',title:'��������',width:100,align:'center',formatter: detailOperation},
		]],
    	toolbar:[
			{
				id:"add",
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddGridData();}
			},'-----------------------------------',
			{
				id:"update",
				iconCls:'icon-update',
				text:'����',
				handler:function(){UpdateGridData();}
			},'-----------------------------------',
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
//modified by csj 20190201 UI���󵯴��޸�
function detailOperation(value,row,index)
{
	var str="RiskItem="+row.TRowID;
	var url='dhceq.plat.riskitemvalue.csp?'+str
	var title="��������"
	var icon="icon-w-paper"
	var showtype=""
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+showtype+'&quot;,&quot;&quot;,&quot;&quot;,&quot;middle&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>' ///modify by lmm 2020-05-15
	return btn;
}
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+$("#Code").val();
	val+="^"+$("#Desc").val();
	val+="^"+$("#Remark").val();
	return val;
}

function OnclickRow()
{
	var selected=$('#tDHCEQCRiskItem').datagrid('getSelected');
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
			$('#tDHCEQCRiskItem').datagrid('unselectAll');
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
			MethodName:'GetOneRiskItem',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			//messageShow("","","",list)
			$('#Code').val(list[0]);
			$('#Desc').val(list[1]);
			$('#Remark').val(list[2]);
		}
	});
}
function ClearElement()
{
	$('#RowID').val("");
	$('#Code').val("");
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
			MethodName:'SaveData',
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
				$('#tDHCEQCRiskItem').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.alert('����ʧ�ܣ�',t[data], 'warning');//modify hly 20190724
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
			MethodName:'SaveData',
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
				$('#tDHCEQCRiskItem').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('����ʧ�ܣ�',t[data], 'warning'); //modify hly 20190724
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
					MethodName:'SaveData',
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
					$('#tDHCEQCRiskItem').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}

