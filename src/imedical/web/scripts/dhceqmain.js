///modified by zy 20160922
/*
Generator: 邹旋 
Creation Data:  2016-09-08
Function：设备管理工作台
*/

///定义一个对象,把全局变量的数据放在里面。
var GlobalObj = {
	//参数
	QXType : "",
	ReadOnly : "",
	vData : "",
	//后台取出来的数据
	TotalQty : "",					///资产总数量
	TotalOriginalFee : "",			///资产总金额
	MaintControlData : "",			///维修监控数据
	EmergencyControlData : "",		///急救设备数据
	CompositionOfAssetsData : "",	///资产总体情况数据
	MenuData : "",					///待办事项数据
	
	getManagementData : function ()
	{
		this.QXType=$("#QXType").val()
		this.ReadOnly=$("#ReadOnly").val()
		this.vData=$("#vData").val()
		var ManagementData=""
	    $.ajax({
		    	async: false,
	            url :"dhceq.jquery.method.csp",
	            type:"POST",
		            data:{
	                ClassName:"web.DHCEQMessages",
	                MethodName:"GetManagementInfo",
			        Arg1:SessionObj.GGROURPID,
			        Arg2:SessionObj.GLOCID,
			        Arg3:GlobalObj.QXType,
			        ArgCnt:3
	            },
	           	error:function(XMLHttpRequest, textStatus, errorThrown){
	                        messageShow("","","",XMLHttpRequest.status);
	                        messageShow("","","",XMLHttpRequest.readyState);
	                        messageShow("","","",textStatus);
	            },
	            success:function (data, response, status) {
	            	$.messager.progress('close');
					data=data.replace(/\ +/g,"")	//去掉空格
					data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	            	ManagementData=data
	           }
	        })
	     var Data=ManagementData.split("&");
	     var EquipmentData=Data[0];
	     this.MaintControlData=Data[1];
	     this.EmergencyControlData=Data[2];
	     this.CompositionOfAssetsData=Data[3];
	     this.MenuData=Data[4];
	     
		 EquipmentData= EquipmentData.split(":")
		 this.TotalQty=EquipmentData[0]
		 this.TotalOriginalFee=EquipmentData[1]
	     
	}
}

///jquery界面入口
jQuery(document).ready(function()
{
	//初始化系统变量,通过ajxe从后台取数据
	GlobalObj.getManagementData();
	initMenu(); //初始化左侧待办事项
	//初始化图表
	initEcharts_MaintControl()
	initEcharts_EmergencyControl()	
	initEcharts_CompositionOfAssets()
	//初始化维修待办数据
	initMaintWaitListDataGrid();
}); 
///初始化维修监控图表
function initEcharts_MaintControl()
{
    var legendData = new Array();  //data=['直接访问','邮件营销','联盟广告','视频广告','搜索引擎'];  
	var seriesData = new Array();  //data=[{value:335, name:'直接访问'},{value:310, name:'邮件营销'},{value:234, name:'联盟广告'},{value:135, name:'视频广告'},{value:1548, name:'搜索引擎'}]
    var subtext=""
	var MaintQty=0

	var dataList=GlobalObj.MaintControlData.split("^")
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":")
		if (data[1]==undefined) data[1]=0
		var newSeriesData=new setSeriesData(data[0],data[1])
		seriesData.push(newSeriesData)
		legendData.push(data[0])
		MaintQty=MaintQty+parseInt(data[1])
	}
	var AvailabilityRate=((1-(MaintQty/GlobalObj.TotalQty))*100).toFixed(2)
	var subtext="设备完好率为"+AvailabilityRate+"%,共计设备"+GlobalObj.TotalQty+"台,在修设备为"+MaintQty+"台."

	var objMaintControl=new setEchertsData('维修监控',subtext,'',legendData,'在修设备','pie',seriesData,'','')
	initEcharts("MaintControl",objMaintControl);
}
///初始化急救设备监控图表
function initEcharts_EmergencyControl()
{
    //var seriesData = new Array();  //   add by zx 2017-02-22 柱状图样式改变
	var xAxisData = new Array();  //
	var seriesData = new Array();
	var stockData = new Array();
	var loadData = new Array();
	var unUseData = new Array();
	var barName= new Array("期初原值","本月新购","期末原值"); //add by zx 2017-03-30  需求号：357255 
    var yAxisType='value'
	var dataList=GlobalObj.EmergencyControlData.split("^");
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":");
	if(data==""){
		xAxisData.push("");   //add by zx 2017-03-30 需求号：357255 
		loadData.push(0);
		unUseData.push(0);
		stockData.push(0);
		}
	else{
		xAxisData.push(data[0]);
		datadetail=data[1].split("-");
		loadData.push(datadetail[0]);
		unUseData.push(datadetail[1]);
		stockData.push(datadetail[2]);
		}	
	}
	var rentDate=new Array(loadData,unUseData,stockData);
	for (j=0;j<3;j++)
	{
		var bardata= new setLineData(barName[j],rentDate[j]);
		seriesData.push(bardata);
	}
	var objEmergencyControl=new setEchertsData('六个月内新购资产及期末汇总','',['#91C7AE'],barName,'六个月内新购资产及期末汇总','line',seriesData,xAxisData,yAxisType)
	initEcharts("EmergencyControl",objEmergencyControl);
	/***************************************************/
