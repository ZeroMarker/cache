/**
 * 获取高危html
 * @creater zhouxin
 * @param score 高危评分
 */
function getHighRiskText(n){
	switch(n)
	{
	case 1:
	  return "红"; 	  
	  break;
	case 2:
	  return "橙";
	  break;
	case 3:
	  return "黄";
	  break;
	case 4:
	  return "绿";
	  break;
	case 0:
	  return "紫";
	  break; 
	case -1:
	  return "蓝";
	  break;  	  
	default:
	  return "";
	}
}

function getHighRiskResult(n){
	switch(n)
	{
	case "1,1":
	  return "传染病+高风险"; 	  
	  break;
	case "2,1":
	  return "传染病+较高风险";
	  break;
	case "3,1":
	  return "传染病+一般风险";
	  break;  
	case "1,0":
	  return "高风险";
	  break; 
	case "2,0":
	  return "较高风险";
	  break;
	case "3,0":
	  return "一般风险";
	  break;	 
	case "4,0":
	  return "低风险";
	  break; 
	default:
	  return "";
	}
}

/**
 * 获取高危、筛查等级描述
 * @creater lvpeng
 * @param 高危评分和筛查背景色
 */
function getHighRiskColorStyle(str){
	switch(str)
	{
	case "传染病":
	  return "purple"; 	  
	  break;
	case "高风险":
	  return "red";
	  break;
	case "较高风险":
	  return "orange";
	  break;
	case "一般风险":
	  return "yellow";
	  break;
	case "低风险":
	  return "green";
	  break;    	  
	default:
	  return "#00BCD4";
	  
	}	
}

function getHighRiskStyle(n){
	
	switch(n)
	{
	case 1:
	  return "pue-red-div"; 	  
	  break;
	case 2:
	  return "pue-orange-div";
	  break;
	case 3:
	  return "pue-yellow-div";
	  break;
	case 4:
	  return "pue-green-div";
	  break;
	case 0:
	  return "pue-purple-div";
	  break;    	  
	default:
	  return "pue-div";
	  
	}
}



/**
 * 获取当前adm
 * @creater zhouxin
 */
function getCurAdm(){
	return $("#EpisodeID",window.parent.document).val();
}

/**
* 公共弹出界面
* @author zhouxin
*/
function commonShowWin(option){
		option.url=option.url+"&MWToken="+websys_getMWToken();
		var content = '<iframe src="'+option.url+'" scrolling="auto" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1110,
			height: 600,
			closed: false,
			content: content,
			modal: true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin" style="overflow:hidden;"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}
function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}
function selectHighRisk(){
	var EpisodeID=$("#EpisodeID").val();
	var url='dhcpue.highrisk.tree.csp?EpisodeID='+EpisodeID;
	try{
		window.parent.commonShowWin({url:url,title:'高危评级',height:520,width:750,collapsible:true,modal:false,top:10})
	}catch(e){
		commonShowWin({url:url,title:'高危评级',height:520,width:750,collapsible:true,modal:false,top:10})
	}
	
}

