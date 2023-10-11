
var num=1;	
var TrsName=$g('药物名称');
var TrsDose=$g('剂量');
var TrsDi=$g('第');
var TrsAll=$g('共');
var TrsBag=$g('袋');
var TrsExec=$g("执行");
var TrsOver=$g('超');
//生成界面
_initBotPage = function(data,cowNum){

	if(!data.length){
		$("#execBotArea").append("<div style='text-align:center;background:#f4f4f4;'>"+$g("没有找到匹配的数据")+"！</div>");
		return ;
	}
	_initAllBotPage(data,cowNum);
	//_initTip(); //hxy 2023-02-20 //2023-02-23 注释，不需要了
	return;
}

///添加一个卡片调用的方法
addBotBox = function(idFlag,cowNum,data){
	addOneBotBox(idFlag,cowNum,data);	
}
function _initTip(){
	$("#execBotArea .panelBox").each(function(){
		bindShowDetail($(this).find("table:eq(1) tr:eq(1) td:eq(1)"),$(this).find("table:eq(1) tr:eq(1) td:eq(1)").html());
	});
}
///生成界面
function _initAllBotPage(data,cowNum){	
	var htmlstr="",idFlag=0;
	for(x in data){
		if(x==0){
			addBotBox(idFlag,cowNum,data[x]);
			var datax=($(".box"+idFlag).attr("datax")?$(".box"+idFlag).attr("datax")+","+x:x);
			$(".box"+idFlag).attr("datax",datax);
			var caImg=data[x].isCaExec?"<img style='position: relative;top: 2px;' src='../skin/default/images/ca_icon_green.png'></img>":"";
			
			$(".box"+idFlag).each(function(){
				var patNameColor="red";
				///颜色设置区域
				if(data[x].disposeStatDesc==$g('需处理临嘱')){
					$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(244,250,133)")
					$(this).find(".panel-default").css("background-color","rgb(244,250,133)")
				}else if(data[x].disposeStatDesc==$g('皮试')){
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"#FA9CA6"}) //hxy 2018-07-03
					$(this).find(".panel-default").css({"background-color":"rgb(250,156,166)"}) //
					patNameColor="green";
				}else if(data[x].disposeStatDesc==$g('皮试阴性')){
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(200,255,0)"}) //hxy 2018-07-03
					$(this).find(".panel-default").css({"background-color":"rgb(200,255,0)"}) //
					patNameColor="green";
				}else if(data[x].disposeStatDesc==$g('未收费')){
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(142, 219, 255)"});	 //
					$(this).find(".panel-default").css({"background-color":"rgb(142, 219, 255)"});		
				}else if(data[x].disposeStatDesc==$g('已处理')){
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(234,234,234)"})
					$(this).find(".panel-default").css({"background-color":"rgb(234,234,234)"})	
				}else{
					$(this).find("table:eq(0) tr:eq(0) td").css("background-color","#fdfac5")
					$(this).find(".panel-default").css("background-color","#fdfac5")	
				}
				if(getParamEM(data[x].prtFlag)!=""){
					$(this).find("table:eq(0)").css({"background-color":"rgb(234,234,234)","border-top-left-radius":"4px","border-top-right-radius":"4px"}) //hxy 2018-07-03
					$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(234,234,234)")
				}else{
				}
				
				$(this).find("table:eq(1)").append("<tr><td>"+getParamEM(data[x].arcimDesc)+caImg+"</td>"+
					"<td style='text-align:center;'>"+getParamEM(data[x].doseQtyUnit)+"</td>"+
					"<td style='text-align:center;display:none;'>"+getParamEM(data[x].oeoreId)+"</td>"+
					"<td style='text-align:center;display:none;'>"+getParamEM(data[x].mainOeoreId)+"</td>"+
					"<td style='text-align:center;display:none;'>"+getParamEM(data[x].disposeStatCode)+"</td>"+
					"</tr>");
				$(this).find("table:eq(1)").css("font-size","13px");
				$(this).find("table:eq(0) tr:eq(0) td").html(
					"<a href='#' style='width:50px;font-size:16px;color:"+patNameColor+"; overflow: hidden;width: 65px;display: block;float: left;white-space:nowrap;padding-left:3px' onClick = 'openChargeDetail(this)'>"+getParamEM(data[x].patName)+"</a>"+  //hxy 2018-07-03 width
					"<span style='float:right;padding-right:3px'><span style='font-weight: bold;font-size:12px;margin-left:-18px'>"+(getParamEM(data[x].sttDateTime)!=""?data[x].sttDateTime:"")+"</span>&nbsp;"+  //hxy 2018-07-03 3
					"<span style='font-weight: bold;font-size:12px'>"+getParamEM(data[x].phcinDesc)+"</span>"+
					"<span style='font-weight: bold;font-size:12px'>"+getParamEM(data[x].phcfrCode)+"</span>"+
					"<span style='font-weight:600;font-size:12px'>("+data[x].execPrice.split("^")[3]+"/"+data[x].execPrice.split("^")[2]+")</span></span><br/>"
				);
				bindShowDetail($(this).find("table:eq(0) tr:eq(0) td"),(getParamEM(data[x].sttDateTime)!=""?data[x].sttDateTime:"")+getParamEM(data[x].phcinDesc)+getParamEM(data[x].phcfrCode)+"("+data[x].execPrice.split("^")[3]+"/"+data[x].execPrice.split("^")[2]+")");
			});
			
		}
		
		
		if(x>0){
			//是否是一组医嘱
			if(data[x].mainOeoreId==data[x-1].mainOeoreId){
				var datax=($(".box"+idFlag).attr("datax")?$(".box"+idFlag).attr("datax")+","+x:x);
				$(".box"+idFlag).attr("datax",datax);
				$(".box"+idFlag).each(function(){
					$(this).find("table:eq(1) tr:eq(1) td:eq(1)").append("<br/>"+getParamEM(data[x].doseQtyUnit));
					$(this).find("table:eq(1) tr:eq(1) td:eq(0)").append("<br/>"+getParamEM(data[x].arcimDesc));
					$(this).find("table:eq(1)").append("<tr><td>"+getParamEM(data[x].arcimDesc.split("______")[1])+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].doseQtyUnit)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].oeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].mainOeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].disposeStatCode)+"</td>"+
					   "</tr>");
					});	
			}else{
				idFlag++;	
				if(data[x].seqNo!=data[x-1].seqNo){
					num=1;
				}
				addBotBox(idFlag,cowNum,data[x]);
				var datax=($(".box"+idFlag).attr("datax")?$(".box"+idFlag).attr("datax")+","+x:x);
				$(".box"+idFlag).attr("datax",datax);
				$(".box"+idFlag).each(function(){
					var patNameColor="red";
					///颜色设置区域
					if(data[x].disposeStatDesc==$g('需处理临嘱')){
						$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(244,250,133)")
						$(this).find(".panel-default").css("background-color","rgb(244,250,133)")
					}else if(data[x].disposeStatDesc==$g('皮试')){
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"#FA9CA6"}) //hxy 2018-07-03
						$(this).find(".panel-default").css({"background-color":"rgb(250,156,166)"}); //hxy 2018-07-03
						patNameColor="green";
					}else if(data[x].disposeStatDesc==$g('皮试阴性')){
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(200,255,0)"}) //hxy 2018-07-03
						$(this).find(".panel-default").css({"background-color":"rgb(200,255,0)"}) //
						patNameColor="green";
					}else if(data[x].disposeStatDesc==$g('未收费')){
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(142, 219, 255)"})	 //hxy 2018-07-03 st	
						$(this).find(".panel-default").css({"background-color":"rgb(142, 219, 255)"})		
					}else if(data[x].disposeStatDesc==$g('已处理')){	
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(234,234,234)"})
						$(this).find(".panel-default").css({"background-color":"rgb(234,234,234)"})	
					}else{
						$(this).find("table:eq(0) tr:eq(0) td").css("background-color","#fdfac5")
						$(this).find(".panel-default").css("background-color","#fdfac5")	
					}
					
					if(getParamEM(data[x].prtFlag)!=""){
						$(this).find(".panel-heading:eq(0)").css({"background-color":"rgb(234,234,234)","border-top-left-radius":"4px","border-top-right-radius":"4px"}) //hxy 2018-07-03 st
						$(this).find("table:eq(0)").css({"background-color":"rgb(234,234,234)","border-top-left-radius":"4px","border-top-right-radius":"4px"}) //ed
						$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(234,234,234)")
					}else{	
					}
					$(this).find("table:eq(1)").append("<tr><td>"+getParamEM(data[x].arcimDesc)+caImg+"</td>"+
					   "<td style='text-align:center;'>"+data[x].doseQtyUnit+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].oeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].mainOeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParamEM(data[x].disposeStatCode)+"</td>"+
					   "</tr>");
					$(this).find("table:eq(1)").css("font-size","13px");
					$(this).find("table:eq(0)").css("background-color","")
					
					$(this).find("table:eq(0) tr:eq(0) td").html(
					"<a href='#' style='width:50px;font-size:16px;color:"+patNameColor+"; overflow: hidden;width: 65px;display: block;float: left;white-space:nowrap;padding-left:3px' onClick = 'openChargeDetail(this)'>"+getParamEM(data[x].patName)+"</a>"+
					"<span style='float:right;padding-right:3px'><span style='font-weight: bold;font-size:12px;margin-left:-18px'>"+(getParamEM(data[x].sttDateTime)!=""?data[x].sttDateTime:"")+"</span>&nbsp;"+
					"<span style='font-weight: bold;font-size:12px'>"+getParamEM(data[x].phcinDesc)+"</span>"+
					"<span style='font-weight: bold;font-size:12px'>"+getParamEM(data[x].phcfrCode)+"</span>"+
					"<span style='font-weight:600;font-size:12px'>("+data[x].execPrice.split("^")[3]+"/"+data[x].execPrice.split("^")[2]+")</span></span><br/>"
					);
					
					bindShowDetail($(this).find("table:eq(0) tr:eq(0) td"),(getParamEM(data[x].sttDateTime)!=""?data[x].sttDateTime:"")+getParamEM(data[x].phcinDesc)+getParamEM(data[x].phcfrCode)+"("+data[x].execPrice.split("^")[3]+"/"+data[x].execPrice.split("^")[2]+")");
				});
						
			}
			
		}
		//设置换行，+1的原因是这里idFlag从0开始的
		if(((idFlag+1)%cowNum==0)&&(idFlag!=0)){
			$("#execBotArea").append("<div style='clear:both;'></div>");
		}
	}	
}

