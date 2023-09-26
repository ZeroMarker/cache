//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-10-31
// ����:	   ����ҽ�����౾JS
//===========================================================================================

var BsID = "";          /// ����ID
var EmType = "Doc";     /// ��������
var Pid = "";           /// ����ID
var CompFlag = "";      /// ��ɱ�־
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var ItemTypeArr = [{"value":"���","text":'���'}, {"value":"�а�","text":'�а�'}, {"value":"ҹ��","text":'ҹ��'}];

/// ҳ���ʼ������
function initPageDefault(){
	
	InitDetList();     /// ��ʼ���б�
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	InitShiftsItem();  /// ����Table�б�
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	
}

/// ��ʼ���������
function InitComponents(){
	
	/// ��������
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	
	/// ҽ������
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMedUnit&LocID="+ LgLocID;
	$HUI.combobox("#MedGrp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			
	    }	
	})
	
	/// ���
	var uniturl = $URL+"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimeInterval&HospID="+ LgHospID +"&Module=Doc";
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
		
	/// ���
	clearPages();
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitDetList(){
	
	///  ����columns
	var columns=[[
		{field:'WriFlag',title:'״̬',width:75,align:'center',formatter:SetCellWriFlag},
		{field:'PatBed',title:'����',width:70},
		{field:'Type',title:'����',width:80,styler:setCellType},
		{field:'PatLoc',title:'����',width:100},
		{field:'Oper',title:'����',width:100,align:'center',formatter:SetCellUrl},
		//{field:'PatLev',title:'��ǰ����',width:90,align:'center',formatter:setCellLevLabel},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'ObsTime',title:'����ʱ��',width:90},
		{field:'PatName',title:'����',width:90},
		{field:'PatSex',title:'�Ա�',width:50},
		{field:'PatAge',title:'����',width:90},
		{field:'WaitToHos',title:'����Ժ����',width:220},
		//{field:'mainDoc',title:'����ҽ��',width:120,align:'center'},
		{field:'PatDiag',title:'���',width:220},
		{field:'BsBackground',title:'����',width:320},
		{field:'BsAssessment',title:'����',width:320},
		{field:'BsSuggest',title:'����',width:320},
		{field:'BsItmID',title:'BsItmID',width:80}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		pageSize : [60],
		pageList : [60,90],
		onLoadSuccess:function(data){
			if (typeof data.Pid != "undefined"){
				Pid = data.Pid;
			}		
		},
		onDblClickRow: function (rowIndex, rowData) {

        }
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ����
function SetCellUrl(value, rowData, rowIndex){
	
	var html = "";
	if (rowData.CompFlag != "Y"){
		html = "<a href='#' onclick='wri("+ rowIndex +")' title='�༭' style='margin:0px 5px;'><img src='../scripts/dhcnewpro/dhcem/images/write_order.png' border=0/></a>";
	    html += "<a href='#' onclick='del("+ rowIndex +")' title='ɾ��' style='margin:0px 5px;'><img src='../scripts/dhcnewpro/dhcem/images/cancel.png' border=0/></a>";
	}
	html += "<a href='#' onclick='log("+ rowData.EpisodeID +")' title='��־' style='margin:0px 5px;'><img src='../scripts/dhcnewpro/dhcem/images/eye.png' border=0/></a>";
	return html;
}

/// �ּ�
function setCellLevLabel(value, rowData, rowIndex){
	
	var fontColor = "";
	if ((value == "1��")||(value == "2��")){ fontColor = "#F16E57";}
	if (value == "3��"){ fontColor = "#FFB746";}
	if (value == "4��"){ fontColor = "#2AB66A";}
	return "<font color='" + fontColor + "'>"+value+"</font>";
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
function SetCellWriFlag(value, rowData, rowIndex){
	
	var html = "<span style='display:block;width:45px;background:#7dba56;padding:3px 6px;color:#fff;border-radius: 4px 4px 4px 4px;'>"+ (value == "Y"?"����":"δ��")+"</span>";
	return html;
}

/// ���ؽ�����Ϣ
function GetEmShift(InBsID){
	
	BsID = InBsID;
	GetEmShiftObj(BsID);  /// ��ʼ�����ؼӰ�����Ϣ
	GetEmLinkItem(BsID);  /// ��ʼ��������Ŀ
	$("#bmDetList").datagrid("load",{"Params":BsID +"^"+ Pid});
}

/// ˢ�²����б�
function refresh(){
	$("#bmDetList").datagrid("reload");
}

/// ��ȡ������Ϣ
function GetEmShiftObj(BsID){
	
	runClassMethod("web.DHCEMBedSideShift","JsGetEmShiftObj",{"BsID":BsID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsEmShiftObj(jsonObjArr);
		}
	},'json',false)
}

/// ���ý�����Ϣ
function InsEmShiftObj(itemobj){
	
	/// ҽ������
	$HUI.combobox("#MedGrp").setValue(itemobj.MedGrpID);
	$HUI.combobox("#MedGrp").disable();
    /// ���ಡ��
	$HUI.combobox("#Ward").setValue(itemobj.WardID);
	$HUI.combobox("#Ward").disable();
    /// ������
	$HUI.combobox("#Schedule").setValue(itemobj.Schedule);
	$HUI.combobox("#Schedule").disable();
    /// ��������
	$HUI.datebox("#WrDate").setValue(itemobj.WrDate);
	/// ������Ա
	$("#CarePrv").val(itemobj.UserName);
	$("#PassWord").val("");
	/// �Ӱ���Ա
	$("#RecUser").val(itemobj.RecUser);
	$("#bt_find").linkbutton('disable');  /// ��ѯ��ť
	if (itemobj.CompFlag == "Y"){
		$("#bt_del").linkbutton('disable');   /// ɾ����ť
		$("#bt_sure").linkbutton('disable');  /// ȷ�ϰ�ť
		$("#bt_add").linkbutton('disable');   /// ������ť
	}else{
		$("#bt_del").linkbutton('enable');   /// ɾ����ť
		$("#bt_sure").linkbutton('enable');  /// ȷ�ϰ�ť
		$("#bt_add").linkbutton('enable');   /// ������ť	
	}
	CompFlag = itemobj.CompFlag;
}

/// ��ʼ��������Ŀ
function GetEmLinkItem(BsID){
	
	$("input[name='item']").val("");     /// ��ս������
	runClassMethod("web.DHCEMBedSideShift","JsGetLnkItemObj",{ "BsID":BsID },function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				if ($("#"+jsonObjArr[i].itmID)){
					$("#"+jsonObjArr[i].itmID).val(jsonObjArr[i].itmVal);
				}
			}
		}
	},'json',false)
}

