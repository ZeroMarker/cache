///add by ZY0260 20210428 
///��ϸ����ҹ���
var editIndex=undefined;
var modifyBeforeRow = {};
var ContractListID=getElementValue("ContractListID");
var sysflag=getElementValue("sysflag")
//modified by ZY0267 2021607
var ArrivedNum=getElementValue("ArrivedNum")
var TotalNum=getElementValue("TotalNum")
if (ArrivedNum=="")  ArrivedNum=0
if (TotalNum=="") TotalNum=0
ArrivedNum=parseInt(ArrivedNum)
TotalNum=parseInt(TotalNum)
var Columns=getCurColumnsInfo('CON.G.Contract.ContractListLoc','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 �������Ч��Ӱ�� bug WY0060
});

function initDocument()
{
	initUserInfo();
    initMessage("Contract"); //��ȡ����ҵ����Ϣ
	defindTitleStyle(); 
	$HUI.datagrid("#tDHCEQContractListLoc",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContractListLoc",
	        	QueryName:"GetContractListLoc",
				ContractListID:ContractListID
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'����',  
				id:'add',        
                handler: function(){
                     insertRow();
                }},
                {
                iconCls: 'icon-cancel',
                text:'ɾ��',
				id:'delete',
                handler: function(){
                     deleteRow();
                }},
                {
                iconCls: 'icon-save',
                text:'����',
				id:'save',
                handler: function(){
                     BSave_Clicked();
                }},
                {
                iconCls: 'icon-accept',
                text:'ȫ������',
				id:'batchArrive',
                handler: function(){
                     BBatchArrive_Clicked();
                }}
                ],
        // add by zx 2019-07-23 ���༭��bug�޸�
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
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
		onLoadSuccess:function(){creatToolbar();}
	});
    setEnabled(); //��ť����
};
//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	var TotalNum=getElementValue("TotalNum")
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
    var totalCLLQuantityNum = 0;
    var totalCLLArrivedQuantityNum = 0;
    for (var i = 0; i < rows.length; i++)
    {
	    //if ((rows[i].CLLRowID=="")||(rows[i].CLLQuantity==rows[i].CLLArrivedQuantity)||(getElementValue("ReadOnly")!=1))
	    //{
		    //$("#CLLAction"+"z"+i).hide()
		//}
	    if (rows[i].CLLBuyLocDR!="")
	    {
        	var colValue=rows[i]["CLLQuantity"];
        	if (colValue=="") colValue=0;
        	totalCLLQuantityNum += parseFloat(colValue);
        	var colValue=rows[i]["CLLArrivedQuantity"];
        	if (colValue=="") colValue=0;
        	totalCLLArrivedQuantityNum += parseFloat(colValue);
        	
    	}
    	///add by ZY0261 20210511
    	if (rows[i].CLLRowID=="")
    	{
	    	$("#CLLAction"+"z"+i).hide()
	    }
    }
    //modified by ZY0267 20210607
	var lable_innerText='������:'+TotalNum+'&nbsp;&nbsp;&nbsp;��ϸ����:'+totalCLLQuantityNum+'&nbsp;&nbsp;&nbsp;�ѵ�������:'+ArrivedNum;	//totalCLLArrivedQuantityNum;
	$("#sumTotal").html(lable_innerText);
}
//modified by ZY0267 20210607
function setEnabled()
{
	var CTStatus=getElementValue("CTStatus");
	var ReadOnly=getElementValue("ReadOnly");
	//modified by ZY0256 20210325 ��֤�ύ֮�����޸�
	if ((CTStatus>0)||(ReadOnly==1))
	{
		disableElement("add",true);
		disableElement("delete",true);
		disableElement("save",true);
	}	
	///����ȫ������,����ˢ��֮��ť������
	var CanArriveNum=parseFloat(getElementValue("TotalNum"))
	var ArriveNum=parseFloat(getElementValue("ArrivedNum"))
	if ((CTStatus!=2)||(CanArriveNum<=ArriveNum))
	{
		disableElement("batchArrive",true);
		//hiddenObj("batchArrive",true);
		$("#tDHCEQContractListLoc").datagrid("hideColumn", "CLLArrivedQuantity");
		$("#tDHCEQContractListLoc").datagrid("hideColumn", "CLLAction");
	}
}

