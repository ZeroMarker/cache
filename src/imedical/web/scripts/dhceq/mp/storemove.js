// ..\web\scripts\dhceq\mp\storemove.js

var editIndex=undefined;
var modifyBeforeRow = {};
var oneFillData={};
var AMSRowID=getElementValue("AMSRowID");
var Columns=getCurColumnsInfo('MP.G.AStoreMove.StoreMoveList','','','');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});
//modify by wl 2020-02-19 WL0052
function initDocument()
{
	setElement("AMSMakeDate",GetCurrentDate())
	setElement("AMSAccessoryTypeDR_ATDesc",getElementValue("AMSAccessoryType"))
	
	initUserInfo();
    initMessage("MP"); 	//获取业务消息
    initLookUp(); 		//初始化放大镜
    
	defindTitleStyle(); //hisui面板title样式定义
    initButton(); 		//按钮初始化
    //initPage(); 		//非通用按钮初始化
    initButtonWidth();
    setElement("AMSMoveType_Desc","出库");	//初始化默认值
    setElement("AMSMoveType",0);
    initLocLookUp("");
	
    setRequiredElements("AMSMoveType_Desc^AMSAccessoryTypeDR_ATDesc^AMSFromLocDR_CTLOCDesc^AMSToLocDR_CTLOCDesc");	//必填项设置
    fillData(); 		//数据填充
    setEnabled(); 		//按钮控制
    //setElementEnabled(); //输入框只读控制 
    //initEditFields(); //获取可编辑字段信息
    initApproveButton(); //初始化审批按钮
	$HUI.datagrid("#DHCEQAStoreMove",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.MP.BUSStoreMove",
	        	QueryName:"GetAMoveStockList",
				RowID:AMSRowID
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
		//onClickRow:function(rowIndex,rowData){onClickRow();},
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){creatToolbar();}
	});
	$("#AMSMoveType_Desc").lookup({
        onSelect:function(index,rowData){
            setElement("AMSMoveType",rowData.TRowID);
            initLocLookUp(rowData.TRowID);
        },
    });
};
//modify by wl 2020-02-19 WL0052 
function initLocLookUp(moveType)
{
	setElement("AMSFromLocDR_CTLOCDesc","")
    setElement("AMSToLocDR_CTLOCDesc","")
	if (moveType=="") moveType=getElementValue("AMSMoveType");
	if (moveType=="0")
    {
	    // 库房分配
        var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"AMSFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0302"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"AMSToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");
    }
    else if (moveType=="2")
    {
	    // 科室退库
     	var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"AMSFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"AMSToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0302"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");   
    }
    /*else if(moveType=="1")
    {
	    // 科室调配
        var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"AMSFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"AMSToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");
    }
    else
    {
	    // 库房调配
        var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":""},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0302"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":""},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0302"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("AMSToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");
    }*/
}
//添加"合计"信息
function creatToolbar()
{
	var lable_innerText='总数量:'+totalSum("DHCEQAStoreMove","AMSLQuantityNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQAStoreMove","AMSLAmount").toFixed(2)
	$("#sumTotal").html(lable_innerText);
	
    //界面toolbar按钮控制
	var Status=getElementValue("AMSStatus");
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
	setElement("AMSJob",$('#DHCEQAStoreMove').datagrid('getData').rows[0].TJob);
	//图标隐藏
    var rows = $("#DHCEQAStoreMove").datagrid('getRows');
    for (var i = 0; i < rows.length; i++)
    {
	    //alertShow(rows[i].TMRRowID)
	    if (rows[i].TMRRowID=="")
	    {
		    //$("#SerialNoz"+editIndex).hide()
		    $("#MRequestz"+i).hide()
		}
    }
}

