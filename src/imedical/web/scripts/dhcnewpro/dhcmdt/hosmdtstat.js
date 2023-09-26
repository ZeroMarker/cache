//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-11-19
// ����:	   ȫԺmdt����ͳ�� JS
//===========================================================================================

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
	
}

/// ��ʼ���������
function InitComponents(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
}

/// ��ʼ�����ؽ����б�
function InitMainList(){
	
	///  ����columns
	var columns=[[
		{field:'mdtMonth',title:'�·�',width:200,align:'center'},
		{field:'mdtDisQty',title:'��������',width:120,align:'center',formatter:SetCellUrl},
		{field:'mdtParams',title:'��ѯ����',width:200,align:'center',hidden:true}
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
				InitDisGrpChart(); /// MDT���ﲡ�ֲַ�
			}
		}
	};
	/// ��������
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var param =  StartDate +"@"+ EndDate;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtMonthMap&Params="+param+ "&pid="+pid;
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// ����
function SetCellUrl(value, rowData, rowIndex){

	var html = "<a href='#' onclick='Pop_Win(\""+ rowData.mdtParams +"\")' style='margin:0px 5px;'>"+ value +"</a>";
	return html;
}

/// ����
function Pop_Win(mdtParams){

	var Link = "dhcmdt.disgroupstat.csp?mdtParams="+ mdtParams;
	window.open(Link, '_blank', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ѯ
function find_click(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var params = StartDate +"@"+ EndDate;
	$("#bmMainList").datagrid("load",{"Params":params, "pid":pid});
}

/// ��ӡ
function print_click(){
	
}

/// MDT���ﲡ���·ֲ�
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtMonthMapCharts",{"pid":pid},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
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