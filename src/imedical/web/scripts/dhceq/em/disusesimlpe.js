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
	setElement("DRDisuseTypeDR_DRDesc","到期报废");
    initMessage(); // add by wy 2020-01-16 QW20200218 BUG:QW0040
	defindTitleStyle(); 
	
	initLookUp(); //初始化放大镜
	
	initButton(); //按钮初始化
	initButtonWidth();
	setRequiredElements("DRRequestLocDR_CTLOCDesc^DRUseLocDR_CTLOCDesc^DREquipTypeDR_ETDesc"); //modified by csj 20191112 必填项id错误
	fillData();
	setEnabled();
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"));     //add by jyp 2020-02-27  JYP0020  报废信息表添加可编辑字段
	initApproveButton(); //初始化审批按钮
	//table数据加载
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
	    rownumbers:true,  //如果为true，则显示一个行号列
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
	            iconCls: 'icon-cancel',   //modified by wy 2020-4-23 UI调整
	            text:'删除',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        }
        ],
	    columns:Columns,
	    //rownumbers:false,  //modified by kdf 2019-03-01 	需求号：836884
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,30,75,100],
		onLoadSuccess:function(){
				creatToolbar();
			}
	});
	$("#BRecover").linkbutton({iconCls: 'icon-w-back'}); // add by wy 2020-01-16 QW20200218 BUG:QW0040//modified by wy 2020-4-23 UI调整
	jQuery('#BRecover').on("click", BRecover_Click); /// Add By QW20191008 BUG:QW0028 增加报废恢复按钮
	///Modiedy by zc0057 增加报废标签打印  begin
	jQuery("#BDisusePrintBar").linkbutton({iconCls: 'icon-w-print'});
	jQuery("#BDisusePrintBar").on("click", BDisusePrintBar_Click);
	//Modiedy by zc0057 增加报废标签打印   end
};

//添加“合计”信息
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
	var lable_innerText='总数量:'+totalDLQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalDLTotalFee.toFixed(2);
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
	//modified By QW20200512 BUG:QW0063 合计行问题 begin
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
	}
	//modified By QW20200512 BUG:QW0063 合计行问题 end
	var  job=$('#DHCEQDisuseRequestSimple').datagrid('getData').rows[0].DRJob; // modified by wy 2020-01-16 QW20200218 BUG:QW0040
	setElement("DRJob",job);
}

