/**
 * 模块:		门诊药房
 * 子模块:		门诊药房-处方审核
 * createdate:	2016-08-04
 * creator:		yunhaibao
 * others:		全局变量最好存在对象中,比如 "OA"
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.URL.THIS_URL = ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
DHCPHA_CONSTANT.DEFAULT.APPTYPE = "OA";

var str=tkMakeServerCall("web.DHCOutPhCommon", "GetPassProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var strArr=str.split("^");
DHCPHA_CONSTANT.DEFAULT.PASS =strArr[0];
var RePassNeedCancle=strArr[1];
var PatientInfo = {
    adm: 0,
    patientID: 0,
    episodeID: 0,
    admType: "I",
    prescno: 0,
    orditem: 0,
    zcyflag: 0
};
$(function () {
    CheckPermission();
    /* 初始化插件 start*/
    var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
    
    InitPhaLoc();

    InitPrescModalTab();
    InitGridPresc();
    InitGirdPrescDetail();
    /* 初始化插件 end*/
    /* 表单元素事件 start*/
    //登记号回车事件
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryGridPresc();
            }
        }
    });
    //卡号回车事件
    $('#txt-cardno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardno = $.trim($("#txt-cardno").val());
            if (cardno != "") {
                BtnReadCardHandler();
            }
        }
    });
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* 表单元素事件 end*/

    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", QueryGridPresc);
    $("#btn-prepresc").on("click", ViewPrescAddInfo);
    $("#btn-viewlog").on("click", ViewPrescMonitorLog);
    $("#btn-pass").on("click", PassPresc);
    $("#btn-refuse").on("click", RefusePresc);
    $("#btn-analysis").on("click", PrescAnalyse) //处方分析
    $("#btn-readcard").on("click", BtnReadCardHandler); //读卡
    /* 绑定按钮事件 end*/
    ;
})
window.onload = function () {
    if (LoadPatNo != "") {
        $('#txt-patno').val(LoadPatNo);
    }
    QueryGridPresc();
}

//初始化table
function InitGridPresc() {
    var columns = [{
            header: '合理用药',
            index: 'druguse',
            name: 'druguse',
            width: 50,
            formatter: druguseFormatter
        },
        {
            header: '注意项目',
            index: 'warningmsg',
            name: 'warningmsg',
            width: 50
        },
        {
            header: '结果',
            index: 'result',
            name: 'result',
            width: 50,
            cellattr: addPassStatCellAttr
        },
        {
            header: '登记号',
            index: 'patid',
            name: 'patid',
            width: 150
        },
        {
            header: '姓名',
            index: 'patname',
            name: 'patname',
            width: 100
        },
        {
            header: '性别',
            index: 'patsex',
            name: 'patsex',
            width: 40
        },
        {
            header: '年龄',
            index: 'patage',
            name: 'patage',
            width: 40
        },
        {
            header: '身高',
            index: 'path',
            name: 'path',
            width: 50
        },
        {
            header: '体重',
            index: 'patw',
            name: 'patw',
            width: 50
        },
        {
            header: '费别',
            index: 'billtype',
            name: 'billtype',
            width: 100
        },
        {
            header: '处方号',
            index: 'prescno',
            name: 'prescno',
            width: 125
        },
        {
            header: '诊断',
            index: 'diag',
            name: 'diag',
            width: 200,
            align: 'left'
        },
        {
            header: 'adm',
            index: 'adm',
            name: 'adm',
            width: 200,
            hidden: true
        },
        {
            header: 'papmi',
            index: 'papmi',
            name: 'papmi',
            width: 200,
            hidden: true
        },
        {
            header: 'orditem',
            index: 'orditem',
            name: 'orditem',
            width: 200,
            hidden: true
        },
        {
            header: 'zcyflag',
            index: 'zcyflag',
            name: 'zcyflag',
            width: 200,
            hidden: true
        },
        {
            header: 'dspstatus',
            index: 'dspstatus',
            name: 'dspstatus',
            width: 200,
            hidden: true
        },
        {
            header: '分析结果',
            index: 'druguseresult',
            name: 'druguseresult',
            width: 100,
            hidden: true
        },
        {
            header: '控制等级',
            index: 'manLevel',
            name: 'manLevel',
            width: 100,
            hidden: true
        },
        {
            header: '分析结果',
            index: 'analyseResult',
            name: 'analyseResult',
            width: 100,
            hidden: true
        }
    ];
    var input = GetQueryParams();
    var jqOptions = {
        colModel: columns, //列
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetAdmPrescList&style=jqGrid&input=' + input, //查询后台	
        height: DhcphaJqGridHeight(2, 3) * 0.5,
        multiselect: true,
        datatype: "local",
        //shrinkToFit:false,
        pager: "#jqGridPager", //分页控件的id  
        onSelectRow: function (id, status) {
            var prescno = "";
            var audit = false;
            var id = $(this).jqGrid('getGridParam', 'selrow');
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                prescno = selrowdata.prescno;
                if ($("#chk-audit").is(':checked')) {
                    audit = true;
                }
                var params = audit;
            }
            $("#grid-prescdetail").setGridParam({
                page: 1,
                datatype: 'json',
                postData: {
                    'PrescNo': prescno,
                    'Input': audit
                }
            }).trigger("reloadGrid");
            PatientInfo.adm = selrowdata.adm;
            PatientInfo.prescno = selrowdata.prescno;
            PatientInfo.zcyflag = selrowdata.zcyflag;
            PatientInfo.patientID = selrowdata.papmi;
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-prescdetail").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        onCellSelect: function (rowIndex, iCol, cellcontent, e) {
            var field = $(this).jqGrid('getGridParam', 'colModel')[iCol].index;
            if (field != "druguse") {
                return
            }
            var content = $(this).jqGrid('getRowData', rowIndex).druguseresult;
            DHCSTPHCMPASS.AnalysisTips({
                Content: content
            })
        }
    };
    $('#grid-presc').dhcphaJqGrid(jqOptions);
}
//初始化明细table
function InitGirdPrescDetail() {
    //var prescdetailWidth=$(".div_content").width();
    var columns = [{
            header: '状态',
            index: 'ordstat',
            name: 'ordstat',
            width: 100,
            cellattr: addStatCellAttr
        },
        {
            header: '药品名称',
            index: 'incidesc',
            name: 'incidesc',
            width: 200,
            align: 'left',
            formatter: function (cellvalue, options, rowObject) {
                if (DHCPHA_CONSTANT.DEFAULT.PASS != "") {
                    return "<a onclick=\"DrugTips()\" style='text-decoration:underline;cursor:pointer;'>" + cellvalue + "</a>";
                } else {
                    return cellvalue;
                }  
            }
        },
        {
            header: '数量',
            index: 'qty',
            name: 'qty',
            width: 40
        },
        {
            header: '单位',
            index: 'uomdesc',
            name: 'uomdesc',
            width: 60
        },
        {
            header: '剂量',
            index: 'dosage',
            name: 'dosage',
            width: 60
        },
        {
            header: '频次',
            index: 'freq',
            name: 'freq',
            width: 60
        },
        {
            header: '规格',
            index: 'spec',
            name: 'spec',
            width: 80,
            hidden: true
        },
        {
            header: '用法',
            index: 'instruc',
            name: 'instruc',
            width: 80
        },
        {
            header: '用药疗程',
            index: 'dura',
            name: 'dura',
            width: 80
        },
        {
            header: '实用疗程',
            index: 'realdura',
            name: 'realdura',
            width: 80,
            hidden: true
        },
        {
            header: '剂型',
            index: 'form',
            name: 'form',
            width: 80
        },
        {
            header: '基本药物',
            index: 'basflag',
            name: 'basflag',
            width: 80
        },
        {
            header: '医生',
            index: 'doctor',
            name: 'doctor',
            width: 60
        },
        {
            header: '医嘱开单日期',
            index: 'orddate',
            name: 'orddate',
            width: 120
        },
        {
            header: '医嘱备注',
            index: 'remark',
            name: 'remark',
            width: 70,
            align: 'left'
        },
        {
            header: '厂商',
            index: 'manf',
            name: 'manf',
            width: 150,
            align: 'left',
            hidden: true
        },
        {
            header: 'orditm',
            index: 'orditm',
            name: 'orditm',
            width: 150,
            hidden: true
        }


    ];
    var jqOptions = {
        colModel: columns, //列
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=FindOrdDetailData&style=jqGrid',
        height: DhcphaJqGridHeight(2, 3) * 0.5,
        shrinkToFit: true,
        datatype: "local"

    };
    $('#grid-prescdetail').dhcphaJqGrid(jqOptions);
}

function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}
//查询未审核处方
function QueryGridPresc() {
    var params = GetQueryParams();
    $("#grid-presc").setGridParam({
        page: 1,
        datatype: 'json',
        postData: {
            'input': params
        }
    }).trigger("reloadGrid");
    return true
}

function GetQueryParams() {
    var phaloc = $("#sel-phaloc").val();
    var stdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    daterange=stdate+" - "+enddate
    
    var audit = false;
    if ($("#chk-audit").is(':checked')) {
        audit = true;
    }
    var patno = $("#txt-patno").val();
    var params = daterange + "^" + phaloc + "^" + patno + "^" + audit;
    return params;
}
//处方审核扩展信息modal
function ViewPrescAddInfo() {
    var grid_records = $("#grid-presc").getGridParam('records');
    if (grid_records == 0) {
        dhcphaMsgBox.alert("当前界面无数据!");
        return;
    }
    var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
    if (selectid == null) {
        dhcphaMsgBox.alert("请先选中需要查看的处方记录!");
        return;
    }
    //$("#modal-prescinfo").find(".modal-dialog").css({height:"200px"});
    $("#modal-prescinfo").modal('show');
}
//查看日志
function ViewPrescMonitorLog() {
    var grid_records = $("#grid-presc").getGridParam('records');
    if (grid_records == 0) {
        dhcphaMsgBox.alert("当前界面无数据!");
        return;
    }
    var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
    if (selectid == null) {
        dhcphaMsgBox.alert("请先选中需要查看的处方记录!");
        return;
    }
    var selectdata = $('#grid-presc').jqGrid('getRowData', selectid);
    var orditm = selectdata.orditem;
    var logoptions = {
        id: "#modal-monitorlog",
        orditm: orditm,
        fromgrid: "#grid-presc",
        fromgridselid: selectid
    };
    InitOutMonitorLogBody(logoptions);
}
//注册modaltab事件
function InitPrescModalTab() {
    $("#ul-monitoraddinfo a").on('click', function () {
        var adm = PatientInfo.adm;
        var prescno = PatientInfo.prescno;
        var zcyflag = PatientInfo.zcyflag;
        var patientID = PatientInfo.patientID;
        var tabId = $(this).attr("id")
        if (tabId == "tab-allergy") {
            $('iframe').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + "&IsOnlyShowPAList=Y"));
        }
        if (tabId == "tab-risquery") {
            $('iframe').attr('src', ChangeCspPathToAll('dhcapp.inspectrs.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm));
        }
        if (tabId == "tab-libquery") {
            $('iframe').attr('src', ChangeCspPathToAll('dhcapp.seepatlis.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1'));
        }
        if (tabId == "tab-eprquery") {
            $('iframe').attr('src', ChangeCspPathToAll('emr.interface.browse.episode.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + session['LOGON.CTLOCID']));
        }
        if (tabId == "tab-orderquery") {
            $('iframe').attr('src', ChangeCspPathToAll('oeorder.opbillinfo.csp' + '?EpisodeID=' + adm));
        }
        if (tabId == "tab-viewpresc") {
            var phartype = "DHCOUTPHA";
            var paramsstr = phartype + "^" + prescno + "^" + DHCPHA_CONSTANT.DEFAULT.CYFLAG;
            $("iframe").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
        }
    })

    $('#modal-prescinfo').on('show.bs.modal', function () {
        $("#modal-prescinfo .modal-dialog").width($(window).width() * 0.9);
        //$("#modal-prescinfo .modal-body").height($(window).height()*0.9);
        //$("#modal-prescinfo .modal-body").height($(window).height()*0.85);
        //var tmpiframeheight=$(window).height()*0.85
        //					-$("#modal-prescinfo .modal-header").height()
        //					-$("#modal-prescinfo #ul-monitoraddinfo").height()
        //					-40;
        $("#ifrm-outmonitor").height($(window).height() * 0.9 - 140)
        $('iframe').attr('src', "dhcpha.comment.queryorditemds.csp?EpisodeID=" + PatientInfo.adm);
        var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
        var selectdata = $('#grid-presc').jqGrid('getRowData', selectid);
        var patoptions = {
            id: "#dhcpha-patinfo",
            orditem: selectdata.orditem
        };
        AppendPatientOrdInfo(patoptions);
        var tabId = $(this).attr("id");
        if (tabId != "tab-viewpresc") {
            $("#tab-viewpresc").click()
        }
    })
    $("#modal-prescinfo").on("hidden.bs.modal", function () {
        //$(this).removeData("bs.modal");
    });
    $("#tab-beforeindrug").hide();
}
//审核通过
function PassPresc() {
    var selectids = $("#grid-presc").jqGrid('getGridParam', 'selarrrow');
    if (selectids == "") {
        dhcphaMsgBox.alert("请先选中需要审核的记录");
        return;
    }
    var canpass = 0;
    canpassi = 0;
    var i = 0;
    $.each(selectids, function () {
        var rowdata = $('#grid-presc').jqGrid('getRowData', this);
        var rowresult = rowdata.result;
        var manLevel = rowdata.manLevel;
        var analyseResult= rowdata.analyseResult;
        canpassi = canpassi + 1;
        if (rowresult == "通过") {
            canpass = "1"
            return false; //false 退出循环
        } else if (rowresult.indexOf("拒绝") != "-1") {
            canpass = "2"
            return false; //false 退出循环
        }
        if ((analyseResult!="0")&&(manLevel == "C")) {
            canpass = "3"
            return false; //false 退出循环
        }
    })
    if(RePassNeedCancle=="Y"){
	    if (canpass == 1) {
	        dhcphaMsgBox.alert("您选择的第" + canpassi + "条已通过,不能再次审核通过 !");
	        return;
	    } else if (canpass == 2) {
	        dhcphaMsgBox.alert("您选择的第" + canpassi + "条已拒绝,不能直接审核通过 !");
	        return;
	    } 
    }
    if(canpass == 3) {
        dhcphaMsgBox.alert("您选择的第" + canpassi + "条不合理并且控制等级为管制,不能直接审核通过 !");
        return;
    }
    var orditem = "";
    var ret = "Y";
    var reasondr = "";
    var advicetxt = "";
    var factxt = "";
    var phnote = "";
    var guser = session['LOGON.USERID'];
    var ggroup = session['LOGON.GROUPID'];
    var i = 0;
    $.each(selectids, function () {
        var rowdata = $('#grid-presc').jqGrid('getRowData', this);
        var orditem = rowdata.orditem;
        var input = ret + "^" + guser + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + ggroup + "^" + orditem;
        var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
        SaveCommontResult(reasondr, input)
    })

}
//审核拒绝
function RefusePresc() {
    var grid_records = $("#grid-prescdetail").getGridParam('records');
    if (grid_records == 0) {
        dhcphaMsgBox.alert("处方无明细数据!");
        return;
    }
    var firstrowdata = $("#grid-prescdetail").jqGrid("getRowData", 1); //获取第一行数据
    var orditm = firstrowdata.orditm;
    if (orditm == "") {
        dhcphaMsgBox.alert("医嘱数据为空!");
        return;
    }
    var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
    if (selectid == "") {
        dhcphaMsgBox.alert("请先选择需要拒绝的记录!");
        return;
    }
    var selectdata = $('#grid-presc').jqGrid('getRowData', selectid);
    var dspstatus = selectdata.dspstatus;
    if (dspstatus.indexOf("已") >= 0) {
        dhcphaMsgBox.alert("您选择的记录状态为:" + dspstatus + ",无法拒绝!");
        return;
    }
    var oaresult = selectdata.result;
    if(RePassNeedCancle=="Y"){
	    if (oaresult.indexOf("拒绝") != "-1") {
	        dhcphaMsgBox.alert("您选择的记录已经拒绝!");
	        return;
	    }
	    if (oaresult == "通过") {
	        dhcphaMsgBox.alert("您选择的记录已经通过!");
	        return;
	    }
    }
    var prescNo=selectdata.prescno;
    var waycode = OutPhaWay;
    ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescNo,
		selType:"PRESCNO"
	},SaveCommontResultEX,{orditm:orditm}); 
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var User = session['LOGON.USERID'];
    var grpdr = session['LOGON.GROUPID'];
    var input = ret + "^" + User + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + grpdr + "^" + origOpts.orditm;
    var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
    SaveCommontResult(reasondr, input);
}
//审核通过/拒绝
function SaveCommontResult(reasondr, input) {
    $.ajax({
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveOPAuditResult&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
        type: 'post',
        success: function (data) {
            var retjson = JSON.parse(data);
            if (retjson.retvalue == 0) {
                QueryGridPresc();
                if (top && top.HideExecMsgWin) {
                    top.HideExecMsgWin();
                }
            } else {
                dhcphaMsgBox.alert(retjson.retinfo);
                return
            }
        },
        error: function () {}
    })
}
//处方分析
function PrescAnalyse() {
    var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
    if (passType == "") {
        dhcphaMsgBox.alert("未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商");
        return;
    }
    if (passType == "DHC") {
        // 东华知识库
        DHCSTPHCMPASS.PassAnalysis({
            GridId: "grid-presc",
            MOeori: "orditem",
            PrescNo: "prescno",
            GridType: "JqGrid",
            Field: "druguse",
            valField:"analyseResult",
            ResultField: "druguseresult",
            ManLevel: "manLevel" //add by MaYuqiang
        });
    } else if (passType == "DT") {
        // 大通
        // StartDaTongDll(); 
        // DaTongPrescAnalyse();  
    } else if (passType == "MK") {
        // 美康
        //MKPrescAnalyse(); 
    } else if (passType == "YY") {}
}

function GridOrdItemCellTip() {}
//权限验证
function CheckPermission() {
    $.ajax({
        url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
            '&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
            '&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
            '&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
        type: 'post',
        success: function (data) {
            var retjson = JSON.parse(data);
            var retdata = retjson[0];
            var permissionmsg = "",
                permissioninfo = "";
            if (retdata.phloc == "") {
                permissionmsg = "药房科室:" + defaultLocDesc;
                permissioninfo = "尚未在门诊药房人员代码维护!"
            } else {
                permissionmsg = "工号:" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "　　姓名:" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
                if (retdata.phuser == "") {
                    permissioninfo = "尚未在门诊药房人员代码维护!"
                } else if (retdata.phnouse == "Y") {
                    permissioninfo = "门诊药房人员代码维护中已设置为无效!"
                } else if (retdata.phaudit != "Y") {
                    permissioninfo = "门诊药房人员代码维护中未设置审核权限!"
                }
            }
            if (permissioninfo != "") {
                $('#modal-dhcpha-permission').modal({
                    backdrop: 'static',
                    keyboard: false
                }); //点灰色区域不关闭
                $('#modal-dhcpha-permission').on('show.bs.modal', function () {
                    $("#lb-permission").text(permissionmsg)
                    $("#lb-permissioninfo").text(permissioninfo)

                })
                $("#modal-dhcpha-permission").modal('show');
            } else {
                DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
                DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
                DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
            }
        },
        error: function () {}
    })
}

function addPassStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val == "通过") {
        return "class=dhcpha-record-passed";
    } else if ((val == "拒绝") || ((val == "拒绝发药"))) {
        return "class=dhcpha-record-refused";
    } else if (val == "申诉") {
        return "class=dhcpha-record-appeal";
    } else {
        return "";
    }
}
//读卡
function BtnReadCardHandler() {
    var readcardoptions = {
        CardTypeId: "sel-cardtype",
        CardNoId: "txt-cardno",
        PatNoId: "txt-patno"
    }
    DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
//读卡返回操作
function ReadCardReturn() {
    QueryGridPresc();
}

///药典提示
function DrugTips() {
    var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
    if (passType == "") {
        dhcphaMsgBox.alert("未设置药典接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商");
        return;
    }
    var $td = $(event.target).closest("td");
	var rowid=$td.closest("tr.jqgrow").attr("id");
	var selectdata=$('#grid-prescdetail').jqGrid('getRowData',rowid);	
	var incDesc=$.jgrid.stripHtml(selectdata.incidesc);
	var orditm=selectdata.orditm;
    if (passType == "DHC") {
        // 东华知识库
        var userInfo = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'];
        DHCSTPHCMPASS.MedicineTips({
            Oeori: orditm,
            UserInfo: userInfo,
            IncDesc: incDesc
        })
    } else if (passType == "MK") {
	     //dhcphaMsgBox.alert("接口尚未开放")
        // 美康
        MKPrescTips(orditm); 
    } else if (passType == "YY") {
		dhcphaMsgBox.alert("接口尚未开放")
	}
}
//格式化列
function druguseFormatter(cellvalue, options, rowdata) {
    if (cellvalue == undefined) {
        cellvalue = "";
    }
    var imageid = "";
    if (cellvalue == "0") {
        imageid = "warning0.gif";
    } else if (cellvalue == "1") {
        imageid = "yellowlight.gif";
    } else if (cellvalue == "2") {
        imageid = "warning2.gif"
    } else if (cellvalue == "3") {
        imageid = "warning3.gif"
    } else if (cellvalue == "4") {
        imageid = "warning4.gif"
    }
    if (imageid == "") {
        return cellvalue;
    }
    //return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/'+imageid+'" alt="' + cellvalue + '" ></img>'
    //return '<img src="../scripts/pharmacy/images/' + imageid + '" ></img>'
    return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/' + imageid + '" ></img>'
}

function addStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if ((val.indexOf("作废") >= 0) || (val.indexOf("停止") >= 0)) {
        return "class=dhcpha-record-ordstop";
    } else {
        return "";
    }
}
/***********************美康相关 start****************************/
// add by MaYuqiang 20181025	
function MKPrescAnalyse() {

    var mainrows = $("#grid-presc").getGridParam('records');
    if (mainrows == 0) {
        dhcphaMsgBox.alert("没有明细记录!");
        return;
    }

    for (var i = 1; i <= mainrows; i++) {
        var tmprowdata = $('#grid-presc').jqGrid('getRowData', i);
        var orditem = tmprowdata.orditem;
        var prescno = tmprowdata.prescno;

        var myrtn = HLYYPreseCheck(prescno, 0);

        var newdata = {
            druguse: myrtn
        };
        $("#grid-presc").jqGrid('setRowData', i, newdata);
    }
}


function HLYYPreseCheck(prescno, flag) {
    var XHZYRetCode = 0 //处方检查返回代码
    MKXHZY1(prescno, flag);
    //若为同步处理,取用McPASS.ScreenHighestSlcode
    //若为异步处理,需调用回调函数处理.
    //同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
    XHZYRetCode = McPASS.ScreenHighestSlcode;
    return XHZYRetCode
}

function MKXHZY1(prescno, flag) {
    MCInit1(prescno);
    HisScreenData1(prescno);
    MDC_DoCheck(HIS_dealwithPASSCheck, flag);
}

function MCInit1(prescno) {
    var PrescStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
    var prescdetail = PrescStr.split("^")
    var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode = "mzyf" //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
    if (result > 0) {} else {
        //alert("没问题");
    }

    return result;
}


function HisScreenData1(prescno) {
    var Orders = "";
    var Para1 = ""

    var PrescMStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
    var PrescMInfo = PrescMStr.split("^")
    var Orders = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
    if (Orders == "") {
        return;
    }
    var DocName = PrescMInfo[2];
    var EpisodeID = PrescMInfo[5];
    if (EpisodeID == "") {
        return
    }
    var ret = tkMakeServerCall("web.DHCDocHLYYMK", "GetPrescInfo", EpisodeID, Orders, DocName);
    var TempArr = ret.split(String.fromCharCode(2));
    var PatInfo = TempArr[0];
    var MedCondInfo = TempArr[1];
    var AllergenInfo = TempArr[2];
    var OrderInfo = TempArr[3];
    var PatArr = PatInfo.split("^");


    var ppi = new Params_MC_Patient_In();
    ppi.PatCode = PatArr[0]; // 病人编码
    ppi.InHospNo = PatArr[11]
    ppi.VisitCode = PatArr[7] // 住院次数
    ppi.Name = PatArr[1]; // 病人姓名
    ppi.Sex = PatArr[2]; // 性别
    ppi.Birthday = PatArr[3]; // 出生年月

    ppi.HeightCM = PatArr[5]; // 身高
    ppi.WeighKG = PatArr[6]; // 体重
    ppi.DeptCode = PatArr[8]; // 住院科室
    ppi.DeptName = PatArr[12]
    ppi.DoctorCode = PatArr[13]; // 医生
    ppi.DoctorName = PatArr[9]
    ppi.PatStatus = 1
    ppi.UseTime = PatArr[4]; // 使用时间
    ppi.CheckMode = MC_global_CheckMode
    ppi.IsDoSave = 1
    MCpatientInfo = ppi;
    var arrayDrug = new Array();
    var pri;
    var OrderInfoArr = OrderInfo.split(String.fromCharCode(1));
    //alert(OrderInfo)
    McRecipeCheckLastLightStateArr = new Array();
    for (var i = 0; i < OrderInfoArr.length; i++) {
        var OrderArr = OrderInfoArr[i].split("^");
        //传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();

        drug.Index = OrderArr[0]; //药品序号
        drug.OrderNo = OrderArr[0]; //医嘱号
        drug.DrugUniqueCode = OrderArr[1]; //药品编码
        drug.DrugName = OrderArr[2]; //药品名称
        drug.DosePerTime = OrderArr[3]; //单次用量
        drug.DoseUnit = OrderArr[4]; //给药单位      
        drug.Frequency = OrderArr[5]; //用药频次
        drug.RouteCode = OrderArr[8]; //给药途径编码
        drug.RouteName = OrderArr[8]; //给药途径名称
        drug.StartTime = OrderArr[6]; //开嘱时间
        drug.EndTime = OrderArr[7]; //停嘱时间
        drug.ExecuteTime = ""; //执行时间
        drug.GroupTag = OrderArr[10]; //成组标记
        drug.IsTempDrug = OrderArr[11]; //是否临时用药 0-长期 1-临时
        drug.OrderType = 0; //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1]; //开嘱科室编码
        drug.DeptName = PrescMInfo[4]; //开嘱科室名称
        drug.DoctorCode = PrescMInfo[6]; //开嘱医生编码
        drug.DoctorName = PrescMInfo[2]; //开嘱医生姓名
        drug.RecipNo = ""; //处方号
        drug.Num = OrderArr[15]; //药品开出数量
        drug.NumUnit = OrderArr[16]; //药品开出数量单位          
        drug.Purpose = 0; //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
        drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
        drug.Remark = ""; //医嘱备注 
        arrayDrug[arrayDrug.length] = drug;

    }
    McDrugsArray = arrayDrug;
    var arrayAllergen = new Array();
    var pai;
    var AllergenInfoArr = AllergenInfo.split(String.fromCharCode(1));
    for (var i = 0; i < AllergenInfoArr.length; i++) {
        var AllergenArr = AllergenInfoArr[i].split("^");

        var allergen = new Params_Mc_Allergen_In();
        allergen.Index = i; //序号  
        allergen.AllerCode = AllergenArr[0]; //编码
        allergen.AllerName = AllergenArr[1]; //名称  
        allergen.AllerSymptom = AllergenArr[3]; //过敏症状 

        arrayAllergen[arrayAllergen.length] = allergen;
    }
    McAllergenArray = arrayAllergen;
    //病生状态类数组
    var arrayMedCond = new Array();
    var pmi;
    var MedCondInfoArr = MedCondInfo.split(String.fromCharCode(1));
    for (var i = 0; i < MedCondInfoArr.length; i++) {
        var MedCondArr = MedCondInfoArr[i].split("^");

        var medcond;
        medcond = new Params_Mc_MedCond_In();
        medcond.Index = i; //诊断序号
        medcond.DiseaseCode = MedCondArr[0]; //诊断编码
        medcond.DiseaseName = MedCondArr[1]; //诊断名称
        medcond.RecipNo = ""; //处方号
        arrayMedCond[arrayMedCond.length] = medcond;

    }
    var arrayoperation = new Array();
    McOperationArray = arrayoperation;
}

// 美康药典提示
function MKPrescTips(orditm){
	if((orditm=="")||(orditm==null)){
	  	dhcphaMsgBox.alert("请先选择需要查看的记录!");
		return;
	}
	var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",oeori)
	var ordData = ordInfoStr.split("^")
	var inciCode = ordData[8]
	var inciDesc = ordData[9]
	var prescNo = ordData[10]
	var cyFlag = ordData[11]
	MCInit1(prescNo);
	HisQueryData(inciCode,inciDesc);
	if (cyFlag == "Y"){
		MDC_DoRefDrug(24)	
	}
	else {
		MDC_DoRefDrug(11)
	}
	
}

function HisQueryData(inciCode,inciDesc) {
	
 	var drug = new Params_MC_queryDrug_In();
    drug.ReferenceCode = inciCode; 	//药品编号
    drug.CodeName = inciDesc;       	//药品名称
    MC_global_queryDrug = drug;
} 

/***********************美康相关 end  ****************************/