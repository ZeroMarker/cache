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
    initMessage("Contract"); 	//获取所有业务消息
    initLookUp(); 			//初始化放大镜
    initCTHold1();			//初始化合同类型	add by CZF0067 2020--03-12		
    defindTitleStyle();
    initButton(); 				//按钮初始化 
    initButtonWidth();
    InitEvent()
    setRequiredElements("CTContractName^CTProviderDR_VDesc^CTSignDate"); //必填项
    setElement("CTSignDate",GetCurrentDate());		//Mozy	929782	2019-06-13
    fillData(); 				//数据填充
    setEnabled(); 				//按钮控制
    //initPage(); 				//非通用初始化
    setElementEnabled(); 		//输入框只读控制 	//Mozy	868476	2019-5-10
    //initEditFields(); 		//获取可编辑字段信息
    initApproveButtonNew(); 		//初始化审批按钮
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
	            text:'新增',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },		/// Mozy003006		2020-04-29		取消按钮的间距
	        {
	            iconCls: 'icon-cancel',
	            text:'删除',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        }
	    ],
		rownumbers: true,  		//如果为true则显示行号列
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
			// 设置隐藏列
			if (getElementValue("CTContractType")==1)
			{
				//保修合同
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
				//协议合同
				$("#DHCEQContract").datagrid("hideColumn", "CTLQuantityNum");
				$("#DHCEQContract").datagrid("hideColumn", "CTLTotalFee");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");	// Mozy	836945	2019-3-10
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy0230		2019-11-11	1090361
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");
			}
			if (getElementValue("CTStatus")=="") $("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");	// Mozy	836945	2019-3-10
			// Mozy		2019-10-22	隐藏按钮
			if ((getElementValue("CTStatus")==1)||(getElementValue("CTStatus")==2))
			{
				hiddenObj("BSave",1);
				hiddenObj("BDelete",1);
				hiddenObj("BSubmit",1);
			}
			if (getElementValue("CTHold1")==2) $("#DHCEQContract").datagrid("hideColumn", "CTLAction");		//modified by czf 1243349 工程合同不需验收
		}
	});
};

