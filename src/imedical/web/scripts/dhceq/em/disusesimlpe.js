var editIndex=undefined;
var modifyBeforeRow={};
var oneFillData={};

var Columns=getCurColumnsInfo('EM.G.DisuseSimpleList','','','')

$(function(){
    initDocument();
    $(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-01-16 QW20200218 BUG:QW0040
});

function initDocument()
{
	initUserInfo();
	setElement("DRRequestLocDR",curLocID);
	setElement("DRRequestLocDR_CTLOCDesc",curLocName);
	setElement("DRUseLocDR",curLocID);
	setElement("DRUseLocDR_CTLOCDesc",curLocName);
	setElement("DREquipTypeDR_ETDesc",getElementValue("DREquipType"));
	setElement("DRDisuseTypeDR",1);
	setElement("DRDisuseTypeDR_DRDesc","���ڱ���");
    initMessage(); // add by wy 2020-01-16 QW20200218 BUG:QW0040
	defindTitleStyle(); 
	
	initLookUp(); //��ʼ���Ŵ�
	
	initButton(); //��ť��ʼ��
	initButtonWidth();
	setRequiredElements("DRRequestLocDR_CTLOCDesc^DRUseLocDR_CTLOCDesc^DREquipTypeDR_ETDesc"); //modified by csj 20191112 ������id����
	fillData();
	setEnabled();
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"));     //add by jyp 2020-02-27  JYP0020  ������Ϣ����ӿɱ༭�ֶ�
	initApproveButton(); //��ʼ��������ť
	var obj=document.getElementById("BSelfCancelSubmit");  //add by mwz 2021-01-18 MWZ0048
    if (obj) obj.onclick=BSelfCancelSubmit_Clicked;
    //Modify by zx 2021-05-19 Bug 1897085
    var obj=document.getElementById("BAppendFile");
    if (obj) obj.onclick=BAppendFile_Clicked;
	//table���ݼ���
	$HUI.datagrid("#DHCEQDisuseRequestSimple",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSDisuseRequest",
			QueryName:"DisuseList",
			RowID:getElementValue("DRRowID"),
			Job:getElementValue("DRJob") // add by  QW20200218 BUG:QW0040
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers:true,  //���Ϊtrue������ʾһ���к���
	    toolbar:[
		    {
				iconCls: 'icon-add',
	            text:'����',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },
	        {
	            iconCls: 'icon-cancel',   //modified by wy 2020-4-23 UI����
	            text:'ɾ��',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        }
        ],
	    columns:Columns,
	    //rownumbers:false,  //modified by kdf 2019-03-01 	����ţ�836884
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,30,75,100],
		onLoadSuccess:function(){
				creatToolbar();
			}
	});
	$("#BRecover").linkbutton({iconCls: 'icon-w-back'}); // add by wy 2020-01-16 QW20200218 BUG:QW0040//modified by wy 2020-4-23 UI����
	jQuery('#BRecover').on("click", BRecover_Click); /// Add By QW20191008 BUG:QW0028 ���ӱ��ϻָ���ť
	///Modiedy by zc0057 ���ӱ��ϱ�ǩ��ӡ  begin
	jQuery("#BDisusePrintBar").linkbutton({iconCls: 'icon-w-print'});
	jQuery("#BDisusePrintBar").on("click", BDisusePrintBar_Click);
	//Modiedy by zc0057 ���ӱ��ϱ�ǩ��ӡ   end
};

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	var rows = $('#DHCEQDisuseRequestSimple').datagrid('getRows');
    var totalDLQuantityNum = 0;
    var totalDLTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
        	var colValue=rows[i]["DLQty"];
        	if (colValue=="") colValue=0;
        	totalDLQuantityNum += parseFloat(colValue);
        	colValue=rows[i]["DLTotalFee"];
        	if (colValue=="") colValue=0;
        	totalDLTotalFee += parseFloat(colValue);
    }
	var lable_innerText='������:'+totalDLQuantityNum+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalDLTotalFee.toFixed(2);
	// modified by wy 2020-01-16 end QW20200218 BUG:QW0040
	$("#sumTotal").html(lable_innerText);
	var panel = $("#DHCEQDisuseRequestSimple").datagrid("getPanel");
	var rows = $("#DHCEQDisuseRequestSimple").datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
	    if (rows[i].TSourceID=="")
	    {
		    $("#DLEquipList"+"z"+i).hide(); // modified by wy 2020-01-16 QW20200218 BUG:QW0040
		}
    }
    
	var Status=getElementValue("DRStatus");
	//modified By QW20200512 BUG:QW0063 �ϼ������� begin
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
	}
	//modified By QW20200512 BUG:QW0063 �ϼ������� end
	var  job=$('#DHCEQDisuseRequestSimple').datagrid('getData').rows[0].DRJob; // modified by wy 2020-01-16 QW20200218 BUG:QW0040
	setElement("DRJob",job);
}

