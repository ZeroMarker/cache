/**
 * ����:	 ��������-ע����÷��ͼ���ά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.instruc.csp";
PHA_COM.App.Name = "PRC.ConFig.Instruc";
PHA_COM.App.Load = "";
$(function () {
	InitGridInst();
    InitGridForm();
    InitGridPrcInst();
    InitEvents();
    InitSetDefVal();
});

function InitEvents(){
	$("#btnAddInst").on("click", SavePrcInstBat);
	$("#btnAddForm").on("click", SavePrcInstBat);	
	$("#btnDel").on("click", DelPrcInstBat);
}


// ���-�÷�
function InitGridInst() {
    var columns = [
        [
            { field: "instId", title: 'instRowId',width: 100, hidden: true },
            { field: "insCheck", title: 'ѡ��', checkbox:'true',align:'center',width:30 },
            { field: "instDesc", title: '�÷�',align:'left',width: 280 }

        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Instruc',
            QueryName: 'SelectInstruc',
            rows:999
        },
        columns: columns,
        fitColumns:true,
        showHeader:true,
        singleSelect:false,
        pagination:false,
        toolbar: "#gridInstBar",
        onDblClickRow:function(rowIndex,rowData){
	        var instId = rowData.instId;
	        SavePrcInst(instId,'');
		}   
		
    };
    PHA.Grid("gridInst", dataGridOption);
}

//���-����
function InitGridForm() {
    var columns = [
        [
            { field: "formId", title: 'formRowId',width: 100, hidden: true },
            { field: "formCheck", title: 'ѡ��', checkbox:'true',align:'center',width:30 },
            { field: "formDesc", title: '����',align:'left',width: 280 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Instruc',
            QueryName: 'SelectForm',
            rows:999
        },
        columns: columns,
        fitColumns:true,
        showHeader:true,
        pagination:false,
        singleSelect:false,
        toolbar: "#gridFormBar",
        onDblClickRow:function(rowIndex,rowData){
	        var formId = rowData.formId;
	        SavePrcInst('',formId);
		}   
		
    };
    PHA.Grid("gridForm", dataGridOption);
}

//���-��ά���б�
function InitGridPrcInst() {
    var columns = [
        [
            { field: "prcInstId", title: 'prcInstId',width: 100, hidden: true },
            { field: "prcInstCheck", title: 'ѡ��', checkbox:'true',align:'center',width:30 },
            { field: "prcInstDesc", title: '�÷�',align:'left',width: 270 },
            { field: "prcFormDesc", title: '����',align:'left',width: 280 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Instruc',
            QueryName: 'SelectPrcInst',
            rows:999
        },
        columns: columns,
        singleSelect:false,
        pagination:false,
        toolbar: "#gridPrcInstBar",
        onDblClickRow:function(rowIndex,rowData){
	        var prcInstId = rowData.prcInstId;
			var delInfo = "��ȷ��ɾ����?"
			PHA.Confirm("ɾ����ʾ", delInfo, function () {
				Delete(prcInstId);
			})
	        
		}   
    };
    PHA.Grid("gridPrcInst", dataGridOption);
}

/// ������Ϣ��ʼ��
function InitSetDefVal() {
	
	var type=tkMakeServerCall("PHA.PRC.ConFig.Instruc","GetPrcInstType")
	//alert("type:"+type)
	if (type=="form"){
		$('#tabsInstForm').tabs('select', "����");
		$('#tabsInstForm').tabs('disableTab', "�÷�");
	}
	else if (type=="inst"){
		$('#tabsInstForm').tabs('select', "�÷�");
		$('#tabsInstForm').tabs('disableTab', "����");	
	}
	else{
		$('#tabsInstForm').tabs('enableTab', "�÷�");	
		$('#tabsInstForm').tabs('enableTab', "����");	
		}
	

}

/// ��������ע����÷�
function SavePrcInstBat(){
	var selTabObj = $('#tabsInstForm').tabs('getSelected');	
	var tabIndex = $('#tabsInstForm').tabs('getTabIndex',selTabObj);
	var instStr="",formStr=""
	if (tabIndex=="0"){		//���÷�����
		var rows = $('#gridInst').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫ���ӵ��÷�", "warning");
	        return;
	    }
	    for (var pnum = 0; pnum < rows.length; pnum++) {
	        var instId = rows[pnum].instId;
	        if (instStr==""){
		        instStr = instId
		    }else{
			    instStr = instStr + "^" + instId
			}
	    
    	}
	}
    else if (tabIndex=="1"){
	    var rows = $('#gridForm').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫ���ӵļ���", "warning");
	        return;
	    }
	    for (var pnum = 0; pnum < rows.length; pnum++) {
	        var formId = rows[pnum].formId;
	        if (formStr==""){
		        formStr = formId
		    }else{
			    formStr = formStr + "^" + formId
			}
	    
    	}
	}

    var saveBatRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "SavePrcInstByBat", instStr, formStr);
    var saveBatArr = saveBatRet.split("^");
    var saveBatVal = saveBatArr[0];
    var saveBatInfo = saveBatArr[1];
    if (saveBatVal < 0) {
        $.messager.alert("��ʾ", saveBatInfo, "warning");
    }
    else{
	    $.messager.alert("��ʾ", "���ӳɹ�", "success");
	}
	$('#gridInst').datagrid("reload");
	$('#gridForm').datagrid("reload");
    $('#gridPrcInst').datagrid("reload");
	
}

function SavePrcInst(instId,formId) {
    var saveRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "SavePrcInst",instId, formId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    else{
	    $.messager.alert("��ʾ", "���ӳɹ�", "success");
	}
    $('#gridPrcInst').datagrid("reload");
    InitSetDefVal() ;
}

/// ����ɾ��
function DelPrcInstBat(){
	
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		var rows = $('#gridPrcInst').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫɾ���ļ�¼", "warning");
	        return;
	    }
	    var prcInstIdStr=""
	    for (var cnum = 0; cnum < rows.length; cnum++) {
	        var prcInstId = rows[cnum].prcInstId;
	        if (prcInstIdStr==""){
		        prcInstIdStr = prcInstId
		    }else{
			    prcInstIdStr = prcInstIdStr + "^" + prcInstId
			}
		    
	    }

	    var delBatRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "DelPrcInstByBat", prcInstIdStr);
	    var delBatArr = delBatRet.split("^");
	    var delBatVal = delBatArr[0];
	    var delBatInfo = delBatArr[1];
	    if (delBatVal < 0) {
	        $.messager.alert("��ʾ", delBatInfo, "warning");
	    }
	    else{
		    $.messager.alert("��ʾ", "ɾ���ɹ�", "success");
		}
	    $('#gridPrcInst').datagrid("reload");
	    InitSetDefVal() ;
    })
}

function Delete(prcInstId) {
	
    var saveRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "DelPrcInst", prcInstId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    else{
	    $.messager.alert("��ʾ", "ɾ���ɹ�", "success");
	}
    $('#gridPrcInst').datagrid("reload");
    InitSetDefVal() ;
}





