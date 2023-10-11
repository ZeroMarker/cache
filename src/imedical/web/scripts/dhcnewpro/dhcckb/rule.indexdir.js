var LastPaNodeId="";		//上级的id
var drugruleID="",drugID="",num=0;  // xww 2021-08-06 获取药品和规则id
$(function(){ 
	InitParam(); //xww 2021-08-06 获取从字典数据规则引用界面传过来的参数
	initLookUp();
	initTree();
	
})

//xww 2021-08-06
function InitParam(){
	drugruleID = getParam("ruleID");
	drugID = getParam("drugID");
}

function initLookUp(){
       
  //目录
	$('#catDesc').combobox({
		url:$URL+'?ClassName=web.DHCCKBRuleIndex&MethodName=QueryCatDic'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
		//editable:false
	})
}

function initTree(){
	$('#ruleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+ModelDic+"&userInfo="+LoginInfo,
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onContextMenu: function(e, node){
			
			e.preventDefault();
			$('#ruleTree').tree('select', node.target);
			// 显示快捷菜单
			$('#treeMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onClick:function(node, checked){
			onClickTreeNode(node);			
	    },
	    onBeforeDrag:function(data){
		   /// 拖拽前事件，返回false则不允许移动此节点
		   var node=$(this).tree('getSelected');
		   if (node === null){return;} 
		   var isLeaf=$(this).tree('isLeaf',node.target);
		   if(isLeaf==false){return false;}
		},
	    onBeforeDrop:function(target,source){         
　　　　 	// 在拖动一个节点之前触发。
			var SouParNode = $(this).tree('getParent',source.target);
			LastPaNodeId=SouParNode.id
            var targetNode = $(this).tree('getNode',target);
            var isLeaf=$(this).tree('isLeaf',targetNode.target);
		    if(isLeaf==false){return false;}
		    var ParNode = $(this).tree('getParent',target);
		    var ParNodeText=""
		    if(ParNode==null){
			    ParNodeText=targetNode.text;
			}else{
				ParNodeText=ParNode.text;
			}
		    var tartext=source.text.split(">")[1];
            if(confirm("确认把 : "+tartext+" 从："+SouParNode.text+" 节点更新到 : "+ParNodeText+" 节点下?"))
                return true;                                                
                return false;
        },
        onDrop:function(target,source,operate){        
        	// 这个方法的效果是 拖动后触发向后台更新 被拖动节点更新到目标节点下。
            var targetNode = $(this).tree('getNode',target);
            var ParNode = $(this).tree('getParent',target);
            var ParNodeId="";
            if(ParNode==null){
	            ParNodeId=targetNode.id;
	        }else{
		        ParNodeId=ParNode.id;
		    }
            runClassMethod("web.DHCCKBRuleIndex","DragRule",{"RuleId":source.id,"LastCatId":LastPaNodeId,"NewCatId":ParNodeId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '移动成功！',type:'success',timeout: 1000});
		            	$("#ruleTree").tree('reload');
		            	return false;
		           	}else{
			           	if(data==-1){
				           	$.messager.popover({msg: '此规则已存在！',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		return false;
				        }else{
					        $.messager.popover({msg: '移动失败！',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		return false;
					    }
			        }
	        })
            
        },
        formatter:function(node){
	        var img=node.text.split("$c(1)")[0];
	        var desc=node.text.split("$c(1)")[1];
	        if(desc==undefined){desc="";}
			if ((desc!="")&&(desc.length > 30)) {
				var str ="" ;
				str = desc.substring(0, 30) + '......';
				return img+str ;
			} else {
				return img+desc;
			} 
			
		},
        onLoadSuccess:function(node,data){
	      commonAddTreeTitle("ruleTree",data)
	      BindTips();
	      	num=num+1;  //第一次不走 xww 2021-08-09
	      	if((drugruleID!="")&&(num>1)){
				findRuleKeyWord(drugruleID);
		   		drugruleID="";  //用完后清空，防止下次依然是这条数据 xww 2021-08-09
		   }
	    }
	});
	
	
	removeKeyWord();
	getRuleIframe(0)
	var selItem=window.parent.$("#modelTable").datagrid('getSelected');
	var opts = window.parent.$('#modelTable').datagrid('getColumnFields');
	var value="";
	for(var i=0;i<opts.length;i++){
		var colOpt=window.parent.$('#modelTable').datagrid('getColumnOption',opts[i])
		if(colOpt.hidden===false){
			if(value!=""){
				continue;	
			}
			var desc=selItem[colOpt.field].split(">")[1];
			var value=selItem[colOpt.field+"Id"]
			//console.log(value+"^"+desc)
			addKeyWord(value,desc,"");
		}	
	}
}

function onClickTreeNode(node){
		 var ruleId=node.ruleId
		
	     if(ruleId!=undefined){
			findRuleKeyWord(node.id); 
	     }else{
		    ruleId=0;
		    $("#selectKeyWords li a").each(function(index,itm){   //sufan 移除目录 2020-02-25
				if($(itm).attr("label-type")=="cat"){
					$(this).parent().remove();
				}
			})
		 	addKeyWord(node.id,node.text,"cat");  
		 }
		 var url="dhcckb.rule.editor0.csp?ruleId="+ruleId;
		 if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken();
		 }
		 $('#ruleFrame').attr('src', url);	
}
function commonAddTreeTitle(domId, nodeData) {
	if (nodeData != null && nodeData != "") {
		for (var index = 0; index < nodeData.length; index++) {
			var operNode = $('#' + domId).tree("find", nodeData[index].id + "");
			$(operNode.target).attr("title", nodeData[index].tiptext);
			commonAddTreeTitle(domId, nodeData[index].children);
		}
}
}
///悬浮提示
function BindTips()
{
	// 去掉 title 的提示框
	$(".tree-title").tooltip({
		position:'none',
		onShow:function(){
			$(this).tooltip('tip').css({
			backgroundColor:'rgba(0,0,0,0)'
			});
		}
	})
	var html='<div id="tip" style="max-width:500px;border-radius:5px;display:none;border:1px solid #000;padding: 5px 8px;position:absolute;background-color:rgba(0,0,0,.7);color:#fff;"></div>'
	$('body').append(html);
	/// 鼠标离开
	$('.tree-title').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('.tree-title').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			var title=$(this).parent()[0].title;
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 1
			}).text(title);   // .text()
		}
	})
}

///查找规则关键字
function findRuleKeyWord(rule){
	$("#selectKeyWords").html("");
	runClassMethod("web.DHCCKBRuleDic","FindRuleKeyWord",{ruleId:rule},function(data){
		$(data).each(function(index,itm){
			addKeyWord(itm.id,itm.text,itm.cat) //hxy 2021-03-26 ""->itm.cat
		})
	},"json")
}

///添加关键字
function addKeyWord(value,title,type){
	var existFlag=0;
	$("#selectKeyWords li a").each(function(index,itm){
		if($(itm).attr("id")==value){
			existFlag=1;
			return false;
		}
	})
	if(existFlag==0){
		if (type==""){
			$("#selectKeyWords").append("<li ><a onClick='removeKeyWordByObj(this)' id="+value+"  title=\""+title+"\">"+title+"</a></li>")
		}else{
			$("#selectKeyWords").append("<li ><a onClick='removeKeyWordByObj(this)' id="+value+"  label-type="+type+" title=\""+title+"\">"+title+"</a></li>")
		}
	}
	
}

function removeKeyWord(){
	$("#selectKeyWords").html("");
}

function getRuleIframe(ruleId){
	var url = "dhcckb.rule.editor0.csp?ruleId="+ruleId;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	$('#ruleFrame').attr('src', url); 
}

function lifeCycle(t){
	
	if(t==0){
		$.messager.alert("提示","请选择规则","info");
		return;	
	}
	
	var url="dhcckb.rule.life.csp?ruleId="+t;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
    
    $('#lifeDia').dialog({
                content: content,
                width:800,
                height:600,
                maximized: false,//默认最大化
                modal: false
	});
	$('#lifeDia').dialog('open')
}

function CreateRule(){
	var node = $("#ruleTree").tree('getSelected');
	if(node.ruleId!=undefined){
		$.messager.alert("提示","不能在规则下增加","info");
		return;
	}	
	var ruleId=0,relation=0,dicCode=0;
	dicCode=node.id;
	relation=node.relation;
	addKeyWord(node.id,node.text,"");
	var url="dhcckb.rule.editor0.csp?ruleId="+ruleId+"&relation="+ dicCode+"&dicCode="+relation;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	$('#ruleFrame').attr('src', url);	
}

function DeleteRule(){
	//var node = $("#ruleTree").tree('getSelected');
	var node = $("#ruleTree").tree('getChecked');
	var nodeArr = []
	for (i=0;i<node.length;i++){
		nodeArr.push(node[i].ruleId); 
	}
	var nodeStr = nodeArr.join("^");
	///if(node.ruleId!=undefined){
	if(nodeStr!=""){
			$.messager.confirm("提示", "您确定要删除吗？", function (res) {
				/// 提示是否删除
				if (res) {
					//runClassMethod("web.DHCCKBRuleSave","RemoveRule",{"ruleId":node.ruleId},function(jsonString){
					runClassMethod("web.DHCCKBRuleSave","RemoveRuleAll",{"nodeStr":nodeStr},function(jsonString){
						reloadTree();
					});
				}
			})	
    }else{
		$.messager.alert("提示","请选中规则!","info");   
	}

}

///移动规则 sufan 20200212
function MoveRule(){
	$("#ruleMoveWin").show();
	$HUI.combobox("#catDesc").setValue("");	
	var option = {
		iconCls:'icon-w-save',
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "移动规则";		
	new WindowUX(title, 'ruleMoveWin', '400', '125', option).Init();
}

///核实规则 sufan 20201105
function VerRule()
{
	var tableName = "DHC_CKBRule";				//表名
	//var dicId = node.id;														//记录id
	var funCode = "confirm";										//授权标记code
	var operator = LgUserID;											//操作者
	var Scope = "D"
	var ScopeValue = LgHospID;
	var ClientIPAddress = ClientIPAdd;
	var nodes = $('#ruleTree').tree('getChecked');
    var s = '';
	    for (var i = 0; i < nodes.length; i++) {
	        if (s != '')
	            s += '^';
	        s += nodes[i].id;
	    }
    var node = $("#ruleTree").tree('getSelected');
    var dicId = "";	
	    if(s)
	    {
			dicId=s;	    
		}else
		{
			dicId=node.id;	
		}
	runClassMethod("web.DHCCKBWriteLog","InsertLogs",{"DicDr":tableName,"dataDr":dicId,"Function":funCode,"Operator":operator,"OperateDate":"","OperateTime":"","Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress},function(ret){
	    if(ret==0)
	    {
		    $("#ruleTree").tree('reload');
		   }else{
			   $.messager.allert("提示","核实失败！错误代码"+ret);
			  }
	},'text',false);
	
	//修改规则表状态
	var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
	runClassMethod("web.DHCCKBRuleLog","SaveLog",{"ruleId":dicId,"LgUserId":operator,"loginInfo":userInfo,"baseHosp":"东华标准版数字化医院[总院]","Type":"Confirm"},function(ret){
    if(ret>0)
    {
	   // $("#ruleTree").tree('reload');
	   }else{
		   $.messager.allert("提示","规则日志状态添加失败"+ret);
		  }
	},'text',false);
	
}

///撤销核实 shy
function CancelVerRule()
{
	var node = $("#ruleTree").tree('getSelected');
	var tableName = "DHC_CKBRule";				                    //表名
	var dicId = node.id;											//记录id
	var funCode = "cancelconfirm";										//授权标记code
	var operator = LgUserID;										//操作者
	var Scope = "D"
	var ScopeValue = LgHospID;
	var ClientIPAddress = ClientIPAdd;
	runClassMethod("web.DHCCKBWriteLog","InsertLogs",{"DicDr":tableName,"dataDr":dicId,"Function":funCode,"Operator":operator,"OperateDate":"","OperateTime":"","Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress},function(ret){
	    if(ret==0)
	    {
		    $("#ruleTree").tree('reload');
		   }else{
			   $.messager.allert("提示","撤销核实失败！错误代码"+ret);
			  }
	},'text',false);
}

///授权规则 Sunhuiyong 20201110
function AuthRule()
{
	var node = $("#ruleTree").tree('getSelected');
	var dicId = node.id;
	var hideFlag=1;								//按钮隐藏标识
	var setFlag = "businessAuth";					//授权标识
	var tableName = "DHC_CKBRule";		        //授权表
	var dataId = dicId;					       //数据Id
	
	if($('#win').is(":visible")){return;}  			//窗体处在打开状态,退出
	
	$('body').append('<div id="win"></div>');
	var ifurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&TableName="+tableName+"&CloseFlag=1"+"&Operator="+LgUserID;
	if ("undefined"!==typeof websys_getMWToken){
		ifurl += "&MWToken="+websys_getMWToken();
	}
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-list',
        title:'授权',
        modal:true,
        width:700,
        height:460,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+ifurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                GrantAuthItem();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }]
    });
	$('#win').dialog('center');	
}

function CopyRule()
{
   var dicID=ModelDic;
   var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgProfessID+"^"+LgGroupID+"^"+LgHospID;
   var nodes = $('#ruleTree').tree('getChecked');
            var s = '';
            for (var i = 0; i < nodes.length; i++) {
                if (s != '')
                    s += ',';
                s += nodes[i].id;
            }
            
	$HUI.dialog("#CopyRuleWin").open();
	
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		multiple:true,
		selectOnNavigation:false,
		panelHeight:400,
		editable:true,
		//mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //选择指向字典id
	    }
	}; 
	if(window.parent.$HUI.combotree('#modelTree').jdata == undefined){
		var mode="";
	}else{
		var mode= window.parent.$HUI.combotree('#modelTree').getValue(); 
	}	
	var url = LINK_CSP+"?ClassName=web.DHCCKBRuleCopy&MethodName=GetDicComboboxList&extraAttr="+"KnowType" +"&extraAttrValue="+"DrugData"+"&mode="+mode+"&indicId="+dicID;;
	new ListCombobox("newDicDrug",url,'',option).init(); 
}

/// 批量发布/批量取消发布 qunianpeng 2020/2/23
function ReleaseStatus(status){

	var nodes = $('#ruleTree').tree('getChecked');
	if (nodes.length==0){
		$.messager.alert('提示','请勾选需要操作的规则！','info');
		return;
	}
    var ruleIdArr = [];
    for (var i = 0; i < nodes.length; i++) {
       if ((nodes[i].ruleId != undefined)&(nodes[i].ruleId != "")){
		    ruleIdArr.push(nodes[i].ruleId);     
		}        
    }
    var ruleIdStr=ruleIdArr.join("^"); 

	runClassMethod("web.DHCCKBRuleSave","ReleaseStatus",{"ruleIdStr":ruleIdStr,"loginInfo":LoginInfo,"status":status},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('提示','操作成功！','info');
		}else if(jsonString != 0){
			$.messager.alert('提示','操作失败！','warning');
		}	
		
		$("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+ModelDic+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');	
	
	});
}

//sunhuiyong 2021-2-23 批量移动规则
function saveMoveRules()
{
	var node = $("#ruleTree").tree('getSelected');  // 可能是根节点，也可能是叶子节点
	var ParNode = $('#ruleTree').tree('getParent',node.target);
	var CatId = $HUI.combobox("#catDesc").getValue();
	var checkNodes = $('#ruleTree').tree('getChecked');
	
	var s = '',rulearr = [],ParNodeId="";
	// 选中目录移动规则,移动目录下所有的规则(选中的是目录)
	if (node.hasOwnProperty("children")){
		ParNodeId = node.id;
		if(checkNodes.length == 0){	// 若勾选了规则,则移动勾选的规则,否则移动目录下所有的规则
			var nodearr = node.children;
			for (var i = 0; i < nodearr.length; i++){
				rulearr.push(nodearr[i].id);
			}
		}else{
			for (var i = 0; i < checkNodes.length; i++){
				if (checkNodes[i].hasOwnProperty("ruleId")){
					rulearr.push(checkNodes[i].ruleId);
				}				
			}
		}		
	}else{ // (选中的是叶子节点)
		ParNodeId = ParNode.id;
		for (var i = 0; i < checkNodes.length; i++){
			if (checkNodes[i].hasOwnProperty("ruleId")){
				rulearr.push(checkNodes[i].ruleId);
			}				
		}		
	}
	rule = rulearr.join(",");
	if ((rule == "")||(ParNodeId == "")){
		$.messager.alert('提示','请勾选需要移动的规则','info');
		return;
	}

	runClassMethod("web.DHCCKBRuleIndex","DragRules",{"RuleId":rule,"LastCatId":ParNodeId,"NewCatId":CatId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '移动成功！',type:'success',timeout: 1000});
		            	//$("#ruleTree").tree('reload');
		            	$("#ruleTree").tree('remove',node.target);
		            	$("#ruleTree").tree('reload');
		            	closeMoveWin()
		            	return false;
		           	}else{
			           	if(data==-1){
				           	$.messager.popover({msg: '此规则已存在！',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		closeMoveWin()
		            		return false;
				        }else{
					        $.messager.popover({msg: '移动失败！',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		closeMoveWin()
		            		return false;
					    }
			        }
	 })
} 
function closeMoveWin(){
	$("#ruleMoveWin").window('close');
}
function reloadTree(){
	$("#ruleTree").tree('reload');
	$("#commonRuleTree").tree('reload');		
	$("#globalRuleTree").tree('reload');		
}

//复制多个选中规则 sunhuiyong
function SaveCopyRuleData()
{
	var dicID=ModelDic;
	var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgProfessID+"^"+LgGroupID+"^"+LgHospID;
	var loginInfo=LgUserID+"^"+LgProfessID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
 	var nodes = $('#ruleTree').tree('getChecked');
            var s = '';
            for (var i = 0; i < nodes.length; i++) {
                if (s != '')
                    s += ',';
                s += nodes[i].id;
            }
    var node = $("#ruleTree").tree('getSelected');
	//var rule = node.id;
    var rule="";
    if(s)
    {
		rule=s;	    
	}else
	{
		rule=node.id;	
	}
	var newDicStr="";
    var newDicDrug=$("#newDicDrug").combobox('getValues');
    for(var k=0; k<newDicDrug.length; k++)
    {
		if(newDicStr=="")
		{
			newDicStr=newDicDrug[k];	
		}else{
			newDicStr=newDicStr+"^"+newDicDrug[k];		
		}
	}
    //$.messager.confirm("提示", "功能维护中...预计30min~");	
    //return;
	$.messager.confirm("提示", "您确定要复制这些规则？", function (res) {	// 提示是否复制
		if (res) {
			
			//alert(dicID+"@@"+userInfo+"@@"+rule);
			//保存数据
			runClassMethod("web.DHCCKBDrugDetail","SaveSingleRules",{"dicID":dicID,"newDicStr":newDicStr,"LgUserId":LgUserID,"userInfo":userInfo,"rulestr":rule,"loginInfo":loginInfo},function(jsonString){
				reloadTree();
				if (jsonString == 0){
					$HUI.dialog('#CopyRuleWin').close();
					$.messager.alert('提示','复制成功','info');
				}else{
					$HUI.dialog('#CopyRuleWin').close();
					$.messager.alert('提示','复制失败,失败代码:'+jsonString,'warning');
				}
				//QueryDicList();
			});
			//alert("Yes!");
		}
	});		
}

///项目授权
function GrantAuthItem(){
	var sucfalg=$("#otherdiclog")[0].contentWindow.SaveManyDatas();	// 子页面日志
	//$.messager.popover({msg: '授权成功！',type:'success',timeout: 1000});
	$HUI.dialog('#win').close();
}
