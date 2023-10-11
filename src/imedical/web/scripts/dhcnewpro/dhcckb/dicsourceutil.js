//===========================================================================================
// Author��      qunianpeng
// Date:		 2030-01-02
// Description:	 �°��ٴ�֪ʶ��-�ֵ��������ó���
//===========================================================================================

var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var parref = "";					// �����ֵ�id
var dicParref = ""					// �ֵ��id
var datatype=""
var newparref=""          	        //�޸�Ϊ�ľ����ֵ�id
var newothername=""                 //����ı���
var parrefFlag=0;					// qunianpeng  �������Ƿ���ʾҶ�ӽڵ���
/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitDataList();		// ʵ��DataGrid��ʼ������
	InitSubDataList();  // ����DataGrid��ʼ������
	resizeH();
}

// ����Ӧ
function resizeH(){

	$('#showlist').resizable( {
        height:$(window).height()-125
    }); 
   
   if (datatype=="tree"){
		$("#dictree").resizable({
	   		maxHeight : $(window).height()-125
		});
    }else{
		$("#diclist").datagrid('resize', { 
            height : $(window).height()-125
   		});
	}	
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){
	
	$("#reset").bind("click",InitPageInfo);	// ����	
	
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
		    QueryDicList();
	    }	   
	});	
	$("#resetvalue").bind("click",RestValue);	
	
	$("#find").bind("click",QueryDicList);			// ������ѯ��ť qunianpeng 2020/4/8	
	
	$("#updruledic").bind('click',UpdRuleDic)		// �޸Ĺ������ֵ��Ԫ�ع���
		
}

/// ��ʼ��combobox
function InitCombobox(){

	/// ��ʼ�����������
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        dicParref = option.value;
	        runClassMethod("web.DHCCKBGetDicSourceUtil","GetDicDataType",{"dicID":dicParref},function(jsonString){
				datatype=jsonString;
				$HUI.combotree("#propType").setValue("");
				if (jsonString == "tree"){
					$("#list").hide();
					$("#tree").show();
					InitTree();
					resizeH();
				}
				else{					
					$("#list").show();
					$("#tree").hide();
					QueryDicList();
					resizeH();					
				}
			},'text',false);				
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
	
	//�ֵ� sufan 20200623 ����
	$('#dicDesc').combobox({
		url:url,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		mode:'remote',
		onSelect:function(option){
			
			/*var params = LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
			var parrefId = option.value;
			if (option.text == "ҩѧ�����ֵ�"){
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetTreeCombobox&parref="+parrefId+"&params="+params;
			}else{
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+parrefId +"&parrefFlag="+"0"+"&params="+params;;
			}
			$("#dicData").combobox('reload',url);*/
		}
	})
	
	//�ֵ����� sufan 20200623 ����
	$('#dicData').combobox({
		//url:'',
		valueField: 'id',
		textField: 'text',
		blurValidValue:true,
		mode:'remote',
		onShowPanel:function(){
			
			var params = LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;	
			var parrefId = $HUI.combobox("#dicDesc").getValue(); 
			var parrText = $HUI.combobox("#dicDesc").getText();
			if (parrText == "ҩѧ�����ֵ�"){
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetTreeCombobox&parref="+parrefId+"&params="+params;
			}else{
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+parrefId +"&parrefFlag="+"0"+"&params="+params;;
			}
			$('#dicData').combobox('reload',url);
		}	
	})
	
	/// ������ qunianpeng 2020/4/7
	var attrValue = "AttrFlag" 
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+attrValue;
	var options={
		url:uniturl,
		onSelect:function(option){
			dicParref = option.id;
			parrefFlag =1;
			$HUI.combobox("#dicType").setValue("");
			QueryDicList();		
		}
	};

	$('#propType').combotree(options);
	$('#propType').combotree('reload')
	
	/// ����������
	var options={
		url:uniturl,
		onSelect:function(option){
				
		}
	};
	$('#dicprop').combotree(options);
	$('#dicprop').combotree('reload')
	
	
	///Ժ��
	///����Ժ��sufan 2020-07-15
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#hosp",{
	     url:uniturl,
	     valueField:'value',
			textField:'text',
			panelHeight:"150",
			mode:'remote',
			onSelect:function(ret){
				SubQueryDicList();
			}
	   })
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