/**
* 查询病历类容
*/
function view(type,emrId){
	runClassMethod("web.DHCPUEEmrItm","findByEmrId",{'type':type,'emrId':emrId},function(data){
			//try{ 
			fillBlock(data);
			//}catch(e){alert(e.message)}
	},'json',false)
}
/**
*查询病人基本信息
*/
function GetPatEssInfo(adm){
	runClassMethod("web.DHCPUECommonData","GetPatEssInfo",{'EpisodeID':adm,'LgUserID':LgUserID},function(data){ 
		fillBlock(data);
	},'json')	
}
/**
*查询儿保基本信息（不同方法区孕产妇和儿保数据差异）
*/
function GetChildInfo(adm){
	runClassMethod("web.DHCPUECommonData","GetChildInfo",{'EpisodeID':adm},function(data){ 
		fillBlock(data);
	},'json')	
}
/**
* Dhc_PueEmrItm
* @通用保存到病历字典
* @param type 	 	|string 	|表单类型
* @param adm  	 	|string 	|病人就诊id
* @param handler 	|function 	|回调函数
* @param container  |string  	|jquery容器id/表单容器id
* @param params  	|string  	|入参和container互斥，同时存在，params优先级高于container
* @author zhouxin
*/
function CommonSaveEmr(type,adm,handler,container,params){
	if("undefined"==typeof(params)){
		params=pueloopStr(container);
	}
	runClassMethod("web.DHCPUEEmrItm","save",
	{
		type:type,
		adm:adm,
		params:params,
		LgUserID:LgUserID,
		LogInfo:LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID //hxy 2020-07-17
	},function(ret){
			if("function"==typeof(handler)){
				handler(ret);  //回调函数
			}
			getErrMsg(ret);
	},"text");
}
///保存建卡模板
function CommonSaveBuildCard(type,adm,handler,container,params){
	if("undefined"==typeof(params)){
		params=loopStr(container);
	}
	runClassMethod("web.DHCPUEEmrItm","savePersonEmrItm",
	{
		type:type,
		adm:adm,
		params:params,
		LgUserID:LgUserID
	},function(ret){
			if("function"==typeof(handler)){
				handler(ret);  //回调函数
			}
			getErrMsg(ret);
	},"text");
}
function getErrMsg(code){
	code=Number(code)
	switch(code)
	{
	case 0:
	  $.messager.alert('提示','保存成功'); 	  
	  break;
	case -3:
	  $.messager.alert('提示','保存失败:请先进行首次产检');
	  break;
	case -4:
	  $.messager.alert('提示','保存失败:表单类型不能为空');
	  break;
	case -4000:
	  $.messager.alert('提示','保存失败:已签名,不能修改');
	  break;
	case -5000:
	  $.messager.alert('提示','保存失败:已经终止妊娠');
	  break;
	case -6000:
	  $.messager.alert('提示','保存失败:已经提交,不能修改');
	  break;   
	case -7000:
	  $.messager.alert('提示','保存失败:病人未建档');
	  break;  
//	case -7001:
//	  $.messager.alert('提示','保存失败:病人未首次产检');
//	  break;
	case -7002:
	  $.messager.alert('提示','保存失败:病人建档未填写产妇条码');
	  break;
	case -7003:
	  $.messager.alert('提示','保存失败:未填写高危评级');
	  break;
	case -7004:
	  $.messager.alert('提示','保存失败:未填写此专案记录');
	  break;
	case -8000:
	  $.messager.alert('提示','保存失败:非本人病历不能操作');
	  $("#datagrid").datagrid('reload');
	  break;	  
	case -9000:
	  $.messager.alert('提示','保存失败:未开产前筛查医嘱');
	  break;
	case -9001:
	  $.messager.alert('提示','保存失败:未开产前诊断医嘱');
	  break;
	case -9002:
	  $.messager.alert('提示','保存失败:检验结果未出');
	  break;
	case -9003:
	  $.messager.alert('提示','保存失败:检验结果未出');
	  break;	   	        	  
	default:
	  $.messager.alert('提示','保存失败:'+code);
	  
	}
}
function historyTitleByCode(n){
	switch(n)
	{
	case 1:
	  return "高危评估"; 	  
	  break;
	case 2:
	  return "产前筛查";
	  break;
	case 3:
	  return "盆骨测量";
	  break;
	case 4:
	  return "检验";
	  break;
	case 5:
	  return "检查";
	  break;
	case 6:
	  return "产前诊断";
	  break;
	case 7:
	  return "备注";
	  break;
	case 8:
	  return "医嘱";
	  break; 
	case 9:
	  return "诊断";
	  break; 
	case 10:
	  return "TCT";
	  break;
	case 11:
	  return "NT";
	  break;	                 	  
	default:
	  return "";
	  
	}
}
/**
* @通用引用界面
* @param type 	 	|string 	|引用类型
*					 1：高危评估
*					 2：产前筛查
*					 3：盆骨测量
*					 4：检验 
*					 5：检查
*					 6：产前诊断
*					 7：备注 
*					 8：医嘱
*					 9：诊断
*					 10：TCT
*					 11：NT   
* @author zhouxin
*/
function CommonQuote(type,ElementId,emrType){
	
	var title=historyTitleByCode(type)
	var ElementId=typeof(ElementId)=="string"?ElementId:"";
	var emrType=typeof(emrType)=="string"?emrType:"review";
	var EpisodeID=$("#EpisodeID").val();			
	window.parent.commonShowWin({
		url:"dhcpue.quote.csp?EpisodeID="+EpisodeID+"&ElementId="+ElementId+"&Type="+type+"&emrType="+emrType,
		title:title	
	})
}

///
function checkRequired(){
	
	ret =true;
	$("#from").find("em").html("*");
	$(".hisui-validatebox").each(function(){
		
		type=$(this).next().find("input").first().attr("type")
		var id=$(this).attr("id")
		if(type=="checkbox"){
		  if($("input[type=checkbox]", $(this).next()).length>0){
			if($("input[type=checkbox]:checked", $(this).next()).length==0){
				
				$("#"+id).find("em").html("*该项为必填项");
				if(ret){
					$("html,body").stop(true);$("html,body").animate({scrollTop: $("#"+id).offset().top}, 1000);	
				}
				ret=false;
			}
			
		  };	
		}
		if(type=="radio"){
			if($("input[type=radio]", $(this).next()).length>0){
				if($("input[type=radio]:checked", $(this).next()).length==0){
					$("#"+id).find("em").html("*该项为必填项");
					if(ret){
						$("html,body").stop(true);$("html,body").animate({scrollTop: $("#"+id).offset().top}, 1000);	
					}
					ret=false;
				}
				
			};
		}	
	})
	if(!ret)return ret;
	ret=$("#from").form('validate'); 
	//alert($(".validatebox-text.validatebox-invalid:first").parent().html())
	//alert(ret)
	return ret;
}
function getAdm(){
	var frm=window.parent.document.forms["fEPRMENU"];
	if(frm){
		if(frm.EpisodeID){
			return frm.EpisodeID.value;	
		}	
	}else if($("#EpisodeID",window.parent.document).length>0){
		return $("#EpisodeID",window.parent.document).val();	
	}else if($("#EpisodeID").length>0){
		return $("#EpisodeID").val();	
	}
	return "";	
}
/**
* @通用弹出div层
* @param 	width 	 	|string 	|宽度
* @param 	height 	 	|string 	|高度
* @param 	code 	 	|string 	|病历字典code
* @param 	adm 	 	|string 	|就诊表ID
* @param 	input 	 	|string 	|入参
* @param 	emrType 	|string 	|表单类型
* @param	columnsStr	|string		|列字符串,为空通过code取
* @param 	htmlType 	|string 	|html类型
*						input
*						radio
*						checkbox
* @param 	htmlTypeRule|string 	|input 输入类型
* @author zhouxin
*/
function divComponent(opt){
		var emrType=opt.emrType;
		if(emrType==undefined){
			emrType='review';
		}
		var option={
			width: 400,
			height: 70,
			emrType:emrType,
			htmlType:'radio',
			columnsStr:'',
			foetus:1,
			htmlTypeRule:''
		}
		
		$.extend(option,opt);
		//获取胎数
		var foetus = 1;
		if ((option.firfetusnum==undefined) || (option.firfetusnum=="")) {
			foetus = serverCall("web.DHCPUECommon","GetFoetus",{adm:option.adm});
		} else {
			foetus = option.firfetusnum;
		}
	
		if(foetus>0){
			option.foetus=foetus
		}
		if ($("#win").length > 0){
			$("#win").remove();
		}	
		///创建弹出窗体
		var btnPos=option.tarobj.offset().top+ option.height;
		var btnLeft=option.tarobj.offset().left - tleft;
		
		if(option.foetus>1){
			option.height=option.height+32*(option.foetus-1)
		}
		
		$(document.body).append('<div id="win" style="width:'+ option.width +'px;height:'+option.height+'px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#eee;"></div>') 
		var html='<div id="mydiv" class="hisui-layout" fit=true style="background-color:#eee;">'
		html=html+' <div data-options="region:\'center\',title:\'\',border:false,collapsible:false" style="background-color:#eee;">';
		var columns=option.columnsStr
		if(columns==""){
			columns=serverCall("web.DHCPUEEmrType","getSubByCode",{emrType:option.emrType,code:option.code})
		}
		
		var columnsArr=columns.split("^");
			
		var inpuArr=[];
		if(option.input!=""){
			inpuArr=option.input.split("/");
		}
		html=html+'<table id="divTable" border="1" cellspacing="0" cellpadding="1" class="form-table" style="width:100%!important">';
		for(var i=0;i<option.foetus;i++){
			html=html+'<tr>';
				
				html=html+'<td>胎'+parseInt(i+1)+'</td>';
				if((option.htmlType=="radio")||(option.htmlType=="checkbox")){
					for(var j=0;j<columnsArr.length;j++){
						html=html+'<td>';
						html=html+'<input  type="'+option.htmlType+'" value="'+columnsArr[j]+'" name="'+option.code+i+'"';
						if(inpuArr.length>=i){
							if(inpuArr[i]==columnsArr[j]){
								html=html+'checked=checked';
							}
						}
						html=html+' >'
						html=html+'<label for="'+option.code+i+'" style="margin-top=:-3px">'+columnsArr[j]+'</label>'
						html=html+'</td>'
					}
				}
				if(option.htmlType=="input"){
						html=html+'<td>';
						html=html+'<input style="height:22px"  type="input"  name="'+option.code+i+'"';
						if((inpuArr.length>0)&&(inpuArr.length>=i)&&(inpuArr[i]!=undefined)){
							html=html+'value='+inpuArr[i];
						}
						if (option.htmlTypeRule="number"){
							html=html+" onkeyup='clearNoNum(this)' ";
						}	
						html=html+' >';
						html=html+'</td>'
				}
			html=html+'</tr>';
		}
		html=html+'</table>';
		html=html+'	</div>';
		html=html+' <div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;height:30px;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >保存</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >关闭</a>';
		html=html+'	</div>';
		html=html+'</div>';
		$("#win").append(html);	
		$("#win").show();
		$.parser.parse($("#win"));
		var tleft = "";
		if((option.tarobj.offset().left+500)>document.body.offsetWidth){
			tleft= 500 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
		$("#win").css("left",option.tarobj.offset().left - tleft);
		$("#win").css("top",option.tarobj.offset().top+ option.tarobj.outerHeight());
		//一胎的情况选radio选择了就关闭窗口
		if(option.foetus==1){
			$("#divTable").find("input[type='radio']").change(function() {
				$(option.tarobj).val($(this).val())
				$("#win").remove();	
			})
		}
		$("#divTable").find("td").children().eq(0).focus();
		$("#saveDivWinBTN").on('click',function(){
				var retArr=[];
				$("#divTable").find("tr").each(function(){
				    
				    var rowData="";
				    if("radio"==option.htmlType){
					    rowData=$(this).find("input[type='radio']:checked").val()
					}
					if("input"==option.htmlType){
						var tdArr = $(this).children();
					    rowData = tdArr.eq(1).find('input').val();//收入金额
					}
				    retArr.push(rowData)
				});
				$(option.tarobj).val(retArr.join("/"))
				$("#win").remove();
		})

		$("#removeDivWinBTN").on('click',function(){
				$("#win").remove();
		})
		$(document).keyup(function(event){

			switch(event.keyCode) {
				case 27:
					$("#win").remove();
			}
		});
}
function clearNoNum(obj){ 
     obj.value = obj.value.replace(/[^\d.]/g,""); //清除“数字”和“.”以外的字符 
     obj.value = obj.value.replace(/\.{2,}/g,"."); //只保留第一个. 清除多余的 
     obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
     obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//只能输入两个小数 
     if(obj.value.indexOf(".")< 0 && obj.value !=""){//以上已经过滤，此处控制的是如果没有小数点，首位不能为类似于 01、02的金额 
     obj.value= parseFloat(obj.value); 
     } 
}
function enableEdit(){
	if($("#ViewFlag",window.parent.document).val()==1){
		$('input').removeAttr('onclick');
		$(".hisui-linkbutton").remove();
	}		
}
function enableEdit_screen(){
	if(view == 1){
		$('input').removeAttr('onclick');
		$(".hisui-linkbutton").not($('a:contains("打印")')).remove();
	}		
}
function SaveCASign(EmrType,EmrCode,adm)
{

	try{
		var rtn = dhcsys_getcacert();
		if (!rtn.IsSucc) {alert("证书未登录,请重新登录证书!");return false;}
		//alert(rtn.CAUserCertCode)
		var ordInfo=adm;
		var ContainerName=rtn.ContainerName;  //证书容器名
		var UserCertCode=rtn.CAUserCertCode;  //证书用户唯一标识
		if (ContainerName!=""){
			var hash = rtn.ca_key.HashData(ordInfo)
			//alert(hash)
			//该科室需签名
			signedRtn = rtn.ca_key.SignedData(hash,ContainerName);
			//alert(signedRtn)
			if (signedRtn==""){
				alert("签名失败!");
				return false;
			}else{
				var ret=serverCall("web.DHCPUESignVerify","SaveCASign",{ContentHash:ordInfo,
																		CertCode:UserCertCode,
																		Cert:ContainerName,
																		SignedData:signedRtn,
																		LgUserID:LgUserID,
																		Adm:adm,
																		EmrCode:EmrCode});
				//alert(ret)
				return true;	
			}
		}else{
			alert("证书为空!");
			return false;	
		}
	
	}catch(e){alert(e.message)}
	/*
	//ExpStr如果是科室提交  PAADM%站点ID
	var IsVerifyCA=serverCall("CA.DigitalSignatureService","IsCACTLoc",{CTLocID:LgCtLocID});
	if (IsVerifyCA==1)
   	{
		var obj={
				Data:adm,
				ExpStr:EmrType+"^"+LgUserID+"^"+EmrType
		};
				 
		var result = window.showModalDialog("dhcpue.ca.verify.csp", obj, "dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		if ((result=="")||(result=="undefined")||(result==null)) 
		{
			alert("没有效签名,无法审核");
			return false;
		}
		return true;	
   }
   else{
	   return true;
   }
   */
}

function loopStr(container){
		var ret=new Array()
		var target = $(document);
		if(container) {
			target = $(container);
		}
		// validatebox&input&textarea
		ipts = jQuery("input[name], textarea[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				//combobox 和datebox 隐藏在inputt的值过滤
				if(jQuery(this).hasClass('combo-value')){
					return true;
				}	
				var type=jQuery(this).attr('type')
				//过滤checkbox和radio
				if((type=="checkbox")||(type=="radio")){
					return true;
				}
				var val = $.trim(jQuery(this).val());
				ret.push(name+":"+val);
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = jQuery(this).val();
				ret.push(name+":"+val);
			});
		}
		// combo&datebox

		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboname]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboname');
					if (jQuery(this).hasClass(type+'-f')){
						if (jQuery(this)[type]('options').multiple){
							var val = jQuery(this)[type]('getValues');
							val=val.replace(/:/g," ")
							if(val.length>0){
								ret.push(name+":"+val);
							}
						} else {
							var val = jQuery(this)[type]('getValue');
							//kml 2019-11-23 
							//val=val.replace(/:/g," ")
							//if(val.length>0){    2019-11-28 注释
							//	ret.push(name+":"+val);
							//}
                            ret.push(name+":"+val);
							
						}
						break;
					}
				}
			});
		}
	
		
		// radio
		var ipts = jQuery("input[name][type=radio]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				
				if((jQuery(this).attr("data-type")==undefined)||("radio-input"==jQuery(this).attr("data-type"))){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							//ret.push(iptsNames[i]+":"+jQuery(this).val());
							ret.push(jQuery(this).attr("data-id")+":"+jQuery(this).val());
							return false;
						}
					});
			
			}
		}
		//checkbox
		var ipts = jQuery("input[name][type=checkbox]", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				if(jQuery(this).attr("data-type")==undefined){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
						}else{
							vals.push("");
						}
					});
					ret.push(iptsNames[i]+":"+vals.join(String.fromCharCode(1)));
				
			}
		}
		return "^"+ret.join("^")+"^";	
}

