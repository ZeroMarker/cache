/*
模块:		草药房
子模块:		草药房-拒绝发药查询界面
Creator:	pushaungcai
CreateDate:	2017-12-25
*/
$(function(){
	InitPhaConfig(); 
	/* 初始化插件 start*/
	var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    };
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
	InitPhaLoc(); 				//药房科室
	InitPhaWard(); 				//病区
	InitGridPrescList();		//初始化处方列表
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* 表单元素事件 end */
	InitBodyStyle();
})

function InitBodyStyle(){
	var wardtitleheight=$("#gview_grid-presclist .ui-jqgrid-hbox").height();
	var wardheight=DhcphaJqGridHeight(1,0)-wardtitleheight-10;
	var prescheight=DhcphaJqGridHeight(1,0)-15;
	var winWidth=$(window).width()
	var gridWidth=winWidth*0.5-22
	$("#grid-presclist").setGridWidth(gridWidth);
	$("#grid-presclist").setGridHeight(wardheight);
	$("#ifrm-presc").height(prescheight);
}

window.onload=function(){
	setTimeout("QueryInPhDispList()",500);
}

function InitPhaLoc(){
	var selectoption={
		minimumResultsForSearch: Infinity,
		allowClear:false,
		url:ChangeCspPathToAll(LINK_CSP)+"?ClassName=web.DHCSTPharmacyCommon&MethodName=GetPhaLocByGrp&style=select2&grpdr="+gGroupId,
	}
	$("#sel-phaloc").dhcphaSelect(selectoption)
	var select2option = '<option value='+"'"+gLocId +"'"+'selected>'+gLocDesc+'</option>'
	$("#sel-phaloc").append(select2option); 
}

//初始化药房科室
function InitPhaConfig(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: ChangeCspPathToAll(LINK_CSP)+"?ClassName=web.DHCSTPharmacyCommon&MethodName=GetInPhaConfig&locId="+gLocId, 
		data: "",
		success:function(value){   
			if (value!=""){
				SetPhaLocConfig(value)
			}   
		},    
		error:function(){        
			dhcphaMsgBox.alert("获取住院药房配置数据失败!");
		}
	});
}
//加载药房配置
function SetPhaLocConfig(configstr){
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateT(startdate);
	enddate=FormatDateT(enddate);
	$("#date-start").data('daterangepicker').setStartDate(startdate + " 00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(startdate + " 00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
}

//初始化处方列表table
function InitGridPrescList(){
		var columns=[
		{name:"TCurWard",index:"TCurWard",header:'TCurWard',width:10,hidden:true},	
		{name:"TDodis",index:"TDodis",header:'TDodis',width:10,hidden:true},
		{name:"TWardDesc",index:"TWardDesc",header:'病区',width:150,align:'left'},
		{name:"TCurBedcode",index:"TCurBedcode",header:'床号',width:60},
		{name:"TPatNo",index:"TPatNo",header:'登记号',width:100},
		{name:"TPatName",index:"TPatName",header:'姓名',width:80},
		{name:"TPrescNo",index:"TPrescNo",header:'处方号',width:120},
		{name:"TRefuseName",index:"TRefuseName",header:'拒绝人',width:80},
		{name:"TDate",index:"TDate",header:'拒绝日期',width:150},
		{name:"TReason",index:"TReason",header:'拒绝原因',width:100}				
	]; 
	var params=GetMainCodParams();
	var jqOptions={
	    colModel: columns, //列
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=RefuseDrugQuery', //查询后台	
	    height: DhcphaJqGridHeight(1,1)-35,
	    fit:true,
	    multiselect: false,
	    shrinkToFit:false,
	    rownumbers: true,
	    datatype:"local",
	    onSelectRow:function(id,status){
			QueryGridDispSub();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#ifrm-presc").attr("src","");
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$('#grid-presclist').dhcphaJqGrid(jqOptions);
}
//查询明细数据
function QueryInPhDispList(){
	var params=GetMainCodParams();
	var Ward=$('#sel-phaward').val();
	if(Ward==null) Ward="";
	params=params+"^"+Ward
	$("#grid-presclist").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				'Params':params
			}
		}).trigger("reloadGrid");
	$("#ifrm-presc").empty();	//初始化处方预览
	return true;
} 

//获取查询条件
function GetMainCodParams(){
	var startdatetime = $("#date-start").val();
	var startdate = startdatetime.split(" ")[0];
	var sttime = startdatetime.split(" ")[1];
    var enddatetime = $("#date-end").val();
    var enddate = enddatetime.split(" ")[0];
    var entime = enddatetime.split(" ")[1];
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaLoc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("药房不允许为空!");
		return;
	}
	var params=startdate+"^"+sttime+"^"+enddate+"^"+entime+"^"+phaloc;
	return params;
}

//查询发药明细
function QueryGridDispSub(){
	var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
	var prescno=selrowdata.TPrescNo;
    QueryPrescDetail(prescno);
}
function QueryPrescDetail(prescno)
{
	$("#ifrm-presc").empty();
	var htmlstr=GetPrescHtml(prescno);
	$("#ifrm-presc").append(htmlstr);
}

function GetPrescHtml(prescno)
{
	var cyflag="Y";
	var phartype="DHCINPHA";
	var paramsstr=phartype+"^"+prescno+"^"+cyflag;
	$("#ifrm-presc").attr("src",ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp")+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
}

//取消拒绝
function CancelRefuse(){
	var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
	if(selectid==null) {
		dhcphaMsgBox.alert("请选择一个处方！");
		return;
	}
	var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
	var PrescNo=selrowdata.TPrescNo;
	var Dodis=selrowdata.TDodis;
	var params=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
	var ret=tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp","CancelRefuse",PrescNo,Dodis,params);
	if(ret==-2){
		dhcphaMsgBox.alert("该记录已经撤销执行或停止执行，不能取消拒绝！");
		return;
	}else if (ret<0)
	{
		dhcphaMsgBox.alert("取消拒绝失败！");
		return;
	}else{
		dhcphaMsgBox.alert("取消拒绝成功！");
		}
	QueryInPhDispList();
	$("#ifrm-presc").empty();	//初始化处方预览
}

window.onresize = InitBodyStyle;
