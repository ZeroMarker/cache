var Columns=getCurColumnsInfo('RM.G.Rent.ShareItem','','','');  ///Modify by zc0076 2020-06-09 将引用组件RM.L.GetSCShareItem改为RM.G.Rent.ShareItem
var Column=getCurColumnsInfo('RM.G.Rent.ShareItemList','','','');  ///Modify by zc0076 2020-06-09 将引用组件RM.L.GetSCShareItemList改为RM.G.Rent.ShareItemList

var curIndex=-1;  //点击行
$(function(){
	initDocument();
	initStatusData();
	disableElement("SILName",true);
	//disableElement("BListA",true);
});

function initDocument()
{
	initMessage("Rent");
	initLookUp();
	//initButton();
	initButtonWidth();
	setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat");  
	$("#BAdd").on("click", BSave_Clicked);
	$("#BSave").on("click", BSave_Clicked);
	$("#BDelete").on("click", BDelete_Clicked);
	//Modify by zc 2020-06-24 ZC0077 防止重复调用
	$("#BAddList").on("click", BSaveList_Clicked);
	$("#BSaveList").on("click", BSaveList_Clicked);
	$("#BDeleteList").on("click", BDeleteList_Clicked);
	//Modify by zc 2020-06-24 ZC0077 防止重复调用
	setEnabled();
	$HUI.datagrid("#tDHCEQSCShareItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItem",
			ShareType:getElementValue("SIShareType"),
			Code:getElementValue("SICode"),
			Desc:getElementValue("SIDesc"),
			ShareItemCatDR:getElementValue("SIShareItemCatDR"),
			HospitalDR:getElementValue("SIHospitalDR"),
			WashFlag:getElementValue("SIWashFlag"),
			InspectFlag:getElementValue("SIInspectFlag"),
			
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
		fitColumns:true,
	    columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow: function (index, row) {
			fillData(index, row);
			SCShareItemList();
		},
		onLoadSuccess:function(){
			
		}
	});
	///Modify by zc0076 2020-06-09  初始灰化资源明细维护按钮 begin
	disableElement("BAddList",true);
	disableElement("BSaveList",true);
	disableElement("BDeleteList",true);
	///Modify by zc0076 2020-06-09  初始灰化资源明细维护按钮 begin
}

function initStatusData()
{
	
	var AdvanceDisFlag = $HUI.combobox('#SIShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"1",
		data:[{
				id: '1',
				text: '设备'
			}]
	});
}

function SCShareItemList()
{
	initButtonWidth();
	//Modify by zc 2020-06-24 ZC0077 删除部分 begin
	//$("#BAddList").on("click", BSaveList_Clicked);
	//$("#BSaveList").on("click", BSaveList_Clicked);
	//$("#BDeleteList").on("click", BDeleteList_Clicked);
	//Modify by zc 2020-06-24 ZC0077 删除部分 end
	if (getElementValue("SIRowID")=="") {disableElement("BAddList",true);}  ///Modify by zc0076 2020-06-09 资源项目没有选中需要灰化明细维护的新增按钮
	setEnabledList();
	$HUI.datagrid("#tDHCEQSCShareItemList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemList",
			ShareItemDR:getElementValue("SIRowID"),
			ItemDR:getElementValue("SILItemDR"),
			Name:getElementValue("SILName"),
			ModelDR:getElementValue("SILModelDR"),
			
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: false,  //modify by lmm 2020-06-24 1385270
	    fitColumns:true,
	    columns:Column,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow: function (index, row) {
			fillDataList(index, row);
		},
		onLoadSuccess:function(){
			
		}
	
	});
}

function BSaveList_Clicked()
{
	//setRequiredElements("SILItem^SILModel");  //Modify by zc 2020-06-24 ZC0077 设置必填位置有改动
	setRequiredElements("SILItem");  //Modify by zc 2020-06-29 ZC0078 设置必填项
	var SILShareItemDR=getElementValue("SIRowID");
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItemList",data,"0",SILShareItemDR);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }	
}

