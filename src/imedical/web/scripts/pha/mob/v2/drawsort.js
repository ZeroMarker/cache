/**
 * @Creator: Huxiaotian 2018-09-20
 * @Desc: ��λ˳��ά������ҩ·����
 * @Csp: csp/phain.mtdrawsort.csp
 * @Js: scripts/pharmacy/herb/phain.mtdrawsort.js
 */
var curLocId = session['LOGON.CTLOCID'];
$(function() {
    //��ʼ������
    InitFormData();
    InitGridMain();
    InitGridDetail();
    InitDialogGrid();
    
    //���¼�
    $('#txt-stkbin').on('keypress', function(event) {
        if (event.keyCode == "13") {
            QueryDetail();
        }
    });
    $('#btn-Find').on("click", Query);
    $('#btn-Clear').on('click', Clear)
    $('#btnAdd').on("click", AddFn);
    $('#btnSave').on("click", SaveFn);
    $('#btnDelete').on("click", DeleteFn);
    $('#btn-CreateSortNum').on("click", function(){
	    $('#dialog-setNum').window('open');
	    QueryStkShelves();
	});
    
    Query(); 
});

//---------------------------------------
function InitFormData() {
    // ҩ��
    $("#cmb-PhaLoc").combobox({
		placeholder:'��ѡ��ҩ��...',
		valueField: 'RowId',
		textField: 'Description',
		mode: 'remote',
		width: 180,
		editable: false,
		url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=LocList&ResultSetType=array",
        onLoadSuccess: function() {
            var datas = $("#cmb-PhaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == curLocId) {
                    $("#cmb-PhaLoc").combobox("setValue", datas[i].RowId); //Ĭ��ֵ
                    break;
                }
            }
        },
        onSelect: function(data) {}
	});
	
	// ҩƷ����
	$("#cmg-Inci").combogrid({
		idField: 'incRowId',
        textField: 'incDesc',
		placeholder:'ҩƷ����...',
		pagination: true,
		pageList:[10,20,50],
		pageSize:10,
		width: 260,
		panelWidth: 600,
		mode: 'remote',
		columns: [[
            { field: 'incRowId', title: 'incItmRowId', width: 80, sortable: true, hidden: true },
            { field: 'incCode', title: 'ҩƷ����', width: 100, sortable: true },
            { field: 'incDesc', title: 'ҩƷ����', width: 360, sortable: true },
            { field: 'incSpec', title: '���', width: 100, sortable: true }
        ]],
        url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=IncItm",
        onBeforeLoad: function(param){
	        param.filterText = param.q;
	    },
		onSelect: function(rowIndex, rowData){
			//alert(rowIndex);
		}
	});
}

function InitGridMain() {
    var columns = [[
		{ field: "ID", title: 'ID', width: 80, hidden: true },
		{ field: 'DSCode', title: '����', width: 150,
			editor: {
            	type: 'text',
                options: {
                	required: false
                }
            }
        },
		{ field: 'DSDesc', title: '����', width: 200,
			editor: {
            	type: 'text',
                options: {
                	required: false
                }
            }
        },
		{ field: 'PhLocId', title: 'PhLocId', width: 150, hidden: true }
    ]];
    var dataGridOption = {
        url: $URL,
        fitColumns: true, //���������
        border: false,
        toolbar: "#gridMainBar",
        rownumbers: false,
        columns: columns,
        pagination: true,
        singleSelect: true,
        onSelect: function(rowIndex, rowData) {
	        QueryDetail();
	    },
	    onLoadSuccess: function() {
            var rows = $("#grid-main").datagrid('getRows');
            if(rows.length>0){
	            $("#grid-main").datagrid('selectRow',0);
	        }
        },
        //�����ݱ༭
        onClickRow: function(rowIndex, rowData){
		    $(this).datagrid('endEditing');
		},
	    onDblClickRow: function(rowIndex, rowData){
		    beginEditFn(rowIndex, rowData, "DSCode");
	    },
	    onBeginEdit: function(rowIndex, rowData){
		    onBeginEditFn(rowIndex, rowData, "DSCode");
		},
		onEndEdit: function(rowIndex, rowData, changes){
			onEndEditFn(rowIndex, rowData);
		}
    };
    
    DHCPHA_HUI_COM.Grid.Init("grid-main", dataGridOption);
}

