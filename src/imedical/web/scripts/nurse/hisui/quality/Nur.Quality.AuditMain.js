/**
 * @description: �ʿ�������
 * @author: ouzilin
 * @date: 2020-04-29 10:28:20
*/
var GV = {
    currentCTLOCID: session['LOGON.CTLOCID'],
    currentUSERID: session['LOGON.USERID'],
    currentUSERNAME: session['LOGON.USERNAME'],
    currentGROUPID: session['LOGON.GROUPID'],
    currentWARDID: (session['LOGON.WARDID'] == undefined) ? "" : session['LOGON.WARDID'],
    currentHOSPID: session['LOGON.HOSPID'],
    tableName: "Nur_IP_Quality.WorkFlowConfig",
    editIndex: undefined,
    roles: "",  //��ǰ�û���Ȩ�޽�ɫ
    statusList: { 'all': $g("ȫ��") }, // ״̬
    showStatusList: {all: $g('ȫ��'), S: $g('���ʿ�Ա���'), ZKYSH: $g('����ʿ�����'), HSZ: $g('���������'), HLBSH1: $g('���ͨ��')}, // xfc������
    buttonList: [], // ��ť
    statusConfigList: [],   // ״̬
    hiddenAppraise: "", //�Ƿ��������۹���
    hiddenNote: "",  //�Ƿ����α�ע����
    statusColor: {}, // ״̬��Ӧ����ɫ����
    nurseList: [],
    selNode: new Object()
}
/**
* @description: ��ʼ��״̬checkbox
*/
function initStatus() {
    GV.statusConfigList = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getStatusList",
        User: GV.currentUSERID,
        Group: GV.currentGROUPID,
        Loc: GV.currentCTLOCID,
        Hosp: GV.currentHOSPID
    }, false);

    for (var i = 0, length = GV.statusConfigList.length; i < length; i++) {
        var single = GV.statusConfigList[i]
        if ((single.code).indexOf('@') > -1) continue
        GV.statusList[single.code] = single.desc
    }
    var needAddplace = $('.nur_checkbox')
    for (var item in GV.statusList) {
        needAddplace.append(
            // xfc���޸�
            '<li><input  id="' + item + '"  class="hisui-checkbox" type="checkbox" checked="true" label="' + GV.showStatusList[item] + '"></li>'
        )
    }
}

initStatus()

$(function () {
    initUI()
})

function initUI() {
    initBeforeLoad();   //����ǰ��ʼ��
    initAppraiseNote();  //�����������ػ���ʾ����
    initSearchForm();   //��ʼ����ѯ����
    initGrid();         //��ʼ�����ݱ��
    initAuditDetail(); //��ʼ�� ���״̬��ϸ�Ĵ���
    initEmrShowAndHandler(); //��ʼ�� ����������ƺ�Ĵ���
}
/**
* @description: ����ǰ��ʼ��
*/
function initBeforeLoad() {
    GV.buttonList = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getButtonList",
        User: GV.currentUSERID,
        Group: GV.currentGROUPID,
        Loc: GV.currentCTLOCID,
        Hosp: GV.currentHOSPID
    }, false);

    for (var f = 0, length = GV.buttonList.length; f < length; f++) {
        var single = GV.buttonList[f]
        if ((single.code).indexOf('@') > -1) continue
        if (GV.roles == "") GV.roles = single.code
        else GV.roles = (GV.roles + "^" + single.code)
    }

    GV.hiddenAppraise = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getSingleConfig",
        code: "appraise",
        HospId: GV.currentHOSPID
    }, false);

    GV.hiddenNote = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getSingleConfig",
        code: "note",
        HospId: GV.currentHOSPID
    }, false);

    GV.statusColor = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getAllStatusColor",
        HospId: GV.currentHOSPID
    }, false);
}
/**
* @description:�����������ػ���ʾ����
*/
function initAppraiseNote() {
    if (GV.hiddenNote) {
        $("#emrNotesBtn").css("visibility", "hidden")

    }
    if (GV.hiddenAppraise) {
        $("#emrAppraiseBtn").css("visibility", "hidden")
        $('#emrAndAppraiseList').tabs("close", 1)
    }
}
/**
* @description: ��ʼ����ѯ����
*/
function initSearchForm() {
    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    /**���� */
    $('#inputWardID').combobox({
        disabled: (GV.currentWARDID != "" ? true : false),
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2=' + GV.currentHOSPID + "&parameter3=" + GV.tableName,
        filter: filter,
        onLoadSuccess: function (params) {
            if (GV.currentWARDID != "") {
                $(this).combobox('setValue', session['LOGON.CTLOCID'])
            }
        }
    })

    /**���� */
    $HUI.switchbox('#patSwitch', {
        onText: $g('��Ժ����'),
        offText: $g('ת��/��Ժ����'),
        size: 'small',
        animated: true,
        onClass: 'primary',
        offClass: 'gray',
        style: { height: '30px' },
        onSwitchChange: function (event, obj) {
            if (obj.value) {
                $("#dateInput").css("display", "none")
            } else {
                $("#dateInput").css("display", "")
            }
            searchBtn()
        },
    })

    $("#dateInput").css("display", "none")
    /**��Ժʱ�� */
    $('#inputOutHopStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
    $('#inputOutHopEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    /**�ؼ��� */
    $('#inputMainSelect').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g('�ǼǺ�'),
            value: 'regNo'
        }, {
            label: $g('����'),
            value: 'bedCode'
        }, {
            label: $g('��������'),
            value: 'name'
        }, {
            label: $g('�����ȼ�'),
            value: 'recGrade'
        }, {
            label: $g('��������'), //xfc��������������
            value: 'recDesc'
        }]
    })

    $('#inputMainInput').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            searchBtn();
        }
    });

    /**��ѯ */
    $('#searchBtn').on('click', function () {
        searchBtn()
    })

    /**���� */
    $('#exportBtn').on('click', function () {
        exportBtn();
    })

    $HUI.checkbox("#all", {
        onCheckChange: function (e, value) {
            allCheckBoxClick(value)
            /*
            if (value)
            {
                allCheckBoxClick(value)
            }
            */
        }
    })

    /*
    for (var item in GV.statusList)
    {
        (function(item){
            if (item != "all")
            {
                $HUI.checkbox('#' + item, {
                    onCheckChange: function(e, value){
                        otherBoxClick(value)
                    }
                })
            }
        }
        )(item)
    }
    */
}

