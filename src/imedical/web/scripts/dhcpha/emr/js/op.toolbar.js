function initPnlButton() {
    function liveBtnBind() {
        //直接打印
        $('#btnPrint').live('click', function () {
            emrEditor.printDoc('PrintDirectly');
        });
		
        //先弹出选项再打印
        $('#btnPrintOpt').live('click', function () {
            emrEditor.printDoc('Print');
        });
		
        //先弹出选项再打印
        $('#btnPrintNFYY').live('click', function () {
			var instanceId = emrEditor.getInstanceID();
			common.getTemplateIDByInsId(instanceId, function (tmpId) {
				if (tmpId==='1104' || tmpId === '1240') {
					alert('请点击右下角病历打印按钮！');
					return;
				}
				emrEditor.printDoc('PrintDirectly');
			});
        });
		
        //保存
        $('#btnSave').live('click', function () {
            emrEditor.saveDoc();
        });

        //删除
        $('#btnDelete').live('click', function () {
            emrEditor.deleteDoc();
        });

        //一键打印(医生站界面)
        $('#btnOneClickPrint').live('click', function () {
            var antMainUrl = 'dhcdocclickprint.csp?EpisodeID=@episodeID&PatientID=@patientID&mradm=@mradm&userid=@userID&ctlocid=@userLocID';
            var lnk = replaceLinkParams(antMainUrl);
            window.open(lnk, true, "status=1,scrollbars=1,top=50,left=10,width=300,height=500");
        });

        //选择模板
        $('#btnTemplateclassify').live('click', function () {
            showTemplateTree();
        });

        //语音录入
        $('#btnAsrVoice').live('click', function () {
            var txt = $('#asrVoice').text();
            if ('语音输入' == txt) {
                //setASRVoiceStateSync(true);
                iEmrPlugin.SET_ASR_VOICE_STATE({
                    Open: true,
                    isSync: true
                });
                $('#asrVoice').text('停止语音输入');
            } else {
                //setASRVoiceStateSync(false);
                iEmrPlugin.SET_ASR_VOICE_STATE({
                    Open: false,
                    isSync: true
                });
                $('#asrVoice').text('语音输入');
            }
        });

        //特殊符号
        $('#btnSpechars').live('click', function () {
            var returnValues = window.showModalDialog('emr.spechars.csp', '', 'dialogHeight:480px;dialogWidth:490px;resizable:no;status:no');
            //insertText(returnValues);
            /*iEmrPlugin.INSERT_TEXT_BLOCK({
                args: returnValues,
                isSync: true
            });*/
            
            iEmrPlugin.INSERT_STYLE_TEXT_BLOCK({
                args: returnValues,
                isSync: true
            });
        });

        //刷新绑定
        $('#btnRefreshRefData').live('click', function () {
            iEmrPlugin.REFRESH_REFERENCEDATA({
                InstanceID: '',
                AutoRefresh: true,
                SyncDialogVisible: true
            });
            common.GetRecodeParamByInsID(insID, function(tempParam) {
                //自动记录病例操作日志
                hisLog.operate('EMR.OP.BinddataReload',tempParam);
            });
        });

        var isScaleEditor = true; //编辑器大小的标志量，用于放大缩小按钮调整时使用；
        //缩放编辑器
        $('#btnScaleEditor').live('click', function () {
            if (TAG === "main")
                return; //缩放编辑器只适用于op.main2.csp
            var proportion,
            newWidth,
            newHeight;
            if (isScaleEditor) {
                proportion = 0.618;
                newWidth = screen.availWidth * proportion;
                newHeight = $('#pnlwest').panel('options').height;
                isScaleEditor = false;
                $('#btnScaleEditor').text('正常');
            } else {
                proportion = 0.382;
                newWidth = screen.availWidth * proportion;
                newHeight = (screen.availHeight - 50) * proportion;
                isScaleEditor = true;
                $('#btnScaleEditor').text('放大');
            }
            $('#pnlwest').panel('resize', {
                width: newWidth
            });
            $('#emrEditor').panel('resize', {
                height: newHeight
            });
            $('body').layout('resize');
        });

        //撤销(Ctrl+Z)
        $('#btnUndo').live('click', function () {
            iEmrPlugin.UNDO();
        });

        //门诊患者列表
        $('#btnOPPatList').live('click', function () {
            var lnk = 'dhcopoutpatlistnew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm';
            lnk = replaceLinkParams(lnk);
            var left = document.body.clientWidth - 700;
            var returnValues = window.showModalDialog('dhcopoutpatlistnew.csp', '', 'dialogHeight:700px;dialogWidth:600px;resizable:no;status:no;dialogLeft=' + left);
            if (!returnValues) {}
            else {
                switchPatient(returnValues.PatientID, returnValues.EpisodeID, returnValues.MRAdm);
            }
        });

        //门诊患者列表
        $('#btnOPPatListPage').live('click', function () {
            window.open('websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList&WinOpenFlag=1', true, 'status=1,scrollbars=1,top=50,left=10,width=1000,height=630');
        });

        //导出
        $('#btnExportDocument').live('click', function () {
            //if (!param || param.id == 'GuideDocument')
            var documentContext = emrEditor.getDocContext();
            if (!documentContext || 'ERROR' == documentContext.result) {
                showEditorMsg('请选中要导出的文档!', 'forbid');
                return;
            }
            iEmrPlugin.SAVE_LOCAL_DOCUMENT();
        });

        // 打开病历模板
		var isClicked = false; 
        $("a[id^='btnTmpl']").live('click', function () {
		   if (!isClicked) {
                isClicked = true;
				setTimeout(function ()  { isClicked =  false; },  3000);
				var emrTmplCateid = $(this).attr('id').substring(7);
				var ret = common.IsAllowMuteCreate(emrTmplCateid);
				if (ret === '0')
				{
					alert('已创建同类型模板，不允许继续创建！');
					return;
				}
				emrTemplate.LoadTemplate(emrTmplCateid);                                 
            }
        });

        //范例病历
        $('#btnmodelinstance').live('click', function () {
            var antMainUrl = 'emr.modelinstance.csp?PatientID=@patientID&EpisodeID=@episodeID&UserID=@userID';
            lnk = replaceLinkParams(antMainUrl);
            window.showModalDialog(lnk, window, 'dialogHeight:570px;dialogWidth:350px;resizable:no;status:no');
        });

        //预览
        //var previewFlag = false;
        $('#btnPreview').live('click', function () {
            var previewFlag = $('#btnPreview').text() === '预览';
            iEmrPlugin.PREVIEW_DOCUMENT({
                Preview: previewFlag
            });
            var txt = previewFlag ? '退出预览' : '预览';
            $('#btnPreview').text(txt);
            if (previewFlag) {
                var insId = insId || emrEditor.getInstanceID();
                common.GetRecodeParamByInsID(insId, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.browse('EMR.OP.Browse',tempParam);
                });
            }
        });

        //显示痕迹
        $('#btnRevisionVisible').live('click', function () {
            var fnBtnRevisionVisible = function () {
                var txt = $('#btnRevisionVisible').text() === '显示痕迹' ? '隐藏痕迹' : '显示痕迹';
                $('#btnRevisionVisible').text(txt);
                return txt === '隐藏痕迹';
            };

            privilege.setViewRevise(emrEditor.getDocContext(), fnBtnRevisionVisible);
        });

        //济宁打开第三方病历
        $('#btnJNThirdParty').live('click', function () {
            var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetPadmCardNo', patInfo.EpisodeID);
            ajaxGETSync(data, function (ret) {
                var PadmCardNo = ret;
                window.open("http://172.18.1.24:9080/htmz/ShowOutpatientInfo.jsp?pid=" + PadmCardNo, "");
            }, function (ret) {
                alert('GetPadmCardNo error:' + ret);
            });
        });

        //操作日志
        $('#btnLogFlagInfo').live('click', function () {
            var instanceId = emrEditor.getInstanceID();
            var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'LogFlagInfo', instanceId);
            ajaxGETSync(data, function (ret) {
                result = ret;
                var TmpNum = result.split('^')[1];
                var TmpChartItemID = result.split('^')[0];
                window.showModalDialog("emr.logdetailrecord.csp?EpisodeID=" + patInfo.EpisodeID + "&EMRDocId=" + TmpChartItemID + "&EMRNum=" + TmpNum, "", "dialogWidth:801px;dialogHeight:550px;resizable:yes;");
            }, function (ret) {
                alert('IsExistInstance error:' + ret);
            });
        });

        //测试
        $('#btnTest').live('click', function () {
            footest();
        });
    }

    function checkHtml(htmlStr) {  
        var reg = /<[^>]+>/g;  
        return reg.test(htmlStr);  
    } 

    function addButtons(param) {
        var pnlButton = $('#pnlButton');  
        if (checkHtml(param)) {
            pnlButton.append(param);
			if ($.browser.version == '11.0') {
				$(".edtor-top-btn").css({
					'margin-top': '3px'
                });
            } 
        }
        else {
			var params = param.split(';');
            for (var i = 0, len = params.length; i < len; i++) {
                var btn = params[i];
                var html = '<a href="#" id="' + btn.split(':')[0] + '"  class="button big" style="margin-left:5px;margin-top:2px">' + btn.split(':')[1] + '</a>';
                pnlButton.append(html);
            }
            if ($.browser.version == '11.0') {
                $("#pnlButton a[id^='btnTmpl']").css({
                    'float': 'right',
                    'color': '#FF0033',
                    'font-weight': '700',
                    'font-size': '1.5em'
                });
            } else {
                $("#pnlButton a[id^='btnTmpl']").css({
                    'float': 'right',
                    'color': '#FF0033',
                    'font-weight': '700',
                    'font-size': '1.2em',
                    'margin-top': '-29px'
                });
            }
        }
    }

    function getOPEmrButtons() {
        /*var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getOPEmrButtons');
        ajaxGET(data, function (ret) {
        addButtons(ret);
        liveBtnBind();
        }, function (ret) {
        alert('发生错误', '获取病历按钮：' + ret);
        });*/
        addButtons(envVar.opEmrButtons);
        liveBtnBind();
    }

    // 资源区上方调整宽度比例的按钮
    function defineBtnScale() {
        $("#pnlResScale a[id^='btnScale']").css({
            'float': 'right',
            'margin-right': '5px',
            'margin-top': '2px'
        });
        $("#pnlResScale a[id^='btnScale']").live('click', function () {
            var rate = parseFloat($(this).attr('rate'));
            $('#emrEditor').panel('resize', {
                width: screen.availWidth * rate
            });
            $('body').layout('resize');
            common.setOPDisplay(rate);
        });
    }

    function ExtAudit() {
        var pnlButton = $('#pnlButton');
        //审核人列表
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetSSUserByLocID', patInfo.UserLocID);
        ajaxGET(data, function (ret) {
            var userlst = $.parseJSON(ret);

            var keyCombo = document.getElementById('auditUsrCombo').options;
            keyCombo.length = 0;
            keyCombo.options[keyCombo.length] = new Option('', '');
            for (var i = 0; i < userlst.length; i++) {
                var item = userlst[i];
                var key = item.Name;
                var value = item.ID;
                keyCombo.options[keyCombo.length] = new Option(key, value);
            }
            $('#auditUsrCombo option[value="' + patInfo.UserID + '"]').attr('selected', true);
        }, function (ret) {
            alert('GetSSUserByLocID error:' + ret);
        });
        // 'color':'#FF0033','font-weight':'700','font-size':'1.5em'
        html = '<a style="font-size:18px;margin-left:5px;margin-top:0px;">审核人：</a><select name="auditUsrCombo" id="auditUsrCombo" style="width:200px;font-size:18px;margin-left:5px;"></select>';
        pnlButton.append(html);
        //审核按钮
        var html = '<a href="#" id="btnOpOfficeAudit"  class="button small" style="margin-left:5px;margin-top:2px;font-size:18px;color:red;font-weight:700;font-size:1.2em">审&nbsp&nbsp&nbsp核</a>';
        pnlButton.append(html);
        $('#btnOpOfficeAudit').live('click', function () {
            var instanceId = emrEditor.getInstanceID();
            if (instanceId === '')
                return;

            if ('0' === common.isSaved(instanceId)) {
                return;
            }
            var auditUsrId = document.getElementById('auditUsrCombo').value;

            var InsertAudit = function () {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertAudit', instanceId, auditUsrId, patInfo.UserID);
                ajaxGET(data, function (ret) {
                    showEditorMsg('审核成功', 'warning');
                }, function (ret) {
                    alert('InsertAudit error:' + ret);
                });
            }

            var ShowAuditLog = function () {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetAuditLog', instanceId);
                ajaxGET(data, function (ret) {
                    if ('' != ret) {
                        var info = ret.split('^');
                        var msg = '已审核' + info.length + '次：\r\n';
                        for (var idx = 0, max = info.length; idx < max; idx++) {
                            msg += '      ' + info[idx] + '\r\n';
                        }
                        alert(msg);
                    }
                    InsertAudit();
                }, function (ret) {
                    alert('InsertAudit error:' + ret);
                });
            }

            if ('' == auditUsrId) {
                return;
            } else if (patInfo.UserID != auditUsrId) {
                var auditUsrComboObj = document.getElementById('auditUsrCombo');
                var index = auditUsrComboObj.selectedIndex;
                var auditUsr = auditUsrComboObj.options[index].text;
                var auditUsrCode = $.trim(auditUsr.split('-')[0]);
                var auditUsrName = $.trim(auditUsr.split('-')[1]);
                var ret = window.showModalDialog('emr.record.sign.csp?UserCode=' + auditUsrCode, '', 'dialogHeight:180px;dialogWidth:280px;resizable:yes;status:no');
                ret = ret || '';
                if (ret != '') {
                    ShowAuditLog();
                }
            } else {
                ShowAuditLog();
            }
        });
    }

    // 河南人民门办审核
    if (envVar.isOfficeAudit || false) {
        ExtAudit();
    } else {
        getOPEmrButtons();
    }
    defineBtnScale();

    setPnlBtnDisable(true);
}

