/**
 * 名称:	 处方点评-点评药师维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-06
 */
PHA_COM.App.Csp = "pha.prc.v2.config.pharmacist.csp";
PHA_COM.App.Name = "PRC.Config.Pharmacist";
PHA_COM.App.Load = "";
var hospId = PHA_COM.Session.HOSPID;
$(function () {
	InitDict();
	InitGridPharmacist();
	InitEvents();
	InitHospCombo();
});

// 事件
function InitEvents() {
	$("#btnAdd").on("click", AddPha);
	$("#btnEdit").on("click", EditPha);
	$("#btnDel").on("click", ComfirmDel);
}

// 字典
function InitDict() {
	// 初始化药师姓名
	PHA.ComboBox("conPharmacist", {
		url: PHA_STORE.Pharmacist().url
	});
	// 初始化药师级别
	PHA.ComboBox("conLevel", {
		data: [{
			RowId: "A",
			Description: $g("审核")
		}, {
			RowId: "C",
			Description: $g("点评")
		}],
		panelHeight: "auto"
	});
		
}

// 表格-点评药师维护
function InitGridPharmacist() {
    var columns = [
        [
            { field: "phaId", title: '药师序号', width: 120 },
			{ field: "phaUserId", title: 'UserId', width: 120 ,hidden: true},
            { field: "phaCode", title: '药师代码',width: 120 },
            { field: 'phaDesc', title: '药师姓名', width: 200},
            { field: 'phaLevelCode', title: '药师级别代码', width: 200,hidden: true },
            { field: 'phaLevel', title: '药师级别', width: 200},		
            { field: 'phaGroup', title: '药师分组', width: 200}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Pharmacist',
            QueryName: 'SelectPharmacist',
            hospID: hospId
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
//新增点评药师
function AddPha(){
	var phaUserId = $("#conPharmacist").combobox('getValue');
	if (phaUserId == "") {
		PHA.Popover({
			msg: "请先选择药师后再保存！",
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
		hospID: hospId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		ClearPha();
		$("#gridPharmacist").datagrid("reload");	
	}
}
//修改点评药师信息
function EditPha(){
	var gridSelect = $('#gridPharmacist').datagrid('getSelected')|| "";
		if (gridSelect == "") {
			PHA.Popover({
				msg: "请选择需要修改的点评药师",
				type: "alert"
			});
			return;
		}
	var phaId = gridSelect.phaId ;
	var phaUserId = $("#conPharmacist").combobox('getValue');
	if (phaUserId == "") {
		PHA.Popover({
			msg: "请先选择药师后再保存！",
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
		hospID: hospId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '修改成功',
			type: 'success'
		});
		ClearPha();
		$("#gridPharmacist").datagrid("reload");	
	}
}

function ComfirmDel(){
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		DelPha();
	})
}
//删除点评药师
function DelPha(){
	var gridSelect = $('#gridPharmacist').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请先选中需要删除的点评药师",
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
		hospID: hospId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '删除成功',
			type: 'success'
		});
		ClearPha();
		$("#gridPharmacist").datagrid("reload");	
	}
	
}
//清空
function ClearPha(){
	$("#conPharmacist").combobox("setValue",'');
	$("#conPharmacist").combobox("setText", '');
	$("#conLevel").combobox("setValue",'');
	$("#conLevel").combobox("setText", '');
	$("#conGrp").val('');
}

function InitHospCombo() {
	var genHospObj = GenHospComp('DHC_PHCNTSALLOTUSER');
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            hospId = newHospId;
            ClearPha();
            $('#conPharmacist').combobox('options').url = $URL + "?ResultSetType=Array&" + 'ClassName=PHA.STORE.Org&QueryName=Pharmacist&HospId=' + newHospId;
			$('#conPharmacist').combobox('reload');
			$('#gridPharmacist').datagrid('query', {hospID: newHospId});
        }
    }
}


