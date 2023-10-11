$(function() {
	initSearchForm();
	initGrid();
	document.onkeydown = DocumentOnKeyDown;
})
function initSearchForm(){
	$HUI.datebox("#startDate,#endDate",{})
	$('#startDate,#endDate').datebox('setValue', dateCalculate(now, 0));
	//������
	$HUI.combobox('#outCome', {
		valueField: 'ID',
		textField: 'desc',
		url: $NURURL + '?className=Nur.IP.Delivery&methodName=findOutCome',
		onSelect: function(record) {},
		filter: filter
	});
	if (onlySearchByCurLoc!="Y"){
		//����
		$HUI.combobox('#department', {
			valueField: 'ID',
			textField: 'desc',
			url: $NURURL + '?className=Nur.IP.Delivery&methodName=findDepartment',
			onSelect: function(record) {},
			filter: filter
		});
	}
	//Ӥ���Ա�
	$HUI.combobox('#babySex', {
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=Nur.NIS.Service.Delivery.Report&QueryName=GetTableData&rows=99999&tableName=User.CTSex',
		onSelect: function(record) {},
		filter: filter,
		loadFilter:function(data){
			return data.rows;
		}
	});
	//���䷽ʽ
	$HUI.combobox('#deliverMethod', {
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=Nur.NIS.Service.Delivery.Report&QueryName=GetTableData&rows=99999&tableName=User.PACDeliveryMethod',
		onSelect: function(record) {},
		filter: filter,
		loadFilter:function(data){
			return data.rows;
		}
	});
	$('#searchBtn').click(search);
	$('#printBtn').click(function(){
		var rows = $('#babyGrid').datagrid('getRows');
		if (rows.length==0){
			$.messager.popover({msg: '��ӡ����Ϊ�գ�������ѯ���ٴ�ӡ��',type: 'error'});
			return false;
		}
		var locationURL = window.location.href.split("/csp/")[0];
		var infos=[];
		infos.push($("#startDate").datebox("getValue"));
		infos.push($("#endDate").datebox("getValue"));
		infos.push($("#outCome").combobox("getValue"));
		if (onlySearchByCurLoc=="Y"){
			var department=linkLocIds;
		}else{
			var department=$("#department").combobox("getValue");
		}
		infos.push(department);
		infos.push($("#deliverMethod").combobox("getValues").join("^"));
		infos.push($("#babySex").combobox("getValue"));
		infos.push($("#motherName").val());
		infos.push($("#motherRegNo").val());
		infos.push(session['LOGON.HOSPID']);
		infos.push(session['LOGON.WARDID']);
		AINursePrintAll(locationURL, "DHCNURMoudPrnDeliveryReport", rows[0].motherEpisodeID, infos.join("@"));
	});
	$('#exportBtn').click(function(){
		print("export")
	});
	$('#vaccinRegisterExportBtn').click(function(){
		vaccinRegisterExport();
	})
}
function initGrid(){
	var columns=$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"getDeliveryReportColumns",
	   	hospId:session['LOGON.HOSPID'],
		rows:99999
	},false);
	columns.splice(0,0,{field:'index',checkbox:true})
	$HUI.datagrid('#babyGrid', {
		border:false,
		autoSizeColumn: true,
		fit: true,
		//data:data,
		columns:[columns],
		fitColumns: false,
		singleSelect:false,
		headerCls: 'panel-header-gray',
		idField: 'babyID',
		rownumbers:true,
		toolbar: [{
			id:"hearingScreeningBtn",
			iconCls: 'icon-adjust-inventory',
			text: '����ɸ��',
			handler: function() {
				var rowsData = $('#babyGrid').datagrid('getSelections');
				if (rowsData.length === 0) {
					$.messager.popover({msg: '��ѡ����Ҫ��������ɸ���Ӥ����Ϣ!',type: 'error'});
					return false;
				}
				var babyDataArr=[];
				for (var i=0;i<rowsData.length;i++){
					var babyEpisodeID=rowsData[i].babyEpisodeID;
					if (!babyEpisodeID) continue;
					babyDataArr.push(rowsData[i]);
				}
				if (babyDataArr.length === 0) {
					$.messager.popover({msg: '��ѡ�����ļ�¼��������ɸ��!',type: 'error'});
					return false;
				}
				$('#HearingScreeningDialog').dialog('open');
				if (rowsData.length==1){
					setBabyHearingScreeningInfo(rowsData[0].babyID);
				}
			}
		},{
			id:"diseaseScreeningBtn",
			iconCls: 'icon-emr-cri',
			text: '����ɸ��',
			handler: function() {
				var rowsData = $('#babyGrid').datagrid('getSelections');
				if (rowsData.length === 0) {
					$.messager.popover({msg: '��ѡ����Ҫ���м���ɸ���Ӥ����Ϣ!',type: 'error'});
					return false;
				}
				var babyDataArr=[];
				for (var i=0;i<rowsData.length;i++){
					var babyEpisodeID=rowsData[i].babyEpisodeID;
					if (!babyEpisodeID) continue;
					babyDataArr.push(rowsData[i]);
				}
				if (babyDataArr.length === 0) {
					$.messager.popover({msg: '��ѡ�����ļ�¼���м���ɸ��!',type: 'error'});
					return false;
				}
				$('#DiseaseScreeningDialog').dialog('open');
				if (rowsData.length==1){
					setBabyDiseaseScreeningInfo(rowsData[0].babyID);
				}
			}
		},'-',{
			id:"vaccinRegisterBtn",
			iconCls: 'icon-edit',
			text: '����Ǽ�',
			handler: function() {
				var rowsData = $('#babyGrid').datagrid('getSelections');
				if (rowsData.length === 0) {
					$.messager.popover({msg: '��ѡ����Ҫ��������Ǽǵ�Ӥ����Ϣ!',type: 'error'});
					return false;
				}
				var babyDataArr=[];
				for (var i=0;i<rowsData.length;i++){
					var babyEpisodeID=rowsData[i].babyEpisodeID;
					if (!babyEpisodeID) continue;
					babyDataArr.push(rowsData[i]);
				}
				if (babyDataArr.length === 0) {
					$.messager.popover({msg: '��ѡ�����ļ�¼��������Ǽ�!',type: 'error'});
					return false;
				}
				$('#VaccineRegisterDialog').dialog('open');
				$("#BCGNotRegisterReason,#HepatitisBNotRegisterReason").removeAttr("disabled");
				initVaccineRegisterCombo();
				if (rowsData.length==1){
					setBabyVaccineRegisterInfo(rowsData[0].babyID);
				}
			}
		},{
			id:"vaccinBtn",
			iconCls: 'icon-batch-cfg',
			text: '����ά��',
			handler: function() {
				$('#VaccineConfigDialog').dialog('open');
				initVaccineCfgTab();
			}
		},
		{
			iconCls: 'icon-ok',
			id:"sum"
		}],
		onDblClickRow: function(index, data) {
			initDetailData(data);
		},
		onLoadSuccess:function(data){
			$("#sum")[0].text=$g("�� ")+data.total+$g(" ��");
		}
	});

	//�޸�table�߶�
	var gridHeight = (document.body.scrollHeight - $('#searchForm').height() - 130);
	$("#babyGridDiv").find(".panel").find(".datagrid-wrap").css("height", gridHeight + "px");

	//�޸�table head ��ʽ
	$('.panel-title').each(function() {
		$(this).html('<p>' + $(this).html() + '</>')
	})
	if (vaccinRegisterFlag!="Y") $("#vaccinRegisterBtn,#vaccinBtn,#vaccinRegisterExportBtn").hide();
	if (hearingScreeningFlag!="Y") $("#hearingScreeningBtn").hide();
	if (diseaseScreeningFlag!="Y") $("#diseaseScreeningBtn").hide();
	if ((hearingScreeningFlag!="Y")&&(diseaseScreeningFlag!="Y")&&(vaccinRegisterFlag!="Y")) $(".datagrid-btn-separator").hide();
	loadBabyGridData();
}
function loadBabyGridData(){
	if (onlySearchByCurLoc=="Y"){
		var department=linkLocIds;
	}else{
		var department=$("#department").combobox("getValue");
	}
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"getDeliveryReportJson",
		startDate:$("#startDate").datebox("getValue"), //"2022-08-01"
		endDate:$("#endDate").datebox("getValue"), //"2023-01-05",
		outCome:$("#outCome").combobox("getValue"),
		department:department,
		deliverMethodIds:$("#deliverMethod").combobox("getValues").join("^"),
		babySexId:$("#babySex").combobox("getValue"),
		motherName:$("#motherName").val(),
		motherRegNo:$("#motherRegNo").val(),
	   	hospID:session['LOGON.HOSPID'],
	},false);
	$('#babyGrid').datagrid("loadData",data);
}
function search(){
	$('#babyGrid').datagrid('clearSelections');
	loadBabyGridData();
}
function print(type){
	var rowsData = $('#babyGrid').datagrid('getSelections')
	if (rowsData.length === 0) {
		$.messager.alert("��ʾ", "��ѡ����Ҫ������Ӥ����Ϣ!", 'error');
		return;
	}
	var Str ="(function test(x){"
	Str +="var xlApp = new ActiveXObject('Excel.Application');"
	Str +="var xlBook = xlApp.Workbooks.Add();"
	Str +="var xlSheet = xlBook.ActiveSheet;"
	Str +="xlSheet.Columns.NumberFormatLocal = '@';"
	//���ù���������  
	Str +="xlSheet.name = 'tt.xlsx';"; 
	var col=0;
	var opts=$('#babyGrid').datagrid("options");
	for (var i=1;i<opts.columns[0].length;i++){
		if (!opts.columns[0][i].hidden){
			Str +="xlSheet.cells("+(1)+","+(col+1)+")='"+opts.columns[0][i].title+"';";
			col++;
		}
	}
	for (var i=0;i<rowsData.length;i++){
		var col=0;
		for (var j=1;j<opts.columns[0].length;j++){
			if (!opts.columns[0][j].hidden){
				Str +="xlSheet.cells("+(i+2)+","+(col+1)+")='"+rowsData[i][opts.columns[0][j].field]+"';";
				col++;
			}
		}
	}
	var filename="tt.xlsx";
	Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
	Str += "if (fname==false) return;"
	if (type=="export"){
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
	}else{
		Str +="xlApp.Visible = true;"
	}
	Str +="xlApp.UserControl = false;"
	Str +="xlBook.Close(savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlSheet=null;"
	Str +="xlBook=null;"
	Str +="xlApp=null;"
	Str +="return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn =1;   //�����޽�����ã�����������
	var rtn =CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
}
function vaccinRegisterExport(){
	var rowsData = $('#babyGrid').datagrid('getSelections')
	if (rowsData.length === 0) {
		$.messager.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼!", 'error');
		return;
	}
	var exportBabyIdArr=[];
	for (var i=0;i<rowsData.length;i++){
		var babyEpisodeID=rowsData[i].babyEpisodeID;
		if (!babyEpisodeID) continue;
		var babyID=rowsData[i].babyID;
		exportBabyIdArr.push(babyID);
	}
	if (exportBabyIdArr.length === 0) {
		$.messager.alert("��ʾ", "��ѡ������¼��", 'error');
		return;
	}
	 $.cm({
		 localDir:"Self",
		 ResultSetTypeDo:"Export",
	     ExcelName:"������������������Ҹ�������ֵǼǱ�",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "Nur.NIS.Service.Delivery.Report",
	     QueryName : "vaccinRegisterExport",
	     exportBabyIdArr:JSON.stringify(exportBabyIdArr),
	     rows:99999
	 },false);
}
/*-----------------------����ά����ʼ-----------------------*/
function initVaccineCfgTab(){
	$('#VaccineManufactTab').datagrid({
		nowrap: false,
        singleSelect: true,
        idField: 'Index',
        border:false,
        fit: true,
        url: $URL,
        queryParams: {
            ClassName: "Nur.NIS.Service.Delivery.Report",
            QueryName: 'getVaccineManufactList'
        },
        toolbar: '#tableCarrySheetToolBar',
        columns: [
            [
            	//{ field: 'Index', title: '',checkbox:true},
                { field: 'VaccineMFName', title: '����', width: 310, editor: 'text',options:{required: true} },
            ]
        ],
        onDblClickRow: function(index, row) {
	    	$(this).datagrid('beginEdit', index);
	    },
        onBeforeLoad:function(param){
	        $("#VaccineManufactTab").datagrid("unselectAll");
	        param.vaccineType=getVaccineType();
	    },
	    onSelect:function(rowIndex, rowData){
		    $('#VaccineBatchNoTab').datagrid("reload");
		}
	})
	$('#VaccineBatchNoTab').datagrid({
		nowrap: false,
        singleSelect: false,
        idField: 'Index',
        border:false,
        fit: true,
        url: $URL,
        queryParams: {
            ClassName: "Nur.NIS.Service.Delivery.Report",
            QueryName: 'getVaccineBatchNoList'
        },
        toolbar: [{
			iconCls: 'icon-add',
			text: '����',
			handler: function() {
				var rows=$("#VaccineManufactTab").datagrid("getSelections");
				if (rows.length==0){
					$.messager.popover({msg: '��ѡ�񳧼ң�',type: 'error'});
					return false;
				}else if(rows.length>1){
					$.messager.popover({msg: '��ѡ��һ�����Ҽ�¼��',type: 'error'});
					return false;
				}else{
					var vaccineBNManufactDR=rows[0].id;
					if (!vaccineBNManufactDR) {
						$.messager.popover({msg: '��ѡ���ѱ���ĳ��Ҽ�¼��',type: 'error'});
						return false;
					}
				}
				var maxRow=$("#VaccineBatchNoTab").datagrid("getRows");
				$("#VaccineBatchNoTab").datagrid("appendRow", {
					Index:maxRow.length,
	                id: '',
	                VaccineBNNumber: ''
	            })
	            var editIndex=maxRow.length-1;
	            $("#VaccineBatchNoTab").datagrid("beginEdit", editIndex);
			}
		},{
			iconCls: 'icon-cancel',
			text: 'ɾ��',
			handler: function() {
				deleteVaccineBatchNo();
			}
		},{
			iconCls: 'icon-save',
			text: '����',
			handler: function() {
				saveVaccineBatchNo();
			}
		}],
        columns: [
            [
            	{ field: 'Index', title: '',checkbox:true},
                { field: 'VaccineBNNumber', title: '����', width: 310, editor: 'text',options:{required: true} },
            ]
        ],
        onDblClickRow: function(index, row) {
	    	$("#VaccineBatchNoTab").datagrid('beginEdit', index);
	    },
        onBeforeLoad:function(param){
	        $("#VaccineBatchNoTab").datagrid("unselectAll");
	        var vaccineMF="";
	        var rows = $("#VaccineManufactTab").datagrid("getSelections");
	        if (rows.length){
	        	vaccineMF=rows[0].id;
	        }
	        if (!vaccineMF) vaccineMF="";
	        param.vaccineMF=vaccineMF;
	    }
	})
}
function vaccineTypeCheckChange(){
	setTimeout(function(){
		$("#VaccineManufactTab").datagrid("reload");
	});
}
function vaccineMFAdd(){
	var maxRow=$("#VaccineManufactTab").datagrid("getRows");
	$("#VaccineManufactTab").datagrid("appendRow", {
		Index:maxRow.length,
        id: '',
        VaccineBNNumber: ''
    })
    var editIndex=maxRow.length-1;
    $("#VaccineManufactTab").datagrid("beginEdit", editIndex);
}
function deleteVaccineMF(){
	var rows = $("#VaccineManufactTab").datagrid("getSelections");
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
        function(r) {
            if (r) {
                var delDataArr=[],delIndexArr=[];
                for (var i = 0; i < rows.length; i++) {
                    var id=rows[i].id;
                    if (id) {
                        delDataArr.push(id);
                    }
                    delIndexArr.push($("#VaccineManufactTab").datagrid("getRowIndex",rows[i].Index));
                }
                var value=$.m({ 
					ClassName:"Nur.NIS.Service.Delivery.Report", 
					MethodName:"handleVaccineManufact",
					event:"DELETE",
					dataArr:JSON.stringify(delDataArr)
				},false);
		        if(value=="0"){
			       for (var i = delIndexArr.length-1; i >=0; i--) {
				       $("#VaccineManufactTab").datagrid("deleteRow",delIndexArr[i]);
				   }
				   $('#VaccineBatchNoTab').datagrid('reload');
			       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
		        }else{
			       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
		        }
            }
        });
	}else{
		$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
	}
}
function saveVaccineMF(){	
	var saveDataArr=[],tableDataArr=[];NullValColumnArr=[],repeatArr=[];
    var rows = $('#VaccineManufactTab').datagrid('getRows');
    for (var j=0;j<rows.length;j++){
	    var rowDataArr=[];
		var editors=$('#VaccineManufactTab').datagrid('getEditors',j);
		if (editors.length ==0) {
			tableDataArr.push({"field":"VaccineMFName","fieldValue":rows[j].VaccineMFName});
			continue;
		}
		var rowNullValArr=[];
		for (var k=0;k<editors.length;k++){
			var field=editors[k].field;
			var fieldType=editors[k].type;
			var value=editors[k].target.val();
			value=$.trim(value);
			var fieldOpts = $('#VaccineManufactTab').datagrid('getColumnOption',field);
			if (fieldOpts.options){
				if ((fieldOpts.options.required)&&(!value)){
					rowNullValArr.push(fieldOpts.title);
				}
			}
			rowDataArr.push({"field":field,"fieldValue":value});
		}
		if ($.hisui.indexOfArray(tableDataArr,"fieldValue",value)>=0) {
			repeatArr.push("��"+(j+1)+"��");
		}
		/*if (JSON.stringify(tableDataArr).indexOf(JSON.stringify(rowDataArr))>=0) {
			repeatArr.push("��"+(j+1)+"��");
		}*/
		if (rowNullValArr.length>0){
			NullValColumnArr.push("��"+(j+1)+"��"+rowNullValArr.join("��"));
		}
		if (rowDataArr.length>0){
			var id=rows[j].id;
			if (!id) id="";
			rowDataArr.push({"field":"id","fieldValue":id});
			rowDataArr.push({"field":"VaccineMFDelFlag","fieldValue":0});
			rowDataArr.push({"field":"VaccineMFType","fieldValue":getVaccineType()});
			saveDataArr.push(rowDataArr);
			tableDataArr.push({"field":field,"fieldValue":value});
		}
	}
	if (saveDataArr.length==0){
		$.messager.popover({msg: 'û����Ҫ��������ݣ�',type: 'error'});
		return false;
	}
	var ErrMsgArr=[];
	if (repeatArr.length>0){
		ErrMsgArr.push(repeatArr.join("��")+ " �����ظ���");
	}
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("��")+ " ����Ϊ�գ�");
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("��ʾ",ErrMsgArr.join(";"));
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"handleVaccineManufact",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '����ɹ���',type: 'success'});
			$('#VaccineManufactTab').datagrid('reload');
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�'+rtn,type: 'error'});
		}
	})
}
function getVaccineType(){
	return $("#BCGRadio").radio("getValue")?"BCG":$("#HepatitisBRadio").radio("getValue")?"HepatitisB":"";
}
function deleteVaccineBatchNo(){
	var rows = $("#VaccineBatchNoTab").datagrid("getSelections");
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
        function(r) {
            if (r) {
                var delDataArr=[],delIndexArr=[];
                for (var i = 0; i < rows.length; i++) {
                    var id=rows[i].id;
                    if (id) {
                        delDataArr.push(id);
                    }
                    delIndexArr.push($("#VaccineBatchNoTab").datagrid("getRowIndex",rows[i].Index));
                }
                var value=$.m({ 
					ClassName:"Nur.NIS.Service.Delivery.Report", 
					MethodName:"handleVaccineBatchNo",
					event:"DELETE",
					dataArr:JSON.stringify(delDataArr)
				},false);
		        if(value=="0"){
			       for (var i = delIndexArr.length-1; i >=0; i--) {
				       $("#VaccineBatchNoTab").datagrid("deleteRow",delIndexArr[i]);
				   }
			       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
		        }else{
			       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
		        }
            }
        });
	}else{
		$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
	}
}
function saveVaccineBatchNo(){
	var rows=$("#VaccineManufactTab").datagrid("getSelections");
	if (rows.length==0){
		$.messager.popover({msg: '��ѡ�񳧼ң�',type: 'error'});
		return false;
	}else if(rows.length>1){
		$.messager.popover({msg: '��ѡ��һ�����Ҽ�¼��',type: 'error'});
		return false;
	}else{
		var vaccineBNManufactDR=rows[0].id;
		if (!vaccineBNManufactDR) {
			$.messager.popover({msg: '��ѡ���ѱ���ĳ��Ҽ�¼��',type: 'error'});
			return false;
		}
	}
	
	var saveDataArr=[],tableDataArr=[];NullValColumnArr=[],repeatArr=[];
    var rows = $('#VaccineBatchNoTab').datagrid('getRows');
    for (var j=0;j<rows.length;j++){
	    var rowDataArr=[];
		var editors=$('#VaccineBatchNoTab').datagrid('getEditors',j);
		if (editors.length ==0) {
			tableDataArr.push({"field":"VaccineBNNumber","fieldValue":rows[j].VaccineBNNumber});
			continue;
		}
		var rowNullValArr=[];
		for (var k=0;k<editors.length;k++){
			var field=editors[k].field;
			var fieldType=editors[k].type;
			var value=editors[k].target.val();
			value=$.trim(value);
			var fieldOpts = $('#VaccineBatchNoTab').datagrid('getColumnOption',field);
			if (fieldOpts.options){
				if ((fieldOpts.options.required)&&(!value)){
					rowNullValArr.push(fieldOpts.title);
				}
			}
			rowDataArr.push({"field":field,"fieldValue":value});
		}
		/*if (JSON.stringify(tableDataArr).indexOf(JSON.stringify(rowDataArr))>=0) {
			repeatArr.push("��"+(j+1)+"��");
		}*/
		if ($.hisui.indexOfArray(tableDataArr,"fieldValue",value)>=0) {
			repeatArr.push("��"+(j+1)+"��");
		}
		if (rowNullValArr.length>0){
			NullValColumnArr.push("��"+(j+1)+"��"+rowNullValArr.join("��"));
		}
		if (rowDataArr.length>0){
			var id=rows[j].id;
			if (!id) id="";
			rowDataArr.push({"field":"id","fieldValue":id});
			rowDataArr.push({"field":"VaccineBNManufactDR","fieldValue":vaccineBNManufactDR});
			rowDataArr.push({"field":"VaccineBNDelFlag","fieldValue":0});
			saveDataArr.push(rowDataArr);
			tableDataArr.push({"field":field,"fieldValue":value});
		}
	}
	if (saveDataArr.length==0){
		$.messager.popover({msg: 'û����Ҫ��������ݣ�',type: 'error'});
		return false;
	}
	var ErrMsgArr=[];
	if (repeatArr.length>0){
		ErrMsgArr.push(repeatArr.join("��")+ " �����ظ���");
	}
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("��")+ " ����Ϊ�գ�");
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("��ʾ",ErrMsgArr.join(";"));
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"handleVaccineBatchNo",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '����ɹ���',type: 'success'});
			$('#VaccineBatchNoTab').datagrid('reload');
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�'+rtn,type: 'error'});
		}
	})
}
function deleteVaccine(tabId){
	var rows = $("#VaccineBatchNoTab").datagrid("getSelections");
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
        function(r) {
            if (r) {
                var delDataArr=[],delIndexArr=[];
                for (var i = 0; i < rows.length; i++) {
                    var id=rows[i].id;
                    if (id) {
                        delDataArr.push(id);
                    }
                    delIndexArr.push($("#VaccineBatchNoTab").datagrid("getRowIndex",rows[i].Index));
                }
                var value=$.m({ 
					ClassName:"Nur.NIS.Service.Delivery.Report", 
					MethodName:"handleVaccine",
					event:"DELETE",
					dataArr:JSON.stringify(delDataArr)
				},false);
		        if(value=="0"){
			       for (var i = delIndexArr.length-1; i >=0; i--) {
				       $("#VaccineBatchNoTab").datagrid("deleteRow",delIndexArr[i]);
				   }
			       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
		        }else{
			       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
		        }
            }
        });
	}else{
		$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
	}
}
/*-----------------------����ά������-----------------------*/
//��������ɸ����
function saveHearingScreening(){
	var rowsData = $('#babyGrid').datagrid('getSelections')
	if (rowsData.length === 0) {
		$.messager.popover({msg: '��ѡ����Ҫ�����Ӥ����Ϣ!',type: 'error'});
		return false;
	}
	var leftEarFlag=$("#leftEar").checkbox("getValue")?"Y":"N";
	var rightEarFlag=$("#rightEar").checkbox("getValue")?"Y":"N";
	var screeningDoc=$("#HearingScreeningDoc").val();
	if (!screeningDoc){
		$.messager.popover({msg: 'ɸ��ҽ������Ϊ�գ�',type: 'error'});
		$("#HearingScreeningDoc").focus();
		return false;
	}
	var screenDate=$("#HearingScreeningDate").datebox("getValue");
	if (!screenDate){
		$.messager.popover({msg: 'ɸ�����ڲ���Ϊ�գ�',type: 'error'});
		$('#HearingScreeningDate').next('span').find('input').focus();
		return false;
	}
	var screenTime=$("#HearingScreeningTime").timespinner("getValue");
	if (!screenTime){
		$.messager.popover({msg: 'ɸ��ʱ�䲻��Ϊ�գ�',type: 'error'});
		$("#HearingScreeningTime").focus();
		return false;
	}
	if (dtseparator=="/"){
		var screenDateArr=screenDate.split("/");
		var tmpScreenDate=screenDateArr[2]+"-"+screenDateArr[1]+"-"+screenDateArr[0];
	}else{
		var tmpScreenDate=screenDate;
	}
	var now = new Date();
	var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	if(!CompareDateTime(tmpScreenDate+" "+screenTime,nowDateTime)){
		$.messager.popover({
            msg: 'ɸ��ʱ������ϵͳ��ǰʱ�䣡',
            type: 'error'
        });
        return false;
	}
	var errors = [];
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		var babyID = rowData['babyID'];
		var babyEpisodeID = rowData['babyEpisodeID'];
		if (babyEpisodeID=="") continue;
		var babyBirthDate = rowData['babyBirthDate'];
		var babyBirthTime = rowData['babyBirthTime'];
		if (dtseparator=="/"){
			var babyBirthDateArr=babyBirthDate.split("/");
			var tmpbabyBirthDate=babyBirthDateArr[2]+"-"+babyBirthDateArr[1]+"-"+babyBirthDateArr[0];
		}else{
			var tmpbabyBirthDate=babyBirthDate;
		}
		if(CompareDateTime(tmpScreenDate+" "+screenTime,tmpbabyBirthDate+" "+babyBirthTime)){
			errors.push(rowData['babyName']+"ɸ��ʱ�䲻�����ڳ���ʱ��"+babyBirthDate+" "+babyBirthTime+"!");
			continue;
		}
		var ret = tkMakeServerCall("Nur.NIS.Service.Delivery.Report", "saveHearingScreening", babyID, leftEarFlag, rightEarFlag,screeningDoc,screenDate,screenTime);
		if (ret != 0) {
			errors.push(ret);
		}
	}
	if (errors.length !== 0) {
		$.messager.alert("��ʾ", "����ʧ��!</br>"+errors.join("</br>"), 'error');
		return false;
	}
	$('#HearingScreeningDialog').dialog('close');
	search();
}
//���漲��ɸ���Ѫ��Ϣ
function saveDiseaseScreening(){
	var rowsData = $('#babyGrid').datagrid('getSelections')
	if (rowsData.length === 0) {
		$.messager.popover({msg: '��ѡ����Ҫ�����Ӥ����Ϣ!',type: 'error'});
		return false;
	}
	var screenDate=$("#DiseaseScreeningDate").datebox("getValue");
	if (!screenDate){
		$.messager.popover({msg: 'ɸ�����ڲ���Ϊ�գ�',type: 'error'});
		$('#DiseaseScreeningDate').next('span').find('input').focus();
		return false;
	}
	var screenTime=$("#DiseaseScreeningTime").timespinner("getValue");
	if (!screenTime){
		$.messager.popover({msg: 'ɸ��ʱ�䲻��Ϊ�գ�',type: 'error'});
		$('#DiseaseScreeningTime').focus();
		return false;
	}
	if (dtseparator=="/"){
		var screenDateArr=screenDate.split("/");
		var tmpScreenDate=screenDateArr[2]+"-"+screenDateArr[1]+"-"+screenDateArr[0];
	}else{
		var tmpScreenDate=screenDate;
	}
	var now = new Date();
	var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	if(!CompareDateTime(tmpScreenDate+" "+screenTime,nowDateTime)){
		$.messager.popover({
            msg: 'ɸ��ʱ������ϵͳ��ǰʱ�䣡',
            type: 'error'
        });
        return false;
	}
	var screeningDoc=$("#DiseaseScreeningDoc").val();
	if (!screeningDoc){
		$.messager.popover({msg: 'ɸ��ҽ������Ϊ�գ�',type: 'error'});
		$("#DiseaseScreeningDoc").focus();
		return false;
	}
	var errors = [];
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		var babyID = rowData['babyID'];
		var babyEpisodeID = rowData['babyEpisodeID'];
		if (babyEpisodeID=="") continue;
		var babyBirthDate=rowData['babyBirthDate'];
		var babyBirthTime=rowData['babyBirthTime'];
		if (dtseparator=="/"){
			var babyBirthDateArr=babyBirthDate.split("/");
			var tmpbabyBirthDate=babyBirthDateArr[2]+"-"+babyBirthDateArr[1]+"-"+babyBirthDateArr[0];
		}else{
			var tmpbabyBirthDate=babyBirthDate;
		}
		if(CompareDateTime(tmpScreenDate+" "+screenTime,tmpbabyBirthDate+" "+babyBirthTime)){
	        errors.push(rowData['babyName']+"ɸ��ʱ�䲻�����ڳ���ʱ��"+babyBirthDate+" "+babyBirthTime+"!");
	        continue;
		}
		var ret=$.m({
			ClassName:"Nur.NIS.Service.Delivery.Report",
			MethodName:"saveDiseaseScreening",
		   	babyID:babyID,
		   	screenDate:screenDate,
		   	screenTime:screenTime,
		   	screeningDoc:screeningDoc
		},false);
		if (ret != 0) {
			errors.push(ret);
		}
	}
	if (errors.length !== 0) {
		$.messager.alert("��ʾ", "����ʧ��!</br>"+errors.join("</br>"), 'error');
	}
	$('#DiseaseScreeningDialog').dialog('close');
	search();
}
//��������Ǽ���Ϣ
function saveVaccineRegister(){
	var rowsData = $('#babyGrid').datagrid('getSelections')
	if (rowsData.length === 0) {
		$.messager.popover({msg: '��ѡ����Ҫ����Ǽǵ�Ӥ����Ϣ!',type: 'error'});
		return false;
	}
	
	var fatherName=$.trim($("#fatherName").val());
	var motherHBsAg="";
	var HBsAg= $("input:radio[name='motherHBsAg']:checked");
	if (HBsAg.length>0){
		motherHBsAg=HBsAg[0].value;
	}
	var BCGManufactor=$("#BCGManufactor").combobox("getValue");
	var BCGBatchNo=$("#BCGBatchNo").combobox("getValue");
	if ((BCGManufactor)&&(BCGBatchNo=="")){
		$.messager.popover({msg: '��ѡ�񿨽������ţ�',type: 'error'});
		$('#BCGBatchNo').next('span').find('input').focus();
		return false;
	}
	var BCGDose=$.trim($("#BCGDose").val());
	if ((BCGManufactor)&&(BCGDose=="")){
		$.messager.popover({msg: '�����뿨������ּ�����',type: 'error'});
		$('#BCGDose').focus();
		return false;
	}
	var BCGDate=$("#BCGDate").datebox("getValue");
	if ((BCGManufactor)&&(BCGDate=="")){
		$.messager.popover({msg: '�����뿨����������ڣ�',type: 'error'});
		$('#BCGDate').next('span').find('input').focus();
		return false;
	}
	var BCGTime=$("#BCGTime").timespinner("getValue");
	if ((BCGManufactor)&&(BCGTime=="")){
		$.messager.popover({msg: '�����뿨�������ʱ�䣡',type: 'error'});
		$('#BCGTime').focus();
		return false;
	}
	if ((BCGDate!="")&&(BCGTime!="")){
		if (dtseparator=="/"){
			var BCGDateArr=BCGDate.split("/");
			var tmpBCGDate=BCGDateArr[2]+"-"+BCGDateArr[1]+"-"+BCGDateArr[0];
		}else{
			var tmpBCGDate=BCGDate;
		}
		var now = new Date();
		var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
		if(!CompareDateTime(tmpBCGDate+" "+BCGTime,nowDateTime)){
			$.messager.popover({
	            msg: '���������ʱ������ϵͳ��ǰʱ�䣡',
	            type: 'error'
	        });
	        return false;
		}
	}
	var BCGNotRegisterReason=$.trim($("#BCGNotRegisterReason").val());
	if ((!BCGManufactor)&&(BCGNotRegisterReason=="")){
		$.messager.popover({msg: '�����������Ϣ��δ����ԭ��������дһ�֣�',type: 'error'});
		return false;
	}
	var HepatitisBManufactor=$("#HepatitisBManufactor").combobox("getValue");
	var HepatitisBBatchNo=$("#HepatitisBBatchNo").combobox("getValue");
	if ((HepatitisBManufactor)&&(HepatitisBBatchNo=="")){
		$.messager.popover({msg: '��ѡ���Ҹ��������ţ�',type: 'error'});
		$('#HepatitisBBatchNo').next('span').find('input').focus();
		return false;
	}
	var HepatitisBDose=$.trim($("#HepatitisBDose").val());
	if ((HepatitisBManufactor)&&(HepatitisBDose=="")){
		$.messager.popover({msg: '��ѡ���Ҹ�������ּ�����',type: 'error'});
		$('#HepatitisBDose').focus();
		return false;
	}
	var HepatitisBDate=$("#HepatitisBDate").datebox("getValue");
	if ((HepatitisBManufactor)&&(HepatitisBDate=="")){
		$.messager.popover({msg: '��ѡ���Ҹ�����������ڣ�',type: 'error'});
		$('#HepatitisBDate').next('span').find('input').focus();
		return false;
	}
	var HepatitisBTime=$("#HepatitisBTime").timespinner("getValue");
	if ((HepatitisBManufactor)&&(HepatitisBTime=="")){
		$.messager.popover({msg: '��ѡ���Ҹ��������ʱ�䣡',type: 'error'});
		$('#HepatitisBDate').focus();
		return false;
	}
	if ((HepatitisBDate!="")&&(HepatitisBTime!="")){
		if (dtseparator=="/"){
			var HepatitisBDateArr=HepatitisBDate.split("/");
			var tmpHepatitisBDate=HepatitisBDateArr[2]+"-"+HepatitisBDateArr[1]+"-"+HepatitisBDateArr[0];
		}else{
			var tmpHepatitisBDate=HepatitisBDate;
		}
		var now = new Date();
		var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
		if(!CompareDateTime(tmpHepatitisBDate+" "+HepatitisBTime,nowDateTime)){
			$.messager.popover({
	            msg: '�Ҹ��������ʱ������ϵͳ��ǰʱ�䣡',
	            type: 'error'
	        });
	        return false;
		}
	}
	var HepatitisBNotRegisterReason=$.trim($("#HepatitisBNotRegisterReason").val());
	if ((!HepatitisBManufactor)&&(HepatitisBNotRegisterReason=="")){
		$.messager.popover({msg: '�Ҹν�����Ϣ��δ����ԭ��������дһ�֣�',type: 'error'});
		return false;
	}
	var HBIg="";
	if ($("input:radio[name='HBIg']:checked").length){
		HBIg=$("input:radio[name='HBIg']:checked")[0].value;
	}
	var HBIgDate=$("#HBIgDate").datebox("getValue");
	var HBIgTime=$("#HBIgTime").timespinner("getValue"); 	
	if ((HBIgDate!="")&&(HBIgTime!="")){
		if (dtseparator=="/"){
			var HBIgDateArr=HBIgDate.split("/");
			var tmpHBIgDate=HBIgDateArr[2]+"-"+HBIgDateArr[1]+"-"+HBIgDateArr[0];
		}else{
			var tmpHBIgDate=HBIgDate;
		}
		var now = new Date();
		var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
		if(!CompareDateTime(tmpHBIgDate+" "+HBIgTime,nowDateTime)){
			$.messager.popover({
	            msg: '�Ҹ������򵰰�(HBIg)����ʱ������ϵͳ��ǰʱ�䣡',
	            type: 'error'
	        });
	        return false;
		}
	}
	var vaccineRegisterUser=$.trim($("#vaccineRegisterUser").val());
	var errors=[];
	var saveBabyIDArr=[];
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		var babyID = rowData['babyID'];
		var babyEpisodeID = rowData['babyEpisodeID'];
		if (babyEpisodeID=="") continue;
		var babyBirthDate = rowData['babyBirthDate'];
		var babyBirthTime = rowData['babyBirthTime'];
		if (dtseparator=="/"){
			var babyBirthDateArr=babyBirthDate.split("/");
			var tmpbabyBirthDate=babyBirthDateArr[2]+"-"+babyBirthDateArr[1]+"-"+babyBirthDateArr[0];
		}else{
			var tmpbabyBirthDate=babyBirthDate;
		}
		var continueFlag=0;
		if ((HepatitisBDate!="")&&(HepatitisBTime!="")){
			if(CompareDateTime(tmpHepatitisBDate+" "+HepatitisBTime,tmpbabyBirthDate+" "+babyBirthTime)){
				errors.push(rowData['babyName']+"�Ҹ��������ʱ�䲻�����ڳ���ʱ��"+babyBirthDate+" "+babyBirthTime+"!");
				continueFlag=1;
			}
		}
		if ((BCGDate!="")&&(BCGTime!="")){
			if(CompareDateTime(tmpBCGDate+" "+BCGTime,tmpbabyBirthDate+" "+babyBirthTime)){
				errors.push(rowData['babyName']+"���������ʱ�䲻�����ڳ���ʱ��"+babyBirthDate+" "+babyBirthTime+"!");
				continueFlag=1;
			}
		}
		if ((HBIgDate!="")&&(HBIgTime!="")){
			if(CompareDateTime(tmpHBIgDate+" "+HBIgTime,tmpbabyBirthDate+" "+babyBirthTime)){
				errors.push(rowData['babyName']+"�Ҹ������򵰰�(HBIg)����ʱ�䲻�����ڳ���ʱ��"+babyBirthDate+" "+babyBirthTime+"!");
				continueFlag=1;
			}
		}
		if (continueFlag==1) continue;
		saveBabyIDArr.push(babyID);
	}
	if (errors.length !== 0) {
		$.messager.alert("��ʾ", errors.join("</br>"), 'error');
		return false;
	}
	var BCGVaccineRegisterObj={
		VaccineRegisterFatherName:fatherName,
		VaccineRegisterMotherHBsAg:motherHBsAg,
		VaccineRegisterType:"BCG",
		VaccineRegisterManufactor:BCGManufactor,
		VaccineRegisterBatchNo:BCGBatchNo,
		VaccineRegisterDose:BCGDose,
		VaccineRegisterDate:BCGDate,
		VaccineRegisterTime:BCGTime,
		VaccineNotRegisterReason:BCGNotRegisterReason,
		VaccineRegisterUser:vaccineRegisterUser,
	};
	var HepatitisBVaccineRegisterObj={
		VaccineRegisterFatherName:fatherName,
		VaccineRegisterMotherHBsAg:motherHBsAg,
		VaccineRegisterType:"HepatitisB",
		VaccineRegisterManufactor:HepatitisBManufactor,
		VaccineRegisterBatchNo:HepatitisBBatchNo,
		VaccineRegisterDose:HepatitisBDose,
		VaccineRegisterDate:HepatitisBDate,
		VaccineRegisterTime:HepatitisBTime,
		VaccineNotRegisterReason:HepatitisBNotRegisterReason,
		VaccineRegisterHBIg:HBIg,
		VaccineHBIgRegisterDate:HBIgDate,
		VaccineHBIgRegisterTime:HBIgTime,
		VaccineRegisterUser:vaccineRegisterUser
	};
	var ret=$.m({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"saveVaccineRegister",
	   	saveBabyIDArr:JSON.stringify(saveBabyIDArr),
	   	BCGVaccineRegisterObj:JSON.stringify(BCGVaccineRegisterObj),
	   	HepatitisBVaccineRegisterObj:JSON.stringify(HepatitisBVaccineRegisterObj)
	},false);
	if (ret != 0) {
		$.messager.alert("��ʾ", "����ʧ��!"+ret, 'error');
		return false;
	}
	$('#VaccineRegisterDialog').dialog('close');
	search();
}
//���ص���Ӥ�����������Ϣ
function setBabyVaccineRegisterInfo(babyID){
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"getVaccineRegister",
	   	babyID:babyID
	},false);
	setItemData(data);
}
//���ص���Ӥ������ɸ����Ϣ
function setBabyDiseaseScreeningInfo(babyID){
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"getDiseaseScreening",
	   	babyID:babyID
	},false);
	setItemData(data);
}
//���ص���Ӥ������ɸ����Ϣ
function setBabyHearingScreeningInfo(babyID){
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Delivery.Report",
		MethodName:"getHearingScreening",
	   	babyID:babyID
	},false);
	setItemData(data);
}
function setItemData(data){
	for (item in data){
		if ($("#"+item).length==0) {
			if ($("input:radio[name='"+item+"']").length){
				for (var i=0;i<$("input:radio[name='"+item+"']").length;i++){
					if ($("input:radio[name='"+item+"']")[i].value==data[item]){
						$($("input:radio[name='"+item+"']")[i]).radio("check");
					}else{
						$($("input:radio[name='"+item+"']")[i]).radio("uncheck");
					}
				}
			}else if((item=="BCGRegisterInfo")||(item=="HepatitisBRegisterInfo")){
				setItemData(data[item])
			}
		}else{
			var itemClass=$("#"+item)[0].className;
			if (itemClass.indexOf("hisui-datebox")>=0){
				$("#"+item).datebox("setValue",data[item]);
			}else if(itemClass.indexOf("hisui-timespinner")>=0){
				$("#"+item).timespinner("setValue",data[item]);
			}else if(itemClass.indexOf("hisui-checkbox")>=0){
				$("#"+item).checkbox("setValue",data[item]=="Y"?true:false);
			}else if(itemClass.indexOf("hisui-combobox")>=0){
				$("#"+item).combobox("select",data[item]);
			}else{
				$("#"+item).val(data[item]);
			}
		};
	}
}
//��ʼ�����糧��
function initVaccineRegisterCombo(){
	//�����糧��
	$HUI.combobox('#BCGManufactor', {
		valueField: 'id',
		textField: 'VaccineMFName',
		url: $URL + '?ClassName=Nur.NIS.Service.Delivery.Report&QueryName=getVaccineManufactList&rows=99999&vaccineType=BCG',
		onSelect: function(record) {
		},
		filter: filter,
		loadFilter:function(data){
			return data.rows;
		},
		onSelect:function(rec){
			$("#BCGBatchNo").combobox("reload"); //.combobox("setValue","").combobox("setText","")
			$("#BCGNotRegisterReason").val("").attr("disabled","disabled");
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				$("#BCGNotRegisterReason").removeAttr("disabled");
			}
		},
		onLoadSuccess:function(){
			var BCGBatchNo=$("#BCGBatchNo").combobox("getValue");
			if (BCGBatchNo){
				if ($.hisui.indexOfArray($("#BCGBatchNo").combobox("getData"),"id",BCGBatchNo)<0){
					$("#BCGBatchNo").combobox("setValue","").combobox("setText","")
				}
			}
		}
	});
	$HUI.combobox('#BCGBatchNo', {
		valueField: 'id',
		textField: 'VaccineBNNumber',
		url: $URL + '?ClassName=Nur.NIS.Service.Delivery.Report&QueryName=getVaccineBatchNoList&rows=99999',
		onSelect: function(record) {
		},
		filter: filter,
		loadFilter:function(data){
			return data.rows;
		},
		onBeforeLoad: function(param){
			param.vaccineMF=$('#BCGManufactor').combobox('getValue');
		},
		onLoadSuccess:function(){
			var data=$("#BCGBatchNo").combobox("getData");
			if (data.length==1) $("#BCGBatchNo").combobox("setValue",data[0].id);
		}
	});
	//�Ҹ����糧��
	$HUI.combobox('#HepatitisBManufactor', {
		valueField: 'id',
		textField: 'VaccineMFName',
		url: $URL + '?ClassName=Nur.NIS.Service.Delivery.Report&QueryName=getVaccineManufactList&rows=99999&vaccineType=HEPATITISB',
		onSelect: function(record) {
		},
		filter: filter,
		loadFilter:function(data){
			return data.rows;
		},
		onSelect:function(rec){
			$("#HepatitisBBatchNo").combobox("reload"); //.combobox("setValue","").combobox("setText","")
			$("#HepatitisBNotRegisterReason").val("").attr("disabled","disabled");
		},
		onChange:function(newValue, oldValue){
			if (!newValue) $("#HepatitisBNotRegisterReason").removeAttr("disabled");
		},
		onLoadSuccess:function(){
			var HepatitisBBatchNo=$("#HepatitisBBatchNo").combobox("getValue");
			if (HepatitisBBatchNo){
				if ($.hisui.indexOfArray($("#HepatitisBBatchNo").combobox("getData"),"id",HepatitisBBatchNo)<0){
					$("#HepatitisBBatchNo").combobox("setValue","").combobox("setText","")
				}
			}
		}
	});
	$HUI.combobox('#HepatitisBBatchNo', {
		valueField: 'id',
		textField: 'VaccineBNNumber',
		url: $URL + '?ClassName=Nur.NIS.Service.Delivery.Report&QueryName=getVaccineBatchNoList&rows=99999',
		onSelect: function(record) {
		},
		filter: filter,
		loadFilter:function(data){
			return data.rows;
		},
		onBeforeLoad: function(param){
			param.vaccineMF=$('#HepatitisBManufactor').combobox('getValue');
		},
		onLoadSuccess:function(){
			var data=$("#HepatitisBBatchNo").combobox("getData");
			if (data.length==1) $("#HepatitisBBatchNo").combobox("setValue",data[0].id);
		}
	});
}
function filter(q, row) {
	var opts = $(this).combobox('options');
	var text = row[opts.textField];
	var pyjp = getPinyin(text).toLowerCase();
	if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
		return true;
	}
	return false;
}
function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("motherRegNo")>=0){
			var PatNo=$('#motherRegNo').val();
			if (PatNo=="") return;
			if (PatNo.length<10) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#motherRegNo').val(PatNo);
			search();
			return false;
		}
		return true;
	}
}
function CompareDateTime(time ,endTime ) {
	var times=time.replace(/-/g,"/");
    var endTimes =endTime.replace(/-/g,"/");
    var b =(Date.parse(times)-Date.parse(endTimes))/3600/1000;    
    if (b<=0) return true;
    return false;
}
function HBIgCheckChange(){
	var HBIg="";
	if ($("input:radio[name='HBIg']:checked").length){
		HBIg=$("input:radio[name='HBIg']:checked")[0].value;
	}
	if (HBIg!="Y"){
		$("#HBIgDate").datebox("setValue","").datebox("disable");
		$("#HBIgTime").timespinner("setValue","").timespinner("disable");
	}else{
		$("#HBIgDate").datebox("enable");
		$("#HBIgTime").timespinner("enable"); 
	}
}