/**
* @description: ���
*/
function initGrid() {
    /*��ȡ���õ���*/
    var configColumns = $cm({
        ClassName: "Nur.Quality.Service.AuditPageColumn",
        MethodName: "getConfig",
        HospId: GV.currentHOSPID
    }, false);

    var frozenColumns = [
        { field: 'ck', checkbox: true },
        {
            field: 'status', title: $g('״̬'), width: 110, align: 'left',
            styler: function (value, row, index) {
                if (!!GV.statusColor[value]) {
                    return 'color:#ffffff;background-color:' + GV.statusColor[value];
                } else {
                    return false;
                }

            },
            formatter: function (data) {
                return $g(data)
            }
        },
        { field: 'statusDetail', title: $g('״̬��ϸ'), width: 70, formatter: showImg, align: 'center' }
    ]
    var columns = []
    columns = columns.concat(configColumns)

    columns = columns.concat([{ field: 'recDesc', title: $g('��������'), width: 240, align: 'left', formatter: showRecDesc },
    { field: 'evaluation', title: $g('���۽��'), width: 80, align: 'center', formatter: showEvalution, hidden: (GV.hiddenAppraise ? true : false) },
    { field: 'recGrade', title: $g('�����ȼ�'), width: 80, align: 'center', formatter: showGrade, hidden: (GV.hiddenAppraise ? true : false) },
    { field: 'auditMainID', title: 'ID', width: 80, align: 'center', hidden: true },
    { field: 'episodeID', title: 'episodeID', width: 80, align: 'center', hidden: true }])

    var toolbar = []
    for (var i = 0, length = GV.buttonList.length; i < length; i++) {
        var single = GV.buttonList[i];
        (function (single) {
            toolbar.push({
                iconCls: (single.code.indexOf("@") > -1) ? 'icon-back' : 'icon-ok',
                text: single.desc,
                handler: function () {
                    changeStatus(single.code)
                }
            })
        })(single)
    }

    $('#patEmrDataListTable').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAuditRec',
            WardID: GV.currentCTLOCID,
            Type: "I",
            MainSelect: $('#inputMainSelect').combobox('getValue'),
            MainInput: $('#inputMainInput').val(),
            Status: getAllChecked(),
            StartDate: $('#inputOutHopStartDate').datebox('getValue'),
            EndDate: $('#inputOutHopEndDate').datebox('getValue'),
            Roles: GV.roles,
            HospId: GV.currentHOSPID
        },
        method: 'post',
        loadMsg: $g('����װ����......'),
        nowrap: false,
        striped: false,
        //fitColumns: true,
        autoRowHeight: true,
        singleSelect: false,
        showHeader: true,
        frozenColumns: [frozenColumns],
        columns: [columns],
        pagination: true,
        pageSize: 10,
        pageList: [10, 20, 50, 200],
        pagePosition: 'bottom',
        toolbar: toolbar,
        // onClickCell: function(rowIndex, field, value){
        //     if (field == "recDesc")
        //     {
        //         var rows = $(this).datagrid('getRows')
        //         var currentRow = rows[rowIndex]
        //         initEmrAndAppraiseList()
        //         getEmrList(currentRow['episodeID']) //��ȡ�����б�
        //         getAppraiseList("55") //��ȡ�����б� ����š�����ID
        //         $('#showAndAppraiseEmr').window('open')
        //     }
        // }
        onLoadSuccess: function(data) {
            if ($('#loading').length > 0) {
                $('#loading').hide();
            }
        }
    })
}
/**
* @description:��ʼ�����״̬��ϸ�Ĵ���
*/
function initAuditDetail() {
    $('#auditDetailsWin').window({
        width: 620,
        height: 500,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('�����ϸ'),
        iconCls: 'icon-w-paper'
    })
}

/**
* @description: ��ʼ�� ����������ƺ�Ĵ���
*/
function initEmrShowAndHandler() {
    $('#showAndAppraiseEmr').window({
        width: 1400,
        height: 770,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('��������'),
        iconCls: 'icon-w-paper'
    })
    //��ע��ť
    $('#emrNotesBtn').on('click', function () {
        clickBtnEvent('emrNotesBtn')
    })
    //���۰�ť
    $('#emrAppraiseBtn').on('click', function () {
        clickBtnEvent('emrAppraiseBtn')
    })
    //�л�tab
    $('#emrAndAppraiseList').tabs({
        onSelect: function (title, index) {
            if (index == 0) {
                $('#emrAndAppraiseDetails').removeAttr("hidden")
                $('#showAppraiseDetails').attr("hidden", "true")
                $('#showEmrScoreList').html("")
                hiddenBtnAndNotes()
            } else {
                $('#emrAndAppraiseDetails').attr("hidden", "true")
                $('#showAppraiseDetails').removeAttr("hidden")
                $('#inputEmrScoreList').html("")
                $('#appraiseListTable').datagrid('reload');
                hiddenBtnAndNotes()
            }
        }
    })

    initShowInputEmrNote(); //��ʼ�� ����������鴰������ı�ע��ť ��ʼ����ע����
    initShowInputEmrScore(); //��ʼ�� ����������鴰����������۰�ť ��ʼ�����۵���
}
/**��ʼ����עģ��*/
function initShowInputEmrNote() {

    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    $('#showInputEmrNote').window({
        width: 800,
        height: 400,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('��ע'),
        iconCls: 'icon-w-pen-paper'
    })

    $('#showInputEmrNote').window({
        "onClose": function () {
            $('#emrTree').tree("reload")
        }
    })

    $('#searchNoteBtn').on('click', function () {
        clickBtnEvent('searchNoteBtn')
    })
    $('#inputEmrNoteTable').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAuditNoteRec',
            AuditMainID: "",
            StartDate: "",
            EndData: ""
        },
        method: 'post',
        loadMsg: $g('����װ����......'),
        // striped: true,
        // fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        rownumbers: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            { field: 'content', title: '��ע����', width: 150, editor: { type: 'textarea' } },
            { field: 'addUser', title: '��ע��', width: 70, align: 'left' },
            { field: 'addDateTime', title: '��ע����', width: 160, align: 'left' },
            {
                field: 'responsible', title: '������', width: 70, align: 'left',
                formatter: function (value, row, index) {
                    var targetArr = GV.nurseList
                    if (value == undefined) {
                        return value;
                    } else {
                        var tmpVal = value.toString().split(",")
                        var resault = [];
                        for (var i = 0; i < targetArr.length; i++) {
                            tmpVal.forEach(function (item) {
                                if (parseInt(targetArr[i].Id) == parseInt(item)) {
                                    resault.push(targetArr[i].Desc)
                                }
                            })
                        }
                        return resault.join(",");
                    }
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'Id',
                        textField: 'Desc',
                        data: GV.nurseList,
                        multiple: true,
                        filter: filter
                    }
                }
            },
            {
                field: 'ifAdajust', title: '�Ƿ����', width: 70, align: 'left', editor: 'text',
                formatter: function (value) {
                    if (value == 0) {
                        return $g("��")
                    } else {
                        return $g("��")
                    }
                },
                editor: {
                    type: 'checkbox',
                    options: {
                        on: "1",
                        off: "0",
                    }
                }
            },
            { field: 'adajustUser', title: '������', width: 70, align: 'left' },
            { field: 'adajustDateTime', title: '��������', width: 150, align: 'left' },
            { field: 'auditMainNoteSubID', title: 'ID', width: 70, align: 'left', hidden:true }
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar: [{
            iconCls: 'icon-add',
            text: $g('����'),
            handler: function () {
                $('#inputEmrNoteTable').datagrid("rejectChanges");
                $('#inputEmrNoteTable').datagrid("unselectAll");
                $('#inputEmrNoteTable').datagrid('insertRow', {
                    index: 0,	// index start with 0
                    row: {
                        addUser: GV.currentUSERNAME
                    }
                });
                GV.editIndex = 0
                $('#inputEmrNoteTable').datagrid('beginEdit', 0)
            }
        }, {
            iconCls: 'icon-cancel',
            text: $g('ɾ��'),
            handler: function () {
                emrNoteHandler('delete')
            }
        }, {
            iconCls: 'icon-save',
            text: $g('����'),
            handler: function () {
                emrNoteHandler('save')
            }
        }
        ],
        onDblClickRow: function (rowIndex, rowData) {
            $('#inputEmrNoteTable').datagrid("rejectChanges");
            $('#inputEmrNoteTable').datagrid("unselectAll");
            $('#inputEmrNoteTable').datagrid("selectRow", rowIndex)
            $('#inputEmrNoteTable').datagrid("beginEdit", rowIndex);
            GV.editIndex = rowIndex
            // if (endEdit())
            // {
            //     GV.editIndex=rowIndex
            //     $('#inputEmrNoteTable').datagrid("beginEdit", rowIndex);
            // }
        }
    })
}
/**
* @description: ��ʼ����������ģ��
*/
function initShowInputEmrScore() {
    $('#showInputEmrScore').window({
        width: 970,
        height: 650,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('����'),
        iconCls: 'icon-w-edit'
    })
}
/***********************���״̬��ϸ************************** */
/**
 * ���״̬��ϸ
 * @param {*} auditMainID 
 * @param {*} episodeID 
 */
