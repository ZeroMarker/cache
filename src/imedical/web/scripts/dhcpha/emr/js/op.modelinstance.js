var $modelInstanceTree;

$(function () {
    $modelInstanceTree = $('#modelInstanceTree');

    var SearchBoxOnTree = NewSearchBoxOnTree();
    $('#searchBox').searchbox({
        searcher: function (value, name) {
            SearchBoxOnTree.Search($modelInstanceTree, value, function (node, searchCon) {
                return (node.text.indexOf(searchCon) >= 0) || (node.attributes.py.indexOf(searchCon.toUpperCase()) >= 0);
            });
        },
        prompt: '请输入查询关键字'
    });

    $('#searchPnl').panel({
        onResize: function (width, height) {
            $('#searchBox').searchbox('resize', width - 6);
        }
    });

    $('#searchBox').searchbox('resize', $('#searchPnl').width() - 6);

    getTreeData();
    initContextMenu();
    initModelInstanceTree();

    $('#btnToModelIns').live('click', function () {
        var documentContext = invoker.getDocumentContext();
        $('#newName').val(documentContext.Title.DisplayName + ' - ' + invoker.patInfo.UserName);
        showNameDlg(saveToModelInsData);
    });
});

function initModelInstanceTree() {

    $modelInstanceTree.tree({
        dnd: true,
        formatter: function (node) {
            var s = node.text;
            if (node.children) {
                s += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
            }
            updateCateIcon(node);
            return s;
        },
        onDblClick: function (node) {
            if ($(this).tree('isLeaf', node.target)) {
                if (node && !isCategory(node)) {
                    invoker.LoadPersonTmpl('&' + node.id, node.id);
                }
                if (window.dialogArguments !== "undefined") {
                    closeWindow();
                }
            } else {
                $(this).tree('toggle', node.target)
            }
        },
        onContextMenu: function (e, node) {
            $(this).tree('select', node.target);
            onContextMenu(e, node);
        },
        onBeforeSelect: function (node) {
            return true;
        },
        onSelect: function (node) {},
        onBeforeDrag: function (node) {
            //共享目录没有拖拽功能
            if (/Share/g.test(node.attributes.type)) return false;
        },
        onDrop: function (targetNode, source, point) {
            //debugger;
            var tNode = $modelInstanceTree.tree('getNode', targetNode);
            var sNode = source;
            var action;
            if (isCategory(sNode)) {
                action = 'MoveModelInsCate';
            } else {
                action = 'MoveModelIns';
            }
            var isBottom = 1; //alert(tNode.id + '  ' + sNode.id + '  ' + point);
            if (point == 'top' || point == 'bottom') {
                var parentNode = $modelInstanceTree.tree('getParent', tNode.target);
                if (point == 'top') {
                    isBottom = 0;
                }
                if (forbidMove(tNode, sNode)) {
                    getTreeData();
                    return;
                }
                moveit(action, parentNode, sNode, isBottom, tNode);
            } else { //'append'
                if (!isCategory(tNode)) {
                    alert('不可放至范例病历下级');
                    getTreeData();
                    return;
                }
                moveit(action, tNode, sNode, 1, '');
            }

        }
    });
}

function forbidMove(tNode, sNode) {
    if (isCategory(tNode) && !isCategory(sNode)) {
        return true;
    }
    if (!isCategory(tNode) && isCategory(sNode)) {
        return true;
    }
    return false;
}

function moveit(action, parentNode, curNode, isBottom, siblingNode) {
    var siblingNodeId = '';
    if ('' != siblingNode) {
        siblingNodeId = siblingNode.id;
    }

    var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
            action, parentNode.id, curNode.id, isBottom, siblingNodeId, userID);

    ajaxGET(data, function (ret) {
        if ('1' == ret) {
            getTreeData();
        }
    }, function (ret) {
        alert('get Tree Data error!');
    });
}

function getTreeData() {
    var data = ajaxDATA('Stream', 'EMRservice.BL.ModelInstanceData',
            'GetModelInstanceNode', userID, invoker.patInfo.UserLocID, invoker.patInfo.SsgroupID, episodeID);

    ajaxGET(data, function (ret) {
        $modelInstanceTree.tree({
            data: eval('[' + ret + ']')
        }).tree('expandAll');
    }, function (ret) {
        alert('get Tree Data error!');
    });
}

