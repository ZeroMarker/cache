var ShowSelectCPWDialog = function(){
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
			param.ResultSetType = 'array';
		}
	});
	
	var firstID="";		//第一个表单
	var selectID="";	//选择的表单
	var QCEntityID="";
	var CPWArr=CPWStr.split(",");

	firstID=CPWArr[0].split("^")[0]	//默认取第一个，表示不入该路径
	var CPWClass="";
	var CPWHtml="<div id='CPW-NotIn' class='CPW-Select NotIn'>不入径申请</div>";
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
			$.messager.alert("错误提示", "请先点击要进入的路径或不入径申请再进行操作！", "error");
			return;	
		}else{
			if(btnTxt=="确定"){		//入径
				var ret =$m({
					ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
					MethodName:"GetInCPW",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+QCEntityID
				}, false);
				if(parseInt(ret)>0){
					$.messager.popover({msg: '入径成功！',type:'info',timeout: 2000});
				}else{
					$.messager.popover({msg: '入径失败！',type:'info',timeout: 2000});
				}
			 		setTimeout(function(){
					websys_showModal('close');
				},2300)
				//关闭窗口
			}else if(btnTxt=="提交"){	//不入径
				var verID=Common_GetValue('NotInReason')
				var verTxt=Common_GetValue('NotInText')
			
				if((verID == "")&&(verTxt == "")){
					$.messager.alert("错误提示", "请选择原因并填写备注信息！", "error")
					return;
				}else if(verID == "") {
					$.messager.alert("错误提示", "请选择不入径原因！", "error")
					return;
				}else if(verTxt == "") {
					$.messager.alert("错误提示", "请填写备注信息！", "error")
					return;
				}
			
				var ret =$m({
					ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
					MethodName:"NotInApply",
					aEpisodeID:EpisodeID,
					aInputs:selectID+"^"+session['DHCMA.USERID']+"^"+session['DHCMA.CTLOCID']+"^"+session['DHCMA.CTWARDID']+"^"+verID+"^"+verTxt
				}, false);
				if(parseInt(ret)>0){
					$.messager.popover({msg:"申请成功",type:'success',timeout: 2000,});
				}else{
					$.messager.popover({msg:"申请失败",type:'error',timeout: 2000,});
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
	$('#NotInApply').css('display','block');
	$('#InitText').css('display','none');
	$('#Summary').css('display','none');
	$('#btnGetIn .l-btn-text').text("提交")
	$('#CPWDiag-right').panel("header").find('div.panel-title').text("申请")
}
var SelectCPW = function(ID){
	$('#btnGetIn .l-btn-text').text("确定")
	$('#CPWDiag-right').panel("header").find('div.panel-title').text("路径说明")
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