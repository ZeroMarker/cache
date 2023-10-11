var Columns=getCurColumnsInfo('RM.G.Rent.ShareItem','','','');  ///Modify by zc0076 2020-06-09 ���������RM.L.GetSCShareItem��ΪRM.G.Rent.ShareItem
var Column=getCurColumnsInfo('RM.G.Rent.ShareItemList','','','');  ///Modify by zc0076 2020-06-09 ���������RM.L.GetSCShareItemList��ΪRM.G.Rent.ShareItemList

var curIndex=-1;  //�����
$(function(){
	initDocument();
	initStatusData();
	disableElement("SILName",true);
	//disableElement("BListA",true);
});

function initDocument()
{
	initMessage("Rent");
	initLookUp();
	initButton(); //modified by LMH 20230207 UI��ť��ʼ��
	initButtonListColor(); ////added by LMH 20230207 ��ϸ��ť��ɫ��ʼ��
	initButtonWidth();
	setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat");  
	//ͳһ����initButton(); modified by LMH 20230207 UI
	/*
	$("#BAdd").on("click", BSave_Clicked);
	$("#BSave").on("click", BSave_Clicked);
	$("#BDelete").on("click", BDelete_Clicked);
	$("#BFind").on("click", BFind_Clicked);  ///Modify by zc0108 2021-11-22 ��Ӳ�ѯ��ť
	*/
	//Modify by zc 2020-06-24 ZC0077 ��ֹ�ظ�����
	$("#BAddList").on("click", BSaveList_Clicked);
	$("#BSaveList").on("click", BSaveList_Clicked);
	$("#BDeleteList").on("click", BDeleteList_Clicked);
	//Modify by zc 2020-06-24 ZC0077 ��ֹ�ظ�����
	setEnabled();
	$HUI.datagrid("#tDHCEQSCShareItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItem",
			ShareType:getElementValue("SIShareType"),
			Code:getElementValue("SICode"),
			Desc:getElementValue("SIDesc"),
			ShareItemCatDR:getElementValue("SIShareItemCatDR"),
			HospitalDR:getElementValue("SIHospitalDR"),
			WashFlag:getElementValue("SIWashFlag"),
			InspectFlag:getElementValue("SIInspectFlag"),
			
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
		fitColumns:true,
	    columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow: function (index, row) {
			fillData(index, row);
			SCShareItemList();
		},
		onLoadSuccess:function(){
			
		}
	});
	$HUI.datagrid('#tDHCEQSCShareItemList',{columns:Column,fitColumns:true,}) //added by LMH 20230207 UI ��ʼ��������ʾ��ϸ����Ϣ
	///Modify by zc0076 2020-06-09  ��ʼ�һ���Դ��ϸά����ť begin
	disableElement("BAddList",true);
	disableElement("BSaveList",true);
	disableElement("BDeleteList",true);
	///Modify by zc0076 2020-06-09  ��ʼ�һ���Դ��ϸά����ť begin
}

function initStatusData()
{
	
	var AdvanceDisFlag = $HUI.combobox('#SIShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"1",
		data:[{
				id: '1',
				text: '�豸'
			}]
	});
}

function SCShareItemList()
{
	initButtonWidth();
	//Modify by zc 2020-06-24 ZC0077 ɾ������ begin
	//$("#BAddList").on("click", BSaveList_Clicked);
	//$("#BSaveList").on("click", BSaveList_Clicked);
	//$("#BDeleteList").on("click", BDeleteList_Clicked);
	//Modify by zc 2020-06-24 ZC0077 ɾ������ end
	if (getElementValue("SIRowID")=="") {disableElement("BAddList",true);}  ///Modify by zc0076 2020-06-09 ��Դ��Ŀû��ѡ����Ҫ�һ���ϸά����������ť
	setEnabledList();
	$HUI.datagrid("#tDHCEQSCShareItemList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemList",
			ShareItemDR:getElementValue("SIRowID"),
			ItemDR:getElementValue("SILItemDR"),
			Name:getElementValue("SILName"),
			ModelDR:getElementValue("SILModelDR"),
			
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: false,  //modify by lmm 2020-06-24 1385270
	    fitColumns:true,
	    columns:Column,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow: function (index, row) {
			fillDataList(index, row);
		},
		onLoadSuccess:function(){
			
		}
	
	});
}