function showEmrAuditDetails(auditMainID, episodeID) {
    getBannerPatInfo(episodeID)
    runClassMethod("Nur.Quality.Service.Audit", "getAuditMainDetails",
        {
            parameter1: JSON.stringify(eval(auditMainID))

        }, function (data) {
            data = eval(data)
            var details = data['details']
            var currentStatus = data['status']
            $('#selectEmrDesc').text($g(currentStatus['emrDesc']))
            $('#selectStatusInfo_status').text($g(currentStatus['status']))
            $('#selectStatusInfo_detaTime').text(currentStatus['Date'])
            $('.auditRecDetailsProcess').html('')
            console.log(data);
            var items = new Array();
            for (var item in details) {
                var currentItem = details[item];
                var auditDateTime = currentItem['auditDateTime'];
                var auditUser = currentItem['auditUser'];
                var status = currentItem['status'];
                var item = new Object();
                item['title'] = status;
                item['context'] = '<label>' + $g('�����ˣ�') + '</label><div class="cntt"><div>' + auditUser + '</div><div>' + auditDateTime + '</div></div>';
                items.push(item);
            }

            $('.auditRecDetailsProcess').vstep({
                stepHeight: 40,
                currentInd: details.length,
                onSelect: function (ind, item) { console.log(item); },
                //titlePostion:'top',
                items: items.reverse()
            });

            // for (var item in details) {
            //     var currentItem = details[item]
            //     var auditDateTime = currentItem['auditDateTime']
            //     var auditUser = currentItem['auditUser']
            //     var status = currentItem['status']
            //     var needHTML =
            //         '<div class="processBar">' +
            //         ((item == (details.length - 1)) ? '<div class="processStepSingle ' + ((item == 0) ? "processSelect" : "") + '"></div>' : '<div class="processLine ' + ((item == 0) ? "processLineSelect" : "") + '"><div class="processStep ' + ((item == 0) ? "processSelect" : "") + '"></div></div>') +
            //         '<div class="processBarText">' +
            //         '<div><span style="width: 100px;float: left;">' + $g(status) + '</span><span class="processBarTextDate">' + auditDateTime + $g('   ������: ') + auditUser + '</span></div>' +
            //         // '<div>������:���ͨ��</div>' +
            //         '</div>' +
            //         '</div>'
            //     $('.auditRecDetailsProcess').append(needHTML)
            // }
            $('#auditDetailsWin').window('open');
        })
}
/**
 * ��ȡ״̬��ϸ���ڵ�ͷ��������Ϣ
 * @param {*} episodeID 
 */
function getBannerPatInfo(episodeID) {
    runClassMethod("Nur.Quality.Service.Audit", "getBannerPatInfo", {
        parameter1: episodeID
    }, function (data) {
        var data = eval(data)
        var sex = data["sex"]
        if (sex == $g('��')) {
            $('#sex').removeClass('unman man woman').addClass('man');
        } else if (sex == $g('Ů')) {
            $('#sex').removeClass('unman man woman').addClass('woman');
        } else {
            $('#sex').removeClass('unman man woman').addClass('unman');
        }
        $('#regNo').text(data["regNo"]);
        $('#bedCode').text(data["bedCode"]);
        $('#patName').text(data["patName"]);
        $('#sex2').text(data["sex"]);
        $('#age').text(data["age"]);
    })
}
/************************************************* */

/***********************�����������************************** */
/**
 * �����������
 * @param {*} episodeID  �����
 * @param {*} auditMainID  �������
 */
function clickRecDesc(episodeID, auditMainID) {
    getEmrList(episodeID, auditMainID) //��ȡ�����б�
    getAppraiseList(auditMainID) //��ȡ�����б� ����š�����ID
    $('#emrAndAppraiseList').tabs("select", 0)  //Ĭ��ѡ���б�ҳǩ
    hiddenBtnAndNotes()  //��������ģ��İ�ť
    $('#showAndAppraiseEmr').window('open')
}
/**
 * ��ȡ���˱�����Ĳ���
 * @param {*} episodeID 
 */
