/*
 *ģ��:סԺҩ��
 *��ģ��:ҵ���ѯ-��ҩ�ۺϲ�ѯ
 *createdate:2016-12-12
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    var tDate = FormatDateT("T");
	$("#date-start").data('daterangepicker').setStartDate(tDate+" 00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(tDate+" 00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(tDate+" 23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(tDate+" 23:59:59");
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc(); //ҩ������
    InitPhaWard(); //����
    InitDocLoc(); //ҽ������
    InitAdmLoc(); //�������
    InitDispCat(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //��ҩ���
    InitPoisonCat(); //���Ʒ���
    InitManaGroup(); //������
    InitPhcForm(); //����
    InitIncludeDoc(); //�Ƿ����ҽ������
    InitIncludeOut(); //�Ƿ������Ժ��ҩ
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitFyUser();
    InitDispMainList();
    InitDispDetailList();
    /*ҩ����� start*/
    $("#txt-phccat").next().children("i").on('click', function (event) {
        ShowPHAINPhcCat({},function(catObj){
			if (catObj){
				$("#txt-phccat").val(catObj.text||'');
				DHCPHA_CONSTANT.VAR.NEWPHACCAT=catObj.id||'';
			}
		})
        
    });
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                Query();
            }
        }
    });
    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    $("#btn-print").on("click", BtnPrintHandler);
    /* �󶨰�ť�¼� end*/
    ;
    $("#gird-dispquery").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
    $("#gird-dispquerydetail").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})


//�Ƿ����ҽ������
function InitIncludeDoc() {
    var data = [{
            id: 0,
            text: '����ҽ������'
        },
        {
            id: 1,
            text: '��ҽ������'
        },
        {
            id: 2,
            text: '������ҽ������'
        }
    ];
    var selectoption = {
        data: data,
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $("#sel-includedoc").dhcphaSelect(selectoption);
}
//�Ƿ������Ժ��ҩ
function InitIncludeOut() {
    var data = [{
            id: 0,
            text: '������Ժ��ҩ'
        },
        {
            id: 1,
            text: '����Ժ��ҩ'
        },
        {
            id: 2,
            text: '��������Ժ��ҩ'
        }
    ];
    var selectoption = {
        data: data,
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $("#sel-includeout").dhcphaSelect(selectoption);
}
//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid,
        width: "390px"
    }
    InitLocInci(locincioptions)
}
//��ʼ����ҩ��
function InitFyUser() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetInPhaUser&locId=" +
            DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&groupId=" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "&style=select2",
        allowClear: true,
        placeholder: '��ҩ��...'
    }
    $("#sel-fyuser").dhcphaSelect(selectoption)
    $("#sel-fyuser").on('select2:select', function (event) {
        //alert(event)
    });
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
        InitDispCat($(this).val());
    });
}

function InitPhaWard() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDs&style=select2",
        placeholder: "����..."
    }
    $("#sel-phaward").dhcphaSelect(selectoption)
}

function InitDocLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetCtLocDs&style=select2&loctype=E&custtype=DocLoc",
        placeholder: "ҽ������..."
    }
    $("#sel-docloc").dhcphaSelect(selectoption);
}

function InitAdmLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetCtLocDs&style=select2&loctype=E&custtype=DocLoc",
        placeholder: "�������..."
    }
    $("#sel-admloc").dhcphaSelect(selectoption);
}

function InitDispCat(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetLocDispTypeDs&style=select2&locId=" + locrowid,
        placeholder: "��ҩ���...",
        minimumResultsForSearch: Infinity
        //multiple: true	
    }
    $("#sel-dispcat").dhcphaSelect(selectoption)
}

function InitPoisonCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetPoisonCatDs&style=select2",
        allowClear: true,
        placeholder: "���Ʒ���...",
        minimumResultsForSearch: Infinity
    }
    $("#sel-poison").dhcphaSelect(selectoption)
    $('#sel-poison').on('select2:select', function (event) {
        //alert(event)
    });
}

function InitManaGroup() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetManaGroupDs&style=select2&gLocId=" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
        allowClear: true,
        minimumResultsForSearch: Infinity,
        placeholder: "������..."
    }
    $("#sel-managroup").dhcphaSelect(selectoption)
    $('#sel-managroup').on('select2:select', function (event) {
        //alert(event)
    });
}

