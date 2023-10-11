var editIndex=undefined;
var PNRowID=getElementValue("PNRowID");
var Columns=getCurColumnsInfo('EM.G.PaymentNotice.PaymentNoticeList','','','');
var oneFillData={};
var ObjSources=new Array();
var delRow=[];

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	setElement("PNMakeDate",GetCurrentDate());
	//setElement("PNLocDR_CTLOCDesc",getElementValue("PNLoc"));
	muilt_Tab();
	initUserInfo();
    initMessage("PaymentNotice");	//获取所有业务消息
    initLookUp();
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"PNLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("PNLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle();
    initButton(); 	//按钮初始化
    //initPage(); 	//非通用按钮初始化
    initButtonWidth();
    setRequiredElements("PNLocDR_CTLOCDesc^PNProviderDR_VDesc");
    fillData();		//数据填充
    setEnabled();	//按钮控制
    //setElementEnabled(); //输入框只读控制 
    //initEditFields(); //获取可编辑字段信息
    //initApproveButtonNew(); //初始化审批按钮
	$HUI.datagrid("#DHCEQPaymentNotice",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSPaymentNotice",
	        	QueryName:"GetPaymentNoticeList",
				RowID:PNRowID
		},
	    toolbar:
	    [{
    			iconCls: 'icon-add',
                text:'新增',
				id:'add',
                handler: function(){insertRow()}
         },{
                iconCls: 'icon-cancel',
                text:'删除',
				id:'delete',
                handler: function(){deleteRow()}
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
		onLoadSuccess:function(){
			creatToolbar();
		}
	});
};
//添加合计信息
function creatToolbar()
{
	var rows = $('#DHCEQPaymentNotice').datagrid('getRows');
    var totalPNLQuantityNum = 0;
    var totalPNLTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
       	var colValue=rows[i]["PNLQuantityNum"];
       	if (colValue=="") colValue=0;
       	totalPNLQuantityNum += parseFloat(colValue);
       	colValue=rows[i]["PNLTotalFee"];
       	if (colValue=="") colValue=0;
       	totalPNLTotalFee += parseFloat(colValue);
		ObjSources[i]=new SourceInfo(rows[i].PNLSourceType,rows[i].PNLSourceID);
    }
	var lable_innerText='总数量:'+totalPNLQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalPNLTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
	var Status=getElementValue("PNStatus");
	if (Status>0)
	{
		disableElement("add",true);
		disableElement("delete",true);
	}
}
function SourceInfo(SourceType,SourceID)
{
	this.SourceType=SourceType;
	this.SourceID=SourceID;
}
function fillData()
{
	if (PNRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPaymentNotice","GetOnePaymentNotice",PNRowID);
	//messageShow("","","",jsonData);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow("","","",jsonData.Data);
		return;
	}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data;
}
function setEnabled()
{
	if (jQuery("#BApprove").length>0)
	{
		//jQuery("#BApprove").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BApprove").on("click", BApprove_Clicked);
		//jQuery("#BApprove").linkbutton({text:'提交'});
	}
	var Status=getElementValue("PNStatus");
	if (Status=="")
	{
		disableElement("BDelete",true);
		disableElement("BApprove",true);
		disableElement("BCancel",true);
	}
	else if (Status==0)
	{
		disableElement("BCancel",true);
	}
	else if (Status==2)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BApprove",true);
	}
	if (Status==3)
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BCancel",true);
		disableElement("BApprove",true);
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		disableElement("BPrint",true);
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="PNLocDR_CTLOCDesc") {setElement("PNLocDR",rowData.TRowID)}
	else if(elementID=="PNProviderDR_VDesc") {setElement("PNProviderDR",rowData.TRowID)}
}

//hisui.common.js错误纠正需要
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_');
	if(_index != -1)
	{
		var vElementDR = vElementID.slice(0,_index);
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}
 
