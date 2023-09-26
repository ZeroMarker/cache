/*
模块:		草药房
子模块:		草药房-科室协定方发药
Creator:	hulihua
CreateDate:	2017-11-15
*/
DHCPHA_CONSTANT.VAR.PARAMS="";
$(function(){
	/* 初始化插件 start*/
	$("#date-daterange").dhcphaDateRange();
	InitPhaLoc(); 				//药房科室
	InitPhaLocWard(); 			//病区科室
	InitGridDispWard(); 		//病区列表
	InitGridOrdTotal();			//协定方汇总
	InitGridOrdDetail();		//协定方明细
	$("#monitor-condition").children().not("#div-ward-condition").hide();	
	/* 初始化插件 end*/
	
	/* 表单元素事件 start*/
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* 表单元素事件 end*/
	
	InitBodyStyle();
})

window.onload=function(){
	setTimeout("QueryDispWardList()",500);
}

//初始病区发药类别table
function InitGridDispWard(){
	var columns=[
		{name:"TPhaAprId",index:"TPhaAprId",header:'TPhaAprId',width:10,hidden:true},
		{name:"TPhaAprWard",index:"TPhaAprWard",header:'TPhaAprWard',width:10,hidden:true},
		{name:"TFromWardLoc",index:"TFromWardLoc",header:'TFromWardLoc',width:10,hidden:true},
		{name:"TAgrReqDate",index:"TAgrReqDate",header:'申请日期',width:150},		
		{name:"TWardLoc",index:"TWardLoc",header:'病区',width:200,align:'left',formatter:splitFormatter},
		{name:"TFromWardDesc",index:"TFromWardDesc",header:'来源科室',width:160},
		{name:"TAgrReqNo",index:"TAgrReqNo",header:'申请单号',width:140},
		{name:"TAgrReqUser",index:"TAgrReqUser",header:'申请人',width:80}						
	];
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery&MethodName=jsQueryAgrParReqList',	//查询后台
	    height:DhcphaJqGridHeight(1,1)-35,
	    multiselect: false,
	    shrinkToFit:false,
	    multiboxonly :false,
	    rownumbers: true,
	    datatype:"local", 
	    onSelectRow:function(id,status){
			var id = $(this).jqGrid('getGridParam', 'selrow');
			KillDetailTmp();
			$("#grid-dispdetail").jqGrid("clearGridData");
			if (id==null){
				$('#grid-disptotal').clearJqGrid();
				$('#grid-dispdetail').clearJqGrid();
			}else{
				QueryInDispTotal();
			}
		},
		loadComplete: function(){
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-wardlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			} 		
			$(this).on("click",function(){
				if (this.name==""){
					KillDetailTmp();
					QueryInDispTotal();
				}
			})
		}
	};
	$('#grid-wardlist').dhcphaJqGrid(jqOptions);
}

