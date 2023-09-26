var DescObj,NameObj,CmpDrObj,CmpNameObj,RuleObj,PageIdObj,ActiveObj,cls="websys.LogClientPage";
var DelObj,AddObj,UpObj,ClearObj;
var ctreedata;

//ɾ���¼�
var delClick = function(){
	if (PageIdObj.val()==""){
		$.messager.alert('����','����ѡ���м�¼,��ɾ��!',"warning"); return false;
	}
	$.ajaxRunServerMethod({ClassName:cls,MethodName:"Delete",Id:PageIdObj.val()},
		function(data,textStatus){
			if ("undefined" == typeof data.err){
				if (data>0){
					//$.messager.alert('�ɹ�','ɾ���������ͳɹ�!');
					$("#Clear").click();
					
				}else{
					$.messager.alert('ʧ��','ɾ����������ʧ��!<br/><br/>�������:'+data,"error");  
				}
			}else{
				$.messager.alert('ʧ��','ɾ����������ʧ��!'+data.err);  
			}
		}
	);
}
//�ǿ�У��
function saveCheck(desc,name,cmpdr,rule){
	if(desc==""){
		$.messager.alert('����','ҳ�����Ʋ���Ϊ��!',"warning"); return false;
	}
	if(name==""&cmpdr==""){
		$.messager.alert('����','����csp�������������ͬʱΪ��!',"warning"); return false;
	}
	if(rule==""){
		$.messager.alert('����','����ѡ��һ����־��¼����!',"warning"); return false;
	}
	return true;
}
//�����¼�
var upClick = function(){
	if (PageIdObj.val()==""){
		$.messager.alert('����','����ѡ��Ҫ�޸ĵ��У��ٸ���!',"warning"); return false;
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
					//$.messager.alert('�ɹ�','���³ɹ�!');
					$("#Clear").click();
					
				}else{
					$.messager.alert('ʧ��','����ʧ��!'+data);  
				}
			}else{
				$.messager.alert('ʧ��','����ʧ��!'+data.err);  
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
	
	//ҳ������������CSP�����Ϊ200��
	DescObj.css('width','200px');
	NameObj.css('width','200px');
	
	//����ajax����ͬ����ʽ����ȡ����Rule��JSON��resultת��JSON����resultJson����ȡresultJson.rows��Ȼ�󹹽�combotree������ctreedata
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
						//$.messager.alert('�ɹ�','����������ͳɹ�!');
						$("#Clear").click();
						
					}else{
						$.messager.alert('ʧ��','�����������ʧ��!'+data);  
					}
				}else{
					$.messager.alert('ʧ��','�����������ʧ��!'+data.err);  
				}
			}
		);
		
	});
	
	//�������Ӧ
	$("#twebsys_LogClientPage").datagrid({
		fit:true,
		fitColumns:true
	});
	//������¼�
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
			//�Ƴ��¼��������󶨶��
			DelObj.unbind("click",delClick).linkbutton('disable');
			UpObj.unbind("click",upClick).linkbutton('disable');
			//���
			DelObj.bind("click",delClick).linkbutton('enable');
			UpObj.bind("click",upClick).linkbutton('enable');
		}
	};
	
	
})