function fillData()
{
	if (AMSRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSStoreMove","GetOneAStoreMove",AMSRowID)
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data;
}
function setEnabled()
{
	var Status=getElementValue("AMSStatus");
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
	var Status=getElementValue("AMSStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQAStoreMove').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQAStoreMove').datagrid('getRows')[editIndex]);
			bindGridEvent();  //编辑行监听响应
		} else {
			$('#DHCEQAStoreMove').datagrid('selectRow', editIndex);
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
        var objGrid = $("#DHCEQAStoreMove");        // 表格对象
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'AMSLQuantityNum'});	// 数量
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQAStoreMove').datagrid('getSelected');
            var Num=$(invQuantityEdt.target).val();
            if (Num<0)
            {
	            messageShow('alert','error','提示',t[-9215]);
	            $(invQuantityEdt.target).val(Num);
	            return;
	        }
            // 根据数量变更后计算 金额
            var price=parseFloat(rowData.AMSLPrice);
			rowData.AMSLAmount=price*Num;
			$('#DHCEQAStoreMove').datagrid('endEdit',editIndex);
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
	if ($('#DHCEQAStoreMove').datagrid('validateRow', editIndex))
	{
		$('#DHCEQAStoreMove').datagrid('endEdit', editIndex);
		//图标隐藏
    	var rows = $("#DHCEQAStoreMove").datagrid('getRows');
	// Mozy003015	1266905		2020-04-23	修正屏蔽条件
    	if ((rows[editIndex]!=undefined)&&((rows[editIndex].TMRRowID == undefined)||(rows[editIndex].TMRRowID==""))) $("#MRequestz"+editIndex).hide();
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
	if(elementID=="AMSMoveType_Desc") {setElement("AMSMoveType",rowData.TRowID)}
	else if(elementID=="AMSAccessoryTypeDR_ATDesc") {setElement("AMSAccessoryTypeDR",rowData.TRowID)}
	else if(elementID=="AMSFromLocDR_CTLOCDesc") {setElement("AMSFromLocDR",rowData.TRowID)}
	else if(elementID=="AMSToLocDR_CTLOCDesc") {setElement("AMSToLocDR",rowData.TRowID)}
	else if(elementID=="AMSReciverDR_SSUSRName") {setElement("AMSReciverDR",rowData.TRowID)}
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
	if(editIndex>="0"){
		jQuery("#DHCEQAStoreMove").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	}
    var rows = $("#DHCEQAStoreMove").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].AMSLItemDR=="")||(rows[lastIndex].AMSLItemDR==undefined))
	    {
		    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.')
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#DHCEQAStoreMove").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		$("#MRequestz"+newIndex).hide();
	}
}

function deleteRow()
{
	if (editIndex>=0)
	{
		jQuery("#DHCEQAStoreMove").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	}
	removeCheckBoxedRow("DHCEQAStoreMove");	//删除行
}
function getEquipList(index,data)
{
	var rowData = $('#DHCEQAStoreMove').datagrid('getSelected');
	rowData.AMSLEquipDR=data.TRowID;
	rowData.EQNo=data.TNo;
	rowData.EQUseLoc=data.TUseLoc;
	var editor = $('#DHCEQAStoreMove').datagrid('getEditors', editIndex);
	$(editor[0].target).combogrid("setValue",data.TName);
	$('#DHCEQAStoreMove').datagrid('endEdit',editIndex);
	if ((rowData.TMRRowID=="")||(rowData.TMRRowID==undefined)) $("#MRequestz"+editIndex).hide();
	$('#DHCEQAStoreMove').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
function GetAStockDetail(index,data)
{
	// TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,
	// TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,
	// THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag,
	// TBillPage,TInvoiceNos,TFund
	// Mozy003003	1225158		2020-3-27
	var rows = $('#DHCEQAStoreMove').datagrid('getRows'); 
	if(data.TRowID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// Mozy003013	1280145 	2020-04-18	过滤重复选中
			if ((editIndex!=i)&&(rows[i].AMSLStockDetailDR==data.TRowID))
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!!')
				return;
			}
		}
	}
	var rowData = $('#DHCEQAStoreMove').datagrid('getSelected');
	rowData.AMSLStockDetailDR=data.TRowID;
	rowData.AMSLItemDR=data.TItemDR;
	rowData.AMSLAISListDR=data.TAInStockListDR;
	rowData.AMSLModel=data.TModel;
	rowData.AMSLBaseUOMDR=data.TBaseUOMDR;
	rowData.AMSLBaseUOMDR_UOMDesc=data.TBaseUOM;
	rowData.AMSLPrice=data.TBprice;
	rowData.AMSLHold5=data.TStock;				//库存
	//rowData.AMSLQuantityNum=data.CanUseNum;
	rowData.AMSLAmount=data.TBprice*data.CanUseNum;
	rowData.AMSLManuFactoryDR=data.TManuFactoryDR;
	rowData.AMSLManuFactoryDR_MDesc=data.TManuFactory;
	rowData.AMSLSerialFlag=data.TSerialFlag;
	rowData.AMSLSerialNo=data.TSerialNo;
	rowData.AISInStockNo=data.TInStockNo;
	rowData.AMSLFundsType=data.TFund;		//// Mozy003008		1266910		2020-04-09
	rowData.AISProviderDR_VDesc=data.TProvider;
	var quantityEdt = $('#DHCEQAStoreMove').datagrid('getEditor', {index:editIndex,field:'AMSLQuantityNum'}); // 数量
	$(quantityEdt.target).val(data.CanUseNum);
	var editor = $('#DHCEQAStoreMove').datagrid('getEditors', editIndex);
	$(editor[1].target).combogrid("setValue",data.TDesc);
	$('#DHCEQAStoreMove').datagrid('endEdit',editIndex);
	if ((rowData.TMRRowID=="")||(rowData.TMRRowID==undefined)) $("#MRequestz"+editIndex).hide();
	$('#DHCEQAStoreMove').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}

