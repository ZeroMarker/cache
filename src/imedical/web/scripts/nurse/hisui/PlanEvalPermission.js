/**
* HISUI ���������Ȩ������js
* PlanEvalPermission.js
* QPEvalPermission
*/
var PageLogicObj={
	m_Permission:""
}
$(window).load(function() {
	$("#loading").hide();
})
$(function(){ 
	InitHospList();
	InitEvent();	
});
function InitHospList() {
    var hospComp = GenHospComp("Nur_IP_QPCommonConfig");
    hospComp.jdata.options.onSelect = function (e, t) {
        Init();
        $('#tabPlanEvalPermissionList').datagrid('reload');
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        Init();
    }
}
function Init(){
	
	// ��ʼ��
	InitPlanEvalPermissionList();
}
function InitEvent(){
	// ��ѯ
	$("#BFind").click(function(){
	 	$("#tabPlanEvalPermissionList").datagrid("reload");
	});
	// ����
	$("#BSave").click(function(){
		var ids=[];
		var rows = $("#tabPlanEvalPermissionList").datagrid("getRows");	
		var permission = $('#tabPlanEvalPermissionList').datagrid('getSelections');
		var permissionList = ""				
		if (permission.length>0){
			permission.forEach(function(item,index){
				ids.push(item.SSUSR_RowId);				
			});
			permissionList = ids.join("^");
		}
		if ((PageLogicObj.m_Permission!="")&&(permissionList!="")&&(PageLogicObj.m_Permission!=permissionList)){				
			var ids=[];
			if (PageLogicObj.m_Permission!=""){
				// �������ǰ��Ȩ��
				ids = PageLogicObj.m_Permission.split("^")
			}
			if (rows.length>0){
				rows.forEach(function(item,index){
					if ((item.isHavePermission=="0")&&(("^"+permissionList+"^").indexOf("^"+item.SSUSR_RowId+"^") != -1 )){
						//��ѡ�е� ֱ�����
						ids.push(item.SSUSR_RowId);
					}					
					if ((item.isHavePermission=="1")&&(("^"+permissionList+"^").indexOf("^"+item.SSUSR_RowId+"^") == -1 )){
						// ȡ����ѡ�� Ҫɾ��
						ids.remove(item.SSUSR_RowId);
					}
				});
			}
			permissionList = ids.join("^");
		}
		$cm({
			ClassName: "CF.NUR.NIS.QPCommonConfig",
			MethodName: "SaveQPCCNursePlanEvalPermission",
			EvalPermission : permissionList,
			Hospital:$HUI.combogrid('#_HospList').getValue(),
		},false);
		// ˢ�±��
		InitPlanEvalPermissionList();	
	});
	// ȡ��
	//$("#BCancel").click(function(){});
	$("#BCancel").hide();
}
function InitPlanEvalPermissionList(){
	var Columns=[[ 
		{ field: 'SSUSR_RowId' , checkbox:true },
		{ field: 'SSUSR_Initials',title:'����ID',width:200},
		{ field: 'SSUSR_Name',title:'��ʿ����',width:200,wordBreak:"break-all"},
		{ field: 'CTPCP_CarPrvTp',title:'ҽ����Ա����',width:200,wordBreak:"break-all"},
    ]];
	$('#tabPlanEvalPermissionList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		shiftCheck:true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"SSUSR_RowId",
		pageSize: 50,
		pageList : [50,100,200],
		columns :Columns,
		autoRowHeight:true,
		nowrap:false,  
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QPEvalPermission&QueryName=Finduse",
		onBeforeLoad:function(param){
			$('#tabPlanEvalPermissionList').datagrid("unselectAll");
			param = $.extend(param,{Desc:$("#NurseName").val(),HOSPID:$HUI.combogrid('#_HospList').getValue(),WardID:session['LOGON.WARDID'],});
		},
		onLoadSuccess:function(data){
			$.m({
			    ClassName:"CF.NUR.NIS.QPCommonConfig",
			    MethodName:"GetQPCCNursePlanEvalPermission",
				Hospital:$HUI.combogrid('#_HospList').getValue(),
				dataType:"text"
			},function(Data){
				PageLogicObj.m_Permission=Data;
				// ������չ�ѡ��������л���
				var rows = $("#tabPlanEvalPermissionList").datagrid("getRows");
				$('#tabPlanEvalPermissionList').datagrid('uncheckAll');
				if ((Data) && (Data!="")){
					var arr = Data.split("^")
					for (var i = 0; i < arr.length; i++) {
					   if(arr[i]){
							var th =$('#tabPlanEvalPermissionList').datagrid('getRowIndex',arr[i]) //.datagrid('checkRow')
							$('#tabPlanEvalPermissionList').datagrid('checkRow',th)															
					    }
					}					
				}					
			 });
		},
	})
}
Array.prototype.indexOf = function(val) { 
    for (var i = 0; i < this.length; i++) { 
        if (this[i] == val) return i; 
    } 
    return -1; 
};
Array.prototype.remove = function(val) { 
    var index = this.indexOf(val); 
    if (index > -1) { 
        this.splice(index, 1); 
    } 
};

