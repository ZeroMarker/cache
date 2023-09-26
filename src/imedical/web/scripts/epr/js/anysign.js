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
                        activeTab: 0, //���tab����
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
                            text:'�Ƿ�ҪΪ��ǰ�������ɴ�ǩ�ĵ���'
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
                                text:'ȷ��',
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
                                text:'ȡ��',
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
                                text:'ȷ��',
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
                                text:'ȡ��',
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
            var obj = "ִ�д���,�������:" + response.status + "," + "������Ϣ:"+ response.statusText;
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
        alert("ǩ���ĵ����ͳɹ���");
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
    return "��ѯ��"+signCnt+"��ǩ����ǩ������ɹ���";
}

function saveSignature(seqNum, signRet, plaintext)
{
    //debugger;
    try
    {
        //��ȡ�ʼ�ͼƬ
        var signScript = getSignInfo(signRet, GET_SIGN_SCRIPT, "");
        
        //��ȡָ��ͼƬ
        var fingerPrint = getSignInfo(signRet, GET_SIGN_FINGERPRINT, "");
        if(!isNaN(fingerPrint)) fingerPrint = "";
        //��ȡ����ǩ��ʱ�����ͼ��
        var patPhoto = getSignInfo(signRet, GET_SIGN_PHOTO, "");
        //��ȡ�¼�֤��
        //var eventCert = getSignInfo(signRet, GET_SIGN_CERT, "");
        //��ȡʱ��� ��ҽ��Ŀǰû�в���ʱ�����ע�͵�
        //var tsValue = getSignInfo(signRet, GET_SIGN_TIMESTAMP, "");
        //��ȡǩ����
        var user = getSignInfo(signRet, GET_CERT_SIGNER, "");
        //��ȡǩ��ʱ��
        var signTime = getSignInfo(signRet, GET_SIGN_TIME, "");
        //ʱ���ǩ��ԭ��Base64
        //var tsPlain = getSignInfo(signRet, GET_TS_PLAINDATA, plaintext);
        
        //var dataObj=eval("("+signRet+")");//ת��Ϊjson����
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
        alert("��ȡǩ����Ϣʧ�ܣ�");
        
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
                alert("ǩ���ɹ���");
            }
        },
        failure : function(response, opts)
        {
            var obj = "ִ�д���,�������:" + response.status + "," + "������Ϣ:"+ response.statusText;
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
            //ע������ݿ�ȡ����SignValue�������滻Ϊ˫����
            signvalue = response.responseText.replace(/\'/g,"\"");;
            if(signvalue=="")
            {
                alert("��֤ǩ��ʧ�ܣ�ǩ��ֵΪ�գ�");
                return;
            }
            var verifyRet = VerifySignature(content, signvalue);
            if(verifyRet==0)
            {
                alert(btnTitle+'����֤�ɹ���');
            }
            else if(verifyRet>0)
            {
                alert(errorInfo(verifyRet));
            }
        },
        failure : function(response, opts)
        {
            var obj = "ִ�д���,�������:" + response.status + "," + "������Ϣ:"+ response.statusText;
            alert(obj);
        }
    });
}