// 插入新行
function insertRow()
{
	if(editIndex>="0") jQuery("#DHCEQPaymentNotice").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
    var rows = $("#DHCEQPaymentNotice").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].PNLSourceType=="")||(rows[lastIndex].PNLSourceID==""))
	    {
		    alertShow("第"+newIndex+"行数据为空!请先填写数据.");
		    return;
		}
	}
	if (newIndex>=0)
	{
		jQuery("#DHCEQPaymentNotice").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	if (editIndex != undefined)
	{
		if($('#DHCEQPaymentNotice').datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"提示",t[-9242]);	//当前行不可删除
			return;
		}
		jQuery("#DHCEQPaymentNotice").datagrid('endEdit', editIndex);//结束编辑,传入之前编辑的行
		var PNLRowID=$('#DHCEQPaymentNotice').datagrid('getRows')[editIndex].PNLRowID;
		delRow.push(PNLRowID)
		$('#DHCEQPaymentNotice').datagrid('deleteRow',editIndex);
	}
	else
	{
		messageShow("alert",'info',"提示",t[-9243]);	//请选中一行
	}
}
function GetSourceType(index,data)
{
	var rowData = $('#DHCEQPaymentNotice').datagrid('getSelected');
	rowData.PNLSourceType=data.TRowID;
	setElement("PNLSourceType",data.TRowID);
   	setElement("PNLSourceType_Desc",data.TDesc);
   	var sourceIDEdt = $("#DHCEQPaymentNotice").datagrid('getEditor', {index:editIndex,field:'PNLSourceID_Desc'});
   	$(sourceIDEdt.target).combogrid('grid').datagrid('load');
   	var sourceTypeEdt = $("#DHCEQPaymentNotice").datagrid('getEditor', {index:editIndex,field:'PNLSourceType_Desc'});
   	$(sourceTypeEdt.target).combogrid("setValue",data.TDesc);
   	$('#DHCEQPaymentNotice').datagrid('endEdit',editIndex);
   	$('#DHCEQPaymentNotice').datagrid('beginEdit', editIndex);
   	//$('#DHCEQPaymentNotice').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetSourceID(index,data)
{
	var rows = $('#DHCEQPaymentNotice').datagrid('getRows'); 
	if(data.TSourceID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			if ((i!=editIndex)&&(rows[i].PNLSourceType==getElementValue("PNLSourceType"))&&(rows[i].PNLSourceID==data.TSourceID))
			{
				messageShow('alert','error','提示',t[-9240].replace("[RowNo]",(i+1)))
				return;
			}
		}
	}
	var rowData = $('#DHCEQPaymentNotice').datagrid('getSelected');
	//rowData.PNLSourceType=getElementValue("PNLSourceType");
	rowData.PNLSourceID=data.TSourceID;
	rowData.PNLExtendType=data.TExtendType;
	rowData.PNLExtendID=data.TExtendID;
	rowData.PNLExtendType_Desc=data.TExtendType;
	rowData.PNLExtendID_Desc=data.TInStockNo;
	rowData.PNLProviderDR=getElementValue("PNProviderDR");
	rowData.PNLMakeDate=data.TDate;
	rowData.PNLEquipName=data.TEquipName;
	rowData.PNLManuFactory=data.TManuFactory;
	rowData.PNLOriginalFee=data.TOriginalFee;
	rowData.PNLQuantityNum=data.TQuantityNum;
	rowData.PNLTotalFee=data.TTotalFee;
	rowData.PNLAmountFee=data.TTotalFee;
	var objGrid = $("#DHCEQPaymentNotice");
	var sourceTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'PNLSourceType_Desc'});
	$(sourceTypeDescEdt.target).combogrid("setValue",getElementValue("PNLSourceType_Desc"));
	var sourceIDDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'PNLSourceID_Desc'});
	$(sourceIDDescEdt.target).combogrid("setValue",data.TNo);
	//var amountFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'PNLAmountFee'});
	//$(amountFeeEdt.target).val(data.TTotalFee);
	$("#DHCEQPaymentNotice").datagrid('endEdit',editIndex);
	//alert(editIndex+".1."+rowData.PNLSourceID+"-"+rowData.PNLExtendID)
	$("#DHCEQPaymentNotice").datagrid('beginEdit',editIndex);
}
function onClickRow(index)
{
	var PNProviderDR=getElementValue("PNProviderDR");
	if (PNProviderDR=="")
	{
		messageShow("","","","请先选择供应商!");
		return false;
	}
	var Status=getElementValue("PNStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			//alert(editIndex+"="+index)
			$('#DHCEQPaymentNotice').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$('#DHCEQPaymentNotice').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	if(editIndex>="0") jQuery("#DHCEQPaymentNotice").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#DHCEQPaymentNotice').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		//alert(oneRow.PNLSourceID)
		if (oneRow.PNLSourceID=="")
		{
			alertShow("第"+(i+1)+"行数据不正确!")
			return "-1"
		}
		
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData;
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
	//alert(dataList)
	disableElement("BSave",true);
	var DelRowid=delRow.join(',')
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPaymentNotice","SaveData",data,dataList,DelRowid);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.paymentnotice.csp?&PNRowID="+jsonData.Data;
	    window.location.href=url;
	}
	else
    {
	    disableElement("BSave",false);
		alertShow("错误信息:"+jsonData.Data);
    }
}
function BDelete_Clicked()
{
	if (PNRowID=="")
	{
		alertShow("没有凭单可删除!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPaymentNotice","DeleteData",PNRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.paymentnotice.csp";
	    window.location.href=url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
    }
}

function BApprove_Clicked()
{
	if (PNRowID=="")
	{
		alertShow("没有凭单审核!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPaymentNotice","Audit",PNRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.paymentnotice.csp?&PNRowID="+jsonData.Data;
	    window.location.href=url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
    }
}
function BCancel_Clicked()
{
  	if (PNRowID=="")
	{
		alertShow("没有凭单作废!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPaymentNotice","Cancel",PNRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.paymentnotice.csp?&PNRowID="+jsonData.Data;
	    window.location.href=url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
    }
}

function BPrint_Clicked()
{
	if ((PNRowID=="")||(PNRowID<1)) return;
	var PrintFlag=getElementValue("PrintFlag");
	if(PrintFlag==0)
	{
		 Print();
	}
	if(PrintFlag==1)
	{
		var EQTitle="";
		var PreviewRptFlag=getElementValue("PreviewRptFlag");
		var fileName=""	;
        if(PreviewRptFlag==0)
        {
	        fileName="{DHCEQPaymentNotice.raq(RowID="+PNRowID+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+";EQTitle="+EQTitle+")}"; 
	        DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        { 
	        fileName="DHCEQPaymentNotice.raq&RowID="+PNRowID+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName+"&EQTitle="+EQTitle; 
	        DHCCPM_RQPrint(fileName);
        }
	}
}
function Print()
{
	if ((PNRowID=="")||(PNRowID<1)) return;
	var ReturnList=tkMakeServerCall("web.DHCEQ.EM.BUSPaymentNotice","GetOnePaymentNoticeStr",PNRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("^");
	//alert("BPrint_Clicked.ReturnList:"+ReturnList);
	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPaymentNotice.xls";
	    xlApp = new ActiveXObject("Excel.Application");
    	xlBook = xlApp.Workbooks.Add(Template);
	   	xlsheet = xlBook.ActiveSheet;
	    var sort=31;
	    //医院名称替换
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
    	xlsheet.cells(2,2)=list[0];
    	xlsheet.cells(2,4)=list[sort+1];
    	xlsheet.cells(3,2)=list[5];
		xlsheet.cells(3,4)=list[4];
		xlsheet.cells(4,2)=list[sort+2];
		xlsheet.cells(5,2)=list[7];
    	xlsheet.cells(5,4)=ChangeDateFormat(list[6]);
    	xlsheet.cells(6,2)=list[8];
    	xlsheet.cells(6,5)=list[9];
		xlsheet.cells(7,2)=list[10];		//经办人
        // MZY0161	3520329		2023-05-12
		xlsheet.cells(11,2)=list[sort+5];
		xlsheet.cells(12,2)=list[sort+4];	//发票号

		var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
		
		//xlsheet.printout; 	//打印输出
		xlApp.Visible=true;
	    xlsheet.PrintPreview();
		//xlBook.SaveAs("D:\\InStock"+i+".xls");
		xlBook.Close (savechanges=false);
		xlsheet.Quit;
		xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alert(e.message);
	}
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQPaymentNotice').datagrid('validateRow', editIndex))
	{
		$('#DHCEQPaymentNotice').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