// ��ҩ��ϸ�б�
function InitGridDetail() {
    var columns = [[
    	{ field: 'TSBID', title: 'TSBID', width: 80, hidden: true },
        { field: 'TSBCode', title: '��λ����', width: 120 },
        { field: 'TSBDesc', title: '��λ����', width: 120 },
        { field: 'TDSiId', title: 'TDSiId', width: 80 , hidden: true},
        { field: 'TDSiSN', title: '��λ˳��', width: 100, align: 'center',
        	editor:{
				type:'numberbox',
				options:{
					precision:0
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
		},
        { field: 'TDSId', title: 'TDSId', width: 80 , hidden: true},
        { field: 'TInciCode', title: 'ҩƷ����', width: 150, halign: 'left', align: 'left' },
        { field: 'TInciDesc', title: 'ҩƷ����', width: 180, halign: 'left', align: 'left' }
    ]];
    var dataGridOption = {
	    url: $URL,
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: true,
        onLoadSuccess: function(data) {},
        onClickCell: function(rowIndex, field, value){
	        if (field=="TDSiSN"){
		        $(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
        			editField: field
    			});
    			
		    } else {
			    $(this).datagrid('endEditing');
			}
	    },
	    onEndEdit: function(rowIndex, rowData, changes){
			var selecteddata = $('#grid-detail').datagrid('getRows')[rowIndex];
			var dsid = selecteddata["TDSId"];
			var dsiid = selecteddata["TDSiId"];
			var dsisbid = selecteddata["TSBID"];
			var dsisn = selecteddata["TDSiSN"];
			if (dsisn == ""){
				$("#grid-detail").datagrid("selectRow", rowIndex);
				return false;
			}
			if (isNaN(parseFloat(dsisn)) == true){
				$("#grid-detail").datagrid("selectRow", rowIndex);
	    		return false;
	    	}
	    	if (parseFloat(dsisn) <= 0){
	    		$.messager.alert('������ʾ',"�� "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (rowIndex+1)+'</span>'+" ��SN˳����С��0!","info");
	    		$("#grid-detail").datagrid("selectRow", rowIndex);
	    		return false;
	    	}
	    	
	    	var detaildata = dsid+"^"+dsiid+"^"+dsisn+"^"+dsisbid;
			savedata(detaildata);
		}
    };
    
    DHCPHA_HUI_COM.Grid.Init("grid-detail", dataGridOption);
}

// ��ѯ
function Query() {
    var locId = $('#cmb-PhaLoc').combobox('getValue');
	if(locId==null || locId=="" || locId==undefined){
		locId = session['LOGON.CTLOCID'];
	}
    $('#grid-main').datagrid('load', {
		ClassName:'PHA.MOB.Config',
		MethodName:'GetDrawSortList',
		inputStr: locId
	});
}

// ��ѯ��ϸ
function QueryDetail() {
	var selRowData = $("#grid-main").datagrid('getSelected');
	if(selRowData == null){
		alert("��ѡ�����·��!");
		return;
	}
	var mainId = selRowData.ID || "";
	var phLocId = selRowData.PhLocId || "";
	var stkBinDesc = $("#txt-stkbin").val() || "";
	stkBinDesc = $.trim(stkBinDesc);
	$("#txt-stkbin").val(stkBinDesc);
	var inci = $("#cmg-Inci").combogrid('getValue');
	
	var inputStr = phLocId +"^"+ mainId +"^"+ stkBinDesc +"^"+ inci;
    $('#grid-detail').datagrid('load', {
		ClassName: 'PHA.MOB.Config',
		MethodName: 'GetDrawSortDetailList',
		inputStr: inputStr
	});
}

// ����
function Clear() {
	//���
    $("#grid-main").datagrid("clear");
    $("#grid-detail").datagrid("clear");
    //��
	$('#cmb-PhaLoc').combobox('clear');
    $('#txt-stkbin').val('');
}

// --------------------------
// ��ʼ�༭һ��
function beginEditFn(rowIndex, rowData, myfield){
	$("#grid-main").datagrid('beginEditRow', {
		rowIndex: rowIndex,
        editField: myfield
    });
}

// ��ʼ�༭ʱ,ĳһ���ý���,��ʧȥ�����¼�
function onBeginEditFn(rowIndex, rowData, myfield){
	var myEditor = $("#grid-main").datagrid('getEditor', {index:rowIndex, field:myfield});
	myEditor.target.focus();
	myEditor.target.select();
}

// �����༭ʱ,��֤���ݺϷ���
function onEndEditFn(rowIndex, rowData){
	if(rowData.DSCode==""){
		alert('��'+(rowIndex+1)+'�У����벻��Ϊ��...');
		$("#grid-main").datagrid("selectRow", rowIndex);
	}
}

// ������ɾ�ĺ�������
function AddFn(){
	$("#grid-main").datagrid('addNewRow', {
        editField: 'DSCode'
    });
}

// ��������
function SaveFn(){
	var locId = $('#cmb-PhaLoc').combobox('getValue');
	$("#grid-main").datagrid('endEditing');
	var gridData = $('#grid-main').datagrid('getData');
	var rows = gridData.rows.length;
	var allData = gridData.rows;
	var paramStr = "";
	for(var i=0;i<rows;i++){
		var myID = allData[i]["ID"] || "";
		var myPhLocId = allData[i]["PhLocId"] || locId;
		var myCode = allData[i]["DSCode"];
		var myDesc = allData[i]["DSDesc"];
		var oneStr = myID + "^" + myPhLocId + "^" + myCode + "^" + myDesc;
		if(oneStr!="^^^"){
			if (paramStr==""){
				paramStr = oneStr;
			} else {
				paramStr = paramStr + "||" + oneStr;
			}
		}
	}
	
	//��������
	var retStr = tkMakeServerCall('PHA.MOB.Config', 'SaveDrawSort', paramStr);
	var retArr = retStr.split("^");
	if(parseFloat(retArr[0]) != 0){
		$.messager.alert('��ʾ', retArr[1]);
	} else {
		$.messager.alert('��ʾ', retArr[1]);
		Query();
	}
}

// ɾ������
function DeleteFn(){
	var selRowData = $('#grid-main').datagrid('getSelected');
	if (selRowData == null) {
		$.messager.alert('��ʾ', "û��ѡ������...");
		return ;
	}
	var selID = selRowData['ID'];
	if (selID == null || selID==undefined || selID=="") {
		$.messager.alert('��ʾ', "����û�б���...");
		Query();
		return ;
	}
	
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����ѡ�ı�ҩ��������¼��', function(r){
		if (!r){
			return;
		}
		var retStr = tkMakeServerCall('PHA.MOB.Config', 'DelDrawSort', selID);
		var retArr = retStr.split("^");
		if(parseFloat(retArr[0]) != 0){
			$.messager.alert('��ʾ', retArr[1]);
		} else {
			$.messager.alert('��ʾ', retArr[1]);
			Query();
		}
	});
}

