///Generator: zx
///Creation Data:  2016-09-08
///Function���豸������̨
/// add by zx 2019-02-26 ZX0058
/// ��ģ�������첽����,�Ż������ٶ�
initUserInfo();
///jquery�������
jQuery(document).ready(function()
{
	$(".eq_echarts").each(function(){
		var parentHeight=$(this).parent().parent().height();
		$(this).parent().panel('resize',{ height:parentHeight});
	});
	defindTitleStyle();
	initMenu(); //��ʼ������������
	//��ʼ��ͼ��
	initEcharts_MaintControl();
	initEcharts_EmergencyControl();
	//initEcharts_CompositionOfAssets(); //add by zx 2019-02-26 ZX0058 ��ά�޷ֲ�ͬʱ����
	//��ʼ��ά�޴�������
	initMaintWaitListDataGrid();
	$("#mainview").layout('remove','north'); //Modife by zx 2020-03-13 BUG ZX0080 ������ϢӰ�ش���,��Ҫʱ�ſ�
}); 
///��ʼ��ά�޼��ͼ���ʲ��������ͼ��
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
		var subtext="�豸�����Ϊ"+AvailabilityRate+"%,�����豸"+totalQty+"̨,�����豸Ϊ"+MaintQty+"̨.";

		var objMaintControl=new setEchertsData('',subtext,'',maintLegendData,'�����豸','pie',maintSeriesData,'','');
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
		var subtext="ԭֵ<10000ΪC�࣬10000<=ԭֵ<100000ΪB�࣬ԭֵ>=100000ΪA�ࡣ"  //Modify By zx 2020-02-18 BUG ZX0074
		var objCompositionOfAssets=new setEchertsData('',subtext,'',legendData,'ABC����ͳ��','pie',seriesData,'','')
		initEcharts("CompositionOfAssets",objCompositionOfAssets);
	});
}
///��ʼ�������豸���ͼ��
function initEcharts_EmergencyControl()
{
	var xAxisData = new Array();  //
	var seriesData = new Array();
	var stockData = new Array();
	var loadData = new Array();
	var unUseData = new Array();
	var barName= new Array("�ڳ�ԭֵ","�����¹�","��ĩԭֵ");
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
				xAxisData.push("");   //add by zx 2017-03-30 ����ţ�357255 
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
		var objEmergencyControl=new setEchertsData('','',['#91C7AE'],barName,'���������¹��ʲ�����ĩ����','line',seriesData,xAxisData,yAxisType)
		initEcharts("EmergencyControl",objEmergencyControl);
	});
}
///��ʼ���ʲ��������ͼ��
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
	var objCompositionOfAssets=new setEchertsData('','','',legendData,'ABC����ͳ��','pie',seriesData,'','')
	initEcharts("CompositionOfAssets",objCompositionOfAssets);
}
//�������˵����ݺ��¼�
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
		//add by zx 2019-07-16 ��ҵ�����Ӱ����Ӧ����
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
///����������������ʱ���tab���¼�
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
	    //Add By QW20200604 BUG:QW0065 Begin ����-ά�޽����ʼ��
	    var head='<div data-options="region:\'north\',border:false" style="border-bottom:solid 1px #ccc;padding:10px 0 10px 0;"><div class="eq-table-tr">';
		var BDate='<div class="eq-table-td "><a id="BPopoverDate" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">��������</a></div>';
		var BLoc='<div class="eq-table-td "><a id="BPopoverLoc" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">��������</a></div>';
		var BMainter='<div class="eq-table-td "><a id="BPopoverMainter" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">ά����</a></div>';
        ///Modified By QW20200707 BUG:QW0069 begin ����״̬���� 
		var BAction='<div class="eq-table-td "><a id="BPopoverAction" href="#"  iconCls="icon-w-filter" class="hisui-linkbutton  hover-dark">״̬����</a></div>'; 
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
		    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		    columns:Columns,
		    toolbar:Toolbar,
			pagination:true,
			pageSize:20,
			pageNumber:1,
			pageList:[20,40,60,80,100]
		});
		//Add By QW20200604 BUG:QW0065 Begin ����-ά�޽����ʼ��
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
//Add By QW20200604 BUG:QW0065 ��ʼ�����ڲ�ѯ
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
	            text:"ɸѡ����",
	            type:"chapter", //��
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'����',id:'1'},
							{text:'��3��',id:'2'},
							{text:'��7��',id:'3'},
							{text:'������',id:'4'},
							{text:'��1��',id:'5'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'��һ��',id:'6'},
							{text:'��һ��',id:'7'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'ָ������',id:'8'}
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
//Add By QW20200604 BUG:QW0065 ��ʼ�����Ҳ�ѯ
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
	            text:"ɸѡ����",
	            type:"chapter", //��
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'����',id:'1'},
							{text:'����',id:'2'},
							{text:'ָ������',id:'3'}
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
//Add By QW20200604 BUG:QW0065 ��ʼ��ά���˲�ѯ
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
	            text:"ɸѡ����",
	            type:"chapter", //��
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'����',id:'1'},
							{text:'����',id:'2'},
							{text:'����',id:'3'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'ָ��ά����',id:'4'}
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
///Add By QW20200707 BUG:QW0069 ��ʼ�� ״̬����
function initActionItem(tableID,BussCode)
{
	var ActionItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQ.Plat.LIBMessages","GetActionByBussType",BussCode)
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	ActionItem.push({text:'����',id:'0'});
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
	            text:"ɸѡ����",
	            type:"chapter", //��
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
//Add By QW20200604 BUG:QW0065 ���ݲ�ѯ����ˢ��ά���б�
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
///��ʼ�����ϽǴ���ά���¼�����
function initMaintWaitListDataGrid()
{
	ObjTabsInfo=new editTabsInfo("","31");
	var Columns=ObjTabsInfo.columns
	var QueryParams=ObjTabsInfo.queryParams
	var Toolbar=ObjTabsInfo.toolbar
	$HUI.datagrid("#tMaintWaitList",{
		url:$URL,
		queryParams:QueryParams,
		border:false,  //add by zx 2019-06-14 ��ʽ�ı�,ȥ���߿� Bug ZX0067
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:Columns,
	    toolbar:Toolbar,
		pagination:true,
		pageSize:7,
		pageNumber:1,
		pageList:[7,14,21,28,35]
	});
}

///11:�������� 12:��װ�������� 21:��⡢22:ת�� 23:���� 31:ά�ޡ�32������33��顢34���ϡ�35�۾ɡ�41ʹ�ü�¼��51�豸����,52 �豸 
///61�����̹��� 62�����п���  
///63��֤����63-1����Ӧ��,63-2����������,63-3������֤�� 64������ 
///71������  72����飬73:�豸����  74:����豸����	75:�ɹ���ͬ����  76:�ƻ����� 
///81: ���
///91���ɹ����� 92���ɹ��ƻ� 93���ɹ��б� 94���ɹ���ͬ
///A01:������ A02:���ת�� A03:����˻� A04:�������
///��busscode�����������
///modified by czf 20181029 735198
///modified by kdf 20190102 �������̨�㿪���� ����Ϊ�յ�����
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
	this.queryParams=queryParams; //���ݲ�ͬ��ҵ���岻ͬ��query
	this.columns=getCurColumnsInfo(componentArray[busscode],"","",""); ///��̬��һ��columns��Ϣx
	this.toolbar=""
}
//Add By QW20200604 BUG:QW0065 LookUp�����ֵ
function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}
//Add By QW20200604 BUG:QW0065 LookUp������
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}