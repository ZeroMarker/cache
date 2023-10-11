//全局
var FSSubmitRemarks = FSSubmitRemarks || {
	RemarksSelectID: ''
};

(function (win) {
	$(function () {
		window.returnValue = '';
		setRemarksTextBox();
		
		$('#btnFinish').on('click',function() {
			var remarks = encodeText($('#taRemarks').val());
			var selectedItems = '';
			var scanOptions = $('input[name="options"]:checked').val();
			if (scanOptions == '1') {
				var rows = $('#paperItemsTable').datagrid('getSelections');
				if (rows.length == 0) {
					$.messager.popover({
						msg: '需扫描但未选中扫描项！',
						type: 'info',
						timeout: 2000
					});
					return;
				}
				var flag = '0', flagNaN = '0';
				for (var i=0;i<rows.length;i++) {
					var itemID = rows[i].ItemID;
					var itemIndex = $('#paperItemsTable').datagrid('getRowIndex',rows[i]);
					var pages = $('#td' + itemIndex).val();
					if (selectedItems == '') {
						selectedItems = itemID + '||' + pages;
					}
					else {
						selectedItems = selectedItems + '^' + itemID + '||' + pages;
					}
					if (pages == '') {
						flag = '1';
					}
					else if(isNaN(pages)) {
						flagNaN = '1';
					}
				}
				if (flag == '1') {
					$.messager.popover({
						msg: '存在扫描页数为空的选中项，请重新检查！',
						type: 'info',
						timeout: 2000
					});
					return;
				}
				else if(flagNaN == '1') {
					$.messager.popover({
						msg: '扫描页数必须输入半角数字格式，请重新检查！',
						type: 'info',
						timeout: 2000
					});
					return;
				}
			}
			var info = '';
			if ((remarks != '')||(selectedItems != '')) {
				info = remarks + '@' + selectedItems;
			}
			window.returnValue = info;
			window.close();
		});
		
		$HUI.combobox('#cbbRemarks',{
			valueField: 'RemarksID',
			textField: 'RemarksDesc',
			url: $URL + '?ClassName=DHCEPRFS.BL.BLAdmMRStatus&QueryName=LoadSubmitRemarks&ResultSetType=array&AUserID=' + userID,
			method: 'post',
			onSelect: function(rec) {
				var remarks = decodeText(rec["Remarks"]);
				$('#taRemarks').val(remarks);
				FSSubmitRemarks.RemarksSelectID = rec["RemarksID"];
			}
		});
		
		$HUI.datagrid('#paperItemsTable',{
			title: '请选择需扫描项目并填写页数',
			iconCls: 'icon-w-edit',
			width: 400,
			height: 280,
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRFS.BL.BLAdmMRStatus',
				QueryName: 'GetPaperItems',
				AEpisodeID: episodeID
			},
			method: 'post',
			rownumbers: true,
			singleSelect: false,
			selectOnCheck: true,
			checkOnSelect: false,
			columns: [[
				{field:'ItemID',title:'ID',width:25,hidden:true},
				{field:'ItemDesc',title:'项目描述',width:240},
				{field:'IsChecked',title:'IsChecked',width:25,hidden:true},
				{field:'ItemPages',title:'ItemPages',width:60,hidden:true},
				{field:'PagesTextBox',title:'扫描页数',width:72,formatter:textBoxFormatter},
				{field:'ck',checkbox:true}
			]],
			onLoadSuccess:function(data) {
				if (data) {
					$.each(data.rows,function(index,item) {
						if (item.IsChecked == '1') {
							$('#paperItemsTable').datagrid('checkRow',index);
						}
					});
				}
			},
			onClickRow:function(index,row) {
				if ($('input[type="checkbox"]')[index + 1].checked) {
					$('#paperItemsTable').datagrid('selectRow',index);
				}
				else {
					$('#paperItemsTable').datagrid('unselectRow',index);
				}
			}
		});
		
		$('#btnAddRemarks').on('click',function() {
			var inputText = $('#cbbRemarks').combobox('getText');
			inputText = inputText.replace(/^\s*|\s*$/g,'');  //去除两端空格
			if (inputText === '') {
				return;
			}
			var remarks = encodeText($('#taRemarks').val());
			$.m({
				ClassName: 'DHCEPRFS.BL.BLAdmMRStatus',
				MethodName: 'AddSubmitRemarks',
				AUserID: userID,
				ARemarksDesc: inputText,
				ARemarks: remarks
			},function(txtData) {
				if (txtData == '1') {
					$.messager.popover({
						msg: '操作成功！',
						type: 'success',
						timeout: 2000
					});
					FSSubmitRemarks.RemarksSelectID = '';
					$('#cbbRemarks').combobox('reload');
				}
				else {
					$.messager.popover({
						msg: '操作失败！',
						type: 'error',
						timeout: 2000
					});
					return;
				}
			});
		});
		
		$('#btnRemoveRemarks').on('click',function() {
			if (FSSubmitRemarks.RemarksSelectID == '') {
				return;
			}
			$.m({
				ClassName: 'DHCEPRFS.BL.BLAdmMRStatus',
				MethodName: 'RemoveSubmitRemarks',
				ARemarksID: FSSubmitRemarks.RemarksSelectID
			},function(txtData) {
				if (txtData == '1') {
					$.messager.popover({
						msg: '操作成功！',
						type: 'success',
						timeout: 2000
					});
					FSSubmitRemarks.RemarksSelectID = '';
					$('#cbbRemarks').combobox('reload');
				}
				else {
					$.messager.popover({
						msg: '操作失败！',
						type: 'error',
						timeout: 2000
					});
					return;
				}
			});
		});
		
		$('#btnSaveRemarks').on('click',function() {
			if (FSSubmitRemarks.RemarksSelectID == '') {
				return;
			}
			var remarks = encodeText($('#taRemarks').val());
			$.m({
				ClassName: 'DHCEPRFS.BL.BLAdmMRStatus',
				MethodName: 'SaveSubmitRemarks',
				ARemarksID: FSSubmitRemarks.RemarksSelectID,
				ARemarks: remarks
			},function(txtData) {
				if (txtData == '1') {
					$.messager.popover({
						msg: '操作成功！',
						type: 'success',
						timeout: 2000
					});
					FSSubmitRemarks.RemarksSelectID = '';
					$('#cbbRemarks').combobox('reload');
				}
				else {
					$.messager.popover({
						msg: '操作失败！',
						type: 'error',
						timeout: 2000
					});
					return;
				}
			});
		});
		
		$HUI.radio('#rbNeed2Scan',{
			checked: true,
			onChecked: function(e,value) {
				$('input[type="checkbox"]')[0].disabled = false;
				var rows = $('#paperItemsTable').datagrid('getRows');
				for(var i=0;i<rows.length;i++) {
					$('#td' + i)[0].disabled = false;
					$('input[type="checkbox"]')[i + 1].disabled = false;
				}
			}
		});
		
		$HUI.radio('#rbNoNeed2Scan',{
			onChecked:function(e,value) {
				$('#paperItemsTable').datagrid('uncheckAll');
				$('input[type="checkbox"]')[0].disabled = true;
				var rows = $('#paperItemsTable').datagrid('getRows');
				for(var i=0;i<rows.length;i++) {
					$('#td' + i)[0].disabled = true;
					$('input[type="checkbox"]')[i + 1].disabled = true;
				}
			}
		});
		
		function setRemarksTextBox() {
			$.m({
				ClassName: 'DHCEPRFS.BL.BLAdmMRStatus',
				MethodName: 'GetLastSubmitRemarks',
				AEpisodeID: episodeID,
			},function(txtData) {
				var lastRemarks = decodeText(txtData);
				$('#taRemarks').val(lastRemarks);
			});
		}
		
		function textBoxFormatter(value,row,index) {
			var textBoxID = 'td' + index;
			var pages = row.ItemPages;
			return '<input id="' + textBoxID + '" type="text" class="textbox" value="' + pages + '" style="width:50px;"/>';
		}
		
		function encodeText(str) {
			var result = str.replace(/\n/g,'<br />');
			return result;
		}
		
		function decodeText(str) {
			var result = str.replace(/<br \/>/g,'\n');
			return result;
		}
	});
}(window));