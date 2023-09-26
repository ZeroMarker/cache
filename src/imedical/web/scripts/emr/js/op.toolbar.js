function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $('#pnlButton a').live('click', function() {
            if (isBtnClicked) { return; }
            isBtnClicked = true;
            setPnlBtnDisable(true);
            setTimeout(function(){
                isBtnClicked = false;
                setPnlBtnDisable(false);
            }, 2000);

            var fnBtnClick = btnClick[$(this).attr('id')];
            if ('function' == typeof fnBtnClick) {
                fnBtnClick();
            } else if ('btnTmpl' == $(this).attr('id').substring(0, 7)) {
                btnClick.btnTmpl($(this).attr('id').substring(7));
            }  else if ('btnNormTmpl' == $(this).attr('id').substring(0, 11)) {
                btnClick.btnTmpl($(this).attr('id').substring(11));
            }else {

            }
        });

        var btnClick = new function() {
            //直接打印
            this.btnPrint = function() {
                emrEditor.printDoc('PrintDirectly');
            };
            
            //先弹出选项再打印
            this.btnPrintOpt = function() {
                emrEditor.printDoc('Print');
            };
            
            //南方医院打印要求
            this.btnPrintNFYY = function() {
                var instanceId = emrEditor.getInstanceID();
                common.getTemplateIDByInsId(instanceId, function(tmpId) {
                    if (tmpId === '1104' || tmpId === '1240') {
                        alert('请点击右下角病历打印按钮！');
                        return;
                    }
                    emrEditor.printDoc('PrintDirectly');
                });
            };
            
            //保存
            this.btnSave = function() {
                emrEditor.saveDoc();
            };
            
            //删除
            this.btnDelete = function() {
                emrEditor.deleteDoc();
            };
            
            //一键打印(医生站界面)
            this.btnOneClickPrint = function() {
                var antMainUrl = 'dhcdocclickprint.csp?EpisodeID=@episodeID&PatientID=@patientID&mradm=@mradm&userid=@userID&ctlocid=@userLocID';
                var lnk = replaceLinkParams(antMainUrl);
                window.open(lnk, true, "status=1,scrollbars=1,top=50,left=10,width=300,height=500");
            };
            
            //选择模板
            this.btnTemplateclassify = function() {
                showTemplateTree();
            };
            
            //语音录入
            this.btnAsrVoice = function() {
                var txt = $('#asrVoice').text();
                if ('语音输入' == txt) {
                    iEmrPlugin.SET_ASR_VOICE_STATE({
                        Open: true,
                        isSync: true
                    });
                    $('#asrVoice').text('停止语音输入');
                } else {
                    iEmrPlugin.SET_ASR_VOICE_STATE({
                        Open: false,
                        isSync: true
                    });
                    $('#asrVoice').text('语音输入');
                }
            };
            
            //特殊符号
            this.btnSpechars = function() {
                var returnValues = window.showModalDialog('emr.spechars.csp', '', 'dialogHeight:480px;dialogWidth:490px;resizable:no;status:no');
                iEmrPlugin.INSERT_STYLE_TEXT_BLOCK({
                    args: returnValues,
                    isSync: true
                });
            };
            
            //刷新绑定
            this.btnRefreshRefData = function() {
                var insID = emrEditor.getInstanceID();
                //获取是否显示同步提示框状态
                var data = ajaxDATA('String', 'EMRservice.BL.BLRefreshBindData', 'getBindDataSyncDialogVisible', insID);
                ajaxGET(data, function(ret) {
                    var flag = ret != 'False';
                    iEmrPlugin.REFRESH_REFERENCEDATA({
                        InstanceID: insID,
                        AutoRefresh: false,
                        SyncDialogVisible: flag,
                        SilentRefresh: false
                    });
                    common.GetRecodeParamByInsID(insID, function(tempParam) {
                        //自动记录病例操作日志
                        hisLog.operate('EMR.OP.BinddataReload',tempParam);
                    });
                }, function(err) {
                    alert('getBindDataSyncDialogVisible error:' + (err.message || err));
                });
            };
            
            //缩放编辑器 缩放编辑器只适用于op.main2.csp
            var isScaleEditor = true; //编辑器大小的标志量，用于放大缩小按钮调整时使用；
            this.btnScaleEditor = function() {
                if (TAG != "main2")
                    return;
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
            };
            
            //撤销(Ctrl+Z)
            this.btnUndo = function() {
                iEmrPlugin.UNDO();
            };
            
            //门诊患者列表
            this.btnOPPatList = function() {
                var lnk = 'dhcopoutpatlistnew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm';
                lnk = replaceLinkParams(lnk);
                var left = document.body.clientWidth - 700;
                var returnValues = window.showModalDialog('dhcopoutpatlistnew.csp', '', 'dialogHeight:700px;dialogWidth:600px;resizable:no;status:no;dialogLeft=' + left);
                if (!returnValues) {} else {
                    switchPatient(returnValues.PatientID, returnValues.EpisodeID, returnValues.MRAdm);
                }
            };
            
            //门诊患者列表
            this.btnOPPatListPage = function() {
                window.open('websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList&WinOpenFlag=1', true, 'status=1,scrollbars=1,top=50,left=10,width=1000,height=630');
            };
            
            //导出
            this.btnExportDocument = function() {
                //if (!param || param.id == 'GuideDocument')
                var documentContext = emrEditor.getDocContext();
                if (!documentContext || 'ERROR' == documentContext.result) {
                    showEditorMsg('请选中要导出的文档!', 'forbid');
                    return;
                }
                iEmrPlugin.SAVE_LOCAL_DOCUMENT();
            }; 
            
            // 打开病历模板
            this.btnTmpl = function(emrTmplCateid) {
                var DocID = common.getEmrDocId(emrTmplCateid);
                if (DocID === '0') {
                    alert('未找到病历模板！'+emrTmplCateid);
                    return;
                } else {
                    var ret = common.IsAllowMuteCreate(DocID);
                    if (ret === '0') {
                        alert('已创建同类型模板，不允许继续创建！');
                        return;
                    }
                    emrTemplate.LoadTemplate(DocID);
                }
            };
            
            //范例病历
            this.btnmodelinstance = function() {
                var antMainUrl = 'emr.modelinstance.csp?PatientID=@patientID&EpisodeID=@episodeID&UserID=@userID';
                lnk = replaceLinkParams(antMainUrl);
                window.showModalDialog(lnk, window, 'dialogHeight:570px;dialogWidth:350px;resizable:no;status:no');
            };
            
            //预览
            this.btnPreview = function() {
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
            };
            
            //显示痕迹
            this.btnRevisionVisible = function() {
                var fnBtnRevisionVisible = function() {
                    var txt = $('#btnRevisionVisible').text() === '显示痕迹' ? '隐藏痕迹' : '显示痕迹';
                    $('#btnRevisionVisible').text(txt);
                    return txt === '隐藏痕迹';
                };

                privilege.setViewRevise(emrEditor.getDocContext(), fnBtnRevisionVisible);
            };
            
            //济宁打开第三方病历
            this.btnJNThirdParty = function() {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetPadmCardNo', patInfo.EpisodeID);
                ajaxGETSync(data, function(ret) {
                    var PadmCardNo = ret;
                    window.open("http://172.18.1.24:9080/htmz/ShowOutpatientInfo.jsp?pid=" + PadmCardNo, "");
                }, function(ret) {
                    alert('GetPadmCardNo error:' + ret);
                });
            };
            
            //操作日志
            this.btnLogFlagInfo = function() {
                window.showModalDialog('emr.logdetailrecord.csp?EpisodeID=' + patInfo.EpisodeID + '&Action=getAllLog', window, 'dialogWidth:801px;dialogHeight:550px;resizable:yes;');
            };
            
            //补打
            this.btnPrintAndLog = function () {
                var documentContext = emrEditor.getDocContext();
                if (!documentContext) return;
                ret = documentContext.privelege.canPrint == '1';
                if (!ret) {
                    showEditorMsg('没有合法签名，不允许进行打印！', 'warning');
                    return;
                }
                var ret = iEmrPlugin.PRINT_DOCUMENT({
                    args: 'PrintDirectly',
                    isSync: true
                });
                if ('OK' === ret.params.result) {
                    var InstanceID = documentContext.InstanceID;
                    var Text = documentContext.Title.DisplayName;
                    var data = ajaxDATA('String', 'EMRservice.HISInterface.BOExternal', 'AddCustomSelfPrintLog', InstanceID, patInfo.IPAddress, patInfo.UserID);
                    ajaxGET(data, function(d) {
                        if (d != "0") {
                            var result = $.parseJSON(d);
                            // 刷新
                            var seleRow = $('#patientPrintListData').datagrid('getSelected');
                            if (seleRow) {
                                var rowIndex = $('#patientPrintListData').datagrid('getRowIndex',patInfo.EpisodeID);
                                //$('#Sub-'+rowIndex).find(InstanceID).html(Text+
                                $('#Sub-'+rowIndex).find(document.getElementById(InstanceID)).html(Text+
                                 '已打印|打印日期: '+result.PrintDate+'|打印时间: '+result.PrintTime+
                                 '|IP: '+result.IPAddress+'|打印者: '+result.UserName);
                                $('#Sub-'+rowIndex).find(document.getElementById(InstanceID)).css({backgroundcolor:'#A4D3EE',color:'red'});
                            }
                        }else {
                            alert("补打日志保存失败！");
                        }
                    }, function(err) {
                        alert('InsertCustomSelfPrintLog error:' + ret);
                    });                        
                }
            };
            
            //手写板
            this.btnWacom = function() {
                var argParams = {
                    UserLocID: patInfo.UserLocID,
                    UserID: patInfo.UserID,
                    Methods: 'wacom',
                    EdtImgPath: '',
                    FnEmrImg: function(imageType, imageData) {
                        iEmrPlugin.INSERT_IMG({
                            ImageType: imageType,
                            ImageData: imageData
                        });
                    }
                }
                externImage.get(argParams);
            };
            
            //测试
            this.btnTest = function() {};

            //牙位
            this.btnTooth = function() {
                var returnValue = window.showModalDialog("emr.record.tooth.csp","","dialogWidth=940px;dialogheight=420px;status:no;center:yes;minimize:yes;");
                if (returnValue !== "") {
                    emrEditor.insertTooth("new",returnValue);
                }
            };
            
            //权限申请
			this.btnAuthRequest = function () {
				var returnValues = window.open("emr.authorizes.request.csp?EpisodeID=" +  patInfo.EpisodeID + "&PatientID=" + patInfo.PatientID,"authRequestWin","resizable:no;status:no,width=850,height=550");
			};	
            
            //文字编辑
            this.btntextedit = function() {
                window.showModalDialog('emr.op.textedit.csp', window, 'dialogWidth:195px;dialogHeight:175px;dialogTop:50;dialogLeft:200;center:no;resizable:no;');
                //window.open('emr.op.textedit.csp','texteditWin',"toolbar=no,menubar=no,resizable=no,titlebar=no,status=no,scrollbars=no,width=195,height=175,top=50,left=200",true);
            };
            
            //门诊签名按钮(只支持单一签名单元的签名与改签)
            this.btnSign = function() {
                var instanceId = emrEditor.getInstanceID();
                var path = common.getSignUnitPath(instanceId);
                if (path == "") {
                    alert('未找到指定的签名单元！');
                } else {
                    iEmrPlugin.TRIGGER_SIGN_ELEMENT({
                        Path: path
                    });
                }
            };
        };
    }

    function checkHtml(htmlStr) {
        var reg = /<[^>]+>/g;
        return reg.test(htmlStr);
    }

    function addButtons(param) {
        var pnlButton = $('#pnlButton');
        if (checkHtml(param)) {
            pnlButton.append(param);
        } else {
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
        $("#pnlResScale a[id^='btnScale']").live('click', function() {
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
        ajaxGET(data, function(ret) {
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
        }, function(ret) {
            alert('GetSSUserByLocID error:' + ret);
        });
        // 'color':'#FF0033','font-weight':'700','font-size':'1.5em'
        html = '<a style="font-size:18px;margin-left:5px;margin-top:0px;">审核人：</a><select name="auditUsrCombo" id="auditUsrCombo" style="width:200px;font-size:18px;margin-left:5px;"></select>';
        pnlButton.append(html);
        //审核按钮
        var html = '<a href="#" id="btnOpOfficeAudit"  class="button small" style="margin-left:5px;margin-top:2px;font-size:18px;color:red;font-weight:700;font-size:1.2em">审&nbsp&nbsp&nbsp核</a>';
        pnlButton.append(html);
        $('#btnOpOfficeAudit').live('click', function() {
            var instanceId = emrEditor.getInstanceID();
            if (instanceId === '')
                return;

            if ('0' === common.isSaved(instanceId)) {
                return;
            }
            var auditUsrId = document.getElementById('auditUsrCombo').value;

            var InsertAudit = function() {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertAudit', instanceId, auditUsrId, patInfo.UserID);
                ajaxGET(data, function(ret) {
                    showEditorMsg('审核成功', 'warning');
                }, function(ret) {
                    alert('InsertAudit error:' + ret);
                });
            }

            var ShowAuditLog = function() {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetAuditLog', instanceId);
                ajaxGET(data, function(ret) {
                    if ('' != ret) {
                        var info = ret.split('^');
                        var msg = '已审核' + info.length + '次：\r\n';
                        for (var idx = 0, max = info.length; idx < max; idx++) {
                            msg += '      ' + info[idx] + '\r\n';
                        }
                        alert(msg);
                    }
                    InsertAudit();
                }, function(ret) {
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
    /*for (var idx = 0; idx < $('.button').length; idx++) {
        $('.button')[idx].disabled = flag;
    }*/
    $('#pnlButton a').each(function(index, element) {
        element.disabled = flag;
    });
}