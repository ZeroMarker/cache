var PageLogicObj = {
    RowId: "",
    m_InterfaceLogDataGrid: "",
}
$(function() {
    Init();
    InitEvent();
})

$(window).load(function() {
	InitTip();
})

function Init() {
    InitProductLine();
    InitInterfaceLogDataGrid();
    ReLoadLogRegListTab();
    //��ʼ��head����
    InitParamsStyle("LogSuccess");
    //$("#LogSuccess").disabled()
    //$('#LogSuccess').textbox('disable');
}

function InitEvent() {
    $("#Find").click(ReLoadLogRegListTab);
    $("#SaveLogBtn").click(SaveLogData);
}

function AddClickHandle() {
    PageLogicObj.RowId = "";
    ClearDetailContent();
    $("#LogRegDetail").window('open');
    $("#interfaceCode").focus();
}

function ClearDetailContent() {
    $('#LogCode,#LogDesc,#productLinkGroup,#LogNote,#LogDays,#LogSuccess').val("");
    $('#productLine').combobox('select', "");
    $("#LogStatus").combobox('select', "Y");
    $('#LogFlag').checkbox('setValue', false);
}

function SaveLogData() {
    var LogType = $('#LogType').combobox('getValue');
    var LogCode = $('#LogCode').val().replace(/\ /g, "");
    if (LogCode == "") {
        $.messager.alert('��ʾ', "��������־����!", "info", function() {
            $('#LogCode').focus();
        });
        return false;
    }
    var LogDesc = $('#LogDesc').val().replace(/\ /g, "");
    if (LogDesc == "") {
        $.messager.alert('��ʾ', "��������־����!", "info", function() {
            $('#LogDesc').focus();
        });
        return false;
    }
    var productLine = $("#productLine").combobox('getValue');
    if (!productLine) {
        $.messager.alert('��ʾ', "�������Ʒ��!", "info", function() {
            $('#productLine').next('span').find('input').focus();
        });
        return false;
    }
    var LogStatus = $("#LogStatus").combobox('getValue');
    var LogFlag = $("#LogFlag").checkbox('getValue') ? "Y" : "N";
    var productLinkGroup = $('#productLinkGroup').val().replace(/\ /g, "");
    var LogNote = $('#LogNote').val();
    LogNote = ReplaceTextarea1(LogNote);
    var LogDays = $('#LogDays').val();
    var LogSuccessJson = $('#LogSuccess').val();
    
    var LogObj = {
        LogID: PageLogicObj.RowId,
        LogType: LogType,
        LogCode: LogCode,
        LogDesc: LogDesc,
        productLine: productLine,
        productLinkGroup: productLinkGroup,
        LogStatus: LogStatus,
        LogFlag: LogFlag,
        LogDays: LogDays,
        LogSuccessJson: LogSuccessJson,
        LogNote: LogNote
    }
    var LogInfo = JSON.stringify(LogObj);

    var Ret = $.m({
        ClassName: "web.DHCDocInterfaceLog",
        MethodName: "SaveLogRegistInfo",
        LogInfo: LogInfo,
        JsonInfo: ""
    }, false);
    var Code = Ret.split("^")[0];
    var Desc = Ret.split("^")[1];
    if (Code != 0) {
        $.messager.alert('��ʾ', "����ʧ�ܣ�" + Desc, "info");
    } else {
        $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
        PageLogicObj.RowId = "";
        ReLoadLogRegListTab();
        $('#LogRegDetail').window('close');
    }
}

function ReLoadLogRegListTab() {
    var LogType = $('#SLogType').combobox('getValue');
    var LogCode = $('#SLogCode').val().replace(/\ /g, "");
    var LogDesc = $('#SLogDesc').val().replace(/\ /g, "");
    var LogStatus = $("#SLogStatus").combobox('getValue');
    var LogFlag = $("#SLogFlag").combobox('getValue');
    var ProductLine = "";
    var ProductLineArr = $("#SProductLine").combobox('getValues');
    for (var i = 0; i < ProductLineArr.length; i++) {
        if (ProductLine == "") ProductLine = ProductLineArr[i];
        else ProductLine = ProductLine = ProductLine + "#" + ProductLineArr[i];
    }

    var Input = LogType + "^" + LogCode + "^" + LogDesc + "^" + LogStatus + "^" + LogFlag + "^" + ProductLine;

    $.cm({
        ClassName: "web.DHCDocInterfaceLog",
        QueryName: "FindLogRegist",
        Input: Input,
        rows:99999
    }, function(GridData) {
        PageLogicObj.m_InterfaceLogDataGrid.datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
        $("#LogRegListTab").datagrid('clearSelections');
    });
}

