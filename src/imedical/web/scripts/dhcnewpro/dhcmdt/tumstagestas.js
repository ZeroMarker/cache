//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-08-18
// ����:	   MDT������ͬ���������ռ���� JS
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

/// ��ʼ����������״̬�б�
function InitMainList(){
	
	///  ����columns
	var columns=[[
		{field:'TumStage',title:'����',width:200,align:'center',formatter:function(value){return $g(value);}},
		{field:'DisQty',title:'��������',width:120,align:'center'},

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
	var param =  StartDate +"^"+ EndDate;
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetTumStageMap&Params="+param+ "&pid="+pid+"&MWToken="+websys_getMWToken();
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}



/// ��ѯ
function find_click(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var params = StartDate +"^"+ EndDate;
	$("#bmMainList").datagrid("load",{"Params":params, "pid":pid});
}


/// MDT���ﲡ���·ֲ�
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTStatistics","JsGetTumStageMapCharts",{"pid":pid},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			
			for (var i in ListDataObj){
				ListDataObj[i].name?ListDataObj[i].name=$g(ListDataObj[i].name):"";
			}
			
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				text: '',    ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('TumStageCharts');
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