// 新增及修改
function BSave_Clicked()
{
	//setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat"); //Modify by zc 2020-06-24 ZC0077 设置必填位置有改动
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItem",data,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}

// add by zx 2020-02-10
// 删除
function BDelete_Clicked()
{
	//setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat");  //Modify by zc 2020-06-24 ZC0077 删除不需要必填项
	if (checkMustItemNull()) return   //Modify by zc 2020-06-24 ZC0077 判断必填项是否为空
	var rowID=getElementValue("SIRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItem",rowID,"1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}

function BDeleteList_Clicked()
{
	//setRequiredElements("SILItem^SILModel");
	//Modify by zc 2020-06-24 ZC0077 删除不需要必填项
	if (checkMustItemNull()) return   //Modify by zc 2020-06-24 ZC0077 判断必填项是否为空
	var rowID=getElementValue("SILRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItemList",rowID,"1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}

// add by zx 2020-02-10
// 点击行后填充数据
// 入参: index,选择行号 row,选择行数据
function fillData(index, row)
{
	
	if (curIndex!=index) 
	{
		setElement("SIShareType",row.TShareTypeDR);
		setElement("SICode",row.TCode);
		setElement("SIDesc",row.TDesc);
		setElement("SIShareItemCatDR",row.TShareItemCatDR);
		setElement("SIShareItemCat",row.TShareItemCat);
		setElement("SIHospital",row.THospital);
		setElement("SIHospitalDR",row.THospitalDR);
		setElement("SIWashFlag",row.TWashFlagDR);
		setElement("SIInspectFlag",row.TInspectFlagDR);
		setElement("SIRemark",row.TRemark);
		setElement("SIRowID",row.TRowID);
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = index;
		setEnabled();
		//setRequiredElements("SILItem");  //Modify by zc 2020-06-24 ZC0077 设置必填项    //Modify by zc 2020-06-29 ZC0078设置必填项位置有误
	}
	else
	{
		setElement("SICode","");
		setElement("SIDesc","");
		setElement("SIShareItemCat","")
		setElement("SIShareItemCatDR","")
		setElement("SIHospital","");
		setElement("SIHospitalDR","");
		setElement("SIWashFlag","");
		setElement("SIInspectFlag","");
		setElement("SIRemark","");
		setElement("SIRowID","");
		setElement("SILShareItemDR","");
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = -1;
		$('#tDHCEQSCShareItem').datagrid('unselectAll');  ///Modify by zc0076 2020-06-09 取消选中应改变背景色
		setEnabled();
		RemoveRequiredElements("SILItem");  //Modify by zc 2020-06-24 ZC0077 移除必填项
		
	}
}

function fillDataList(index, row)
{
	
	if (curIndex!=index) 
	{
		
		
		setElement("SILShareItemDR",row.TShareItemDR);
		setElement("SILItem",row.TItem);
		setElement("SILItemDR",row.TItemDR);
		setElement("SILName",row.TName);
		setElement("SILModel",row.TModel);
		setElement("SILModelDR",row.TModelDR);
		setElement("SILRowID",row.TRowID);
		curIndex = index;
		setEnabledList();
		RemoveRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat"); //Modify by zc 2020-06-24 ZC0077 移除必填项
	}
	else
	{
		setElement("SILShareItemDR",row.TShareItemDR);
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = -1;
		$('#tDHCEQSCShareItemList').datagrid('unselectAll');  ///Modify by zc0076 2020-06-09 取消选中应改变背景色
		setEnabledList();
		setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat");  //Modify by zc 2020-06-24 ZC0077 设置必填项
	}
}

// add by zx 2020-02-10
// 按钮灰化控制处理
function setEnabled()
{
	var SIRowID=getElementValue("SIRowID");
	if (SIRowID!="")
	{
		disableElement("BAdd",true);
		disableElement("BSave",false);
		disableElement("BDelete",false);
		
		
	}
	else
	{
		disableElement("BAdd",false);
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
}

function setEnabledList()
{
	var SILRowID=getElementValue("SILRowID");
	if (SILRowID!="")
	{
		disableElement("BAddList",true);
		disableElement("BSaveList",false);
		disableElement("BDeleteList",false);
	}
	else
	{
		disableElement("BAddList",false);
		disableElement("BSaveList",true);
		disableElement("BDeleteList",true);
		
	}	
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID,item.TDesc);
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="SIHospital")
	{
		setElement("SIHospital",item.TName);
		setElement("SIHospitalDR",item.TRowID);
	}
	if (vElementID=="SILItem")
	{
		setElement("SILItem",item.TName);
		setElement("SILName",item.TName);
		setElement("SILItemDR",item.TRowID);
		setElement("EQItemDR",item.TRowID);
		
	}
	if (vElementID=="SILModel")
	{
		setElement("SILModel",item.TName);
		setElement("SILModelDR",item.TRowID);
	}

}
//Modify by zc 2020-06-29 ZC0078
//元素清空赋值
function clearData(elementID)
{
	setElement(elementID+"DR","")
}

