
//名称	DHCPESendReportMessage.hisui.js
//功能	报告已完成hisui
//创建	2019.10.18
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitSendReportataGrid();
	    
     //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });  
        

   $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				FindSendReportInfo();
				}
	});
	
	//发送短信	
	$("#BSendMessage").click(function() {	
		BSendMessage_click();		
        });  
	
	//
	Info();
	
})

//发送短信	
function BSendMessage_click()
{
	var selectrow = $("#SendReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据

	var ErrRows="",NullTelRows="",ErrTelRows="";
	var Content="";
	var Type="RP"
	var Content=$("#Content").val();

	if(Content==""){
		$.messager.alert("提示","短信内容不能为空！","info");
		return false;
	}

	if(selectrow.length=="0"){
		$.messager.alert("提示","请选择待发送短信的人员！","info");
		return false;
	}

	for(var i=0;i<selectrow.length;i++)
	{
		var ID=selectrow[i].TID;
		var RegNo=selectrow[i].TRegNo;
		var TTel=$.trim(selectrow[i].TTel);
		 
		
		if (TTel==""){
				NullTelRows=NullTelRows+",第"+(i+1)+"行";
				continue;
			}
		if (!isMoveTel(TTel)){
				ErrTelRows=ErrTelRows+",第"+(i+1)+"行"; 
				continue;
			}
			
			var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+Content;
			//alert(InfoStr)
			var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
			
			if (ret!=0){
				ErrRows=ErrRows+",第"+(i+1)+"行";
			}else{
				 
				/*var obj=document.getElementById("TSendMessagez"+i);
				if (obj) obj.checked=false;
				var obj=document.getElementById("THadSendMessagez"+i);
				if (obj) obj.innerText="待发送";
				*/
			}
		}
	
	if ((ErrRows!="")||(NullTelRows!="")||(ErrTelRows!="")){
		if (ErrRows!=""){$.messager.alert("提示","错误行: "+ErrRows,"info");}
		if (NullTelRows!=""){$.messager.alert("提示","电话号码为空的行: "+NullTelRows,"info");}
		if (ErrTelRows!=""){$.messager.alert("提示","电话号码错误的行: "+ErrTelRows,"info");}

	}else{
		BFind_click();
	}
	
}


///判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^1(3|4|5|8)\d{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}

function FindSendReportInfo()
{
		var iRegNo=$("#RegNo").val(); 
		if(iRegNo!="") {
	 		var iRegNo=$.m({
				"ClassName":"web.DHCPE.DHCPECommon",
				"MethodName":"RegNoMask",
            	"RegNo":iRegNo
			}, false);
		
			$("#RegNo").val(iRegNo)
		}else{
			 $.messager.alert("提示","请输入登记号","info");
			return false;
		}	
		
		var iRegNo=$("#RegNo").val();
		
		var PADMS=tkMakeServerCall("web.DHCPE.FetchReport","GetSRPIADMSByRegNo",iRegNo);
	
		
		if (PADMS.split("^")[0]!="0"){
		
			 $.messager.popover({msg: PADMS.split("^")[1], type: "info"});
			return false;
		}else{
			
		var PADM=PADMS.split("^")[1];
		if (PADM==""){
			$.messager.popover({msg: "没有要完成报告的记录", type: "info"});
			return false;
			}
		var PADMArr=PADM.split("$");
		if (PADMArr.length>2){
           
           openWin(PADM)
		}else{
			
			var ret=tkMakeServerCall("web.DHCPE.FetchReport","FetchReportHisui",PADM.split("$")[0],"C");
			var Arr=ret.split("^");
			if (Arr[0]!=0){
				$.messager.popover({msg: Arr[1], type: "info"});
				return false;
			}
			BFind_click();
			}
		}
	
}


//就诊记录弹窗
var openWin = function(PIADMs){
	
	$("#myWin").show();
	
	$HUI.window("#myWin",{
		title:"就诊记录",
		minimizable:false,
		collapsible:false,
		modal:true,
		width:1000,
		height:390
	});
	
	
	
	var PIADMSQueryTabObj = $HUI.datagrid("#PIADMSQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [], //配置项toolbar为空时,会在标题与列头产生间距"
		queryParams:{
			ClassName:"web.DHCPE.PreIADMEx",
			QueryName:"SearchPreIADM",
			
			PIADMs:PIADMs,	
		},
		frozenColumns:[[
			{field:'PIBIPAPMINo',width:100,title:'登记号'},
		]],
		columns:[[
	
		    {field:'id',title:'id',hidden: true},
		    {field:'PIADMPIBIDR',title:'PIADMPIBIDR',hidden: true}, 
			{field:'PIADMPIBIDRName',width:100,title:'姓名'},
			{field:'PIADMPGADMDRName',width:300,title:'团体名称'},
			{field:'PIADMPGTeamDRName',width:150,title:'分组名称'},
			{field:'PIADMPEDateBegin',width:100,title:'体检日期'},
			{field:'PIADMOldHPNo',width:120,title:'体检号'},
			{field:'BSendReport',title:'完成报告',width:80,align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.id!=""){
						return "<span style='cursor:pointer;' class='icon-ok' title='完成报告' onclick='SendReport("+rowData.id+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"  title="完成报告" border="0" onclick="SendReport('+rowData.id+')"></a>';
					
					}
				}},	
		]],
		onSelect: function (rowIndex, rowData) {
			
				
			
		}
		
			
	})
	
	
	
}

