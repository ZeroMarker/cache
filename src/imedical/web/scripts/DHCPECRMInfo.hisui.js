//����	DHCPECRMInfo.hisui.js
//����  �����Ϣ
//����	2020.03.26
//������  xy

$(function(){
	 	
	InitCRMList();
	
	//����
	$("#BSave").click(function() {	
		BSave_click();		
        });
        
    //������ 
    $("#BCrmFinish").click(function() {	
		 BCrmFinish_click();		
        }); 
        
	
})


function InitCRMList(){
	
	
	$HUI.datagrid("#CRMList",{
		url: $URL,
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���  
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"FindCRMInfo", 
			SourceID:SourceID,	
		},

		columns:[[
			{field:'TID',title:'ID',hidden: true},
			{field:'TSort',title:'Sort',hidden: true},
			{field:'TUser',width:'120',title:'�����'},
			{field:'TDate',width:'120',title:'�������'},
			{field:'TTime',width:'120',title:'���ʱ��'},
			{field:'TCRMInfo',width:'400',title:'�������'},
			{field:'delete',title:'����',width:'40',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TSourceID!=""){
					                                                                                
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="" border="0" onclick="Delete('+rowIndex+')"></a>';
			
				}
				}},	
		]]
		
		
	
	})

	
}

function  BCrmFinish_click()
{
	var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","CrmFinish",SourceID,UserID)
	if(ret=="0"){
		$.messager.alert("��ʾ","������","success");
		//$("#CRMInfoWin").window("close");
		window.parent.$("#HighRiskListGrid").datagrid("reload");
		
	} 

}
function BSave_click(){
	var UserID=session['LOGON.USERID'];
	var CRMInfo=$("#CRMInfo").val();
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveCRMInfo",SourceID,CRMInfo,UserID)
	if(ret=="0"){
		$.messager.alert("��ʾ","����ɹ�","success");
		$("#CRMList").datagrid("reload");
		
	}	
	
}

function Delete(selectrow){
	var objtbl = $("#CRMList").datagrid('getRows');
	var ID=objtbl[selectrow].TID;
	var Sort=objtbl[selectrow].TSort;
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","DeleteCRMInfo",ID+"^"+Sort)
	if(ret=="0"){
		$.messager.alert("��ʾ","ɾ���ɹ�","success");
		$("#CRMList").datagrid("reload");
		
	}	
}