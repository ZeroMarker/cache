
var editFlag="undefined";
var SelectRowID="";
var SourceType=getElementValue("SourceType");
var SourceID=getElementValue("SourceID"); 
var CalcFlag=getElementValue("CalcFlag");
var PurchaseTypeCode=getElementValue("PurchaseTypeCode");
var ComponentName="EM.G.BuyRequest.EconCalc"

if (CalcFlag=="N")
{
	//purchaseType：01:新增；02：更新：03： 首配
	if (PurchaseTypeCode=="01")
	{
		ComponentName="EM.G.BuyRequest.EconCalc01"
	}
	else if (PurchaseTypeCode=="02")
	{
		ComponentName="EM.G.BuyRequest.EconCalc02"
	}
}
var Columns=getCurColumnsInfo(ComponentName,'','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage("BuyRequest"); //获取所有业务消息
    //initLookUp();
	defindTitleStyle(); 
    //initButton();
    //initButtonWidth();
	$HUI.datagrid("#tDHCEQEconCalc",{   
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSEconCalc",
	        	QueryName:"GetEconCalc",
				SourceType:SourceType,
				SourceID:SourceID,
				CalcFlag:CalcFlag,
				PurchaseTypeCode:PurchaseTypeCode,
			},
			fit:true,
			//border:false,	//modified zy ZY0215 2020-04-01
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fitColumns : true,    //add by lmm 2020-06-04
			toolbar:[{
				iconCls:'icon-add',
				text:'新增',
				id:'add',
				handler:function(){insertRow();}
			},
			{
				iconCls:'icon-save',
				text:'保存',
				id:'save',
				handler:function(){SaveData();}
			},
			{
                iconCls: 'icon-cancel',
				text:'删除',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
		    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQEconCalc').datagrid('endEdit', editFlag);
	                editFlag="undefined";
	            }
	            else
	            {
		            $('#tDHCEQEconCalc').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onSelect:function(index,row){ 
				//modified by zy ZY0223 2020-04-17
				if (SelectRowID!=index)
				{
					SelectRowID=index
				}
				else
				{
					SelectRowID=""
				}
			}
	});
	if (getElementValue("ReadOnly")==1)
	{
		$("#add").linkbutton("disable");
		$("#save").linkbutton("disable");
		$("#delete").linkbutton("disable");
	}
}

// 插入新行
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQEconCalc").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQEconCalc").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var ECYear = (typeof rows[lastIndex].ECYear == 'undefined') ? "" : rows[lastIndex].ECYear;
    var ECServiceIncome = (typeof rows[lastIndex].ECServiceIncome == 'undefined') ? "" : rows[lastIndex].ECServiceIncome;
    var ECWorkLoadNum = (typeof rows[lastIndex].ECWorkLoadNum == 'undefined') ? "" : rows[lastIndex].ECWorkLoadNum;
    var ECEquip = (typeof rows[lastIndex].ECEquip == 'undefined') ? "" : rows[lastIndex].ECEquip;
    if ((CalcFlag=="Y")&&(ECYear=="")&&(ECWorkLoadNum==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	    return
	}
	if ((PurchaseTypeCode=="01")&&(ECWorkLoadNum==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	    return
	}
	if ((PurchaseTypeCode=="02")&&(ECEquipDR==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	    return
	}
	$("#tDHCEQEconCalc").datagrid('insertRow', {index:newIndex,row:{}});
	editFlag=0;
}
// 保存编辑行
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQEconCalc').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQEconCalc').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		rows[i].ECSourceType=SourceType
		rows[i].ECSourceID=SourceID
		rows[i].ECCalcFlag=CalcFlag
		var oneRow=rows[i]
		if ((CalcFlag=="Y")&&((oneRow.ECYear=="")||(typeof(oneRow.ECYear)=="undefined")))
		{
			alertShow("第"+(i+1)+"行数据不正确!")
			return "-1"
		}
		if ((PurchaseTypeCode=="01")&&((oneRow.ECWorkLoadNum=="")||(typeof(oneRow.ECWorkLoadNum)=="undefined")))
		{
			alertShow("第"+(i+1)+"行数据不正确!")
			return "-1"
		}
		if ((PurchaseTypeCode=="02")&&((oneRow.ECEquipDR=="")||(typeof(oneRow.ECEquipDR)=="undefined")))
		{
			alertShow("第"+(i+1)+"行数据设备必填!")
			return "-1"
		}
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
		alertShow("明细不能为空!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","SaveData",dataList);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&SourceType="+SourceType+"&SourceID="+SourceID+"&CalcFlag="+CalcFlag+"&ReadOnly="+getElementValue("ReadOnly");
		url="dhceq.em.econcalc.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(CalcFlag);
	}
	else
    {
		$.messager.popover({msg:"错误信息:"+jsonData,type:'error'});
		return
    }
}

//modified by ZY0223 2020-04-17 删除逻辑bug
//modified by ZY0222 2020-04-16
function DeleteData()
{
	var rows = $('#tDHCEQEconCalc').datagrid('getSelected');  //选中要删除的行
	if(rows.length<=0){
		alertShow("请选择要删除的项.");
		return;
	}
	var RowID=(typeof rows.ECRowID == 'undefined') ? "" : rows.ECRowID
	if (RowID=="")
	{
		if(SelectRowID>="0"){
			$("#tDHCEQEconCalc").datagrid('endEdit', SelectRowID);//结束编辑，传入之前编辑的行
			if(Selectindex>="1")$("#tDHCEQEconCalc").datagrid('deleteRow',SelectRowID)
		}
		return
	}
	else
	{
		SelectRowID=RowID
		messageShow("confirm","","","确定要删除吗？","",confirmFun,"")
	}
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	//modified by ZY0222 2020-04-16
	var RowData={"ECRowID":SelectRowID}; //add by zx 2019-09-12
	RowData = JSON.stringify(RowData);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","SaveDataList",RowData,"1");
	//jsonData=JSON.parse(jsonData)
	//if (jsonData.SQLCODE==0)
	if (jsonData==0)
	{
		var val="&SourceType="+SourceType+"&SourceID="+SourceID+"&CalcFlag="+CalcFlag+"&ReadOnly="+getElementValue("ReadOnly");
		url="dhceq.em.econcalc.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(CalcFlag);
	}
	else
    {
		$.messager.popover({msg:"错误信息:"+jsonData,type:'error'});
		return
    }
}
//hisui.common.js错误纠正需要
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
 
// 淘汰设备
function getEquipDR(index,data)
{
	var rowData = $('#tDHCEQEconCalc').datagrid('getSelected');
	rowData.ECEquipDR=data.TRowID;
	var EquipEdt = $('#tDHCEQEconCalc').datagrid('getEditor', {index:editFlag,field:'TEquip'});
	$(EquipEdt.target).combogrid("setValue",data.TName);
	
	setElement("TModel",data.TRowID);
	setElement("TUseLoc",data.TUseLoc);
	setElement("TOriginalFee",data.TOriginalFee);
	//setElement("TLimitYearsNum",data.TLimitYearsNum);
	//setElement("TStartDate",data.TStartDate);
	setElement("TTransAssetDate",data.TTransAssetDate);
	setElement("TNo",data.TNo);
	$('#tDHCEQEconCalc').datagrid('endEdit',editFlag);
	$('#tDHCEQEconCalc').datagrid('beginEdit',editFlag);
}
