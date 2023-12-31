/**
	qunianpeng
	2020-09-15
	规则核对
*/
var	input ="";
var	hospID = "";
var catID = "";
var selectDicID = "";
var dicType = "";
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var DrugLibID="";

$(function(){ 

	initPage();						// 初始化界面
	initButton();					// 初始化按钮事件	
	initCommbobox();				// 初始化combobox
	initdicTable();					// 初始化药品列表
	initTree();						// 初始化tree 

	
})

/// 初始化界面
function initPage(){	
		
	}

// 初始化按钮事件	
function initButton(){
	
	if (LgHospDesc.indexOf("东华标准")==-1){
		$('#editMsg').hide();
	}
	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		queryDicList();
	    }	   
	});

	$("#search").bind("click",queryDicList);	// 药品查询
	
	$("#reset").bind("click",refreshData);		// 药品查询条件重置
	
	$("#searchrule").bind("click",serachRule);	// 规则查询
	
	$("#editrule").bind("click",editRule);		// 规则修改
	
	$('input[name="level"]').checkbox({onCheckChange:function(){
		 queryRule(selectDicID,"");
	}})
	
	$('input[name="queryLevel"]').checkbox({onCheckChange:function(){
		 //queryRule(selectDicID,"");
	}})
	
	$("#editLevel").bind("click",editLevel);	// 规则级别修改
	
	$("#editMsg").bind("click",editMsg);	// 规则消息修改
}

/// 初始化combobox
function initCommbobox(){
	
	// 院区
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
	 	//rowStyle:'checkbox', //显示成勾选行形式
	 	multiple:true,
	 	cascadeCheck:false
	 };
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+catData;
	$('#cattree').combotree(options);
	$('#cattree').combotree('reload') 
		
	/// 初始化字典类型
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
                    if(data[i].text != "西药字典" && data[i].text != "中成药字典" && data[i].text != "中药饮片字典"){
                        data.splice(i,1);
                        //由于splice函数将data中的某个序号的值删掉了，因此整体数组的顺序会依次向前，如果不-1,会导致部分数据未经过筛选
                        i--;
                    }
                }
                return data;
	   	},
	   	onLoadSuccess: function (data) {
           if (data != 0) {
                var data1 = $('#dicType').combobox('getData'); //赋默认值
               if (data1.length > 0) {
                   $("#dicType").combobox('select', data1[0].value);
               }
           } 
       },
	}; 
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 


	// 目录
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
	
	// 管理级别
  	var uniturl = $URL+"?ClassName=web.DHCCKBCheckRule&MethodName=GetLevelFlagData"  
  	$HUI.combobox("#initlevel",{
	    url:uniturl,
	    valueField:'id',
		textField:'text',	
		mode:'remote',		
	})	
}
	
	
/// 初始化药品列表
function initdicTable(){	

	$('#dicTable').datagrid({ 
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCCKBCheckRule&MethodName=QueryDrugList&hospID="+hospID+"&catID="+catID+"&input="+input,
		columns:[[ 
			{field:'hisId',title:'hisId',hidden:true},
			{field:'hisCode',title:'his代码',align:'left',hidden:false},
			{field:'hisDesc',title:'his药品名称',width:350,align:'left'},		
			{field:'libId',title:'知识库id',width:50,hidden:true},	
			{field:'libCode',title:'知识库药品代码',width:350,align:'left'},	
			{field:'libDesc',title:'知识库药品名称',width:350,align:'left'}				
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
	displayMsg: '共{total}记录'
	});
	  	
}	

// 初始化tree
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
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}*/
			$(this).tree('select', node.target);			
			// 显示快捷菜单
			$('#right').menu('show', {
						left: e.pageX,
						top: e.pageY
			});
		}
	});
}

/// 表格单击事件
function queryRule(dicID,levels){
	
	 var levelArr=[]; 	
	 $('input:checkbox[name=level]:checked').each(function (i) {
		 	levelArr.push($(this).attr("label"));	//$(this).val();   			 	   
	 });
  	 var levels=levelArr.join("!"); 	
	 //levels = "警示"; // 2021/3/24 暂时只查警示的内容
	 
	  var queryRuleCode = $HUI.searchbox("#queryRuleCode").getValue();
	  var catID = $("#ruleList").combobox("getValue");
	  
	 $("#ruleTree").tree("options").url=encodeURI($URL+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree&dic='+dicID+"&levels="+levels+"&useFlag="+"check"+"&input="+queryRuleCode+"&catID="+catID);
		$('#ruleTree').tree('reload');
		
}

/// 查询
function queryDicList(){
	
	if(hospID ==""){
		$.messager.alert("提示","请选择一个院区!","info");
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

/// 清空数据
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
	
	/// 规则查询
function serachRule(){
	var levelArr=[]; 
	
	 $('input:checkbox[name=level]:checked').each(function (i) {
		 	levelArr.push($(this).attr("label"));	//$(this).val();   			 	   
	 });
  	
  	var levels=levelArr.join("!");  	
  	queryRule(selectDicID,levels);  		
}
	
	/// 取消checkbox选中状态
function cancelCheckBoxSelect(){			
	$('input:checkbox[name=queryLevel]:checked').each(function () {
		$HUI.checkbox($(this)).setValue(false); 			 	   
	})
}

/// 修改规则
function editRule(){

	var ruleArr=[];
	var node = $("#ruleTree").tree('getSelected');
	if ((node == nulll)||(node.ruleId === undefined)){		// 叶子节点
		/*for (i=0;i<node.children.length;i++){
					var leaf=node.children[i];
					if (leaf.ruleId != undefined){
								ruleArr.push(leaf.ruleId);
					}
		}*/		
		$.messager.alert('提示','请选择一条规则','info');	
		return;
	}
	else{	// 规则节点	
		ruleArr.push(node.ruleId)
	}
	var ruleStr=ruleArr.join("^");

	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	var edithtml = '<div id="editPanelDiv" class="edittextbox" style="height: 300px;"><textarea id="editPanel" class="textbox" style="width:460px;height:290px;margin:10px 10px 10px; 10px;"></textarea></div>';
	$('body').append('<div id="win">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#win",{
         iconCls:'icon-w-save',
        //resizable:true,
        title:'添加',
        modal:true,
        width:500,
        height:400,
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                saveRule(ruleStr);  
                $HUI.dialog("#win").close();                  
            }
        },{
            text:'关闭',
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

/// 保存规则
function saveRule(ruleID){
	
		var editText = $("#editPanel").val();
		runClassMethod("web.DHCCKBCheckRule","SaveRuleTemp",{"ruleID":ruleID,"input":editText,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
					if (jsonString == 1){
						$.messager.alert('提示','保存成功','info');
					}else{
						$.messager.alert('提示','保存失败,失败代码:'+jsonString,'warning');
					}		
					cleanEidtPanel();
		},"","");			
}
	
/// 加载规则修改的内容
function initRuleEditContent(ruleID){
	
		var text = "";
		runClassMethod("web.DHCCKBCheckRule","GetTextByRule",{"ruleID":ruleID},function(jsonString){
					text = jsonString;
		},"","");			

	return text;
}
	
/// 初始化
function cleanEidtPanel(){
		$("#editPanel").val("");		
}

/// 修改级别
function editLevel(){

	var nodes = $("#ruleTree").tree('getSelected');
	
	if (nodes==null){		// 叶子节点				
		$.messager.alert('提示','请选择一条规则','info');	
		return;
	}
	/* var rule = [];
	for (i =0; i<nodes.length;i++){
		var node = nodes[i];
		if ((node.ruleId != undefined)&(node.ruleId != null)){
			rule.push(node.ruleId);
		} 		
	}*/	
	var title = "修改级别";
	$("#levelDiv").show(); 
	var myWin = $HUI.dialog("#levelDiv",{
        iconCls:'icon-w-save',
        //resizable:true,
        title:title,
        modal:true,
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                SaveRuleLevel();             
                $HUI.dialog("#levelDiv").close();                  
            }
        },{
            text:'关闭',
            handler:function(){  
            	//cleanEidtPanel();                            
                myWin.close(); 
            }
        }]
    });
 }

/// 动态加载管理级别
function initLevelHtml(){
	var html = ""
	var manLevel = "提醒,提示,警示,禁止"
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

/// 保存级别修改
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
			$.messager.alert('提示','保存成功','info');
			queryRule(selectDicID,"")
		}else{
			$.messager.alert('提示','保存失败,失败代码:'+jsonString,'warning');
		}
				
	},"",false);	
	
}


/// 修改消息
function editMsg(){

	var ruleArr=[];
	var node = $("#ruleTree").tree('getSelected');
	if ((node == null)||(node.ruleId === undefined)){		// 叶子节点
		/*for (i=0;i<node.children.length;i++){
					var leaf=node.children[i];
					if (leaf.ruleId != undefined){
								ruleArr.push(leaf.ruleId);
					}
		}*/		
		$.messager.alert('提示','请选择一条规则','info');	
		return;
	}
	else{	// 规则节点	
		ruleArr.push(node.ruleId)
	}
	var title = "修改消息";
	var ruleStr=ruleArr.join("^");
	var ruleText = changeStr(node.content);
	if($('#msgWin').is(":visible")){return;}  //窗体处在打开状态,退出
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
            text:'保存',
            id:'save_btn',
            handler:function(){
                saveRuleMsg();  
                //$("#editMsgText").val("");  
                $HUI.dialog("#msgWin").close();                  
            }
        },{
            text:'关闭',
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
			$.messager.alert('提示','保存成功','info');
			queryRule(selectDicID,"")
		}else{
			$.messager.alert('提示','保存失败,失败代码:'+jsonString,'warning');
		}
				
	},"","");	
	
}


function changeStr(str){
	
	if ((str == "")||(str === undefined)||(str == null)){
		str = "";
	}
	return str;
}

/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
