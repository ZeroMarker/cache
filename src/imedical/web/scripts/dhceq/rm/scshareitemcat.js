var Columns=getCurColumnsInfo('RM.G.Rent.ShareItemCat','','','');
//alert(Columns)
var curIndex=-1;  //点击行
$(function(){
	initDocument();
});

function initDocument()
{
	initLookUp();
	initButton();
	initMessage("");
	defindTitleStyle();
	initButtonWidth();
	$("#BAdd").on("click", BSave_Clicked);
	setEnabled();
	initStatusData();
	setRequiredElements("SICShareType^SICCode^SICDesc");
	
	$HUI.datagrid("#tDHCEQSCShareItemCat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemCat",
			Code:getElementValue("SICCode"),
			Desc:getElementValue("SICDesc"),
			ShareType:getElementValue("SICShareType"),
			HospitalDR:getElementValue("SICHospitalDR"),
			
		},
		//scrollbarSize:0,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:Columns,
	    fitColumns:true,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow: function (index, row) {
			fillData(index, row);
		},
		onLoadSuccess:function(){
			setEnabled();
		}
	});
}

function initStatusData()
{
	var AdvanceDisFlag = $HUI.combobox('#SICShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"1",
		data:[{
				id: '1',
				text: '设备'
			}]
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSCShareItemCat",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemCat",
			Code:getElementValue("SICCode"),
			Desc:getElementValue("SICDesc"),
			ShareType:getElementValue("SICShareType"),
			HospitalDR:getElementValue("SICHospitalDR"),
	    }
	}); 
}

// 新增及修改
function BSave_Clicked()
{
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataCat",data,"0");
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
	var rowID=getElementValue("SICRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataCat",rowID,"1");
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
		
		setElement("SICShareType",row.TShareTypeDR);
		setElement("SICCode",row.TCode);
		setElement("SICDesc",row.TDesc);
		setElement("SICHospital",row.THospital);
		setElement("SICHospitalDR",row.THospitalDR);
		setElement("SICRemark",row.TRemark);
		setElement("SICRowID",row.TRowID);
		curIndex = index;
		setEnabled();
	}
	else
	{
		//setElement("SICShareType","");
		setElement("SICCode","");
		setElement("SICDesc","");
		setElement("FIDesc","");
		setElement("SICHospital","");
		setElement("SICHospitalDR","");
		setElement("SICRemark","");
		setElement("SICRowID","");
		curIndex = -1;
		setEnabled();
	}
}

// add by zx 2020-02-10
// 按钮灰化控制处理
function setEnabled()
{
	var SICRowID=getElementValue("SICRowID");
	if (SICRowID!="")
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

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)

}