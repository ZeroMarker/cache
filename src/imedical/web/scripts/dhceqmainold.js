var ObjMenuTabs=['Buss','Warning','Monitor']
var	ObjTabsInfo=new Array();

///11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 
///61：工程管理 62：科研课题  
///63：证件：63-1：供应商,63-2：生产厂家,63-3：计量证书 64：租赁 
///71：是保养；72：检查，73：保修;81：监控
///91：采购申请 92：采购计划 93：采购招标 94：采购合同
///A01:配件入库 A02:配件转移 A03:配件退货 A04:配件减少
///用busscode做数组的索引
function EditTabsInfo(title,busscode)
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
			formatterApprove=ApproveFlowDetail
		  	break;
		case '21':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case '22':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case '23':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case '31':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case '34':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
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
		case '64':
			formatter=""
			formatterApprove=""
			queryParams={
			    	ClassName:"web.DHCEQMessages",
		        	QueryName:"GetRentData",
					Arg1:busscode,
			        ArgCnt:1
			    	};
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
			formatterApprove=ApproveFlowDetail
		  	break;
		case '92':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case '93':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case '94':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		// add by zx 2016-03-04 Bug ZX0035 配件工作台显示
		case 'A01':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
	    case 'A02':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case 'A03':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		case 'A04':
			formatter=detailOperation
			formatterApprove=ApproveFlowDetail
		  	break;
		default:
			formatter=""
			formatterApprove=""
		  	break;
	}
	this.queryParams=queryParams; //根据不同的业务定义不同的query
	this.columns=GetCurColumnsInfo('0','0',busscode,formatter,formatterApprove); ///动态成一个columns信息
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
function ApproveFlowDetail(value,row,index)
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
	var para="RowID="+row.bussID+"&TEquipDR="+row.equipID+"&BussType="+BussType+"&ReadOnly="+$('#ReadOnly').val()
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanNew&"+para;
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}
function ReloadData()
{
	//左边menu的刷新
	var currentMenuTab = $("#Menu").tabs('getSelected');
	var Index = $('#Menu').tabs('getTabIndex', currentMenuTab);
	$('#'+ObjMenuTabs[Index]).datagrid('reload');
	//左边data的刷新
	var currentdataTab = $("#Data").tabs('getSelected');
	var Index = $('#Data').tabs('getTabIndex', currentdataTab);
	if (ObjTabsInfo[Index]) $('#'+ObjTabsInfo[Index].tableID).datagrid('reload');
}
$(document).ready(function () {
//    setInterval(showMessage, 5000);
//	function showMessage()
//	{
//	    $.ajax({
//	            url :"dhceq.jquery.method.csp",
//	            type:"POST",
//	            data:{
//	                ClassName:"web.DHCEQMessages",
//	                MethodName:"GetMsgInfo",
//			        Arg1:$('#GroupID').val(),
//			        ArgCnt:1
//	            },
//	           	error:function(XMLHttpRequest, textStatus, errorThrown){
//	                        messageShow("","","",XMLHttpRequest.status);
//	                        messageShow("","","",XMLHttpRequest.readyState);
//	                        messageShow("","","",textStatus);
//	            },
//	            success:function (data, response, status) {
//	            $.messager.progress('close');
//	            if (data!=0) {
//		            $.messager.show({
//		                title:'<font size="1" color="red">消息</font>',
//		                //msg:'<a href='+window.location+'><font size="1" color="red">'+data+'</font></a>',
//		                msg:'<A onclick="ReloadData(&quot;&quot;)" href="#"><font size="1" color="red">有待处理业务:'+data+'</font></A>',
//		                autoClose:false
//		            });
//	            }
//	            else {
//	               //$.messager.alert('保存失败！',data, 'warning')
//	               //return;
//	            }
//	           }
//	        })
//	}
	$('#Menu').tabs({
		onSelect:function(title,index){
			findBussData(index)
		}
	});
	
	var currentMenuTab = $("#Menu").tabs('getSelected');
	var menuIndex = $('#Menu').tabs('getTabIndex', currentMenuTab);
	findBussData(menuIndex)
	
	$('#Data').tabs({
		onSelect:function(title,index){
			if (ObjTabsInfo[index])
			{
				tableID=ObjTabsInfo[index].tableID
				$('#'+tableID).datagrid('reload');
			}
		},
		onClose:function(title,index){
			//删除当前节点之后,其他元素的索引重新排序,这样才和界面增加的tab一致.
			ObjTabsInfo.splice(index,1)
		}
	});
	
	
	function findBussData(menuIndex)
	{
		var TabID=ObjMenuTabs[menuIndex]
		$('#'+TabID).datagrid({
		    url:'dhceq.jquery.csp', 
		    queryParams:{
		        ClassName:"web.DHCEQCRoleBuss",
		        QueryName:"GetBussByRole",
					Arg1:TabID,
			        ArgCnt:1
		    },
		    border:'true',
		    singleSelect:true,
		    columns:[[
		    		{field:'busstypedr',title:'业务ID',width:0,align:'center',hidden:true},
			        {field:'busscode',title:'代码',width:50,align:'center'},
			    	{field:'busstype',title:'名称',width:100,align:'center'},
			        {field:'waitnum',title:'数量',width:50,align:'center'}
		    ]],
		    onClickRow : function (rowIndex, rowData) {
		        var selected=$('#'+TabID).datagrid('getSelected');
		        addTab(selected);
		    }
		});
	}
	function addTab(selected){
		var title=selected.busstype
		var busscode=selected.busscode
		if($("#Data").tabs('exists',title))
	    {
	        $("#Data").tabs('select',title);
		}
		else
		{
			if (!$("#Data").tabs('exists',"工作台"))
			{
		       $("#Data").tabs('add',{
		    		closable:true,
		    		selected:true
		       });
			}
	    }
	    var currentTabPanel = $("#Data").tabs('getSelected');
		var index = $('#Data').tabs('getTabIndex', currentTabPanel);
	    $('#Data').tabs('update',{
		    tab:currentTabPanel,
			options:{title:title,
					iconCls:'icon-tip'
					}
		});
		if (ObjTabsInfo[index])
		{
			var tableID=ObjTabsInfo[index].tableID
			$('#'+tableID).datagrid('reload');
		}
		else
		{
			ObjTabsInfo[index]=new EditTabsInfo(title,busscode);
		    var tableID=ObjTabsInfo[index].tableID
		    var Columns=ObjTabsInfo[index].columns
		    var QueryParams=ObjTabsInfo[index].queryParams
		    var Toolbar=ObjTabsInfo[index].toolbar
		    //动态生成tabs数据
			var dynamicTable = $('<table id="'+tableID+'"></table>');
		    //这里一定要先添加到currentTabPanel中,因为dynamicTable.datagrid()函数需要调用到parent函数
			currentTabPanel.html(dynamicTable);
		    dynamicTable.datagrid({
				    url:'dhceq.jquery.csp', 
				    queryParams:QueryParams,
				    border:'true',
				    singleSelect:true,
				    columns:Columns,
				    toolbar:Toolbar,
				    pagination:true,
				    pageSize:15,
				    pageNumber:1,
				    pageList:[15,30,45,60,75]  
		        });
//		    dynamicTable.datagrid({    
//    			rowStyler:function(index,row){    
//				        if (row.warningFlag=="2"){    
//				            return 'background-color:pink;color:blue;font-weight:bold;';    
//				        }    
//				    }    
//				}); 
		}
	}
});
function initStatusData()
{
	if (jQuery("#Status").prop("type")!="hidden")
	{
		
		jQuery("#Status").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '0',
				text: '在库'
			},{
				id: '1',
				text: '启用'
			},{
				id: '2',
				text: '停用'
			}],
			onSelect: function() {GlobalObj.StatusDR=jQuery("#Status").combobox("getValue");}
		});
	}
}
