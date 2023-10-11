/**
 * 名称:	 草药房管理-处方拒发原因维护
 * 编写人:	 MaYuqiang
 * 编写日期: 2022-01-12
 */
PHA_COM.App.Csp = "pha.herb.v2.config.refusereason.csp";
PHA_COM.App.Name = "HERB.Config.RefuseReason";
PHA_COM.App.Load = "";
var HospId = session['LOGON.HOSPID'];	//PHA_COM.Session.HOSPID;
$(function () {
	if (RefuseWayID == "") {
        $.messager.alert("提示","处方拒发类型尚未维护,请联系信息人员添加", "warning");
        return;
    }
	InitDict();
	InitEvents();
    InitGridReason();
    LoadTreeGridReason();
    InitHospCombo();
	Clear();
});

// 字典
function InitDict() {
	PHA.Tree("treeGridReason",{
		lines: false,
		onSelect: function (node) {
			Clear();
			$("#gridReason").datagrid("query", {
				Params: RefuseWayID +"^"+ node.id ,
				HospId: HospId
			});			
		},
		onLoadSuccess: function(node, data){
			$("#gridReason").datagrid("clear");
			if(data.length === 0){
				return;	
			}
			var node = $(this).tree('getRoot');
			$(this).tree('select', node.target);
		}
	});
	$('#search-form').searchbox({
		width: 350,
		searcher: function(e){
			LoadTreeGridReason();	
		}	
	});
}

// 事件
function InitEvents() {
	$("#btnAdd").on("click", AddReason);
	$("#btnEdit").on("click", EditReason);
	$("#btnDel").on("click", ComfirmDel);
}

function LoadTreeGridReason() {
	var desc = $HUI.searchbox('#search-form').getValue();	
	$.cm({
		ClassName: 'PHA.HERB.Reason.Query',
		MethodName: 'GetReasonTreeStore',
		Params: RefuseWayID + "^"+ desc,
		HospId: HospId
	},function(data){
		$('#treeGridReason').tree('loadData', data);
	});
}

