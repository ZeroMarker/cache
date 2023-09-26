///Generator: zx
///Creation Data:  2016-09-08
///Function：设备管理工作台
/// add by zx 2019-02-26 ZX0058
/// 各模块数据异步加载,优化加载速度
initUserInfo();
///jquery界面入口
jQuery(document).ready(function()
{
	$(".eq_echarts").each(function(){
		var parentHeight=$(this).parent().parent().height();
		$(this).parent().panel('resize',{ height:parentHeight});
	});
	defindTitleStyle();
	initMenu(); //初始化左侧待办事项
	//初始化图表
	initEcharts_MaintControl();
	initEcharts_EmergencyControl();
	//initEcharts_CompositionOfAssets(); //add by zx 2019-02-26 ZX0058 与维修分布同时加载
	//初始化维修待办数据
	initMaintWaitListDataGrid();
	$("#mainview").layout('remove','north'); //Modife by zx 2020-03-13 BUG ZX0080 滚动信息影藏处理,需要时放开
}); 
///初始化维修监控图表及资产总体情况图表
function initEcharts_MaintControl()
{
    var maintLegendData = new Array();
	var maintSeriesData = new Array();
    var subtext=""
	var MaintQty=0
	//add by zx 2019-02-26 ZX0058
	var legendData = new Array(); 
    var seriesData = new Array();
    
	$cm({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		MethodName:"GetMainOfEquipRange",
		GroupID:curSSGroupID,
		LocID:curLocID,
		QXType:getElementValue("#QXType"),
		UserID:curUserID
	},function(jsonData){
		
		var maintControlData=jsonData.Data["MaintMonitorData"];
	    var compositionOfAssetsData=jsonData.Data["ABCTypeData"];
		var totalQty=jsonData.Data["TotalQty"];
		
		var controlDataList=maintControlData.split("^");
		var controlDataLen=controlDataList.length;
		for(var i=0;i<controlDataLen;i++)
		{
			var data=controlDataList[i].split(":");
			if (data[1]==undefined) data[1]=0;
			var newSeriesData=new setSeriesData(data[0],data[1]);
			maintSeriesData.push(newSeriesData);
			maintLegendData.push(data[0]);
			MaintQty=MaintQty+parseInt(data[1]);
		}
		var AvailabilityRate=((1-(MaintQty/totalQty))*100).toFixed(2);
		var subtext="设备完好率为"+AvailabilityRate+"%,共计设备"+totalQty+"台,在修设备为"+MaintQty+"台.";

		var objMaintControl=new setEchertsData('',subtext,'',maintLegendData,'在修设备','pie',maintSeriesData,'','');
		initEcharts("MaintControl",objMaintControl);
		
		var assetsDataList=compositionOfAssetsData.split("^");
		var assetsDataLen=assetsDataList.length;
		for(var i=0;i<assetsDataLen;i++)
		{
			var data=assetsDataList[i].split(":");
			if (data[1]==undefined) data[1]=0;
			var newSeriesData=new setSeriesData(data[0],data[1]);
			seriesData.push(newSeriesData);
			legendData.push(data[0]);
		}
		var subtext="原值<10000为C类，10000<=原值<100000为B类，原值>=100000为A类。"  //Modify By zx 2020-02-18 BUG ZX0074
		var objCompositionOfAssets=new setEchertsData('',subtext,'',legendData,'ABC分类统计','pie',seriesData,'','')
		initEcharts("CompositionOfAssets",objCompositionOfAssets);
	});
}
///初始化急救设备监控图表
function initEcharts_EmergencyControl()
{
	var xAxisData = new Array();  //
	var seriesData = new Array();
	var stockData = new Array();
	var loadData = new Array();
	var unUseData = new Array();
	var barName= new Array("期初原值","本月新购","期末原值");
    var yAxisType='value';
    //add by zx 2019-02-26 ZX0058
    $m({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		MethodName:"GetMainOfEmergency",
		GroupID:curSSGroupID,
		LocID:curLocID,
		QXType:getElementValue("#QXType"),
		UserID:curUserID
	},function(dataList){
		var dataList=dataList.split("^")
		var Len=dataList.length;
		for(var i=0;i<Len;i++)
		{
			var data=dataList[i].split(":");
			if(data=="")
			{
				xAxisData.push("");   //add by zx 2017-03-30 需求号：357255 
				loadData.push(0);
				unUseData.push(0);
				stockData.push(0);
			}
			else
			{
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
		var objEmergencyControl=new setEchertsData('','',['#91C7AE'],barName,'六个月内新购资产及期末汇总','line',seriesData,xAxisData,yAxisType)
		initEcharts("EmergencyControl",objEmergencyControl);
	});
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
	var objCompositionOfAssets=new setEchertsData('','','',legendData,'ABC分类统计','pie',seriesData,'','')
	initEcharts("CompositionOfAssets",objCompositionOfAssets);
}
//处理左侧菜单数据和事件
function initMenu()
{
	//add by zx 2019-02-26 ZX0058
	$m({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		MethodName:"GetMainOfMenu",
		GroupID:curSSGroupID,
		LocID:curLocID,
		QXType:getElementValue("#QXType"),
		UserID:curUserID
	},function(dataList){
		var dataList=dataList.split("^")
		var Len=dataList.length;
		for(var i=0;i<Len;i++)
		{
			var data=dataList[i].split(":");
			var MenuType=data[0];
			var BussTypeID=data[1];
			var BussCode=data[2];
			var BussType=data[3];
			var WaitNum=data[4];
			jQuery('#'+MenuType).append('<li onclick ="addTabsData_Clicked(&quot;'+BussCode+','+BussType+'&quot;)" '+'><span class='+'"eq_radius"'+'>'+WaitNum+'</span><a>'+BussType+'</a></li>')
		}
		//add by zx 2019-07-16 无业务或保养影藏相应标题
		var bussWaitHtml=$("#Buss").html();
	   	if(bussWaitHtml==""||bussWaitHtml.length==0){
	    	$("#BussWait").css('display','none')
	    }
	    var warningWaitHtml=$("#Warning").html();
	   	if((warningWaitHtml=="")||(warningWaitHtml.length==0)){
	    	$("#WarningWait").css('display','none')
	    }
	});
	
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
		var objTabsInfo=new editTabsInfo(BussType,BussCode);
	    var tableID=objTabsInfo.tableID;
	    var Columns=objTabsInfo.columns;
	    var QueryParams=objTabsInfo.queryParams;
	    var Toolbar=objTabsInfo.toolbar;
	    //Add By QW20200604 BUG:QW0065 Begin 待办-维修界面初始化
	    var head='<div data-options="region:\'north\',border:false" style="border-bottom:solid 1px #ccc;padding:10px 0 10px 0;"><div class="eq-table-tr">';
		var BDate='<div class="eq-table-td "><a id="BPopoverDate" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">申请日期</a></div>';
		var BLoc='<div class="eq-table-td "><a id="BPopoverLoc" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">所属科室</a></div>';
		var BMainter='<div class="eq-table-td "><a id="BPopoverMainter" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">维修人</a></div>';
        ///Modified By QW20200707 BUG:QW0069 begin 增加状态进度 
		var BAction='<div class="eq-table-td "><a id="BPopoverAction" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">状态进度</a></div>'; 
		var html=head+BDate+BLoc+BMainter+BAction+'</div></div>';
 		///Modified By QW20200707 BUG:QW0069 end 
		if (BussCode=="31")
	    {
		   var content ='<div class="hisui-layout" data-options="fit:true,border:false""><div data-options="region:\'center\',border:false"><div class="hisui-layout" data-options="fit:true,border:false">'+ html+'<div data-options="region:\'center\',border:false" style="position:relative;"><table class="hisui-datagrid" id="'+tableID+'"></table></div>'+'</div></div></div>'; 
		}
		else{
			var content = '<table class="hisui-datagrid" id="'+tableID+'"></table>';
		}
		//Add By QW20200604 BUG:QW0065 End
		$("#TabsData").tabs('add',{
			title:BussType,
			iconCls:'icon-tip',
			fit:true,
			closable:true,
			selected:true,
			content:content
		});
		$HUI.datagrid("#"+tableID,{
			url:$URL,
			queryParams:QueryParams,
			border:true, //Add By QW20200604 BUG:QW0065 Begin
		    fit:true,
		    fitColumns : true,
	    	scrollbarSize:0, 
	    	border:false,  //Add By QW20200604 BUG:QW0065 End
		    singleSelect:true,
		    rownumbers: true,  //如果为true，则显示一个行号列。
		    columns:Columns,
		    toolbar:Toolbar,
			pagination:true,
			pageSize:20,
			pageNumber:1,
			pageList:[20,40,60,80,100]
		});
		//Add By QW20200604 BUG:QW0065 Begin 待办-维修界面初始化
		if (BussCode=="31")
		{
			 initLookUp();
			 initButtonWidth();
			 initDateItem(tableID);
			 initLocItem(tableID);
			 initMainterItem(tableID);
			 initActionItem(tableID,BussCode); ///Add By QW20200707 BUG:QW0069
		}
		//Add By QW20200604 BUG:QW0065 Begin
    }
}
//Add By QW20200604 BUG:QW0065 初始化日期查询
function initDateItem(tableID)
{
	$('#BPopoverDate').webuiPopover({
		width:'auto',//can be set with  number
    	height:'auto',//can be set with  number
		url:'#DateItem',
		dismissible:false,
		onShow: function($element) {
			$HUI.keywords("#DateItemDetail").select(getElementValue("DatePattern"));
			if(getElementValue("DatePattern")=="8") 
			{
				disableElement("StartDate",false);
			   	disableElement("EndDate",false);
			}
		}
    });
    $("#DateItemDetail").keywords({
	    onClick:function(v){
		   if(v.id=="8")
		   {
			   	disableElement("StartDate",false);
			   	disableElement("EndDate",false);
			}else{
				disableElement("StartDate",true);
			   	disableElement("EndDate",true);
			   	setElement("StartDate","");
			   	setElement("EndDate","");
			}
		},
	    singleSelect:true,
		items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'不限',id:'1'},
							{text:'近3天',id:'2'},
							{text:'近7天',id:'3'},
							{text:'近两周',id:'4'},
							{text:'近1月',id:'5'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'超一周',id:'6'},
							{text:'超一月',id:'7'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'指定日期',id:'8'}
						]
	                }
	            ]
	        }
	    ]
	});
	$("#BDateSure").click(function(){
		var dateItemKeyObj=$HUI.keywords("#DateItemDetail").getSelected();
		setElement("DatePattern",dateItemKeyObj[0].id);
		refreshTabsGrid(tableID);
		$('#BPopoverDate').webuiPopover('hide');
	});
}
//Add By QW20200604 BUG:QW0065 初始化科室查询
function initLocItem(tableID)
{
	$('#BPopoverLoc').webuiPopover({
		width:'auto',//can be set with  number
    	height:'auto',//can be set with  number
		url:'#LocItem',
		dismissible:false,
		onShow: function($element) {
			$HUI.keywords("#LocItemDetail").select(getElementValue("LocPattern"));
			if(getElementValue("LocPattern")=="3") $("#UseLoc").lookup("enable");
		}
    });
    $("#LocItemDetail").keywords({
	    	onClick:function(v){
			   if(v.id=="3")
			   {
				   	$("#UseLoc").lookup("enable");
				}else{
					$("#UseLoc").lookup("disable");
					setElement("UseLocDR","");
					setElement("UseLoc","");
				}
			},
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'不限',id:'1'},
							{text:'本科',id:'2'},
							{text:'指定科室',id:'3'}
						]
	                }
	            ]
	        }
	    ]
	});
	$("#BLocSure").click(function(){
		var locItemKeyObj=$HUI.keywords("#LocItemDetail").getSelected();
		setElement("LocPattern",locItemKeyObj[0].id);
		refreshTabsGrid(tableID);
			$('#BPopoverLoc').webuiPopover('hide');
		});
}
//Add By QW20200604 BUG:QW0065 初始化维修人查询
function initMainterItem(tableID)
{
	$('#BPopoverMainter').webuiPopover({
		width:200,//can be set with  number
    	height:'auto',//can be set with  number
		url:'#MainterItem',
		dismissible:false,
		onShow: function($element) {
			$HUI.keywords("#MainterItemDetail").select(getElementValue("UserPattern"));
			if(getElementValue("UserPattern")=="4") $("#MaintUser").lookup("enable");
		}
    });
    $("#MainterItemDetail").keywords({
	    	onClick:function(v){
			   if(v.id=="4")
			   {
				   	$("#MaintUser").lookup("enable");
				}else{
					$("#MaintUser").lookup("disable");
					setElement("MaintUserDR","");
					setElement("MaintUser","");
				}
			},
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'不限',id:'1'},
							{text:'本人',id:'2'},
							{text:'他人',id:'3'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'指定维修人',id:'4'}
						]
	                }
	            ]
	        }
	    ]
	});
	$("#BMainterSure").click(function(){
		var mainterItemKeyObj=$HUI.keywords("#MainterItemDetail").getSelected();
		setElement("UserPattern",mainterItemKeyObj[0].id);
		refreshTabsGrid(tableID);
		$('#BPopoverMainter').webuiPopover('hide');
	});
}
///Add By QW20200707 BUG:QW0069 初始化 状态进度
function initActionItem(tableID,BussCode)
{
	var ActionItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQ.Plat.LIBMessages","GetActionByBussType",BussCode)
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	ActionItem.push({text:'不限',id:'0'});
	var list=Vallist.split("&");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[2]
		ActionItem.push({text:text,id:id});
	}
	$('#BPopoverAction').webuiPopover({
		width:200,//can be set with  number
    	height:'auto',//can be set with  number
		url:'#ActionItem',
		dismissible:false,
		onShow: function($element) {
			$HUI.keywords("#ActionItemDetail").select(getElementValue("ActionID"));
		}
    });
    $("#ActionItemDetail").keywords({
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:ActionItem
	                }
	            ]
	        }
	    ]
	});
	$("#BActionSure").click(function(){
		var ActionItemKeyObj=$HUI.keywords("#ActionItemDetail").getSelected();
		setElement("ActionID",ActionItemKeyObj[0].id);
		refreshTabsGrid(tableID);
		$('#BPopoverAction').webuiPopover('hide');
	});
}
//Add By QW20200604 BUG:QW0065 根据查询条件刷新维修列表
function refreshTabsGrid(tableID)
{
	var queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetBussDataByCode",
					BussType:'31',
					GroupID:'',
					UserID:'',
					CurLocDR:'',
					EquipDR:'',
					DatePattern:getElementValue("DatePattern"), 
					StartDate:getElementValue("StartDate"), 
					EndDate:getElementValue("EndDate"), 
					LocPattern:getElementValue("LocPattern"), 
					UseLocDR:getElementValue("UseLocDR"), 
					UserPattern:getElementValue("UserPattern"), 
					UserDR:getElementValue("MaintUserDR"),
					vActionDR:getElementValue("ActionID")  ///Add By QW20200707 BUG:QW0069
			};
		$HUI.datagrid("#"+tableID,{
			url:$URL,
			queryParams:queryParams
		});
}
///初始化右上角待办维修事件数据
function initMaintWaitListDataGrid()
{
	ObjTabsInfo=new editTabsInfo("","31");
	var Columns=ObjTabsInfo.columns
	var QueryParams=ObjTabsInfo.queryParams
	var Toolbar=ObjTabsInfo.toolbar
	$HUI.datagrid("#tMaintWaitList",{
		url:$URL,
		queryParams:QueryParams,
		border:false,  //add by zx 2019-06-14 样式改变,去掉边框 Bug ZX0067
	    fit:true,
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
///71：保养  72：检查，73:设备保修  74:租借设备到期	75:采购合同到货  76:计划付款 
///81: 监控
///91：采购申请 92：采购计划 93：采购招标 94：采购合同
///A01:配件入库 A02:配件转移 A03:配件退货 A04:配件减少
///用busscode做数组的索引
///modified by czf 20181029 735198
///modified by kdf 20190102 解决工作台点开报废 界面为空的问题
var componentArray = {"11":"EM.G.Queue.OpenCheckRequest", "12":"EM.G.Queue.OpenCheckRequest", "21":"EM.G.Queue.InStock", "22":"EM.G.Queue.StoreMove", "23":"EM.G.Queue.Return", "31":"EM.G.Queue.MaintRequest", "32":"32",
					"33":"33", "34":"EM.G.Queue.DisuseRequest", "35":"35", "41":"41", "51":"51", "52":"52", "61":"61",
					"62":"62", "63":"Plat.G.Queue.Certificate", "63-1":"Plat.G.Queue.Vendor", "63-2":"Plat.G.Queue.Manufacturer", "63-3":"Plat.G.Queue.Certificate", "64":"RM.G.Queue.Rent",
					"71":"EM.G.Queue.MaintAlert", "72-1":"EM.G.Queue.MaintAlert","72-2":"EM.G.Queue.MaintAlert", "73":"EM.G.Queue.GuaranteeAlert", "75":"EM.G.Queue.ContractArriveAlert", "76":"EM.G.Queue.PayPlanAlert",
					"81":"81", "91":"EM.G.Queue.BuyRequest", "92":"EM.G.Queue.BuyPlan", "93":"93",
					"A01":"A01", "A02":"A02", "A03":"A03", "A04":"A04"};

function editTabsInfo(title,busscode)
{
	this.title=title;
	this.busscode=busscode;
	this.tableID="table"+busscode;
	
	switch (busscode)
	{
		case '63-1':
			queryParams={	
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",	///modified by czf 20181029 735198
		        	QueryName:"GetCertificateData",
					BussType:busscode
			    	};
		  	break;
		case '63-2':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetCertificateData",
					BussType:busscode
			    	};
		  	break;
		case '63-3':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetCertificateData",
					BussType:busscode
			    	};
		  	break;
		case '71':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetMaintAlertData",
					BussType:busscode
			    	};
		  	break;
		case '72-1':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetMaintAlertData",
					BussType:busscode
			    	};
		  	break;
		case '72-2':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetMaintAlertData",
					BussType:busscode
			    	};
		  	break;
		case '73':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetGuaranteeData",
					CurBussCode:busscode
			    	};
		  	break;
		case '74':
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetRentData",
					BussType:busscode
			    	};
		  	break;
		case '75':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetContractArriveData",
					CurBussCode:busscode
			    	};
		  	break;
		case '76':
			queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetPayPlanData",
					CurBussCode:busscode
			    	};
		  	break;
		case '81':
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintMonitorData",
					BussType:busscode
			    	};
		  	break;
		case '81-1':
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetMaintMonitorData",
					BussType:busscode
			    	};
		  	break;
		default:
			var queryParams={
			    	ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetBussDataByCode",
					BussType:busscode,
					GroupID:'',
					UserID:'',
					CurLocDR:'',
					EquipDR:''
			    	};
		  	break;
	}
	this.queryParams=queryParams; //根据不同的业务定义不同的query
	this.columns=getCurColumnsInfo(componentArray[busscode],"","",""); ///动态成一个columns信息x
	this.toolbar=""
}
//Add By QW20200604 BUG:QW0065 LookUp组件赋值
function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}
//Add By QW20200604 BUG:QW0065 LookUp组件清空
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}