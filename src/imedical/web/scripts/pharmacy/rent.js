var Columns=getCurColumnsInfo('RM.G.Rent.Affix','','',''); // add by zx 2020-04-22 �����б�
var editIndex=undefined;
var modifyBeforeRow={};
var tableID="";
var MoveUserFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'511001');  //Modify by zc 2020-05-20 ZC0073 

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initMessage("Rent");
	setElement("RRequestLocDR",curLocID);
	setElement("RRequestLocDR_DeptDesc",curLocName);
	setElement("RRequestUserDR",curUserID);
	setElement("RRequestUserDR_UName",curUserName);
	//Modify by zx 2020-04-24
	//setElement("RFromLocDR",getElementValue("RentLocID"));
	//setElement("RFromLocDR_DeptDesc",getElementValue("RentLocDesc"));
	var startTime=getElementValue("CurDateTime");
	if ($.trim(startTime)!="")$('#RPlanBegin').datetimebox({value: startTime});
	var startTime=getElementValue("CurDateTime");
	if ($.trim(startTime)!="")$('#RPlanEnd').datetimebox({value: startTime});
	initShowBtn(); //added by LMH 20230207 UI ֻ��ҳ���°�ť����ʾ
    //initApproveButtonNew(); //added by LMH 20230206 UI ������ť��ʼ��
	initButton(); //��ť��ʼ��
	defindTitleStyle();
	//Modify by zc0079 �ȳ�ʼ��,�ٸ�ֵ  begin
	initRentStatus();  
	initReturnStatus();
	//Modify by zc0079 �ȳ�ʼ��,�ٸ�ֵ  begin
	fillData();
	setRequiredElements("RFromLocDR_DeptDesc^RShareItemDR_SIDesc^RRequestLocDR_DeptDesc^RRequestUserDR_UName"); //������ Modify by zx 2020-04-24
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("Action"));
	initApproveButton();
	setEnabled();
	initLookUp();  //Modified By QW20220517 BUG:QW0161 ����λ��
	setDataTime();
	showBtnIcon('BSave^BDelete^BSubmit^BCancelSubmit^BApprove1^BApprove2^BApprove3^BApprove4^BApprove5',false); //modified by LMH 20230206 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonWidth();
	//Modify by zc 2020-05-20 ZC0073  ������Ϣ���� begin
	//$('#RWorkLoad').blur(function(){totalFee_Change()});
	totalFee_Change();
	//����ɱ�
	$('#RHold2').blur(function(){reduceFee_Change()});
	reduceFee_Change();
	if (MoveUserFlag=="0")
	{
		singlelookup("FromMoveUser","PLAT.L.EQUser","","");
		singlelookup("ToMoveUser","PLAT.L.EQUser","","");
	}
	//Modify by zc 2020-05-20 ZC0073  ������Ϣ���� end
}

