
//����	DHCPEAdvancePayMentReplace.hisui.js
//����	������Ϣ�޸�
//����	2022.12.28
//������  ln

$(function(){
	

	Info();

	InitAPReplaceGrid();  
    
    //����
	$("#BSave").click(function() {	
		BSave_click();		
        });
	  
})


function BSave_click() { 
    
    var Name=$("#Name").val();
    var Sex=$("#Sex").val();
    var Tel=$("#Tel").val();
    var EndLineDate=$("#EndLineDate").datebox('getValue');
    var IDCard=$("#IDCard").val();
    var Rebate=$("#Rebate").val();
    var Remark=$("#Remark").val();
    if((Name=="")&&(Sex=="")&&(Tel=="")&&(EndLineDate=="")&&(IDCard=="")&&(Rebate=="")){
	    $.messager.alert("��ʾ","�滻��Ϣ����ȫ��Ϊ��","info");
	    return false;
    }
    var UserID=session['LOGON.USERID'];
    var Str=APRowID+"^"+Name+"^"+Sex+"^"+Tel+"^"+EndLineDate+"^"+IDCard+"^"+Rebate+"^"+Remark+"^"+UserID;
    var ret=tkMakeServerCall("web.DHCPE.AdvancePaymentReplace","Save",Str);
    var Arr=ret.split("^");
   
     if (Arr[0]<0){
	    $.messager.alert("��ʾ",Arr[1],"info");
	    return false;
    }else{
	     $.messager.alert("��ʾ","�滻�ɹ�","success",function(){
		    $("#EndLineDate").datebox('setValue');
		    $("#Name,#Sex,#Tel,#IDCard,#Rebate,#Remark").val("");
		   $("#APReplaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreIBaseInfo",
			QueryName:"SearchPreIBModifyRecord",
			SourceType:"ADVANCEPAYMENT",
			SourceID:APRowID
			
			})  
	    });
	
    }

   
}
function InitAPReplaceGrid(){
	
	$HUI.datagrid("#APReplaceGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,//����Ϊ true����������ƻ�������ż��ʹ�ò�ͬ����ɫ��
		fitColumns : true,
		nowrap:false,  /*�˴�Ϊfalse*/
		rownumbers:true,
		pagination : true,   
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.PreIBaseInfo",
			QueryName:"SearchPreIBModifyRecord",
			SourceType:"ADVANCEPAYMENT",
			SourceID:APRowID	
				
		},
		columns:[[
	

		    {field:'Date',width:'100',title:'�滻����'},
			{field:'Time',width:'100',title:'�滻ʱ��'},
			{field:'User',width:'90',title:'������'},
			{field:'OldInfo',width:'250',title:'�滻ǰ��Ϣ'},
			{field:'NewInfo',width:'300',title:'�滻����Ϣ'}
						
		]]
			
	})
		
}


function Info(){
	var HospID=session['LOGON.HOSPID']
	
	var BaseInfo=tkMakeServerCall("web.DHCPE.AdvancePaymentReplace","GetPreInfo",APRowID);
	var Arr=BaseInfo.split("^");
		
	$("#OldCardNo").val(Arr[0]);
	$("#OldName").val(Arr[1]);
	$("#OldSex").val(Arr[2]);
	$("#OldTel").val(Arr[3]);
	$("#OldEndLineDate").val(Arr[4]);
	$("#OldIDCard").val(Arr[5]);
	$("#OldRebate").val(Arr[6]);
	
} 


