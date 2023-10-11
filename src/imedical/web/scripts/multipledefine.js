var Columns=getCurColumnsInfo('EM.G.MultipleDefine','','','')
var selectflag=false
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initLookUp();
	initButton();
	initButtonWidth();
	defindTitleStyle();
	initMDSourceTypeData();
	setRequiredElements("MDSourceType^MDMultiCode^MDMultiName^MDApproveTypeDR_ATDesc") //Add by QW20191205 begin 需求号:1124174  排除保存空数据
	$HUI.datagrid("#DHCEQMultipleDefine",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.CTMultipleDefine",
	        	QueryName:"MultipleDefine",
				ApproveTypeDR:getElementValue("MDApproveTypeDR")
		},
		rownumbers: true, 
		singleSelect:true,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);},
		onLoadSuccess:function(){}
	});
}
function BSave_Clicked()
{
	//Add by QW20191205 begin 需求号:1124174  排除保存空数据
	if (getElementValue("MDSourceType")=="")
	{
		alertShow("来源不能为空!")
		return
	}
	if (getElementValue("MDMultiCode")=="")
	{
		alertShow("编码不能为空!")
		return
	}
	if (getElementValue("MDMultiName")=="")
	{
		alertShow("描述不能为空!")
		return
	}
	if (getElementValue("MDApproveTypeDR")=="")
	{
		alertShow("审批类型不能为空!")
		return
	}
	//Add by QW20191205 End 需求号:1124174  排除保存空数据
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.CTMultipleDefine","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		url="dhceq.em.multipledefine.csp?&ApproveType="+getElementValue("MDApproveTypeDR") //Modified by QW20191205 需求号:1124184 默认显示审批类型
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	var data=getElementValue("MDRowID")
	if (data=="")
	{
		alertShow("没有选中行!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.CTMultipleDefine","SaveData",data,"1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		url="dhceq.em.multipledefine.csp?&ApproveType="+getElementValue("MDApproveTypeDR")  //Modified By QW20210511 BUG: QW0107 
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

function setSelectValue(elementID,rowData)
{
	
	if(elementID=="MDApproveTypeDR_ATDesc") {setElement("MDApproveTypeDR_ATDesc",rowData.Description);setElement("MDApproveTypeDR",rowData.RowID)}
}

function onClickRow(rowIndex,rowData)
{
	//Modified by QW20191213 begin 需求号:1135903  审批类型及id从前面传过来,保持不变,因此选中不赋值
	    if(!selectflag)
	    {   
	        selectflag=true;
			setElement("MDRowID",rowData.TRowID);
			setElement("MDSourceType",rowData.TSourceType);
			setElement("MDClearFlag",rowData.TClearFlag);
			setElement("MDMultiCode",rowData.TMultiCode);
			setElement("MDMultiName",rowData.TMultiName);
	    }else
	    {
		    selectflag=false;
			setElement("MDRowID","");
			setElement("MDSourceType","");
			setElement("MDClearFlag","");
			setElement("MDMultiCode","");
			setElement("MDMultiName","");
			jQuery('#DHCEQMultipleDefine').datagrid('unselectAll');
		}
		//Modified by QW20191213 begin 需求号:1135903  审批类型及id从前面传过来,保持不变,因此选中不赋值

}

function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

function initMDSourceTypeData()
{
	var MRSourceType = $HUI.combobox('#MDSourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
			id: '0',
			text: '科室'
		},{
			id: '1',
			text: '人员'
		},{
			id: '2',
			text: '角色'
		}]
});
}