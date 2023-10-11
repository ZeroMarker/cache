/**
	xiaowenwu 
	2020-01-15
	ҩƷ�������ʾ��Ϣ
*/
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var parref = "";
var hospID = "";
var queryType = "drugType";		//sufan 2022-04-28 �����ֵ�������Բ�ѯ���ݣ�Ĭ������
$(function(){ 

	initPage();			// ��ʼ������
	initCombobox();		// ��ʼ��combobox
	initdicTable();		// ��ʼ��ҩƷͨ�����б�
	initTree();			
	initButton();		//ҩƷͨ������ѯ
		
})

function initPage(){
			
	if (LgHospDesc.indexOf("������׼") == 0){		// �Ǳ�׼�ⲻ��ʾ��ť
		$("#copy").show();
		$("#copyProp").show();
		$("#export").show();
	}
}

/// ��ʼ��combobox
function initCombobox(){
		
		
	/**ȡҩƷ����**/
  	$HUI.combobox("#dicAttr",{
	    url:'',
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(option){
			
		}
	})
	
	/// ��ʼ�����������
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        parref = option.value;
	        queryType  = "drugType";
	       	QueryDicList();
	       	var params = parref +"^"+ "LinkProp"; 		//sufan ��������2021-12-17
	        var uniturl = $URL+"?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugAttr&params="+params ;
			$("#dicAttr").combobox('reload',uniturl);  
	    },
		loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "��ҩ" && data[i].text != "�г�ҩ" && data[i].text != "��ҩ��Ƭ"){
                        data.splice(i,1);
                        //����splice������data�е�ĳ����ŵ�ֵɾ���ˣ�������������˳���������ǰ�������-1,�ᵼ�²�������δ����ɸѡ
                        i--;
                    }
                }
                return data;
        },
       onLoadSuccess: function (data) {
	        var data = $("#dicType").combobox("getData");	// Ĭ��ѡ���һ��
	        if (data && data.length > 0) {
	            $("#dicType").combobox("setValue", data[0].value);
	            parref = data[0].value;	
	            //QueryDicList(); 
	            var params = parref +"^"+ "LinkProp"; 		//sufan ��������2021-12-17
	            var uniturl = $URL+"?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugAttr&params="+params ;
				$("#dicAttr").combobox('reload',uniturl);          
	        }
        }
	}; 	
	var url = $URL +"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	//var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
  	$HUI.combobox("#hospId",{
	    url:uniturl,
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(option){
			hospID = option.value;
		}
	})	  
	$HUI.combobox("#exportHospId",{
	    url:uniturl,
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(option){
			$("#selectdrug").html("");
		}
	})	
	/// ��ʼ���ֵ�����
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       ("#selectdrug").html(""); 	           
	    },
	   	loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "��ҩ�ֵ�" && data[i].text != "�г�ҩ�ֵ�" && data[i].text != "��ҩ��Ƭ�ֵ�"&& data[i].text != "ȫ�ֹ����ֵ�" && data[i].text != "ͨ�����ֵ�" ){
                        data.splice(i,1);
                        //����splice������data�е�ĳ����ŵ�ֵɾ���ˣ�������������˳���������ǰ�������-1,�ᵼ�²�������δ����ɸѡ
                        i--;
                    }
                }
                return data;
	   	}
	}; 
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue=DictionFlag";
	new ListCombobox("exDicType",url,'',option).init(); 
	
	
	/// ��ʼ���ֵ�����
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        queryType  = "dictionType";  
	        parref = option.value;	        
	    },
	   	loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "��ҩ�ֵ�" && data[i].text != "�г�ҩ�ֵ�" && data[i].text != "��ҩ��Ƭ�ֵ�"&& data[i].text != "����Ӧ���ֵ�"&&data[i].text != "ͨ�����ֵ�" &&data[i].text != "ȫ�ֹ����ֵ�"){
                        data.splice(i,1);
                        //����splice������data�е�ĳ����ŵ�ֵɾ���ˣ�������������˳���������ǰ�������-1,�ᵼ�²�������δ����ɸѡ
                        i--;
                    }
                }
                return data;
	   	},
	   	onLoadSuccess: function (data) {
	       
        }
	}; 
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue=DictionFlag";
	new ListCombobox("dictiontype",url,'',option).init(); 
	
	
}


function initTree(){
	$('#ruleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree',
    	lines:true,
		animate:true,
		checkbox:true,
		onClick:function(node, checked){

	    }, 
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			/*var node = $("#ruleTree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}*/
			$(this).tree('select', node.target);			
			console.log(node) 
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}
	});
}

function initdicTable(){
	$('#dicTable').datagrid({
		toolbar:"#toolbar", //var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
		url:$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+""+"&drugType="+InitDrugType()+"&hospId=",
		//url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
		/* 	{field:'ID',hidden:true},
			{field:'CDParrefDesc',title:'����',width:100,align:'center'},		
			{field:'CDCode',title:'����',align:'center',hidden:true},
			{field:'CDDesc',title:'ҩƷ����',width:350,align:'left'} */
			{field:'dicID',title:'rowid',hidden:true},
			{field:'parref',title:'���ڵ�id',width:100,align:'left',hidden:true},
			{field:'parrefDesc',title:'����',width:100,align:'left'},
			{field:'dicCode',title:'����',width:200,align:'left',hidden:true},
			{field:'dicDesc',title:'����',width:350,align:'left'},
			{field:'idList',title:'idList',width:50,align:'left',hidden:true}
	
		 ]],
		title:"ҩƷ�б�",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		border:false,
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onClickRow: function (rowIndex, rowData) {
			//$('#indicTable').datagrid('load', {dic: rowData.ID});
			//$('#dirTable').datagrid('load', {dic: rowData.ID});
			dataGridDBClick(rowData);
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '��{total}��¼'
	});
		
}	

function dataGridDBClick(rowData){
		
	    $("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree&dic='+rowData.dicID;
		$('#ruleTree').tree('reload');
		
}

function initButton(){
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});

	$("#copy").bind("click",copyRule);	// ���ƹ���
	
	$("#copyProp").bind("click",CopyProp);	// �������� qunianpeng 2020-04-16
	
	$("#find").bind("click",QueryDicList);	// ��ѯ
	
	$("#export").bind("click",ExportWin);	// ����  qnp 2021/07/13
	
	$("#exportReset").bind("click",ExportReset);	// ���� qnp 2021/07/13
}


function QueryDicList(){
	
	var params = $HUI.searchbox("#queryCode").getValue() +"^" +$("#dicAttr").combobox("getValue") + $("#dictiontype").combobox("getValue");
	$('#dicTable').datagrid('load',{
		extraAttr:"DataSource",
		parref:parref,
		params:params,
		hospId:hospID,
		queryType:queryType
		//id:DrugData,
		//parDesc:params	
	}); 
}

/// �رչ���
function CloseRule(){
	
	var ruleArr=[];
	var node = $("#ruleTree").tree('getSelected');
	if (node.ruleId === undefined){		// Ҷ�ӽڵ�
		for (i=0;i<node.children.length;i++){
			var leaf=node.children[i];
			if (leaf.ruleId != undefined){
				ruleArr.push(leaf.ruleId);
			}
		}
		
	}
	else{	// ����ڵ�	
		ruleArr.push(node.ruleId)
	}
	
	var ruleStr=ruleArr.join("^");
	var tableName = "DHC_CKBRuleData";
	var setFlag = "stop";
	var hideFlag = 1;	
	
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'���',
        modal:true,
        width:500,
        height:600,
        content:"<iframe id='diclog' scrolling='auto' frameborder='0' src='dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+ruleStr+"&SetFlag="+setFlag+"&Operator="+LgUserID+"&type=acc"+"&ClientIP="+ClientIPAdd+ "' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                Save(ruleStr);                    
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        },
        onLoad:function(){
	    
	    },
	    onOpen:function(){
	    }
    });
	$('#win').dialog('center');
	
}

/// �洢��Ȩ
function Save(ruleStr){
	
	//var scope=$("#diclog").contents().find("#scope").combobox("getValue");	// ������
	//$("#diclog").contents().find("#dicname").val(); //	 ��ȡԪ��
	//$("#diclog")[0].contentWindow.test;		// ��ȡ����
	//$("#diclog")[0].contentWindow.test();	// ��ȡ����
	var scope=$("#diclog")[0].contentWindow.SAtypeID;	// ������	
	if (scope == "D"){	// ȫԺ
		// ����״̬	
		runClassMethod("web.DHCCKBDrugDetail","CloseRule",{"ruleStr":ruleStr,"userId":LgUserID,"status":"CancelRelease"},function(jsonString){
			if (jsonString!=0 ){
				$.messager.alert('��ʾ','�ر�ʧ��','info');			
			}
		});
	}
	
	$("#diclog")[0].contentWindow.SaveManyDatas();	// ��ҳ����־
}


///	Desc:	���ƹ��� 
/// Author:	qunianpeng 
/// Date:	2020-03-13
function copyRule(){

	var rowsData = $("#dicTable").datagrid('getSelections');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","��ѡ��һ������!","info");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);
	} 
	var dicStr=dataList.join("&&");
	//var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
	
	$.messager.confirm("��ʾ", "��ȷ��Ҫ������Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
		if (res) {
			//��������
			runClassMethod("web.DHCCKBDrugDetail","CopyDrugRule",{"dicStr":dicStr,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
				
				if (jsonString == 0){
					$.messager.alert('��ʾ','���Ƴɹ�','info');
				}else{
					$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+jsonString,'warning');
				}
				QueryDicList();
			});
		}
	});	
}


