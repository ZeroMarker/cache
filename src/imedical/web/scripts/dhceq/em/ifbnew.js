var editIndex=undefined;
var modifyBeforeRow = {};
var IFBRowID=getElementValue("IFBRowID");
var Columns=getCurColumnsInfo('EM.G.IFB.IFBList','','','')
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-01-10 �������Ч��Ӱ�� bug WY0054
});
function initDocument()
{
	initUserInfo();
    initMessage(); //��ȡ����ҵ����Ϣ     //add by lmm 2019-09-09
    initLookUp(); //��ʼ���Ŵ�
	defindTitleStyle();
    initButton(); //��ť��ʼ��
    initButtonWidth();
    initPage();
    //modified 20191012 by zy �����ֶεĿ�����ȥ��//modfied by wy 20191225
    setRequiredElements("IFBPrjName^IFBNo^IFBOpenDate^IFBDeadlineDate");
    fillData(); //�������
    setEnabled(); //��ť����
    initApproveButtonNew(); //��ʼ��������ť
	$HUI.datagrid("#DHCEQIFB",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSIFB",
	        	QueryName:"IFBBagDetail",
				RowID:getElementValue("IFBRowID"),
				PlanListIDs:getElementValue("PlanListIDs")
		},
	    border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    toolbar:[
		    {
				iconCls: 'icon-add',
	            text:'����',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },'----------',
	        {
	            iconCls: 'icon-remove',
	            text:'ɾ��',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        }
        ],
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		onLoadSuccess:function(){
				creatToolbar();
			}
	});
}

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	var rows = $('#DHCEQIFB').datagrid('getRows');
    var totalIFBBQuantityNum = 0;
    var totalIFBBTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
        var colValue=rows[i]["IFBBQuantity"];
        if (colValue=="") colValue=0;
        totalIFBBQuantityNum += parseFloat(colValue);
        colValue=rows[i]["IFBBAmount"];
        if (colValue=="") colValue=0;
        totalIFBBTotalFee += parseFloat(colValue);
    }
	var lable_innerText='������:'+totalIFBBQuantityNum+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalIFBBTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
	//ͼ��Ӱ��
    for (var i = 0; i < rows.length; i++) 
    {
    	if ((rows[i].IFBBExtendType=="")||(rows[i].IFBBExtendID==""))
	    {
		    $("#IFBBList"+"z"+i).hide()
		}
    }
	//��ť�һ�
	var panel = $("#DHCEQIFB").datagrid("getPanel");	
	var Status=getElementValue("IFBStatus");
	if (Status>0)
	{
		panel.find("#add").hide()
		panel.find("#delete").hide()
		//panel.find("#add").linkbutton("enable",false);
		//panel.find("#delete").linkbutton("enable",false);
	}
}
function initPage() //��ʼ��
{	
		jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
}
function fillData()
{
	var IFBRowID=getElementValue("IFBRowID");
	if (IFBRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("CurRole");
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","GetOneIFB",IFBRowID,ApproveRoleDR,Action,Step)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}
///******************
function setEnabled()
{
	var Status=getElementValue("IFBStatus");
	var Type=getElementValue("Type");
	var ReadOnly=getElementValue("ReadOnly"); //add by wy 2019-9-13 1022200 begin
	if (Status!="0")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		if (Status!="")
		{
			disableElement("BSave",true);
			disableElement("BClear",true);
	        setElement("ReadOnly","1")     //add by wy 2019-12-3 ����1110996 begin
		}
		else
		{
			setElement("ReadOnly","0");
		}   //end 
	}
	if ((Type==1)||(ReadOnly==1))
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BSave",true);
		disableElement("BClear",true);
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="IFBModeDR_IFBMDesc") {setElement("IFBModeDR",rowData.TRowID)}
	else if(elementID=="IFBBuyTypeDR_BTDesc") {setElement("IFBBuyTypeDR",rowData.TRowID)}
	else if(elementID=="IFBAgencyDR_IFBADesc") {setElement("IFBAgencyDR",rowData.TRowID)}
}

