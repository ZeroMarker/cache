/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��-��ҩ
 * createdate:2016-09-02
 * creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
DHCPHA_CONSTANT.VAR.SELECT = "";
DHCPHA_CONSTANT.VAR.DISPCATPID = 0;
DHCPHA_CONSTANT.VAR.DISPCATARR = "";
DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE = "";
DHCPHA_CONSTANT.VAR.WARDIDSTR = "";
DHCPHA_CONSTANT.VAR.PARAMS = "";
DHCPHA_CONSTANT.VAR.MAC = "";
DHCPHA_CONSTANT.VAR.PRIORITY = "";
$(function () {
    InitPhaConfig(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    }

    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //ҩ������
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitGridDispDocLoc();
    //InitGridAdm(); //��ʱ����,ûд��,��������,�ɲ���סԺ��ҩ,yunhaibao20160929
    InitGridOrdTotal();
    InitGridOrdDetail();
    //InitInDispTab();  //��ҳ��tab
    //$("#monitor-condition").children().not("#div-ward-condition").hide();	
    /* ��ʼ����� end*/
    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-regno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-regno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                KillDetailTmp();
                QueryInDispTotal("");
            }
        }
    });
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* ��Ԫ���¼� end*/

    /* �󶨰�ť�¼� start*/
    $("#a-change").on("click", ChangeDispQuery)
    $("#chk-timer").on("ifChanged", function () {
        if ($(this).is(':checked') == true) {
            DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryDispDocLocList();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
        } else {
            clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
        }
    })
    $("#btn-find").on("click", QueryDispDocLocList);
    $("#btn-refuse").on("click", DoRefuse);
    $("#btn-disp").on("click", ConfirmDisp)
    $("#btn-finddetail").on("click", function () {
        KillDetailTmp();
        QueryInDispTotal("");
    });
    /* �󶨰�ť�¼� end*/
    ;
    InitRefuseReasonModal();
    InitBodyStyle();
    $('#chk-prttotal').iCheck('check');
})
window.onload = function () {
    QueryDispDocLocList();
}
//��ʼ������ҩ���table
function InitGridDispDocLoc() {
    var columns = getPhaLocDispType(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID)
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryDispDocLocList&style=jqGrid', //��ѯ��̨	
        height: DhcphaJqGridHeight(1, 1),
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        // pager: "#jqGridPager1", //��ҳ�ؼ���id  
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            KillDetailTmp();
            $("#grid-dispdetail").jqGrid("clearGridData");
            if (id == null) {
                $('#grid-disptotal').clearJqGrid();
            } else {
                QueryInDispTotal();
            }
        },
        loadComplete: function () {
            $("#grid-wardlist input[type=checkbox]").each(function () {
                $(this).on("click", function () {
                    if (this.name == "") {
                        KillDetailTmp();
                        QueryInDispTotal();
                    }
                })
            });

            /* //yunhaibao,��ȷ����Ҫ���ĸ����ҵ�ҩƷ,������Ĭ��ѡ��
            var grid_records = $(this).getGridParam('records');
            if (grid_records==0){
            	$("#grid-dispdetail").clearJqGrid();
            }else{
            	$(this).jqGrid('setSelection',1);
            }*/
            var dispwardrowdata = $(this).jqGrid('getRowData');
            var dispwardgridrows = dispwardrowdata.length;
            //Ĭ�Ϸ�ҩ���
            var hasQT = "";
            if (dispwardgridrows > 0) {
                var dispWardColModel = $(this).jqGrid('getGridParam', 'colModel');
                for (var rowi = 1; rowi <= dispwardgridrows; rowi++) {
                    var rowidata = $(this).jqGrid('getRowData', rowi);
                    for (var coli = 1; coli < dispWardColModel.length; coli++) {
                        var tmpColObj = dispWardColModel[coli];
                        var tmpIndex = tmpColObj.index;
                        if ((tmpIndex != "TDocLocRowID") && (tmpIndex != "TDocLoc")) {
                            if (rowidata[tmpIndex] == "Yes") {
                                if (tmpIndex == "QT") {
                                    // ����,Ĭ�ϲ���ѡ
                                    $(this).setCell(rowi, tmpIndex, 'N');
                                    hasQT = "Y";
                                }
                            }
                        }
                    }
                }
            }
            if (hasQT == "Y") {
                $("#grid-wardlist").setGridParam().showCol("QT");
            } else {
                $("#grid-wardlist").setGridParam().hideCol("QT");
            }
        }
    };
    $('#grid-wardlist').dhcphaJqGrid(jqOptions);
}

