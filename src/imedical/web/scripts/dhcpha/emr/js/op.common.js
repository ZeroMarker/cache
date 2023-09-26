//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

//处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
function forbidBackSpace(e) {
    var ev = e || window.event; //获取event对象
    var obj = ev.target || ev.srcElement; //获取事件源
    var t = obj.type || obj.getAttribute('type'); //获取事件源类型
    //获取作为判断条件的事件类型
    var vReadOnly = obj.readOnly;
    var vDisabled = obj.disabled;
    //处理undefined值情况
    vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
    vDisabled = (vDisabled == undefined) ? true : vDisabled;
    //当敲Backspace键时，事件源类型为密码或单行、多行文本的，
    //并且readOnly属性为true或disabled属性为true的，则退格键失效
    var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);
    //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
    var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";
    //判断
    if (flag2 || flag1) {
        ev.returnValue = false;
        return false;
    }
}

//是否存在指定函数
function isExistFunc(funcName) {
    try {
        if (typeof(eval(funcName)) == 'function') {
            return true;
        }
    } catch (e) {}
    return false;
}
//是否存在指定变量
function isExistVar(variableName) {
    try {
        if (typeof(variableName) == 'undefined') {
            return false;
        } else {
            return true;
        }
    } catch (e) {}
    return false;
}

/* 获取鼠标在页面上的位置
 * @param ev  触发的事件
 * @return  x:鼠标在页面上的横向位置, y:鼠标在页面上的纵向位置
 */
function getMousePoint(ev) {
    var point = {
        x: 0,
        y: 0
    };
    if (typeof window.pageYOffset != 'undefined') {
        point.x = window.pageXOffset;
        point.y = window.pageYOffset;
    } else if (typeof document.compatMode != 'undefined' && document.compatMode != 'BackCompat') {
        point.x = document.documentElement.scrollLeft;
        point.y = document.documentElement.scrollTop;
    } else if (typeof document.body != 'undefined') {
        point.x = document.body.scrollLeft;
        point.y = document.body.scrollTop;
    }
    point.x += ev.clientX;
    point.y += ev.clientY;
    return point;
}

//获取客户端IP地址
function getIpAddress() {
    try {
        var locator = new ActiveXObject('WbemScripting.SWbemLocator');
        var service = locator.ConnectServer('.');
        var properties = service.ExecQuery('Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True');
        var e = new Enumerator(properties); {
            var p = e.item();
            var ip = p.IPAddress(0);
            return ip
        }
    } catch (err) {
        return '';
    }
}

function NewSearchBoxOnTree() {

    var SearchBoxOnTree = new Object();
    SearchBoxOnTree.ContinueID = '';
    SearchBoxOnTree.Search = function ($tree, value, isMatchFunc) {
        var searchCon = $('#searchBox').searchbox('getValue');
        if ('' == searchCon)
            return;
        var rootNode = $tree.tree('getRoot');
        if (null == rootNode)
            return false;

        function setContinueID(rootNode) {
            var startNode = $tree.tree('getSelected');

            if (startNode != null && startNode.id != rootNode.id) {
                SearchBoxOnTree.ContinueID = startNode.id;
            } else {
                SearchBoxOnTree.ContinueID = '';
            }
        }

        function selectNode(node) {
            $tree.tree('select', node.target);
        }

        function expandParent(node) {
            var parentNode = node;
            var t = true;
            do {
                parentNode = $tree.tree('getParent', parentNode.target); //获取此节点父节点
                if (parentNode) { //如果存在
                    t = true;
                    $tree.tree('expand', parentNode.target);
                } else {
                    t = false;
                }
            } while (t);
        }

        //查找子节点，查找到了 true， 返回false继续查找
        function searchChild(startNode) {
            var children = $tree.tree('getChildren', startNode.target);
            if (!children)
                return false;
            var flag = false;

            for (var j = 0; j < children.length; j++) {
                if ('' != SearchBoxOnTree.ContinueID) {
                    if (SearchBoxOnTree.ContinueID == children[j].id) {
                        flag = true;
                        continue;
                    }
                    if (!flag) {
                        continue;
                    }
                }
                if (isMatchFunc(children[j], searchCon)) {
                    selectNode(children[j]);
                    expandParent(children[j]);
                    $tree.tree('scrollTo');
                    return true;
                }
            }

            return false;
        }

        if (searchChild(rootNode)) {
            setContinueID(rootNode);
        } else {
            SearchBoxOnTree.ContinueID = '';
            if (searchChild(rootNode)) {
                setContinueID(rootNode);
            }
        }
    }

    return SearchBoxOnTree;
}

function ajaxDATA() {
    var data = {
        OutputType: arguments[0],
        Class: arguments[1],
        Method: arguments[2]
    };

    for (var i = 3; i < arguments.length; i++) {
        data['p' + (i - 2)] = arguments[i];
    }

    return data;
}