//完成报告
function SendReport(PIADM)
{
	var ret=tkMakeServerCall("web.DHCPE.FetchReport","FetchReportHisui",PIADM,"C");
			var Arr=ret.split("^");
			if (Arr[0]!=0){
				 $.messager.alert("提示",Arr[1],"info");
			    return false;
			
			}
			BFind_click();
	
}


function Info()
{
	var IFOLD="";
	var IFOLD=$("#IFOLD").checkbox('getValue');
	if(IFOLD){var IFOLD="Y";}
	else{var IFOLD="";}
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var VIPLevel="";}
	
	var LocID=session['LOGON.CTLOCID'];
	var MessContent=tkMakeServerCall("web.DHCPE.FetchReport","GetContent",IFOLD,VIPLevel,LocID);

	$("#Content").val(MessContent);
}


//撤销完成
function CancelSendReport(ID)
{
	if(ID==""){
		$.messager.alert("提示","请选择待撤销的人","info");
		return false;
		}
		
	$.messager.confirm("确认", "确定要撤销吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"CancelFetchReport",ID:ID,CurStatus:"C"},function(ReturnValue){
				
				var ret=ReturnValue.split("^");
				if (ret[0]!="0") {
					$.messager.alert("提示",ret[1]+",不允许撤销完成","info");
				}else{
					$.messager.alert("提示","撤销成功","success");
					BFind_click();
				}
				});
		}
	});
	
	
}
//查询
function BFind_click(){
	
	
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}	
	$("#SendReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchCmopleteReport",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			NoFetchReport:$HUI.checkbox('#NoFetchReport').getValue() ? "on" : "",
			HadSendMessage:$HUI.checkbox('#HadSendMessage').getValue() ? "on" : "",
			IFOLD:$HUI.checkbox('#IFOLD').getValue() ? "on" : "",
			})
	
}


function InitSendReportataGrid()
{
	$HUI.datagrid("#SendReportQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchCmopleteReport",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			NoFetchReport:$HUI.checkbox('#NoFetchReport').getValue() ? "on" : "",
			HadSendMessage:$HUI.checkbox('#HadSendMessage').getValue() ? "on" : "",
			IFOLD:$HUI.checkbox('#IFOLD').getValue() ? "on" : "",
		},
		frozenColumns:[[
			{title: '选择',field: 'Select',width: 60,checkbox:true},
			{field:'BCancelSendReport',title:'撤销',width:'80',align:'center',
				formatter:function(value,rowData,rowIndex){
					if((rowData.TID!="")&&(rowData.TSendUser!="")){
						return "<span style='cursor:pointer;' class='icon-cancel' title='撤销' onclick='CancelSendReport("+rowData.TID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="撤销" border="0" onclick="CancelSendReport('+rowData.TID+')"></a>';
					
					}
				}},
			{field:'TRegNo',width:100,title:'登记号'},
			{field:'TName',width:80,title:'姓名'},
		]],
		columns:[[
	
		    {field:'TID',title:'ReportID',hidden: true},
			{field:'TSex',width:45,title:'性别'},
			{field:'TBirth',width:100,title:'出生日期'},
			{field:'TSendUser',width:80,title:'完成人'},
			{field:'TSendDate',width:100,title:'完成日期'},
			{field:'TReportStatus',width:100,title:'报告状态'},
			{field:'TAppDate',width:100,title:'报告约期'},
			{field:'TTel',width:120,title:'电话'},
			{field:'THadSendMessage',width:80,title:'短信状态'},
			{field:'TMessageDate',width:100,title:'短信时间'},
			{field:'RptPrtDate',width:100,title:'打印日期'},
			{field:'TVIPLevel',width:80,title:'VIP等级'},
			{field:'TGroupName',width:200,title:'团体名称'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}

function InitCombobox()
{
	  // VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	})
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onChange:function()
		{
			
			
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100},
		
		]]
		})
		
		
	
}