///添加一个卡片
function addOneBotBox (idFlag,cowNum,data){
	var execDesc = getParamEM(data.execCtcpDesc)!=""?$g("执行")+":"+data.execCtcpDesc:"";
	var prtDesc = getParamEM(data.execPrice.split("^")[4])!=""?$g("打印")+":"+data.execPrice.split("^")[4]:"";
	var overTimeHtml='<div style="position: absolute;right: -19px;bottom: -5px;background: #e67272;height: 25px;transform: rotate(309deg);width: 50px;text-align: center;">'+TrsOver+'</div>' //$g('超')
	var htmlData = ""
	if(execDesc==""){
		htmlData = '<td>'+'<span>'+prtDesc+'</span>'+'</th>'
	}else{
		htmlData ='<td>'+'<span>'+execDesc+'</span>'+'</th>'
	}
	
	htmlstr = 
	'<div class="box_width'+cowNum+' box'+idFlag+' displayClass panelBox">'+
		'<div class="panel-default" style="border:1px solid #000" >'+
			'<div class="panel-heading" style="overflow:hidden;border-bottom:1px solid #ccc;">'+
				 '<table id="title-table" style="table-layout:fixed;width:100%;max-width:100%;">'+ //hxy 2018-07-03 
				 	'<tr><td style="white-space: nowrap;text-overflow: ellipsis;overflow: hidden;"></td></tr>'+
				 '</table>'+
			'</div>'+
			'<div class="panel-body" style="overflow:hidden" onClick="selectCheckBox(this)">'+                 //'<li>______氯化钠注射液[东宝][0.9%500ml]</li>'
				'<table style="border:#fff;width:100%;max-width:100%;">'+
					'<tr >' +
						'<th>'+TrsName+'</th>' + //$g('药物名称')
						'<th>'+TrsDose+'</th>' + //$g('剂量')
					'</tr>'+
				'</table>'+
			'</div>'+
			'<input type="checkbox" class="pull-right" name="IfPrint" align="right" onClick="GetPrintInfo(this)" style="display:none"/>'+ //checked
			'<div class="panelBottom" style="border-top:1px solid #ccc;position: relative;overflow:hidden;">'+ //hxy 2018-07-03 #787878 //hxy 2023-01-06 #ccc
				'<table style="width:100%">'+
						'<tr >' +
							'<td style="text-overflow:ellipsis;overflow: hidden;white-space: nowrap;max-width: 135px;display: block;">'+'<span>'+data.ctcpDesc+" "+getParamEM(data.notes)+'</span>'+'</th>' +htmlData+
							'<td>'+'<span>'+TrsDi+data.execPrice.split("^")[1]+TrsAll+data.execPrice.split("^")[0]+TrsBag+'</span>'+'</th>' + //第，共，袋
						'</tr>'+
						'<tr >' +
							'<td style="text-overflow:ellipsis;font-weight: 800;overflow: hidden;white-space: nowrap;max-width: 135px;display: block;">'+'<span>'+(data.disposeStatDesc.substring(0,3)==$g("需处理")?$g("已收费"):data.disposeStatDesc.substring(0,3))+'</span>'+'</td>'+
							'<td colspan="3">'+'<span>'+(data.execDateTime==""?"":"&nbsp;"+ TrsExec+"："+data.execDateTime)+'</span>'+'</td>' + //$g("执行")
						'</tr>'+
				'</table>'+
				(data.overTimeReqExecDate>0?overTimeHtml:"")+
			'</div>'+
		'</div>'+
	'</div>'
	$("#execBotArea").append(htmlstr);	
}

// 隐藏的td和单击事件
function GetPrintInfo(obj){
	var oeoreidarr="";mainoeoreidarr="",codearr="",arcidescarr="";
	if($(obj).is(':checked')){
		$(obj).prev().find("table tr").each(function(){
			if(($(this).find("td:eq(2)").text()=="")||($(this).find("td:eq(3)").text()=="")||($(this).find("td:eq(4)").text()=="")){
				return true;
			}
			
			//医嘱id  qqa 2017-09-19 只需要保存主医嘱即可
			if(oeoreidarr.length==0){
			   oeoreidarr=$(this).find("td:eq(2)").text();
			}else{
			   oeoreidarr=oeoreidarr+"^"+$(this).find("td:eq(2)").text();
			}
			
			//主医嘱id
			if(mainoeoreidarr.length==0){
			   mainoeoreidarr=$(this).find("td:eq(3)").text();
			}else{
			   mainoeoreidarr=mainoeoreidarr+"^"+$(this).find("td:eq(3)").text();
			}
			
			//处置状态
			if(codearr.length==0){
			   codearr=$(this).find("td:eq(4)").text();
			}else{
			   codearr=codearr+"^"+$(this).find("td:eq(4)").text();
			}	
			
			//医嘱名称
			if(arcidescarr.length==0){
			   arcidescarr=$(this).find("td:eq(0)").text();
			}else{
			   arcidescarr=arcidescarr+"^"+$(this).find("td:eq(0)").text();
			}
			
		})
		
		$(obj).attr("data-code",codearr)
		$(obj).attr("data-oeoreid",oeoreidarr)
		$(obj).attr("data-mainoeoreid",mainoeoreidarr)
		$(obj).attr("data-arcidesc",arcidescarr)
	}else{
		$(obj).removeAttr("data-code");	
		$(obj).removeAttr("data-oeoreid");	
		$(obj).removeAttr("data-mainoeoreid");
		$(obj).removeAttr("data-arcidesc");	
	}
	//$(obj).prev().find("table tr:eq(1) td:eq(2)").text()
}

// 隐藏的td和单击事件
function GetBotLabOeore(obj){
	var oeoreidarr="";
	if($(obj).is(':checked')){
		$(obj).prev().find("table tr").each(function(){
			if(($(this).find("td:eq(2)").text()=="")||($(this).find("td:eq(3)").text()=="")||($(this).find("td:eq(4)").text()=="")){
				return true;
			}	
			oeoreidarr=$(this).find("td:eq(2)").text();
		})
	}
	return oeoreidarr;	
}

function setFrmInfo(oeoreDatas){
	if (oeoreDatas=="") return ;
	var oeoreId = oeoreDatas.split("^")[0];
	adm=serverCall("web.DHCEMOrdInfoVO","getAdm",{ord:oeoreId}) 
	var frm=window.parent.parent.document.forms["fEPRMENU"];	
	if(frm.EpisodeID){
		frm.EpisodeID.value=adm
	}
	$("#EpisodeID",window.parent.document).val(adm);
	window.parent.ADM=adm
	
}

function openChargeDetail(thisObj){
	var x = $(thisObj).parents(".displayClass").attr("datax");
	var allData=$("#execTable").datagrid("getRows")
	var row = allData[x];
	var exeStDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.StartDate})
	var exeEdDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.EndDate})
	var regNo = $("#RegNo").val() ; 
	var queryTypeCode = $("#QueryTypeCode").val();
	url='dhcem.chargedetail.csp?regNo='+regNo+'&startDate='+exeStDate+'&endDate='+exeEdDate+'&oreId='+row.oeoreId+'&queryTypeCode='+queryTypeCode
	var openCss = 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ', top=0, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	//window.open(url,'费用明细',openCss)
	$('#commonIframe')[0].src=url;
	$('#CommonWin').window({
			title:$g('费用明细'),
    		width:$(window).width(),
    		height:$(window).height(),
    		modal:true
	});	
	return false;
}

