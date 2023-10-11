/**
 * 评估内容关联 dhchm.evaluationlink.js
 * @Author   wangguoying
 * @DateTime 2020-04-21
 */


$.extend($.fn.validatebox.defaults.rules, {
	checkOrdSetsExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCPE.HM.OrdSetsLink',MethodName:'CheckOrdSetsExist',OrdSetsDR:$("#OrdSetsDR").combogrid("getValue"),ID:$("#linkid-hidden").val()};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '套餐已存在'
	}
});



var qdetailListObj=$HUI.datagrid("#QDetailList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.Evaluation",
		QueryName:"QueryQDetail",
		EvaluationDR:$("#H_EvaluationDetail").val()
	},
	onSelect:function(rowIndex,rowData){
		if(rowIndex>-1){
			$("#detailid-hidden").val(rowData.TRowID);
			initQDetailDR(rowData.TDetailDesc);	
			$("#QDetailDR").combogrid("setValue",rowData.TDetailId);
			$("#QDetailDR").combogrid("disable");
			$("#detailtype-hidden").val(rowData.TDetailType);
			$("#Relevance").val(rowData.TScore);
			$("#Expression").val(rowData.TExpression);
			initOptionDR(rowData.TDetailId);
			optionListObj.load({
				ClassName:"web.DHCPE.HM.Evaluation",
				QueryName:"QueryQDOption",
				LinkDetailDR:rowData.TRowID
			});		
			doption_clean();
		}
	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{field:'TRowID',hidden:true,sortable:'true'},
		{field:'TDetailId',hidden:true,sortable:'true'},
		{field:'TOperation',width:60,title:'操作',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='qdetail_delete(\""+row.TRowID+"\")'>\
				<img style='padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
				</a>";
			}
                    
		},
		{field:'TDetailDesc',width:180,title:'问题内容'},
		{field:'TScore',width:60,title:'得分'},
		{field:'TExpression',width:120,title:'表达式'},
		{field:'TDetailType',width:60,title:'类型',
			formatter:function(value,row,index){
				var dispalyTxt="";
				switch (value){
					case "T":
						dispalyTxt="说明型";
						break;
					case "N":
						dispalyTxt="数值型";
						break;
					case "D":
						dispalyTxt="日期型";
						break;
					case "S":
						dispalyTxt="单选型";
						break;
					case "M":
						dispalyTxt="多选型";
						break;
				}
				return dispalyTxt;
			}                 
		},
		{field:'TDetailSex',width:60,title:'性别',
			formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='男';
               		}
                	if (value == 'F') {
                    	dispalyTxt='女';
               		}
               		if (value == 'N') {
                    	dispalyTxt='不限';
                	}
                	return dispalyTxt;
				}                  
		},
		{field:'TDetailUnit',width:60,title:'单位'},
		{field:'TDetailRemark',width:100,title:'备注'}
	]],
	onLoadSuccess : function(data){
		initOptionDR("");
	},	
	fitColumns: true,
	singleSelect:true,
	pagination:true,
	pageSize:20,
	fit:true
});

var optionListObj=$HUI.datagrid("#OptionList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.Evaluation",
		QueryName:"QueryQDOption",
		LinkDetailDR:$("#detailid-hidden").val()
	},
	onSelect:function(rowIndex,rowData){
		$("#optionid-hidden").val(rowData.TOPTID);
		$("#DOptionDR").combogrid("setValue",rowData.TOptionId);
		$("#DOptionDR").combogrid("disable");
		$("#OptionRelevance").val(rowData.TOptionRelevance);	
	},	
	columns:[[
		{field:'TOPTID',hidden:true,sortable:'true'},
		{field:'TOptionId',hidden:true,sortable:'true'},
		{field:'QDOOperation',width:60,title:'操作',align:"center",
			formatter:function(value,row,index){
				return "<a href='#' onclick='doption_delete(\""+row.TOPTID+"\")'>\
				<img style='padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
				</a>";
			}
		},
		{field:'TOptionDesc',width:200,title:'描述'},
		{field:'TOptionRelevance',width:80,title:'得分'},
		{field:'TOptionSex',width:60,title:'性别',
			formatter:function(value,row,index){
				var dispalyTxt="";
				if (value == 'M') {
                	dispalyTxt='男';
           		}
            	if (value == 'F') {
                	dispalyTxt='女';
           		}
           		if (value == 'N') {
                	dispalyTxt='不限';
            	}
            	return dispalyTxt;
			}
		}
	]],
	fitColumns:true,
	pagination:true,
	pageSize:20,
	fit:true,
	displayMsg:""
});



