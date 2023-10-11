var obj = new Object();	
function InitCPForm(){
    $.parser.parse(); // 解析整个页面
	obj.InitCPWInfo();
	
	return obj;
}

//加载路径基本信息
obj.InitCPWInfo = function() {
	$m({
		ClassName: "DHCMA.CPW.CPS.ImplementSrv",
		MethodName: "GetCPWInfo",
		aEpisodeID: EpisodeID
	}, function (JsonStr) {
		if (JsonStr == "") return;
		var JsonObj = $.parseJSON(JsonStr);
		obj.CPWCurrDesc = JsonObj.CPWDesc;		//当前路径名称
		obj.CPWStatus = JsonObj.CPWStatus;		//当前路径状态
		obj.PathFormID = JsonObj.PathFormID		//当前路径的表单ID
		obj.PathwayID = JsonObj.PathwayID		//出入径记录ID
		obj.CurrEpID = JsonObj.CPWEpisID		//当前阶段ID
		obj.CurrEpNo = JsonObj.CurrEpisNo		//当前阶段序号

		$('#CPWDesc').text(JsonObj.CPWDesc)
		$('#CPWStatus').text(JsonObj.CPWStatus)
		$('#CPWUser').text(JsonObj.CPWUser)
		$('#CPWTime').text(JsonObj.CPWTime)

		var htmlIcon = ""
		htmlIcon = htmlIcon + '<span class="Icon Icon-D">'+$g('单')+'</span>'
		htmlIcon = htmlIcon + '<span class="Icon Icon-B">'+$g('变')+'</span>'
		htmlIcon = htmlIcon + '<span class="Icon Icon-T">T</span>'
		htmlIcon = htmlIcon + '<span class="Icon Icon-Y">¥</span>'
		$('#CPWIcon').html(htmlIcon)
		$(".Icon-D").popover({
			content: $g('单病种信息：') + JsonObj.SDDesc
		});
		$(".Icon-B").popover({
			content: JsonObj.VarDesc
		});
		$(".Icon-T").popover({
			content: $g('入径天数：') + JsonObj.CPWDays + $g('天')+'<br />'+$g('计划天数：') + JsonObj.FormDays + $g('天')
		});
		$(".Icon-Y").popover({
			content: $g('住院总费用：') + JsonObj.PatCost + '<br />'+$g('计划费用：') + JsonObj.FormCost + $g('元')
		});
		
		if((obj.CPWStatus == $g("出径"))||(obj.CPWStatus == $g("完成"))||(obj.CPWStatus == $g("作废"))){
			$('#btnExecute').linkbutton("disable");
			$('#btnCancel').linkbutton("disable");
			//$('#menubtn-blue').linkbutton("disable");			//保证作废时样式与其他按钮一致
			$('#menubtn-blue').unbind();
			$('#menubtn-blue').css({'background-color': '#bbb',"pointer-events":"none"});	
		}
		if(UserType=="MED"){
			$('#btnExecute').linkbutton("disable");
			$('#btnCancel').linkbutton("disable");
			//$('#menubtn-blue').menubutton("disable");
			$('#menubtn-blue').unbind();
			$('#menubtn-blue').css({'background-color': '#bbb',"pointer-events":"none"});
		}
		obj.InitCPWSteps();	//步骤信息
	});
}

