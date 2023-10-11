function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $('#pnlButton a').live('click', function() {
            if (isBtnClicked) { return; }
            isBtnClicked = true;
            setBtnStatus("N");
            setTimeout(function(){
                isBtnClicked = false;
                var selectedRow = $('#patientListData').datagrid('getSelected');
				if (selectedRow.Status == "已签名")
				{
					if (selectedRow.AuditStatus !== "已拒绝")
					{
						$('#btnOpOfficeAudit').linkbutton('enable');
						$('#btnOpOfficeAudit').removeAttr("disabled");
						$('#btnAuditAndPrint').linkbutton('enable');
						$('#btnAuditAndPrint').removeAttr("disabled");
						if (selectedRow.AuditStatus == "未审核")
						{
							$('#btnRefuse').linkbutton('enable');
							$('#btnRefuse').removeAttr("disabled");
						}
					}
				}
				$('#btnBrowse').linkbutton('enable');
            	$('#btnBrowse').removeAttr("disabled");
                $('#btnOpOfficePrint').linkbutton('enable');
                $('#btnOpOfficePDFPrev').linkbutton('enable');
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
                var auditUsrId = document.getElementById('auditUsrCombo').value;
				if (auditUsrId == "")
            	{
                	alert("未选择审核人");
                	return;
            	}
				
                var InsertAudit = function() {
		            var selectedRow = $('#patientListData').datagrid('getSelected');
					if (selectedRow.InstanceID !== instanceId)
					{
						top.$.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
				    	return;
					}
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertAudit', instanceId, auditUsrId, patInfo.UserID);
                    ajaxGET(data, function(ret) {
                        if (ret == "1") {
                            var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                            $('#patientListData').datagrid('updateRow',{
                                index: rowIndex,
                                row: {
                                    AuditStatus: '已审核'
                                }
                            });
                            alert('审核成功');
                            $('#btnPrint').linkbutton('enable');
                            $('#btnPrint').removeAttr("disabled");
                            $('#btnRefuse').linkbutton('disable');
                            $('#btnRefuse').attr({"disabled":"disabled"});
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
                } /* else if (patInfo.UserID != auditUsrId) {
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
                }  */
                else {
                    ShowAuditLog();
                }
            };
            
            this.btnOpOfficePrint = function() {
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
             //打印
            this.btnPrint = function() {
	            var instanceId = emrEditor.getInstanceID();
                if (instanceId === '') return;
                var selectedRow = $('#patientListData').datagrid('getSelected');
				if (selectedRow.InstanceID !== instanceId)
				{
					alert("左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历");
			    	return;
				}
	            emrEditor.printDoc();
	            $('#btnPrint').linkbutton('enable');
	            $('#btnPrint').removeAttr("disabled");
            };
            //拒绝
            this.btnRefuse = function() {
	            var insId = emrEditor.getInstanceID();
	            if (insId == "") return;
	        	var selectedRow = $('#patientListData').datagrid('getSelected');
	        	if (selectedRow.InstanceID == insId)
	        	{
		        	//获取审核人userid
                	var auditUsrId = document.getElementById('auditUsrCombo').value;
                	if (auditUsrId == "")
                	{
	                	alert("未选择审核人");
	                	$('#btnRefuse').linkbutton('enable');
	            		$('#btnRefuse').removeAttr("disabled");
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
                            alert("拒绝成功");
                            $('#btnOpOfficeAudit').linkbutton('disable');
					        $('#btnAuditAndPrint').linkbutton('disable');
					        $('#btnPrint').linkbutton('disable');
					        $('#btnRefuse').linkbutton('disable');
					        $('#btnOpOfficeAudit').attr({"disabled":"disabled"});
					        $('#btnAuditAndPrint').attr({"disabled":"disabled"});
					        $('#btnPrint').attr({"disabled":"disabled"});
					        $('#btnRefuse').attr({"disabled":"disabled"});
                        }
                    }, function(ret) {
                        alert('InsertRefuse error:' + ret);
                    });
		        }
		        else
		        {
			        alert("左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历");
			    	return;
			    }
            };
            //审核并打印
            this.btnAuditAndPrint = function() {
	            var instanceId = emrEditor.getInstanceID();
                if (instanceId === '') return;
				var selectedRow = $('#patientListData').datagrid('getSelected');
				if (selectedRow.InstanceID !== instanceId)
				{
					alert("左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历");
			    	return;
				}
                btnClick.btnOpOfficeAudit();
                //打印
	            emrEditor.printDoc();
            };
            //病历浏览
            this.btnBrowse = function(){
	            var selectedRow = $('#patientListData').datagrid('getSelected');
	            var episodeID = selectedRow.EpisodeID;
	            var patientID = selectedRow.PatientID;
	            var xpwidth=window.screen.width-10;
				var xpheight=window.screen.height-35;
				window.showModalDialog("emr.record.browse.csp?EpisodeID="+episodeID+"&PatientID="+patientID,"","dialogHeight:"+xpwidth+";dialogWidth:"+xpheight+";resizable:yes;status:no");
           	};
        };
    }

    //审核人列表
    function initAuditList() {
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetSSUserByLocID', patInfo.UserLocID);
        ajaxGET(data, function(ret) {
            if ('' != ret) {
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
            }else {
                //showEditorMsg('未获取到审核人列表数据', 'alert');
                //alert('未获取到审核人列表数据');
            }
        }, function(ret) {
            alert('GetSSUserByLocID error:' + ret);
        });
    }

    initAuditList();
    liveBtnBind();
    setBtnStatus("N");
    $('#btnOpOfficePrint').linkbutton('disable');
    $('#btnOpOfficePDFPrev').linkbutton('disable');
}

//设置按钮状态
function setBtnStatus(rs)
{
	if (rs == "N")
	{
		$('#btnOpOfficeAudit').linkbutton('disable');
        $('#btnAuditAndPrint').linkbutton('disable');
        $('#btnPrint').linkbutton('disable');
        $('#btnRefuse').linkbutton('disable');
        $('#btnBrowse').linkbutton('disable');
        $('#btnOpOfficeAudit').attr({"disabled":"disabled"});
        $('#btnAuditAndPrint').attr({"disabled":"disabled"});
        $('#btnPrint').attr({"disabled":"disabled"});
        $('#btnRefuse').attr({"disabled":"disabled"});
        $('#btnBrowse').attr({"disabled":"disabled"});
	}
}

