function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $('#pnlButton a').on('click', function() {
            if (isBtnClicked) { return; }
            isBtnClicked = true;
            $('#btnOpOfficeAudit').linkbutton('disable');
            $('#btnOpOfficePDFPrev').linkbutton('disable');
            $('#btnOpOfficePDFPrint').linkbutton('disable');
            setTimeout(function(){
                isBtnClicked = false;
            	$('#btnOpOfficeAudit').linkbutton('enable');
            	$('#btnOpOfficePDFPrev').linkbutton('enable');
            	$('#btnOpOfficePDFPrint').linkbutton('enable');
            }, 2000);

            var fnBtnClick = btnClick[$(this).attr('id')];
            if ('function' == typeof fnBtnClick) {
                fnBtnClick();
            } else {

            }
        });
        
        var btnClick = new function() {
            this.btnOpOfficeAudit = function() {
                var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;

                if ('0' === common.isSaved(instanceId)) {
                    return;
                }
                //获取userid
                var auditUsrId = $('#auditUsrCombo').combobox("getValue");
                var InsertAudit = function() {
	            
                var pdfName = "";
                var pdfPath = "";
                
                pdfName = patInfo.PatientID+"-"+patInfo.EpisodeID+"-"+instanceId.replace("||","@");
                var emrDocId = "";
                try {
                    emrDocId = envVar.savedRecords[0].emrDocId
                } catch(e) {
                    emrDocId = "";
                }
                
                var signArgs = {
                    patientID: patInfo.PatientID,
                    episodeID: patInfo.EpisodeID,
                    printDocID: emrDocId,
                    eprNum: instanceId.split("||")[1],
                    insID: instanceId,
                    userID: patInfo.UserID,
                }
                emrPDFSeal(signArgs,pdfName,pdfPath, emrEditor);
                
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertAudit', instanceId, auditUsrId, patInfo.UserID);
                    ajaxGET(data, function(ret) {
                        if (ret != "-1") {
                            var selectedRow = $('#patientListData').datagrid('getSelected');
                            var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                            $('#patientListData').datagrid('updateRow',{
                                index: rowIndex,
                                row: {
                                    AuditStatus: '已审核'
                                }
                            });
                            showEditorMsg('审核成功', 'alert');
                        }
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
                    //获取usercode和username
                    var auditUsr = $('#auditUsrCombo').combobox("getText");
                    var auditUsrCode = $.trim(auditUsr.split('-')[0]);
                    var auditUsrName = $.trim(auditUsr.split('-')[1]);
                    //HISUI模态框
					var signParam = {"canRevokCheck":"null","callType":"office"}
					var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
                    var iframeContent = '<iframe id="ShowSign" scrolling="auto" frameborder="0" src="emr.opdoc.sign.csp?UserCode='+auditUsrCode+'&signParam='+signParamStr+'" style="width:100%;height:100%;display:block;"></iframe>'
                    var callback = function(returnValue,arr){
						if(typeof returnValue != 'undefined'){
							var ret = returnValue
							if (ret != '') {
					        	ShowAuditLog();
					    	}
						}
					}
                    createModalDialog("signDialog", "签名信息", 350, 300, "ShowSign", iframeContent,callback,"")
                } else {
                    ShowAuditLog();
                }
            };
            this.btnOpOfficePDFPrev = function() {
                var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;
                var pdfInfo = "";
                var data = {
                    action: 'getPDFInfo',
                    episodeID: patInfo.EpisodeID,
                    insID: instanceId,
                }
                var chkAuditPDF = function () {
                    $.ajax({
                        type: 'POST',
                        dataType: 'text',
                        url: '../CA.Ajax.anySign.cls',
                        async: false,
                        cache: false,
                        data: data,
                        success: function (ret) {
                            pdfInfo = JSON.parse(ret)
                            pdfPreview(pdfInfo.pdfB64, pdfInfo.pdfName);
                        },
                        error: function (ret) {
                            alert("获取PDF错误");
                        }
                    });
                }
                chkAuditPDF();
            };
            this.btnOpOfficePDFPrint = function() {
                var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;
                var pdfInfo = "";
                var data = {
                    action: 'getPDFInfo',
                    episodeID: patInfo.EpisodeID,
                    insID: instanceId,
                }
                var chkAuditPDF = function () {
                    $.ajax({
                        type: 'POST',
                        dataType: 'text',
                        url: '../CA.Ajax.anySign.cls',
                        async: false,
                        cache: false,
                        data: data,
                        success: function (ret) {
                            pdfInfo = JSON.parse(ret);
                            printToRealPrint(pdfInfo.pdfB64, pdfInfo.pdfName);
                        },
                        error: function (ret) {
                            alert("获取PDF错误");
                        }
                    });
                }
                chkAuditPDF();
            };
        };
    }

    //审核人列表
    function initAuditList() {
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetSSUserByLocID', patInfo.UserLocID);
        ajaxGET(data, function(ret) {
            if ('' != ret) {
                var userlst = $.parseJSON(ret);
                var userList = [];
                for (var i = 0; i < userlst.length; i++) {
                    var item = userlst[i];
                	var UserID = item.ID;
                	var UserName = item.Name;	
                    var userInfo = {ID:UserID,Name:UserName};
                    userList.push(userInfo)
                }
                //google遮挡问题
                var cbox = $HUI.combobox("#auditUsrCombo",{
					valueField:'ID', 
					textField:'Name', 
					//panelHeight:"auto",
					data:userList,
					onShowPanel:function(){
						$("#editor").css("display","none");
						},
					onHidePanel:function(){
						$("#editor").css("display","block");				
						}
					})
				//解决combobox被ActiveX控件遮挡问题
                $(".combo-panel").prepend('<iframe frameborder="0" scrolling="no" style="background-color:transparent; position: absolute; z-index: -1; width: 100%; height: 100%; top: 0; left:0;"></iframe>');
                
                //增加判断登录用户是否存在于审核人列表
                var isAuditUser = false;
                for (var i = 0;i<userlst.length;i++){
	            	if(userlst[i].ID == patInfo.UserID){
		            	isAuditUser = true;
		            	//一旦存在就退出循环
		            	break;
		           	}
	            }
                if(isAuditUser){
	            	//如果登录人在审核人列表 选中当前登录用户
                	$('#auditUsrCombo').combobox('setValue', patInfo.UserID);    
	            }else{
		        	//否则不选中任何用户
                	$('#auditUsrCombo').combobox('setValue', '');	
		        }
            }else {
                alert('未获取到审核人列表数据');
            }
        }, function(ret) {
            alert('GetSSUserByLocID error:' + ret);
        });
    }
    
    initAuditList();
    liveBtnBind();
    //设置按钮默认不可用 加载病例后才可以点击
    $('#btnOpOfficeAudit').linkbutton('disable');
    $('#btnOpOfficePDFPrev').linkbutton('disable');
    $('#btnOpOfficePDFPrint').linkbutton('disable');
}
function closeEditorDiaglog(args){
	$HUI.dialog("#HisuiShowSign").close();
}