var resultArr= "";
$(function(){
	if (IsEnableDRG=="Y")
	{
		//调DIPDRG接口   有值显示DIP，无值不显示DIP
		var data=drgsqualityCheck(EpisodeID).result_data;
	}
	else
	{
		
		var data=undefined
	}
	//判断是DIP还是DRG
	var dip='';
	if (data!=undefined)
	{
		dip=data.GROUP_TYPE=='CHS-DIP'?'DIP':'DRG'
	}
	//dipdrg内容
	var dipdrgMsg=''
	dipdrgMsg+=data?'<div>':'<div style="display:none">'//做判断 有值显示DIP，无值不显示DIP
	//dipdrgMsg+='<div style="margin:10px'+data==undefined?' display:none"':'"'+'>'
	dipdrgMsg+='<div style="'+(isFirstPage=='Y'?'"':' display:none" ')+'>'
	dipdrgMsg+='<a href="#" class="hisui-linkbutton title" iconCls="icon-big-paper" disabled>当前分组结果</a>'
	dipdrgMsg+='<table id="groupResult"></table>'
	dipdrgMsg+='</div><div style="'+(isFirstPage=='Y'?'"':' display:none" ')+'>'
	//dipdrgMsg+='</div><div style="margin:10px'+data==undefined?' display:none"':'"'+'>'
	dipdrgMsg+='<a href="#" style="margin-bottom:10px" class="hisui-linkbutton title" iconCls="icon-big-med-equi" disabled>编码推荐结果</a>'
	dipdrgMsg+='<div id="cases" class="hisui-tabs tabs-keywords" > '
	dipdrgMsg+='</div></div></div>'
	dipdrgMsg+='<div>'
	dipdrgMsg+='<a href="#" class="hisui-linkbutton title" iconCls="icon-big-paper-pen" disabled>首页质控结果</a>'
	dipdrgMsg+='<div id="messages" style="width:auto;overflow-y:auto;height:900px;"></div></div></div>'
	
	var dipdrgElm=document.getElementById('dip&drg');
	dipdrgElm.innerHTML =dipdrgMsg;
	
	if (data!=undefined)
	{
		//因为接口可能不返回所需字段，页面显示为undefined，所以这里手动添加空值
		//分组号
		if(data.GROUP_CODE==undefined){data.GROUP_CODE=''}
		//主要诊断
		if(data.ZYDIAG==undefined){data.ZYDIAG=''}
		//手术操作
		if(data.ZYOPER==undefined){data.ZYOPER=''}
		//点数
		if(data.WEIGHT==undefined){data.WEIGHT=''}
		//点值(费率)
		if(data.FIGURE==undefined){data.FIGURE=''}
		//支付标准(元)
		if(data.STD_FEE==undefined){data.STD_FEE=''}
		//药占比
		if(data.YPFeeRate==undefined){data.YPFeeRate=''}
		//住院费用
		if(data.TOTAL_EXPENSE==undefined){data.TOTAL_EXPENSE=''}
		//耗占比
		if(data.HCFeeRate==undefined){data.HCFeeRate=''}
		//盈亏金额
		if(data.PROFIT==undefined){data.PROFIT=''}
		//分组结果内容
		var msg = "";	
		msg+='<tr><th colspan="4">'+data.GROUP_CODE+'</th></tr>'					
		msg+='<tr><td>主要诊断:</td><td colspan="3">'+data.ZYDIAG+'</td></tr>'						
		msg+='<tr><td>手术操作:</td><td colspan="3">'+data.ZYOPER+'</td></tr>'					
		msg+='<tr><th>'+dip+'点数:</th><td>'+data.WEIGHT+'</td><th>点值(费率):</th><td>'+data.FIGURE+'</td></tr>'					
		msg+='<tr><th>支付标准(元):</th><td>'+data.STD_FEE+'</td><th>药占比(%):</th><td>'+data.YPFeeRate+'</td></tr>'						
		msg+='<tr><th>住院费用(元):</th><td>'+data.TOTAL_EXPENSE+'</td><th>耗占比(%):</th><td>'+data.HCFeeRate+'</td></tr>'						
		msg+='<tr><th>盈亏金额(元):</th><td colspan="3">'					
		msg+=data.PROFIT<=0?'<a href="#" style="color:red;" class="hisui-linkbutton" iconCls="icon-alert-red" disabled>'+data.PROFIT+'</a>':'<a href="#" style="color:green;" class="hisui-linkbutton" iconCls="icon-accept" disabled>'+data.PROFIT+'</a>'
		msg+='</td></tr>'
											
		var el = document.getElementById('groupResult');
		el.innerHTML = msg;
	
	
		//推荐方案内容
		var casesmsg='';
		//根据返回值循环生成内容
		resultArr=data.REC_RESULT;
		for(var i=0,s=1;i<resultArr.length;i++,s++){
			casesmsg+='<div title="推荐方案'+ s +'" data-options="closable:false">'
			casesmsg+='<div style="overflow-y:auto;height:300px;">'
			casesmsg+='<div style="float: left;width:50%">'
			//casesmsg+='<tr><td><a href="#" class="hisui-linkbutton" iconCls="icon-write-order" disabled></a></td><td><a style="font-weight:bold" class="details" onClick="getDisease(' + i + ')">&nbsp;&nbsp;方案引入</a></td></tr>'				
			casesmsg+='<div>'
			casesmsg+='<div class="card-title">诊断信息</div>'				  
			casesmsg+='<table>'	
		    casesmsg+='<tr><td><a href="#" class="hisui-linkbutton" iconCls="icon-star-orange-border" disabled></a></td><td>'+resultArr[i].DISEASE_CODE+'</td><td>'+resultArr[i].DISEASE_NAME+'</td></tr>'												
			
			//循环生成其他诊断信息OTHER_DIAGS  从第二条其他诊断信息开始折叠，点击详情后才展示
			var otherDiags=resultArr[i].OTHER_DIAGS
			//如果其他诊断信息>1
			if(otherDiags.length>1){
				//第一条其他诊断信息
				casesmsg+='<tr><td></td><td>'+otherDiags[0].CODE+'</td><td>'+otherDiags[0].NAME+'<a id="diagsDetails'+i+'" class="details" onClick="getDIAGSDetails('+i+')">&nbsp;&nbsp;详情\>\></a></td></tr>'
				//从第二条起折叠
				for(var j=1;j<otherDiags.length;j++){
					casesmsg+='<tr class="hide-tr"><td></td><td>'+otherDiags[j].CODE+'</td><td>'+otherDiags[j].NAME+'</td></tr>'
				}
			}
										
			casesmsg+='</table></div>'								
			casesmsg+='<div>'
			casesmsg+='<div class="card-title">手术信息</div>'	
			//做判断  若是没有手术信息，则不显示							
			casesmsg+=resultArr[i].OPER_CODE?'<table>':'<table style="display:none">'						
			casesmsg+='<tr><td><a href="#" class="hisui-linkbutton" iconCls="icon-star-orange-border" disabled></a></td><td>'+resultArr[i].OPER_CODE+'</td><td>'+resultArr[i].OPER_NAME+'</td></tr>'												
			
			//循环生成其他手术信息OTHER_OPERS  从第二条其他手术信息开始折叠，点击详情后才展示
			var otherOpers=resultArr[i].OTHER_OPERS
			//如果其他手术信息>1
			for(var j=0;j<otherOpers.length;j++){
				//第一条手术诊断信息
				casesmsg+='<tr><td></td><td>'+otherOpers[0].CODE+'</td><td>'+otherOpers[0].NAME+'<a id="opersDetails'+i+'" class="details" onClick="getOPERSDetails('+i+')">&nbsp;&nbsp;详情\>\></a></td></tr>'
				//从第二条起折叠
				for(var j=1;j<otherOpers.length;j++){
					casesmsg+='<tr class="hide-tr-2"><td></td><td>'+otherOpers[j].CODE+'</td><td>'+otherOpers[j].NAME+'</td></tr>'
				}
			}
			
			casesmsg+='</table></div></div>'								
			casesmsg+='<div style="float: left;width:50%">'										
			casesmsg+='<div class="card-title">分组信息</div>'									
			casesmsg+='<table>'	
			casesmsg+='<tr><th colspan="2">'						
			casesmsg+=dip=='DIP'?resultArr[i].GROUP_CODE:resultArr[i].GROUP_DESC;					
			casesmsg+='</th></tr>'
			casesmsg+='<tr><th>'+dip+'分值:</th><td>'+resultArr[i].FIGURE+'</td></tr>'						
			casesmsg+='<tr><th>'+dip+'点值:</th><td>'+resultArr[i].WEIGHT+'</td></tr>'							
			casesmsg+='<tr><th>支付标准(元):</th><td>'+resultArr[i].STD_FEE+'</td></tr>'								
			casesmsg+='<tr><th>住院费用(元):</th><td>'+data.TOTAL_EXPENSE+'</td></tr>'									
			casesmsg+='<tr><th>盈亏金额(元):</th><td>'
			casesmsg+=resultArr[i].PROFIT<=0?'<a href="#" style="color:red;" class="hisui-linkbutton" iconCls="icon-alert-red" disabled>'+resultArr[i].PROFIT+'</a>':'<a href="#" style="color:green;" class="hisui-linkbutton" iconCls="icon-accept" disabled>'+resultArr[i].PROFIT+'</a>'
			casesmsg+='</td></tr>'																		
			casesmsg+='</table></div></div></div>'  							
		}

		var cases=document.getElementById('cases');
		cases.innerHTML =casesmsg
	}
	//首页质控结果
	//首页质控结果接口返回值
	var qualityData = qualityCheck(key)
	var i = 1;
	var x = 0;
	var resultMsg = "";

	var m = qualityData.split(";");	
	while(i<m.length) {
		var setredcode = m[x].split("#");
		var codes=""
		for (var j=1;j<setredcode.length;j++)
		{
			//resultMsg += '<div id='+setredcode[j]+' onclick="javascript:setred(this)" class="textmessage">'+setredcode[0]+'</div>';
			if(codes!="")
			{
				codes=codes+"^"+setredcode[j]
			}
			else
			{
				codes=setredcode[j]
			}
		}
		resultMsg += '<div id='+codes+' onclick="javascript:setred(this)" class="textmessage" style="border:none">'+setredcode[0]+'</div>';
		i++;
		x++;
	}
	//alert(resultMsg);
	var messages = document.getElementById('messages');
	messages.innerHTML = resultMsg;


	
	//整个页面重新编译
	$.parser.parse();
});

