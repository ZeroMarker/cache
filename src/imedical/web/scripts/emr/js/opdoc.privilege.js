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
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canSave == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行保存操作！' + documentContext.privelege.cantSaveReason;
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
		}  
        //showEditorMsg('权限控制：不允许进行打印操作！', 'warning');

        return ret;
    },
    //删除权限
    canDelete: function (documentContext) {
        var ret = false;
        if (!this._checkPrivilege(documentContext))
            return ret;

        ret = documentContext.privelege.canDelete == '1';
        if (!ret)
		{
			var message = '权限控制：不允许进行删除操作！' + documentContext.privelege.cantDeleteReason;
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
		}
        //showEditorMsg('权限控制：不允许进行重审核操作！', 'warning');

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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:15}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
		}
        //showEditorMsg('权限控制：不允许进行查看留痕操作！', 'warning');

        return ret;
    },
    //检查签名权限脚本
    checkSign: function (userInfo, signProperty) {

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
            $.messager.popover({msg:'已签名,不必再签！',type:'info',style:{top:10,right:5}});
            //showEditorMsg('已签名,不必再签', 'forbid');
            return result;
        }
        if (signProperty.OriSignatureLevel == 'All') {
            if (count > 0) {
                //改签
                if (confirm('已签名，是否改签') == true) {
                    result = {
                        'flag': true,
                        'ationtype': 'Replace'
                    };
                } else {
                    result = {
                        'flag': false,
                        'ationtype': ''
                    };
                }
            } else {
                //签名
                result = {
                    'flag': true,
                    'ationtype': 'Append'
                };
            }
        } else if (signProperty.OriSignatureLevel == 'Check') {
            if (count <= 0) {
                //签名
                result = {
                    'flag': true,
                    'ationtype': 'Append'
                };
            } else {
                if (userInfo.UserLevel == 'Resident') {
                    if (count == 1 && signProperty.SignatureLevel == 'Resident') {
                        //改签
                        if (confirm('已签名，是否改签') == true) {
                            result = {
                                'flag': true,
                                'ationtype': 'Replace'
                            };
                        } else {
                            result = {
                                'flag': false,
                                'ationtype': ''
                            };
                        }
                    } else {
                        //无权限签
                        result = {
                            'flag': false,
                            'ationtype': ''
                        };
                        $.messager.popover({msg:'已签名,不必再签！',type:'info',style:{top:10,right:5}});
                        //showEditorMsg('已签名,不必再签', 'forbid');
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
                            $.messager.popover({msg:'已签名,不必再签！',type:'info',style:{top:10,right:5}});
                            //showEditorMsg('已签名,不必再签', 'forbid');
                            return result;
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
                        } else if (signProperty.SignatureLevel == 'Attending') {
                            //改签
                            if (confirm('已签名，是否改签') == true) {
                                result = {
                                    'flag': true,
                                    'ationtype': 'Replace'
                                };
                            } else {
                                result = {
                                    'flag': false,
                                    'ationtype': ''
                                };
                            }
                        } else {
                            //无权限签
                            result = {
                                'flag': false,
                                'ationtype': ''
                            };
                            $.messager.popover({msg:'已签名,不必再签！',type:'info',style:{top:10,right:5}});
                            //showEditorMsg('已签名,不必再签', 'forbid');
                        }
                } else if (userInfo.UserLevel == 'Chief') {
                    var flag = 0
                        for (var i = 0; i < count; i++) {
                            if (signProperty.Authenticator[i].SignatureLevel == 'Chief') {
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
                        } else if (signProperty.SignatureLevel == 'Chief') {
                            //改签
                            if (confirm('已签名，是否改签') == true) {
                                result = {
                                    'flag': true,
                                    'ationtype': 'Replace'
                                };
                            } else {
                                result = {
                                    'flag': false,
                                    'ationtype': ''
                                };
                            }
                        } else {
                            //无权限签
                            result = {
                                'flag': false,
                                'ationtype': ''
                            };
                            $.messager.popover({msg:'已签名,不必再签！',type:'info',style:{top:10,right:5}});
                            //showEditorMsg('已签名,不必再签', 'forbid');
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
                $.messager.popover({msg:'签名身份不符，无权限签名！',type:'alert',style:{top:10,right:5}});
                //showEditorMsg('签名身份不符，无权限签名', 'forbid');
            } else if (count > 0) {
                //改签
                if (confirm('已签名，是否改签') == true) {
                    result = {
                        'flag': true,
                        'ationtype': 'Replace'
                    };
                } else {
                    result = {
                        'flag': false,
                        'ationtype': ''
                    };
                }
            } else {
                //签名
                result = {
                    'flag': true,
                    'ationtype': 'Append'
                };
            }
        }
        return result;
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
			$.messager.popover({msg:message,type:'alert',style:{top:10,right:5}});
		}
        return ret;
    }
};
