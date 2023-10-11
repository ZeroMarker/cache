///add by ZY0260 20210428 
///明细多科室功能
var editIndex=undefined;
var modifyBeforeRow = {};
var ContractListID=getElementValue("ContractListID");
var sysflag=getElementValue("sysflag")
//modified by ZY0267 2021607
var ArrivedNum=getElementValue("ArrivedNum")
var TotalNum=getElementValue("TotalNum")
if (ArrivedNum=="")  ArrivedNum=0
if (TotalNum=="") TotalNum=0
ArrivedNum=parseInt(ArrivedNum)
TotalNum=parseInt(TotalNum)
var Columns=getCurColumnsInfo('CON.G.Contract.ContractListLoc','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 界面加载效果影藏 bug WY0060
});

function initDocument()
{
	initUserInfo();
    initMessage("Contract"); //获取所有业务消息
	defindTitleStyle(); 
	$HUI.datagrid("#tDHCEQContractListLoc",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContractListLoc",
	        	QueryName:"GetContractListLoc",
				ContractListID:ContractListID
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
                }},
                {
                iconCls: 'icon-accept',
                text:'全部到货',
				id:'batchArrive',
                handler: function(){
                     BBatchArrive_Clicked();
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
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
    var totalCLLQuantityNum = 0;
    var totalCLLArrivedQuantityNum = 0;
    for (var i = 0; i < rows.length; i++)
    {
	    //if ((rows[i].CLLRowID=="")||(rows[i].CLLQuantity==rows[i].CLLArrivedQuantity)||(getElementValue("ReadOnly")!=1))
	    //{
		    //$("#CLLAction"+"z"+i).hide()
		//}
	    if (rows[i].CLLBuyLocDR!="")
	    {
        	var colValue=rows[i]["CLLQuantity"];
        	if (colValue=="") colValue=0;
        	totalCLLQuantityNum += parseFloat(colValue);
        	var colValue=rows[i]["CLLArrivedQuantity"];
        	if (colValue=="") colValue=0;
        	totalCLLArrivedQuantityNum += parseFloat(colValue);
        	
    	}
    	///add by ZY0261 20210511
    	if (rows[i].CLLRowID=="")
    	{
	    	$("#CLLAction"+"z"+i).hide()
	    }
    }
    //modified by ZY0267 20210607
	var lable_innerText='总数量:'+TotalNum+'&nbsp;&nbsp;&nbsp;明细数量:'+totalCLLQuantityNum+'&nbsp;&nbsp;&nbsp;已到货数量:'+ArrivedNum;	//totalCLLArrivedQuantityNum;
	$("#sumTotal").html(lable_innerText);
}
//modified by ZY0267 20210607
function setEnabled()
{
	var CTStatus=getElementValue("CTStatus");
	var ReadOnly=getElementValue("ReadOnly");
	//modified by ZY0256 20210325 保证提交之后不能修改
	if ((CTStatus>0)||(ReadOnly==1))
	{
		disableElement("add",true);
		disableElement("delete",true);
		disableElement("save",true);
	}	
	///批量全部到货,界面刷新之后按钮不可用
	var CanArriveNum=parseFloat(getElementValue("TotalNum"))
	var ArriveNum=parseFloat(getElementValue("ArrivedNum"))
	if ((CTStatus!=2)||(CanArriveNum<=ArriveNum))
	{
		disableElement("batchArrive",true);
		//hiddenObj("batchArrive",true);
		$("#tDHCEQContractListLoc").datagrid("hideColumn", "CLLArrivedQuantity");
		$("#tDHCEQContractListLoc").datagrid("hideColumn", "CLLAction");
	}
}

// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#tDHCEQContractListLoc").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQContractListLoc").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    //modified by zy 20181120
    if (lastIndex>=0)
    {
	    if ((rows[lastIndex].CLLBuyLocDR=="")||(rows[lastIndex].CLLQuantity==""))
	    {
		    alertShow("第"+newIndex+"行数据为空!请先填写数据.")
		    return
		}
	}
	if (newIndex>=0)
	{
		jQuery("#tDHCEQContractListLoc").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		 
		$("#CLLAction"+"z"+newIndex).hide()
		
	}
}

function deleteRow()
{
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	if(rows.length<2)
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
		return;
	}
	if (editIndex != undefined)
	{
		jQuery("#tDHCEQContractListLoc").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		var CLLRowID=(typeof rows[editIndex].CLLRowID == 'undefined') ? "" : rows[editIndex].CLLRowID
		if (CLLRowID!="")
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContractListLoc","SaveData",CLLRowID,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE!=0)
		    {
				alertShow("删除失败:"+jsonData.Data);
				return
		    }
		    else
		    {
			    $('#tDHCEQContractListLoc').datagrid('deleteRow',editIndex);
			}
		}else
		{
			$('#tDHCEQContractListLoc').datagrid('deleteRow',editIndex);
		}
		
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}

