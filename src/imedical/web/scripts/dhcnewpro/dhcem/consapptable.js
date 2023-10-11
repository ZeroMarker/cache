var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
$(function(){
	initParams();
	initPage();
	initTable();
})

function initParams(){
		
}

function initPage(){
	$("#appTableTitle").html(AppTableTitle);
	if(seeCstType==1){ //hxy 2021-04-12 st
		$("#columnsSaveOrderBtn").hide();
	}else{
		$("#columnsSaveOrderBtn").show();
	} //ed
	
}

function initTable(){
	runClassMethod("web.DHCEMConsAppTable","GetColumn",
		{
			TypeCode:AppTableCode,
			LgParams:LgParams
		},function(ret){
			var columns=[];
			for(var i=0;i<ret.length;i++){
				ret[i].formatter=filedFormatter;
				columns.push(ret[i])	
			}
			$('#appTable').datagrid({
					fit:true,
					fitColumns:false,
				    url:'dhcapp.broker.csp?ClassName=web.DHCEMConsAppTable&MethodName=GetData',
					columns:[columns],
					singleSelect:true,
					onBeforeLoad:function(param){
						param.TypeCode=AppTableCode;
						param.LgParams=LgParams;
						param.CstID=ID;
					},
					pagination:false,
					pageSize:200,  // 每页显示的记录条数
					pageList:[200,500]   // 可以设置每页记录条数的列表
			})
						
		}
	);	
}


function filedFormatter(value,rowData,index){
	var dicItmID = value.split("##")[0];
	var value = value.split("##")[1];
	if(value==undefined){value="";} //hxy 2021-04-14 在不够四列时，显示为空代替未定义
	var ret= "";
	if((value=="checkbox")||(value=="N")){
		ret = "<input class='dicSaveItm' data-id='"+dicItmID+"' type='checkbox' onclick='checkOneDom(this)'></input>"
	}else if(value=="Y"){
		ret = "<input class='dicSaveItm' data-id='"+dicItmID+"' type='checkbox' checked='checked' onclick='checkOneDom(this)'></input>"
	}else{
		ret = "<span class='dicSaveItm' data-id='"+dicItmID+"'>"+value+"</span";	
	}
	return ret;
}

function checkOneDom(thisDom){
	var thisCheck = $(thisDom).is(":checked");
	
	$(thisDom).parents("tr").find("input[type='checkbox']").not($(thisDom)).removeAttr("checked");
}

function saveAppTableData(){
	var saveDataArr=[];
	$(".dicSaveItm").each(function(){
		var tagName = $(this)[0].tagName;
		var dicItmID = $(this).attr("data-id");
		var dicItmValue="";
		if(tagName=="SPAN"){
			dicItmValue = $(this).html();
			saveDataArr.push(dicItmID+"##"+dicItmValue)
		}else if(tagName=="INPUT"){
			if($(this).attr("type")=="checkbox"){
				dicItmValue = $(this).is(":checked")?"Y":"N";
				saveDataArr.push(dicItmID+"##"+dicItmValue)	
			}
		}
	})
	var saveData = saveDataArr.join("^");
	
	runClassMethod("web.DHCEMConsAppTable","SaveAva",
		{
			CstID:ID,
			AvaType:SaveMode,
			SaveData:saveData
		},function(ret){
			if(ret==0){
				$.messager.alert("提示:","保存成功!");    
		 		return;	
			}else{
				$.messager.alert("提示:","失败!Code="+ret);    
		 		return;	
			}		
		}
	);	
}