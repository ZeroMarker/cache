$(function(){
	setRequiredElements("EQItemDR_MIDesc^EQUseLocDR_CTLOCDesc^EQEquipTypeDR_ETDesc")  //modified by wy 2020-3-31 需求1249945
	initDocument();
	
});

function initDocument()
{
	initUserInfo();
	//add by csj 2020-02-11 标准版-简易台账泛类使用科室非必填修改
	$("#EQClassFlag").checkbox({
		onCheckChange:function(e,v){
			setItemRequire("EQUseLocDR_CTLOCDesc",!v)
		}
	})
	fillData();
	initLookUp();
	initMessage();  //add by lmm 2019-09-09
	var paramsFrom=[{"name":"EquipTypeDR","type":"2","value":""},{"name":"StatCatDR","type":"2","value":""},{"name":"Name","type":"2","value":""},{"name":"AssetType","type":"1","value":""},{"name":"MaintFlag","type":"2","value":"1"}];
    singlelookup("EQItemDR_MIDesc","EM.L.GetMasterItem",paramsFrom,""); //设备项加载
	defindTitleStyle();
	initButton();
	setEnabled();
	initEquipAttributeList();  /// modify by zc0054 2019-12-02 设备属性初始化
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
}

///Description: 获取台账信息并加载
function fillData()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','错误',jsonData.Data,'','','');return;}
	setElementByJson(jsonData.Data);
}

///Input: vElementID LookUp元素ID  rowData 选中列数据
function setSelectValue(elementID,rowData)
{
	if(elementID=="EQCountryDR_CTCOUDesc") {setElement("EQCountryDR",rowData.TRowID)}
	else if(elementID=="EQModelDR_MDesc") {setElement("EQModelDR",rowData.TRowID)}
	else if(elementID=="EQUnitDR_UOMDesc") {setElement("EQUnitDR",rowData.TRowID)}
	else if(elementID=="EQManuFactoryDR_MFName") {setElement("EQManuFactoryDR",rowData.TRowID)}
	else if(elementID=="EQPurposeTypeDR_PTDesc") {setElement("EQPurposeTypeDR",rowData.TRowID)}
	else if(elementID=="EQOriginDR_ODesc") {setElement("EQOriginDR",rowData.TRowID)}
	else if(elementID=="EQEquiCatDR_ECDesc") {setElement("EQEquiCatDR",rowData.TRowID)}
	else if(elementID=="EQBuyTypeDR_BTDesc") {setElement("EQBuyTypeDR",rowData.TRowID)}
	else if(elementID=="EQPurchaseTypeDR_PTDesc") {setElement("EQPurchaseTypeDR",rowData.TRowID)}
	else if(elementID=="EQProviderDR_VName") 
	{
		setElement("EQProviderDR",rowData.TRowID)
		setElement("EQProviderHandler",rowData.TContPerson)
		setElement("EQProviderTel",rowData.TTel)	
	}
	else if(elementID=="EQLocationDR_LDesc") {setElement("EQLocationDR",rowData.TRowID)}
	else if(elementID=="EQKeeperDR_SSUSRName") {setElement("EQKeeperDR",rowData.TRowID)}
	else if(elementID=="EQUseLocDR_CTLOCDesc") {setElement("EQUseLocDR",rowData.TRowID);setElement("EQStoreLocDR",rowData.TRowID)}
	else if(elementID=="EQItemDR_MIDesc") {getMasterItem(rowData)}
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}

