/// ��������ά��js 
///sufan 2016��7��14
var flag=0;     ///�޸� 2016/07/26
var rowIndexflag=""; ///�޸� 2016/09/07
/// ҳ���ʼ������
function initPageDefault(){
	
	initSymptomLevTree();    /// ��ʼ����������
	initDataGrid();          /// ҳ��DataGrid��ʼ����
	initBlButton();          /// ҳ�� Button ���¼�
    initCombobox();          /// ҳ��Combobox��ʼ����  
    LoadPageBaseInfo();   ///  ��ʼ�����ػ�������  
}
function initSymptomLevTree(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=CheckClassifyTree';
	
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("itemCat").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var TraItmID = node.id; 		/// ������ID
				$("#itemlist").datagrid("load",{"TraItmID":TraItmID});
	        }
	    }
	};
	new CusTreeUX("itemCat", '', option).Init();
}

///  ��ʼ�����ػ�������
function LoadPageBaseInfo(){
	/// ��ʼ��������
	var url = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=jsonCheckCatByNodeID&id=0';
	$('#itemCat').tree('options').url =url; 
	$('#itemCat').tree('reload');

} 

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'ItemCode',title:'����',width:100},
		{field:'ItemDesc',title:'ҽ����',width:300},
		{field:'ItemID',title:'ItemID',width:100},
		{field:'TraItmID',title:'TraItmID',width:100}
	]];
	
	///  ����datagrid
	var option = {
		//title:'ҽ�����б�',
		rownumbers : false,
		singleSelect : true,
		showPageList : false
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTreeAdd&MethodName=QueryCheckItemList";
	new ListComponent('itemlist', columns, uniturl, option).Init();
	///�޸� 2016/09/07
	$('#itemlist').datagrid({
		onClickRow: function (rowIndex, rowData) {//����ѡ���б༭
            rowIndexflag=rowIndex;
        }
    });
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///	 ����
	$('a:contains("����")').bind("click",showTraWin);
		
	///  ɾ��
	$('#subtoolbar a:contains("ɾ��")').bind("click",deleteRow);
	 ///  ����
    $('#subtoolbar a:contains("����")').bind("click",moveUp);
    
    ///  ����
    $('#subtoolbar a:contains("����")').bind("click",moveDown);	
    
	///  ����
    $('a:contains("����")').bind("click",UpdateTraWin);
    
    ///  ����
    $('#itmcattoolbar a:contains("����")').bind("click",MoveOrdNumUp);
    
    ///  ����
    $('#itmcattoolbar a:contains("����")').bind("click",MoveOrdNumDown);	
    
	///  ��������
	$('#addWin a:contains("����")').bind("click",saveadd);
	
	///  ȡ������
	$('#addWin a:contains("ȡ��")').bind("click",cancelWinadd);
	
	///  �������
	$('#updateWin a:contains("����")').bind("click",saveupd);
	
	///  ȡ������
	$('#updateWin a:contains("ȡ��")').bind("click",cancelWinupd);
	
	///  ɾ��
	$('#itmcattoolbar a:contains("ɾ��")').bind("click",deleteItmCat);
    
    ///�س��¼�
	$('#itmdesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input = $('#itmdesc').val();
			new UIDivWindow($('#itmdesc'), input, "500px", "" ,setCurrEditRowCellVal).init();
		}
	});
}

///ҽ������Ӧ����
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#itmdesc').focus().select();  ///���ý��� ��ѡ������
		return;
	}
	$('#itmdesc').val(rowObj.itmDesc);  /// ҽ����
	$('#itmmast').val(rowObj.itmID);    /// ҽ����ID
	
}

/// ҳ��Combobox��ʼ����
function initCombobox(){

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=";
	/// ҽԺ
	var url = uniturl+"GetHospDs";
	new ListCombobox("HospID",url,'').init();
	$("#HospID").combobox("setValue",LgHospID);
	///�Ӳ�λ
	$('#Part').combotree({			
			url : 'dhcapp.broker.csp?ClassName=web.DHCAPPTreeAdd&MethodName=getTreeCombo',
			state:closed,
			editable:true,
			onSelect:function(node) {
				var t = $("#Part").combotree('tree');
				var node=t.tree("getSelected");
				var parentNode=t.tree('getParent',node.target);
				$("#addDesc").val(parentNode.text);
				}
	
		});
}

///�������ӵĵ�����
function saveadd(){
	var TraID = $("#addCatID").val();
	var ItemCatDesc = $("#addDesc").val();
	if (ItemCatDesc == ""){
		$.messager.alert('��ʾ',"�����಻��Ϊ�գ�") 
		return;
	}
	var ItmmastID = $("#itmmast").val();                    /// ҽ����   
	var PartID = $('#Part').combotree('getValues')          /// �Ӳ�λ
	if((PartID!="")&&(ItmmastID == "")){
		$.messager.alert('��ʾ',"ҽ�����Ϊ�գ�") 
		return
	}
	var StartDate = $("#startDate").datebox("getValue");    /// ��ʼ����
	var EndDate = $("#endDate").datebox("getValue");        /// ��ֹ����
	var LastLevID = $("#LastLevID").val();       /// �ϼ��ڵ�ID
	var TraAlias=$("#addalias").val();     //�������
	var TraLinkID = "";
	///	ListData  ������^������^�ϼ�id^ҽԺid^�ָ���^�ӱ�id^�Ӳ�λid^ҽ����id^��ʼ����^��ֹ����
	var ListData = ItemCatDesc +"^"+ ItemCatDesc +"^"+ LastLevID +"^"+ LgHospID +"^"+TraAlias+"$$"+TraLinkID +"^"+ PartID +"^"+ ItmmastID +"^"+ StartDate+"^"+ EndDate;
	/// ��������
	runClassMethod("web.DHCAPPTreeAdd","Save",{"TraID":TraID, "ListData":ListData},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ","����ɹ�!");
			$('#itmdesc').val("");    /// ҽ����
			$('#itmmast').val("");    /// ҽ����ID
			$("#itemCat").tree('reload');
			$("#itemlist").datagrid('reload');
			
		}
		if(jsonString == "-1"){
		     $.messager.alert("��ʾ","���������Ѵ���!");
		}
		if(jsonString == "-2"){
			$.messager.alert("��ʾ","�Ѵ����Ӳ�λ����������µķ���!");
		}
		if(jsonString == "-4"){
			$.messager.alert("��ʾ","ҽ������ڣ���������Ӳ�λ!");
		}
		if(jsonString == "-5"){
			$.messager.alert("��ʾ","�Ӳ�λΪ�գ��������ҽ����!");
		}
		if(jsonString == "-9"){
			$.messager.alert("��ʾ","ҽ������ظ�����!");
		}
	},'',false);
	     //$('#updateWin').window('close');   // 2016-07-2
	     
}
///�������ʱ������
function saveupd(){
	var ItemCatDesc = $("#updateDesc").val();
	if (ItemCatDesc == ""){
		$.messager.alert('��ʾ',"����������࣡") 
		return;
	}
	var TraID = $("#updateCatID").val();
	var TraAlias=$("#updalias").val();
	var ListData =ItemCatDesc +"^"+ ItemCatDesc+"^"+ ""+"^"+ ""+"^"+ TraAlias ; 
	/// ��������
	runClassMethod("web.DHCAPPTreeAdd","SaveType",{"TraID":TraID, "ListData":ListData},function(jsonString){
		if (jsonString == 0){
		   
			$.messager.alert("��ʾ","����ɹ�!");
			$('#updateWin').window('close');
			$("#itemCat").tree('reload');
			} 
			if(jsonString == "-2"){
			     $.messager.alert("��ʾ","���������Ѵ���!");
			  }

	     },'',false)
}

