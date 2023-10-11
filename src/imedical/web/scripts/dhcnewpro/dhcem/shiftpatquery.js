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
var pid = "";           /// ������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var ItemTypeArr = [{"value":"���","text":'���'}, {"value":"�а�","text":'�а�'}, {"value":"ҹ��","text":'ҹ��'}];;

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	
	InitMainList();    /// ��ʼ�������б�
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
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
	if (EmType == "Nur"){
		$("#MedGrp").next(".combo").hide();
		$("#MedGrpLabel").hide();
	}
}

/// ��ʼ�����ؽ����б�
function InitMainList(){
	
	///  ����columns
	var columns=[[
		{field:'BsItmID',title:'BsItmID',width:100,hidden:true},
		{field:'Log',title:'����',width:70,align:'center',formatter:SetCellLogUrl},
		{field:'bsDate',title:'��������',width:120},
		{field:'PatBed',title:'����',width:60},
		{field:'Type',title:'����',width:80,styler:setCellType},
		{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'PatName',title:'����',width:100},
		{field:'bsSchedule',title:'���',width:120},
		{field:'bsUser',title:'������',width:120},
		{field:'bsAccUser',title:'�Ӱ���',width:120},
		{field:'bsBackground',title:'����',width:320},
		{field:'bsAssessment',title:'����',width:320},
		{field:'bsSuggest',title:'����',width:320},
	]];
	
	///  ����datagrid
	var option = {
		headerCls:'panel-header-gray',
		title:'',
		toolbar:'#toolbar',
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
				pid = data.rows[0].pid;
			}else{
				$("#bmDetList").datagrid("load",{"Params":0});
			}
		},
        rowStyler:function(rowIndex, rowData){
//			if(rowData.bsStatus != "Y"){
//				return 'background-color:#fec0c0;';
//			}
		}
	};
	/// ��������
	var param = "^^^^^" + EmType +"^"+ pid+"^^"+LgHospID; //hxy 2020-06-05 +"^^"+LgHospID
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShiftQuery&MethodName=GetEmPatShiftHis&Params="+param;
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// ����
function setCellType(value, row, index){
	
	if (value == "����"){
		return 'background-color:#F16E57;color:white';
	}else if (value == "����"){
		return 'background-color:#FFB746;color:white';
	}else if (value == "����"){
		return 'background-color:#2AB66A;color:white';
	}else if (value == "��ɫ"){
		return 'background-color:#449be2;color:white';
	}else{
		return '';
	}
}

/// ����
function SetCellLogUrl(value, rowData, rowIndex){
	
	var html = "<a href='#' onclick='log("+ rowData.EpisodeID +")' style='display:block;width:38px;background:#7dba56;padding:3px 6px;color:#fff;border-radius: 4px 4px 4px 4px;'>"+$g("��־")+"</a>";
	return html;
}

/// �ǼǺ�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		find_click();  /// ��ѯ
	}
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

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
	var PatNo = $("#PatNo").val();    /// �ǼǺ�
	var params = StartDate +"^"+ EndDate +"^"+ WardID +"^"+ Schedule +"^"+ MedGrpID +"^"+ EmType +"^"+ pid +"^"+ PatNo+"^"+LgHospID; //hxy 2020-06-05
	$("#bmMainList").datagrid("load",{"Params":params}); 
}

/// ��ӡ
function print_click(){
	
}

/// ����
function export_click(){
	
	if (pid == "") {
		$.messager.alert("��ʾ:","����Ϊ�գ��޷�������","warning");
		return;
	}
	
	runClassMethod("web.DHCEMBedSideShiftQuery","GetPrintDetail",{"pid":pid},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","�����쳣��","warning");
		}else{
			var jsonObjArr = jsonString;
			Export_Xml(jsonObjArr);
		}
	},'json',false)	
}

/// �鿴��־
function log(EpisodeID){
	var link="dhcem.pattimeaxis.csp?PatientID=&EpisodeID="+ EpisodeID +"&EmType="+ EmType;
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	commonShowWin({
		url:link,
		title:"���ν�����Ϣ",
		height: (window.screen.availHeight - 180)	
	})
}

