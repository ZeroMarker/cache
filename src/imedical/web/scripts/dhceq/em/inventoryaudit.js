
var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryAudit','','','')
var ListColumns=getCurColumnsInfo('EM.G.Inventory.InventoryLocList','','','')	// MZY0123	2612992		2022-05-12

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("inventory"); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    //setEnabled(); //按钮控制
    initButtonWidth();
    AInventoryListReload();	// MZY0123	2612992		2022-05-12
	$HUI.datagrid("#tDHCEQInventoryAudit",{
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryAudit",
				InventoryDR:getElementValue("IRowID"),
				StoreLocDR:getElementValue("StoreLocDR")
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			toolbar:[	 /*	MZY0136	2612992		2022-09-30
				{
					id:'BSubmit',
					iconCls:'icon-save',
					text:'确定',
					handler:function(){BSubmit_Click()}
				},'-----------------------------------',
				{
					id:'BCancel',
					iconCls:'icon-export',
					text:'退回',
					handler:function(){BCancel_Click()}
				}*/
			],
			pagination:true,
			pageSize:5,
			pageNumber:1,
			pageList:[5,10,15,20],
			onLoadSuccess:function(){
				if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992008")!=1) $("#tDHCEQInventoryAudit").datagrid("hideColumn", "IAProfitNum");	// MZY0048	2020-08-21	是否启用盘盈
				$("#tDHCEQInventoryAudit").datagrid("hideColumn", "TInventoryListInfo");	// MZY0123	2612992		2022-05-12
				creatToolbar();		//MZY0129	2612992		2022-07-07
				return
				var rows = $('#tDHCEQInventoryAudit').datagrid('getRows');
			    for (var i = 0; i < rows.length; i++)
			    {
				    if (rows[i].IAStatus=="0")
				    {
					    $("#tDHCEQInventoryAudit").datagrid("hideColumn", "BSubmit");
					    $("#tDHCEQInventoryAudit").datagrid("hideColumn", "BCancel");
					}
			    }
			}
	});
}
// MZY0129	2612992		2022-07-07
function creatToolbar()
{
	var lable_innerText="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' width='16' height='16' style='margin-top:15px;margin-right:10px'/><a id='BSubmit' href='#' class='l-btn l-btn-small l-btn-plain' data-options='stopAllEventOnDisabled:true' style='margin-bottom:10px;margin-right:20px'>确定</a>"+
						"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' width='16' height='16' style='margin-top:15px;margin-right:10px'/><a id='BCancel' href='#' class='l-btn l-btn-small l-btn-plain' data-options='stopAllEventOnDisabled:true' style='margin-bottom:10px;margin-right:10px'>退回</a>";
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#BSubmit").length>0)
	{
		//jQuery("#BSubmit").linkbutton({iconCls: 'icon-ok'});
		jQuery("#BSubmit").on("click", BSubmit_Click);
	}
	if (jQuery("#BCancel").length>0)
	{
		//jQuery("#BCancel").linkbutton({iconCls: 'icon-no'});
		jQuery("#BCancel").on("click", BCancel_Click);
	}
}
function BSubmit_Click() 
{
	///add by ZY0244 20200927 管理科室自盘的时候可以跳过科室提交步骤
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
	    	///add by ZY0244 20200927 管理科室自盘的时候可以跳过科室提交步骤
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
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventory", IARowIDs,2);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.em.inventoryaudit.csp?&IRowID="+getElementValue("IRowID")+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
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

function BCancel_Click() 
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
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventory", IARowIDs,0);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.em.inventoryaudit.csp?&IRowID="+getElementValue("IRowID")+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
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

function checkboxSelectChange(TSelect,rowIndex)
{
	var row = jQuery('#tDHCEQInventoryAudit').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TSelect==key)
			{
				if ((val=="N")||(val=="")) row.TSelect="Y"
				else row.TSelect="N"
			}
		})
	}
}
// MZY0123	2612992		2022-05-12
function onClickRow(index)
{
	var objGrid = $("#tDHCEQInventoryAudit");
	var IARowID=objGrid.datagrid('getSelected').IARowID;
	if (IARowID>"")
	{
		setElement("ALStoreLocDR", objGrid.datagrid('getSelected').IALocDR);
	}
	else
	{
		setElement("ALStoreLocDR", "undefined");
	}
	AInventoryListReload();
}
function AInventoryListReload()
{
	$HUI.datagrid("#tDHCEQInventoryList",{
	    url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryList",
		        InventoryDR:getElementValue("IRowID"),
		    	StoreLocDR:getElementValue("ALStoreLocDR"),
		    	onlyShowDiff:getElementValue("onlyShowDiff"),
		    	DisplayFlag:"allflag"
		},
		rownumbers:true,  		//如果为true则显示行号列
		singleSelect:true,
		fit:true,
		//fitColumns:true,
		columns:ListColumns,
		toolbar:[],			// MZY0136	2612992		2022-09-30
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40]
	});
}
