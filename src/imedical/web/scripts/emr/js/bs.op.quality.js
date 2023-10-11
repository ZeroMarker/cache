var quality = {
    // 必填项检查
    requiredObject: function () {
        if ("Y" != sysOption.requiredFlag) {
            return false;
        }
        var ret = EmrEditor.syncExecute({
            action: "MARK_REQUIRED",
            params: 1, // 1 显示必填项;0 隐藏必填项;
            product: envVar.product
        });
        if (ret && ("fail" != ret.result) && (ret.params > 0)) {
            showEditorMsg({msg: "有未完成项目！",type:"info"});
            return true;
        }
        return false;
    },
    // 文档保存质控
    saveChecker: function (documentID){
        var eventType = "Save^" + patInfo.ssgroupID + "^" + patInfo.userLocID;
        return this.qualityCheck(documentID, eventType);
    },
    // 签名质控
    signChecker: function (documentID) {
        if (this.requiredObject()){
            return true;
        }
        var eventType = "Commit^" + patInfo.ssgroupID + "^" + patInfo.userLocID;
        return this.qualityCheck(documentID, eventType);
    },
    // 打印质控
    printChecker: function (documentID) {
        if (this.requiredObject()){
            return true;
        }
        var eventType = "Print^" + patInfo.ssgroupID + "^" + patInfo.userLocID;
        return this.qualityCheck(documentID, eventType);
    },
    // 质控 通过返回 false，有问题返回 true
    qualityCheck: function (documentID, eventType){
        var rtn = false;
        var data = {
            action: "QUALITY_CHECK",
            params:{
                episodeID: patInfo.episodeID,
                documentID: documentID,
                eventType: eventType
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(qualityData){
            if (qualityData){
                if (qualityData.total > 0){
                    var controlType = qualityData.controlType;
                    if ("0" === controlType){
                        rtn = true;
                    }
                    var qualityContent = '<iframe id="qualityFrame" src="" lnk="dhc.emr.quality.runtimequalitylist.csp?EpisodeID='+qualityData.episodeID+"&EventType="+qualityData.eventType+"&TemplateID="+qualityData.templateID+"&key="+qualityData.key+"&MWToken="+getMWToken()+'" style="width:100%; height:100%;overflow:hidden;" scrolling="no" frameborder="0" refreshOnSelect="Y"></iframe>';
                    var tabData = {
                        id: "qualityFrame",
                        title: "质控提示",
                        content: qualityContent,
                        fit:true,
                        closable: true,
                        selected: true
                    };
                    HisTools.dataTabs.addQualityTab("质控提示",tabData);
                }
            }
        }, function (error) {
            $.messager.alert("发生错误", "qualityCheck error:"+error, "error");
        }, false);
        return rtn;
    }
};