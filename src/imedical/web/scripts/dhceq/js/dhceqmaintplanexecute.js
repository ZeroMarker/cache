//�������
var editFlag="undefined";
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initTopPanel();
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	//initComboGridPanel();
	initCombogrid();
	var MPRowID=$("#MPRowID").val();
	var RowID=$("#RowID").val();
	var BussType=$("#BussType").val();
	jQuery("#BExecute").click(function(){BExecute_Click(RowID,MPRowID,BussType)});
	jQuery("#BFinish").click(function(){BFinish_Click(RowID)});
	jQuery("#BDelete").click(function(){BDelete_Click(RowID)});
	FillData(RowID);
	SetEnabled();
}
function initComboGridPanel()
{
	jQuery("input[name='combogrid']").each(function() {
		var options=eval('(' + jQuery(this).attr("data-options") + ')');
		jQuery(this).initComboGrid(options);
	});
}
$('#ExecuteUser').combogrid({
	url:'dhceq.jquery.csp', 
	panelWidth:320,
	delay:800,
	idField:'TRowID',
	textField:'TName',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName: 'web.DHCEQ.Process.DHCEQFind',
		QueryName: 'User',
		Arg1: '',
		ArgCnt: 1
	},
	columns:[[    
        {field:'TRowID',title:'rowid',hidden:true},    
        {field:'TName',title:'ִ����'}
        ]],
	keyHandler: { 
		query: function(q) {
			ReloadGrid("MaintUser",q,q);}
		},
	pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75,90,105]
 });
 
jQuery('#tDHCEQMaintEquipList').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQMaintPlanNew",
			QueryName:"GetPlanExecuteList",
	        Arg1:$("#MPRowID").val(),
	        Arg2:$("#RowID").val(),
	        Arg3:'',
	        Arg4:'',
			ArgCnt:4
			},
		fit:true,
		rownumbers: false,  //���Ϊtrue������ʾһ���к��С�
        //checkOnSelect: true,
     	selectOnCheck: true,
    	columns:[[
    		{field:'TRow',title:'���',align:'center',width:'5%'},
    		{field:'Chk',title:'���',align:'center',width:'5%',checkbox:true},
    		{field:'TRowID',title:'RowID',width:'3%',hidden:true},
        	{field:'TName',title:'�豸����',align:'center',width:'15%'},
        	{field:'TEquipNo',title:'�豸���',align:'center',width:'12%'},
        	{field:'TStockLoc',title:'ʹ�ÿ���',align:'center',width:'12%'},
        	{field:'TModel',title:'����ͺ�',align:'center',width:'12%'},
        	{field:'TExecuteFlag',title:'ִ��״̬',align:'center',width:'6%'},
        	{field:'TExeUser',title:'ִ����',align:'center',width:'6%'},
        	{field:'TExecuteDate',title:'ִ������',align:'center',width:'10%'},
        	{field:'TEquipID',title:'�豸ID',width:'3%',hidden:true},
        	{field:'TResult',title:'ִ�н��',align:'center',width:'8%',editor:texteditor}
    	]],
		onLoadSuccess:function(data){},
		onClickRow:function(rowIndex,rowData){},onSelect: function (rowIndex, rowData) {//������ȡ���༭
			if (rowData.TExecuteFlag=="��ִ��")
			{
				alertShow("���豸��ִ��")
				$(this).datagrid('unselectRow', rowIndex);
				//jQuery("#computerflag").attr("checked",false)
				return
			}
			if (editFlag!="undefined") 
			{
	        	jQuery("#tDHCEQMaintEquipList").datagrid('endEdit', editFlag);
	        	editFlag="undefined";
	        }
    	},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	if (rowData.TExecuteFlag=="��ִ��")
			{
				alertShow("���豸��ִ��")
				return	
			}
			if (editFlag!="undefined")
			{
	        	jQuery("#tDHCEQMaintEquipList").datagrid('endEdit', editFlag);
	        	editFlag="undefined"
	    	}
	     	jQuery("#tDHCEQMaintEquipList").datagrid('beginEdit', rowIndex);
	     	editFlag =rowIndex;
	    },
		onLoadError: function(resullt) { alertShow(JSON.stringify(resullt)) },//jQuery.messager.alert("����", "�����б����.");},
		rowStyler:function(index,row){},
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
	
