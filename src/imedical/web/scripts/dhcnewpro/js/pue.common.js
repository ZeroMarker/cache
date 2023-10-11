/**
 * ��ȡ��Σhtml
 * @creater zhouxin
 * @param score ��Σ����
 */
function getHighRiskText(n){
	switch(n)
	{
	case 1:
	  return "��"; 	  
	  break;
	case 2:
	  return "��";
	  break;
	case 3:
	  return "��";
	  break;
	case 4:
	  return "��";
	  break;
	case 0:
	  return "��";
	  break; 
	case -1:
	  return "��";
	  break;  	  
	default:
	  return "";
	}
}

function getHighRiskResult(n){
	switch(n)
	{
	case "1,1":
	  return "��Ⱦ��+�߷���"; 	  
	  break;
	case "2,1":
	  return "��Ⱦ��+�ϸ߷���";
	  break;
	case "3,1":
	  return "��Ⱦ��+һ�����";
	  break;  
	case "1,0":
	  return "�߷���";
	  break; 
	case "2,0":
	  return "�ϸ߷���";
	  break;
	case "3,0":
	  return "һ�����";
	  break;	 
	case "4,0":
	  return "�ͷ���";
	  break; 
	default:
	  return "";
	}
}

/**
 * ��ȡ��Σ��ɸ��ȼ�����
 * @creater lvpeng
 * @param ��Σ���ֺ�ɸ�鱳��ɫ
 */