obj.InitCPWSteps = function() {
	obj.ItmChecked=[];	//选中的项目
	obj.StepChecked=[];	//处理全选
	obj.EpisChecked={};	//处理全选
	obj.arrEpisDate=[];	//全部阶段时间
	
	obj.ItmCheckedType=0;
	var EpisList =$m({
		ClassName:"DHCMA.CPW.CPS.EpisSrv",
		QueryName:"QryEpis",
		ResultSetType:'array',
		aPathwayID:obj.PathwayID
	}, false);
	
	var objStr = JSON.parse(EpisList);
	var len = objStr.length;
	var EpisHtml="",innerHtml="";
	for (var ind=0; ind <len;ind++) {
		var EpisID    = objStr[ind].EpisID;
		var EpisDesc  = objStr[ind].EpisDesc;
		var SignDoc	  = objStr[ind].SignDoc;
		var SignNur	  = objStr[ind].SignNur;
		var SttDate   = objStr[ind].SttDate;
		var SttTime   = objStr[ind].SttTime;
		var EndDate   = objStr[ind].EndDate;
		var EndTime	  = objStr[ind].EndTime;
		var EpisNo	  = objStr[ind].EpisIndNo
		var SttDateTime = (SttTime != "" && SttTime != undefined) ? SttDate + " " + SttTime : SttDate;
		var EndDateTime = (EndTime != "" && EndTime != undefined) ? EndDate + " " + EndTime : EndDate;
		
		if ( SttDateTime && EndDateTime ){
			tmpJsonDate={};
			tmpJsonDate["EpisID"] = EpisID;
			tmpJsonDate["DateFrom"] = SttDateTime;
			tmpJsonDate["DateEnd"] = EndDateTime;
			obj.arrEpisDate.push(tmpJsonDate);
		} 
		
		//异步加载各阶段项目内容
		(function(tmpEpisID,tmpEpisNo){
			$m({
				ClassName:"DHCMA.CPW.CPS.ImplSrv",
				QueryName:"QryImplItems",
				ResultSetType:'array',
				aPathwayID:obj.PathwayID,
				aEpisID:tmpEpisID
			},function(itmList){
				var objitm = JSON.parse(itmList);
				var ZLHtml="",HLHtml="",YZHtml="",ItmsHtml="";
				for (var jnd=0,jen=objitm.length;jnd<jen;jnd++){
					var ItmID=objitm[jnd].ImplID;
					var ItmDesc=objitm[jnd].ItemDesc;
					var ItmTypeDesc=objitm[jnd].TypeDesc;
					var ItmIsOption=parseInt(objitm[jnd].IsOption);
					var ItmIsImp=parseInt(objitm[jnd].IsImp);
					var ItmIsVar=parseInt(objitm[jnd].IsVar);
					
					// 根据配置决定选择框是否可用  Modified by yankai 20220321
					var retConfig = $m({
						ClassName:"DHCMA.Util.BT.Config",
						MethodName:"GetValueByCode",
						aCode:"CPWCPFormItemActive",
						aHospID:session['DHCMA.HOSPID']
					},false)
					
					if (retConfig == "0"){		
						if(obj.CurrEpNo == tmpEpisNo) isDisabled=false;
						else isDisabled = true;
					}else if(retConfig == "1"){
						if(obj.CurrEpNo >= tmpEpisNo) isDisabled=false;
						else isDisabled = true;
					}else if (retConfig == "2"){
						isDisabled = false;
					}else{
						isDisabled = true;
					}
					if (!isDisabled){		//isDisabled=false
						if (UserType == "D"){
							if(ItmTypeDesc == $g("主要护理工作")) isDisabled=true
						}else if(UserType == "N"){
							if(ItmTypeDesc != $g("主要护理工作")) isDisabled=true
						}else{
						}
					} 
					
					var itmClass="normal";
					//if(ItmIsOption) itmClass="optional"
					if(ItmIsImp){
						itmClass += " done";
					}else if(ItmIsVar){
						itmClass += " variat";
					}
					
					//var ItmHtml="<li class='"+itmClass+"'><input label='' id='Itm-"+ItmID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkItm(event,value,"+ItmIsImp+")}\" class='hisui-checkbox' type='checkbox'><label for='Itm-"+ItmID+"'>"+ItmDesc+"</label></li>"
					if (ItmIsOption){
						var ItmHtml="<li class='"+itmClass+"'><input label='' id='Itm-"+ItmID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkItm(event,value,"+ItmIsImp+")}\" class='hisui-checkbox' type='checkbox'><label class='lab-checkbox' for='Itm-"+ItmID+"'>"+ItmDesc+"</label></li>"	
					}else{
						var ItmHtml="<li class='"+itmClass+"'><input label='' id='Itm-"+ItmID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkItm(event,value,"+ItmIsImp+")}\" class='hisui-checkbox' type='checkbox'><label class='lab-checkbox' for='Itm-"+ItmID+"'>"+"<span style='color:red'>*</span>"+ItmDesc+"</label></li>"	
					}

					if(ItmTypeDesc == $g("主要诊疗工作")){
						ZLHtml += ItmHtml;
						var id="ItmTypeZL-"+tmpEpisID
					}else if(ItmTypeDesc == $g("重点医嘱")){
						YZHtml += ItmHtml;
						var id="ItmTypeYZ-"+tmpEpisID
					}else{
						HLHtml += ItmHtml;
						var id="ItmTypeHL-"+tmpEpisID
					}
					if(!isDisabled) {
						if(typeof(obj.EpisChecked[id])=="undefined") obj.EpisChecked[id]=[];
						obj.EpisChecked[id].push(ItmID);
					}
				}
				if(ZLHtml != ""){
					isDisabled=(UserType=="D")?false:true;
					if((!obj.EpisChecked["ItmTypeZL-"+tmpEpisID])||(obj.EpisChecked["ItmTypeZL-"+tmpEpisID].length<1)) isDisabled=true;
					ItmsHtml += "<div class='itmtype'><input label='' id='ItmTypeZL-"+tmpEpisID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkType(event,value)}\" class='hisui-checkbox' type='checkbox'/><label class='lab-checkbox' for='ItmTypeZL-"+tmpEpisID+"'>"+$g('主要诊疗工作')+"</label></div>"
					ItmsHtml += "<div class='itmlist'><ul>"+ZLHtml+"</ul></div>";
				}
				if(YZHtml != ""){
					isDisabled=(UserType=="D")?false:true;
					if((!obj.EpisChecked["ItmTypeYZ-"+tmpEpisID])||(obj.EpisChecked["ItmTypeYZ-"+tmpEpisID].length<1)) isDisabled=true;
					ItmsHtml += "<div class='itmtype'><input label='' id='ItmTypeYZ-"+tmpEpisID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkType(event,value)}\" class='hisui-checkbox' type='checkbox'/><label class='lab-checkbox' for='ItmTypeYZ-"+tmpEpisID+"'>"+$g('重点医嘱')+"</label></div>"
					ItmsHtml += "<div class='itmlist'><ul>"+YZHtml+"</ul></div>";
				}
				if(HLHtml != ""){
					isDisabled=(UserType=="N")?false:true;
					if((!obj.EpisChecked["ItmTypeHL-"+tmpEpisID])||(obj.EpisChecked["ItmTypeHL-"+tmpEpisID].length<1)) isDisabled=true;
					ItmsHtml += "<div class='itmtype'><input label='' id='ItmTypeHL-"+tmpEpisID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkType(event,value)}\" class='hisui-checkbox' type='checkbox'/><label class='lab-checkbox' for='ItmTypeHL-"+tmpEpisID+"'>"+$g('主要护理工作')+"</label></div>"
					ItmsHtml += "<div class='itmlist'><ul>"+HLHtml+"</ul></div>";
				}
				var EpisConID="#EpisID-"+tmpEpisID+" .episItems";
				$(EpisConID).html(ItmsHtml); 
				$.parser.parse(EpisConID); 
			})
		})(EpisID,EpisNo)	//解决闭包

		var Datestr="";
		if(SttDateTime == ""){
			Datestr = $g("未执行");
		}else if(EndDateTime == ""){
			Datestr = "<input id='DateFrom_"+EpisID+"' class='hisui-datetimebox episDatebox' arrIndex="+ind+" value='"+SttDateTime+"'/>"+$g("至今");
		}else{
			Datestr = "<input id='DateFrom_"+EpisID+"' class='hisui-datetimebox episDatebox' arrIndex="+ind+" value='"+SttDateTime+"'/>"+$g("至")+"<input id='DateEnd_"+EpisID+"' class='hisui-datetimebox episDatebox' arrIndex="+ind+" value='"+EndDateTime+"'/><span style='float:right'><a href='#' id='editDate' onclick='editEpisDate("+EpisID+")' style='margin:0;padding:0;' class='hisui-linkbutton' title="+$g('修改阶段日期')+" data-options='iconCls:\"icon-edit\",plain:true'></a></span>";
		}
		var Signstr="";
		SignDoc=SignDoc||$g("医生未签名");
		SignNur=SignNur||$g("护士未签名");
		Signstr="<span id='SignDoc-"+EpisID+"'>"+SignDoc+"</span> / <span id='SignNur-"+EpisID+"'>"+SignNur+"</span>";
		var Signimg="<span style='float:right' ><a href='#' class='btnsign' id='btnsign'>"+$g('签名')+"</a><a href='#' class='btnsign' id='btncancel'>"+$g('撤销')+"</a><span/>"
		
		var Episclass=(ind==len-1)?"epis lastepis":"epis"
		EpisHtml = "<div id=EpisID-"+EpisID+" class='"+Episclass+"'>"
		EpisHtml +=		"<div class='episDesc'>"+EpisDesc+"</div>"
		EpisHtml +=		"<div class='episDate' style='height:30px'>"+Datestr+"</div>"
		EpisHtml +=		"<div class='episSign'>"+Signstr+Signimg+"</div>"
		EpisHtml +=		"<div class='episItems'></div>"
		EpisHtml +=	"</div>"
		
		innerHtml += EpisHtml
	}
	$('.container').html(innerHtml); 
	$.parser.parse('.container');
	
	$('.btnsign').on('click', function () {
		if(UserType=="MED"){
			return;
		}
		
		var Flag = $m({
			ClassName:"DHCMA.Util.BT.Config",
			MethodName:"GetValueByCode",
			aCode:"CPWCPSigeFlag",
			aHospID:session['DHCMA.HOSPID']
		},false)
		if ((Flag==0)&&(obj.CPWStatus == $g("完成"))){
			$.messager.popover({
				msg: $g('已经')+obj.CPWStatus+$g(',不允许操作！'),
				type: 'error'
			});
			return
		}
		if((obj.CPWStatus == $g("出径"))||(obj.CPWStatus == $g("作废"))){
			$.messager.popover({
				msg: $g('已经')+obj.CPWStatus+$g(',不允许操作！'),
				type: 'error'
			});
		}else{
			var EpisID=$(this).parent().parent().parent().attr('id').split("-")[1];
			var signtxt=$(this).text();
			
			if(signtxt == $g("签名")){
				var VarCount = $cm({ ClassName: "DHCMA.CPW.CPS.ImplementSrv", MethodName: "CheckVarToSign", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + EpisID, aSignType: UserType }, false);
				if ((parseInt(VarCount) > 0)&&(Flag==1)&&(obj.CPWStatus == $g("完成"))) {
					$.messager.confirm($g("提示"), $g("有变异信息未处理！是否继续签名？"), function (r){
							if(r){
								obj.SignStep(UserType,EpisID);
							}	
						})
				}else{obj.SignStep(UserType,EpisID);}
			}else if(signtxt == $g("撤销")){
				obj.UnSignStep(UserType,EpisID);
			}else{
				$.messager.popover({
					msg: $g('签名设置错误'),
					type: 'error'
				});
			}
		}
	});
	
	obj.BeforeEditDate=""
    $(".episDatebox").datetimebox({
		disabled:'disabled',
		onShowPanel:function(){
			obj.BeforeEditDate=$(this).datetimebox('getValue');
		},
		onHidePanel: function(n) {
			var id = $(this).attr("id");			 
			var curType=id.split("_")[0];
			var curEpisID=id.split("_")[1];
			var date=$(this).datetimebox('getText'); 
			var arrInd=parseInt($(this).attr("arrIndex"));					 
			var preDate="",preEpisID="",nextDate="",nextEpisId="";
			//检查所选日期不能大于当前日期
			var myDate=new Date();
			var Month=myDate.getMonth()+1
			var sysDateTime=myDate.getFullYear()+"-"+Month+"-"+myDate.getDate()+" "+myDate.getHours()+":"+myDate.getMinutes()+":"+myDate.getSeconds();
			if (Common_CompareDate(date,sysDateTime)){
				$.messager.confirm($g("提示"), $g("所选时间不能大于当前时间！<br />是否重新修改？"), function (r){
					if(r){
						$('#'+id).combobox('enable').combobox('showPanel');
						return;
					}else{
						//$('#'+id).datetimebox('setValue', obj.BeforeEditDate).datetimebox({disabled:true});
						//if($("#DateEnd_"+curEpisID).length) $("#DateEnd_"+curEpisID).combobox('disable');
						//$("#DateFrom_"+curEpisID).combobox('disable');
						obj.InitCPWSteps();
						return;	
					}
				})
			}else{
				if (curType=="DateFrom"){
					//非第一阶段的检查前一阶段开始日期
					if(arrInd>0){
						preEpisID = obj.arrEpisDate[arrInd-1].EpisID;									
						preDate = $("#DateFrom_"+preEpisID).datetimebox('getText'); 	// 前一阶段开始时间
						if (!Common_CompareDate(date,preDate)){
							if (arrInd-1 != 0){		// 前一阶段不是第一阶段
								$.messager.confirm($g("提示"), $g("所选时间应大于前一阶段开始时间！<br />是否继续修改？"), function (r){
									if(r){
										$("#DateEnd_"+preEpisID).datetimebox('setValue', date);
										$("#DateFrom_"+preEpisID).combobox('enable');
										$("#DateFrom_"+preEpisID).combobox('showPanel');
									}else{
										//$('#'+id).datetimebox('setValue', obj.BeforeEditDate).datetimebox({disabled:true});
										//if($("#DateEnd_"+curEpisID).length) $("#DateEnd_"+curEpisID).combobox('disable');
										obj.InitCPWSteps();
										return;
									}	
								})	
							}else{
								$.messager.confirm($g("提示"), $g("所选时间应大于第一阶段开始时间！<br />是否重新修改？"), function (r){
									if(r){
										$('#'+id).combobox('enable').combobox('showPanel');
									}else{
										//$('#'+id).datetimebox('setValue', obj.BeforeEditDate).datetimebox({disabled:true});
										//if($("#DateEnd_"+curEpisID).length) $("#DateEnd_"+curEpisID).combobox('disable');
										obj.InitCPWSteps();
										return;	
									}
								})
							}	
						}else{
							// 最终无问题时同时更新前一阶段结束时间
							$("#DateEnd_"+preEpisID).datetimebox('setValue', date);
						}
					}
					//存在本阶段结束日期的进行检查
					if ($("#DateEnd_"+curEpisID).length){
						nextDate=$("#DateEnd_"+curEpisID).datetimebox('getText');
						if (!Common_CompareDate(nextDate,date)){
							$.messager.confirm($g("提示"), $g("所选时间应小于本阶段结束时间！<br />是否继续修改？"), function (r){
								if(r){
									$("#DateEnd_"+curEpisID).combobox('enable');
									$("#DateEnd_"+curEpisID).combobox('showPanel');
								}else{
									//$('#'+id).datetimebox('setValue', obj.BeforeEditDate);
									//$('#'+id).combobox('disable');
									//if($("#DateEnd_"+curEpisID).length) $("#DateEnd_"+curEpisID).combobox('disable');
									obj.InitCPWSteps();
									return;	
								}
							})
						}	 
					}
				}else if(curType=="DateEnd"){
					//检查本阶段开始日期
					preDate = $("#DateFrom_"+curEpisID).datetimebox('getText');
					if (!Common_CompareDate(date,preDate)){
						if (arrInd==0){
							$.messager.confirm($g("提示"), $g("所选时间应大于本阶段开始时间！<br />是否重新修改？"), function (r){
								if(r){
									$('#'+id).combobox('enable').combobox('showPanel');
								}else{
									//$('#'+id).datetimebox('setValue', obj.BeforeEditDate).datetimebox({disabled:true});
									//if($("#DateFrom_"+curEpisID).length) $("#DateFrom_"+curEpisID).combobox('disable');
									obj.InitCPWSteps();
									return;	
								}	
							})
						}else{
							$.messager.confirm($g("提示"), $g("所选时间应大于本阶段开始时间！<br />是否继续修改？"), function (r){
								if(r){
									$("#DateFrom_"+curEpisID).combobox('enable');
									$("#DateFrom_"+curEpisID).combobox('showPanel');
								}else{
									//$('#'+id).datetimebox('setValue', obj.BeforeEditDate);
									//$('#'+id).combobox('disable');
									//$("#DateFrom_"+curEpisID).combobox('disable');
									obj.InitCPWSteps();
									return;
								}	
							})	
						}
					}
					if (arrInd<obj.arrEpisDate.length-1){		//非最后阶段
						//检查下一阶段结束日期
						nextEpisId=obj.arrEpisDate[arrInd+1].EpisID;
						if ($("#DateEnd_"+nextEpisId).length){
							nextDate = $("#DateEnd_"+nextEpisId).datetimebox('getText');
							if (!Common_CompareDate(nextDate,date)){
								 $.messager.confirm($g("提示"), $g("所选时间应小于下一阶段结束时间！<br />是否继续修改？"), function (r){
									if(r){
										$("#DateFrom_"+nextEpisId).datetimebox('setValue', date);	
										$("#DateEnd_"+nextEpisId).combobox('enable');
										$("#DateEnd_"+nextEpisId).combobox('showPanel');
									}else{
										//$('#'+id).datetimebox('setValue', obj.BeforeEditDate);
										//$('#'+id).combobox('disable');
										//$("#DateFrom_"+curEpisID).combobox('disable');
										obj.InitCPWSteps();
										return;	
									}
								 })
							}else{
								// 最终无问题的，如存在下一阶段开始时间，则同时进行更新
								$("#DateFrom_"+nextEpisId).datetimebox('setValue', date);	
							}
						}
											
					}
				}	
			}
		}
	})
}