/// Ĭ�ϻ�ȡ��ǰʱ��
function GetDateStr(dd,AddDayCount) 
{ 
	dd.setDate(dd.getDate()+AddDayCount);// ��ȡAddDayCount�������� 
	var y = dd.getFullYear();
	var m = dd.getMonth()+1;             // ��ȡ��ǰ�·ݵ����� 
	var d = dd.getDate(); 
	return y+"-"+m+"-"+d; 
} 
/// ��ȡ��ǰʱ���ǰһ��
function DefDate() { 
	$('#startDate').datebox('setValue', GetDateStr(new Date(),-1));   //��ǰʱ���ǰһ��
	var tranodes = $("#itemCat").tree('getSelected');       /// �ϼ��ڵ�ID
	var LastLevID = "0";
	if (tranodes != null){
		LastLevID = tranodes.id;
	}
	$("#LastLevID").val(LastLevID);
	
}

/// ���Ӵ���
function showTraWin(){
	
	clearPanel();       /// ������
	setPartLeafNote();  /// ���Ӳ�λҶ�ӽڵ㸳ֵ
	DefDate();
	createNewWin();     /// ��������

	
}

/// �������Ӵ���
function createNewWin(){
	
	if($('#addWin').is(":hidden")){
	   $('#addWin').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	flag="add";
	new WindowUX('����', 'addWin', '400', '350', option).Init();
	
}


//�������´���
function createUpdateWin(){	
	if($('updateWin').is(":hidden")){
	   $('updateWin').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	flag="update";
	new WindowUX('����', 'updateWin', '400', '200', option).Init();


}
///  ���´���
function UpdateTraWin(){
	
	clearPanel();            /// ������
	var ret=setUpdateWin();  /// ���Ӳ�λҶ�ӽڵ㸳ֵ
	if(ret==false){return;}
	//DefDate();             /// 2016-07-26
	createUpdateWin();       /// ��������
}
/// ���´���
function setUpdateWin(){
	
	var tranodes = $("#itemCat").tree('getSelected');      /// ��ѡ�нڵ�
	if (tranodes == null){return false;}
	var leafnodeID = tranodes.id;	                   /// Ҷ�ӽڵ�ID
	if (leafnodeID.indexOf("^") != "-1"){return false;}	
	$("#updateCatID").val(tranodes.id);                    /// ��������ID   2016-07-27
	$("#updateDesc").val(tranodes.text);                   /// 2016-07-26
	runClassMethod("web.DHCAPPTreeAdd","FindAlias",{"TraID":leafnodeID},function(data){
		$('#updalias').val(data);		
	},'',false)
	return true;

}
/// ���Ӳ�λҶ�ӽڵ㸳ֵ
function setPartLeafNote(){

	var tranodes = $("#itemCat").tree('getSelected');    /// ��ѡ�нڵ�
	if (tranodes == null){return;}
	var leafnodeID = tranodes.id;
	$("#addDesc").val(tranodes.text)	                 /// Ҷ�ӽڵ�ID
	var PartID="",TraItmID="";
	if (leafnodeID.indexOf("^") != "-1"){
		TraItmID = leafnodeID.split("^")[0];             ///�ӱ�ID
		PartID = leafnodeID.split("^")[1];
		$("#Part").combotree("setValue",PartID);         /// ��λ
		$("#itemCatSubID").val(TraItmID);			     /// �����ӱ�ID
		var ParentNode=$("#itemCat").tree('getParent',tranodes.target);
		$("#addCatID").val(ParentNode.id);		/// ��������ID
		$("#addDesc").val(ParentNode.text);    		    /// ��������   2016-07-2
		runClassMethod("web.DHCAPPTreeAdd","FindAlias",{"TraID":ParentNode.id},function(data){
		$('#addalias').val(data);		
			},'',false)	}	
}
///  ȡ��   2016/07/26
function cancelWinadd(){  
	if(flag=="add"){
		$('#addWin').window('close');
	}
}
function cancelWinupd(){  
	if(flag=="update"){
		$('#updateWin').window('close');
	}
}

/// ɾ������
function deleteItmCat(){
	var tranodes = $("#itemCat").tree('getSelected');     /// ��ѡ�нڵ�
	if (tranodes == null){return;}
    var leafnodeID = tranodes.id;		                  /// Ҷ�ӽڵ�ID      
	 if ((tranodes != "")){
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
			if (res) {
				runClassMethod("web.DHCAPPTreeAdd","Delete",{"Id":leafnodeID},function(jsonString){
					if(jsonString==0)
					{
						$.messager.alert("��ʾ", "ɾ���ɹ���");
					
	    						$("#itemCat").tree('reload');
								$("#itemlist").datagrid('reload');
						
						}
						if(jsonString==-1)
						{
							$.messager.alert("��ʾ", "�����ӽڵ㣬����ɾ����");
							}
							if(jsonString==-2)
							{
								$.messager.alert("��ʾ", "�����ӷ��࣬����ɾ����");
								}
					
				})
			}
		});
	}else {
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ɾ��ҽ����
function deleteRow(){
	
	var rowsData = $("#itemlist").datagrid('getSelected'); /// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
			/// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTreeAdd","DelTreeLink",{"TraItmID":rowsData.TraItmID},function(jsonString){
					$('#itemlist').datagrid('reload');    /// ���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ������
function clearPanel(){
	
	$("#itemCatID").val("");			     /// ������ID
	$("#itemCatDesc").val("");			     /// ������
	$("#addDesc").val("");					 /// 2016-07-26
	$("#updateDesc").val("");	             /// 2016-07-26
	$('#addalias').val("");
	$("#addCatID").val("");
	$("#updateCatID").val("");
	$("#itmmast").val();
	$("#itmdesc").val("");
	$("#Part").combotree("setValue","");     /// ��λ
	$("#itemCatSubID").val("");   			 /// ��λID
	$("#startDate").datebox("setValue","");  /// ��ʼ����
	$("#endDate").datebox("setValue","");    /// ��ֹ���� 
}

///����
function MoveOrdNumUp(){
	MoveOrdNum(-1);
}

///����
function MoveOrdNumDown(){
	MoveOrdNum(1);
}
//�ƶ�����
function MoveOrdNum(move){
	var tranodes = $("#itemCat").tree('getSelected');      // ��ѡ�нڵ�
	var ss= this;
	if (tranodes == null){return}
	var leafnodeID = tranodes.id;
							   // Ҷ�ӽڵ�ID	                   
	runClassMethod("web.DHCAPPTreeAdd","Move",{"Id":leafnodeID, "Flag":move},function(jsonString){},'',false)
	$("#itemCat").tree('reload');	
}
function move(isUp,index) {
		var rows=$('#itemlist').datagrid('getData')
		if((isUp)&&(index==0)){
			return;
		}
		if(!(isUp)&&(index==rows.length)){
			return;
		}
		var nextId;
		if(isUp){
			nextId=rows.rows[index-1].TraItmID
		}else{
			nextId=rows.rows[index+1].TraItmID
		}
		var $view = $('div.datagrid-view');
		var $row = $view.find('tr[datagrid-row-index=' + index + ']');		
	    if (isUp) {
	            $row.each(function(){
	                    var prev = $(this).prev();
	                    prev.length && $(this).insertBefore(prev);
	    });
	    } else {
	            $row.each(function(){
	                    var next = $(this).next();
	                   next.length && $(this).insertAfter(next);
	            });
	    }
        runClassMethod(
	 				"web.DHCAPPTreeAdd",
	 				"MoveItmmast",
	 				{'Id':rows.rows[index].TraItmID,isUp:isUp,nextId:nextId},
	 				function(data){
   						$("#itemlist").datagrid('reload')
	 	            })

}
function moveUp(){move(true,rowIndexflag)}
function moveDown(){move(false,rowIndexflag)}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
