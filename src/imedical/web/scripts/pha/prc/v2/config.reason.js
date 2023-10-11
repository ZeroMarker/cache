/**
 * ����:	 ��������-����ԭ��ά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.reason.csp";
PHA_COM.App.Name = "PRC.Config.Reason";
PHA_COM.App.Load = "";
var hospID = PHA_COM.Session.HOSPID;
$(function () {
	InitDict();
	InitEvents();
    InitGridReason();
    LoadTreeGridReason();
	InitHospCombo();
});

// �ֵ�
function InitDict() {
	PHA.Tree("treeGridReason",{
		//url: $URL + "?ClassName=PHA.PRC.Com.Store&MethodName=GetPRCReasonTree&params=^^N^",
		lines: false,
		onSelect: function (node) {
			Clear();
			var includeNFlag = $HUI.checkbox("#filterFlag").getValue()? "Y":"N";
			$("#gridReason").datagrid("query", {
				hospID: hospID,
				params: node.id +"^"+ includeNFlag
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
	$("#filterFlag").checkbox({
	    onCheckChange: function(){
			LoadTreeGridReason();   
		}
	})
}

// �¼�
function InitEvents() {
	$("#btnAdd").on("click", AddReason);
	$("#btnEdit").on("click", EditReason);
	$("#btnDel").on("click", ComfirmDel);
}

function LoadTreeGridReason() {
	var desc = $HUI.searchbox('#search-form').getValue();	
	var filterFlag = $HUI.checkbox("#filterFlag").getValue()? "Y":"N";
	$.cm({
		ClassName: 'PHA.PRC.Com.Store',
		MethodName: 'GetPRCReasonTree',
		params: "^^"+ filterFlag+ "^"+ desc,
		hospID: hospID
	},function(data){
		$('#treeGridReason').tree('loadData', data);
	});
}

function InitGridReason() {
    var columns = [
        [
            { field: "reasonId", title: '����ԭ��Id', width: 100, hidden: true },
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
            { field: "activeFlag", title: '�Ƿ����'},
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
            ClassName: 'PHA.PRC.ConFig.Reason',
            QueryName: 'SelectReason',
			hospID: hospID
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
			var activeFlag = rowData.activeFlag;
			$("#conCode").val(code);
			$("#conDesc").val(desc);
			$HUI.checkbox("#activeFlag").setValue(activeFlag=="��");
        },
	    onBeforeLoad: function (param) {
		    if(param.params){
				return true;    
			}
			return false;
        }
    };
    PHA.Grid("gridReason", dataGridOption);
}


function AddReason(){
	var reaCode=$("#conCode").val();
	var reaDesc=$("#conDesc").val();
	if ((reaCode=="")||(reaDesc == "")) {
		PHA.Popover({
			msg: "����д����ԭ�������������ٱ��棡",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var selectedNode = $('#treeGridReason').tree('getSelected');
	if(selectedNode === null){
		PHA.Popover({
			msg: "�������ѡ����Ҫ�����ϸ��ԭ��ȼ���",
			type: "alert",
			timeout: 1000
		});
		return;	
	}
	var reaLevel = selectedNode.id;
	var nouseFlag = $HUI.checkbox("#activeFlag").getValue()?"N":"Y";	
	var DataStr = reaCode + "^" + reaDesc + "^" + reaLevel +"^"+ nouseFlag;
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Reason',
		MethodName: 'SaveComReason',
		ReasonID: '',
		DataStr: DataStr,
		hospID: hospID,
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
				text: reaDesc
			}]
		});
		var includeNFlag = $HUI.checkbox("#filterFlag").getValue()? "Y":"N";
		$("#gridReason").datagrid("query", {
			params: reaLevel +"^"+ includeNFlag
		});	
	}
}
function EditReason(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ����Ҫ�޸ĵĵ���ԭ��",
			type: "alert"
		});
		return;
	}
	var reaCode=$("#conCode").val();
	var reaDesc=$("#conDesc").val();
	if ((reaCode=="")||(reaDesc == "")) {
		PHA.Popover({
			msg: "����д����ԭ�������������ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var reasonId = gridSelect.reasonId ;
	var nouseFlag = $HUI.checkbox("#activeFlag").getValue()?"N":"Y";	
	
	var DataStr = reaCode + "^" + reaDesc +"^^"+ nouseFlag;
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Reason',
		MethodName: 'SaveComReason',
		ReasonID: reasonId,
		DataStr: DataStr,
		hospID: hospID,
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
						text: reaDesc
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
								text: reaDesc
							});	
						}
						return false;
					}
				});
			}
		}
		var includeNFlag = $HUI.checkbox("#filterFlag").getValue()? "Y":"N";
		$("#gridReason").datagrid("query", {
			params: selectedNode.id +"^"+ includeNFlag
		});	
	}
}

function ComfirmDel(){
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		deleteReason();
	})
}

function Clear(){
	$("#conCode").val('');
	$("#conDesc").val('');
	$HUI.checkbox("#activeFlag").uncheck();
}

function InitHospCombo() {
	var genHospObj = GenHospComp('DHC_PHCNTSREASON');
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
        	hospID = record.HOSPRowId;
            LoadTreeGridReason();
        }
    }
}