function InitInterfaceLogDataGrid() {
    var toolbar = [
	    {
	        text: '����',
	        iconCls: 'icon-add',
	        handler: function() { AddClickHandle(); }
	    },'-',{
			id:"tip",
			text: '˵��',
			iconCls: 'icon-help',
			handler: function(){
				InitTip();
				$("#tip").popover('show');
			}
    	}
    ];
    var Columns = [
        [
            { field: 'ID', title: 'ID', width: 20, hidden: 'true' },
            { field: 'ColOper', title: '�в���', width: 150,
                formatter: function(v, rec, index) {
                    var editBtn = '<a href="#this" class="editcls1" onclick="EditRow(' + (rec.ID + ',' + index) + ')"></a>';
                    var deleteBtn = '<a href="#this" class="deletecls" onclick="DeleteRow(' + (rec.ID + ',' + index) + ')"></a>';
                    var logBtn = '<a href="#this" class="logcls" onclick="UpdateLog(' + (rec.ID + ',' + index) + ')"></a>';
                    if (rec.LogFlag == "Y") {
                        logBtn = '<a href="#this" class="slogcls" onclick="UpdateLog(' + (rec.ID + ',' + index) + ')"></a>';
                    }
                    return editBtn + " " + deleteBtn + " " + logBtn;
                }
            },
            { field: 'LogCode', title: '��־����', width: 200 },
            { field: 'LogDesc', title: '��־����', width: 200 },
            { field: 'LogType', title: '��־����', width: 100, align: "center" },
            { field: 'LogStatus', title: '״̬', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogStatus = (rec.LogStatus == "Y") ? "����" : "ͣ��";
                    return LogStatus;
                }
            },
            { field: 'LogFlag', title: '��¼��־', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.LogFlag == "Y") ? "��" : "��";
                    return LogFlag;
                }
            },
            { field: 'LogNote', title: '��ע', width: 200, align: "center",
            	formatter: function(v, rec, index) {
	            	var LogNote = ReplaceTextarea2(v);
	            	return LogNote; 
	            }
            },
            { field: 'InsertDate', title: '��������', width: 120, align: "center" },
            { field: 'InsertTime', title: '����ʱ��', width: 100, align: "center" },
        ]
    ]
    var interfaceLogDataGrid = $("#LogRegListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'id',
        columns: Columns,
        toolbar: toolbar,
        onLoadSuccess: function(data) {
	    ChangeButtonText($('.editcls1'),"�޸�","icon-write-order");
            ChangeButtonText($('.deletecls'),"ɾ��","icon-cancel");
            ChangeButtonText($('.logcls'),"����־","icon-cal-pen");
            ChangeButtonText($('.slogcls'),"������־","icon-red-cancel-paper");
        },
        detailFormatter: function(rowIndex, rowData) {
            return "<div id='detailDiv" + rowIndex + "' style='color:black;height:auto;'><div/>";;
        },
        rowStyler: function(index, row) {
            if (row.LogStatus != 'Y') {
                return 'background-color:#FFC1C1;color:#fff;';
            }
        }
    });
    PageLogicObj.m_InterfaceLogDataGrid = interfaceLogDataGrid;
    return interfaceLogDataGrid;
}

function EditRow(ID, index) {
    PageLogicObj.RowId = ID;
    ClearDetailContent();
    $("#LogRegListTab").datagrid('selectRow', index);
    var JsonStr = $.m({
        ClassName: "web.DHCDocInterfaceLog",
        MethodName: "GetLogRegistInfo",
        Input: ID
    }, false);
    var Obj = JSON.parse(JsonStr);
    $("#LogCode").val(Obj.LogCode);
    $("#LogDesc").val(Obj.LogDesc);
    $("#productLinkGroup").val(Obj.LogProductLinkGroup);
    $("#LogNote").val(Obj.LogNote);
    $("#LogType").combobox('select', Obj.LogType);
    $('#productLine').combobox('select', Obj.ProductLine);
    $('#LogStatus').combobox('select', Obj.LogStatus);
    $('#LogFlag').checkbox('setValue', (Obj.LogFlag == "Y") ? true : false);
    var LogNote = Obj.LogNote;
    	LogNote = ReplaceTextarea2(LogNote);
    $("#LogNote").val(LogNote);
    $('#LogDays').val(Obj.LogDays);
    $('#LogSuccess').val(Obj.LogSuccessJson);

    $("#LogRegDetail").window('open');
    $("#LogCode").focus();
}

