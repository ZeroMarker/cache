//�������
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	defindTitleStyle();
	initTopPanel();
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	
	//modify by lmm 2020-06-05 UI
	var MPRowID=jQuery("#MPRowID").val();
	FillData(MPRowID);
	$HUI.datagrid("#tDHCEQHistoryExeList",{   
	   	url:$URL, 
		idField:'TRowID', //����   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
		fitColumns:true,   //add by lmm 2020-06-05 UI
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCEQPlanExecute",
	        QueryName:"GetExecutePlan",
	        MaintPlanDR:getElementValue("MPRowID"),
	        Status:'',
	        ExeLocDR:'',
	        ExecuteNo:'',

		},
		//fitColumns:true,
		pagination:true,
    	columns:[[
    	    {field:'TRow',title:'���',align:'center'},
    		{field:'TRowID',title:'RowID',hidden:true},
        	{field:'TExeNo',title:'ִ�е���',width:150,align:'center'},
        	{field:'TExeLoc',title:'ִ�п���',width:150,align:'center'},
        	{field:'TExeDate',title:'ִ�п�ʼ����',width:150,align:'center'},
        	{field:'TExecutor',title:'ִ����',width:150,align:'center'},
        	{field:'TFinishDate',title:'�������',width:150,align:'center'},
        	{field:'TRemark',title:'��ע',width:150,align:'center'},
        	{field:'TExeSchedule',title:'ִ�н���',width:150,align:'center',formatter:ExeDetail}
    	]], 
	});	
	
}
		
	
function ExeDetail(rowIndex, rowData)
{
	var PERowID=rowData.TRowID;
	if(PERowID!="")
	{
		var url="dhceq.em.maintplanexecute.csp?MPRowID="+$("#MPRowID").val()+"&BussType="+$('#BussType').val()+"&RowID="+PERowID;
		var btn='<A class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-add\'" onclick="showWindow(&quot;'+url+'&quot;,&quot;�ƻ�ִ��&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#">'+rowData.TExeSchedule+'</A>';
		return btn;
	}
}

function FillData(MPRowID)
{
	if(MPRowID=="") return;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQMaintPlanNew',
			MethodName:'GetOneMaintPlan',
			Arg1:MPRowID,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			var sort=44;
			setElement("MaintPlanName",list[0])
			setElement("MaintPlanNo",list[49])
			setElement("CycleNum",list[6]+list[sort+9])
			setElement("MaintLoc",list[sort+11])
			
		}
	});
}