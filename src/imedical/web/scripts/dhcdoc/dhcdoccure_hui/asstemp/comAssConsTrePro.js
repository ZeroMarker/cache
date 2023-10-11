var comAssConsTrePro=(function(){
	function Init(id){
		$("#QueEmr").click(function(){OpenEmr(id)})
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	/// 引用
	function OpenEmr(flag){
		//var Link="doccure.patemrque.csp?&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
		var Link="dhcem.patemrque.csp?&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
		websys_showModal({
			url: Link,
			title: $g("引用"),
			width: 1280,
			height: 600,
			InsQuote:InsQuote
		})
	}

	function InsQuote(innertTexts,id){
		//治疗科室引用内容保存至id元素CBAss_ConsTrePro
		//其他保存引用 传入id值
		if((typeof(id)=="undefined")||(id=="undefined")||(id=="")){
			id="CBAss_ConsTrePro";
		}
		innertTexts=innertTexts.replace(/\t/g," ")
		var InsObj=$("#"+id);
		if(InsObj.length>0){
			var InsVal=InsObj.val();
			if (InsVal == ""){
				InsObj.val(innertTexts);  		/// 简要病历
			}else{
				InsObj.val(InsVal  +"\r\n"+ innertTexts);  		/// 简要病历
			}
		}
		/*if (flag == 1){
			if ($("#CBAss_ConsTrePro").val() == ""){
				$("#CBAss_ConsTrePro").val(innertTexts);  		/// 简要病历
			}else{
				$("#CBAss_ConsTrePro").val($("#CBAss_ConsTrePro").val()  +"\r\n"+ innertTexts);  		/// 简要病历
			}
		}else{
			if ($("#ConsOpinion").val() == ""){
				$("#ConsOpinion").val(innertTexts);  		/// 简要病历
			}else{
				$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ innertTexts);  		/// 简要病历
			}	
		}*/
		return;
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();