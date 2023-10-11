var hospId=session['LOGON.HOSPID'];
var HospEnvironment=true;
$(function() { 
	/**
	 * @description ��ʼ������
	 */
	function initUI() {
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
		initCondition();
		initEvent();
		findshareData();
		initSubGrid();
		//$('#DIV_toolbar').appendTo('.datagrid-toolbar');
	}
	
	function initHosp(){
		var hospComp = GenHospComp("Nur_IP_DHCNurTerminologySet",session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']);  
		hospComp.options().onSelect = function(){
			if(HospEnvironment) hospId=$HUI.combogrid('#_HospList').getValue()
			findshareData();
			initSubGrid();
			clearscreen();
		}  ///ѡ���¼�
		hospId = hospComp.options().value;
	
	}
	function initEvent() {
		$('#clearscreen').bind('click', clearscreen);
		$('#ifMultiple').bind('change',changeGridCheck);
		$('#addDataItem').bind('click', addDataItem);
		$('#editDataItem').bind('click', editDataItem);
		$('#deleteDataItem').bind('click', deleteDataItem);
		$('#exportData').bind('click', exportData);
		$('#importData').bind('click', importData);
		$('#downloadTemplate').bind('click', downloadTemplate);
		
		
		
	}
	function initCondition() {
		$HUI.combobox('#category', {
			valueField: 'value',
			textField: 'value',
			editable:false,
			panelHeight:"auto",
            enterNullValueClear:false,
            data: [
                { value: "������ͨ"},
                { value: "ͳ�Ʊ���"}
            ]
		});
		
	}
	/**
	 * @description ��ѯ����
	 */
	function findshareData() {
		$('#shareDataGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'Nur.DHCNurTerminologySet',
				QueryName: 'GetPublCodeNew',
				Parr: '',
				hospId:hospId
			},
			nowrap: false,
			/*toolbar: [{
					iconCls: 'icon-add',
					text: '����',
					handler: addDataItem
				}, {
					iconCls: 'icon-edit',
					text: '�޸�',
					handler: editDataItem
				}, {
					iconCls: 'icon-remove',
					text: 'ɾ��',
					handler: deleteDataItem
				}, {
					iconCls: 'icon-export',
					text: '����',
					handler: exportData,
				}, {
					iconCls: 'icon-import',
					text: '����',
					handler: importData
				}, {
					iconCls: 'icon-download',
					text: '����ģ��',
					handler: downloadTemplate
				}
			],*/
			toolbar: '#DIV_toolbar',
			
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 15,
			pageList: [15,30,60,120],
			onClickRow: shareDataGridClickRow,
		});
	}
	function changeGridCheck(e,val){
		var ifMultiple=$('#ifMultiple').checkbox("getValue")
		if(ifMultiple){
			$("#shareDataGrid").datagrid({singleSelect: false,})
		}else{
			$("#shareDataGrid").datagrid({singleSelect: true,})
		}
	}
	
	/**
	 * @description ��ʼ���ֶα��
	 */
	function initSubGrid() {
		$('#subGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'Nur.DHCNurTerminologySetSub',
				QueryName: 'GetPublItemSubNew',
				Par: ''
			},
			nowrap: false,
			toolbar: [{
					iconCls: 'icon-add',
					text: '����',
					handler: function() {
						addSubItem();
					}
				}, {
					iconCls: 'icon-edit',
					text: '�޸�',
					handler: function() {
						editSubItem();
					}
				}, {
					iconCls: 'icon-remove',
					text: 'ɾ��',
					handler: function() {
						deleteSubItem();
					}
				}, {
					iconCls: 'icon-export',
					text: '����',
					handler: function() {
						exportSubItem();
					}
				}, {
					iconCls: 'icon-import',
					text: '����',
					handler: function() {
						inportSubItem();
					}
				}, {
					iconCls: 'icon-download',
					text: '����ģ��',
					handler: function() {
						downloadSubTemp();
					}
				}
			],
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 10,
			pageList: [10,20,30,40,50,100],
			onClickRow: subGridClickRow
		});
	}
	
	
	
	function clearscreen(){
		
		$('#chapterCons').val("");
		$('#chapterDesc').val("");
		$('#entryCons').val("");
		$('#entryDesc').val("");
		$('#fieldCons').val("");
		$('#fieldDesc').val("");
		$('#dataCode').val("");
		$('#dataFrom').val("");
		$('#subNotes').val("");
		
		 $('#code').val("");
		 $('#desc').val("");
		 $('#notes').val("");
		$('#category').combobox('setValue',"");
		
	}
	/**
	 * @description ����Դ������¼�
	 */
	function shareDataGridClickRow(rowIndex, rowData) {
		setCommonInfo(rowData);
		
		/*if(rowData.category=="ͳ�Ʊ���"){
			$('#chapterCons').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'chapterCons');
			$('#chapterDesc').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'chapterDesc');
			$('#entryCons').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'entryCons');
			$('#entryDesc').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'entryDesc');
			$('#fieldCons').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'fieldCons');
			$('#dataFrom').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'dataFrom');
			$('#subNotes').attr('disabled',true);
			$('#subGrid').datagrid('hideColumn', 'subNotes');
			$('#fieldDesc').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'fieldDesc');
			$('#dataCode').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'dataCode');
			
		}else if(rowData.category=="������ͨ"){
			$('#chapterCons').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'chapterCons');
			$('#chapterDesc').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'chapterDesc');
			$('#entryCons').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'entryCons');
			$('#entryDesc').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'entryDesc');
			$('#fieldCons').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'fieldCons');
			$('#fieldDesc').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'fieldDesc');
			$('#dataCode').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'dataCode');
			$('#dataFrom').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'dataFrom');
			$('#subNotes').attr('disabled',false);
			$('#subGrid').datagrid('showColumn', 'subNotes');
		}*/
		
		$('#subGrid').datagrid('reload', {
			ClassName: 'Nur.DHCNurTerminologySetSub',
			QueryName: 'GetPublItemSubNew',
			Par: rowData.id
		});
	}
	
	
	/**
	 * @description �ֶα�����¼�
	 */
	function subGridClickRow(rowIndex, rowData) {
		setCommonInfo(rowData);
	}
	/**
	 * @description ���ر�������Ϣ
	 */
	function setCommonInfo(rowData) {
		for (var item in rowData) {
	        var domID = "#" + item;
			
	        if (domID === '#category') {
	        	$(domID).combobox('setValue', rowData[item]);
	        } else {
	        	$(domID).val(rowData[item]);
	        }
	    }
	}
	/**
	 * @description ��������Դ��Ŀ
	 */
	function addDataItem() {
		var code = $('#code').val();
		var desc = $('#desc').val();
		var notes = $('#notes').val();
		var category = $('#category').combobox('getText');
		if(code==""){
			$.messager.popover({msg:'������벻��Ϊ��!',type:'error'});
			return;
		}
		if(desc==""){
			$.messager.popover({msg:'��Ŀ���Ʋ���Ϊ��!',type:'error'});
			return;
		}
		if(category==""){
			$.messager.popover({msg:'������𲻿�Ϊ��!',type:'error'});
			return;
		}
		var parr = "PublCode|"+code + "^PublDesc|" + desc + "^PublCat|" + category + "^PublMem|" + notes ;
		
		$m({
			ClassName: "Nur.DHCNurTerminologySet",
			MethodName: "SaveNew",
			parr: parr,
			id:"",
			hospId:hospId
		},function(txtData){
			
			if(txtData == 0) {
				$.messager.popover({msg:'��ӳɹ���',type:'success'});
				$('#shareDataGrid').datagrid('reload');
				
				$('#subGrid').datagrid({
					url: $URL,
					queryParams: {
						ClassName: 'Nur.DHCNurTerminologySetSub',
						QueryName: 'GetPublItemSubNew',
						Par: ""
					}
				});
				
				clearscreen()
			}else{
				$.messager.popover({msg:txtData,type:'error'});
			}
		});
	}
	/**
	 * @description �޸�����Դ��Ŀ
	 */
	function editDataItem() {
		var dataSourceRow = $('#shareDataGrid').datagrid('getChecked');
		
		if (dataSourceRow.length==0) {
			$.messager.popover({msg:'��ѡ��һ������Դ!',type:'info'});
			return;
		}
		if(dataSourceRow.length>1){
			$.messager.popover({msg:'ֻ��ѡ��һ������Դ!',type:'info'});
			return;
		}
		var code = $('#code').val();
		var desc = $('#desc').val();
		var notes = $('#notes').val();
		var category = $('#category').combobox('getText');
		if(code==""){
			$.messager.popover({msg:'������벻��Ϊ��!',type:'error'});
			return;
		}
		if(desc==""){
			$.messager.popover({msg:'��Ŀ���Ʋ���Ϊ��!',type:'error'});
			return;
		}
		if(category==""){
			$.messager.popover({msg:'������𲻿�Ϊ��!',type:'error'});
			return;
		}
		var parr = "PublCode|"+code + "^PublDesc|" + desc + "^PublCat|" + category + "^PublMem|" + notes ;
		
		$.each(dataSourceRow, function(index, item){
            $m({
				ClassName: "Nur.DHCNurTerminologySet",
				MethodName: "SaveNew",
				parr: parr,
				id:item.id,
				hospId:hospId
			},function(txtData){
			
				if(txtData == 0) {
					$.messager.popover({msg:'�޸ĳɹ���',type:'success'});
					$('#shareDataGrid').datagrid('reload');
					$('#subGrid').datagrid('reload');
					clearscreen()
				}else{
					$.messager.popover({msg:txtData,type:'error'});
				}
			});
        }); 
		
		
		
	}
	/**
	 * @description ɾ������Դ��Ŀ
	 */
	function deleteDataItem() {
		var dataSourceRow = $('#shareDataGrid').datagrid('getChecked');
		if (dataSourceRow.length==0) {
			$.messager.popover({msg:'��ѡ��һ������Դ!',type:'info'});
			return;
		}
		$.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
			if (r) {
				
				$.each(dataSourceRow, function(index, item){
			
					$m({
						ClassName: "Nur.DHCNurTerminologySet",
						MethodName: "Delete",
						id: item.id,
						hospId:hospId
					},function(result){
			
						if(result == 0) {
							$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
							$('#shareDataGrid').datagrid('reload');
							$('#subGrid').datagrid('reload');
							clearscreen();
						}else{
							$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
						}
					});				
				
				});	
			}
		});
		
		
		
	}

	
	

	/**
	 * @description �����ֶ���Ŀ
	 */
	function addSubItem() {
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'�������ѡ��һ��������Ŀ!',type:'info'});
			return;
		}
		
		var chapterCons = $('#chapterCons').val();
		var chapterDesc = $('#chapterDesc').val();
		var entryCons = $('#entryCons').val();
		var entryDesc = $('#entryDesc').val();
		var fieldCons = $('#fieldCons').val();
		var fieldDesc = $('#fieldDesc').val();
		var dataCode = $('#dataCode').val();
		var dataFrom = $('#dataFrom').val();
		var subNotes = $('#subNotes').val();
		if(chapterCons==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"�½�Լ������Ϊ��",type:'info'});
			return ;
		}
		if(chapterDesc==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"�½���������Ϊ��",type:'info'});
			return ;
		}
		if(entryCons==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"��ĿԼ������Ϊ��",type:'info'});
			return ;
		}
		if(entryDesc==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"��Ŀ��������Ϊ��",type:'info'});
			return ;
		}
		if(fieldCons==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"�ֶ�Լ������Ϊ��",type:'info'});
			return ;
		}
		if(fieldDesc==""){
			$.messager.popover({msg:"�ֶ���������Ϊ��",type:'info'});
			return ;
		}
		
		var parr = "Item1|"+chapterCons  + "^Item2|" + chapterDesc + "^Item3|" + entryCons + "^Item4|" + entryDesc + "^Item5|" + fieldCons+ "^Item6|" + fieldDesc+ "^Item7|" + dataCode+ "^Item8|" + dataFrom+ "^Item9|" + subNotes;
		$m({
			ClassName: "Nur.DHCNurTerminologySetSub",
			MethodName: "SaveNew",
			parr: parr,
			parId:dataRow.id,
			subId:""
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'�Ӽ���ӳɹ���',type:'success'});
				$('#subGrid').datagrid('reload');
				clearscreen()
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	/**
	 * @description �޸��ֶ���Ŀ
	 */
	function editSubItem() {
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ��������Ŀ!',type:'info'});
			return;
		}
		var subRow = $('#subGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'��ѡ��һ�������Ӽ�!',type:'info'});
			return;
		}
		var chapterCons = $('#chapterCons').val();
		var chapterDesc = $('#chapterDesc').val();
		var entryCons = $('#entryCons').val();
		var entryDesc = $('#entryDesc').val();
		var fieldCons = $('#fieldCons').val();
		var fieldDesc = $('#fieldDesc').val();
		var dataCode = $('#dataCode').val();
		var dataFrom = $('#dataFrom').val();
		var subNotes = $('#subNotes').val();
		
		if(chapterCons==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"�½�Լ������Ϊ��",type:'info'});
			return ;
		}
		if(chapterDesc==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"�½���������Ϊ��",type:'info'});
			return ;
		}
		if(entryCons==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"��ĿԼ������Ϊ��",type:'info'});
			return ;
		}
		if(entryDesc==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"��Ŀ��������Ϊ��",type:'info'});
			return ;
		}
		if(fieldCons==""&&dataRow.category=="������ͨ"){
			$.messager.popover({msg:"�ֶ�Լ������Ϊ��",type:'info'});
			return ;
		}
		if(fieldDesc==""){
			$.messager.popover({msg:"�ֶ���������Ϊ��",type:'info'});
			return ;
		}
		
		var parr = "Item1|"+chapterCons  + "^Item2|" + chapterDesc + "^Item3|" + entryCons + "^Item4|" + entryDesc + "^Item5|" + fieldCons+ "^Item6|" + fieldDesc+ "^Item7|" + dataCode+ "^Item8|" + dataFrom+ "^Item9|" + subNotes;
		$m({
			ClassName: "Nur.DHCNurTerminologySetSub",
			MethodName: "SaveNew",
			parr: parr,
			parId:dataRow.id,
			subId:subRow.subId
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'�Ӽ��޸ĳɹ���',type:'success'});
				$('#subGrid').datagrid('reload');
				clearscreen()
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	/**
	 * @description ɾ���ֶ���Ŀ
	 */
	function deleteSubItem() {
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ��������Ŀ!',type:'info'});
			return;
		}
		var subRow = $('#subGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'��ѡ��һ�������Ӽ�!',type:'info'});
			return;
		}
		$m({
			ClassName: "Nur.DHCNurTerminologySetSub",
			MethodName: "Delete",
			subId: subRow.subId
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'�Ӽ�ɾ���ɹ���',type:'success'});
				$('#subGrid').datagrid('reload');
				clearscreen();
			}
		});
	}
	function downloadSubTemp(){
		var xls = new ActiveXObject ("Excel.Application");
			
			var xlBook = xls.Workbooks.Add;
			var xlSheet = xlBook.Worksheets(1);
			
			var cols = $('#subGrid').datagrid('options').columns[0];
			var colCount = cols.length;
			var temp_obj = [];
			
			 for(i=0;i <colCount-1;i++){ 
				xlSheet.Cells(1,i+1).value =cols[i].title.trim();
				xlSheet.Cells(1,i+1).Font.Bold = true;
				xlSheet.Columns(i+1).ColumnWidth = 10; 
				xlSheet.Cells(2,i+1).value ="�Ӽ�����"+(i+1);
			}
			xlSheet.Range("L1:P5").MergeCells = true; 
			xlSheet.Cells(1,12).WrapText=true; 
			xlSheet.Cells(1,12).Font.ColorIndex = 3
			xlSheet.Cells(1,12).value ="˵����1.����������Ϊ��������ͨ��ʱ��A~F��Ϊ�����G~JΪ��ѡ�2.����������Ϊ��ͳ�Ʊ���ʱ��ֻ��F��G��j����Ҫ��д������J�пɲ��"
			
			var fname = xls.Application.GetSaveAsFilename("�Ӽ����ݵ���ģ��.xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
            xlBook.SaveAs(fname); 
            xlBook.Close(); 
            xls.Quit();  
			xls=null;
		  	xlBook=null; 
		  	xlSheet=null;			
	}
	function exportSubItem(){
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ��������Ŀ!',type:'info'});
			return;
		}
		$cm({
			ClassName: 'Nur.DHCNurTerminologySetSub',
			QueryName: 'GetPublItemSubNew',
			ResultSetType: "array",
			Par: dataRow.id
		},function(jsonData){
			
			var xls = new ActiveXObject ("Excel.Application");
			
			var xlBook = xls.Workbooks.Add;
			var xlSheet = xlBook.Worksheets(1);
			
			var cols = $('#subGrid').datagrid('options').columns[0];
			var colCount = cols.length;
			var temp_obj = [];
			
			 for(i=0;i <colCount-1;i++){ 
				xlSheet.Cells(1,i+1).value =cols[i].title.trim();
				xlSheet.Cells(1,i+1).Font.Bold = true;
				if(cols[i].hidden == true){ 
					xlSheet.Columns(i+1).ColumnWidth = 0; 
				}else{
					xlSheet.Columns(i+1).ColumnWidth = 20; 
				}
			}
			
			for (var i=0;i<jsonData.length;i++) {
				var j = 0;
				$.each(jsonData[i], function(name,value) {
					if(j<colCount-1){
						xlSheet.Cells(i+2,j+1).value = value;
					}
					j++;
				});
			}
			//xls.UserControl = true;
			//xls.Visible = true;
			var fname = xls.Application.GetSaveAsFilename(dataRow.category+"-"+dataRow.desc+"-"+dataRow.code+".xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
            xlBook.SaveAs(fname); 
            xlBook.Close(); 
            xls.Quit();     
			xls=null;
		  	xlBook=null; 
		  	xlSheet=null;
			
		});	
	}
	function inportSubItem(){
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ��������Ŀ!',type:'info'});
			return;
		}
		$('#importDialog').dialog({
			title: '�����ļ�',
			width: 400,
			height: 200,
			closed: false,
			modal: true,
			buttons: [{
				text:'����',
				handler: importSubHandler,
			},{
				text:'ȡ��',
				handler:function(){
					$('#importDialog').dialog("close");
				}
			}]

		});
	}
	function importSubHandler() {
		var filePath = $("input[name=file]").val();
		if ((filePath.indexOf(".xls") == "-1")&(filePath.indexOf(".xlsx") == "-1")) {
		   $.messager.alert('��ʾ',"��ѡ��excel����ļ���");
		   $.messager.progress('close'); 
		   return;
		}
		var realFilePath = filePath.replace(/\\/g, "\\\\");
		if(!!realFilePath){
			importSubExcel(realFilePath);
			$.messager.popover({msg:'�������!',type:'success'});
			$('#importDialog').dialog("close");
			
		}else{
			$.messager.popover({msg:'��ѡ���ļ���',type:'info'});
			return;
		}
	}
	function importSubExcel(realFilePath){
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ��������Ŀ!',type:'info'});
			return;
		}
		try{
		    var oXL = new ActiveXObject("Excel.application"); 
		    var oWB = oXL.Workbooks.open(realFilePath);
		    oWB.worksheets(1).select(); 
		    var oSheet = oWB.ActiveSheet;
			var failStr="";
		    for(var i=2;i<1000;i++) {
				var chapterCons=oSheet.Cells(i,1).value
				var chapterDesc=oSheet.Cells(i,2).value
				var entryCons=oSheet.Cells(i,3).value
				var entryDesc=oSheet.Cells(i,4).value
				var fieldCons=oSheet.Cells(i,5).value
				var fieldDesc=oSheet.Cells(i,6).value
				var dataCode=oSheet.Cells(i,7).value
				var dataFrom=oSheet.Cells(i,8).value
				var subNotes=oSheet.Cells(i,9).value
				var LinkCode=oSheet.Cells(i,10).value
				if(chapterCons=="null"||chapterCons==undefined){
					chapterCons=""
				}
				if(chapterDesc=="null"||chapterDesc==undefined){
					chapterDesc=""
				}
				if(entryCons=="null"||entryCons==undefined){
					entryCons=""
				}
				if(entryDesc=="null"||entryDesc==undefined){
					entryDesc=""
				}
				if(fieldCons=="null"||fieldCons==undefined){
					fieldCons=""
				}
				if(fieldDesc=="null"||fieldDesc==undefined){
					fieldDesc=""
				}
				if(dataCode=="null"||dataCode==undefined){
					dataCode=""
				}
				if(dataFrom=="null"||dataFrom==undefined){
					dataFrom=""
				}
				if(subNotes=="null"||subNotes==undefined){
					subNotes=""
				}
				if(LinkCode=="null"||LinkCode==undefined){
					LinkCode=""
				}
				if(fieldDesc==""){
					break;
				}
				var parr = "Item1|"+chapterCons  + "^Item2|" + chapterDesc + "^Item3|" + entryCons + "^Item4|" + entryDesc + "^Item5|" + fieldCons+"^Item6|" + fieldDesc+ "^Item7|" + dataCode+ "^Item8|" + dataFrom+ "^Item9|" + subNotes+"^LinkCode|"+LinkCode;
				var result=tkMakeServerCall("Nur.DHCNurTerminologySetSub","SaveNew",parr,dataRow.id,"");
				if(result == 0) {
				}else{
					failStr=failStr+result+";"
				}
		    }
			if(failStr!=""){
				alert(failStr);
			}
		}catch(e){
			alert(e.message)
		}
		
	    oXL.Quit();
	    $('#subGrid').datagrid('reload');
	}
	function downloadTemplate(){
		$cm({
			ResultSetType:"ExcelPlugin",
			localDir: "Self",
			ExcelName:"������ͨ��������Դģ��",	
			PageName:"DHCNurTerminologySet",
			ClassName:"Nur.DHCNurTerminologySet",
			QueryName:"DownPublItem",
			Pars: ""
		},function(){
			// hideProgressBar();
		});
		
		/*
		var xls = new ActiveXObject ("Excel.Application");
		var xlBook = xls.Workbooks.Add;
		var xlSheet = xlBook.Worksheets(1);
		
		var cols = $('#shareDataGrid').datagrid('options').columns[0];
		var colCount = cols.length;
		
		var subcols = $('#subGrid').datagrid('options').columns[0];
		var subcolCount = subcols.length;
		
		for(i=1;i <colCount-1;i++){ 
			xlSheet.Cells(1,i).value =cols[i].title.trim();
			xlSheet.Cells(1,i).Font.Bold = true;
			xlSheet.Cells(1,i).Font.Size = 12;
			xlSheet.Columns(i).ColumnWidth = 10; 
			
			xlSheet.Cells(2,i).value ="��Ŀ����1-"+i;
			xlSheet.Cells(5,i).value ="��Ŀ����2-"+i;
		}
		
		for(i=0;i <subcolCount-1;i++){ 
			xlSheet.Cells(1,i+colCount-1).value =subcols[i].title.trim();
			xlSheet.Cells(1,i+colCount-1).Font.Bold = true;
			xlSheet.Cells(1,i+colCount-1).Borders.Weight = 2; 
			xlSheet.Columns(i+colCount-1).ColumnWidth = 10; 
			xlSheet.Cells(2,i+colCount-1).value ="1-�Ӽ�����1-"+(i+1);
			xlSheet.Cells(3,i+colCount-1).value ="1-�Ӽ�����2-"+(i+1);
			xlSheet.Cells(4,i+colCount-1).value ="1-�Ӽ�����3-"+(i+1);
			
			xlSheet.Cells(5,i+colCount-1).value ="2-�Ӽ�����4-"+(i+1);
			xlSheet.Cells(6,i+colCount-1).value ="2-�Ӽ�����5-"+(i+1);
			xlSheet.Cells(7,i+colCount-1).value ="2-�Ӽ�����6-"+(i+1);
		}
		
		xlSheet.Range("A11:D16").MergeCells = true; 
		xlSheet.Cells(11,1).WrapText=true; 
		xlSheet.Cells(11,1).Font.ColorIndex = 3
		xlSheet.Cells(11,1).value ="˵����1.A~D��Ϊ��Ŀ�ֶΣ�����ABC���е��ֶβ���Ϊ�ա�A���ֶ�Ψһ���ϵͳ���Ѵ������ܵ��롣2.����������Ϊ��������ͨ��ʱ��E~J��Ϊ�����2.����������Ϊ��ͳ�Ʊ���ʱ��ֻ��JKN����Ҫ��д������N�пɲ��"
			
		
		var fname = xls.Application.GetSaveAsFilename("��������ģ��.xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
		xls=null;
		xlBook=null; 
		xlSheet=null;
		*/
	}
	/**
	 * @description ����
	 */
	function exportData() {
		
		var dataSourceRow = $('#shareDataGrid').datagrid('getChecked');
		if (dataSourceRow.length==0) {
			$.messager.popover({msg:'������ѡ��һ������!',type:'info'});
			return;
		}
		var dataIDs=""
		$.each(dataSourceRow, function(index, item){
			var shareDataId=item.id
			if(shareDataId!=""){
				if(dataIDs==""){
					dataIDs=shareDataId
				}else{
					dataIDs=dataIDs+"^"+shareDataId
				}
			}
		});
		
		$cm({
			ResultSetType:"ExcelPlugin",
			localDir: "Self",
			ExcelName:"������ͨ��������Դ",	
			PageName:"DHCNurTerminologySet",
			ClassName:"Nur.DHCNurTerminologySet",
			QueryName:"ExportPublItem",
			Pars: dataIDs
		},function(){
			// hideProgressBar();
		});
		
		return;
		$cm({
			ClassName: 'Nur.DHCNurTerminologySet',
			QueryName: 'ExportPublItem',
			ResultSetType: "array",
			Pars: dataIDs
		},function(jsonData){
			var xls = new ActiveXObject ("Excel.Application");
			var xlBook = xls.Workbooks.Add;
			var xlSheet = xlBook.Worksheets(1);
		
			var cols = $('#shareDataGrid').datagrid('options').columns[0];
			var colCount = cols.length;
		
			var subcols = $('#subGrid').datagrid('options').columns[0];
			var subcolCount = subcols.length;
		
			for(i=1;i <colCount-1;i++){ 
				xlSheet.Cells(1,i).value =cols[i].title.trim();
				xlSheet.Cells(1,i).Font.Bold = true;
				xlSheet.Cells(1,i).Font.Size = 12;
				xlSheet.Columns(i).ColumnWidth = 10; 
				xlSheet.Cells(1,i).Borders.Weight = 2; 
			}
		
			for(i=0;i <subcolCount-1;i++){ 
				xlSheet.Cells(1,i+colCount-1).value =subcols[i].title.trim();
				xlSheet.Cells(1,i+colCount-1).Font.Bold = true;
				xlSheet.Cells(1,i+colCount-1).Borders.Weight = 2; 
				xlSheet.Columns(i+colCount-1).ColumnWidth = 10; 
			
			}	
			
			for (var i=0;i<jsonData.length;i++) {
				var j = 0;
				$.each(jsonData[i], function(name,value) {
					xlSheet.Cells(i+2,j+1).value = value;
					if(j+1>4){
						xlSheet.Cells(i+2,j+1).Borders.Weight = 2; 
					}
					if((j+1<5)&&(value!="")){
						xlSheet.Cells(i+2,j+1).Borders.Weight = 2; 
						xlSheet.Cells(i+2,j+2).Borders.Weight = 2; 
					}
					j++;
				});
			}
			var fname = xls.Application.GetSaveAsFilename("������ͨ.xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
			xlBook.SaveAs(fname); 
			xlBook.Close(); 
			xls.Quit();     
			xls=null;
			xlBook=null; 
			xlSheet=null;
		});
	}
	
	/**
	 * @description ����
	 */
	function importData() {
		$('#importDialog').dialog({
			title: '�����ļ�',
			width: 400,
			height: 200,
			closed: false,
			modal: true,
			buttons: [{
				text:'����',
				handler: importHandler,
			},{
				text:'ȡ��',
				handler:function(){
					$('#importDialog').dialog("close");
				}
			}]

		});
	}
	/**
	 * @description ����
	 */
	function importHandler() {
		var filePath = $("input[name=file]").val();
		if ((filePath.indexOf(".xls") == "-1")&(filePath.indexOf(".xlsx") == "-1")) {
		   $.messager.alert('��ʾ',"��ѡ��excel����ļ���");
		   $.messager.progress('close'); 
		   return;
		}
		var realFilePath = filePath.replace(/\\/g, "\\\\");
		if(!!realFilePath){
			var aaa=importExcel(realFilePath);
			if(aaa=="") $.messager.popover({msg:'�������!',type:'success'});
			$('#importDialog').dialog("close");
			
		}else{
			$.messager.popover({msg:'��ѡ���ļ���',type:'info'});
			return;
		}
	}
	/**
	 * @description ����Excel
	 */
	function importExcel(realFilePath){
		try{
		    var oXL = new ActiveXObject("Excel.application"); 
		    var oWB = oXL.Workbooks.open(realFilePath);
		    oWB.worksheets(1).select(); 
		    var oSheet = oWB.ActiveSheet;
			var par="";
			var parID=""
			var failStr=""
		    for(var i=2;i<1000;i++) {
				var code= oSheet.Cells(i,1).value
				var desc= oSheet.Cells(i,2).value
				var category= oSheet.Cells(i,3).value
				var notes= oSheet.Cells(i,4).value
				var chapterCons= oSheet.Cells(i,5).value
				var chapterDesc= oSheet.Cells(i,6).value
				var entryCons= oSheet.Cells(i,7).value
				var entryDesc= oSheet.Cells(i,8).value
				var fieldCons= oSheet.Cells(i,9).value
				var fieldDesc= oSheet.Cells(i,10).value
				var dataCode= oSheet.Cells(i,11).value
				var dataFrom= oSheet.Cells(i,12).value
				var subNotes=oSheet.Cells(i,13).value
				var LinkCode=oSheet.Cells(i,14).value
				if(code==undefined||code=="null"){code="";}
				if(desc==undefined||desc=="null"){desc="";}
				if(category==undefined||category=="null"){category="";}
				if(notes==undefined||notes=="null"){notes="";}
				if(chapterCons==undefined||chapterCons=="null"){chapterCons="";}
				if(chapterDesc==undefined||chapterDesc=="null"){chapterDesc="";}
				if(entryCons==undefined||entryCons=="null"){entryCons="";}
				if(entryDesc==undefined||entryDesc=="null"){entryDesc="";}
				if(fieldCons==undefined||fieldCons=="null"){fieldCons="";}
				if(fieldDesc==undefined||fieldDesc=="null"){fieldDesc="";}
				if(dataCode==undefined||dataCode=="null"){dataCode="";}
				if(dataFrom==undefined||dataFrom=="null"){dataFrom="";}
				if(subNotes==undefined||subNotes=="null"){subNotes="";}
				if(LinkCode==undefined||LinkCode=="null"){LinkCode="";}
				//alert(fieldDesc)
				if(fieldDesc==""&&code==""){break;}
				//alert(fieldDesc)
				if(code!=""){
					var parr = "PublCode|"+code + "^PublDesc|" + desc + "^PublCat|" + category + "^PublMem|" + notes ;
					
					parID=tkMakeServerCall("Nur.DHCNurTerminologySet","ImportItem",parr,"",hospId)
				}
				if(parID==""||parID.indexOf("-1")>-1){
					if(parID.indexOf("-1")>-1){
						if(failStr==""){
							failStr=code+":"+parID.split("^")[1]
						}else{
							failStr=failStr+";"+code+":"+parID.split("^")[1]
						}
						parID=""
					}
					continue;
				}
				if(fieldDesc=="") continue;
				var parrsub = "Item1|"+chapterCons  + "^Item2|" + chapterDesc + "^Item3|" + entryCons + "^Item4|" + entryDesc + "^Item5|" + fieldCons+"^Item6|" + fieldDesc+ "^Item7|" + dataCode+ "^Item8|" + dataFrom+ "^Item9|" + subNotes+"^LinkCode|"+LinkCode;
				var result=tkMakeServerCall("Nur.DHCNurTerminologySetSub","SaveNew",parrsub,parID,"");
				if(result == 0) {
				}else{
					if(failStr==""){
							failStr=code+":"+chapterCons+":"+result
					}else{
							failStr=failStr+";"+code+":"+chapterCons+":"+result
					}
				}
				
		    }
			if(failStr!=""){
				alert(failStr);
			}
			
		}catch(e){
			alert(e.message)
		}
	    oXL.Quit();
	    $('#shareDataGrid').datagrid('reload');
		return failStr
	}
	
	initUI();
});