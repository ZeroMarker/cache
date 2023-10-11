var editIndex=undefined;
var modifyBeforeRow = {};
var IRowID=getElementValue("IRowID");
var StatusDR=getElementValue("StatusDR");
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryList','','','');
var DisplayFlag="allflag";

$(function(){
	if (StatusDR==1) DisplayFlag="uncheckflag";
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	if (StatusDR==0)
	{
		var StoreLocDR=getElementValue("StoreLocDR")
		setElement("IStoreLocDR",StoreLocDR)
		setElement("IStoreLocDR_CTLOCDesc",getElementValue("StoreLoc"))
		setElement("IManageLocDR",getElementValue("ManageLocDR"))
		setElement("IManageLocDR_CTLOCDesc",getElementValue("ManageLoc"))
		//StoreLocDR��Ϊ��ʱ�ǿ�������
		if (StoreLocDR!="")
		{
			setElement("ISelfFlag",1)
			disableElement("ISelfFlag",1);
			disableElement("IStoreLocDR_CTLOCDesc",1);
		}
		//add by zc0128 2023-02-08 �����ſ��� begin
		if (getElementValue("QXType")=="0")
		{
			disableElement("IManageLocDR_CTLOCDesc",1);
			disableElement("ISelfFlag",1);  //Modefied by zc0130 2023-2-17 �������̱�ʶ����
		}
		else
		{
			singlelookup("IManageLocDR_CTLOCDesc","PLAT.L.Loc","","")
		}
		//add by zc0128 2023-02-08 �����ſ��� end
	}else{
		var url='dhceq.em.inventoryplanmanage.csp?InventoryPlanDR=&InventoryDR='+getElementValue("IRowID")+'&ReadOnly='+getElementValue("ReadOnly")+'&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&DisposeType='+getElementValue("DisposeType")+'&IAStatusDR='+getElementValue("IAStatusDR");
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	initUserInfo();
    initMessage("Inventory"); 	//��ȡ����ҵ����Ϣ
    initLookUp(); 				//��ʼ���Ŵ�
    initIEquipType();			//��ʼ����������
    defindTitleStyle();
    initButton(); 				//��ť��ʼ�� 
    initButtonWidth();
    InitEvent()
    setRequiredElements("IEquipType^IManageLocDR_CTLOCDesc"); //������
    fillData(); 				//�������
    //initPage(); 				//��ͨ�ó�ʼ��
    setEnabled(); 				//��ť����
    //setElementEnabled(); 		//�����ֻ������
    //initEditFields(); 		//��ȡ�ɱ༭�ֶ���Ϣ
	//initApproveButtonNew(); 		//��ʼ��������ť
	initFilterKeyWords();		// MZY0133	2612992		2022-09-09
	$HUI.datagrid("#DHCEQInventoryList",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryList",
		        InventoryDR:IRowID,
		    	StoreLocDR:getElementValue("StoreLocDR"),
		    	IStoreLocDR:getElementValue("IStoreLocDR"),
		    	EquipTypeIDs:getElementValue("IEquipTypeIDs"),
		    	StatCatDR:getElementValue("IStatCatDR"),
		    	OriginDR:getElementValue("IOriginDR"),
		    	onlyShowDiff:getElementValue("onlyShowDiff"),
		    	FilterInfo:getElementValue("FilterInfo"),
		    	ManageLocDR:getElementValue("IManageLocDR"),
		    	QXType:getElementValue("QXType"),
		    	StatusDR:StatusDR,
		    	HospitalDR:getElementValue("IHospitalDR"),
		    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
		    	DisplayFlag:DisplayFlag
		},
		rownumbers:true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		// MZY0133	2612992		2022-09-09	ɾ��toolbar
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45],
		onLoadSuccess:function(){
			creatToolbar();
			// ����������
			$("#DHCEQInventoryList").datagrid("hideColumn", "TResultType");		//���
			if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992006")!=1)
			{
				$("#DHCEQInventoryList").datagrid("hideColumn", "ILCondition_Display");
				$("#DHCEQInventoryList").datagrid("hideColumn", "IListInfo");
				$("#DHCEQInventoryList").datagrid("hideColumn", "ILPictrue");
			}
			var trs = $(this).prev().find('div.datagrid-body').find('tr');
			//alert(trs.length)
			for (var i = 0; i < trs.length; i++)
			{
				// ����������
				//alert(trs[i].cells.length)
				var TRowID="";
				for (var j = 0; j < trs[i].cells.length; j++)
				{
					var row_html = trs[i].cells[j];
	                var cell_field=$(row_html).attr('field');
                    //if (cell_field=="TRowID") TRowID=$(row_html).find('div').html();
					if (cell_field=="ILStatus_Display")
					{
						//alert($(row_html).find('div').html())
			 			// �ı䵥Ԫ����ɫ
						//trs[i].cells[j].style.cssText = 'background:#EEEE00;color:#fff';
						if ($(row_html).find('div').html()=="����һ��") trs[i].cells[j].style.cssText = 'background:#22b14c';
						if ($(row_html).find('div').html()=="���Ҳ���") trs[i].cells[j].style.cssText = 'background:#0080ff';	// MZY0050	1498290		2020-09-01
						if ($(row_html).find('div').html()=="�̿�") trs[i].cells[j].style.cssText = 'background:#ff0000';
						if ($(row_html).find('div').html()=="������") trs[i].cells[j].style.cssText = 'background:#ff0000';	// MZY0049	2020-08-25
					    //if ($(row_html).find('div').html()=="���Ҳ���") trs[i].cells[j].style.cssText = 'background:#ff8000';
					    //if ($(row_html).find('div').html()=="����һ��") trs[i].cells[j].style.cssText = 'background:#c0c0c0';
					}
				}
			}
			$("#"+DisplayFlag).css("color", "#FF0000");
			//$("#"+DisplayFlag).css("background-color", "#40A2DE");
			if ((+getElementValue("IStatus")==0)||(getElementValue("IAStatus")!=getElementValue("IAStatusDR")))
			{
				$('#BSaveList').linkbutton('disable');
				// MZY0044	1457724		2020-08-07
				//$('#BResultStat').linkbutton('disable');
				//$('#BSaveTXT').linkbutton('disable');
				//$('#BPrtInventory').linkbutton('disable');
				//$('#BBarCodePrint').linkbutton('disable');
			}
			if (+getElementValue("IStatus")==2)	$('#BSaveList').linkbutton('disable');
			$("#BSaveListNew").css("width","80px");		// MZY0133	2612992		2022-09-09
		}
	});
	//Modefied by zc0127 2023-01-10 �̵㽨���޹���ϢӰ�� begin
	$("#DHCEQInventoryList").datagrid("hideColumn", "TSelect");
	$("#DHCEQInventoryList").datagrid("hideColumn", "LIUseStatus_USDesc");
	$("#DHCEQInventoryList").datagrid("hideColumn", "LIPurpose_PDesc");
	$("#DHCEQInventoryList").datagrid("hideColumn", "ILILeaveFactoryNo");
	$("#DHCEQInventoryList").datagrid("hideColumn", "LILossReasonDR_LRDesc");
	$("#DHCEQInventoryList").datagrid("hideColumn", "ILILocationDR_LDesc");
	// MZY0151	2023-02-01
	if ((typeof(HISUIStyleCode)!="undefined")&&(HISUIStyleCode=="lite"))
	{
		jQuery("#menubtn-prt").attr("style","width:116px");
	}
};

