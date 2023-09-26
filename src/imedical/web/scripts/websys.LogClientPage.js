var DescObj,NameObj,CmpDrObj,CmpNameObj,RuleObj,PageIdObj,ActiveObj,cls="websys.LogClientPage";
var DelObj,AddObj,UpObj,ClearObj;
var ctreedata;

//删除事件
var delClick = function(){
	if (PageIdObj.val()==""){
		$.messager.alert('警告','请先选择行记录,再删除!',"warning"); return false;
	}
	$.ajaxRunServerMethod({ClassName:cls,MethodName:"Delete",Id:PageIdObj.val()},
		function(data,textStatus){
			if ("undefined" == typeof data.err){
				if (data>0){
					//$.messager.alert('成功','删除接收类型成功!');
					$("#Clear").click();
					
				}else{
					$.messager.alert('失败','删除接收类型失败!<br/><br/>错误代码:'+data,"error");  
				}
			}else{
				$.messager.alert('失败','删除接收类型失败!'+data.err);  
			}
		}
	);
}
//非空校验
function saveCheck(desc,name,cmpdr,rule){
	if(desc==""){
		$.messager.alert('警告','页面名称不能为空!',"warning"); return false;
	}
	if(name==""&cmpdr==""){
		$.messager.alert('警告','连接csp和连接组件不能同时为空!',"warning"); return false;
	}
	if(rule==""){
		$.messager.alert('警告','至少选择一条日志记录规则!',"warning"); return false;
	}
	return true;
}
//更新事件
var upClick = function(){
	if (PageIdObj.val()==""){
		$.messager.alert('警告','请先选择要修改的行，再更新!',"warning"); return false;
	}
	var Id=PageIdObj.val();
	var PageDesc=DescObj.val();
	var PageName=NameObj.val();
	var PageCmpDr=CmpNameObj.combo('getText');	
	var PageActive="N";
	if(ActiveObj.attr("checked")){
		PageActive = "Y";	
	}
	var PageRule=RuleObj.combotree('getValues').join('^');
	if(!saveCheck(PageDesc,PageName,PageCmpDr,PageRule)){
		return false;
	}
	$.ajaxRunServerMethod({
		ClassName:cls,MethodName:"Save",
		Id:Id,
		PageDesc:PageDesc,
		PageName:PageName,
		PageCmpName:PageCmpDr,
		PageActive:PageActive,
		PageRule:PageRule
		},
		function(data,textStatus){
			if ("undefined" == typeof data.err){
				if (data>0){
					//$.messager.alert('成功','更新成功!');
					$("#Clear").click();
					
				}else{
					$.messager.alert('失败','更新失败!'+data);  
				}
			}else{
				$.messager.alert('失败','更新失败!'+data.err);  
			}
		}
	);
}

