/**
 * 名称:	 处方点评-点评管制分类维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-07
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

// 表格-管制分类维护
function InitGridPoison() {
    var columns = [
        [
            { field: "poisonId", title: 'poisonRowId',  width: 100,hidden: true },
            { field: "poisonCheck", title: '选择', checkbox:'true',align:'center',width:30 },
            { field: "poisonCode", title: '代码',width: 120 },
            { field: 'poisonDesc', title: '描述', width: 300 }
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

// 表格-已维护级别
function InitGridControl() {
    var columns = [
        [
            { field: "ctrlId", title: 'ctrlRowId',  width: 100,hidden: true },
            { field: "ctrCheck", title: '选择', checkbox:'true',align:'center',width:30 },
            { field: "ctrlCode", title: '代码',width: 120 },
            { field: "ctrlDesc", title: '描述',width: 300 }
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
			var delInfo = "您确认删除吗?"
			PHA.Confirm("删除提示", delInfo, function () {
				DeleteControl(ctrlId);
			})	        
		}   
    };
    PHA.Grid("gridControl", dataGridOption);
}

/// 批量增加管制分类
function AddControlByBat(){
	var rows = $('#gridPoison').datagrid('getSelections')
    if (rows.length == 0) {
	    $.messager.alert("提示", "请先勾选需要增加的管制分类", "warning");
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
        $.messager.alert("提示", saveBatInfo, "warning");
    }
    else{
	    PHA.Popover({msg: "增加成功", type: "success"});
	}
	ReloadData();
}
	
function AddControl(ctrlId,poisonId) {
    var saveRet = tkMakeServerCall("PHA.PRC.ConFig.Control", "SaveComControl", ctrlId, poisonId, hospId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    else{
	    PHA.Popover({msg: "增加成功", type: "success"});
	}
    ReloadData();
}


/// 批量删除管制分类
function DelControlBtBat(){
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		var rows = $('#gridControl').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("提示", "请先勾选需要删除的管制分类", "warning");
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
	        $.messager.alert("提示", delBatInfo, "warning");
	    }
	    else{
		    PHA.Popover({msg: "删除成功", type: "success"});
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
        $.messager.alert("提示", deleteInfo, "warning");
    }
    else{
	    PHA.Popover({msg: "删除成功", type: "success"});
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