function InitEvent() //��ʼ��
{
	if (jQuery("#BComfirm").length>0)
	{
		jQuery("#BComfirm").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BComfirm").on("click", BComfirm_Clicked);
	}
	if (jQuery("#BSaveException").length>0)
	{
		jQuery("#BSaveException").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BSaveException").on("click", BSaveException_Clicked);
	}

	if (jQuery("#BInventoryResult").length>0)
	{
		//jQuery("#BInventoryResult").linkbutton({iconCls: 'icon-w-import'});
		jQuery("#BInventoryResult").on("click", BInventoryResult_Clicked);
	}
	if (jQuery("#BLocSubmit").length>0)
	{
		jQuery("#BLocSubmit").linkbutton({iconCls: 'icon-w-stamp'});	// MZY0123	2612989		2022-05-12
		jQuery("#BLocSubmit").on("click", BLocSubmit_Clicked);
	}
	if (jQuery("#BInventoryAudit").length>0)
	{
		jQuery("#BInventoryAudit").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BInventoryAudit").on("click", BInventoryAudit_Clicked);
	}
	//Modify by QW20210430 ����������ť BUG:QW0103
	if (jQuery("#BFilterInfo").length>0)
	{
		jQuery("#BFilterInfo").linkbutton({iconCls: 'icon-w-filter'});
		jQuery("#BFilterInfo").on("click", BFilterInfo_Clicked);
	}
	// MZY0064	1630877		2020-12-23
	if (jQuery("#BResultStat").length>0)
	{
		jQuery("#BResultStat").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BResultStat").on("click", BResultStat_Clicked);
	}
	if (jQuery("#BPrtInventory").length>0)
	{
		jQuery("#BPrtInventory").linkbutton({iconCls: 'icon-w-print'});
		jQuery("#BPrtInventory").on("click", BPrtInventory_Clicked);
	}
	if (jQuery("#BBarCodePrint").length>0)
	{
		jQuery("#BBarCodePrint").linkbutton({iconCls: 'icon-w-print'});
		jQuery("#BBarCodePrint").on("click", BBarCodePrint_Clicked);
	}
	//InitRadio();	//  MZY0133	2612992		2022-09-09	ȡ��
	// MZY0134	2952670		2022-09-20
	if (jQuery("#BInventoryBatch").length>0)
	{
		jQuery("#BInventoryBatch").linkbutton({iconCls: 'icon-w-list'});
		jQuery("#BInventoryBatch").on("click", BInventoryBatch_Clicked);
	}
	if (jQuery("#BInventoryPlan").length>0)
	{
		jQuery("#BInventoryPlan").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BInventoryPlan").on("click", BInventoryPlan_Clicked);
	}
}
function initPage() //��ʼ��
{
	//
}
// MZY0049	2020-08-25	������ʾ��ʶ
function creatToolbar()
{
	/* MZY0123	2612989		2022-05-12
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>ȫ���豸</a>"+
						"<a id='consistentflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>����һ��</a>"+
						"<a id='unconsistentflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>���ﲻһ��</a>"+
						"<a id='uncheckflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>δ��</a>"+
						"<a id='unchecklocflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px'>���Ҳ���</a>"+
						"<a id='unfindflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>�̿�</a>"+
						"<a id='findflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:10px;margin-right:10px;'>������</a>"
						//<a href="#" class="hisui-linkbutton">��ɫ��ť</a>
						//<a href="#" class="hisui-linkbutton yellow">��ɫ��ť</a>
	//alert(lable_innerText)
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BAll_Clicked);
	}
	if (jQuery("#consistentflag").length>0)
	{
		jQuery("#consistentflag").linkbutton({iconCls: 'icon-star'});
		jQuery("#consistentflag").on("click", BConsistentflag_Clicked);
	}
	if (jQuery("#unconsistentflag").length>0)
	{
		jQuery("#unconsistentflag").linkbutton({iconCls: 'icon-star'});
		jQuery("#unconsistentflag").on("click", BUnConsistentflag_Clicked);
	}
	if (jQuery("#uncheckflag").length>0)
	{
		jQuery("#uncheckflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#uncheckflag").on("click", BUnCheck_Clicked);
	}
	if (jQuery("#unchecklocflag").length>0)
	{
		jQuery("#unchecklocflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#unchecklocflag").on("click", BUnCheckLocflag_Clicked);
	}
	if (jQuery("#unfindflag").length>0)
	{
		jQuery("#unfindflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#unfindflag").on("click", BUnFindFlag_Clicked);
	}
	// MZY0049	2020-08-25
	if (jQuery("#findflag").length>0)
	{
		jQuery("#findflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#findflag").on("click", BFindFlag_Clicked);
	}*/
}
function BAll_Clicked()
{
	//alert("BAll_Clicked")
	DisplayFlag="allflag";
	/*$("#allflag").css("color", "#FF0000");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BConsistentflag_Clicked()
{
	//alert("BConsistentflag_Clicked")
	DisplayFlag="consistentflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FF0000");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnConsistentflag_Clicked()
{
	//alert("BUnConsistentflag_Clicked")
	DisplayFlag="unconsistentflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FF0000");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnCheck_Clicked()
{
	//alert("BUnCheck_Clicked")
	DisplayFlag="uncheckflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FF0000");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnCheckLocflag_Clicked()
{
	//alert("BUnCheckLocflag_Clicked")
	DisplayFlag="unchecklocflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FF0000");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
function BUnFindFlag_Clicked()
{
	//alert("BUnFindFlag_Clicked")
	DisplayFlag="unfindflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FF0000");
	$("#findflag").css("color", "#FFFFFF");*/
	BFind_Clicked();
}
// MZY0049	2020-08-25
function BFindFlag_Clicked()
{
	//alert("BFindFlag_Clicked")
	DisplayFlag="findflag";
	/*$("#allflag").css("color", "#FFFFFF");	// MZY0128	2673539,2673540		2022-06-23
	$("#consistentflag").css("color", "#FFFFFF");
	$("#unconsistentflag").css("color", "#FFFFFF");
	$("#uncheckflag").css("color", "#FFFFFF");
	$("#unchecklocflag").css("color", "#FFFFFF");
	$("#unfindflag").css("color", "#FFFFFF");
	$("#findflag").css("color", "#FF0000");*/
	BFind_Clicked();
}
function fillData()
{
	if (IRowID=="") return;
	var StoreLocDR=getElementValue("StoreLocDR")
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneInventory",IRowID,StoreLocDR);
	//alertShow(InventoryDR+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	if (jsonData.Data.IEquipTypeIDs!="")
	{
		var arr=jsonData.Data.IEquipTypeIDs.split(",");
		$('#IEquipType').combogrid('setValues', arr);
	}
}
function setEnabled()
{
	if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992008")!=1) hiddenObj("BSaveException",1);	// MZY0048	2020-08-21	�Ƿ�������ӯ
	var IStatus=getElementValue("IStatus");
	var IAStatusDR=getElementValue("IAStatusDR");
	var IAStatus=getElementValue("IAStatus")
	//alert("IStatus:"+IStatus+"   IAStatusDR:"+IAStatusDR+"   IAStatus:"+IAStatus+"   StatusDR:"+StatusDR)
	hiddenObj("BInventoryResult",1);	// MZY0047	1457470		2020-08-19	����
	//MZY0123	2612989		2022-05-12	�������ظ�����״̬�İ�ť
	if (IStatus=='')
	{
		hiddenObj("BDelete",1);
		hiddenObj("BComfirm",1);
		hiddenObj("BLocSubmit",1);		//�̵��ύ
		hiddenObj("BInventoryBatch",1);	// MZY0134	2952670		2022-09-20
	}
	else if (IStatus==0)
	{
		hiddenObj("BFind",1)		// MZY0128	2673539,2673540		2022-06-23
		hiddenObj("BInventoryBatch",1);	// MZY0134	2952670		2022-09-20
	}
	else if (IStatus==1)
	{
		hiddenObj("BFind",1)
		hiddenObj("BSave",1)
		hiddenObj("BDelete",1);
		hiddenObj("BComfirm",1);
	}
	else if (IStatus==2)
	{
		hiddenObj("BFind",1)
		hiddenObj("BSave",1)
		hiddenObj("BDelete",1);
		hiddenObj("BComfirm",1);
		
		//disableElement("BSaveList",1);		//�����̵���
		hiddenObj("BInventoryResult",1)	//�����̵���
		//disableElement("BSaveException",1);	//��ӯ
		hiddenObj("BCancelSubmit",1);	//�˻�����
		hiddenObj("BAudit",1);			//�̵�������
		//disableElement("BPrtInventory",1);	//��ӡ�̵㵥
		//disableElement("BSaveTXT",1);		//����
		//disableElement("BBarCodePrint",1);	//��ӡ����
		hiddenObj("BInventoryBatch",1);	// MZY0134	2952670		2022-09-20
	}
	if (StatusDR==0)
	{
		hiddenObj("BLocSubmit",1);		//�̵��ύ
		hiddenObj("BInventoryResult",1)	//�����̵���
		//disableElement("BSaveList",1);		//�����̵���
		hiddenObj("BSaveException",1);	//��ӯ
		hiddenObj("BResult",1);			//���
		hiddenObj("BResultStat",1);		//�������	 MZY0064	1630825		2020-12-23
		hiddenObj("BPrtInventory",1);	//��ӡ�̵㵥
		hiddenObj("BSaveTXT",1);		//����
		hiddenObj("BBarCodePrint",1);	//��ӡ����
		//disableElement("BFilterInfo",1);		//�������� Modify by QW20210430 BUG:QW0103
		
		hiddenObj("BCancelSubmit",1);	//�˻�����
		hiddenObj("BAudit",1);			//�̵�������
	}
	else if (StatusDR==1)
	{
		//�༭��������ϸ��¼��
		hiddenObj("BFilterInfo",1);		//��������
	}
	else if (StatusDR==2)
	{
		//disableElement("BCancelSubmit",1);	//�˻�����
		hiddenObj("BLocSubmit",1)		//�̵��ύ
		hiddenObj("BFilterInfo",1);		//��������
	}
	///�����Ŵ���������ʾ
	if (IAStatusDR==0)
	{
		//hiddenObj("BCancelSubmit",1);	//�˻�����
		hiddenObj("BAudit",1);			//�̵�������
		//disableElement("BResult",1);		//���
		//disableElement("BResultStat",1);	//�������
	}
	else if (IAStatusDR==1)
	{
		hiddenObj("BLocSubmit",1)		//�̵��ύ
		//disableElement("BSaveList",1);		//�����̵�����ϸ
		//disableElement("BInventoryResult",1)	//�����̵���
		//disableElement("BFilterInfo",1)		//��������
		//disableElement("BSaveException",1);	//��ӯ
	}
	if (IAStatusDR!=1)
	{
		hiddenObj("BCancelSubmit",1);	//�˻�����
		hiddenObj("BAudit",1);			//�̵�������
		hiddenObj("BInventoryAudit",1);		//�̵�������
	}
	
	if (IAStatus!=IAStatusDR)
	{
		hiddenObj("BLocSubmit",1)		//�̵��ύ
		//disableElement("BSaveList",1);		//�����̵���
		hiddenObj("BCancelSubmit",1);	//�˻�����
		hiddenObj("BAudit",1);			//�̵�������
		//disableElement("BInventoryResult",1)	//�����̵���
	}
	//add by cjc 20022-07-28 2733215 ��ť�һ��ж�
	if((IAStatusDR=='')&&(IAStatusDR==0)){
		$('#menubtn-prt').menubutton('disable');
		$('#menubtn-prt').attr("disabled", "disabled").css({ "backgroundColor": "#bbbbbb" });
	}
	
}

