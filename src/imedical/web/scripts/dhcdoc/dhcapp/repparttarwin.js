//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2016-12-22
// ����:	   ������벿λѡ�����
//===========================================================================================

var oeori = "";
var refRepPart=""

/// ҳ���ʼ������
function initPageDefault() {
	
	InitParam();     ///  ��ʼ��������Ϣ
	InitItemList();  ///  ҳ��DataGrid�������б�
	InitBlButton();  ///  ҳ��Button���¼�
	
	InitLoadData();  ///  ����ҽ����Ӧ��λ
}

/// ��ʼ�����ز��˾���ID
function InitParam(){
	oeori = getParam("oeori");
	refRepPart = getParam("refRepPart");
}

/// ҳ��DataGrid��ʼ����������б�
function InitItemList(){

	///  ����columns
	var columns=[[
		{field:"checkbox",checkbox:true},
		{field:'PartDesc',title:'��λ',width:280},
		{field:'ItemPrice',title:'�۸�',width:130},
		{field:'ItemStat',title:'״̬',width:130,formatter:SetCellFontColor},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'PartID',title:'PartID',width:100,hidden:true},
		{field:'TarFlag',title:'TarFlag',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		bodyCls: 'panel-header-gray',
		rownumbers: true,
		singleSelect: false,
		pagination: false,
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "ֹͣ"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onCheckAll:function (){
 			var rowsData = $("#dmPartList").datagrid("getRows");
    		for (var i = 0; i < rowsData.length; i++) {
      			if ((rowsData[i].ItemStat == "ֹͣ")||(rowsData[i].PartID == "")||((rowsData[i].ItemStat == "ִ��")&&(ServiceObj.TreatItmReqMode ==0))){
					$("input[type='checkbox']")[i + 1].checked=false
				}
	   
    		}
		   	SetCheckclick()
		    },
	    onCheck:function(rowIndex,rowData){
			if (rowData.ItemStat == "ֹͣ"){
				$(this).datagrid('unselectRow', rowIndex);
				$.messager.alert("��ʾ:","��ǰ��¼��ֹͣ�������ٴγ�����");
				return;
			}
			if ((rowData.ItemStat == "ִ��")&(rowData.PartID != "")&(ServiceObj.TreatItmReqMode ==0)){
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
			SetCheckclick()
		},
		onUncheck:function(rowIndex,rowData){
		   
			if (rowData.TarFlag == "N"){
	            var rowsData = $("#dmPartList").datagrid("getRows");
                for (var i = 0; i < rowsData.length; i++) {
                    $("#dmPartList").datagrid('uncheckAll');
                }
			}
			SetCheckclick()
		},
	    onClickRow:function(rowIndex, rowData){
		    
		    $(this).datagrid('unselectRow', rowIndex);
		},
		onLoadSuccess: function(data){
			/// ���ر�����checkbox
			/// $("#dmPartList").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
            /// ѭ������ֹͣ��Ŀcheckbox ����ѡ
            if (data.rows.length > 0) {
                for (var i = 0; i < data.rows.length; i++) {
                    if ((data.rows[i].ItemStat == "ֹͣ")||(data.rows[i].PartID == "")||((data.rows[i].ItemStat == "ִ��")&&(ServiceObj.TreatItmReqMode ==0))) {
                        $("input[type='checkbox']")[i + 1].disabled = true;
                    }
                }
            }
            if (refRepPart!=""){
	            var rowsData = $("#dmPartList").datagrid("getRows");
	            var refRepPartArry=refRepPart.split("!!")
			    for (var i = 0; i < rowsData.length; i++) {
			       //if ((rowsData[i].ItemStat == "ֹͣ")||((rowsData[i].ItemStat == "ִ��"))){
					 if (rowsData[i].ItemStat == "ֹͣ"){
						continue;
					}
					for (var j = 0; j < refRepPartArry.length; j++) {
						if (refRepPartArry[j]==rowsData[i].ItemID ){
							$("input[type='checkbox']")[i + 1].checked=true
							$(this).datagrid('selectRow', i );
							}
					}
			    }
	            refRepPart=""
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
	$('#Cancel').bind("click",cancel);
		
	///  ȷ��
	$('#BSave').bind("click",retExaReqItm);

}

/// ��ʼ�����ز�λ����
function InitLoadData(){
	
	/// ��λ�����б�
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPartItmList&oeori="+oeori;
	$('#dmPartList').datagrid({url:uniturl});
}

/// �˷�����ȷ������ȡִ��ѡ����Ŀ
function retExaReqItm(){

	var rowsData=$("#dmPartList").datagrid('getRows'); /// ��ȡѡ����
	if (rowsData.length == 0){
		$.messager.alert("��ʾ:","����ѡ����˷Ѽ�¼��");
		return;
	}
	var mItmListData = [];
	$.each(rowsData, function(index, rowData){
		var arReqItmID = rowData.ItemID;  /// ��ĿID
		var PartID = rowData.PartID;      /// ��λID
		var PartDesc = rowData.PartDesc;  /// ��λ����
		//if ((rowData.ItemStat == "ֹͣ")||(rowData.PartID == "")||((rowData.ItemStat == "ִ��")&&(ServiceObj.TreatItmReqMode ==0))) {
		if ($("input[type='checkbox']")[index + 1].checked==false){	
		}else{
			var ListData = arReqItmID +"^"+ PartDesc;
			mItmListData.push(ListData);
		}
	});
	websys_showModal("options").callBackFunc(mItmListData.join("!!"));
	websys_showModal("close");
}
function SetCheckclick(){
	var NeedFlag=1
	var rowsData = $("#dmPartList").datagrid("getRows");
    for (var i = 0; i < rowsData.length; i++) {
       if ((rowsData[i].ItemStat == "ֹͣ")||(rowsData[i].PartID == "")||((rowsData[i].ItemStat == "ִ��"))){
			continue;
		}
	   if ($("input[type='checkbox']")[i + 1].checked){}else{
		   NeedFlag=0
		   }
    }
    if (NeedFlag==0){
	    for (var i = 0; i < rowsData.length; i++) {
		 if ((rowsData[i].PartID == "")&&(rowsData[i].ItemStat != "ֹͣ")&&(rowsData[i].ItemStat != "ִ��")){
			 $("input[type='checkbox']")[i + 1].checked=false
			 }		
	    
	    }
	}else{
		for (var i = 0; i < rowsData.length; i++) {
		 if ((rowsData[i].PartID == "")&&(rowsData[i].ItemStat != "ֹͣ")&&(rowsData[i].ItemStat != "ִ��")){
			 $("input[type='checkbox']")[i + 1].checked=true
			 }		
	    
	    }
	} 
}
/// �رմ���
function cancel(){
	websys_showModal("options").callBackFunc("");
	websys_showModal("close");
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
