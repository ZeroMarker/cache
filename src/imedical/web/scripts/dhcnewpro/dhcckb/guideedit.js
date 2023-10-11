var parref = "";
var drugid="";
var drugidnew="";
var IsEnableValue="",LevelFlagValue="",KnowSourceValue="",IsEnableText="",LevelFlagText="",KnowSourceText="",RuleId="";
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var queryType = "drugType";	
var dictionType="dictionType";
var ActiveArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var LastPaNodeId="";		//上级的id

function initPageDefault(){
	initCombobox();		// 初始化combobox
	initButton();
	initTree();
	initdicTable();		// 初始化药品商品名列表
	initdictionTable();
}
///商品药 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
///通用药 药品类型
function InitdictionType(){	
	var drugType = getParam("dictionType");	
	return drugType;
}
function initButton(){
	$("#find").bind("click",QueryDicList);	// 查询商品名
	$("#reset").bind("click",ExportReset);	// 重置 qnp 2021/07/13
	$("#findto").bind("click",QueryDicListnew);	// 查询通用名
	$("#resetto").bind("click",ExportResetnew);	// 重置通用
	$("#btnAdd").bind('click',function(){
		SaveRule()
	});										// 新增
	/* $("#btnUpd").bind('click',function(){
		SaveRule()
	});										// 修改 */
	$("#btnDel").bind("click",DeleteRule);	// 删除
	$("#btnRel").bind("click",RelodePage);	// 清屏
	
}
function initTree(){
	$('#ruleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBGuideEdit&MethodName=GetDrugLibraryTree'+"&userInfo="+LoginInfo,
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onClick:function(node){
			RuleId=node.id;
			LoadRightValue(node)
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
		    var ParNodeText=""
		    if (targetNode.hasOwnProperty("ruleId")){
				var ParNode = $(this).tree('getParent',target);	
				ParNodeText=ParNode.text;	    
			}else{
				ParNodeText=targetNode.text;
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
           /*  if(ParNode==null){
	            ParNodeId=targetNode.id;
	        }else{
		        ParNodeId=ParNode.id;
		    } */
		    if (targetNode.hasOwnProperty("ruleId")){
				ParNodeId =  ParNode.id;
			}else{
				ParNodeId=targetNode.id;
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
            
        }
	     
	});
}
///商品药查询
function initdicTable(){
	
	var hospId = $HUI.combobox("#hospId").getValue();
	//var parVale = $HUI.combobox("#dicType").getValue();	
	$('#dicTable').datagrid({
		toolbar:"#toolbar", //var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
		url:$URL+"?ClassName=web.DHCCKBGuideEdit&MethodName=GetDicInstanceByParref&parref="+parref+"&params="+"&hospId="+hospId+"&existGuide=",
		//url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
		/* 	{field:'ID',hidden:true},
			{field:'CDParrefDesc',title:'类型',width:100,align:'center'},		
			{field:'CDCode',title:'代码',align:'center',hidden:true},
			{field:'CDDesc',title:'药品名称',width:350,align:'left'} */
			{field:'dicID',title:'rowid',hidden:true},
			{field:'parref',title:'父节点id',width:100,align:'left',hidden:true},
			{field:'parrefDesc',title:'类型',width:100,align:'left'},
			{field:'dicCode',title:'代码',width:200,align:'left',hidden:true},
			{field:'dicDesc',title:'描述',width:350,align:'left'},
			{field:'Operating',title:'操作',width:60,align:'center',formatter:SetCellOper}
	
		 ]],
		title:"药品列表",
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
		onClickRow:  function (rowIndex, rowData) {
			//$('#indicTable').datagrid('load', {dic: rowData.ID});
			//$('#dirTable').datagrid('load', {dic: rowData.ID});
			dataGridDBClick(rowData);
			drugidnew=rowData.dicID;
			reloadTree();
			RelodePage();
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '共{total}记录'
	});
		
}	
///通用药查询
function initdictionTable(){
	$('#comTable').datagrid({
		toolbar:"#toolbarto", //var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
		url:$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+"78200"+"&params="+"^78200"+"&drugType="+InitdictionType()+"&hospId="+"&queryType="+dictionType,
		//url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
		/* 	{field:'ID',hidden:true},
			{field:'CDParrefDesc',title:'类型',width:100,align:'center'},		
			{field:'CDCode',title:'代码',align:'center',hidden:true},
			{field:'CDDesc',title:'药品名称',width:350,align:'left'} */
			{field:'dicID',title:'rowid',hidden:true},
			{field:'parref',title:'父节点id',width:100,align:'left',hidden:true},
			{field:'parrefDesc',title:'类型',width:100,align:'left'},
			{field:'dicCode',title:'代码',width:200,align:'left',hidden:true},
			{field:'dicDesc',title:'描述',width:350,align:'left'}
	
		 ]],
		title:"药品列表",
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
		onClickRow:  function (rowIndex, rowData) {
			//$('#indicTable').datagrid('load', {dic: rowData.ID});
			//$('#dirTable').datagrid('load', {dic: rowData.ID});
			dataGridDBClick(rowData);
			reloadTree();
			RelodePage();
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '共{total}记录'
	});
		
}
function SaveRule(){
	
	if(drugidnew==""){
		$.messager.alert("提示","请选择药品!",'warning'); 
		return;
	}else{
	var DrugPrintId=serverCall("web.DHCCKBGuideEdit","GetDrugPrintId","");
	var LevelFlagId=serverCall("web.DHCCKBGuideEdit","GetLevelFlagId","");
	var WarnMessageId=serverCall("web.DHCCKBGuideEdit","GetWarnMessageId","");
	var KnowSourceId=serverCall("web.DHCCKBGuideEdit","GetKnowSourceId","");
	var IsEnableValue=$("#IsEnable").combobox('getValue');
	var IsEnableText=$("#IsEnable").combobox('getText');
	var LevelFlagValue=$("#LevelFlag").combobox('getValue');
	var LevelFlagText=$("#LevelFlag").combobox('getText');
	
	var KnowSourceValue=$("#KnowSource").combobox('getValue');
	var KnowSourceText=$("#KnowSource").combobox('getText');
	
	var WarnMessage=$("#Descript").val();
	/* 管理级别 */
	var AssignListFir={
         "value":{
         	"_ruleData":"0",
         	"_const-category":"undefined",
         	"_const":LevelFlagValue,//管理级别ID
         	"_const-label":LevelFlagText,//管理级别描述
          	"_type":"Constant"
                  },
         "_varCategory":"药品输出",
         "_ruleData":"0",
         "_varCategoryId":DrugPrintId,
         "_var":LevelFlagId,
         "_varLabel":"管理级别",
         "_datatype":"String",
         "_type":"variable"
                };
    /* 提示信息 */             
	var AssignListSec={
         "value":{
         	"_ruleData":"0",
         	"_content":WarnMessage,//描述
         	"_type":"Input"
                  },
         "_varCategory":"药品输出",
         "_ruleData":"0",
         "_varCategoryId":DrugPrintId,
         "_var":WarnMessageId,
         "_varLabel":"提示信息",
         "_datatype":"String",
         "_type":"variable"
                };
    /* 知识来源 */
    var AssignListFif={
         "value":{
         	"_ruleData":"0",
         	"_const-category":"undefined",
         	"_const":KnowSourceValue,
         	"_const-label":KnowSourceText,
          	"_type":"Constant"
                  },
         "_varCategory":"药品输出",
         "_ruleData":"0",
         "_varCategoryId":DrugPrintId,
         "_var":KnowSourceId,
         "_varLabel":"知识来源",
         "_datatype":"String",
         "_type":"variable"
                };
    var param=[];
    param.push(AssignListFir);
    param.push(AssignListSec);
    /* param.push(AssignListThi);
    param.push(AssignListFou); */
    param.push(AssignListFif);
    var RuleData={};
    RuleData["remark"]="";
    RuleData["if"]={"and":{}};
    RuleData["then"]={"var-assign":param};
    RuleData["else"]="";
    RuleData["_name"]="rule";
    var RuleJson={};
	RuleJson["rule"]=RuleData;
	var rulejson=JSON.stringify(RuleJson);
	var node = $("#ruleTree").tree('getSelected');
	var GuideEditId=serverCall("web.DHCCKBGuideEdit","GetGuideEditId","");
	if (node==null){
		$.messager.alert("提示","请先选中目录中的规则",'warning');
		return;
		}else{
		if (node.ruleId==null){
		dicStr=drugidnew+"^"+node.id
		RuleId=0
	}else{
		var parentnode=$("#ruleTree").tree('getParent',node.target);
		dicStr=parentnode.id+"^"+drugidnew
		RuleId=node.ruleId
		}
	var data={
	   	ruleId:RuleId,
	   	status:IsEnableValue,
	   	/* json:JSON.stringify(RuleJson), */
	   	json:RuleJson,
	   	LgUserId:LgUserID,
		dicStr:dicStr,
		loginInfo:LoginInfo	
	};
	console.log(data);	
	if((WarnMessage!="")&&(LevelFlagValue!="")){
		
		/* $.post(
 		"web.DHCCKBRuleSave.cls",
   		{json:rulejson,
		 dicStr:dicStr,
		 ruleId:RuleId,
		 LgUserId:LgUserID,
		 status:IsEnableValue,
		 loginInfo:LoginInfo	
		 },function(data){
	     	if(data.code>0){
	         	$.messager.alert("提示","保存成功！"); 
	         	reloadTree();
		    }else{
		        //window._setDirty()
		        $.messager.alert("提示","保存失败！"+data.msg);
		        reloadTree() ;
			}
	},"json"); */
	
	runClassMethod("web.DHCCKBRuleSave","save",
		{"json": rulejson,
		 "dicStr":dicStr, //目录和药品ID
		 "ruleId":RuleId,
		 "LgUserId":LgUserID,
		 "status":IsEnableValue, 
		 "loginInfo":LoginInfo
		 }, function(data){
	     	if(data>0){
	         	$.messager.alert("提示","保存成功！",'success'); 
	         	reloadTree();
	         	RelodePage();
		    }else{
		        $.messager.alert("提示","保存失败！"+data,'error');
		        reloadTree() ;
		        RelodePage();
			}
	},"json");
	}else{
		$.messager.alert("提示","级别,描述不能为空",'warning');
		return;
		};	
			
	};
	
	};
}

