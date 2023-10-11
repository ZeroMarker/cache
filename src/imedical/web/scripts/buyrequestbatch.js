///批量采购申请
///Add By czf 1837956 2021-05-18
var editIndex=undefined;
var modifyBeforeRow = {};
var BRRowID=getElementValue("BRRowID");
var Columns=getCurColumnsInfo('EM.G.BuyRequest.BuyReqList','','','')
var objtbl=$('#DHCEQBuyReqList');
var delRow=[];

$(function(){
	initDocument();	
});
function initDocument()
{
	setElement("BRRequestDate",GetCurrentDate());
    setElement("BRRequestLocDR_CTLOCDesc",getElementValue("BRRequestLoc"));
    setElement("BREquipTypeDR_ETDesc",getElementValue("BREquipType"));
    initUserInfo();	//获取所有session值
    initMessage("BuyReqList"); //获取入参js业务和通用消息
    initLookUp(); //初始化放大镜
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"BRManageLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("BRManageLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
    //czf 1969255 2021-06-17
    var ETParams=[{"name":"Desc","type":"1","value":"BREquipTypeDR_ETDesc"},{"name":"GroupID","type":"3","value":curGroupID},{"name":"Flag","type":"2","value":"0"},{"name":"FacilityFlag","type":"2","value":"0"},{"name":"ManageLocID","type":"4","value":"BRManageLocDR"}];
    singlelookup("BREquipTypeDR_ETDesc","PLAT.L.EquipType",ETParams,"");
    defindTitleStyle();
    initButton(); //按钮初始化
    //initButtonWidth();	//初始化按钮宽度
    initPage();//非通用按钮初始化
    setRequiredElements("BRManageLocDR_CTLOCDesc^BREquipTypeDR_ETDesc");	//modified by csj 20191112 类组必填
    fillData(); //数据填充
    setEnabled(); //按钮控制
    initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"));	//add by csj 20190806 
    initApproveButtonNew(); //初始化审批按钮
    initDataGrid();	//初始化datagrid
    var Action=getElementValue("Action");
    if((getElementValue("BRStatus")!=1)||((Action!="BuyReq_Research")&&(Action!="BuyReq_Decision")))
    {
	    objtbl.datagrid('getColumnOption', 'BRAIAuditQuantity').editor = {};
        objtbl.datagrid('getColumnOption', 'BRAIAuditPrice').editor = {};
	}
	if(getElementValue("YearFlag")!="Y")
	{
		hiddenObj("BRYear",1);
		hiddenObj("cBRYear",1);
		hiddenObj("YearRemark",1)
		$('input#BRYearFlag').next().css('display','none');
	}
	else
	{
		setElement("BRYearFlag","Y");
		disableElement("BRYearFlag",true);
		setRequiredElements("BRYear",true)
	}
}

function initCheckBox()
{
	$("#BRYearFlag").checkbox({
	    onCheckChange:function(){
			if(this.checked){
				disableElement("BRYear",false);
			}
			else{
				disableElement("BRYear",true);
			}
		}
	})
}

