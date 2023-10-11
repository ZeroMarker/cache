/**
 * ����:	 ��������-����סԺҽ��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-14
 */
PHA_COM.App.Csp = "pha.prc.v2.comment.ipmain.csp";
PHA_COM.App.Name = "PRC.Comment.Main";
PHA_COM.App.Load = "";
var EpisodeId="";
var LoadAdmId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var loadWayId = gLoadWayID		//���ص�������Ӧ�ĵ�����ʽ
var loadPcntId = gLoadPcntID ;
var longoninfo = logonGrpId + "^" + logonLocId + "^" + logonUserId ;
$(function () {
	InitGridIPMain();
    InitGridOrdDetail();			
    InitGridLog();
    InitGridAllLog();
    InitSetPatInfo("I");
	
    InitDiagReason("IP");	// ������ԭ�򴰿�
    InitFindNoDialog({type: "IP", callback: LoadCommentNo});		// �鵥����
	
    $("#btnFind").on("click", function () {
		ShowDiagFindNo();
	});
	$("#btnLog").on("click", function () {
		ShowDiagLog(this)
	});
	$("#btnAllLog").on("click", function () {
		ShowDiagAllLog(this)
	});
	$("#btnSearch").on("click", function () {
		SearchComments()
	});
	$("#btnSelect").on("click", function () {
		SelectCommentItms()
	});
	$("#btnDelete").on("click", function () {
		DeleteComment()
	});
	$("#btnSubmit").on("click", function () {
		SubmitComment()
	});
	//����ͨ��(����)
	$("#btnPass").on("click", function () {
		CommentOK()
	});
	//������ͨ��(������)
	$("#btnRefuse").on("click", function () {
		ShowDiagUnreason(this) ;
	});
	// ��ҩ����
	$("#btnAnaly").on("click", function () {
		OrderAnalyse()
	});
	
	$("#tabsForm").tabs({
        onSelect: function(title) {
	        var gridSelect = $("#gridIPMain").datagrid("getSelected");
			if (gridSelect==null){
				$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĳ���!","info");
				return;
			}
			var EpisodeId = gridSelect.adm;
		    // �ⲻ����,ÿ��tk��û��
		    var admData=tkMakeServerCall("web.DHCSTPIVAS.Common","GetAdmInfo",EpisodeId);
		    var patId=admData.toString().split("^")[0]||"";

			/* MaYuqiang 20220517 ��������Ϣ����ͷ�˵����������ý��洮���� */
			var menuWin = websys_getMenuWin();  // ���ͷ�˵�Window����
			if (menuWin){		
				var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
				if((frm) &&(frm.EpisodeID.value != EpisodeId)){
					if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //���ͷ�˵������в��������Ϣ
					frm.EpisodeID.value = EpisodeId; 
					frm.PatientID.value = patId;
				}
			}
			if(title==="ҽ����ϸ"){
				QueryAdmOrdDetail() ;	
			}else if (title=="�������"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N' + "&MWToken="+websys_getMWToken();
                	$('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + EpisodeId);
		        } 
		    }
        }
    });  
    if (loadPcntId === ""){
		setTimeout(function(){
			ShowDiagFindNo();
		}, 500);
    }
});

