/**
 * ����:	 ��ҩ������-�������ԭ��ά��
 * ��д��:	 MaYuqiang
 * ��д����: 2022-01-12
 */
PHA_COM.App.Csp = "pha.herb.v2.config.auditreason.csp";
PHA_COM.App.Name = "HERB.Config.AuditReason";
PHA_COM.App.Load = "";
var HospId = session['LOGON.HOSPID'];	//PHA_COM.Session.HOSPID;
$(function () {
	if (AuditWayID == "") {
        $.messager.alert("��ʾ", "��ҩ�������������δά��,����ϵ��Ϣ��Ա���!", "warning");
        return;
    }
	InitDict();
	InitEvents();
    InitGridReason();
    LoadTreeGridReason();
    InitHospCombo();
});

// �ֵ�
function InitDict() {
	PHA.Tree("treeGridReason",{
		lines: false,
		onSelect: function (node) {
			Clear();
			$("#gridReason").datagrid("query", {
				Params: AuditWayID +"^"+ node.id ,
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
		searcher: function(e){
			LoadTreeGridReason();	
		}	
	});
}

// �¼�
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
		Params: AuditWayID + "^"+ desc,
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
            	title: 'ԭ��Id', 
            	width: 100, 
            	hidden: true 
            },
            {
                field: 'reasonCode',
                title: 'ԭ�����',
                width: 20,
                sortable: 'true',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            { 
            	field: "activeFlag", 
            	title: '�Ƿ����', 
            	hidden: true 
            },
            {
                field: 'reasonDesc',
                title: 'ԭ������',
                width: 70,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.HERB.Reason.Query',
            QueryName: 'QueryReason',
            Params: AuditWayID +"^"+ "",
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
			$("#conCode").val(code);
			$("#conDesc").val(desc);
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
			msg: "����д���ԭ�������������ٱ��棡",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var selectedNode = $('#treeGridReason').tree('getSelected');
	if(selectedNode === null){
		PHA.Popover({
			msg: "�������ѡ����Ҫ�����ϸ��ԭ��ȼ�",
			type: "alert",
			timeout: 1000
		});
		return;	
	}
	var reaLevel = selectedNode.id;
	var nouseFlag = "Y";	
	var DataStr = AuditWayID +"^"+ reasonCode + "^" + reasonDesc + "^" + reaLevel +"^"+ nouseFlag;
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({msg: "���ӳɹ���", type: "success", timeout: 1000});
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
			msg: "��ѡ����Ҫ�޸ĵ����ԭ��",
			type: "alert"
		});
		return;
	}
	var reasonCode=$("#conCode").val();
	var reasonDesc=$("#conDesc").val();
	if ((reasonCode=="")||(reasonDesc == "")) {
		PHA.Popover({
			msg: "����дԭ������ԭ���������ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var reasonId = gridSelect.reasonId ;
	var selectedNode = $('#treeGridReason').tree('getSelected');
	var reaLevel = selectedNode.id;
	var nouseFlag = "Y";	
	var DataStr = AuditWayID +"^"+ reasonCode + "^" + reasonDesc + "^" + reaLevel +"^"+ nouseFlag;	
	
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({msg: "�޸ĳɹ���", type: "success", timeout: 1000});
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

function ComfirmDel(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ�������ԭ��",
			type: "alert"
		});
		return;
	}
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		Delete();
	})
}

/* ִ��ɾ������ */
function Delete(){
	var nouseFlag = "N"
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
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
		PHA.Alert('��ʾ', deleteInfo, 'warning');
		return;
	} else {
		PHA.Popover({msg: "ɾ���ɹ���", type: "success", timeout: 1000});
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
}


function InitHospCombo() {
	var genHospObj = HERB.AddHospCom({tableName:'DHC_PHCNTSREASON'});
	if (typeof genHospObj ==='object'){
		//debugger;
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $.cm({
					ClassName: 'PHA.HERB.Reason.Query',
					MethodName: 'GetReasonTreeStore',
					Params: AuditWayID + "^"+ "",
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


