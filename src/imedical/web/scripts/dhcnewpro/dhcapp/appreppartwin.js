//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2016-07-23
// ����:	   ������벿λѡ�����
//===========================================================================================

var itmmastid = "";  /// ҽ����ID
var TraID = "";      /// ������ID
var InvFlag = 0 ;    /// ���ñ�ʶ: 1-���������ã�0-ҽ��ģ�����
var mListData = "";
var LgHospID = session['LOGON.HOSPID'];   /// ҽԺID
var selOrdBodyPartStr="";  /// ��ѡ�б�
var selOrdBodyPartDescStr="";
/// ҳ���ʼ������
function initPageDefault(){
	
	initParam();     ///  ��ʼ��������Ϣ
	initItemList();  ///  ҳ��DataGrid�������б�
	initBlButton();  ///  ҳ��Button���¼�
	//LoadPartTree(); /// ��λ��
	initItemDisp();  ///  ������
	initHideCol();   ///  �����п���
	initExaPart();   ///  ��λ�б�
	if (InvFlag != 1){
		initSelExaPart(); /// ��ѡ�б�
	}
}
function initSelExaPart(){
	//38B1A29B2*
	//addItmSelList
	var arExaDispID=selOrdBodyPartStr.split("*")[1]; //����ѡ�� ��
	selOrdBodyPartStr=selOrdBodyPartStr.split("*")[0];
	if (selOrdBodyPartStr!=""){
		runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
			for (var i=0;i<selOrdBodyPartStr.split("A").length;i++){
				var id=selOrdBodyPartStr.split("A")[i].split("B")[0];
				var ItemPosiIDStr=selOrdBodyPartStr.split("A")[i].split("B")[1];
				var text=$("#Part_"+id).parent().next().text();
				var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
				$("#dmPartList").datagrid('appendRow',rowobj);
				var rowsData=$("#dmPartList").datagrid('getRows');
				$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
				var ed=$("#dmPartList").datagrid('getEditor',{index:rowsData.length - 1,field:'ItemPosiDesc'});
				if (ItemPosiIDStr!=""){
					var ItemPosiIDArr=new Array();
					var ItemPosiArr=new Array();
					for (var k=0;k<ItemPosiIDStr.split(",").length;k++){
						ItemPosiIDArr.push(ItemPosiIDStr.split(",")[k]);
						for (var m=0;m<jsonString.length;m++){
							if(ItemPosiIDStr.split(",")[k]==jsonString[m].value){
								ItemPosiArr.push(jsonString[m].text);
								break;
							}
						}
					}
					$(ed.target).combobox('setValues',ItemPosiIDArr);
					var ed=$("#dmPartList").datagrid('getEditor',{index:rowsData.length - 1,field:'ItemPosiID'});
					$(ed.target).val(ItemPosiIDStr);
					var ed=$("#dmPartList").datagrid('getEditor',{index:rowsData.length - 1,field:'ItemPosi'});
					$(ed.target).val(ItemPosiArr.join(","));
				}
			}
		},'json',false)
		
	}
	if (arExaDispID!=""){
		for (var k=0;k<arExaDispID.split("@").length;k++){
			$("#ExaDisp_"+arExaDispID.split("@")[k]).prop('checked', true);
		}
	}
}
/// ��ʼ�����ز��˾���ID
function initParam(){
	
	itmmastid = getParam("itmmastid");   /// ҽ����ID 
	TraID = getParam("arExaCatID"); /// ������ID 
	InvFlag = getParam("InvFlag");  /// ���ñ�ʶ 
	selOrdBodyPartStr = getParam("selOrdBodyPartStr");  /// ��ѡ�б�
	selOrdBodyPartDescStr = getParam("selOrdBodyPartDescStr");  /// ��ѡ�б�����
}

/// ҳ�� Button ���¼�
function initBlButton(){
		
	///  ƴ����
	$("#PartCode").bind("keyup",findPartTree);
	
	/// ��λѡ��
	$("#ItmExaPart").on("click","[id^=Part]",selectItem);
}

/// ���Ҽ�鲿λ��
function findPartTree(){
	
	var PyCode=$.trim($("#PartCode").val());
	
	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+'&PyCode='+ PyCode +'&TraID=&HospID='+LgHospID;

	$('#EnPart').tree('options').url =encodeURI(url);
	$('#EnPart').tree('reload');
}

/// ��ʼ����鲿λ��
function LoadPartTree(){

	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+'&PyCode=&TraID=&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#EnPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        if (checked){
					addItmSelList(node.id, node.text);
		        }else{
			    	delItmSelList(node.id);
			    }
	        }   
	    },
	    onLoadSuccess:function(node, data){
	    	//$("span:contains('��ѡ��λ')").parent().find("span.tree-checkbox").remove();
			$("ul#EnPart>li>div").find("span.tree-checkbox").remove();
	    },
	    onClick:function(node){
			if (node.checked){
				$("#EnPart").tree('uncheck',node.target);
			}else{
				$("#EnPart").tree('check',node.target);
			}
		}
	};
	new CusTreeUX("EnPart", url, option).Init();
}


