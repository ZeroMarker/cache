var ESColumns=getCurColumnsInfo('BA.G.EquipSercie.EquipService','','','')
var ELColumns=getCurColumnsInfo('BA.G.EquipSercie.EquipList','','','')
///modified by ZY0215 2020-04-02
var DeleteRowIDs=""

$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage("EquipService");
	defindTitleStyle();
	initButtonWidth();
	initLookUp(); //��ʼ���Ŵ�
	initButton(); //��ť��ʼ��
	///modified by ZY0209
	setEnabled(); //��ť����
	findEquipList(0);
	findEquipService();
	//add by ZY0224 2020-04-24
	var BussType=getElementValue("BussType")
	if (BussType==1)
	{
		hiddenObj("BFind",1);
		//$("#BAEquipList").hide()
		//$("#ServiceItem").css("width",'100%');
		
	}
};
function BFind_Clicked()
{
	setElement("SLocDR","")
	//add by ZY0224 2020-04-24
	//setElement("EQRowID","")
	setElement("SourceType","")
	setElement("SourceID","")
	///modified by ZY0209
	findEquipList(1)
	findEquipService()
}
function BAdd_Clicked()
{
	//add by ZY0224 2020-04-24
	var BussType=getElementValue("BussType")
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	///modified by ZY0226 2020-04-29
	if (BussType=="0")
	{
		if (SourceType=="")
		{
			messageShow("","","","����ѡ���豸/�豸��!");
			return
		}
		else if (SourceType=="1")
		{
			if (SourceID=="")
			{
				messageShow("","","","����ѡ���豸!");
				return
			}
		}
		else if (SourceType=="2")
		{
			if (SourceID=="")
			{
				messageShow("","","","����ѡ���豸��!");
				return
			}
		}
	}
	else
	{
		if (SourceType=="")
		{
			messageShow("","","","��ȷ����Դ���ͺ�,ѡ����Դ!");
			return
		}
		else if (SourceType=="3")
		{
			if (SourceID=="")
			{
				messageShow("","","","����ȷ���ɹ�������ϸ��Ϊ��!");
				return
			}
		}
	}
	//var str="dhceq.ba.historylocservice.csp?&SLocDR="+getElementValue("SLocDR")+"&EQRowID="+getElementValue("EQRowID")
	var str="dhceq.ba.historylocservice.csp?&SLocDR="+getElementValue("SLocDR")+"&BussType="+BussType+"&SourceType="+SourceType+"&SourceID="+SourceID
	showWindow(str,"������ʷҽ����","","","icon-w-paper","modal","","","large",findEquipService)
}
function BDelete_Clicked()
{
	//add by ZY0224 2020-04-24
	//var DeleteRowIDs=""
	var rows = $('#DHCEQServiceItem').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.Opt=="Y")
		{
			DeleteRowIDs=DeleteRowIDs+","+oneRow.TRowID
		}
	}
	if (DeleteRowIDs=="")
	{
		messageShow("","","","�޼�¼ɾ��");
		return
	}
	else
	{
		///modified by ZY0215 2020-04-02
		//var truthBeTold = window.confirm(t[-9203]);
		//if (!truthBeTold) return;
	    messageShow("confirm","","",t[-9203],"",confirmFun,"")
	}
}
///modified by ZY0258 2021-03-31
function confirmFun()
{
	DeleteRowIDs=""
	var rows = $('#DHCEQServiceItem').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.Opt=="Y")
		{
			DeleteRowIDs=DeleteRowIDs+","+oneRow.TRowID
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTEquipService","DeleteData",DeleteRowIDs);
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","�����ɹ�!");
		findEquipService()
		///modified by ZY0256 20210315
		var DeleteRowIDs=""
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData.Data);
		return
    }
}
function checkboxOnChange(Opt,rowIndex)
{
	var row = jQuery('#DHCEQServiceItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (Opt==key)
			{
				if (((val=="N")||val==""))
				{
					row.Opt="Y"
				}
				else
				{
					row.Opt="N"
				}
			}
		})
	}
}
function setSelectValue(vElementID,rowData)
{
	if (vElementID=="MasterItemDR_Desc")
	{
		setElement("MasterItemDR",rowData.TRowID)
	}
}
function clearData(vElementID)
{
	var DRElementName=vElementID.split("_")[0]
	setElement(DRElementName,"")
}
function findEquipList(findFlag)
{
	///modified by ZY0209
	if (findFlag==1)
	{
		var FromOriginalFee=getElementValue("FromOriginalFee")
		if (FromOriginalFee=="")
		{
			messageShow("","","","��ѡ��ԭֵ��Χ���ٲ�ѯ!");
			return
		}
	}
	$HUI.datagrid("#DHCEQBAEquipList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.CTEquipService",
	        	QueryName:"GetEquipList",
				vLocDR:"",
				vDesc:getElementValue("Equip"),
				vEquipTypeDR:"",
				vFromOriginalFee:getElementValue("FromOriginalFee"),
				vToOriginalFee:getElementValue("ToOriginalFee"),
				vItemDR:getElementValue("MasterItemDR")
		},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		border:false,
		columns:ELColumns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
	    onClickRow: function (rowIndex,rowData) {
		    setElement("SLocDR",rowData.TStoreLocDR)
		    //add by ZY0224 2020-04-24
		    //setElement("EQRowID",rowData.TEQRowID)
		    setElement("SourceType","1")
		    setElement("SourceID",rowData.TEQRowID)
		    findEquipService()
		    }
	});
}
function findEquipService()
{
	$HUI.datagrid("#DHCEQServiceItem",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.CTEquipService",
	        	QueryName:"GetEquipService",
				BussType:getElementValue("BussType"),
				SourceType:getElementValue("SourceType"),
				SourceID:getElementValue("SourceID"),
		},
		//rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fitColumns:true,  //modify by lmm 2020-06-06 UI
		fit:true,
		border:false,
		toolbar:[{                    //modify by txr 2023-02-09 UI
				iconCls:'icon-add',
				text:'����',
				id:'add',
				handler:function(){BAdd_Clicked();}
			},
			{
				iconCls:'icon-cancel',
				text:'ɾ��',
				id:'delete',
				handler:function(){BDelete_Clicked();}
			}],
		columns:ESColumns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
	    onClickRow: function (rowIndex,rowData) {}
	});
}
///add by ZY 20211014
function setEnabled()
{
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly==1)
	{
		
		disableElement("BFind",true)
		disableElement("BAdd",true)
		disableElement("BDelete",true)
	}
}

///add by ZY0301 20220523
function getParam(ID)
{
	
}
