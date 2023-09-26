/*
模块:		住院草药房
子模块:		住院草药房-科室协定方修改
Creator:	hulihua
CreateDate:	2018-03-27
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* 初始化插件 start*/
    InitDepAgrpList();
    InitDepAgrpDetList();	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
})

window.onload=function(){
	setTimeout("QueryArgParReq()",500);
}

//初始化未发药申请单列表
function InitDepAgrpList(){
	//定义columns
	var columns=[
		{header:'TPhaAprId',index:'TPhaAprId',name:'TPhaAprId',width:30,hidden:true},
		{header:'申请单号',index:'TAgrReqNo',name:'TAgrReqNo',width:80},
		{header:'申请日期',index:'TAgrReqDate',name:'TAgrReqDate',width:130},
		{header:'申请人',index:'TAgrReqUser',name:'TAgrReqUser',width:60},
		{header:'来源科室',index:'TAgrFromWard',name:'TAgrFromWard',width:120}
    ];
         
    var jqOptions={
	    colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=GetAgrParReqList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)*0.4,
		onSelectRow:function(id,status){
			SelectQueryAgrReqDetail();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-depagrpreq").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	} 
   //定义datagrid	
   $('#grid-depagrpreq').dhcphaJqGrid(jqOptions);
}

//初始化未发药申请单详细信息列表
function InitDepAgrpDetList(){
	//定义columns
	var columns=[
		{header:'TPhaApriId',index:'TPhaApriId',name:'TPhaApriId',width:30,hidden:true},
		{header:'协定方名称',index:'TArcimDesc',name:'TArcimDesc',width:120,align:'left'},
		{header:'累积数量',index:'TAccQty',name:'TAccQty',width:30},
		{header:'申请数量',index:'TReqQty',name:'TReqQty',width:30,
			editable:true,
			cellattr:addTextCellAttr,
			inputlimit:{
	           	number:true,
	        	negative:false
	        }
		},
		{header:'单位',index:'TDispUom',name:'TDispUom',width:30},
		{header:'修改日期',index:'TUpReqDate',name:'TUpReqDate',width:80},
		{header:'修改人',index:'TUpReqUser',name:'TUpReqUser',width:60}
    ];        
    var dataGridOption={
	    colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=GetAgrParReqDetList',
		height:GridCanUseHeight(1)*0.6,
		multiselect: false,
		shrinkToFit:false,
		rownumbers: true,
		autoScroll:true,  
		onSelectRow:function(id,status){
			if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-depagrpreqdetail").jqGrid('setSelection',LastEditSel);
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
					var iddata=$('#grid-depagrpreqdetail').jqGrid('getRowData',id);
					var dspqty=iddata.TAccQty;								
					if (parseFloat(this.value*1000)>parseFloat(dspqty*1000)) {
						dhcphaMsgBox.message("第"+id+"行申请数量大于积累数量!")
						$("#grid-depagrpreqdetail").jqGrid('restoreRow',id);
						JqGridCanEdit=false
						return false
					}else{
						var phaapriid=iddata.TPhaApriId;
						var ResultCode=tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","UpReqDetData",phaapriid,this.value,gUserID);
						if(ResultCode!=0){
							if(ResultCode=="-1"){
								dhcphaMsgBox.alert("修改申请数量失败,未选中明细信息！");
							}else if(ResultCode=="-2"){
								dhcphaMsgBox.alert("修改申请数量失败,未选中明细信息！");
							}else{
								dhcphaMsgBox.alert("修改申请数量失败,该申请单已经是非申请状态！");
							}
							$("#grid-depagrpreqdetail").jqGrid('restoreRow',id);
							JqGridCanEdit=false;
							return false;
						}else{
							JqGridCanEdit=true;
							return true;
						}
					}
				});
			}});
			LastEditSel=id;
		}
	} 
   //定义datagrid	
   $('#grid-depagrpreqdetail').dhcphaJqGrid(dataGridOption);
   PhaGridFocusOut('grid-depagrpreqdetail');
} 

///查询未发药的申请单信息
function QueryArgParReq()
{
	var phaloc="96";
	var wardloc=gLocId;
	if (wardloc==null){wardloc=""}
	var aprstatus="R";
	var params=phaloc+tmpSplit+wardloc+tmpSplit+aprstatus;
	$("#grid-depagrpreq").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///查询明细
function SelectQueryAgrReqDetail(){
	var selectid = $("#grid-depagrpreq").jqGrid('getGridParam', 'selrow');
	if(selectid==null){
		return;	
	}
	var selrowdata = $("#grid-depagrpreq").jqGrid('getRowData', selectid);
	var phaaprid=selrowdata.TPhaAprId;
	if((phaaprid==null)||(phaaprid=="")){
		return;
	}
	var params=phaaprid;
	$("#grid-depagrpreqdetail").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
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

//清空
function ClearConditions(){
	$('#grid-depagrpreq').clearJqGrid();
	$('#grid-depagrpreqdetail').clearJqGrid();
}