//    //var seriesData = new Array();  //   add by zx 2017-02-22 柱状图样式改变
//	var xAxisData = new Array();  //
//	var seriesData = new Array();
//	var stockData = new Array();
//	var loadData = new Array();
//	var unUseData = new Array();
//	var barName= new Array("期初原值","本月新购","期末原值"); //add by zx 2017-03-30  需求号：357255 
//    var yAxisType='value'
//	var dataList=GlobalObj.EmergencyControlData.split("^");
//	var Len=dataList.length;
//	for(var i=0;i<Len;i++)
//	{
//		var data=dataList[i].split(":");
//	if(data==""){
//		xAxisData.push("");   //add by zx 2017-03-30 需求号：357255 
//		loadData.push(0);
//		unUseData.push(0);
//		stockData.push(0);
//		}
//	else{
//		xAxisData.push(data[0]);
//		datadetail=data[1].split("-");
//		loadData.push(datadetail[0]);
//		unUseData.push(datadetail[1]);
//		stockData.push(datadetail[2]);
//		}	
//	}
//	var rentDate=new Array(loadData,unUseData,stockData);
//	for (j=0;j<3;j++)
//	{
//		var bardata= new setBarData(barName[j],rentDate[j]);
//		seriesData.push(bardata);
//	}
//	var objEmergencyControl=new setEchertsData('六个月内新购资产及期末汇总','',['#91C7AE'],barName,'六个月内新购资产及期末汇总','bar',seriesData,xAxisData,yAxisType)
//	initEcharts("EmergencyControl",objEmergencyControl);
}
///初始化资产总体情况图表
function initEcharts_CompositionOfAssets()
{
    var legendData = new Array();  
    var seriesData = new Array();
    
	var dataList=GlobalObj.CompositionOfAssetsData.split("^")
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":")
		if (data[1]==undefined) data[1]=0
		var newSeriesData=new setSeriesData(data[0],data[1])
		seriesData.push(newSeriesData)
		legendData.push(data[0])
	}
	var objCompositionOfAssets=new setEchertsData('资产构成比例','','',legendData,'ABC分类统计','pie',seriesData,'','')
	initEcharts("CompositionOfAssets",objCompositionOfAssets);
}
//处理左侧菜单数据和事件
function initMenu()
{
	var dataList=GlobalObj.MenuData.split("^")
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":")
		var MenuType=data[0]
		var BussTypeID=data[1]
		var BussCode=data[2]
		var BussType=data[3]
		var WaitNum=data[4]
		jQuery('#'+MenuType).append('<li onclick ="addTabsData_Clicked(&quot;'+BussCode+','+BussType+'&quot;)" '+'><span class='+'"eq_radius"'+'>'+WaitNum+'</span><a>'+BussType+'</a></li>')
	}
}
///定义点击左侧待办事项时添加tab的事件
function addTabsData_Clicked(data)
{
	data = data.split(",")
	var BussCode=data[0]
	var BussType=data[1]
	
	if($("#TabsData").tabs('exists',BussType))
    {
        $("#TabsData").tabs('select',BussType);
	}
	else
	{
		var ObjTabsInfo=new editTabsInfo(BussType,BussCode);
	    var tableID=ObjTabsInfo.tableID
	    var Columns=ObjTabsInfo.columns
	    var QueryParams=ObjTabsInfo.queryParams
	    var Toolbar=ObjTabsInfo.toolbar
	    
		var content = '<table id="'+tableID+'"></table>';
		//var content = '<iframe scrolling="auto" frameborder="0"  src="dhceq.management.tab.csp" style="width:100%;height:100%;"></iframe>';
		$("#TabsData").tabs('add',{
			title:BussType,
			iconCls:'icon-tip',
			fit:true,
			closable:true,
			selected:true,
			content:content
			//href:href
			/*
			onSelect:function(title){
				messageShow("","","",title+' is selected');
			}*/
		});
		
	    $("#"+tableID).datagrid({
			    url:'dhceq.jquery.csp', 
			    queryParams:QueryParams,
			    border:true,
			    fit:true,
			    singleSelect:true,
	    		rownumbers: true,  //如果为true，则显示一个行号列。
			    columns:Columns,
			    toolbar:Toolbar,
			    pagination:true,
			    pageSize:20,
			    pageNumber:1,
			    pageList:[20,40,60,80,100]  
	        });
		
    }
}
///初始化右上角待办维修事件数据
function initMaintWaitListDataGrid()
{
	ObjTabsInfo=new editTabsInfo("","31");
	var Columns=ObjTabsInfo.columns
	var QueryParams=ObjTabsInfo.queryParams
	var Toolbar=ObjTabsInfo.toolbar
	jQuery('#tMaintWaitList').datagrid({
		url:'dhceq.jquery.csp',
	    queryParams:QueryParams,
	    border:'true',
	    fit:"true",
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:Columns,
	    toolbar:Toolbar,
		pagination:true,
		pageSize:7,
		pageNumber:1,
		pageList:[7,14,21,28,35]
    });
}

