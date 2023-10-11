/// 对外处理
var HisTools;

function initHisTools () {
    HisTools = new function () {
        this.refreshOeOrdGrd = null; //刷新资源区医嘱grid的委托
        this.closeEmrFrm = function () {
            window.opener = null;
            window.open('', '_self');
            window.close();
        };
        this.closeHislinkWindow = function () {
            HisTools.hislinkWindow.closeAll();
        };
        this.refreshResFrame = function () {
            // 刷新资源区
            var args = {
                papmi: patInfo.PatientID,
                adm: patInfo.EpisodeID,
                mradm: patInfo.MRadm
            };
            HisTools.dataTabs.refresh();
            HisTools.hislinkWindow.closeAll();
        };
        this.checkOeordBeforeUnload = function () {
            return HisTools.dataTabs.checkOeordBeforeUnload();
        };
        this.refreshDiagFrame = function (args) {
            HisTools.diagFrame.refresh(args);
        };
        this.refreshOeordFrame = function () {
            HisTools.dataTabs.refreshOeordFrame();
        }
    };
    ///  弹窗
    HisTools['hislinkWindow'] = new function () {
        dialogId = ""; // 弹窗是否关闭标识

        this.args = null;

        this.setArgs = function (title, lnk, confirmCallback, cancelCallback) {
            this.args = {
                title: title,
                lnk: replaceLinkParams(lnk),
                confirmCallback: confirmCallback,
                cancelCallback: cancelCallback
            }
        }
        this.show = function(winName, wWidth, wHeight, isDirectOpen) {//alert(wWidth+", "+wHeight);
            function closeDialogFlag(){
                dialogId = "";
            }
            dialogId = 'hislink';
            if (!wWidth || !wHeight) {
                //wWidth = $('body').width() - 200;
                //wHeight = $('body').height() - 50;
                wWidth = window.screen.availWidth - 200;
                wHeight = window.screen.availHeight - 250;
				if ((typeof(isDirectOpen) != undefined)&&(isDirectOpen == "Y"))
				{
                    var content = "<iframe id='hislinkFrame' scrolling='auto' frameborder='0' src='"+this.args.lnk+"' style='width:100%; height:100%;'></iframe>";
                    createModalDialog(dialogId,winName,wWidth,wHeight,'hislinkFrame',content,closeDialogFlag,'');
				}
				else
				{
                    var lnk = this.args.lnk;
                    var src = "emr.opdoc.hislink.window.csp?lnk="+lnk+"&title="+winName+"&dialogId="+dialogId+"&isConfirmCallback=Y&MWToken="+getMWToken();
                    var content = "<iframe id='hislinkFrame' scrolling='auto' frameborder='0' src='"+src+"' style='width:100%; height:100%;'></iframe>";
                    createModalDialog(dialogId,winName,wWidth,wHeight,'hislinkFrame',content,closeDialogFlag,'');
				}
            } else {
                var iWidth = wWidth;
                var iHeight = wHeight;
                var lnk = this.args.lnk;
                var src = "emr.opdoc.hislink.window.csp?lnk="+lnk+"&title="+winName+"&dialogId="+dialogId+"&isConfirmCallback=Y&MWToken="+getMWToken();
                var content = "<iframe id='hislinkFrame' scrolling='auto' frameborder='0' src='"+src+"' style='width:100%; height:100%;'></iframe>";
                createModalDialog(dialogId,winName,iWidth,iHeight,'hislinkFrame',content,closeDialogFlag,'');
            }
        } 

        this.closeAll = function () {
            if (dialogId != "") {
                $HUI.dialog('#hislink').close();
                dialogId = "";
            }
            return;
        }

        /// 接收编辑器发出的事件，打开链接单元
        /// EMRservice.Ajax.opHISInterface原接口所在类
        this.openUnitLink = function (unitLink, args) {

            function writeBack(unitLink, args) {
                var data = ajaxDATA('String', 'EMRservice.BL.opInterface', unitLink.Method, patInfo.EpisodeID, patInfo.SsgroupID);
                ajaxGET(data, function (ret) {
                    if (ret != "") {
                        ret = $.parseJSON(ret);
                        if (ret.Value == "") {
                            var param = [];
                            if (typeof args.Url.relation != "undefined") {
                                if (typeof args.Url.relation.length != "undefined") {
                                    $.each(args.Url.relation, function(index, item){
                                        param.push({"Path":item.path,"Value":ret[item.name]});
                                    });
                                }else {
                                    param.push({"Path":args.Url.relation.path,"Value":ret[args.Url.relation.name]});
                                }
                            }
                            iEmrPlugin.UPDATE_INSTANCE_DATA({
                                actionType: args.WriteBack,
                                InstanceID: emrEditor.getInstanceID(),
                                Path: args.path,
                                Value: ret[args.Url.name],
                                Other: param
                            });
                        }else if (ret.Value != "") {
                            iEmrPlugin.UPDATE_INSTANCE_DATA({
                                actionType: args.WriteBack,
                                InstanceID: emrEditor.getInstanceID(),
                                Path: args.Path,
                                Value: ret.Value
                            });
                        }
                    }
                    else {
                        //$.messager.alert('提示', '未获取到数据！', 'info');
                        alert('未获取到数据！');
                    }
                }, function (ret) {
                    //$.messager.alert('发生错误', unitLink.Method + '发生错误' + ret + '】配置！', 'error');
                    alert(unitLink.Method + '发生错误' + ret + '】配置！');
                });
            }

            this.setArgs(unitLink.Title, unitLink.Link,
                function () {
                writeBack(unitLink, args);
            }, null);
            eventSave("openUnitlink");
			if ((typeof(unitLink.IsDirectOpen) != undefined)&&(unitLink.IsDirectOpen == "Y"))
			{
				this.show(unitLink.Title, "", "", "Y");
			}
			else
			{
				this.show(unitLink.Title);
			}
            //this.show(args.Url);
        }
    };
    /// 资源区
    HisTools['dataTabs'] = new function () {
        var $dataTabs = $('#dataTabs');
        var lastSelectedDataTab = -1;

        function checkOeord(index) {
            function oeordEditRowForEMR() {
				
				
				//var oeordFrame = window.frames['oeordFrame'];
				var oeordFrame = document.getElementById('oeordFrame')&&document.getElementById('oeordFrame').contentWindow
			
				if ((typeof oeordFrame === 'undefined')||(oeordFrame == null))
                    return;
                var editRowForEMR = oeordFrame.EditRowForEMR;
                if (typeof editRowForEMR === 'function')
                    editRowForEMR();
            }
            if (lastSelectedDataTab == 0 && index != 0) {
                if (HisTools.checkOeordBeforeUnload()) {
                    $dataTabs.tabs('select', 0);
                    oeordEditRowForEMR();
                    return true;
                }
            }
            return false;
        }

        function onSelect(title, index) {
            if (checkOeord(index))
                return;
            lastSelectedDataTab = index;
            var tab = $dataTabs.tabs('getSelected');
            if (0 === tab.find('iframe').length)
                return;

            var iframe = tab.find('iframe')[0];
            if ('' == $(iframe).attr('src')) {
                if (isExistVar($(iframe).attr('src'))) {
                    $(iframe).attr('src', replaceLinkParams($(iframe).attr('lnk')));
                }
            } else {
                var frameName = iframe.name;
                var frame = document.getElementById(frameName).contentWindow //window.frames[frameName];
                if (frame) {
                    var fnReLoadLabInfo = frame.ReLoadLabInfo;
                    if ('function' === typeof fnReLoadLabInfo) {
                        fnReLoadLabInfo();
                    } else if ($(iframe).attr('refreshOnSelect') == 'Y') {
                        if (isExistVar($(iframe).attr('src'))) {
                            $(iframe).attr('src', replaceLinkParams($(iframe).attr('lnk')));
                        }
                    }
                }
            }
        }

        $dataTabs.tabs({
            //plain: true,
            narrow: false,
            pill: true,
            justified: true,
            onSelect: function (title, index) {
                onSelect(title, index);
            }
        });

        function addTabs(data) {
            if (!data || 0 == data.length) {
                return;
            }
            for (var idx = 0, max = data.length; idx < max; idx++) {
                var item = data[idx];

                var _content = '';
                if (isExistVar(item.Content) && '' !== item.Content) {
                    _content = '<iframe id="' + item.Frame + '" name="' + item.Frame + '" ';
                    _content += 'src="" style="width:100%;height:100%;"'
                    var zoom = item.Zoom || '';
                    if (zoom !== '')
                        _content += 'zoom:' + zoom + '%';
                    var scrolling = item.Scrolling || 'no';
                    _content += '" frameborder="0" scrolling="' + scrolling;
                    _content += '" lnk="' + item.Content + '" refreshOnSelect="' + item.RefreshOnSelect + '"></iframe>';
                }
                /*if (item.Name === 'opdocAdmHistory') {
                    var opHistoryFlag = common.getOPHistoryFlag();                    
                    if ($.parseJSON(opHistoryFlag.replace(/\'/g, "\""))[0].AdmHistoryCount > 0) {
                        item.Title = item.Title+'<sup style="border-radius: 10px; border: 1px solid transparent; border-image: none; left: 50px; top: 12px; width: 10px; height: 10px; text-align: center; color: rgb(255, 255, 255); line-height: 10px; font-size: 10px; display: inline-block; position: absolute; transform: translateY(-50%) translateX(100%); background-color: rgb(238, 79, 56);"></sup>';
                    }
                }*/
                //结核病历
                if ((sysOption.PhthisisEpisodeIDs == "")&&(item.Name === 'phthisisRecordCatalog')){
                    continue;
                }
                var setSelected = false;
                var tab = $dataTabs.tabs('getSelected');
                if (!tab) {
                    setSelected = true;
                }

                $dataTabs.tabs('add', {
                    id: item.Name,
                    title: item.Title,
                    selected: (setSelected)&&(plantToothTreatmentCategory == ""),
                    fit: true,
                    content: _content,
                    href: item.Href
                });
            };
        }
		
		if(plantToothTreatmentCategory !== "")
        {
	        $dataTabs.tabs('add', {
	            id: 'dentalImplants',
	            title: '种植牙疗程',
	            selected: true,
	            fit: true,
	            content: "<iframe id='dentalimplantsFrame' name='dentalimplantsFrame' src='' style='width:100%;height:100%;' frameborder='0' scrolling='no' lnk='emr.opdoc.planttoothtreatment.csp?PatientID=@patientID&EpisodeID=@episodeID' refreshOnSelect=''></iframe>"
	        });
        }

        addTabs(envVar.opResource);

        this.refresh = function () {
            var tabs = $dataTabs.tabs('tabs');
            for (var idx = tabs.length - 1; idx > -1; idx--) {
                $dataTabs.tabs('close',idx);
            }

            //结核病历
            var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getPhthisisRecordAdm', patInfo.EpisodeID);
            ajaxGETSync(data, function (ret) {
                sysOption.PhthisisEpisodeIDs = ret;
            }, function (ret) {
                $.messager.alert('发生错误', 'getPhthisisRecordAdm error:' + ret, 'error');
            });
            addTabs(envVar.opResource);
        }

        this.refreshOeordFrame = function () {

            var tabs = $dataTabs.tabs('tabs');
            var tab = $dataTabs.tabs('getSelected');
            var index = $dataTabs.tabs('getTabIndex', tab);
            for (var j = 0, len = tabs.length; j < len; j++) {
                if (tabs[j].panel('options').id === 'DIAoeordFrame') {
                    iframe = tabs[j].find('iframe');
                    if (iframe.length > 0) {
                        $(iframe[0]).attr('src', '');
                        if (index === j)
                            $(iframe[0]).attr('src', replaceLinkParams($(iframe[0]).attr('lnk')));
                    }
                }
            }
        }

        this.checkOeordBeforeUnload = function () {
            
			//var oeordFrame = window.frames['oeordFrame'];
            var oeordFrame = document.getElementById('oeordFrame')&&document.getElementById('oeordFrame').contentWindow
			
            if ((typeof oeordFrame === 'undefined')||(oeordFrame == null))
                return false;
            var checkModifiedBeforeUnload = oeordFrame.checkModifiedBeforeUnload;
            if (typeof checkModifiedBeforeUnload !== 'function')
                return false;
            var flag = checkModifiedBeforeUnload();
            if (flag && !confirm('医嘱有未审核项目，确定切换?')) {
                return true;
            }
            return false;
        }

        this.switchDataTab = function (tabName) {
            var tab = $('#dataTabs').tabs('getSelected');
            if (tabName === tab.panel('options').title)
                return;

            $.each($('#dataTabs').tabs('tabs'), function (idx, item) {
                if (tabName === item.panel('options').title) {
                    $('#dataTabs').tabs('select', idx);
                    return false;
                }
            });
        }
    };
}