//add by kdf 2019-01-22
//�������
function fillData()
{
	var DRRowID=getElementValue("DRRowID")
	if (DRRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	
	
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","GetOneDisuseRequest",DRRowID,ApproveRoleDR,Action,Step)
	
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ","�������ʧ�ܣ��������"+jsonData.Data);return;}
	//modified By QW20191023 �����:1065779 �޸ı��ϻָ�ִ�гɹ��޷�ˢ�½������� 
	if (jsonData.Data["DRInvalidFlag"]=="1")   return;  // modified by wy 2020-01-16 QW20200218 BUG:QW0040
	//End By QW20191023 �����:1065779 �޸ı��ϻָ�ִ�гɹ��޷�ˢ�½������� 
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
    if (jsonData.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
	// Add By QW20191008 BUG:QW0028 ���ϵ���Ч���ʼ����ť
	if (jsonData.Data["DRInvalidFlag"]=="1")
	{
		disableElement("BRecover",true);
	}
	// End By QW20191008 BUG:QW0028
	
}

//add by kdf 2019-01-22
//��ť�ֻ�
function setEnabled()
{ 
	var Status=getElementValue("DRStatus");
	var WaitAD=getElementValue("WaitAD");
	disableElement("DRHold4",true);
	disableElement("DRHold5",true);
	hiddenObj("BClear",true); //add by wy 2020-9-24 1532207
	///Modiedy by zc0058  ���ϴ�ӡ��ť�ύ�󲻿ɲ�������Ĵ���  begin
	if ((Status=="")||(Status=="0"))
	{
		//Modify by zx 2021-05-19 Bug 1897085
		if(Status=="") disableElement("BAppendFile",true);
		if(Status=="") disableElement("BPicture",true);  //Add By By zy20221115 bug��3073937
		disableElement("BSelfCancelSubmit",true) //add by mwz 2021-01-18 MWZ0048
		disableElement("BDisusePrintBar",true);
	}
	if (Status!="0")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		///Modiedy by zc0058  ���ϴ�ӡ��ť�ύ�󲻿ɲ�������Ĵ���
		//disableElement("BDisusePrintBar",true);   ///Modiedy by zc0057 ���ϴ�ӡ��ǩӰ�� 
	    hiddenObj("BClear",false);
		if (Status!="")
		{
			disableElement("BSave",true);
			hiddenObj("BClear",true); 
		}
		else
		{
			disableElement("Opinion",1)
			disableElement("DRRejectReason",1)
		}
	}
	else{
		disableElement("Opinion",1)
		disableElement("DRRejectReason",1)
	}
	//��˺�ſɴ�ӡ������ת�Ƶ�
    //modified by ZY 20221107  3044786
    //if (Status!="2")
    if (Status<1)
	{
		disableElement("BPrint",true); //Modified by QW20191022 BUG:QW0032 ��ӡ��ť��ʼ��
		//disableElement("BPrintBar",true);
		disableElement("BRecover",true); // Add By QW20191008 BUG:QW0028 ���ϻָ���ť��ʼ��
		///Modiedy by zc0058  ���ϴ�ӡ��ť�ύ�󲻿ɲ�������Ĵ���
		//disableElement("BDisusePrintBar",true);   ///Modiedy by zc0057 ���ϴ�ӡ��ǩӰ�� 
	}
	//�ǽ����ݲ˵�,���ɸ��µȲ�������
	if (WaitAD!="false")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BSave",true);
	}
	///���ϰ�ť
	// Add By QW20200218 begin BUG:QW0041 ��������:����Ȩ������
	//modified by wy 2020-4-18 1276569
	var RecoverFlag=getElementValue("RecoverFlag");
	if ((RecoverFlag=="1")&&(Status=="2"))
	{
		disableElement("BRecover",false); 
	}
	else{
		disableElement("BRecover",true);  
		
	}
	if ((Status=="2")||(getElementValue("ReadOnly")==1))
	{
		hiddenObj("BSelfCancelSubmit",true)
	}
	var SelfFlag=getElementValue("SelfFlag");
	var ApproveRole=getElementValue("CurRole"); 
	if ((SelfFlag=="")&&(ApproveRole!="")) disableElement("BSelfCancelSubmit",true)  //Modified By QW20210729 BUG:QW0145
}

// modified by kdf 2019-01-10
// ���������
// modified by wy 2020-01-16 QW20200218 BUG:QW0040
function getEquipList(index,data)
{
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	/// add by kdf 2019-05-27 begin ����ţ�860203
	var rows = $('#DHCEQDisuseRequestSimple').datagrid('getRows');
		for(var i=0;i<rows.length;i++){
			if(editIndex!=i) continue  //modified by csj 2020-11-10 ����ţ�1590562
			if(data.TEquipDR!=="")
			{
				if((rows[i].DLSourceID!=="")&&(rows[i].DLSourceID==data.TEquipDR))
				{
					messageShow('alert','error','��ʾ','��ǰѡ��������ϸ�е�'+(i+1)+'���ظ�!')
					return;
				}
			}
			else {
			if(rows[i].DLNo==data.TInStockNo)
			{
				messageShow('alert','error','��ʾ','��ǰѡ��������ϸ�е�'+(i+1)+'���ظ�!')
				return;
			}
		}
		//add by wy 2020-4-29 �������Ͽ��Ƽ��δ�����豸 begin
		if(data.TEquipDR!=="")
		 { 
		 	var EQRowID=data.TEquipDR
		 }
		else {
			     var Result=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","GetEquipByInStockListDR",data.TInStockListDR,getElementValue("DRUseLocDR"));  //modified by wy 2020-05-06 bug WY0067
				  var list=Result.split("^");
				  var EQRowID=list[0]
			 }
		var LimitYearsType=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601005");
		var Flag=tkMakeServerCall("web.DHCEQEquip","GetLimitYearsNum",EQRowID);
		if (Flag<0)
		{
			if (getElementValue("DRDisuseTypeDR")==LimitYearsType)
			{
				messageShow('alert','info','��ʾ','��ǰ��'+(i+1)+'���豸δ��ʹ�����ޣ����ܱ��ϣ�');
				return;
			}
			else
			{
					messageShow('alert','info','��ʾ','��ǰ��'+(i+1)+'���豸δ��ʹ������!');
			}
		}
        //add by wy 2020-4-29 �������Ͽ��Ƽ��δ�����豸 end
	}
	var rowData = $('#DHCEQDisuseRequestSimple').datagrid('getSelected');
	rowData.DLSourceType=1
	rowData.DLSourceID=data.TInStockListDR
	rowData.DLNo=data.TInStockNo  //modified by wy 2020-4-30 ������ֵ���� bug WY0066
	if (data.TEquipDR!=="") 
	{
		rowData.DLSourceType=0
		rowData.DLSourceID=data.TEquipDR
		rowData.DLNo=data.TNo  //modified by wy 2020-4-30 ������ֵ���� bug WY0066

	}
	rowData.DLSource=data.TEquip
	rowData.DLHold1=data.TOriginalFee
	rowData.DLQty=data.TQuantityNum
	rowData.DLTotalFee=data.TOriginalFee*data.TQuantityNum
	rowData.DLUnit=data.TUnit	
	rowData.DLProvider=data.TProvider
	rowData.DLModel=data.TModel
	rowData.DLManuFactory=data.TEQManufacturer
	rowData.DLStock=data.TStoreLoc
	rowData.DLInDate=data.TInDate
	//Modified BY QW20200320 BUG:QW0049 begin ѡ���豸��,����ʾ�豸��ֵ���ۼ��۾ɡ�
	rowData.DLNetFee=data.TNetFee
	rowData.DLDepreTotalFee=data.TDepreTotalFee
	//Modified BY QW20200320 BUG:QW0049 End 
	var objGrid = $("#DHCEQDisuseRequestSimple"); 
	
	var NameEditor = objGrid.datagrid('getEditor', {index:editIndex,field:'DLSource'});
	$(NameEditor.target).combogrid("setValue",data.TEquip);
	$('#DHCEQDisuseRequestSimple').datagrid('endEdit',editIndex);
	mth(editIndex,data.TQuantityNum);  //Add by QW20200303 BUG:QW0042
    // modified by wy 2020-01-16 end QW20200218 BUG:QW0040
}


