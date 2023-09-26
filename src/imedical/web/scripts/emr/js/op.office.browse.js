
$(function () {
    $('#patLst').panel('resize', {
        width: (screen.availWidth) * 0.382
    });
    $('body').layout('resize');

    $('.easyui-searchbox').searchbox({
        searcher: function (value, name) {
            var regNo = $("#regNoSearch").searchbox('getValue');
            var medNo = $("#medNoSearch").searchbox('getValue');
            var name = $("#nameSearch").searchbox('getValue');
            var cardNo = $("#cardNoSearch").searchbox('getValue');
            setQuery(regNo, medNo ,name, cardNo);
        },
        prompt: '请输入'
    });
    //$('#cardNoSearch').searchbox('textbox').focus();
    $('#readCard').live('click', function () {
        debugger;
        $('#cardNoSearch').searchbox('textbox').focus();
        //调用读卡接口获取患者信息,入参为设备类型
        //var rtn = DHCACC_ReadMagCard("2");
        //var rtn = DHCACC_GetAccInfo("2","");
        var cardTypeDR = "2";
        var cardTypeOpt = "2^PUMCH^就诊卡^C^N^^5^Y^Y^61091^^IE^N^ReadCard^2^^Read^0^Y^N^Name^N^CardNo^Y^CL^UDHCCardInvPrt^DHCOutMedicalHome^Y^PC^^CQU^Y^Y^Y^^";
        var rtn = DHCACC_GetAccInfo(cardTypeDR,cardTypeOpt);
        var myary=rtn.split("^");
        //alert("rtn:" + rtn);
        
        if ("0" == myary[0]) {
            var cardNo = myary[1];
            var cardTypeID = myary[8];
        
            setQuery('','','',cardNo);
            
        } else {
            setSearchOptions("","","","");
        }
        
    });
    
    $('#btnScan').live('click', function () {
        $('#regNoSearch').searchbox('textbox').focus();
        
        var NoInfo2 = DHCACC_Scan("regNoSearch","","");
        var NoInfo = NoInfo2.split("^");
        if ("0" == NoInfo[0]) {
            
            var regNo = NoInfo[5];
            
            setQuery(regNo,'','','');
            
        }else {
            setSearchOptions("","","","");
        }
    });
    
    $('#printListSeek').live('click', function () {
        var regNo = $("#regNoSearch").searchbox('getValue');
        var medNo = $("#medNoSearch").searchbox('getValue');
        var name = $("#nameSearch").searchbox('getValue');
        var cardNo = $("#cardNoSearch").searchbox('getValue');
        setQuery(regNo, medNo ,name, cardNo);
    });
    
    $('#reset').live('click', function () {
        reset();
        $('#patientListData').datagrid('loadData', {total:0,rows:[]});
    });
    
    
    initPatTable();
    
    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;
    
    //todo
    data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetBrowsePatList','','','','');
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientListData').datagrid('loadData', patData);
        }else {
            $('#patientListData').datagrid('loadData', {total:0,rows:[]});
        }
    
    }, function (err) {
        alert('GetBrowsePatList error:' + err);
    });
});

// 更新病历页面内容
function switchEMRContentaudit(_patientID, _episodeID, _mradm, _episodeLocID, _admType) {
    if (_episodeID == patInfo.EpisodeID)
        return;
    var url = "emr.record.browse.browseform.csp?PatientID="+_patientID+"&EpisodeID="+_episodeID+"&EpisodeLocID="+_episodeLocID+"&AdmType="+_admType;
    $('#editorFrame').attr('src', url);

    //全局参数替换
    patInfo.PatientID = _patientID;
    patInfo.EpisodeID = _episodeID;
    patInfo.MRadm = _mradm;

}

function initPatTable() {
    $('#patientListData').datagrid({
        width: '100%',
        height: 106,
        //pageSize:20,
        //pageList:[10,20,30,50,80,100],
        //fitColumns: true,
        striped: true,
        loadMsg: '数据装载中......',
        //autoSizeColumn: true,
        autoRowHeight: true,
        singleSelect: true,
        idField: 'EpisodeID',
        rownumbers: true,
        fit: true,
        remoteSort: false,
        columns: [
            [{
                field: 'PatientID',
                title: 'PatientID',
                width: 80,
                hidden: true
            }, {
                field: 'EpisodeID',
                title: 'EpisodeID',
                width: 80,
                hidden: true
            }, {
                field: 'AdmType',
                title: 'AdmType',
                width: 80,
                hidden: true
            }, {
                field: 'mradm',
                title: 'mradm',
                width: 80,
                hidden: true
            }, {
                field: 'HasComplete',
                title: '知情同意书',
                width: 70,
                sortable: true
            }, {
                field: 'PAPMIName',
                title: '姓名',
                width: 60,
                sortable: true
            }, {
                field: 'PAPMISex',
                title: '性别',
                width: 40,
                sortable: true
            }, {
                field: 'PAPMIAge',
                title: '年龄',
                width: 40,
                sortable: true
            }, {
                field: 'PAAdmDate',
                title: '就诊日期',
                width: 80,
                sortable: true
            }, {
                field: 'PAAdmTime',
                title: '就诊时间',
                width: 80,
                sortable: true
            }, {
                field: 'PAAdmLoc',
                title: '就诊科室',
                width: 120,
                sortable: true
            }, {
                field: 'PAAdmDoc',
                title: '就诊医师',
                width: 80,
                sortable: true
            }, {
                field: 'Diagnosis',
                title: '门诊诊断',
                width: 500,
                sortable: true
            }]
        ],
        rowStyler: function (index, row) {
            if (row.HasComplete == "已签") {
                return 'background-color:#A4D3EE;color:red;';
            }
        },
        onDblClickRow: function () {
            //alert('onDblClickRow');
            var seleRow = $('#patientListData').datagrid('getSelected');
            if (seleRow) {
                switchEMRContentaudit(seleRow.PatientID, seleRow.EpisodeID, seleRow.mradm, seleRow.PAAdmLoc, seleRow.AdmType);
            }
        }
    });
}

//查询条件
function setSearchOptions(regNo, medNo, name, cardNo){
    
    var patStatus = "";
    
    var data = ajaxDATA('Stream', 'EMRservice.BL.opPrintSearch', 'GetOPPatInfo', regNo, medNo, name, "", cardNo);
    ajaxPOSTSync(data, function (ret) {
        if (('' != ret)&&('[]' != ret)) {
            
            if ($.parseJSON(ret).total > 1) {
                
                var returnValues = window.showModalDialog('emr.op.choosepatient.csp', $.parseJSON(ret), 'dialogHeight:550px;dialogWidth:550px;resizable:no;status:no');    
                
                if (returnValues == "cancel") {
                    patStatus = "未选择患者";
                } else {
                    var patInfoData = returnValues;
                    $("#regNoSearch").searchbox('setValue', patInfoData.RegNo);
                    $("#medNoSearch").searchbox('setValue', patInfoData.MedNo);
                    $("#nameSearch").searchbox('setValue', patInfoData.PatName);
                    $("#cardNoSearch").searchbox('setValue', patInfoData.CardNo);
                }

            }
            else if ($.parseJSON(ret).total == 1) {
                var patInfoData = $.parseJSON(ret).rows[0];
                $("#regNoSearch").searchbox('setValue', patInfoData.RegNo);
                $("#medNoSearch").searchbox('setValue', patInfoData.MedNo);
                $("#nameSearch").searchbox('setValue', patInfoData.PatName);
                $("#cardNoSearch").searchbox('setValue', patInfoData.CardNo);	
            }

        }else {
            patStatus = "未找到指定患者";
            if ("" === regNo) $("#regNoSearch").searchbox('setValue', '');
            if ("" === medNo) $("#medNoSearch").searchbox('setValue', '');
            if ("" === name) $("#nameSearch").searchbox('setValue', '');
            if ("" === cardNo) $("#cardNoSearch").searchbox('setValue', '');
        }
    }, function (err) {
        alert('GetOPPatInfo error:' + err);
    });
    
    return patStatus;
}

//清空输入查询条件
function reset() {
    $("#regNoSearch").searchbox('setValue', '');
    $("#medNoSearch").searchbox('setValue', '');
    $("#nameSearch").searchbox('setValue', '');
    $("#cardNoSearch").searchbox('setValue', '');
}

//查询操作调用
function setQuery(regNo, medNo ,name, cardNo){
    
    var patStatus = setSearchOptions(regNo, medNo, name, cardNo);
    
     if (patStatus != "") {
        if (patStatus == "未选择患者") {
            return;
        } else {
            alert(patStatus);
        }
        return;
    }
    
    var tregNo = $("#regNoSearch").searchbox('getValue');
    var tmedNo = $("#medNoSearch").searchbox('getValue');
    var tname = $("#nameSearch").searchbox('getValue');
    var tcardNo = $("#cardNoSearch").searchbox('getValue');
    
    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetBrowsePatList', tregNo, tmedNo, tname, tcardNo);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientListData').datagrid('loadData', patData);
        }else {
            $('#patientListData').datagrid('loadData', {total:0,rows:[]});
        }
    }, function (err) {
        alert('GetBrowsePatList error:' + err);
    });
}