function getEmrList(EpisodeID, auditMainID) {

    var tabs = $('#emrAndAppraiseDetails').tabs('tabs')
    for (var i = 0, tabLength = tabs.length; i < tabLength; i++) {
        $('#emrAndAppraiseDetails').tabs('close', 0)
    }

    $('#emrTree').tree({
        //url: '../web.eprajax.GivePower.cls?Action=tree&EpisodeID=' + episodeID,
        url: LINK_CSP + "?className=Nur.Quality.Service.Audit&methodName=getAuditEmrByEpisodeID&parameter1=" + EpisodeID + "&parameter2=" + $('#inputWardID').combobox('getValue') + "&parameter3=" + auditMainID,
        method: 'get',
        animate: true,
        onSelect: openRecord,
        onLoadSuccess: function (node, data) {
            //$('#emrTree').tree('select', node.target);
            /*Ĭ��ѡ�в���*/
            var rootNode = data[0];
            if ($('#emrAndAppraiseDetails').tabs('tabs').length == 0) {
                rootNode.children.forEach(function (single) {
                    if (single.checked){
                        var node = $('#emrTree').tree('find', single.id);
                        $('#emrTree').tree('select', node.target);
                        // openRecord(node)
                    }
                });
            } else {
                if (selNode) {
                    var node = $('#emrTree').tree('find', selNode.id);
                    if ((node.id == "TEMP") || (node.id == "ORDER")) {
                        if (!$('#' + node.domId).hasClass('tree-node-selected')) {
                            $('#' + node.domId).addClass('tree-node-selected');
                        }
                    } else {
                        $('#emrTree').tree('select', node.target);
                    }
                }
            }
        }

    });


    var currentTab = $('#emrAndAppraiseDetails').tabs('getSelected');
    if (currentTab != null) {
        setTimeout(function () {
            var iframe = $(currentTab.panel('options').content);
            var src = iframe.attr('src');
            var jsonUrl = serilizeURL(src);
            if (jsonUrl["EpisodeID"] != EpisodeID) {
                var tabUrl = jsonUrl["csp"] + "?EpisodeID=" + EpisodeID + "&EmrCode=" + jsonUrl["EmrCode"];
                var frameId = "iframetab" + jsonUrl["EmrCode"];
                var content = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + tabUrl + '"></iframe>';
                $('#emrAndAppraiseDetails').tabs('update', {
                    tab: currentTab,
                    options: {
                        content: content
                    }
                });
            }
        }, 200);
    }
}
/**
 * ��ʼ�������б�
 * @param {*} auditMainID 
 */
function getAppraiseList(auditMainID) {
    $('#appraiseListTable').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAppraiseList',
            AuditMainID: auditMainID
        },
        method: 'post',
        loadMsg: $g('����װ����......'),
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        nowrap: false,
        idField: 'appraiseID',
        columns: [[
            { field: 'appraiseScore', title: $g('���۽��'), width: 150, align: 'left' },
            { field: 'appraiseUser', title: $g('������'), width: 150, align: 'left' },
            { field: 'appraiseDateTime', title: $g('��������'), width: 230, align: 'left' },
            { field: 'appraiseID', title: 'ID', width: 30, hidden: true }
        ]],
        onClickRow: function (rowIndex, rowData) {
            $('#showAppraiseBtns').removeAttr("hidden")
            showEmrScoreDataList("", rowData['appraiseID'], "showEmrScoreList")
        }
    })
}

/**
 * ��������б�
 * @param {*} node
 */
