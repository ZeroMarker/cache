var CHR_1=String.fromCharCode(1);
var ShowOPCPWView = function(){
	var obj = new Object();
	$.parser.parse(); // ��������ҳ�� 
	$('#InitText').css('display','block');
	$('#Summary').css('display','none');
	
	visitID="";		//��ѡ����ϴ��뾶visitID
	selectID="";	//��ѡ���formID
	diagnos="";		//��ѡ·�������뾶������ַ���$c(1)�ָ�
	
	var LocCPWHtml="",LocCPWInfo=""
	
	//���ξ������뾶
	$m({
		ClassName: "DHCMA.CPW.OPCPS.PathwayVisitSrv",
		MethodName: "CheckIsInPath",
		aEpisodeID: EpisodeID
	}, function (ret) {
			if(ret=="1"){
			$("#btnGetIn").hide();
			}
	})
	//���ξ��ﲻ�ǵ�������
	$m({
		ClassName: "DHCMA.CPW.OPCPS.PathwayVisitSrv",
		MethodName: "CheckIsNowDayVisit",
		aEpisodeID: EpisodeID
	}, function (ret) {
		if(ret!="1"){
			$("#btnGetIn").hide();
		}
	})
	
	var LocCPWInfo=$cm({
		ClassName:"DHCMA.CPW.OPCPS.PathwayVisitSrv",
		MethodName:"GetLocPathInfo",
		aEpisodeID:EpisodeID,
		aLocID:session['DHCMA.CTLOCID'],
		dataType:"text"
	},false)
	if(LocCPWInfo!=""){
		LocOthCPWArr=LocCPWInfo.split(",");
		for(var ind = 0 ; ind < LocOthCPWArr.length; ind++){
			var OtherCPW=LocOthCPWArr[ind];
			CPWClass="CPW-Select MayIn";
			 if (OtherCPW.split("^")[2]!=""){
				LocCPWHtml=LocCPWHtml+"<div id='CPW-"+OtherCPW.split("^")[0]+"' class='"+CPWClass+"' visit='"+OtherCPW.split("^")[2]+"' diagnos=''>"+OtherCPW.split("^")[1]+"<img style='float:right' src='../images/webemr/�ٴ�·��.png' border='0' /></div>"
			}else{ 
				LocCPWHtml=LocCPWHtml+"<div id='CPW-"+OtherCPW.split("^")[0]+"' class='"+CPWClass+"' visit='"+OtherCPW.split("^")[2]+"' diagnos=''>"+OtherCPW.split("^")[1]+"</div>"
			  }
		}
	}else{
		$.messager.alert("������ʾ", "�ÿ���û��ά��·����Ϣ��", "error");
		return;	
	}

	$('#LocOtherCPW').html(LocCPWHtml);
	
	//��ʼ����ʾѡ�е�һ��·��
	SelectCPW($(".MayIn").eq(0)[0]);
	InitHtml(visitID,selectID);
	$('#InCPWDialog').on('click','.MayIn',function(){
		SelectCPW(this);
		InitHtml(visitID,selectID);
	});
	
	/*$("#btnClose").on('click',function(){			
		if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
	});	*/
	$("#btnGetIn").on('click',function(){			
		var btnTxt=$('#btnGetIn .l-btn-text').text();
		if (!selectID){
			$.messager.alert("������ʾ", "���ȵ��Ҫ�����·�����뾶�����ٽ��в�����", "error");
			return;	
		}else{
			if(btnTxt=="����·��"){		//�뾶
				var retCheck = $m({
					ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
					MethodName:"CheckIsInOPCPW",
					aEpisodeID:EpisodeID,
					dataType:"text"
					}, false)
				if(retCheck==""){
					var ret =$m({
						ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
						MethodName:"GetInOPCPW",
						aEpisodeID:EpisodeID,
						aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+visitID+"^"+diagnos,
						aBtnType:"btnGetIn"
					}, false);
					if(parseInt(ret)>0){
						$.messager.popover({msg: '�뾶�ɹ���',type:'info',timeout: 2000});
						$("#btnGetIn").hide();
					}else{
						$.messager.popover({msg: '�뾶ʧ�ܣ�',type:'info',timeout: 2000});
					}
					setTimeout(function(){
						websys_showModal('close');
					},2300)
				}else{
					$.messager.alert("������ʾ", retCheck, "error");
					return;
				}
			}
			setTimeout(function(){
				websys_showModal('close');
			},2300)
		}
	});
		
	function SelectCPW(obj){
		$('.MayIn').removeClass("CPWactive");
		$('#'+obj.id).addClass("CPWactive");
		selectID=obj.id.split("-")[1];
		visitID=obj.getAttribute("visit");
		$('#CPWDiag-right').panel("header").find('div.panel-title').text("·��˵��")
		$('#InitText').css('display','none');
		$('#CPWName').css('display','block');
		var parentSelectorId=$('#'+obj.id).parent().attr('id');
		
		if(parentSelectorId=="CurEpInCPW"){
			$('#LastPathInfo').css('display','block');			
		}else{
			if(visitID!=""){
				$('#LastPathInfo').css('display','block');
			}else{
				$('#LastPathInfo').css('display','none');
			}
		}
		
		$('#SplitLine').css('display','block');
		$('#Summary').css('display','block');
	}
	function InitHtml(v,f){
		$m({
			ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
			MethodName:"GetOPCPWInfoAndSum",
			aVisitID:v,
			aFormID:f
		},function(data){
			//Set return=PathName_"^"_FirstInDate_"^�뾶��"_InDays_"�죨��"_(InWayCount+1)_"�Σ�^"_CurStep_"^"_NextStep_"^"_ApplyPerson_"^"_HelpDoc
			var retArr=data.split("^");
			$('#PathName').html(retArr[0]);	
			$('#FirstInDate').html(retArr[1]);
			$('#InDays').html(retArr[2]);
			$('#CurStep').html(retArr[3]);
			$('#NextStep').html(retArr[4]);
			$('#ApplyPerson').html(retArr[5]);
			$('#HelpDoc').html(retArr[6]);
		});
	}
	
}
