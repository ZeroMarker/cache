///  scripts/pha/in/v3/decimal/decimal.js


$(function() {
	InitGridDeciFac();
	
	
	$('#btnFind').on("click", Query);
	
	$('#btnAdd').on("click", AddDeciFac);
    $('#btnSave').on("click", SaveDeciFac);
    $('#btnDel').on("click", DelDeciFac);
    
    Query();

})

function InitGridDeciFac(){
	var columns = [
        [
        	{ field: "RowId", title: 'RowId', width: 60, halign: 'center', hidden: true },
        	{ field: "FrDeciConFac", title: '��ʼֵ', width: 150,
        		editor: {
                    type: 'validatebox',
                    options: {
                        validType: 'PosNumber'
                    }
                }
        	},
            { field: "ToDeciConFac", title: '����ֵ', width: 150,
        		editor: {
                    type: 'validatebox',
                    options: {
	                     validType: 'PosNumber'
			        }
                }
            },
            { field: "FacVal", title: '��ʾֵ', width: 200,
        		editor: {
                    type: 'validatebox'
        		}
            }
  		]
        
    ];
    var dataGridOption = {
        url: "DHCST.QUERY.GIRD.EASYUI.csp",          
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        toolbar:"#gridDeciFacBar",
        pagination: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'InRinInci'
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDeciFac", dataGridOption);
}
function Query() {
    var params ="";
    $("#gridDeciFac").datagrid("clear");
    $('#gridDeciFac').datagrid({
        queryParams: {
	        ClassName:"PHA.IN.DeciConFac.Query",
	     	QueryName:"QueryDeciConFac",
	     	Params: params 
        }

    });
}
function AddDeciFac(){
	

	$("#gridDeciFac").datagrid('addNewRow', { editField: 'FrDeciConFac' });	
}
function SaveDeciFac(){
	$('#gridDeciFac').datagrid('endEditing');
    var gridChanges = $('#gridDeciFac').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i]; 
        var frdeci=iData.FrDeciConFac || ""
        var todeci=iData.ToDeciConFac || ""
        var FacVal=iData.FacVal || ""
        if((frdeci=="")||(frdeci=="")||(FacVal=="")){
	        $.messager.alert("��ʾ", "����������˶�", "warning");
        	return;
	    }
        var params =  (iData.RowId || "") + "^" + (iData.FrDeciConFac || "")+ "^" + (iData.ToDeciConFac || "")+ "^" + (iData.FacVal || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    
    var saveRet = tkMakeServerCall("PHA.IN.DeciConFac.Save", "SaveDeciFac", paramsStr);
    if (saveRet!=0) {
	    var arrRet=saveRet.split("^");
        $.messager.alert("��ʾ", arrRet[1], "warning");
    }else{
		Query();
	}

}
function DelDeciFac(){
	var gridSelect=$('#gridDeciFac').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	var RowId=(gridSelect.RowId || "")
	if(RowId==""){
		var curInd =$('#gridDeciFac').datagrid('getRowIndex',gridSelect) ;
		$('#gridDeciFac').datagrid('deleteRow',curInd);
	}else{
	    $.cm({
	        ClassName: "PHA.IN.DeciConFac.Save",
	        MethodName: "Delete",	       
	        RowId: RowId
	    }, function(retData) {
	        if (retData == "") {
	            $.messager.alert('��ʾ', "ɾ��ʧ�ܣ�"+retData, 'warning');
	            return;
	        } 
	        
	       	Query(); //��ѯ
	    });
	}
}