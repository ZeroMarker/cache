var editIndex=undefined;
var modifyBeforeRow = {};
var RowID=getElementValue("BPRowID");
var Columns=getCurColumnsInfo('EM.G.BuyPlan.BuyPlanList','','','')
var objtbl=$('#DHCEQBuyPlan')
var delRow=[]

$(function(){
	initDocument();	
});
function initDocument()
{
	initUserInfo();	//��ȡ����sessionֵ
    initMessage("BuyPlan"); //��ȡ���jsҵ���ͨ����Ϣ
    initLookUp(); //��ʼ���Ŵ�
    //czf 2021-09-02 begin
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"BPManageLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""},{"name":"ManageLocFlag","type":"2","value":"1"}];
    singlelookup("BPManageLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");	
    var ETParams=[{"name":"Desc","type":"1","value":"BPEquipTypeDR_ETDesc"},{"name":"GroupID","type":"3","value":curGroupID},{"name":"Flag","type":"2","value":"0"},{"name":"FacilityFlag","type":"2","value":"0"},{"name":"ManageLocID","type":"4","value":"BPManageLocDR"}];
    singlelookup("BPEquipTypeDR_ETDesc","PLAT.L.EquipType",ETParams,"");
	//czf 2021-09-02 end
	defindTitleStyle();
    initButton(); //��ť��ʼ��
    initButtonWidth();	//��ʼ����ť���
    initPage();//��ͨ�ð�ť��ʼ��
    ///modified by ZY0301 20220523
    //setElement("BPEquipTypeDR_ETDesc",getElementValue("BPEquipType"));
    setRequiredElements("BPPlanName^BPHold1_Desc^BPEquipTypeDR_ETDesc^BPManageLocDR_CTLOCDesc");	//modified by csj 20191112 �������
    fillData(); //�������
    setEnabled(); //��ť����
    initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"));	//add by csj 20190806 
    initApproveButtonNew(); //��ʼ��������ť
    initDataGrid();	//��ʼ��datagrid
}

function initDataGrid()
{
	$HUI.datagrid("#DHCEQBuyPlan",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSBuyPlan",
	        	QueryName:"BuyPlanList",
				RowID:RowID
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
	        },  //modify by lmm 2019-09-20 �����ť���
	        {
	            iconCls: 'icon-cancel',	//modified by csj 20190926 �޸�ͼ��
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
		pageSize:12,
		pageNumber:1,
		pageList:[12],
		onLoadSuccess:function(){
				creatToolbar();
		}
	});
//	$HUI.datagrid("#DHCEQBuyPlan").getPager().pagination({
//			onBeforeRefresh:function(){
//				console.log("onBeforeRefresh")
//			},
//		 	onRefresh:function(pageNumber,pageSize){
//			 	console.log("onRefresh")
//			},
//			onChangePageSize:function(){
//				console.log("onChangePageSize")
//			},
//			onSelectPage:function(pageNumber,pageSize){
//				console.log('pageNumber:'+pageNumber+',pageSize:'+pageSize);
//				console.log("onSelectPage")
//			}
//		})
}

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	//modified by ZY0253 ��ʼ��ʱͳ�ƺϼ�
	ChangeTotal()
	//��ť�һ�
	var panel = objtbl.datagrid("getPanel");	
	var BPStatus=getElementValue("BPStatus");
	if (BPStatus>0)
	{
		//modify by lmm 2019-09-20 ���ص��ºϼ�������ʾ�б�
		disableElement("add",true);
		disableElement("delete",true);
	}
	///add by ZY0213
    var rows = $("#DHCEQBuyPlan").datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
	    if (rows[i].BPLRowID=="")
	    {
		    $("#TSuggestList"+"z"+i).hide()
		}
    }
}
//��ͨ�ð�ť��ʼ��
function initPage() 
{	
	if (jQuery("#BIFBRequest").length>0)
	{
		//jQuery("#BIFBRequest").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BIFBRequest").on("click", BIFBRequest_Clicked);
	}
	if (jQuery("#BAuditReqeust").length>0)
	{
		//jQuery("#BAuditReqeust").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BAuditReqeust").on("click", BAuditReqeust_Clicked);
	}
	// MZY0041	1427332		2020-7-22	ע����ͣ���ð�ť��ʽ
	//Modified by CSJ 20191213 ������Ϣ��ͣ�鿴
	/*$("#showOpinion").on("mouseover mouseout",function(event){
		if(event.type == "mouseover"){
			//�������
			$("#showOpinion").popover('show');
		}else if(event.type == "mouseout"){
			//����뿪
			$("#showOpinion").popover('hide')
		}
	})*/
	if (jQuery("#showOpinion").length>0)
	{
		jQuery("#showOpinion").on("click", BShowOpinion_Clicked);
	}
}


