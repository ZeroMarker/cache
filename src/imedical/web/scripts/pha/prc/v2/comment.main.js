/**
 * ����:	 ��������-��������
 * ��д��:	 dinghongying
 * ��д����: 2019-05-14
 */
PHA_COM.App.Csp = "pha.prc.v2.comment.main.csp";
PHA_COM.App.Name = "PRC.Comment.Main";
PHA_COM.App.Load = "";

var EpisodeId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var longoninfo = logonGrpId + "^" + logonLocId + "^" + logonUserId ;

$(function () {
	PatInfo = {
        pcntItm: 0,
        prescNo: 0,
        patNo: 0,
        patName: 0 ,
        patientID: 0,
		episodeID: 0,
        orditem: 0,
        zcyflag: 0
    };	
	InitSetPatInfo();
	InitGridMain();
	//InitGridDiag();
    InitGridPrescInfo();
    InitGridLog();   
    InitDiagReason("OP");										// ������ԭ�򴰿�
    InitFindNoDialog({type: "OP", callback: LoadCommentNo});	// �鵥����
    
    $("#btnFind").on("click", function () {
		ShowDiagFindNo();
	});
	$("#btnSearch").on("click", function () {
		SearchComments()
	});
	$("#btnSelect").on("click", function () {
		SelectCommentItms() ;
	});
	$("#btnDelete").on("click", function () {
		DeleteComment() ;
	});
	$("#btnSubmit").on("click", function () {
		SubmitComment() ;
	});
	//����ͨ��(����)
	$("#btnPass").on("click", function () {
		CommentOK() ;
	});
	//������ͨ��(������)
	$("#btnRefuse").on("click", function () {
		ShowDiagUnreason() ;
	});
	$("#btnAnaly").on("click", function () {
		PrescAnalyse() ;
	});
	
	$("#tabsForm").tabs({
        onSelect: function(title) {
		    // �ⲻ����,ÿ��tk��û��
		    var admData=tkMakeServerCall("web.DHCSTPIVAS.Common","GetAdmInfo",EpisodeId);
		    var patId=admData.toString().split("^")[0]||"";
			
			var gridSelect = $("#gridMain").datagrid("getSelected");
			if (gridSelect==null){
				$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĵ���!","info");
				return;
			}
			var prescNo = gridSelect.prescNo ;
			var cyflag = gridSelect.zcyflag ;	
			var EpisodeId = gridSelect.adm ;	
			var patId = gridSelect.papmi ;
			//alert("EpisodeId:"+EpisodeId)
			if (title==="ҽ����ϸ"){
				QueryPrescDetail() ;
				QueryLogDetail() ;				
			}else if (title=="����Ԥ��"){
		        if ($('#ifrmPresc').attr('src')==""||"undefined"){
			        var prescno=prescNo ;
			        var cyflag=cyflag ;
					var phartype="DHCOUTPHA";
					var paramsstr=phartype+"^"+prescno+"^"+cyflag;
		            $("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW" + "&MWToken="+websys_getMWToken());
		        } 
		    } else if (title=="�������"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
					var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N'+ "&MWToken="+websys_getMWToken();
                    $('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + EpisodeId);
				} 
		    }
        }
    });
    LoadMsgComment();
    if (gLoadPCntId === ""){
		setTimeout(function(){
			ShowDiagFindNo();
		}, 500);
    }
});


