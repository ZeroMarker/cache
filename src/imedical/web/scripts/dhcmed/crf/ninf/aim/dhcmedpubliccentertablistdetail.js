//ajax从后台取权限
function getPower() {
    Ext.Ajax.request({
        url: '../web.eprajax.ajaxGetPower.cls',
        timeout: parent.parent.timedOut,
        params: { episodeID: episodeID, printTemplateDocId: printTemplateDocId, templateDocId: templateDocID, EPRNum: EPRNum, patientID: pateintID },
        success: function(response, opts) {
            var obj = eval('[{' + response.responseText + '}]');
            canView = obj[0].canView;
            canSave = obj[0].canSave;
            canCommit = obj[0].canCommit;
            canReference = obj[0].canReference;
            canSwitchTemplate = obj[0].canSwitchTemplate;
            setPower();
        },
        failure: function(response, opts) {
            var obj = "获取权限列表错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;
            alert(obj);
        }
    });
}

//病历引用功能按钮事件
function reference() {
    //禁止使用病历引用功能    
}

//显示感染相关信息
function ShowNInfInfo() { 
	var lnk="dhcmed.cc.qryfeedbackdoctor.csp?EpisodeID="+episodeID+"&SubjectID="+SubjectID;
 	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=850px;dialogHeight=550px;status=no");
}

function DeleteEPRRep() {
try{
		if(ReportID=="")
		{
			window.alert("请先上报!!");
			 return;
		}
		var retRes=prompt("请输入删除原因","");
      if(!retRes) 
      {
           alert("没输入删除原因,删除失败！");
           return;
       }
		var ret=tkMakeServerCall("DHCMed.CRService.ReportCtl","DeleteReport",ReportID,retRes,session['LOGON.USERID']);
		window.alert("删除成功!!");
		}catch(e)
		{
			window.alert(tmes['failed']);
			}	
}

function save(isConfirm) {
    //修改内容：增加了一个判断“保存”按钮是否可按
    //修改原因：新增快捷键F7，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。
    if (Ext.getCmp('btnSave').disabled == false) {
        //保存操作
        var eprlisteditor = frames['eprlisteditordll'].document.getElementById('eprlistedit');
        eprlisteditor.PrnTemplateDocID = printTemplateDocId;
        eprlisteditor.EPRNum = EPRNum;

        if (isConfirm == '') {
            var saveState = eprlisteditor.SaveClick();
        } else {
            var saveState = eprlisteditor.SaveClick(isConfirm);
        }

        if (saveState != true) {
            //alert('保存失败!');
            return;
        }else
        {
        	var ret=tkMakeServerCall("DHCMed.NINFService.Aim.Interface","SyncDataEPRByEpisodeID","",episodeID);
        }

        //提示是否保存的信息状态
        isSave = true;

        var obj = eprlisteditor.StatusAfterSaveNewFrameWork;

        //add by zhuj on 2009-12-21
        currState = obj.split('^')[4];
        divState.innerHTML = obj.split('^')[3];
        EPRNum = obj.split('^')[2];
        var instanceID = eprlisteditor.InstanceDataID;

        //打印类型
        var printType = '';
        for (var i = 0; i < eprlisteditor.childNodes.length; i++) {
            if (eprlisteditor.childNodes[i].name == 'ChartItemType') {
                printType = eprlisteditor.childNodes[i].value;
            }
        }
        //获得logID
        if (bindPrnTemplateID != "")
        {
            var logID = obj.split('^')[1];
            var objEprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
            objEprform.InvokePreviewService(pateintID, episodeID, logID, bindPrnTemplateID, "Normal", instanceID, userID, printTemplateDocId);
        }
        
        //更新标题
        var title = eprlisteditor.EPRListTitle;
        if (title) {
            //无需更新标题
            //setTabInfo(title);
        }
        
        //根据权限重置各按钮状态
        getPower();
    }
}

//增加北京CA数据签名所需的参数 lingchen
//userID, episodeID, printTemplateDocId, IDs, signValue, contentHash, 增加 docEprNumList，templateDocId
var args = new Array(8);

