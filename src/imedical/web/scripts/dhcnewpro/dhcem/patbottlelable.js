
var num=1;
//var oeoreid="",mainoeoreid="";

$(function(){

})



	
var obj= new Object();
//д����
obj.init = function(cowNum){

}

obj.data = "";

///���������ֱ�����к󽫽������	
obj.getData =function(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },"json",false
	);
	return RtnStr;
}

//���ɽ���
obj.initpage = function(data,cowNum){

	if(!data.length){
		$("#c2").append("<div style='text-align:center;background:#f4f4f4;'>û���ҵ�ƥ������ݣ�</div>");
		return ;
	}
	obj.data= data;
	adm = data[0].adm;
	var oeoreIdStr = ""

	for(x in data){
		if(oeoreIdStr!=""){
			oeoreIdStr = oeoreIdStr+"^"+data[x].oeoreId;
		}else{
			oeoreIdStr = data[x].oeoreId;
		}		
	}
	runClassMethod("web.DHCEMNurExe","GetExecPrice",
	   {'oeoreIdData':oeoreIdStr},
	   function (numStr){
		   
		    for(x in data){
				data[x].execPrice =numStr.split("!")[x];
			}
			initPage(data,cowNum);
		},"text",false
	);
	
	
	
}

///���һ����Ƭ���õķ���
obj.addBox = function(idFlag,cowNum,data){
	//var prtDesc = getParam(data.prtFlag)=="T"?"�Ѵ�ӡ":"";
	addBox(idFlag,cowNum,data);	
}

