///add by ZY0260 20210428 
var editIndex=undefined;
var modifyBeforeRow = {};
var InStockListID=getElementValue("InStockListID");
var Columns=getCurColumnsInfo('EM.G.InStock.InStockListLoc','','','')
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 界面加载效果影藏 bug WY0060
});

function initDocument()
{
	initUserInfo();
    initMessage("InStock"); //获取所有业务消息
	defindTitleStyle(); 
	$HUI.datagrid("#tDHCEQInStockListLoc",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInStockListLoc",
	        	QueryName:"GetInStockListLoc",
				InStockListID:InStockListID
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
	var	TotalNum=getElementValue("TotalNum")
	var rows = $('#tDHCEQInStockListLoc').datagrid('getRows');
    var totalISLLQuantityNum = 0;
    for (var i = 0; i < rows.length; i++)
    {
	    //if ((rows[i].CLLRowID=="")||(rows[i].CLLQuantity==rows[i].CLLArrivedQuantity)||(getElementValue("ReadOnly")!=1))
	    //{
		    //$("#CLLAction"+"z"+i).hide()
		//}
	    if (rows[i].ISLLBuyLocDR!="")
	    {
        	var colValue=rows[i]["ISLLQuantity"];
        	if (colValue=="") colValue=0;
        	totalISLLQuantityNum += parseFloat(colValue);
    	}
    }
	var lable_innerText='总数量:'+TotalNum+'&nbsp;&nbsp;&nbsp;明细数量:'+totalISLLQuantityNum
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
///modified by ZY02264 20210521
function setEnabled()
{
	var InStockListID=getElementValue("InStockListID");
	if (InStockListID=="") setElement("ReadOnly",1)
	var ISStatus=getElementValue("ISStatus");
	var ReadOnly=getElementValue("ReadOnly");
	if ((ISStatus==2)||(ReadOnly==1))
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
		jQuery("#tDHCEQInStockListLoc").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQInStockListLoc").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    //modified by zy 20181120
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].ISLLBuyLocDR=="")||(rows[lastIndex].ISLLQuantity==""))
	    {
		    alertShow("第"+newIndex+"行数据为空!请先填写数据.")
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#tDHCEQInStockListLoc").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		 
		//$("#CLLAction"+"z"+newIndex).hide()
		
	}
}

function deleteRow()
{
	var rows = $('#tDHCEQInStockListLoc').datagrid('getRows');
	if (editIndex != undefined)
	{
		jQuery("#tDHCEQInStockListLoc").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		var ISLLRowID=(typeof rows[editIndex].ISLLRowID == 'undefined') ? "" : rows[editIndex].ISLLRowID
		if (ISLLRowID!="")
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockListLoc","SaveData",ISLLRowID,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE!=0)
		    {
				alertShow("删除失败:"+jsonData.Data);
				return
		    }
		    else
		    {
			    $('#tDHCEQInStockListLoc').datagrid('deleteRow',editIndex);
			}
		}else
		{
			$('#tDHCEQInStockListLoc').datagrid('deleteRow',editIndex);
		}
		
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}

function BSave_Clicked()
{
	if (editIndex != undefined){ $('#tDHCEQInStockListLoc').datagrid('endEdit', editIndex);}
	var dataList=""
	var	TotalNum=getElementValue("TotalNum")
	var CurTotalNum=0
	var rows = $('#tDHCEQInStockListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		///modified by ZY0272 20210628 
		if ((oneRow.ISLLBuyLocDR=="")||(oneRow.ISLLBuyLocDR==undefined)||(oneRow.ISLLQuantity=="")||(oneRow.ISLLQuantity==undefined))
		{
			alertShow("第"+(i+1)+"行数据为空,请填写!")
			return "-1"
		}
		CurTotalNum=CurTotalNum+parseInt(oneRow.ISLLQuantity)
		rows[i].ISLLInStockListDR=getElementValue("InStockListID")
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
    var rows = $('#tDHCEQInStockListLoc').datagrid('getRows');
    var LeaveFactoryNoFlag=""
    for (var i = 0; i < rows.length; i++) 
    {
        var RowData=JSON.stringify(rows[i])
        if (RowData.ISLLLeaveFactoryNo!="") LeaveFactoryNoFlag=1
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
    if (LeaveFactoryNoFlag==1)
    {
        
        messageShow("confirm","info","提示","信息:出厂编号是否直接更新到台账?","",function(){
            
                disableElement("BSave",true)
                var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockListLoc","SaveData",dataList,"0",LeaveFactoryNoFlag);
                jsonData=JSON.parse(jsonData)
                if (jsonData.SQLCODE==0)
                {
                    var InStockListID=getElementValue("InStockListID");
                    var ReadOnly=getElementValue("ReadOnly"); 
                    var val="&InStockListID="+InStockListID+"&ReadOnly="+ReadOnly;
                    url="dhceq.em.instocklistloc.csp?"+val;
                    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
						url += "&MWToken="+websys_getMWToken()
					}
                    window.location.href= url;
                }
                else
                {
                    disableElement("BSave",false)
                    alertShow("错误信息:"+jsonData.Data);
                    return
                }
            
            },function(){
            return;
        });
    
    }
    else
    {
        disableElement("BSave",true)
        var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockListLoc","SaveData",dataList,"0");
        jsonData=JSON.parse(jsonData)
        if (jsonData.SQLCODE==0)
        {
            var InStockListID=getElementValue("InStockListID");
            var ReadOnly=getElementValue("ReadOnly"); 
            var val="&InStockListID="+InStockListID+"&ReadOnly="+ReadOnly;
            url="dhceq.em.instocklistloc.csp?"+val;
            if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
            window.location.href= url;
        }
        else
        {
            disableElement("BSave",false)
            alertShow("错误信息:"+jsonData.Data);
            return
        }
    }
    
}
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#tDHCEQInStockListLoc').datagrid('validateRow', editIndex)){
			$('#tDHCEQInStockListLoc').datagrid('endEdit', editIndex);
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
			$('#tDHCEQInStockListLoc').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQInStockListLoc').datagrid('getRows')[editIndex]);
		} else {
			$('#tDHCEQInStockListLoc').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function getBuyLoc(index,data)
{
	var rowData = $('#tDHCEQInStockListLoc').datagrid('getSelected');
	rowData.ISLLBuyLocDR=data.TRowID;
	///modified by ZY02264 20210521
	var editor = $('#tDHCEQInStockListLoc').datagrid('getEditor',{index:editIndex,field:'ISLLBuyLocDR_CTLOCDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQInStockListLoc').datagrid('endEdit',editIndex);
	$('#tDHCEQInStockListLoc').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	//$("#CLLAction"+"z"+editIndex).hide()
}