function BSave_Clicked()
{
	if (editIndex != undefined){ $('#tDHCEQContractListLoc').datagrid('endEdit', editIndex);}
	var TotalNum=getElementValue("TotalNum")
	var CurTotalNum=0
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		//modified by ZY0267 20210607
		if ((oneRow.CLLBuyLocDR=="")||(oneRow.CLLBuyLocDR==undefined)||(oneRow.CLLQuantity=="")||(oneRow.CLLQuantity==undefined))
		{
			alertShow("第"+(i+1)+"行数据为空,请填写!")
			return "-1"
		}
		CurTotalNum=CurTotalNum+parseInt(oneRow.CLLQuantity)
		rows[i].CLLContractListDR=getElementValue("ContractListID")
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
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
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
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContractListLoc","SaveData",dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var ContractListID=getElementValue("ContractListID");
		var ReadOnly=getElementValue("ReadOnly"); 
		var val="&ContractListID="+ContractListID+"&ReadOnly="+ReadOnly;
		url="dhceq.con.contractlistloc.csp?"+val
        websys_showModal("options").mth();
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

function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#tDHCEQContractListLoc').datagrid('validateRow', editIndex)){
			$('#tDHCEQContractListLoc').datagrid('endEdit', editIndex);
    		var rows = $("#tDHCEQContractListLoc").datagrid('getRows');
    		// modified by ZY0269 20210615
    		/*
    		//if (!rows[editIndex].hasOwnProperty("CLLRowID"))
			var CLLRowID=(typeof rows[editIndex].CLLRowID == 'undefined') ? "" : rows[editIndex].CLLRowID
			if (CLLRowID=="")
    		{
			    $("#CLLAction"+"z"+editIndex).hide()
	    	}
	    	*/
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
			$('#tDHCEQContractListLoc').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQContractListLoc').datagrid('getRows')[editIndex]);
		} else {
			$('#tDHCEQContractListLoc').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function getBuyLoc(index,data)
{
	var rowData = $('#tDHCEQContractListLoc').datagrid('getSelected');
	rowData.CLLBuyLocDR=data.TRowID;
	///modified by ZY02264 20210521
	var editor = $('#tDHCEQContractListLoc').datagrid('getEditor',{index:editIndex,field:'CLLBuyLoc_CTLOCDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQContractListLoc').datagrid('endEdit',editIndex);
	$('#tDHCEQContractListLoc').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	$("#CLLAction"+"z"+editIndex).hide()
}
function BBatchArrive_Clicked()
{
	/*
	var url='dhceq.em.arrive.csp?&SourceType=1&SourceID='+ContractListID;
	//size=modal,width=350,height=13row,title=验收通知
	showWindow(url,"验收通知",350,"13row","icon-w-paper","modal","","","modal",reloadGrid);
	*/
	//modified by ZY0198 字符判断问题
	if (sysflag==2)
	{
        ///modified by ZY20230105 bug:3159848
        var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
        if (rows.length>1)
        {
            messageShow("confirm","info","提示","多明细是否生成到一个验收单中?","",function(){
                sysflag=0;
                OptBatchArrive();
            },function(){
                sysflag=1;
                OptBatchArrive();
            });            
        }
        else
        {
            sysflag=1;
            OptBatchArrive();
        }
	}else
	{
		OptBatchArrive()
	}
}

function OptBatchArrive()
{
	var CanArriveNum=parseFloat(getElementValue("TotalNum"))
	var ArriveNum=parseFloat(getElementValue("ArrivedNum"))
	if ((CanArriveNum<1)||(ArriveNum>CanArriveNum))
	{
		//alertShow("本次到货数量无效!");
		messageShow('alert','info','提示',"本次到货数量无效!");
		return;
	}
	var combindata=getElementValue("ProviderDR")
	
	
	var	TotalNum=parseFloat(getElementValue("TotalNum"))
	var CLLRowID=""
	var SourceType=1
	var SourceID=getElementValue("ContractListID")
    var totalCLLQuantityNum = 0;
    
	var valuelist=""
	var rows = $('#tDHCEQContractListLoc').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
    	var CLLRowID=rows[i]["CLLRowID"];
    	var ArriveLocDR=rows[i]["CLLBuyLocDR"];
    	var CLLQuantity=rows[i]["CLLQuantity"];
    	if (CLLQuantity=="") CLLQuantity=0;
    	var CLLArrivedQuantity=rows[i]["CLLArrivedQuantity"];
    	if (CLLArrivedQuantity=="") CLLArrivedQuantity=0;
    	var ArriveNum=CLLQuantity-CLLArrivedQuantity
    	///modified by ZY02264 20210521
    	var RowData=SourceType+"^"+SourceID+"^"+ArriveNum+"^"+CLLRowID+"^"+ArriveLocDR;
    	if (sysflag==1)
    	{
	    	///modified by ZY0275 20210712
	    	if (ArriveNum==0)
	    	{
		    	TotalNum=TotalNum-CLLArrivedQuantity
		    	continue
		    }
		    else
		    {
		    	totalCLLQuantityNum += parseFloat(ArriveNum);
				if (valuelist=="")
				{
					valuelist=RowData;
				}
				else
				{
					valuelist=valuelist+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
				}
			}
	    }
	    else
	    {
	    	totalCLLQuantityNum += parseFloat(CLLArrivedQuantity);
	    }
	}
	var remainNum=TotalNum-totalCLLQuantityNum
	if (remainNum>0)
	{
		var RowData=SourceType+"^"+SourceID+"^"+remainNum+"^"+""+"^";
		if (valuelist=="")
		{
			valuelist=RowData;
		}
		else
		{
			valuelist=valuelist+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	disableElement("batchArrive",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSArrive","SaveArriveRecord",combindata,valuelist,sysflag);	// MZY0058	2020-10-18
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var ContractListID=getElementValue("ContractListID");
		var ReadOnly=getElementValue("ReadOnly"); 
		var val="&ContractListID="+ContractListID+"&ReadOnly="+ReadOnly;
		url="dhceq.con.contractlistloc.csp?"+val
        websys_showModal("options").mth();
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("batchArrive",false)
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function reloadGrid()
{
	$HUI.datagrid("#tDHCEQContractListLoc",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContractListLoc",
	        	QueryName:"GetContractListLoc",
				ContractListID:ContractListID
		},
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){creatToolbar();}
	});
	// modified by ZY0269 20210615
	setEnabled()
}