//hisui.common.js���������Ҫ
function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}
// ��������
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#DHCEQIFB").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = $("#DHCEQIFB").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var IFBBBagNo = (typeof rows[lastIndex].IFBBBagNo == 'undefined') ? "" : rows[lastIndex].IFBBBagNo;
    var IFBBExtendType = (typeof rows[lastIndex].IFBBExtendType == 'undefined') ? "" : rows[lastIndex].IFBBExtendType;
    var IFBBExtendID = (typeof rows[lastIndex].IFBBExtendID == 'undefined') ? "" : rows[lastIndex].IFBBExtendID;
    if ((IFBBBagNo=="")||(IFBBExtendType=="")||(IFBBExtendID==""))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	}
	else
	{
		jQuery("#DHCEQIFB").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	if (editIndex>"0")
	{
		jQuery("#DHCEQIFB").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	$("#DHCEQIFB").datagrid('deleteRow',editIndex);
	}
    else if(editIndex=="0")
	{
		messageShow("alert",'info',"��ʾ","��ǰ�в���ɾ��!");  //add by wy ����:776577 2018-12-12
	}
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}}
function BSave_Clicked()
{
	if (checkMustItemNull()) return	//add by lmm 2019-09-09
	/*
	if (getElementValue("IFBPrjName")=="")
	{
		messageShow('alert','error','��ʾ',"��Ŀ���Ʋ���Ϊ��!")
		return
	}
	if (getElementValue("IFBNo")=="")
	{
		messageShow('alert','error','��ʾ',"�б��Ų���Ϊ��!")
		return
	}
	if (getElementValue("IFBOpenDate")=="")
	{
		messageShow('alert','error','��ʾ',"�������ڲ���Ϊ��!")
		return
	}
	if (getElementValue("IFBDeadlineDate")=="")
	{
		messageShow('alert','error','��ʾ',"Ͷ���ֹ���ڲ���Ϊ��!")
		return
	}*/
	if(CheckDateTimeCheck()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
    var Listinfo=""
	if (editIndex != undefined){ $('#DHCEQIFB').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQIFB').datagrid('getRows');
	
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		//add by csj 2020-04-10 ����ţ�1266545
		var IFBBItemDR = (typeof oneRow.IFBBItemDR== 'undefined') ? "" : oneRow.IFBBItemDR;
		var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","93","");
		if ((ItemReqFlag==0)&&(IFBBItemDR==""))
		{
			messageShow('alert','error','������ʾ',t[-9250].replace('[RowNo]',i+1)); //"��[RowNo]���豸���Ϊ��!"
			return "-1";
		}
		if ((oneRow.IFBBExtendType_Desc=="")||(oneRow.IFBBExtendID_Name==""))
		{
			messageShow('alert','error','��ʾ',"��"+(i+1)+"�����ݲ���ȷ!");
			return "-1";
		}
		if (oneRow.IFBBBagNo=="")
		{
			messageShow('alert','error','��ʾ',"��"+(i+1)+"��[�б����]����ȷ!");
			return "-1";
		}
        var IFBLVendor = (typeof oneRow.IFBLVendor== 'undefined') ? "" : oneRow.IFBLVendor;  //add by wy 2019-5-29 841877 
		if (IFBLVendor=="")
		{
			messageShow('alert','error','��ʾ',"��"+(i+1)+"��[��Ӧ��]����ȷ!");
			return "-1";
		}
	
	
		if ((oneRow.IFBBQuantity=="")||(IsValidateNumber(oneRow.IFBBQuantity,0,0,0,0)==0))
		{
			messageShow('alert','error','��ʾ',"��"+(i+1)+"��[����]����ȷ!");
			return "-1";
		}
		if ((oneRow.IFBBWinPrice=="")||(IsValidateNumber(oneRow.IFBBWinPrice,0,1,0,1)==0))
		{
			messageShow('alert','error','��ʾ',"��"+(i+1)+"��[����]����ȷ!");
			return "-1";
		}
		if (oneRow.IFBBExtendID!="")
		{
			//add by wy 2019-5-29 865591 begin
			var val="model=IFBBModelDR_MDesc="+oneRow.IFBBModelDR+"^";
			val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
			var list=val.split("^");
			var Detail=list[0].split("=");
			if (oneRow.IFBBModelDR_MDesc!=Detail[1])
			{
				oneRow.IFBBModelDR="";
				//modfied by wy 2019-12-25 ����1142647  begin
				var IFBBItemDR=oneRow.IFBBItemDR; 
			    if (oneRow.IFBBModelDR_MDesc!="")
			    {
			   		var TModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",oneRow.IFBBModelDR_MDesc,IFBBItemDR);
			    
			     }
	            oneRow.IFBBModelDR=TModelDR;  //end
			}
			val="manufacturer=IFBBManuFactoryDR_MFDesc="+oneRow.IFBBManuFactoryDR+"^";
			val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
			list=val.split("^");
			Detail=list[0].split("=");
			if (oneRow.IFBBManuFactoryDR_MFDesc!=Detail[1])
			{
				oneRow.IFBBManuFactoryDR_MFDesc="";
				oneRow.IFBBManuFactoryDR="";
			}  //end
			var RowData=JSON.stringify(rows[i]);
			if (dataList=="")
			{
				dataList=RowData;
			}
			else
			{
				dataList=dataList+"&"+RowData;
			}
		
		}
			if (rows[i].IFBLVendorDR!="")
		{
			var ValList=rows[i];
			var IFBLData={"IFBLRowID":ValList.IFBLRowID};
			IFBLData["IFBLSourceType"]=ValList.IFBBExtendType
			IFBLData["IFBLSourceID"]=ValList.IFBBExtendID
			IFBLData["IFBLVendorDR"]=ValList.IFBLVendorDR
			IFBLData["IFBLVendor"]=ValList.IFBLVendor
			IFBLData["IFBLModelDR"]=ValList.IFBBModelDR
			IFBLData["IFBLModel"]=ValList.IFBBModelDR_MDesc
			IFBLData["IFBLModelDR"]=ValList.IFBBModelDR; 
			IFBLData["IFBLManuFactoryDR"]=ValList.IFBBManuFactoryDR
			IFBLData["IFBLManuFactory"]=ValList.IFBBManuFactoryDR_MFDesc
			IFBLData["IFBLArg"]=ValList.IFBBArg
			IFBLData["IFBLPrice"]=ValList.IFBBWinPrice
            IFBLData["IFBLWinQty"]=ValList.IFBBQuantity
            IFBLData["IFBLAmount"]=ValList.IFBBAmount
			var IFBLData=JSON.stringify(IFBLData);
			if (Listinfo=="")
			{
				Listinfo=IFBLData;
			}
			else
			{
				Listinfo=Listinfo+"&"+IFBLData;
			}
		}
		
	}
	if (dataList=="")
	{
		messageShow('alert','error','��ʾ',"�б���ϸ����Ϊ��!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","SaveData",data,dataList,Listinfo,0);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var Type=getElementValue("Type");
		//modified by zy0197  ���ӹ����ſ���
		//modified by wy 2020-4-18 1280315,1278899  ������ȡֵ��������
		var val="&RowID="+jsonData.Data+"&Type="+Type+"&ManageLocDR="+getElementValue("IFBManageLocDR")
		url="dhceq.em.ifbnew.csp?"+val
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data); ///modified by ZY0212
		return
    }
}

