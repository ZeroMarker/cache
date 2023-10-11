///modified by ZY0298 处理乱码问题
///增加提示处理
var SelectedRow="undefined";
var Columns=getCurColumnsInfo('EM.G.AccountPeriod','','','')
$(document).ready(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  
	
});
function initDocument()
{
	initUserInfo();
    initMessage(""); //获取所有业务消息
    initLookUp(); //初始化放大镜
	defindTitleStyle(); 
    initButton(); //按钮初始化
    //initPage(); //非通用按钮初始化
    initButtonWidth();
    initAPEquipTypeIDs();
    setEnabled(); //按钮控制
	jQuery("#BCancel").linkbutton({text:'撤销'});
	$HUI.datagrid("#tDHCEQAccountPeriod",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAccountPeriod",
	        	QueryName:"AccountPeriodList",
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		fit:true,
	    singleSelect:true,
		fitColumns:false,    //modify by lmm 2018-11-07 734076
		pagination:true,
		striped : true,
	    cache: false,
		columns:Columns,
		onClickRow:function(rowIndex,rowData){SelectRowHandler(rowIndex,rowData);},
		
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}

function initAPEquipTypeIDs()
{
	var EquipTypeData=getElementValue("EquipTypeData")
	var jsonData=jQuery.parseJSON(EquipTypeData);
	var EquipTypeData=eval('(' + jsonData.Data+ ')');
    $("#APEquipTypeIDs").keywords({
       	items:EquipTypeData
    });
}
function BAudit_Clicked()
{
	var APYear=getElementValue("APYear")
	if (APYear=="")
	{
		alertShow("年度不能为空!")
		return
	}
	var APMonth=getElementValue("APMonth")
	if (APMonth=="")
	{
		alertShow("月份不能为空!")
		return
	}
	var APStartDate=getElementValue("APStartDate")
	if (APStartDate=="")
	{
		alertShow("开始日期不能为空!")
		return
	}
	var APEndDate=getElementValue("APEndDate")
	if (APEndDate=="")
	{
		alertShow("结束日期不能为空!")
		return
	}
	if (APEndDate<=APStartDate)
	{
		alertShow("结束日期不能比开始日期小!")
		return
	}
	messageShow("confirm","info","提示","1.当前会计周期:"+APYear+"-"+APMonth+",<br>2.开始日期:"+APStartDate+",<br>3.结束日期:"+APEndDate+",<br>4.操作会计提折旧,生成快照和月结报表。<br>请确定是否要继续执行操作?","",ExecuteJob,function(){return},"确定","取消");
	
}
function ExecuteJob()
{
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BAudit",true)
	
	$.messager.progress({
				title: "提示",
				msg: '正在执行操作',
				text: '执行中....'
			});
	$cm({
		ClassName:"web.DHCEQ.EM.BUSAccountPeriod",
		MethodName:"ExecuteJob",
		data:data
	},function(jsonData){
		//jsonData=JSON.parse(jsonData)
		$.messager.progress('close');
		if (jsonData.SQLCODE==0)
		{
			//disableElement("BAudit",false);
			alertShow("执行成功!");
			url="dhceq.fam.accountperiod.csp?"
		    window.location.href= url;
			return
		}
		else
	    {
		    disableElement("BAudit",false)
			alertShow("错误信息:"+jsonData.Data);
			return
	    }
	});
	//var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountPeriod","ExecuteJob",data);
	//jsonData=JSON.parse(jsonData)
	
}
function BCancel_Clicked()
{
	var APYear=getElementValue("APYear")
	if (APYear=="")
	{
		alertShow("年度不能为空!")
		return
	}
	var APMonth=getElementValue("APMonth")
	if (APMonth=="")
	{
		alertShow("月份不能为空!")
		return
	}
	var APStartDate=getElementValue("APStartDate")
	if (APStartDate=="")
	{
		alertShow("开始日期不能为空!")
		return
	}
	var APEndDate=getElementValue("APEndDate")
	if (APEndDate=="")
	{
		alertShow("结束日期不能为空!")
		return
	}
	
	messageShow("confirm","info","提示","当前操作会修改的内容:<br>1.把会计周期:"+APYear+"-"+APMonth+"的折旧改回到前一个周期,<br>2.删除当前周期的快照,<br>3.删除当前周期的月报记录,<br>请确定是否要继续执行撤销操作?","",
	function(){
		
			$.messager.progress({
						title: "提示",
						msg: '正在撤销执行',
						text: '执行中....'
					});
			$cm({
				ClassName:"web.DHCEQ.EM.BUSAccountPeriod",
				MethodName:"CancelJob",
				APRowID:APRowID
			},function(jsonData){
				//jsonData=JSON.parse(jsonData)
				$.messager.progress('close');
				if (jsonData.SQLCODE==0)
				{
					//disableElement("BAudit",false);
					alertShow("撤销成功!");
					url="dhceq.fam.accountperiod.csp?"
				    window.location.href= url;
					return
				}
				else
			    {
				    disableElement("BCancel",false)
					alertShow("错误信息:"+jsonData.Data);
					return
			    }
			});
		
		},
	function(){return},
	"确定",
	"取消");
}
function setEnabled()
{
	disableElement("APYear",true); 
	disableElement("APMonth",true);
	disableElement("APStartDate",true);
	disableElement("APStartTime",true);
	disableElement("APEndDate",true); 
	//disableElement("BAudit",true);
	disableElement("BCancel",true);
}
function SelectRowHandler(rowIndex,rowData)
{
	if (rowIndex==SelectedRow)
	{
		setElement("APRowID","");
		setElement("APYear",getElementValue("NewAPYear")); 
		setElement("APMonth",getElementValue("NewAPMonth"));
		setElement("APStartDate",getElementValue("NewStartDate"));
		setElement("APStartTime","");
		setElement("APEndDate",GetCurrentDate()); 
		setElement("APEndTime","");
		setElement("APSnapID","");
		setElement("APRemark","");
		SelectedRow= "undefined";
		//initButton();
		disableElement("BAudit",false);
		disableElement("BCancel",true);
	}
	else
	{
		setElementByJson(rowData);
		//initButton();
		disableElement("BAudit",true);
		///控制是否最后一条记录，只有最后一条记录才可以撤销
		var APRowID=getElementValue("APRowID");
		var LastRowID=getElementValue("LastRowID");
		var APRemark=getElementValue("APRemark");
		if ((APRowID!=LastRowID)||(APRemark=="初始记录"))
		{
			disableElement("BCancel",true);
		}
		else
		{
			disableElement("BCancel",false);
		}
		SelectedRow=rowIndex
	}
}
