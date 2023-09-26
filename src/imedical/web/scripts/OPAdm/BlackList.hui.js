var PageLogicObj={
	m_DHCBlackListDataGrid:"",
	m_DHCPatAppInfoDataGrid:"",
	m_BlacklistTypeDataGrid:"",
};
$(function(){
	Init();
	InitEvent();
	DHCBlackListDataGridLoad();
});
function Init(){
	InitDate();
	PageLogicObj.m_DHCBlackListDataGrid=InitDHCBlackListDataGrid();
	PageLogicObj.m_DHCPatAppInfoDataGrid=InitPatAppInfoDataGrid();
	$(document.body).bind("keydown",BodykeydownHandler)
	intiBlackListType()
}

function InitEvent(){
	$('#BAdd').click(function() {
		AddClickHandle();	
	})
	$('#BFind').click(function() {
		DHCBlackListDataGridLoad();
	})
	$('#BClear').click(function() {
		ClearData();	
	})
	
	$('#BModify').click(function() {
		ModifyClickHandle();		
	})
	
	$('#BSaveConfig').click(function() {
		SaveConfigClickHandle();		
	})
	
	$("#CardNo").keydown(function(e){
		CardNoKeydownHandler(e);
	});
	$("#PatNo").keydown(function(e){
		PatNoKeydownHandler(e);
	});
	
	$("#ReadCard").click(function(e){
	   	ReadCardClickHandler()
   });
   $("#BType").click(function(e){
	   	BTypeClickHandler()
   });
}

function ReadCardClickHandler(){
	//var myrtn=DHCACC_GetAccInfo("","");
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack,true);
}

function ModifyClickHandle(){
	$("#add-dialog").dialog("open");
	$('#add-form').form("clear");
	ClearConfigData();
	InitConfigData();
}

function ClearConfigData(){
	$('#Date').numberbox('setValue',"");
	$('#SYCount').numberbox('setValue',"");
	$('#SYDate').numberbox('setValue',"");	
}

function InitConfigData(){
	$.cm({
		ClassName:"web.InExportApp",
		MethodName:"GetBlackConfig",
		dataType:"text",
	},function(value){
		if(value=="")return;
		var Config=value.split("^");
		$('#Date').numberbox('setValue',Config[0]);
		$('#SYCount').numberbox('setValue',Config[1]);
		$('#SYDate').numberbox('setValue',Config[2]);	
	})
}

function SaveConfigClickHandle(){
	var Date=$('#Date').numberbox('getValue');
	var SYCount=$('#SYCount').numberbox('getValue');
	var SYDate=$('#SYDate').numberbox('getValue');		
	$.cm({
		ClassName:"web.InExportApp",
		MethodName:"UpdateConfig",
		dataType:"text",
		Date:Date,
		Count:SYCount,
		SYDate:SYDate,
	},function(value){
		$.messager.alert("提示","保存成功.","info",function(){
			$("#add-dialog").dialog("close");
			DHCBlackListDataGridLoad();
		});
	})	
}