function DeleteRow(ID, index) {
    $("#LogRegListTab").datagrid('selectRow', index);
    $.messager.confirm("������ʾ", "��ȷ��Ҫִ��ɾ��������", function(r) {
        if (r) {
            var Ret = $.m({
                ClassName: "web.DHCDocInterfaceLog",
                MethodName: "DeleteLogRegistInfo",
                Input: ID
            }, false);
            var Code = Ret.split("^")[0];
            var Desc = Ret.split("^")[1];
            if (Code == "0") {
                $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
                ReLoadLogRegListTab();
            } else {
                $.messager.alert('��ʾ', Desc);
            }
        }
    })
}

function UpdateLog(ID, index) {
    $("#LogRegListTab").datagrid('selectRow', index);
    var LogFlag = "";
    var Obj = $("#LogRegListTab").datagrid('getSelected');
    if (Obj != null) {
        LogFlag = Obj.LogFlag;
    }
    var LogFlag = (LogFlag == "Y") ? "N" : "Y";
    $.messager.confirm("������ʾ", "��ȷ��Ҫִ���޸Ĳ�����", function(r) {
        if (r) {
            var Ret = $.m({
                ClassName: "web.DHCDocInterfaceLog",
                MethodName: "UpdateLogRegistInfo",
                Input: ID + "^" + LogFlag
            }, false);
            var Code = Ret.split("^")[0];
            var Desc = Ret.split("^")[1];
            if (Code == "0") {
                $.messager.popover({ msg: '�޸ĳɹ���', type: 'success', timeout: 1000 });
                ReLoadLogRegListTab();
            } else {
                $.messager.alert('��ʾ', Desc);
            }
        }
    })
}

function ReplaceTextarea1(str) {
    var reg = new RegExp("\n", "g");
    var reg1 = new RegExp(" ", "g");
    str = str.replace(reg, "<br>");
    str = str.replace(reg1, "<p>");
    return str;
}

function ReplaceTextarea2(str) {
    var reg = new RegExp("<br>", "g");
    var reg1 = new RegExp("<p>", "g");
    str = str.replace(reg, "\n");
    str = str.replace(reg1, " ");
    return str;
}

function InitProductLine() {
    $HUI.combobox("#SProductLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        rowStyle: 'checkbox',
        multiple: true,
        editable: false
    });
    $HUI.combobox("#productLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        editable: false
    });
}

function InitParamsStyle(id) {
	LoadCombo2Css();
	var html = "<div id='DiagWin' style='width:150px'>";
		html += "	<table class='search-table' style='margin:0 auto;border:none;'>";
		html += "		<tr>";
		html += "			<td class='r-label'>�̶���ʶ</td>";
		html += "			<td><input class='hisui-checkbox' type='checkbox' id='FixedFlag'/></td>";
		html += "			<td class='r-label'>^�ָ�</td>";
		html += "			<td><input class='hisui-checkbox' type='checkbox' id='Delimiter'/></td>";
		html += "		</tr>";
		html += "	</table>";
		html += "</div>";
	
	var target = $('#' + id)[0];    		       
    initKeyValueBox(target, {
        panelWidth: 600,
        panelHeight: 250,
        parseValue: parseValue,
        formatValue: formatValue,
        descEditor: 'text',
        singleRow:"Y",
        innerhtml:html,
        keyTitle:"�ָ���",
        valueTitle:"�ָ�λ",
        descTitle:"У��ֵ",
        callback:LoadFixedFlag
    });    
   
    function formatValue(o) {
	    var FixedFlag=$HUI.checkbox("#FixedFlag").getValue();
        var arr = [];
        $.each(o, function() {
	        if (!FixedFlag){
		    	if ((this.key != "")&&(this.value==""||this.desc=="")) {
			    	dhcsys_alert("�зָ��ʱ���ָ�λ���ж�ֵ����Ϊ�գ������룡");
			    	return false;
			    }
		    }
            arr.push({ key: this.key, value: this.value, desc: this.desc, FixedFlag:FixedFlag});
        })
        if (arr.length==0) return false;
        return JSON.stringify(arr);
    }

    function parseValue(str) {
        try {
            var arr = $.parseJSON(str);
        } catch (e) {
            var arr = [];
        }	    
        var FixedFlag=false;
        var all = [];
        if (arr.length==0){
	    	all.push({ key: '', desc: '', value: '', custom: true});
        }else{
	        $.each(arr, function() {
	            all.push({ key: this.key, value: this.value, desc: this.desc, custom: true, FixedFlag:this.FixedFlag });
	            FixedFlag=this.FixedFlag;
	        })
        }
        setTimeout(function(){
	    	$HUI.checkbox("#FixedFlag").setValue(FixedFlag);
	    	//��Ϊ�ᱻchange�¼�����
	    	$('#combo2-panel-content-dg').datagrid("loadData", all);
	    }, 300);
        return all;
    }
}

