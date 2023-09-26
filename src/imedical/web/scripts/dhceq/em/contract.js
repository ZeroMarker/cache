var editIndex=undefined;
var modifyBeforeRow = {};
var CTRowID=getElementValue("CTRowID");
var Columns=getCurColumnsInfo('CON.G.Contract.ContractList','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});

function initDocument()
{
	//modified zy 20191012 
	setElement("CTSignLocDR_CTLOCDesc",getElementValue("CTSignLoc"))
	initUserInfo();
    initMessage("Contract"); 	//��ȡ����ҵ����Ϣ
    initLookUp(); 			//��ʼ���Ŵ�
    initCTHold1();			//��ʼ����ͬ����	add by CZF0067 2020--03-12		
    defindTitleStyle();
    initButton(); 				//��ť��ʼ�� 
    initButtonWidth();
    InitEvent()
    setRequiredElements("CTContractName^CTProviderDR_VDesc^CTSignDate"); //������
    setElement("CTSignDate",GetCurrentDate());		//Mozy	929782	2019-06-13
    fillData(); 				//�������
    setEnabled(); 				//��ť����
    //initPage(); 				//��ͨ�ó�ʼ��
    setElementEnabled(); 		//�����ֻ������ 	//Mozy	868476	2019-5-10
    //initEditFields(); 		//��ȡ�ɱ༭�ֶ���Ϣ
    initApproveButtonNew(); 		//��ʼ��������ť
    if (getElementValue("CTContractType")=="1") setRequiredElements("CTEndDate^CTTotalFee"); // Mozy003011	2020-04-14
	$HUI.datagrid("#DHCEQContract",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContract",
	        	QueryName:"GetContractList",
		        RowID:CTRowID
		},
	    toolbar:[
	    	{
				iconCls: 'icon-add',
	            text:'����',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },		/// Mozy003006		2020-04-29		ȡ����ť�ļ��
	        {
	            iconCls: 'icon-cancel',
	            text:'ɾ��',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        }
	    ],
		rownumbers: true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,		// Mozy0243	2020-01-11	1146266
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40],
		onLoadSuccess:function(){
			creatToolbar();
			// ����������
			if (getElementValue("CTContractType")==1)
			{
				//���޺�ͬ
				//$("#DHCEQContract").datagrid("showColumn", "CTLContractConfig");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy	1068113	2019-10-26	Mozy0227
				// Mozy003011	2020-04-14
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");
			}
			if (getElementValue("CTContractType")==2)
			{
				//Э���ͬ
				$("#DHCEQContract").datagrid("hideColumn", "CTLQuantityNum");
				$("#DHCEQContract").datagrid("hideColumn", "CTLTotalFee");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");	// Mozy	836945	2019-3-10
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy0230		2019-11-11	1090361
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");
			}
			if (getElementValue("CTStatus")=="") $("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");	// Mozy	836945	2019-3-10
			// Mozy		2019-10-22	���ذ�ť
			if ((getElementValue("CTStatus")==1)||(getElementValue("CTStatus")==2))
			{
				hiddenObj("BSave",1);
				hiddenObj("BDelete",1);
				hiddenObj("BSubmit",1);
			}
			if (getElementValue("CTHold1")==2) $("#DHCEQContract").datagrid("hideColumn", "CTLAction");		//modified by czf 1243349 ���̺�ͬ��������
		}
	});
};

