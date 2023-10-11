/*
 * @Descripttion: 护理病历-公用界面-模板列表
 * @Author: yaojining
 */

/**
 * @description: 模板列表页面入口
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
 * @description: 初始化页面(Accrodition)
 */
function loadAccTempPage() {
    initTempCondition();
    activeAccordion();
    listenTempEvents();
}

/**
 * @description: 初始化页面(无Accrodition)
 */
function loadOneTempPage() {
    initOneTemplateTree('TemplateUl');
    listenTempEvents();
}

/**
 * @description: 初始化选择的accordion
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
 * @description: 查询条件初始化
 */
function initTempCondition() {
    // 精简模式开启后，修改查询条件的样式
    if ((GV.SwitchInfo.SimpleListFlag == 'false') || (!!ShowBtnMore)) {
        $('#btnMore').show();
        $('#TemplateSearch').searchbox({
            width: 154
        });
    }
    // 激活的accordion下的模板树初始化
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
 * @description: 重新设置尺寸
 */
function resize() {
    var acchead_height = 36;
    var accbody_height = $('.accordion-gray.accordion .accordion-body').panel('options').height;
    var contentbody_height = accbody_height - acchead_height;
    $('.accordion-gray.accordion .accordion-body').css('height', contentbody_height + 5 + 'px');
}

/**
 * @description: 初始化模板列表(Accrodition)
 * @param {object} tempTreeId
 */
function initAccTemplateTree(tempTreeId) {
	if (TempCheckFlag == 1) {
        // 多选
        initCheckAccTemplateTree(tempTreeId);
        return;
    }
    $('#' + tempTreeId).tree({
        lines: true,
        loader: function (param, success, error) {
            var rangeFlag = 'S';
            // 判断是否是更多弹窗
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
 * @description: 初始化多选模板列表(Accrodition)
 * @param {object} tempTreeId
 */
function initCheckAccTemplateTree(tempTreeId) {
    $('#' + tempTreeId).tree({
        lines: true,
        loader: function (param, success, error) {
            var rangeFlag = 'S';
            // 判断是否是更多弹窗
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
 * @description: 初始化模板列表(无Accrodition)
 * @param {object} tempTreeId
 */
function initOneTemplateTree(tempTreeId) {
	if (TempCheckFlag == 1) {
        // 多选
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
 * @description: 初始化多选模板列表(无Accrodition)
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
 * @description: 树节点样式
 * @param {object} node
 * @param {string} text
 */
function tempTreeFormatter(node) {
    var text = node.text;
    // CA签名图标
    if (node.ifRecordCASign == 'Y') {
        text = text + '&nbsp;&nbsp;<img style="height:14px;" src="../skin/default/images/ca_icon_green.png"/>'
    }
    // 是否打印标识
    if (node.ifPriented == 1) {
        text = text + '&nbsp;<span style="color:orange;">*</span>';
    }
    // 是否打印标识
    if (node.ifMedField == 1) {
        text = '<span style="color:#3d59ab;font-size:15px;">★</span>' + text;
    }
    // 自定义病人列表节点的样式
    if (typeof customTempTreeFormatter == 'function') {
        return customTempTreeFormatter(node, text);
    }
    return text;
}

/**
 * @description: tree加载成功后的处理
 * @param {*} node
 * @param {*} data
 */
function onTempTreeLoadSuccess(node, data) {
    // 优先根据ModelID打开默认单据
    if (!!ModelID) {
        var selNode = $(this).tree('find', ModelID);
        if (!!selNode) {
            $(this).tree('select', selNode.target);
        }
    }
    if (typeof updateStep == 'function') {
        updateStep('templist');
    }
    // 自定义病人列表加载完成后的接口方法
    if (typeof customTempTreeLoadSuccess == 'function') {
        customTempTreeLoadSuccess(node, data);
    }
}

/**
 * @description: 模板点击事件
 * @param {object} node
 */
function onClickTemplate(node) {
    ModelID = node.id;
    $(this).tree(node.state == 'closed' ? 'expand' : 'collapse', node.target);
    if (String(node.id).indexOf('||') < 0) {
        return;
    }
    // 自定义模板点击事件接口方法
    if (typeof (customClickTemplate) == 'function') {
        customClickTemplate(node);
    }
    // 超融合
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}

/**
 * @description: 模板勾选事件
 * @param {object} node
 * @param {bool} checked
 */
function onCheckTemplate(node,checked) {
    // 自定义模板点击事件接口方法
    if (typeof (customCheckTemplate) == 'function') {
        customCheckTemplate(node,checked);
    }
    // 超融合
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}

/**
 * @description: 全部取消勾选
 */
function unCheckAllTemplate() {
    $('#curTemplateTree, #transTemplateTree').find('.tree-checkbox1').removeClass('tree-checkbox1').addClass('tree-checkbox0');
}

/**
 * @description: 右键菜单
 * @param {*} event
 * @param {object} node
 * @param {string} moreWindowFlag
 */
function onTempTreeMenu(event, node) {
    $(this).tree('select', node.target);
    if (node.type != 'leaf') {
        return;
    }
    // 自定义模板点击事件接口方法
    if (typeof (customTempTreeMenu) == 'function') {
        customTempTreeMenu(event, node);
    }
}

/**
 * @description: 改变状态
 * @param {object} node
 */
function onChangeState(node) {
    // 自定义模板点击事件接口方法
    if (typeof (customChangeState) == 'function') {
        customChangeState(node);
    }
}

/**
 * @description: 模板树的节点点击事件
 * @param {string} tempTreeId
 */
function clickOneTemplate(tempTreeId) {
    if (!!DefaultCode) {
        if ($('#' + tempTreeId).length > 0) {
            // 可以根据ModelID或者Guid打开默认表单
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
 * @description: 初始化右键菜单
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
 * @description: 移入移出菜单事件
 * @param {object} node
 * @param {string} func
 */
function onOpMenuClick(node, func) {
    if (!GV.LocRootId) {
        $.messager.popover({ msg: '操作失败！', type: 'error', timeout: 1000 });
        return;
    }
    var funCmd = func + '(node)';
    eval(funCmd);
}

/**
 * @description: 移入
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
            $.messager.popover({ msg: '移入失败! 科室模板中可能不存在科室根目录，请前往【科室显示模板配置】页面维护！', type: 'error', timeout: 1000 });
        } else {
            $.messager.popover({ msg: '移入成功! ', type: 'success', timeout: 1000 });
        }
    });
}

/**
 * @description: 移出
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
                $.messager.popover({ msg: '移出失败! ' + txtData, type: 'error', timeout: 1000 });
                return;
            } else {
                $.messager.popover({ msg: '移出成功! ', type: 'success', timeout: 1000 });
                $HUI.tree('#tab1', 'reload');
            }
        })
    });
}

/**
 * @description 刷新模板树
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
 * @description: 更多模板弹窗
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
 * @description: 更多模板打开前
 */
function onBeforeOpenMore() {
    $cm({
        ClassName: 'NurMp.Service.Template.Directory',
        MethodName: 'getTabConfig',
        HospitalID: session['LOGON.HOSPID'],
        LocID: session['LOGON.CTLOCID']
    }, function (tabConfig) {
        // 动态创建页签
        $.each(tabConfig, function (index, tab) {
            if (!$('#templateTabs').tabs('exists', tab.name)) {
                $('#templateTabs').tabs('add', {
                    title: tab.name,
                    content: '<ul id="tab' + index + '" data-options="animate:true" showType="' + tab.showType + '"></ul>'
                });
            }
        });
        // 默认选中第一个页签
        $('#templateTabs').tabs('select', 0);
    });
}

/**
 * @description: 打开更多模板
 */
function onOpenMore() {
    $m({
        ClassName: 'NurMp.Service.Template.Directory',
        MethodName: 'getLocTemplatesRootId',
        locID: session['LOGON.CTLOCID'],
        hospitalID: session['LOGON.HOSPID']
    }, function (locRootId) {
        // 自定义病人列表加载完成后的接口方法
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
 * @description: 事件监听
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