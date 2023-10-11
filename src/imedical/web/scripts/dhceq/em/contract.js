var editIndex=undefined;
var modifyBeforeRow = {};
var CTRowID=getElementValue("CTRowID");
var CTContractType=getElementValue("CTContractType")
var ComponentName="CON.G.Contract.ContractList"
if (CTContractType==1) ComponentName="CON.G.Contract.ContractListForMaint"
var Columns=getCurColumnsInfo(ComponentName,'','','')
var objtbl=$('#DHCEQContract')	//czf 2021-01-30 
var delRow=[]
var LocListFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",201015);
var ContratNoFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});

function initDocument()
{
	//modified zy 20191012 
	//setElement("CTSignLocDR_CTLOCDesc",getElementValue("CTSignLoc"))
	initUserInfo();
    initMessage(""); 	//��ȡ����ҵ����Ϣ
    initLookUp(); 			//��ʼ���Ŵ�
    initCTHold1();			//��ʼ����ͬ����	add by CZF0067 2020--03-12		
    defindTitleStyle();
    initButton(); 				//��ť��ʼ�� 
    initButtonWidth();
    initIsIFB();
    InitEvent();
    setRequiredElements("CTContractName^CTProviderDR_VDesc^CTSignDate^CTHold1^CIsIFB^CTPurchaseType^CTSignLocDR_CTLOCDesc"); //������ MZY0040	1407717		2020-7-21
    setElement("CTSignDate",GetCurrentDate());		//Mozy	929782	2019-06-13
    fillData(); 				//�������
    setEnabled(); 				//��ť����
    //initPage(); 				//��ͨ�ó�ʼ��
    setElementEnabled(); 		//�����ֻ������ 	//Mozy	868476	2019-5-10
    //initEditFields(); 		//��ȡ�ɱ༭�ֶ���Ϣ
    initApproveButtonNew(); 		//��ʼ��������ť
    if (getElementValue("CTContractType")=="1") setRequiredElements("CTEndDate^CTTotalFee"); // Mozy003011	2020-04-14
	if (CTContractType==2) hiddenObj("panelTotal",1);	// MZY0153	3225019		2023-02-20
	if (getElementValue("OCRFlag")==1) hiddenObj("BCopy",1);	// MZY0153	3225463		2023-02-20
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
	        },		///add BY ZY0274 20210707 ������������豸�Ĺ���
	        {
	            iconCls: 'icon-batch-add',
	            text:'��������豸',
	            id:'batchaddequip',
	            handler: function(){
	                 batchAddEquip_Click();
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
			//modified by ZY0267 20210607
			var CTContractType=getElementValue("CTContractType")
			if (CTContractType==0)
			{
				//�ɹ���ͬ
				if (LocListFlag==0)
				{
					$("#DHCEQContract").datagrid("hideColumn", "CTLAction");
					$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");
				}
				// MZY0095	2021-09-15
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintTimes");
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintCountType_Desc");
				hiddenObj("batchaddequip",1);
			}
			else if (CTContractType==1)
			{
				//���޺�ͬ
				//$("#DHCEQContract").datagrid("showColumn", "CTLContractConfig");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy	1068113	2019-10-26	Mozy0227
				// Mozy003011	2020-04-14
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				//$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");	// MZY0095	2021-09-15
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");	///modfied by ZY0260 20210428
				$("#DHCEQContract").datagrid("hideColumn", "CLLBuyLocDR_CTLOCDesc"); ///modfied by ZY0264 20210521
			}
			else if (CTContractType==2)
			{
				//Э���ͬ
				$("#DHCEQContract").datagrid("hideColumn", "CTLQuantityNum");
				$("#DHCEQContract").datagrid("hideColumn", "CTLTotalFee");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");	// Mozy	836945	2019-3-10
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy0230		2019-11-11	1090361
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");	///modfied by ZY0260 20210428
				$("#DHCEQContract").datagrid("hideColumn", "CTLFundsList");	///modfied by ZY0263 20210514
				// MZY0095	2021-09-15
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintTimes");
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintCountType_Desc");
				hiddenObj("batchaddequip",1);
				disableElement("CTHold2",true);			// MZY0103	2314903		2021-12-06
			}
			if (getElementValue("CTStatus")=="")
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");	// Mozy	836945	2019-3-10
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");	///modfied by ZY0260 20210428
				//hiddenObj("batchaddequip",1);   //Modefied  by zc 2021115 zc0107 batchaddequip��ťӰ��
			}
			// Mozy		2019-10-22	���ذ�ť
			if ((getElementValue("CTStatus")==1)||(getElementValue("CTStatus")==2))
			{
				hiddenObj("BSave",1);
				hiddenObj("BDelete",1);
				hiddenObj("BSubmit",1);
			}
			///modified by zy0259  20210420  ����һ���߼�
			if (getElementValue("CTStatus")<2)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// MZY0053	1503084	2020-09-08 ��ͬ��Ϣδ�������״̬
			}
			//1:�豸��ͬ, 2:���̺�ͬ,3:�����ͬ,4��� 5���պ󲹺�ͬ
			if (getElementValue("CTHold1")==2)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		//modified by czf 1243349 ���̺�ͬ��������
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");
			}else if (getElementValue("CTHold1")==4)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");
			}
			else if (getElementValue("CTHold1")==5)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// MZY0066	1679245	2021-01-14 ���պ󲹺�ͬ��������
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");
			}
			var rows = $('#DHCEQContract').datagrid('getRows');
		    	for (var i = 0; i < rows.length; i++)
		    	{
			    if (rows[i].CLLFlag!=1)
			    {
			    	$("#CTLAction"+"z"+i).hide()
		    		}
		    		else
		    		{
				    //$("#CTLListLoc"+"z"+i).hide()
				}
			}
		}
	});
};

