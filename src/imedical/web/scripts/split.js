///�豸���
///Add By czf 2014955 2021-07-04
var editIndex=undefined;
var modifyBeforeRow = {};
var SRowID=getElementValue("SRowID");
var Columns=getCurColumnsInfo('EM.G.Split.SplitList','','','')
var objtbl=$('#tDHCEQSplitList');
var delRow=[];

$(function(){
	initDocument();	
});
function initDocument()
{
	initUserInfo();
    initMessage("");
    initLookUp();
    //initCheckBox();
    var paramsFrom=[{"name":"Equip","type":"1","value":"SEquipDR_EQName"},{"name":"VUseLoc","type":"4","value":"SLocDR"},{"name":"VEquipTypeDR","type":"4","value":"SEquipTypeDR"}];
    singlelookup("SEquipDR_EQName","EM.L.Equip",paramsFrom,GetShortEquip);
	defindTitleStyle();
    initButton();
    initButtonWidth();
    initPage();
    setRequiredElements("SEquipDR_EQName^SReason");
    fillData(); 
    setEnabled();
    initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"));
    initApproveButtonNew(); //��ʼ��������ť
    initDataGrid();	
}

function initDataGrid()
{
	var SplitListGrid=$HUI.datagrid("#tDHCEQSplitList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSSplit",
	        	QueryName:"GetSplitList",
				RowID:SRowID
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
	        }, 
	        {
	            iconCls: 'icon-cancel',	
	            text:'ɾ��',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        }
        ],
        onClickRow:onClickRow,
	    columns:Columns,
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[30,50,100],
		onLoadSuccess:function(){
			creatToolbar();
		}
	});
}

///CheckBoxѡ���¼�
function initCheckBox()
{
	$("#SIsKeep").checkbox({
	    onCheckChange:function(){
			if(this.checked){
				
			}
			else{
				
			}
		}
	})
}

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	var lable_innerText='�ܽ��:'+getElementValue("SLListTotalFee")+'&nbsp;&nbsp;&nbsp;���ۼ��۾�:'+getElementValue("SLListTotalDepreFee");
	$("#sumTotal").html(lable_innerText);
	var panel = objtbl.datagrid("getPanel");	
	var Status=getElementValue("SStatus");
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
	}
	if (Status==1)	//�ύ״̬Ĭ�ϴ������б༭��
	{
		var rows = objtbl.datagrid('getRows');
		if(rows.length>0) onClickRow(0);
	}
}
//��ͨ�ð�ť��ʼ��
function initPage() 
{	
	if (jQuery("#showOpinion").length>0)
	{
		jQuery("#showOpinion").on("click", BShowOpinion_Clicked);
	}
}

function fillData()
{
	if (SRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","GetOneSplit",SRowID,ApproveRoleDR,Action,Step)
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	var ApproveListInfo=tkMakeServerCall("web.DHCEQApproveList","GetApproveByRource","36",SRowID)
	FillEditOpinion(ApproveListInfo,"EditOpinion")
}

function setEnabled()
{
	var Status=getElementValue("SStatus");
	var Type=getElementValue("Type");
	var ReadOnly=getElementValue("ReadOnly");
	if (Status!="0")
	{
		setElement("ReadOnly","1");
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		if (Status!="")
		{
			disableElement("SEquipDR_EQName",true);
			disableElement("BSave",true);
			disableElement("BClear",true);
		}
		else
		{
			setElement("ReadOnly","0");
			$("#cEditOpinion")[0].parentNode.parentNode.remove();//add by cjc ui���� ��dom����ɾ���ڵ�
			document.getElementById("SLTable").style.height = "auto";
			document.getElementById("SLTableTitle").style.height = "auto";
			hiddenObj("showOpinion",1)
			hiddenObj("cEditOpinion",1)
			hiddenObj("EditOpinion",1)
			hiddenObj("cRejectReason",1)
			hiddenObj("RejectReason",1)
		}
	}
	else{
		$("#cEditOpinion")[0].parentNode.parentNode.remove();//add by cjc ui���� ��dom����ɾ���ڵ�
		document.getElementBy("SLTable").style.height = "auto";
		document.getElementById("SLTableTitle").style.height = "auto";
		hiddenObj("showOpinion",1)
		hiddenObj("cEditOpinion",1)
		hiddenObj("EditOpinion",1)
		hiddenObj("cRejectReason",1)
		hiddenObj("RejectReason",1)
	}
	if (Type==1)
	{
		setElement("ReadOnly","1");
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BClear",true);
		disableElement("BPrint",true);
	}
	if(ReadOnly==1)	
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BClear",true);
		disableElement("BPrint",true);
	}
	/*
	//���¼������߶�
	var eqtableHeight=$("#SLTable>.eq-table").height()
	var northHeight=$("#SLTable").height()
	var offset=northHeight-eqtableHeight
	$("#SLTable").height($("#SLTable>.eq-table").height())
	$("#SLGrid").parent().css({"top":$("#SLGrid").parent().position().top-offset})
	$("#SLGrid").height($("#SLGrid").height()+offset)
	$("#SLGrid .panel-body").height($("#SLGrid .panel-body").height()+offset)
	$("#SLGrid .datagrid-wrap").height($("#SLGrid .datagrid-wrap").height()+offset)
	*/
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID.split("_")[0],rowData.TRowID);
}