function BSave_Clicked()
{
	if (getElementValue("AMSMoveType")=="")
	{
		messageShow('alert','error','错误提示','转移类型不能为空!')
		return
	}
	if (getElementValue("AMSAccessoryTypeDR")=="")
	{
		messageShow('alert','error','错误提示','管理类组不能为空!')
		return
	}
	if (getElementValue("AMSFromLocDR")=="")
	{
		messageShow('alert','error','错误提示','供给部门不能为空!')
		return
	}
	if (getElementValue("AMSToLocDR")=="")
	{
		messageShow('alert','error','错误提示','接收部门不能为空!')
		return
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList="";
	if (editIndex != undefined){ $('#DHCEQAStoreMove').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQAStoreMove').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		// MZY0034	1376749		2020-06-24	修正配件业务明细空记录判断处理
		if ((oneRow.AMSLItemDR=="")||(oneRow.AMSLItemDR==undefined))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据不正确!')
			return "-1"
		}
		if ((oneRow.AMSLQuantityNum=="")||(parseInt(oneRow.AMSLQuantityNum)<=0))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据不正确!')
			return "-1"
		}
		oneRow["AMSLIndex"]=i; 		//index值处理
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
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSStoreMove","SaveData",data,dataList);
	//alertShow(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		url="dhceq.mp.storemove.csp?"+val;
	    window.location.href= url;
	}
	else
    {
		messageShow('show','error','错误提示',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (AMSRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSStoreMove","DeleteData",AMSRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var val="&WaitAD="+getElementValue("WaitAD")+"&QXType="+getElementValue("QXType")+"&Type="+getElementValue("Type");
		url="dhceq.mp.storemove.csp?"+val;
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
	if (AMSRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSStoreMove","SubmitData",AMSRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		//url="dhceqinstocknew.csp?&DHCEQMWindow=1"+val
		url="dhceq.mp.storemove.csp?"+val
	    window.location.href=url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (AMSRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSStoreMove","CancelSubmitData",AMSRowID,getElementValue("CurRole"),getElementValue("CancelToFlowDR"));
	//alertShow(AMSRowID+","+getElementValue("CurRole")+","+getElementValue("CancelToFlowDR"))
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
		var url="dhceq.mp.storemove.csp?"+val;
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function BApprove_Clicked()
{
	if (AMSRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
  	//alertShow(AMSRowID+","+getElementValue("AISJob")+","+CurRole+","+RoleStep)
  	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSStoreMove","AuditData",AMSRowID,CurRole,RoleStep);
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
		url="dhceq.mp.storemove.csp?"+val
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}

//add by wl 2019-12-24 WL0038
function BPrint_Clicked()
{
	if (AMSRowID==""){ messageShow('alert','error','错误提示',t[-9003])}
	var PrintFlag = getElementValue("PrintFlag");	 //打印方式标志位 excel：0  润乾:1   
	var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
	var filename = ""
	//Excel打印方式
	if(PrintFlag==0)  
	{
		PrintExcel();
	}
	//润乾打印
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQAMoveStock.raq(AMSRowID="+AMSRowID
		    +";HOSPDESC="+curSSHospitalName
		    +";curUserName="+curUserName
		    +")}";
		    
	        DHCCPM_RQDirectPrint(fileName);		
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQAMoveStock.raq&AMSRowID="+AMSRowID
		    +"&HOSPDESC="+curSSHospitalName
		    +"&curUserName="+curUserName	   
			DHCCPM_RQPrint(fileName);
			
		}
	}	
	
}
//modify by wl 2019-12-24 WL0038
function PrintExcel()
{
	if (AMSRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003])
		return;
	}
	var gbldata=tkMakeServerCall("web.DHCEQAMoveStock","GetList",AMSRowID);
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
	tkMakeServerCall("web.DHCEQOperateLog","SaveData","^A02^"+AMSRowID,1);
}
