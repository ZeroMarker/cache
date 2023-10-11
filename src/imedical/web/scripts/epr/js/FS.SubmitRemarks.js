//全局
var FSSubmitRemarks = FSSubmitRemarks || {
	RemarksSelectID: ""
};

//配置和静态
FSSubmitRemarks.Config = FSSubmitRemarks.Config || {
	ERROR_INFO: "错误",
	ERROR_INFO_OPERATION: "操作失败"
};

(function (win) {
	$(function () {
		setRemarksTextBox();
		
		$('#finishBtn').on('click', function () {
			var remarks = encodeText($('#inputRemarks').val());
			var selectedItems = ""
			var scanOptions = $("input[name='options']:checked").val();
			if (scanOptions == "1") {
				var rows = $('#paperItemsTable').datagrid('getSelections');
				if (rows.length == 0) {
					alert('需扫描但未选中扫描项!');
					return;
				}
				var flag = "0";
				var flagNaN = "0";
				for (var i=0;i<rows.length;i++) {
					var itemID = rows[i].ItemID;
					var itemIndex = $('#paperItemsTable').datagrid('getRowIndex',rows[i]);
					var pages = $('#td'+itemIndex).val();
					if (selectedItems == "") {
						selectedItems = itemID + "||" + pages;
					}
					else {
						selectedItems = selectedItems + "^" + itemID + "||" + pages;
					}
					if (pages == "") {
						flag = "1";
					}
					else if(isNaN(pages)) {
						flagNaN = "1";
					}
				}
				if (flag == "1") {
					alert('存在扫描页数为空的选中项，请重新检查!');
					return;
				}
				else if(flagNaN == "1") {
					alert('扫描页数必须输入半角数字格式，请重新检查!');
					return;
				}
			}
			var info = "";
			if ((remarks != "")||(selectedItems != "")) {
				info = remarks + '@' + selectedItems;
			}
			window.returnValue = info;
			window.close();
		});
		
		$('#inputRemarksSelect').combobox({
			valueField: 'RemarksID',
			textField: 'RemarksDesc',
			url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=loadremarks&UserID=" + userID,
			method: 'post',
			onSelect: function (rec) {
				var remarks = decodeText(rec["Remarks"]);
				$('#inputRemarks').val(remarks);
				FSSubmitRemarks.RemarksSelectID = rec["RemarksID"];
			}
		});
		
		$('#paperItemsTable').datagrid({
			url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?",
			queryParams: {
				ActionType: 'getpaperitems',
				EpisodeID: episodeID
			},
			width: 360,
			height: 254,
			title: '请选择需扫描项目并填写页数',
			method: 'post',
			loadMsg: '数据装载中......',
			rownumbers: true,
			showHeader: true,
			singleSelect: false,
			selectOnCheck: true,
			checkOnSelect: false,
			columns: [[
				{ field: 'ItemID', title: 'ID', width: 25, sortable: true, hidden: true},
				{ field: 'ItemCode', title: '项目编码', width: 80, sortable: true, hidden: true},
				{ field: 'ItemName', title: '项目名称', width: 210, sortable: true},
				{ field: 'ItemDesc', title: '项目描述', width: 100, sortable: true, hidden: true},
				{ field: 'IsChecked', title: 'IsChecked', width: 25, sortable: true, hidden: true},
				{ field: 'ItemPages', title: 'ItemPages', width: 60, sortable: true, hidden: true},
				{ field: 'PagesTextBox', title: '扫描页数', width: 60, sortable: true, formatter: textBoxFormatter},
				{ field: 'ck', checkbox: true }
			]],
			onLoadSuccess:function(data){
				if(data){
					$.each(data.rows, function(index, item){
						if(item.IsChecked == "1"){
							$('#paperItemsTable').datagrid('checkRow', index);
						}
					});
				}
			},
			onClickRow:function(index,row) {
				if ($("input[type='checkbox']")[index + 1].checked) {
					$('#paperItemsTable').datagrid('selectRow', index);
				}
				else {
					$('#paperItemsTable').datagrid('unselectRow', index);
				}
			}
		});
		
		$('#addRemarksBtn').on('click', function () {
			var inputText = $('#inputRemarksSelect').combobox('getText');
			inputText = inputText.replace(/^\s*|\s*$/g,'');  //去除两端空格
			if (inputText === "") {
				return;
			}
			var remarks = encodeText($('#inputRemarks').val());
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=addremarks&UserID=" + userID + "&Remarks=" + encodeURI(remarks) + "&RemarksDesc=" + encodeURI(inputText),
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === "1") {
				FSSubmitRemarks.RemarksSelectID = "";
				$('#inputRemarksSelect').combobox('reload');
			}
			else {
				alert(FSSubmitRemarks.Config.ERROR_INFO_OPERATION);
			}
		});
		
		$('#removeRemarksBtn').on('click', function () {
			if (FSSubmitRemarks.RemarksSelectID == "") {
				return;
			}
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=removeremarks&RemarksID=" + FSSubmitRemarks.RemarksSelectID,
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === "1") {
				FSSubmitRemarks.RemarksSelectID = "";
				$('#inputRemarksSelect').combobox('reload');
			}
			else {
				alert(FSSubmitRemarks.Config.ERROR_INFO_OPERATION);
			}
		});
		
		$('#saveRemarksBtn').on('click', function () {
			if (FSSubmitRemarks.RemarksSelectID == "") {
				return;
			}
			var remarks = encodeText($('#inputRemarks').val());
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=saveremarks&RemarksID=" + FSSubmitRemarks.RemarksSelectID + "&Remarks=" + encodeURI(remarks),
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === "1") {
				FSSubmitRemarks.RemarksSelectID = "";
				$('#inputRemarksSelect').combobox('reload');
			}
			else {
				alert(FSSubmitRemarks.Config.ERROR_INFO_OPERATION);
			}
		});
		
		$('#need2Scan').on('click', function () {
			$("input[type='checkbox']")[0].disabled = false;
			var rows = $('#paperItemsTable').datagrid('getRows');
			for(var i=0;i<rows.length;i++) {
				$('#td' + i)[0].disabled = false;
				$("input[type='checkbox']")[i + 1].disabled = false;
			}
		});
		
		$('#noNeed2Scan').on('click', function () {
			$('#paperItemsTable').datagrid('uncheckAll');
			$("input[type='checkbox']")[0].disabled = true;
			var rows = $('#paperItemsTable').datagrid('getRows');
			for(var i=0;i<rows.length;i++) {
				$('#td' + i)[0].disabled = true;
				$("input[type='checkbox']")[i + 1].disabled = true;
			}
		});
		
		function setRemarksTextBox() {
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=lastremarks&EpisodeID=" + episodeID,
				type: 'post',
				async: false
			});
			var lastRemarks = decodeText(obj.responseText);
			$('#inputRemarks').val(lastRemarks);
		}
		
		function textBoxFormatter(value, row, index) {
			var textBoxID = 'td' + index;
			var pages = row.ItemPages
			return '<input id="'+textBoxID+'" type="text" value="' + pages + '" style="width:50px;height:20px;"/>';
		}
		
		function encodeText(str) {
			var result = str.replace(/\n/g,"<br />");
			return result;
		}
		
		function decodeText(str) {
			var result = str.replace(/<br \/>/g,"\n");
			return result;
		}
	});
}(window));