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
	var clientInfo = getClientInfo();   //调平台组接口获取客户端信息
	if (clientInfo !== "") {return clientInfo[0];}
	else{
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
}

//调用平台组接口获取客户端信息
function getClientInfo()
{
	var clientInfo = "";
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls", 
		async : false,
		data : {
			"OutputType":"String",
			"Class":"EMRservice.HISInterface.PatientInfoAssist",
			"Method":"GetClientInfo"		
		},
		success : function(d) {
			if (d !== '')
	        clientInfo = d.split("^");		//IP地址^会话ID^在线状态^计算机名^计算机MAC
		}
	});	
	return clientInfo;
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
                //判断节点是否为子节点
                if (!$tree.tree('isLeaf', children[j].target)) { 
                    continue; 
                }    
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

$.extend($.fn.tree.methods, {
    getLeafChildren: function(jqTree, params) {
        var nodes = [];
        $(params).next().children().children("div.tree-node").each(function() {
            nodes.push($(jqTree[0]).tree('getNode', this));
        });
        return nodes;
    },
    /** 
     * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
     * @param param { 
     *    treeContainer: easyui tree的容器（即存在滚动条的树容器）。如果为null，则取easyui tree的根UL节点的父节点。 
     *    targetNode:  将要滚动到的easyui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
     * }  
     */
    scrollTo: function(jqTree, param) {
        //easyui tree的tree对象。可以通过tree.methodName(jqTree)方式调用easyui tree的方法  
        var tree = this;
        //如果node为空，则获取当前选中的node  
        var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);

        if (targetNode != null) {
            //判断节点是否在可视区域
            var root = tree.getRoot(jqTree);
            var $targetNode = $(targetNode.target);
            var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();
            var containerH = container.height();
            var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;
            if (nodeOffsetHeight > (containerH - 30)) {
                var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;
                container.scrollTop(scrollHeight);
            }else {
                container.scrollTop(0);
            }
        }
    }
});

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
            //$.messager.alert('发生错误', 'get err', 'error');
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

