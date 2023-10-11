var keySign;

$(function() {
    keySign = new KeySign();
});


function KeySign() {

    //登录，返回用户名，和签名图片
    function GetUserInfo(UserName,UserCertCode,CertNo) {
	    var loginInfo = '';
        if ('' === UserName) return '';
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: "../EMRservice.Ajax.caKeySign.cls",
            async: false,
            cache: false,
            data: {
	            func: 'GetUserInfo',
	            UserName: UserName,
	            UserCertCode:UserCertCode,
	            CertNo:CertNo
	        },
            success: function(ret) {
	            if (ret && ret.Err) {
	                alert('GetUserInfo' + ret.Err);
	            } else {
	                loginInfo = ret;
	            }
            },
            error: function(err) {
                alert(err.message || err);
            }
        });
        return loginInfo;
    }

    /// 提交服务器，验签名，返回signID
    function serverSign(signValue, contentHash,rtn) {
	    var signID = '';
        var UsrCertCode = rtn.CAUserCertCode || '';
		var UsrCertNo = rtn.CACertNo || '';
        if ('' === UsrCertCode) {
	        $('#msgTable').hide();
            alert('用户唯一标示为空！');
            return signID;
        }
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: "../EMRservice.Ajax.caKeySign.cls",
            async: false,
            cache: false,
            data: {
	            func: 'sign',
	            UsrCertCode: UsrCertCode,
	            signValue: signValue,
	            contentHash: contentHash,
				UsrCertNo : UsrCertNo
	        },
            success: function(ret) {
	            if (ret && ret.Err) {
	                alert('sign:' + ret.Err);
	            } else {
	                signID = ret.SignID;
	            }
            },
            error: function(err) {
                alert(err.message || err);
            }
        });
        return signID;
    }

	//用图片签名编辑器，拿到HASH值
    function getSignContent(usrInfo, insID, checkresult, signProperty) {
        
        //如果是三级医师审核时，传入签名级别为医师级别
        var signlevel = signProperty.SignatureLevel;
        if (signProperty.OriSignatureLevel === 'Check') {
            signlevel = usrInfo.Level;
        }
        
        var ret = '';
        var signInfo = iEmrPlugin.SIGN_DOCUMENT({
            InstanceID: insID,
            Type: usrInfo.Type,
            SignatureLevel: signlevel,
            actionType: checkresult.ationtype,
            Id: usrInfo.UserID,
            Name: usrInfo.Name,
            Image: usrInfo.Image,
            Description: usrInfo.LevelDesc,
            isSync: true
        });
        if (signInfo && signInfo.result == 'OK') {
            return signInfo;
        }
        return ret;
    }
    
    // 入口
    this.sign = function(operate, insID, signProperty) {
		//开始执行
		var doSign = function(loginInfo,rtn) {	
            //权限检查
            var checkresult = privilege.checkSign(loginInfo, signProperty);
            if (!checkresult.flag) {
	            $('#msgTable').hide();
                alert('无签名权限');
                return;
            }

            // 获取原文(编辑器已经hash压缩)签名,服务器验证,通知编辑器保存SignID签名记录号
            var fnSign = function() {
                try {
					if ((loginInfo.Type == "Graph")&&(loginInfo.Image == "")) {
						$('#msgTable').hide();
						alert('签名图为空, 请联系管理员导入签名图！');
                        return;
					}
                    
                    //如果是三级医师审核时，传入签名级别为医师级别
                    var signlevel = signProperty.SignatureLevel;
                    if (signProperty.OriSignatureLevel === 'Check') {
                        signlevel = loginInfo.Level;
                    }
                    
                    if ('' === signlevel) {
                        alert('用户签名级别为空，请检查系统配置！');
                        return;
                    }
					
                    //文档签名
                    var signInfo = getSignContent(loginInfo, insID, checkresult, signProperty);
                    var contentHash = signInfo.Digest || '';
                    if ('' === contentHash) {
	                    $('#msgTable').hide();
                        alert('签名原文为空！');
                        return;
                    }
                    //CA接口
                    var signValue = rtn.ca_key.SignedData(contentHash, rtn.ContainerName, patInfo.EpisodeID) || '';
                    if ('' === signValue) {
	                    $('#msgTable').hide();
                        alert('签名数据为空！');
                        return;
                    }
                    var signID = serverSign(signValue, contentHash,rtn) || '';
                    if ('' === signID) {
	                    $('#msgTable').hide();
                        alert('SignID为空！');
                        return;
                    }

                    var saveRet = iEmrPlugin.SAVE_SIGNED_DOCUMENT({
                        SignUserID: loginInfo.UserID,
                        SignID: signID,
                        SignLevel: signlevel,
                        Digest: contentHash,
                        Type: 'CA',
                        Path: signInfo.Path,
                        ActionType: checkresult.ationtype,
                        InstanceID: insID,
                        isSync: true
                    });
                    if (saveRet && 'OK' === saveRet.params.result) {
                        showEditorMsg('数据签名成功!');
                        var documentContext = emrEditor.getDocContext(saveRet.params.InstanceID);
                        privilege.setRevsion(documentContext);
                        privilege.setViewRevise(documentContext, function() {
                            var txt = $('#btnRevisionVisible').text();
                            return txt === '隐藏痕迹';
                        });
                        return true;
                    } else {
                        return false;
                    }
                } catch (ex) {
                    alert(ex.message || ex);
                    return false;
                }

            }
            //fnSign结束
            
            //开始签名
            var retSign = fnSign() || false;
		    if (!retSign) {
		        var ret = iEmrPlugin.UNSIGN_DOCUMENT({
		            isSync: true
		        });
		        if ('ERROR' === ret.result)
		        {
			        $('#msgTable').hide();
		            alert('撤销最后一次签名失败！');
		        }
		    }
			

        }
		showEditorMsg('签名中，请耐心等待...','alwaysshow');
        var rtn = dhcsys_getcacert({modelCode:"OPEMR", isHeaderMenuOpen:true, SignUserCode:patInfo.UserCode},undefined,undefined,undefined);
		if (!rtn.IsSucc) 
		{
			//alert("证书未登录,请重新登录证书!");
			showEditorMsg('证书未登录,请重新登录证书!','forbid');
			return;
		}
		
		if (rtn.ContainerName!="")
		{ 
			//该科室需签名
			var loginInfo = GetUserInfo(rtn.UserName,rtn.CAUserCertCode,rtn.CACertNo);
			if (loginInfo !="")
			{
				doSign(loginInfo,rtn);
			}
		}else{
			//alert('获取ContainerName失败！');	
			showEditorMsg('获取证书ContainerName失败','forbid');
		}
    }
	//this.sign结束

}