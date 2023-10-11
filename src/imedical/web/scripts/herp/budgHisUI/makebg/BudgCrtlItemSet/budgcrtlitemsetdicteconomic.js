/*
Creator: Liu XiaoMing
CreatDate: 2018-03-23
Description: ���������-���ÿ�����
CSPName: herp.budg.hisui.budgitemmonitor.csp
ClassName: herp.budg.hisui.udata.uBudgItemMonitor
 */
var hospid = session['LOGON.HOSPID'];
var init = function () {
	//���α��
	var ctrlItemsObj = $HUI.treegrid("#setCtrlItemDictEconomic", {
			//title: '֧������������',
			//headerCls: 'panel-header-gray',
			lines: true,
			border: false,
			fit: true,
			idField: 'id',
			treeField: 'Name',
			rownumbers: true,
			autoSizeColumn: false,
			checkbox: true,
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgCtrlItemDictEconomic",
				MethodName: "ListEconomic",
				hospid: hospid
			},
			/*
			onLoadSuccess: function (row, data) {
			if (data) {
			$.each(data, function (index, item) {
			alert(item.checked);

			});
			}
			},
			 */
			onCheckNode: function (row, checked) {
				var p = ctrlItemsObj.getPanel();
				var nodes = ctrlItemsObj.getCheckedNodes();
				/*
				if (nodes.length) {
				p.find("#addCItems").linkbutton("enable");
				p.find("#delCItems").linkbutton("enable");
				} else {
				p.find("#addCItems").linkbutton("disable");
				p.find("#delCItems").linkbutton("disable");
				}
				 */
			},
			columns: [[{
						field: 'id',
						width: '250',
						hidden: true,
						title: 'ID'
					}, {
						field: 'Name',
						width: '250',
						title: '����'
					}, {
						field: 'Code',
						width: '150',
						title: '����'
					}, {
						field: 'Year',
						width: '100',
						title: '���'
					}, {
						field: 'CompDR',
						width: '200',
						title: 'ҽԺ����'
					}, {
						field: 'Active',
						width: '120',
						title: '�Ƿ����'
					}, {
						field: '_parentId',
						width: '120',
						hidden: true,
						title: '�ϼ�����'
					}
				]],
			toolbar: [{
					iconCls: 'icon-batch-cfg',
					text: '���ÿ�����',
					id: 'addCItems',
					//disabled: true,
					handler: function () {
						save(ctrlItemsObj);
					}
				}, {
					iconCls: 'icon-stop-order',
					text: 'ȡ��������',
					id: 'delCItems',
					//disabled: true,
					handler: function () {
						del(ctrlItemsObj);
					}
				}
			]

		});

	//֧�����Ʒ���
	var save = function (treegridObj) {
		//alert(getNoChiChkedNodesId(treegridObj));
		if (getNoChiChkedNodesId(treegridObj)) {
			$.m({
				ClassName: "herp.budg.hisui.udata.uBudgCtrlItemDictEconomic",
				MethodName: "Save",
				rowids: getNoChiChkedNodesId(treegridObj)
			}, function (rtn) {
				if (rtn == 0) {
					treegridObj.reload();
					$.messager.popover({
						msg: '���óɹ���',
						type: 'success',
						timeout: 3000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 10
						}
					});

				} else {
					$.messager.popover({
						msg: '����ʧ��' + rtn,
						type: 'error',
						timeout: 3000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 10
						}
					});
				};
			});
		}
	}

	//ɾ������
	var del = function (treegridObj) {
		//alert(getNoChiChkedNodesId(treegridObj));
		if (getNoChiChkedNodesId(treegridObj)) {
			$.m({
				ClassName: "herp.budg.hisui.udata.uBudgCtrlItemDictEconomic",
				MethodName: "Del",
				rowids: getNoChiChkedNodesId(treegridObj)
			}, function (rtn) {
				if (rtn == 0) {
					treegridObj.reload();
					$.messager.popover({
						msg: 'ȡ���ɹ���',
						type: 'success',
						timeout: 1000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 10
						}
					});

				} else {
					$.messager.popover({
						msg: 'ȡ��ʧ�ܣ�' + rtn,
						type: 'error',
						timeout: 3000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 10
						}
					});

				};
			});
		} else {
			return;
		}

	}
};

$(init);