// ���-��������
function InitGridMain() {
    var columns = [
        [
            { field: "analysisResult", index:'analysisResult' , title: '������ҩ',width: 90,formatter: druguseFormatter,align:'center' },
            { field: 'passtext', title: 'Ԥ��', width: 100, hidden: true},
            { field: "patNo", title: '�ǼǺ�' ,width: 120, hidden: true},
            { field: "patName", title: '����', width: 100, hidden: true },
            { field: "sexDesc", title: '�Ա�',width: 120, hidden: true},
            { field: 'patAge', title: '����', width: 200, hidden: true},
            { field: "typeDesc", title: '�ѱ�' ,width: 120, hidden: true},
            { field: "diag", title: '���',width: 100, hidden: true },
            { field: "prescNo", index:'prescNo', title: '������',width: 180 },
            { field: 'curret', title: '�������', width: 130},
            { field: 'oriCurret', title: '�������', width: 80, hidden: true},
			{ field: "docName", title: 'ҽ��' ,width: 120, hidden: true},
            { field: "doclocDesc", title: '����' ,width: 120, hidden: true},
            { field: "adm", title: 'adm',width: 120 , hidden: true},
            { field: 'orditm', index:'orditm', title: 'orditm', width: 200, hidden: true},
            //{ field: "porcess", title: 'porcess' ,width: 120, hidden: true},
            { field: "wayCode", title: 'waycode', width: 100, hidden: true },
            { field: "pcntItm", title: '������ϸid',width: 120, hidden: true},
            { field: 'zcyflag', title: 'zcyflag', width: 200, hidden: true},
            { field: "analyResultRet", index:'�������ֵ', title: 'analyResultRet' ,width: 120, hidden: true},
            { field: "analysisData", index:'�������', title: 'analysisData' ,width: 120, hidden: true},
            { field: "manLevel", index:'���Ƶȼ�', title: 'manLevel' ,width: 120, hidden: true},
            { field: "papmi", title: 'papmi',width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentItms',
            pcntId: gLoadPCntId || "" ,
            comResult: "",
            phaUserId: ""            
        },
        columns: columns,
        toolbar: "#gridMainBar",
        onSelect:function(rowIndex,rowData){
			LoadPatInfo(rowData);
			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){			//ҽ����ϸ
				QueryPrescDetail() ;
				QueryLogDetail() ;			
			}else if (index==1){	//����Ԥ��
				var prescno = rowData.prescNo;
				var cyflag = rowData.zcyflag;
				var phartype = "DHCOUTPHA";
				var paramsstr = phartype +"^"+ prescno +"^"+ cyflag;
				$("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW" + "&MWToken="+websys_getMWToken());			
			}else if (index==2){	//�������
				var adm = rowData.adm;
				var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N' + "&MWToken=" + websys_getMWToken();
                $('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + adm);
			}
		},
		onRowContextMenu: rightClickCommentFn,
		onClickCell: function (rowIndex, field, value) {
			var rows = $(this).datagrid('getRows');
			var rowData = rows[rowIndex];
            if (field != "analysisResult") {
                return
            }
            var content = rowData.analysisData;
            DHCSTPHCMPASS.HUIAnalysisTips({
                Content: content
            })
        }				
    };
    PHA.Grid("gridMain", dataGridOption);
}

//����load Tab,����������
var HrefRefresh = function() {
    var adm = PatInfo.adm;
    var patientID = PatInfo.patientID;
    var episodeID = PatInfo.episodeID;
    var prescno = PatInfo.prescno;
    var orditem = PatInfo.orditem;
    var zcyflag = PatInfo.zcyflag;
	
    var p = Ext.getCmp("ToolsTabPanel").getActiveTab();
    var iframe = p.el.dom.getElementsByTagName("iframe")[0];

    if (p.id == "framepaallergy") {
        iframe.src = 'dhcem.allergyenter.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framerisquery") {
        iframe.src = ' dhcapp.inspectrs.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framelabquery") {
        iframe.src = 'dhcapp.seepatlis.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1';
    }

    if (p.id == "frameprbrowser") {
        //iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
        var LocID = session['LOGON.CTLOCID'];
        //iframe.src = p.src + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
        iframe.src = 'emr.browse.manage.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
    }


    //��ϸ
    if (p.id == "frameordquery") {
        if (adm == 0) return;
        FindDiagData(adm);
        FindOrdDetailData(prescno);
        FindLogData(orditem);
        CheckArcExist(prescno);
    }

    //����Ԥ��
    if (p.id == "prescriptioninfo") {
        if (zcyflag == 0) {
            iframe.src = 'dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        } else {
            iframe.src = 'dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        }
    }

    //����ҽ��
    if (p.id == "frameadmordquery") {
        //iframe.src = p.src + '?EpisodeID=' + adm;
        iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
    }
};

function InitGridDiag() {
    var columns = [
        [
            { field: "diag", title: '���',width: 620, }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectDiagList',
			adm: ''
        },
        columns: columns,
        pagination: false  
    };
    PHA.Grid("gridDiag", dataGridOption);
}

function InitGridPrescInfo() {
    var columns = [
        [
            { field: "arcitmdesc", title: 'ҽ������',width: 200 },
            { field: "qty", title: '����',width: 80 },
            { field: "uomdesc", title: '��λ',width: 80 },
            { field: "dosage", title: '����',width: 120 },
            { field: "freq", title: 'Ƶ��',width: 120 },
            //{ field: "spec", title: '���',width: 120 },		ҽ���������֮��ҽ�����ȷ��Ψһ�Ĺ��
            { field: "instruc", title: '�÷�',width: 120 },
            { field: "duration", title: '��ҩ�Ƴ�',width: 120 },
            { field: "realdura", title: 'ʵ���Ƴ�',width: 80 },
            //{ field: "form", title: '����',width: 120 },
            { field: "basflag", title: '����ҩ��',width: 80 },
            { field: "doctor", title: 'ҽ��',width: 120 },
            { field: "orddate", title: 'ҽ����������',width: 120 },
            { field: "remark", title: 'ҽ����ע',width: 120 },
            //{ field: "manf", title: '����',width: 120 },
            { field: "orditm", title: 'orditm',width: 120,hidden:true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectPrescDetail',
			prescNo: ''
        },
		border: false,
        pagination:false,
        pageSize:100,
        columns: columns,
        toolbar: [], //"#gridPrescInfotableBar",
        onClickRow:function(rowIndex,rowData){
	        if (rowData){
		        
			}   
		},
		onRowContextMenu: rightClickYDTSFn
    };
    PHA.Grid("gridPrescInfo", dataGridOption);
}

function InitGridLog() {
    var columns = [
        [
            { field: "grpNo", title: '���',width: 50, },
            { field: "reasonDesc", title: '����ԭ��',width: 300,
            	formatter:function(v){
					return v.replace('������','<span style="color:#999999">������</span>')
				} 
			},
            { field: "patName", title: '����',width: 120, hidden: true },
            { field: "prescNo", title: '������',width: 120, hidden: true },
            { field: "comDate", title: '��������',width: 120, },
            { field: "comTime", title: '����ʱ��',width: 120, },
            { field: "comUserName", title: '������',width: 120, },
            { field: "comResult", title: '�������',width: 120, },
            { field: "factorDesc", title: '������ʾֵ',width: 120, },
            { field: "adviceDesc", title: 'ҩʦ����',width: 120, },
            { field: "phaNote", title: 'ҩʦ��ע',width: 120, },
            { field: "docAdvice", title: 'ҽ������',width: 120, hidden:true},
            { field: "docNote", title: 'ҽ����ע',width: 120, },
            { field: "reSaveFlag", title: '���ε���',width: 70, },
            { field: "active", title: '��Ч',width: 60, }
            
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentLog' ,
			pcntItm: ''
        },
        columns: columns,
        toolbar:[],
		border: false,
        pagination: false
    };
    PHA.Grid("gridLog", dataGridOption);
}

/// �򿪹���������ԭ���ҽ������
function ShowDiagUnreason() {	
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĵ���!","info");
		return;
	}
	var pItmResult = gridSelect.curret ;		//�������
	/*
	if (pItmResult.indexOf("����")>0){
		$.messager.alert('��ʾ',"�ô���Ϊ�ѽ���״̬���������ٴε���!","info");
		return;
	}
	*/
	var pcntsItmId = gridSelect.pcntItm ;		//�����ӱ�id
	var pcntsAuth = tkMakeServerCall("PHA.PRC.Create.Main","ChkItmComAuth",longoninfo,pcntsItmId)			//��ȡ����Ȩ��
	if (pcntsAuth !== "1"){
		var pcntsAuthData = pcntsAuth.split("^")
		$.messager.alert('��ʾ',pcntsAuthData[1],"info");
		return;
	}
	var prescNo = gridSelect.prescNo;
	showDialogSelectReason(prescNo, pcntsItmId, SaveCommentResult);
}

function LoadCommentNo(param){
	ClearCommentGrid();
	if (param.loadWayCode == "RE"){
		$('#gridMain').datagrid('showColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 80;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 130;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 100;
		$('#btnPass').linkbutton({text:'ͨ��'});
		$('#btnRefuse').linkbutton({text:'��ͨ��'});
	}else{
		$('#gridMain').datagrid('hideColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 90;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 150;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 130;
		$('#btnPass').linkbutton({text:'����'});
		$('#btnRefuse').linkbutton({text:'������'});
	} 
	$('#gridMain').datagrid('query', param);	
}

function LoadMsgComment(){
	if (gWayCode === "RE"){
		$('#gridMain').datagrid('showColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 80;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 130;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 100;
		$('#btnPass').linkbutton({text:'ͨ��'});
		$('#btnRefuse').linkbutton({text:'��ͨ��'});
	}else{
		$('#gridMain').datagrid('hideColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 90;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 150;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 130;
		$('#btnPass').linkbutton({text:'����'});
		$('#btnRefuse').linkbutton({text:'������'});
	}
}


// ***********************������÷��� Start ************************
function QueryDiag(){
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĵ���!","info");
		return;
	}
	var adm=gridSelect.adm;
    $('#gridDiag').datagrid('query', {
        adm: adm
    });	
}

///��ȡ������ϸ��Ϣ
function QueryPrescDetail() {
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĵ���!","info");
		return;
	}
	var prescNo=gridSelect.prescNo;
    $('#gridPrescInfo').datagrid('query', {
        prescNo: prescNo
    });
}

///��ȡ������־��Ϣ
function QueryLogDetail() {
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĵ���!","info");
		return;
	}
	var pcntItm=gridSelect.pcntItm;
    $('#gridLog').datagrid('query', {
        pcntItm: pcntItm
    });
}

function CommentOK(){
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĵ���!","info");
		return;
	}
	var pItmResult = gridSelect.curret ;		//�������
	var pcntItm = gridSelect.pcntItm ;		//������ϸ��id
	var result = "Y"
	var reasonstr = ""
	var input = ""	
	SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;
}

// ��������������
function SaveCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr){
	var OKRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SaveComItmResult',
			pcntItm: pcntItm,
			result: result,
			longoninfo: longoninfo,
			reasonstr: reasonIdStr,
			input: remarkStr ,		
			dataType: 'text'
		}, false);

	var RetArr = OKRet.split('^');
	var RetVal = RetArr[0];
	var RetInfo = RetArr[1];	
	if (RetVal < 0) {
		PHA.Alert('��ʾ', RetInfo, 'warning');
		return;
	} else {
		var gridSelect = $("#gridMain").datagrid("getSelected");
		var seqNo = $('#gridMain').datagrid('getRowIndex',gridSelect);
		if (result=="Y"){
			if (FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("ͨ��")
			}else {
				var ResultDesc = $g("����")
			}	
		}else if (result=="N"){
			if (FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("��ͨ��")	
			}else {
				var ResultDesc = $g("������")
			}	
		}else{
			var ResultDesc = ""			
		}
		$("#gridMain").datagrid('updateRow', {
			index: seqNo,
			row: { curret: ResultDesc }
		})
		$("#gridMain").datagrid('selectRow', seqNo);
	}
}

