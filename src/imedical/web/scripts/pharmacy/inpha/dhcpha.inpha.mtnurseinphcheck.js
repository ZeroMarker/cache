/**
 * ģ��:		�ƶ�סԺҩ��
 * ��ģ��:		�ƶ�סԺҩ��-��ʿҩ���˶�
 * createdate:	2017-04-19
 * creator:		hulihua
 */
var AuditorDr = ""
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
DhcphaTempBarCode = "";

$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker:true,
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    //�����ڿؼ�����ʼ��ֵ��
    startdate = FormatDateT("t-3");
    enddate = FormatDateT("t");
    $("#date-start").data('daterangepicker').setStartDate(startdate);
    $("#date-start").data('daterangepicker').setEndDate(startdate);
    $("#date-end").data('daterangepicker').setStartDate(enddate);
    $("#date-end").data('daterangepicker').setEndDate(enddate);
    InitPhaLoc(); //ҩ������
    SetLogPhaLoc(); //��ҩ�����Ҹ�Ĭ��ֵ��
    InitGirdPreList();
    InitGridPreIncList();
    InitGirdPreOrderList();
    /* ��Ԫ���¼� start*/
    //����ʧȥ���㴥���¼�
    $('#txt-cardno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            SetUserInfo();
        }
    });

    $('#txt-cardno').focus();

    $("#chk-audit").on("ifChanged", function () {
        QueryGridPre();
    })

    //document.onkeydown = OnKeyDownHandler;
    InitBodyStyle();
})

//ɨ��������빤��֮����֤�Լ�������
function SetUserInfo() {
    var cardno = $.trim($("#txt-cardno").val());
    $('#currentnurse').text("");
    $('#currentctloc').text("");
    if (cardno != "") {
        var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", cardno);
        if (defaultinfo == null || defaultinfo == "") {
            dhcphaMsgBox.alert("���빤���������ʵ!",'',function(){
				setTimeout(function(){
					$('#txt-cardno').focus(); 
				},500);
			});
            $('#txt-cardno').val("");
            return;
        }
        var ss = defaultinfo.split("^");
        AuditorDr = ss[0];
        $('#currentnurse').text(ss[2]);
        $('#currentctloc').text(ss[4]);
        $('#txt-cardno').val("");
    }else{
		dhcphaMsgBox.alert("����ˢ��ҩ�˵Ŀ��������빤��!",'',function(){
			setTimeout(function(){
				$('#txt-cardno').focus();
			},500);
		
		});
		return;
	}
    //QueryGridPre();
}

//ҩ�����Ҹ�Ĭ��ֵ��
function SetLogPhaLoc() {
	if (session['LOGON.WARDID']!=""){
		$("#sel-phaloc").empty();
		$('#currentctloc').parent().hide();
		
		return;
	}
}

//��ʼ����ҩ���б�table
function InitGirdPreList() {
    var columns = [{
            header: 'ID',
            index: 'TPhacID',
            name: 'TPhacID',
            width: 60,
            hidden: true
        },
        {
            header: '��ҩ����',
            index: 'TPhacNo',
            name: 'TPhacNo',
            width: 120
        },
        {
            header: '��ҩ����',
            index: 'TPhaDate',
            name: 'TPhaDate',
            width: 140
        },
        {
            header: '��ҩ��',
            index: 'TPhaDispUser',
            name: 'TPhaDispUser',
            width: 100,
            align: 'left'
        },
        {
            header: 'ȡҩ��',
            index: 'TTakeNuserUser',
            name: 'TTakeNuserUser',
            width: 100,
            align: 'left'
        },
        {
            header: '����',
            index: 'TWardDesc',
            name: 'TWardDesc',
            width: 200,
            align: 'left'
        }
    ];

    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhacList',
        height: OutFYCanUseHeight() + 120,
        recordtext: "",
        pgtext: "",
        shrinkToFit: false,
        onSelectRow: function (id, status) {
            QueryGridPreInc();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-preparelist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }

    };
    $("#grid-preparelist").dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ��ҩƷ����table
