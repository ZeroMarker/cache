/**
 * FileName: insueprchangedtl.js
 * Description: 变更记录
 */
 var PageLogicObj={
	m_OPSpecilDiagDataGrid:""
}

$(function(){
	//初始化
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
					title: '段落代码',
					field: 'keydata',
					align: 'center',
					width: 90
				}, {
					title: '段落名',
					field: 'keydatadesc',
					align: 'center',
					width: 100
				},{
					title: '字段代码',
					field: 'keycode',
					align: 'center',
					width: 120
				}, {
					title: '字段名',
					field: 'keycodedesc',
					align: 'center',
					width: 120
				}, {
					title: '行号',
					field: 'xh',
					align: 'center',
					width: 50
				}, {
					title: 'his内容',
					field: 'keyvalueA',
					align: 'center',
					width: 140
				}
				, {
					title: '上传内容',
					field: 'keyvalueB',
					align: 'center',
					width: 140
				}, {
					title: '变更内容',
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