/// �Ҽ�һ������
function rightClickCommentFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //��ֹ����ð��
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_comment' + ' data-options="' + "iconCls:'icon-export-all'" + '">'+$g("һ������")+'</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_comment").on("click", function () {
		AllCommontOk();
	})
}

function AllCommontOk(){
	var rows = $("#gridMain").datagrid("getRows");
	for (var i = 0; i < rows.length; i++) {
		var analyResultRet = rows[i].analyResultRet;
		if (analyResultRet==0){
			var pcntItm = rows[i].pcntItm ;		//������ϸ��id
			var result = "Y"
			var reasonstr = ""
			var input = ""
            SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;	
		}
	}
	$("#gridMain").datagrid("reload");
}

function ClearCommentGrid(){
	InitSetPatInfo() ;
	$("#gridPrescInfo").datagrid("clear");
	$("#gridLog").datagrid("clear");
}

//��������
function PrescAnalyse(){
	var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
	if (passTypeInfo==""){
		$.messager.alert('ע��',"δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����!","info");
		return;
	}
	//alert("passType:"+passType)
	var passTypeData=passTypeInfo.split("^")
	var passType=passTypeData[0]
	if (passType=="DHC"){
		// ����֪ʶ��
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "gridMain", 
		 	MOeori: "orditm",
		 	PrescNo:"prescNo", 
		 	GridType: "EasyUI", 
		 	Field: "analysisResult",
		 	ResultField:"analysisData",
		 	manLevelFleld:"analyResultRet",
		 	ManLevel: "manLevel"
		 });
	}else if (passType=="DT"){
		dhcphaMsgBox.alert("�ӿ���δ����");
		
	}else if (passType=="MK"){
		dhcphaMsgBox.alert("�ӿ���δ����")
		// ����
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
		dhcphaMsgBox.alert("�ӿ���δ����")
	}
}


