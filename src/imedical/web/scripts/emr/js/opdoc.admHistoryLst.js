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

    window.open(lnk, name, 'height=' + iHeight + ',width=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes');
}

//住院病历浏览
function openRecordBrowse(patientID, episodeID) {
    if ('N' == OPDisplayWindow) {
        $HUI.dialog('#admHisDetail').open();
        $("#insComboSpan").hide();
        var lnk = 'emr.interface.browse.category.csp?EpisodeID=' + episodeID + '&PatientID=' + patientID + '&OPHistoryDefaultSelectDocID=' + OPHistoryDefaultSelectDocID;
        $('#frameDetail').attr('src', lnk);
        showAdmHisDetail(true);
    }else {
        //河南中医药大学第一附属医院项目历史就诊病历弹窗显示
        var lnk = 'emr.browse.emr.csp?EpisodeID='+episodeID+'&Action=&ViewType=Editor';
        openWindow('recordbrowse', lnk);
    }
}

//显示门诊病历详细内容
function showEmrDoc(insData) {
    if ((''===insData)||(getViewPrivilege(insData).canView == '0')) {
        var Viewblank = 'emr.blank.csp?info=OPCannotView';
        $('#frameDetail').attr('src', Viewblank);
        $('#refEmrDoc').hide();
        showAdmHisDetail(true);
    }else {
	    //$('#refEmrDoc').show();
	    admHisUrl = 'emr.record.browse.browsform.editor.csp?VisitType=OP&'; //id=2461||1&chartItemType=Single&pluginType=DOC
	    var src = admHisUrl + 'id=' + insData.id + '&chartItemType=' + insData.chartItemType + '&pluginType=' + insData.pluginType;
	    $('#frameDetail').attr('src', src);
	    //通过权限规则脚本控制是否显示引用按钮
	    if (getQuotePrivilege(insData).canquote == '1') {
	        $('#refEmrDoc').show();
	    }else {
	        $('#refEmrDoc').hide();
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
function showHistoryEMR(adm,order) {
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
            if ("last" == order) {
                insCombo.select(allInstance.length-1);
            }else {
                insCombo.select(0);
            }
        }
    }, function (ret) {
        $.messager.alert('发生错误', 'getAllInstance:' + ret, 'info');
    });
}

/// 济宁使用集成平台的页面
function showxmlpreview(adm) {
    $('#refEmrDoc').hide();
    $('#insComboSpan').hide();
    var oeordLnk = 'dhctt.xmlpreview.csp?xmlName=EMRPreview&EpisodeID='+adm;
    $('#frameDetail').attr('scrolling', 'yes').attr('src', oeordLnk);
    showAdmHisDetail(true); 
}

function showOPEMR(adm,order) {
    if ('showHistoryEMR' == showHistoryEMRmethod) {
        showHistoryEMR(adm,order);
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

// 获取模板加载权限
function getViewPrivilege(insData) {
    var result = '';
    var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetLoadPrivilege', userID, userLocID, ssgroupID, episodeID, patientID, insData.id);
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

var currentAdmID = "";
$(function () {
    $HUI.dialog('#admHisDetail').close();
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
                        $("input[name='flagAdmType']:checked").val(), "HISUI");
                ajaxGET(data, function (ret) {
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
                ajaxGET(data, function (ret) {
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
        /*
        $('#Type' + admType).prop('checked',true);
        $(':radio').change(function () {
            $('#admHistoryLst').empty();
            getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
            $('#msg_start')[0].scrollIntoView(true);
        });
        */
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
                $('#msg_start')[0].scrollIntoView(true);
            }
        });
        $HUI.radio("[name='flagAdmType']",{
            onChecked:function(e,value){
                $('#admHistoryLst').empty();
                getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
                $('#msg_start')[0].scrollIntoView(true);
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
    //默认隐藏引用按钮
    $('#refEmrDoc').hide();
    
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
                showOPEMR($(this).attr('admID'));
                if ('' == admIDs) getOEPEpisodeList();
            }else{
                windowArgs = {
                    admID: $(this).attr('admID'),
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
        //$('#prevAdm').show();
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
                        showOPEMR(currentAdmID);
                    }else {
                        $.messager.alert('提示', "已经切换至该患者门(急)诊就诊所书写的最后一份病历！", 'info');
                    }
                }
            }
        });
        //$('#nextAdm').show();
    }
    //查看医嘱内容
    $(document).on('click','.oeord', function () {
        $HUI.dialog('#admHisDetail').open();
        $('#refEmrDoc').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        //$('#insCombo').hide();
        $("#insComboSpan").hide();
        var oeordLnk = 'oeorder.opbillinfo.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID');
        $('#frameDetail').attr('src', oeordLnk);
        showAdmHisDetail(true);
    });
    $(document).on('click','.oeordEMR', function () {
        $HUI.dialog('#admHisDetail').open();
        //$('#insCombo').hide();
        $('#refEmrDoc').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $("#insComboSpan").hide();
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
        $('#msg_end')[0].scrollIntoView(true);
    });
    //返回就诊列表
    $('#backAdmHistoryLst').bind('click', function () {
        $HUI.dialog('#admHisDetail').close();
        showAdmHisDetail(false);
    });
    
    //初始化获取数据
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll'?'':episodeID);

    //隔行变色
    $('.admDetail:odd').css('background-color', '#E0EEEE');
});
