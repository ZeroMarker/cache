/// 对外处理
var HisTools;

function initHisTools() {
    HisTools = new function() {
        this.refreshOeOrdGrd = null; //刷新资源区医嘱grid的委托
        this.closeEmrFrm = function() {
            window.opener = null;
            window.open('', '_self');
            window.close();
        };
        this.closeHislinkWindow = function() {
            HisTools.hislinkWindow.closeAll();
        };
        this.refreshResFrame = function() {
            // 刷新资源区
            var args = {
                papmi: patInfo.PatientID,
                adm: patInfo.EpisodeID,
                mradm: patInfo.MRadm
            };
            HisTools.refreshDiagFrame(args);
            HisTools.dataTabs.refresh();
            HisTools.hislinkWindow.closeAll();
        };
        this.checkOeordBeforeUnload = function() {
            return HisTools.dataTabs.checkOeordBeforeUnload();
        };
        this.refreshDiagFrame = function(args) {
            HisTools.diagFrame.refresh(args);
        };
        this.refreshOeordFrame = function() {
            HisTools.dataTabs.refreshOeordFrame();
        }
    };
    ///  弹窗
    HisTools['hislinkWindow'] = new function() {
        wins = {};

        this.args = null;

        this.setArgs = function(title, lnk, confirmCallback, cancelCallback) {
            this.args = {
                title: title,
                lnk: replaceLinkParams(lnk),
                confirmCallback: confirmCallback,
                cancelCallback: cancelCallback
            }
        }

        this.show = function(winName, wWidth, wHeight, isDirectOpen) {
            var win = wins[winName];
            if (win && !win.closed) {
                win.focus();
                return;
            }
            if (!wWidth || !wHeight) {
				if ((typeof(isDirectOpen) != undefined)&&(isDirectOpen == "Y"))
				{
					wins[winName] = window.open(this.args.lnk, winName, 'channelmode,scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes');
				}
				else
				{
					wins[winName] = window.open('emr.op.hislink.window.csp', winName, 'channelmode,scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes');
				}
            } else {
                var iWidth = wWidth;
                var iHeight = wHeight;
                var iTop = (window.screen.availHeight - iHeight) / 2;
                var iLeft = (window.screen.availWidth - iWidth) / 2;
                wins[winName] = window.open('emr.op.hislink.window.csp', winName, 'height=' + iHeight + ',width=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes');
            } 
        }    

        this.closeAll = function() {
            var win;
            for (var key in wins) {
                win = wins[key];
                win.close();
            }
            wins = {};
        }

        /// 接收编辑器发出的事件，打开链接单元
        /// EMRservice.Ajax.opHISInterface原接口所在类
        this.openUnitLink = function(unitLink, args) {

            function writeBack(unitLink) {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', unitLink.Method, patInfo.EpisodeID, patInfo.SsgroupID);
                ajaxGET(data, function(ret) {
                    ret = $.parseJSON(ret);
                    iEmrPlugin.UPDATE_INSTANCE_DATA({
                        actionType: args.WriteBack,
                        InstanceID: emrEditor.getInstanceID(),
                        Path: args.Path,
                        Value: ret.Value
                    });
                }, function(ret) {
                    alert(unitLink.Method + '发生错误' + ret + '】配置！');
                });
            }

            this.setArgs(unitLink.Title, unitLink.Link,
                function() {
                    writeBack(unitLink);
                }, null);
            eventSave("openUnitlink"); 
			if ((typeof(unitLink.IsDirectOpen) != undefined)&&(unitLink.IsDirectOpen == "Y"))
			{
				this.show(args.Url, "", "", "Y");
			}
			else
			{
				this.show(args.Url);
			}
        }
    };
    /// 左下角诊断区域
    HisTools['diagFrame'] = new function() {
        var $diagFrame = $('#diagFrame');

        if ($diagFrame.length > 0) {
            var diagLnk = 'diagnosentrynew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm';
            $diagFrame.attr('lnk', diagLnk);
            $diagFrame.attr('src', replaceLinkParams(diagLnk));
        }

        this.refresh = function(args) {
            if ($diagFrame.length > 0) {
                var fn = $diagFrame[0].contentWindow.xhrRefresh;
                if (typeof fn === 'function')
                    fn(args);
            }
        }
    };
    /// 资源区
    HisTools['dataTabs'] = new function() {
        var $dataTabs = $('#dataTabs');
        var lastSelectedDataTab = -1;

        function checkOeord(index) {
            function oeordEditRowForEMR() {
                var oeordFrame = window.frames['oeordFrame'];
                if (typeof oeordFrame === 'undefined')
                    return;
                var editRowForEMR = oeordFrame.EditRowForEMR;
                if (typeof editRowForEMR === 'function')
                    editRowForEMR();
            }
            if (lastSelectedDataTab == 0 && index != 0) {
                if (HisTools.checkOeordBeforeUnload()) {
                    $dataTabs.tabs('select', 0);
                    oeordEditRowForEMR();
                    return true;
                }
            }
            return false;
        }

        function onSelect(title, index) {
            if (checkOeord(index))
                return;
            lastSelectedDataTab = index;
            var tab = $dataTabs.tabs('getSelected');
            if (0 === tab.find('iframe').length)
                return;

            var iframe = tab.find('iframe')[0];
            if ('' == $(iframe).attr('src')) {
                if (isExistVar($(iframe).attr('src'))) {
                    $(iframe).attr('src', replaceLinkParams($(iframe).attr('lnk')));
                }
            } else {
                var frame = window.frames[iframe.name];
                if (frame) {
                    var fnReLoadLabInfo = frame.ReLoadLabInfo;
                    if ('function' === typeof fnReLoadLabInfo) {
                        fnReLoadLabInfo();
                    } else if ($(iframe).attr('refreshOnSelect') == 'Y') {
                        if (isExistVar($(iframe).attr('src'))) {
                            $(iframe).attr('src', replaceLinkParams($(iframe).attr('lnk')));
                        }
                    }
                }
            }
        }

        $dataTabs.tabs({
            plain: true,
            narrow: false,
            pill: true,
            justified: true,
            onSelect: function(title, index) {
                onSelect(title, index);
            }
        });

        function addTabs(data) {
            if (!data || 0 == data.length) {
                return;
            }
            for (var idx = 0, max = data.length; idx < max; idx++) {
                var item = data[idx];

                var _content = '';
                if (isExistVar(item.Content) && '' !== item.Content) {
                    _content = '<iframe id="' + item.Frame + '" name="' + item.Frame + '" ';
                    _content += 'src="" style="width:100%;height:100%;'
                    var zoom = item.Zoom || '';
                    if (zoom !== '')
                        _content += 'zoom:' + zoom + '%';
                    var scrolling = item.Scrolling || 'no';
                    _content += '" frameborder="0" scrolling="' + scrolling;
                    _content += '" lnk="' + item.Content + '" refreshOnSelect="' + item.RefreshOnSelect + '"></iframe>';
                }
				if(AllergyLen>0 && item.Frame=="GMFrame"){
					item.Title='<div style="color:red">'+item.Title+"("+AllergyLen+")</div>"	
				}
                $dataTabs.tabs('add', {
                    id: item.Name,
                    title: item.Title,
                    selected: 0 == idx,
                    fit: true,
                    content: _content,
                    href: item.Href
                });
            };
        }

        addTabs(envVar.opResource);

        this.refresh = function() {
            var tabs = $dataTabs.tabs('tabs');
            var len = tabs.length;

            for (var idx = 0; idx < len; idx++) {
                iframe = tabs[idx].find('iframe');
                if (iframe.length > 0) {
                    $(iframe[0]).attr('src', '');
                }
            }
            $dataTabs.tabs('select', 0);
        }

        this.refreshOeordFrame = function() {

            var tabs = $dataTabs.tabs('tabs');
            var tab = $dataTabs.tabs('getSelected');
            var index = $dataTabs.tabs('getTabIndex', tab);
            for (var j = 0, len = tabs.length; j < len; j++) {
                if (tabs[j].panel('options').id === 'DIAoeordFrame') {
                    iframe = tabs[j].find('iframe');
                    if (iframe.length > 0) {
                        $(iframe[0]).attr('src', '');
                        if (index === j)
                            $(iframe[0]).attr('src', replaceLinkParams($(iframe[0]).attr('lnk')));
                    }
                }
            }
        }

        this.checkOeordBeforeUnload = function() {
            var oeordFrame = window.frames['oeordFrame'];
            if (typeof oeordFrame === 'undefined')
                return false;
            var checkModifiedBeforeUnload = oeordFrame.checkModifiedBeforeUnload;
            if (typeof checkModifiedBeforeUnload !== 'function')
                return false;
            var flag = checkModifiedBeforeUnload();
            if (flag && !confirm('医嘱有未审核项目，确定切换?')) {
                return true;
            }
            return false;
        }

        this.switchDataTab = function(tabName) {
            var tab = $('#dataTabs').tabs('getSelected');
            if (tabName === tab.panel('options').title)
                return;

            $.each($('#dataTabs').tabs('tabs'), function(idx, item) {
                if (tabName === item.panel('options').title) {
                    $('#dataTabs').tabs('select', idx);
                    return false;
                }
            });
        }
    };
    /// 链接按钮区
    HisTools['hisTool'] = new function() {
        var $histTool = $('#hisToolTable');

        function Div(exp1, exp2) {
            var ret = Math.round(exp1) / Math.round(exp2);
            return ret >= 0 ? Math.floor(ret) : Math.ceil(ret);
        }

        function resize_res_region(iHeight) {
            if ($('#res_region').length > 0) {
                $('#res_region').layout('panel', 'south').panel('resize', {
                    height: iHeight
                });
                $('#res_region').layout('resize');
            }
        }

        function createHisTools(objHisTools) {
            var html = '',
                rows = 0;

            if (!objHisTools || 0 == objHisTools.length) {
                resize_res_region(1);
                return;
            }

            var html = '',
                rows = 0,
                lastPosition = 10;

            for (var idx = 0, max = objHisTools.length; idx < max; idx++) {
                var item = objHisTools[idx];
                if (0 == idx) {
                    html = html + '<tr>';
                    //if ('#FFFFFF'==item.Color) { $('#hisToolTable').css('background',item.Color); }
                } else if ((Div(item.Position, 10) - Div(lastPosition, 10)) > 0) {
                    html = html + '</tr><tr>';
                    rows++;
                }
                lastPosition = item.Position;
                html += '<td colSpan="' + item.ColSpan + '">';
                html += '<button id="btn' + item.Name + '" idx=' + idx;
                html += ' class="metroButton" style="background:' + item.Background + ';color:' + item.Color + ';" >'; ///color:#008B8B;
                html += item.Text + '</button>';
                html += '</td>';

                setBtnHisToolClick(item);
            };
            if ('' !== html) {
                html += '</tr>';
                rows++;
            }

            resize_res_region(rows * 40);
            $histTool.append(html);
        }

        function startWith(txt, prefix) {
            if (prefix == null || prefix == '' || txt.length == 0 || prefix.length > txt.length)
                return false;
            return (txt.substr(0, prefix.length) == prefix)
        }
        
        function diagresult() {
            var diagFrame = window.frames['diagFrame'];
            if (typeof diagFrame === 'undefined')
                return true;
            var getDiagCount = diagFrame.getDiagCount;
            if (typeof getDiagCount !== 'function')
                return true;
            var count = getDiagCount() || 0;

            return count !== 0;
        }        

        var opHistoolMethods = {
            admComplete: function() {
                //协和医院：完成接诊成功之后，自动关闭电子病历
                var lnk = 'dhcdhcdocoverallinfo.csp?PatientID=@patientID&EpisodeID=@episodeID';
                openHisToolForm('admComplete', '完成接诊', lnk);
                //完成接诊成功之后，自动关闭电子病历
                HisTools.closeEmrFrm();

                $.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: '../EMRservice.Ajax.opHISInterface.cls',
                    async: false,
                    cache: false,
                    data: {
                        action: 'admComplete',
                        EpisodeID: patInfo.EpisodeID
                    },
                    success: function(ret) {
                        if (ret && ret.Err) {
                            $.messager.alert('发生错误', ret.Err);
                        } else {
                            if ('Y' === ret.Value) {
                                HisTools.closeEmrFrm();
                            }
                        }
                    },
                    error: function(ret) {
                        $.messager.alert('发生错误', "admComplete:" + ret);
                    }
                });
            },
            //TODO
            SetComplate: function() {
                $.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: '../EMRservice.Ajax.opHISInterface.cls',
                    async: false,
                    cache: false,
                    data: {
                        action: 'getOPToolsLink',
                        func: 'SetComplate',
                        Adm: patInfo.EpisodeID,
                        LocId: patInfo.UserLocID,
                        UserId: patInfo.UserID,
						IPAddress: patInfo.IPAddress
                    },
                    success: function(ret) {
                        if (ret && ret.Err) {
                            alert('获取HIS链接：' + ret.Err);
                        } else {
                            var msg = ret.Value.split('^');
                            if ('0' == msg[0]) {
                                opHistoolMethods.OPPatListPage();
                            } else
                                alert(msg[1]);
                        }
                    },
                    error: function(ret) {
                        alert('获取HIS链接：' + ret);
                    }
                });
            },    
            //山东省立完成就诊
            admtmplate: function() {
                  if (patInfo.SsgroupID === '557') {
                      window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocEmergencyPatientList&WinOpenFlag=1",true,"status=1,scrollbars=1,top=150,left=300,width=1000,height=630");
                  }else {
                      window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList&WinOpenFlag=1",true,"status=1,scrollbars=1,top=150,left=300,width=1000,height=630");
                  }
            },
            //山东省立第三方预约就诊
            DHCOPAdmRegSDSL: function() {
                var data = ajaxDATA('String', 'EMRservice.Ajax.opHISInterface', 'DHCOPAdmRegSDSL' , patInfo.PatientID, patInfo.UserLocID,patInfo.UserCode);
                ajaxGET(data, function(ret) {
                    if (ret != '')
                        openHisToolForm('appointment', '预约', ret);
                    else
                        alert('获取的链接为空！');
                }, function(ret) {
                    alert('发生错误', '获取HIS链接:' + ret);
                });
            },
            //宁波鄞州获取打开第三方居民健康档案
            DHCPHRNBYZ: function() {
                var data = ajaxDATA('String', 'EMRservice.Ajax.opHISInterface', 'DHCPHRNBYZ' , patInfo.PatientID, patInfo.UserCode);
                ajaxGET(data, function(ret) {
                    if (ret == '0')
                        alert('该病人身份证号为空！');
                    else if (ret == '-1')
                        alert('程序异常，请联系管理人员！');
                    else
                        openHisToolForm('PHR', '居民健康档案', ret, 1200, 700);
                }, function(ret) {
                    alert('发生错误', '获取HIS链接DHCPHRNBYZ:' + ret);
                });
            },
            oeordComfirmNFYY: function() {
                var DIAoeordFrame = window.frames['oeordFrame'];
                if (DIAoeordFrame.checkModifiedBeforeUnload()) {
                    alert('有新开医嘱未保存，请先处理！');
                    DIAoeordFrame.EditRowForEMR();
                    return;
                }

                var iHeight = screen.availHeight - 90;
                var iWidth = (screen.availWidth - 70) * 0.618;
                //var lnk = 'emr.op.print.csp?AutoPrint=N&EpisodeID=' + patInfo.EpisodeID + '&userID=' + patInfo.UserID;
                var lnk = 'emr.op.print.csp?IsWithTemplate=Y&EpisodeID=' + patInfo.EpisodeID;
                var returnValues = window.showModalDialog(lnk, window, 'dialogHeight:' + iHeight + 'px;dialogWidth:' + iWidth + 'px;resizable:no;status:no;');
            },
            inpatientNFYY: function() {
                if (!diagresult()) {
                    alert("请先录入诊断！");
                    return;
                }
                openHisToolForm('inpatientNFYY', '住院证', 'dhcdocipbooknew.csp?IPBKFlag=Booking&EpisodeID=' + patInfo.EpisodeID, 1350, 800);
            },
            SetComplateNFYY: function() {
                if (!diagresult()) {
                    alert("请先录入诊断！");
                    return;
                }                
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'AdmComplete', patInfo.EpisodeID);
                ajaxGET(data, function(ret) {
                    ret = $.parseJSON(ret);
                    if (ret && ret.Err) {
                        $.messager.alert('发生错误', ret.Err);
                    } else {
                        if ('Y' == ret.Value) {
                            var lnk = 'dhcopoutpatlistnew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm';
                            lnk = replaceLinkParams(lnk);
                            var left = document.body.clientWidth - 700;
                            var returnValues = window.showModalDialog("dhcopoutpatlistnew.csp", "", "dialogHeight:700px;dialogWidth:600px;resizable:no;status:no;dialogLeft=" + left);
                            if (!returnValues) {} else {
                                switchPatient(returnValues.PatientID, returnValues.EpisodeID, returnValues.MRAdm);
                            }
                        }
                    }
                }, function(ret) {
                    alert('发生错误', '获取HIS链接:' + ret);
                });
            },
            //标准版完成患者就诊置状态
            SetComplateSdEdition: function() {
                var data = ajaxDATA('String', 'web.DHCDocOutPatientList', 'SetComplate', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID);
                ajaxGET(data, function(ret) {
                    if (ret == '0') {
                        alert('患者已完成就诊!');
                    } else {
                        alert('完成就诊失败!');
                    }
                }, function(ret) {
                    alert('发生错误', '获取HIS链接:' + ret);
                });
            },
            //合肥京东方，完成就诊前需判断是否下诊断
            SetComplateHFJDF: function () {
                var data = ajaxDATA('String', 'EMRservice.Ajax.opHISInterface', 'GetMRDiagnoseCount', patInfo.EpisodeID);
                ajaxGETSync(data, function(ret) {
                    if (ret == '0') {
                        alert('请先录入诊断！');
                        return;
                    }else {
	                 	var data = ajaxDATA('String', 'web.DHCDocOutPatientList', 'SetComplate', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID);
                		ajaxGET(data, function(ret) {
                    		if (ret == '0') {
                        		alert('患者已完成就诊!');
                    		} else {
                        		alert('完成就诊失败!');
                    		}
                		}, function(ret) {
                    		alert('发生错误', '获取HIS链接:' + ret);
                		});                    
	                }
                }, function(ret) {
                    alert('发生错误', '获取诊断数目:' + ret);
                });
            },
            //门诊患者列表
            OPPatListPage: function() {
                window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList&WinOpenFlag=1", true, "status=1,scrollbars=1,top=50,left=10,width=1000,height=630");
            },
            //门诊打印套打
            opPrintCSP: function() {
                var iHeight = screen.availHeight - 50;
                var iWidth = (screen.availWidth - 10) * 0.618;
                var insID = emrEditor.getInstanceID();
                //var lnk = 'emr.op.print.csp?InstanceId=' + insID + '&PatientID=' + patInfo.PatientID + '&EpisodeID=' + patInfo.EpisodeID;
                var lnk = 'emr.op.print.csp?IsWithTemplate=Y&EpisodeID=' + patInfo.EpisodeID + '&InstanceId=' + insID;
                var returnValues = window.showModalDialog(lnk, window, 'dialogHeight:' + iHeight + 'px;dialogWidth:' + iWidth + 'px;resizable:no;status:no;');
            },
            ShowPatientList: function() {
                var lnk = 'dhcopoutpatlistnew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm';
                lnk = replaceLinkParams(lnk);
                var left = document.body.clientWidth - 700;
                var returnValues = window.showModalDialog("dhcopoutpatlistnew.csp", "", "dialogHeight:700px;dialogWidth:600px;resizable:no;status:no;dialogLeft=" + left);
                if (!returnValues) {} else {
                    switchPatient(returnValues.PatientID, returnValues.EpisodeID, returnValues.MRAdm);
                }
            },
            DHCDocOutPatientList: function() {
                if (typeof(parent.refreshBar) === 'function') {
                    setTophref('websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList');
                } else {
                    sethref('websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList');
                }
            },
            HrefPatLstByAdmType: function() {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface',
                    'getAdmType', patInfo.EpisodeID);
                ajaxGET(data, function(ret) {
                    if ('E' === ret) {
                        var tmplink = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocEmergencyPatientList";
                        top.frames['TRAK_main'].location.href = tmplink;
                    } else if ('O' === ret) {
                        var tmplink = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList";
                        top.frames['TRAK_main'].location.href = tmplink;
                    } else {
                        alert('getAdmType：' + ret);
                    }
                }, function(err) {
                    alert('getAdmType：' + (err.message || err));
                });
            },
            NewTreatementRecord: function() {
                var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface',
                    'NewTreatementRecord', patInfo.PatientID, patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID);
                ajaxGET(data, function(ret) {
                    if ('' === ret)
                        return;
                    var lnk = 'emr.createinstance.csp?Templates=' + ret;
                    var returnValues = window.showModalDialog(lnk, patInfo, "dialogHeight:200px;dialogWidth:400px;resizable:no;status:no;");
                    if (!returnValues) {} else {
                        emrEditor.initDocument();
                    }

                }, function(ret) {
                    alert('新增诊程错误：' + ret);
                });

            },
            invoke: function(methodName) {
                var fn = opHistoolMethods[methodName];
                if (typeof fn === 'function') {
                    fn();
                } else {
                    alert('未指定' + methodName);
                }
            },
            sethref: function(lnk) {
                document.location.href = lnk;
            },
            setTophref: function(lnk) {
                if (lnk == 'SetComplate') {
                    var tmplink = "";
                    if ('104' === patInfo.SsgroupID) {
                        tmplink = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocEmergencyPatientList";
                    } else {
                        tmplink = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList";
                    }
                    top.frames['TRAK_main'].location.href = tmplink;
                } else if (lnk == 'SetComplateJNRM') {
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'SetComplate', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID);
                    ajaxGET(data, function(ret) {
                        top.frames['TRAK_main'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList";
                    }, function(ret) {
                        alert('完成就诊失败' + ret);
                    });
                } else {
                    top.frames['TRAK_main'].location.href = lnk;
                }
            },
            getDynamicLink: function(name, text, lnk) {
                var data = ajaxDATA('String', 'EMRservice.Ajax.opHISInterface',
                    'getOPToolsLink', lnk.split(':')[1], patInfo.PatientID);
                ajaxGET(data, function(ret) {
                    if (ret != '')
                        openHisToolForm(name, text, ret);
                    else
                        alert(lnk.split(':')[1] + ':获取的链接为空！');
                }, function(ret) {
                    alert('发生错误', '获取HIS链接:' + ret);
                });
            },
            refreshOeOrdGrd: function() {
                if (typeof HisTools.refreshOeOrdGrd == 'function') {
                    HisTools.refreshOeOrdGrd();
                }
            },
            refreshOeordFrame: function() {
                if (typeof dataTabs.refreshOeordFrame == 'function') {
                    dataTabs.refreshOeordFrame();
                }
            },
            reloadBinddata: function() {
                //emrEditor.reloadBinddata();
                //不显示同步提示框
                iEmrPlugin.REFRESH_REFERENCEDATA({
                    InstanceID: '',
                    AutoRefresh: true,
                    SyncDialogVisible: false,
                    SilentRefresh : true
                });    
            }
        };

        //防止双击
        var isBtnHisToolClicked = false;

        function setBtnHisToolDisable(flag) {
            $("button[id^='btn']").each(function(index, element) {
                element.disabled = flag;
            });
        }

        function setBtnHisToolClick(item) {
            $('#btn' + item.Name).live('click', function() {
                if (isBtnHisToolClicked) { return; }
                isBtnHisToolClicked = true;
                setBtnHisToolDisable(true);
                setTimeout(function () {
                    isBtnHisToolClicked = false;
                    setBtnHisToolDisable(false);
                }, 2000);

                eventSave("openHisTool");
                if (startWith(item.Link, 'func')) {
                    getDynamicLink(item.Name, item.Text, item.Link);
                } else if (startWith(item.Link, 'tophref')) {
                    opHistoolMethods.setTophref(item.Link.split(':')[1]);
                } else if (startWith(item.Link, 'href')) {
                    opHistoolMethods.sethref(item.Link.split(':')[1]);
                } else if (startWith(item.Link, 'method')) {
                    opHistoolMethods.invoke(item.Link.split(':')[1]);
                } else {
                    openHisToolForm(item.Name, item.Text, item.Link, item.FormWidth, item.FormHeight, item.FnNameAfterClose);
                }
                return false;
            });
        }

        function openHisToolForm(name, txt, lnk, wWidth, wHeight, fnNameAfterClose) {
            HisTools.hislinkWindow.setArgs(txt, lnk, null,
                function() {
                    /*if ('oeord' == name && HisTools.refreshOeOrdGrd != null) {
                        HisTools.refreshOeOrdGrd(); //todo
                    } else if ('transfusion' == name) {
                        dataTabs.refreshOeordFrame();
                    }*/
                    var fnAfterClose = opHistoolMethods[fnNameAfterClose];
                    if (typeof fnAfterClose == 'function') {
                        fnAfterClose();
                    }
                });

            HisTools.hislinkWindow.show(name, wWidth, wHeight);
        }

        function GetHisTools() {
            createHisTools(envVar.opHisTools);
        }

        GetHisTools();
    };
}