//初始化发药汇总table
function InitGridOrdTotal(){
	var columns=[
		{name:"TPID",index:"TPID",header:'TPID',width:100,align:'left',hidden:true},
		{name:"TPhaApriId",index:"TPhaApriId",header:'TPhaApriId',width:60,align:'left',hidden:true},
		{name:"TArcimDr",index:"TArcimDr",header:'TArcimDr',width:60,align:'left',hidden:true},	
		{name:"TDesc",index:"TDesc",header:'协定方名称',width:160,align:'left'},
		{name:"TAccQty",name:"TAccQty",header:'积累数量',width:60,align:'right'},
		{name:"TReqQty",name:"TReqQty",header:'申请数量',width:60,align:'right'},
		{name:'TDspQty',index:'TDspQty',header:'实发数量',width:60,align:'right'},
		{name:"TUom",name:"TUom",header:'单位',width:60}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery&MethodName=jsQueryInDisp&querytype=total', //查询后台	
	    height: DhcphaJqGridHeight(2,1)-$("#panel div_content .panel-heading").height(),
	    multiselect: false,
	    shrinkToFit:false,
	    rownumbers: true,
	    datatype:'local',   
		onSelectRow:function(id,status){
			if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-disptotal").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{oneditfunc:function(){
				$editinput = $(event.target).find("input");
				$editinput.focus(); 
				$editinput.select();
				$("#"+id+"_TDspQty").on("focusout || mouseout",function(){	
					var iddata=$('#grid-disptotal').jqGrid('getRowData',id);
					var accqty=iddata.TAccQty;								
					if (parseFloat(this.value*1000)>parseFloat(accqty*1000)) {
						dhcphaMsgBox.message("第"+id+"行实发数量大于积累数量!")
						$("#grid-disptotal").jqGrid('restoreRow',id);
						JqGridCanEdit=false
						return false
					}else{
						JqGridCanEdit=true
						return true
					}
				});
			}});
			LastEditSel=id;
		}
	};
	$('#grid-disptotal').dhcphaJqGrid(jqOptions);
	PhaGridFocusOut('grid-disptotal');
}
function splitFormatter(cellvalue, options, rowObject){ 
	if(cellvalue.indexOf("-")>=0){
		cellvalue=cellvalue.split("-")[1];
	} 
	return cellvalue;  
};  
//初始化发药明细table
function InitGridOrdDetail(){
	var columns=[
		{name:"TPID",index:"TPID",header:'TPID',width:80,hidden:true},		
		{name:"TAdmLoc",index:"TAdmLoc",header:'科室',width:125,formatter:splitFormatter},	
		{name:"TBedNo",index:"TBedNo",header:'床号',width:80},
		{name:"TRegNo",index:"TRegNo",header:'登记号',width:100},
		{name:"TPaName",index:"TPaName",header:'姓名',width:80},
		{name:"TAge",index:"TAge",header:'年龄',width:60},			
		{name:"Tsex",index:"Tsex",header:'性别',width:60},
		{name:"TDesc",index:"TDesc",header:'协定方名称',width:200,align:'left'},		
		{name:"TQty",index:"TQty",header:'数量',width:50,align:'right'},		
		{name:"TPrescNo",index:"TPrescNo",header:'处方号',width:100},	
		{name:"TDispIdStr",index:"TDispIdStr",header:'TDispIdStr',width:80,hidden:true},
		{name:"Toedis",index:"Toedis",header:'Toedis',width:80,hidden:true}						
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery&MethodName=jsQueryInDisp&querytype=detail&style=jqGrid', //查询后台	
	    height: DhcphaJqGridHeight(2,1)-$("#panel div_content .panel-heading").height()+5,
	    multiselect: false,
	    shrinkToFit:false,
	    datatype:'local',
	    rownumbers: true,
	    pager: "#jqGridPager1", //分页控件的id  
		onPaging:function(pgButton){
			ReLoadAddPid();
		}
	};
	$('#grid-dispdetail').dhcphaJqGrid(jqOptions);
	$("#refresh_grid-dispdetail").hide(); //此处刷新先屏蔽
}


function ReLoadAddPid(){
	if ($("#grid-dispdetail").getGridParam('records')>0){
		var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
		var Pid= firstrowdata.TPID
		$("#grid-dispdetail").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				Pid:Pid
			}
		})				
	}
}

//查询待发药病区
function QueryDispWardList(){
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaLoc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("药房不允许为空!");
		return;
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""}
	
	var params=startdate+"!!"+enddate+"!!"+phaloc+"!!"+wardloc;
	$("#grid-wardlist").setGridParam({
		datatype:'json',
		page:1,
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	KillDetailTmp();
	$('#grid-disptotal').clearJqGrid();
	$('#grid-dispdetail').clearJqGrid();
}

//查询待发药列表
function QueryInDispTotal(Pid){
	if (Pid==undefined){Pid="";}
	var params=GetQueryDispParams();
	if(params!=""){
		if ($("#div-detail").is(":hidden")==false){
			$("#grid-dispdetail").setGridParam({
				datatype:'json',
				page:1,
				postData:{
					params:params,
					Pid:Pid
				}
			}).trigger("reloadGrid");
		}else{
			$("#grid-disptotal").setGridParam({
				datatype:'json',
				page:1,
				postData:{
					params:params,
					Pid:Pid
				}
			}).trigger("reloadGrid");
		}	
	}
}

function GetQueryDispParams(){
	if($("#div-ward-condition").is(":hidden")==false){
		var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
		if ((selectid=="")||(selectid==null)){
			dhcphaMsgBox.alert("请先选择需要发药的申请单!");
			$('#grid-disptotal').clearJqGrid();
			$('#grid-dispdetail').clearJqGrid();
			return "";
		}
		var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
		var dispWard=selrowdata.TPhaAprWard;
		var phaaprid=selrowdata.TPhaAprId;
		var fromwardloc=selrowdata.TFromWardLoc;
	}else{
		dhcphaMsgBox.alert("请刷新界面后重试!");
		return "";
	}
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaloc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("药房不允许为空!");
		return "";
	}
	var dispCats="XDCF";
	var params=phaloc+"!!"+dispWard+"!!"+gUserID+"!!"+dispCats+"!!"+phaaprid+"!!"+fromwardloc;
	return 	params;
}

//发药
function ConfirmDisp(){
	if ($("#sp-title").text()=="协定方明细"){
		if (DhcphaGridIsEmpty("#grid-dispdetail")==true){
			return;
		}
	}else if ($("#sp-title").text()=="协定方汇总"){
		if (DhcphaGridIsEmpty("#grid-disptotal")==true){
			return;
		}
	}
	dhcphaMsgBox.confirm("是否确认发药?",DoDisp);
}
function DoDisp(result){
	if (result==true){
		var dispflag="";
		//取是否录入发药人配置
		if (DHCPHA_CONSTANT.VAR.PARAMS!=""){
			var paramsarr=DHCPHA_CONSTANT.VAR.PARAMS.split("^");
			var dispuserflag=paramsarr[17];
			var operaterflag=paramsarr[21];
			if ((dispuserflag=="Y")||(operaterflag=="Y")){
				dispflag=1;
				$('#modal-inphaphauser').modal('show');
			}
		}
		if (dispflag==""){
			ExecuteDisp({});
		}
	}
}
function ExecuteDisp(dispoptions){
	var pid="";
	if ($("#sp-title").text()=="协定方明细"){
		var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
		pid= firstrowdata.TPID
	}else if ($("#sp-title").text()=="协定方汇总"){
		var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
		pid= firstrowdata.TPID
	}
	if (dispoptions.operateuser==undefined){
		dispoptions.operateuser="";
	}
	if (dispoptions.phauser==undefined){
		dispoptions.phauser=gUserID;
	}
	var phaloc=$("#sel-phaloc").val();
	//正常发药
	var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
	var wardid=selrowdata.TPhaAprWard;
	var phaaprid=selrowdata.TPhaAprId;
	var cat="XDCF";
	var MainInfo=phaloc+"^"+wardid+"^"+phaaprid+"^"+dispoptions.phauser;
	
	var disptotalrowdata = $("#grid-disptotal").jqGrid('getRowData');
    var disptotalgridrows=disptotalrowdata.length;
	if (disptotalgridrows<=0){
		dhcphaMsgBox.alert("没有申请数据!");
		return;
	}

	var DispString="";	
	for(var rowi=0;rowi<disptotalgridrows;rowi++){
		var phaApriId=disptotalrowdata[rowi].TPhaApriId;
		var arcimDr=disptotalrowdata[rowi].TArcimDr;
		var accQty=disptotalrowdata[rowi].TAccQty;
		var reqQty=disptotalrowdata[rowi].TReqQty;
		var dispQty=disptotalrowdata[rowi].TDspQty;
		phaApriId=$.trim(phaApriId);
		accQty=$.trim(accQty);
		reqQty=$.trim(reqQty);
		dispQty=$.trim(dispQty);
		if(parseFloat(dispQty)>parseFloat(accQty)){
			dhcphaMsgBox.alert("实发数量不能大于积累数量!");
			return;
		}
		if (parseFloat(dispQty)<0){
			dhcphaMsgBox.alert("实发数量不能小于0!");
			return;
		}

		var tmpdispstring=phaApriId+"^"+arcimDr+"^"+reqQty+"^"+dispQty;
		if (DispString==""){
			DispString=tmpdispstring;
		}
		else{
			DispString=DispString+"!!"+tmpdispstring;
		}
		
	} 
	if((DispString=="")||(DispString==null)){
		dhcphaMsgBox.alert("科室协定方明细为空，请核实！") ;
 		return;
	}
	var Ret=tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","SaveAgrParDisp",pid,MainInfo,DispString);
	if (Ret!=0){
		if (Ret=="-10"){
			dhcphaMsgBox.alert("协定方中有明细库存不足，请核实！");
			return;
		}else if(Ret=="-99"){
			dhcphaMsgBox.alert("加锁失败，请联系系统管理员!") ;
			return;
		}else{
			dhcphaMsgBox.alert("发放科室协定方失败,"+Ret) ;
			return;
		}		
	}
	KillDetailTmp();
	QueryDispWardList();
}

function ChangeDispQuery(){
	var Pid="";
	if ($("#sp-title").text()=="协定方汇总"){
		$("#sp-title").text("协定方明细");
		$("#div-total").hide();
		$("#div-detail").show();
		if ($("#grid-dispdetail").getGridParam('records')==0){
			if ($("#grid-disptotal").getGridParam('records')>0){
				var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
				Pid= firstrowdata.TPID
			}
			QueryInDispTotal(Pid);
		}
	}else{
		$("#sp-title").text("协定方汇总")
		$("#div-detail").hide();
		$("#div-total").show(); //每次点击汇总都要重新汇总
		if ($("#grid-dispdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
		QueryInDispTotal(Pid);
	}
}

//已发药查询报表
function DispQuery(){
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaLoc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("药房不允许为空!");
		return;
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""}
	var aprstatus="D";
	var locdesc=$.trim($('#sel-phaloc option:checked').text());
	//预览打印	
	fileName="DHCINPHA_DispStat_AgrPartyHerMed.raq&StartDate="+startdate+"&EndDate="+enddate+"&AprStatusStr="+aprstatus+"&PhaLocId="+phaloc+"&WardLocId="+wardloc+"&LocDesc="+locdesc+"&StatType=1";
	DHCST_RQPrint(fileName,"");
}

//编辑完申请数量之后鼠标交点离开保存当前数据
function PhaGridFocusOut(gridid){
	$("#"+gridid).focusout(function(e){
		if (e.relatedTarget) {
	        var $related = $("#"+gridid).find(e.relatedTarget);
	        if ($related.length <= 0 && LastEditSel!="") {
	            $("#"+gridid).jqGrid('saveRow', LastEditSel);
	        }
	    }
	})
}

function KillDetailTmp(){
	var Pid="";
	if ($("#sp-title").text()=="协定方汇总"){
		if ($("#grid-disptotal").getGridParam('records')>0){
			var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
			Pid=firstrowdata.TPID;
		}			
	}else{
		if ($("#grid-dispdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
	}
	KillInDispTmp(Pid)
}
function KillInDispTmp(pid){
	if (pid!=""){
		tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","KillTmp",pid);
	}
}

function InitBodyStyle(){
	var tmpheight=DhcphaJqGridHeight(1,1)-$("#div-ward-condition .panel-heading").height()+10;
	$("#grid-disptotal").setGridHeight(tmpheight);
	$("#grid-dispdetail").setGridWidth("");
	$("#div-detail").hide();
	var wardtitleheight=$("#gview_grid-wardlist .ui-jqgrid-hbox").height();
	var wardheight=DhcphaJqGridHeight(1,0)-wardtitleheight-16;
	$("#grid-wardlist").setGridHeight(wardheight);
	
}

window.onbeforeunload = function (){
	KillDetailTmp();
}