function onClickRow(index)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQDisuseRequestSimple').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQDisuseRequestSimple').datagrid('getRows')[editIndex]);
			bindGridEvent();  //�༭�м�����Ӧ // modified by wy 2020-01-16 QW20200218 BUG:QW0040
		} else {
			$('#DHCEQDisuseRequestSimple').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQDisuseRequestSimple').datagrid('validateRow', editIndex)){
		$('#DHCEQDisuseRequestSimple').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// �������� add by kdf 2019-01-10
function insertRow()
{
	if(editIndex>="0"){
		$("#DHCEQDisuseRequestSimple").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = $("#DHCEQDisuseRequestSimple").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    if ((lastIndex>=0)&&(rows[lastIndex].DLSourceID==""))
    {
	    messageShow("alert","error","������ʾ","��"+newIndex+"������Ϊ��!������д����.");
	}
	else
	{
		$("#DHCEQDisuseRequestSimple").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//�������е�ͼ��
		$("#DLEquipList"+"z"+newIndex).hide(); // modified by wy 2020-01-16 QW20200218 BUG:QW0040
	}
}

//ɾ���� ad by kdf 2019-01-10
function deleteRow()
{
	if (editIndex>="0")
	{
		$("#DHCEQDisuseRequestSimple").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		$('#DHCEQDisuseRequestSimple').datagrid('deleteRow',editIndex)
	}
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}
}

// ����ѡ����¼�
// modified by kdf 2019-01-10
// modified by wy 2020-01-16 QW20200218 BUG:QW0040
function setSelectValue(elementID,rowData)
{
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	if(elementID=="DRRequestLocDR_CTLOCDesc") {setElement("DRRequestLocDR",rowData.TRowID);}
	else if(elementID=="DRUseLocDR_CTLOCDesc") {setElement("DRUseLocDR",rowData.TRowID);}
	else if(elementID=="DRDisuseTypeDR_DRDesc") {setElement("DRDisuseTypeDR_DRDesc",rowData.TDesc);setElement("DRDisuseTypeDR",rowData.TRowID);} //Modified BY QW20200320 BUG:QW0050
    else if(elementID=="DREquipTypeDR_ETDesc") {setElement("DREquipTypeDR",rowData.TRowID);}
	/*
	if(editIndex != undefined)
	{
		var sourceIDEdt = $("#DHCEQDisuseRequestSimple").datagrid('getEditor', {index:editIndex,field:'DLSource'});
		$(sourceIDEdt.target).combogrid('grid').datagrid('load');
	}
	*/
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}


function saveDataFromInStock(rowData)
{
	var SMRowID=getElementValue("RowID");
	if (SMRowID!="")
	{
		
	}
	var fromLocDR=getElementValue("SMFromLocDR");  
	var moveType=getElementValue("SMMoveType");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetSMInfoByISL",rowData.TEquipID,rowData.TInStockListID,moveType,curUserID);
	
	jsonData=jQuery.parseJSON(jsonData);
	jsonData.Data["SMJob"]=getElementValue("SMJob");
	jsonData.Data["SMStoreMoveNo"]="";
	jsonData.Data["SMRowID"]="";
	var data = jsonData.Data;
	data = JSON.stringify(data);
	if (rowData.TInStockListID==0)
	{
		var EquipDR=rowData.TEquipID;
		var InStockListDR="";
		var BatchFlag="";
	}
	else
	{
		var EquipDR="";
		var InStockListDR=rowData.TInStockListID;
		var BatchFlag="Y"
	}
	
	var dataList={"SMLRowID":""};
	dataList["SMLEquipDR"]=EquipDR;
	dataList["SMLInStockListDR"]=InStockListDR;
	dataList["SMLBatchFlag"]=BatchFlag;
	dataList["SMLEquip"]=rowData.TName;
	dataList["SMLManuFactoryDR"]=rowData.TManuFactoryDR;
	dataList["SMLOriginalFee"]=rowData.TOriginalFee;
	dataList["SMLQuantityNum"]=rowData.TQuantity;
	dataList["SMLModelDR"]=rowData.TModelDR;
	dataList["SMLUnitDR"]=rowData.TUnitDR;
	dataList["SMLLocationDR"]=rowData.TLocationDR;
	dataList = JSON.stringify(dataList);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var flag=getElementValue("flag");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
		url="dhceq.em.storemove.csp?"+val;
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

// modified by kdf 2019-01-11
// ���水ť�¼�
function BSave_Clicked()
{	
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	if (checkMustItemNull()) return	
	//Add BY QW20200326 BUG:QW0052 begin �����б༭
	if(editIndex>="0"){
		jQuery("#DHCEQDisuseRequestSimple").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
	//Add BY QW20200326 BUG:QW0052 end
	var data=getInputList();
	// modified by wy 2020-01-16 end QW20200218 BUG:QW0040
	data=JSON.stringify(data);
	var dataList="";
	var rows = $('#DHCEQDisuseRequestSimple').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		if ((oneRow.DLSource=="")||(oneRow.DLSource==undefined))   //modify by lmm 2019-02-17 826174
		{
			messageShow('alert','error','��ʾ',"��"+(i+1)+"�����ݲ���ȷ!");
			return "-1";
		}
	    oneRow["DLIndex"]=i; //indexֵ���� // modified by wy 2020-01-16 QW20200218 BUG:QW0040
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData // modified by wy 2020-01-16 QW20200218 BUG:QW0040
		}
		
	}
	if (dataList=="")
	{
		messageShow('alert','error','��ʾ',"��ϸ����Ϊ��!");
		return;
	}
	disableElement("BSave",true)	//add by csj 2020-03-10 ��У������
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","SaveData",data,dataList,"0");

	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");

		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&Type=0"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 ����ʧ�ܺ�����
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}

// modified by kdf 2019-01-11
// ɾ����ť�¼�
function BDelete_Clicked()
{
	
	var DRRowID=getElementValue("DRRowID")
	
	if (DRRowID=="")
	{
		messageShow("alert","error","������ʾ","û�е��ݿ�ɾ��!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","SaveData",DRRowID,"","1");
	
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
         var val="&Type=0"
         val=val+"&RowID="    //add by lmm 2019-02-17 826215
         val=val+"&WaitAD=false"   //add by lmm 2019-02-17 826215
	    
		url="dhceq.em.disusesimlpe.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow("alert","error","������ʾ","ɾ��ʧ��,������Ϣ:"+jsonData.Data);
		return
    }
}

// MZY0153	3295363		2023-02-20	���Ӿ�ֵ�ж�
///�ύ
function BSubmit_Clicked()
{
	var Data = tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest", "CheckEquipNetfee", getElementValue("DRRowID"));
	if (Data != "")
	{
		messageShow("confirm", "info", "��ʾ", Data+" ���ϱ�ŵ��豸��ֵ��Ϊ0,�Ƿ�����ύ����?", "", SubmitRequest, "");
	}
	else
	{
		SubmitRequest();
	}
}
function SubmitRequest()
{
	var DRRowID=getElementValue("DRRowID")
	if (DRRowID=="")
	{
		messageShow("alert","error","������ʾ","û�е��ݿ�ɾ��!");
		return;
	}
	//add by wy 2021-4-23 ���α�������ͣ�ù��� bug WY0088 begin
	var NeedChange=tkMakeServerCall("web.DHCEQChangeInfo","NeedChange","34",DRRowID,"1");
	var GetStopEquipFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990037");
	var CheckStoreLocDR=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CheckStoreLocDR",getElementValue("DRUseLocDR"));   // add by kdf 2019-06-10 �ڿ��豸����ʾͣ�� �����920964
	if ((NeedChange==1) && (GetStopEquipFlag==1) && (CheckStoreLocDR!=1))   // modified by kdf 2019-06-10 �ڿ��豸����ʾͣ�� �����920964
	{
		messageShow("confirm","","","��ǰ�����豸�Ƿ�ͣ��?","",function(){
			GetStopEquipFlag=2;
			SubmitData(DRRowID,GetStopEquipFlag)
			},
			function(){
				SubmitData(DRRowID,GetStopEquipFlag)
				
			});
	}
	else
	{
		SubmitData(DRRowID,GetStopEquipFlag)
	}
}
function SubmitData(DRRowID,GetStopEquipFlag){
	if (GetStopEquipFlag==2)
	{
		var result=tkMakeServerCall("web.DHCEQChangeInfo","StopEquipBySource","34",DRRowID,"1");
		if (result!=0)
		{
			alertShow("�豸ͣ��ʧ��!")
			return;
		}
	}
	
	///Modefied by zc0110 2021-12-15 �ж�ҵ���Ƿ���ڱ����ϴ������� begin
	var FileMustRtn=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","CheckMustUpLoad",'34',DRRowID,'1')
	var FileMustInfo=FileMustRtn.split("^");
	var FileFlag=FileMustInfo[0]
	var FileTyp=FileMustInfo[2]
	if (FileFlag=="1")
	{
		alertShow("�б����ϴ���"+FileTyp+"�ļ�û���ϴ�!") 
		return ;
	}
	///Modefied by zc0110 2021-12-15 �ж�ҵ���Ƿ���ڱ����ϴ������� end
	//add by wy 2021-4-23 ���α�������ͣ�ù��� bug WY0088 end
  var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","SubmitData",DRRowID);		
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");

		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType+"&SelfFlag=1"; //Modifed By QW20210621 BUG:QW0125
		url="dhceq.em.disusesimlpe.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','������ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}

// add by kdf 2019-01-23 ȡ���ύ
function BCancelSubmit_Clicked()
{
	var DRRowID=getElementValue("DRRowID");
	
	if (DRRowID=="")
	{
		messageShow('alert','error','��ʾ',"û�б��ϵ�ȡ��!");
		return;
	}
	// add by sjh SJH0034 2020-09-10 BEGIN
	var DRRejectReason=getElementValue("DRRejectReason");
	if (DRRejectReason=="")
	{
		messageShow('alert','error','��ʾ',"û����д�˻�ԭ��!");
		return
	} 
	// add by sjh SJH0034 2020-09-10 END
	//add by wy 2020-05-06 1288746ϵͳ���������Ƿ�ɾ�����ܱ��ϵ��еĶ�Ӧ��ϸ��¼ begin
	var RoleStep=getElementValue("RoleStep");
	if(RoleStep=="1")
	{
	//add by wy 2021-4-23 ���α�������ͣ�ù��� bug WY0088 begin
	var NeedChange=tkMakeServerCall("web.DHCEQChangeInfo","NeedChange","34",DRRowID,"0");
	var GetStopEquipFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990037");
	var CheckStoreLocDR=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CheckStoreLocDR",getElementValue("DRUseLocDR"));   // add by kdf 2019-06-10 �ڿ��豸����ʾͣ�� �����920964
	if ((NeedChange==1) && (GetStopEquipFlag==1) && (CheckStoreLocDR!=1))   // modified by kdf 2019-06-10 �ڿ��豸����ʾͣ�� �����920964
	  {
		messageShow("confirm","","","��ǰ�����豸�Ƿ�ȡ��ͣ��?","",function(){
		GetStopEquipFlag=2;
		CancelSubmitData(DRRowID,GetStopEquipFlag)
			},
			function(){
				CancelSubmitData(DRRowID,GetStopEquipFlag)
				
			});
	  }
	else
	   {
		CancelSubmitData(DRRowID,GetStopEquipFlag)
	   }
	}
	else{		
		 BCancelData()
		}

}
function CancelSubmitData(DRRowID,GetStopEquipFlag)
{	
		if (GetStopEquipFlag==2)
		{
			var result=tkMakeServerCall("web.DHCEQChangeInfo","StopEquipBySource","34",DRRowID,"0");
			if (result!=0)
			{
				alertShow("�豸ȡ��ͣ��ʧ��!")
				return;
			}
		}		
		var vFlag=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetMergeOrderFlag",DRRowID);
		var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601006");
		if ((CheckFlag==1)&&(vFlag==0))
			{
				messageShow("confirm","","","������������ȡ��(��������Ч���ܱ��ϵ��еĶ�Ӧ��ϸ��¼)?","",function(){		
					BCancelData();
					},
					function(){return;})	
			}
		else if ((CheckFlag!=1)&&(vFlag==0))   //Add By QW20210525  BUG:QW0114
		{
			messageShow("alert","error","��ʾ","�ñ��ϵ��Ѵ�������ܵ���,�޷�����!")
			return
		}
		else {
				BCancelData();
			
			 }		//add by wy 2021-4-23 ���α�������ͣ�ù��� bug WY0088 end
}
function BCancelData()
{
	var DRRowID=getElementValue("DRRowID");
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
  	var DRRejectReason=getElementValue("DRRejectReason");	
  	var combindata=DRRowID+"^"+getElementValue("CurRole")+"^^^^"+DRRejectReason+"^";  //Modified By QW20200119 BUG:QW0039
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","CancelSubmit",combindata);	
	// modified by wy 2020-01-16 end QW20200218 BUG:QW0040
    var RtnObj=JSON.parse(Rtn)
    
    
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("alert","error","������ʾ","������Ϣ:"+RtnObj.Data);
	    return;
    }
    else
    {
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
	    
	    var val="&RowID="+RtnObj.Data+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
    }

}
//add by wy 2020-05-06 1288746ϵͳ���������Ƿ�ɾ�����ܱ��ϵ��еĶ�Ӧ��ϸ��¼ end

/// add by kdf 2019-01-23
function GetOpinion()
{
	var ApproveRole=getElementValue("CurRole");
	var CurStep=getElementValue("RoleStep");
	var combindata=getElementValue("CurRole") ;
  	combindata=combindata+"^"+getElementValue("RoleStep") ;
  	combindata=combindata+"^"+getElementValue("Opinion") ;	// MZY0153	3188364		2023-02-20
  	combindata=combindata+"^"+getElementValue("OpinionRemark") ;
  	return combindata;
  	
}

/// add by kdf 2019-01-23 ����¼�
///modified by ZY0298 20220310  ���ӻ�����ڵ��ж�����
function BApprove_Clicked()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSAccountPeriod","IsCurPeriod");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
		messageShow("confirm","info","��ʾ","��ǰ���������ݻ�ͳ����������:"+RtnObj.Data+"��<br>��ȷ���Ƿ�Ҫ����ִ�в���?","",BApprove,function(){return},"ȷ��","ȡ��");
    }
    else
    {
	    BApprove()
	}
}
function BApprove()
{
	var RowID=getElementValue("DRRowID");
	if (RowID=="")  return;
	//begin add  by jyp 2020-02-27  JYP0022  ������Ϣ����ӿɱ༭�ֶ�
	var objtbl=getParentTable("DRRequestNo")  
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);   
	if (EditFieldsInfo=="-1") return;                    
	//end add  by jyp 2020-02-27  JYP0022  ������Ϣ����ӿɱ༭�ֶ�
	
	var combindata=RowID+"^"+GetOpinion()+"^^"; //Modified By QW20200119 BUG:QW0039
	//Add By By zy20221115 bug��3073937
	if (getElementValue("Opinion")=="")
	{
	    messageShow("alert","error","������ʾ","������Ϣ:����������Ϊ��!");
	    return;
	}
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","AuditData",combindata,"",EditFieldsInfo);   //modify by jyp 2020-02-27  JYP0022  ������Ϣ����ӿɱ༭�ֶ�	
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
	    //window.location.reload();
	    var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
	    
	    var val="&RowID="+RtnObj.Data+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType+"&SelfFlag=1&CurRole="+GetElementValue("CurRole"); //Modifed By QW20210701 BUG:QW0133
		url="dhceq.em.disusesimlpe.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
    else
    {
	    messageShow("alert","error","������ʾ","������Ϣ:"+RtnObj.Data);
	    return;
    } 
	
}
//add by wy 2020-01-16 QW20200218 BUG:QW0040
function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQDisuseRequestSimple");        // ������
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'DLQty'});            // ����
        // ����  �� �뿪�¼� 
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQDisuseRequestSimple').datagrid('getSelected');
            var moveNum=parseFloat(rowData.DLQty);
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            // ���������������� ���
            var originalFee= (typeof rowData.DLHold1 == 'undefined') ? "" : rowData.DLHold1;
            originalFee=parseFloat(originalFee);
			rowData.DLTotalFee=quantityNum*originalFee;
			$('#DHCEQDisuseRequestSimple').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}

//add by wy 2020-01-16 QW20200218 BUG:QW0040Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="LocDR"){return getElementValue("DRUseLocDR")}
	else if (ID=="EquipTypeDR"){return getElementValue("DREquipTypeDR")}	
	else if (ID=="Flag")
	{
		if (editIndex == undefined) return "";  
		var flagEdt = $("#DHCEQDisuseRequestSimple").datagrid('getEditor', {index:editIndex,field:'DLFlag'}); 
		return flagEdt==null?'':flagEdt.target.checkbox("getValue");	
}
}
//add by wy 2020-01-16 QW20200218 BUG:QW0040�豸��ϸ�������
function BUpdateEquipsByList(editIndex)
{
	var rowData =  $("#DHCEQDisuseRequestSimple").datagrid("getRows")[editIndex];
    var inStockListDR=""
    var equipDR=""
    var SourceType=rowData.DLSourceType;
    if (SourceType=="1")
    {
		var inStockListDR=(typeof rowData.DLSourceID == 'undefined') ? "" : rowData.DLSourceID;
    }
    else
    {
	     var equipDR=(typeof rowData.DLSourceID == 'undefined') ? "" : rowData.DLSourceID;
    }
	if ((inStockListDR=="")&&(equipDR=="")) return;
	var quantityNum=(typeof rowData.DLQty == 'undefined') ? "" : rowData.DLQty;
	if (quantityNum=="") return;
	var url="dhceq.em.updateequipsbylist.csp?";
	url=url+"SourceID="+inStockListDR;
	url=url+"&QuantityNum="+quantityNum;
	url=url+"&Job="+getElementValue("DRJob");
	url=url+"&Index="+editIndex;
	var DLRowID = (typeof rowData.DLRowID == 'undefined') ? "" : rowData.DLRowID;
	url=url+"&MXRowID="+DLRowID;
	url=url+"&StoreLocDR="+getElementValue("DRUseLocDR");
	url=url+"&Status="+getElementValue("DRStatus");
	url=url+"&Type=5";
	url=url+"&EquipID="+equipDR;
	showWindow(url,"�豸��ϸ�б�","","","icon-w-paper","modal","","","small",mth);   
}
//add by wy 2020-01-16  QW20200218 BUG:QW0040�豸��ϸ���������޸���������
function mth(index,quantity)
{
	$('#DHCEQDisuseRequestSimple').datagrid('selectRow', index).datagrid('beginEdit', Number(index));
	var rowData = $('#DHCEQDisuseRequestSimple').datagrid('getSelected');
	var objGrid = $("#DHCEQDisuseRequestSimple");        // ������
    var quantityEdt = objGrid.datagrid('getEditor', {index:index,field:'DLQty'}); // ����
	$(quantityEdt.target).val(quantity);
	var originalFee= (typeof rowData.DLHold1 == 'undefined') ? "" : rowData.DLHold1;
	rowData.DLTotalFee=quantity*originalFee;
	$('#DHCEQDisuseRequestSimple').datagrid('endEdit',Number(index));  
}
//Add By QW20191008 BUG:QW0028
//���ӱ��ϻָ�����
function BRecover_Click()
{
	var DRRowID=getElementValue("DRRowID")
	var Result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","RecoverDisUseEquip",DRRowID);
	var	list=Result.split("^");
	if (list[0]!=0)
	{
		messageShow('alert','error','��ʾ',"������Ϣ:"+list[1]);		//Mozy	949803	2019-9-12
		return;
	}else
	{
		///Modiedy by zc0058  ���ϵ�����Ч��Ӧ�ر�ҳ�� begin
		//var WaitAD=getElementValue("WaitAD"); 
		//var QXType=getElementValue("QXType");
	    
	    //var val="&RowID="+DRRowID+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType; //modified By QW20191023 �����:1065779 �޸ı��ϻָ�ִ�гɹ��޷�ˢ�½������� 
		//url="dhceq.em.disusesimlpe.csp?"+val;
	    //window.location.href= url;
		websys_showModal("close"); 
		///Modiedy by zc0058  ���ϵ�����Ч��Ӧ�ر�ҳ�� end
	}
}