function fillData()
{
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","GetOneBuyPlan",RowID)
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	//add by CSJ 20191201 �°�������¼
	//$("#showOpinion").popover({trigger:'manual',placement:'bottom',content:'<ul class="eq-auditopinion">'+jsonData.Data.AuditOpinion+'</ul>'});	 MZY0041	1427332		2020-7-22
	var ApproveListInfo=tkMakeServerCall("web.DHCEQApproveList","GetApproveByRource","2",RowID)
	FillEditOpinion(ApproveListInfo,"EditOpinion")
}

function setEnabled()
{
	var BPStatus=getElementValue("BPStatus");
	var Type=getElementValue("Type");
	var ReadOnly=getElementValue("ReadOnly");	//add by csj 2020-03-25
	if (BPStatus!="0")
	{
		setElement("ReadOnly","1");
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		if (BPStatus!="")
		{
			disableElement("BSave",true);
			disableElement("BClear",true);
		}
		else
		{
			setElement("ReadOnly","0");
			hiddenObj("showOpinion",1)
			hiddenObj("cEditOpinion",1)
			hiddenObj("EditOpinion",1)
			hiddenObj("cRejectReason",1)
			hiddenObj("RejectReason",1)
		}
	}
	else{
		hiddenObj("showOpinion",1)
		hiddenObj("cEditOpinion",1)
		hiddenObj("EditOpinion",1)
		hiddenObj("cRejectReason",1)
		hiddenObj("RejectReason",1)
	}
	//add by csj 20191023
	if(BPStatus!="2")
	{
		disableElement("BIFBRequest",true)
	}
	if (Type==1)
	{
		setElement("ReadOnly","1");
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BClear",true);
	}
	//add by csj 2020-03-25
	if(ReadOnly==1)	
	{
		disableElement("BIFBRequest",true);
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BClear",true);
	}
	//add by csj 2020-04-02 ���¼������߶�
	var eqtableHeight=$("#BPTable>.eq-table").height()
	var northHeight=$("#BPTable").height()
	var offset=northHeight-eqtableHeight
	$("#BPTable").height($("#BPTable>.eq-table").height())
	$("#BPGrid").parent().css({"top":$("#BPGrid").parent().position().top-offset})
	$("#BPGrid").height($("#BPGrid").height()+offset)
	$("#BPGrid .panel-body").height($("#BPGrid .panel-body").height()+offset)
	$("#BPGrid .datagrid-wrap").height($("#BPGrid .datagrid-wrap").height()+offset)
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID.split("_")[0],rowData.TRowID)
}

function clearData(elementID)
{
	setElement(elementID.split("_")[0],'')
	return;
}
// ��������
// modified by csj 2020-04-10 ֱ�ӵ���GetTableInfo�жϣ��Ż�����������ʾ 
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#DHCEQBuyPlan").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = objtbl.datagrid('getRows'); // modified by csj 2020-04-14
//    var lastIndex=rows.length-1
    var newIndex=rows.length; // modified by csj 2020-04-14