// ҩ����ʾ
function rightClickYDTSFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //��ֹ����ð��
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_YDTS' + ' data-options="' + "iconCls:'icon-tip'" + '">'+$g("ҩ����ʾ")+'</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_YDTS").on("click", function () {
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if (passType==""){
			PHA.Alert("��ʾ","δ����ҩ��ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����",'warning');
			return;
		}
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			// ����֪ʶ��
			var ordSelect = $("#gridPrescInfo").datagrid("getSelected");
			if((ordSelect=="")||(ordSelect==null)){
				PHA.Alert("��ʾ","����ѡ����Ҫ�鿴ҩ����ʾ����ϸ��¼!",'warning');
				return;
			}
			var userInfo = logonUserId + "^" + logonLocId + "^" + logonGrpId;
			var incDesc = ordSelect.arcitmdesc;
			var selOrdItm = ordSelect.orditm
			DHCSTPHCMPASS.MedicineTips({
				Oeori: selOrdItm,
				UserInfo: userInfo,
				IncDesc: incDesc
			})
		}else if (passType=="MK"){
			// ����
			MKPrescYDTS(selOrdItm); 
		}else if (passType=="YY"){
		}		
	})
}

    
/********************** ��������������ҩ start   **************************/
//������������
function MKPrescAnalyse() {
    var rows = $("#gridMain").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescNo;
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = "warningnull.gif"
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// ����
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        var str = "<img id='analysisResult" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
		$("#gridMain").datagrid('updateRow', {
			index: i,
			row: {
				analysisResult: str,
				analyResultRet: myrtn
			}
		})
    }
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //������鷵�ش���
	MKXHZY1(prescno,flag);
	//��Ϊͬ������,ȡ��McPASS.ScreenHighestSlcode
	//��Ϊ�첽����,����ûص���������.
	//ͬ���첽ΪMcConfig.js MC_Is_SyncCheck true-ͬ��;false-�첽
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
        if (result > 0) {
        } else {
            //alert("û����");
        }
	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
		
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// ���˱���
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // סԺ����
	ppi.Name = PatArr[1];				// ��������
	ppi.Sex = PatArr[2];				// �Ա�
	ppi.Birthday = PatArr[3];			// ��������
	
	ppi.HeightCM = PatArr[5];			// ���
	ppi.WeighKG = PatArr[6];			// ����
	ppi.DeptCode  = PatArr[8];			// סԺ����
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// ҽ��
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// ʹ��ʱ��
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//ҩƷ���
        drug.OrderNo =OrderArr[0]; 		        		//ҽ����
        drug.DrugUniqueCode = OrderArr[1];  	//ҩƷ����
        drug.DrugName =  OrderArr[2]; 			//ҩƷ����
        drug.DosePerTime = OrderArr[3]; 	   //��������
		drug.DoseUnit =OrderArr[4];   	        //��ҩ��λ      
        drug.Frequency =OrderArr[5]; 	        //��ҩƵ��
        drug.RouteCode = OrderArr[8]; 	   		//��ҩ;������
        drug.RouteName = OrderArr[8];   		//��ҩ;������
		drug.StartTime = OrderArr[6];			//����ʱ��
        drug.EndTime = OrderArr[7]; 			//ͣ��ʱ��
        drug.ExecuteTime = ""; 	   				//ִ��ʱ��
		drug.GroupTag = OrderArr[10]; 	       //������
        drug.IsTempDrug = OrderArr[11];          //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
        drug.OrderType = 0;    //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //�������ұ���
        drug.DeptName =  PrescMInfo[4]; 	  //������������
        drug.DoctorCode =PrescMInfo[6];   //����ҽ������
        drug.DoctorName =PrescMInfo[2];     //����ҽ������
		drug.RecipNo = "";            //������
        drug.Num = OrderArr[15];                //ҩƷ��������
        drug.NumUnit = OrderArr[16];            //ҩƷ����������λ          
        drug.Purpose = 0;             //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
		drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
		drug.Remark = "";             //ҽ����ע 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //���  
      	allergen.AllerCode = AllergenArr[0];    //����
      	allergen.AllerName = AllergenArr[1];    //����  
      	allergen.AllerSymptom =AllergenArr[3]; //����֢״     	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//����״̬������
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//������
     	medcond.DiseaseCode = MedCondArr[0];        //��ϱ���
      	medcond.DiseaseName = MedCondArr[1];     //�������
 		medcond.RecipNo = "";              //������
      	arrayMedCond[arrayMedCond.length] = medcond;          
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

