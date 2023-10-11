/**
 * 套餐关联维护  dhchm.ordsetslink.js
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


var sexObj=$HUI.combobox("#SexDR",{
	url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
	valueField:'id',
	textField:'sex'
});
var maritalObj=$HUI.combobox("#MaritalDR",{
	url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
	valueField:'id',
	textField:'married'
});
var ordsetsListObj=$HUI.datagrid("#OrdSetsList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.OrdSetsLink",
		QueryName:"QueryLinkOrdSets",
		LocID: session["LOGON.CTLOCID"]
	},
	onSelect:function(rowIndex,rowData){
		if(rowIndex>-1){
			linkordsets_clean();
			$("#linkid-hidden").val(rowData.TID);
			initOrdSetsDR(rowData.TOrdSetsDesc);
			$("#OrdSetsDR").combogrid("setValue",rowData.TOrdSetsId);
			$("#OrdSetsDR").combogrid("disable");
			$("#SexDR").combobox("setValue",rowData.TSexId);
			$("#MaritalDR").combobox("setValue",rowData.TMaritalId);
			$("#MinAge").val(rowData.TMinAge);
			$("#MaxAge").val(rowData.TMaxAge);
			if(rowData.TOrdSetsType=="A"){
				$("#add_ordsets").radio("check");
			}else{
				$("#main_ordsets").radio("check");
			}
			qdetail_clean();
			qdetail_find();	
			doption_clean();
			optionListObj.load({
				ClassName:"web.DHCPE.HM.OrdSetsLink",
				QueryName:"QueryQDOption",
				LinkDetailDR:""
			});	
		}
	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{field:'TID',hidden:true,sortable:'true'},
		{field:'TOrdSetsId',hidden:true,sortable:'true'},
		{field:'TSexId',hidden:true,sortable:'true'},
		{field:'TMinAge',hidden:true,sortable:'true'},
		{field:'TMaxAge',hidden:true,sortable:'true'},
		{field:'TMaritalId',hidden:true,sortable:'true'},
		{field:'TOperation',width:60,title:'操作',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='linkordsets_delete(\""+row.TID+"\")'>\
				<img style='padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
                    
		},
		{field:'TOrdSetsDesc',width:180,title:'套餐名称'},
		{field:'TSexDesc',width:60,title:'性别'},
		{field:'TAgeRange',width:80,title:'年龄范围',align:'center',
			formatter:function(value,row,index){
				if((row.TMinAge=="")&&(row.TMaxAge=="")){
					return "";
				}else{
					return row.TMinAge+"-"+row.TMaxAge;
				}
			}                   
		},
		{field:'TMaritalDesc',width:80,title:'婚姻状况'},
		{field:'TOrdSetsType',width:80,title:'类型',
			formatter:function(value,row,index){
				var dispalyTxt="";
				if (value == 'M') {
                	dispalyTxt='主套餐';
           		}
            	if (value == 'A') {
                	dispalyTxt='加项包';
           		}
            	return dispalyTxt;
			}
		}
	]],
	fitColumns: true,
	singleSelect:true,
	pagination:true,
	pageSize:20,
	fit:true
});

var qdetailListObj=$HUI.datagrid("#QDetailList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.OrdSetsLink",
		QueryName:"QueryQDetail",
		LinkDR:$("#linkid-hidden").val()
	},
	onSelect:function(rowIndex,rowData){
		if(rowIndex>-1){
			$("#detailid-hidden").val(rowData.TOQDID);
			initQDetailDR(rowData.TDetailDesc);	
			$("#QDetailDR").combogrid("setValue",rowData.TDetailId);
			$("#QDetailDR").combogrid("disable");
			$("#detailtype-hidden").val(rowData.TDetailType);
			$("#Relevance").val(rowData.TRelevance);
			$("#Expression").val(rowData.TExpression);
			initOptionDR(rowData.TDetailId);
			optionListObj.load({
				ClassName:"web.DHCPE.HM.OrdSetsLink",
				QueryName:"QueryQDOption",
				LinkDetailDR:rowData.TOQDID
			});		
			doption_clean();
		}
	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{field:'TOQDID',hidden:true,sortable:'true'},
		{field:'TDetailId',hidden:true,sortable:'true'},
		{field:'TOperation',width:60,title:'操作',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='qdetail_delete(\""+row.TOQDID+"\")'>\
				<img style='padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
                    
		},
		{field:'TDetailDesc',width:180,title:'问题内容'},
		{field:'TRelevance',width:60,title:'关联度'},
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
	fitColumns: true,
	singleSelect:true,
	pagination:true,
	pageSize:20,
	fit:true
});

var optionListObj=$HUI.datagrid("#OptionList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.OrdSetsLink",
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
				<img style='padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
		},
		{field:'TOptionDesc',width:200,title:'描述'},
		{field:'TOptionRelevance',width:80,title:'关联度'},
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
 * [关联套餐查询]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function linkordsets_find(){
	var ordsetsid=$("#OrdSetsDR").combogrid("getValue");
	var sexid=$("#SexDR").combobox("getValue");
	var maritalid= $("#MaritalDR").combobox("getValue");
	var minage=$("#MinAge").val();
	var maxAge=$("#MaxAge").val();
	ordsetsListObj.load({ClassName:"web.DHCPE.HM.OrdSetsLink",QueryName:"QueryLinkOrdSets",OrdSetsDR:ordsetsid,SexDR:sexid,MaritalDR:maritalid,LocID: session["LOGON.CTLOCID"]});
}

/**
 * [问卷基本内容查询]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_find(){
	var linkid=$("#linkid-hidden").val();
	var detailid=$("#QDetailDR").combogrid("getValue");
	qdetailListObj.load({ClassName:"web.DHCPE.HM.OrdSetsLink",QueryName:"QueryQDetail",LinkDR:linkid,DetailDR:detailid});
}

/**
 * [关联套餐保存]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function linkordsets_save(){
	var id=$("#linkid-hidden").val();
	var ordsetsid=$("#OrdSetsDR").combogrid("getValue");
	if(ordsetsid==""|| ordsetsid=="undefined"){
		$.messager.alert("提示","套餐不能为空！","info");
		return false;
	}
	if(!$("#OrdSetsDR").combogrid("isValid")){
		$.messager.alert("提示","套餐已存在","info");
		return false;
	}
	var sexid=$("#SexDR").combobox("getValue");
	var maritalid= $("#MaritalDR").combobox("getValue");
	var minage=$("#MinAge").val();
	var maxAge=$("#MaxAge").val();
	if(minage>maxAge){
		$.messager.alert("提示","年龄范围有误！","info");
		return false;
	}

	var setsTypeObj = $("input[name='OrdSetsType']:checked");
	var setsType=setsTypeObj.val();
	if(setsType==""){
		$.messager.alert("提示","套餐类型不能为空","info");
		return false;
	}

	//"OLOrdSetsDR^OLSexDR^OLMinAge^OLMaxAge^OLMaritalDR^OLOrdSetsType^OLUpdateUserDR^OLTUpdateDate^OLUpdateTime"
	var valueStr=ordsetsid+"^"+sexid+"^"+minage+"^"+maxAge+"^"+maritalid+"^"+setsType+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","UpdateLinkOrdSets",id,valueStr,session["LOGON.CTLOCID"]);
	ret=ret.split("^");
	if(parseInt(ret[0])<0){
		$.messager.alert("提示","保存失败："+ret[1],"info");
		return false;
	}else{
		$.messager.alert("提示","保存成功","success");
		linkordsets_clean();
		ordsetsListObj.reload();
	}
	
}

/**
 * [问卷基本内容保存]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_save(){
	var linkId=$("#linkid-hidden").val();
	if(linkId==""){
		$.messager.alert("提示","请先选择左侧关联套餐！","info");
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
			$.messager.alert("提示","关联度必录！","info");
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
			$.messager.alert("提示","选择型问题请在右侧维护关联度！","info");
			return false;
		}
		if(expression!=""){
			$.messager.alert("提示","选择型问题不需要录入表达式！","info");
			return false;
		}
	}
	//OQDParRef^OQDDeatilDR^OQDRelevance^OQDExpression^OQDUpdateUserDR
	var valueStr=linkId+"^"+detailid+"^"+relevance+"^"+expression+"^"+session["LOGON.USERID"];
	//alert(valueStr);
	var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","UpdateQDetail",id,valueStr);
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
		$.messager.alert("提示","关联度必录！","info");
		return false;
	}
	//OQDOParRef^OQDOOptionDR^OQDORelevance^OQDOUpdateUserDR
	var valueStr=parref+"^"+optionId+"^"+relevance+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","UpdateQDOption",id,valueStr);
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
 * [关联套餐删除]
 * @param    {[int]}    id [关联ID]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function linkordsets_delete(id){
	$.messager.confirm("警告","删除当前关联套餐？",function(r){
		if(r){
			var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","DeleteLinkOrdSets",id);
			ret=ret.split("^");
			if(ret[0]=="-1"){
				$.messager.alert("提示","删除失败："+ret[1],"info");
				return false;
			}else{
				$.messager.alert("提示","删除成功","success");
				ordsetsListObj.reload();
			}
		}	
	});
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
			var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","DeleteQDetail",id);
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
			var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","DeleteQDOption",id);
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
 * [关联套餐清屏]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function linkordsets_clean(){
	$("#OrdSetsDR").combogrid("setValue","");
	$("#SexDR").combobox("setValue","");
	$("#MaritalDR").combobox("setValue","");
	$("#MinAge").val("");
	$("#MaxAge").val("");
	$("#linkid-hidden").val("");
	var setsTypeObj = $("input[name='OrdSetsType']:checked");
	setsTypeObj.radio("uncheck");
	$("#main_ordsets").radio("check");
	initOrdSetsDR("");
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

}

/**
 * [初始化套餐下拉表格]
 * @param    {[string]}    desc [套餐描述]
 * @Author   wangguoying
 * @DateTime 2020-04-21
 */