function openRecord(node) {
    if (node.type == 'leaf') {
        var EpisodeID = $('#emrTree').tree('getParent', node.target).id
        if ((node.id == "TEMP") || (node.id == "ORDER")) {
            setEprMenuForm(EpisodeID, "", "", "");
            switch (node.id) {
                case "TEMP":
                    window.open(buildMWTokenUrl("./nur.hisui.temperature.linux.csp?EpisodeID=" + EpisodeID), "tempWindow", "height=700, width=1386, top=30, left=30, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
                    selNode = node;
                    break;
                case "ORDER":
                    window.open(buildMWTokenUrl("./nur.hisui.ordersheet.csp?EpisodeID=" + EpisodeID), "tempWindow", "height=700, width=1386, top=30, left=30, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
                    //orderSheetWindow(EpisodeID)
                    selNode = node;
                    break;
            }

        } else {
            $m({
                ClassName: "NurMp.Service.Template.Model",
                MethodName: "getCodeByGuid",
                Guid: node.id
            }, function (emrCode) {
                var label = node.text.split('&nbsp;')[0];
                if ($('#emrAndAppraiseDetails').tabs('exists', label)) {
                    $('#emrAndAppraiseDetails').tabs('select', label);
                } else {
                    //var tabUrl = emrCode + ".csp?EpisodeID=" + EpisodeID + "&EmrCode=" + node.id;
                    //2.3.2�滤��������csp������
                    var tabUrl = "nur.emr." + emrCode.toLowerCase() + ".csp?EpisodeID=" + EpisodeID + "&EmrCode=" + node.id;
                    var frameId = "iframetab" + node.id;
                    var content = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + buildMWTokenUrl(tabUrl) + '"></iframe>';
                    $('#emrAndAppraiseDetails').tabs('add', {
                        title: label,
                        content: content,
                        fit: true,
                        closable: true,
                        episodeId: EpisodeID
                    });
                }
                selNode = node;
                // $HUI.window('#windowMore','close');
            });
        }
    }
}
/************************************************* */

/***********************�¼�����************************** */
/**
* @description: �������ѯ��ť
*/
function searchBtn() {
    var queryParams = $('#patEmrDataListTable').datagrid('options').queryParams
    queryParams.WardID = $('#inputWardID').combobox('getValue')
    queryParams.Type = $HUI.switchbox('#patSwitch').getValue() ? "I" : "D"
    queryParams.MainSelect = $('#inputMainSelect').combobox('getValue')
    queryParams.MainInput = $('#inputMainInput').val()
    queryParams.Status = getAllChecked()
    queryParams.StartDate = $('#inputOutHopStartDate').datebox('getValue')
    queryParams.EndDate = $('#inputOutHopEndDate').datebox('getValue')
    queryParams.roles = GV.roles
    $('#patEmrDataListTable').datagrid('options').queryParams = queryParams;
    $('#patEmrDataListTable').datagrid('load');
    $(".datagrid-header-check").children().prop("checked", false);
}

/**
* @description: �����浼������
*/
function exportBtn() {
    var episodeIDs = '';
    var sel_rows = $('#patEmrDataListTable').datagrid('getSelections');
    $.each(sel_rows, function(i, r){
        episodeIDs = !!episodeIDs ? episodeIDs + '^' + r.episodeID : r.episodeID;
    });
    $('#patEmrDataListTable').datagrid('toExcel',
        {
            name: $g('����������.xls'),
            parseDataFun: function (data) {
                var data = $cm({
                    ClassName: 'Nur.Quality.Service.Audit',
                    QueryName: 'getAuditRec',
                    ResultSetType: "array",
                    WardID: $('#inputWardID').combobox('getValue'),
                    Type: $HUI.switchbox('#patSwitch').getValue() ? "I" : "D",
                    MainSelect: $('#inputMainSelect').combobox('getValue'),
                    MainInput: $('#inputMainInput').val(),
                    Status: getAllChecked(),
                    StartDate: $('#inputOutHopStartDate').datebox('getValue'),
                    EndDate: $('#inputOutHopEndDate').datebox('getValue'),
                    Roles: "",
                    exportFlag: "true",
                    HospId: GV.currentHOSPID,
                    FilterAdms: episodeIDs
                }, false)
                return data
            }
        })
    /*
    $cm({
        ClassName: 'Nur.Quality.Service.Audit',
        QueryName: 'getAuditRec',
        ResultSetType: "array",
        WardID: $('#inputWardID').combobox('getValue'),
        Type: $HUI.switchbox('#patSwitch').getValue() ? "I" : "D",
        MainSelect: $('#inputMainSelect').combobox('getValue'),
        MainInput: $('#inputMainInput').val(),
        Status: getAllChecked(),
        StartDate: $('#inputOutHopStartDate').datebox('getValue'),
        EndDate: $('#inputOutHopEndDate').datebox('getValue')
    },function(jsonData){
        var xls = new ActiveXObject ("Excel.Application");
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
    
        var cols = $('#patEmrDataListTable').datagrid('options').columns[0];
        var colCount = cols.length;
        debugger
    
        for(i=1;i <colCount-2;i++){ 
            xlSheet.Cells(1,i).value =cols[i].title.trim();
            xlSheet.Cells(1,i).Font.Bold = true;
            xlSheet.Cells(1,i).Font.Size = 12;
            xlSheet.Columns(i).ColumnWidth = 10; 
            xlSheet.Cells(1,i).Borders.Weight = 2; 
        }
        

        var row =  2;
        for (var i=0;i<jsonData.length;i++) {
            var column = 1;
            var recDesc = $.parseJSON(jsonData[i].recDesc)
            var rowSpans = recDesc.length
            var evaluation = $.parseJSON(jsonData[i].evaluation)
            var recGrade = $.parseJSON(jsonData[i].recGrade)
            // xlSheet.Range(xlSheet.cells(i+2,j+1),xlSheet.cells(i+2,maxCols)).Select(); //ѡ�����
            // ExApp.Selection.HorizontalAlignment = 3;                          //����
            // ExApp.Selection.MergeCells = true;
           // "[{"colSpan":1,"score":97}]"
           
           
           for(var j=1;j <colCount-2;j++){ 
             
                var name = cols[j].field;
                var value = jsonData[i][name]
                
                if (value==undefined)
                {
                    xlSheet.Cells(row,column).Borders.Weight = 2;
                    continue
                }
                
                if ((name == "auditMainID")||(name == "episodeID")){
                   
                }
                else if (name == "recDesc")
                {
                    for (var recIndex in recDesc){
                        recIndex = parseInt(recIndex)
                        xlSheet.Cells(row + recIndex,column).value = recDesc[recIndex].recDesc.split("&nbsp")[0];
                        xlSheet.Cells(row + recIndex,column).Borders.Weight = 2; 
                    }
                }
                else if(name == "evaluation")
                {
                    var curRow = row
                    for(var evaIndex in evaluation){
                        evaIndex = parseInt(evaIndex)
                        var curRowSpans = evaluation[evaIndex].colSpan
                        var curScore = evaluation[evaIndex].score
                        xlSheet.Cells(curRow,column).value = curScore;
                        xlSheet.Cells(curRow,column).Borders.Weight = 2; 
                        if ( curRowSpans > 1 ){
                            xlSheet.Range(xlSheet.cells(curRow, column),xlSheet.cells(curRow + curRowSpans-1, column)).Select();
                            xls.Selection.MergeCells = true;
                            xls.Selection.Borders.Weight = 2;    
                        }
                        curRow += curRowSpans 
                    }
                }
                 else if(name == "recGrade")
                {
                    var curRow = row
                    for(var recGradeIndex in recGrade){
                        recGradeIndex = parseInt(recGradeIndex)
                        var curRowSpans = recGrade[recGradeIndex].colSpan
                        var curGrade = recGrade[recGradeIndex].grade
                        xlSheet.Cells(curRow,column).value = curGrade.split(">")[1].split("<")[0];
                        xlSheet.Cells(curRow,column).Borders.Weight = 2; 
                        if ( curRowSpans > 1 ){
                            xlSheet.Range(xlSheet.cells(curRow, column),xlSheet.cells(curRow + curRowSpans-1, column)).Select();
                            xls.Selection.MergeCells = true;
                            xls.Selection.Borders.Weight = 2;    
                        }
                        curRow += curRowSpans 
                    }
                }
                else
                {
                    xlSheet.Cells(row,column).NumberFormatLocal = "@"
                    xlSheet.Cells(row,column).value = value;
                    xlSheet.Cells(row,column).Borders.Weight = 2; 
                    if (rowSpans>1)
                    {
                        xlSheet.Range(xlSheet.cells(row, column),xlSheet.cells(row + rowSpans-1, column)).Select();
                        xls.Selection.MergeCells = true;
                        xls.Selection.Borders.Weight = 2;     
                    }
                }
                column++;
                
            	
            }
            row += rowSpans
        }
        var fname = xls.Application.GetSaveAsFilename("������xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
        xls=null;
        xlBook=null; 
        xlSheet=null;
    });
    */
}
/**
 * ��������� �ύ �����ύ ��� ������� ���ذ�ť
 * @param {*} StatusCode
 */
function changeStatus(StatusCode) {
    var record = $('#patEmrDataListTable').datagrid("getSelections");
    var auditMainIDList = []
    for (var i in record) {
        auditMainIDList.push(record[i]["auditMainID"])
    }

    if (auditMainIDList.length == 0) {
        $.messager.popover({ msg: $g('��ѡ��һ��'), type: 'error', timeout: 1000 });
        return
    }
    runClassMethod("Nur.Quality.Service.Audit", "changeStatus", {
        parameter1: JSON.stringify(auditMainIDList),
        parameter2: StatusCode,
        parameter3: GV.currentUSERID,
        parameter4: GV.currentHOSPID
    }, function (data) {
        if (data == 0) {
            $.messager.alert($g("��ʾ"), $g("�����ɹ�"), "success")
            searchBtn()
        } else {
            $.messager.alert($g("��ʾ"), data, "error").window({ width: 450 });
            searchBtn()
        }
    }, "", false)

}
/**
 * ��ע���Ĳ�����ť
 * @param {*} action  delete save
 */
function emrNoteHandler(action) {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('��ѡ��һ����¼'), type: 'error', timeout: 1000 });
        return
    }
    var auditMainNoteID = "", auditMainID = "", content = "", ifAdajust = "", responsible = ""
    var auditMainID = selectedNote.auditMainID
    if (action != "delete") {
        var ed = $('#inputEmrNoteTable').datagrid('getEditor', { index: GV.editIndex, field: 'content' })
        if (ed == null) {
            $.messager.popover({ msg: $g('û����Ҫ���������'), type: 'error', timeout: 1000 });
            return
        }
        var content = $(ed.target).val();
        if ((content == "") || (content.trim() == "")) {
            $.messager.popover({ msg: $g('��ע����Ϊ��'), type: 'error', timeout: 1000 });
            return
        }
        var edAdajust = $('#inputEmrNoteTable').datagrid('getEditor', { index: GV.editIndex, field: 'ifAdajust' })
        var ifAdajust = ($(edAdajust.target).prop("checked") ? 1 : 0)
        var responsibleED = $('#inputEmrNoteTable').datagrid('getEditor', { index: GV.editIndex, field: 'responsible' })
        var responsible = $(responsibleED.target).combobox("getValues")
        var responsible = responsible.join(",")
    } else {
        var selectedNoteRec = $('#inputEmrNoteTable').datagrid('getSelected')
        if (selectedNoteRec == null) {
            $.messager.popover({ msg: $g('��ѡ��һ����¼'), type: 'error', timeout: 1000 });
            return
        }
    }
    var auditMainNoteSelected = $('#inputEmrNoteTable').datagrid('getSelected')
    if (auditMainNoteSelected != null) {
        auditMainNoteID = auditMainNoteSelected['auditMainNoteSubID']
    }
    runClassMethod("Nur.Quality.Service.Audit", "auditMainNoteSubHandler",
        {
            parameter1: auditMainID,
            parameter2: auditMainNoteID,
            parameter3: content,
            parameter4: ifAdajust,
            parameter5: GV.currentUSERID,
            parameter6: action,
            parameter7: responsible
        },
        function (data) {
            if (data == "0") {
                $.messager.popover({ msg: $g('�����ɹ�'), type: 'success', timeout: 1000 });
                $('#inputEmrNoteTable').datagrid('reload');
            } else {
                $.messager.popover({ msg: $g('����ʧ��'), type: 'error', timeout: 1000 });
            }
        })
}