function onContextMenu(e, node) {
    e.preventDefault();

    var node = $modelInstanceTree.tree('getSelected');
    if (!/Share/g.test(node.attributes.type)){
        if ('0' == node.id) { //根节点
            $('#mm').menu('enableItem', $('#newCategory')[0]);
            $('#mm').menu('enableItem', $('#toModelIns')[0]);
            $('#mm').menu('disableItem', $('#modifyit')[0]);
            $('#mm').menu('disableItem', $('#renameit')[0]);
            $('#mm').menu('disableItem', $('#removeit')[0]);
            $('#mm').menu('disableItem', $('#moveUpNode')[0]);
            $('#mm').menu('disableItem', $('#moveDownNode')[0]);
            $('#mm').menu('disableItem', $('#shareit')[0]);
            $('#mm').menu('disableItem', $('#cancelshareit')[0]);
        } else if (isCategory(node)) { // 文件夹
            $('#mm').menu('enableItem', $('#newCategory')[0]);
            $('#mm').menu('enableItem', $('#toModelIns')[0]);
            $('#mm').menu('disableItem', $('#modifyit')[0]);
            $('#mm').menu('enableItem', $('#renameit')[0]);
            $('#mm').menu('enableItem', $('#removeit')[0]);
            $('#mm').menu('enableItem', $('#moveUpNode')[0]);
            $('#mm').menu('enableItem', $('#moveDownNode')[0]);
            $('#mm').menu('disableItem', $('#shareit')[0]);
            $('#mm').menu('disableItem', $('#cancelshareit')[0]);
        } else { //范例节点
            $('#mm').menu('disableItem', $('#newCategory')[0]);
            $('#mm').menu('disableItem', $('#toModelIns')[0]);
            $('#mm').menu('enableItem', $('#modifyit')[0]);
            $('#mm').menu('enableItem', $('#renameit')[0]);
            $('#mm').menu('enableItem', $('#removeit')[0]);
            $('#mm').menu('enableItem', $('#moveUpNode')[0]);
            $('#mm').menu('enableItem', $('#moveDownNode')[0]);
            //判断共享科室字段
            if (node.attributes.shareLocID === "")
            {
                $('#mm').menu('enableItem', $('#shareit')[0]);
                $('#mm').menu('disableItem', $('#cancelshareit')[0]);
            }else{
                $('#mm').menu('disableItem', $('#shareit')[0]);
                $('#mm').menu('enableItem', $('#cancelshareit')[0]);
            }
        }
    }else{//共享范例病历右键目录
        $('#mm').menu('disableItem', $('#newCategory')[0]);
        $('#mm').menu('disableItem', $('#toModelIns')[0]);
        $('#mm').menu('disableItem', $('#modifyit')[0]);
        $('#mm').menu('disableItem', $('#renameit')[0]);
        $('#mm').menu('disableItem', $('#removeit')[0]);
        $('#mm').menu('disableItem', $('#moveUpNode')[0]);
        $('#mm').menu('disableItem', $('#moveDownNode')[0]);
        $('#mm').menu('disableItem', $('#shareit')[0]);
        $('#mm').menu('disableItem', $('#cancelshareit')[0]);
    }

    $('#mm').menu('show', {
        left: e.pageX,
        top: e.pageY
    });
}

function isCategory(node) {
    return ('category' == node.attributes.type);
}

function updateCateIcon(node) {
    if (!isCategory(node))
        return;
    $modelInstanceTree.tree('update', {
        target: node.target,
        iconCls: 'user-folder-open'
    });
}