function InitEvent() //��ʼ��
{
	/*	 MZY0024	1311628		2020-05-09	ȡ��"�˻�"�¼��ظ�����
	if (jQuery("#BCancelSubmit").length>0)
	{
		jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
	}*/
	if (jQuery("#BPayPlan").length>0)
	{
		jQuery("#BPayPlan").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BPayPlan").on("click", BPayPlan_Clicked);
	}
	if (jQuery("#BCopy").length>0)
	{
		jQuery("#BCopy").linkbutton({iconCls: 'icon-w-copy'});
		jQuery("#BCopy").on("click", BCopy_Clicked);
	}
	//modified zy 20191012 �����豸��ά���İ�ť�¼�
	if (jQuery("#BMasterItem").length>0)
	{
		jQuery("#BMasterItem").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BMasterItem").on("click", MenuMasterItem);
	}
	//Modify by zx 2020-02-25 BUG ZX0077
	if (jQuery("#BAppendFile").length>0)
	{
		jQuery("#BAppendFile").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BAppendFile").on("click", BAppendFile_Clicked);
	}
	//add by CZF0090 2020-03-06
	$("#BProvider").on("click", BProvider_Clicked);
}
function initPage() //��ʼ��
{
	//
}
//��Ӻϼ���Ϣ
function creatToolbar()
{
	var lable_innerText='������:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2)
	if (getElementValue("CTContractType")==1) lable_innerText='ά���豸������:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;ά���豸�ܽ��:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2);	// Mozy003011	2020-04-14
	$("#sumTotal").html(lable_innerText);
	if (getElementValue("CTContractType")==2) $("#sumTotal").remove();	// Mozy003004	1247770		2020-3-30	Э���ͬ����ʾ�ϼ���
	var panel = $("#DHCEQContract").datagrid("getPanel");
	var rows = $("#DHCEQContract").datagrid('getRows');
	//ͼ��Ӱ��
    for (var i = 0; i < rows.length; i++) {
	    if ((rows[i].CTLSourceType=="")&&(rows[i].CTLSourceID==""))
	    {
		    $("#ContractConfig"+"z"+i).hide();
		}
    }
	//��ť�һ�
	var Status=getElementValue("CTStatus");
	if (Status>0)
	{
		// Mozy		2019-10-22	��Ч��ť
		disableElement("add",true);
		disableElement("delete",true);
	}
}
function fillData()
{
	if (CTRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetOneContract",CTRowID);
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
}
function setEnabled()
{
	var Type=getElementValue("Type");
	var Status=getElementValue("CTStatus");
	var ContractNoFlag=getElementValue("ContractNoFlag");
	var ReadOnly=getElementValue("ReadOnly");
	//alertShow("Type="+Type)
	//alertShow("CTStatus="+Status)
	if (ReadOnly=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BCancelSubmit",true);
		disableElement("BScan",true);
		disableElement("BApprove1",true);
		disableElement("BApprove2",true);
		disableElement("BApprove3",true);
		hiddenObj("BCancel",1);		// Mozy0253	1215171		2020-3-4
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		
		return;
	}
	if (Status=="")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BCancelSubmit",true);
		
		disableElement("BPicture",true);
		disableElement("BAppendFile",true);  //Modify by zx 2020-02-25 BUG ZX0077
		disableElement("BScan",true);
		disableElement("BPayPlan",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true); //modified by CZF0088 2020-02-06 1217951
	}
	else if (Status=="0")
	{
		disableElement("BCancelSubmit",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true);	//modified by CZF0088 2020-02-06 1217951
	}
	else if (Status=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BScan",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true);	//modified by CZF0088 2020-02-06 1217951
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
	}
	else if (Status=="2")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BCancelSubmit",true);
		disableElement("BScan",true);
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		//add by CZF0055 2020-02-20
		var CancelOper=getElementValue("CancelOper")
		if (CancelOper=="Y")
		{
			disableElement("BCancel",false);
		}
		else		//modified by CZF0088 2020-02-06 1217951
		{
			disableElement("BCancel",true);
			hiddenObj("BCancel",1); 
		}
	}
	if (Type=="0")
	{
		disableElement("BCancelSubmit",true);
	}
	else
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BScan",true);
	}
	if (ContractNoFlag==1)
	{
		jQuery("#ContractNo").attr('disabled',true);
	}
	if (Status!=2)
	{
		hiddenObj("BCancel",1); 	//add by CZF0055 2020-02-20
	}
	
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="CTProviderDR_VDesc")
	{
		setElement("CTProviderDR",rowData.TRowID);
		// Mozy		1068028		2019-10-26	Mozy0227
		setElement("CTProviderHandler",rowData.TContPerson);	
		setElement("CTProviderTel",rowData.TTel);
	}
	else if(elementID=="CTSignLocDR_CTLOCDesc") {setElement("CTSignLocDR",rowData.TRowID)}
	else if(elementID=="CTManageLocDR_CTLOCDesc") {setElement("CTManageLocDR",rowData.TRowID)}	//Mozy0233	2019-11-25 1096009	�����ֶ���
	else if(elementID=="CTBuyTypeDR_BTDesc") {setElement("CTBuyTypeDR",rowData.TRowID)}
	else if(elementID=="CTServiceDR_SVName")                          
	 { setElement("CTServiceDR",rowData.TRowID)                         //modified by wl 2019-10-14 1040848
	   setElement("CTServiceTel",rowData.TTel)
	   setElement("CTServiceHandler",rowData.TContPerson)
	 }
	else if(elementID=="CTSubType_List") {setElement("CTSubType",rowData.TRowID)}	//	Mozy	770055	2018-12-20
	//else if(elementID=="ContractTypeList") {setElement("CTContractType",rowData.TRowID)}
}

