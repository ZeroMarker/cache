/**
 * ģ��:     �Ƽ���Ϣά��
 * ��д����: 2018-07-04
 * ��д��:   zhaozhiduan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var inmanuurl="dhcst.inmanuorderaction.csp"
var GridCmgInc,GridCmgUom;
var curEditInci=""
$(function() {
    
	InitDict();
    InitGridDrugInfo();
     
    $('#btnFind').on("click", Query);
    
    //ά��div
    InitGridRcpInfo();
    InitGridInrecIngr();
	$('#btnSaveInRcp').on("click", SaveInRcp);
    $('#btnAddInRcp').on("click", AddInRcp);
    $('#btnDelInRcp').on("click", DelInRcp);
    //�Ƽ�ԭ��
    $('#btnSaveInRecIngr').on("click", SaveInRecIngr);
    $('#btnAddInRecIngr').on("click", AddInRecIngr);
    $('#btnDelInRecIngr').on("click", DelInRecIngr);
})


function InitDict() {
    
    // ҩƷ
    DHCST.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { placeholder: "ҩƷ..." }); // width: 315
     // ������
    DHCST.ComboBox.Init({ Id: 'cmbStkCat', Type: 'StkCat' }, { placeholder: "������..." });
	
	GridCmgInc = DHCST.GridComboGrid.Init({ Type: "IncItm" }, {
        required: true,
        idField: 'InRinDesc',
        textField: 'InRinDesc',
        checkOnSelect: false,
        selectOnCheck: false,
        hasDownArrow: false,
        //pageSize: 10,
        //pageList: [10, 30, 50],
        onHidePanel: function() {
	    	var editIndex = $("#gridInRecIngr").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var incEd = $("#gridInRecIngr").datagrid('getEditor', { index: editIndex, field: 'InRinDesc' });
            var rowData = $(incEd.target).combogrid("grid").datagrid("getSelected");
            if ((rowData == "") || (rowData == null)) {
                return;
            }
            var gridSelect = $('#gridInRecIngr').datagrid("getSelected");
            var InRinUomEd = $("#gridInRecIngr").datagrid('getEditor', { index: editIndex, field: 'InRinUomId' });
            
            gridSelect.InRinCode = rowData.incCode;
            gridSelect.InRinInci = rowData.incRowId;
            gridSelect.InRinDesc = rowData.incDesc;
            curEditInci=rowData.incRowId;
            $(InRinUomEd.target).combobox("reload");
            
        },
        onBeforeLoad: function(param) {
	        curEditInci=$('#gridInRecIngr').datagrid("getSelected").InRinInci;
            if (param.q == undefined) {
                param.q = $('#gridInRecIngr').datagrid("getSelected").InRinDesc;
                
            }
            param.filterText = param.q; 
        }
    });
   GridCmgUom = DHCST.GridComboBox.Init({ Type: "Uom" }, {
        required: true,
        editable: true,
        onBeforeLoad: function(param) {
	        var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
			if(gridSelect==null){
        		return;
			}
			var Inci=(gridSelect.Inci || "")
	
            param.inputStr =Inci; 
            param.filterText = param.q;
        },
        onLoadSuccess: function(data) {
	        var len=data.length;
            if (len > 0) {
                var selectUom = $('#gridInRcp').datagrid("getSelected").UomId || "";
                var finalUom=""
                // Ĭ�ϵ�λ
                for(var i=0;i<len;i++){
	                var iUom=data[i].RowId;
	                if (iUom==selectUom){
		            	finalUom=iUom;
		            	break;
		            }
                }
                if (finalUom==""){
	            	finalUom=data[0].RowId; 
	            }
	            $(this).combobox('select', finalUom);
            }else{
	        	$(this).combobox('clear');
	        }
        }
    });
    GridCmgIngrUom = DHCST.GridComboBox.Init({ Type: "Uom" }, {
        required: true,
        editable: true,
        onBeforeLoad: function(param) {
            param.inputStr =curEditInci;     //$('#gridInRecIngr').datagrid("getSelected").InRinInci;
            param.filterText = param.q;
        },
        onLoadSuccess: function(data) {
	        var len=data.length;
            if (len > 0) {
                var selectUom = $('#gridInRecIngr').datagrid("getSelected").InRinUomId || "";
                var finalUom=""
                // Ĭ�ϵ�λ
                for(var i=0;i<len;i++){
	                var iUom=data[i].RowId;
	                if (iUom==selectUom){
		            	finalUom=iUom;
		            	break;
		            }
                }
                if (finalUom==""){
	            	finalUom=data[0].RowId; 
	            }
	            $(this).combobox('select', finalUom);
            }else{
	        	$(this).combobox('clear');
	        }
        }
    });
   	
}

function InitGridDrugInfo() {
    var columns = [
        [
        	{ field: "InciCode", title: 'ҩƷ����', width: 120 },
            { field: "InciDesc", title: 'ҩƷ����', width: 250 },
            { field: "Spec", title: '���', width: 105 },
            { field: "Manf", title: '����', width: 200},
            { field: "Sp", title: '�ۼ�', width: 70, halign: 'right', align: 'right'},
            { field: "Rp", title: '����', width: 70, halign: 'right', align: 'right' },
            { field: "Uom", title: '��λ', width: 70 },
            { field: "Form", title: '����', width: 80},
            { field: "GenName", title: '����ͨ����', width: 120 },
            { field: "StkCat", title: '������', width: 120 },
            { field: "Inci", title: '���id', width: 50,hidden: true }
        ]
    ];
    var dataGridOption = {
        url:'', // inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        toolbar: "#gridQueryBar",
        pageSize: 50,
        pageList: [50, 100, 200],
        onClickRow: function(rowIndex, rowData) {
            if(rowData){
	        	FindInRcp()
	        }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDrugInfo", dataGridOption);
}

///��ѯ
function Query() {
    var params = GetParams();
    $("#gridInRcp").datagrid("clear");
	$("#gridInRecIngr").datagrid("clear");
    $('#gridDrugInfo').datagrid("clear")
    $('#gridDrugInfo').datagrid({
	    url: inmanuurl + '?action=JsGetIncItm',
        queryParams: {
            params: params
        }
    });
}
function GetParams(){
	var incId =$("#cmgIncItm").combobox("getValue"); // ҩƷ
	var stkcat = $('#cmbStkCat').combobox("getValue"); // ����
	var incAlias = $("#txtAlias").val().trim();
    var inmanu = $("#chkInManu").is(':checked') ? "Y" : "N";
    
    var params = incId+"^"+stkcat+"^"+incAlias+"^"+inmanu
    return params
    
}



function InitGridRcpInfo() {
    var columns = [
        [
        	{ field: "InRec", title: 'Rowid', width: 50, hidden: true },
        	{ 	
        		field: "InrecDesc", 
        		title: '�Ƽ���', 
        		width: 150, 
        		halign: 'center', 
        		align: 'right',
        		/*
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                },*/
                hidden: true 
        	},
            { 
            	field: "QtyManuf", 
            	title: '����', 
            	width: 80, 
                editor: {
                    type: 'numberbox',
                    options: {
                        required: true
                    }
                } 
            
            },
            { 
            	field: "UomId",  //uom-rowid
            	title: '��λ', 
            	width: 60, 
            	editor: GridCmgUom,
                descField: 'Uom',
                formatter: function(value, row, index) {
                    return row.Uom;
                }
            }
            ,
            { 
            	field: "Ratio",  //uom-rowid
            	title: '�ɱ��ӳ�ϵ��', 
            	width: 60, 
                editor: {
                    type: 'validatebox',
                    options: {
                        //required: true,
                        validType: 'PosNumber'
                    }
                }, 
                hidden: true
            }, 
            { field: "Uom", title: '��λ', width: 100, hidden: true  },
            { field: "Creator", title: '��ʼ��', width: 60 , hidden: true },
            { field: "UpdUser", title: '������', width: 60, hidden: true  },
            { field: "CreatDate", title: '��ʼ����', width: 90, halign: 'center', align: 'center', hidden: true  },
            { field: "UpdDate", title: '��������', width: 70, halign: 'center' , hidden: true },
            
            { field: "Remark", title: '��ע', width: 250,
                editor: {
                    type: 'validatebox'
                } 
            },
			{ field: "ExpDate", title: 'Ԥ��Ч��(��)', width: 90 ,
                editor: {
                    type: 'numberbox'
                } 
            },
            { 
            	field: "AddCost", 
            	title: 'Ĭ�ϸ��ӷ���', 
            	width: 80, 
            	halign: 'right' , 
            	align: 'right' ,
                editor: {
                    type: 'validatebox',
                    options: {
                        validType: 'PosNumber'
                    }
                },
                 hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',           //inmanuurl + '?action=JsGetIncItm',
        toolbar: '#gridInRcpBar',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pagination: false,
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                FindInRecIngr()
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'QtyManuf'
            });
        },
        onLoadSuccess: function() {
	        var rows = $("#gridInRcp").datagrid("getRows").length; 
			if(rows>0){
				$('#gridInRcp').datagrid("selectRow",0);
				FindInRecIngr()
			}
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridInRcp", dataGridOption);
}

