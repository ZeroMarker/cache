var columns=getCurColumnsInfo('RM.G.Rent.ShareResourceFind','','','');
//Modify by zx 2020-04-20 Bug ZX0084
var curTableID="tDHCEQShareResourceFind"
var paramsObj={
	firstFlag:'1',
	rentLocDR:'',
	rentStatus:'',
	equipStatus:'',
	isLoanOut:''
}
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
	//initButtonWidth();
	initShareType();
	initEquipStatus();
	//Modify by zx 2020-04-20 ��ʽ���� Bug ZX0084
	initDataGrid();
	//Modify by zx 2020-04-20 ��ʽ���� Bug ZX0084
	//���ά�����Ҳǩˢ��
	initShareSourceKeyWords();
	/*
	$HUI.tabs("#ShareSourceTabs",{
		onSelect:function(title)
		{
			paramsObj.rentLocDR=getElementValue("RentLocDR");
			paramsObj.rentStatus="";
			paramsObj.equipStatus="";
			paramsObj.firstFlag='0';
			if (title.indexOf("ȫ����Դ") != -1)
			{
				curTableID="tDHCEQShareResourceFind_All";
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
			}
			else if(title.indexOf("�ڿ���Դ") != -1)
			{
				curTableID="tDHCEQShareResourceFind_Stock";
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="0";
				paramsObj.isLoanOut="";
			}
			else if (title.indexOf("������Դ") != -1) //Modify by zx 2020-06-09 BUG ZX0100
			{
				curTableID="tDHCEQShareResourceFind_LoanOut";
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="1";
				paramsObj.isLoanOut="1";
			}
			else if (title.indexOf("������Դ") != -1) //Modify by zx 2020-06-09 BUG ZX0100
			{
				curTableID="tDHCEQShareResourceFind_LoanIn";
				paramsObj.rentLocDR=curLocID;
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
			}
			else if (title.indexOf("������Դ") != -1)
			{
				curTableID="tDHCEQShareResourceFind_Fault";
				paramsObj.rentLocDR="";
				paramsObj.equipStatus="1";
				paramsObj.isLoanOut="";
			}
			initDataGrid();
		}
	});
	*/
	//add by csj 2020-07-02 �ٴ��������ش������ϼ����� ����ţ�1396144
	var loctype=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","CheckLocType",curLocID)
	if(loctype==0)
	{
		$("#putOnSetAudit").hide()
	}
}