function initDataGrid()
{
	var BuyReqGrid=$HUI.datagrid("#DHCEQBuyReqList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSBuyRequest",
	        	QueryName:"GetBuyRequestList",
				RowID:BRRowID,
				Step:getElementValue("RoleStep")
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
	        }, 
	        {
	            iconCls: 'icon-cancel',	
	            text:'删除',
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
}

//添加“合计”信息
function creatToolbar()
{
	var lable_innerText='申请总数量:'+getElementValue("BRQuantityNum")+'&nbsp;&nbsp;&nbsp;申请总金额:'+getElementValue("BRTotalFee");
	$("#sumTotal").html(lable_innerText);
	var panel = objtbl.datagrid("getPanel");	
	var BRStatus=getElementValue("BRStatus");
	if (BRStatus>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
	}
	if (BRStatus==1)	//提交状态默认打开首行列编辑器
	{
		var rows = $("#DHCEQBuyReqList").datagrid('getRows');
		if(rows.length>0) onClickRow(0);
	}
}
//非通用按钮初始化
function initPage() 
{	
	if (jQuery("#showOpinion").length>0)
	{
		jQuery("#showOpinion").on("click", BShowOpinion_Clicked);
	}
}

function fillData()
{
	if (BRRowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetOneBuyRequest",BRRowID)
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	var ApproveListInfo=tkMakeServerCall("web.DHCEQApproveList","GetApproveByRource","1",BRRowID)
	FillEditOpinion(ApproveListInfo,"EditOpinion")
}

function setEnabled()
{
	var BRStatus=getElementValue("BRStatus");
	var Type=getElementValue("Type");
	var ReadOnly=getElementValue("ReadOnly");
	if (BRStatus!="0")
	{
		setElement("ReadOnly","1");
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		if (BRStatus!="")
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
	//add by csj 2020-04-02 重新计算面板高度
	var eqtableHeight=$("#BRLTable>.eq-table").height()
	var northHeight=$("#BRLTable").height()
	var offset=northHeight-eqtableHeight
	$("#BRLTable").height($("#BRLTable>.eq-table").height())
	$("#BRLGrid").parent().css({"top":$("#BRLGrid").parent().position().top-offset})
	$("#BRLGrid").height($("#BRLGrid").height()+offset)
	$("#BRLGrid .panel-body").height($("#BRLGrid .panel-body").height()+offset)
	$("#BRLGrid .datagrid-wrap").height($("#BRLGrid .datagrid-wrap").height()+offset)
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

// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		objtbl.datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
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
			messageShow("alert",'info',"提示",t[-9242]);	//当前行不可删除
			return
		}
		objtbl.datagrid('endEdit', editIndex);	//结束编辑，传入之前编辑的行
		var BRLRowID=objtbl.datagrid('getRows')[editIndex].BRLRowID
		delRow.push(BRLRowID)
		objtbl.datagrid('deleteRow',editIndex);
		ChangeTotal()
	}
	else
	{
		messageShow("alert",'info',"提示",t[-9243]);	//请选中一行
	}
	
}

function BClear_Clicked()
{
	var url='dhceq.em.buyrequestbatch.csp?QXType=&Type=0&WaitAD=off&Hold1=1';
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}

function BSave_Clicked()
{
    if (checkMustItemNull()) return;
	var combindata=JSON.stringify(getInputList()); 	//总单信息
  	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
  	var DelRowid=delRow.join(',')	//GetDelRowid();
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SaveBatchData",combindata,valList,DelRowid,curUserID);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','info','提示',t[0]);	//操作成功
		var url='dhceq.em.buyrequestbatch.csp?WaitAD=off&RowID='+jsonData.Data+"&Type="+getElementValue("Type");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	else
	{
		messageShow('alert','error','提示',t[-9200]+jsonData.Data);
	}

}

function BDelete_Clicked()
{
	messageShow("confirm","","",t[-9203],"",truthBeTold,Cancel);
	
	function truthBeTold(){
		var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SaveData",BRRowID,1);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			messageShow('alert','error','提示',t[-9200]+jsonData.Data);
			return
	    }
	    else
	    {
		    var url="dhceq.em.buyrequestbatch.csp?WaitAD=off&Type="+getElementValue("Type")+"&YearFlag="+getElementValue("YearFlag");
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
		    window.location.href= url;
		}

	}
	function Cancel(){
		return
	}	

}

function BSubmit_Clicked()
{
	if (checkMustItemNull()) return;
	var combindata=JSON.stringify(getInputList()); 	//总单信息
  	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
	var DelRowid=delRow.join(',');	//GetDelRowid();
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SaveBatchData",combindata,valList,DelRowid,curUserID);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		combindata=GetAuditData();
		jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SubmitData",BRRowID);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
	    {
		    var WaitAD=getElementValue("WaitAD");
			var QXType=getElementValue("QXType");
			var BRYearFlag=getElementValue("BRYearFlag");
			var Action=getElementValue("Action");
			var RoleStep=getElementValue("RoleStep");
			var val="&RowID="+jsonData.Data+"&ReadOnly=1&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		    var url='dhceq.em.buyrequestbatch.csp?'+val;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
		    window.location.href=url;
		}
	    else
	    {
		    messageShow('alert','error','提示',t[-9200]+jsonData.Data);
			return
	    }

	}
	else
	{
		messageShow('alert','error','提示',t[-9200]+jsonData.Data);
	}
}

