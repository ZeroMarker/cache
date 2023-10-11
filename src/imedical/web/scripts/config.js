var preRowID=0;
var Columns=getCurColumnsInfo('EM.G.Config.EquipConfig','','','');
$(function(){
	initUserInfo();
	initMessage("Config"); 	//获取所有业务消息
	defindTitleStyle();
	initLookUp("");
	initButton(); //按钮初始化
	initButtonWidth();
	setRequiredElements("CType_Desc^CItem"); //必填项
	InitButton(false);
	initTypeLookUp();
	initItemLookUp();
	setProvider();		// Mozy003003	1237348		2020-3-27
	
	//table数据加载
	$HUI.datagrid("#DHCEQConfig",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSConfig",
			QueryName:"GetConfig",
			Type:getElementValue("CType"),
			SourceType:getElementValue("CSourceType"),
			SourceID:getElementValue("CSourceID"),
			Flag:getElementValue("FromType")
		},
		border:false,
	    fit:true,
	    fitColumns:true,   //add by lmm 2020-06-02
	    singleSelect:true,
		onClickRow:function(rowIndex,rowData){OnclickRow();},
	    rownumbers: true,  //如果为true则显示一个行号列
	    columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			// MZY0069	1728850		2021-02-18	设置隐藏列
			if (getElementValue("CSourceType")!=2)
			{
				$("#DHCEQConfig").datagrid("hideColumn", "TAppendFlag");
			}
		}
	});
});
function InitButton(isselected)
{
	var Status=+jQuery("#Status").val();
	//alertShow(Status)
	if (Status>0)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
	else
	{
		//disableElement("BSave",isselected);
		disableElement("BDelete",!isselected);
	}
	var ReadOnly=+jQuery("#ReadOnly").val();
	if (ReadOnly==1)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
}
function OnclickRow()
{
	var selected=jQuery('#DHCEQConfig').datagrid('getSelected');
	if(selected)
	{
		var selectedrowID=selected.TRowID;
		if(preRowID!=selectedrowID)
		{
			fillData(selectedrowID)
			jQuery("#CRowID").val(selectedrowID)
			preRowID=selectedrowID;
			InitButton(true);
		}		
		else
		{
			ClearElement();
			selectedrowID = 0;
			preRowID=0;
			InitButton(false);
		}
	}
}
function fillData(CRowID)
{
	if (CRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSConfig","GetOneConfigNew",CRowID);
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	initItemLookUp();
	if (getElementValue("COpenFlag")==1)
	{
		jQuery('#COpenFlag').val("Y");
	}
	else
	{
		jQuery('#COpenFlag').val("N");
	}
}
function ClearElement()
{
	//alertShow("ClearElement")
	jQuery('#CRowID').val("");
	jQuery('#CType').val("");
	jQuery('#CType_Desc').val("");
	jQuery('#CItemDR_Desc').val("");
	jQuery('#CCItemDR_Desc').val("");	// MZY0061	1610256		2020-12-2
	jQuery('#CItemDR').val("");
	jQuery('#CItem').val("");
	// Mozy003003	1237348		2020-3-27	取消清空供应商信息
	//jQuery('#CProviderDR').val("");
	//jQuery('#CProviderDR_VDesc').val("");
	jQuery('#CBrandDR').val("");
	jQuery('#CBrandDR_Desc').val("");
	jQuery('#CSpec').val("");
	jQuery('#CModel').val("");
	jQuery('#CManuFactoryDR').val("");
	jQuery('#CManuFactoryDR_MDesc').val("");
	jQuery('#CPrice').val("");
	jQuery('#CQuantityNum').val("");
	jQuery('#CUnitDR').val("");
	jQuery('#CUnitDR_UOMDesc').val("");
	jQuery('#CCountryDR').val("");
	jQuery('#CCountryDR_CDesc').val("");
	if (getElementValue("FromType")!=1) jQuery('#CLeaveDate').datebox('setValue',"");
	jQuery('#CLocation').val("");
	jQuery('#CGuaranteePeriodNum').val("");
	setElement("CMeasureFlag",0);
	jQuery('#CReceiverDR').val("");
	jQuery('#CReceiverDR_SSUSRName').val("");
	jQuery('#CLeaveFacNo').val("");
	jQuery('#CParameters').val("");
	jQuery('#CRemark').val("");
	jQuery('#CInvoiceNo').val("");
	//jQuery('#GuaranteeStartDate').datebox('setValue',list[43]);
	//jQuery('#GuaranteeEndDate').datebox('setValue',list[44]);
	//SetCheckValue("DisuseFlag",list[23]);
	//jQuery('#DisuseFlag').val(list[23]);
	//jQuery('#DisuseDate').datebox('setValue',list[24]);
	//jQuery('#COpenFlag').val(list[26]);
}
///Lookup返回处理
function setSelectValue(elementID,rowData)
{
	if(elementID=="CType_Desc")
	{
		setElement("CType",rowData.TRowID);
		initItemLookUp();
	}
	else if(elementID=="CCItemDR_Desc")
	{
		// MZY0061	1610256		2020-12-2
		setElement("CItemDR",rowData.TRowID);
		setElement("CItemDR_Desc",rowData.TName);
		setElement("CItem",rowData.TName);
		setElement("CUnitDR_UOMDesc",rowData.TUOM);
		setElement("CUnitDR",rowData.TUOMDR);
	}
	else if(elementID=="CProviderDR_VDesc") {setElement("CProviderDR",rowData.TRowID);}
	else if(elementID=="CBrandDR_Desc") {setElement("CBrandDR",rowData.TRowID);}
	else if(elementID=="CManuFactoryDR_MDesc") {setElement("CManuFactoryDR",rowData.TRowID);}
	else if(elementID=="CUnitDR_UOMDesc") {setElement("CUnitDR",rowData.TRowID);}
	else if(elementID=="CCountryDR_CDesc") {setElement("CCountryDR",rowData.TRowID);}
	else if(elementID=="CReceiverDR_SSUSRName") {setElement("CReceiverDR",rowData.TRowID);}
}
///清空Lookup
function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}
function BSave_Clicked()
{
	if (getElementValue("CType")=="")
	{
		$.messager.show({title: '提示',msg: '配置类型不能为空!'});
		return;
	}
	/*if ((jQuery('#CItemDR').val()=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '配置项不能为空'});
		return;
	}*/
	if (getElementValue("CItem")=="")
	{
		$.messager.show({title: '提示',msg: '名称不能为空!'});
		return;
	}
	/*if ((getElementValue("CQuantityNum")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '总数量不能为空!'});
		return;
	}
	if ((getElementValue("CPrice")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '单价不能为空!'});
		return;
	}
	if ((getElementValue("CProviderDR")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '供应商不能为空!'});
		return;
	}*/
	// MZY0061	1610256		2020-12-2
	if ((getElementValue("CManuFactoryDR")=="")&&(getElementValue("CManuFactoryDR_MDesc")!=""))
	{
		var val=getPYCode(getElementValue("CManuFactoryDR_MDesc"))+"^"+getElementValue("CManuFactoryDR_MDesc")+"^^^3";
		var CManuFactoryDR=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if (CManuFactoryDR=="")
		{
			messageShow('alert','error','错误提示','生产厂家异常!');
			return;
		}
		else
			setElement("CManuFactoryDR",CManuFactoryDR);
	}
	/* MZY0144	3080974		2022-11-24	取消提示信息
	if (getElementValue("CRowID")=="")
	{
		messageShow("confirm","","","确定新增一条记录?","",DoSave);
	}
	else
	{
		DoSave();
	}*/
	DoSave();
}
function DoSave()
{
	var val=CombinData();
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.EM.BUSConfig',
			MethodName:'SaveData',
			Arg1:val,
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			ErrorMessages(XMLHttpRequest,textStatus,errorThrown);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			$.messager.progress('close');
			data=data.split("^");
			if(data[0]==0)
			{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#DHCEQConfig').datagrid('reload');
				ClearElement();
				InitButton(false);
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data[0], 'warning');
		}
	});
}
function BDelete_Clicked()
{
	var rowid=jQuery("#CRowID").val()
	if (rowid=="")
	{
		$.messager.show({title: '提示',msg: '没有选中记录不能删除'});
		return;
	}
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.EM.BUSConfig',
			MethodName:'DeleteData',
			Arg1:rowid,
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			ErrorMessages(XMLHttpRequest,textStatus,errorThrown);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			$.messager.progress('close');
			//alertShow(data)
			if(data==0)
			{
				$.messager.show({title: '提示',msg: '删除成功'});
				jQuery('#DHCEQConfig').datagrid('reload');
				ClearElement();
				InitButton(false);
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
}

function CombinData()
{
	var combindata=getElementValue("CRowID");
	combindata=combindata+"^"+getElementValue("CType");
	combindata=combindata+"^"+getElementValue("CSourceType");
	combindata=combindata+"^"+getElementValue("CSourceID");
	combindata=combindata+"^"+getElementValue("CItemDR");
	combindata=combindata+"^"+getElementValue("CItem");
	combindata=combindata+"^"+getElementValue("CPrice");
	combindata=combindata+"^"+getElementValue("CQuantityNum");
	combindata=combindata+"^"+getElementValue("CUnitDR");
	combindata=combindata+"^"+getElementValue("CBrandDR");
	combindata=combindata+"^"+getElementValue("CProviderDR");
	combindata=combindata+"^"+getElementValue("CManuFactoryDR");
	combindata=combindata+"^"+getElementValue("CSpec");
	combindata=combindata+"^"+getElementValue("CModel");
	combindata=combindata+"^"+getElementValue("CParameters");
	combindata=combindata+"^"+getElementValue("CGuaranteePeriodNum");
	combindata=combindata+"^"+getElementValue("CCountryDR");
	combindata=combindata+"^"+getElementValue("CLeaveFacNo");
	combindata=combindata+"^"+getElementValue("CLeaveDate");
	combindata=combindata+"^"+getElementValue("CLocation");
	combindata=combindata+"^"+getElementValue("CReceiverDR");
	combindata=combindata+"^";
	if (getElementValue("CMeasureFlag")==true)
	{
		combindata=combindata+"Y";
	}
	else
	{
		combindata=combindata+"N";
	}
	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
	combindata=combindata+"^"+getElementValue("CInvoiceNo");
	combindata=combindata+"^"+getElementValue("COpenFlag");
	combindata=combindata+"^"+getElementValue("CRemark");

  	return combindata
}
function initTypeLookUp()
{
    var params=[{"name":"FromType","type":"2","value":getElementValue("FromType")}];
    singlelookup("CType_Desc","EM.L.Config.FromType",params,"");
}
function initItemLookUp()
{
	// MZY0061	1610256		2020-12-2
    var params=[{"name":"Type","type":"2","value":getElementValue("CType")},{"name":"Name","type":"1","value":"CCItemDR_Desc"}];
    singlelookup("CCItemDR_Desc","EM.L.Config.Item",params,"");
}
// MZY0026	1320845		2020-05-20	修正增加台账设备设置默认供应商
function setProvider()
{
	var Data="";
	if (getElementValue("CSourceType")==1)
	{
		Data=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","GetCheckRequestProvider",getElementValue("CSourceID"));
	}
	if (getElementValue("CSourceType")==2)
	{
		Data=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","GetEquipProvider",getElementValue("CSourceID"));
	}
	var ProviderList=Data.split("^");
	setElement("CProviderDR",ProviderList[0]);
	setElement("CProviderDR_VDesc",ProviderList[1]);
}