function setPnlBtnDisable(flag) {
    //if (envVar.isOfficeAudit && flag) return;
    for (var idx = 0; idx < $('.button').length; idx++) {
        $('.button')[idx].disabled = flag;
    }
}

function footest() {
    // 1.
    /*var data = ajaxDATA('String', 'EMRservice.BL.opInterface',
            'getAdmType', patInfo.EpisodeID);
    ajaxGET(data, function (ret) {
        if ('E' === ret) {
            var tmplink = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocEmergencyPatientList";
            top.frames['TRAK_main'].location.href = tmplink;
        } else if ('O' === ret) {
            var tmplink = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList";
            top.frames['TRAK_main'].location.href = tmplink;
        } else {
            alert('getAdmType：' + ret);
        }
    }, function (err) {
        alert('getAdmType：' + (err.message || err));
    });*/
    //2
    //updateEMRInstanceData('diag', 'xxxxxxxxxxxxxxxx');
    //3
    /*if ('11411'==patInfo.EpisodeID) {alert('1');
        switchPatient('6586', '8651', '8651');
    }
    else {alert('2');
        switchPatient('8376', '11411', '11411');
    }*/
    //4            
    /*emrEditor.closeResourceWindow();            
    emrEditor.showResourceWindow();*/
	//5
	var iHeight = screen.availHeight - 50;
    var iWidth = (screen.availWidth - 10) * 0.618;
    var lnk = 'emr.op.print.csp?AutoPrint=N&EpisodeID=' + patInfo.EpisodeID;
    //var returnValues = window.showModalDialog(lnk, window, 'dialogHeight:' + iHeight + 'px;dialogWidth:' + iWidth + 'px;resizable:no;status:no;');
	window.open(lnk, true, "status=1,scrollbars=1,top=50,left=10,width=1000,height=630");
}