//    var BPLSourceType = (typeof rows[lastIndex].BPLSourceType == 'undefined') ? "" : rows[lastIndex].BPLSourceType;
//    var BPLQuantityNum = (typeof rows[lastIndex].BPLQuantityNum == 'undefined') ? "" : rows[lastIndex].BPLQuantityNum;
//    var BPLItemDR = (typeof rows[lastIndex].BPLItemDR == 'undefined') ? "" : rows[lastIndex].BPLItemDR;
//    if ((BPLSourceType=="")||(BPLQuantityNum=="")||(BPLItemDR==""))	
    if(GetTableInfo()=="-1")
    {
	    return
//	    messageShow('alert','error','������ʾ',t[-9241].replace('[RowNo]',newIndex));	//��[RowNo]������Ϊ��!������д����
	}
	else
	{
		jQuery("#DHCEQBuyPlan").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	//modified by csj 2020-04-10 �Ż�ɾ������ʾ
	if (editIndex != undefined)
	{
		if(objtbl.datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"��ʾ",t[-9242]);	//��ǰ�в���ɾ��
			return
		}
		jQuery("#DHCEQBuyPlan").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		var BPLRowID=objtbl.datagrid('getRows')[editIndex].BPLRowID
		delRow.push(BPLRowID)
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
	var url='dhceq.em.buyplan.csp?QXType=&Type=0&PlanType=0&WaitAD=off';
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}

function BSave_Clicked()
{
    if (checkMustItemNull()) return;
	var combindata=JSON.stringify(getInputList()); 	//�ܵ���Ϣ
  	var valList=GetTableInfo(); 	//��ϸ��Ϣ
  	if (valList=="-1")  return; 	//��ϸ��Ϣ����
  	var DelRowid=delRow.join(',')//GetDelRowid();
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","UpdateData",combindata,valList,DelRowid,curUserID);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','info','��ʾ',t[0]);	//�����ɹ�
		var url='dhceq.em.buyplan.csp?WaitAD=off&RowID='+jsonData.Data+"&Type="+getElementValue("Type")+"&PlanType="+getElementValue("PlanType");
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
		var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","DeleteData",RowID,curUserID);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
			return
	    }
	    else
	    {
		    var url="dhceq.em.buyplan.csp?WaitAD=off&Type="+getElementValue("Type")+"&PlanType="+getElementValue("PlanType");
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
		    window.location.href= url
		}

	}
	
	function Cancel(){
		return
	}	

}
//modified by csj 20191016�ȱ���һ�����ύ
function BSubmit_Clicked()
{
	if (checkMustItemNull()) return;
	var combindata=JSON.stringify(getInputList()); 	//�ܵ���Ϣ
  	var valList=GetTableInfo(); 	//��ϸ��Ϣ
  	if (valList=="-1")  return; 	//��ϸ��Ϣ����
	var DelRowid=delRow.join(',')//GetDelRowid();
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","UpdateData",combindata,valList,DelRowid);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		combindata=GetAuditData();
		jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","SubmitData",combindata);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
	    {
		    var url='dhceq.em.buyplan.csp?RowID='+jsonData.Data+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type")+"&PlanType="+getElementValue("PlanType");
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
	if (getElementValue("RejectReason")=="")
	{
		setFocus("RejectReason");
		messageShow('alert','error','��ʾ',t[-9234])	//"�ܾ�ԭ����Ϊ��!"
		return
	}
	var combindata=GetAuditData();
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","CancelSubmitData",combindata,getElementValue("CurRole"));
	jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
	    var url='dhceq.em.buyplan.csp?RowID='+jsonData.Data+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type")+"&PlanType="+getElementValue("PlanType")+"&CurRole="+getElementValue("CurRole");;
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
    if (getElementValue("EditOpinion")=="")
	{
		setFocus("EditOpinion");
		messageShow('alert','error','��ʾ',t[-9233])	//�����������Ϊ��!
		return
	}
	
	var combindata=GetAuditData();
	var CurRole=getElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep");
  	if (RoleStep=="") return;
  	 //start by csj 20190806 �ɱ༭�ֶ���Ϣ
  	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyPlan","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo);
  	jsonData=JSON.parse(jsonData)
  	//end by csj 20190806
    if (jsonData.SQLCODE==0)
    {
	    window.location.reload();
	}
    else
    {
	    messageShow("","","",t[-9200]+jsonData.Data); //"����ʧ��"
    }
}

