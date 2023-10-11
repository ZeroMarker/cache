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
            height: $('body').height()
        });
        $('#admHisDetail').panel('resize', {
            height: 1
        });
        $('body').layout('resize');
    }
}

function openWindow(name, lnk) {
    
    var iWidth = screen.availWidth - 800;
    var iHeight = screen.availHeight - 400;
    var iTop = 250;
    var iLeft = 330;
    //var iLeft = (window.screen.availWidth - iWidth);
    //var iTop = (window.screen.availWidth - iHeight);
    if (judgeIsIE()){
        window.open(lnk, name, 'height=' + iHeight + ',width=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes');
    }else{
        parent.createWindow("admHistoryWindow",name,lnk,iWidth + 400,iHeight + 200,50,150);
    }
}

//住院病历浏览
function openRecordBrowse(patientID, episodeID) {
    if ('N' == OPDisplayWindow) {
        $HUI.dialog('#admHisDetail').open();
        var lnk = 'emr.browse.emr.csp?EpisodeID='+episodeID+'&Action=externalapp&ViewType=Editor&OPHistoryDefaultSelectDocID=' + OPHistoryDefaultSelectDocID + '&MWToken=' + getMWToken();
        $('#frameDetail').attr('src', lnk);
        showAdmHisDetail(true);
    }else {
        //河南中医药大学第一附属医院项目历史就诊病历弹窗显示
        var lnk = 'emr.browse.emr.csp?EpisodeID='+episodeID+'&Action=externalapp&ViewType=Editor&OPHistoryDefaultSelectDocID=' + OPHistoryDefaultSelectDocID + '&MWToken=' + getMWToken();
        openWindow('recordbrowse', lnk);
    }
}

//显示门诊病历详细内容
function showEmrDoc(insData) {
    //通过浏览权限规则脚本判断是否允许浏览
    if ((''===insData)||(getViewPrivilege(insData).canView == '0')) {
        var frame = document.getElementById("frameDetail");
		frame = document.all ? frame.contentWindow.document : frame.contentDocument;
		frame.open();
		frame.write('<body><img  src="../scripts/emr/image/icon/noview.png"  alt="您没有权限查看当前病历" />');
		frame.write('</body>');
		frame.close();
        showAdmHisDetail(true);
    } else {
	    admHisUrl = 'emr.record.browse.browsform.editor.csp?VisitType=OP&'; //id=2461||1&chartItemType=Single&pluginType=DOC
        var src = admHisUrl + 'id=' + insData.id + '&chartItemType=' + insData.chartItemType + '&pluginType=' + insData.pluginType + '&Action=externalapp&MWToken=' + getMWToken();
	    $('#frameDetail').attr('src', src);
	    //通过权限规则脚本控制是否显示引用按钮
	    if (getQuotePrivilege(insData).canquote == '1') {
	        $('#refEmrDoc').show();
            if ('' != refEmrLastDocID) {
                $('#refEmrLastDoc').show();
            }
	    }
        
        if ('N' !== isSwitchHistoryOERecord) {
        	$('#prevAdm').show();
        	$('#nextAdm').show();
    	}
        
	    $("#insComboSpan").show();
	    showAdmHisDetail(true);
	    //自动记录病例操作日志
	    parent.hisLog.browse('EMR.OP.AdmHistoryLst.Browse', insData);
	}
}

