var Columns=getCurColumnsInfo('BA.G.ServiceConsumable.GetServiceConsumable','','','')
var editFlag="undefined";
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage("BenefitEquipList");
	initLookUp();
	fillData();
	defindTitleStyle();
	//initButtonWidth();      ///modified BY TXR 20230306 
	initButton(); //按钮初始化
    //setElementEnabled(); //输入框只读控制 
    //initEvent();
    ///modified BY ZY0253 20210122 增加必填项设置
    setRequiredElements("SICConsumableItemDR_CIDesc^SICQuantity") 
    initQuantityType();
	$HUI.datagrid("#tDHCEQCServiceConsumable",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.BA.CTServiceConsumable",
	        	QueryName:"GetServiceConsumable",
	        	SourceType:getElementValue("SourceType"),
	        	SourceID:getElementValue("SourceID"),
	        	ServiceItemID:getElementValue("SICServiceItemDR")
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
	    	onClickRow: function (rowIndex,rowData) {
		    	///modified by ZY0282 20211110
		    	if (editFlag==rowIndex)
		    	{
	                editFlag="undefined"
	                setElement("SICRowID","")
	                setElement("SICConsumableItemDR_CIDesc","")
	                setElement("SICQuantity","")
	                setElement("SICUOMDR_UOMDesc","")
	                setElement("SICQuantityType","")
	                setElement("SICSubType","")
	                setElement("SICSubKey","")
	            }
	            else
	            {
	                setElement("SICRowID",rowData.TRowID)
		            fillData();
		            editFlag =rowIndex;
		        }
		    },
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
};

function setSelectValue(elementID,rowData)
{
	if(elementID=="SICConsumableItemDR_CIDesc") 
	{
		setElement("SICConsumableItemDR",rowData.TRowID)
		setElement("SICConsumableItemDR_CIDesc",rowData.TDesc)
		setElement("SICUomDR",rowData.TUnitDR)	//modified by ZY 20220809 2708102
		setElement("SICUOMDR_UOMDesc",rowData.TUnit)
		///modified by ZY0258 2021-03-31
		setElement("SICSubType",rowData.TExType)
		setElement("SICSubKey",rowData.TExDesc)
	}
	//modified by ZY 20220809 2708102
	else if(elementID=="SICUOMDR_UOMDesc") 
	{
		setElement("SICUomDR",rowData.TRowID)
		setElement("SICUOMDR_UOMDesc",rowData.TName)
	}
	else
	{
		setDefaultElementValue(elementID,rowData)
	}
}
function initQuantityType()
{
	var Status = $HUI.combobox('#SICQuantityType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '绝对量'
			},{
				id: '2',
				text: '相对量'
			}]
	});
}
/*
function setElementEnabled()
{
	if(jQuery("#Year").val()!="")jQuery("#Year").attr("disabled", "disabled");
	if(jQuery("#Month").val()!="")jQuery("#Month").attr("disabled", "disabled");
}
function initEvent() 
{	
	if (jQuery("#BGatherResource").length>0)
	{
		jQuery("#BGatherResource").on("click", BGatherResource_Clicked);
	}
}
*/

function BSave_Clicked()
{
	var SICServiceItemDR=getElementValue("SICServiceItemDR")
	var SICConsumableItemDR=getElementValue("SICConsumableItemDR")
	if ((SICServiceItemDR=="")||(SICConsumableItemDR=="")){
		jQuery.messager.alert("提示","耗材项目不能为空!");	///modified by ZY0254 20220220
		return;
	}
	if (checkMustItemNull("")) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTServiceConsumable","SaveData",data,0);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&ESRowID="+getElementValue("ESRowID")+"&ReadOnly="+getElementValue("ReadOnly");
		var url="dhceq.ba.serviceconsumable.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.reload(url);
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	var SICRowID=getElementValue("SICRowID")
	if (SICRowID==""){
		jQuery.messager.alert("提示","数据不能为空!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTServiceConsumable","SaveData",SICRowID,1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&ESRowID="+getElementValue("ESRowID")+"&ReadOnly="+getElementValue("ReadOnly");
		var url="dhceq.ba.serviceconsumable.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.reload(url);
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
	
}

function fillData()
{
	var SICRowID=getElementValue("SICRowID")
	if (SICRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.BA.CTServiceConsumable","GetOneServiceConsumable",SICRowID)
	//messageShow("","","",jsonData)
	
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}
