var CureWorkListDataGrid;

$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();		
	//CureApplyDataGridLoad();
	
});
function Init(){
	//卡类型列表
    $HUI.combobox("#cardType",{
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCardType&ResultSetType=array",
	});
	//服务组列表
	$HUI.combobox("#serviceGroup",{
	    valueField:'Rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&ResultSetType=array",
	});
	
	InitCureWorkListDataGrid();
}
function InitEvent(){
	$('#btnFind').bind('click', function(){
		   CureWorkListDataGridLoad();
    });
    
    $('#btnClear').bind('click', function(){
		ClearHandle();
	});

    $('#btnReadCard').bind('click', function(){
		   ReadCard();
    });
    $('#btnReadInsuCard').bind('click', function(){
		   ReadInsuCard();
    });
    $('#patNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {
			  var patNo=$("#patNo").val();
			  if(patNo=="") return;
			  for (var i=(8-patNo.length-1); i>=0; i--) {
				patNo="0"+patNo;
			}
			$("#patNo").val(patNo);
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
			$("#PatientID").val(PatientID);
			CureWorkListDataGridLoad();
		   }
		   if ($("#patNo").val()=="")
		   {$("#PatientID").val("");}
    });
    $('#patNo').bind('change', function(event){
		   if ($("#patNo").val()=="")
		   {$("#PatientID").val("");}
    });
     $('#cardNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {
				var cardType=$("#cardType").combobox('getValue');
				if (cardType=="") return;
				var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
				if (cardTypeInfo=="") return;
				var cardNoLength=cardTypeInfo.split("^")[16];
				//alert(cardNoLength);
				var cardNo=$("#cardNo").val();
				if(cardNo=="") return;
				if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
				$("#cardNo").val(cardNo);
				var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo)
				$("#PatientID").val(PatientID);
				CureWorkListDataGridLoad();
			}
			if ($("#patNo").val()=="")$("#PatientID").val("");
    });
    $('#cardNo').bind('change', function(event){
		   if ($("#cardNo").val()=="")
		   {$("#PatientID").val("");}
    });
   
};

function PageHandle(){
	
}

function ClearHandle(){
	$("#cardNo").val("");
	$("#patNo").val("");
	$("#PatientID").val("");
	$("#sttDate").datebox("setValue","");	
	$("#endDate").datebox("setValue","");	
	$("#serviceGroup").combobox("setValue","");	
	$("#queryStatus").combobox("setValue","");	
}

function InitCureWorkListDataGrid(){
	var cureWorkListToolBar = [/*{
			id:'BtnCall',
			text:'叫号',
			iconCls:'icon-add',
			handler:function(){
				FormMatterPatName();		 
			}
		},'-',*/];
	// 治疗工作台查询Grid
	CureWorkListDataGrid=$('#tabCureWorkList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		//singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize : 5,
		pageList : [5,15,50,100],
		columns :[[   
					{field:'RowCheck',checkbox:true},     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					
					{field:'PatNo',title:'登记号',width:100,align:'center'},   
        			{field:'PatName',title:'姓名',width:80,align:'center',
						formatter:function(value,row){							
							return '<a href="###" onclick=FormMatterPatName();>'+row.PatName+"</a>"
						},
						styler:function(value,row){
							return "color:blue;"
						}
					},   
        			{field:'PatSex',title:'性别',width:40,align:'center'},
        			{field:'PatAge',title:'年龄',width:40,align:'center'},
					{ field: 'DDCRSDate', title:'日期', width: 120, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'科室', width: 120, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 60, align: 'center', resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 60, align: 'center', resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 80, align: 'center',resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 80, align: 'center',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 60, align: 'center',resizable: true
					},
					{ field: 'DDCRSStatus', title: '排班状态', width: 60, align: 'center',resizable: true
					},
					{ field: 'DCAAStatus', title: '预约状态', width: 60, align: 'center',resizable: true
					},
					{ field: 'CallStatus', title: '呼叫状态', width: 30, align: 'center',resizable: true
					},
					{ field: 'ReqUser', title: '预约操作人', width: 60, align: 'center',resizable: true
					},
					{ field: 'ReqDate', title: '预约操作时间', width: 60, align: 'center',resizable: true
					},
					{ field: 'LastUpdateUser', title: '更新人', width: 60, align: 'center',resizable: true,hidden: true
					},
					{ field: 'LastUpdateDate', title: '更新时间', width: 60, align: 'center',resizable: true,hidden: true
					},
					{ field: 'OEOREDR', title: '执行记录ID', width: 60, align: 'center',hidden: true
					},
					{ field: 'ServiceGroupID', title: '服务组', width: 60, align: 'center',hidden: true
					}
    			 ]] ,
    	toolbar : cureWorkListToolBar,
		onClickRow:function(rowIndex, rowData){
			loadTabData()
		},
		onCheck:function(rowIndex, rowData){
			loadTabData();
		},
		onUncheck:function(rowIndex, rowData){
			//var ret=CheckSelectedRow(rowIndex, rowData);
			loadTabData();
		},
		rowStyler:function(index,row){   
	        if (row.CallStatus=="正在呼叫"){   
	            return 'background-color:green;';   
	        }   
	    }
	});
	$('#tabs').tabs({
  		onSelect: function(title,index){
				loadTabData()
  		}
	});
	CureWorkListDataGridLoad();	
}