/// ʵ��DataGrid��ʼ����ͨ����
function InitDataList(){
	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:400,align:'left',editor:texteditor},
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"��������",width:200,align:'left',hidden:true}

		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 	
 			newothername=rowData.CDDesc;  //����ı���   
 			parref=rowData.ID;  
		   	SubQueryDicList();		 
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+dicParref+"&parrefFlag=0&parDesc=";
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

/// ����DataGrid��ʼ����ͨ����
function InitSubDataList(){
	// ruleID^drugID^drugName^libaryID^libaryDesc^left^leftDesc"
	// ����columns	
	var columns=[[   
			{field:'ck',title:'����',checkbox:'true',width:80,align:'left'},
			{field:'drugName',title:'ҩƷ����',width:280,align:'left'},
			{field:'libaryDesc',title:'��ϵ',width:100,align:'left'},
			{field:'leftDesc',title:'��',width:100,align:'left'},
			{field:'ruleID',title:'���ô�id',width:60,align:'left',hidden:true},
			{field:'ruleMark',title:'���ô�id',width:80,align:'left'},
			{field:'Operating',title:'��������',width:50,align:'center',formatter:SetCellOperation},  //xww 2021-08-06
			{field:'marks',title:'marks',width:80,align:'left',hidden:true}
	 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){    
 		
		}, 		
		onLoadSuccess:function(data){         
        }		  
	}
	var params = "";
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;
	new ListComponent('linkattrlist', columns, uniturl, option).Init();			
}

function InitTree(){
		
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+dicParref+"&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID
	var option = {
		height:$(window).height()-105,   ///��Ҫ���ø߶ȣ���Ȼ����չ��̫��ʱ����ͷ�͹�����ȥ�ˡ�
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){	       
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        parref=node.id;  
		   	SubQueryDicList();		
	        if (isLeaf){
		        							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    },
	    onContextMenu: function(e, node){			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}
				
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		
}



/// ʵ��datagrid��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();	
	var referenceFlag=$HUI.checkbox("#referenceFlag").getValue()  //xww 2021-08-23
	if(datatype=="tree"){
		reloadTree();
	}else{
		var options={} // 
		options.url=encodeURI($URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+dicParref+"&parrefFlag="+parrefFlag+"&parDesc="+params+"&loginInfo="+LoginInfo+"&referenceFlag="+referenceFlag);
		$('#diclist').datagrid(options);
	}
}

/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
	InitTree();	
	$HUI.combobox("#dicType").setValue("");
	$HUI.combotree("#propType").setValue("");
	dicParref="";
	$HUI.combobox("#hosp").setValue("");
}

/// ��ѯ������ҳ��
function SubQueryDicList(){

	var params=parref;
	var hospId = $HUI.combobox("#hosp").getValue();		//sufan 2020-12-24 ����ҽԺ���
	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBGetDicSourceUtil&MethodName=QueryDicSource&dicID="+params+"&hospId="+hospId;
	$('#linkattrlist').datagrid(options);
	$('#linkattrlist').datagrid('reload');
}
///�޸�Ϊ��һ��/��������
function RestValue(){
	if(parref=="")
	{
		$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ���!','warning');
		return;
	}
	//��ʼ��dialog�е�combobox
	var option = {
		panelHeight:"250",
		mode:"remote",
		valueField:'id',
		textField:'text',		
        onSelect:function(option){
	        newparref = option.id;
	    }
	}; 
	var params = LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
	 if (datatype == "tree"){
		
			var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetTreeCombobox&parref="+dicParref+"&params="+params;
			}else{
			var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+dicParref +"&parrefFlag="+"0"+"&params="+params;;
			}
	
	new ListCombobox("reactionnamerule",url,'',option).init(); 
	$HUI.dialog("#exaction").open();
	
	}