function setEnabled()
{
	var Status=getElementValue("RStatus");
	var RowID=getElementValue("RRowID");
	if(RowID=="")
	{
		disableElement("BSubmit",true);
		disableElement("BDelete",true);
	}
	else
	{
		if (Status!="0")
		{
			disableElement("BDelete",true);
			disableElement("BSubmit",true);
			if (Status!="")
			{
				disableElement("BSave",true);
			}
		}
	}
	var Action=getElementValue("Action");
	var ReadOnly=getElementValue("ReadOnly");
	if(Action=="ZL_Loan")
	{
		$("#RRenewalTo").datetimebox({disabled: true});
		$("#RReturn").datetimebox({disabled: true});
		disableAllElements("RShareResourceDR_REEquipName^RRentManagerDR_UName^RLocReceiverDR_UName^RRentStatus^RStart^RRentStatusRemark^FromMoveUser");  //Modify by zc 2020-05-20 ZC0073
		tableID="tDHCEQRentAffix_Loan"
		initAffixInfo(); //Modify by zx 2020-05-18 Bug ZX0088
		$("#AffixReturn").hide();
		$("#RenturnInfo").hide();  //Modify by zc 2020-05-20 ZC0073
	}
	else if(Action=="ZL_Renewal")
	{
		$("#RStart").datetimebox({disabled: true});
		$("#RReturn").datetimebox({disabled: true});
		disableAllElements("RRenewalTo");
		$("#RenturnInfo").hide(); //Modify by zc 2020-05-20 ZC0073
	}
	else if(Action=="ZL_Return")
	{
		$("#RStart").datetimebox({disabled: true});
		$("#RRenewalTo").datetimebox({disabled: true});
		disableAllElements("RReturnManagerDR_UName^RLocReturnDR_UName^RReturnStatus^RReturn^RReturnStatusRemark^ToMoveUser^RHold2");  //Modify by zc 2020-05-20 ZC0073
		tableID="tDHCEQRentAffix_Return"
		initAffixInfo(); //Modify by zx 2020-05-18 Bug ZX0088
		$("#AffixLoan").hide();
		$("#RenturnInfo").show(); //Modify by zc 2020-05-20 ZC0073
	}
	else
	{
		$("#RenturnInfo").hide(); //Modify by zc 2020-05-20 ZC0073
		if (ReadOnly=="1") 
		{
			//Modify by zx 2020-08-29 BUG ZX0105 ��ϸ��ѯʱ��ʾ��Ϣ����
			disableAllElements();
			if (Status=="3")
			{
				tableID="tDHCEQRentAffix_Return";
				initAffixInfo();
				$("#AffixLoan").hide();
				$("#RenturnInfo").show();
				$('#AffixReturn').accordion("unselect",0);   //Modefied by zc0101 2021-5-13  ����ʾ������Ϣ
			}
			else if(Status=="2")
			{
				tableID="tDHCEQRentAffix_Loan";
				initAffixInfo();
				$("#AffixReturn").hide();
			}
			else
			{
				tableID="tDHCEQRentAffix_Loan";
				$("#AffixReturn").hide();
				$("#AffixLoan").hide();
			}
		}
		else
		{
			tableID="tDHCEQRentAffix_Loan";
			//Modify by zx 2020-08-28 BUG ZX0105
			initAffixInfo();
			$("#AffixReturn").hide();
			//$("#AffixLoan").hide();
		}
	}
}

function BSave_Clicked()
{
	if(getElementValue("RentModeFlag")!="2")
	{
		messageShow('alert','error','��ʾ',"��ǰ����ģʽ���������޸����ã�");
		return;
	}
	if (checkMustItemNull()) return;
	//Modify by zx 2020-05-22 BUG ZX0089 ������Һ��������Ҳ�����ͬ
	if (getElementValue("RRequestLocDR")==getElementValue("RFromLocDR"))
	{
		messageShow('alert','error','��ʾ',"������Һ͹������Ҳ�����ͬ��");
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSRent","SaveData",data, 0, curSSUserID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','success','��ʾ',"����ɹ�!",'',function(){reloadRent("0",jsonData.Data);});
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return;
    }
}

function BDelete_Clicked()
{
	var RowID=getElementValue("RRowID");
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSRent", "SaveData", RowID, 1, curSSUserID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','success','��ʾ',"ɾ���ɹ�!",'',function(){reloadRent("0","");});
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return;
    }
}

