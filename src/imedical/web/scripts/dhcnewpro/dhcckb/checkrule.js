/**
	qunianpeng
	2020-09-15
	����˶�
*/
var	input ="";
var	hospID = "";
var catID = "";
var selectDicID = "";
var dicType = "";
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var DrugLibID="";

$(function(){ 

	initPage();						// ��ʼ������
	initButton();					// ��ʼ����ť�¼�	
	initCommbobox();				// ��ʼ��combobox
	initdicTable();					// ��ʼ��ҩƷ�б�
	initTree();						// ��ʼ��tree 

	
})

/// ��ʼ������
function initPage(){	
		
	}

// ��ʼ����ť�¼�	
function initButton(){
	
	if (LgHospDesc.indexOf("������׼")==-1){
		$('#editMsg').hide();
	}
	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		queryDicList();
	    }	   
	});

	$("#search").bind("click",queryDicList);	// ҩƷ��ѯ
	
	$("#reset").bind("click",refreshData);		// ҩƷ��ѯ��������
	
	$("#searchrule").bind("click",serachRule);	// �����ѯ
	
	$("#editrule").bind("click",editRule);		// �����޸�
	
	$('input[name="level"]').checkbox({onCheckChange:function(){
		 queryRule(selectDicID,"");
	}})
	
	$('input[name="queryLevel"]').checkbox({onCheckChange:function(){
		 //queryRule(selectDicID,"");
	}})
	
	$("#editLevel").bind("click",editLevel);	// ���򼶱��޸�
	
	$("#editMsg").bind("click",editMsg);	// ������Ϣ�޸�
}

/// ��ʼ��combobox
function initCommbobox(){
	
	// Ժ��
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
  
 	var options={
	 	//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
	 	multiple:true,
	 	cascadeCheck:false
	 };
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+catData;
	$('#cattree').combotree(options);
	$('#cattree').combotree('reload') 
		
	/// ��ʼ���ֵ�����
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicType = option.value;	  
	       //queryDicList();    
	    },
	   	loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "��ҩ�ֵ�" && data[i].text != "�г�ҩ�ֵ�" && data[i].text != "��ҩ��Ƭ�ֵ�"){
                        data.splice(i,1);
                        //����splice������data�е�ĳ����ŵ�ֵɾ���ˣ�������������˳���������ǰ�������-1,�ᵼ�²�������δ����ɸѡ
                        i--;
                    }
                }
                return data;
	   	},
	   	onLoadSuccess: function (data) {
           if (data != 0) {
                var data1 = $('#dicType').combobox('getData'); //��Ĭ��ֵ
               if (data1.length > 0) {
                   $("#dicType").combobox('select', data1[0].value);
               }
           } 
       },
	}; 
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 


	// Ŀ¼
  	var uniturl = $URL+"?ClassName=web.DHCCKBCheckRule&MethodName=QueryDrugLibList"  
  	$HUI.combobox("#ruleList",{
	    url:uniturl,
	    valueField:'value',
			textField:'text',
			panelHeight:"150",
			mode:'remote',
			onSelect:function(option){
				DrugLibID = option.value;
			}
	})	
	
	// ������
  	var uniturl = $URL+"?ClassName=web.DHCCKBCheckRule&MethodName=GetLevelFlagData"  
  	$HUI.combobox("#initlevel",{
	    url:uniturl,
	    valueField:'id',
		textField:'text',	
		mode:'remote',		
	})	
}
	
	
/// ��ʼ��ҩƷ�б�
function initdicTable(){	

	$('#dicTable').datagrid({ 
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCCKBCheckRule&MethodName=QueryDrugList&hospID="+hospID+"&catID="+catID+"&input="+input,
		columns:[[ 
			{field:'hisId',title:'hisId',hidden:true},
			{field:'hisCode',title:'his����',align:'left',hidden:false},
			{field:'hisDesc',title:'hisҩƷ����',width:350,align:'left'},		
			{field:'libId',title:'֪ʶ��id',width:50,hidden:true},	
			{field:'libCode',title:'֪ʶ��ҩƷ����',width:350,align:'left'},	
			{field:'libDesc',title:'֪ʶ��ҩƷ����',width:350,align:'left'}				
		 ]],
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		border:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onClickRow: function (rowIndex, rowData) {
			selectDicID = rowData.libId;
			//cancelCheckBoxSelect();
			queryRule(rowData.libId,"");
	},
	onLoadSuccess:function(data){},
	displayMsg: '��{total}��¼'
	});
	  	
}	

