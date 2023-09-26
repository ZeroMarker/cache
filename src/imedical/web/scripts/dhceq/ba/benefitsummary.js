var editFlag="undefined";
var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitSummary','','','')
jQuery(document).ready(function()
{
	initUserInfo();
	setElement("BSUserDR",SessionObj.GUSERID)
	setElement("BSUserDR_SSName",SessionObj.GUSERNAME)
    initMessage("BA"); //��ȡ����ҵ����Ϣ
	initLookUp();
	defindTitleStyle();
	fillData(); //�������
	//showFieldsTip();
    setEnabled(); //��ť����
    initApproveButtonNew(); //��ʼ��������ť
    initButton();
	initButtonWidth();	
	$HUI.datagrid("#tDHCEQBenefitSummary",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitSummary",
	        	QueryName:"GetBenefitSummaryList",
				RowID:getElementValue("BSRowID"),
				Year:getElementValue("BSYear")
		},
    	border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		columns:Columns,
	    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQBenefitSummary').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQBenefitSummary').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	        }
        },
		pagination:true,
		pageSize:18,
		pageNumber:18,
		pageList:[18,36,54,72,90]
	});
	//SetEnabled()
	}
)

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}

function fillData()
{
	var RowID=getElementValue("BSRowID")
	if (RowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","GetOneBenefitSummary",RowID)
	//messageShow("","","",jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}
function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#tDHCEQBenefitSummary").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	if (getElementValue("BSYear")=="")
	{
		alertShow("��Ȳ���Ϊ��!")
		return
	}
	if (getElementValue("BSSummary")=="")
	{
		alertShow("�ܽ᲻��Ϊ��!")
		return
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#tDHCEQBenefitSummary').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.UCEquipDR=="")
		{
			alertShow("��"+(i+1)+"���豸IDΪ��!")
			return "-1"
		}
		if (oneRow.UCTotalScore=="")
		{
			alertShow("��"+(i+1)+"�����ݲ���ȷ!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
		}
	}
	if (dataList=="")
	{
		//alertShow("�豸��ϸ����Ϊ��!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data
		url="dhceq.ba.benefitsummary.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
	
}
function BDelete_Clicked()
{
	var RowID=getElementValue("BSRowID")
	if (RowID=="")
	{
		//alertShow("û����ⵥɾ��!")
		messageShow("","","","û�п�ɾ������!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SaveData",RowID,"","1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val=""	//"&RowID="+jsonData.Data
		url="dhceq.ba.benefitsummary.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	var RowID=getElementValue("BSRowID")
	if (RowID=="")
	{
		//alertShow("û����ⵥɾ��!")
		messageShow("","","","û�п�ɾ������!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SubmitData",RowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data
		url="dhceq.ba.benefitsummary.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function setEnabled()
{
	var BSStatus=getElementValue("BSStatus")
	if (BSStatus=="")
	{
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
	}else if (BSStatus>0)
	{
		disableElement("BSave",true)
		disableElement("BSubmit",true)
	}
}