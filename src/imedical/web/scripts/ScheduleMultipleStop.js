var DateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
var PageLogicObj={
	m_deptRowId:"",
	m_DocRowId:"",
	m_TimeRangeRowId:"",
	m_ScheduleListDataGrid:"",
	m_ELeaderRowId:"",
	m_EReasonRowId:"",
	m_ERepDocRowId:"",
	m_ERepLocRowId:"",
	m_ERepLeaderRowId:"",
	m_ERepSessionTypeRowId:"",
	m_ERepReasonRowId:""
}
function InitHospList()
{
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_deptRowId="";
		PageLogicObj.m_DocRowId=""; 
		PageLogicObj.m_TimeRangeRowId=""; 
		$("#Combo_Loc,#Combo_Doc,#Combo_TimeRange").lookup('setText',''); 
		InitCombo();
		var StartDate=$("#StartDate").datebox("getValue"); 	
		var EndDate=$("#EndDate").datebox("getValue");
		if ((StartDate!="")&&(EndDate!="")){
			LoadScheduleList();
		}else{
			PageLogicObj.m_ScheduleListDataGrid.datagrid('loadData', { total: 0, rows: [] }); 
		}
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitCombo();
	}
}
$(function(){ 
  //InitCombo();
  InitHospList();
  PageLogicObj.m_ScheduleListDataGrid=InitTabScheduleList();
  $("#BFind").click(LoadScheduleList)
  InitStopWin();
  //替诊页面
  InitReplaceWin();
  $(document.body).bind("keydown",BodykeydownHandler)
});
function LoadScheduleList(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var StartDate=$("#StartDate").datebox("getValue"); 	
	var EndDate=$("#EndDate").datebox("getValue");	
    if (StartDate=="") {
	    $.messager.alert("提示", "请选择开始日期!");
	    return false;
	}
	if (EndDate==""){
		$.messager.alert("提示", "请选择结束日期!");
	    return false;
    }	
    if ($("#Combo_Loc").lookup('getText')=="") PageLogicObj.m_deptRowId="";
    if ($("#Combo_Doc").lookup('getText')=="") PageLogicObj.m_DocRowId="";
    if ($("#Combo_TimeRange").lookup('getText')=="") PageLogicObj.m_TimeRangeRowId="";
    var SelectStop=$("#SelectStop").checkbox('getValue')?"Y":"N";
    var Type=1
    if (SelectStop=="Y"){Type=0}
    var WeekArry=$('#Combo_Week').combo('getValues');
   	var WeekStr=WeekArry.join(",")
    $.q({
	    ClassName : "web.DHCApptScheduleNew",
	    QueryName : "GetApptSchedule",
	    Loc:PageLogicObj.m_deptRowId,
	    Doc:PageLogicObj.m_DocRowId, StDate:StartDate, EnDate:EndDate,
	    userid:session['LOGON.USERID'], groupid:session['LOGON.GROUPID'],
	    ResID:"", ExaID:"", paraTimeRange:PageLogicObj.m_TimeRangeRowId, Type:Type,SelectStop:SelectStop,
	    WeekStr:WeekStr,HospId:HospID,
	    Pagerows:PageLogicObj.m_ScheduleListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ScheduleListDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	}); 
}
function InitTabScheduleList()
{
	var ScheduleListToolBar = [{
            text: '停诊',
            iconCls: 'icon-stop-order',
            handler: function() {
	            StopAppSchedule();
            }
        },'-',{
	        text: '替诊',
            iconCls: 'icon-replace-order',
            handler: function() {
	            ReplaceSchedule();
            }
	    },'-',{
		    text: '撤销停诊',
            iconCls: 'icon-cancel-order',
            handler: function() {
	            CancelScheduleStop();
            }
		},'-',{
		    text: '导出',
            iconCls: 'icon-export',
            handler: function() {
	           ExportSchedule();
            }
		}];
	var ScheduleListColumns=[[   
	        {field:'check',title:'',width:120,align:'center',checkbox:true},
	        {field:'ASStatus',title:'状态',width:50,align:'left',sortable:true
			},
			{field:'ASDate',title:'出诊日期',width:100,align:'left',sortable:true
			},
			{field:'ASRowId',title:'ASRowId',width:10,hidden:true},
			{field:'LocDesc',title:'出诊科室',width:150,align:'left',sortable:true},
			{field:'DocDesc',title:'出诊医生',width:100,align:'left',sortable:true
            },
            {field:'ASRoom',title:'诊室名称',width:120,align:'left',sortable:true},
			{field:'ASSessionType',title:'职称',width:100,align:'left',sortable:true},
			{field:'TimeRange',title:'时段',width:60,align:'left',sortable:true},
			{field:'ASSessStartTime',title:'开始时间',width:80,align:'left'},
			{field:'ASSessionEndTime',title:'结束时间',width:80,align:'left'},
			{field:'ASLoad',title:'挂号限额',width:80,align:'left'},
			{field:'ASAppLoad',title:'预约限额',width:80,align:'left'},
			{field:'AppStartSeqNo',title:'预约起始号',width:100,align:'left'},
			{field:'ASAddLoad',title:'加号限额',width:80,align:'left'},
			{field:'ASQueueNoCount',title:'合计限额',width:100,align:'left'},
			{field:'RegisterNum',title:'已挂号数',width:100,align:'left'},
			{field:'AppedNum',title:'已预约数',width:100,align:'left'
			},
			{field:'AppedArriveNum',title:'已取号数',width:100,align:'left'},
			{field:'QueueNO',title:'剩号',width:80,align:'left'},
			
			//{field:'ASReason',title:'停替诊原因',width:80,align:'left'},
			{field:'IrregularFlag',title:'异常',width:50,align:'left'}
    	]];
	ScheduleListDataGrid=$('#tabScheduleList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ASRowId',
		columns :ScheduleListColumns,
		toolbar :ScheduleListToolBar,
		rowStyler: function(index,row){
			if (row.ASStatus=="停诊"){
				return 'color:red;';
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	ScheduleListDataGrid.datagrid('loadData', { total: 0, rows: [] });  
	return ScheduleListDataGrid;
}
function InitCombo(){
	InitLoc();
	InitDoc();
	InitTimeRange();
	InitCombWeek();
}
function InitLoc(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$("#Combo_Loc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'LocDesc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'LocDesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'FindLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q']; 
			param = $.extend(param,{Desc:desc,userid:session['LOGON.USERID'], groupid:session['LOGON.USERID'], ExamRowId:"",HospitalDr:HospID});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				PageLogicObj.m_deptRowId=rec["RowId"];
				PageLogicObj.m_DocRowId="";  
				$("#Combo_Doc").lookup('setText','');
			});
		}
    });
}
function InitDoc(){
	$("#Combo_Doc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'FinNoRegDoc'},
        onBeforeLoad:function(param){
	        var desc=param['q']; 
	        if ($("#Combo_Loc").lookup('getText')=="") {
		        PageLogicObj.m_deptRowId="";
		        PageLogicObj.m_DocRowId="";
		    	$("#Combo_Doc").lookup('setText','');
		    }
	        if ($("#Combo_TimeRange").lookup('getText')=="") PageLogicObj.m_TimeRangeRowId="";
			param = $.extend(param,{AdmDate:"", loc:PageLogicObj.m_deptRowId, TimeRangeRowId:PageLogicObj.m_TimeRangeRowId, desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				PageLogicObj.m_DocRowId=rec["RowId"];
			});
		}
    });
}
function InitTimeRange(){
	$("#Combo_TimeRange").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'时段',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'LookUpTimeRange'},
        onBeforeLoad:function(param){
	        var desc=param['q']; 
	        if ($("#Combo_Loc").lookup('getText')=="") PageLogicObj.m_deptRowId="";
			param = $.extend(param,{date:CurrDate.split("^")[0],HospId:$HUI.combogrid('#_HospUserList').getValue()});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				PageLogicObj.m_TimeRangeRowId=rec["RowId"];
			});
		}
    });
}
function InitComboData(ComboGridID,queryParams)
{
	var jQueryComboGridObj = $(ComboGridID);
	var opts = jQueryComboGridObj.combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	opts.queryParams = queryParams;
	jQueryComboGridObj.combogrid("grid").datagrid("reload");
}
function StopAppSchedule(){
	$("#StopASRowIDStr").val("");
	var rows=PageLogicObj.m_ScheduleListDataGrid.datagrid("getSelections")
	var idStr="";
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus;
		if((status=="停诊")||(status=="被替诊")||(status=="待审核")) {
			$.messager.alert("提示","已停诊或被替诊或未审核的排班记录不能停诊,请重新选择!")
			return false;
		}
		var AppedCount=$.cm({
		    ClassName : "web.DHCRBApptSchedule",
		    MethodName : "GetAppedSeqNoCount",
		    dataType:"text",
		    RBASId:rows[i].ASRowId
		},false);
	    if(AppedCount>=1){
		    if (!(confirm(rows[i].LocDesc+" "+rows[i].DocDesc+" "+rows[i].TimeRange+"的排班信息已存在预约记录,是否确认停诊?"))) return false;
		}
		if(idStr==""){
			idStr=rows[i].ASRowId
		}else{
			idStr=idStr+"^"+rows[i].ASRowId
		}
	}
	if(idStr==""){
		$.messager.alert("提示","请选择要停诊的排班记录")
		return false;
	}
	$("#StopASRowIDStr").val(idStr);
	PageLogicObj.m_ELeaderRowId=session['LOGON.USERID'];
	PageLogicObj.m_EReasonRowId="";
	$("#EReason").lookup('setText','');
	$("#ELeader").lookup('setText',session['LOGON.USERNAME']);
	$("#EPassword").val('');
	$("#EPassword").prop("disabled",true); 
	$("#EReason").focus();
	$("#StopWin").window("open");
}
function ReplaceSchedule(){
	$("#ReplaceASRowIDStr").val("");
	var rows=PageLogicObj.m_ScheduleListDataGrid.datagrid("getSelections")
	var idStr="";
	for(var i=0;i<rows.length;i++){
		var Status=rows[0].ASStatus;
		if (Status=="停诊"){
			 $.messager.alert("提示","已经停诊的记录不能替诊!");
			 return false;
		}else if (Status=="被替诊"){
			$.messager.alert("提示","已经替诊的记录不能替诊!");
			return false;
		}else if (Status=="待审核"){
		  	$.messager.alert("提示","未审核的记录不能替诊!");
		 	return false;
		}
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	}
	if(idStr==""){
		$.messager.alert("提示","请选择要替诊的排班记录!");
		return false;
	}
	if(idStr.split("^").length>1){
		 $.messager.alert("提示","请选择单个排班进行替诊操作!");
		 return false;
	}
	$("#ReplaceASRowIDStr").val(idStr);
	ClearReplaceData();
	if (idStr.split("^").length==1){
		 var RBResInfo=tkMakeServerCall("web.DHCApptScheduleNew","GetApptScheduleInfo",idStr);
		 PageLogicObj.m_ERepLocRowId=RBResInfo.split("^")[2];
		 $("#ERepLoc").lookup("setText", rows[0].LocDesc);
	}
	PageLogicObj.m_ERepLeaderRowId=session['LOGON.USERID'];
	$("#ERepLeader").lookup("setText", session['LOGON.USERNAME']);
	$("#ERepDoc").focus();
	$("#td-ERepPassword").val('');
	$("#td-ERepPassword").prop("disabled",true);  
	$("#ReplaceWin").window("open")
}
function ReplaceCancel(){
	 $('#ReplaceWin').window('close', true); 
}
//替诊
 function ReplaceSave(){
	 if ($("#ERepLoc").lookup("getText")==""){
		 PageLogicObj.m_ERepLocRowId="";
	 }
	 if(PageLogicObj.m_ERepLocRowId==""){
		 $.messager.alert("提示","请选择替诊科室!")
		 return false;
	 }
	 if ($("#ERepDoc").lookup("getText")==""){
		 PageLogicObj.m_ERepDocRowId="";
	 }
	 if(PageLogicObj.m_ERepDocRowId==""){
		  $.messager.alert("提示","请选择替诊医生!")
		 return false;
	 }
	 if ($("#ERepSessionType").lookup("getText")==""){
		 PageLogicObj.m_ERepSessionTypeRowId="";
	 }
	 if(PageLogicObj.m_ERepSessionTypeRowId==""){
		  $.messager.alert("提示","请选择替诊职称!")
		 return false;
	 }
	 if ($("#ERepReason").lookup("getText")==""){
		 PageLogicObj.m_ERepReasonRowId="";
	 }
	 if(PageLogicObj.m_ERepReasonRowId==""){
		 $.messager.alert("提示","请选择替诊原因!")
		 return false;
	 }
	 if ($("#ERepLeader").lookup("getText")==""){
		 PageLogicObj.m_ERepLeaderRowId="";
	 }
	 if (PageLogicObj.m_ERepLeaderRowId==""){
		$.messager.alert("提示","请选择批准人","info",function(){
			$("#ERepLeader").focus();
		})
		return false;
	}
	 if ((PageLogicObj.m_ERepLeaderRowId!="")&&(PageLogicObj.m_ERepLeaderRowId!=session['LOGON.USERID'])){
		 var UserName=$("#ERepLeader").lookup("getText");	
		 var ERepPassword=$("#td-ERepPassword").val();
		 if(ERepPassword==""){
			$.messager.alert("提示","请输入批准人【"+UserName+"】的登陆密码!","info",function(){
				$("#EPassword").focus();
			});
			return false;
		}
		var err=tkMakeServerCall('web.DHCOEOrdItem','PinLogNumberValid',PageLogicObj.m_ERepLeaderRowId,ERepPassword);
		if (err==-1){
			$.messager.alert("提示","该用户不存在!")
			return false;
		}else if(err==-4){
			$.messager.alert("提示","密码错误!")
			return false;
		}
	 }
	 var ASRowidStr=$("#ReplaceASRowIDStr").val();
	 for (var i=0;i<ASRowidStr.split("^").length;i++){
		 /*var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowidStr.split("^")[i])
		 if (ret<0){
			$.messager.alert('错误', "操作号源已超过号源可用时间! ");
			return false;
		 }*/
		 var IsAudit=0;
		 var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","R",ASRowidStr.split("^")[i],session['LOGON.GROUPID']);
		 var RequestRetArr=RequestRet.split("^");
		 var RequestFlag=RequestRetArr[0];
		 if(RequestFlag=="0")IsAudit="1";
		 var ret1=$.cm({
		    ClassName : "web.DHCRBApptSchedule",
		    MethodName : "ReplaceOneSchedule",
		    dataType:"text",
		    ScheduleID:ASRowidStr.split("^")[i],
		    ReplaceDoctorID:PageLogicObj.m_ERepDocRowId,
		    ReplaceLocationID:PageLogicObj.m_ERepLocRowId,
		    ReplaceReasonID:PageLogicObj.m_ERepReasonRowId,
		    AuditUserID:PageLogicObj.m_ERepLeaderRowId,
		    ReplaceSessionTypeID:PageLogicObj.m_ERepSessionTypeRowId, IsAudit:IsAudit
		},false);
		 var temparr=ret1.split("^");
		 var ret=temparr[0];
		 if (ret==0){
		 }else{
			switch(parseInt(ret))
			{
			case 300:
				$.messager.alert('错误', '医生没有安排资源!');
		 		break;
			case 200:	
				$.messager.alert('错误', '医生已经有排班记录!');
				break;
			case 100:
		  		$.messager.alert('错误', '替诊失败!');
				break;
			case 101:
				$.messager.alert('错误', '复制被替诊医生的预约限额记录失败');		
		  		break;
			default:
				$.messager.alert('错误', ret);
				break;	
	 		}
	 		return false;
		 }
     }
     var msg="替诊成功!"
     if(RequestFlag==1){
		var msg="替诊申请成功!请等待相关人员审核后生效.";
	 }
	 $.messager.alert('提示', msg,"info",function(){
		 ReplaceCancel();
 	 	 LoadScheduleList();
	 });
	 return true;
 }
