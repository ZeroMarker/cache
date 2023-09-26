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
    
    var iWidth = screen.availWidth - 10;
    var iHeight = screen.availHeight - 50;
    var iTop = 0;
    var iLeft = 0;
    var iLeft = (window.screen.availWidth - iWidth) / 2;

    window.open(lnk, 'recordbrowse', 'height=' + iHeight + ',width=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes');
}
//打开病历浏览
function openRecordBrowse(patientID, episodeID) {
    var lnk = 'emr.record.browse.csp?EpisodeID=' + episodeID + '&PatientID=' + patientID;
    openWindow('recordbrowse', lnk);
}
//显示门诊病历详细内容
function showEmrDoc(insData) {
    if (''===insData) return;
    admHisUrl = 'emr.record.browse.browsform.editor.csp?VisitType=OP&'; //id=2461||1&chartItemType=Single&pluginType=DOC
    var src = admHisUrl + 'id=' + insData.id + '&chartItemType=' + insData.chartItemType + '&pluginType=' + insData.pluginType;
    $('#frameDetail').attr('src', src);
    if ('Y' !== OPEnableReference) {
        $('#refEmrDoc').hide();
    }
    $('#insCombo').show();
    showAdmHisDetail(true);
    //自动记录病例操作日志
    parent.hisLog.browse('EMR.OP.AdmHistoryLst.Browse', insData);
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
        var insCombo = $('#insCombo');
        insCombo.empty();
        var insData = $.parseJSON(ret);
        for (var idx = 0, len = insData.length; idx < len; idx++) {
            var tmpl = insData[idx];
            insCombo.append($('<option>').text(tmpl.text).val(idx));
            allInstance[idx] = tmpl;
        };
        showEmrDoc(allInstance[0]||'');
    }, function (ret) {
        alert('发生错误', 'getAllInstance:' + ret);
    });
}

/// 济宁使用集成平台的页面
function showxmlpreview(adm) {
    $('#refEmrDoc').hide();
    $('#insCombo').hide();    
    var oeordLnk = 'dhctt.xmlpreview.csp?xmlName=EMRPreview&EpisodeID='+adm;
    $('#frameDetail').attr('scrolling', 'yes').attr('src', oeordLnk);
    showAdmHisDetail(true); 
}

function showOPEMR(adm) {
	if ('showHistoryEMR' == showHistoryEMRmethod) {
		showHistoryEMR(adm);
	}
	else if ('showxmlpreview' == showHistoryEMRmethod){
		showHistoryEMR1(adm);
	}
}

function GetRecodeParam(emrTmplCateid, func) {
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParam', emrTmplCateid);
    ajaxGET(data, function (ret) {
        func($.parseJSON(ret));
    }, function (ret) {
        alert('GetRecodeParam error:' + ret);
    });

}

$(function () {
    //判断IE浏览器版本 add By Lina 2017-01-19
    if($.browser.version == '11.0')
    {
        document.documentElement.className ='ie11';
    }
    //加载历史就诊
    var getAdmHistory = function (patID, admID, ctloc) {
        function appendDetail(data) {
            for (var i = 0, len = data.total; i < len; i++) {
                var row = data.rows[i];
                var div = $('<div class="admDetail"></div>');
                $(div).append(row.record);
                $('#admHistoryLst').append(div);
            }
        }

        if ($('#stdpnl').length > 0) {
            return function (patID, admID) {
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface',
                        GetOPHistoryMethod, patID,
                        $("input[name='flag']:checked").val(), admID,
                        $("input[name='flagAdmType']:checked").val());
                ajaxGET(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (err) {
                    alert('发生错误', GetOPHistoryMethod + ':' + err.message || err);
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
                ajaxGET(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (ret) {
                    alert('发生错误', 'GetOPHistoryByDateLoc:' + ret);
                });
            }
        }
    }
    ();
    //查询条件栏
    if ($('#stdpnl').length > 0) {
        $('#Type' + admType).prop('checked', true);
        $(':radio').change(function () {
            $('#admHistoryLst').empty();
            getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
            $('#msg_start')[0].scrollIntoView(true);
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
    if ('N' !== OPEnableReference) {
        $('#refEmrDoc').live('click', function (evt) {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function ()  { isClicked =  false; },  2000);
                var idx = $('#insCombo').get(0).selectedIndex;
                parent.createDocFromInstance(allInstance[idx]);
            }
        });
        $('#refEmrDoc').show();
    }
    //病历实例下拉菜单
    $("#insCombo").change(function () {
        showEmrDoc(allInstance[$(this).val()]);
    });
    //查看病历内容
    $('.emrdoc').live('click', function () {
        //showOPEMR($(this).attr('admID')); return;  //test
        if (('O' === $(this).attr('admType'))||('E' === $(this).attr('admType')))
            showOPEMR($(this).attr('admID'));
        else {
            openRecordBrowse(patientID, $(this).attr('admID'));
        }
    });
    //查看医嘱内容
    $('.oeord').live('click', function () {
        $('#refEmrDoc').hide();
        $('#insCombo').hide();
        var oeordLnk = 'oeorder.opbillinfo.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID');
        $('#frameDetail').attr('src', oeordLnk);
        showAdmHisDetail(true);
    });
    $('.oeordEMR').live('click', function () {
        $('#refEmrDoc').hide();
        $('#insCombo').hide();    
        var oeordLnk = 'emr.op.oeorddata.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID') + '&ssgroupID=' + ssgroupID;
        $('#frameDetail').attr('src', oeordLnk);
        showAdmOeOrd(true);
    });    
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
    //加载更多
    $('#btnLoadMore').live('click', function (evt) {
        var records = $('.diag');
        var lastEpisodeID = records.length === 0 ? episodeID : records.last().attr('admID');
        getAdmHistory(patientID, lastEpisodeID);
        $('#msg_end')[0].scrollIntoView(true);
    });
    //返回就诊列表
    $('#backAdmHistoryLst').live('click', function () {
        showAdmHisDetail(false);
    });
    //初始化获取数据
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll'?'':episodeID);

    //隔行变色
    $('.admDetail:odd').css('background-color', '#E0EEEE');
});