//add by kdf 2019-01-22
//填充数据
function fillData()
{
	var DRRowID=getElementValue("DRRowID")
	if (DRRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	
	
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","GetOneDisuseRequest",DRRowID,ApproveRoleDR,Action,Step)
	
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示","数据填充失败，错误代码"+jsonData.Data);return;}
	//modified By QW20191023 需求号:1065779 修改报废恢复执行成功无法刷新界面问题 
	if (jsonData.Data["DRInvalidFlag"]=="1")   return;  // modified by wy 2020-01-16 QW20200218 BUG:QW0040
	//End By QW20191023 需求号:1065779 修改报废恢复执行成功无法刷新界面问题 
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
    if (jsonData.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
	// Add By QW20191008 BUG:QW0028 报废单无效后初始化按钮
	if (jsonData.Data["DRInvalidFlag"]=="1")
	{
		disableElement("BRecover",true);
	}
	// End By QW20191008 BUG:QW0028
	
}

//add by kdf 2019-01-22
//按钮恢化
function setEnabled()
{ 
	var Status=getElementValue("DRStatus");
	var WaitAD=getElementValue("WaitAD");
	disableElement("DRHold4",true);
	disableElement("DRHold5",true);
	///Modiedy by zc0058  报废打印按钮提交后不可操作问题的处理  begin
	if ((Status=="")||(Status=="0"))
	{
		disableElement("BDisusePrintBar",true);
	}
	///Modiedy by zc0058  报废打印按钮提交后不可操作问题的处理  end
	if (Status!="0")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		///Modiedy by zc0058  报废打印按钮提交后不可操作问题的处理
		//disableElement("BDisusePrintBar",true);   ///Modiedy by zc0057 报废打印标签影藏 
		if (Status!="")
		{
			disableElement("BSave",true);
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		disableElement("BPrint",true); //Modified by QW20191022 BUG:QW0032 打印按钮初始化
		//disableElement("BPrintBar",true);
		disableElement("BRecover",true); // Add By QW20191008 BUG:QW0028 报废恢复按钮初始化
		///Modiedy by zc0058  报废打印按钮提交后不可操作问题的处理
		//disableElement("BDisusePrintBar",true);   ///Modiedy by zc0057 报废打印标签影藏 
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="false")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BSave",true);
	}
	///作废按钮
	// Add By QW20200218 begin BUG:QW0041 测试需求:报废权限限制
	//modified by wy 2020-4-18 1276569
	var RecoverFlag=getElementValue("RecoverFlag");
	if ((RecoverFlag=="1")&&(Status=="2"))
	{
		disableElement("BRecover",false); 
	}
	else{
		disableElement("BRecover",true);  
		
	}

	// Add By QW20200218 begin BUG:QW0041 测试需求修改
}


// modified by kdf 2019-01-10
// 填充行数据
// modified by wy 2020-01-16 QW20200218 BUG:QW0040
function getEquipList(index,data)
{
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	/// add by kdf 2019-05-27 begin 需求号：860203
	var rows = $('#DHCEQDisuseRequestSimple').datagrid('getRows');
		for(var i=0;i<rows.length;i++){
			if(data.TEquipDR!=="")
			{
				if((rows[i].DLSourceID!=="")&&(rows[i].DLSourceID==data.TEquipDR))
				{
					messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!')
					return;
				}
			}
			else {
			if(rows[i].DLNo==data.TInStockNo)
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!')
				return;
			}
		}
		//add by wy 2020-4-29 多批报废控制检测未到期设备 begin
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
				messageShow('alert','info','提示','当前第'+(i+1)+'行设备未到使用年限，不能报废！');
				return;
			}
			else
			{
					messageShow('alert','info','提示','当前第'+(i+1)+'行设备未到使用年限!');
			}
		}
        //add by wy 2020-4-29 多批报废控制检测未到期设备 end
	}
	var rowData = $('#DHCEQDisuseRequestSimple').datagrid('getSelected');
	rowData.DLSourceType=1
	rowData.DLSourceID=data.TInStockListDR
	rowData.DLNo=data.TInStockNo  //modified by wy 2020-4-30 多批赋值问题 bug WY0066
	if (data.TEquipDR!=="") 
	{
		rowData.DLSourceType=0
		rowData.DLSourceID=data.TEquipDR
		rowData.DLNo=data.TNo  //modified by wy 2020-4-30 多批赋值问题 bug WY0066

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
	//Modified BY QW20200320 BUG:QW0049 begin 选择设备后,不显示设备净值与累计折旧。
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
			bindGridEvent();  //编辑行监听响应 // modified by wy 2020-01-16 QW20200218 BUG:QW0040
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

// 插入新行 add by kdf 2019-01-10
function insertRow()
{
	if(editIndex>="0"){
		$("#DHCEQDisuseRequestSimple").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#DHCEQDisuseRequestSimple").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    if ((lastIndex>=0)&&(rows[lastIndex].DLSourceID==""))
    {
	    messageShow("alert","error","错误提示","第"+newIndex+"行数据为空!请先填写数据.");
	}
	else
	{
		$("#DHCEQDisuseRequestSimple").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		$("#DLEquipList"+"z"+newIndex).hide(); // modified by wy 2020-01-16 QW20200218 BUG:QW0040
	}
}

//删除行 ad by kdf 2019-01-10
function deleteRow()
{
	if (editIndex>="0")
	{
		$("#DHCEQDisuseRequestSimple").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		$('#DHCEQDisuseRequestSimple').datagrid('deleteRow',editIndex)
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}

// 下拉选择框事件
// modified by kdf 2019-01-10
// modified by wy 2020-01-16 QW20200218 BUG:QW0040
function setSelectValue(elementID,rowData)
{
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	if(elementID=="DRRequestLocDR_CTLOCDesc") {setElement("DRRequestLocDR",rowData.TRowID);}
	else if(elementID=="DRUseLocDR_CTLOCDesc") {setElement("DRUseLocDR",rowData.TRowID);}
	else if(elementID=="DRDisuseTypeDR_DRDesc") {setElement("DRDisuseTypeDR_DRDesc",rowData.TDesc);setElement("DRDisuseTypeDR",rowData.TRowID);} //Modified BY QW20200320 BUG:QW0050
    else if(elementID=="DREquipTypeDR_ETDesc") 
    	{
		setElement("DREquipTypeDR",rowData.TRowID);
		if(editIndex != undefined)
		{
			var sourceIDEdt = $("#DHCEQDisuseRequestSimple").datagrid('getEditor', {index:editIndex,field:'DLSource'});
   			$(sourceIDEdt.target).combogrid('grid').datagrid('load');
		}
	}
	// modified by wy 2020-01-16 end QW20200218 BUG:QW0040
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
	    window.location.href= url;

	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

// modified by kdf 2019-01-11
// 保存按钮事件
function BSave_Clicked()
{	
	// modified by wy 2020-01-16 begin QW20200218 BUG:QW0040
	if (checkMustItemNull()) return	
	//Add BY QW20200326 BUG:QW0052 begin 结束行编辑
	if(editIndex>="0"){
		jQuery("#DHCEQDisuseRequestSimple").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
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
			messageShow('alert','error','提示',"第"+(i+1)+"行数据不正确!");
			return "-1";
		}
	    oneRow["DLIndex"]=i; //index值处理 // modified by wy 2020-01-16 QW20200218 BUG:QW0040
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
		messageShow('alert','error','提示',"明细不能为空!");
		return;
	}
	disableElement("BSave",true)	//add by csj 2020-03-10 表单校验后禁用
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","SaveData",data,dataList,"0");

	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");

		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&Type=0"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 保存失败后启用
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}

// modified by kdf 2019-01-11
// 删除按钮事件
function BDelete_Clicked()
{
	
	var DRRowID=getElementValue("DRRowID")
	
	if (DRRowID=="")
	{
		messageShow("alert","error","错误提示","没有单据可删除!");
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
	    window.location.href= url;
	}
	else
    {
		messageShow("alert","error","错误提示","删除失败,错误信息:"+jsonData.Data);
		return
    }
}

// modified by kdf 2019-01-22
// 提交按钮事件
function BSubmit_Clicked()
{
	var DRRowID=getElementValue("DRRowID")
	if (DRRowID=="")
	{
		messageShow("alert","error","错误提示","没有单据可删除!");
		return;
	}
	
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","SubmitData",DRRowID);
	
	
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");

		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
		
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',"错误信息:"+jsonData.Data);
		return
    }
}

// add by kdf 2019-01-23 取消提交
function BCancelSubmit_Clicked()
{
	var DRRowID=getElementValue("DRRowID");
	
	if (DRRowID=="")
	{
		messageShow('alert','error','提示',"没有报废单取消!");
		return;
	}
	//add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录 begin
	var RoleStep=getElementValue("RoleStep");
	if(RoleStep=="1")
	{
		var vFlag=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetMergeOrderFlag",DRRowID);
		var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601006");
		if ((CheckFlag==1)&&(vFlag==0))
			{
				messageShow("confirm","","","继续操作还是取消(继续将无效汇总报废单中的对应明细记录)?","",function(){		
					BCancelData();
					},
					function(){return;})	
			}
		else {
				BCancelData();
			
			 }
		 
    }
    else{
		BCancelData();
    }

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
	    messageShow("alert","error","错误提示","错误信息:"+RtnObj.Data);
	    return;
    }
    else
    {
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
	    
	    var val="&RowID="+RtnObj.Data+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
		
	    window.location.href= url;
    }

}
	//add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录 end

/// add by kdf 2019-01-23
function GetOpinion()
{
	var ApproveRole=getElementValue("CurRole");
	var CurStep=getElementValue("RoleStep");
	var combindata=getElementValue("CurRole") ;
  	combindata=combindata+"^"+getElementValue("RoleStep") ;
  	combindata=combindata+"^"+getElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+getElementValue("OpinionRemark") ;
  	return combindata;
  	
}

/// add by kdf 2019-01-23 审核事件
function BApprove_Clicked()
{
	var RowID=getElementValue("DRRowID");
	if (RowID=="")  return;
	//begin add  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	var objtbl=getParentTable("DRRequestNo")  
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);   
	if (EditFieldsInfo=="-1") return;                    
	//end add  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	
	var combindata=RowID+"^"+GetOpinion()+"^^"; //Modified By QW20200119 BUG:QW0039
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","AuditData",combindata,"",EditFieldsInfo);   //modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段	
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
	    //window.location.reload();
	    var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
	    
	    var val="&RowID="+RtnObj.Data+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType;
		url="dhceq.em.disusesimlpe.csp?"+val;
	    window.location.href= url;
	}
    else
    {
	    messageShow("alert","error","错误提示","错误信息:"+RtnObj.Data);
	    return;
    } 
	
}
//add by wy 2020-01-16 QW20200218 BUG:QW0040
function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQDisuseRequestSimple");        // 表格对象
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'DLQty'});            // 数量
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQDisuseRequestSimple').datagrid('getSelected');
            var moveNum=parseFloat(rowData.DLQty);
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
            // 根据数量变更后计算 金额
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

//add by wy 2020-01-16 QW20200218 BUG:QW0040元素参数重新获取值
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
//add by wy 2020-01-16 QW20200218 BUG:QW0040设备明细点击弹窗
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
	showWindow(url,"设备明细列表","","","icon-w-paper","modal","","","small",mth);   
}
//add by wy 2020-01-16  QW20200218 BUG:QW0040设备明细保存后调用修改数量与金额
function mth(index,quantity)
{
	$('#DHCEQDisuseRequestSimple').datagrid('selectRow', index).datagrid('beginEdit', Number(index));
	var rowData = $('#DHCEQDisuseRequestSimple').datagrid('getSelected');
	var objGrid = $("#DHCEQDisuseRequestSimple");        // 表格对象
    var quantityEdt = objGrid.datagrid('getEditor', {index:index,field:'DLQty'}); // 数量
	$(quantityEdt.target).val(quantity);
	var originalFee= (typeof rowData.DLHold1 == 'undefined') ? "" : rowData.DLHold1;
	rowData.DLTotalFee=quantity*originalFee;
	$('#DHCEQDisuseRequestSimple').datagrid('endEdit',Number(index));  
}
//Add By QW20191008 BUG:QW0028
//增加报废恢复功能
function BRecover_Click()
{
	var DRRowID=getElementValue("DRRowID")
	var Result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","RecoverDisUseEquip",DRRowID);
	var	list=Result.split("^");
	if (list[0]!=0)
	{
		messageShow('alert','error','提示',"错误信息:"+list[1]);		//Mozy	949803	2019-9-12
		return;
	}else
	{
		///Modiedy by zc0058  报废单据无效后应关闭页面 begin
		//var WaitAD=getElementValue("WaitAD"); 
		//var QXType=getElementValue("QXType");
	    
	    //var val="&RowID="+DRRowID+"&WaitAD="+WaitAD+"&Type=1"+"&QXType="+QXType; //modified By QW20191023 需求号:1065779 修改报废恢复执行成功无法刷新界面问题 
		//url="dhceq.em.disusesimlpe.csp?"+val;
	    //window.location.href= url;
		websys_showModal("close"); 
		///Modiedy by zc0058  报废单据无效后应关闭页面 end
	}
}

