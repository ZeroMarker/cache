/**
 * ����:	 ��������-��������
 * ��д��:	 dinghongying
 * ��д����: 2019-05-14
 */

//document.write("<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>");
//document.write("</object>");
PHA_COM.App.Csp = "pha.prc.v2.comment.main.csp";
PHA_COM.App.Name = "PRC.Comment.Main";
PHA_COM.App.Load = "";
var EpisodeId="";
var LoadAdmId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var loadWayId = gLoadWayID ;		//���ص�������Ӧ�ĵ�����ʽ
var loadPcntId = gLoadPCntId ;
var loadWayCode = "" ;				//������ʽ����
var longoninfo = logonGrpId + "^" + logonLocId + "^" + logonUserId ;
var colWidth = 20 ;
var hiddenFlag = true ;
var selResult = ""		//�������
var selPhaUserId = ""	//����ҩʦ
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
	InitDict();
	InitSetDefVal();
	InitSetPatInfo();
	InitGridMain();
	InitGridDiag();
    InitGridPrescInfo();
    InitGridLog();   
    InitGridFindNo();
	InitReasonTreeGrid() ;		// ��ѡȡ�����������
	InitGridLinkOrd();
    InitGridQuestion();
    $("#btnFind").on("click", function () {
		ShowDiagFindNo(this)
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
		//CommentBad()
		ShowDiagUnreason(this) ;
	});
	//������ͨ��(������)
	$("#btnAnaly").on("click", function () {
		PrescAnalyse() ;
	});
	//�������������ԭ�����Ϣ
	$("#btnSave").on("click", function () {
		saveReason() ;
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
			
			if (title=="����Ԥ��"){
		        if ($('#ifrmPresc').attr('src')==""||"undefined"){
			        var prescno=prescNo ;
			        var cyflag=cyflag ;
					var phartype="DHCOUTPHA";
					var paramsstr=phartype+"^"+prescno+"^"+cyflag;
		            $("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
		        } 
		    }
	        else if (title=="�������"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?PatientID='+ patId + '&EpisodeID=' + EpisodeId + '&EpisodeLocID=' + logonLocId );
		        } 
		    }else if (title=="������¼"){
			    if ($('#ifrmAllergy').attr('src')==""||"undefined"){
					$('#ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId); 
			    }
			}else if (title=="����¼"){
				if ($('#ifrmRisQuery').attr('src')==""||"undefined"){
					$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);
				}
			}else if (title=="�����¼"){
				if ($('#ifrmLisQuery').attr('src')==""||"undefined"){
					$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + EpisodeId+'&NoReaded='+'1'+'&PatientID='+patId); 
				}
			}else if (title=="����ҽ��"){
				if ($('#ifrmOrdQuery').attr('src')==""||"undefined"){
					//$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + EpisodeId+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
					$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?PatientID=' + patId+'&EpisodeID=' + EpisodeId+'&mradm=' + EpisodeId+'&OpenWinName=OPDocRecAdm');
					//$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?EpisodeID=' + EpisodeId);
				} 
			}
        }
    });

});

// �ֵ�
function InitDict() {
	// ��ʼ��-����
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	// ��ʼ��������ʽ
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay("1","CNTS").url,
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
		width:160
	});
	//��ʼ������ҩʦ
	PHA.ComboBox("conPharmacist", {
		url: PRC_STORE.PhaUser(),
		width:160
	});
	// ��ʼ������״̬
	PHA.ComboBox("comState", {
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
	PHA.ComboBox("conWarn", {
		url: PRC_STORE.Factor(),
		width:333
	});
	PHA.ComboBox("conAdvice", {
		url: PRC_STORE.PhaAdvice(),
		width:333
	});
}

/// ������Ϣ��ʼ��
function InitSetDefVal() {
	//��������
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.ComEndDate);
		// ���ε������ñ�־
		if (jsonColData.ReCntFlag == "Y")
		{
			width = 0 ;
			hiddenFlag = false ;
		}
		if (jsonColData.DefaultLogonUser == "Y")
		{
			var phaFlag=tkMakeServerCall("PHA.PRC.Com.Util","ChkPharmacistFlag",logonUserId)
			if (phaFlag=="Y"){	//������¼��Ϊ��ά����ҩʦʱ��Ĭ��
				$("#conPharmacist").combobox("setValue", logonUserId);
			}
		}
		//��ʼ�������Ƿ����ö��ε�����־���첽���⣬��ʼ�������б����
		//InitGridMain(); 
		
	});
	
	
}

