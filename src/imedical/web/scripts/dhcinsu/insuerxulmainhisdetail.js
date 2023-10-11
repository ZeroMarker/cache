/**
 * FileName: dhcinsu/insuerxulmainhisdetail.js
 * Anchor: 
 * Date: 20220621
 * Description: ���Ӵ����ϴ�  ������ϸ����
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
�1�3
$(document).ready(function () {
	initChargeDtlList();
	initQueryMenu();
});

function initQueryMenu() {
	var url = window.location.href
	//var PrescNo=url.split("PrescNo=")[1].split("&")[0]
	//upt HanZH 20220629 ������ϸ��ѯ��������ҽ�����ͺ�Ժ��ָ��
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
					title: '����',
					field: 'PatName',
					align: 'center',
					width: 100
				}, {
					title: '�ǼǺ�',
					field: 'PatRegNo',
					align: 'center',
					width: 100
				},{
					title: 'ҽ������',
					field: 'ArcimCode',
					align: 'center',
					width: 200
				},  {
					title: 'ҽ������',
					field: 'ArcimDesc',
					align: 'center',
					width: 280
				},  {
					title: 'ҽ����Ŀ����',
					field: 'TarItemInsuCode',
					align: 'center',
					width: 250
				},  {
					title: 'ҽ��״̬',
					field: 'OEORIItemStatDesc',
					align: 'center',
					width: 80
				},  {
					title: '������',
					field: 'PrescNo',
					align: 'center',
					width: 120
				}, {
					title: '����ҽ������',
					field: 'ResDocName',
					align: 'center',
					width: 100
				}, {
					title: '����ʱ��',
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



