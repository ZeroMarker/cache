
//名称	DHCPEAdvancePayMentReplace.hisui.js
//功能	基本信息修改
//创建	2022.12.28
//创建人  ln

$(function(){
	

	Info();

	InitAPReplaceGrid();  
    
    //保存
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
	    $.messager.alert("提示","替换信息不能全部为空","info");
	    return false;
    }
    var UserID=session['LOGON.USERID'];
    var Str=APRowID+"^"+Name+"^"+Sex+"^"+Tel+"^"+EndLineDate+"^"+IDCard+"^"+Rebate+"^"+Remark+"^"+UserID;
    var ret=tkMakeServerCall("web.DHCPE.AdvancePaymentReplace","Save",Str);
    var Arr=ret.split("^");
   
     if (Arr[0]<0){
	    $.messager.alert("提示",Arr[1],"info");
	    return false;
    }else{
	     $.messager.alert("提示","替换成功","success",function(){
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
		striped : false,//设置为 true，则把行条纹化（即奇偶行使用不同背景色）
		fitColumns : true,
		nowrap:false,  /*此处为false*/
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
	

		    {field:'Date',width:'100',title:'替换日期'},
			{field:'Time',width:'100',title:'替换时间'},
			{field:'User',width:'90',title:'操作人'},
			{field:'OldInfo',width:'250',title:'替换前信息'},
			{field:'NewInfo',width:'300',title:'替换后信息'}
						
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


