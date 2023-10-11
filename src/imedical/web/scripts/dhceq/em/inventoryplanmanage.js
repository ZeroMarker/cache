var ListColumns=getCurColumnsInfo('EM.G.Inventory.InventoryList','','','');
var PlanListColumns=getCurColumnsInfo('EM.G.Inventory.InventoryPlanList','','','');
var LastDealColumns=getCurColumnsInfo('EM.G.Inventory.InventoryPlanList','','','');  //Modefied by zc0125 2022-12-12 增加最终处理列定义
var PlanSummaryColumns=getCurColumnsInfo('EM.G.Inventory.InventoryPlanSummary','','','');
var AuditColumns=getCurColumnsInfo('EM.G.Inventory.InventoryAudit','','','')
var editIndex=undefined;
var DisplayFlag="uncheckflag";
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	//InitEvent();
	initUserInfo();
	initInfoShow();
	initResultShow();
	initLookUp();			//初始化放大镜
	initEquipType();		//初始化管理类组
	initPlanEquipType();		// MZY0137	2981128		2022-10-08
	initDisposeStatus();
	initFilterResult();
	
	initInventoryList();
	initInventoryPlanList();
	initInventoryLastDeal();  //Modefied by zc0125 2022-12-12  增加最终处理
	initInventoryResult();
	initInventoryAudit();
	initTabs();
	// MZY0148	3160393,3160394		2023-1-3
	if ((typeof(HISUIStyleCode)!="undefined")&&(HISUIStyleCode=="lite"))   //add by zc0128 2023-02-08 修正页面不显示
	{
		jQuery("#inv-TotalNum").attr("style","background-color:rgb(248,248,248)");
		//jQuery("#inv-TotalNum").attr("style","border-top:solid 1px #E2E2E2");
		jQuery("#inv-vTotalNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#TotalNum").attr("style","color:rgba(31, 220, 151, 1)");
		jQuery("#inv-pTotalNum").attr("style","color:#000000");
		document.getElementById("inv-TotalNum").style.backgroundImage="url('../images/dhceq/eq-inv-planequipnumnew-b.svg')";	// MZY0151	2023-02-01
		
		jQuery("#inv-NotInventoryNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#inv-vNotInventoryNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#NotInventoryNum").attr("style","color:rgba(150, 92, 213, 1)");
		jQuery("#inv-pNotInventoryNum").attr("style","color:#000000");
		document.getElementById("inv-NotInventoryNum").style.backgroundImage="url('../images/dhceq/eq-inv-plannotinventorynew-b.svg')";	// MZY0151	2023-02-01
		
		jQuery("#inv-InventoryNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#inv-vInventoryNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#InventoryNum").attr("style","color:rgba(255, 197, 20, 1)");
		jQuery("#inv-pInventoryNum").attr("style","color:#000000");
		document.getElementById("inv-InventoryNum").style.backgroundImage="url('../images/dhceq/eq-inv-planinventorynumnew-b.svg')";	// MZY0151	2023-02-01
		
		jQuery("#inv-InventoryLocNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#inv-vInventoryLocNum").attr("style","background-color:rgb(248,248,248)");
		jQuery("#InventoryLocNum").attr("style","color:rgba(55, 161, 240, 1)");
		jQuery("#inv-pInventoryLocNum").attr("style","color:#000000");
		document.getElementById("inv-InventoryLocNum").style.backgroundImage="url('../images/dhceq/eq-inv-planinvlocnumnew-b.svg')";	// MZY0151	2023-02-01
	}
	else
	{
		jQuery("#sumTotal").attr("style","position:absolute;right:5px;top:0px");
	}
	$("#InventoryPlanBanner").attr("src",'dhceq.plat.inventoryplanbanner.csp?&InventoryPlanDR='+getElementValue("InventoryPlanDR")+"&InventoryDR="+getElementValue("InventoryDR"));
}

