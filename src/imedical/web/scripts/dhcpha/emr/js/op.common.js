//�رմ���
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

//��������¼� ��ֹ���˼���Backspace��������С������ı������
function forbidBackSpace(e) {
    var ev = e || window.event; //��ȡevent����
    var obj = ev.target || ev.srcElement; //��ȡ�¼�Դ
    var t = obj.type || obj.getAttribute('type'); //��ȡ�¼�Դ����
    //��ȡ��Ϊ�ж��������¼�����
    var vReadOnly = obj.readOnly;
    var vDisabled = obj.disabled;
    //����undefinedֵ���
    vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
    vDisabled = (vDisabled == undefined) ? true : vDisabled;
    //����Backspace��ʱ���¼�Դ����Ϊ������С������ı��ģ�
    //����readOnly����Ϊtrue��disabled����Ϊtrue�ģ����˸��ʧЧ
    var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);
    //����Backspace��ʱ���¼�Դ���ͷ�������С������ı��ģ����˸��ʧЧ
    var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";
    //�ж�
    if (flag2 || flag1) {
        ev.returnValue = false;
        return false;
    }
}

//�Ƿ����ָ������
function isExistFunc(funcName) {
    try {
        if (typeof(eval(funcName)) == 'function') {
            return true;
        }
    } catch (e) {}
    return false;
}
//�Ƿ����ָ������
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

/* ��ȡ�����ҳ���ϵ�λ��
 * @param ev  �������¼�
 * @return  x:�����ҳ���ϵĺ���λ��, y:�����ҳ���ϵ�����λ��
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

//��ȡ�ͻ���IP��ַ
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
                parentNode = $tree.tree('getParent', parentNode.target); //��ȡ�˽ڵ㸸�ڵ�
                if (parentNode) { //�������
                    t = true;
                    $tree.tree('expand', parentNode.target);
                } else {
                    t = false;
                }
            } while (t);
        }

        //�����ӽڵ㣬���ҵ��� true�� ����false��������
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

// in: var myDate = new Date(); out: ��ʽΪYYYY-MM-DD
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
    ///��ǰ�û���Ϣ
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
    ///�ĵ��Ƿ��Ѿ�������
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
    ///�ĵ��Ƿ��ѱ���
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
    ///�ĵ��Ƿ��Ѿ���ӡ
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
    ///�����飬�Ƿ�������(1����0������)
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
    ///ͨ����������ID��ȡչ�ֽṹID
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
    ///ͨ��ʵ��ID��ȡģ��ID
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