// ���-��������
function InitGridIPMain() {
	var columns = [
        [
            { field: "patNo", title: '�ǼǺ�' ,width: 120},
            { field: "patName", title: '����' ,width: 100},
            { field: "sexDesc", title: '�Ա�',width: 120, hidden: true},
            { field: 'patAge', title: '����', width: 200, hidden: true},
            { field: "typeDesc", title: '�ѱ�' ,width: 120, hidden: true},
            { field: "diag", title: '���', width: 100,hidden: true },
            { field: 'curret', title: '���', width: 100},
            { field: 'oriCurret', title: '�������', width: 80, hidden: true},
            { field: "doclocDesc", title: '����' ,width: 120, hidden: true},
            { field: "adm", title: 'adm',width: 120 , hidden: true},
            { field: "wayCode", title: 'waycode',width: 100, hidden: true },
            { field: "pcntItm", title: '������ϸid',width: 120, hidden: true},
            { field: "papmi", title: 'papmi', width: 100,hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentItms',
            pcntId: loadPcntId || '' ,
            comResult: '',
            phaUserId: ''
        },
        columns: columns,
        toolbar: "#gridIPMainBar",
        onClickRow:function(rowIndex,rowData){
	        var EpisodeId = rowData.adm ;
			LoadPatInfo(rowData);

			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){			//ҽ����ϸ
				QueryAdmOrdDetail() ;			
			}else if (index==1){	//�������
				var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N'+ "&MWToken="+ websys_getMWToken();
                $('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + EpisodeId);
			}
		}  
    }; 

    PHA.Grid("gridIPMain", dataGridOption);
}
function InitGridOrdDetail() {
    var columns = [
        [
            { field: "analysisResult", title: '������ҩ',width: 80,align: 'center',formatter: druguseFormatter },
			{ field: "orderResult", title: '�������',width: 110,align: 'center', 
				styler: function (value, row, index) {
					if ((row.orderResult.indexOf("��ͨ��")>-1)||(row.orderResult.indexOf("����")>-1)) {
                        return 'background-color:#EE4F38;color:white;';
                    }
				}
			},
			{ field: "oriOrderResult", title: '���ε������',width: 110,align: 'center', hidden :true,
				styler: function (value, row, index) {
					if (row.oriOrderResult.indexOf("����")>-1) {
                        return 'background-color:#EE4F38;color:white;';
                    }
				}
			},
			{ field: "oeoriSign", title: '��',width: 30 },
            { field: "arcimdesc", title: 'ҽ������',align: 'left',width: 200 },
            { field: "qty", title: '����',align: 'left',width: 50 },
            { field: "uomdesc", title: '��λ',align: 'left',width: 50 },
            { field: "dosage", title: '����',align: 'left',width: 50 },
            { field: "freq", title: 'Ƶ��',align: 'left',width: 50 },
            { field: "instruc", title: '�÷�',align: 'left',width: 80 },
            { field: "form", title: '����',width: 80 },
            { field: "priorty", title: 'ҽ�����ȼ�',align: 'left',width: 100 },
            { field: "basflag", title: '����ҩ��',align: 'left',width: 60 },
            { field: "doctor", title: 'ҽ��',width: 60 },
            { field: "orddate", title: 'ҽ����������',align: 'left',width: 150 },
            { field: "remark", title: 'ҽ����ע',align: 'left',width: 120 },
            { field: "orditm", title: 'orditem',width: 120,align: 'left',hidden:false },
            { field: "prescno", title: 'prescno',width: 120,align: 'left',hidden:true },
			{ field: "analysisData", title: '��������ֵ' ,width: 120, align: 'left',hidden: true},
            { field: "colorflag", title: 'colorflag',width: 120,align: 'left',hidden:true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.IPMain',
            QueryName: 'SelectAdmOrderDetail',
			pcntsitm: '' ,
			adm:''
        },
        columns: columns,
        toolbar: "#gridOrderBar",
        onClickRow:function(rowIndex,rowData){
	        if (rowData){
	        	var prescNo = rowData.prescno ;
			}   
		},
		onRowContextMenu: rightClickYDTSFn ,
		rowStyler: function(rowIndex, rowData) {        
            var colorflag=rowData.colorflag;
            var colorStyle="";
            if (colorflag==1){	// ������ı���ɫ
				//colorStyle="background-color:pink";
            }
            return colorStyle;	
            
        },
        onClickCell: function (rowIndex, field, value) {
			var rows = $(this).datagrid('getRows');
			var rowData = rows[rowIndex];
            if (field != "analysisResult") {
                return
            }
            var content = rowData.analysisData;
            DHCSTPHCMPASS.AnalysisTips({
                Content: content
            })
        }
    };
    PHA.Grid("gridOrder", dataGridOption);
}

function InitGridLog() {
    var columns = [
        [
            { field: "grpNo", title: '���',width: 40 },
            { field: 'reasonDesc', title: '����ԭ��', width: 250,
            	formatter:function(v){
					return v.replace('������','<span style="color:#999999">������</span>')
				}
			},
            { field: 'pcntDate', title: '��������', width: 100},
            { field: "pcntTime", title: '����ʱ��', width: 80 },
            { field: "pcntUser", title: '������' ,width: 80},
            { field: "pcntResult", title: '�������',width: 80 },
            { field: 'pcntFactor', title: '������ʾֵ', width: 150},
            { field: "pcntAdvice", title: 'ҩʦ����' ,width: 150},
			{ field: "pcntNote", title: 'ҩʦ��ע' ,width: 150},
			{ field: "pcntDocNote", title: 'ҽ����ע' ,width: 150},
			{ field: "reSaveFlag", title: '���ε���',width: 70 },
			{ field: "pcntActive", title: '��Ч״̬' ,width: 80}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.IPMain',
            QueryName: 'SelectCommentLog',
			pcntItmId: '',
			orditem: ''
        },      
        columns: columns,
        toolbar: null,
        border:true,
        bodyCls:'panel-header-gray',
        onClickRow:function(rowIndex,rowData){
	         
		}   
    };
	PHA.Grid("gridLog", dataGridOption);
}

function InitGridAllLog() {
    var columns = [
        [
            { field: "grpNo", title: '���',width: 40 },
            { field: 'reasonDesc', title: '����ԭ��', width: 250,
            	formatter:function(v){
					return v.replace('������','<span style="color:#999999">������</span>')
				}
			},
            { field: 'pcntDate', title: '��������', width: 100},
            { field: "pcntTime", title: '����ʱ��', width: 80 },
            { field: "pcntUser", title: '������' ,width: 80},
            { field: "pcntResult", title: '�������',width: 80 },
            { field: 'pcntFactor', title: '������ʾֵ', width: 150},
            { field: "pcntAdvice", title: 'ҩʦ����' ,width: 150},
			{ field: "pcntNote", title: 'ҩʦ��ע' ,width: 150},
			{ field: "pcntDocNote", title: 'ҽ����ע' ,width: 150},
			{ field: "reSaveFlag", title: '���ε���',width: 70 },
			{ field: "pcntActive", title: '��Ч״̬' ,width: 80}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.IPMain',
            QueryName: 'SelectCommentAllLog',
			pcntItmId: ''
        },      
        columns: columns,
        toolbar: null,
        border:true,
        bodyCls:'panel-header-gray',
        onClickRow:function(rowIndex,rowData){
	         
		}   
    };
	PHA.Grid("gridAllLog", dataGridOption);
}

function ShowDiagUnreason(btnOpt) {
	var itmGridSelect = $("#gridOrder").datagrid("getSelected");
	if (itmGridSelect==null){
		PHA.Popover({ msg: "����ѡ��ҽ��!", type: 'alert'});	
		return false;
	}	
	var orditm = itmGridSelect.orditm ;		
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		PHA.Popover({ msg: "����ѡ����Ҫ�����Ĳ���!", type: 'alert'});
		return false;
	}
	//��ȡ����Ȩ��
	var pcntsItm = gridSelect.pcntItm ;		//�����ӱ�id
	var pcntsAuth = tkMakeServerCall("PHA.PRC.Create.Main","ChkItmComAuth", longoninfo, pcntsItm)			
	if (pcntsAuth !== "1"){
		var pcntsAuthData = pcntsAuth.split("^")
		$.messager.alert('��ʾ',pcntsAuthData[1],"info");
		return false;
	}
	showDialogSelectReason(orditm, pcntsItm, SaveIPCommentResult);
}

function ShowDiagLog(btnOpt) {
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĳ���!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;
	var itmGridSelect = $("#gridOrder").datagrid("getSelected");
	if (itmGridSelect==null){
		$.messager.alert('��ʾ',"����ѡ��ҽ��!","info");
		return ;
	}	
	var orditem = itmGridSelect.orditm ;		//ҽ��id
	$('#diagLog').dialog({
		title: "��־" ,
		iconCls:  'icon-w-paper' ,
		modal: true,
		width: $('body').width() - 40,
		height: $('body').height() * 0.8
	})
	$('#diagLog').dialog('open');
	$('#gridLog').datagrid('query', {
        pcntItmId: pcntItm,
		orditem: orditem
    });
}

function ShowDiagAllLog(btnOpt) {
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĳ���!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;
	
	$('#diagAllLog').dialog({
		title: "ȫ����־" ,
		iconCls:  'icon-w-paper' ,
		modal: true,
		width: $('body').width() - 40,
		height: $('body').height() * 0.8
	})
	
	$('#diagAllLog').dialog('open');
	$('#gridAllLog').datagrid('query', {
        pcntItmId: pcntItm
    });
}

///��ȡ����ҽ����ϸ��Ϣ
function QueryAdmOrdDetail() {
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�ľ�����Ϣ!","info");
		return;
	}
	var adm = gridSelect.adm;
	var pcntsitm = gridSelect.pcntItm ;
    $('#gridOrder').datagrid('query', {
		pcntsitm: pcntsitm,
        adm: adm
    });
}

