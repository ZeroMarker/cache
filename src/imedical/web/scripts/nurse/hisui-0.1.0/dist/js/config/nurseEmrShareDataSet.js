var hospId=session['LOGON.HOSPID'];
var HospEnvironment=true;
$(function() { 
	/**
	 * @description 初始化界面
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
		}  ///选中事件
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
                { value: "互联互通"},
                { value: "统计报表"}
            ]
		});
		
	}
	/**
	 * @description 查询数据
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
					text: '增加',
					handler: addDataItem
				}, {
					iconCls: 'icon-edit',
					text: '修改',
					handler: editDataItem
				}, {
					iconCls: 'icon-remove',
					text: '删除',
					handler: deleteDataItem
				}, {
					iconCls: 'icon-export',
					text: '导出',
					handler: exportData,
				}, {
					iconCls: 'icon-import',
					text: '导入',
					handler: importData
				}, {
					iconCls: 'icon-download',
					text: '下载模板',
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
	 * @description 初始化字段表格
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
					text: '增加',
					handler: function() {
						addSubItem();
					}
				}, {
					iconCls: 'icon-edit',
					text: '修改',
					handler: function() {
						editSubItem();
					}
				}, {
					iconCls: 'icon-remove',
					text: '删除',
					handler: function() {
						deleteSubItem();
					}
				}, {
					iconCls: 'icon-export',
					text: '导出',
					handler: function() {
						exportSubItem();
					}
				}, {
					iconCls: 'icon-import',
					text: '导入',
					handler: function() {
						inportSubItem();
					}
				}, {
					iconCls: 'icon-download',
					text: '下载模板',
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
	 * @description 数据源表格点击事件
	 */
	function shareDataGridClickRow(rowIndex, rowData) {
		setCommonInfo(rowData);
		
		/*if(rowData.category=="统计报表"){
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
			
		}else if(rowData.category=="互联互通"){
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
	 * @description 字段表格点击事件
	 */
	function subGridClickRow(rowIndex, rowData) {
		setCommonInfo(rowData);
	}
	/**
	 * @description 加载表格的行信息
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
	 * @description 增加数据源条目
	 */
	function addDataItem() {
		var code = $('#code').val();
		var desc = $('#desc').val();
		var notes = $('#notes').val();
		var category = $('#category').combobox('getText');
		if(code==""){
			$.messager.popover({msg:'共享代码不可为空!',type:'error'});
			return;
		}
		if(desc==""){
			$.messager.popover({msg:'项目名称不可为空!',type:'error'});
			return;
		}
		if(category==""){
			$.messager.popover({msg:'所属类别不可为空!',type:'error'});
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
				$.messager.popover({msg:'添加成功！',type:'success'});
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
	 * @description 修改数据源条目
	 */
	function editDataItem() {
		var dataSourceRow = $('#shareDataGrid').datagrid('getChecked');
		
		if (dataSourceRow.length==0) {
			$.messager.popover({msg:'请选择一条数据源!',type:'info'});
			return;
		}
		if(dataSourceRow.length>1){
			$.messager.popover({msg:'只能选择一条数据源!',type:'info'});
			return;
		}
		var code = $('#code').val();
		var desc = $('#desc').val();
		var notes = $('#notes').val();
		var category = $('#category').combobox('getText');
		if(code==""){
			$.messager.popover({msg:'共享代码不可为空!',type:'error'});
			return;
		}
		if(desc==""){
			$.messager.popover({msg:'项目名称不可为空!',type:'error'});
			return;
		}
		if(category==""){
			$.messager.popover({msg:'所属类别不可为空!',type:'error'});
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
					$.messager.popover({msg:'修改成功！',type:'success'});
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
	 * @description 删除数据源条目
	 */
	function deleteDataItem() {
		var dataSourceRow = $('#shareDataGrid').datagrid('getChecked');
		if (dataSourceRow.length==0) {
			$.messager.popover({msg:'请选择一条数据源!',type:'info'});
			return;
		}
		$.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
			if (r) {
				
				$.each(dataSourceRow, function(index, item){
			
					$m({
						ClassName: "Nur.DHCNurTerminologySet",
						MethodName: "Delete",
						id: item.id,
						hospId:hospId
					},function(result){
			
						if(result == 0) {
							$.messager.popover({msg:'删除成功！',type:'success'});
							$('#shareDataGrid').datagrid('reload');
							$('#subGrid').datagrid('reload');
							clearscreen();
						}else{
							$.messager.popover({msg:'删除失败！',type:'error'});
						}
					});				
				
				});	
			}
		});
		
		
		
	}

	
	

	/**
	 * @description 增加字段条目
	 */
	function addSubItem() {
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'请在左侧选择一条共享项目!',type:'info'});
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
		if(chapterCons==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"章节约束不可为空",type:'info'});
			return ;
		}
		if(chapterDesc==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"章节描述不可为空",type:'info'});
			return ;
		}
		if(entryCons==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"条目约束不可为空",type:'info'});
			return ;
		}
		if(entryDesc==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"条目描述不可为空",type:'info'});
			return ;
		}
		if(fieldCons==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"字段约束不可为空",type:'info'});
			return ;
		}
		if(fieldDesc==""){
			$.messager.popover({msg:"字段描述不可为空",type:'info'});
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
				$.messager.popover({msg:'子集添加成功！',type:'success'});
				$('#subGrid').datagrid('reload');
				clearscreen()
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	/**
	 * @description 修改字段条目
	 */
	function editSubItem() {
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'请在左侧列表选择一条共享项目!',type:'info'});
			return;
		}
		var subRow = $('#subGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'请选择一条数据子集!',type:'info'});
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
		
		if(chapterCons==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"章节约束不可为空",type:'info'});
			return ;
		}
		if(chapterDesc==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"章节描述不可为空",type:'info'});
			return ;
		}
		if(entryCons==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"条目约束不可为空",type:'info'});
			return ;
		}
		if(entryDesc==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"条目描述不可为空",type:'info'});
			return ;
		}
		if(fieldCons==""&&dataRow.category=="互联互通"){
			$.messager.popover({msg:"字段约束不可为空",type:'info'});
			return ;
		}
		if(fieldDesc==""){
			$.messager.popover({msg:"字段描述不可为空",type:'info'});
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
				$.messager.popover({msg:'子集修改成功！',type:'success'});
				$('#subGrid').datagrid('reload');
				clearscreen()
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	/**
	 * @description 删除字段条目
	 */
	function deleteSubItem() {
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'请在左侧列表选择一条共享项目!',type:'info'});
			return;
		}
		var subRow = $('#subGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'请选择一条数据子集!',type:'info'});
			return;
		}
		$m({
			ClassName: "Nur.DHCNurTerminologySetSub",
			MethodName: "Delete",
			subId: subRow.subId
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'子集删除成功！',type:'success'});
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
				xlSheet.Cells(2,i+1).value ="子集数据"+(i+1);
			}
			xlSheet.Range("L1:P5").MergeCells = true; 
			xlSheet.Cells(1,12).WrapText=true; 
			xlSheet.Cells(1,12).Font.ColorIndex = 3
			xlSheet.Cells(1,12).value ="说明：1.当导入的类别为‘互联互通’时，A~F列为必填项，G~J为可选项。2.当导入的类别为‘统计报表’时，只有F，G，j列需要填写，其中J列可不填。"
			
			var fname = xls.Application.GetSaveAsFilename("子集数据导入模板.xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
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
			$.messager.popover({msg:'请在左侧列表选择一条共享项目!',type:'info'});
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
			$.messager.popover({msg:'请在左侧列表选择一条共享项目!',type:'info'});
			return;
		}
		$('#importDialog').dialog({
			title: '导入文件',
			width: 400,
			height: 200,
			closed: false,
			modal: true,
			buttons: [{
				text:'导入',
				handler: importSubHandler,
			},{
				text:'取消',
				handler:function(){
					$('#importDialog').dialog("close");
				}
			}]

		});
	}
	function importSubHandler() {
		var filePath = $("input[name=file]").val();
		if ((filePath.indexOf(".xls") == "-1")&(filePath.indexOf(".xlsx") == "-1")) {
		   $.messager.alert('提示',"请选择excel表格文件！");
		   $.messager.progress('close'); 
		   return;
		}
		var realFilePath = filePath.replace(/\\/g, "\\\\");
		if(!!realFilePath){
			importSubExcel(realFilePath);
			$.messager.popover({msg:'导入完成!',type:'success'});
			$('#importDialog').dialog("close");
			
		}else{
			$.messager.popover({msg:'请选择文件！',type:'info'});
			return;
		}
	}
	function importSubExcel(realFilePath){
		var dataRow = $('#shareDataGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'请在左侧列表选择一条共享项目!',type:'info'});
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
			ExcelName:"互联互通共享数据源模板",	
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
			
			xlSheet.Cells(2,i).value ="项目数据1-"+i;
			xlSheet.Cells(5,i).value ="项目数据2-"+i;
		}
		
		for(i=0;i <subcolCount-1;i++){ 
			xlSheet.Cells(1,i+colCount-1).value =subcols[i].title.trim();
			xlSheet.Cells(1,i+colCount-1).Font.Bold = true;
			xlSheet.Cells(1,i+colCount-1).Borders.Weight = 2; 
			xlSheet.Columns(i+colCount-1).ColumnWidth = 10; 
			xlSheet.Cells(2,i+colCount-1).value ="1-子集数据1-"+(i+1);
			xlSheet.Cells(3,i+colCount-1).value ="1-子集数据2-"+(i+1);
			xlSheet.Cells(4,i+colCount-1).value ="1-子集数据3-"+(i+1);
			
			xlSheet.Cells(5,i+colCount-1).value ="2-子集数据4-"+(i+1);
			xlSheet.Cells(6,i+colCount-1).value ="2-子集数据5-"+(i+1);
			xlSheet.Cells(7,i+colCount-1).value ="2-子集数据6-"+(i+1);
		}
		
		xlSheet.Range("A11:D16").MergeCells = true; 
		xlSheet.Cells(11,1).WrapText=true; 
		xlSheet.Cells(11,1).Font.ColorIndex = 3
		xlSheet.Cells(11,1).value ="说明：1.A~D列为项目字段，其中ABC三列的字段不可为空。A列字段唯一如果系统中已存在则不能导入。2.当导入的类别为‘互联互通’时，E~J列为必填项。2.当导入的类别为‘统计报表’时，只有JKN列需要填写，其中N列可不填。"
			
		
		var fname = xls.Application.GetSaveAsFilename("整体数据模板.xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
		xls=null;
		xlBook=null; 
		xlSheet=null;
		*/
	}
	/**
	 * @description 导出
	 */
	function exportData() {
		
		var dataSourceRow = $('#shareDataGrid').datagrid('getChecked');
		if (dataSourceRow.length==0) {
			$.messager.popover({msg:'请至少选择一条数据!',type:'info'});
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
			ExcelName:"互联互通共享数据源",	
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
			var fname = xls.Application.GetSaveAsFilename("互联互通.xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
			xlBook.SaveAs(fname); 
			xlBook.Close(); 
			xls.Quit();     
			xls=null;
			xlBook=null; 
			xlSheet=null;
		});
	}
	
	/**
	 * @description 导入
	 */
	function importData() {
		$('#importDialog').dialog({
			title: '导入文件',
			width: 400,
			height: 200,
			closed: false,
			modal: true,
			buttons: [{
				text:'导入',
				handler: importHandler,
			},{
				text:'取消',
				handler:function(){
					$('#importDialog').dialog("close");
				}
			}]

		});
	}
	/**
	 * @description 导入
	 */
	function importHandler() {
		var filePath = $("input[name=file]").val();
		if ((filePath.indexOf(".xls") == "-1")&(filePath.indexOf(".xlsx") == "-1")) {
		   $.messager.alert('提示',"请选择excel表格文件！");
		   $.messager.progress('close'); 
		   return;
		}
		var realFilePath = filePath.replace(/\\/g, "\\\\");
		if(!!realFilePath){
			var aaa=importExcel(realFilePath);
			if(aaa=="") $.messager.popover({msg:'导入完成!',type:'success'});
			$('#importDialog').dialog("close");
			
		}else{
			$.messager.popover({msg:'请选择文件！',type:'info'});
			return;
		}
	}
	/**
	 * @description 导入Excel
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