function ClearReplaceData(){
	PageLogicObj.m_ERepLocRowId="";
	PageLogicObj.m_ERepDocRowId="";
	PageLogicObj.m_ERepSessionTypeRowId="";
	PageLogicObj.m_ERepReasonRowId="";
    $("#ERepLoc,#ERepDoc,#ERepSessionType,#ERepReason").lookup("setText", '');
    $("#ERepPassword").val('');
 }
 //停诊
 function StopSave(){	  
	 if ($("#ELeader").lookup('getText')==""){
		 PageLogicObj.m_ELeaderRowId="";
	 }
	 if (PageLogicObj.m_ELeaderRowId==""){
		$.messager.alert("提示","请选择批准人","info",function(){
			$("#ELeader").focus();
		})
		return false;
	}
	if ((PageLogicObj.m_ELeaderRowId!="")&&(PageLogicObj.m_ELeaderRowId!=session['LOGON.USERID'])){
		var UserName=$("#ELeader").lookup("getText");	
		var EPassword=$("#EPassword").val();
		if(EPassword==""){
			$.messager.alert("提示","请输入批准人【"+UserName+"】的登陆密码!","info",function(){
				$("#EPassword").focus();
			});
			return false;
		}
		var err=$.cm({
		    ClassName : "web.DHCOEOrdItem",
		    MethodName : "PinLogNumberValid",
		    dataType:"text",
		    UserID:PageLogicObj.m_ELeaderRowId, PinNumber:EPassword
		},false);
		if (err==-1){
			$.messager.alert("提示","该用户不存在!")
			return false;
		}else if(err==-4){
			$.messager.alert("提示","密码错误!")
			return false;
		}
	}
	if ($("#EReason").lookup('getText')=="") PageLogicObj.m_EReasonRowId="";
	if (PageLogicObj.m_EReasonRowId==""){
		$.messager.alert('提示', '停诊原因不能为空!');
		return false;
	}	
	var RequestLocDesc=""
	var NotRequestLocDesc=""
	var ASRowidStr=$("#StopASRowIDStr").val();
	for (var i=0;i<ASRowidStr.split("^").length;i++){
		/*var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowidStr.split("^")[i]);
		if (ret<0){ //<0过时了 >0中途停诊 
		  $.messager.alert('提示',t["ApptScheduleIsLater"]);
		  return false;
	    }*/
	    var StatusCode="S",IsAudit=0;
		/*if (ret==1) StatusCode="PS";
		var IsAudit="0";
		if (ret==2) IsAudit="1";*/
		var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","S",ASRowidStr.split("^")[i],session['LOGON.GROUPID']);
		var RequestRetArr=RequestRet.split("^");
		var RequestFlag=RequestRetArr[0];
		if(RequestFlag==0)IsAudit="1";
		var ret=$.cm({
		    ClassName : "web.DHCRBApptSchedule",
		    MethodName : "StopOneSchedule",
		    dataType:"text",
		    ScheduleID:ASRowidStr.split("^")[i], StopReasonID:PageLogicObj.m_EReasonRowId, 
		    AuditUserID:PageLogicObj.m_ELeaderRowId, StatusCode:StatusCode, IsAudit:IsAudit
		},false);
		if (ret!= 0) {
			$.messager.alert('错误', '停诊失败!'+ret);
			return false;
		}else{
			if(RequestFlag==0){
				if(NotRequestLocDesc==""){NotRequestLocDesc=RequestRetArr[1];}
				else{NotRequestLocDesc=NotRequestLocDesc+","+RequestRetArr[1];}	
			}else{
				if(RequestLocDesc==""){RequestLocDesc=RequestRetArr[1];}
				else{RequestLocDesc=RequestLocDesc+","+RequestRetArr[1];}	
			}	
		}
	}
	var msg="停诊成功!";
	if(NotRequestLocDesc!=""){msg=NotRequestLocDesc+"停诊成功!"};
	if(RequestLocDesc!=""){
		if(msg!=""){msg=msg+";"+RequestLocDesc+"停诊申请成功!请等待相关人员审核后生效."}
		else{msg=RequestLocDesc+"停诊申请成功!请等待相关人员审核后生效."}	
	}
	$.messager.alert('提示', msg,"info",function(){
		StopCancel();
		LoadScheduleList();
		return true;
	});
 } 
 function StopCancel(){
	 $('#StopWin').window('close', true); 
 }