function clickBtnEvent(id) {
    switch (id) {
        case 'emrNotesBtn':
            //����������鵯���ϵı�ע��ť
            emrNotesBtn()
            break;
        case 'emrAppraiseBtn':
            //����������鵯���ϵ����۰�ť
            emrAppraiseBtn()
            break;
        case 'searchNoteBtn':
            //�����ע���ڵĲ�ѯ
            emrNoteSearchBtn()
            break;
    }
}
/**
* @description:����������鵯���ϵı�ע��ť
*/
function emrNotesBtn() {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('��ѡ��һ������'), type: 'error', timeout: 1000 });
        return
    }
    if (selectedNote.type == 'root') {
        $.messager.popover({ msg: $g('��ѡ����ģ�壡'), type: 'error', timeout: 1000 });
        return;
    }
    $('#inputEmtNoteStartDate').datebox('setValue', ""),
        $('#inputEmtNoteEndDate').datebox('setValue', ""),
        emrNoteSearchBtn()
    $('#showInputEmrNote').window('open')
}
/**
* @description: ����������鵯���ϵ����۰�ť
*/
function emrAppraiseBtn() {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('��ѡ��һ������'), type: 'error', timeout: 1000 });
        return
    }
    var auditMainID = selectedNote.auditMainID
    showEmrScoreDataList(auditMainID, "", "inputEmrScoreList")
    $('#showInputEmrScore').window('open')
}
/**
* @description: ��ȡ���ֱ���Ϣ
*/
function showEmrScoreDataList(auditMainID, appraiseID, divID) {
    runClassMethod("Nur.Quality.Service.Audit", "getCheckItems",
        {
            parameter1: auditMainID,
            parameter2: appraiseID,
            parameter3: $('#inputWardID').combobox('getValue')
        }, function (data) {
            if (data.appraiseInfo == undefined) {
                $.messager.popover({ msg: $g('û��ά��Ҫ���۵�ģ�壡'), type: 'error', timeout: 1000 });
                $('#showInputEmrScore').window('close')
                return
            }
            initEmrAppraiseHandler(data, appraiseID) //��ʼ������ �� ������ύ��ť
            showEmrScoreTable(data, divID)
        })
}
/** ���ݵõ������ֱ���Ϣ ��ʼ�� ������ύ��ť */
function initEmrAppraiseHandler(data, appraiseID) {
    var curStatus = data.appraiseInfo.status
    if (curStatus != "") {
        showHandlerBtn(curStatus)
        if (curStatus == $g("����")) {
            $('#saveAppraiseShowBtn').unbind()
            $('#saveAppraiseShowBtn').on('click', function () {
                saveAppraiseBtn(data, appraiseID, function () {
                    $('#appraiseListTable').datagrid('reload');
                    $('#appraiseListTable').datagrid('selectRecord', appraiseID);
                })
            })
            $('#submitAppraiseShowBtn').unbind()
            $('#submitAppraiseShowBtn').on('click', function () {
                appraiseStatusChangeBtn(appraiseID, "T", function () {
                    showEmrScoreDataList("", appraiseID, "showEmrScoreList")
                    $('#appraiseListTable').datagrid('reload');
                    $('#appraiseListTable').datagrid('selectRecord', appraiseID);
                })
            })
        } else if (curStatus == $g("�ύ")) {
            $('#cancelSubmitShowBtn').unbind()
            $('#cancelSubmitShowBtn').on('click', function () {
                appraiseStatusChangeBtn(appraiseID, "S", function () {
                    showEmrScoreDataList("", appraiseID, "showEmrScoreList")
                    $('#appraiseListTable').datagrid('reload');
                    $('#appraiseListTable').datagrid('selectRecord', appraiseID);
                })
            })
        }
    } else {
        $('#saveAppraiseBtn').unbind()
        //���۴��ڵİ�ť��ʼ�� ����
        $('#saveAppraiseBtn').on('click', function () {
            saveAppraiseBtn(data, appraiseID, function () {
                $('#showInputEmrScore').window('close')
                $('#appraiseListTable').datagrid('reload')
            })
        })
        $('#submitAppraiseBtn').unbind()
        //���۴��ڵİ�ť��ʼ�� �ύ
        $('#submitAppraiseBtn').on('click', function () {
        })
    }
}