function DeleteRule(){
	var node = $("#ruleTree").tree('getSelected');
	if(node.ruleId!=undefined){
			$.messager.confirm("提示", "您确定要删除吗？", function (res) {
				/// 提示是否删除
				if (res) {
					runClassMethod("web.DHCCKBRuleSave","RemoveRule",{"ruleId":node.ruleId},function(jsonString){
						reloadTree();
						RelodePage();
					});
				}
			})	
    }else{
		$.messager.alert("提示","请选中规则!");   
	}

}
function LoadRightValue(node){
	if(node.ruleId!=null){
		RelodePage()
		var RuleData=serverCall("web.DHCCKBGuideEdit","GetRuleData",{"RuleId":node.ruleId});	
		var RuleDataArr = RuleData.split('^');
		for (var i=0;i < RuleDataArr.length;i++){
			var RuleDet=RuleDataArr[i];
			var RuleDetArr = RuleDet.split('&');
			var RuleDetType=RuleDetArr[0];
			var RuleDetValue=RuleDetArr[1];
			var RuleDetText=RuleDetArr[2];
			if (RuleDetType=="IsEnable"){
				if (RuleDetText=="Release"){
					$HUI.combobox("#IsEnable").setValue("Release");
					$HUI.combobox("#IsEnable").setText("是");
				}else if(RuleDetText=="CancelRelease"){
					$HUI.combobox("#IsEnable").setValue("CancelRelease");
					$HUI.combobox("#IsEnable").setText("否");
					}
			}else if(RuleDetType=="LevelFlag"){
				
				$HUI.combobox("#LevelFlag").setValue(RuleDetValue);
				$HUI.combobox("#LevelFlag").setText(RuleDetText);
			}else if(RuleDetType=="KnowSource"){
				
				$HUI.combobox("#KnowSource").setValue(RuleDetValue);
				$HUI.combobox("#KnowSource").setText(RuleDetText);
			}else if(RuleDetType=="WarnMessage"){
				$("#Descript").val(RuleDetText);
				}
		}	
	}else{
		RelodePage()
		}
	
	}
