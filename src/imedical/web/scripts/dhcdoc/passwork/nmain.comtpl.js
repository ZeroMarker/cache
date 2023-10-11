/*
 * @Author: qiupeng
 * @Date: 2022-10-24 15:21:31
 * @LastEditors: qiupeng
 * @LastEditTime: 2022-10-24 15:30:43
 * @FilePath: \gcpbc\passwork\nmain.comtpl.js
 * @Description: 公共模版
 * 
 * Copyright (c) 2022 by qiupeng, All Rights Reserved. 
 */
var PageLogicObj = {
	m_ItemGrid:"",
	m_SelfSwitch:"",
    MainSreenFlag:websys_getAppScreenIndex()
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
		height:500,
		url:"dhcdoc.passwork.nmain.comtpl.edit.csp"
	
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
 * @description: 初始化明细表格
 * @param {*} id
 * @return {*}
 */
function InitItemGrid (id) {
	var columns = [[
		{field:'SID',title:'SID',width:100,hidden:true},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true},
		{field:'FillFlag',title:'填写标志',width:100,
			formatter: function(value,row,index){
				var mRtn = '';
				if (value==1) {
					mRtn = $g("已填写")
				} else if (value==2) {
					mRtn =  $g("未填写")
				} else if(value==0) {
					mRtn = $g("未保存")
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
		{field:'PType',title:'类型',width:100},
		{field:'PatName',title:'病人姓名',width:100},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatSex',title:'性别',width:100},
		{field:'PatAge',title:'年龄',width:100},
		{field:'AdmDocDesc',title:'主治医生',width:100},
		{field:'PatDiagnos',title:'诊断',width:200},
		{field:'PatOperName',title:'手术',width:200},
		{field:'PatMedicareNo',title:'住院号',width:100},
        {field:'CurBedCode',title:'床号',width:100},
        {field:'SubmitContent',title:'交班内容',width:250},
         {field:'AcceptContent',title:'接班内容',width:250}
        //{field:'PatMedicareNo',title:'住院号',width:100}
    ]]
	var DurDataGrid = $HUI.datagrid("#"+id, {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		idField:"SID",
		pagination : false,  
		view:scrollview,
		pageSize:1000,
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
			if (rowData.SubmitContent!="") {
				result="<div style='padding:10px 0px;'><label style='font-weight:bold;'>"+$g("交班内容")+"：</label>"+rowData.SubmitContent
			}
			if (rowData.AcceptContent!="") {
				result=result+"<div style='padding:5px 0px;'><label style='font-weight:bold;'>"+$g("接班内容")+"：</label>"+rowData.AcceptContent+"</div>"
			}
			if (result=="") {
				result="<div style='padding:10px 0px;'><label style='color:red;'>"+$g("请填写交班内容、接班内容！")+"<label></div>"
			}
			return result;
		},
		onUnselect:function(){
		},
		toolbar:[{
				text:'新增',
				id:'BAdd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'BEdit',
				iconCls: 'icon-write-order'
            },{
				text:'填写交班内容',
				id:'BContent',
				iconCls: 'icon-write-order'
            }
		],
		columns :columns,
        onSelect:function(index,row){
			var Obj={PatientID:row.PatientID,EpisodeID:row.EpisodeID};
			ShowSecondeWin("onOpenDHCEMRbrowse",Obj);
		}
	});
	
	PageLogicObj.m_ItemGrid =  DurDataGrid;
	return false;
}

//双屏应用
function ShowSecondeWin(Flag,Obj){
	if (PageLogicObj.MainSreenFlag==0){
        if (Flag=="onOpenDHCEMRbrowse"){
            var JsonStr=$.m({
                ClassName:"DHCDoc.Util.Base",
                MethodName:"GetMenuInfoByName",
                MenuCode:"DHC.Seconde.DHCEMRbrowse"
            },false)
            if (JsonStr=="{}") return false;
            var JsonObj=JSON.parse(JsonStr);
            $.extend(Obj,JsonObj);
        }
        websys_emit(Flag,Obj);
    }
}