function BPrint_Clicked()
{
	//modified by QW20191022 BUG:QW0032 ������Ǭ��excel��ӡ
	var PrintFlag=getElementValue("PrintFlag");
	var DRRowID=getElementValue("DRRowID")
	if ((DRRowID=="")||(DRRowID<1))  return;
	//add by ZY20230228 bug:3295367
	var lodopBussIDs=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990090")
	if (lodopBussIDs.indexOf("34")!=-1)
	{
		var c1=String.fromCharCode(1);
		var c2=String.fromCharCode(2);
		var inpara="title"+c2+session['LOGON.HOSPDESC']+"�ʲ����ϵ�";
		inpara+="^DRRequestNo"+c2+GetShortName(oneFillData["DRRequestNo"],"-");
		inpara+="^DRUseLocDR_CTLOCDesc"+c2+oneFillData["DRUseLocDR_CTLOCDesc"];  //ʹ�ÿ���
		inpara+="^DREquipTypeDR_ETDesc"+c2+oneFillData["DREquipTypeDR_ETDesc"];
		inpara+="^DRRequestDate"+c2+oneFillData["DRRequestDate"];
		inpara+="^PrintDate"+c2+GetCurrentDate(2);
		inpara+="^ApproveOpinon1"+c2+oneFillData["ApproveOpinon1"];
		inpara+="^ApproveOpinon2"+c2+oneFillData["ApproveOpinon2"];
		inpara+="^ApproveOpinon3"+c2+oneFillData["ApproveOpinon3"];
		inpara+="^ApproveOpinon4"+c2+oneFillData["ApproveOpinon4"];
		inpara+="^ApproveOpinon5"+c2+oneFillData["ApproveOpinon5"];
		inpara+="^ApproveOpinon6"+c2+oneFillData["ApproveOpinon6"];
		
		
		var jsonArr=[
			{type:"img",name:"ApproveUser1",x:"52.381", y:"103.968",width:"20",height:"6",value:oneFillData["ApproveUser1"]},
			{type:"img",name:"ApproveUser2",x:"52.381", y:"113.503",width:"20",height:"6",value:oneFillData["ApproveUser2"]},
			{type:"img",name:"ApproveUser3",x:"52.381", y:"123.503",width:"20",height:"6",value:oneFillData["ApproveUser3"]},
			{type:"img",name:"ApproveUser4",x:"52.381", y:"133.503",width:"20",height:"6",value:oneFillData["ApproveUser4"]},
			{type:"img",name:"ApproveUser5",x:"52.381", y:"143.503",width:"20",height:"6",value:oneFillData["ApproveUser5"]},
			{type:"img",name:"ApproveUser6",x:"52.381", y:"153.503",width:"20",height:"6",value:oneFillData["ApproveUser6"]},
		]
		
		var gbldata=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetList",DRRowID);
		var list=gbldata.split(getElementValue("SplitNumCode"));
		var Listall=list[0];
		var rows=list[1];
		var PageRows=6;//ÿҳ�̶�����
		var Pages=parseInt(rows / PageRows); //��ҳ��-1  
		var ModRows=rows%PageRows; //���һҳ����
		if (ModRows==0) {Pages=Pages-1;}
		for (var i=0;i<=Pages;i++)
    		{
	    	
			var inlist=""
	    		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Lists=Listall.split(getElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+Row];
				var List=Listl.split("^");
				var cellRow=Row+4;
				var oneRowStr=""
				if (List[0]=='�ϼ�')
				{
					inpara+="^sum"+c2+List[0];//����
					inpara+="^sumQty"+c2+List[4];//����
					inpara+="^sumFee"+c2+List[6];//�ܼ�

				}
				else
				{
					oneRowStr=List[8];//���
					oneRowStr=oneRowStr+"^"+List[0];//�豸����
					oneRowStr=oneRowStr+"^"+List[1];//����
					oneRowStr=oneRowStr+"^"+List[5];//����
					oneRowStr=oneRowStr+"^"+List[6];//ԭֵ
					
					oneRowStr=oneRowStr+"^"+List[9];//�۾�����
					oneRowStr=oneRowStr+"^"+List[10];//ʹ������
					oneRowStr=oneRowStr+"^"+List[11];//����ԭ��
				}
				
				if (inlist=="")
				{
					inlist=oneRowStr;
				}
				else
				{
					inlist=inlist+c1+c2+oneRowStr
				}
    			}
    			printByLodop("DHCEQDisuseRequest",inpara,inlist,jsonArr,"",{printListByText:true})
    		}
	}
	else
	{
		if(PrintFlag==0)
		{
			 Print(DRRowID);
		}
		else if(PrintFlag==1)
		{
			var RequestNo=oneFillData["DRRequestNo"];
			var RequestLoc=oneFillData["DRRequestLocDR_CTLOCDesc"];
			var EquipType=oneFillData["DREquipTypeDR_ETDesc"];
			var RequestDate=oneFillData["DRRequestDate"];
			var UseLoc=oneFillData["DRUseLocDR_CTLOCDesc"];
			var UseLocCode=tkMakeServerCall("web.DHCEQCommon", "GetTrakNameByID","deptcode",oneFillData["DRUseLocDR"]);
			var PreviewRptFlag=getElementValue("PreviewRptFlag"); //add by wl 2019-11-11 WL0010 begin   ������ǬԤ����־
			var HOSPDESC = getElementValue("GetHospitalDesc"); //Modified by sjh 2019-12-06 BUG00019 begin ����ҽԺ����
		//modified by ZY20230215 ��������˵Ĵ�ӡ
		var DRAddUser=oneFillData["DRAddUserDR_UDesc"];
		var DRSubmitUser=oneFillData["DRSubmitUserDR_UDesc"];
		var DRAuditUser=oneFillData["DRAuditUserDR_UDesc"];
			var fileName=""
			//Add By QW20210913 BUG:QW0147 �������Ӳ�����	begin
			var EQTitle="";
			var PrintNumFlag=getElementValue("PrintNumFlag");
			if(PrintNumFlag==1)  
			{
				var num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","34",DRRowID)
				if(num>0) EQTitle="(����)";
			}
			if(PreviewRptFlag==0)
			{ 
        fileName="{DHCEQDisuseRequestPrint.raq(RequestNo="+RequestNo+";RequestLoc="+RequestLoc+";RequestDate="+RequestDate+";UseLoc="+UseLoc+";EquipType="+EquipType+";UseLocCode="+UseLocCode+";HOSPDESC="+HOSPDESC+";EQTitle="+EQTitle+";DRAddUser="+DRAddUser+";DRAuditUser="+DRAuditUser+")}"; 
				DHCCPM_RQDirectPrint(fileName);
			}
			else if(PreviewRptFlag==1)
			{ 
        fileName="DHCEQDisuseRequestPrint.raq&RequestNo="+RequestNo+"&RequestLoc="+RequestLoc+"&RequestDate="+RequestDate+"&UseLoc="+UseLoc+"&EquipType="+EquipType+"&UseLocCode="+UseLocCode+"&HOSPDESC="+HOSPDESC+"&EQTitle="+EQTitle+"&DRAddUser="+DRAddUser+"&DRAuditUser="+DRAuditUser; 
				DHCCPM_RQPrint(fileName);//Modified by sjh 2019-12-06 BUG00019 end ����ҽԺ����
			}												//add by wl 2019-11-11 WL0010 end
		}
	}
	//End by QW20191022 BUG:QW0032 ������Ǭ��ӡ
	var DisusePrintOperateInfo="^34^"+DRRowID+"^^���ϴ�ӡ����^0"
	var PrintFlag=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",DisusePrintOperateInfo)
	//Modified By QW20210913 BUG:QW0147 �޸Ĵ�ӡ����  end
}
//Add by QW20191022 BUG:QW0032 excel��ӡ
function Print(disuseid)
{
		var gbldata=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetList",disuseid);
		var list=gbldata.split(getElementValue("SplitNumCode"));
		var Listall=list[0];
		rows=list[1];
		var PageRows=6;
		var Pages=parseInt(rows / PageRows); //��ҳ��?1  3Ϊÿҳ�̶�����
		var ModRows=rows%PageRows; //���һҳ����
		if (ModRows==0) {Pages=Pages-1;}
        var xlApp,xlsheet,xlBook;
		var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	    var Template=TemplatePath+"DHCEQDisuse11.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		   
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//Add By QW20210913 BUG:QW0147 �������Ӳ�����	begin
			var PrintNumFlag=getElementValue("PrintNumFlag");
			if(PrintNumFlag==1)  
			{
				var num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","34",disuseid)
				if(num>0) 
				{
				    xlsheet.cells(1,1)="[Hospital]�豸���ϵ�(����)"
			    	
				}
			}
			//Add By QW20210913 BUG:QW0147 �������Ӳ�����	end
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
	    	xlsheet.cells(2,2)="���ϵ��ţ�"+oneFillData["DRRequestNo"];//���ϵ���
	    	xlsheet.cells(2,6)=oneFillData["DRRequestDate"];
	    	xlsheet.cells(2,9)=oneFillData["DRRequestLocDR_CTLOCDesc"];
	    	xlsheet.cells(3,2)="���飺"+oneFillData["DREquipTypeDR_ETDesc"];
			xlsheet.cells(3,9)=oneFillData["DRUseLocDR_CTLOCDesc"];  //ʹ�ÿ���
			var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		var Lists=Listall.split(getElementValue("SplitRowCode"));
	   		for (var j=1;j<=OnePageRow;j++)
			{

				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				if ((List[0]=='�ϼ�')&&(i==Pages))
				{
					xlsheet.cells(10,2)=List[0];
					xlsheet.cells(10,7)=List[4];//����
					xlsheet.cells(10,9)=List[6];//���
				}
				else
				{
					xlsheet.cells(Row,2)=List[0];//�豸����
					xlsheet.cells(Row,3)=List[1];//����
					xlsheet.cells(Row,4)=List[2];//��λ
					xlsheet.cells(Row,5)=List[3];//����
					xlsheet.cells(Row,6)=List[4];//�������
					xlsheet.cells(Row,7)=List[5];//����
					xlsheet.cells(Row,8)=List[6];//����
					xlsheet.cells(Row,9)=List[7];//���
					
							
				}
					var Row=Row+1;
				
	    	}
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    	var size=obj.GetPaperInfo("DHCEQInStock");
	    	if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; //��ӡ���
	    	xlBook.Close (savechanges=false);	    
	    	xlsheet.Quit;
	    	xlsheet=null;
		}
		xlApp=null;
}
///Modiedy by zc0057 ���ӱ��ϱ�ǩ��ӡ  
function BDisusePrintBar_Click()
{
	var RowID=getElementValue("DRRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","GetOneDisuseRequest",RowID,'','','')
	jsonData=jQuery.parseJSON(jsonData);
	var objDisUse=jsonData.Data;
	var strs=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetDisuseEquipIDs",RowID)
	var strArray=strs.split(",");
	var n=strArray.length;
	for (var m=0;m<n;m++)
	{
		var equipid=strArray[m];
		if (equipid=="")
		{
			messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
			return;
		}
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",equipid);
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
		var objEquip=jsonData.Data;
		var BarInfoDR=tkMakeServerCall("web.DHCEQCBarInfo","GetBarInfoDR",'DHCEQDisuseRequest');
		var Listall=tkMakeServerCall("web.DHCEQCBarInfo","GetPrintBarInfo",equipid,BarInfoDR);
		//alertShow(Listall)
		if (Listall=="")
		{
			alertShow("�豸��Ϣ������������Ϣ��Ч,��˶�!");
			return;
		}
		var Lists=Listall.split(getElementValue("SplitRowCode"));
		var NewString="";
		var InfoList=Lists[0].split("^");
		//alertShow("No="+Listall)
		for (var i=1;i<Lists.length;i++)
		{
			// 1^0^^����^��׼��ά��������ӡ^����^16^N^^^N^60^150^^^N^^^^N^^^1^^^^^&1^0^EQName^�豸����^����:^����^8^N^1^^N^^^^^N^^^^N^^^2^^^^^&1^0^EQNo^�豸���^���:^����^8^N^2^^N^^^^^N^^^^N^^^3^^^^^&1^0^EQModelDR_MDesc^����ͺ�^�ͺ�:^����^8^N^3^^N^^^^^N^^^^N^^^^^^^^&1^0^EQManuFactoryDR_MFName^��������^����:^����^8^N^4^^N^^^^^N^^^^N^^^^^^^^&1^0^EQLeaveFactoryNo^�������^SN��:^����^8^N^5^^N^^^^^N^^^^N^^^^^^^^&1^0^EQStartDate^��������^����:^����^8^N^6^^N^^^^^N^^^^N^^^^^^^^&1^0^EQUseLocDR_CTLOCDesc^ʹ�ÿ���^����:^����^8^N^7^^N^^^^^N^^^^N^^^^^^^^&1^0^EQLocationDR_LDesc^��ŵص�^���:^����^8^N^8^^N^^^^^N^^^^N^^^^^^^^&1^0^EQHospital^ҽԺ����^ҽԺ:^����^8^N^9^^N^^^^^N^^^^Y^^^^^^^^&1^0^EQOriginalFee^ԭֵ^ԭֵ:^����^8^N^10^^N^^^^^N^^^^Y^^^^^^^^&1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^����1^4^^^^^
			// 1^0^^����^��׼��ά��������ӡ^����^16^N^^^N^60^150^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^������ʾϵͳ^�豸����^����:^����^8^N^1^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^3222299001100^�豸���^���:^����^8^N^2^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^\sd^����ͺ�^�ͺ�:^����^8^N^3^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^��ͨ���칫˾^��������^����:^����^8^N^4^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^CCBH2019020201^�������^SN��:^����^8^N^5^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^2019-02-02^��������^����:^����^8^N^6^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^X����^ʹ�ÿ���^����:^����^8^N^7^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^210C��^��ŵص�^���:^����^8^N^8^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^������׼�����ֻ�ҽԺ[��Ժ]^ҽԺ����^ҽԺ:^����^8^N^9^^N^^^^^N^^^^N^^^16^^^^^$CHAR(3)1^0^6300.00^ԭֵ^ԭֵ:^����^8^N^10^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^����1^4^^^^^
			var DetailList=Lists[i].split("^");
			// ��������Ԫ��
			if (DetailList[19]!="Y")
			{
				if (DetailList[2]!="")
				{
					// ��ֵ��ʽ��
					if (DetailList[20]!="")
					{
						if (DetailList[23]=="DHCEQDisuseRequest")
						{
							var tmpValue=ColFormat(objDisUse[DetailList[2]],DetailList[20]);
						}
						else
						{
							var tmpValue=ColFormat(objEquip[DetailList[2]],DetailList[20]);
						}
						Lists[i]=DetailList[0]+"^"+DetailList[1]+"^"+tmpValue;
						for (var j=3;j<DetailList.length;j++)
						{
							Lists[i]=Lists[i]+"^"+DetailList[j];
						}
					}
					else
					{
						if (DetailList[23]=="DHCEQDisuseRequest")
						{
							Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objDisUse[DetailList[2]]+"^");
						}
						else
						{
							Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objEquip[DetailList[2]]+"^");
						}
					}
				}
				if (NewString!="") NewString=NewString+getElementValue("SplitRowCode");
				NewString=NewString+Lists[i];
			}
		}
		
	
		//ÿ���߸����� 17+3*4,������
		//alertShow(InfoList[19]+":"+QRErrorCorrectLevel.Q)
		var type=0;
		var qrcode="";
		if (InfoList[19]==0)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.M);
			qrcode = new QRCode(type, QRErrorCorrectLevel.M);
		}
		if (InfoList[19]==1)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.L);
			qrcode = new QRCode(type, QRErrorCorrectLevel.L);
		}
		if (InfoList[19]==2)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.H);
			qrcode = new QRCode(type, QRErrorCorrectLevel.H);
		}
		if (InfoList[19]==3)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.Q);
			qrcode = new QRCode(type, QRErrorCorrectLevel.Q);
		}
		//var valueStr=(objEquip.EQFileNo=="")?objEquip.EQNo:"fileno:"+objEquip.EQFileNo+",no:"+objEquip.EQNo;
		var ValueStr=utf16to8(objEquip.EQNo);
		qrcode.addData(ValueStr);
		qrcode.make();
		var TempCode=""
		for (var i=0;i<qrcode.modules.length;i++)
		{
			for (var j=0;j<qrcode.modules.length;j++)
			{
				TempCode+=String(Number(qrcode.modules[i][j]))
			}
		}
		if (getElementValue("ChromeFlag")=="1")
		{
			var Str ="(function test(x){"
			Str +="var Bar=new ActiveXObject('EquipmentBar.PrintBar');"
			Str +="Bar.SplitRowCode='"+getElementValue("SplitRowCode")+"';"			// Mozy003002	2020-03-18	�������÷���
			Str +="Bar.BarInfo='"+Lists[0]+"';"	// ��ά��������ӡ-�Ϸ�ҽԺ^1^60^500^0^2^2^3500^2000^1350^200^����^10^Y^0^160^600^1200^0^3^EQNo^0^520^0^Y^tiaoma^2^N^10248^65285^42428^^^^^^^��׼��ά��^3222299001100
			Str +="Bar.BarDetail='"+NewString+"';"
			Str +="Bar.QRCode='"+TempCode+"';"
			Str +="Bar.PrintOut('1');"
			Str +="return 1;}());";
			CmdShell.notReturn =0;   //�����޽�����ã�����������
			var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
		}
		else
		{
			var Bar=new ActiveXObject("EquipmentBar.PrintBar");
			Bar.SplitRowCode=getElementValue("SplitRowCode");
			Bar.BarInfo=Lists[0];
			Bar.BarDetail=NewString;
			Bar.QRCode=TempCode;
			Bar.PrintOut('1');
		}
	}
}
//add by wy 2020-04-02 bug WY0058
//���ӹ�ѡ����ʾ��
function checkboxDLFlagChange(DLFlag,rowIndex)
{
	var row = jQuery('#DHCEQDisuseRequestSimple').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (DLFlag==key)
			{
				if (((val=="N")||val=="")) row.DLFlag="Y"
				else row.DLFlag="N"
			}
		})
	}
}
//add by wy 2020-9-24 1532207����ҵ����������
function BClear_Clicked()
{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var val="&WaitAD="+WaitAD+"&Type=0"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
	    window.location.href= url;
}
//add by mwz 2021-01-18 MWZ0048
//ҵ�񵥾��Է����ع���
function BSelfCancelSubmit_Clicked()
{
	var DRRowID=getElementValue("DRRowID");
	
	if (DRRowID=="")
	{
		messageShow('alert','error','��ʾ',"û�б��ϵ�ȡ��!");
		return;
	}
	var RoleStep=getElementValue("RoleStep");
	if(RoleStep=="0")
	{
		var vFlag=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetMergeOrderFlag",DRRowID);
		var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601006");
		if ((CheckFlag==1)&&(vFlag==0))
			{
				messageShow("confirm","","","������������ȡ��(��������Ч���ܱ��ϵ��еĶ�Ӧ��ϸ��¼)?","",function(){		
					BSelfCancelData();
					},
					function(){return;})	
			}
			//add by mwz 2021-05-18 MWZ0049 begin
		else if ((CheckFlag!=1)&&(vFlag==0)){
			
				messageShow('alert','error','��ʾ',"�ñ��ϵ��Ѵ����ڻ��ܵ���,�޷�����!");  
				return;			
			 }
			 //add by mwz 2021-05-18 MWZ0049 end
		else {
				BSelfCancelData();
			
			 }
		 
    }
    else{
		BSelfCancelData();
    }
   }