function ajaxGET(data, onSuccess, onError) {
    $.ajax({
        type: 'GET',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: true,
        cache: false,
        data: data,
        success: function (ret) {
            if (!onSuccess) {}
            else {
                onSuccess(ret);
            }
        },
        error: function (ret) {
            alert('get err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
}

function ajaxGETSync(data, onSuccess, onError) {
    $.ajax({
        type: 'GET',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: false,
        cache: false,
        data: data,
        success: function (ret) {
            if (!onSuccess) {}
            else {
                onSuccess(ret);
            }
        },
        error: function (ret) {
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
}

// in: var myDate = new Date(); out: 格式为YYYY-MM-DD
function getFormatDate(date) {
    var seperator1 = "-";
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = year + seperator1 + month + seperator1 + strDate;
    return currentdate;
}

function replaceLinkParams(lnk) {
    var ret = lnk.replace('@patientID', patInfo.PatientID);
    ret = ret.replace('@episodeID', patInfo.EpisodeID);
    ret = ret.replace('@mradm', patInfo.MRadm);
    //ret = ret.replace('@WardID, WardID);
    ret = ret.replace('@userID', patInfo.UserID);
    ret = ret.replace('@ssgroupID', patInfo.SsgroupID);
    ret = ret.replace('@userLocID', patInfo.UserLocID);
    ret = ret.replace('@userCode', patInfo.UserCode);
    return ret;
}

function dynamicCall(funcName, thisObj) {
    var result = '';
    var fn = window[funcName];
    if (typeof fn === 'function') {
        if (thisObj == null)
            thisObj = window;

        var argArray = [];
        for (var i = 2; i < arguments.length; i++) {
            argArray.push(arguments[i]);
        }
        result = fn.apply(thisObj, argArray);
    }
    return result;
}

var common = {
    ///当前用户信息
    getUserInfo: function () {
        var result = '';
        var data = ajaxDATA('String', 'EMRservice.BL.BLEMRSign', 'GetUserInfo', patInfo.UserCode, '', patInfo.UserLocID);
        ajaxGETSync(data, function (ret) {
            result = $.parseJSON(ret.replace(/\'/g, "\""));
        }, function (ret) {
            alert('GetUserInfo error:' + ret);
        });

        return result;
    },
    getSavedRecords: function (onSuccess) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getSavedRecords', patInfo.EpisodeID, patInfo.UserID, patInfo.UserLocID, patInfo.SsgroupID);
        ajaxGET(data, function (ret) {
            if (typeof onSuccess === 'function') {
                onSuccess(ret);
            }
        });
    },
    ///文档是否已经被创建
    IsExistInstance: function (emrDocId) {
        var result = '0';
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'IsExistInstance', patInfo.EpisodeID, emrDocId);
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            alert('IsExistInstance error:' + ret);
        });

        return result;
    },
    ///文档是否已保存
    isSaved: function (insID) {
        var result = '0';
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'isSaved', insID);
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            alert('isSaved error:' + ret);
        });

        return result;
    },
    ///文档是否已经打印
    isPrinted: function (insID) {
        var result = '0';
        var data = ajaxDATA('String', 'EMRservice.BL.BLEMRLogs', 'RecHasAction', patInfo.EpisodeID, insID, 'Print');
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            alert('isPrinted error:' + ret);
        });

        return result;
    },
    ///互斥检查，是否允许创建(1允许、0不允许)
    IsAllowMuteCreate: function (emrDocId) {
        var result = '1';
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'IsAllowMuteCreate', patInfo.EpisodeID, emrDocId);
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            alert('IsAllowMuteCreate error:' + ret);
        });

        return result;
    },
    ///通过范例病历ID获取展现结构ID
    getEMRTemplateIDBymodelId: function (modelId) {
        var result = '';
        $.ajax({
            type: 'GET',
            dataType: 'text',
            url: '../EMRservice.Ajax.opInterface.cls',
            async: false,
            cache: false,
            data: {
                action: 'getEMRTemplateIDBymodelId',
                modelId: modelId
            },
            success: function (ret) {
                result = ret;
            },
            error: function (ret) {
                alert('getEMRTemplateIDBymodelId Error:' + modelId);
            }
        });
        return result;
    },
    ///通过实例ID获取模板ID
    getTemplateIDByInsId: function (insID, func) {
        $.ajax({
            type: 'GET',
            dataType: 'text',
            url: '../EMRservice.Ajax.opInterface.cls',
            async: false,
            cache: false,
            data: {
                action: 'GetTemplateIDByInsId',
                InstanceID: insID
            },
            success: function (ret) {
                func(ret);
            },
            error: function (ret) {
                alert('GetTemplateIDByInsId Error:' + insID);
            }
        });
    },
    GetRecodeParam: function (emrTmplCateid, func) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParam', emrTmplCateid);
        ajaxGET(data, function (ret) {
            func($.parseJSON(ret));
        }, function (ret) {
            alert('GetRecodeParam error:' + ret);
        });

    },
    GetRecodeParamByInsID: function (insID, func) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParamByInsID', insID);
        ajaxGET(data, function (ret) {
            func($.parseJSON(ret));
        }, function (ret) {
            alert('GetRecodeParamByInsID error:' + ret);
        });
    },
    getOPDisplay: function (callback) {
        var data = ajaxDATA('String', 'EMRservice.BL.BLUserPageConfig', 'GetOPDisplay', patInfo.UserID, patInfo.UserLocID);
        ajaxGET(data, function (ret) {
            callback(ret);
        }, function (ret) {
            alert('GetOPDisplay error:' + ret);
        });		
    },
    setOPDisplay: function (opDisplay) {
        var data = ajaxDATA('String', 'EMRservice.BL.BLUserPageConfig', 'SetOPDisplay', patInfo.UserID, patInfo.UserLocID, ''+opDisplay);
        ajaxGET(data, function (ret) {
             
        }, function (ret) {
            alert('SetOPDisplay error:' + ret);
        });			
    },	
    foo: function () {}
};
