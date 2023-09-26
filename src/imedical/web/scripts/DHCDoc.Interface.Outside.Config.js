var GroupRowId="";
var arrayObj1=new Array(
      new Array("Check_UsePAPMINoToCard","UsePAPMINoToCard"),
      new Array("Check_HisCreateCardNo","HisCreateCardNo"),
	  new Array("Check_NotUseLockReg","NotUseLockReg"),
	  new Array("Check_LockNotAllowAdd","LockNotAllowAdd"),
	  new Array("Check_InsuPatSelfPayReg","InsuPatSelfPayReg"),
	  new Array("Check_AppReg","AppReg"),
	  new Array("OutRegStartTime","OutRegStartTime"),
	  new Array("OutRegEndTime","OutRegEndTime"),
	  new Array("Check_AllowRelateCard","AllowRelateCard"),
	  new Array("Check_LockUseTimeRange","LockUseTimeRange"),
	  new Array("Check_InsuReg","InsuReg"),
	  new Array("Check_UseDataCompare","UseDataCompare")
)

var arrayObj2=new Array(
  new Array("List_SelfAdmReason","SelfAdmReason"),
  new Array("List_AppRegMethod","AppRegMethod"),
  new Array("List_GetPatientIDRule","GetPatientIDRule"),
  new Array("List_BarCardType","BarCardType")
);

var arrayObj3=new Array(
  new Array("Text_LockActiveTime","LockActiveTime")
);

var arrayObj4=new Array(
  new Array("List_CardType","CardType"),
  new Array("List_IDCardType","IDCardType"),
  new Array("List_ExtUserID","ExtUserID"),
  new Array("List_AdmReason","AdmReason")
);

$(function(){ 
  /*if(GroupRowId==""){
		$.messager.alert("警告","安全组ID参数获取错误");
		return false;
	}*/
	
	$("#"+"List_SSGroup"+"").combobox({      
    	valueField:'RowId',   
    	textField:'Code',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.Interface.Outside.Config';
						param.QueryName = 'FindList';
						param.Arg1 ="SSGroup";
						param.Arg2 ="";
						param.ArgCnt =2;
		},
		//若汉字检索到完全匹配项，回车选中后不会触发onSelect事件
		/*onSelect:function(rowData){
			GroupRowId="";
			var boxvalue=$('#List_SSGroup').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				GroupRowId = $('#List_SSGroup').combobox('getValue'); 
			}else{
				$.messager.alert("警告","安全组ID参数获取错误");
				return false;	
			} 
			InitData();
		},*/
		onHidePanel:function(){
			GroupRowId="";
			var boxvalue=$('#List_SSGroup').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")&&(!isNaN(boxvalue))){
				GroupRowId = $('#List_SSGroup').combobox('getValue'); 
			}else{
				$.messager.alert("警告","安全组ID参数获取错误");
				return false;	
			} 
			InitData();
		}
	});

	 
	 //保存事件
	 $("#BSave").click(function(){
	    SaveClick();
	 });
	 
	 //保存事件
	 $("#BSaveDefault").click(function(){
	    SaveDefaultClick();
	 });
	 
	 $("#BReadMe").click(function(){
	    var url="dhcdoc.interface.outside.configexp.csp";
	    var OpenWindow=window.open(url,"弹出窗口","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width="+800+",height="+600+",top="+100+"");         
		OpenWindow.focus(); 

	 });
	 
	 InitDefaultData();
})

function InitDefaultData(){
	for( var i=0;i<arrayObj4.length;i++) {
		var param1=arrayObj4[i][0];
		var param2=arrayObj4[i][1];
		InitList1(param1,param2);	    
	}
}

function InitList1(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'RowId',   
    	textField:'Code',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.Interface.Outside.Config';
						param.QueryName = 'FindList';
						param.Arg1 =param2;
						param.Arg2 ="";
						param.ArgCnt =2;
		}  
	});	
}


