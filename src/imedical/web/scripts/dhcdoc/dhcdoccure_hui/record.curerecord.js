var cureItemList;
var cureAppId="";
$(document).ready(function(){
	var DCAARowId=$('#DCAARowId').val();
	var DCRRowId=$('#DCRRowId').val();
	var OEORERowID=$('#OEORERowID').val();
	if((DCAARowId=="")&&(DCRRowId=="")&&(OEORERowID=""))return;
	InitEvent();
	PageHandle();
	CureRecordInfoLoad();
	 
});

function InitEvent(){
	$('#btnSave').click(SaveCureRecord);	
}

function PageHandle(){
	var DCRRowId=$('#DCRRowId').val();
	if(DCRRowId==""){
		var trs = $("tr[class='ifhidden']"); 
		for(i = 0; i < trs.length; i++){ 
			trs[i].style.display = "none"; //这里获取的trs[i]是DOM对象而不是jQuery对象，因此不能直接使用hide()方法 
		}
	}	
}

function InitDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"GetCurrendDateTime",
		dataType:"text"   
	},false);
    $("#DCRCureDate").datetimebox('setValue',CurDay);		
}

function CureRecordInfoLoad(){
	var DCRRowId=$('#DCRRowId').val();
	var DCAARowId=$('#DCAARowId').val();
	var OEORERowID=$('#OEORERowID').val();
	var ret="";
	if(DCRRowId!=""){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Record",
			MethodName:"GetCureRecord",
			'DCRRowId':DCRRowId,
		},function(objScope){
			if (objScope=="") return;
			SetValue(objScope);
		})
	}else if((DCAARowId!="")||(OEORERowID!="")){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Record",
			MethodName:"GetCureRecordByDCA",
			'AppArriveDR':DCAARowId,
			'SpecFlag':"",
			'OEORERowID':OEORERowID,
			'HospId':session['LOGON.HOSPID']
		},function(objScope){
			if (objScope=="") return;
			SetValue(objScope);
		})
	}
	
	
}
function SetValue(val){
	if (val=="") return;
	var TempArr=val.split("^");
	var DCRTitle=TempArr[2];
	var DCRContent=TempArr[3];
	var CreateUser=TempArr[5];
	var CreateDate=TempArr[6];
	var UpdateUser=TempArr[8];
	var UpdateDate=TempArr[9];
	var DCRCureDate=TempArr[11];
	var DCRResponse=TempArr[12];
	var DCREffect=TempArr[13];
	var DCRDoseage=TempArr[14];
	var DCRCureEndDate=TempArr[15];
	$("#DCRTitle").val(DCRTitle);
	$("#DCRContent").val(DCRContent);
	$("#CreateUser").val(CreateUser);
	$("#CreateDate").val(CreateDate);
	$("#UpdateUser").val(UpdateUser);
	$("#UpdateDate").val(UpdateDate);	
	$("#DCRCureDate").datetimebox('setValue',DCRCureDate);
	$("#DCRCureEndDate").datetimebox('setValue',DCRCureEndDate);
	$("#DCRResponse").prop("innerText",DCRResponse);	
	$("#DCREffect").prop("innerText",DCREffect);	
	$("#DCRDosage").prop("innerText",DCRDoseage);	
 	if(DCRCureDate==""){
		InitDate();
	}
}
function SaveCureRecord()
{
    var OperateType=$('#OperateType').val();;
    if(OperateType!="ZLYS"){
	   	$.messager.alert("提示","只有治疗医师才可修改治疗记录");
		return; 
	}
	var DCRRowId=$('#DCRRowId').val();
	var DCAARowId=$('#DCAARowId').val();
	var OEORERowID=$('#OEORERowID').val();
	var source=$('#source').val();
    if((DCAARowId=="")&&(DCRRowId=="")&&(OEORERowID==""))return;
    var regS = new RegExp("\\^","g");
	var DCRTitle=$("#DCRTitle").val();
	DCRTitle=DCRTitle.replace(regS,"")
	if (DCRTitle==""){
		$.messager.alert("提示","治疗标题不能为空");
		return;
	}
	var DCRContent=$("#DCRContent").val();
	DCRContent=DCRContent.replace(regS,"")
	if (DCRContent==""){
		$.messager.alert("提示","治疗记录不能为空");
		return;
	}
	var DCRCureDate=$("#DCRCureDate").datetimebox('getValue');
	if (DCRCureDate=="")
	{
		$.messager.alert("提示","治疗开始时间不能为空");
		return;
	}
	var DCRCureEndDate=$("#DCRCureEndDate").datetimebox('getValue');
	if (DCRCureEndDate=="")
	{
		$.messager.alert("提示","治疗结束时间不能为空");
		return;
	}
	var DCRDosage="";
	var DCRResponse="",DCREffect="";
	/* var DCRDosage=$("#DCRDosage").val();
	DCRDosage=DCRDosage.replace(regS,"")
	if (DCRDosage=="")
	{
		//$.messager.alert("提示","治疗参数不能为空");
		//return;
	}*/
	
	var DCRResponse=$("#DCRResponse").val();
	DCRResponse=DCRResponse.replace(regS,"")
	if (DCRResponse==""){
		$.messager.alert("提示","治疗反应不能为空");
		return;
	}
	var DCREffect=$("#DCREffect").val();
	DCREffect=DCREffect.replace(regS,"")
	if (DCREffect==""){
		$.messager.alert("提示","治疗效果不能为空");
		return;
	}
	var Para=DCRRowId+"^"+DCAARowId+"^"+DCRTitle+"^"+DCRContent+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+OEORERowID;
	var Para=Para+"^"+DCRCureDate+"^"+DCRDosage+"^"+DCRResponse+"^"+DCREffect+"^"+DCRCureEndDate;
	//alert(Para);
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Record",
		MethodName:"SaveCureRecord",
		'Para':Para,
	},function(value){
		if(value==0){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			if(source=="exec"){
				if (websys_showModal("options")) {
					if (websys_showModal("options").CallBackFunc) {
						websys_showModal("options").CallBackFunc(true);
					}else{
						websys_showModal("close");
					}
					
				}else{
					window.returnValue = true;
					window.close();	
				}
			}else{
				websys_showModal("close");
			}
		}else if(value=="100"){
			$.messager.alert('警告','保存失败,新增治疗记录,必须选择一条预约记录');
		}else if(value=="101"){
			$.messager.alert('警告','保存失败,保存失败,一个预约仅限添加一条治疗记录');
		}else if(value=="102"){
			$.messager.alert('警告','保存失败,预约记录没有对应的执行记录,不能做治疗');
			
		}else if(value=="103"){
			$.messager.alert('警告','保存失败,已取消预约的不能够添加治疗记录');
		}else if(value=="104"){
			$.messager.alert('警告','保存失败,治疗开始时间不能晚于治疗结束时间');
		}else if(value=="-303"){
			$.messager.alert('警告','保存失败,该预约记录已被执行!');
		}else{
			errmsg='保存失败'+",错误代码:"+value
			$.messager.alert('错误',errmsg);
		}
	})
}