//保存修改的阶段日期
obj.SaveEditDate = function(){
	var inDateStr=""
	for (var j=0;j<obj.arrEpisDate.length;j++){
		var xEpisID=obj.arrEpisDate[j].EpisID;
		var xDateFrom=$("#DateFrom_"+xEpisID).datetimebox('getValue');
		var xDateEnd=$("#DateEnd_"+xEpisID).datetimebox('getValue');
			
		inDateStr = inDateStr+xEpisID
		inDateStr = inDateStr+"^"+xDateFrom
		inDateStr = inDateStr+"^"+xDateEnd
		inDateStr = inDateStr+"#"
	}
	var retFlag = $m({
		ClassName: "DHCMA.CPW.CPS.ImplementSrv",
		MethodName: "ChangeEpisDate",
		aPathwayID: obj.PathwayID,
		aInDateStr:inDateStr,
		aUserID:session['DHCMA.USERID']
	}, false);
	
	if(retFlag){
		$.messager.popover({ msg: $g("日期修改成功！"), type: 'success' });
		obj.InitCPWSteps();
	}else{
		$.messager.popover({ msg: $g("日期修改失败,请重试！"), type: 'error' });
	}
}

obj.SignStep = function (Type,StepSelecedID) {

	var SignText = ""; 
	if (Type=="D"){ 
		SignText = $('#SignDoc-'+StepSelecedID).text();
		if ((SignText != "医生未签名")&&(SignText!="") ){
			$.messager.popover({ msg: "不能重复签名", type: 'error' });
			return;
		}
	}else if(Type=="N"){
		SignText = $('#SignNur-'+StepSelecedID).text();
		if ((SignText != $g("护士未签名"))&&(SignText!="") ){
			$.messager.popover({ msg: $g("不能重复签名"), type: 'error' });
			return;
		}
	}
	
	// 设置CA签名参数
	var retSign=""
	var CA_Code = Type=="D"? "DocSignToCPW":"NurseSignToCPW";
	var CA_OperType = Type=="D"?"DS":"NS";						//医生签名DS,护士签名NS
	var aInputStr=obj.PathwayID + "||" + StepSelecedID + "^" + session['DHCMA.USERID'] + "^" + Type;
	
	var strCheckItm = $m({
		ClassName: "DHCMA.CPW.CPS.ImplementSrv",
		MethodName: "CheckHaveUnExItm",
		aPathwayID: obj.PathwayID,
		aEpisID: obj.PathwayID + "||" + StepSelecedID,
		aUserType: Type
	}, false)
	if (strCheckItm == "1") {
		$.messager.confirm($g("提示"), $g("存在未执行的非必选项目，确定不执行？"), function (r) {
			if (r) {
				$.messager.confirm($g("签名"), $g("确定签名?<br />签名信息：") + session['LOGON.USERNAME'], function (r) {
					if (r) {
						//CA签名验证
						CASignLogonModal('CPW',CA_Code,{
							signData: aInputStr,				// 签名数据
							dhcmaOperaType:CA_OperType,
							ModalOption:{
								isHeaderMenuOpen:false			//当前页面打开认证弹窗
							}
						},function(){
							var retSign=$m({
								ClassName: "DHCMA.CPW.CP.PathwayEpis",
								MethodName: "Sign",
								aEpisID: obj.PathwayID + "||" + StepSelecedID,
								aUserID: session['DHCMA.USERID'],
								aUserType: Type
							}, false)
							if (parseInt(retSign) > 0) {
								$.messager.popover({ msg: $g("签名成功！"), type: 'success' });
								obj.InitCPWSteps();	//步骤信息
								return retSign;
							}else{
								$.messager.popover({ msg: $g("签名失败！")+"err"+parseInt(retSign), type: 'error' });
							}	
						})
					} else {
						$.messager.popover({ msg: $g("签名取消") });
						return;
					}
				});
			} else {
				return;
			}
		});
	} else {
		//CA签名验证
		CASignLogonModal('CPW',CA_Code,{
			signData: aInputStr,				// 签名数据
			dhcmaOperaType:CA_OperType,
			ModalOption:{
				isHeaderMenuOpen:false			//当前页面打开认证弹窗
			}
		},function(){
			var retSign=$m({
				ClassName: "DHCMA.CPW.CP.PathwayEpis",
				MethodName: "Sign",
				aEpisID: obj.PathwayID + "||" + StepSelecedID,
				aUserID: session['DHCMA.USERID'],
				aUserType: Type
			}, false)
			if (parseInt(retSign) > 0) {
				$.messager.popover({ msg: $g("签名成功！"), type: 'success' });
				obj.InitCPWSteps();	//步骤信息
				return retSign;
			}else{
				$.messager.popover({ msg: $g("签名失败！")+"err"+parseInt(retSign), type: 'error' });
			}	
		})
	}
}
obj.UnSignStep = function (Type,StepSelecedID) {
	if(Type=="D"){
		var SignID="SignDoc";
	}else{
		var SignID="SignNur";
	}
	var SignTxt=$('#EpisID-'+StepSelecedID+' #'+SignID).text();
	
	if(SignTxt.indexOf($g("未签名")) > 0){
		$.messager.popover({ msg: $g("未签名无需撤销！"), type: 'error' });
		return;
	}
	
	var Signret = $m({
		ClassName: "DHCMA.CPW.CP.PathwayEpis",
		MethodName: "UnSign",
		aEpisID: obj.PathwayID + "||" + StepSelecedID,
		aUserID: session['DHCMA.USERID'],
		aUserType: Type
	}, false);
	if(parseInt(Signret) > 0){
		$.messager.popover({ msg: $g("撤销成功！"), type: 'success' });
		obj.InitCPWSteps();
	}else{
		$.messager.popover({ msg: $g("撤销失败！")+"err"+parseInt(Signret), type: 'error' });
	}
}

