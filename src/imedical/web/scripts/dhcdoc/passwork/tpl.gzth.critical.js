/*
 * @Author: qiupeng
 * @Date: 2022-10-24 15:21:31
 * @LastEditors: qiupeng
 * @LastEditTime: 2022-10-24 15:42:23
 * @FilePath: \gcpbc\test\my.js
 * @Description: 
 * 
 * Copyright (c) 2022 by qiupeng, All Rights Reserved. 
 */
var PageLogicObj = {
	m_ItemGrid:"",
	m_SelfSwitch:""
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})

function Init(){
    TPL.initFillFlagCombox();
	PageLogicObj.m_SelfSwitch = TPL.initSwitch();
	InitItemGrid("ItemGrid");
}

function InitEvent () {
	$("#Find").click(TPL.FindGrid)
	$("#BAdd").click(TPL.BAddHandler)
	$("#BEdit").click(TPL.BEditHandler)
	$("#BContent").click(function (){TPL.BContentHandler({
		width:950,
		height:710,
		url:"dhcdoc.passwork.tpl.gzth.critical.edit.csp"
	
	})})
	document.onkeydown = TPL.DocumentOnKeyDown;
}

function PageHandle() {
	if (ServerObj.NID=="") {
		TPL.setTypeButton("init")
	}	
}
/**
 * @name: qp
 * @date: 2022-10-24
 * @description: ��ʼ����ϸ���
 * @param {*} id
 * @return {*}
 */
function InitItemGrid (id) {
	var columns = [[
		{field:'SID',title:'SID',width:100,hidden:true},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true},
		{field:'FillFlag',title:'��д��־',width:100,
			formatter: function(value,row,index){
				var mRtn = '';
				if (value==1) {
					mRtn = $g("����д")
				} else if (value==2) {
					mRtn =  $g("δ��д")
				} else if(value==0) {
					mRtn = $g("δ����")
				}
				return mRtn;
			},
			styler: function(value,row,index){
				if (value == 0){
					return 'background-color:#FF9C00;color:#fff;';
				} else if (value == 1) {
					return 'background-color:#21ba45;color:#fff;';
				} else if (value == 2) {
					return 'background-color:#f16e57;color:#fff;';
				} else {}
			}
		},
		{field:'PType',title:'����',width:100},
		{field:'PatName',title:'��������',width:100},
		//{field:'PatNo',title:'�ǼǺ�',width:100},
		//{field:'PatSex',title:'�Ա�',width:100},
		//{field:'PatAge',title:'����',width:100},
		//{field:'AdmDocDesc',title:'����ҽ��',width:100},
		//{field:'PatDiagnos',title:'���',width:200},
		//{field:'PatOperName',title:'����',width:200},
		{field:'PatMedicareNo',title:'סԺ��',width:100},
        {field:'CurBedCode',title:'����',width:100},
        {field:'EQuestion',title:'Ŀǰ�ٴ�����',width:200},
        {field:'EMainAction',title:'��Ҫ���ô�ʩ',width:200},
        {field:'SubmitContent',title:'��������',width:250},
        {field:'AcceptContent',title:'�Ӱ�����',width:250}
        //{field:'PatMedicareNo',title:'סԺ��',width:100}
    ]]
	var DurDataGrid = $HUI.datagrid("#"+id, {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		view:scrollview,
		//autoRowHeight : false,
		pagination : false,
		pageSize:1000,  
		idField:"SID",
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.BS.NSub",
			QueryName : "ItemSubQry",
			NID:ServerObj.NID,
			BCDate:ServerObj.BCDate,
			LocId:session['LOGON.CTLOCID'],
			UserId:session['LOGON.USERID'],
			InBCCode:ServerObj.BCCode,
			InPType:ServerObj.PType
		},
		detailFormatter:function(rowIndex, rowData){
			var result=""
			if (rowData.EQuestion!="") {
				result="<div style='padding:5px 0px;'><label style='font-weight:bold;'>"+$g("Ŀǰ�ٴ�����")+"��</label>"+rowData.EQuestion+"</div>"
			}
			if (rowData.EMainAction!="") {
				result=result+"<div style='padding:5px 0px;'><label style='font-weight:bold;'>"+$g("��Ҫ���ô�ʩ")+"��</label>"+rowData.EMainAction+"</div>"
			}
			if (rowData.SubmitContent!="") {
				result=result+"<div style='padding:5px 0px;'><label style='font-weight:bold;'>"+$g("��������")+"��</label>"+rowData.SubmitContent+"</div>"
			}
			if (rowData.AcceptContent!="") {
				result=result+"<div style='padding:5px 0px;'><label style='font-weight:bold;'>"+$g("�Ӱ�����")+"��</label>"+rowData.AcceptContent+"</div>"
			}
			if (result=="") {
				result="<div style='padding:10px 0px;'><label style='color:red;'>"+$g("����дĿǰ�ٴ����⡢��Ҫ���ô�ʩ���������ݡ��Ӱ����ݣ�")+"<label></div>"
			}
			return result;
		},
		onUnselect:function(){
		},
		toolbar:[{
				text:'����',
				id:'BAdd',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'BEdit',
				iconCls: 'icon-write-order'
            },{
				text:'��д��������',
				id:'BContent',
				iconCls: 'icon-write-order'
            }
		],
		columns :columns
	});
	
	PageLogicObj.m_ItemGrid =  DurDataGrid;
	return false;
}

