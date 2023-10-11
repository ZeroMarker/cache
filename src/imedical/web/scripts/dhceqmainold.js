var ObjMenuTabs=['Buss','Warning','Monitor']
var	ObjTabsInfo=new Array();

///11:�������� 12:��װ�������� 21:��⡢22:ת�� 23:���� 31:ά�ޡ�32������33��顢34���ϡ�35�۾ɡ�41ʹ�ü�¼��51�豸����,52 �豸 
///61�����̹��� 62�����п���  
///63��֤����63-1����Ӧ��,63-2����������,63-3������֤�� 64������ 
///71���Ǳ�����72����飬73������;81�����
///91���ɹ����� 92���ɹ��ƻ� 93���ɹ��б� 94���ɹ���ͬ
///A01:������ A02:���ת�� A03:����˻� A04:�������
///��busscode�����������
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
		// add by zx 2016-03-04 Bug ZX0035 �������̨��ʾ
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
	this.queryParams=queryParams; //���ݲ�ͬ��ҵ���岻ͬ��query
	this.columns=GetCurColumnsInfo('0','0',busscode,formatter,formatterApprove); ///��̬��һ��columns��Ϣ
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
function ApproveFlowDetail(value,row,index)
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
	var para="RowID="+row.bussID+"&TEquipDR="+row.equipID+"&BussType="+BussType+"&ReadOnly="+$('#ReadOnly').val()
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanNew&"+para;
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}
function ReloadData()
{
	//���menu��ˢ��
	var currentMenuTab = $("#Menu").tabs('getSelected');
	var Index = $('#Menu').tabs('getTabIndex', currentMenuTab);
	$('#'+ObjMenuTabs[Index]).datagrid('reload');
	//���data��ˢ��
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
//		                title:'<font size="1" color="red">��Ϣ</font>',
//		                //msg:'<a href='+window.location+'><font size="1" color="red">'+data+'</font></a>',
//		                msg:'<A onclick="ReloadData(&quot;&quot;)" href="#"><font size="1" color="red">�д�����ҵ��:'+data+'</font></A>',
//		                autoClose:false
//		            });
//	            }
//	            else {
//	               //$.messager.alert('����ʧ�ܣ�',data, 'warning')
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
			//ɾ����ǰ�ڵ�֮��,����Ԫ�ص�������������,�����źͽ������ӵ�tabһ��.
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
		    		{field:'busstypedr',title:'ҵ��ID',width:0,align:'center',hidden:true},
			        {field:'busscode',title:'����',width:50,align:'center'},
			    	{field:'busstype',title:'����',width:100,align:'center'},
			        {field:'waitnum',title:'����',width:50,align:'center'}
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
			if (!$("#Data").tabs('exists',"����̨"))
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
		    //��̬����tabs����
			var dynamicTable = $('<table id="'+tableID+'"></table>');
		    //����һ��Ҫ����ӵ�currentTabPanel��,��ΪdynamicTable.datagrid()������Ҫ���õ�parent����
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
				text: '�ڿ�'
			},{
				id: '1',
				text: '����'
			},{
				id: '2',
				text: 'ͣ��'
			}],
			onSelect: function() {GlobalObj.StatusDR=jQuery("#Status").combobox("getValue");}
		});
	}
}
