///CreatDate:  2019-03-16
///Author:     yangyongtao
/// pay.advoayass.js 
var PayFlag=""
$(function(){
	initCombox();
	initBtn();
	GetLgContent();
	initDefaultValue();
	GetCurrDate();
	PayFlag=getParam("PayFlag"); //预交金标识
	//searchAction();
	setTimeout('searchAction()',500)
});


function initCombox(){
	
	//评估科室
	$HUI.combobox("#payLoc",{
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType=EMLOC&LocID=&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
	})
	
	//评估留观病区
    $HUI.combobox("#payobsWard",{
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType=EMWARD&LocID=&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
	})
		
}

/// 取登录信息
function GetLgContent(){

	runClassMethod("web.DHCEMAdvPayass","GetLgContent",{"LgLocID":LgCtLocID},function(jsonObject){
		
		if (jsonObject != null){
			$('#payCurward').val(jsonObject.LocDesc);  /// 申请科室
		}
	},'json',false)
}
function initBtn(){
	 $('#addBTN').on('click',function(){addAction("add")});
	 $("#searchBTN").on('click',function(){searchAction()});
	 $("#updateBTN").on('click',function(){addAction("update")});
	 $("#cancelBTN").on('click',function(){delAction()});
	 $("#printBTN").on('click',function(){printAction()});
	 $("#regno").on("keypress",regNo_KeyPress);
}

function regNo_KeyPress(e){
	var e=e||event;
	if(e.keyCode == 13){
		var regNo = $("#regno").val();
		regNo = GetWholePatNo(regNo);
		$("#regno").val(regNo);
		searchAction();  /// 查询
	}	
}

//新增预交金评估
function addAction(type){
	
	advpayassId=$('#advpayassId').val()
	if((advpayassId=="")&&(type=="update")){   //修改提示 yyt 2019-05-28
		$.messager.alert("提示:","请选择要操作的记录");
		return;
    }
	var EpisodeID=$('#EpisodeID').val()  //就诊ID
	var payCurward=LgCtLocID; 
	var payobsDays=$('#payobsDays').val() //评估留观天数
    var payobsWard=$('#payobsWard').combobox('getValue')
	var advpayAmt=$('#advpayAmt').val()
	
	if(parseInt(advpayAmt)==0){
		$.messager.alert("提示:","评估预交金不能为0");
		return;
	}
	
	var payLoc=$('#payLoc').combobox('getValue')
    var payAssDate="",payAssTime=""
    var payAssDatetime=$('#payAssDatetime').datebox('getValue')
    if(payAssDatetime!=""){
       payAssDate=payAssDatetime.split(" ")[0] 
       payAssTime=payAssDatetime.split(" ")[1]   
    } 
	var payNote=$('#payNote').val()
	
	var PayDataList=EpisodeID+"^"+payCurward+"^"+payobsDays+"^"+payobsWard+"^"+advpayAmt+"^"+payLoc
	PayDataList=PayDataList+"^"+LgUserID+"^"+payAssDate+"^"+payAssTime+"^"+payNote
	var PayMessage=""
	if($('#detailTable').form('validate')){
		advpayassId=$('#advpayassId').val()
		if(type=="add"){
			advpayassId=0;
			PayMessage="保存"
		}
		if(type=="update"){
			PayMessage="修改"
			//$('#datagrid')
		}

		/// 保存
		runClassMethod("web.DHCEMAdvPayass","saveAdvPayass",{"payAssID":advpayassId, "PayDataList":PayDataList},function(jsonString){
			if (jsonString < 0){
				$.messager.alert("提示:","申请"+PayMessage+"失败，失败原因:"+jsonString);
			}else{
				CstID = jsonString;
				$('#datagrid').datagrid('reload')
				$('#advpayassId').val(""); /// 保存或修改成功后清空
				$("#payUser").val(LgUserName);
				$.messager.alert("提示",PayMessage+"成功！","",function(){
					if(PayFlag=="1"){  
					  window.close();
					}
				});	
			}
		},'',false)

	 }
}

function getInfoByAss(pay,adm){
	$("#advpayassId").val(pay)
	$("#EpisodeID").val(adm)
	$.ajax({
     	url: LINK_CSP,
     	data: {
			'ClassName':'web.DHCEMAdvPayass',
			'MethodName':'getInfoBYAss',
			'pay':pay
	 	},
     	dataType: "json",
    	success: function(data){
			$("#payobsDays").val(data.payobsDays)
			$("#payobsWard").combobox('setValue',data.payobsWard)
			$("#advpayAmt").val(data.advpayAmt)
			$HUI.validatebox("#advpayAmt").isValid();
			$("#payLoc").combobox('setValue',data.payLoc);
			$("#payAssDatetime").datetimebox('setValue',data.payAssDate+" "+data.payAssTime);
			$("#payNote").val(data.payNote);
			$("#payUser").val(data.User);
	     }
	 });
}


function initDefaultValue(){
	nowDay=new Date()
	date=nowDay.Format('YYYY-MM-dd')
	start=new Date((nowDay.getTime()-30*24*60*60*1000)).Format('yyyy-MM-dd')
	$("#startDate").datebox('setValue',start)	
	$("#endDate").datebox('setValue',date)
    adm=getAdm();
    if(adm==""){adm=$("#EpisodeID").val()}
    getInfoBYAdm(adm)
    
   $('#datagrid').datagrid('load', {
		parAdm:adm,
    	no: $("#regno").val(),
    	startDate: $("#startDate").datebox('getValue'),
    	endDate: $("#endDate").datebox('getValue'),
    	lgUser:LgUserID
	})
	
}