// ���汸ҩ������ϸ��SN
function savedata(detaildata){
	var retStr = tkMakeServerCall("PHA.MOB.Config", "SaveDrawSortDetail", detaildata);
	var retArr = retStr.split("^");
	if(parseFloat(retArr[0]) != 0){
		$.messager.alert('��ʾ', retArr[1]);
	} else {
		//$.messager.alert('��ʾ', retArr[1]);
		$("#grid-detail").datagrid('reload');
	}
}

// ----------------------------------
// ����Ϊ�Զ����ɻ�λ·���ķ���
// ��ʼ�����
function InitDialogGrid(){
    //������
    var columns = [
    	[
        	{ field: 'StkShelves', title: '��������', width: 100 },
        	{ field: 'StkShelvesNum', title: '����˳���', width: 100,
        	  	editor:{
					type:'numberbox',
					options:{
						precision:0
					}
				}
			}
    	]
    ];
	
	//Grid��������
    var dataGridOption = {
	    url: $URL,
	    fitColumns: true,
        //rownumbers: true,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pagination: false,
        onLoadSuccess: function(data) {},
        rowStyler: function(rowIndex, rowData) {},
        onDblClickRow: function(rowIndex, rowData) {},
	    onCilckRow:function(rowIndex, rowData) {},
		onSelect: function(rowIndex, rowData) {},
		onClickCell: function(rowIndex, field, value){
	        if (field=="StkShelvesNum"){
		        $(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
        			editField: field
    			});
		    } else {
			    $(this).datagrid('endEditing');
			}
	    }
    };
    
    //Grid��ʼ��
    $("#grid-dialog-setNum").datagrid(dataGridOption);
}

function QueryStkShelves(){
	$("#grid-dialog-setNum").datagrid('load', {
		ClassName: 'PHA.MOB.Config',
		MethodName: 'QueryStkShelves',
	});
}

function SaveStkShelves(){
	$.messager.alert('��ʾ', "�趨�����ɹ���");
	return;
	
	var selRowData = $("#grid-main").datagrid('getSelected');
	if(selRowData == null){
		alert("��ѡ�����·��!");
		return;
	}
	var mainId = selRowData.ID;
	
	$("#grid-dialog-setNum").datagrid('endEditing');
	var retStr = "";
	var gridData = $('#grid-dialog-setNum').datagrid('getData');
	var rows = gridData.rows.length;
	if (rows == 0) {
		alert("ҳ��û������,�޷���ӡ!");
		return ;
	}
	var allData = gridData.rows;
	for(var i=0; i<rows; i++){
		var StkShelves = allData[i].StkShelves || "";
		var StkShelvesNum = allData[i].StkShelvesNum || "";
		if(StkShelvesNum == ""){
			continue;
		}
		var oneRow = StkShelves + "^" + StkShelvesNum;
		if(retStr == ""){
			retStr = oneRow;
		}else{
			retStr = retStr + "|@|" + oneRow;
		}
	}
	if(retStr == ""){
		alert("����д����˳��!");
		return;
	}
	
	var ret = tkMakeServerCall("PHA.MOB.Config", "SaveStkShelves", mainId, retStr);
	var retArr = ret.split("^");
	if(retArr[0] < 0){
		$.messager.alert("��ܰ��ʾ", "����ʧ��"+retArr[1], "info");
	} else {
		$('#dialog-setNum').window('close');
		$.messager.alert("��ܰ��ʾ", "���ɳɹ�", "info");
	}
}