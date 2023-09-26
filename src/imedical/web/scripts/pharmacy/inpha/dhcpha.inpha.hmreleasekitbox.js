/*
模块:		草药房
子模块:		草药房-揭药箱发放
Creator:	hulihua
CreateDate:	2018-01-11
*/
var userlogisticsid="";		//取药护士工号
var SendVoiceStr="";
DhcphaTempBarCode="";
$(function(){
	/* 初始化插件 start*/
	//$("#date-daterange").dhcphaDateRange();
	//给日期控件赋初始化值！
	//startdate=FormatDateT("t-3");
	//$("#date-daterange").data('daterangepicker').setStartDate(startdate);
	
	var daterangeoptions = {
        timePicker: false,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT		//+ ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t-3") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
	
	InitPhaWard(); 				//病区
	InitReleaKitBoxList();
	InitTakeDrugUserModal();
    /* 初始化插件 end*/
    
    //物流人员工号回车触发事件
	$('#txt-userlogistics').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetLogisticsInfo();	 
		}     
	});
	
	//揭药箱号回车触发查询事件
	$('#txt-phboxno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetBarCodeSta();
			$('#txt-phboxno').val("");
			DhcphaTempBarCode="";	 
		}     
	});
	
    
    //屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	//屏蔽所有按钮事件
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
    
    //未扫描和已发放互斥
    $("#chk-dispbox").on("ifChanged",function(){
		if ($('#chk-dispbox').is(':checked')) { 
	    	$('#chk-noscan').iCheck('uncheck');
	    }
		QueryRelkitbox();
	})
	
	$("#chk-noscan").on("ifChanged",function(){
		if ($('#chk-noscan').is(':checked')) { 
	    	$('#chk-dispbox').iCheck('uncheck');
	    }
		QueryRelkitbox();
	})
	
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

//扫描物流人员工牌之后验证以及填充界面
function SetLogisticsInfo(){
	var userlogisticsno=$.trim($("#txt-userlogistics").val());
	userlogisticsid="";
	$('#userlogistics').text("");
	if (userlogisticsno!=""){
		var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",userlogisticsno);
		if (defaultinfo==null||defaultinfo==""){
			dhcphaMsgBox.alert("输入工号有误，请核实!");
			$('#txt-userlogistics').val("");
			return;	
		}
		var ss=defaultinfo.split("^");
		userlogisticsid=ss[0];
		$('#userlogistics').text(ss[2]);
		$('#txt-userlogistics').val("");				
	}
}

//初始化待发揭药箱列表
function InitReleaKitBoxList(){
	var columns=[
		{header:'TPhboxId',index:'TPhboxId',name:'TPhboxId',width:5,hidden:true},
		{header:'接收病区',index:'TLocDesc',name:'TLocDesc',width:100,align:'left'},
		{header:'箱号',index:'TPhBoxNo',name:'TPhBoxNo',width:80},
	    {header:'箱数',index:'TPhBoxNum',name:'TPhBoxNum',width:30},
	    {header:'装箱人',index:'TUserCreate',name:'TUserCreate',width:80},
		{header:'装箱日期',index:'TDateCreate',name:'TDateCreate',width:100},
		{header:'发放人',index:'TUserPhHand',name:'TUserPhHand',width:80},
		{header:'发放日期',index:'TDatePhHand',name:'TDatePhHand',width:100},
		{header:'物流人',index:'TUserLogistics',name:'TUserLogistics',width:80},
		{header:'药箱当前状态',index:'TPhbStatus',name:'TPhbStatus',width:60},
		{header:'备注',index:'TRemark',name:'TRemark',width:80,hidden:true},
	];
	 var jqOptions={
		colModel: columns, //列
		url:LINK_CSP+'?ClassName=web.DHCINPHA.MTBinBox.BinBoxQuery&MethodName=GetLeaseKitBoxList',
		multiselect: false,
		shrinkToFit:false,		
		rownumbers: true,	//是否显示行号
		height:GridCanUseHeight(2)+40,
	    pager: "#jqGridPager", 	//分页控件的id  
	    shrinkToFit:false,
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-releasekitboxlist").clearJqGrid();
			}
		}
	} 
   //定义datagrid	
   $('#grid-releasekitboxlist').dhcphaJqGrid(jqOptions);
}

