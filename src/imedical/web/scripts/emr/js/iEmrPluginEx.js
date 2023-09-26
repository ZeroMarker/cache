/// 对编辑器的命令进行包装，不包含业务逻辑
var iEmrPlugin;
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
            try {
                return $.parseJSON(result);  
            } catch (err) {
                return {result: result};
            }
        } else {
            ///异步执行execute
            plugin.execute(JSON.stringify(command));
        }
    }

    var _pluginWord;
    var _pluginWordStatus = false;
    this.attachWord = function (pluginUrl, pluginType, argConnect, fnEvtDispatch) {
        _pluginType = pluginType;
        if (!_pluginWord) {
            var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
            objString += "<param name='install-url' value='";
            objString += pluginUrl;
            objString += "'/></object>";
            _pluginWord = edtorFrame.attachWord(objString);
            if (!_pluginWord.initWindow) {
                this.setUpPlug(pluginUrl);
            }
        }
        if (!_pluginWordStatus) {
            _pluginWordStatus = _pluginWord.initWindow("iEditor") || false;
            if (!_pluginWordStatus) {
                throw ('Word编辑器创建失败!');
                return;
            }
            this.pluginAdd(fnEvtDispatch);
            var ret = this.SET_NET_CONNECT({
                args: argConnect,
                isSync: true
            });
            if ('' != ret && 'OK' != ret.result)
                alert('数据库连接失败,请检查连接参数!');
        }
    }

    var _pluginGrid;
    var _pluginGridStatus = false;
    this.attachGrid = function (pluginUrl, pluginType, argConnect, fnEvtDispatch) {
        _pluginType = pluginType;
        if (!_pluginGrid) {
            var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
            objString += "<param name='install-url' value='";
            objString += pluginUrl;
            objString += "'/></object>";
            _pluginGrid = edtorFrame.attachGrid(objString);
            if (!_pluginGrid.initWindow) {
                this.setUpPlug(pluginUrl);
            }
        }
        if (!_pluginGridStatus) {
            _pluginGridStatus = _pluginGrid.initWindow("iGridEditor") || false;
            if (!_pluginGridStatus) {
                throw ('Grid编辑器创建失败!');
                return;
            }
            this.pluginAdd(fnEvtDispatch);
            var ret = this.SET_NET_CONNECT({
                args: argConnect,
                isSync: true
            });
            if ('OK' != ret.result)
                alert('数据库连接失败,请检查连接参数!');
        }
    }

    this.getPlugin = function () {
        if (_pluginType === 'DOC') {
            if (_pluginWordStatus)
                return _pluginWord;
        } else if (_pluginType === 'GRID') {
            if (_pluginGridStatus)
                return _pluginGrid;
        }
    }

    ///安装插件提示
    this.setUpPlug = function (pluginUrl) {
        var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl=" + pluginUrl, "", "dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
        if (result) {
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
    this.SET_NET_CONNECT = function (argParams) {
	    var netConnect="";
	    /*
        var command = {
            action: 'SET_NET_CONNECT',
            args: argParams.args

        };
        return this.invoke(command, argParams);
        */
        $.ajax({
			type: 'Post',
			dataType: 'text',
			url: '../EMRservice.Ajax.common.cls',
			async:  false,
			cache: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLSysOption",
				"Method":"GetNetConnectJson"
			},
			success: function (ret) {
				ret=$.parseJSON(ret.replace(/\'/g,"\""));
				argParams.args.Params=ret.Params;
	 		
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
            args: argParams.args

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
                PrintMode: argParams.PrintMode || "All",
                CopyCount:argParams.CopyCount || '1'
            }
        };
        return this.invoke(command, argParams);
    }

    ///创建文档
    this.CREATE_DOCUMENT = function (argParams) {
        var command = {
            action: 'CREATE_DOCUMENT',
            args: {
                AsLoad: argParams.AsLoad,
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
                    AsLoad: argParams.AsLoad
                }
            };
        }
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
                    status: argParams.status
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
                SignElementPath: argParams.SignElementPath || ''
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
        var command = {
            action: 'SIGN_DOCUMENT',
            args: {
                InstanceID: argParams.InstanceID,
                Type: argParams.Type,
                SignatureLevel: argParams.SignatureLevel,
                actionType: argParams.actionType,
                Authenticator: {
                    Id: argParams.Id,
                    Name: argParams.Name,
                    Image: argParams.Image,
                    HeaderImage: argParams.HeaderImage,
                    FingerImage: argParams.FingerImage,                    
                    Description: argParams.Description
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
                CreateGuideBox: argParams.CreateGuideBox
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
                SectionCode: argParams.SectionCode || '',
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

    ///设置只读
    this.SET_READONLY = function (argParams) {
        var command = {
            action: 'SET_READONLY',
            args: {
                ReadOnly: argParams.ReadOnly  //,
                //InstanceID: argParams.InstanceID || ''
            }
        };
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
                Value: argParams.Value
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

    /// 刷新引用数据
    this.REFRESH_REFERENCEDATA = function (argParams) {
        var command = {
            action: 'REFRESH_REFERENCEDATA',
            args: {
                InstanceID: argParams.InstanceID || '',
                AutoRefresh: argParams.AutoRefresh,
                SyncDialogVisible: argParams.SyncDialogVisible,
                SilentRefresh : argParams.SilentRefresh || false
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

    ///获取文档结构
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
                ImageData: argParams.ImageData
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
                AsLoad: argParams.AsLoad,
                TitleCode: argParams.TitleCode || ''
            }
        };
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
}
