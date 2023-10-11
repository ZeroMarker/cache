/**
 * @author yaojining
 * @description ������
 */
$(function () {
	EpisodeID = isValidAdm(EpisodeID) ? EpisodeID : '';
	var GLOBAL = {
		SimpleFlag: $cm({
			ClassName: "NurMp.Service.Switch.Config",
			MethodName: "getDomValue",
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			DomID: "SimpleListFlag"
		}, false),
		ArrSort: new Object(),
		CurrState: new Object(),
		TranState: new Object(),
		CurrentModelId: null
	};

	/**
	* @description ��ʼ��UI
	*/
	function initUI() {
		initLayout();
		initSearchCondition();
		if (SinglePatient != '1') {
			initPatientTree();
		}
		if (HideBanner != '1') {
			setPatientInfo(EpisodeID)
		}
		initSavedTemplateTree();
		initTransTemplateTree();
		openDefaultRecord();
		listenEvents();
	}
	/**
	* @description �������ò���
	*/
	function initLayout() {
		if (SinglePatient != "1") {
			$m({
				ClassName: 'NurMp.Service.Switch.Config',
				MethodName: 'getDomValue',
				HospitalID: session['LOGON.HOSPID'],
				LocID: session['LOGON.CTLOCID'],
				DomID: 'PatListExpandFlag'
			}, function (expand) {
				if ((expand == 'true') && (!!EpisodeID)) {
					setTimeout(function () {
						$('#nrLayout').layout('collapse', 'west');
					}, 200);
				}
			});
		}
		$m({
			ClassName: 'NurMp.Service.Switch.Config',
			MethodName: 'getDomValue',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			DomID: 'TemplatePanelExpandFlag'
		}, function (expand) {
			if (expand == 'true') {
				setTimeout(function () {
					$('#modelLayout').layout('collapse', 'west');
				}, 300);
			}
		});
	}
	/**
	* @description ��ʼ����ѯ����
	*/
	function initSearchCondition() {
		if (SinglePatient != '1') {
			$('#wardPatientSearchBox').searchbox({
				searcher: function (value) {
					$HUI.tree('#patientTree', 'reload');
				}
			});

			// �������Ȩ�޿���ʱ��Ĭ����ʾ����
			if (groupFlag == "Y") $("#wardPatientCondition").switchbox("setValue", false);

			$('#wardPatientCondition').switchbox('options').onSwitchChange = function () {
				$HUI.tree('#patientTree', 'reload');
			};
		}
		if (ShowSearchDate == 1) {
			$('#startDate').datebox('setValue', 'Today');
			$('#endDate').datebox('setValue', 'Today');
		}
		$('#savedSearchBox').searchbox({
			searcher: function (value) {
				refreshTree();
			}
		});
		if (GLOBAL.SimpleFlag) {
			$('#btnMore').hide();
			$('#savedSearchBox').searchbox({
				width: 217
			});
		}
	}
	/**
	* @description: ��ʼ��menu
	*/
	function initMenu(node) {
		$('#menuTree').empty();
		$('#menuTree').menu('appendItem', {
			id: 'menuPlaceFile',
			text: $g('һ���鵵'),
			iconCls: 'icon-knw-submit',
			handler: function () {
				placeFile(node);
			}
		});
	}
	/**
	* @description: ��ʼ��ģ��menu
	*/
	function initMenuTemplate(node, id, text, iconCls, csp, urlParameter, width) {
		$('#menuTemplate').menu('appendItem', {
			id: id,
			text: text,
			iconCls: iconCls,
			handler: function () {
				var url = csp + '?EpisodeID=' + EpisodeID + '&Guid=' + node.id + urlParameter;
				var operationWin = websys_createWindow(url, text, "top=10,left=10,width=98%,height=90%,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
			}
		});
		if (!!width) {
			$('#menuTemplate').width(width);
		}
		
	}
	/**
	* @description ��ʼ��������
	*/
	function initPatientTree() {
		$HUI.tree('#patientTree', {
			loader: function (param, success, error) {
				var parameter = {
					EpisodeID: EpisodeID,
					WardID: session['LOGON.WARDID'],
					LocID: session['LOGON.CTLOCID'],
					GroupFlag: $('#wardPatientCondition').switchbox('getValue') == true ? 'N' : 'Y',
					BabyFlag: '',
					SearchInfo: $HUI.searchbox('#wardPatientSearchBox').getValue(),
					LangID: session['LOGON.LANGID'],
					UserID: session['LOGON.USERID'],
					StartDate: ShowSearchDate == 1 ? $('#startDate').datebox('getValue') : '',
					EndDate: ShowSearchDate == 1 ? $('#endDate').datebox('getValue') : ''
				};
				$cm({
					ClassName: 'NurMp.Service.Patient.List',
					MethodName: 'getPatients',
					Param: JSON.stringify(parameter)
				}, function (data) {
					var addIDAndText = function (node) {
						node.id = node.ID;
						node.text = node.label;
						if (node.id === EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.WardPatients.forEach(addIDAndText);
					GLOBAL.ArrSort = data.ArrSort;
					success(data.WardPatients);
				});
			},
			onLoadSuccess: function (node, data) {
				if (!!EpisodeID) {
					var selNode = $('#patientTree').tree('find', EpisodeID);
					if (!!selNode) {
						$('#patientTree').tree('select', selNode.target);
					}
				}
			},
			lines: true,
			onContextMenu: function (e, node) {
				var placeFileFlag = $cm({
					ClassName: 'NurMp.Service.Switch.Config',
					MethodName: 'getDomValue',
					HospitalID: session['LOGON.HOSPID'],
					LocID: session['LOGON.CTLOCID'],
					DomID: "PlaceFileFlag"
				}, false);
				if (placeFileFlag && node.visitStatus == 'D') {
					initMenu(node);
					e.preventDefault();
					$('#patientTree').tree('select', node.target);
					$('#menuTree').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				}
			},
			onClick: function (node) {
				if (!!node.episodeID) {
					var wordsPatInfo = node.name + '��' + node.sex + '��' + node.age;
					EpisodeID = node.episodeID;
					setPatientInfo(EpisodeID);
					refreshTree();
					passPatientToMenu(node);
					var currentTab = $('#recordTabs').tabs('getSelected');
					if (!!currentTab) {
						var iframe = $(currentTab.panel('options').content);
						var src = iframe.attr('src');
						var jsonUrl = serilizeURL(src);
						var editAuthority = AuthorityFlag;
						$m({
							ClassName: 'NurMp.Service.Template.Model',
							MethodName: 'editAuthority',
							EpisodeID: EpisodeID,
							LocID: session['LOGON.CTLOCID'],
							Key: jsonUrl["csp"]
						}, function (ifCanEidt) {
							if (ifCanEidt != '0') {
								$.messager.popover({ msg: ifCanEidt, type: 'error' });
								editAuthority = 2;
							}
							setTimeout(function () {
								if (jsonUrl["EpisodeID"] != EpisodeID) {
									var tabUrl = jsonUrl["csp"] + ".csp?EpisodeID=" + EpisodeID + "&AuthorityFlag=" + editAuthority + "&ModelId=" + jsonUrl["ModelId"];
									var frameId = "iframetab" + jsonUrl["emrcode"];
									var content = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + tabUrl + '"></iframe>';
									$('#recordTabs').tabs('update', {
										tab: currentTab,
										options: {
											content: content
										}
									});
								}
							}, 200);
						});
					}
				}
			}
		});
	}
	/**
	* @description ��ʼ���ⲿģ����
	*/
	function initSavedTemplateTree() {
		$HUI.tree('#savedTemplateTree', {
			loader: function (param, success, error) {
				$cm({
					ClassName: "NurMp.Service.Template.List",
					MethodName: "getTemplates",
					HospitalID: session['LOGON.HOSPID'],
					LocID: session['LOGON.CTLOCID'],
					EpisodeID: EpisodeID,
					RangeFlag: "S",
					SearchInfo: $HUI.searchbox('#savedSearchBox').getValue(),
					SimpleFlag: GLOBAL.SimpleFlag
				}, function (data) {
					var addIDAndText = function (node) {
						if (node.ifPrint === EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			},
			lines: true,
			onContextMenu: function (e, node) {
				rightClickMenu(e, node, 'savedTemplateTree');
			},
			onLoadSuccess: function (node, data) {
				if (!!GLOBAL.CurrentModelId) {
					var selNode = $('#savedTemplateTree').tree('find', GLOBAL.CurrentModelId);
					if (!!selNode) {
						$('#savedTemplateTree').tree('select', selNode.target);
					}
				}
				if (!$.isEmptyObject(GLOBAL.CurrState)) {
					$.each(GLOBAL.CurrState, function (id, state) {
						var selRoot = $('#savedTemplateTree').tree('find', id);
						if (selRoot) {
							if (state == 'open') {
								$('#savedTemplateTree').tree('expand', selRoot.target);
							} else {
								$('#savedTemplateTree').tree('collapse', selRoot.target);
							}
						}
					});
				}
			},
			onClick: function (node) {
				GLOBAL.CurrentModelId = node.id;
				openRecord(node);
				$(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);
			},
			onExpand: function (node) {
				GLOBAL.CurrState[node.id] = node.state;
			},
			onCollapse: function (node) {
				GLOBAL.CurrState[node.id] = node.state;
			}
		});
	}
	/**
	* @description ��ʼ��ת��ģ����
	*/
	function initTransTemplateTree() {
		$HUI.tree('#transTemplateTree', {
			loader: function (param, success, error) {
				$cm({
					ClassName: "NurMp.Service.Template.List",
					MethodName: "getTemplates",
					HospitalID: session['LOGON.HOSPID'],
					LocID: session['LOGON.CTLOCID'],
					EpisodeID: EpisodeID,
					RangeFlag: "S",
					SearchInfo: $HUI.searchbox('#savedSearchBox').getValue(),
					SimpleFlag: GLOBAL.SimpleFlag,
					TreeType: 'T'
				}, function (data) {
					var addIDAndText = function (node) {
						if (node.ifPrint === EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			},
			lines: true,
			onContextMenu: function (e, node) {
				rightClickMenu(e, node, 'transTemplateTree');
			},
			onLoadSuccess: function (node, data) {
				if (!!GLOBAL.CurrentModelId) {
					var selNode = $('#transTemplateTree').tree('find', GLOBAL.CurrentModelId);
					if (!!selNode) {
						$('#transTemplateTree').tree('select', selNode.target);
					}
				}
				if (!$.isEmptyObject(GLOBAL.TranState)) {
					$.each(GLOBAL.TranState, function (id, state) {
						var selRoot = $('#transTemplateTree').tree('find', id);
						if (selRoot) {
							if (state == 'open') {
								$('#transTemplateTree').tree('expand', selRoot.target);
							} else {
								$('#transTemplateTree').tree('collapse', selRoot.target);
							}
						}
					});
				}
			},
			onClick: function (node) {
				GLOBAL.CurrentModelId = node.id;
				openRecord(node);
				$(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);
			},
			onExpand: function (node) {
				GLOBAL.TranState[node.id] = node.state;
			},
			onCollapse: function (node) {
				GLOBAL.TranState[node.id] = node.state;
			}
		});
	}
	/**
	* @description ˢ��ģ����
	*/
	function refreshTree() {
		$HUI.tree('#savedTemplateTree', 'reload');
		$HUI.tree('#transTemplateTree', 'reload');
	}
	/**
	* @description ��ʼ������ģ����
	*/
	function initMoreWindow() {
		var tabConfig = $cm({
			ClassName: 'NurMp.Service.Template.Directory',
			MethodName: 'getTabConfig',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID']
		}, false);
		$.each(tabConfig, function (index, tab) {
			if ($('#templateTabs').tabs('exists', tab.name)) {
				$('#templateTabs').tabs('select', tab.name);//ѡ�в�ˢ��
			} else {
				$('#templateTabs').tabs('add', {
					title: tab.name,
					content: '<ul id="tab' + index + '" data-options="animate:true"></ul>'
				});
			}
			$HUI.tree('#tab' + index, {
				loader: function (param, success, error) {
					$cm({
						ClassName: "NurMp.Service.Template.List",
						MethodName: "getTemplates",
						HospitalID: session['LOGON.HOSPID'],
						LocID: session['LOGON.CTLOCID'],
						EpisodeID: EpisodeID,
						RangeFlag: tab.showType,
						SearchInfo: $HUI.searchbox('#moreSearchBox').getValue()
					}, function (data) {
						success(data);
					});
				},
				lines: true,
				onLoadSuccess: function (node, data) {
					if (!!GLOBAL.CurrentModelId) {
						var selNode = $(this).tree('find', GLOBAL.CurrentModelId);
						if (!!selNode) {
							$(this).tree('select', selNode.target);
						}
					}
				},
				onClick: function (node) {
					GLOBAL.CurrentModelId = node.id;
					openRecord(node);
					$(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);
				}
			});
		});

	}
	/**
	* @description ���൯�����¼�
	*/
	function openMoreWindow() {
		initMoreWindow();
		$HUI.window('#windowMore', 'open');
		$('#moreSearchBox').searchbox({
			searcher: function (value) {
				var tab = $('#templateTabs').tabs('getSelected');
				var index = $('#templateTabs').tabs('getTabIndex', tab);
				$HUI.tree('#tab' + index, 'reload');
			}
		});
		$HUI.tabs('#templateTabs', {
			onSelect: function (title, index) {
				$HUI.tree('#tab' + index, 'reload');
			}
		});
	}
	/**
	* @description ���ݴ򿪷���
	* @param {node} ģ����� 
	*/
	function openRecord(node) {
		if (!EpisodeID) {
			$.messager.alert($g('����ʾ'), $g('����ѡ���ߵľ����¼��'), 'info');
			return;
		}
		var editAuthority = AuthorityFlag;
		$m({
			ClassName: 'NurMp.Service.Template.Model',
			MethodName: 'editAuthority',
			EpisodeID: EpisodeID,
			LocID: session['LOGON.CTLOCID'],
			Key: node.cspName
		}, function (ifCanEidt) {
			if (ifCanEidt != '0') {
				$.messager.popover({ msg: ifCanEidt, type: 'error' });
				editAuthority = 2;
			}
			if (!!node.cspName) {
				if ($('#recordTabs').tabs('exists', node.label)) {
					$('#recordTabs').tabs('select', node.label);
					var currTab = $('#recordTabs').tabs('getSelected');
					var tabUrl = $(currTab.panel('options').content).attr('src');
					if (tabUrl != undefined && currTab.panel('options').title != 'Home') {
						$('#recordTabs').tabs('update', {
							tab: currTab,
							options: {
								content: createFrame("iframetab" + node.cspName.toLowerCase(), tabUrl)
							}
						})
					}
				} else {
					var tabUrl = "nur.emr." + node.cspName.toLowerCase() + ".csp?EpisodeID=" + EpisodeID + "&AuthorityFlag=" + editAuthority + "&ModelId=" + node.modelId;
					if (node.ejectFlag) {
						recordDialog(node, tabUrl);
					} else {
						$('#recordTabs').tabs('add', {
							title: node.label,
							content: createFrame("iframetab" + node.cspName.toLowerCase(), tabUrl),
							fit: true,
							closable: true,
							episodeId: EpisodeID
						});
					}
				}
				$HUI.window('#windowMore', 'close');
			}
		});
	}
	/**
	 * @description: ����iframe
	 */
	function createFrame(frameId, tabUrl) {
		var iframe = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + tabUrl + '"></iframe>';
		return iframe;
	}
	/**
	* @description ��Ĭ�ϵĵ���
	*/
	function openDefaultRecord() {
		if (!!DefaultCode) {
			var defaultArr = DefaultCode.split('^');
			$m({
				ClassName: "NurMp.Service.Template.Model",
				MethodName: "getEmrName",
				Guid: defaultArr[0]
			}, function (emrName) {
				var emrArr = emrName.split('^');
				var defaultNode = {
					id: defaultArr[0],
					label: emrArr[0],
					text: emrArr[0],
					cspName: emrArr[1],
					type: "leaf"
				};
				openRecord(defaultNode);

			});
		}
	}
	/**
	* @description  һ���鵵
	*/
	function placeFile(node) {
		$.messager.confirm($g('��ʾ'), $g("ȷ���� <b style='color:red;'>" + node.name + "</b> �Ĳ����鵵��"), function (r) {
			if (r) {
				$m({
					ClassName: 'NurMp.Service.Patient.List',
					MethodName: 'placeFile',
					EpisodeID: node.episodeID,
					UserID: session['LOGON.USERID']
				}, function (message) {
					if (message == '1') {
						$.messager.popover({ msg: $g('�ύ�ɹ���'), type: 'info' });
						$HUI.tree('#patientTree', 'reload');
					} else if (message == '0') {
						$.messager.popover({ msg: $g('�ύʧ�ܣ�'), type: 'error' });
					} else {
						$.messager.popover({ msg: message, type: 'error' });
					}
				});
			} else {
			}
		});
	}
	/**
	* @description  ������չʾ������
	*/
	function recordDialog(node, url) {
		$('#dialogRecord').dialog({
			title: node.label,
			width: $(window).width() - 20,
			height: $(window).height() - 5,
			cache: false,
			content: createFrame("iframetab" + node.cspName.toLowerCase(), url),
			modal: true,
			onClose: function () {
				refreshTree();
			}
		});
		$("#dialogRecord").dialog("open");
	}
	/**
	* @description  ѡ��ĳ������
	*/
	function selectOnePatient(direct, admId) {
		var nextNodeID;
		if (!direct) {
			direct = 1;
		}
		if (!!admId) {
			nextNodeID = admId;

		} else {
			var selNode = $('#patientTree').tree('getSelected');
			var selSortId = selNode.sortId;
			if ((selSortId == 1) && (direct < 0)) {
				selSortId = Object.keys(GLOBAL.ArrSort).length + 1;
			}
			var nextSortId = selSortId + direct;
			nextNodeID = GLOBAL.ArrSort[1];
			if (!!GLOBAL.ArrSort[nextSortId]) {
				nextNodeID = GLOBAL.ArrSort[nextSortId];
			}
		}
		var node = $('#patientTree').tree('find', nextNodeID);
		if (node != null) {
			$('#patientTree').tree('select', node.target);
			node.target.click();
		}
	}
	/**
	 * @description: �Ҽ���ݲ˵�
	 * @param {*} e��node, treeId
	 */
	function rightClickMenu(e, node, treeId) {
		e.preventDefault();
		$('#' + treeId).tree('select', node.target);
		var patNode = $('#patientTree').tree('getSelected');
		//���˾���״̬
		var visitStatus = !!patNode ? patNode.visitStatus : '';
		var expStr = JSON.stringify({Guid: node.id});
		$cm({
			ClassName: 'NurMp.Service.Switch.Config',
			MethodName: 'GetSwitchValues',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			ExpStr: expStr
		}, function (configInfo) {
			var ifGotoLog = JSON.parse(configInfo.Main.GotoUrl);  //������־
			var ifOutEdit = JSON.parse(configInfo.Main.OutPatientEditFlag);  //��Ժ�����༭����
			var editDays = parseFloat(configInfo.Main.OutPatientEditDays);  //��Ժ�����༭��������
			$('#menuTemplate').empty();
			var emptyFlag = 1;
			if ((ifGotoLog) && (configInfo.Other) && (JSON.parse(configInfo.Other.logSwitch))) {
				initMenuTemplate(node, 'operationLog', $g('������־'), 'icon-green-line-eye', 'nur.hisui.nurseRecordLog.csp', configInfo.Main.UrlParameter, '');
				emptyFlag = 0
			}
			if ((visitStatus == 'D') && (ifOutEdit) && (patNode.outDays!='') && (patNode.outDays > editDays)) {
				initMenuTemplate(node, 'outPatEdit', $g('��Ժ������������'), 'icon-checkin', 'NurMp.Quality.AuthorityV2.csp', '', 165);
				emptyFlag = 0
			}
			if (emptyFlag == 0) {
				$('#menuTemplate').menu('show', {
					left: e.pageX,
					top: e.pageY
				});
			}
		});
	}
	/**
	* @description �����¼�
	*/
	function listenEvents() {
		$('#btnMore').click(openMoreWindow);
		$HUI.tabs('#recordTabs', {
			onSelect: function (title, index) {
				var currTab = $('#recordTabs').tabs('getTab', index);
				var src = $(currTab.panel('options').content).attr('src');
				var jsonUrl = serilizeURL(src);
				if (jsonUrl["EpisodeID"] != EpisodeID) {
					var editAuthority = AuthorityFlag;
					$m({
						ClassName: 'NurMp.Service.Template.Model',
						MethodName: 'editAuthority',
						EpisodeID: EpisodeID,
						LocID: session['LOGON.CTLOCID'],
						Key: jsonUrl["csp"]
					}, function (ifCanEidt) {
						if (ifCanEidt != '0') {
							$.messager.popover({ msg: ifCanEidt, type: 'error' });
							editAuthority = 2;
						}
						var tabUrl = jsonUrl["csp"] + ".csp?EpisodeID=" + EpisodeID + "&AuthorityFlag=" + editAuthority + "&ModelId=" + jsonUrl["ModelId"];
						$('#recordTabs').tabs('update', {
							tab: currTab,
							options: {
								content: createFrame("iframetab" + jsonUrl["emrcode"], tabUrl)
							}
						});
					});
				}
			},
			onUnselect: function (title, index) {
				var target = this;
				var idcolse = true;
				return idcolse;
			},
			onBeforeClose: function (title, index) {
				var target = this;
				var targetTab = $('#recordTabs').tabs('getTab', index);
				var iframe = $(targetTab.panel('options').content);
				var src = iframe.attr('src');
				var jsonUrl = serilizeURL(src);
				var frameId = "iframetab" + jsonUrl["emrcode"];
				var t = document.getElementById(frameId);
				var oldwindow = t.contentWindow;
				if (oldwindow.CloseAlertFlag && (typeof oldwindow.FormIsChanged === "function")) {
					var IsChanged = oldwindow.FormIsChanged();
					if (!IsChanged) {
						var opts = $(target).tabs('options');
						var bc = opts.onBeforeClose;
						opts.onBeforeClose = function () { };  // allowed to close now
						$(target).tabs('close', index);
						opts.onBeforeClose = bc;  // restore the event function
					} else {
						var oldOk = $.messager.defaults.ok;
						var oldCancel = $.messager.defaults.cancel;
						$.messager.defaults.ok = "ȷ��";
						$.messager.defaults.cancel = "ȡ��";
						$.messager.confirm($g('��ʾ'), $g('���޸ģ��Ƿ񱣴�?ѡ��ȡ��ֱ�ӹرգ�ѡ��ȷ���Զ����档'), function (r) {
							if (!r) {
								var opts = $(target).tabs('options');
								var bc = opts.onBeforeClose;
								opts.onBeforeClose = function () { };  // allowed to close now
								$(target).tabs('close', index);
								opts.onBeforeClose = bc;  // restore the event function
							} else {
								if (typeof oldwindow.autoSave === "function") {
									oldwindow.autoSave();
								}
							}
						});
						$.messager.defaults.ok = oldOk;
						$.messager.defaults.cancel = oldCancel;
					}
				} else {
					return true;
				}
				return false;	// prevent from closing
			}
		});
	}

	initUI();

	return NursingRecords = {
		InitSavedTemplateTree: refreshTree,
		SelectOnePatient: selectOnePatient
	};
});