function onchangeEvent(obj){}
function combobox_change(){}
function combobox_select(){}

//转诊弹窗
function referral(EpisodeID){
	var url = "dhcpue.referral.csp?EpisodeID="+ EpisodeID;
	commonShowWin({
		url:url,
		title:"转诊",	
		height:450,
		width:670
	})
}

// 加载转诊信息
function SetReferralInfo(EpisodeID){
	runClassMethod("web.DHCPUEReferral","Find",{'EpisodeID':EpisodeID},
	function(data){
		if (data!=null){
			var RType="";
			if(data.RType==0){
				RType="转入";
			}
			if(data.RType==1){
				RType="转出";
			}
			if(data.RType!=""){
				$('#referralinfo').html("");
				var List="<span>转诊类型:</span>"+"<span style='margin: 0px 20px 0px 10px; ';>"+RType+"</span>";
				List=List+"<span>转入单位:</span>"+"<span style='margin: 0px 20px 0px 10px; ';>"+data.RToUnit+"</span>";
				List=List+"<span>转诊日期:</span>"+"<span style='margin: 0px 20px 0px 10px; ';>"+data.RDate+"</span>";
				$('#referralinfo').html(List);
				$('input[name=tran][id=TYDMB2]').prop("checked","checked");
				$('#tranbtn').linkbutton('enable');
			}
		}
	},"json")

}

