var preRowID=0;
var Columns=getCurColumnsInfo('EM.G.Config.EquipList','','','');
$(function(){
	initUserInfo();
	initMessage("Config"); 	//获取所有业务消息
	defindTitleStyle();
	initLookUp("");
	initButton(); //按钮初始化
	initButtonWidth();
	// Mozy0255	1190551		2020-3-6	取消类型值设置
   	setElement("CType",1);
   	setRequiredElements("CItemDR_Desc^CQuantityNum^CPrice^MIEquipTypeDR_ETDesc^MIStatCatDR_SCDesc^MIEquipCatDR_ECDesc^CUnitDR_UOMDesc^CProviderDR_VDesc"); //czf 2022-04-19		MZY0078		1959107		2021-05-31
	InitButton(false);
	initTypeLookUp();
	initItemLookUp();
	setProvider();		// Mozy0255	1190551		2020-3-6
	hiddenObj("BSubmit",true);	//czf 2022-11-04
	//czf 2022-04-19 begin
	var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//是否新窗口打开分类树
	if (!+CatShow)
	{
		initEquipCatTree();
	}
	else
	{
		singlelookup("MIEquipCatDR_ECDesc","EM.L.EquipCat",[{name:"Desc",type:1,value:"MIEquipCatDR_ECDesc"},{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{"name":"EditFlag","type":"2","value":"1"}])
	}
	//czf 2022-04-20 end
	
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
	    singleSelect:true,
		onClickRow:function(rowIndex,rowData){OnclickRow();},
	    rownumbers: true,  //如果为true则显示一个行号列
	    columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
		// Mozy0255	1190551		2020-3-6	取消隐藏列设置
	});
});

function initEquipCatTree()
{
	var EquipeCatTree=$.m({
		    ClassName:"web.DHCEQ.Plat.LIBTree",
		    MethodName:"GetEquipeCatTreeStr"
		},false);
		
	var cbtree = $HUI.combotree('#MIEquipCatDR_ECDesc',{
		panelWidth:400,
		panelHeight:400,
		editable:true,
		onChange: function (newValue, oldValue) {
			setElement("MIEquipCatDR",newValue);
		}
		});
	cbtree.loadData(JSON.parse(EquipeCatTree));
}

function InitButton(isselected)
{
	var Status=+jQuery("#Status").val();
	
	if (Status>0)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
	}
	else
	{
		disableElement("BSave",isselected);
		disableElement("BDelete",!isselected);
		disableElement("BSubmit",!isselected);
	}
	//Mozy	1012394	2019-8-28
	var ReadOnly=+jQuery("#ReadOnly").val();
	if (ReadOnly==1)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
	}
}

