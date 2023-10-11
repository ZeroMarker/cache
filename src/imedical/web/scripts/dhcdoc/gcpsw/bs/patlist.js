/**
 * patlist.js
 * 
 * Copyright (c) 2020-2021 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-11-13
 * 
 * 
 */
PLObject = {
	v_PI:""
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitGrid();
	InitCombox();
}
function InitEvent () {
	$("#BFind").click(Find_Handle)
	$("#Clear").click(Clear_Handle)
	$("#PatientNo").keydown(PatientNo_KeyDownHander);
	$("#PPName").keydown(PPName_KeyDownHander);
	$("#PPCode").keydown(PPCode_KeyDownHander);
	$("#PatName").keydown(PatName_KeyDownHander);
}

function InitCombox() {
	///alert(111)
	var UserID = 3901		//session['LOGON.USERID'];
	PLObject.m_PPDesc = $HUI.combobox("#PPDesc", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=QryGCP&UserID="+UserID+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		defaultFilter:4,
		blurValidValue:true
	});
	
	
	$("#PI").lookup({
        url:$URL,
        mode:'remote',
		//required:true,
        method:"Get",
        idField:'uid',
        textField:'userName',
        columns:[[  
		   {field:'jobNum',title:'����',width:100},
		   {field:'userName',title:'����',width:100},
		   {field:'defaultLocDesc',title:'Ĭ�ϵ�¼����',width:200},
           {field:'uid',title:'uid',width:60,sortable:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:400,
        isCombo:true,
        minQueryLen:0,
        delay:'100',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.GCPSW.COM.Qry',QueryName: 'QryTransDoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{inDesc:desc});
	    },onSelect:function(ind,item){
		    PLObject.v_PI = item['uid'];
		},onHidePanel:function() {
			var text = $("#PI").lookup("getText")||"";
			if (text=="") {
				PLObject.v_PI = "";
			}
		}
    });
	

}

function InitGrid(){
	var columns = [[
		{field:'PPRowId',hidden:true,title:''},
		{field:'PPPID',hidden:true,title:''},
		{field:'PPPAID',hidden:true,title:''},
		{field:'PapmiDr',hidden:true,title:''},
		{field:'admid',hidden:true,title:''},
		{field:'mradm',hidden:true,title:''},
		{field:'PPCode',title:'��Ŀ���',width:100},
		{field:'PPDesc',title:'ҩ��/ҽ����е����',width:150},
		{field:'CreateLoc',title:'�������',width:100},
		{field:'StartUser',title:'��Ҫ�о���',width:100},
		{field:'PatientNo',title:'������ID',width:100},
		{field:'PatientName',title:'����������',width:100},
		{field:'Sex',title:'�������Ա�',width:100},
		{field:'Age',title:'����������',width:100},
		{field:'OAdmDate',title:'�����������',width:100},
		{field:'InHospDate',title:'סԺ����',width:120},
		{field:'OutHospDate',title:'��Ժ����',width:120},
		{field:'Diagnosis',title:'���',width:150},
		{field:'MainNote',title:'����',width:100},
		{field:'LastPPCode',title:'���һ���ٴ�������Ŀ���',width:180},
		{field:'LastPPDesc',title:'���һ���ٴ����鷽������',width:180},
		{field:'LastICFDate',title:'���һ���ٴ�����ǩ��ICF����',width:200},
		{field:'LastOutDate',title:'���һ���ٴ������������',width:180}
	]]
	var toolbar =[	
				
		] 
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		//fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.BS.PatList",
			QueryName : "QryGCPAdmList"
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_RID = rowData.id;
		},
		//toolbar:toolbar,
		columns :columns,
		onLoadSuccess: function (data) {
		    if (data.rows.length == 0) {}
		    else {
		        //$(this).datagrid("selectRow", 0);
		    }
		}

	});
	
	PLObject.m_Grid = DataGrid;
}

function Clear_Handle () {
	$("#StartDate").datebox("clear");
	$("#EndDate").datebox("clear");
	$("#PPCode,#PPName,#PatientNo,#PatName,#PatientID").val("");
	PLObject.m_PPDesc.clear();
	//$("#PI").lookup("setValue","")
	$("#PI").lookup("setText","")
	PLObject.v_PI = "";
	Find_Handle();
}

function Find_Handle () {
	var PList = {
		StartDate:$("#StartDate").datebox("getValue")||"",
		EndDate:$("#EndDate").datebox("getValue")||"",
		PPCode:$.trim($("#PPCode").val()),
		PPDesc:$.trim($("#PPName").val()),
		PI:PLObject.v_PI,
		PatNo:$.trim($("#PatientNo").val()),
		PatName:$.trim($("#PatName").val())
	}
	
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.GCPSW.BS.PatList",
		QueryName : "QryGCPAdmList",
		PPRowId:PLObject.m_PPDesc.getValue()||"",
		PatientID:$("#PatientID").val(),
		PList:JSON.stringify(PList)
	})
	
}

function PPName_KeyDownHander (e) {
	var key=websys_getKey(e);
	if (key==13){
		Find_Handle();
	}
}

function PPCode_KeyDownHander (e) {
	var key=websys_getKey(e);
	if (key==13){
		Find_Handle();
	}
}

function PatName_KeyDownHander (e) {
	var key=websys_getKey(e);
	if (key==13){
		Find_Handle();
	}
}

function PatientNo_KeyDownHander(e) {
	var key=websys_getKey(e);
	if (key==13){
		SetPapmiNoLenth();
		SetPatInfo();
		Find_Handle();
	}
}

function SetPapmiNoLenth() {
	var PatientNo=$('#PatientNo').val();
	var m_PAPMINOLength=10;
	if (PatientNo!='') {
		if ((PatientNo.length<m_PAPMINOLength)&&(m_PAPMINOLength!=0)) {
			for (var i=(m_PAPMINOLength-PatientNo.length-1); i>=0; i--) {
				PatientNo="0"+PatientNo;
			}
		}	
	}
	$('#PatientNo').val(PatientNo);
}

function SetPatInfo(){
	var PatientNo=$('#PatientNo').val();
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetPatientByNo",
		dataType:"text",
		PapmiNo:PatientNo
	},function(rtnStr){
		if (rtnStr!=""){
			var rtnStrTemp=rtnStr.split("^");
			var myStr=rtnStrTemp[1]+","+rtnStrTemp[2]+","+rtnStrTemp[3]+","+rtnStrTemp[4];
			$("#PatientID").val(rtnStrTemp[0]);
			$("#PatName").val(rtnStrTemp[2]);
		}else{
			$("#PatientID").val("");
			$("#PatName").val("");
		}
	}); 
}

