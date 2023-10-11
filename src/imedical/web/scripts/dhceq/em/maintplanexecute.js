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
	// MZY0091	2083796		2021-08-26	修正图标
	jQuery("#BExecute").linkbutton({iconCls: 'icon-w-run'});
	jQuery("#BExecute").on("click", BExecute_Click);
	jQuery("#BFinish").linkbutton({iconCls: 'icon-w-ok'});
	jQuery("#BFinish").on("click", BFinish_Click);
	//initButtonWidth();
	fillData()
	setEnabled();
	//显示列表
	createMaintEquipList();
	$HUI.datagrid("#tDHCEQMaintEquipList",{
		onClickRow:function(rowIndex,rowData){
			SelectRowHandler(rowIndex,rowData);
		},
		//add by lmm 2020-11-18
		onUncheck:function(rowIndex,rowData){
			UnSelectRowHandler(rowIndex,rowData);
		},
		onCheckAll: function (rows) { onCheckAll(rows); },
		onUncheckAll: function (rows) { onUncheckAll(rows); },
		//add by lmm 2020-11-18
	});
	// add by hyy 按钮样式 2023-03-07
	if (jQuery("#BFinish").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// 极简版
			if (($("#BFinish").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BFinish").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BFinish").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
	if (jQuery("#BExecute").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// 极简版
			if (($("#BExecute").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BExecute").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BExecute").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
	// add by sjh SJH0037 2020-10-16 start 增加MaintTypeDR控制，巡检保养不显示计量证号和日期
	if(getElementValue("MaintTypeDR")!=5)
	{
		$('#tDHCEQMaintEquipList').datagrid('hideColumn','TCertificateNo')
		$('#tDHCEQMaintEquipList').datagrid('hideColumn','TMaintDate')
	}
	if (getElementValue("BussType")!="1") $('#tDHCEQMaintEquipList').datagrid('hideColumn','TExecute');	// MZY0093	2021-09-08
	changeColumnOption() //add by lmm 2020-11-18 	
	// MZY0076	2021-05-25	注释相关列
	$('#tDHCEQMaintEquipList').datagrid('hideColumn','TMaintPic');
	$('#tDHCEQMaintEquipList').datagrid('hideColumn','TMaintFile');
	$('#tDHCEQMaintEquipList').datagrid('hideColumn','TPMReport');
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
			var PlanEquip=MPRowID+"^"+selectrow[i].TEquipID+"^"+selectrow[i].TRowID+"^"+selectrow[i].TResult+"^"+selectrow[i].THold1+"^"+selectrow[i].TCertificateNo+"^"+selectrow[i].TMaintDate+"^"+selectrow[i].TExecuteDate+"^"+selectrow[i].TAffixDR; //modified by czf 1283059
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
	// MZY0109	2385363		2021-12-30
	if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo",501002)==0)
	{
		 if (PlanRowIDs.length>1)
		 {
			 alertShow("不能批量执行,请逐条记录选中后执行.");
			 return;
		 }
	}
   	messageShow("confirm","info","提示","所选中设备按计划执行并生成PM报告,是否执行?","",function(){
    	var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","ExecutePlan",RowID,val,BussType,Remark);
		if (Result>0)
		{
			alertShow(t[0]);
			window.location.reload();
		}
		else
		{
			alertShow(Result);
		}
	},function(){
		return;
	},"执行","取消");
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
			// MZY0079	1883089,1883162		2021-06-02
			rowData.TExecuteDate=getElementValue("EExecuteDate");
			$('#tDHCEQMaintEquipList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQMaintEquipList').datagrid('getRows')[editIndex]);
			var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TResult'});
			jQuery(ed.target).val("完好");  //设置ID
			var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TResult'});
			jQuery(ed.target).combobox('setValue', "完好");
			// MZY0079	1883089,1883162		2021-06-02	注释
			/*var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TExecuteDate'});
			jQuery(ed.target).val(ExecuteDate);  //设置ID
			var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TExecuteDate'});
			jQuery(ed.target).datebox('setValue', ExecuteDate);
			*/
			setElement("ListEquipID",rowData.TEquipID)
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
//add by lmm 2020-11-18 
//执行结果改用下拉菜单
function changeColumnOption()
{
	var TResult=$("#tDHCEQMaintEquipList").datagrid('getColumnOption','TResult');	
	TResult.editor={type: 'combobox',options:{
					data: [{"value":"完好","text":"完好"},{"value":"有缺陷","text":"有缺陷"},{"value":"故障","text":"故障"}],
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TResult'});
						jQuery(ed.target).val(option.value);  //设置ID
						var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TResult'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//列增加编辑器
	TResult.formatter=	function(value,row){
		return row.TResult;
	}		
}
///add by lmm 2020-11-18
/**全选的处理*/
function onCheckAll(rows){
    $.each(rows, function(index, item){
        var rowData= rows[index];//获取到行内容
        SelectRowHandler(index,rowData)
    });
}
///add by lmm 2020-11-18
/**全不选的处理*/
function onUncheckAll(rows){
	var Status=getElementValue("Status");
	if (Status>0) return
    $.each(rows, function(index, item){
        var rowData= rows[index];//获取到行内容
        UnSelectRowHandler(index,rowData)
    });
}
//add by lmm 2020-11-18
//取消勾选行触发事件
function UnSelectRowHandler(index,rowData)
{
	var Status=getElementValue("Status");
	if (Status>0) return
	if(rowData.TExecuteFlag=="已执行") return;

	rowData.TExecuteDate="";	// MZY0079	1883089,1883162		2021-06-02
	$('#tDHCEQMaintEquipList').datagrid('beginEdit', index);
	var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:index,field:'TResult'});
	jQuery(ed.target).val("");  //设置ID
	var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:index,field:'TResult'});
	jQuery(ed.target).combobox('setValue', "");
	// MZY0079	1883089,1883162		2021-06-02	注释
	/*var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:index,field:'TExecuteDate'});
	jQuery(ed.target).val("");  //设置ID
	var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:index,field:'TExecuteDate'});
	jQuery(ed.target).datebox('setValue', "");*/
	$('#tDHCEQMaintEquipList').datagrid('endEdit', index);
}

///记录执行操作	 MZY0076	2021-05-25
//Modify by zx 2021-05-29 调整执行按钮链接
function executeList(index)
{
	var BussType=getElementValue("BussType")
	if(BussType!="1")
	{
		var curRowObj=$('#tDHCEQMaintEquipList').datagrid('getRows')[index];
		var params="ReadOnly=&QXType=&BussType="+BussType+"&EquipDR="+curRowObj.TEquipID+"&RowID="+curRowObj.TMaintID+"&CollectFlag=";
		if((getElementValue("MaintTypeDR")==5))
		{
			var url="dhceq.em.meterage.csp?";
			var title="计量记录"
		}
		else
		{
			var url="dhceq.em.inspect.csp?";
			var title="巡检记录"
		}
		showWindow(url+params,title,"","11row","icon-w-paper","modal","","","lar")
	}
	else
	{
		var curRowObj=$('#tDHCEQMaintEquipList').datagrid('getRows')[index];
		url="dhceq.em.preventivemaint.csp?&ReadOnly=&QXType=&BussType="+BussType+"&EquipDR="+curRowObj.TEquipID+"&MaintLocDR="+curRowObj.TMaintLocDR+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&RowID="+curRowObj.TMaintID+"&PlanExecuteID="+curRowObj.TPlanExecuteID+"&PlanExecuteListID="+curRowObj.TRowID;
		showWindow(url,"预防性维护记录","","","icon-w-paper","","","","large");
	}
}

function GetAffixID(index,data)
{
	var rowData = $('#tDHCEQMaintEquipList').datagrid('getSelected');
	rowData.TAffixDR=data.TRowID
	// MZY0096	2144129		2021-09-16
	var ed=jQuery("#tDHCEQMaintEquipList").datagrid('getEditor',{index:editIndex,field:'TAffix'});
	jQuery(ed.target).combogrid('setValue', data.TDesc);
	$('#tDHCEQMaintEquipList').datagrid('endEdit',editIndex);
}
