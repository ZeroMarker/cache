var LINK_CSP="dhcapp.broker.csp";
var lgParams =LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID ;
$(function(){
	initDateBox();
	
	initDatagrid();

	initMethod();	
})

function initDateBox(){
	$("#stDate").datebox("setValue",formatDate(0));
	$("#endDate").datebox("setValue",formatDate(0));
}

function initMethod(){
	$(".tdDiv").on("click",selOrdItm);
	$('#RegNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur();
            commonQuery();
        }
    });
    $('#ExeNur').bind('keypress',function(event){
        if(event.keyCode == "13"){
            commonQuery();
        }
    });	
    $('#ArcDesc').bind('keypress',function(event){
        if(event.keyCode == "13"){ 
            commonQuery();
        }
    });	
}

function selOrdItm(){
	$(this).toggleClass("selTdDiv");
	$(".tdDiv").not(this).each(function(){
		$(this).removeClass("selTdDiv");	
	})
	
	commonQuery();
}

function initDatagrid(){
	var columns=[[
    	{ field: 'RegNo',align: 'center', title: '登记号',width:50},
    	{ field: 'PatName',align: 'center', title: '患者姓名',width:50},
    	{ field: 'PatSex',align: 'center', title: '患者性别',width:30},
    	{ field: 'PatAge',align: 'center', title: '患者年龄',width:50},
    	{ field: 'ArciName',align: 'center', title: '医嘱名称',width:100},
    	{ field: 'ExecDate',align: 'center', title: '执行日期',width:50},
    	{ field: 'ExecTime',align: 'center', title: '执行时间',width:50},
    	{ field: 'ExecUser',align: 'center', title: '执行人',width:50},
    	{ field: 'CTPCPCareDesc',align: 'center', title: '就诊号别',width:50},
    	{ field: 'AdmType',align: 'center', title: '就诊类型',formatter:formAdmType}
 	]]; 

 	$("#ordDetailTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCEMShowOrdNum&MethodName=JsonListOrdDetail",
		queryParams:{
			stDate:$("#stDate").datebox("getValue"),
			endDate:$("#endDate").datebox("getValue"),
			lgParams:lgParams,
			ordType:"",
			Params:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		//title:'<span id=\'ordDetail\'>医嘱明细-全部</span>',  
		border:false,//hxy 2018-10-30
		rowStyler:function(index,rowData){
			var ret="";
			if(rowData.SaveMedDate>=30){
				ret="background:red";
			}	
			return ret;
		},
		onLoadSuccess:function(data){
			numArr= data.number.split("^");
			$("#SYDO").html(numArr[0]);
			$("#ZSDO").html(numArr[1]);
			$("#PSDO").html(numArr[2]);
			$("#ZLDO").html(numArr[3]);
			$("#JYDO").html(numArr[4]);
			$("#JCDO").html(numArr[5]);
			$("#ECCC").html(numArr[6]);
			$("#XDT").html(numArr[7]);
			$("#XQ").html(numArr[8]);
		}
	});		
}


function commonQuery(){

	var selOrdType = $(".selTdDiv").length==0?"":$(".selTdDiv").attr("data-type");
	
	$("#ordDetailTable").datagrid("load",{
		stDate:$("#stDate").datebox("getValue"),
		endDate:$("#endDate").datebox("getValue"),
		lgParams:lgParams,
		ordType:selOrdType,
		Params:$("#RegNo").val()+"^"+$("#ExeNur").val()+"^"+$("#ArcDesc").val()
	})	
}


function commonReload(){

	$("#stDate").datebox("setValue",formatDate(0));
	$("#endDate").datebox("setValue",formatDate(0));
	$("#ordDetailTable").datagrid("load",{
		stDate:$("#stDate").datebox("getValue"),
		endDate:$("#endDate").datebox("getValue")
	})	
}


function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
}

function formAdmType(value){
	var ret="";
	if(value=="O"){
		ret = $g("门诊");
	}
	if(value=="E"){
		ret = $g("急诊");
	}
	if(value=="I"){
		ret = $g("住院");
	}
	return ret;
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

/// 格式化日期  yangyongtao 2017-11-17

///补零方法
function RegNoBlur()
{
	var i;
    var regno=$('#RegNo').val();
    var oldLen=regno.length;
    if (oldLen==8) return;
	if (regno!="") {
	    for (i=0;i<10-oldLen;i++)
	    {
	    	regno="0"+regno 
	    }
	}
    $("#RegNo").val(regno);
}
