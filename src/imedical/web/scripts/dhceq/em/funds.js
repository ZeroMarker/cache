var editFlag="undefined";
var modifyBeforeRow = {};
var modifyAfterRow = {};

var Columns=getCurColumnsInfo('EM.G.Funds.GetFunds','','','')
var selectRow="undefined"

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
    initButton();
    initButtonWidth();
	$HUI.datagrid("#tDHCEQFunds",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSFunds",
			QueryName:"GetFunds",
			FromType:getElementValue("FromType"),
			FromID:getElementValue("FromID"),
			FundsAmount:getElementValue("FundsAmount"),
			DataChangeFlag:getElementValue("DataChangeFlag")		//czf 2020-10-29
		},
		fit:true,
		border:'fasle',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fitColumns:true,   //add by lmm 2020-06-02
		columns:Columns,
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			id:'add',
			handler:function(){insertRow();}
		},
		{
			iconCls:'icon-no',
			text:'删除',
			id:'delete',
			handler:function(){DeleteData();}
		}],
        singleSelect:true,
		loadMsg: '正在加载信息...',
		//Modify by zx 20200302 BUG ZX0079
	    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	//Modify by zx 20200302 BUG ZX0079
	    	//if (rowIndex==0) return; //第一行不做编辑
	    	if (rowData.TFundsTypeDR==getElementValue("SelfFundsID"))
	    	{
		    	messageShow('alert','error','错误提示','默认资金来源,不可编辑.');
		    	return;
		    }
	    	/*if ((parseFloat(rowData.TPreFundsFee)>0)||(parseFloat(rowData.TPreDepreTotalFee)>0))
	    	{
		    	messageShow('alert','error','错误提示','第'+(rowIndex+1)+'行变动前金额不为0,不能直接编辑.');
		    	return;
		    }*/
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQFunds').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQFunds').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	            bindGridEvent();  //编辑行监听响应
	        }
        },
		onSelect:function(index,row){
			//modified by ZY0286 处理选择行的问题
			if (editFlag!="undefined")
			{
			$('#tDHCEQFunds').datagrid('endEdit', editFlag);
			editFlag="undefined"
			}
			selectRow = index;
		},
		onLoadSuccess:function(){
			//modified by ZY0215 2020-04-02
			//调账时这些列需要隐藏不显示
			if (getElementValue("FromType")!="7")
			{
				$('#tDHCEQFunds').datagrid('hideColumn', 'TPreFundsFee');
				$('#tDHCEQFunds').datagrid('hideColumn', 'TPreDepreTotalFee');
				$('#tDHCEQFunds').datagrid('hideColumn', 'TCurFundsFee');
				$('#tDHCEQFunds').datagrid('hideColumn', 'TCurDepreTotalFee');
				$('#tDHCEQFunds').datagrid('hideColumn', 'TDepreTotal');
			}
			//Modify by zx 2020-03-09 Bug ZX0079 核算项目不可用
			if(getElementValue("FinaceItemUseFlag")=="0")
			{
				$('#tDHCEQFunds').datagrid('hideColumn', 'TFinaceItem');
				$('#tDHCEQFunds').datagrid('hideColumn', 'TFunctionCat');
			}
			//Modify by zx 2020-03-09 Bug ZX0079 是否单项资金来源
			if(getElementValue("FundsSingleFlag")=="0")
			{
				$('div.datagrid-toolbar').eq(0).hide();
			}
		}
	});
	// MZY0111	2407723		2022-01-14	非采购合同不能保存
	if (getElementValue("FromType")==8)
	{
		if (tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetContractTypeBySI",getElementValue("FromID"))!=0) setElement("ReadOnly", 1);
	}
	if (getElementValue("ReadOnly")==1)
	{
		$("#add").linkbutton("disable");
		$("#delete").linkbutton("disable");
		disableElement("BSave",true);
	}
	if (getElementValue("DataChangeFlag")=="Y")		//add by czf 20201029 单据调整
	{
		websys_showModal('options').mth();
		//websys_showModal("close");
	}
}

// 插入新行
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQFunds").datagrid('endEdit', editFlag);//结束编辑,传入之前编辑的行
	}
    var rows = $("#tDHCEQFunds").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var useLocID = "";
    var quantity = "";
    if(rows.length>0) 
    {
	    fundsTypeDR = (typeof rows[lastIndex].TFundsTypeDR == 'undefined') ? "" : rows[lastIndex].TFundsTypeDR;
	}

    if ((fundsTypeDR=="")&&(rows.length>0))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行资金来源为空!请先填写数据.');
	}
	else
	{
		//Modify by zx 20200302 BUG ZX0079 默认值处理,避免未定义
		$("#tDHCEQFunds").datagrid('insertRow', {index:newIndex,row:{"TFee":"0.00","TDepreTotal":"0.00","TPreFundsFee":"0.00","TCurFundsFee":"0.00","TPreDepreTotalFee":"0.00","TCurDepreTotalFee":"0.00",
			"TRowID":"","TOldRowDR":"","THold1":"","TFinaceItemDR":"","TFunctionCatDR":"","TNo":""}});
		editFlag=0;
	}
}