function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	}
	
}
function InitStopWin(){
	//批准原因
	$("#EReason").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'批准原因',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'LookUpReasonNotAvail'}, 
        onBeforeLoad:function(param){
	        var desc=param['q']; 
			param = $.extend(param,{date:CurrDate.split("^")[0]});
	    },
	    onSelect:function(index, rec){
			PageLogicObj.m_EReasonRowId=rec["RowId"];
		}
    });
	//审批人
	$("#ELeader").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'批准人',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:300,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'LookUpELeaderNew'}, 
        onBeforeLoad:function(param){
	        var HospID=$HUI.combogrid('#_HospUserList').getValue();
	        var desc=param['q']; 
			param = $.extend(param,{loc:'',desc:desc,HospID:HospID});
	    },
	    onSelect:function(index, rec){
		    $("#EPassword").val();
		    PageLogicObj.m_ELeaderRowId=rec["RowId"];
			 //如果审批人非当前登陆用户,则显示密码
		    if (rec['RowId']!=session['LOGON.USERID']){
			    $("#EPassword").prop("disabled",false);  
			    $("#EPassword").focus();
			}else{
				$("#EPassword").val('');
				$("#EPassword").prop("disabled",true);  
			}
		}
    });
	$("#StopSave").on("click", StopSave)
	$("#StopCancel").on("click", StopCancel)
 }
 function InitReplaceWin(){
	 var HospID=$HUI.combogrid('#_HospUserList').getValue();
	 $("#ERepDoc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'替诊医生',width:250}
        ]], 
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'FinNoRegDoc'}, 
        onBeforeLoad:function(param){
	        var desc=param['q']; 
	        if ($("#ERepLoc").lookup('getText')=="") PageLogicObj.m_ERepLocRowId="";
			if (PageLogicObj.m_ERepLocRowId=="") return;
			var ReplaceASRowID=$("#ReplaceASRowIDStr").val();
			if (ReplaceASRowID.split("^").length==1){
				var ReplaceASRowIDInfo=tkMakeServerCall("web.DHCApptScheduleNew","GetApptScheduleInfo",ReplaceASRowID);
			    var TimeRange=ReplaceASRowIDInfo.split("^")[0]; 
			    var AdmDate=ReplaceASRowIDInfo.split("^")[1];
			}else{
				var AdmDate=CurrDate.split("^")[0];
				var TimeRange="";
			}
			param = $.extend(param,{AdmDate:AdmDate, loc:PageLogicObj.m_ERepLocRowId, TimeRangeRowId:TimeRange, desc:desc});
	    },
	    onSelect:function(index, rec){
			PageLogicObj.m_ERepDocRowId=rec["RowId"];
			if ($("#ERepLoc").lookup('getText')=="")PageLogicObj.m_ERepLocRowId="";
			if (PageLogicObj.m_ERepLocRowId=="") return;
			var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",rec.RowId,PageLogicObj.m_ERepLocRowId);
			if(sessTypeDr != ""){
				PageLogicObj.m_ERepSessionTypeRowId=sessTypeDr.toString();
				var sessTypeDesc = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeDescById",sessTypeDr);
				$("#ERepSessionType").lookup('setText',sessTypeDesc);
			}
		}
    });
    $("#ERepLoc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'LocDesc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'LocDesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'FindLoc'}, 
        onBeforeLoad:function(param){
	        var desc=param['q']; 
	        var HospID=$HUI.combogrid('#_HospUserList').getValue();
			param = $.extend(param,{Desc:desc, userid:session['LOGON.USERID'], groupid:session['LOGON.GROUPID'], ExamRowId:"",HospitalDr:HospID});
	    },
	    onSelect:function(index, rec){
			PageLogicObj.m_ERepLocRowId=rec["RowId"];
			$("#ERepDoc,#ERepSessionType").lookup('setText','');
			PageLogicObj.m_ERepDocRowId="";
			PageLogicObj.m_ERepSessionTypeRowId
		}
    });
	$("#ERepSessionType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'ID',title:'',hidden:true},
			{field:'Desc',title:'替诊职称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCBL.BaseReg.BaseDataQuery',QueryName: 'RBCSessionTypeQuery'}, 
        onBeforeLoad:function(param){
	        var desc=param['q']; 
	        var HospID=$HUI.combogrid('#_HospUserList').getValue();
			param = $.extend(param,{HospID:HospID});
	    },
	    onSelect:function(index, rec){
			PageLogicObj.m_ERepSessionTypeRowId=rec["ID"];
		}
    });
    $("#ERepReason").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'批准原因',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'LookUpReasonNotAvail'}, 
        onBeforeLoad:function(param){
	        var desc=param['q']; 
			param = $.extend(param,{date:CurrDate.split("^")[0]});
	    },
	    onSelect:function(index, rec){
			PageLogicObj.m_ERepReasonRowId=rec["RowId"];
		}
    });
    $("#ERepLeader").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'批准人',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:300,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCApptScheduleNew',QueryName: 'LookUpELeaderNew'}, 
        onBeforeLoad:function(param){
	        var HospID=$HUI.combogrid('#_HospUserList').getValue();
	        var desc=param['q']; 
			param = $.extend(param,{loc:'',desc:desc,HospID:HospID});
	    },
	    onSelect:function(index, rec){
			PageLogicObj.m_ERepLeaderRowId=rec["RowId"];
			$("#td-ERepPassword").val('');
		    if (rec['RowId']!=session['LOGON.USERID']){
			    $("#td-ERepPassword").prop("disabled",false);  
			    $("#td-ERepPassword").focus();
			}else{
				$("#td-ERepPassword").prop("disabled",true);  
			}
		}
    });
    $("#ReplaceSave").on("click", ReplaceSave)
	$("#ReplaceCancel").on("click", ReplaceCancel)
 }
