$(function() {
	initUI();
})
	//存储查询的参数
	var currentRequestParam = {
		summaryDrugGrid: '',
		detailDrugGrid: ''
	};

	function initUI() {
		//initPatientTree();
		initSearchForm();
		
	}

	function search() {
		var startDate = $HUI.datebox('#startDate').getValue();
		var startTime = $HUI.timespinner('#startTime').getValue();
		var endDate = $HUI.datebox('#endDate').getValue();
		var endTime	= $HUI.timespinner('#endTime').getValue();
		if(1==compareDate(startDate,endDate)){
			$.messager.alert("提示", "结束日期小于开始日期", 'info');
			return;
		}
		if(0==compareDate(startDate,endDate)&&1==compareTime(startTime,endTime)){
			$.messager.alert("提示", "结束时间小于开始时间", 'info');
			return;
		}
		initSummayData();
		currentRequestParam['detailDrugGrid']={};
		$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
	}

	function initSummayData() {
		$('#summaryDrugGrid').datagrid('clearSelections');
		$HUI.datagrid('#summaryDrugGrid').load();
	}

	function initDetailData(data) {
		/*$("#detailDrugGrid").datagrid({
			loadFilter: function(data1){				
				var value={
					total:data1.total,
					rows:[]
				};
				var x=0;
				for (var i = 0; i < data1.length; i++) {  
					if(data1[i].Audit==""&&(!$HUI.checkbox('#Audittyp').getValue())){
						value.rows[x++]=data1[i];
					}
					if(data1[i].Audit!=""&&($HUI.checkbox('#Audittyp').getValue())){
						value.rows[x++]=data1[i];
					}
				}
				return value;
			}
		});*/
		var param = {};
		param.parameter1 = session['LOGON.USERID'];
		param.parameter2 = data.Process;
		param.parameter3 = data.ArRow;
		param.parameter4 = data.recLocId;
		param.parameter5 = $("#Return").checkbox("getValue")?"Y":"N";
		currentRequestParam['detailDrugGrid'] = param;
		$('#detailDrugGrid').datagrid('clearSelections');
		$HUI.datagrid('#detailDrugGrid').load(param);
	}

	/*function initPatientTree() {

		//初始化病人树列表
		$HUI.tree('.patientTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "Nur.NIS.Service.Base.Ward",
					MethodName: "GetWardPatientsNew",
					wardID: session['LOGON.WARDID'],
					adm: EpisodeID,
					groupSort: "",
					babyFlag: "",
					searchInfo: "",
					locID: session['LOGON.CTLOCID']||'',
					transInHospFlag:"",
					consultationFlag:""
				}, function(data) {

					//添加id和text 使给vue使用的数据符合his ui tree的格式
					var addIDAndText = function(node) {
						node.id = node.ID;
						if (node.id == EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.text = $g(node.label);
							node.children.forEach(addIDAndText);
						}
						else{
							node.text = node.label;
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			},
			onLoadSuccess: function() {
				initGrid();
				initSummayData();
			},
			lines: true,
			checkbox: true
		});
	}*/

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
		if (typeof periodString !== "undefined") {
			//初始化日期时间
			$('#startDate').datebox('setValue', dateCalculate(new Date(), parseInt(periodString.split("^")[0]), 10));
			$('#endDate').datebox('setValue', dateCalculate(new Date(), parseInt(periodString.split("^")[1]), 10));
			/*$('#startTime').timespinner('setValue', periodString.split("^")[2]);
			$('#endTime').timespinner('setValue', periodString.split("^")[3]);*/
			$HUI.timespinner('#startTime').setValue(periodString.split("^")[2]);
			$HUI.timespinner('#endTime').setValue(periodString.split("^")[3]);
		}
		if (typeof periodString !== "undefined") {
			//根据后台配置添加查询条件checkbox
			var checkBoxLabelArray = checkBoxLableString.split("^");
			var checkBoxKeyArray = checkBoxKeyString.split("^");
			var checkBoxCheckStatusArray = checkBoxCheckStatusString.split("^");
			var checkBoxHiddenStatusArray = checkBoxHiddenStatusString.split("^");
			var checkBoxRowStringArray = ["", ""];
			var checkBoxArray = [];
			var count = 0;
			checkBoxHiddenStatusArray.forEach(function(checkBoxHiddenStatus, index) {
				var checkBoxRowString = ""
				if (checkBoxHiddenStatus != "hidden") {
					checkBoxRowString = "<input id='" +
						checkBoxKeyArray[index] +
						"' class='hisui-checkbox' type='checkbox'>";
					if ((count % 2) === 0) {
						checkBoxRowStringArray[0] = checkBoxRowStringArray[0] + checkBoxRowString;
					} else {
						checkBoxRowStringArray[1] = checkBoxRowStringArray[1] + checkBoxRowString;
					}
					checkBoxArray.push({
						id: checkBoxKeyArray[index],
						label: checkBoxLabelArray[index],
						checked: checkBoxCheckStatusArray[index] === "checked"
					});
					count++;
				}
			});
			if (checkBoxArray.length !== 0) {
				$('#searchForm #searhFormTable tr').each(function(index) {
					$(this).append("<td class='r-label' style=''>" + checkBoxRowStringArray[index] + "</td>");
				});
				checkBoxArray.forEach(function(checkBox) {
					$HUI.checkbox("#" + checkBox.id, checkBox);
				});
			}
		}
		//初始化药房combox
		$HUI.combobox('#pharmacy', {
			valueField: 'ID',
			textField: 'desc',
			url: $URL + '?ClassName=Nur.IP.DrugAudit&MethodName=getPharmacy&HospID='+session['LOGON.HOSPID'],
			onSelect: function(record) {
				var pharmacyDr="";
				if (record) {
					pharmacyDr=record.ID;
				}
				resetDateTimeRange(pharmacyDr);
			},
			onChange:function(newValue, oldValue){
				if (!newValue){
					resetDateTimeRange("");
				}
			},
			filter: filter
		});

		//初始化药品combox
		$HUI.combobox('#arcimDR', {
			valueField: 'ID',
			textField: 'desc',
			url: $URL + '?ClassName=Nur.IP.DrugAudit&MethodName=getMedicine&HospID='+session['LOGON.HOSPID'],
			onSelect: function(record) {},
			filter: filter
		});
		$('#searchBtn').click(search);
		$('#ReadyDrugBtn').click(ReadyDrug);   //zhangxiangbo
		$('#printBtn').click(printBtnClick);   
		$('#messageBtn').click(messageBtnClick); // EH 2020-09-17 移到药房接口新，通知备药
	}
	//新加  zhangxiangbo
	function ReadyDrug()
	{
	
		var wardId=session['LOGON.WARDID'];
	 	var phLocStr=tkMakeServerCall("Nur.IP.DrugAudit","getDispensingLocIDString");		var msg=tkMakeServerCall("web.DHCSTINTERFACE","SaveMessageByAudit",phLocStr,wardId,session['LOGON.USERID']);
		if(msg=="0"){
			$.messager.alert("提示", "消息发送成功。", 'success');
		}else if(msg=="-1"){
			$.messager.alert("提示", "接收科室不存在！", 'info');
		}else if(msg=="-2"){
			$.messager.alert("提示", "病区不存在！", 'info');
		}else{
			$.messager.alert("提示", "消息发送失败！", 'info');
		}
	}
	function getGridColumns(columnTitleString, columnKeyString, columnWidthString, columnHiddenStatusString,ifFrozen,frozenNum) {
		var columnTitleArray = columnTitleString.split("^");
		var columnKeyArray = columnKeyString.split("^");
		var columnWidthArray = columnWidthString.split("^");
		var columnHiddenStatusArray = columnHiddenStatusString.split("^");
		var columns = [];
		var count=0;
		columnHiddenStatusArray.forEach(function(hiddenStatus, index) {
			if (hiddenStatus !== "hidden") {
				var column = {
					field: columnKeyArray[index],
					title: columnTitleArray[index],
					width: parseInt(columnWidthArray[index], 10)
				};
				if (index === 0) {
					column.checkbox = true;
				}
				if (columnKeyArray[index] === 'errcode1') {
					column.styler = function(value, row, index) {
						var style = '';
						var controlItemKeyArray = controlItemKeyString.split('^');
						var controlItemColorArray = controlItemColorString.split('^');
						var controlItemLableArray = controlItemLableString.split('^');
						controlItemKeyArray.forEach(function(controlItemKey, index) {
							if (controlItemKey === row.errcode) {
								style = 'color:white;background-color:' + controlItemColorArray[index];
							}
							else{
								if(row.errcode.indexOf(controlItemKey)>-1){
									if (index==0){
										style = style+'border-top-width: 13px;border-top-color:' + controlItemColorArray[index]+";" ;
									}
									else if(index==1){
										style = style+'color:white;background-color:' + controlItemColorArray[index]+";" ;
									}
									else if(index==2){
										style = style+'border-bottom-width: 13px;border-bottom-color:' + controlItemColorArray[index] +";";
									}
									else{
										style = style+'border-left-width: 50px;border-left-color:' + controlItemColorArray[index] +";";
									}
								}
							}
						});
						return style;
					}
				}
				if (ifFrozen&&count<frozenNum){
					columns.push(column);
				}
				if (frozenNum!=""&&!ifFrozen&&count>=frozenNum){
					columns.push(column);
				}
				if (ifFrozen==""&&frozenNum==""){
					columns.push(column);
				}
				count=count+1;
			}
		});
		columns.push({
			field: 'no',
			title: 'no',
			width: 0,
			hidden:true
		});
		return columns;
	}

	function getDisposeStatColor() {


	var str = "<table>" + "<tr>" + labHtmlString + "</tr>" + " </table>";

	return str;
}


	function initGrid() {
		$("#drugSummaryAuditBtn").click(drugSummaryAudit);
		$("#drugSummaryAuditCancelBtn").click(drugSummaryAuditCancel);
		//初始化汇总表格
		$HUI.datagrid('#summaryDrugGrid', {
			autoSizeColumn: false,
			fit: true,
			url: $NURURL + '?className=Nur.IP.DrugAudit&methodName=getDrugSummary',
			fitColumns: false,
			headerCls: 'panel-header-gray',
			columns: [getGridColumns(summaryTableColumnTitleString, summaryTableColumnKeyString, summaryTableColumnWidthString, summaryTableColumnHiddenStatusString,"","")],
			idField: 'no',
			/*toolbar: [{
					iconCls: 'icon-ok',
					text: '药品审核',
					handler: function() {
						drugSummaryAudit();
					}
				}, {
					iconCls: 'icon-cancel-order',
					text: '撤销审核',
					handler: function() {
						drugSummaryAuditCancel();
					}
				}
				// , {
				// 	iconCls: 'icon-funnel-half',
				// 	text: '审核后暂缓配液',
				// 	handler: function() {
				// 		drugSummaryAuditDelay()
				// 	}
				// }
			],*/
			onBeforeLoad: function(param) {
				/*episodeIDArray = [];
				$HUI.tree(".patientTree").getChecked().forEach(function(node) {
					episodeIDArray.push(node.ID);
				});
				param.parameter1 = episodeIDArray.join("^");*/
				param.parameter1 = EpisodeIDStr;
				if(param.parameter1==""){
					$.messager.popover({msg: '请选择患者！',type:'alert'});
					$("#summaryDrugGrid").datagrid("loadData", { total: 0, rows: [] });
					$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
					return;
				}else{
					if (!checkPatsDisChargeStatus()) return;
				}
				param.parameter2 = session['LOGON.USERID'];
				param.parameter3 = session['LOGON.CTLOCID'];
				param.parameter4 = $HUI.datebox('#startDate').getValue();
				param.parameter5 = $HUI.timespinner('#startTime').getValue();
				param.parameter6 = $HUI.datebox('#endDate').getValue();
				param.parameter7 = $HUI.timespinner('#endTime').getValue();
				var checkBoxKeyArray = checkBoxKeyString.split("^");
				var conditionArray = [];
				checkBoxKeyArray.forEach(function(key) {
					var object = $HUI.checkbox("#" + key);
					if (object) {
						var value = object.getValue();
						conditionArray.push(key + "|" + value);
					}
				})
				param.parameter8 = conditionArray.join("^");
				param.parameter9 = $HUI.combobox('#arcimDR').getValue()?$HUI.combobox('#arcimDR').getValue():'';
				param.parameter10 = $HUI.combobox('#pharmacy').getValue()?$HUI.combobox('#pharmacy').getValue():'';
				currentRequestParam['summaryDrugGrid'] = param;

			},
			onLoadSuccess:function(data){
				dspRecLocId="";
				//var packFlag = $HUI.checkbox('#summaryPack').getValue() ? 'Y' : '';
				//ret = tkMakeServerCall('Nur.IP.DrugAudit', 'AutoAudit', session['LOGON.USERID'],session['LOGON.CTLOCID'], packFlag);		
				if (currentRequestParam['detailDrugGrid']) {
					if (data.total > 0){
						for(var i=0;i<data.total;i++){
							if ((data.rows[i].ArRow == currentRequestParam['detailDrugGrid'].parameter3)&&(data.rows[i].recLocId == currentRequestParam['detailDrugGrid'].parameter4)){
								dspRecLocId = data.rows[i].recLocId;
								break;
							}
						}
						currentRequestParam['detailDrugGrid'].parameter2 = data.rows[0].Process;
						$('#detailDrugGrid').datagrid('clearSelections');
						$HUI.datagrid('#detailDrugGrid').load(currentRequestParam['detailDrugGrid']);
					}else{
						dspRecLocId = "";
						currentRequestParam['detailDrugGrid']={};
						$('#detailDrugGrid').datagrid('clearSelections');
						$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
					}
				}
			},
			onDblClickRow: function(index, data) {
				dspRecLocId=data.recLocId;
				initDetailData(data);
			}
		});

		//table toolbar 添加checkbox
		//$("#summaryDiv").find(".datagrid-toolbar").find("tr").append("<td><input id='summaryPack' type='checkbox'></td>");
		//$("#summaryDiv").find(".datagrid-toolbar").find("tr").append(getDisposeStatColor());
		var controlItemLableArr=controlItemLableString.split('^');
		for(var i=0;i<controlItemLableArr.length;i++){
			$('#summaryDrugGridTB > table > tbody > tr').append('<td><a href="#" class="orderDisposeStatInfo__disposeStat is-label" style="background-color:'+controlItemColorString.split('^')[i]+';">&nbsp;&nbsp;&nbsp;&nbsp;'+$g(controlItemLableArr[i])+'<span class="orderDisposeStatInfo__triangle" style="border-right-color:'+controlItemColorString.split('^')[i]+';"><span class="orderDisposeStatInfo__circle"></span></span></a></TD>');
		}
		
		/*$HUI.checkbox("#summaryPack", {
			label: '打包标志'
		});*/

		//修改table高度
		var gridHeight = (document.body.scrollHeight - $('#searchForm').height() - 131) / 2;
		$("#summaryDiv").find(".panel").find(".datagrid-wrap").css("height", gridHeight + "px");

		//初始化明细表格
		$HUI.datagrid('#detailDrugGrid', {
			fit: true,
			url: $NURURL + '?className=Nur.IP.DrugAudit&methodName=getDrugDetail',
			autoSizeColumn: false,
			idField: 'no',
			fitColumns: false,
			headerCls: 'panel-header-gray',
			frozenColumns: [getGridColumns(detailsTableColumnTitleString, detailsTableColumnKeyString, detailsTableColumnWidthString, detailsTableColumnHiddenStatusString,true,"4")],
			columns: [getGridColumns(detailsTableColumnTitleString, detailsTableColumnKeyString, detailsTableColumnWidthString, detailsTableColumnHiddenStatusString,false,"4")],
			toolbar: [{
					iconCls: 'icon-ok',
					text: '明细审核',
					handler: function() {
						drugDetailsAudit();
					}
				}, {
					iconCls: 'icon-cancel-order',
					text: '撤销审核',
					handler: function() {
						drugDetailsAuditCancel();
					}
				}
				, {
					iconCls: 'icon-write-order',
					text: '静配延迟',
					handler: function() {
						openDelayDialog();
					}
				}
				// , {
				// 	iconCls: 'icon-checkin',
				// 	text: '明细打包',
				// 	handler: function() {
				// 		drugDetailsAuditPack();
				// 	}
				// }
			]
		});

		//table toolbar 添加checkbox
		$("#detailDiv").find(".datagrid-toolbar").find("tr").append("<td><input id='detailPack' type='checkbox'></td>")
		$HUI.checkbox("#detailPack", {
			label: '打包标志'
		});

		//修改table高度
		$("#detailDiv").find(".panel").find(".datagrid-wrap").css("height", gridHeight + "px");

		//修改table head 样式
		/*$('.panel-title').each(function() {
			$(this).html('<p>' + $(this).html() + '</>')
		})*/
	}

	//获取当前查询的是不是已审
	function isAuditChecked(gridName) {
		var conditionString = currentRequestParam['summaryDrugGrid'].parameter8 || '';
		var conditionArray = conditionString.split('^');
		for (var i = 0; i < conditionArray.length; i++) {
			var conditionItemArray = conditionArray[i].split('|');
			// 已审
			if ((conditionItemArray[0] == 'Audittyp')) {
				if (conditionItemArray[1] == 'true') {
					return true;
				}
			}
		}
		return false;
	}
	//获取当前查询的是不是已发药
	function isTypChecked(gridName) {
		var conditionString = currentRequestParam['summaryDrugGrid'].parameter8 || '';
		var conditionArray = conditionString.split('^');
		for (var i = 0; i < conditionArray.length; i++) {
			var conditionItemArray = conditionArray[i].split('|');
			// 已发 
			if ((conditionItemArray[0] == 'typ')) {
				if (conditionItemArray[1] == 'true') {
					return true;
				}
			}
		}
		return false;
	}

	function handleRetInfo(ret) {
		var success = '操作成功!';
		var fail = '操作失败!';
		var alertType="info";
		var retInfo = ret.split('^');
		retInfo[0] = retInfo[0].replace(/\r\n/g, '');
		if (!retInfo[1]) {
			if (retInfo[0] == '0') {
				retInfo[1] = success;
				alertType="success";
			}
		}
		var msgInfo = retInfo[1] ? retInfo[1] : fail;
		if (isNaN(retInfo[0])) {
			msgInfo = '执行操作过程中发生了以下错误：\n' + ret;
		}		
		msgInfo = msgInfo.replace(String.fromCharCode(129),"");
		$.messager.alert('提示', msgInfo, alertType);
		return (retInfo[0] == '0');
	}
	//药品汇总审核
	function drugSummaryAudit() {
		if (!checkPatsDisChargeStatus()) return;
		if (isAuditChecked() == true) {
			$.messager.alert("提示", "已审核药品不能审核!", 'info');
			return;
		}
		if (isTypChecked() == true) {
			$.messager.alert("提示", "已发药药品不能审核!", 'info');
			return;
		}
		var counter = '';
		var arcimDRString = '';
		var recLocString = '';
		var typGet="";  //zhangxiangbo
		var rowsData = $('#summaryDrugGrid').datagrid('getSelections')
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var arcimDR = rowData['ArRow'];
			var locID = rowData['recLocId'];
			counter = rowData['Process'];
			arcimDRString += (arcimDRString == '') ? arcimDR : '^' + arcimDR;
			recLocString += (recLocString == '') ? locID : '^' + locID;
		}
		if (counter === '') {
			$.messager.alert("提示", "请选择需要审核的数据!", 'info');
			return;
		}
		//2022.6.16判断审核的数据是否存在未处理医嘱
		var UnHandleDrugInfo=tkMakeServerCall("Nur.IP.DrugAudit","getUnHandleDrugInfo",session['LOGON.USERID'], session['LOGON.CTLOCID'],counter, arcimDRString, recLocString,"");
		if (UnHandleDrugInfo!=""){
			$.messager.confirm('确认',UnHandleDrugInfo+" "+$g('医嘱未处理,是否领药审核')+"?",function(r){    
			    if (r){    
			    	drugAudit();
			    }    
			});
		}else{
			drugAudit();
		}
		function drugAudit(){
			var packFlag = $HUI.checkbox('#summaryPack').getValue() ? 'Y' : '';
		
			var strRet=tkMakeServerCall("Nur.IP.DrugAudit","GetArcStrOrderByTyp",session['LOGON.USERID'], counter, arcimDRString, recLocString);   //zhangxiangbo
			if (strRet.indexOf('100')>-1){
				typGet=100;
			}
			var ret="";
			if(typGet===100)   //zhangxiangbo
			{
				$("#drugTypDlg").dialog('open');
				$('#takeMedicineBtn').unbind('click');
				$('#takeMedicineBtn').bind('click', function(){
					ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugSummaryAudit', session['LOGON.USERID'], counter, arcimDRString, recLocString, packFlag,session['LOGON.CTLOCID'],1);
					if (handleRetInfo(ret)) {
						initSummayData();
						//$('#detailDrugGrid').datagrid('clearSelections');
						$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
						//$HUI.datagrid('#detailDrugGrid').reload();
						// 刷新病人列表未领药审核标识
						if (parent && typeof parent.getPatAdditionalInfo === "function") {
							parent.getPatAdditionalInfo();
						}
					}
					$("#drugTypDlg").dialog('close');
				});
				$('#giveMedicineBtn').unbind('click');
				$('#giveMedicineBtn').bind('click', function(){
					ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugSummaryAudit', session['LOGON.USERID'], counter, arcimDRString, recLocString, packFlag,session['LOGON.CTLOCID'],2);
					if (handleRetInfo(ret)) {
						initSummayData();
						$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
						//$('#detailDrugGrid').datagrid('clearSelections');
						//$HUI.datagrid('#detailDrugGrid').reload();
						// 刷新病人列表未领药审核标识
						if (parent && typeof parent.getPatAdditionalInfo === "function") {
							parent.getPatAdditionalInfo();
						}
					}
					$("#drugTypDlg").dialog('close');
				});			
			}else
			{
				ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugSummaryAudit', session['LOGON.USERID'], counter, arcimDRString, recLocString, packFlag,session['LOGON.CTLOCID'],"");
				if (handleRetInfo(ret)) {
					initSummayData();
					$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
					//$('#detailDrugGrid').datagrid('clearSelections');
					//$HUI.datagrid('#detailDrugGrid').reload();
					// 刷新病人列表未领药审核标识
					if (parent && typeof parent.getPatAdditionalInfo === "function") {
						parent.getPatAdditionalInfo();
					}
				}
			}
		}
	}
	//药品汇总撤销
	function drugSummaryAuditCancel() {
		if (isAuditChecked() == false) {
			$.messager.alert("提示", "请查询已审核的药品!", 'info');
			return;
		}
		var counter = '';
		var arcimDRString = '';
		var recLocString = '';
		var rowsData = $('#summaryDrugGrid').datagrid('getSelections')
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var arcimDR = rowData['ArRow'];
			var locID = rowData['recLocId'];
			counter = rowData['Process'];
			arcimDRString += (arcimDRString == '') ? arcimDR : '^' + arcimDR;
			recLocString += (recLocString == '') ? locID : '^' + locID;
		}
		if (counter === '') {
			$.messager.alert("提示", "请选择需要撤销审核的数据!", 'info');
			return;
		}
		var ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugSummaryAuditCancel', session['LOGON.USERID'], counter, arcimDRString, recLocString,"",session['LOGON.CTLOCID']);
		if (handleRetInfo(ret)) {
			initSummayData();
			$('#detailDrugGrid').datagrid('clearSelections');
			//$HUI.datagrid('#detailDrugGrid').reload();
			$('#detailDrugGrid').datagrid('loadData', { total: 0, rows: [] });
			// 刷新病人列表未领药审核标识
			if (parent && typeof parent.getPatAdditionalInfo === "function") {
				parent.getPatAdditionalInfo();
			}
		}
	}

	//药品明细审核
	function drugDetailsAudit() {
		if (!currentRequestParam['detailDrugGrid']) {
			return;
		}
		if (!checkPatsDisChargeStatus()) return;
		var dhcDspIDString = '';
		var dhcDspID = '';
		var auditInfo = '';
		var typGet="";  //zhangxiangbo
		var rowsData = $('#detailDrugGrid').datagrid('getSelections')
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			dhcDspID = rowData['dhcDspId'];
			auditInfo = rowData['Audit'];
			if (auditInfo == "") {
				dhcDspIDString += (dhcDspIDString == '') ? dhcDspID : '^' + dhcDspID;
			}
		}
		if (dhcDspIDString === '') {
			$.messager.alert("提示", "请选择未审核的数据!", 'info');
			return;
		}
		if (isTypChecked() == true) {
			$.messager.alert("提示", "已发药药品不能审核!", 'info');
			return;
		}
		//2022.6.16判断审核的数据是否存在未处理医嘱
		var UnHandleDrugInfo=tkMakeServerCall("Nur.IP.DrugAudit","getUnHandleDrugInfo",session['LOGON.USERID'], session['LOGON.CTLOCID'],currentRequestParam['detailDrugGrid'].parameter2, "", "",dhcDspIDString);
		if (UnHandleDrugInfo!=""){
			$.messager.confirm('确认',UnHandleDrugInfo+$g('医嘱未处理,是否领药审核')+'?',function(r){    
				if (r){    
					drugAudit();
				}    
			});
		}else{
			drugAudit();
		}
		function drugAudit(){
			var packFlag = $HUI.checkbox('#detailPack').getValue() ? 'Y' : '';
			var strRet=tkMakeServerCall("Nur.IP.DrugAudit","GetFetchTyp",dhcDspIDString);   //zhangxiangbo
			if (strRet.indexOf('100')>-1){
				typGet=100;
			}
			var ret="";
			if(typGet===100)  //zhangxiangbo
			{
				$("#drugTypDlg").dialog('open');
				$('#takeMedicineBtn').unbind('click');
				$('#takeMedicineBtn').bind('click', function(){
					ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugDetailsAudit', session['LOGON.USERID'], currentRequestParam['detailDrugGrid'].parameter2, dhcDspIDString, currentRequestParam['detailDrugGrid'].parameter3,currentRequestParam['detailDrugGrid'].parameter4,packFlag,session['LOGON.CTLOCID'],1);
					if (handleRetInfo(ret)) {
						//$HUI.datagrid('#detailDrugGrid').reload();
						initSummayData();
						// 刷新病人列表未领药审核标识
						if (parent && typeof parent.getPatAdditionalInfo === "function") {
							parent.getPatAdditionalInfo();
						}
					}
					$("#drugTypDlg").dialog('close');
				});
				$('#giveMedicineBtn').unbind('click');
				$('#giveMedicineBtn').bind('click', function(){
					ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugDetailsAudit', session['LOGON.USERID'], currentRequestParam['detailDrugGrid'].parameter2, dhcDspIDString, currentRequestParam['detailDrugGrid'].parameter3,currentRequestParam['detailDrugGrid'].parameter4,packFlag,session['LOGON.CTLOCID'],2);
					if (handleRetInfo(ret)) {
						//$HUI.datagrid('#detailDrugGrid').reload();
						initSummayData();
						// 刷新病人列表未领药审核标识
						if (parent && typeof parent.getPatAdditionalInfo === "function") {
							parent.getPatAdditionalInfo();
						}
					}	
					$("#drugTypDlg").dialog('close');
				});			
			}else
			{
				ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugDetailsAudit', session['LOGON.USERID'],
				currentRequestParam['detailDrugGrid'].parameter2,
				dhcDspIDString,
				currentRequestParam['detailDrugGrid'].parameter3,
				currentRequestParam['detailDrugGrid'].parameter4,
				packFlag,session['LOGON.CTLOCID'],"");
				if (handleRetInfo(ret)) {
					//$HUI.datagrid('#detailDrugGrid').reload();
					initSummayData();
					// 刷新病人列表未领药审核标识
					if (parent && typeof parent.getPatAdditionalInfo === "function") {
						parent.getPatAdditionalInfo();
					}
				}
			}  
		} 
	}

	//药品明细审核撤销
	function drugDetailsAuditCancel() {
		if (!currentRequestParam['detailDrugGrid']) {
			return;
		}
		var dhcDspIDString = '';
		var dhcDspID = '';
		var auditInfo = '';
		var rowsData = $('#detailDrugGrid').datagrid('getSelections')
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			dhcDspID = rowData['dhcDspId'];
			auditInfo = rowData['Audit'];
			if (auditInfo !== "") {
				dhcDspIDString += (dhcDspIDString == '') ? dhcDspID : '^' + dhcDspID;
			}
		}
		if (rowsData.length === 0) {
			$.messager.alert("提示", "请选择需要撤销审核的数据!", 'info');
			return;
		}
		if (dhcDspIDString === '') {
			$.messager.alert("提示", "未审核，无法撤销审核!", 'info');
			return;
		}
		
		var ret = tkMakeServerCall('Nur.IP.DrugAudit', 'drugDetailsAuditCancel', session['LOGON.USERID'],
			currentRequestParam['detailDrugGrid'].parameter2,
			dhcDspIDString,
			currentRequestParam['detailDrugGrid'].parameter3,
			currentRequestParam['detailDrugGrid'].parameter4,
			session['LOGON.CTLOCID']);
		if (handleRetInfo(ret)) {
			//$HUI.datagrid('#detailDrugGrid').reload();
			initSummayData();
			// 刷新病人列表未领药审核标识
			if (parent && typeof parent.getPatAdditionalInfo === "function") {
				parent.getPatAdditionalInfo();
			}
		}
	}
 
	/**
	 *@description 打印按钮
	 */
	 function printBtnClick(){
		//var titleInfo=$('title').text().trim().split(" ");	
		var dateTime=getServerTime("",dtformat=='DMY'?4:3);	
		var headStr="<thead><th>药房</th><th>药品</th><th>数量</th><th>单位</th></thead>";
		var footStr="<tfoot style='border: none;'><td></td><td></td><td colspan='2'>打印时间:"+dateTime.date+" "+dateTime.time+"</td></tfoot>";
		var rows=$('#summaryDrugGrid').datagrid('getSelections');
		if(rows.length>0){
			var rowStr="<tbody>";
			rows.forEach(function(row){
				rowStr=rowStr+'<tr>'+'<td>'+row.LocDes+'</td>'+'<td>'+row.Arcim+'</td>'+'<td>'+row.Qty+'</td>'+'<td>'+row.Uom+'</td>'+'</tr>';
			});
			rowStr=rowStr+"</tbody>";
			var strHTML = '<table style="border: 1px solid black; border-image: none; border-collapse: collapse;" border="1">'+headStr+rowStr+footStr+"</table>";
			var LODOP=getLodop();
			LODOP.PRINT_INITA("0.53mm", "0mm", "211.67mm", "158.75mm", "领药单");
			LODOP.ADD_PRINT_TEXT(12,218,113,42,"领药单");
			LODOP.SET_PRINT_STYLEA(0,"FontSize",19);
			LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
			LODOP.SET_PRINT_STYLEA(0,"Bold",1);
			LODOP.ADD_PRINT_TEXT(55,77,153,22,"病区:"+session['LOGON.CTLOCDESC']); //titleInfo[3]
			LODOP.ADD_PRINT_TEXT(55,270,123,22,"打印人:"+session['LOGON.USERNAME']); //titleInfo[0]
			//LODOP.ADD_PRINT_TEXT(55,300,173,22,);
			LODOP.ADD_PRINT_TABLE("20mm","20mm","180mm","260mm",strHTML);
			LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
			//LODOP.PRINT_DESIGN();
			//LODOP.PREVIEW();
			LODOP.PRINT();
		}
		else{
			$.messager.popover({msg: '请选择要打印的数据！',type:'alert'});
		}
	}
	function messageBtnClick(){ // EH
		var ret = tkMakeServerCall('PHA.FACE.OUT.Method', 'NotifyPhaDraw', session['LOGON.WARDID'], session['LOGON.USERID']);
		if (ret == '0') {
			$.messager.alert("提示", "消息发送成功!", 'info');
		} else {
			$.messager.alert("提示", "消息发送失败" + ret, 'info');
		}
	}
	
	// 静配延迟弹窗
	var dspRecLocId="";
	function openDelayDialog(){
		var selRows=$("#detailDrugGrid").datagrid("getSelections");
		if(selRows.length>0){
			if(selRows.length>1){
				return $.messager.popover({msg: '请选择一条数据进行延迟操作！',type:'alert'});
			}		
					
			// 获取配液批次
			var batchInfo=tkMakeServerCall('PHA.FACE.OUT.Com', 'GetPivasBatNo', dspRecLocId);
			var orderInfo=$.cm({
				ClassName:'Nur.IP.DrugAudit', 
				MethodName:'GetOrderGroupDesc', 
				order:selRows[0].Orw
			},false);
			var batchArr=[];
			if($.trim(batchInfo)==""){
				return $.messager.popover({msg: '选择的药品无批次信息！',type:'alert'});
			}else{	
				$('#saveDelayInfo').unbind('click');
				$('#saveDelayInfo').bind('click',function(){
					saveDelayInfo();	
				})			
				batchArr=batchInfo.split("$$");	
				$("#batchList").html("");	
				batchArr.forEach(function(val,index){
					var value=$.trim(val.split("(")[0]);
					var checkbox='<li style="width:160px;float:left;"><input class="hisui-radio" type="radio" id="batch'+value+'" name="batch" value="'+value+'" label="'+val+'" /></li>';
					$("#batchList").append(checkbox);
					$HUI.radio("#batchList input#batch"+value,{});
				})
				$("#excDTime").html(selRows[0].OrdDate);
				var order="";
				orderInfo.forEach(function(val){
					order+='<p style="line-height:22px;padding-left:12px;">'+val+'</p>'						
				})	
				if(order!=""){
					order+='<span style="display:inline-block;position:absolute;top:9px;left:0;bottom:9px;width:6px;border:2px solid #ccc;border-right:0;"></span>';
				}
				$("#arcName").html(order);
				$HUI.dialog('#drugDelayDlg').center();
				$HUI.dialog('#drugDelayDlg').open();
			}			
			
		}else{
			return $.messager.popover({msg: '请选择一条要延迟的药品',type:'alert'});
		}		
	}
	
	// 保存配置延迟信息
	function saveDelayInfo(){
		var selRows=$("#detailDrugGrid").datagrid("getSelections");
		var BatNo=$("input[name=batch]:checked").val();
		if(!BatNo) return $.messager.popover({msg: '请选择配液批次！',type:'alert'});
		var ret=tkMakeServerCall('PHA.FACE.OUT.Com', 'SaveNursePIVABat', selRows[0].dhcDspId,BatNo,session['LOGON.USERID']);
		$HUI.dialog('#drugDelayDlg').close();
		if(ret=='0'){
			return $.messager.popover({msg: '配液延迟成功',type:'success'});	
		}else{
			if(ret.indexOf("^")>-1){
				var msg=ret.split("^")[1];
				return $.messager.popover({msg: msg,type:'success'});		
			}	
		}	
	}

	initUI();

function patientTreeLoadSuccessCallBack(){
	if (!currentRequestParam['summaryDrugGrid']) {
		initGrid();
	}else{
		initSummayData();
		currentRequestParam['detailDrugGrid']={};
		$("#detailDrugGrid").datagrid("loadData", { total: 0, rows: [] });
	}
}
function checkPatsDisChargeStatus(){
	if (EpisodeIDStr=="") return true;
	var ret=$.m({
		ClassName:'Nur.IP.DrugAudit', 
		MethodName:'checkPatsDischargeStatus', 
		episodeIDs:EpisodeIDStr
	},false);
	if (ret!="") {
		$.messager.popover({msg: ret,type:'alert'});
		return false;
	}
	return true;
}
function resetDateTimeRange(pharmacyDr){
	var FYTimeSetString=tkMakeServerCall("web.DrugAuditNew","GetFYTimeSet",session["LOGON.CTLOCID"],pharmacyDr);
	if (FYTimeSetString!=""){
		$('#startDate').datebox('setValue', dateCalculate(new Date(), parseInt(FYTimeSetString.split("^")[0]), 10));
		$('#endDate').datebox('setValue', dateCalculate(new Date(), parseInt(FYTimeSetString.split("^")[1]), 10));
		$('#startTime').timespinner('setValue', FYTimeSetString.split("^")[2]);
		$('#endTime').timespinner('setValue', FYTimeSetString.split("^")[3]);
	}else{
		$('#startDate').datebox('setValue', dateCalculate(new Date(), parseInt(periodString.split("^")[0]), 10));
		$('#endDate').datebox('setValue', dateCalculate(new Date(), parseInt(periodString.split("^")[1]), 10));
		$('#startTime').timespinner('setValue', periodString.split("^")[2]);
		$('#endTime').timespinner('setValue', periodString.split("^")[3]);
	}
}