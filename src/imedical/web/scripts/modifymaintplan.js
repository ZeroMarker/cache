///动态获取datagrid列信息
var Columns=getCurColumnsInfo('EM.G.Maint.PlanEquipList','','','')
///动态生成datagrid调用查询
var queryParams={ClassName:"web.DHCEQ.EM.BUSMaintPlan",QueryName:"PlanEquipList"}
var editIndex=undefined;
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
	InitEvent();
	initButton();
	initButtonWidth();
	FillData();
	setEnabled();
	
	//显示列表
	$HUI.datagrid("#DHCEQEquipList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSMaintPlan",
	        	QueryName:"PlanEquipList",
				MPID:getElementValue("MPRowID"),
		},
		toolbar:[{			//MZY0092	2021-08-27
    			iconCls: 'icon-add',
                text:'追加设备',  		// MZY0120	2022-04-13
				id:'add',        
                handler: function(){
                     addEquip();
                }},'----------',
                {
                iconCls: 'icon-cancel',
                text:'删除设备',
				id:'del',
                handler: function(){
                     delEquip();
                }}
        ],
		rownumbers: true,  //如果为true则显示一个行号列
		singleSelect:false,	// MZY0093	2021-09-08
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
		//fitColumns:true,
		columns:Columns,
		//onClickRow:function(rowIndex,rowData){onClickRow();},
		pagination:true,
		pageSize:100,
		pageNumber:1,
		pageList:[100,200,300,400],
		onLoadSuccess:function(){}
	});
	var TDeleteList=$("#DHCEQEquipList").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=function(value,row,index){
		return '<a href="#"  onclick="deleterow(&quot;'+row.TRowID+'&quot;)"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	}
	//$('#DHCEQEquipList').datagrid('hideColumn','Opt');	 MZY0093	2021-09-08
	// MZY0111	2411239		2022-01-14
	if (getElementValue("CancelFlag")=="Y")
	{
		disableElement("add",true);
		disableElement("del",true);
	}
	//Modefied by zc0121  2022-9-13  新增状态不可编辑
	if (getElementValue("Status")=="0")
	{
		disableElement("add",true);
		disableElement("del",true);
	}
}
function InitEvent() //初始化事件
{
	if (jQuery("#BCancelSubmit").length>0)
	{
		jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-submit'});	// MZY0093	2021-09-08
		jQuery("#BCancelSubmit").on("click", BCancelSubmit_Click);
	}
	if (jQuery("#BUpdateExecute").length>0)
	{
		jQuery("#BUpdateExecute").linkbutton({iconCls: 'icon-w-import'});
		jQuery("#BUpdateExecute").on("click", BUpdateExecute_Click);
	}
	if (jQuery("#BAssign").length>0)
	{
		jQuery("#BAssign").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery('#BAssign').on("click", BAssign_Clicked);
	}
	$("#MonthStr").datebox({
		onChange: function(newVal,oldValue){
			//alertShow(newVal+":"+oldValue)
			var list = tkMakeServerCall("web.DHCEQReport", "GetReportDate",newVal,"",3);
			list=list.split("^");
			setElement("SDate", list[0]);
			setElement("EDate", list[1]);
		}
	});
}
function setEnabled()
{
	var Status=$("#Status").val();
	if (Status==3)
	{
		$("#BSave").linkbutton("disable")
		$("#BCancelSubmit").linkbutton("disable")
		$("#BAssign").linkbutton("disable")
		$("#BUpdateExecute").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BCancelSubmit").unbind();
		jQuery("#BAssign").unbind();
		jQuery("#BUpdateExecute").unbind();
	}
	//Modefied by zc0121  2022-9-13  新增状态不可编辑 begin
	if (Status==0)
	{
		disableElement("BSave",true)
		disableElement("BCancelSubmit",true)
		disableElement("BAssign",true)
		disableElement("BUpdateExecute",true)
	}
	//Modefied by zc0121  2022-9-13  新增状态不可编辑 end
}
function FillData()
{
	var MPRowID=getElementValue("MPRowID");
  	if ((MPRowID=="")||(MPRowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetOneMaintPlan", MPRowID);
	//alert(list)
	//list=list.replace(/\ +/g,"")
	list=list.replace(/[\r\n]/g,"")
	list=list.split("^");
	
	var sort=50;
	setElement("Name",list[0]);
	setElement("MaintLocDR",list[13]);
	setElement("MaintUserDR",list[14]);
	setElement("Status",list[25]);
	setElement("SDate",list[47]);
	setElement("EDate",list[48]);
	setElement("PlanNo",list[49]);
	setElement("MaintLocDR_Loc",list[sort+5]);
	setElement("MaintUserDR_Name",list[sort+6]);
	setElement("Stage",list[sort+17]);
	//alert(list[45])
	switch (list[45]) {
	    case "1" :
	        setElement("CycleType","固定周期");
	        break;
	    case "2" :
	        setElement("CycleType","固定时间(周期)");
	        break;
	    case "3" :
	        setElement("CycleType","固定时间(一次)");
	        break;
	    case "4" :
	        setElement("CycleType","根据风险等级");
	        break;
	    case "5" :
	        setElement("CycleType","固定月份(周期)");
	        break;
	    case "6" :
	        setElement("CycleType","固定月份(一次)");
	        break;
	    default : 
	        //setElement("CycleType","");
	        break;
	}

	/*setElement("Type",list[1]);
	setElement("Content",list[5]);
	setElement("CycleNum",list[6]);
	setElement("CycleUnitDR",list[7]);
	setElement("MaintTypeDR",list[8]);
	setElement("FromDate",list[9]);
	//setElement("EndDate",list[10]);
	setElement("PreWarnDaysNum",list[11]);
	setElement("MaintFee",list[12]);
	//setElement("MeasureFlag",list[17]);
	setElement("MeasureDeptDR",list[18]);
	setElement("MeasureHandler",list[19]);
	setElement("MeasureTel",list[20]);
	setElement("ServiceDR",list[21]);
	setElement("ServiceHandler",list[22]);
	setElement("ServiceTel",list[23]);
	setElement("Remark",list[24]);
	setElement("InvalidFlag",list[35]);
	setElement("Hold1",list[39]);
	setElement("Hold2",list[40]);
	setElement("Hold3",list[41]);
	setElement("Hold4",list[42]);
	setElement("Hold5",list[43]);
	setElement("CycleUnit",list[sort+3]);
	setElement("MaintType",list[sort+4]);
	setElement("MeasureDept",list[sort+9]);
	setElement("Service",list[sort+10]);
	setElement("No",list[sort+16]);
	//setElement("TotalFee",list[44]);
	setElement("FeeType",list[46]);
	//setElement("CycleUnit",list[7],"value");	
	setElement("CycleUnit",list[sort+3]);*/
	//alert(list[47])
	if (list[47]!="")
	{
		//$('#MonthStr').datebox('setValue', "2021-04-06")
		setElement("MonthStr", list[47].substring(0,7));
	}
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	//if(elementID=="IStoreLocDR_CTLOCDesc") {setElement("IStoreLocDR",rowData.TRowID)}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
function deleterow(EquipDR)
{
	var rows = $("#DHCEQEquipList").datagrid('getRows');//获得所有行
	for (var i=0;i<rows.length;i++)
	{
		if(rows[i].TRowID==EquipDR)
		{
			var index=i;
			var RowID=rows[i].TListID;
		}
	}
	messageShow("confirm","","","是否删除指定范围数据?","",function(){
		deletedata(RowID,index)
	},'');
}
function deletedata(RowID,index)
{
	if(RowID=="")
	{
		$("#DHCEQEquipList").datagrid('deleteRow',index);
	}
	else
	{
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange", "DeleteManageLimitList",RowID);
		if (Rtn ==0)
		{
			alertShow("删除成功!")
			$HUI.datagrid("#DHCEQEquipList",{ 
		    url:$URL, 
		    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSMaintPlan",
	        	QueryName:"PlanEquipList",
				MPID:getElementValue("MPRowID"),
				},
			})
			$("#DHCEQEquipList").datagrid('reload');
		}
		else
		{
			alertShow("操作失败!  "+Rtn);	// MZY0093	2021-09-08
			return;
		}
	}
}
function BSave_Clicked()
{
  	var combindata=getElementValue("MPRowID");
	combindata=combindata+"^"+getElementValue("Name"); 
	combindata=combindata+"^"+getElementValue("MaintLocDR");
	combindata=combindata+"^"+getElementValue("MaintUserDR");
	combindata=combindata+"^"+getElementValue("SDate");
	combindata=combindata+"^"+getElementValue("EDate");
	//alert(combindata)
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveDataSimple", combindata);
	var Rtn=Rtn.split("^")
	if ($('#RowID').val()=="") $('#RowID').val(Rtn[1]);
	if (Rtn[1]<0) 
	{
		alertShow("更新失败！");
		return;	
	}
	alertShow("更新成功！");
	var url="dhceq.em.modifymaintplan.csp?&MPRowID="+getElementValue("MPRowID");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
function BCancelSubmit_Click()
{
	if (getElementValue("MPRowID")!="")
	{
		messageShow("confirm","","","确定作废本计划吗?","",function(){
			canceldata();
		},'');
	}
}
function canceldata()
{
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "CancelSubmitData", getElementValue("MPRowID"));
	if (Rtn<0) 
	{
		alertShow("操作失败！");
		return;	
	}
	alertShow("操作成功！");
	var url="dhceq.em.modifymaintplan.csp?&MPRowID="+getElementValue("MPRowID");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}

function BAssign_Clicked()
{
	if ((getElementValue("MaintUserDR")=="")||(getElementValue("MonthStr")==""))
	{
		alertShow("请选择分派的'维护工程师'和'维护月份' !")
	}
	else
	{
		messageShow("confirm","","","本计划单分派维护工程师: "+getElementValue("MaintUserDR_Name")+"("+getElementValue("MonthStr")+")", "", Assign)
	}
}
function Assign()
{
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "Assign", getElementValue("MPRowID"), getElementValue("MaintLocDR"), getElementValue("MaintUserDR"), getElementValue("SDate"), getElementValue("EDate"));
	if (Rtn<0) 
	{
		alertShow("操作失败！ "+Rtn);
	}
	else
	{
		alertShow("操作成功！");
		var url="dhceq.em.modifymaintplan.csp?&MPRowID="+getElementValue("MPRowID");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	}
}

function BUpdateExecute_Click()
{
	messageShow("confirm","","","追加的计划单正在执行,是否将设备同步至执行单?","",UpdateExecuteList,UnUpdateExecuteList);
}

function UpdateExecuteList()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","UpdateExecuteList", getElementValue("MPRowID"), getElementValue("EquipDRStr"));
	//alert(jsonData)
	if (Rtn<0)
	{
		messageShow('alert','error','错误提示！',"");
	}
	else
    {
		//window.location.reload()
		//var url= 'dhceq.em.inventoryexception.csp?&InventoryDR=&InventoryNo='+getElementValue("InventoryNo")+'&StatusDR='+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
	    //window.setTimeout(function(){window.location.href=url},50);
	    messageShow("popover","","","同步成功！","");
    }
}
function UnUpdateExecuteList()
{
	
}
// MZY0099	2200181		2021-11-13
function addEquip()
{
	var url="dhceq.em.createmaintplan.csp?&AddFlag=1&MPRowID="+getElementValue("MPRowID");  //Modefied by zc0122 2022-10-12 追加设备添加计划单入参
	var title="设备保养计划";
	showWindow(url,title,"","","icon-w-paper","modal","","","large");
	
	//var url= 'dhceq.em.maintplansimple.csp?&EquipDRStr='+selectEquips+'&ReadOnly=';
	//showWindow(url,"新建固定月份(一次)计划单","","10row","icon-w-paper","modal","","","small");
}
function delEquip()
{
	var checkedEquips = $('#DHCEQEquipList').datagrid('getChecked');
	var selectEquips = "";
	$.each(checkedEquips, function(index, item){
		if(selectEquips!="") selectEquips=selectEquips+",";
		selectEquips=selectEquips+item.TListID;
	});
	if(selectEquips=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	messageShow("confirm","","","是否删除指定范围数据?","",function(){
		deletedata(selectEquips, 0)
	},'');
}