//儿保转诊弹窗 hxy 2020-08-14
function referralChild(EpisodeID){
	var url = "dhcpue.referralchild.csp?EpisodeID="+ EpisodeID;
	commonShowWin({
		url:url,
		title:"转诊",	
		height:450,
		width:670
	})
}

// 结案弹窗 cy 2020-08-31
function terchild(EpisodeID,EmrType,EmrId){
	var url = "dhcpue.terminalchild.csp?EpisodeID="+ EpisodeID+"&EmrType="+EmrType+"&EmrId="+EmrId;
	commonShowWin({
		url:url,
		title:"结案",	
		height:450,
		width:670
	})
}

// 删除按钮权限
function DeleteBtnEdit(){
	var LgParams=LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID;
	runClassMethod("web.DHCPUECommonData","GetConfigBySession",{'Type':'DELETEBTNLIM','LgParams':LgParams},
		function(data){
			if(data !=1){
				$('#Delete').hide();	  
			}
		},"text");
}

function pueloopStr(container){
		var ret=new Array()
		var target = $(document);
		if(container) {
			target = $(container);
		}
		// validatebox&input&textarea
		ipts = jQuery("input[name], textarea[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				//combobox 和datebox 隐藏在inputt的值过滤
				if(jQuery(this).hasClass('combo-value')){
					return true;
				}	
				var type=jQuery(this).attr('type')
				//过滤checkbox和radio
				if((type=="checkbox")||(type=="radio")){
					return true;
				}
				var val = $.trim(jQuery(this).val());
				ret.push(name+":"+val);
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = jQuery(this).val();
				ret.push(name+":"+val);
			});
		}
		// combo&datebox

		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboname]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboname');
					if (jQuery(this).hasClass(type+'-f')){
						if (jQuery(this)[type]('options').multiple){
							var val = jQuery(this)[type]('getValues');
							//val=val.replace(/:/g," ")
							if(val.length>0){
								ret.push(name+":"+val.join(String.fromCharCode(1)));
							}
						} else {
							var val = jQuery(this)[type]('getValue');
							//val=val.replace(/:/g," ")
							if(val.length>0){
								ret.push(name+":"+val);
							}
						}
						break;
					}
				}
			});
		}
	
		
		// radio
		var ipts = jQuery("input[name][type=radio]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				
				if((jQuery(this).attr("data-type")==undefined)||("radio-input"==jQuery(this).attr("data-type"))){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							//ret.push(iptsNames[i]+":"+jQuery(this).val());
							ret.push(jQuery(this).attr("data-id")+":"+jQuery(this).val());
							return false;
						}
					});
			
			}
		}
		//checkbox
		var ipts = jQuery("input[name][type=checkbox]", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				if(jQuery(this).attr("data-type")==undefined){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
						}else{
							vals.push("");
						}
					});
					ret.push(iptsNames[i]+":"+vals.join(String.fromCharCode(1)));
				
			}
		}
		return "^"+ret.join("^")+"^";	
}
/**
 * 通过JSON设置区块数据
 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
 * @param data json字符串或JSON对象
 */
