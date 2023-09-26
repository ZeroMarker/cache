//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2016-12-22
// ����:	   ������벿λѡ�����
//===========================================================================================

var oeori = "";

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParam();     ///  ��ʼ��������Ϣ
	InitItemList();  ///  ҳ��DataGrid�������б�
	InitBlButton();  ///  ҳ��Button���¼�
	
	InitLoadData();  ///  ����ҽ����Ӧ��λ
}

/// ��ʼ�����ز��˾���ID
function InitParam(){
	oeori = getParam("oeori");
}

/// ҳ��DataGrid��ʼ����������б�
function InitItemList(){

	///  ����columns
	var columns=[[
		{field:'PartDesc',title:'��λ',width:180,align:'center'},
		{field:'PosiDesc',title:'��λ',width:120,align:'center'},
		{field:'ItemDisp',title:'����',width:160,align:'center'},
		{field:'ItemStat',title:'״̬',width:100,align:'center'},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'PartID',title:'PartID',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "ֹͣ"){
	            return 'background-color:Pink;'; 
	        }
	    }
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function InitBlButton(){
	
	///  ȡ��
	$('a:contains("ȡ��")').bind("click",cancel);
	
	///  ����
	$('a:contains("����")').bind("click",revExaReqItm);

}

/// ����ִ��ѡ����Ŀ
function revExaReqItm(){
	
	var rowData=$("#dmPartList").datagrid('getSelected'); /// ��ȡѡ����
	if (rowData == null){
		$.messager.alert("��ʾ:","����ѡ���������¼��");
		return;
	}
	if (rowData.ItemStat == "ֹͣ"){
		$.messager.alert("��ʾ:","��ǰ��¼��ֹͣ�������ٴγ�����");
		return;
	}
	if (rowData.ItemStat == "ִ��"){
		$.messager.alert("��ʾ:","��ǰ��¼��ִ�У����ܳ�����");
		return;
	}
	var arReqItmID = rowData.ItemID;  /// ��ĿID
	var PartID = rowData.PartID;      /// ��λID

	runClassMethod("web.DHCAPPExaReport","revExaReqItm",{"arRepItmID":arReqItmID, "PartID":PartID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == 1){
			$.messager.alert("��ʾ:","������ִ�в��ܽ��д˲�����");
			return;
		}
	    if (jsonString < 0){
			$.messager.alert("��ʾ:","ɾ������,������Ϣ:"+jsonString);
			return;
		}
	    if (jsonString == 0){
			$("#dmPartList").datagrid("reload");   /// ˢ��ҳ������
		}
	
	},'',false)
}

/// ��ʼ�����ز�λ����
function InitLoadData(){
	
	/// ��λ�����б�
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPartItmList&oeori="+oeori;
	$('#dmPartList').datagrid({url:uniturl});
}

/// �رմ���
function cancel(){
	
	window.close();
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })