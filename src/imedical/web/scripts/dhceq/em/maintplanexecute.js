///动态获取datagrid列信息
var Columns=getCurColumnsInfo('EM.G.Maint.MaintEquipList','','','')
///动态生成datagrid调用查询
var queryParams={ClassName:"web.DHCEQ.EM.BUSMaintPlan",QueryName:"GetPlanExecuteList"}
var editIndex=undefined;		//modified by czf 2020-04-28

jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initUserInfo();
	initLookUp();
	initMessage();
	defindTitleStyle();
	initButton();
	jQuery("#BExecute").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BExecute").on("click", BExecute_Click);
	jQuery("#BFinish").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BFinish").on("click", BFinish_Click);
	initButtonWidth();
	fillData()
	setEnabled();
	//显示列表
	createMaintEquipList();
	$HUI.datagrid("#tDHCEQMaintEquipList",{
		onClickRow:function(rowIndex,rowData){
			SelectRowHandler(rowIndex,rowData);
		}
	});
}
function fillData()
{
	var RowID=getElementValue("RowID")
	if(RowID=="") return;
	var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetPlanExecuteByID",RowID)
	var list=Result.split("^");
	setElement("PEPlanExecuteNo",list[0]);
	setElement("MPName",list[15]);
	setElement("PEExecuteLocDR_LocDesc",list[16]);
	setElement("PEExecuteLocDR",list[2]);
	setElement("PETotalNum",list[3]);
	setElement("PEExecuteUserDR_UserName",list[19]);
	setElement("PEExecuteUserDR",list[8]);
	setElement("PEExecuteDate",list[17]);
	setElement("PERemark",list[9]);
	setElement("PEDisExecuteNum",list[3]-list[4]);
	setElement("Status",list[5]);
	setElement("BussType",list[20])
	setEnabled();
}
function setEnabled()
{
	var Status=$("#Status").val()
	if (Status==1)
	{
		$("#BExecute").linkbutton("disable")
		$("#BFinish").linkbutton("disable")
		$("#BDelete").linkbutton("disable")		//add by czf 20190313
		jQuery("#BExecute").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BFinish").unbind();
	}
	else if((Status=="")||(Status==0))
	{
		$("#BExecute").linkbutton("enable")
		$("#BFinish").linkbutton("enable")
		$("#BDelete").linkbutton("enable")
	}
}
function createMaintEquipList()
{
	queryParams.MPID=getElementValue("MPRowID")
	queryParams.PEID=getElementValue("RowID")
	//动态生成datagrid窗口显示数据
	createdatagrid("tDHCEQMaintEquipList",queryParams,Columns)
}
function BExecute_Click()
{
	var MPRowID=getElementValue("MPRowID")
	var BussType=getElementValue("BussType")
	var Remark=getElementValue("PERemark")  //add by lmm 2019-05-16 896639
	var RowID=getElementValue("RowID")
	var selectrow = $("#tDHCEQMaintEquipList").datagrid("getChecked");
	if (selectrow.length==0)
	{
		alertShow("请选择要执行计划的设备")
		return
	}
	endEditing(); 		//modified by czf 1283059
	var PlanRowIDs = [];
	for(var i=0;i<selectrow.length;i++)
	{
		if (selectrow[i].TExecuteFlag=="已执行") 
		{
			alertShow(selectrow[i].TName+"已执行")
			return
		}
		else
		{
			var PlanEquip=MPRowID+"^"+selectrow[i].TEquipID+"^"+selectrow[i].TRowID+"^"+selectrow[i].TResult+"^"+selectrow[i].THold1; //modified by czf 1283059
			PlanRowIDs.push(PlanEquip);
		}
	}
	var val=""
	for(var j=0;j<PlanRowIDs.length;j++){
		if (j==0)  
		{	val=PlanRowIDs[j]	}
		else
		{	val=val+","+PlanRowIDs[j]	}
	}
	var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","ExecutePlan",RowID,val,BussType,Remark)  //add by lmm 2019-05-16 896639
	if (Result>0)
	{
		alertShow(t[0]);
		window.location.reload();
	}
	else
	{
		alertShow(t[Result])
	}
}
//modify by lmm 2020-04-03
function BFinish_Click()
{
	messageShow("confirm","","","确认完成该计划单？","",FinishMaint,"");
}
function FinishMaint()
{
	var RowID=getElementValue("RowID")
	var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","PlanExeFinish",RowID)
	if (Result>0)
	{
		alertShow(t[0]);
		window.location.reload();
	}
	else
	{
		alertShow(t[Result])
	}
}
//modify by lmm 2020-04-03
function BDelete_Clicked()
{
	messageShow("confirm","","","是否取消执行？","",DeleteData,"");
}

function DeleteData()
{
	var MPRowID=getElementValue("MPRowID")
	var BussType=getElementValue("BussType")
	var RowID=getElementValue("RowID")
	var selectrow = $("#tDHCEQMaintEquipList").datagrid("getChecked");
	if (selectrow.length==0)
	{
		alertShow("请选择要撤销执行的设备")
		return
	}
	var PlanRowIDs = [];
	for(var i=0;i<selectrow.length;i++)
	{
		if (selectrow[i].TExecuteFlag=="未执行") 
		{
			alertShow(selectrow[i].TEquipNo+"未执行")
			return
		}
		else
		{
			var PlanEquip=selectrow[i].TRowID
			PlanRowIDs.push(PlanEquip);
		}
	}
	var val=""
	for(var j=0;j<PlanRowIDs.length;j++){
		if (j==0)  
		{	val=PlanRowIDs[j]	}
		else
		{	val=val+","+PlanRowIDs[j]	}
	}
	var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","DeletePlanExecute",RowID,val)
	if (Result>0)
	{
		alertShow(t[Result])
	}
	else
	{
		alertShow(t[0]);
		window.location.reload();
		//window.location.href='dhceq.em.maintplanexecute.csp?&RowID=&MPRowID=&BussType=&ReadOnly=&Status=0';    //add by lmm 2019-03-12  840335	
	}
}
///描述：列表成功加载时调用，不写方法影响列表分页栏及列表数据显示
///add by lmm 2019-05-30 914535
function LoadSuccess()
{
}

//add by czf 2020-04-28
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#tDHCEQMaintEquipList').datagrid('validateRow', editIndex)){
		$('#tDHCEQMaintEquipList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//add by czf 2020-04-28
function SelectRowHandler(index,rowData)
{
	var Status=getElementValue("Status");
	if (Status>0) return
	if(rowData.TExecuteFlag=="已执行") return;
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#tDHCEQMaintEquipList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQMaintEquipList').datagrid('getRows')[editIndex]);
		} else {
			$('#tDHCEQMaintEquipList').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

///add by czf 1283063
///增加历史维护记录
function maintHistoryList(index)
{
	var curRowObj=$('#tDHCEQMaintEquipList').datagrid('getRows')[index];
	var MPType=curRowObj.TMPType;
	var MaintType=curRowObj.TMaintTypeDR;
	var EquipDR=curRowObj.TEquipID;
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSMaint",
		QueryName:"GetMaint",
		BussType:MPType,
		EquipDR:EquipDR,
		MaintTypeDR:MaintType
	},function(jsonData){
		if(jsonData.rows.length<1)
		{
			alertShow("没有历史维护记录");
			return;
		}
		else
		{
			var url="dhceq.em.mainthistorylist.csp?&MPType="+MPType+"&MaintType="+MaintType+"&EquipDR="+EquipDR;
			showWindow(url,"历史维护记录","","","icon-w-paper","modal","","","small");   //modify by lmm 2020-06-05 UI 
		}
	});
}


