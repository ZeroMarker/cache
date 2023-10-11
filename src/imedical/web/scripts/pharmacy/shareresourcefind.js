var columns=getCurColumnsInfo('RM.G.Rent.ShareResourceFind','','','');
//Modify by zx 2020-04-20 Bug ZX0084
var curTableID="tDHCEQShareResourceFind"
var paramsObj={
	firstFlag:'1',
	rentLocDR:'',
	rentStatus:'',
	equipStatus:'',
	isLoanOut:''
}
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	defindTitleStyle();
	initButton(); //按钮初始化
	//initButtonWidth();
	initShareType();
	initEquipStatus();
	//Modify by zx 2020-04-20 样式调整 Bug ZX0084
	initDataGrid();
	//Modify by zx 2020-04-20 样式调整 Bug ZX0084
	//点击维修配件也签刷新
	initShareSourceKeyWords();
	/*
	$HUI.tabs("#ShareSourceTabs",{
		onSelect:function(title)
		{
			paramsObj.rentLocDR=getElementValue("RentLocDR");
			paramsObj.rentStatus="";
			paramsObj.equipStatus="";
			paramsObj.firstFlag='0';
			if (title.indexOf("全部资源") != -1)
			{
				curTableID="tDHCEQShareResourceFind_All";
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
			}
			else if(title.indexOf("在库资源") != -1)
			{
				curTableID="tDHCEQShareResourceFind_Stock";
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="0";
				paramsObj.isLoanOut="";
			}
			else if (title.indexOf("调出资源") != -1) //Modify by zx 2020-06-09 BUG ZX0100
			{
				curTableID="tDHCEQShareResourceFind_LoanOut";
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="1";
				paramsObj.isLoanOut="1";
			}
			else if (title.indexOf("调入资源") != -1) //Modify by zx 2020-06-09 BUG ZX0100
			{
				curTableID="tDHCEQShareResourceFind_LoanIn";
				paramsObj.rentLocDR=curLocID;
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
			}
			else if (title.indexOf("故障资源") != -1)
			{
				curTableID="tDHCEQShareResourceFind_Fault";
				paramsObj.rentLocDR="";
				paramsObj.equipStatus="1";
				paramsObj.isLoanOut="";
			}
			initDataGrid();
		}
	});
	*/
	//add by csj 2020-07-02 临床科室隐藏待审批上架设置 需求号：1396144
	var loctype=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","CheckLocType",curLocID)
	if(loctype==0)
	{
		$("#putOnSetAudit").hide()
	}
}