//	Mozy	770055	2018-12-20
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
// ��������
function insertRow()
{
	if(editIndex>="0"){
		$("#DHCEQContract").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = $("#DHCEQContract").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    if ((lastIndex>0)&&(rows[lastIndex].CTLSourceID=="undifined"))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	}
	else
	{
		$("#DHCEQContract").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//�������е�ͼ��
		$("#ContractConfig"+"z"+newIndex).hide();
	}
}
//Mozy	898948	2019-5-22
function deleteRow()
{
	////modified zy 20191012 ���ù�������ɾ����
	if ((editIndex>"0")||(editIndex="0"))  //modify by wl 2019-9-3 1014272
	{
		jQuery("#DHCEQContract").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		//$("#DHCEQContract").datagrid('deleteRow',editIndex);
	}
	removeCheckBoxedRow("DHCEQContract")
	/*
	else if(editIndex=="0")
	{
		messageShow("alert",'info',"��ʾ","��ǰ�в���ɾ��!");
	}
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}
	*/
}
function BSave_Clicked()
{
	if (getElementValue("CTContractType")=="")
	{
		messageShow('alert','error','������ʾ','��ͬ���Ͳ���Ϊ��!');
		return;
	}
	if (getElementValue("CTContractName")=="")
	{
		messageShow('alert','error','������ʾ','��ͬ���Ʋ���Ϊ��!');
		return;
	}
	if (getElementValue("CTProviderDR")=="")
	{
		messageShow('alert','error','������ʾ','��Ӧ�̲���Ϊ��!');
		return;
	}
	if (getElementValue("CTSignDate")=="")
	{
		messageShow('alert','error','������ʾ','ǩ�����ڲ���Ϊ��!');
		return;
	}
	if ((getElementValue("CTContractType")=="1")&&(getElementValue("CTEndDate")==""))
	{
		messageShow('alert','error','������ʾ',"���޽�ֹ���ڲ���Ϊ��!");
		return;
	}
	// Mozy003011	2020-04-14
	if ((getElementValue("CTContractType")=="1")&&(getElementValue("CTTotalFee")==""))
	{
		messageShow('alert','error','������ʾ',"ά���ܽ���Ϊ��!");
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	if (editIndex != undefined){ $('#DHCEQContract').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQContract').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		//Mozy	898948	2019-5-22
		if ((oneRow.CTLSourceID_Desc=="")||(oneRow.CTLSourceID_Desc==undefined))
		{
			messageShow('alert','error','������ʾ','��'+(i+1)+'�����ݲ���ȷ!');
			return "-1";
		}
		///modified by ZY0214
		var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","94","");
		if ((ItemReqFlag==0)&&(oneRow.CTLItemDR==""))
		{
			messageShow('alert','error','������ʾ','�豸���Ϊ��!');
			return -1
		}
		///end by ZY0214
		if (getElementValue("CTContractType")==0)
		{
			////modified zy 20191012 �豸�����
			/*
			if (oneRow.CTLItemDR=="")
			{
				messageShow('alert','error','������ʾ','��'+(i+1)+'��[ͨ����]����ȷ!');
				return "-1";
			}
			*/
			if (oneRow.CTLQuantityNum=="")
			{
				messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]����ȷ!');
				return "-1";
			}
			if (oneRow.CTLPriceFee=="")
			{
				messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]����ȷ!');
				return "-1";
			}
		}
		//Mozy	810416	2019-1-21
		if (rows[i].CTLSourceID!="")
		{
			// Mozy		770055	2018-12-20
			var val="model=CTLModelDR_MDesc="+oneRow.CTLModelDR+"^";
			val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
			var list=val.split("^");
			var Detail=list[0].split("=");
			if (oneRow.CTLModelDR_MDesc!=Detail[1])
			{
				// Mozy		2019-11-02	1069069		Mozy0228	�Զ�������Դ�豸��Ĺ���ͺ�
				if (oneRow.CTLSourceType==3)
				{
					oneRow.CTLModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",oneRow.CTLModelDR_MDesc+"^"+oneRow.CTLPriceFee,oneRow.CTLItemDR);
				}
				else
				{
					oneRow.CTLModelDR_MDesc="";
					oneRow.CTLModelDR="";
				}
			}
			val="manufacturer=CTLManuFactoryDR_MFName="+oneRow.CTLManuFactoryDR+"^";
			val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
			list=val.split("^");
			Detail=list[0].split("=");
			if (oneRow.CTLManuFactoryDR_MFName!=Detail[1])
			{
				oneRow.CTLManuFactoryDR_MFName="";
				oneRow.CTLManuFactoryDR="";
			}
			var RowData=JSON.stringify(rows[i]);
			if (dataList=="")
			{
				dataList=RowData;
			}
			else
			{
				dataList=dataList+getElementValue("SplitRowCode")+RowData;	// Mozy0235	2019-11-27
			}
		}
	}
	if (dataList=="")
	{
		messageShow('alert','error','������ʾ','��ͬ��ϸ����Ϊ��!');
		return;
	}
	//alertShow(data)
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var val="&RowID="+jsonData.Data+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		window.location.href= url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','û�к�ͬɾ��!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","DeleteData",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var val="&ContractType="+getElementValue("CTContractType")+"&Type="+getElementValue("Type")+"&QXType="+getElementValue("QXType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','û�к�ͬ�ύ!');
		return;
	}
	// Mozy003019		2020-04-28
	if (getElementValue("CTContractNo")=="")
	{
		messageShow('alert','error','������ʾ','��ͬ��Ϊ��,�����ύ!');
		return;
	}
	/*/ Mozy003008		2020-04-09 		δ����ϴ�����,ע��
	///modified by ZY0203
	//start by csj 20190808 �ж�ͼƬ�ϴ�
	if((getElementValue("CTTotalFee")>=5000)&&(getElementValue("CTContractType")==0)){
		//����Ƿ��ϴ���Ʊ���ͼƬ
		var uploadReportFlag = tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","CheckIfUploadPicBySourceID","94",CTRowID,"08");
		if(!+uploadReportFlag){
			messageShow('alert','error','��ʾ',"�ɹ��ܶ����5000!���ϴ���Ʊ���ͼƬ")
			return
		}
		if(getElementValue("CTTotalFee")>=200000){
			//����Ƿ��ϴ��б�֪ͨ��
			var uploadNoticeFlag = tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","CheckIfUploadPicBySourceID","94",CTRowID,"07");
			if(!+uploadNoticeFlag){
				messageShow('alert','error','��ʾ',"�ɹ��ܶ����20��!���ϴ��б�֪ͨ��ͼƬ")
				return
			}
		}
		
	}
	//end by csj 20190808 �ж�ͼƬ�ϴ�
	*/
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","SubmitData",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ContractType="+getElementValue("CTContractType");
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ContractType="+getElementValue("CTContractType");
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','û�к�ͬȡ��!');
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','������ʾ',RtnObj.Data);
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("Status");
		var WaitAD=getElementValue("WaitAD"); 
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var ApproveRole=getElementValue("CurRole");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function BApprove_Clicked()
{
  	var combindata=getValueList();
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","AuditData",combindata,CurRole,RoleStep,"");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','������ʾ',RtnObj.Data);
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("Status");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");		//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function getValueList()
{
	var combindata=CTRowID;
	combindata=combindata+"^"+session['LOGON.USERID'];
	combindata=combindata+"^"+getElementValue("ApproveSetDR");
	combindata=combindata+"^"+getElementValue("CancelToFlowDR");
	combindata=combindata+"^"+getElementValue("EditOpinion");
	combindata=combindata+"^"+getElementValue("RejectReason");
  	
	return combindata;
}
function BPicture_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','���ȱ��浥��!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var value=getElementValue("CTContractType");	//0:�ɹ���ͬ  1:���޺�ͬ  2:Э���ͬ
	if (value==1)
	{
		//modified by czf 20190305
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+status+'&ReadOnly='+ReadOnly;
	}
	else
	{
		//modified by czf 20190305
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+status+'&ReadOnly='+ReadOnly;
	}
	showWindow(str,"ͼƬ","","","icon-w-paper","modal","","","middle");	//modify by lmm 2020-06-04 UI
}
function BPayPlan_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','���ȱ��������,���ܴ�����ƻ�!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	///SourceType:1��ͬ  2����
	//var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType=1&SourceID="+CTRowID+"&ReadOnly="+ReadOnly;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=580,left=120,top=0')
    var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType=1&SourceID="+CTRowID+"&ReadOnly="+ReadOnly;
	showWindow(str,"����ƻ�","","","icon-w-paper","modal","","","large");	//modify by lmm 2020-06-04 UI
}
function BPrint_Clicked()
{
	//alertShow("BPrint_Clicked")
}
function BCopy_Clicked()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CopyContract",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","�����ɹ�");
	    //window.location.reload()
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var CurRole=getElementValue("CurRole");
		var val="&RowID="+jsonData.Data+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		window.location.href= url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQContract').datagrid('validateRow', editIndex))
	{
		$('#DHCEQContract').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index)
{
	var Status=getElementValue("CTStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQContract').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQContract').datagrid('getRows')[editIndex]);
			bindGridEvent(); //�༭�м�����Ӧ	 Mozy003011	2020-04-14	ȡ��ע��
		} else {
			$('#DHCEQContract').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

//modified by csj 2020-05-09 ����ţ�1311282��1311051
function GetSourceType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	// Mozy003013	1279967 	2020-04-18	ע�Ͳ���������Ԫ��
	//SetElement("SourceType",data.TRowID);
	//SetElement("SourceType_Desc",data.TDesc);
	rowData.CTLSourceType=data.TRowID
	SetElement("CTLSourceTypeDesc",data.TDesc);
	SetElement("CTLSourceType",data.TRowID);
	//Mozy	865594	2019-5-9	���¼�����Դ����
   	var sourceIDEdt = $("#DHCEQContract").datagrid('getEditor', {index:editIndex,field:'CTLSourceID_Desc'});
   	$(sourceIDEdt.target).combogrid('grid').datagrid('load');
   	var sourceTypeEdt = $("#DHCEQContract").datagrid('getEditor', {index:editIndex,field:'CTLSourceType_Desc'});
   	$(sourceTypeEdt.target).combogrid("setValue",data.TDesc);
   	$('#DHCEQContract').datagrid('endEdit',editIndex);
   	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
function GetSourceID(index,data)
{
	// Mozy003012	2020-04-15	������ϸ���ظ��ж�
	var rows = $('#DHCEQContract').datagrid('getRows'); 
	if(data.TSourceID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// Mozy003013	1280145 	2020-04-18	�����ظ�ѡ��
			if ((i!=editIndex)&&(rows[i].CTLSourceType==getElementValue("CTLSourceType"))&&(rows[i].CTLSourceID==data.TSourceID))
			{
				messageShow('alert','error','��ʾ',t[-9240].replace("[RowNo]",(i+1)))
				return;
			}
		}
	}
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLSourceType=getElementValue("CTLSourceType");	// Mozy003013	1279967 	2020-04-18
	rowData.CTLSourceID=data.TSourceID;
	rowData.CTLModelDR=data.TModelDR;
	rowData.CTLManuFactoryDR=data.TManuFacDR;
	rowData.CTLUnitDR_UOMDesc=data.TUnit;	//Mozy	762902	2018-12-2
	rowData.CTLItemDR=data.TItemDR;
	rowData.CTLTotalFee=data.TTotalFee;
	//rowData.CTLItem=data.CTLItem;
	
	var objGrid = $("#DHCEQContract");
	var nameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLName'}); 
	$(nameEdt.target).val(data.TName);
	var quantityNumEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'}); 
	$(quantityNumEdt.target).val(data.TQuantityNum);
	var priceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'}); 
	$(priceFeeEdt.target).val(data.TPriceFee);
	//var itemEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLItem'}); 
	//$(itemEdt.target).combogrid(data.TName);
	var sourceTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLSourceType_Desc'}); 
	$(sourceTypeDescEdt.target).combogrid("setValue",getElementValue("CTLSourceTypeDesc"));		// Mozy003013	1279967 	2020-04-18
	var sourceIDDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLSourceID_Desc'});
	$(sourceIDDescEdt.target).combogrid("setValue",data.TNo);		// Mozy003011	2020-04-14
	var modelDRMDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLModelDR_MDesc'}); 
	$(modelDRMDescEdt.target).combogrid("setValue",data.TModel);
	var manuFactoryDRMFNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLManuFactoryDR_MFName'}); 
	$(manuFactoryDRMFNameEdt.target).combogrid("setValue",data.TManuFac);
	var CTLItemEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLItem'}); 
	$(CTLItemEdt.target).combogrid("setValue",data.CTLItem);
	/*
	var editor = $('#DHCEQContract').datagrid('getEditors', editIndex);
	$(editor[0].target).combogrid("setValue",getElementValue("SourceType_Desc"));
	$(editor[1].target).combogrid("setValue",data.TName);
	//$(editor[2].target).combogrid("setValue",data.TName);
	$(editor[2].target).val(data.TName);
	if (data.TItemDR!="") $(editor[3].target).val(data.TName);
	$(editor[4].target).combogrid("setValue",data.TModel);
    $(editor[5].target).combogrid("setValue",data.TManuFac);
    $(editor[6].target).val(data.TQuantityNum);
    $(editor[7].target).val(data.TPriceFee);*/
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
function GetModel(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLModelDR=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLModelDR_MDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	//$(editor[3].target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}

function GetManuFacturer(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLManuFactoryDR=data.TRowID;	// Mozy		770055	2018-12-20
	// Mozy		769995	2018-12-12
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLManuFactoryDR_MFName'});
	$(editor.target).combogrid("setValue",data.TName);
	//$(editor[4].target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
// ����741240		2018-11-12
function GetEquipID(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	//rowData.ISLHold5=data.TRowID
	//rowData.ISLHold5_EDesc=data.TName
}
function GetBrand(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLBrandDR=data.TRowID
	rowData.CTLBrandDR_BDesc=data.TName
}
function checkboxDisabledChange()
{
	alertShow("checkboxDisabledChange")
}
function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQContract");		// ������
        // Mozy003013	1279967 	2020-04-18	��ѡ����ϸ�в������и�ֵ
        setElement("CTLSourceTypeDesc", objGrid.datagrid('getSelected').CTLSourceType_Desc);
        setElement("CTLSourceType", objGrid.datagrid('getSelected').CTLSourceType);
        setElement("CTLSourceID",objGrid.datagrid('getSelected').CTLSourceID);
        setElement("CTLRowID",objGrid.datagrid('getSelected').CTLRowID);
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'});	// ����
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
        // ����  �� �뿪�¼� 
        $(invQuantityEdt.target).bind("blur",function(){
            // ���������������� ���
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQContract').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQContract').datagrid('endEdit',editIndex);
        });
		// Mozy003011	2020-04-14	���ӵ��۴����¼�
        $(invPriceFeeEdt.target).bind("blur",function(){
            // ���������������� ���
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQContract').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQContract').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
//Mozy	868476	2019-5-10
function setElementEnabled()
{
	var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	if(Rtn=="1")
	{
		 disableElement("CTContractNo",true);
	}
}

//add by csj 20190809 ��ģ̬���ص�ˢ���б�
function reloadDatagrid()
{
	$('#DHCEQContract').datagrid('reload');
}
//add by csj 20190809 ͨ����
function GetMasterItem(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLItemDR=data.TRowID;
	var editor =$('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLItem'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	var rows = $('#DHCEQContract').datagrid('getRows');
}
//add by zy 20190809 ֪ͨ����
function ArriveConfirmClickHandler(index) 
{
	if (getElementValue("CTStatus")<2)
	{
		messageShow('alert','error','������ʾ','����ȷ����ͬ��Ϣ�������״̬!');	// Mozy0230		2019-11-11	1090361
		return;
	}
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','������ʾ','�޺�ͬ��Ϣ!');	// Mozy0230		2019-11-11	1090361
		return;
	}
	var url="dhceq.em.arrive.csp?&SourceType=1&SourceID="+rowData.CTLRowID
	//alertShow(url)
	showWindow(url,"����֪ͨ","350","10row","icon-w-paper","modal","","","");    //modify by lmm 2020-06-02 UI
	
}
///add by zy 20190919
function MenuMasterItem()
{
	// Mozy003011	2020-04-14	������ͬҵ���С������ֵ�⡱����
	var url='dhceqcmasteritem.csp?&ReadOnly=';
	if ((getElementValue("CTStatus")>0)||(getElementValue("ReadOnly")==1)) url=url+"1";
	showWindow(url,"�豸ͨ�������ֵ��","","","icon-w-paper","modal","","","verylarge");	//modify by lmm 2020-06-04 UI
}

//add by CZF0055 2020-02-20
//��ͬ����
function BCancel_Clicked()
{
	var CTRowID=getElementValue("CTRowID")
  	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CheckBussCancelFlag",4,CTRowID);
  	
	var result=results.split("^")
	if (result[0]!="0")
	{
		messageShow("","","",result[1])
	}
	else
	{
		messageShow("confirm","","","�Ƿ����ϸú�ͬ?","",ConfirmOpt,DisConfirmOpt);	// Mozy003006		2020-04-03
	}
}
// Mozy003006		2020-04-03	UI��������
function ConfirmOpt()
{
	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CancelBuss",4,getElementValue("CTRowID"));
	var result=results.split("^")
	if (result[0]!="0")
	{
		if (result[1]!="")
		{
			messageShow("","","","����ʧ��:"+result[1])
		}
		else
		{
			messageShow("","","","����ʧ��:"+result[0])
		}
	}
	else
	{
		messageShow("","","","�ɹ�����!")
		var url="dhceq.con.contract.csp?&RowID="+CTRowID
	   	window.setTimeout(function(){window.location.href=url},50); 
	}
}
function DisConfirmOpt()
{
}

//Modify by zx 2020-02-25 BUG ZX0077
function BAppendFile_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','���ȱ��浥��!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var value=getElementValue("CTContractType");
	
	if (value==0)
	{
		//Modefied by zc0060 20200329 �ļ��ϴ�����  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		//Modefied by zc0060 20200329 �ļ��ϴ�����  end
	}
	else
	{
		//Modefied by zc0060 20200329 �ļ��ϴ�����  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		//Modefied by zc0060 20200329 �ļ��ϴ�����  end
	}
	showWindow(str,"��������","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-04
}

//add by CZF0090 2020-03-06
function BProvider_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly");
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCVendor&ReadOnly="+ReadOnly;
	showWindow(str,"��˾��Ϣά��","","","icon-w-paper","modal","","","verylarge");		//modified by lmm 2020-06-04
}

//add by CZF0067 2020-03-12
function initCTHold1()
{
	var CTHold1 = $HUI.combobox('#CTHold1',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '1',text: '�豸��ͬ'},{id: '2',text: '���̺�ͬ'},{id: '3',text: '�����ͬ'}],
		onSelect : function(){}
	});
}
//add by Mozy003018 1279498 2020-04-27	��ͬ�豸����
function EquipAttributeClickHandler(index) 
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','������ʾ','�����ͬ��Ϣ��ſ��Խ����豸��������!');
		return;
	}
	
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	var url='dhceq.em.equipattributelist.csp?SourceType=4&SourceID='+rowData.CTLRowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"��ͬ�豸����","","","icon-w-paper","modal","","","middle");  //modify by lmm 2020-06-04 UI
}
// MZY0026	1279490		2020-05-22
function ScheduledDateClickHandler(index)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','������ʾ','�����ͬ��Ϣ��ſ��Խ���Ԥ������!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	var url='dhceq.plat.busswarndays.csp?SourceType=75&SubType=94-1&SourceID='+rowData.CTLRowID+"&WarnDay="+rowData.CTLContractArriveDate+"&ReadOnly="+ReadOnly+"&Name="+rowData.CTLName;
	showWindow(url,"Ԥ������","","","icon-w-paper","modal");
}