///Description: 数据保存方法
function BSave_Clicked()
{
	// add by zx 2019-06-11 消息提示未定义暂时处理方式
	//modify by lmm 2019-09-09
	if (checkMustItemNull()) return;
	/*
	if (getElementValue("EQItemDR")=="")
	{
		messageShow("","","","资产名称不能为空!");
		return
	}
	if (getElementValue("EQUseLocDR")=="")
	{
		messageShow("","","","使用部门不能为空!");
		return
	}
	*/
	setModelRowID(getElementValue("ModelOperMethod")); //add by zx 2019-01-22 简易台账机型保存
	var data=getInputList();
	data=JSON.stringify(data);
	/// modify by zc0054 2019-12-02 begin 设备属性相关调整
    var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	for (var j=0;j<i;j++)
	{
		if(EquipAttributeString=="")
		{
			EquipAttributeString=SelectType[j].id
		}else
		{
			EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data,EquipAttributeString);
	/// modify by zc0054 2019-12-02 end 设备属性相关调整
	jsonData=jQuery.parseJSON(jsonData);
	// Mozy0241	1142519		2019-12-25	调整返回结果处置
	if (jsonData.SQLCODE<0) 
	{messageShow('alert','error','错误',jsonData.Data,'','','');return;}
	else
	{
	messageShow('alert','info','提示',"保存成功","","","") 
	window.location.href= "dhceq.em.equipfacility.csp?RowID="+jsonData.Data;
	}
}
function confirmFun(){ 
	var url="dhceq.em.equipfacility.csp?RowID="+jsonData.Data;
	window.location.href= url;
}

function getMasterItem(rowData)
{
	setElement("EQItemDR_MIDesc",rowData.TName)
	setElement("EQItemDR",rowData.TRowID)
	setElement("EQEquipTypeDR_ETDesc",rowData.TEquipType)
	setElement("EQEquipTypeDR",rowData.TEquipTypeDR)
	setElement("EQStatCatDR_SCDesc",rowData.TStatCat)
	setElement("EQStatCatDR",rowData.TStatCatDR)
	setElement("EQEquiCatDR_ECDesc",rowData.TCat)
	setElement("EQEquiCatDR",rowData.TCatDR)
	setElement("EQName",rowData.TName)
	setElement("EQCode",rowData.TCode)
	setElement("EQUnitDR_UOMDesc",rowData.TUnit)
	setElement("EQUnitDR",rowData.TUnitDR)
	/// modify by zc0054 2019-12-02 begin设备属性相关调整
	var CodeString=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","GetOneEquipAttribute","1",rowData.TRowID)
	$("#EquipAttributeList").keywords("clearAllSelected")
	if (CodeString!="")
	{
		var list=CodeString.split("^");
		var i=list.length;
		for (var j=0;j<i;j++)
		{
			$("#EquipAttributeList").keywords("select",list[j]);
		}
	}
	/// modify by zc0054 2019-12-02 end 设备属性相关调整
}
function setEnabled()
{
	var RowID=getElementValue("EQRowID");
	if(RowID=="")
	{
		disableElement("BDelete",true);
	}
}

function BDelete_Clicked()
{  
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){    
    		setElement("EQInvalidFlag","true");
			var data=getInputList();
			data=JSON.stringify(data);
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data,""); //modfied by wy 2019-12-16 需求1136221
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow('alert','error','错误',jsonData.Data,'','','');return;}
			messageShow('alert','success','提示','删除成功','','','');
			var url="dhceq.em.equipfacility.csp?RowID=";
			window.location.href= url;
   	 	}    
	});
}

//add by zx 2019-01-22 简易台账机型保存
function setModelRowID(type)
{
	if((type=="0")||(type==""))
	{
		setElement("EQModelDR","");
	}
	else
	{
		var modelDesc=getElementValue("EQModelDR_MDesc");
		if (modelDesc=="") return;
		var data=modelDesc+"^"+getElementValue("EQOriginalFee");
		var item=getElementValue("EQItemDR");
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTModel","UpdModel",data, item);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("EQModelDR",jsonData.Data);
	}
}
/// modify by zc0054 2019-12-02 设备属性初始化
///加载设备属性关键字列表
function initEquipAttributeList()
{
	var result=""
	if(getElementValue("EQRowID")!="")
	{
		var result=getElementValue("EQRowID");
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ReturnJsonEquipAttribute",result)
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
        $("#EquipAttributeList").keywords({
                items:string
        });
    $("#EquipAttributeList").parent().height($("#EquipAttributeList").height())	//add by csj 2020-03-26 需求号：1238681
}