//add by czf 2022-07-15 UI需求修改 2612994
function initShareSourceKeyWords()
{
	 $("#ShareSourceKeyWords").keywords({
        singleSelect:true,
        onClick:function(v){},
        onUnselect:function(v){
	    },
        onSelect:function(v){
	        var selectItemID=v.id;
	        paramsObj.rentLocDR=getElementValue("RentLocDR");
			paramsObj.rentStatus="";
			paramsObj.equipStatus=getStatusValue();      //modified by LMH 20220929 2804591    
			paramsObj.firstFlag='0';
			if (selectItemID=="AllResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if(selectItemID=="StockResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="0";
				paramsObj.isLoanOut="";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if (selectItemID=="LoanOutResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="1";
				paramsObj.isLoanOut="1";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if (selectItemID=="LoanInResource")
			{
				paramsObj.rentLocDR=curLocID;
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if (selectItemID=="FaultResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.equipStatus="1";
				paramsObj.isLoanOut="";
				setStatusValue('1');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",true); //modified by LMH 20220929 2804591
			}
			initDataGrid();
	    },
        labelCls:'blue',
        items:[
            {text:'全部资源'+'<span class="eq-resourcenum" id="AllNum">0</span>',id:'AllResource',selected:true},
            {text:'在库资源'+'<span class="eq-resourcenum" id="StockNum">0</span>',id:'StockResource'},
            {text:'调出资源'+'<span class="eq-resourcenum" id="LoanOutNum">0</span>',id:'LoanOutResource'},
            {text:'调入资源'+'<span class="eq-resourcenum" id="LoanInNum">0</span>',id:'LoanInResource'},
            {text:'故障资源'+'<span class="eq-resourcenum" id="FaultNum">0</span>',id:'FaultResource'}
        ]
    });
}

function initDataGrid()
{
	$HUI.datagrid("#"+curTableID,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"ShareResource",
			ShareType:getElementValue("ShareType"),
			EquipDR:getElementValue("EquipDR"),
			RentLocDR:paramsObj.rentLocDR,
			LocID:curLocID,
			UserID:curUserID,
			CurJob:getElementValue("Job"),
			RentStatus:paramsObj.rentStatus,
			EquipStatus:paramsObj.equipStatus,
			IsLoanOut:paramsObj.isLoanOut
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
			//首次加载界面加载数量
			if(paramsObj.firstFlag=="1")
			{
				GetPutOnSetAuditNum();	//待审批上架设置数量 add by csj 2020-07-02 需求号：1396144
				getToDoNum(); //待办数量
				getTotalInfo(); //页签显示数量
			}
			/*if (curTableID!="tDHCEQShareResourceFind_All")
			{
				$("#"+curTableID).datagrid("hideColumn", "REHistory");
			}
			else
			{*/
				$("#"+curTableID).datagrid('showColumn', "REHistory")
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
	            //行
	            for(var i=0;i<trs.length;i++){
	                //行内单元格
	                for(var j=1;j<trs[i].cells.length;j++){
	                    var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
	                    var cell_value=$(row_html).find('div').html();
	                    if(cell_field == 'REWashFlag')
	                    {
		                    if(cell_value == "未处理")
		                    {
	                        	trs[i].cells[j].style.cssText='background:#f58800;color:#fff;';
			                }
			                else
			                {
				                $('#REWashz'+i).remove();
				            }
	                    }
	                    else if(cell_field == 'REInspectFlag')
	                    {
		                    if(cell_value == "未处理")
		                    {
	                        	trs[i].cells[j].style.cssText='background:#ffbd2e;color:#fff;';
			                }
			                else
			                {
				                $('#REInspectz'+i).remove();
				            }
	                    }
	                    else if(cell_field == 'REEquipStatus')
	                    {
		                    if(cell_value == "故障")
		                    {
	                        	trs[i].cells[j].style.cssText='background:#ee4f38;color:#fff;';
			                }
			                else if(cell_value == "完好")
			                {
				                trs[i].cells[j].style.cssText='background:#4caf50;color:#fff;';
				            }
	                    }
	                }
	                
		            if ((curTableID == "tDHCEQShareResourceFind_LoanOut")||(curTableID == "tDHCEQShareResourceFind_LoanIn"))
	                {
	                	$("#"+curTableID).datagrid("hideColumn", "REHistory");
	                }
	            }
			//}
			
		},
		onSelect:function(rowIndex,rowData){
			//fillData(rowData);
		}
	});
}

// Author add by zx 2019-12-19
// Desc 列表查询
// Input 无
// Output 无
// modified by sjh BUG0032 2020-08-31 修改元素取值方式
function BFind_Clicked()
{
	paramsObj.rentLocDR = getElementValue("RentLocDR")  //added by LMH 20220929 2804591
	getStatusValue();	 ////added by LMH 20220929 2804591
	$HUI.datagrid("#"+curTableID,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"ShareResource",
			ShareType:getElementValue("ShareType"),
			EquipDR:getElementValue("EquipDR"),
			RentLocDR:paramsObj.rentLocDR,                   //Modefied by zc0101 2021-5-13 将getElementValue("RentLocDR")改成取paramsObj.rentLocDR //Modify by mwz 2020-12-28 BUG MWZ0043
			LocID:curLocID,
			UserID:curUserID,
			CurJob:getElementValue("Job"),
			RentStatus:paramsObj.rentStatus,       //Modefied by zc0101 2021-5-13 将getElementValue("RentStatus")改成取paramsObj.rentStatus
			EquipStatus:paramsObj.equipStatus,     //Modefied by zc0101 2021-5-13 将getElementValue("EquipStatus")改成取paramsObj.equipStatus
			IsLoanOut:paramsObj.isLoanOut			//Modefied by zc0101 2021-5-13 将getElementValue("IsLoanOut")改成取paramsObj.isLoanOut
		}
	});
}

