//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-11-01
// ����:	   ������־JS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";         /// ID
var modeType = "";      /// �򿪷�ʽ
var EmType = "";        /// ҽ������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var ItemTypeArr = [{"value":"���","text":'���'}, {"value":"�а�","text":'�а�'}, {"value":"ҹ��","text":'ҹ��'}];;

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	
	InitMainList();    /// ��ʼ�������б�
	InitDetList();     /// ��ʼ����ϸ�б�
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	modeType = getParam("Type");   /// �򿪷�ʽ
	EmType = getParam("EmType");   /// ��������
}

/// ��ʼ���������
function InitComponents(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// ҽ������
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMedUnit&LocID="+LgLocID;
	$HUI.combobox("#MedGrp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// ���
	$HUI.combobox("#Schedule",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// ����
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	$HUI.combobox("#Ward",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	if (modeType == "T"){
		$(".panel-south").hide();
	}
}

/// ��ʼ�����ؽ����б�
function InitMainList(){
	
	///  ����columns
	var columns=[[
		{field:'bsID',title:'bsID',width:100,hidden:true},
		{field:'bsDate',title:'��������',width:120,align:'center'},
		{field:'bsMedGrp',title:'ҽ����',width:120,align:'center'},
		{field:'bsWard',title:'������',width:160},
		{field:'bsSchedule',title:'���',width:120,align:'center'},
		{field:'bsUser',title:'������',width:120,align:'center'},
		{field:'bsAccUser',title:'�Ӱ���',width:120,align:'center'},
		{field:'bsCreateDate',title:'��������',width:120,align:'center'},
		{field:'bsCreateTime',title:'����ʱ��',width:120,align:'center'},
		{field:'bsPatNum',title:'��������',width:120,align:'center',formatter:
			function (value, row, index){
				return '<font style="color:red;font-weight:bold;">'+value+'</font>';
			}
		},
		{field:'bsStatus',title:'״̬',width:120,align:'center',formatter:
			function (value, row, index){
				if (value == "N"){return '<font style="color:#ff3d2c;font-weight:700;">δ���</font>'}
				else {return '<font style="color:green;font-weight:700;">�����</font>'}
			}
		}
	]];
	
	///  ����datagrid
	var option = {
		headerCls:'panel-header-gray',
		//title:'�����¼'+titleNote,
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
			$("#bmDetList").datagrid("load",{"Params":rowData.BsID});
		},
		onDblClickRow:function(rowIndex, rowData){
			parent.GetEmShift(rowData.BsID);
			parent.commonCloseWin();
		},
		onLoadSuccess:function(data){
			if (typeof data.rows[0] != "undefined"){
				$("#bmDetList").datagrid("load",{"Params":data.rows[0].BsID});
			}else{
				$("#bmDetList").datagrid("load",{"Params":0});
			}
		},
        rowStyler:function(rowIndex, rowData){
			if(rowData.bsStatus != "Y"){
				return 'background-color:#fec0c0;';
			}
		}
	};
	/// ��������
	var param = "^^^^^" + EmType;
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmShiftList&Params="+param;
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitDetList(){
	
	///  ����columns
	var columns=[[
		{field:'BsItmID',title:'BsItmID',width:100,hidden:true},
		{field:'PatBed',title:'����',width:60,align:'center'},
		{field:'PatName',title:'����',width:100},
		{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'PatAge',title:'����',width:60,align:'center'},
		{field:'PatSex',title:'�Ա�',width:50,align:'center'},
		{field:'PAAdmDate',title:'��������',width:100,align:'center'},
		{field:'PAAdmTime',title:'����ʱ��',width:100,align:'center'},
		{field:'PatDiag',title:'���',width:320},
		{field:'BsVitalSign',title:'��������',width:320},
		{field:'BsContents',title:'��������',width:320},
		//{field:'WaitToHos',title:'����Ժ����',width:300},
		{field:'BsMedHis',title:'��ʷ',width:320},
		{field:'BsTreatMet',title:'���Ʒ�ʽ',width:120},
		{field:'BsCotNumber',title:'��ϵ��ʽ',width:120},
		{field:'BsNotes',title:'��ע',width:320},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmShiftPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ��ѯ
function find_click(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var MedGrpID = $HUI.combobox("#MedGrp").getValue();    /// ҽ����
	if (typeof MedGrpID == "undefined") MedGrpID = "";
	var WardID = $HUI.combobox("#Ward").getValue();        /// ������
	if (typeof WardID == "undefined") WardID = "";
	var Schedule = $HUI.combobox("#Schedule").getValue();  /// ���
	if (typeof Schedule == "undefined") Schedule = "";
	var params = StartDate +"^"+ EndDate +"^"+ WardID +"^"+ Schedule +"^"+ MedGrpID +"^"+ EmType;
	$("#bmMainList").datagrid("load",{"Params":params}); 
}

/// ��ӡ
function print_click(){
	
}

/// ����
function export_click(){
	
	var rowsData = $("#bmMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ:","����ѡ��Ҫ�����Ľ����¼��","warning");
		return;
	}
	var jsonObjArr = rowsData;
	
	runClassMethod("web.DHCEMBedSideShift","GetExpEmShiftDetail",{"BsID":rowsData.BsID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","�����쳣��","warning");
		}else{
			var jsonItemArr = jsonString;
			Export_Xml(jsonObjArr, jsonItemArr);
		}
	},'json',false)	
}

/// �����Ű��¼
function Export_Xml(jsonObjArr, jsonItemArr){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCEM_BedSideShift.xlsx";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(2, 2).value = jsonObjArr.MedGrp;    /// ҽ������
	objSheet.Cells(2, 4).value = jsonObjArr.Ward;      /// ������
	objSheet.Cells(2, 6).value = jsonObjArr.Schedule;  /// ���
	objSheet.Cells(2, 8).value = "" // jsonObjArr.UserName;  //����
	objSheet.Cells(2, 10).value = jsonObjArr.WrDate;    /// ��������
	objSheet.Cells(2, 12).value = jsonObjArr.UserName;  /// ������Ա
		
	for (var i=0; i<jsonItemArr.length; i++){
		objSheet.Cells(4+i, 1).value = jsonItemArr[i].PatBed;      /// ����
		objSheet.Cells(4+i, 2).value = jsonItemArr[i].PatName;     /// ����
		objSheet.Cells(4+i, 3).value = jsonItemArr[i].PatNo;       /// �ǼǺ�
		objSheet.Cells(4+i, 4).value = jsonItemArr[i].PatAge;      /// ����
		objSheet.Cells(4+i, 5).value = jsonItemArr[i].PatSex;      /// �Ա�
		objSheet.Cells(4+i, 6).value = jsonItemArr[i].PAAdmDate;   /// ��������
		objSheet.Cells(4+i, 7).value = jsonItemArr[i].PAAdmTime;   /// ����ʱ��
		objSheet.Cells(4+i, 8).value = jsonItemArr[i].PatDiag;     /// ���
		objSheet.Cells(4+i, 9).value = jsonItemArr[i].BsVitalSign; /// ��������
		objSheet.Cells(4+i, 10).value = jsonItemArr[i].BsMedHis;   /// ��ʷ
		objSheet.Cells(4+i, 11).value = jsonItemArr[i].BsTreatMet; /// ���Ʒ�ʽ
		objSheet.Cells(4+i, 12).value = jsonItemArr[i].BsContents; /// ��������
		//objSheet.Cells(4+i, 13).value = jsonItemArr[i].WaitToHos;  /// ����Ժ����
		objSheet.Cells(4+i, 13).value = "" //jsonItemArr[i].WaitToHos;  ///����
		objSheet.Cells(4+i, 14).value = jsonItemArr[i].BsCotNumber;/// ��ϵ��ʽ
		//objSheet.Cells(4+i, 12).value = jsonItemArr[i].BsNotes;    /// ��ע
		setCellLine(objSheet,4+i,1,14);
	}
	//objSheet.printout();
	objSheet.Application.Visible = true;
	xlBook.SaveAs("������ϸ.xlsx");
	xlApp=null;
	//xlBook.Close(savechanges=false);
	objSheet=null;	
}

/// ���ñ߿�
function setCellLine(objSheet,row,startcol,colnum){
	
	for (var m=startcol;m<=colnum;m++){
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(9).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(8).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(7).LineStyle=1;
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

/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })