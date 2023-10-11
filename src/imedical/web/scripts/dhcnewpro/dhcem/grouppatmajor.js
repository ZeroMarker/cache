///Creator:hxy
///Date:2019-10-19
var PatientID=""
var DateFormat=""
$(function(){
	
	initParams();
	
	clearForm();
		
	initMethod();
	
	QueryGroupHurt();   // 默认查询一次

    $("#GroupPatGrid").datagrid('loadData',{ "total":"0",rows:[]});

})

function initMethod(){
	//重大事件按事件查找 
	$('#QueryGroupHurt').bind("click",QueryGroupHurt);  
	
	$("#GroupHurtStDate,#GroupHurtEndDate").datebox("setValue",formatDate(new Date())); //hxy 2020-03-05
	//日期控制 //hxy 2020-03-04 st
	$('#GroupHurtDate').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	$('#GroupReportTime').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	var now = new Date();
    var MaxTime= now.getHours()+':'+(now.getMinutes()+1);
    $('#GroupHurtDate').datetimebox('spinner').timespinner({
	    max: MaxTime
	});
	$('#GroupReportTime').datetimebox('spinner').timespinner({
	    max: MaxTime
	}); //ed
}

/// 群伤病人查询 lp 18-1-22
function QueryGroupHurt(){
	var GroupHurtStDate=$('#GroupHurtStDate').combobox('getValue');
	var GroupHurtEndDate=$('#GroupHurtEndDate').combobox('getValue');
	var params=GroupHurtStDate+"^"+GroupHurtEndDate+"^"+LgHospID;
	$('#GroupGrid').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMGroupPatMajor&MethodName=ListGroupHurt',	
		queryParams:{
			params:params}
	});	
	clearForm();
   
}

/// 事件患者关联
function LinkPat(){
	var row = $('#GroupGrid').datagrid('getSelected');
	if(!row){
		$.messager.alert('提示：','请选择关联的事件！');	
		return;
	}
	if(PatientID==""){
		$.messager.alert('提示：','未带入患者，请在患者列表选择！');	
		return;
	}
	var GroupID=row.ID;
	var params=PatientID+"^"+GroupID;
	
	runClassMethod("web.DHCEMGroupPatMajor","LinkPat",{"params":params},function(data){
		if(data<0){
			$.messager.alert('提示：','关联失败！');
			return;		
		}else if(data==1){ //hxy 2020-03-06
			$.messager.alert('提示：','已关联！');
			return;
		}else{	
			$.messager.alert('提示：','关联成功！');
			$("#GroupPatGrid").datagrid('reload') //hxy 2020-02-25
		}
	})
}

///初始化参数
function initParams(){
	DateFormat = "";
	runClassMethod("web.DHCEMRegister","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
	},"text",false)
	PatientID = getParam("PatientID");   /// 病人ID
	runClassMethod("web.DHCEMGroupPatMajor","GetInfo",{"PatientID":PatientID},function(data){
		$("#MajorName").text(data.split("^")[0]);
		$("#MajorNo").text(data.split("^")[1]);		
	},"text",false)	
}

/// 格式化日期  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}

/// form清除
function clearForm(){
	$("input[type='checkbox'][name$='GroupReportFor']").radio('setValue',false);
	$('#formMes').form("clear");
	runClassMethod("web.DHCEMGroupPatMajor","GetTrsUser",{"LgUserName":LgUserName},function(data){
		$("#GroupReportUser").val(data);
	},"text",false)	
	//$("#GroupReportUser").val(LgUserName);
	//$("input[type='checkbox'][name$='GroupReportFor']").radio('setValue',false);
	//$('.hisui-radio').not("input[type='radio'][name$='Flag']").radio('setValue',false)
}
// 保存
function submitForm(){
	var params="";
	var	GroupHurtDate=$('#GroupHurtDate').datetimebox('getValue');
	if(GroupHurtDate==""){
		$.messager.alert('提示：','请录入事件时间！');
		return;	
	}
	var	GroupHurtSite=$('#GroupHurtSite').val();
	var	GroupHurtDesc=$('#GroupHurtDesc').val();
	if(GroupHurtDesc==""){
		$.messager.alert('提示：','请录入事件描述！');
		return;	
	}
	var GroupReportFor="";
	/// 汇报对象
	var ReportForArr = [];
	$('input[name="GroupReportFor"]:checked').each(function(){
		ReportForArr.push(this.value);
	})

	var GroupReportFor = ReportForArr.join("@");
	var GroupReportUserID=LgUserID;
	var GroupReportTime=$('#GroupReportTime').datetimebox('getValue');
	var RowId=$('#RowId').val();
	params=GroupHurtDate+"^"+GroupHurtSite+"^"+GroupHurtDesc+"^"+GroupReportFor+"^"+GroupReportUserID+"^"+GroupReportTime+"^"+LgHospID+"^Major^"+RowId;
	//return GroupHurtDate+"^"+encodeURIComponent(GroupHurtSite)+"^"+encodeURIComponent(GroupHurtDesc)+"^"+encodeURIComponent(GroupReportFor)+"^"+GroupReportUserID+"^"+GroupReportTime+"^"+LgHospID+"^Major^"+RowId;

	 //alert(params)
	 runClassMethod("web.DHCEMGroupPatMajor","SavePatGroupHurt",{"params":params},function(data){
	  	if (data == 0) { 
           	$.messager.alert("提示","保存成功!");
            $('#GroupGrid').datagrid('reload');  // 重新载入当前页面数据 
            clearForm(); 
          }else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#GroupGrid").datagrid('reload')
		  }else{	
				$.messager.alert('提示','保存失败:'+data)
				//clearForm();
		  }
	},'text')

}

//单击显示左侧
function onClickRow(index,row){
	clearForm();
	var row = $('#GroupGrid').datagrid('getSelected');
	if(!row){
		return;	
	}
	$('#RowId').val(row.ID);
	$('#GroupHurtDate').datetimebox('setValue',row.GHUDateAndTime);
	$('#GroupHurtSite').val(row.GHUSite);
	$('#GroupHurtDesc').val(row.GHUDetailSpec);
	//alert(row.GHUReportFor)
	var ForArr = row.GHUReportFor.split("@");
	for(var i=0;i<ForArr.length;i++){
		$HUI.radio('input[name="GroupReportFor"][value="'+ ForArr[i] +'"]').setValue(true);
	}
	$('#GroupReportUserID').val(row.GHUReportUserDr);
	$('#GroupReportUser').val(row.GHUReportUser);
	$('#GroupReportTime').datetimebox('setValue',row.GHUReportTime);
	
	var params=row.ID;
	$('#GroupPatGrid').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMGroupPatMajor&MethodName=QueryGroupHurt',	
		queryParams:{
			params:params}
	});	
}

/// 事件患者取消关联
function CanLinkPat(){
	var row = $('#GroupPatGrid').datagrid('getSelected');
	if(!row){
		$.messager.alert('提示：','请选择取消关联的患者！');	
		return;
	}
	var ID=row.ID;
	$.messager.confirm('提示', '确定该患者取消关联吗?', function(result){  
    	if(result) {
        	runClassMethod("web.DHCEMGroupPatMajor","CanLinkPat",{"ID":ID},function(data){
				if(data<0){
					$.messager.alert('提示：','取消关联失败！');
					return;
				}else{	
					$.messager.alert('提示：','取消关联成功！');
					$("#GroupPatGrid").datagrid('reload');
				}
			})
        }else{
	    }
	})
}



