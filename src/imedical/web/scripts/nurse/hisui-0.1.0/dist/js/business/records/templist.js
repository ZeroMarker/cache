/*
 * @Descripttion: ������-���ý���-ģ���б�
 * @Author: yaojining
 */

/**
 * @description: ģ���б�ҳ�����
 */
function requestTemplate() {
    if ((GV) && (!$.isEmptyObject(GV.SwitchInfo))) {
		if ($('#curTemplateTree').length > 0) {
	        loadAccTempPage();
	    } else if ($('#TemplateUl').length > 0) {
	        loadOneTempPage();
	    } else {
	        return;
	    }
	} else {
		$cm({
			ClassName: 'NurMp.Service.Switch.Config',
			MethodName: 'GetSwitchValues',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			GroupID: session['LOGON.GROUPID']
		}, function (switchInfo) {
			GV.SwitchInfo = switchInfo.Main;
		    if ($('#curTemplateTree').length > 0) {
		        loadAccTempPage();
		    } else if ($('#TemplateUl').length > 0) {
		        loadOneTempPage();
		    } else {
		        return;
		    }
		});
	}
}

/**
 * @description: ��ʼ��ҳ��(Accrodition)
 */
function loadAccTempPage() {
    initTempCondition();
    activeAccordion();
    listenTempEvents();
}

/**
 * @description: ��ʼ��ҳ��(��Accrodition)
 */
function loadOneTempPage() {
    initOneTemplateTree('TemplateUl');
    listenTempEvents();
}

/**
 * @description: ��ʼ��ѡ���accordion
 */
function activeAccordion() {
    var p = $('#tempAccordion').accordion('getSelected');
    if (p) {
        var ulid = p.children(0).attr('id');
        if (ulid) {
            initAccTemplateTree(ulid);
            setTimeout(function () {
                clickOneTemplate(ulid);
            }, 200);
        }
    }
}

/**
 * @description: ��ѯ������ʼ��
 */
function initTempCondition() {
    // ����ģʽ�������޸Ĳ�ѯ��������ʽ
    if ((GV.SwitchInfo.SimpleListFlag == 'false') || (!!ShowBtnMore)) {
        $('#btnMore').show();
        $('#TemplateSearch').searchbox({
            width: 154
        });
    }
    // �����accordion�µ�ģ������ʼ��
    $('#tempAccordion').accordion({
        onSelect: function (title, index) {
            var p = $(this).accordion('getPanel', index);
            if (p) {
                var ulid = p.children(0).attr('id');
                if (ulid) {
                    initAccTemplateTree(ulid);
                }
            }
            resize();
        },
        onResize:function(w,h) {
            resize();
        }
    });
    resize();
}

/**
 * @description: �������óߴ�
 */
function resize() {
    var acchead_height = 36;
    var accbody_height = $('.accordion-gray.accordion .accordion-body').panel('options').height;
    var contentbody_height = accbody_height - acchead_height;
    $('.accordion-gray.accordion .accordion-body').css('height', contentbody_height + 5 + 'px');
}

/**
 * @description: ��ʼ��ģ���б�(Accrodition)
 * @param {object} tempTreeId
 */
