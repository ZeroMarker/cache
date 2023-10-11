var oldwidth = '';
var curEpisodId = '';
var sum = 0;
var loadedsum = 0;

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

//记录当前页面比例，如果历史病历页面比例过低，调整为1:1
function BeforeResScale() {
    oldwidth =  parent.$('#emrEditor').panel('options').width;
    if((oldwidth/window.screen.availWidth)>0.5)
    ResScale(window.screen.availWidth * 0.5);   
}

//住院病历浏览
function openRecordBrowse(patientID, episodeID) {
    BeforeResScale();
    var lnk = 'emr.interface.browse.category.csp?EpisodeID=' + episodeID + '&PatientID=' + patientID + '&OPHistoryDefaultSelectDocID=' + OPHistoryDefaultSelectDocID;
    $('#frameDetail').attr('src', lnk);
    $('#insCombo').hide(); 
    showAdmHisDetail(true);
}

//二版病历浏览
function openEPRRecordBrowse(patientID, episodeID, admType) {
    BeforeResScale();
    var lnk = "epr.newfw.episodelistuvpanel.csp?patientID=" + patientID + "&episodeID=" + episodeID + "&admType=" + admType;
    $('#frameDetail').attr('src', lnk);
    $('#refEmrDoc').hide();
    $('#refEmrLastDoc').hide();
    $('#insCombo').hide(); 
    $('#prevAdm').hide();
    $('#nextAdm').hide();
    showAdmHisDetail(true);
}

//显示门诊病历详细内容
function showEmrDoc(insData) {
    if (''===insData) return;
    
    //通过浏览权限规则脚本判断是否允许浏览
    if (getViewPrivilege(insData).canView == '0') {
        var Viewblank = 'emr.blank.csp?info=OPCannotView';
        $('#frameDetail').attr('src', Viewblank);
        showAdmHisDetail(true);
    }else {
        //通过权限规则脚本控制是否显示引用按钮
        if (getQuotePrivilege(insData).canquote == '1') {
            $('#refEmrDoc').show();
            if ('' != refEmrLastDocID) $('#refEmrLastDoc').show();
        }else {
            $('#refEmrDoc').hide();
            $('#refEmrLastDoc').hide();
        }
         
        BeforeResScale();
        admHisUrl = 'emr.record.browse.browsform.editor.csp?VisitType=OP&'; //id=2461||1&chartItemType=Single&pluginType=DOC
        var src = admHisUrl + 'id=' + insData.id + '&chartItemType=' + insData.chartItemType + '&pluginType=' + insData.pluginType+"&Action=externalapp";
        $('#frameDetail').attr('src', src);
        if ('N' !== isSwitchHistoryOERecord) {
            $('#prevAdm').show();
            $('#nextAdm').show();
        }
        $('#insCombo').show();
        showAdmHisDetail(true);
    }
    //自动记录病例操作日志
    parent.hisLog.browse('EMR.OP.AdmHistoryLst.Browse', insData);
}

//实例集合
var allInstance = "";
var currentIdx = "";
function showHistoryEMR(adm,order) {
    var data = ajaxDATA('String', 'EMRservice.BL.opInterface','getAllInstance', userLocID, ssgroupID, adm, userID);
    ajaxGET(data, function (ret) {
        if (ret === '')
            return;
        allInstance = $.parseJSON(ret);
        var insCombo = $('#insCombo');
        insCombo.empty();
        for (var idx = 0, len = allInstance.length; idx < len; idx++) {
            insCombo.append($('<option>').text(allInstance[idx].text).val(idx));
        };
        if (!(allInstance[0]||'')) {
            currentIdx = 0;
            showEmrDoc('');
        }else {
            if ("last" == order) {
                currentIdx = allInstance.length-1;
                showEmrDoc(allInstance[currentIdx]);
            }else {
                currentIdx = 0;
                showEmrDoc(allInstance[currentIdx]);
            }
        }
    }, function (ret) {
        alert('发生错误', 'getAllInstance:' + ret);
    });
}

