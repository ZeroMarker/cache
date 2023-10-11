var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
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
					pageSize:200,  // ÿҳ��ʾ�ļ�¼����
					pageList:[200,500]   // ��������ÿҳ��¼�������б�
			})
						
		}
	);	
}


function filedFormatter(value,rowData,index){
	var dicItmID = value.split("##")[0];
	var value = value.split("##")[1];
	if(value==undefined){value="";} //hxy 2021-04-14 �ڲ�������ʱ����ʾΪ�մ���δ����
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
				$.messager.alert("��ʾ:","����ɹ�!");    
		 		return;	
			}else{
				$.messager.alert("��ʾ:","ʧ��!Code="+ret);    
		 		return;	
			}		
		}
	);	
}