//add by czf 2022-07-15 UI�����޸� 2612994
function initShareSourceKeyWords()
{
	 $("#ShareSourceKeyWords").keywords({
        singleSelect:true,
        onClick:function(v){},
        onUnselect:function(v){
	    },
        onSelect:function(v){
	        var selectItemID=v.id;
	        paramsObj.rentLocDR=getElementValue("RentLocDR");
			paramsObj.rentStatus="";
			paramsObj.equipStatus=getStatusValue();      //modified by LMH 20220929 2804591    
			paramsObj.firstFlag='0';
			if (selectItemID=="AllResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if(selectItemID=="StockResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="0";
				paramsObj.isLoanOut="";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if (selectItemID=="LoanOutResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.rentStatus="1";
				paramsObj.isLoanOut="1";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if (selectItemID=="LoanInResource")
			{
				paramsObj.rentLocDR=curLocID;
				paramsObj.rentStatus="";
				paramsObj.isLoanOut="";
				setStatusValue('');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",false); //modified by LMH 20220929 2804591
			}
			else if (selectItemID=="FaultResource")
			{
				paramsObj.rentLocDR="";
				paramsObj.equipStatus="1";
				paramsObj.isLoanOut="";
				setStatusValue('1');  //modified by LMH 20220929 2804591
				disableElement("EquipStatus",true); //modified by LMH 20220929 2804591
			}
			initDataGrid();
	    },
        labelCls:'blue',
        items:[
            {text:'ȫ����Դ'+'<span class="eq-resourcenum" id="AllNum">0</span>',id:'AllResource',selected:true},
            {text:'�ڿ���Դ'+'<span class="eq-resourcenum" id="StockNum">0</span>',id:'StockResource'},
            {text:'������Դ'+'<span class="eq-resourcenum" id="LoanOutNum">0</span>',id:'LoanOutResource'},
            {text:'������Դ'+'<span class="eq-resourcenum" id="LoanInNum">0</span>',id:'LoanInResource'},
            {text:'������Դ'+'<span class="eq-resourcenum" id="FaultNum">0</span>',id:'FaultResource'}
        ]
    });
}

function initDataGrid()
{
	$HUI.datagrid("#"+curTableID,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"ShareResource",
			ShareType:getElementValue("ShareType"),
			EquipDR:getElementValue("EquipDR"),
			RentLocDR:paramsObj.rentLocDR,
			LocID:curLocID,
			UserID:curUserID,
			CurJob:getElementValue("Job"),
			RentStatus:paramsObj.rentStatus,
			EquipStatus:paramsObj.equipStatus,
			IsLoanOut:paramsObj.isLoanOut
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
			//�״μ��ؽ����������
			if(paramsObj.firstFlag=="1")
			{
				GetPutOnSetAuditNum();	//�������ϼ��������� add by csj 2020-07-02 ����ţ�1396144
				getToDoNum(); //��������
				getTotalInfo(); //ҳǩ��ʾ����
			}
			/*if (curTableID!="tDHCEQShareResourceFind_All")
			{
				$("#"+curTableID).datagrid("hideColumn", "REHistory");
			}
			else
			{*/
				$("#"+curTableID).datagrid('showColumn', "REHistory")
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
	            //��
	            for(var i=0;i<trs.length;i++){
	                //���ڵ�Ԫ��
	                for(var j=1;j<trs[i].cells.length;j++){
	                    var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
	                    var cell_value=$(row_html).find('div').html();
	                    if(cell_field == 'REWashFlag')
	                    {
		                    if(cell_value == "δ����")
		                    {
	                        	trs[i].cells[j].style.cssText='background:#f58800;color:#fff;';
			                }
			                else
			                {
				                $('#REWashz'+i).remove();
				            }
	                    }
	                    else if(cell_field == 'REInspectFlag')
	                    {
		                    if(cell_value == "δ����")
		                    {
	                        	trs[i].cells[j].style.cssText='background:#ffbd2e;color:#fff;';
			                }
			                else
			                {
				                $('#REInspectz'+i).remove();
				            }
	                    }
	                    else if(cell_field == 'REEquipStatus')
	                    {
		                    if(cell_value == "����")
		                    {
	                        	trs[i].cells[j].style.cssText='background:#ee4f38;color:#fff;';
			                }
			                else if(cell_value == "���")
			                {
				                trs[i].cells[j].style.cssText='background:#4caf50;color:#fff;';
				            }
	                    }
	                }
	                
		            if ((curTableID == "tDHCEQShareResourceFind_LoanOut")||(curTableID == "tDHCEQShareResourceFind_LoanIn"))
	                {
	                	$("#"+curTableID).datagrid("hideColumn", "REHistory");
	                }
	            }
			//}
			
		},
		onSelect:function(rowIndex,rowData){
			//fillData(rowData);
		}
	});
}

// Author add by zx 2019-12-19
// Desc �б��ѯ
// Input ��
// Output ��
// modified by sjh BUG0032 2020-08-31 �޸�Ԫ��ȡֵ��ʽ
function BFind_Clicked()
{
	paramsObj.rentLocDR = getElementValue("RentLocDR")  //added by LMH 20220929 2804591
	getStatusValue();	 ////added by LMH 20220929 2804591
	$HUI.datagrid("#"+curTableID,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"ShareResource",
			ShareType:getElementValue("ShareType"),
			EquipDR:getElementValue("EquipDR"),
			RentLocDR:paramsObj.rentLocDR,                   //Modefied by zc0101 2021-5-13 ��getElementValue("RentLocDR")�ĳ�ȡparamsObj.rentLocDR //Modify by mwz 2020-12-28 BUG MWZ0043
			LocID:curLocID,
			UserID:curUserID,
			CurJob:getElementValue("Job"),
			RentStatus:paramsObj.rentStatus,       //Modefied by zc0101 2021-5-13 ��getElementValue("RentStatus")�ĳ�ȡparamsObj.rentStatus
			EquipStatus:paramsObj.equipStatus,     //Modefied by zc0101 2021-5-13 ��getElementValue("EquipStatus")�ĳ�ȡparamsObj.equipStatus
			IsLoanOut:paramsObj.isLoanOut			//Modefied by zc0101 2021-5-13 ��getElementValue("IsLoanOut")�ĳ�ȡparamsObj.isLoanOut
		}
	});
}