/**
 * [问卷基本内容查询]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_find(){
	var linkid=$("#H_EvaluationDetail").val();
	var detailid=$("#QDetailDR").combogrid("getValue");
	qdetailListObj.load({ClassName:"web.DHCPE.HM.Evaluation",QueryName:"QueryQDetail",EvaluationDR:linkid,DetailDR:detailid});
}

/**
 * [问卷基本内容保存]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_save(){
	var parrefId=$("#H_EvaluationDetail").val();
	if(parrefId==""){
		$.messager.alert("提示","评估内容不能为空！","info");
		return false;
	}
	var id=$("#detailid-hidden").val();
	var detailid=$("#QDetailDR").combogrid("getValue");
	if(detailid==""|| detailid=="undefined"){
		$.messager.alert("提示","问卷基本内容不能为空！","info");
		return false;
	}
	var detailtype=$("#detailtype-hidden").val();
	var relevance=$("#Relevance").val();
	var expression=$("#Expression").val();
	if(detailtype=="T" || detailtype=="N" || detailtype=="D"){
		if (relevance=="") {
			$.messager.alert("提示","得分必录！","info");
			return false;
		}
		if(expression==""){
			$.messager.alert("提示","表达式不能为空！","info");
			return false;
		}else{
			var IsVaild=tkMakeServerCall("web.DHCHM.QuestionDetailSet","IsValidExpression",expression)
			if(IsVaild=="0"){
				$.messager.alert("提示","无效的表达式","info");
				return;
			}
		}
	}else{
		if (relevance!="") {
			$.messager.alert("提示","选择型问题请在右侧维护得分！","info");
			return false;
		}
		if(expression!=""){
			$.messager.alert("提示","选择型问题不需要录入表达式！","info");
			return false;
		}
	}
	//ELDEvaluationDR^ELDQustionDetailDR^ELDScore^ELDExpression^ELDUpdateUserDR
	var valueStr=parrefId+"^"+detailid+"^"+relevance+"^"+expression+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","UpdateQDetail",id,valueStr);
	ret=ret.split("^");
	if(ret[0]=="-1"){
		$.messager.alert("提示","保存失败："+ret[1],"info");
		return false;
	}else{
		$.messager.alert("提示","保存成功","success");
		qdetail_clean();
		qdetailListObj.reload();
	}
}

/**
 * [选项 保存]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function doption_save(){
	var parref=$("#detailid-hidden").val();
	if(parref==""){
		$.messager.alert("提示","请先选择中间的关联问题！","info");
		return false;
	}
	var detailType=$("#detailtype-hidden").val();
	if(detailType!="M" && detailType!="S"){
		$.messager.alert("提示","非选择问题不需要维护选项！","info");
		return false;
	}
	var id=$("#optionid-hidden").val();
	var optionId=$("#DOptionDR").combogrid("getValue");
	if(optionId==""|| optionId=="undefined"){
		$.messager.alert("提示","选项不能为空！","info");
		return false;
	}
	var relevance=$("#OptionRelevance").val();
	if(relevance==""){
		$.messager.alert("提示","得分必录！","info");
		return false;
	}
	//OQDOParRef^OQDOOptionDR^OQDORelevance^OQDOUpdateUserDR
	var valueStr=parref+"^"+optionId+"^"+relevance+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","UpdateQDOption",id,valueStr);
	ret=ret.split("^");
	if(ret[0]=="-1"){
		$.messager.alert("提示","保存失败："+ret[1],"info");
		return false;
	}else{
		$.messager.alert("提示","保存成功","success");
		doption_clean();
		optionListObj.reload();
	}
}


/**
 * [删除问卷基本内容]
 * @param    {[int]}    id [关联问题ID]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_delete(id){
	$.messager.confirm("警告","删除当前记录？",function(r){
		if(r){
			var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","DeleteQDetail",id);
			ret=ret.split("^");
			if(ret[0]=="-1"){
				$.messager.alert("提示","删除失败："+ret[1],"info");
				return false;
			}else{
				$.messager.alert("提示","删除成功","success");
				qdetailListObj.reload();
				qdetail_clean();
			}
		}	
	})
}

/**
 * [选项 删除]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function doption_delete(id){
	$.messager.confirm("警告","删除当前记录？",function(r){
		if(r){
			var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","DeleteQDOption",id);
			ret=ret.split("^");
			if(ret[0]=="-1"){
				$.messager.alert("提示","删除失败："+ret[1],"info");
				return false;
			}else{
				$.messager.alert("提示","删除成功","success");
				optionListObj.reload();
				doption_clean();
			}
		}	
	});
}

/**
 * [问卷基本内容清屏]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_clean(){
	$("#detailid-hidden").val("");
	$("#QDetailDR").combogrid("setValue","");
	$("#detailtype-hidden").val("");
	$("#Relevance").val("");
	$("#Expression").val("");
	initQDetailDR("");
	//qdetailListObj.reload();
	$("#QDetailList").datagrid('load',{
			ClassName:"web.DHCPE.HM.Evaluation",
			QueryName:"QueryQDetail",
			EvaluationDR:$("#H_EvaluationDetail").val(),
			DetailDR:""
			})
}

/**
 * [选项清屏]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function doption_clean(){
	$("#optionid-hidden").val("");
	$("#DOptionDR").combogrid("setValue","");
	$("#DOptionDR").combogrid("enable");
	$("#OptionRelevance").val("");
	optionListObj.reload();
}


function initQDetailDR(detailDesc)
{
	var setsObj=$HUI.combogrid("#QDetailDR",{
		panelWidth: 380,
		idField: 'SDLQuestionsDetailDR',
        textField: 'QDDesc',
        method: 'get',
        url:$URL+'?ClassName=web.DHCHM.QuestionnaireSet&QueryName=FindQD',
        onBeforeLoad:function(param){
        	if(detailDesc!==""){
        		param.Desc = detailDesc;
        	}else{
        		param.Desc=param.q;
        	}
			
		},
		mode:'remote',
		delay:200,
        columns: [[           				            			
			{field:'QDCode',title:'编码',width:80},
			{field:'QDDesc',title:'描述',width:200},
			{field:'QDType',title:'类型',width:60,
				formatter:function(value,row,index){
				var dispalyTxt="";
				switch (value){
					case "T":
						dispalyTxt="说明型";
						break;
					case "N":
						dispalyTxt="数值型";
						break;
					case "D":
						dispalyTxt="日期型";
						break;
					case "S":
						dispalyTxt="单选型";
						break;
					case "M":
						dispalyTxt="多选型";
						break;
				}
				return dispalyTxt;
			}},
			{field:'SDLQuestionsDetailDR',title:'ID',hidden:true}
		]],
        onSelect: function (rowIndex,rowData) {
        	if(rowIndex>-1){
        		$("#detailtype-hidden").val(rowData.QDType);
        	}    					
       	},
		fitColumns: true,
		pagination:true,
		pageSize:50,
		displayMsg:''
	});
	$("#QDetailDR").combogrid("enable");
} 
function initOptionDR(detailId)
{
	var optionObj=$HUI.combogrid("#DOptionDR",{
		panelWidth: 200,
		idField: 'QDOID',
        textField: 'QDODesc',
        method: 'get',
		url:$URL+'?ClassName=web.DHCHM.QuestionDetailSet&QueryName=FindQDOption&Active=Y',
        onBeforeLoad:function(param){
        	param.ParRef=detailId;		
		},
		onSelect:function(rowIndex,rowData){
			
		},
		mode:'remote',
		delay:200,
		columns:[[
			{field:'QDOID',hidden:true,sortable:'true'},
			{field:'QDODesc',width:'140',title:'描述'},
			{field:'QDODefault',width:'40',title:'默认',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		pageSize:50,
		fit:true,
		displayMsg:""
	});
	$("#DOptionDR").combogrid("enable");
}

/**
 * [设置页面布局样式]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function setGridHeight()
{
	$(".panel-header.panel-header-gray").css("border-radius","4px 4px 0 0");//设置圆角
	$(".panel-header").css("padding","4px 5px");  //设置panel  和布局 标题高度相等

	$("#QDetailListDiv").height($("#CenterPanel").height()-186);
	qdetailListObj.resize();
	$("#OptionListDiv").height($("#EastPanel").height()-141);
	$("#OptionList").datagrid("resize");
}
function init(){
	setGridHeight();
	initQDetailDR("");
}
$(init);