///���ɽ���
function initPage(data,cowNum){	
	var htmlstr="",idFlag=0;
	for(x in data){
		
		if(x==0){
			obj.addBox(idFlag,cowNum,data[x]);
			$(".box"+idFlag).attr("datax",x);
			$(".box"+idFlag).each(function(){
				var patNameColor="red";
				///��ɫ��������
				if(data[x].disposeStatDesc=='�账������'){
					$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(244,250,133)")
					$(this).find(".panel-default").css("background-color","rgb(244,250,133)")
				}else if(data[x].disposeStatDesc=='Ƥ��'){
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(250,156,166)","color":"#ffffff"})
					$(this).find(".panel-default").css({"background-color":"rgb(250,156,166)","color":"#ffffff"})
					patNameColor="green";
				}else if(data[x].disposeStatDesc=='δ�շ�'){
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(142, 219, 255)","color":"#ffffff"});	
					$(this).find(".panel-default").css({"background-color":"rgb(142, 219, 255)"});		
					$(this).find(".panel-default").find(".panel-body").find("table").css({"color":"#FFF"});		
					$(this).find(".panel-default").find(".panelBottom").find("table").css({"color":"#FFF"});
				}else if(data[x].disposeStatDesc=='�Ѵ���'){
					//$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"#16BBA2"})
					//$(this).find(".panel-default").css({"background-color":"#16BBA2"})	
					$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(234,234,234)"})
					$(this).find(".panel-default").css({"background-color":"rgb(234,234,234)"})	
				}else{
					$(this).find("table:eq(0) tr:eq(0) td").css("background-color","#fdfac5")
					$(this).find(".panel-default").css("background-color","#fdfac5")	
				}
				if(getParam(data[x].prtFlag)!=""){
					$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(234,234,234)")
				}else{
					//$(this).find("table:eq(0) tr:eq(0) td").css("background-color","#FBFAAE")		
				}
				$(this).find("table:eq(1)").append("<tr><td>"+getParam(data[x].arcimDesc)+"</td>"+
					"<td style='text-align:center;'>"+getParam(data[x].doseQtyUnit)+"</td>"+
					"<td style='text-align:center;display:none;'>"+getParam(data[x].oeoreId)+"</td>"+
					"<td style='text-align:center;display:none;'>"+getParam(data[x].mainOeoreId)+"</td>"+
					"<td style='text-align:center;display:none;'>"+getParam(data[x].disposeStatCode)+"</td>"+
					"</tr>");
				$(this).find("table:eq(1)").css("font-size","13px");
				$(this).find("table:eq(0) tr:eq(0) td").html(
					//"<a href='#' style='font-size:18px;color:#ff00ff' onClick = 'openChargeDetail(this)'>"+getParam(data[x].oecprDesc.charAt(0))+"</a>&nbsp;"+
					"<a href='#' style='font-size:16px;color:"+patNameColor+"; overflow: hidden;text-overflow: ellipsis;width: 60px;display: block;float: left;white-space:nowrap;' onClick = 'openChargeDetail(this)'>"+getParam(data[x].patName)+"</a>"+
					"<span style='font-weight: bold;font-size:12px;margin-left:-3px'>"+getParam(data[x].sttDateTime)+"</span>&nbsp;"+
					"<span style='font-weight: bold;font-size:12px'>"+getParam(data[x].phcinDesc)+"</span>"+
					//"</span><span style='font-weight: bold;font-size:14px'>"+getParam(data[x].phcfrCode)+"</span>("+"</span><span style='font-weight:600;font-size:14px'>"+data[x].oeoreId.split("||")[2]+"/"+data[x].oeoreId.split("||")[1]+"</span>"
					"</span><span style='font-weight: bold;font-size:12px'>"+getParam(data[x].phcfrCode)+"</span>"+
					"<span style='font-weight:600;font-size:12px'>("+data[x].execPrice.split("^")[3]+"/"+data[x].execPrice.split("^")[2]+")</span>"
				);
			});
			
		}
		
		
		if(x>0){
			
			//�Ƿ���һ��ҽ��
			if(data[x].mainOeoreId==data[x-1].mainOeoreId){
				$(".box"+idFlag).each(function(){
					$(this).find("table:eq(1)").append("<tr><td>"+"__"+getParam(data[x].arcimDesc.split("______")[1])+"</td>"+
					   "<td style='text-align:center;'>"+getParam(data[x].doseQtyUnit)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParam(data[x].oeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParam(data[x].mainOeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParam(data[x].disposeStatCode)+"</td>"+
					   "</tr>");
					});	
			}
			else{
				idFlag++;	
				if(data[x].seqNo!=data[x-1].seqNo){
					num=1;
				}
				obj.addBox(idFlag,cowNum,data[x]);
				$(".box"+idFlag).attr("datax",x);
				$(".box"+idFlag).each(function(){
					var patNameColor="red";
					///��ɫ��������
					if(data[x].disposeStatDesc=='�账������'){
						$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(244,250,133)")
						$(this).find(".panel-default").css("background-color","rgb(244,250,133)")
					}else if(data[x].disposeStatDesc=='Ƥ��'){
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(250,156,166)","color":"#ffffff"})
						$(this).find(".panel-default").css({"background-color":"rgb(250,156,166)","color":"#ffffff"});
						patNameColor="green";
					}else if(data[x].disposeStatDesc=='δ�շ�'){
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(142, 219, 255)","color":"#ffffff"})		
						$(this).find(".panel-default").css({"background-color":"rgb(142, 219, 255)","color":"#ffffff"})		
						$(this).find(".panel-default").find(".panel-body").find("table").css({"color":"#FFF"});		
					$(this).find(".panel-default").find(".panelBottom").find("table").css({"color":"#FFF"});
					}else if(data[x].disposeStatDesc=='�Ѵ���'){	
						$(this).find("table:eq(0) tr:eq(0) td").css({"background-color":"rgb(234,234,234)"})
						$(this).find(".panel-default").css({"background-color":"rgb(234,234,234)"})	
					}else{
						$(this).find("table:eq(0) tr:eq(0) td").css("background-color","#fdfac5")
						$(this).find(".panel-default").css("background-color","#fdfac5")	
					}
					
					if(getParam(data[x].prtFlag)!=""){
						$(this).find("table:eq(0) tr:eq(0) td").css("background-color","rgb(234,234,234)")
					}else{
						//$(this).find("table:eq(0) tr:eq(0) td").css("background-color","")		
					}
					$(this).find("table:eq(1)").append("<tr><td>"+getParam(data[x].arcimDesc)+"</td>"+
					   "<td style='text-align:center;'>"+data[x].doseQtyUnit+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParam(data[x].oeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParam(data[x].mainOeoreId)+"</td>"+
					   "<td style='text-align:center;display:none;'>"+getParam(data[x].disposeStatCode)+"</td>"+
					   "</tr>");
					$(this).find("table:eq(1)").css("font-size","13px");
					$(this).find("table:eq(0)").css("background-color","")
					
					$(this).find("table:eq(0) tr:eq(0) td").html(
					//"<a href='#' style='font-size:18px;color:#ff00ff' onClick = 'openChargeDetail(this)'>"+getParam(data[x].oecprDesc.charAt(0))+"</a>&nbsp;"+
					"<a href='#' style='font-size:16px;color:"+patNameColor+"; overflow: hidden;text-overflow: ellipsis;width: 60px;display: block;float: left;white-space:nowrap;' onClick = 'openChargeDetail(this)'>"+getParam(data[x].patName)+"</a>"+
					"<span style='font-weight: bold;font-size:12px;margin-left:-3px'>"+getParam(data[x].sttDateTime)+"</span>&nbsp;"+
					//"</span><span style='font-weight: bold;font-size:14px'>"+getParam(data[x].phcfrCode)+"</span>("+"</span><span style='font-weight:600;font-size:14px'>"+data[x].oeoreId.split("||")[2]+"/"+data[x].oeoreId.split("||")[1]+")</span>"
					"<span style='font-weight: bold;font-size:12px'>"+getParam(data[x].phcinDesc)+"</span>"+
					"</span><span style='font-weight: bold;font-size:12px'>"+getParam(data[x].phcfrCode)+"</span>"+
					"<span style='font-weight:600;font-size:12px'>("+data[x].execPrice.split("^")[3]+"/"+data[x].execPrice.split("^")[2]+")</span>"
					);
				});
						
			}
			
		}
		//���û��У�+1��ԭ��������idFlag��0��ʼ��
		if(((idFlag+1)%cowNum==0)&&(idFlag!=0)){
			$("#c2").append("<div style='clear:both;'></div>");
		}
	}	
}

///���һ����Ƭ
function addBox (idFlag,cowNum,data){
	var execDesc = getParam(data.execCtcpDesc)!=""?"ִ��:"+data.execCtcpDesc:""
	var prtDesc = getParam(data.execPrice.split("^")[4])!=""?"��ӡ:"+data.execPrice.split("^")[4]:""
	var htmlData = ""
	if(execDesc==""){
		htmlData = '<td>'+'<span>'+prtDesc+'</span>'+'</th>'
	}else{
		htmlData ='<td>'+'<span>'+execDesc+'</span>'+'</th>'
	}
	
	htmlstr = 
	'<div class="box_width'+cowNum+' box'+idFlag+' displayClass">'+
		'<div class="panel-default" style="border:1px solid #000" >'+
			'<div class="panel-heading" >'+
				 '<table id="title-table" style="border-bottom:1px solid #000">'+
				 	'<tr><td colspan="4"></td></tr>'+
				 '</table>'+
			'</div>'+
			'<div class="panel-body" onClick="selectCheckBox(this)">'+                 //'<li>______�Ȼ���ע��Һ[����][0.9%500ml]</li>'
				'<table style="border:#fff">'+
					'<tr >' +
						'<th>ҩ������</th>' +
						'<th>����</th>' +
					'</tr>'+
				'</table>'+
			'</div>'+
			'<input type="checkbox" class="pull-right" name="IfPrint" align="right" onClick="GetPrintInfo(this)" style="display:none"/>'+ //checked
			'<div class="panelBottom" style="border-top:1px solid;">'+
				'<table style="width:100%">'+
						'<tr >' +
							'<td style="text-overflow:ellipsis;overflow: hidden;white-space: nowrap;max-width: 135px;display: block;">'+'<span>'+data.ctcpDesc+" "+getParam(data.notes)+'</span>'+'</th>' +htmlData+
							'<td>'+'<span>��'+data.execPrice.split("^")[1]+'��'+data.execPrice.split("^")[0]+'��</span>'+'</th>' +
						'</tr>'+
				'</table>'+
			'</div>'+
			'</div>'
		'</div>'+
	'</div>'
	$("#c2").append(htmlstr);	
}

// ���ص�td�͵����¼�
function GetPrintInfo(obj){
	var oeoreidarr="";mainoeoreidarr="",codearr="",arcidescarr="";
	if($(obj).is(':checked')){
		$(obj).prev().find("table tr").each(function(){
			if(($(this).find("td:eq(2)").text()=="")||($(this).find("td:eq(3)").text()=="")||($(this).find("td:eq(4)").text()=="")){
				return true;
			}
			
			//ҽ��id  qqa 2017-09-19 ֻ��Ҫ������ҽ������
			if(oeoreidarr.length==0){
			   oeoreidarr=$(this).find("td:eq(2)").text();
			}else{
			   oeoreidarr=oeoreidarr+"^"+$(this).find("td:eq(2)").text();
			}
			
			//��ҽ��id
			if(mainoeoreidarr.length==0){
			   mainoeoreidarr=$(this).find("td:eq(3)").text();
			}else{
			   mainoeoreidarr=mainoeoreidarr+"^"+$(this).find("td:eq(3)").text();
			}
			
			//����״̬
			if(codearr.length==0){
			   codearr=$(this).find("td:eq(4)").text();
			}else{
			   codearr=codearr+"^"+$(this).find("td:eq(4)").text();
			}	
			
			//ҽ������
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

function openChargeDetail(thisObj){
	var x = $(thisObj).parents(".displayClass").attr("datax");
	var row = obj.data[x];
	var exeStDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.exeStDate})
	var exeEdDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.exeEdDate})
	//$('#attachtable').dhccQuery
	//({query:{regNo:$("#RegNo").val(),userId:LgUserID,
	//startDate:exeStDate,endDate:exeEdDate,admType:"OE",
	//DetailFlag:"on",ordId:row.oeoreId,queryTypeCode: $("#QueryTypeCode").val()}})
	var regNo = $("#RegNo").val() ; 
	var queryTypeCode = $("#QueryTypeCode").val();
	var option={
		title:'������ϸ',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['950px','350px'],
  		content: 'dhcem.chargedetail.csp?regNo='+regNo+'&startDate='+exeStDate+'&endDate='+exeEdDate+'&oreId='+row.oeoreId+'&queryTypeCode='+queryTypeCode
	}

	window.parent.layer.open(option);
	
	return false;
}

///���bodyѡ��checkbox
function selectCheckBox(panBodyObj){
	if(!$(panBodyObj).next().is(':checked')){
		$('.J_menuTab',parent.document).each(function(){
			$(this).attr("data-episodeid",adm);
		})	
		$(panBodyObj).next().prop("checked",true);
		$(panBodyObj).css("backgroundImage","url(../images/check_nurorder.gif)");
		GetPrintInfo($(panBodyObj).next()[0]);
	}else{
		$(panBodyObj).next().prop("checked",false);
		$(panBodyObj).css("backgroundImage","");
		GetPrintInfo($(panBodyObj).next()[0]);
	};
	return ;
}
//����������Ϊundefined���ؿ�
function getParam(param){
	return typeof param=="undefined"?"":param
	}