function initContextMenu() {
    document.getElementById("newCategory").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if (node) {
            $('#newName').val(node.text);
            showNameDlg(NewCategory);
        }
    };
    document.getElementById("toModelIns").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if (node) {
            var documentContext = invoker.getDocumentContext();
            $('#newName').val(documentContext.Title.DisplayName + ' - ' + invoker.patInfo.UserName); //todo
            showNameDlg(saveToModelInsData);
        }
    };
    document.getElementById("modifyit").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if (node) {
            var id = node.id;
            var returnValues = window.showModalDialog('emr.record.edit.modelinstance.csp', id, 'dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;');
        }
    };
    document.getElementById("renameit").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if (node) {
            $('#newName').val(node.text);
            showNameDlg(RenameIt);
        }
    };
    document.getElementById("removeit").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if ($modelInstanceTree.tree('getChildren', node.target).length > 0) {
            alert('存在下级节点，不允许删除');
            return;
        }

        if (!confirm('确定删除【' + node.text + '】?')) {
            return;
        }
        var id = node.id;
        var action;
        if (isCategory(node)) {
            action = 'RemoveModelInsCate';
        } else {
            action = 'RemoveModelIns';
        }

        var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
                action, id);
        ajaxGET(data, function (ret) {
            if (ret != 1) {
                alert('删除失败：' + ret.Err);
            } else {
                var parentNode = $modelInstanceTree.tree('getParent', node.target);
                $modelInstanceTree.tree('remove', node.target);
                if ($modelInstanceTree.tree('getChildren', parentNode.target).length == 0) {
                    updateCateIcon(parentNode);
                }
            }
        }, function (ret) {
            alert(action + ':' + ret);
        });

    };
    document.getElementById("moveUpNode").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        var prevSibling = getSibling(node, 0, isCategory(node));
        if ('' == prevSibling)
            return;
        SwapNode(node, prevSibling);
    };
    document.getElementById("moveDownNode").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        var nextSibling = getSibling(node, 1, isCategory(node));
        if ('' == nextSibling)
            return;
        SwapNode(node, nextSibling);
    };
    
    document.getElementById("shareit").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if (node) {
            $('#newName').val(node.text);
            $('#title').hide();
            $('#shareModel').show();
            $('#shareModel').text('确认共享【' + node.text + '】?');
            showNameDlg(shareModelIns);
        }
    };
    document.getElementById("cancelshareit").onclick = function() {
        var node = $modelInstanceTree.tree('getSelected');
        if (node) {
            $('#newName').val(node.text);
            $('#title').hide();
            $('#shareModel').show();
            $('#shareModel').text('确认取消共享【' + node.text + '】?');
            showNameDlg(cancelModelIns);
        }
    };
}

function showNameDlg(fnOnComfirmed) {
    $('#dlg').dialog({
        title: '',
        closed: true,
        cache: false,
        modal: true,
        buttons: [{
                text: '确认',
                handler: function () {                    
                    var newName = $('#newName').val();
                    if ('' == newName)
                        return;
                    if (typeof fnOnComfirmed === 'function') {
                        fnOnComfirmed(newName);
                    }
                    $('#title').show();
                    $('#shareModel').hide();
                    return false;
                }
            }, {
                text: '取消',
                handler: function () {
                    $('#dlg').dialog('close');
                    $('#title').show();
                    $('#shareModel').hide();
                    return false;
                }
            }
        ]
    }).dialog('open');    
}

//flag = 0： 向前  1：向后
function getSibling(node, flag, isCate) {

    var parentNode = $modelInstanceTree.tree('getParent', node.target);
    var nodes;
    if (isCate) {
        nodes = $modelInstanceTree.tree('getChildren', parentNode.target);
    } else {
        nodes = $modelInstanceTree.tree('getLeafChildren', parentNode.target);
    }
    if (2 > nodes.length)
        return '';
    var siblingNode = '';
    for (var i = 0; i < nodes.length; i++) {
        if (node.id == nodes[i].id) {
            var tmpNode = '';
            if (0 == flag) {
                tmpNode = nodes[i - 1];
            } else {
                tmpNode = nodes[i + 1];
            }
            if (!tmpNode)
                return '';
            if ($modelInstanceTree.tree('isLeaf', tmpNode.target)) {
                return tmpNode;
            }
            return '';
        }
    }
    return '';
}

