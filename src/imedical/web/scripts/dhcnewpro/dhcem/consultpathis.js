//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-08-15
// ����:	   ���˻����¼��ѯ
//===========================================================================================

var CstID = "";         /// ��������ID
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var ItemTypeArr = [{"value":"N","text":$g('����')}, {"value":"Y","text":$g('����')}];;

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	InitMethod();
	
	/// ��ʼ�����˻�����Ϣ
	InitPatInfoPanel();
	
	IsOpenMoreScreen?InitMoreScreen():''; //2022-03-07 �û����
}

function InitMethod(){
	$(window).resize(function () {
		$("#bmDetList").datagrid("resize");
	});	
}


/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");
	CsType = getParam("CsType");         /// ��������
	IsOpenMoreScreen = isOpenMoreScreen();	///�Ƿ����Ļ 2022-03-07 �û����
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// ��������
	$HUI.combobox("#CstRLoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// ��������
	$HUI.combobox("#CstType",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// ���״̬
	$HUI.combobox("#AuditFlag",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// �ǼǺ�
	//$("#PatNo").bind('keypress',PatNo_KeyPress);
	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	///  ����columns
	var columns=[[
		{field:'CstID',title:'CstID',width:100,hidden:true},
		//{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'PatName',title:'����',width:100},
		//{field:'PatSex',title:'�Ա�',width:60,align:'center'},
		//{field:'PatAge',title:'����',width:60,align:'center'},
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatWard',title:'����',width:120},
		{field:'PatBed',title:'����',width:60,align:'center'}, 
		{field:'PatDiag',title:'���',width:140},
		{field:'CstType',title:'��������',width:100,align:'center'},
		{field:'CstRLoc',title:'��������',width:120},
		{field:'CstRUser',title:'�������',width:100,align:'center'},
		{field:'CstRTime',title:'����ʱ��',width:160,align:'center'},
		//{field:'CstTrePro',title:'��Ҫ����',width:400},
		//{field:'CstPurpose',title:'����Ŀ��',width:400},
		{field:'CstUnit',title:'����ҽԺ',width:100},
		{field:'CstLocArr',title:'�������',width:220},
		{field:'CstPrvArr',title:'������',width:220},
		{field:'AccpTime',title:'����ʱ��',width:160,align:'center'},
		{field:'CompTime',title:'���ʱ��',width:160,align:'center'},
		{field:'CstStatus',title:'����״̬',width:80,align:'center'},
		{field:'CstNPlace',title:'����ص�',width:200},
		//{field:'PrintFlag',title:'��ӡ',width:80,align:'center',hidden:true},
		//{field:'AuditFlag',title:'���״̬',width:80,align:'center'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fit:true,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0){
				InsPageConsult({CstTrePro:"",CstPurpose:"",CsOpinion:""})
				return;
			}
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			$("#bmDetList").datagrid('selectRow',0)
			InsPageConsult(rowData);
			/*
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0) return;
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			var TmpCstID = rowData.CstID;
			var mergerows = 0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpCstID != rows[i].CstID){
				    MergeCells(i,mergerows);  /// �ϲ�ָ����Ԫ��
				    mergerows=0;
				    TmpCstID = rows[i].CstID;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				 MergeCells(i,mergerows);  /// �ϲ�ָ����Ԫ��
			}
			*/
		},
		onClickRow: function (rowIndex, rowData) {
			InsPageConsult(rowData);
        },
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.CstID);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "����"){
				return 'background-color:pink;';
			}
		}
	};
	/// ��������
	var param = "^^^^" + PatientID +"^"+ EpisodeID;
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsGetPatHisCons&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// �ϲ�ָ����Ԫ��
function MergeCells(i, mergerows){
	
	var Fields = ["PatNo","PatName","CstID","PatSex","PatAge","PatLoc","PatWard","PatBed","PatDiag","CstType","CstRLoc","CstRUser","CstRTime","CstTrePro","CstPurpose","CstUnit"];
	for (var m = 0; m < Fields.length; m++){
		$('#bmDetList').datagrid('mergeCells',{
	       index:(i - mergerows),
	       field:Fields[m],
	       rowspan:mergerows
	    });
	}
}

