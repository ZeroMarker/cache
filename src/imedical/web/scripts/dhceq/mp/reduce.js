// ..\web\scripts\dhceq\mp\return.js

var editIndex=undefined;
var ARRowID=getElementValue("ARRowID");
var Columns=getCurColumnsInfo('MP.G.AReturn.ReturnList','','','');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});

function initDocument()
{
	setElement("ARMakeDate",GetCurrentDate())
	setElement("ARLocDR_CTLOCDesc",getElementValue("ARLoc"))
	setElement("ARAccessoryTypeDR_ATDesc",getElementValue("ARAccessoryType"))
	
	initUserInfo();
    initMessage("MP"); 	//获取业务消息
    initLookUp(); 		//初始化放大镜
    // MZY0074	1850251		2021-04-30
    var paramsFrom=[{"name":"Type","type":"2","value":"2"},{"name":"LocDesc","type":"1","value":"ARLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("ARLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle(); //hisui面板title样式定义
    initButton(); 		//按钮初始化
    //initPage(); 		//非通用按钮初始化
    initButtonWidth();
	
    setRequiredElements("ARReduceType_Desc^ARAccessoryTypeDR_ATDesc^ARLocDR_CTLOCDesc^ARProviderDR_VDesc");	//必填项设置
    fillData(); 		//数据填充
    setEnabled(); 		//按钮控制
    //setElementEnabled(); //输入框只读控制 
    //initEditFields(); //获取可编辑字段信息
    initApproveButton(); //初始化审批按钮
    
	$HUI.datagrid("#DHCEQAReduce",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.MP.BUSReduce",
	        	QueryName:"GetAReduceList",
				RowID:ARRowID
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'新增',  
				id:'add',        
                handler: function(){
                     insertRow();
                }},/// MZY0025		1254598		2020-05-13		取消按钮的间距
                {
                iconCls: 'icon-cancel',
                text:'删除',
				id:'delete',
                handler: function(){
                     deleteRow();
                }
        }],
		rownumbers: true,  //如果为true则显示一个行号列
		singleSelect:true,
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			creatToolbar();
			//alertShow(getElementValue("ARReduceType"))
			if (getElementValue("ARReduceType")==1)
			{
				//退货单
			}
			else
			{
				$("#DHCEQAReduce").datagrid("hideColumn", "ARLHold1_RRDesc");
			}
		}
	});
};

//添加"合计"信息
function creatToolbar()
{
	var lable_innerText='总数量:'+totalSum("DHCEQAReduce","ARLQuantityNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQAReduce","ARLAmount").toFixed(2)
	$("#sumTotal").html(lable_innerText);
	
    //界面toolbar按钮控制
	var Status=getElementValue("ARStatus");
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
		// MZY0027	1326004		2020-05-21	隐藏按钮
		hiddenObj("BSave",1);
		hiddenObj("BDelete",1);
		hiddenObj("BSubmit",1);
	}
	if (Status!=2) hiddenObj("BPrint",1);	// MZY0025		1254598		2020-05-13
	setElement("ARJob",$('#DHCEQAReduce').datagrid('getData').rows[0].TJob);
}

function fillData()
{
	if (ARRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","GetOneAReduce",ARRowID)
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	//oneFillData=jsonData.Data;
}
function setEnabled()
{
	var Status=getElementValue("ARStatus");
	var WaitAD=getElementValue("WaitAD");
	var ReadOnly=getElementValue("ReadOnly");
	if (Status!="0")
	{
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
		if (Status!="")
		{
			disableElement("BSave",true)
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		disableElement("BPrint",true)
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		setElement("ReadOnly",1);	//非建单据菜单设为只读
	}
}

function onClickRow(index)
{
	if (getElementValue("ARAccessoryTypeDR")=="")
	{
		messageShow('alert','error','提示',"管理类组不能为空,请选择管理类组!");
		return
	}
	if (getElementValue("ARReduceType")==1)
	{
		if (getElementValue("ARProviderDR")=="")
		{
			messageShow('alert','error','提示',"供应商不能为空,请选择供应商!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','提示',"退货部门不能为空,请选择退货部门!");
			return
		}
	}
	else
	{
		if (getElementValue("ARReduceType")=="")
		{
			messageShow('alert','error','提示',"减少类型不能为空,请选择减少类型!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','提示',"科室部门不能为空,请选择科室部门!");
			return
		}
	}
	var Status=getElementValue("ARStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQAReduce').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			bindGridEvent();  //编辑行监听响应
		} else {
			$('#DHCEQAReduce').datagrid('selectRow', editIndex);
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
        var objGrid = $("#DHCEQAReduce");        // 表格对象
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'ARLQuantityNum'});	// 数量
        // 数量  绑定离开事件
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQAReduce').datagrid('getSelected');
            var Num=$(invQuantityEdt.target).val();
            if (Num<0)
            {
	            messageShow('alert','error','提示',t[-9215]);
	            $(invQuantityEdt.target).val(Num);
	            return;
	        }
            // 根据数量变更后计算 金额
            var price=parseFloat(rowData.ARLPrice);
			rowData.ARLAmount=price*Num;	// Mozy0243	2020-01-11	1173134	修正变量名称
			$('#DHCEQAReduce').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQAReduce').datagrid('validateRow', editIndex))
	{
		$('#DHCEQAReduce').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	}
	else
	{
		return false;
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="ARReduceType_Desc") {setElement("ARReduceType",rowData.TRowID)}
	else if(elementID=="ARAccessoryTypeDR_ATDesc") {setElement("ARAccessoryTypeDR",rowData.TRowID)}
	else if(elementID=="ARLocDR_CTLOCDesc") {setElement("ARLocDR",rowData.TRowID)}
	else if(elementID=="ARProviderDR_VDesc") {setElement("ARProviderDR",rowData.TRowID)}
}

//清除弹框选项值(放大镜)
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

// 插入新行
function insertRow()
{
	if(editIndex>="0") jQuery("#DHCEQAReduce").datagrid('endEdit', editIndex);	//结束编辑传入之前编辑的行
    var rows = $("#DHCEQAReduce").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].ARLItemDR=="")||(rows[lastIndex].ARLItemDR==undefined))
	    {
		    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.')
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#DHCEQAReduce").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	if (editIndex>=0)
	{
		jQuery("#DHCEQAReduce").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	}
	removeCheckBoxedRow("DHCEQAReduce");	//删除行
}
/// 明细记录配件名称返回处理
function GetAStockDetail(index,data)
{
	// data:
	// TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,
	// TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,
	// THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag,
	// TBillPage,TInvoiceNos,TFundsType
	// Mozy003004	1246570		2020-3-30
	var rows = $('#DHCEQAReduce').datagrid('getRows'); 
	if(data.TRowID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// Mozy003013	1280145 	2020-04-18	过滤重复选中
			if ((editIndex!=i)&&(rows[i].ARLStockDetailDR==data.TRowID))
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!!')
				return;
			}
		}
	}
	var rowData = $('#DHCEQAReduce').datagrid('getSelected');
	rowData.ARLItemDR=data.TItemDR;
	rowData.ARLBaseUOMDR=data.TBaseUOMDR;
	rowData.ARLBaseUOMDR_UOMDesc=data.TBaseUOM;
	rowData.ARLStockDetailDR=data.TRowID;
	rowData.ARLManuFactoryDR=data.TManuFactoryDR;
	rowData.ARLManuFactoryDR_MDesc=data.TManuFactory;
	rowData.ARLHold2=data.TAInStockListDR;
	rowData.ARLCode=data.TCode;
	rowData.ARLModel=data.TModel;
	rowData.ARLPrice=data.TBprice;
	rowData.ARLQuantityNum=data.TStock;				//库存
	//rowData.AMSLQuantityNum=data.CanUseNum;
	rowData.ARLAmount=data.TBprice*data.TStock;		// Mozy0243	2020-01-11	1173134	计算总金额
	rowData.ARLSerialFlag=data.TSerialFlag;
	rowData.ARLSerialNo=data.TSerialNo;
	rowData.ARLAInStockNo=data.TInStockNo;
	rowData.ARLInvoiceNos=data.TInvoiceNos;
	rowData.ARLFundsType=data.TFundsType;
	
	var quantityEdt = $('#DHCEQAReduce').datagrid('getEditor', {index:editIndex,field:'ARLQuantityNum'}); // 数量
	$(quantityEdt.target).val(data.TStock);
	// MZY0057	1454499		2020-10-09	调整"配件名称"赋值方式
	//var editor = $('#DHCEQAReduce').datagrid('getEditors', editIndex);
	//$(editor[0].target).combogrid("setValue",data.TDesc);
	var ARLDescEdt = $('#DHCEQAReduce').datagrid('getEditor', {index:editIndex,field:'ARLDesc'});
	$(ARLDescEdt.target).combogrid("setValue",data.TDesc);
	$('#DHCEQAReduce').datagrid('endEdit',editIndex);
	$('#DHCEQAReduce').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
