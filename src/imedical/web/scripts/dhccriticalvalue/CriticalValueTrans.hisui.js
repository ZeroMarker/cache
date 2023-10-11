;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    var tempOnLoadSuccess=$(this).combogrid('options').onLoadSuccess;
			    
			    var that=this;
			    $(this).combogrid('options').onLoadSuccess=function(data){
				    $(that).combogrid('setValue',val).combogrid('setText',text);
				    
					if(typeof param.callback=='function') {
						param.callback(data,{value:val,text:text})
					}   
					tempOnLoadSuccess.call(this,data);
					$(that).combogrid('options').onLoadSuccess=tempOnLoadSuccess;
				}
			    
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
	            // ����Ѿ�ִ�й�������ִ��
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
		
		return common.easyModal(title,url,width,height);
		
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


GV.initInfo=function(){


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
					o.text='��'+c.SendTime+'���� '+c.CreateDate+' '+c.CreateTime
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
		//$('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
	}else{
		$('#TransAdvice-TR').hide();
	}
	
	GV.openEditEmr=function(){
		if ($.trim(GV.EmrEditLink)=="") {
			$.messager.alert("��ʾ","��δά��������д���ӣ�",'warning');
			return;
		}
		if (GV.AllowEditEmrInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
			$.messager.alert("��ʾ","��ǰ��¼�����벡�����ڿ��Ҳ���������д����",'warning');
			return;
		}
		$.m({ClassName:'web.DHCAntCVReportTrans',MethodName:'GetLatestTransEmr',reportID:GV.RepType+'||'+GV.ReportId},function(ret){
			var newObj={InstanceID:'',AntCVID:GV.reportID};
			if (parseInt(ret)>0) {
				var retArr=ret.split('$');
				newObj.InstanceID=retArr[0];
				if (retArr[1]) newObj.AntCVID=retArr[1];
			}
			GV.currInstanceID=newObj.InstanceID,GV.currInsLinkRep=newObj.AntCVID;
			
			if (GV.ManyRep2OneEmr=='1'){
				GV.openRepSelect();
			}else{
				GV.realOpenEditEmr(newObj);	
			}
											
		})
	}
	
	///���ȴ�websys_showModal ���û�� ʹ��ԭ��open
	GV.openCVLinkWin=function(title,url,width,height,onClose){
		
		
		
		if (!window.opener && window.top.websys_showModal && window.top.document.body['clientWidth']>1000){
			
			title=title.split('//')[0];
			
			return websys_showModal({title:$g(title),url:url,width:width,height:height,iconCls:'icon-w-paper',onClose:function(){
				if (typeof onClose=='function') {
					onClose();
				}
			}});
		}else{
			var winname=title.split('//')[1]||'';
			var openWin=getOpenWindow();
			return common.easyOriginWin(winname,url,width,height,openWin)   //winname,url,width,height,opWin
		}

		
	}
	
	GV.realOpenEditEmr=function(newObj){
		var link=getOtherLink(GV.EmrEditLink,newObj);
		
		GV.openCVLinkWin('Σ��ֵ����//CVTransEmrWin',link,'90%','90%',function(){
			$(this).find('iframe').eq(0).attr('src','about:blank');
		})
							
	}
	///��Σ��ֵ��¼ѡ�п�
	/// currReportID��ǰΣ��ֵID   instanceID֮ǰ�Ѿ�����������ID  reportIDs��ͬ����ID����������Σ��ֵID
	GV.openRepSelect=function(){
		if($('#rep-select-win').length==0){
			$('<div id="rep-select-win" style="padding:10px 10px 0 10px;"><table id="rep-select-list"></table></div>').appendTo('body');
			$('#rep-select-win').dialog({
				title:'ѡ��Σ��ֵ��¼',
				width:$(window).width()-50,
				height:$(window).height()-50,
				closed:true,
				draggable:false,
				modal:true,
				buttons:[{
					text:'ȷ��',
					handler:function(){
						var rows=$('#rep-select-list').datagrid('getSelections');
						if(rows && rows.length>0){
							var arr=[];
							$.each(rows,function(){arr.push(this.reportID);})
							GV.realOpenEditEmr({InstanceID:GV.currInstanceID,AntCVID:arr.join('^')});
						}else{
							$.messager.popover({msg:'��ѡ��Σ��ֵ��¼',type:'alert'});	
						}
					}
				},{
					text:'ȡ��',
					handler:function(){
						$('#rep-select-win').dialog('close');
					}	
				}],
				onClose:function(){
					$('#rep-select-list').datagrid('clearSelections');
				}
			})
			var repSelectDg=$('#rep-select-list').datagrid({
				headerCls:'panel-header-gray',bodyCls:'panel-header-gray',
				url:$URL,
				queryParams:{
					ClassName:'web.DHCAntService',QueryName:'QryCVByAdm',
					Adm:GV.EpisodeID
				},
				columns:[[
					{field:'ck',checkbox:true},
					{field:'repDate',title:'����ʱ��',width:150,formatter:function(val,row){
						return val+' '+row.repTime;
					}},
					{field:'ordItemDesc',title:'ҽ������',width:150},
					{field:'repResult',title:'������',width:200,showTip:true,tipWidth:200},
					{field:'EmrStatus',title:'����״̬',width:150,formatter:function(val,row){
						if (row.instanceID){
							if (row.instanceID==GV.currInstanceID){
								return '�뵱ǰΣ��ֵ����ͬһ��������¼';
							}else{
								return '��д����';
							}
						}else{
							return 'δд'
						}
					}},
				]],
				fit:true,
				idField:'reportID',
				pagination:true,
				pageSize:1000,
				pageList:[1000],
				rownumbers:true,
				striped:true,
				singleSelect:false,
				onLoadSuccess:function(data){
					repSelectDg.closest('.datagrid').find('.datagrid-header-check>input[type="checkbox"]').attr('disabled','disabled');
					console.log(data);
					$.each(data.rows,function(ind,item){
						if(GV.currInstanceID && item.instanceID==GV.currInstanceID) repSelectDg.datagrid('selectRow',ind);
						if(item.reportID==GV.reportID) repSelectDg.datagrid('selectRow',ind);
					})
				}
			})
		}else{
			$('#rep-select-list').datagrid('reload');
		}
		$('#rep-select-win').dialog('open');
	}
	GV.openEditOrder=function(){
		if ($.trim(GV.OrderEditLink)=="") {
			$.messager.alert("��ʾ","��δά��ҽ��¼�����ӣ�",'warning');
			return;
		}
		if (GV.AllowEditOrderInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
			$.messager.alert("��ʾ","��ǰ��¼�����벡�����ڿ��Ҳ��������ܿ�ҽ��",'warning');
			return;
		}
		
		var link=getOtherLink(GV.OrderEditLink);
		var cylink=getOtherLink(GV.CYOrderEditLink);
		
		var mylink="criticalvalue.oeord.csp?p1="+encodeURIComponent(link)+"&p2="+encodeURIComponent(cylink);
		
		GV.openCVLinkWin('Σ��ֵҽ��//CVTransOrderWin',mylink,'90%','90%',function(){
			$(this).find('iframe').eq(0).attr('src','about:blank');
		})

	}
	GV.openConsultation=function(){
		if ($.trim(GV.ConsultationLink)=="") {
			$.messager.alert("��ʾ","��δά�������������ӣ�",'warning');
			return;
		}
		$.m({ClassName:'web.DHCAntCVReportTrans',MethodName:'GetLatestTransConsultation',reportID:GV.RepType+'||'+GV.ReportId},function(ret){
			var newObj={CstID:'',AntCVID:GV.reportID}
			if (parseInt(ret)>0){
				var retArr=ret.split('$');
				newObj.CstID=retArr[0];
				if (retArr[1]) newObj.AntCVID=retArr[1];
			}
			var link=getOtherLink(GV.ConsultationLink,newObj);
			
			GV.openCVLinkWin('Σ��ֵ����//CVConsultationWin',link,'90%','90%',function(){
				$(this).find('iframe').eq(0).attr('src','about:blank');
			})
							
											
		})
	}
	//����ҽ��
	GV.openLinkOrder=function(){
		//alert('//����ҽ��')
		var link=getOtherLink('criticalvalue.linkorder.csp?reportID={AntCVID}&EpisodeID={EpisodeID}');
		GV.openCVLinkWin('����ҽ��//CVLinkOrderWin',link,1000,600,function(){
			$(this).find('iframe').eq(0).attr('src','about:blank');
		})
		
		
	}
	///��Ѫ����
	GV.openBlood=function(){
		if ($.trim(GV.BloodLink)=="") {
			$.messager.alert("��ʾ","��δά����Ѫ�������ӣ�",'warning');
			return;
		}
		$.m({ClassName:'web.DHCAntCVReportTrans',MethodName:'GetLatestTransBlood',reportID:GV.RepType+'||'+GV.ReportId},function(ret){
			var newObj={CstID:'',AntCVID:GV.reportID}
			if (parseInt(ret)>0){
				var retArr=ret.split('$');
				newObj.CstID=retArr[0];
				if (retArr[1]) newObj.AntCVID=retArr[1];
			}
			var link=getOtherLink(GV.BloodLink,newObj);
			GV.openCVLinkWin('Σ��ֵ��Ѫ����//CVBloodWin',link,'90%','90%',function(){
				$(this).find('iframe').eq(0).attr('src','about:blank');
			})								
		})
	}
	GV.openNoOrder=function(){
		$.messager.confirm("ȷ��","ȷ������Ҫҽ��������",function(r){
			if(r) {
				$.m({
					ClassName:'web.DHCAntCVReportTrans',
					MethodName:'SaveTransNoOrder',
					reportID:GV.RepType+'||'+GV.ReportId,  
					userid:GV.UserId
				},function(ret){
						if (ret>0) {
							$.messager.popover({msg:'����ɹ�',type:'success'});
						}else{
							$.messager.popover({msg:'����ʧ��',type:'error'});	
						}
					
				})
			}	
			
		})
		
	}
	

	///��ȡopenҪ�����ĸ����ڵ�open
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
		// template + data��������html
		return template.replace(/\{(.+?)\}/ig,function(m,i,d){
				return data[i]||'';
		}) ;
	}
	//�������õ�����ģ���ַ�������ȡʵ������
	function getOtherLink(linkTmpl,data){
		data=data||{};
		//�����е�{key}�����滻
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
		//����websys.jquery.js�е� $.formatByJson
		var link=formatByJson(linkTmpl,obj);	
		//alert(link);
		return link;	
	}
	
	
	var pgItemTipArr=[];
	
	if (GV.CareProvType=="DOCTOR") { //

		
		if (GV.ShowEditOrder=='1') {pgItemTipArr.push('��ҽ��');GV.openOnlyOnePg=GV.openEditOrder;}
		if (GV.ShowLinkOrder=='1') {pgItemTipArr.push('�ѿ�ҽ��');GV.openOnlyOnePg=GV.openLinkOrder;}
		if (GV.ShowConsultation=='1') {pgItemTipArr.push('��������');GV.openOnlyOnePg=GV.openConsultation;}
		if (GV.ShowBlood=='1') {pgItemTipArr.push('��Ѫ����');GV.openOnlyOnePg=GV.openBlood;}
		if (GV.ShowNoOrder=='1') {pgItemTipArr.push('����ҽ������');GV.openOnlyOnePg=GV.openNoOrder;}
		
		if (pgItemTipArr.length>=3) {
			var execMenuBtn=$('<a id="execMenuBtn" style="margin-right:10px;" href="javascript:void(0);" class="menubutton-blue" data-options="">��������</a>')
			var execMenu=$('<div id="execMenu"></div>');
			
			if (GV.ShowEditOrder=="1"){
				var execMenuItem=$('<div id="btnTransORD" onclick="GV.openEditOrder();">��ҽ��</div>');
				if (GV.AllowEditOrderInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
					execMenuItem.attr('title','��ǰ��¼�����벡�����ڿ��Ҳ��������ܿ�ҽ��').attr('disabled',true);
				}
				execMenuItem.appendTo(execMenu);
			}
			if (GV.ShowLinkOrder=="1"){
				var execMenuItem=$('<div id="btnLinkOrder" onclick="GV.openLinkOrder();">�ѿ�ҽ��</div>');
				execMenuItem.appendTo(execMenu);
			}
			if (GV.ShowConsultation=="1"){
				var execMenuItem=$('<div id="btnTransConsultation" onclick="GV.openConsultation();">��������</div>');
				execMenuItem.appendTo(execMenu);
			}
			if (GV.ShowBlood=="1"){
				var execMenuItem=$('<div id="btnTransBlood" onclick="GV.openBlood();">��Ѫ����</div>');
				execMenuItem.appendTo(execMenu);
			}
			if (GV.ShowNoOrder=="1"){
				var execMenuItem=$('<div id="btnTransNoOrder" onclick="GV.openNoOrder();">����ҽ������</div>');
				execMenuItem.appendTo(execMenu);
			}
			
			var execMenuItem=$('<div id="" disabled="disabled">��������</div>');
			execMenuItem.appendTo(execMenu);
			
			execMenu.appendTo('body');
			execMenuBtn.prependTo('#buttons').menubutton({
				menu:'#execMenu',otherCls:'menubutton-blue'
			})
			
			
		}else{
			if (GV.ShowEditOrder=="1"){
				$('<a id="btnTransORD" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">��ҽ��</a>').insertBefore('#btnSave').linkbutton({
					onClick:function(){	
						GV.openEditOrder();
					}
				})
				if (GV.AllowEditOrderInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
					$('#btnTransORD').linkbutton('disable').attr('title','��ǰ��¼�����벡�����ڿ��Ҳ��������ܿ�ҽ��');
				}
			}
			if (GV.ShowLinkOrder=="1"){
				$('<a id="btnLinkOrder" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">�ѿ�ҽ��</a>').insertBefore('#btnSave').linkbutton({
					onClick:function(){	
						GV.openLinkOrder();
					}
				})
			}
			if (GV.ShowConsultation=="1"){
				$('<a id="btnTransConsultation" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">��������</a>').insertBefore('#btnSave').linkbutton({
					onClick:function(){	
						GV.openConsultation();
					}
				})
			}
			if (GV.ShowBlood=="1"){
				$('<a id="btnTransBlood" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">��Ѫ����</a>').insertBefore('#btnSave').linkbutton({
					onClick:function(){	
						GV.openBlood();
					}
				})
			}
			if (GV.ShowNoOrder=="1"){
				$('<a id="btnTransNoOrder" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">����ҽ������</a>').insertBefore('#btnSave').linkbutton({
					onClick:function(){	
						GV.openNoOrder();
					}
				})
			}
			
			
		}
		
		if (GV.ShowEditEmr=="1" ){
			$('<a id="btnTransEMR" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true">д����</a>').insertBefore('#btnSave').linkbutton({
				onClick:function(){
					//alert('д����')	
					GV.openEditEmr();
				}
			})
			if (GV.AllowEditEmrInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc) {
				$('#btnTransEMR').linkbutton('disable').attr('title','��ǰ��¼�����벡�����ڿ��Ҳ���������д����');
			}
		}

	}

	GV.epis=GV.ReportId.split("||")[0];
	GV.conResultCNMap={'F':'��֪ͨ','C':'δ��ϵ��'}  //���������ֵ�
	
	var conResultData=[{value:'F',text:$g('��֪ͨ')},{value:'C',text:$g('δ��ϵ��')}];
	if(GV.dicConResultExec) {
		conResultData=[];
		$.each(GV.dicConResultExec,function(){
			conResultData.push({value:this.TCode,text:$g(this.TDesc)})
		})
	}
	
	
	$('#ConResult').combobox({
		textField:'text',
		valueField:'value',
		data:conResultData,
		panelHeight:'auto',
		editable:false,
		onSelect:function(row){
			if(row.value=='NoNeedExec') {
				if($('#TransAdvice').length>0 && $('#TransAdvice').val()=='') {  //���ѡ�����账�� �������Ϊ�� �Զ�������Ϣ
					$('#TransAdvice').val(row.text);	
					if ($('#TransAdvice').hasClass('validatebox-text')) $('#TransAdvice').validatebox('validate')
				}	
				
			}
			
		}
	})
	
	function checkTransOrd(reportID,status,after){
		GV.requestMsg='����У��ҽ��������Ϣ';
		$.m({
			ClassName:'web.DHCAntCVReportTrans'	,MethodName:'CheckTransOrd',
			reportID:reportID,
			trExecResult:status
			},function(rtn){
				GV.requestMsg='';
				var pgAct=pgItemTipArr.length>1?'��������':(pgItemTipArr[0]||'��������');
				if (rtn=='-100'){
					var msg='��Ҫ��'+pgAct;
					if(GV.CareProvType=="DOCTOR") msg+= pgItemTipArr.length>1?(',��ѡ��'+pgItemTipArr.join('��') ):(',���ȷ��ȥ'+(pgItemTipArr[0]||'��������'));
					else  msg+=',����ϵҽ��';
					$.messager.alert('ʧ��',msg,'error',function(){
						if(GV.CareProvType=="DOCTOR" && pgItemTipArr.length==1){
							GV.openOnlyOnePg();
							//GV.openEditOrder();
						}
					});
				}else if (rtn=='-200'){
					if(GV.CareProvType=="DOCTOR") var msg='��δ'+pgAct+'���Ƿ���������ȷ����������';
					else var msg='��δ'+pgAct+'���Ƿ���������ȷ����������';
					$.messager.confirm("��ʾ",msg,function(r){
						if (r){
							if (after) after();
						}else{
							if(GV.CareProvType=="DOCTOR" && pgItemTipArr.length==1 ) {
								GV.openOnlyOnePg();
								//GV.openEditOrder();
							}
						}
					})
				}else{
					if (after) after();
				}
			}
		)
	}
	function checkTransEMR(reportID,status,after){
		GV.requestMsg='����У�鲡��������Ϣ';
		$.m({
			ClassName:'web.DHCAntCVReportTrans'	,MethodName:'CheckTransEMR',
			reportID:reportID,
			trExecResult:status
			},function(rtn){
				GV.requestMsg='';
				if (rtn=='-100'){
					var msg="��Ҫ��д�����ٽ��д���"
					if(GV.CareProvType=="DOCTOR") msg+=',���ȷ��д����';
					else  msg+=',����ϵҽ��';
					$.messager.alert('ʧ��',msg,'error',function(){
						if(GV.CareProvType=="DOCTOR"){
							GV.openEditEmr();
						}
					});
				}else if (rtn==-'200'){
					if(GV.CareProvType=="DOCTOR") var msg="��δд�������Ƿ���������ȷ�������������ȡ��ȥд����";
					else var msg="��δд�������Ƿ���������ȷ����������"
					$.messager.confirm("��ʾ",msg,function(r){
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
	
	var setContactPhone=function(userid,phonetype){
		if (phonetype) {  //�������
			if (phonetype=='AdmLocPhone') { //Ĭ��ֵΪ���ҵ绰
				$m({ClassName:'web.DHCAntCVComm',MethodName:'GetLocPhone',locid:GV.reportInfoObj.admLoc},function(ret){
					$('#ContactTel').val(ret);
				})
			}else {
				var mth='';
				if (phonetype=='DocPhone') mth='GetUserPhone';
				if (phonetype=='DocWorkPhone') mth='GetUserWorkPhone';
				if (mth!='') {
					$m({ClassName:'web.DHCAntCVComm',MethodName:mth,userid:userid},function(ret){
						$('#ContactTel').val(ret);
					})
				}
				
			}
			
		
			return;	
		}
		
		
		
		
		var mth='';
		if (GV.ReceiveContactTel=='DocPhone') mth='GetUserPhone';
		if (GV.ReceiveContactTel=='DocWorkPhone') mth='GetUserWorkPhone';
		if (mth!='') {
			$m({ClassName:'web.DHCAntCVComm',MethodName:mth,userid:userid},function(ret){
				$('#ContactTel').val(ret);
			})
		}

	}
	
	var debounce_setContactPhone=GV.util.debounce(setContactPhone,200);
	
	var canReceive=false,showReceive=false;
	if (GV.ReceiveMode>0){ //��Ҫ����
		$('#btnSave').find('.l-btn-text').text($g('����'));
		showReceive=true;
		
		if (GV.ReceiveMode=='3'&& GV.CareProvType=='DOCTOR') showReceive=false; //ҽ���鿴������ ҽ������ʾ��ť
		if (GV.ReceiveMode=='4'&& GV.CareProvType=='DOCTOR') showReceive=false; //����ʱ���� ҽ������ʾ��ť
		
		if (showReceive) {
			$('<a id="btnReceive" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true,disabled:true" class="green">����</a>').prependTo('#buttons').linkbutton({
				onClick:function(){
					saveReceive();
				}
			})
			
			if(GV.reportInfoObj.repStatus=='C') canReceive=true; //Ŀǰֻ�иմ����Ŀ��Խ���
			$('#btnReceive').linkbutton(canReceive?'enable':'disable');
			$('#btnReceive')[canReceive?'addClass':'removeClass']('green');
		}
		
		if (canReceive){
			
			if (GV.ReceiveContactTel=='AdmLocPhone') { //Ĭ��ֵΪ���ҵ绰
				$m({ClassName:'web.DHCAntCVComm',MethodName:'GetLocPhone',locid:GV.reportInfoObj.admLoc},function(ret){
					$('#ContactTel').val(ret);
				})
			}
			
			var conResultDataRec=[{value:'F',text:$g('��֪ͨ')},{value:'C',text:$g('δ��ϵ��')}];
			if(GV.dicConResultRec) {
				conResultDataRec=[];
				$.each(GV.dicConResultRec,function(){
					conResultDataRec.push({value:this.TCode,text:$g(this.TDesc)})
				})
			}
			$('#ConResult').combobox({data:conResultDataRec});
			
			
			$('#ConResult').combobox('setValue','F');
			
			if (GV.ReceiveContact=='AllDoc' || GV.ReceiveContact=='AdmLocDoc') { //ȫԺҽ�������ҽ��
				$('#Contact').combogrid({
					width:170,
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
						param.LocId=GV.ReceiveContact=='AdmLocDoc'?GV.reportInfoObj.admLoc:'';
						return true;
					},
					onSelect:function(ind,row){
						debounce_setContactPhone(row.TId)
					},
					idField:"TCode",textField:"TDesc",
					columns:[[{field:'TDesc',title:'����',width:200},{field:'TCode',title:'����',width:200}]],
					pagination:true
				})
				
				
				if (GV.CareProvType=='DOCTOR') { //ҽ����ϵ��Ĭ���Լ�
					$('#Contact').combogrid('setRemoteValue',{value:GV.UserCode,text:GV.UserName});
					setContactPhone(GV.UserId);
				}else if(GV.CareProvType=='NURSE' ) {  //��ʿ
					if (GV.NurRecDefContact=='AdmDoc') { //Ĭ������ҽ��
						$('#Contact').combogrid('setRemoteValue',{value:GV.reportInfoObj.admDocUserCode,text:GV.reportInfoObj.admDocName});
						setContactPhone(GV.reportInfoObj.admDocUserId,GV.ReceiveContactTel);
					}else if (GV.NurRecDefContact=='OrdDoc') { //Ĭ�Ͽ���ҽ��
						$('#Contact').combogrid('setRemoteValue',{value:GV.reportInfoObj.ordDocUserCode,text:GV.reportInfoObj.ordDocName});
						setContactPhone(GV.reportInfoObj.ordDocUserId,GV.ReceiveContactTel);
					}
					
				}
				
			}else{
				if (GV.CareProvType=='DOCTOR') { //ҽ����ϵ��Ĭ���Լ�
					$('#Contact').val(GV.UserName);
					setContactPhone(GV.UserId);
				}else if(GV.CareProvType=='NURSE' ) {  //��ʿ
					if (GV.NurRecDefContact=='AdmDoc') { //Ĭ������ҽ��
						$('#Contact').val(GV.reportInfoObj.admDocName); 
						setContactPhone(GV.reportInfoObj.admDocUserId,GV.ReceiveContactTel);
					}else if (GV.NurRecDefContact=='OrdDoc') { //Ĭ�Ͽ���ҽ��
						$('#Contact').val(GV.reportInfoObj.ordDocName); 
						setContactPhone(GV.reportInfoObj.ordDocUserId,GV.ReceiveContactTel);
					}
					
				}
			}
			
			
		
			
			$('#TransAdvice').closest('td').prev().text($g('��ע'));
			$('#btnSave').linkbutton('disable');
			
			if (GV.ShowTransAdvice!="1") { //ǰ�����ڲ���ʾ�����ʩ �������ص��� �ڽ���ʱ ��ע�õ�ͬһ����� Ҫ����ʾ����
				$('#TransAdvice-TR').show();
				$('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
			}
		}
		
	}
	
	if (GV.AllowFwDoc=='1'){
		
		$('<a id="btnFwDoc" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true,disabled:true" >ת��</a>').insertAfter('#btnSave').linkbutton({
			onClick:function(){
				openFwDoc();
			}
		})
		var canFwDoc=false;
		//if(GV.reportInfoObj.repStatus=='Rec' || (GV.ReceiveMode!='1' &&GV.reportInfoObj.repStatus=='C') ) canFwDoc=true;  //���պ�ſ�ת��  �������Ҫ���� ��ô�մ���״̬Ҳ����ת��
		if(GV.reportInfoObj.repStatus!='F' && GV.reportInfoObj.repStatus!='D' && !canReceive  ) canFwDoc=true; 
		$('#btnFwDoc').linkbutton(canFwDoc?'enable':'disable');
		
		if (canReceive && GV.CareProvType=='NURSE' &&GV.AllowNurRecFwDoc=='1') {
			$('<a id="btnRecFwDoc" style="margin-right:10px;" data-options="stopAllEventOnDisabled:true,disabled:true" >���ղ�ת��</a>').insertAfter('#btnFwDoc').linkbutton({
				onClick:function(){
					openRecFwDoc();
				}
			})
			var canRecAndFwDoc=false;
			if (GV.reportInfoObj.repStatus=='C') canRecAndFwDoc=true;
			$('#btnRecFwDoc').linkbutton(canRecAndFwDoc?'enable':'disable');
		}

		
	}
	if(!canReceive) {  //����ʱ ��ϵ����ϵ�绰���ֶεı������ 2022-10-27
		if(GV.HideExecContactInfo=='1') { //����֪ͨ��Ϣ
			$('#contact-tr').hide();
		}
		$('#Contact').validatebox({required:GV.ExecRequireContact=='1'})
		$('#ContactTel').validatebox({required:GV.ExecRequireContactTel=='1'})
		$('#ConResult').combobox({required:GV.ExecRequireContactResult=='1'})
		$('#ConResult').combobox('setValue',GV.ContactResultDefValue||'')
		$('#TransAdvice').validatebox({required:GV.ExecRequireTransAdvice=='1'})
		
		
		if (GV.reportInfoObj.repStatus!='F') {  //δ�������Σ��ֵ ��ϵ����ϵ�绰Ĭ����Ϣ
			
			if(GV.ExecContactDefault=="PatSelf"){ //���߱���
				$('#Contact').val(GV.reportInfoObj.patName);
				$('#ContactTel').val(GV.reportInfoObj.patPhone)
				
			}else if (GV.ExecContactDefault=="CurrUser"){ //��ǰ��¼��
				$('#Contact').val(GV.UserName);
				setContactPhone(GV.UserId,GV.ExecContactUserTelDefault);

			}
			$('#Contact').validatebox('validate');
			$('#ContactTel').validatebox('validate')
		}
		
		
		
	}
	if (GV.reportInfoObj.repStatus=='F'){
		for (var len=GV.reportInfoObj.transArray.length,i=len-1;i>=0;i--){
			var trInfo=GV.reportInfoObj.transArray[i];
			if (trInfo.trOpType=='E' || trInfo.trOpType==''){ //ֻȡ�����
				$('#Contact').val(trInfo.trContact);
				$('#ContactTel').val(trInfo.trPhone);
				$('#ConResult').combobox('setValue',trInfo.trExecResult||trInfo.trStatus);
				var $TransAdvice=$('#TransAdvice');
				if ($TransAdvice.length>0 && $TransAdvice.is(':visible') && typeof trInfo.trAdvice=="string"){
					$TransAdvice.val( trInfo.trAdvice.replace(/\$c\(92\)/ig,'\\').replace(/\$c\(94\)/ig,'^'));
				}
				break;
			}
			
		}
		$('#Contact,#ContactTel,#TransAdvice').validatebox('validate');
		$('#ConResult').combobox('validate');
	}
	
	///���ղ�ת��
	function openRecFwDoc(){
		if(GV.requestMsg) {$.messager.alert('��ʾ',GV.requestMsg+'�����Ժ�','warning'); return;}
		if ($('#Contact').hasClass('combogrid-f')) {
			var Contact=$('#Contact').combogrid('getText');
			var ContactCode=$('#Contact').combogrid('getValue');
			
		}else{
			var Contact=$('#Contact').val();
			var ContactCode='';
				
		}
		var ContactTel=$('#ContactTel').val();
		var ConResult=$('#ConResult').combobox('getValue');
		var TransMemo=$('#ConResult').combobox('getText');
		var TransAdvice=$('#TransAdvice').val()||'';
		TransAdvice=TransAdvice.replace(/\\/g,'$c(92)').replace(/\^/g,'$c(94)');
		
		if(Contact==""){
			$.messager.alert("��ʾ",'��ϵ�˲���Ϊ�գ�','warning');
			return;
		}
		if(ContactTel=="" && GV.AllowNoTelOnReceive!='1'){
			$.messager.alert('��ʾ',"��ϵ�绰����Ϊ�գ�",'warning');
			return;
		}
		var conResultItem=$.hisui.getArrayItem(GV.dicConResultRec,'TCode',ConResult);
		
		if (!conResultItem){
			$.messager.alert('��ʾ',"��ѡ����ϵ�����",'warning');
			return;
		}
		
		openFwDoc({
			loc:GV.reportInfoObj.admLoc,
			locDesc:GV.reportInfoObj.admLocDesc,
			docId:'',
			docName:Contact,
			docCode:ContactCode,
			docId2:GV.reportInfoObj.admDocUserId,
			docName2:GV.reportInfoObj.admDocName
			,isRecAndFwDoc:true
		})
	}
	function initFwDoc(){
		if ($('#FwDoc-Win').length==0){
			if (GV.AllowFwDoc2!='1') {
				$('<div id="FwDoc-Win" style="padding:10px 10px 0px 10px;"> \
				<div style="padding:0px 0px 5px 0px;">'+$g('��ѡ��Ҫת����ĳ���һ�ĳ����ĳҽ��')+'</div> \
				<table style="width:330px;" cellspacing="0" cellpadding="0" border="0">\
					<tr style="height:40px;"><td class="r-label" style="width:50px;" ><span style="color:red;">*</span>'+$g('����')+'</td><td style="width:280px;"><input class="textbox textbox-fit"  id="FwDoc-Loc"/></td></tr>\
					<tr style="height:30px;"><td class="r-label" style="padding-top:5px;" >'+$g('ҽ��')+'</td><td  style="padding-top:5px;"><input class="textbox textbox-fit" id="FwDoc-Doc" /></td></tr>\
				</table></div>').appendTo('body');
			}else{
				$('<div id="FwDoc-Win" style="padding:10px 10px 0px 10px;"> \
				<div style="padding:0px 0px 5px 0px;">'+$g('��ѡ��Ҫת����ĳ���һ�ĳ����ĳҽ��')+'</div> \
				<table style="width:330px;" cellspacing="0" cellpadding="0" border="0">\
					<tr style="height:40px;"><td class="r-label" style="width:50px;" ><span style="color:red;">*</span>'+$g('����')+'</td><td style="width:280px;"><input class="textbox textbox-fit"  id="FwDoc-Loc"/></td></tr>\
					<tr style="height:40px;"><td class="r-label" style="padding-top:5px;" >'+$g('ҽ��')+'</td><td  style="padding-top:5px;"><input class="textbox textbox-fit" id="FwDoc-Doc" /></td></tr>\
					<tr style="height:30px;"><td class="r-label" style="padding-top:5px;" >'+$g('ҽ��2')+'</td><td  style="padding-top:5px;"><input class="textbox textbox-fit" id="FwDoc-Doc2" /></td></tr>\
				</table></div>').appendTo('body');
			}

			$('#FwDoc-Win').dialog({
				iconCls:'icon-w-paper',
				closed:true,
				modal:true,
				width:350,
				
				title:'��ѡ��',
				buttons:[{
					text:'ȷ��',
					handler:function(){
						if(GV.isRecAndFwDoc){
							//alert('���ղ�ת��');
							
							saveReceive(function(recret){
								if(recret==0){
									saveFwDoc();
								}else{
									$.messager.alert('ʧ��',"���������Ϣʧ��"+(recret.split('^')[1]||recret),'error');
								}	
							})
						}else{
							saveFwDoc();
						}
					}	
				},{
					text:'ȡ��',
					handler:function(){
						$('#FwDoc-Win').dialog('close');
					}
				}]	
			})
			
			$('#FwDoc-Loc').combogrid({
				width:280,
				panelWidth:450,
				delay: 500,
				mode: 'remote',
				url:$URL,
				queryParams:{
					ClassName:'web.DHCAntCVComm',
					QueryName:'LookUpLoc',
					onlySameHosp:1,
					onlyActive:1
					,pAdmType:GV.FwDocMustSameAdmType=='1'?(GV.AdmType||''):''   //ת������ͬ�������Ϳ��� 2022-10-27
				},
				onBeforeLoad:function(param){
					param.desc=param.q;
					return true;
				},
				onSelect:function(row){
					$('#FwDoc-Doc').combogrid('setRemoteValue',{value:'',text:''});
					if($('#FwDoc-Doc2').length>0) $('#FwDoc-Doc2').combogrid('setRemoteValue',{value:'',text:''});
				},
				onLoadSuccess:function(data){
					//$('#FwDoc-Doc').combogrid('setRemoteValue',{value:'',text:''});
				},
				idField:"HIDDEN",textField:"Description",
				columns:[[{field:'Description',title:'��������',width:200},{field:'Code',title:'���Ҵ���',width:200}]],
				pagination:true
			})
			$('#FwDoc-Doc').combogrid({
				width:280,
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
				onShowPanel:function(){
					var locId=$('#FwDoc-Loc').combogrid('getValue');
					if (!(locId>0)) {
						$.messager.popover({msg:'����ѡ�������ѡ��ҽ��',type:'alert'})
						$('#FwDoc-Doc').combogrid('hidePanel');
					}
				},
				idField:"TId",textField:"TDesc",
				columns:[[{field:'TDesc',title:'����',width:100},{field:'TCode',title:'����',width:100}]],
				pagination:true
			})
			$('#FwDoc-Doc2').combogrid({
				width:280,
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
				columns:[[{field:'TDesc',title:'����',width:100},{field:'TCode',title:'����',width:100}]],
				pagination:true
			})			
	
		}
	
	}

	function openFwDoc(defData){
		GV.isRecAndFwDoc=defData&&defData.isRecAndFwDoc;
		
		initFwDoc();
		$('#FwDoc-Win').dialog('open');
		
		if (defData) {
			var temOnSelect=$('#FwDoc-Loc').combogrid('options').onSelect;
			$('#FwDoc-Loc').combogrid('options').onSelect=function(){};
			$('#FwDoc-Loc').combogrid('setRemoteValue',{value:defData.loc,text:defData.locDesc,callback:function(){
				
				$('#FwDoc-Doc').combogrid('setRemoteValue',{value:defData.docId,text:defData.docName,callback:function(data,row){
					if(!defData.docId) {
						var flag=false;
						if(data && data.rows) {
							$.each(data.rows,function(){
								if(defData.docCode) {
									if(this.TCode==defData.docCode) {
										$('#FwDoc-Doc').combogrid('setValue',this.TId);
										flag=true;
										return false;
									}
								}else if(defData.docName){
									if(this.TDesc==defData.docName) {
										$('#FwDoc-Doc').combogrid('setValue',this.TId);
										flag=true;
										return false;
									}	
								}
								
								
							})
							
						}
						if(!flag) {
							$('#FwDoc-Doc').combogrid('setText','');
						}
					}
						
				}})
				
				if($('#FwDoc-Doc2').length>0) $('#FwDoc-Doc2').combogrid('setRemoteValue',{value:defData.docId2||'',text:defData.docName2||''})
				
				$('#FwDoc-Loc').combogrid('options').onSelect=temOnSelect;
				
			}})
			
		}

	}
	
	///���������ȷ������
	function confirmPwd(op,callback){
		var needPop=false;
		needPop=(op='FwD' && GV.PINOnForward=='1')||(op='Rec' && GV.PINOnReceive=='1')||(op='E' && GV.PINOnExec=='1') ;
		if (needPop) {
			if(GV.pwdCheck_pwd) {  //���ȫ���м�¼���ϴ���֤�ɹ������� ֱ��ʹ��֮
				callback({pwd:GV.pwdCheck_pwd});
				return;
			}
			$.messager.prompt('ȷ������','������ǩ������',function(r){
			    if(r) {
					callback({pwd:hex_md5(dhc_cacheEncrypt(r))})    
				}else{
					$.messager.popover({msg:'������ǩ������',type:'alert'})	
				}
			})
			$('.messager-window').last().find('.messager-input').attr('type','password').focus()
			
		}else{
			callback({pwd:''});
		}
		
		
	}
	
	
	function saveFwDoc(){
		if(GV.requestMsg) {$.messager.alert('��ʾ',GV.requestMsg+'�����Ժ�','warning'); return;}
		var fwLocId=$('#FwDoc-Loc').combogrid('getValue'),
			fwUserId=$('#FwDoc-Doc').combogrid('getValue'),
			fwUserId2=$('#FwDoc-Doc2').length>0?$('#FwDoc-Doc2').combogrid('getValue'):'';
		
		confirmPwd('FwD',function(pwdObj){
			GV.requestMsg='����ת��';
			$.m({
				//reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode
				ClassName:'web.DHCAntCVReportTrans'	,MethodName:'SaveFwDoc',
				reportID:GV.RepType+'||'+GV.ReportId,
				usercode:GV.UserCode
				,fwLocId:fwLocId
				,fwUserId:fwUserId
				,pwd:pwdObj.pwd
				,fwUserId2:fwUserId2
				},function(rtn){
					GV.requestMsg='';
					if(rtn==0){
						if(pwdObj.pwd) GV.pwdCheck_pwd=pwdObj.pwd; //����ɹ���¼�ϴ�pwd
						$.messager.alert('�ɹ�',"����ɹ�",'success',function(){
							closeWin();
						});
					}else{
						$.messager.alert('ʧ��',(rtn.split('^')[1]||rtn),'error');
					}
				}
			)
		})
		

	}
	
	
	function saveReceive(callback){
		if(GV.requestMsg) {$.messager.alert('��ʾ',GV.requestMsg+'�����Ժ�','warning'); return;}
		if ($('#Contact').hasClass('combogrid-f')) {
			var Contact=$('#Contact').combogrid('getText');
			var ContactCode=$('#Contact').combogrid('getValue');
			
		}else{
			var Contact=$('#Contact').val();
			var ContactCode='';
				
		}
		var ContactTel=$('#ContactTel').val();
		var ConResult=$('#ConResult').combobox('getValue');
		var TransMemo=$('#ConResult').combobox('getText');
		var TransAdvice=$('#TransAdvice').val()||'';
		TransAdvice=TransAdvice.replace(/\\/g,'$c(92)').replace(/\^/g,'$c(94)');
		
		if(Contact==""){
			$.messager.alert("��ʾ",'��ϵ�˲���Ϊ�գ�','warning');
			return;
		}
		if(ContactTel=="" && GV.AllowNoTelOnReceive!='1'){
			$.messager.alert('��ʾ',"��ϵ�绰����Ϊ�գ�",'warning');
			return;
		}
		var conResultItem=$.hisui.getArrayItem(GV.dicConResultRec,'TCode',ConResult);
		
		if (!conResultItem){
			$.messager.alert('��ʾ',"��ѡ����ϵ�����",'warning');
			return;
		}
		TransMemo=conResultItem.TDesc;  //GV.conResultCNMap[ConResult]||TransMemo;
		
		confirmPwd('Rec',function(pwdObj){
			GV.requestMsg='���ڱ��������Ϣ';
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
				,pwd:pwdObj.pwd
				,contactCode:ContactCode
				},function(rtn){
					GV.requestMsg='';
					if(typeof callback=='function') {
						if(rtn==0 && pwdObj.pwd) GV.pwdCheck_pwd=pwdObj.pwd; //����ɹ���¼�ϴ�pwd
						callback(rtn);
						return;	
						
					}
					if(rtn==0){
						if(pwdObj.pwd) GV.pwdCheck_pwd=pwdObj.pwd; //����ɹ���¼�ϴ�pwd
						$.messager.alert('�ɹ�',"����ɹ�",'success',function(){
							if (GV.CareProvType=='DOCTOR') {
								if(typeof websys_getMWToken=='function' && window.location.href.indexOf('MWToken=')==-1) {
									window.location.href=window.location.href+'&MWToken='+websys_getMWToken();	
								}else{
									window.location.reload();	
								}
								
							}else{
								closeWin();
							}
							
						});
					}else{
						$.messager.alert('ʧ��',""+(rtn.split('^')[1]||rtn),'error');
					}
				}
			)
			
		})
		

	}
	
	function saveTrans(){
		if(GV.requestMsg) {$.messager.alert('��ʾ',GV.requestMsg+'�����Ժ�','warning'); return;}
		
		if (GV.HideExecContactInfo=='1') {
			var Contact='';
			var ContactTel='';
			var ConResult='';
			var TransMemo='';
		}else{
			var Contact=$('#Contact').val();
			var ContactTel=$('#ContactTel').val();
			var ConResult=$('#ConResult').combobox('getValue');
			var TransMemo=$('#ConResult').combobox('getText');
			

			var conResultItem=$.hisui.getArrayItem(GV.dicConResultExec,'TCode',ConResult);
		
			if (!conResultItem){
				$.messager.alert('��ʾ',"��ѡ����ϵ�����",'warning');
				return;
			}
			TransMemo=conResultItem.TDesc;  //GV.conResultCNMap[ConResult]||TransMemo;
			
			if(!$('#Contact').validatebox('isValid')) {
				$.messager.popover({msg:'��ϵ�˲���Ϊ�գ�',type:'alert'});
				return ;	
			}
			if(!$('#ContactTel').validatebox('isValid')) {
				$.messager.popover({msg:'��ϵ�绰����Ϊ�գ�',type:'alert'});
				return ;	
			}
			if(!$('#ConResult').combobox('isValid')) {
				$.messager.popover({msg:'��ѡ����ϵ�����',type:'alert'});
				return ;	
			}
		}
		var TransAdvice=$('#TransAdvice').val()||'';
		TransAdvice=TransAdvice.replace(/\\/g,'$c(92)').replace(/\^/g,'$c(94)');
		if($('#TransAdvice').is(':visible')) {
			if(!$('#TransAdvice').validatebox('isValid')) {
				$.messager.popover({msg:'�����ʩ����Ϊ�գ�',type:'alert'});
				return ;
			}
		}
		
		
		
//		if(GV.AdmType!="I"){
//			if(Contact==""){
//				$.messager.alert("��ʾ",'��ϵ�˲���Ϊ�գ�','warning');
//				return;
//			}
//			if(ContactTel==""){
//				$.messager.alert('��ʾ',"��ϵ�绰����Ϊ�գ�",'warning');
//				return;
//			}
//		}
//		if (ConResult!="C" && ConResult!="F"){
//			$.messager.alert('��ʾ',"��ѡ����ϵ�����",'warning');
//			return;
//		}
		
		checkTransOrd(GV.RepType+'||'+GV.ReportId,"F",function(){
			checkTransEMR(GV.RepType+'||'+GV.ReportId,"F",function(){
				confirmPwd('E',function(pwdObj){
					GV.requestMsg='���ڱ��洦����Ϣ';
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
						,pwd:pwdObj.pwd
						},function(rtn){
							GV.requestMsg='';
							if(rtn==0){
								if(pwdObj.pwd) GV.pwdCheck_pwd=pwdObj.pwd; //����ɹ���¼�ϴ�pwd
								
								$.messager.alert('�ɹ�',"����ɹ�",'success',function(){
									if (GV.PopupEmrOnExec=='1' &&GV.CareProvType=="DOCTOR" && !(GV.AllowEditEmrInOtherLoc!='1' && GV.LocId!=GV.reportInfoObj.admLoc)) {
									
										GV.openEditEmr();
										
									}else{
										closeWin();
									}
								});
								$('#btnFwDoc').linkbutton('disable'); 
							}else{
								$.messager.alert('ʧ��',""+(rtn.split('^')[1]||rtn),'error');
							}
						}
					)
				}) //end confirmPwd
			}) //end checkTransEMR
		}) //end checkTransOrd
	}
	
	if(GV.CareProvType!='DOCTOR' && GV.AllowNurExec!='1') {
		$('#btnSave').hide();
	}
	
	$('#btnSave').click(saveTrans);
	$('#btnClose').click(function(){
		closeWin();
	})
	$(window).resize(GV.util.debounce(function(){
		
		if($('#contact-tr').is(':visible')) {
			var lasttdwidth=$('#ConResult').combobox('textbox').closest('.combo').outerWidth();
			$('.form-table .lasttd').width(lasttdwidth);
		}
		
	},200));
	if (GV.ShowProcess=='1'){
		var pModal=findThisModal()
		if (pModal && pModal.length) {
			var size={};
			if (pModal.width()<1050) {
				size.width=1150;
			}
			if (GV.SendTime>0 && pModal.height()<720) {
				size.height=720;
			}
			if(size.width||size.height){
				pModal.window('resize',size).window('center');
				$(window).resize();
			}
		}
	}
	$(window).resize();
	
	if (GV.OnlyView=='1') {
		$('#buttons').find('.l-btn').not('#btnClose').hide();
	}

	if (GV.reportInfoObj.repStatus=='D' ) {
		$.messager.alert('��ʾ',"Σ��ֵ�ѱ�����",'info');
		$('#buttons').find('.l-btn').not('#btnClose').hide();
		
	}
	
	if ($('#btnRecFwDoc').is(':visible') && !$('#btnRecFwDoc').linkbutton('options').disabled ) {
		
		initFwDoc();	
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
	GV.requestMsg='��������Σ��ֵ����';
	$.m({
		ClassName:'web.DHCAntCVReportSearch',
		MethodName:'GetAllInfo',
		reportID:GV.RepType+'||'+GV.ReportId
	},function(ret){
		GV.requestMsg='';
		try{
			var obj=$.parseJSON(ret);
		}catch(e){
			var obj={success:0,msg:'�������ݸ�ʽ����'}
		}
		if (obj && obj.success=='1'){
			obj.repTypeNoDesc=$g(obj.repTypeDesc+'��')
			$('.data-ele').each(function(){
				var t=$(this);
				var key=t.data('key'),mth=t.data('mth')||'text';
				t[mth]( obj[key]||'');
			})
			GV.reportInfoObj=obj;
			
			////
			GV.dicConResultExec=$.cm({ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'ConResultExec',rows:999,ResultSetType:'array'},false);
			GV.dicConResultRec=$.cm({ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'ConResultRec',rows:999,ResultSetType:'array'},false);
			
			
			var processUrl='criticalvalue.process.csp?reportID='+GV.reportID;
			processUrl=common.getTokenUrl(processUrl);
			$('#CVProcessFrame').attr('src',processUrl);
			
			
			init();
		}else{
			$.messager.alert("����",obj.msg,function(){
				closeWin()
			},'error');
		}
		
	})
});