//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-11-19
// ����:	   ȫԺmdt����ͳ�� JS
//===========================================================================================

var mdtParams = "";  /// �ϼ�ҳ�洫�ݲ�ѯ����
var pid = "";        /// ������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	
	InitMainList();    /// ��ʼ�������б�
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	mdtParams = getParam("mdtParams");   /// �ϼ�ҳ�洫�ݲ�ѯ����
}

/// ��ʼ���������
function InitComponents(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
		
	/// �����ϼ�ҳ�洫�����ÿ�ʼ���ڣ���������
	if (mdtParams != ""){
		$HUI.datebox("#StartDate").setValue(mdtParams.split("@")[0]);
		$HUI.datebox("#EndDate").setValue(mdtParams.split("@")[1]);
	}
	$HUI.combobox("#doctor",{
		valueField:'value',
		textField:'text',
		url:$URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonLocCareProvAll",
		mode:'remote',
		
		})
	
}

/// ��ʼ�����ؽ����б�
function InitMainList(){
	
	///  ����columns
	var columns=[[
		{field:'mdtUser',title:'ר��',width:200,align:'center'},
		{field:'mdtReqTimes',title:'�������',width:120,align:'center'},
		{field:'mdtCsTimes',title:'�������',width:120,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		headerCls:'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){

		},
		onLoadSuccess:function(data){
			if (typeof data.rows[0] != "undefined"){
				pid = data.rows[0].pid;
				InitDisGrpChart(); /// MDT����ҽ�����������
			}
		}
	};
	/// ��������
	var param = mdtParams;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtDocMap&Params="+param+ "&pid="+pid+"&MWToken="+websys_getMWToken();
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// ����
function SetCellUrl(value, rowData, rowIndex){
	
	return value;
//	var html = "<a href='#' onclick='Pop_Win()' style='margin:0px 5px;'>"+ value +"</a>";
//	return html;
}

/// ����
function Pop_Win(mdtMonth){
	
	var Link = "dhcmdt.disgroupstat.csp?mdtMonth="+ mdtMonth+"&MWToken="+websys_getMWToken();
	window.open(Link, '_blank', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ѯ
function find_click(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var params = StartDate +"@"+ EndDate;
	var doctor = $HUI.combobox("#doctor").getValue(); /// ����ҽ��
	params=params+"@@@@"+doctor
	$("#bmMainList").datagrid("load",{"Params":params, "pid":pid});
}

/// ��ӡ
function print_click(){
	
}

/// MDT����ҽ�����������
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtDocMapCharts",{"pid":pid},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			
			for (var i in ListDataObj){
				ListDataObj[i].group = $g(ListDataObj[i].group);
			}
			
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '',    ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('DisGrpCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
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

/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCMDTConsultQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    killTmpGlobal();  /// �����ʱglobal
}

/// �Զ�����ҳ�沼��
function onresize_handler(){
	$("#bmMainList").datagrid("resize");
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