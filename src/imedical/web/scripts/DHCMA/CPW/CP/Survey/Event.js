//页面Event
function InitSurveyWinEvent(obj){
	
    obj.LoadEvent = function(args){
	    $('#btnClose').on("click", function(){
			obj.btnClose_click(); 
		});
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		$('#btnPrint').on("click", function(){
			obj.btnPrint_click(); 
		})
	}
	obj.btnPrint_click = function() {	// 打印
		// 1.直接打印
		var fileName="{DHCMA.CPW.STA.Survey.raq(aParRef="+obj.PatStsSvy+";aEpisodeID="+EpisodeID+")}";
		//DHCCPM_RQDirectPrint(fileName);
		DHCCPM_RQDirectPrintPDF(fileName);
		
		// 2.弹出打印
		//var fileName="DHCMA.CPW.STA.Survey.raq&aParRef="+obj.PatStsSvy+"&aEpisodeID="+EpisodeID;
		//DHCCPM_RQPrint(fileName); 
	}
	obj.btnClose_click = function(){
		websys_showModal('close');
	};
	obj.btnSave_click = function(){
		var count=0,score=0;
		var inputStr = obj.PatStsSvy;
		for(j = 0; j < obj.IDArr.length; j++) {
			if (obj.IDArr[j].indexOf("Radio")>-1){
				if (!Common_RadioValue(obj.IDArr[j])){
					var count=count+1
				}
				var Rscore=$m({
					ClassName :"DHCMA.CPW.BT.SurveyOption",
					MethodName:"GetScoreByID",
					aID :Common_RadioValue(obj.IDArr[j])
				},false)
				var score=score+parseInt(Rscore)
			}else if(obj.IDArr[j].indexOf("Check")>-1){
				if (!Common_CheckboxValue(obj.IDArr[j])){
					var count=count+1
				}
				var Cscore=$m({
					ClassName :"DHCMA.CPW.BT.SurveyOption",
					MethodName:"GetScoreByID",
					aID :Common_CheckboxValue(obj.IDArr[j])
				},false)
				var score=score+parseInt(Cscore)
			}else{
				if ($("#"+obj.IDArr[j]).val()==""){
					var count=count+1
				}
				var Tscore=$m({
					ClassName :"DHCMA.CPW.BT.SurveyQuestion",
					MethodName:"GetScoreByID",
					aID :obj.IDArr[j]
				},false)
				var score=score+parseInt(Tscore)
			}
		}
		if (count!=0) {
			$.messager.alert($g("错误提示"), $g("共有")+count+$g("项未填写!"), 'info');
			return;
		} 
		inputStr = inputStr + "^" + EpisodeID; 	//就诊ID
		inputStr = inputStr + "^" + obj.AdmLoc; 	//就诊科室
		inputStr = inputStr + "^" + score; 		//调查总得分
		inputStr = inputStr + "^" + Code; 		//调查表指针
		inputStr = inputStr + "^" + session['LOGON.CTLOCID']+"!!1"; 	//更新科室
		inputStr = inputStr + "^" + session['LOGON.USERID']+"!!1";	//更新用户
		var TRet=$m({
			ClassName :"DHCMA.CPW.CP.PatStsSvy",
			MethodName:"Update",
			aInputStr :inputStr,
			aSeparete:"^"
		},false)
		if (parseInt(TRet) <= 0) {
			$.messager.alert($g("错误提示"), $g("更新数据错误!")+"Error=" + TRet , 'info');
			return 
		}else {
			obj.PatStsSvy = TRet;
			obj.SaveOption()
		}
	};
	//保存选项
	obj.SaveOption = function(){
		var errinfo = "";
		for(j = 0; j < obj.IDArr.length; j++) {
			if (obj.IDArr[j].indexOf("Radio")>-1){
				var Rscore=$m({
					ClassName :"DHCMA.CPW.BT.SurveyOption",
					MethodName:"GetScoreByID",
					aID :Common_RadioValue(obj.IDArr[j])
				},false)
				if (Common_RadioValue(obj.IDArr[j])!=""){
					var RinputStr=obj.PatStsSvy+"^"+""+"^"+Common_RadioValue(obj.IDArr[j])+"^"+Rscore+"^"+Common_RadioValue(obj.IDArr[j])+"^"+""
					var flag=$m({
						ClassName :"DHCMA.CPW.CP.PatStsSvyDtl",
						MethodName:"Update",
						aInputStr :RinputStr,
						aSeparete:"^"
					},false)
					if (parseInt(flag) <= 0) {
						errinfo = errinfo + $g("第")+j+$g("项单选数据保存错误!")+"Error=" + flag+"<br>";
					}
				}
			}else if(obj.IDArr[j].indexOf("Check")>-1){
				var Cscore=$m({
					ClassName :"DHCMA.CPW.BT.SurveyOption",
					MethodName:"GetScoreByID",
					aID :Common_CheckboxValue(obj.IDArr[j])
				},false)
				if (Common_CheckboxValue(obj.IDArr[j])!=""){
					var CinputStr=obj.PatStsSvy+"^"+""+"^"+Common_CheckboxValue(obj.IDArr[j])+"^"+Cscore+"^"+Common_CheckboxValue(obj.IDArr[j])+"^"+""
					var flag=$m({
						ClassName :"DHCMA.CPW.CP.PatStsSvyDtl",
						MethodName:"Update",
						aInputStr :CinputStr,
						aSeparete:"^"
					},false)
					if (parseInt(flag) <= 0) {
						errinfo = errinfo + $g("第")+j+$g("项多选数据保存错误!")+"Error=" + flag+"<br>";
					}
				}	
			}else{
				var Tscore=$m({
					ClassName :"DHCMA.CPW.BT.SurveyQuestion",
					MethodName:"GetScoreByID",
					aID :obj.IDArr[j]
				},false)
				var TinputStr=obj.PatStsSvy+"^"+""+"^"+obj.IDArr[j]+"^"+Tscore+"^"+""+"^"+$("#"+obj.IDArr[j]).val()
				var flag=$m({
					ClassName :"DHCMA.CPW.CP.PatStsSvyDtl",
					MethodName:"Update",
					aInputStr :TinputStr,
					aSeparete:"^"
				},false)
				if (parseInt(flag) <= 0) {
					errinfo = errinfo + $g("第")+j+$g("项文本数据保存错误!")+"Error=" + flag+"<br>";
				}
			}
		}
		if (errinfo) {
			$.messager.alert($g("错误提示"), errinfo, 'info');
			return;
		}else{
			$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});
			location.reload(true);
			//websys_showModal('close');
		}
	}
}