var arrayObj = new Array(
	  new Array("Check_GeneSchedule","AudiGeneSchedule"),
	  new Array("Check_NewSchedule","AudiNewSchedule"),
	  new Array("Check_StopSchedule","AudiStopSchedule"),
	  new Array("Check_CancelStopSchedule","AudiCancelStopSchedule"),
	  new Array("Check_ReplaceSchedule","AudiReplaceSchedule")
);
var PageLogicObj={
	m_AuthFlag:tkMakeServerCall("DHCDoc.Interface.Inside.InvokeAuth","GetSwitch"),
	m_AuthLoad:0
}
var AudiReasonDataGrid;

$(document).ready(function(){
	Init();
	InitEvent();
	InitCache();
});
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	var hospComp = GenHospComp("Doc_OPAdm_ScheduleAudit");
	InitAudiReasonDataGrid();
	hospComp.jdata.options.onSelect = function(e,t){
		LoadGroupData();
		LoadCheckData();
		LoadLocData();
		AudiReasonDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		LoadGroupData();
		LoadCheckData();
		LoadLocData();
		AudiReasonDataGridLoad();
	}
	LoadAuthHtml();
}

function LoadCheckData(){
	for(var i=0;i<arrayObj.length;i++){
		var paramid=arrayObj[i][0];
		var param=arrayObj[i][1];
		
		var ObjScope=$.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"GetConfigNodeNew",
			'Node':param,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		
		var result=false;
		var value=ObjScope.result;
		if(value=="Y"){
			result=true;	
		}

		SetSwitchBox(paramid,result);	

	}
}

function InitEvent(){
	$('#Confirm').click(function() {
		SaveConfigData();
	})
	
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});

}

function SetSwitchBox(param,objScopeVal){
	var obj=$HUI.switchbox("#"+param);
	obj.setValue(objScopeVal)	
}

function LoadGroupData(){
	$("#List_AudiNotLimitedGroup").empty();
	$.m({
		ClassName:"web.DHCRBApptScheduleAudi",
		MethodName:"FindGroupListBroker",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneGroup=objScopeArr[i];
			var oneGroupArr=oneGroup.split(String.fromCharCode(2))
			var GroupRowID=oneGroupArr[0];
			var GroupDesc=oneGroupArr[1];
			var selected=oneGroupArr[2];
			vlist += "<option value=" + GroupRowID + ">" + GroupDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_AudiNotLimitedGroup").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_AudiNotLimitedGroup").get(0).options[j-1].selected = true;
			}
		}
	});	
}

function LoadLocData(){
	$("#List_AudiNotNeedLoc").empty();
	$.m({
		ClassName:"web.DHCRBApptScheduleAudi",
		MethodName:"FindLocListBroker",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneLoc=	objScopeArr[i];
			var oneLocArr=oneLoc.split(String.fromCharCode(2))
			var LocRowID=oneLocArr[0];
			var LocDesc=oneLocArr[1];
			var selected=oneLocArr[2];
			vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_AudiNotNeedLoc").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_AudiNotNeedLoc").get(0).options[j-1].selected = true;
			}
		}
	});
    
}

function SaveConfigData()
{
	var LocDataStr=""
	var size = $("#List_AudiNotNeedLoc option").size();
	if(size>0){
		$.each($("#List_AudiNotNeedLoc  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (LocDataStr=="") LocDataStr=svalue
			else LocDataStr=LocDataStr+"^"+svalue
		})
		LocDataStr="AudiNotNeedLocStr"+String.fromCharCode(1)+LocDataStr
	}
	
	var GroupDataStr=""
	var size = $("#List_AudiNotLimitedGroup option").size();
	if(size>0){
		$.each($("#List_AudiNotLimitedGroup  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (GroupDataStr=="") GroupDataStr=svalue
			else GroupDataStr=GroupDataStr+"^"+svalue
		})
		GroupDataStr="AudiNotLimitedGroupStr"+String.fromCharCode(1)+GroupDataStr
	}
	
	var AuthGroupStr="";
	if (PageLogicObj.m_AuthFlag==1){
		AuthGroupStr=GroupDataStr;
		GroupDataStr=""
	}
	
	var CheckStr="";
	for(var i=0;i<arrayObj.length;i++){
		var paramid=arrayObj[i][0];
		var param=arrayObj[i][1];
		var myobj=$HUI.switchbox("#"+paramid);
		var paramflag="";
		if (myobj.getValue()) {
			paramflag="Y";
		}
		var str=param+String.fromCharCode(1)+paramflag;
		if(CheckStr==""){
			CheckStr=str;
		}else{
			CheckStr=CheckStr+String.fromCharCode(2)+str;	
		}
	}

	var DataStr=LocDataStr+String.fromCharCode(2)+CheckStr+String.fromCharCode(2)+GroupDataStr;
	var ret=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		Coninfo:DataStr,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(ret=="0"){
		$.messager.show({title:"��ʾ",msg:"����ɹ�"});					
	}else{
		$.messager.show({title:"��ʾ",msg:"����ʧ��"});		
	}
	if (PageLogicObj.m_AuthFlag==1){
		var ret=$.m({
			ClassName:"DHCDoc.Interface.Inside.InvokeAuth",
			MethodName:"InvokeScheduleAudiAuth",
			Coninfo:AuthGroupStr,
			HospID:$HUI.combogrid('#_HospList').getValue(),
			UserID:session["LOGON.USERID"],
		},false);
		var Arr=ret.split("^");
        $.messager.alert("��ʾ",Arr[1],"info",function(){
            //location.reload();
            LoadAuthHtml();
        });
	}
}

function InitAudiReasonDataGrid(){
	var AudiReasontoolbar=[{
		text:'����',
		iconCls:'icon-add',
		handler:function(){
			$("#add-dialog").dialog("open");
			//��ձ�����
			$('#add-form').form("clear");

		}
	},{
		text:'����',
		iconCls:'icon-update',
		handler:function(){
			UpdateGridData();
		}	
	},{
        text: '��ȨҽԺ',
        iconCls: 'icon-house',
        handler: function() {
	        var row=AudiReasonDataGrid.datagrid('getSelected');
			if (!row){
				$.messager.alert("��ʾ","��ѡ��һ�У�")
				return false
			}
			GenHospWin("DHC_RBApptScheduleAudiReason",row.TAudiID);
	    }
    }]
	AudiReasonDataGrid=$('#tblAudiReason').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"TAudiID",
		//pageNumber:0,
		pageSize : 10,
		pageList : [10,20,50],
		toolbar:AudiReasontoolbar,
		columns :[[ 
				{field:'TAudiID',title:'����',width:50,align:'center'}, 
				{field:'TAudiDesc',title:'�ܾ�ԭ��',width:250,align:'center'}, 
				{field:'TAudiStartDate',title:'��ʼ����',width:150,align:'center'}, 
				{field:'TAudiEndDate',title:'��������',width:150,align:'center'}								
			 ]]
	});
	
}

function AudiReasonDataGridLoad(){
	
	$.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"FindAudiReason",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		Pagerows:AudiReasonDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		AudiReasonDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
		AudiReasonDataGrid.datagrid('clearSelections'); 
	})

}

function CheckData(){
	var DDCTSDesc=$("#Desc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('��ʾ','��������Ϊ��');   
        return false;
	}
	var DDCTSStartTime=$("#StartDate").datebox('getValue');
	if(DDCTSStartTime=="")
	{
		$.messager.alert('��ʾ','��ʼ���ڲ���Ϊ��');   
        return false;
	}
	var DDCTSEndTime=$("#EndDate").datebox('getValue');
	if(DDCTSEndTime=="")
	{
		//$.messager.alert('��ʾ','�������ڲ���Ϊ��');   
        //return false;
	}
	return true;
}
///�޸ı����
function SaveFormData(){
	if(!CheckData()) return false;    
	var ROWID=$("#ROWID").val();
	var Desc=$("#Desc").val();
	var StartDate=$("#StartDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	var InputPara=ROWID+"^"+Desc+"^"+StartDate+"^"+EndDate;
	 //alert(InputPara)
	 
	$.m({
		ClassName:"web.DHCRBApptScheduleAudi",
		MethodName:"SetAudiReason",
		Para:InputPara,
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			AudiReasonDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else err=value;
			$.messager.alert('��ʾ',err);   
			return false;
		}
	});
}
///�޸ı����
function UpdateGridData(){
	var rows = AudiReasonDataGrid.datagrid("getSelections");
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open').window('resize',{width:'350px',height:'300px',top: 100,left:400});
		//��ձ�����
		$('#add-form').form("clear")
		
		$('#add-form').form("load",{
			ROWID:rows[0].TAudiID,
			Desc:rows[0].TAudiDesc,
			StartDate:rows[0].TAudiStartDate,
			EndDate:rows[0].TAudiEndDate,
		})
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }
}
function LoadAuthHtml() {
	if (PageLogicObj.m_AuthLoad==1) return false;		//ֻ����һ��
    $m({
        ClassName: "BSP.SYS.SRV.AuthItemApply",
        MethodName: "GetStatusHtml",
        AuthCode: "HIS-DOC-SCHEDULEAUDI"
    }, function (rtn) {
        if (rtn != "") {
	        PageLogicObj.m_AuthLoad=1;
	        $('#Panel_AudiNotLimitedGroup').panel('setTitle',"<label>�������Ƶİ�ȫ��</label>"+rtn);
        }
    })
}