// Author add by zx 2019-12-19
// Desc ��Դ�ϼ�
// Input ��
// Output ��
function addShareResource()
{
	var url="dhceq.rm.shareresource.csp?";
	showWindow(url,"���޹�����Դά��","","","icon-w-paper","modal","","","middle",reloadGrid);  //modify by lmm 2020-06-05 UI
}

// Author add by zx 2019-12-19
// Desc ��ʼ����Դ����Ϊcombobox
// Input ��
// Output ��
function initShareType()
{
	var Status = $HUI.combobox('#ShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"0",
		data:[{
				id: '0',
				text: '�豸'
			}]
	});
}

// Author add by zx 2019-12-19
// Desc ��ʼ����Դ����Ϊcombobox
// Input ��
// Output ��
function initEquipStatus()
{
	var Status = $HUI.combobox('#EquipStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '���'
			},{
				id: '1',
				text: '����'
			},{
				id: '2',
				text: '����'
			}]
	});
}

function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}
function clearData(elementID)
{
	setElement(elementID+"DR","")
}

// Author add by zx 2019-12-19
// Desc ������롢��Դ�ϼ� ģ̬���رպ�ˢ���б�
// Input ��
// Output ��
function reloadGrid()
{
	$("#"+curTableID).datagrid('reload');
}

function rentRequest()
{
	var url="dhceq.rm.rentrequest.csp?";
	showWindow(url,"��������","840","235","icon-w-paper","modal","","","",reloadGrid);    //modify by mwz 2022-07-14 UI  //modified by LMH 20220929 2801466 ����ģ̬����С //modified by LMH 20230206 UI�����߶�
}

// Author add by zx 2019-12-19
// Desc ������Դ��ز�������ʷ��¼
// Input ��
// Output ��
function rentAudit()
{
	var url="dhceq.rm.rentdolist.csp?";
	showWindow(url,"���޵���Ϣ","1050px","","icon-w-paper","modal","","","middle",reloadGrid);    //modify by lmm 2020-06-04 UI  //modified by LMH 20230215 UI ���󵯿��� 
}

// Author add by zx 2019-12-19
// Desc ����ͳ��
function rentStat()
{
	//var url="dhceq.rm.rentstatistics.csp?ReportFileName=DHCEQRentStatistic1.raq";
	var url="dhceq.rm.rentstat.csp?";
	showWindow(url,"����ͳ��","","","icon-w-paper","modal","","","large");    //modify by lmm 2020-06-04 UI
}
// Author add by CSJ 2020-07-02 ����ţ�1396144
// Desc ��������Դ�ϼ�
// Input ��
// Output ��
function putOnSetAudit()
{
	var url="dhceq.rm.putonset.csp?StatusDR=1&NoCurDateFlag=N&OuterTypeAllFlag=Y";
	showWindow(url,"��������Դ�ϼ�","","","icon-w-paper","modal","","","large");  
}

// Author add by CSJ 2020-07-02 ����ţ�1396144
// Desc ��������Դ�ϼ�����
function GetPutOnSetAuditNum()
{
	$m({
		ClassName:"web.DHCEQ.RM.BUSPutOnSet",
		MethodName:"GetPutOnSetAuditNum",
	},function(textData){
		$("#putOnSetToDoNum").text(textData);
	});
}
// Author add by zx 2020-01-10
// Desc ������Դ��ز�������ʷ��¼
// Input ��
// Output ��
function getToDoNum()
{
	$m({
		ClassName:"web.DHCEQ.RM.BUSShareResource",
		MethodName:"GetBussAlertNum",
		GroupID:curSSGroupID,
		UserID:curUserID
	},function(textData){
		$("#ToDoNum").text(textData);
	});
}

