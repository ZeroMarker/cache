var Columns=getCurColumnsInfo('RM.G.Rent.ShareItem','','','');
//alert(Columns)
var curIndex=-1;  //�����
$(function(){
	initDocument();
	initStatusData();
});

function initDocument()
{
	initLookUp();
	initButton();
	initMessage("");
	defindTitleStyle();
	initButtonWidth();
	setRequiredElements("SIShareType^SICode^SIDesc^SIShareItemCat");
	$("#BAdd").on("click", BSave_Clicked);
	
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
		},
		onLoadSuccess:function(){
			setEnabled();
		}
	});
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

// �������޸�
function BSave_Clicked()
{
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
function BDelete_Clicked()
{
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
		curIndex = index;
		setEnabled();
	}
	else
	{
		//setElement("SIShareType","");
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
		curIndex = -1;
		setEnabled();
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

function setSelectValue(vElementID,item)
{
	setElement(vElementID,item.TDesc);
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="SIHospital")
	{
		setElement("SIHospital",item.TName);
		setElement("SIHospitalDR",item.TRowID);
	}

}