function RelodePage(){
	/*
	$HUI.combobox("#IsEnable").setValue("");
	$HUI.combobox("#IsEnable").setText("");
	$HUI.combobox("#LevelFlag").setValue("");
	$HUI.combobox("#LevelFlag").setText("");
	$HUI.combobox("#KnowSource").setValue("");
	$HUI.combobox("#KnowSource").setText("");
	*/
	$("#Descript").val("");	
	$HUI.combobox("#IsEnable").setValue("Release");
	$HUI.combobox("#LevelFlag").setValue(tipsId); // 默认提示
	$HUI.combobox("#KnowSource").setValue(knowId); // 默认说明书
	$HUI.combobox("#IsEnable").setText("是");
	$HUI.combobox("#LevelFlag").setText("提示");	
	$HUI.combobox("#KnowSource").setText("药品说明书");
	}

function QueryDicList(){
	var params = $HUI.searchbox("#queryCode").getValue();
	var hospId = $HUI.combobox("#hospId").getValue();
	var existGuide = $HUI.checkbox("#existGuide").getValue(); 
	existGuide = existGuide==false?"":existGuide;
	$('#dicTable').datagrid('load',{	
		parref:parref,
		params:params,
		hospId:hospId,	
		existGuide:existGuide
		//id:DrugData,
		//parDesc:params	
	}); 
}
function QueryDicListnew(){
	var params = $HUI.searchbox("#queryCodenew").getValue()+"^"+"78200"
	var hospId = $HUI.combobox("#hospId").getValue();
	$('#comTable').datagrid('load',{
		extraAttr:"DataSource",
		parref:"78200",
		params:params,
		hospId:hospId,
		queryType:dictionType
		//id:DrugData,
		//parDesc:params	
	}); 
}
/// 重置查询条件
function ExportReset(){
	$HUI.searchbox("#queryCode").setValue("");
	$HUI.combobox("#dicType").setValue("");
	$HUI.combobox("#hospId").setValue("");
	$HUI.checkbox("#existGuide").setValue(false); 
}

