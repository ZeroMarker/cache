/// 对编辑器的命令进行包装，不包含业务逻辑
var iEmrPlugin;
var iwordFlag = false;
var igridFlag = false;
/// 构造函数
function iEmrPluginEx(edtorFrame) {

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
        if (_pluginWord==null || _pluginWord.innerHTML== undefined || !iwordFlag)
        {
            edtorFrame.attachGrid("");
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
            setRunEMRParams();
            iwordFlag = true;
            igridFlag = false;
        }
        return isSetPlugin;  
    }

    var _pluginGrid;
    this.attachGrid = function (pluginUrl, pluginType, fnEvtDispatch) {
        //debugger;
        _pluginType = pluginType;
        var isSetPlugin = true;
        if (_pluginGrid==null || _pluginGrid.innerHTML== undefined || !igridFlag)
        {
            edtorFrame.attachWord("");
            var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
            objString += "<param name='install-url' value='";
            objString += pluginUrl;
            objString += "'/></object>";
            _pluginGrid = edtorFrame.attachGrid(objString);
            if (!_pluginGrid.initWindow) {
                iEmrPlugin.setUpPlug(pluginUrl);
                isSetPlugin = false;
                return isSetPlugin;
            }
            iEmrPlugin.pluginAdd(fnEvtDispatch);
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
            setRunEMRParams();
            igridFlag = true;
            iwordFlag = false;
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
        //以前的模态框
//        var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl=" + pluginUrl, "", "dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
//        if (result) {
//            window.location.reload();
//        }
        //HISUI模态框
        pluginUrl = base64encode(utf16to8(pluginUrl));
        var iframeContent = '<iframe id="InstallPlugin" scrolling="no" frameborder="0" src="emr.record.downloadplugin.csp?PluginUrl='+pluginUrl+'&openWay=editor&MWToken='+getMWToken()+'" style="width:100%;height:99%;"></iframe>'
        createModalDialog("downloadPluginDialog", "下载插件", 300, 150, "InstallPlugin", iframeContent,setUpPlugCallBack,"");
    }
    
    function setUpPlugCallBack(returnValue,arr)
    {
        if (returnValue)
        {
            window.location.reload();
        }
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
    this.setWorkEnvironment = function (chartItemType) {

        this.CLEAN_DOCUMENT();
        this.SET_WORKSPACE_CONTEXT({
            args: chartItemType
        });
        this.SET_NOTE_STATE({
            args: 'Edit'
        });
        this.SET_READONLY_COLOR({
            args: '0000ff'
        });
    }

    ///建立数据库连接
    this.SET_NET_CONNECT = function () {
 
        var netConnect = "";
        
        var port = window.location.port;
        var protocol = window.location.protocol.split(":")[0];
        
        if (protocol == "http")
        {
            port = port==""?"80":port;
        }
        else if (protocol == "https")
        {
            port = port==""?"443":port;
        }
    
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
                "p2":port,
                "p3":protocol
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

    ///加载本地文档 todo
    this.LOAD_LOCAL_DOCUMENT = function (argParams) {
        var command = {
            action: 'LOAD_LOCAL_DOCUMENT',
            args: {
                path: ''
            }
        };
        return this.invoke(command, argParams);
    }

    ///打印文档 Print PrintDirectly
    this.PRINT_DOCUMENT = function (argParams) {
        var command = {
            action: 'PRINT_DOCUMENT',
            args: {
                actionType: argParams.args,
                PrintMode: argParams.printMode || '',
                "FirstNeedChangePage":FirstNeedChangePageFlag
            }
        };
        return this.invoke(command, argParams);
    }

    ///创建文档
    this.CREATE_DOCUMENT = function (argParams) {
        var command = {
            action: 'CREATE_DOCUMENT',
            args: {
                AsLoad: argParams.AsLoad || false,
                Title: {
                    DisplayName: argParams.DisplayName
                }
            }
        };
        return this.invoke(command, argParams);
    }

    ///预览
    this.PREVIEW_DOCUMENT = function (argParams) {
        var command = {
            action: 'PREVIEW_DOCUMENT',
            args: {
                Preview: argParams.Preview
            }
        };
        return this.invoke(command, argParams);
    }

    ///根据实例创建文档
    this.CREATE_DOCUMENT_BY_INSTANCE = function (argParams) {
        var CreateMode = argParams.CreateMode || '';
        if ('' != CreateMode) { 
            var command = {
                action: 'CREATE_DOCUMENT_BY_INSTANCE',
                args: {
                    params: {
                        CreateMode: 'ReplaceSection',
                        ExampleInstanceID: argParams.exampleId,
                        SectionList: argParams.sectionList
                    }
                }
            };
        }else {
            var command = {
                action: 'CREATE_DOCUMENT_BY_INSTANCE',
                args: {
                    InstanceID: argParams.InstanceID,
                    TitleCode: argParams.TitleCode,
                    AsLoad: argParams.AsLoad || false
                }
            };
        }
        return this.invoke(command, argParams);
    }
    
    ///使用科室模板创建文档
    this.CREATE_DOCUMENT_BY_USERTEMPLATE = function (argParams) {
        var command = {
            action: 'CREATE_DOCUMENT',
            args: {
                AsLoad: argParams.AsLoad || false,
                Title: {
                    DisplayName: argParams.DisplayName
                },
                TitleCode:argParams.TitleCode,
                LoadMode:'UserTemplate',
                UserTemplateCode:argParams.ExampleInstanceID
            }
        };
        return this.invoke(command, argParams);
    }
    
    ///使用个人模板创建文档
    this.CREATE_DOCUMENT_PERSONAL_TEMPLATE = function (argParams) {
	    ///根据标题创建实例
		if ((argParams.TitleCode || "") != "")
		{
	        var command = {
	            action: 'CREATE_DOCUMENT_BY_TITLE',
	            args: {
	                AsLoad: argParams.AsLoad || false,
	                TitleCode: argParams.TitleCode || '',
	                params: {
	                    action: 'CREATE_PERSONAL_TEMPLATE',
	                    PersonalTemplateID: argParams.ExampleInstanceID
	                }
	            }
	        };
		}
		else
		{   
	        var command = {
	            action: 'CREATE_DOCUMENT',
	            args: {
	                AsLoad: argParams.AsLoad || false,
	                TitleCode: argParams.TitleCode,
	                Title: {
	                        DisplayName: argParams.DisplayName
	                    },
	                params: {
	                    action: 'CREATE_PERSONAL_TEMPLATE',
	                    PersonalTemplateID: argParams.ExampleInstanceID
	                }
	            }
	        };
		}
        return this.invoke(command, argParams);
    }
    
    //保存个人模板-个人模板需要传给编辑器章节code，过滤header与footer、未绑定知识库的章节
    this.SAVE_PERSONAL_SECTION = function (argParams) {
        var metaDataTree = this.GET_METADATA_TREE({isSync:true});
        var items = [];

        for(var i=0;i<metaDataTree.items.length;i++)
        {
            if ((metaDataTree.items[i].Code == "Header")||(metaDataTree.items[i].Code == "Footer"))
                continue;
            var relation = "REPLACE";
            if ((metaDataTree.items[i].BindKBBaseID == "undefined")||(metaDataTree.items[i].BindKBBaseID == ""))
                relation = "REFERENCE";
            items.push({
                "SectionCode":metaDataTree.items[i].Code,
                "SectionStatus":relation
            });
        }
        var command = {
            action: 'SAVE_SECTION',
            args: {
                Items:items,
                params: {
                    CategoryID: argParams.CategoryID,
                    UserID: argParams.UserID,
                    Name: argParams.Name,
                    action: 'SAVE_PERSONAL_SECTION'
                }
            }
        };
        return this.invoke(command, argParams);
    }

    this.SAVE_SECTION = function (argParams) {
        var command = {
            action: 'SAVE_SECTION',
            args: {
                params: {
                    CategoryID: argParams.CategoryID,
                    UserID: argParams.UserID,
                    Name: argParams.Name,
                    action: 'SAVE_INSTANCE_SECTION'
                }
            }
        };
        return this.invoke(command, argParams);
    }

    this.LOAD_DOCUMENT = function (argParams) {
        var command = {
            action: 'LOAD_DOCUMENT',
            args: {
                params: {
                    status: argParams.status,
                    LoadType: argParams.LoadType||""
                },
                InstanceID: argParams.InstanceID,
                actionType: argParams.actionType
            }
        };
        return this.invoke(command, argParams);
    }

    ///保存文档
    this.SAVE_DOCUMENT = function (argParams) {
        argParams = argParams || {};
        var command = {
            action: 'SAVE_DOCUMENT',
            args: {
                params: {
                    action: 'SAVE_DOCUMENT'
                }
            }
        };
        return this.invoke(command, argParams);
    }

    this.DELETE_DOCUMENT = function (argParams) {
        var command = {
            action: 'DELETE_DOCUMENT',
            args: {
                InstanceID: argParams.InstanceID
            }
        };
        return this.invoke(command, argParams);
    }

    ///另存为病历副本   范本病历
    this.SAVE_DOCUMENT_AS = function (argParams) {
        argParams = argParams || {};
        var command = {
            action: 'SAVE_DOCUMENT_AS',
            args: {
                params: {
                    action: 'SAVE_DOCUMENT_AS'
                }
            }
        };
        return this.invoke(command, argParams);
    }

    ///保存签名文档
    this.SAVE_SIGNED_DOCUMENT = function (argParams) {
        var command = {
            action: 'SAVE_SIGNED_DOCUMENT',
            args: {
                params: {
                    action: 'SAVE_SIGNED_DOCUMENT',
                    SignUserID: argParams.SignUserID,
                    SignID: argParams.SignID,
                    SignLevel: argParams.SignLevel,
                    Digest: argParams.Digest,
                    Type: argParams.Type,
                    Path: argParams.Path,
                    ActionType: argParams.ActionType
                },
                InstanceID: argParams.InstanceID
            }
        }
        return this.invoke(command, argParams);
    }

    /// 撤销最后一次签名
    this.UNSIGN_DOCUMENT = function (argParams) {
        var command = {
            action: 'UNSIGN_DOCUMENT',
            args: ''
        };
        return this.invoke(command, argParams);
    }

    this.REVOKE_SIGNED_DOCUMENT = function (argParams) {
        var command = {
            action: 'REVOKE_SIGNED_DOCUMENT',
            args: {
                SignatureLevel: argParams.SignatureLevel,
                InstanceID: argParams.InstanceID,
                "params":{
	                OperatorID:argParams.OperatorID
	             }
            }
        };
        return this.invoke(command, argParams);
    }

    ///获取活动文档上下文
    this.GET_DOCUMENT_CONTEXT = function (argParams) {
        var command = {
            action: 'GET_DOCUMENT_CONTEXT',
            args: {
                InstanceID: argParams.InstanceID || ''
            }
        };
        return this.invoke(command, argParams);
    }

    ///请求目录大纲
    this.GET_DOCUMENT_OUTLINE = function (argParams) {
        var command = {
            action: 'GET_DOCUMENT_OUTLINE',
            args: ''
        }
        return this.invoke(command, argParams);
    }

    ///获取文档是否被修改过
    this.CHECK_DOCUMENT_MODIFY = function (argParams) {
        var command = {
            action: 'CHECK_DOCUMENT_MODIFY',
            args: {
                InstanceID: argParams.InstanceID || ''
            }
        };
        return this.invoke(command, argParams);
    }

    ///同步运行脚本
    this.RUN_SCRIPT = function (argParams) {
        var command = {
            action: 'RUN_SCRIPT',
            args: {
                Script: argParams.Script
            }
        };
        return this.invoke(command, argParams);
    }

    ///标注必填项
    this.MARK_REQUIRED_OBJECTS = function (argParams) {
        var command = {
            action: 'MARK_REQUIRED_OBJECTS',
            args: {
                Mark: argParams.Mark
            }
        };
        return this.invoke(command, argParams);
    }

    ///获取文档摘要
    this.GET_DOCUMENT_DIGEST = function (argParams) {
        var command = {
            action: 'GET_DOCUMENT_DIGEST',
            args: {
                InstanceID: argParams.InstanceID
            }
        };
        return this.invoke(command, argParams);
    }

    ///签名
    this.SIGN_DOCUMENT = function (argParams) {
        var imageZoomRatio = getImageZoomRatio(argParams.Id);
        //患者签名不传图片行高，通过编辑器系统参数设置
        if (argParams.SignatureLevel == "Patient") imageZoomRatio = "";
        //增加参数控制是否压缩图片，患者批注时不压缩图片
        if ((typeof(argParams.IsZoom) == "undefined")||(argParams.IsZoom === "")) {
            var isZoom = true;
        } else {
            var isZoom = argParams.IsZoom;  
        }    
        var command = {
            action: 'SIGN_DOCUMENT',
            args: {
                InstanceID: argParams.InstanceID,
                Type: argParams.Type,
                Path: argParams.Path || '',   //增加单元路径，处理光标改变导致签名失败问题
                SignatureLevel: argParams.SignatureLevel,
                actionType: argParams.actionType,
                Authenticator: {
                    Id: argParams.Id,
                    Name: argParams.Name,
                    Image: argParams.Image,
                    HeaderImage: argParams.HeaderImage,
                    FingerImage: argParams.FingerImage,                    
                    Description: argParams.Description,
                    SignImageZoomRatio: imageZoomRatio,
                    IsZoom: isZoom
                },
                params: {}
            }
        }
        return this.invoke(command, argParams);
    }

    ///定位文档
    this.FOCUS_ELEMENT = function (argParams) {
        var command = {
            action: 'FOCUS_ELEMENT',
            args: {
                Path: argParams.Path,
                InstanceID: argParams.InstanceID || '',
                actionType: argParams.actionType
            }
        }
        return this.invoke(command, argParams);
    }

    ///设置创建模板
    this.SET_DOCUMENT_TEMPLATE = function (argParams) {
        var command = {
            action: 'SET_DOCUMENT_TEMPLATE',
            args: {
                DocID: argParams.DocID,
                IsMutex: argParams.IsMutex,
                CreateGuideBox: argParams.CreateGuideBox,
                KBLoadMode: 'Replace'
            }
        };
        return this.invoke(command, argParams);
    }

    ///插入文本
    this.INSERT_TEXT_BLOCK = function (argParams) {
        var command = {
            action: 'INSERT_TEXT_BLOCK',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }

    this.INSERT_STYLE_TEXT_BLOCK = function (argParams) {
        var command = {
            action: 'INSERT_STYLE_TEXT_BLOCK',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }

    ///插入知识库结点
    this.APPEND_COMPOSITE = function (argParams) {
        var command = {
            action: 'APPEND_COMPOSITE_ADVANCED',
            args: {
                params: {
                    action: 'LOAD_COMPOSITE',
                    KBNodeID: argParams.KBNodeID
                }
            }
        };
        return this.invoke(command, argParams);
    }

    ///替换知识库结点
    this.REPLACE_COMPOSITE = function (argParams) {
        var command = {
            action: 'REPLACE_COMPOSITE',
            args: {
                params: {
                    action: 'LOAD_COMPOSITE',
                    KBNodeID: argParams.KBNodeID
                }
            }
        };
        return this.invoke(command, argParams);
    }

    ///判断当前光标在文档中的位置
    this.GET_ELEMENT_CONTEXT = function (argParams) {
        var command = {
            action: 'GET_ELEMENT_CONTEXT',
            args: {
                Type: argParams.Type
            }
        };
        return this.invoke(command, argParams);
    }
    
    ///判断当前文档的只读状态
    this.GET_READONLY = function (argParams) {
        var command = {
            action: 'GET_READONLY',
            args: {}
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

    ///设置患者信息
    this.SET_PATIENT_INFO = function (argParams) {
        var command = {
            action: 'SET_PATIENT_INFO',
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

    ///获取文档是否被修改过
    this.CHECK_DOCUMENT_MODIFY = function (argParams) {
        var command = {
            action: 'CHECK_DOCUMENT_MODIFY',
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

    ///设置书写状态 "Edit"
    this.SET_NOTE_STATE = function (argParams) {
        var command = {
            action: 'SET_NOTE_STATE',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }

    this.UPDATE_INSTANCE_DATA = function (argParams) {
        var command = {
            action: 'UPDATE_INSTANCE_DATA',
            args: {
                actionType: argParams.actionType,
                InstanceID: argParams.InstanceID || '',
                Path: argParams.Path,
                Value: argParams.Value,
                Other: argParams.Other || []
            }
        };
        return this.invoke(command, argParams);
    }

    /// state: true, false
    this.SET_ASR_VOICE_STATE = function (argParams) {
        var command = {
            action: 'SET_ASR_VOICE_STATE',
            args: {
                Open: argParams.Open
            }
        };
        return this.invoke(command, argParams);
    }

    /// "result":"","ErrorCode":"","ErrorInfo":""
    this.GET_ASR_VOICE_STATE = function (argParams) {
        var command = {
            action: 'GET_ASR_VOICE_STATE'
        };
        return this.invoke(command, argParams);
    }

    /// 刷新引用数据; InterfaceStyle:Web  js弹框，否则插件弹框
    this.REFRESH_REFERENCEDATA = function (argParams) {
        dataObjStr = argParams.AutoRefresh;
        var command = {
            action: 'REFRESH_REFERENCEDATA',
            args: {
                InterfaceStyle:"Web",
                InstanceID: argParams.InstanceID || '',
                AutoRefresh: argParams.AutoRefresh,
                SyncDialogVisible: argParams.SyncDialogVisible
            }
        };
        return this.invoke(command, argParams);
    }

    /// 导出文档
    this.SAVE_LOCAL_DOCUMENT = function (argParams) {
        var command = {
            action: 'SAVE_LOCAL_DOCUMENT',
            args: {}
        };
        return this.invoke(command, argParams);
    }

    /// 设置修改状态
    this.RESET_MODIFY_STATE = function (argParams) {
        var command = {
            action: 'RESET_MODIFY_STATE',
            args: {
                InstanceID: argParams.InstanceID || '',
                State: argParams.State
            }
        };
        return this.invoke(command, argParams);
    }

    /// 设置本次操作痕迹修订者信息
    this.SET_CURRENT_REVISOR = function (argParams) {
        var command = {
            action: 'SET_CURRENT_REVISOR',
            args: {
                Id: argParams.Id,
                Name: argParams.Name,
                IP: argParams.IP
            }
        };
        return this.invoke(command, argParams);
    }

    /// 设置指定文档实例痕迹的跟踪状态（跟踪或取消）
    this.SET_REVISION_STATE = function (argParams) {
        var command = {
            action: 'SET_REVISION_STATE',
            args: {
                InstanceID: argParams.InstanceID || '',
                Mark: argParams.Mark
            }
        };
        return this.invoke(command, argParams);
    }

    /// 显示或隐藏痕迹内容
    this.SET_REVISION_VISIBLE = function (argParams) {
        var command = {
            action: 'SET_REVISION_VISIBLE',
            args: {
                Visible: argParams.Visible
            }
        };
        return this.invoke(command, argParams);
    }

    this.GET_METADATA_TREE = function (argParams) {
        var command = {
            action: 'GET_METADATA_TREE',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///插入图片
    this.INSERT_IMG = function (argParams) {
        var command = {
            action: 'INSERT_IMG',
            args: {
                ImageType: argParams.ImageType,
                ImageData: argParams.ImageData || '',
                ImageId: argParams.ImageId
            }
        };
        return this.invoke(command, argParams);
    }
    
    ///替换图片
    this.REPLACE_IMG = function (argParams) {
        var command = {
            action: 'REPLACE_IMG',
            args: {
                ImageType: argParams.ImageType,
                ImageData: argParams.ImageData
            }
        };
        return this.invoke(command, argParams);
    }
    
    ///编辑图片
    this.EDIT_IMG = function(argParams) {
        var command = {
            action: 'EDIT_IMG',
            args: ''
        }
        return this.invoke(command, argParams);
    }
    
    ///插入新建的牙位图图片
    this.INSERT_TEETH_IMAGE = function (argParams) {
        var command = argParams;
        return this.invoke(command, argParams);
    }
    
    ///(替换牙位图图片) 双击打开已有牙位图，修改牙位信息，重新插入牙位图图片
    this.REPLACE_TEETH_IMAGE = function (argParams) {
        var command = argParams;
        return this.invoke(command, argParams);
    }
    
    ///根据标题创建实例
    this.CREATE_DOCUMENT_BY_TITLE = function (argParams) {
        var command = {
            action: 'CREATE_DOCUMENT_BY_TITLE',
            args: {
                AsLoad: argParams.AsLoad || false,
                TitleCode: argParams.TitleCode || ''
            }
        };
        return this.invoke(command, argParams);
    }
    
    ///刷新权限
    this.UPDATE_PRIVILEGE = function (argParams) {
        var command = {
            action: 'UPDATE_PRIVILEGE',
            args: {
                InstanceID: argParams.InstanceID || ''
            }
        }
        return this.invoke(command, argParams);
    }    
    
    ///模拟双击触发签名单元
    this.TRIGGER_SIGN_ELEMENT = function (argParams) {
        var command = {
            action: 'TRIGGER_SIGN_ELEMENT',
            args: {
                Path: argParams.Path
            }
        };
        return this.invoke(command, argParams);
    }
     ///2021/11/12 Zhangxy 病历缩放
  	this.ZOOM_DOCUMENT = function (zoomScale) {
    	if (!zoomScale) return;
    	var command = {
      		action: "ZOOM_DOCUMENT",
      		args: {
        		zoomType: "PERCENT",
        		zoomScale: zoomScale,
      		},
    	};
    	return this.invoke(command);
  	}    
    /// 插入前房深度公式
    this.EYE = function (argParams) {
        var command = {
            action: 'APPEND_ELEMENT',
            args: {
                Code:"",
                ElemType:"MIMacroObject",
                DisplayName: "深度公式",
                Description: "深度公式",
                MacroType:"macro_eye_deep_grade"
            }
        };
        return this.invoke(command, argParams);
    }   
    ///-------------------编辑按钮-------------------///
    ///字体
    this.FONT_FAMILY = function (argParams) {
        var command = {
            action: 'FONT_FAMILY',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }
    
    ///字号
    this.FONT_SIZE = function (argParams) {
        var command = {
            action: 'FONT_SIZE',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }
    
    ///颜色
    this.FONT_COLOR = function (argParams) {
        var command = {
            action: 'FONT_COLOR',
            args: argParams.args
        };
        return this.invoke(command, argParams);
    }
    
    ///粗体
    this.BOLD = function (argParams) {
        var command = {
            action: 'BOLD',
            args: {
                path: argParams.path || ''
            }
        };
        return this.invoke(command, argParams);
    } 
    
    ///斜体
    this.ITALIC = function (argParams) {
        var command = {
            action: 'ITALIC',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///下划线
    this.UNDER_LINE = function (argParams) {
        var command = {
            action: 'UNDER_LINE',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///删除线
    this.STRIKE = function (argParams) {
        var command = {
            action: 'STRIKE',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///上标
    this.SUPER = function (argParams) {
        var command = {
            action: 'SUPER',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///下标
    this.SUB = function (argParams) {
        var command = {
            action: 'SUB',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///两端对齐
    this.ALIGN_JUSTIFY = function (argParams) {
        var command = {
            action: 'ALIGN_JUSTIFY',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///设置左对齐
    this.ALIGN_LEFT = function (argParams) {
        var command = {
            action: 'ALIGN_LEFT',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///设置居中对齐
    this.ALIGN_CENTER = function (argParams) {
        var command = {
            action: 'ALIGN_CENTER',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///设置右对齐
    this.ALIGN_RIGHT = function (argParams) {
        var command = {
            action: 'ALIGN_RIGHT',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///设置缩进
    this.INDENT = function (argParams) {
        var command = {
            action: 'INDENT',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///设置反缩进
    this.UNINDENT = function (argParams) {
        var command = {
            action: 'UNINDENT',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///剪切
    this.CUT = function (argParams) {
        var command = {
            action: 'CUT',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///复制
    this.COPY = function (argParams) {
        var command = {
            action: 'COPY',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///粘贴
    this.PASTE = function (argParams) {
        var command = {
            action: 'PASTE',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///撤销
    this.UNDO = function (argParams) {
        var command = {
            action: 'UNDO',
            args: ''
        };
        return this.invoke(command, argParams);
    }
    
    ///重做
    this.REDO = function (argParams) {
        var command = {
            action: 'REDO',
            args: ''
        };
        return this.invoke(command, argParams);
    }   
    ///-------------------编辑按钮-------------------///

    ///设置电子病历运行环境参数
    this.SET_RUNEMR_PARAMS=function (argParams) {
        var command = {
            action: argParams.action,
            args:argParams.args || ''
          
        }
        return this.invoke(command, argParams);
    }
    
    /// 获取打印范围内InstanceID
    this.GET_PRINT_DOC_INSTANCEID_LIST = function (argParams) {
        var command = {
            action: 'GET_PRINT_DOC_INSTANCEID_LIST',
            args: {}
          
        }
        return this.invoke(command, argParams);
    }
    
    /// 静默刷新引用数据
    this.SILENT_REFRESH_REFERENCEDATA = function (argParams) {
        var command = {
            action: 'SILENT_REFRESH_REFERENCEDATA',
            args: {
                InstanceID: argParams.InstanceID || ''
            }
        };
        return this.invoke(command, argParams);
    }
    
    /// 获取签名单元数据
    this.GET_SIGNED_INFO = function (argParams) {
        var command = {
            action: 'GET_SIGNED_INFO',
            args: {
                Path: argParams.Path
            }
        };
        return this.invoke(command, argParams);
    }
    
    ///插入个人短语
    this.APPEND_DPCOMPOSITE = function (argParams) {
        var command = {
            action: 'APPEND_COMPOSITE_ADVANCED',
            args: {
                params: {
                    action: 'LOAD_COMPOSITE',
                    KBNodeID: argParams.KBNodeID,
                    Type: argParams.Type
                }
            }
        };
        return this.invoke(command, argParams);
    }
}
function closeEditorDiaglog(args){
    $HUI.dialog('#HisUIInstallPlugin').close();
}
