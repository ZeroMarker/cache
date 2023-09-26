var selectedRowID = "";	//取当前选中的组件设备记录ID
var columns=getCurColumnsInfo('RM.G.Rent.CostAllot','','',''); //获取列定义
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initMessage("Rent");
	initUserInfo(); //用户信息
	initLookUp();
	defindTitleStyle();
	initButton(); //按钮初始化
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	initButtonWidth();
	initRALAllotType();
	setRequiredElements("RALAllotType^RALAllotSourceDR_Desc^RALAllotPercentNum"); //必填项
	setEnabled();		//按钮控制
	HiddenButtonByLoc();
	//table数据加载
	$HUI.datagrid("#tDHCEQSRentCostAllot",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSCostAllot",
			QueryName:"GetCostAllot",
			PutOnSetDR:getElementValue("RALPutOnSetDR"),
			AllotType:getElementValue("RALAllotType"),
			AllotSourceDR:getElementValue("RALAllotSourceDR")
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:columns,
	   	fitColumns: true,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
				//creatToolbar();
			},
		onSelect:function(rowIndex,rowData){
				fillData(rowData);
			}
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSRentCostAllot",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSCostAllot",
			QueryName:"GetCostAllot",
			PutOnSetDR:getElementValue("RALPutOnSetDR"),
			AllotType:getElementValue("RALAllotType"),
			AllotSourceDR:getElementValue("RALAllotSourceDR")
		}
	});
}
///初始化按钮状态
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///选中行按钮状态
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
function BAdd_Clicked()
{
	//Modefined by ZC0074 2020-5-28 分摊比例不能超过100%！ begin
	if (parseFloat(getElementValue("RALAllotPercentNum"))>100)
	{
		messageShow("alert","alert","提示","分摊比例不能超过100%！");
		return;
	}
	//Modefined by ZC0074 2020-5-28 分摊比例不能超过100%！ end
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","SaveData",data,"2");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	window.setTimeout(function(){window.location.href= "dhceq.rm.costallot.csp?&RowID="+getElementValue("RALPutOnSetDR")},50);
}
function BSave_Clicked()
{
	//Modefined by ZC0074 2020-5-28 分摊比例不能超过100%！ begin
	if (parseFloat(getElementValue("RALAllotPercentNum"))>100)
	{
		messageShow("alert","alert","提示","分摊比例不能超过100%！");
		return;
	}
	//Modefined by ZC0074 2020-5-28 分摊比例不能超过100%！ end
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","SaveData",data,"");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","修改成功");
	window.setTimeout(function(){window.location.href= "dhceq.rm.costallot.csp?&RowID="+getElementValue("RALPutOnSetDR")},50);
}

function BDelete_Clicked()
{
	if(getElementValue("RALRowID")==""){return;}
	messageShow("confirm","info","提示",t[-9203],"",DeleteData,"")

}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	window.setTimeout(function(){window.location.href= "dhceq.rm.costallot.csp?&RowID="+getElementValue("RALPutOnSetDR")},50);
}

// Author add by zx 2019-12-19
// Desc 初始化资源类型为combobox,默认value值为 '0'
// Input 无
// Output 无
function initRALAllotType()
{
	var Status = $HUI.combobox('#RALAllotType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '医院'
			},{
				id: '1',
				text: '共享平台中心'
			}
			/*,{
				id: '2',
				text: '借出部门'
			}*/
			],
			onSelect: function () {
	    		ValueClear()
	    		var SourceType = getElementValue("RALAllotType");
	    		if (SourceType=="0")
				{
					disableElement("RALAllotSourceDR_Desc",true);
					var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","GetHosptailInfo",getElementValue("RALPutOnSetDR"));
    				jsonData=jQuery.parseJSON(jsonData);
    				setElement("RALAllotSourceDR_Desc",jsonData.Data["RALAllotSourceDR_Desc"]);
					setElement("RALAllotSourceDR",jsonData.Data["RALAllotSourceDR"]);
    				//singlelookup("RALAllotSourceDR_Desc","PLAT.L.Hospital","","");
				}
				else if (SourceType=="2")
				{
					disableElement("RALAllotSourceDR_Desc",false);
					var paramsFrom=[{"name":"Type","type":"2","value":"0"},{"name":"LocDesc","type":"1","value":"RALAllotSourceDR_Desc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        			singlelookup("RALAllotSourceDR_Desc","PLAT.L.Loc",paramsFrom,"");
				}
				else
				{
					setElement("RALAllotSourceDR_Desc",curLocName);
					setElement("RALAllotSourceDR",curLocID);
					disableElement("RALAllotSourceDR_Desc",true);
				}
			}
	});
}
function ValueClear()
{
	setElement("RALAllotSourceDR_Desc","");
	setElement("RALAllotSourceDR","");
}
// Author add by zx 2019-12-19
// Desc 放大镜元素选择行后给对应DR元素赋值
// Input elementID:放大镜元素ID rowData:选择行数据
// Output 无
function setSelectValue(elementID,rowData)
{
	if(elementID=="RALAllotSourceDR_Desc") 
	{
		setElement("RALAllotSourceDR",rowData.TRowID);
		setElement("RALAllotSourceDR_Desc",rowData.TName);
	}
}


// Author add by zx 2019-12-19
// Desc 选中datagrid行后填充表单
// Input rowData:datagrid选中行数据
// Output 无
function fillData(rowData)
{
	if (selectedRowID!=rowData.RALRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.RALRowID;
		if (rowData.RALAllotType=="0")
		{
			disableElement("RALAllotSourceDR_Desc",true);
			var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","GetHosptailInfo",getElementValue("RALPutOnSetDR"));
    		jsonData=jQuery.parseJSON(jsonData);
    		setElement("RALAllotSourceDR_Desc",jsonData.Data["RALAllotSourceDR_Desc"]);
			setElement("RALAllotSourceDR",jsonData.Data["RALAllotSourceDR"]);
    		//singlelookup("RALAllotSourceDR_Desc","PLAT.L.Hospital","","");
		}
		else if (rowData.RALAllotType=="2")
		{
			disableElement("RALAllotSourceDR_Desc",false);
			var paramsFrom=[{"name":"Type","type":"2","value":"0"},{"name":"LocDesc","type":"1","value":"RALAllotSourceDR_Desc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        	singlelookup("RALAllotSourceDR_Desc","PLAT.L.Loc",paramsFrom,"");
		}
		else
		{
			disableElement("RALAllotSourceDR_Desc",true);
		}
		UnderSelect();
		HiddenButtonByLoc();
	}
	else
	{
		clearFormData();
		disableElement("RALAllotSourceDR_Desc",false);
		selectedRowID="";
		setEnabled();
		HiddenButtonByLoc();
	}
}

// Author add by zx 2019-12-19
// Desc 再次选中datagrid行后清空表单
// Input 无
// Output 无
function clearFormData()
{
	setElement("RALRowID","");
	setElement("RALAllotSourceDR","");
	setElement("RALAllotSourceDR_Desc","");
	setElement("RALAllotType","");
	setElement("RALAllotPercentNum","");
	setElement("RALRemark","");
}
function HiddenButtonByLoc()
{
	var Flag=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","CheckLocType",curLocID);
	if (Flag=="0")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BAdd",true);
	}
}