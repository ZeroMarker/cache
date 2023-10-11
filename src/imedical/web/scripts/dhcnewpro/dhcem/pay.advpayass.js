///CreatDate:  2019-03-16
///Author:     yangyongtao
/// pay.advoayass.js 
var PayFlag="";
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
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2011-10-24 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
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
	
	/// 评估日期
	$('#payAssDatetime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});	
}

/// 取登录信息
function GetLgContent(){

	runClassMethod("web.DHCEMAdvPayass","GetLgContent",{"LgLocID":LgCtLocID,"LgUserID":LgUserID},function(jsonObject){
		
		if (jsonObject != null){
			$('#payCurward').val(jsonObject.LocDesc);  /// 申请科室
			$('#payUser').val(jsonObject.User);  /// 评估人
			LgUserName=jsonObject.User;
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
	
	if(parseFloat(advpayAmt) <= 0){
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
						if(typeof websys_showModal=="function"){
							websys_showModal("close");
						}
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
					$("#ChargeLabel").html($g("预交金"));	
				}
		     }
		 });	
}


function searchAction(){
	$('#datagrid').datagrid('reload')
}

function getAdm(){
	adm=getParam("EpisodeID"); //hxy 2022-10-24 st
	if(adm!=""){
		return adm
	} //ed
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
	
	LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEMAdvPayEval");
	var ret=serverCall("web.DHCEMAdvPayass","GetPrintData",{ID:pay}).split("^");
	var PatName=ret[2];           //姓名
	var PatAge=ret[4];			  //年龄
	var PatSex=ret[3];			  //性别
	var PayMoney=ret[5];		  //金额
	var Loc=ret[9];				  //性别
	var RegNo=ret[1];			  //登记号
	var MedInType=ret[15];		  //费别
	var AdmDate=ret[7]+" "+ret[8];//就诊时间
	var FirstDiag=ret[14];
	var OrderDoc=ret[6];		  	  //就诊医师
	var PrintDate=ret[11]+" "+ret[12] //打印日期和打印时间
	var HospName=ret[13]              //医院名称
		
	var MyPara="HospName"+String.fromCharCode(2)+HospName;
	MyPara=MyPara+"^PatName"+String.fromCharCode(2)+PatName;
	MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+PatSex;
	MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+PatAge;
	MyPara=MyPara+"^Loc"+String.fromCharCode(2)+Loc;
	MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
	MyPara=MyPara+"^MedInType"+String.fromCharCode(2)+MedInType;
	MyPara=MyPara+"^AdmDate"+String.fromCharCode(2)+AdmDate;
	MyPara=MyPara+"^FirstDiag"+String.fromCharCode(2)+FirstDiag;
	MyPara=MyPara+"^OrderDoc"+String.fromCharCode(2)+OrderDoc;
	MyPara=MyPara+"^PrintDate"+String.fromCharCode(2)+PrintDate;
	MyPara=MyPara+"^PayMoney"+String.fromCharCode(2)+PayMoney;
	DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	var printRet = LODOP.PRINT();
	return printRet;
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
