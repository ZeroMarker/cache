Ext.onReady(function ()
{
    Ext.Ajax.request(
    {
        url : '../web.eprajax.anySign.cls',
        params :
        {
            episodeID : episodeID,
            printDocID : printDocID,
            eprNum : eprNum,
            userID : userID,
            action : action
        },
        success : function(response, opts)
        {
            var anysignUI = "";
            var evo = eval("("+response.responseText.split("^")[1]+")");
            var iniflag = response.responseText.split("^")[0];
            var layoutflag = false;
            if(iniflag=="G")
            {
                if(layoutflag)
                {
                    anysignUI  = new Ext.TabPanel(
                    {
                        region:'center',
                        //renderTo:'panel',
                        //deferredRender: true,
                        tabPosition : 'top',
                        enableTabScroll : true,
                        layoutOnTabChange : true,
                        activeTab: 0, //活动的tab索引
                        items:evo
                    })
                }
                else
                {
                    anysignUI = new Ext.Panel(
                    {
                        renderTo:'panel',
                        layout:'accordion',
                        layoutConfig:{animate:false},
                        items:evo
                    })
                }
            }
            else if(iniflag=="B")
            {
                anysignUI = new Ext.Panel(
                {
                    autoWidth:true,
                    baseCls:'x-plain',
                    renderTo:'panel',
                    layout:'column',
                    items:[
                    {
                        columnWidth:.26,
                        baseCls:'x-plain'
                    },
                    {
                        columnWidth:.6,
                        baseCls:'x-plain',
                        style:'padding-top:10',
                        items:evo
                    },
                    {
                        columnWidth:.14,
                        baseCls:'x-plain'
                    }]
                })
            }
            else if(iniflag=="M")
            {
                var anysignUI = new Ext.Panel(
                {
                    renderTo:'panel',
                    layout:'anchor',
                    items:[
                    {
                        anchor:"100% 20%",
                        xtype:'label'
                    },
                    {
                        anchor:"100% 50%",
                        layout:'column',
                        items:[
                        {
                            columnWidth:.15,
                            baseCls:'x-plain'
                        },
                        {
                            columnWidth:.75,
                            xtype:'label',
                            style:'font-size:15px',
                            text:'是否要为当前患者生成待签文档？'
                        },
                        {
                            columnWidth:.1,
                            baseCls:'x-plain'
                        }]
                    },
                    {
                        anchor:"100% 30%",
                        layout:'column',
                        items:[
                        {
                            columnWidth:.15,
                            baseCls:'x-plain'
                        },
                        {
                            columnWidth:.4,
                            baseCls:'x-plain',
                            items:[
                            {
                                minWidth:'80',
                                xtype:'button',
                                text:'确定',
                                handler:function()
                                {
                                    mobileSign(patName,ipRecordNo,'',userID,content,pdfPath);
                                    window.returnValue = 'Y';
                                    window.close();
                                }
                            }]
                        },
                        {
                            columnWidth:.45,
                            baseCls:'x-plain',
                            items:[
                            {
                                minWidth:'80',
                                xtype:'button',
                                text:'取消',
                                handler:function()
                                {
                                    alert(userLocID);
                                    window.close();
                                }
                            }]
                        }]
                    }
                    ],
                    frame: true
                });
            }
            else if(iniflag=="MD")
            {
                signStatus = mobileSignStatus(patName,ipRecordNo,'',userID,content);
                var anysignUI = new Ext.Panel(
                {
                    renderTo:'panel',
                    layout:'anchor',
                    items:[
                    {
                        anchor:"100% 20%",
                        xtype:'label'
                    },
                    {
                        anchor:"100% 50%",
                        layout:'column',
                        items:[
                        {
                            columnWidth:.15,
                            baseCls:'x-plain'
                        },
                        {
                            columnWidth:.75,
                            xtype:'label',
                            style:'font-size:15px',
                            text:signStatus
                        },
                        {
                            columnWidth:.1,
                            baseCls:'x-plain'
                        }]
                    },
                    {
                        anchor:"100% 30%",
                        layout:'column',
                        items:[
                        {
                            columnWidth:.15,
                            baseCls:'x-plain'
                        },
                        {
                            columnWidth:.4,
                            baseCls:'x-plain',
                            items:[
                            {
                                minWidth:'80',
                                xtype:'button',
                                text:'确定',
                                handler:function()
                                {
                                    window.returnValue = 'Y';
                                    window.close();
                                }
                            }]
                        },
                        {
                            columnWidth:.05,
                            baseCls:'x-plain'
                        },
                        {
                            columnWidth:.4,
                            baseCls:'x-plain',
                            items:[
                            {
                                minWidth:'80',
                                xtype:'button',
                                text:'取消',
                                handler:function()
                                {
                                    window.close();
                                }
                            }]
                        }]
                    }
                    ],
                    frame: true
                });
            }
            
            anysignUI.doLayout();
            
            new Ext.Viewport(
            {
                layout: 'fit',
                items: anysignUI
            });
        },
        failure : function(response, opts)
        {
            var obj = "执行错误,错误代码:" + response.status + "," + "错误信息:"+ response.statusText;
            alert(obj);
        }
    });
});

function signature(seqNum, plaintext, user, cardtype, cardNo)
{
    var signRet = Sign(plaintext, user, cardtype, cardNo);
    if(!isNaN(signRet))
    {
        alert(errorInfo(signRet));
        return;
    }
    saveSignature(seqNum, signRet, plaintext);
    
    return;
}

