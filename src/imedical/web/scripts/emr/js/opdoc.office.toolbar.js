function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $('#pnlButton a').on('click', function() {
            if (isBtnClicked) { return; }
            isBtnClicked = true;
            $('#btnOpOfficeAudit').linkbutton('disable');
            $('#btnAuditAndPrint').linkbutton('disable');
            $('#btnPrint').linkbutton('disable');
            $('#btnRefuse').linkbutton('disable');
			$('#btnViewRevision').linkbutton('disable');
            $('#btnBrowse').linkbutton('disable');
            /* $('#btnOpOfficePDFPrev').linkbutton('disable');
            $('#btnOpOfficePDFPrint').linkbutton('disable'); */
            setTimeout(function(){
                isBtnClicked = false;
                var selectedRow = $('#patientListData').datagrid('getSelected');
				if (selectedRow.Status == "已签名")
				{
					if (selectedRow.AuditStatus !== "已拒绝")
					{
						$('#btnOpOfficeAudit').linkbutton('enable');
						$('#btnAuditAndPrint').linkbutton('enable');
						if (selectedRow.AuditStatus == "未审核") {
							$('#btnRefuse').linkbutton('enable');
						} else {
							$('#btnPrint').linkbutton('enable');
						}
					}
				}
				$('#btnViewRevision').linkbutton('enable');
				$('#btnBrowse').linkbutton('enable');
            	/* $('#btnOpOfficePDFPrev').linkbutton('enable');
            	$('#btnOpOfficePDFPrint').linkbutton('enable'); */
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
                    return false;

                if ('0' === common.isSaved(instanceId)) {
                    return false;
                }
                //获取审核人userid
                var auditUsrId = $('#auditUsrCombo').combobox("getValue");
                if (auditUsrId == "")
            	{
                	top.$.messager.alert("提示信息", "未选择审核人", 'info');
                	return false;
                }
                var InsertAudit = function() {
		            var selectedRow = $('#patientListData').datagrid('getSelected');
					if (selectedRow.InstanceID !== instanceId)
					{
						top.$.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
				    	return false;
					}
		            
	                var pdfName = "";
	                var pdfPath = "";
	                
	                pdfName = patInfo.PatientID+"-"+patInfo.EpisodeID+"-"+instanceId.replace("||","@");
	                var emrDocId = "";
	                try {
	                    emrDocId = envVar.savedRecords.emrDocId
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
	                //emrPDFSeal(signArgs,pdfName,pdfPath, emrEditor);
                
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertAudit', instanceId, auditUsrId, patInfo.UserID);
                    ajaxGETSync(data, function(ret) {
                        if (ret == "1") {
                            var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                            $('#patientListData').datagrid('updateRow',{
                                index: rowIndex,
                                row: {
                                    AuditStatus: '已审核'
                                }
                            });
                            top.$.messager.alert("提示信息", "审核成功", 'info');
                            $('#btnPrint').linkbutton('enable');
                            $('#btnRefuse').linkbutton('disable');
                            if((typeof(printFlag) !== 'undefined')&&(printFlag))
                            {	//当点击审核并打印后调用打印方法
                            	emrEditor.printDoc();
                            	printFlag = false;
                            }
                            return true;
                        }
                    }, function(ret) {
                        alert('InsertAudit error:' + ret);
                    });
                }

                var ShowAuditLog = function() {
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetAuditLog', instanceId);
                    ajaxGETSync(data, function(ret) {
                        if ('' != ret) {
                            var info = ret.split('^');
                            var msg = '已审核' + info.length + '次：\r\n';
                            for (var idx = 0, max = info.length; idx < max; idx++) {
                                msg += '      ' + info[idx] + '\r\n';
                            }
                            top.$.messager.alert("提示信息", msg, 'info');
                        }
                        var rtn = InsertAudit();
                        return rtn || false;
                    }, function(ret) {
                        alert('GetAuditLog error:' + ret);
                    });
                }

                if ('' == auditUsrId) {
                    return false;
                } /* else if (patInfo.UserID != auditUsrId) {
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
                }  */
                else {
                    return ShowAuditLog();
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
            //打印
            this.btnPrint = function() {
	            var instanceId = emrEditor.getInstanceID();
                if (instanceId === '') return;
                var selectedRow = $('#patientListData').datagrid('getSelected');
				if (selectedRow.InstanceID !== instanceId)
				{
					top.$.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
			    	return;
				}
	            emrEditor.printDoc();
	            $('#btnPrint').linkbutton('enable');
            };
            //拒绝
            this.btnRefuse = function() {
	            var insId = emrEditor.getInstanceID();
	            if (insId == "") return;
	        	var selectedRow = $('#patientListData').datagrid('getSelected');
	        	if (selectedRow.InstanceID == insId)
	        	{
		        	//获取审核人userid
                	var auditUsrId = $('#auditUsrCombo').combobox("getValue");
                	if (auditUsrId == "")
                	{
	                	top.$.messager.alert("提示信息", "未选择审核人", 'info');
	                	$('#btnRefuse').linkbutton('enable');
	                	return;
	                }
		        	var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertRefuse', insId, auditUsrId, patInfo.UserID);
                    ajaxGET(data, function(ret) {
                        if (ret == "1") {
                            var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                            $('#patientListData').datagrid('updateRow',{
                                index: rowIndex,
                                row: {
                                    AuditStatus: '已拒绝'
                                }
                            });
                            top.$.messager.alert("提示信息", "拒绝成功", 'info');
                            $('#btnOpOfficeAudit').linkbutton('disable');
			    $('#btnAuditAndPrint').linkbutton('disable');
			    $('#btnPrint').linkbutton('disable');
                            $('#btnRefuse').linkbutton('disable');
                        }
                    }, function(ret) {
                        alert('InsertRefuse error:' + ret);
                    });
		        }
		        else
		        {
			        top.$.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
			    	return;
			    }
            };
            //审核并打印
            this.btnAuditAndPrint = function() {
	            var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;
				var selectedRow = $('#patientListData').datagrid('getSelected');
				if (selectedRow.InstanceID !== instanceId)
				{
					top.$.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
			    	return;
				}
				
                if ('0' === common.isSaved(instanceId)) {
                    return;
                }
				printFlag = true;
                var rtn = btnClick.btnOpOfficeAudit();
                if (!rtn) {
                    printFlag = false;
                }
            };
            //病历浏览
            this.btnBrowse = function(){
	            var selectedRow = $('#patientListData').datagrid('getSelected');
	            var episodeID = selectedRow.EpisodeID;
	            var patientID = selectedRow.PatientID;
	            var xpwidth=window.screen.width-60;
				var xpheight=window.screen.height-260;
				var tempFrame = "<iframe id='iframeBrowse' scrolling='auto' frameborder='0' src='websys.chartbook.hisui.csp?PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse&EpisodeID="+episodeID+"&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
				createModalDialog("browse","病历浏览",xpwidth,xpheight,"iframeBrowse",tempFrame,"","");

				//window.showModalDialog("emr.record.browse.csp?EpisodeID="+episodeID+"&PatientID="+patientID,"","dialogHeight:"+xpwidth+";dialogWidth:"+xpheight+";resizable:yes;status:no");
           	};
			//显示留痕
           	this.btnViewRevision = function(){
	           	if ($("#btnViewRevision").text() == "显示留痕") {
		           	$('#btnViewRevision').linkbutton({
						text : '隐藏留痕'
					});
		           	emrEditor.viewRevision(true);
		        } else {
			        $('#btnViewRevision').linkbutton({
						text : '显示留痕'
					});
		           	emrEditor.viewRevision(false);
		        }
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
						document.getElementById("editor").style.visibility="hidden";
						},
					onHidePanel:function(){
						document.getElementById("editor").style.visibility="visible";				
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
    $('#btnAuditAndPrint').linkbutton('disable');
    $('#btnPrint').linkbutton('disable');
    $('#btnRefuse').linkbutton('disable');
	$('#btnViewRevision').linkbutton('disable');
    $('#btnBrowse').linkbutton('disable');
    /* $('#btnOpOfficePDFPrev').linkbutton('disable');
    $('#btnOpOfficePDFPrint').linkbutton('disable'); */
}
function closeEditorDiaglog(args){
	$HUI.dialog("#HisuiShowSign").close();
}