function clearData(elementID)
{
	setElement(elementID.split("_")[0],'');
	if (elementID=="SEquipDR_EQName") ClearEquip();
	return;
}

function ClearEquip()
{
	setElement("SEquipDR","");
	setElement("EquipNo","");
	setElement("SLocDR_DeptDesc","");
	setElement("SLocDR","");
	setElement("SOriginalFee","");
	setElement("SDepreTotalFee","");
	setElement("SNetFee",""); 
	setElement("SEquipTypeDR_ETDesc","");
	setElement("SEquipTypeDR","");
	setElement("SStatCatDR_SCDesc","");
	setElement("SStatCatDR","");
	setElement("SEquipCatDR_ECDesc","");
	setElement("SEquipCatDR","");
	setElement("SOriginDR_ODesc","");
	setElement("SOriginDR","");
	setElement("STransAssetDate","");
	setElement("SStartDate","");
	setElement("SProviderDR_VName","");
	setElement("SProviderDR","");
	setElement("SManuFactoryDR_VName","");
	setElement("SManuFactoryDR","");
	setElement("SModelDR_MDesc","");
	setElement("SModelDR","");
	setElement("SLimitYearsNum","");
	setElement("SDepreMethodDR_DMDesc","");
	setElement("SDepreMethodDR","");
	setElement("LeaveFactoryNo","");
	setElement("SSplitOriginalFee","");
	setElement("SSplitDepreTotalFee","");
	setElement("SSplitNetFee","");
}

// ��������
function insertRow()
{
	if(editIndex>="0"){
		objtbl.datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = objtbl.datagrid('getRows');
    var newIndex=rows.length; 
    if(GetTableInfo()=="-1")
    {
	    return
	}
	else
	{
		objtbl.datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	if (editIndex != undefined)
	{
		if(objtbl.datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"��ʾ",t[-9242]);	//��ǰ�в���ɾ��
			return
		}
		objtbl.datagrid('endEdit', editIndex);	//�����༭������֮ǰ�༭����
		var SLRowID=objtbl.datagrid('getRows')[editIndex].SLRowID;
		delRow.push(SLRowID);
		objtbl.datagrid('deleteRow',editIndex);
		ChangeTotal()
	}
	else
	{
		messageShow("alert",'info',"��ʾ",t[-9243]);	//��ѡ��һ��
	}
	
}

function BClear_Clicked()
{
	var url='dhceq.em.split.csp?QXType=&Type=0&WaitAD=off';
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}

function BSave_Clicked()
{
    ChangeTotal();
    if (checkMustItemNull()) return;
    if (CheckSplitNumber()) return;
	var combindata=JSON.stringify(getInputList());
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
  	var DelRowid=delRow.join(',');
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","SaveData",combindata,valList,DelRowid,curUserID);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','success','��ʾ',t[0]);
		var url='dhceq.em.split.csp?WaitAD=off&RowID='+jsonData.Data+"&Type="+getElementValue("Type");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	else
	{
		messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
	}

}

function BDelete_Clicked()
{
	messageShow("confirm","","",t[-9203],"",truthBeTold,Cancel);
	
	function truthBeTold(){
		var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSSplit","DeleteData",SRowID,curUserID);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
			return;
	    }
	    else
	    {
		    var url="dhceq.em.split.csp?WaitAD=off&Type="+getElementValue("Type");
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
		    window.location.href= url;
		}

	}
	
	function Cancel(){
		return;
	}	

}