function SwapNode(node1, node2) {

    if (forbidMove(node1, node2)) {
        return;
    }

    function swap() {
        var id = node2.id;
        var txt = node2.text;
        $modelInstanceTree.tree('update', {
            target: node2.target,
            id: node1.id,
            text: node1.text
        });
        $modelInstanceTree.tree('update', {
            target: node1.target,
            id: id,
            text: txt
        });
    }

    var flag = isCategory(node1) ? '1' : '0';

    var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
            'SwapSequence', node1.id, node2.id, flag);
    ajaxGET(data, function (ret) {
        if (ret == 1) {
            getTreeData();
        }
    }, function (ret) {
        alert('Swap Sequence error!');
    });
}

function RenameIt(newName) {
    var node = $modelInstanceTree.tree('getSelected');
    var id = node.id;
    var action;
    if (isCategory(node)) {
        action = 'RenameModelCategory';
    } else {
        action = 'RenameModelInstance';
    }

    if ('' == id || '' == newName)
        return;

    var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
            action, id, newName);
    ajaxGET(data, function (ret) {
        if (ret == '1') {
            node.text = newName;
            $modelInstanceTree.tree('update', node);
            $('#dlg').dialog('close');
        } else {
            alert('修改失败：' + ret);
        }
    }, function (ret) {
        alert(action + ':' + ret);
    });
}

function NewCategory(newName) {

    function AppendNode(parentNode, id) {
        $modelInstanceTree.tree('collapseAll');
        $modelInstanceTree.tree('append', {
            parent: parentNode.target,
            data: [{
                    id: id,
                    text: newName,
                    state: 'closed',
                    children: [],
                    attributes: {
                        type: 'category'
                    }
                }
            ]
        }).tree('expandAll');
    }

    var node = $modelInstanceTree.tree('getSelected');
    var parentCateID;
    if (!isCategory(node)) {
        return;
    } else {
        parentCateID = node.id;
    }

    if ('' == parentCateID || '' == newName)
        return;

    var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
            'NewModelCategory', userID, parentCateID, newName);
    ajaxGET(data, function (ret) {
        if (ret && ret.Err) {
            alert('新增失败：' + ret.Err);
        } else {
            AppendNode(node, ret);
            $('#dlg').dialog('close');
        }
    }, function (ret) {
        alert('NewModelCategory:' + ret);
    });

}

function saveToModelInsData(newTitle) {
    var node = $modelInstanceTree.tree('getSelected');
    var nodeID = '0';
    if (node && isCategory(node)) {
        nodeID = node.id;
    }    

    var documentContext = invoker.getDocumentContext();
    if (!documentContext)
        return;

    //设置患者信息
    var insID = documentContext.InstanceID;
    var argParams = {
        InstanceID: insID,
        SaveType: 'Model',
        newTitle: newTitle,
        ModelInsCategoryID: nodeID
    };
    //debugger;
    invoker.iEmrPlugin.SET_PATIENT_INFO({
        args: argParams
    });
    var ret = invoker.iEmrPlugin.SAVE_DOCUMENT_AS({
            isSync: true
        });

    if (ret.result === 'OK' && ret.params.result === 'OK') {
        getTreeData();
    } else
        alert('保存失败!', 'info');

    var argParams = {
        SaveType: '',
        newTitle: ''
    };
    invoker.iEmrPlugin.SET_PATIENT_INFO({
        args: argParams
    });

    $('#dlg').dialog('close');
}

//共享范例病历
function shareModelIns(newName){
    var node = $modelInstanceTree.tree('getSelected');
    var id = node.id;
    if ('' === id ) return;
    var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
            'ShareModelInstance', id, invoker.patInfo.UserLocID);
    ajaxGET(data, function (ret) {
        if (ret === '1') {
            getTreeData();
        } else {
            alert('共享失败：' + ret);
        }
    }, function (ret) {
        alert(action + ':' + ret);
    });
    $('#dlg').dialog('close');
}
    
//取消共享
function cancelModelIns(newName){
    var node = $modelInstanceTree.tree('getSelected');
    var id = node.id;
    if ('' === id ) return;
    var data = ajaxDATA('String', 'EMRservice.BL.ModelInstanceData',
            'CancelShareModelInstance', id);
    ajaxGET(data, function (ret) {
        if (ret === '1') {
            getTreeData();
        } else {
            alert('取消共享失败：' + ret);
        }
    }, function (ret) {
        alert(action + ':' + ret);
    });
    $('#dlg').dialog('close');
}

//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