///11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 
///61：工程管理 62：科研课题  
///63：证件：63-1：供应商,63-2：生产厂家,63-3：计量证书 64：租赁 
///71：是保养；72：检查，73：保修;81：监控
///91：采购申请 92：采购计划 93：采购招标 94：采购合同
///A01:配件入库 A02:配件转移 A03:配件退货 A04:配件减少
///用busscode做数组的索引
function editTabsInfo(title,busscode)
{
	this.title=title;
	this.busscode=busscode;
	this.tableID="table"+busscode;
	var queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetBussDataByCode",
					Arg1:busscode,
			        ArgCnt:1
			    	}
	var formatter=""
	switch (busscode)
	{
		case '11':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '21':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '22':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '23':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '31':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '34':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '63-1':
			formatter="";
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetCertificateData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '63-2':
			formatter=""
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetCertificateData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '63-3':
			formatter=""
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetCertificateData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '74':  //add by zx 
			formatter=""
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetRentData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '64':
		  	formatter=detailOperation   //add by zx 
			formatterApprove=approveFlowDetail
			break;
		case '71':
			formatter=planOperation;
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintAlertData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '72-1':
			formatter=planOperation;
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintAlertData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '72-2':
			formatter=planOperation;
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintAlertData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '73':
			formatter="";
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetGuaranteeData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '81':
			formatter="";
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintMonitorData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '81-1':
			formatter="";
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintMonitorData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
		  	break;
		case '91':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '92':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '93':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case '94':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		// add by zx 2016-03-04 Bug ZX0035 配件工作台显示
		case 'A01':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
	    case 'A02':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case 'A03':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		case 'A04':
			formatter=detailOperation
			formatterApprove=approveFlowDetail
		  	break;
		default:
			formatter=""
			formatterApprove=""
		  	break;
	}
	this.queryParams=queryParams; //根据不同的业务定义不同的query
	//modified  by zy 2017-04-06  zy0162  调整取列信息的方法
	this.columns=GetCurColumnsInfo(busscode,"","",""); ///动态成一个columns信息
	this.toolbar=""
}
function detailOperation(value,row,index)
{
	var roleInfo=row.roles.split(",");
	var actionDescInfo=row.actionDesc.split(",");
	var actionCodeInfo=row.actionCode.split(",");
    var btn=""
    for (var i=0;i<roleInfo.length;i++)
    {
	    var para="RowID="+row.msgID+"&ReadOnly="+$('#ReadOnly').val()+"&vData="+$('#vData').val();
        var url="dhceqmessages.csp?"+para;
	    url=url+"&Action="+actionCodeInfo[i]+"&CurRole="+roleInfo[i];
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    var name="审核"
	    if (actionCodeInfo[i]!="") 
	    {
		    name=actionDescInfo[i];
	    }
	    btn=btn+'<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#" style="margin-left:5px">'+name+'</A>';
	}
	return btn;
}
///Add by wsp 2016-3-22 业务审核进度查询点击事件
function approveFlowDetail(value,row,index)
{
	var url="dhceqapproveinfo.csp"
	var arg="?&BussType="+row.bussType+"&BussID="+row.bussID;
	url+=arg;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	btn='<A onclick="window.open(&quot;'+url+'&quot,&quot;_blank&quot,&quot;toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=600,left=400,top=100&quot)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>'
	return btn;
}
function planOperation(value,row,index)
{
	//"&RowID="MaintPlanID_"&EquipDR="TEquipDR_"&BussType=BussType")_"&ReadOnly=ReadOnly")
	if (row.bussType=="71") BussType=1
	if ((row.bussType=="72-1")||(row.bussType=="72-2")) BussType=2		//Add By DJ 2015-12-28
	//var para="RowID="+row.bussID+"&TEquipDR="+row.equipID+"&BussType="+BussType+"&ReadOnly="+$('#ReadOnly').val()
	var para="RowID="+row.bussID+"&TEquipDR="+row.equipID+"&BussType="+BussType+"&ReadOnly=1"	//modified by czf 需求号：330695
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanNew&"+para;
	if (BussType==2)
	{
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInspectPlanNew&"+para;
		if (row.mainttype=="5")
		{
			var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMeteragePlanNew&"+para;
		}
	}
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}