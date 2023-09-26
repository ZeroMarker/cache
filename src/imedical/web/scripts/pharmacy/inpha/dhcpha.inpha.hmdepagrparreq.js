/*
模块:		草药房
子模块:		草药房-科室协定方申请
Creator:	hulihua
CreateDate:	2017-12-12
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* 初始化插件 start*/
	$("#date-daterange").dhcphaDateRange();
	InitPhaLoc(); 				//药房科室
	InitPhaWard(); 				//病区
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
	
	SetDefaultDate();
	SetLogPhaLoc();				//给药房科室赋默认值！
	InitBodyStyle();
})

window.onload=function(){
	setTimeout("QueryReqDspTotal()",500);
}

//申请单修改
function UpdateAgrParReq(){
	var lnk="dhcpha/dhcpha.inpha.hmdepagrparupreq.csp";
	window.open(lnk,"_target","width="+(window.screen.availWidth-10)+",height="+(window.screen.availHeight-10)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top='0',left='110',location=no");	
}

//初始化发药汇总table
function InitGridOrdTotal(){
	var columns=[
		{name:"TPID",index:"TPID",header:'TPID',width:100,align:'left',hidden:true},
		{name:"TArcimDr",index:"TArcimDr",header:'TArcimDr',width:60,align:'left',hidden:true},	
		{name:"TDesc",index:"TDesc",header:'协定方名称',width:120,align:'left'},
		{name:"TQty",index:"TQty",header:'积累数量',width:60,align:'right'},
		{name:'TReqQty',index:'TReqQty',header:'申请数量',width:60,
			editable:true,
			cellattr:addTextCellAttr,
			inputlimit:{
	           	number:true,
	        	negative:false
	        }
		},
		{name:"TUom",index:"TUom",header:'单位',width:60}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=jsQueryAgrPartyReq&querytype=total', //查询后台	
	    height: DhcphaJqGridHeight(1,1)-$("#panel div_content .panel-heading").height()-10,
	    multiselect: false,
	    shrinkToFit:false,
	    rownumbers: true,	
	    datatype:'local',   
		onSelectRow:function(id,status){
			if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-depagrptotal").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{oneditfunc:function(){
				$editinput = $(event.target).find("input");
				$editinput.focus(); 
				$editinput.select();
				$("#"+id+"_TReqQty").on("focusout || mouseout",function(){	
					var iddata=$('#grid-depagrptotal').jqGrid('getRowData',id);
					var dspqty=iddata.TQty;								
					if (parseFloat(this.value*1000)>parseFloat(dspqty*1000)) {
						dhcphaMsgBox.message("第"+id+"行申请数量大于积累数量!")
						$("#grid-depagrptotal").jqGrid('restoreRow',id);
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
	$('#grid-depagrptotal').dhcphaJqGrid(jqOptions);
	PhaGridFocusOut('grid-depagrptotal');
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
		{name:"TRegNo",index:"TRegNo",header:'登记号',width:80},	
		{name:"TBedNo",index:"TBedNo",header:'床号',width:60},
		{name:"TPaName",index:"TPaName",header:'姓名',width:100},
		{name:"TAge",index:"TAge",header:'年龄',width:60},			
		{name:"Tsex",index:"Tsex",header:'性别',width:40},
		{name:"TDesc",index:"TDesc",header:'协定方名称',width:120,align:'left'},		
		{name:"TQty",index:"TQty",header:'数量',width:50,align:'right'},		
		{name:"TPrescNo",index:"TPrescNo",header:'处方号',width:90},	
		{name:"TDispIdStr",index:"TDispIdStr",header:'TDispIdStr',width:80,hidden:true},
		{name:"Toedis",index:"Toedis",header:'Toedis',width:80,hidden:true}						
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=jsQueryAgrPartyReq&querytype=detail&style=jqGrid', //查询后台	
	    height: DhcphaJqGridHeight(1,1)-$("#panel div_content .panel-heading").height()-45,
	    multiselect: false,
	    shrinkToFit:false,
	    datatype:'local',
	    rownumbers: true,
	    pager: "#jqGridPager1", //分页控件的id  
		onPaging:function(pgButton){
			ReLoadAddPid();
		}
	};
	$('#grid-depagrpdetail').dhcphaJqGrid(jqOptions);
	$("#refresh_grid-depagrpdetail").hide(); //此处刷新先屏蔽
}

function ReLoadAddPid(){
	if ($("#grid-depagrpdetail").getGridParam('records')>0){
		var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
		var Pid= firstrowdata.TPID
		$("#grid-depagrpdetail").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				Pid:Pid
			}
		})				
	}
}

//查询待发药列表
function QueryReqDspTotal(Pid){
	if (Pid==undefined){Pid="";}
	var params=GetQueryDispParams();
	if(params!=""){
		if ($("#div-detail").is(":hidden")==false){
			$("#grid-depagrpdetail").setGridParam({
				datatype:'json',
				page:1,
				postData:{
					params:params,
					Pid:Pid
				}
			}).trigger("reloadGrid");
		}else{
			$("#grid-depagrptotal").setGridParam({
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
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaloc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("药房不允许为空!");
		return "";
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""};
	var reqstatus="R";
	var params=phaloc+"!!"+gLocId+"!!"+gUserID+"!!"+reqstatus+"!!"+wardloc;
	return 	params;
}

//保存申请单
function SaveAgrParReq(){
	if ($("#sp-title").text()=="协定方明细"){
		if (DhcphaGridIsEmpty("#grid-depagrpdetail")==true){
			return;
		}
	}else if ($("#sp-title").text()=="协定方汇总"){
		if (DhcphaGridIsEmpty("#grid-depagrptotal")==true){
			return;
		}
	}
	dhcphaMsgBox.confirm("是否确认申请?",DoReq);
}
function DoReq(result){
	if (result==true){
		var pid="";
		if ($("#sp-title").text()=="协定方明细"){
			var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
			pid= firstrowdata.TPID
		}else if ($("#sp-title").text()=="协定方汇总"){
			var firstrowdata = $("#grid-depagrptotal").jqGrid("getRowData", 1);
			pid= firstrowdata.TPID
		}
		var reqtotalrowdata = $("#grid-depagrptotal").jqGrid('getRowData');
	    var reqtotalgridrows=reqtotalrowdata.length;
		if (reqtotalgridrows<=0){
			dhcphaMsgBox.alert("没有申请数据!");
			return;
		}

		var reqQtyString="";	
		for(var rowi=0;rowi<reqtotalgridrows;rowi++){
			var arcimDr=reqtotalrowdata[rowi].TArcimDr
			var dspQty=reqtotalrowdata[rowi].TQty
			var reqQty=reqtotalrowdata[rowi].TReqQty
			dspQty=$.trim(dspQty);
			reqQty=$.trim(reqQty);
			if(parseFloat(reqQty)>parseFloat(dspQty)){
				dhcphaMsgBox.alert("第"+parseFloat(rowi+1)+"行申请数量不能大于积累数量!");
				return;
			}
			if (parseFloat(reqQty)<0){
				dhcphaMsgBox.alert("第"+parseFloat(rowi+1)+"行申请数量不能小于0!");
				return;
			}
			if ((reqQty=="")||(reqQty==null)){
				dhcphaMsgBox.alert("第"+parseFloat(rowi+1)+"行申请数量为空但可为0!");
				return;
			}

			var tmpreqstring=arcimDr+"^"+dspQty+"^"+reqQty;
			if (reqQtyString==""){
				reqQtyString=tmpreqstring;
			}
			else{
				reqQtyString=reqQtyString+"!!"+tmpreqstring;
			}
			
		} 
		if((tmpreqstring=="")||(tmpreqstring==null)){
			dhcphaMsgBox.alert("申请信息为空，请核实!");
			return;
		}
		var params=GetQueryDispParams();
		
		var PhaAprRowid=tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","SaveReqData",params,reqQtyString);
		if(PhaAprRowid=="-1"){
			dhcphaMsgBox.alert("申请单信息为空!") ;
	 		return;
		}else if(PhaAprRowid=="-2"){
			dhcphaMsgBox.alert("加锁失败!") ;
	 		return;
		}else if(PhaAprRowid=="-3"){
			dhcphaMsgBox.alert("生成申请单号失败!") ;
	 		return;
		}else if(PhaAprRowid=="-4"){
			dhcphaMsgBox.alert("本病区有未处理的申请单，请优先处理!") ;
	 		return;
		}else if(PhaAprRowid=="-5"){
			dhcphaMsgBox.alert("保存申请主表失败!") ;
	 		return;
		}else if(PhaAprRowid=="-6"){
			dhcphaMsgBox.alert("申请主表ID为空!") ;
	 		return;
		}else if(PhaAprRowid=="-7"){
			dhcphaMsgBox.alert("有科室协定方的医嘱项ID为空，请核实!") ;
	 		return;
		}else if(PhaAprRowid=="-8"){
			dhcphaMsgBox.alert("有科室协定方的申请数量大于了积累数量!") ;
	 		return;
		}else if(PhaAprRowid=="-9"){
			dhcphaMsgBox.alert("保存申请单子表失败!") ;
	 		return;
		}else if ((PhaAprRowid<0)||(PhaAprRowid=="")||(PhaAprRowid==0)){
			dhcphaMsgBox.alert("申请科室协定方失败，"+PhaAprRowid) ;
	 		return;
		}else{
			dhcphaMsgBox.alert("申请成功！") ;
			$("#grid-depagrptotal").jqGrid("clearGridData");
			$("#grid-depagrpdetail").jqGrid("clearGridData");
			KillDetailTmp();
			QueryReqDspTotal();
		}
	}
}

//明细和汇总切换调用查询
function ChangeDispQuery(){
	var Pid="";
	if ($("#sp-title").text()=="协定方汇总"){
		$("#sp-title").text("协定方明细");
		$("#div-total").hide();
		$("#div-detail").show();
		if ($("#grid-depagrpdetail").getGridParam('records')==0){
			if ($("#grid-depagrptotal").getGridParam('records')>0){
				var firstrowdata = $("#grid-depagrptotal").jqGrid("getRowData", 1);
				Pid= firstrowdata.TPID
			}
			QueryReqDspTotal(Pid);
		}
	}else{
		$("#sp-title").text("协定方汇总")
		$("#div-detail").hide();
		$("#div-total").show(); //每次点击汇总都要重新汇总
		if ($("#grid-depagrpdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
		QueryReqDspTotal(Pid);
	}
}

//已发药查询报表
function DispQuery(){
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaloc="96";
	var wardloc=gLocId;
	if (wardloc==null){wardloc=""}
	var aprstatus="R,D,C";
	var locdesc=gLocDesc;
	//预览打印	
	fileName="DHCINPHA_DispStat_AgrPartyWardReq&StartDate="+startdate+"&EndDate="+enddate+"&AprStatusStr="+aprstatus+"&PhaLocId="+phaloc+"&WardLocId="+wardloc+"&LocDesc="+locdesc+"&StatType=2";
	DHCST_RQPrint(fileName);
}

//定义界面大小
function InitBodyStyle(){
	var tmpheight=DhcphaJqGridHeight(1,1)-$("#panel div_content .panel-heading").height()-10;
	$("#grid-depagrptotal").setGridHeight(tmpheight);
	$("#grid-depagrpdetail").setGridWidth("");
	$("#div-detail").hide();
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

//给日期控件默认值
function SetDefaultDate(){
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaloc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("药房不允许为空!");
		return "";
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=gLocId};
	return false;		
}

//药房科室赋默认值！
function SetLogPhaLoc(){
	var LogLocid=""
	if (gHospID=="1"){
		LogLocid="96";		//中医院院区默认为黄河路中调！
	}
	if((LogLocid=="")||(LogLocid==gLocId)){
		return;
	}
	var LogLocArr=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetLocInfoById",LogLocid);
	var LogLocDesc=LogLocArr.split("^")[1];
	var select2option = '<option value='+"'"+LogLocid +"'"+'selected>'+LogLocDesc+'</option>'
	$("#sel-phaloc").append(select2option);
}

function KillDetailTmp(){
	var Pid="";
	if ($("#sp-title").text()=="协定方汇总"){
		if ($("#grid-depagrptotal").getGridParam('records')>0){
			var firstrowdata = $("#grid-depagrptotal").jqGrid("getRowData", 1);
			Pid=firstrowdata.TPID;
		}			
	}else{
		if ($("#grid-depagrpdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
	}
	KillInDispTmp(Pid)
}
function KillInDispTmp(pid){
	if (pid!=""){
		tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","KillTmp",pid);
	}
}

window.onbeforeunload = function (){
	KillDetailTmp();
}