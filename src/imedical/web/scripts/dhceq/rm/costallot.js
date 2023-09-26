var selectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
var columns=getCurColumnsInfo('RM.G.Rent.CostAllot','','',''); //��ȡ�ж���
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initMessage("Rent");
	initUserInfo(); //�û���Ϣ
	initLookUp();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	initButtonWidth();
	initRALAllotType();
	setRequiredElements("RALAllotType^RALAllotSourceDR_Desc^RALAllotPercentNum"); //������
	setEnabled();		//��ť����
	HiddenButtonByLoc();
	//table���ݼ���
	$HUI.datagrid("#tDHCEQSRentCostAllot",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSCostAllot",
			QueryName:"GetCostAllot",
			PutOnSetDR:getElementValue("RALPutOnSetDR"),
			AllotType:getElementValue("RALAllotType"),
			AllotSourceDR:getElementValue("RALAllotSourceDR")
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    columns:columns,
	   	fitColumns: true,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
				//creatToolbar();
			},
		onSelect:function(rowIndex,rowData){
				fillData(rowData);
			}
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSRentCostAllot",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSCostAllot",
			QueryName:"GetCostAllot",
			PutOnSetDR:getElementValue("RALPutOnSetDR"),
			AllotType:getElementValue("RALAllotType"),
			AllotSourceDR:getElementValue("RALAllotSourceDR")
		}
	});
}
///��ʼ����ť״̬
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///ѡ���а�ť״̬
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
function BAdd_Clicked()
{
	//Modefined by ZC0074 2020-5-28 ��̯�������ܳ���100%�� begin
	if (parseFloat(getElementValue("RALAllotPercentNum"))>100)
	{
		messageShow("alert","alert","��ʾ","��̯�������ܳ���100%��");
		return;
	}
	//Modefined by ZC0074 2020-5-28 ��̯�������ܳ���100%�� end
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","SaveData",data,"2");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.rm.costallot.csp?&RowID="+getElementValue("RALPutOnSetDR")},50);
}
function BSave_Clicked()
{
	//Modefined by ZC0074 2020-5-28 ��̯�������ܳ���100%�� begin
	if (parseFloat(getElementValue("RALAllotPercentNum"))>100)
	{
		messageShow("alert","alert","��ʾ","��̯�������ܳ���100%��");
		return;
	}
	//Modefined by ZC0074 2020-5-28 ��̯�������ܳ���100%�� end
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","SaveData",data,"");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�޸ĳɹ�");
	window.setTimeout(function(){window.location.href= "dhceq.rm.costallot.csp?&RowID="+getElementValue("RALPutOnSetDR")},50);
}

function BDelete_Clicked()
{
	if(getElementValue("RALRowID")==""){return;}
	messageShow("confirm","info","��ʾ",t[-9203],"",DeleteData,"")

}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.rm.costallot.csp?&RowID="+getElementValue("RALPutOnSetDR")},50);
}

// Author add by zx 2019-12-19
// Desc ��ʼ����Դ����Ϊcombobox,Ĭ��valueֵΪ '0'
// Input ��
// Output ��
function initRALAllotType()
{
	var Status = $HUI.combobox('#RALAllotType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: 'ҽԺ'
			},{
				id: '1',
				text: '����ƽ̨����'
			}
			/*,{
				id: '2',
				text: '�������'
			}*/
			],
			onSelect: function () {
	    		ValueClear()
	    		var SourceType = getElementValue("RALAllotType");
	    		if (SourceType=="0")
				{
					disableElement("RALAllotSourceDR_Desc",true);
					var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","GetHosptailInfo",getElementValue("RALPutOnSetDR"));
    				jsonData=jQuery.parseJSON(jsonData);
    				setElement("RALAllotSourceDR_Desc",jsonData.Data["RALAllotSourceDR_Desc"]);
					setElement("RALAllotSourceDR",jsonData.Data["RALAllotSourceDR"]);
    				//singlelookup("RALAllotSourceDR_Desc","PLAT.L.Hospital","","");
				}
				else if (SourceType=="2")
				{
					disableElement("RALAllotSourceDR_Desc",false);
					var paramsFrom=[{"name":"Type","type":"2","value":"0"},{"name":"LocDesc","type":"1","value":"RALAllotSourceDR_Desc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        			singlelookup("RALAllotSourceDR_Desc","PLAT.L.Loc",paramsFrom,"");
				}
				else
				{
					setElement("RALAllotSourceDR_Desc",curLocName);
					setElement("RALAllotSourceDR",curLocID);
					disableElement("RALAllotSourceDR_Desc",true);
				}
			}
	});
}
function ValueClear()
{
	setElement("RALAllotSourceDR_Desc","");
	setElement("RALAllotSourceDR","");
}
// Author add by zx 2019-12-19
// Desc �Ŵ�Ԫ��ѡ���к����ӦDRԪ�ظ�ֵ
// Input elementID:�Ŵ�Ԫ��ID rowData:ѡ��������
// Output ��
function setSelectValue(elementID,rowData)
{
	if(elementID=="RALAllotSourceDR_Desc") 
	{
		setElement("RALAllotSourceDR",rowData.TRowID);
		setElement("RALAllotSourceDR_Desc",rowData.TName);
	}
}


// Author add by zx 2019-12-19
// Desc ѡ��datagrid�к�����
// Input rowData:datagridѡ��������
// Output ��
function fillData(rowData)
{
	if (selectedRowID!=rowData.RALRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.RALRowID;
		if (rowData.RALAllotType=="0")
		{
			disableElement("RALAllotSourceDR_Desc",true);
			var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSCostAllot","GetHosptailInfo",getElementValue("RALPutOnSetDR"));
    		jsonData=jQuery.parseJSON(jsonData);
    		setElement("RALAllotSourceDR_Desc",jsonData.Data["RALAllotSourceDR_Desc"]);
			setElement("RALAllotSourceDR",jsonData.Data["RALAllotSourceDR"]);
    		//singlelookup("RALAllotSourceDR_Desc","PLAT.L.Hospital","","");
		}
		else if (rowData.RALAllotType=="2")
		{
			disableElement("RALAllotSourceDR_Desc",false);
			var paramsFrom=[{"name":"Type","type":"2","value":"0"},{"name":"LocDesc","type":"1","value":"RALAllotSourceDR_Desc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        	singlelookup("RALAllotSourceDR_Desc","PLAT.L.Loc",paramsFrom,"");
		}
		else
		{
			disableElement("RALAllotSourceDR_Desc",true);
		}
		UnderSelect();
		HiddenButtonByLoc();
	}
	else
	{
		clearFormData();
		disableElement("RALAllotSourceDR_Desc",false);
		selectedRowID="";
		setEnabled();
		HiddenButtonByLoc();
	}
}

// Author add by zx 2019-12-19
// Desc �ٴ�ѡ��datagrid�к���ձ�
// Input ��
// Output ��
function clearFormData()
{
	setElement("RALRowID","");
	setElement("RALAllotSourceDR","");
	setElement("RALAllotSourceDR_Desc","");
	setElement("RALAllotType","");
	setElement("RALAllotPercentNum","");
	setElement("RALRemark","");
}
function HiddenButtonByLoc()
{
	var Flag=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","CheckLocType",curLocID);
	if (Flag=="0")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BAdd",true);
	}
}