function InitSetPatInfo(){	
	var imageid="icon-unmale.png";
	var emptyMsg="����ѡ��һ������"		
	var pathtml=""
	pathtml+='<div style="position: absolute;top: 0px;left: 0px;">'
		pathtml+='<img src=/imedical/web/scripts/pharmacy/images/'+imageid+' style="border-radius:35px;height:50px;width:50px;">';
	pathtml+='</div>';	
	pathtml+='<div style="margin-top:17px;padding-left:35px">'
		pathtml+='<div style="line-height:25px">';
			pathtml+='<span style="font-size:14px;color:#666666">'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+emptyMsg+'</span>'
		pathtml+='</div>';
	pathtml+='</div>';
	$("#dhcpha-patinfo").append(pathtml);
	
}


// ���-��������
function InitGridMain() {
    var columns = [
        [
            { field: "analysisResult", index:'analysisResult' , title: '������ҩ',width: 70+colWidth,formatter: druguseFormatter },
            { field: 'passtext', title: 'Ԥ��', width: 100, hidden: true},
            { field: "patNo", title: '�ǼǺ�' ,width: 120, hidden: true},
            { field: "patName", title: '����', width: 100, hidden: true },
            { field: "sexDesc", title: '�Ա�',width: 120, hidden: true},
            { field: 'patAge', title: '����', width: 200, hidden: true},
            { field: "typeDesc", title: '�ѱ�' ,width: 120, hidden: true},
            { field: "diag", title: '���',width: 100, hidden: true },
            { field: "prescNo", index:'prescNo', title: '������',width: 120+colWidth },
            { field: 'curret', title: '�������', width: 100+colWidth},
            { field: 'oriCurret', title: '�������', width: 80, hidden: hiddenFlag},
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
            pcntId: loadPcntId ,
            comResult: selResult,
            phaUserId: selPhaUserId
            
        },
        columns: columns,
        toolbar: "#gridMainBar",
        onClickRow:function(rowIndex,rowData){
			//$("#dhcpha-patinfo").append("");
			$("#dhcpha-patinfo").empty();
			var patordinfo='';
			var pcntItm = rowData.pcntItm ;
			var prescNo = rowData.prescNo ;
			var patNo = rowData.patNo ;
			var patName = rowData.patName ;
			var sexDesc = rowData.sexDesc ;
			var patAge = rowData.patAge ;
			var adm = rowData.adm ;
			var papmi = rowData.papmi ;
			var orditm = rowData.orditm ;
			var zcyflag = rowData.zcyflag ;
			var typeDesc = rowData.typeDesc ;		//���߷ѱ�
			var doclocDesc = rowData.doclocDesc ;	//�������
			var patDiag = "��ϣ�"+rowData.diag ;			//�������
			//HLYYPreseCheck(prescNo,1) ;
			var imageid="";
			if (sexDesc=="Ů"){  //��Ů����
				imageid="icon-female.png";
			}else if (sexDesc=="��"){
				imageid="icon-male.png";
			}else{
				imageid="icon-unmale.png";
			}
						
			patordinfo='<span>'+prescNo+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+patNo+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+sexDesc+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+patAge+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+typeDesc+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+doclocDesc+'&nbsp;&nbsp;</span>'+'&nbsp;&nbsp;';
			
			var pathtml=""
			pathtml+='<div style="position: absolute;top: 0px;left: 0px;">'
				pathtml+='<img src=/imedical/web/scripts/pharmacy/images/'+imageid+' style="border-radius:35px;height:50px;width:50px;">';
			pathtml+='</div>';	
			pathtml+='<div style="padding-left:60px">'
				pathtml+='<div style="line-height:25px;padding-top:0px">';
					pathtml+='<span style="font-size:14px;">'+patName+'&nbsp;&nbsp;&nbsp;</span>'+patordinfo;
				pathtml+='</div>';
				pathtml+='<div style="line-height:25px">';
					pathtml+='<span>'+patDiag+'</span>'
				pathtml+='</div>';
			pathtml+='</div>';
			pathtml+='</div>';
			
			$("#dhcpha-patinfo").append(pathtml);
			$("#patDiag").tooltip({
		        content: $("#patDiag").text(),
		        position: 'bottom',
		        showDelay: 500
		    });
			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){			//ҽ����ϸ
				QueryPrescDetail() ;
				QueryLogDetail() ;			
			}else if (index==1){	//����Ԥ��
				var prescno=prescNo ;
				var cyflag=zcyflag ;
				var phartype="DHCOUTPHA";
				var paramsstr=phartype+"^"+prescno+"^"+cyflag;
				$("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");			
			}else if (index==2){	//������¼
				$('#ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp'+'?EpisodeID=' + adm+'&PatientID='+papmi);		
			}else if (index==3){	//����¼
				$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + adm+'&PatientID='+papmi);			
			}else if (index==4){	//�����¼
				$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + adm+'&NoReaded='+'1'+'&PatientID='+papmi);			
			}else if (index==5){	//�������
				 $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?PatientID='+ papmi + '&EpisodeID=' + adm + '&EpisodeLocID=' + logonLocId );			
			}else if (index==6){	//����ҽ��
				//$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + adm+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
				$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?PatientID=' + papmi+'&EpisodeID=' + adm+'&mradm=' + adm+'&OpenWinName=OPDocRecAdm');
		
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
        iframe.src = 'emr.browse.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
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
            { field: "factorDesc", title: '���ϸ�ʾֵ',width: 120, },
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
        pagination: false 
		//fitColumns: true 
		//shrinkToFit:false
		  
    };
    PHA.Grid("gridLog", dataGridOption);
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
            { field: "pcntState", title: '����״̬',width: 80 },
            { field: 'pcntWayCode', title: '��ʽ����', width: 200, hidden: true},
			{ field: 'pcntWayId', title: '��ʽ', width: 200, hidden: true}
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
        toolbar: "#gridFindNoBar",
        border: true ,
        bodyCls:'panel-header-gray',
        onDblClickRow:function(rowIndex,rowData){
	         SelectCommentItms() ;
		}   
    };
	PHA.Grid("gridFindNo", dataGridOption);
}

