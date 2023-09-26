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
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'��������',
				handler:function(){ImportData();}
			},
			{
				iconCls:'icon-save',
				text:'���ɵ���',
				handler:function(){SaveDisuseRequest();}
			}
		],
		columns:[[
			{field:'Job',title:'Job',width:0,align:'center',hidden:true,formatter:GetJobValue},
			{field:'TNo',title:'�ʲ�����',width:120,align:'left'},
			{field:'TFileNo',title:'������',width:80,align:'left'},
			{field:'TEquipName',title:'����',width:150,align:'left'},
			{field:'TModel',title:'�ͺ�',width:180,align:'left'},
			{field:'TStoreLoc',title:'����',width:150,align:'center'},
			{field:'TStatus',title:'״̬',width:80,align:'center'},
			{field:'TEquipType',title:'����',width:80,align:'center'},
			{field:'TTransAssetDate',title:'�������',width:80,align:'center'},
			{field:'TOriginalFee',title:'ԭֵ',width:100,align:'right'},
			{field:'TNetFee',title:'��ֵ',width:100,align:'right'},
			{field:'TDepreTotalFee',title:'�ۻ��۾�',width:100,align:'right'}
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
				text: 'δ����'
			},{
				id: '1',
				text: '���ɱ��ϵ�'
			},{
				id: '2',
				text: '�����ύ���ϵ�'
			},{
				id: '3',
				text: '����Ԥ���ϵ�'
			},{
				id: '4',
				text: '���������ϱ��ϵ�'
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
		$.messager.alert('��ʾ','JobΪ��!', 'warning'); return;
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
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			if(data!=0)
			{$.messager.alert('����ʧ�ܣ�','��ʼ��ʧ��!', 'warning');
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
		    alertShow("��"+Row+"��"+"�豸���Ϊ��!");
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
				data=data.replace(/\ +/g,"")	//ȥ���ո�
				data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
				if(data!=0)
				{
					var MegDesc='�������:'+No
					if (data=="-1012") MegDesc='�豸:'+No+'�Ѿ����ڱ��ϵ���!'
					$.messager.alert('����ʧ�ܣ�',MegDesc, 'warning');
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
	alertShow("�������!");
}
function SaveDisuseRequest()
{
	if (GlobalObj.OperationTypeID=="")
	{
		$.messager.alert('��ʾ','��������û��ѡ��!', 'warning'); return;
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
				data=data.replace(/\ +/g,"")	//ȥ���ո�
				data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
				if(data!=0)
				{
					$.messager.alert('����ʧ�ܣ�','�������:', 'warning');
				}
				else
				{
					$.messager.alert('���ɳɹ�!','���ɳɹ�!', 'warning');
				}
			}
		});
	}
}