function initIEquipType()
{
	$HUI.combogrid('#IEquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'ȫѡ',width:150},
	        //{field:'TCode',title:'����',width:150},
	    ]]/*,
	    onSelect:function(e){
		    //alert("onSelect:")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		},
		onClickRow:function(index, row){
			alert("onClickRow")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		}*/
	});
}
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	if(elementID=="IStoreLocDR_CTLOCDesc") {setElement("IStoreLocDR",rowData.TRowID)}
	else if(elementID=="IHospitalDR_HDesc") {setElement("IHospitalDR",rowData.TRowID)}
	else if(elementID=="PrintLoc_CTLOCDesc") {setElement("PrintLocDR",rowData.TRowID)}
	else if(elementID=="IManageLocDR_CTLOCDesc") {setElement("IManageLocDR",rowData.TRowID)}
	else if(elementID=="IPlan_Name") {
		setElement("IPlan_Name",rowData.TName)
		setElement("IHold6",rowData.TRowID)
	}	// MZY0128	2673539,2673540		2022-06-23
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQInventoryList').datagrid('validateRow', editIndex))
	{
		$('#DHCEQInventoryList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index)
{
	var Status=getElementValue("IStatus");
	// MZY0115	2469647		2022-03-10
	if (Status==0)
	{
		var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
		//objGrid.datagrid('getSelected').CTLSourceType_Desc
		//alert(rowData.ILBillEquipDR+":"+rowData.TSelect+":"+index)
		if (rowData.TSelect=="Y")
		{
			//alert("-")
			//rowData.TSelect="N"
			tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SetUncheckEquip", IRowID, rowData.ILBillEquipDR, 1);	// +
		}
		else
		{
			//alert("+")
			//rowData.TSelect="Y"
			tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SetUncheckEquip", IRowID, rowData.ILBillEquipDR, 0);	// -
		}
		
		$('#DHCEQInventoryList').datagrid('reload');
	}
	if (Status!=1) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQInventoryList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQInventoryList').datagrid('getRows')[editIndex]);
			bindGridEvent(); //�༭�м�����Ӧ
		} else {
			$('#DHCEQInventoryList').datagrid('selectRow', editIndex);
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
        /*var objGrid = $("#DHCEQInventoryList");		// ������
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
            var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
        });
        $(invPriceFeeEdt.target).bind("blur",function(){
            // ���������������� ���
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
        });*/
    }
    catch(e)
    {
        alertShow(e);
    }
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function BFind_Clicked()
{
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"));
	$HUI.datagrid("#DHCEQInventoryList",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.EM.BUSInventory",
	    	QueryName:"InventoryList",
	        InventoryDR:IRowID,
	    	StoreLocDR:getElementValue("StoreLocDR"),
	    	IStoreLocDR:getElementValue("IStoreLocDR"),
	    	EquipTypeIDs:getElementValue("IEquipTypeIDs"),
	    	StatCatDR:getElementValue("IStatCatDR"),
	    	OriginDR:getElementValue("IOriginDR"),
	    	onlyShowDiff:getElementValue("onlyShowDiff"),
	    	FilterInfo:getElementValue("FilterInfo"),
	    	ManageLocDR:getElementValue("IManageLocDR"),
	    	QXType:getElementValue("QXType"),
	    	StatusDR:StatusDR,
	    	HospitalDR:getElementValue("IHospitalDR"),
	    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
	    	DisplayFlag:DisplayFlag
		}
	});
}

