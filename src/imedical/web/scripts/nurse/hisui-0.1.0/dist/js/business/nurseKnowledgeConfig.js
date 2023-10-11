/*
 * @author: yaojining
 * @discription: 知识库维护
 * @date: 2020-05-11
 */
$(function () {
	/**
		* @description:  定义全局变量
	*/
	var GLOBAL = {
		NodeData: {},
		ArrData: [],
		TemplateID: '',
		EditElementID: '',
		ElementNew: '',
		HospitalID: session['LOGON.HOSPID']
	};
	/**
	* @description: 初始化界面
	*/
	function initUI() {
		initSearchCondition();
		initKnowledgeCategoryTree();
		listenEvents();
	}
	/**
	* @description: 初始化查询条件
	*/
	function initSearchCondition() {
		$HUI.combobox('#comboDepartment', {
			valueField: 'id',
			textField: 'desc',
			url: $URL + '?ClassName=NurMp.Common.Base.Loc&MethodName=GetLocs&HospitalID=' + GLOBAL.HospitalID + '&LocType=W',
			value: session['LOGON.CTLOCID'],
			onSelect: function (record) {
				$HUI.tree('#knowledgeCategoryTree', 'reload');
			},
			defaultFilter: 4
		});
	}
	/**
	* @description: 初始化menu
	*/
	function initMenu(node) {
		$('#menuTree').empty();
		if (node.iconCls == 'icon-book-green') {
			$('#menuTree').menu('appendItem', {
				id: 'menuAddMenu',
				text: '增加目录',
				iconCls: 'icon-add',
				handler: addCategory
			});
			$('#menuTree').menu('appendItem', {
				id: 'menuAddSub',
				text: '增加子项',
				iconCls: 'icon-add-item',
				handler: addCategorySub
			});
		}
		if (node.text.toString().indexOf('^') < 0) {
			$('#menuTree').menu('appendItem', {
				id: 'menuRemove',
				text: '删除',
				iconCls: 'icon-cancel',
				handler: deleteNode
			});
			$('#menuTree').menu('appendItem', {
				id: 'menuProperty',
				text: '属性',
				iconCls: 'icon-batch-cfg',
				handler: editProperty
			});
			$('#menuTree').menu('appendItem', {
				id: 'menuUp',
				text: '上移',
				iconCls: 'icon-arrow-top',
				handler: function () {
					moveNode('UP');
				}
			});
			$('#menuTree').menu('appendItem', {
				id: 'menuDown',
				text: '下移',
				iconCls: 'icon-arrow-bottom',
				handler: function () {
					moveNode('DOWN');
				}
			});
		}
	}
	/**
	* @description: 初始化知识库目录树结构
	*/
	function initKnowledgeCategoryTree() {
		$HUI.tree('#knowledgeCategoryTree', {
			loader: function (param, success, error) {
				$cm({
					ClassName: 'NurMp.Service.Refer.Handle',
					MethodName: 'getKnowledgeTree',
					LocId: session['LOGON.CTLOCID'],
					HospitalID: GLOBAL.HospitalID,
					Flag: '0'
				}, function (treeData) {
					if (treeData.length == 0) {
						//treeData.push({id:0,text:'点击以新建目录...'});
						$.messager.popover({ msg: $g("请联系超级用户前往编辑器中维护知识库目录！"), type: 'alert', timeout: 5000 });
					}
					success(treeData);
				});
			},
			autoNodeHeight: true,
			onClick: clickNodeHandler,
			onContextMenu: function (e, node) {
				initMenu(node);
				if (node.id != 0) {
					e.preventDefault();
					$('#knowledgeCategoryTree').tree('select', node.target);
					$('#menuTree').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				}
			}
		});
	}
	/**
		* @description:  节点点击事件
	*/
	function clickNodeHandler(node) {
		GLOBAL.TemplateID = node.guid;
		if (node.id == 0) {
			dialogShow(node);
		} else {
			initContentPanel();
			GLOBAL.NodeData = {};
			GLOBAL.ArrData = [];
			GLOBAL.EditElementID = '';
			if (node.iconCls == 'icon-paper-info') {
				GLOBAL.TemplateID = node.guid;
				clearSource();
				$('#kw').empty();
				loadKnowData(node);
			} else {
				$('#elementTree').empty();
				$('#contentPanel').empty();
			}
		}
	}
	/**
		* @description:  添加/属性窗口
	*/
	function dialogShow(node) {
		if ((node.text.toString().indexOf('^') > -1) || (node.id == 0)) {
			var myTitle = '新建目录';
			var iconCls = 'icon-w-add';
			if (node.id != 0) {
				myTitle = '属性';
				iconCls = 'icon-w-config';
			}
			$HUI.dialog('#dialogTreeConfig', {
				title: myTitle,
				width: 320,
				height: 250,
				iconCls: 'icon-w-add',
				resizable: false,
				modal: true,
				buttons: [{
					text: '保存',
					handler: function () {
						saveCategory();
					}
				}, {
					text: '取消',
					handler: function () {
						$HUI.dialog('#dialogTreeConfig').close();
					}
				}],
				onOpen: function () {
					$HUI.combobox('#comboWard', {
						valueField: 'id',
						textField: 'desc',
						url: $URL + '?ClassName=NurMp.Common.Base.Loc&MethodName=GetLocs&HospitalID=' + GLOBAL.HospitalID + '&LocType=W',
						value: '',
						editable: true,
						onSelect: function (record) {
							//$('#wardKey').val(record.id);
						},
						defaultFilter: 4
					});
					//$('#wardKey').val('');
					if (typeof node.desc != 'undefined') {
						$('#desc').val(node.desc);
					}
					$HUI.combobox('#comboAuthLoc', {
						valueField: 'id',
						textField: 'desc',
						multiple: true,
						rowStyle: 'checkbox', //显示成勾选行形式
						selectOnNavigation: false,
						//panelHeight:"auto",
						editable: true,
						url: $URL + '?ClassName=NurMp.Common.Base.Loc&MethodName=GetLocs&HospitalID=' + GLOBAL.HospitalID,
						value: '',
						defaultFilter: 4
					});
					if (node.id == 0) {
						$('#comboWard').combobox('setValue', session['LOGON.CTLOCID']);
						//$('#wardKey').val(session['LOGON.CTLOCID']);
						$('#desc').val('');
						$('#comboAuthLoc').combobox('setValue', session['LOGON.CTLOCID']);
					} else {
						$('#comboWard').combobox('setValue', node.text.split('^')[1]);
						//$('#wardKey').val(node.text.split('^')[1]);
						if (typeof node.desc != 'undefined') {
							$('#desc').val(node.desc);
						}
						$('#comboAuthLoc').combobox('setValues', node.locs.split('^'));
					}
				}
			});

		} else {
			$HUI.dialog('#dialogAddCate', {
				title: "属性",
				width: 320,
				height: 200,
				iconCls: 'icon-w-add',
				resizable: false,
				modal: true,
				buttons: [{
					text: '保存',
					handler: function () {
						saveProperty(node);
					}
				}, {
					text: '取消',
					handler: function () {
						$HUI.dialog('#dialogAddCate').close();
					}
				}],
				onOpen: function () {
					$('#cateName').val(node.text);
					$('#cateDesc').val(node.desc);
				}
			});
		}
	}

	/**
		* @description:  保存目录
	*/
	function saveCategory() {
		var ward = $('#comboWard').combobox('getValue');
		if (!ward) {
			$.messager.popover({ msg: $g("请选择病区！"), type: 'alert', timeout: 1000 });
			return;
		}
		var arrLocs = $('#comboAuthLoc').combobox('getValues');
		if (arrLocs.length == 0) {
			$.messager.popover({ msg: $g("请授权！"), type: 'alert', timeout: 1000 });
			return;
		}
		var locs = arrLocs.join('^');
		$m({
			ClassName: "NurMp.Service.Refer.Handle",
			MethodName: "getFirstCategory",
			HospitalID: GLOBAL.HospitalID
		}, function (rootGuid) {
			if (!!rootGuid) {
				var node = $('#knowledgeCategoryTree').tree('getSelected');
				var Guid = node.guid;
				var cmMsg = $g('修改成功');
				if (!Guid) {
					Guid = $m({
						ClassName: "DHCHAI.Utils.CommonSrv",
						MethodName: "GetGUIDCode"
					}, false);
					cmMsg = $g('新增成功');
				}
				if (!!Guid) {
					var name = $('#comboWard').combobox('getText');
					var wardKey = name.split('^')[1];
					var desc = $('#desc').val();
					var json = { Inpatient: name, Id: 0, Indentity: Guid, Name: name, ParentIndentity: rootGuid, Type: 1, Description: desc, IsDelete: false, TemplateIndentity: wardKey + "Kn", HospitalID: GLOBAL.HospitalID };
					$cm({
						ClassName: 'NurMp.KnowledgeCategory',
						MethodName: 'save',
						parr: JSON.stringify(json)
					}, function (result) {
						if (result.status == '0') {
							$cm({
								ClassName: 'NurMp.KnowledgeLoc',
								MethodName: 'Save',
								kcIndentity: Guid,
								locstr: locs
							}, function (ret) {
								if (ret.status == '0') {
									$.messager.popover({ msg: cmMsg + "！", type: 'success', timeout: 1000 });
									$HUI.dialog('#dialogTreeConfig').close();
									$HUI.tree('#knowledgeCategoryTree', 'reload');
									return;
								} else {
									$.messager.popover({ msg: cmMsg + $g("，科室关联失败！"), type: 'error', timeout: 1000 });
									return;
								}
							});

						} else {
							$.messager.popover({ msg: $g(result.msg), type: 'error', timeout: 1000 });
							return;
						}
					});
				}
			} else {
				$.messager.popover({ msg: $g("获取根目录失败！"), type: 'error', timeout: 1000 });
				return;
			}
		});
	}
	/**
		* @description:  保存属性
	*/
	function saveProperty(node) {
		var name = $('#cateName').val();
		if (!name) {
			$.messager.popover({ msg: $g('请填写名称！'), type: 'info', timeout: 1000 });
			return;
		}
		var desc = $('#cateDesc').val();
		if (!desc) {
			$.messager.popover({ msg: $g('请填写描述！'), type: 'info', timeout: 1000 });
			return;
		}
		var templateGuid = typeof node.templateGuid == 'undefined' ? '' : node.templateGuid;
		var type = node.iconCls == 'icon-paper-info' ? 1 : 0;
		var json = { Id: node.id, Indentity: node.guid, Name: name, Description: desc, Type: type, TemplateIndentity: templateGuid, HospitalID: GLOBAL.HospitalID };
		$cm({
			ClassName: 'NurMp.KnowledgeCategory',
			MethodName: 'save',
			parr: JSON.stringify(json)
		}, function (result) {
			if (result.status == '0') {
				$.messager.popover({ msg: $g("修改成功！"), type: 'success', timeout: 1000 });
				$HUI.dialog('#dialogAddCate').close();
				$HUI.tree('#knowledgeCategoryTree', 'reload');
			} else {
				$.messager.popover({ msg: result.msg, type: 'error', timeout: 1000 });
				return;
			}
		});
	}
	/**
		* @description:  增加目录
	*/
	function addCategory() {
		var node = $('#knowledgeCategoryTree').tree('getSelected');
		if (!node) {
			$.messager.popover({
				msg: $g('请选择节点！'),
				type: 'info',
				timeout: 1000
			});
			return;
		}
		$HUI.dialog('#dialogAddCate', {
			title: '添加目录',
			width: 320,
			height: 200,
			iconCls: 'icon-w-add',
			resizable: false,
			modal: true,
			buttons: [{
				text: '保存',
				handler: function () {
					var name = $('#cateName').val();
					if (!name) {
						$.messager.popover({ msg: $g('请填写名称！'), type: 'info', timeout: 1000 });
						return;
					}
					var desc = $('#cateDesc').val();
					if (!desc) {
						$.messager.popover({ msg: $g('请填写描述！'), type: 'info', timeout: 1000 });
						return;
					}
					$m({
						ClassName: "DHCHAI.Utils.CommonSrv",
						MethodName: "GetGUIDCode"
					}, function (Guid) {
						if (!!Guid) {
							var json = { Inpatient: 'null', Id: 0, Indentity: Guid, Name: name, ParentIndentity: node.guid, Type: 0, Description: desc, IsDelete: false, TemplateIndentity: 'null', HospitalID: GLOBAL.HospitalID };
							$cm({
								ClassName: 'NurMp.KnowledgeCategory',
								MethodName: 'save',
								parr: JSON.stringify(json)
							}, function (result) {
								if (result.status == '0') {
									$.messager.popover({ msg: $g("添加成功！"), type: 'success', timeout: 1000 });
									$HUI.dialog('#dialogAddCate').close();
									$HUI.tree('#knowledgeCategoryTree', 'reload');
									return;
								} else {
									$.messager.popover({ msg: $g(result.msg), type: 'error', timeout: 1000 });
									return;
								}
							});
						}
					});
				}
			}, {
				text: '取消',
				handler: function () {
					$HUI.dialog('#dialogAddCate').close();
				}
			}],
			onOpen: function () {
				$('#cateName').val('');
				$('#cateDesc').val('');
			}
		});
	}
	/**
		* @description:  增加子项
	*/
	function addCategorySub(p) {
		var node = $('#knowledgeCategoryTree').tree('getSelected');
		if (!node) {
			$.messager.popover({
				msg: $g('请选择节点！'),
				type: 'info',
				timeout: 1000
			});
			return;
		}
		$HUI.dialog('#dialogAddCate', {
			title: '添加子项',
			width: 320,
			height: 200,
			iconCls: 'icon-w-add',
			resizable: false,
			modal: true,
			buttons: [{
				text: '保存',
				handler: function () {
					var name = $('#cateName').val();
					if (!name) {
						$.messager.popover({ msg: $g('请填写名称！'), type: 'info', timeout: 1000 });
						return;
					}
					var desc = $('#cateDesc').val();
					if (!desc) {
						$.messager.popover({ msg: $g('请填写描述！'), type: 'info', timeout: 1000 });
						return;
					}
					$m({
						ClassName: "DHCHAI.Utils.CommonSrv",
						MethodName: "GetGUIDCode"
					}, function (Guid) {
						if (!!Guid) {
							$m({
								ClassName: "DHCHAI.Utils.CommonSrv",
								MethodName: "GetGUIDCode"
							}, function (tempGuid) {
								if (!!tempGuid) {
									var json = { Inpatient: 'null', Id: 0, Indentity: Guid, Name: name, ParentIndentity: node.guid, Type: 1, Description: desc, IsDelete: false, TemplateIndentity: tempGuid, HospitalID: GLOBAL.HospitalID };
									$cm({
										ClassName: 'NurMp.KnowledgeCategory',
										MethodName: 'save',
										parr: JSON.stringify(json)
									}, function (result) {
										if (result.status == '0') {
											$.messager.popover({ msg: $g("添加成功！"), type: 'success', timeout: 1000 });
											$HUI.dialog('#dialogAddCate').close();
											$HUI.tree('#knowledgeCategoryTree', 'reload');
											return;
										} else {
											$.messager.popover({ msg: result.msg, type: 'error', timeout: 1000 });
											return;
										}
									});
								} else {
									$.messager.popover({ msg: $g('获取栏目Guid失败！'), type: 'error', timeout: 1000 });
									return;
								}
							});
						} else {
							$.messager.popover({ msg: $g('获取目录Guid失败！'), type: 'error', timeout: 1000 });
							return;
						}
					});
				}
			}, {
				text: '取消',
				handler: function () {
					$HUI.dialog('#dialogAddCate').close();
				}
			}],
			onOpen: function () {
				$('#cateName').val('');
				$('#cateDesc').val('');
			}
		});
	}
	/**
		* @description:  删除
	*/
	function deleteNode() {
		var node = $('#knowledgeCategoryTree').tree('getSelected');
		if (!node) {
			$.messager.popover({
				msg: $g('请选择节点！'),
				type: 'info',
				timeout: 1000
			});
			return;
		}
		$.messager.confirm($g("提醒"), $g("确定要删除吗？"), function (r) {
			if (r) {
				$cm({
					ClassName: "NurMp.KnowledgeCategory",
					MethodName: "delete",
					indentity: node.guid,
					ip: '',
					hander: ''
				}, function (result) {
					if (result.status == '0') {
						$.messager.popover({
							msg: $g('删除成功! '),
							type: 'info',
							timeout: 1000
						});
						$HUI.tree('#knowledgeCategoryTree', 'reload');
						initContentElement('');
					} else {
						$.messager.popover({
							msg: $g('删除失败! ' + result.msg),
							type: 'error',
							timeout: 1000
						});
					}
				});
			} else {
				return;
			}
		});
	}
	/**
		* @description:  属性
	*/
	function editProperty() {
		var node = $('#knowledgeCategoryTree').tree('getSelected');
		if (!node) {
			$.messager.popover({
				msg: $g('请选择节点！'),
				type: 'info',
				timeout: 1000
			});
			return;
		}
		dialogShow(node);
	}
	/**
		* @description:  删除元素
	*/
	function deleteElement() {
		var node = $('#elementTree').tree('getSelected');
		if (!node) {
			$.messager.popover({
				msg: $g('请选择元素！'),
				type: 'info',
				timeout: 1000
			});
			return;
		}
		$.messager.confirm($g("提醒"), $g("确定要删除该元素吗？"), function (r) {
			if (r) {
				$('#' + node.id).parent().remove();
				resetNodeData(node.id);
				delete GLOBAL.NodeData[node.id];
				GLOBAL.EditElementID = '';
				clearSource();
				$('#kw').empty();
				saveData();
				initContentPanel();
			}
		});
	}
	/**
		* @description:  移动
	*/
	function moveNode(direction) {
		var node = $('#knowledgeCategoryTree').tree('getSelected');
		if (!node) {
			$.messager.popover({
				msg: $g('请选择节点！'),
				type: 'info',
				timeout: 1000
			});
			return;
		}
		$m({
			ClassName: "NurMp.KnowledgeCategory",
			MethodName: "changeOrderNumber",
			indentity: node.guid,
			direction: direction,
		}, function (result) {
			if (result == '1') {
				$HUI.tree('#knowledgeCategoryTree', 'reload');
				initContentElement('');
			} else if (result == '0') {
				$.messager.popover({
					msg: $g('移动失败! '),
					type: 'error',
					timeout: 1000
				});
			} else {
				$.messager.popover({
					msg: result,
					type: 'alert',
					timeout: 1000
				});
			}
		});
	}
	/**
		* @description:  加载知识库整体内容
	*/
	function loadKnowData(node) {
		$cm({
			ClassName: "NurMp.Service.Refer.Handle",
			MethodName: "getContent",
			KnowledgeID: node.id
		}, function (content) {
			$('#contentPanel').empty();
			if (content.length > 0) {
				GLOBAL.NodeData = {};  //深层复制
				var arrElement = [];
				$.each(content, function (i, c) {
					var eleItem = loadHtmlDom(i, c, arrElement);
				});
			} else {
				$('#elementTree').empty();
			}
			GLOBAL.ElementNew = '';
		});
	}

	/**
	 * @description: 加载dom元素
	 * @param {object} c
	 * @return {string} html
	 */
	function loadHtmlDom(i, c, arrElement) {
		var eleHtml = '';
		var strRefTo = '';
		if ((typeof c.refTo != "undefined") && (c.refTo.length > 0)) {
			$.each(c.refTo, function (index, ref) {
				strRefTo = !!strRefTo ? strRefTo + "," + ref.Text : ref.Text;
			});
		}
		if (c.type == 'O') {
			var elementO = { id: c.id, text: c.type + ' ' + c.title, data: c };
			arrElement.push(elementO);
			eleHtml = "<span style='background-color:#509de1;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;' refFrom='" + c.refFrom + "' refTo='" + strRefTo + "'>" + c.title + "</a></span>";
		} else if (c.type == 'M') {
			var elementM = { id: c.id, text: c.type + ' ' + c.title, data: c };
			arrElement.push(elementM);
			eleHtml = "<span style='background-color:#EE7942;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;' refFrom='" + c.refFrom + "' refTo='" + strRefTo + "'>" + c.title + "</a></span>";
		} else if (c.type == 'D') {
			var elementD = { id: c.id, text: c.type + ' ' + c.title, data: c };
			arrElement.push(elementD);
			eleHtml = "<span style='background-color:#4EEE94;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;' refFrom='" + c.refFrom + "' refTo='" + strRefTo + "'>" + c.title + "</a></span>";
		} else if (c.type == 'N') {
			var elementN = { id: c.id, text: c.type + ' ' + c.title, data: c };
			arrElement.push(elementN);
			eleHtml = "<span style='background-color:#8552a1;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;' refFrom='" + c.refFrom + "' refTo='" + strRefTo + "'>" + c.title + "</a></span>";
		} else if (c.type == 'I') {
			var elementI = { id: c.id, text: c.type + ' ' + c.title, data: c };
		} else {
			var reg = new RegExp('\r\n', 'g');
			eleText = c.title.toString().replace(reg, "<br>");
			var elementT = { id: c.id, text: 'A ' + c.title, data: c };
			arrElement.push(elementT);
			var eleWidth = getTextLength(c.title) * 6.5 + "px";
			eleHtml = "<span style='text-decoration:underline;width:" + eleWidth + ";'><a href='javascript:void(0);' id=" + c.id + " style='color:black;margin:0 4px;' refFrom='" + c.refFrom + "' refTo='" + strRefTo + "'>" + c.title + "</a></span>";
		}
		GLOBAL.NodeData[c.id] = c;
		GLOBAL.NodeData[c.id].sort = i;

		if (!!eleHtml) {
			$('#contentPanel').append($(eleHtml));
		}

		$.parser.parse('#contentPanel');

		$('#' + c.id).bind('click', {
			index: i,
			id: c.id,
			type: c.type,
			title: c.title,
			sourceData: c.sourceData,
			dateFlag: c.dateFlag,
			timeFlag: c.timeFlag,
			dsRef: c.dsRef || '',
			dsName: c.dsName || ''
		}, eleClickHandler);
		$('#menuElement').empty();
		$('#menuElement').menu('appendItem', {
			id: 'deleteElement',
			text: '删除',
			iconCls: 'icon-cancel',
			handler: deleteElement
		});
		//把元素转为树
		$('#elementTree').tree({
			data: arrElement,
			autoNodeHeight: true,
			lines: true,
			onClick: eleClickHandler,
			onContextMenu: function (e, node) {
				e.preventDefault();
				$('#elementTree').tree('select', node.target);
				$('#menuElement').menu('show', {
					left: e.pageX,
					top: e.pageY
				});
			}
		});
		if (!!GLOBAL.EditElementID) {
			var editId = "";
			$.each(GLOBAL.ArrData, function (index, data) {
				if (data.id == GLOBAL.EditElementID) {
					var editNo = index + 1;
					editId = data.type + editNo;
				}
			});
			if (!!editId) {
				var n = $('#elementTree').tree('find', editId);
				if ((!!n) && (typeof n != "undefined")) {
					$('#elementTree').tree('select', n.target);
				}
			}
		}
	}

	/**
	 * @description: 初始化内容
	 */
	function initContentPanel() {
		$('#editPanel').panel('setTitle', '');
		$('#tableEdit').hide();
	}
	/**
	 * @description: 初始化内容元素
	 */
	function initContentElement(e) {
		if (!e) {
			$('#elementTree').empty();
			$('#contentPanel').empty();
			$('#editPanel').panel('setTitle', '');
			$('#txtName').val('');
			$('#txtItem').val('');
			$('#txtDefaultVal').val('');
			$('#txtNumber').numberbox('clear');
			$('#tableEdit').hide();
			return;
		}
		$('#tableEdit').show();
		$('#txtName').val('');
		$('#txtItem').val('');
		$('#txtDefaultVal').val('');
		$('#txtNumber').numberbox('clear');
		if (e.data.type == 'FreeText') {
			$('#editPanel').panel('setTitle', '文本');
			$('#trFirst').hide();
			$('#divArea').show();
			$('#divDatetime').hide();
			$('#trLast').hide();
			$('#divNumber').hide();
			$('#txtNumber').hide();
		} else if (e.data.type == 'N') {
			$('#editPanel').panel('setTitle', '数值');
			$('#trFirst').show();
			$('#divArea').hide();
			$('#divDatetime').hide();
			$('#trLast').hide();
			$('#divNumber').show();
			$('#txtNumber').show();
		} else if (e.data.type == 'D') {
			var date = new Date();
			$('#date').datebox('setValue', 'Today');
			$('#time').timespinner('setValue', date.getHours() + ':' + date.getMinutes());
			$('#cbDate').checkbox('setValue', true);
			$('#cbTime').checkbox('setValue', true);
			$('#editPanel').panel('setTitle', '日期时间');
			$('#trFirst').show();
			$('#divArea').hide();
			$('#divDatetime').show();
			$('#trLast').hide();
			$('#divNumber').hide();
			$('#txtNumber').hide();
		} else {
			if (e.data.type == 'O') {
				$('#editPanel').panel('setTitle', '下拉');
			}
			if (e.data.type == 'M') {
				$('#editPanel').panel('setTitle', '多选');
			}
			$('#trFirst').show();
			$('#divArea').show();
			$('#divDatetime').hide();
			$('#divNumber').hide();
			$('#trLast').show();
			$('#txtNumber').hide();
		}
	}
	/**
	 * @description: 选中知识库内容
	 */
	function eleClickHandler(e) {
		if (!!GLOBAL.ElementNew) {
			$.messager.popover({ msg: $g('有未保存的元素！'), type: 'info', timeout: 1000 });
			return;
		}
		GLOBAL.EditElementID = e.data.id;
		$('#tableEdit').show();
		$('#txtName').val('');
		$('#txtItem').val('');
		if (e.data.type == 'FreeText') {
			$('#editPanel').panel('setTitle', '文本');
			$('#trFirst').hide();
			$('#divArea').show();
			$('#divDatetime').hide();
			$('#trLast').hide();
			$('#txtNumber').hide();
		} else if (e.data.type == 'D') {
			$('#editPanel').panel('setTitle', '日期时间');
			$('#trFirst').show();
			$('#divArea').hide();
			$('#divDatetime').show();
			$('#trLast').hide();
			$('#txtNumber').hide();
		} else if (e.data.type == 'N') {
			$('#editPanel').panel('setTitle', '数值');
			$('#trFirst').show();
			$('#divArea').hide();
			$('#divDatetime').hide();
			$('#trLast').hide();
			$('#divNumber').show();
			$('#txtNumber').show();
		} else {
			if (e.data.type == 'O') {
				$('#editPanel').panel('setTitle', '下拉');
			}
			if (e.data.type == 'M') {
				$('#editPanel').panel('setTitle', '多选');
			}
			$('#trFirst').show();
			$('#divArea').show();
			$('#divDatetime').hide();
			$('#trLast').show();
			$('#txtNumber').hide();
		}
		if (e.data.type == 'FreeText') {
			$('#txtItem').val(e.data.title);

		} else if (e.data.type == 'D') {
			$('#txtName').val(e.data.title);
			var datetimeArr = e.data.sourceData.split(/\s/);
			var dateFlag = e.data.dateFlag == 'Y' ? true : false;
			var timeFlag = e.data.timeFlag == 'Y' ? true : false;
			$('#date').datebox('setValue', datetimeArr[0].replace(/\//g, "-"));
			$('#time').timespinner('setValue', datetimeArr[1]);
			$('#cbDate').checkbox('setValue', dateFlag);
			$('#cbTime').checkbox('setValue', timeFlag);
		} else if (e.data.type == 'N') {
			$('#txtName').val(e.data.title);
//			$('#txtNumber').val(e.data.sourceData);
			$('#txtNumber').numberbox('setValue', e.data.sourceData);
		} else {
			$('#txtName').val(e.data.title);
			if ($.isPlainObject(e.data.sourceData)) {
				var itemStr = '';
				var valStr = '';
				$.each(e.data.sourceData.source, function (index, data) {
					itemStr = !!itemStr ? itemStr + '\r' + data.Text : data.Text;
				});
				$('#txtItem').val(itemStr);
				$.each(e.data.sourceData.values, function (index, data) {
					valStr = !!valStr ? valStr + ',' + data.Text : data.Text;
				});
				$('#txtDefaultVal').val(valStr);
			}
		}

		GLOBAL.EditElementID = e.data.id;

		var n = $('#elementTree').tree('find', e.data.id);
		$('#elementTree').tree('select', n.target);

		GLOBAL.ArrData = [];
		for (var key in GLOBAL.NodeData) {
			GLOBAL.ArrData.push(GLOBAL.NodeData[key]);
		}
		GLOBAL.ArrData.sort(function (a, b) {
			return a.sort - b.sort;
		});

		if (e.data.type == "FreeText") {
			$("#referPanel").hide();
			$('#propertyLayout').layout('panel', 'west').panel('resize', { width: $('#contentlayout').layout('panel', 'center').width() });
			$('#propertyLayout').layout('resize');
			return;
		} else {
			$("#referPanel").show();
			$('#propertyLayout').layout('panel', 'west').panel('resize', { width: 500 });
			$('#propertyLayout').layout('resize');
		}

		//数据源
		var dsRef = '', dsName = '';
		if ((!!e.data.dsRef) && (!!e.data.dsName)) {
			dsRef = e.data.dsRef;
			dsName = e.data.dsName;
		}
		$('#txtSource').val(dsName);
		$('#sourceCode').val(dsRef);

		//关联项
		var kwArr = [];
		var refTo = GLOBAL.NodeData[GLOBAL.EditElementID].refTo;
		$.each(GLOBAL.ArrData, function (index, item) {
			if (item.type == "FreeText") {
				var isSelected = false;
				$.each(refTo, function (refIndex, refItem) {
					if (refItem.Text == item.refFrom) {
						isSelected = true;
						return false;
					}
				});
				kwArr.push({ text: item.title, id: item.refFrom, selected: isSelected });
			}
		});

		$("#kw").keywords({
			items: kwArr,
			onUnselect: function (v) {
				removeAaary(GLOBAL.NodeData[GLOBAL.EditElementID].refTo, v.id);
			},
			onSelect: function (v) {
				GLOBAL.NodeData[GLOBAL.EditElementID].refTo.push({ Text: v.id, Value: (refTo.length + 1) });
			},
		});
	}
	/*删除数组中的某一个对象
	_arr:数组
	_obj:需删除的对象
	*/
	function removeAaary(_arr, value) {
		var length = _arr.length;
		for (var i = 0; i < length; i++) {
			if (_arr[i].Text == value) {
				if (i == 0) {
					_arr.shift(); //删除并返回数组的第一个元素
					return _arr;
				}
				else if (i == length - 1) {
					_arr.pop();  //删除并返回数组的最后一个元素
					return _arr;
				}
				else {
					_arr.splice(i, 1); //删除下标为i的元素
					return _arr;
				}
			}
		}
	}
	/**
	 * @description: 添加元素
	 */
	function addElement(e) {
		var selNode = $('#knowledgeCategoryTree').tree('getSelected');
		if ((!selNode) || (selNode.length == 0)) {
			$.messager.popover({ msg: $g('请选择内容节点!'), type: 'info', timeout: 1000 });
			return;
		}
		if (selNode.iconCls != 'icon-paper-info') {
			$.messager.popover({ msg: $g('请在内容节点下添加元素!'), type: 'info', timeout: 1000 });
			return;
		}
		if (!GLOBAL.EditElementID) {
			if (!($.isEmptyObject(GLOBAL.NodeData))) {
				$.messager.popover({ msg: $g('请选择要添加元素的位置！'), type: 'info', timeout: 1000 });
				return;
			}
		}
		if (!!GLOBAL.EditElementID) {
			var eleTitle = GLOBAL.NodeData[GLOBAL.EditElementID].title;
			if (eleTitle == $g("新建文本") || eleTitle == $g("新建下拉") || eleTitle == $g("新建多选") || eleTitle == $g("新建日期") || eleTitle == $g("新建数值")) {
				$.messager.popover({ msg: $g('有未编辑或未保存的元素！'), type: 'info', timeout: 1000 });
				return;
			}
		}
		initContentElement(e);
		clearSource();
		$('#kw').empty();
		if (e.data.type == "FreeText") {
			$("#referPanel").hide();
			$('#propertyLayout').layout('panel', 'west').panel('resize', { width: $('#contentlayout').layout('panel', 'center').width() });
			$('#propertyLayout').layout('resize');
		} else {
			$("#referPanel").show();
			$('#propertyLayout').layout('panel', 'west').panel('resize', { width: 500 });
			$('#propertyLayout').layout('resize');
		}
		if (e.data.type == 'FreeText') {
			var span = document.createElement("span");
			span.style = "text-decoration:underline;width:20px;";
			var a = document.createElement("a");
			a.href = "javascript:void(0);";
			a.id = getLastEleId(GLOBAL.EditElementID, e.data.type);
			a.style = "color:black;margin:0 4px;";
			var text = document.createTextNode($g('新建文本'));
			a.appendChild(text);
			span.appendChild(a);
			insertAfter(span, GLOBAL.EditElementID);
			var eleSort = 101;
			if (!!GLOBAL.EditElementID) {
				eleSort = GLOBAL.NodeData[GLOBAL.EditElementID].sort + 1;
			}
			GLOBAL.NodeData[a.id] = { id: a.id, title: $g('新建文本'), type: e.data.type, sort: eleSort };
			GLOBAL.EditElementID = a.id;
			GLOBAL.ElementNew = $g('新建文本');
		} else if (e.data.type == 'O') {
			var span = document.createElement("span");
			span.style = "background-color:#509de1;border:1px dotted black";
			var a = document.createElement("a");
			a.href = "javascript:void(0);";
			a.id = getLastEleId(GLOBAL.EditElementID, e.data.type);
			a.style = "color:white;";
			var text = document.createTextNode($g('新建下拉'));
			a.appendChild(text);
			span.appendChild(a);
			insertAfter(span, GLOBAL.EditElementID);
			var eleSort = 101;
			if (!!GLOBAL.EditElementID) {
				eleSort = GLOBAL.NodeData[GLOBAL.EditElementID].sort + 1;
			}
			GLOBAL.NodeData[a.id] = { id: a.id, data: new Array(), sourceData: new Object(), defaultVal: '', title: $g('新建下拉'), type: e.data.type, sort: eleSort };
			GLOBAL.EditElementID = a.id;
			GLOBAL.ElementNew = $g('新建下拉');
		} else if (e.data.type == 'M') {
			var span = document.createElement("span");
			span.style = "background-color:#EE7942;border:1px dotted black";
			var a = document.createElement("a");
			a.href = "javascript:void(0);";
			a.id = getLastEleId(GLOBAL.EditElementID, e.data.type);
			a.style = "color:white;";
			var text = document.createTextNode($g('新建多选'));
			a.appendChild(text);
			span.appendChild(a);
			insertAfter(span, GLOBAL.EditElementID);
			var eleSort = 101;
			if (!!GLOBAL.EditElementID) {
				eleSort = GLOBAL.NodeData[GLOBAL.EditElementID].sort + 1;
			}
			GLOBAL.NodeData[a.id] = { id: a.id, data: new Array(), sourceData: new Object(), defaultVal: '', title: $g('新建多选'), type: e.data.type, sort: eleSort };
			GLOBAL.EditElementID = a.id;
			GLOBAL.ElementNew = $g('新建多选');
		} else if (e.data.type == 'D') {
			var span = document.createElement("span");
			span.style = "background-color:#4EEE94;border:1px dotted black";
			var a = document.createElement("a");
			a.href = "javascript:void(0);";
			a.id = getLastEleId(GLOBAL.EditElementID, e.data.type);
			a.style = "color:white;";
			var text = document.createTextNode($g('新建时间'));
			a.appendChild(text);
			span.appendChild(a);
			insertAfter(span, GLOBAL.EditElementID);
			var eleSort = 101;
			if (!!GLOBAL.EditElementID) {
				eleSort = GLOBAL.NodeData[GLOBAL.EditElementID].sort + 1;
			}
			GLOBAL.NodeData[a.id] = { dateFlag: 'Y', timeFlag: 'Y', id: a.id, sourceData: '', defaultVal: '', title: $g('新建时间'), type: e.data.type, sort: eleSort };
			GLOBAL.EditElementID = a.id;
			GLOBAL.ElementNew = $g('新建时间');
		} else if (e.data.type == 'N') {
			var span = document.createElement("span");
			span.style = "background-color:#8552a1;border:1px dotted black";
			var a = document.createElement("a");
			a.href = "javascript:void(0);";
			a.id = getLastEleId(GLOBAL.EditElementID, e.data.type);
			a.style = "color:white;";
			var text = document.createTextNode($g('新建数值'));
			a.appendChild(text);
			span.appendChild(a);
			insertAfter(span, GLOBAL.EditElementID);
			var eleSort = 101;
			if (!!GLOBAL.EditElementID) {
				eleSort = GLOBAL.NodeData[GLOBAL.EditElementID].sort + 1;
			}
			GLOBAL.NodeData[a.id] = { id: a.id, data: new Array(), sourceData: '', defaultVal: '', title: $g('新建数值'), type: e.data.type, sort: eleSort };
			GLOBAL.EditElementID = a.id;
			GLOBAL.ElementNew = $g('新建数值');
		} else {

		}
	}
	/**
	 * @description: 添加元素后重置id和顺序
	 */
	function getLastEleId(currentId, type) {
		if (!currentId) currentId = type + '1';
		if ($.isEmptyObject(GLOBAL.NodeData)) return type + '1';
		if (typeof GLOBAL.NodeData[currentId] == 'undefined') return type + '1';
		var count = 0;
		var currentSeq = GLOBAL.NodeData[currentId].sort;
		$.each(GLOBAL.NodeData, function (index, node) {
			var nodeId = node.id;
			var seq = node.sort;
			var nodeType = node.type;
			if (nodeType == type) {
				count++;
			}
			if (seq > currentSeq) {
				GLOBAL.NodeData[nodeId].sort = seq + 1;
			}
		});
		count = count + 1;

		return type + '' + count;
	}
	/**
	 * @description: 删除元素后重置id和顺序
	 */
	function resetNodeData(currentId) {
		var currentSeq = GLOBAL.NodeData[currentId].sort;
		$.each(GLOBAL.NodeData, function (index, node) {
			var nodeId = node.id;
			var seq = node.sort;
			if (seq > currentSeq) {
				GLOBAL.NodeData[nodeId].sort = seq - 1;
			}
		});
	}
	/**
		* @description:  获取字符串像素长度
	*/
	function getTextLength(text) {
		return text.toString().replace(/[\u0391-\uFFE5]/g, "aa").length;  //先把中文替换成两个字节的英文，再计算长度
	}
	/**
	 * @description: 绑定数据源
	 */
	function bindSource() {
		if (!GLOBAL.EditElementID) {
			$.messager.alert($g('提示'), $g('请选择元素！'));
			return;
		}
		$HUI.dialog('#dialogSource', {
			title: '绑定数据源',
			width: 500,
			height: 680,
			resizable: false,
			modal: true,
			buttons: [{
				text: '确定',
				handler: fetchNode
			}, {
				text: '取消',
				handler: function () {
					$HUI.dialog('#dialogSource').close();
				}
			}],
			onOpen: openSourceWin
		});
		$('#dialogSource').dialog('open');
	}
	/**
	 * @description: 获取父级节点
	 */
	function fetchNode() {
		var tabIndex = 0;
		var arrNode = new Array();
		var currentTab = $('#tabSource').tabs('getSelected');
		if (!!currentTab) {
			tabIndex = $('#tabSource').tabs('getTabIndex', currentTab);
		}
		var treeId = tabIndex == 1 ? 'inTree' : 'outTree';
		var node = $('#' + treeId).tree('getSelected');
		if (!node) {
			$.messager.alert($g('提示'), $g('请选择数据源的节点！'));
			return;
		}
		if (parseInt(node.depth) < 4) {
			$.messager.alert($g('提示'), $g('请选择正确的节点！'));
			return;
		}
		var methodCode = null;
		var currentNode = node;
		do {
			arrNode.push(currentNode.text);
			if (currentNode.depth == 3) {
				methodCode = currentNode.id;
			}
			currentNode = $('#' + treeId).tree('getParent', currentNode.target);
		} while (!!currentNode)
		var sourceDesc = arrNode.reverse().join('-');
		if (!!methodCode) {
			var sourceType = tabIndex == 1 ? 'inside' : 'outside';
			var sourceCode = sourceType + ',$' + methodCode + ',$' + methodCode + '!' + node.id;
			if (sourceType == 'inside') {
				sourceCode = sourceType + ',' + node.id + ',' + node.bindID;
			}
			$('#txtSource').val(sourceDesc);
			$('#sourceCode').val(sourceCode);
		}
		$HUI.dialog('#dialogSource').close();
	}
	/**
	 * @description: 初始化数据源窗口
	 */
	function openSourceWin() {
		initSourceTree('outTree', 'outside');
		initSourceTree('inTree', 'inside');
	}
	/**
	 * @description: 初始化数据源树
	 * @param {string} treeId, flag
	 */
	function initSourceTree(treeId, flag) {
		$('#' + treeId).tree({
			loader: function (param, success, error) {
				$cm({
					ClassName: 'NurMp.Service.Refer.Handle',
					MethodName: 'GetDataSource',
					Flag: flag,
					HospitalID: GLOBAL.HospitalID
				}, function (data) {
					success(data);
				});
			},
			lines: true,
			onLoadSuccess: function(data) {
				var tabIndex = 0;
				var currentTab = $('#tabSource').tabs('getSelected');
				if (!!currentTab) {
					tabIndex = $('#tabSource').tabs('getTabIndex', currentTab);
				}
				var currentNodeId = $('#sourceCode').val().split('!')[1];
				if (tabIndex == 1) {
					currentNodeId = $('#sourceCode').val().split(',')[1];
				}
				if (!!currentNodeId) {
					var targetNode = $(this).tree('find',currentNodeId);
					if (targetNode) {
						$(this).tree('select',targetNode.target);
					}
				}
			}
		});
	}
	function clearSource() {
		$('#txtSource').val('');
		$('#sourceCode').val('');
	}
	/**
		* @description:  临时存储数据
	*/
	function updateData() {
		var dsRef = $('#sourceCode').val();
		var dsName = $('#txtSource').val();
		if (GLOBAL.EditElementID.indexOf('FreeText') > -1) {
			var newItem = $('#txtItem').val();
			GLOBAL.NodeData[GLOBAL.EditElementID].title = newItem;
		} else if ((GLOBAL.EditElementID.indexOf('O') > -1) || (GLOBAL.EditElementID.indexOf('M') > -1)) {
			var newTitle = $('#txtName').val();
			var newItemArr = $('#txtItem').val().split(/[\s\n]/);
			var newDefaultArr = $('#txtDefaultVal').val().split(',');
			var newDataArr = [];
			$.each(newItemArr, function (index, item) {
				var objItem = { Value: index, Text: item };
				newDataArr.push(objItem);
			});
			var newValueArr = [];
			$.each(newDefaultArr, function (index, item) {
				var objValue = { Value: index, Text: item };
				newValueArr.push(objValue);
			});
			GLOBAL.NodeData[GLOBAL.EditElementID].title = newTitle;
			GLOBAL.NodeData[GLOBAL.EditElementID].sourceData.source = newDataArr;
			GLOBAL.NodeData[GLOBAL.EditElementID].sourceData.values = newValueArr;
			GLOBAL.NodeData[GLOBAL.EditElementID].dsRef = dsRef;
			GLOBAL.NodeData[GLOBAL.EditElementID].dsName = dsName;
		} else if (GLOBAL.EditElementID.indexOf('D') > -1) {
			var newTitle = $('#txtName').val();
			var newDate = $('#date').datebox('getValue').replace(/-/g, "/");
			var newTime = $('#time').timespinner('getValue');
			var newDateFlag = $('#cbDate').checkbox('getValue');
			var newTimeFlag = $('#cbTime').checkbox('getValue');
			GLOBAL.NodeData[GLOBAL.EditElementID].title = newTitle;
			GLOBAL.NodeData[GLOBAL.EditElementID].sourceData = newDate + " " + newTime;
			GLOBAL.NodeData[GLOBAL.EditElementID].defaultVal = newDate + " " + newTime;
			GLOBAL.NodeData[GLOBAL.EditElementID].dateFlag = newDateFlag ? "Y" : "N";
			GLOBAL.NodeData[GLOBAL.EditElementID].timeFlag = newTimeFlag ? "Y" : "N";
			GLOBAL.NodeData[GLOBAL.EditElementID].dsRef = dsRef;
			GLOBAL.NodeData[GLOBAL.EditElementID].dsName = dsName;
		} else if (GLOBAL.EditElementID.indexOf('N') > -1) {
			var newTitle = $('#txtName').val();
			var number = $('#txtNumber').numberbox('getValue');
			if (!newTitle) {
				$.messager.popover({ msg: $g('请填写名称！'), type: 'error', timeout: 800 });
				return $g('请填写名称！');
			}
			GLOBAL.NodeData[GLOBAL.EditElementID].title = newTitle;
			GLOBAL.NodeData[GLOBAL.EditElementID].sourceData = number;
			GLOBAL.NodeData[GLOBAL.EditElementID].defaultVal = number;
			GLOBAL.NodeData[GLOBAL.EditElementID].dsRef = dsRef;
			GLOBAL.NodeData[GLOBAL.EditElementID].dsName = dsName;
		}
		return '';
	}

	/**
		* @description:  更新并保存数据
	*/
	function saveData() {
		GLOBAL.ArrData = [];
		var upDataMsg = updateData();
		if (!!upDataMsg) {
			$.messager.popover({ msg: upDataMsg, type: 'error', timeout: 800 });
			return;
		}
		for (var key in GLOBAL.NodeData) {
			GLOBAL.ArrData.push(GLOBAL.NodeData[key]);
		}
		GLOBAL.ArrData.sort(function (a, b) {
			return a.sort - b.sort;
		});
		var arrLen = GLOBAL.ArrData.length;
		var nullTitle = false;
		var nullContent = false;
		var preType = "";
		var numF=1;
		xmlContent = '<Root><InstanceData IDNO="1">';
		$.each(GLOBAL.ArrData, function (index, data) {
			if (data.type == "FreeText") {
				if (!data.title) {
					nullContent = true;
				}
				var reg = new RegExp('\r\n', 'g');
				var titleData = data.title.toString().replace(reg, '\n');
				reg = new RegExp('\n', 'g');
				titleData = titleData.replace(reg, '&amp;KeyEnter;');
				reg = new RegExp(' ', 'g');
				titleData = titleData.replace(reg, '&amp;nbsp;');
				var refFrom = data.refFrom;
				if (preType == data.type) {
					var nodeName = "I" + index;
					xmlContent += '<' + nodeName + ' Title="' + nodeName + '"><Itms /><RefItms /></' + nodeName + '>'
				}
				if (index == arrLen - 1) {
					if (index == 0) {
						title = '';
					} else {
						title = GLOBAL.ArrData[index - 1].id;
					}
				} else {
					if (index == 0) {
						title = GLOBAL.ArrData[index + 1].id;
					} else {
						title = GLOBAL.ArrData[index - 1].id + GLOBAL.ArrData[index + 1].id;
					}
				}
				xmlContent += '<FreeText Title="' + title + '">' + titleData + '</FreeText>';
				numF += 1;
			} else {
				if ((!data.title) && (data.type != 'I')) {
					nullTitle = true;
				}
				var defaultValue = data.sourceData;
				if (data.type == 'D') {
					if (data.sourceData.indexOf(' ') > -1) {
						var dateValue = data.sourceData.split(' ')[0];
						var timeValue = data.sourceData.split(' ')[1]
						defaultValue = changeDateFormat(dateValue) + ' ' + timeValue;
					}
				} else if ((data.type == 'O') || (data.type == 'M')) {
					var valueStr = '';
					$.each(data.sourceData.values, function (i, v) {
						valueStr = !!valueStr ? valueStr + ',' + v.Text : v.Text;
					});
					defaultValue = valueStr;
				}
				if (typeof defaultValue == 'undefined') {
					debugger;
				}
				xmlContent += '<' + data.id + ' Title="' + data.title + '" Value="' + defaultValue + '"';
				if (typeof data.dateFlag != 'undefined') {
					xmlContent += ' DateFlag="' + data.dateFlag + '"';
				}
				if (typeof data.timeFlag != 'undefined') {
					xmlContent += ' TimeFlag="' + data.timeFlag + '"';
				}
				xmlContent += '>'
				if ((data.type == 'O') || (data.type == 'M')) {
					if (typeof data.sourceData != 'undefined') {
						if (data.sourceData.source.length == 0) {
							nullContent = true;
						}
						xmlContent += '<Itms>';
						$.each(data.sourceData.source, function (subI, subData) {
							xmlContent += '<Itm>' + subData.Text + '</Itm>';
						});
						xmlContent += '</Itms>';
					} else {
						xmlContent += '<Itms />';
					}
				} else {
					xmlContent += '<Itms />';
				}
				if ((data.type == 'O') || (data.type == 'M') || (data.type == 'D')) {
					if (!!data.refTo) {
						xmlContent += '<RefItms>';
						$.each(data.refTo, function (index, refItem) {
							xmlContent += '<RefItm>' + refItem.Text + '</RefItm>';
						});
						xmlContent += '</RefItms>';
					} else {
						xmlContent += '<RefItms />';
					}
				} else {
					xmlContent += '<RefItms />';
				}
				if ((data.type == 'O') || (data.type == 'M') || (data.type == 'D') || (data.type == 'N')) {
					if (!!data.dsRef) {
						xmlContent += '<DataSourceRef>' + data.dsRef + '</DataSourceRef>';
					}
					if (!!data.dsName) {
						xmlContent += '<DataSourceRefInfo>' + data.dsName + '</DataSourceRefInfo>';
					}
				}
				xmlContent += '</' + data.id + '>';
			}
			preType = data.type;
		});

		xmlContent += '</InstanceData></Root>';

		if (nullTitle) {
			$.messager.popover({ msg: $g('请输入名称!'), type: 'error', timeout: 800 });
			return;
		}
		if (nullContent) {
			$.messager.popover({ msg: $g('请输入内容!'), type: 'error', timeout: 800 });
			return;
		}
		console.log(xmlContent);

		$cm({
			ClassName: "NurMp.Service.Refer.Handle",
			MethodName: "Save",
			KCIndentity: GLOBAL.TemplateID,
			XmlContent: xmlContent,
			HospitalID: GLOBAL.HospitalID
		}, function (result) {
			if (result.status == '0') {
				$.messager.popover({
					msg: $g('保存成功！'),
					type: 'success',
					style: {
						bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10, //显示到右下角
						right: 10
					},
					timeout: 500
				});
				var selNode = $('#elementTree').tree('getSelected');
				if (!!selNode) {
					//GLOBAL.EditElementID = $('#elementTree').tree('getSelected').id;
				}
				var node = $('#knowledgeCategoryTree').tree('getSelected');
				if (!!node) {
					loadKnowData(node);
				}
			} else {
				$.messager.popover({
					msg: $g('保存失败！'),
					type: 'error',
					style: {
						bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10, //显示到右下角
						right: 10
					},
					timeout: 1000
				});
			}
		});
	}

	/**
		* @description:  在某个元素后边添加元素
	*/
	function insertAfter(newElement, oriElementID) {
		if (!!oriElementID) {
			var targetElement = $('#' + oriElementID).parent()[0];
			var parent = targetElement.parentNode;
			if (parent.lastChild == targetElement) {
				parent.appendChild(newElement);
			} else {
				parent.insertBefore(newElement, targetElement.nextSibling);
			}
		} else {
			$('#contentPanel').append(newElement);
		}
	}
	/**
		* @description:  日期格式变换
	*/
	function changeDateFormat(date) {
		var formatFlag = $m({
			ClassName: 'websys.Conversions',
			MethodName: 'DateFormat',
		}, false);
		var formatDate = date;
		if (formatDate.indexOf('/') > -1) {
			var dateArr = formatDate.split('/');
			if (formatFlag == '4') {
				formatDate = dateArr[2] + '/' + dateArr[1] + '/' + dateArr[0];
			} else if (formatFlag == '1') {
				formatDate = dateArr[2] + '/' + dateArr[0] + '/' + dateArr[1];
			}
		} else if (formatDate.indexOf('-') > -1) {
			var dateArr = formatDate.split('-');
			formatDate = dateArr[0] + '/' + dateArr[1] + '/' + dateArr[2];
		}
		return formatDate;
	}
	/**
		* @description:  监听事件
	*/
	function listenEvents() {
		$('#btnAddA').bind('click', { type: "FreeText" }, addElement);
		$('#btnAddO').bind('click', { type: "O" }, addElement);
		$('#btnAddM').bind('click', { type: "M" }, addElement);
		$('#btnAddD').bind('click', { type: "D" }, addElement);
		$('#btnAddN').bind('click', { type: "N" }, addElement);
		$('#btnSource').bind('click', bindSource);
		$('#btnClear').bind('click', clearSource);
		$('#btnSave').bind('click', saveData);
	}
	initUI();
});
