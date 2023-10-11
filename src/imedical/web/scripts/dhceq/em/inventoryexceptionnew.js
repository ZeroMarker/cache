var editIndex=undefined;
var IEInventoryDR=getElementValue("IEInventoryDR");
var StatusDR=getElementValue("StatusDR");
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryException','','','');
var curTableID="tDHCEQInventoryException"
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
    initMessage("InventoryException"); 	//获取所有业务消息
    initLookUp(); 				//初始化放大镜
	initIEquipType();			//初始化管理类组
    defindTitleStyle();
    initInventoryStatusData();
    initType();
    initButton(); 				//按钮初始化 
    //initButtonWidth("BSaveExcel1,BSaveExcel2");	MZY0157	3219574		2023-03-29
    InitEvent()
    setRequiredElements("IEEquipName^IEStoreLocDR_CTLOCDesc^IETransAssetDate^IEOriginalFee"); //Modeied by zc0124 2022-11-02 增加必填项
    setEnabled(); 				//按钮控制
    var vtoolbar=Inittoolbar();
	$HUI.datagrid("#tDHCEQInventoryException",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"QueryInventoryException",
		        InventoryDR:IEInventoryDR,
				InventoryPlanDR:getElementValue("InventoryPlanDR")
		},
		rownumbers:true,  		//如果为true则显示行号列
		singleSelect:true,
		toolbar:vtoolbar,
		columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30],
		onLoadSuccess:function(){
				//$("#"+curTableID).datagrid('hideColumn', "IEUnBind")
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
	            //行
	            for(var i=0;i<trs.length;i++)
	                //行内单元格
	                for(var j=1;j<trs[i].cells.length;j++){
	                    var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
	                    var cell_value=$(row_html).find('div').html();
	                    if(cell_field == 'IEEquipNo')
	                    {
		                    if(cell_value == "")
		                    {
				                $('#IEUnBindz'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();  //Modefied by zc0125 2022-12-12 按钮影藏 begin
				                $('#IEBReducez'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEDisusez'+i).remove();
				                $('#IEBArgeez'+i).remove();
				            }
				            else
				            {
					            $('#IEBindz'+i).remove();
				                $('#IEBInStockz'+i).remove();
					        }  //Modefied by zc0125 2022-12-12 按钮影藏 end
	                    }
	                    else if(cell_field == 'IEInventoryStatus')
	                    {
		                    if(cell_value == "盘盈")
		                    {
				                $('#IEExceptionz'+i).remove();
				            }
	                    }
	                    else if(cell_field == 'IEDisposeStatus')
	                    {
		                    if(cell_value == "有报废单")
		                    {
	                        	 $('#IEDisusez'+i).remove();
			                }
			                else if(cell_value == "盘盈")
			                {
				                $('#IEExceptionz'+i).remove();
				            }
	                    }
						else if(cell_field == 'IETempNo')
	                    {
		                    if(cell_value == "")
		                    {
				                $('#IEBindz'+i).remove();
				            }
	                    }
	                    //Modefied by zc0125 2022-12-12 按钮影藏 begin
	                    if(cell_field == 'IEDisposeStatusID')
	                    {
		                    if(cell_value == "2")
		                    {
			                    $('#IEBReducez'+i).remove();
				                $('#IEBInStockz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				            }
				            else if(cell_value == "3")
				            {
					            $('#IEBNoDealz'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBInStockz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
					        }
					        else if(cell_value == "5")
				            {
					            $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBInStockz'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBArgeez'+i).remove();
					        }
					        else if(cell_value == "6")
				            {
					            $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				                $('#IEExceptionz'+i).remove();
				                $('#IEDisusez'+i).remove();
				                $('#IEUnBindz'+i).remove();
					        }
					        else if(cell_value == "")
				            {
					            $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				                $('#IEBInStockz'+i).remove();
					        }
	                    }
	                    if(cell_field == 'IEDisposeResultID')
	                    {
		                    if(cell_value != "")
		                    {
				                $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				                $('#IEExceptionz'+i).remove();
				                $('#IEBindz'+i).remove();
				                $('#IEExceptionz'+i).remove();
				                $('#IEDisusez'+i).remove();
				                $('#IEUnBindz'+i).remove();
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
						//Modefied by zc0125 2022-12-12 按钮影藏 end
	                }
	                
	            }
	});
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEStartDate");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IETransAssetDate");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUserLoc");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEManuFactory");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEProvider");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IELocation");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IELeaveFactoryNo");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IERemark");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEPictrue");
	//Modefied by zc0128 2023-02-08 按钮元素的影藏 begin
	if (getElementValue("DisposeType")=="0")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEInventoryStatus");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEDisposeStatus");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEDisposeResult");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "BussDetail");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUnBind");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEBArgee");
	}
	if (getElementValue("DisposeType")=="1")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "BussDetail");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEBArgee");
	}
	if (getElementValue("DisposeType")=="2")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUnBind");
	}
	//Modefied by zc0128 2023-02-08 按钮元素的影藏 end
	//Modefied by zc0126 2022-12-26 权限控制 begin
	if (getElementValue("ReadOnly")=="1")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUnBind");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEBArgee");  //Modefied by zc0128 2023-02-08 按钮元素的影藏
	}
	//Modefied by zc0126 2022-12-26 权限控制 end
	var IEStoreLoc=$('#tDHCEQInventoryException').datagrid('getColumnOption','IEStoreLoc');
	IEStoreLoc.title="盘点科室"
	$('#tDHCEQInventoryException').datagrid();
};
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
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150},
	    ]]
	});
}
function initInventoryStatusData()
{
	$("#InventoryStatus").keywords({
			   singleSelect:true,
               items:[
               	{                                 //Modefied by zc0125 2022-12-12 begin
					id: '',
					text: '全部',selected:true
				},
               	{
					id: '1',
					text: '未处理'     //Modefied by zc0125 2022-12-12 end
				},{
					id: '2',
					text: '盘盈'
				},{
					id: '3',
					text: '已处理非盘盈'
				}],
			    onClick : function(v){				    
					var InventoryStatus=v.id
					setElement("InventoryStatus",InventoryStatus)
					BFind_Clicked()
				},

	     })
}
function Inittoolbar()
{
	var toolbar="" 
	//Modefied by zc0128 2023-02-08 按钮元素的影藏 begin
	if (getElementValue("InventoryDR")!="")
	{
		if ((getElementValue("DisposeType")=="1")||(getElementValue("DisposeType")=="2"))
		{
			toolbar=[
	        {
                iconCls: 'icon-export',
	            text:'盘点状态导出',
	            id:'BSaveExcel1',
	            handler: function(){
	                 BSaveExcel1_Click();
	            }
	        },
	        {
                iconCls: 'icon-export',
	            text:'处理状态导出',
	            id:'BSaveExcel2',
	            handler: function(){
	                 BSaveExcel2_Click();
	            }
	        }
        	]
		}
		else
		{
			toolbar=[
	        {
                iconCls: 'icon-add',
	            text:'新增盘盈设备',
	            id:'add',
	            handler: function(){
	                 Add();
	            }
	        },	// MZY0150	3193876		2023-01-29	UI改造
	        {
                iconCls: 'icon-export',
	            text:'盘点状态导出',
	            id:'BSaveExcel1',
	            handler: function(){
	                 BSaveExcel1_Click();
	            }
	        },
	        {
                iconCls: 'icon-export',
	            text:'处理状态导出',
	            id:'BSaveExcel2',
	            handler: function(){
	                 BSaveExcel2_Click();
	            }
	        }
        	]
		}
	}
	//Modefied by zc0128 2023-02-08 按钮元素的影藏 end
	if (getElementValue("ReadOnly")=="1")
	{
		toolbar="" 
	}
	return toolbar;
}
function initType()
{
	var IEUseStatus = $HUI.combobox('#IEUseStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: '在用'
			},{
				id: '2',
				text: '拆封未使用'
			},{
				id: '3',
				text: '未拆封'
			},{
				id: '4',
				text: '积压闲置'
			},{
				id: '5',
				text: '已盈亏'
			}]
	});
	//Modify By zx 2020-02-20 BUG ZX0076
	var IEPurpose = $HUI.combobox('#IEPurpose',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: '医院日常使用'		//modified by czf 20200911 begin CZF0127
			},{
				id: '2',
				text: '储备物资'
			}]
	});
}
function InitEvent() //初始化事件
{
	if (jQuery("#BSaveExcel").length>0)
	{
		jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BSaveExcel").on("click", BSaveExcel_Click);
	}
	if (jQuery("#BColSet").length>0)
	{
		jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});
		jQuery("#BColSet").on("click", BColSet_Click);
	}
	if (jQuery("#BSaveExcel1").length>0)
	{
		jQuery("#BSaveExcel1").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BSaveExcel1").on("click", BSaveExcel1_Click);
	}
	if (jQuery("#BSaveExcel2").length>0)
	{
		jQuery("#BSaveExcel2").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BSaveExcel2").on("click", BSaveExcel2_Click);
	}
	//Modefied by zc0132 2023-3-28 检查编号是否重复录入 begin
	var obj=document.getElementById("IEEquipNo");
	if (obj) obj.onchange=IEEquipNoChange;
	//Modefied by zc0132 2023-3-28 检查编号是否重复录入 end
}
//Modefied by zc0132 2023-3-28 检查编号是否重复录入 begin
function IEEquipNoChange()
{
	var rtn =tkMakeServerCall("web.DHCEQ.EM.BUSInventory","CheckEquipNoInException",getElementValue("IERowID"),getElementValue("IEEquipNo"));
	if (rtn!="0")
	{
		messageShow('alert','error','错误提示','设备编号/临时码已存在!');
		SetElement("IEEquipNo","");
		return;	
	}
}
//Modefied by zc0132 2023-3-28 检查编号是否重复录入 end
function Save()
{
	
}
function Add()
{
	Clear()
	$HUI.dialog('#ExceptionInfo').open();
	$('#tDHCEQInventoryException').datagrid('unselectAll')
}
function BFind_Clicked()
{
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"))  ///Modefied by zc0125 2022-11-09 给IEquipTypeIDs元素赋值
	$HUI.datagrid("#tDHCEQInventoryException",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.EM.BUSInventory",
	    	QueryName:"QueryInventoryException",
	        InventoryDR:IEInventoryDR,
	    	User:curUserID,
	    	InventoryPlanDR:getElementValue("InventoryPlanDR"),
	    	InventoryLocDR:getElementValue("InventoryLocDR"),
	    	InventoryNo:getElementValue("IEInventoryNo"),
	    	InventoryStatus:getElementValue("InventoryStatus"),
			IEquipTypeIDs:getElementValue("IEquipTypeIDs")		 ///Modefied by zc0125 2022-11-09 类组串取值改为获取IEquipTypeIDs元素值
		}
	});
}
function setEnabled()
{
	disableElement("BDelete",true);
	if (getElementValue("IERowID")!="")
	{
		disableElement("BDelete",false);
	}
	if (getElementValue("InventoryPlanDR")!="")
	{
		setDisableElements("InventoryLocPlan",true)
	}
	if (getElementValue("InventoryDR")!="")
	{
		setDisableElements("IEInventoryNo",true)
	}
	else
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	//Modefied by zc0126 2022-12-26 按钮控制 begin
	if (getElementValue("ReadOnly")=="1")
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	if (getElementValue("IEBussID")!="")
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	//Modefied by zc0126 2022-12-26 按钮控制 begin
	//Modefied by zc0128 2023-02-08 按钮元素的影藏  begin
	if (getElementValue("DisposeType")!="0")
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	//Modefied by zc0128 2023-02-08 按钮元素的影藏 end
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	// MZY0044	1457590		2020-08-07	删除旧处理方法
	if(elementID=="InventoryLocPlan") {
		setElement("InventoryLocPlan",rowData.TName)
		setElement("InventoryPlanID",rowData.TRowID)
		setElement("InventoryPlanDR",rowData.TRowID)
	}
}

