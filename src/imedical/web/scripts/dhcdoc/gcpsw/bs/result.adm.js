/**
 * result.adm.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-16
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitAdmGrid();
}

function InitEvent () {
	
}

function InitAdmGrid(){
	var columns=[[ 
		{field:'EpisodeID',hidden:true,title:'EpisodeID',align:'center'},
		{field:'PatientID',hidden:true,title:''},
		{field:'mradm',hidden:true,title:''},
		{field:'PAPMINO',title:'登记号',width:100},
		{field:'PAPMIName',title:'姓名',width:80,
			formatter: function(value,row,index){
				var btn = '<a style="cursor:pointer;" onclick="BLInfo(\'' + row["EpisodeID"] + '\')">'+value+'</a>';
				return btn;
			}
		},
		{field:'PAPMIDOB',title:'出生日期',width:100},
		{field:'PAPMISex',title:'性别',width:70},
		{field:'PAAdmReason',title:'患者类型',width:70},
		{field:'PAAdmDate',title:'就诊日期',width:100,order:'asc'},
		{field:'PAAdmTime',title:'就诊时间',width:110},
		{field:'IconProfile',title:'图标菜单',width:110,hidden:true},
		{field:'Ord',title:'医嘱',width:70,align:'center',hidden:true,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BAdmOrdInfo(\'' + row["Ord"] + '\')"><img src="../images/websys/update.gif"></a>';
				return btn;
			}
		},
		{field:'PAAdmDepCodeDR',title:'就诊科室',width:120},
		{field:'PAAdmDocCodeDR',title:'医生',width:110},
		{field:'PAAdmNo',title:'就诊号',width:120},
		{field:'PAAdmType',title:'就诊类型',width:80}, 
		{field:'PAAdmStatus',title:'患者状态',width:80},
		{field:'Hospital',title:'医院',width:190}, 
		{field:'PAAdmWard',title:'病房',width:130}, 
		{field:'PAAdmBed',title:'床位号',width:70},
        {field:'DischargeDate',title:'出院日期',width:100},
		{field:'Diagnosis',title:'诊断',width:250},
		{field:'TPoliticalLevel',title:'患者级别',width:80,hidden:true},
		{field:'TSecretLevel',title:'患者密级',width:100,align:'center',hidden:true}
    ]]
    
	var toolbar =[	
					
		] 
	var DataGrid = $HUI.datagrid("#AdmList", {
		fit : true,
		striped : true,
		nowrap:false,
		border:false,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.BS.Adm",
			QueryName : "FindDocCurrentAdm",
			PatientID:ServerObj.PatientID
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		toolbar:toolbar,
		columns :columns

	});
	
	PLObject.m_AdmGrid = DataGrid;
}


function BAdmOrdInfo(Ord){
	
}

function BLInfo (EpisodeID) {
	
	//var lnk= "emr.record.browse.csp?"+"EpisodeID="+EpisodeID;
	
	var lnk= "websys.chartbook.hisui.csp?"+"EpisodeID="+EpisodeID;
	lnk = lnk +"&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse"
	
	websys_showModal({
		url:lnk,
		iconCls: 'icon-w-list',
		title:'病历浏览',
		width:$(window).width()-100,height:$(window).height()-100
	})
	return false;
}