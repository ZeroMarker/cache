// ..\web\scripts\dhceq\mp\return.js

var editIndex=undefined;
var ARRowID=getElementValue("ARRowID");
var Columns=getCurColumnsInfo('MP.G.AReturn.ReturnList','','','');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});

function initDocument()
{
	setElement("ARMakeDate",GetCurrentDate())
	setElement("ARLocDR_CTLOCDesc",getElementValue("ARLoc"))
	setElement("ARAccessoryTypeDR_ATDesc",getElementValue("ARAccessoryType"))
	
	initUserInfo();
    initMessage("MP"); 	//��ȡҵ����Ϣ
    initLookUp(); 		//��ʼ���Ŵ�
    // MZY0074	1850251		2021-04-30
    var paramsFrom=[{"name":"Type","type":"2","value":"2"},{"name":"LocDesc","type":"1","value":"ARLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("ARLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle(); //hisui���title��ʽ����
    initButton(); 		//��ť��ʼ��
    //initPage(); 		//��ͨ�ð�ť��ʼ��
    initButtonWidth();
	
    setRequiredElements("ARReduceType_Desc^ARAccessoryTypeDR_ATDesc^ARLocDR_CTLOCDesc^ARProviderDR_VDesc");	//����������
    fillData(); 		//�������
    setEnabled(); 		//��ť����
    //setElementEnabled(); //�����ֻ������ 
    //initEditFields(); //��ȡ�ɱ༭�ֶ���Ϣ
    initApproveButton(); //��ʼ��������ť
    
	$HUI.datagrid("#DHCEQAReduce",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.MP.BUSReduce",
	        	QueryName:"GetAReduceList",
				RowID:ARRowID
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'����',  
				id:'add',        
                handler: function(){
                     insertRow();
                }},/// MZY0025		1254598		2020-05-13		ȡ����ť�ļ��
                {
                iconCls: 'icon-cancel',
                text:'ɾ��',
				id:'delete',
                handler: function(){
                     deleteRow();
                }
        }],
		rownumbers: true,  //���Ϊtrue����ʾһ���к���
		singleSelect:true,
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			creatToolbar();
			//alertShow(getElementValue("ARReduceType"))
			if (getElementValue("ARReduceType")==1)
			{
				//�˻���
			}
			else
			{
				$("#DHCEQAReduce").datagrid("hideColumn", "ARLHold1_RRDesc");
			}
		}
	});
};

//���"�ϼ�"��Ϣ
function creatToolbar()
{
	var lable_innerText='������:'+totalSum("DHCEQAReduce","ARLQuantityNum")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalSum("DHCEQAReduce","ARLAmount").toFixed(2)
	$("#sumTotal").html(lable_innerText);
	
    //����toolbar��ť����
	var Status=getElementValue("ARStatus");
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
		// MZY0027	1326004		2020-05-21	���ذ�ť
		hiddenObj("BSave",1);
		hiddenObj("BDelete",1);
		hiddenObj("BSubmit",1);
	}
	if (Status!=2) hiddenObj("BPrint",1);	// MZY0025		1254598		2020-05-13
	setElement("ARJob",$('#DHCEQAReduce').datagrid('getData').rows[0].TJob);
}

function fillData()
{
	if (ARRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","GetOneAReduce",ARRowID)
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	//oneFillData=jsonData.Data;
}
function setEnabled()
{
	var Status=getElementValue("ARStatus");
	var WaitAD=getElementValue("WaitAD");
	var ReadOnly=getElementValue("ReadOnly");
	if (Status!="0")
	{
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
		if (Status!="")
		{
			disableElement("BSave",true)
		}
	}
	//��˺�ſɴ�ӡ������ת�Ƶ�
	if (Status!="2")
	{
		disableElement("BPrint",true)
	}
	//�ǽ����ݲ˵�,���ɸ��µȲ�������
	if (WaitAD!="off")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		setElement("ReadOnly",1);	//�ǽ����ݲ˵���Ϊֻ��
	}
}

