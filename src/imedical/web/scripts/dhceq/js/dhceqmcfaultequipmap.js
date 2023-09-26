var preRowID=0
var GlobalObj = {
	BrandDR : "",
	ModelDR : "",
	MapTypeID : "",
	ESourceTypeID : "",
	ItemDR: "",
	ClearData : function(vElementID)
	{
		if (vElementID=="Brand") this.BrandDR="";
		if (vElementID=="Model") this.ModelDR="";
		if (vElementID=="ESourceID") this.ItemDR="";
	},
	ClearAll : function()
	{
		this.BrandDR="";
		this.ModelDR="";
		this.MapTypeID = "";
		this.ESourceTypeID="";
		this.ItemDR=""
	}
}

$(document).ready(function()
{
	initDocument();
	$('#tdhceqmcfaultequipmap').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		fit:'true',
		queryParams:{
			ClassName:"web.DHCEQM.DHCEQMCFaultEquipMap",
			QueryName:"GetFaultEquipMap",
			Arg1:$("#MapType").val(),
			Arg2:$("#FaultID").combogrid("getValue"),
			Arg3:$("#ESourceType").val(),
			Arg4:$("#ESourceID").combogrid("getValue"),
			ArgCnt:4
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
			{field:'TMapType',title:'��Ҫ����',width:100,align:'center'},
			{field:'TFaultID',title:'����ID',width:50,align:'center',hidden:true}, 
			{field:'TFault',title:'��������',width:100,align:'center'},
			{field:'TESourceTypeID',title:'��Դ����ID',width:100,align:'center',hidden:true},
			{field:'TESourceType',title:'��Դ����',width:100,align:'center'},
			{field:'TESourceID',title:'��ԴID',width:200,align:'center',hidden:true}, 
			{field:'TCode',title:'����',width:200,align:'center',hidden:true},
			{field:'TESource',title:'��Դ����',width:200,align:'center'},
			{field:'TEModelDR',title:'����DR',width:100,align:'center',hidden:true},
			{field:'TEModel',title:'����',width:100,align:'center'},
			{field:'TEBrandDR',title:'Ʒ��DR',width:100,align:'center',hidden:true},
			{field:'TEBrand',title:'Ʒ��',width:100,align:'center'},
			{field:'TUsedFlag',title:'ʹ�ñ��',width:100,align:'center'},
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
	initBrandPanel();
	initModelPanel();
	initBrandData();
	initModelData();
	
	if (jQuery("#MapType").prop("type")!="hidden")
	{
		document.getElementById('TDFaultID').innerHTML="��������"
		jQuery("#MapType").combobox({
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
				text: '��������'
			},{
				id: '2',
				text: '����ԭ��'
			},{
				id: '3',
				text: '���Ͻ������'
			}],
			onSelect: function() {GlobalObj.MapTypeID=jQuery("#MapType").combobox("getValue");
			if (GlobalObj.MapTypeID==1)
			{
				document.getElementById('TDFaultID').innerHTML="��������"
				$("#FaultID").combogrid({
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
				//fit:'true',
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
				
			});
			}
			else if(GlobalObj.MapTypeID==2) 
			{
				document.getElementById('TDFaultID').innerHTML="����ԭ��"
				$("#FaultID").combogrid({
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
			else if (GlobalObj.MapTypeID==3)
			{
				document.getElementById('TDFaultID').innerHTML="�������"
				$("#FaultID").combogrid({
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
				//fit:'true',
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
			});		
			}
			}
		});
	}
	if (jQuery("#ESourceType").prop("type")!="hidden")
	{
		document.getElementById('TDESourceID').innerHTML="��Դ����"
		jQuery("#ESourceType").combobox({
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
				text: '�豸����'
			},{
				id: '2',
				text: '�豸��'
			}],
			onSelect: function() {GlobalObj.ESourceTypeID=jQuery("#ESourceType").combobox("getValue");
			if (GlobalObj.ESourceTypeID==1)
			{
				document.getElementById('TDESourceID').innerHTML="�豸����"
				$("#ESourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'EquipCatLookUp',
				Arg1:'',
				ArgCnt:1
					},
				columns:[[
					{field:'TRowID',title:'��λ',width:30,align:'center',hidden:true},
					{field:'TCode',title:'����',width:90,align:'center'},
					{field:'TName',title:'����',width:120,align:'center'}
				]],
				//fit:'true',
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
			});		
			}
			else if (GlobalObj.ESourceTypeID==2)
			{
		document.getElementById('TDESourceID').innerHTML="�豸��"
				$("#ESourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'GetMasterItem',
				Arg1:'',Arg2:'',Arg3:'',Arg4:'',
				ArgCnt:4
					},
				columns:[[
					{field:'TRowID',title:'��λ',width:60,align:'center',hidden:true},
					{field:'TCode',title:'����',width:90,align:'center'},
					{field:'TName',title:'����',width:120,align:'center'}
				]],
				//fit:'true',
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

function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Model") {initModelData();}
	if (vElementID=="Brand") {initBrandData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Model") {GlobalObj.ModelDR = CurValue;}
	if (vElementID=="Brand") {GlobalObj.BrandDR = CurValue;}
}

function OnclickRow()
{
	var selected=$('#tdhceqmcfaultequipmap').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			$('#RowID').val(selected.TRowID);					
			$('#MapTypeID').val(selected.TMapTypeID);
			GlobalObj.MapTypeID=selected.TMapTypeID;
			$('#MapType').combobox('setText',selected.TMapType);
			$('#FaultID').combogrid('setValue',selected.TFaultID);
			$('#FaultID').combogrid('setText',selected.TFault);
			$('#Fault').combogrid('setValue',selected.TFault);
			GlobalObj.ESourceTypeID=selected.TESourceTypeID;
			$('#ESourceType').combobox('setText',selected.TESourceType);
			$('#ESourceID').combogrid('setValue',selected.TESourceID);
			$('#ESourceID').combogrid('setText',selected.TESource);
			$('#Code').val(selected.TCode);
			$('#ESource').val(selected.TESource);
			GlobalObj.BrandDR=selected.TEBrandDR;
			$('#Brand').combogrid('setText',selected.TEBrand);
			GlobalObj.ModelDR=selected.TEModelDR;
			$('#Model').combogrid('setText',selected.TEModel);
						if(GlobalObj.MapTypeID==1){
				document.getElementById('TDFaultID').innerHTML="��������"
				}
			else if(GlobalObj.MapTypeID==2){
				document.getElementById('TDFaultID').innerHTML="����ԭ��"
				}
			else if(GlobalObj.MapTypeID==3){
				document.getElementById('TDFaultID').innerHTML="�������"
				}
			if(GlobalObj.ESourceTypeID==1){
				document.getElementById('TDESourceID').innerHTML="�豸����"
				}
			else if(GlobalObj.ESourceTypeID==2){
				document.getElementById('TDESourceID').innerHTML="�豸��"
				}
			
			
			if(selected.TUsedFlag=="Y")
			{
				$("#UsedFlag").prop("checked",true);

			}
			else{$("#UsedFlag").prop("checked",false);		}
			preRowID=selectedRowID;

		}
		else
		{
			ClearElement();
			$('#tdhceqmcfaultequipmap').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
			document.getElementById('TDFaultID').innerHTML="��������"
			document.getElementById('TDESourceID').innerHTML="��Դ����"
		}
	}
}
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+GlobalObj.MapTypeID;
	val+="^"+$("#FaultID").combogrid("getValue");
	val+="^"+GlobalObj.ESourceTypeID;
	val+="^"+$("#ESourceID").combogrid("getValue");
	val+="^"+GlobalObj.ModelDR;
	val+="^"+GlobalObj.BrandDR;
	val+="^"+(($("#UsedFlag").is(':checked')==true)?'Y':'N');       //ʹ�ñ�־
	
	return val;
}

function FindGridData() 
{
	$('#tdhceqmcfaultequipmap').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQM.DHCEQMCFaultEquipMap',
			QueryName:'GetFaultEquipMap',
			Arg1:$("#MapType").val(),
			Arg2:$("#FaultID").combogrid("getValue"),
			Arg3:$("#ESourceType").val(),
			Arg4:$("#ESourceID").combogrid("getValue"),
			ArgCnt:4
		}
	});
	ClearElement();
}

