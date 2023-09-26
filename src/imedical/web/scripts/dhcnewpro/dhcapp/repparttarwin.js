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
		{field:"checkbox",checkbox:"true"},
		{field:'PartDesc',title:'��λ',width:280,align:'center'},
		{field:'ItemPrice',title:'�۸�',width:130,align:'center'},
		{field:'ItemStat',title:'״̬',width:130,align:'center',formatter:SetCellFontColor},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'PartID',title:'PartID',width:100,hidden:true},
		{field:'TarFlag',title:'TarFlag',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		border : false,
		rownumbers : true,
		singleSelect : false,
		pagination: false,
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "ֹͣ"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onCheck:function(rowIndex,rowData){
		   
			if (rowData.ItemStat == "ֹͣ"){
				$(this).datagrid('unselectRow', rowIndex);
				$.messager.alert("��ʾ:","��ǰ��¼��ֹͣ�������ٴγ�����");
				return;
			}
			if ((rowData.ItemStat == "ִ��")&(rowData.PartID != "")){
				$(this).datagrid('unselectRow', rowIndex);
				$.messager.alert("��ʾ:","��ǰ��¼��ִ�У����ܳ�����");
				return;
			}
			if (rowData.TarFlag == "N"){
	            var rowsData = $("#dmPartList").datagrid("getRows");
                for (var i = 0; i < rowsData.length; i++) {
                    $("#dmPartList").datagrid('checkAll');
                }
			}
		},
		onUncheck:function(rowIndex,rowData){
		   
			if (rowData.TarFlag == "N"){
	            var rowsData = $("#dmPartList").datagrid("getRows");
                for (var i = 0; i < rowsData.length; i++) {
                    $("#dmPartList").datagrid('uncheckAll');
                }
			}
		},
	    onClickRow:function(rowIndex, rowData){
		    
		    $(this).datagrid('unselectRow', rowIndex);
		},
		onLoadSuccess: function(data){
			/// ���ر�����checkbox
			$("#dmPartList").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
            /// ѭ������ֹͣ��Ŀcheckbox ����ѡ
            if (data.rows.length > 0) {
                for (var i = 0; i < data.rows.length; i++) {
                    if ((data.rows[i].ItemStat == "ֹͣ")||(data.rows[i].PartID == "")||(data.rows[i].ItemStat == "ִ��")) {
                        $("input[type='checkbox']")[i + 1].disabled = true;
                    }
                }
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
		
	///  ȷ��
	$('a:contains("ȷ��")').bind("click",retExaReqItm);

}

/// ��ʼ�����ز�λ����
function InitLoadData(){
	
	/// ��λ�����б�
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPartItmList&oeori="+oeori;
	$('#dmPartList').datagrid({url:uniturl});
}

/// �˷�����ȷ������ȡִ��ѡ����Ŀ
function retExaReqItm(){

	var rowsData=$("#dmPartList").datagrid('getSelections'); /// ��ȡѡ����
	if (rowsData.length == 0){
		$.messager.alert("��ʾ:","����ѡ��������¼��");
		return;
	}
	
	var mItmListData = [];
	$.each(rowsData, function(index, rowData){
		var arReqItmID = rowData.ItemID;  /// ��ĿID
		var PartID = rowData.PartID;      /// ��λID
		var PartDesc = rowData.PartDesc;  /// ��λ����
		var ListData = arReqItmID +"^"+ PartDesc;
		mItmListData.push(ListData);
	})
	
	window.returnValue = mItmListData.join("!!");
	window.close();
}

/// �رմ���
function cancel(){
	
	window.close();
}

/// ����������ʾ��ɫ
function SetCellFontColor(value, rowData, rowIndex){
	
	var htmlstr = value;
	if (rowData.ItemStat == "ִ��"){
		htmlstr = "<span style='color:red; font-weight:bold'>"+value+"</span>"
	}else{
		htmlstr = "<span style='color:green; font-weight:bold'>"+value+"</span>"
	}
	return htmlstr;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })