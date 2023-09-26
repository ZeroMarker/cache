document.body.onload=BodyLoaderHandler;
var SelectedRow = 0;
function BodyLoaderHandler() {
	var obj;
	
	//按钮 更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }

	//按钮 删除
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//清除 删除
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=ClearValue; }
	
}

function Update_click(){
	var PADMDr = document.getElementById('PADMDr');
	
	if(PADMDr){
		var DrId = PADMDr.value;
	} else {
		return false;	
	}
	
	var Type=document.getElementById('Type').value;
	DrId=DrId+"^"+Type;
	var RowId = document.getElementById('RowId').value;
	var BeginDate = document.getElementById('BeginDate').value;
	var EndDate = document.getElementById('EndDate').value;
	if(BeginDate == "" || BeginDate == null
		|| EndDate == "" || EndDate == null){
		alert("开始日期与结束日期为必填项！");
		return false;
	}
	
	/*
	if(BeginDate > EndDate){
		alert("开始日期不能晚于结束日期！");
		return false;	
	}*/
	
	var Num = document.getElementById('Num').value;
	
	if(Num.indexOf("-")<=-1){
	    alert("每日人数格式应为:例如“1-100”")
	    return false;
	    }

	if(Num.indexOf("-")>0)
	   {
		   
		   var Data=Num.split("-");
		   var reg = /^[0-9]+.?[0-9]*$/; 
		   if(!(reg.test(Data[1]))||!(reg.test(Data[0]))) 
		   {
			   alert("每日人数-前后应为数字");
			    return false; 
		   }
	   }

	if(Num == "" || Num == null || Num == undefined || Num == "-"){
		alert("人数不能为空！");
		return false;
	}
	var ins = document.getElementById('UpdateClass');
	var methodAddress;
	if(ins){
		methodAddress = ins.value;	
	} else {
		methodAddress = '';
	}
	var iRemark="";
	var obj=document.getElementById("Remark");
    if(obj){var iRemark=obj.value;}

	var rnt = cspRunServerMethod(methodAddress,DrId,RowId,BeginDate,EndDate,Num,iRemark);
	if(rnt == "1"){
		alert("与现有的主场日期有重叠，更新失败！"); 
	} else if(rnt == "2"){
		alert("服务器错误，更新失败！");
	} else if (rnt == "4"){
		alert("开始日期不能晚于结束日期，更新失败！");
	}else if (rnt == "5"){
		alert("结束时间不能大于团体的预约时间，更新失败！");
	}else if (rnt == "6"){
		alert("主场男性数量小于团体男性成员数量，更新失败！");
	}else if (rnt == "7"){
		alert("主场女性数量小于团体女性成员数量，更新失败！");
	}else if (rnt == "3"){
		alert("更新成功");
		window.location.reload();
	} 


}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEPreGADM_Home');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var obj=document.getElementById('RowId');
		if (obj){
			var SelRowObj=document.getElementById('THomeRowIDz'+selectrow);
			obj.value=SelRowObj.value;	//隐藏元素用value
		}
		
		var obj=document.getElementById('BeginDate');
		if (obj){
			var SelRowObj=document.getElementById('TDatez'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		
		var obj=document.getElementById('EndDate');
		if (obj){
			var SelRowObj=document.getElementById('TDatez'+selectrow);
			obj.value=SelRowObj.innerText;
			
		}
		
		var obj=document.getElementById('Num');
		if (obj){
			var SelRowObj=document.getElementById('TMaleNumz'+selectrow);
			obj.value=SelRowObj.innerText;
			
			var SelRowObj=document.getElementById('TFemaleNumz'+selectrow);
			obj.value=obj.value+"-"+SelRowObj.innerText;
		}
			var obj=document.getElementById('Remark');
			if (obj){
			var SelRowObj=document.getElementById('TRemarkz'+selectrow);
			obj.value=SelRowObj.innerText;

		}

		
	}else{
		SelectedRow=0;
		ClearValue();
	}
	
}

function Delete_click(){
	var RowId = document.getElementById('RowId').value;
	if(RowId == null || RowId=="" || RowId==undefined){
		alert("请选择数据");
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
		alert("数据不存在，删除失败");	
	} else if(rnt == "2"){
		alert("服务器错误，删除失败");
	} else if (rnt == "3"){
		alert("删除成功");
		window.location.reload();
	}
}

function ClearValue(){
	var obj=document.getElementById('RowId');
	if(obj){obj.value="";}
	var obj=document.getElementById('BeginDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('EndDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('Num');
	if(obj){obj.value="";}
	var obj=document.getElementById('Remark');
	if(obj){obj.value="";}

}