function runClassMethodByApp(className, methodName, datas, successHandler, datatype, sync) {
    var _options = {
        url: buildMWTokenUrl("dhcnurqualitydata.csp"),
        async: true,
        dataType: "json", // text,html,script,json
        type: "POST",
        data: {
            'className': className,
            'methodName': methodName
        }
    };
    $.extend(_options.data, datas);
    var option = { dataType: typeof (datatype) == "undefined" ? "json" : datatype, async: typeof (sync) == "undefined" ? _options.async : sync };
    _options = $.extend(_options, option);
    return $.ajax(_options).done(successHandler).error(successHandler);
}



/**���۱����¼� */
function saveAppraiseBtn(data, appraiseID, callback) {
    var scoreData = data.scoreList
    for (var index in scoreData) {
        scoreData[index].realScore = $('#tr' + index + ' .pa4 input').val()
        scoreData[index].CheckItemRemark = $('#tr' + index + ' .br input').val()
    }
    data.scoreList = scoreData
    data.appraiseInfo['score'] = $('#appScore').val()

    runClassMethodByApp("Nur.Quality.Service.Audit", "appraiseHandler",
        {
            parameter1: appraiseID,
            parameter2: "insert",
            parameter3: "S",
            parameter4: GV.currentUSERID,
            parameter5: JSON.stringify(data),
            parameter6: appraiseID == "" ? $('#inputEmrAppRemarks').val() : $('#showEmrAppRemarks').val(),
            parameter7: GV.currentHOSPID
        }, function (data) {
            if (data == "0") {
                $.messager.popover({ msg: $g('�����ɹ�'), type: 'success', timeout: 1000 });
                $('#emrTree').tree("reload")
                callback()
            } else {
                $.messager.popover({ msg: data, type: 'error', timeout: 1000 });
            }
        })
    /*
    $cm({
       ClassName: 'Nur.Quality.Service.Audit',
       MethodName: 'appraiseHandler',
       ResultSetType: "text",
       ID: appraiseID,
       Action: "insert",
       Status: "S",
       UserID: GV.currentUSERID,
       JsonData: JSON.stringify(data),
       Remarks: appraiseID == "" ? $('#inputEmrAppRemarks').val() : $('#showEmrAppRemarks').val()
    }, function(data){
        if (data=="0")
        {
           $.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});
           $('#emrTree').tree("reload")
           callback()
        }else{
           $.messager.popover({msg: data,type:'error',timeout: 1000});
        }
    })
    */
}
/**�����ύ�����ύ�¼� */
function appraiseStatusChangeBtn(appraiseID, status, callback) {
    runClassMethod("Nur.Quality.Service.Audit", "appraiseHandler", {
        parameter1: appraiseID,
        parameter2: "changeStatus",
        parameter3: status,
        parameter4: GV.currentUSERID,
        parameter5: '',
        parameter6: ''
    }, function (data) {
        if (data == "0") {
            $.messager.popover({ msg: $g('�����ɹ�'), type: 'success', timeout: 1000 });
            $('#emrTree').tree("reload")
            callback()
        } else {
            $.messager.popover({ msg: data, type: 'error', timeout: 1000 });
        }
    })
}
/**��Ⱦ���ֱ� */
function showEmrScoreTable(data, divID) {
    var appraiseInfo = data.appraiseInfo
    $('#showEmrAppRemarks').val(appraiseInfo.remarks)
    $('#inputEmrAppRemarks').val(appraiseInfo.remarks)
    var html = '<div style="width: 90%; margin: 0px auto;">' +
        '<div style="margin: 0 auto 10px; text-align: center; font-size: 22px; font-weight: bold;">' + $g(appraiseInfo.title) + '</div>' +
        '<div style="margin: 10px 0px;">' +
        $g("����") + '<input value="' + appraiseInfo.patName + '" class="textbox" name="patName" disabled="true" style="width:120px;height:26px;margin:0 12px 0 10px;" >' +
        '&nbsp&nbsp' + $g("�ǼǺ�") + '<input value="' + appraiseInfo.regNo + '" class="textbox" name="RegNo" disabled="true" style="width:120px;height:26px;margin:0 12px 0 10px;" >' +
        '&nbsp&nbsp' + $g("��������") + '<input value="' + appraiseInfo.appDateTime + '" class="textbox" name="apoDateTime" disabled="true" style="width:140px;height:26px;margin:0 12px 0 10px;" >' +
        '&nbsp&nbsp' + $g("�ɼ�") + '<input id="appScore" value="' + appraiseInfo.score + '" class="textbox" name="appScore" disabled="true" style="width:50px;height:26px;margin:0 12px 0 10px;" >' +
        '&nbsp&nbsp' + $g("״̬") + '<input value="' + $g(appraiseInfo.status) + '" class="textbox" name="appStatus" disabled="true" style="width:50px;height:26px;margin-left:10px;" >' +
        '</div>' +
        '<div style="overflow:hidden">' +
        '<table id="scoredata" border="0" cellspacing="0" cellpadding="0" style="width: 100%;">' +
        '<thead>' +
        '<tr>' +
        '<th width="130" >' + $g("һ��ָ��") + '</th> ' +
        '<th >' + $g("����ָ��") + '</th> ' +
        '<th width="50" >' + $g("�ܷ�") + '</th>' +
        '<th width="50" >' + $g("�÷�") + '</th> ' +
        '<th width="140" class="noteTh" >' + $g("��ע") + '</th>' +
        '</tr>' +
        '</thead>' +
        '<tbody>'
    for (var index in data.scoreList) {
        var item = data.scoreList[index]
        var trHtml = '<tr id="tr' + index + '">' +
            (item['oneIsShow'] == "1" ? '<td class="pl4" width="100" rowspan="' + item['oneColSpan'] + '">' + item['oneModelDesc'] + '</td>' : '') +
            '<td >' + item['twoModelDesc'] + '</td>' +
            '<td class="pl4" >' + item['Score'] + '</td>' +
            '<td class="pa4" align="center" width="50" >' +
            '<input id="score' + index + '" max="' + item['Score'] + '"  value="' + item['realScore'] + '">' +
            '</td>' +
            '<td class="br" width="140" >' +
            '<input value="' + item['CheckItemRemark'] + '" >' +
            '</td>' +
            '</tr>'
        html = html + trHtml
    }
    html = html + '</tbody>' + '</table>' + '</div>' + '</div>' + '</div>'

    $('#' + divID).html(html)

    for (var scoreIndex in data.scoreList) {
        $('#score' + scoreIndex).on('change', function (event) {
            var scoreObj = $(event.target)
            if (new RegExp(/(^[\-0-9][0-9]*(.[0-9]+)?)$/).test(scoreObj.val())) {
                var num = parseFloat(scoreObj.val())
                var maxNum = parseFloat(scoreObj.attr('max'))
                if ((num < 0) || (num > maxNum)) {
                    scoreObj.val(maxNum)
                }
            } else {
                scoreObj.val(0)
            }
            countScore(data.scoreList.length)
        })
    }
    //inputEmrScoreList
}
/**
* @description: �����ע���ڵĲ�ѯ
*/
function emrNoteSearchBtn() {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('��ѡ��һ������'), type: 'error', timeout: 1000 });
        return
    }
    var auditMainID = selectedNote.auditMainID
    var queryParams = $('#inputEmrNoteTable').datagrid('options').queryParams;
    queryParams.AuditMainID = auditMainID,
        queryParams.StartDate = $('#inputEmtNoteStartDate').datebox('getValue'),
        queryParams.EndDate = $('#inputEmtNoteEndDate').datebox('getValue'),
        $('#inputEmrNoteTable').datagrid('options').queryParams = queryParams;
    $('#inputEmrNoteTable').datagrid('load');
    changeNurseList(auditMainID)
}


