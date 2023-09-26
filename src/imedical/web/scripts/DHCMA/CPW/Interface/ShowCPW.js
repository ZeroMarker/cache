var ShowSelectCPWDialog = function(){
	$.parser.parse(); // ��������ҳ�� 
	$('#NotInApply').css('display','none');
	$('#InitText').css('display','block');
	$('#Summary').css('display','none');
	
	var NotInReason = $HUI.combobox('#NotInReason', {
		url: $URL,
		editable: false,
		placeholder:'��ѡ��',
		valueField: 'VarID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVariatSrv';
			param.QueryName = 'QryVerByTypeCat';
			param.aTypeCode = '03';
			param.aCatCode = '';
			param.ResultSetType = 'array';
		}
	});
	
	var firstID="";		//��һ����
	var selectID="";	//ѡ��ı�
	var QCEntityID="";
	var CPWArr=CPWStr.split(",");

	firstID=CPWArr[0].split("^")[0]	//Ĭ��ȡ��һ������ʾ�����·��
	var CPWClass="";
	var CPWHtml="<div id='CPW-NotIn' class='CPW-Select NotIn'>���뾶����</div>";
	for(var ind = 0,len = CPWArr.length; ind < len; ind++){
		var tmpCPW=CPWArr[ind];
		/*
		if(ind==0) {
			CPWClass="CPW-Select MayIn CPWactive";
		}else{
			CPWClass="CPW-Select MayIn";
		}*/
		CPWClass="CPW-Select MayIn";
		CPWHtml=CPWHtml+"<div id='CPW-"+tmpCPW.split("^")[0]+"' class='"+CPWClass+"'>"+tmpCPW.split("^")[1]+"</div>"
	}
	$('#CPWList').html(CPWHtml);
	
	$('#InCPWDialog').on('click','#CPW-NotIn',function(){
		NotInApply(firstID);
		selectID=firstID;
		QCEntityID=""
	});
	$('#InCPWDialog').on('click','.MayIn',function(){
		$('.MayIn').removeClass("CPWactive")
		$('#'+this.id).addClass("CPWactive");
		selectID=this.id.split("-")[1];
		QCEntityID=this.id.split("-")[2];
		SelectCPW(selectID);
	});
	
	$("#btnClose").on('click',function(){			
		if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
	});	
	$("#btnGetIn").on('click',function(){			
		var btnTxt=$('#btnGetIn .l-btn-text').text()
		if (!selectID){
			$.messager.alert("������ʾ", "���ȵ��Ҫ�����·�����뾶�����ٽ��в�����", "error");
			return;	
		}else{
			if(btnTxt=="ȷ��"){		//�뾶
				var ret =$m({
					ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
					MethodName:"GetInCPW",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+QCEntityID
				}, false);
				if(parseInt(ret)>0){
					$.messager.popover({msg: '�뾶�ɹ���',type:'info',timeout: 2000});
				}else{
					$.messager.popover({msg: '�뾶ʧ�ܣ�',type:'info',timeout: 2000});
				}
			 		setTimeout(function(){
					websys_showModal('close');
				},2300)
				//�رմ���
			}else if(btnTxt=="�ύ"){	//���뾶
				var verID=Common_GetValue('NotInReason')
				var verTxt=Common_GetValue('NotInText')
			
				if((verID == "")&&(verTxt == "")){
					$.messager.alert("������ʾ", "��ѡ��ԭ����д��ע��Ϣ��", "error")
					return;
				}else if(verID == "") {
					$.messager.alert("������ʾ", "��ѡ���뾶ԭ��", "error")
					return;
				}else if(verTxt == "") {
					$.messager.alert("������ʾ", "����д��ע��Ϣ��", "error")
					return;
				}
			
				var ret =$m({
					ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
					MethodName:"NotInApply",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+verID+"^"+verTxt
				}, false);
				if(parseInt(ret)>0){
					$.messager.popover({msg:"����ɹ�",type:'success',timeout: 2000,});
				}else{
					$.messager.popover({msg:"����ʧ��",type:'error',timeout: 2000,});
				}
				//�رմ���
			 	setTimeout(function(){
					websys_showModal('close');
				},2300)
			}else{
			
			}
		}
	});
}
var NotInApply = function(ID){
	$('#NotInApply').css('display','block');
	$('#InitText').css('display','none');
	$('#Summary').css('display','none');
	$('#btnGetIn .l-btn-text').text("�ύ")
	$('#CPWDiag-right').panel("header").find('div.panel-title').text("����")
}
var SelectCPW = function(ID){
	$('#btnGetIn .l-btn-text').text("ȷ��")
	$('#CPWDiag-right').panel("header").find('div.panel-title').text("·��˵��")
	$('#NotInApply').css('display','none');
	$('#InitText').css('display','none');
	$('#Summary').css('display','block');
	$m({
		ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
		MethodName:"GetCPWSummary",
		aPathID:ID
	},function(Summary){	
		$('#Summary').html(Summary)
	});
}