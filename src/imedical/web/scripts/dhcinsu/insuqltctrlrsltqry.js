/**
 * FileName: dhcinsu/insuqltctrlrsltqry.js
 * Anchor: HanZH
 * Date: 20230303
 * Description: 质控结果查询
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

$(document).ready(function () {
	initChargeDtlList();
	initQueryMenu();
});
function initQueryMenu() {
	var url = window.location.href;
	var InputStr=url.split("=");
	
	var SetlYm = InputStr[1].split("&")[0];
	var SetlId =InputStr[2].split("&")[0];
	var PsnNo = InputStr[3].split("&")[0];
	var ErrLv = InputStr[4].split("&")[0];
	var RetnFlag = InputStr[5].split("&")[0];
	var PageNum = InputStr[6].split("&")[0];
	var PageSize = InputStr[7].split("&")[0];
	var InputInfo="00A^4104^2^"+PUBLIC_CONSTANT.SESSION.GUSER_ROWID+"^0^102^"+SetlYm+"^"+SetlId+"^"+PsnNo+"^"+ErrLv+"^"+RetnFlag+"^"+PageNum+"^"+PageSize;
	var Rtn = tkMakeServerCall("INSU.OFFBIZ.BL.BIZ00A", "Insu4104Query", Param, "STR", "JSON");

	var queryParams = {
		ClassName: 'INSU.OFFBIZ.BL.BIZ00A',
		QueryName: 'Insu4104Query',
		InputInfo: InputInfo,
		InArgType: "STR",
		OutArgType: "JSON"	
	};
	loadDataGridStore('mainHisDtlList', queryParams);
}


function initChargeDtlList() {
	$HUI.datagrid('#qltctrlrsltList', {
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
		columns:[[
				{ field: 'papno', title: '登记号', sortable: true, width: 100 },
				{ field: 'medNo', title: '住院号', sortable: true, width: 100 },
				{ field: 'psnno', title: '人员编号', sortable: true, width: 200 },
				{ field: 'psncerttype', title: '证件类型', sortable: true, width: 80 },
				{ field: 'certno', title: '证件号码', sortable: true, width: 170 },
				{ field: 'psnname', title: '人员姓名', sortable: true, width: 80 },
				{ field: 'qltctrlver', title: '质控版本号', sortable: true, width: 90 },
				{ field: 'suberrlv', title: '错误等级', sortable: true, width: 80 },
				{ field: 'qltctrlrslt', title: '质控结果', sortable: true, width: 80 },
				{ field: 'examdatafld', title: '检查数据字段', sortable: true, width: 100 },
				{ field: 'qltctrlchkrslt', title: '质控校验结果', sortable: true, width: 250},
				{ field: 'retnflag', title: '回退标志', sortable: true, width: 80 },
				{ field: 'initval', title: '初始值', sortable: true, width: 80 },
				{ field: 'setlid', title: '结算ID', sortable: true, width: 200 },
				{ field: 'setlym', title: '结算年月', sortable: true, width: 80 },
				{ field: 'fixmedinscode', title: '机构编号', sortable: true, width: 120 },
				{ field: 'fixmedinsname', title: '机构名称', sortable: true, width: 150 }	
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



