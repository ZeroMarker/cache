//历次就诊信息
function showAdmHisDetail(flag) {
    if (flag) {
        $('#admHisDetail').panel('resize', {
            height: $('body').height()
        });
        $('#admHisLst').panel('resize', {
            height: 1
        });
        $('body').layout('resize');
    } else {
        $('#admHisLst').panel('resize', {
            height: $('body').height(),
            top: -10
        });
        $('#admHisDetail').panel('resize', {
            height: 1
        });
        $('body').layout('resize');
    }
}

//住院病历浏览
function openRecordBrowse() {
    $HUI.dialog('#admHisDetail').open();
    var lnk = 'emr.browse.emr.csp?EpisodeID='+currentAdmID+'&Action=&ViewType=Editor&MWToken='+getMWToken();
    $('#frameDetail').attr('src', lnk);
    showAdmHisDetail(true);
}

//显示门诊病历详细内容
function showEmrDoc(docParam) {
    //通过浏览权限规则脚本判断是否允许浏览
    if (('' === docParam)||(getViewPrivilege(docParam).canView == '0')) {
        var frame = document.getElementById("frameDetail");
        frame = document.all ? frame.contentWindow.document : frame.contentDocument;
        frame.open();
        frame.write('<body><img src="../scripts/emr/image/icon/noview.png" alt="您没有权限查看当前病历" />');
        frame.write('</body>');
        frame.close();
        showAdmHisDetail(true);
    }else {
        admHisUrl = 'emr.bs.op.browse.csp?documentID='+docParam.documentID+'&pluginType='+docParam.pluginType+'&serial='+docParam.serial+'&leadframe='+docParam.isLeadframe+'&product='+product+'&MWToken='+getMWToken();
        $('#frameDetail').attr('src', admHisUrl);
        //通过权限规则脚本控制是否显示引用按钮
        if (getQuotePrivilege(docParam).canquote == '1') {
            $('#refEmrDoc').show();
            if ("{}" != JSON.stringify(refTemplateID)) {
                $('#refTemplateID').show();
            }
        }
        
        if ('N' !== sysOption.isSwitchHistoryOERecord) {
            $('#prevAdm').show();
            $('#nextAdm').show();
            if (0 == admIDs.length){
                getOEPEpisodeList();
            }
        }
        
        $("#insComboSpan").show();
        showAdmHisDetail(true);
        //自动记录病例操作日志
        parent.hisLog.browse('EMR.OP.AdmHistoryLst.Browse', docParam);
    }
}

//实例集合
var allInstance = "";
var currentIdx = "";
function showHistoryEMR(seq) {
    var args = {
        action: "GET_ALLSAVEDRECORDS",
        params:{
            episodeID: currentAdmID,
            userLocID: userLocID,
            ssgroupID: ssgroupID,
            order: "-1"
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (0 == data.length){
            $.messager.alert('发生错误', '请检查方法getSaveRecords', 'info');
            return;
        }
        var comboData = "";
        allInstance = data;
        for (var idx = 0, len = allInstance.length; idx < len; idx++) {
            if (comboData == "")
            {
                comboData = '{"id":' + idx + ',"text":"' + allInstance[idx].docName + '"}';
            }
            else
            {
                comboData = comboData + ',{"id":' + idx + ',"text":"' + allInstance[idx].docName + '"}';
            }
        };
        comboData = "[" + comboData + "]";
        var comboDataJson = JSON.parse(comboData);

        var insCombo = $HUI.combobox("#insCombo",{
            valueField:'id',
            textField:'text',
            multiple:false,
            selectOnNavigation:false,
            editable:false,
            data: comboDataJson,
            onSelect:function(rec) {
                currentIdx = rec.id;
                showEmrDoc(allInstance[rec.id]);
            },
            onLoadSuccess: function() {
                $("#insCombo").combobox('panel').panel('resize',{height:comboDataJson.length*33});
            }
        });

        if (!(allInstance[0]||'')) {
            currentIdx = 0;
            showEmrDoc('');
        }else {
            if ("last" == seq) {
                insCombo.select(allInstance.length-1);
            }else {
                insCombo.select(seq);
            }
        }
    }, function (error) {
        $.messager.alert("发生错误", "getSaveRecords error:"+error, "error");
    }, false);
}

// 获取实例是否有病历引用权限
function getQuotePrivilege(docParam) {
    var result = '';
    var args = {
        action: "QUOTE_PRIVILEGE",
        params:{
            patientID: patientID,
            episodeID: episodeID,
            userID: userID,
            userLocID: userLocID,
            ssgroupID: ssgroupID,
            documentID: docParam.documentID,
            templateID: docParam.templateID,
            docName: docParam.docName,
            docCode: docParam.docCode
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        result = data;
    }, function (error) {
        $.messager.alert("发生错误", "GetQuotePrivilege error:"+error, "error");
    }, false);
    return result;
}

// 获取病历浏览权限
function getViewPrivilege(docParam) {
    var result = '';
    var args = {
        action: "BROWSE_PRIVILEGE",
        params:{
            patientID: patientID,
            episodeID: episodeID,
            userID: userID,
            userLocID: userLocID,
            ssgroupID: ssgroupID,
            documentID: docParam.documentID,
            templateID: docParam.templateID,
            docName: docParam.docName,
            docCode: docParam.docCode
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        result = data;
    }, function (error) {
        $.messager.alert("发生错误", "getViewPrivilege error:"+error, "error");
    }, false);
    return result;
}

function getOEPEpisodeList() {
    var args = {
        action: "GET_OEPEPISODELISTBYPID",
        params:{
            patientID: patientID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data.length > 0){
            admIDs = data;
        }else{
            $.messager.alert('发生错误', '请检查方法GetOEPEpisodeListByPID', 'info');
        }
    }, function (error) {
        $.messager.alert("发生错误", "getOEPEpisodeList error:"+error, "error");
    }, true);
}

//刷新历史就诊列表
function refreshAdmHistoryList(){
    $('#admHistoryLst').empty();
    getAdmHistory(sysOption.getHistoryDataMethod == 'GET_ALLOPHISTORY' ? '' : episodeID);
}

//加载历史就诊
function getAdmHistory(admID) {
    var args = {
        action: sysOption.getHistoryDataMethod,
        params:{
            patientID: patientID,
            lastEpisodeID: admID,
            userCode: userCode,
            userLocID: userLocID,
            hospitalID: hospitalID,
            ssgroupID: ssgroupID,
            flag: $("input[name='flag']:checked").val(),
            admType: $("input[name='flagAdmType']:checked").val()
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            for (var i = 0, len = data.total; i < len; i++) {
                var row = data.rows[i];
                var div = $('<div class="admDetail"></div>');
                $(div).append(row.record);
                $('#admHistoryLst').append(div);
            }
            //隔行变色
            $('.admDetail:odd').css('background-color', '#E0EEEE');
        }
    }, function (error) {
        $.messager.alert("发生错误", sysOption.getHistoryDataMethod + " error:"+error, "error");
    }, false);
}

