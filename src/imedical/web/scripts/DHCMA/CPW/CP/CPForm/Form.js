var obj = new Object();	
function InitCPForm(){
    $.parser.parse(); // 解析整个页面
    /*
	$("#CPWPatList").lookup({
		url:$URL+"?ClassName=DHCMA.CPW.CPS.InterfaceSrv&QueryName=QryCPWVPatByWard&ResultSetType=array",
		mode:'remote',
		idField:'EpisodeID',
		textField:'PatName',
		columns:[[
			{field:'BedNo',title:'床号',width:50},  
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:100},
			{field:'PatSex',title:'性别',width:50},
			{field:'Status',title:'状态',width:50}
		]],
		pagination:false,
		onSelect:function(index,rowData){
			EpisodeID=rowData['EpisodeID'];
			obj.InitCPWInfo();
		},
		panelWidth:380,
		editable:false,
		minQueryLen:3
	});
	*/
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
		obj.CPWCurrDesc = JsonObj.CPWDesc;		//当前步骤名称
		obj.CPWStatus = JsonObj.CPWStatus;		//当前路径状态
		obj.PathFormID = JsonObj.PathFormID		//当前路径的表单ID
		obj.PathwayID = JsonObj.PathwayID			//出入径记录ID

		$('#CPWDesc').text(JsonObj.CPWDesc)
		$('#CPWStatus').text(JsonObj.CPWStatus)
		$('#CPWUser').text(JsonObj.CPWUser)
		$('#CPWTime').text(JsonObj.CPWTime)

		var htmlIcon = ""
		htmlIcon = htmlIcon + '<span class="Icon Icon-D">单</span>'
		htmlIcon = htmlIcon + '<span class="Icon Icon-B">变</span>'
		htmlIcon = htmlIcon + '<span class="Icon Icon-T">T</span>'
		htmlIcon = htmlIcon + '<span class="Icon Icon-Y">¥</span>'
		$('#CPWIcon').html(htmlIcon)
		$(".Icon-D").popover({
			content: '单病种信息：' + JsonObj.SDDesc
		});
		$(".Icon-B").popover({
			content: JsonObj.VarDesc
		});
		$(".Icon-T").popover({
			content: '入径天数：' + JsonObj.CPWDays + '天<br />计划天数：' + JsonObj.FormDays + '天'
		});
		$(".Icon-Y").popover({
			content: '住院总费用：' + JsonObj.PatCost + '<br />计划费用：' + JsonObj.FormCost + '元'
		});
		
		/*
		$m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "GetPatName",
			aEpisodeID: "3!!1" //EpisodeID
		}, function (PatName) {
			$("#CPWPatList").val(PatName);
		});
		*/
		if((obj.CPWStatus == "出径")||(obj.CPWStatus == "完成")){
			$('#btnExecute').linkbutton("disable");
			$('#btnCancel').linkbutton("disable");
			$('#menubtn-blue').menubutton("disable");
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
		var EndDate   = objStr[ind].EndDate;
		if ( SttDate && EndDate ){
			tmpJsonDate={};
			tmpJsonDate["EpisID"] = EpisID;
			tmpJsonDate["DateFrom"] = SttDate;
			tmpJsonDate["DateEnd"] = EndDate;
			obj.arrEpisDate.push(tmpJsonDate);
		} 
		
		//异步加载各阶段项目内容
		(function(tmpEpisID){
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
					
					//var isDisabled = Boolean(ItmIsImp||ItmIsVar);
					//可重复执行、撤销
					var isDisabled = Boolean(ItmIsVar);
					if (UserType == "D"){
						if(ItmTypeDesc == "主要护理工作") isDisabled=true
					}else if(UserType == "N"){
						if(ItmTypeDesc != "主要护理工作") isDisabled=true
					}else{
						isDisabled=true
					}
					var itmClass="normal";
					if(ItmIsOption) itmClass="optional"
					if(ItmIsImp){
						itmClass += " done";
					}else if(ItmIsVar){
						itmClass += " variat";
					}
					
					var ItmHtml="<li class='"+itmClass+"'><input label='' id='Itm-"+ItmID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkItm(event,value,"+ItmIsImp+")}\" class='hisui-checkbox' type='checkbox'><label for='Itm-"+ItmID+"'>"+ItmDesc+"</label></li>"
					
					if(ItmTypeDesc == "主要诊疗工作"){
						ZLHtml += ItmHtml;
						var id="ItmTypeZL-"+tmpEpisID
					}else if(ItmTypeDesc == "重点医嘱"){
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
					ItmsHtml += "<div class='itmtype'><input label='主要诊疗工作' id='ItmTypeZL-"+tmpEpisID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkType(event,value)}\" class='hisui-checkbox' type='checkbox'></div>"
					ItmsHtml += "<div class='itmlist'><ul>"+ZLHtml+"</ul></div>";
				}
				if(YZHtml != ""){
					isDisabled=(UserType=="D")?false:true;
					if((!obj.EpisChecked["ItmTypeYZ-"+tmpEpisID])||(obj.EpisChecked["ItmTypeYZ-"+tmpEpisID].length<1)) isDisabled=true;
					ItmsHtml += "<div class='itmtype'><input label='重点医嘱' id='ItmTypeYZ-"+tmpEpisID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkType(event,value)}\" class='hisui-checkbox' type='checkbox'></div>"
					ItmsHtml += "<div class='itmlist'><ul>"+YZHtml+"</ul></div>";
				}
				if(HLHtml != ""){
					isDisabled=(UserType=="N")?false:true;
					if((!obj.EpisChecked["ItmTypeHL-"+tmpEpisID])||(obj.EpisChecked["ItmTypeHL-"+tmpEpisID].length<1)) isDisabled=true;
					ItmsHtml += "<div class='itmtype'><input label='主要护理工作' id='ItmTypeHL-"+tmpEpisID+"' data-options=\"disabled:"+isDisabled+",onCheckChange:function(event,value){obj.checkType(event,value)}\" class='hisui-checkbox' type='checkbox'></div>"
					ItmsHtml += "<div class='itmlist'><ul>"+HLHtml+"</ul></div>";
				}
				var EpisConID="#EpisID-"+tmpEpisID+" .episItems";
				$(EpisConID).html(ItmsHtml); 
				$.parser.parse(EpisConID); 
			})
		})(EpisID)	//解决闭包

		var Datestr="";
		if(SttDate == ""){
			Datestr = "未执行";
		}else if(EndDate == ""){
			Datestr = "<input id='DateFrom_"+EpisID+"' class='hisui-datebox episDatebox' arrIndex="+ind+" style='width:114px;height:24px;' value="+SttDate+"/>"+"至今";
		}else{
			Datestr = "<input id='DateFrom_"+EpisID+"' class='hisui-datebox episDatebox' arrIndex="+ind+" style='width:114px;height:24px;' value="+SttDate+"/>"+"至"+"<input id='DateEnd_"+EpisID+"' class='hisui-datebox episDatebox' arrIndex="+ind+" style='width:114px;height:24px;' value="+EndDate+"/><span style='float:right'><a href='#' id='editDate' onclick='editEpisDate("+EpisID+")' style='margin:0;padding:0;' class='hisui-linkbutton' title='修改阶段日期' data-options='iconCls:\"icon-edit\",plain:true'></a></span>";
		}
		var Signstr="";
		SignDoc=SignDoc||"医生未签名";
		SignNur=SignNur||"护士未签名";
		Signstr="<span id='SignDoc-"+EpisID+"'>"+SignDoc+"</span> / <span id='SignNur-"+EpisID+"'>"+SignNur+"</span>";
		var Signimg="<a href='#' class='btnsign' id='btnsign'>签名</a><a href='#' class='btnsign' id='btncancel'>撤销</a>"
		
		var Episclass=(ind==len-1)?"epis lastepis":"epis"
		EpisHtml = "<div id=EpisID-"+EpisID+" class='"+Episclass+"'>"
		EpisHtml +=		"<div class='episDesc'>"+EpisDesc+"</div>"
		EpisHtml +=		"<div class='episDate'>"+Datestr+"</div>"
		EpisHtml +=		"<div class='episSign'>"+Signstr+Signimg+"</div>"
		EpisHtml +=		"<div class='episItems'></div>"
		EpisHtml +=	"</div>"
		
		innerHtml += EpisHtml
	}
	$('.container').html(innerHtml); 
	$.parser.parse('.container');
	
	$('.btnsign').on('click', function () {
		if((obj.CPWStatus == "出径")||(obj.CPWStatus == "完成")){
			$.messager.popover({
				msg: '已经'+obj.CPWStatus+',不允许操作！',
				type: 'error'
			});
		}else{
			var EpisID=$(this).parent().parent().attr('id').split("-")[1];
			var signtxt=$(this).text();
			
			if(signtxt == "签名"){
				obj.SignStep(UserType,EpisID);
			}else if(signtxt == "撤销"){
				obj.UnSignStep(UserType,EpisID);
			}else{
				$.messager.popover({
					msg: '签名设置错误',
					type: 'error'
				});
			}
		}
	});
	
	obj.BeforeEditDate=""
    $(".episDatebox").datebox({
		disabled:'disabled',
		onShowPanel:function(){
			obj.BeforeEditDate=$(this).datebox('getValue');
		},
		onHidePanel: function(n) {
			var id = $(this).attr("id");			 
			var curType=id.split("_")[0];
			var curEpisID=id.split("_")[1];
			var date=$(this).datebox('getValue');  
			var arrInd=parseInt($(this).attr("arrIndex"));		 
			var preDate="",preEpisID="",postDate="",postEpisId="";
			if (curType=="DateFrom"){
				//非第一阶段的检查前一阶段结束日期
				if(arrInd>0){									
					preDate = obj.arrEpisDate[arrInd-1].DateEnd;
					preEpisID = obj.arrEpisDate[arrInd-1].EpisID;
					if (Common_CompareDate(preDate,date)){
						$.messager.confirm("提示", "当前日期小于前一阶段结束日期！<br />是否继续修改？", function (r){
							if(r){
								$("#DateEnd_"+preEpisID).combobox('enable');
								$("#DateEnd_"+preEpisID).combobox('showPanel');
							}else{
								$('#'+id).datebox('setValue', obj.BeforeEditDate);
								$('#'+id).combobox('disable');
								if($("#DateEnd_"+curEpisID).length) $("#DateEnd_"+curEpisID).combobox('disable');
								return;
							}	
						})
					}
				}
				//存在本阶段结束日期的进行检查
				if ($("#DateEnd_"+curEpisID).length){			
					postDate=obj.arrEpisDate[arrInd].DateEnd;
					postEpisId=curEpisID;
					if (Common_CompareDate(date,postDate)){
						$.messager.confirm("提示", "当前日期大于本阶段结束日期！<br />是否继续修改？", function (r){
							if(r){
								$("#DateEnd_"+curEpisID).combobox('enable');
								$("#DateEnd_"+curEpisID).combobox('showPanel');
							}else{
								$('#'+id).datebox('setValue', obj.BeforeEditDate);
								$('#'+id).combobox('disable');
								if($("#DateEnd_"+curEpisID).length) $("#DateEnd_"+curEpisID).combobox('disable');
								return;	
							}
						})
					}	 
				}
			}else if(curType=="DateEnd"){
				//检查本阶段开始日期
				preDate = obj.arrEpisDate[arrInd].DateFrom;
				preEpisID = curEpisID;
				if (Common_CompareDate(preDate,date)){
					$.messager.confirm("提示", "当前日期小于本阶段开始日期！<br />是否继续修改？", function (r){
						if (arrInd==0){		//第一阶段不允许修改开始日期（默认入径日期）
							if(r){
								$('#'+id).datebox('setValue', obj.BeforeEditDate);
								$('#'+id).combobox('showPanel');
							}else{
								$('#'+id).datebox('setValue', obj.BeforeEditDate);
								$('#'+id).combobox('disable');
								$("#DateFrom_"+curEpisID).combobox('disable');
								return;
							}	
						}else{
							if(r){
								$("#DateFrom_"+preEpisID).combobox('enable');
								$("#DateFrom_"+preEpisID).combobox('showPanel');
							}else{
								$('#'+id).datebox('setValue', obj.BeforeEditDate);
								$('#'+id).combobox('disable');
								$("#DateFrom_"+curEpisID).combobox('disable');
								return;
							}
						}
					})
				}
				if (arrInd<obj.arrEpisDate.length-1){
					//检查下一阶段开始日期
					postDate = obj.arrEpisDate[arrInd+1].DateFrom;
					postEpisId=obj.arrEpisDate[arrInd+1].EpisID;
					if (Common_CompareDate(date,postDate)){
						 $.messager.confirm("提示", "当前日期大于下一阶段开始日期！<br />是否继续修改？", function (r){
								if(r){
									$("#DateFrom_"+postEpisId).combobox('enable');
									$("#DateFrom_"+postEpisId).combobox('showPanel');
								}else{
									$('#'+id).datebox('setValue', obj.BeforeEditDate);
									$('#'+id).combobox('disable');
									$("#DateFrom_"+curEpisID).combobox('disable');
									return;	
								}
						 })
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
		var xDateFrom=$("#DateFrom_"+xEpisID).datebox('getValue');
		var xDateEnd=$("#DateEnd_"+xEpisID).datebox('getValue');
			
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
		$.messager.popover({ msg: "日期修改成功！", type: 'success' });
		obj.InitCPWSteps();
	}else{
		$.messager.popover({ msg: "日期修改失败,请重试！", type: 'error' });
	}
}

obj.SignStep = function (Type,StepSelecedID) {
	/*var VarCount = $cm({ ClassName: "DHCMA.CPW.CPS.ImplementSrv", MethodName: "CheckVarToSign", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + StepSelecedID, aSignType: Type }, false);
	if (parseInt(VarCount) > 0) {
		$.messager.popover({ msg: "有变异信息未处理，不允许签名", type: 'error' });
		return;
	}*/
	
	var SignText = ""; 
	if (Type=="D"){ 
		SignText = $('#SignDoc-'+StepSelecedID).text();
		if ((SignText != "医生未签名")&&(SignText!="") ){
			$.messager.popover({ msg: "不能重复签名", type: 'error' });
			return;
		}
	}else if(Type=="N"){
		SignText = $('#SignNur-'+StepSelecedID).text();
		if ((SignText != "护士未签名")&&(SignText!="") ){
			$.messager.popover({ msg: "不能重复签名", type: 'error' });
			return;
		}
	}
	
	var strCheckItm = $m({
		ClassName: "DHCMA.CPW.CPS.ImplementSrv",
		MethodName: "CheckHaveUnExItm",
		aPathwayID: obj.PathwayID,
		aEpisID: obj.PathwayID + "||" + StepSelecedID,
		aUserType: Type
	}, false)
	if (strCheckItm == "1") {
		$.messager.confirm("提示", "存在未执行的非必选项目，确定不执行？", function (r) {
			if (r) {
				$.messager.confirm("签名", "确定签名?<br />签名信息：" + session['LOGON.USERNAME'], function (r) {
					if (r) {
						var Signret = $m({
							ClassName: "DHCMA.CPW.CP.PathwayEpis",
							MethodName: "Sign",
							aEpisID: obj.PathwayID + "||" + StepSelecedID,
							aUserID: session['DHCMA.USERID'],
							aUserType: Type
						}, false);
						if(parseInt(Signret) > 0){
							$.messager.popover({ msg: "签名成功！", type: 'success' });
							obj.InitCPWSteps();
						}else{
							$.messager.popover({ msg: "签名失败！err"+parseInt(Signret), type: 'error' });
						}
					} else {
						$.messager.popover({ msg: "签名取消" });
						return;
					}
				});
			} else {
				return;
			}
		});
	} else {
		var Signret = $m({
			ClassName: "DHCMA.CPW.CP.PathwayEpis",
			MethodName: "Sign",
			aEpisID: obj.PathwayID + "||" + StepSelecedID,
			aUserID: session['DHCMA.USERID'],
			aUserType: Type
		}, false);
		if(parseInt(Signret) > 0){
			$.messager.popover({ msg: "签名成功！", type: 'success' });
			obj.InitCPWSteps();
		}else{
			$.messager.popover({ msg: "签名失败！err"+parseInt(Signret), type: 'error' });
		}
	}
}
obj.UnSignStep = function (Type,StepSelecedID) {
	if(Type=="D"){
		var SignID="SignDoc";
	}else{
		var SignID="SignNur";
	}
	var SignTxt=$('#EpisID-'+StepSelecedID+' #'+SignID).text();
	
	if(SignTxt.indexOf("未签名") > 0){
		$.messager.popover({ msg: "未签名无需撤销！", type: 'error' });
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
		$.messager.popover({ msg: "撤销成功！", type: 'success' });
		obj.InitCPWSteps();
	}else{
		$.messager.popover({ msg: "撤销失败！err"+parseInt(Signret), type: 'error' });
	}
}
obj.checkItm = function(event,value,ItmIsImp){
	var ItmIDstr=event.target.id;
	if(ItmIDstr){
		var ItmID=ItmIDstr.split("-")[1];
		if(value){
			obj.ItmChecked.push(ItmID);
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
			if(obj.ItmChecked.indexOf(tmpVal)<0) obj.ItmChecked.push(tmpVal);
			$('#Itm-'+tmpVal).checkbox('setValue',true);
		}else{
			obj.ItmChecked.remove(tmpVal);
			$('#Itm-'+tmpVal).checkbox('setValue',false);
		}
	}
}
obj.MarkItm = function(markType,IsImpl){
	if(obj.ItmChecked.length < 1) {
		$.messager.popover({
			msg: '请先选择要操作的项目！',
			type: 'error'
		});
		return;
	}
	if(obj.ItmChecked.length == Math.abs(obj.ItmCheckedType)) {
		if(IsImpl){
			if(obj.ItmCheckedType>0){
				$.messager.popover({
				msg: '无效操作',
				type: 'info'
			});
			return;
			}
		}else{
			if(obj.ItmCheckedType<0){
				$.messager.popover({
					msg: '无效操作',
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
				msg: '操作成功',
				type: 'success'
			});
			obj.InitCPWSteps();
		} else {
			$.messager.popover({
				msg: '操作失败,ret=' + ret,
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