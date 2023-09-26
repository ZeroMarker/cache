var Columns=getCurColumnsInfo('RM.G.Rent.SCItemAffix','','','')
var PreSelectedRowID = "";	//取当前选中的组件设备记录ID
$(function(){
	initDocument();	
});
function initDocument()
{
	initUserInfo();	//获取所有session值
    initMessage(); //获取入参js业务和通用消息
    initLookUp(); //初始化放大镜
	defindTitleStyle();
    initButton(); //按钮初始化
    initButtonWidth();	//初始化按钮宽度
    initPage();//非通用按钮初始化
    setRequiredElements("IAItemDR_Desc^IAAffixDR_Desc^IAQuantity");
	//fillData(); //数据填充
    setEnabled(); //按钮控制
    initDataGrid();	//初始化datagrid
}
function initDataGrid()
{
	$HUI.datagrid("#itemaffixdatagrid",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.RM.SCItemAffix",
	        	QueryName:"GetItemAffix",
	        	//Modify by zx 2020-06-28 Bug ZX0094
				IAShareItemDR:getElementValue("IAShareItemDR"),
				IAAffixDR:getElementValue("IAAffixDR"),
				IAModel:getElementValue("IAModel")
		},
	    border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
//        onClickRow:onClickRow,
		onClickRow:function(rowIndex,rowData){
			fillData_OnClickRow(rowIndex, rowData);
		},
		fitColumns:true,
	    columns:Columns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12],
		onLoadSuccess:function(data){
//				creatToolbar();
		}
	});
}
function initPage()
{
	if (jQuery("#BAdd").length>0)
	{
		//jQuery("#BIFBRequest").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BAdd").on("click", BSave_Clicked);
	}
	if(getElementValue("IAShareItemDR")!="")
	{
		disableElement("IAShareItemDR_Desc",true)
	}

}
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	setAffixRowID();
	var combindata=JSON.stringify(getInputList());
  	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCItemAffix","SaveData",combindata);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','info','提示',t[0]);	//操作成功
		location.reload();
	}
	else
	{
		messageShow('alert','error','提示',t[-9200]+jsonData.Data);
	}

}

function BDelete_Clicked()
{
	messageShow("confirm","","",t[-9203],"",truthBeTold,Cancel);
	
	function truthBeTold(){
		var jsonData = tkMakeServerCall("web.DHCEQ.RM.SCItemAffix","DeleteData",getElementValue("IARowID"));
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			messageShow('alert','error','提示',t[-9200]+jsonData.Data);
			return
	    }
	    else
	    {
		    location.reload();
		}

	}
	
	function Cancel(){
		return
	}	

}

//查找按钮点击事件
function BFind_Clicked()
{
	$HUI.datagrid("#itemaffixdatagrid",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.RM.SCItemAffix",
	        	QueryName:"GetItemAffix",
	        	//Modify by zx 2020-06-28 Bug ZX0094
				IAShareItemDR:getElementValue("IAShareItemDR"),
				IAAffixDR:getElementValue("IAAffixDR"),
				IAModel:getElementValue("IAModel")
		},
	})
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
///点击行事件
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.IARowID)
	{
		setElement("IARowID",rowData.IARowID);
		setElement("IAShareItemDR",rowData.IAShareItemDR);
		setElement("IAAffixDR",rowData.IAAffixDR);
		setElement("IAShareItemDR_Desc",rowData.IAShareItemDesc);
		setElement("IAAffixDR_Desc",rowData.IAAffixDesc);
		setElement("IAModel",rowData.IAModel);
		setElement("IAQuantity",rowData.IAQuantity);
		setElement("IAPrice",rowData.IAPrice);
		setElement("IARemark",rowData.IARemark);
		UnderSelect();
		PreSelectedRowID=rowData.IARowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}
	
}
//清空按钮触发事件，取消选中行触发事件
function BClear_Clicked()
{
	setElement("IARowID","");
	if(getElementValue("IAShareItemDR")=="")
	{
		setElement("IAShareItemDR","");
		setElement("IAShareItemDR_Desc","");
	}
	setElement("IAAffixDR","");
	setElement("IAAffixDR_Desc","");
	setElement("IAModel","");
	setElement("IAQuantity","");
	setElement("IAPrice","");
	setElement("IARemark","");
	setEnabled();
	PreSelectedRowID=""
}
function setSelectValue(vElementID,item)
{
	if(vElementID=='IAAffixDR_Desc')
	{
		setElement("IAAffixDR",item.TRowID);
		setElement("IAAffixDR_Desc",item.TDesc);
	}
	if(vElementID=='IAShareItemDR_Desc')
	{
		setElement("IAShareItemDR",item.TRowID);
		setElement("IAShareItemDR_Desc",item.TDesc);
	}
}
function clearData(vElementID)
{
	setElement(vElementID.split("_")[0],"")
}

function setAffixRowID()
{
	var affixDesc=getElementValue("IAAffixDR_Desc");
	if (affixDesc=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTAffix","UpdAffix",affixDesc);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0) setElement("IAAffixDR",jsonData.Data);
}