function initOrdSetsDR(desc)
{
	var setsObj=$HUI.combogrid("#OrdSetsDR",{
		panelWidth: 380,
		idField: 'OrderSetId',
		textField: 'OrderSetDesc',
		method: 'get',
		url:$URL+'?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet',
		onBeforeLoad:function(param){
    		param.Type='ItemSet';
			param.BType="B";
            param.LocID=session['LOGON.CTLOCID'];
            param.hospId=session['LOGON.HOSPID'];
            param.UserID=session['LOGON.USERID'];
    		if(desc!="") param.OrdSetSDesc=desc;
			else param.OrdSetSDesc = param.q;
		},
		mode:'remote',
		delay:200,
		columns: [[           				            			
			{field:'OrderSetDesc',title:'套餐名称',width:200},
			{field:'OrderSetPrice',title:'金额',align:'right',width:70},
			{field:'OrderSetId',title:'ID',width:80}
		]],
		fitColumns: true,
		pagination:true,
		pageSize:50,
		displayMsg:''
	});
	$("#OrdSetsDR").combogrid("enable");
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
		url:$URL+'?ClassName=web.DHCHM.QuestionDetailSet&QueryName=FindQDOption',
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
	$("#OrdSetsListDiv").height($("#WestPanel").height()-211);
	$("#OrdSetsList").datagrid("resize");
	$("#QDetailListDiv").height($("#CenterPanel").height()-186);
	qdetailListObj.resize();
	$("#OptionListDiv").height($("#EastPanel").height()-141);
	$("#OptionList").datagrid("resize");
}
function init(){
	setGridHeight();
	initOrdSetsDR("");
	initQDetailDR("");
}
$(init);