// Author add by zx 2019-12-19
// Desc 资源上架
// Input 无
// Output 无
function addShareResource()
{
	var url="dhceq.rm.shareresource.csp?";
	showWindow(url,"租赁共享资源维护","","","icon-w-paper","modal","","","middle",reloadGrid);  //modify by lmm 2020-06-05 UI
}

// Author add by zx 2019-12-19
// Desc 初始化资源类型为combobox
// Input 无
// Output 无
function initShareType()
{
	var Status = $HUI.combobox('#ShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"0",
		data:[{
				id: '0',
				text: '设备'
			}]
	});
}

// Author add by zx 2019-12-19
// Desc 初始化资源类型为combobox
// Input 无
// Output 无
function initEquipStatus()
{
	var Status = $HUI.combobox('#EquipStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '完好'
			},{
				id: '1',
				text: '故障'
			},{
				id: '2',
				text: '报废'
			}]
	});
}

function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}
function clearData(elementID)
{
	setElement(elementID+"DR","")
}

// Author add by zx 2019-12-19
// Desc 租借申请、资源上架 模态窗关闭后刷新列表
// Input 无
// Output 无
function reloadGrid()
{
	$("#"+curTableID).datagrid('reload');
}

function rentRequest()
{
	var url="dhceq.rm.rentrequest.csp?";
	showWindow(url,"调配申请","840","235","icon-w-paper","modal","","","",reloadGrid);    //modify by mwz 2022-07-14 UI  //modified by LMH 20220929 2801466 调整模态窗大小 //modified by LMH 20230206 UI调整高度
}

// Author add by zx 2019-12-19
// Desc 共享资源相关操作及历史记录
// Input 无
// Output 无
function rentAudit()
{
	var url="dhceq.rm.rentdolist.csp?";
	showWindow(url,"租赁单信息","1050px","","icon-w-paper","modal","","","middle",reloadGrid);    //modify by lmm 2020-06-04 UI  //modified by LMH 20230215 UI 调大弹框宽度 
}

// Author add by zx 2019-12-19
// Desc 租赁统计
function rentStat()
{
	//var url="dhceq.rm.rentstatistics.csp?ReportFileName=DHCEQRentStatistic1.raq";
	var url="dhceq.rm.rentstat.csp?";
	showWindow(url,"租赁统计","","","icon-w-paper","modal","","","large");    //modify by lmm 2020-06-04 UI
}
// Author add by CSJ 2020-07-02 需求号：1396144
// Desc 待审批资源上架
// Input 无
// Output 无
function putOnSetAudit()
{
	var url="dhceq.rm.putonset.csp?StatusDR=1&NoCurDateFlag=N&OuterTypeAllFlag=Y";
	showWindow(url,"待审批资源上架","","","icon-w-paper","modal","","","large");  
}

// Author add by CSJ 2020-07-02 需求号：1396144
// Desc 待审批资源上架数量
function GetPutOnSetAuditNum()
{
	$m({
		ClassName:"web.DHCEQ.RM.BUSPutOnSet",
		MethodName:"GetPutOnSetAuditNum",
	},function(textData){
		$("#putOnSetToDoNum").text(textData);
	});
}
// Author add by zx 2020-01-10
// Desc 共享资源相关操作及历史记录
// Input 无
// Output 无
function getToDoNum()
{
	$m({
		ClassName:"web.DHCEQ.RM.BUSShareResource",
		MethodName:"GetBussAlertNum",
		GroupID:curSSGroupID,
		UserID:curUserID
	},function(textData){
		$("#ToDoNum").text(textData);
	});
}

