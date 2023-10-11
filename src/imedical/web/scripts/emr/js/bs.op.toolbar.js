function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $("#pnlButton a.button").bind("click", function() {
            if (this.disabled){
                return;
            }
            if (isBtnClicked){
                return;
            }
            isBtnClicked = true;
            var isReadonly = emrService.getReadonly();
            if (!isReadonly){
                setPnlBtnDisable(true);
            }
            //setPnlBtnDisable(true);
            setTimeout(function(){
                isBtnClicked = false;
                if (!isReadonly){
                    setPnlBtnDisable(false);
                }
            }, 2000);
            
            if ("btnTmpl" == $(this).attr("id").substring(0, 7)){
                btnClick.btnTmpl($(this).attr("id").substring(7));
            }else{
                var fnBtnClick = btnClick[$(this).attr("id")];
                if ("function" == typeof fnBtnClick) {
                    fnBtnClick();
                }else{

                }
            }
        });

        var btnClick = new function() {
            //直接打印
            this.btnPrint = function () {
                emrService.printDoc(1);
            };
            
            //弹窗打印
            this.btnPrintOpt = function () {
                emrService.printDoc(0);
            };
            
            //保存
            this.btnSave = function () {
                var documentIDs = [];
                var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:documentIDs},product: envVar.product});
                if ("fail" === command.result){
                    showEditorMsg({msg:"获取待保存病历集合失败！",type:"error"});
                }else{
                    if (command.params){
                        for (var i=0;i<command.params.length;i++){
                            var rtn = privilege.getPrivilege(command.params[i].id);
                            if ("1" != rtn.canSave){
                                showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                                return false;
                            }
                            documentIDs.push(command.params[i].id);
                        }
                    }else{
                        var documentID = emrService.getCurrentDocumentID();
                        var docStatus = emrService.getCurrentDocStatus(documentID);
                        if (docStatus && (docStatus.curStatus === "created")){
                            var rtn = privilege.getPrivilege(documentID);
                            if ("1" != rtn.canSave){
                                showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                            }else{
                                documentIDs.push(documentID);
                            }
                        }
                    }
                }
                if (0 != documentIDs.length){
                    emrService.saveDoc(documentIDs,true);
                }
            };

            //删除
            this.btnDelete = function () {
                emrService.deleteDoc();
            };
            
            //选择模板
            this.btnTemplateclassify = function () {
                showTemplateTree();
            };

            //特殊符号
            this.btnSpechars = function () {
                createModalDialog("spechars","特殊字符",600,460,"specharsFrame",'<iframe id="specharsFrame" scrolling="auto" frameborder="0" src="emr.bs.op.spechars.csp?product='+envVar.product+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
            };

            //刷新绑定
            this.btnRefreshRefData = function () {
                var documentID = emrService.getCurrentDocumentID();
                if (documentID){
                    emrService.reloadBindData(documentID,false);
                }
            };

            //预览
            this.btnPreview = function () {
                var previewFlag = $("#btnPreview").find("span").eq(1).text() === emrTrans("预览");
                var reviseValue = {
                    del: {
                        show: "0"
                    },
                    add: {
                        show: "0"
                    },
                    style: {
                        show: "0"
                    }
                };
                if (!previewFlag){
                    var reviseReturn = EmrEditor.syncExecute({action:"GET_PARAMETERS",params:{value:"revise"},product: envVar.product});
                    if ("fail" === reviseReturn.result){
                        showEditorMsg({msg:"获取病历编辑器留痕显示参数失败，请检查！",type:"error"});
                        return;
                    }
                    var revisionVisible = $('#btnRevisionVisible').find("span").eq(1).text() === emrTrans('显示痕迹') ? "0" : "1";
                    reviseValue = reviseReturn.params;
                    reviseValue.del.show = revisionVisible;
                    reviseValue.add.show = revisionVisible;
                    reviseValue.style.show = revisionVisible;
                }
                var documentStatus = previewFlag ? "browse":"write";
                EmrEditor.syncExecute({
                    action:"SET_PARAMETERS",
                    params:{
                        status: documentStatus,
                        revise: reviseValue
                    },
                    product: envVar.product
                });
                var txt = previewFlag ? emrTrans("退出预览") : emrTrans("预览");
                $("#btnPreview").find("span").eq(1).text(txt);
                if (previewFlag) {
                    var documentID = emrService.getCurrentDocumentID();
                    if (documentID) {
                        //自动记录病例操作日志
                        hisLog.browse("EMR.OP.Browse",documentID);
                    };
                }
            };

            //显示痕迹
            this.btnRevisionVisible = function () {
                var fnBtnRevisionVisible = function () {
                    var txt = $('#btnRevisionVisible').find("span").eq(1).text() === emrTrans('显示痕迹') ? emrTrans('隐藏痕迹') : emrTrans('显示痕迹');
                    $('#btnRevisionVisible').find("span").eq(1).text(txt);
                    return txt === emrTrans('隐藏痕迹');
                };

                privilege.setViewRevise(emrService.getCurrentDocumentID(), fnBtnRevisionVisible);
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

            //操作日志
            this.btnLogFlagInfo = function () {
                var documentID = emrService.getCurrentDocumentID();
                if (documentID) {
                    createModalDialog("logdetailWin","操作日志",1300,450,"logdetailWinFrame",'<iframe id="logdetailWinFrame" scrolling="auto" frameborder="0" src="emr.bs.op.logdetailrecord.csp?documentID='+documentID+"&product="+envVar.product+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
                }
            };

            //门诊图库
            this.btnImage = function () {
                var width = window.screen.availWidth - 250;
                var height = window.screen.availHeight - 250;
                createModalDialog("imageModal","图库",width,height,"iframeImage",'<iframe id="iframeImage" scrolling="auto" frameborder="0" src="emr.bs.op.image.csp?product='+envVar.product+"&UserID="+patInfo.userID+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
            };

            //管理个人模板
            this.btnManagePersonal = function () {
                var documentID = emrService.getCurrentDocumentID();
                if (documentID){
                    createModalDialog("managePersonalModal","管理个人模版",300,480,"iframeManagePersonal",'<iframe id="iframeManagePersonal" scrolling="auto" frameborder="0" src="emr.bs.op.managepersonal.csp?DocumentID='+documentID+'&product='+envVar.product+"&UserLocID="+patInfo.userLocID+"&UserID="+patInfo.userID+"&UserCode="+patInfo.userCode+"&EpisodeID="+patInfo.episodeID+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
                }else{
                    showEditorMsg({msg:"请先打开病历，再操作个人模板管理页面！",type:"info"});
                }
            };

            //患者签名：待签二维码
            this.btnPatPushSignQR = function() {
                var documentID = emrService.getCurrentDocumentID();
                if (documentID){
                    common.getPatPushSignQR(documentID, function(ret){
                        if (ret.split("^")[0] == "1") {
                            var patPushSignID = ret.split("^")[1];
                            if (patPushSignID == ""){
                                showEditorMsg({msg:"没有已推送的待签PDF文档！",type:"alert"});
                            }else{
                                createModalDialog("patPushSignQRModal","患者签名二维码",550,450,"iframePatPushSignQR",'<iframe id="iframePatPushSignQR" scrolling="auto" frameborder="0" src="../csp/dhc.certauth.patsign.tosignqr.csp?EpisodeID='+patInfo.episodeID+'&PatPushSignID='+patPushSignID+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
                            }
                        }else if(ret === "0"){ 
                            showEditorMsg({msg:"没有已推送的待签PDF文档！",type:"alert"});
                        }else{
                            alert(ret);
                        }
                    });
                }
            }

            //患者签名：同步患者签名结果
            this.btnPatPushSignResult = function() {
                common.patPdfSign(common.fetchPatPushSignResult);
            };

            //患者签名：患者重签
            this.btnPatPushSignInvalid = function() {
                common.patPdfSign(common.invalidPatSignedPDF);
            }

            //验证CA签名
            this.btnVerifySignedData = function() {
                var documentID = emrService.getCurrentDocumentID();
                if (documentID){
                    common.verifySignedData(documentID);
                }
            };

            //牙位
            this.btnTooth = function() {
                modalDialogArgs = "";
                var width = window.screen.availWidth - 250;
                var height = window.screen.availHeight - 250;
                var dialogID = "toothDialog";
                var iframeId = "iframeTooth";
                var src = "emr.bs.op.tooth.csp?dialogID="+dialogID+"&MWToken="+getMWToken();
                var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
                createModalDialog(dialogID,"牙位图", width, height, iframeId, iframeCotent, emrService.insertTooth);
            };

            //前房深度公式
            this.btnEye = function() {
                EmrEditor.syncExecute({action:"COMMAND",params:'eyeDeepGrade',product: envVar.product});
            };

            //胎心图
            this.btnFetalHeartChart = function() {
                EmrEditor.syncExecute({action:"COMMAND",params:'fetalHeart',product: envVar.product});
            };

            //门诊签名按钮(只支持单一签名单元的签名与改签)
            this.btnSign = function() {
                var documentID = emrService.getCurrentDocumentID();
                if (documentID){
                    var commandJson = emrService.getDoctortSign(documentID);
                    if ("fail" === command.result){
                        showEditorMsg({msg:"获取医生签名列表集合失败！",type:"error"});
                        return;
                    }else if (commandJson.params.documentID.length > 1){
                        showEditorMsg({msg:"只支持单一签名单元的签名与改签！",type:"info"});
                        return;
                    }else{
                        editorEvent.eventRequestSign({"action": "eventRequestSign","args": commandJson.params.documentID[0]});
                    }
                }
            };

            //测试
            this.btnTest = function () {
                var callBack = {
                  response: function (value) {
                    console.log(value);
                  },
                  reject: function (error) {
                    console.log(error);
                  },
                };
                EmrEditor.syncExecute({
                  action: 'GET_PDF',
                  params: [],
                  callBack: callBack,
                  product: envVar.product
                });
                //parent.$.messager.popover({msg: '请选中要导出的文档!',type:'alert',timeout:0,style:{top:10,right:5}});
                //var width = window.screen.availWidth - 250;
                //var height = window.screen.availHeight - 250;
                //createModalDialog("browseModal","测试",width,height,"iframeImage",'<iframe id="iframeImage" scrolling="auto" frameborder="0" src="emr.interface.episode.print.csp?product='+envVar.product+"&EpisodeID="+patInfo.episodeID+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
            };
        }
    }

    function addButtons(param) {
        var pnlButton = $("#pnlButton"); 
        var tmpButton = $("#toolbarTemplate");
        $.each(param,function(index,item){
            var tool = tmpButton.clone();
            tool.removeAttr("style");
            tool.removeAttr("id");
            tool.removeAttr("iconCls");
            tool.css("float","left");
            //按钮ID如果带有^会有异常，替换为-
            var a = $("a",tool).attr("id",item["id"].replace(/\^/g, "-"));
            $("a",tool).css("padding", "0 10px");
            $("a",tool).addClass("button");
            $("a",tool).find("span").eq(2).removeClass("icon-save");
            if(item["icon"]) {
                $("a",tool).find("span").eq(2).addClass(item["icon"]);
                $("a",tool).find("span").eq(2).css({"top":"4px", "width":"100%", "height":"28px", "line-height":"28px", "position":"absolute"});
            }
            $("a",tool).find("span").eq(1).text(emrTrans(item["desc"]));
            $("a",tool).find("span").eq(1).css({"margin":"0", "padding":"25px 0px 0px", "text-align":"center"});
            pnlButton.append(tool);
        });
        slider = new Slider($(".scale-slider"), {
            start: 50,
            end: 200,
            initValue: sysOption.scale || 100,
            onChange: function (val) {
                common.setUserConfig("bsEditorScale",val);
                sysOption.scale = val;
                if (document.getElementById("bsEditor").innerHTML){
                    EmrEditor.syncExecute({action:"UPDATE_PARAMETERS",params:{scale: val/100},product: envVar.product});
                }
            }
        });
    }

    function getOPEmrButtons() {
        addButtons(sysOption.toolButtons);
        liveBtnBind();
    }
    // 工具栏调整宽度比例的按钮
    function defineBtnScale() {
        $("#pnlResScale a[id^='btnScale']").bind("click", function () {
            $("#pnlResScale a[id^='btnScale']").css("background-color","");
            $(this).css({"background":"#ddd","border":"#ddd"});
            var rate = parseFloat($(this).attr("rate"));
            var tempRate = 1-rate;
            $("#resRegion").panel("resize", {
                width: $("#main").width() * tempRate
            });
            $("body").layout("resize");
            common.setUserConfig("resourceDisplay",tempRate);
        });
    }
    getOPEmrButtons();
    defineBtnScale();
    setPnlBtnDisable(true);
    setPnlBtnEditHide(false);
    //初始化文字大小修改(正常项目不开放)
    //setFontSizeData();
}

//excludeBtn排除置灰不可用按钮数组集合
function setPnlBtnDisable(flag, btn) {
    var excludeBtn = new Array();
    if (isExistVar(btn)){
        excludeBtn = btn || [];
    }
    $("#pnlButton a.button").each(function(index, element) {
        if (excludeBtn.indexOf(element.id) != "-1" && flag){
            element.disabled = false;
            $("#"+element.id).removeClass("l-btn-disabled l-btn-plain-disabled");
            return true;
        }
        element.disabled = flag;
        if (flag) {
            $("#"+element.id).addClass("l-btn-disabled l-btn-plain-disabled");
        }else {
            $("#"+element.id).removeClass("l-btn-disabled l-btn-plain-disabled");
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
    //$('#fontColorDiv').hide();
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

//设置字体大小
function changeFontSize(value){
    EmrEditor.syncExecute({action:"COMMAND",params:{fontSize:value},product: envVar.product});
}

//设置字体大小数据源
function setFontSizeData()
{
    var json = [{"value":"42","name":emrTrans("初号")},
        {"value":"36","name":emrTrans("小初号")},
        {"value":"31.5","name":emrTrans("大一号")},
        {"value":"28","name":emrTrans("一号")},
        {"value":"21","name":emrTrans("二号")},
        {"value":"18","name":emrTrans("小二号")},
        {"value":"16","name":emrTrans("三号")},
        {"value":"14","name":emrTrans("四号")},
        {"value":"12","name":emrTrans("小四号")},
        {"value":"10.5","name":emrTrans("五号")},
        {"value":"9","name":emrTrans("小五号")},
        /*{"value":"8","name":"六号"},
        {"value":"6.875","name":"小六号"},
        {"value":"5.25","name":"七号"},
        {"value":"4.5","name":"八号"},
        {"value":"5","name":"5"},
        {"value":"5.5","name":"5.5"},
        {"value":"6.5","name":"6.5"},
        {"value":"7.5","name":"7.5"},
        {"value":"8.5","name":"8.5"},*/
        {"value":"9.5","name":"9.5"},
        {"value":"10","name":"10"},
        {"value":"11","name":"11"}
    ];
    $HUI.combobox("#fontSizeCom",{
        valueField:'value',
        textField:'name',
        multiple:false,
        selectOnNavigation:false,
        editable:false,
        data:json,
        onSelect:function(record){
            if (isExistVar(record)){
                changeFontSize(record.value);
            }
        }
    });
}

//设置字体颜色   start
$("#fontcolor").colorpicker({
});
//打开/关闭颜色选择器
document.getElementById("fontcolor").onclick = function(){
    var colorpanelshow = $("#fontcolor").attr("colorpanelshow");
    if (colorpanelshow == "1")
    {
        $("#colorpanel").hide();
        $("#fontcolor").attr("colorpanelshow","0");
    }
    else if (colorpanelshow == "0")
    {
        $("#colorpanel").show();
        $("#fontcolor").attr("colorpanelshow","1");
    }
};
//将字体颜色传给编辑器
function setFontColor(c){
    EmrEditor.syncExecute({action:"COMMAND",params:{color:c},product: envVar.product});
    $("#fontcolor").attr("colorpanelshow","0");
};
//设置字体颜色   end

//设置粗体
document.getElementById("bold").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:"bold",product: envVar.product});
};

//设置斜体
document.getElementById("italic").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:"italic",product: envVar.product});
};

//设置下划线
document.getElementById("underline").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:"underline",product: envVar.product});
};