function mobileSign(UserName, UserID, DoctorName, DoctorID, plaintext, pdfPath)
{
    var DocID = episodeID+"-"+printDocID+"-"+eprNum;
    var DocName = title+"-"+pdfhash;
    
    var pushRet = pushSignInfo(DocName, DocID, UserName, UserID, DoctorName, DoctorID, plaintext, pdfPath);
    if(pushRet!=0)
    {
        alert(errorInfo(pushRet));
    }
    else
    {
        alert("签名文档发送成功！");
        return;
    }
    //saveSignature(seqNum, signRet, plaintext);
    
    return;
}

function mobileSignStatus(UserName, UserID, DoctorName, DoctorID, plaintext)
{
    var DocID = episodeID+"-"+printDocID+"-"+eprNum
    var DocName = title+"-"+pdfhash;
    
    var signRet = getMobileSignStatus(DocName, DocID, UserName, UserID, DoctorName, DoctorID, plaintext);
    //var signRet = signRet1;
    if(!isNaN(signRet))
    {
        //alert(errorInfo(signRet));
        return errorInfo(signRet);
    }
    var signCnt = getSignCount(signRet);
    for (var signInd=0; signInd < signCnt; signInd++ )
    {
        var scattersign = getScatterSign(signRet,signInd);
        saveSignature(signInd+1, scattersign, plaintext);
    }
    return "查询到"+signCnt+"个签名，签名保存成功！";
}

function saveSignature(seqNum, signRet, plaintext)
{
    //debugger;
    try
    {
        //获取笔迹图片
        var signScript = getSignInfo(signRet, GET_SIGN_SCRIPT, "");
        
        //获取指纹图片
        var fingerPrint = getSignInfo(signRet, GET_SIGN_FINGERPRINT, "");
        if(!isNaN(fingerPrint)) fingerPrint = "";
        //获取患者签名时拍摄的图像
        var patPhoto = getSignInfo(signRet, GET_SIGN_PHOTO, "");
        //获取事件证书
        //var eventCert = getSignInfo(signRet, GET_SIGN_CERT, "");
        //获取时间戳 哈医大目前没有部署时间戳，注释掉
        //var tsValue = getSignInfo(signRet, GET_SIGN_TIMESTAMP, "");
        //获取签名人
        var user = getSignInfo(signRet, GET_CERT_SIGNER, "");
        //获取签名时间
        var signTime = getSignInfo(signRet, GET_SIGN_TIME, "");
        //时间戳签名原文Base64
        //var tsPlain = getSignInfo(signRet, GET_TS_PLAINDATA, plaintext);
        
        //var dataObj=eval("("+signRet+")");//转换为json对象
        var dataObj=jQuery.parseJSON(signRet);
        var algorithm = dataObj.SigValue.Algorithm;
        var bioFeature = dataObj.SigValue.BioFeature;
        var eventCert = dataObj.SigValue.EventCert;
        var sigValue = dataObj.SigValue.SigValue;
        var tsValue = dataObj.SigValue.TSValue;
        var version = dataObj.SigValue.Version;
    }
    catch(err)
    {
        alert("获取签名信息失败！");
        
        return;
    }
    
    Ext.Ajax.request(
    {
        url : '../web.eprajax.anySign.cls',
        method : 'POST',
        params :
        {
            //episodeID, userID, printDocID, eprNum, seqNum,
            //algorithm, bioFeature, eventCert, sigValue, tsValue, version,
            //user, signTime, signScript, fingerPrint, content
            episodeID : episodeID,
            userID : userID,
            printDocID : printDocID,
            eprNum : eprNum,
            insIDs : insIDs,
            seqNum : seqNum,
            algorithm : algorithm,
            bioFeature : bioFeature,
            eventCert : eventCert,
            sigValue : sigValue,
            tsValue : tsValue,
            version : version,
            user : user,
            signTime : signTime,
            signScript : signScript,
            fingerPrint : fingerPrint,
            patPhoto : patPhoto,
            signOption : "",
            content : plaintext,
            action : 'saveSignInfo'
        },
        success : function(response, opts)
        {
            if(response.responseText.split("^")[0]=="0")
            {
                alert(response.responseText.split("^")[1]);
                return;
            }
            else if(response.responseText.split("^")[0]=="1")
            {
                parWindow.divState.innerHTML = response.responseText.split('^')[1];
                parWindow.getPower();
                alert("签名成功！");
            }
        },
        failure : function(response, opts)
        {
            var obj = "执行错误,错误代码:" + response.status + "," + "错误信息:"+ response.statusText;
            alert(obj);
        }
    });
}

function verifyAnySign(content, seqNum, btnTitle)
{
    var signvalue = "";
    var ob = Ext.get("verifyItem"+seqNum);
    Ext.get("verifyItem"+seqNum).setStyle('button_color', 'red');
    Ext.Ajax.request(
    {
        url : '../web.eprajax.anySign.cls',
        params :
        {
            episodeID : episodeID,
            printDocID : printDocID,
            eprNum : eprNum,
            seqNum : seqNum,
            action : 'getSignValue'
        },
        success : function(response, opts)
        {
            //注意把数据库取出的SignValue单引号替换为双引号
            signvalue = response.responseText.replace(/\'/g,"\"");;
            if(signvalue=="")
            {
                alert("验证签名失败，签名值为空！");
                return;
            }
            var verifyRet = VerifySignature(content, signvalue);
            if(verifyRet==0)
            {
                alert(btnTitle+'，验证成功！');
            }
            else if(verifyRet>0)
            {
                alert(errorInfo(verifyRet));
            }
        },
        failure : function(response, opts)
        {
            var obj = "执行错误,错误代码:" + response.status + "," + "错误信息:"+ response.statusText;
            alert(obj);
        }
    });
}