///查询
function QueryRelkitbox()
{
	/*
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange); 
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""};
	var barcode=$.trim($('#txt-phboxno').val());
	var dispboxflag="N";
	if($("#chk-dispbox").is(':checked')){
		dispboxflag="Y";
	}	
	var scanflag="N"
	if($("#chk-noscan").is(':checked')){
		scanflag="Y";
	}
	var params=startdate+"^"+enddate+"^"+wardloc+"^"+gLocId+"^"+dispboxflag+"^"+scanflag+"^"+barcode;
	$("#grid-releasekitboxlist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//物流人员选择
function InitTakeDrugUserModal(){
	$("#btn-userlogistics-sure").on("click",function(){
		if ((userlogisticsid=="")||(userlogisticsid==null)){
			dhcphaMsgBox.alert("物流人员不能为空，请扫描物流人工牌!");
			return;
		}
		$("#modal-userlogistics").modal('hide');
		var dispoptions={
			userlogisticsid:userlogisticsid
		}
		ExecuteDisp(dispoptions);
	});	
}

///发放开始
function ConfirmDisp(){
	var thisrecords=$("#grid-releasekitboxlist").getGridParam('records');
	if (thisrecords==0){
		dhcphaMsgBox.alert("请先扫描需要发放的揭药箱！");
		return;
	}	
	var thisrecords=$("#grid-releasekitboxlist").getGridParam('records');
	if (thisrecords>0){
	    var ids = $("#grid-releasekitboxlist").getDataIDs();
	    for(var i=1;i<ids.length+1;i++){	
			var tmpselecteddata=$("#grid-releasekitboxlist").jqGrid('getRowData',i);
			var tmpphbstatus=tmpselecteddata["TPhbStatus"];
			if(tmpphbstatus=="揭药箱已发放") {
				dhcphaMsgBox.alert("列表中有已发放的揭药箱，请核实！");
				return;
			}else if(tmpphbstatus=="封箱完成"){
				dhcphaMsgBox.alert("列表中有未扫码的揭药箱，请核实！");
				return;
			}else if(tmpphbstatus=="物流交接完成"){
				dhcphaMsgBox.alert("列表中有已交接完成的揭药箱，请核实！");
				return;
			}
	    }
	}
	
	$('#modal-userlogistics').modal('show');
	userlogisticsid="";
	$('#userlogistics').text("");
	var timeout=setTimeout(function () {
		$(window).focus();
	    if (CheckTxtFocus()!=true){ 
			$("#txt-userlogistics").focus();
			return true;  
		} 
    },500);
}

///确认发放
function ExecuteDisp(dispoptions){
	var userlogisticsid=dispoptions.userlogisticsid;
	var phboxidstr="";
	var thisrecords=$("#grid-releasekitboxlist").getGridParam('records');
	if (thisrecords>0){
	    var ids = $("#grid-releasekitboxlist").getDataIDs();
	    for(var i=1;i<ids.length+1;i++){	
			var tmpselecteddata=$("#grid-releasekitboxlist").jqGrid('getRowData',i);
			var tmpphboxid=tmpselecteddata["TPhboxId"]; 
			if(phboxidstr==""){
				phboxidstr=tmpphboxid;
			}else{
				phboxidstr=phboxidstr+"&&"+tmpphboxid;
			}
	    }
	}
	var ret=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","SaveDispBoxData",phboxidstr,gUserID,userlogisticsid,gLocId);
	if(ret!=0){
		if(ret==-1){
			dhcphaMsgBox.alert("发放人为空，请核实!");
			return;	
		}else if(ret==-2){
			dhcphaMsgBox.alert("物流人员为空，请核实!");
			return;
		}else{
			dhcphaMsgBox.alert("发放失败"+ret);
			return;
		}
	}else{
		dhcphaMsgBox.alert("发放成功！");
		QueryRelkitbox();
	}
}

///清空
function ClearConditions(){	
	//给日期控件赋初始化值！
	//$("#date-daterange").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	//$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$('#chk-noscan').iCheck('uncheck');
	$('#chk-dispbox').iCheck('uncheck');
	$("#txt-phboxno").val("");
	$("#sel-phaward").empty();
	$('#grid-releasekitboxlist').clearJqGrid();
}

function RePrint(){
	var selectid = $("#grid-releasekitboxlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-releasekitboxlist").jqGrid('getRowData', selectid);
	var phboxid=selrowdata.TPhboxId;
	if ((phboxid=="")||(phboxid==null)){
		dhcphaMsgBox.alert("请先选中需要补打的揭药箱！");
		return;
	}
	PrintHmPhBoxLabelL(phboxid,"1")		//打印封箱签	
}

///扫码置状态
function SetBarCodeSta(){
	var barcode=$.trim($('#txt-phboxno').val());
	$("#txt-phboxno").val("");
	var ret=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","SaveBoxBarData",barcode);
	if(ret==-1){
		SendVoiceStr="条码为空";
		SendVocie(SendVoiceStr);
		return;	
	}else if(ret==-2){
		SendVoiceStr="该揭药箱条码有误";
		SendVocie(SendVoiceStr);
		return;
	}else if(ret==-3){
		SendVoiceStr="处理条码状态失败";
		SendVocie(SendVoiceStr);
		return;
	}else{
		SendVoiceStr=ret;
		SendVocie(SendVoiceStr);
		QueryRelkitbox();
	}
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-userlogistics").is(":focus");
	var txtfocus2=$("#txt-phboxno").is(":focus");
	if ((txtfocus1!=true)&&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			var BarCode=tkMakeServerCall("web.DHCST.Common.JsonObj","GetData",DhcphaTempBarCode);
			$("#txt-phboxno").val(BarCode);
			SetBarCodeSta();
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}