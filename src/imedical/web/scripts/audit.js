var editIndex=undefined;
var modifyBeforeRow = {};
var IFBRowID=getElementValue("IFBRowID");
var Columns=getCurColumnsInfo('EM.G.IFB.IFBList','','','')
$(function(){
	initDocument();
});
function initDocument()
{
	initUserInfo();
    //initMessage("InStock"); //获取所有业务消息
    initLookUp(); //初始化放大镜
	defindTitleStyle();
    initButton(); //按钮初始化
    initButtonWidth();
    initPage();
    //setRequiredElements("IFBPrjName^IFBNo^IFBOpenDate^IFBDeadlineDate");
    fillData(); //数据填充
    setEnabled(); //按钮控制
    initApproveButton(); //初始化审批按钮
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
	    rownumbers: true,  //如果为true，则显示一个行号列
	    toolbar:[
		    {
				iconCls: 'icon-add',
	            text:'新增',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },'----------',
	        {
	            iconCls: 'icon-remove',
	            text:'删除',
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

//添加“合计”信息
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
	var lable_innerText='总数量:'+totalIFBBQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalIFBBTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
	//图标影藏
    for (var i = 0; i < rows.length; i++) 
    {
    	if ((rows[i].IFBBExtendType=="")||(rows[i].IFBBExtendID==""))
	    {
		    $("#IFBBList"+"z"+i).hide()
		}
    }
	//按钮灰化
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
function initPage() //初始化
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
	if (Status!="0")
	{
		setElement("ReadOnly","1");
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		if (Status!="")
		{
			disableElement("BSave",true);
			disableElement("BClear",true);
		}
		else
		{
			setElement("ReadOnly","0");
		}
	}
	if (Type==1)
	{
		setElement("ReadOnly","1");
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

//hisui.common.js错误纠正需要
function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}
// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#DHCEQIFB").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#DHCEQIFB").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var IFBBBagNo = (typeof rows[lastIndex].IFBBBagNo == 'undefined') ? "" : rows[lastIndex].IFBBBagNo;
    var IFBBExtendType = (typeof rows[lastIndex].IFBBExtendType == 'undefined') ? "" : rows[lastIndex].IFBBExtendType;
    var IFBBExtendID = (typeof rows[lastIndex].IFBBExtendID == 'undefined') ? "" : rows[lastIndex].IFBBExtendID;
    if ((IFBBBagNo=="")||(IFBBExtendType=="")||(IFBBExtendID==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
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
		jQuery("#DHCEQIFB").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	$("#DHCEQIFB").datagrid('deleteRow',editIndex);
	}
    else if(editIndex=="0")
	{
		messageShow("alert",'info',"提示","当前行不可删除!");  //add by wy 需求:776577 2018-12-12
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}}
function BSave_Clicked()
{
	if (getElementValue("IFBPrjName")=="")
	{
		messageShow('alert','error','提示',"项目名称不能为空!")
		return
	}
	if (getElementValue("IFBNo")=="")
	{
		messageShow('alert','error','提示',"招标编号不能为空!")
		return
	}
	if (getElementValue("IFBOpenDate")=="")
	{
		messageShow('alert','error','提示',"开标日期不能为空!")
		return
	}
	if (getElementValue("IFBDeadlineDate")=="")
	{
		messageShow('alert','error','提示',"投标截止日期不能为空!")
		return
	}
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
		if ((oneRow.IFBBExtendType_Desc=="")||(oneRow.IFBBExtendID_Name==""))
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行数据不正确!");
			return "-1";
		}
		if (oneRow.IFBBBagNo=="")
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行[招标包号]不正确!");
			return "-1";
		}
        var IFBLVendor = (typeof oneRow.IFBLVendor== 'undefined') ? "" : oneRow.IFBLVendor;  //add by wy 2019-5-29 841877 
		if (IFBLVendor=="")
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行[供应商]不正确!");
			return "-1";
		}
	
	
		if ((oneRow.IFBBQuantity=="")||(IsValidateNumber(oneRow.IFBBQuantity,0,0,0,0)==0))
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行[数量]不正确!");
			return "-1";
		}
		if ((oneRow.IFBBWinPrice=="")||(IsValidateNumber(oneRow.IFBBWinPrice,0,1,0,1)==0))
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行[单价]不正确!");
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
				oneRow.IFBBModelDR_MDesc="";
				oneRow.IFBBModelDR="";
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
		messageShow('alert','error','提示',"招标明细不能为空!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","SaveData",data,dataList,Listinfo,0);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Type="+Type
		url="dhceq.em.ifbnew.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.SQLCODE);
		return
    }
}

