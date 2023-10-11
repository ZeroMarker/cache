var editIndex=undefined;
var modifyBeforeRow = {};
var IRowID=getElementValue("IRowID");
var StatusDR=getElementValue("StatusDR");
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryList','','','');
var DisplayFlag="allflag";

$(function(){
	if (StatusDR==1) DisplayFlag="uncheckflag";
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	if (StatusDR==0)
	{
		var StoreLocDR=getElementValue("StoreLocDR")
		setElement("IStoreLocDR",StoreLocDR)
		setElement("IStoreLocDR_CTLOCDesc",getElementValue("StoreLoc"))
		setElement("IManageLocDR",getElementValue("ManageLocDR"))
		setElement("IManageLocDR_CTLOCDesc",getElementValue("ManageLoc"))
		//StoreLocDR不为空时是科室自盘
		if (StoreLocDR!="")
		{
			setElement("ISelfFlag",1)
			disableElement("ISelfFlag",1);
			disableElement("IStoreLocDR_CTLOCDesc",1);
		}
		//add by zc0128 2023-02-08 管理部门控制 begin
		if (getElementValue("QXType")=="0")
		{
			disableElement("IManageLocDR_CTLOCDesc",1);
			disableElement("ISelfFlag",1);  //Modefied by zc0130 2023-2-17 科室自盘标识控制
		}
		else
		{
			singlelookup("IManageLocDR_CTLOCDesc","PLAT.L.Loc","","")
		}
		//add by zc0128 2023-02-08 管理部门控制 end
	}else{
		var url='dhceq.em.inventoryplanmanage.csp?InventoryPlanDR=&InventoryDR='+getElementValue("IRowID")+'&ReadOnly='+getElementValue("ReadOnly")+'&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&DisposeType='+getElementValue("DisposeType")+'&IAStatusDR='+getElementValue("IAStatusDR");
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	initUserInfo();
    initMessage("Inventory"); 	//获取所有业务消息
    initLookUp(); 				//初始化放大镜
    initIEquipType();			//初始化管理类组
    defindTitleStyle();
    initButton(); 				//按钮初始化 
    initButtonWidth();
    InitEvent()
    setRequiredElements("IEquipType^IManageLocDR_CTLOCDesc"); //必填项
    fillData(); 				//数据填充
    //initPage(); 				//非通用初始化
    setEnabled(); 				//按钮控制
    //setElementEnabled(); 		//输入框只读控制
    //initEditFields(); 		//获取可编辑字段信息
	//initApproveButtonNew(); 		//初始化审批按钮
	initFilterKeyWords();		// MZY0133	2612992		2022-09-09
	$HUI.datagrid("#DHCEQInventoryList",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryList",
		        InventoryDR:IRowID,
		    	StoreLocDR:getElementValue("StoreLocDR"),
		    	IStoreLocDR:getElementValue("IStoreLocDR"),
		    	EquipTypeIDs:getElementValue("IEquipTypeIDs"),
		    	StatCatDR:getElementValue("IStatCatDR"),
		    	OriginDR:getElementValue("IOriginDR"),
		    	onlyShowDiff:getElementValue("onlyShowDiff"),
		    	FilterInfo:getElementValue("FilterInfo"),
		    	ManageLocDR:getElementValue("IManageLocDR"),
		    	QXType:getElementValue("QXType"),
		    	StatusDR:StatusDR,
		    	HospitalDR:getElementValue("IHospitalDR"),
		    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
		    	DisplayFlag:DisplayFlag
		},
		rownumbers:true,  		//如果为true则显示行号列
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		// MZY0133	2612992		2022-09-09	删除toolbar
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45],
		onLoadSuccess:function(){
			creatToolbar();
			// 设置隐藏列
			$("#DHCEQInventoryList").datagrid("hideColumn", "TResultType");		//结果
			if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992006")!=1)
			{
				$("#DHCEQInventoryList").datagrid("hideColumn", "ILCondition_Display");
				$("#DHCEQInventoryList").datagrid("hideColumn", "IListInfo");
				$("#DHCEQInventoryList").datagrid("hideColumn", "ILPictrue");
			}
			var trs = $(this).prev().find('div.datagrid-body').find('tr');
			//alert(trs.length)
			for (var i = 0; i < trs.length; i++)
			{
				// 遍历所有列
				//alert(trs[i].cells.length)
				var TRowID="";
				for (var j = 0; j < trs[i].cells.length; j++)
				{
					var row_html = trs[i].cells[j];
	                var cell_field=$(row_html).attr('field');
                    //if (cell_field=="TRowID") TRowID=$(row_html).find('div').html();
					if (cell_field=="ILStatus_Display")
					{
						//alert($(row_html).find('div').html())
			 			// 改变单元格颜色
						//trs[i].cells[j].style.cssText = 'background:#EEEE00;color:#fff';
						if ($(row_html).find('div').html()=="账物一致") trs[i].cells[j].style.cssText = 'background:#22b14c';
						if ($(row_html).find('div').html()=="科室不符") trs[i].cells[j].style.cssText = 'background:#0080ff';	// MZY0050	1498290		2020-09-01
						if ($(row_html).find('div').html()=="盘亏") trs[i].cells[j].style.cssText = 'background:#ff0000';
						if ($(row_html).find('div').html()=="待查找") trs[i].cells[j].style.cssText = 'background:#ff0000';	// MZY0049	2020-08-25
					    //if ($(row_html).find('div').html()=="科室不符") trs[i].cells[j].style.cssText = 'background:#ff8000';
					    //if ($(row_html).find('div').html()=="账物一致") trs[i].cells[j].style.cssText = 'background:#c0c0c0';
					}
				}
			}
			$("#"+DisplayFlag).css("color", "#FF0000");
			//$("#"+DisplayFlag).css("background-color", "#40A2DE");
			if ((+getElementValue("IStatus")==0)||(getElementValue("IAStatus")!=getElementValue("IAStatusDR")))
			{
				$('#BSaveList').linkbutton('disable');
				// MZY0044	1457724		2020-08-07
				//$('#BResultStat').linkbutton('disable');
				//$('#BSaveTXT').linkbutton('disable');
				//$('#BPrtInventory').linkbutton('disable');
				//$('#BBarCodePrint').linkbutton('disable');
			}
			if (+getElementValue("IStatus")==2)	$('#BSaveList').linkbutton('disable');
			$("#BSaveListNew").css("width","80px");		// MZY0133	2612992		2022-09-09
		}
	});
	//Modefied by zc0127 2023-01-10 盘点建单无关信息影藏 begin
	$("#DHCEQInventoryList").datagrid("hideColumn", "TSelect");
	$("#DHCEQInventoryList").datagrid("hideColumn", "LIUseStatus_USDesc");
	$("#DHCEQInventoryList").datagrid("hideColumn", "LIPurpose_PDesc");
	$("#DHCEQInventoryList").datagrid("hideColumn", "ILILeaveFactoryNo");
	$("#DHCEQInventoryList").datagrid("hideColumn", "LILossReasonDR_LRDesc");
	$("#DHCEQInventoryList").datagrid("hideColumn", "ILILocationDR_LDesc");
	// MZY0151	2023-02-01
	if ((typeof(HISUIStyleCode)!="undefined")&&(HISUIStyleCode=="lite"))
	{
		jQuery("#menubtn-prt").attr("style","width:116px");
	}
};