function onClickRow(index)
{
	if (getElementValue("ARAccessoryTypeDR")=="")
	{
		messageShow('alert','error','��ʾ',"�������鲻��Ϊ��,��ѡ���������!");
		return
	}
	if (getElementValue("ARReduceType")==1)
	{
		if (getElementValue("ARProviderDR")=="")
		{
			messageShow('alert','error','��ʾ',"��Ӧ�̲���Ϊ��,��ѡ��Ӧ��!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','��ʾ',"�˻����Ų���Ϊ��,��ѡ���˻�����!");
			return
		}
	}
	else
	{
		if (getElementValue("ARReduceType")=="")
		{
			messageShow('alert','error','��ʾ',"�������Ͳ���Ϊ��,��ѡ���������!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','��ʾ',"���Ҳ��Ų���Ϊ��,��ѡ����Ҳ���!");
			return
		}
	}
	var Status=getElementValue("ARStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQAReduce').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			bindGridEvent();  //�༭�м�����Ӧ
		} else {
			$('#DHCEQAReduce').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQAReduce");        // ������
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'ARLQuantityNum'});	// ����
        // ����  ���뿪�¼�
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQAReduce').datagrid('getSelected');
            var Num=$(invQuantityEdt.target).val();
            if (Num<0)
            {
	            messageShow('alert','error','��ʾ',t[-9215]);
	            $(invQuantityEdt.target).val(Num);
	            return;
	        }
            // ���������������� ���
            var price=parseFloat(rowData.ARLPrice);
			rowData.ARLAmount=price*Num;	// Mozy0243	2020-01-11	1173134	������������
			$('#DHCEQAReduce').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQAReduce').datagrid('validateRow', editIndex))
	{
		$('#DHCEQAReduce').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	}
	else
	{
		return false;
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="ARReduceType_Desc") {setElement("ARReduceType",rowData.TRowID)}
	else if(elementID=="ARAccessoryTypeDR_ATDesc") {setElement("ARAccessoryTypeDR",rowData.TRowID)}
	else if(elementID=="ARLocDR_CTLOCDesc") {setElement("ARLocDR",rowData.TRowID)}
	else if(elementID=="ARProviderDR_VDesc") {setElement("ARProviderDR",rowData.TRowID)}
}

//�������ѡ��ֵ(�Ŵ�)
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
}

// ��������
function insertRow()
{
	if(editIndex>="0") jQuery("#DHCEQAReduce").datagrid('endEdit', editIndex);	//�����༭����֮ǰ�༭����
    var rows = $("#DHCEQAReduce").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].ARLItemDR=="")||(rows[lastIndex].ARLItemDR==undefined))
	    {
		    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.')
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#DHCEQAReduce").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	if (editIndex>=0)
	{
		jQuery("#DHCEQAReduce").datagrid('endEdit', editIndex);//�����༭����֮ǰ�༭����
	}
	removeCheckBoxedRow("DHCEQAReduce");	//ɾ����
}
/// ��ϸ��¼������Ʒ��ش���
function GetAStockDetail(index,data)
{
	// data:
	// TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,
	// TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,
	// THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag,
	// TBillPage,TInvoiceNos,TFundsType
	// Mozy003004	1246570		2020-3-30
	var rows = $('#DHCEQAReduce').datagrid('getRows'); 
	if(data.TRowID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// Mozy003013	1280145 	2020-04-18	�����ظ�ѡ��
			if ((editIndex!=i)&&(rows[i].ARLStockDetailDR==data.TRowID))
			{
				messageShow('alert','error','��ʾ','��ǰѡ��������ϸ�е�'+(i+1)+'���ظ�!!')
				return;
			}
		}
	}
	var rowData = $('#DHCEQAReduce').datagrid('getSelected');
	rowData.ARLItemDR=data.TItemDR;
	rowData.ARLBaseUOMDR=data.TBaseUOMDR;
	rowData.ARLBaseUOMDR_UOMDesc=data.TBaseUOM;
	rowData.ARLStockDetailDR=data.TRowID;
	rowData.ARLManuFactoryDR=data.TManuFactoryDR;
	rowData.ARLManuFactoryDR_MDesc=data.TManuFactory;
	rowData.ARLHold2=data.TAInStockListDR;
	rowData.ARLCode=data.TCode;
	rowData.ARLModel=data.TModel;
	rowData.ARLPrice=data.TBprice;
	rowData.ARLQuantityNum=data.TStock;				//���
	//rowData.AMSLQuantityNum=data.CanUseNum;
	rowData.ARLAmount=data.TBprice*data.TStock;		// Mozy0243	2020-01-11	1173134	�����ܽ��
	rowData.ARLSerialFlag=data.TSerialFlag;
	rowData.ARLSerialNo=data.TSerialNo;
	rowData.ARLAInStockNo=data.TInStockNo;
	rowData.ARLInvoiceNos=data.TInvoiceNos;
	rowData.ARLFundsType=data.TFundsType;
	
	var quantityEdt = $('#DHCEQAReduce').datagrid('getEditor', {index:editIndex,field:'ARLQuantityNum'}); // ����
	$(quantityEdt.target).val(data.TStock);
	// MZY0057	1454499		2020-10-09	����"�������"��ֵ��ʽ
	//var editor = $('#DHCEQAReduce').datagrid('getEditors', editIndex);
	//$(editor[0].target).combogrid("setValue",data.TDesc);
	var ARLDescEdt = $('#DHCEQAReduce').datagrid('getEditor', {index:editIndex,field:'ARLDesc'});
	$(ARLDescEdt.target).combogrid("setValue",data.TDesc);
	$('#DHCEQAReduce').datagrid('endEdit',editIndex);
	$('#DHCEQAReduce').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