///dialog�����޸�  ����
function SaveResetData(){
	if(newparref=="")
	{
		$.messager.alert('��ʾ','δѡ���ֵ䣡');
		return;		
	}
		runClassMethod("web.DHCCKBGetDicSourceUtil","SaveResetAction",{"dicID":parref,"dicDataId":newparref,"otherName":newothername},function(jsonString){
					if (jsonString == 1){
						 $.messager.alert('��ʾ','�ֵ����á����������޸ĳɹ���');
						//$('#diclist').datagrid('reload'); //���¼���
					}else if(jsonString == -1){
						 $.messager.alert('��ʾ','���������޸ĳɹ���');
					}else if(jsonString == -2){
						 $.messager.alert('��ʾ','�ֵ������޸ĳɹ���');
					}								
				})
				$HUI.dialog("#exaction").close();
}
///�ƶ������ֵ����
function UpdRuleDic()
{
	var seltems=$('#linkattrlist').datagrid('getSelections')
	if(seltems.length==0){
		$.messager.alert("��ʾ","��ѡ��Ҫ�޸ĵ��б�");
		return;
	}
	
	$("#UpdDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	$HUI.combobox("#dicData").setValue("");	
	$HUI.combotree("#dicprop").setValue("");
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "�޸Ĺ����ֵ�����";		
	new WindowUX(title, 'UpdDicWin', '360', '260', option).Init();
}
///�����������
function saveDiction()
{
	var selitems = $('#linkattrlist').datagrid('getSelections');
	var preDicId = "";
	if(datatype == "tree"){
		var selnode = $('#dictree').tree('getSelected');
		preDicId = selnode.id;
	}else{
		var dicselitems = $('#diclist').datagrid('getSelected');
		preDicId = dicselitems.ID;
	}
	var dicData = $HUI.combobox("#dicData").getValue();
	
	var dicProp = $HUI.combotree("#dicprop").getValue();
	var dicArray = new Array();
	var dataList = [];
	for(var i=0;i<selitems.length;i++){
		var linkId = selitems[i].ruleID;
		var linktp = selitems[i].marks;
		var list = linkId +"^"+ linktp;
		if($.inArray(linktp,dicArray) < 0){
                dicArray.push(linktp);
        }
		dataList.push(list)
	}
	var listData = dataList.join("&");
	console.log(dicArray);
	if(dicArray.length != 1){
		closeDicWin();
		$.messager.alert("��ʾ","��ѡ��ͬһ���͵ļ�¼�޸ģ�");
		return false;
	}
	runClassMethod("web.DHCCKBGetDicSourceUtil","ChangeRuleDic",
		{"listData":listData,"dicId":dicData,"preDicId":preDicId,"dicProp":dicProp},
		function(data){
			if(data==0){
				closeDicWin();
				$('#linkattrlist').datagrid("reload");
				$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
			}else{
				$.messager.alert("��ʾ","�޸�ʧ��,�������:"+data)
				return;
			}				
		}
	)
}
///��ѯ���ķ���  sufan2020-08-03
function reloadTree(){
	var Input=$.trim($HUI.searchbox("#queryCode").getValue());
	if(Input==""){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+dicParref+"&Input=";
	}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+dicParref+"&Input="+Input;
	}
	$('#dictree').tree('options').url = encodeURI(url);	
	$('#dictree').tree('reload');
}

///���ù�����ϸ���� xww 2021-08-06
function SetCellOperation(value, rowData, rowIndex){

	var btn="��"
	if(rowData.ruleMark.indexOf("����")>-1){
		var btn = "<img class='mytooltip' title='��������' onclick=\"OpenEditWin('"+rowData.ruleID+"','linkprop','"+rowData.drugID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' style='border:0px;cursor:pointer'>" 
	}
 	return btn;  

}

/// ���ù�����ϸ���� xww 2021-08-06
function OpenEditWin(ruleID,model,drugID){

	var linkUrl="dhcckb.rule.index0.csp",title=""

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?ruleID='+ruleID+'&drugID='+drugID+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:"����༭��",
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		maximized:true,
		maximizable:true,
		width:800,
		height:500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
///�رմ���
function closeDicWin()
{
	$("#UpdDicWin").window('close')
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