/// ����ҩ����ʾ
function MKPrescYDTS(orditm){
	//alert("orditm:"+orditm)
	var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",orditm)
	//alert("ordInfoStr:"+ordInfoStr)
	var ordInfo = ordInfoStr.split("^")
	var prescNo = ordInfo[10]
	var incicode = ordInfo[8]
	var incidesc = ordInfo[9]
	var cyFlag =  ordInfo[11]		//��ҩ��־
	
	MCInit1(prescNo);
	HisQueryData(incicode,incidesc);
	if (cyFlag == "Y"){
		MDC_DoRefDrug(24)	
	}else {
		MDC_DoRefDrug(11)
	}	
}

function HisQueryData(incicode,incidesc) {   
    var drug = new Params_MC_queryDrug_In();
    drug.ReferenceCode = incicode; //��ѯҩƷ�ı���
    drug.CodeName =incidesc;  //��ѯҩƷ������           
    MC_global_queryDrug = drug;   //��ֵ��ȫ�ֱ���
}


//********************** ��������������ҩ end   **************************/ 

//��ʽ����
function druguseFormatter(cellvalue, options, rowdata){
	//alert("cellvalue:"+cellvalue)
	if (cellvalue==undefined){
		cellvalue="";
	}
	/*if (cellvalue!=""){
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			var cellvalue = (cellvalue == 1) ? 0 : 1;
		}
	} */
	var imageid="";
	if (cellvalue=="0"){
		imageid="warning0.gif";
	}else if (cellvalue=="1"){
		imageid="yellowlight.gif";
	}else if (cellvalue=="2"){
		imageid="warning2.gif"
	}
	else if (cellvalue=="3"){
		imageid="warning3.gif"
	}
	else if (cellvalue=="4"){
		imageid="warning4.gif"
	}
	if (imageid==""){
		return cellvalue;
	}
	return '<img src="../scripts/pharmacy/images/'+imageid+'" ></img>'
}

// ***********************������÷��� End ************************