function ClearElement()
{
	$('#RowID').val('');
	GlobalObj.MapTypeID="";
	$('#MapType').combobox('setValue',''); 
	$('#FaultID').combogrid('setValue','');
	$('#Fault').combogrid('setValue','');
	GlobalObj.ESourceTypeID="";
	$('#ESourceType').combobox('setValue',''); 
	$('#ESourceID').combogrid('setValue','');
	GlobalObj.ModelDR="";
	$('#Model').combogrid('setText','');
	GlobalObj.BrandDR="";
	$('#Brand').combogrid('setText','');
	$("#UsedFlag").prop("checked",false);

}

function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if(GlobalObj.MapTypeID==""){$.messager.alert('��ʾ','����ʧ��,��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#FaultID").combogrid('getValue')==""){$.messager.alert('��ʾ','����ʧ��,����ID����Ϊ�գ�','warning');return;}
	if(GlobalObj.ESourceTypeID==""){$.messager.alert('��ʾ','����ʧ��,��Դ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#ESourceID").combogrid('getValue')==""){$.messager.alert('��ʾ','����ʧ��,��ԴID����Ϊ�գ�','warning');return;}
	if(($("#ESourceType").combobox('getValue')==1)&(GlobalObj.ModelDR!="")){$.messager.alert('��ʾ','����ʧ��,�豸�����޻��ͣ�','warning');return;}
    $.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCFaultEquipMap',
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
				$('#tdhceqmcfaultequipmap').datagrid('reload');
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
	if(GlobalObj.MapTypeID==""){$.messager.alert('��ʾ','��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#FaultID").combogrid('getValue')==""){$.messager.alert('��ʾ','����ID����Ϊ�գ�','warning');return;}
	if(GlobalObj.ESourceTypeID==""){$.messager.alert('��ʾ','��Դ���Ͳ���Ϊ�գ�','warning');return;}
	if($("#ESourceID").combogrid('getValue')==""){$.messager.alert('��ʾ','��ԴID����Ϊ�գ�','warning');return;}
	if((GlobalObj.ESourceTypeID==1)&(GlobalObj.ModelDR!="")){$.messager.alert('��ʾ','�豸�����޻��ͣ�','warning');return;}
	
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCFaultEquipMap',
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
				$('#tdhceqmcfaultequipmap').datagrid('reload');
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
				ClassName:'web.DHCEQM.DHCEQMCFaultEquipMap',
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
					$('#tdhceqmcfaultequipmap').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}