function InitEvent() //初始化
{
	if (jQuery("#BComfirm").length>0)
	{
		jQuery("#BComfirm").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BComfirm").on("click", BComfirm_Clicked);
	}
	if (jQuery("#BSaveException").length>0)
	{
		jQuery("#BSaveException").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BSaveException").on("click", BSaveException_Clicked);
	}

	if (jQuery("#BInventoryResult").length>0)
	{
		//jQuery("#BInventoryResult").linkbutton({iconCls: 'icon-w-import'});
		jQuery("#BInventoryResult").on("click", BInventoryResult_Clicked);
	}
	if (jQuery("#BLocSubmit").length>0)
	{
		jQuery("#BLocSubmit").linkbutton({iconCls: 'icon-w-stamp'});	// MZY0123	2612989		2022-05-12
		jQuery("#BLocSubmit").on("click", BLocSubmit_Clicked);
	}
	if (jQuery("#BInventoryAudit").length>0)
	{
		jQuery("#BInventoryAudit").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BInventoryAudit").on("click", BInventoryAudit_Clicked);
	}
	//Modify by QW20210430 过滤条件按钮 BUG:QW0103
	if (jQuery("#BFilterInfo").length>0)
	{
		jQuery("#BFilterInfo").linkbutton({iconCls: 'icon-w-filter'});
		jQuery("#BFilterInfo").on("click", BFilterInfo_Clicked);
	}
	// MZY0064	1630877		2020-12-23
	if (jQuery("#BResultStat").length>0)
	{
		jQuery("#BResultStat").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BResultStat").on("click", BResultStat_Clicked);
	}
	if (jQuery("#BPrtInventory").length>0)
	{
		jQuery("#BPrtInventory").linkbutton({iconCls: 'icon-w-print'});
		jQuery("#BPrtInventory").on("click", BPrtInventory_Clicked);
	}
	if (jQuery("#BBarCodePrint").length>0)
	{
		jQuery("#BBarCodePrint").linkbutton({iconCls: 'icon-w-print'});
		jQuery("#BBarCodePrint").on("click", BBarCodePrint_Clicked);
	}
	//InitRadio();	//  MZY0133	2612992		2022-09-09	取消
	// MZY0134	2952670		2022-09-20
	if (jQuery("#BInventoryBatch").length>0)
	{
		jQuery("#BInventoryBatch").linkbutton({iconCls: 'icon-w-list'});
		jQuery("#BInventoryBatch").on("click", BInventoryBatch_Clicked);
	}
	if (jQuery("#BInventoryPlan").length>0)
	{
		jQuery("#BInventoryPlan").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BInventoryPlan").on("click", BInventoryPlan_Clicked);
	}
}
function initPage() //初始化
{
	//
}
// MZY0049	2020-08-25	调整显示标识
function creatToolbar()
{
	/* MZY0123	2612989		2022-05-12
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>全部设备</a>"+
						"<a id='consistentflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>账物一致</a>"+
						"<a id='unconsistentflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>账物不一致</a>"+
						"<a id='uncheckflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>未盘</a>"+
						"<a id='unchecklocflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>科室不符</a>"+
						"<a id='unfindflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>盘亏</a>"+
						"<a id='findflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>待查找</a>"
						//<a href="#" class="hisui-linkbutton">蓝色按钮</a>
						//<a href="#" class="hisui-linkbutton yellow">黄色按钮</a>
	//alert(lable_innerText)
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BAll_Clicked);
	}
	if (jQuery("#consistentflag").length>0)
	{
		jQuery("#consistentflag").linkbutton({iconCls: 'icon-star'});
		jQuery("#consistentflag").on("click", BConsistentflag_Clicked);
	}
	if (jQuery("#unconsistentflag").length>0)
	{
		jQuery("#unconsistentflag").linkbutton({iconCls: 'icon-star'});
		jQuery("#unconsistentflag").on("click", BUnConsistentflag_Clicked);
	}
	if (jQuery("#uncheckflag").length>0)
	{
		jQuery("#uncheckflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#uncheckflag").on("click", BUnCheck_Clicked);
	}
	if (jQuery("#unchecklocflag").length>0)
	{
		jQuery("#unchecklocflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#unchecklocflag").on("click", BUnCheckLocflag_Clicked);
	}
	if (jQuery("#unfindflag").length>0)
	{
		jQuery("#unfindflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#unfindflag").on("click", BUnFindFlag_Clicked);
	}
	// MZY0049	2020-08-25
	if (jQuery("#findflag").length>0)
	{
		jQuery("#findflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#findflag").on("click", BFindFlag_Clicked);
	}*/
}
function BAll_Clicked()
{
	//alert("BAll_Clicked")
	DisplayFlag="allflag";
	/*$("#allflag").css("color", "#FF0000");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BConsistentflag_Clicked()
{
	//alert("BConsistentflag_Clicked")
	DisplayFlag="consistentflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FF0000");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnConsistentflag_Clicked()
{
	//alert("BUnConsistentflag_Clicked")
	DisplayFlag="unconsistentflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FF0000");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnCheck_Clicked()
{
	//alert("BUnCheck_Clicked")
	DisplayFlag="uncheckflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FF0000");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnCheckLocflag_Clicked()
{
	//alert("BUnCheckLocflag_Clicked")
	DisplayFlag="unchecklocflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FF0000");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnFindFlag_Clicked()
{
	//alert("BUnFindFlag_Clicked")
	DisplayFlag="unfindflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FF0000");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
// MZY0049	2020-08-25
function BFindFlag_Clicked()
{
	//alert("BFindFlag_Clicked")
	DisplayFlag="findflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FF0000");*/
	BFind_Clicked();
}
function fillData()
{
	if (IRowID=="") return;
	var StoreLocDR=getElementValue("StoreLocDR")
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneInventory",IRowID,StoreLocDR);
	//alertShow(InventoryDR+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	if (jsonData.Data.IEquipTypeIDs!="")
	{
		var arr=jsonData.Data.IEquipTypeIDs.split(",");
		$('#IEquipType').combogrid('setValues', arr);
	}
}
function setEnabled()
{
	if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992008")!=1) hiddenObj("BSaveException",1);	// MZY0048	2020-08-21	是否启用盘盈
	var IStatus=getElementValue("IStatus");
	var IAStatusDR=getElementValue("IAStatusDR");
	var IAStatus=getElementValue("IAStatus")
	//alert("IStatus:"+IStatus+"   IAStatusDR:"+IAStatusDR+"   IAStatus:"+IAStatus+"   StatusDR:"+StatusDR)
	hiddenObj("BInventoryResult",1);	// MZY0047	1457470		2020-08-19	导入
	//MZY0123	2612989		2022-05-12	调整隐藏各单据状态的按钮
	if (IStatus=='')
	{
		hiddenObj("BDelete",1);
		hiddenObj("BComfirm",1);
		hiddenObj("BLocSubmit",1);		//盘点提交
		hiddenObj("BInventoryBatch",1);	// MZY0134	2952670		2022-09-20
	}
	else if (IStatus==0)
	{
		hiddenObj("BFind",1)		// MZY0128	2673539,2673540		2022-06-23
		hiddenObj("BInventoryBatch",1);	// MZY0134	2952670		2022-09-20
	}
	else if (IStatus==1)
	{
		hiddenObj("BFind",1)
		hiddenObj("BSave",1)
		hiddenObj("BDelete",1);
		hiddenObj("BComfirm",1);
	}
	else if (IStatus==2)
	{
		hiddenObj("BFind",1)
		hiddenObj("BSave",1)
		hiddenObj("BDelete",1);
		hiddenObj("BComfirm",1);
		
		//disableElement("BSaveList",1);		//保存盘点结果
		hiddenObj("BInventoryResult",1)	//导入盘点结果
		//disableElement("BSaveException",1);	//盘盈
		hiddenObj("BCancelSubmit",1);	//退回重盘
		hiddenObj("BAudit",1);			//盘点完成审核
		//disableElement("BPrtInventory",1);	//打印盘点单
		//disableElement("BSaveTXT",1);		//导出
		//disableElement("BBarCodePrint",1);	//打印条码
		hiddenObj("BInventoryBatch",1);	// MZY0134	2952670		2022-09-20
	}
	if (StatusDR==0)
	{
		hiddenObj("BLocSubmit",1);		//盘点提交
		hiddenObj("BInventoryResult",1)	//导入盘点结果
		//disableElement("BSaveList",1);		//保存盘点结果
		hiddenObj("BSaveException",1);	//盘盈
		hiddenObj("BResult",1);			//结果
		hiddenObj("BResultStat",1);		//结果汇总	 MZY0064	1630825		2020-12-23
		hiddenObj("BPrtInventory",1);	//打印盘点单
		hiddenObj("BSaveTXT",1);		//导出
		hiddenObj("BBarCodePrint",1);	//打印条码
		//disableElement("BFilterInfo",1);		//过滤条件 Modify by QW20210430 BUG:QW0103
		
		hiddenObj("BCancelSubmit",1);	//退回重盘
		hiddenObj("BAudit",1);			//盘点完成审核
	}
	else if (StatusDR==1)
	{
		//编辑、操作明细记录等
		hiddenObj("BFilterInfo",1);		//过滤条件
	}
	else if (StatusDR==2)
	{
		//disableElement("BCancelSubmit",1);	//退回重盘
		hiddenObj("BLocSubmit",1)		//盘点提交
		hiddenObj("BFilterInfo",1);		//过滤条件
	}
	///管理部门处理界面才显示
	if (IAStatusDR==0)
	{
		//hiddenObj("BCancelSubmit",1);	//退回重盘
		hiddenObj("BAudit",1);			//盘点完成审核
		//disableElement("BResult",1);		//结果
		//disableElement("BResultStat",1);	//结果汇总
	}
	else if (IAStatusDR==1)
	{
		hiddenObj("BLocSubmit",1)		//盘点提交
		//disableElement("BSaveList",1);		//保存盘点结果明细
		//disableElement("BInventoryResult",1)	//导入盘点结果
		//disableElement("BFilterInfo",1)		//过滤条件
		//disableElement("BSaveException",1);	//盘盈
	}
	if (IAStatusDR!=1)
	{
		hiddenObj("BCancelSubmit",1);	//退回重盘
		hiddenObj("BAudit",1);			//盘点完成审核
		hiddenObj("BInventoryAudit",1);		//盘点完成审核
	}
	
	if (IAStatus!=IAStatusDR)
	{
		hiddenObj("BLocSubmit",1)		//盘点提交
		//disableElement("BSaveList",1);		//保存盘点结果
		hiddenObj("BCancelSubmit",1);	//退回重盘
		hiddenObj("BAudit",1);			//盘点完成审核
		//disableElement("BInventoryResult",1)	//导入盘点结果
	}
	//add by cjc 20022-07-28 2733215 按钮灰化判断
	if((IAStatusDR=='')&&(IAStatusDR==0)){
		$('#menubtn-prt').menubutton('disable');
		$('#menubtn-prt').attr("disabled", "disabled").css({ "backgroundColor": "#bbbbbb" });
	}
	
}

