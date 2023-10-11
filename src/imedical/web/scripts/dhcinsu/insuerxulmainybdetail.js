/**
 * FileName: dhcinsu/insuerxulmainybdetail.js
 * Anchor: 
 * Date: 20220621
 * Description: 电子处方上传 医保返回查询界面
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
//	var InterType=url.split("InterType=")[1].split("&")[0];
//	var hirxno=url.split("hirxno=")[1];
	//upt HanZH 20220629 医保返回结果查询界面查询新增参数医保类型和院区指针
	var InputStr=url.split("=")
	var InterType=InputStr[1].split("&")[0];
	var hirxno=InputStr[2].split("&")[0];
	var InsuType=InputStr[3].split("&")[0];
	var HospDr=InputStr[4].split("&")[0];
	
	var queryParams = {
		ClassName: 'web.INSUELECRXUPLD',
		QueryName: 'GetPrescNoybInfo',
		InterType: InterType,
		hirxno: hirxno,
		InsuType: InsuType,
		HospDr: HospDr	
	};
	loadDataGridStore('mainybDtlList', queryParams);
}


function initChargeDtlList() {
	$HUI.datagrid('#mainybDtlList', {
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
					title: '名称',
					field: 'valueDesc',
					align: 'center',
					width: 250
				}, {
					title: '结果列表',
					field: 'value',
					align: 'center',
					width: 450
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



