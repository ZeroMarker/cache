var ShowSelectCPWDialog = function(){
	$.parser.parse(); // 解析整个页面 
	$('#NotInApply').css('display','none');
	$('#InitText').css('display','block');
	$('#Summary').css('display','none');
	var canRun=true;	//防止重复提交
	
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
			param.ResultSetType = 'array';
		}
	});
	
	var firstID="";		//第一个表单
	var selectID="";	//选择的表单
	var diagoper="";
	var QCEntityID="";
	var PCEntityID="";
	var CPWArr=CPWStr.split(",");

	firstID=CPWArr[0].split("^")[0]	//默认取第一个，表示不入该路径
	var CPWClass="";
	var CPWHtml="<div id='CPW-NotIn' class='CPW-Select NotIn'>"+$g("不入径申请")+"</div><hr style='border:0;margin:0 atuo;height:1px;background-color:#cccccc;'/>";
	for(var ind = 0,len = CPWArr.length; ind < len; ind++){
		var tmpCPW=CPWArr[ind];
		/*
		if(ind==0) {
			CPWClass="CPW-Select MayIn CPWactive";
		}else{
			CPWClass="CPW-Select MayIn";
		}*/
		CPWClass="CPW-Select MayIn";
		CPWHtml=CPWHtml+"<div id='CPW-"+tmpCPW.split("^")[0]+"' data-diagoper='"+tmpCPW.split("^")[2]+"' class='"+CPWClass+"'>"+tmpCPW.split("^")[1]+"</div>"
	}
	$('#CPWList').html(CPWHtml);
	
	$('#InCPWDialog').on('click','#CPW-NotIn',function(){
		NotInApply(firstID);
		selectID=firstID;
		diagoper="";
		QCEntityID="";
		PCEntityID="";
	});
	$('#InCPWDialog').on('click','.MayIn',function(){
		$('.MayIn').removeClass("CPWactive")
		$('#'+this.id).addClass("CPWactive");
		selectID=this.id.split("-")[1];
		diagoper=$("#"+this.id).attr("data-diagoper");
		if (this.id.split("-").length>2) QCEntityID=this.id.split("-")[2];
		if (this.id.split("-").length>3) PCEntityID=this.id.split("-")[3];
		SelectCPW(selectID);
	});
	
	$("#btnClose").on('click',function(){			
		if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
	});	
	$("#btnGetIn").on('click',function(){			
		if(!canRun) return;		
		var btnTxt=$('#btnGetIn .l-btn-text').text()
		if (!selectID){
			$.messager.alert($g("错误提示"), $g("请先点击要进入的路径或不入径申请再进行操作！"), "error");
			return;	
		}else{
			if(btnTxt==$g("确定")){		//入径
				var aInputStr=selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+QCEntityID+"^"+PCEntityID+"^"+diagoper;
				//CA签名验证
				CASignLogonModal('CPW','GetInCPW',{
					// 签名数据
					signData: aInputStr,
					dhcmaOperaType:'I'
				},GetInCPWFun,EpisodeID,aInputStr);
				
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
					ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
					MethodName:"NotInApply",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+verID+"^"+verTxt
				}, false);
				if(parseInt(ret)>0){
					canRun=false;
					$.messager.popover({msg:$g("申请成功"),type:'success',timeout: 2000,});
				}else{
					$.messager.popover({msg:$g("申请失败"),type:'error',timeout: 2000,});
				}
				//关闭窗口
			 	setTimeout(function(){
					websys_showModal('close');
				},2300)
			}else{
			
			}
		}
	});
}
var NotInApply = function(ID){
	$('#CPW-NotIn').removeClass("NotIn");
	$('#CPW-NotIn').addClass("NotIn-Select");
	$('.MayIn').removeClass("CPWactive");
	$('#NotInApply').css('display','block');
	$('#InitText').css('display','none');
	$('#Summary').css('display','none');
	$('#btnGetIn .l-btn-text').text($g("提交"))
	$('#CPWDiag-right').panel("header").find('div.panel-title').text($g("申请"))
}
var SelectCPW = function(ID){
	$('#CPW-NotIn').removeClass("NotIn-Select");
	$('#CPW-NotIn').addClass("NotIn");
	$('#btnGetIn .l-btn-text').text($g("确定"))
	$('#CPWDiag-right').panel("header").find('div.panel-title').text($g("路径说明"))
	$('#NotInApply').css('display','none');
	$('#InitText').css('display','none');
	$('#Summary').css('display','block');
	$m({
		ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
		MethodName:"GetCPWSummary",
		aPathID:ID
	},function(Summary){	
		//$('#Summary').html(Summary)
		$('#PathName').html(Summary.split("^")[0]);
		$('#ApplyDoc').html(Summary.split("^")[1]);
		$('#HelpDoc').html(Summary.split("^")[2]);
	});
}
// 患者入径事件
var GetInCPWFun = function(aEpisodeID,aInputStr){
	var ret =$m({
		ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
		MethodName:"GetInCPW",
		aEpisodeID:aEpisodeID,
		aInputs:aInputStr
	}, false);
	if(parseInt(ret)>0){
		canRun=false;
		$.messager.popover({msg: $g('入径成功！'),type:'info',timeout: 2000});
	}else{
		$.messager.popover({msg: $g('入径失败！'),type:'info',timeout: 2000});
	}
 	setTimeout(function(){			//关闭窗口
		websys_showModal('close');
	},2300)
	if(parseInt(ret)>0) return parseInt(ret);
}