function CommentOK(){
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĳ���!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;
	var itmGridSelect = $("#gridOrder").datagrid("getSelected");
	if (itmGridSelect==null){
		var orditm = "" ;
	}else {
		var orditm = itmGridSelect.orditm ;		//ҽ��id
	}	
	var result = "Y"
	var reasonstr = ""
	var remarkStr = ""
	var otherstr = orditm	
	SaveIPCommentResult(pcntItm, result, longoninfo, reasonstr, remarkStr, otherstr) ;
}

// ҽ������������
function SaveIPCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr, otherstr){
	var OKRet = $.cm({
		ClassName: 'PHA.PRC.Create.IPMain',
		MethodName: 'SaveComItmResult',
		pcntItm: pcntItm,
		result: result,
		longoninfo: longoninfo,
		reasonstr: reasonIdStr,
		input: remarkStr ,
		otherstr: otherstr ,			
		dataType: 'text'
	}, false);
	var RetArr = OKRet.split('^');
	var RetVal = RetArr[0];
	var RetInfo = RetArr[1];	
	if (RetVal < 0) {
		PHA.Alert('��ʾ', RetInfo, 'warning');
		return;
	}else{
		var gridSelect = $("#gridIPMain").datagrid("getSelected");
		var seqNo = $('#gridIPMain').datagrid('getRowIndex',gridSelect);
		var $gridOrder = $("#gridOrder");
		var selectedOrder = $gridOrder.datagrid('getSelected');
		var tmpOeori = selectedOrder? selectedOrder.orditm : "";
		var orderRows = $gridOrder.datagrid("getRows");
		var resultFlag = result;
		if((tmpOeori === "")&&(result === "Y")){
			resultFlag = "Y";
		}else{
			for (var i = 0; i < orderRows.length; i++){
				if(orderRows[i].orditm === tmpOeori){
					continue;
				}			
				if ((orderRows[i].orderResult.indexOf("��ͨ��")>-1)||(orderRows[i].orderResult.indexOf("����")>-1)) {
					resultFlag = "N";		
	                break;
	            }
			}
		}
		if (resultFlag === "N"){
			if(FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("��ͨ��");	
			}else{
				var ResultDesc = $g("������");	
			}	
		} else if (resultFlag === "Y") {
			if(FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("ͨ��");	
			}else{
				var ResultDesc = $g("����");
			}
		} else {
			var ResultDesc = "";		
		}
		$("#gridIPMain").datagrid('updateRow', {
			index: seqNo,
			row: { curret: ResultDesc }
		}) 
		$gridOrder.datagrid("reload");		
	}		
}

