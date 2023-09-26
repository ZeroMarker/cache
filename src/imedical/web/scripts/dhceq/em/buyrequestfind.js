///定义一个对象,把全局变量的数据放在里面。
var GlobalObj = {
	//参数
	QXType : "",
	ReadOnly : "",
	vData : "",
	BussCode : "",
	Columns : "",
	getData : function ()
	{
		this.QXType=$("#QXType").val()
		this.ReadOnly=$("#ReadOnly").val()
		this.vData=$("#vData").val()
		this.BussCode="91"
		this.Columns = getCurColumnsInfo('EM.G.BuyRequest.BuyRequestFind','','','')
	}
}

///jquery界面入口
jQuery(document).ready(function()
{
	GlobalObj.getData();
	InitTableList();
}); 

function InitTableList()
{
	$HUI.datagrid("#tDHCEQBuyRequest",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.LIBMessages",
	        	QueryName:"GetBussDataByCode",
				BussType:GlobalObj.BussCode,
		},
	    border:'true',
	    fit:true,
	    columns:GlobalObj.Columns,
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36] 
	});
}
/*
function detailOperation(value,row,index)
{
	var roleInfo=row.roles.split(",");
	var actionDescInfo=row.actionDesc.split(",");
	var actionCodeInfo=row.actionCode.split(",");
    var btn=""
    for (var i=0;i<roleInfo.length;i++)
    {
	    if(roleInfo[i]!="")
	    {
		    var para="RowID="+row.msgID+"&ReadOnly="+$('#ReadOnly').val()+"&vData="+$('#vData').val();
	        var url="dhceqmessages.csp?"+para;
		    url=url+"&Action="+actionCodeInfo[i]+"&CurRole="+roleInfo[i];
		    var name="审核"
		    if (actionCodeInfo[i]!="") 
		    {
			    name=actionDescInfo[i];
		    }
	    	btn=btn+'<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#" style="margin-left:5px">'+name+'</A>';
	        btn=btn+'<br />'
	    }
	}
	return btn;
}

///Add by wsp 2016-3-22 业务审核进度查询点击事件
function approveFlowDetail(value,row,index)
{
	var url="dhceqapproveinfo.csp"
	var arg="?&BussType="+row.bussType+"&BussID="+row.bussID;
	url+=arg;
	btn='<A onclick="window.open(&quot;'+url+'&quot,&quot;_blank&quot,&quot;toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=600,left=400,top=100&quot)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>'
	return btn;
}
*/