function InitPhcForm() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetPhcFormDs&style=select2",
        allowClear: true,
        placeholder: "����..."
    }
    $("#sel-phcform").dhcphaSelect(selectoption)
}
//��ʼ����ҩ��ѯ�б�
function InitDispMainList() {
    //����columns
    var columns = [
        [{
                field: 'TPID',
                title: 'TPID',
                width: 100,
                align: 'left',
                hidden: true
            },
            {
                field: 'TCode',
                title: 'ҩƷ����',
                width: 90,
                align: 'center'
            },
            {
                field: 'TDesc',
                title: 'ҩƷ����',
                width: 350
            },
            {
                field: 'Tbcode',
                title: '���',
                width: 100
            },
            {
                field: 'Tmname',
                title: '������ҵ',
                width: 150,
                align: 'left',
				hidden:true
            },
            {
                field: 'TDispQty',
                title: '����',
                width: 90,
                align: 'right'
            },
            {
                field: 'TUom',
                title: '��λ',
                width: 90,
                align: 'center'
            },
            {
                field: 'Tprice',
                title: '�ۼ�',
                width: 100,
                align: 'right'
            },
            {
                field: 'TDispAmt',
                title: '���',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'TQty',
                title: '��ҩ����',
                width: 100,
                align: 'right'
            },
            {
                field: 'TAmt',
                title: '��ҩ���',
                width: 100,
                align: 'right'
            },
            {
                field: 'TRetQty',
                title: '��ҩ����',
                width: 100,
                align: 'right'
            },
            {
                field: 'TRetAmt',
                title: '��ҩ���',
                width: 100,
                align: 'right'
            },
            {
                field: 'TPackUomQty',
                title: 'ȡ����λ����',
                width: 100
            },
            {
                field: 'TPackPrice',
                title: '����װ�۸�',
                width: 100,
                align: 'right'
            },
            {
                field: 'Tgname',
                title: '����ͨ����',
                width: 150
            },
            {
                field: 'Tfname',
                title: '����',
                width: 110,
                algin: 'center'
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        onClickRow: function (rowIndex, rowData) {
            QueryDetail();
        }
    }
    //����datagrid	
    $('#gird-dispquery').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩ��ϸ�б�
function InitDispDetailList() {
    //����columns
    var columns = [
        [{
                field: 'TAdmLoc',
                title: '����',
                width: 150
            },
            {
                field: 'TBedNo',
                title: '����',
                width: 80
            },
            {
                field: 'TRegNo',
                title: '�ǼǺ�',
                width: 90,
                align: 'center'
            },
            {
                field: 'TName',
                title: '����',
                width: 90
            },
            {
                field: 'TSex',
                title: '�Ա�',
                width: 75,
                align: 'center'
            },
            {
                field: 'Tpaold',
                title: '����',
                width: 75,
                align: 'center'
            },
            {
                field: 'TPrescNo',
                title: '������',
                width: 110,
                align: 'center'
            },
            {
                field: 'TDoseQty',
                title: '����',
                width: 100
            },
            {
                field: 'TQty',
                title: '����',
                width: 75,
                align: 'right'
            },
            {
                field: 'TUomDesc',
                title: '��λ',
                width: 75
            },
            {
                field: 'TSalePrice',
                title: '�ۼ�',
                width: 75,
                align: 'right'
            },
            {
                field: 'TAmt',
                title: '���',
                width: 75,
                align: 'right'
            },
            {
                field: 'Tfreq',
                title: 'Ƶ��',
                width: 100
            },
            {
                field: 'Tdiag',
                title: '���',
                width: 200,
                hidden: true
            },
            {
                field: 'Tptime',
                title: '��ҩʱ��',
                width: 150
            },
            {
                field: 'Tdoctor',
                title: '����ҽ��',
                width: 80,
                align: 'center',
                hidden: true
            },
            {
                field: 'Toedate',
                title: '����ʱ��',
                width: 150
            },
            {
                field: 'Taction',
                title: '��ע',
                width: 100
            },
            {
                field: 'TPackPrice',
                title: '����װ�۸�',
                width: 100,
                align: 'right',
                hidden: true
            },
            {
                field: 'TEncryptLevel',
                title: '�����ܼ�',
                width: 100
            },
            {
                field: 'TPatLevel',
                title: '���˼���',
                width: 100
            },
            {
                field: 'TDrugForm',
                title: '����',
                width: 100
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        pagination: true
    }
    //����datagrid	
    $('#gird-dispquerydetail').dhcphaEasyUIGrid(dataGridOption);
}


///��ѯ
function Query() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $("#sel-phaloc").val();
    var patno = $("#txt-patno").val();
    var patname = "" //$("#txt-patname").val();
    var wardrowid = $("#sel-phaward").val();
    if (wardrowid == null) {
        wardrowid = "";
    }
    var dispuser = $("#sel-fyuser").val();
    if (dispuser == null) {
        dispuser = "";
    }
    dispuser = dispuser + "^id";
    var incirowid = $("#sel-locinci").val();
    if (incirowid == null) {
        incirowid = "";
    }
    var fyuser = $("#sel-fyuser").val();
    if (fyuser == null) {
        fyuser = "";
    }
    var dispcat = $("#sel-dispcat").val();
    if (dispcat == null) {
        dispcat = "";
    }
    var admlocrowid = $("#sel-admloc").val();
    if (admlocrowid == null) {
        admlocrowid = "";
    }
    var doclocrowid = $("#sel-docloc").val();
    if (doclocrowid == null) {
        doclocrowid = "";
    }
    var phcformrowid = $("#sel-phcform").val();
    if (phcformrowid == null) {
        phcformrowid = "";
    }
    var managrouprowid = $("#sel-managroup").val();
    if (managrouprowid == null) {
        managrouprowid = "";
    }
    var poisonrowid = $("#sel-poison").val();
    if (poisonrowid == null) {
        poisonrowid = "";
    }
    var stkcatrowid = "";
    var PhcCatRowidStr = "^^"; //ԭҩѧ��������
    var includedoc = $("#sel-includedoc").val();
    var onlydoc = 0,
        onlyout = 0,
        excludedoc = 0,
        excludeout = 0;
    if (includedoc == 1) {
        onlydoc = "1"
    } else if (includedoc == 2) {
        excludedoc = "1"
    }
    var includeout = $("#sel-includeout").val();
    if (includeout == 1) {
        onlyout = "1"
    } else if (includeout == 2) {
        excludeout = "1"
    }
    if ($("#txt-phccat").val() == "") {
        DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
    }
    var otherparams = poisonrowid + "^" + stkcatrowid + "^" + onlydoc + "^" + onlyout + "^" + excludedoc + "^" + excludeout + "^" + DHCPHA_CONSTANT.VAR.NEWPHACCAT;
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + wardrowid + tmpSplit + dispuser +
        tmpSplit + dispcat + tmpSplit + PhcCatRowidStr + tmpSplit + incirowid + tmpSplit + admlocrowid + tmpSplit + starttime +
        tmpSplit + endtime + tmpSplit + doclocrowid + tmpSplit + phcformrowid + tmpSplit + patno + tmpSplit + managrouprowid +
        tmpSplit + otherparams
    $('#gird-dispquery').datagrid({
        queryParams: {
            ClassName: "web.DHCSTDISPSTAT",
            QueryName: "DispStatGenerally",
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
    $('#gird-dispquerydetail').clearEasyUIGrid();

}

///��ҩ��ϸ��ѯ
function QueryDetail() {
    var selecteddata = $('#gird-dispquery').datagrid('getSelected');
    if (selecteddata == null) {
        return;
    }
    var pid = selecteddata["TPID"];
    var incicode = selecteddata["TCode"];
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = pid + tmpSplit + incicode;
    $('#gird-dispquerydetail').datagrid({
        queryParams: {
            ClassName: "web.DHCSTDISPSTAT",
            QueryName: "DispStatGenarallyDetail",
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
}

//���
function ClearConditions() {
    var tDate = FormatDateT("T");
    $("#date-start").data('daterangepicker').setStartDate(tDate + " " + "00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(tDate + " " + "00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(tDate + " " + "23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(tDate + " " + "23:59:59");
    //$("#txt-patname").val("");
    $("#txt-patno").val("");
    $("#txt-phccat").val("");
    DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
    $("#sel-fyuser").empty();
    $("#sel-locinci").empty();
    $("#sel-admloc").empty();
    $("#sel-docloc").empty();
    $("#sel-poison").empty();
    $("#sel-phaward").empty();
    $("#sel-phcform").empty();
    $("#sel-dispcat").empty();
    $("#sel-managroup").empty();
    $("#sel-includedoc").select2('val', '0');
    $("#sel-includeout").select2('val', '0');
    $('#gird-dispquery').clearEasyUIGrid();
    $('#gird-dispquerydetail').clearEasyUIGrid();
}

//��ӡ
function BtnPrintHandler() {
    if ($('#gird-dispquery').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert("ҳ��û������,�޷���ӡ!");
        return;
    }
    //��ȡ��������
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
	var daterange = startdatetime + " �� " + enddatetime;
	var phLocDesc = $("#sel-phaloc").select2("data")[0].text;
	var wardData = $("#sel-phaward").select2("data");
	var wardDesc="";
	if (wardData != ""){
		wardDesc = "����: " + wardData[0].text;
	}
	
	var Para = {
		title: DHCPHA_CONSTANT.SESSION.GHOSP_DESC + "��ҩ�ۺϲ�ѯͳ��",
		countDate: daterange,
		printDate: getPrintDateTime(),
		phLocDesc: phLocDesc,
    	wardDesc: wardDesc
	}
	//��ӡ���� Huxt 2019-12-25
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAIPDispQueryGenerally',
		data: {
			Para: Para,
			Grid: {type:'easyui', grid:'gird-dispquery'}
		},
		preview:false,
		listBorder: {style:2, startX:1, endX:195},
		page: {
			rows:30, 
			x:185, 
			y:2, 
			fontname:'����', 
			fontbold:'true',
			fontsize:'12', 
			format:'ҳ�룺{1}/{2}'
		}
	});
}