function myparser(s){
	if (!s) return new Date();
	if (DateFormat==3){
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}else if(DateFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}
}
function BodykeydownHandler(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}
///批量撤销停诊
function CancelScheduleStop()
{
	var Error=""
	var rows=ScheduleListDataGrid.datagrid("getSelections")
	var idStr=""
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus
		if(status.indexOf("停诊")<0) {
			$.messager.alert("提示","非停诊状态的排班记录不能进行撤销停诊操作!")
			return false;
		}
		//进行撤销停诊操作
		var rtn=tkMakeServerCall("web.DHCRBApptSchedule","CancelStopOneSchedule",rows[i].ASRowId)
		if(rtn!=0){
			var rtnArr=rtn.split("^")
			if(rtnArr[0]=='-201'){
				dhcsys_alert("不能撤销停诊,"+rtnArr[1]+"存在相同时段的排班!");
				Error="Y";
				continue;
			}else{
				dhcsys_alert("撤销停诊失败!");
				Error="Y";
				continue;
			}
		}
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	}
	if (Error=="Y"){
		$.messager.alert("提示","存在撤销失败的记录,请注意核对操作数据!")	
		LoadScheduleList();
		return false
	}
	
	if(idStr==""){
		$.messager.alert("提示","请选择要撤销停诊的排班记录!")
		return false
	}
	$.messager.popover({msg:"撤销停诊成功!",type:'info'});
	LoadScheduleList();
}