// ��ʼ��tree
function initTree(){	

	$('#ruleTree').tree({
		url:LINK_CSP+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree',
		lines:true,
		animate:true,
		//checkbox:true,
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
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
						left: e.pageX,
						top: e.pageY
			});
		}
	});
}

/// ��񵥻��¼�
function queryRule(dicID,levels){
	
	 var levelArr=[]; 	
	 $('input:checkbox[name=level]:checked').each(function (i) {
		 	levelArr.push($(this).attr("label"));	//$(this).val();   			 	   
	 });
  	 var levels=levelArr.join("!"); 	
	 //levels = "��ʾ"; // 2021/3/24 ��ʱֻ�龯ʾ������
	 
	  var queryRuleCode = $HUI.searchbox("#queryRuleCode").getValue();
	  var catID = $("#ruleList").combobox("getValue");
	  
	 $("#ruleTree").tree("options").url=encodeURI($URL+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree&dic='+dicID+"&levels="+levels+"&useFlag="+"check"+"&input="+queryRuleCode+"&catID="+catID);
		$('#ruleTree').tree('reload');
		
}

/// ��ѯ
function queryDicList(){
	
	if(hospID ==""){
		$.messager.alert("��ʾ","��ѡ��һ��Ժ��!","info");
		return;
	}
	input = $HUI.searchbox("#queryCode").getValue();
	var catArr = $("#cattree").combotree("getValues");
	catID = catArr.join(",");
	var levelArr=[]; 		
	$('input:checkbox[name=queryLevel]:checked').each(function (i) {
		 	levelArr.push($(this).attr("label"));	//$(this).val();   			 	   
	});  	
  	var levels=levelArr.join("!"); 
  	
  	
  	var queryRuleCode = $HUI.searchbox("#queryRuleCode").getValue();
	
	var rulePar = $("#ruleList").combobox("getValue");
  	  	
	$('#dicTable').datagrid('load',{
		hospID:hospID,
		catID:catID,
		input:input,
		levels:levels,
		dicType:dicType,
		searchRuleCode:queryRuleCode,
		rulePar:rulePar
	}); 
}

/// �������
function refreshData(){
	
		$HUI.searchbox('#queryCode').setValue("");
		$HUI.combobox("#hospId").setValue("");
		//$HUI.combobox("#dicType").setValue("");
		$HUI.combobox("#ruleList").setValue("");
		$HUI.searchbox('#queryRuleCode').setValue("");	
		$HUI.combotree("#cattree").setValue("");	
		//$HUI.combobox("#ruleUse").setValue("");
		input ="";
		hospID = "";
		catID = "";
		selectDicID = "";
		dicType="";
		cancelCheckBoxSelect();
		$('#dicTable').datagrid('loadData',{total:0,rows:[]});
		$("#ruleTree").tree("options").url=""
		$('#ruleTree').tree('reload');
		$HUI.combobox("#dicType").reload();
		
		
	}
	
	/// �����ѯ
function serachRule(){
	var levelArr=[]; 
	
	 $('input:checkbox[name=level]:checked').each(function (i) {
		 	levelArr.push($(this).attr("label"));	//$(this).val();   			 	   
	 });
  	
  	var levels=levelArr.join("!");  	
  	queryRule(selectDicID,levels);  		
}
	
	/// ȡ��checkboxѡ��״̬
function cancelCheckBoxSelect(){			
	$('input:checkbox[name=queryLevel]:checked').each(function () {
		$HUI.checkbox($(this)).setValue(false); 			 	   
	})
}

/// �޸Ĺ���
function editRule(){

	var ruleArr=[];
	var node = $("#ruleTree").tree('getSelected');
	if ((node == nulll)||(node.ruleId === undefined)){		// Ҷ�ӽڵ�
		/*for (i=0;i<node.children.length;i++){
					var leaf=node.children[i];
					if (leaf.ruleId != undefined){
								ruleArr.push(leaf.ruleId);
					}
		}*/		
		$.messager.alert('��ʾ','��ѡ��һ������','info');	
		return;
	}
	else{	// ����ڵ�	
		ruleArr.push(node.ruleId)
	}
	var ruleStr=ruleArr.join("^");

	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	var edithtml = '<div id="editPanelDiv" class="edittextbox" style="height: 300px;"><textarea id="editPanel" class="textbox" style="width:460px;height:290px;margin:10px 10px 10px; 10px;"></textarea></div>';
	$('body').append('<div id="win">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#win",{
         iconCls:'icon-w-save',
        //resizable:true,
        title:'���',
        modal:true,
        width:500,
        height:400,
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                saveRule(ruleStr);  
                $HUI.dialog("#win").close();                  
            }
        },{
            text:'�ر�',
            handler:function(){  
            	cleanEidtPanel();                            
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
 	$("#editPanel").val(initRuleEditContent(ruleStr));
	$('#win').dialog('center');
	
}

/// �������
function saveRule(ruleID){
	
		var editText = $("#editPanel").val();
		runClassMethod("web.DHCCKBCheckRule","SaveRuleTemp",{"ruleID":ruleID,"input":editText,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
					if (jsonString == 1){
						$.messager.alert('��ʾ','����ɹ�','info');
					}else{
						$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+jsonString,'warning');
					}		
					cleanEidtPanel();
		},"","");			
}
	
/// ���ع����޸ĵ�����
function initRuleEditContent(ruleID){
	
		var text = "";
		runClassMethod("web.DHCCKBCheckRule","GetTextByRule",{"ruleID":ruleID},function(jsonString){
					text = jsonString;
		},"","");			

	return text;
}
	
/// ��ʼ��
function cleanEidtPanel(){
		$("#editPanel").val("");		
}

/// �޸ļ���
function editLevel(){

	var nodes = $("#ruleTree").tree('getSelected');
	
	if (nodes==null){		// Ҷ�ӽڵ�				
		$.messager.alert('��ʾ','��ѡ��һ������','info');	
		return;
	}
	/* var rule = [];
	for (i =0; i<nodes.length;i++){
		var node = nodes[i];
		if ((node.ruleId != undefined)&(node.ruleId != null)){
			rule.push(node.ruleId);
		} 		
	}*/	
	var title = "�޸ļ���";
	$("#levelDiv").show(); 
	var myWin = $HUI.dialog("#levelDiv",{
        iconCls:'icon-w-save',
        //resizable:true,
        title:title,
        modal:true,
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                SaveRuleLevel();             
                $HUI.dialog("#levelDiv").close();                  
            }
        },{
            text:'�ر�',
            handler:function(){  
            	//cleanEidtPanel();                            
                myWin.close(); 
            }
        }]
    });
 }

/// ��̬���ع�����
function initLevelHtml(){
	var html = ""
	var manLevel = "����,��ʾ,��ʾ,��ֹ"
	runClassMethod("web.DHCCKBCheckRule","GetLevelFlagData",{},function(jsonString){
		if (jsonString != ""){
			for (i=0; i<jsonString.length; i++){
				var obj = jsonString[i];
				if (manLevel.indexOf(obj.text)==-1){
					continue;
				}
				var temphtml = '<tr><td><input class="hisui-radio" type="radio" name="initlevel" label="' +obj.text+ '" value=' + obj.id+ '></td></tr>'
				html = html + temphtml;
			}
		}
	},"json",false);	
	
	return html;	
}

/// ���漶���޸�
function SaveRuleLevel(){
	
	var nodes = $("#ruleTree").tree('getSelected');	
	
	var rule = [],ruleDataArr=[];
	/* for (i =0; i<nodes.length;i++){
		var node = nodes[i];
		if ((node.ruleId != undefined)&(node.ruleId != null)){
			rule.push(node.ruleId);
		}	
		if ((node.ruleId != undefined)&(node.ruleId != null)){
			ruleDataArr.push(node.warnID);
		}		
	} */
	var rule = (nodes.ruleId);
	var ruleDataID = changeStr(nodes.warnID);
	//var ruleStr = rule.join('&&');	
 	//var checkedRadioObj = $("input[name='initlevel']:checked");
 	//var level = checkedRadioObj.val();
 	var level = $HUI.combobox("#initlevel").getValue(); 	
 	var levelIDStr = ruleDataID+"&"+level;
	runClassMethod("web.DHCCKBCheckRule","UpdateRule",{"rule":rule,"levelIDStr":levelIDStr,"msgIDStr":"","userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('��ʾ','����ɹ�','info');
			queryRule(selectDicID,"")
		}else{
			$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+jsonString,'warning');
		}
				
	},"",false);	
	
}