/// 平台调用
function updateEMRInstanceData(flag, content, callback, episodeID) {
    //增加逻辑校验防止串患者
    if (typeof episodeID != 'undefined') {
        if (patInfo.EpisodeID != episodeID) {
            return;
        }  
    }

    var instanceId = emrEditor.getInstanceID();
    if ('' === instanceId)
        return;
    var displayName = '';
    if (flag === 'diag')
        displayName = '诊断';
    else if (flag === 'oeord')
        displayName = '医嘱';
    else if ((flag === 'oeordCN') || (flag === 'zoeord'))
        displayName = '草药';
    else if (flag === 'pacs')
        displayName = '检查';
    else if (flag === 'allergic')
	{
		displayName = '过敏';
		if ((typeof(content.UpdateEMR)=="undefined")||(content.UpdateEMR != true)) return;
		var queryAllergiesList = "";
		if (typeof(content.QueryAllergiesList)!="undefined") queryAllergiesList = content.QueryAllergiesList;
		var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getAllergic', patInfo.EpisodeID, queryAllergiesList);
		ajaxGETSync(data, function (ret) {
			content = ret;
		}, function (ret) {
			alert('getAllergic error:' + ret);
		});
	} 
    else
        return;
    editorEvt.evtAfterGetMetaDataTree = function (commandJson) {
        var path = emrEditor.getHyperLinkPath(commandJson.args.items, displayName);
        if (path === '')
            return;
        var rtn = iEmrPlugin.UPDATE_INSTANCE_DATA({
            actionType: 'Replace',
            InstanceID: instanceId || '',
            Path: path,
            Value: content.replace(/\\r\\n/g, '\n').replace(/@/g, '\n'),
            isSync: true
        });
        if (rtn.result == 'OK') {
            if (typeof callback == 'function') {
                callback();
            } else {
                eventSave("updateInsByDoc");
            }
        }
    };
    iEmrPlugin.GET_METADATA_TREE();
}

/// 平台的方法
function invokeChartFun(tabName, funName) {
    var fn = this[funName];
    if ('function' === typeof fn) {
        var args = [];
        for (var i = 2, len = arguments.length; i < len; i++) {
            args.push(arguments[i]);
        }
        fn.apply(this, args);
    }
}

