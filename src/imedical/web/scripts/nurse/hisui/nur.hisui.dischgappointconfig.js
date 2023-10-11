$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			$(this).datagrid('endEdit', param.index);
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				// if (fields[i] != param.field){
				if (param.field.indexOf(fields[i])<0){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
var editBGCell=(function() {
	var oldFields;
	return function(fields,index) {
		if (fields) oldFields=fields;
		$('#dischgAppointTable').datagrid('editCell', {
			index:index,
			field:oldFields||[]
		});
	};
})();
// -----------------------------------------------------
var editTSIndex,tsTableData={"total":0,"rows":[]};
var hospID, multiColumns=[],colCodesArr = [],curEditorTarget,saveFlag=false;
$(function() {
	hospComp = GenHospComp("Nur_IP_DischgAppoint",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;
		getBuildandDAInfo();
		getDischgAppointFlag();
	}  ///ѡ���¼�
	getBuildandDAInfo();
	getDischgAppointFlag();
})
function getDischgAppointFlag(){
  $cm({
    ClassName: 'Nur.NIS.Service.DischgAppoint.Config',
    MethodName: 'GetDischgAppointFlag',
		hospDR:hospID
  }, function (res) {
		if (1 == res) {
			$("#appointCheck").checkbox('setValue', true);
		} else {
			$("#appointCheck").checkbox('setValue', false);
		}
		setTimeout(function() {
			saveFlag=true;
		}, 100);
  });
}
function updateDischgAppointFlag(){
	if (!saveFlag) return;
  $cm({
    ClassName: 'Nur.NIS.Service.DischgAppoint.Config',
    MethodName: 'UpdateDischgAppointFlag',
    flag: $("#appointCheck").checkbox('getValue')?1:0,
		hospDR:hospID
  }, function (res) {
		if (0 == res) {
			$.messager.popover({ msg: "���ݱ���ɹ�", type: "success" });
		} else {
			$.messager.popover({ msg: res, type: "alert" });
		}
  });
}
function getBuildandDAInfo() {
	// ��ȡ��¥��ԺԤԼ��Ϣ
  $cm({
		ClassName: 'Nur.NIS.Service.DischgAppoint.Config',
		MethodName: 'GetBuildandDAInfo',
		hospDR: hospID
  }, function (res) {
		var colspan=0;
		var keys = Object.keys(res[0]);
		keys.map(function (k,i) {
			if (k.indexOf("buildDesc")>-1) colspan++;
		});
		colLen=colspan*3;
		rowLen=res.length;
		colCodesArr=[];
		multiColumns = [[
			{title:$g('��������'),align:"center",width:174},
			{title:$g('��һ ~ ����'),align:"center",colspan:colspan},
			{title:$g('����'),align:"center",colspan:colspan},
			{title:$g('����'),align:"center",colspan:colspan}
		], [
			{title:$g('ʱ���'),align:"center",field:'timeSlot',width:174,formatter:function(value,row){
				return value||(row.startTime+'~'+row.endTime);
			}},
		]];
		var footer={timeSlot:"�ϼ�"};
		["1,2,3,4,5","6","7"].map(function (w) {
			var n=0;
			keys.map(function (k,i) {
				if (k.indexOf("buildDesc")>-1) {
					n++;
					var field='col'+colCodesArr.length;
					multiColumns[1].push({
						title:$g(res[0]["buildDesc_"+n]),
						field:field,
						align:"center",
						width:100
					});
					res.map(function(r,j) {
						var val=res[j]["buildId_"+n+"_ "+w+"_"+"_val"]||'';
						res[j][field]=val
						footer[field]=parseInt(val||0)+parseInt(footer[field]||0);
					})
					colCodesArr.push({
						building:res[0]["buildId_"+n],
						weekAll:w
					});
				}
			});
		});
		$("#dischgAppointTable").datagrid({
			singleSelect: true,
			autoSizeColumn: false,
			// fitColumns: false,
			fitColumns: true,
			pagination: false,
			columns: multiColumns,
			showFooter:true,
			data: {
				rows:res,
				footer:[footer],
				// footer:[{price:'33Ԫ'}],
			},
			loadFilter:function(data){ //�õ����ݺ�Ϊ�ϼ��и�ֵ
				if(data.footer && data.footer.length>0){
					data.footer[0]["timeSlot"] = "�ϼ�";
				}
				return data;
			},
			onClickCell: function (index, field, value) {
				if ("bedCode" == field || "name" == field) return;
				console.log(index, field, value);
				var bgColor = $(
					'tr[datagrid-row-index="' + index + '"]>td[field="' + field + '"]'
				).css("backgroundColor");
				if ("rgb(228, 228, 228)" == bgColor) return;
				colIndex = parseInt(field.slice(3));
				editMultiTableCell(index, field);
			},
			onLoadSuccess: function (data) {
				resizeTableHeight();
				setTimeout(resizeTableHeight, 500);
			},
		});
  });
}
function endEditMultiTableCell(flag) {
  var rows = $("#dischgAppointTable").datagrid("getRows");
  // �����༭
  for (var i = 0, len = rows.length; i < len; i++) {
    e = rows[i];
    var ed = $("#dischgAppointTable").datagrid("getEditors", i)[0]; // ��ȡ�༭��
    if (ed) {
      console.log(ed);
      var colObj = colCodesArr[ed.field.slice(3)];
			// var value = $(ed.target).val();
			var value = $(ed.target).numberbox('getValue');
      var res = $cm(
        {
          ClassName: "Nur.NIS.Service.DischgAppoint.Config",
          MethodName: "AddOrUpdateBuildandDAInfo",
					dataType: "text",
					data: JSON.stringify(
            {
              slotDR: e.slotDR,
              weekAll: colObj.weekAll,
              appointNum: value,
              building: colObj.building,
							hospDR:hospID
            }
          ),
        },
        false
      );
      if (0 == res) {
        if (1 == flag) {
          $.messager.popover({ msg: "���ݱ���ɹ�", type: "success" });
        }
      } else {
        $.messager.popover({ msg: res, type: "alert" });
        return false;
      }
      if (2 != flag) {
        $("#dischgAppointTable").datagrid("endEdit", i);
      }
			var field=ed.field
			var count=0;
			var $divs=$('.evaluate .datagrid-view2>.datagrid-body td[field="'+field+'"]>div');
			$divs.map(function (i,obj) {
				if ($(obj).children('table').length) {
					count+=parseInt($(obj).find('table input').val()||0);
				} else {
					count+=parseInt($(obj).html()||0);
				}
			})
			$('.evaluate .datagrid-view2>.datagrid-footer td[field="'+field+'"]>div').html(count);
      return true;
    }
  }
  return true;
}
function forwardMultiTableCell(index, field, keyCode) {
  var rows = $("#dischgAppointTable").datagrid("getRows"),
    row = rows[index];
  var colspan;
  switch (keyCode) {
    case 38: //��
      if (0 == index) {
        index = rows.length - 1;
        if (0 == colIndex) {
          colIndex = colCodesArr.length - 1;
        } else {
          colIndex--;
        }
      } else {
        index--;
      }
      break;
    case 40: //��
      if (index == rows.length - 1) {
        index = 0;
        if (colCodesArr.length - 1 == colIndex) {
          colIndex = 0;
        } else {
          colIndex++;
        }
      } else {
        index++;
      }
      break;
    case 37: //��
      if (0 == colIndex) {
        if (0 == index) {
          index = rows.length - 1;
        } else {
          index--;
        }
        colIndex = colCodesArr.length - 1;
      } else {
        colIndex--;
      }
      break;
    case 39: //��
      if (colIndex == colCodesArr.length - 1) {
        colIndex = 0;
        if (index == rows.length - 1) {
          index = 0;
        } else {
          index++;
        }
      } else {
        colIndex++;
      }
      break;
    default:
      return;
  }
  field = "col" + colIndex;
  editMultiTableCell(index, field, keyCode);
}
function editMultiTableCell(index, field, keyCode) { // ��ʱ���
  var $td = $(
    'tr[datagrid-row-index="' + index + '"]>td[field="' + field + '"]'
  );
  var bgColor = $td.css("backgroundColor");
  console.log(bgColor);
  if ("rgb(228, 228, 228)" == bgColor) {
    if (keyCode) {
      forwardMultiTableCell(index, field, keyCode);
    }
    return;
  }
  var rows = $("#dischgAppointTable").datagrid("getRows"),
    row = rows[index];
  var saveRes = endEditMultiTableCell();
  if (!saveRes) return;
  var e = $("#dischgAppointTable").datagrid("getColumnOption", field);
	e.editor = {
		type: "numberbox",
		options: {
			max:9999,min:0,isKeyupChange:true,
		},
	};
  $("#dischgAppointTable").datagrid("editCell", {
    index: index,
    field: [field] || [],
  });
  var ed = $("#dischgAppointTable").datagrid("getEditor", {
    index: index,
    field: field,
  }); // ��ȡ�༭��
  curEditorTarget = ed.target;
  $(ed.target)
    .focus()
    .bind("keyup", function (e) {
      if (13 == e.keyCode) e.keyCode = 40;
      if ([13, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
        forwardMultiTableCell(index, field, e.keyCode);
        return;
      }
    })
    .bind("blur", function (e) {
      endEditMultiTableCell(2);
    });
}
function addTSRow() {
	if ((undefined!=editTSIndex)&&!saveTSRow()) return;
	editTSIndex=$('#timeSlot').datagrid('getRows').length;
	var row={
		startTime: "",
		endTime: "",
		id: ""
	}
	$('#timeSlot').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", editTSIndex);
  editTSRow(editTSIndex,row)
}
function editTSRow(curInd,row) {
	// ��˫����һ��ʱ���ȱ������ڱ༭����
	if ((undefined!=editTSIndex)&&(editTSIndex!=curInd)&&!saveTSRow()) return;
	editTSIndex=curInd;
	$('#timeSlot').datagrid('beginEdit', editTSIndex);
}
function saveTSRow() {
	if (undefined==editTSIndex) {
		return $.messager.popover({msg: '����Ҫ������',type:'alert'});
	}
	var curRow=$('#timeSlot').datagrid('getRows')[editTSIndex];
	var rowEditors=$('#timeSlot').datagrid('getEditors',editTSIndex);
	var id=curRow.id||'';
	var startTime=$(rowEditors[0].target).timespinner('getValue');  
	var endTime=$(rowEditors[1].target).timespinner('getValue');  
	if (!startTime||!endTime) {
		$.messager.popover({msg: '��ֹʱ�����ڱ����',type:'alert'});
		return false;
	}
	if (startTime>endTime) {
		return $.messager.popover({msg: '��ֹʱ�䲻�ܴ��ڽ���ʱ�䣡',type:'alert'});
		return false;
	}
	for (var i = 0; i < tsTableData.rows.length; i++) {
		var t=tsTableData.rows[i];
		if (id==t.id) continue;
		if (startTime<=endTime) {
			if ((startTime<=t.endTime)&&(endTime>=t.startTime)) {
				return $.messager.popover({msg: '��ʱ����������Ѵ��ڵ����ص���',type:'alert'});
			}
		}
	}
	var data={
		id:id,
		startTime:startTime,
		endTime:endTime,
		hospDR:hospID
	}
	var updateRow=editTSIndex;
  var res=$cm({
    ClassName: 'Nur.NIS.Service.DischgAppoint.Config',
    MethodName: 'AddOrUpdateTSConfig',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	if (parseInt(res)==res) {
		$.messager.popover({msg: '����ɹ���',type:'success'});
		var row={
    	id:id||res,
			startTime:startTime,
			endTime:endTime
    };
		$('#timeSlot').datagrid('acceptChanges').datagrid('updateRow', {
      index: updateRow,
      row: row
    });
		$('#timeSlot').datagrid('endEdit',editTSIndex)
		editTSIndex=undefined;
		// ��������
		tsTableData.rows.map(function(elem,index) {
			if (row.id==elem.id) {
				tsTableData.rows[index].startTime=row.startTime;
				tsTableData.rows[index].endTime=row.endTime;
			}
		});
		$('#timeSlot').datagrid({data: tsTableData.rows});
		getBuildandDAInfo();
		return true;
	} else {
		$.messager.popover({msg: res,type:'alert'});
		return false;
	}
}
function deleteTSRow(id) {
	var bgObj = $('#timeSlot');
	var row=bgObj.datagrid('getSelected');
	$.messager.confirm("ɾ��", "ȷ��Ҫɾ�����е�����?", function (r) {
		if (r) {
			if (id) {
		    var res=$cm({
	        ClassName: 'Nur.NIS.Service.DischgAppoint.Config',
	        MethodName: 'DeleteTSConfig',
	        ID:id
		    }, false);
	    	console.log(res);
	    	if (0==res) {
	    		$.messager.popover({msg: 'ɾ���ɹ���',type:'success'});
					tsTableData.rows.map(function(elem,index) {
						if (id==elem.id) {
							tsTableData.rows.splice(index,1);
						}
					});
					$('#timeSlot').datagrid({data: tsTableData.rows});
	    	} else {
	    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
	    		return false
	    	}
			}else{
				var curInd =bgObj.datagrid('getRowIndex',row);
				bgObj.datagrid('deleteRow',curInd);
			}
			editTSIndex = undefined;
		}
	});
}
function openTSModal() {
	$('#timeSlotModal').dialog("open");
  $('#timeSlot').datagrid('resize',{
    height:300
	});
	var offsetLeft = (window.innerWidth - $('#timeSlotModal').parent().width()) / 2;
	var offsetTop = (window.innerHeight - $('#timeSlotModal').parent().height()) / 2;
	$('#timeSlotModal').dialog({
			// onClose: getBGRecordByDays,
			left: offsetLeft,
			top: offsetTop
	}).dialog("open");
	// ��ȡѪ�ǲɼ�ʱ������
  $cm({
      ClassName: 'Nur.NIS.Service.DischgAppoint.Config',
      QueryName: 'GetTSConfig',
      rows: 999999999999999,
      hospDR: hospID
  }, function (data) {
    tsTableData=data;
		editTSIndex=undefined;
		$('#timeSlot').datagrid({
			columns:[[
				{field:'startTime',title:'��ʼʱ��',width:80,editor:{type:'timespinner'}},
				{field:'endTime',title:'��ֹʱ��',width:80,editor:{type:'timespinner'}},
			]],
			data: tsTableData.rows
		});
  });
}
function resizeTableHeight() {
	var innerHeight=window.innerHeight;
  $('#dischgAppointTable').datagrid('resize',{
    height:innerHeight-155
	});
}
// setTimeout(resizeTableHeight,100);
window.addEventListener("resize",resizeTableHeight);
