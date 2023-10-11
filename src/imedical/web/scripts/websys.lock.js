var dataGradId = "#lockLog",locId = "#inLocId";
var initLoc = function () {
	$(locId).lookup({
		width: 200, panelWidth: 350, panelHeight: 400,
		url: $URL,
		mode: 'remote',
		idField: 'CTLOCRowID',
		textField: 'CTLOCDesc',
		columns: [[
			{ field: 'CTLOCDesc', title: '��������', width: 150 },
			{ field: 'CTLOCCode', title: '���Ҵ���', width: 250 },
			{ field: 'CTLOCRowID', title: '����ID', width: 50, hidden: true }
		]],
		queryParams: {
			//"ClassName": "web.DHCBL.CT.CTLoc"
			//, "QueryName": "GetDataForCmb1"
			"ClassName": "BSP.SYS.BL.Lock"
			,"QueryName": "FindLoc"
			, "desc": ""
		},
		onBeforeLoad: function (param) {
			param.desc = param.q ? param.q : "";
		},
		pagination: true,
		showPageList:false,
		rownumbers: false,
		onSelect: function (index, rowData) {
			FindBtnClick();
			// console.log("index=" + index + ",rowData=", rowData);
		},
	});
	$(locId).lookup('setValue',inLocIdReq);
	$(locId).lookup('setText',locDescReq);
}
var initEpisodeID = function () {
	$("#EpisodeID").lookup({
		width: 200, panelWidth: 350, panelHeight: 400,
		url: $URL,
		mode: 'remote',
		idField: 'EpisodeID',
		textField: 'EpisodeDesc',
		columns: [[
			{ field: 'EpisodeDesc', title: '����', width: 100 },
			{ field: 'EpisodeRegNo', title: '�ǼǺ�', width: 100 },
			{ field: 'EpisodeID', hidden: true }
		]],
		queryParams: {
			ClassName:"BSP.SYS.BL.Lock"
			,QueryName:"FindEpisode"
			,desc: ""
		},
		onBeforeLoad: function (param) {
			param.desc = param.q ? param.q : "";
		},
		onSelect: function (index, rowData) {
			$("#EpisodeID").lookup('setValue',rowData['EpisodeID']);
			FindBtnClick();
		},
		showPageList:false,
		pagination: true
	});
	$("#EpisodeID").lookup('setValue',EpisodeIDReq);
	$("#EpisodeID").lookup('setText',EpisodeDesc);
}
var createDataGrid = function () {
	$(dataGradId).datagrid({
		fit: true,
		className:"BSP.SYS.BL.Lock",
		queryName:'Find',
		url:$URL,
		singleSelect: true,
		autoSizeColumn: true,
		fitColumns: true,
		headerCls: 'panel-header-gray',
		bodyCls: 'panel-body-gray',
		border: false,
		iconCls: 'icon-paper',
		rownumbers: false,
		defaultsColumns:[
			{field:'UserDR',hidden:true},
			{field:'LoginLocation',hidden:true},
			{field:'Id',hidden:true}
		],
		onColumnsLoad : function(cm){
			/*for (var i=0;i<cm.length;i++){
				if(cm[i]['field']=="UserDR" || cm[i]['field']=="LoginLocation"|| cm[i]['field']=="Id"){
					cm[i].hidden = true;
				}
			}*/
			cm.push({
				field: 'deleteRow', title: 'ɾ������',width:100,
				formatter: function (val, row, index) {
					return '<a href="javascript:void(0)" onclick="deleteRow(' + index + ')">ɾ��</a>';
				}
			});
		},
		onBeforeLoad: function (param) {
			param.ClassName = "BSP.SYS.BL.Lock";
			param.QueryName = "Find";
			param.inLocId = $(locId).lookup("getValue");
			param.EpisodeID = $("#EpisodeID").lookup('getValue');
		}
	});
}
/*
* Ĭ����ɾ�Ļص�
* ��ʾmsg�����ɹ���ʧ�ܡ���̨dto����json����gridId����,ˢ��gridId���
*/
var defaultCallBack = function (rtn) {
	if (rtn.success == 1) {
		FindBtnClick();
		$.messager.popover({ msg: rtn.msg, type: 'success' });
	} else {
		$.messager.popover({ msg: rtn.msg, type: 'error' });
	}
}
function deleteRow(index) {
	var row = $(dataGradId).datagrid("getRows")[index];
	$.messager.confirm("ɾ��", "ȷ��ɾ����" + row.UserDR + "��������¼?", function (r) {
		if (r) {
			$cm({
				ClassName: "websys.Lock",
				MethodName: "LockClear2",
				classId1: row.Id,
				className1: row.ClassName,
				sessionid: row.SessionId,
			}, defaultCallBack);
		}
	});
}
$('#ClearBtn').click(function () {
	if (ChangeCondition==0){return false;}
	$('#EpisodeID').lookup("setValue", "");
	$('#EpisodeID').lookup("setText", "");
	$(locId).lookup("setValue", "");
	$(locId).lookup("setText", "");
	FindBtnClick();
})
function FindBtnClick() {
	if (!$(locId).lookup("getText")) {
		$(locId).lookup("setValue", "");
	}
	if (!$("#EpisodeID").lookup("getText")) {
		$('#EpisodeID').lookup("setValue", "");
	}
	$('#lockLog').datagrid('reload');
}
function bindEnterQuery(id, queryFunction) {
	$('#' + id).keypress(function (event) {
		if (event.keyCode == "13") {
			queryFunction();
		}
	});
}
function init() {
	initLoc();
	initEpisodeID();
	createDataGrid();
	// bindEnterQuery("inLocId", FindBtnClick); // �����󶨲��ˡ�
	// bindEnterQuery("EpisodeID", FindBtnClick);
	if (ChangeCondition==="0"){
		$(locId).lookup("disable");
		$("#EpisodeID").lookup("disable");
	}
	$('#FindBtn').click(FindBtnClick);
	FindBtnClick();
}
$(init);