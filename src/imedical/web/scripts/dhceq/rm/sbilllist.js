var columns=getCurColumnsInfo('RM.G.Rent.BillList','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initButton(); //按钮初始化
	var BillDR=getElementValue("BillDR")
	if(BillDR!="") 
	{
		disableElement("BExecute",true);
		disableElement("BFind",true);
		disableElement("BStartDate",true); 
		disableElement("BStartTime",true);
		disableElement("BEndDate",true);
		disableElement("BEndTime",true);
	}
	fillData();
	jQuery("#BExecute").linkbutton({iconCls: 'icon-w-run'});
	jQuery("#BExecute").on("click", BExecute_Clicked);
	initButtonWidth();
	defindTitleStyle();
	$HUI.datagrid("#tDHCEQSBillList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSSBill",
			QueryName:"GetRentBillList",
			BillDR:getElementValue("BillDR"),
			BillStartDate:getElementValue("BStartDate"),
			BillEndDate:getElementValue("BEndDate"),
			BillStartTime:getElementValue("BStartTime"),
			BillEndTime:getElementValue("BEndTime"),
			FromHospitalDR:'',
			ToHospitalDR:'',
			ShareType:''
		},
		toolbar:[{}], 
		fitColumns : true,
	    scrollbarSize:0, 
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
			creatToolbar();
		}
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSBillList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSSBill",
			QueryName:"GetRentBillList",
			BillDR:getElementValue("BillDR"),
			BillStartDate:getElementValue("BStartDate"),
			BillEndDate:getElementValue("BEndDate"),
			BillStartTime:getElementValue("BStartTime"),
			BillEndTime:getElementValue("BEndTime"),
			FromHospitalDR:'',
			ToHospitalDR:'',
			ShareType:''
		}
	});
}
function BExecute_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var rows = $('#tDHCEQSBillList').datagrid('getRows');
	var dataList="";
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		var RowData=JSON.stringify(oneRow);
		if (dataList=="")
		{
			dataList=RowData;
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData; 
		}
		
	}
	//Modify by QW 2020-05-18
	if (dataList=="")
	{
		messageShow('alert','error','提示',"账单明细不能为空!");
		return;
	}
	var jsonData = tkMakeServerCall("web.DHCEQ.RM.BUSSBill", "SaveBill",data,dataList);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{

		messageShow('alert','success','提示',"保存成功!",'',function(){reloadbill(jsonData);});
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return;
    }

}
function reloadbill(jsonData)
{
	websys_showModal("options").mth();
	var val="BillDR="+jsonData.Data
	url="dhceq.rm.sbilllist.csp?"+val;
	window.location.href= url;
}
function creatToolbar()
{
	var BillDR=getElementValue("BillDR")
	var cost=0
	var total=0
	//Modify by QW 2020-05-18
	if(BillDR=="")
	{
		var rows = $('#tDHCEQSBillList').datagrid('getRows');
		for (var i = 0; i < rows.length; i++) {
			//Modify by QW 2020-05-18
			cost=cost+parseFloat(rows[i].BLCostFee)
			total=total+parseFloat(rows[i].BLTotalFee)
	    }
		setElement("BTotalFee",total);
		setElement("BCostFee",cost);
	}else
	{
		//Modify by QW 2020-05-18
		if(getElementValue("BCostFee")!="") cost=getElementValue("BCostFee")
		if(getElementValue("BTotalFee")!="")total=getElementValue("BTotalFee")
	}
	var lable_innerText='总费用:'+total+' 实际总费用:'+cost;
	$("#sumTotal").html(lable_innerText);
}
function fillData()
{
	var BillDR=getElementValue("BillDR")
	if (BillDR=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSSBill","GetOneBill",BillDR)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}