function BCancelSubmit_Clicked()
{
	if (BRRowID=="")
	{
		alertShow("没有申请单取消!");
		return;
	}
	if (getElementValue("RejectReason")=="")
	{
		setFocus("RejectReason");
		messageShow('alert','error','提示',t[-9234])	//"拒绝原因不能为空!"
		return
	}
	var combindata=GetAuditData();
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","CancelSubmitData",combindata,getElementValue("CurRole"));
	jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
	    var WaitAD=1;
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep+"&ReadOnly=1";
	    var url='dhceq.em.buyrequestbatch.csp?'+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
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
	if (BRRowID=="")
	{
		alertShow("没有申请单审核!");
		return;
	}
	if (checkMustItemNull("")) return
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
	var Action=getElementValue("Action")
	
	var rows = $("#DHCEQBuyReqList").datagrid('getRows');
	var RowNo = 0;
	for (var i = 0; i < rows.length; i++) 
	{
		RowNo+=1;
		var BRLRequestNum=parseInt(rows[i].BRLRequestNum);
		var BRAIAuditQuantity=parseInt(rows[i].BRAIAuditQuantity);
		if(BRAIAuditQuantity>BRLRequestNum)  
		{
			messageShow("","","","第"+RowNo+"行填写当前意见数量大于申请数量!")
			return;
		}
		//Add By QW20210729 BUG:QW0143 Begin
		if((setListEditable(objtbl)==0)&&(BRAIAuditQuantity==0)){
			messageShow("","","","第"+RowNo+"行填写当前意见数量为0!")
			return;
		}
		//Add By QW20210729 BUG:QW0143 end
	}
																				
	if ((getElementValue("BuyUserDR")=="")&(Action=="BuyReq_Assign"))
	{
		url="dhceq.em.buyrequestassign.csp?&Action="+Action+"&RowIDs="+BRRowID+"&CurRole="+CurRole+"&RoleStep="+RoleStep;
		messageShow('confirm','info','提示',"当前步骤需要派单给采购员!","",confirmFun,"");
		return;
	}
	
	var combindata=GetAuditData();
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,"",curUserID);
    var jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		var url="dhceq.em.buyrequestbatch.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
    else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

function confirmFun()
{
	showWindow(url,"分配采购员","","","icon-w-paper","modal","","","small",reloadGrid)
}

//获取列表明细
function GetTableInfo()
{
	var valList="";
	if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = 0;
	for (var i = 0; i < rows.length; i++) 
	{
		//rows[i].BRLTotalFee=rows[i].BRLQuantityNum*rows[i].BRLPriceFee;
		rows[i].BRLTotalFee=rows[i].BRLRequestNum*rows[i].BRLHold10;
		RowNo=i+1;
		var BRLRow=(typeof rows[i].BRLRow == 'undefined') ? "" : rows[i].BRLRow
		var BRLRowID=(typeof rows[i].BRLRowID == 'undefined') ? "" : rows[i].BRLRowID
		var BRLName=(typeof rows[i].BRLName == 'undefined') ? "" : rows[i].BRLName
		if(BRLName=="")
		{
			messageShow('alert','error','提示',t[-9251].replace('[RowNo]',RowNo))	//"第[RowNo]行设备名称不能为空!"
			return -1
		}
		
		var BRLItemDR=(typeof rows[i].BRLItemDR == 'undefined') ? "" : rows[i].BRLItemDR
		if(BRLItemDR!="")
		{
			var MasterItemInfo=tkMakeServerCall("web.DHCEQCMasterItem","GetDocByID","","",BRLItemDR)
		    if (MasterItemInfo.split("^")[3]!=getElementValue("BREquipTypeDR"))
		    {
			    messageShow('alert','error','提示',t[-9220].replace('[RowNo]',RowNo))	//"第"+RowNo+"行明细数据与主单类组不一致!"
			    return -1
		    }
		    
		    var BRLModel=(typeof rows[i].BRLModelDR_MDesc == 'undefined') ? "" : rows[i].BRLModelDR_MDesc
			if (BRLModel!="")
			{
				var RModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",BRLModel,BRLItemDR)
			    if (RModelDR<=0)
			    {
				    messageShow("","","",t[-9247].replace('[RowNo]',RowNo))	//"第[RowNo]行规格型号登记错误!"
				    return -1
			    }
			    else
			    {
				    rows[i].BRLModelDR=RModelDR;
			    }
			}
			else
			{
				rows[i].BRLModelDR=""
			}

		}
		else
		{
			//messageShow('alert','error','错误提示',t[-9250].replace('[RowNo]',RowNo));	//"第[RowNo]行设备项不能为空!"
			//return -1
		}
		
		for(var j=i+1;j<rows.length;j++){
			if ((rows[i].BRLName==rows[j].BRLName)&&(rows[i].BRLModelDR==rows[j].BRLModelDR))
			{
				messageShow('alert','error','提示',t[-9249].replace('[RowNoi]',RowNo).replace('[RowNoj]',j+1))	//'第[RowNoi]行与第[RowNoj]行重复!'
				return -1;
			}
		}
		
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
		messageShow('alert','error','提示',t[-9248]);	//"列表明细不能为空!"
		return -1;
	}
	return valList;
}