function initInfoShow()
{
	var InfoList=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetInventoryInfo",getElementValue("InventoryPlanDR"),getElementValue("InventoryDR"))
	InfoList=InfoList.replace(/\\n/g,"\n");
	var totalInfo=InfoList.split("^");
	//alert(InfoList)
	/*	MZY0148	3160393,3160394		2023-1-3
	$("#PLabel").html(totalInfo[0]);
	$("#PCaption").html(totalInfo[1]);
	$("#ExpectDate").html(totalInfo[2]);
	$("#ManageLoc").html(totalInfo[3]);
	$("#HOSP").html(totalInfo[4]);
	if (totalInfo[5]==totalInfo[17])
	{
		$("#EquipTypeDesc").html(totalInfo[5]);
		$("#EquipTypeTitle").remove();
	}
	else
	{
		$("#EquipTypeTitle").html(totalInfo[5]);
		$HUI.tooltip("#EquipTypeTitle",{position:"bottom",tipWidth:"400",content:totalInfo[17]})
		//$("#EquipTypeTitle").popover({title:'管理类组：',content:tt});
	}
	$("#FreezeDate").html(totalInfo[6]);*/
	$("#InventoryNum").html(totalInfo[7]);
	$("#InventoryLocNum").html(totalInfo[8]);
	$("#TotalNum").html(totalInfo[9]);
	$("#NotInventoryNum").html(totalInfo[10]);
}
function initResultShow()
{
	var InfoList=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetInventoryInfo",getElementValue("InventoryPlanDR"),getElementValue("InventoryDR"))
	InfoList=InfoList.replace(/\\n/g,"\n");
	var totalInfo=InfoList.split("^");
	//alert(InfoList)
	$("#TTotalNum").html(totalInfo[9]);
	$("#TNotInventoryNum").html(totalInfo[10]);
	$("#TConsistentNum").html(totalInfo[11]);
	$("#TUnCheckLocNum").html(totalInfo[12]);
	$("#TDisUseNum").html(totalInfo[13]);
	$("#TLoseNum").html(totalInfo[14]);
	$("#TFindNum").html(totalInfo[15]);
	$("#TProfitNum").html(totalInfo[16]);
}
function initEquipType()
{
	$HUI.combogrid('#EquipType',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    //rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //placeholder:"管理类组",
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'类组',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]
	});
}
// MZY0137	2981128		2022-10-08
function initPlanEquipType()
{
	$HUI.combogrid('#PlanEquipType',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    //rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //placeholder:"管理类组",
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'类组',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]
	});
}
function initDisposeStatus()
{
	$HUI.combogrid('#DisposeStatus',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSInventory",
	        QueryName:"GetDisposeStatus"
	    },
	    idField:'TRowID',
		textField:'TDesc',
	    //multiple: true,
	    //rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //placeholder:"处理状态",
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	//{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TDesc',title:'状态',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]
	});
}
function initFilterResult()
{
	var FilterResult = $HUI.combobox('#FilterResult',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '0',text: '按盘点状态汇总',selected:true},{id: '1',text: '按处理状态汇总'}],		// ,{id: '2',text: '按处理结果汇总'}
			onSelect : function(index){
				//alert(index.id)
				setElement("FilterType",index.id);
				initInventoryResult();
			}
		});
}
function initInventoryList()
{
	var vtoolbar=Inittoolbar();   ///Modefied by zc0124 2022-11-03 toolbar元素根据条件显示
	$HUI.datagrid("#tDHCEQInventoryList",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryList",
		        InventoryPlanDR:getElementValue("InventoryPlanDR"),
				InventoryDR:getElementValue("InventoryDR"),
		    	StoreLocDR:getElementValue("StoreLocDR"),			//管理科室
		    	IStoreLocDR:getElementValue("BillStoreLocDR"),		//账面科室
		    	EquipTypeIDs:getElementValue("EquipTypeIDs"),
		    	StatCatDR:getElementValue("IStatCatDR"),
		    	OriginDR:getElementValue("IOriginDR"),
		    	onlyShowDiff:getElementValue("onlyShowDiff"),
		    	FilterInfo:getElementValue("FilterInfo"),
		    	ManageLocDR:getElementValue("IManageLocDR"),
		    	QXType:getElementValue("QXType"),
		    	//StatusDR:StatusDR,
		    	HospitalDR:getElementValue("IHospitalDR"),
		    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
		    	DisplayFlag:DisplayFlag
		},
		rownumbers:true,  		//如果为true则显示行号列
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:ListColumns,
		// MZY0148	3160393,3160394		2023-1-3	删除toolbar
		toolbar:vtoolbar, 
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,100],
		onLoadSuccess:function(){
			creatToolbar();
			$("#"+DisplayFlag).css("color", "#FF0000");
			//$("#"+DisplayFlag).css("background-color", "#40A2DE");
			var rowData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneInventory",getElementValue("InventoryDR"),session['LOGON.CTLOCID']);	//curLocID
			var jsonData=JSON.parse(rowData)
			if (jsonData.Data.IARowID==undefined)
			{
				setElement("IARowID","");
			}
			else
			{
				setElement("IARowID",jsonData.Data.IARowID);
			}
			setElement("UnSubmitNum",jsonData.Data.UnSubmitNum);
			setElement("UnAuditNum",jsonData.Data.UnAuditNum);
			//alert(getElementValue("IARowID"))
			// 设置隐藏列
			//$("#tDHCEQInventoryList").datagrid("hideColumn", "IListInfo");		//结果  //add by zc0128 2023-02-08 设备信息调整放开
		}
	});
}
function initInventoryPlanList()
{
	// MZY0148	3160393,3160394		2023-1-3
	$("#kwStatus").keywords({
        //onClick:function(v){alert("点击->"+v.text)},
        //onUnselect:function(v){alert("取消选择->"+v.text);},
		singleSelect:true,
        items:[{
                text:"",    /*无段落*/ 
                //type:"chapter",
                type:"section",
                items:[
                    {text:"全部设备"},
                    {text:"账物一致"},
					{text:"科室差异"},
					{text:"报废中"},
					{text:"盘亏"},
					{text:"待查找"},
					{text:"未盘点"}
                ]
        }],
		onSelect:function(v){
			if (v.text=="全部设备")
			{
				BAll_Clicked();
			}
			else if (v.text=="账物一致")
			{
				BConsistentflag_Clicked();
			}
			else if (v.text=="科室差异")
			{
				BUnCheckLoc_Clicked();
			}
			else if (v.text=="报废中")
			{
				BDisUse_Clicked();
			}
			else if (v.text=="盘亏")
			{
				BLose_Clicked();
			}
			else if (v.text=="待查找")
			{
				BFind_Clicked();
			}
			else
			{
				BNotInventory_Clicked();	//未盘点
			}
		}
    });
	
	setElement("EquipTypeIDs",$("#PlanEquipType").combogrid("getValues"));		// MZY0137	2981128,2981133		2022-10-08
	setElement("DisposeStatusDR",$("#DisposeStatus").combogrid("getValues"));
	$HUI.datagrid("#tDHCEQInventoryPlanList",{
		url:$URL,
	    queryParams:{
		    ClassName:"web.DHCEQ.EM.BUSInventory",
	        QueryName:"GetIPlanList",
			pInventoryPlanDR:getElementValue("InventoryPlanDR"),
			pInventoryDR:getElementValue("InventoryDR"),
			pEquipTypeIDs:getElementValue("EquipTypeIDs"),
			pStoreLocDR:getElementValue("BillStoreLocDR"),
			pStatus:getElementValue("Status"),
			pDisposeStatus:getElementValue("DisposeStatusDR"),
			pEQNo:getElementValue("EQNo"),	// MZY0137	2981128,2981133		2022-10-08
			pEQName:getElementValue("EQName")
		},
		// MZY0148	3160393,3160394		2023-1-3
		toolbar:[{
    			iconCls: 'icon-paper-link',
                text:'盘盈处置',  
				id:'OptException',        
                handler: function(){
                     OptException_Clicked();
                }},
                {
                iconCls: 'icon-paper-table',
                text:'盘点状态明细',
				id:'TFilterType1',
                handler: function(){
                     BListExport1_Clicked();
                }},
                {
                iconCls: 'icon-paper-table',
                text:'处理状态明细',
				id:'TFilterType2',
                handler: function(){
                     BListExport2_Clicked();
                }},
				{
                iconCls: 'icon-paper-table',
                text:'盘点状态盘亏',
				id:'TFilterType3',
                handler: function(){
                     FilterType3_Clicked();
                }},
				{
                iconCls: 'icon-paper-table',
                text:'处理状态盘亏',
				id:'TFilterType4',
                handler: function(){
                     FilterType4_Clicked();
                }}
        ],
		rownumbers:false,  		//如果为true则显示行号列
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:PlanListColumns,
	    pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,100],
		onLoadSuccess:function(){
		$("#tDHCEQInventoryPlanList").datagrid("hideColumn", "ILBDisuseRequest");  //Modefied by zc0125 2022-12-12 列影藏 begin
		$("#tDHCEQInventoryPlanList").datagrid("hideColumn", "BussDetail");
		$("#tDHCEQInventoryPlanList").datagrid("hideColumn", "TDisposeResult");    //Modefied by zc0125 2022-12-12 列影藏 end
		var trs = $(this).prev().find('div.datagrid-body').find('tr');
	    for(var i=0;i<trs.length;i++)
		for(var j=1;j<trs[i].cells.length;j++){
			var row_html = trs[i].cells[j];
			var cell_field=$(row_html).attr('field');
			var cell_value=$(row_html).find('div').html();
			$('#ILBArgeez'+i).remove();   //Modefied by zc0125 2022-12-12 按钮影藏 begin
			$('#ILBStoreMvoez'+i).remove();
			$('#ILBNoDealz'+i).remove();
			$('#ILBReducez'+i).remove();
			$('#ILBDisuseRequestz'+i).remove();
			$('#BussDetailz'+i).remove();   //Modefied by zc0125 2022-12-12 按钮影藏 end
			if(cell_field == 'TDisposeStatus')
			{
				if(cell_value == "盘亏")
				{
					$('#ToLossz'+i).remove();
				}
				if(cell_value == "账物一致")
				{
					$('#ToConsistentz'+i).remove();
				}
				if(cell_value == "科室不符")
				{
					$('#ToUnCheckLocz'+i).remove();
				}
				if(cell_value == "有报废单")
				{
					$('#ToDisUsez'+i).remove();
				}
			}
			if (cell_field == 'TStatus_Display')
			{
				if((cell_value != "盘亏")&&(cell_value != "有报废单"))
				{
					$('#ToConsistentz'+i).remove();
					$('#ToLossz'+i).remove();
					$('#ToUnCheckLocz'+i).remove();
					$('#ToDisUsez'+i).remove();
				}
			}
			//Modefied by zc0125 2022-12-12 按钮影藏 begin
			if (cell_field == 'TActerStoreLocDR')
			{
				if((cell_value == ""))
				{
					$('#ToUnCheckLocz'+i).remove();
				}
			}
			if (cell_field == 'ILDisposeResultID')
			{
				if(cell_value != "")
				{
					$('#ToConsistentz'+i).remove();
					$('#ToLossz'+i).remove();
					$('#ToUnCheckLocz'+i).remove();
					$('#ToDisUsez'+i).remove();
				}
			}
			//Modefied by zc0125 2022-12-12 按钮影藏 end
		  }
	    }
	});
	//Modefied by zc0126 2022-12-26 权限控制 begin
	if (getElementValue("ReadOnly")=="1")
	{
		$("#tDHCEQInventoryPlanList").datagrid("hideColumn", "ToLoss");
	}
	//Modefied by zc0126 2022-12-26 权限控制 
}
function initInventoryResult()
{
	setElement("EquipTypeIDs",$("#EquipType").combogrid("getValues"));
	$HUI.datagrid("#tDHCEQInventoryResult",{
		url:$URL,
	    queryParams:{
		    ClassName:"web.DHCEQ.EM.BUSInventory",
	        QueryName:"GetIPlanSummary",
			pInventoryPlanDR:getElementValue("InventoryPlanDR"),
			pInventoryDR:getElementValue("InventoryDR"),
			pFilterType:getElementValue("FilterType")
		},
		rownumbers:false,  		//如果为true则显示行号列
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:PlanSummaryColumns,
	    pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow : function (rowIndex, rowData)
    	{
        	InventoryResultDataGrid_OnClickRow(rowIndex, rowData);
    	}
	});
}
function initInventoryAudit()
{
	var atoolbar=InitAudittoolbar();   ///Modefied by zc0125 2022-12-20 toolbar元素根据条件显示
	$HUI.datagrid("#tDHCEQInventoryAudit",{
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryAudit",
				InventoryDR:getElementValue("InventoryDR"),
				StoreLocDR:getElementValue("StoreLocDR")
			},
			rownumbers: true,  //如果为true则显示一个行号列
			singleSelect:true,
			fit:true,
			border:false,
			columns:AuditColumns,
			toolbar:atoolbar,
			pagination:true,
			pageSize:15,
			pageNumber:1,
			pageList:[15,30,45,60],
			onLoadSuccess:function(){
				if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992008")!=1) $("#tDHCEQInventoryAudit").datagrid("hideColumn", "IAProfitNum");
				/*var rows = $('#tDHCEQInventoryAudit').datagrid('getRows');
			    for (var i = 0; i < rows.length; i++)
			    {
				    if (rows[i].IAStatus=="0")
				    {
					    $("#tDHCEQInventoryAudit").datagrid("hideColumn", "BSubmit");
					    $("#tDHCEQInventoryAudit").datagrid("hideColumn", "BCancel");
					}
			    }*/
			}
	});
	//modify by mwz 20230106 mwz0067
	var IStatus = $HUI.combobox('#IStatus',{
	valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '新增'
			},{
				id: '1',
				text: '盘点科室提交'
			},{
				id: '2',
				text: '管理科室确认'
			}]
	});  ///0:"新增",1:"盘点科室提交",2:"管理科室确认")
}
function initTabs()
{
	var DisposeType=getElementValue("DisposeType")
	if(DisposeType=="1"){
		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点").panel('options').tab;
		tab_option.hide();	//隐藏页签

		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点处理").panel('options').tab;
		//tab_option.hide();	//隐藏页签
	
		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点最终处理").panel('options').tab;
		tab_option.hide();	//隐藏页签
	
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点单汇总").panel('options').tab;
		//tab_option.hide();	//隐藏页签
	
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点科室汇总").panel('options').tab;	 MZY0148	3160393,3160394		2023-1-3
		//tab_option.hide();	//隐藏页签
	
		$('#tt-brand-gray').tabs('select', 1);		// 页签从0开始
	}else if(DisposeType=="0"){
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点").panel('options').tab;
		//tab_option.hide();	//隐藏页签

		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点处理").panel('options').tab;
		tab_option.hide();	//隐藏页签
	
		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点最终处理").panel('options').tab;
		tab_option.hide();	//隐藏页签
		//add by zc0128 2023-02-08 结果录入只需保留盘点页签 begin
		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点单汇总").panel('options').tab;
		tab_option.hide();	//隐藏页签
		//add by zc0128 2023-02-08 结果录入只需保留盘点页签 end
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点科室汇总").panel('options').tab;	 MZY0148	3160393,3160394		2023-1-3
		//tab_option.hide();	//隐藏页签
	
		$('#tt-brand-gray').tabs('select', 0);		// 页签从0开始
	}else if(DisposeType=="2"){
		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点").panel('options').tab;
		tab_option.hide();	//隐藏页签

		var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点处理").panel('options').tab;
		tab_option.hide();	//隐藏页签
	
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点最终处理").panel('options').tab;
		//tab_option.hide();	//隐藏页签
	
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点单汇总").panel('options').tab;
		//tab_option.hide();	//隐藏页签
	
		//var tab_option = $('#tt-brand-gray').tabs('getTab',"盘点科室汇总").panel('options').tab;	 MZY0148	3160393,3160394		2023-1-3
		//tab_option.hide();	//隐藏页签
	
		$('#tt-brand-gray').tabs('select', 2);		// 页签从0开始
	}
	
}
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	if(elementID=="BillStoreLocDR_CTLOCDesc") {setElement("BillStoreLocDR",rowData.TRowID)}
	//else if(elementID=="IManageLocDR_CTLOCDesc") {setElement("IManageLocDR",rowData.TRowID)}
	else if(elementID=="BillStoreLoc") {setElement("BillStoreLocDR",rowData.TRowID)}   //Modefied by zc0124 2022-11-03 选中盘点科室赋值
	else if(elementID=="IStoreLoc") {setElement("IStoreLocDR",rowData.TRowID)}
}
// 盘盈处置
function OptException_Clicked()
{
	BSetClickDivStyle("TProfitNum");
	var str='dhceq.em.inventoryexceptionnew.csp?&StatusDR='+""+"&InventoryDR="+getElementValue("InventoryDR")+"&QXType="+getElementValue("QXType")+"&InventoryPlanDR="+getElementValue("InventoryPlanDR")+"&ReadOnly="+getElementValue("ReadOnly")+"&DisposeType="+getElementValue("DisposeType");  //add by zc0128 增加入参DisposeType
	//Modefied by zc0125 2022-12-12 调整盘盈页面弹出 begin
	//showWindow(str,"盘盈处理","1920","1080","icon-w-paper","modal","","","small");
	showWindow(str,"盘盈处理","","","icon-w-paper","modal","","","verylarge",ProfitNum_Change);    //Modefied by zc0126 2022-12-26 调整盘盈数量变化取值
	//Modefied by zc0125 2022-12-12 调整盘盈页面弹出 end
}
//Modefied by zc0126 2022-12-26 调整盘盈数量变化取值 begin
function ProfitNum_Change()
{
	initResultShow()
}
//Modefied by zc0126 2022-12-26 调整盘盈数量变化取值 end
function BListFind_Clicked()
{
	//setElement("Status","");
	setElement("EquipTypeIDs",$("#EquipType").combogrid("getValues"));
	initInventoryList();
}
function BAll_Clicked()
{
	BSetClickDivStyle("TTotalNum");
	$("#StatusDesc").text("全部设备");
	setElement("Status","");
	initInventoryPlanList();
}
function BConsistentflag_Clicked()
{
	BSetClickDivStyle("TConsistentNum");
	$("#StatusDesc").text("账物一致");
	setElement("Status",1)
	initInventoryPlanList();
}
function BUnCheckLoc_Clicked()
{
	BSetClickDivStyle("TUnCheckLocNum");
	$("#StatusDesc").text("科室差异");
	setElement("Status",2);
	initInventoryPlanList();
}
function BLose_Clicked()
{
	BSetClickDivStyle("TLoseNum");
	$("#StatusDesc").text("盘亏");
	setElement("Status",3);
	initInventoryPlanList();
}
function BFind_Clicked()
{
	BSetClickDivStyle("TFindNum");
	$("#StatusDesc").text("待查找");
	setElement("Status",4);
	initInventoryPlanList();
}
function BDisUse_Clicked()
{
	BSetClickDivStyle("TDisUseNum");
	$("#StatusDesc").text("报废中");
	setElement("Status",5);
	initInventoryPlanList();
}
function BNotInventory_Clicked()
{
	BSetClickDivStyle("TNotInventoryNum");
	$("#StatusDesc").text("未盘点");
	setElement("Status",0);
	initInventoryPlanList();
}
function BListExport1_Clicked()
{
	BSetClickDivStyle("TFilterType1");
	var fileName="DHCEQInventoryListExport.raq&DisplayType=0&InventoryPlanDR="+getElementValue("InventoryPlanDR")+"&InventoryDR="+getElementValue("InventoryDR");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BListExport2_Clicked()
{
	BSetClickDivStyle("TFilterType2");
	var fileName="DHCEQInventoryListExport.raq&DisplayType=1&InventoryPlanDR="+getElementValue("InventoryPlanDR")+"&InventoryDR="+getElementValue("InventoryDR");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function FilterType3_Clicked()
{
	BSetClickDivStyle("TFilterType3");
	var fileName="DHCEQInventoryLossListExport.raq&DisplayType=0&InventoryPlanDR="+getElementValue("InventoryPlanDR")+"&InventoryDR="+getElementValue("InventoryDR")+"&ILStatus=3";  // Modefied by zc0132 2023-03-13 盘亏数据过滤
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function FilterType4_Clicked()
{
	BSetClickDivStyle("TFilterType4");
	var fileName="DHCEQInventoryLossListExport.raq&DisplayType=1&InventoryPlanDR="+getElementValue("InventoryPlanDR")+"&InventoryDR="+getElementValue("InventoryDR")+"&ILStatus=3"; // Modefied by zc0132 2023-03-13 盘亏数据过滤
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BFindPlanList_Clicked()
{
	//alert("BFindPlanList_Clicked:"+$("#EquipType").combogrid("getValues")+"-"+getElementValue("BillStoreLocDR")+"-"+$("#DisposeStatus").combogrid("getValues"))
	initInventoryPlanList();
}
function BSaveList_Clicked()
{
	//保存盘点结果
	//alert("BSaveList_Clicked")
	var dataList="";
	if (editIndex != undefined){ $('#tDHCEQInventoryList').datagrid('endEdit', editIndex);}
	var rows = $('#tDHCEQInventoryList').datagrid('getRows');
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
		if (rows[i].ILStatus==4)
		{
			if (rows[i].ILActerStoreLocDR!="")
			{
				alertShow("待查找: 第"+(i+1)+"行【实际库房】错误.请修正!");
				return;
			}
		}
		if ((rows[i].ILCondition=="")&&(tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992006")==1))
		{
			if ((rows[i].ILStatus!="")&&(rows[i].ILStatus!=3)&&(rows[i].ILStatus!=4))
			{
				alertShow("完好状态: 第"+(i+1)+"行不能为空.请修正!");
				return;
			}
		}
		if (dataList!="") dataList=dataList+getElementValue("SplitRowCode");
		dataList=dataList+rows[i].ILRowID+"^"+rows[i].ILActerStoreLocDR+"^"+rows[i].ILActerUseLocDR+"^"+rows[i].ILStatus+"^"+rows[i].ILRemark+"^"+rows[i].ILCondition+"^"+rows[i].LIUseStatus+"^"+rows[i].LIPurpose+"^"+rows[i].LILossReasonDR+"^"+rows[i].ILIKeeperDR+"^"+rows[i].ILILocationDR+"^"+rows[i].ILILeaveFactoryNo+"^"+rows[i].ILILocationDR_LDesc;
	}
	///Modefied by zc0124 2022-11-03 没有数据不能保存 begin
	if (dataList=="")
	{
		alertShow("没有数据,不能保存!");
		return;
	}
	///Modefied by zc0124 2022-11-03 没有数据不能保存 end
	//alert(rows.length+":"+dataList)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventoryList", "", dataList);
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		//var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    //window.location.href=url;
		$("#tDHCEQInventoryList").datagrid('reload'); 
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function BLocSubmit_Clicked()
{
	//alert("BLocSubmit_Clicked：科室总单确认")
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventoryAudit", getElementValue("InventoryDR"),curLocID, "1");  //Modefied by zc0132 2023-03-13 科室盘点确认修正
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','提交失败提示',jsonData.Data);
	}
	else
	{
		window.location.reload()
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
	if (getElementValue("InventoryDR")=="")
	{
		messageShow('alert','error','错误提示','盘点单ID为空!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", getElementValue("InventoryDR"),2);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","此次盘点完成!")
	    window.location.reload()
		//var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    //window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function BBarCodePrint_Clicked()
{
	//alert("BBarCodePrint_Clicked")
	/*var Status=getElementValue("IAStatusDR");
	if ((Status=="")||(Status=0))
	{
		messageShow('alert','error','错误提示','未确认盘点单不能打印条码!');
		return
	}*/
	var InventoryDRStr=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetInventoryDRStr", getElementValue("InventoryPlanDR"));
	if (InventoryDRStr=="") InventoryDRStr=getElementValue("InventoryDR");
	if (InventoryDRStr!="")
	{
		var InventoryDRList=InventoryDRStr.split(",")
		for (var j=0;j<InventoryDRList.length;j++)
		{
			//alert(InventoryDRList[j])
			var Strs="";
			do
			{
				Strs=tkMakeServerCall("web.DHCEQSPrint","GetEquipBarInfo",InventoryDRList[j]+"^"+Strs,"Inventory");
				if (Strs!="")
				{
					printBars(Strs,"tiaoma","固定资产");
				}
			} while (Strs!="")
		}
	}
}
function BSaveException_Clicked()
{
	//alert("IListInfoClickHandler:"+rowData.ILRowID)
	//var url= 'dhceq.em.inventoryexception.csp?&InventoryDR='+IRowID+'&InventoryNo='+getElementValue("IInventoryNo")+'&ReadOnly='+getElementValue("ReadOnly");
	//showWindow(url,"盘盈设备信息","","","icon-w-paper","modal","","","large");
	OptException_Clicked();
}
function BInventoryResult_Clicked()
{
	alert("BInventoryResult_Clicked:待定")
	return
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
function BSetClickDivStyle(id)
{
	$("div[name='search']").each(function(){  
	    $(this).removeClass("eq-inven-position-click");
	})
	$("#"+id).parent().parent().addClass("eq-inven-position-click");
}
function ToConsistentClickHandler(index)
{
	var rows = $('#tDHCEQInventoryPlanList').datagrid('getRows');//获得所有行
	if (!rows) return;
	var TInventoryListDR=rows[index].TInventoryListDR
	//alert("转一致:"+TInventoryListDR)
	var TInventoryListDR=rows[index].TInventoryListDR
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateILDisposeStatus",TInventoryListDR,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		BFindPlanList_Clicked()
	}
	else 
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function ToUnCheckLocClickHandler(index)
{
	var rows = $('#tDHCEQInventoryPlanList').datagrid('getRows');//获得所有行
	if (!rows) return;
	//alert("转科室不符:"+rows[index].TInventoryListDR)
	var TInventoryListDR=rows[index].TInventoryListDR
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateILDisposeStatus",TInventoryListDR,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		BFindPlanList_Clicked()
	}
	else 
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function ToDisUseClickHandler(index)
{
	var rows = $('#tDHCEQInventoryPlanList').datagrid('getRows');//获得所有行
	if (!rows) return;
	//alert("转报废:"+rows[index].TInventoryListDR)
	var TInventoryListDR=rows[index].TInventoryListDR
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateILDisposeStatus",TInventoryListDR,"5");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		BFindPlanList_Clicked()
	}
	else 
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function ToLossClickHandler(index)
{
	var rows = $('#tDHCEQInventoryPlanList').datagrid('getRows');//获得所有行
	if (!rows) return;
	//alert("转盘亏:"+rows[index].TInventoryListDR)
	var TInventoryListDR=rows[index].TInventoryListDR
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateILDisposeStatus",TInventoryListDR,"3");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		BFindPlanList_Clicked()
	}
	else 
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>全部设备</a>"+
						"<a id='consistentflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>账物一致</a>"+
						"<a id='uncheckflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>未盘点</a>"+
						"<a id='unchecklocflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>科室差异</a>"+
						"<a id='disuseflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>有报废单</a>"+
						"<a id='unfindflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>盘亏</a>"+
						"<a id='findflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>待查找</a>"
						//<a href="#" class="hisui-linkbutton">蓝色按钮</a>
						//<a href="#" class="hisui-linkbutton yellow">黄色按钮</a>
	//alert(lable_innerText)
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		//alert("全部设备")
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BListAll_Clicked);
	}
	if (jQuery("#consistentflag").length>0)
	{
		jQuery("#consistentflag").linkbutton({iconCls: 'icon-star'});
		jQuery("#consistentflag").on("click", BListConsistentflag_Clicked);
	}
	if (jQuery("#unchecklocflag").length>0)
	{
		jQuery("#unchecklocflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#unchecklocflag").on("click", BListUnCheckLocflag_Clicked);
	}
	if (jQuery("#disuseflag").length>0)
	{
		jQuery("#disuseflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#disuseflag").on("click", BDisUseFlag_Clicked);
	}
	if (jQuery("#unfindflag").length>0)
	{
		jQuery("#unfindflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#unfindflag").on("click", BListUnFindflag_Clicked);
	}
	if (jQuery("#findflag").length>0)
	{
		jQuery("#findflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#findflag").on("click", BListFindFlag_Clicked);
	}
	if (jQuery("#uncheckflag").length>0)
	{
		jQuery("#uncheckflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#uncheckflag").on("click", BListUnCheck_Clicked);
	}
	/*if (jQuery("#unconsistentflag").length>0)
	{
		jQuery("#unconsistentflag").linkbutton({iconCls: 'icon-star'});
		jQuery("#unconsistentflag").on("click", BUnConsistentflag_Clicked);
	}*/
}
function BListAll_Clicked()
{
	//alert("BAll_Clicked")
	$("#ListStatusDesc").html("全部设备");
	DisplayFlag="allflag";
	$("#allflag").css("color", "#FF0000");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#disuseflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
function BListConsistentflag_Clicked()
{
	//alert("BConsistentflag_Clicked")
	$("#ListStatusDesc").html("账物一致");
	DisplayFlag="consistentflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FF0000");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#disuseflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
function BListUnCheckLocflag_Clicked()
{
	//alert("BUnCheckLocflag_Clicked")
	$("#ListStatusDesc").html("科室差异");
	DisplayFlag="unchecklocflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FF0000");
	$("#disuseflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
function BDisUseFlag_Clicked()
{
	//alert("BUnFindFlag_Clicked")
	$("#ListStatusDesc").html("有报废单");
	DisplayFlag="disuseflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#disuseflag").css("color", "#FF0000");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
function BListUnFindflag_Clicked()
{
	//alert("BListUnFindflag_Clicked")
	$("#ListStatusDesc").html("盘亏");
	DisplayFlag="unfindflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#disuseflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FF0000");
	$("#findflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
function BListFindFlag_Clicked()
{
	//alert("BFindFlag_Clicked")
	$("#ListStatusDesc").html("待查找");
	DisplayFlag="findflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#disuseflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FF0000");
	$("#uncheckflag").css("color", "#FFFFFF");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
function BListUnCheck_Clicked()
{
	//alert("BUnCheck_Clicked")
	$("#ListStatusDesc").html("未盘");
	DisplayFlag="uncheckflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#disuseflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FF0000");
	//$("#unconsistentflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
/*function BUnConsistentflag_Clicked()
{
	//alert("BUnConsistentflag_Clicked")
	DisplayFlag="unconsistentflag";
	$("#allflag").css("color", "#FFFFFF");
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FF0000");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");
	BListFind_Clicked();
}
*/
function onClickRow(index)
{
	//var Status=getElementValue("IStatus");
	//if (Status!=1) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#tDHCEQInventoryList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQInventoryList').datagrid('getRows')[editIndex]);
			bindGridEvent(); //编辑行监听响应
		} else {
			$('#tDHCEQInventoryList').datagrid('selectRow', editIndex);
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
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#tDHCEQInventoryList').datagrid('validateRow', editIndex))
	{
		$('#tDHCEQInventoryList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function InventoryResultDataGrid_OnClickRow(rowIndex, rowData)
{
	//alert("InventoryResultDataGrid_OnClickRow:"+rowData.TInventoryDR)
	setElement("InventoryDR",rowData.TInventoryDR);
	initInventoryAudit();
	//var str='dhceq.em.inventoryaudit.csp?&IRowID='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")
	// +"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
}
function GetStatus(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILStatus=data.TRowID;
	//rowData.ILStatus_Display=data.TDesc;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILStatus_Display'});
	$(editor.target).combogrid("setValue",data.TDesc);
	if (data.TRowID==1)
	{
		// 账物一致
		//alert(rowData.ILBillStoreLoc)
		rowData.ILActerStoreLocDR=rowData.ILBillStoreLocDR;
		editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
		$(editor.target).combogrid("setValue",rowData.ILBillStoreLoc);
	}
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLoc(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILActerStoreLocDR=data.TRowID;
	//rowData.ILActerStoreLoc=data.TName;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetCondition(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILCondition=data.TRowID;
	//rowData.ILCondition_Display=data.TDesc;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILCondition_Display'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLocation(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILILocationDR=data.TRowID;
	//rowData.ILILocationDR_LDesc=data.TName;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILILocationDR_LDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetKeeper(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILIKeeperDR=data.TRowID;
	//rowData.ILIKeeperDR_SSUSRName=data.TName;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILIKeeperDR_SSUSRName'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetUseStatus(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.LIUseStatus=data.TRowID;
	//rowData.LIUseStatus_USDesc=data.TDesc;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LIUseStatus_USDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLossReason(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.LILossReasonDR=data.TRowID;
	//rowData.LILossReasonDR_LRDesc=data.TDesc;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LILossReasonDR_LRDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetPurpose(index, data)
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.LIPurpose=data.TRowID;
	//rowData.LILossReasonDR_LRDesc=data.TDesc;
	var editor = $('#tDHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LIPurpose_PDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function BAuditSubmit_Click()
{
	var SelfFlag=getElementValue("SelfFlag")
	var IARowIDs=""
	var rows = $('#tDHCEQInventoryAudit').datagrid('getRows');
    for (var i = 0; i < rows.length; i++)
    {
	    var TSelect = (typeof rows[i].TSelect == 'undefined') ? "" : rows[i].TSelect;
		if (TSelect=="1"||TSelect=="Y")
		{
	    	var IARowID = (typeof rows[i].IARowID == 'undefined') ? "" : rows[i].IARowID;
	    	var IAStatus = (typeof rows[i].IAStatus == 'undefined') ? "" : rows[i].IAStatus;
	    	var IALoc = (typeof rows[i].IALoc == 'undefined') ? "" : rows[i].IALoc;
			if ((IAStatus!="1")&&(SelfFlag=="Y"))
			{
				messageShow('alert','error','错误提示','第'+(i+1)+'行"'+IALoc+'"的盘点数据不是"科室提交状态",不能审核确定!');	
				return;
			}
			if (IARowID=="")
			{
				messageShow('alert','error','错误提示','数据ID不能为空!');
				return;
			}
			if (IARowIDs=="") IARowIDs=IARowID
			else IARowIDs=IARowIDs+"^"+IARowID
		}
    }
	if (IARowIDs=="") return
	//Modefied by zc0125 2022-12-20 修改科室确认按钮不起作用 begin
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventory", IARowIDs,2);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		// MZY0147	3063632		2022-12-20
		//var url="dhceq.em.inventoryaudit.csp?&IRowID="+getElementValue("IRowID")+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    //window.setTimeout(function(){window.location.href=url},50);
	    $("#tDHCEQInventoryAudit").datagrid('reload');
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function BAuditCancel_Click()
{
	var IARowIDs=""
	var rows = $('#tDHCEQInventoryAudit').datagrid('getRows');
    for (var i = 0; i < rows.length; i++)
    {
	    var TSelect = (typeof rows[i].TSelect == 'undefined') ? "" : rows[i].TSelect;
		if (TSelect=="1"||TSelect=="Y")
		{
	    	var IARowID = (typeof rows[i].IARowID == 'undefined') ? "" : rows[i].IARowID;
	    	var IAStatus = (typeof rows[i].IAStatus == 'undefined') ? "" : rows[i].IAStatus;
	    	var IALoc = (typeof rows[i].IALoc == 'undefined') ? "" : rows[i].IALoc;
	    	if (IAStatus!="1")
			{
				messageShow('alert','error','错误提示','第'+(i+1)+'行"'+IALoc+'"的盘点数据不是"科室提交状态",不能退回重盘!');	
				return;
			}
			if (IARowID=="")
			{
				messageShow('alert','error','错误提示','数据ID不能为空!');
				return;
			}
			if (IARowIDs=="") IARowIDs=IARowID
			else IARowIDs=IARowIDs+"^"+IARowID
		}
    }
	if (IARowIDs=="") return
	/*var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventory", IARowIDs,0);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.em.inventoryaudit.csp?&IRowID="+getElementValue("IRowID")+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }*/
}
///Modefied by zc0124 2022-11-03 toolbar元素根据条件显示
function Inittoolbar()
{
	var toolbar="" 
	if ((getElementValue("ReadOnly")=="1")||(getElementValue("StatusDR")=="2")) 
	{
		toolbar=[{
				id:'BPrtInventory',
				iconCls:'icon-print',
				text:'打印条码',
				handler:function(){BBarCodePrint_Clicked()}
			}]
	}
	else
	{
		//Modefied by zc0130 2023-2-17 盘点页签按钮显示控制 begin
		if ((getElementValue("QXType")!="2"))
		{
			toolbar=[
				{
					id:'BSaveList',
					iconCls:'icon-save',
					text:'保存',
					handler:function(){BSaveList_Clicked()}
				},
				/*  //add by zc0128 2023-02-08 功能按钮迁移到其他地方 begin
				{
					id:'BLocSubmit',
               	 	iconCls: 'icon-stamp',
                	text:'科室确认',
                	handler: function(){BLocSubmit_Clicked();}
            	},
				{
					id:'BAudit',
					iconCls:'icon-accept',
					text:'盘点完成',
					handler:function(){BAudit_Clicked()}
				},*/  //add by zc0128 2023-02-08 功能按钮迁移到其他地方 end
				{
					id:'BPrtInventory',
					iconCls:'icon-print',
					text:'打印条码',
					handler:function(){BBarCodePrint_Clicked()}
				},
				{
					id:'BBarCodePrint',
					iconCls:'icon-write-order',
					text:'盘盈录入',
					handler:function(){BSaveException_Clicked()}
				},
				{
					id:'BInventoryBatch',
					iconCls:'icon-mtpaper-add',
					text:'批量结果录入',
					handler:function(){BInventoryBatch_Clicked()}
				}
			]
		}
		else
		{
			toolbar=[
				{
					id:'BSaveList',
					iconCls:'icon-save',
					text:'保存',
					handler:function(){BSaveList_Clicked()}
				},
				{
					id:'BPrtInventory',
					iconCls:'icon-print',
					text:'打印条码',
					handler:function(){BBarCodePrint_Clicked()}
				},
				{
					id:'BBarCodePrint',
					iconCls:'icon-write-order',
					text:'盘盈录入',
					handler:function(){BSaveException_Clicked()}
				},
				{
					id:'BInventoryBatch',
					iconCls:'icon-mtpaper-add',
					text:'批量结果录入',
					handler:function(){BInventoryBatch_Clicked()}
				},
				{
					id:'BLocSubmit',
               	 	iconCls: 'icon-stamp',
                	text:'科室确认',
                	handler: function(){BLocSubmit_Clicked();}
            	}
			]
		}
		//Modefied by zc0130 2023-2-17 盘点页签按钮显示控制 end
	}
	return toolbar;
}
// MZY0134	2952670		2022-09-20
function BInventoryBatch_Clicked()
{
	var str='dhceq.em.inventorybatch.csp?&IRowID='+getElementValue("InventoryDR")+"&StatusDR="+getElementValue("Status")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR=&ManageLocDR=";
	showWindow(str,"未盘设备批量处置","","","icon-w-paper","modal","","","middle",reloadGrid);
}
// MZY0134	2952670		2022-09-20
function reloadGrid()
{
	initInventoryList()
}
function checkboxSelectChange(TSelect,rowIndex)
{
	var row = $('#tDHCEQInventoryAudit').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TSelect==key)
			{
				if (((val=="N")||val=="")) row.TSelect="Y"
				else row.TSelect="N"
			}
		})
	}
}
///Modefied by zc0124 2022-11-03 toolbar元素根据条件显示
function InitAudittoolbar()
{
	var toolbar="" 
	if ((getElementValue("ReadOnly")=="1")||(getElementValue("StatusDR")=="2")) 
	{
		toolbar=[{}]
	}
	else
	{
		//Modefied by zc0130 2023-2-17 盘点最终处理按钮显示控制 begin
		if ((getElementValue("DisposeType")!="2"))
		{
			toolbar=[
				{
					id:'BSubmit',
					iconCls:'icon-accept',
					text:'确定',
					handler:function(){BAuditSubmit_Click()}
				},
				{
					id:'BCancel',
					iconCls:'icon-return',
					text:'退回',
					handler:function(){BAuditCancel_Click()}
				},
				{			
					id:'BFind',
					iconCls:'icon-search',
					text:'查询',
					handler:function(){BAuditFind_Click()}
				}
			]
		}
		else
		{
			toolbar=[
				{			
					id:'BFind',
					iconCls:'icon-search',
					text:'查询',
					handler:function(){BAuditFind_Click()}
				}
			]
		}
		//Modefied by zc0130 2023-2-17 盘点最终处理按钮显示控制 end
	}
	return toolbar;
}
/// modify by mwz 20230106 mwz0067
function BAuditFind_Click()
{
	$HUI.datagrid("#tDHCEQInventoryAudit",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryAudit",
	        	InventoryDR:getElementValue("InventoryDR"),
				IStoreLocDR:getElementValue("IStoreLocDR"),
				IStatusDR:getElementValue("IStatus")
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:AuditColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}
//Modefied by zc0125 2022-12-12 增加最终处理 begin
function initInventoryLastDeal()
{
	//Modefied by zc0126 2022-12-26 信息注释 begin
	//setElement("IDEquipTypeIDs",$("#IDEquipType").combogrid("getValues"));
	//setElement("DisposeStatusDR",$("#DisposeStatus").combogrid("getValues"));
	//Modefied by zc0126 2022-12-26 信息注释 end
	var LastDealtoolbar=InitLastDealtoolbar()  ///Modefied by zc0132 2023-03-13 盘点最终处理toolbar元素根据条件显示 
	$HUI.datagrid("#tDHCEQInventoryLastDeal",{
		url:$URL,
	    queryParams:{
		    ClassName:"web.DHCEQ.EM.BUSInventory",
	        QueryName:"GetIPlanList",
			pInventoryPlanDR:getElementValue("InventoryPlanDR"),
			pInventoryDR:getElementValue("InventoryDR"),
			pEquipTypeIDs:getElementValue("IDEquipTypeIDs"),
			pStoreLocDR:getElementValue("IDBillStoreLocDR"),
			pStatus:getElementValue("Status"),
			pDisposeStatus:getElementValue("DisposeStatusDR")
		},
		rownumbers:false,  		//如果为true则显示行号列
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:LastDealColumns,
		toolbar:LastDealtoolbar,   ///Modefied by zc0132 2023-03-13 盘点最终处理toolbar元素根据条件显示 
	    pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,100],
		onLoadSuccess:function(){
		$("#tDHCEQInventoryLastDeal").datagrid("hideColumn", "ToLoss");
		$("#tDHCEQInventoryLastDeal").datagrid("hideColumn", "TDisposeStatus");
		var trs = $(this).prev().find('div.datagrid-body').find('tr');
	    for(var i=0;i<trs.length;i++)
		for(var j=1;j<trs[i].cells.length;j++){
			var row_html = trs[i].cells[j];
			var cell_field=$(row_html).attr('field');
			var cell_value=$(row_html).find('div').html();
			$('#ToConsistentz'+i).remove();
			$('#ToLossz'+i).remove();
			$('#ToUnCheckLocz'+i).remove();
			$('#ToDisUsez'+i).remove();
			if(cell_field == 'TDisposeStatus')
			{
				if(cell_value == "盘亏")
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBStoreMvoez'+i).remove();
					$('#ILBNoDealz'+i).remove();
					$('#ILBDisuseRequestz'+i).remove();
				}
				if(cell_value == "科室不符")
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBReducez'+i).remove();
					$('#ILBDisuseRequestz'+i).remove();
				}
				if(cell_value == "有报废单")
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBStoreMvoez'+i).remove();
					$('#ILBNoDealz'+i).remove();
					$('#ILBReducez'+i).remove();
				}
				if(cell_value == "")
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBStoreMvoez'+i).remove();
					$('#ILBNoDealz'+i).remove();
					$('#ILBReducez'+i).remove();
					$('#ILBDisuseRequestz'+i).remove();
				}
			}
			if (cell_field == 'TStatus_Display')
			{
				if((cell_value == "账物一致"))
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBStoreMvoez'+i).remove();
					$('#ILBNoDealz'+i).remove();
					$('#ILBReducez'+i).remove();
					$('#ILBDisuseRequestz'+i).remove();
				}
			}
			if (cell_field == 'TActerStoreLocDR')
			{
				if((cell_value == ""))
				{
					$('#ILBStoreMvoez'+i).remove();
				}
			}
			if (cell_field == 'ILDisposeStatusID')
			{
				if(cell_value == "1")
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBStoreMvoez'+i).remove();
					$('#ILBNoDealz'+i).remove();
					$('#ILBReducez'+i).remove();
					$('#ILBDisuseRequestz'+i).remove();
					$('#BussDetailz'+i).remove();
				}
			}
			if (cell_field == 'ILDisposeResultID')
			{
				if(cell_value != "")
				{
					$('#ILBArgeez'+i).remove();
					$('#ILBStoreMvoez'+i).remove();
					$('#ILBNoDealz'+i).remove();
					$('#ILBReducez'+i).remove();
					$('#ILBDisuseRequestz'+i).remove();
				}
				else
				{
					$('#BussDetailz'+i).remove();
				}
			}
			if (cell_field == 'TBussID')
			{
				if(cell_value == "")
				{
					$('#BussDetailz'+i).remove();
				}
			}
		  }
	    }
	});
	//Modefied by zc0126 2022-12-26 权限控制 begin
	if (getElementValue("ReadOnly")=="1")
	{
		$("#tDHCEQInventoryLastDeal").datagrid("hideColumn", "ILBDisuseRequest");
	}
	//Modefied by zc0126 2022-12-26 权限控制 end
}
///Modefied by zc0132 2023-03-13 盘点最终处理toolbar元素根据条件显示 begin
function InitLastDealtoolbar()
{
	var toolbar="" 
	if (getElementValue("DisposeType")!="2")
	{
		toolbar=[{
    			iconCls: 'icon-paper-link',
                text:'盘盈处置',  
				id:'OptException',        
                handler: function(){
                     OptException_Clicked();
                }}]
	}
	else
	{
		toolbar=[{
    			iconCls: 'icon-paper-link',
                text:'盘盈处置',  
				id:'OptException',        
                handler: function(){
                     OptException_Clicked();
                }}
				,  
				{
				id:'BAudit',
				iconCls:'icon-accept',
				text:'盘点完成',
				handler:function(){BAudit_Clicked()}
				}   
        ]
	}
	return toolbar;
}
///Modefied by zc0132 2023-03-13 盘点最终处理toolbar元素根据条件显示 end
function BArgeeClick(curIndex)
{
	var rowsData = $("#tDHCEQInventoryPlanList").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryListDR = rowData.TInventoryListDR;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateILDisposeResult",InventoryListDR, "1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#tDHCEQInventoryPlanList").datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
			return;
	}
}
function BStoreMoveClick(curIndex)
{
	var rowsData = $("#tDHCEQInventoryPlanList").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryListDR = rowData.TInventoryListDR;
	var ILEquipNo = rowData.TBillEquipDR_No;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",ILEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','提示',"错误信息:设备编号无效,不能报废");
		return;
	}
	//modified by ZY0229 20200511
	var url="dhceq.em.storemove.csp?EquipDR="+EquipDR+"&SMMoveType=1&QXType=&WaitAD=off&FromLocDR="+rowData.TBillStoreLocDR+"&ToLocDR="+rowData.TActerStoreLocDR+"&EquipTypeDR="+rowData.TEquipTypeDR+"&InventoryListDR="+InventoryListDR; 
	showWindow(url,"资产转移","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}
function BNoDealClick(curIndex)
{
	var rowsData = $("#tDHCEQInventoryPlanList").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryListDR = rowData.TInventoryListDR;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateILDisposeResult",InventoryListDR, "4");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#tDHCEQInventoryPlanList").datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
			return;
	}
	
}
function BReduceClick(curIndex)
{
	var rowsData = $("#tDHCEQInventoryPlanList").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryListDR = rowData.TInventoryListDR;
	var ILEquipNo = rowData.TBillEquipDR_No;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",ILEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','提示',"错误信息:设备编号无效,不能减少");
		return;
	}
	//modified by ZY0229 20200511
	var url="dhceq.em.outstock.csp?EquipDR="+EquipDR+"&ROutTypeDR=4&WaitAD=off&QXType=2&UseLocDR="+rowData.TBillStoreLocDR+"&InventoryListDR="+InventoryListDR; 
	showWindow(url,"资产减少","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}
function BDisuseRequestClick(curIndex)
{
	var rowsData =$("#tDHCEQInventoryPlanList").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryListDR = rowData.TInventoryListDR;
	var ILEquipNo = rowData.TBillEquipDR_No;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",ILEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','提示',"错误信息:设备编号无效,不能报废");
		return;
	}
	var ReadOnly=0;
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&DType=1&Type=0&EquipDR='+EquipDR+"&RequestLocDR="+curLocID+"&ReadOnly="+ReadOnly+"&InventoryListDR="+InventoryListDR; //session值需要替换
	showWindow(url,"资产报废","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-02 UI
}
function BussClick(curIndex)
{
	var rowsData = $("#tDHCEQInventoryPlanList").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var TBussType = rowData.TBussType;
	var TBussID = rowData.TBussID;
	if (TBussType=="11")
	{
		var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&RowID='+TBussID+'&ReadOnly=1'; 
		showWindow(url,"设备验收管理","","","icon-w-paper","modal","","","large");
	}
	else if (TBussType=="22")
	{
		var url='dhceq.em.storemove.csp?RowID='+TBussID+'&ReadOnly=1'; 
		showWindow(url,"资产转移","","","icon-w-paper","modal","","","large");
	}
	else if (TBussType=="23")
	{
		var url='dhceq.em.outstock.csp?RowID='+TBussID+'&ReadOnly=1&&ROutTypeDR=2'; 
		showWindow(url,"资产减少","","","icon-w-paper","modal","","","large");
	}
	else if (TBussType=="34")
	{
		var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&RowID='+TBussID+'&ReadOnly=1'; 
		showWindow(url,"资产报废","","","icon-w-paper","modal","","","large");
	}
}
//Modefied by zc0125 2022-12-12 增加最终处理 end
// MZY0134	2952670		2022-09-20
function BInventoryBatch_Clicked()
{
	var str='dhceq.em.inventorybatchnew.csp?&IRowID='+getElementValue("InventoryDR")+"&StatusDR="+getElementValue("Status")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR=&ManageLocDR=";
	showWindow(str,"未盘设备批量处置","","","icon-w-paper","modal","","","middle",reloadGrid);
}
//add by mwz 20230315 mwz0068 增加列清除方法
function clearStatus()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILStatus="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearLoc()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILActerStoreLocDR="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearCondition()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILCondition="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearLocation()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILILocationDR="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearKeeper()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILIKeeperDR="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearUseStatus()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.ILUseStatus="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearLossReason()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.LILossReasonDR="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
function clearPurpose()
{
	var rowData = $('#tDHCEQInventoryList').datagrid('getSelected');
	rowData.LIPurpose="";
	$('#tDHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#tDHCEQInventoryList').datagrid('beginEdit',editIndex);
}