//modified by csj 2020-04-03 �޸�confirm
function BDelete_Clicked()
{
	messageShow("confirm","","","�Ƿ�ɾ��������¼","",truthBeTold,Cancel);
	
}
function truthBeTold()
{
	if (getElementValue("IFBRowID")=="")
	{
		messageShow('alert','error','��ʾ',"û���б�ɾ��!");
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","SaveData",data,"","",1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		//modified by zy0197  ���ӹ����ſ���
		//modified by wy 2020-4-18 1280315,1278899  ������ȡֵ��������
		var val="&Type="+getElementValue("Type")+"&ManageLocDR="+getElementValue("IFBManageLocDR");
		url="dhceq.em.ifbnew.csp?"+val
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.SQLCODE);
		return
    }
}
function Cancel()
{
	return
}
function BSubmit_Clicked()
{
	if (getElementValue("IFBRowID")=="")
	{
		messageShow('alert','error','��ʾ',"û���б���Ϣ�ύ!");
		return;
	}
	var combindata=getValueList();
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","SubmitData",combindata);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		//modified by zy0197  ���ӹ����ſ���
		//modified by wy 2020-4-18 1280315,1278899  ������ȡֵ��������
		url="dhceq.em.ifbnew.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ManageLocDR="+getElementValue("IFBManageLocDR");
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data); ///modified by ZY0212
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (getElementValue("IFBRowID")=="")
	{
		messageShow('alert','error','��ʾ',"û���б���Ϣȡ��!");
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
		var Status=getElementValue("IBFStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var Type=1;
		var QXType=getElementValue("QXType");
		var ApproveRole=getElementValue("ApproveRole");
		//modified by zy0197  ���ӹ����ſ���
		//modified by wy 2020-4-18 1280315,1278899  ������ȡֵ��������
		var val="&RowID="+getElementValue("IFBRowID")+"&Status="+Status+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType+"&ApproveRole="+ApproveRole+"&ManageLocDR="+getElementValue("IFBManageLocDR");
		url="dhceq.em.ifbnew.csp?"+val
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
  	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","AuditData",combindata,CurRole,RoleStep,"");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
		var Status=getElementValue("IBFStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var ApproveRole=getElementValue("CurRole");
		//modified by zy0197  ���ӹ����ſ���
		//modified by wy 2020-4-18 1280315,1278899  ������ȡֵ��������
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&ApproveRole="+ApproveRole+"&ManageLocDR="+getElementValue("IFBManageLocDR");
		url="dhceq.em.ifbnew.csp?"+val
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function getValueList()
{
	var combindata="";
  	combindata=IFBRowID;
	combindata=combindata+"^"+session['LOGON.USERID'];
	combindata=combindata+"^"+getElementValue("CancelToFlowDR");
	combindata=combindata+"^"+getElementValue("ApproveSetDR");
	return combindata;
}

function onClickRow(index)
{
	var Status=getElementValue("IFBStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQIFB').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQIFB').datagrid('getRows')[editIndex]);
			bindGridEvent(); //�༭�м�����Ӧ
		} else {
			$('#DHCEQIFB').datagrid('selectRow', editIndex);
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
	if ($('#DHCEQIFB').datagrid('validateRow', editIndex))
	{
		$('#DHCEQIFB').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function GetExtendType(index,data)
{
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
	setElement("IFBBExtendType",data.TRowID);
	setElement("IFBBExtendType_Desc",data.TDesc);
	rowData.IFBBExtendType=data.TRowID;
	rowData.IBFExtendType_Desc=data.TDesc;
	//������Դ����ˢ����Դ���ݼ�
    //modifed by wy 2018-12-24 783404
    var ExtendIDEdt = $("#DHCEQIFB").datagrid('getEditor', {index:editIndex,field:'IFBBExtendType_Desc'});
	$(ExtendIDEdt.target).combogrid("setValue",data.TDesc);
	$('#DHCEQIFB').datagrid('endEdit',editIndex);
	$('#DHCEQIFB').datagrid('beginEdit',editIndex);// add by wy 2020-01-10  bug WY0054

}
function GetExtendID(index,data)
{
	setElement("EQItemDR",data.TItemDR) //add by wl 2019-11-27 WL0017 ���͹������ 
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
	//rowData.IFBBExtendType=getElementValue("IFBBExtendType");
	rowData.IFBBExtendID=data.TExtendID;
	rowData.IFBBItemDR=data.TItemDR;
	//modified by wy 2020-4-17 ��Դ���豸��Ϊ��ʱ�б��豸�ֵΪ��1280346
	if (data.TItemDR!=""){
	rowData.IFBBItemDR_MIDesc=data.TName; //modfied by wy 20191225
	}
	else{
	rowData.IFBBItemDR_MIDesc=""
		}
	rowData.IFBBModelDR=data.TModelDR;
	rowData.IFBBModelDR_MDesc=data.TModel;
	rowData.IFBBManuFactoryDR=data.TManuFcDR
	rowData.IFBBManuFactoryDR_MFDesc=data.TManuFc
	rowData.IFBBWinPrice=data.TPriceFee;
	rowData.IFBBQuantity=data.TQuantityNum;
	rowData.IFBBAmount=data.TTotalFee;
	rowData.IFBBUnitDR=data.TUnitDR;
	rowData.IFBBUnitDR_UOMDesc=data.TUnit;
	rowData.IFBBHold1=data.TName;
	var objGrid = $("#DHCEQIFB");        // ������
	var ExtendTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBExtendType_Desc'}); // �豸����
	$(ExtendTypeDescEdt.target).combogrid("setValue",getElementValue("IFBBExtendType_Desc"));
	var ExtendNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBExtend_Name'}); // �豸����
	$(ExtendNameEdt.target).combogrid("setValue",data.TName);
	var ModelDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBModelDR_MDesc'}); // 
	$(ModelDescEdt.target).combogrid("setValue",data.TModel);
	/*var UOMDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBUnitDR_UOMDesc'}); // 
	$(UOMDescEdt.target).val(data.TUnit);*/
	var ManuFactoryDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBManuFactoryDR_MFDesc'}); // 
	$(ManuFactoryDescEdt.target).combogrid("setValue",data.TManuFac);
	
	var QuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBQuantity'}); // 
	$(QuantityEdt.target).val(data.TQuantityNum);
	var WinPriceEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBWinPrice'}); // 
	$(WinPriceEdt.target).val(data.TPriceFee);
	/*var AmountEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBAmount'}); // 
	$(AmountEdt.target).val(data.TTotalFee);*/
	//modified by wy 2020-4-17 ��Դ���豸��Ϊ��ʱ�б��豸�ֵΪ��1280346
	var ItemDRMIDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBItemDR_MIDesc'}); //add by wy 2020-4-16 bug WY0062 
	if (data.TItemDR==""){
	$(ItemDRMIDescEdt.target).combogrid("setValue","");
	}
	else{
			$(ItemDRMIDescEdt.target).combogrid("setValue",data.TName);
		}
	$('#DHCEQIFB').datagrid('endEdit',editIndex);
}
function GetModel(index,data)
{
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
    rowData.IFBBModelDR=data.TRowID;
	var ModelDescEdt = $('#DHCEQIFB').datagrid('getEditor', {index:editIndex,field:'IFBBModelDR_MDesc'}); // 
	$(ModelDescEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQIFB').datagrid('endEdit',editIndex);
}
function GetManuFacturer(index,data)
{
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
    rowData.IFBBManuFactoryDR=data.TRowID;
	var ManuFactoryDescEdt = $('#DHCEQIFB').datagrid('getEditor', {index:editIndex,field:'IFBBManuFactoryDR_MFDesc'}); // 
	$(ManuFactoryDescEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQIFB').datagrid('endEdit',editIndex);
}
function GetVendor(index,data)
{
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
    rowData.IFBLVendorDR=data.TRowID;
	var IFBLVendorEdt = $("#DHCEQIFB").datagrid('getEditor', {index:editIndex,field:'IFBLVendor'}); // 
	$(IFBLVendorEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQIFB').datagrid('endEdit',editIndex);
}

function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQIFB");		// ������
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBQuantity'});	// ����
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBWinPrice'});
		setElement("EQItemDR",$("#DHCEQIFB").datagrid('getSelected').IFBBItemDR) //add by wl 2019-11-27 WL0018
        // ����  �� �뿪�¼�
        $(invQuantityEdt.target).bind("blur",function(){
            // ���������������� ���
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQIFB').datagrid('getSelected');
			rowData.IFBBAmount=quantityNum*originalFee; //add by zx 2019-09-11
			//$('#DHCEQIFB').datagrid('endEdit',editIndex);
        });
        //add by zx 2019-09-11
        $(invPriceFeeEdt.target).bind("blur",function(){
            // ���������������� ���
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQIFB').datagrid('getSelected');
			rowData.IFBBAmount=quantityNum*originalFee;
			//$('#DHCEQIFB').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        messageShow('','','',e);	//modified by csj 2020-04-03 alert�޸�
    }   
}
function CheckDateTimeCheck()  
{
	var OpenDate = new Date(FormatDate(getElementValue("IFBOpenDate")).replace(/\-/g, "\/"))     //modified by wy ����782084
	var DeadlineDate=new Date(FormatDate(getElementValue("IFBDeadlineDate")).replace(/\-/g, "\/"))
	if (OpenDate<DeadlineDate)    ////modfied by wy 2019-12-3 Ͷ���������Ҫ���ڿ�������
	{
		messageShow('alert','error','��ʾ',"�������ڲ������ڿ�������");
		return true
	}
	var BuyFileFromDate=new Date(FormatDate(getElementValue("IFBBuyFileFromDate")).replace(/\-/g, "\/"));
	var BuyFileToDate=new Date(FormatDate(getElementValue("IFBBuyFileToDate")).replace(/\-/g, "\/"))
	if ((""!=BuyFileFromDate)&&(""!=BuyFileToDate))
	{
		if (BuyFileFromDate>BuyFileToDate)
		{
			messageShow('alert','error','��ʾ',"������鿪ʼ���ڲ������ڹ�������������");
			return true
		}
	}
	return false
	}
	
function BupdateIFBBList(index)
{
	var rowData=$("#DHCEQIFB").datagrid("getRows")[index];
	var IFBBRowID=rowData.IFBBRowID;
	var IFBBExtendType=rowData.IFBBExtendType
	var IFBBExtendID=rowData.IFBBExtendID;
	if ((IFBBExtendType=="")||(IFBBExtendID==""))
	{
		messageShow('alert','error','��ʾ',"����ѡ����Դ�豸!");
		return;
	}
	var IFBLVendorDR=rowData.IFBLVendorDR
	if (IFBLVendorDR=="")
	{
		messageShow('alert','error','��ʾ',"��Ӧ�̲���Ϊ��!");
		return;
	}
	if (IFBRowID=="")
	{
		messageShow('alert','error','��ʾ',"���ȱ��浥��!");
		return;
	}
	var url="dhceq.em.ifblist.csp?";
	url=url+"&IFBBRowID="+IFBBRowID;
	url=url+"&SourceType="+IFBBExtendType;
	url=url+"&SourceID="+IFBBExtendID;
	url=url+"&ReadOnly="+getElementValue("ReadOnly")  //modfied by wy 2019-12-3 ����1110996 
	showWindow(url,"Ӧ�깩Ӧ��","","","icon-w-paper","modal","","","","large"); //modify by lmm 2020-06-05 UI

}

//add by ZY0212 �豸��
function GetMasterItem(index,data)
{
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
	rowData.IFBBItemDR=data.TRowID;
	var editor =$('#DHCEQIFB').datagrid('getEditor',{index:editIndex,field:'IFBBItemDR_MIDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQIFB').datagrid('endEdit',editIndex);
	var rows = $('#DHCEQIFB').datagrid('getRows');
}