// ..\web\scripts\dhceq\mp\instock.js

var editIndex=undefined;
var modifyBeforeRow = {};
var oneFillData={};
var AISRowID=getElementValue("AISRowID");
var Columns=getCurColumnsInfo('MP.G.AInStock.InStockList','','','');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});

function initDocument()
{
	setElement("AISInDate",GetCurrentDate())
	setElement("AISLocDR_CTLOCDesc",getElementValue("AISLoc"))
	setElement("AISAccessoryTypeDR_ATDesc",getElementValue("AISAccessoryType"))
	
	initUserInfo();
    initMessage("MP"); 	//获取业务消息
    initLookUp(); 		//初始化放大镜
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"ISLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0302"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("AISLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle(); //hisui面板title样式定义
    initButton(); 		//按钮初始化
    //initPage(); 		//非通用按钮初始化
    initButtonWidth();
	//入库单号的必填项设置
    setRequiredElements("AISInStockNo^AISInDate^AISInType_Desc^AISAccessoryTypeDR_ATDesc^AISLocDR_CTLOCDesc^AISProviderDR_VDesc")
    fillData(); 		//数据填充
    setEnabled(); 		//按钮控制
    //setElementEnabled(); //输入框只读控制 
    //initEditFields(); //获取可编辑字段信息
    initApproveButton(); //初始化审批按钮
	$HUI.datagrid("#DHCEQAInStock",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.MP.BUSInStock",
	        	QueryName:"GetAInStockList",
				RowID:AISRowID
		},
	    toolbar:[
	    	{
    			iconCls: 'icon-add',
                text:'新增',  
				id:'add',        
                handler: function(){
                     insertRow();
                }
            },/// MZY0025		1254598		2020-05-13		取消按钮的间距
            {
                iconCls: 'icon-cancel',
                text:'删除',
				id:'delete',
                handler: function(){
                     deleteRow();
                }
        	}
        ],
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
};
//添加"合计"信息
function creatToolbar()
{
	var lable_innerText='总数量:'+totalSum("DHCEQAInStock","AISLQuantityNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQAInStock","AISLAmount").toFixed(2)
	$("#sumTotal").html(lable_innerText);
	
    //界面toolbar按钮控制	 Mozy003006		2020-04-03	保存等按钮隐藏处理
	var Status=getElementValue("AISStatus");
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
		hiddenObj("BSave",1);
		hiddenObj("BDelete",1);
		hiddenObj("BSubmit",1);
	}
	if (Status!=2) hiddenObj("BPrint",1);
	var  job=$('#DHCEQAInStock').datagrid('getData').rows[0].AISJob;
	setElement("AISJob",job);
	//图标隐藏	Mozy		2019-10-18
    var rows = $("#DHCEQAInStock").datagrid('getRows');
    for (var i = 0; i < rows.length; i++)
    {
	    // Mozy0230		2019-11-11		1084719
	    if ((rows[i].TMRRowID == undefined)||(rows[i].TMRRowID==""))
	    {
		    //$("#SerialNoz"+editIndex).hide()
		    $("#MRequestz"+i).hide()
		}
    }
}