function getPhaLocDispType(phaLocId) {
    phaLocDispCat = ""
    var columns = new Array();
    var column = {};
    column.name = "TDocLocRowID";
    column.index = "TDocLocRowID";
    column.header = "TDocLocRowID";
    column.hidden = true;
    columns.push(column);
    column = {};
    column.header = "ҽ������";
    column.name = "TDocLoc";
    column.index = "TDocLoc";
    column.align = "left";
    column.width = 150;
    columns.push(column);
    column = {};
    var phaLocDispCat = "";
    var dispcatsstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaLocDispType", phaLocId);
    var dispcatsarr = dispcatsstr.split("^");
    var dispcatslength = dispcatsarr.length;
    var dispcatsi = 0
    for (dispcatsi = 0; dispcatsi < dispcatslength; dispcatsi++) {
        column = {};
        var dispcatsdescarr = dispcatsarr[dispcatsi].split("@");
        var dispcatsdesc = dispcatsdescarr[1];
        if (dispcatsdesc == "") {
            continue;
        }
        var newcatlen = dispcatsdesc.length;
        var newdispcatdesc = "";
        for (var newcati = 0; newcati < newcatlen; newcati++) {
            var onecellcat = dispcatsdesc.charAt(newcati)
            newdispcatdesc = newdispcatdesc = "" ? onecellcat : newdispcatdesc + "\t" + onecellcat;
        }
        var dispcatscode = dispcatsdescarr[0];
        if (phaLocDispCat == "") {
            phaLocDispCat = dispcatscode
        } else {
            phaLocDispCat = phaLocDispCat + "^" + dispcatscode
        }
        column.header = newdispcatdesc;
        column.index = dispcatscode;
        column.name = dispcatscode;
        column.width = 30;
        column.formatter = "checkbox";
        column.formatoptions = {
            disabled: false
        };
        columns.push(column);
    }
    DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE = phaLocDispCat;
    return columns
}

//��ʼ����ҩ����table
function InitGridOrdTotal() {
    var columns = [{
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 100,
            align: 'left',
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '״̬',
            width: 65,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TDesc",
            index: "TDesc",
            header: 'ҩƷ����',
            width: 200,
            align: 'left'
        },
        {
            name: "TQty",
            name: "TQty",
            header: '����',
            width: 60,
            align: 'right'
        },
        {
            name: "TUom",
            name: "TUom",
            header: '��λ',
            width: 60
        },
        {
            name: "TSp",
            name: "TSp",
            header: '�ۼ�',
            width: 80,
            align: 'right'
        },
        {
            name: "TAmt",
            name: "TAmt",
            header: '���',
            width: 80,
            align: 'right'
        },
        {
            name: "TQtyBed",
            name: "TQtyBed",
            header: '����/����',
            width: 80,
            hidden: true
        },
        {
            name: "TBarcode",
            name: "TBarcode",
            header: '���',
            width: 100
        },
        {
            name: "TManufacture",
            name: "TManufacture",
            header: '����',
            width: 150,
            align: 'left'
        },
        {
            name: "TIncstk",
            name: "TIncstk",
            header: '��λ',
            width: 100,
            align: 'left'
        },
        {
            name: "TGeneric",
            name: "TGeneric",
            header: '����ͨ����',
            width: 150,
            align: 'left'
        },{
            name: "TDrugForm",
            name: "TDrugForm",
            header: '����',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=jsQueryDispDocLoc&style=jqGrid&querytype=total', //��ѯ��̨	
        height: DhcphaJqGridHeight(2, 1) - 35,
        multiselect: false,
        shrinkToFit: false,
        // pager: "#jqGridPager", //��ҳ�ؼ���id  
        onSelectRow: function (id, status) {

        }
    };
    $('#grid-disptotal').dhcphaJqGrid(jqOptions);
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};
//��ʼ����ҩ��ϸtable
function InitGridOrdDetail() {
    var columns = [{
            name: 'TSelect',
            index: 'TSelect',
            header: '<a id="TDispSelect" href="#" onclick="SetSelectAll()">ȫ��</a>',
            width: 35,
            editable: true,
            align: 'center',
            edittype: 'checkbox',
            formatter: "checkbox",
            formatoptions: {
                disabled: false
            }
        },
        {
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 80,
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '״̬',
            width: 65,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '����',
            width: 125,
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '����',
            width: 80
        },
        {
            name: "TPaName",
            index: "TPaName",
            header: '����',
            width: 80
        },
        {
            name: "TRegNo",
            index: "TRegNo",
            header: '�ǼǺ�',
            width: 100
        },
        {
            name: "TDesc",
            index: "TDesc",
            header: 'ҩƷ����',
            width: 200,
            align: 'left'
        },
        {
            name: "TQty",
            index: "TQty",
            header: '����',
            width: 50,
            align: 'right'
        },
        {
            name: "TUom",
            index: "TUom",
            header: '��λ',
            width: 50
        },
        {
            name: "TDoseQty",
            index: "TDoseQty",
            header: '����',
            width: 60
        },
        {
            name: "TFreq",
            index: "TFreq",
            header: 'Ƶ��',
            width: 60
        },
        {
            name: "TInstruction",
            index: "TInstruction",
            header: '�÷�',
            width: 80
        },
        {
            name: "TDuration",
            index: "TDuration",
            header: '�Ƴ�',
            width: 80
        },
        {
            name: "TSalePrice",
            index: "TSalePrice",
            header: '�ۼ�',
            width: 70,
            align: 'right'
        },
         {
            name: "Tolp",
            index: "Tolp",
            header: '���',
            width: 80,
            align: 'right'
        },
        {
            name: "Tbarcode",
            index: "Tbarcode",
            header: '���',
            width: 80
        },
        {
            name: "Tmanf",
            index: "Tmanf",
            header: '����',
            width: 150,
            align: 'left'
        },
        {
            name: "Tgenedesc",
            index: "Tgenedesc",
            header: '����ͨ����',
            width: 150,
            align: 'left'
        },
        {
            name: "Tphcform",
            index: "Tphcform",
            header: '����',
            width: 100
        },

        {
            name: "Tgoods",
            index: "Tgoods",
            header: '��λ',
            width: 100,
            align: 'left'
        },
        {
            name: "TOrdStatus",
            index: "TOrdStatus",
            header: 'ҽ��״̬',
            width: 60
        },
        {
            name: "Toetype",
            index: "Toetype",
            header: 'ҽ�����ȼ�',
            width: 80
        },
        {
            name: "TPhaCat",
            index: "TPhaCat",
            header: '���',
            width: 80,
            hidden: true
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '������',
            width: 110
        },
        {
            name: "Tdoctor",
            index: "Tdoctor",
            header: '����ҽ��',
            width: 60,
            hidden:true
        },
        {
            name: "Tdatetime",
            index: "Tdatetime",
            header: '����ʱ��',
            width: 150,
            align: 'left'
        },
        {
            name: "Tdiagnose",
            index: "Tdiagnose",
            header: '���',
            width: 200,
            align: 'left'
        }, 
        {
            name: "Taudited",
            index: "Taudited",
            header: '���',
            width: 80,
            hidden: true
        },
        {
            name: "TPaold",
            index: "TPaold",
            header: '����',
            width: 60
        },
        {
            name: "Taction",
            index: "Taction",
            header: '��ע',
            width: 80,
            align: 'left'
        },
        {
            name: "TInsuType",
            index: "TInsuType",
            header: 'ҽ�����',
            width: 75
        },
        {
            name: "Tstr",
            index: "Tstr",
            header: 'Tstr',
            width: 80,
            hidden: true
        },
        {
            name: "TDispIdStr",
            index: "TDispIdStr",
            header: 'TDispIdStr',
            width: 80,
            hidden: true
        },
        {
            name: "Toedis",
            index: "Toedis",
            header: 'Toedis',
            width: 80,
            hidden: true
        },
        {
            name: "TBatchNo",
            index: "TBatchNo",
            header: '����',
            width: 80,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=jsQueryDispDocLoc&querytype=detail&style=jqGrid', //��ѯ��̨	
        height: DhcphaJqGridHeight(2, 2) - 42,
        multiselect: false,
        //multiboxonly:false,
        shrinkToFit: false,
        pager: "#jqGridPager1", //��ҳ�ؼ���id  
        onSelectRow: function (id, status) {

        },
        loadComplete: function () {
            $('#grid-disptotal').clearJqGrid();
            $("#TDispSelect").text("ȫ��");
            AddjqGridCheckEvent();
        },
        onPaging: function (pgButton) {
            ReLoadAddPid();
        },
        gridComplete: function () {

        }
    };
    $('#grid-dispdetail').dhcphaJqGrid(jqOptions);
    $("#refresh_grid-dispdetail").hide(); //�˴�ˢ��������
}

function AddjqGridCheckEvent() {
    $("#grid-dispdetail input[type=checkbox]").each(function () {
        $(this).unbind(); //setrowdata��,click�¼�ʧЧ,ÿ�ζ���ȫ��
        $(this).on("click", function () {
            if (this.name == "") {
                $td = $(event.target).closest("td"); //֪���ĸ�Ԫ��,���ܶ�λ�ĸ�����
                var rowid = $td.closest("tr.jqgrow").attr("id");
                var selectdata = $("#grid-dispdetail").jqGrid('getRowData', rowid)
                Savetofitler(selectdata);
                //SelectLinkOrder(selectdata);	
            }
        })
    })
}

function SetSelectAll() {
    var tmpSelectFlag = ""
    if ($("#TDispSelect").text() == "ȫѡ") {
        $("#TDispSelect").text("ȫ��")
        tmpSelectFlag = "Y"
    } else {
        $("#TDispSelect").text("ȫѡ")
        tmpSelectFlag = "N"
    }
    var selDspIdArr=[];
    var thisrecords = $("#grid-dispdetail").getGridParam('records');
    if (thisrecords > 0) {
        var ids = $("#grid-dispdetail").getDataIDs();
        for (var i = 0; i < ids.length; i++) {
			var rowData=$("#grid-dispdetail").jqGrid('getRowData',i+1);
			var dspIdStr=rowData.TDispIdStr;
			selDspIdArr.push(dspIdStr);
			var newdata={
		    	TSelect:tmpSelectFlag 
		    };
		    $("#grid-dispdetail").jqGrid('setRowData',i+1,newdata);	
        }
        var tmpRowData=$("#grid-dispdetail").jqGrid('getRowData',1);
		var pid=tmpRowData.TPID;
		var selDspIdStr=selDspIdArr.join("^");
		var selected=(tmpSelectFlag=="Y")?"D":"S";
		if (selDspIdStr!=""){
			tkMakeServerCall("web.DHCSTPCHCOLLSDOCLOC","SaveToFilterMulti",pid,selDspIdStr,selected)
		}
    }
    
    AddjqGridCheckEvent();
}

function Savetofitler(selectrowdata) {
    //��ʱ���淢ҩʱû��ѡ���ҽ��Rowid
    var tdispstr = selectrowdata["TDispIdStr"];
    var tpid = selectrowdata["TPID"];
    var selected = selectrowdata["TSelect"];
    if (selected == "Yes") {
        selected = "D";
    } else {
        selected = "S";
    }
    if ((tpid != "") && (tpid != undefined)) {
        var saveret = tkMakeServerCall("web.DHCSTPCHCOLLSDOCLOC", "SaveToFilter", tpid, tdispstr, selected)
    }
}
//����ҽ��ѡ��,������,ҽ�����ҷ�ҩ����Ҫ
function SelectLinkOrder(selecteddata) {
    var tmpselect = selecteddata["TSelect"]
    var toedis = selecteddata["Toedis"];
    var orderlinkret = CheckOrderLink(toedis).split("%");
    var oeoricnt = orderlinkret[0]
    if (oeoricnt > 0) {
        var mainoeori = selecteddata["TMainOrd"]; //��ҽ��id
        var dodisdate = selecteddata["TTimeAdd"]
        var mainindex = mainoeori + "^" + dodisdate
        var quitflag = 0;
        var dispgridrows = $("#grid-dispdetail").getGridParam('records');
        for (var i = 1; i <= dispgridrows; i++) {
            var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i)
            var tmpmainoeori = tmpselecteddata["TMainOrd"]
            var tmpdodisdate = tmpselecteddata["TTimeAdd"]
            var tmpmainindex = tmpmainoeori + "^" + tmpdodisdate;
            if (mainindex == tmpmainindex) {
                var newdata = {
                    TSelect: tmpselect
                };
                $("#grid-dispdetail").jqGrid('setRowData', i, newdata);
                //$("#grid-dispdetail").jqGrid('setCell',i,'TSelect',tmpselect,"",abc);
                var newselectdata = $("#grid-dispdetail").jqGrid('getRowData', i)
                Savetofitler(newselectdata);
                quitflag = 1;
            }
            if ((quitflag == 1) && (mainindex != tmpmainindex)) {
                break;
            }
        }
    }
    AddjqGridCheckEvent();
}
//�ж��Ƿ�Ϊ����ҽ��
function CheckOrderLink(oedisstr) {
    var ret = tkMakeServerCall("web.DHCSTPCHCOLLS", "CheckLinkOeord", oedisstr)
    return ret;
}

function ReLoadAddPid() {
    if ($("#grid-dispdetail").getGridParam('records') > 0) {
        var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
        var Pid = firstrowdata.TPID
        $("#grid-dispdetail").setGridParam({
            postData: {
                Pid: Pid
            }
        })
    }
}

function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        $("#sel-locinci").empty();
        InitThisLocInci($(this).val());
    });
}

function InitPhaConfig(locRowId) {
    $.ajax({
        type: 'POST', //�ύ��ʽ post ����get  
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetInPhaConfig&gLocId=' + locRowId, //�ύ������ �����ķ���  
        data: "",
        success: function (value) {
            if (value != "") {
                SetPhaLocConfig(value)
            }
        },
        error: function () {
            alert("��ȡסԺҩ����������ʧ��!");
        }
    });
}
//����ҩ������
function SetPhaLocConfig(configstr) {
    DHCPHA_CONSTANT.VAR.PARAMS = configstr;
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    var notwardrequired = configarr[0];
    var auditneed = configarr[10];
    var retflag = configarr[11];
    var dispuserflag = configarr[17];
    var operaterflag = configarr[21];
    var aduitBillflag = configarr[22];
    var disptypelocalflag = configarr[23];
    var displayemyflag = configarr[24];
    var displayoutflag = configarr[25];
    var lsflag = configarr[26];
    var reqwardflag = configarr[27];
    var dispdefaultflag = configarr[28];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate);
    $("#date-start").data('daterangepicker').setEndDate(startdate);
    $("#date-end").data('daterangepicker').setStartDate(enddate);
    $("#date-end").data('daterangepicker').setEndDate(enddate);
    //InitDispUserModal(DHCPHA_CONSTANT.VAR.PARAMS);
}

//��ѯ����ҩҽ������
function QueryDispDocLocList() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return;
    }
    var params = startdate + "!!" + enddate + "!!" + phaloc;
    $("#grid-wardlist").setGridParam({
        datatype: 'json',
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    KillDetailTmp();
    $('#grid-disptotal').clearJqGrid();
    $('#grid-dispdetail').clearJqGrid();
}
//��ѯ�����¼
function QueryDispAdmList() {
    var patno = $("#txt-patno").val();
    var params = patno;
    $("#grid-admlist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}
//��ѯ����ҩ�б�
function QueryInDispTotal(Pid) {
    if (Pid == undefined) {
        Pid = "";
    }
	if (Pid == '') {
        $('#grid-dispdetail').jqGrid('clearGridData');
        $('#grid-disptotal').jqGrid('clearGridData');
    }
    var params = GetQueryDispParams();
    if (params != "") {
        if ($("#div-detail").is(":hidden") == false) {
            $("#grid-dispdetail").setGridParam({
                postData: {
                    params: params,
                    Pid: Pid
                }
            }).trigger("reloadGrid");
        } else {
            $("#grid-disptotal").setGridParam({
                postData: {
                    params: params,
                    Pid: Pid
                }
            }).trigger("reloadGrid");
        }
    }
}

function GetQueryDispParams() {
    var dispcatlist = "";
    var doclocrowid = "";
    if ($("#div-ward-condition").is(":hidden") == false) {
        var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
        if ((selectid == "") || (selectid == null)) {
            dhcphaMsgBox.alert("����ѡ����Ҫ��ҩ��ҽ������!");
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return "";
        }
        var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
        doclocrowid = selrowdata.TDocLocRowID;
        dispcatlist = GetDispCatList(selrowdata);

    } else {
        dhcphaMsgBox.alert("��ˢ�½��������!");
        return "";
    }
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return "";
    }
    var incirowid = $("#sel-locinci").val()
    if (incirowid == null) {
        incirowid = ""
    }
    var patno = $("#txt-regno").val();
    var params = phaloc + "!!" + startdate + "!!" + enddate + "!!" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "!!" + dispcatlist + "!!" + doclocrowid + "!!" + patno + "!!" + incirowid
    return params;

}
//��ȡѡ�п��ҵķ�ҩ���
function GetDispCatList(selectrowdata) {
    var colModel = $("#grid-wardlist").jqGrid('getGridParam', 'colModel');
    var dispcatsstr = "";
    var collength = colModel.length;
    for (var columni = 0; columni < collength; columni++) {
        var colmodali = colModel[columni];
        var colnamei = colmodali.name;
        if ((colnamei == "TDocLocRowID") || (colnamei == "TDocLoc") || (colnamei == "cb")) {
            continue;
        }
        if (selectrowdata[colnamei] == "Yes") {
            if (dispcatsstr == "") {
                dispcatsstr = colnamei
            } else {
                dispcatsstr = dispcatsstr + "^" + colnamei
            }
        }
    }
    return dispcatsstr;
}
//��ҩ
function ConfirmDisp() {
    if ($("#sp-title").text() == "��ҩ��ϸ") {
        if (DhcphaGridIsEmpty("#grid-dispdetail") == true) {
            return;
        }
    } else if ($("#sp-title").text() == "��ҩ����") {
        if (DhcphaGridIsEmpty("#grid-disptotal") == true) {
            return;
        }
    }
    if (DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE == "") {
        dhcphaMsgBox.alert("��ҩ���Ϊ��!")
        return;
    }
    dhcphaMsgBox.confirm("�Ƿ�ȷ�Ϸ�ҩ?", DoDisp);
}

function DoDisp(result) {
    if (result == true) {
        var dispflag = "";
        //ȡ�Ƿ�¼�뷢ҩ������
        /*if (DHCPHA_CONSTANT.VAR.PARAMS!=""){
        	var paramsarr=DHCPHA_CONSTANT.VAR.PARAMS.split("^");
        	var dispuserflag=paramsarr[17];
        	var operaterflag=paramsarr[21];
        	if ((dispuserflag=="Y")||(operaterflag=="Y")){
        		dispflag=1;
        		$('#modal-inphaphauser').modal('show');
        	}
        }*/
        if (dispflag == "") {
            ExecuteDisp({});
        }
    }
}

function ExecuteDisp(dispoptions) {
    var pid = "";
    if ($("#sp-title").text() == "��ҩ��ϸ") {
        var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    } else if ($("#sp-title").text() == "��ҩ����") {
        var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    }
    var phaloc = $("#sel-phaloc").val();
    var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("����ѡ����Ҫ��ҩ��ҽ������!");
        return "";
    }
    var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
    doclocrowid = selrowdata.TDocLocRowID;
    dispcatlist = GetDispCatList(selrowdata);
    if (dispcatlist == "") {
        dhcphaMsgBox.alert("��ҩ���Ϊ��!");
        return "";
    }
    var phacrowidStr = ""
    var dispcatarr = dispcatlist.split("^");
    for (var cati = 0; cati < dispcatarr.length; cati++) {
        var dispcat = dispcatarr[cati];
        var PhacRowid = SaveDispensing(dispcat, pid,doclocrowid);
        if (PhacRowid > 0) {
            if (phacrowidStr != "") {
                phacrowidStr = phacrowidStr + "A" + PhacRowid;
            } else {
                phacrowidStr = PhacRowid;
            }
        } else if (PhacRowid < 0) {
            alert(getDispCatName(cat) + "��ҩʧ��!");
        }
    }
    // ��������֧
    if ((phacrowidStr == "") || (phacrowidStr == 0)) {
        dhcphaMsgBox.alert("δ����ҩƷ,�������ڷ�ҩ��ϸ�в����ԭ��");
        tkMakeServerCall("web.DHCINPHA.Disp.Global", "KillSaveDataNoStock", pid)
        return;
    }
    var reserveret = tkMakeServerCall("web.DHCINPHA.Reserve", "SaveReserveForWhole", phacrowidStr, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
    dhcphaMsgBox.confirm("�Ƿ��ӡ��", function (rtn) {
        if (rtn == true) {
            PrintReport(phacrowidStr, pid);
        }
        KillDetailTmp();
        QueryDispDocLocList();
    });

}

function SaveDispensing(dispcat, pid,doclocrowid) {
    var PhacRowid = tkMakeServerCall("web.DHCSTPCHCOLLSDOCLOC", "SaveDisp", "", "", dispcat, pid, DHCPHA_CONSTANT.SESSION.GUSER_ROWID,doclocrowid);
    return PhacRowid;
}
//�ܾ���ҩ
function DoRefuse() {
    if ($("#sp-title").text() == "��ҩ����") {
        dhcphaMsgBox.alert("���л�����ҩ��ϸ���оܾ�!");
        return;
    }
    if (DhcphaGridIsEmpty("#grid-dispdetail") == true) {
        return;
    }
    var dispgridrows = $("#grid-dispdetail").getGridParam('records');
    var canrefuse = 0;
    for (var i = 1; i <= dispgridrows; i++) {
        var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i)
        var tmpselect = tmpselecteddata["TSelect"];
        if (tmpselect != "Yes") {
            continue;
        }
        canrefuse = 1;
        break;
    }
    if (canrefuse == 0) {
        dhcphaMsgBox.alert("��ѡ����Ҫ�ܾ���ҩ����ϸ!");
        return;
    }
    $('#modal-inpharefusedispreason').modal('show');
}

function ExecuteRefuse(refusereason) {
    var ordArr = new Array();
    var dispgridrows = $("#grid-dispdetail").getGridParam('records');
    for (var i = 1; i <= dispgridrows; i++) {
        var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i)
        var tmpselect = tmpselecteddata["TSelect"];
        if (tmpselect != "Yes") {
            continue;
        }
        var tmpdispidstr = tmpselecteddata["TDispIdStr"];
        if (!ordArr.contains(tmpdispidstr)) {
            ordArr.push(tmpdispidstr)
        }
    }
    tkMakeServerCall("web.DHCSTPCHCOLLS", "InsertDrugRefuse", ordArr.join("^"), DHCPHA_CONSTANT.SESSION.GUSER_ROWID, refusereason)
    KillDetailTmp();
    QueryInDispTotal();
}

function InitInDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        ;
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        if (tabId != "tab-patno") {
            $("#txt-patno").val("");
            if ($("#grid-admlist").getGridParam('records') > 0) {
                KillDetailTmp();
                $('#grid-admlist').clearJqGrid();
                $('#grid-disptotal').clearJqGrid();
                $('#grid-dispdetail').clearJqGrid();
                QueryInDispTotal("");
            }
        }
    })

}
//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid
    }
    InitLocInci(locincioptions)
}

function ChangeDispQuery() {
    var Pid = "";
    if ($("#sp-title").text() == "��ҩ����") {
        $("#sp-title").text("��ҩ��ϸ");
        $("#div-total").hide();
        $("#div-detail").show();
        if ($("#grid-dispdetail").getGridParam('records') == 0) {
            if ($("#grid-disptotal").getGridParam('records') > 0) {
                var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
                Pid = firstrowdata.TPID
            }
            QueryInDispTotal(Pid);
        }
    } else {
        $("#sp-title").text("��ҩ����")
        $("#div-detail").hide();
        $("#div-total").show(); //ÿ�ε�����ܶ�Ҫ���»���
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
        QueryInDispTotal(Pid);
    }
}

function KillDetailTmp() {
    var Pid = "";
    if ($("#sp-title").text() == "��ҩ����") {
        if ($("#grid-disptotal").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID;
        }
    } else {
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
    }
    KillInDispTmp(Pid)
}

function KillInDispTmp(pid) {
    if (pid != "") {
        tkMakeServerCall("web.DHCINPHA.DispDocLoc", "KillTmp", pid);
    }
}

function GetDispCatNameByCode(catcode) {
    var dispcatname = tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetDispCatDescByCode", catcode)
    return dispcatname;
}

function PrintReport(phacstr, pid) {
    var printtype = "";
    if ($("#chk-prttotal").is(':checked') == true) {
        printtype = 2;
    }
    if ($("#chk-prtdetail").is(':checked') == true) {
        printtype = 1;
    }
    if (($("#chk-prttotal").is(':checked') == true) && ($("#chk-prtdetail").is(':checked') == true)) {
        printtype = 3;
    }
    var phacStr = phacstr.split("A").join("^");
    IPPRINTCOM.Print({
        phacStr: phacStr,
        otherStr: "",
        printType: printtype,
        reprintFlag: "N",
        pid: ''
    });
}

function InitRefuseReasonModal() {
    $('#modal-inpharefusedispreason').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetRefuseDispReason&style=select2",
            minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        }
        $("#sel-refusedispreason").dhcphaSelect(option);
        $("#sel-refusedispreason").empty();
    })
    $("#btn-refusereason-sure").on("click", function () {
        var refusereason = $("#sel-refusedispreason").val();
        if ((refusereason == "") || (refusereason == null)) {
            dhcphaMsgBox.alert("��ѡ��ܾ���ҩԭ��!");
            return;
        }
        $("#modal-inpharefusedispreason").modal('hide');
        ExecuteRefuse(refusereason);
    });

}
//��ҩ��,��ҩ��ѡ��
function InitDispUserModal(params) {
    var paramsarr = params.split("^");
    var dispuserflag = paramsarr[17];
    var operaterflag = paramsarr[21];
    if (dispuserflag != "Y") {
        $("#sel-phauser").closest("div").hide();
    }
    if (operaterflag != "Y") {
        $("#sel-operateuser").closest("div").hide();
    }
    $('#modal-inphaphauser').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetInPhaUser&style=select2&groupId=" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
            //minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        }
        $("#sel-phauser").dhcphaSelect(option);
        $("#sel-phauser").empty();
        $("#sel-operateuser").dhcphaSelect(option);
        $("#sel-operateuser").empty();
    })
    $("#btn-phauser-sure").on("click", function () {
        var phauser = $("#sel-phauser").val();
        var operateuser = $("#sel-operateuser").val();
        if ((dispuserflag == "Y") && ((phauser == "") || (phauser == null))) {
            dhcphaMsgBox.alert("��ѡ��ҩ��!");
            return;
        }
        if ((operaterflag == "Y") && ((operateuser == "") || (operateuser == null))) {
            dhcphaMsgBox.alert("��ѡ���ҩ��!");
            return;
        }
        $("#modal-inphaphauser").modal('hide');
        var dispoptions = {
            phauser: phauser,
            operateuser: operateuser
        }
        ExecuteDisp(dispoptions);
    });
}

function InitBodyStyle() {
    $('#div-conditions').collapse('show');
    $('#div-conditions').on('hide.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        tmpheight = tmpheight + $("#div-conditions").height();
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $('#div-conditions').on('show.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $("#grid-disptotal").setGridWidth(""); //yunhaibao20160906,��պ������ռ�,��֪��Ϊɶ
    $("#grid-dispdetail").setGridWidth("");
    $("#div-detail").hide();
    var wardtitleheight = $("#gview_grid-wardlist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 10;
    $("#grid-wardlist").setGridHeight(wardheight);
    $("#grid-wardlist").setGridWidth("");
    $("#tab-patno").hide();

}

function addCollStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val.indexOf("Ƿ��") >= 0) {
        return "class=dhcpha-record-owefee";
    } else if (val.indexOf("��治��") >= 0) {
        return "class=dhcpha-record-nostock";
    } else {
        return "";
    }
}
window.onbeforeunload = function () {
    KillDetailTmp();
}