function InitGridInrecIngr() {
    var columns = [
        [		
        	{ field: "InRin", title: 'InRin', width: 50, halign: 'center', hidden: true },
        	{ field: "InRinCode", title: '����', width: 100 },
            { 
            	field: "InRinInci", 
            	title: '�������', 
            	width: 230, 
            	hidden: true
            },
            { 
            	field: "InRinDesc", 
            	title: '����', 
            	width: 200,
            	editor: GridCmgInc,
                descField: 'InRinDesc',
                formatter: function(value, row, index) {
                    return row.InRinDesc;
                }
            },
            { 
            	field: "InRinQty", 
            	title: '����', 
            	width: 50, 
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                        validType: 'PosNumber'
                    }
                }
            },
            { 
            	field: "InRinUomId",   //uom-rowid
            	title: '��λ', 
            	width: 80, 
            	editor: GridCmgIngrUom,
                descField: 'InRinUom',
                formatter: function(value, row, index) {
                    return row.InRinUom;
                }
            },
			{ field: "InRinUom", title: '��λ', width: 200,hidden: true},

        ]
    ];
    var dataGridOption = {
        url: '',
        toolbar: '#gridInRecIngrBar',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'InRinInci'
            });
        },
        onClickCell: function(rowIndex, field, value) {
            if(field=="InRinCode"){
	       		$(this).datagrid('endEdit',rowIndex );
	        }
        },
    };
    DHCPHA_HUI_COM.Grid.Init("gridInRecIngr", dataGridOption);
}
function FindInRcp(){
	var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	var Inci=(gridSelect.Inci || "")
	if(Inci==""){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	$("#gridInRcp").datagrid("clear");
	$("#gridInRecIngr").datagrid("clear");
	$('#gridInRcp').datagrid({
	    url: inmanuurl + '?action=GetIncItmRcp',
        queryParams: {
            Params: Inci
        }
    });
}
function SaveInRcp(){
	var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	var Inci=(gridSelect.Inci || "")
;
	if(Inci==""){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	$('#gridInRcp').datagrid('endEditing');
    var gridChanges = $('#gridInRcp').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i]; 
        var params =  (iData.InRec || "") + "^" + (iData.QtyManuf || "")+ "^" + (iData.UomId || "")+ "^" + (iData.InrecDesc || "")+ "^" + (iData.Remark || "")+ "^" + (iData.Ratio || "")+ "^" + (iData.ExpDate || "") + "^" + (iData.AddCost || "")    ;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    
    var saveRet = tkMakeServerCall("web.DHCST.IncItmRcp", "SaveInRcp", Inci,paramsStr,SessionUser);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    if (saveVal!=0) {
	    var saveInfo = saveArr[1];
        $.messager.alert("��ʾ", saveInfo, "warning");
    }else{
		FindInRcp();
	}



}
function AddInRcp(){
	var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	$("#gridInRcp").datagrid('addNewRow', { editField: 'QtyManuf' });	
	
}
//ɾ���Ƽ�
function DelInRcp(){
	var gridSelect=$('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	var InRec=(gridSelect.InRec || "")
	if(InRec==""){
		var curInd =$('#gridInRcp').datagrid('getRowIndex',gridSelect) ;
		$('#gridInRcp').datagrid('deleteRow',curInd);
	}else{
		DHCST.Progress.Show({ type: 'delete', interval: 1000 });
	    $.m({
	        ClassName: "web.DHCST.IncItmRcp",
	        MethodName: "DeleteInRcp",	        
	        InRec: InRec,
	        
	    }, function(retData) {
	        DHCST.Progress.Close();
	        var retArr = retData.split("^");
	        if (retArr[0] != 0) {
	            $.messager.alert('��ʾ', "ɾ��ʧ�ܣ�"+retArr[0], 'warning');
	            return;
	        } 
	       	FindInRcp(); //��ѯ�Ƽ���Ϣ 
	    });
	}
}
//��ѯ�Ƽ�
function FindInRecIngr(){
	var gridSelect = $('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	$("#gridInRecIngr").datagrid("clear");
	var InRec= (gridSelect.InRec || "");
	$('#gridInRecIngr').datagrid({
	    url: inmanuurl + '?action=GetIncItmRecIngr',
        queryParams: {
            Params: InRec
        }
    });
}
function CheckBeforeSaveIngr(){
	var rows = $("#gridInRecIngr").datagrid("getRows"); 
	for(var i=0;i<rows.length;i++){
		var iData=rows[i];
        var InRinInci=(iData.InRinInci || "")
        if((InRinInci=="")||(InRinInci==0)){
	    	$.messager.alert("��ʾ", "��ѡ��ҩƷ��", "warning");
	    	return false;
	    }
        var InRinQty=(iData.InRinQty || 0)
        if(InRinQty==0){
	    	$.messager.alert("��ʾ", "����ȷ¼��������", "warning");
	    	return false;
	    }
	    var UomId=(iData.InRinUomId || "")
	    if(UomId==""){
	    	$.messager.alert("��ʾ", "��ѡ��λ��", "warning");
	    	return false;
	    }
	    for(var j=0;j<i;j++){
		    var jData=rows[j];
		    var tmpInci=(jData.InRinInci || "")
		    if(InRinInci==tmpInci){
				$.messager.alert("��ʾ", "��"+(i+1)+"�����"+(j+1)+"��ԭ���ظ�", "warning");
	    		return false;
			}
	    }
	    
    }
    return true;
}
function SaveInRecIngr(){
	
	var gridSelect=$('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	var InRec=(gridSelect.InRec || "")
	$('#gridInRecIngr').datagrid('endEditing');
	if(CheckBeforeSaveIngr()==false){return;}
	
	var paramsStr=""
	var rows = $("#gridInRecIngr").datagrid("getRows"); 
	for(var i=0;i<rows.length;i++){
		var iData=rows[i];
		
 
        var InRinInci=(iData.InRinInci || "")

        var InRinQty=(iData.InRinQty || 0)
       
       
	    var UomId=(iData.InRinUomId || "")
	    
	    var Desc=(iData.InRinDesc || "")
        var params =  (iData.InRin || "") + "^" + InRinInci+ "^" + InRinQty+ "^" + UomId+ "^" +Desc;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.IncItmRcp", "SaveInRecIngr", InRec,paramsStr,SessionUser);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    if (saveVal!=0) {
	    var saveInfo = saveArr[1];
        $.messager.alert("��ʾ", saveInfo, "warning");
    }else{
		FindInRecIngr();
	}


}
function AddInRecIngr(){
	var gridSelect=$('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���Ƽ���¼!", "warning");
        return;
	}
	$("#gridInRecIngr").datagrid('addNewRow', { editField: 'InRinDesc' });	
}
function DelInRecIngr(){
	var gridSelect=$('#gridInRecIngr').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���Ƽ�ԭ�ϼ�¼!", "warning");
        return;
	}
	var InRin=(gridSelect.InRin || "")
	if(InRin==""){
		var curInd =$('#gridInRecIngr').datagrid('getRowIndex',gridSelect) ;
		$('#gridInRecIngr').datagrid('deleteRow',curInd);
	}else{
		DHCST.Progress.Show({ type: 'delete', interval: 1000 });
	    $.m({
	        ClassName: "web.DHCST.IncItmRcp",
	        MethodName: "DeleteInRecIngr",	       
	        InRin: InRin,
	        
	    }, function(retData) {
	        DHCST.Progress.Close();
	        var retArr = retData.split("^");
	        if (retArr[0] != 0) {
	            $.messager.alert('��ʾ', "ɾ��ԭ��ʧ�ܣ�"+retArr[0], 'warning');
	            return;
	        } 
	        
    		$("#gridInRecIngr").datagrid("clear");
	       	FindInRecIngr(); //��ѯ�Ƽ���Ϣ 
	    });
	}
}