//************************* ѡȡ����ԭ��������ݳ�ʼ�� Start *****************************

function InitReasonTreeGrid() {
	PHA.Tree("gridReason",{})
	$.cm({
		ClassName: 'PHA.PRC.Com.Store',
		MethodName: 'GetPRCReasonTree',
		wayId: loadWayId , 
		ParentId: ''
	},function(data){
		$('#gridReason').tree({
			lines: false,
			data: data			
		});
		
	});

}

/// ����ԭ����˫���¼�
$('#gridReason').tree({
	onDblClick: function(node){
		treeClickEvent(node) ;		
	}
});

//��ʼ�����-ԭ�����ҽ��
function InitGridLinkOrd() {
    var columns = [
        [
            { field: "ordDesc", title: 'ҽ������',width: 270, },
            { field: "orditm", title: 'orditm', width: 80, hidden : true },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectOrdDetail',
			input :''
        },
        columns: columns,
        pagination: false,
        onDblClickRow:function(rowIndex,rowData){
			var orditm = rowData.orditm ;
			var ordDesc = rowData.ordDesc ;
			OrderClickEvent(orditm, ordDesc) ;
		}   
    };
    PHA.Grid("gridLinkOrder", dataGridOption);
}

//��ʼ�����-�����б�
function InitGridQuestion() {
    var columns = [
        [
            { field: "desc", title: '����', width: 300,
            formatter:function(v){
					return v.replace('������','<span style="color:#999999">������</span>')
				}  },			
            { field: "level", title: '�ּ�', width: 80 },
			{ field: "rowid", title: 'rowid', width:100, hidden:true} 
        ]
    ];
    var dataGridOption = {
       // url: $URL,
        //queryParams: {
       //     ClassName: '',
       //     QueryName: ''
       // },
        columns: columns,
        pagination: false,
        toolbar: "#gridQuestionBar",
        onDblClickRow:function(rowIndex,rowData){
			$('#gridQuestion').datagrid('deleteRow', rowIndex);
		}   
    };
    PHA.Grid("gridQuestion", dataGridOption);
}



//************************* ѡȡ����ԭ��������ݳ�ʼ�� End *****************************

//**************************** �������浯�� Start ***********************
/// �򿪲鵥����
function ShowDiagFindNo(btnOpt) {
	$('#diagFindNo').dialog({
		title: "��������" + btnOpt.text,
		iconCls:  'icon-w-find', 
		modal: true
	})
	$('#diagFindNo').dialog('open');
	
}

/// �򿪹���������ԭ���ҽ������
function ShowDiagUnreason(btnOpt) {
	
	ClearQuestionGrid() ;
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
	
	$('#diagSelectReason').dialog({
		title: "������ԭ��" ,
		iconCls:  'icon-w-list' ,
		modal: true
	})
	$('#diagSelectReason').dialog('open');
	
	var prescNo = gridSelect.prescNo;
	
	$('#gridLinkOrder').datagrid('query', {
        input: prescNo
    });
	
}

//**************************** �������浯�� End ***********************

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

/// ��ѯ������
function SearchComments(){
	var stDate = $("#conStartDate").datebox('getValue') ;
	var endDate = $("#conEndDate").datebox('getValue') ;
	var wayId = $("#conWay").combobox('getValue')||''; 
	var result = $("#conResult").combobox('getValue')||'';
	var phaUserId = $("#conPharmacist").combobox('getValue')||'';
	var state = $("#comState").combobox('getValue')||'';
	var parStr = wayId + "^" + result + "^" + phaUserId + "^" + state
	
	$("#gridFindNo").datagrid("query", {
		findFlag: '1',
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: ''
	});
		
}

/// ѡȡ��������Ϣ
function SelectCommentItms(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
		loadPcntId = pcntId
		loadWayId = gridSelect.pcntWayId ;
		loadWayCode = gridSelect.pcntWayCode ;
		selResult = $("#conResult").combobox('getValue')||'';
		selPhaUserId = $("#conPharmacist").combobox('getValue')||'';
	if (loadWayCode == "RE"){
		hiddenFlag = false ;
		colWidth = 0 ;
		$('#btnPass').linkbutton({text:'ͨ��'});
		$('#btnRefuse').linkbutton({text:'��ͨ��'});
	}
	else {
		hiddenFlag = true ;
		colWidth = 20 ;
		$('#btnPass').linkbutton({text:'�ϸ�'});
		$('#btnRefuse').linkbutton({text:'���ϸ�'});
	}
		InitGridMain();
	$('#diagFindNo').dialog('close');
	ClearCommentGrid() ;
	InitReasonTreeGrid() ;		//ѡȡ�����������ܻ�ȡ��������ʽId
}