function CureWorkListDataGridLoad()
{
	var ServiceGroup=$("#serviceGroup").combobox('getValue');
	var PatientID=$("#PatientID").val();
	var sttDate=$('#sttDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var queryStatus=$("#queryStatus").combobox('getValue');
	
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		QueryName:"FindCurrentAppointmentListHUI",
		'LocId':session['LOGON.CTLOCID'],
		'UserId':session['LOGON.USERID'],
		'StartDate':sttDate,
		'EndDate':endDate,
		'PatientID':PatientID,
		'ServiceGroupId':ServiceGroup,
		'QueryStatus':queryStatus,
		Pagerows:CureWorkListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureWorkListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function FormMatterPatName(val,row){
	//以下程序仅支持东华叫号接口
	var rows = CureWorkListDataGrid.datagrid("getSelections");
	var DCAARowId="",DCARowId="",DCAOEOREDR=""
	if (rows.length>=1)
	{
		var succsss=true;
		for(var i=0;i<rows.length;i++){
			
			var rowIndex = CureWorkListDataGrid.datagrid("getRowIndex", rows[i]);
			var selected=CureWorkListDataGrid.datagrid('getRows'); 
			var DCAARowId=selected[rowIndex].Rowid;
			DCAOEOREDR=selected[rowIndex].OEOREDR;
			var PatName=selected[rowIndex].PatName;
			var treatID=selected[rowIndex].ServiceGroupID;
			
		    var ServiceGroupDesc=selected[rowIndex].ServiceGroupDesc;
		    var StartTime=selected[rowIndex].StartTime;
			//alert(DCAARowId)
			//return;
			/*
			深圳市中医院  治疗室 叫号接口
		   	web.DHCVISVoiceCall.InsertVoiceQueue(callinfo,user,computerIP,"A","LR","N",callinfo,callinfo,"",treatID)
		   	callinfo          请 张三 进入治疗室
		   	user              userID
		   	computerIP        计算机IP
		   	treatID           治疗类型ID   
			*/
			var callinfo="请"+PatName+"进入治疗室";
			var computerIP=GetComputerIp()
			var loguser=session['LOGON.USERID'];
			var logloc=session['LOGON.CTLOCID'];
			var ret="0"; 
			//alert(callinfo+";"+loguser+";"+computerIP+";"+callinfo+";"+logloc+";"+treatID);
			var zhContent=DCAARowId+";"+PatName+";"+ServiceGroupDesc+";"+StartTime;
			var ret=tkMakeServerCall("web.DHCVISVoiceCall","InsertVoiceQueue",callinfo,loguser,computerIP,"A","LR","N",zhContent,logloc,"",treatID)
			//alert("InsertVoiceQueue+"+ret)
			if(ret=="0"){
				var callret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","UpdateTreatCallStatus",DCAARowId,"Y")
				if(callret!=0){
					succsss=false;
					$.messager.alert("错误", "更新呼叫状态失败", 'error')
			        return false;
				}else{
					//alert("呼叫成功")
					$.messager.alert("提示", "呼叫成功")
				}
			}else{
				var errmsg="呼叫失败:"+ret
				$.messager.alert("错误", errmsg, 'error');
				succsss=false;
			    return false;
			}
		}
		if(succsss==true){
			$.messager.alert("提示", "呼叫成功")		
		}
	}else{
		$.messager.alert("错误", "请选择一位病人再呼叫.", 'error')
		 return false;
	}
}

function GetComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //连接本机服务器
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准 
   var e = new Enumerator (properties);
   var p = e.item ();

   for (;!e.atEnd();e.moveNext ())  
   {
  	var p = e.item ();  
 	//document.write("IP:" + p.IPAddress(0) + " ");//IP地址为数组类型,子网俺码及默认网关亦同
	ipAddr=p.IPAddress(0); 
	if(ipAddr) break;
	}

	return ipAddr;
}
function loadTabData()
{
	var rows = CureWorkListDataGrid.datagrid("getSelections");
	var DCARowId="";DCARowIdStr="";DCAOEOREDR="";
	if (rows.length==1)
	{
		var rowIndex = CureWorkListDataGrid.datagrid("getRowIndex", rows[0]);
		var selected=CureWorkListDataGrid.datagrid('getRows'); 
		var DCAARowId=selected[rowIndex].Rowid;
		if (DCAARowId!="")
		{
			DCARowId=DCAARowId.split("||")[0];
		}
	}
	for(var i=0;i<rows.length;i++){
		var DCAARowId=rows[i].Rowid;
		if (DCAARowId!="")
		{
			DCARowId=DCAARowId.split("||")[0];
		}
		if(DCARowIdStr==""){
			DCARowIdStr=DCARowId;
		}else{
			var cDCARowIdStr="!"+DCARowIdStr+"!";
			var cDCARowId="!"+DCARowId+"!";
			if(cDCARowIdStr.indexOf(cDCARowId)<0){
				DCARowIdStr=DCARowIdStr+"!"+DCARowId;
			}
		}
	}
	_SELECT_DCAROWID=DCARowIdStr;
	var title = $('.tabs-selected').text();
	var href=""
	if (title=="治疗记录") 
	{href="dhcdoc.cure.curerecord.csp?OperateType=ZLYS&DCAARowId="+DCAARowId;}
	else if (title=="预约列表") 
	{href="doccure.applyapplist.hui.csp?OperateType=ZLYS&DCARowId="+DCARowId+"&DCAOEOREDR="+DCAOEOREDR+"&DCARowIdStr="+DCARowIdStr+"&SingleSelect=false";}
	else if (title=="治疗记录列表") 
	{href="doccure.curerecordlist.hui.csp?OperateType=ZLYS&DCARowId="+DCARowId+"&DCAOEOREDR="+DCAOEOREDR+"&DCARowIdStr="+DCARowIdStr;}
	//alert(href);
	if(href=="")return;
	refreshTab({tabTitle:title,url:href}); 
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
	    var _refresh_ifram = refresh_tab.find('iframe')[0];  
	    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
	    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}

function ReadCardClick()
{
	var cardType=$("#cardType").combobox('getValue');
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=combo_CardType.getActualValue();
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    //alert(CardInform)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			document.getElementById('cardNo').value=""
			break;
		default:
			document.getElementById('cardNo').value=myary[1] //myary[2]
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			if(PatientID=="")
			{
				 alert("卡无效");
				 return;
			}
			$("#PatientID").val(PatientID);
			CureWorkListDataGridLoad();
			break;
	}
		
    
}
function ReadInsuCard()
{
	$("#cardType").combobox('setValue',4)
	var cardType=$("#cardType").combobox('getValue');
	var CardInform=DHCACC_ReadMagCard(cardType,"","","");
	var myary=CardInform.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			document.getElementById('cardNo').value=""
			break;
		
		default:
			document.getElementById('cardNo').value=myary[1];
			CureWorkListDataGridLoad();
			break;
	}
}