function BSubmit_Clicked()
{
	if (SRowID=="")
	{
		messageShow('alert','alert','��ʾ',"û�����뵥�ύ!");
		return;
	}
	if (checkMustItemNull()) return;
	if ((+getElementValue("SSplitOriginalFee")==0)&&(getElementValue("SIsKeep"))) {
		messageShow("confirm","","","���豸ԭֵΪ0���Ա������豸��","",function(){
			setElement("SIsKeep","true");
			SubmitOper();
		},function(){
			setElement("SIsKeep","false");
			SubmitOper();
		},"��","��");
	}
	else {
		SubmitOper();
	}
}

function SubmitOper()
{
	var JsonObj=getInputList();
	var combindata=JSON.stringify(JsonObj);
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
	var DelRowid=delRow.join(',');
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","SaveData",combindata,valList,DelRowid,curUserID);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		combindata=GetAuditData();
		jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","SubmitData",combindata);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
	    {
		    var WaitAD=getElementValue("WaitAD");
			var QXType=getElementValue("QXType");
			var Action=getElementValue("Action");
			var RoleStep=getElementValue("RoleStep");
			var val="&RowID="+jsonData.Data+"&ReadOnly=1&WaitAD="+WaitAD+"&QXType="+QXType+"&Action="+Action+"&RoleStep="+RoleStep;
		    var url='dhceq.em.split.csp?'+val;
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
		    window.location.href=url;
		}
	    else
	    {
		    messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
			return
	    }

	}
	else
	{
		messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
	}
}

function BCancelSubmit_Clicked()
{
	if (SRowID=="")
	{
		messageShow('alert','alert','��ʾ',"û�����뵥ȡ��!");
		return;
	}
	if (getElementValue("RejectReason")=="")
	{
		setFocus("RejectReason");
		messageShow('alert','error','��ʾ',t[-9234])	//"�ܾ�ԭ����Ϊ��!"
		return
	}
	var combindata=GetAuditData();
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","CancelSubmitData",combindata,getElementValue("CurRole"));
	jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
	    var WaitAD=1;
		var QXType=getElementValue("QXType");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Action="+Action+"&RoleStep="+RoleStep+"&ReadOnly=1";
	    var url='dhceq.em.split.csp?'+val;
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
    }
    else
    {
		messageShow("","","",t[-9200]+jsonData.Data)
    }
}
	
function BApprove_Clicked()
{
	if (SRowID=="")
	{
		messageShow('alert','alert','��ʾ',"û�����뵥���!");
		return;
	}
	if (checkMustItemNull("")) return
	var CurRole=getElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep");
  	if (RoleStep=="") return;
	var Action=getElementValue("Action");
	var combindata=GetAuditData();
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo);
    var jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Action="+Action+"&RoleStep="+RoleStep;
		url="dhceq.em.split.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
    else
    {
	    messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
		return;
    }
}

function NumFormat(Num)
{
	if (Num=="") return 0;
	else{ return parseFloat(Num);}
}