/// 平台调用
function updateEMRInstanceData(flag, content, callback, episodeID) {
    //增加逻辑校验防止串患者
    if (typeof episodeID != 'undefined') {
        if (patInfo.EpisodeID != episodeID) {
            return;
        }  
    }
    
    var instanceId = emrEditor.getInstanceID();
    if ('' === instanceId)
        return;
    var documentContext = emrEditor.getDocContext(instanceId);
    if (!privilege.canSave(documentContext)) return;

    var displayName = '';
    if (flag === 'diag')
        displayName = '诊断';
    else if (flag === 'oeord')
        displayName = '医嘱';
    else if ((flag === 'oeordCN') || (flag === 'zoeord'))
        displayName = '草药';
    else if (flag === 'pacs')
        displayName = '检查';
    else if (flag === 'allergic')
	{
		displayName = '过敏';
		if ((typeof(content.UpdateEMR)=="undefined")||(content.UpdateEMR != true)) return;
		var queryAllergiesList = "";
		if (typeof(content.QueryAllergiesList)!="undefined") queryAllergiesList = content.QueryAllergiesList;
		var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getAllergic', patInfo.PatientID, queryAllergiesList);
		ajaxGETSync(data, function (ret) {
			content = ret;
		}, function (ret) {
			alert('getAllergic error:' + ret);
		});
	} 
    else
        return;
    editorEvt.evtAfterGetMetaDataTree = function(commandJson) {
        var path = emrEditor.getHyperLinkPath(commandJson.args.items, displayName);
        if (path === '')
            return;
        var rtn = iEmrPlugin.UPDATE_INSTANCE_DATA({
            actionType: 'Replace',
            InstanceID: instanceId || '',
            Path: path,
            Value: content.replace(/@/g, '\r\n'),
            isSync: true
        });
        if (rtn.result == 'OK') {
            eventSave("updateInsByDoc");
            if (typeof callback == 'function') {
                callback();
            }
        }
    };
    iEmrPlugin.GET_METADATA_TREE();
}

//静默刷新绑定数据
function updateEMRReferenceData() {
    var insID = emrEditor.getInstanceID();
    iEmrPlugin.REFRESH_REFERENCEDATA({
        InstanceID: insID || '',
        AutoRefresh: true,
        SyncDialogVisible: false,
        SilentRefresh: true
    });

}

/// 平台的方法
function invokeChartFun(tabName, funName) {
    var fn = this[funName];
    if ('function' === typeof fn) {
        var args = [];
        for (var i = 2, len = arguments.length; i < len; i++) {
            args.push(arguments[i]);
        }
        fn.apply(this, args);
    }
}

function refreshDiagFrame(args) {
    HisTools.diagFrame.refresh(args);
};