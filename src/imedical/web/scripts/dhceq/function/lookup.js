//Create By DJ 20160126 ����������combogrid�ؼ�����
//====================================================================
function initEquipPanel()
{
	var vElementID="Equip"
	var vElementName="�豸����"
	var vWidth=450
	var vEditFlag=true
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//��ʾԪ�ؼ���
	{
		jQuery("#"+vElementID).combogrid({
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'���ݼ����С���', 
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		    idField: 'TRowID',    
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:250},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        {field:'TNo',title:'�豸���',width:30,width:150},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "����"+vElementName+"�б�ʧ��!");},
			onChange: function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
			onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function initEquipData()
{
	var vParams=jQuery("#Equip").combogrid("getText")+",,,,,"
	initComboData("Equip","web.DHCEQ.Process.DHCEQFind","GetShortEquip",vParams,6)
}
function initUseLocPanel()
{
	initComboGrid("UseLoc","��������",400,true);
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
function initServicePanel()
{
	initComboGrid("Service","ά����",400,true);
}
function initServiceData()
{
	var vParams=jQuery("#Service").combogrid("getText")
	initComboData("Service","web.DHCEQ.Process.DHCEQFind","ServiceLookUp",vParams,1)
}
function initMaintUserPanel()
{
	initComboGrid("MaintUser","ά����",400,true);
}
function initMaintUserData()
{
	var vParams=jQuery("#MaintUser").combogrid("getText")
	initComboData("MaintUser","web.DHCEQ.Process.DHCEQFind","User",vParams,1)
}
function initManuFacturerPanel()
{
	initComboGrid("ManuFacturer","��������",400,true);
}
function initManuFacturerData()
{
	var vParams=jQuery("#ManuFacturer").combogrid("getText")
	initComboData("ManuFacturer","web.DHCEQ.Process.DHCEQFind","GetManuFacturer",vParams,1)
}
function initModelPanel()
{
	initComboGrid("Model","����ͺ�",400,true);
}
function initModelData()
{
	var vParams=GlobalObj.ItemDR+","+jQuery("#Model").combogrid("getText")
	initComboData("Model","web.DHCEQ.Process.DHCEQFind","GetModel",vParams,2)
}
function initMaintGroupPanel()
{
	initComboGrid("MaintGroup","ά����",400,true);
}
function initMaintGroupData()
{
	var vParams=jQuery("#MaintGroup").combogrid("getText")
	initComboData("MaintGroup","web.DHCEQ.Process.DHCEQFind","MaintGroupLookUp",vParams,1)
}
function initItemPanel()
{
	initComboGrid("Item","�豸��",400,true);
}
function initItemData()
{
	var vParams=GlobalObj.EquipTypeDR+","+GlobalObj.StatCatDR+","+jQuery("#Item").combogrid("getText")+","
	initComboData("Item","web.DHCEQ.Process.DHCEQFind","GetMasterItem",vParams,4)
}
function initEquipTypePanel()
{
	initComboGrid("EquipType","�豸����",400,true);
}
function initEquipTypeData()
{
	var vParams=jQuery("#EquipType").combogrid("getText")
	initComboData("EquipType","web.DHCEQ.Process.DHCEQFind","GetEquipType",vParams,1)
}
function initStatCatPanel()
{
	initComboGrid("StatCat","�豸����",400,true);
}
function initStatCatData()
{
	var vParams=jQuery("#StatCat").combogrid("getText")+GlobalObj.EquipTypeDR
	initComboData("StatCat","web.DHCEQ.Process.DHCEQFind","StatCatLookUp",vParams,2)
}
function initEquipCatPanel()
{
	initComboGrid("EquipCat","�豸����",400,true);
}
function initEquipCatData()
{
	var vParams=jQuery("#EquipCat").combogrid("getText")
	initComboData("EquipCat","web.DHCEQ.Process.DHCEQFind","EquipCatLookUp",vParams,1)
}
function initProviderPanel()
{
	initComboGrid("Provider","��Ӧ��",400,true);
}
function initProviderData()
{
	var vParams=jQuery("#Provider").combogrid("getText")
	initComboData("Provider","web.DHCEQ.Process.DHCEQFind","GetVendor",vParams,1)
}
function initBrandPanel()
{
	initComboGrid("Brand","Ʒ��",400,true);
}
function initBrandData()
{
	var vParams=","+jQuery("#Brand").combogrid("getText")
	initComboData("Brand","web.DHCEQ.Process.DHCEQFind","GetBrand",vParams,2)
}

///add by lmm 2016-12-23
function initUserPanel()
{
	initComboGrid("User","�û�",400,true);
}
function initUserData()
{
	var vParams=","+jQuery("#User").combogrid("getText")+",,,"
	initComboData("User","web.DHCEQ.Process.DHCEQFind","EQUser",vParams,5)
}

//add by zy  2016-09-30  �ɹ�����
function initCountryPanel()
{
	initComboGrid("Country","����",400,true);
}
function initCountryData()
{
	var vParams=jQuery("#Country").combogrid("getText")
	initComboData("Country","web.DHCEQ.Process.DHCEQFind","GetCountry",vParams,1)
}
function initUnitPanel()
{
	initComboGrid("Unit","��λ",400,true);
}
function initUnitData()
{
	//desc ,type:2
	var vParams=jQuery("#Unit").combogrid("getText")+",2"
	initComboData("Unit","web.DHCEQ.Process.DHCEQFind","GetUOM",vParams,2)
}
function initAssetItemPanel()
{
	initComboGrid("AssetItem","ƷĿ",400,true);
}
function initAssetItemData()
{
	//desc ,type:2
	var vParams=","+jQuery("#AssetItem").combogrid("getText")+","
	initComboData("AssetItem","web.DHCEQ.Process.DHCEQFind","GetAssetItemList",vParams,3)
}
function initCompanyPanel()
{
	initComboGrid("Company","��ҵ",400,true);
}
function initCompanyData()
{
	//desc ,type:2
	var vParams=","+jQuery("#Company").combogrid("getText")+","//modify by jyp20160902
	initComboData("Company","web.DHCEQ.Process.DHCEQFind","GetPCCCompany",vParams,3)
}
function initProductPanel()
{
	initComboGrid("Product","��Ʒ",400,true);
}
function initProductData()
{
	var vParams=jQuery("#Product").combogrid("getText")+","+jQuery("#Product").combogrid("getText")
	initComboData("Product","web.DHCEQ.Process.DHCEQFind","GetProduct",vParams,2)
}

function initAssetTypePanel()
{
	initComboGrid("AssetType","�ʲ�����",400,true);
}
function initAssetTypeData()
{
	var vParams="";
	initComboData("AssetType","web.DHCEQ.Process.DHCEQFind","GetAssetType",vParams,0)
}
function initCompanyTypePanel()
{
	initComboGrid("CompanyType","��ҵ����",400,true);
}
function initCompanyTypeData()
{
	var vParams="";
	initComboData("CompanyType","web.DHCEQ.Process.DHCEQFind","GetCompanyType",vParams,0)
}

function initAgentPanel()
{
	initComboGrid("Agent","������",400,true);
}
function initAgentData()
{
	//desc ,type:2
	var vParams=jQuery("#Agent").combogrid("getText")+","+jQuery("#Agent").combogrid("getText")+","
	initComboData("Agent","web.DHCEQ.Process.DHCEQFind","GetPCCCompany",vParams,3)
}
function initGrantPanel()
{
	initComboGrid("Grant","��Ȩ��",400,true);
}
function initGrantData()
{
	//desc ,type:2
	var vParams=jQuery("#Grant").combogrid("getText")+","+jQuery("#Grant").combogrid("getText")+","
	initComboData("Grant","web.DHCEQ.Process.DHCEQFind","GetPCCCompany",vParams,3)
}

function initFundsTypePanel()
{
	initComboGrid("FundsType","�ʽ�����",400,true);
}
function initFundsTypeData()
{
	initComboData("FundsType","web.DHCEQ.Process.DHCEQFind","FundsType","",0)
}
function initHospitalPanel()
{
	initComboGrid("Hospital","ҽԺ",400,true);
}
function initHospitalData()
{
	initComboData("Hospital","web.DHCEQ.Process.DHCEQFind","GetHospital","",1)
}
///add by zy 2017-4-6  ZY0162
///���Ԫ�س�ʼ��
function initComponentPanel()
{
	initComboGrid("Component","���",400,true);
}
function initComponentData()
{
	var vParams=jQuery("#Component").combogrid("getText")
	initComboData("Component","web.DHCEQ.Process.DHCEQFind","GetComponent",vParams,1)
}