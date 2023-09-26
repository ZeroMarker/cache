/** 
 * ģ��: 	 ���ε����������
 * ��д����: 2020-04-17
 * ��д��:   MaYuqiang
 */
PHA_COM.App.Csp = "pha.prc.v2.report.remain.csp";
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
		url: PRC_STORE.PCNTSWay("2","RECNTS").url,
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
	// ��ʼ��������� 1-���н��,2-���޽��,3-������,4-��������,5-��ҽ������
	PHA.ComboBox("conReResult", {
		data: [{
			RowId: "1",
			Description: "���н��"
		}, {
			RowId: "2",
			Description: "���޽��"
		}, {
			RowId: "3",
			Description: "��ͨ��"
		}, {
			RowId: "4",
			Description: "����ͨ��"
		}],
		panelHeight: "auto",
		width:205
	});
	// ��ʼ���鵥���������� 1-���н��,2-���޽��,3-������,4-��������
	PHA.ComboBox("conNoResult", {
		data: [{
			RowId: "1",
			Description: "���н��"
		}, {
			RowId: "2",
			Description: "���޽��"
		}, {
			RowId: "3",
			Description: "��ͨ��"
		}, {
			RowId: "4",
			Description: "����ͨ��"
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
    var checkedRadioJObj = $("input[name='wantSelect']:checked");
    var radioValue = checkedRadioJObj.val();
	
	if ((radioValue == "")||(radioValue == undefined)){
		PHA.Alert('��ʾ', "����ѡ�񱨱�����!", 'warning');
		return ;
	}
	var firstInputStr = GetFirstTextParams() ;
	var secInputStr = GetSecTextParams() ;
	var dateRange="ͳ�����ڣ�"+StartDate+" �� "+EndDate
	
    if (radioValue == "ReComPhaIndex") {
        var raqObj = {
            raqName: "PHA_PRC_QueryRePassRateByPha.raq",
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
    } else if (radioValue == "ReComLocIndex") {
        var raqObj = {
            raqName: "PHA_PRC_QueryRePassRateByLoc.rpx",
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
    } else if (radioValue == "ReComDetail") {
        var raqObj = {
            raqName: "PHA_PRC_QueryReComDetail.rpx",
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
		findFlag: '2',
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
	var queryStartDate = $("#conNoStartDate").datebox('getValue') ;
	var queryEndDate = $("#conNoEndDate").datebox('getValue') ;
	var selPcntsNo = gridSelect.pcntNo;
	$('#diagFindNo').dialog('close');
	$('#conComNo').val(selPcntsNo);
	$("#conStartDate").datebox("setValue", queryStartDate);
	$("#conEndDate").datebox("setValue", queryEndDate);

}

// ��ȡ����
function GetParams() {
    var admLocId = $("#conMultiDocLoc").combobox('getValues')||''
	var result = $("#conResult").combobox('getValue')||'';
	var reResult = $("#conReResult").combobox('getValue')||'';
	var RetStr = admLocId + "^" + result + "^" + reResult
	
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
	   	var ResultText="���ν����ȫ��"
	}
	else{
		var ResultText="���ν����"+result	
	}
	var reResult = $("#conReResult").combobox('getText')||'';
	if (reResult==""){
	   	var reResultText="���ν����ȫ��"
	}
	else{
		var reResultText="���ν����"+reResult	
	}
	var comNo = $('#conComNo').val() ;
	var ComNoText="�������ţ�"+comNo
	
	var RetTextStr = "����˵����"+ ResultText + "  " + reResultText + "  " + ComNoText
	
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
			findFlag: '2',
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
		title: "���ε���" + btnOpt.text,
		iconCls:  'icon-w-find' ,
		modal: true
	})
	$('#diagFindNo').dialog('open');
	
}