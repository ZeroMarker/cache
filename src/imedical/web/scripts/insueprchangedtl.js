/**
 * FileName: insueprchangedtl.js
 * Description: �����¼
 */
 var PageLogicObj={
	m_OPSpecilDiagDataGrid:""
}

$(function(){
	//��ʼ��
	Init();	
})

function Init(){
	PageLogicObj.m_OPSpecilDiagDataGrid=initEprchangedtl();
	var url = window.location.href
	var Rowid=url.split("Rowid=")[1]
	$("#Eprchangedtl").datagrid({ url: $URL+"?ClassName=web.DHCINSUEprUl&MethodName=CompareJson", queryParams:{Eid:Rowid}});
}

function initEprchangedtl() {
	$HUI.datagrid('#Eprchangedtl', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20,30,40,50],
		data: [],
		columns: [[{
					title: '�������',
					field: 'keydata',
					align: 'center',
					width: 90
				}, {
					title: '������',
					field: 'keydatadesc',
					align: 'center',
					width: 100
				},{
					title: '�ֶδ���',
					field: 'keycode',
					align: 'center',
					width: 120
				}, {
					title: '�ֶ���',
					field: 'keycodedesc',
					align: 'center',
					width: 120
				}, {
					title: '�к�',
					field: 'xh',
					align: 'center',
					width: 50
				}, {
					title: 'his����',
					field: 'keyvalueA',
					align: 'center',
					width: 140
				}
				, {
					title: '�ϴ�����',
					field: 'keyvalueB',
					align: 'center',
					width: 140
				}, {
					title: '�������',
					field: 'type',
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