///点击body选中checkbox
function selectCheckBox(panBodyObj){
	var checkModel = arguments[1];   //1:全选事件,2:取消全选事件
	var dataIndxArr=$(panBodyObj).parent().parent().attr("datax").split(",");
	if(!$(panBodyObj).next().is(':checked')){
		if(checkModel==2){return};
		for(index in dataIndxArr){
			$("#execTable").datagrid('checkRow',dataIndxArr[index]); 
		}	
		//checkOrUnCheckBot(panBodyObj,1);
		//GetPrintInfo($(panBodyObj).next()[0]);
	}else{
		if(checkModel==1){return};
		for(index in dataIndxArr){
			$("#execTable").datagrid('uncheckRow',dataIndxArr[index]); 
		}
		//checkOrUnCheckBot(panBodyObj,2);
		//GetPrintInfo($(panBodyObj).next()[0]);
	};
	
	if((checkModel!=1)&&(checkModel!=2)){
		var oeoreDatas = GetBotLabOeore($(panBodyObj).next()[0]);
		//setFrmInfo(oeoreDatas);	
	}
	
	return ;
}

function checkOrUnCheckBot(panBodyObj,check){
	if(check==1){
		$(panBodyObj).next().prop("checked",true);
		$(panBodyObj).css("backgroundImage","url(../images/check_nurorder.gif)");
		$(panBodyObj).css("backgroundSize","95% 100%");
		$(panBodyObj).css("backgroundRepeat","no-repeat");	
	}else{
		$(panBodyObj).next().prop("checked",false);
		$(panBodyObj).css("backgroundImage","");
	}
}

function bindShowDetail(obj,text){
	$(obj).mousemove(function(e){
		$(".showPanel").html(text);
        $(".showPanel").show().css({
            "top": e.pageY+20,
            "left": e.pageX+20
        })
    });
    $(obj).mouseleave(function(){
	    $(".showPanel").html("");
        $('.showPanel').hide();
    });	
}

//公共方法，为undefined返回空
function getParamEM(param){
	return typeof param=="undefined"?"":param
	}