var HSColumns=getCurColumnsInfo('BA.G.EquipSercie.ServiceItem','','','')

$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage("EquipService");
	defindTitleStyle();
	initLookUp();  //add by wy 2022-7-12 2790212初始化放大镜
	initButtonWidth();
	initButton(); //按钮初始化
	initOrdCat();
	initOrdItemCat("");
	findServiceItem();
	if(getElementValue("SLocDR")!="")  //add by wy 2022-7-18 2790212给科室默认赋值
	{
		var result=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID","dept",getElementValue("SLocDR"))
		setElement("SLoc",result)
		}

	jQuery("#BDownload").linkbutton({iconCls: 'icon-w-update'});
	jQuery("#BDownload").on("click", BDownload_Clicked);
};
function BDownload_Clicked()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTEquipService","Download",getElementValue("StartDate"),getElementValue("EndDate"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","同步完成!");
		initOrdCat()
		initOrdItemCat("");
	}
	else
    {
		messageShow("","","","信息:"+jsonData.Data);
		return
    }
}
function BFind_Clicked()
{
	findServiceItem()
}
function BSave_Clicked()
{
	var SelectRowIDs=""
	var rows = $('#DHCEQHistoryLocService').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.Opt=="Y")
		{
			SelectRowIDs=SelectRowIDs+","+oneRow.TOeordItemDR
		}
	}
	if (SelectRowIDs=="")
	{
		messageShow("","","","请先选择需要保存的记录");
		return
	}
	//add by ZY0224 2020-04-24
	var BussType=getElementValue("BussType")
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	var SaveType=getElementValue("SaveType")
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTEquipService","SaveData",SelectRowIDs,SaveType,BussType,SourceType,SourceID);
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","操作成功!");
		websys_showModal("options").mth();
		findServiceItem()
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData.Data);
		return
    }
}
function checkboxOnChange(Opt,rowIndex)
{
	var row = jQuery('#DHCEQHistoryLocService').datagrid('getRows')[rowIndex];
	if (row)
	{
		///modified by ZY0282 20211112
		if ((row.TSingleFlag=="Y")&&(row.TCount>1))
		{
			alertShow("当前服务项是设备单一使用,已经被使用，不能再选!");
			$.each(row,function(key,val){
				if (Opt==key)
				{
					row.Opt="N"
				}
			})
			return;
		}
		$.each(row,function(key,val){
			if (Opt==key)
			{
				if (((val=="N")||val==""))
				{
					row.Opt="Y"
				}
				else
				{
					row.Opt="N"
				}
			}
		})
	}
}
function createCustomData(webCls,Method,Paras)
{
	var CustomDataObj=[]
	var CustomDataStr=tkMakeServerCall(webCls,Method,Paras)
	if (CustomDataStr!="")
	{
		var CustomDataCount=CustomDataStr.split("@")
		for (var i=0; i<CustomDataCount.length; i++)
		{
			var OneInfo=new CustomData(CustomDataCount[i])
			CustomDataObj.push(OneInfo)
		}
	}
	return CustomDataObj
}
function CustomData(OneCustomStr)
{
	var Str=OneCustomStr.split("^")
	this.id=Str[0]
	this.text=Str[1]
}
function initOrdCat()
{
	var OrdCat=createCustomData("web.DHCEQ.BA.CTEquipService","GetOrdCat","")
	$HUI.combobox("#OrdCatDR_Desc",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"400",
		editable:false,
		data:OrdCat,
		onChange : function(newval,oldval){
			var SelectIDs=""
			for (var i=0;i<newval.length;i++)
			{
				SelectIDs=SelectIDs+newval[i]+","
			}
			initOrdItemCat(SelectIDs)
			}
	})
}
function initOrdItemCat(OrdCatIDs)
{
	var OrdCatItem=createCustomData("web.DHCEQ.BA.CTEquipService","GetOrdItemCat",OrdCatIDs)
	$HUI.combobox("#OrdItemCatDR_Desc",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"400",
		editable:false,
		data:OrdCatItem
	})
}
function findServiceItem()
{
	var OrdCat=$("#OrdCatDR_Desc").combobox("getValues")
	var OrdItemCat=$("#OrdItemCatDR_Desc").combobox("getValues")
	var OrdCatIDs=""
	var OrdCatItemIDs=""
	for (var i=0;i<OrdCat.length;i++)
	{
		OrdCatIDs=OrdCatIDs+OrdCat[i]+","
	}
	for (var i=0;i<OrdItemCat.length;i++)
	{
		OrdCatItemIDs=OrdCatItemIDs+OrdItemCat[i]+","
	}
	
	$HUI.datagrid("#DHCEQHistoryLocService",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.CTEquipService",
	        	QueryName:"GetOeordItem",
				vLocDR:getElementValue("SLocDR"),
				vORCatDR:OrdCatIDs,
				vORItemCatDR:OrdCatItemIDs,
				BussType:getElementValue("BussType"),
				SourceType:getElementValue("SourceType"),
				SourceID:getElementValue("SourceID"),
				vIncludeInput:getElementValue("IncludeInput"),	/////modified by ZY0257 20210325
				Code:getElementValue("Code"),  //add by wy 2022-6-29
				Desc:getElementValue("Desc")   //add by wy 2022-6-29 2790212
				
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:false,
		fit:true,
		border:false,
		columns:HSColumns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
	    onClickRow: function (rowIndex,rowData) {}
	});
}
//add by wy 2022-7-12 2790212放大镜赋值和清除
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}