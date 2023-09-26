/** 
 * ģ��: 	 ���������������
 * ��д����: 2019-07-27
 * ��д��:   dinghongying
 */
PHA_COM.App.Csp = "pha.prc.v2.report.main.csp";
var EpisodeId="";
var LoadAdmId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var loadWayId = ""		//���ص�������Ӧ�ĵ�����ʽ
$(function() {
    InitDict();
    InitGridFindNo();
    $("#btnFindNo").on("click", function () {
		ShowDiagFindNo(this)
	});
	$('#btnFind').on("click", Query);
	$('#btnSearch').on("click", SearchComments);
	$('#btnComfirm').on("click", Comfirm);
    $("iframe").attr("src",PRC_STORE.RunQianBG);
	InitSetDefVal() ;

});

function InitDict() {
    // ��ʼ��-����
	PHA.DateBox("conStartDate", {width:205});
	PHA.DateBox("conEndDate", {width:205});
	PHA.DateBox("conNoStartDate", {});
	PHA.DateBox("conNoEndDate", {});
	// ��ʼ��-��ѡ������
	PHA.ComboBox("conMultiDocLoc", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PHA_STORE.DocLoc().url,
		width:205
	});
	// ��ʼ������״̬
	PHA.ComboBox("conSubmit", {
		data: [{
			RowId: "1",
			Description: "δ����"
		}, {
			RowId: "2",
			Description: "������"
		}, {
			RowId: "3",
			Description: "�������"
		}, {
			RowId: "4",
			Description: "���ύ"
		}],
		panelHeight: "auto",
		width:140
	});
	// ��ʼ��������ʽ
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay("1","UNRECNTS").url,
		width:140
	});
	// ��ʼ��������� 1-���н��,2-���޽��,3-������,4-��������,5-��ҽ������
	PHA.ComboBox("conResult", {
		data: [{
			RowId: "1",
			Description: "���н��"
		}, {
			RowId: "2",
			Description: "���޽��"
		}, {
			RowId: "3",
			Description: "������"
		}, {
			RowId: "4",
			Description: "��������"
		}, {
			RowId: "5",
			Description: "��ҽ������"
		}],
		panelHeight: "auto",
		width:205
	});
	// ��ʼ���鵥���������� 1-���н��,2-���޽��,3-������,4-��������,5-��ҽ������
	PHA.ComboBox("conNoResult", {
		data: [{
			RowId: "1",
			Description: "���н��"
		}, {
			RowId: "2",
			Description: "���޽��"
		}, {
			RowId: "3",
			Description: "������"
		}, {
			RowId: "4",
			Description: "��������"
		}, {
			RowId: "5",
			Description: "��ҽ������"
		}],
		panelHeight: "auto",
		width:160
	});
	//��ʼ������ҩʦ
	PHA.ComboBox("conPharmacist", {
		url: PRC_STORE.PhaUser(),
		width:160
	});
}

/// ������Ϣ��ʼ��
function InitSetDefVal() {
	//��ѯ���ڳ�ʼ��
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.QueryStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.QueryEndDate);
		$("#conNoStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conNoEndDate").datebox("setValue", jsonColData.ComEndDate);
	});

}

