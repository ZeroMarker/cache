///add by ZY0260 20210428 
var editIndex=undefined;
var modifyBeforeRow = {};
var OpenCheckListID=getElementValue("OpenCheckListID");
var SourceType=getElementValue("SourceType");
var SourceID=getElementValue("SourceID");
var Columns=getCurColumnsInfo('EM.G.OpenCheckRequest.OpenCheckListLoc','','','')
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 界面加载效果影藏 bug WY0060
});

function initDocument()
{
	initUserInfo();
    initMessage("OpenCheck"); //获取所有业务消息
	defindTitleStyle(); 
	$HUI.datagrid("#tDHCEQOpenCheckListLoc",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSOpenCheckListLoc",
	        	QueryName:"GetOpenCheckListLoc",
				OpenCheckListID:OpenCheckListID,
				SourceType:SourceType,
				SourceID:SourceID
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'新增',  
				id:'add',        
                handler: function(){
                     insertRow();
                }},
                {
                iconCls: 'icon-cancel',
                text:'删除',
				id:'delete',
                handler: function(){
                     deleteRow();
                }},
                {
                iconCls: 'icon-save',
                text:'保存',
				id:'save',
                handler: function(){
                     BSave_Clicked();
                }}
                ],
        // add by zx 2019-07-23 入库编辑列bug修改
		rownumbers: true,  //如果为true，则显示一个行号列。
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
		onLoadSuccess:function(){creatToolbar();}
	});
    setEnabled(); //按钮控制
};
//添加“合计”信息
function creatToolbar()
{
	var TotalNum=getElementValue("TotalNum")
	var rows = $('#tDHCEQOpenCheckListLoc').datagrid('getRows');
    var totalCLLQuantityNum = 0;
    for (var i = 0; i < rows.length; i++)
    {
	    //if ((rows[i].CLLRowID=="")||(rows[i].CLLQuantity==rows[i].CLLArrivedQuantity)||(getElementValue("ReadOnly")!=1))
	    //{
		    //$("#CLLAction"+"z"+i).hide()
		//}
	    if (rows[i].OCLLBuyLocDR!="")
	    {
        	var colValue=rows[i]["OCLLQuantity"];
        	if (colValue=="") colValue=0;
        	totalCLLQuantityNum += parseFloat(colValue);
    	}
    }
	var lable_innerText='总数量:'+TotalNum+'&nbsp;&nbsp;&nbsp;明细数量:'+totalCLLQuantityNum
	$("#sumTotal").html(lable_innerText);
	/*
	var OCRStatus=getElementValue("OCRStatus");
	if (OCRStatus!=2)
	{
		$("#tDHCEQContractListLoc").datagrid("hideColumn", "CLLArrivedQuantity");
		$("#tDHCEQContractListLoc").datagrid("hideColumn", "CLLAction");
	}
	*/
}

function setEnabled()
{
	var OCRStatus=getElementValue("OCRStatus");
	var ReadOnly=getElementValue("ReadOnly");
	if ((OCRStatus==2)||(ReadOnly==1))
	{
		disableElement("add",true);
		disableElement("delete",true);
		disableElement("save",true);
	}
}

// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#tDHCEQOpenCheckListLoc").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQOpenCheckListLoc").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    //modified by zy 20181120
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].OCLLBuyLocDR=="")||(rows[lastIndex].OCLLQuantity==""))
	    {
		    alertShow("第"+newIndex+"行数据为空!请先填写数据.")
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#tDHCEQOpenCheckListLoc").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		 
		//$("#CLLAction"+"z"+newIndex).hide()
		
	}
}

function deleteRow()
{
	var rows = $('#tDHCEQOpenCheckListLoc').datagrid('getRows');
	if (editIndex != undefined)
	{
		jQuery("#tDHCEQOpenCheckListLoc").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		var OCLLRowID=(typeof rows[editIndex].OCLLRowID == 'undefined') ? "" : rows[editIndex].OCLLRowID
		if (OCLLRowID!="")
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckListLoc","SaveData",OCLLRowID,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE!=0)
		    {
				alertShow("删除失败:"+jsonData.Data);
				return
		    }
		    else
		    {
			    $('#tDHCEQOpenCheckListLoc').datagrid('deleteRow',editIndex);
				///modified by ZY0261 20210511
		        websys_showModal("options").mth();
			}
		}else
		{
			$('#tDHCEQOpenCheckListLoc').datagrid('deleteRow',editIndex);
		}
		
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}

function BSave_Clicked()
{
	if (editIndex != undefined){ $('#tDHCEQOpenCheckListLoc').datagrid('endEdit', editIndex);}
	var	TotalNum=getElementValue("TotalNum")
	var CurTotalNum=0
	var rows = $('#tDHCEQOpenCheckListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if ((oneRow.OCLLBuyLocDR=="")||(oneRow.OCLLQuantity==""))
		{
			alertShow("第"+(i+1)+"行数据为空,请填写!")
			return "-1"
		}
		CurTotalNum=CurTotalNum+parseInt(oneRow.OCLLQuantity)
		rows[i].OCLLOpenCheckListDR=getElementValue("OpenCheckListID")
	}
	if((CurTotalNum>TotalNum))
	{
		alertShow("明细合计数量大于总数量,请修改!")
		return "-1"
	}
	
	if (CurTotalNum!=TotalNum)
	{
		messageShow("confirm","info","提示","信息:明细合计数量与总数量不一致,是否继续保存?","",OptSaveData,function(){
			return;
		});
	}
	else
	{
		OptSaveData();
	}
}

function OptSaveData()
{
	var dataList=""
	var rows = $('#tDHCEQOpenCheckListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	if (dataList=="")
	{
		alertShow("明细不能为空!");
		return;
	}
	disableElement("BSave",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckListLoc","SaveData",dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var OpenCheckListID=getElementValue("OpenCheckListID");
		var ReadOnly=getElementValue("ReadOnly"); 
		var val="&OpenCheckListID="+OpenCheckListID+"&ReadOnly="+ReadOnly;
		url="dhceq.em.openchecklistloc.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		///modified by ZY0261 20210511
        websys_showModal("options").mth();
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#tDHCEQOpenCheckListLoc').datagrid('validateRow', editIndex)){
			$('#tDHCEQOpenCheckListLoc').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function onClickRow(index){
	var ReadOnly=getElementValue("ReadOnly");
	//if (ReadOnly>0) return
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#tDHCEQOpenCheckListLoc').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQOpenCheckListLoc').datagrid('getRows')[editIndex]);
		} else {
			$('#tDHCEQOpenCheckListLoc').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function getBuyLoc(index,data)
{
	var rowData = $('#tDHCEQOpenCheckListLoc').datagrid('getSelected');
	rowData.OCLLBuyLocDR=data.TRowID;
	///modified by ZY02264 20210521
	var editor = $('#tDHCEQOpenCheckListLoc').datagrid('getEditor',{index:editIndex,field:'OCLLBuyLoc_CTLOCDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQOpenCheckListLoc').datagrid('endEdit',editIndex);
	$('#tDHCEQOpenCheckListLoc').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	//$("#CLLAction"+"z"+editIndex).hide()
}