/// ɾ��������
function DeleteComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		var deleteRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'DeleteComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
	
		var deleteRet = deleteRet.toString() ;
		var deleteArr = deleteRet.split('^');
		var deleteVal = deleteArr[0];
		var deleteInfo = deleteArr[1];
		
		if (deleteVal < 0) {
			PHA.Alert('��ʾ', deleteInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
	
}

/// �ύ������
function SubmitComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	var subInfo = "��ȷ���ύ��?�ύ������ȡ���ύ��"
	PHA.Confirm("�ύ��ʾ", subInfo, function () {
		var submitRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SubmitComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
		
		var submitRet = submitRet.toString() ;
		var submitArr = submitRet.split('^');
		var submitVal = submitArr[0];
		var submitInfo = submitArr[1];
		
		if (submitVal < 0) {
			//PHA.Alert('��ʾ', submitVal+"^"+submitInfo, 'warning');
			PHA.Alert('��ʾ', submitInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '�ύ�ɹ�',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
	
}

function CommentOK()
{
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
	var pcntItm = gridSelect.pcntItm ;		//������ϸ��id
	var result = "Y"
	var reasonstr = ""
	var input = ""
	
	SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;

}

function treeClickEvent(node)
{
	if (node.isLeaf=="N"){
		var reasonId = node.id ;  	
		var reasonDesc = node.text ;
		if (reasonId==""){
			return;
		}
		
		var gridChanges = $('#gridQuestion').datagrid('getChanges');
		var gridChangeLen = gridChanges.length;
		for (var counter = 0; counter < gridChangeLen; counter++) {
			var quesData = gridChanges[counter];
			var selReasonId = quesData.rowid|| "" ;
			
			if (selReasonId==reasonId){
				PHA.Alert('��ʾ', '��ԭ���Ѵ���,�����ظ����', 'warning');
				return;		
			}		
	
		}
		$("#gridQuestion").datagrid('appendRow', {
				desc : reasonDesc ,
				level : '' ,
				rowid : reasonId
			});
			
	}

}

function OrderClickEvent(selOrdItm, selOrdDesc)
{
	if (selOrdItm==""){
		return;
	}
	var gridChanges = $('#gridQuestion').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen=="0"){		
		PHA.Alert('��ʾ', '����˫��ѡ�񲻺���ԭ��,Ȼ�������ԣ�', 'warning');
		return;
	}
	var reasonRowId = ""	// ԭ��Id
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selRowid = quesData.rowid|| "" ;
		if (selOrdItm==selRowid){
			PHA.Alert('��ʾ', '��ҽ���Ѵ���,�����ظ����', 'warning');
			return;		
		}		
	}
	lastData = gridChanges[(gridChangeLen-1)]
	var lastRowId = lastData.rowid|| "" ;
	//alert("selOrdItm:"+selOrdItm)
	var selOrdDesc =  "������&nbsp;&nbsp;"+selOrdDesc
	$("#gridQuestion").datagrid('appendRow', {
			desc : selOrdDesc ,
			level :  selOrdItm ,	//lastRowId,
			rowid : selOrdItm
		});	
	

}

function saveReason()
{
	var gridChanges = $('#gridQuestion').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	//alert("gridChangeLen:"+gridChangeLen)
	if (gridChangeLen=="0"){		
		PHA.Alert('��ʾ', '���������б��м����������ҽ��,Ȼ�������ԣ�', 'warning');
		return;
	}
	var reasonIdStr = ""
	var levelflag = 0; chkexistflag=0;
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selReasonId = quesData.rowid|| "" ;
		var selLevel = quesData.level|| "" ;
		var selDesc = quesData.desc|| "" ;
		var selDescData = selDesc.split("������")
		var selDescVal = selDescData[1]
		if (selLevel != ""){
			if (reasonIdStr==""){
				PHA.Alert('��ʾ', '�������'+selDescVal+' ��Ӧ�Ĳ�����ԭ��,Ȼ�������ԣ�', 'warning');
				return;	
			}
			reasonIdStr=reasonIdStr+"$$$"+selReasonId ;
		    levelflag=1;
		    chkexistflag=1;						
		}
		else {
			if (reasonIdStr == ""){
				reasonIdStr = selReasonId ;				
			}
			else {
				if (levelflag == 1){
					reasonIdStr=reasonIdStr+"!"+selReasonId ;
		  			levelflag=0;
				}
				else {
					reasonIdStr=reasonIdStr+"^"+selReasonId ;				
				}
			}
			
		}
	}	
	if (chkexistflag==0){
		PHA.Alert('��ʾ', '���������б��м����������ҽ��,Ȼ�������ԣ�', 'warning');
		return;
	}	
	var factorId = $("#conWarn").combobox('getValue')||'';		//��ʾֵ
	var adviceId = $("#conAdvice").combobox('getValue')||''; 		//����	
	var phnoteDesc = $.trim($("#conPhNote").val());				//��ע
	
	var remarkStr = factorId+"^"+adviceId+"^"+phnoteDesc ;	
	
	//$('#diagSelectReason').dialog('close');
	
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĵ���!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;		//������ϸ��id
	var result = "N"
	
	SaveCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr) ;

}

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
		//$("#gridMain").datagrid("reload");
		$('#diagSelectReason').dialog('close');
		var gridSelect = $("#gridMain").datagrid("getSelected");
		var seqNo = $('#gridMain').datagrid('getRowIndex',gridSelect);
		if (result=="Y"){
			if (loadWayCode == "RE"){
				var ResultDesc = "ͨ��"	
			}
			else {
				var ResultDesc = "�ϸ�"
			}	
		}
		else if (result=="N"){
			if (loadWayCode == "RE"){
				var ResultDesc = "��ͨ��"	
			}
			else {
				var ResultDesc = "���ϸ�"
			}	
		}
		else{
			var ResultDesc = ""			
		}
		
		$("#gridMain").datagrid('updateRow', {
			index: seqNo,
			row: { curret: ResultDesc }
		})
	}
	
	ClearCommentGrid() ;

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
		'<div id=' + menuId + '_comment' + ' data-options="' + "iconCls:'icon-export-all'" + '">һ������</div>' +
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
			var pcntItm = gridSelect.pcntItm ;		//������ϸ��id
			var result = "Y"
			var reasonstr = ""
			var input = ""

            SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;		
		}
	}
	$("#gridMain").datagrid("reload");
}

