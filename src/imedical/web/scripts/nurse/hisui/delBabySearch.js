$(function() {
	function initUI() {
		initSearchForm();
		initGrid();
	}

	function search() {
		initBabyData();
	}

	function initBabyData() {
		$('#babyGrid').datagrid('clearSelections');
		$HUI.datagrid('#babyGrid').load();
	}


	function initSearchForm() {
		function filter(q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField];
			var pyjp = getPinyin(text).toLowerCase();
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
		}

		//???????
		$('#startDate').datebox('setValue', dateCalculate(now, 0));
		$('#endDate').datebox('setValue', dateCalculate(now, 0));


		//???????combox
		$HUI.combobox('#outCome', {
			valueField: 'ID',
			textField: 'desc',
			url: $NURURL + '?className=Nur.IP.Delivery&methodName=findOutCome',
			onSelect: function(record) {},
			filter: filter
		});

		//?????combox
		$HUI.combobox('#department', {
			valueField: 'ID',
			textField: 'desc',
			url: $NURURL + '?className=Nur.IP.Delivery&methodName=findDepartment',
			onSelect: function(record) {},
			filter: filter
		});
		$('#searchBtn').click(search);
		$('#printBtn').click(print);
	}


	function initGrid() {
		/*$cm({
			ClassName: "Nur.QueryBrokerNew",
			MethodName: "getTableColumnOfHISUI",
			className: "Nur.IP.Delivery",
			classQuery: "findBabyInfo"
		}, function(columns) {
			columns.forEach(function(column) {
				if ((column.field === "leftEarFlag") || (column.field === "rightEarFlag")) {
					column.editor = {
						type: 'checkbox',
						options: {
							on: '是',
							off: '否'
						}
					};
					column.align = "center";

				}
			});
			columns.unshift({
				field: "selection",
				title: "选择",
				width: 40,
				checkbox: true
			})*/


			//???????
			$HUI.datagrid('#babyGrid', {
				autoSizeColumn: true,
				fit: true,
				queryParams: {
					ClassName: "Nur.IP.Delivery",
					QueryName: "findBabyInfo"
				},
				url: $URL,
				//url: $URL+ '?className=Nur.IP.Delivery&methodName=findBabyInfo',
				className:"Nur.IP.Delivery",
				queryName:"findBabyInfo",
				onColumnsLoad:function(cm){
					cm.unshift({
						field: "selection",
						title: "选择",
						width: 40,
						checkbox: true
					})
					var columnsConfig={};
					for (var i=0;i<cm.length;i++){
						columnsConfig={};
						var filedName=cm[i]['field'];
						//$.extend(columnsConfig,{sortable:true});
						switch (filedName) {
							case "leftEarFlag":
								$.extend(columnsConfig,{
									editor:{
										type: 'icheckbox',
										options: {
											on: "是",
											off: "否"
										}
									},
									align :"center",
									formatter: function(value,row,index){
										return $g(value);
									}
								});
								break;
							case "rightEarFlag":
								$.extend(columnsConfig,{
									editor:{
										type: 'icheckbox',
										options: {
											on: "是",
											off: "否"
										}
									},
									align :"center",
									formatter: function(value,row,index){
										return $g(value);
									}
								});
								break;
							default:
								break;
						}
						$.extend(cm[i],columnsConfig)
					}
				},
				fitColumns: false,
				headerCls: 'panel-header-gray',
				//columns: [columns],
				idField: 'babyID',
				rownumbers:true,
				toolbar: [{
					iconCls: 'icon-ok',
					text: '保存',
					handler: function() {
						saveHearingScreening();
					}
				},
				{
					iconCls: 'icon-ok',
					text: '批量通过听力筛查',
					handler: function() {
						saveHearingScreening("Y");
					}
				},
				{
					iconCls: 'icon-ok',
					id:"sum"
				}],
				onBeforeLoad: function(param) {
					param.startDate = $HUI.datebox('#startDate').getValue(); //parameter1
					param.endDate = $HUI.datebox('#endDate').getValue();
					param.outCome = $HUI.combobox('#outCome').getValue() ? $HUI.combobox('#outCome').getValue() : '';
					param.department = $HUI.combobox('#department').getValue() ? $HUI.combobox('#department').getValue() : '';
					param.hospID = session['LOGON.HOSPID'];
				},
				onClickRow: function(index,data) {
					$('#babyGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
					if(data.babyOutComeDesc==$g("流产") || data.babyOutComeDesc==$g("死胎")){
						var ed=$("#babyGrid").datagrid("getEditor",{index:index,field:'leftEarFlag'});
						var ed2=$("#babyGrid").datagrid("getEditor",{index:index,field:'rightEarFlag'});
						$(ed.target).attr("disabled",true);	
						$(ed2.target).attr("disabled",true);	
					}
				},
				onDblClickRow: function(index, data) {
					initDetailData(data);
				},
				onLoadSuccess:function(data){
					$("#sum")[0].text=$g("共 ")+data.total+$g(" 人");
				}
			});

			//修改table高度
			var gridHeight = (document.body.scrollHeight - $('#searchForm').height() - 130);
			$("#babyGridDiv").find(".panel").find(".datagrid-wrap").css("height", gridHeight + "px");

			//修改table head 样式
			$('.panel-title').each(function() {
				$(this).html('<p>' + $(this).html() + '</>')
			})
		//});
	}
	
	function saveHearingScreening(result) {
		var rowsData = $('#babyGrid').datagrid('getSelections')
		if (rowsData.length === 0) {
			$.messager.alert("提示", "请选择需要保存的婴儿信息!", 'info');
			return;
		}
		var errors = [];
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var babyID = rowData['babyID'];
			var index = $('#babyGrid').datagrid('getRowIndex', babyID)
			$('#babyGrid').datagrid('selectRow', index).datagrid('endEdit', index);
			if (result){
				var leftEarFlag = "Y",rightEarFlag="Y";
				if (rowsData[i].EpisodeID=="") continue;
			}else{
				var leftEarFlag = rowData['leftEarFlag'];
				if (leftEarFlag==$g("是")) leftEarFlag="Y";
				else if(leftEarFlag==$g("否")) leftEarFlag="N";
				var rightEarFlag = rowData['rightEarFlag'];
				if (rightEarFlag==$g("是")) rightEarFlag="Y";
				else if(rightEarFlag==$g("否")) rightEarFlag="N";
			}
			var babyName = rowData['babyName'];
			var ret = tkMakeServerCall("Nur.IP.Delivery", "saveHearingScreening", babyID, leftEarFlag, rightEarFlag);
			if (ret != 0) {
				errors.push(errors);
			}
		}
		if (errors.length !== 0) {
			$.messager.alert("提示", errors.join(",") + "保存失败!", 'info');
		}
		search();
	}

	function print() {
		var rowsData = $('#babyGrid').datagrid('getSelections')
		if (rowsData.length === 0) {
			$.messager.alert("提示", "请选择需要打印的婴儿信息!", 'info');
			return;
		}
		var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add();"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Columns.NumberFormatLocal = '@';"
		//设置工作薄名称  
		//Str +="xlSheet.name = '"+session['LOGON.HOSPDESC']+"新生儿清单.xlsx';"; 
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
		//var filename=session['LOGON.HOSPDESC']+"新生儿清单.xlsx";
		var filename="tt.xlsx";
		Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		
		/*var xlsExcel, xlsSheet, xlsBook;
		var titleRows, titleCols, LeftHeader, CenterHeader, RightHeader;
		var LeftFooter, CenterFooter, RightFooter, frow, fCol, tRow, tCol;
		var path, fileName, fso;
		path = tkMakeServerCall("web.DHCLCNUREXCUTE", "GetPath");
		fileName = path + "procbabyinfo.xls";
		xlsExcel = new ActiveXObject("Excel.Application");

		xlsBook = xlsExcel.Workbooks.Add(fileName)
		xlsSheet = xlsBook.ActiveSheet
		var hospitalDesc = tkMakeServerCall("Nur.IP.Delivery", "getHospitalDesc", session['LOGON.CTLOCID']);
		xlsSheet.cells(1, 1) = hospitalDesc + " " + "新生儿清单"
		fontcell(xlsSheet, 1, 1, 1, 16);
		var Num = 2
		for (var i = 0; i < rowsData.length; i++) {

			var babyID = rowData['babyID'];
			var prtdata = tkMakeServerCall("web.DHCPADelBaby", "GetPrintData", babyID)
			var str = prtdata.split("^");
			Num = Num + 1
			xlsSheet.cells(Num, 1) = str[0];
			xlsSheet.cells(Num, 2) = str[1];
			xlsSheet.cells(Num, 3) = str[2];

			xlsSheet.cells(Num, 4) = str[5];
			xlsSheet.cells(Num, 5) = str[6];

			xlsSheet.cells(Num, 6) = str[10];
			xlsSheet.cells(Num, 7) = str[12];
			xlsSheet.cells(Num, 8) = str[13];
			xlsSheet.cells(Num, 9) = str[14];
			xlsSheet.cells(Num, 10) = str[15];

		}
		xlsExcel.Visible = true
		xlsSheet.PrintPreview
		//xlsSheet.PrintOut(); 
		//xlsSheet = null;
		xlsBook.Close(savechanges = false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;*/
	}
	initUI();

})

