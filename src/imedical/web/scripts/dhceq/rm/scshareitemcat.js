var Columns=getCurColumnsInfo('RM.G.Rent.ShareItemCat','','','');
//alert(Columns)
var curIndex=-1;  //�����
$(function(){
	initDocument();
});

function initDocument()
{
	initLookUp();
	initButton();
	initMessage("");
	defindTitleStyle();
	initButtonWidth();
	$("#BAdd").on("click", BSave_Clicked);
	setEnabled();
	initStatusData();
	setRequiredElements("SICShareType^SICCode^SICDesc");
	
	$HUI.datagrid("#tDHCEQSCShareItemCat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemCat",
			Code:getElementValue("SICCode"),
			Desc:getElementValue("SICDesc"),
			ShareType:getElementValue("SICShareType"),
			HospitalDR:getElementValue("SICHospitalDR"),
			
		},
		//scrollbarSize:0,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    columns:Columns,
	    fitColumns:true,
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
	var AdvanceDisFlag = $HUI.combobox('#SICShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"1",
		data:[{
				id: '1',
				text: '�豸'
			}]
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSCShareItemCat",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemCat",
			Code:getElementValue("SICCode"),
			Desc:getElementValue("SICDesc"),
			ShareType:getElementValue("SICShareType"),
			HospitalDR:getElementValue("SICHospitalDR"),
	    }
	}); 
}

// �������޸�
function BSave_Clicked()
{
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataCat",data,"0");
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
	var rowID=getElementValue("SICRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataCat",rowID,"1");
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
		
		setElement("SICShareType",row.TShareTypeDR);
		setElement("SICCode",row.TCode);
		setElement("SICDesc",row.TDesc);
		setElement("SICHospital",row.THospital);
		setElement("SICHospitalDR",row.THospitalDR);
		setElement("SICRemark",row.TRemark);
		setElement("SICRowID",row.TRowID);
		curIndex = index;
		setEnabled();
	}
	else
	{
		//setElement("SICShareType","");
		setElement("SICCode","");
		setElement("SICDesc","");
		setElement("FIDesc","");
		setElement("SICHospital","");
		setElement("SICHospitalDR","");
		setElement("SICRemark","");
		setElement("SICRowID","");
		curIndex = -1;
		setEnabled();
	}
}

// add by zx 2020-02-10
// ��ť�һ����ƴ���
function setEnabled()
{
	var SICRowID=getElementValue("SICRowID");
	if (SICRowID!="")
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
	setElement(vElementID+"DR",item.TRowID)

}