// Author add by zx 2020-02-14
// Desc datagrid��������
// Input ��
// Output ��
// Modify by zx 2020-04-20 Bug ZX0084
function getTotalInfo()
{
	$m({
		ClassName:"web.DHCEQ.RM.BUSShareResource",
		MethodName:"GetTotalInfo",
		CurJob:getElementValue("Job")
	},function(textData){
		var totalInfo=textData.split("^")
		$("#AllNum").html(totalInfo[0]);
		$("#StockNum").html(totalInfo[1]);
		$("#LoanOutNum").html(totalInfo[2]);
		$("#LoanInNum").html(totalInfo[3]);
		$("#FaultNum").html(totalInfo[4]);
	});
}

// Author add by zx 2019-12-19
// Desc ������Դ��ز���--��ϴ����
// Input curIndex:��ǰ��λ��
// Output ��
function BWashClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var washFlag = rowData.REWashFlag;
	var shareResourceDR = rowData.RERowID;
	if (washFlag=="��")
	{
		messageShow('alert','info','��ʾ',"����Դ����Ҫ��ϴ������");
	}
	else
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeShareResourceStatus",shareResourceDR, "1");
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0)
		{
			$("#"+curTableID).datagrid('reload'); 
		}
		else
		{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
		}
	}
}


// Author add by zx 2019-12-19
// Desc ������Դ��ز���--���
// Input curIndex:��ǰ��λ��
// Output ��
function BInspectClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var inspectFlag = rowData.REInspectFlag;
	var shareResourceDR = rowData.RERowID;
	if (inspectFlag=="��")
	{
		messageShow('alert','info','��ʾ',"����Դ����Ҫ��⣡");
	}
	else
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeShareResourceStatus",shareResourceDR, "2");
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0)
		{
			$("#"+curTableID).datagrid('reload'); 
		}
		else
		{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
		}
	}
}

// Author add by zx 2019-12-19
// Desc ������Դ��ز���--�¼�
// Input curIndex:��ǰ��λ��
// Output ��
function BPutOffClick(curIndex)
{
	$.messager.confirm("�¼�����", "ȷ��Ҫ�¼���̨�豸?", function (r) {
		if (r) {
			var rowsData = $("#"+curTableID).datagrid("getRows");
			var rowData = rowsData[curIndex];
			if(rowData.RERentLocDR_DeptDesc!="")
			{
				messageShow('alert','error','��ʾ',"�������豸�������¼ܣ�");
				return;
			}
			var shareResourceDR = rowData.RERowID;
			var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","PutOffShareResource",shareResourceDR);
			jsonData=JSON.parse(jsonData);
			if (jsonData.SQLCODE==0)
			{
				$("#"+curTableID).datagrid('reload'); 
			}
			else
			{
				messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
				return;
			}
		} else {
			return;
		}
	});

}

// Author add by zx 2020-04-20
// Desc ������Դ����
// Input curIndex:��ǰ��λ��
// Output ��
function BMaintRequest(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var equipID=rowData.REEquipDR;
	var url="dhceq.em.mmaintrequestsimple.csp?ExObjDR="+equipID+"&QXType=&WaitAD=off&Status=0&RequestLocDR="+curLocID+"&StartDate=&EndDate=&InvalidFlag=N&vData=^Action=^SubFlag=&LocFlag="+curLocID;
	showWindow(url,"ά������","","","icon-w-paper","modal","","","small"); //modify by lmm 2020-06-05 UI
}

/**
 * �������ʽ�����豸״ֵ̬
 * @input  ��
 * @output  
 * @returns ��
 * @author LMH 20220929 2804591
 */
var getStatusValue = function()
{
	paramsObj.equipStatus = $("#EquipStatus").combobox('getValue'); 
}

/**
 * �������ʽ�����豸״ֵ̬
 * @input  Id��comboboxֵ��Ӧid
 * @output  
 * @returns ��
 * @author LMH 20220929 2804591
 */
var setStatusValue = function(Id)
{
	if (Id === '') $("#EquipStatus").combobox('setValue',Id);
	else if (Id === '1') $("#EquipStatus").combobox('setValue',Id)
}
