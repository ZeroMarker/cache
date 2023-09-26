
//名称	DHCPEPreGADM.Home.js
//功能	主场设置
//组件	DHCPEPreGADM.Home	
//创建	2018.09.04
//创建人  xy

document.body.onload=BodyLoaderHandler;
function BodyLoaderHandler() {
	var obj;
	
	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }

	//删除
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//清屏 
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=ClearValue; }
	
}

function Update_click(){
	var DrId=getValueById("PGADMDr");
	if(DrId==""){
		return false;
		}
	
	
	var Type=getValueById("Type");
	DrId=DrId+"^"+Type;
	var iRemark=getValueById("Remark");
	var RowId=getValueById("RowId");
	var BeginDate=getValueById("BeginDate");
	var EndDate=getValueById("EndDate");
	if(BeginDate == "" || BeginDate == null
		|| EndDate == "" || EndDate == null){
		$.messager.alert("提示","开始日期与结束日期为必填项！","info");
		return false;
	}
	var BeginDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",BeginDate);
	var EndDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate);
	if(Type=="C"){
		var value=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",getValueById("PGADMDr"));
		var SighDate=value.split("^")[3];
		 if(SighDate!=""){var SighDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",SighDate);}
		 if(BeginDateLogical<SighDate){
			$.messager.alert("提示","开始日期不能小于合同签订日期","info");
			return false;
		}
   }

    if(EndDateLogical<SighDate){
	   $.messager.alert("提示","结束日期不能小于合同签订日期","info");
	    return false;
   }
	var Num=getValueById("Num");
	if(Num.indexOf("-")<=-1){
		$.messager.alert("提示","每日人数格式应为“每日人数(男)-每日人数(女)”:例如“10-10”","info");
	    return false;
	    }

	if(Num.indexOf("-")>=0)
	   {
		   
		   var Data=Num.split("-");
			if((Data[0]=="")||(Data[1]=="")){
			    $.messager.alert("提示","每日人数-前后应为数字","info");
			    return false;
		   }
		   
		   var reg = /^[0-9]+.?[0-9]*$/; 
		   if(!(reg.test(Data[1]))||!(reg.test(Data[0]))) 
		   {
			   $.messager.alert("提示","每日人数-前后应为数字","info");
			    return false; 
		   }
	   }

	if(Num == "" || Num == null || Num == undefined || Num == "-"){
		$.messager.alert("提示","人数不能为空！","info");
		return false;
	}
	var ins = document.getElementById('UpdateClass');
	var methodAddress;
	if(ins){
		methodAddress = ins.value;	
	} else {
		methodAddress = '';
	}
     
     //alert(DrId+"^"+RowId+"^"+BeginDate+"^"+EndDate+"^"+Num+"^"+iRemark)
	var rnt = cspRunServerMethod(methodAddress,DrId,RowId,BeginDate,EndDate,Num,iRemark);
	if(rnt == "1"){
		$.messager.alert("提示","与现有的主场日期有重叠，更新失败！","info");
	} else if(rnt == "2"){
		$.messager.alert("提示","服务器错误，更新失败！","info");
	} else if (rnt == "4"){
		$.messager.alert("提示","开始日期不能晚于结束日期，更新失败！","info");
	}else if (rnt == "5"){
		$.messager.alert("提示","结束日期不能大于团体的预约时间，更新失败！","info");
	}else if (rnt == "8"){
		$.messager.alert("提示","开始日期不能小于团体的预约时间，更新失败！","info");
	}else if (rnt == "6"){
		$.messager.alert("提示","主场男性数量小于团体男性成员数量，更新失败！","info");
	}else if (rnt == "7"){
		$.messager.alert("提示","主场女性数量小于团体女性成员数量，更新失败！","info");
	}else if (rnt == "3"){
		$.messager.alert("提示","更新成功","success");
		$("#tDHCPEPreGADM_Home").datagrid('load',{ComponentID:56439,PGADMDr:$("#PGADMDr").val(),Type:$("#Type").val()});
		//window.location.reload();
	} 


}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{
		var HomeRowID=rowdata.THomeRowID;
	    setValueById("RowId",HomeRowID);
	    
		var Date=rowdata.TDate;
		setValueById("BeginDate",Date);
		
		var Date=rowdata.TDate;
		setValueById("EndDate",Date);
		
		var MaleNum=rowdata.TMaleNum;
		var FemaleNum=rowdata.TFemaleNum;
		var num=MaleNum+"-"+FemaleNum;
		setValueById("Num",num);
		
	   var Remark=rowdata.TRemark;
	   setValueById("Remark",Remark);
				
	}else
	{
		selectrow=-1;
		ClearValue();
	
	}	

}


/*
function Delete_click(){
	var RowId = document.getElementById('RowId').value;
	if(RowId == null || RowId=="" || RowId==undefined){
		$.messager.alert("提示","请选择待删除的数据","info");
		return false;	
	}
	var ins = document.getElementById('DeleteClass');
	var methodAddress;
	if(ins){
		methodAddress = ins.value;	
	} else {
		methodAddress = '';
	}
	var rnt = cspRunServerMethod(methodAddress,RowId);
	if(rnt == "1"){
		$.messager.alert("提示","数据不存在，删除失败","info");	
	} else if(rnt == "2"){
		$.messager.alert("提示","服务器错误，删除失败","info");
	} else if (rnt == "3"){
		$.messager.alert("提示","删除成功","success");
		window.location.reload();
	}
}
*/
function Delete_click(){
	var RowId = document.getElementById('RowId').value;
	if(RowId == null || RowId=="" || RowId==undefined){
		$.messager.alert("提示","请选择待删除的数据","info");
		return false;	
	}
	
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.PreHome", MethodName:"DeleteMethod",RowId:RowId},function(ReturnValue){
				if (ReturnValue=='1') {
					$.messager.alert("提示","数据不存在，删除失败","error");  
				}else if((ReturnValue=='2')){
					$.messager.alert("提示","服务器错误，删除失败","error"); 
				}else if((ReturnValue=='3')){
					$.messager.alert("提示","删除成功","success"); 
					 $("#tDHCPEPreGADM_Home").datagrid('load',{ComponentID:56439,PGADMDr:$("#PGADMDr").val(),Type:$("#Type").val()}); 
					 $("#RowId").val("");
					  ClearValue()
					
				}
			});	
		}
	});
	
}
function ClearValue(){
	   setValueById("RowId","");
	   setValueById("BeginDate","");
	   setValueById("EndDate","");
	   setValueById("Num","");
	   setValueById("Remark","");
	

}