function fillData()
{
	if (AISRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSInStock","GetOneAInStock",AISRowID)
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}		// Mozy		2019-10-18
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data;
}
function setEnabled()
{
	var Status=getElementValue("AISStatus");
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
	var Status=getElementValue("AISStatus");
	if (Status>0) return;
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQAInStock').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQAInStock').datagrid('getRows')[editIndex]);
			setElement("AISLRowID", $('#DHCEQAInStock').datagrid('getSelected').AISLRowID)	//MZY0040	1408950		2020-7-21
			bindGridEvent();  //编辑行监听响应
		} else {
			$('#DHCEQAInStock').datagrid('selectRow', editIndex);
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
        var objGrid = $("#DHCEQAInStock");        // 表格对象
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'AISLQuantityNum'});	// 数量
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQAInStock').datagrid('getSelected');
            var Num=$(invQuantityEdt.target).val();
            if (Num<0)
            {
	            messageShow('alert','error','提示',t[-9215]);
	            $(invQuantityEdt.target).val(Num);
	            return;
	        }
            // 根据数量变更后计算 金额
            var price=parseFloat(rowData.AISLPrice);
			rowData.AISLAmount=price*Num;
			rowData.TTotalFee=rowData.AISLAmount;	// Mozy003003	1246564		2020-3-27
			$('#DHCEQAInStock').datagrid('endEdit',editIndex);
			// Mozy003003	1246533		2020-3-27	增加维修单链接隐藏处理
	    	if ((rowData.TMRRowID == undefined)||(rowData.TMRRowID=="")) $("#MRequestz"+editIndex).hide();
        });
        var rowData = objGrid.datagrid('getSelected');
        // Mozy0230		2019-11-11		1083659
        if (rowData.AISLSerialFlag=="N")
		{
			//var ee = $('#DHCEQAInStock').datagrid('getColumnOption', 'oneUpVal');	列不可编辑
			//ee.editor={};
			var SN = $('#DHCEQAInStock').datagrid('getEditor', { index:editIndex, field: 'SerialNoInfo' });
			$(SN.target).attr('disabled', true);	//$(ff.target).attr('disabled','disable');
		}
    }
    catch(e)
    {
        alertShow(e);
    }
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQAInStock').datagrid('validateRow', editIndex))
	{
		$('#DHCEQAInStock').datagrid('endEdit', editIndex);
		//图标隐藏	Mozy		2019-10-18
    	var rows = $("#DHCEQAInStock").datagrid('getRows');
    	/*if (!rows[editIndex].hasOwnProperty("ISLSourceType"))
    	{
		    $("#SerialNoz"+editIndex).hide()
	    }*/
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
	if(elementID=="AISInType_Desc") {setElement("AISInType",rowData.TRowID)}
	else if(elementID=="AISAccessoryTypeDR_ATDesc") {setElement("AISAccessoryTypeDR",rowData.TRowID)}
	else if(elementID=="AISBuyLocDR_CTLOCDesc") {setElement("AISBuyLocDR",rowData.TRowID)}
	else if(elementID=="AISBuyUserDR_SSUSRName") {setElement("AISBuyUserDR",rowData.TRowID)}
	else if(elementID=="AISLocDR_CTLOCDesc") {setElement("AISLocDR",rowData.TRowID)}
	else if(elementID=="AISProviderDR_VDesc") {setElement("AISProviderDR",rowData.TRowID)	}
	//else if(elementID=="OpenCheck"){SaveDataFromOpenCheck(rowData)}
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
		jQuery("#DHCEQAInStock").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	}
    var rows = $("#DHCEQAInStock").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].AISLItemDR=="")||(rows[lastIndex].AISLItemDR==undefined))
	    {
		    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.')
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#DHCEQAInStock").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		$("#MRequestz"+newIndex).hide();	//Modify by Mozy	1064176	2019-10-26	Mozy0227
	}
}

