if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
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
				if (!param.field.includes(fields[i])){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
				// reloadLocsData()
			if (param.field.includes('ruleLocs')) {
				reloadLocsData()
			}
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
// -----------------------------------------------------
var selectSSIndex,hospComp,hospID,wardList,ssTableData,wardID,wardDescObj={},ssObj={},expandFlag="statisticsSet",nameList=[],nameObj={};
ssTableData={"total":0,"rows":[]}
var selectMSIndex,editMSIndex,msTableData,itemSRCValue;
msTableData={"total":0,"rows":[]}
var editMSCell=(function() {
	var oldFields;
	return function(fields) {
		console.log($('.panel.combo-p'));
		// $('.panel.combo-p').remove()
		if (fields) oldFields=fields;
		console.log('"""""""""oldFields"""""""""');
		console.log(oldFields);
		$('#middleSet').datagrid('editCell', {
			index:editMSIndex,
			field:oldFields||[]
		});
	};
})();

$(function() {
	if (parseInt(multiFlag)) {
		hospComp = GenHospComp("Nur_IP_ExchangeItem",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
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
	console.log(hospID);

	findSSData();
	updateShowFormat(-2);
})

// ��ѯ����������
function findSSData() {
	hospID=hospComp?hospComp.getValue():hospID;
	wardID=$('#wardType').combobox('getValue');
	getallWardNew();
	// $('#statisticsSet').datagrid('loadData',ssTableData);
	msTableData.rows=[]
	$('#middleSet').datagrid('loadData',{"total":0,"rows":[]});
	// $("#template").val('');
	editMSIndex=undefined;
}
function getWardsDesc(wardIDString) {
	if (''==wardIDString) return "";
	var ids=wardIDString.toString().split(','),str="";
	ids.map(function(elem,index) {
		str+=wardDescObj[elem]+",";
	});
	return str.slice(0,-1);
}
function getallWardNew() {
	// ��ȡ����
    $cm({
        ClassName: 'Nur.NIS.Service.Base.Ward',
        QueryName: 'GetallWardNew',
        desc: '',
        hospid: hospID,
        bizTable: 'Nur_IP_ExchangeItem',
        rows: 10000
    }, function (data) {
        wardList=data.rows;
        wardList.map(function(elem,index) {
        	wardDescObj[elem.wardid]=elem.warddesc;
        });

				$HUI.combobox(".locs",{
					multiple:true,valueField:'wardid', textField:'warddesc',
					data:wardList,
					defaultFilter:4
				});
        getSSTableData();
        // msExpand();
    });
}
function getSSTableData() {
	// ��ȡ��������������
  $cm({
      ClassName: 'Nur.SHIFT.Service.ShiftSetting',
      QueryName: 'GetShiftExchangeItem',
      hospDR: hospID,
      wardType: wardID,
      posType: 0 //ͳ����
  }, function (data) {
  	console.log(data);
  	nameList=[];
  	data.rows.map(function(elem,index) {
			data.rows[index].ruleInvalidLocs=elem.ruleInvalidLocs.replace(/\|/g,',')
			data.rows[index].ruleLocs=elem.ruleLocs.replace(/\|/g,',')
			nameList.push({id:elem.id,name:elem.name,methodExpression:elem.methodExpression});
			nameObj[elem.id]=elem.name;
		});
    ssTableData=data;
		$('#statisticsSet').datagrid('loadData',ssTableData);
		selectSSIndex=undefined;
		resizePageStyle()
		$('#middleSet').datagrid('getPanel').panel('collapse',true)
  });
}
function addSSRow() {
	ssObj={};
	$HUI.dialog('#statisticsModal').open();
	$('#ssForm').form('reset')
	$('#ssForm').form('disableValidation')
}
//ɾ��һ��
function deleteSSRow() {
	var diObj = $('#statisticsSet');
	var row=diObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("ɾ��", "ȷ��Ҫɾ��ѡ�е�����?", function (r) {
			if (r) {
		    $cm({
		        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
		        MethodName: 'DeleteShiftExchangeItem',
		        ID:row.id
		    }, function (data) {
		    	console.log(data);
		    	if (0==data) {
		    		$.messager.popover({msg: 'ɾ���ɹ���',type:'success'});
						var curInd =diObj.datagrid('getRowIndex',row);
						diObj.datagrid('deleteRow',curInd);
						// updateTableHeight()
						selectSSIndex = undefined;
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
		    	}
		    });
			}
		});
	} else {
		$.messager.popover({msg: '����ѡ��Ҫɾ�����У�',type:'alert'});
	}
}
// ѡ������������
function selectSSRow(curInd) {
	selectSSIndex=curInd;
	$('#statisticsSet').datagrid('selectRow',curInd);
	getMSTableData();
	// getTemplateSetData();
}
// �༭����������
function editSSRow(curInd,row) {
	console.log(row);
	ssObj=row;
	$HUI.dialog('#statisticsModal').open();
	$("#name").val(row.name)
	$("#sortNo").val(row.sortNo)
	$("#positionColumn").val(row.positionColumn)
	$("#shiftDesc").val(row.shiftDesc)
	$("#methodExpression").val(row.methodExpression)
	$("#type").combobox('setValue',row.type)
	$("#ruleLocs").combobox('setValues',row.ruleLocs?row.ruleLocs.split(','):[])
	$("#ruleInvalidLocs").combobox('setValues',row.ruleInvalidLocs?row.ruleInvalidLocs.split(','):[])
	$("#detailFlag").combobox('setValue',row.detailFlag)
	$("#sumFlag").combobox('setValue',row.sumFlag)
	$("#template").val(row.template)
	$('#ssForm').form('validate')
}
// ��������������
function saveSSRow() {
	console.log($('#ssForm').form('validate'));
	$('#ssForm').form('enableValidation')
	if ($('#ssForm').form('validate')) {

		var repeatCheck={},ruleLocs=$("#ruleLocs").combobox('getValues'),ruleInvalidLocs=$("#ruleInvalidLocs").combobox('getValues');//�ظ�У��
		for (var i = 0; i < ruleLocs.length; i++) {
			repeatCheck[ruleLocs[i]]=1;
		}
		for (var i = 0; i < ruleInvalidLocs.length; i++) {
			if (repeatCheck[ruleInvalidLocs[i]]) {
				$.messager.popover({msg: '���÷�Χ�Ͳ����÷�Χ��������ͬѡ�',type:'alert'});
				return false;
			} else {
				repeatCheck[ruleInvalidLocs[i]]=1;
			}
		}
		var obj={
			hospDR:hospID,
			wardType:wardID,
			id:ssObj.id||"",
			name:$("#name").val(),
			sortNo:$("#sortNo").val(),
			positionColumn:$("#positionColumn").val(),
			shiftDesc:$("#shiftDesc").val(),
			methodExpression:$("#methodExpression").val(),
			type:$("#type").combobox('getValue'),
			ruleLocs:ruleLocs.join('|'),
			ruleInvalidLocs:ruleInvalidLocs.join('|'),
			detailFlag:$("#detailFlag").combobox('getValue'),
			sumFlag:$("#sumFlag").combobox('getValue'),
			template:$("#template").val(),
			positionType:0,
			activeFlag:"Y"
		}
    $cm({
        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
        MethodName: 'AddOrUpdateShiftExchangeItem',
        dataType: "text",
        data:JSON.stringify(obj)
    }, function (data) {
    	console.log(data);
    	if (0==data) {
				$.messager.popover({msg: "���ݱ���ɹ���",type:'success'});
    		$HUI.dialog('#statisticsModal').close();
    		getSSTableData();
    	} else {
				$.messager.popover({msg: JSON.stringify(data),type:'alert'});
    	}
    });
		return true;
	}
}
// ����û���
function addDisplaceMark() {
	var str="{}";
	if (undefined!=selectMSIndex) {
		str="{"+msTableData.rows[selectMSIndex].field+"}";
	}
	insertText($("#template")[0],str)
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

function msExpand() {
	if (!msTableData.rows.length) {
		getMSTableData()
	}
	$('#statisticsSet').datagrid('getPanel').panel('collapse',true)
	expandFlag="middleSet"
}
function getMSTableData() {
	// ��ȡ��������������
  $cm({
      ClassName: 'Nur.SHIFT.Service.ShiftSetting',
      QueryName: 'GetShiftExchangeItem',
      hospDR: hospID,
      wardType: wardID,
      posType: 1 //�м���
  }, function (data) {
  	data.rows.map(function(elem,index) {
			data.rows[index].ruleInvalidLocs=elem.ruleInvalidLocs.replace(/\|/g,',')
			data.rows[index].ruleLocs=elem.ruleLocs.replace(/\|/g,',')
		});
    msTableData=data;
		$('#middleSet').datagrid('loadData',msTableData);
		selectMSIndex=undefined;
		editMSIndex=undefined;
		resizePageStyle()
  });
}
function addMSRow() {
	if ((undefined!=editMSIndex)&&!saveMSRow()) return;
	editMSIndex=$('#middleSet').datagrid('getRows').length;
	console.log(editMSIndex);
	var row={
		id: "",
		itemSRC: "",
		name: "",
		positionRow: "",
		positionColumn: "",
		wholeLine: "",
		showType: "",
		showFormat: "",
		ruleLocs: "",
		ruleInvalidLocs: "",
		shiftDesc: "",
		methodExpression: "",
	}
	$('#middleSet').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", editMSIndex);
	selectMSIndex=editMSIndex;
  editMSRow(editMSIndex,row)
}
// �༭����������
function editMSRow(curInd,row) {
	console.log(arguments);
	// ��˫����һ��ʱ���ȱ������ڱ༭����
	if ((undefined!=editMSIndex)&&(editMSIndex!=curInd)&&!saveMSRow()) return;
	editMSIndex=curInd;
	if (row.itemSRC) {
		itemSRCChange({value:row.itemSRC})
		if (4==row.itemSRC) {
			// nameChange({id:row.name,methodExpression:row.methodExpression})
			nameChange({name:row.name,id:row.relationItem,methodExpression:row.methodExpression})
		}
		if (row.showType) {
			showTypeChange({value:row.showType})
		}
	} else {
		editMSCell(['itemSRC','positionRow','positionColumn','wholeLine','ruleLocs','ruleInvalidLocs','shiftDesc']);
	}
}
$.extend($.fn.datagrid.defaults.editors, {
	selfDefEdit: {
		init: function(container, options){
			if (4==itemSRCValue) {
				console.log(11);
				var input = $('<input class="nameItem" type="text">').appendTo(container);
				return input.combobox({
				  data:nameList,
				  valueField:'name',
				  textField:'name',
				  onSelect:nameChange
				});
			} else {
				console.log(22);
				var input = $('<input class="nameItem" class="textbox">').appendTo(container);
				console.log(2222);
				return $HUI.validatebox(input, {});
			}
		},
		destroy: function(target){
			if (4==itemSRCValue) {
				console.log(11);
				$(target).combobox('destroy');
			} else {
				console.log(22);
				$(target)[0].destroy();
			}
		},
		getValue: function(target){
			if (4==itemSRCValue) {
				console.log(11);
				return $(target).combobox('getValue');
			} else {
				console.log(22);
				console.log($(target));
				console.log($(target)[0].jdata.value);
				return $(target)[0].jdata.value;
			}
		},
		setValue: function(target, value){
			if (4==itemSRCValue) {
				console.log(11);
				$(target).combobox('setValue',value);
			} else {
				console.log(22);
				console.log('"""""""""value"""""""""');
				console.log(value);
				console.log($(target));
				target.jqselector[0].value=value;
				$(target)[0].jdata.value=value;
			}
		},
		resize: function(target, width){
			if (4==itemSRCValue) {
				console.log(11);
				$(target).combobox('resize',width);
			} else {
				console.log(22);
				$(target)[0].jqselector.css('width',width);
			}
		}
	}
});
function itemSRCChange(data) {
	console.log(editMSIndex);
	$('#middleSet').datagrid('endEdit', editMSIndex);
	console.log(data);
		
	itemSRCValue=data.value
	if (4==itemSRCValue) {
		editMSCell(['itemSRC','name','positionRow','positionColumn','wholeLine','showFormat','ruleLocs','ruleInvalidLocs','shiftDesc']);
		getMSEditorTarget('name').combobox({data:nameList});
		updateShowFormat(-1);
	} else {
		if ('A'==msTableData.rows[editMSIndex].showType) {
			editMSCell(['itemSRC','name','positionRow','positionColumn','wholeLine','showType','showFormat','ruleLocs','ruleInvalidLocs','shiftDesc','methodExpression']);
			updateShowFormat(0);
		} else {
			editMSCell(['itemSRC','name','positionRow','positionColumn','wholeLine','showType','ruleLocs','ruleInvalidLocs','shiftDesc']);
		}
	}
}
function showTypeChange(data) {
	console.log(data);
	var nameVal=getMSEditorTarget('name')[0].jdata.value;
	$('#middleSet').datagrid('acceptChanges').datagrid('updateRow',{
		index: editMSIndex,
		row: {
			name: nameVal
		}
	});
	if ('M'==data.value) { //�û�¼��
		editMSCell(['itemSRC','name','positionRow','positionColumn','wholeLine','showType','ruleLocs','ruleInvalidLocs','shiftDesc']);
		$(".middleSet .datagrid-row-editing td:nth-child(7) div").html("");
	} else { //�Զ���ȡ
		editMSCell(['itemSRC','name','positionRow','positionColumn','wholeLine','showType','showFormat','ruleLocs','ruleInvalidLocs','shiftDesc','methodExpression']);
		updateShowFormat(0)
	}
}
function getMSEditorTarget(field) {
	var editor=$('#middleSet').datagrid('getEditor', {
		index : editMSIndex,  
		field : field  
  });
  return $(editor.target);
}
function nameChange(data) {
	console.log(data);
	$('#middleSet').datagrid('acceptChanges').datagrid('updateRow',{
		index: editMSIndex,
		row: {
			name: data.name,
			relationItem: data.id,
			// showType: "A",
			methodExpression: ""
			// methodExpression: data.methodExpression
		}
	});
	editMSCell();
	updateShowFormat(-1);
}
function updateShowFormat(i) {
	showFormatList=[
		{value:1,desc:"��������"},
		{value:2,desc:"����"},
		{value:3,desc:"����+����"},
		{value:4,desc:"���ı�"}
	];
	if (i>-1) {
		showFormatList.splice(i,1)
	}
	showFormatList.map(function(elem,index) {
		showFormatObj[elem.value]=elem.desc
	});
	if (-2==i) return;
	var row=msTableData.rows[editMSIndex];
	var showFormatTarget=getMSEditorTarget('showFormat');
	showFormatTarget.combobox({
    data:showFormatList,
    width:showFormatTarget.parentsUntil('tr')[0].offsetWidth
	}).combobox('setValue',row.showFormat);
}
//ɾ��һ��
function deleteMSRow() {
	var msObj = $('#middleSet');
	var row=msObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("ɾ��", "ȷ��Ҫɾ��ѡ�е�����?", function (r) {
			if (r) {
				var curInd =msObj.datagrid('getRowIndex',row);
				if (row.id) {
				    $cm({
				        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
				        MethodName: 'DeleteShiftExchangeItem',
				        ID:row.id
				    }, function (data) {
				    	console.log(data);
				    	if (0==data) {
				    		$.messager.popover({msg: 'ɾ���ɹ���',type:'success'});
								msObj.datagrid('deleteRow',curInd);
								selectMSIndex = undefined;
								editMSIndex = undefined;
				    	} else {
				    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
				    	}
				    });
				}else{
					msObj.datagrid('deleteRow',curInd);
					selectMSIndex = undefined;
					editMSIndex = undefined;
				}
			}
		});
	} else {
		$.messager.popover({msg: '����ѡ��Ҫɾ�����У�',type:'alert'});
	}
}
// ѡ������������
function selectMSRow(curInd) {
	selectMSIndex=curInd;
	$('#middleSet').datagrid('selectRow',curInd);
}
// ��������������
function saveMSRow() {
	if (undefined==editMSIndex) {
		return $.messager.popover({msg: '����Ҫ������',type:'alert'});
	}
	if (!itemSRCValue) {
		return $.messager.popover({msg: '��ѡ����Դ��',type:'alert'});
	}
	var row=msTableData.rows[editMSIndex];
	var rowEditors=$('#middleSet').datagrid('getEditors',editMSIndex);
	console.log(rowEditors);
	var name="",positionRow="",positionColumn="",wholeLine="",showType="",showFormat="",ruleLocs="",ruleInvalidLocs="",shiftDesc="",methodExpression="";
	positionRow=$(rowEditors[2].target).val();
	positionColumn=$(rowEditors[3].target).val();
	wholeLine=$(rowEditors[4].target).checkbox('getValue');
	console.log(1);
	if (4==itemSRCValue) { //ͳ��������
		name=$(rowEditors[1].target).combobox('getValue');
		showFormat=$(rowEditors[5].target).combobox('getValue');
		ruleLocs=$(rowEditors[6].target).combobox('getValues');
		ruleInvalidLocs=$(rowEditors[7].target).combobox('getValues');
		shiftDesc=$(rowEditors[8].target).val();
		methodExpression=row.methodExpression;
		if (!name||!positionRow||!positionColumn||!showFormat) {
			return $.messager.popover({msg: '��Ŀ���ƣ���ʾλ�ú͸�ʽ����Ϊ�գ�',type:'alert'});
		}
	} else {
		name=getMSEditorTarget('name')[0].jdata.value;
		if ((name==parseInt(name))&&(name>0)) {
			return $.messager.popover({msg: '��Ŀ���Ʋ���Ϊ����������',type:'alert'});
		}
		showType=$(rowEditors[5].target).combobox('getValue');
		if (!name||!positionRow||!positionColumn||!showType) {
			return $.messager.popover({msg: '��Ŀ���ƣ���ʾλ�ã����Ͳ���Ϊ�գ�',type:'alert'});
		}
		if ('M'==showType) { //�û�¼��
			ruleLocs=$(rowEditors[6].target).combobox('getValues');
			ruleInvalidLocs=$(rowEditors[7].target).combobox('getValues');
			shiftDesc=$(rowEditors[8].target).val();
		} else {
			showFormat=$(rowEditors[6].target).combobox('getValue');
			ruleLocs=$(rowEditors[7].target).combobox('getValues');
			ruleInvalidLocs=$(rowEditors[8].target).combobox('getValues');
			shiftDesc=$(rowEditors[9].target).val();
			methodExpression=$(rowEditors[10].target).val();
			if (!showFormat||!methodExpression) {
				return $.messager.popover({msg: '��ʾ��ʽ����������Ϊ�գ�',type:'alert'});
			}
		}
	}
	var repeatCheck={};//�ظ�У��
	for (var i = 0; i < ruleLocs.length; i++) {
		repeatCheck[ruleLocs[i]]=1;
	}
	for (var i = 0; i < ruleInvalidLocs.length; i++) {
		if (repeatCheck[ruleInvalidLocs[i]]) {
			$.messager.popover({msg: '���÷�Χ�Ͳ����÷�Χ��������ͬѡ�',type:'alert'});
			return false;
		} else {
			repeatCheck[ruleInvalidLocs[i]]=1;
		}
	}
	// ���������ظ�
	console.log(msTableData);
	for (var i = msTableData.rows.length - 1; i >= 0; i--) {
		if (editMSIndex==i) continue;
		if ((positionRow==msTableData.rows[i].positionRow)&&(positionColumn==msTableData.rows[i].positionColumn)) {
			return $.messager.popover({msg: '�������Ѵ�����ͬ���ݣ�',type:'alert'});
		}
		if ((positionRow==msTableData.rows[i].positionRow)&&(wholeLine||("Y"==msTableData.rows[i].wholeLine))) {
			return $.messager.popover({msg: '����Ҫ�������ݺ��Ѵ��ڵĳ�ͻ��',type:'alert'});
		}
	}
	var obj={
		hospDR:hospID,
		wardType:wardID,
		id:msTableData.rows[editMSIndex].id||'',
		relationItem:msTableData.rows[editMSIndex].relationItem||'',
		itemSRC:itemSRCValue,
		name:name,
		positionRow:positionRow,
		positionColumn:positionColumn,
		wholeLine:wholeLine?'Y':'N',
		showType:showType||"A",
		showFormat:showFormat,
		ruleLocs:ruleLocs.join('|'),
		ruleInvalidLocs:ruleInvalidLocs.join('|'),
		shiftDesc:shiftDesc,
		methodExpression:methodExpression,
		positionType:1,
		activeFlag:"Y"
	}
	var updateRow=editMSIndex;
  var res=$cm({
    ClassName: 'Nur.SHIFT.Service.ShiftSetting',
    MethodName: 'AddOrUpdateShiftExchangeItem',
    dataType: "text",
    data:JSON.stringify(obj)
  },false);
	console.log(res);
  if ((res>-1)&&(res==parseInt(res))) {
    $.messager.popover({msg: '����ɹ���',type:'success'});
    $('#middleSet').datagrid('acceptChanges').datagrid('updateRow', {
      index: updateRow,
      row: {
      	id:msTableData.rows[updateRow].id||res,
      	name:name,
				showType:showType||"A",
				showFormat:showFormat,
      	methodExpression:methodExpression
      }
    });
		$('#middleSet').datagrid('endEdit',editMSIndex)
		editMSIndex=undefined;
		return true;
  } else {
    $.messager.popover({msg: res,type:'alert'});
    return false;
  }
}

function reloadLocsData() {
	var row=msTableData.rows[editMSIndex];
	// ���¼��ز�������
	getMSEditorTarget('ruleLocs').combobox({
    data:wardList,
    width:getMSEditorTarget('ruleLocs').parentsUntil('tr')[0].offsetWidth
	}).combobox('setValues',row.ruleLocs?row.ruleLocs.split(','):[]);
	getMSEditorTarget('ruleInvalidLocs').combobox({
		data:wardList,
    width:getMSEditorTarget('ruleInvalidLocs').parentsUntil('tr')[0].offsetWidth
	}).combobox('setValues',row.ruleInvalidLocs?row.ruleInvalidLocs.split(','):[]);
}

function updateTableHeight() {
	console.log(expandFlag);
	if ("statisticsSet"==expandFlag) {
		$('#statisticsSet').datagrid('resize',{
    	width: document.querySelector("hr.dashed").offsetWidth,
      height:window.innerHeight-106
    })
	} else {
		$('#middleSet').datagrid('resize',{
    	width: document.querySelector("hr.dashed").offsetWidth,
      height:window.innerHeight-106
    })
	}
}
function resizePageStyle() {
	updateTableHeight()
	setTimeout(function(){
		updateTableHeight()
	},800)
}
window.addEventListener("resize",resizePageStyle)
