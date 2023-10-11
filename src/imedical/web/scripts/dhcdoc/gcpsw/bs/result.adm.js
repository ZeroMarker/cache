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
		{field:'PAPMINO',title:'�ǼǺ�',width:100},
		{field:'PAPMIName',title:'����',width:80,
			formatter: function(value,row,index){
				var btn = '<a style="cursor:pointer;" onclick="BLInfo(\'' + row["EpisodeID"] + '\')">'+value+'</a>';
				return btn;
			}
		},
		{field:'PAPMIDOB',title:'��������',width:100},
		{field:'PAPMISex',title:'�Ա�',width:70},
		{field:'PAAdmReason',title:'��������',width:70},
		{field:'PAAdmDate',title:'��������',width:100,order:'asc'},
		{field:'PAAdmTime',title:'����ʱ��',width:110},
		{field:'IconProfile',title:'ͼ��˵�',width:110,hidden:true},
		{field:'Ord',title:'ҽ��',width:70,align:'center',hidden:true,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BAdmOrdInfo(\'' + row["Ord"] + '\')"><img src="../images/websys/update.gif"></a>';
				return btn;
			}
		},
		{field:'PAAdmDepCodeDR',title:'�������',width:120},
		{field:'PAAdmDocCodeDR',title:'ҽ��',width:110},
		{field:'PAAdmNo',title:'�����',width:120},
		{field:'PAAdmType',title:'��������',width:80}, 
		{field:'PAAdmStatus',title:'����״̬',width:80},
		{field:'Hospital',title:'ҽԺ',width:190}, 
		{field:'PAAdmWard',title:'����',width:130}, 
		{field:'PAAdmBed',title:'��λ��',width:70},
        {field:'DischargeDate',title:'��Ժ����',width:100},
		{field:'Diagnosis',title:'���',width:250},
		{field:'TPoliticalLevel',title:'���߼���',width:80,hidden:true},
		{field:'TSecretLevel',title:'�����ܼ�',width:100,align:'center',hidden:true}
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
		title:'�������',
		width:$(window).width()-100,height:$(window).height()-100
	})
	return false;
}