// ��������
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#tDHCEQContractListLoc").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = $("#tDHCEQContractListLoc").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    //modified by zy 20181120
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].CLLBuyLocDR=="")||(rows[lastIndex].CLLQuantity==""))
	    {
		    alertShow("��"+newIndex+"������Ϊ��!������д����.")
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#tDHCEQContractListLoc").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//�������е�ͼ��
		 
		$("#CLLAction"+"z"+newIndex).hide()
		
	}
}

function deleteRow()
{
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	if(rows.length<2)
	{
		messageShow("alert",'info',"��ʾ","��ǰ�в���ɾ��!");
		return;
	}
	if (editIndex != undefined)
	{
		jQuery("#tDHCEQContractListLoc").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		var CLLRowID=(typeof rows[editIndex].CLLRowID == 'undefined') ? "" : rows[editIndex].CLLRowID
		if (CLLRowID!="")
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContractListLoc","SaveData",CLLRowID,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE!=0)
		    {
				alertShow("ɾ��ʧ��:"+jsonData.Data);
				return
		    }
		    else
		    {
			    $('#tDHCEQContractListLoc').datagrid('deleteRow',editIndex);
			}
		}else
		{
			$('#tDHCEQContractListLoc').datagrid('deleteRow',editIndex);
		}
		
	}
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}
}

function BSave_Clicked()
{
	if (editIndex != undefined){ $('#tDHCEQContractListLoc').datagrid('endEdit', editIndex);}
	var TotalNum=getElementValue("TotalNum")
	var CurTotalNum=0
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		//modified by ZY0267 20210607
		if ((oneRow.CLLBuyLocDR=="")||(oneRow.CLLBuyLocDR==undefined)||(oneRow.CLLQuantity=="")||(oneRow.CLLQuantity==undefined))
		{
			alertShow("��"+(i+1)+"������Ϊ��,����д!")
			return "-1"
		}
		CurTotalNum=CurTotalNum+parseInt(oneRow.CLLQuantity)
		rows[i].CLLContractListDR=getElementValue("ContractListID")
	}
	if((CurTotalNum>TotalNum))
	{
		alertShow("��ϸ�ϼ���������������,���޸�!")
		return "-1"
	}
	if (CurTotalNum!=TotalNum)
	{
		messageShow("confirm","info","��ʾ","��Ϣ:��ϸ�ϼ���������������һ��,�Ƿ��������?","",OptSaveData,function(){
			return;
		});
	}
	else
	{
		OptSaveData();
	}
	
}	
function OptSaveData()
{
	var dataList=""
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
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
		alertShow("��ϸ����Ϊ��!");
		return;
	}
	disableElement("BSave",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContractListLoc","SaveData",dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var ContractListID=getElementValue("ContractListID");
		var ReadOnly=getElementValue("ReadOnly"); 
		var val="&ContractListID="+ContractListID+"&ReadOnly="+ReadOnly;
		url="dhceq.con.contractlistloc.csp?"+val
        websys_showModal("options").mth();
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}