function InitEvent() //初始化
{
	/*	 MZY0024	1311628		2020-05-09	取消"退回"事件重复定义
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
	//modified zy 20191012 增加设备项维护的按钮事件
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
function initPage() //初始化
{
	//
}
//添加合计信息
function creatToolbar()
{
	var lable_innerText='总数量:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2)
	if (getElementValue("CTContractType")==1) lable_innerText='维保设备总数量:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;维保设备总金额:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2);	// Mozy003011	2020-04-14
	$("#sumTotal").html(lable_innerText);
	if (getElementValue("CTContractType")==2) $("#sumTotal").remove();	// Mozy003004	1247770		2020-3-30	协议合同不显示合计行
	var panel = $("#DHCEQContract").datagrid("getPanel");
	var rows = $("#DHCEQContract").datagrid('getRows');
	//图标影藏
    for (var i = 0; i < rows.length; i++) {
	    if ((rows[i].CTLSourceType=="")&&(rows[i].CTLSourceID==""))
	    {
		    $("#ContractConfig"+"z"+i).hide();
		}
    }
	//按钮灰化
	var Status=getElementValue("CTStatus");
	if (Status>0)
	{
		// Mozy		2019-10-22	无效按钮
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
		messageShow('alert','error','错误提示',jsonData.Data)
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
	else if(elementID=="CTManageLocDR_CTLOCDesc") {setElement("CTManageLocDR",rowData.TRowID)}	//Mozy0233	2019-11-25 1096009	修正字段名
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
// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		$("#DHCEQContract").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#DHCEQContract").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    if ((lastIndex>0)&&(rows[lastIndex].CTLSourceID=="undifined"))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	}
	else
	{
		$("#DHCEQContract").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		$("#ContractConfig"+"z"+newIndex).hide();
	}
}
//Mozy	898948	2019-5-22
function deleteRow()
{
	////modified zy 20191012 调用公共方法删除行
	if ((editIndex>"0")||(editIndex="0"))  //modify by wl 2019-9-3 1014272
	{
		jQuery("#DHCEQContract").datagrid('endEdit', editIndex);//结束编辑并传入之前编辑的行
		//$("#DHCEQContract").datagrid('deleteRow',editIndex);
	}
	removeCheckBoxedRow("DHCEQContract")
	/*
	else if(editIndex=="0")
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
	*/
}
function BSave_Clicked()
{
	if (getElementValue("CTContractType")=="")
	{
		messageShow('alert','error','错误提示','合同类型不能为空!');
		return;
	}
	if (getElementValue("CTContractName")=="")
	{
		messageShow('alert','error','错误提示','合同名称不能为空!');
		return;
	}
	if (getElementValue("CTProviderDR")=="")
	{
		messageShow('alert','error','错误提示','供应商不能为空!');
		return;
	}
	if (getElementValue("CTSignDate")=="")
	{
		messageShow('alert','error','错误提示','签订日期不能为空!');
		return;
	}
	if ((getElementValue("CTContractType")=="1")&&(getElementValue("CTEndDate")==""))
	{
		messageShow('alert','error','错误提示',"保修截止日期不能为空!");
		return;
	}
	// Mozy003011	2020-04-14
	if ((getElementValue("CTContractType")=="1")&&(getElementValue("CTTotalFee")==""))
	{
		messageShow('alert','error','错误提示',"维保总金额不能为空!");
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
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据不正确!');
			return "-1";
		}
		///modified by ZY0214
		var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","94","");
		if ((ItemReqFlag==0)&&(oneRow.CTLItemDR==""))
		{
			messageShow('alert','error','错误提示','设备项不能为空!');
			return -1
		}
		///end by ZY0214
		if (getElementValue("CTContractType")==0)
		{
			////modified zy 20191012 设备项不必填
			/*
			if (oneRow.CTLItemDR=="")
			{
				messageShow('alert','error','错误提示','第'+(i+1)+'行[通用名]不正确!');
				return "-1";
			}
			*/
			if (oneRow.CTLQuantityNum=="")
			{
				messageShow('alert','error','错误提示','第'+(i+1)+'行[数量]不正确!');
				return "-1";
			}
			if (oneRow.CTLPriceFee=="")
			{
				messageShow('alert','error','错误提示','第'+(i+1)+'行[单价]不正确!');
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
				// Mozy		2019-11-02	1069069		Mozy0228	自动保存来源设备项的规格型号
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
		messageShow('alert','error','错误提示','合同明细不能为空!');
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
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同删除!');
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
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同提交!');
		return;
	}
	// Mozy003019		2020-04-28
	if (getElementValue("CTContractNo")=="")
	{
		messageShow('alert','error','错误提示','合同号为空,不能提交!');
		return;
	}
	/*/ Mozy003008		2020-04-09 		未完成上传设置,注释
	///modified by ZY0203
	//start by csj 20190808 判断图片上传
	if((getElementValue("CTTotalFee")>=5000)&&(getElementValue("CTContractType")==0)){
		//检查是否上传审计报告图片
		var uploadReportFlag = tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","CheckIfUploadPicBySourceID","94",CTRowID,"08");
		if(!+uploadReportFlag){
			messageShow('alert','error','提示',"采购总额大于5000!请上传审计报告图片")
			return
		}
		if(getElementValue("CTTotalFee")>=200000){
			//检查是否上传中标通知书
			var uploadNoticeFlag = tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","CheckIfUploadPicBySourceID","94",CTRowID,"07");
			if(!+uploadNoticeFlag){
				messageShow('alert','error','提示',"采购总额大于20万!请上传中标通知书图片")
				return
			}
		}
		
	}
	//end by csj 20190808 判断图片上传
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
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同取消!');
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);
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
	    messageShow('alert','error','错误提示',RtnObj.Data);
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
		messageShow('alert','error','错误提示','请先保存单据!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var value=getElementValue("CTContractType");	//0:采购合同  1:保修合同  2:协议合同
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
	showWindow(str,"图片","","","icon-w-paper","modal","","","middle");	//modify by lmm 2020-06-04 UI
}
function BPayPlan_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','请先保存该数据,才能处理付款计划!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	///SourceType:1合同  2验收
	//var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType=1&SourceID="+CTRowID+"&ReadOnly="+ReadOnly;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=580,left=120,top=0')
    var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType=1&SourceID="+CTRowID+"&ReadOnly="+ReadOnly;
	showWindow(str,"付款计划","","","icon-w-paper","modal","","","large");	//modify by lmm 2020-06-04 UI
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
		messageShow("","","","操作成功");
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
		messageShow('alert','error','错误提示',jsonData.Data);
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
			bindGridEvent(); //编辑行监听响应	 Mozy003011	2020-04-14	取消注释
		} else {
			$('#DHCEQContract').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

//modified by csj 2020-05-09 需求号：1311282，1311051
function GetSourceType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	// Mozy003013	1279967 	2020-04-18	注释并修正隐藏元素
	//SetElement("SourceType",data.TRowID);
	//SetElement("SourceType_Desc",data.TDesc);
	rowData.CTLSourceType=data.TRowID
	SetElement("CTLSourceTypeDesc",data.TDesc);
	SetElement("CTLSourceType",data.TRowID);
	//Mozy	865594	2019-5-9	重新加载来源数据
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
	// Mozy003012	2020-04-15	增加明细行重复判断
	var rows = $('#DHCEQContract').datagrid('getRows'); 
	if(data.TSourceID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// Mozy003013	1280145 	2020-04-18	过滤重复选中
			if ((i!=editIndex)&&(rows[i].CTLSourceType==getElementValue("CTLSourceType"))&&(rows[i].CTLSourceID==data.TSourceID))
			{
				messageShow('alert','error','提示',t[-9240].replace("[RowNo]",(i+1)))
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
// 需求：741240		2018-11-12
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
        var objGrid = $("#DHCEQContract");		// 表格对象
        // Mozy003013	1279967 	2020-04-18	对选中明细行参数进行赋值
        setElement("CTLSourceTypeDesc", objGrid.datagrid('getSelected').CTLSourceType_Desc);
        setElement("CTLSourceType", objGrid.datagrid('getSelected').CTLSourceType);
        setElement("CTLSourceID",objGrid.datagrid('getSelected').CTLSourceID);
        setElement("CTLRowID",objGrid.datagrid('getSelected').CTLRowID);
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'});	// 数量
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
            // 根据数量变更后计算 金额
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQContract').datagrid('getSelected');
			rowData.CTLTotalFee=quantityNum*originalFee;
			$('#DHCEQContract').datagrid('endEdit',editIndex);
        });
		// Mozy003011	2020-04-14	增加单价触发事件
        $(invPriceFeeEdt.target).bind("blur",function(){
            // 根据数量变更后计算 金额
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

//add by csj 20190809 供模态窗回调刷新列表
function reloadDatagrid()
{
	$('#DHCEQContract').datagrid('reload');
}
//add by csj 20190809 通用名
function GetMasterItem(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLItemDR=data.TRowID;
	var editor =$('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLItem'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	var rows = $('#DHCEQContract').datagrid('getRows');
}
//add by zy 20190809 通知验收
function ArriveConfirmClickHandler(index) 
{
	if (getElementValue("CTStatus")<2)
	{
		messageShow('alert','error','错误提示','请先确保合同信息处于审核状态!');	// Mozy0230		2019-11-11	1090361
		return;
	}
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','错误提示','无合同信息!');	// Mozy0230		2019-11-11	1090361
		return;
	}
	var url="dhceq.em.arrive.csp?&SourceType=1&SourceID="+rowData.CTLRowID
	//alertShow(url)
	showWindow(url,"验收通知","350","10row","icon-w-paper","modal","","","");    //modify by lmm 2020-06-02 UI
	
}
///add by zy 20190919
function MenuMasterItem()
{
	// Mozy003011	2020-04-14	修正合同业务中“名称字典库”链接
	var url='dhceqcmasteritem.csp?&ReadOnly=';
	if ((getElementValue("CTStatus")>0)||(getElementValue("ReadOnly")==1)) url=url+"1";
	showWindow(url,"设备通用名称字典库","","","icon-w-paper","modal","","","verylarge");	//modify by lmm 2020-06-04 UI
}

//add by CZF0055 2020-02-20
//合同作废
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
		messageShow("confirm","","","是否作废该合同?","",ConfirmOpt,DisConfirmOpt);	// Mozy003006		2020-04-03
	}
}
// Mozy003006		2020-04-03	UI评审修正
function ConfirmOpt()
{
	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CancelBuss",4,getElementValue("CTRowID"));
	var result=results.split("^")
	if (result[0]!="0")
	{
		if (result[1]!="")
		{
			messageShow("","","","操作失败:"+result[1])
		}
		else
		{
			messageShow("","","","操作失败:"+result[0])
		}
	}
	else
	{
		messageShow("","","","成功作废!")
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
		messageShow('alert','error','错误提示','请先保存单据!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var value=getElementValue("CTContractType");
	
	if (value==0)
	{
		//Modefied by zc0060 20200329 文件上传改造  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		//Modefied by zc0060 20200329 文件上传改造  end
	}
	else
	{
		//Modefied by zc0060 20200329 文件上传改造  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		//Modefied by zc0060 20200329 文件上传改造  end
	}
	showWindow(str,"电子资料","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-04
}

//add by CZF0090 2020-03-06
function BProvider_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly");
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCVendor&ReadOnly="+ReadOnly;
	showWindow(str,"公司信息维护","","","icon-w-paper","modal","","","verylarge");		//modified by lmm 2020-06-04
}

//add by CZF0067 2020-03-12
function initCTHold1()
{
	var CTHold1 = $HUI.combobox('#CTHold1',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '1',text: '设备合同'},{id: '2',text: '工程合同'},{id: '3',text: '软件合同'}],
		onSelect : function(){}
	});
}
//add by Mozy003018 1279498 2020-04-27	合同设备属性
function EquipAttributeClickHandler(index) 
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','错误提示','保存合同信息后才可以进行设备属性设置!');
		return;
	}
	
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	var url='dhceq.em.equipattributelist.csp?SourceType=4&SourceID='+rowData.CTLRowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"合同设备属性","","","icon-w-paper","modal","","","middle");  //modify by lmm 2020-06-04 UI
}
// MZY0026	1279490		2020-05-22
function ScheduledDateClickHandler(index)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','错误提示','保存合同信息后才可以进行预警设置!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	var url='dhceq.plat.busswarndays.csp?SourceType=75&SubType=94-1&SourceID='+rowData.CTLRowID+"&WarnDay="+rowData.CTLContractArriveDate+"&ReadOnly="+ReadOnly+"&Name="+rowData.CTLName;
	showWindow(url,"预警设置","","","icon-w-paper","modal");
}