function InitBase(obj){

    // 初始化就诊信息
    obj.AdmInfo = $cm({
		ClassName:"DHCHAI.DPS.PAAdmSrv",
		QueryName:"QryAdmInfo",		
		aEpisodeID: EpisodeID
	},false);
	if (obj.AdmInfo.total>0) {
		var AdmInfo = obj.AdmInfo.rows[0];
		if (AdmInfo.Sex == '女') {
			$('#Sex').removeClass('man').addClass('woman');		
		} else {
			$('#Sex').removeClass('woman').addClass('man');
		}
		$('#txtPatName').text(AdmInfo.PatName);
		$('#Age').text(AdmInfo.Age);	
		$('#txtPapmiNo').text(AdmInfo.PapmiNo);
		$('#txtMrNo').text(AdmInfo.MrNo);
		$('#txtAdmDate').text(AdmInfo.AdmDate);
		$('#txtDisDate').text(AdmInfo.DischDate);
		if (AdmInfo.IsDeath=='1'){
			$('#txtPatName').css('color','red');	// 死亡病人
		}
		var Weight=AdmInfo.AdmitWeight.replace("g", "");  //新生儿入院体重
		if ((Weight>0)&&(Weight<=1000)) {
			$('#txtWeight').text("BW <=1000g");
		}else if ((Weight>1000)&&(Weight<=1500)) {
			$('#txtWeight').text("BW 1001g~1500g");
		}else if ((Weight>1500)&(Weight<=2500)) {
			$('#txtWeight').text("BW 1501g~2500g");
		}else if (Weight>2500){
			$('#txtWeight').text("BW >2500g");
		}else {
			$('#txtWeight').text("");
		}
		$('#txtAdmitDiag').val(AdmInfo.AdmitDiag);
		$('#txtMainDiag').val(AdmInfo.MainDiag);
		$('#txtOtherDiag').val(AdmInfo.OtherDiag);
	}
	
	$('#txtAdmitDiag').hover(function(){
		var AdmitDiag = $('#txtAdmitDiag').val();
		if (AdmitDiag!='') {
			$("#txtAdmitDiag").popover({
				content:AdmitDiag,
				trigger:'hover',
				placement:'bottom-right'
			});
			$("#txtAdmitDiag").popover('show'); 
		}			
	});
	$('#txtMainDiag').hover(function(){
		var MainDiag = $('#txtMainDiag').val();
		if (MainDiag!='') {
			$("#txtMainDiag").popover({
				content:MainDiag,
				trigger:'hover',
				placement:'bottom-right'
			});
			$("#txtMainDiag").popover('show'); 
		}			
	});
	
	$('#txtOtherDiag').hover(function(){
		var OtherDiag = $('#txtOtherDiag').val();
		if (OtherDiag!='') {
			$("#txtOtherDiag").popover({
				content:OtherDiag,
				trigger:'hover',
				placement:'bottom-right'
			});
			$("#txtOtherDiag").popover('show'); 
		}			
	});
	
	obj.TransInfo = $cm({
		ClassName:"DHCHAI.DPS.PAAdmTransSrv",
		QueryName:"QryTransLocInfo",		
		aEpisodeID: EpisodeID
	},false);
   
    var TransHtml="";
    for (var ind=0; ind<obj.TransInfo.total;ind++) {
	    var LocDesc = obj.TransInfo.rows[ind].LocDesc;
	    var TransDate = obj.TransInfo.rows[ind].TransDate;
	    TransHtml += '<span style="margin-right:10px;padding:5px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;">'+LocDesc+" "+TransDate+'</span>' 
	    if ((ind+1)==obj.TransInfo.total) continue;
	    TransHtml +='<span class="icon-arrow-blue" style="margin-right:8px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>'  
    }
	$('#TransInfo').append(TransHtml);
	
}