///czf 2022-09-16
function initIsIFB()
{
	var cbox = $HUI.combobox("#CIsIFB",{
		valueField:'id', 
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		data:[
			{id:'',text:''},
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange:function(newval,oldval){
			//
		}
	});
}

function InitEvent() //��ʼ��
{
	/*	 MZY0024	1311628		2020-05-09	ȡ��"�˻�"�¼��ظ�����
	if (jQuery("#BCancelSubmit").length>0)
	{
		jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
	}*/
   /// Add:QW 20200810 BUG:QW0073 begin
	if (jQuery("#BBack").length>0)
	{
		jQuery("#BBack").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BBack").on("click", BBackData_Clicked);
	}
	/// Add:QW 20200810 BUG:QW0073 end
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
	// MZY0072	1801775		2021-04-19
	//var lable_innerText='������:'+getElementValue("CTTotalNum")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+getElementValue("CTTotalFee");		//czf 2021-01-28 1759063
	//if (getElementValue("CTContractType")==1) lable_innerText='ά���豸������:'+getElementValue("CTTotalNum")+'&nbsp;&nbsp;&nbsp;ά���豸�ܽ��:'+getElementValue("CTTotalFee");	// Mozy003011	2020-04-14
	var lable_innerText='������:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2)
	if (getElementValue("CTContractType")==1) lable_innerText='ά���豸������:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;ά���豸�ܽ��:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2);	// Mozy003011	2020-04-14
	$("#sumTotal").html(lable_innerText);
	//modified by cjt 20230313 �����3266462 "#sumTotal"��Ϊ".messager-popover"
	if (getElementValue("CTContractType")==2) $(".messager-popover").remove();	// Mozy003004	1247770		2020-3-30	Э���ͬ����ʾ�ϼ���
	var panel = $("#DHCEQContract").datagrid("getPanel");
	var rows = $("#DHCEQContract").datagrid('getRows');
	//ͼ��Ӱ��
    for (var i = 0; i < rows.length; i++) {
	    if ((rows[i].CTLSourceType=="")&&(rows[i].CTLSourceID==""))
	    {
		    $("#ContractConfig"+"z"+i).hide();
		}
		// MZY0060	1568741,1568794		2020-11-3	�����
		if (rows[i].CTLSourceType==6)
		{
			$("#CTLContractConfig"+"z"+i).hide();	//'������ϸ'
			$("#CTLAction"+"z"+i).hide();			//'֪ͨ����'
			$("#CTLEquipAttribute"+"z"+i).hide();	//'�豸����'
			$("#CTLListLoc"+"z"+i).hide();			//'�깺��ϸ'	MZY0074	1846462		2021-04-30
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
	//modified by ZY0263   20210514
	if (String(Type)=="") Type=1
	if (String(Type)==0)
	{
		setElement("ReadOnly",0)
	}
	else
	{
		setElement("ReadOnly",1)
	}
	var ContractNoFlag=getElementValue("ContractNoFlag");
	var ReadOnly=getElementValue("ReadOnly");
	//alertShow("Type="+Type)
	//alertShow("CTStatus="+Status)
	disableElement("BClear",true); //add by wy 2020-9-24 1532207
	if (ReadOnly=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		///disableElement("BCancelSubmit",true);	//modified by ZY0263   20210514
		disableElement("BScan",true);
		//modified by ZY0263   20210514
		//disableElement("BApprove1",true);
		//disableElement("BApprove2",true);
		//disableElement("BApprove3",true);
		hiddenObj("BCancel",1);		// Mozy0253	1215171		2020-3-4
		hiddenObj("BBack",1);       //Add:QW 20200810 BUG:QW0073
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		//Modife by zc 2020-09-18 ZC0083    �һ����ƺ�ͬ��ť����λ���д��� begin
		///Modefied by ZC0081 2020-09-07  �һ����ƺ�ͬ��ť  begin
		if (getElementValue("CopyFlag")!="")
		{
			disableElement("BCopy",true);
		}
		///Modefied by ZC0081 2020-09-07  �һ����ƺ�ͬ��ť  end
		//Modife by zc 2020-09-18 ZC0083    �һ����ƺ�ͬ��ť����λ���д��� end
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
		disableElement("BBack",true);       //Add:QW 20200810 BUG:QW0073
	    disableElement("BClear",false); //add by wy 2020-9-24 1532207
	    disableElement("batchaddequip",true);
	}
	else if (Status=="0")
	{
		disableElement("BCancelSubmit",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true);	//modified by CZF0088 2020-02-06 1217951
		disableElement("BBack",true);       //Add:QW 20200810 BUG:QW0073
	}
	else if (Status=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BScan",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true);	//modified by CZF0088 2020-02-06 1217951
		disableElement("BBack",true);       //Add:QW 20200810 BUG:QW0073
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		disableElement("batchaddequip",true);
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
			hiddenObj("BCancel",0);
			disableElement("BCancel",false);
			disableElement("BBack",false);       //Add:QW 20200810 BUG:QW0073
		}
		else		//modified by CZF0088 2020-02-06 1217951
		{
			disableElement("BCancel",true);
			hiddenObj("BCancel",1); 
			disableElement("BBack",true); //Add:QW 20200810 BUG:QW0073
			hiddenObj("BBack",1); //Add:QW 20200810 BUG:QW0073
		}
		disableElement("batchaddequip",true);
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
		hiddenObj("BBack",1);       //Add:QW 20200810 BUG:QW0073
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
	else if(elementID=="CTNeedHandlerDR_SSUSRName") {setElement("CTNeedHandlerDR",rowData.TRowID)}	// MZY0095	2021-09-15
	else if(elementID=="CTTaxItemDR_TIDesc") {setElement("CTTaxItemDR",rowData.TRowID)}	//czf 2022-09-19
	else if(elementID=="CTRequestLocDR_CTLOCDesc") {setElement("CTRequestLocDR",rowData.TRowID)} //czf 2022-09-19	
	//else if(elementID=="ContractTypeList") {setElement("CTContractType",rowData.TRowID)}
}
///modified by ZY02264 20210521
/*
//	Mozy	770055	2018-12-20
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
*/
///modified by ZY02264 20210521
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

///modified by ZY02264 20210521
function clearCLLBuyLoc()
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CLLBuyLocDR="";
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit',editIndex);
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
    // MZY0086		2021-8-12
    if ((lastIndex>0)&&(rows[lastIndex].CTLSourceID=="undefined"))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	}
	else
	{
		$("#DHCEQContract").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//�������е�ͼ��
		/// modified by ZY0263 20210514
		$("#CTLContractConfig"+"z"+newIndex).hide();
		$("#CTLAction"+"z"+newIndex).hide();
		$("#CTLEquipAttribute"+"z"+newIndex).hide();
		$("#CTLScheduledDate"+"z"+newIndex).hide();
		$("#CLLAction"+"z"+newIndex).hide();
		$("#CTLFundsList"+"z"+newIndex).hide();
	}
}
//Mozy	898948	2019-5-22
///czf 1754903 2021-01-28
function deleteRow()
{
	/*
	////modified zy 20191012 ���ù�������ɾ����
	if ((editIndex>"0")||(editIndex="0"))  //modify by wl 2019-9-3 1014272
	{
		jQuery("#DHCEQContract").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		//$("#DHCEQContract").datagrid('deleteRow',editIndex);
	}
	removeCheckBoxedRow("DHCEQContract")
	
	else if(editIndex=="0")
	{
		messageShow("alert",'info',"��ʾ","��ǰ�в���ɾ��!");
	}
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}
	*/
	if (editIndex != undefined)
	{
		if(objtbl.datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"��ʾ",t[-9242]);	//��ǰ�в���ɾ��
			return
		}
		jQuery("#DHCEQContract").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		var CTLRowID=objtbl.datagrid('getRows')[editIndex].CTLRowID
		delRow.push(CTLRowID)
		objtbl.datagrid('deleteRow',editIndex);
	}
	else
	{
		messageShow("alert",'info',"��ʾ",t[-9243]);	//��ѡ��һ��
	}
}
function BSave_Clicked()
{
    //modified by ZY20230307 bug:3314754
    if (checkLegalChar("CTFileNo")!=true) return true
	if ((ContratNoFlag!="1")&&(getElementValue("CTContractNo")==""))
	{
		messageShow('alert','error','������ʾ','��ͬ��Ų���Ϊ��!');
		return;
	}
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
    if (getElementValue("CTTotalFee")<0)
    {
        messageShow('alert','error','������ʾ','��ͬ�ܼ۲���Ϊ����!');
        return;
    }
    if (getElementValue("CTPreFeeFee")<0)
    {
        messageShow('alert','error','������ʾ','Ԥ�����Ϊ����,����������!');
        return;
	}
    //modified by ZY20230322 bug:3314754
    if (getElementValue("CTGuaranteePeriodNum")<0)
    {
        messageShow('alert','error','������ʾ','������(��)����Ϊ����,����������!');
        return;
    }
	// MZY0057	1493603		2020-10-09
	if ((getElementValue("CTContractType")!=1)&&(getElementValue("CTHold1")==""))
	{
		messageShow('alert','error','������ʾ','��ͬ���Ͳ���Ϊ��!');
		return;
	}
	// MZY0051	1501969		2020-09-06
	if (getElementValue("CTProviderDR")=="")
	{
		var val=GetPYCode(getElementValue("CTProviderDR_VDesc"))+"^"+getElementValue("CTProviderDR_VDesc")+"^^^";
		var CTProviderDR=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if ((CTProviderDR=="")||(CTProviderDR<0))
		{
			messageShow('alert','error','������ʾ','�бꡢǩԼ��˾����Ϊ��!');
			return;
		}
		else
			setElement("CTProviderDR",CTProviderDR);
	}
	if ((getElementValue("CTServiceDR")=="")&&(getElementValue("CTServiceDR_SVName")!=""))		//modified by czf 2020-10-21 begin 1571970
	{
		var val=GetPYCode(getElementValue("CTServiceDR_SVName"))+"^"+getElementValue("CTServiceDR_SVName")+"^^^4";
		var CTServiceDR=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if ((CTServiceDR=="")||(CTServiceDR<0))
		{
			messageShow('alert','error','������ʾ','�����̱������!');		//modified by czf 2020-10-21 end
			return;
		}
		setElement("CTServiceDR",CTServiceDR);
	}
	if (getElementValue("CTSignDate")=="")
	{
		messageShow('alert','error','������ʾ','ǩ�����ڲ���Ϊ��!');
		return;
    }
    ///add by ZY20230309 bug:3301084\3301084
    var CTSignDate = new Date(FormatDate(getElementValue("CTSignDate")).replace(/\-/g, "\/"))
    var CTStartDate = new Date(FormatDate(getElementValue("CTStartDate")).replace(/\-/g, "\/"))
    var CTEndDate = new Date(FormatDate(getElementValue("CTEndDate")).replace(/\-/g, "\/"))
    if (CTStartDate>CTSignDate)
    {
        messageShow('alert','error','������ʾ','ǩ�����ڲ������ڿ�ʼ����!');
        return;
    }
    if (CTStartDate>CTSignDate)
    {
        messageShow('alert','error','������ʾ','ǩ�����ڲ������ڽ�ֹ����!');
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
        messageShow('alert','error','������ʾ',"ά���ܽ���Ϊ��,����������!");
		return;
	}
	// MZY0098	2207387		2021-10-15
	if ((getElementValue("CTHold1")==4)&&(getElementValue("CTHold2")==1))
	{
		messageShow('alert','error','������ʾ',"�����ͬ���Ͳ�������Ϊ���պ󲹺�ͬ!");
		return;
	}
	/*	 MZY0095	2021-09-15
	if (getElementValue("CTHold3")!="")
	{
		if (getElementValue("CTHold4")=="")
		{
			messageShow('alert','error','������ʾ',"��дά��������ά��Ԥ����������Ϊ��!");
			return;
		}
		if (getElementValue("CTStartDate")=="")
		{
			messageShow('alert','error','������ʾ',"���޿�ʼ���ڲ���Ϊ��!");
			return;
		}
	}*/
	//czf 2022-09-19
	if (getElementValue("CIsIFB")=="")
	{
		messageShow('alert','error','������ʾ','�Ƿ��б겻��Ϊ��!');
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	if (editIndex != undefined){ $('#DHCEQContract').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQContract').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		// modified by ZY0265 20210526
		// MZY0040	1407717		2020-7-21
		if ((oneRow.CTLSourceType!=6)&&(getElementValue("CTHold1")==4))
		{
			messageShow('alert','error','������ʾ','�����ͬ. ��'+(i+1)+'�����ݲ���ȷ:������Դ��ʽӦ���������!');
			return "-1";
		}
		if ((oneRow.CTLSourceType==6)&&(getElementValue("CTHold1")!=4))
		{
			messageShow('alert','error','������ʾ','�������ͬ. ��'+(i+1)+'�����ݲ���ȷ:������Դ��ʽ�����������!');
			return "-1";
		}
		// MZY0095	2021-09-15
		if ((oneRow.CTLSourceType!=7)&&(getElementValue("CTHold2")==1))
		{
			messageShow('alert','error','������ʾ','���պ󲹺�ͬ. ��'+(i+1)+'�����ݲ���ȷ:������Դ��ʽӦ�������յ�!');
			return "-1";
		}
		if ((oneRow.CTLSourceType==7)&&(getElementValue("CTHold2")!=1))
		{
			messageShow('alert','error','������ʾ','�����պ󲹺�ͬ. ��'+(i+1)+'�����ݲ���ȷ:������Դ��ʽ���������յ�!');
			return "-1";
		}
		// MZY0098	2166119		2021-10-15
		if ((oneRow.CTLSourceType==7)&&(getElementValue("CTHold2")==1))
		{
			var IDFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckIDForOCL",oneRow.CTLRowID,oneRow.CTLSourceID);
			if (IDFlag!=0)
			{
				messageShow('alert','error','������ʾ','���պ󲹺�ͬ. ��'+(i+1)+'�����ݲ���ȷ:������Դ�ظ�!');
				return "-1";
			}
		}
		//Mozy	898948	2019-5-22
		if ((oneRow.CTLSourceType!=99)&&((oneRow.CTLSourceID_Desc=="")||(oneRow.CTLSourceID_Desc==undefined)))
		{
			messageShow('alert','error','������ʾ','��'+(i+1)+'�����ݲ���ȷ:û��ѡ����Դ����!');
			return "-1";
		}
		///modified by ZY0214
		var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","94","");
		// MZY0040	1407717		2020-7-21
		if ((oneRow.CTLSourceType!=99)&&(ItemReqFlag==0)&&(oneRow.CTLItemDR=="")&&(getElementValue("CTHold1")!=4))
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
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]����ȷ,����������!');
				return "-1";
			}
			if (oneRow.CTLPriceFee=="")
			{
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]����ȷ,����������!');
				return "-1";
			}
		}
		//Mozy	810416	2019-1-21
		if (rows[i].CTLSourceID!="")
		{
			// MZY0066	1679245		2021-01-14	�Զ�������Դ�豸��Ĺ���ͺ�
			if (oneRow.CTLSourceType==3)
			{
				if ((oneRow.CTLModelDR_MDesc!="")&&(oneRow.CTLModelDR==""))
				{
					oneRow.CTLModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",oneRow.CTLModelDR_MDesc+"^"+oneRow.CTLPriceFee,oneRow.CTLItemDR);
				}
			}
			// ������ϸ���ͺ��ظ��ж�
			for(var j=0;j<rows.length;j++)
			{
				if ((j!=i)&&(rows[j].CTLSourceType==3)&&(rows[j].CTLItemDR==oneRow.CTLItemDR)&&(rows[j].CTLModelDR_MDesc==oneRow.CTLModelDR_MDesc))
				{
					// ��ͬ�����豸����ͬ����ϸ
					//alert(i+": oneRow.CTLModelDR_MDesc="+oneRow.CTLModelDR_MDesc+"   "+j+": rows[j].CTLModelDR_MDesc="+rows[j].CTLModelDR_MDesc)
					messageShow('alert','error','��ʾ',"��"+(i+1)+"�����"+(j+1)+"���ͺ��ظ�!")
					return;
				}
			}
			//czf 2022-10-11 begin
			var manuFactoryName=oneRow.CTLManuFactoryDR_MFName;
			var FirmType=3;
		 	var val="^"+manuFactoryName+"^^^"+FirmType;
			var ManuFactoryRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
			oneRow.CTLManuFactoryDR=ManuFactoryRowID;
			//czf 2022-10-11 end
			// MZY0053	1505534	2020-09-08	End
			val="manufacturer=CTLManuFactoryDR_MFName="+oneRow.CTLManuFactoryDR+"^";
			val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
			list=val.split("^");
			Detail=list[0].split("=");
			if (oneRow.CTLManuFactoryDR_MFName!=Detail[1])
			{
				oneRow.CTLManuFactoryDR_MFName="";
				oneRow.CTLManuFactoryDR="";
			}
			if (oneRow.CTLHold2_ETDesc=="") oneRow.CTLHold2="";		// MZY0043	2020-08-05	��չ�������
            ///add by ZY20230309 bug:3314660\3314717
            if (oneRow.CTLGuaranteePeriodNum<0)
            {
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[������]����ȷ,����������!');
                return "-1";
            }
            if (oneRow.CTLQuantityNum<0)
            {
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]����ȷ,����������!');
                return "-1";
            }
			//modified by ZY20230407 bug:3412104
			var priceFee=Number(oneRow.CTLPriceFee)
			var retNum = /^[0-9]+\.?[0-9]*$/	//ƥ������
			if(!retNum.test(priceFee))
			{
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]��������,����������!');
                return "-1";
			}
			else
			{
				if (priceFee<0)
				{
					messageShow('alert','error','������ʾ','��'+(i+1)+'��[����]����ȷ,����������!');
					return "-1";
				}
			}
            if (oneRow.CTLTotalFee<0)
            {
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[�ܽ��]����ȷ,����������!');
                return "-1";
            }
            //modified by ZY20230307 bug:3357775��3357724
            if (oneRow.CTLHold1<0)
            {
                messageShow('alert','error','������ʾ','��'+(i+1)+'��[���������]����ȷ,����������!');
                return "-1";
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
	var DelRowid=delRow.join(',')			//czf 2021-01-27 ��ȡɾ����rowid�� 1754903
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","SaveData",data,dataList,DelRowid);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var val="&RowID="+jsonData.Data+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
		var val="&ContractType="+getElementValue("CTContractType")+"&Type="+getElementValue("Type")+"&QXType="+getElementValue("QXType")+"&AuditType="+getElementValue("AuditType");	//czf 1914903
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
	// MZY0098	2207387		2021-10-15
	if ((getElementValue("CTHold1")==4)&&(getElementValue("CTHold2")==1))
	{
		messageShow('alert','error','������ʾ',"�����ͬ���Ͳ�������Ϊ���պ󲹺�ͬ!");
		return;
	}
	// MZY0098	2166119		2021-10-15
	if (getElementValue("CTHold2")==1)
	{
		var rows = $('#DHCEQContract').datagrid('getRows');
		for (var i = 0; i < rows.length; i++) 
		{
			var oneRow=rows[i];
			var IDFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckIDForOCL",oneRow.CTLRowID,oneRow.CTLSourceID);
			if (IDFlag==1)
			{
				messageShow('alert','error','������ʾ','���պ󲹺�ͬ. ��'+(i+1)+'�����ݲ���ȷ:������Դ�ظ�!');
				return "-1";
			}
		}
	}
	///modfied by ZY0267 20210607
	var CTContractType=getElementValue("CTContractType")
	if ((CTContractType==1)||(CTContractType==2))
	{
		//Add By By zy20221115 bug��3073937
		if (CTContractType==2)
		{
			var CTStartDate=getElementValue("CTStartDate")
			var CTEndDate=getElementValue("CTEndDate")
			if ((CTStartDate=="")||(CTEndDate==""))
			{
				messageShow('alert','error','������ʾ','Э���ͬ�ĺ�ͬ��ʼʱ��ͽ���ʱ�䲻��Ϊ��!');
				return "-1";
			}
		}
		
		OptSubmit();
	}
	else
	{
		var CTHold1=getElementValue("CTHold1")	//2 ���̺�ͬ
		if (CTHold1==2)
		{
			OptSubmit();
		}
		else
		{
			if (LocListFlag==1)		//czf 2022-04-11 ���ö���Ҳ������ж�
			{
				var result=tkMakeServerCall("web.DHCEQ.Con.BUSContractListLoc","CheckContractListLoc", CTRowID);
				if (result=="")
				{
					OptSubmit();
				}else
				{
					messageShow("confirm","info","��ʾ",result+",�Ƿ�����ύ?","",OptSubmit,function(){
						return;
					});
				}
			}
			else
			{
				OptSubmit();
			}
		}
	}
}
function OptSubmit()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","SubmitData",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.con.contract.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ContractType="+getElementValue("CTContractType");
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ContractType="+getElementValue("CTContractType");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
	var Status=+getElementValue("CTStatus");
	if (Status>0) Status=0;
	var value=getElementValue("CTContractType");	//0:�ɹ���ͬ  1:���޺�ͬ  2:Э���ͬ
	if (value==1)
	{
		//modified by czf 20190305
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+Status+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
	}
	else
	{
		//modified by czf 20190305
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+Status+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
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
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
			///modofied by 20220725
			if (CTContractType!=1) bindGridEvent(); //�༭�м�����Ӧ	 Mozy003011	2020-04-14	ȡ��ע��
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
	if (CTContractType!=1) bindGridEvent();
}
function GetSourceID(index,data)
{
	// Mozy003012	2020-04-15	������ϸ���ظ��ж�
	var rows = $('#DHCEQContract').datagrid('getRows'); 
	if(data.TSourceID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// MZY0053	1505534		2020-09-08	�����ظ�ѡ��
			if ((i!=editIndex)&&(rows[i].CTLSourceType==getElementValue("CTLSourceType"))&&(rows[i].CTLSourceID==data.TSourceID)&&(rows[i].CTLSourceType!=3))
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
	rowData.CTLUnitDR=data.TUnitDR;	//czf 2022-10-11
	rowData.CTLItemDR=data.TItemDR;
	SetElement("EQItemDR",rowData.CTLItemDR);		//MZY0052	1503091		2020-09-07
	rowData.CTLTotalFee=data.TTotalFee;
	///modofied by 20220725
	rowData.CTLHold2=data.TEquipTypeDR;	
	//rowData.CTLItem=data.CTLItem;
	rowData.CTLGuaranteePeriodNum=data.TGuaranteePeriodNum  //modified by ZY0303 20220615 2686600
	
	var objGrid = $("#DHCEQContract");
	var nameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLName'}); 
	$(nameEdt.target).val(data.TName);
	var sourceTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLSourceType_Desc'}); 
	$(sourceTypeDescEdt.target).combogrid("setValue",getElementValue("CTLSourceTypeDesc"));		// Mozy003013	1279967 	2020-04-18
	var sourceIDDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLSourceID_Desc'});
	$(sourceIDDescEdt.target).combogrid("setValue",data.TNo);		// Mozy003011	2020-04-14
	var CTLItemEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLItem'});
	// MZY0149	3163972		2023-01-09
	if (CTLItemEdt)
	{
		$(CTLItemEdt.target).combogrid("setValue",data.CTLItem);
	}
	else
	{
		rowData.CTLItem=data.CTLItem;
	}
	// MZY0057	1506387		2020-10-09	��ͬ��ϸѡ���豸������ϸ����
	if (getElementValue("CTLSourceType")!=3)
	{
		var modelDRMDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLModelDR_MDesc'}); 
		// MZY0149	3163972		2023-01-09
		if (modelDRMDescEdt)
		{
			$(modelDRMDescEdt.target).combogrid("setValue",data.TModel);
			$(modelDRMDescEdt.target).combogrid('grid').datagrid('load');
		}
		else
		{
			rowData.CTLModelDR_MDesc=data.TModel;
		}
		var manuFactoryDRMFNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLManuFactoryDR_MFName'}); 
		// MZY0149	3163972		2023-01-09
		if (manuFactoryDRMFNameEdt)
		{
			$(manuFactoryDRMFNameEdt.target).combogrid("setValue",data.TManuFac);
		}
		else
		{
			rowData.CTLManuFactoryDR_MFName=data.TManuFac;
		}
		var priceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
		// MZY0149	3163972		2023-01-09
		if (priceFeeEdt)
		{
			$(priceFeeEdt.target).val(data.TPriceFee);
		}
		else
		{
			rowData.CTLPriceFee=data.TPriceFee;
		}
		var quantityNumEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'}); 
		// MZY0149	3163972		2023-01-09
		if (quantityNumEdt)
		{
			$(quantityNumEdt.target).val(data.TQuantityNum);
		}
		else
		{
			rowData.CTLQuantityNum=data.TQuantityNum;
		}
	}
	// MZY0061	1612536		2020-12-2	����'����'��ֵ
	rowData.CTLHold2=data.TEquipTypeDR;
	var CTLHold2Edt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLHold2_ETDesc'}); 
	// MZY0149	3163972		2023-01-09
	if (CTLHold2Edt)
	{
		$(CTLHold2Edt.target).combogrid("setValue",data.TEquipType);
	}
	else
	{
		rowData.CTLHold2_ETDesc=data.TEquipType;
	}
	rowData.CTLUnitDR=data.TUnitDR;
	var UnitEditor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLUnitDR_UOMDesc'});
	if (UnitEditor)
	{
		$(UnitEditor.target).combogrid("setValue",data.TUnit);
	}else{
		rowData.CTLUnitDR_UOMDesc=data.TUnit;
	}

	
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	if (CTContractType!=1) bindGridEvent();
}
function GetModel(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLModelDR=data.TRowID;
	// MZY0053	1505534		2020-09-08	������ϸ���ظ��ж�
	var rows = $('#DHCEQContract').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		//alert("i="+i+" rowData.CTLItemDR="+rowData.CTLItemDR+"   rows[i].CTLItemDR="+rows[i].CTLItemDR+"   CTLSourceType="+rows[i].CTLSourceType)
		if ((i!=editIndex)&&(rows[i].CTLSourceType==3)&&(rows[i].CTLItemDR==rowData.CTLItemDR)&&(rows[i].CTLModelDR==data.TRowID))
		{
			messageShow('alert','error','��ʾ',t[-9240].replace("[RowNo]",(i+1)))
			return;
		}
	}
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLModelDR_MDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	//$(editor[3].target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	if (CTContractType!=1) bindGridEvent();
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
	if (CTContractType!=1) bindGridEvent();
}