function BPrint_Clicked()
{
	//modified by QW20191022 BUG:QW0032 增加润乾和excel打印
	var PrintFlag=getElementValue("PrintFlag");
	var DRRowID=getElementValue("DRRowID")
    if ((DRRowID=="")||(DRRowID<1))  return;
	if(PrintFlag==0)
	{
		 Print(DRRowID);
	}
	if(PrintFlag==1)
	{
		var RequestNo=oneFillData["DRRequestNo"];
        var RequestLoc=oneFillData["DRRequestLocDR_CTLOCDesc"];
        var EquipType=oneFillData["DREquipTypeDR_ETDesc"];
        var RequestDate=oneFillData["DRRequestDate"];
        var UseLoc=oneFillData["DRUseLocDR_CTLOCDesc"];
        var UseLocCode=tkMakeServerCall("web.DHCEQCommon", "GetTrakNameByID","deptcode",oneFillData["DRUseLocDR"]);
        var PreviewRptFlag=getElementValue("PreviewRptFlag"); //add by wl 2019-11-11 WL0010 begin   增加润乾预览标志
		var HOSPDESC = getElementValue("GetHospitalDesc"); //Modified by sjh 2019-12-06 BUG00019 begin 增加医院参数
        var fileName=""
        if(PreviewRptFlag==0)
        { 
        fileName="{DHCEQDisuseRequestPrint.raq(RequestNo="+RequestNo+";RequestLoc="+RequestLoc+";RequestDate="+RequestDate+";UseLoc="+UseLoc+";EquipType="+EquipType+";UseLocCode="+UseLocCode+";HOSPDESC="+HOSPDESC+")}";
        DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        { 
        fileName="DHCEQDisuseRequestPrint.raq&RequestNo="+RequestNo+"&RequestLoc="+RequestLoc+"&RequestDate="+RequestDate+"&UseLoc="+UseLoc+"&EquipType="+EquipType+"&UseLocCode="+UseLocCode+"&HOSPDESC="+HOSPDESC;
        DHCCPM_RQPrint(fileName);//Modified by sjh 2019-12-06 BUG00019 end 增加医院参数
        }												//add by wl 2019-11-11 WL0010 end
	}
	//End by QW20191022 BUG:QW0032 增加润乾打印
}
//Add by QW20191022 BUG:QW0032 excel打印
function Print(disuseid)
{
		var gbldata=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetList",disuseid);
		var list=gbldata.split(getElementValue("SplitNumCode"));
		var Listall=list[0];
		rows=list[1];
		var PageRows=6;
		var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}
        var xlApp,xlsheet,xlBook;
		var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	    var Template=TemplatePath+"DHCEQDisuse11.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		   
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
	    	xlsheet.cells(2,2)="报废单号："+oneFillData["DRRequestNo"];//报废单号
	    	xlsheet.cells(2,6)=oneFillData["DRRequestDate"];
	    	xlsheet.cells(2,9)=oneFillData["DRRequestLocDR_CTLOCDesc"];
	    	xlsheet.cells(3,2)="类组："+oneFillData["DREquipTypeDR_ETDesc"];
			xlsheet.cells(3,9)=oneFillData["DRUseLocDR_CTLOCDesc"];  //使用科室
			var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		var Lists=Listall.split(getElementValue("SplitRowCode"));
	   		for (var j=1;j<=OnePageRow;j++)
			{

				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				if ((List[0]=='合计')&&(i==Pages))
				{
					xlsheet.cells(10,2)=List[0];
					xlsheet.cells(10,7)=List[4];//数量
					xlsheet.cells(10,9)=List[6];//金额
				}
				else
				{
					xlsheet.cells(Row,2)=List[0];//设备名称
					xlsheet.cells(Row,3)=List[1];//机型
					xlsheet.cells(Row,4)=List[2];//单位
					xlsheet.cells(Row,5)=List[3];//厂家
					xlsheet.cells(Row,6)=List[4];//入库日期
					xlsheet.cells(Row,7)=List[5];//数量
					xlsheet.cells(Row,8)=List[6];//单价
					xlsheet.cells(Row,9)=List[7];//金额
					
							
				}
					var Row=Row+1;
				
	    	}
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    	var size=obj.GetPaperInfo("DHCEQInStock");
	    	if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; //打印输出
	    	xlBook.Close (savechanges=false);	    
	    	xlsheet.Quit;
	    	xlsheet=null;
		}
		xlApp=null;
}
///Modiedy by zc0057 增加报废标签打印  
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
			messageShow('alert','error','提示','没有找到设备信息!','','','');
			return;
		}
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",equipid);
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
		var objEquip=jsonData.Data;
		var BarInfoDR=tkMakeServerCall("web.DHCEQCBarInfo","GetBarInfoDR",'DHCEQDisuseRequest');
		var Listall=tkMakeServerCall("web.DHCEQCBarInfo","GetPrintBarInfo",equipid,BarInfoDR);
		//alertShow(Listall)
		if (Listall=="")
		{
			alertShow("设备信息或条码配置信息无效,请核对!");
			return;
		}
		var Lists=Listall.split(getElementValue("SplitRowCode"));
		var NewString="";
		var InfoList=Lists[0].split("^");
		//alertShow("No="+Listall)
		for (var i=1;i<Lists.length;i++)
		{
			// 1^0^^标题^标准二维条码左侧打印^宋体^16^N^^^N^60^150^^^N^^^^N^^^1^^^^^&1^0^EQName^设备名称^名称:^宋体^8^N^1^^N^^^^^N^^^^N^^^2^^^^^&1^0^EQNo^设备编号^编号:^宋体^8^N^2^^N^^^^^N^^^^N^^^3^^^^^&1^0^EQModelDR_MDesc^规格型号^型号:^宋体^8^N^3^^N^^^^^N^^^^N^^^^^^^^&1^0^EQManuFactoryDR_MFName^生产厂家^厂家:^宋体^8^N^4^^N^^^^^N^^^^N^^^^^^^^&1^0^EQLeaveFactoryNo^出厂编号^SN码:^宋体^8^N^5^^N^^^^^N^^^^N^^^^^^^^&1^0^EQStartDate^启用日期^启用:^宋体^8^N^6^^N^^^^^N^^^^N^^^^^^^^&1^0^EQUseLocDR_CTLOCDesc^使用科室^科室:^宋体^8^N^7^^N^^^^^N^^^^N^^^^^^^^&1^0^EQLocationDR_LDesc^存放地点^存放:^宋体^8^N^8^^N^^^^^N^^^^N^^^^^^^^&1^0^EQHospital^医院名称^医院:^宋体^8^N^9^^N^^^^^N^^^^Y^^^^^^^^&1^0^EQOriginalFee^原值^原值:^宋体^8^N^10^^N^^^^^N^^^^Y^^^^^^^^&1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^竖线1^4^^^^^
			// 1^0^^标题^标准二维条码左侧打印^宋体^16^N^^^N^60^150^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^车载显示系统^设备名称^名称:^宋体^8^N^1^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^3222299001100^设备编号^编号:^宋体^8^N^2^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^\sd^规格型号^型号:^宋体^8^N^3^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^万通制造公司^生产厂家^厂家:^宋体^8^N^4^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^CCBH2019020201^出厂编号^SN码:^宋体^8^N^5^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^2019-02-02^启用日期^启用:^宋体^8^N^6^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^X线室^使用科室^科室:^宋体^8^N^7^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^210C房^存放地点^存放:^宋体^8^N^8^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^东华标准版数字化医院[总院]^医院名称^医院:^宋体^8^N^9^^N^^^^^N^^^^N^^^16^^^^^$CHAR(3)1^0^6300.00^原值^原值:^宋体^8^N^10^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^竖线1^4^^^^^
			var DetailList=Lists[i].split("^");
			// 过滤隐藏元素
			if (DetailList[19]!="Y")
			{
				if (DetailList[2]!="")
				{
					// 数值格式化
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
		
	
		//每条边格子数 17+3*4,纠错级别
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
			Str +="Bar.SplitRowCode='"+getElementValue("SplitRowCode")+"';"			// Mozy003002	2020-03-18	调整调用方法
			Str +="Bar.BarInfo='"+Lists[0]+"';"	// 二维条码左侧打印-南方医院^1^60^500^0^2^2^3500^2000^1350^200^宋体^10^Y^0^160^600^1200^0^3^EQNo^0^520^0^Y^tiaoma^2^N^10248^65285^42428^^^^^^^标准二维码^3222299001100
			Str +="Bar.BarDetail='"+NewString+"';"
			Str +="Bar.QRCode='"+TempCode+"';"
			Str +="Bar.PrintOut('1');"
			Str +="return 1;}());";
			CmdShell.notReturn =0;   //设置无结果调用，不阻塞调用
			var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
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
//增加勾选框显示列
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