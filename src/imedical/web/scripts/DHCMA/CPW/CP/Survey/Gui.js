//页面Gui
function InitSurveyWin(){
	var obj = new Object();  
	obj.AdmLoc=""
	obj.PatStsSvy=""
	$.parser.parse(); 
	$m({
		ClassName: "DHCMA.CPW.BTS.SurveySrv",
		QueryName: "QryPatData",
		ResultSetType: 'array',
		aEpisodeID: EpisodeID,
		aCode: Code
	}, function (PatData) {
		if (PatData == "") {
			return;
		}
		var PatHtml = "",TitleHtml=""
		var PatArr = JSON.parse(PatData);
		for (var ind = 0, len = 1; ind < len; ind++) {
			var title=PatArr[ind].Title		//标题
			var PatName=PatArr[ind].PatName	//姓名
			var PatSex=PatArr[ind].PatSex	//性别
			var PatAge=PatArr[ind].PatAge	//年龄
			var PapmiNo=PatArr[ind].PapmiNo	//登记号
			var AdmWardDesc=PatArr[ind].AdmWardDesc	//病区
			obj.AdmLoc=PatArr[ind].AdmLoc	//就诊科室
			var AdmBed=PatArr[ind].AdmBed	//床位
			var AdmLocDesc=PatArr[ind].AdmLocDesc	//科室
			var AdmNo=PatArr[ind].AdmNo		//住院号
			var MrNo=PatArr[ind].MrNo		//病案号
			var AdmDate=PatArr[ind].AdmDate		//入院日期
			var DischDate=PatArr[ind].DischDate		//出院日期
			
			//var TitleHtml=TitleHtml+'<div id="title" class="report-header">'
			var TitleHtml=TitleHtml+'<span>'+title+'</span>'
			$('#title').append(TitleHtml);	//标题
			var PatHtml=PatHtml+'<span class="patName"></span>'+PatName
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('性别')+':</span>'+PatSex
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('年龄')+':</span>'+PatAge
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('入院日期')+':</span>'+AdmDate
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('出院日期')+':</span>'+DischDate
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('床位')+':</span>'+AdmBed
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('病案号')+':</span>'+MrNo
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('登记号')+':</span>'+PapmiNo
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('病区')+':</span>'+AdmWardDesc
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			var PatHtml=PatHtml+'<span class="infoLabel">'+$g('科室')+':</span>'+AdmLocDesc
			//var PatHtml=PatHtml+'<span class="sline">/</span>'
			//var PatHtml=PatHtml+'<span class="infoLabel">'+$g('住院号')+':</span>'+AdmNo
			$('#PatInfoTab').html(PatHtml);	//患者内容
		}
	});
	$m({
		ClassName: "DHCMA.CPW.BTS.SurveySrv",
		QueryName: "QrySurveyQ",
		ResultSetType: 'array',
		aCode: Code
	}, function (SurData) {
		if (SurData == "") {
			return;
		}
		$('#SurInfoTab').html('')
		var SurHtml = "",SurRHtml="",SurCHtml="",SurTHtml=""
		var SurArr = JSON.parse(SurData);
		arr = new Array();
		obj.IDArr=new Array();
		for (var ind = 0, len = SurArr.length; ind < len; ind++) {
			var RID="",CID="",TID=""
			var Title="Title-"+ind
			var SurHtml='<div id='+Title+'><b style="margin:5px 10px;font-size:16px;"><font color="red">*</font>'+SurArr[ind].BTDesc+'</b></div>'
			if (SurArr[ind].BTType=="Radio"){
				var RID="Radio-"+ind
				obj.IDArr.push(RID)
				var SurRHtml='<div id='+RID+' style="margin:0 15px"></div>'
			}else if(SurArr[ind].BTType=="Check"){
				var CID="Check-"+ind
				obj.IDArr.push(CID)
				var SurCHtml='<div id='+CID+' style="margin:0 15px"></div>'
			}else{
				var Surid=SurArr[ind].QuesId.split("||")[0]
				var Quesid=SurArr[ind].QuesId.split("||")[1]
				var TID=Surid+"-"+Quesid
				obj.IDArr.push(TID)
				var SurTHtml='<div><input class="textbox" id='+TID+' style="width:98%;margin:0 15px"/></div>'
			}
			$('#SurInfoTab').append(SurHtml);	//题目
			if (RID!=""){
				$('#'+Title).append(SurRHtml);	//题目内容
				Common_RadioToSur(RID,SurArr[ind].QuesId,5);
			}
			if (CID!=""){
				$('#'+Title).append(SurCHtml);	//题目内容
				Common_CheckboxToSur(CID,SurArr[ind].QuesId,5);
			}
			if (TID!=""){
				$('#'+Title).append(SurTHtml);	//题目内容
			}
		}
		$.parser.parse();
		var flag=$m({
			ClassName :"DHCMA.CPW.CP.PatStsSvy",
			MethodName:"GetPatSts",
			EpisodeID :EpisodeID,
			Code:Code
		},false)
		if (parseInt(flag)>0){
			var Score=$m({
				ClassName :"DHCMA.CPW.CP.PatStsSvy",
				MethodName:"GetScore",
				aId :flag
			},false)
			if (parseInt(Score)>0){
				$('#SCore').html('<div style="margin:20px 10px 0 10px"><b style="font-size:18px;">'+$g('总分')+':'+Score+'</b></div>')
			}
			$m({
				ClassName: "DHCMA.CPW.CPS.PatStsSvyDtlSrv",
				QueryName: "QryOptin",
				ResultSetType: 'array',
				aParRef: flag
			}, function (Data) {
				if (Data == "") {
					return;
				}
				obj.PatStsSvy=flag
				var DataArr = JSON.parse(Data);
				var Datalen=DataArr.length
				for(j = 0; j < obj.IDArr.length; j++) {			//遍历题目ID
					if ((obj.IDArr[j].indexOf("Radio")>-1)){
						for(i = 0; i < Datalen; i++) {
							if (DataArr[i].Type=="Radio"){
								Common_SetRadioValue(obj.IDArr[j],DataArr[i].Option)	
							}
						}	
					}else if(obj.IDArr[j].indexOf("Check")>-1){ 
						for(i = 0; i < Datalen; i++) {
							if (DataArr[i].Type=="Check"){
								var a=DataArr[i].Option.split(',').length
								for (var len=0; len < a;len++) { 
									var valueCode = DataArr[i].Option.split(',')[len];
									
									var valueCode=valueCode.replace("||","-")
									var valueCode=valueCode.replace("||","-")
									console.log(obj.IDArr[j]+valueCode)
									$('#'+obj.IDArr[j]+valueCode).checkbox('setValue',(valueCode!=""?true:false)); 
								}
							}
						}
					}else{
						for(i = 0; i < Datalen; i++) {
							if (DataArr[i].Type=="Text"){
								$("#"+obj.IDArr[j]).val(DataArr[i].AnswerTxt)
							}
						}
					}
				}
			})
		}
	});
	InitSurveyWinEvent(obj); 
	obj.LoadEvent();    
	return obj; 
}