function BSubmit_Clicked()
{
	var RowID=getElementValue("RRowID");
	if (RowID=="")
	{
		messageShow('alert','error','��ʾ',"��Ч���������뵥!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSRent", "SubmitData", RowID, curUserID, curSSGroupID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    messageShow('alert','success','��ʾ',"�ύ�ɹ�!",'',function(){reloadRent("0",jsonData.Data);});
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return;
    }
}

function fillData()
{
	var RowID=getElementValue("RRowID");
	if (RowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSRent","GetOneRent",RowID,Action,Step);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	//����ʱ��ؼ���ֵ����
	var beginTime=getElementValue("RPlanBeginDate")+" "+getElementValue("RPlanBeginTime");
	if ($.trim(beginTime)!="") $('#RPlanBegin').datetimebox({value: beginTime});
	var endTime=getElementValue("RPlanEndDate")+" "+getElementValue("RPlanEndTime");
	if ($.trim(endTime)!="")$('#RPlanEnd').datetimebox({value: endTime});
	var startTime=getElementValue("RStartDate")+" "+getElementValue("RStartTime");
	if ($.trim(startTime)!="")$('#RStart').datetimebox({value: startTime});
	var returnTime=getElementValue("RReturnDate")+" "+getElementValue("RReturnTime");
	if ($.trim(returnTime)!="")$('#RReturn').datetimebox({value: returnTime});
	showPriceInfo();
	//�жϲ��账��
	if (jsonData.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
	//����͹黹ʱ��Ա��Ϣ����
	if(Action=="ZL_Loan")
	{
		setElement("RRentManagerDR",curUserID);
		setElement("RRentManagerDR_UName",curUserName);
		//Modify by zx 2020-04-21 Bug ZX0084
		var startTime=getElementValue("CurDateTime");
		//Modefied by zc0079 2020-07-10  ��ʼ����Ӧȡ��ǰ��ֵʱ��  begin
		//if ($.trim(startTime)!="")$('#RStart').datetimebox({value: startTime});
		if (($.trim(startTime)!="")&&(getElementValue("RStartDate")==""))
		{
			$('#RStart').datetimebox({value: startTime});
			var vRStart=startTime.split(" ");
			setElement("RStartDate",vRStart[0]);
			setElement("RStartTime",vRStart[1]);
		}
		//Modefied by zc0079 2020-07-10  ��ʼ����Ӧȡ��ǰ��ֵʱ��  end
	}
	else if(Action=="ZL_Return")
	{
		setElement("RReturnManagerDR",curUserID);
		setElement("RReturnManagerDR_UName",curUserName);
		//Modify by zx 2020-04-21 Bug ZX0084
		var returnTime=getElementValue("CurDateTime");
		//Modefied by zc0079 2020-07-10  ��������Ӧȡ��ǰ��ֵʱ��  begin
		//if ($.trim(returnTime)!="")$('#RReturn').datetimebox({value: returnTime});
		if (($.trim(returnTime)!="")&&(getElementValue("RReturnDate")==""))
		{
			$('#RReturn').datetimebox({value: returnTime});
			var vRReturn=returnTime.split(" ");
			setElement("RReturnDate",vRReturn[0]);
			setElement("RReturnTime",vRReturn[1]);
		}
		//Modefied by zc0079 2020-07-10  ��������Ӧȡ��ǰ��ֵʱ��  begin
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="RFromLocDR_DeptDesc") {setElement("RFromLocDR",rowData.TRowID)}
	else if(elementID=="RItemDR_MIDesc") {setElement("RItemDR",rowData.TRowID);}
	else if(elementID=="RShareResourceDR_REEquipName") 
	{
		setElement("RShareResourceDR",rowData.TRowID);
		setElement("RItemDR_MIDesc",rowData.TItem);
		setElement("RItemDR",rowData.TItemDR);
		setElement("RModelDR_MDesc",rowData.TModel);
		setElement("RModelDR",rowData.TModelDR);
		setElement("REquipNo",rowData.TEquipNo);
		setElement("RLeaveFactoryNo",rowData.TLeaveFactoryNo);
		showPriceInfo();
	}
	else if(elementID=="RModelDR_MDesc") {setElement("RModelDR",rowData.TRowID)}
	else if(elementID=="RRequestLocDR_DeptDesc") {setElement("RRequestLocDR",rowData.TRowID)}
	else if(elementID=="RRequestUserDR_UName") {setElement("RRequestUserDR",rowData.TRowID)}
	else if(elementID=="RRentManagerDR_UName") {setElement("RRentManagerDR",rowData.TRowID)}
	else if(elementID=="RLocReceiverDR_UName") {setElement("RLocReceiverDR",rowData.TRowID)}
	else if(elementID=="RRequestUserDR_UName") {setElement("RRequestUserDR",rowData.TRowID)}
	else if(elementID=="RRequestUserDR_UName") {setElement("RRequestUserDR",rowData.TRowID)}
	else if(elementID=="RReturnManagerDR_UName") {setElement("RReturnManagerDR",rowData.TRowID)}
	else if(elementID=="RLocReturnDR_UName") {setElement("RLocReturnDR",rowData.TRowID)}
	else if(elementID=="RShareItemDR_SIDesc") {setElement("RShareItemDR",rowData.TRowID)}
	//Modify by zc 2020-05-20 ZC0073 begin
	else if(elementID=="FromMoveUser") {setElement("FromMoveUserDR",rowData.TRowID)}
	else if(elementID=="ToMoveUser") {setElement("ToMoveUserDR",rowData.TRowID)}
	//Modify by zc 2020-05-20 ZC0073 end
}

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

function BApprove_Clicked()
{
	if (editIndex != undefined){ $("#"+tableID).datagrid('endEdit', editIndex);}
	setElement("RowID",getElementValue("RRowID")); //���ʱ�踳ֵRowID
	if (checkMustItemNull()) return;
	var objtbl=getParentTable("RRequestNo");
	var editFieldsInfo=approveEditFieldsInfo(objtbl);
	if (editFieldsInfo=="-1") return;
	var combindata=getValueList();
	var curAction=getElementValue("Action");
	var affixInfo=getAffixInfo(curAction);
	if (affixInfo=="-1") return;
  	var rtn=tkMakeServerCall("web.DHCEQ.RM.BUSRent","AuditData",combindata, curAction, editFieldsInfo,affixInfo);
    var rtnObj=JSON.parse(rtn);
    if (rtnObj.SQLCODE<0)
    {
	    messageShow("","","",rtnObj.Data);
    }
    else
    {
	    messageShow('alert','success','��ʾ',t[0],'',function(){reloadRent("","");});
    }
}

function getAffixInfo(action)
{
	//Modify by zx 2020-12-10 BUG ZX0121 �ɱ༭����Ҫ�����༭
	if(editIndex != undefined) $("#"+tableID).datagrid('endEdit', editIndex);
	var rows = $("#"+tableID).datagrid('getRows');
	var RowCount=rows.length;
	var val=""
	for (var i=0;i<RowCount;i++)
	{
		if (val!="") val=val+","
		if (action=="ZL_Loan")
		{
			if (rows[i].TQuantity>rows[i].TCanUseNum)
			{
				messageShow('alert','error','������ʾ','��'+(i+1)+'����������ʵ������.');
				return "-1";
			}
			var val=val+rows[i].TRowID;
			val=val+"^"+rows[i].TAffixDR;
			val=val+"^"+rows[i].TModel;
			val=val+"^"+rows[i].TQuantity;
			val=val+"^"+rows[i].TStatusDR;
			val=val+"^"+rows[i].TRemark;
			val=val+"^"+rows[i].TLeaveFactoryNo;
			val=val+"^";
			val=val+"^";
			val=val+"^";
		}
		else if(action=="ZL_Return")
		{
			if (rows[i].TBackQuantity>rows[i].TCanUseNum)
			{
				messageShow('alert','error','������ʾ','��'+(i+1)+'����������ʵ������.');
				return "-1";
			}
			var val=val+rows[i].TBackRowID;
			val=val+"^"+rows[i].TAffixDR;
			val=val+"^"+rows[i].TModel;
			val=val+"^"+rows[i].TBackQuantity;
			val=val+"^"+rows[i].TBackStatusDR;
			val=val+"^"+rows[i].TBackRemark;
			val=val+"^"+rows[i].TLeaveFactoryNo;
			val=val+"^";
			val=val+"^";
			val=val+"^";	
		}
	}
	return val;
}
function BCancelSubmit_Clicked()
{
	var RowID=getElementValue("RRowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var combindata=getValueList();
	//Modify by zx 2020-05-22 BUG ZX0089 ���Ӷ�������
	var curAction=getElementValue("Action");
	var rtn=tkMakeServerCall("web.DHCEQ.RM.BUSRent","CancelSubmitData",combindata,getElementValue("CurRole"),curAction);
    var rtnObj=JSON.parse(rtn)
    if (rtnObj.SQLCODE<0)
    {
	    messageShow("","","",rtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
	    window.setTimeout(function(){window.location.reload()},50); 
    }
}

function getValueList()
{
	var ValueList="";
	ValueList=getElementValue("RRowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+curGroupID;
	//Modify by zc 2020-05-20 ZC0073
	if(getElementValue("Action")=="ZL_Loan")
	{
		if (MoveUserFlag=="0")
		{
			ValueList=ValueList+"^"+getElementValue("FromMoveUserDR");
		}
		else
		{
			ValueList=ValueList+"^"+getElementValue("FromMoveUser");
		}
	}
	else if(getElementValue("Action")=="ZL_Return")
	{
		if (MoveUserFlag=="0")
		{
			ValueList=ValueList+"^"+getElementValue("ToMoveUserDR");
		}
		else
		{
			ValueList=ValueList+"^"+getElementValue("ToMoveUser");
		}
	}
	else 
	{
		ValueList=ValueList+"^";
	}
	//Modify by zc 2020-05-20 ZC0073 end
	return ValueList;
}

function initReturnStatus()
{
	$HUI.combobox('#RReturnStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"0",
		data:[{
				id: '0',
				text: '���'
			},{
				id: '1',
				text: '��ȱ��'
			}]
	});
}

function initRentStatus()
{
	$HUI.combobox('#RRentStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"0",
		data:[{
				id: '0',
				text: '���'
			},{
				id: '1',
				text: '��ȱ��'
			}]
	});
}
function setDataTime()
{
	$(".hisui-datetimebox").each(function(){
		var dataTimeObjID=$(this)[0].id;
		$('#'+dataTimeObjID).datetimebox({
			onChange: function(time){
				var dataTime=time.split(" ");
				setElement(dataTimeObjID+"Date",dataTime[0]);
				setElement(dataTimeObjID+"Time",dataTime[1]);
			}
		});
	});
}

function totalFee_Change()
{
	var price=getElementValue("RPrice")
	if (price=="") price=0
	price=parseFloat(price);
	var workLoad=getElementValue("RWorkLoad");
	//Modify by zx 2020-08-20 BUG ZX0105 ʱ��Ϊ��ʱ��ֵ0 
	if (workLoad=="")
	{
		workLoad=0;
		setElement("RWorkLoad",workLoad)
	}
	workLoad=parseFloat(workLoad);
	var tmpValue=(price.toFixed(2)*1)*(workLoad.toFixed(2)*1);
	tmpValue=parseFloat(tmpValue);
	//setElement("RTotalFee",tmpValue.toFixed(2))  /// Modefied by zc0111 2021-12-29 �ɱ��۸�ȡ��̨����ֵ
}

//���¼���ת�Ƶ�
function reloadRent(type, rowID)
{
	if(type=="0")
	{
		websys_showModal("options").mth();
		url="dhceq.rm.rentrequest.csp?RowID="+rowID;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
	{
		websys_showModal("options").mth();
		window.location.reload();
	}
}
//Modify by zx 2020-05-18 Bug ZX0088
function initAffixInfo()
{
	$HUI.datagrid("#"+tableID,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSRent",
			QueryName:"GetMoveAffix",
			RentID:getElementValue("RRowID"),
			EventType:getElementValue("RStatus")
		},
	    //fit:true,
	    singleSelect:true,
	    rownumbers: true,
	    border:false,
	    columns:Columns,
	    	//Modify by zx 2020-05-18 Bug ZX0088
		//pagination:true,
		//pageSize:5,
		pageNumber:1,
		//pageList:[5,10,15],
		onLoadSuccess:function(data){
			//Modify by zx 2020-06-09 Bug ZX0100 ������ʱ�����б�Ӱ��
			if (data.total=="0")
			{
				$("#AffixLoan").hide();
				$("#AffixReturn").hide();
			}
			var Action=getElementValue("Action");
			if (Action=="ZL_Loan")
			{
				$("#"+tableID).datagrid('hideColumn', 'TBackQuantity');
				$("#"+tableID).datagrid('hideColumn', 'TBackStatus');
				$("#"+tableID).datagrid('hideColumn', 'TBackRemark');
			}
		}
	});
}

// add by zx 2020-04-22
// �����б�˫������
function onClickRow(index)
{
	var Action=getElementValue("Action");
	if ((Action!="ZL_Loan")&&(Action!="ZL_Return")) return;
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$("#"+tableID).datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$("#"+tableID).datagrid('getRows')[editIndex]);
			
			if(Action=="ZL_Return")
			{
				var quantity = $("#"+tableID).datagrid('getEditor', { index:index, field: 'TQuantity' });
				$(quantity.target).attr('disabled', true);
				var remark = $("#"+tableID).datagrid('getEditor', { index:index, field: 'TRemark' });
				$(remark.target).attr('disabled', true);
				var status = $("#"+tableID).datagrid('getEditor', { index:index, field: 'TStatus' });
				$(status.target).attr('disabled', 'disable');
				var leaveFactoryNo = $("#"+tableID).datagrid('getEditor', { index:index, field: 'TLeaveFactoryNo' });
				$(leaveFactoryNo.target).attr('disabled', true);
			}
		} else {
			$("#"+tableID).datagrid('selectRow', editIndex);
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
	if ($("#"+tableID).datagrid('validateRow', editIndex)){
		$("#"+tableID).datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// add by zx 2018-11-22
// �豸��ŵص�ѡ��
function getAffixStatus(index,data)
{
	var rowData = $("#"+tableID).datagrid('getSelected');
	var Action=getElementValue("Action");
	if (Action=="ZL_Loan")
	{
		rowData.TStatusDR=data.TRowID;
		var statusEdt = $("#"+tableID).datagrid('getEditor', {index:editIndex,field:'TStatus'});
		$(statusEdt.target).combogrid("setValue",data.TDesc);
	}
	else if (Action=="ZL_Return")
	{
		rowData.TBackStatusDR=data.TRowID;
		var statusEdt = $("#"+tableID).datagrid('getEditor', {index:editIndex,field:'TBackStatus'});
		$(statusEdt.target).combogrid("setValue",data.TDesc);
	}
	$("#"+tableID).datagrid('endEdit',editIndex);
}

//Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="ShareItemDR"){return getElementValue("RShareItemDR")}
}

function showPriceInfo()
{
	var shareResourceDR=getElementValue("RShareResourceDR");
	if (shareResourceDR=="") return;
	var rtn=tkMakeServerCall("web.DHCEQ.RM.BUSRent","RentPriceInfo",shareResourceDR);
	rtn=rtn.split("^");
	if (rtn!="")
	{
		$("#PriceInfo").css('display','block');
		$("#PriceDesc").text(rtn[0]);
		setElement("RResourcePriceDR",rtn[1])
	}
}
//����ɱ�����
//Modify by zc 2020-05-20 ZC0073
function reduceFee_Change()
{
	var price=getElementValue("RPrice")
	if (price=="") price=0
	price=parseFloat(price);
	var workLoad=getElementValue("RWorkLoad")
	if (workLoad=="") workLoad=0
	workLoad=parseFloat(workLoad);
	var reduce=getElementValue("RHold2")
	if (reduce=="") reduce=0
	reduce=parseFloat(reduce);
	if (reduce>workLoad)
	{
		messageShow('alert','info','����',"����ʱ������ʹ��ʱ����");
		setElement("RHold2","")
		return ;
	}
	/// Modefied by zc0111 2021-12-29   ���ٷ��ü��� begin
	//var tmpValue=(price.toFixed(2)*1)*(reduce.toFixed(2)*1);
	//tmpValue=parseFloat(tmpValue);
	//setElement("RHold4",tmpValue.toFixed(2))
	var tmpValue=tkMakeServerCall("web.DHCEQ.RM.BUSRent","GetReduceFeeByRResourcePrice",getElementValue("RResourcePriceDR"),reduce);
	setElement("RHold4",tmpValue)
	/// Modefied by zc0111 2021-12-29	���ٷ��ü��� end
}
/**
*@description �ɽ������ReadOnly���ư�ť�Ƿ���ʾ 1 ����ʾ ""��ʾ
*@author LMH 20230207
*@params ��
*@return ��
*/
function initShowBtn(){
	if(getElementValue('ReadOnly')){
		$('#showBtn').hide();
	}else{
		$('#showBtn').parent().css('top','329px');
	}
}