function CardNoKeydownHandler(e){
   var key=websys_getKey(e);
   var CardNo=$("#CardNo").val();
   if (key==13) {
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo","CardTypeCallBack");
		if(!myrtn){
			$("#CardNo").focus();
			ClearData();	
		}
		return false;
   }
}
function CardTypeCallBack(myrtn){
    var myary=myrtn.split("^");
    //alert(myrtn)
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			//alert(PatientID+",,,"+CardNo)
			SetPatientInfo(PatientNo,CardNo,PatientID);
			if(event)event.keyCode=13;			
			break;
		case "-200": //卡无效
			setTimeout(function(){$.messager.alert("提示","该卡无效!","info",function(){
				$("#CardNo").focus();
				ClearData();	
			});
			})
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			//alert(PatientNo+",,,"+CardNo)
			SetPatientInfo(PatientNo,CardNo,PatientID);
			if(event)event.keyCode=13;
			break;
		default:
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	$("#PatientID").val(PatientID);
	if (PatientID!=""){
		$.m({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"GetPatientByRowid",
			PapmiRowid:PatientID
		},function(PatInfo){
			var tempArr=PatInfo.split("^");
			var PatNo=tempArr[1];
			var PatName=tempArr[2];
			var PatIDCard=tempArr[30];
			$("#PatNo").val(PatNo);
			$("#PatName").val(PatName);
			$("#PatIDCard").val(PatIDCard);
			$("#BlackNote").val("")
		});
	}else{
		ClearData();	
	}
}
function PatNoKeydownHandler(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var m_PatientNoLength=10;
		var PatNo=$("#PatNo").val();
		if (PatNo!=""){
			if ((PatNo.length<m_PatientNoLength)&&(m_PatientNoLength!=0)) {
				for (var i=(m_PatientNoLength-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
		}
		$("#PatNo").val(PatNo);
		CheckPatientNoNew(PatNo);
	}
}

function CheckPatientNoNew(PatNo)
{
	$.m({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetCardNoByPatientNo",
		PatientNo:PatNo
	},function(CardNoStr){
		var CardInfoArr=CardNoStr.split("^");
		var CardNo=CardInfoArr[0]
		if (CardNo=="") {
			$.messager.alert("提示","该登记号无对应卡号信息!","info",function(){
				$("#PatNo").focus();
			})
			$("#CardNo,#PatName").val("");
			SetPatientInfo("","","")
			return false;
		}
		var CardTypeRowId=CardInfoArr[1];
		$("#CardTypeNew").val(CardInfoArr[2]);
		$("#CardNo").val(CardNo);
		$("#PatName").val(CardInfoArr[4]);
		$("#PatientID").val(CardInfoArr[3]);
	});
}

function InitDHCBlackListDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle();}
    },{
        text: '置为无效',
        iconCls: 'icon-update',
        handler: function() { UpdateDetailClickHandle();}
    }];
	var Columns=[[ 
		{field:'PBRowId',hidden:true,title:''},
		{field:'RegNo',title:'登记号',width:300},
		{field:'ApptPatName',title:'患者姓名',width:200,
			formatter:function(value,row){							
				return '<a href="###">'+row.ApptPatName+"</a>"
			}},
		{field:'CardNo',title:'卡号',width:300},
		{field:'TPAPMICardType',title:'证件类型',width:200},
		{field:'IDCardNo',title:'证件号',width:300},
		{field:'InfoFlag',title:'信息标志',width:200,formatter:function(value,row,index){
				//兼容组建版本
				if(value=="0"){
					return "无效";	
				}else{
					return "有效";	
				}
		}},
		{field:'TBlackType',title:'黑名单类型',width:200},
		{field:'TBlackNote',title:'备注',width:300},
		{field:'AddUser',title:'新增操作人',width:300},
		{field:'StDate',title:'有效开始日期',width:300},
		{field:'TEndDate',title:'有效截止日期',width:300},
		{field:'PatientID',hidden:true,width:30}
    ]]
	var DHCBlackListDataGrid=$("#DHCBlackListTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'PBRowId',
		columns :Columns,
		toolbar:toobar,
		onClickCell:function(index, field,value){
			if(field=="ApptPatName"){
				ShowPatAppInfo(index);
			}
		},
		onUnselect:function(index, row){
			//ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_DHCBlackListDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DHCBlackListDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					//PageLogicObj.m_DHCBlackListDataGrid.datagrid('unselectRow',index);
					//return false;
				}
			}
		}
	}); 
	return DHCBlackListDataGrid;
}

function SetSelRowData(row){
	var PBRowId=row["PBRowId"];
	if(PBRowId=="")return;
	var StDate=row["StDate"]
	var TEndDate=row["TEndDate"];
	
	$HUI.datebox("#StartDate").setValue(row["StDate"]);
	$HUI.datebox("#EndDate").setValue(row["TEndDate"]);	
}

