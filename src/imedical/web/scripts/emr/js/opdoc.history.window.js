var patientID = opener?opener.patientID:envVar.hisuiWindowArgs.patientID;
var episodeID = opener?opener.windowArgs.admID:envVar.hisuiWindowArgs.admID;
var userLocID = opener?opener.userLocID:envVar.hisuiWindowArgs.userLocID;
var ssgroupID = opener?opener.ssgroupID:envVar.hisuiWindowArgs.ssgroupID;
var userID = opener?opener.userID:envVar.hisuiWindowArgs.userID;
var showHistoryEMRmethod = 'showHistoryEMR';  //济宁使用 showxmlpreview
var refEmrLastDocID = opener?opener.windowArgs.refEmrLastDocID:envVar.hisuiWindowArgs.refEmrLastDocID;
$(function () {
    //病历引用功能
    var isClicked = false;
    $('#refEmrDoc').bind('click', function (evt) {
        if (!isClicked) {
            isClicked = true;
            setTimeout(function ()  { isClicked =  false; },  2000);
            var idx = $('#insCombo').combobox('getValue');
            if (judgeIsIE()){
                opener.windowArgs.refEmrDocCallback(allInstance[idx]);
            }else{
                envVar.hisuiWindowArgs.refEmrDocCallback(allInstance[idx]);
            }
        }
    });
    if ('' != refEmrLastDocID) {
        $('#refEmrLastDoc').bind('click', function (evt) {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                if (judgeIsIE()){
                    opener.windowArgs.refEmrLastDocCallback(refEmrLastDocID,episodeID);
                }else{
                    envVar.hisuiWindowArgs.refEmrLastDocCallback(refEmrLastDocID,episodeID);
                }
            }
        });
    }
    showOPEMR(episodeID);
});

//显示门诊病历详细内容
function showEmrDoc(insData) {
    if (getViewPrivilege(insData).canView == '0') {
        var Viewblank = 'emr.blank.csp?info=OPCannotView&MWToken='+getMWToken();
        $('#frameDetail').attr('src', Viewblank);
    }else {
        if (''===insData) return;
        admHisUrl = 'emr.record.browse.browsform.editor.csp?VisitType=OP&'; //id=2461||1&chartItemType=Single&pluginType=DOC
        var src = admHisUrl + 'id=' + insData.id + '&chartItemType=' + insData.chartItemType + '&pluginType=' + insData.pluginType + '&MWToken=' + getMWToken();
        $('#frameDetail').attr('src', src);
        //通过权限规则脚本控制是否显示引用按钮
        if (getQuotePrivilege(insData).canquote == '1') {
            $('#refEmrDoc').show();
            if ('' != refEmrLastDocID) $('#refEmrLastDoc').show();
        }
        $("#insComboSpan").show();
        //自动记录病例操作日志
        if (judgeIsIE()){
            opener.windowArgs.hisLog('EMR.OP.AdmHistoryLst.Browse', insData);
        }else{
            envVar.hisuiWindowArgs.hisLog('EMR.OP.AdmHistoryLst.Browse', insData);
        }
    }
}
//实例集合
var allInstance = {};
function showHistoryEMR(adm) {
    var data = ajaxDATA('String', 'EMRservice.BL.opInterface',
            'getAllInstance', userLocID, ssgroupID, adm, userID);
    ajaxGET(data, function (ret) {
        if (ret === '')
            return;
        allInstance = {};
        var comboData = "";
        var insData = $.parseJSON(ret);
        for (var idx = 0, len = insData.length; idx < len; idx++) {
            var tmpl = insData[idx];
            allInstance[idx] = tmpl;
            if (comboData == "")
            {
                comboData = '{"id":"' + idx + '","text":"' + tmpl.text + '"}';
            }
            else
            {
                comboData = comboData + ',{"id":"' + idx + '","text":"' + tmpl.text + '"}';
            }
        };
        comboData = "[" + comboData + "]";
        var comboDataJson = JSON.parse(comboData);

        var insCombo = $HUI.combobox("#insCombo",{
            valueField:'id',textField:'text',multiple:false,selectOnNavigation:false,editable:false,
            data:comboDataJson,
            onShowPanel:function(){
                document.getElementById("admHisPnl").style.visibility="hidden";
            },
            onHidePanel:function(){
                document.getElementById("admHisPnl").style.visibility="visible";
            },
            onSelect:function(rec) {
                showEmrDoc(allInstance[rec.id]);
            },
            onLoadSuccess: function() {
                $("#insCombo").combobox('panel').panel('resize',{height:comboDataJson.length*33});
            }
        });
    
        var prop = function (n){return n&&n.constructor==Number?n+'px':n;}
        var t1 = insCombo.panel();
        var str = '<iframe frameborder="1" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
        str += 'top:0px;left:-2px;width:'+prop(t1.css("width") + 2)+';height:'+prop(t1.css("height"))+';"/>';
        t1.append(str);

        insCombo.select(0);
        showEmrDoc(allInstance[0]||'');
    }, function (ret) {
        alert('发生错误', 'getAllInstance:' + ret);
    });
}

/// 济宁使用集成平台的页面
function showxmlpreview(adm) {
    $('#insComboSpan').hide();
    var oeordLnk = 'dhctt.xmlpreview.csp?xmlName=EMRPreview&EpisodeID='+adm+'&MWToken='+getMWToken();
    $('#frameDetail').attr('scrolling', 'yes').attr('src', oeordLnk);
}

function showOPEMR(adm) {
    if ('showHistoryEMR' == showHistoryEMRmethod) {
        showHistoryEMR(adm);
    }
    else if ('showxmlpreview' == showHistoryEMRmethod){
        showxmlpreview(adm);
    }
}

// 获取实例是否有病历引用权限
function getQuotePrivilege(insData) {
    var result = '';
    var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetQuotePrivilege', userID, userLocID, ssgroupID, episodeID, patientID, insData.id);
    ajaxGETSync(data, function (ret) {
        result = $.parseJSON(ret);
    }, function (ret) {
        alert('GetQuotePrivilege error:' + ret);
    });
    return result;
}

// 获取模板加载权限
function getViewPrivilege(insData) {
    var result = '';
    var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetLoadPrivilege', userID, userLocID, ssgroupID, episodeID, patientID, insData.id);
    ajaxGETSync(data, function (ret) {
        result = $.parseJSON(ret);
    }, function (ret) {
        alert('getViewPrivilege error:' + ret);
    });
    return result;
}

