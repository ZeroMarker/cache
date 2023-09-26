//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2016-07-23
// ����:	   ������벿λѡ�����
//===========================================================================================

var itmmastid = "";
var mListData = "";

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParam();     ///  ��ʼ��������Ϣ
	initItemList();  ///  ҳ��DataGrid�������б�
	initBlButton();  ///  ҳ��Button���¼�
	
	LoadPartTree();  /// ��λ��
    LoadItemPosi();  /// ��λ
    LoadItemDisp();  /// ����
    initCheckBoxEvent();  ///  ҳ��CheckBox�¼�
}

/// ��ʼ�����ز��˾���ID
function InitParam(){
	itmmastid = getParam("itmmastid");
	mListData = getParam("mListData");
}

/// ҳ��DataGrid��ʼ����������б�
function initItemList(){
	
	///  ����columns
	var columns=[[
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemPart',title:'��λ',width:300},
		{field:'ItemOpt',title:'����',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	///  ����datagrid
	var option = {
		title : '��ѡ��λ',
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// ����
function SetCellOpUrl(value, rowData, rowIndex){
	var html = "<a href='#' onclick='delItmSelRow("+rowIndex+")'>ɾ��</a>";
    return html;
}

/// ɾ����
function delItmSelRow(rowIndex){
	
	/// ɾ����
	$("#dmPartList").datagrid('deleteRow',rowIndex);
	/// ˢ���б�����
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#dmPartList').datagrid('refreshRow', index);
	})
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ȡ��
	$('a:contains("ȡ��")').bind("click",cancel);
	
	///  ȷ��
	$('a:contains("ȷ��")').bind("click",sure);
	
	///  ƴ����
	$("#ExaCatCode").bind("keyup",findExaItmTree);
}

/// ��ʼ����鲿λ��
function LoadPartTree(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        if (checked){
		        	addItmSelList(node.id, node.text);
		        }else{
			    	delItmSelList(node.id);
			    }
	        }   
	    },
	    onLoadSuccess:function(node, data){
	    	initPageBaseInfo(); /// ��ʼ������ҳ���������
	    },
	    onClick:function(node){
			if (node.checked){
				$("#CheckPart").tree('uncheck',node.target);
			}else{
				$("#CheckPart").tree('check',node.target);
			}
		}
	};
	new CusTreeUX("CheckPart", url, option).Init();
}

/// ��λ
function LoadItemPosi(){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				if ($('input[name="ExaPosi"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaPosi" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmPosi").append(html);
				}
			}
		}
	},'json',false)
}

/// ������
function LoadItemDisp(){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				if ($('input[name="ExaDisp"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaDisp" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmDisp").append(html);
				}
			}
		}
	},'json',false)
}

/// ��ʼ��ҳ��CheckBox�¼�
function initCheckBoxEvent(){

	$("input[type=checkbox]").live('click',function(){
		
		///  ������
		if (this.name == "ExaDisp") {
			return;
		}
		
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
		})
	});
}

/// ������Ŀ�б�
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
}

/// ɾ���б�����
function delItmSelList(id){
	
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemID == id){
			delItmSelRow(index);  /// ɾ����Ӧ��
			return false;
		}
	})
}

/// ȷ��
function sure(){

	/// ��λ
	var arExaPosiID = "",arExaPosiDesc = "";
	if ($('input[name="ExaPosi"]:checked').length){
		arExaPosiID = $('input[name="ExaPosi"]:checked').val();
		arExaPosiDesc = $('input[name="ExaPosi"]:checked').parent().text();
	}

	/// ������
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("@");
	
	/// ��λ
	var arExaPartID = [],arExaPartDesc = [];
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		arExaPartID.push(selItem.ItemID);
		arExaPartDesc.push(selItem.ItemPart);
	})
	arExaPartID=arExaPartID.join("@");
	arExaPartDesc=arExaPartDesc.join("@");
	//���Ʋ�λ����Ϊ��   22222
    if (arExaPartID==""){
	   alert("��λ����Ϊ�գ�����ѡ��");
	   return false;
		
	}
	
	var mListData = arExaPartID +"^"+ arExaPartDesc +"^"+ arExaPosiID +"^"+ arExaPosiDesc +"^"+ arExaDispID +"^"+ arExaDispDesc

	window.returnValue=mListData;
	window.close();
}

/// �رմ���
function cancel(){
	
	window.close();
}

/// ��ʼ������ҳ���������
function initPageBaseInfo(){
	
	if (mListData == "") return;
	var ExaReqArr = mListData.split("||");
	/// ��λ
	if (ExaReqArr[0] != ""){
		var ExaReqPartArr = ExaReqArr[0].split("@");  /// ��λ
		var tempArr=[];
		for (var i=0; i<ExaReqPartArr.length; i++){
			var PartID = ExaReqPartArr[i].split("^")[0];   /// ��λID
			var PartDesc = ExaReqPartArr[i].split("^")[1]; /// ��λ����
		
			var node = $('#CheckPart').tree('find', PartID); /// ��ȡ�ڵ����
			$('#CheckPart').tree('check', node.target);      /// ѡ�нڵ�

			tempArr.push("{\"ItemID\":\""+PartID+"\",\"ItemPart\":\""+PartDesc+"\",\"ItemOpt\":\""+""+"\"}");
		}
		var jsdata = '{"total":'+ExaReqPartArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#dmPartList').datagrid("loadData",data);       /// �����ݰ󶨵�DataGrid��
	}
	/// ��λ
	if (ExaReqArr[1] != ""){
		var ExaReqPosiArr = ExaReqArr[1].split("^");      /// ��λ
		$("[name='ExaPosi'][value='"+ ExaReqPosiArr[0]+"']").attr("checked",true);
	}
	/// ����
	if (ExaReqArr[2] != ""){
		var ExaReqDispArr = ExaReqArr[2].split("@");      /// ����
		for (var j=0; j<ExaReqDispArr.length; j++){
			var DispID = ExaReqDispArr[j].split("^")[0];  /// ��λID
			$("[name='ExaDisp'][value='"+ DispID+"']").attr("checked",true);
		}
	}
}

/// ���Ҽ����Ŀ��
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());
	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+"&PyCode="+PyCode;
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })