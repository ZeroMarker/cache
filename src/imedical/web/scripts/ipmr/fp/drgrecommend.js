/**
 * drgrecommend drg推荐分组
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function InitEvent(){

}

function Init(){
	var result = getDrgRecommend();
	var result_code = result.result_code;
	var result_message = result.result_message;
	var data=result.result_data;
	if (result_code==-1) {
		dipdrgMsg='<div>'
		dipdrgMsg+='<a href="#" class="hisui-linkbutton title" iconCls="" disabled>分组异常</a>'
		dipdrgMsg+='<p><font color=red>'+result_message+'</font></p>'
		dipdrgMsg+='</div>'
		var dipdrgElm=document.getElementById('dip&drg');
		dipdrgElm.innerHTML =dipdrgMsg;
		return;
	}
	var dip='';
	dip=data.GROUP_TYPE=='CHS-DIP'?'DIP':'DRG'
	var type=data.GROUP_TYPE=='CHS-DIP'?'DIP':'DRG'

	var dipdrgMsg=''
	dipdrgMsg+='<div>'
	dipdrgMsg+='<div style="margin:10px">'
	dipdrgMsg+='<a href="#" class="hisui-linkbutton title" iconCls="icon-big-paper" disabled>当前分组结果</a>'
	dipdrgMsg+='<table id="groupResult" style="min-width:400px"></table>'
	dipdrgMsg+='</div><div style="margin:10px">'
	dipdrgMsg+='<a href="#" style="margin-bottom:10px" class="hisui-linkbutton title" iconCls="icon-big-med-equi" disabled>编码推荐结果</a>'
	dipdrgMsg+='<div id="cases" class="hisui-tabs tabs-keywords" style="min-width:400px;"> '
	dipdrgMsg+='</div></div></div>'
	dipdrgMsg+='</div>'
	
	var dipdrgElm=document.getElementById('dip&drg');
	dipdrgElm.innerHTML =dipdrgMsg;
	
	//分组结果内容
	var msg = "";	
	msg+='<tr><th colspan="4">'+data.GROUP_CODE+' ('+data.GROUP_DESC+')'+'</th></tr>'	
	if (type=='DIP') {
		msg+='<tr><th>DIP分值:</th><td>'+data.WEIGHT+'</td><th>DIP点值:</th><td>'+data.FIGURE+'</td></tr>'		
	}
	if (type=='DRG') {
		msg+='<tr><th>病组权重:</th><td>'+data.WEIGHT+'</td><th>病组费率:</th><td>'+data.FIGURE+'</td></tr>'		
	}			
	msg+='<tr><th>支付标准(元):</th><td>'+data.STD_FEE+'</td><th>药占比(%):</th><td>'+data.Drug_Proportion+'</td></tr>'						
	msg+='<tr><th>住院费用(元):</th><td>'+data.TOTAL_EXPENSE+'</td><th>耗占比(%):</th><td>'+data.Con_Proportion+'</td></tr>'						
	msg+='<tr><th>盈亏金额(元):</th><td colspan="3">'					
	msg+=data.PROFIT<=0?'<a href="#" style="color:red;" class="hisui-linkbutton" iconCls="icon-alert-red" disabled>'+data.PROFIT+'</a>':'<a href="#" style="color:green;" class="hisui-linkbutton" iconCls="icon-accept" disabled>'+data.PROFIT+'</a>'
	msg+='</td></tr>'
										
	var el = document.getElementById('groupResult');
	el.innerHTML = msg;
	
	
	//推荐方案内容
	var casesmsg='';
	//根据返回值循环生成内容
	var resultArr=data.REC_RESULT;
	for(var i=0,s=1;i<resultArr.length;i++,s++){
		casesmsg+='<div title="推荐方案'+ s +'" data-options="closable:false">'
		casesmsg+='<div style="float: left;">'			
		casesmsg+='<div>'				
		casesmsg+='<div class="card-title">诊断信息</div>'				  
		casesmsg+='<table>'	
		casesmsg+='<tr><td><a href="#" class="hisui-linkbutton" iconCls="icon-star-orange-border" disabled></a></td><td>'+resultArr[i].DISEASE_CODE+'</td><td>'+resultArr[i].DISEASE_NAME+'</td></tr>'												
		
		//循环生成其他诊断信息OTHER_DIAGS
		var otherDiags=resultArr[i].OTHER_DIAGS
		for(var j=0;j<otherDiags.length;j++){
			casesmsg+='<tr><td></td><td>'+otherDiags[j].CODE+'</td><td>'+otherDiags[j].NAME+'</td></tr>'
		}
									
		casesmsg+='</table></div>'								
		casesmsg+='<div>'
		casesmsg+='<div class="card-title">手术信息</div>'	
		//做判断  若是没有手术信息，则不显示							
		casesmsg+=resultArr[i].OPER_CODE?'<table>':'<table style="display:none">'						
		casesmsg+='<tr><td><a href="#" class="hisui-linkbutton" iconCls="icon-star-orange-border" disabled></a></td><td>'+resultArr[i].OPER_CODE+'</td><td>'+resultArr[i].OPER_NAME+'</td></tr>'												
		
		//循环生成其他手术信息OTHER_OPERS
		var otherOpers=resultArr[i].OTHER_OPERS
		for(var j=0;j<otherOpers.length;j++){
			casesmsg+='<tr><td></td><td>'+otherOpers[j].CODE+'</td><td>'+otherOpers[j].NAME+'</td></tr>'
		}
		
		casesmsg+='</table></div></div>'								
		casesmsg+='<div style="float: left;">'										
		casesmsg+='<div class="card-title">分组信息</div>'									
		casesmsg+='<table>'	
		casesmsg+='<tr><th colspan="2">'						
		casesmsg+=dip=='DIP'?resultArr[i].GROUP_CODE:resultArr[i].GROUP_DESC;					
		casesmsg+='</th></tr>'
		if (type=='DIP') {
			casesmsg+='<tr><th>'+dip+'分值:</th><td>'+resultArr[i].WEIGHT+'</td></tr>'						
			casesmsg+='<tr><th>'+dip+'点值:</th><td>'+resultArr[i].FIGURE+'</td></tr>'		
		}
		if (type=='DRG') {
			casesmsg+='<tr><th>病组权重:</th><td>'+resultArr[i].WEIGHT+'</td></tr>'						
			casesmsg+='<tr><th>病组费率:</th><td>'+resultArr[i].FIGURE+'</td></tr>'	
		}
								
		casesmsg+='<tr><th>支付标准(元):</th><td>'+resultArr[i].STD_FEE+'</td></tr>'								
		casesmsg+='<tr><th>住院费用(元):</th><td>'+data.TOTAL_EXPENSE+'</td></tr>'									
		casesmsg+='<tr><th>盈亏金额(元):</th><td>'+resultArr[i].PROFIT+'</td></tr>'	
		casesmsg+=resultArr[i].PROFIT<=0?'<a href="#" style="color:red;" class="hisui-linkbutton" iconCls="icon-alert-red" disabled>'+resultArr[i].PROFIT+'</a>':'<a href="#" style="color:green;" class="hisui-linkbutton" iconCls="icon-accept" disabled>'+resultArr[i].PROFIT+'</a>'
		casesmsg+='</td></tr>'																		
		casesmsg+='</table></div></div>'  							
	}

	var cases=document.getElementById('cases');
	cases.innerHTML =casesmsg
	
	//整个页面重新编译
	$.parser.parse();
}

function getDrgRecommend()
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "json",
			url : "../MA.IPMR.Ajax.Common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"MA.IPMR.FPS.DataMasterSrv",
					"Method":"DrgRecommend",	
					"p1":EpisodeID
					
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}
