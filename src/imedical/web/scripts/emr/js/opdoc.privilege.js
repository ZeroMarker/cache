///
var privilege = {
    _checkPrivilege: function (documentContext) {
        if (!documentContext || 'ERROR' === documentContext.result)
            return false;
        if (documentContext.InstanceID === 'GuideDocument')
            return false;
        if (!documentContext.privelege || documentContext.privelege === '') {
            //$.messager.alert('提示', '权限脚本为空，请检查！', 'info');
            alert('权限脚本为空，请检查！');
            return false;
        }
        return true;
    },
    //保存权限
    canSave: function (documentContext) {
	    var lockedInsID = $("#lock span").attr("instaceID");
		if ((lockedInsID != undefined )&&(lockedInsID == documentContext.InstanceID))
	    {
			var message = '病历已加锁，不允许进行保存操作！';
			showEditorMsg({msg:message,type:'alert'});
			
			iEmrPlugin.SET_READONLY({
                ReadOnly: true
            });
			return false;
		}
	    
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canSave == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行保存操作！' + documentContext.privelege.cantSaveReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行保存操作！', 'warning');

        return ret;
    },
    //打印权限
    canPrint: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canPrint == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行打印操作！' + documentContext.privelege.cantPrintReason;
			showEditorMsg({msg:message,type:'alert'});
		}  
        //showEditorMsg('权限控制：不允许进行打印操作！', 'warning');

        return ret;
    },
    //删除权限
    canDelete: function (documentContext) {
	    var lockedInsID = $("#lock span").attr("instaceID");
		if ((lockedInsID != undefined )&&(lockedInsID == documentContext.InstanceID))
	    {
			var message = '病历已加锁，不允许进行删除操作！';
			showEditorMsg({msg:message,type:'alert'});
			
			iEmrPlugin.SET_READONLY({
                ReadOnly: true
            });
			return false;
		}

        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canDelete == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行删除操作！' + documentContext.privelege.cantDeleteReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行删除操作！', 'warning');

        return ret;
    },
    canCheck: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canCheck == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行审核操作！' + documentContext.privelege.cantCheckReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行审核操作！', 'warning');

        return ret;
    },
    canReCheck: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canReCheck == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行重审核操作！' + documentContext.privelege.cantReCheckReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行重审核操作！', 'warning');

        return ret;
    },
    canPatCheck: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canPatCheck == '1';
        if (!ret)
        {
            var message = '不允许进行患者签名操作! ' + documentContext.privelege.cantPatCheckReason;
            showEditorMsg(message, 'warning');
        }
        return ret;
    },
    canPatReCheck: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canPatReCheck == '1';
        if (!ret)
        {
            var message = '不允许进行患者改签操作! ' + documentContext.privelege.cantPatReCheckReason;
            showEditorMsg(message, 'warning');
        }
        return ret;
    },
    canRevokCheck: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canRevokCheck == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行撤销审核操作！' + documentContext.privelege.cantRevokCheckReason;
			showEditorMsg({msg:message,type:'alert'});
		} 
        //showEditorMsg('权限控制：不允许进行撤销审核操作！', 'warning');

        return ret;
    },
    canReference: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canReference == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行引用审核操作！' + documentContext.privelege.cantReferenceReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行引用审核操作！', 'warning');

        return ret;
    },
    canExport: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canExport == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行导出操作！' + documentContext.privelege.cantExportReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行导出操作！', 'warning');

        return ret;
    },
    canCopyPaste: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canCopyPaste == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行复制粘贴操作！' + documentContext.privelege.cantCopyPasteReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行复制粘贴操作！', 'warning');

        return ret;
    },
    canRevise: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canRevise == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行留痕操作！' + documentContext.privelege.cantReviseReason;
			showEditorMsg({msg:message,type:'alert'});
		} 
        //showEditorMsg('权限控制：不允许进行留痕操作！', 'warning');

        return ret;
    },
    canViewRevise: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canViewRevise == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行查看留痕操作！' + documentContext.privelege.cantViewReviseReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        //showEditorMsg('权限控制：不允许进行查看留痕操作！', 'warning');

        return ret;
    },
    //检查签名权限脚本
    checkSign: function (userInfo, signProperty, documentContext, callback, arr) {

        var result = {
            'flag': false,
            'ationtype': ''
        };
        var count = signProperty.Authenticator.length;
        if (count > 0 && signProperty.Id == userInfo.UserID) {
            result = {
                'flag': false,
                'ationtype': ''
            };
            showEditorMsg({msg:'已签名,不必再签！',type:'info'});
            if ((sysOption.isAllRevokeSign.split("^")[0]=="Y")&&(sysOption.isAllRevokeSign.split("^")[2]=="Y")&&(documentContext!=undefined)&&(documentContext!="")&&(documentContext.InstanceID!=undefined)&&(documentContext.InstanceID!=""))
            {
	            var instanceId = documentContext.InstanceID;
	            var text = '是否需要撤销本人签名？';
				$.messager.confirm("操作提示", text, function (data) { 
					if(data) {
						
						var ret = revokeWordSign(userInfo,signProperty,instanceId);
						if (ret.result == "OK")
						{
							$.messager.popover({msg:'签名撤销成功！', type:'success', style:{top:10,right:5}});
						}
						else
						{
							$.messager.popover({msg:'签名撤销失败！', type:'error', style:{top:10,right:5}});
						}
                        callback(result, arr);
					} else {
                        callback(result, arr);
                    }
				});
            }
            return;
        }
        if (signProperty.OriSignatureLevel == 'All') {
            if (count > 0) {
                //改签
                top.$.messager.confirm("操作提示", "已签名，是否改签?", function (data) { 
					if(data) {
						result = {
                            'flag': true,
                            'ationtype': 'Replace'
                        };
                        callback(result,arr);
					} else {
                        result = {
                            'flag': false,
                            'ationtype': ''
                        };
                        callback(result,arr);
					}
				});
            } else {
                //签名
                result = {
                    'flag': true,
                    'ationtype': 'Append'
                };
                callback(result,arr);
            }
        } else if (signProperty.OriSignatureLevel == 'Check') {
            if (count <= 0) {
                //签名
                result = {
                    'flag': true,
                    'ationtype': 'Append'
                };
                callback(result,arr);
            } else {
                if (userInfo.UserLevel == 'Resident') {
                    if (count == 1 && signProperty.SignatureLevel == 'Resident') {
                        //改签
                        top.$.messager.confirm("操作提示", "已签名，是否改签?", function (data) { 
							if(data) {
								result = {
                                    'flag': true,
                                    'ationtype': 'Replace'
                                };
		                        callback(result,arr);
							} else {
                                result = {
                                    'flag': false,
                                    'ationtype': ''
                                };
		                        callback(result,arr);
							}
						});
                    } else {
                        //无权限签
                        result = {
                            'flag': false,
                            'ationtype': ''
                        };
                        showEditorMsg({msg:'已签名,不必再签！',type:'info'});
                        callback(result,arr);
                    }
                } else if (userInfo.UserLevel == 'Attending') {
                    var flag = 0
                    for (var i = 0; i < count; i++) {
                        if (signProperty.Authenticator[i].SignatureLevel == 'Chief') {
                            flag = 1
                                break;
                        }
                    }

                    if (flag == 1) {
                        //无权限签
                        result = {
                            'flag': false,
                            'ationtype': ''
                        };
                        showEditorMsg({msg:'已签名,不必再签！',type:'info'});
                        callback(result,arr);
                        return;
                    }

                    flag = 0
                    for (var i = 1; i < count; i++) {
                        if (signProperty.Authenticator[i].SignatureLevel == 'Attending') {
                            flag = 1
                                break;
                        }
                    }

                    if (flag != 1) {
                        //签名
                        result = {
                            'flag': true,
                            'ationtype': 'Append'
                        };
                        callback(result,arr);
                    } else if (signProperty.SignatureLevel == 'Attending') {
                        //改签
                        top.$.messager.confirm("操作提示", "已签名，是否改签?", function (data) { 
							if(data) {
								result = {
                                    'flag': true,
                                    'ationtype': 'Replace'
                                };
		                        callback(result,arr);
							} else {
                                result = {
                                    'flag': false,
                                    'ationtype': ''
                                };
		                        callback(result,arr);
							}
						});
                    } else {
                        //无权限签
                        result = {
                            'flag': false,
                            'ationtype': ''
                        };
                        showEditorMsg({msg:'已签名,不必再签！',type:'info'});
                        callback(result,arr);
                    }
                } else if ($.inArray(userInfo.UserLevel,["Chief","ViceChief"]) != -1) {
                    var flag = 0
                    for (var i = 0; i < count; i++) {
                        if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Chief","ViceChief"]) != -1) {
                            flag = 1;
                            break;
                        }
                    }
                    if (flag != 1) {
                        //签名
                        result = {
                            'flag': true,
                            'ationtype': 'Append'
                        };
                        callback(result,arr);
                    } else if (signProperty.SignatureLevel == 'Chief') {
                        top.$.messager.confirm("操作提示", "已签名，是否改签", function (data) { 
							if(data) {
								result = {
                                    'flag': true,
                                    'ationtype': 'Replace'
                                };
                                callback(result,arr);
							} else {
								result = {
                                    'flag': false,
                                    'ationtype': ''
                                };
                                callback(result,arr);
							}
						});
                    } else {
                        //无权限签
                        result = {
                            'flag': false,
                            'ationtype': ''
                        };
                        showEditorMsg({msg:'已签名,不必再签！',type:'info'});
                        callback(result,arr);
                    }
                }
            }
        } else {
            if (signProperty.OriSignatureLevel != userInfo.UserLevel) {
                //无权限签
                result = {
                    'flag': false,
                    'ationtype': ''
                };
                showEditorMsg({msg:'签名身份不符，无权限签名！',type:'alert'});
                callback(result,arr);
            } else if (count > 0) {
                //改签
                top.$.messager.confirm("操作提示", "已签名，是否改签?", function (data) { 
					if(data) {
						result = {
	                        'flag': true,
	                        'ationtype': 'Replace'
	                    };
                        callback(result,arr);
					} else {
	                    result = {
	                        'flag': false,
	                        'ationtype': ''
	                    };
                        callback(result,arr);
					}
				});
            } else {
                //签名
                result = {
                    'flag': true,
                    'ationtype': 'Append'
                };
                callback(result,arr);
            }
        }
    },
    //是否调用签名失效
    GetRevokeStatus: function () {
        var result = '';

        var data = ajaxDATA('String', 'EMRservice.SystemParameter', 'GetRevokeStatus');
        ajaxGETSync(data, function (ret) {
            result = ret;
        }, function (ret) {
            //$.messager.alert('发生错误', 'GetRevokeStatus error', 'error');
            alert('GetRevokeStatus error');
        });

        return result;
    },
    // 痕迹 完成签名事件，加载文档完成
    setRevsion: function (documentContext) {
        if (documentContext && documentContext.privelege) {
            var ret = documentContext.privelege.canRevise || '-1';

            if (ret === '1') {
                iEmrPlugin.SET_REVISION_STATE({
                    InstanceID: documentContext.InstanceID,
                    Mark: true
                });
            } else if (ret === '0') {
                iEmrPlugin.SET_REVISION_STATE({
                    InstanceID: documentContext.InstanceID,
                    Mark: false
                });
            } else if (ret === '-1') {
                if ('1' === (documentContext.status.signStatus || '0')) {
                    iEmrPlugin.SET_REVISION_STATE({
                        InstanceID: documentContext.InstanceID,
                        Mark: true
                    });
                }
            }
        }
    },
    setViewRevise: function (documentContext, fnBtnRevisionVisible) {
        var result = false;
        if (documentContext && documentContext.privelege) {
            result = documentContext.privelege.canViewRevise == '1';
        }
        if (result) {
            if (typeof fnBtnRevisionVisible !== 'function')
                result = false;
            else
                result = fnBtnRevisionVisible();
        }
        iEmrPlugin.SET_REVISION_VISIBLE({
            Visible: result
        });
    },
    //获取是否有权限加载病历
    getViewPrivilege: function (documentContext) {
        var result = '';
        var data = ajaxDATA('String', 'EMRservice.Ajax.privilege', 'GetLoadPrivilege', patInfo.UserID, patInfo.UserLocID, patInfo.SsgroupID, patInfo.EpisodeID, patInfo.PatientID, documentContext.id);
        ajaxGETSync(data, function (ret) {
            result = $.parseJSON(ret);
        }, function (ret) {
            alert('getViewPrivilege error:' + ret);
        });
        return result;
    },
    //自动审批权限
    canAutoApply: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canAutoApply == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行自动审批动作！' + documentContext.privelege.cantAutoApplyReason;
			showEditorMsg({msg:message,type:'alert'});
		}
        return ret;
    }
};