/// Author: qunianpeng 
/// Time:	2020-04-16
/// Desc:	�������� 
function CopyProp(){
	
	var rowsData = $("#dicTable").datagrid('getSelections');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","��ѡ��һ������!","info");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);
	} 
	var dicStr=dataList.join("&&");
	
	if($('#propWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="propWin"></div>');
	var myWin = $HUI.dialog("#propWin",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'���',
        modal:true,
        width:600,
        height:500,
        content:"<iframe id='copypropFrame' scrolling='auto' frameborder='0' src='dhcckb.copyprop.csp"+"?dicStr="+dicStr+"&parref="+parref+  "' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                SaveCopyProp();  
                myWin.close();                   
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        },
        onLoad:function(){
	    
	    },
	    onOpen:function(){
	    }
    });
	$('#propWin').dialog('center');
	
}

/// Author: qunianpeng 
/// Time:	2020-04-16
/// Desc:	�洢���ƵĹ��� 
/// 
function SaveCopyProp(){
	
	$.messager.confirm("��ʾ", "��ȷ��Ҫ������Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
		if (res) {
			var ret=$("#copypropFrame")[0].contentWindow.CopyPropValue();	// ��ҳ�汣�淽��	
			if (ret == 0){
				$.messager.alert('��ʾ','���Ƴɹ�','info');
			}else{
				$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+ret,'warning');
			}
		}
	});	
	
}

function reloadDatagrid(){

}

/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}

/// Author: qunianpeng 
/// Time:	2021-07-13
/// Desc:	���򵼳�
function ExportWin(){
	
	CleanExportMsg();
	/* ѡ���ҩƷ */	
	var rowsData = $("#dicTable").datagrid('getSelections');
	/* if(rowsData.length<=0){
		$.messager.alert("��ʾ","��ѡ��һ������!","info");
		return;
	} */	
	var dataList = [],dataNameList =[];
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);
		dataNameList.push(rowsData[i].dicDesc);
	} 
	var dicStr=dataList.join("^");
	$HUI.dialog("#exportWin").open();
	
	var subhtmls =""
	var $tdstyle  = 'padding:10px;';	
	
	if (dataNameList.length>0){	
		var tipHtml = "<p style='font-weight:bold'>���Ѿ�ѡ������ҩƷ,���������ť,��������,Ҳ��������ѡ������,�������ݡ�</p>"	
		var tablehtml = "<table>"
		var trhtml = ""
		for (var i=0; i<dataNameList.length; i++){	
			trhtml = trhtml +"<tr>" +'<td style='+$tdstyle+'><span>'+dataNameList[i]+'</span> </td>' + "</tr>";	
			/*if((i+1)%2 == 1){  
				subhtmls = subhtmls + '<tr>';
			}
			subhtmls = subhtmls + '<td><span style="'+spanleft+'">'+dataNameList[i]+'</span> </td>';						    
			if((i+1)%2 == 0){
			   	subhtmls = subhtmls + '</tr>';
			}*/				
		}
		tablehtml = tablehtml +trhtml + "</table>";
		$("#selectdrug").html(tipHtml+tablehtml)
	}
	
}

/// ���ò�ѯ����
function ExportReset(){

	$HUI.combobox("#exDicType").setValue("");
	$HUI.combobox("#exportHospId").setValue("");
	$HUI.datebox("#exStDate").setValue("");
	$HUI.datebox("#exendDate").setValue("");
	
}

/// ��������
function Export(extype){
	CleanExportMsg();
	var stDate = $HUI.datebox("#exStDate").getValue();
	var endDate = $HUI.datebox("#exEndDate").getValue();
	var hospDesc = $HUI.combobox("#exportHospId").getText();
	var dicType = $HUI.combobox("#exDicType").getValue();

	/* ѡ���ҩƷ */	
	var rowsData = $("#dicTable").datagrid('getSelections');
	var dataList = []
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);	
	} 
	var dicStr=dataList.join("^");
	if ((dicStr=="")&&(hospDesc=="")&&(dicType=="")&&(stDate=="")){
		$.messager.alert('��ʾ','������ѡ��һ��ҩƷ,����ѡ��һ������������','info');
		retrun;	
	}
		
	if ((extype == "all")||(extype == "know")){
		if ((dicStr=="")&&(hospDesc=="")&&(dicType=="")&&(stDate!="")){
			$.messager.alert('��ʾ','֪ʶ���ݵ�����֧�ֵ�һʱ������,��ѡ�����������','info');
			retrun;
		}
	}
	
	//ѡ��Ĺ������
	var idList = []
	var selItems = $("#ruleTree").tree('getChecked');
	for(var i=0;i<selItems.length;i++){
		var id = selItems[i].ruleId;
		idList.push(id);
	}
	var nodeList = idList.join("^");
	runClassMethod("web.DHCCKBUpdateManage","Export",{"stDate":stDate, "endDate":endDate, "userId":LgUserID, "hosp":hospDesc, "extype":extype, "drugStr":dicStr, "dataId":dicType,"nodeList":nodeList},function(data){
		$("#exportPath").html("<p style='font-weight:bold'>"+data+"</p>");		
	},"text",false);
	

}

function onChangeDate(){
	$("#selectdrug").html("");
}

function CleanExportMsg(){
	$("#exportPath").html("");
	$("#selectdrug").html("");

}