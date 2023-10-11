function initPlugin() {
    try {
        if (!templatePlugin) {
            templatePlugin = new templatePluginEx(document.getElementById('pluginFrame').contentWindow);
        }
    }catch(err) {
        alert(err.message || err);
    }
}
// 加载模板
function loadTemplate(node) {
    if (loadFlag) {
        return;
    }
    loadFlag = true;
    var docType = node.attributes.documentType;
    var isSetPlugin = setPlugin(docType)
    if(!isSetPlugin) {
        loadFlag = false;
        return;
    }
    if (node.attributes.nodeType == "template") {
        // 基础模板
        if (node.attributes.TemplateVersionId == "isGuideBox") {
            loadFlag = false;
            return;
        }else {
            templatePlugin.SET_TEMPLATE_LOAD_SECTION({
                UserTemplateId: '',
                LoadSection: false
            });
            templatePlugin.LOAD_DOCUMENT({
                action: "LOAD_TEMPLATE",
                TemplateVersionId: node.attributes.TemplateVersionId
            });
        }
    } else if (node.attributes.nodeType == "leaf") {
        // 科室模板
        templatePlugin.SET_TEMPLATE_LOAD_SECTION({
            UserTemplateId: node.attributes.UserTemplateId,
            LoadSection: true
        });
        templatePlugin.LOAD_DOCUMENT({
            action: "LOAD_TEMPLATE",
            TemplateVersionId: node.attributes.TemplateVersionId
        });
    } else if (node.attributes.nodeType == "personal") {
        // 个人模板
        templatePlugin.LOAD_DOCUMENT({
            action: "LOAD_PERSONAL_TEMPLATE",
            ExampleInstanceId: node.id
        });
    }
}

function setPlugin(docType) {
    if (docType === 'DOC') {
        templatePlugin.showWord();
        var isSetPlugin = templatePlugin.attachWord(sysOption.pluginUrl, docType, eventDispatch);
        if(!isSetPlugin) return isSetPlugin;
        var fontStyle = $.parseJSON("{" + sysOption.setDefaultFontStyle.replace(/\'/g, "\"") + "}");
        templatePlugin.SET_DEFAULT_FONTSTYLE({
            args: fontStyle
        });
        templatePlugin.setWorkEnvironment();
        return true;
    } else {
        templatePlugin.showGrid();
        var isSetPlugin = templatePlugin.attachGrid(sysOption.pluginUrl, docType, eventDispatch);
        if(!isSetPlugin) return isSetPlugin;
        templatePlugin.setWorkEnvironment();
        return true;
    }
    
}

function eventDispatch(commandJson) {
    if (commandJson.action == "eventLoadDocument") {
        eventLoadDocument(commandJson);
    }else if (commandJson.action == "eventSetTemplateLoadSection") {
        eventSetTemplateLoadSection(commandJson);
    }
}

function eventLoadDocument(commandJson) {
    loadFlag = false;
    if (commandJson["args"]["result"] != "OK")
    {
        alert('模板加载失败');
    }
    templatePlugin.SET_READONLY({
        ReadOnly: true
    });
}

function eventSetTemplateLoadSection(commandJson) {
    if (commandJson["args"]["result"] != "OK"){
        alert('病历模板-组合章节数据加载失败!');
    }
}