//add by mwz 2021-01-18 MWZ0048 
///ҵ�񵥾��Է����ع���
function BSelfCancelData()
{
	var RowID=GetElementValue("RowID");
	var Status=GetElementValue("Status")
	var Type=GetElementValue("Type")
	if (Status>1)
	{
		messageShow('alert','error','��ʾ',"�õ�����������,�޷�����");
		return;
	}
	var combindata=RowID+"^"+GetOpinion();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","SelfCancelSubmitData",combindata,GetElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
	  	messageShow("alert","info","��ʾ","���سɹ�");
		var val="&RowID="+RowID+"&WaitAD=false"+"&Type=0"+"&QXType="+GetElementValue("QXType")+"&CurRole="+GetElementValue("CurRole");
		url="dhceq.em.disusesimlpe.csp?"+val;	
		 window.location.href= url;
	}
    else
    {
	     messageShow("alert","error","������ʾ","������Ϣ:"+RtnObj.Data);
    }
}

//Modify by zx 2021-05-19 Bug 1897085
function BAppendFile_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var Status=GetElementValue("Status");
	var str='dhceq.plat.appendfile.csp?&CurrentSourceType=34&CurrentSourceID='+RowID+'&Status='+Status+'&ReadOnly=';
	showWindow(str,"��������","","","icon-w-paper","modal","","","large");

}
//Modify by zy 2022-11-07
function BPicture_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var Status=GetElementValue("Status");
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=34&CurrentSourceID='+RowID+'&Status='+Status+'&ReadOnly=';
	showWindow(str,"ͼƬ��Ϣ","","","icon-w-paper","modal","","","middle");
}

