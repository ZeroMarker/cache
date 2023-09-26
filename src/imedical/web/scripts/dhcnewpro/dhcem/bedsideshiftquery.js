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
	var uniturl = $URL+"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimeInterval&HospID="+ LgHospID +"&Module="+ EmType;
	$HUI.combobox("#Schedule",{
		url:uniturl,
		//data : ItemTypeArr,
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
	
	if (EmType == "Nur"){
		$("#MedGrp").next(".combo").hide();
		$("#MedGrpLabel").hide();
	}
}

/// ��ʼ�����ؽ����б�
function InitMainList(){
	
	///  ����columns
	var columns=[[
		{field:'bsID',title:'bsID',width:100,hidden:true},
		{field:'bsDate',title:'��������',width:120},
		{field:'bsMedGrp',title:'ҽ����',width:120},
		{field:'bsWard',title:'������',width:160},
		{field:'bsSchedule',title:'���',width:120},
		{field:'bsUser',title:'������',width:120},
		{field:'bsAccUser',title:'�Ӱ���',width:120},
		{field:'bsCreateDate',title:'��������',width:120},
		{field:'bsCreateTime',title:'����ʱ��',width:120},
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
			if (EmType == "Nur"){
				$("#bmMainList").datagrid('hideColumn','bsMedGrp');
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
		{field:'PatBed',title:'����',width:60},
		{field:'PatName',title:'����',width:100},
		{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'Log',title:'����',width:70,align:'center',formatter:SetCellLogUrl},
		{field:'PatAge',title:'����',width:60},
		{field:'PatSex',title:'�Ա�',width:50},
		{field:'ObsTime',title:'����ʱ��',width:100},
		{field:'PAAdmDate',title:'��������',width:100},
		{field:'PAAdmTime',title:'����ʱ��',width:100},
		{field:'PatDiag',title:'���',width:320},
		{field:'BsBackground',title:'����',width:320},
		{field:'BsAssessment',title:'����',width:320},
		{field:'BsSuggest',title:'����',width:320},
		{field:'EpisodeID',title:'EpisodeID',width:100}
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

/// ����
function SetCellLogUrl(value, rowData, rowIndex){
	
	var html = "<a href='#' onclick='log("+ rowData.EpisodeID +")' style='display:block;width:38px;background:#7dba56;padding:3px 6px;color:#fff;border-radius: 4px 4px 4px 4px;'>��־</a>";
	return html;
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
	var params = StartDate +"^"+ EndDate +"^"+ WardID +"^"+ Schedule +"^"+ MedGrpID +"^"+ EmType+"^"+LgHospID; //hxy 2020-06-03
	$("#bmMainList").datagrid("load",{"Params":params}); 
}

/// ��ӡ
function print_click(){
		
	var rowsData = $("#bmMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ:","����ѡ��Ҫ��ӡ�Ľ����¼��","warning");
		return;
	}
	var jsonObjMain = "��������: " + rowsData.bsDate + "       ҽ����: " + rowsData.bsMedGrp + "       ������: " + rowsData.bsWard  + "       ���: " + rowsData.bsSchedule + "       ������: " + rowsData.bsUser;
	window.open("dhcem.bedsideshiftprint.csp?BsID="+ rowsData.BsID +"&jsonObjMain="+ jsonObjMain);
	return;
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

/// �鿴��־
function log(EpisodeID){
	
	if (!hasLog(EpisodeID)) return;  /// �����Ƿ��н�����־ 
	
	commonShowWin({
		url:"dhcem.pattimeaxis.csp?PatientID=&EpisodeID="+ EpisodeID +"&EmType="+ EmType,
		title:"���ν�����Ϣ",
		height: (window.screen.availHeight - 180)	
	})
}

/// ���������¼
function Export_Xml(jsonObjArr, jsonItemArr){
	
	var title = "��������: " + jsonObjArr.bsDate + "       ҽ����: " + jsonObjArr.bsMedGrp + "       ������: " + jsonObjArr.bsWard  + "       ���: " + jsonObjArr.bsSchedule + "       ������: " + jsonObjArr.bsUser;
	var str = '(function test(x){' +
		'var xlApp = new ActiveXObject("Excel.Application");'  +
		'var xlBook = xlApp.Workbooks.Add();' +
		'var objSheet = xlBook.ActiveSheet;' +
		
		'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true;' + //�ϲ���Ԫ��
		'xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,11)).MergeCells = true;' + //�ϲ���Ԫ��
		'objSheet.Cells(1, 1).value = "���ｻ�౾";'+		 
   		'objSheet.Cells(2, 1).value = "' + title +'";' +
		'objSheet.Cells(3, 1).value = "����";' +      /// ����
		'objSheet.Cells(3, 2).value = "����";' +      /// ����
		'objSheet.Cells(3, 3).value = "�ǼǺ�";' +    /// �ǼǺ�
		'objSheet.Cells(3, 4).value = "����";' +      /// ����
		'objSheet.Cells(3, 5).value = "�Ա�";' +      /// �Ա�
		'objSheet.Cells(3, 6).value = "����ʱ��";' +  /// ��������
		'objSheet.Cells(3, 7).value = "����ʱ��";' +  /// ����ʱ��
		'objSheet.Cells(3, 8).value = "���";' +      /// ���
		'objSheet.Cells(3, 9).value = "����";' +      /// ����
		'objSheet.Cells(3, 10).value = "����";' +     /// ����
		'objSheet.Cells(3, 11).value = "����";'       /// ����
		str = str +setCellLine("",3,1,11);
		for (var i=0; i<jsonItemArr.length; i++){
			str = str +
			'objSheet.Cells('+ (4+ i) +', 1).value = "' +jsonItemArr[i].PatBed +'";' +      /// ����
			'objSheet.Cells('+ (4+ i) +', 2).value = "' +jsonItemArr[i].PatName +'";' +     /// ����
			'objSheet.Cells('+ (4+ i) +', 3).NumberFormatLocal = "@";' +           /// ���õ���Ϊ�ı�
			'objSheet.Cells('+ (4+ i) +', 3).value = "' +jsonItemArr[i].PatNo +'";' +       /// �ǼǺ�
			'objSheet.Cells('+ (4+ i) +', 4).value = "' +jsonItemArr[i].PatAge +'";' +      /// ����
			'objSheet.Cells('+ (4+ i) +', 5).value = "' +jsonItemArr[i].PatSex +'";' +      /// �Ա�
			'objSheet.Cells('+ (4+ i) +', 6).NumberFormatLocal = "@";' +            /// ���õ���Ϊ�ı�
			'objSheet.Cells('+ (4+ i) +', 6).value = "' +jsonItemArr[i].PAAdmDate +" "+ jsonItemArr[i].PAAdmTime +'";' +   /// ��������
			'objSheet.Cells('+ (4+ i) +', 7).value = "' +jsonItemArr[i].ObsTime +'";' +       /// ����ʱ��
			'objSheet.Cells('+ (4+ i) +', 8).value = "' +jsonItemArr[i].PatDiag +'";' +       /// ���
			'objSheet.Cells('+ (4+ i) +', 9).value = "' +escape2Html(jsonItemArr[i].bsBackground) +'";' +  /// ����
			'objSheet.Cells('+ (4+ i) +', 10).value = "' +escape2Html(jsonItemArr[i].bsAssessment) +'";'   /// ����
			var bsSuggest = "";
			if (jsonItemArr[i].bsSuggest != ""){
				bsSuggest = jsonItemArr[i].bsSuggest.replace(/<\/?[^>]*>/g,"");
			}
			str = str +
			'objSheet.Cells('+ (4+ i) +', 11).value = "' + escape2Html(bsSuggest.replace(/(\n)/g, "")) +'";'   /// ����
			str = str +setCellLine("",4+i,1,11);
		}
		str = str +
		"xlApp.Visible=true;" +
		'xlBook.SaveAs("����ƽ��౾.xlsx");' +
		'xlApp=null;' +
		'objSheet=null;' +
		"return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(str);   //ͨ���м�����д�ӡ���� 
	return;
	
	/*	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,11)).MergeCells = true; //�ϲ���Ԫ��
	objSheet.Cells(1, 1).value = "���ｻ�౾";
	var title = "��������: " + jsonObjArr.bsDate + "       ҽ����: " + jsonObjArr.bsMedGrp + "       ������: " + jsonObjArr.bsWard  + "       ���: " + jsonObjArr.bsSchedule + "       ������: " + jsonObjArr.bsUser;
	objSheet.Cells(2, 1).value = title;
	objSheet.Cells(3, 1).value = "����";   /// ����
	objSheet.Cells(3, 2).value = "����";   /// ����
	objSheet.Cells(3, 3).value = "�ǼǺ�"; /// �ǼǺ�
	objSheet.Cells(3, 4).value = "����";   /// ����
	objSheet.Cells(3, 5).value = "�Ա�";   /// �Ա�
	objSheet.Cells(3, 6).value = "����ʱ��"; /// ��������
	//objSheet.Cells(3, 7).value = "����ʱ��"; /// ����ʱ��
	objSheet.Cells(3, 7).value = "����ʱ��"; /// ����ʱ��
	objSheet.Cells(3, 8).value = "���";     /// ���
	objSheet.Cells(3, 9).value = "����"; 	 /// ����
	objSheet.Cells(3, 10).value = "����"; 	 /// ����
	objSheet.Cells(3, 11).value = "����"; 	 /// ����
		
	for (var i=0; i<jsonItemArr.length; i++){
		objSheet.Cells(4+i, 1).value = jsonItemArr[i].PatBed;      /// ����
		objSheet.Cells(4+i, 2).value = jsonItemArr[i].PatName;     /// ����
		objSheet.Cells(4+i, 3).NumberFormatLocal = "@";//���õ���Ϊ�ı�
		objSheet.Cells(4+i, 3).value = jsonItemArr[i].PatNo;       /// �ǼǺ�
		objSheet.Cells(4+i, 4).value = jsonItemArr[i].PatAge;      /// ����
		objSheet.Cells(4+i, 5).value = jsonItemArr[i].PatSex;      /// �Ա�
		objSheet.Cells(4+i, 6).NumberFormatLocal = "@";//���õ���Ϊ�ı�
		objSheet.Cells(4+i, 6).value = jsonItemArr[i].PAAdmDate +" "+ jsonItemArr[i].PAAdmTime;   /// ��������
		//objSheet.Cells(4+i, 7).value = jsonItemArr[i].PAAdmTime;   /// ����ʱ��
		objSheet.Cells(4+i, 7).value = jsonItemArr[i].ObsTime;     /// ����ʱ��
		objSheet.Cells(4+i, 8).value = jsonItemArr[i].PatDiag;     /// ���
		objSheet.Cells(4+i, 9).value = jsonItemArr[i].bsBackground; /// ����
		objSheet.Cells(4+i, 10).value = jsonItemArr[i].bsAssessment; /// ����
		var bsSuggest = "";
		if (jsonItemArr[i].bsSuggest != ""){
			bsSuggest = jsonItemArr[i].bsSuggest.replace(/<\/?[^>]*>/g,'')
		}
		objSheet.Cells(4+i, 11).value = bsSuggest;    /// ����
		setCellLine(objSheet,4+i,1,11);
	}
	//objSheet.printout();
	objSheet.Application.Visible = true;
	xlBook.SaveAs("����ƽ��౾.xlsx");
	xlApp=null;
	//xlBook.Close(savechanges=false);
	objSheet=null;
	*/	
}

/// ���ñ߿�
function setCellLine(objSheet,row,startcol,colnum){
	
	var mstr = "";
	for (var m=startcol;m<=colnum;m++){
		mstr = mstr +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(10).LineStyle=1;' +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(9).LineStyle=1;' +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(8).LineStyle=1;' +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(7).LineStyle=1;'
	}
	return mstr;
	
//	for (var m=startcol;m<=colnum;m++){
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(10).LineStyle=1;
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(9).LineStyle=1;
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(8).LineStyle=1;
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(7).LineStyle=1;
//	}
}

//ת���������ͨ�ַ�
function escape2Html(str) {
	
	str = str.trim().replace("\n", String.valueOf(10));
	var arrEntities={'lt':'<','gt':'>','nbsp':' ','amp':'&','quot':'"'}; 
	return str.replace(/&(lt|gt|nbsp|amp|quot);/ig,function(all,t){return arrEntities[t];}); 
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

/// �����Ƿ��н�����־ 
function hasLog(EpisodeID){

	var hasFlag = false;
	runClassMethod("web.DHCEMBedSideShiftQuery","HasLog",{"EpisodeID":EpisodeID, "Type":EmType},function(jsonString){

		if (jsonString == 1){
			hasFlag = true;
		}else{
			$.messager.alert("��ʾ:","�ò����޽�����־��","warning");
		}
	},'',false)
	return hasFlag;
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