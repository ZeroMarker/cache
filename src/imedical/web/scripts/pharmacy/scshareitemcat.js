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
	showBtnIcon('BDelete^BSave^BFind',false); //added by LMH 20230207 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonWidth();
	//$("#BAdd").on("click", BSave_Clicked);	MZY0141	2973405		2022-11-02
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
	    //fitColumns:true,  //modified by LMH 20230207 UI ����ʱĬ���������
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
// MZY0096	2137553		2021-09-16	����ȷ��ѡ��
function BDelete_Clicked()
{
	messageShow("confirm","","","ȷ��Ҫɾ���ü�¼��","",DeleteShareItemCat,unDeleteShareItemCat,"��","��");
}
function DeleteShareItemCat()
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
function unDeleteShareItemCat()
{
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
		//disableElement("BAdd",true);	 MZY0141	2973405		2022-11-02
		//disableElement("BSave",false);  //Add by zc0125 2022-12-8 ���水ť������
		disableElement("BDelete",false);
	}
	else
	{
		//disableElement("BAdd",false);	 MZY0141	2973405		2022-11-02
		//disableElement("BSave",true);		//Add by zc0125 2022-12-8 ���水ť������
		disableElement("BDelete",true);
	}
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)

}
// MZY0111	2414717		2022-01-14
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
	if (vElementID=="SICHospital") setElement("SICHospitalDR", "")
}