/// ҳ��DataGrid��ʼ����������б�
function initItemList(){
	
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	// ��λ�༭��
	var PosiEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "", //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+itmmastid+"&HospID="+LgHospID,
			valueField: "value", 
			textField: "text",
			multiple:true,
			editable:false,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var PosiED=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var tempPosiID = $(PosiED.target).combobox('getValues');
				var tempPosi = $(PosiED.target).combobox('getText');
				/// �ݴ���λID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiID'});
				$(ed.target).val(tempPosiID);
				/// �ݴ���λ
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosi'});
				$(ed.target).val(tempPosi);
				/// ��ѡ��ĿΪ1��ʱ,ѡ�к�ֱ�ӹر�
				var rowData = $(PosiED.target).combobox('getData');
				if (rowData.length == 1){
					$(PosiED.target).combobox('hidePanel');
				}
			},
			onShowPanel:function(){
				
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemID'});
				var PartID=$(ed.target).val();  /// ��λID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+itmmastid+"&HospID="+LgHospID+"&PartID="+PartID;
				$(ed.target).combobox('reload',unitUrl);
			},
			onUnselect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var tempPosiID = $(ed.target).combobox('getValues');
				var tempPosi = $(ed.target).combobox('getText');
				/// �ݴ���λID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiID'});
				$(ed.target).val(tempPosiID);
				/// �ݴ���λ
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosi'});
				$(ed.target).val(tempPosi);
			}
		}

	}
	
	///  ����columns
	var columns=[[
		{field:'ItemID',title:'ItemID',width:100,hidden:true,editor:texteditor},
		{field:'ItemPart',title:'��λ',width:200},
		{field:'ItemPosiID',title:'ItemPosiID',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosi',title:'ItemPosi',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosiDesc',title:'��λ',width:160,editor:PosiEditor},
		{field:'ItemRemark',title:'��ע',width:200,editor:texteditor},
		{field:'ItemOpt',title:'����',width:100,align:'center',formatter:SetCellDelUrl}
	]];
	
	///  ����datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != -1||editRow == 0) { 
                //$("#dmPartList").datagrid('endEdit', editRow); 
            }
            //$("#dmPartList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// ����
function SetCellDelUrl(value, rowData, rowIndex){
	var html = "<a href='#' onclick='delItmRow("+rowData.ItemID+")'>ɾ��</a>";
    return html;
}

/// ɾ����
function delItmRow(PartID){
	
	/// ȡ��ѡ�нڵ�
	//var node = $("#EnPart").tree('find',PartID);
	//$("#EnPart").tree('uncheck',node.target);
	
	/// ȡ�������Ŀ��ѡ��
	if ($("#Part_"+PartID).is(":checked")){
		$("#Part_"+PartID).attr("checked",false);
	}
	
	/// ɾ��ѡ����
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// ɾ����
			$("#dmPartList").datagrid('deleteRow',rowIndex);
			return false;			
		}
	})
}

/// ѡ���¼�
function selectItem(){
	
	if ($(this).is(':checked')){
		
		/// ��λ
		var PartID = this.value;    /// ��λID
		var PartDesc = $(this).parent().next().text(); /// ��λ����
		addItmSelList(PartID, PartDesc);
	}else{
		
		var PartID = this.value;    /// ��λID
		delItmSelList(PartID);
	}
}

/// ������Ŀ�б�
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
	
	/// �����б༭     /// 2016-12-14 bianshuai �������б༭
	var rowsData=$("#dmPartList").datagrid('getRows');
	$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
}

/// ɾ���б�����
function delItmSelList(PartID){
	
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// ɾ����
			$("#dmPartList").datagrid('deleteRow',rowIndex);			
		}
	})
	/*
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemID == id){
			delItmRow(index);  /// ɾ����Ӧ��
			return false;
		}
	})
	*/
}

/// ������
function initItemDisp(){
	
	$("#ItmExaDisp").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				var html = '';
					html = html + '<tr style="height:30px">';
					html = html + '<td style="width:20px"><input id="ExaDisp_'+jsonObjArr[i].value+'" name="ExaDisp" type="checkbox" value="'+ jsonObjArr[i].value +'"></input></td>';
					html = html + '<td>'+ jsonObjArr[i].text +'</td>';
					html = html + '</tr>';
				$("#ItmExaDisp").append(html);
			}
			/// ��������Ϊ�գ�չ�����
			//$('#PopPanel').layout('expand','east');
			$('#PopPanel').layout('show','east'); 
		}else{
			/// ��������Ϊ�գ��۵����
			//$('#PopPanel').layout('collapse','east');
			$('#PopPanel').layout('hidden','east'); 
		}
	},'json',false)
}

