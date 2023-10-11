var Columns=getCurColumnsInfo('BA.G.ResourceAllot','','','')
var SelectedRow=-1
jQuery(document).ready(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	defindTitleStyle();
	initUserInfo();
    initMessage("ba"); //modified by ZY0288 2021-12-30
    initLookUp(); //��ʼ���Ŵ�
    initElementData();
	initButton();
	initEvent();
	setEnabled(false)
	//modified by ZY 2690645 20220808
    setRequiredElements("RALoc^RAYear^RAMonth^RAResourceType^RAAmount^RARate^RAAllotAmount^RAAllotMode") 
	initDateGrid();
}

function initDateGrid()
{
	var LocDR=getElementValue("RALocDR")
	var ResourceTypeDR=getElementValue("RAResourceTypeDR")
	var Year=getElementValue("RAYear")
	var Month=getElementValue("RAMonth")
	$HUI.datagrid("#tDHCEQResourceAllot",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.BUSResourceAllot",
			QueryName:"GetResourceAllot",
			LocDR:LocDR,
			ResourceTypeDR:ResourceTypeDR,
			Year:Year,
			Month:Month,
		},
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:Columns,
		pagination:true,
		onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);},
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
function onClickRow(rowIndex,rowData)
{
	if (SelectedRow==rowIndex)	
	{
		setElement("RARowID",""); 
		setElement("RALocDR",""); 
		setElement("RALoc",""); 
		setElement("RAYear",""); 
		setElement("RAMonth",""); 
		setElement("RAResourceTypeDR",""); 
		setElement("RAResourceType",""); 
		setElement("RAAmount",""); 
		setElement("RARate",""); 
		setElement("RAAllotAmount",""); 
		setElement("RAAllotMode",""); 
		setElement("RATotal",""); 
		setElement("RAStatus",""); 
		setElement("RARemark",""); 
		setElement("RAHold1",""); 
		setElement("RAHold2",""); 
		setElement("RAHold3",""); 
		setElement("RAHold4",""); 
		setElement("RAHold5",""); 
		SelectedRow=-1;
		setEnabled(false);
	}
	else
	{
		setElement("RARowID",rowData.RARowID); 
		setElement("RALocDR",rowData.RALocDR); 
		setElement("RALoc",rowData.RALoc); 
		setElement("RAYear",rowData.RAYear); 
		setElement("RAMonth",rowData.RAMonth); 
		setElement("RAResourceTypeDR",rowData.RAResourceTypeDR); 
		setElement("RAResourceType",rowData.RAResourceType); 
		setElement("RAAmount",rowData.RAAmount); 
		setElement("RARate",rowData.RARate); 
		setElement("RAAllotAmount",rowData.RAAllotAmount); 
		setElement("RAAllotMode",rowData.RAAllotMode);
		setElement("RATotal",rowData.RATotal); 
		setElement("RAStatus",rowData.RAStatus); 
		setElement("RARemark",rowData.RARemark); 
		setElement("RAHold1",rowData.RAHold1); 
		setElement("RAHold2",rowData.RAHold2); 
		setElement("RAHold3",rowData.RAHold3); 
		setElement("RAHold4",rowData.RAHold4); 
		setElement("RAHold5",rowData.RAHold5); 
		SelectedRow=rowIndex;
		setEnabled(true);
	}
}
function setEnabled(isselected)
{
	//disableElement("BSave",isselected);
	disableElement("BDelete",!isselected);
	disableElement("BSubmit",!isselected);
	//disableElement("BFind",isselected);
}
function initElementData()
{
	var RAAllotMode = $HUI.combobox('#RAAllotMode',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: 'ԭֵ'
			},{
				id: '2',
				text: '����'
			},{
				id: '3',
				text: '������'
			}]
	});
	jQuery("#RAAmount").change(function(){
		getRAAllotAmountValue()
		});
	jQuery("#RARate").change(function(){
		getRAAllotAmountValue()
		});
	
}
function getRAAllotAmountValue()
{
	var RAAmount=getElementValue("RAAmount")
	var RARate=getElementValue("RARate")/100
	setElement("RAAllotAmount",RAAmount*RARate)
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	/*
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
	*/
}
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	if (getElementValue("RAResourceTypeDR")=="")
	{
		alertShow("��Դ����ID����Ϊ��!")
		return
	}
	var RAYear=getElementValue("RAYear")
	if ((RAYear<2015)||(RAYear>2100))
	{
		alertShow("��Ȳ��淶,���޸�(��:2021)!")
		return
	}
	var RAMonth=getElementValue("RAMonth")
	if ((RAMonth<0)||(RAMonth>12))
	{
		alertShow("�·ݲ��淶,���޸�(1--12)!")
		return
	}
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BSave",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",data,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.ba.resourceallot.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 ����ʧ�ܺ�����
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
///modified by ZY 2853221 20220818
function BDelete_Clicked()
{
    ///modified by ZY0301 20220523
    var RAStatus=getElementValue("RAStatus")
    if (RAStatus>0)
    {
        alertShow("��ʾ��Ϣ:��¼�Ѿ��ύ,����ɾ��!");
        return
    }
    
    messageShow("confirm","info","��ʾ","�Ƿ�ȷ��ɾ������?","",function(){
            var RARowID=getElementValue("RARowID")
            var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",RARowID,"0");
            jsonData=JSON.parse(jsonData)
            if (jsonData.SQLCODE==0)
            {
                var url="dhceq.ba.resourceallot.csp?"
                if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
					url += "&MWToken="+websys_getMWToken()
				}
                window.location.href= url;
            }
            else
            {
                alertShow("������Ϣ:"+jsonData.Data);
                return
            }
        },function(){
        return;
    },"ȷ��","ȡ��");
    
}
function BSubmit_Clicked()
{
	var RARowID=getElementValue("RARowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",RARowID,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.ba.resourceallot.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function BFind_Clicked()
{
	initDateGrid()
}

function initEvent()
{
	jQuery("#BImport").linkbutton({iconCls: 'icon-w-import'});
	jQuery("#BImport").on("click", BImport_Click);
}


function BImport_Click()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}
//modified by ZY0302 20220601
function BImport_Chrome()
{
	var RowInfo=EQReadExcel('','','��Դ����');
	RowInfo=RowInfo[0]
	if ((RowInfo=="")||(RowInfo.length<=1))		//add by czf 20200611 1342552 begin		//czf 20200811 1456821
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
		var UseLoc=trim(RowInfo[Row-1][Col++]);
		var Year=trim(RowInfo[Row-1][Col++]);
		var Month=trim(RowInfo[Row-1][Col++]);
		var ResourceType=trim(RowInfo[Row-1][Col++]);
		var Amount=trim(RowInfo[Row-1][Col++]);
		var Rate=trim(RowInfo[Row-1][Col++]);
		var AllotAmount=trim(RowInfo[Row-1][Col++]);
		var AllotMode=trim(RowInfo[Row-1][Col++]);	///1,2,3
		var Total=trim(RowInfo[Row-1][Col++]);
		if (UseLoc!="")
		{
			UseLoc=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",UseLoc);
			if (UseLoc=="")
			{
				alertShow("��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		if (ResourceType!="")
		{
			ResourceType=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCResourceType",ResourceType);
			if (ResourceType=="")
			{
				alertShow("��"+Row+"�� �豸��Դ���͵���Ϣ����ȷ:"+ResourceType);
				return 0;
			}
		}
		//var datas=[]
		var data={}
		data["RALocDR"]=UseLoc
		data["RAYear"]=Year
		data["RAMonth"]=Month
		data["RAResourceTypeDR"]=ResourceType
		data["RAAmount"]=Amount
		data["RARate"]=Rate
		data["RAAllotAmount"]=AllotAmount
		data["RAAllotMode"]=AllotMode
		data["RATotal"]=Total
		//datas.push(data)
		data=JSON.stringify(data);
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",data,"1");
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			Error="��"+Row+"����Ϣ����ʧ��!!!"+jsonData.Data
			alertShow(Error);
			Row=RowInfo.length+1
		}
	}
	if (Error=="")
	{
		messageShow('alert','info','��ʾ','������Դ������Ϣ�������!��˶������Ϣ.','',importreload,'');		
	}
}
function importreload()
{
	window.location.reload();
}
//modified by ZY0302 20220601
function BImport_IE()
{
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("��Դ����");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		var Year=trim(xlsheet.cells(Row,Col++).text);
		var Month=trim(xlsheet.cells(Row,Col++).text);
		var ResourceType=trim(xlsheet.cells(Row,Col++).text);		//czf 20200811
		var Amount=trim(xlsheet.cells(Row,Col++).text);
		var Rate=trim(xlsheet.cells(Row,Col++).text);
		var AllotAmount=trim(xlsheet.cells(Row,Col++).text);
		var AllotMode=trim(xlsheet.cells(Row,Col++).text);
		var Total=trim(xlsheet.cells(Row,Col++).text);
		if (UseLoc!="")
		{
			UseLoc=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",UseLoc);
			if (UseLoc=="")
			{
				alertShow("��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		if (ResourceType!="")
		{
			ResourceType=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCResourceType",ResourceType);
			if (ResourceType=="")
			{
				alertShow("��"+Row+"�� �豸��Դ���͵���Ϣ����ȷ:"+ResourceType);
				return 0;
			}
		}
		//var datas=[]
		var data={}
		data["RALocDR"]=UseLoc
		data["RAYear"]=Year
		data["RAMonth"]=Month
		data["RAResourceTypeDR"]=ResourceType
		data["RAAmount"]=Amount
		data["RARate"]=Rate
		data["RAAllotAmount"]=AllotAmount
		data["RAAllotMode"]=AllotMode
		data["RATotal"]=Total
		//datas.push(data)
		data=JSON.stringify(data);
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",data,"1");
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			alertShow("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ����ʧ��!!"+jsonData.Data);;
		}
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	alertShow("������Դ������Ϣ�������!��˶������Ϣ.");
	window.location.reload();
}
