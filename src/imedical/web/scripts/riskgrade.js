var preRowID=0
var t=[]             //add hly 20190724
t[-3003]="�����ظ�"  //add hly 20190724
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
	showBtnIcon('BFind',false); //modified by LMH 20230202 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  �޸ĵ�����ʾundefined
	initLookUp();	//CZF0134 2021-02-23
	setRequiredElements("Code^Desc")
	initDHCEQCRiskGrade();			//��ʼ�����

}	
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+$("#Code").val();
	val+="^"+$("#Desc").val();
	val+="^"+$("#MinValue").val();
	val+="^"+$("#MaxValue").val();
	val+="^"+$("#Remark").val();
	val+="^"+$("#CycleNum").val();		//CZF0134 2021-02-23
	val+="^"+$("#CycleUnitDR").val();
	return val;
}

function OnclickRow()
{
	var selected=$('#tDHCEQCRiskGrade').datagrid('getSelected');
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
			$('#tDHCEQCRiskGrade').datagrid('unselectAll');
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
			ClassName:'web.DHCEQ.Risk.CTGrade',
			MethodName:'GetOneRiskGrade',
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
			$('#MinValue').val(list[2]);
			$('#MaxValue').val(list[3]);
			$('#Remark').val(list[4]);
			$('#CycleNum').val(list[6]);	//CZF0134 2021-02-23
			$('#CycleUnitDR').val(list[7]);
			$('#CycleUnit').val(list[8]);
		}
	});
}
function ClearElement()
{
	$('#RowID').val("");
	$('#Code').val("");
	$('#Desc').val("");
	$('#MinValue').val("");
	$('#MaxValue').val("");
	$('#Remark').val("");
	$('#CycleNum').val("");		//CZF0134 2021-02-23
	$('#CycleUnitDR').val("");
	$('#CycleUnit').val("");
}
function BFind_Clicked()
{
	initDHCEQCRiskGrade()
}

function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTGrade',
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
				$('#tDHCEQCRiskGrade').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.alert('����ʧ�ܣ�',t[data], 'warning');  //modify hly 20190724
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
			ClassName:'web.DHCEQ.Risk.CTGrade',
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
				$('#tDHCEQCRiskGrade').datagrid('reload');
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
					ClassName:'web.DHCEQ.Risk.CTGrade',
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
					$('#tDHCEQCRiskGrade').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}
function initDHCEQCRiskGrade()
{
	$HUI.datagrid("#tDHCEQCRiskGrade",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.CTGrade",
	        QueryName:"GetRiskGrade",
	        Code:getElementValue("Code"),
			Desc:getElementValue("Desc"),
			MinValue:getElementValue("MinValue"),
			MaxValue:getElementValue("MaxValue"),
	    },
	    //border : false,
	    fit:true,  //midified by LMH 20230202 UI���ֵ��� �����޸�
	    singleSelect:true,
		//fitColumns:true, //midified by LMH 20230202 UI���ֵ���
		pagination:true,
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TCode',title:'����',width:100,align:'center'},
			{field:'TDesc',title:'����',width:250,align:'center'},
			{field:'TMinValue',title:'��Сֵ',width:100,align:'center'},
			{field:'TMaxValue',title:'���ֵ',width:100,align:'center'},
			{field:'TCycle',title:'����',width:100,align:'center'},		//CZF0134 2021-02-23
			{field:'TCycleNum',title:'����',width:20,align:'center',hidden:true},
			{field:'TCycleUnitDR',title:'TCycleUnitDR',width:20,align:'center',hidden:true},
			{field:'TRemark',title:'��ע',width:100,align:'center'},
		]],
    	toolbar:[
			{
				id:"add",
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddGridData();}
			},  //modify by lmm 2020-03-30 UI���ֵ���
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
//CZF0134 2021-02-23
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