function InitGridReason() {
    var columns = [
        [
            { 
            	field: "reasonId", 
            	title: '原因Id', 
            	width: 100, 
            	hidden: true 
            },
            {
                field: 'reasonCode',
                title: '原因代码',
                width: 100,
                sortable: 'true',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'reasonDesc',
                title: '原因描述',
                width: 200,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            { 
            	field: "activeFlag", 
            	title: '是否启用',
				width: 40
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.HERB.Reason.Query',
            QueryName: 'QueryReason',
            Params: RefuseWayID +"^"+ "",
            HospId: HospId
        },
        columns: columns,
        pagination: true,
        fitColumns: true,
        nowrap: false,
        toolbar: "#gridReasonBar",
        onClickRow: function(rowIndex, rowData) {
	        var code = rowData.reasonCode ;
			var desc = rowData.reasonDesc ;
			var reaId = rowData.reasonId ;
			var activeFlag = rowData.activeFlag ;
			if((activeFlag == "是")||(activeFlag =="Y")) {activeFlag = true;}
			else{ activeFlag = false;}
			$("#conCode").val(code);
			$("#conDesc").val(desc);
			$("#activeFlag").checkbox("setValue",activeFlag);
        },
	    onBeforeLoad: function (param) {
		    if(param.Params){
				return true;    
			}
			return false;
        }
    };
    PHA.Grid("gridReason", dataGridOption);
}


function AddReason(){
	var reasonCode = $("#conCode").val();
	var reasonDesc = $("#conDesc").val();
	if ((reasonCode=="")||(reasonDesc == "")) {
		PHA.Popover({
			msg: "请填写拒发原因代码和描述后再保存！",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var selectedNode = $('#treeGridReason').tree('getSelected');
	if(selectedNode === null){
		PHA.Popover({
			msg: "请在左侧选中需要添加明细的原因等级！",
			type: "alert",
			timeout: 1000
		});
		return;	
	}
	var reaLevel = selectedNode.id;
	var activeFlag = $("#activeFlag").checkbox("getValue");	
	var DataStr = RefuseWayID +"^"+ reasonCode + "^" + reasonDesc + "^" + reaLevel +"^"+ activeFlag;
	var saveRet = $.cm({
		ClassName: 'PHA.HERB.Reason.Save',
		MethodName: 'SaveData',
		ReasonId: '',
		InputStr: DataStr,
		HospId: HospId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({msg: "增加成功！", type: "success", timeout: 1000});
		Clear();
		$('#treeGridReason').tree('append', {
			parent: selectedNode.target,
			data: [{
				id: saveVal,
				text: reasonDesc
			}]
		});
		$("#gridReason").datagrid("reload");
	}
}
function EditReason(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择需要修改的拒发原因",
			type: "alert"
		});
		return;
	}
	var reasonCode=$("#conCode").val();
	var reasonDesc=$("#conDesc").val();
	if ((reasonCode=="")||(reasonDesc == "")) {
		PHA.Popover({
			msg: "请填写原因代码和原因描述后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var reasonId = gridSelect.reasonId ;
	var selectedNode = $('#treeGridReason').tree('getSelected');
	var reaLevel = selectedNode.id;
	var activeFlag = $("#activeFlag").checkbox("getValue");	;	
	var DataStr = RefuseWayID +"^"+ reasonCode + "^" + reasonDesc + "^" + reaLevel +"^"+ activeFlag;	
	
	var saveRet = $.cm({
		ClassName: 'PHA.HERB.Reason.Save',
		MethodName: 'SaveData',
		ReasonId: reasonId,
		InputStr: DataStr,
		HospId: HospId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({msg: "修改成功！", type: "success", timeout: 1000});
		Clear();
		var selectedNode = $('#treeGridReason').tree('getSelected');
		if(selectedNode !== null){
			if(reasonId == selectedNode.id){
				if(activeFlag === false){
					$('#treeGridReason').tree('update', {
						target: selectedNode.target,
						text: reasonDesc + "(" + $g("未启用") +")"
					})	
				}else{
					$('#treeGridReason').tree('update', {
						target: selectedNode.target,
						text: reasonDesc
					});	
				}
			}else{
				var children = $('#treeGridReason').tree('getChildren', selectedNode.target);
				$.each(children, function(key, val){
					if(val.id.toString() === reasonId){
						if(activeFlag === false){
							$('#treeGridReason').tree('update', {
								target: val.target,
								text: reasonDesc + "(" + $g("未启用") +")"
							})
						}else{
							$('#treeGridReason').tree('update', {
								target: val.target,
								text: reasonDesc
							});	
						}
						return false;
					}
				});
			}
		}
		$("#gridReason").datagrid("reload");
	}
}

function ComfirmDel(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择需要删除的拒发原因",
			type: "alert"
		});
		return;
	}

	var delInfo = $g("您确认删除吗?")
	PHA.Confirm("删除提示", delInfo, function () {
		Delete();
	})
}

/* 执行删除方法 */
function Delete(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
	var nouseFlag = "N"
	var reasonId = gridSelect.reasonId ;
	var reasonDesc = gridSelect.reasonDesc ;
	
	var deleteRet = $.cm({
		ClassName: 'PHA.HERB.Reason.Save',
		MethodName: 'DeleteData',
		ReasonId: reasonId,
		HospId: HospId,
		dataType: 'text'
	}, false);
	var deleteArr = deleteRet.split('^');
	var deleteVal = deleteArr[0];
	var deleteInfo = deleteArr[1];
	if (deleteVal < 0) {
		PHA.Alert('提示', deleteInfo, 'warning');
		return;
	} else {
		PHA.Popover({msg: $g("删除成功"), type: "success", timeout: 1000});
		Clear();
		var selectedNode = $('#treeGridReason').tree('getSelected');
		if(selectedNode !== null){
			if(reasonId == selectedNode.id){
				if(nouseFlag === "N"){
					$('#treeGridReason').tree('remove', selectedNode.target);		
				}else{
					$('#treeGridReason').tree('update', {
						target: selectedNode.target,
						text: reasonDesc
					});	
				}
			}else{
				var children = $('#treeGridReason').tree('getChildren', selectedNode.target);
				$.each(children, function(key, val){
					if(val.id.toString() === reasonId){
						if(nouseFlag === "N"){
							$('#treeGridReason').tree('remove', val.target);		
						}else{
							$('#treeGridReason').tree('update', {
								target: val.target,
								text: reasonDesc
							});	
						}
						return false;
					}
				});
			}
		}
		$("#gridReason").datagrid("reload");
	}
}

function Clear(){
	$("#conCode").val('');
	$("#conDesc").val('');
	$("#activeFlag").checkbox('setValue', true);
	
}


function InitHospCombo() {
	var genHospObj=HERB.AddHospCom({tableName:'DHC_PHCNTSREASON'});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
				$.cm({
					ClassName: 'PHA.HERB.Reason.Query',
					MethodName: 'GetReasonTreeStore',
					Params: RefuseWayID + "^"+ "",
					HospId: newHospId
				},function(data){
					$('#treeGridReason').tree('loadData', data);
				});	
				
            }
        }
    }
    
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHC_PHCNTSREASON',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
}