function BDelete_Clicked()
{
	if (getElementValue("IFBRowID")=="")
	{
		messageShow('alert','error','提示',"没有招标删除!");
		return;
	}
	var data=getInputList();
	 data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","SaveData",data,"","",1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&Type="+getElementValue("Type");
		url="dhceq.em.ifbnew.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.SQLCODE);
		return
    }
}
function BSubmit_Clicked()
{
	if (getElementValue("IFBRowID")=="")
	{
		messageShow('alert','error','提示',"没有招标信息提交!");
		return;
	}
	var combindata=getValueList();
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFB","SubmitData",combindata);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		url="dhceq.em.ifbnew.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.SQLCODE);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (getElementValue("IFBRowID")=="")
	{
		messageShow('alert','error','提示',"没有招标信息取消!");
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
		var val="&RowID="+getElementValue("IFBRowID")+"&Status="+Status+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType+"&ApproveRole="+ApproveRole;
		url="dhceq.em.ifbnew.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
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
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&ApproveRole="+ApproveRole;
		url="dhceq.em.ifbnew.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
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
			bindGridEvent(); //编辑行监听响应
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
	//根据来源类型刷新来源数据集
    //modifed by wy 2018-12-24 783404
    var ExtendIDEdt = $("#DHCEQIFB").datagrid('getEditor', {index:editIndex,field:'IFBBExtendType_Desc'});
	$(ExtendIDEdt.target).combogrid("setValue",data.TDesc);
	$('#DHCEQIFB').datagrid('endEdit',editIndex);

}
function GetExtendID(index,data)
{
	var rowData = $('#DHCEQIFB').datagrid('getSelected');
	//rowData.IFBBExtendType=getElementValue("IFBBExtendType");
	rowData.IFBBExtendID=data.TExtendID;
	rowData.IFBBItemDR=data.TItemDR;
	rowData.IFBBItemDR_MIDesc=data.TItemDR;
	rowData.IFBBModelDR=data.TModelDR;
	rowData.IFBBModelDR_MDesc=data.TModel;
	rowData.IFBBManuFactoryDR=data.TManuFcDR
	rowData.IFBBManuFactoryDR_MFDesc=data.TManuFc
	rowData.IFBBWinPrice=data.TPriceFee;
	rowData.IFBBQuantity=data.TQuantityNum;
	rowData.IFBBAmount=data.TTotalFee;
	rowData.IFBBUnitDR=data.TUnitDR;
	rowData.IFBBUnitDR_UOMDesc=data.TUnit;
	rowData.IFBBItemDR_MIDesc=data.TName;
	rowData.IFBBHold1=data.TName;
	var objGrid = $("#DHCEQIFB");        // 表格对象
	var ExtendTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBExtendType_Desc'}); // 设备名称
	$(ExtendTypeDescEdt.target).combogrid("setValue",getElementValue("IFBBExtendType_Desc"));
	var ExtendNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBExtend_Name'}); // 设备名称
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
        var objGrid = $("#DHCEQIFB");		// 表格对象
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBQuantity'});	// 数量
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'IFBBWinPrice'});
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
            // 根据数量变更后计算 金额
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
            var rowData = $('#DHCEQIFB').datagrid('getSelected');
			rowData.TAmount=quantityNum*originalFee;
			$('#DHCEQIFB').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        alertShow(e);
    }   
}
function CheckDateTimeCheck()  
{
	var OpenDate = new Date(FormatDate(getElementValue("IFBOpenDate")).replace(/\-/g, "\/"))     //modified by wy 需求：782084
	var DeadlineDate=new Date(FormatDate(getElementValue("IFBDeadlineDate")).replace(/\-/g, "\/"))
	if (OpenDate>DeadlineDate)
	{
		messageShow('alert','error','提示',"截至日期不能早于开标日期");
		return true
	}
	var BuyFileFromDate=new Date(FormatDate(getElementValue("IFBBuyFileFromDate")).replace(/\-/g, "\/"));
	var BuyFileToDate=new Date(FormatDate(getElementValue("IFBBuyFileToDate")).replace(/\-/g, "\/"))
	if ((""!=BuyFileFromDate)&&(""!=BuyFileToDate))
	{
		if (BuyFileFromDate>BuyFileToDate)
		{
			messageShow('alert','error','提示',"购买标书开始日期不能晚于购买标书结束日期");
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
	if ((IFBBExtendType=="")||(IFBBExtendID==""))return;
	var IFBLVendorDR=rowData.IFBLVendorDR
	if (IFBLVendorDR=="")
	{
		messageShow('alert','error','提示',"供应商不能为空");
	}
	if (IFBRowID=="") return;
	var url="dhceq.em.ifblist.csp?";
	url=url+"&IFBBRowID="+IFBBRowID;
	url=url+"&SourceType="+IFBBExtendType;
	url=url+"&SourceID="+IFBBExtendID;
	url=url+"&ReadOnly="+GetElementValue("ReadOnly")
	showWindow(url,"应标供应商","","","icon-w-paper","modal","","","","large"); //modify by lmm 2020-06-05 UI
}