function InitGridPreIncList() {
    var columns = [{
            header: 'TPhacSub',
            index: 'TPhacSub',
            name: 'TPhacSub',
            width: 60,
            hidden: true
        },
        {
            header: 'ҩƷ����',
            index: 'TInciDesc',
            name: 'TInciDesc',
            width: 300,
            align: 'left'
        },
        {
            header: '���',
            index: 'TSpec',
            name: 'TSpec',
            width: 100
        },
        {
            header: '��λ',
            index: 'TPhacUom',
            name: 'TPhacUom',
            width: 100
        },
        {
            header: 'Ӧ������',
            index: 'TQtyTotal',
            name: 'TQtyTotal',
            width: 80
        },
        {
            header: 'ʵ������',
            index: 'TQtyActual',
            name: 'TQtyActual',
            width: 80
        },
        {
            header: '����(��װ)',
            index: 'TPackQtyActual',
            name: 'TPackQtyActual',
            width: 80
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhacIncList',
        height: OutFYCanUseHeight() * 0.7,
        multiselect: false,
        pager: "#jqGridPager", //��ҳ�ؼ���id 
        multiselect: false,
        //datatype:"local",
        shrinkToFit: false,
        onSelectRow: function (id, status) {
            QueryGridPreOrder();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-preorderlist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $("#grid-preinclist").dhcphaJqGrid(jqOptions);
}

//��ҩ��������ϸtable
function InitGirdPreOrderList() {
    var columns = [{
            header: '�ǼǺ�',
            index: 'TPatNo',
            name: 'TPatNo',
            width: 80,
            align: 'left'
        },
        {
            header: '����',
            index: 'TPatName',
            name: 'TPatName',
            width: 150,
            align: 'left'
        },
        {
            header: '��λ��',
            index: 'TBed',
            name: 'TBed',
            width: 80,
            align: 'right'
        },
        {
            header: '��ҩ����',
            index: 'TDspDate',
            name: 'TDspDate',
            width: 80,
            align: 'right'
        },
        {
            header: '��λ',
            index: 'TDspUom',
            name: 'TDspUom',
            width: 60
        },
        {
            header: 'Ӧ����',
            index: 'TDspQty',
            name: 'TDspQty',
            width: 100
        },
        {
            header: '��ҩ��',
            index: 'TQty',
            name: 'TQty',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhacOrderList',
        height: OutFYCanUseHeight() * 0.3,
        shrinkToFit: false
    };
    $("#grid-preorderlist").dhcphaJqGrid(jqOptions);
}

//��ѯ��ҩ���б�
function QueryGridPre() {
    $("#grid-preparelist").jqGrid("clearGridData");
    $("#grid-preinclist").jqGrid("clearGridData");
    $("#grid-preorderlist").jqGrid("clearGridData");
    var currentnurse = $.trim($("#currentnurse").text());
    var currentctloc = $.trim($("#currentctloc").text());
    if (currentnurse == null || currentnurse == "" || currentctloc == null || currentctloc == "") {
        dhcphaMsgBox.alert("����ˢ��ҩ�˵Ŀ��������빤��!",'',function(){
			return false
		});
        return;
    }
    var stdate = $("#date-start").val();
    var enddate =$("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
 	if (phaloc===null){
        dhcphaMsgBox.alert("����ѡ��ҩ��!");
        return;		
	}
    var chkauit = "N";
    if ($("#chk-audit").is(':checked')) {
        chkauit = "Y";
    }
    var checkflag = 0
    if (phaloc != gLocId) {
        checkflag = 1
    }
    var params = stdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + AuditorDr + tmpSplit + chkauit + tmpSplit + checkflag + tmpSplit + gLocId + tmpSplit + gWardID;

    $("#grid-preparelist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

//��ѯ��ҩ��ҩƷ����
function QueryGridPreInc() {
    var selectid = $("#grid-preparelist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-preparelist").jqGrid('getRowData', selectid);
    var phacid = selrowdata.TPhacID;
    var params = phacid;

    $("#grid-preinclist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    $("#grid-preorderlist").jqGrid("clearGridData");
}

//��ѯ��ҩ��������ϸ
function QueryGridPreOrder() {
    var selectid = $("#grid-preinclist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-preinclist").jqGrid('getRowData', selectid);
    var phacsub = selrowdata.TPhacSub;
    if (typeof (phacsub) == "undefined") {
        $("#grid-preorderlist").jqGrid("clearGridData");
        return;
    }
    var params = phacsub;
    $("#grid-preorderlist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

//��ʿ�˶�ͨ��
function PhacAuitPass() {
    var selectid = $("#grid-preparelist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-preparelist").jqGrid('getRowData', selectid);
    var phacid = selrowdata.TPhacID;
    var params = phacid;
    runClassMethod("web.DHCINPHA.MTNurseCheck.NurseCheckQuery", "SaveAuditPass", {
            'params': params
        },
        function (data) {
            if (data == -1) {
                dhcphaMsgBox.alert("δѡ����Ҫͨ���ķ�ҩ�������ʵ!");
                return;
            } else if (data == -2) {
                dhcphaMsgBox.alert("�÷�ҩ���Ѿ��˶ԣ����ʵ!");
                return;
            } else if (data == -3) {
                dhcphaMsgBox.alert("���±�����ʧ�ܣ����ʵ!");
                return;
            } else {
                dhcphaMsgBox.alert("�˶Գɹ�!");
                QueryGridPre();
                return;
            }
        });
}

//���
function ClearConditions() {
    $('#currentnurse').text("");
    $('#currentctloc').text("");
    $("#grid-preparelist").clearJqGrid();
    $("#grid-preinclist").clearJqGrid();
    $("#grid-preorderlist").clearJqGrid();
    var tmpstartdate = FormatDateT("t-2")
    $("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
    $("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
    $("#date-end").data('daterangepicker').setStartDate(new Date());
    $("#date-end").data('daterangepicker').setEndDate(new Date());
    return
    if ($("#col-right").is(":hidden") == false) {
        $("#col-right").hide();
        $("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
    } else {
        $("#col-right").show()
        $("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
    }
    $("#grid-preparelist").setGridWidth("")
    $("#grid-preinclist").setGridWidth("")
    $("#grid-preorderlist").setGridWidth("")
}

//��ҳ��table���ø߶�
function OutFYCanUseHeight() {
    var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
    var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
    var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
    var height5 = parseFloat($("[class='panel-heading']").height());
    var tableheight = $(window).height() - height1 * 2 - 2 * height3 - 2 * height4 - 2 * height5 - 125;
    return tableheight;
}

function CheckTxtFocus() {
    var txtfocus = $("#txt-cardno").is(":focus");
    if (txtfocus != true) {
        return false;
    }
    return true;
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler() {
    if (CheckTxtFocus() != true) {
        if (event.keyCode == 13) {
            $("#txt-usercode").val(DhcphaTempBarCode);
            QueryGridPre();
            DhcphaTempBarCode = "";
        } else {
            DhcphaTempBarCode += String.fromCharCode(event.keyCode)
        }
    }
    if (event.keyCode == 113) {
        PhacAuitPass();
    }
}

function InitBodyStyle() {
    $("#grid-preparelist").setGridWidth("")
}