function DeleteData()
{
	var rows = $('#tDHCEQFunds').datagrid('getSelections'); //选中要删除的行
	if(rows.length<=0){
		jQuery.messager.alert("提示","无要删除的项");
		return;
	}
	if(selectRow=="undefined")
	{
		jQuery.messager.alert('提示','请选择要删除的项','warning');
		return;
	}
	//提示是否删除
	jQuery.messager.confirm("提示", "您确定要删除这行数据吗？", function (res) {
		if (res)
		{
		    $('#tDHCEQFunds').datagrid('deleteRow', selectRow);
		    selectRow = "undefined";
		}
	});
}

function BSave_Clicked()
{
	//检测自有资金参数是否设置
	if (getElementValue("SelfFundsID")=="")
	{
		alertShow("自有资金参数未设置!");
		return;
	}
	//检测金额是否正确?及一致
	var fundsAmount=getElementValue("FundsAmount");
	var Amount=0;
	var rows = $('#tDHCEQFunds').datagrid('getRows');
	var RowCount=rows.length;
	if(RowCount<=0){
		jQuery.messager.alert("没有待保存数据");
		return;
	}
	for (var i=0;i<RowCount;i++)
	{
		$('#tDHCEQFunds').datagrid('endEdit',i);
		var CurFee=rows[i].TFee;
		var Desc=rows[i].TFundsType;
		/*if (isNaN(CurFee)||((CurFee<0)&&(fundsAmount>0))||((CurFee>0)&&(fundsAmount<0)))
		{	//当'总金额'大于0时,每项资金来源的值应该大于或等于0;
			//当'总金额'小于0时,每项资金来源的值应该小于或等于0;
			//当'总金额'等于0时,每项资金来源可为正负数或0.
			alertShow("["+Desc+"]金额设置有误!请正确输入!");
			return;
		}*/
		Amount=Amount+CurFee*1
		/*if(getElementValue("FromType")=="0")
		{
			var CurFundsFee=rows[i].TCurFundsFee;
			var CurDepreTotalFee=rows[i].TCurDepreTotalFee;
			if ((isNaN(CurFundsFee))||(CurFundsFee<0))
			{
				alertShow("变动后资金来源金额不能小于0!");
				return
			}
			if ((isNaN(CurDepreTotalFee))||(CurDepreTotalFee<0))
			{
				alertShow("变动后累计折旧不能小于0!");
				return
			}
			if ((CurDepreTotalFee*1)>(CurFundsFee*1))
			{
				alertShow("变动后累计折旧不能大于变动后资金来源!");
				return
			}
		}*/
		var CurFundsFee=rows[i].TCurFundsFee;
		var CurDepreTotalFee=rows[i].TCurDepreTotalFee;
		if ((isNaN(CurFundsFee))||(CurFundsFee<0))
		{
			messageShow('alert','error','提示','第'+(i+1)+'行变动后资金来源金额不能小于0!');
			return
		}
		if ((isNaN(CurDepreTotalFee))||(CurDepreTotalFee<0))
		{
			messageShow('alert','error','提示','第'+(i+1)+'变动后累计折旧不能小于0!');
			return
		}
		if ((CurDepreTotalFee*1)>(CurFundsFee*1))
		{
			messageShow('alert','error','提示','第'+(i+1)+'变动后累计折旧不能大于变动后资金来源!');
			return
		}
		//Modify by zx 2020-03-03 Bug ZX0079 资金来源,核算项目,功能分类唯一性判断
		var CurFinaceItemDR=rows[i].TFinaceItemDR;
		if (CurFinaceItemDR=="") CurFinaceItemDR=getElementValue("SelfFinaceItemID");
		var CurFunctionCatDR=rows[i].TFunctionCatDR;
		if (CurFunctionCatDR=="") CurFunctionCatDR=getElementValue("SelfFunctionCatID");
		var rows = $('#tDHCEQFunds').datagrid('getRows');
		for(var j=0;j<rows.length;j++){
			if((i!=j)&&(rows[i].TFundsTypeDR==rows[j].TFundsTypeDR)&&(CurFinaceItemDR==rows[j].TFinaceItemDR)&&(CurFunctionCatDR==rows[j].TFunctionCatDR))
			{
				messageShow('alert','error','提示','第'+(i+1)+'行与明细中第'+(j+1)+'行重复!');
				return;
			}
		}
	}
	Amount=Amount.toFixed(2);
	if (Number(Amount)!=Number(getElementValue("FundsAmount")))
	{
		alertShow("各项资金来源合计不等于总金额!");
		return;
	}
	var val=""
	for (var i=0;i<RowCount;i++)
	{
		var val=val+rows[i].TRowID;
		val=val+"^"+rows[i].TFundsTypeDR;
		val=val+"^"+rows[i].TFee;
		val=val+"^"+rows[i].TOldRowDR;
		val=val+"^"+rows[i].THold1;
		//Modefied by ZC0080 2020-08-07 调整资金来源保存调整前的累计折旧  begin
		val=val+"^"+rows[i].TPreDepreTotalFee;
		/*
		if(getElementValue("FromType")=="0")
		{
			val=val+"^"+rows[i].TPreDepreTotalFee;
		}
		else
		{
			val=val+"^";
		}*/
		//Modefied by ZC0080 2020-08-07 调整资金来源保存调整前的累计折旧  end
		//Modify by zx 2020-02-24 BUG ZX0077 列定义取值调整
		val=val+"^"+rows[i].TFinaceItemDR;
		val=val+"^"+rows[i].TFunctionCatDR;
		val=val+"^"+rows[i].TNo;
		val=val+"^"+"";  //课题待处理
		val=val+"^"+rows[i].TDepreTotal;
		val=val+"^"+rows[i].TPreFundsFee;
		val=val+"||"
	}
	var result=tkMakeServerCall("web.DHCEQFunds","SaveFunds",getElementValue("FromType"),getElementValue("FromID"),val,getElementValue("DataChangeFlag"));		//czf 2020-10-29
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		if (result==-3001)
		{
			messageShow("","","","数据输入错误!")
			return;
		}
		else
		{
			alertShow("保存失败!")
			return
		}
	}
	else
	{
		alertShow("保存成功!")
		//刷新父界面
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
		location.reload();
	}
}