function initIEquipType()
{
	$HUI.combogrid('#IEquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]/*,
	    onSelect:function(e){
		    //alert("onSelect:")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		},
		onClickRow:function(index, row){
			alert("onClickRow")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		}*/
	});
}
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	if(elementID=="IStoreLocDR_CTLOCDesc") {setElement("IStoreLocDR",rowData.TRowID)}
	else if(elementID=="IHospitalDR_HDesc") {setElement("IHospitalDR",rowData.TRowID)}
	else if(elementID=="PrintLoc_CTLOCDesc") {setElement("PrintLocDR",rowData.TRowID)}
	else if(elementID=="IManageLocDR_CTLOCDesc") {setElement("IManageLocDR",rowData.TRowID)}
	else if(elementID=="IPlan_Name") {
		setElement("IPlan_Name",rowData.TName)
		setElement("IHold6",rowData.TRowID)
	}	// MZY0128	2673539,2673540		2022-06-23
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQInventoryList').datagrid('validateRow', editIndex))
	{
		$('#DHCEQInventoryList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index)
{
	var Status=getElementValue("IStatus");
	// MZY0115	2469647		2022-03-10
	if (Status==0)
	{
		var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
		//objGrid.datagrid('getSelected').CTLSourceType_Desc
		//alert(rowData.ILBillEquipDR+":"+rowData.TSelect+":"+index)
		if (rowData.TSelect=="Y")
		{
			//alert("-")
			//rowData.TSelect="N"
			tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SetUncheckEquip", IRowID, rowData.ILBillEquipDR, 1);	// +
		}
		else
		{
			//alert("+")
			//rowData.TSelect="Y"
			tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SetUncheckEquip", IRowID, rowData.ILBillEquipDR, 0);	// -
		}
		
		$('#DHCEQInventoryList').datagrid('reload');
	}
	if (Status!=1) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQInventoryList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQInventoryList').datagrid('getRows')[editIndex]);
			bindGridEvent(); //编辑行监听响应
		} else {
			$('#DHCEQInventoryList').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        /*var objGrid = $("#DHCEQInventoryList");		// 表格对象
        setElement("CTLSourceTypeDesc", objGrid.datagrid('getSelected').CTLSourceType_Desc);
        setElement("CTLSourceType", objGrid.datagrid('getSelected').CTLSourceType);
        setElement("CTLSourceID",objGrid.datagrid('getSelected').CTLSourceID);
        setElement("CTLRowID",objGrid.datagrid('getSelected').CTLRowID);
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'});	// 数量
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
            // 根据数量变更后计算 金额
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
        });
        $(invPriceFeeEdt.target).bind("blur",function(){
            // 根据数量变更后计算 金额
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
        });*/
    }
    catch(e)
    {
        alertShow(e);
    }
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function BFind_Clicked()
{
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"));
	$HUI.datagrid("#DHCEQInventoryList",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.EM.BUSInventory",
	    	QueryName:"InventoryList",
	        InventoryDR:IRowID,
	    	StoreLocDR:getElementValue("StoreLocDR"),
	    	IStoreLocDR:getElementValue("IStoreLocDR"),
	    	EquipTypeIDs:getElementValue("IEquipTypeIDs"),
	    	StatCatDR:getElementValue("IStatCatDR"),
	    	OriginDR:getElementValue("IOriginDR"),
	    	onlyShowDiff:getElementValue("onlyShowDiff"),
	    	FilterInfo:getElementValue("FilterInfo"),
	    	ManageLocDR:getElementValue("IManageLocDR"),
	    	QXType:getElementValue("QXType"),
	    	StatusDR:StatusDR,
	    	HospitalDR:getElementValue("IHospitalDR"),
	    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
	    	DisplayFlag:DisplayFlag
		}
	});
}