//星期
function InitCombWeek(){
	
	var JsonComb="[{'Desc':'周一','Value':'1'},{'Desc':'周二','Value':'2'},{'Desc':'周三','Value':'3'},{'Desc':'周四','Value':'4'},{'Desc':'周五','Value':'5'},{'Desc':'周六','Value':'6'},{'Desc':'周日','Value':'7'}]"
	var Json=eval("("+JsonComb+")")
	
	var cbox = $HUI.combobox("#Combo_Week", {
			valueField: 'Value',
			textField: 'Desc', 
			data: Json,
			multiple:true,
			filter: function(q, row){
				
			},
			onSelect: function (rec) {
				
			},
			onChange:function(newValue,oldValue){
				
			},
			onLoadSuccess:function(){
				
			}
	   });
	
	
}
function ExportSchedule(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var StartDate=$("#StartDate").datebox("getValue"); 	
	var EndDate=$("#EndDate").datebox("getValue");		
    if ($("#Combo_Loc").lookup('getText')=="") PageLogicObj.m_deptRowId="";
    if ($("#Combo_Doc").lookup('getText')=="") PageLogicObj.m_DocRowId="";
    if ($("#Combo_TimeRange").lookup('getText')=="") PageLogicObj.m_TimeRangeRowId="";
    var SelectStop=$("#SelectStop").checkbox('getValue')?"Y":"N";
    var Type=1
    if (SelectStop=="Y"){Type=0}
    var WeekArry=$('#Combo_Week').combo('getValues');
   	var WeekStr=WeekArry.join(",")
   	$cm({
	   	localDir:"Self",
	   	ResultSetType:"ExcelPlugin",
	   	ExcelName:"坐诊信息",
	  	ClassName : "web.DHCApptScheduleNew",
	    QueryName : "ApptScheduleExport",
	    Loc:PageLogicObj.m_deptRowId,
	    Doc:PageLogicObj.m_DocRowId, StDate:StartDate, EnDate:EndDate,
	    userid:session['LOGON.USERID'], groupid:session['LOGON.GROUPID'],
	    ResID:"", ExaID:"", paraTimeRange:PageLogicObj.m_TimeRangeRowId, Type:Type,SelectStop:SelectStop,
	    WeekStr:WeekStr,HospId:HospID,
	},false)

	}