//��ȡ�б���ϸ
function GetTableInfo()
{
	var valList="";
	if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = ""
	for (var i = 0; i < rows.length; i++) 
	{
		//add by csj 2020-10-13 ����ţ�1556638
		rows[i].BPLTotalFee=rows[i].BPLQuantityNum*rows[i].BPLPriceFee;
		RowNo=i+1
		var BPLRow=(typeof rows[i].BPLRow == 'undefined') ? "" : rows[i].BPLRow
		var BPLRowID=(typeof rows[i].BPLRowID == 'undefined') ? "" : rows[i].BPLRowID
		//start by csj 2020-04-10 �豸���Ʋ���Ϊ��
		//var BPLItem=(typeof rows[i].BPLItem == 'undefined') ? "" : rows[i].BPLItemDR_IDesc
		var BPLName=(typeof rows[i].BPLName == 'undefined') ? "" : rows[i].BPLName
		if(BPLName=="")
		{
			messageShow('alert','error','��ʾ',t[-9251].replace('[RowNo]',RowNo))	//"��[RowNo]���豸���Ʋ���Ϊ��!"
			return -1
		}
		//end by csj 2020-04-10
		//start by csj 20181203
		var BPLItemDR=(typeof rows[i].BPLItemDR == 'undefined') ? "" : rows[i].BPLItemDR
		//add by csj 20191112 �ж���ϸ�����Ƿ�������һ��
		if(BPLItemDR!="")
		{
			var MasterItemInfo=tkMakeServerCall("web.DHCEQCMasterItem","GetDocByID","","",BPLItemDR)
		    if (MasterItemInfo.split("^")[3]!=getElementValue("BPEquipTypeDR"))
		    {
			    messageShow('alert','error','��ʾ',t[-9220].replace('[RowNo]',RowNo))	//"��"+RowNo+"����ϸ�������������鲻һ��!"
			    return -1
		    }
		    
		    var BPLModel=(typeof rows[i].BPLModelDR_MDesc == 'undefined') ? "" : rows[i].BPLModelDR_MDesc
			if (BPLModel!="")
			{
				var RModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",BPLModel,BPLItemDR)
			    if (RModelDR<=0)
			    {
				    messageShow("","","",t[-9247].replace('[RowNo]',RowNo))	//"��[RowNo]�й���ͺŵǼǴ���!"
				    return -1
			    }
			    else
			    {
				    rows[i].BPLModelDR=RModelDR	//modified by csj 20190531
			    }
			}
			else
			{
				rows[i].BPLModelDR=""
			}

		}
		///modified by ZY0214
		else
		{
			var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","92","");
			if ((ItemReqFlag==0)&&(BPLItemDR==""))
			{
				messageShow('alert','error','������ʾ',t[-9250].replace('[RowNo]',RowNo));	//modified by csj 2020-04-10 "��[RowNo]���豸���Ϊ��!"
				//messageShow("","","",t[-9246].replace('[RowNo]',RowNo))	//"��[RowNo]��δѡ��ƻ��豸��Դ!" 
				return -1
			}
		}
		///end by ZY0214
		
		//add by csj 20191202 �ж��ظ���Ϣ
		for(var j=i+1;j<rows.length;j++){
			if(rows[i].BPLItemDR==rows[j].BPLItemDR&&rows[i].BPLModelDR_MDesc==rows[j].BPLModelDR_MDesc)	
			{
				messageShow('alert','error','��ʾ',t[-9249].replace('[RowNoi]',RowNo).replace('[RowNoj]',j+1))	//'��[RowNoi]�����[RowNoj]���ظ�!'
				return -1;
			}
		}
		//end by csj 20191202
		if (CheckInvalidData(i)) return -1;
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
	if (valList=="")
	{
		messageShow('alert','error','��ʾ',t[-9248]);	//"�б���ϸ����Ϊ��!"
		return -1;
	}
	return valList;
}

function GetAuditData()
{
	var ValueList="";
	ValueList=RowID;
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EditOpinion");
	ValueList=ValueList+"^"+getElementValue("RejectReason");
	
	return ValueList;
}

function onClickRow(index)
{
	var BPStatus=getElementValue("BPStatus");
	
	if (BPStatus>0 && setListEditable(objtbl)==-1) return	//modifeid by csj 20191016 �����Ƿ��б�ɱ༭�ֶι�������
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
	ChangeTotal()
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
//add by csj 2020-03-19 ͨ����ѡ�� ����ţ�1234799
function GetMasterItem(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
	rowData.BPLItemDR=data.TRowID;
	rowData.BPLEquipCatDR=data.TCatDR;	
	rowData.BPLEquipCatDR_ECDesc=data.TCat
	var ItemEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLItemDR_IDesc'}); 
	$(ItemEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);// add by wy 2020-01-10  bug WY0054
	//modified by ZY0230 20200508
	ChangeTotal()
}
function GetSourceType(index,data)
{
	if (checkMustItemNull()) return;
	var rowData = objtbl.datagrid('getSelected');
	setElement("BPSourceTypeDR",data.TRowID)
	rowData.BPLBuyRequestListDR="";
	rowData.BPLItemDR="";
	rowData.BPLModelDR="";
	rowData.BPLQuantityNum="";
	rowData.BPLPriceFee="";
	rowData.BPLTotalFee="";
	rowData.BPLManuFacDR="";
	rowData.BPLExecNum="";
	rowData.BPLArriveNum="";
	rowData.BPLSourceTypeDR=data.TRowID
	
	var SourceIDEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLSourceID'});
	$(SourceIDEdt.target).combogrid("setValue",'');
	var ItemEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLItemDR_IDesc'}); 
	$(ItemEdt.target).val('');
	var ModelDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLModelDR_MDesc'});
	$(ModelDescEdt.target).combogrid("setValue",'');
	var ManuFactoryDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLManuFacDR_MFDesc'});
	$(ManuFactoryDescEdt.target).combogrid("setValue",'');
	
	var QuantityEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLQuantityNum'}); // 
	$(QuantityEdt.target).val('');
	var PriceFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLPriceFee'}); // 
	$(PriceFeeEdt.target).val('');
	var CommonNameEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLName'}); // 
	$(CommonNameEdt.target).val('');
	var TArriveDateEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLArriveDate'}); // 
	$(TArriveDateEdt.target).datebox('setValue','');
	
	var ExtendIDEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLSourceType'});
	$(ExtendIDEdt.target).combogrid("setValue",data.TDesc);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);// add by wy 2020-01-10  bug WY0054
	//modified by ZY0230 20200508
	ChangeTotal()
}
function GetSourceID(index,data)
{
	var rows = objtbl.datagrid('getRows'); 
	var RowNo = ""
	var rowData = objtbl.datagrid('getSelected');
	setElement("EQItemDR",data.TItemDR)
	rowData.BPLItemDR=data.TItemDR;
	rowData.BPLModelDR=data.TModelDR;
	rowData.BPLManuFacDR=data.TManuFcDR;
	rowData.BPLPriceFee=data.TPriceFee;
	rowData.BPLQuantityNum=data.TQuantityNum;
	rowData.BPLTotalFee=data.TTotalFee;
	rowData.BPLBuyRequestListDR=data.TBuyRequestListDR;
	rowData.BPLEquipCatDR=data.TEquipCatDR;	//add by csj 20190531
	rowData.BPLEquipCatDR_ECDesc=data.TEquipCat	//add by csj 20190531
	var SourceIDEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLSourceID'});
	$(SourceIDEdt.target).combogrid("setValue",data.TPrjName);
	var ItemEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLItemDR_IDesc'}); 
	$(ItemEdt.target).val(data.TName);
	var ModelDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLModelDR_MDesc'}); // 
	$(ModelDescEdt.target).combogrid("setValue",data.TModel);
	var ManuFactoryDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLManuFacDR_MFDesc'}); // 
	$(ManuFactoryDescEdt.target).combogrid("setValue",data.TManuFac);
	
	var QuantityEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLQuantityNum'}); // 
	$(QuantityEdt.target).val(data.TQuantityNum);
	var PriceFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLPriceFee'}); // 
	$(PriceFeeEdt.target).val(data.TPriceFee);
	var CommonNameEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLName'}); // 
	$(CommonNameEdt.target).val(data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);// add by wy 2020-01-10  bug WY0054
	//modified by ZY0230 20200508
	ChangeTotal()
}

function GetModel(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BPLModelDR=data.TRowID;
	var ModelDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLModelDR_MDesc'}); // 
	$(ModelDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);// add by wy 2020-01-10  bug WY0054
	//modified by ZY0230 20200508
	ChangeTotal()
}
function GetManuFacturer(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BPLManuFacDR=data.TRowID;
	var ManuFactoryDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLManuFacDR_MFDesc'}); // 
	$(ManuFactoryDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);// add by wy 2020-01-10  bug WY0054
	//modified by ZY0230 20200508
	ChangeTotal()
}

function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var invQuantityEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLQuantityNum'});	// ����
        var invPriceFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BPLPriceFee'});
        setElement("BPSourceTypeDR",objtbl.datagrid('getSelected').BPLSourceTypeDR) //add by csj 20191009 
        setElement("EQItemDR",objtbl.datagrid('getSelected').BPLItemDR) //add by csj 20190906 ��Ҫ�ò���ȡ�豸�����
        // ����  �� �뿪�¼� 
        if(invQuantityEdt){
	        $(invQuantityEdt.target).bind("blur",function(){
	            // ���������������� ���
	            var quantityNum=parseFloat($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = objtbl.datagrid('getSelected');
				rowData.BPLTotalFee=quantityNum*originalFee;
				//add by ZY0248 2020-12-14
				$('#DHCEQBuyPlan').datagrid('endEdit',editIndex);
				ChangeTotal()
        	});
	    }
        if(invPriceFeeEdt){
	        $(invPriceFeeEdt.target).bind("blur",function(){
	            // ���������������� ���
	            var quantityNum=parseFloat($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = objtbl.datagrid('getSelected');
				rowData.BPLTotalFee=quantityNum*originalFee;
				//add by ZY0248 2020-12-14
				$('#DHCEQBuyPlan').datagrid('endEdit',editIndex);
				ChangeTotal()
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
	var totalQuantityNum = 0;
    var totalTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
	    //objtbl.datagrid('endEdit',i);	//add by csj 20190828
        var colNumValue=rows[i]["BPLQuantityNum"];
        if (isNaN(colNumValue)) colNumValue=0;
        totalQuantityNum += parseFloat(+colNumValue);
        colFeeValue=rows[i]["BPLTotalFee"];
        if (isNaN(colFeeValue)) colFeeValue=0;
        totalTotalFee += parseFloat(+colFeeValue);
        ///modified by ZY0213
	    if(rows[i].BPLRowID=="") $("#TSuggestList"+"z"+i).hide()
    }
    var lable_innerText='������:'+totalQuantityNum+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalTotalFee.toFixed(2);
//	var lable_innerText='������:'+getElementValue("BPQuantityNum")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+getElementValue("BPTotalFee");
	$("#sumTotal").html(lable_innerText);

//	setElement("BPQuantityNum",totalQuantityNum)
//	setElement("BPTotalFee",totalTotalFee.toFixed(2))
}

/// Add By ZY 2011-03-10
/// ����:�ѵ�ǰ��ɫ����������ŵ�����༭����;
/// ����:value:Role1,Step1,Opinion1^Role2,Step2,Opinion2
/// 	 ename:����༭��Ԫ�ص�����
///      ����CurRole��ȡ��ǰ��ɫ��ǰ�����
function FillEditOpinion(value,ename)
{
	if (!value) return
	var list=value.split("^");
	var len=list.length
	//modified by csj 20190909 ��Ϊ��������������
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
function CheckInvalidData(i)
{
	var rows = objtbl.datagrid('getRows');
	var oneRow=rows[i]
	var RowNo=i+1
	if ((oneRow.BPLQuantityNum=="")||(IsValidateNumber(oneRow.BPLQuantityNum,0,0,0,0)==0))
	{
		messageShow('alert','error','��ʾ',t[-9244].replace('[RowNo]',RowNo));	//��������ȷ
		return "-1";
	}
	if ((oneRow.BPLPriceFee=="")||(IsValidateNumber(oneRow.BPLPriceFee,0,1,0,0)==0))
	{
		messageShow('alert','error','��ʾ',t[-9245].replace('[RowNo]',RowNo));	//����ȷ
		return "-1";
	}
	return false;
}
///Add by jdl 2011-3-22
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
	if ((parseFloat(NumStr)==0)&&(AllowZero=="0")) return "0";
	return "1";	
}

///add by csj 20191014 �ɹ������Ƽ���Ʒ��Ϣ
function BSuggestListForLoc(editIndex)
{
	var rowData =  objtbl.datagrid("getRows")[editIndex];
	if(rowData.BPLBuyRequestListDR==undefined) return
	if (rowData.BPLBuyRequestListDR=="")
	{
		messageShow("","","",t[-5030])	//"�ǲɹ��������Ƽ���Ʒ��Ϣ��"
		return
	}
	var val="&SourceType=1&SourceID="+rowData.BRLBuyRequestListDR+"&ReadOnly="+getElementValue("ReadOnly");
	url="dhceq.em.ifblistforloc.csp?"+val;
	showWindow(url,"�ɹ�������֤-�Ƽ���Ʒ��Ϣ","","","icon-w-paper","modal","","","middle");   //modify by lmm 2020-06-04 UI
}

function BIFBRequest_Clicked()
{
	var RowsData = objtbl.datagrid('getRows');
	if(RowsData==""){
		messageShow("","","","û�д���������!")
		return;
	}
	var PlanListIDs=""
	$.each(RowsData, function(index, row){
		if (PlanListIDs=="") PlanListIDs=row.BPLRowID
		else PlanListIDs=PlanListIDs+","+row.BPLRowID
		});
	var para="&PlanListIDs="+PlanListIDs+"&SourceType=2"+"&ManageLocDR="+session['EQ.DEPTID']	//modified by csj 20191024 �����Դ����  modified by wy 201912-14 ����1136404 ���ӹ�����	
	//add by zx 2019-09-11
	//var url="dhceq.em.ifb.csp?"+para;
	var url="dhceq.em.ifb.csp?"+para;   //modified by wy 2020-8-14 1476459 �б��ļ�ȥ��new����
	showWindow(url,"�б����뵥","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2020-06-02 UI
}

function BAuditReqeust_Clicked()
{
	//add by zx 2019-09-11
	messageShow("","","","�ù�����δ����!");
	/*
	var RowsData = $('#DHCEQBuyPlan').datagrid('getRows');
	if(RowsData==""){
		messageShow("","","","û�д���������!")
		return;
	}
	var PlanListIDs=""
	$.each(RowsData, function(index, row){
		if (PlanListIDs=="") PlanListIDs=row.BPLRowID
		else PlanListIDs=PlanListIDs+","+row.BPLRowID
		});
	var para="&PlanListIDs="+PlanListIDs
	var url="dhceq.em.audit.csp?"+para;
	showWindow(url,"������뵥","96%","96%","icon-w-paper","modal","","","",refreshWindow)
	*/
}
//add by csj 2020-04-20 ������ȡ
function getParam(vQueryParams){
	if(vQueryParams=="BPLRowID"){
		return objtbl.datagrid('getSelected').BPLRowID==undefined?"":objtbl.datagrid('getSelected').BPLRowID;
	}
	return ""
}
// MZY0041	1427332		2020-7-22
function BShowOpinion_Clicked()
{
	url="dhceq.plat.approvelist.csp?&BussType=92&BussID="+getElementValue("BPRowID");
	showWindow(url,"�ɹ��ƻ���������","","","icon-w-paper","modal","","","middle");
}
//add By ZY0286 20211210
//Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="EquipTypeDR"){return getElementValue("BPEquipTypeDR")}
}