function BSaveList_Clicked()
{
	//setRequiredElements("SILItem^SILModel");  //Modify by zc 2020-06-24 ZC0077 ���ñ���λ���иĶ�
	setRequiredElements("SILItem");  //Modify by zc 2020-06-29 ZC0078 ���ñ�����
	var SILShareItemDR=getElementValue("SIRowID");
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItemList",data,"0",SILShareItemDR);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }	
}

// �������޸�
function BSave_Clicked()
{
	//setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat"); //Modify by zc 2020-06-24 ZC0077 ���ñ���λ���иĶ�
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItem",data,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}

// add by zx 2020-02-10
// ɾ��
// MZY0096	2137553		2021-09-16	����ȷ��ѡ��
function BDelete_Clicked()
{
	messageShow("confirm","","","ȷ��Ҫɾ������Դ��Ŀ��","",DeleteShareItem,unDeleteShareItem,"��","��");
}
function DeleteShareItem()
{
	if (checkMustItemNull()) return   //Modify by zc 2020-06-24 ZC0077 �жϱ������Ƿ�Ϊ��
	var rowID=getElementValue("SIRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItem",rowID,"1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}
function unDeleteShareItem()
{
}
function BDeleteList_Clicked()
{
	messageShow("confirm","","","ȷ��Ҫɾ������Դ��Ŀ��ϸ��","",DeleteShareItemList,unDeleteShareItemList,"��","��");
}
function DeleteShareItemList()
{
	if (checkMustItemNull()) return   //Modify by zc 2020-06-24 ZC0077 �жϱ������Ƿ�Ϊ��
	var rowID=getElementValue("SILRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItemList",rowID,"1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}
function unDeleteShareItemList()
{
}
// add by zx 2020-02-10
// ����к��������
// ���: index,ѡ���к� row,ѡ��������
function fillData(index, row)
{
	
	if (curIndex!=index) 
	{
		setElement("SIShareType",row.TShareTypeDR);
		setElement("SICode",row.TCode);
		setElement("SIDesc",row.TDesc);
		setElement("SIShareItemCatDR",row.TShareItemCatDR);
		setElement("SIShareItemCat",row.TShareItemCat);
		setElement("SIHospital",row.THospital);
		setElement("SIHospitalDR",row.THospitalDR);
		setElement("SIWashFlag",row.TWashFlagDR);
		setElement("SIInspectFlag",row.TInspectFlagDR);
		setElement("SIRemark",row.TRemark);
		setElement("SIRowID",row.TRowID);
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = index;
		setEnabled();
		//setRequiredElements("SILItem");  //Modify by zc 2020-06-24 ZC0077 ���ñ�����    //Modify by zc 2020-06-29 ZC0078���ñ�����λ������
	}
	else
	{
		setElement("SICode","");
		setElement("SIDesc","");
		setElement("SIShareItemCat","")
		setElement("SIShareItemCatDR","")
		setElement("SIHospital","");
		setElement("SIHospitalDR","");
		setElement("SIWashFlag","");
		setElement("SIInspectFlag","");
		setElement("SIRemark","");
		setElement("SIRowID","");
		setElement("SILShareItemDR","");
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = -1;
		$('#tDHCEQSCShareItem').datagrid('unselectAll');  ///Modify by zc0076 2020-06-09 ȡ��ѡ��Ӧ�ı䱳��ɫ
		setEnabled();
		RemoveRequiredElements("SILItem");  //Modify by zc 2020-06-24 ZC0077 �Ƴ�������
		
	}
}

function fillDataList(index, row)
{
	
	if (curIndex!=index) 
	{
		
		
		setElement("SILShareItemDR",row.TShareItemDR);
		setElement("SILItem",row.TItem);
		setElement("SILItemDR",row.TItemDR);
		setElement("EQItemDR",row.TItemDR);    //Modify by zc 2021-05-31 ZC0101  ���Ͳ����豸�����
		setElement("SILName",row.TName);
		setElement("SILModel",row.TModel);
		setElement("SILModelDR",row.TModelDR);
		setElement("SILRowID",row.TRowID);
		curIndex = index;
		setEnabledList();
		RemoveRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat"); //Modify by zc 2020-06-24 ZC0077 �Ƴ�������
	}
	else
	{
		setElement("SILShareItemDR",row.TShareItemDR);
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("EQItemDR","");   //Modify by zc 2021-05-31 ZC0101  ���Ͳ����豸�����
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = -1;
		$('#tDHCEQSCShareItemList').datagrid('unselectAll');  ///Modify by zc0076 2020-06-09 ȡ��ѡ��Ӧ�ı䱳��ɫ
		setEnabledList();
		setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat");  //Modify by zc 2020-06-24 ZC0077 ���ñ�����
	}
}

// add by zx 2020-02-10
// ��ť�һ����ƴ���
function setEnabled()
{
	var SIRowID=getElementValue("SIRowID");
	if (SIRowID!="")
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

function setEnabledList()
{
	var SILRowID=getElementValue("SILRowID");
	if (SILRowID!="")
	{
		disableElement("BAddList",true);
		disableElement("BSaveList",false);
		disableElement("BDeleteList",false);
	}
	else
	{
		disableElement("BAddList",false);
		disableElement("BSaveList",true);
		disableElement("BDeleteList",true);
		
	}	
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID,item.TDesc);
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="SIHospital")
	{
		setElement("SIHospital",item.TName);
		setElement("SIHospitalDR",item.TRowID);
	}
	if (vElementID=="SILItem")
	{
		setElement("SILItem",item.TName);
		setElement("SILName",item.TName);
		setElement("SILItemDR",item.TRowID);
		setElement("EQItemDR",item.TRowID);
		
	}
	if (vElementID=="SILModel")
	{
		setElement("SILModel",item.TName);
		setElement("SILModelDR",item.TRowID);
	}

}
//Modify by zc 2020-06-29 ZC0078
//Ԫ����ո�ֵ
function clearData(elementID)
{
	setElement(elementID+"DR","")
}
///Modify by zc0108 2021-11-22 ��Ӳ�ѯ��ť
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSCShareItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItem",
			ShareType:getElementValue("SIShareType"),
			Code:getElementValue("SICode"),
			Desc:getElementValue("SIDesc"),
			ShareItemCatDR:getElementValue("SIShareItemCatDR"),
			HospitalDR:getElementValue("SIHospitalDR"),
			WashFlag:getElementValue("SIWashFlag"),
			InspectFlag:getElementValue("SIInspectFlag"),
			
		}
	});
}
// ZC0117	2584942		2022-04-28
//Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="EquipTypeDR"){return getElementValue("EquipTypeDR")}
}
/**
* @description ��Ӻ�����ֹ��������initButton()��BAdd_Clicked���屨��
* @author LMH 20230207 UI
* @params ��
* @return ��
*/
function BAdd_Clicked(){
	BSave_Clicked();
}
/**
* @description ��ϸ��ť��ɫ��ʼ��
* @author LMH 20230207 UI
* @params ��
* @return ��
*/
function initButtonListColor()
{
	if (jQuery("#BAddList").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// �����
			if (($("#BAddList").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BAddList").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BAddList").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
	if (jQuery("#BSaveList").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// �����
			if (($("#BSaveList").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BSaveList").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BSaveList").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
}