function BSave_Clicked()
{
	//messageShow('alert','error','错误提示','BSave_Clicked');
	//setElement("IHold6",getElementValue("IPlan_Name"));	// MZY0128	2673539,2673540		2022-06-23
	
	var IPlanDR=getElementValue("IHold6")
	var IPlanName=getElementValue("IPlan_Name")
	if ((IPlanDR=="")&&(IPlanName!=""))
	{
		IPlanDR=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdInventoryPlan",IPlanName);
		setElement("IHold6",IPlanDR);
	}
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"));
	if (getElementValue("IManageLocDR")=="")
	{
		messageShow('alert','error','错误提示','管理部门不能为空!');
		return;
	}
	if (getElementValue("IEquipTypeIDs")=="")
	{
		messageShow('alert','error','错误提示','管理类组不能为空!');
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	//alertShow(data)
	//Modify by QW20210430 BUG:QW0103 增加过滤条件保存
	var FilterInfo=getElementValue("FilterInfo");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventory",data,FilterInfo);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function BDelete_Clicked()
{
	messageShow("confirm","","","是否确定删除当前盘点单?","",DeleteInventory,DisConfirmOpt);
}
function DeleteInventory()
{
	if (IRowID=="")
	{
		messageShow('alert','error','错误提示','没有盘点单删除!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", IRowID,1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function DisConfirmOpt()
{
	
}
//Modified By QW20210701 BUG:QW0132 
function BComfirm_Clicked()
{
	//提示是否盘点确认 ,防止双击
	messageShow("confirm","","","是否确认当前盘点单?","",BComfirmData,"");
}
//Modified By QW20210701 BUG:QW0132 
function BComfirmData()
{
	if (IRowID=="")
	{
		messageShow('alert','error','错误提示','没有盘点单确认!');
		return;
	}
	// MZY0128	2673539,2673540		2022-06-23
	if (getElementValue("IStoreLocDR")=="")
	{
		if (getElementValue("OptFlag")==1)
		{
			jQuery("#tInventoryOptionGrid").datagrid({
				url:'dhceq.jquery.csp',
				border:'true',
				singleSelect:true,
				fit:true,
				columns:[[
					{field:'Code',title:'TRowID',width:50,align:'center',hidden:true},
					{field:'Option',title:'选项列表',width:320}
				]],
				data:{
					rows:[
						{Code:'0',TStep:'2',Option:'1. 当前设备列表仅生成一张盘点单'},
						{Code:'-2',Option:'2. 按照当前设备列表的台账科室生成批量盘点单'}
			    	]
				},
			    onSelect: function (rowIndex, rowData) {
				    dataGridSelect(rowData);		//执行选择操作
				    jQuery("#InventoryOptionWin").window('close');	//关闭当前窗口
				}
			});
			jQuery('#InventoryOptionWin').window('open');
			return;
		}
		if (getElementValue("OptFlag")==2)
		{
			jQuery("#tInventoryOptionGrid").datagrid({
				url:'dhceq.jquery.csp',
				border:'true',
				singleSelect:true,
				fit:true,
				columns:[[
					{field:'Code',title:'TRowID',width:50,align:'center',hidden:true},
					{field:'Option',title:'选项列表',width:320}
				]],
				data:{
					rows:[
						{Code:'0',TStep:'2',Option:'1. 当前设备列表仅生成一张盘点单'},
						{Code:'-2',Option:'2. 按照当前设备列表的台账科室生成批量盘点单'},
						{Code:'-1',Option:'3. 按照当前设备列表的一级科室生成批量盘点单'}
			    	]
				},
			    onSelect: function (rowIndex, rowData) {
				    dataGridSelect(rowData);		//执行选择操作
				    jQuery("#InventoryOptionWin").window('close');	//关闭当前窗口
				}
			});
			jQuery('#InventoryOptionWin').window('open');
			return;
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","FreezeInventory",IRowID,getElementValue("FilterInfo"),""); //modified by wy 2022-5-24 WY0100确认盘点单时增加入参
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
// MZY0128	2673539,2673540		2022-06-23
function dataGridSelect(vRowData)
{
	//alert("Code="+vRowData.Code)
	if (vRowData.Code==0)
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","FreezeInventory",IRowID,getElementValue("FilterInfo"),getElementValue("QXType"));	// MZY0130	2816034		2022-07-27
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
		    window.setTimeout(function(){window.location.href=url},50);
		}
		else
	    {
			messageShow('alert','error','错误提示',jsonData.Data);
	    }
	}
	else
	{
		if (getElementValue("IPlan_Name")=="")
		{
			messageShow('alert','error','错误提示',"请填写本次盘点计划名称! 保存后再进行确认操作.");
			return
		}
		var LocDRStr=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetLocDRStr",IRowID,vRowData.Code);
		if (LocDRStr=="")
		{
			messageShow('alert','error','错误提示',"科室设置异常 !");
			return
		}
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","BatchCreateInventory",IRowID,LocDRStr,vRowData.Code,getElementValue("QXType"));	// MZY0130	2816034		2022-07-27
		//alert(jsonData)
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
		    window.setTimeout(function(){window.location.href=url},50);
		}
		else
	    {
			messageShow('alert','error','错误提示',jsonData.Data);
	    }
	}
}
function BSaveList_Clicked()
{
	//保存盘点结果
	var dataList="";
	if (editIndex != undefined){ $('#DHCEQInventoryList').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQInventoryList').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var val="dept=ILActerStoreLoc="+rows[i].ILActerStoreLocDR+"^";
		val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
		list=val.split("^");
		Detail=list[0].split("=");
		if (rows[i].ILActerStoreLoc!=Detail[1])
		{
			rows[i].ILActerStoreLoc="";
			rows[i].ILActerStoreLocDR="";
		}
		if (rows[i].ILStatus==1)
		{
			if (rows[i].ILActerStoreLocDR!=rows[i].ILBillStoreLocDR)
			{
				alertShow("账物一致: 第"+(i+1)+"行【台账库房】和【实际库房】不一致.请修正!");
				return;
			}
		}
		if (rows[i].ILStatus==2)
		{
			if ((rows[i].ILActerStoreLocDR==rows[i].ILBillStoreLocDR)||(rows[i].ILActerStoreLocDR==""))
			{
				alertShow("科室不符: 第"+(i+1)+"行【实际库房】错误.请修正!");
				return;
			}
		}
		if (rows[i].ILStatus==3)
		{
			if (rows[i].ILActerStoreLocDR!="")
			{
				alertShow("盘亏: 第"+(i+1)+"行【实际库房】错误.请修正!");
				return;
			}
		}
		// MZY0049	2020-08-25
		if (rows[i].ILStatus==4)
		{
			if (rows[i].ILActerStoreLocDR!="")
			{
				alertShow("待查找: 第"+(i+1)+"行【实际库房】错误.请修正!");
				return;
			}
		}
		// MZY0057	1506387		2020-10-09		增加参数
		if ((rows[i].ILCondition=="")&&(tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992006")==1))
		{
			// MZY0049	2020-08-25
			if ((rows[i].ILStatus!="")&&(rows[i].ILStatus!=3)&&(rows[i].ILStatus!=4))
			{
				alertShow("完好状态: 第"+(i+1)+"行不能为空.请修正!");
				return;
			}
		}
		if (dataList!="") dataList=dataList+getElementValue("SplitRowCode");
		dataList=dataList+rows[i].ILRowID+"^"+rows[i].ILActerStoreLocDR+"^"+rows[i].ILActerUseLocDR+"^"+rows[i].ILStatus+"^"+rows[i].ILRemark+"^"+rows[i].ILCondition+"^"+rows[i].LIUseStatus+"^"+rows[i].LIPurpose+"^"+rows[i].LILossReasonDR+"^"+rows[i].ILIKeeperDR+"^"+rows[i].ILILocationDR+"^"+rows[i].ILILeaveFactoryNo+"^"+rows[i].ILILocationDR_LDesc;
	}
	//alert(rows.length+":"+dataList)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventoryList", IRowID, dataList);
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href=url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}


function DisConfirmOpt()
{
}

function BLocSubmit_Clicked()
{
	var IARowID=getElementValue("IARowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventory", IARowID,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','提交失败提示',jsonData.Data);
	}
	else
	{
		var ISelfFlag=getElementValue("ISelfFlag");
		var IStoreLocDR=getElementValue("IStoreLocDR");
		var IManageLocDR=getElementValue("IManageLocDR");
		if ((ISelfFlag==true)&&(IStoreLocDR!="")&&(IStoreLocDR!=IManageLocDR))
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", IRowID,2);
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0)
			{
				messageShow("","","","此次盘点完成!")
			    //window.location.reload()
				var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
			    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
					url += "&MWToken="+websys_getMWToken()
				}
			    window.setTimeout(function(){window.location.href=url},50);
			}
			else
		    {
				messageShow('alert','error','盘点完成错误提示',jsonData.Data);
		    }
		}
		else
		{
			//messageShow("","","","此次盘点完成!")
			var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR")+"&IARowID="+IARowID;
			//url= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+InventoryDR+"&ReadOnly="+ReadOnly;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			window.setTimeout(function(){window.location.href=url},50);
		}
	}
}

function BAudit_Clicked()
{
	var UnSubmitNum=getElementValue("UnSubmitNum");
	var UnAuditNum=getElementValue("UnAuditNum");
	var MsgDesc="";
	if (UnSubmitNum>0)
	{
		MsgDesc="有"+UnSubmitNum+"个科室的盘点数据没有提交,"
	}
	if (UnAuditNum>0)
	{
		MsgDesc=MsgDesc+"有"+UnAuditNum+"个科室的盘点数据没有确认,"
	}
	
	var MsgDesc=MsgDesc+"是否确定结束当前盘点单?"
	//提示是否盘点完成
	messageShow("confirm","","",MsgDesc,"",FinishInventory,"");
}

function FinishInventory()
{
	if (IRowID=="")
	{
		messageShow('alert','error','错误提示','盘点单ID为空!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", IRowID,2);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","此次盘点完成!")
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}

/*function BResult_Clicked()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryResult&InventoryDR='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	showWindow(str,"盘点结果","","","icon-w-paper","modal","","","middle");
}*/
function BResultStat_Clicked()
{
	//var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryResultStat&InventoryDR='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	var str='dhceq.em.resultstat.csp?&InventoryDR='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");	// MZY0133	2612992		2022-09-09
	showWindow(str,"结果汇总","","","icon-w-paper","modal","","","middle");
}

function BInventoryAudit_Clicked()
{
	var str='dhceq.em.inventoryaudit.csp?&IRowID='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("IStoreLocDR")+"&ManageLocDR="+getElementValue("IManageLocDR");   //Modified By QW20210416 BUG:QW0097 修正传参错误
	showWindow(str,"科室盘点结果","","","icon-w-paper","modal","","","middle");		// MZY0133	2612992		2022-09-09
}
// MZY0134	2952670		2022-09-20
function BInventoryBatch_Clicked()
{
	var str='dhceq.em.inventorybatch.csp?&IRowID='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	showWindow(str,"未盘设备批量处置","","","icon-w-paper","modal","","","middle",reloadGrid);
}
function BSaveTXT_Clicked()
{
	var locid=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextLoc", IRowID, "");
	if (locid=="")
	{
		messageShow("","","","该盘点单未确认,不允许导出!");
		return;
	}
	try
	{
		var FileName=GetFileNameToTXT();
		var fso = new ActiveXObject("Scripting.FileSystemObject");
    	var f = fso.OpenTextFile(FileName,2,true);	//覆盖写文件
		//写入标题
		f.WriteLine("盘点单号:"+getElementValue("IInventoryNo")+"\t导出日期:"+FormatDate(GetCurrentDate()));
	    var tmpString="序号"+"\t"+"使用科室"+"\t"+"设备名称"+"\t"+"院产编号"+"\t"+"设备类组"+"\t"+"原值"+"\t"+"单位"+"\t"+"数量"+"\t"+"规格型号"+"\t"+"生产厂商"+"\t"+"出厂编号"+"\t"+"供应商"+"\t"+"入库审核日期"+"\t"+"实盘数量"+"\t"+"备注";
	    f.WriteLine(tmpString);
		
		//写入记录
		var row=0;		//序号
		do
		{
			if (locid!="")
			{
				var equipdr="";
				var rowid="";
				var TotalFee=0;
				var Count=0;
				do
				{
					var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextListInfo", IRowID,locid,equipdr,rowid);
					result=result.replace(/\r\n/g,"");
					//alertShow(result)
					if (result=="")
					{
						equipdr="";
						rowid="";
					}
					else
					{
						var list=result.split("^");
						equipdr=list[0];
						rowid=list[1];
						row=row+1;
						//NewEquipDR,NewRowID,Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace,CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider
						tmpString=row+"\t"+list[8]+"\t"+list[2]+"\t"+list[5]+"\t"+list[19]+"\t"+list[11]+"\t"+list[6]+"\t"+1+"\t"+list[3]+"\t"+list[4]+"\t"+list[20]+"\t"+list[21]+"\t"+FormatDate(list[18]);
						f.WriteLine(tmpString);
						TotalFee=TotalFee+parseFloat(list[11]);
						Count=Count+1;
					}
				} while(rowid!="")
				f.WriteLine("小计"+"\t\t\t\t\t"+TotalFee+"\t\t"+Count);
			}
			locid=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextLoc", IRowID, locid);
		} while(locid!="")
		f.Close();
		messageShow("","","","操作完成!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}
function BBarCodePrint_Clicked()
{
	var Status=getElementValue("IAStatusDR");
	if ((Status=="")||(Status=0))
	{
		messageShow('alert','error','错误提示','未确认盘点单不能打印条码!');
		return
	}
	// MZY0092	2127012		2021-08-27
	messageShow("confirm","info","提示","依次打印本盘点单全部无'实际库房'的设备条码,是否继续?","",function(){
					confirmPrintBar();
				},function(){
				return;
			},"继续","取消");
}
// MZY0092	2127012		2021-08-27
function confirmPrintBar()
{
	var Strs="";
	do
	{
		Strs=tkMakeServerCall("web.DHCEQSPrint","GetEquipBarInfo",IRowID+"^"+Strs,"Inventory");
		if (Strs!="")
		{
			printBars(Strs, 0);
		}
	} while (Strs!="")
}
function GetStatus(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILStatus=data.TRowID;
	//rowData.ILStatus_Display=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILStatus_Display'});
	$(editor.target).combogrid("setValue",data.TDesc);
	if (data.TRowID==1)
	{
		// 账物一致
		//alert(rowData.ILBillStoreLoc)
		rowData.ILActerStoreLocDR=rowData.ILBillStoreLocDR;
		editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
		$(editor.target).combogrid("setValue",rowData.ILBillStoreLoc);
	}else{ //Add By QW20210416 BUG:QW0097 修改状态则清空
		editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
		$(editor.target).combogrid("setValue","");
	}
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLoc(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILActerStoreLocDR=data.TRowID;
	//rowData.ILActerStoreLoc=data.TName;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetCondition(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILCondition=data.TRowID;
	//rowData.ILCondition_Display=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILCondition_Display'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function BPrtInventory_Clicked()
{
	// MZY0128	2673539,2673540		2022-06-23
	var Status=getElementValue("IAStatusDR");
	if ((Status=="")||(Status=0))
	{
		messageShow('alert','error','错误提示','未确认盘点单不能打印!');
		return
	}
	var StoreLocDR=getElementValue("StoreLocDR");
	var PrintLocDR=getElementValue("PrintLocDR");
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "990062");			//打印方式标志位 excel：0  润乾:1
	var PreviewRptFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "990075");		//润乾预览标志 不预览 :0  预览 :1
	var HOSPDESC=tkMakeServerCall("web.DHCEQCommon","GetHospitalDesc");
	var filename = "";
	//alert("BPrtInventory_Clicked:"+PrintFlag+PreviewRptFlag+HOSPDESC);
	
	//Excel打印方式
	if(PrintFlag==0)
	{
		PrintInventory();
	}
	//润乾打印
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{
			// MZY0058	1468106		2020-10-18
		    fileName="{DHCEQInventoryPrint.raq(InventoryDR="+IRowID+";StoreLocDR="+StoreLocDR+";PrintLocDR="+PrintLocDR
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+curUserName
		    +")}";
		    //alert(fileName)
	        DHCCPM_RQDirectPrint(fileName);
		}
		
		if(PreviewRptFlag==1)
		{
			// MZY0058	1468106		2020-10-18
			fileName="DHCEQInventoryPrint.raq&InventoryDR="+IRowID+"&StoreLocDR="+StoreLocDR+"&PrintLocDR="+PrintLocDR
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+curUserName
			DHCCPM_RQPrint(fileName);
		}
	}
}
function PrintInventory()
{	
	var result;
	var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	var Template=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQInventoryLoc.xls";
	if (locid!="")
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var locid=getElementValue("PrintLocDR");
	if (locid!="")
	{
		result=PrintOneLoc(locid,xlsheet);
		if (result>0) xlsheet.printout; //打印输出
	}
	else
	{
		do
		{
			var locid=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextLoc",IRowID,locid);
			if (locid!="")
			{
				result=PrintOneLoc(locid,xlsheet);
				if (result>0) 
				{
					xlsheet.printout; //打印输出
					if (result>1)
					{
						var rows=result+3;
						var rows="5:"+rows
						xlsheet.Rows(rows).Delete();
					}
					xlsheet.Rows(4).ClearContents()
				}
			}
		} while(locid!="")
	}
	xlBook.Close (savechanges=false);
	xlsheet.Quit;
	xlsheet=null;
	xlApp=null;
}
function PrintOneLoc(locid,xlsheet)
{
	var equipdr,rowid;
	var row;
	var result;
	if (locid=="") return 0;
	if (""==IRowID) return 0;
	var InventoryNo=getElementValue("InventoryNo");	
	var curDate=GetCurrentDate();
	var username=curUserName;
	var loc="";
	
	row=0;
	equipdr="";
	rowid="";
	do
	{
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextListInfo",IRowID,locid,equipdr,rowid);
		if (result=="")
		{
			equipdr="";
			rowid="";
		}
		else
		{
			var list=result.split("^");
			equipdr=list[0];
			rowid=list[1];
			row=row+1;
			xlsheet.Rows(row+3).Insert();
			//NewEquipDR_"^"_NewRowID_"^"_Name_"^"_Model_"^"_Manufactory_"^"_No_"^"_Unit_"^"_EquipCat_"^"_StoreLoc_"^"_UseLocDR_"^"_UseLoc_"^"_OriginalFee_"^"_Origin_"^"_StorePlace_"^"_CheckDate_"^"_OpenCheckDate_"^"_Country_"^"_ManageUser_"^"_InDate_"^"_EquipType_"^"_LeaveFactoryNo_"^"_Provider
			//alert(result)
			xlsheet.cells(row+3,2)=list[8];
			xlsheet.cells(row+3,3)=list[5];	//No
			xlsheet.cells(row+3,4)=list[2];	//Name
			xlsheet.cells(row+3,5)=list[3];	//Model
			//xlsheet.cells(row+3,5)=list[6];	//Unit
			xlsheet.cells(row+3,6)=list[11];	//OriginalFee
			//xlsheet.cells(row+3,7)=FormatDate(list[18]);	//InDate
			if (""==loc) loc=list[8];	//StoreLoc
		}
	} while(rowid!="")
	if (0==row) return 0;
	xlsheet.cells(2,3)=loc;
	xlsheet.cells(2,7)=InventoryNo;
	var delRow=row+4;
	xlsheet.Rows(delRow).Delete();
	xlsheet.cells(row+4,3)=FormatDate(curDate);
	xlsheet.cells(row+4,7)=username;
	
	return row;	
}
function BSaveException_Clicked()
{
	//alert("IListInfoClickHandler:"+rowData.ILRowID)
	var url= 'dhceq.em.inventoryexception.csp?&InventoryDR='+IRowID+'&InventoryNo='+getElementValue("IInventoryNo")+'&ReadOnly='+getElementValue("ReadOnly");
	showWindow(url,"盘盈设备信息","","","icon-w-paper","modal","","","large");
}
function BInventoryPlan_Clicked()
{
	//alert("BInventoryPlan_Clicked:"+rowData.ILRowID)
	var url= 'dhceq.em.inventoryplanmanage.csp?&InventoryDR='+IRowID+'&InventoryPlanDR=&ReadOnly='+getElementValue("ReadOnly");
	showWindow(url,"盘点计划","","","icon-w-paper","modal","","","large");
}
function setElementEnabled()
{
	//var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	//if(Rtn=="1") disableElement("CTContractNo",true);
}

function BInventoryResult_Clicked()
{
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("盘点结果");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var InventoryNo=trim(xlsheet.cells(Row,Col++).text);
		var EquipNo=trim(xlsheet.cells(Row,Col++).text);
		var EquipName=trim(xlsheet.cells(Row,Col++).text);
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		if (InventoryNo=="")
		{
		    alertShow("盘点单号不能为空!");
		    return 0;
		}
		if (EquipNo=="")
		{
		    alertShow("台帐设备编号不能为空!");
		    return 0;
		}
		if (EquipName=="")
		{
		    alertShow("台帐设备名称不能为空!");
		    return 0;
		}
		if (UseLoc=="")
		{
		    alertShow("实际使用科室不能为空!");
		    return 0;
		}
		else
		{
			var UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("第"+Row+"行 实际使用科室的信息不正确:"+UseLoc);
				return 0;
			}
		}
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpLoadInventoryResult", "", UseLocDR, "", "", EquipNo, EquipName, "", "", "", "", InventoryNo);
		if (result!=0) alertShow("第 "+Row+" 行 <"+xlsheet.cells(Row,2).text+"> 信息导入失败!!!请核对该行信息.");;
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	alertShow("导入盘点信息操作完成!");
	window.location.reload();
}

//Modify by QW20210430 BUG:QW0103 过滤条件点击时间
function BFilterInfo_Clicked()
{
	var InventoryDR=getElementValue("IRowID");
	var FilterInfo=getElementValue("FilterInfo");
	var url="dhceq.em.inventoryfilterinfo.csp?InventoryDR="+InventoryDR+"&FilterInfo="+FilterInfo;
	showWindow(url,"筛选条件",500,400,"icon-w-paper","modal","","","",setFilterInfo); 
}
//Modify by QW20210430 BUG:QW0103 子窗口筛选条件赋值
function setFilterInfo(value)
{
	setElement("FilterInfo",value)
}
/* MZY0133	2612992		2022-09-09	取消
function InitRadio()
{
    $HUI.radio("[name='wantEat']",{
        onChecked:function(e,value){
            //logger.info($(e.target).attr("label"));  //输出当前选中的label值
			if ($(e.target).attr("value")=="consistentflag") {
				BConsistentflag_Clicked();
			} else if ($(e.target).attr("value")=="unconsistentflag") {
				BUnConsistentflag_Clicked();
			} else if ($(e.target).attr("value")=="uncheckflag") {
				BUnCheck_Clicked();
			} else if ($(e.target).attr("value")=="unchecklocflag") {
				BUnCheckLocflag_Clicked();
			} else if ($(e.target).attr("value")=="unfindflag") {
				BUnFindFlag_Clicked();
			} else if ($(e.target).attr("value")=="findflag") {
				BFindFlag_Clicked();
			} else {
				BAll_Clicked();
			}
        }
    });
}*/
// MZY0133	2612992		2022-09-09
function initFilterKeyWords()
{
	 $("#FilterKeyWords").keywords({
        singleSelect:true,
        onClick:function(v){},
        onUnselect:function(v){
	    },
        onSelect:function(v){
	        var selectItemID=v.id;
			if (selectItemID=="allflag")
			{
				DisplayFlag="allflag";
			}
			else if(selectItemID=="consistentflag")
			{
				DisplayFlag="consistentflag";
			}
			else if (selectItemID=="unconsistentflag")
			{
				DisplayFlag="unconsistentflag";
			}
			else if (selectItemID=="uncheckflag")
			{
				DisplayFlag="uncheckflag";
			}
			else if (selectItemID=="unchecklocflag")
			{
				DisplayFlag="unchecklocflag";
			}
			else if (selectItemID=="unfindflag")
			{
				DisplayFlag="unfindflag";
			}
			else if (selectItemID=="findflag")
			{
				DisplayFlag="findflag";
			}
			BFind_Clicked();
	    },
        labelCls:'blue',
        items:[
            {text:'全部设备'+'<span class="eq-resourcenum" id="AllNum"></span>',id:'allflag'},
            {text:'账物一致'+'<span class="eq-resourcenum" id="ConsistentNum"></span>',id:'consistentflag'},
            {text:'账物不一致'+'<span class="eq-resourcenum" id="UnConsistentNum"></span>',id:'unconsistentflag'},
            {text:'未盘'+'<span class="eq-resourcenum" id="UnCheckNum"></span>',id:'uncheckflag',selected:true},
            {text:'科室不符'+'<span class="eq-resourcenum" id="UnCheckLocNum"></span>',id:'unchecklocflag'},
            {text:'盘亏'+'<span class="eq-resourcenum" id="UnFindNum"></span>',id:'unfindflag'},
            {text:'待查找'+'<span class="eq-resourcenum" id="FindNum"></span>',id:'findflag'}
        ]
    });
}
// MZY0134	2952670		2022-09-20
function reloadGrid()
{
	fillData();
	BFind_Clicked();
	//window.location.reload();		禁止全刷
}
function GetLocation(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILILocationDR=data.TRowID;
	//rowData.ILILocationDR_LDesc=data.TName;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILILocationDR_LDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetKeeper(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILIKeeperDR=data.TRowID;
	//rowData.ILIKeeperDR_SSUSRName=data.TName;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILIKeeperDR_SSUSRName'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLossReason(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.LILossReasonDR=data.TRowID;
	//rowData.LILossReasonDR_LRDesc=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LILossReasonDR_LRDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetUseStatus(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.LIUseStatus=data.TRowID;
	//rowData.LIUseStatus_USDesc=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LIUseStatus_USDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetPurpose(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.LIPurpose=data.TRowID;
	//rowData.LILossReasonDR_LRDesc=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LIPurpose_PDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