/// 明细记录退货原因返回处理
function GetReturnReason(index,data)
{
	var rowData = $('#DHCEQAReduce').datagrid('getSelected');
	rowData.ARLHold1=data.TRowID;
	// MZY0057	1454499		2020-10-09	调整"退货原因"赋值方式
	//var editor = $('#DHCEQAReduce').datagrid('getEditors', editIndex);
	//$(editor[3].target).combogrid("setValue",data.TDesc);
	var ARLHold1RRDescEdt = $('#DHCEQAReduce').datagrid('getEditor', {index:editIndex,field:'ARLHold1_RRDesc'});
	$(ARLHold1RRDescEdt.target).combogrid("setValue",data.TDesc);
	$('#DHCEQAReduce').datagrid('endEdit',editIndex);
	$('#DHCEQAReduce').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
function BSave_Clicked()
{
	if (getElementValue("ARAccessoryTypeDR")=="")
	{
		messageShow('alert','error','错误提示','管理类组不能为空!')
		return
	}
	if (getElementValue("ARReduceType")==1)
	{
		if (getElementValue("ARProviderDR")=="")
		{
			messageShow('alert','error','提示',"供应商不能为空,请选择供应商!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','提示',"退货部门不能为空,请选择退货部门!");
			return
		}
	}
	else
	{
		if (getElementValue("ARReduceType")=="")
		{
			messageShow('alert','error','提示',"减少类型不能为空,请选择减少类型!");
			return
		}
		if (getElementValue("ARLocDR")=="")
		{
			messageShow('alert','error','提示',"科室部门不能为空,请选择科室部门!");
			return
		}
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList="";
	if (editIndex != undefined){ $('#DHCEQAReduce').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQAReduce').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		// MZY0034	1376749		2020-06-24	修正配件业务明细空记录判断处理
		if ((oneRow.ARLItemDR=="")||(oneRow.ARLItemDR==undefined))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据不正确!')
			return "-1"
		}
		if ((oneRow.ARLQuantityNum=="")||(parseInt(oneRow.ARLQuantityNum)<=0))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据不正确!')
			return "-1"
		}
		oneRow["ARLIndex"]=i; 		//index值处理
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (dataList=="")
	{
		alertShow("转移明细不能为空!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","SaveData",data,dataList);
	//alertShow(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("ARStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")==1) url="dhceq.mp.return.csp?";	// Mozy0239		2019-12-17
	    window.location.href=url+val;
	}
	else
    {
		messageShow('show','error','错误提示',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","DeleteData",ARRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var val="&WaitAD="+getElementValue("WaitAD")+"&QXType="+getElementValue("QXType")+"&Type="+getElementValue("Type");
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";	// Mozy003003	1246567		2020-3-27
	    window.location.href= url+val;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","SubmitData",ARRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		// Mozy003019		2020-04-28
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";
	    window.location.href=url+val;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","CancelSubmitData",ARRowID,getElementValue("CurRole"),getElementValue("CancelToFlowDR"));
	//alertShow(ARRowID+","+getElementValue("CurRole")+","+getElementValue("CancelToFlowDR"))
    var RtnObj=JSON.parse(Rtn);
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		// Mozy003019		2020-04-28
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";
	    window.setTimeout(function(){window.location.href=url+val},50); 
    }
}
function BApprove_Clicked()
{
	if (ARRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
  	//alertShow(ARRowID+","+getElementValue("AISJob")+","+CurRole+","+RoleStep)
  	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSReduce","AuditData",ARRowID,CurRole,RoleStep);
    var RtnObj=JSON.parse(Rtn);
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);
    }
    else
    {
	    //messageShow("","","",t[0])
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		// Mozy003019		2020-04-28
		var url="dhceq.mp.reduce.csp?";
		if (getElementValue("ARReduceType")=="1") url="dhceq.mp.return.csp?";
	    window.setTimeout(function(){window.location.href=url+val},50); 
    }
}
function BPrint_Clicked()
{
	/*if (ARRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003])
		return;
	}
	var gbldata=tkMakeServerCall("web.DHCEQAMoveStock","GetList",ARRowID);
	var list=gbldata.split(getElementValue("SplitNumCode"));
	var Listall=list[0];
	var rows=list[1];
	var PageRows=8;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	var movetype=getElementValue("AMSMoveType");
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template;
    	Template=TemplatePath+"DHCEQAMoveStock.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var sort=34;
	    var Listsort=18;	
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	
	    	if (movetype=="0")
			{
				xlsheet.cells(1,2)="[Hospital]配件出库单";
				xlsheet.cells(2,8)="出库单号:"+oneFillData["AMSMoveNo"];  //单号
		    	//xlsheet.cells(3,6)=GetShortName(oneFillData["AMSFromLocDR_CTLOCDesc"],"-");//供给部门
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AMSToLocDR_CTLOCDesc"],"-");//接收部门
	    	}
			else if (movetype=="1")
			{
		    	xlsheet.cells(1,2)="[Hospital]配件调配单";
		    	xlsheet.cells(2,8)="调配单号:"+oneFillData["AMSMoveNo"];  //单号
		    	//xlsheet.cells(3,6)=GetShortName(oneFillData["AMSFromLocDR_CTLOCDesc"],"-");//供给部门
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AMSToLocDR_CTLOCDesc"],"-");//接收部门
			}
	    	if (movetype=="2")
	    	{
		    	xlsheet.cells(1,2)="[Hospital]配件退库单";
		    	xlsheet.cells(2,8)="退库单号:"+oneFillData["AMSMoveNo"];  //单号
		    	//xlsheet.cells(3,6)=GetShortName(oneFillData["AMSFromLocDR_CTLOCDesc"],"-");//供给部门
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AMSToLocDR_CTLOCDesc"],"-");//接收部门
	    	}
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"));
	    	xlsheet.cells(2,6)=ChangeDateFormat(oneFillData["AMSMakeDate"]);	    	
	    	//xlsheet.cells(3,2)="类组:"+oneFillData["AMSAccessoryTypeDR_ATDesc"];
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Lists=Listall.split(getElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+Row];
				//alertShow(Listl);
				var List=Listl.split("^");
				var cellRow=Row+3;
				if (List[4]=='合计') cellRow=11;
				xlsheet.cells(cellRow,2)=List[4];//配件名称
				xlsheet.cells(cellRow,4)=List[5];//机型
				xlsheet.cells(cellRow,5)=List[Listsort+2];//单位
				xlsheet.cells(cellRow,6)=List[11];//数量
				xlsheet.cells(cellRow,7)=List[10];//原值
				xlsheet.cells(cellRow,8)=List[12];//总价
				//xlsheet.cells(cellRow,8)=List[Listsort+3];//生产厂商
				xlsheet.cells(cellRow,9)=List[Listsort+4];//入库单号
	    	}
		    xlsheet.cells(12,2)=xlsheet.cells(12,2)+oneFillData["AMSReciverDR_SSUSRName"]; //接收人
		    xlsheet.cells(12,5)=xlsheet.cells(12,5)+curUserName+" "; //制单人
		    xlsheet.cells(12,9)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"; 
		    
		    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
			var size=obj.GetPaperInfo("DHCEQInStock");
			if (0!=size) xlsheet.PageSetup.PaperSize = size;
		    
		    //xlsheet.printout; //打印输出
		    xlApp.Visible=true;
    		xlsheet.PrintPreview();
		    xlBook.Close(savechanges=false);
		    xlsheet.Quit;
		    xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		messageShow('alert','error',e.message,t[-9003])
	}
	tkMakeServerCall("web.DHCEQOperateLog","SaveData","^A02^"+ARRowID,1);*/
	//打印单据采用方式		0:Excel 1:润乾

	var fileName="" // modify by wl 2019-12-23 WL0041 begin
	if (getElementValue("PrintFlag")==1)
	{
		//系统打印单据默认是否预览	 0:不预览 1:预览
		if(getElementValue("PreviewRptFlag")==1)
		{ 
			fileName="DHCEQAReduce.raq&RowID="+ARRowID+"&CurGroupID="+curGroupID ;   
			DHCCPM_RQPrint(fileName);
		}
		else
		{ 
		    fileName="{DHCEQAReduce.raq(RowID="+ARRowID+";CurGroupID="+curGroupID+")}";  // modify by wl 2019-12-23 WL0041 end
	        DHCCPM_RQDirectPrint(fileName);		//润乾直接打印
		}
	}
}
