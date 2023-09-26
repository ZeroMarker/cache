var CHR_1=String.fromCharCode(1);
var ShowSelectCPWDialog = function(){
	
	var obj = new Object();
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
			param.aAdmType = 'O';
			param.ResultSetType = 'array';
		}
	});
	obj.OutReason = $HUI.combobox('#OutReason', {
		url: $URL,
		editable: false,
		placeholder:'��ѡ��',
		valueField: 'VarID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVariatSrv';
			param.QueryName = 'QryVerByTypeCat';
			param.aTypeCode = '02';
			param.aCatCode = '';
			param.aAdmType = 'O';
			param.ResultSetType = 'array';
		}
	});
	visitID="";		//��ѡ����ϴ��뾶visitID
	selectID="";	//��ѡ���formID
	diagnos="";		//��ѡ·�������뾶������ַ���$c(1)�ָ�
	var CPWArr=CPWStr.split(",");
	var CPWHtml="<div id='CPW-NotIn' class='CPW-Select NotIn'>���뾶����</div><hr style='border:0;margin:0 atuo;height:1px;background-color:#cccccc;'/>";
	for(var ind = 0,len = CPWArr.length; ind < len; ind++){
		var tmpCPW=CPWArr[ind];
		CPWClass="CPW-Select MayIn";
		if (tmpCPW.split("^")[2]!=""){
			CPWHtml=CPWHtml+"<div id='CPW-"+tmpCPW.split("^")[0]+"' class='"+CPWClass+"' visit='"+tmpCPW.split("^")[2]+"' diagnos='"+tmpCPW.split("^")[3]+"'>"+tmpCPW.split("^")[1]+"<img style='float:right' src='../images/webemr/�ٴ�·��.png' border='0' /></div>"	
		}else{
			CPWHtml=CPWHtml+"<div id='CPW-"+tmpCPW.split("^")[0]+"' class='"+CPWClass+"' visit='"+tmpCPW.split("^")[2]+"' diagnos='"+tmpCPW.split("^")[3]+"'>"+tmpCPW.split("^")[1]+"</div>"
		}
		
	}
	$('#CPWList').html(CPWHtml);
	
	//��ʼ����ʾѡ�е�һ��·��
	SelectCPW($(".MayIn").eq(0)[0]);
	InitHtml(visitID,selectID);
	$('#InCPWDialog').on('click','#CPW-NotIn',function(){
		InitHtml(visitID,selectID);
		NotInApply(selectID);
	});
	
	$('#InCPWDialog').on('click','.MayIn',function(){
		SelectCPW(this);
		InitHtml(visitID,selectID);
	});
	/*
	$("#btnClose").on('click',function(){			
		if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
	});
	*/	
	$("#btnGetIn").on('click',function(){			
		var btnTxt=$('#btnGetIn .l-btn-text').text();
		if (!selectID){
			$.messager.alert("������ʾ", "���ȵ��Ҫ�����·�����뾶�����ٽ��в�����", "error");
			return;	
		}else{
			if(btnTxt=="�뾶"){		//�뾶
				var ret =$m({
					ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
					MethodName:"GetInOPCPW",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+visitID+"^"+diagnos,
					aBtnType:"btnGetIn"
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
					ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
					MethodName:"ApplyNotInPath",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+verID+"^"+verTxt+"^"+visitID
				}, false);
				if(parseInt(ret)>0){
					$.messager.popover({msg:"����ɹ�",type:'success',timeout: 2000});
				}else{
					$.messager.popover({msg:"����ʧ��",type:'error',timeout: 2000});
				}
				//�رմ���
			 	setTimeout(function(){
					websys_showModal('close');
				},2300)
			}else{
			
			}
		}
	});
	/*
	$(".histInbtn").on('click',function(){
		if (!selectID){
			$.messager.alert("������ʾ", "���ȵ��Ҫ�����·���ٽ��в�����", "error");
			return;	
		}
		
		if(this.id == "btnContPath"){
			var ret =$m({
				ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
				MethodName:"GetInOPCPW",
				aEpisodeID:EpisodeID,
				aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+visitID+"^"+diagnos,
				aBtnType:this.id
			}, false);
			if(parseInt(ret)>0){
				$.messager.popover({msg:"�뾶�ɹ�",type:'success',timeout: 2000,});
			}else{
				$.messager.popover({msg:"�뾶ʧ��",type:'error',timeout: 2000,});
			}
			//�رմ���
			 setTimeout(function(){
				websys_showModal('close');
			},2300)
		}else if(this.id == "btnOutPath"){
			$HUI.dialog('#OutCPWDialog').open();
			$("#btn-OutCPWDialog").on('click',function(){
				var verID = Common_GetValue('OutReason')
				var verTxt = Common_GetValue('OutText')
				var errorInfo = "";
				if (verID == "") {
					errorInfo = "��ѡ�����ԭ��<br />"
				}
				if (verTxt == "") {
					errorInfo = errorInfo + "����д��ע��Ϣ��"
				}
				if (errorInfo != "") {
					$.messager.alert("������ʾ", errorInfo, "error")
					return;
				}
				$m({
					ClassName: "DHCMA.CPW.OPCPS.InterfaceSrv",
					MethodName: "GetOutOPCPW",
					aEpisodeID: EpisodeID,
					aInputs: "" + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID'] + "^" + verID + "^" + verTxt + "^" + visitID
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: "�����ɹ�", type: 'success' });
						$HUI.dialog('#OutCPWDialog').close();
					}
				})
				setTimeout(function(){
					websys_showModal('close');
				},2300)
			})			
		}else{
		 	return;
		}
	})
	*/
	function NotInApply(ID){
		$('#CPW-NotIn').removeClass("NotIn");
		$('#CPW-NotIn').addClass("NotIn-Select");
		$('.MayIn').removeClass("CPWactive");
		$('#CPWName').css('display','block');
		$('#SplitLine').css('display','block');
		$('#NotInApply').css('display','block');
		$('#InitText').css('display','none');
		$('#Summary').css('display','none');
		//$('.histInbtn').hide();
		$('#btnGetIn .l-btn-text').text("�ύ")
		$('#CPWDiag-right').panel("header").find('div.panel-title').text("����")
	}
	function SelectCPW(obj){
		$('#CPW-NotIn').removeClass("NotIn-Select");
		$('#CPW-NotIn').addClass("NotIn");
		$('.MayIn').removeClass("CPWactive");
		$('#'+obj.id).addClass("CPWactive");
		selectID=obj.id.split("-")[1];
		visitID=obj.getAttribute("visit");
		diagnos=obj.getAttribute("diagnos");
		$('#btnGetIn .l-btn-text').text("�뾶")
		$('#CPWDiag-right').panel("header").find('div.panel-title').text("·��˵��")
		$('#NotInApply').css('display','none');
		$('#InitText').css('display','none');
		$('#CPWName').css('display','block');
		if (visitID!=""){
			$('#LastPathInfo').css('display','block');
			//$('.histInbtn').show();
			//$('#btnGetIn').show();
		}else{
			$('#LastPathInfo').css('display','none');
			//$('.histInbtn').hide();
			//$('#btnGetIn').show();
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





