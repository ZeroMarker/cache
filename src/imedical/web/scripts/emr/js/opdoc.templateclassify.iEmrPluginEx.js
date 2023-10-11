/// 对编辑器的命令进行包装，不包含业务逻辑
var templatePlugin;
/// 构造函数
function templatePluginEx(edtorFrame) {

    var _pluginType;
    this.showWord = function () {
        edtorFrame.showWord();
    }

    this.showGrid = function () {
        edtorFrame.showGrid();
    }

    /// 调用编辑器命令
    this.invoke = function (command, argParams) {

        var plugin = this.getPlugin();
        if (!plugin)
            return;
        argParams = argParams || {};
        if (argParams.isSync || false) {
            ///同步执行execute
            var result = plugin.syncExecute(JSON.stringify(command));
            if ((result === 'NONE')||(result === ''))
                return result;
            return $.parseJSON(result);
        } else {
            ///异步执行execute
            plugin.execute(JSON.stringify(command));
        }
    }

    var _pluginWord;
    this.attachWord = function (pluginUrl, pluginType, fnEvtDispatch) {
        //debugger;
        _pluginType = pluginType;
        var isSetPlugin = true;
        if (_pluginWord==null || _pluginWord.innerHTML== undefined)
        {
            var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
            objString += "<param name='install-url' value='";
            objString += pluginUrl;
            objString += "'/></object>";
            _pluginWord = edtorFrame.attachWord(objString);
            if (!_pluginWord.initWindow) {
                this.setUpPlug(pluginUrl);
                isSetPlugin = false;
                return isSetPlugin;
            }
            this.pluginAdd(fnEvtDispatch);
            var ret = _pluginWord.initWindow("iEditor") || false;
            if (!ret)
                throw ('iEditor initWindow error');
            var nectresult = this.SET_NET_CONNECT(); 
            if (nectresult != "" && nectresult.result != "OK")
            {
                alert('设置链接失败！');
                isSetPlugin = false;
                return isSetPlugin;
            } 
        }
        return isSetPlugin;  
    }

    var _pluginGrid;
    this.attachGrid = function (pluginUrl, pluginType, fnEvtDispatch) {
        //debugger;
        _pluginType = pluginType;
        var isSetPlugin = true;
        if (_pluginGrid==null || _pluginGrid.innerHTML== undefined)
        {
            var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
            objString += "<param name='install-url' value='";
            objString += pluginUrl;
            objString += "'/></object>";
            _pluginGrid = edtorFrame.attachGrid(objString);
            if (!_pluginGrid.initWindow) {
                this.setUpPlug(pluginUrl);
                isSetPlugin = false;
                return isSetPlugin;
            }
            this.pluginAdd(fnEvtDispatch);
            var ret = _pluginGrid.initWindow("iGridEditor") || false;
            if (!ret)
                throw ('iGridEditor initWindow error');
            var nectresult = this.SET_NET_CONNECT(); 
            if (nectresult != "" && nectresult.result != "OK")
            {
                alert('设置链接失败！');
                isSetPlugin = false;
                return isSetPlugin;
            } 
        }
        return isSetPlugin;

    }

    this.getPlugin = function () {
        if (_pluginType === 'DOC') {
            return _pluginWord;
        } else if (_pluginType === 'GRID') {
            return _pluginGrid;
        }
    }

    ///安装插件提示
    this.setUpPlug = function (pluginUrl) {
        //HISUI模态框
        pluginUrl = base64encode(utf16to8(pluginUrl));
        var iframeContent = '<iframe id="InstallPlugin" scrolling="no" frameborder="0" src="emr.record.downloadplugin.csp?PluginUrl='+pluginUrl+'&openWay=editor&MWToken='+getMWToken()+'" style="width:100%;height:99%;"></iframe>'
        createModalDialog("downloadPluginDialog", "下载插件", 300, 150, "InstallPlugin", iframeContent,"","");
        $HUI.dialog('#downloadPluginDialog',{ 
            onClose:function(){
                window.location.reload();
            }
        });
    }

    ///添加监听事件 挂接插件 \ 事件监听
    this.pluginAdd = function (fnEventDispatch) {
        var plugin = this.getPlugin();
        if (!plugin)
            return;

        var addEvent = function (obj, name, func) {
            if (obj.attachEvent) {
                obj.attachEvent("on" + name, func);
            } else {
                obj.addEventListener(name, func, false);
            }
        };

        addEvent(plugin, 'onFailure', function (command) {
            //$.messager.alert('发生错误', 'onFailure：' + command, 'error');
            alert('onFailure：' + command);
        });
        addEvent(plugin, 'onExecute', function (command) {
            var commandJson = $.parseJSON(command);
            fnEventDispatch(commandJson);
        });
    }

    ///设置工作环境
    this.setWorkEnvironment = function () {

        this.CLEAN_DOCUMENT();
        this.SET_WORKSPACE_CONTEXT({
            args: "Template"
        });
        this.SET_NOTE_STATE({
            args: 'Browse',
            isSync: true
            
        });
        this.SET_READONLY_COLOR({
            args: '0000ff'
        });
    }

    ///建立数据库连接
    this.SET_NET_CONNECT = function () {
 
        var netConnect = "";
        $.ajax({
            type: 'Post',
            dataType: 'text',
            url: '../EMRservice.Ajax.common.cls',
            async: false,
            cache: false,
            data: {
                "OutputType":"String",
                "Class":"EMRservice.BL.BLSysOption",
                "Method":"GetNetConnectJson",
				"p1":window.location.hostname,
				"p2":window.location.port,
				"p3":window.location.protocol.split(":")[0]
            },
            success: function (ret) {

                netConnect = eval("("+ret+")");
            },
            error: function (ret) {
                alert('get err');
                if (!onError) {}
                else {
                    onError(ret);
                }
            }
        });
        var command = {
            action: 'SET_NET_CONNECT',
            args: netConnect
        };
        var argParams = {
            isSync: true
        };
        return this.invoke(command, argParams);
    }

    ///设置默认字体
    this.SET_DEFAULT_FONTSTYLE = function (argParams) {
        var command = {
            action: 'SET_DEFAULT_FONTSTYLE',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }

    ///清空文档
    this.CLEAN_DOCUMENT = function (argParams) {
        var command = {
            action: 'CLEAN_DOCUMENT',
            args: ''
        };
        return this.invoke(command, argParams);
    }

    ///设置工作空间上下文
    this.SET_WORKSPACE_CONTEXT = function (argParams) {
        var command = {
            action: 'SET_WORKSPACE_CONTEXT',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }

    ///设置文字只读颜色 "0000ff"
    this.SET_READONLY_COLOR = function (argParams) {
        var command = {
            action: 'SET_READONLY_COLOR',
            args: {
                color: argParams.color
            }
        };
        return this.invoke(command, argParams);
    }

    ///设置状态 "Browse"
    this.SET_NOTE_STATE = function (argParams) {
        var command = {
            action: 'SET_NOTE_STATE',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }

    this.LOAD_DOCUMENT = function (argParams) {
        var command = {
            action: 'LOAD_DOCUMENT',
            args: {
                params: {
                    action: argParams.action,
                    TemplateVersionId: argParams.TemplateVersionId || '',
                    UserTemplateId: argParams.UserTemplateId || '',
                    ExampleInstanceID: argParams.ExampleInstanceId || ''
                }
            }
        };
        return this.invoke(command, argParams);
    }

    ///设置只读
    this.SET_READONLY = function (argParams) {
        var command = '';
        var insID = argParams.InstanceID || '';
        if (insID == '') {
            command = {
                action: 'SET_READONLY',
                args: {
                    ReadOnly: argParams.ReadOnly
                }
            };
        } else {
            command = {
                action: 'SET_READONLY',
                args: {
                    ReadOnly: argParams.ReadOnly,
                    InstanceID: [insID]
                }
            };
        }
        return this.invoke(command, argParams);
    }
    
    ///设置病历模板加载时组合章节数据
    this.SET_TEMPLATE_LOAD_SECTION = function (argParams) {
        var command = {
            action: 'SET_TEMPLATE_LOAD_SECTION',
            args: {
                LoadSection: argParams.LoadSection,
                UserTemplateCode: argParams.UserTemplateId || ''
            }
        };
        return this.invoke(command, argParams);
    }
}

