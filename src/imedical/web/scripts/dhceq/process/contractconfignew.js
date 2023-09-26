var preRowID=0;
var Columns=getCurColumnsInfo('CON.G.Contract.ContractConfig','','','');
$(function(){
	initUserInfo();
	initMessage("ContractConfig"); 	//��ȡ����ҵ����Ϣ
	defindTitleStyle();
	initLookUp("");
	initButton(); //��ť��ʼ��
	initButtonWidth();
	setRequiredElements("CType_Desc^CCItem^CCVendorDR_VDesc^CCPrice^CCQuantityNum"); //������	Mozy	964414	2019-7-24
	InitButton(false);
	initTypeLookUp();
	initItemLookUp();
	
	//table���ݼ���
	$HUI.datagrid("#DHCEQContractConfig",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQContractConfig",
			QueryName:"GetConfig",
			ContractListDR:getElementValue("CCContractListDR")
		},
		border:false,
	    fit:true,
	    singleSelect:true,
		onClickRow:function(rowIndex,rowData){OnclickRow();},
	    rownumbers: true,  //���Ϊtrue����ʾһ���к���
	    columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
});
function InitButton(isselected)
{
	//Mozy	964346	2019-7-24	��ȡ��ͬ��״̬
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetOneContract","","","","",$('#CCContractListDR').val());
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	//alertShow("CTStatus="+getElementValue("CTStatus"))
	if (getElementValue("CTStatus")>0)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
	else
	{
		//disableElement("BSave",isselected);
		disableElement("BDelete",!isselected);
	}
	if (getElementValue("ReadOnly")==1)   //add by wl 2019-09-30 1031265 
	{ 
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
}
function OnclickRow()
{
	var selected=jQuery('#DHCEQContractConfig').datagrid('getSelected');
	if(selected)
	{
		var selectedrowID=selected.TRowID;
		if(preRowID!=selectedrowID)
		{
			fillData(selectedrowID)
			jQuery("#CCRowID").val(selectedrowID)
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
	jsonData=tkMakeServerCall("web.DHCEQContractConfig","GetOneConfigNew",CRowID);
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	initItemLookUp();
}
function ClearElement()
{
	//alertShow("ClearElement")
	jQuery('#CCRowID').val("");
	jQuery('#CCType').val("");
	jQuery('#CType_Desc').val("");
	jQuery('#CCItemDR_Desc').val("");
	jQuery('#CCItemDR').val("");
	jQuery('#CCItem').val("");
	jQuery('#CCVendorDR').val("");
	jQuery('#CCVendorDR_VDesc').val("");
	jQuery('#CCBrandDR').val("");
	jQuery('#CCBrandDR_Desc').val("");
	jQuery('#CCSpec').val("");
	jQuery('#CCModel').val("");
	jQuery('#CCManuFactoryDR').val("");
	jQuery('#CCManuFactoryDR_MDesc').val("");
	jQuery('#CCPrice').val("");
	jQuery('#CCQuantityNum').val("");
	jQuery('#CCUnitDR').val("");
	jQuery('#CCUnitDR_UOMDesc').val("");
	jQuery('#CCCountryDR').val("");
	jQuery('#CCCountryDR_CDesc').val("");
	jQuery('#CCGuaranteePeriodNum').val("");
	jQuery('#CCParameters').val("");
	jQuery('#CCRemark').val("");
	// Mozy	2019-10-04
	jQuery('#CCLeaveFacNo').val("");
	jQuery('#CCLeaveDate').datebox('setValue',"");
	jQuery('#CCReceiverDR').val("");
	jQuery('#CCReceiverDR_SSUSRName').val("");
	jQuery('#CCRegistrationNo').val("");
	jQuery('#CCInvoiceNo').val("");
	jQuery('#CCGuaranteeStartDate').datebox('setValue',"");
	jQuery('#CCGuaranteeEndDate').datebox('setValue',"");
}
///Lookup���ش���
function setSelectValue(elementID,rowData)
{
	if(elementID=="CType_Desc")
	{
		setElement("CCType",rowData.TRowID);
		initItemLookUp();
	}
	else if(elementID=="CCItemDR_Desc")
	{
		setElement("CCItemDR",rowData.TRowID);
		setElement("CCItemDR_Desc",rowData.TName);
		setElement("CCItem",rowData.TName);
	}
	else if(elementID=="CCVendorDR_VDesc") {setElement("CCVendorDR",rowData.TRowID);}
	else if(elementID=="CCBrandDR_Desc") {setElement("CCBrandDR",rowData.TRowID);}
	else if(elementID=="CCManuFactoryDR_MDesc") {setElement("CCManuFactoryDR",rowData.TRowID);}
	else if(elementID=="CCUnitDR_UOMDesc") {setElement("CCUnitDR",rowData.TRowID);}
	else if(elementID=="CCCountryDR_CDesc") {setElement("CCCountryDR",rowData.TRowID);}
	else if(elementID=="CCReceiverDR_SSUSRName") {setElement("CCReceiverDR",rowData.TRowID);}
}
///���Lookup
function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}
function BSave_Clicked()
{
	if (getElementValue("CCContractListDR")=="")
	{
		$.messager.show({title: '��ʾ',msg: '�����ú�ͬ��ϸ����δ����!'});
		return;
	}
	if (getElementValue("CCType")=="")
	{
		$.messager.show({title: '��ʾ',msg: '�������Ͳ���Ϊ��!'});
		return;
	}
	// Mozy		951093	2019-7-16
	if ((jQuery('#CCItemDR').val()=="")&&(getElementValue("CCType")==1))
	{
		$.messager.show({title: '��ʾ',msg: '�������Ϊ��'});
		return;
	}
	if (getElementValue("CCItem")=="")
	{
		$.messager.show({title: '��ʾ',msg: '���Ʋ���Ϊ��!'});
		return;
	}
	// Mozy		964414	2019-7-24
	if (getElementValue("CCQuantityNum")=="")
	{
		$.messager.show({title: '��ʾ',msg: '����������Ϊ��!'});
		return;
	}
	if (getElementValue("CCPrice")=="")
	{
		$.messager.show({title: '��ʾ',msg: '���۲���Ϊ��!'});
		return;
	}
	if (getElementValue("CCVendorDR")=="")
	{
		$.messager.show({title: '��ʾ',msg: '��Ӧ�̲���Ϊ��!'});
		return;
	}
	var val=CombinData();
	//alertShow(val)
	if (getElementValue("CCRowID")=="")
	{
		if (!window.confirm("ȷ������һ����¼?")) return;
	}
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQContractConfig',
			MethodName:'UpdateData',
			Arg1:val,
			Arg2:0,
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			ErrorMessages(XMLHttpRequest,textStatus,errorThrown);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			$.messager.progress('close');
			data=data.split("^");
			if(data[0]>0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#DHCEQContractConfig').datagrid('reload');
				ClearElement();
				InitButton(false);
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data[0], 'warning');
		}
	});
}
function BDelete_Clicked()
{
	var rowid=jQuery("#CCRowID").val()
	if (rowid=="")
	{
		$.messager.show({title: '��ʾ',msg: 'û��ѡ�м�¼����ɾ��'});
		return;
	}
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQContractConfig',
			MethodName:'UpdateData',
			Arg1:rowid,
			Arg2:2,
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			ErrorMessages(XMLHttpRequest,textStatus,errorThrown);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			$.messager.progress('close');
			//alertShow(data)
			if(data>0)
			{
				$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
				jQuery('#DHCEQContractConfig').datagrid('reload');
				ClearElement();
				InitButton(false);
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}

function CombinData()
{
	var combindata=getElementValue("CCRowID");
	combindata=combindata+"^"+getElementValue("CCContractListDR");
	combindata=combindata+"^"+getElementValue("CCType");
	combindata=combindata+"^"+getElementValue("CCItemDR");
	combindata=combindata+"^"+getElementValue("CCItem");
	combindata=combindata+"^"+getElementValue("CCPrice");
	combindata=combindata+"^"+getElementValue("CCQuantityNum");
	combindata=combindata+"^"+getElementValue("CCUnitDR");
	combindata=combindata+"^"+getElementValue("CCBrandDR");
	combindata=combindata+"^"+getElementValue("CCVendorDR");
	combindata=combindata+"^"+getElementValue("CCManuFactoryDR");
	combindata=combindata+"^"+getElementValue("CCSpec");
	combindata=combindata+"^"+getElementValue("CCModel");
	combindata=combindata+"^"+getElementValue("CCParameters");
	combindata=combindata+"^"+getElementValue("CCCountryDR");
	combindata=combindata+"^"+getElementValue("CCGuaranteePeriodNum");
	combindata=combindata+"^"+getElementValue("CCRemark");
	// Mozy	2019-10-04
	combindata=combindata+"^"+getElementValue("CCLeaveFacNo");
	combindata=combindata+"^"+getElementValue("CCLeaveDate");
	combindata=combindata+"^"+getElementValue("CCReceiverDR");
	combindata=combindata+"^"+getElementValue("CCRegistrationNo");
	combindata=combindata+"^"+getElementValue("CCInvoiceNo");
	combindata=combindata+"^"+getElementValue("CCGuaranteeStartDate");
	combindata=combindata+"^"+getElementValue("CCGuaranteeEndDate");
	
  	return combindata
}
function initTypeLookUp()
{
    var params=[{"name":"FromType","type":"2","value":getElementValue("FromType")}];
    singlelookup("CType_Desc","EM.L.Config.FromType",params,"");
}
function initItemLookUp()
{
    var params=[{"name":"Type","type":"2","value":getElementValue("CCType")},{"name":"Name","type":"1","value":"CCItemDR_Desc"}];
    singlelookup("CCItemDR_Desc","EM.L.Config.Item",params,"");
}