/**
 * FileName: dhcinsu/insuerxulmainhisdetail.js
 * Anchor: 
 * Date: 20220621
 * Description: 电子处方上传  处方明细界面
 */
var DateFlag=0
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	}
}
﻿
$(document).ready(function () {
	initChargeDtlList();
	initQueryMenu();
});

function initQueryMenu() {
	var url = window.location.href
	//var PrescNo=url.split("PrescNo=")[1].split("&")[0]
	//upt HanZH 20220629 处方明细查询新增参数医保类型和院区指针
	var InputStr=url.split("=")
	var PrescNo=InputStr[1].split("&")[0];
	var InsuType=InputStr[2].split("&")[0];
	var HospDr=InputStr[3].split("&")[0];
	
	var queryParams = {
		ClassName: 'web.INSUELECRXUPLD',
		QueryName: 'GetPrescNoDetailInfo',
		PrescNo: PrescNo,
		InsuType: InsuType,
		HospDr: HospDr	
	};
	loadDataGridStore('mainHisDtlList', queryParams);
}


function initChargeDtlList() {
	$HUI.datagrid('#mainHisDtlList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		frozenColumns: [[
			]],
		columns: [[{
					title: '姓名',
					field: 'PatName',
					align: 'center',
					width: 100
				}, {
					title: '登记号',
					field: 'PatRegNo',
					align: 'center',
					width: 100
				},{
					title: '医嘱代码',
					field: 'ArcimCode',
					align: 'center',
					width: 200
				},  {
					title: '医嘱名称',
					field: 'ArcimDesc',
					align: 'center',
					width: 280
				},  {
					title: '医保项目编码',
					field: 'TarItemInsuCode',
					align: 'center',
					width: 250
				},  {
					title: '医嘱状态',
					field: 'OEORIItemStatDesc',
					align: 'center',
					width: 80
				},  {
					title: '处方号',
					field: 'PrescNo',
					align: 'center',
					width: 120
				}, {
					title: '开单医生姓名',
					field: 'ResDocName',
					align: 'center',
					width: 100
				}, {
					title: '开单时间',
					field: 'OrdDate',
					align: 'center',
					width: 100
				}	
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}



