var CHR_1=String.fromCharCode(1);
var ShowSelectCPWDialog = function(){
	
	var obj = new Object();
	$.parser.parse(); // 解析整个页面 
	$('#NotInApply').css('display','none');
	$('#InitText').css('display','block');
	$('#Summary').css('display','none');
	
	var NotInReason = $HUI.combobox('#NotInReason', {
		url: $URL,
		editable: false,
		placeholder:'请选择',
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

	visitID="";		//所选择表单上次入径visitID
	selectID="";	//所选择表单formID
	diagnos="";		//所选路径引发入径的诊断字符串$c(1)分隔
	var CPWArr=CPWStr.split(",");
	var CPWHtml="<div id='CPW-NotIn' class='CPW-Select NotIn'>"+$g("不入径申请")+"</div><hr style='border:0;margin:0 atuo;height:1px;background-color:#cccccc;'/>";
	for(var ind = 0,len = CPWArr.length; ind < len; ind++){
		var tmpCPW=CPWArr[ind];
		CPWClass="CPW-Select MayIn";
		if (tmpCPW.split("^")[2]!=""){
			CPWHtml=CPWHtml+"<div id='CPW-"+tmpCPW.split("^")[0]+"' class='"+CPWClass+"' visit='"+tmpCPW.split("^")[2]+"' diagnos='"+tmpCPW.split("^")[3]+"'>"+tmpCPW.split("^")[1]+"<img style='float:right' src='../images/webemr/临床路径.png' border='0' /></div>"	
		}else{
			CPWHtml=CPWHtml+"<div id='CPW-"+tmpCPW.split("^")[0]+"' class='"+CPWClass+"' visit='"+tmpCPW.split("^")[2]+"' diagnos='"+tmpCPW.split("^")[3]+"'>"+tmpCPW.split("^")[1]+"</div>"
		}
	}
	$('#CPWList').html(CPWHtml);
	
	//初始化显示选中第一条路径
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

	$("#btnGetIn").on('click',function(){			
		var btnTxt=$('#btnGetIn .l-btn-text').text();
		if (!selectID){
			$.messager.alert($g("错误提示"), $g("请先点击要进入的路径或不入径申请再进行操作！"), "error");
			return;	
		}else{
			if(btnTxt==$g("入径")){		//入径
				var aInputStr=selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+visitID+"^"+diagnos;
				//CA签名验证
				CASignLogonModal('OPCPW','GetInOPCPW',{
					// 签名数据
					signData: aInputStr,
					dhcmaOperaType:'I'
				},GetInOPCPWFun,EpisodeID,aInputStr);			
			}else if(btnTxt==$g("提交")){	//不入径
				var verID=Common_GetValue('NotInReason')
				var verTxt=Common_GetValue('NotInText')
			
				if((verID == "")&&(verTxt == "")){
					$.messager.alert($g("错误提示"), $g("请选择原因并填写备注信息！"), "error")
					return;
				}else if(verID == "") {
					$.messager.alert($g("错误提示"), $g("请选择不入径原因！"), "error")
					return;
				}else if(verTxt == "") {
					$.messager.alert($g("错误提示"), $g("请填写备注信息！"), "error")
					return;
				}
			
				var ret =$m({
					ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
					MethodName:"ApplyNotInPath",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+verID+"^"+verTxt+"^"+visitID
				}, false);
				if(parseInt(ret)>0){
					$.messager.popover({msg:$g("申请成功"),type:'success',timeout: 2000});
				}else{
					$.messager.popover({msg:$g("申请失败"),type:'error',timeout: 2000});
				}
				//关闭窗口
			 	setTimeout(function(){
					websys_showModal('close');
				},2300)
			}else{
			
			}
		}
	});

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
		$('#btnGetIn .l-btn-text').text($g("提交"))
		$('#CPWDiag-right').panel("header").find('div.panel-title').text($g("申请"))
	}
	function SelectCPW(obj){
		$('#CPW-NotIn').removeClass("NotIn-Select");
		$('#CPW-NotIn').addClass("NotIn");
		$('.MayIn').removeClass("CPWactive");
		$('#'+obj.id).addClass("CPWactive");
		selectID=obj.id.split("-")[1];
		visitID=obj.getAttribute("visit");
		diagnos=obj.getAttribute("diagnos");
		$('#btnGetIn .l-btn-text').text($g("入径"))
		$('#CPWDiag-right').panel("header").find('div.panel-title').text($g("路径说明"))
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
			//Set return=PathName_"^"_FirstInDate_"^入径第"_InDays_"天（第"_(InWayCount+1)_"次）^"_CurStep_"^"_NextStep_"^"_ApplyPerson_"^"_HelpDoc
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
	
	// 入径方法
	GetInOPCPWFun = function(aEpisodeID,aInputStr){
		var ret =$m({
			ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
			MethodName:"GetInOPCPW",
			aEpisodeID:aEpisodeID,
			aInputs:aInputStr,
			aBtnType:"btnGetIn"
		}, false);
		if(parseInt(ret)>0){
			$.messager.popover({msg: $g('入径成功！'),type:'info',timeout: 2000});
		}else{
			$.messager.popover({msg: $g('入径失败！'),type:'info',timeout: 2000});
		}
		setTimeout(function(){
			websys_showModal('close');
		},2300)
		if(parseInt(ret)>0) return parseInt(ret);
	} 
	
}





