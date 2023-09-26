var editFlag="undefined";
var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitSummary','','','')
jQuery(document).ready(function()
{
	initUserInfo();
	setElement("BSUserDR",SessionObj.GUSERID)
	setElement("BSUserDR_SSName",SessionObj.GUSERNAME)
    initMessage("BA"); //获取所有业务消息
	initLookUp();
	defindTitleStyle();
	fillData(); //数据填充
	//showFieldsTip();
    setEnabled(); //按钮控制
    initApproveButtonNew(); //初始化审批按钮
    initButton();
	initButtonWidth();	
	$HUI.datagrid("#tDHCEQBenefitSummary",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitSummary",
	        	QueryName:"GetBenefitSummaryList",
				RowID:getElementValue("BSRowID"),
				Year:getElementValue("BSYear")
		},
    	border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		columns:Columns,
	    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQBenefitSummary').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQBenefitSummary').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	        }
        },
		pagination:true,
		pageSize:18,
		pageNumber:18,
		pageList:[18,36,54,72,90]
	});
	//SetEnabled()
	}
)

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}

function fillData()
{
	var RowID=getElementValue("BSRowID")
	if (RowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","GetOneBenefitSummary",RowID)
	//messageShow("","","",jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}
function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#tDHCEQBenefitSummary").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	if (getElementValue("BSYear")=="")
	{
		alertShow("年度不能为空!")
		return
	}
	if (getElementValue("BSSummary")=="")
	{
		alertShow("总结不能为空!")
		return
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#tDHCEQBenefitSummary').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.UCEquipDR=="")
		{
			alertShow("第"+(i+1)+"行设备ID为空!")
			return "-1"
		}
		if (oneRow.UCTotalScore=="")
		{
			alertShow("第"+(i+1)+"行数据不正确!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	if (dataList=="")
	{
		//alertShow("设备明细不能为空!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data
		url="dhceq.ba.benefitsummary.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
	
}
function BDelete_Clicked()
{
	var RowID=getElementValue("BSRowID")
	if (RowID=="")
	{
		//alertShow("没有入库单删除!")
		messageShow("","","","没有可删除单据!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SaveData",RowID,"","1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val=""	//"&RowID="+jsonData.Data
		url="dhceq.ba.benefitsummary.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	var RowID=getElementValue("BSRowID")
	if (RowID=="")
	{
		//alertShow("没有入库单删除!")
		messageShow("","","","没有可删除单据!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SubmitData",RowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data
		url="dhceq.ba.benefitsummary.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function setEnabled()
{
	var BSStatus=getElementValue("BSStatus")
	if (BSStatus=="")
	{
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
	}else if (BSStatus>0)
	{
		disableElement("BSave",true)
		disableElement("BSubmit",true)
	}
}