function ajaxPOST(data, onSuccess, onError) {
    $.ajax({
        type: 'POST',
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
            alert('post err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
}

function ajaxPOSTSync(data, onSuccess, onError) {
    $.ajax({
        type: 'POST',
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
    var ret = lnk.replace(/@patientID/g, patInfo.PatientID);
    ret = ret.replace(/@episodeID/g, patInfo.EpisodeID);
    ret = ret.replace(/@mradm/g, patInfo.MRadm);
    //ret = ret.replace(/@WardID/g, WardID);
    ret = ret.replace(/@userID/g, patInfo.UserID);
    ret = ret.replace(/@ssgroupID/g, patInfo.SsgroupID);
    ret = ret.replace(/@userLocID/g, patInfo.UserLocID);
    ret = ret.replace(/@userCode/g, patInfo.UserCode);
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

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr){
    if ($("#modalIframe").length<1)
	{
        $("body").append('<iframe id="modalIframe" style="position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;" frameborder="0"></iframe>');
    }
	else
	{
        $("#modalIframe").css("display","block");
    }
    $("body").append("<div id='"+dialogId+"'</div>");
	if (isNaN(width)) width = 800;
	if (isNaN(height)) height = 500;  
    if(document.getElementById("emrEditor")&&(judgeIsIE()==false))
    	document.getElementById("emrEditor").style.visibility="hidden"; //隐藏插件
    var returnValue = "";
    $HUI.dialog('#'+dialogId,{ 
        title: dialogTitle,
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $('#'+iframeId)[0].contentWindow;
            if (tempFrame)
			{
				returnValue = tempFrame.returnValue;
			    if ((returnValue != "") && (returnValue !== undefined) && (typeof(callback) === "function"))
				{
                    callback(returnValue,arr);
                }
			}
        },
        onClose:function(){
            $("#modalIframe").hide();
            if(document.getElementById("emrEditor"))
    			document.getElementById("emrEditor").style.visibility="visible"; //隐藏插件
			$("#"+dialogId).dialog('destroy');
        }
    });
}
//关闭dialog,子页面调用
function closeDialog(dialogId)
{
	$HUI.dialog('#'+dialogId).close();
}

function judgeIsIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}

/*
/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, _width, _height, iframeId, iframeCotent, fn){
    if($("#modalIframe").length<1){
        $('body').append('<iframe id="modalIframe" style=\"position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;\" frameborder=\"0\"></iframe>');
    }else{
        $("#modalIframe").css("display","block")
    }
    $("body").append("<div id='"+dialogId+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    var returnValue = "";
    $HUI.dialog('#'+dialogId,{ 
        title: dialogTitle,
        width: _width,
        height: _height,
        cache: false,
        //border:'thick',
        //iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeCotent,
        onBeforeClose:function(){
            if ($("#"+iframeId)[0]){
                returnValue = $("#"+iframeId)[0].contentWindow.returnValue;
            }
        },
        onClose:function(){
            destroyDialog(dialogId);
            $("#modalIframe").hide();
            if (returnValue == "cancel"){
                return;
            }else{
                if ((returnValue != "") &&(typeof fn === "function")){
                    fn(returnValue);
                }
            }
        }
    });
}
function closeDialog(id){
   $('#'+id).dialog('close');
}
function destroyDialog(id){
    $("body").remove("#"+id); //移除存在的Dialog
    $("#"+id).dialog('destroy');
}
*/
function createDialog(id, title, url, width, height, icon) {
    //top.$("<div class='hisui-dialog' style='overflow:hidden;'></div>").appendTo("body").dialog({
    $("<div class='hisui-dialog' style='overflow:hidden;'></div>").appendTo("body").dialog({
        id: id,
        title: title,
        href: url,
        width: width || 400,
        height: height || 500,
        iconCls: icon || '',
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true
        /*,
        onClose: function(){
            //移除存在的Dialog
            $("body").remove("#"+id);
            $("#"+id).dialog('destroy');
        }*/
    });
}

/// 创建HISUI-Window弹窗
function createWindow(id, title, url, width, height, iTop, iLeft, icon) {
    //parent.$('body').append("<div id='"+id+"' class='hisui-window' style='overflow:hidden;'></div>");
    //parent.$('#'+id).window({
    $("<div class='hisui-window' style='overflow:hidden;'></div>").appendTo("body").window({
        id: id,
        title: title,
        href: url,
        width: width || 1000,
        height: height || 500,
        top: iTop || 20,
        left: iLeft || 150,
        /*width: width,
        height: height,
        top: iTop,
        left: iLeft,*/
        iconCls: icon,
        //fit: true,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        //modal: true,
        closed: false,
        closable: true,
        isTopZindex: true
        /*,
        onBeforeClose: function(){
            
        },
        onClose: function(){
            /*$("#"+id).window('destroy');
            //移除存在的window
            $("body").remove("#"+id);
        }*/
    });
}

var common = {
    ///当前用户信息
    getUserInfo: function () {
        var result = '';
        var data = ajaxDATA('String', 'EMRservice.BL.BLEMRSign', 'GetUserInfo', patInfo.UserCode, '', patInfo.UserLocID);
        ajaxGETSync(data, function (ret) {
            result = $.parseJSON(ret.replace(/\'/g, "\""));
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetUserInfo error:' + ret, 'error');
            alert('GetUserInfo error:' + ret);
        });

        return result;
    },
    getSavedRecords: function (onSuccess) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getSavedRecords', patInfo.EpisodeID, patInfo.UserLocID, patInfo.SsgroupID);
        ajaxGET(data, function (ret) {
            if (typeof onSuccess === 'function') {
                onSuccess(ret);
            }
        });
    },
    getSavedRecordsForAudit: function (onSuccess) {
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getSavedRecordsForAudit', patInfo.EpisodeID, patInfo.UserID, patInfo.UserLocID, patInfo.SsgroupID);
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
            //$.messager.alert('发生错误', 'IsExistInstance error:' + ret, 'error');
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
            //$.messager.alert('发生错误', 'isSaved error:' + ret, 'error');
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
            //$.messager.alert('发生错误', 'isPrinted error:' + ret, 'error');
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
            //$.messager.alert('发生错误', 'IsAllowMuteCreate error:' + ret, 'error');
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
                //$.messager.alert('发生错误', 'getEMRTemplateIDBymodelId error:' + modelId, 'error');
                alert('getEMRTemplateIDBymodelId error:' + modelId);
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
                //$.messager.alert('发生错误', 'GetTemplateIDByInsId error:' + insID, 'error');
                alert('GetTemplateIDByInsId error:' + insID);
            }
        });
    },
    GetRecodeParam: function (emrTmplCateid, func) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParam', emrTmplCateid);
        ajaxGET(data, function (ret) {
            func($.parseJSON(ret));
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetRecodeParam error:' + ret, 'error');
            alert('GetRecodeParam error:' + ret);
        });

    },
    GetRecodeParamByInsID: function (insID, func) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParamByInsID', insID);
        ajaxGET(data, function (ret) {
            func($.parseJSON(ret));
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetRecodeParamByInsID error:' + ret, 'error');
            alert('GetRecodeParamByInsID error:' + ret);
        });
    },
	GetRecodeParamByInsIDSync: function (insID, func) {
		var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParamByInsID', insID);
        ajaxGETSync(data, function (ret) {
			func($.parseJSON(ret));
		}, function (ret) {
			$.messager.alert('发生错误', 'GetRecodeParamByInsIDSync error:' + ret, 'error');
		});
    },
    getOPDisplay: function (callback) {
        var data = ajaxDATA('String', 'EMRservice.BL.BLUserPageConfig', 'GetOPDisplay', patInfo.UserID, patInfo.UserLocID);
        ajaxGET(data, function (ret) {
            callback(ret);
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetOPDisplay error:' + ret, 'error');
            alert('GetOPDisplay error:' + ret);
        });
    },
    setOPDisplay: function (opDisplay) {
        var data = ajaxDATA('String', 'EMRservice.BL.BLUserPageConfig', 'SetOPDisplay', patInfo.UserID, patInfo.UserLocID, ''+opDisplay);
        ajaxGET(data, function (ret) {
             
        }, function (ret) {
            //$.messager.alert('发生错误', 'SetOPDisplay error:' + ret, 'error');
            alert('SetOPDisplay error:' + ret);
        });
    },
    getDefaultLoadId: function (templateCategoryId,locID) {
        //获取多文档加载未创建时默认加载的titleCode
        var defaultLoadId = '';
        var data = ajaxDATA('String', 'EMRservice.BL.BLTitleConfig', 'GetDefaultLoadTitleCode', templateCategoryId, locID);
        ajaxGETSync(data, function (ret) {
                defaultLoadId = ret;
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetDefaultLoadTitleCode error:' + ret, 'error');
            alert('GetDefaultLoadTitleCode error:' + ret);
        });        
        return defaultLoadId;
    },
    getOPHistoryFlag: function () {
        var opHistoryFlag = "";
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetOPInfoJosn', patInfo.EpisodeID);
            ajaxGETSync(data, function (ret) {
                    opHistoryFlag = ret;
            }, function (ret) {
                alert('GetOPInfoJosn error:' + ret);
            });
        if (opHistoryFlag === "") opHistoryFlag = "[{'AdmHistoryCount':'0','AllergyCount':'0'}]";
        return opHistoryFlag;
    },
    getApplyStatus: function (insID) {
        var result = "";
        var data = ajaxDATA('String', 'EMRservice.BL.BLApplyEdit', 'GetApplyStatus', insID, patInfo.UserID);
        ajaxGETSync(data, function (ret) {
            result = ret.split('^')[0];
        }, function (ret) {
            alert('GetApplyStatus error:' + ret);
        });        
        return result;
    },
    getSignUnitPath: function (insID) {
        //获取模板维护的对应签名单元路径
        var result = '';
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getSignUnitPath', insID);
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            alert('GetSignUnitPath error:' + ret);
        });        
        return result;
    },
    //检查是否有去权限创建，以及有个创建选项时返回权限下的创建选项 (0不允许、其余值为emrDocId)
    getEmrDocId: function (emrDocIds) {
        var result = '0';
        var data = ajaxDATA('String', 'EMRservice.BL.BLOPClientCategory', 'GetEMRTemplateID', patInfo.EpisodeID, patInfo.UserID, patInfo.UserLocID, patInfo.SsgroupID, emrDocIds);
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            alert('getEmrDocId error:' + ret);
        });
        return result;
    },
    //审核页面使用
    GetRecodeParamByInsIDSync: function (insID, func) {
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParamByInsID', insID);
        ajaxPOSTSync(data, function (ret) {
            func($.parseJSON(ret));
        }, function (ret) {
            alert('GetRecodeParamByInsID error:' + ret);
        });
    },
    foo: function () {}
};

//国际化改造获取翻译
function emrTrans(value)
{
	if (typeof $g == "function") 
	{
		value = $g(value)
	}
	return value;
}