//实例集合
var allInstance = "";
var currentIdx = "";
function showHistoryEMR(adm,seq) {
    var data = ajaxDATA('String', 'EMRservice.BL.opInterface',
            'getAllInstance', userLocID, ssgroupID, adm, userID);
    ajaxGET(data, function (ret) {
        if (ret === '')
            return;
        var comboData = "";
        allInstance = $.parseJSON(ret);
        for (var idx = 0, len = allInstance.length; idx < len; idx++) {
            if (comboData == "")
            {
                comboData = '{"id":' + idx + ',"text":"' + allInstance[idx].text + '"}';
            }
            else
            {
                comboData = comboData + ',{"id":' + idx + ',"text":"' + allInstance[idx].text + '"}';
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
                currentIdx = rec.id;
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
    }, function (ret) {
        $.messager.alert('发生错误', 'getAllInstance:' + ret, 'info');
    });
}

/// 济宁使用集成平台的页面
function showxmlpreview(adm) {
    var oeordLnk = 'dhctt.xmlpreview.csp?xmlName=EMRPreview&EpisodeID='+adm;
    $('#frameDetail').attr('scrolling', 'yes').attr('src', oeordLnk);
    showAdmHisDetail(true); 
}

function showOPEMR(adm,seq) {
    if ('showHistoryEMR' == showHistoryEMRmethod) {
        showHistoryEMR(adm,seq);
    }
    else if ('showxmlpreview' == showHistoryEMRmethod){
        showHistoryEMR1(adm);
    }
}

// 获取实例是否有病历引用权限
function getQuotePrivilege(insData) {
    var result = '';
    var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetQuotePrivilege', userID, userLocID, ssgroupID, episodeID, patientID, insData.id);
    ajaxGETSync(data, function (ret) {
        result = $.parseJSON(ret);
    }, function (ret) {
        $.messager.alert('提示', 'GetQuotePrivilege error:' + ret, 'info');
    });
    return result;
}

function GetRecodeParam(emrTmplCateid, func) {
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParam', emrTmplCateid);
    ajaxGET(data, function (ret) {
        func($.parseJSON(ret));
    }, function (ret) {
        $.messager.alert('提示', 'GetRecodeParam error:' + ret, 'info');
    });

}

// 获取病历浏览权限
function getViewPrivilege(insData) {
    var result = '';
    var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetBrowsePrivilege', userID, userLocID, ssgroupID, episodeID, patientID, insData.id);
    ajaxGETSync(data, function (ret) {
        result = $.parseJSON(ret);
    }, function (ret) {
        $.messager.alert('提示', 'getViewPrivilege error:' + ret, 'info');
    });
    return result;
}

var admIDs = "";
function getOEPEpisodeList() {
    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetOEPEpisodeListByPID', patientID);
    ajaxGET(data, function (ret) {
        if ("" == ret) 
        {
	        $.messager.alert('发生错误', '请检查方法GetOEPEpisodeListByPID', 'info');
        }
        admIDs = ret.split(",");
    }, function (err) {
        $.messager.alert('发生错误', 'GetOEPEpisodeListByPID:' + err.message || err, 'info');
    });
}
//刷新历史就诊列表
function refreshAdmHistoryList(){
    $('#admHistoryLst').empty();
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
}
var getAdmHistory = "";
var currentAdmID = "";
$(function () {
    $HUI.dialog('#admHisDetail').close();
    //判断IE浏览器版本 add By Lina 2017-01-19
    if($.browser.version == '11.0')
    {
        document.documentElement.className ='ie11';
    }
    //加载历史就诊
    getAdmHistory = function (patID, admID, ctloc) {
        function appendDetail(data) {
            for (var i = 0, len = data.total; i < len; i++) {
                var row = data.rows[i];
                var div = $('<div class="admDetail"></div>');
                $(div).append(row.record);
                $('#admHistoryLst').append(div);
            }
            //隔行变色
            $('.admDetail:odd').css('background-color', '#E0EEEE');
        }

        if ($('#stdpnl').length > 0) {
            return function (patID, admID) {
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface',
                        GetOPHistoryMethod, patID,
                        $("input[name='flag']:checked").val(), admID,
                        $("input[name='flagAdmType']:checked").val(), "HISUI");
                ajaxGETSync(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (err) {
                    $.messager.alert('发生错误', GetOPHistoryMethod + ':' + err.message || err, 'info');
                    
                });
            }
        } else { //广西医大使用
            return function (patID, admID, ctloc) {
                ctloc = ctloc || $('#cbxLoc').combobox('getValue');
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface',
                        'GetOPHistoryByDateLoc', patID,
                        '', admID, '',
                        $('#startDate').datebox('getText'),
                        $('#endDate').datebox('getText'),
                        ctloc);
                ajaxGETSync(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (ret) {
                    $.messager.alert('发生错误', 'GetOPHistoryByDateLoc:' + ret, 'info');
                });
            }
        }
    }
    ();
    //查询条件栏
    if ($('#stdpnl').length > 0) {
        $HUI.radio('#Type' + admType).setValue(true);
        $HUI.radio('#Type'+admType).options().checked = true;
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
                getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
            }
        });
        $HUI.radio("[name='flagAdmType']",{
            onChecked:function(e,value){
                $('#admHistoryLst').empty();
                getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
            }
        });
        
    } else if ($('#ctlocpnl').length > 0) { //广西医大使用
        $('#startDate').datebox({
            //value : (new Date()).toLocaleDateString()
        });
        $('#endDate').datebox({
            //value : (new Date()).toLocaleDateString()
        });
        $("#PatientListQuery").click(function () {
            $('#admHistoryLst').empty();
            getAdmHistory(patientID, '');
        });
        //支持大小写字母查询科室
        $('#cbxLoc').combobox({
            url: '../EMRservice.Ajax.hisData.cls?Action=GetCTLocListNew',
            valueField: 'Id',
            textField: 'Text',
            filter: function (q, row) {
                var opts = $(this).combobox('options');
                return row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) == 0;
            }
        });
    }
    //病历引用功能
    var isClicked = false; 
    $('#refEmrDoc').bind('click', function (evt) {
        if (!isClicked) {
            isClicked = true;
            setTimeout(function () { isClicked = false; }, 2000);
            var idx = $('#insCombo').combobox('getValue');
            //alert(idx);
            parent.createDocFromInstance(allInstance[idx]);
        }
    });

    if ('' != refEmrLastDocID) {
        $('#refEmrLastDoc').bind('click', function () {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                parent.createEmrLastDocFromInstance(refEmrLastDocID,currentAdmID);
            }
        });
    }
    
    /*
    //病历实例下拉菜单
    $("#insCombo").change(function () {
        showEmrDoc(allInstance[$(this).val()]);
    });
    */
    //查看病历内容
    $(document).on('click','.emrdoc', function () {
        //showOPEMR($(this).attr('admID')); return;  //test
        currentAdmID = $(this).attr('admID');
        if (('O' === $(this).attr('admType'))||('E' === $(this).attr('admType'))) {
            if ('N' == OPDisplayWindow) {
                $HUI.dialog('#admHisDetail').open();
                var index = parseInt($(this).attr('index'))
                showOPEMR($(this).attr('admID'), index);
                if ('' == admIDs) getOEPEpisodeList();
            }else{
                windowArgs = {
                    patientID: patientID,
                    userLocID: userLocID,
                    ssgroupID: ssgroupID,
                    userID: userID,
                    admID: $(this).attr('admID'),
                    refEmrLastDocID:refEmrLastDocID,
                    refEmrDocCallback: function(idx) {
                        parent.createDocFromInstance(idx);
                    },
                    refEmrLastDocCallback: function(emrDocId,lastAdm) {
                        parent.createEmrLastDocFromInstance(emrDocId,lastAdm);
                    },
                    hisLog: function(hisLogType,insData) {
                        parent.hisLog.browse(hisLogType, insData);
                    }
                };
                var lnk = 'emr.opdoc.history.window.csp';
                if (!judgeIsIE()){
                    parent.envVar.hisuiWindowArgs = windowArgs;
                }
                openWindow('历史就诊病历显示页面', lnk);
            }
        }
        else {
            openRecordBrowse(patientID, $(this).attr('admID'));
        }
    });
    
    if ('N' !== isSwitchHistoryOERecord) {
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
                        showOPEMR(currentAdmID,"last");
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
                        showOPEMR(currentAdmID, 0);
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
        var oeordLnk = 'oeorder.opbillinfo.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID');
        $('#frameDetail').attr('src', oeordLnk);
        showAdmHisDetail(true);
    });
    $(document).on('click','.oeordEMR', function () {
        $HUI.dialog('#admHisDetail').open();
        var oeordLnk = 'emr.op.oeorddata.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID') + '&ssgroupID=' + ssgroupID;
        $('#frameDetail').attr('src', oeordLnk);
        showAdmOeOrd(true);
    });
    /*
    //南方医院，在列表界面进行引用
    $('.refDoc').live('click', function () {
        var admID = $(this).attr('admID');
        var insID = $(this).attr('insID');
        var emrDocID = $(this).attr('emrDocID');
        common.GetRecodeParam(emrDocID, function (tempParam) {//alert('tempParam'+ insID);
            tempParam['id']=insID;
            parent.createDocFromInstance(tempParam);
        });
    });    
    */
    //加载更多
    $('#btnLoadMore').bind('click', function (evt) {
        //alert("加载更多");
        var records = $('.diag');
        var lastEpisodeID = records.length === 0 ? episodeID : records.last().attr('admID');
        //alert(lastEpisodeID);
        getAdmHistory(patientID, lastEpisodeID);
        $('#msg').scrollTop($('#admHistoryLst')[0].scrollHeight);
    });
    //返回就诊列表
    $('#backAdmHistoryLst').bind('click', function () {
        $('#refEmrDoc').hide();
        $('#refEmrLastDoc').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $("#insComboSpan").hide();
        $HUI.dialog('#admHisDetail').close();
        showAdmHisDetail(false);
    });
    $("#insComboSpan").hide();
    //初始化获取数据
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll'?'':episodeID);
});
