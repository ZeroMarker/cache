//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-10-21
// ����:	   ���ֲ�ѯJS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	InitDetList();     /// ��ʼ���б�
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitDetList(){
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		//{field:'Type',title:'����',width:120},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:120},
		{field:'ScoreDesc',title:'���ֱ�',width:320},
		{field:'ScoreVal',title:'��ֵ',width:100,formatter:
			function (value, row, index){
				if (value != ""){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'User',title:'������',width:120,},
		{field:'Date',title:'��������',width:120},
		{field:'Time',title:'����ʱ��',width:120},
		{field:'Detail',title:'����',width:120,align:'center',formatter:
			function (value, row, index){
				return '<a href="#" onclick="review(\''+ row.ID +'\',\''+ row.ScoreID +'\')">����</a>';
			}
		}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
		},
		onDblClickRow: function (rowIndex, rowData) {

        }
	};
	/// ��������
	var param = "^^^^"+LgHospID; //hxy 2020-06-09 ""
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreQuery&MethodName=JsGetScore&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ���ֱ�Ԥ��
function review(ID, ScoreID){
	
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}
	var link = "dhcemc.scoretabreview.csp?ScoreID="+ ScoreID +"&ID=" + ID +"&EditFlag=0";
	window.open(link, '_blank', 'height='+ (window.screen.availHeight - 180) +', width=1200, top=50, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ѯ
function find_click(){

	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var PatNo = $("#PatNo").val();  /// �ǼǺ�
	var params = StartDate +"^"+ EndDate +"^"+ PatNo+"^^"+LgHospID; //hxy 2020-06-09 +"^^"+LgHospID
	$("#bmDetList").datagrid("load",{"Params":params});
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