//获取其他诊断信息详情
function getDIAGSDetails(i){
	var aDetails=document.getElementById('diagsDetails'+i)
	var flag=aDetails.innerHTML=='&nbsp;&nbsp;详情&gt;&gt;'?true:false;
	aDetails.innerHTML=flag?'&nbsp;&nbsp;收起<<':'&nbsp;&nbsp;详情>>'
	var hideTr = document.querySelectorAll('.hide-tr');
	for(var x=0;x<hideTr.length;x++){
		var itemStyle=hideTr[x].style;
		flag?itemStyle.setProperty('display', 'table-row'):itemStyle.setProperty('display', 'none')			
	}
}

//获取其他手术信息详情
function getOPERSDetails(i){
	var aDetails=document.getElementById('opersDetails'+i)
	var flag=aDetails.innerHTML=='&nbsp;&nbsp;详情&gt;&gt;'?true:false;
	aDetails.innerHTML=flag?'&nbsp;&nbsp;收起<<':'&nbsp;&nbsp;详情>>'
	var hideTr = document.querySelectorAll('.hide-tr-2');
	for(var x=0;x<hideTr.length;x++){
		var itemStyle=hideTr[x].style;
		flag?itemStyle.setProperty('display', 'table-row'):itemStyle.setProperty('display', 'none')			
	}
}