function getInfoBYAdm(adm){
		$("#EpisodeID").val(adm)
		$.ajax({
	     	url: LINK_CSP,
	     	data: {
				'ClassName':'web.DHCEMAdvPayass',
				'MethodName':'getInfoBYAdm',
				'adm':adm,
				'hosp':LgHospID,
		 	},
	     	dataType: "json",
	    	success: function(data){
		    	$("#patno").val(data.patno);  /// 登记号
				$("#name").val(data.name)
				$("#sex").val(data.sex)
				$("#age").val(data.age)
				$("#level").val(data.level)
				$("#admway").val(data.admway)
				$("#admtime").val(data.admtime)
				$("#threenon").val(data.threenon)
				$("#diagnosis").val(data.diagnosis)
				$("#payobsWard").combobox('setValue',data.LocationDr)
				$("#TotalAmt").val(data.TotalAmt);  ///总费用
				$("#Charge").val(data.Charge);      ///押金余额
				$("#NotAmount").val(data.NotAmount);///未记账金额 
				$("#AllCharge").val(data.AllCharge);
				if(data.StayFlag!="Y"){
					$("#ChargeLabel").html("预交金");	
				}
		     }
		 });	
}


function searchAction(){
	$('#datagrid').datagrid('reload')
}

function getAdm(){
	try{
		adm="";
		var frm=window.parent.document.forms["fEPRMENU"];
		if(frm.EpisodeID){
			adm=frm.EpisodeID.value;
		}
		return adm
	}catch(e){
		return "";
	}
}


//删除
function delAction(){
	pay=$('#advpayassId').val()
	 if(pay==""){
		 $.messager.alert('警告','请选择要操作的记录');
		 return;	
	 }
	 $.messager.confirm('提示', "确认要删除吗", function(r){
		if (r){
			$.ajax({
		     	url: LINK_CSP,
		     	data: {
					'ClassName':'web.DHCEMAdvPayass',
					'MethodName':'DelPayAss',
					'pay':pay,
					'lgUser':LgUserID,
			 	},
		     	dataType: "text",
		    	success: function(data){
					if(data==0){
						searchAction();
						$('#advpayassId').val(""); /// 删除成功后清空
						Clear(); /// 清空
						GetCurrDate();
					}else if(data==-1){
						$.messager.alert('警告','非评估人不能删除！');
					}else{
						$.messager.alert('警告','删除失败！');	
					}	
			    }
			 });
		}
	});
	
}


//打印
function printAction(){
	
	pay=$("#advpayassId").val()
	if(pay==""){
		 $.messager.alert('警告','请选择要操作的记录');
		 return;	
	}
	try {
		var ret=serverCall("web.DHCEMAdvPayass","getPrintInfo",{pay:pay}).split("^")
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_AdvPayAss");
		var PatName=ret[0];           //姓名
		var Company=ret[1]            //单位 
		var Phone=ret[2]              //电话 
		var Address=ret[3]            //地址 
		var Diagnosis=ret[4]          //诊断
		var HospName=ret[5]           //医院名称
		var payCurward=ret[6]         //当前病区
		var payobsDays=ret[7]         //评估留观天数
		var payobsWard=ret[8]         //评估留观病区
		var advpayAmt=ret[9]          //评估预交金
		var payLoc=ret[10]            //评估科室
		var User=ret[11]              //评估人
		var payAssDateTime=ret[12]    //评估日期
		var payNote=ret[13]           //备注
		
		 
		var MyPara="HospName"+String.fromCharCode(2)+HospName
		var MyPara=MyPara+"^PatName"+String.fromCharCode(2)+PatName
		var MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company
		var MyPara=MyPara+"^Phone"+String.fromCharCode(2)+Phone
		var MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address
		var MyPara=MyPara+"^Diagnosis"+String.fromCharCode(2)+Diagnosis
		var MyPara=MyPara+"^payCurward"+String.fromCharCode(2)+payCurward
		var MyPara=MyPara+"^payobsDays"+String.fromCharCode(2)+payobsDays
		var MyPara=MyPara+"^payobsWard"+String.fromCharCode(2)+payobsWard
		var MyPara=MyPara+"^advpayAmt"+String.fromCharCode(2)+advpayAmt
		var MyPara=MyPara+"^payLoc"+String.fromCharCode(2)+payLoc
		var MyPara=MyPara+"^User"+String.fromCharCode(2)+User
		var MyPara=MyPara+"^payAssDateTime"+String.fromCharCode(2)+payAssDateTime
		var MyPara=MyPara+"^payNote"+String.fromCharCode(2)+payNote
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,MyPara,"");
	} catch(e) {alert(e.message)};
}	

//获取当前日期
function GetCurrDate(){
	runClassMethod("web.DHCEMAdvPayass","GetCurrDate",{},function(date){
		$("#payAssDatetime").datetimebox("setValue",date);
	},'text',false)
	
}


///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

/// 清空 bianshuai 2020-02-18
function Clear(){
	$('#advpayAmt').val(""); /// 预交金
	$('#payNote').val("");   /// 备注
}
