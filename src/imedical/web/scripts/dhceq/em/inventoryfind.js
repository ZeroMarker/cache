
var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryFind','','','')

$(function(){
	initDocument();
	
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("inventory"); //获取所有业务消息
    initLookUp();
	//Modefied by zc0130 2023-2-17 管理部门的控制 begin
    if (getElementValue("QXType")!="2")
    {
	    disableElement("ManageLoc",1);
	    setElement("ManageLocDR",curLocID)	
    	setElement("ManageLoc",curLocName)	
	}
	//Modefied by zc0130 2023-2-17 管理部门的控制 end
	defindTitleStyle();
  	initButton();
  	initEvent();
  	setEnabled(); //按钮控制
    //initButtonWidth();	 MZY0157	3219572		2023-03-29
	$HUI.datagrid("#tDHCEQInventoryFind",{
	    url:$URL,
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"QueryInventory",
				BeginDate:getElementValue("BeginDate"),
				EndDate:getElementValue("EndDate"),
				InventoryNo:getElementValue("InventoryNo"),
				QXType:getElementValue("QXType"),
				StatusDR:getElementValue("StatusDR"),
				HospitalDR:getElementValue("HospitalDR"),
				StoreLocDR:getElementValue("StoreLocDR"),
				ManageLocDR:getElementValue("ManageLocDR"),
				IAStatusDR:getElementValue("IAStatusDR"),
				CStatus:getElementValue("CStatus")	// MZY0045	1432837		2020-08-14
			},
			fitColumns: true,
			striped: false,
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
				// MZY0048	2020-08-21	是否启用盘盈
				if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992008")!=1)
				{
					$("#tDHCEQInventoryFind").datagrid("hideColumn", "IProfitNum");
				}
				// MZY0146	3132818		2022-12-09		设置单元格背景及文本颜色
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
				for (var i = 0; i < trs.length; i++)
				{
					// 遍历所有列
					//alert(trs[i].cells.length)
					var IRowID="";
					var IStatus=0;
					var cellSort=0;
					for (var j = 0; j < trs[i].cells.length; j++)
					{
						var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
	                    
	                    if (cell_field=="IRowID") IRowID=$(row_html).find('div').html();
	                    if (cell_field=="IStatus") IStatus=$(row_html).find('div').html();
	                    if (cell_field=="IExpectDate") cellSort=j;
					}
					if (IStatus==1)
					{
						var DaysNum=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetDaysNum", IRowID);
						if (DaysNum>0)
						{
							//超期
							if (DaysNum>30)
							{
								trs[i].cells[cellSort].style.cssText = 'background:#F00;color:#FFF';
							}
							else
							{
								//提前多少天要到期
								trs[i].cells[cellSort].style.cssText = 'background:#FFA500;color:#FFF';	// MZY0157	3219572		2023-03-29
							}
						}
					}
				}
			}
	});
	//add by zc0128 2023-02-07 新增状态的盘点单不能查看计划 begin
	if (getElementValue("StatusDR")=="0")
	{
		$("#tDHCEQInventoryFind").datagrid("hideColumn", "IPlanName");
	}
	//add by zc0128 2023-02-07 新增状态的盘点单不能查看计划 end
}