function getHighRiskColorStyle(str){
	switch(str)
	{
	case "��Ⱦ��":
	  return "purple"; 	  
	  break;
	case "�߷���":
	  return "red";
	  break;
	case "�ϸ߷���":
	  return "orange";
	  break;
	case "һ�����":
	  return "yellow";
	  break;
	case "�ͷ���":
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
 * ��ȡ��ǰadm
 * @creater zhouxin
 */
function getCurAdm(){
	return $("#EpisodeID",window.parent.document).val();
}

/**
* ������������
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
		window.parent.commonShowWin({url:url,title:'��Σ����',height:520,width:750,collapsible:true,modal:false,top:10})
	}catch(e){
		commonShowWin({url:url,title:'��Σ����',height:520,width:750,collapsible:true,modal:false,top:10})
	}
	
}

/**
* ��ѯ��������
*/
function view(type,emrId){
	runClassMethod("web.DHCPUEEmrItm","findByEmrId",{'type':type,'emrId':emrId},function(data){
			//try{ 
			fillBlock(data);
			//}catch(e){alert(e.message)}
	},'json',false)
}
/**
*��ѯ���˻�����Ϣ
*/
function GetPatEssInfo(adm){
	runClassMethod("web.DHCPUECommonData","GetPatEssInfo",{'EpisodeID':adm,'LgUserID':LgUserID},function(data){ 
		fillBlock(data);
	},'json')	
}
/**
*��ѯ����������Ϣ����ͬ�������в����Ͷ������ݲ��죩
*/
function GetChildInfo(adm){
	runClassMethod("web.DHCPUECommonData","GetChildInfo",{'EpisodeID':adm},function(data){ 
		fillBlock(data);
	},'json')	
}
/**
* Dhc_PueEmrItm
* @ͨ�ñ��浽�����ֵ�
* @param type 	 	|string 	|������
* @param adm  	 	|string 	|���˾���id
* @param handler 	|function 	|�ص�����
* @param container  |string  	|jquery����id/������id
* @param params  	|string  	|��κ�container���⣬ͬʱ���ڣ�params���ȼ�����container
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
				handler(ret);  //�ص�����
			}
			getErrMsg(ret);
	},"text");
}
///���潨��ģ��
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
				handler(ret);  //�ص�����
			}
			getErrMsg(ret);
	},"text");
}
function getErrMsg(code){
	code=Number(code)
	switch(code)
	{
	case 0:
	  $.messager.alert('��ʾ','����ɹ�'); 	  
	  break;
	case -3:
	  $.messager.alert('��ʾ','����ʧ��:���Ƚ����״β���');
	  break;
	case -4:
	  $.messager.alert('��ʾ','����ʧ��:�����Ͳ���Ϊ��');
	  break;
	case -4000:
	  $.messager.alert('��ʾ','����ʧ��:��ǩ��,�����޸�');
	  break;
	case -5000:
	  $.messager.alert('��ʾ','����ʧ��:�Ѿ���ֹ����');
	  break;
	case -6000:
	  $.messager.alert('��ʾ','����ʧ��:�Ѿ��ύ,�����޸�');
	  break;   
	case -7000:
	  $.messager.alert('��ʾ','����ʧ��:����δ����');
	  break;  
//	case -7001:
//	  $.messager.alert('��ʾ','����ʧ��:����δ�״β���');
//	  break;
	case -7002:
	  $.messager.alert('��ʾ','����ʧ��:���˽���δ��д��������');
	  break;
	case -7003:
	  $.messager.alert('��ʾ','����ʧ��:δ��д��Σ����');
	  break;
	case -7004:
	  $.messager.alert('��ʾ','����ʧ��:δ��д��ר����¼');
	  break;
	case -8000:
	  $.messager.alert('��ʾ','����ʧ��:�Ǳ��˲������ܲ���');
	  $("#datagrid").datagrid('reload');
	  break;	  
	case -9000:
	  $.messager.alert('��ʾ','����ʧ��:δ����ǰɸ��ҽ��');
	  break;
	case -9001:
	  $.messager.alert('��ʾ','����ʧ��:δ����ǰ���ҽ��');
	  break;
	case -9002:
	  $.messager.alert('��ʾ','����ʧ��:������δ��');
	  break;
	case -9003:
	  $.messager.alert('��ʾ','����ʧ��:������δ��');
	  break;	   	        	  
	default:
	  $.messager.alert('��ʾ','����ʧ��:'+code);
	  
	}
}
function historyTitleByCode(n){
	switch(n)
	{
	case 1:
	  return "��Σ����"; 	  
	  break;
	case 2:
	  return "��ǰɸ��";
	  break;
	case 3:
	  return "��ǲ���";
	  break;
	case 4:
	  return "����";
	  break;
	case 5:
	  return "���";
	  break;
	case 6:
	  return "��ǰ���";
	  break;
	case 7:
	  return "��ע";
	  break;
	case 8:
	  return "ҽ��";
	  break; 
	case 9:
	  return "���";
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
* @ͨ�����ý���
* @param type 	 	|string 	|��������
*					 1����Σ����
*					 2����ǰɸ��
*					 3����ǲ���
*					 4������ 
*					 5�����
*					 6����ǰ���
*					 7����ע 
*					 8��ҽ��
*					 9�����
*					 10��TCT
*					 11��NT   
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
				
				$("#"+id).find("em").html("*����Ϊ������");
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
					$("#"+id).find("em").html("*����Ϊ������");
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
* @ͨ�õ���div��
* @param 	width 	 	|string 	|���
* @param 	height 	 	|string 	|�߶�
* @param 	code 	 	|string 	|�����ֵ�code
* @param 	adm 	 	|string 	|�����ID
* @param 	input 	 	|string 	|���
* @param 	emrType 	|string 	|������
* @param	columnsStr	|string		|���ַ���,Ϊ��ͨ��codeȡ
* @param 	htmlType 	|string 	|html����
*						input
*						radio
*						checkbox
* @param 	htmlTypeRule|string 	|input ��������
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
		//��ȡ̥��
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
		///������������
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
				
				html=html+'<td>̥'+parseInt(i+1)+'</td>';
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
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >����</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >�ر�</a>';
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
		//һ̥�����ѡradioѡ���˾͹رմ���
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
					    rowData = tdArr.eq(1).find('input').val();//������
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
     obj.value = obj.value.replace(/[^\d.]/g,""); //��������֡��͡�.��������ַ� 
     obj.value = obj.value.replace(/\.{2,}/g,"."); //ֻ������һ��. �������� 
     obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
     obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//ֻ����������С�� 
     if(obj.value.indexOf(".")< 0 && obj.value !=""){//�����Ѿ����ˣ��˴����Ƶ������û��С���㣬��λ����Ϊ������ 01��02�Ľ�� 
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
		$(".hisui-linkbutton").not($('a:contains("��ӡ")')).remove();
	}		
}
function SaveCASign(EmrType,EmrCode,adm)
{

	try{
		var rtn = dhcsys_getcacert();
		if (!rtn.IsSucc) {alert("֤��δ��¼,�����µ�¼֤��!");return false;}
		//alert(rtn.CAUserCertCode)
		var ordInfo=adm;
		var ContainerName=rtn.ContainerName;  //֤��������
		var UserCertCode=rtn.CAUserCertCode;  //֤���û�Ψһ��ʶ
		if (ContainerName!=""){
			var hash = rtn.ca_key.HashData(ordInfo)
			//alert(hash)
			//�ÿ�����ǩ��
			signedRtn = rtn.ca_key.SignedData(hash,ContainerName);
			//alert(signedRtn)
			if (signedRtn==""){
				alert("ǩ��ʧ��!");
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
			alert("֤��Ϊ��!");
			return false;	
		}
	
	}catch(e){alert(e.message)}
	/*
	//ExpStr����ǿ����ύ  PAADM%վ��ID
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
			alert("û��Чǩ��,�޷����");
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
				//combobox ��datebox ������inputt��ֵ����
				if(jQuery(this).hasClass('combo-value')){
					return true;
				}	
				var type=jQuery(this).attr('type')
				//����checkbox��radio
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
							//if(val.length>0){    2019-11-28 ע��
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

//ת�ﵯ��
function referral(EpisodeID){
	var url = "dhcpue.referral.csp?EpisodeID="+ EpisodeID;
	commonShowWin({
		url:url,
		title:"ת��",	
		height:450,
		width:670
	})
}

// ����ת����Ϣ
function SetReferralInfo(EpisodeID){
	runClassMethod("web.DHCPUEReferral","Find",{'EpisodeID':EpisodeID},
	function(data){
		if (data!=null){
			var RType="";
			if(data.RType==0){
				RType="ת��";
			}
			if(data.RType==1){
				RType="ת��";
			}
			if(data.RType!=""){
				$('#referralinfo').html("");
				var List="<span>ת������:</span>"+"<span style='margin: 0px 20px 0px 10px; ';>"+RType+"</span>";
				List=List+"<span>ת�뵥λ:</span>"+"<span style='margin: 0px 20px 0px 10px; ';>"+data.RToUnit+"</span>";
				List=List+"<span>ת������:</span>"+"<span style='margin: 0px 20px 0px 10px; ';>"+data.RDate+"</span>";
				$('#referralinfo').html(List);
				$('input[name=tran][id=TYDMB2]').prop("checked","checked");
				$('#tranbtn').linkbutton('enable');
			}
		}
	},"json")

}

//����ת�ﵯ�� hxy 2020-08-14
function referralChild(EpisodeID){
	var url = "dhcpue.referralchild.csp?EpisodeID="+ EpisodeID;
	commonShowWin({
		url:url,
		title:"ת��",	
		height:450,
		width:670
	})
}

// �᰸���� cy 2020-08-31
function terchild(EpisodeID,EmrType,EmrId){
	var url = "dhcpue.terminalchild.csp?EpisodeID="+ EpisodeID+"&EmrType="+EmrType+"&EmrId="+EmrId;
	commonShowWin({
		url:url,
		title:"�᰸",	
		height:450,
		width:670
	})
}

// ɾ����ťȨ��
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
				//combobox ��datebox ������inputt��ֵ����
				if(jQuery(this).hasClass('combo-value')){
					return true;
				}	
				var type=jQuery(this).attr('type')
				//����checkbox��radio
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
 * ͨ��JSON������������
 * @param container dom���󣬿����ǣ�domԪ�ص�id | jQueryѡ���� | dom���� | jQuery����
 * @param data json�ַ�����JSON����
 */
function fillBlock(data,container){
	var json = data;
	if('string'===typeof(data)) json=$.parseJSON(data);
	if(!json) return;
	var target = $(document);
	if(container) {
		target = $(container);
	}
	
	// ��������������
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