function BExecute_Click(RowID,MPRowID,BussType)
{
	var selectrow = $("#tDHCEQMaintEquipList").datagrid("getChecked");
	if (selectrow.length==0)
	{
		alertShow("��ѡ��Ҫִ�мƻ����豸")
		return
	}
	var PlanRowIDs = [];
	var message=""
	for(var i=0;i<selectrow.length;i++){
		if (selectrow[i].TExecuteFlag=="��ִ��") 
		{
			message=selectrow[i].TName
			break;
		}
		var PlanEquip=MPRowID+"^"+selectrow[i].TEquipID+"^"+selectrow[i].TRowID+"^"+selectrow[i].TResult
		PlanRowIDs.push(PlanEquip);
	}
	if (message)
	{
		alertShow(message+"��ִ��")
		return
	}
	var val=""
	for(var j=0;j<PlanRowIDs.length;j++){
		if (j==0)  
		{	val=PlanRowIDs[j]	}
		else
		{	val=val+","+PlanRowIDs[j]	}
	}
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQPlanExecute',
			MethodName:'ExecutePlan',
			Arg1:RowID,
			Arg2:val,
			Arg3:BussType,
			ArgCnt:3
		},
		success:function(data,response,status)
		{
			if (data>0) {
	    		//$('#tDHCEQMaintEquipList').datagrid('reload'); 
	    		$.messager.show({
	        	title: '��ʾ',
	        	msg: 'ִ�гɹ�'
	        	}); 
	        	window.location.reload();
	        }   
	        else {
	           $.messager.alert('ִ��ʧ�ܣ�',data, 'warning')
	           return;
	        }
		}
	});	
}

function BFinish_Click(RowID)
{
	var truthBeTold = window.confirm("ȷ����ɸüƻ�����");
	if (!truthBeTold) return;
	jQuery.ajax({
	    async:false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQPlanExecute',
			MethodName:'PlanExeFinish',
			Arg1:RowID,
			ArgCnt:1
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			if(data>0)
			{
				$.messager.alert('ִ�гɹ���',data, 'warning')
			 	window.location.reload();
			}
			else
			{
				jQuery.messager.alert("��ʾ", "�ƻ����ʧ��!");
			}
		}
	});
}

function BDelete_Click(RowID)
{
	var truthBeTold = window.confirm("�Ƿ�ȷ��ɾ����");
	if (!truthBeTold) return;
	jQuery.ajax({
	    async:false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQPlanExecute',
			MethodName:'DeleteData',
			Arg1:RowID,
			ArgCnt:1
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			if(data<0)
			{
				jQuery.messager.alert("��ʾ", "ɾ��ʧ��!");
			}
			else
			{
				jQuery.messager.alert("��ʾ", "ɾ���ɹ�!");
			 	var lnk="dhceqmaintplanexecute.csp?MPRowID="+MPRowID+"&BussType="+BussType+"&RowID=";
				location.href=lnk;
			}
		}
	});
}

function FillData(RowID)
{
	if(RowID=="") return;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQPlanExecute',
			MethodName:'GetPlanExecuteByID',
			Arg1:RowID,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			$("#ExecuteNo").textbox('setText',list[0]);
			$("#ExecuteLocDR").val(list[2]);
			$("#TotalNum").val(list[3]);
			$("#DisExecuteNum").val(list[3]-list[4]);
			$("#Status").val(list[5]);
			$("#ExecuteDate").datebox('setValue',list[17]);
			$("#ExecuteDate").datebox('setText',list[17]);
			$("#ExecuteUserDR").val(list[8]);
			$("#Remark").val(list[9]);
			$("#MaintPlanName").textbox('setText',list[15]);
			$("#ExecuteLoc").combogrid('setText',list[16]);
			$("#ExecuteUser").combogrid('setText',list[19]);
			SetEnabled();
		}
	});
}

function SetEnabled()
{
	var Status=$("#Status").val()
	if (Status==1)
	{
		$("#BExecute").linkbutton("disable")
		$("#BFinish").linkbutton("disable")
		//$("#BDelete").linkbutton("disable")
		jQuery("#BExecute").unbind();
		jQuery("#BFinish").unbind();
		//jQuery("#BDelete").unbind();
	}
	else if((Status=="")||(Status==0))
	{
		$("#BExecute").linkbutton("enable")
		$("#BFinish").linkbutton("enable")
		$("#BDelete").linkbutton("enable")
	}
}