//主要诊断信息点击事件
//function getDisease(key){
//	
//	alert(key);
//	var arr = resultArr;
//	jQuery.ajax({
//			type : "POST", 
//			dataType : "text",
//			url : "../EMRservice.Ajax.common.cls",
//			async : false,
//			data : {
//					"OutputType":"String",
//					"Class":"EPRservice.Quality.Interface.FirstPageDRGQInfo",
//					"Method":"SaveDRGDIPQuoteResult",
//					"p1":EpisodeID,	
//					"p2":JSON.stringify(arr),
//					"p3":key	
//					
//				},
//			success: function(d) {
//					result = d;
//			},
//			error : function(d) { alert("GetSummery error");}
//		});	
//}


function setred(obj)
{
	if (typeof parent.qualityMarkRequiredObjects  == "function")
  {
    parent.qualityMarkRequiredObjects(obj.id)
  }else if (typeof parent.parent.qualityMarkRequiredObjects  == "function")
  {
    parent.parent.qualityMarkRequiredObjects(obj.id)
  };
}

//质控
function qualityCheck(key)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"GetCheckResultList",	
					"p1":EpisodeID,		
					"p2":key
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}

function drgsqualityCheck(EpisodeID)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "json",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EPRservice.Quality.Interface.FirstPageDRGQInfo",
					"Method":"GetWMRQualityResult",	
					"p1":EpisodeID	
					
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}
