var quality = {
    //参数控制是否检查为空单元
    requiredObject: function () {
        if ('GRID' === sysOption.pluginType && '0' === sysOption.requiredFlag.Grid) {
            return false;
        } else if ('DOC' === sysOption.pluginType && '0' === sysOption.requiredFlag.Word) {
            return false;
        }

        var ret = iEmrPlugin.MARK_REQUIRED_OBJECTS({
                Mark: true,
                isSync: true
            });
        if (ret && ret.result == 'OK' && ret.MarkCount > 0) {
            $.messager.popover({msg: '有未完成项目！',type:'info',style:{top:10,right:5}});
            //showEditorMsg('有未完成项目！', 'alert');
            return true;
        }

        return false;
    },
    //文档保存质控 未通过 false; 通过 true
    saveChecker : function (documentContext) {
        
        if (documentContext.result === 'ERROR') 
            return false;
        //必填项校验
        if (this.requiredObject()) {
            return false;
        }
        //打散数据质控
        var eventType = "Save^" + patInfo.SsgroupID + "^" + patInfo.UserLocID;
        var insID = documentContext.InstanceID;
        var templateId;
        common.getTemplateIDByInsId(insID, function (tmpId) {
            templateId = tmpId;
        });

        return this.qualityCheck(patInfo.EpisodeID, insID, templateId, eventType);
    },
    //签名质控
    signChecker : function (documentContext) {
        //必填项校验
        if (this.requiredObject()) {
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
        if (this.requiredObject()) {
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
                alert('quality saveChecker:' + strQualityData);
                return controlType !== '0';
            } else
                return true;
        }
        
        return true;
    }
};