function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var PatientID=$("#PatientID").val();
	var CardNo=$("#CardNo").val();
	var RegNo=$("#PatNo").val();
	var SttDate=$HUI.datebox("#StartDate").getValue();
	var Name=$("#PatName").val();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var PatIDCard=$("#PatIDCard").val();
	var Blacktype=$HUI.datebox("#BlackType").getValue();
	var BlackNote=$("#BlackNote").val();
	$.messager.confirm('确认对话框', '若该患者已存在【'+$HUI.datebox("#BlackType").getText()+"】类型的黑名单,新增会覆盖原有记录,是否新增?", function(r){
		if (r){
		    $.cm({
				ClassName:"web.DHCRBAppointment",
				MethodName:"InsertBlackList",
				PBType:"R",
				PatientID:PatientID,
				IDCardNo:PatIDCard,
				Name:Name,
				AddUserID:session['LOGON.USERID'],
				BlackType:Blacktype,
				BlackNote:BlackNote,
			},function(rtn){
				if (rtn=="0"){
					$.messager.show({title:"提示",msg:"新增黑名单记录成功"});
					PageLogicObj.m_DHCBlackListDataGrid.datagrid('uncheckAll');
					ClearData();
					DHCBlackListDataGridLoad();
				}else{
					$.messager.alert("提示","新增黑名单记失败!错误代码:"+rtn,"error");
					return false;
				}
			});
		}
	});
}

function ClearData(){
	InitDate();
	$("#CardTypeNew,#CardNo,#PatNo,#PatName,#PatIDCard,#PatientID,#BlackNote").val("");
	var BlackTypeData=$("#BlackType").combobox('getData');
	if (BlackTypeData.length>0) {
		$("#BlackType").combobox('select',BlackTypeData[0].RowId);
	}
}

function CheckDataValid(){
	var Blacktype=$HUI.datebox("#BlackType").getValue();
	if (!Blacktype) {
		$.messager.alert("提示","请选择黑名单类型!","info",function(){
			$("#BlackType").next('span').find('input').focus();
		});
		return false;
	}
	var PatientID=$("#PatientID").val();
	var RegNo=$("#PatNo").val();
	var PatIDCard=$("#PatIDCard").val();
	if (PatientID==""){
		$.messager.alert("提示","请根据卡号或者登记号确定有效病人.","info");
		return false;
	}
	if(PatIDCard!=""){	
		var myIsID=DHCWeb_IsIdCardNo(PatIDCard);
		if (!myIsID){
			websys_setfocus("PatIDCard");
			return false;
		}
	}
	
	var StartDate=$HUI.datebox("#StartDate").getValue();
	if (StartDate==""){
		//$.messager.alert("提示","缺少有效开始日期","info",function(){$("#StartDate").focus();});
		//return false;
	}
	var EndDate=$HUI.datebox("#EndDate").getValue();
	if (EndDate==""){
		//$.messager.alert("提示","缺少有效截止日期","info",function(){$("#EndDate").focus();});
		//return false;
	}
	var Rtn=CompareDate(StartDate,EndDate)
	if (!Rtn){
		//$.messager.alert("提示","结束日期不能小于开始日期!");
		//return Rtn
	}
	
	return true;
}
function DHCBlackListDataGridLoad(){
	var CardNo=$("#CardNo").val();
	var RegNo=$("#PatNo").val();
	var SttDate=$HUI.datebox("#StartDate").getValue();
	var Name=$("#PatName").val();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var PatIDCard=$("#PatIDCard").val();
	var Blacktype=$HUI.datebox("#BlackType").getValue();
	$.q({
	    ClassName : "web.InExportApp",
	    QueryName : "BlackList",
	    'SttDate':SttDate,
	    'EndDate':EndDate,
	    'CardNo1':CardNo,
	    'RegNo1':RegNo,
	    'Name':Name,
	    'PatIDCard':PatIDCard,
	    "Blacktype":Blacktype,
	    Pagerows:PageLogicObj.m_DHCBlackListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCBlackListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_DHCBlackListDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_DHCBlackListDataGrid.datagrid('clearChecked'); 
	}); 
}

function UpdateDetailClickHandle(){
	var PBRowId="";
	var row=PageLogicObj.m_DHCBlackListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的黑名单记录!","info");
		return false;
	}
	PBRowId=row.PBRowId;	
	var InfoFlag=row.InfoFlag;
	if(InfoFlag=="0"){
		$.messager.alert("提示","该黑名单记录已经是无效状态.","info")
		return false	
	}
	$.cm({
		ClassName:"web.InExportApp",
		MethodName:"SetBlackStatus",
		PBRowId:PBRowId,
		dataType:"text"		
	},function(ret){
		if(ret==0) {
			$.messager.show({title:"提示",msg:"修改成功"});
	 		DHCBlackListDataGridLoad();
 		}
   		else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret,"error");
	   		return false;
   		}
	})
}

