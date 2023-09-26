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
  //����ҳ��
  InitReplaceWin();
  $(document.body).bind("keydown",BodykeydownHandler)
});
function LoadScheduleList(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var StartDate=$("#StartDate").datebox("getValue"); 	
	var EndDate=$("#EndDate").datebox("getValue");	
    if (StartDate=="") {
	    $.messager.alert("��ʾ", "��ѡ��ʼ����!");
	    return false;
	}
	if (EndDate==""){
		$.messager.alert("��ʾ", "��ѡ���������!");
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
            text: 'ͣ��',
            iconCls: 'icon-stop-order',
            handler: function() {
	            StopAppSchedule();
            }
        },'-',{
	        text: '����',
            iconCls: 'icon-replace-order',
            handler: function() {
	            ReplaceSchedule();
            }
	    },'-',{
		    text: '����ͣ��',
            iconCls: 'icon-cancel-order',
            handler: function() {
	            CancelScheduleStop();
            }
		},'-',{
		    text: '����',
            iconCls: 'icon-export',
            handler: function() {
	           ExportSchedule();
            }
		}];
	var ScheduleListColumns=[[   
	        {field:'check',title:'',width:120,align:'center',checkbox:true},
	        {field:'ASStatus',title:'״̬',width:50,align:'left',sortable:true
			},
			{field:'ASDate',title:'��������',width:100,align:'left',sortable:true
			},
			{field:'ASRowId',title:'ASRowId',width:10,hidden:true},
			{field:'LocDesc',title:'�������',width:150,align:'left',sortable:true},
			{field:'DocDesc',title:'����ҽ��',width:100,align:'left',sortable:true
            },
            {field:'ASRoom',title:'��������',width:120,align:'left',sortable:true},
			{field:'ASSessionType',title:'ְ��',width:100,align:'left',sortable:true},
			{field:'TimeRange',title:'ʱ��',width:60,align:'left',sortable:true},
			{field:'ASSessStartTime',title:'��ʼʱ��',width:80,align:'left'},
			{field:'ASSessionEndTime',title:'����ʱ��',width:80,align:'left'},
			{field:'ASLoad',title:'�Һ��޶�',width:80,align:'left'},
			{field:'ASAppLoad',title:'ԤԼ�޶�',width:80,align:'left'},
			{field:'AppStartSeqNo',title:'ԤԼ��ʼ��',width:100,align:'left'},
			{field:'ASAddLoad',title:'�Ӻ��޶�',width:80,align:'left'},
			{field:'ASQueueNoCount',title:'�ϼ��޶�',width:100,align:'left'},
			{field:'RegisterNum',title:'�ѹҺ���',width:100,align:'left'},
			{field:'AppedNum',title:'��ԤԼ��',width:100,align:'left'
			},
			{field:'AppedArriveNum',title:'��ȡ����',width:100,align:'left'},
			{field:'QueueNO',title:'ʣ��',width:80,align:'left'},
			
			//{field:'ASReason',title:'ͣ����ԭ��',width:80,align:'left'},
			{field:'IrregularFlag',title:'�쳣',width:50,align:'left'}
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
			if (row.ASStatus=="ͣ��"){
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
			{field:'LocDesc',title:'��������',width:350}
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
			{field:'Desc',title:'����',width:350}
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
			{field:'Desc',title:'ʱ��',width:350}
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
		if((status=="ͣ��")||(status=="������")||(status=="�����")) {
			$.messager.alert("��ʾ","��ͣ��������δ��˵��Ű��¼����ͣ��,������ѡ��!")
			return false;
		}
		var AppedCount=$.cm({
		    ClassName : "web.DHCRBApptSchedule",
		    MethodName : "GetAppedSeqNoCount",
		    dataType:"text",
		    RBASId:rows[i].ASRowId
		},false);
	    if(AppedCount>=1){
		    if (!(confirm(rows[i].LocDesc+" "+rows[i].DocDesc+" "+rows[i].TimeRange+"���Ű���Ϣ�Ѵ���ԤԼ��¼,�Ƿ�ȷ��ͣ��?"))) return false;
		}
		if(idStr==""){
			idStr=rows[i].ASRowId
		}else{
			idStr=idStr+"^"+rows[i].ASRowId
		}
	}
	if(idStr==""){
		$.messager.alert("��ʾ","��ѡ��Ҫͣ����Ű��¼")
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
		if (Status=="ͣ��"){
			 $.messager.alert("��ʾ","�Ѿ�ͣ��ļ�¼��������!");
			 return false;
		}else if (Status=="������"){
			$.messager.alert("��ʾ","�Ѿ�����ļ�¼��������!");
			return false;
		}else if (Status=="�����"){
		  	$.messager.alert("��ʾ","δ��˵ļ�¼��������!");
		 	return false;
		}
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	}
	if(idStr==""){
		$.messager.alert("��ʾ","��ѡ��Ҫ������Ű��¼!");
		return false;
	}
	if(idStr.split("^").length>1){
		 $.messager.alert("��ʾ","��ѡ�񵥸��Ű�����������!");
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
//����
 function ReplaceSave(){
	 if ($("#ERepLoc").lookup("getText")==""){
		 PageLogicObj.m_ERepLocRowId="";
	 }
	 if(PageLogicObj.m_ERepLocRowId==""){
		 $.messager.alert("��ʾ","��ѡ���������!")
		 return false;
	 }
	 if ($("#ERepDoc").lookup("getText")==""){
		 PageLogicObj.m_ERepDocRowId="";
	 }
	 if(PageLogicObj.m_ERepDocRowId==""){
		  $.messager.alert("��ʾ","��ѡ������ҽ��!")
		 return false;
	 }
	 if ($("#ERepSessionType").lookup("getText")==""){
		 PageLogicObj.m_ERepSessionTypeRowId="";
	 }
	 if(PageLogicObj.m_ERepSessionTypeRowId==""){
		  $.messager.alert("��ʾ","��ѡ������ְ��!")
		 return false;
	 }
	 if ($("#ERepReason").lookup("getText")==""){
		 PageLogicObj.m_ERepReasonRowId="";
	 }
	 if(PageLogicObj.m_ERepReasonRowId==""){
		 $.messager.alert("��ʾ","��ѡ������ԭ��!")
		 return false;
	 }
	 if ($("#ERepLeader").lookup("getText")==""){
		 PageLogicObj.m_ERepLeaderRowId="";
	 }
	 if (PageLogicObj.m_ERepLeaderRowId==""){
		$.messager.alert("��ʾ","��ѡ����׼��","info",function(){
			$("#ERepLeader").focus();
		})
		return false;
	}
	 if ((PageLogicObj.m_ERepLeaderRowId!="")&&(PageLogicObj.m_ERepLeaderRowId!=session['LOGON.USERID'])){
		 var UserName=$("#ERepLeader").lookup("getText");	
		 var ERepPassword=$("#td-ERepPassword").val();
		 if(ERepPassword==""){
			$.messager.alert("��ʾ","��������׼�ˡ�"+UserName+"���ĵ�½����!","info",function(){
				$("#EPassword").focus();
			});
			return false;
		}
		var err=tkMakeServerCall('web.DHCOEOrdItem','PinLogNumberValid',PageLogicObj.m_ERepLeaderRowId,ERepPassword);
		if (err==-1){
			$.messager.alert("��ʾ","���û�������!")
			return false;
		}else if(err==-4){
			$.messager.alert("��ʾ","�������!")
			return false;
		}
	 }
	 var ASRowidStr=$("#ReplaceASRowIDStr").val();
	 for (var i=0;i<ASRowidStr.split("^").length;i++){
		 /*var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowidStr.split("^")[i])
		 if (ret<0){
			$.messager.alert('����', "������Դ�ѳ�����Դ����ʱ��! ");
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
				$.messager.alert('����', 'ҽ��û�а�����Դ!');
		 		break;
			case 200:	
				$.messager.alert('����', 'ҽ���Ѿ����Ű��¼!');
				break;
			case 100:
		  		$.messager.alert('����', '����ʧ��!');
				break;
			case 101:
				$.messager.alert('����', '���Ʊ�����ҽ����ԤԼ�޶��¼ʧ��');		
		  		break;
			default:
				$.messager.alert('����', ret);
				break;	
	 		}
	 		return false;
		 }
     }
     var msg="����ɹ�!"
     if(RequestFlag==1){
		var msg="��������ɹ�!��ȴ������Ա��˺���Ч.";
	 }
	 $.messager.alert('��ʾ', msg,"info",function(){
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
 //ͣ��
 function StopSave(){	  
	 if ($("#ELeader").lookup('getText')==""){
		 PageLogicObj.m_ELeaderRowId="";
	 }
	 if (PageLogicObj.m_ELeaderRowId==""){
		$.messager.alert("��ʾ","��ѡ����׼��","info",function(){
			$("#ELeader").focus();
		})
		return false;
	}
	if ((PageLogicObj.m_ELeaderRowId!="")&&(PageLogicObj.m_ELeaderRowId!=session['LOGON.USERID'])){
		var UserName=$("#ELeader").lookup("getText");	
		var EPassword=$("#EPassword").val();
		if(EPassword==""){
			$.messager.alert("��ʾ","��������׼�ˡ�"+UserName+"���ĵ�½����!","info",function(){
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
			$.messager.alert("��ʾ","���û�������!")
			return false;
		}else if(err==-4){
			$.messager.alert("��ʾ","�������!")
			return false;
		}
	}
	if ($("#EReason").lookup('getText')=="") PageLogicObj.m_EReasonRowId="";
	if (PageLogicObj.m_EReasonRowId==""){
		$.messager.alert('��ʾ', 'ͣ��ԭ����Ϊ��!');
		return false;
	}	
	var RequestLocDesc=""
	var NotRequestLocDesc=""
	var ASRowidStr=$("#StopASRowIDStr").val();
	for (var i=0;i<ASRowidStr.split("^").length;i++){
		/*var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowidStr.split("^")[i]);
		if (ret<0){ //<0��ʱ�� >0��;ͣ�� 
		  $.messager.alert('��ʾ',t["ApptScheduleIsLater"]);
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
			$.messager.alert('����', 'ͣ��ʧ��!'+ret);
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
	var msg="ͣ��ɹ�!";
	if(NotRequestLocDesc!=""){msg=NotRequestLocDesc+"ͣ��ɹ�!"};
	if(RequestLocDesc!=""){
		if(msg!=""){msg=msg+";"+RequestLocDesc+"ͣ������ɹ�!��ȴ������Ա��˺���Ч."}
		else{msg=RequestLocDesc+"ͣ������ɹ�!��ȴ������Ա��˺���Ч."}	
	}
	$.messager.alert('��ʾ', msg,"info",function(){
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
	//��׼ԭ��
	$("#EReason").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'��׼ԭ��',width:350}
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
	//������
	$("#ELeader").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowId', 
        textField:'Desc',
        columns:[[  
            {field:'RowId',title:'',hidden:true},
			{field:'Desc',title:'��׼��',width:350}
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
			 //��������˷ǵ�ǰ��½�û�,����ʾ����
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
			{field:'Desc',title:'����ҽ��',width:250}
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
			{field:'LocDesc',title:'��������',width:350}
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
			{field:'Desc',title:'����ְ��',width:350}
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
			{field:'Desc',title:'��׼ԭ��',width:350}
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
			{field:'Desc',title:'��׼��',width:350}
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
   //�������Backspace������  
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
///��������ͣ��
function CancelScheduleStop()
{
	var Error=""
	var rows=ScheduleListDataGrid.datagrid("getSelections")
	var idStr=""
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus
		if(status.indexOf("ͣ��")<0) {
			$.messager.alert("��ʾ","��ͣ��״̬���Ű��¼���ܽ��г���ͣ�����!")
			return false;
		}
		//���г���ͣ�����
		var rtn=tkMakeServerCall("web.DHCRBApptSchedule","CancelStopOneSchedule",rows[i].ASRowId)
		if(rtn!=0){
			var rtnArr=rtn.split("^")
			if(rtnArr[0]=='-201'){
				dhcsys_alert("���ܳ���ͣ��,"+rtnArr[1]+"������ͬʱ�ε��Ű�!");
				Error="Y";
				continue;
			}else{
				dhcsys_alert("����ͣ��ʧ��!");
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
		$.messager.alert("��ʾ","���ڳ���ʧ�ܵļ�¼,��ע��˶Բ�������!")	
		LoadScheduleList();
		return false
	}
	
	if(idStr==""){
		$.messager.alert("��ʾ","��ѡ��Ҫ����ͣ����Ű��¼!")
		return false
	}
	$.messager.popover({msg:"����ͣ��ɹ�!",type:'info'});
	LoadScheduleList();
}

//����
function InitCombWeek(){
	
	var JsonComb="[{'Desc':'��һ','Value':'1'},{'Desc':'�ܶ�','Value':'2'},{'Desc':'����','Value':'3'},{'Desc':'����','Value':'4'},{'Desc':'����','Value':'5'},{'Desc':'����','Value':'6'},{'Desc':'����','Value':'7'}]"
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
	   	ExcelName:"������Ϣ",
	  	ClassName : "web.DHCApptScheduleNew",
	    QueryName : "ApptScheduleExport",
	    Loc:PageLogicObj.m_deptRowId,
	    Doc:PageLogicObj.m_DocRowId, StDate:StartDate, EnDate:EndDate,
	    userid:session['LOGON.USERID'], groupid:session['LOGON.GROUPID'],
	    ResID:"", ExaID:"", paraTimeRange:PageLogicObj.m_TimeRangeRowId, Type:Type,SelectStop:SelectStop,
	    WeekStr:WeekStr,HospId:HospID,
	},false)

	}