/// ��ѯ
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var RLocID = $HUI.combobox("#CstRLoc").getValue();     /// ��������
	if (typeof RLocID == "undefined") RLocID = "";
	var CstType = $HUI.combobox("#CstType").getValue();    /// ��������
	if (typeof CstType == "undefined") CstType = "";
	
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ CstType +"^"+ PatientID +"^"+ EpisodeID;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// ��дMDT����
function WriteMdt(EpisodeID, CstID){

	//var rowsData = $("#bmDetList").datagrid('getSelected'); //ѡ��Ҫɾ������
	//if (rowsData != null) {
		OpenMdtConsWin();
		var lnk="dhcem.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID;
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		$("#newWinFrame").attr("src",lnk);
		//$("#newWinFrame").attr("src","dhcem.consultjdf.csp");
		//$("#newWinFrame").attr("src","dhcem.consultjdf.csp?EpisodeID="+rowsData.EpisodeID +"&ConsID="+ rowsData.ConsID);
	//}else{
		//$.messager.alert('��ʾ','��ѡ��Ҫ��д����ļ�¼��','warning');
		//return;
	//}
}

/// ��ӡ
function PrintCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //ѡ��Ҫɾ������
	var CsStatCode = rowsData.CstStatus;
	if(CsStatCode=="ȡ��"){
		$.messager.alert("��ʾ","���뵥�Ѿ�ȡ��,���ܴ�ӡ��","warning");
		return;
	}
	
	if((CsStatCode=="����")||(CsStatCode.indexOf("���")!=-1)||(CsStatCode=="����")||(CsStatCode=="�ܾ�")||(CsStatCode=="����")||(CsStatCode=="ȡ������")||(CsStatCode=="����")||(CsStatCode=="ȡ�����")){
		if(ConsNoCompCanPrt==1){
			$.messager.alert("��ʾ","����δ���,���ܴ�ӡ��","warning");
			return;
		}
	}
	if(PrintModel==1){
		var lnk="dhcem.printconsone.csp?CstItmIDs="+rowsData.CstItmID;
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		window.open(lnk);
		InsCsMasPrintFlag();  /// �޸Ļ����ӡ��־
	}else{
		var prtRet = PrintCstNew(rowsData.CstItmID,LgHospID);
		if(prtRet){
			InsCsMasPrintFlag();  /// �޸Ļ����ӡ��־	
		}
	}
	return;
}

/// ����ջ�
function CloseLoop(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //ѡ��Ҫɾ������
	var CsStatCode = rowsData.CstStatus;
	if(CsStatCode=="ȡ��"){
		$.messager.alert("��ʾ","���뵥�Ѿ�ȡ��,���ܴ�ӡ��","warning");
		return;
	}
	
	var lnk = "dhc.orderview.csp?ord="+rowsData.Oeori+"&ordViewType=CST&ordViewBizId="+rowsData.CstItmID; //hxy 2022-07-22 ��ҽ����ʾ�հ����⣺�����
	//var lnk = "dhc.orderview.csp?ord="+ rowsData.Oeori;
	
	if(rowsData.TypeCode=="NUR"){ //hxy 2022-09-29
		var lnk = "dhcem.consultnur.csp?CstID="+rowsData.CstID+"&CstItmID="+rowsData.CstItmID+"&seeCstType=1"
	}
	
	websys_showModal({
		url: lnk,
		height:640,
		width:1300, //hxy 2021-05-07 890->1280 ���õ������ɹر� //900->1300 ������Ϣ�ڸ�
		iconCls:"icon-w-paper",
		title: $g('������ϸ'),
		closed: true,
		onClose:function(){}
	});	
}

/// �����¼
function InsPageConsult(jsonObj){
	
	$("#ConsTrePro").text($_TrsTxtToSymbol(jsonObj.CstTrePro));    /// ����ժҪ
	$("#ConsPurpose").text($_TrsTxtToSymbol(jsonObj.CstPurpose));  /// ����Ŀ��
	$("#ConsOpinion").text($_TrsTxtToSymbol(jsonObj.CsOpinion));   /// �������
	
	if(IsOpenMoreScreen){
	LoadMoreScr(jsonObj); //2023-03-07 �û����
	}
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

function InitMoreScreen(){
	
}

function LoadMoreScr(rowData){
	var Obj={
		CstID:rowData.CstID,
		seeCstType:1
	}
	
	websys_emit("onOpenConsMessage",Obj);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