//删除线
document.getElementById("strikethrough").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:"strikethrough",product: envVar.product});
};

//设置上标
document.getElementById("sup").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'sup',product: envVar.product});
};

//设置下标
document.getElementById("sub").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'sub',product: envVar.product});
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:{paragraphStyle:{textAlign:'justify'}},product: envVar.product});
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:{paragraphStyle:{textAlign:'left'}},product: envVar.product});
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:{paragraphStyle:{textAlign:'center'}},product: envVar.product});
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:{paragraphStyle:{textAlign:'right'}},product: envVar.product});
};

//增加缩进
document.getElementById("indent").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:{addIndent:'indent'},product: envVar.product});
};

//减少缩进
document.getElementById("outdent").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:{addIndent:'outdent'},product: envVar.product});
};

//剪切
document.getElementById("cut").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'cut',product: envVar.product});
};

//复制
document.getElementById("copy").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'copy',product: envVar.product});
};

//粘贴
document.getElementById("paste").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'paste',product: envVar.product});
};

//撤销
document.getElementById("undo").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'undo',product: envVar.product});
};

//重做
document.getElementById("redo").onclick = function(){
    EmrEditor.syncExecute({action:"COMMAND",params:'redo',product: envVar.product});
};

function showTemplateTree(){
    var width = 300;
    var height = 480;
    if ("Y" === sysOption.isShowTmpBrowse) {
        width = window.screen.availWidth - 250;
        height = window.screen.availHeight - 250;
    }
    createModalDialog("tempClassifyModal","选择模板",width,height,"iframeTempClassify",'<iframe id="iframeTempClassify" scrolling="auto" frameborder="0" src="emr.bs.op.templateclassify.csp?product='+envVar.product+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
}
function tempCallBack(node){
    if (node){
        emrService.saveConfirm3(true,[],node,function(docParam){
            if (docParam){
                var createArgs = {
                    action: "ISCAN_CREATE",
                    params:{
                        episodeID: patInfo.episodeID,
                        templateID: docParam.templateID
                    },
                    product: envVar.product
                };
                var rtn = common.isCanCreate(createArgs);
                if ("1" != rtn.canCreate){
                    showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
                    return;
                }
                rtn = "";
                if ("1" === docParam.serial){
                    $.each(envVar.savedRecords,function(index,item){
                        if ("1" != item.serial) {
                            return true;
                        }
                        if (docParam.docCategoryCode === item.docCategoryCode){
                            rtn = item;
                            return false;
                        }
                    });
                }
                if (rtn){
                    // 选中实例页签,追加创建
                    var isSelected = emrTemplate.selectTmplTab(rtn.docCategoryCode);
                    if (isSelected){
                        emrService.loadDoc(rtn, false);
                        docParam.actionType = "ADD_ARTICLE";
                        emrService.createDoc(docParam);
                    }else{
                        showEditorMsg({msg:"未选中病历实例页签，请检查！",type:"error"});
                        return;
                    }
                }else{
                    emrService.createDoc(docParam);
                    //新建病历后取消实例页签的选中状态
                    emrTemplate.unselectTmplTab();
                }
            }else{
                showEditorMsg({msg:"未查到要显示的病历数据，请检查！",type:"info"});
            }
        });
    }
    closeDialog("tempClassifyModal");
};

