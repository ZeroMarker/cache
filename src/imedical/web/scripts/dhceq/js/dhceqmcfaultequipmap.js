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
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){UpdateGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-search',
				text:'查询',
				handler:function(){FindGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TMapTypeID',title:'主要类型ID',width:100,align:'center',hidden:true}, 
			{field:'TMapType',title:'主要类型',width:100,align:'center'},
			{field:'TFaultID',title:'故障ID',width:50,align:'center',hidden:true}, 
			{field:'TFault',title:'故障名称',width:100,align:'center'},
			{field:'TESourceTypeID',title:'来源类型ID',width:100,align:'center',hidden:true},
			{field:'TESourceType',title:'来源类型',width:100,align:'center'},
			{field:'TESourceID',title:'来源ID',width:200,align:'center',hidden:true}, 
			{field:'TCode',title:'代码',width:200,align:'center',hidden:true},
			{field:'TESource',title:'来源名称',width:200,align:'center'},
			{field:'TEModelDR',title:'机型DR',width:100,align:'center',hidden:true},
			{field:'TEModel',title:'机型',width:100,align:'center'},
			{field:'TEBrandDR',title:'品牌DR',width:100,align:'center',hidden:true},
			{field:'TEBrand',title:'品牌',width:100,align:'center'},
			{field:'TUsedFlag',title:'使用标记',width:100,align:'center'},
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
		document.getElementById('TDFaultID').innerHTML="故障名称"
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
				text: '故障现象'
			},{
				id: '2',
				text: '故障原因'
			},{
				id: '3',
				text: '故障解决方法'
			}],
			onSelect: function() {GlobalObj.MapTypeID=jQuery("#MapType").combobox("getValue");
			if (GlobalObj.MapTypeID==1)
			{
				document.getElementById('TDFaultID').innerHTML="故障现象"
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
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
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
				document.getElementById('TDFaultID').innerHTML="故障原因"
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
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
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
				document.getElementById('TDFaultID').innerHTML="解决方法"
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
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
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
		document.getElementById('TDESourceID').innerHTML="来源名称"
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
				text: '设备分类'
			},{
				id: '2',
				text: '设备项'
			}],
			onSelect: function() {GlobalObj.ESourceTypeID=jQuery("#ESourceType").combobox("getValue");
			if (GlobalObj.ESourceTypeID==1)
			{
				document.getElementById('TDESourceID').innerHTML="设备分类"
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
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:90,align:'center'},
					{field:'TName',title:'描述',width:120,align:'center'}
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
		document.getElementById('TDESourceID').innerHTML="设备项"
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
					{field:'TRowID',title:'单位',width:60,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:90,align:'center'},
					{field:'TName',title:'描述',width:120,align:'center'}
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
				document.getElementById('TDFaultID').innerHTML="故障现象"
				}
			else if(GlobalObj.MapTypeID==2){
				document.getElementById('TDFaultID').innerHTML="故障原因"
				}
			else if(GlobalObj.MapTypeID==3){
				document.getElementById('TDFaultID').innerHTML="解决方法"
				}
			if(GlobalObj.ESourceTypeID==1){
				document.getElementById('TDESourceID').innerHTML="设备分类"
				}
			else if(GlobalObj.ESourceTypeID==2){
				document.getElementById('TDESourceID').innerHTML="设备项"
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
			document.getElementById('TDFaultID').innerHTML="故障名称"
			document.getElementById('TDESourceID').innerHTML="来源名称"
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
	val+="^"+(($("#UsedFlag").is(':checked')==true)?'Y':'N');       //使用标志
	
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
	if($("#RowID").val()!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if(GlobalObj.MapTypeID==""){$.messager.alert('提示','新增失败,主要类型不能为空！','warning');return;}
	if($("#FaultID").combogrid('getValue')==""){$.messager.alert('提示','新增失败,故障ID不能为空！','warning');return;}
	if(GlobalObj.ESourceTypeID==""){$.messager.alert('提示','新增失败,来源类型不能为空！','warning');return;}
	if($("#ESourceID").combogrid('getValue')==""){$.messager.alert('提示','新增失败,来源ID不能为空！','warning');return;}
	if(($("#ESourceType").combobox('getValue')==1)&(GlobalObj.ModelDR!="")){$.messager.alert('提示','新增失败,设备分类无机型！','warning');return;}
    $.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCFaultEquipMap',
			MethodName:'SaveData',
			Arg1:CombineData(),
			ArgCnt:1
			
		},		
		beforeSend:function(){$.messager.progress({text:'正在保存中'})		
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
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tdhceqmcfaultequipmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
}

function UpdateGridData()
{
	//messageShow("","","",CombineData())
	if($("#RowID").val()==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	if(GlobalObj.MapTypeID==""){$.messager.alert('提示','主要类型不能为空！','warning');return;}
	if($("#FaultID").combogrid('getValue')==""){$.messager.alert('提示','故障ID不能为空！','warning');return;}
	if(GlobalObj.ESourceTypeID==""){$.messager.alert('提示','来源类型不能为空！','warning');return;}
	if($("#ESourceID").combogrid('getValue')==""){$.messager.alert('提示','来源ID不能为空！','warning');return;}
	if((GlobalObj.ESourceTypeID==1)&(GlobalObj.ModelDR!="")){$.messager.alert('提示','设备分类无机型！','warning');return;}
	
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCFaultEquipMap',
			MethodName:'SaveData',
			Arg1:CombineData(),
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			if(data>0)
			{
				$.messager.show({title: '提示',msg: '更新成功'});
				$('#tdhceqmcfaultequipmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('更新失败！','错误代码:'+data, 'warning');
		}
	});
}

function DeleteGridData()
{
	if($("#RowID").val()==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	$.messager.confirm('确认', '您确定要删除所选的行吗？', function(b)
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
			beforeSend:function(){$.messager.progress({text:'正在删除中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data==0)
				{
					$.messager.show({title: '提示',msg: '删除成功'});
					$('#tdhceqmcfaultequipmap').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('删除失败！','错误代码:'+data, 'warning');
			}
		});
        }
	});
}