function GetAuditData()
{
	var ValueList="";
	ValueList=BRRowID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EditOpinion");
  	ValueList=ValueList+"^"+getElementValue("OpinionRemark");
	ValueList=ValueList+"^"+getElementValue("RejectReason");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("RoleStep");	//czf 2021-05-17 begin
	ValueList=ValueList+"^"+getElementValue("ActionID");
	ValueList=ValueList+getElementValue("SplitNumCode");
	var Action=getElementValue("Action");
	if ((Action=="BuyReq_Research")||(Action=="BuyReq_Decision"))	//调研意见或决策意见才保存审批情况
	{
		if ($("#DHCEQBuyReqList").length>0)		//批量采购申请
		{
			var rows = $("#DHCEQBuyReqList").datagrid('getRows');
			var RowNo = ""
			for (var i = 0; i < rows.length; i++) 
			{
				var val=rows[i].BRAIRowID;
				val=val+"^"+rows[i].BRLRowID;
				val=val+"^"+rows[i].BRAIAuditQuantity;
				val=val+"^"+rows[i].BRAIAuditPrice;
				val=val+"^"+rows[i].BRAIAuditTotalFee;
				val=val+"^"+rows[i].BRAIHold1;
				val=val+"^"+rows[i].BRAIHold2;
				val=val+"^"+rows[i].BRAIHold3;
				val=val+"^"+rows[i].BRAIHold4;
				val=val+"^"+rows[i].BRAIHold5;
				ValueList=ValueList+val;
				ValueList=ValueList+val+getElementValue("SplitRowCode");
			}
		}
		else
		{
			ValueList=ValueList+"^"+getElementValue("BRAIRowID");	//7
			ValueList=ValueList+"^"+getElementValue("BRLRowID");	//BRLRowID
			ValueList=ValueList+"^"+getElementValue("BRAIAuditQuantity");
			ValueList=ValueList+"^"+getElementValue("BRAIAuditPrice");
			ValueList=ValueList+"^"+getElementValue("BRAIAuditTotalFee");
			ValueList=ValueList+"^"+getElementValue("BRAIHold1");
			ValueList=ValueList+"^"+getElementValue("BRAIHold2");
			ValueList=ValueList+"^"+getElementValue("BRAIHold3");
			ValueList=ValueList+"^"+getElementValue("BRAIHold4");
			ValueList=ValueList+"^"+getElementValue("BRAIHold5");
		}
	}
	return ValueList;		//czf 2021-05-17 end
}