/// �����п���
function initHideCol(){
	
	runClassMethod("web.DHCAPPExaReportQuery","isExistPos",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonPosi){
		if (jsonPosi == ""){
			/// �����Ŀ�޶�Ӧ��λʱ��������λ��
			$("#dmPartList").datagrid('hideColumn','ItemPosiDesc');
		}
	},'json',false)
	
	if (InvFlag != 1){
		/// ҽ��վ����ʱ�����ر�ע��
		$("#dmPartList").datagrid('hideColumn','ItemRemark');
	}
}

/// ȷ��
function sure(){
	
	/// ���ڵ��ñ�ʶ
	if (InvFlag == 1){ 
		InsPart();     /// ����������
	}else{
		InsPartDoc();  /// ҽ��ģ�����
	}
}

/// ����������
function InsPart(resItemPart){
	
	/// ��鸽����Ϣ
	var rows=$("#dmPartList").datagrid('getRows');
	if (rows.length == 0){
		$.messager.alert("��ʾ:","����ѡ��λ��");
		return;
	}
	
	for(var index=0; index < rows.length; index++){
		
		/// �����༭
		$("#dmPartList").datagrid('endEdit', index); 
	}
	
	/// ������
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().next().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("��");
	
	window.parent.frames.InsItemSelList(rows, arExaDispID, arExaDispDesc);
}

/// ҽ��ģ�����
function InsPartDoc(){
	
	/// ��鸽����Ϣ
	var rows=$("#dmPartList").datagrid('getRows');
	if (rows.length == 0){
		$.messager.alert("��ʾ:","����ѡ��λ��");
		return;
	}
	
	var itmLabelID = "";     /// ��ĿID��
	var itmLabel = "";       /// ��Ŀ����
	/// ������
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().next().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("��");

	/// ����	
	if (arExaDispDesc != ""){
		itmLabel = $.trim(arExaDispDesc);
	}
	
	var itmArr = [];         /// ��ĿID��
	var itmPartArr = [];     /// ��λ����
	$.each(rows, function(index, rowData){
		
		/// �����༭
		$("#dmPartList").datagrid('endEdit', index); 
		
		var arExaPartID = rowData.ItemID;         /// ��λID
		var arExaPartDesc = rowData.ItemPart;     /// ��λ
		var arExaPosiID = rowData.ItemPosiID;     /// ��λID
		var arExaPosiDesc = rowData.ItemPosi;     /// ��λ
		
		/// ��λ (��λ)
		if (arExaPosiDesc != ""){
			arExaPartDesc = arExaPartDesc +"("+ arExaPosiDesc +")";
		}
		itmPartArr.push(arExaPartDesc);
		itmArr.push(arExaPartID +"B"+ arExaPosiID);
	})
	
	if (itmPartArr.join("��") != ""){
		itmLabel = itmLabel + "[" + itmPartArr.join("��") + "]";
	}
	itmLabelID = itmArr.join("A");
	
	/// ��������
	var mListData = itmLabel +"^"+ itmLabelID +"^"+ arExaDispID;

	$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// ���datagrid
	window.returnValue=mListData;
	window.close();
}

/// �رմ���
function cancel(){
	
	if (InvFlag == 1){
		window.parent.frames.closeWin();
	}else{
		window.close();
	}
}

/// ���Ҽ����Ŀ��
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());
	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+"&PyCode="+PyCode;
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}


/// ��鲿λ�б�
function initExaPart(){
	
	/// ��ʼ����鷽������
	$("#ItmExaPart").html('<tr style="height:0px;" ><td style="width:80px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonGetPartTreeByArc",{"itmmastid": itmmastid, "PyCode":"", "TraID":TraID, "HospID": LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsPartRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ��鲿λ����
function InsPartRegion(itemobj){	
	/// ������
	var htmlstr = '';
		// htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var column = 5;  /// ����
	var itemArr = itemobj.children;
	var itemhtmlArr = []; itemhtmlstr = "";
	var merRow = Math.ceil(itemArr.length / column);  /// ����
	for (var j=1; j<=itemArr.length; j++){
		
		if (j == 1){
			itemhtmlArr.push('<td rowspan="'+ merRow +'" align="center">'+ itemobj.text +'</td>');
		}
		itemhtmlArr.push('<td><input id="Part_'+ itemArr[j-1].id +'" type="checkbox" value="'+ itemArr[j-1].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		
		if (j % column == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % column != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + GetEmptyLabel(column - (itemArr.length % column)) +'</tr>';
		itemhtmlArr = [];
	}

	$("#ItmExaPart").append(htmlstr+itemhtmlstr)
}

/// ��ȡ��tb����
function GetEmptyLabel(number){
	
	var tempHtmlArr = [];
	for (var m=0; m < number; m++){
		tempHtmlArr.push('<td></td><td></td>');
	}
	return tempHtmlArr.join("");
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })