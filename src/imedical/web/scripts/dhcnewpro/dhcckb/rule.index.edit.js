/**
	zhouxin
	2019-06-20
	规则维护界面
*/
var LastPaNodeId="";		//上级的id
var drugruleID="",drugID="",num=0;  // xww 2021-08-06 获取药品和规则id
var isrule="",isconfirm="";  // isrule-结构化  isconfirm-核实
var	hospID = "";  //ld  2022-9-5 添加医院查询
var	attr="",attrVal ="";  //ld  2022-9-6 添加属性查询
$(function(){ 
	InitParam(); //xww 2021-08-06 获取从字典数据规则引用界面传过来的参数
	initCheckbox(); // 2022-05-24 cy 注册checkbox的单击事件
	initTree();
	//initTable();
	initLookUp();
	//initConstant();
	initButton();
	initSelectTabs();
	initCommbobox();				// ld  2022-9-5 初始化combobox
})
// 2022-05-24 cy 注册checkbox的单击事件
function initCheckbox(){
	if ($('input[name="ruleFlag"]:checked').length){
		isrule=$("input[name='ruleFlag']:checked").val();
	}
	if ($('input[name="drugConfirmFlag"]:checked').length){
		isconfirm=$("input[name='drugConfirmFlag']:checked").val();
	}
	$HUI.radio("[name='ruleFlag']",{
        onCheckChange:function(e,value){
           if(value){
           	isrule=this.value;
           }else{
	          isrule=""; 
	       }
        }
    });
    $HUI.radio("[name='drugConfirmFlag']",{
        onCheckChange:function(e,value){
           if(value){
           		isconfirm=this.value;
           }else{
	       		isconfirm=""; 
	       }
        }
    });
}


//xww 2021-08-06
function InitParam(){
	drugruleID = getParam("ruleID");
	drugID = getParam("drugID");
}


function initLookUp(){
   $("#dicLookUp").lookup({
            width:120,
            panelWidth:500,
            panelHeight:410,
            url:LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr=KnowType&extraAttrValue=DictionFlag&params=',
            mode:'remote',
            idField:'ID',
            textField:'CDDesc',
            fitColumns:true,
            columns:[[
            	{field:'ID',title:'ID',hidden:true},
            	{field:'CDCode',title:'代码',width:200},    
                {field:'CDDesc',title:'描述',width:200}  
            ]],
            pagination:true,
            onSelect:function(index,rowData){
                $('#dicLookUp').lookup('setText',rowData.CDDesc);
                $('#dicTable').datagrid('load', {id: rowData.ID});
                DrugData=rowData.ID
            }
       });
       
      //目录
		$('#catDesc').combobox({
			url:$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=QueryCatDic',
			valueField: 'value',
			textField: 'text',
			blurValidValue:true,
			editable:false
		})
}

function initTree(){
	$('#commonRuleTree').tree({
    	/* url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListCommonRuleIndexTree&LoginInfo='+LoginInfo, */
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetSortTreeJsonData&LoginInfo='+LoginInfo,
    	lines:true,
		animate:true,
		onContextMenu: function(e, node){
			var defflag=node.defflag
			if ((defflag==1)||(typeof(defflag)=="undefined")){
				e.preventDefault();
				$('#commonRuleTree').tree('select', node.target);
				// 显示快捷菜单
				$('#commonRuleMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
			}
			
		},
		onClick:function(node, checked){
			var defflag=node.defflag
			if ((defflag==1)||(typeof(defflag)=="undefined")){
			removeKeyWord();
			onClickTreeNode(node)
				}
			if (defflag==0){
				$('#ruleFrame').attr('src', "");
				}
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
			//return img+desc;
		},
        onLoadSuccess:function(node,data){
	      commonAddTreeTitle("commonRuleTree",data)
	      BindTips();
	    }
	});	
	$('#globalRuleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListGlobalRuleIndexTree&LoginInfo='+LoginInfo,
    	lines:true,
		animate:true,
		onContextMenu: function(e, node){
			
			e.preventDefault();
			$('#globalRuleTree').tree('select', node.target);
			// 显示快捷菜单
			$('#globalRuleMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		 onClick:function(node, checked){
			$("#itmId").val(node.id);
			removeKeyWord();
			onClickTreeNode(node)
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
			//return img+desc; 
			
		},
        onLoadSuccess:function(node,data){
	      commonAddTreeTitle("globalRuleTree",data)
	      BindTips();
	    }
	});	
	$('#modelTree').combotree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListModelTree'+"&drugType="+InitDrugType(),
    	lines:true,
		animate:true,
		onSelect: function(rec){
			var parent=rec.id;
			runClassMethod("web.DHCCKBRuleIndexEdit","ListModelDataGrid",{"parent":parent},function(data){
				var json= eval('(' + data + ')');
				//json.push({"field":"op","title":"操作",formatter:FormatterOP})
				$('#modelTable').datagrid({
					toolbar:"#modelToolbar",
					url:LINK_CSP+"?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListModelDataNew&parent="+parent+"&drugID="+drugID+"&isrule="+isrule+"&isconfirm="+isconfirm+"&parStr=",  //xww 2021-08-06 新加drugID ,
					columns:[json],
					headerCls:'panel-header-gray',
					iconCls:'icon-paper', 
					border:false,
					fit:true,
					fitColumns:true,
					singleSelect:true, 
					pagination:true,
					pageSize:30,
					pageList:[30,60,90],
					displayMsg: '共{total}记录',
					onClickRow: function (rowIndex, rowData) {		//双击选择行编辑 //hxy 2022-07-06 双击改单击 onDblClickRow
          			 	/* CommonRowClick(rowIndex,rowData,"#modelTable");
           				dataGridBindEnterEvent(rowIndex); */
           				dataModelClick(rowData);
        			},
	        		onLoadSuccess: function (rowData) {   //xww 2021-08-06 默认加载传过来的药品规则
		    			if(drugID!=""){
		    				dataModelLoad(rowData.rows[0]);
		    				$('#modelTable').datagrid('selectRow',0); //默认选中第一行
		    			}
		    			TbBindTips();
					}
				});
			},"text","false");
	    },
	    onLoadSuccess: function (node, data) {
		    $('#modelTree').combotree('setValue',data[0].id);
		}
	});	
}
// 字数限制30字,超出不显示
function fontNumber (data) {
  var length = data.length;
  if (length > 30) {
    var str ="" ;
    str = data.substring(0, 30) + '......';
    return str ;
  } else {
    return data;
  }
}
/// 给节点div  title赋值 便于悬浮取值 　
function commonAddTreeTitle(domId, nodeData) {
	if (nodeData != null && nodeData != "") {
		for (var index = 0; index < nodeData.length; index++) {
			var operNode = $('#' + domId).tree("find", nodeData[index].id + "");
			$(operNode.target).attr("title",nodeData[index].tiptext);
			commonAddTreeTitle(domId, nodeData[index].children);
		}
	}
}
///悬浮提示
function BindTips()
{
	/* $(".tree-title").tooltip({
		position:'right',
		content:'<span style="color:#fff" class="_tooltip"></span>',
		onShow:function(){
			tree_title=this;
			//alert($(this).parent().id)
			$("._tooltip").text(tree_title.innerText);
		}
	}) */
	// 去掉 title 的提示框
	$(".tree-title").tooltip({
		position:'none',
		onShow:function(){
			$(this).tooltip('tip').css({
			backgroundColor:'rgba(0,0,0,0)'
			});
		}
	})
	var html='<div id="tip" style="max-width:500px;border-radius:3px;display:none;border:1px solid #000;padding:10px;position:absolute;background-color:#000;color:#fff;"></div>'
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
					opacity: 0.6
				}).text(title);    // .text()  this.innerText
			}
	})
}
function initButton(){
	
	
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});
	
	///模板规则查询
	$('#queryrules').searchbox({
	    searcher:function(value,name){
	   		ReloadModelGrid(value);
	    }	   
	});
	
	///重置
	$("#reset").bind('click',function(){
		$HUI.searchbox("#queryrules").setValue("");
		$HUI.combobox("#hospId").setValue("");
		$HUI.combobox("#LookUp").setValue("");
		$HUI.combobox("#QueCond").setValue("");
		$('#modelTree').combotree("reload");	
		ReloadModelGrid("");
	
	})
	///查询
	$("#search").bind('click',function(){
		var rules=$HUI.searchbox("#queryrules").getValue();	
		ReloadModelGrid(rules);
	})
}

function initSelectTabs(){
	$('#mainPanel').layout('hidden','center'); 
	$('#mainPanel').layout('panel', 'west').panel("resize", {
		width:document.body.clientWidth-10
	}); 
	$HUI.tabs("#ruleTabs",{
		onSelect:function(title){
			/// 字典规则改为属于规则
			if ((title=="术语规则")||(title=="全局规则")){	
				$('#mainPanel').layout('panel', 'west').panel("resize", {
					width:550
				});	
				$('#ruleTabs').tabs({
					//width:document.body.clientWidth-560
				});	
				var eastwid = $("#mainPanel").layout("panel", "center")[0].clientWidth;
				if(eastwid == 0){
					$('#mainPanel').layout('show', 'center');
				}
			}else{
				$('#mainPanel').layout('panel', 'west').panel("resize", {
					width:document.body.clientWidth-10
				});
				$('#ruleTabs').tabs({
					width:document.body.clientWidth-10
				});				
				$('#mainPanel').layout('hidden','center');  
	
			}
		}
	}); 
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
	///属性
	$("#LookUp").combobox({
		url:$URL+'?ClassName=web.DHCCKKBIndex&MethodName=QueryDrugAttr',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option) {
			$("#QueCond").combobox('setValue',"");
			var unitUrl = $URL+"?ClassName=web.DHCCKKBIndex&MethodName=QueryAttrData&Parref="+option.value
			$("#QueCond").combobox('reload',unitUrl);
			attr = option.value;
		}
		
	})
	///属性值
	$("#QueCond").combobox({
		url:'',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			attrVal = option.value;
		}
	})
	
}
function getParStr(){
		
		// 条件下拉值（列名 代码）
		var attr=$("#LookUp").combobox('getValue');
		if(attr!=undefined){
			attr=attr;
		}else{
			attr="";
		}
		// 输入判断值 （具体的数据）
		var attrVal=$("#QueCond").combobox('getValue');
		if(attrVal!=undefined){
			attrVal=attrVal;
		}else{
			attrVal="";
		}
		// 列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系
		var par=attr+"$"+attrVal+"$"+"";
		return par;
}
function QueryDicList(){

	var params = $HUI.searchbox("#queryCode").getValue();
	$('#dicTable').datagrid('load',{
		id:DrugData,
		parDesc:params	
	}); 
}


function addModelKeyWord(){
	if(!endEditing("#modelTable")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var Selected=$('#modelTable').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("提示","请选择记录");
		return;
	}
	
	$('#ruleFrame').attr('src', "dhcckb.rule.edit.csp?ruleId=0"+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""));	
	
}
function initModelDataGrid(id){
	var index=$('#modelTable').datagrid('getRowIndex',Selected)
	var opts = $('#modelTable').datagrid('getColumnFields');
	//console.table($('#modelTable').datagrid('getRows'));
	removeKeyWord();
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
		if(colOpt.hidden===false){
			var desc=Selected[colOpt.field]
			var value=$('#modelTable').datagrid('getRows')[index][colOpt.field+"Id"]
			if(value==""){
				continue;	
			}
			//console.log(value+"^"+desc)
			addKeyWord(value,desc,"");
		}	
	}
		runClassMethod(
			"web.DHCCKBRuleSave",
			"RemoveRule",
			{"ruleId":node.ruleId},
			function(jsonString){
				reloadTree();
		});	
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
		 var url="dhcckb.rule.editor0.csp?ruleId="+ruleId+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
		 $('#ruleFrame').attr('src', url);	
}

function CreateRule(){
	var node = $("#ruleTree").tree('getSelected');
	if(node.ruleId!=undefined){
		$.messager.alert("提示","不能在规则下增加");
		return;
	}	
	var ruleId=0,relation=0,dicCode=0;
	dicCode=node.id;
	relation=node.relation;
	addKeyWord(node.id,node.text,"");
	var url="dhcckb.rule.editor0.csp?ruleId="+ruleId+"&relation="+ dicCode+"&dicCode="+relation+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
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
		$.messager.alert("提示","请选中规则!");   
	}

}
///移动规则 sufan 20200212
function MoveRule(){
	$("#ruleMoveWin").show();
	$HUI.combobox("#catDesc").setValue("");	
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "移动规则";		
	new WindowUX(title, 'ruleMoveWin', '400', '150', option).Init();
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
	
	var linkurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&TableName="+tableName+"&CloseFlag=1"+"&Operator="+LgUserID;
	linkurl += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-write-order',
        title:'授权',
        modal:true,
        width:700,
        height:500,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
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
///复制规则 Sunhuiyong 20201116
function CopyRuleOld()
{
	var dicID=$('#modelTable').datagrid('getSelected').ID;
	var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
	var node = $("#ruleTree").tree('getSelected');
	var rule = node.id;
	$.messager.confirm("提示", "您确定要复制此条规则？", function (res) {	// 提示是否复制
		if (res) {
			
			//alert(dicID+"@@"+userInfo+"@@"+rule);
			//保存数据
			runClassMethod("web.DHCCKBDrugDetail","SaveSingleRule",{"dicID":dicID,"newDicID":dicID,"LgUserId":LgUserID,"userInfo":userInfo,"rule":rule},function(jsonString){
				reloadTree();
				if (jsonString == 0){
					$.messager.alert('提示','复制成功','info');
				}else{
					$.messager.alert('提示','复制失败,失败代码:'+jsonString,'warning');
				}
				//QueryDicList();
			});
			//alert("Yes!");
		}
	});	
}


function CopyRule()
{
   var dicID=$('#modelTable').datagrid('getSelected').ID;
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


	var mode= $HUI.combotree('#modelTree').getValue();
	var url = LINK_CSP+"?ClassName=web.DHCCKBRuleCopy&MethodName=GetDicComboboxList&extraAttr="+"KnowType" +"&extraAttrValue="+"DrugData"+"&mode="+mode;
	new ListCombobox("newDicDrug",url,'',option).init(); 
}
//复制多个选中规则 sunhuiyong
function SaveCopyRuleData()
{
	var dicID=$('#modelTable').datagrid('getSelected').ID;
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
function saveMoveRule()
{
	var node = $("#ruleTree").tree('getSelected');
	var ParNode = $('#ruleTree').tree('getParent',node.target);
	var CatId = $HUI.combobox("#catDesc").getValue();
	runClassMethod("web.DHCCKBRuleIndexEdit","DragRule",{"RuleId":node.id,"LastCatId":ParNode.id,"NewCatId":CatId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '移动成功！',type:'success',timeout: 1000});
		            	//$("#ruleTree").tree('reload');
		            	$("#ruleTree").tree('remove',node.target);
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
//sunhuiyong 2021-2-23 批量移动规则
function saveMoveRules()
{
	var node = $("#ruleTree").tree('getSelected');
	var ParNode = $('#ruleTree').tree('getParent',node.target);
	var CatId = $HUI.combobox("#catDesc").getValue();
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
	runClassMethod("web.DHCCKBRuleIndexEdit","DragRules",{"RuleId":rule,"LastCatId":ParNode.id,"NewCatId":CatId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '移动成功！',type:'success',timeout: 1000});
		            	//$("#ruleTree").tree('reload');
		            	$("#ruleTree").tree('remove',node.target);
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




function AddRule(id){
	
	var node = $("#"+id).tree('getSelected');
	if(node.ruleId!=undefined){
		$.messager.alert("提示","不能在规则下增加");
		return;
	}	
	var dicCode=node.id;
	
	var url="dhcckb.rule.editor0.csp?ruleId=0&relation="+ dicCode+"&dicCode="+AddRuleFlag+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
	$('#ruleFrame').attr('src', url);	
}

function DeleteComRule(id){
	var node =  $("#"+id).tree('getSelected');
	if(node.ruleId!=undefined){
			$.messager.confirm("提示", "您确定要删除吗？", function (res) {
				/// 提示是否删除
				if (res) {
					runClassMethod("web.DHCCKBRuleSave","RemoveRule",{"ruleId":node.ruleId},function(jsonString){
						reloadTree();
					});
				}
			})	
    }else{
		$.messager.alert("提示","请选中规则!");   
	}
}


///规则列表
function initTable(){

	$('#dicTable').datagrid({
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
			{field:'ID',hidden:true},
			{field:'CDCode',title:'代码',align:'center',hidden:true},
			{field:'CDDesc',title:'描述',width:350,align:'center',formatter: function(value,row,index){
				if (row.RuleFlag == 1){
					return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"+value;
				} else {
					return value;
				}
			}},
			{field:'op',title:'操作',width:50,formatter:FormatterAdd}			
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
		onDblClickRow: function (rowIndex, rowData) {
			dataGridDBClick(rowData)
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '共{total}记录'
	});
}

function dataGridDBClick(rowData){
	
	    $("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+rowData.ID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
		removeKeyWord();
		addKeyWord(rowData.ID,rowData.CDDesc,"")
		getRuleIframe(0)
}
///目录录入双击事件 sufan 20200214
function dataModelClick(rowData){
		var url="dhcckb.rule.indexdir.csp?ModelDic="+rowData.ID+"&LoginInfo="+LoginInfo+"&ruleID="+drugruleID+"&drugID="+drugID;
		url += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
		var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
		$('#dirDia').dialog({
				content: content,
				width:window.innerWidth-100, //1400,
                //width:window.screen.availWidth-100, //1400,
                height:window.screen.availHeight-140, //800,
                maximized: false,//默认最大化
                modal: true
		});
		$('#dirDia').dialog('open');
		
	    $("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+rowData.ID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
		removeKeyWord();
		getRuleIframe(0)
		var selItem=$("#modelTable").datagrid('getSelected');
		var opts = $('#modelTable').datagrid('getColumnFields');
		var value="";
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
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
function getRuleIframe(ruleId){
	$('#ruleFrame').attr('src', "dhcckb.rule.editor0.csp?ruleId="+ruleId+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"")); 
}

function FormatterAdd(value,rowData){
	return "<span style='cursor: pointer' class='icon icon-add' onClick='addKeyWord("+rowData.ID+",\""+rowData.CDDesc+"\","+""+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
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
///删除关键字
function removeKeyWordByObj(obj){
	
	var title=$(obj).attr("title")
	$.messager.confirm("操作提示", "确认要删除<font color='red' >"+title+"</font>吗？", function (data) {  
            if (data) {  
               $(obj).parent().remove();
            } 
    }); 	
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
///删除目录
function clearKeyWord(){
	$.messager.confirm("操作提示", "确认要清空目录吗？", function (data) {  
            if (data) {  
               removeKeyWord();
            } 
    }); 
}
function removeKeyWord(){
	$("#selectKeyWords").html("");
}
function lifeCycle(t){
	
	if(t==0){
		$.messager.alert("提示","请选择规则");
		return;	
	}
	
	var url="dhcckb.rule.life.csp?ruleId="+t;
	url += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
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

function initConstant(){
	
	//数据集
	/***/
    $.getJSON("web.DHCCKBRuleConstants.cls", function(json){
  		window._uruleEditorConstantLibraries = json;

	});
}

function addModelRow(){
	
	commonAddRow({'datagrid':'#modelTable',value:{}})
	dataGridBindEnterEvent(0);
}

function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#modelTable').datagrid('getEditors',index);

	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		
		editors[i].target.attr("field",editors[i].field);
		
		editors[i].target.mousedown(function(e){
				var field=$(this).attr("field")
				var ed=$("#modelTable").datagrid('getEditor',{index:index, field:field});		
				var input = $(ed.target).val();
				divComponent({
							  tarobj:$(ed.target),
							  filed:field,
							  input:input,
							  htmlType:'datagrid',
							  height:'260',
							  url:LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id='+field+"&parDesc="+encodeURIComponent(input),
							  columns:[[
							  	{field:'ID',hidden:true},
							  	{field:'CDDesc',title:'描述',width:60}
							  ]] 
							},function(rowData){
								$(ed.target).val(rowData.CDDesc);
								var IdEd=$("#modelTable").datagrid('getEditor',{index:index,field:field+"Id"});
								$(IdEd.target).val(rowData.ID);
								$("#win").remove();
							})
			
		});
		
		
	}
}
/// 增加/修改全局规则
function editGlobalItm(type){

	if (type == "E"){
		var node =  $("#globalRuleTree").tree('getSelected');	
		if (node == null){
			$.messager.alert("提示","请选择一个项目进行修改!");
			return;
		}
		if (node.ruleId != undefined){
			return;
		}
		$("#itmId").val(node.id);
		$("#itmCode").val(node.code);
		$("#itmDesc").val(node.text);
	}else{
		$("#itmId").val("");
		$("#itmCode").val("");
		$("#itmDesc").val("");
	}
	newCreateWin();	
}

/// Window 定义
function newCreateWin(){	
	$("#globalWin").show();	
	var option = {
		modal:true,
		collapsible:false,
		minimizable: false,
		maximizable: false,
		iconCls: 'icon-w-save',
		border:true,
		closed:"true"
	};
	var title = "全局规则字典";		
	new WindowUX(title, 'globalWin', '400', '165', option).Init();
}

/// 删除全局规则
function delGlobalItm(){
	
	var node =  $("#globalRuleTree").tree('getSelected');	
	if (node == null){
		$.messager.alert("提示","请选择一个项目删除!","info");
		return;
	}
	if (node.ruleId != undefined){
		return;
	}
	if (node.children.length != 0){
		$.messager.alert("提示","选择的项目下有规则,不能直接删除项目!","info");
		return;
	}
	var id=node.id;
	if (id != "") {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":id},function(jsonString){
					$('#globalRuleTree').tree('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
	
}

/// 关闭窗口
function closeGlobalWin(){
	$("#globalWin").window("close");
}

/// 保存全局规则字典
function saveGlobalItm(){

	var id=$("#itmId").val();
	var code=$("#itmCode").val();
	var desc=$("#itmDesc").val();
	
	if (code == ""){
		$.messager.alert("提示","代码不能为空!");
		return;
	}
	if (desc == ""){
		$.messager.alert("提示","描述不能为空!");
		return;
	}
	
	var params=id +"^"+ code +"^"+ desc +"^"+globalparref;
	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":""},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			closeGlobalWin();
			$("#globalRuleTree").tree('reload');
			return;
		}
	});
}
///查询模板规则

function ReloadModelGrid(Input)
{
	/* if(hospID ==""){
		$.messager.alert("提示","请选择一个院区!","info");
		return;
	} */
	var parent = $HUI.combotree('#modelTree').getValue();
	if ($('input[name="ruleFlag"]:checked').length){
		isrule=$("input[name='ruleFlag']:checked").val();
	}
	if ($('input[name="drugConfirmFlag"]:checked').length){
		isconfirm=$("input[name='drugConfirmFlag']:checked").val();
	}
	var parStr=getParStr();
	$("#modelTable").datagrid('reload',{"parent":parent,"Input":Input,"isrule":isrule,"isconfirm":isconfirm,"hospID":hospID,"parStr":parStr });
}
///规则模板操作
function FormatterOP(value,rowData,index)
{
	return "<span style='cursor: pointer' class='icon icon-add' onClick='addRulueKeyWord("+rowData+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
}
function addRulueKeyWord(rowData)
{
	dataModelClick(rowData);
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
		
		var selecItm=$("#modelTable").datagrid('getSelected');
		var dicId=selecItm.ID;
		$("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+dicId+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');	
	
	});
}

/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
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


///目录录入双击事件 xww 20210806 默认选中传入的规则
function dataModelLoad(rowData){
		
	    $("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+rowData.ID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
		removeKeyWord();
		getRuleIframe(drugruleID)
		var selItem=$("#modelTable").datagrid('getRows')[0];
		var opts = $('#modelTable').datagrid('getColumnFields');
		var value="";
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
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

function resize(){
	
	$('.mainpanel').css("width","700px");
	$('.treeitem').css("left","720px");
	$('.treeitem').css("right","0");
	$('.griditem').css("width","0");
	//$.parser.parse('.mainpanel');
}

/// 绑定提示栏
function TbBindTips(){
	var html='<div id="TbTip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// 鼠标离开
	$('td[field="81224"]').on({
		'mouseleave':function(){
			$("#TbTip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="81224"]').on({
		'mousemove':function(){
			var tleft=(event.clientX + 10);
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#TbTip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text($(this).text());
		}
	})
}