// ��ѯ�������ص�������ѡ�������ʱ��������������
function LoadCommentNo(param){
	ClearCommentGrid();
	$('#gridIPMain').datagrid('clear');	
	if (param.loadWayCode == "RE"){
		$('#gridIPMain').datagrid('showColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 110;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 100;	
		$('#btnPass').linkbutton({text:'ͨ��'});
		$('#btnRefuse').linkbutton({text:'��ͨ��'});
	}else{
		$('#gridIPMain').datagrid('hideColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 140;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 140;
		$('#btnPass').linkbutton({text:'����'});
		$('#btnRefuse').linkbutton({text:'������'});
	} 
	$('#gridIPMain').datagrid('query', param);	
	$('#gridIPMain').datagrid();
}

function LoadMsgComment(){
	if (gWayCode == "RE"){
		$('#gridIPMain').datagrid('showColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 110;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 100;	
		$('#btnPass').linkbutton({text:'ͨ��'});
		$('#btnRefuse').linkbutton({text:'��ͨ��'});
	}else{
		$('#gridIPMain').datagrid('hideColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 140;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 140;
		$('#btnPass').linkbutton({text:'����'});
		$('#btnRefuse').linkbutton({text:'������'});
	} 
}

function ClearCommentGrid(){
	InitSetPatInfo("I") ;
	$("#gridLog").datagrid("clear");
	$("#gridOrder").datagrid("clear");	
	$('#gridIPMain').datagrid('clear');
}

//��������
function OrderAnalyse(){
	var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
	if (passTypeInfo==""){
		$.messager.alert('ע��',"δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����!","info");
		return;
	}
	var passTypeData=passTypeInfo.split("^")
	var passType=passTypeData[0];
	if (passType=="DHC"){
		// ����֪ʶ��
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "gridOrder", 
		 	MOeori: "orditm",
		 	PrescNo:"prescno", 
		 	GridType: "EasyUI", 
		 	Field: "analysisResult",
			ResultField: "analysisData"
		 	//CallBack: 
		 });
	}else if (passType=="DT"){
		// ��ͨ
		dhcphaMsgBox.alert("�ӿ���δ����");
	}else if (passType=="MK"){
		// ����
		dhcphaMsgBox.alert("�ӿ���δ����");
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
		dhcphaMsgBox.alert("�ӿ���δ����");
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
		var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if (passTypeInfo==""){
			PHA.Alert("��ʾ","δ����ҩ��ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����",'warning');
			return;
		}
		var passTypeData=passTypeInfo.split("^")
		var passType=passTypeData[0];
		if (passType=="DHC"){
			// ����֪ʶ��
			var ordGridSelect = $("#gridOrder").datagrid("getSelected");
			if((ordGridSelect=="")||(ordGridSelect==null)){
				PHA.Alert("��ʾ","����ѡ����Ҫ�鿴ҩ����ʾ����ϸ��¼!",'warning');
				return;
			}
			var userInfo = logonUserId + "^" + logonLocId + "^" + logonGrpId;
			var incDesc = ordGridSelect.arcimdesc;
			var selOrdItm = ordGridSelect.orditm
			DHCSTPHCMPASS.MedicineTips({
				Oeori: selOrdItm,
				UserInfo: userInfo,
				IncDesc: incDesc
			})
		}else if (passType=="DT"){
			dhcphaMsgBox.alert("�ӿ���δ����");
			// ��ͨ
		}else if (passType=="MK"){
			dhcphaMsgBox.alert("�ӿ���δ����");
			// ����
			//MKPrescYDTS(selOrdItm) ; 
		}else if (passType=="YY"){
			dhcphaMsgBox.alert("�ӿ���δ����");
		}		
	})
}

//��ʽ����
function druguseFormatter(cellvalue, options, rowdata){
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
    
/********************** ��������������ҩ start   **************************/
//������������
function MKPrescAnalyse() {
    var rows = $("#gridOrder").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescno;
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = "warningnull.gif"
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// ����
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        var str = "<img id='analysisResult" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
		$("#gridOrder").datagrid('updateRow', {
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
