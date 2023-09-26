var preRowID=0
var GlobalObj = {
	Job : "",
	OperationTypeID  :"" ,
	GetData :  function()
	{
		this.Job = $("#Job").val();
	}
}
jQuery(document).ready(function()
{
	initDocument();
	$('#tDHCEQDisuse').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQBatchDisuseRequest",
			QueryName:"GetImportDisuseEquipList",
			Arg1:GlobalObj.Job,
			ArgCnt:1},
    	border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'加载数据',
				handler:function(){ImportData();}
			},
			{
				iconCls:'icon-save',
				text:'生成单据',
				handler:function(){SaveDisuseRequest();}
			}
		],
		columns:[[
			{field:'Job',title:'Job',width:0,align:'center',hidden:true,formatter:GetJobValue},
			{field:'TNo',title:'资产编码',width:120,align:'left'},
			{field:'TFileNo',title:'档案号',width:80,align:'left'},
			{field:'TEquipName',title:'名称',width:150,align:'left'},
			{field:'TModel',title:'型号',width:180,align:'left'},
			{field:'TStoreLoc',title:'科室',width:150,align:'center'},
			{field:'TStatus',title:'状态',width:80,align:'center'},
			{field:'TEquipType',title:'类组',width:80,align:'center'},
			{field:'TTransAssetDate',title:'入库日期',width:80,align:'center'},
			{field:'TOriginalFee',title:'原值',width:100,align:'right'},
			{field:'TNetFee',title:'净值',width:100,align:'right'},
			{field:'TDepreTotalFee',title:'累积折旧',width:100,align:'right'}
		]],
		onClickRow:function(rowIndex,rowData){//OnclickRow();
		},
		pagination:true,
		pageSize:25,
		pageNumber:25,
		pageList:[25,50,75,100]
	});
	
	$(window).unload(function () 
	{
		InitDHCEQTemp()
	})
	}
)

function initDocument()
{
	if (jQuery("#OperationType").prop("type")!="hidden")
	{
		jQuery("#OperationType").combobox({
			height: 24,
			width: 160,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: '未定义'
			},{
				id: '1',
				text: '生成报废单'
			},{
				id: '2',
				text: '生成提交报废单'
			},{
				id: '3',
				text: '生成预报废单'
			},{
				id: '4',
				text: '生成审核完毕报废单'
			}],
			onSelect: function() {GlobalObj.OperationTypeID=jQuery("#OperationType").combobox("getValue");}
		});
	}
}

function GetJobValue(rowIndex, rowData)
{
	if(rowData.Job!="")
	{
		GlobalObj.Job=rowData.Job
	}
}
function InitDHCEQTemp()
{
	if (GlobalObj.Job==""){
		$.messager.alert('提示','Job为空!', 'warning'); return;
	}
	$.ajax({
		async: false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQBatchDisuseRequest',
			MethodName:'InitDisuseEquip',
			Arg1:GlobalObj.Job,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			if(data!=0)
			{$.messager.alert('保存失败！','初始化失败!', 'warning');
			}
		}
	});
}
function ImportData()
{
	InitDHCEQTemp()
    var xlApp = new ActiveXObject("Excel.Application");
	var FileName=document.all.FileName.value;
    var xlBook = xlApp.Workbooks.Add(FileName);
    var xlsheet =xlBook.Worksheets(1);
    var MaxRow=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=MaxRow;Row++)
	{
	    var Col=1;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No=""
	    if (No=="")
	    {
		    alertShow("第"+Row+"行"+"设备编号为空!");
		    return 1;
	    }
		$.ajax({
    		async: false,
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQBatchDisuseRequest',
				MethodName:'ImportDisuseEquip',
				Arg1:GlobalObj.Job,
				Arg2:No,
				ArgCnt:2
			},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				data=data.replace(/\ +/g,"")	//去掉空格
				data=data.replace(/[\r\n]/g,"")	//去掉回车换行
				if(data!=0)
				{
					var MegDesc='错误代码:'+No
					if (data=="-1012") MegDesc='设备:'+No+'已经存在报废单中!'
					$.messager.alert('保存失败！',MegDesc, 'warning');
				}
			}
		});
	}
	
	jQuery('#tDHCEQDisuse').datagrid('load',{
		ClassName:"web.DHCEQBatchDisuseRequest",
		QueryName:"GetImportDisuseEquipList",
		Arg1:GlobalObj.Job,
		ArgCnt:1
	}); 
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
	alertShow("导入完毕!");
}
function SaveDisuseRequest()
{
	if (GlobalObj.OperationTypeID=="")
	{
		$.messager.alert('提示','操作类型没有选择!', 'warning'); return;
	}
	else
	{
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQBatchDisuseRequest',
				MethodName:'BuildDisuseRequest',
				Arg1:GlobalObj.Job,
				Arg2:GlobalObj.OperationTypeID,
				ArgCnt:2
			},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				data=data.replace(/\ +/g,"")	//去掉空格
				data=data.replace(/[\r\n]/g,"")	//去掉回车换行
				if(data!=0)
				{
					$.messager.alert('保存失败！','错误代码:', 'warning');
				}
				else
				{
					$.messager.alert('生成成功!','生成成功!', 'warning');
				}
			}
		});
	}
}