var editIndex=undefined;
var ANRowID=getElementValue("ANRowID");
var Columns=getCurColumnsInfo('EM.G.AccountNo.AccountNoList','','','');
var oneFillData={};
var ObjSources=new Array();
var delRow=[];

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	setElement("ANAccountDate",GetCurrentDate());
	setElement("ANEquipTypeDR_ETDesc",getElementValue("ANEquipType"));
	//setElement("ANLocDR_CTLOCDesc",getElementValue("ANLoc"));
	muilt_Tab();
	initUserInfo();
    initMessage("AccountNo");	//获取所有业务消息
    initLookUp();
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"ANLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("ANLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle();
    initButton(); 	//按钮初始化
    //initPage(); 	//非通用按钮初始化
    initButtonWidth();
    setRequiredElements("ANAccountDate^ANEquipTypeDR_ETDesc^ANLocDR_CTLOCDesc^ANProviderDR_VDesc");
    fillData();		//数据填充
    setEnabled();	//按钮控制
    //setElementEnabled(); //输入框只读控制 
    //initEditFields(); //获取可编辑字段信息
    //initApproveButtonNew(); //初始化审批按钮
	$HUI.datagrid("#DHCEQAccountNo",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAccountNo",
	        	QueryName:"GetAccountNoList",
				AccountNoDR:ANRowID
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
	var rows = $('#DHCEQAccountNo').datagrid('getRows');
    var totalANLQuantityNum = 0;
    var totalANLTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
       	var colValue=rows[i]["ANLQuantityNum"];
       	if (colValue=="") colValue=0;
       	totalANLQuantityNum += parseFloat(colValue);
       	colValue=rows[i]["ANLAmount"];
       	if (colValue=="") colValue=0;
       	totalANLTotalFee += parseFloat(colValue);
		ObjSources[i]=new SourceInfo(rows[i].ANLSourceType,rows[i].ANLSourceID);
    }
	var lable_innerText='总数量:'+totalANLQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalANLTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
	var Status=getElementValue("ANStatus");
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
	if (ANRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","GetOneAccountNo",ANRowID);
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
	var Status=getElementValue("ANStatus");
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
	if(elementID=="ANEquipTypeDR_ETDesc") {setElement("ANEquipTypeDR",rowData.TRowID)}
	else if(elementID=="ANLocDR_CTLOCDesc") {setElement("ANLocDR",rowData.TRowID)}
	else if(elementID=="ANProviderDR_VDesc") {setElement("ANProviderDR",rowData.TRowID)}
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
	if(editIndex>="0") jQuery("#DHCEQAccountNo").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
    var rows = $("#DHCEQAccountNo").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].ANLSourceType=="")||(rows[lastIndex].ANLSourceID==""))
	    {
		    alertShow("第"+newIndex+"行数据为空!请先填写数据.");
		    return;
		}
	}
	if (newIndex>=0)
	{
		jQuery("#DHCEQAccountNo").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}