// 济宁使用集成平台的页面
function showxmlpreview(adm) {
    $('#refEmrDoc').hide();
    $('#refEmrLastDoc').hide();
    $('#prevAdm').hide();
    $('#nextAdm').hide();
    $('#insCombo').hide();    
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

//南方医院
function GetRecodeParam(emrTmplCateid, func) {
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetRecodeParam', emrTmplCateid);
    ajaxGET(data, function (ret) {
        func($.parseJSON(ret));
    }, function (ret) {
        alert('GetRecodeParam error:' + ret);
    });

}

// 宽度调节
function ResScale(flag) {
    parent.$('#emrEditor').panel('resize', {
        width: flag  
    });
    parent.$('body').layout('resize');
}

// 获取病历浏览权限
function getViewPrivilege(insData) {
    var result = '';
    var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetBrowsePrivilege', userID, userLocID, ssgroupID, episodeID, patientID, insData.id);
    ajaxGETSync(data, function (ret) {
        result = $.parseJSON(ret);
    }, function (ret) {
        alert('getViewPrivilege error:' + ret);
    });
    return result;
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

var admIDs = "";
function getOEPEpisodeList() {
    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetOEPEpisodeListByPID', patientID);
    ajaxGET(data, function (ret) {
        if ("" == ret) return alert('发生错误', '请检查方法GetOEPEpisodeListByPID');
        admIDs = ret.split(",");
    }, function (err) {
        alert('发生错误', 'GetOEPEpisodeListByPID:' + err.message || err);
    });
}

$(function () {
    //判断IE浏览器版本 add By Lina 2017-01-19
    if($.browser.version == '11.0')
    {
        document.documentElement.className ='ie11';
    }
    
    if ('' === episodeID) {
        var frm = top.document.forms['fEPRMENU'];
        episodeID = frm.EpisodeID.value;
        patientID = frm.PatientID.value;
    }
    //加载历史就诊
    var getAdmHistory = function (patID, admID, ctloc) {
        function appendDetail(data) {
            for (var i = 0, len = data.total; i < len; i++) {
                var row = data.rows[i];
                var div = $('<div class="admDetail"></div>');
                $(div).html(row.record);
                $('#admHistoryLst').append(div);
            }
            //隔行变色
            $('.admDetail:odd').css('background-color','#E0EEEE');
            //显示已加载和总数
            if (sum == "0") {
                sum = data.count;
            }
            loadedsum = loadedsum + data.total;
            if (loadedsum>sum) {
                loadedsum = sum;    
            }
            document.getElementById('msgtd').innerText = "已加载"+loadedsum+"条/共"+sum+"条记录";
        }

        if ($('#stdpnl').length > 0) {
            return function (patID, admID) {
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface',GetOPHistoryMethod, patID,$("input[name='flag']:checked").val(), admID,$("input[name='flagAdmType']:checked").val());
                ajaxGET(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (err) {
                    alert('发生错误', GetOPHistoryMethod + ':' + err.message || err);
                });
            }
        } else { //广西医大使用
            return function (patID, admID, ctloc) {
                ctloc = ctloc || $('#cbxLoc').combobox('getValue');
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface','GetOPHistoryByDateLoc', patID,'', admID, '',$('#startDate').datebox('getText'),$('#endDate').datebox('getText'),ctloc);
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
            sum = 0;
            loadedsum = 0;
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
    $('#refEmrDoc').live('click', function (evt) {
        if (!isClicked) {
            ResScale(oldwidth);
            isClicked = true;
            setTimeout(function(){isClicked =false;},2000);
            var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'copyOPInfo', userID, episodeID,curEpisodId,userLocID);
            ajaxGETSync(data, function (ret) {
                ret = $.parseJSON(ret);
                if (ret && ret.Err) {
                    alert(ret.Err);
                } else if(ret.diag == "0") {
                    var idx = $('#insCombo').get(0).selectedIndex;
                    parent.createDocFromInstance(allInstance[idx]);
                    isClicked = false;
                } else {
                    alert(ret.diag);
                    if (ret.diag == "诊断复制失败！")
                        return;
                    var idx = $('#insCombo').get(0).selectedIndex;
                    parent.createDocFromInstance(allInstance[idx]);
                }
            }, function (err) {
                alert('发生错误', 'copyOPInfo:' + err);
            });	
        }
    });
    $('#refEmrDoc').hide();

    if ('' != refEmrLastDocID) {
        $('#refEmrLastDoc').live('click', function () {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                common.GetRecodeParam(refEmrLastDocID, function (tempParam) {
                    if (tempParam == "") {
                        alert( '未找到病历模板！');
                        return;
                    }
                    parent.createEmrLastDocFromInstance(tempParam, curEpisodId);
                });
            }
        });
    }
    
    //医嘱引用功能 - 医嘱数据由医生站提供
    $('#refOeord').live('click', function (evt) {
        if (!isClicked) {
            ResScale(oldwidth);
            isClicked = true;
            setTimeout(function(){isClicked = false;},2000);
            if (window.frames["frameDetail"])
            {
                // 调用医生站接口，获取医嘱页签上勾选的医嘱数据
                var refOeordData = window.frames["frameDetail"].OEOrdItemListEMR_PassSelected();
                var param = {
                    "action" : "insertText",
                    "text" : refOeordData
                };
                parent.eventDispatch(param);
            }
        }
    });
    
    //病历实例下拉菜单
    $("#insCombo").change(function () {
        currentIdx = Number($(this).val());
        showEmrDoc(allInstance[$(this).val()]);
    });
    
    //查看病历内容
    $('.emrdoc').live('click', function () {
        $('#refOeord').hide();
        //查看病历内容为三版病历
        if ( $(this).attr('isEMR') == 1) {
            curEpisodId = $(this).attr('admID');
            if (('O' === $(this).attr('admType'))||('E' === $(this).attr('admType'))) {
                showOPEMR($(this).attr('admID'));
                if ('' == admIDs) getOEPEpisodeList();
            }else {
                openRecordBrowse(patientID, $(this).attr('admID'));
            }
        }else {
            openEPRRecordBrowse(patientID, $(this).attr('admID'), $(this).attr('admType'));
        }
    });
    
    if ('N' !== isSwitchHistoryOERecord) {
        //查看该患者门(急)诊就诊所书写的上一份病历内容
        $('#prevAdm').bind('click', function () {
            if (!isClicked) {
                isClicked = true;
                setTimeout(function() { isClicked = false; }, 2000);
                if (0 != currentIdx) {
                    currentIdx = currentIdx-1;
                    document.getElementById("insCombo").options[currentIdx].selected = true;
                    showEmrDoc(allInstance[currentIdx]);
                }else {
                    if (0 != admIDs.indexOf(curEpisodId)) {
                        curEpisodId = admIDs[admIDs.indexOf(curEpisodId)-1];
                        showOPEMR(curEpisodId,"last");
                    }else {
                        alert("已经切换至该患者门(急)诊就诊所书写的第一份病历！");
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
                    currentIdx = currentIdx+1;
                    document.getElementById("insCombo").options[currentIdx].selected = true;
                    showEmrDoc(allInstance[currentIdx]);
                }else {
                    if ((admIDs.length-1) != admIDs.indexOf(curEpisodId)) {
                        curEpisodId = admIDs[admIDs.indexOf(curEpisodId)+1];
                        showOPEMR(curEpisodId);
                    }else {
                        alert("已经切换至该患者门(急)诊就诊所书写的最后一份病历！");
                    }
                }
            }
        });
    }
    
    //查看第三方住院病历内容 山东省立项目提供的第三方住院病历查看链接地址
    $('.thirdIPRecord').live('click', function () {
        var ipRecordLnk = 'http://172.16.1.227/WebAppView/DoqLeiView/DoqLeiView.aspx?id=' + $(this).attr('recordNo');
        openWindow('recordbrowse', ipRecordLnk);
    });
    
    //查看体检报告
    $('.healthReport').live('click', function () {
        $('#refOeord').hide();
        $('#refEmrDoc').hide();
        $('#refEmrLastDoc').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $('#insCombo').hide();
        var healthReportLnk = 'dhcpeireport.normal.csp?PatientID='+ $(this).attr('admID');
        $('#frameDetail').attr('src', healthReportLnk);
        showAdmHisDetail(true);
    });
    
    //查看医嘱内容
    $('.oeord').live('click', function () {
        $('#refOeord').hide();
        $('#refEmrLastDoc').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $('#insCombo').hide();
        var oeordLnk = 'oeorder.opbillinfo.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID');
        $('#frameDetail').attr('src', oeordLnk);
        showAdmHisDetail(true);
    });
     
    //慈林项目-查看医嘱内容
    $('.oeordByCL').live('click', function () {
        if ('N' !== OPEnableRefOeord) $('#refOeord').show();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $('#refEmrDoc').hide();
        $('#refEmrLastDoc').hide();
        $('#insCombo').hide();
        var oeordLnk = 'websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.ListEMR&EpisodeID=' + $(this).attr('admID') + '&par=' + $(this).attr('ord') +'&EpisodeAll=0'+'&ExcludeCurrentEpisode=0';
        $('#frameDetail').attr('src', oeordLnk);
        showAdmHisDetail(true);
    });
    
    //查看病历提供医嘱引用界面
    $('.oeordEMR').live('click', function () {
        $('#refOeord').hide();
        $('#prevAdm').hide();
        $('#nextAdm').hide();
        $('#refEmrDoc').hide();
        $('#refEmrLastDoc').hide();
        $('#insCombo').hide();    
        var oeordLnk = 'emr.op.oeorddata.csp?PatientID=' + patientID + '&EpisodeID=' + $(this).attr('admID') + '&ssgroupID=' + ssgroupID;
        $('#frameDetail').attr('src', oeordLnk);
        showAdmOeOrd(true);
    });
    
    //南方医院，在列表界面进行引用
    $('.refDoc').live('click', function () {
        if (!isClicked) {
            isClicked = true;
            setTimeout(function() { isClicked = false; }, 2000);
            var admID = $(this).attr('admID');
            var insID = $(this).attr('insID');
            var emrDocID = $(this).attr('emrDocID');
            common.GetRecodeParam(emrDocID, function (tempParam) {alert('tempParam'+ insID);
                tempParam['id']=insID;
                parent.createDocFromInstance(tempParam);
            });
        }
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
        ResScale(oldwidth);
        showAdmHisDetail(false);
    });
    
    //初始化获取数据
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll'?'':episodeID);

});
