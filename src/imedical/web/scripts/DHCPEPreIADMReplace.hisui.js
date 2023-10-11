
//����	DHCPEPreIADMReplace.hisui.js
//����	�����滻
//����	2020.12.16
//������  xy

$(function(){
	

	Info();

	InitPreIADMReplaceGrid();  
    
    //����
	$("#BSave").click(function() {	
		BSave_click();		
        });
	  
     $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNo_change();
			}
			
        });
 	$("#RegNo").change(function(){
            RegNo_change();
        });
  
})


function RegNo_change()
{
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var RegNo=$("#RegNo").val();
	if(RegNo==""){
		// $.messager.popover({msg: "�滻�����Ϣ����Ϊ��,�������滻�˵ĵǼǺŰ��س�", type: "info"});
		return false;
	}
	if (RegNo.length<RegNoLength && RegNo.length>0) { 
			RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
			$("#RegNo").val(RegNo)
		};
   
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",RegNo)
	
	
	var HospID=session['LOGON.HOSPID']	
	var BaseInfo=tkMakeServerCall("web.DHCPE.PreIADMReplace","GetBaseInfoByRegNo",RegNo,HospID,"0")
	var Arr=BaseInfo.split("^");
	$("#PatID").val(Arr[0]);
	$("#RegNo").val(Arr[1]);
	$("#Name").val(Arr[2]);
	if(Arr[3]==""){
		$("#Sex").val("");
	}
	if((Arr[3]!="")&&(flag!="G")){	
		$("#Sex").val(Arr[3]);
	}
	$("#Marital").val(Arr[4]);
	$("#IDCard").val(Arr[5]);
	$("#IDCardType").val(Arr[6]);

}

function BSave_click() { 
    
	var RegNo=$("#RegNo").val();
	if(RegNo==""){
		$.messager.alert("��ʾ","�滻�����Ϣ����Ϊ��,�������滻�˵ĵǼǺŰ��س�","info");
		return false;
	}
	
    var OldRegNo=$("#OldRegNo").val()
    if(OldRegNo==RegNo){
	    $.messager.alert("��ʾ","�滻��ĵǼǺ����滻ǰ�ĵǼǺ���ͬ","info");
	    return false    
    }
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",RegNo)
	if(flag=="G"){
		$.messager.alert("��ʾ","�õǼǺ�����������Ϣ,�����滻","info");
	    	return false;
		}
		
    var Remark=$("#Remark").val();
    var UserID=session['LOGON.USERID'];
    var Str=PreIADM+"^"+RegNo+"^"+Remark+"^"+UserID;
    var ret=tkMakeServerCall("web.DHCPE.PreIADMReplace","Save",Str);
    var Arr=ret.split("^");
   
     if (Arr[0]<0){
	    $.messager.alert("��ʾ",Arr[1],"info");
	    return false;
    }else{
	     $.messager.alert("��ʾ","�滻�ɹ�","success",function(){
		   //parent.document.TRAK_main.$("#tDHCPEPreIADM_Find").datagrid("reload");
		    $("#RegNo,#Name,#Sex,#Marital,#IDCard,#IDCardType").val("");
		   $("#PreIADMReplaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreIADMReplace",
			QueryName:"ReplaceListNew",
			PreIADM:PreIADM	
			
			})  
	    });
	
    }

   
}
function InitPreIADMReplaceGrid(){
	
	$HUI.datagrid("#PreIADMReplaceGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,//����Ϊ true����������ƻ�������ż��ʹ�ò�ͬ����ɫ��
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,   
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.PreIADMReplace",
			QueryName:"ReplaceListNew",
			PreIADM:PreIADM	
				
		},
		columns:[[
	

		    {field:'TUpdateDate',width:'140',title:'�滻����'},
			{field:'TUpdateTime',width:'150',title:'�滻ʱ��'},
			{field:'TUpdateUser',width:'90',title:'������'},
			{field:'TRemark',width:'80',title:'��ע'},
			{field:'TOldInfo',width:'150',title:'�滻ǰ��Ϣ'},
			{field:'TNewInfo',width:'200',title:'�滻����Ϣ'}
						
		]]
			
	})
		
}


function Info(){
	var HospID=session['LOGON.HOSPID']
	
	var BaseInfo=tkMakeServerCall("web.DHCPE.PreIADMReplace","GetPreInfo",PreIADM,HospID);
	var Arr=BaseInfo.split("^");
		
	$("#Status").val(Arr[0]);
	$("#GDesc").val(Arr[1]);
	$("#TeamDesc").val(Arr[2]);
	$("#VIPLevel").val(Arr[3]);
	$("#HPNo").val(Arr[4]);
	$("#OldPatID").val(Arr[6]);
	$("#OldRegNo").val(Arr[7]);
	$("#OldName").val(Arr[8]);
	$("#OldSex").val(Arr[9]);
	$("#OldMarital").val(Arr[10]);
	$("#OldIDCard").val(Arr[11]);
	$("#OldIDCardType").val(Arr[12]);
	
} 