function BSave_Clicked()
{
	//messageShow('alert','error','������ʾ','BSave_Clicked');
	//setElement("IHold6",getElementValue("IPlan_Name"));	// MZY0128	2673539,2673540		2022-06-23
	
	var IPlanDR=getElementValue("IHold6")
	var IPlanName=getElementValue("IPlan_Name")
	if ((IPlanDR=="")&&(IPlanName!=""))
	{
		IPlanDR=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdInventoryPlan",IPlanName);
		setElement("IHold6",IPlanDR);
	}
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"));
	if (getElementValue("IManageLocDR")=="")
	{
		messageShow('alert','error','������ʾ','�����Ų���Ϊ��!');
		return;
	}
	if (getElementValue("IEquipTypeIDs")=="")
	{
		messageShow('alert','error','������ʾ','�������鲻��Ϊ��!');
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	//alertShow(data)
	//Modify by QW20210430 BUG:QW0103 ���ӹ�����������
	var FilterInfo=getElementValue("FilterInfo");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventory",data,FilterInfo);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
function BDelete_Clicked()
{
	messageShow("confirm","","","�Ƿ�ȷ��ɾ����ǰ�̵㵥?","",DeleteInventory,DisConfirmOpt);
}
function DeleteInventory()
{
	if (IRowID=="")
	{
		messageShow('alert','error','������ʾ','û���̵㵥ɾ��!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", IRowID,1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
function DisConfirmOpt()
{
	
}
//Modified By QW20210701 BUG:QW0132 
function BComfirm_Clicked()
{
	//��ʾ�Ƿ��̵�ȷ�� ,��ֹ˫��
	messageShow("confirm","","","�Ƿ�ȷ�ϵ�ǰ�̵㵥?","",BComfirmData,"");
}
//Modified By QW20210701 BUG:QW0132 
function BComfirmData()
{
	if (IRowID=="")
	{
		messageShow('alert','error','������ʾ','û���̵㵥ȷ��!');
		return;
	}
	// MZY0128	2673539,2673540		2022-06-23
	if (getElementValue("IStoreLocDR")=="")
	{
		if (getElementValue("OptFlag")==1)
		{
			jQuery("#tInventoryOptionGrid").datagrid({
				url:'dhceq.jquery.csp',
				border:'true',
				singleSelect:true,
				fit:true,
				columns:[[
					{field:'Code',title:'TRowID',width:50,align:'center',hidden:true},
					{field:'Option',title:'ѡ���б�',width:320}
				]],
				data:{
					rows:[
						{Code:'0',TStep:'2',Option:'1. ��ǰ�豸�б������һ���̵㵥'},
						{Code:'-2',Option:'2. ���յ�ǰ�豸�б��̨�˿������������̵㵥'}
			    	]
				},
			    onSelect: function (rowIndex, rowData) {
				    dataGridSelect(rowData);		//ִ��ѡ�����
				    jQuery("#InventoryOptionWin").window('close');	//�رյ�ǰ����
				}
			});
			jQuery('#InventoryOptionWin').window('open');
			return;
		}
		if (getElementValue("OptFlag")==2)
		{
			jQuery("#tInventoryOptionGrid").datagrid({
				url:'dhceq.jquery.csp',
				border:'true',
				singleSelect:true,
				fit:true,
				columns:[[
					{field:'Code',title:'TRowID',width:50,align:'center',hidden:true},
					{field:'Option',title:'ѡ���б�',width:320}
				]],
				data:{
					rows:[
						{Code:'0',TStep:'2',Option:'1. ��ǰ�豸�б������һ���̵㵥'},
						{Code:'-2',Option:'2. ���յ�ǰ�豸�б��̨�˿������������̵㵥'},
						{Code:'-1',Option:'3. ���յ�ǰ�豸�б��һ���������������̵㵥'}
			    	]
				},
			    onSelect: function (rowIndex, rowData) {
				    dataGridSelect(rowData);		//ִ��ѡ�����
				    jQuery("#InventoryOptionWin").window('close');	//�رյ�ǰ����
				}
			});
			jQuery('#InventoryOptionWin').window('open');
			return;
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","FreezeInventory",IRowID,getElementValue("FilterInfo"),""); //modified by wy 2022-5-24 WY0100ȷ���̵㵥ʱ�������
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
// MZY0128	2673539,2673540		2022-06-23
function dataGridSelect(vRowData)
{
	//alert("Code="+vRowData.Code)
	if (vRowData.Code==0)
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","FreezeInventory",IRowID,getElementValue("FilterInfo"),getElementValue("QXType"));	// MZY0130	2816034		2022-07-27
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
		    window.setTimeout(function(){window.location.href=url},50);
		}
		else
	    {
			messageShow('alert','error','������ʾ',jsonData.Data);
	    }
	}
	else
	{
		if (getElementValue("IPlan_Name")=="")
		{
			messageShow('alert','error','������ʾ',"����д�����̵�ƻ�����! ������ٽ���ȷ�ϲ���.");
			return
		}
		var LocDRStr=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetLocDRStr",IRowID,vRowData.Code);
		if (LocDRStr=="")
		{
			messageShow('alert','error','������ʾ',"���������쳣 !");
			return
		}
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","BatchCreateInventory",IRowID,LocDRStr,vRowData.Code,getElementValue("QXType"));	// MZY0130	2816034		2022-07-27
		//alert(jsonData)
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			var url="dhceq.em.inventory.csp?&IRowID="+jsonData.Data+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
		    window.setTimeout(function(){window.location.href=url},50);
		}
		else
	    {
			messageShow('alert','error','������ʾ',jsonData.Data);
	    }
	}
}
function BSaveList_Clicked()
{
	//�����̵���
	var dataList="";
	if (editIndex != undefined){ $('#DHCEQInventoryList').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQInventoryList').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var val="dept=ILActerStoreLoc="+rows[i].ILActerStoreLocDR+"^";
		val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
		list=val.split("^");
		Detail=list[0].split("=");
		if (rows[i].ILActerStoreLoc!=Detail[1])
		{
			rows[i].ILActerStoreLoc="";
			rows[i].ILActerStoreLocDR="";
		}
		if (rows[i].ILStatus==1)
		{
			if (rows[i].ILActerStoreLocDR!=rows[i].ILBillStoreLocDR)
			{
				alertShow("����һ��: ��"+(i+1)+"�С�̨�˿ⷿ���͡�ʵ�ʿⷿ����һ��.������!");
				return;
			}
		}
		if (rows[i].ILStatus==2)
		{
			if ((rows[i].ILActerStoreLocDR==rows[i].ILBillStoreLocDR)||(rows[i].ILActerStoreLocDR==""))
			{
				alertShow("���Ҳ���: ��"+(i+1)+"�С�ʵ�ʿⷿ������.������!");
				return;
			}
		}
		if (rows[i].ILStatus==3)
		{
			if (rows[i].ILActerStoreLocDR!="")
			{
				alertShow("�̿�: ��"+(i+1)+"�С�ʵ�ʿⷿ������.������!");
				return;
			}
		}
		// MZY0049	2020-08-25
		if (rows[i].ILStatus==4)
		{
			if (rows[i].ILActerStoreLocDR!="")
			{
				alertShow("������: ��"+(i+1)+"�С�ʵ�ʿⷿ������.������!");
				return;
			}
		}
		// MZY0057	1506387		2020-10-09		���Ӳ���
		if ((rows[i].ILCondition=="")&&(tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992006")==1))
		{
			// MZY0049	2020-08-25
			if ((rows[i].ILStatus!="")&&(rows[i].ILStatus!=3)&&(rows[i].ILStatus!=4))
			{
				alertShow("���״̬: ��"+(i+1)+"�в���Ϊ��.������!");
				return;
			}
		}
		if (dataList!="") dataList=dataList+getElementValue("SplitRowCode");
		dataList=dataList+rows[i].ILRowID+"^"+rows[i].ILActerStoreLocDR+"^"+rows[i].ILActerUseLocDR+"^"+rows[i].ILStatus+"^"+rows[i].ILRemark+"^"+rows[i].ILCondition+"^"+rows[i].LIUseStatus+"^"+rows[i].LIPurpose+"^"+rows[i].LILossReasonDR+"^"+rows[i].ILIKeeperDR+"^"+rows[i].ILILocationDR+"^"+rows[i].ILILeaveFactoryNo+"^"+rows[i].ILILocationDR_LDesc;
	}
	//alert(rows.length+":"+dataList)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventoryList", IRowID, dataList);
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href=url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}


function DisConfirmOpt()
{
}

function BLocSubmit_Clicked()
{
	var IARowID=getElementValue("IARowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","LocInventory", IARowID,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','�ύʧ����ʾ',jsonData.Data);
	}
	else
	{
		var ISelfFlag=getElementValue("ISelfFlag");
		var IStoreLocDR=getElementValue("IStoreLocDR");
		var IManageLocDR=getElementValue("IManageLocDR");
		if ((ISelfFlag==true)&&(IStoreLocDR!="")&&(IStoreLocDR!=IManageLocDR))
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", IRowID,2);
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0)
			{
				messageShow("","","","�˴��̵����!")
			    //window.location.reload()
				var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
			    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
					url += "&MWToken="+websys_getMWToken()
				}
			    window.setTimeout(function(){window.location.href=url},50);
			}
			else
		    {
				messageShow('alert','error','�̵���ɴ�����ʾ',jsonData.Data);
		    }
		}
		else
		{
			//messageShow("","","","�˴��̵����!")
			var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR")+"&IARowID="+IARowID;
			//url= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+InventoryDR+"&ReadOnly="+ReadOnly;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
			window.setTimeout(function(){window.location.href=url},50);
		}
	}
}

function BAudit_Clicked()
{
	var UnSubmitNum=getElementValue("UnSubmitNum");
	var UnAuditNum=getElementValue("UnAuditNum");
	var MsgDesc="";
	if (UnSubmitNum>0)
	{
		MsgDesc="��"+UnSubmitNum+"�����ҵ��̵�����û���ύ,"
	}
	if (UnAuditNum>0)
	{
		MsgDesc=MsgDesc+"��"+UnAuditNum+"�����ҵ��̵�����û��ȷ��,"
	}
	
	var MsgDesc=MsgDesc+"�Ƿ�ȷ��������ǰ�̵㵥?"
	//��ʾ�Ƿ��̵����
	messageShow("confirm","","",MsgDesc,"",FinishInventory,"");
}

function FinishInventory()
{
	if (IRowID=="")
	{
		messageShow('alert','error','������ʾ','�̵㵥IDΪ��!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteData", IRowID,2);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","�˴��̵����!")
	    //window.location.reload()
		var url="dhceq.em.inventory.csp?&IRowID="+IRowID+"&StatusDR="+getElementValue("StatusDR")+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}

/*function BResult_Clicked()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryResult&InventoryDR='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	showWindow(str,"�̵���","","","icon-w-paper","modal","","","middle");
}*/
function BResultStat_Clicked()
{
	//var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryResultStat&InventoryDR='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	var str='dhceq.em.resultstat.csp?&InventoryDR='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");	// MZY0133	2612992		2022-09-09
	showWindow(str,"�������","","","icon-w-paper","modal","","","middle");
}

function BInventoryAudit_Clicked()
{
	var str='dhceq.em.inventoryaudit.csp?&IRowID='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("IStoreLocDR")+"&ManageLocDR="+getElementValue("IManageLocDR");   //Modified By QW20210416 BUG:QW0097 �������δ���
	showWindow(str,"�����̵���","","","icon-w-paper","modal","","","middle");		// MZY0133	2612992		2022-09-09
}
// MZY0134	2952670		2022-09-20
function BInventoryBatch_Clicked()
{
	var str='dhceq.em.inventorybatch.csp?&IRowID='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
	showWindow(str,"δ���豸��������","","","icon-w-paper","modal","","","middle",reloadGrid);
}
function BSaveTXT_Clicked()
{
	var locid=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextLoc", IRowID, "");
	if (locid=="")
	{
		messageShow("","","","���̵㵥δȷ��,��������!");
		return;
	}
	try
	{
		var FileName=GetFileNameToTXT();
		var fso = new ActiveXObject("Scripting.FileSystemObject");
    	var f = fso.OpenTextFile(FileName,2,true);	//����д�ļ�
		//д�����
		f.WriteLine("�̵㵥��:"+getElementValue("IInventoryNo")+"\t��������:"+FormatDate(GetCurrentDate()));
	    var tmpString="���"+"\t"+"ʹ�ÿ���"+"\t"+"�豸����"+"\t"+"Ժ�����"+"\t"+"�豸����"+"\t"+"ԭֵ"+"\t"+"��λ"+"\t"+"����"+"\t"+"����ͺ�"+"\t"+"��������"+"\t"+"�������"+"\t"+"��Ӧ��"+"\t"+"����������"+"\t"+"ʵ������"+"\t"+"��ע";
	    f.WriteLine(tmpString);
		
		//д���¼
		var row=0;		//���
		do
		{
			if (locid!="")
			{
				var equipdr="";
				var rowid="";
				var TotalFee=0;
				var Count=0;
				do
				{
					var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextListInfo", IRowID,locid,equipdr,rowid);
					result=result.replace(/\r\n/g,"");
					//alertShow(result)
					if (result=="")
					{
						equipdr="";
						rowid="";
					}
					else
					{
						var list=result.split("^");
						equipdr=list[0];
						rowid=list[1];
						row=row+1;
						//NewEquipDR,NewRowID,Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace,CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider
						tmpString=row+"\t"+list[8]+"\t"+list[2]+"\t"+list[5]+"\t"+list[19]+"\t"+list[11]+"\t"+list[6]+"\t"+1+"\t"+list[3]+"\t"+list[4]+"\t"+list[20]+"\t"+list[21]+"\t"+FormatDate(list[18]);
						f.WriteLine(tmpString);
						TotalFee=TotalFee+parseFloat(list[11]);
						Count=Count+1;
					}
				} while(rowid!="")
				f.WriteLine("С��"+"\t\t\t\t\t"+TotalFee+"\t\t"+Count);
			}
			locid=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextLoc", IRowID, locid);
		} while(locid!="")
		f.Close();
		messageShow("","","","�������!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}
function BBarCodePrint_Clicked()
{
	var Status=getElementValue("IAStatusDR");
	if ((Status=="")||(Status=0))
	{
		messageShow('alert','error','������ʾ','δȷ���̵㵥���ܴ�ӡ����!');
		return
	}
	// MZY0092	2127012		2021-08-27
	messageShow("confirm","info","��ʾ","���δ�ӡ���̵㵥ȫ����'ʵ�ʿⷿ'���豸����,�Ƿ����?","",function(){
					confirmPrintBar();
				},function(){
				return;
			},"����","ȡ��");
}
// MZY0092	2127012		2021-08-27
function confirmPrintBar()
{
	var Strs="";
	do
	{
		Strs=tkMakeServerCall("web.DHCEQSPrint","GetEquipBarInfo",IRowID+"^"+Strs,"Inventory");
		if (Strs!="")
		{
			printBars(Strs, 0);
		}
	} while (Strs!="")
}
function GetStatus(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILStatus=data.TRowID;
	//rowData.ILStatus_Display=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILStatus_Display'});
	$(editor.target).combogrid("setValue",data.TDesc);
	if (data.TRowID==1)
	{
		// ����һ��
		//alert(rowData.ILBillStoreLoc)
		rowData.ILActerStoreLocDR=rowData.ILBillStoreLocDR;
		editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
		$(editor.target).combogrid("setValue",rowData.ILBillStoreLoc);
	}else{ //Add By QW20210416 BUG:QW0097 �޸�״̬�����
		editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
		$(editor.target).combogrid("setValue","");
	}
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLoc(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILActerStoreLocDR=data.TRowID;
	//rowData.ILActerStoreLoc=data.TName;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILActerStoreLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetCondition(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILCondition=data.TRowID;
	//rowData.ILCondition_Display=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILCondition_Display'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function BPrtInventory_Clicked()
{
	// MZY0128	2673539,2673540		2022-06-23
	var Status=getElementValue("IAStatusDR");
	if ((Status=="")||(Status=0))
	{
		messageShow('alert','error','������ʾ','δȷ���̵㵥���ܴ�ӡ!');
		return
	}
	var StoreLocDR=getElementValue("StoreLocDR");
	var PrintLocDR=getElementValue("PrintLocDR");
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "990062");			//��ӡ��ʽ��־λ excel��0  ��Ǭ:1
	var PreviewRptFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "990075");		//��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var HOSPDESC=tkMakeServerCall("web.DHCEQCommon","GetHospitalDesc");
	var filename = "";
	//alert("BPrtInventory_Clicked:"+PrintFlag+PreviewRptFlag+HOSPDESC);
	
	//Excel��ӡ��ʽ
	if(PrintFlag==0)
	{
		PrintInventory();
	}
	//��Ǭ��ӡ
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{
			// MZY0058	1468106		2020-10-18
		    fileName="{DHCEQInventoryPrint.raq(InventoryDR="+IRowID+";StoreLocDR="+StoreLocDR+";PrintLocDR="+PrintLocDR
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+curUserName
		    +")}";
		    //alert(fileName)
	        DHCCPM_RQDirectPrint(fileName);
		}
		
		if(PreviewRptFlag==1)
		{
			// MZY0058	1468106		2020-10-18
			fileName="DHCEQInventoryPrint.raq&InventoryDR="+IRowID+"&StoreLocDR="+StoreLocDR+"&PrintLocDR="+PrintLocDR
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+curUserName
			DHCCPM_RQPrint(fileName);
		}
	}
}
function PrintInventory()
{	
	var result;
	var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	var Template=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQInventoryLoc.xls";
	if (locid!="")
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var locid=getElementValue("PrintLocDR");
	if (locid!="")
	{
		result=PrintOneLoc(locid,xlsheet);
		if (result>0) xlsheet.printout; //��ӡ���
	}
	else
	{
		do
		{
			var locid=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextLoc",IRowID,locid);
			if (locid!="")
			{
				result=PrintOneLoc(locid,xlsheet);
				if (result>0) 
				{
					xlsheet.printout; //��ӡ���
					if (result>1)
					{
						var rows=result+3;
						var rows="5:"+rows
						xlsheet.Rows(rows).Delete();
					}
					xlsheet.Rows(4).ClearContents()
				}
			}
		} while(locid!="")
	}
	xlBook.Close (savechanges=false);
	xlsheet.Quit;
	xlsheet=null;
	xlApp=null;
}
function PrintOneLoc(locid,xlsheet)
{
	var equipdr,rowid;
	var row;
	var result;
	if (locid=="") return 0;
	if (""==IRowID) return 0;
	var InventoryNo=getElementValue("InventoryNo");	
	var curDate=GetCurrentDate();
	var username=curUserName;
	var loc="";
	
	row=0;
	equipdr="";
	rowid="";
	do
	{
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetNextListInfo",IRowID,locid,equipdr,rowid);
		if (result=="")
		{
			equipdr="";
			rowid="";
		}
		else
		{
			var list=result.split("^");
			equipdr=list[0];
			rowid=list[1];
			row=row+1;
			xlsheet.Rows(row+3).Insert();
			//NewEquipDR_"^"_NewRowID_"^"_Name_"^"_Model_"^"_Manufactory_"^"_No_"^"_Unit_"^"_EquipCat_"^"_StoreLoc_"^"_UseLocDR_"^"_UseLoc_"^"_OriginalFee_"^"_Origin_"^"_StorePlace_"^"_CheckDate_"^"_OpenCheckDate_"^"_Country_"^"_ManageUser_"^"_InDate_"^"_EquipType_"^"_LeaveFactoryNo_"^"_Provider
			//alert(result)
			xlsheet.cells(row+3,2)=list[8];
			xlsheet.cells(row+3,3)=list[5];	//No
			xlsheet.cells(row+3,4)=list[2];	//Name
			xlsheet.cells(row+3,5)=list[3];	//Model
			//xlsheet.cells(row+3,5)=list[6];	//Unit
			xlsheet.cells(row+3,6)=list[11];	//OriginalFee
			//xlsheet.cells(row+3,7)=FormatDate(list[18]);	//InDate
			if (""==loc) loc=list[8];	//StoreLoc
		}
	} while(rowid!="")
	if (0==row) return 0;
	xlsheet.cells(2,3)=loc;
	xlsheet.cells(2,7)=InventoryNo;
	var delRow=row+4;
	xlsheet.Rows(delRow).Delete();
	xlsheet.cells(row+4,3)=FormatDate(curDate);
	xlsheet.cells(row+4,7)=username;
	
	return row;	
}
function BSaveException_Clicked()
{
	//alert("IListInfoClickHandler:"+rowData.ILRowID)
	var url= 'dhceq.em.inventoryexception.csp?&InventoryDR='+IRowID+'&InventoryNo='+getElementValue("IInventoryNo")+'&ReadOnly='+getElementValue("ReadOnly");
	showWindow(url,"��ӯ�豸��Ϣ","","","icon-w-paper","modal","","","large");
}
function BInventoryPlan_Clicked()
{
	//alert("BInventoryPlan_Clicked:"+rowData.ILRowID)
	var url= 'dhceq.em.inventoryplanmanage.csp?&InventoryDR='+IRowID+'&InventoryPlanDR=&ReadOnly='+getElementValue("ReadOnly");
	showWindow(url,"�̵�ƻ�","","","icon-w-paper","modal","","","large");
}
function setElementEnabled()
{
	//var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	//if(Rtn=="1") disableElement("CTContractNo",true);
}

function BInventoryResult_Clicked()
{
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("�̵���");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var InventoryNo=trim(xlsheet.cells(Row,Col++).text);
		var EquipNo=trim(xlsheet.cells(Row,Col++).text);
		var EquipName=trim(xlsheet.cells(Row,Col++).text);
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		if (InventoryNo=="")
		{
		    alertShow("�̵㵥�Ų���Ϊ��!");
		    return 0;
		}
		if (EquipNo=="")
		{
		    alertShow("̨���豸��Ų���Ϊ��!");
		    return 0;
		}
		if (EquipName=="")
		{
		    alertShow("̨���豸���Ʋ���Ϊ��!");
		    return 0;
		}
		if (UseLoc=="")
		{
		    alertShow("ʵ��ʹ�ÿ��Ҳ���Ϊ��!");
		    return 0;
		}
		else
		{
			var UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("��"+Row+"�� ʵ��ʹ�ÿ��ҵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpLoadInventoryResult", "", UseLocDR, "", "", EquipNo, EquipName, "", "", "", "", InventoryNo);
		if (result!=0) alertShow("�� "+Row+" �� <"+xlsheet.cells(Row,2).text+"> ��Ϣ����ʧ��!!!��˶Ը�����Ϣ.");;
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	alertShow("�����̵���Ϣ�������!");
	window.location.reload();
}

//Modify by QW20210430 BUG:QW0103 �����������ʱ��
function BFilterInfo_Clicked()
{
	var InventoryDR=getElementValue("IRowID");
	var FilterInfo=getElementValue("FilterInfo");
	var url="dhceq.em.inventoryfilterinfo.csp?InventoryDR="+InventoryDR+"&FilterInfo="+FilterInfo;
	showWindow(url,"ɸѡ����",500,400,"icon-w-paper","modal","","","",setFilterInfo); 
}
//Modify by QW20210430 BUG:QW0103 �Ӵ���ɸѡ������ֵ
function setFilterInfo(value)
{
	setElement("FilterInfo",value)
}
/* MZY0133	2612992		2022-09-09	ȡ��
function InitRadio()
{
    $HUI.radio("[name='wantEat']",{
        onChecked:function(e,value){
            //logger.info($(e.target).attr("label"));  //�����ǰѡ�е�labelֵ
			if ($(e.target).attr("value")=="consistentflag") {
				BConsistentflag_Clicked();
			} else if ($(e.target).attr("value")=="unconsistentflag") {
				BUnConsistentflag_Clicked();
			} else if ($(e.target).attr("value")=="uncheckflag") {
				BUnCheck_Clicked();
			} else if ($(e.target).attr("value")=="unchecklocflag") {
				BUnCheckLocflag_Clicked();
			} else if ($(e.target).attr("value")=="unfindflag") {
				BUnFindFlag_Clicked();
			} else if ($(e.target).attr("value")=="findflag") {
				BFindFlag_Clicked();
			} else {
				BAll_Clicked();
			}
        }
    });
}*/
// MZY0133	2612992		2022-09-09
function initFilterKeyWords()
{
	 $("#FilterKeyWords").keywords({
        singleSelect:true,
        onClick:function(v){},
        onUnselect:function(v){
	    },
        onSelect:function(v){
	        var selectItemID=v.id;
			if (selectItemID=="allflag")
			{
				DisplayFlag="allflag";
			}
			else if(selectItemID=="consistentflag")
			{
				DisplayFlag="consistentflag";
			}
			else if (selectItemID=="unconsistentflag")
			{
				DisplayFlag="unconsistentflag";
			}
			else if (selectItemID=="uncheckflag")
			{
				DisplayFlag="uncheckflag";
			}
			else if (selectItemID=="unchecklocflag")
			{
				DisplayFlag="unchecklocflag";
			}
			else if (selectItemID=="unfindflag")
			{
				DisplayFlag="unfindflag";
			}
			else if (selectItemID=="findflag")
			{
				DisplayFlag="findflag";
			}
			BFind_Clicked();
	    },
        labelCls:'blue',
        items:[
            {text:'ȫ���豸'+'<span class="eq-resourcenum" id="AllNum"></span>',id:'allflag'},
            {text:'����һ��'+'<span class="eq-resourcenum" id="ConsistentNum"></span>',id:'consistentflag'},
            {text:'���ﲻһ��'+'<span class="eq-resourcenum" id="UnConsistentNum"></span>',id:'unconsistentflag'},
            {text:'δ��'+'<span class="eq-resourcenum" id="UnCheckNum"></span>',id:'uncheckflag',selected:true},
            {text:'���Ҳ���'+'<span class="eq-resourcenum" id="UnCheckLocNum"></span>',id:'unchecklocflag'},
            {text:'�̿�'+'<span class="eq-resourcenum" id="UnFindNum"></span>',id:'unfindflag'},
            {text:'������'+'<span class="eq-resourcenum" id="FindNum"></span>',id:'findflag'}
        ]
    });
}
// MZY0134	2952670		2022-09-20
function reloadGrid()
{
	fillData();
	BFind_Clicked();
	//window.location.reload();		��ֹȫˢ
}
function GetLocation(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILILocationDR=data.TRowID;
	//rowData.ILILocationDR_LDesc=data.TName;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILILocationDR_LDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetKeeper(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.ILIKeeperDR=data.TRowID;
	//rowData.ILIKeeperDR_SSUSRName=data.TName;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'ILIKeeperDR_SSUSRName'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetLossReason(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.LILossReasonDR=data.TRowID;
	//rowData.LILossReasonDR_LRDesc=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LILossReasonDR_LRDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetUseStatus(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.LIUseStatus=data.TRowID;
	//rowData.LIUseStatus_USDesc=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LIUseStatus_USDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetPurpose(index, data)
{
	var rowData = $('#DHCEQInventoryList').datagrid('getSelected');
	rowData.LIPurpose=data.TRowID;
	//rowData.LILossReasonDR_LRDesc=data.TDesc;
	var editor = $('#DHCEQInventoryList').datagrid('getEditor',{index:editIndex,field:'LIPurpose_PDesc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQInventoryList').datagrid('endEdit',editIndex);
	$('#DHCEQInventoryList').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