/**
* @description: �ı������˻�ʿ�б�
*/
function changeNurseList(auditMainID) {
    GV.nurseList = $cm({
        ClassName: "Nur.Quality.Service.Audit",
        MethodName: "getNurseList",
        auditMainID: auditMainID
    }, false)
    var columns = $("#inputEmrNoteTable").datagrid("getColumnOption", "responsible")
    columns.editor.options.data = GV.nurseList
    /*
     var editor=$("#inputEmrNoteTable").datagrid("getEditor",{field:'responsible'})
     $(editor.target).combobox('loadData',GV.nurseList)
     $(editor.target).combobox('clear')
     */

}
/***************************************************** */


/**ͼ��չʾ */
function showImg(value, row, index) {
    return "<a onclick='showEmrAuditDetails(" + row['auditMainID'] + "," + row['episodeID'] + ")'  class='icon icon-paper' href='javascript:;'></a>"
}
/**��������չʾ */
function showRecDesc(data) {
    var data = $.parseJSON(data)
    var html = '<div class="showEmrList"><ul>'
    for (var index in data) {
        var desc = data[index].recDesc
        html += '<li  style="cursor:pointer;overflow:hidden;color:blue" onclick="clickRecDesc(' + data[index].episodeID + ',' + data[index].auditMainID + ')" value="' + data[index].auditMainID + '">' + (desc.indexOf("<") > -1 ? ($g(desc.split("<span")[0]) + "<span" + desc.split("<span")[1]) : $g(desc)) + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**���۽��չʾ */
function showEvalution(data) {
    var data = $.parseJSON(data)
    var html = '<div class="showEmrList"><ul>'
    for (var index in data) {
        html += '<li style="height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px;line-height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px" >' + data[index].score + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**������ʾ */
function showGrade(data) {
    var data = $.parseJSON(data)
    var html = '<div class="showEmrList"><ul>'
    for (var index in data) {
        html += '<li style="height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px;line-height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px" >' + data[index].grade + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**״̬���ȫ�� */
function allCheckBoxClick(flag) {
    for (var item in GV.statusList) {
        if (item != "all") {
            $HUI.checkbox('#' + item).setValue(flag)
        }
    }
}
/**����״̬�������ȫ�� */
function otherBoxClick(flag) {
    var ifAllChecked = true
    for (var item in GV.statusList) {
        if (item != "all") {
            if (!$HUI.checkbox('#' + item).getValue()) {
                ifAllChecked = false
            }
        }
    }
    if (ifAllChecked) {
        $HUI.checkbox('#all').setValue(true)
    } else {
        $HUI.checkbox('#all').setValue(false)
    }
}
function getAllChecked() {
    var checkedList = []
    for (var item in GV.statusList) {
        if (item != "all") {
            if ($HUI.checkbox('#' + item).getValue()) {
                checkedList.push(item)
            }
        }
    }
    return checkedList.join(",")
}
function countScore(length) {
    var allScore = 0
    for (var i = 0; i < length; i++) {
        allScore = floatObj.add(allScore, parseFloat($('#score' + i).val()))
        //allScore += parseFloat($('#score' + i ).val())
    }
    $('#appScore').val(allScore)
}
function serilizeURL(url) {
    var rs = url.split("?")[1];
    var arr = rs.split("&");
    var json = {};
    json["csp"] = url.split("?")[0];
    for (var i = 0; i < arr.length; i++) {
        if (arr[i].indexOf("=") != -1) {
            json[arr[i].split("=")[0]] = arr[i].split("=")[1];
        }
        else {
            json[arr[i]] = "undefined";
        }
    }
    return json;
}
function onLoadSuccess(data) {
    var merges = [{
        index: 2,
        rowspan: 3
    }, {
        index: 5,
        rowspan: 2
    }, {
        index: 7,
        rowspan: 2
    }, {
        index: 122,
        rowspan: 3
    }];
    /*
        $(this).datagrid('mergeCells',{
            index: merges[i].index,
            field: 'ck',
            rowspan: merges[i].rowspan
        });
    */
}
function showHandlerBtn(status) {
    if (status == $g("�ύ")) {
        $('#saveAppraiseShowBtn').css("display", "none")
        $('#submitAppraiseShowBtn').css("display", "none")
        $('#cancelSubmitShowBtn').css("display", "")

    } else if (status == $g("����")) {
        $('#saveAppraiseShowBtn').css("display", "")
        //$('#submitAppraiseShowBtn').css("display", "")
        $('#cancelSubmitShowBtn').css("display", "none")
    }
}

function hiddenBtnAndNotes() {
    $('#saveAppraiseShowBtn').css("display", "none")
    $('#submitAppraiseShowBtn').css("display", "none")
    $('#cancelSubmitShowBtn').css("display", "none")
    $('#showEmrAppRemarks').val("")
}

var tableToExcel = (function () {
    var uri = 'data:application/vnd.ms-excel;base64,',
        template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><?xml version="1.0" encoding="UTF-8" standalone="yes"?><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) },
        format = function (s, c) {
            return s.replace(/{(\w+)}/g,
                function (m, p) { return c[p]; })
        }
    return function (table, name) {
        if (!table.nodeType) table = document.getElementById(table)
        var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
        window.location.href = uri + base64(format(template, ctx))
    }
})()


function setEprMenuForm(adm, papmi, mradm, canGiveBirth) {
    var frm = dhcsys_getmenuform();
    if ((frm) && (frm.EpisodeID.value != adm)) {
        frm.EpisodeID.value = adm;
        frm.PatientID.value = papmi;
        frm.mradm.value = mradm;
    }
}

/**
 * @description: token���췽��
 * @return {bool} true/false
 */
function buildMWTokenUrl(url){
	if (typeof websys_getMWToken != 'undefined'){
		if (url.indexOf('?') == -1){
			url = url + '?MWToken=' + websys_getMWToken();
		} else {
			url = url + "&MWToken=" + websys_getMWToken();
		}
	}
	return url;
}