function onClickRow(index)
{
	if (editIndex==index)
	{
		editIndex = undefined;
		Clear();
		setEnabled();
		return
	}
	var rowData = $('#tDHCEQInventoryException').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.IERowID=="")
	{
		messageShow('alert','error','错误提示','盘盈设备列表数据异常!');
		return;
	}
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneIException",rowData.IERowID);
	//alertShow(rowData.IERowID+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	setElement("IERowID",rowData.IERowID);
	$HUI.dialog('#ExceptionInfo').open();
	$('#tDHCEQInventoryException').datagrid('unselectAll')
	editIndex=index;
	setEnabled();
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	//Modefied by zc0126 2022-12-26 元素清空 begin
	if(elementID=="InventoryLocPlan") {
		setElement("InventoryPlanID","")
		setElement("InventoryPlanDR","")
	}
	//Modefied by zc0126 2022-12-26 元素清空 begin
	return;
}
function Clear()
{
	SetElement("IERowID","");
	SetElement("IEEquipName","");
	SetElement("IEEquipNo","");
	SetElement("IEModel","");
	SetElement("IEOriginalFee","");
	SetElement("IETransAssetDate","");
	SetElement("IEStartDate","");
	SetElement("IEUserLocDR_CTLOCDesc","");
	SetElement("IEUserLocDR","");
	SetElement("IEStoreLocDR_CTLOCDesc","");
	SetElement("IEStoreLocDR","");
	SetElement("IELocationDR_LDesc","");
	SetElement("IELocationDR","");
	SetElement("IEProviderDR_VDesc","");
	SetElement("IEProviderDR","");
	SetElement("IEManuFactoryDR_MFDesc","");
	SetElement("IEManuFactoryDR","");
	SetElement("IELeaveFactoryNo","");
	SetElement("IERemark","");
	SetElement("IEEquipTypeDR_ETDesc",""); //add by zc0128 2023-02-07 清空赋值 begin
	SetElement("IEEquipTypeDR","");
	SetElement("IEBrand","");
	SetElement("IEManuFactoryDR_MFName","");
	SetElement("IEManuFactoryDR","");
	SetElement("IEUseStatus","");
	SetElement("IEPurpose","");			//add by zc0128 2023-02-07 清空赋值 end
}
function BSave_Clicked()
{
	if (getElementValue("IEEquipName")=="")
	{
		messageShow('alert','error','错误提示','设备名称不能为空!');
		return;
	}
	if (getElementValue("IEOriginalFee")=="")
	{
		messageShow('alert','error','错误提示','设备原值不能为空!');
		return;
	}
	if (getElementValue("IETransAssetDate")=="")
	{
		messageShow('alert','error','错误提示','转资(入库)日期不能为空!');
		return;
	}
	if (getElementValue("IEStoreLocDR")=="")
	{
		messageShow('alert','error','错误提示','所在库房不能为空!');
		return;
	}
	var data=getInputList();
	data.IEUserDR=curUserID;  //Modefied by zc0126 2022-12-26 增加盘盈人信息
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventoryException",data);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		websys_showModal("options").mth();  //Modefied by zc0126 2022-12-26 父界面刷新
	    var url= 'dhceq.em.inventoryexceptionnew.csp?&InventoryDR='+IEInventoryDR+'&InventoryPlanDR=&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
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
	messageShow("confirm","","","是否确定删除当前盘盈记录?","",DeleteIException,DisConfirmOpt);
}
function DeleteIException()
{
	if (getElementValue("IERowID")=="")
	{
		messageShow('alert','error','错误提示','没有盘盈记录删除!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteIException", getElementValue("IERowID"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		websys_showModal("options").mth();  //Modefied by zc0126 2022-12-26 父界面刷新
		var url= 'dhceq.em.inventoryexceptionnew.csp?&InventoryDR='+IEInventoryDR+'&InventoryPlanDR=&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
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

function setElementEnabled()
{
	//var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	//if(Rtn=="1") disableElement("CTContractNo",true);
}
// MZY0090	2021-08-23
//导出盘盈明细
function BSaveExcel_Click()
{
	var ObjTJob=$('#tDHCEQInventoryException').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"]) TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	// MZY0122	2578403		2022-04-24	增加润乾打印
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		if (!CheckColset("InventoryException"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQInventoryExceptionExport.raq&CurTableName=InventoryException&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob;
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
	else
	{
		var vData=GetData();
		PrintDHCEQEquipNew("InventoryException",1,TJob,vData,"InventoryException",100); 
	}
} 
//导出数据列设置
function BColSet_Click()
{
	var para="&TableName=InventoryException&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)
}
function GetData()
{
	var vData="^ContractTypeDR="+getElementValue("ContractType");
	vData=vData+"^Name="+getElementValue("EquipName");
	vData=vData+"^ContractName="+getElementValue("ContractName");
	vData=vData+"^ContractNo="+getElementValue("ContractNo");
	return vData;
}

function BBindClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IETempNo = rowData.IETempNo;
	var str='dhceq.em.inventorybind.csp?&TempID='+IETempNo+"&ExceptionID="+IERowID;
	showWindow(str,"设备绑定","","","icon-w-paper","modal","","","large");   //Modeied by zc0124 2022-11-07 绑定页面弹出过小
}
function BIEClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","ChangeIEInventoryStatus",IERowID, "6");
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
function BDisuseClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","ChangeIEInventoryStatus",IERowID, "5");
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
function BUnBindClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UnBindEquip",IERowID, "5");
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
function BSaveExcel1_Click()
{
	//var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=0&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=0&InventoryDR="+IEInventoryDR+"&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BSaveExcel2_Click()
{
	//var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=1&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=1&InventoryDR="+IEInventoryDR+"&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
//Modefied by zc0125 2022-12-12 增加业务处理 begin
function BArgeeClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateIEDisposeResult",IERowID, "1");
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
function BInStockClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&CheckTypeDR=0&Type=0&ApproveRole=&ReadOnly=&InventoryExceptionDR='+IERowID; 
	showWindow(url,"设备验收管理","","","icon-w-paper","modal","","","large");
}
function BStoreMoveClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IEEquipNo = rowData.IEEquipNo;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",IEEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','提示',"错误信息:设备编号无效,不能报废");
		return;
	}
	//modified by ZY0229 20200511
	var url="dhceq.em.storemove.csp?EquipDR="+EquipDR+"&SMMoveType=1&QXType=&WaitAD=off&FromLocDR="+rowData.IEUserLocDR+"&ToLocDR="+rowData.IEStoreLocDR+"&EquipTypeDR="+rowData.IEEquipTypeDR+"&InventoryExceptionDR="+IERowID; 
	showWindow(url,"资产转移","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}
function BNoDealClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateIEDisposeResult",IERowID, "4");
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
function BReduceClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IEEquipNo = rowData.IEEquipNo;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",IEEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','提示',"错误信息:设备编号无效,不能减少");
		return;
	}
	//modified by ZY0229 20200511
	var url="dhceq.em.outstock.csp?EquipDR="+EquipDR+"&ROutTypeDR=4&WaitAD=off&QXType=2&UseLocDR="+rowData.IEStoreLocDR+"&InventoryExceptionDR="+IERowID; 
	showWindow(url,"资产减少","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}
function BDisuseRequestClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IEEquipNo = rowData.IEEquipNo;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",IEEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','提示',"错误信息:设备编号无效,不能报废");
		return;
	}
	var ReadOnly=0;
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&DType=1&Type=0&EquipDR='+EquipDR+"&RequestLocDR="+curLocID+"&ReadOnly="+ReadOnly+"&InventoryExceptionDR="+IERowID; //session值需要替换
	showWindow(url,"资产报废","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-02 UI
}
function BussClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
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
//Modefied by zc0125 2022-12-12 增加业务处理 end
