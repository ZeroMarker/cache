///modified by zy 20160922
/*
Generator: ���� 
Creation Data:  2016-09-08
Function���豸������̨
*/

///����һ������,��ȫ�ֱ��������ݷ������档
var GlobalObj = {
	//����
	QXType : "",
	ReadOnly : "",
	vData : "",
	//��̨ȡ����������
	TotalQty : "",					///�ʲ�������
	TotalOriginalFee : "",			///�ʲ��ܽ��
	MaintControlData : "",			///ά�޼������
	EmergencyControlData : "",		///�����豸����
	CompositionOfAssetsData : "",	///�ʲ������������
	MenuData : "",					///������������
	
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
					data=data.replace(/\ +/g,"")	//ȥ���ո�
					data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
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

///jquery�������
jQuery(document).ready(function()
{
	//��ʼ��ϵͳ����,ͨ��ajxe�Ӻ�̨ȡ����
	GlobalObj.getManagementData();
	initMenu(); //��ʼ������������
	//��ʼ��ͼ��
	initEcharts_MaintControl()
	initEcharts_EmergencyControl()	
	initEcharts_CompositionOfAssets()
	//��ʼ��ά�޴�������
	initMaintWaitListDataGrid();
}); 
///��ʼ��ά�޼��ͼ��
function initEcharts_MaintControl()
{
    var legendData = new Array();  //data=['ֱ�ӷ���','�ʼ�Ӫ��','���˹��','��Ƶ���','��������'];  
	var seriesData = new Array();  //data=[{value:335, name:'ֱ�ӷ���'},{value:310, name:'�ʼ�Ӫ��'},{value:234, name:'���˹��'},{value:135, name:'��Ƶ���'},{value:1548, name:'��������'}]
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
	var subtext="�豸�����Ϊ"+AvailabilityRate+"%,�����豸"+GlobalObj.TotalQty+"̨,�����豸Ϊ"+MaintQty+"̨."

	var objMaintControl=new setEchertsData('ά�޼��',subtext,'',legendData,'�����豸','pie',seriesData,'','')
	initEcharts("MaintControl",objMaintControl);
}
///��ʼ�������豸���ͼ��
function initEcharts_EmergencyControl()
{
    //var seriesData = new Array();  //   add by zx 2017-02-22 ��״ͼ��ʽ�ı�
	var xAxisData = new Array();  //
	var seriesData = new Array();
	var stockData = new Array();
	var loadData = new Array();
	var unUseData = new Array();
	var barName= new Array("�ڳ�ԭֵ","�����¹�","��ĩԭֵ"); //add by zx 2017-03-30  ����ţ�357255 
    var yAxisType='value'
	var dataList=GlobalObj.EmergencyControlData.split("^");
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":");
	if(data==""){
		xAxisData.push("");   //add by zx 2017-03-30 ����ţ�357255 
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
	var objEmergencyControl=new setEchertsData('���������¹��ʲ�����ĩ����','',['#91C7AE'],barName,'���������¹��ʲ�����ĩ����','line',seriesData,xAxisData,yAxisType)
	initEcharts("EmergencyControl",objEmergencyControl);
	/***************************************************/
//    //var seriesData = new Array();  //   add by zx 2017-02-22 ��״ͼ��ʽ�ı�
//	var xAxisData = new Array();  //
//	var seriesData = new Array();
//	var stockData = new Array();
//	var loadData = new Array();
//	var unUseData = new Array();
//	var barName= new Array("�ڳ�ԭֵ","�����¹�","��ĩԭֵ"); //add by zx 2017-03-30  ����ţ�357255 
//    var yAxisType='value'
//	var dataList=GlobalObj.EmergencyControlData.split("^");
//	var Len=dataList.length;
//	for(var i=0;i<Len;i++)
//	{
//		var data=dataList[i].split(":");
//	if(data==""){
//		xAxisData.push("");   //add by zx 2017-03-30 ����ţ�357255 
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
//	var objEmergencyControl=new setEchertsData('���������¹��ʲ�����ĩ����','',['#91C7AE'],barName,'���������¹��ʲ�����ĩ����','bar',seriesData,xAxisData,yAxisType)
//	initEcharts("EmergencyControl",objEmergencyControl);
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
	var objCompositionOfAssets=new setEchertsData('�ʲ����ɱ���','','',legendData,'ABC����ͳ��','pie',seriesData,'','')
	initEcharts("CompositionOfAssets",objCompositionOfAssets);
}
//�������˵����ݺ��¼�
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
	    		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			    columns:Columns,
			    toolbar:Toolbar,
			    pagination:true,
			    pageSize:20,
			    pageNumber:1,
			    pageList:[20,40,60,80,100]  
	        });
		
    }
}
///��ʼ�����ϽǴ���ά���¼�����
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
///71���Ǳ�����72����飬73������;81�����
///91���ɹ����� 92���ɹ��ƻ� 93���ɹ��б� 94���ɹ���ͬ
///A01:������ A02:���ת�� A03:����˻� A04:�������
///��busscode�����������
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
		// add by zx 2016-03-04 Bug ZX0035 �������̨��ʾ
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
	this.queryParams=queryParams; //���ݲ�ͬ��ҵ���岻ͬ��query
	//modified  by zy 2017-04-06  zy0162  ����ȡ����Ϣ�ķ���
	this.columns=GetCurColumnsInfo(busscode,"","",""); ///��̬��һ��columns��Ϣ
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
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    var name="���"
	    if (actionCodeInfo[i]!="") 
	    {
		    name=actionDescInfo[i];
	    }
	    btn=btn+'<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#" style="margin-left:5px">'+name+'</A>';
	}
	return btn;
}
///Add by wsp 2016-3-22 ҵ����˽��Ȳ�ѯ����¼�
function approveFlowDetail(value,row,index)
{
	var url="dhceqapproveinfo.csp"
	var arg="?&BussType="+row.bussType+"&BussID="+row.bussID;
	url+=arg;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
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
	var para="RowID="+row.bussID+"&TEquipDR="+row.equipID+"&BussType="+BussType+"&ReadOnly=1"	//modified by czf ����ţ�330695
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