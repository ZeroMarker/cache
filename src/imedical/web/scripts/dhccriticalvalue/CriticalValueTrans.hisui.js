;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);
GV.util={
	debounce:function(func, wait, immediate) {
	    var timeout, result;
	    var debounced = function () {
	        var context = this;
	        var args = arguments;

	        if (timeout) clearTimeout(timeout);
	        if (immediate) {
	            // 如果已经执行过，不再执行
	            var callNow = !timeout;
	            timeout = setTimeout(function(){
	                timeout = null;
	            }, wait)
	            if (callNow) result = func.apply(context, args)
	        }
	        else {
	            timeout = setTimeout(function(){
	                func.apply(context, args)
	            }, wait);
	        }
	        return result;
	    };

	    debounced.cancel = function() {
	        clearTimeout(timeout);
	        timeout = null;
	    };

	    return debounced;
	},
	formatPAPMINO:function(no){
		no+='';
		if(no!=""){
			while(no.length<10){
				no=0+''+no;
			}	
		}
		return no;
	},
	easyModal:function(title,url,width,height){
		var $easyModal=$('#easyModal');
		if ($easyModal.length==0){
			$easyModal=$('<div id="easyModal" style="overflow:hidden;"><iframe name="easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
		}
		var maxWidth=$(window).width(),maxHeight=$(window).height();
		width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
		height=''+(height||'80%'),height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
		$easyModal.find('iframe').attr('src',url);
		$easyModal.dialog({
			iconCls:'icon-w-paper',
			modal:true,
			title:title,
			width:width,
			height:height
		}).dialog('open').dialog('center');
		
	}
}
GV.BaseInfoCP={  
	0:'IDValField', //登记号
	1:'PatNameValField',
	2:'SexValField',
	3:'AgeValField',
	4:'MedCareValField',
	7:'AppDepValField',
	8:'AppDocValField',
	13:'TelValField',
	5:'ArcItemValField'
}
GV.setBaseInfo=function(baseInfo){
	var baseArr=baseInfo.split("\\");
	for (var i in GV.BaseInfoCP){
		$('#'+GV.BaseInfoCP[i]).text(baseArr[i]);
	}
	//$('#BBNoValField').text(GV.epis);
	$('#BBNoValField').text(GV.epis.replace(/--/ig,'||')); //把双-换成双|
	 
}
GV.setResultInfo=function(resultInfo){
	$('#RepResult').html(resultInfo);
}
GV.setContactInfo=function(contactInfo){
	var contactArr=contactInfo.split("\\");
	$('#Contact').val(contactArr[0]);
	$('#ContactTel').val(contactArr[1]);
	if (contactArr[2]=="已通知"){
		$('#ConResult').combobox('setValue',"F");
	}else if(contactArr[2]=="未通知"){
		$('#ConResult').combobox('setValue',"C");
	}
	var $TransAdvice=$('#TransAdvice');
	if ($TransAdvice.length>0 && typeof contactArr[3]=="string"){
		$TransAdvice.val( contactArr[3].replace(/\$c\(92\)/ig,'\\').replace(/\$c\(94\)/ig,'^'));
	}
	
}
GV.initInfo=function(){
	/*$.m({
		ClassName:'web.DHCAntCVReportSearch',
		MethodName:'GetPanicReportInfo',
		epis:GV.epis,
		RepType:GV.RepType
		},function(rtn){
			//console.log(rtn);
			GV.setBaseInfo(rtn);
		}
	)
	$.m({
		ClassName:'web.DHCAntCVReportSearch',
		MethodName:'GetPanicReportResult',
		ReportId:GV.ReportId,
		RType:GV.RepType
		},function(rtn){
			//console.log(rtn);
			GV.setResultInfo(rtn);
		}
	)
	$.m({
		ClassName:'web.DHCCVCommon',
		MethodName:'GetCantactInfo',
		reportid:GV.ReportId,
		RepType:GV.RepType
		},function(rtn){
			//console.log(rtn);
			GV.setContactInfo(rtn);
		}
	)

	$.m({
		ClassName:'web.DHCAntCVReportNameQuery',
		MethodName:'GetPanicName',
		DPRPType:GV.RepType
		},function(rtn){
			//console.log(rtn);
			GV.RepTypeDesc=rtn;
			$('#BBNoValField').closest('td').prev('td').text(rtn+'号:'); //还原老版 类型+号
		}
	)*/

}
var init=function(){
	if (GV.SendTime>1){
		$.m({
			ClassName:'web.DHCAntCVSend',
			MethodName:'GetSendHistory',
			reportID:GV.RepType+'||'+GV.ReportId,
			SendTime:GV.SendTime
			},function(rtn){
				rtn=$.parseJSON(rtn);
				
				var items=[];
				$.each(rtn,function(i,c){
					var o={};
					o.text='第'+c.SendTime+'发送 '+c.CreateDate+' '+c.CreateTime
					o.type='section',
					o.items=[];
					$.each(c.rows,function(i,r){
						o.items.push({text:r.UserName,id:'Det-'+r.DetailsId});
					})
					items.push(o);
				})
				//console.log(items);
				$('#SendHistory').keywords({
					items:items
				}).off('click');
				
				$('#SendHistory').find('ul.kw-section-list').append('<div style="clear:both"></div>');
				var c=$('#SendHistory-P').closest('.container');
				c.height(c.height()+($('#SendHistory')._outerHeight()-$('#SendHistory-P').height()));
				$('#SendHistory-P').panel('resize');
				
			}
		)
	}
	if (GV.ShowTransAdvice=="1") {
		$('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
	}else{
		$('#TransAdvice-TR').hide();
	}
	GV.openEditEmr=function(){
		if ($.trim(GV.EmrEditLink)=="") {
			$.messager.alert("提示","尚未维护病历书写链接！",'warning');
			return;
		}
		if (GV.AllowEditEmrInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
			$.messager.alert("提示","当前登录科室与病人所在科室不符，不能写病历",'warning');
			return;
		}
		$.m({ClassName:'web.DHCAntCVReportTrans',MethodName:'GetLatestTransEmr',reportID:GV.RepType+'||'+GV.ReportId},function(ret){
			var InstanceID=parseInt(ret)>0?ret:'';
			var link=getOtherLink(GV.EmrEditLink,{InstanceID:InstanceID});
			var maxWidth=screen.availWidth-20;
			var maxHeight=screen.availHeight-40;
			var w=parseInt(maxWidth*0.8),h=parseInt(maxHeight*0.8),l=parseInt((maxWidth-w)/2),t=parseInt((maxHeight-h)/2);
			
			if (!window.opener && window.top.websys_showModal && window.top.document.body['clientWidth']>w){
				websys_showModal({title:'危急值病历',url:link,width:'90%',height:'90%',iconCls:'icon-w-paper'});
				return false;
			}
			
			var features='top='+t+',left='+l+',width='+w+',height='+h+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes'
			var openWin=getOpenWindow();
			openWin.open(link,'CVTransEmrWin',features);					
											
		})
	}
	GV.openEditOrder=function(){
		if ($.trim(GV.OrderEditLink)=="") {
			$.messager.alert("提示","尚未维护医嘱录入链接！",'warning');
			return;
		}
		if (GV.AllowEditOrderInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
			$.messager.alert("提示","当前登录科室与病人所在科室不符，不能开医嘱",'warning');
			return;
		}
		
		var link=getOtherLink(GV.OrderEditLink);
		var maxWidth=screen.availWidth-20;
		var maxHeight=screen.availHeight-40;
		var w=parseInt(maxWidth*0.8),h=parseInt(maxHeight*0.8),l=parseInt((maxWidth-w)/2),t=parseInt((maxHeight-h)/2);
		

		var features='top='+t+',left='+l+',width='+w+',height='+h+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes'
		
		var openWin=getOpenWindow();
		var cylink=getOtherLink(GV.CYOrderEditLink);
		
		var mylink="criticalvalue.oeord.csp?p1="+encodeURIComponent(link)+"&p2="+encodeURIComponent(cylink);
		
		if (!window.opener && window.top.websys_showModal && window.top.document.body['clientWidth']>w){
			websys_showModal({title:'危急值医嘱',url:mylink,width:'90%',height:'90%',iconCls:'icon-w-paper'});
			return false;
		}
		openWin.open(mylink,'CVTransOrderWin',features);
	}

	///获取open要调用哪个窗口的open
	function getOpenWindow(){
		if ((GV.openMode==3 || GV.openMode==3)&&(window.opener)){
			return window.opener;
		}else if(GV.openMode=="4" && window.dialogArguments &&window.dialogArguments.open) {
			return window.dialogArguments;
		}else{
			return window;
		}
	}
	function formatByJson(template,data){
		if ("string" == typeof data ){
			data = $.parseJSON(data);
		}
		// template + data生成数据html
		return template.replace(/\{(.+?)\}/ig,function(m,i,d){
				return data[i]||'';
		}) ;
	}
	//根据配置的链接模板字符串，获取实际链接
	function getOtherLink(linkTmpl,data){
		data=data||{};
		//链接中的{key}进行替换
		var obj={
			EpisodeID:GV.EpisodeID,
			UserCode:GV.UserCode,
			UserID:GV.UserId,
			GroupID:GV.GroupId,
			CTLocID:GV.LocId,
			AntCVID:GV.reportID,
			PatientID:GV.PatientID,
			mradm:GV.mradm||''
		}
		$.extend(obj,data);
		//调用websys.jquery.js中的 $.formatByJson
		var link=formatByJson(linkTmpl,obj);	
		//alert(link);
		return link;	
	}
	
	if (GV.CareProvType=="DOCTOR") { //
		if (GV.ShowEditEmr=="1" ){
			$('<a id="btnTransEMR" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">写病历</a>').prependTo('#buttons').linkbutton({
				onClick:function(){
					//alert('写病历')	
					GV.openEditEmr();
				}
			})
			if (GV.AllowEditEmrInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
				$('#btnTransEMR').linkbutton('disable').attr('title','当前登录科室与病人所在科室不符，不能写病历');
			}
		}
		if (GV.ShowEditOrder=="1"){
			$('<a id="btnTransORD" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">开医嘱</a>').prependTo('#buttons').linkbutton({
				onClick:function(){
					//alert('开医嘱')	
					GV.openEditOrder();
				}
			})
			if (GV.AllowEditOrderInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
				$('#btnTransORD').linkbutton('disable').attr('title','当前登录科室与病人所在科室不符，不能开医嘱');
			}
		}
	}

	GV.epis=GV.ReportId.split("||")[0];
	$('#ConResult').combobox({
		textField:'text',
		valueField:'value',
		data:[{value:'F',text:'已通知'},{value:'C',text:'未联系到'}],
		panelHeight:'auto',
		editable:false
	})
	
	function checkTransOrd(reportID,status,after){
		GV.requestMsg='正在校验医嘱关联信息';
		$.m({
			ClassName:'web.DHCAntCVReportTrans'	,MethodName:'CheckTransOrd',
			reportID:reportID,
			trExecResult:status
			},function(rtn){
				GV.requestMsg='';
				if (rtn=='-100'){
					var msg="需要先开医嘱再进行处理"
					if(GV.CareProvType=="DOCTOR") msg+=',点击确定开医嘱';
					else  msg+=',请联系医生';
					$.messager.alert('失败',msg,'error',function(){
						if(GV.CareProvType=="DOCTOR"){
							GV.openEditOrder();
						}
					});
				}else if (rtn=='-200'){
					if(GV.CareProvType=="DOCTOR") var msg="还未开医嘱，是否继续？点击确定继续处理，点击取消去开医嘱";
					else var msg="还未开医嘱，是否继续？点击确定继续处理"
					$.messager.confirm("提示",msg,function(r){
						if (r){
							if (after) after();
						}else{
							if(GV.CareProvType=="DOCTOR") GV.openEditOrder();
						}
					})
				}else{
					if (after) after();
				}
			}
		)
	}
	function checkTransEMR(reportID,status,after){
		GV.requestMsg='正在校验病历关联信息';
		$.m({
			ClassName:'web.DHCAntCVReportTrans'	,MethodName:'CheckTransEMR',
			reportID:reportID,
			trExecResult:status
			},function(rtn){
				GV.requestMsg='';
				if (rtn=='-100'){
					var msg="需要先写病历再进行处理"
					if(GV.CareProvType=="DOCTOR") msg+=',点击确定写病历';
					else  msg+=',请联系医生';
					$.messager.alert('失败',msg,'error',function(){
						if(GV.CareProvType=="DOCTOR"){
							GV.openEditEmr();
						}
					});
				}else if (rtn==-'200'){
					if(GV.CareProvType=="DOCTOR") var msg="还未写病历，是否继续？点击确定继续处理，点击取消去写病历";
					else var msg="还未写病历，是否继续？点击确定继续处理"
					$.messager.confirm("提示",msg,function(r){
						if (r){
							if (after) after();
						}else{
							if(GV.CareProvType=="DOCTOR") GV.openEditEmr();
						}
					})
				}else{
					if (after) after();
				}
			}
		)	
	}
	
	if (GV.ReceiveMode=='1'){ //显示接收按钮
		$('#btnSave').find('.l-btn-text').text('处理');
		$('<a id="btnReceive" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true,disabled:true" >接收</a>').insertBefore('#btnSave').linkbutton({
			onClick:function(){
				saveReceive();
			}
		})
		var canReceive=false;
		if(GV.reportInfoObj.repStatus=='C') canReceive=true; //目前只有刚创建的可以接收
		
		if (canReceive){
			$('#TransAdvice').closest('td').prev().text('备注');
			$('#btnSave').linkbutton('disable');
			
			if (GV.ShowTransAdvice!="1") { //前面由于不显示意见措施 将框隐藏掉了 在接收时 备注用的同一输入框 要再显示出来
				$('#TransAdvice-TR').show();
				$('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
			}
		}
		$('#btnReceive').linkbutton(canReceive?'enable':'disable');
	}
	
	if (GV.AllowFwDoc=='1'){
		
		$('<a id="btnFwDoc" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true,disabled:true" >转发</a>').insertAfter('#btnSave').linkbutton({
			onClick:function(){
				openFwDoc();
			}
		})
		var canFwDoc=false;
		if(GV.reportInfoObj.repStatus=='Rec' || (GV.ReceiveMode!='1' &&GV.reportInfoObj.repStatus=='C') ) canFwDoc=true;  //接收后才可转发  如果不需要接收 那么刚创建状态也可以转发
		$('#btnFwDoc').linkbutton(canFwDoc?'enable':'disable');
	}
	
	if (GV.reportInfoObj.repStatus=='F'){
		for (var len=GV.reportInfoObj.transArray.length,i=len-1;i>=0;i--){
			var trInfo=GV.reportInfoObj.transArray[i];
			if (trInfo.trOpType=='E' || trInfo.trOpType==''){ //只取处理的
				$('#Contact').val(trInfo.trContact);
				$('#ContactTel').val(trInfo.trPhone);
				$('#ConResult').combobox('setValue',trInfo.trStatus);
				var $TransAdvice=$('#TransAdvice');
				if ($TransAdvice.length>0 && $TransAdvice.is(':visible') && typeof trInfo.trAdvice=="string"){
					$TransAdvice.val( trInfo.trAdvice.replace(/\$c\(92\)/ig,'\\').replace(/\$c\(94\)/ig,'^'));
				}
				break;
			}
			
		}
	}
	
	function openFwDoc(){
		if ($('#FwDoc-Win').length==0){
			$('<div id="FwDoc-Win" style="padding:10px;"><table style="width:100%;">\
				<tr style="height:40px;"><td class="r-label">科室</td><td><input class="textbox" id="FwDoc-Loc"/></td></tr>\
				<tr style="height:40px;"><td class="r-label">医生</td><td><input class="textbox" id="FwDoc-Doc"/></td></tr>\
			</table></div>').appendTo('body');
			$('#FwDoc-Win').dialog({
				closed:true,
				width:350,
				height:200,
				title:'请选择',
				buttons:[{
					text:'确定',
					handler:function(){
						saveFwDoc();
					}	
				},{
					text:'取消',
					handler:function(){
						$('#FwDoc-Win').dialog('close');
					}
				}]	
			})
			$('#FwDoc-Loc').combogrid({
				width:200,
				panelWidth:450,
				delay: 500,
				mode: 'remote',
				url:$URL,
				queryParams:{
					ClassName:'web.DHCAntCVComm',
					QueryName:'LookUpLoc',
					onlySameHosp:1,
					onlyActive:1
				},
				onBeforeLoad:function(param){
					param.desc=param.q;
					return true;
				},
				onSelect:function(row){
					$('#FwDoc-Doc').combogrid('setRemoteValue',{value:'',text:''});
				},
				onLoadSuccess:function(data){
					$('#FwDoc-Doc').combogrid('setRemoteValue',{value:'',text:''});
				},
				idField:"HIDDEN",textField:"Description",
				columns:[[{field:'Description',title:'科室名称',width:200},{field:'Code',title:'科室代码',width:200}]],
				pagination:true
			})
			$('#FwDoc-Doc').combogrid({
				width:200,
				panelWidth:450,
				delay: 500,
				mode: 'remote',
				url:$URL,
				queryParams:{
					ClassName:'web.DHCAntCVComm',
					QueryName:'LookUpUser',
					onlyActive:1,
					UseRes:1,
					CareType:'DOCTOR'
				},
				onBeforeLoad:function(param){
					param.LocId=$('#FwDoc-Loc').combogrid('getValue')||'';
					return true;
				},
				idField:"TId",textField:"TDesc",
				columns:[[{field:'TDesc',title:'姓名',width:100},{field:'TCode',title:'工号',width:100}]],
				pagination:true
			})
		}
		$('#FwDoc-Win').dialog('open');
	}
	function saveFwDoc(){
		if(GV.requestMsg) {$.messager.alert('提示',GV.requestMsg+'，请稍候','warning'); return;}
		var fwLocId=$('#FwDoc-Loc').combogrid('getValue'),
			fwUserId=$('#FwDoc-Doc').combogrid('getValue');
			
		GV.requestMsg='正在转发';
		$.m({
			//reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode
			ClassName:'web.DHCAntCVReportTrans'	,MethodName:'SaveFwDoc',
			reportID:GV.RepType+'||'+GV.ReportId,
			usercode:GV.UserCode
			,fwLocId:fwLocId
			,fwUserId:fwUserId
			},function(rtn){
				GV.requestMsg='';
				if(rtn==0){
					$.messager.alert('成功',"保存成功",'success',function(){
						closeWin();
					});
				}else{
					$.messager.alert('失败',"保存失败"+(rtn.split('^')[1]||rtn),'error');
				}
			}
		)
	}
	
	
	function saveReceive(){
		if(GV.requestMsg) {$.messager.alert('提示',GV.requestMsg+'，请稍候','warning'); return;}
		var Contact=$('#Contact').val();
		var ContactTel=$('#ContactTel').val();
		var ConResult=$('#ConResult').combobox('getValue');
		var TransMemo=$('#ConResult').combobox('getText');
		var TransAdvice=$('#TransAdvice').val()||'';
		TransAdvice=TransAdvice.replace(/\\/g,'$c(92)').replace(/\^/g,'$c(94)');
		
		//if(GV.AdmType!="I"){
			if(Contact==""){
				$.messager.alert("提示",'联系人不能为空！','warning');
				return;
			}
			if(ContactTel==""){
				$.messager.alert('提示',"联系电话不能为空！",'warning');
				return;
			}
		//}
		if (ConResult!="C" && ConResult!="F"){
			$.messager.alert('提示',"请选择联系结果！",'warning');
			return;
		}
		GV.requestMsg='正在保存接收信息';
		$.m({
			//reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode
			ClassName:'web.DHCAntCVReportTrans'	,MethodName:'SaveReceive',
			reportID:GV.RepType+'||'+GV.ReportId,
			contact:Contact,
			contactTel:ContactTel,
			contactResult:ConResult,
			contactResultDesc:TransMemo,
			note:TransAdvice,
			usercode:GV.UserCode
			},function(rtn){
				GV.requestMsg='';
				if(rtn==0){
					$.messager.alert('成功',"保存成功",'success',function(){
						closeWin();
					});
				}else{
					$.messager.alert('失败',"保存失败"+(rtn.split('^')[1]||rtn),'error');
				}
			}
		)
	}
	
	function saveTrans(){
		if(GV.requestMsg) {$.messager.alert('提示',GV.requestMsg+'，请稍候','warning'); return;}
		var Contact=$('#Contact').val();
		var ContactTel=$('#ContactTel').val();
		var ConResult=$('#ConResult').combobox('getValue');
		var TransMemo=$('#ConResult').combobox('getText');
		var TransAdvice=$('#TransAdvice').val()||'';
		TransAdvice=TransAdvice.replace(/\\/g,'$c(92)').replace(/\^/g,'$c(94)');
		if(GV.AdmType!="I"){
			if(Contact==""){
				$.messager.alert("提示",'联系人不能为空！','warning');
				return;
			}
			if(ContactTel==""){
				$.messager.alert('提示',"联系电话不能为空！",'warning');
				return;
			}
		}
		if (ConResult!="C" && ConResult!="F"){
			$.messager.alert('提示',"请选择联系结果！",'warning');
			return;
		}
		
		checkTransOrd(GV.RepType+'||'+GV.ReportId,"F",function(){
			checkTransEMR(GV.RepType+'||'+GV.ReportId,"F",function(){
				GV.requestMsg='正在保存处理信息';
				$.m({
					//reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode
					ClassName:'web.DHCAntCVReportTrans'	,MethodName:'SaveExec',
					reportID:GV.RepType+'||'+GV.ReportId,
					contact:Contact,
					contactTel:ContactTel,
					contactResult:ConResult,
					contactResultDesc:TransMemo,
					note:TransAdvice,
					usercode:GV.UserCode
					},function(rtn){
						GV.requestMsg='';
						if(rtn==0){
							
							$.messager.alert('成功',"保存成功",'success',function(){
								if (GV.PopupEmrOnExec=='1' &&GV.CareProvType=="DOCTOR" && !(GV.AllowEditEmrInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc)) {
								
									GV.openEditEmr();
									
								}else{
									closeWin();
								}
							});
							$('#btnFwDoc').linkbutton('disable'); 
						}else{
							$.messager.alert('失败',"保存失败"+(rtn.split('^')[1]||rtn),'error');
						}
					}
				)
			})
		})
	}
	
	
	$('#btnSave').click(saveTrans);
	$('#btnClose').click(function(){
		closeWin();
	})
	$(window).resize(GV.util.debounce(function(){
		$('body').find('div.panel:visible').each(function(){
			$(this).triggerHandler('_resize');
			
		})
		if($('#TransAdvice').is(':visible')) $('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
	},200));
	if (GV.ShowProcess=='1'){
		var pModal=findThisModal()
		if (pModal && pModal.length) {
			if (pModal.width()<1050) {
				pModal.window('resize',{width:1150}).window('center');
				$(window).resize();
			}
		}
	}

}

function findThisModal(id){
	var modal=null;
	var key=(new Date()).getTime()+'r'+parseInt(Math.random()*1000000);
	if (!window.parent || window.parent===window) return modal;
	try {
		var P$=window.parent.$;
	}catch(e){
		return modal;
	}
	if (typeof id=="string" && P$('#'+id).length>0) return P$('#'+id);
	
	window._findThisModalKey=key;
	
	P$('iframe').each(function(){
		try {
			if (this.contentWindow._findThisModalKey==key){
				modal=P$(this).closest('.window-body');
				return false;
			}
		}catch(e){}
		
	})
	return modal;
}

function closeWin(){
	var modal=findThisModal();
	if (modal && modal.length>0){
		modal.window('close');
	}else{
		window.close()
		if (parent && parent.closeTransWin) {
			parent.closeTransWin();
		}else if(top && top.HideExecMsgWin) {
			top.HideExecMsgWin();
		}
	}
	

}
$(function(){
	GV.requestMsg='正在请求危急值数据';
	$.m({
		ClassName:'web.DHCAntCVReportSearch',
		MethodName:'GetAllInfo',
		reportID:GV.RepType+'||'+GV.ReportId
	},function(ret){
		GV.requestMsg='';
		try{
			var obj=$.parseJSON(ret);
		}catch(e){
			var obj={success:0,msg:'返回数据格式错误'}
		}
		if (obj && obj.success=='1'){
			$('.data-ele').each(function(){
				var t=$(this);
				var key=t.data('key'),mth=t.data('mth')||'text';
				t[mth]( obj[key]||'');
			})
			GV.reportInfoObj=obj;
			init();
		}else{
			$.messager.alert("错误",obj.msg,function(){
				closeWin()
			},'error');
		}
		
	})
});