function deleteRow()
{
	if (editIndex>=0)
	{
		jQuery("#DHCEQAInStock").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	}
	removeCheckBoxedRow("DHCEQAInStock");	//删除行
}
function GetAccessoryList(index,data)
{
	// TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TCurBPrice,TCat,TManuFactory,TManuFactoryDR,THold1,THold2,THold3,THold4,THold5,TType,TSerialFlag
	// Mozy003004	1246570		2020-3-30
	var rows = $('#DHCEQAInStock').datagrid('getRows'); 
	if(data.TRowID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// Mozy003008	1266900		2020-04-09
			if ((editIndex!=i)&&(rows[i].AISLItemDR==data.TRowID))
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!!')
				var editor = $('#DHCEQAInStock').datagrid('getEditors', editIndex);
				$(editor[0].target).combogrid("setValue","");
				$('#DHCEQAInStock').datagrid('endEdit',editIndex);
				$("#MRequestz"+editIndex).hide();
				return;
			}
		}
	}
	var rowData = $('#DHCEQAInStock').datagrid('getSelected');
	// MZY0035	1387807		2020-06-28	增加维修配件入库单总价计算
	if ((rowData.TMRRowID!="")&&(rowData.TMRRowID!=undefined)&&(rowData.AISLPrice!=data.TCurBPrice))
	{
		alertShow("原维修单该配件单价"+rowData.AISLPrice+"被选中配件单价替换为:"+data.TCurBPrice);
		rowData.AISLAmount=data.TCurBPrice*rowData.AISLQuantityNum;
		rowData.TTotalFee=rowData.AISLAmount;
	}
	rowData.AISLItemDR=data.TRowID;
	rowData.AISLSourceID=data.TRowID;
	rowData.AISLCode=data.TCode;
	rowData.AISLModel=data.TModel;
	rowData.AISLPrice=data.TCurBPrice;
	rowData.AISLBaseUOMDR=data.TBaseUOMDR;
	rowData.AISLBaseUOMDR_UOMDesc=data.TBaseUOM;
	rowData.AISLSerialFlag=data.TSerialFlag;
	rowData.AISLManuFactoryDR=data.TManuFactoryDR;
	rowData.AISLManuFactoryDR_MDesc=data.TManuFactory;
	rowData.AISLHold1=data.THold1;
	rowData.AISLHold2=data.THold2;
	// MZY0057	1454499		2020-10-09	调整"配件名称"赋值方式
	//var editor = $('#DHCEQAInStock').datagrid('getEditors', editIndex);
	//$(editor[0].target).combogrid("setValue",data.TDesc);
	//$(editor[1].target).combogrid("setValue",data.TBaseUOM);
	// MZY0040	1408950		2020-7-21
	rowData.AISLHold5=data.TCTLRowID;
	rowData.TContractNo=data.TContractNo;
	
	// MZY0057	1454499		2020-10-09
	var AISLDescEdt = $('#DHCEQAInStock').datagrid('getEditor', {index:editIndex,field:'AISLDesc'});
	$(AISLDescEdt.target).combogrid("setValue",data.TDesc);
	if (rowData.AISLHold5!="")
	{
		var quantityEdt = $('#DHCEQAInStock').datagrid('getEditor', {index:editIndex,field:'AISLQuantityNum'}); // 数量
		$(quantityEdt.target).val(data.TQuantityNum);
		// MZY0060	1568642		2020-11-3
		rowData.AISLAmount=data.TCurBPrice*data.TQuantityNum;
		rowData.TTotalFee=rowData.AISLAmount;
	}
	$('#DHCEQAInStock').datagrid('endEdit',editIndex);
	if ((rowData.TMRRowID=="")||(rowData.TMRRowID==undefined)) $("#MRequestz"+editIndex).hide();	//Add by Mozy	1064176	2019-10-26	Mozy0227
	$('#DHCEQAInStock').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	bindGridEvent();
}
function BSave_Clicked()
{
	if (getElementValue("AISInDate")=="")
	{
		messageShow('alert','error','错误提示','入库日期不能为空!')
		return
	}
	if (getElementValue("AISInType")=="")
	{
		messageShow('alert','error','错误提示','入库类型不能为空!')
		return
	}
	if (getElementValue("AISAccessoryTypeDR")=="")
	{
		messageShow('alert','error','错误提示','管理类组不能为空!')
		return
	}
	if (getElementValue("AISLocDR")=="")
	{
		messageShow('alert','error','错误提示','库房不能为空!')
		return
	}
	if (getElementValue("AISProviderDR")=="")
	{
		messageShow('alert','error','错误提示','供应商不能为空!')
		return
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList="";
	if (editIndex != undefined){ $('#DHCEQAInStock').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQAInStock').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		// MZY0034	1376749		2020-06-24	修正配件业务明细空记录判断处理
		if ((oneRow.AISLItemDR=="")||(oneRow.AISLItemDR==undefined))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据配件名称不正确,请重新选择配件名称!');	//Mozy0234	2019-11-26	1092991
			return "-1"
		}
		if ((oneRow.AISLQuantityNum=="")||(parseInt(oneRow.AISLQuantityNum)<=0))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数量不正确!')
			return "-1"
		}
		// Mozy0230		2019-11-11		1085216
		if ((oneRow.AISLSerialFlag=="Y")&&(oneRow.SerialNoInfo==""))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行未填写序列号!')
			return "-1"
		}
		//Mozy003015	1266905		2020-04-23	修正:明细的发票信息与主表的一致
		oneRow.AISLInvoiceNos=getElementValue("AISHold2");
		oneRow.AISLHold4=getElementValue("AISHold3");
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
		alertShow("入库明细不能为空!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSInStock","SaveData",data,dataList);
	//alertShow(dataList)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+jsonData.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		url="dhceq.mp.instock.csp?"+val
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);	// Mozy		2019-10-18
		return
    }
}
function BDelete_Clicked()
{
	if (AISRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSInStock","DeleteData",AISRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var val="&WaitAD="+getElementValue("WaitAD")+"&QXType="+getElementValue("QXType")+"&Type="+getElementValue("Type");
		url="dhceq.mp.instock.csp?"+val
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);	// Mozy		2019-10-18
		return
    }
}
function BSubmit_Clicked()
{
	if (AISRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.MP.BUSInStock","SubmitData",AISRowID,getElementValue("AISJob"));
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
		//url="dhceqinstocknew.csp?&DHCEQMWindow=1"+val
		url="dhceq.mp.instock.csp?"+val
	    window.location.href=url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);	// Mozy		2019-10-18
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (AISRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSInStock","CancelSubmitData",AISRowID,getElementValue("CurRole"),getElementValue("CancelToFlowDR"));
	//alertShow(AISRowID+","+getElementValue("CurRole")+","+getElementValue("CancelToFlowDR"))
    var RtnObj=JSON.parse(Rtn);
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);	// Mozy		2019-10-18
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("AISStatus");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		var url="dhceq.mp.instock.csp?"+val;
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function BApprove_Clicked()
{
	if (AISRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003]);
		return;
	}
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
  	//alertShow(AISRowID+","+getElementValue("AISJob")+","+CurRole+","+RoleStep)
  	var Rtn=tkMakeServerCall("web.DHCEQ.MP.BUSInStock","AuditData",AISRowID,getElementValue("AISJob"),CurRole,RoleStep);
    var RtnObj=JSON.parse(Rtn);
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);	// Mozy		2019-10-18
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
		url="dhceq.mp.instock.csp?"+val
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
//add by wl 2019-11-21 WL0013 
function BPrint_Clicked()
{ 
	var PrintFlag = getElementValue("PrintFlag");	 //打印方式标志位 excel：0  润乾:1   
	var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1	
	var HOSPDESC = getElementValue("HospitalDesc");
	var filename="";
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
		    fileName="{DHCEQAInstockList.raq(AISRowID="+AISRowID
		    +";HOPDESC="+HOSPDESC
		    +";curUserName="+curUserName
		    +")}";
	        DHCCPM_RQDirectPrint(fileName);		
		}
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQAInstockList.raq&AISRowID="+AISRowID
		    +"&HOPDESC="+HOSPDESC
		    +"&curUserName="+curUserName	 
			DHCCPM_RQPrint(fileName);
		}
	}	
	
}
//modify by wl 2019-11-21 WL0013
function PrintExcel()
{
	if (AISRowID=="")
	{
		messageShow('alert','error','错误提示',t[-9003])
		return;
	}
	var gbldata=tkMakeServerCall("web.DHCEQAInStockList","GetList",AISRowID);
	var list=gbldata.split(getElementValue("SplitNumCode"));
	var Listall=list[0];
	var rows=list[1];
	var PageRows=8;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	//alertShow(TemplatePath);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAInStockSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var sort=37;
	    	xlsheet.cells.replace("[Hospital]",getElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(oneFillData["AISProviderDR_VDesc"],"-"); //供货商
	    	xlsheet.cells(2,6)=ChangeDateFormat(oneFillData["AISInDate"]);	//入库日期
	    	xlsheet.cells(2,8)=xlsheet.cells(2,8)+oneFillData["AISInStockNo"]; //入库单号
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(getElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=3+j;
				if (List[0]=="合计") Row=11;
				xlsheet.cells(Row,2)=List[0];//配件名称
				xlsheet.cells(Row,4)=List[2];//型号
				xlsheet.cells(Row,5)=List[3];//单位
				xlsheet.cells(Row,6)=List[4];//数量
				xlsheet.cells(Row,7)=List[5];//原值
				xlsheet.cells(Row,8)=List[6];//金额
				xlsheet.cells(Row,9)=List[7];//发票号
				//xlsheet.cells(Row,9)=List[1];//生产厂商
	    	}
	    	xlsheet.cells(12,3)=xlsheet.cells(12,3)+oneFillData["AISBuyUserDR_SSUSRName"];	//采购员
	    	xlsheet.cells(12,9)="制单人:"+curUserName; //制单人
	    	xlsheet.cells(13,9)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			if ((oneFillData["AISRemark"]!="")&&(oneFillData["AISRemark"]!=undefined)) xlsheet.cells(13,2)="备注:"+oneFillData["AISRemark"];
			var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	//xlsheet.printout; 	//打印输出
	    	xlApp.Visible=true
    		xlsheet.PrintPreview();
	    	//xlBook.SaveAs("D:\\InStock"+i+".xls");
	    	xlBook.Close (savechanges=false);
	    	
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
	tkMakeServerCall("web.DHCEQOperateLog","SaveData","^A01^"+AISRowID,1);
}
// Mozy0231	资金来源类型	Mozy003003	1246564		2020-3-27
function GetFundsType(index,data)
{
	var rowData = $('#DHCEQAInStock').datagrid('getSelected');
	rowData.AISLHold3=data.TRowID;
	var fundsTypeEdt = $('#DHCEQAInStock').datagrid('getEditor', {index:editIndex,field:'AISLHold3Desc'});
	$(fundsTypeEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQAInStock').datagrid('endEdit',editIndex);
	// Mozy003008	1266900		2020-04-09 	增加维修单链接隐藏处理
	if ((rowData.TMRRowID == undefined)||(rowData.TMRRowID=="")) $("#MRequestz"+editIndex).hide();
}