function ShowPatAppInfo(rowIndex){
	var rows=PageLogicObj.m_DHCBlackListDataGrid.datagrid('getRows'); 
	var ApptPatName=rows[rowIndex].ApptPatName;
	var PatientID=rows[rowIndex].PatientID;
	var RegNo=rows[rowIndex].RegNo;
	var PatIDCard=rows[rowIndex].IDCardNo;
	//alert(ApptPatName+","+PatientID+","+RegNo+","+PatIDCard)
	$("#AppInfo-dialog").dialog("open");
	PatAppInfoDataGridLoad(PatientID,RegNo,ApptPatName,PatIDCard);
}
function InitPatAppInfoDataGrid(){
	var AppinfoColumns=[[ 
		{field:'RowId',hidden:true,title:''},
		{field:'PatName',title:'患者姓名',width:300},
		{field:'Loc',title:'预约科室',width:300},
		{field:'Doc',title:'医生',width:200},
		{field:'SYDate',title:'爽约时间',width:300},
    ]]
	var PatAppInfoDataGrid=$("#PatAppInfoTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 15,
		pageList : [15,50],
		idField:'RowId',
		columns :AppinfoColumns
	}); 
	return PatAppInfoDataGrid;	
}
function PatAppInfoDataGridLoad(PatientID,RegNo,ApptPatName,PatIDCard){
	$.q({
	    ClassName : "web.InExportApp",
	    QueryName : "FindApptInfo",
	    'PatientID':PatientID,
	    'PatName':ApptPatName,
	    'RegNo':RegNo,
	    'IDCardNo':PatIDCard,
	    Pagerows:PageLogicObj.m_DHCPatAppInfoDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCPatAppInfoDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_DHCPatAppInfoDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_DHCPatAppInfoDataGrid.datagrid('clearChecked'); 
	}); 	
}
function BodykeydownHandler(e){
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
        //e.preventDefault(); 
        return false;  
    }  
}

function InitDate(){
	$('#StartDate').datebox('setValue', ServerObj.MCurrDate);	
    $('#EndDate').datebox('setValue', ServerObj.CurrDate);		
}