//��ȡ�б���ϸ
function GetTableInfo()
{
	var valList="";
	if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = "";
	var TotalOriginalFee=0;
	var TotalDepreFee=0;
	var TotalNetFee=0;
	for (var i = 0; i < rows.length; i++) 
	{
		TotalOriginalFee += NumFormat(NumFormat(rows[i].SLOriginalFee)*NumFormat(rows[i].SLQuantityNum));
		TotalDepreFee += NumFormat(NumFormat(rows[i].SLDepreTotalFee)*NumFormat(rows[i].SLQuantityNum));
		TotalNetFee += NumFormat(NumFormat(rows[i].SLNetFee)*NumFormat(rows[i].SLQuantityNum));
		
		RowNo=i+1;
		var SLRow=(typeof rows[i].SLRow == 'undefined') ? "" : rows[i].SLRow
		var SLRowID=(typeof rows[i].SLRowID == 'undefined') ? "" : rows[i].SLRowID
		var SLEquipName=(typeof rows[i].SLEquipName == 'undefined') ? "" : rows[i].SLEquipName
		var SLQuantityNum=(typeof rows[i].SLQuantityNum == 'undefined') ? "" : rows[i].SLQuantityNum
		if(SLEquipName=="")
		{
			messageShow('alert','error','��ʾ',t[-9251].replace('[RowNo]',RowNo))	//"��[RowNo]���豸���Ʋ���Ϊ��!"
			return -1
		}
		if(!IsValidateNumber(SLQuantityNum,0,0,0,0))
		{
			messageShow('alert','error','��ʾ',"��"+RowNo+"�������ǼǴ���!")	//"��[RowNo]�������ǼǴ���
			return -1
		}
		var SLItemDR=(typeof rows[i].SLItemDR == 'undefined') ? "" : rows[i].SLItemDR
		if(SLItemDR!="")
		{
		    var SLModel=(typeof rows[i].SLModelDR_MDesc == 'undefined') ? "" : rows[i].SLModelDR_MDesc
			if (SLModel!="")
			{
				var RModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",SLModel,SLItemDR)
			    if (RModelDR<=0)
			    {
				    messageShow("","","",t[-9247].replace('[RowNo]',RowNo))	//"��[RowNo]�й���ͺŵǼǴ���!"
				    return -1
			    }
			    else
			    {
				    rows[i].SLModelDR=RModelDR;
			    }
			}
			else
			{
				rows[i].SLModelDR=""
			}
		}
		else
		{
			messageShow('alert','error','������ʾ',t[-9250].replace('[RowNo]',RowNo));	//"��[RowNo]���豸���Ϊ��!"
			return -1
		}
		for(var j=i+1;j<rows.length;j++){
			if ((rows[i].SLEquipName==rows[j].SLEquipName)&&(rows[i].SLModelDR==rows[j].SLModelDR))
			{
				messageShow('alert','error','��ʾ',t[-9249].replace('[RowNoi]',RowNo).replace('[RowNoj]',j+1))	//'��[RowNoi]�����[RowNoj]���ظ�!'
				return -1;
			}
		}
		var SLManuFactory=(typeof rows[i].SLManuFactoryDR_VName == 'undefined') ? "" : rows[i].SLManuFactoryDR_VName
		if (SLManuFactory!="")
		{
			var RManuFactoryDR=tkMakeServerCall("web.DHCEQForTrak","UpdProvider","^"+SLManuFactory+"^^^3")
		    if (RManuFactoryDR<=0)
		    {
			    messageShow("","","","��["+RowNo+"]���������̵ǼǴ���!")
			    return -1
		    }
		    else
		    {
			    rows[i].SLManuFactoryDR=RManuFactoryDR;
		    }
		}
		else
		{
			rows[i].SLManuFactoryDR=""
		}
		var SLLocation=(typeof rows[i].SLLocationDR_LDesc == 'undefined') ? "" : rows[i].SLLocationDR_LDesc
		if (SLLocation!="")
		{
			var RLocationDR=tkMakeServerCall("web.DHCEQCLocation","UpdLocation","^"+SLLocation)
		    if (RLocationDR<=0)
		    {
			    messageShow("","","","��"+RowNo+"�д�ŵص�ǼǴ���!")
			    return -1
		    }
		    else
		    {
			    rows[i].SLLocationDR=RLocationDR;
		    }
		}
		else
		{
			rows[i].SLLocationDR=""
		}
		if (CheckInvalidData(i)) return -1;
		rows[i]["SLIndex"]=i;
		var RowData=JSON.stringify(rows[i]);
		if (valList=="")
		{
			valList=RowData;
		}
		else
		{
			valList=valList+getElementValue("SplitRowCode")+RowData;
		}
	}
	var SSpliOriginalFee=NumFormat(getElementValue("SSplitOriginalFee"));
	var SOriginalFee=NumFormat(getElementValue("SOriginalFee"));
	if ((NumFormat(TotalOriginalFee.toFixed(2))*100+NumFormat(SSpliOriginalFee.toFixed(2))*100)/100!=NumFormat(SOriginalFee.toFixed(2)))
	{
		messageShow('alert','error','��ʾ',"��ϸԭֵ����ԭֵ֮�������豸���ǰԭֵ��һ��!");
		return -1;
	}
	var SSplitDepreTotalFee=NumFormat(getElementValue("SSplitDepreTotalFee"));
	var SDepreTotalFee=NumFormat(getElementValue("SDepreTotalFee"));
	if ((NumFormat(TotalDepreFee.toFixed(2))*100+NumFormat(SSplitDepreTotalFee.toFixed(2))*100)/100!=NumFormat(SDepreTotalFee.toFixed(2)))
	{
		messageShow('alert','error','��ʾ',"��ϸ�ۼ��۾������ۼ��۾�֮�������豸���ǰ�ۼ��۾ɲ�һ��!");
		return -1;
	}
	var SSplitNetFee=NumFormat(getElementValue("SSplitNetFee"));
	var SNetFee=NumFormat(getElementValue("SNetFee"));
	if (AddOper(TotalNetFee,SSplitNetFee)!=NumFormat(SNetFee.toFixed(2)))
	{
		messageShow('alert','error','��ʾ',"��ϸ��ֵ����ֵ֮�������豸���ǰ��ֵ��һ��!");
		return -1;
	}
	if (valList=="")
	{
		messageShow('alert','error','��ʾ',t[-9248]);	//"�б���ϸ����Ϊ��!"
		return -1;
	}
	return valList;
}

