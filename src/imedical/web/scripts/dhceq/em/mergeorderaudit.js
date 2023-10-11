var SelectedRowID = 0;
var PreSelectedRowID = 0;
var editFlag="undefined";
var DisuseRequestcolumns=getCurColumnsInfo('EM.G.MergeOrder.DisuseDetail','','',''); 
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
		$(function(){$("#Loading").fadeOut("fast");});   //Add By QW20210429 BUG:QW0102
	}
);
function initDocument(){
	initUserInfo(); 
	initButton();
    initButtonWidth();

	defindTitleStyle(); 
	initLookUp();
	$HUI.datagrid("#DHCEQMergeOrder",{   
    url:$URL, 
	idField:'TRowID', 
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:false,
    selectOnCheck: true,
    checkOnSelect: true,
    queryParams:{
        ClassName:"web.DHCEQ.EM.BUSBatchDisuseRequest",
        QueryName:"GetDisuseRequest",
        VData:Combindata()
    },
	fitColumns:true,
	pagination:true,
	columns:DisuseRequestcolumns,
	pagination:true,
	pageSize:25,
	pageNumber:1,
	pageList:[25,50,75,100],
	toolbar:[{}],  //Add By QW20210429 BUG:QW0102
	onLoadSuccess:function(data){
	$("#DHCEQMergeOrder").datagrid("clearSelections");
	creatToolbar();  //Add By QW20210429 BUG:QW0102
	}
	});
	jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-back'});
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
	jQuery("#BApprove").linkbutton({iconCls: 'icon-w-stamp'});
	jQuery("#BApprove").on("click", BApprove_Clicked);
    hiddenObj("BApprove",true);
	hiddenObj("BCancelSubmit",true);
	initKeyWords();
	filldata();
}	

//Add By QW20210429 BUG:QW0102 添加“合计”信息
function creatToolbar()
{
	// Mozy0217  2018-11-01		修改汇总数量及总金额
	var rows = $('#DHCEQMergeOrder').datagrid('getRows');
    var totalISLQuantityNum = 0;
    var totalISLTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {

        	var colValue=rows[i]["TQuantity"];
        	if (colValue=="") colValue=0;
        	totalISLQuantityNum += parseFloat(colValue);
        	colValue=rows[i]["TTotalFee"];
        	if (colValue=="") colValue=0;
        	totalISLTotalFee += parseFloat(colValue);
    }
	var lable_innerText='总数量:'+totalISLQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalISLTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}

 function filldata(){
	var RowID=$("#RowID").val()
	var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "GetMergeOrderInfo",RowID);
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	var list=data.split("^");
	jQuery("#MergeOrderNo").val(list[0]);
}
///报废单查询条件
function Combindata()
{
	var	val="^ReplacesAD=";
	val=val+"^ApproveRole="+getElementValue("CurRole");
	val=val+"^Type="+getElementValue("Type");
	val=val+"^StatusDR="+getElementValue("StatusDR");;
	val=val+"^Status=";
	val=val+"^EquipDR=";  
	val=val+"^RequestLocDR="+getElementValue("RequestLocDR");
	val=val+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	val=val+"^PurchaseTypeDR=";	
	val=val+"^StartDate="+getElementValue("StartDate");
	val=val+"^EndDate="+getElementValue("EndDate");  
	val=val+"^WaitAD="+getElementValue("WaitAD");
	val=val+"^QXType="+getElementValue("QXType");
	val=val+"^Name=";
	val=val+"^UseLocDR="+getElementValue("UseLocDR");
	val=val+"^RequestNo="+getElementValue("RequestNo");
	val=val+"^EquipName="+getElementValue("EquipName");
	val=val+"^MinValue=";
	val=val+"^MaxValue=";
	val=val+"^StartInDate=";
	val=val+"^EndInDate=";
	val=val+"^EquipNo="+getElementValue("EquipNo");			
	val=val+"^MergeOrderFlag=Y";
	val=val+"^Action="+getElementValue("Action");
	val=val+"^MergeOrderDR="+getElementValue("RowID");		
	return val;
		
}

//报废单查询
function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQMergeOrder",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.EM.BUSBatchDisuseRequest",
        QueryName:"GetDisuseRequest",
        VData:Combindata()
	    },
	});

}


function setSelectValue(vElementID,rowData)
{
	setElement(vElementID+"DR",rowData.TRowID)  
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}


