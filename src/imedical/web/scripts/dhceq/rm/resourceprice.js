var selectedRowID = "";	//取当前选中的组件设备记录ID
var columns=getCurColumnsInfo('RM.G.Rent.ResourcePrice','','',''); //获取列定义
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
	initRPSourceType();
	initRHPMode();
	var paramsFrom=[{"name":"Desc","type":"1","value":"RHPUOMDR_Desc"},{"name":"Type","type":"2","value":"1"}];
    singlelookup("RHPUOMDR_Desc","PLAT.L.UOM",paramsFrom,"");
	setRequiredElements("RPSource^RHPFromDate^RHPUomQuantity^RHPPrice"); //必填项
	setEnabled();		//按钮控制
	//table数据加载
	$HUI.datagrid("#tDHCEQSResourcePrice",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.CTResourcePrice",
			QueryName:"GetResourcePrice",
			HospitalDR:getElementValue("RPHospitalDR"),
			SourceType:getElementValue("RPSourceType"),
			SourceID:getElementValue("RPSourceID"),
			ModelDR:getElementValue("RPModelDR")
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
	// Modify by zc 2020-06-11
	if (getElementValue("RPSourceType")=="1")
	{
		var label=document.getElementById("cRPSource");   
		label.innerHTML="资源项目"; 
		var bcolumn=$('#tDHCEQSResourcePrice').datagrid('getColumnOption','RPSource');  
		bcolumn.title='资源项目';
		$('#tDHCEQSResourcePrice').datagrid();                     
	}
	else if (getElementValue("RPSourceType")=="2")
	{
		var label=document.getElementById("cRPSource");   
		label.innerHTML="资源"; 
		var bcolumn=$('#tDHCEQSResourcePrice').datagrid('getColumnOption','RPSource');  
		bcolumn.title='资源';
		$('#tDHCEQSResourcePrice').datagrid();                     
	}
	else if (getElementValue("RPSourceType")=="3")
	{
		var label=document.getElementById("cRPSource");   
		label.innerHTML="设备类别"; 
		var bcolumn=$('#tDHCEQSResourcePrice').datagrid('getColumnOption','RPSource');  
		bcolumn.title='设备类别';
		$('#tDHCEQSResourcePrice').datagrid();                     
	}
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSResourcePrice",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.CTResourcePrice",
			QueryName:"GetResourcePrice",
			HospitalDR:getElementValue("RPHospitalDR"),
			SourceType:getElementValue("RPSourceType"),
			SourceID:getElementValue("RPSourceID"),
			ModelDR:getElementValue("RPModelDR")
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
	if(CheckDate()) return;
	if(checkMustItemNull()){return;}
	if(getElementValue("RHPUOMDR")==""){$.messager.alert('提示','计价单位不能为空！','warning');return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTResourcePrice","SaveData",data,"2");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	window.setTimeout(function(){window.location.href= "dhceq.rm.resourceprice.csp?&RPSourceType="+getElementValue("RPSourceType")},50);
}
function CheckDate()
{
	var FromDate = new Date(FormatDate(getElementValue("RHPFromDate")).replace(/\-/g, "\/"))     //modified by wy 需求：782084
	var CurDate=new Date(FormatDate(getElementValue("CurDate")).replace(/\-/g, "\/"))
	if (FromDate<CurDate)    
	{
		messageShow('alert','error','提示',"生效日期不能晚于当前日期");
		return true
	}
	return false
}
function BSave_Clicked()
{
	if(CheckDate()) return;
	if(checkMustItemNull()){return;}
	if(getElementValue("RHPUOMDR")==""){$.messager.alert('提示','计价单位不能为空！','warning');return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTResourcePrice","SaveData",data,"");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","更新成功！");
	window.setTimeout(function(){window.location.href= "dhceq.rm.resourceprice.csp?&RPSourceType="+getElementValue("RPSourceType")},50);
}
function BDelete_Clicked()
{
	if(getElementValue("RPRowID")==""){$.messager.alert('提示','请选中一条需要删除的记录！','warning');return;}
	messageShow("confirm","info","提示",t[-9203],"",DeleteData,"")

}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTResourcePrice","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	window.setTimeout(function(){window.location.href= "dhceq.rm.resourceprice.csp?&RPSourceType="+getElementValue("RPSourceType")},50);
}
// Author add by zx 2019-12-19
// Desc 初始化资源类型为combobox,默认value值为 '0'
// Input 无
// Output 无
function initRPSourceType()
{
	
	setElement("RPSource","");
	setElement("RPSourceID","");
	var RPSourceType = getElementValue("RPSourceType");
	if (RPSourceType=="1")
	{
    	singlelookup("RPSource","RM.L.ShareItem","",GetRPSource);
    	var paramsFrom=[{"name":"Desc","type":"1","value":"RPModelDR_Desc"},{"name":"ShareItemDR","type":"1","value":"RPSourceID"}];
    	singlelookup("RPModelDR_Desc","RM.L.ShareItemModel",paramsFrom,"");
	}
	else if (RPSourceType=="2")
	{
		singlelookup("RPSource","RM.L.EquipByShareResource","",GetSourceID);
		singlelookup("RPModelDR_Desc","PLAT.L.Model","","");
	}
	else
	{
		var paramsFrom=[{"name":"Desc","type":"1","value":"RPSource"}];
    	singlelookup("RPSource","RM.L.Rent.ResourceItem",paramsFrom,"");
    	var paramsFrom=[{"name":"ItemDR","type":"1","value":"RPSourceID"},{"name":"Name","type":"1","value":"RPModelDR_Desc"}];
    	singlelookup("RPModelDR_Desc","PLAT.L.Model",paramsFrom,"");
	}
	
}
function GetRPSource(item)
{
	setElement("RPSource",item.TDesc);  
	setElement("RPSourceID",item.TRowID);
}
function GetSourceID(item)
{
	setElement("RPSource",item.TEquipName);  
	setElement("RPSourceID",item.TRowID);
	setElement("RPModelDR",item.TModelDR);
	setElement("RPModelDR_Desc",item.TModel);   
}
function initRHPMode()
{
	var Status = $HUI.combobox('#RHPMode',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"1",
		data:[{
				id: '1',
				text: '租赁时长'
			},{
				id: '2',
				text: '工作量'
			}],
		onSelect: function () {
	    	ValueClear()
			var paramsFrom=[{"name":"Desc","type":"1","value":"RHPUOMDR_Desc"},{"name":"Type","type":"2","value":"1"}];
    		singlelookup("RHPUOMDR_Desc","PLAT.L.UOM",paramsFrom,"");

    }
	});
}