function AddOper(Num1,Num2)
{
	Num1=(NumFormat(Num1.toFixed(2))*100)/100
	Num2=(NumFormat(Num2.toFixed(2))*100)/100
	var AddNum=Num1+Num2
	AddNum=((NumFormat(AddNum.toFixed(2))*100))/100
	return AddNum
}

function GetAuditData()
{
	var ValueList="";
	ValueList=SRowID+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EditOpinion");
  	ValueList=ValueList+"^"+getElementValue("OpinionRemark");
	ValueList=ValueList+"^"+getElementValue("RejectReason");
	ValueList=ValueList+"^"+getElementValue("RoleStep");
	ValueList=ValueList+"^"+getElementValue("ActionID");
	return ValueList;
}

function onClickRow(index)
{
	var Status=getElementValue("SStatus");
	
	if (Status>0 && setListEditable(objtbl)==-1) return	//�����Ƿ��б�ɱ༭�ֶι�������
	if (editIndex!=index)
	{
		if (endEditing())
		{
			objtbl.datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},objtbl.datagrid('getRows')[editIndex]);
			bindGridEvent(); //�༭�м�����Ӧ
		} else {
			objtbl.datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
	ChangeTotal();
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if (objtbl.datagrid('validateRow', editIndex))
	{
		objtbl.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function GetShortEquip(item)
{
	var RtnInfo=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CheckEquipDR","5",getElementValue("SRowID"),item.TRowID,"","","Y");
  	if (RtnInfo.split("^")[0]!=0)
  	{
	  	messageShow('alert','alert','��ʾ',RtnInfo.split("^")[1]);
	  	return
	}
	setElement("SEquipDR_EQName",item.TName);
	setElement("SEquipDR",item.TRowID);
	setElement("EquipNo",item.TNo);
	setElement("SLocDR_DeptDesc",item.TStoreLoc);
	setElement("SLocDR",item.TStoreLocDR);
	setElement("SOriginalFee",item.TOriginalFee);
	setElement("SDepreTotalFee",item.TDepreTotalFee);
	setElement("SNetFee",item.TNetFee); 
	setElement("SEquipTypeDR_ETDesc",item.TEquipType);
	setElement("SEquipTypeDR",item.TEquipTypeDR);
	setElement("SStatCatDR_SCDesc",item.TStatCat);
	setElement("SStatCatDR",item.TStatCatDR);
	setElement("SEquipCatDR_ECDesc",item.TEquipCat);
	setElement("SEquipCatDR",item.TEquipCatDR);
	setElement("SOriginDR_ODesc",item.TOrigin);
	setElement("SOriginDR",item.TOriginDR);
	setElement("STransAssetDate",item.TTransAssetDate);
	setElement("SStartDate",item.TStartDate);
	setElement("SProviderDR_VName",item.TProvider);
	setElement("SProviderDR",item.TProviderDR);
	setElement("SManuFactoryDR_VName",item.TManuFactory);
	setElement("SManuFactoryDR",item.TManuFactoryDR);
	setElement("SModelDR_MDesc",item.TModel);
	setElement("SModelDR",item.TModelDR);
	setElement("SLimitYearsNum",item.TLimitYearsNum);
	setElement("SDepreMethodDR_DMDesc",item.TDepreMethod);
	setElement("SDepreMethodDR",item.TDepreMethodDR);
	setElement("LeaveFactoryNo",item.TLeaveFactoryNo);
	setElement("SSplitOriginalFee",item.TOriginalFee);
	setElement("SSplitDepreTotalFee",item.TDepreTotalFee);
	setElement("SSplitNetFee",item.TNetFee);
}

function GetMasterItem(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
	rowData.SLItemDR=data.TRowID;
	setElement("EQItemDR",data.TRowID);		//���͹���
	var ItemEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLItemDR_MIDesc'}); 
	$(ItemEdt.target).combogrid("setValue",data.TName);
	var SLEquipNameEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLEquipName'}); 
	$(SLEquipNameEdt.target).val(data.TName);
	rowData.SLEquipCatDR=data.TCatDR;	//��ϸ�豸��������豸��ȡֵ
	rowData.SLDepreMethodDR=data.TDepreMethodDR;	//�۾ɷ���
	var SLDepreMethodEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLDepreMethodDR_DMDesc'}); 
	$(SLDepreMethodEdt.target).combogrid("setValue",data.TDepreMethod);
	var SLLimitYearsNumEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLLimitYearsNum'}); 
	$(SLLimitYearsNumEdt.target).val(data.TLimitYearsNum);	//�۾�����
	objtbl.datagrid('endEdit',editIndex);
	//objtbl.datagrid('beginEdit',editIndex);
}

function GetModel(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.SLModelDR=data.TRowID;
	var ModelDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLModelDR_MDesc'}); 
	$(ModelDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetManuFacturer(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.SLManuFactoryDR=data.TRowID;
	var ManuFactoryDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLManuFactoryDR_VName'}); 
	$(ManuFactoryDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetLocation(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.SLLocationDR=data.TRowID;
	var LocationEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLLocationDR_LDesc'}); 
	$(LocationEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetDepreMethod(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.SLDepreMethodDR=data.TRowID;
	var DepreMethodEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLDepreMethodDR_DMDesc'}); 
	$(DepreMethodEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
		var Index=editIndex;
        var invOriginalFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLOriginalFee'});
        var invDepreFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'SLDepreTotalFee'});        
        var invQuantityNum = objtbl.datagrid('getEditor', {index:editIndex,field:'SLQuantityNum'});
        setElement("EQItemDR",objtbl.datagrid('getSelected').SLItemDR)		//���͹���
        
        if(invOriginalFeeEdt){
	        $(invOriginalFeeEdt.target).bind("blur",function(){
	            var OriginalFee=NumFormat($(invOriginalFeeEdt.target).val());
	            var DepreFee=NumFormat($(invDepreFeeEdt.target).val());
	            var QuantityNum=NumFormat($(invQuantityNum.target).val());
	            if (QuantityNum=="") QuantityNum=0;
	            
	            var rowData = objtbl.datagrid('getSelected');
				rowData.SLNetFee=NumFormat(OriginalFee-DepreFee);
				objtbl.datagrid('endEdit',editIndex);
				if (IsValidateNumber(OriginalFee,1,1,0,1)==0)
				{
					messageShow('alert','error','��ʾ',"���ԭֵ����ȷ�����޸�ԭֵ!");
					return
				}
				if (IsValidateNumber(OriginalFee-DepreFee,1,1,0,1)==0)
				{
					messageShow('alert','error','��ʾ',"���ֵ����ȷ�����޸�ԭֵ!");
					return
				}
        	});
	    }
        if(invDepreFeeEdt){
	        $(invDepreFeeEdt.target).bind("blur",function(){
		        var OriginalFee=NumFormat($(invOriginalFeeEdt.target).val());
	            var DepreFee=NumFormat($(invDepreFeeEdt.target).val());
	            var QuantityNum=NumFormat($(invQuantityNum.target).val());
	            if (QuantityNum=="") QuantityNum=0;
	            var rowData = objtbl.datagrid('getSelected');
				rowData.SLNetFee=NumFormat(OriginalFee-DepreFee);
				objtbl.datagrid('endEdit',editIndex);
				if (IsValidateNumber(DepreFee,1,1,0,1)==0)
				{
					messageShow('alert','error','��ʾ',"����ۼ��۾ɲ���ȷ�����޸��ۼ��۾�!");
					return
				}
				if (IsValidateNumber(OriginalFee-DepreFee,1,1,0,1)==0)
				{
					messageShow('alert','error','��ʾ',"���ֵ����ȷ�����޸��ۼ��۾�!");
					return
				}
        	});
	    }
    }
    catch(e)
    {
        messageShow("","","",e);
    }   
}

function ChangeTotal()
{
	var rows = objtbl.datagrid('getRows');
    var totalTotalFee = 0;
	var totalDepreDee = 0;
    for (var i = 0; i < rows.length; i++)
    {
	    var colQuantityNum=rows[i]["SLQuantityNum"];
        var colPrice=rows[i]["SLOriginalFee"];
        if (isNaN(colPrice)) colPrice=0;
        totalTotalFee += NumFormat(NumFormat(+colPrice)*NumFormat(+colQuantityNum));
        
        var colDepreValue=rows[i]["SLDepreTotalFee"];
        if (isNaN(colDepreValue)) colDepreValue=0;
        totalDepreDee += NumFormat(NumFormat(+colDepreValue)*NumFormat(+colQuantityNum));
    }
    var lable_innerText='�����ԭֵ:'+totalTotalFee.toFixed(2)+'&nbsp;&nbsp;&nbsp;������ۼ��۾�:'+totalDepreDee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
	var SOriginalFee=NumFormat(getElementValue("SOriginalFee"));
	var SDepreTotalFee=NumFormat(getElementValue("SDepreTotalFee"));
	var SNetFee=NumFormat(getElementValue("SNetFee"));
	setElement("SSplitOriginalFee",SOriginalFee-totalTotalFee);
	setElement("SSplitDepreTotalFee",SDepreTotalFee-totalDepreDee);
	setElement("SSplitNetFee",(SOriginalFee-totalTotalFee)-(SDepreTotalFee-totalDepreDee));
}

/// ����:�ѵ�ǰ��ɫ����������ŵ�����༭����;
/// ����:value:Role1,Step1,Opinion1^Role2,Step2,Opinion2
/// 	 ename:����༭��Ԫ�ص�����
///      ����CurRole��ȡ��ǰ��ɫ��ǰ�����
function FillEditOpinion(value,ename)
{
	if (!value) return
	var list=value.split("^");
	var len=list.length
	for (var i=len-1;i>=0;i--)
	{
		var EditOpinion=list[i].split(",");
		if (getElementValue("CurRole")==EditOpinion[0])
		{
			setElement("EditOpinion",EditOpinion[2])
			i=0;
		}
		else
		{
			setElement("EditOpinion","")
		}		
	}
}

function CheckSplitNumber()
{
	if (IsValidateNumber(getElementValue("SSplitOriginalFee"),1,1,0,1)==0)
	{
		messageShow('alert','error','��ʾ',"���ԭֵ����ȷ!");
		return -1;
	}
	if (IsValidateNumber(getElementValue("SSplitDepreTotalFee"),1,1,0,1)==0)
	{
		messageShow('alert','error','��ʾ',"����ۼ��۾ɲ���ȷ!");
		return -1;
	}
	if (IsValidateNumber(getElementValue("SSplitNetFee"),1,1,0,1)==0)
	{
		messageShow('alert','error','��ʾ',"���ֵ����ȷ!");
		return -1;
	}
}

function CheckInvalidData(i)
{
	var rows = objtbl.datagrid('getRows');
	var oneRow=rows[i]
	var RowNo=i+1
	if ((oneRow.SLOriginalFee=="")||(IsValidateNumber(oneRow.SLOriginalFee,1,1,0,0)==0))
	{
		messageShow('alert','error','��ʾ',"��"+RowNo+"�У�ԭֵ����ȷ!");	//��������ȷ
		return "-1";
	}
	if ((IsValidateNumber(oneRow.SLDepreTotalFee,1,1,0,1)==0))
	{
		messageShow('alert','error','��ʾ',"��"+RowNo+"�У��ۼ��۾ɲ���ȷ!");	//����ȷ
		return "-1";
	}
	if ((IsValidateNumber(oneRow.SLNetFee,1,1,0,1)==0))
	{
		messageShow('alert','error','��ʾ',"��"+RowNo+"�У���ֵ����ȷ!");	//����ȷ
		return "-1";
	}
	return false;
}

///�ж��Ƿ�Ϊ����
///���?NumStr��֤���ַ���
///		AllowEmpty:�Ƿ�����Ϊ��
///		AllowDecimal?�Ƿ�����С��
///		AllowNegative?�Ƿ�������
///		AllowZero:�Ƿ�������
///	����ֵ?0:��Ч
///			1:��Ч
function IsValidateNumber(NumStr,AllowEmpty,AllowDecimal,AllowNegative,AllowZero)
{
	if (NumStr=="")
	{
		if (AllowEmpty=="1")
		{
			return "1";
		}
		else
		{
			return "0";
		}
	}
	if (isNaN(NumStr)) return "0";
	//�ж��Ƿ���
	if ((NumStr<0)&&(AllowNegative!="1")) return "0";
	//�ж��Ƿ�����
	if ((parseInt(NumStr)!=NumStr)&&(AllowDecimal!="1")) return "0";
	if ((NumFormat(NumStr)==0)&&(AllowZero=="0")) return "0";
	return "1";	
}


function getParam(vQueryParams){
	if(vQueryParams=="SLRowID"){
		return objtbl.datagrid('getSelected').SLRowID==undefined?"":objtbl.datagrid('getSelected').SLRowID;
	}
	return ""
}

function BShowOpinion_Clicked()
{
	url="dhceq.plat.approvelist.csp?&BussType=55&BussID="+getElementValue("SRowID");
	showWindow(url,"�豸�����������","","","icon-w-paper","modal","","","middle");
}

function BPrint_Clicked(){ 
	var PreviewRptFlag=getElementValue("PreviewRptFlag");  //����Ԥ����־
	var fileName=""	
	if(PreviewRptFlag==0)
	{ 
	 	fileName="{DHCEQSplitPrint.raq(rowid="+getElementValue("SRowID")+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	if(PreviewRptFlag==1)
	{ 
		fileName="DHCEQSplitPrint.raq&rowid="+getElementValue("SRowID");
		DHCCPM_RQPrint(fileName); 
	}
}

function reloadGrid()
{
	var WaitAD=getElementValue("WaitAD"); 
	var QXType=getElementValue("QXType");
	var Action=getElementValue("Action");
	var RoleStep=getElementValue("RoleStep");
	var RowID=getElementValue("SRowID");
	var val="&RowID="+RowID+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Action="+Action+"&RoleStep="+RoleStep;
	url="dhceq.em.split.csp?"+val;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}

//������ϸ����
function BUpdateEquipsByList(editIndex)
{
	if (editIndex==="")
	{
		messageShow('alert','alert','��ʾ',"��Ų���Ϊ��!");
		return;
	}
	objtbl.datagrid('endEdit',editIndex);
	var rowData =  objtbl.datagrid("getRows")[editIndex];
	var SLRowID= (rowData.SLRowID==undefined?"":rowData.SLRowID);
	if (SLRowID=="")	//czf 2021-11-3
	{
		messageShow('alert','alert','��ʾ',"�����ȱ����ֵ�!");
		return;
	}
	var MainEquipNo= getElementValue("EquipNo");
	if (MainEquipNo=="")
	{
		messageShow('alert','alert','��ʾ',"���豸��Ų���Ϊ��!");
		return;
	}
	var SLQuantityNum= rowData.SLQuantityNum;
	if (IsValidateNumber(SLQuantityNum,0,0,0,0)=="0")
	{
		messageShow('alert','alert','��ʾ',"��ϸ��������,���޸�����!");
		return;
	}
	var SLJob=getElementValue("SJob");
	if (SLJob=="")
	{
		messageShow('alert','alert','��ʾ',"Jobֵ����Ϊ��!");
		return;
	}
	
	var url="dhceq.em.splitequiplist.csp?";
	url=url+"&EquipNo="+MainEquipNo;
	url=url+"&SourceID="+SLRowID;
	url=url+"&QuantityNum="+SLQuantityNum;
	url=url+"&Job="+SLJob;
	url=url+"&Index="+editIndex;
	url=url+"&Status="+getElementValue("SStatus");
	url=url+"&Type=1";
	showWindow(url,"�豸��������б�","","","icon-w-paper","modal","","","small",listChange);
}

//�豸������ű��������޸ĳ���
function listChange(index,quantity)
{
	
}

function clearDepreMethod()
{
	var rowData = $('#tDHCEQSplitList').datagrid('getSelected');
	rowData.SLDepreMethodDR="";
	$('#tDHCEQSplitList').datagrid('endEdit',editIndex);
	$('#tDHCEQSplitList').datagrid('beginEdit',editIndex);
}