/// ��ϸ��¼�˻�ԭ�򷵻ش���
function GetReturnReason(index,data)
{
	var rowData = $('#DHCEQAReduce').datagrid('getSelected');
	rowData.ARLHold1=data.TRowID;
	// MZY0057	1454499		2020-10-09	����"�˻�ԭ��"��ֵ��ʽ
	//var editor = $('#DHCEQAReduce').datagrid('getEditors', editIndex);
	//$(editor[3].target).combogrid("setValue",data.TDesc);
	var ARLHold1RRDescEdt = $('#DHCEQAReduce').datagrid('getEditor', {index:editIndex,field:'ARLHold1_RRDesc'});
	$(ARLHold1RRDescEdt.target).combogrid("setValue",data.TDesc);
	$('#DHCEQAReduce').datagrid('endEdit',editIndex);
	$('#DHCEQAReduce').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
function BSave_Clicked()
{
	if (getElementValue("ARAccessoryTypeDR")=="")
	{
		messageShow('alert','error','������ʾ','�������鲻��Ϊ��!')
		return
	}
	if (getElementValue("ARReduceType")==1)
	{
		if (getElementValue("ARProviderDR")=="")
		{
			messageShow('alert','error','��ʾ',"��Ӧ�̲���Ϊ��,��ѡ��Ӧ��!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','��ʾ',"�˻����Ų���Ϊ��,��ѡ���˻�����!");
			return
		}
	}
	else
	{
		if (getElementValue("ARReduceType")=="")
		{
			messageShow('alert','error','��ʾ',"�������Ͳ���Ϊ��,��ѡ���������!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','��ʾ',"���Ҳ��Ų���Ϊ��,��ѡ����Ҳ���!");
			return
		}
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList="";
	if (editIndex != undefined){ $('#DHCEQAReduce').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQAReduce').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		// MZY0034	1376749		2020-06-24	�������ҵ����ϸ�ռ�¼�жϴ���
		if ((oneRow.ARLItemDR=="")||(oneRow.ARLItemDR==undefined))
		{
			messageShow('alert','error','������ʾ','��'+(i+1)+'�����ݲ���ȷ!')
			return "-1"
		}
		if ((oneRow.ARLQuantityNum=="")||(parseInt(oneRow.ARLQuantityNum)<=0))
		{
			messageShow('alert','error','������ʾ','��'+(i+1)+'�����ݲ���ȷ!')
			return "-1"
		}
		oneRow["ARLIndex"]=i; 		//indexֵ����
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (dataList=="")
	{
		alertShow("ת����ϸ����Ϊ��!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","SaveData",data,dataList);
	//alertShow(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("ARStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")==1) url="dhceq.mp.return.csp?";	// Mozy0239		2019-12-17
	    window.location.href=url+val;
	}
	else
    {
		messageShow('show','error','������ʾ',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','������ʾ',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","DeleteData",ARRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var val="&WaitAD="+getElementValue("WaitAD")+"&QXType="+getElementValue("QXType")+"&Type="+getElementValue("Type");
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";	// Mozy003003	1246567		2020-3-27
	    window.location.href= url+val;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','������ʾ',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","SubmitData",ARRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		// Mozy003019		2020-04-28
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";
	    window.location.href=url+val;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','������ʾ',t[-9003]);
		return;
	}
	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","CancelSubmitData",ARRowID,getElementValue("CurRole"),getElementValue("CancelToFlowDR"));
	//alertShow(ARRowID+","+getElementValue("CurRole")+","+getElementValue("CancelToFlowDR"))
    var RtnObj=JSON.parse(Rtn);
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','������ʾ',RtnObj.Data);
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		// Mozy003019		2020-04-28
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";
	    window.setTimeout(function(){window.location.href=url+val},50); 
    }
}
function BApprove_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','������ʾ',t[-9003]);
		return;
	}
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
  	//alertShow(ARRowID+","+getElementValue("AISJob")+","+CurRole+","+RoleStep)
  	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","AuditData",ARRowID,CurRole,RoleStep);
    var RtnObj=JSON.parse(Rtn);
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','������ʾ',RtnObj.Data);
    }
    else
    {
	    //messageShow("","","",t[0])
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		// Mozy003019		2020-04-28
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";
	    window.setTimeout(function(){window.location.href=url+val},50); 
    }
}
function BPrint_Clicked()
{
	/*if (ARRowID=="")
	{
		messageShow('alert','error','������ʾ',t[-9003])
		return;
	}
	var gbldata=tkMakeServerCall("web.DHCEQAMoveStock","GetList",ARRowID);
	var list=gbldata.split(getElementValue("SplitNumCode"));
	var Listall=list[0];
	var rows=list[1];
	var PageRows=8;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	var movetype=getElementValue("AMSMoveType");
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template;
    	Template=TemplatePath+"DHCEQAMoveStock.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var sort=34;
	    var Listsort=18;	
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	
	    	if (movetype=="0")
			{
				xlsheet.cells(1,2)="[Hospital]������ⵥ";
				xlsheet.cells(2,8)="���ⵥ��:"+oneFillData["AMSMoveNo"];  //����
		    	//xlsheet.cells(3,6)=GetShortName(oneFillData["AMSFromLocDR_CTLOCDesc"],"-");//��������
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AMSToLocDR_CTLOCDesc"],"-");//���ղ���
	    	}
			else if (movetype=="1")
			{
		    	xlsheet.cells(1,2)="[Hospital]������䵥";
		    	xlsheet.cells(2,8)="���䵥��:"+oneFillData["AMSMoveNo"];  //����
		    	//xlsheet.cells(3,6)=GetShortName(oneFillData["AMSFromLocDR_CTLOCDesc"],"-");//��������
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AMSToLocDR_CTLOCDesc"],"-");//���ղ���
			}
	    	if (movetype=="2")
	    	{
		    	xlsheet.cells(1,2)="[Hospital]����˿ⵥ";
		    	xlsheet.cells(2,8)="�˿ⵥ��:"+oneFillData["AMSMoveNo"];  //����
		    	//xlsheet.cells(3,6)=GetShortName(oneFillData["AMSFromLocDR_CTLOCDesc"],"-");//��������
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AMSToLocDR_CTLOCDesc"],"-");//���ղ���
	    	}
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"));
	    	xlsheet.cells(2,6)=ChangeDateFormat(oneFillData["AMSMakeDate"]);	    	
	    	//xlsheet.cells(3,2)="����:"+oneFillData["AMSAccessoryTypeDR_ATDesc"];
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Lists=Listall.split(getElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+Row];
				//alertShow(Listl);
				var List=Listl.split("^");
				var cellRow=Row+3;
				if (List[4]=='�ϼ�') cellRow=11;
				xlsheet.cells(cellRow,2)=List[4];//�������
				xlsheet.cells(cellRow,4)=List[5];//����
				xlsheet.cells(cellRow,5)=List[Listsort+2];//��λ
				xlsheet.cells(cellRow,6)=List[11];//����
				xlsheet.cells(cellRow,7)=List[10];//ԭֵ
				xlsheet.cells(cellRow,8)=List[12];//�ܼ�
				//xlsheet.cells(cellRow,8)=List[Listsort+3];//��������
				xlsheet.cells(cellRow,9)=List[Listsort+4];//��ⵥ��
	    	}
		    xlsheet.cells(12,2)=xlsheet.cells(12,2)+oneFillData["AMSReciverDR_SSUSRName"]; //������
		    xlsheet.cells(12,5)=xlsheet.cells(12,5)+curUserName+" "; //�Ƶ���
		    xlsheet.cells(12,9)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"; 
		    
		    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
			var size=obj.GetPaperInfo("DHCEQInStock");
			if (0!=size) xlsheet.PageSetup.PaperSize = size;
		    
		    //xlsheet.printout; //��ӡ���
		    xlApp.Visible=true;
    		xlsheet.PrintPreview();
		    xlBook.Close(savechanges=false);
		    xlsheet.Quit;
		    xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		messageShow('alert','error',e.message,t[-9003])
	}
	tkMakeServerCall("web.DHCEQOperateLog","SaveData","^A02^"+ARRowID,1);*/
	//��ӡ���ݲ��÷�ʽ		0:Excel 1:��Ǭ

	var fileName="" // modify by wl 2019-12-23 WL0041 begin
	if (getElementValue("PrintFlag")==1)
	{
		//ϵͳ��ӡ����Ĭ���Ƿ�Ԥ��	 0:��Ԥ�� 1:Ԥ��
		if(getElementValue("PreviewRptFlag")==1)
		{ 
			fileName="DHCEQAReduce.raq&RowID="+ARRowID+"&CurGroupID="+curGroupID ;   
			DHCCPM_RQPrint(fileName);
		}
		else
		{ 
		    fileName="{DHCEQAReduce.raq(RowID="+ARRowID+";CurGroupID="+curGroupID+")}";  // modify by wl 2019-12-23 WL0041 end
	        DHCCPM_RQDirectPrint(fileName);		//��Ǭֱ�Ӵ�ӡ
		}
	}
}
