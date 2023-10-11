/**
 * desc:    ��ȫ���������ά��(�����Ȩ)
 * creator: Huxt 2019-09-12
 * scripts/pha/mob/v2/grouploc.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
$(function() {
	$g('��');
	$g('��');
	InitDict();
    InitGridGroup();
    InitGridGroupLoc();
});

// ��ʼ�� - ��ȫ���б�
function InitDict(){
	PHA.SearchBox('groupText', {
		searcher: Query,
		width: 417,
		placeholder: $g("���밲ȫ������ƻ��ƴ") + "..."
	});
	PHA.SearchBox('groupLocText', {
		searcher: QueryGroupLoc,
		width: 417,
		placeholder: $g("������ҵ����ƻ��ƴ") + "..."
	});
	InitHospCombo();
}

// ��ʼ�� - ��ȫ���б�
function InitGridGroup() {
    var columns = [
        [
            { field: "RowId", title: 'RowId', hidden: true },
            { field: 'Description', title: '��ȫ������', width: 225, sortable: 'true'}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.STORE.Org',
            QueryName: 'SSGroup',
            HospId: HospId
        },
        columns: columns,
        fitColumns: true,
        toolbar: "#gridGroupBar",
        onClickRow: function(rowIndex, rowData) {
            QueryGroupLoc();
        }
    };
    PHA.Grid("gridGroup", dataGridOption);
}

// ��ʼ�� - ��ȫ������б�
function InitGridGroupLoc() {
    var columns = [
        [
        	{ field: "grpLocRowId", title: 'grpLocRowId', hidden: true},
            { field: "locId", title: 'locId', hidden: true},
            { field: 'locCode', title: '���Ҵ���', width: 225, sortable: true},
            { field: 'locDesc', title: '��������', width: 225, sortable: true},
            { field: 'activeFlag', title: '�Ƿ�����', align:'center', formatter: FormatterYes}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.MOB.GroupLoc.Query',
            QueryName: 'GroupLoc'
        },
        singleSelect: true,
        columns: columns,
        toolbar: "#gridGroupLocBar",
        onDblClickCell: function(index, field, value){
	        var retActiveFlag = "N";
	        if(value == "Y"){
		        retActiveFlag = "N";
		    } else {
			    retActiveFlag = "Y";
			}
			SaveGroupLoc(index, retActiveFlag); 
	    }
        
    };
    PHA.Grid("gridGroupLoc", dataGridOption);
}

// ��ѯ - ��ȫ��
function Query(){
	var groupText = $('#groupText').searchbox('getValue') || "";
	$('#gridGroup').datagrid("load", {
		ClassName: 'PHA.STORE.Org',
		QueryName: 'SSGroup',
		QText: groupText,
		HospId: HospId
	});
	$('#gridGroupLoc').datagrid('clear');
}

// ��ѯ - ��ȫ���¶�Ӧ�Ŀ���
function QueryGroupLoc(){
	var groupLocText = $('#groupLocText').searchbox('getValue') || "";
	var gridSelect = $('#gridGroup').datagrid("getSelected");
    if (gridSelect == null) {
        return;
    }
    var groupId = gridSelect.RowId || "";
    if(groupId == ""){
	    return;
	}
	var pJsonStr = JSON.stringify({
		groupId: groupId
	});
	$('#gridGroupLoc').datagrid("load", {
		ClassName: 'PHA.MOB.GroupLoc.Query',
		QueryName: 'GroupLoc',
		QText: groupLocText,
		pJsonStr: pJsonStr
	});
}

// ���氲ȫ������¿��ҵĿ���״̬
function SaveGroupLoc(index, activeFlag){
	var eaRows = $('#gridGroupLoc').datagrid('getRows');
	var grpLocRowId = eaRows[index].grpLocRowId || "";
	var retStr = tkMakeServerCall("PHA.MOB.GroupLoc.Save", "SaveGroupLoc", grpLocRowId, activeFlag);
	var retArr = retStr.split("^");
	if(retArr[0] < 0) {
		$.messager.alert("��ʾ", "����ʧ��" + retArr[1], "warning");
	} else {
		$.messager.popover({
			msg: "����ɹ�!",
			type: "success",
			timeout: 1000
		});
		QueryGroupLoc();
	}
}

// ������Ϣ
function ShowHelpTips(){
	var winId = "helpWin";
	var winContentId = "helpWin_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 400,
	    	height: 300,
	    	modal: true,
	    	title: '����',
	    	iconCls: 'icon-w-list',
	    	content: "<div id='" + winContentId + "'style='margin:10px;'>" + GetContentHtml() + "</div>",
	    	closable: true
		});
	}
	$('#' + winId).dialog('open');
	
	// ����
	function GetContentHtml(){
		var cHtml = "";
		cHtml += "<p style='line-height:28.5px;'>1��ѡ����లȫ���б��еİ�ȫ�飬��ѯ���Ҳ�Ŀ����б�<p>";
		cHtml += "<p style='line-height:28.5px;'>2������Ҳ��û�ж�Ӧ�Ŀ�����Ϣ������Ҫ������������->��ȫ��->�����Ȩ���������Ҫ�Ŀ��ң�<p>";
		cHtml += "<p style='line-height:28.5px;'>3��˫�����Ƿ����á��п���ά���ð�ȫ���£��ƶ��˻�ȡ����ʱ�Ƿ���Ի�ȡ�ð�ȫ���¸ÿ��ҵĴ�����<p>";
		return cHtml;
	}
}

// ��ʽ��
function FormatterYes(value, row, index) {
	if (value == "Y"){
		return '<label style="cursor:pointer;"><font color="#21ba45">��</font></label>';
	} else {
		return '<label style="cursor:pointer;"><font color="#f16e57">��</font></label>';
	}
}

function InitHospCombo() {
	var genHospObj=PHA_COM.GenHospCombo({tableName:'PHAIP_LabelConfig'});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                
            }
        }
    }
}