function OnclickRow()
{
	var selected=jQuery('#DHCEQConfig').datagrid('getSelected');
	if(selected)
	{
		var selectedrowID=selected.TRowID;
		var Status=selected.TStatus;
		var SourceType=selected.TSourceType;
		
		if(preRowID!=selectedrowID)
		{
			fillData(selectedrowID)
			jQuery("#CRowID").val(selectedrowID)
			preRowID=selectedrowID;
			if (SourceType=="2")
			{
				hiddenObj("BSubmit",false);
				if (Status=="审核") //已经审核，不能重复提交，不能删除
				{
					disableElement("BSave",true);
					disableElement("BSubmit",true);
					disableElement("BDelete",true);
				}
				else
				{
					disableElement("BSave",false);
					disableElement("BSubmit",false);
					disableElement("BDelete",false);
				}
			}
			else
			{
				disableElement("BSave",false);
				disableElement("BSubmit",false);
				disableElement("BDelete",false);
			}
		}		
		else
		{
			ClearElement();
			selectedrowID = 0;
			preRowID=0;
			InitButton(false);
			// // Mozy0255	1190551		2020-3-6
			//if (getElementValue("FromType")==0)
			//{
			//	setElement("CType_Desc","附属设备");	//初始化默认值
		    	//setElement("CType",1);
			//}
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
	
	//czf 2022-04-19 begin
	var jObj=$("#MIEquipCatDR_ECDesc")
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',jsonData.Data.MIEquipCatDR);
		var t = $("#MIEquipCatDR_ECDesc").combotree('tree');
		var node = t.tree('find',jsonData.Data.MIEquipCatDR);
		if (node!=null)
		{
			expandParent(t,node);
			t.tree("scrollTo",node.target);
		}
	}
	else
	{
		setElement("MIEquipCatDR_ECDesc",jsonData.Data.MIEquipCatDR_ECDesc);
	}
	//czf 2022-04-19 end
	
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
	// Mozy0255	1190551		2020-3-6
	//jQuery('#CType').val("");
	//jQuery('#CType_Desc').val("");
	jQuery('#CItemDR_Desc').val("");
	jQuery('#CItemDR').val("");
	jQuery('#CItem').val("");
	// MZY0154	3256218		2023-03-03
	jQuery('#CProviderDR').val("");
	jQuery('#CProviderDR_VDesc').val("");
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
	if (getElementValue("FromType")!=1) jQuery('#CLeaveDate').datebox('setValue',"");	// Mozy0246	2020-1-22
	jQuery('#CLocation').val("");
	jQuery('#CGuaranteePeriodNum').val("");
	setElement("CMeasureFlag",0);
	jQuery('#CReceiverDR').val("");
	jQuery('#CReceiverDR_SSUSRName').val("");
	jQuery('#CLeaveFacNo').val("");
	jQuery('#CParameters').val("");
	jQuery('#CRemark').val("");
	jQuery('#CInvoiceNo').val("");
	
	//czf 2022-04-19 begin
	setElement("MIEquipTypeDR_ETDesc","");
	setElement("MIEquipTypeDR","");
	setElement("MIEquipCatDR","");		
	var jObj=$("#MIEquipCatDR_ECDesc")
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',""); 
		var t = $("#MIEquipCatDR_ECDesc").combotree('tree');
		collapseAllNode(t);
	}
	else
	{
		setElement("MIEquipCatDR_ECDesc","");
	}
	setElement("MIStatCatDR","");
	setElement("MIStatCatDR_SCDesc","");
	setElement("CRegisterNo","");
	setElement("CRecomendYears","");
	//czf 2022-04-19 end
	
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
	else if(elementID=="CItemDR_Desc")
	{
		setElement("CItemDR",rowData.TRowID);
		setElement("CItemDR_Desc",rowData.TName);
		setElement("CItem",rowData.TName);
		setElement("CUnitDR",rowData.TUOMDR);
		setElement("CUnitDR_UOMDesc",rowData.TUOM);
		//czf 2022-04-19 begin
		setElement("MIEquipTypeDR_ETDesc",rowData.TEquipType);
		setElement("MIEquipTypeDR",rowData.TEquipTypeDR);
		setElement("MIStatCatDR_SCDesc",rowData.TStatCat);
		setElement("MIStatCatDR",rowData.TStatCatDR);
		setElement("MIEquipCatDR",rowData.TEquipCatDR);
		var jObj=$("#MIEquipCatDR_ECDesc")
		var objClassInfo=jObj.prop("class")
		if (objClassInfo.indexOf("combotree")>=0){
			jObj.combotree('setValue',rowData.TEquipCatDR);
			var t = $("#MIEquipCatDR_ECDesc").combotree('tree');
			var node = t.tree('find', rowData.TEquipCatDR);
			if (node!=null)
			{
				expandParent(t,node);
				t.tree("scrollTo",node.target);
			}
		}
		else
		{
			setElement("MIEquipCatDR_ECDesc",rowData.TEquipCat);
		}
		//czf 2022-04-19 end
	}
	else if(elementID=="CProviderDR_VDesc") {setElement("CProviderDR",rowData.TRowID);}
	else if(elementID=="CBrandDR_Desc") {setElement("CBrandDR",rowData.TRowID);}
	else if(elementID=="CManuFactoryDR_MDesc") {setElement("CManuFactoryDR",rowData.TRowID);}
	else if(elementID=="CUnitDR_UOMDesc") {setElement("CUnitDR",rowData.TRowID);}
	else if(elementID=="CCountryDR_CDesc") {setElement("CCountryDR",rowData.TRowID);}
	else if(elementID=="CReceiverDR_SSUSRName") {setElement("CReceiverDR",rowData.TRowID);}
	else
	{
		setDefaultElementValue(elementID,rowData);		//czf 2022-04-19
	}
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
	//czf 2022-04-19 begin
	if(getElementValue("MIEquipTypeDR")==""){
		$.messager.show({title: '提示',msg: '管理类组不能为空!'});
		return;
	}
	if(getElementValue("MIStatCatDR")==""){
		$.messager.show({title: '提示',msg: '设备类型不能为空!'});
		return;
	}
	if(getElementValue("MIEquipCatDR")==""){
		$.messager.show({title: '提示',msg: '设备分类不能为空!'});
		return;
	}
	if(getElementValue("CUnitDR")==""){
		$.messager.show({title: '提示',msg: '单位不能为空!'});
		return;
	}
	if (getElementValue("CItemDR_Desc")=="")
	{
		$.messager.show({title: '提示',msg: '设备项名称不能为空!'});
		return;
	}
	if (getElementValue("CItem")=="") setElement("CItem",getElementValue("CItemDR_Desc"))
	//czf 2022-04-19 end
	// Mozy0246	2020-1-22
	if ((getElementValue("CQuantityNum")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '总数量不能为空!'});
		return;
	}
	if ((getElementValue("CPrice")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '单价不能为空!'});
		return;
	}
	if (getElementValue("CProviderDR")=="")
	{
		var providerName=getElementValue("CProviderDR_VDesc");
		if (providerName!="")
		{
			var FirmType=2
		 	var val="^"+providerName+"^^^"+FirmType;
			var ProviderRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
			if (ProviderRowID>0) setElement("CProviderDR",ProviderRowID);
		}
	}
	if ((getElementValue("CProviderDR")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '供应商不能为空!'});
		return;
	}
	if (getElementValue("CManuFactoryDR")=="")
	{
		var manuFactoryName=getElementValue("CManuFactoryDR_MDesc");
		if (manuFactoryName!="")
		{
			var FirmType=3;
		 	var val="^"+manuFactoryName+"^^^"+FirmType;
			var ManuFactoryRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
			if (ManuFactoryRowID>0) setElement("CManuFactoryDR",ManuFactoryRowID);
		}
	}
	if (getElementValue("CBrandDR")=="")
	{
		var brand=getElementValue("CBrandDR_Desc");
		if (brand!="")
		{
		 	var val="^"+brand;
			var brandID=tkMakeServerCall("web.DHCEQCBrand","UpdBrand",val);
			if (brandID>0) setElement("CBrandDR",brandID);
		}
	}
	///modified by ZY0243 20200917 
	DoSave();
	/*	
	if (getElementValue("CRowID")=="")
	{
		messageShow("confirm","","","确定新增一条记录?","",DoSave);
	}
	else
	{
		DoSave();
	}
	*/
}
function DoSave()
{
	//保存设备项信息
	//czf 2022-04-19 begin
	if (getElementValue("CItemDR")=="")
	{
	  	var masterinfo="";
	    masterinfo=getElementValue("CItemDR") ;
		masterinfo=masterinfo+"^"+getElementValue("CItemDR_Desc") ;
	  	masterinfo=masterinfo+"^";	//+getElementValue("MICode") ; 
	  	masterinfo=masterinfo+"^"+getElementValue("MIEquipTypeDR") ;
	  	masterinfo=masterinfo+"^"+getElementValue("MIEquipCatDR") ;
	  	masterinfo=masterinfo+"^"+getElementValue("MIStatCatDR") ;
	  	masterinfo=masterinfo+"^";		//+getElementValue("MIRemark") ;
	  	masterinfo=masterinfo+"^"+getElementValue("CUnitDR") ; 
	  	var masterid=tkMakeServerCall("web.DHCEQCMasterItem","SaveData",'','',masterinfo,"","");
		masterid=masterid.replace(/\\n/g,"\n")
		if (masterid>0) setElement("CItemDR",masterid)
		else
		{
			alertShow("设备项自动保存失败!"+masterid)
			return
		}
	}
	if ((jQuery('#CItemDR').val()=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '提示',msg: '设备项不能为空'});
		return;
	}
  	//czf 2022-04-19 end
  	
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
				///modified by ZY0243 20200917 
				$.messager.alert('保存失败！','错误代码:'+data[0]+","+data[1], 'warning');
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
	messageShow("confirm","info","提示","是否确认删除？","",function(){
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

	},function(){
		return;
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
	combindata=combindata+"^"	//30 Status
	combindata=combindata+"^"	//31 ServiceHandler
	combindata=combindata+"^"	//32 ServiceTel
	combindata=combindata+"^"+getElementValue("CRegisterNo");	//czf 2022-09-14 33 
	combindata=combindata+"^"+getElementValue("CRecomendYears"); //34
  	
  	return combindata
}
function initTypeLookUp()
{
    var params=[{"name":"FromType","type":"2","value":getElementValue("FromType")}];
    singlelookup("CType_Desc","EM.L.Config.FromType",params,"");
}
function initItemLookUp()
{
    var params=[{"name":"Type","type":"2","value":getElementValue("CType")},{"name":"Name","type":"1","value":"CItemDR_Desc"}];
    singlelookup("CItemDR_Desc","EM.L.Config.Item",params,"");
}
// Mozy0255	1190551		2020-3-6	设置默认供应商
function setProvider()
{
	///modified by ZY0275 20210712
	var Data=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","GetCheckRequestProvider",getElementValue("OCRRowID"));
	var ProviderList=Data.split("^");
	setElement("CProviderDR",ProviderList[0]);
	setElement("CProviderDR_VDesc",ProviderList[1]);
}

///czf 2022-04-19 begin
///根据叶子节点展开所有父节点
function expandParent(treeObj, curnode)
{
    var parentNode = treeObj.tree("getParent", curnode.target);
    if(parentNode != null && parentNode != "undefined"){
	    treeObj.tree("expand", parentNode.target);
	    expandParent(treeObj, parentNode);
    }
    else
    {
	    treeObj.tree("expand", curnode.target);
	}
}

///czf 2022-04-19 begin
///返回当前节点的首级节点
function getFirstTreeNode(treeObj, curnode)
{
	var parentNode = treeObj.tree("getParent", curnode.target);
	if(parentNode != null && parentNode != "undefined"){
    	return getFirstTreeNode(treeObj, parentNode);
    }
    else
    {
    	return curnode;
    }
}

///czf 2022-04-19 begin
//折叠所有节点
function collapseAllNode(treeObj)
{
	var roots=treeObj.tree("getRoots");
    for(var j=0; j<roots.length; j++){
        var rootnode=roots[j];
        if(rootnode!=null&& rootnode != "undefined")
        {
            treeObj.tree("collapseAll",rootnode.target);
        }
    }
}

function BSubmit_Clicked()
{
	var rowid=getElementValue("CRowID");
	if (rowid=="")
	{
		messageShow('alert','alert','提示','请先选中行记录！');
		return;
	}
	messageShow("confirm","info","提示","提交后不能修改，是否确认提交？","",function(){
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSConfig","SubmitData",rowid);
		jsonData=JSON.parse(jsonData)
		
		if (jsonData.SQLCODE==0)
		{
			messageShow('alert','success','提示',"操作成功!");
			$('#DHCEQConfig').datagrid('reload');
			ClearElement();
			InitButton(false);
			websys_showModal("options").mth();
		}
		else
	    {
			messageShow('alert','error','提示',"提交失败!错误信息:"+jsonData.Data);
			return
	    }
	},function(){
		return;
	})
	
}
