function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $('#pnlButton a.button').bind('click', function() {
            if (this.disabled) return;
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
            } else {

            }
        });

        var btnClick = new function() {
            //直接打印
            this.btnPrint = function () {
                emrEditor.printDoc('PrintDirectly');
            };
            
            //先弹出选项再打印
            this.btnPrintOpt = function () {
                emrEditor.printDoc('Print');
            };
            
            //插入半页空白后打印
            this.btnPrintInsertHalfpage = function () {
                emrEditor.printDoc('PrintDocInsertHalfpage');
            };
            
            //南方医院打印要求,先弹出选项再打印
            this.btnPrintNFYY = function () {
                var instanceId = emrEditor.getInstanceID();
                common.getTemplateIDByInsId(instanceId, function (tmpId) {
                    if (tmpId==='1104' || tmpId === '1240') {
                        //$.messager.alert('提示', '请点击右下角病历打印按钮！', 'info');
                        alert('请点击右下角病历打印按钮！');
                        return;
                    }
                    emrEditor.printDoc('PrintDirectly');
                });
            };
            
            //保存
            this.btnSave = function () {
                emrEditor.saveDoc();
            };

            //删除
            this.btnDelete = function () {
                emrEditor.deleteDoc();
            };

            //一键打印(医生站界面)
            this.btnOneClickPrint = function () {
                var antMainUrl = 'dhcdocclickprint.csp?EpisodeID=@episodeID&PatientID=@patientID&mradm=@mradm&userid=@userID&ctlocid=@userLocID';
                var lnk = replaceLinkParams(antMainUrl);
                window.open(lnk, true, "status=1,scrollbars=1,top=50,left=10,width=300,height=500");
            };

            //选择模板
            this.btnTemplateclassify = function () {
                showTemplateTree();
            };

            //语音录入
            this.btnAsrVoice = function () {
                var asrVoiceFlag = $('#asrVoice').find("span").eq(1).text() === '语音输入';
                iEmrPlugin.SET_ASR_VOICE_STATE({
                    Open: asrVoiceFlag,
                    isSync: true
                });
                var txt = asrVoiceFlag ? '停止语音输入' : '语音输入';
                $('#asrVoice').find("span").eq(1).text(txt);
            };

            //特殊符号
            this.btnSpechars = function () {
	            
                //var returnValues = window.showModalDialog("emr.opdoc.spechars.csp","","dialogHeight:420px;dialogWidth:490px;resizable:no;center:yes;status:no");	
                // InputSpechars(returnValues);
                var content = "<iframe id='specharsFrame' scrolling='auto' frameborder='0' src='emr.opdoc.spechars.csp' style='width:100%; height:100%;'></iframe>";
                createModalDialog('spechars',"特殊字符",600,460,'specharsFrame',content,InputSpechars,'');

            };

            //刷新绑定
            this.btnRefreshRefData = function () {
                var insID = emrEditor.getInstanceID();
                iEmrPlugin.REFRESH_REFERENCEDATA({
                    InstanceID: '',
                    AutoRefresh: false,
                    SyncDialogVisible: true
                });
                common.GetRecodeParamByInsID(insID, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.BinddataReload',tempParam);
                });
            };

            //撤销(Ctrl+Z)
            this.btnUndo = function () {
                iEmrPlugin.UNDO();
            };

            //门诊患者列表
            this.btnOPPatList = function () {
                var lnk = 'dhcopoutpatlistnew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm';
                lnk = replaceLinkParams(lnk);
                var left = document.body.clientWidth - 700;
                var returnValues = window.showModalDialog('dhcopoutpatlistnew.csp', '', 'dialogHeight:700px;dialogWidth:600px;resizable:no;status:no;dialogLeft=' + left);
                if (!returnValues) {} else {
                    switchPatient(returnValues.PatientID, returnValues.EpisodeID, returnValues.MRAdm);
                }
            };

            //门诊患者列表
            this.btnOPPatListPage = function () {
                window.open('websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList&WinOpenFlag=1', true, 'status=1,scrollbars=1,top=50,left=10,width=1000,height=630');
            };

            //导出
            this.btnExportDocument = function () {
                //if (!param || param.id == 'GuideDocument')
                var documentContext = emrEditor.getDocContext();
                if (!documentContext || 'ERROR' == documentContext.result) {
                    $.messager.popover({msg:'请选中要导出的文档！',type:'info',style:{top:10,right:5}});
                    return;
                }
                iEmrPlugin.SAVE_LOCAL_DOCUMENT();
            };

            // 打开病历模板
            this.btnTmpl = function(emrTmplCateid) {
                var ret = common.IsAllowMuteCreate(emrTmplCateid);
                if (ret === '0') {
                    //$.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
                    alert('已创建同类型模板，不允许继续创建！');
                    return;
                }
                emrTemplate.LoadTemplate(emrTmplCateid);
            };

            //范例病历
            this.btnmodelinstance = function () {
                //var antMainUrl = 'emr.modelinstance.csp?PatientID=@patientID&EpisodeID=@episodeID&UserID=@userID';
                //lnk = replaceLinkParams(antMainUrl);
                //window.showModalDialog(lnk, window, 'dialogHeight:570px;dialogWidth:350px;resizable:no;status:no');
           	var content = '<iframe id="modelinstanceFrame" scrolling="auto" frameborder=0 style="width:100%;height:100%;display:block;" src=emr.modelinstance.csp?PatientID=@patientID&EpisodeID=@episodeID&UserID=@userID></iframe>'
            	content = replaceLinkParams(content);
            	createModalDialog("modelInstance","范例病历",350,570,"modelinstanceFrame",content,"","");
            };

            //预览
            this.btnPreview = function () {
                var previewFlag = $('#btnPreview').find("span").eq(1).text() === emrTrans('预览');
                iEmrPlugin.PREVIEW_DOCUMENT({
                    Preview: previewFlag
                });
                var txt = previewFlag ? emrTrans('退出预览') : emrTrans('预览');
                $('#btnPreview').find("span").eq(1).text(txt);
                if (previewFlag) {
                    var insId = insId || emrEditor.getInstanceID();
                    common.GetRecodeParamByInsID(insId, function(tempParam) {
                        //自动记录病例操作日志
                        hisLog.browse('EMR.OP.Browse',tempParam);
                    });
                }
            };

            //显示痕迹
            this.btnRevisionVisible = function () {
                var fnBtnRevisionVisible = function () {
                    var txt = $('#btnRevisionVisible').find("span").eq(1).text() === emrTrans('显示痕迹') ? emrTrans('隐藏痕迹') : emrTrans('显示痕迹');
                    $('#btnRevisionVisible').find("span").eq(1).text(txt);
                    return txt === emrTrans('隐藏痕迹');
                };

                privilege.setViewRevise(emrEditor.getDocContext(), fnBtnRevisionVisible);
            };

            //济宁打开第三方病历
            this.btnJNThirdParty = function () {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetPadmCardNo', patInfo.EpisodeID);
                ajaxGETSync(data, function (ret) {
                    var PadmCardNo = ret;
                    window.open("http://172.18.1.24:9080/htmz/ShowOutpatientInfo.jsp?pid=" + PadmCardNo, "");
                }, function (ret) {
                    //$.messager.alert('发生错误', 'GetPadmCardNo error:' + ret, 'error');
                    alert('GetPadmCardNo error:' + ret);
                });
            };

            //操作日志
            this.btnLogFlagInfo = function () {
                var instanceId = emrEditor.getInstanceID();
                var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'LogFlagInfo', instanceId);
                ajaxGETSync(data, function (ret) {
                    result = ret;
                    var TmpNum = result.split('^')[1];
                    var TmpChartItemID = result.split('^')[0];
                    //门诊HisUI页面风格改造-操作日志页面 add by niucaicai 2018-06-20
                    //window.showModalDialog("emr.logdetailrecord.csp?EpisodeID=" + patInfo.EpisodeID + "&EMRDocId=" + TmpChartItemID + "&EMRNum=" + TmpNum, "", "dialogWidth:801px;dialogHeight:550px;resizable:yes;");
                    /* var logdetailSRC = "emr.opdoc.logdetailrecord.csp?EpisodeID=" + patInfo.EpisodeID + "&EMRDocId=" + TmpChartItemID + "&EMRNum=" + TmpNum;
                    $('#LogdetailWin').attr('src',logdetailSRC);
                    $HUI.dialog('#HisUILogdetailWin').open(); */
                    
	                var content = '<iframe id="logdetailWinFrame" scrolling="auto" frameborder="0" src="emr.opdoc.logdetailrecord.csp?EpisodeID=' + patInfo.EpisodeID + '&EMRDocId=' + TmpChartItemID + '&EMRNum=' + TmpNum +'" style="width:100%;height:100%;display:block;"></iframe>';
	            	createModalDialog('LogdetailWin','操作日志',800,450,"logdetailWinFrame",content,"","");
                }, function (ret) {
                    //$.messager.alert('发生错误', 'LogFlagInfo error:' + ret, 'error');
                    alert('LogFlagInfo error:' + ret);
                });
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
            
            //牙位
            this.btnTooth = function() {
                var dialogId = "toothDialog";
                var iframeId = "opdocTooth";
                var src = "emr.ip.tool.tooth.csp?dialogId="+dialogId;
                var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
                createModalDialog(dialogId,"牙位图", 1060, 475,iframeId,iframeCotent,insertTooth);
            };
            
            //权限申请
            this.btnAuthRequest = function () {
	            
                //var returnValues = window.showModalDialog("emr.auth.request.csp?EpisodeID="+ patInfo.EpisodeID + "&PatientID=" + patInfo.PatientID,window,"dialogHeight:550px;dialogWidth:1150px;resizable:no;status:no");
            	var content = '<iframe id="authRequestFrame" scrolling="auto" frameborder="0" src="emr.auth.request.csp?EpisodeID='+patInfo.EpisodeID+"&PatientID="+patInfo.PatientID+'" style="width:100%;height:100%;display:block;"></iframe>';
            	createModalDialog('authRequest','权限申请',1200,600,"authRequestFrame",content,"","");
            };

            //测试
            this.btnTest = function () {
                //footest();
                $.messager.popover({msg: '请选中要导出的文档!',type:'alert',timeout:0,style:{top:10,right:5}});
                //parent.$.messager.popover({msg: '请选中要导出的文档!',type:'alert',timeout:0});
            };
            
            //管理个人模板
            this.btnManagePersonal = function () {
                var documentContext = emrEditor.getDocContext();
                if (typeof documentContext === "undefined" || documentContext.status.curStatus === "") {
			$.messager.alert('提示', "请先保存当前病历后，再打开管理页面！", 'info');
                        return;
                }
                var insID = emrEditor.getInstanceID();
                
                var content = '<iframe id="managePersonalWinFrame" scrolling="auto" frameborder="0" src="emr.opdoc.managepersonal.csp?IstanceID=' + insID + '&UserID=' + patInfo.UserID + '&UserLocID=' + patInfo.UserLocID +'" style="width:100%;height:100%;display:block;"></iframe>';
            	createModalDialog('managePersonalWin','管理个人模版',300,480,"managePersonalWinFrame",content,"","");
                
                /* var ManagePersonalSRC = "emr.opdoc.managepersonal.csp?IstanceID=" + insID + "&UserID=" + patInfo.UserID + "&UserLocID=" + patInfo.UserLocID ;
                $('#ManagePersonalWin').attr('src',ManagePersonalSRC);
                $HUI.dialog('#HisUIManagePersonalWin').open(); */
            };
            
            //文字编辑
            this.btntextedit = function() {
	            var display =$('#textedit').css('display');
				if (display == "block"){
					hideTextEdit();
				}
				else
				{
					showTextEdit();
				}
	        };
            
            //自动审批
            this.btnAutoApply = function () {
	            var documentContext = emrEditor.getDocContext();
		        if (!documentContext)
		            return;
				
				var insID = documentContext.InstanceID;
				if (common.getApplyStatus(insID) == "1")
				{
					$.messager.alert("提示信息", "存在有效授权审批，无需再次申请！", 'info');
					return;
				}

		        if (!privilege.canAutoApply(documentContext)) 
		        {
		            return;
		        }
		       
		        //var returnValues = window.showModalDialog("emr.opdoc.autoapplyreason.csp","","dialogHeight:350px;dialogWidth:626px;resizable:no;status:no");
				var iframe = '<iframe id="autoApplyFrame" scrolling="auto" frameborder="0" src="emr.opdoc.autoapplyreason.csp" style="width:100%;height:100%;display:block;"></iframe>';
				createModalDialog("autoApply","自动审批",680,400,"autoApplyFrame",iframe,autoApplyReturn,documentContext);
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
        }
    }
	function autoApplyReturn(returnValues,documentContext){
			        if (returnValues == "")
		        {
			    	$.messager.alert("提示信息", "自动审批必须填写原因！", 'info');
			    	return;    
			    }
				var insID = documentContext.InstanceID;
		        jQuery.ajax({
					type : "GET",
					dataType : "text",
					url : "../EMRservice.Ajax.AuthAppoint.cls",
					async : false,
					data : {
						"Action":"autorequestForOP",
						"EpisodeID":patInfo.EpisodeID,
						"RequestCateCharpter":insID,
						"RequestUserID":patInfo.UserID,
						"RequestDept":patInfo.UserLocID,
						"EPRAction":"save,print",
						"RequestReason":returnValues,
						"BeforeRequestContent":"",
						"AfterRequestContent":""
						},
					success : function(d) {
			           if ( d == "1" ) 
					   {
							documentContext = emrEditor.getDocContext(insID);
							//设置当前文档操作权限
							emrEditor.setEditorReadonly(documentContext);
							$.messager.popover({msg:'申请编辑成功！', type:'success', style:{top:10,right:5}});
					   }
					},
					error : function(d) { alert("apply edit error");}
				});	
	}
	

    function checkHtml(htmlStr) {  
        var reg = /<[^>]+>/g;  
        return reg.test(htmlStr);  
    } 

    function addButtons(param) {
        var pnlButton = $('#pnlButton'); 
        var tmpButton = $('#toolbarTemplate'); 
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
                var tool = tmpButton.clone();
                tool.removeAttr("style");
                tool.removeAttr("id");
                tool.removeAttr("iconCls");
                if (btn.split(':')[0].indexOf('btnTmpl')!="-1"){
                    tool.css("float","right");
                }else{
                    tool.css("float","left");
                }
                var a = $("a",tool).attr("id",btn.split(':')[0]);
                $("a",tool).css("padding", "0 10px");
                $("a",tool).addClass("button");
                $("a",tool).find("span").eq(2).removeClass("icon-save");
                if(btn.split(':')[2]) {
                    $("a",tool).find("span").eq(2).addClass(btn.split(':')[2]);
                    $("a",tool).find("span").eq(2).css({'top':'4px', 'width':'100%', 'height':'28px', 'line-height':'28px', 'position':'absolute'});
                }
                $("a",tool).find("span").eq(1).text(emrTrans(btn.split(':')[1]));
                $("a",tool).find("span").eq(1).css({'margin':'0', 'padding':'25px 0px 0px', 'text-align':'center'});
                pnlButton.append(tool);
            }
        }
    }

    function getOPEmrButtons() {
        addButtons(envVar.opEmrButtons);
        liveBtnBind();
    }

    // 工具栏调整宽度比例的按钮
    function defineBtnScale() {
        $("#pnlResScale a[id^='btnScale']").bind('click', function () {
            $("#pnlResScale a[id^='btnScale']").css('background-color','');
            $(this).css({'background':'#ddd','border':'#ddd'});
            var rate = parseFloat($(this).attr('rate'));
            $('#resRegion').panel('resize', {
                width: $('#main').width() * rate
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
            //$.messager.alert('发生错误', 'GetSSUserByLocID error:' + ret, 'error');
            alert('GetSSUserByLocID error:' + ret);
        });
        // 'color':'#FF0033','font-weight':'700','font-size':'1.5em'
        html = '<a style="font-size:18px;margin-left:5px;margin-top:0px;">审核人：</a><select name="auditUsrCombo" id="auditUsrCombo" style="width:200px;font-size:18px;margin-left:5px;"></select>';
        pnlButton.append(html);
        //审核按钮
        var html = '<a href="#" id="btnOpOfficeAudit"  class="button small" style="margin-left:5px;margin-top:2px;font-size:18px;color:red;font-weight:700;font-size:1.2em">审&nbsp&nbsp&nbsp核</a>';
        pnlButton.append(html);
        $('#btnOpOfficeAudit').bind('click', function () {
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
                    $.messager.popover({msg:'审核成功！',type:'success',style:{top:10,right:5}});
                    //showEditorMsg('审核成功', 'warning');
                }, function (ret) {
                    //$.messager.alert('发生错误', 'InsertAudit error:' + ret, 'error');
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
                        //$.messager.alert('提示', msg, 'info');
                        alert(msg);
                    }
                    InsertAudit();
                }, function (ret) {
                    //$.messager.alert('发生错误', 'GetAuditLog error:' + ret, 'error');
                    alert('GetAuditLog error:' + ret);
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
    setPnlBtnEditHide(false);
}

function setPnlBtnDisable(flag) {
    //if (envVar.isOfficeAudit && flag) return;
    $('#pnlButton a.button').each(function(index, element) {
        element.disabled = flag;
        if (flag) {
            $("#"+element.id).addClass('l-btn-disabled l-btn-plain-disabled');
        }else {
            $("#"+element.id).removeClass('l-btn-disabled l-btn-plain-disabled');
        }
    });
}

//设置默认展开编辑文字并且按钮非只读时，展开编辑文字界面
function setPnlBtnEditHide(flag) {
    if (sysOption.isDefaultShowTextEdit == "Y")
    {
	    if (flag) {
			hideTextEdit();
		}else{
			showTextEdit();
		}
    }
}

//显示文字编辑区域
function showTextEdit(){
	$('#textedit').show();
	$('#toolbar').panel('resize', {
        height: '105'
    });
    $('#textedit').panel('resize', {
        height: '50',
        width: '100%'
    });
    $('body').layout('resize');
}

//隐藏文字编辑区域
function hideTextEdit(){
	$('#textedit').hide();
	$('#fontColorDiv').hide();
	$('#toolbar').panel('resize', {
        height: '55'
    });
    $('body').layout('resize');
    
    $('#textedit').panel('resize', {
        height: '0',
        width: '0'
    });
    $('body').layout('resize');
}

function footest() {
    var iHeight = screen.availHeight - 50;
    var iWidth = (screen.availWidth - 10) * 0.618;
    var lnk = 'emr.op.print.csp?AutoPrint=N&EpisodeID=' + patInfo.EpisodeID;
    //var returnValues = window.showModalDialog(lnk, window, 'dialogHeight:' + iHeight + 'px;dialogWidth:' + iWidth + 'px;resizable:no;status:no;');
    window.open(lnk, true, "status=1,scrollbars=1,top=50,left=10,width=1000,height=630");
}

//门诊HisUI页面风格改造-特殊字符页面 add by niucaicai 2018-06-19
function InputSpechars(SpecharsValues)
{
    iEmrPlugin.INSERT_STYLE_TEXT_BLOCK({
        args: SpecharsValues,
        isSync: true
    });
}

//设置字体大小
function changeFontSize(){
	iEmrPlugin.FONT_SIZE({
        args:$("#fontSize").find("option:selected").val()
    });
}

//设置字体大小数据源
function setFontSizeData()
{
    var json = [{"value":"14pt","name":"四号"},
                {"value":"12pt","name":"小四号"},
                {"value":"10.5pt","name":"五号"},
                {"value":"42pt","name":"初号"},
                {"value":"36pt","name":"小初号"},
                {"value":"31.5pt","name":"大一号"},
                {"value":"28pt","name":"一号"},
                {"value":"21pt","name":"二号"},
                {"value":"18pt","name":"小二号"},
                {"value":"16pt","name":"三号"},
                {"value":"9pt","name":"小五号"},
                {"value":"8pt","name":"六号"},
                {"value":"6.875pt","name":"小六号"},
                {"value":"5.25pt","name":"七号"},
                {"value":"4.5pt","name":"八号"},
                {"value":"5pt","name":"5"},
                {"value":"5.5pt","name":"5.5"},
                {"value":"6.5pt","name":"6.5"},
                {"value":"7.5pt","name":"7.5"},
                {"value":"8.5pt","name":"8.5"},
                {"value":"9.5pt","name":"9.5"},
                {"value":"10pt","name":"10"},
                {"value":"11pt","name":"11"}
            ]
    for (var i=0;i<json.length;i++)  
    {       
        $('#fontSize').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
    }
    var defaultFontStyle = sysOption.setDefaultFontStyle.replace(/\'/g, "\"");  
    defaultFontStyle = $.parseJSON(('{'+defaultFontStyle+'}'));
    //设置默认显示项
    if ($.browser.version == '6.0')
    {
        setTimeout(function() { 
            $('#fontSize').find('option[value="'+defaultFontStyle.fontSize+'"]').attr("selected",true);    
        }, 1);
    }
    else
    {
        $('#fontSize').find('option[value="'+defaultFontStyle.fontSize+'"]').attr("selected",true);
    }                
}

//将字体颜色传给编辑器
function setFontColor(color){
    iEmrPlugin.FONT_COLOR({
        args:color
    });
}

//点击选择颜色按钮展现颜色选择器
document.getElementById("fontcolor").onclick = function(){
    var display =$('#fontColorDiv').css('display');
	if (display == "block"){
		$('#fontColorDiv').hide();
		$('#textedit').panel('resize', {
			height: '50',
		});
		
		$('#toolbar').panel('resize', {
            height: '105'
        });

        $('body').layout('resize');
	}
	else
	{
		$('#fontColorDiv').show();
		$('#textedit').panel('resize', {
			height: '90',
		});
		
		$('#toolbar').panel('resize', {
            height: '150'
        });

        $('body').layout('resize');
	}
};

//设置粗体
document.getElementById("bold").onclick = function(){    
    iEmrPlugin.BOLD({path:""});
};

//设置斜体
document.getElementById("italic").onclick = function(){
    iEmrPlugin.ITALIC();
};

//设置下划线
document.getElementById("underline").onclick = function(){
    iEmrPlugin.UNDER_LINE();
};

//删除线
document.getElementById("strike").onclick = function(){    
    iEmrPlugin.STRIKE();
};

//设置上标
document.getElementById("super").onclick = function(){
    iEmrPlugin.SUPER();
};

//设置下标
document.getElementById("sub").onclick = function(){    
    iEmrPlugin.SUB();
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
    iEmrPlugin.ALIGN_JUSTIFY();
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
    iEmrPlugin.ALIGN_LEFT();
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
    iEmrPlugin.ALIGN_CENTER();
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
    iEmrPlugin.ALIGN_RIGHT();
};

//设置缩进
document.getElementById("indent").onclick = function(){
    iEmrPlugin.INDENT();
};

//设置反缩进
document.getElementById("unindent").onclick = function(){
    iEmrPlugin.UNINDENT();
};

//剪切
document.getElementById("cut").onclick = function(){
    iEmrPlugin.CUT();
};

//复制
document.getElementById("copy").onclick = function(){
    iEmrPlugin.COPY();
};

//粘贴
document.getElementById("paste").onclick = function(){
    iEmrPlugin.PASTE();
};

//撤销
document.getElementById("undo").onclick = function(){
    iEmrPlugin.UNDO();    
};

//重做
document.getElementById("redo").onclick = function(){
    iEmrPlugin.REDO();
};