function deleteRow()
{
	if (editIndex != undefined)
	{
		if($('#DHCEQAccountNo').datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"提示",t[-9242]);	//当前行不可删除
			return;
		}
		jQuery("#DHCEQAccountNo").datagrid('endEdit', editIndex);//结束编辑,传入之前编辑的行
		var ANLRowID=$('#DHCEQAccountNo').datagrid('getRows')[editIndex].ANLRowID;
		delRow.push(ANLRowID)
		$('#DHCEQAccountNo').datagrid('deleteRow',editIndex);
	}
	else
	{
		messageShow("alert",'info',"提示",t[-9243]);	//请选中一行
	}
}
function GetSourceType(index,data)
{
	var rowData = $('#DHCEQAccountNo').datagrid('getSelected');
	rowData.ANLSourceType=data.TRowID;
	setElement("ANLSourceType",data.TRowID);
   	setElement("ANLSourceType_Desc",data.TDesc);
   	var sourceIDEdt = $("#DHCEQAccountNo").datagrid('getEditor', {index:editIndex,field:'ANLSourceID_Desc'});
   	$(sourceIDEdt.target).combogrid('grid').datagrid('load');
   	var sourceTypeEdt = $("#DHCEQAccountNo").datagrid('getEditor', {index:editIndex,field:'ANLSourceType_Desc'});
   	$(sourceTypeEdt.target).combogrid("setValue",data.TDesc);
   	$('#DHCEQAccountNo').datagrid('endEdit',editIndex);
   	$('#DHCEQAccountNo').datagrid('beginEdit',editIndex);
   	//$('#DHCEQAccountNo').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}
function GetSourceID(index,data)
{
	var rows = $('#DHCEQAccountNo').datagrid('getRows'); 
	if(data.TSourceID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			if ((i!=editIndex)&&(rows[i].ANLSourceType==getElementValue("ANLSourceType"))&&(rows[i].ANLSourceID==data.TSourceID))
			{
				messageShow('alert','error','提示',t[-9240].replace("[RowNo]",(i+1)))
				return;
			}
		}
	}
	var rowData = $('#DHCEQAccountNo').datagrid('getSelected');
	rowData.ANLSourceType=getElementValue("ANLSourceType");
	rowData.ANLSourceID=data.TSourceID;
	rowData.ANLEquipTypeDR=getElementValue("ANEquipTypeDR");
	rowData.ANLProviderDR=getElementValue("ANLProviderDR");
	rowData.MakeDate=data.TDate;
	rowData.ANLEquipName=data.TEquipName;
	rowData.ANLManuFactory=data.TManuFactory;
	rowData.ANLQuantityNum=data.TTotalNum;
	rowData.ANLAmount=data.TTotalFee;
	rowData.ToLoc=data.TBuyLoc;
	rowData.ANLRemark=data.TRemark;
	
	var objGrid = $("#DHCEQAccountNo");
	var sourceTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'ANLSourceType_Desc'});
	$(sourceTypeDescEdt.target).combogrid("setValue",getElementValue("ANLSourceType_Desc"));
	var sourceIDDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'ANLSourceID_Desc'});
	$(sourceIDDescEdt.target).combogrid("setValue",data.TNo);
	$('#DHCEQAccountNo').datagrid('endEdit',editIndex);
	$('#DHCEQAccountNo').datagrid('beginEdit',editIndex);
}
function onClickRow(index)
{
	var ANProviderDR=getElementValue("ANProviderDR");
	if (ANProviderDR=="")
	{
		messageShow("","","","请先选择供应商!");
		return false;
	}
	var Status=getElementValue("ANStatus");
	if (Status>0) return;
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQAccountNo').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$('#DHCEQAccountNo').datagrid('selectRow', editIndex);
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
	if(editIndex>="0") jQuery("#DHCEQAccountNo").datagrid('endEdit', editIndex);//结束编辑传入之前编辑的行
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#DHCEQAccountNo').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.ANLSourceID=="")
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
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","SaveData",data,dataList,DelRowid);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.accountno.csp?&ANRowID="+jsonData.Data;
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
	if (ANRowID=="")
	{
		alertShow("没有凭单可删除!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","DeleteData",ANRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.accountno.csp";
	    window.location.href=url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
    }
}

function BApprove_Clicked()
{
	if (ANRowID=="")
	{
		alertShow("没有凭单审核!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","Audit",ANRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.accountno.csp?&ANRowID="+jsonData.Data;
	    window.location.href=url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
    }
}
function BCancel_Clicked()
{
  	if (ANRowID=="")
	{
		alertShow("没有凭单作废!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","Cancel",ANRowID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		url="dhceq.em.accountno.csp?&ANRowID="+jsonData.Data;
	    window.location.href=url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
    }
}

function BPrint_Clicked()
{
	if ((ANRowID=="")||(ANRowID<1)) return;
	var PrintFlag=getElementValue("PrintFlag");
	if(PrintFlag==0)
	{
		 Print();
	}
	if(PrintFlag==1)
	{
		var EQTitle="";
		var PreviewRptFlag=getElementValue("PreviewRptFlag");
		var fileName="";
        if(PreviewRptFlag==0)
        {
	        fileName="{DHCEQAccountNoPrint.raq(RowID="+ANRowID+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+";EQTitle="+EQTitle+")}"; 
	        DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        { 
	        fileName="DHCEQAccountNoPrint.raq&RowID="+ANRowID+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName+"&EQTitle="+EQTitle; 
	        DHCCPM_RQPrint(fileName);
        }
	}
}

function Print()
{
	var gbldata=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","GetList",ANRowID);
	var list=gbldata.split(getElementValue("SplitNumCode"));
	var Listall=list[0];
	var rows=list[1];
	
	var PageRows=5;
	var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
  	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAccountNo.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	   	for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	var sort=28;
	    	//医院名称替换
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"));
	    	xlsheet.cells(2,1)="供应商:"+GetShortName(oneFillData["ISProviderDR_VDesc"],"-"); //供货商
	    	xlsheet.cells(2,4)="凭证号:"+oneFillData["ANAccountNo"];
	    	xlsheet.cells(2,6)=ChangeDateFormat(oneFillData["ANAccountNo"]);	//"凭证日期:"+
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	var Lists=Listall.split(getElementValue("SplitRowCode"));
	    	for (var j=1;j<=OnePageRow;j++)
			{
				//SourceType_"^"_TSourceNo_"^"_EquipType_"^"_Provider_"^"_ManuFactory_"^"_EquipName_"^"_QuantityNum_"^"_Amount_"^"_Remark
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=3+j;
				xlsheet.cells(Row,1)=List[0];		//来源类型
				xlsheet.cells(Row,2)=List[1];		//单号
				xlsheet.cells(Row,3)=List[5];		//设备名称
				xlsheet.cells(Row,4)=List[4];		//生产厂家
				xlsheet.cells(Row,5)=List[6];		//数量
				xlsheet.cells(Row,6)=List[7];		//总金额
				xlsheet.cells(Row,7)=List[8];		//备注
	    	}
	    	xlsheet.cells(9,2)=(list[1]-1)+" 张";
	    	//xlsheet.cells(16,10)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
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
		}
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
	if ($('#DHCEQAccountNo').datagrid('validateRow', editIndex))
	{
		$('#DHCEQAccountNo').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