function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#tDHCEQContractListLoc').datagrid('validateRow', editIndex)){
			$('#tDHCEQContractListLoc').datagrid('endEdit', editIndex);
    		var rows = $("#tDHCEQContractListLoc").datagrid('getRows');
    		// modified by ZY0269 20210615
    		/*
    		//if (!rows[editIndex].hasOwnProperty("CLLRowID"))
			var CLLRowID=(typeof rows[editIndex].CLLRowID == 'undefined') ? "" : rows[editIndex].CLLRowID
			if (CLLRowID=="")
    		{
			    $("#CLLAction"+"z"+editIndex).hide()
	    	}
	    	*/
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function onClickRow(index){
	var ReadOnly=getElementValue("ReadOnly");
	//if (ReadOnly>0) return
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#tDHCEQContractListLoc').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQContractListLoc').datagrid('getRows')[editIndex]);
		} else {
			$('#tDHCEQContractListLoc').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function getBuyLoc(index,data)
{
	var rowData = $('#tDHCEQContractListLoc').datagrid('getSelected');
	rowData.CLLBuyLocDR=data.TRowID;
	///modified by ZY02264 20210521
	var editor = $('#tDHCEQContractListLoc').datagrid('getEditor',{index:editIndex,field:'CLLBuyLoc_CTLOCDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQContractListLoc').datagrid('endEdit',editIndex);
	$('#tDHCEQContractListLoc').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	$("#CLLAction"+"z"+editIndex).hide()
}
function BBatchArrive_Clicked()
{
	/*
	var url='dhceq.em.arrive.csp?&SourceType=1&SourceID='+ContractListID;
	//size=modal,width=350,height=13row,title=����֪ͨ
	showWindow(url,"����֪ͨ",350,"13row","icon-w-paper","modal","","","modal",reloadGrid);
	*/
	//modified by ZY0198 �ַ��ж�����
	if (sysflag==2)
	{
        ///modified by ZY20230105 bug:3159848
        var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
        if (rows.length>1)
        {
            messageShow("confirm","info","��ʾ","����ϸ�Ƿ����ɵ�һ�����յ���?","",function(){
                sysflag=0;
                OptBatchArrive();
            },function(){
                sysflag=1;
                OptBatchArrive();
            });            
        }
        else
        {
            sysflag=1;
            OptBatchArrive();
        }
	}else
	{
		OptBatchArrive()
	}
}

function OptBatchArrive()
{
	var CanArriveNum=parseFloat(getElementValue("TotalNum"))
	var ArriveNum=parseFloat(getElementValue("ArrivedNum"))
	if ((CanArriveNum<1)||(ArriveNum>CanArriveNum))
	{
		//alertShow("���ε���������Ч!");
		messageShow('alert','info','��ʾ',"���ε���������Ч!");
		return;
	}
	var combindata=getElementValue("ProviderDR")
	
	
	var	TotalNum=parseFloat(getElementValue("TotalNum"))
	var CLLRowID=""
	var SourceType=1
	var SourceID=getElementValue("ContractListID")
    var totalCLLQuantityNum = 0;
    
	var valuelist=""
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
    	var CLLRowID=rows[i]["CLLRowID"];
    	var ArriveLocDR=rows[i]["CLLBuyLocDR"];
    	var CLLQuantity=rows[i]["CLLQuantity"];
    	if (CLLQuantity=="") CLLQuantity=0;
    	var CLLArrivedQuantity=rows[i]["CLLArrivedQuantity"];
    	if (CLLArrivedQuantity=="") CLLArrivedQuantity=0;
    	var ArriveNum=CLLQuantity-CLLArrivedQuantity
    	///modified by ZY02264 20210521
    	var RowData=SourceType+"^"+SourceID+"^"+ArriveNum+"^"+CLLRowID+"^"+ArriveLocDR;
    	if (sysflag==1)
    	{
	    	///modified by ZY0275 20210712
	    	if (ArriveNum==0)
	    	{
		    	TotalNum=TotalNum-CLLArrivedQuantity
		    	continue
		    }
		    else
		    {
		    	totalCLLQuantityNum += parseFloat(ArriveNum);
				if (valuelist=="")
				{
					valuelist=RowData;
				}
				else
				{
					valuelist=valuelist+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
				}
			}
	    }
	    else
	    {
	    	totalCLLQuantityNum += parseFloat(CLLArrivedQuantity);
	    }
	}
	var remainNum=TotalNum-totalCLLQuantityNum
	if (remainNum>0)
	{
		var RowData=SourceType+"^"+SourceID+"^"+remainNum+"^"+""+"^";
		if (valuelist=="")
		{
			valuelist=RowData;
		}
		else
		{
			valuelist=valuelist+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
		}
	}
	disableElement("batchArrive",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSArrive","SaveArriveRecord",combindata,valuelist,sysflag);	// MZY0058	2020-10-18
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var ContractListID=getElementValue("ContractListID");
		var ReadOnly=getElementValue("ReadOnly"); 
		var val="&ContractListID="+ContractListID+"&ReadOnly="+ReadOnly;
		url="dhceq.con.contractlistloc.csp?"+val
        websys_showModal("options").mth();
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("batchArrive",false)
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function reloadGrid()
{
	$HUI.datagrid("#tDHCEQContractListLoc",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContractListLoc",
	        	QueryName:"GetContractListLoc",
				ContractListID:ContractListID
		},
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){creatToolbar();}
	});
	// modified by ZY0269 20210615
	setEnabled()
}