function LoadFixedFlag(){
	$HUI.checkbox("#FixedFlag",{
		onCheckChange:function(e,value){
			var optionk = $('#combo2-panel-content-dg').datagrid("getColumnOption", "key");
			var optionv = $('#combo2-panel-content-dg').datagrid("getColumnOption", "value");
			var optiond = $('#combo2-panel-content-dg').datagrid("getColumnOption", "desc");
			optionk.title=value?"�жϴ���":"�ָ���";
			optionv.title=value?"�ж�ֵ":"�ָ�λ";
			optiond.title=value?"˵��":"�ж�ֵ";
			$('#combo2-panel-content-dg').datagrid().datagrid("loadData", [{ key: '', desc: '', value: '', custom: true}]);
		}
	});
	
	$HUI.checkbox("#Delimiter",{
		onCheckChange:function(e,value){
			var FixedFlag=$HUI.checkbox("#FixedFlag").getValue();
			if ((!FixedFlag)&&(value)){
				$('#combo2-panel-content-dg').datagrid("beginEdit", 0);
				var ed = $('#combo2-panel-content-dg').datagrid('getEditor', {index:0,field:'key'});
				$(ed.target).val('"^"'); 
				$('#combo2-panel-content-dg').data('editindex','0');
			}
		}
	})
}

function ChangeButtonText(element,desc,icon){
	$(element).linkbutton({iconCls: icon, plain: true});
	$(element).popover({content: desc, placement: 'top-right', trigger: 'hover'});
}

function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>ҽ��վ�ӿ���־ע��ʹ��˵��</li>" + 
		"<li>1���ӿ���־ע����������Ҫ��¼�ӿڵ�����μ�����ֵ�ĳ���������HIS�ڲ���־���͵Ľӿڣ������첽��ʽ��¼����ֹ�������ݻع���������־���Ͳ���ͬ����ʽ��¼��־��</li>" +
		"<li>2��ҽ��վ�ӿ�ע���Doc_InterfaceMethod ����־ע���: CF_DOC_Interface.LogRegist ����־��¼��DOC_Interface.Log</li>" +
		"<li>3���������ò���(����˵��)��" +
		"<li><span>��־�������Soap�����ԣ�W.��ͷ��Http�����ԣ�H.��ͷ��JS���ԣ�J.��ͷ</span></li>" + 
		"<li><span>����ʱ��(��)����־�������Чʱ��(Ĭ��3��)</span></li>" + 
		'<li><span>�ɹ���ʶ��У��ӿڷ���ֵ�Ƿ�ɹ���˵����1.�̶����ش�������У��ֵ(����������Ҫ��"")��2.�ָ���жϣ����÷ָ�����ָ�λ��У��ֵ��</span></li>' +
		'<li><span></span><span>3.�̶��ֶ�ֵ����ѡ�̶���ʶ�������жϴ��롢�ж�ֵ��</span></li>' + 
		"<li>4�����÷�ʽ��</li>" +
		"<li><span>1.��̨������������̳У�DHCDoc.Util.RegisteredObject.cls������ã�d $$$DocLogObj.SaveInterfaceLog(��־Code, Json��, ����ֵ, ���...)</span></li>" + 
		'<li><span>ʾ����s rtn=$$$DocLogObj.SaveInterfaceLog("LogTest","","����ֵ����","���1","���2","���3")</span></li>' + 
		"<li><span>2.ǰ̨������js����̳У�scripts/dhcdoc/tools/tools.hui.js������ã�DocLogObj.SaveInterfaceLog(��־Code, Json��, ����ֵ, ���...)</span></li>" + 
		'<li><span>ʾ����var rtn=DocLogObj.SaveInterfaceLog("LogTest","","����ֵ����","���1","���2","���3")</span></li>' + 
		"<li><span>3.ֱ�ӵ��ã�����û�м̳����js�ĵط���ֱ�ӵ��÷�����##class(web.DHCDocInterfaceLog).SaveInterfaceLog(��־Code, Json��, ����ֵ, ���...)</span></li>" 

	$("#tip").popover({
		trigger:'hover',
		content:_content
	});
}