function initAccTemplateTree(tempTreeId) {
	if (TempCheckFlag == 1) {
        // ��ѡ
        initCheckAccTemplateTree(tempTreeId);
        return;
    }
    $('#' + tempTreeId).tree({
        lines: true,
        loader: function (param, success, error) {
            var rangeFlag = 'S';
            // �ж��Ƿ��Ǹ��൯��
            var moreWindowFlag = ($('#curTemplateTree').length > 0) && (!$('#windowMore').parent().is(':hidden'));
            if (moreWindowFlag) {
                var tab = $('#templateTabs').tabs('getSelected');
                rangeFlag = tab.children(0).attr('showType');
            }
            $cm({
                ClassName: 'NurMp.Service.Template.List',
                MethodName: 'getTemplates',
                HospitalID: session['LOGON.HOSPID'],
                LocID: session['LOGON.CTLOCID'],
                EpisodeID: EpisodeID,
                RangeFlag: rangeFlag,
                SearchInfo: moreWindowFlag ? $HUI.searchbox('#moreSearchBox').getValue() : $HUI.searchbox('#TemplateSearch').getValue(),
                SimpleFlag: moreWindowFlag ? 'false' : (GV.SwitchInfo.SimpleListFlag == 'true' ? 'true' : 'false'),
                GroupID: session['LOGON.GROUPID'],
                TreeType: moreWindowFlag ? 'curTemplateTree' : tempTreeId,
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
        formatter: tempTreeFormatter,
        onLoadSuccess: onTempTreeLoadSuccess,
        onClick: onClickTemplate,
        onContextMenu: onTempTreeMenu,
        onExpand: onChangeState,
        onCollapse: onChangeState
    });
}

/**
 * @description: ��ʼ����ѡģ���б�(Accrodition)
 * @param {object} tempTreeId
 */
function initCheckAccTemplateTree(tempTreeId) {
    $('#' + tempTreeId).tree({
        lines: true,
        loader: function (param, success, error) {
            var rangeFlag = 'S';
            // �ж��Ƿ��Ǹ��൯��
            var moreWindowFlag = ($('#curTemplateTree').length > 0) && (!$('#windowMore').parent().is(':hidden'));
            if (moreWindowFlag) {
                var tab = $('#templateTabs').tabs('getSelected');
                rangeFlag = tab.children(0).attr('showType');
            }
            $cm({
                ClassName: 'NurMp.Service.Template.List',
                MethodName: 'getTemplates',
                HospitalID: session['LOGON.HOSPID'],
                LocID: session['LOGON.CTLOCID'],
                EpisodeID: EpisodeID,
                RangeFlag: rangeFlag,
                SearchInfo: moreWindowFlag ? $HUI.searchbox('#moreSearchBox').getValue() : $HUI.searchbox('#TemplateSearch').getValue(),
                SimpleFlag: moreWindowFlag ? 'false' : (GV.SwitchInfo.SimpleListFlag == 'true' ? 'true' : 'false'),
                GroupID: session['LOGON.GROUPID'],
                TreeType: moreWindowFlag ? 'curTemplateTree' : tempTreeId,
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
        formatter: tempTreeFormatter,
        onLoadSuccess: onTempTreeLoadSuccess,
        onContextMenu: onTempTreeMenu,
        onExpand: onChangeState,
        onCollapse: onChangeState,
        checkbox: true,
        onCheck: onCheckTemplate
    });
}


/**
 * @description: ��ʼ��ģ���б�(��Accrodition)
 * @param {object} tempTreeId
 */
function initOneTemplateTree(tempTreeId) {
	if (TempCheckFlag == 1) {
        // ��ѡ
        initCheckOneTemplateTree(tempTreeId);
        return;
    }
    $('#' + tempTreeId).tree({
        lines: true,
        loader: function (param, success, error) {
            $cm({
                ClassName: 'NurMp.Service.Template.List',
                MethodName: 'getTemplates',
                HospitalID: session['LOGON.HOSPID'],
                LocID: session['LOGON.CTLOCID'],
                RangeFlag: 'S',
                SearchInfo: $('#TemplateSearch').searchbox('getValue'),
                SimpleFlag: 'true',
                Page: 'One',
                GroupID: session['LOGON.GROUPID'],
                TreeType: 'curTemplateTree',
            }, function (data) {
                var addIDAndText = function (node) {
                    if (!!node.locDesc) {
                        node.text = node.text + "&nbsp;&nbsp;<label style='font-size:12px;font-style:italic;color:red;'>" + node.locDesc + "</label>";
                    }
                }
                data.forEach(addIDAndText);
                success(data);
            });
        },
        formatter: tempTreeFormatter,
        onLoadSuccess: onTempTreeLoadSuccess,
        onClick: onClickTemplate,
        onContextMenu: onTempTreeMenu,
        onExpand: onChangeState,
        onCollapse: onChangeState
    });
}

/**
 * @description: ��ʼ����ѡģ���б�(��Accrodition)
 * @param {object} tempTreeId
 */
function initCheckOneTemplateTree(tempTreeId) {
    $('#' + tempTreeId).tree({
        lines: true,
        loader: function (param, success, error) {
            $cm({
                ClassName: 'NurMp.Service.Template.List',
                MethodName: 'getTemplates',
                HospitalID: session['LOGON.HOSPID'],
                LocID: session['LOGON.CTLOCID'],
                RangeFlag: 'S',
                SearchInfo: $('#TemplateSearch').searchbox('getValue'),
                SimpleFlag: 'true',
                Page: 'One',
                GroupID: session['LOGON.GROUPID'],
                TreeType: 'curTemplateTree',
            }, function (data) {
                var addIDAndText = function (node) {
                    if (!!node.locDesc) {
                        node.text = node.text + "&nbsp;&nbsp;<label style='font-size:12px;font-style:italic;color:red;'>" + node.locDesc + "</label>";
                    }
                }
                data.forEach(addIDAndText);
                success(data);
            });
        },
        formatter: tempTreeFormatter,
        onLoadSuccess: onTempTreeLoadSuccess,
        onContextMenu: onTempTreeMenu,
        onExpand: onChangeState,
        onCollapse: onChangeState,
        checkbox: true,
        onCheck: onCheckTemplate
    });
}

/**
 * @description: ���ڵ���ʽ
 * @param {object} node
 * @param {string} text
 */
function tempTreeFormatter(node) {
    var text = node.text;
    // CAǩ��ͼ��
    if (node.ifRecordCASign == 'Y') {
        text = text + '&nbsp;&nbsp;<img style="height:14px;" src="../skin/default/images/ca_icon_green.png"/>'
    }
    // �Ƿ��ӡ��ʶ
    if (node.ifPriented == 1) {
        text = text + '&nbsp;<span style="color:orange;">*</span>';
    }
    // �Ƿ��ӡ��ʶ
    if (node.ifMedField == 1) {
        text = '<span style="color:#3d59ab;font-size:15px;">��</span>' + text;
    }
    // �Զ��岡���б�ڵ����ʽ
    if (typeof customTempTreeFormatter == 'function') {
        return customTempTreeFormatter(node, text);
    }
    return text;
}

/**
 * @description: tree���سɹ���Ĵ���
 * @param {*} node
 * @param {*} data
 */
function onTempTreeLoadSuccess(node, data) {
    // ���ȸ���ModelID��Ĭ�ϵ���
    if (!!ModelID) {
        var selNode = $(this).tree('find', ModelID);
        if (!!selNode) {
            $(this).tree('select', selNode.target);
        }
    }
    if (typeof updateStep == 'function') {
        updateStep('templist');
    }
    // �Զ��岡���б������ɺ�Ľӿڷ���
    if (typeof customTempTreeLoadSuccess == 'function') {
        customTempTreeLoadSuccess(node, data);
    }
}

/**
 * @description: ģ�����¼�
 * @param {object} node
 */
function onClickTemplate(node) {
    ModelID = node.id;
    $(this).tree(node.state == 'closed' ? 'expand' : 'collapse', node.target);
    if (String(node.id).indexOf('||') < 0) {
        return;
    }
    // �Զ���ģ�����¼��ӿڷ���
    if (typeof (customClickTemplate) == 'function') {
        customClickTemplate(node);
    }
    // ���ں�
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}

/**
 * @description: ģ�年ѡ�¼�
 * @param {object} node
 * @param {bool} checked
 */
function onCheckTemplate(node,checked) {
    // �Զ���ģ�����¼��ӿڷ���
    if (typeof (customCheckTemplate) == 'function') {
        customCheckTemplate(node,checked);
    }
    // ���ں�
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}

/**
 * @description: ȫ��ȡ����ѡ
 */
function unCheckAllTemplate() {
    $('#curTemplateTree, #transTemplateTree').find('.tree-checkbox1').removeClass('tree-checkbox1').addClass('tree-checkbox0');
}

/**
 * @description: �Ҽ��˵�
 * @param {*} event
 * @param {object} node
 * @param {string} moreWindowFlag
 */
function onTempTreeMenu(event, node) {
    $(this).tree('select', node.target);
    if (node.type != 'leaf') {
        return;
    }
    // �Զ���ģ�����¼��ӿڷ���
    if (typeof (customTempTreeMenu) == 'function') {
        customTempTreeMenu(event, node);
    }
}

/**
 * @description: �ı�״̬
 * @param {object} node
 */
function onChangeState(node) {
    // �Զ���ģ�����¼��ӿڷ���
    if (typeof (customChangeState) == 'function') {
        customChangeState(node);
    }
}

/**
 * @description: ģ�����Ľڵ����¼�
 * @param {string} tempTreeId
 */
function clickOneTemplate(tempTreeId) {
    if (!!DefaultCode) {
        if ($('#' + tempTreeId).length > 0) {
            // ���Ը���ModelID����Guid��Ĭ�ϱ�
            if (DefaultCode.indexOf('||') > -1) {
                var selNode = $('#' + tempTreeId).tree('find', DefaultCode);
                if (!!selNode) {
                    selNode.target.click();
                }
            } else {
                $cm({
                    ClassName: 'NurMp.Service.Template.Model',
                    MethodName: 'GetModelInfoByGuid',
                    Guid: DefaultCode
                }, function (modelInfo) {
                    if (!$.isEmptyObject(modelInfo)) {
                        var selNode = $('#' + tempTreeId).tree('find', modelInfo.ModelID);
                        if (!!selNode) {
                            selNode.target.click();
                        }
                    }
                });
            }
        }
    }
}

/**
 * @description: ��ʼ���Ҽ��˵�
 * @param {*} node
 * @param {*} id
 * @param {*} text
 * @param {*} iconCls
 * @param {*} csp
 * @param {*} urlParameter
 * @param {*} width
 */
function initMenuTemplate(node, id, text, iconCls, csp, urlParameter, width) {
    $('#menuTemplate').menu('appendItem', {
        id: id,
        text: text,
        iconCls: iconCls,
        handler: function () {
            if (!!csp) {
                var url = csp + '?EpisodeID=' + EpisodeID + '&DefaultCode=' + node.id + urlParameter;
                websys_createWindow(url, text, "top=10,left=10,width=98%,height=90%,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
            } else {
                onOpMenuClick(node, id);
            }
        }
    });
    if (!!width) {
        $('#menuTemplate').width(width);
    }
}

/**
 * @description: �����Ƴ��˵��¼�
 * @param {object} node
 * @param {string} func
 */
function onOpMenuClick(node, func) {
    if (!GV.LocRootId) {
        $.messager.popover({ msg: '����ʧ�ܣ�', type: 'error', timeout: 1000 });
        return;
    }
    var funCmd = func + '(node)';
    eval(funCmd);
}

/**
 * @description: ����
 * @param {*} node
 */
function addIntoModel(node) {
    $m({
        ClassName: "NurMp.Service.Template.Directory",
        MethodName: "saveBatch",
        NodeID: GV.LocRootId,
        Guids: node.id,
        LocID: session['LOGON.CTLOCID'],
        ReName: node.text,
        SortNo: '',
        UserID: session['LOGON.USERID'] || '',
        HospitalID: session['LOGON.HOSPID'],
        TypeCode: 'L',
        OperationLog: 'false',
        MarkLog: 'false',
        IsOut: 'false',
        EjectFlag: 'false',
        EditFlag: 'false'
    }, function (txtData) {
        if (!$.isNumeric(txtData)) {
            $.messager.popover({ msg: txtData, type: 'error', timeout: 1000 });
        } else if (parseInt(txtData) < 0) {
            $.messager.popover({ msg: '����ʧ��! ����ģ���п��ܲ����ڿ��Ҹ�Ŀ¼����ǰ����������ʾģ�����á�ҳ��ά����', type: 'error', timeout: 1000 });
        } else {
            $.messager.popover({ msg: '����ɹ�! ', type: 'success', timeout: 1000 });
        }
    });
}

/**
 * @description: �Ƴ�
 * @param {*} node
 */
function removeFromModel(node) {
    confirm(function () {
        $m({
            ClassName: "NurMp.Service.Template.Directory",
            MethodName: "deleteDirectSub",
            LocID: session['LOGON.CTLOCID'],
            RootID: GV.LocRootId,
            Guid: node.id,
            HospitalID: session['LOGON.HOSPID']
        }, function (txtData) {
            if (parseInt(txtData) != 0) {
                $.messager.popover({ msg: '�Ƴ�ʧ��! ' + txtData, type: 'error', timeout: 1000 });
                return;
            } else {
                $.messager.popover({ msg: '�Ƴ��ɹ�! ', type: 'success', timeout: 1000 });
                $HUI.tree('#tab1', 'reload');
            }
        })
    });
}

/**
 * @description ˢ��ģ����
 */
function refreshTempTree() {
    if ($('#tempAccordion').length > 0) {
        var p = $('#tempAccordion').accordion('getSelected');
        if (p) {
            var ulid = p.children(0).attr('id');
            if (ulid) {
                $('#' + ulid).tree('reload');
            }
        }
    } else {
        $('#TemplateUl').tree('reload');
    }
}

/**
 * @description: ����ģ�嵯��
 */
function showMoreWindow() {
    $('#windowMore').window({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        modal: false,
        isTopZindex: true,
        onBeforeOpen: onBeforeOpenMore,
        onOpen: onOpenMore
    }).window('open');
}

/**
 * @description: ����ģ���ǰ
 */
function onBeforeOpenMore() {
    $cm({
        ClassName: 'NurMp.Service.Template.Directory',
        MethodName: 'getTabConfig',
        HospitalID: session['LOGON.HOSPID'],
        LocID: session['LOGON.CTLOCID']
    }, function (tabConfig) {
        // ��̬����ҳǩ
        $.each(tabConfig, function (index, tab) {
            if (!$('#templateTabs').tabs('exists', tab.name)) {
                $('#templateTabs').tabs('add', {
                    title: tab.name,
                    content: '<ul id="tab' + index + '" data-options="animate:true" showType="' + tab.showType + '"></ul>'
                });
            }
        });
        // Ĭ��ѡ�е�һ��ҳǩ
        $('#templateTabs').tabs('select', 0);
    });
}

/**
 * @description: �򿪸���ģ��
 */
function onOpenMore() {
    $m({
        ClassName: 'NurMp.Service.Template.Directory',
        MethodName: 'getLocTemplatesRootId',
        locID: session['LOGON.CTLOCID'],
        hospitalID: session['LOGON.HOSPID']
    }, function (locRootId) {
        // �Զ��岡���б������ɺ�Ľӿڷ���
        if (typeof (setLocRootId) == 'function') {
            setLocRootId(locRootId);
        }
    });
    $('#templateTabs').tabs({
        onSelect: function (title, index) {
            initAccTemplateTree('tab' + index);
        }
    });
    $('#moreSearchBox').searchbox({
        searcher: function (value) {
            var tab = $('#templateTabs').tabs('getSelected');
            var index = $('#templateTabs').tabs('getTabIndex', tab);
            $('#tab' + index).tree('reload');
        }
    });
}

/**
 * @description: �¼�����
 */
function listenTempEvents() {
    if ($('#TemplateSearch').length > 0) {
        $('#TemplateSearch').searchbox({
            searcher: function (value) {
                refreshTempTree();
            }
        });
    }
    if ($('#btnMore').length > 0) {
        $('#btnMore').bind('click', showMoreWindow);
    }
}