function ClearCommentGrid(){
	//$("#dhcpha-patinfo").empty();
	InitSetPatInfo() ;
	$("#gridPrescInfo").datagrid("clear");
	$("#gridLog").datagrid("clear");
}

function ClearQuestionGrid(){
	InitReasonTreeGrid() ;
	$("#gridQuestion").datagrid("clear");
	$("#conWarn").combobox("setValue",'');
	$("#conWarn").combobox("setText", '');
	$("#conAdvice").combobox("setValue",'');
	$("#conAdvice").combobox("setText", '');
	$("#conPhNote").val('');
	
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
		// ��ͨ
		 StartDaTongDll(); 
		 DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// ����
		MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}

/********************** ���ô�ͨ������ҩ start   **************************/
// ��ʼ��
function StartDaTongDll() {
    dtywzxUI(0, 0, "");
}

function dtywzxUI(nCode, lParam, sXML) {
    var result;
    result = CaesarComponent.CRMS_UI(nCode, lParam, sXML, "");
    return result;
}

//��ͨ��������
function DaTongPrescAnalyse() {
    var rows = $("#gridMain").datagrid("getRows");
    if (rows.length == 0) {
		PHA.Alert('��ʾ', "û����Ҫ���������ݣ�", 'warning');
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescNo;
        var analyResultRet = rows[i].analyResultRet;
        var baseinfo = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDocBaseInfoByPresc", prescno);
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescInfoXML", prescno);
        myrtn = dtywzxUI(6, baseinfo, myPrescXML);
        if (myrtn == 0) { var imgname = "warning0.gif"; }
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
        if (myrtn == 2) { var imgname = "warning3.gif"; }	// �ڵ�
	
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

// ��ͨҩ����ʾ
function rightClickYDTSFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //��ֹ����ð��
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_YDTS' + ' data-options="' + "iconCls:'icon-tip'" + '">ҩ����ʾ</div>' +
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
				//alert("userInfo:"+userInfo)
				//alert("incDesc:"+incDesc)
				//alert("selOrdItm:"+selOrdItm)
			DHCSTPHCMPASS.MedicineTips({
				Oeori: selOrdItm,
				UserInfo: userInfo,
				IncDesc: incDesc
			})
		}else if (passType=="DT"){
			// ��ͨ
			// StartDaTongDll(); 
			// DaTongPrescAnalyse();  
		}else if (passType=="MK"){
			// ����
			MKPrescYDTS(selOrdItm); 
		}else if (passType=="YY"){
		}		
		// �ݲ��ſ�
		return;	  

		var gridSelect = $("#gridPrescInfo").datagrid("getSelected");
		if (gridSelect==null){
			$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴��ҽ����Ϣ!","info");
			return;
		}
		var orditm = gridSelect.orditm ;
		dtywzxUI(3, 0, "");
		var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);
		myrtn = dtywzxUI(12, 0, myPrescXML);
	})
}
/********************** ���ô�ͨ������ҩ end   **************************/


    
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
        }
        else {
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
	}
	else {
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
	if (cellvalue!=""){
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			var cellvalue = (cellvalue == 1) ? 0 : 1;
		}
	}
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