function onClickRow(index)
{
	var BRStatus=getElementValue("BRStatus");
	
	if (BRStatus>0 && setListEditable(objtbl)==-1) return	//调用是否列表可编辑字段公共方法
	if (editIndex!=index)
	{
		if (endEditing())
		{
			objtbl.datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},objtbl.datagrid('getRows')[editIndex]);
			bindGridEvent(); //编辑行监听响应
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

function GetMasterItem(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
	setElement("EQItemDR",data.TRowID);		//czf 机型过滤 1950247
	rowData.BRLItemDR=data.TRowID;
	var ItemEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLItemDR_MIDesc'}); 
	$(ItemEdt.target).combogrid("setValue",data.TName);
	var BRLNameEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLName'}); 
	$(BRLNameEdt.target).val(data.TName);
	rowData.BRLUnitDR=data.TUnitDR;
	rowData.BRLUnitDR_UOMDesc=data.TUnit;
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetModel(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BRLModelDR=data.TRowID;
	var ModelDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLModelDR_MDesc'}); 
	$(ModelDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetFundsType(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BRLFundsOriginDR=data.TRowID;
	var FundsOriginDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLFundsOriginDR_FTDesc'});
	$(FundsOriginDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetPurchaseType(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BRLPurchaseTypeDR=data.TRowID;
	var PurchaseTypeDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLPurchaseTypeDR_PTDesc'}); 
	$(PurchaseTypeDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetPurposeType(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BRLPurposeTypeDR=data.TRowID;
	var PurposeTypeDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLPurposeTypeDR_PTDesc'}); 
	$(PurposeTypeDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function GetManuFacturer(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.BRLManuFacDR=data.TRowID;
	var ManuFactoryDescEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLManuFacDR_MFDesc'}); // 
	$(ManuFactoryDescEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var invQuantityEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLRequestNum'});
        var invPriceFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRLHold10'});
  		
  		var invAuditQuantityEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRAIAuditQuantity'});
        var invAuditPriceFeeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'BRAIAuditPrice'});
        setElement("EQItemDR",objtbl.datagrid('getSelected').BRLItemDR)		//czf 机型过滤 1950247
        
        // 数量  绑定 离开事件 
        if(invQuantityEdt){
	        $(invQuantityEdt.target).bind("blur",function(){
	            // 根据数量变更后计算 金额
	            var quantityNum=parseInt($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = objtbl.datagrid('getSelected');
				rowData.BRLTotalFee=quantityNum*originalFee;
				objtbl.datagrid('endEdit',editIndex);
        	});
	    }
        if(invPriceFeeEdt){
	        $(invPriceFeeEdt.target).bind("blur",function(){
	            // 根据数量变更后计算 金额
	            var quantityNum=parseInt($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = objtbl.datagrid('getSelected');
				rowData.BRLTotalFee=quantityNum*originalFee;
				objtbl.datagrid('endEdit',editIndex);
        	});
	    }
	    if(invAuditQuantityEdt){
			$(invAuditQuantityEdt.target).bind("blur",function(){
	            // 根据数量变更后计算 金额
	            var quantityNum=parseInt($(invAuditQuantityEdt.target).val());
	            var originalFee=parseFloat($(invAuditPriceFeeEdt.target).val());
	            var rowData = objtbl.datagrid('getSelected');
				rowData.BRAIAuditTotalFee=quantityNum*originalFee;
				objtbl.datagrid('endEdit',editIndex);
        	});
		}
		if(invAuditPriceFeeEdt){
			$(invAuditPriceFeeEdt.target).bind("blur",function(){
	            // 根据数量变更后计算 金额
	            var quantityNum=parseInt($(invAuditQuantityEdt.target).val());
	            var originalFee=parseFloat($(invAuditPriceFeeEdt.target).val());
	            var rowData = objtbl.datagrid('getSelected');
				rowData.BRAIAuditTotalFee=quantityNum*originalFee;
				objtbl.datagrid('endEdit',editIndex);
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
        var colNumValue=rows[i]["BRLRequestNum"];
        if (isNaN(colNumValue)) colNumValue=0;
        if (colNumValue=="") colNumValue=0;
        totalQuantityNum += parseInt(+colNumValue);
        var colPrice=rows[i]["BRLHold10"];
        if (isNaN(colPrice)) colPrice=0;
        if (colPrice=="") colPrice=0;
        var colFeeValue=parseInt(colNumValue)*parseFloat(colPrice);
        //colFeeValue=rows[i]["BRLTotalFee"];
        //if (isNaN(colFeeValue)) colFeeValue=0;
        totalTotalFee += parseFloat(+colFeeValue);
    }
    var lable_innerText='申请总数量:'+totalQuantityNum+'&nbsp;&nbsp;&nbsp;申请总金额:'+totalTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}

/// Add By ZY 2011-03-10
/// 描述:把当前角色的审批意见放到意见编辑栏中;
/// 参数:value:Role1,Step1,Opinion1^Role2,Step2,Opinion2
/// 	 ename:意见编辑栏元素的名字
///      根据CurRole来取当前角色以前的意见
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

function CheckInvalidData(i)
{
	var rows = objtbl.datagrid('getRows');
	var oneRow=rows[i]
	var RowNo=i+1
	if ((oneRow.BRLRequestNum=="")||(IsValidateNumber(oneRow.BRLRequestNum,0,0,0,0)==0))
	{
		messageShow('alert','error','提示',t[-9244].replace('[RowNo]',RowNo));	//数量不正确
		return "-1";
	}
	if ((oneRow.BRLHold10=="")||(IsValidateNumber(oneRow.BRLHold10,0,1,0,0)==0))
	{
		messageShow('alert','error','提示',t[-9245].replace('[RowNo]',RowNo));	//金额不正确
		return "-1";
	}
	return false;
}
///Add by jdl 2011-3-22
///判断是否为数字
///入参?NumStr验证的字符串
///		AllowEmpty:是否允许为空
///		AllowDecimal?是否允许小数
///		AllowNegative?是否允许负数
///		AllowZero:是否允许零
///	返回值?0:无效
///			1:有效
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
	//判断是否负数
	if ((NumStr<0)&&(AllowNegative!="1")) return "0";
	//判断是否整数
	if ((parseInt(NumStr)!=NumStr)&&(AllowDecimal!="1")) return "0";
	if ((parseFloat(NumStr)==0)&&(AllowZero=="0")) return "0";
	return "1";	
}


function getParam(vQueryParams){
	if(vQueryParams=="BRLRowID"){
		return objtbl.datagrid('getSelected').BRLRowID==undefined?"":objtbl.datagrid('getSelected').BRLRowID;
	}
	return ""
}


function BShowOpinion_Clicked()
{
	url="dhceq.plat.approvelist.csp?&BussType=91&BussID="+getElementValue("BRRowID");
	showWindow(url,"采购申请审批进度","","","icon-w-paper","modal","","","middle");
}

function BPrint_Clicked(){ 
	var PreviewRptFlag=getElementValue("PreviewRptFlag");  //增加预览标志
	var fileName=""	
	if(PreviewRptFlag==0)
	{ 
	 	fileName="{DHCEQBuyRequestPrint.raq(rowid="+getElementValue("BRRowID")+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	if(PreviewRptFlag==1)
	{ 
		fileName="DHCEQBuyRequestPrint.raq&rowid="+getElementValue("BRRowID");
		DHCCPM_RQPrint(fileName); 
	}
}

function reloadGrid()
{
	var WaitAD=getElementValue("WaitAD"); 
	var QXType=getElementValue("QXType");
	var BRYearFlag=getElementValue("BRYearFlag");
	var Action=getElementValue("Action");
	var RoleStep=getElementValue("RoleStep");
	var RowID=getElementValue("BRRowID");
	var val="&RowID="+RowID+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
	var url="dhceq.em.buyrequestbatch.csp?"+val
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}

///审批明细弹窗
function BAuditList(editIndex)
{
	var rowData =  objtbl.datagrid("getRows")[editIndex];
	var BRLRowID= rowData.BRLRowID;
	
	if ($("#_BRAIAuditInfoWin").length==0){
		$("<div id=\"_BRAIAuditInfoWin\" />").prependTo("body");
	}
	var gridObj = "";
	var obj = $HUI.dialog('#_BRAIAuditInfoWin',{
		width:650,
		modal:true,
		height:300,
		title:'审批记录',
		content:'<table id="_BRAIAuditInfoGrid"></table>',
		buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#_BRAIAuditInfoWin").close();
			}
		}],
		onOpen:function(){
			gridObj = $HUI.datagrid("#_BRAIAuditInfoGrid",{
				mode: 'remote',
				fit:true,
				border:false,
				pagination:false,
				showPageList:false,
				showRefresh:false,
				singleSelect:true,
	    		rownumbers: true,
				queryParams:{ClassName:"web.DHCEQ.EM.BUSBuyRequest",QueryName: 'GetBuyReqAuditInfo',BRLRowID:BRLRowID},
				url: $URL,
				columns: [[
					{field:"BRAIRowID",title:"BRAIRowID",align:"left",hidden:true,width:10},
					{field:"BRAIAuditQuantity",title:"审批数量",align:"right",width:80},
					{field:"BRAIAuditPrice",title:"审批单价",align:"right",width:80},
					{field:"BRAIAuditTotalFee",title:"审批总价",align:"right",width:80},
					{field:"BRAIAction",title:"审批角色",align:"left",width:100},
					{field:"ALApproveUser",title:"审批人",align:"left",width:60},
					{field:"ALApproveDate",title:"审批日期",align:"left",width:150},
				]]
				})
		}
	});
	return gridObj;
}