obj.checkItm = function(event,value,ItmIsImp){
	var ItmIDstr=event.target.id;
	if(ItmIDstr){
		var ItmID=ItmIDstr.split("-")[1];
		if(value){
			if(obj.ItmChecked.indexOf(ItmID)<0) obj.ItmChecked.push(ItmID);
			if(ItmIsImp){
				obj.ItmCheckedType+=1;
			}else{
				obj.ItmCheckedType-=1;
			}
		}else{
			obj.ItmChecked.remove(ItmID);
			if(ItmIsImp){
				obj.ItmCheckedType-=1;
			}else{
				obj.ItmCheckedType+=1;
			}
		}
	}
}
obj.checkType = function(event,value){
	var len=obj.EpisChecked[event.target.id].length
	for(var ind=0;ind<len;ind++){
		var tmpVal=obj.EpisChecked[event.target.id][ind];
		if(value){
			$('#Itm-'+tmpVal).checkbox('setValue',true);	//自动触发obj.checkItm事件
		}else{
			$('#Itm-'+tmpVal).checkbox('setValue',false);	//自动触发obj.checkItm事件
		}
	}
}
obj.MarkItm = function(markType,IsImpl){
	if(obj.ItmChecked.length < 1) {
		$.messager.popover({
			msg: $g('请先选择要操作的项目！'),
			type: 'error'
		});
		return;
	}
	if(obj.ItmChecked.length == Math.abs(obj.ItmCheckedType)) {
		if(IsImpl){
			if(obj.ItmCheckedType>0){
				$.messager.popover({
				msg: $g('无效操作'),
				type: 'info'
			});
			return;
			}
		}else{
			if(obj.ItmCheckedType<0){
				$.messager.popover({
					msg: $g('无效操作'),
					type: 'info'
				});
				return;
			}
		}
	}
	var Itms=obj.ItmChecked.join("^");
	$m({
		ClassName: "DHCMA.CPW.CPS.ImplSrv",
		MethodName: "UpdateItms",
		aItms: Itms,
		aIsImpl: IsImpl,
		aType: markType,
		aPathwayID: obj.PathwayID,
		aUserID: session['DHCMA.USERID']
	}, function (ret) {
		if (parseInt(ret) > 0) {
			$.messager.popover({
				msg: $g('操作成功'),
				type: 'success'
			});
			obj.InitCPWSteps();
		} else {
			$.messager.popover({
				msg: $g('操作失败')+',ret=' + ret,
				type: 'error'
			});
		}
	});
}
obj.Close = function(){
	websys_showModal('close');
}

function editEpisDate(aEpisID){
	$("#DateFrom_"+aEpisID).combobox('enable');
	if(document.getElementById("DateEnd_"+aEpisID)) {//js判断元素是否存在
    	$("#DateEnd_"+aEpisID).combobox('enable');
	}
	$('#DateFrom_1').combobox('disable'); //第一阶段开始日期为入径日期，不允许修改
	$("#btnChangeDate").linkbutton('enable');
}
//查找元素位置
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
          if (this[i] == val) return i;
    }
    return -1;
};
//删除元素
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};