function ValueClear()
{
	setElement("RHPUOMDR_Desc","");
	setElement("RHPUOMDR","");
}
// Author add by zx 2019-12-19
// Desc 放大镜元素选择行后给对应DR元素赋值
// Input elementID:放大镜元素ID rowData:选择行数据
// Output 无
function setSelectValue(elementID,rowData)
{
	if(elementID=="RPSource") 
	{
		setElement("RPSource",rowData.TDesc);
		setElement("RPSourceID",rowData.TRowID);
	}
	else if(elementID=="RHPUOMDR_Desc")
	{
		setElement("RHPUOMDR_Desc",rowData.TName);
		setElement("RHPUOMDR",rowData.TRowID);
	}
	else if(elementID=="RPHospitalDR_Desc") {setElement("RPHospitalDR",rowData.TRowID);}
	else if(elementID=="RHPPriceTypeDR_Desc") {setElement("RHPPriceTypeDR",rowData.TRowID);}
	else if(elementID=="RPModelDR_Desc") {setElement("RPModelDR",rowData.TRowID);}  //Modify By ZX 2020-06-24 Bug ZX0093
}
// Author add by zx 2019-12-19
// Desc 放大镜元素文本内容变化时清除对应的DR元素值
// Input elementID:放大镜元素ID
// Output 无
function clearData(elementID)
{
	return;
}


// Author add by zx 2019-12-19
// Desc 选中datagrid行后填充表单
// Input rowData:datagrid选中行数据
// Output 无
function fillData(rowData)
{
	if (selectedRowID!=rowData.RPRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.RPRowID;
		setElement("RPRowID",selectedRowID);
		// Modify by zc 2020-06-11
		disableElement("RPHospitalDR_Desc",true);
		disableElement("RPSource",true);
		disableElement("RPModelDR_Desc",true);
		disableElement("RHPPriceTypeDR_Desc",true);
		if (rowData.RPSourceType=="1")
		{
			singlelookup("RPSource","RM.L.ShareItem","","");
    		var paramsFrom=[{"name":"Desc","type":"1","value":"RPModelDR_Desc"},{"name":"ShareItemDR","type":"1","value":"RPSourceID"}];
    		singlelookup("RPModelDR_Desc","RM.L.ShareItemModel",paramsFrom,"");
		}
		else if (rowData.RPSourceType=="2")
		{
			singlelookup("RPSource","RM.L.EquipByShareResource","",GetSourceID);
			singlelookup("RPModelDR_Desc","PLAT.L.Model","","");
		}
		else
		{
			var paramsFrom=[{"name":"Desc","type":"1","value":"RPSource"}];
    		singlelookup("RPSource","RM.L.Rent.ResourceItem",paramsFrom,"");
    		var paramsFrom=[{"name":"ItemDR","type":"1","value":"RPSourceID"},{"name":"Name","type":"1","value":"RPModelDR_Desc"}];
    		singlelookup("RPModelDR_Desc","PLAT.L.Model",paramsFrom,"");
		}
		UnderSelect();
	}
	else
	{
		clearFormData();
		selectedRowID="";
		setEnabled()
		// Modify by zc 2020-06-11
		disableElement("RPHospitalDR_Desc",false);
		disableElement("RPSource",false);
		disableElement("RPModelDR_Desc",false);
		disableElement("RHPPriceTypeDR_Desc",false);
	}
}

// Author add by zx 2019-12-19
// Desc 再次选中datagrid行后清空表单
// Input 无
// Output 无
function clearFormData()
{
	setElement("RPRowID","");
	setElement("RPHospitalDR","");
	setElement("RPHospitalDR_Desc","");
	setElement("RPSource","");
	setElement("RPSourceID","");
	setElement("RPModelDR","");
	setElement("RPModelDR_Desc","");
	setElement("RHPRowID","");
	setElement("RHPPriceTypeDR","");
	setElement("RHPPriceTypeDR_Desc","");
	setElement("RHPMode","1");
	setElement("RHPUomQuantity","");
	setElement("RHPUOMDR","");
	setElement("RHPUOMDR_Desc","");
	setElement("RHPPrice","");
	setElement("RHPFromDate","");
	var paramsFrom=[{"name":"Desc","type":"1","value":"RHPUOMDR_Desc"},{"name":"Type","type":"2","value":"1"}];
    singlelookup("RHPUOMDR_Desc","PLAT.L.UOM",paramsFrom,"");
}

//Modify by zx 2020-05-18 Bug ZX0088
//元素参数重新获取值
function getParam(ID)
{
	if (ID=="ItemDR"){return ""}
	else if (ID=="ModelDR") {return getElementValue("RPModelDR")}
}