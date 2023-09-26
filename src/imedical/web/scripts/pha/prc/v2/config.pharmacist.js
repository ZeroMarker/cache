/**
 * ����:	 ��������-����ҩʦά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-06
 */
PHA_COM.App.Csp = "pha.prc.v2.config.pharmacist.csp";
PHA_COM.App.Name = "PRC.Config.Pharmacist";
PHA_COM.App.Load = "";
$(function () {
	InitDict();
	InitGridPharmacist();
	InitEvents();
});

// �¼�
function InitEvents() {
	$("#btnAdd").on("click", AddPha);
	$("#btnEdit").on("click", EditPha);
	$("#btnDel").on("click", ComfirmDel);
}

// �ֵ�
function InitDict() {
	// ��ʼ��ҩʦ����
	PHA.ComboBox("conPharmacist", {
		url: PHA_STORE.Pharmacist().url
	});
	// ��ʼ��ҩʦ����
	PHA.ComboBox("conLevel", {
		data: [{
			RowId: "A",
			Description: "���"
		}, {
			RowId: "C",
			Description: "����"
		}],
		panelHeight: "auto"
	});
		
}

// ���-����ҩʦά��
function InitGridPharmacist() {
    var columns = [
        [
            { field: "phaId", title: 'ҩʦ���', width: 120 },
			{ field: "phaUserId", title: 'UserId', width: 120 ,hidden: true},
            { field: "phaCode", title: 'ҩʦ����',width: 120 },
            { field: 'phaDesc', title: 'ҩʦ����', width: 200},
            { field: 'phaLevelCode', title: 'ҩʦ�������', width: 200,hidden: true },
            { field: 'phaLevel', title: 'ҩʦ����', width: 200},		
            { field: 'phaGroup', title: 'ҩʦ����', width: 200}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Pharmacist',
            QueryName: 'SelectPharmacist'
        },
        columns: columns,
        toolbar: "#gridPharmacistBar",
        onClickRow:function(rowIndex,rowData){
			if (rowData){			
				var phaId=rowData.phaId;
				var phaUserId=rowData.phaUserId;
				var phaDesc=rowData.phaDesc;
				var phaGroup=rowData.phaGroup;
				var phaLevelCode=rowData.phaLevelCode;
				var phaLevel=rowData.phaLevel;

				$("#conPharmacist").combobox('setValue', phaUserId); 				
			    $("#conPharmacist").combobox('setText', phaDesc);
			    $("#conLevel").combobox('setValue', phaLevelCode);        
			    $("#conLevel").combobox('setText', phaLevel);
			    $("#conGrp").val(phaGroup);
			}
			
		}   
    };
	PHA.Grid("gridPharmacist", dataGridOption);
}
//��������ҩʦ
function AddPha(){
	var phaUserId = $("#conPharmacist").combobox('getValue');
	if (phaUserId == "") {
		PHA.Popover({
			msg: "����ѡ��ҩʦ���ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var phaLevel = $("#conLevel").combobox('getValue');
	var phaGroup = $("#conGrp").val();
	var OtherStr = phaUserId + "^" + phaLevel + "^" + phaGroup
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Pharmacist',
		MethodName: 'SaveComPha',
		phaId: '',
		OtherStr: OtherStr,
		logonLoc: session['LOGON.CTLOCID'],
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
		ClearPha();
	}
}
//�޸ĵ���ҩʦ��Ϣ
function EditPha(){
	var gridSelect = $('#gridPharmacist').datagrid('getSelected')|| "";
		if (gridSelect == "") {
			PHA.Popover({
				msg: "��ѡ����Ҫ�޸ĵĵ���ҩʦ",
				type: "alert"
			});
			return;
		}
	var phaId = gridSelect.phaId ;
	var phaUserId = $("#conPharmacist").combobox('getValue');
	if (phaUserId == "") {
		PHA.Popover({
			msg: "����ѡ��ҩʦ���ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var phaLevel = $("#conLevel").combobox('getValue');
	var phaGroup = $("#conGrp").val();
	var OtherStr = phaUserId + "^" + phaLevel + "^" + phaGroup
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Pharmacist',
		MethodName: 'SaveComPha',
		phaId: phaId,
		OtherStr: OtherStr,
		logonLoc: session['LOGON.CTLOCID'],
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '�޸ĳɹ�',
			type: 'success'
		});
		ClearPha();
	}
}

function ComfirmDel(){
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		DelPha();
	})
}
//ɾ������ҩʦ
function DelPha(){
	var gridSelect = $('#gridPharmacist').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "����ѡ����Ҫɾ���ĵ���ҩʦ",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var phaId = gridSelect.phaId ;
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Pharmacist',
		MethodName: 'DelComPha',
		phaId: phaId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: 'ɾ���ɹ�',
			type: 'success'
		});
		ClearPha();
	}
	
}
//���
function ClearPha(){
	$("#conPharmacist").combobox("setValue",'');
	$("#conPharmacist").combobox("setText", '');
	$("#conLevel").combobox("setValue",'');
	$("#conLevel").combobox("setText", '');
	$("#conGrp").val('');
	$("#gridPharmacist").datagrid("reload");
	
}