/// ���ҳ��Ԫ������
function clearPages(){
	
	BsID = "";      /// ����ID
	CompFlag = "";  /// ��ɱ�־
	/// ҽ������
	$HUI.combobox("#MedGrp").setValue("");
	$HUI.combobox("#MedGrp").enable();
    /// ���ಡ��
	$HUI.combobox("#Ward").setValue("");
	$HUI.combobox("#Ward").enable();
    /// ������
	$HUI.combobox("#Schedule").setValue("");
	$HUI.combobox("#Schedule").enable();
    /// ��������
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	/// ������Ա
	$("#CarePrv").val(session['LOGON.USERNAME']);
	$("#PassWord").val("");
	/// �Ӱ���Ա
	$("#RecUser").val("");
	$("#bmDetList").datagrid("loadData", { total: 0, rows: [] });
	
	$("#bt_find").linkbutton('enable');  /// ��ѯ��ť
	$("#bt_del").linkbutton('enable');   /// ɾ����ť
	$("#bt_sure").linkbutton('enable');  /// ȷ�ϰ�ť
	$("#bt_add").linkbutton('enable');   /// ������ť
	
	$("input[name='item']").val("");     /// �������
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

/// ����Table�б�
function InitShiftsItem(){
	
	/// ��ʼ����鷽������
	//$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	// ��ȡ��ʾ����
	runClassMethod("web.DHCEMDicItem","JsGetColumns",{"mCode":"BSD", "HospID":session['LOGON.HOSPID']},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ������Ŀ�б�
function InitCheckItemRegion(itemArr){	

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td align="right" class="tb_td_bk">'+ itemArr[j-1].title +'</td><td><input id="'+ itemArr[j-1].field +'" name="item" class="hisui-validatebox" style="width:60px;"></input></td>');
		if (j % 7 == 0){
			itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 7 != 0){
		var fixhtml = "";
		var remainder = (j-1) % 4;
		if (remainder == 3){fixhtml = "<td></td><td></td>"}
		if (remainder == 2){fixhtml = "<td></td><td></td><td></td><td></td>"}
		if (remainder == 1){fixhtml = "<td></td><td></td><td></td><td></td><td></td><td></td>"}
		itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + fixhtml + '</tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr)
	$.parser.parse($('#itemList'));  /// ���½���
}

/// ���ɽ����¼
function takShift(){
	
	var WrDate = $HUI.datebox("#WrDate").getValue();       /// ��������
	
	var MedGrpID = $HUI.combobox("#MedGrp").getValue(); /// ҽ����
	if ((MedGrpID == "")&(EmType == "Doc")){
		//$.messager.alert("��ʾ:","��ѡ��ҽ��С�飡","warning");
		//return;
	}
	
	var WardID = $HUI.combobox("#Ward").getValue();     /// ������
	if (WardID == ""){
		$.messager.alert("��ʾ:","��ѡ�����۲�����","warning");
		return;
	}
	
	var Schedule = $HUI.combobox("#Schedule").getValue();  /// ������
	if (Schedule == ""){
		$.messager.alert("��ʾ:","�����β���Ϊ�գ�","warning");
		return;
	}

	/// ҽ���� +"^"+ ������ +"^"+ ��� +"^"+ �������� +"^"+ �������� +"^"+ ������Ա +"^"+ ���������� +"^"+ ҽԺID
	var mParams = MedGrpID +"^"+ WardID +"^"+ Schedule +"^"+ WrDate +"^"+ EmType +"^"+ LgUserID +"^"+ "BSD" +"^"+ LgHospID;

	/// ����
	runClassMethod("web.DHCEMBedSideShift","Insert",{"BsID":BsID, "mParams":mParams, "Pid":Pid},function(jsonString){
		if (jsonString < 0){
		   if(jsonString == "-1"){
			   $.messager.alert("��ʾ:","�ð�����м�¼���뵽<font style='color:red;font-weight:bold;'>������־</font>�����ѯ��","warning");
	       }else{
			   $.messager.alert("��ʾ:","��������Ϣ����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		   }
		}else{
			GetEmShift(jsonString);  /// ��ȡ������Ϣ
			$.messager.alert("��ʾ:","���ɽ���ɹ���","warning");
		}
	},'',false)
}

/// �����б���
function OpenBedLisWin(){
	
	commonShowWin({
		url:"dhcem.bedsideshiftquery.csp?Type=T&EmType=Doc",
		title:"���౾��ѯ"	
	})
}

/// �༭
function wri(index){
	
	var rowDatas = $('#bmDetList').datagrid('getRows');
	var bsItemID = rowDatas[index].BsItmID;
//	if (bsItemID == ""){
//		$.messager.alert("��ʾ:","����ѡ���轻�ಡ�˼�¼��","warning");
//		return;
//	}
	if (CompFlag == "Y"){
		$.messager.alert("��ʾ:","��ǰ�����Ѿ�ȷ�ϣ����ܱ༭��","warning");
		return;
	}
	var EpisodeID = rowDatas[index].EpisodeID; /// ����ID
	
	commonShowWin({
		url:"dhcem.wirtebedshift.csp?bsID="+ BsID +"&bsItemID="+ bsItemID +"&EpisodeID="+ EpisodeID +"&EmType=Doc" +"&Pid="+ Pid,
		title:"����¼��",
		width: (window.screen.availWidth - 20),
		height: (window.screen.availHeight - 150)
	})
}

/// ɾ��
function del(index){
	
	var rowDatas = $('#bmDetList').datagrid('getRows');
	var bsItemID = rowDatas[index].BsItmID;
	if (bsItemID == ""){
		$.messager.alert("��ʾ:","��ǰ����δ��д�����¼������ɾ����","warning");
		return;
	}
	if (CompFlag == "Y"){
		$.messager.alert("��ʾ:","��ǰ�����Ѿ�ȷ�ϣ�����ɾ����","warning");
		return;
	}
	
	$.messager.confirm("ɾ��", "ȷ��Ҫɾ���˲��˽����¼?", function (r) {
		if (r) {
			delBsPat(bsItemID);
		}
	});
}

/// ����
function add(){

	if (BsID == ""){
		$.messager.alert("��ʾ:","����ѡ������ɽ����¼��","warning");
		return;
	}
	
	commonShowWin({
		url:"dhcem.addpat.csp?BsID="+ BsID +"&Pid="+ Pid,
		title:"����",
		width: 600,
		height: 270
	})
}

/// ɾ��
function delBsPat(bsItemID){
	
	runClassMethod("web.DHCEMBedSideShift","DelBsPat",{ "bsItemID":bsItemID },function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","ɾ��ʧ�ܣ�","warning");
		}else{
			$.messager.alert("��ʾ:","ɾ���ɹ���","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// �鿴��־
function log(EpisodeID){
	
	if (!hasLog(EpisodeID)) return;  /// �����Ƿ��н�����־ 
	
	commonShowWin({
		url:"dhcem.pattimeaxis.csp?PatientID=&EpisodeID="+ EpisodeID +"&EmType=Doc",
		title:"���ν�����Ϣ",
		height: (window.screen.availHeight - 180)	
	})
}

/// ȷ��
function sure(){
	
	$.messager.confirm("ȷ��", "ȷ��Ҫ�ύ���ν����¼?ȷ��֮�������ٽ����޸ģ�", function (r) {
		if (r) {
			sureBs();
		}
	});
}

/// ȷ��
function sureBs(){
	
	var rowDatas = $('#bmDetList').datagrid('getRows');
	if (rowDatas.length == 0){
		$.messager.alert("��ʾ:","�����ಡ�˲���Ϊ�գ�","warning");
		return;	
	}
	
	var RecUser = $("#RecUser").val();    /// �Ӱ���
	if (RecUser == ""){
		$.messager.alert("��ʾ:","�Ӱ��˲���Ϊ�գ�","warning");
		return;
	}
	//if (!IsValAccUser(RecUser)) return;  /// ��֤�Ӱ����Ƿ���д��ȷ
	
	if (!IsValPassWord()) return;        /// ��֤����
	
	var items = $("input[name='item']"); /// �������
	var itemArr = [];
	for(var i=0; i<items.length; i++){
		if (items[i].value != ""){
			itemArr.push(items[i].id +"@"+ items[i].value);
		}
	}
	
	/// ����Ϣ
	var mListData = RecUser +"^"+ itemArr.join("#");
	
	runClassMethod("web.DHCEMBedSideShift","InsBsSure",{ "BsID":BsID , "mListData":mListData},function(jsonString){

		if (jsonString == -1){
			$.messager.alert("��ʾ:","�����¼Ϊ�ջ���������δ��д�����¼�����ܽ���ȷ�ϲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","ȷ��ʧ�ܣ�","warning");
		}else{
			$.messager.alert("��ʾ:","ȷ�ϳɹ���","warning");
			GetEmShift(BsID);  /// ��ȡ������Ϣ
		}
	},'',false)
}

/// ǩ����֤
function IsValPassWord(){

	var PassWord = $("#PassWord").val(); /// ǩ������
	if (PassWord == ""){
		$.messager.alert("��ʾ:","������ǩ�����벻��Ϊ�գ�","warning");
		return false;
	}
	
	var userName = $("#CarePrv").val(); /// ������
	
	var success = false;
	runClassMethod("web.DHCEMBedSideShift","IsValPassWord",{"userName":userName, "passWord":PassWord},function(jsonString){

		if (jsonString == 0){
			success = true;
		}else{
			$.messager.alert("��ʾ:",jsonString,"warning");
		}
	},'',false)
	return success;
}

/// ��֤�Ӱ����Ƿ���д��ȷ
function IsValAccUser(userName){

	var success = false;
	runClassMethod("web.DHCEMBedSideShift","IsValAccUser",{"userName":userName},function(jsonString){

		if (jsonString != ""){
			success = true;
		}else{
			$.messager.alert("��ʾ:","�Ӱ�����д����","warning");
		}
	},'',false)
	return success;
}

/// ɾ�������¼
function delShifts(){

	if (BsID == ""){
		$.messager.alert("��ʾ:","����ѡ��һ�ν����¼�����ԣ�");
		return;
	}
	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ����ǰ�����¼��', function(r){
		if (r){
			runClassMethod("web.DHCEMBedSideShift","deleteBs",{"BsID":BsID},function(jsonString){

				if (jsonString < 0){
					$.messager.alert("��ʾ:","ɾ�������¼ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
				}else{
					$.messager.alert("��ʾ:","ɾ���ɹ���");
					clearPages(); /// ��ս�������
				}
			},'',false)
		}
	});
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

/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCEMBedSideShift","killTmpGlobal",{"Pid":Pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    killTmpGlobal();  /// �����ʱglobal
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
window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })