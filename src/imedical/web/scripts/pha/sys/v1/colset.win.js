/*
 * @creator:     Huxt 2020-05-06
 * @description: ����Ϣά������
 * @others:      ��
 * @csp:         pha.sys.v1.colset.win.csp
 * @js:          pha/sys/v1/colset.win.js
 */
var COLSET_WIN = {
	curEditRowIndex: null,
	InitOptions: {},
	/**
	 * ����Ϣά������
	 * COLSET_WIN.Open();
	 *  _options.queryParams: {Object} ��ѯ����
	 *  _options.serverOpts: {Object} ��̨�Ѵ��ڵ�����Ϣ
	 *  _options.showGridInfo: {Blooean} ��ʾwest/��ಿ�ֱ����Ϣ
	 *  _options.hideWest: {Blooean} ����west/��ಿ�ֱ����Ϣ,����jqGrid����
	 *  _options.onClickSave: {Function} ����ʱ�ص�����
	 *  _options.onClickDelete: {Function} ɾ��ʱ�ص�����
	 *  _options.colValBtnMsg: {String} �����ȡֵ���ʽ����ťʱ��ʾ����
	 *  _options.onClose: {Function} �ر�����Ϣά������ʱ�ص�,����jqGrid����
	 *  _options.onOpen: {Function} ������Ϣά������ʱ�ص�,����jqGrid����
	 *  _options.checkWidth: {Blooean} �Ƿ���֤�ⲿ���õĿ�ȴ��ڵ�ǰ��ҳ����,jqGrid���治����֤
	 *  _options.width: {Number} ���ڿ��
	 *  _options.xxx: ������������
     * @returns
	 */
	Open: function (_options) {
		if (typeof PHA_GridEditor == 'object') {
			PHA_GridEditor.AutoUpd = true;
		}
		this.InitOptions = _options;
		if ($('#dialogColSet-Container').length == 0) {
			$.ajax({
				url: "pha.sys.v1.colset.win.csp",
				success: function (_htmlText) {
					$('body').append(_htmlText);
					$.parser.parse($("#dialogColSet-Container"));
					// �Ƿ���ʾ���
					var winWidth = 1150;
					var winTitle = "����Ϣά��";
					if (COLSET_WIN.InitOptions.showGridInfo) {
						winWidth += 200;
						winTitle = "�����Ϣά��";
						COLSET_WIN.AddGridInfo();
					}
					// �򿪴���
					var _dialogOpts = {
						title: winTitle,
						collapsible: false,
						minimizable: false,
						iconCls: "icon-w-setting",
						border: false,
						closed: true,
						modal: true,
						width: winWidth,
						height: 580,
						onOpen: function(){
							COLSET_WIN.InitOptions.onOpen && COLSET_WIN.InitOptions.onOpen();
						},
						onClose: function(){
							COLSET_WIN.InitOptions.onClose && COLSET_WIN.InitOptions.onClose();
						}
					};
					if (COLSET_WIN.InitOptions.showGridInfo) {
						$('#btnSaveGirdCol').hide(); // ����ԭ���ı��水ť
						_dialogOpts.buttons = [{
							text:'����',
							handler:function(){
								COLSET_WIN.Save({
									gridID: 'gridDialogColSet'
								});
							}
						},{
							text:'�ر�',
							handler:function(){
								$('#dialogColSet').dialog('close');
							}
						}]
					}
					var winOpts = $.extend({}, _dialogOpts, COLSET_WIN.InitOptions);
					if (COLSET_WIN.InitOptions.checkWidth != false) {
						if (winOpts.width > $(window).width() - 10) {
							winOpts.width = $(window).width() - 10;
						}
					}
					$('#dialogColSet').dialog(winOpts);
					$('#dialogColSet').dialog('open');
					
					COLSET_WIN.InitGridBar();
					COLSET_WIN.InitGrid();
					COLSET_WIN.InitEvent();
				}
			});
		} else {
			$('#dialogColSet').dialog('open');
			this.Query();
			this.QueryGridInfo();
		}
	},
	InitGridBar: function(){
		var $chkIncludeAll = $('#chkIncludeAll').next();
		if(!$chkIncludeAll.is('label')) {
			$chkIncludeAll = $('label[for="chkIncludeAll"]');
		}
		$chkIncludeAll.attr('title', '�����ѡ���ѯQuery����û����ʾ������Ϣ');
		$chkIncludeAll.tooltip({
			position: 'right'
		});
		if (this.InitOptions.showColValBtn === true) {
			$('#btnSetColVal').show();
		} else {
			$('#btnSetColVal').hide();
		}
	},
	InitGrid: function () {
		var _queryParams = this.InitOptions.queryParams;
		var includeAllFlag = $('#chkIncludeAll').checkbox('getValue') == true ? 'Y' : 'N';
		_queryParams.includeAllFlag = includeAllFlag;
		_queryParams.page = 1;
		_queryParams.rows = 9999;
		var _sysFlag = 'Y';
		var dataGridOption = {
			url: $URL,
			queryParams: _queryParams,
			pagination: false,
			columns: this.GetColumns(_sysFlag),
			fitColumns: true,
			fit: true,
			border: false,
			singleSelect: true,
			toolbar: '#gridDialogColSetBar',
			enableDnd: false,
			rownumbers: true,
			onDblClickHeader: function () {},
			onHeaderContextMenu: function () {},
			onRowContextMenu: function () {},
			onSelect: function (rowIndex, rowData) {
				$(this).datagrid('options').selectedRowIndex = rowIndex;
			},
			onClickCell: function (index, field, value) {
				$(this).datagrid('options').selectedRowIndex = index;
				if (_sysFlag != "Y" && field == "ColField") {
					return;
				}
				COLSET_WIN.StartEditCell({
					gridID: 'gridDialogColSet',
					index: index,
					field: field
				});
			},
			onLoadSuccess: function(data){
				if (data && data.total > 0) {
					var selectedRowIndex = $(this).datagrid('options').selectedRowIndex;
					if (selectedRowIndex >= 0 && data.total > selectedRowIndex) {
						$(this).datagrid('selectRow', selectedRowIndex);
					} else {
						$(this).datagrid('selectRow', 0);
					}
				}
				$('#btnUpGirdCol').prop('disabled', '');
				$('#btnDownGirdCol').prop('disabled', '');
			},
			gridSave: false // �������̨
		}
		PHA.Grid("gridDialogColSet", dataGridOption); // $("#gridDialogColSet").datagrid(dataGridOption);
		if (COLSET_WIN.InitOptions.serverOpts) {
			var mSaveType = COLSET_WIN.InitOptions.serverOpts.mSaveType || "";
			COLSET_WIN.SetSaveType && COLSET_WIN.SetSaveType(mSaveType);
		}
	},
	// �󶨰�ť�¼�
	InitEvent: function () {
		$('#btnAddGirdCol').on('click', function () {
			COLSET_WIN.Add({
				gridID: 'gridDialogColSet'
			});
		});
		$('#btnSaveGirdCol').on('click', function () {
			COLSET_WIN.Save({
				gridID: 'gridDialogColSet'
			});
		});
		$('#btnDelGirdCol').on('click', function () {
			COLSET_WIN.Delete({
				gridID: 'gridDialogColSet'
			});
		});
		$('#btnUpGirdCol').on('click', function () {
			var mRet = COLSET_WIN.UpAndDown({
				gridID: 'gridDialogColSet',
				ifUp: true
			});
			if (mRet) {
				$('#btnUpGirdCol').prop('disabled', 'disabled');
				$('#btnDownGirdCol').prop('disabled', 'disabled');
				COLSET_WIN.Save({
					gridID: 'gridDialogColSet'
				});
			}
		});
		$('#btnDownGirdCol').on('click', function () {
			var mRet = COLSET_WIN.UpAndDown({
				gridID: 'gridDialogColSet',
				ifUp: false
			});
			if (mRet) {
				$('#btnUpGirdCol').prop('disabled', 'disabled');
				$('#btnDownGirdCol').prop('disabled', 'disabled');
				COLSET_WIN.Save({
					gridID: 'gridDialogColSet'
				});
			}
		});
		$('#btnSetColVal').on('click', function () {
			COLSET_WIN.OpenColValWin();
		});
	},
	// ��ѯ����
	Query: function () {
		var _queryParams = COLSET_WIN.InitOptions.queryParams;
		var includeAllFlag = $('#chkIncludeAll').checkbox('getValue') == true ? 'Y' : 'N';
		_queryParams.includeAllFlag = includeAllFlag;
		_queryParams.page = 1;
		_queryParams.rows = 9999;
		$('#gridDialogColSet').datagrid('query', _queryParams);
		// ���±�������
		if (COLSET_WIN.InitOptions.serverOpts) {
			var mSaveType = COLSET_WIN.InitOptions.serverOpts.mSaveType || "";
			COLSET_WIN.SetSaveType && COLSET_WIN.SetSaveType(mSaveType);
		}
	},
	// ����
	Save: function (_opt) {
		var _gridID = _opt.gridID;
		$('#' + _gridID).datagrid('endEditing');
		// ��֤����
		var chkRetStr = PHA_GridEditor.CheckValues(_gridID);
		if (chkRetStr != "") {
			PHA.Popover({
				msg: chkRetStr,
				type: "alert"
			});
			return;
		}
		// ��֤�ظ�
		var chkRetStr = PHA_GridEditor.CheckDistinct({
			gridID: _gridID,
			fields: ['ColField']
		});
		if (chkRetStr != "") {
			PHA.Popover({
				msg: chkRetStr,
				type: "alert"
			});
			return;
		}
		// �ص�����
		var gridColsData = $("#" + _gridID).datagrid("getRows");
		if (gridColsData.length == 0) {
			PHA.Popover({
				msg: "û����Ҫ���������Ϣ��",
				type: "error",
				timeout: 1000
			});
			return;
		}
		var gridOptsData = {};
		var saveType = "";
		if (COLSET_WIN.InitOptions.showGridInfo == true) {
			gridOptsData = this.GetGridInfo();
			saveType = this.GetSaveType();
			// ��֤��������
			if (saveType == "") {
				PHA.Popover({
					msg: "��ѡ�񱣴����ͣ�",
					type: "alert"
				});
				return;
			}
			// ��֤�ж����Ƿ���Ч
			if (gridOptsData.fitColumns == 'Y') {
				for (var r = 0; r < gridColsData.length; r++) {
					if (gridColsData[r]['ColFrozen'] == 'Y') {
						PHA.Popover({
							msg: "��" + (r + 1) + "��, ��ѡ���Զ���䡱������Ϣ�С��ж��ᡱ��ѡ��Ч��",
							type: "alert",
							timeout: 2000
						});
						return;
					}
				}
			}
		}
		COLSET_WIN.InitOptions.onClickSave && COLSET_WIN.InitOptions.onClickSave(COLSET_WIN.InitOptions, gridColsData, gridOptsData, saveType);
	},
	// ɾ��
	Delete: function (_opt) {
		var _gridID = _opt.gridID;
		var selectedData = $("#" + _gridID).datagrid("getSelected") || "";
		if (selectedData == "") {
			PHA.Popover({
				msg: "��ѡ����Ҫɾ������!",
				type: "alert"
			});
			return;
		}
		var ColId = selectedData.ColId || "";
		PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ������?", function () {
			if (ColId == "") {
				var rowIndex = $("#" + _gridID).datagrid('getRowIndex', selectedData);
				$("#" + _gridID).datagrid('deleteRow', rowIndex);
				return;
			}
			COLSET_WIN.InitOptions.onClickDelete && COLSET_WIN.InitOptions.onClickDelete(COLSET_WIN.InitOptions, selectedData, ColId);
		});
	},
	// =====================
	// ���� - ��ʼ�༭
	StartEditCell: function (_options) {
		var gridID = _options.gridID;
		var index = _options.index;
		var field = _options.field;
		var isEndEidting = $("#" + gridID).datagrid("endEditing");
		if (!isEndEidting) {
			var colTitles = {};
			var mColumnsArr = $("#" + gridID).datagrid('options').columns;
			var mColumns = mColumnsArr[0];
			for (var i = 0; i < mColumns.length; i++) {
				var oneCol = mColumns[i];
				var mField = oneCol.field;
				var mTitle = oneCol.title;
				colTitles[mField] = mTitle;
			}
			PHA.Popover({
				msg: "��" + (COLSET_WIN.curEditCell.index + 1) + "��, " + colTitles[COLSET_WIN.curEditCell.field] + '����Ϊ��!',
				type: "alert"
			});
			setTimeout(function () {
				$("#" + gridID).datagrid('selectRow', COLSET_WIN.curEditCell.index);
			}, 100);
			return;
		}
		$("#" + gridID).datagrid('beginEditCell', {
			index: index,
			field: field
		});
		COLSET_WIN.curEditCell = {
			index: index,
			field: field
		};
		// �󶨻س���ת��һ��
		var ed = $("#" + gridID).datagrid('getEditor', {
			index: index,
			field: field
		});
		$(ed.target).focus().select();
		$(ed.target).on('keydown', function (e) {
			if (e.keyCode != 13) {
				return;
			}
			setTimeout(function () {
				var rowsData = $("#" + gridID).datagrid('getRows');
				if (rowsData.length <= index + 1) {
					if (field == 'ColField') {
						COLSET_WIN.StartEditCell({
							gridID: gridID,
							index: index,
							field: 'ColTitle'
						});
					}
					return;
				}
				var nextRowIndex = index + 1;
				COLSET_WIN.StartEditCell({
					gridID: gridID,
					index: nextRowIndex,
					field: field
				});
			}, 100);
		});
	},
	// ���� - ���
	Add: function (_opt) {
		var _gridID = _opt.gridID;
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "������ɱ����һ�б༭!",
				type: "alert"
			});
			return;
		}
		var inputStr = this.InitOptions.queryParams.inputStr || "";
		var inputArr = inputStr.split("^");
		var tableName = inputArr[0];
		var tablePointer = inputArr[1];
		var newRowData = {};
		var mColumnsArr = $("#" + _gridID).datagrid('options').columns;
		var mColumns = mColumnsArr[0];
		for (var i = 0; i < mColumns.length; i++) {
			var oneCol = mColumns[i];
			var mField = oneCol.field;
			if (mField == 'ColAlign') {
				newRowData[mField] = 'left';
			} else if (mField == 'ColSortable') {
				newRowData[mField] = 'Y';
			} else if (mField == 'ColTableName') {
				newRowData[mField] = tableName;
			} else if (mField == 'ColPointer') {
				newRowData[mField] = tablePointer;
			} else if (mField == 'ColIfExport') {
				newRowData[mField] = 'Y';
			} else if (mField == 'ColIfPrint') {
				newRowData[mField] = 'Y';
			} else if (mField == 'ColWidth') {
				newRowData[mField] = 100;
			} else {
				newRowData[mField] = '';
			}
		}
		$("#" + _gridID).datagrid("appendRow", newRowData);
		// ��ʼ�༭
		var rowsData = $("#" + _gridID).datagrid('getRows');
		COLSET_WIN.StartEditCell({
			gridID: _gridID,
			index: rowsData.length - 1,
			field: 'ColField'
		});
	},
	// ���� - �����ƶ�
	UpAndDown: function (_opt) {
		var _gridID = _opt.gridID;
		var _ifUp = _opt.ifUp;
		// ȡֵ
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "�б�����û������,�޷���ɱ��༭!",
				type: "alert"
			});
			return false;
		}
		var selectedData = $("#" + _gridID).datagrid("getSelected") || "";
		if (selectedData == "") {
			PHA.Popover({
				msg: "��ѡ����Ҫ" + ((_ifUp == true) ? '����' : '����') + "����!",
				type: "alert"
			});
			return false;
		}
		var rowsData = $("#" + _gridID).datagrid("getRows");
		var rowIndex = $("#" + _gridID).datagrid('getRowIndex', selectedData);
		if (_ifUp == true) {
			if (rowIndex == 0) {
				PHA.Popover({
					msg: "�ѵ����һ��!",
					type: "alert"
				});
				return false;
			}
		} else {
			if (rowIndex == rowsData.length - 1) {
				PHA.Popover({
					msg: "�ѵ������һ��!",
					type: "alert"
				});
				return false;
			}
		}
		var newSelectedData = this.deepCopy(selectedData);
		// ������
		if (_ifUp == true) {
			$("#" + _gridID).datagrid('updateRow', {
				index: rowIndex,
				row: rowsData[rowIndex - 1]
			});
			$("#" + _gridID).datagrid('updateRow', {
				index: rowIndex - 1,
				row: newSelectedData
			});
			$("#" + _gridID).datagrid('selectRow', rowIndex - 1);
		} else {
			$("#" + _gridID).datagrid('updateRow', {
				index: rowIndex,
				row: rowsData[rowIndex + 1]
			});
			$("#" + _gridID).datagrid('updateRow', {
				index: rowIndex + 1,
				row: newSelectedData
			});
			$("#" + _gridID).datagrid('selectRow', rowIndex + 1);
		}
		return true;
	},
	/*
	 * ��ʾ�����Ϣ
	 * Huxt 2021-03-26
	 */
	AddGridInfo: function () {
		var westContentHtml = '<div class="hisui-panel" title="" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true">';
		/* �ı��� */
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_ClassName">����</label></div>';
		westContentHtml += '	<div class="pha-col">';
		westContentHtml += '		<input id="grid_set_ClassName" class="hisui-validatebox" data-options="disabled:true" style="width:128px;"/>';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_QueryName">Query��</label></div>';
		westContentHtml += '	<div class="pha-col">';
		westContentHtml += '		<input id="grid_set_QueryName" class="hisui-validatebox" data-options="disabled:true" style="width:128px;"/>';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_MethodName">������</label></div>';
		westContentHtml += '	<div class="pha-col">';
		westContentHtml += '		<input id="grid_set_MethodName" class="hisui-validatebox" data-options="disabled:true" style="width:128px;"/>';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_pageList">�����б�</label></div>';
		westContentHtml += '	<div class="pha-col">';
		westContentHtml += '		<input id="grid_set_pageList" class="hisui-validatebox" style="width:128px;"/>';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_pageSize">ÿҳ����</label></div>';
		westContentHtml += '	<div class="pha-col">';
		westContentHtml += '		<input id="grid_set_pageSize" class="hisui-validatebox" style="width:128px;"/>';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		/* ��ѡ�� */
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_pagination">�Ƿ��ҳ</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_pagination" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:78px;"><label for="grid_set_rownumbers">��ʾ�к�</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_rownumbers" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_nowrap">������</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_nowrap" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:78px;"><label for="grid_set_fitColumns">�Զ����</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_fitColumns" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_striped">������</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_striped" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:78px;"><label for="grid_set_showComCol">��ʾͨ����</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_showComCol" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_exportXls" class="hisui-tooltip" title="ֻ�����ں�̨����">�����˵�</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_exportXls" class="hisui-checkbox" data-options="boxPosition:\'right\',disabled:true" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:78px;"><label for="grid_set_exportChkCol">����ѡ����</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_exportChkCol" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_printOut" class="hisui-tooltip" title="ֻ�����ں�̨����">��ӡ�˵�</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_printOut" class="hisui-checkbox" data-options="boxPosition:\'right\',disabled:true" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:78px;"><label for="grid_set_printChkCol">����ѡ��ӡ</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_printChkCol" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		/*
		westContentHtml += '<div class="pha-row">';
		westContentHtml += '	<div class="pha-col" style="text-align:right;width:60px;"><label for="grid_set_showContextMenu">�Ҽ��˵�</label></div>';
		westContentHtml += '	<div class="pha-col" style="margin-left:-10px;">';
		westContentHtml += '		<input id="grid_set_showContextMenu" class="hisui-checkbox" data-options="boxPosition:\'right\'" type="checkbox" />';
		westContentHtml += '	</div>';
		westContentHtml += '</div>';
		*/
		westContentHtml += '</div>';
		if (this.InitOptions.hideWest !== true) {
			$('#gridDialogSetLayout').layout('add', {
				region: 'west',
				width: 237,
				split: true,
				border: false,
				content: westContentHtml
			});
		}
		$('#gridDialogSetLayout').layout('add', {
			region: 'south',
			height: 45,
			split: true,
			border: false,
			content: '<center>' + COLSET_WIN.GetTypeHtml() + '</center>'
		});
		this.QueryGridInfo();
	},
	QueryGridInfo: function () {
		var serverOpts = COLSET_WIN.InitOptions.serverOpts;
		if (typeof serverOpts == 'undefined') {
			return;
		}
		$('#grid_set_ClassName').val(serverOpts.ClassName || "");
		$('#grid_set_QueryName').val(serverOpts.QueryName || "");
		$('#grid_set_MethodName').val(serverOpts.MethodName || "");
		$('#grid_set_pageList').val((serverOpts.pageList || []).join(','));
		$('#grid_set_pageSize').val(serverOpts.pageSize || "");
		$('#grid_set_pagination').checkbox('setValue', serverOpts.pagination == 1 ? true : false);
		$('#grid_set_striped').checkbox('setValue', serverOpts.striped == 1 ? true : false);
		$('#grid_set_nowrap').checkbox('setValue', serverOpts.nowrap != 1 ? false : true);
		$('#grid_set_rownumbers').checkbox('setValue', serverOpts.rownumbers == 1 ? true : false);
		$('#grid_set_fitColumns').checkbox('setValue', serverOpts.fitColumns == 1 ? true : false);
		// $('#grid_set_showContextMenu').checkbox('setValue', serverOpts.showContextMenu == 1 ? true : false);
		$('#grid_set_exportChkCol').checkbox('setValue', serverOpts.exportChkCol == 1 ? true : false);
		$('#grid_set_exportXls').checkbox('setValue', serverOpts.exportXls == 1 ? true : false);
		$('#grid_set_printChkCol').checkbox('setValue', serverOpts.printChkCol == 1 ? true : false);
		$('#grid_set_printOut').checkbox('setValue', serverOpts.printOut == 1 ? true : false);
		$('#grid_set_showComCol').checkbox('setValue', serverOpts.showComCol == 1 ? true : false);
	},
	GetGridInfo: function () {
		var ClassName = $('#grid_set_ClassName').val();
		var QueryName = $('#grid_set_QueryName').val();
		var MethodName = $('#grid_set_MethodName').val();
		var pageList = $('#grid_set_pageList').val();
		var pageSize = $('#grid_set_pageSize').val();
		var pagination = $('#grid_set_pagination').checkbox('getValue') == true ? 'Y' : 'N';
		var striped = $('#grid_set_striped').checkbox('getValue') == true ? 'Y' : 'N';
		var nowrap = $('#grid_set_nowrap').checkbox('getValue') == true ? 'Y' : 'N';
		var rownumbers = $('#grid_set_rownumbers').checkbox('getValue') == true ? 'Y' : 'N';
		var fitColumns = $('#grid_set_fitColumns').checkbox('getValue') == true ? 'Y' : 'N';
		// var showContextMenu = $('#grid_set_showContextMenu').checkbox('getValue') == true ? 'Y' : 'N';
		var exportChkCol = $('#grid_set_exportChkCol').checkbox('getValue') == true ? 'Y' : 'N';
		var exportXls = $('#grid_set_exportXls').checkbox('getValue') == true ? 'Y' : 'N';
		var printChkCol = $('#grid_set_printChkCol').checkbox('getValue') == true ? 'Y' : 'N';
		var printOut = $('#grid_set_printOut').checkbox('getValue') == true ? 'Y' : 'N';
		var showComCol = $('#grid_set_showComCol').checkbox('getValue') == true ? 'Y' : 'N';
		var saveData = {
			ClassName: ClassName,
			QueryName: QueryName,
			MethodName: MethodName,
			pageList: pageList,
			pageSize: pageSize,
			pagination: pagination,
			striped: striped,
			nowrap: nowrap,
			rownumbers: rownumbers,
			fitColumns: fitColumns,
			exportChkCol: exportChkCol,
			exportXls: exportXls,
			printChkCol: printChkCol,
			printOut: printOut,
			showComCol: showComCol
		}
		return saveData;
	},
	GetTypeHtml: function () {
		var typeHtml = "";
		typeHtml += "<div style='margin-top:10px'>";
		typeHtml += "	<div class='pha-col'>";
		typeHtml += "		<input class='hisui-radio' type='radio' label='�û�' name='PHA_SYS_SET_GirdWin_Type' value='U' data-options='requiredSel:true' />";
		typeHtml += "	</div>";
		typeHtml += "	<div class='pha-col'>";
		typeHtml += "		<input class='hisui-radio' type='radio' label='��ȫ��' name='PHA_SYS_SET_GirdWin_Type' value='G' data-options='requiredSel:true' />";
		typeHtml += "	</div>";
		typeHtml += "	<div class='pha-col'>";
		typeHtml += "		<input class='hisui-radio' type='radio' label='����' name='PHA_SYS_SET_GirdWin_Type' value='L' data-options='requiredSel:true' />";
		typeHtml += "	</div>";
		typeHtml += "	<div class='pha-col'>";
		typeHtml += "		<input class='hisui-radio' type='radio' label='ҽԺ' name='PHA_SYS_SET_GirdWin_Type' value='A' data-options='requiredSel:true,checked:true' />";
		typeHtml += "	</div>";
		typeHtml += "</div>";
		return typeHtml;
	},
	GetSaveType: function () {
		var checkedRadioObj = $("input[name='PHA_SYS_SET_GirdWin_Type']:checked");
		var authType = checkedRadioObj == undefined ? "" : checkedRadioObj.val();
		if (authType == "" || authType == undefined) {
			return "";
		}
		return authType;
	},
	SetSaveType: function (authType) {
		var $_radio = $("input[name='PHA_SYS_SET_GirdWin_Type'][value='" + authType + "']");
		if ($_radio.length > 0) {
			$_radio.radio('setValue', true);
		}
	},
	// ��ʼ������Ϣ
	GetColumns: function (_sysFlag) {
		var gridColums = [[{
					field: "ColId",
					title: 'ColId',
					hidden: true,
					width: 100
				}, {
					field: "ColTableName",
					title: 'ColTableName',
					hidden: true,
					width: 100
				}, {
					field: "ColPointer",
					title: 'ColPointer',
					hidden: true,
					width: 100
				}, {
					field: "ColSort",
					title: '��˳��',
					hidden: true,
					width: 70,
					align: 'center'
				}, {
					field: "ColField",
					title: '�ֶ�',
					width: 110,
					editor: {
						type: 'validatebox',
						options: {
							editable: _sysFlag == "Y" ? true : false,
							required: _sysFlag == "Y" ? true : false
						}
					}
				}, {
					field: "ColTitle",
					title: '����',
					width: 110,
					editor: {
						type: 'validatebox',
						options: {
							required: true
						}
					}
				}, {
					field: "ColWidth",
					title: '���',
					width: 70,
					align: 'right',
					editor: {
						type: 'validatebox',
						options: {
							required: true
						}
					}
				}, {
					field: "ColAlign",
					title: '����',
					width: 88,
					align: 'left',
					editor: {
						type: 'combobox',
						options: {
							valueField: 'RowId',
							textField: 'Description',
							panelHeight: 'auto',
							editable: true,
							data: [{
									RowId: 'left',
									Description: 'left'
								}, {
									RowId: 'center',
									Description: 'center'
								}, {
									RowId: 'right',
									Description: 'right'
								}
							]
						}
					}
				}, {
					field: "ColSortable",
					title: '����',
					width: 45,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColHidden",
					title: '����',
					width: 45,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColIfExport",
					title: '����',
					width: 45,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColIfPrint",
					title: '��ӡ',
					width: 45,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColIsCheckbox",
					title: '��ѡ��',
					width: 55,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColFrozen",
					title: '�ж���',
					width: 55,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColFixed",
					title: '�п�̶�',
					width: 65,
					align: "center",
					fixed: true,
					editor: COLSET_WIN.YesNoEditor,
					formatter: COLSET_WIN.YesNoFormatter
				}, {
					field: "ColTipWidth",
					title: '��ʾ���',
					width: 78,
					align: 'right',
					editor: {
						type: 'validatebox',
						options: {
							required: false
						}
					}
				}, {
					field: "ColEnterSort",
					title: '�س�˳��',
					width: 90,
					hidden: false,
					align: 'center',
					editor: {
						type: 'validatebox',
						options: {
							required: false
						}
					}
				}, {
					field: "ColIsTotal",
					title: '���',
					width: 70,
					align: 'center',
					editor: {
						type: 'combobox',
						options: {
							valueField: 'RowId',
							textField: 'Description',
							panelHeight: 'auto',
							data: [{
									RowId: '���',
									Description: $g('���')
								}, {
									RowId: '�ϼ�',
									Description: $g('�ϼ�')
								}
							]
						}
					}
				}, {
					field: "ColFormatter",
					title: 'formatter',
					width: 85,
					hidden: _sysFlag == "Y" ? false : true,
					editor: {
						type: 'validatebox',
						options: {
							required: false
						}
					}
				}, {
					field: "ColStyler",
					title: 'styler',
					width: 85,
					editor: {
						type: 'validatebox',
						options: {
							required: false
						}
					}
				}
			]
		];
		// ����������
		var ResetCols = COLSET_WIN.ResetCols || [];
		if (ResetCols.length > 0) {
			var colIndex = {};
			for (var i = 0; i < gridColums[0].length; i++) {
				var colField = gridColums[0][i].field;
				colIndex[colField] = i;
			}
			for (var i = 0; i < ResetCols.length; i++) {
				var iResetCol = ResetCols[i];
				var resetColField = iResetCol.field;
				var cIndex = colIndex[resetColField];
				if (cIndex >= 0 && gridColums[0][cIndex]) {
					for (var colProp in iResetCol) {
						gridColums[0][cIndex][colProp] = iResetCol[colProp];
					}
				}
			}
		}
		return gridColums;
	},
	// ��ȡֵ���ʽ����
	OpenColValWin: function(){
		var colValBtnMsg = this.InitOptions.colValBtnMsg;
		if (colValBtnMsg && colValBtnMsg != '') {
			PHA.Popover({
				msg: colValBtnMsg,
				type: 'alert'
			});
			return;
		}
		var _queryParams = this.InitOptions.queryParams;
		var winId = 'col_val_win';
		var gridId = winId + '_grid';
		var saveId = winId + '_save';
		var refreshId = winId + '_refresh';
		var helpId = winId + '_help';
		if ($('#' + winId).length == 0) {
			// ����
			var helpHtml = '';
			helpHtml += '<p>' + $g('��1��ά��ȡֵ���ʽ֮�󣬺�̨��Ҫ�ڲ�ѯ�����е���PHA.SYS.Col.Value�е�ȡֵ��������Ч��') + '</p>';
			helpHtml += '<p>' + $g('��2��ȡֵ���ʽȡ������ֵ�����id�����ͨ��ֵת�����ʽת������Ӧ�Ĵ���������ơ�') + '</p>';
			var layoutHtml = '';
			layoutHtml += '<div id="' + (gridId + '_Bar') + '">';
			layoutHtml += '	<a id="' + saveId + '" class="hisui-linkbutton" plain="true" iconCls="icon-save">' + $g('����') + '</a>';
			layoutHtml += '	<a id="' + refreshId + '" class="hisui-linkbutton" plain="true" iconCls="icon-reload">' + $g('ˢ��') + '</a>';
			layoutHtml += '	<a id="' + helpId + '" class="hisui-linkbutton" plain="true" iconCls="icon-help">' + $g('����') + '</a>';
			layoutHtml += '</div>';
			layoutHtml += '<div class="hisui-layout" fit="true">';
			layoutHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
			layoutHtml += '		<div class="hisui-panel" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true" title="">';
			layoutHtml += '			<table id="' + gridId + '"></table>';
			layoutHtml += '		</div>';
			layoutHtml += '	</div>';
			layoutHtml += '</div>';
			$('body').append('<div id="' + winId + '"></div>');
			// ����
			$('#' + winId).dialog({
				title: '��ȡֵ���ʽά��',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-book",
				border: false,
				closed: true,
				modal: true,
				width: 900,
				height: 530,
				content: layoutHtml
			});
			$('#' + winId).dialog('open');
			// ���
			var columns = [
				[{
					field: "ColField",
					title: '�ֶ�',
					width: 110
				}, {
					field: "ColTitle",
					title: '����',
					width: 110
				}, {
					field: 'ColValExp',
					title: 'ȡֵ���ʽ',
					width: 300,
					rowHeight: 28,
					editor: PHA_GridEditor.ComboGrid({
						url: $URL + '?ResultSetType=Json&ClassName=PHA.SYS.Col.Query&QueryName=ValExp',
						panelWidth: 500,
						fitColumns: true,
						idField: 'RowId',
						textField: 'RowId',
						pageSize: 30,
						qLen: 0,
						columns: [[{
								field: 'RowId',
								title: '���ʽ',
								width: 150,
							}, {
								field: 'Description',
								title: '���ʽ����',
								width: 100,
							}
						]],
						onBeforeNext: function(cmbRowData, gridRowData, gridRowIndex){
							gridRowData.ColValExpDesc = cmbRowData.Description;
						}
					})
				}, {
					field: 'ColValExpDesc',
					title: 'ȡֵ���ʽ����',
					width: 160
				}, {
					field: 'ColValConvert',
					title: 'ֵת�����ʽ',
					width: 140,
					editor: PHA_GridEditor.ComboGrid({
						url: $URL + '?ResultSetType=Json&ClassName=PHA.SYS.Col.Query&QueryName=ValConvert',
						panelWidth: 410,
						fitColumns: true,
						idField: 'RowId',
						textField: 'RowId',
						pageSize: 30,
						qLen: 0,
						columns: [[{
								field: 'RowId',
								title: '���ʽ',
								width: 100,
							}, {
								field: 'Description',
								title: '���ʽ����',
								width: 150,
							}
						]],
						onBeforeNext: function(cmbRowData, gridRowData, gridRowIndex){
							gridRowData.ColValConvertDesc = cmbRowData.Description;
						}
					})
				}, {
					field: 'ColValConvertDesc',
					title: 'ֵת�����ʽ����',
					width: 160
				}
				]
			];
			var dataGridOption = {
				url: $URL,
				queryParams: _queryParams,
				columns: columns,
				pagination: false,
				fitColumns: true,
				toolbar: '#' + gridId + '_Bar',
				enableDnd: false,
				editFieldSort: ['ColValExp', 'ColValConvert'],
				onRowContextMenu: function () {},
				onDblClickRow: function (rowIndex, field, value) {},
				onClickCell: function(index, field, value){
					PHA_GridEditor.Edit({
						gridID: gridId,
						index: index,
						field: field
					});
				},
				onSelect: function (rowIndex, rowData) {},
				onLoadSuccess: function (data) {},
				gridSave: false
			};
			PHA.Grid(gridId, dataGridOption);
			// �¼�
			$('#' + saveId).on('click', SaveColVal);
			$('#' + refreshId).on('click', RefreshColVal);
			$('#' + helpId).attr('title', helpHtml);
			$('#' + helpId).tooltip({
				position: 'right'
			});
		}
		$('#' + winId).dialog('open');
		RefreshColVal();
		return;
		
		// �¼�����
		function SaveColVal(){
			PHA_GridEditor.End(gridId);
			var rowsData = $('#' + gridId).datagrid('getRows');
			if ((rowsData == null || rowsData.length == 0)) {
				PHA.Popover({
					msg: "û����Ҫ���������!",
					type: "alert"
				});
				return;
			}
			var jsonColStr = JSON.stringify(rowsData);
			var jsonCol = JSON.parse(jsonColStr);
			for (var i = 0; i < jsonCol.length; i++) {
				var iCol = jsonCol[i];
				if (iCol.ColValConvert && iCol.ColValConvert != '') {
					iCol.ColValExp = iCol.ColValExp + '-' + iCol.ColValConvert;
				}
			}
			jsonColStr = JSON.stringify(jsonCol);
			
			var retText = tkMakeServerCall('PHA.SYS.Col.Save', 'SaveForPIPIS', jsonColStr);
			var retArr = retText.split('^');
			if (retArr[0] < 0) {
				PHA.Alert("��ܰ��ʾ", retArr[1], retArr[0]);
				return;
			}
			PHA.Popover({
				msg: "����ɹ�!",
				type: "success"
			});
			RefreshColVal();
		}
		function RefreshColVal(){
			$('#' + gridId).datagrid('reload');
		}
	},
	YesNoEditor: {
		type: 'icheckbox',
		options: {
			on: 'Y',
			off: 'N'
		}
	},
	YesNoFormatter: function (val, rowData, rowIndex) {
		if (val == "Y") {
			return PHA_COM.Fmt.Grid.Yes.Chinese;
		} else {
			return PHA_COM.Fmt.Grid.No.Chinese;
		}
	},
	deepCopy: function (source) {
		var result = {};
		for (var key in source) {
			result[key] = typeof source[key] === 'object' ? deepCopy(source[key]) : source[key];
		}
		return result;
	}
}