//czf 2022-10-11
function GetUOM(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLUnitDR=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLUnitDR_UOMDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);
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
        SetElement("EQItemDR",objGrid.datagrid('getSelected').CTLItemDR);	//MZY0052	1503091		2020-09-07
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'});	// ����
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
        ///modofied by 20220725
	if (invQuantityEdt!=null)
        {
	        // ����  �� �뿪�¼� 
	        $(invQuantityEdt.target).bind("blur",function(){
	            // ���������������� ���
	            var quantityNum=parseFloat($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = $('#DHCEQContract').datagrid('getSelected');
				rowData.CTLTotalFee=quantityNum*originalFee;
				//$('#DHCEQContract').datagrid('endEdit',editIndex);	//�༭�󲻹رձ༭״̬ 2022-12-30
	        });
        }
        if (invPriceFeeEdt!=null)
        {
			// Mozy003011	2020-04-14	���ӵ��۴����¼�
	        $(invPriceFeeEdt.target).bind("blur",function(){
	            // ���������������� ���
	            var quantityNum=parseFloat($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = $('#DHCEQContract').datagrid('getSelected');
				rowData.CTLTotalFee=quantityNum*originalFee;
				//$('#DHCEQContract').datagrid('endEdit',editIndex);	//�༭�󲻹رձ༭״̬ 2022-12-30
	        });
        }
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
	else
	{
		setRequiredElements("CTContractNo")
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
	// MZY0038	2020-7-10
	$('#DHCEQContract').datagrid('beginEdit', editIndex);
	if (CTContractType!=1) bindGridEvent();
}
///modfied by ZY0260 20210428  ��������
// MZY0053	1503084		2020-09-08		ע��
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
	// MZY0047	1455739		2020-08-19
	if (rowData.CTLSourceType==6)
	{
		messageShow('alert','error','������ʾ','����޷������豸��֪ͨ����!');
		return;
	}
	var url="dhceq.em.arrive.csp?&SourceType=1&SourceID="+rowData.CTLRowID
	//alertShow(url)
	showWindow(url,"����֪ͨ","350","11row","icon-w-paper","modal","","","");    //modify by lmm 2020-06-02 UI
}
///add by zy 20190919
function MenuMasterItem()
{
	///modified by ZY20230328 bug:3333797
    // Mozy003011   2020-04-14  ������ͬҵ���С������ֵ�⡱����
    var url='dhceq.plat.masteritem.csp?&ReadOnly=';
    if ((getElementValue("CTStatus")>0)||(getElementValue("ReadOnly")==1)) url=url+"1";
    showWindow(url,"�豸ͨ�������ֵ��","","","icon-w-paper","modal","","","verylarge"); //modify by lmm 2020-06-04 UI
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
		var confirmStr=""		//czf 2286940 2021-11-18 begin
		if (result[4]!=""){
			confirmStr=confirmStr+"��ص�����:"+result[4]
			if (result[2]!=""){
				confirmStr=confirmStr+",���:"+result[2]
				if (result[3]!=""){
					confirmStr=confirmStr+",ת��:"+result[3]+",̨��"
				}
				else{
					confirmStr=confirmStr+",̨��"
				}
			}
			confirmStr=confirmStr+"Ҳһ������!�Ƿ����?"
		}
		else if (result[5]!="")		// MZY0109	2384432		2021-12-23
		{
			confirmStr=confirmStr+"��ص�������:"+result[5];
			if (result[6]!="") confirmStr=confirmStr+",�������:"+result[6];
			confirmStr=confirmStr+"Ҳһ������!�Ƿ����?";
		}
		else{
			confirmStr=confirmStr+"�Ƿ����ϸú�ͬ?"
		}
		
		messageShow("confirm","","",confirmStr,"",ConfirmOpt,DisConfirmOpt);	//czf 2286940 2021-11-18 end
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
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
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
	if (CTStatus>0) CTStatus=0;
	var value=getElementValue("CTContractType");
	if (value==0)
	{
		//Modefied by zc0060 20200329 �ļ��ϴ�����  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
		//Modefied by zc0060 20200329 �ļ��ϴ�����  end
	}
	else
	{
		//Modefied by zc0060 20200329 �ļ��ϴ�����  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
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

// MZY0066	1679245		2021-01-14	������ͬ����
function initCTHold1()
{
	if (getElementValue("CTContractType")==0)
	{
		//�ɹ���ͬ	MZY0095	2021-09-15
		var CTHold1 = $HUI.combobox('#CTHold1',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '1',text: '�豸��ͬ'},{id: '2',text: '���̺�ͬ'},{id: '3',text: '�����ͬ'},{id: '4',text: '�����ͬ'}],
			onSelect : function(){}
		});
	}
	if (getElementValue("CTContractType")==1)
	{
		//���޺�ͬ
		var CTHold1 = $HUI.combobox('#CTHold1',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '1',text: '�豸��ͬ'},{id: '2',text: '���̺�ͬ'},{id: '3',text: '�����ͬ'}],
			onSelect : function(){}
		});
	}
	if (getElementValue("CTContractType")==2)
	{
		//Э���ͬ
		var CTHold1 = $HUI.combobox('#CTHold1',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '1',text: '�豸��ͬ'},{id: '2',text: '���̺�ͬ'},{id: '3',text: '�����ͬ'}],
			onSelect : function(){}
		});
	}
}
// MZY0072	1797995		2021-04-19	��������Indexȡ��
function EquipAttributeClickHandler(index) 
{
	var rows = $('#DHCEQContract').datagrid('getRows');//���������
	if (!rows) return;
	// MZY0144	3070773		2022-11-24
	if ((rows[index].CTLRowID=="")||(rows[index].CTLRowID==undefined))
	{
		messageShow('alert','error','������ʾ','�����ͬ��Ϣ��ſ��Խ����豸��������!');
		return;
	}
	
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	var url='dhceq.em.equipattributelist.csp?SourceType=4&SourceID='+rows[index].CTLRowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"��ͬ�豸����","","","icon-w-paper","modal","","","middle");  //modify by lmm 2020-06-04 UI
}
// MZY0072	1797995		2021-04-19	��������Indexȡ��
function ScheduledDateClickHandler(index)
{
	var rows = $('#DHCEQContract').datagrid('getRows');//���������
	if (!rows) return;
	// MZY0144	3070773		2022-11-24
	if ((rows[index].CTLRowID=="")||(rows[index].CTLRowID==undefined))
	{
		messageShow('alert','error','������ʾ','�����ͬ��Ϣ��ſ��Խ���Ԥ������!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	// MZY0095	2021-09-15
	var url='dhceq.plat.busswarndays.csp?SourceID='+rows[index].CTLRowID+"&WarnDay="+rows[index].CTLContractArriveDate+"&ReadOnly="+ReadOnly+"&Name="+rows[index].CTLName;
	if (getElementValue("CTContractType")==0) url=url+"&SourceType=75&SubType=94-1";
	if (getElementValue("CTContractType")==1) url=url+"&SourceType=71&SubType=95-1";
	//modified by cjt 20230201 �����3220213 UIҳ�����
	showWindow(url,"Ԥ������","548px","278px","icon-w-paper","modal","","","small");
}
// MZY0043	2020-08-05
function GetEquipType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLHold2=data.TRowID
	rowData.CTLHold2_ETDesc=data.TName
}
/// Add:QW 20200810 BUG:QW0073 ��ͬ���� 
function BBackData_Clicked()
{
    var CTRowID=getElementValue("CTRowID")
  	var results=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckBuss",CTRowID);
  	
	var result=results.split("^")
	if (result[0]!="0")
	{
		messageShow("","","",result[1])
	}
	else
	{
		messageShow("confirm","","","�Ƿ񳷻ظú�ͬ?","",ConfirmBack,DisConfirmOpt);
	}
}
/// Add:QW 20200810 BUG:QW0073 ��ͬ���� 
function ConfirmBack()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','������ʾ','û�к�ͬȡ��!');
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","BackData",combindata);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','������ʾ',RtnObj.Data);
    }
    else
    {
		messageShow("","","","�ɹ�����!")
		var url="dhceq.con.contract.csp?&RowID="+CTRowID
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	   	window.setTimeout(function(){window.location.href=url},50);
    }
}
//add by wy 2020-9-24 1532207����ҵ����������
function BClear_Clicked()
{
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var val="&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType")+"&AuditType="+getElementValue("AuditType");	//czf 1914903
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
}
///modfied by ZY0260 20210428
function getBuyLoc(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CLLBuyLocDR=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CLLBuyLocDR_CTLOCDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	$("#CTLAction"+"z"+editIndex).hide()
}
///modfied by ZY0260 20210428
function reloadGrid()
{
	$HUI.datagrid("#DHCEQContract",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContract",
	        	QueryName:"GetContractList",
		        RowID:CTRowID
		},
		columns:Columns
	});
}
///add by ZY0274 20210707 ���������豸
function batchAddEquip_Click()
{
	/*
	if(getElementValue("SMFromLocDR")==""){
		alertShow("�������Ų���Ϊ��!")
		return
	}
	if(getElementValue("SMEquipTypeDR")==""){
		alertShow("�������鲻��Ϊ��!")
		return
	}
	*/
	var str=""
	str=str+"&BussType=94"+""
	str=str+"&FromLocDR="+""
	str=str+"&EquipTypeDR="+""
	str=str+"&title="+"�����豸ѡ��"     //Modefied  by zc 2021115  zc0107 title�ĳ�ȡֵ
	var url="dhceq.em.batchaddequip.csp?"+str;
	showWindow(url,"��������豸","","","icon-w-paper","modal","","","middle",insertEquipRow);  
}
/// MZY0100	2288153,2288189		2021-11-18	�����������ش���
///add by ZY0274 20210707 ���������豸
///��������豸�ص�
///copyrows:�б���������
function insertEquipRow(copyrows)
{
	var ComponentID="DHCEQContract";
	if ($("#"+ComponentID).datagrid("getRows")[0].CTLSourceType_Desc=="") $("#"+ComponentID).datagrid('deleteRow',0);

	for(i=0;i<copyrows.length;i++)
	{
		var morows = $("#"+ComponentID).datagrid("getRows");
		var index=morows.length;
		var vallist=copyrows[i].TEquipID;
		if (vallist=="") vallist=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetEQIDs",copyrows[i].TFromLocDR, copyrows[i].TInStockListID);
		var EQRowID=vallist.split(",");
		for(var j=0;j<EQRowID.length;j++)
		{
			for (k=0;k<morows.length;k++)
			{
				if(morows[k].CTLSourceID==EQRowID[j])
				{
					//messageShow('alert','error','��ʾ',"������Ϣ:"+copyrows[i].TEquipNo+"�豸�ظ�!");
					return;
				}
			}
			
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",EQRowID[j]);
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
			var ObjEquip=jsonData.Data
			$("#"+ComponentID).datagrid('appendRow',{ 
				CTLSourceType:"4",
				CTLSourceType_Desc: "�豸",
				CTLSourceID:ObjEquip.EQRowID,
				CTLSourceID_Desc:ObjEquip.EQNo,
				CTLName:ObjEquip.EQName,
				CTLItemDR:ObjEquip.EQItemDR,
				CTLItem:ObjEquip.EQItemDR_MIDesc,
				CTLModelDR:ObjEquip.EQModelDR,
				CTLModelDR_MDesc:ObjEquip.EQModelDR_MDesc,
				CTLManuFactoryDR:ObjEquip.EQManuFactoryDR,
				CTLManuFactoryDR_MFName:ObjEquip.EQManuFactoryDR_MFName,
				CTLQuantityNum:1,
				CTLPriceFee:ObjEquip.EQOriginalFee,
				CTLTotalFee:ObjEquip.EQOriginalFee,
				CTLUnitDR_UOMDesc:ObjEquip.EQUnitDR_UOMDesc,
				CTLHold2:ObjEquip.EQEquipTypeDR,
				CTLHold2_ETDesc:ObjEquip.EQEquipTypeDR_ETDesc,
				CTLRemark:"",
				CTLContractArriveDate:"",
				CTLArriveDate:"",
				CTLArriveQuantityNum:"",
				CTLGuaranteePeriodNum:"",
				CTLBrandDR:"",
				CTLImportFlag:"",
				CTLGuaranteeContent:"",
				CTLMaintCountType:"",
				CTLMaintTimes:"",
				CTLHold1:"",
				CTLHold3:"",
				CTLHold4:"",
				CTLHold5:"",
				CTLBrandDR_BDesc:"",
		     })
		}
	}
}
// MZY0095	2021-09-15
function GetMaintCountType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLMaintCountType=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLMaintCountType_Desc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);
	if (CTContractType!=1) bindGridEvent();
}

function clearMaintCountType()
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLMaintCountType="";
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit',editIndex);
}
