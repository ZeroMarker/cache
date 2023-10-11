/**
	qunianpeng
	2020-09-15
	项目修改规则查询
*/
var	input ="";
var	hospID = 94;
var catID = "";
var selectDicID = "";
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

	}
	
	
/// 初始化药品列表
function initdicTable(){			
			$('#dicTable').datagrid({
				//toolbar:"#toolbar",
				url:LINK_CSP+"?ClassName=web.DHCCKBQueryHisUpdateRule&MethodName=QueryHisUpdateDrug&hospId="+hospID+"&catID="+catID+"&input="+input,
				columns:[[ 
					{field:'conID',title:'hisId',hidden:true},
					{field:'hisCode',title:'his代码',align:'center',hidden:false},
					{field:'hisDesc',title:'his药品名称',width:350,align:'center'},		
					{field:'libId',title:'知识库id',width:50,hidden:true},	
					{field:'libCode',title:'知识库药品代码',width:350,align:'center'},	
					{field:'libDesc',title:'知识库药品名称',width:350,align:'center'}				
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
		url:LINK_CSP+'?ClassName=web.DHCCKBQueryHisUpdateRule&MethodName=QueryUpdateRule',
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
  	
  	 var levels=levelArr.join("!");  	 hospID
	 //levels = "警示"; // 2021/3/24 暂时只查警示的内容
	 $("#ruleTree").tree("options").url=encodeURI($URL+'?ClassName=web.DHCCKBQueryHisUpdateRule&MethodName=QueryUpdateRule&queryID='+dicID+"&levels="+levels+"&hospId="+hospID);
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
	$('#dicTable').datagrid('load',{
		hospId:hospID,
		catID:catID,
		input:input,
		levels:levels
	}); 
}

/// 清空数据
function refreshData(){
	
		$HUI.searchbox('#queryCode').setValue("");
		$HUI.combobox("#hospId").setValue("");
		//$HUI.combobox("#ruleUse").setValue("");
		input ="";
		hospID = "";
		catID = "";
		selectDicID = "";
		cancelCheckBoxSelect();
		$('#dicTable').datagrid('loadData',{total:0,rows:[]});
		$("#ruleTree").tree("options").url=""
		$('#ruleTree').tree('reload');
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
			
		$('input:checkbox[name=level]:checked').each(function () {
		 	  $HUI.checkbox($(this)).setValue(false); 			 	   
		});  		
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
        iconCls:'icon-write-order',
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

	if($('#levelWin').is(":visible")){return;}  //窗体处在打开状态,退出
	var levelhtml = initLevelHtml();
	var edithtml = '<div id="levelDiv" style="height: 160px;">';
	edithtml = edithtml + '<span class="tdlabel"> 管理级别 </span>';
	edithtml = edithtml + '<table cellpadding=8 cellspacing=8 style="margin-left:100px;">'+levelhtml+'</table>';
	edithtml = edithtml + '</div>';
	$('body').append('<div id="levelWin">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#levelWin",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'添加',
        modal:true,
        width:400,
        height:300,
        buttonAlign : 'center',
        content:edithtml,
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                SaveRuleLevel();             
                $HUI.dialog("#levelWin").close();                  
            }
        },{
            text:'关闭',
            handler:function(){  
            	//cleanEidtPanel();                            
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

}

/// 动态加载管理级别
function initLevelHtml(){
	var html = ""
	
	runClassMethod("web.DHCCKBCheckRule","GetLevelFlagData",{},function(jsonString){
		if (jsonString != ""){
			for (i=0; i<jsonString.length; i++){
				var obj = jsonString[i];
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
 	var checkedRadioObj = $("input[name='initlevel']:checked");
 	var level = checkedRadioObj.val();
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
	var ruleStr=ruleArr.join("^");
	var ruleText = changeStr(node.content);
	if($('#msgWin').is(":visible")){return;}  //窗体处在打开状态,退出
	var edithtml = '<div id="msgDiv" class="edittextbox" style="height: 300px;"><textarea id="editMsgText" class="textbox" style="width:460px;height:290px;margin:10px 10px 10px; 10px;">'+'</textarea></div>';
	$('body').append('<div id="msgWin">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#msgWin",{
        iconCls:'icon-write-order',
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