function InitData(){
	if(GroupRowId==""){
		$.messager.alert("警告","安全组ID参数获取错误");
		return false;
	}
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		InitList(param1,param2);	    
	}
	//所有的checkbox radio元素初始化 
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		LoadCheckData(param1,param2);	    
	}
	//所有text元素初始化
	for( var i=0;i<arrayObj3.length;i++) {
		var param1=arrayObj3[i][0];
		var param2=arrayObj3[i][1];
		LoadTextData(param1,param2);	    
	}	
}

function LoadTextData(param1,param2)
{
	if(GroupRowId!=""){
	$.dhc.util.runServerMethod("DHCDoc.Interface.Outside.Config","getDefaultData","false",function(objScope,value,extraArg){
		$("#"+param1+"").val(objScope.result);
	},"","",GroupRowId,param2);
	}
}

function InitList(param1,param2)
{
	if(GroupRowId!=""){
		$("#"+param1+"").combobox({      
	    	valueField:'RowId',   
	    	textField:'Code',
	    	url:"./dhcdoc.cure.query.combo.easyui.csp",
	    	onBeforeLoad:function(param){
							param.ClassName = 'DHCDoc.Interface.Outside.Config';
							param.QueryName = 'FindList';
							param.Arg1 =param2;
							param.Arg2 =GroupRowId;
							param.ArgCnt =2;
			}  
		});	
	}
}

function LoadCheckData(param1,param2)
{
	if(GroupRowId!=""){
	$.dhc.util.runServerMethod("DHCDoc.Interface.Outside.Config","getDefaultData","false",function(objScope,value,extraArg){
				if((param1=="OutRegStartTime")||(param1=="OutRegEndTime")){
					$("#"+param1+"").val(objScope.result);	
				}else{
					if(objScope.result==1){
						$("#"+param1+"").attr('checked', true);
					}else{
						$("#"+param1+"").attr('checked', false);	
					}
				}
			  },"","",GroupRowId,param2);
	}
}

function SaveClick()
{
	if(GroupRowId==""){
		$.messager.alert("警告","请选择安全组");
		return false;
	}
	var DataList="";
	//所有的check radio的保存
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       var CheckedValue=0;
	       
		   if((param1=="OutRegStartTime")||(param1=="OutRegEndTime")){
			    var CheckedValue= $("#"+param1+"").val();
			    var time=/^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/ 
			    if ((CheckedValue!="")&&(time.test(CheckedValue) != true)) {
		          $.messager.alert("提示", "时间格式不正确", "error");
				  return false;
				}
		   }else{
				if ($("#"+param1+"").is(":checked")) {
	         		CheckedValue=1;
           		}   
		  }
          if(DataList=="") DataList=param2+String.fromCharCode(1)+CheckedValue;
		  else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
   }
	
	for( var i=0;i<arrayObj2.length;i++) {
		   var param1=arrayObj2[i][0];
		   var param2=arrayObj2[i][1];
	       var value=$("#"+param1+"").combobox("getValue") 
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   }
   for( var i=0;i<arrayObj3.length;i++) {
		   var param1=arrayObj3[i][0];
		   var param2=arrayObj3[i][1];
	       var value=$("#"+param1+"").val();
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   }
	$.dhc.util.runServerMethod("DHCDoc.Interface.Outside.Config","SaveConfig","false",function(value){	
       	if(value=="0"){
			 $.messager.show({title:"提示",msg:"保存成功"});	
			 return false;
		}
	},"","",DataList,GroupRowId);
	
}


function SaveDefaultClick(){
	var DataList="";
	for( var i=0;i<arrayObj4.length;i++) {
		   var param1=arrayObj4[i][0];
		   var param2=arrayObj4[i][1];
	       var value=$("#"+param1+"").combobox("getValue") 
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	//alert(DataList)
	$.dhc.util.runServerMethod("DHCExternalService.RegInterface.GetRelate","SetDefaultData","false",function(value){	
       	if(value=="0"){
			 $.messager.show({title:"提示",msg:"保存成功"});	
			 return false;
		}
	},"","",DataList);
}