//提交
function commit() {
    //edit by loo on 2010-7-28
    //修改内容：增加了一个判断“提交”按钮是否可按
    //修改原因：新增快捷键F8，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
    if (Ext.getCmp('btnCommit').disabled == false) {
        //判断是否未完成
        if (currState == 'unfinished' || currState == '') {
            alert('当前病历尚未完成,不能进行提交操作!');
            return;
        }

        if (printTemplateDocId == '' || EPRNum == '-1') {
            alert('当前病历未完成,不能进行提交操作!');
            return;
        }

        //判断是否已经提交
        if (currState == 'commited') {
            alert('当前病历已经提交,不需重复提交!');
            return;
        }
        //判断是否已经审核
        if (currState == 'attendingChecked' || currState == 'chiefChecked') {
            alert('当前病历已经审核,不需重复提交!');
            return;
        }
        //判断是否已经归档
        if (currState == 'archieved') {
            alert('当前病历已经归档交,不需重复提交!');
            return;
        }

        var commit = confirm('您确定要提交病历吗?');
        if (commit) {
            var eprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');

            //add by zhuj on 2010-1-27	begin
            eprform.PrnTemplateDocID = printTemplateDocId;
            eprform.EPRNum = EPRNum;
            //end

            // LingChen 插入北京CA数字签名
            var instanceID = eprform.InstanceDataID;

            //var content=eprform.GetContentByIDs(instanceID);    
            //var contentHash=getContentHash(containerName, content)        // 获取需签名的病历原文的Hash
            //var signValue=CADigitalSign(containerName, contentHash)          // 对Hash进行签名

            var state = false;

            if (eprform.IsCAOn()) {
                //userID, episodeID, printTemplateDocId, IDs, signValue, contentHash,   todo
                // 增加 docEprNumList，templateDocId
                args[0] = userID;
                args[1] = episodeID;
                args[2] = printTemplateDocId;
                args[3] = instanceID;


                // 弹出输入框 登录成功
                var result = window.showModalDialog("../csp/dhc.epr.ca.audit.csp", self, "dialogWidth:250px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
                if (result != true) return;
                //userID, episodeID, printTemplateDocId, IDs, signValue, contentHash, 
                state = eprform.CACommitClick(episodeID, EPRNum, printTemplateDocId, args[4], args[3], args[5], args[0]);
            }
            else {
                state = eprform.CommitClick(EPRNum, printTemplateDocId);
            }

            if (state == true) {
                //设置病历当前状态
                var obj = eprform.StatusAfterSaveNewFrameWork;

                currState = obj.split('^')[4];
                divState.innerHTML = obj.split('^')[3];

                getPower();
            }
        }
    }
}

function update() {
    var eprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
    var printState = eprform.RefreshClick();
}

//更新模板
function updateTemplate() {
    var eprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
    eprform.PrnTemplateDocID = printTemplateDocId;
    eprform.EPRNum = EPRNum;
    var printState = eprform.TemplateClick('refreshNecessary');
    var obj = eprform.StatusAfterSaveNewFrameWork;
    //add by zhuj on 2010-1-22	如果obj为undefinded,直接返回
    if (obj == undefined) {
        return;
    }
    if (obj != 'UnChanged') {
        //add by zhuj on 2009-12-21
        currState = obj.split('^')[4];

        divState.innerHTML = obj.split('^')[3];
        EPRNum = obj.split('^')[2];
        getPower(); 		//add by zhuj on 2009-12-9
    }
}

//设置权限
function setPower() {
    if (canView != '1') {
        Ext.getCmp('btnUpdateData').disable();
    }	
    if (canSave == '1' && canView == '1') {
        Ext.getCmp('btnSave').enable();
    } else {
        //Ext.getCmp('btnSave').disable();
    }

    if (canCommit == '1' && canView == '1') {
        Ext.getCmp('btnCommit').enable();
    } else {
        Ext.getCmp('btnCommit').disable();
    }

    if (canSwitchTemplate == '1' && canView == '1') {
        Ext.getCmp('btnUpdateTemplate').enable();
    } else {
        Ext.getCmp('btnUpdateTemplate').disable();
    }

    if (canReference == "1") {
        Ext.getCmp('btnReference').enable();
    } else {
        Ext.getCmp('btnReference').disable();
    }
    if((RepStatus=="")||(RepStatus=="已审")||(RepStatus=="删除")) {
				Ext.getCmp("btnDelete").disable();
		}
    if(RepStatus=="已审")
		{
			Ext.getCmp("btnDelete").disable();
			Ext.getCmp('btnCommit').disable();
			Ext.getCmp('btnSave').disable();
		}
	Ext.getCmp('btnUpdateData').disable();
	Ext.getCmp('btnUpdateTemplate').disable();
}

//自动保存
function eprAutoSave() {
    if (canView == 'False') {
        return;
    }
    save('True');
}

//关闭计时器
function closeInterval() {
    clearInterval(interval);
}

function setSaveTime() {
    if (isNaN(autoSaveTime)) {
        autoSaveTime = -1;
    }

    if (autoSaveTime < 1) {
        autoSaveTime = -1;
    }

    if (autoSaveTime > 0 && autoSaveTime < 60) {
        autoSaveTime = 60;
    }
    if (autoSaveTime > 0) {
        interval = setInterval(eprAutoSave, autoSaveTime * 1000);
    }
}


//病历状态
function setEprState() {
    var divState = document.getElementById('divState');
    divState.innerHTML = divStateServer;
}

//显示历史日志信息
function showLog() {

}


function getBBar() {
    var bbar = new Ext.Toolbar({ border: false, items: [
    	{ id: 'btnNINRep', text: '感染信息', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnReference.gif', pressed: false, listeners: { 'click': function() { ShowNInfInfo(); } } },
		 '-',
		{ id: 'btnReference', text: '病历引用', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnReference.gif', pressed: false, listeners: { 'click': function() { reference(); } } },
		'->', '-',
		{ id: 'btnSave', text: '保存', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/save.gif', pressed: false, listeners: { 'click': function() { save(); } } },
		'-',
		{ id: 'btnCommit', text: '提交', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/submission.gif', pressed: false, handler: commit },
		'-',
		{ id: 'btnDelete', text: '删除', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/cancelall.gif', pressed: false, listeners: { 'click': function() { DeleteEPRRep(); } } },
		'-',
		{ id: 'btnUpdateData', text: '更新数据', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/upda.gif', pressed: false, handler: update },
		'-',
		{ id: 'btnUpdateTemplate', text: '更新模板', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/updaTemplate.gif', pressed: false, handler: updateTemplate },
		'-'
		]
    });
    return bbar;
}

function getTBar() {
    var tbar = new Ext.Toolbar({ height: 28, border: false });
    return tbar;
}

function getCenterTabVPort() {

    var frmMainContent = new Ext.Viewport({
        id: 'centertabviewport',
        shim: false,
        animCollapse: false,
        constrainHeader: true,
        margins: '0 0 0 0',
        layout: 'border',
        items: [{
            border: false, region: 'center', layout: 'border',
            items: [

				{
				    border: false, region: 'center', layout: 'fit', html: _IframeScript
				},
				{
				    border: false, region: 'south', layout: 'column', height: 46, items:
					[
						{ border: false, columnWidth: 1, height: 27, items: getBBar() },
						{ border: false, columnWidth: 1, height: 24, html: '<div id="divStateParent" class="divStateParent"><div id="divState" style= "float:left;line-height:15px;"></div><div id="divDetail" style= "float:right;width:32px"><img alt="" style="cursor:pointer;margin-top:2px;" src="../scripts/epr/Pics/browser.gif" onClick="showLog()" /></div></div>' }
                	]
				}
		    ]
        }]
    });
}

    
    getCenterTabVPort(); 


    //add by loo on 2010-7-27
    //历次模板保存(F7)?提交(F8)操作添加快捷键
    //debugger;
    var map = new Ext.KeyMap(Ext.getDoc(), {
        key: 118, // F7
        fn: function() {
            save();
        },
        scope: this
    });

    map.addBinding({
        key: 119, //F8
        fn: function() {
            commit();
        },
        scope: this
    });


    //设置病历状态
    setEprState();

    //设置权限
    setPower();
    //自动保存
    setSaveTime();

    //隐藏病历引用功能按钮
    document.getElementById("btnReference").style.visibility = 'hidden';