/// �޸���Ϣ
function editMsg(){

	var ruleArr=[];
	var node = $("#ruleTree").tree('getSelected');
	if ((node == null)||(node.ruleId === undefined)){		// Ҷ�ӽڵ�
		/*for (i=0;i<node.children.length;i++){
					var leaf=node.children[i];
					if (leaf.ruleId != undefined){
								ruleArr.push(leaf.ruleId);
					}
		}*/		
		$.messager.alert('��ʾ','��ѡ��һ������','info');	
		return;
	}
	else{	// ����ڵ�	
		ruleArr.push(node.ruleId)
	}
	var title = "�޸���Ϣ";
	var ruleStr=ruleArr.join("^");
	var ruleText = changeStr(node.content);
	if($('#msgWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	var edithtml = '<div id="msgDiv" class="edittextbox" style="height: 295px;padding:10px 10px 0 10px"><textarea id="editMsgText" class="textbox" style="width:470px;height:290px;resize:none;">'+'</textarea></div>';
	$('body').append('<div id="msgWin">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#msgWin",{
        iconCls:'icon-w-save',
        //resizable:true,
        title:title,
        modal:true,
        width:500,
        buttonAlign : 'center',     
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                saveRuleMsg();  
                //$("#editMsgText").val("");  
                $HUI.dialog("#msgWin").close();                  
            }
        },{
            text:'�ر�',
            handler:function(){  
            	//$("#editMsgText").val("");                              
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
 	$("#editMsgText").val(ruleText);
	$('#msgWin').dialog('center');
}

function saveRuleMsg(){

	
	var nodes = $("#ruleTree").tree('getSelected');	
	
	var rule = [],ruleDataArr=[];
	/* for (i =0; i<nodes.length;i++){
		var node = nodes[i];
		if ((node.ruleId != undefined)&(node.ruleId != null)){
			rule.push(node.ruleId);
		}	
		if ((node.ruleId != undefined)&(node.ruleId != null)){
			ruleDataArr.push(node.warnID);
		}		
	} */
	var rule = (nodes.ruleId);
	var ruleDataID = changeStr(nodes.msgID);
	//var ruleStr = rule.join('&&');	
  	var msg = $("#editMsgText").val();  
 	var msgIDStr = ruleDataID+"&"+msg;
	runClassMethod("web.DHCCKBCheckRule","UpdateRule",{"rule":rule,"levelIDStr":"","msgIDStr":msgIDStr,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('��ʾ','����ɹ�','info');
			queryRule(selectDicID,"")
		}else{
			$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+jsonString,'warning');
		}
				
	},"","");	
	
}


function changeStr(str){
	
	if ((str == "")||(str === undefined)||(str == null)){
		str = "";
	}
	return str;
}

/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