/// ��ѯ
function Query() {
	var comNo = $('#conComNo').val() ;
    var params = GetParams();
    
	var StartDate = $('#conStartDate').datebox('getValue') ;
	var EndDate = $('#conEndDate').datebox('getValue') ;
	if ((StartDate == "")||(StartDate == "")){
		PHA.Alert('��ʾ', "���ڷ�Χ����Ϊ��!", 'warning');
		return ;
	}
	var firstInputStr = GetFirstTextParams() ;
	var secInputStr = GetSecTextParams() ;
	var dateRange="ͳ�����ڣ�"+StartDate+" �� "+EndDate
    var checkedRadioJObj = $("input[name='wantSelect']:checked");
    var radioValue = checkedRadioJObj.val();
	
	if ((radioValue == "")||(radioValue == undefined)){
		PHA.Alert('��ʾ', "����ѡ�񱨱�����!", 'warning');
		return ;
	}
    if (radioValue == "������Ϣ��ѯ(��������ԭ�����)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPrescForRea.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        };
		var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "������Ϣ��ѯ(���������һ���)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPrescForLoc.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "����������ϸͳ��") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPrescForAnti.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "���Ҵ��������ϸ���ͳ��") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPassRateByLoc.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "���Ҳ��ϸ񴦷�ԭ��ͳ��(���ۺϵ���)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryUnPassDataByLocRea.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "���ﴦ��������ϸͳ��") {
        var raqObj = {
            raqName: "PHA_PRC_QueryComDataDetail.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "ҩ��������ҩ������Ϣͳ��") {
        var raqObj = {
            raqName: "PHA_PRC_QueryComDataByPhaLoc.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "������Ϣͳ��(��ҽ��)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryComDataByDoctor.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } 
}

/// ��ѯ������
function SearchComments(){
	var stDate = $("#conNoStartDate").datebox('getValue') ;
	var endDate = $("#conNoEndDate").datebox('getValue') ;
	var wayId = $("#conWay").combobox('getValue')||''; 
	var result = $("#conNoResult").combobox('getValue')||'';
	var phaUserId = $("#conPharmacist").combobox('getValue')||'';
	var state = $("#conSubmit").combobox('getValue')||'';
	var parStr = wayId + "^" + result + "^" + phaUserId + "^" + state;
	
	$("#gridFindNo").datagrid("query", {
		findFlag: '1',
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: ''
	});
		
}

function Comfirm()
{
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var selPcntsNo = gridSelect.pcntNo;
	var queryStartDate = $("#conNoStartDate").datebox('getValue') ;
	var queryEndDate = $("#conNoEndDate").datebox('getValue') ;
	$('#diagFindNo').dialog('close');
	$('#conComNo').val(selPcntsNo);
	$("#conStartDate").datebox("setValue", queryStartDate);
	$("#conEndDate").datebox("setValue", queryEndDate);
}

// ��ȡ����
function GetParams() {
    var ordLocId = $("#conMultiDocLoc").combobox('getValues')||'';
	var result = $("#conResult").combobox('getValue')||'';
	var RetStr = ordLocId + "^" + result
	
    return RetStr
}

// ��ȡ������ʾֵ
function GetFirstTextParams() {
    var ordLocStr = $("#conMultiDocLoc").combobox('getText')||'';
    var ordLocData = ordLocStr.split(",")
    if (ordLocData.length>3){
		var ordLocStr = ordLocData[0]+","+ordLocData[1]+","+ordLocData[2]+"..."
	}
    if (ordLocStr==""){
	   	var OrdLocText="����˵����������ң�ȫ��"
	}
	else{
		var OrdLocText="����˵����������ң�"+ordLocStr	
	}
	
	return OrdLocText ;
}

// ��ȡ������ʾֵ
function GetSecTextParams() {
    
	var result = $("#conResult").combobox('getText')||'';
	if (result==""){
	   	var ResultText="���������ȫ��"
	}
	else{
		var ResultText="���������"+result	
	}
	var comNo = $('#conComNo').val() ;
	var ComNoText="�������ţ�"+comNo
	
	var RetTextStr = "����˵����"+ ResultText + "  " + ComNoText
	
    return RetTextStr
	
}

// ���-������
function InitGridFindNo() {
    var columns = [
        [
            { field: "pcntId", title: 'rowid', width: 80, hidden:true},
            { field: "pcntNo", title: '����',width: 150 },
            { field: 'pcntDate', title: '����', width: 100},
            { field: "pcntTime", title: 'ʱ��', width: 80 },
            { field: "pcntUserName", title: '�Ƶ���' ,width: 80},
            { field: "typeDesc", title: '����',width: 120 },
            { field: 'wayDesc', title: '��ʽ', width: 150},
            { field: "pcntText", title: '��ѯ����' ,width: 400},
            { field: "pcntState", title: '����״̬',width: 80, }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectComments',
			findFlag: '1',
			stDate: $("#conStartDate").datebox('getValue'),
			endDate: $("#conEndDate").datebox('getValue'),
			parStr: '',
			logonLocId: logonLocId,
			searchFlag: ''
        },      
        columns: columns,
        border:true,
        bodyCls:'panel-header-gray',
        toolbar: "#gridFindNoBar",
        onDblClickRow:function(rowIndex,rowData){
	         Comfirm();
		}   
    };
	PHA.Grid("gridFindNo", dataGridOption);
}

/// �򿪲鵥����
function ShowDiagFindNo(btnOpt) {
	$('#diagFindNo').dialog({
		title: "��������" + btnOpt.text,
		iconCls:  'icon-w-find' ,
		modal: true
	})
	$('#diagFindNo').dialog('open');
	
}