function BPrint_Clicked()
{
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var fileName=""	;
    if(PreviewRptFlag==0)
    {
	    fileName="{DHCEQMergeOrder.raq(RowID="+getElementValue("RowID")+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+";MergeOrderNo="+getElementValue("MergeOrderNo")+")}";
	    DHCCPM_RQDirectPrint(fileName);
    }
    if(PreviewRptFlag==1)
    { 
	    fileName="DHCEQMergeOrder.raq&RowID="+getElementValue("RowID")+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName+"&MergeOrderNo="+getElementValue("MergeOrderNo");
	    DHCCPM_RQPrint(fileName);
    }												

}

function BPicture_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly")

	var Status=getElementValue("Status");
	if (Status!=0) {ReadOnly=1}
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=34-1&CurrentSourceID='+getElementValue("RowID")+'&Status='+Status+'&ReadOnly='+ReadOnly;
	showWindow(str,"图片信息","","","icon-w-paper","modal","","","large");
}

//初始化审批KeyWords
function initKeyWords()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder","GetApproveAction",34)
	if(jsonData=="") return
	var aproves=jsonData.split(",")
	var items=[]
	var initkeyword={
		text:'全部',
		id:'appove_0',
		value:'',
		selected:true
	}
	items.push(initkeyword)
	for (var i = 0; i < aproves.length; i++)
	{
		var infos=aproves[i].split("^");
		var keyword={
				text:infos[1],
				id:'appove_'+(i+1),
				value:infos[0]
			}
		items.push(keyword)
	}
	 $("#ApproveButton").keywords({
		singleSelect:true,
		 labelCls:'blue',
    	items:items,
    	onClick:function(v){
	    	var approvevalue=v.value;
	    	if(approvevalue=="")
	    	{
		    	setElement("Type","");
		    	setElement("StatusDR","");//Add By QW202101121 BUG:QW0087 需求号:1703512 已经审核的汇总单，点击全部不显示报废设备
		    	hiddenObj("BApprove",true);
				hiddenObj("BCancelSubmit",true);
		    }else
	    	{
		    	setElement("Type","1");
		    	setElement("StatusDR","1");//Add By QW202101121 BUG:QW0087 需求号:1703512 已经审核的汇总单，点击全部不显示报废设备
		    	hiddenObj("BApprove",false);
				hiddenObj("BCancelSubmit",false);
		    }
	    	setElement("ApproveSetDR",approvevalue.split("&")[0]);
			setElement("CurRole",approvevalue.split("&")[1]);
			setElement("Action",approvevalue.split("&")[2]);
        	BFind_Clicked();
	    }
    });
}

function BApprove_Clicked()
{
	var RowID=getElementValue("RowID");
	var rows = $('#DHCEQMergeOrder').datagrid('getChecked');
	for (var i = 0; i < rows.length; i++) 
	{
		var TRowID=rows[i].TRowID   //报废主单ID
		if (TRowID=="") return;
		var CurRole=getElementValue("CurRole")
	  	if (CurRole=="") return;
	  	var RoleStep=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetRoleStep",TRowID,CurRole);
	  	if (RoleStep=="") return;
	  	var valuelist=TRowID+"^"+CurRole+"^"+RoleStep+"^"+"同意"
	  	var Rtn=tkMakeServerCall("web.DHCEQBatchDisuseRequest","AuditData",valuelist);
	}
	BFind_Clicked();

}

function BCancelSubmit_Clicked()
{
	var RowID=getElementValue("RowID");
	//Add By QW20210525  BUG:QW0114 begin
	var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601006");
	if ((CheckFlag!=1))
	{
		messageShow("alert","error","提示","该报废单已存在于汇总单中,无法撤回!")
		return
	}
	//Add By QW20210525  BUG:QW0114 end
	var rows = $('#DHCEQMergeOrder').datagrid('getChecked');
	if (rows.length>0)
	{
		//add by cjt 20220913 需求号2684979 增加提示信息
		messageShow("confirm","info","提示","信息:继续操作还是取消(继续将无效汇总报废单中的对应明细记录)?","",
		function()
		{
			for (var i = 0; i < rows.length; i++) 
			{
				var TRowID=rows[i].TRowID   //报废主单ID
				if (TRowID=="") return;
				var CurRole=getElementValue("CurRole")
				if (CurRole=="") return;
				var combindata=TRowID+"^批量退回^"+getElementValue("CurRole");
				var Rtn=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CancelSubmit",combindata);
			}
			BFind_Clicked();
		},function(){return;},"继续","取消");
	}
}