$(function () {
    $HUI.dialog('#admHisDetail').close();
    showAdmHisDetail(false);
    //查询条件栏
    $HUI.radio('#Type' + admType).setValue(true);
    $HUI.radio('#Type' + admType).options().checked = true;
    if (admType == "E") {
        $HUI.radio('#CurDept').setValue(true);
        $HUI.radio('#CurDept').options().checked = true;
    }else {
        $HUI.radio('#CurDoc').setValue(true);
        $HUI.radio('#CurDoc').options().checked = true;
    }
    $HUI.radio("[name='flag']",{
        onChecked:function(e,value){
            $('#admHistoryLst').empty();
            getAdmHistory(sysOption.getHistoryDataMethod == 'GET_ALLOPHISTORY' ? '' : episodeID);
        }
    });
    $HUI.radio("[name='flagAdmType']",{
        onChecked:function(e,value){
            $('#admHistoryLst').empty();
            getAdmHistory(sysOption.getHistoryDataMethod == 'GET_ALLOPHISTORY' ? '' : episodeID);
        }
    });
    
    //病历引用功能
    var isClicked = false; 
    $('#refEmrDoc').bind('click', function (evt) {
        if (!isClicked) {
            isClicked = true;
            setTimeout(function () { isClicked = false; }, 2000);
            var idx = $('#insCombo').combobox('getValue');
            //parent.createDocFromInstance(allInstance[idx]);
            var docParam = allInstance[idx];
            docParam.sourceType = "REFERENCE";
            parent.emrService.createDocByDocumentID(docParam);
        }
    });

    if ("{}" != JSON.stringify(refTemplateID)) {
        $('#refTemplateID').bind('click', function () {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                refTemplateID.templateID = refTemplateID.sourceID;
                parent.emrService.createDocByRefTemplateID(refTemplateID,currentAdmID);
            }
        });
    }
    
    //查看病历内容
    $(document).on('click','.emrdoc', function () {
        currentAdmID = $(this).attr('admID');
        if (('O' === $(this).attr('admType'))||('E' === $(this).attr('admType'))) {
            $HUI.dialog('#admHisDetail').open();
            var index = parseInt($(this).attr('index'))
            showHistoryEMR(index);
        }
        else {
            //openRecordBrowse();
        }
    });
    
    if ('N' !== sysOption.isSwitchHistoryOERecord) {
        //查看该患者门(急)诊就诊所书写的上一份病历内容
        $('#prevAdm').bind('click', function () {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                if (0 != currentIdx) {
                    $("#insCombo").combobox('select',currentIdx-1);
                }else {
                    if (0 != admIDs.indexOf(currentAdmID)) {
                        currentAdmID = admIDs[admIDs.indexOf(currentAdmID)-1];
                        showHistoryEMR("last");
                    }else {
                        $.messager.alert('提示', "已经切换至该患者门(急)诊就诊所书写的第一份病历！", 'info');
                    }
                }
            }
        });
        //查看该患者门(急)诊就诊所书写的下一份病历内容
        $('#nextAdm').bind('click', function () {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                if ((allInstance.length > 0)&&((allInstance.length-1) != currentIdx)) {
                    $("#insCombo").combobox('select',currentIdx+1);
                }else {
                    if ((admIDs.length-1) != admIDs.indexOf(currentAdmID)) {
                        currentAdmID = admIDs[admIDs.indexOf(currentAdmID)+1];
                        showHistoryEMR(0);
                    }else {
                        $.messager.alert('提示', "已经切换至该患者门(急)诊就诊所书写的最后一份病历！", 'info');
                    }
                }
            }
        });
    }
    //查看医嘱内容
    $(document).on('click','.oeord', function () {
        $HUI.dialog('#admHisDetail').open();
        var oeordLnk = 'oeorder.opbillinfo.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID') + '&MWToken='+getMWToken();
        $('#frameDetail').attr('src', oeordLnk);
        showAdmHisDetail(true);
    });
    //加载更多
    $('#btnLoadMore').bind('click', function (evt) {
        var records = $('.diag');
        var lastEpisodeID = records.length === 0 ? episodeID : records.last().attr('admID');
        getAdmHistory(lastEpisodeID);
        $('#msg').scrollTop($('#admHistoryLst')[0].scrollHeight);
    });
    //返回就诊列表
    $('#backAdmHistoryLst').bind('click', function () {
        $('#refEmrDoc').hide();
        $('#refTemplateID').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $("#insComboSpan").hide();
        $HUI.dialog('#admHisDetail').close();
        showAdmHisDetail(false);
    });
    $("#insComboSpan").hide();
    //初始化获取数据
    getAdmHistory(sysOption.getHistoryDataMethod == 'GET_ALLOPHISTORY'?'':episodeID);
});
