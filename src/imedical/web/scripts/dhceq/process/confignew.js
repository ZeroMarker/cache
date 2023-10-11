var preRowID=0;
var Columns=getCurColumnsInfo('EM.G.Config.EquipList','','','');
$(function(){
	initUserInfo();
	initMessage("Config"); 	//��ȡ����ҵ����Ϣ
	defindTitleStyle();
	initLookUp("");
	initButton(); //��ť��ʼ��
	initButtonWidth();
	// Mozy0255	1190551		2020-3-6	ȡ������ֵ����
   	setElement("CType",1);
   	setRequiredElements("CItemDR_Desc^CQuantityNum^CPrice^MIEquipTypeDR_ETDesc^MIStatCatDR_SCDesc^MIEquipCatDR_ECDesc^CUnitDR_UOMDesc^CProviderDR_VDesc"); //czf 2022-04-19		MZY0078		1959107		2021-05-31
	InitButton(false);
	initTypeLookUp();
	initItemLookUp();
	setProvider();		// Mozy0255	1190551		2020-3-6
	hiddenObj("BSubmit",true);	//czf 2022-11-04
	//czf 2022-04-19 begin
	var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//�Ƿ��´��ڴ򿪷�����
	if (!+CatShow)
	{
		initEquipCatTree();
	}
	else
	{
		singlelookup("MIEquipCatDR_ECDesc","EM.L.EquipCat",[{name:"Desc",type:1,value:"MIEquipCatDR_ECDesc"},{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{"name":"EditFlag","type":"2","value":"1"}])
	}
	//czf 2022-04-20 end
	
	//table���ݼ���
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
	    rownumbers: true,  //���Ϊtrue����ʾһ���к���
	    columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
		// Mozy0255	1190551		2020-3-6	ȡ������������
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
				if (Status=="���") //�Ѿ���ˣ������ظ��ύ������ɾ��
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
			//	setElement("CType_Desc","�����豸");	//��ʼ��Ĭ��ֵ
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
		messageShow('alert','error','������ʾ',jsonData.Data)
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
///Lookup���ش���
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
///���Lookup
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
		$.messager.show({title: '��ʾ',msg: '�������Ͳ���Ϊ��!'});
		return;
	}
	//czf 2022-04-19 begin
	if(getElementValue("MIEquipTypeDR")==""){
		$.messager.show({title: '��ʾ',msg: '�������鲻��Ϊ��!'});
		return;
	}
	if(getElementValue("MIStatCatDR")==""){
		$.messager.show({title: '��ʾ',msg: '�豸���Ͳ���Ϊ��!'});
		return;
	}
	if(getElementValue("MIEquipCatDR")==""){
		$.messager.show({title: '��ʾ',msg: '�豸���಻��Ϊ��!'});
		return;
	}
	if(getElementValue("CUnitDR")==""){
		$.messager.show({title: '��ʾ',msg: '��λ����Ϊ��!'});
		return;
	}
	if (getElementValue("CItemDR_Desc")=="")
	{
		$.messager.show({title: '��ʾ',msg: '�豸�����Ʋ���Ϊ��!'});
		return;
	}
	if (getElementValue("CItem")=="") setElement("CItem",getElementValue("CItemDR_Desc"))
	//czf 2022-04-19 end
	// Mozy0246	2020-1-22
	if ((getElementValue("CQuantityNum")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '��ʾ',msg: '����������Ϊ��!'});
		return;
	}
	if ((getElementValue("CPrice")=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '��ʾ',msg: '���۲���Ϊ��!'});
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
		$.messager.show({title: '��ʾ',msg: '��Ӧ�̲���Ϊ��!'});
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
		messageShow("confirm","","","ȷ������һ����¼?","",DoSave);
	}
	else
	{
		DoSave();
	}
	*/
}
function DoSave()
{
	//�����豸����Ϣ
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
			alertShow("�豸���Զ�����ʧ��!"+masterid)
			return
		}
	}
	if ((jQuery('#CItemDR').val()=="")&&(getElementValue("CType")==1))
	{
		$.messager.show({title: '��ʾ',msg: '�豸���Ϊ��'});
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
			if(data[0]==0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#DHCEQConfig').datagrid('reload');
				ClearElement();
				InitButton(false);
			}
			else
				///modified by ZY0243 20200917 
				$.messager.alert('����ʧ�ܣ�','�������:'+data[0]+","+data[1], 'warning');
		}
	});
}
function BDelete_Clicked()
{
	var rowid=jQuery("#CRowID").val()
	if (rowid=="")
	{
		$.messager.show({title: '��ʾ',msg: 'û��ѡ�м�¼����ɾ��'});
		return;
	}
	messageShow("confirm","info","��ʾ","�Ƿ�ȷ��ɾ����","",function(){
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.EM.BUSConfig',
				MethodName:'DeleteData',
				Arg1:rowid,
				ArgCnt:1
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
				if(data==0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					jQuery('#DHCEQConfig').datagrid('reload');
					ClearElement();
					InitButton(false);
				}
				else
					$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
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
// Mozy0255	1190551		2020-3-6	����Ĭ�Ϲ�Ӧ��
function setProvider()
{
	///modified by ZY0275 20210712
	var Data=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","GetCheckRequestProvider",getElementValue("OCRRowID"));
	var ProviderList=Data.split("^");
	setElement("CProviderDR",ProviderList[0]);
	setElement("CProviderDR_VDesc",ProviderList[1]);
}

///czf 2022-04-19 begin
///����Ҷ�ӽڵ�չ�����и��ڵ�
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
///���ص�ǰ�ڵ���׼��ڵ�
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
//�۵����нڵ�
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
		messageShow('alert','alert','��ʾ','����ѡ���м�¼��');
		return;
	}
	messageShow("confirm","info","��ʾ","�ύ�����޸ģ��Ƿ�ȷ���ύ��","",function(){
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSConfig","SubmitData",rowid);
		jsonData=JSON.parse(jsonData)
		
		if (jsonData.SQLCODE==0)
		{
			messageShow('alert','success','��ʾ',"�����ɹ�!");
			$('#DHCEQConfig').datagrid('reload');
			ClearElement();
			InitButton(false);
			websys_showModal("options").mth();
		}
		else
	    {
			messageShow('alert','error','��ʾ',"�ύʧ��!������Ϣ:"+jsonData.Data);
			return
	    }
	},function(){
		return;
	})
	
}