// Author add by zx 2020-02-14
// Desc datagrid汇总数量
// Input 无
// Output 无
// Modify by zx 2020-04-20 Bug ZX0084
function getTotalInfo()
{
	$m({
		ClassName:"web.DHCEQ.RM.BUSShareResource",
		MethodName:"GetTotalInfo",
		CurJob:getElementValue("Job")
	},function(textData){
		var totalInfo=textData.split("^")
		$("#AllNum").html(totalInfo[0]);
		$("#StockNum").html(totalInfo[1]);
		$("#LoanOutNum").html(totalInfo[2]);
		$("#LoanInNum").html(totalInfo[3]);
		$("#FaultNum").html(totalInfo[4]);
	});
}

// Author add by zx 2019-12-19
// Desc 共享资源相关操作--清洗消毒
// Input curIndex:当前列位置
// Output 无
function BWashClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var washFlag = rowData.REWashFlag;
	var shareResourceDR = rowData.RERowID;
	if (washFlag=="是")
	{
		messageShow('alert','info','提示',"该资源不需要清洗消毒！");
	}
	else
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeShareResourceStatus",shareResourceDR, "1");
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0)
		{
			$("#"+curTableID).datagrid('reload'); 
		}
		else
		{
			messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
			return;
		}
	}
}


// Author add by zx 2019-12-19
// Desc 共享资源相关操作--检测
// Input curIndex:当前列位置
// Output 无
function BInspectClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var inspectFlag = rowData.REInspectFlag;
	var shareResourceDR = rowData.RERowID;
	if (inspectFlag=="是")
	{
		messageShow('alert','info','提示',"该资源不需要检测！");
	}
	else
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeShareResourceStatus",shareResourceDR, "2");
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0)
		{
			$("#"+curTableID).datagrid('reload'); 
		}
		else
		{
			messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
			return;
		}
	}
}

// Author add by zx 2019-12-19
// Desc 共享资源相关操作--下架
// Input curIndex:当前列位置
// Output 无
function BPutOffClick(curIndex)
{
	$.messager.confirm("下架提醒", "确定要下架这台设备?", function (r) {
		if (r) {
			var rowsData = $("#"+curTableID).datagrid("getRows");
			var rowData = rowsData[curIndex];
			if(rowData.RERentLocDR_DeptDesc!="")
			{
				messageShow('alert','error','提示',"租赁中设备不允许下架！");
				return;
			}
			var shareResourceDR = rowData.RERowID;
			var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","PutOffShareResource",shareResourceDR);
			jsonData=JSON.parse(jsonData);
			if (jsonData.SQLCODE==0)
			{
				$("#"+curTableID).datagrid('reload'); 
			}
			else
			{
				messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
				return;
			}
		} else {
			return;
		}
	});

}

// Author add by zx 2020-04-20
// Desc 共享资源报修
// Input curIndex:当前列位置
// Output 无
function BMaintRequest(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var equipID=rowData.REEquipDR;
	var url="dhceq.em.mmaintrequestsimple.csp?ExObjDR="+equipID+"&QXType=&WaitAD=off&Status=0&RequestLocDR="+curLocID+"&StartDate=&EndDate=&InvalidFlag=N&vData=^Action=^SubFlag=&LocFlag="+curLocID;
	showWindow(url,"维修申请","","","icon-w-paper","modal","","","small"); //modify by lmm 2020-06-05 UI
}

/**
 * 函数表达式设置设备状态值
 * @input  无
 * @output  
 * @returns 无
 * @author LMH 20220929 2804591
 */
var getStatusValue = function()
{
	paramsObj.equipStatus = $("#EquipStatus").combobox('getValue'); 
}

/**
 * 函数表达式设置设备状态值
 * @input  Id：combobox值对应id
 * @output  
 * @returns 无
 * @author LMH 20220929 2804591
 */
var setStatusValue = function(Id)
{
	if (Id === '') $("#EquipStatus").combobox('setValue',Id);
	else if (Id === '1') $("#EquipStatus").combobox('setValue',Id)
}