/// 清屏
function ExportResetnew(){
	$HUI.searchbox("#queryCodenew").setValue("");
}

	
function dataGridDBClick(rowData){
		$("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBGuideEdit&MethodName=GetDrugLibraryTree&dic='+rowData.dicID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
}
function dataGridDBClicknew(rowData){
		$('#form-save').form('reload');
}
function reloadTree(){
	$("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBGuideEdit&MethodName=GetDrugLibraryTree&dic='+drugidnew+'&userInfo='+LoginInfo;
	$('#ruleTree').tree('reload');
	}

/// 初始化combobox
function initCombobox(){
	/// 初始化分类检索框
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        parref = option.value;
	       	QueryDicList();
	    },
		loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "西药" && data[i].text != "中成药" && data[i].text != "中药饮片"){
                        data.splice(i,1);
                        //由于splice函数将data中的某个序号的值删掉了，因此整体数组的顺序会依次向前，如果不-1,会导致部分数据未经过筛选
                        i--;
                    }
                }
                return data;
        },
       onLoadSuccess: function (data) {
	        var data = $("#dicType").combobox("getData");	// 默认选择第一个
	        if (data && data.length > 0) {
	            $("#dicType").combobox("setValue", data[0].value);
	            parref = data[0].value;	
	            //QueryDicList();            
	        }
        }
	}; 	
	var url = $URL +"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	//var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
	
	$('#IsEnable').combobox({
		valueField:'value',
		textField:'text',
		mode:'remote',
		enterNullValueClear:false,
		blurValidValue:true,
		onSelect:function(option){
		/* IsEnableValue=option.value
		IsEnableText=option.text */
		},
		onShowPanel:function(){
		var data=[{"value":"Release","text":"是"},{"value":"CancelRelease","text":"否"}];
		$('#IsEnable').combobox('loadData',data);	
		}
	})
	$('#IsEnable').combobox("setText","是"); // 默认启用
	$('#IsEnable').combobox("setValue","Release"); // 默认启用
	
	$('#LevelFlag').combobox({
		valueField:'value',
		textField:'text',
		mode:'remote',
		enterNullValueClear:false,
		blurValidValue:true,
		onSelect:function(option){
		/* LevelFlagValue=option.value;
		LevelFlagText=option.text */
		},
		onShowPanel:function(){
		var unitUrl=$URL+"?ClassName=web.DHCCKBGuideEdit&MethodName=GetLevelFlagComboxData&q="+'';
		$('#LevelFlag').combobox('reload',unitUrl);	
		}
	})	
	$('#LevelFlag').combobox("setValue",tipsId); // 默认提示
	$('#LevelFlag').combobox("setText","提示"); // 默认提示
	
	$('#KnowSource').combobox({
		valueField:'value',
		textField:'text',
		mode:'remote',
		enterNullValueClear:false,
		blurValidValue:true,
		onSelect:function(option){
		/* KnowSourceValue=option.value;
		KnowSourceText=option.text */
		},
		onShowPanel:function(){
		var unitUrl=$URL+"?ClassName=web.DHCCKBGuideEdit&MethodName=GetKnowSourceComboxData&q="+'';
		$('#KnowSource').combobox('reload',unitUrl);	
		}
	})
	$('#KnowSource').combobox("setValue",knowId); // 默认说明书
	$('#KnowSource').combobox("setText","药品说明书"); // 默认说明书
	
	// 院区
  	var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
  	$HUI.combobox("#hospId",{
	    url:uniturl,
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote'				
	})
	
}