function getFinaceItem(index,data)
{
	var rowData = $('#tDHCEQFunds').datagrid('getSelected');
	rowData.TFinaceItemDR=data.TRowID;
	var finaceItemEdt = $('#tDHCEQFunds').datagrid('getEditor', {index:editFlag,field:'TFinaceItem'});
	$(finaceItemEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQFunds').datagrid('endEdit',editFlag);
	$('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}
///modified by ZY0213
function clearFinaceItem()
{
	var rowData = $('#tDHCEQFunds').datagrid('getSelected');
	rowData.TFinaceItemDR="";;
	$('#tDHCEQFunds').datagrid('endEdit',editFlag);
	$('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}


function getFunctionCat(index,data)
{
	var rowData = $('#tDHCEQFunds').datagrid('getSelected');
	rowData.TFunctionCatDR=data.TRowID;
	var functionCatEdt = $('#tDHCEQFunds').datagrid('getEditor', {index:editFlag,field:'TFunctionCat'});
	$(functionCatEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQFunds').datagrid('endEdit',editFlag);
	$('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}

///modified by ZY0213
function clearFunctionCat()
{
	var rowData = $('#tDHCEQFunds').datagrid('getSelected');
	rowData.TFunctionCatDR="";
	$('#tDHCEQFunds').datagrid('endEdit',editFlag);
	$('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}
function getFundsType(index,data)
{
	//Modify by zx 20200302 BUG ZX0079
	if (data.TRowID==getElementValue("SelfFundsID"))
	{
		messageShow('alert','error','错误提示',data.TName+'不能存在多条!');
		return;
	}
	else
	{
		var rowData = $('#tDHCEQFunds').datagrid('getSelected');
		rowData.TFundsTypeDR=data.TRowID;
		var fundsTypeEdt = $('#tDHCEQFunds').datagrid('getEditor', {index:editFlag,field:'TFundsType'});
		$(fundsTypeEdt.target).combogrid("setValue",data.TName);
		$('#tDHCEQFunds').datagrid('endEdit',editFlag);
		//Modify By zx 2020-03-02 BUG ZX0079 点击开启监听费用变化
		//$('#tDHCEQFunds').datagrid('beginEdit',editFlag);
	}
}

function bindGridEvent()
{
	if (editFlag == undefined){return true}
    try
    {
        var objGrid = $("#tDHCEQFunds");        // 表格对象
        var feeEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'TFee'});            // 数量
        /*	CZF 2021-06-03
        // MZY0070	1756530		2021-02-20
		var OtherDepreTotal=0
        var UnitDepreFee=0;		//单位折旧额
        if (getElementValue("FromType")==7)
		{
		    UnitDepreFee=tkMakeServerCall("web.DHCEQFunds","getUnitDepreFee",getElementValue("FromID"));
		}
		*/
        // 数量  绑定 离开事件 
        $(feeEdt.target).bind("blur",function(){
	        var OtherFunds=0
			var CurRow=0
			var rows = objGrid.datagrid('getRows');
			var RowCount=rows.length;
			for (var i=0; i<RowCount;i++)
			{
				//Modify By zx 2020-02-19 BUG ZX0075
				if (rows[i].TFundsTypeDR!=getElementValue("SelfFundsID"))
				{
					if(i==editFlag)
					{
						var CurFee=$(feeEdt.target).val();
						/*	CZF 2021-06-03
						// MZY0070	1756530		2021-02-20
						var CurDepreTotal=UnitDepreFee*(CurFee*1);
						var DepreTotalEdt = objGrid.datagrid('getEditor', {index:i,field:'TDepreTotal'}); 
						$(DepreTotalEdt.target).val(CurDepreTotal.toFixed(2));
						rows[i].TCurDepreTotalFee=(+rows[i].TCurDepreTotalFee+CurDepreTotal).toFixed(2);
						OtherDepreTotal=OtherDepreTotal+CurDepreTotal.toFixed(2);
						*/
					}
					else
					{
						var CurFee=rows[i].TFee;
					}
					OtherFunds=OtherFunds+CurFee*1;
				}
				else
				{
					CurRow=i
				}
			}
			var Fee=getElementValue("FundsAmount")-OtherFunds;
			rows[CurRow].TFee=Fee;
			/*	CZF 2021-06-03
			// MZY0070	1756530		2021-02-20
			rows[CurRow].TDepreTotal=0-OtherDepreTotal;		//变动累计折旧
			rows[CurRow].TCurDepreTotalFee=rows[CurRow].TCurDepreTotalFee-OtherDepreTotal;	//变动后累计折旧
			*/
			objGrid.datagrid('refreshRow', CurRow); 
			$('#tDHCEQFunds').datagrid('endEdit',editFlag);
			RefreshTable();
        });
        var depreTotalEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'TDepreTotal'});
        $(depreTotalEdt.target).bind("blur",function(){
	        var OtherDepreTotal=0
			var CurRow=0
			var rows = objGrid.datagrid('getRows');
			var RowCount=rows.length;
			for (var i=0; i<RowCount;i++)
			{
				//Modify By zx 2020-02-19 BUG ZX0075
				if (rows[i].TFundsTypeDR!=getElementValue("SelfFundsID"))
				{
					if(i==editFlag)
					{
						var TDepreTotal=$(depreTotalEdt.target).val();
					}
					else
					{
						var TDepreTotal=rows[i].TDepreTotal;
					}
					OtherDepreTotal=OtherDepreTotal+TDepreTotal*1;
				}
				else
				{
					CurRow=i;
				}
			}
			var TDepreTotal=getElementValue("DepreTotal")-OtherDepreTotal;
			rows[CurRow].TDepreTotal=TDepreTotal;
			objGrid.datagrid('refreshRow', CurRow); 
			$('#tDHCEQFunds').datagrid('endEdit',editFlag);
			RefreshTable();
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
function RefreshTable()
{
	var rows = $('#tDHCEQFunds').datagrid('getRows');
	var RowCount=rows.length;
	for (var i=0; i<RowCount;i++)
	{
		var CurFee=rows[i].TFee;
		var DepreTotal=rows[i].TDepreTotal;
		var PreFundsFee=rows[i].TPreFundsFee;
		var PreDepreTotalFee=rows[i].TPreDepreTotalFee;
		//modified by ZY0218 2020-04-10
		var CurFundsFee=(CurFee*1)+(PreFundsFee*1);
		var CurDepreTotalFee=(DepreTotal*1)+(PreDepreTotalFee*1);
		/*
		//Modify By zx 2020-02-19 BUG ZX0075
		if (rows[i].TFundsTypeDR!=getElementValue("SelfFundsID"))
		{
			var CurFundsFee=(CurFee*1)+(PreFundsFee*1);
			var CurDepreTotalFee=(DepreTotal*1)+(PreDepreTotalFee*1);
		}
		else
		{
			var CurFundsFee=CurFee*1;
			var CurDepreTotalFee=DepreTotal*1;
		}
		*/
		rows[i].TCurFundsFee=CurFundsFee.toFixed(2);
		rows[i].TCurDepreTotalFee=CurDepreTotalFee.toFixed(2);
		$('#tDHCEQFunds').datagrid('refreshRow', i);
	}
}