$(function(){
	DescObj=$('#PageDesc');
	NameObj=$('#PageName');
	CmpDrObj=$('#PageCmpDr');
	CmpNameObj=$('#PageCmpName');
	RuleObj=$('#PageRuleNames');
	PageIdObj=$('#PageId');
	ActiveObj=$('#PageActive');
	ActiveObj.attr("checked",true);
	
	DelObj=$('#Delete');
	DelObj.linkbutton('disable');
	AddObj=$('#Add');
	UpObj=$('#Update');
	UpObj.linkbutton('disable');
	ClearObj=$('#Clear');
	
	//页面名车和连接CSP宽度设为200；
	DescObj.css('width','200px');
	NameObj.css('width','200px');
	
	//发送ajax请求（同步方式）获取所有Rule的JSON，result转成JSON对象resultJson，获取resultJson.rows，然后构建combotree的数据ctreedata
	$.ajax({url:"jquery.easyui.querydatatrans.csp?ClassName=websys.LogClientRule&QueryName=FindIdAndText&ActiveFlag=Y&page=1&rows=999",async:false,success:function(result){
		//console.log(result);
		var resultJson=$.parseJSON(result);
		//console.log(resultJson);
		var children=resultJson.rows;
		ctreedata=[{
			"state":"open",
			"children":children
		}];
		//console.log(ctreedata);
	}});
	CmpNameObj.combogrid({
		width:200,
		delay: 500,
		panelWidth:200,
		panelHeight:310,
		mode: 'remote',
		queryParams:{ClassName:'websys.Component',QueryName: 'VBFindLE',name:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'ID',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{name:param.q});
			return true;
		},
		
		onSelect:function(rowIndex, rowData){
			if (rowIndex>-1) {
				CmpDrObj.val(rowData['ID']);
			}
			return true;
		},
		onChange:function(newValue, oldValue){
			if(!CmpNameObj.combogrid('getValue')>0){
				CmpDrObj.val("");
			}
		},
		columns: [[{field:'Name',title:'Name',align:'left',width:180},{field:'ID',title:'ID',align:'right',hidden:true,width:0}]]
		//pagination: true , 
		//pageSize: 10 
	});	
	
	RuleObj.combotree({
		width:200,
		panelWidth:200,
		panelHeight:310,
		mode: 'local',
		multiple:true,
		data:ctreedata
	});	
	
	ClearObj.click(function(){
		PageIdObj.val("");
		NameObj.val("");
		DescObj.val("");
		RuleObj.combotree('setValues',"");
		CmpNameObj.combogrid('setValue',"");
		CmpNameObj.combogrid('setText',"");
		ActiveObj.attr("checked",true);	
		CmpDrObj.val('');
		$("#Find").click();
		DelObj.unbind("click",delClick).linkbutton('disable');
		UpObj.unbind("click",upClick).linkbutton('disable');
		//console.log("#############CLEAR################");
	});
	
	//Save(Id,PageDesc, PageName, PageCmpDr, PageActive, PageRule)
	AddObj.click(function(){
		var Id="";
		var PageDesc=DescObj.val();
		var PageName=NameObj.val();
		var PageCmpDr=CmpNameObj.combo('getText')
		var PageActive="N";
		if(ActiveObj.attr("checked")){
			PageActive = "Y";	
		}
		var PageRule=RuleObj.combotree('getValues').join('^');
		if(!saveCheck(PageDesc,PageName,PageCmpDr,PageRule)){
			return false;
		}
		$.ajaxRunServerMethod({
			ClassName:cls,MethodName:"Save",
			Id:Id,
			PageDesc:PageDesc,
			PageName:PageName,
			PageCmpName:PageCmpDr,
			PageActive:PageActive,
			PageRule:PageRule
			},
			function(data,textStatus){
				if ("undefined" == typeof data.err){
					if (data>0){
						//$.messager.alert('成功','保存接收类型成功!');
						$("#Clear").click();
						
					}else{
						$.messager.alert('失败','保存接收类型失败!'+data);  
					}
				}else{
					$.messager.alert('失败','保存接收类型失败!'+data.err);  
				}
			}
		);
		
	});
	
	//宽度自适应
	$("#twebsys_LogClientPage").datagrid({
		fit:true,
		fitColumns:true
	});
	//点击行事件
	$("#twebsys_LogClientPage").datagrid("options").onClickRow = function(index,rowData){
		if (index>-1){
			PageIdObj.val(rowData["PageId"]);
			NameObj.val(rowData["PageName"]);
			DescObj.val(rowData["PageDesc"]);
			RuleObj.combotree('setValues',rowData["PageRule"].split("^"));
			CmpNameObj.combogrid('setValue',rowData["PageCmpDr"]);
			CmpNameObj.combogrid('setText',rowData["PageCmpName"]);
			CmpDrObj.val(rowData["PageCmpDr"]);
			if (rowData["PageActive"]=="Y"){
				ActiveObj.attr("checked",true);
			}else{
				ActiveObj.attr("checked",false);
			}
			//移除事件，否则会绑定多个
			DelObj.unbind("click",delClick).linkbutton('disable');
			UpObj.unbind("click",upClick).linkbutton('disable');
			//添加
			DelObj.bind("click",delClick).linkbutton('enable');
			UpObj.bind("click",upClick).linkbutton('enable');
		}
	};
	
	
})