/// �����Ű��¼
function Export_Xml(jsonObjArr){

	var str = '(function test(x){' +
		'var xlApp = new ActiveXObject("Excel.Application");'  +
		'var xlBook = xlApp.Workbooks.Add();' +
		'var objSheet = xlBook.ActiveSheet;' +
		
		'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true;' + //�ϲ���Ԫ��
		'objSheet.Cells(1, 1).value = "'+$g("���ｻ�ಡ���б�")+'";'+		 
		'objSheet.Cells(2, 1).value = "'+$g("��������")+'";' +  /// ��������
		'objSheet.Cells(2, 2).value = "'+$g("����")+'";' +      /// ����
		'objSheet.Cells(2, 3).value = "'+$g("����")+'";' +      /// ����
		'objSheet.Cells(2, 4).value = "'+$g("���")+'";' +      /// ���
		'objSheet.Cells(2, 5).value = "'+$g("������")+'";' +    /// ������
		'objSheet.Cells(2, 6).value = "'+$g("�Ӱ���")+'";' +    /// �Ӱ���
		'objSheet.Cells(2, 7).value = "'+$g("����")+'";' +      /// ����
		'objSheet.Cells(2, 8).value = "'+$g("����")+'";' +      /// ����
		'objSheet.Cells(2, 9).value = "'+$g("����")+'";'        /// ����
		str = str +setCellLine("",2,1,9);
		for (var i=0; i<jsonObjArr.length; i++){
			str = str +
			'objSheet.Cells('+ (3+ i) +', 1).NumberFormatLocal = "@";' +           /// ���õ���Ϊ�ı�
			'objSheet.Cells('+ (3+ i) +', 1).value = "' +jsonObjArr[i].bsDate +'";' +      /// ��������
			'objSheet.Cells('+ (3+ i) +', 2).value = "' +jsonObjArr[i].PatBed +'";' +      /// ����
			'objSheet.Cells('+ (3+ i) +', 3).value = "' +jsonObjArr[i].PatName +'";' +     /// ����
			'objSheet.Cells('+ (3+ i) +', 4).value = "' +jsonObjArr[i].bsSchedule +'";' +  /// ���
			'objSheet.Cells('+ (3+ i) +', 5).value = "' +jsonObjArr[i].bsUser +'";' +      /// ������
			'objSheet.Cells('+ (3+ i) +', 6).value = "' +jsonObjArr[i].bsAccUser +'";' +   /// �Ӱ���
			'objSheet.Cells('+ (3+ i) +', 7).value = "' +escape2Html(jsonObjArr[i].bsBackground) +'";' +    /// ����
			'objSheet.Cells('+ (3+ i) +', 8).value = "' +escape2Html(jsonObjArr[i].bsAssessment) +'";'      /// ����
			var bsSuggest = "";
			if (jsonObjArr[i].bsSuggest != ""){
				bsSuggest = jsonObjArr[i].bsSuggest.replace(/<\/?[^>]*>/g,"");
			}
			str = str +
			'objSheet.Cells('+ (3+ i) +', 9).value = "' + escape2Html(bsSuggest.replace(/(\n)/g, "")) +'";'   /// ����
			str = str +setCellLine("",3+i,1,9);
		}
		str = str +
		"xlApp.Visible=true;" +
		'xlBook.SaveAs("'+$g("���������ϸ")+'.xlsx");' +
		'xlApp=null;' +
		'objSheet=null;' +
		"return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.CurrentUserEvalJs(str);   //ͨ���м�����д�ӡ���� 
	return;
		
//	var xlApp = new ActiveXObject("Excel.Application");
//	var xlBook = xlApp.Workbooks.Add();
//	var objSheet = xlBook.ActiveSheet;
//	
//	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true; //�ϲ���Ԫ��
//	objSheet.Cells(1, 1).value = "���ｻ�ಡ���б�";
//	
//	objSheet.Cells(2, 1).value = "��������";  /// ��������
//	objSheet.Cells(2, 2).value = "����";      /// ����
//	objSheet.Cells(2, 3).value = "����";      /// ����
//	objSheet.Cells(2, 4).value = "���";  	/// ���
//	objSheet.Cells(2, 5).value = "������";    /// ������
//	objSheet.Cells(2, 6).value = "�Ӱ���";    /// �Ӱ���
//	objSheet.Cells(2, 7).value = "����"       /// ����
//	objSheet.Cells(2, 8).value = "����";      /// ����
//	objSheet.Cells(2, 9).value = "����";      /// ����
//	
//	for (var i=0; i<jsonObjArr.length; i++){
//		objSheet.Cells(3+i, 1).NumberFormatLocal = "@";//���õ���Ϊ�ı�
//		objSheet.Cells(3+i, 1).value = jsonObjArr[i].bsDate;      /// ��������
//		objSheet.Cells(3+i, 2).value = jsonObjArr[i].PatBed;      /// ����
//		objSheet.Cells(3+i, 3).value = jsonObjArr[i].PatName;     /// ����
//		objSheet.Cells(3+i, 4).value = jsonObjArr[i].bsSchedule;  /// ���
//		objSheet.Cells(3+i, 5).value = jsonObjArr[i].bsUser;      /// ������
//		objSheet.Cells(3+i, 6).value = jsonObjArr[i].bsAccUser;   /// �Ӱ���
//		objSheet.Cells(3+i, 7).value = jsonObjArr[i].bsBackground;  /// ����
//		objSheet.Cells(3+i, 8).value = jsonObjArr[i].bsAssessment;  /// ����
//		var bsSuggest = "";
//		if (jsonObjArr[i].bsSuggest != ""){
//			bsSuggest = jsonObjArr[i].bsSuggest.replace(/<\/?[^>]*>/g,'')
//		}
//		objSheet.Cells(3+i, 9).value = bsSuggest;     /// ����
//		setCellLine(objSheet,3+i,1,9);
//	}
//	//objSheet.printout();
//	objSheet.Application.Visible = true;
//	xlBook.SaveAs("���������ϸ.xlsx");
//	xlApp=null;
//	//xlBook.Close(savechanges=false);
//	objSheet=null;	
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
	str = str.replace(/\s/g," ");
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

/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}


/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCEMBedSideShiftQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    killTmpGlobal();  /// �����ʱglobal
}

window.onload = onload_handler;
window.onresize = onresize_handler;
window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