function BTypeClickHandler(){
	$("#BlacklistType-dialog").dialog("open");
	if (PageLogicObj.m_BlacklistTypeDataGrid=="") {
		PageLogicObj.m_BlacklistTypeDataGrid=BlacklistTypeTabDataGrid();
	}
	BlacklistTypeDataGridLoad();
	$("#BlacklistTypeCode").val("");
	$("#BlacklistTypeName").val("");
	$("#BlacklistTypeExecuteCode").val("");
}
function BlacklistTypeTabDataGrid(){
	var AppinfoColumns=[[ 
		{field:'RowId',hidden:true,title:''},
		{field:'Code',title:'代码',width:100},
		{field:'Desc',title:'类型',width:150},
		{field:'ExecuteCode',title:'管控执行代码',width:300},		
    ]]
    var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddBlackTypeClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() { DelectBlackTypeClickHandle();}
    },{
        text: '更新',
        iconCls: 'icon-write-order',
        handler: function() { UpdateBlackTypeClickHandle();}
    }];
	var BlacklistTypeDataGrid=$("#BlacklistTypeTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 15,
		pageList : [15,50],
		idField:'RowId',
		toolbar:toobar,
		columns :AppinfoColumns,
		onSelect:function(index,row){
			$("#BlacklistTypeCode").val(row["Code"]);
			$("#BlacklistTypeName").val(row["Desc"]);
			$("#BlacklistTypeExecuteCode").val(row["ExecuteCode"]);
		}
	}); 
	return BlacklistTypeDataGrid;	
}
function BlacklistTypeDataGridLoad(){
	$.q({
	    ClassName : "web.InExportApp",
	    QueryName : "FindBlackListType",
	    Pagerows:PageLogicObj.m_DHCPatAppInfoDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_BlacklistTypeDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_BlacklistTypeDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_BlacklistTypeDataGrid.datagrid('clearChecked'); 
	}); 	
}
function AddBlackTypeClickHandle(){
	var BlacklistTypeCode=$("#BlacklistTypeCode").val();
	var BlacklistTypeName=$("#BlacklistTypeName").val();
	var BlacklistTypeExecuteCode=$("#BlacklistTypeExecuteCode").val();
	if (BlacklistTypeCode==""){
		$.messager.alert("提示","代码不能为空","error");
		return false
	}
	if (BlacklistTypeName==""){
		$.messager.alert("提示","描述不能为空","error");
		return false
	}
	$.cm({
		ClassName:"web.InExportApp",
		MethodName:"InsertBlackType",
		ID:"",
		Code:BlacklistTypeCode,
		Desc:BlacklistTypeName,
		ExecuteCode:BlacklistTypeExecuteCode,
		dataType:"text"		
	},function(ret){
		if(ret==0) {
			$.messager.popover({msg: '新增成功!',type:'success'});
	 		BlacklistTypeDataGridLoad();
	 		$("#BlacklistTypeCode,#BlacklistTypeName,#BlacklistTypeExecuteCode").val("");
	 		intiBlackListType();
 		}else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret,"error");
	   		return false;
   		}
	})
}
function UpdateBlackTypeClickHandle(){
	var rows=PageLogicObj.m_BlacklistTypeDataGrid.datagrid("getSelected");
	if (!rows) {
		$.messager.alert("提示","请选择行","error");
		return false;
	}
	var PatListTypeCode=$("#BlacklistTypeCode").val();
	var PatListTypeName=$("#BlacklistTypeName").val();
	var PatListTypeExecuteCode=$("#BlacklistTypeExecuteCode").val();
	if (PatListTypeCode==""){
		$.messager.alert("提示","代码不能为空","error");
		return false;
	}
	if (PatListTypeName==""){
		$.messager.alert("提示","描述不能为空","error");
		return false;
	}
	$.cm({
		ClassName:"web.InExportApp",
		MethodName:"InsertBlackType",
		ID:rows["RowId"],
		Code:PatListTypeCode,
		Desc:PatListTypeName,
		ExecuteCode:PatListTypeExecuteCode,
		dataType:"text"		
	},function(ret){
		if(ret==0) {
			$.messager.popover({msg: '更新成功!',type:'success'});
	 		BlacklistTypeDataGridLoad();
	 		$("#BlacklistTypeCode,#BlacklistTypeName,#BlacklistTypeExecuteCode").val("");
	 		intiBlackListType();
 		}else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret);
	   		return false;
   		}
	})
}
function DelectBlackTypeClickHandle(){
	var selrow = PageLogicObj.m_BlacklistTypeDataGrid.datagrid('getSelected');
	var rows = PageLogicObj.m_BlacklistTypeDataGrid.datagrid('getData')
	if (selrow==null){
		$.messager.alert("提示","请选择一行","error");
	   	return false;
	}
	var ID=selrow.RowId
	$.cm({
		ClassName:"web.InExportApp",
		MethodName:"DelectBlackType",
		ID:ID,
		dataType:"text"		
	},function(ret){
		if(ret==0) {
			$.messager.popover({msg: '删除成功!',type:'success'});
			$("#BlacklistTypeCode,#BlacklistTypeName,#BlacklistTypeExecuteCode").val("");
	 		BlacklistTypeDataGridLoad();
	 		intiBlackListType();
 		}
   		else{
	   		$.messager.alert("提示","删除失败,错误信息:"+ret,"error");
	   		return false;
   		}
	})
}
function intiBlackListType(){
	var cbox = $HUI.combobox("#BlackType", {
		url:$URL+"?ClassName=web.InExportApp&QueryName=FindBlackListType&ResultSetType=array&HospID="+session['LOGON.HOSPID'],
		valueField:'RowId',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onSelect: function (record) {
			
		},
		onLoadSuccess:function(data){
			var sbox = $HUI.combobox("#BlackType");
			sbox.setValue(data[0].RowId);
		}
	});
}