function initEvent()
{
	///Modefied by zc0124 2022-11-02 新增按钮事件已在jquery.common.js里已定义 begin
	/*var obj=document.getElementById("BAdd");
	if (obj)
	{
		jQuery("#BAdd").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BAdd").on("click", BAdd_Clicked);
	}*/
	///Modefied by zc0124 2022-11-02 新增按钮已在jquery.common.js里已定义 end
}
function BAdd_Clicked()
{
	var val="&StatusDR="+getElementValue("StatusDR")
	val=val+"&IAStatusDR="+getElementValue("IAStatusDR")
	val=val+"&QXType="+getElementValue("QXType")
	val=val+"&ManageLocDR="+getElementValue("ManageLocDR")
	val=val+"&StoreLocDR="+getElementValue("StoreLocDR")
	var url= 'dhceq.em.inventory.csp?'+val
	showWindow(url,"盘点单新增","","","icon-w-paper","modal","","","large",refreshWindow)	// MZY0123	2612989		2022-05-12
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQInventoryFind",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"QueryInventory",
				BeginDate:getElementValue("BeginDate"),
				EndDate:getElementValue("EndDate"),
				InventoryNo:getElementValue("InventoryNo"),
				QXType:getElementValue("QXType"),
				StatusDR:getElementValue("StatusDR"),
				HospitalDR:getElementValue("HospitalDR"),
				StoreLocDR:getElementValue("StoreLocDR"),
				ManageLocDR:getElementValue("ManageLocDR"),
				IAStatusDR:getElementValue("IAStatusDR"),
				CStatus:getElementValue("CStatus"),	// MZY0045	1432837		2020-08-14
				PlanDR:getElementValue("IHold6")	
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	if(elementID=="IPlan_Name") {
		setElement("IPlan_Name",rowData.TName)
		setElement("IHold6",rowData.TRowID)
	}
	//Modefied by zc0131 2023-03-07 管理部门选中赋值 bgein
	if(elementID=="ManageLoc") {
		setElement("ManageLocDR",rowData.TRowID)
	}
	//Modefied by zc0131 2023-03-07 管理部门选中赋值 end
}
function setEnabled()
{
	var StatusDR=getElementValue("StatusDR");
	if (StatusDR>0)
	{
		hiddenObj("BAdd",1)
	}
	// MZY0045	1432837		2020-08-14
	if (StatusDR!=2)
	{
		hiddenObj("cCStatus",1);
		$('#CStatus').next(".combo").hide();
	}
	else
	{
		var CStatus = $HUI.combobox('#CStatus',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '3',text: '全部'},{id: '0',text: '新增'},{id: '1',text: '提交'},{id: '2',text: '审核'}],
			onSelect : function(){}
		});
		$('#CStatus').combobox('setValue','2');
	}
}
// MZY0111	2412339		2022-01-14
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
	if (vElementID=="IPlan_Name") { setElement("IHold6","");}  //Modefied by zc0124 2022-11-03 清除计划名称同时清除计划ID
	if (vElementID=="ManageLoc") { setElement("ManageLocDR","");}    //Modefied by zc0131 2023-03-07 管理部门清空
}

function ToInventoryClickHandler(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryPlanDR = rowData.IHold6;
	var InventoryDR = rowData.IRowID;
	var ReadOnly = getElementValue("ReadOnly");
	var StatusDR = getElementValue("StatusDR");
	var QXType = getElementValue("QXType");
	//var IERowID = rowData.IERowID;
	var str='dhceq.em.inventoryplanmanage.csp?InventoryPlanDR=&InventoryDR='+InventoryDR+'&ReadOnly='+ReadOnly+'&StatusDR='+StatusDR+'&QXType='+QXType+'&DisposeType=0'+'&IAStatusDR='+getElementValue("IAStatusDR");
	showWindow(str,"","1920","1080","icon-w-paper","modal","","","small");
}

function ToInventoryDisposeClickHandler(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryPlanDR = rowData.IHold6;
	var InventoryDR = rowData.IRowID;
	var ReadOnly = getElementValue("ReadOnly");
	var StatusDR = getElementValue("StatusDR");
	var QXType = getElementValue("QXType");
	//var IERowID = rowData.IERowID;
	var str='dhceq.em.inventoryplanmanage.csp?InventoryPlanDR=&InventoryDR='+InventoryDR+'&ReadOnly='+ReadOnly+'&StatusDR='+StatusDR+'&QXType='+QXType+'&DisposeType=1'+'&IAStatusDR='+getElementValue("IAStatusDR");
	showWindow(str,"","1920","1080","icon-w-paper","modal","","","small");
}

function ToFinalDisposeClickHandler(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var InventoryPlanDR = rowData.IHold6;
	var InventoryDR = rowData.IRowID;
	var ReadOnly = getElementValue("ReadOnly");
	var StatusDR = getElementValue("StatusDR");
	var QXType = getElementValue("QXType");
	//var IERowID = rowData.IERowID;
	var str='dhceq.em.inventoryplanmanage.csp?InventoryPlanDR=&InventoryDR='+InventoryDR+'&ReadOnly='+ReadOnly+'&StatusDR='+StatusDR+'&QXType='+QXType+'&DisposeType=2'+'&IAStatusDR='+getElementValue("IAStatusDR");
	showWindow(str,"","1920","1080","icon-w-paper","modal","","","small");
}

