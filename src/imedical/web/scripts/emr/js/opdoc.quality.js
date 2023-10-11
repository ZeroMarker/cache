var quality = {
    //参数控制是否检查为空单元
    requiredObject: function (action) {
        if ('GRID' === sysOption.pluginType && '0' === sysOption.requiredFlag.Grid) {
            return false;
        } else if ('DOC' === sysOption.pluginType && '0' === sysOption.requiredFlag.Word) {
            return false;
        }

        var ret = iEmrPlugin.MARK_REQUIRED_OBJECTS({
                Mark: true,
                isSync: true
            });
            
        var msgType = "error";
        if (action == "Save") msgType = "info";
        if (ret && ret.result == 'OK' && ret.MarkCount > 0) {
            showEditorMsg({msg: '有未完成项目！',type: msgType});
            return true;
        }

        return false;
    },
    //文档保存质控 保存质控单提示使用
    saveChecker : function (insID) {
        //打散数据质控
        var eventType = "Save^" + patInfo.SsgroupID + "^" + patInfo.UserLocID;
        var templateId;
        common.getTemplateIDByInsId(insID, function (tmpId) {
            templateId = tmpId;
        });

        this.qualityCheck(patInfo.EpisodeID, insID, templateId, eventType);
    },
    //签名质控
    signChecker : function (documentContext) {
        //必填项校验
        if (this.requiredObject('Sign')) {
            return false;
        }
        var eventType = "Commit^" + patInfo.SsgroupID + "^" + patInfo.UserLocID;
        var insID = documentContext.InstanceID;
        var templateId;
        common.getTemplateIDByInsId(insID, function (tmpId) {
            templateId = tmpId;
        });        

        return this.qualityCheck(patInfo.EpisodeID, insID, templateId, eventType);
    },
    //打印质控
    printChecker : function (documentContext) {
        //脚本检查
        if (this.requiredObject('Print')) {
            return false;
        }

        //病历质控
        var eventType = "Print^" + patInfo.SsgroupID + "^" + patInfo.UserLocID;
        var insID = documentContext.InstanceID;
        var templateId;
        common.getTemplateIDByInsId(insID, function (tmpId) {
            templateId = tmpId;
        });
        
        return this.qualityCheck(patInfo.EpisodeID, insID, templateId, eventType);
    },
    //质控 通过返回true，有问题返回false
    qualityCheck : function (episodeId, instanceId, templateId, eventType) {
        //return '';
        var result = '';
        var data = ajaxDATA('String', 'web.eprajax.qualitycheck', 'GetQualityCheck', episodeId, eventType, templateId, instanceId);
        ajaxGETSync(data, function (ret) {
            //debugger;
            result = ret;
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetQualityCheck error:' + ret, 'error');
            alert('GetQualityCheck error:' + ret);
        });  

        if (result !== '') {
            var pos = result.indexOf('^');
            // controlType === 0 是强制类型，返回false
            var controlType = result.substring(0, pos);
            var strQualityData = result.substring(pos + 1);
            if (strQualityData !== '') {
                //$.messager.alert('提示', 'quality saveChecker:' + strQualityData, 'info');
                //alert('质控提示:\r\n' + strQualityData.replace(/;/g, '\r\n'));
                $.messager.alert('提示', '质控提示:<br/>' + strQualityData.replace(/;/g, '<br/>') + '<br/>', 'info');
                return controlType !== '0';
            } else
                return true;
        }
        
        return true;
    }
};
