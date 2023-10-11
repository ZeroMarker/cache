var hospID = ""; // ҽԺid
var wardID = ""; // ����id
function getWardData(hospid) {
    $cm({
            ClassName: "Nur.SHIFT.Service.ShiftBizV2",
            QueryName: "GetallWard",
            desc: "",
            hospid: hospid,
            bizTable: "ExchangeSettingV2",
        },
        function (obj) {
	        obj.rows.splice(0,0,{"wardid":"","warddesc":"ȫԺ"})
            wardId = "";
            $HUI.combobox("#wardBox", {
                valueField: "wardid",
                textField: "warddesc",
                multiple: false,
                selectOnNavigation: false,
                panelHeight: "210",
                editable: true,
                data: obj.rows,
                onChange: function (newval) {
                    wardID = newval;
                    // console.log(wardId);
                    // disableButtom(false)
                },
            });
        }
    );
}
function getTreeData()
{
	$cm({
            ClassName: "Nur.SHIFT.Service.ShiftSetting",
            MethodName: "GetDetailColumnSetting",
            HospID:hospID,
            WardID: wardID,
        },
        function (jsonData) {
            $('#columns').tree({
				data:jsonData,
				onClick: function(node){
					if(node.id==0)
					{
						return;
					}
					var res=$cm({
		       			ClassName: 'Nur.SHIFT.Service.ShiftSetting',
		        		MethodName: 'GetColumnSettingByID',
		        		ColumnID:node.id
			   		 }, false);
		    		if (res) {
		    			$("#columnID").val(res.ID)
		    			$("#columnWidth").val(res.width)
		    			$("#canEdit").checkbox("setValue",parseInt(res.editable)=="1"?true:false)
		    			$('#storagePosition').combobox('setValue', !!res.field?res.field:"");
		    			$("#templateArea").val(res.template)
		    		}
				}
			});
        }
    );
}
// ����û���
function addDisplaceMark() {
	var str="{}";
	insertText($("#templateArea")[0],str)
}
function insertText(obj,str) {
  if (document.selection) {
    var sel = document.selection.createRange();
    sel.text = str;
  } else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
    var startPos = obj.selectionStart,
        endPos = obj.selectionEnd,
        cursorPos = startPos,
        tmpStr = obj.value;
    obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length);
    cursorPos += str.length;
    obj.selectionStart = obj.selectionEnd = cursorPos;
  } else {
    obj.value += str;
  }
}
function addSetting()
{
	$('#modalAdd').window('open');
	$("#maColumnName").val("");
}
function addSettingHandler()
{
	var node = $('#columns').tree('getSelected');
	var parent=0
	if(node)
	{
		parent=node.id
	}
	var res=$cm({
		        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
		        MethodName: 'NewColumnSetting',
		        HospID:hospID,
		        WardID:wardID,
		        ParentID:parent,
		        Title:$("#maColumnName").val()
			    }, false);
		    	if (0==res) {
		    		$.messager.popover({msg: '��ӳɹ�',type:'success'});
		    		getTreeData();
		    		$('#ff')[0].reset()
		    		$('#modalAdd').window('close');
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		    		return false
		    	}
}
function DelSetting()
{
	var node = $('#columns').tree('getSelected');
	if(node)
	{
		$.messager.confirm("ɾ��", "ȷ��Ҫɾ��ѡ�е�����?", function (r) {
		if (r) {
			if (node.id) {
			    var res=$cm({
		        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
		        MethodName: 'DeleteColumnSetting',
		        ID:node.id
			    }, false);
		    	if (0==res) {
		    		$.messager.popover({msg: 'ɾ���ɹ���',type:'success'});
		    		getTreeData();
		    		$('#ff')[0].reset()
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		    		return false
		    	}
			}
		}
	});
	}
	
}
function saveSetting()
{
	var res=$cm({
		        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
		        MethodName: 'SaveColumnSetting',
		        ID:$("#columnID").val(),
		        Width:$("#columnWidth").val(),
		        Editable:$("#canEdit").checkbox('getValue')?1:0,
		        Field:$('#storagePosition').combobox('getValue'),
		        Template:$("#templateArea").val()
			    }, false);
		    	if (0==res) {
		    		$.messager.popover({msg: '��ӳɹ�',type:'success'});
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		    		return false
		    	}
}
$(function() {
	if (parseInt(multiFlag)) {
		hospComp = GenHospComp("Nur_IP_DataTab",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
		///var hospComp = GenHospComp("ARC_ItemCat")
		// console.log(hospComp.getValue());     //��ȡ�������ֵ
		hospID=hospComp.getValue();
		hospComp.options().onSelect = function(i,d){
			// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
			// HOSPRowId: "2"
			console.log(arguments);
		}  ///ѡ���¼�
	} else {
		hospID=session['LOGON.HOSPID'];
	}
	getWardData(hospID);
	getTreeData();
})
