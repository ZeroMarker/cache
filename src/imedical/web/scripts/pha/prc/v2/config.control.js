/**
 * ����:	 ��������-�������Ʒ���ά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.control.csp";
PHA_COM.App.Name = "PRC.ConFig.Control";
PHA_COM.App.Load = "";
var hospId = PHA_COM.Session.HOSPID;
$(function () {
	InitGridPoison();
    InitGridControl();
    InitEvents();
    InitHospCombo();
});

function InitEvents(){
	$("#btnAdd").on("click", AddControlByBat);
	$("#btnDel").on("click", DelControlBtBat);	
}

// ���-���Ʒ���ά��
function InitGridPoison() {
    var columns = [
        [
            { field: "poisonId", title: 'poisonRowId',  width: 100,hidden: true },
            { field: "poisonCheck", title: 'ѡ��', checkbox:'true',align:'center',width:30 },
            { field: "poisonCode", title: '����',width: 120 },
            { field: 'poisonDesc', title: '����', width: 300 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Control',
            QueryName: 'SelectPoison',
            hospID: hospId
        },
        columns: columns,
        pagination: false,
        singleSelect:false,
        toolbar: "#gridPoisonBar",
        onDblClickRow:function(rowIndex,rowData){
	        var poisonId = rowData.poisonId;
	        AddControl('',poisonId);
		}   
		
    };
    PHA.Grid("gridPoison", dataGridOption);
}

// ���-��ά������
function InitGridControl() {
    var columns = [
        [
            { field: "ctrlId", title: 'ctrlRowId',  width: 100,hidden: true },
            { field: "ctrCheck", title: 'ѡ��', checkbox:'true',align:'center',width:30 },
            { field: "ctrlCode", title: '����',width: 120 },
            { field: "ctrlDesc", title: '����',width: 300 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Control',
            QueryName: 'SelectControl',
            hospID: hospId
        },
        columns: columns,
        pagination: false,
        singleSelect:false,
        toolbar: "#gridControlBar",
        onDblClickRow:function(rowIndex,rowData){
	        var ctrlId = rowData.ctrlId;
			var delInfo = "��ȷ��ɾ����?"
			PHA.Confirm("ɾ����ʾ", delInfo, function () {
				DeleteControl(ctrlId);
			})	        
		}   
    };
    PHA.Grid("gridControl", dataGridOption);
}

/// �������ӹ��Ʒ���
function AddControlByBat(){
	var rows = $('#gridPoison').datagrid('getSelections')
    if (rows.length == 0) {
	    $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫ���ӵĹ��Ʒ���", "warning");
        return;
    }
    var poisonIdStr=""
    for (var pnum = 0; pnum < rows.length; pnum++) {
        var poisonId = rows[pnum].poisonId;
        if (poisonIdStr==""){
	        poisonIdStr = poisonId
	    }else{
		    poisonIdStr = poisonIdStr + "^" + poisonId
		}
	    
    }

    var saveBatRet = tkMakeServerCall("PHA.PRC.ConFig.Control", "SaveControlByBat", poisonIdStr, hospId);
    var saveBatArr = saveBatRet.split("^");
    var saveBatVal = saveBatArr[0];
    var saveBatInfo = saveBatArr[1];
    if (saveBatVal < 0) {
        $.messager.alert("��ʾ", saveBatInfo, "warning");
    }
    else{
	    PHA.Popover({msg: "���ӳɹ�", type: "success"});
	}
	ReloadData();
}
	
function AddControl(ctrlId,poisonId) {
    var saveRet = tkMakeServerCall("PHA.PRC.ConFig.Control", "SaveComControl", ctrlId, poisonId, hospId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    else{
	    PHA.Popover({msg: "���ӳɹ�", type: "success"});
	}
    ReloadData();
}


/// ����ɾ�����Ʒ���
function DelControlBtBat(){
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		var rows = $('#gridControl').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫɾ���Ĺ��Ʒ���", "warning");
	        return;
	    }
	    var ctrlIdStr=""
	    for (var cnum = 0; cnum < rows.length; cnum++) {
	        var ctrlId = rows[cnum].ctrlId;
	        if (ctrlIdStr==""){
		        ctrlIdStr = ctrlId
		    }else{
			    ctrlIdStr = ctrlIdStr + "^" + ctrlId
			}
		    
	    }

	    var delBatRet = tkMakeServerCall("PHA.PRC.ConFig.Control", "DelControlByBat", ctrlIdStr, hospId);
	    var delBatArr = delBatRet.split("^");
	    var delBatVal = delBatArr[0];
	    var delBatInfo = delBatArr[1];
	    if (delBatVal < 0) {
	        $.messager.alert("��ʾ", delBatInfo, "warning");
	    }
	    else{
		    PHA.Popover({msg: "ɾ���ɹ�", type: "success"});
		}
	    ReloadData();
    })
}


function DeleteControl(ctrlId) {
    var deleteRet = tkMakeServerCall("PHA.PRC.ConFig.Control", "DelComControl", ctrlId, hospId);
    var deleteArr = deleteRet.split("^");
    var deleteVal = deleteArr[0];
    var deleteInfo = deleteArr[1];
    if (deleteVal < 0) {
        $.messager.alert("��ʾ", deleteInfo, "warning");
    }
    else{
	    PHA.Popover({msg: "ɾ���ɹ�", type: "success"});
	}
    ReloadData();
}

function ReloadData(){
	$('#gridControl').datagrid('query', {hospID: hospId}); 	
    $('#gridPoison').datagrid('query', {hospID: hospId}); 	
}

function InitHospCombo() {
	var genHospObj = PRC_STORE.AddHospCom({tableName: "DHC_PHCNTSCONTROL"});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
        	hospId = record.HOSPRowId;
            ReloadData();
        }
        hospId = genHospObj.getValue();
    }
}