function fillBlock(data,container){
	var json = data;
	if('string'===typeof(data)) json=$.parseJSON(data);
	if(!json) return;
	var target = $(document);
	if(container) {
		target = $(container);
	}
	
	// 遍历并加载数据
	var prefixs=[];
	loopJSON(json);
	
	function loopJSON(json) {
		if(!json) return;
		$.each(json, function(i, d){
			if(null === d) {
				
			} else if('object' === $.type(d)) {
				prefixs.push(i);
				loopJSON(d);
				prefixs.pop();
			} else {
				prefixs.push(i);
				setNameVal(prefixs.join('.'), d);
				prefixs.pop();
			}
		});
	}
	
	function setNameVal(name, val) {
		name = 'undefined'!==typeof(name)? ''+name:'';
		if('' === name) return;
		val = 'undefined'!==typeof(val)? val:'';
		
		// combobox combotree combogrid datetimebox datebox combo
		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = $('[comboname="' + name + '"]', target);
		
		if (ipts.length){
			for(var i=0; i<cbxCls.length; i++){
				var type = cbxCls[i];
				if (ipts.hasClass(type+'-f')){
					if (ipts[type]('options').multiple){
						ipts[type]('setValues', val);
					} else {
						if(-1!=$.inArray(type, ['datetimebox','datebox']) && $.isNumeric(val)) {
							var valDate = new Date();valDate.setTime(val);
							val = $.fn.datebox.defaults.formatter(valDate);
						}
						ipts[type]('setValue', val);
					}
					return;
				}
			}
		}
		
		// numberbox&slider 19-5-9 lp
		var cTypes = ['numberbox', 'slider'];
		for(var i=0;i<cTypes.length;i++) {
			ipts = jQuery("input["+cTypes[i]+"name="+name+"]", target);
			if(ipts.length){
				ipts[cTypes[i]]('setValue', val);
				return;
			}
		}
		
		if(1==1){
		// radio checkbox
		try{
		var opts = $('input[name="'+name+'"][type=checkbox]', target);
		}catch(e){return}
		if(opts.length) {
			opts.attr('checked',false);
			if(val==""){
				return;	
			}
			val=val.split(",");
			opts.each(function(){
				var f = $(this);
				
				if ('array'==$.type(val) && val && -1!==$.inArray(f.val(), val)
						|| f.val() == String(val)){
				//if(f.val() == String(val)){
					f.prop('checked', true);
					//f.iCheck('check');
					//f.attr("checked", true);
				}
			});

			return;
		}
		}
		
		//radio
		try{
			var opts = $('input[name="'+name+'"][type=radio]', target);
		}catch(e){console.error(e.message)}
		if(opts.length) {
			opts.attr('checked',false);
			if(val==""){
				return;	
			}
			opts.each(function(){
				var f = $(this);
				if ( f.val() == String(val)){
					f.prop('checked', true);
				}
			});

			return;
		}
		
		// input
		f = $('input[name="'+name+'"]', target);
		if(f && f.length){
			f.val(val);
			return;
		}
		
		// textarea
		f = $('textarea[name="'+name+'"]', target);
		if(f && f.length) {
			f.val(val);
			return;
		}
		// select
		f = $('select[name="'+name+'"]', target);
		if(f && f.length) {
			if(f.hasClass('multiselect2side')) {
				f['multiselect2side']('setValue',val);
			} else {
				f.val(val);
			}
			return;
		}
	}
};
