var hospId=session['LOGON.HOSPID']
var HospEnvironment=true;
var GV = {
    ClassName: "NurMp.DHCNURTemPrintLInk",
};
var init = function () {
	if (typeof GenHospComp == "undefined") {
		HospEnvironment=false;
	}
	if(HospEnvironment){
		initHosp();
	}else{
		var hospDesc=tkMakeServerCall("NurMp.DHCNURTemPrintLInk","GetHospDesc",session['LOGON.HOSPID'])
		$("#_HospList").val(hospDesc)
		$('#_HospList').attr('disabled',true);
		//$("#_HospListLabel").css("display","none")
    	//$("#_HospList").css("display","none")
	}
	
    initPageDom();
	initEvent();
}
$(init)
function initHosp(){
	
	var hospComp = GenHospComp("Nur_IP_DHCNURTemPrintLInk",session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']);  
	///var hospComp = GenHospComp("ARC_ItemCat")
	///alert(hospComp.getValue());     //获取下拉框的值
	hospComp.options().onSelect = function(){
		if(HospEnvironment) hospId=$HUI.combogrid('#_HospList').getValue()
		var value=$HUI.searchbox('#search').getValue()
		
		$('#TemplateLinkGrid').datagrid('reload', {
			ClassName: GV.ClassName,
			MethodName: "GetCRItem",
			code:value,
			hospId:hospId
		});
	}  ///选中事件
	hospId = hospComp.options().value;

}
function initEvent() {
    //$('#insertRowBtn').bind('click', append)
	//$('#saveRowBtn').bind('click', accept)
	//$('#deleteRowBtn').bind('click', removeit)
	
	$('#search').searchbox({
		searcher: function(value) {
			$('#TemplateLinkGrid').datagrid('reload', {
				ClassName: GV.ClassName,
				MethodName: "GetCRItem",
				code:value,
				hospId:hospId
			});
		},
		prompt: '请输入打印或界面模板的关键字或名称'
	});
}
function initPageDom() {
	var toolbar = [{
        text: '增加',
        iconCls: 'icon-add',
        handler: append
    }, '-', {
        text: '删除',
        iconCls: 'icon-remove',
        handler: removeit
    }, '-', {
        text: '保存',
        iconCls: 'icon-save',
        handler: accept
    }];
		
	 $HUI.datagrid('#TemplateLinkGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            MethodName: "GetCRItem",
			code:"",
			hospId:hospId
        },
        toolbar: toolbar,
        columns: [[
            { field: 'Name', title: '界面模板名称', width: 260, editor: 'validatebox' },
			{ field: 'Code', title: '界面模板关键字', width: 260, editor: 'validatebox' },
			{ field: 'PrintName', title: '打印模板名称', width: 260, editor: 'validatebox' },
			{ field: 'PrintCode', title: '打印模板关键字', width: 260, editor: 'validatebox' },
            { field: 'XuFlag', title: '是否续打', hidden:true,width: 100, formatter: function (value, row) {
                    return row.XuFlagDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
						panelHeight:"auto",
                 		editable:false,
                		enterNullValueClear:false,
                        data: [
                            { value: "True", desc: "是" },
                            { value: "False", desc: "否" }
                        ]
                    }
                }
            },
            { field: 'MakePic', title: '是否生成图片', hidden:true, width: 100, formatter: function (value, row) {
                    return row.MakePicDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
						panelHeight:"auto",
                 		editable:false,
                		enterNullValueClear:false,
                        data: [
                            { value: "True", desc: "是" },
                            { value: "False", desc: "否" }
                        ]
                    }
                }
            },
			{ field: 'UploadFTP', title: '归档', width: 100, formatter: function (value, row) {
                    return row.UploadFTPDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
						panelHeight:"auto",
                        required: false,
                 		editable:false,
                		enterNullValueClear:false,
                        data: [
                            { value: "True", desc: "是" },
                            { value: "False", desc: "否" }
                        ]
                    }
                }
            },
			{ field: 'rw', title: 'ID', width: 50, hidden:true,editor: 'validatebox' }
        ]],
        idField: 'rw',
        rownumbers: true,
		singleSelect:true,
        onDblClickRow: onDblClickRow,
    })
}
var editIndex = undefined;
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($('#TemplateLinkGrid').datagrid('validateRow', editIndex)) {
        $('#TemplateLinkGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#TemplateLinkGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#TemplateLinkGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    if (endEditing()) {
        $('#TemplateLinkGrid').datagrid('appendRow', { status: 'P' });
        editIndex = $('#TemplateLinkGrid').datagrid('getRows').length - 1;
        $('#TemplateLinkGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function removeit() {
	  var rec = $('#TemplateLinkGrid').datagrid('getSelected');
	  
	  if(rec&&rec.rw!=""){
		$.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
			if (r) {			  
				$cm({
					ClassName: GV.ClassName,
					MethodName: "QtDelete",
					id: rec.rw
				}, function (txtData) {
					if (txtData == '0') {
						endEditing();
						$.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
						$('#TemplateLinkGrid').datagrid('reload')
					}
					else {
						$.messager.popover({ msg: '删除失败:' + txtData, type: 'alert', timeout: 1000 });
					}
				});
			}
		});
	  }else{
		  $.messager.popover({ msg: '请选中需要删除的记录', type: 'alert', timeout: 1000 });
	  }
}
function accept() {
    if (endEditing()) {
        saveLink();
        $('#TemplateLinkGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#TemplateLinkGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#TemplateLinkGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveLink() {
    var rows = $('#TemplateLinkGrid').datagrid('getChanges');
	
	//alert(hospId)
    rows.forEach(function (row) {
        var para = "rw|"+row.rw + "^Code|"+ row.Code + "^Name|" + row.Name + "^PrintCode|" + row.PrintCode + "^PrintName|" + row.PrintName + "^MakePic|" + row.MakePic + "^XuFlag|" + row.XuFlag +"^UploadFTP|"+row.UploadFTP;
		$cm({
			ClassName: GV.ClassName,
			MethodName: "SaveNew",
			parr: para,
			id:row.rw,
			hospId:hospId
		}, function (txtData) {
			if (txtData.status == '0') {
				$.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
				$('#TemplateLinkGrid').datagrid('reload');
			}
			else {
				$.messager.popover({ msg:  txtData.msg, type: 'alert', timeout: 1000 });
			}
		});
	});
    
}