///设置操作明细连接
function SetCellOper(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='用药指导总览' onclick=\"OpenEditWin('"+rowData.dicID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 

 return btn;  

}

// 用药指导规则汇总弹出页面
function OpenEditWin(ID){
	
	if($('#guideWin').is(":visible")){return;}  			//窗体处在打开状态,退出

	var edithtml = '<div id="guide" class="hisui-textbox" style="height: 300px;"><textarea id="editPanel" class="textbox" style="width:460px;height:290px;margin:10px 10px 10px; 10px;"></textarea></div>';
	$('body').append('<div id="guideWin">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#guideWin",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'用药指导',
        modal:true,
        width:500,
        height:400,
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
	           var msg = $("#editPanel").val();
	           if (msg != ""){
		       	  SaveGuideInfo(ID);
               	  $HUI.dialog("#guideWin").close();        
		       }else{
			   	  $.messager.alert("提示","请录入指导信息",'warning'); 
			   }
                        
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
    GetAllGuideInfo(ID);
 	//$("#editPanel").val("");
	$('#guideWin').dialog('center');
}

/// 用药指导规则信息
function GetAllGuideInfo(drugId){

	runClassMethod("web.DHCCKBGuideEdit","GetGuideInfo",{"drugId":drugId},function(jsonString){
		$("#editPanel").val(jsonString);
	},"",false);
}

/// 保存用药指导规则信息
function SaveGuideInfo(drugId){

	var msg = $("#editPanel").val();
	runClassMethod("web.DHCCKBGuideEdit","SaveGuideInfo",{"drugId":drugId,"msg":msg,"userInfo":LoginInfo,"ip":ClientIPAdd},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示","保存失败"+ret,'warning'); 
		}
	},"",false);
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
