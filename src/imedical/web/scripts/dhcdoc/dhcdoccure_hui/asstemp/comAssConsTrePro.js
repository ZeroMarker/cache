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
	
	/// ����
	function OpenEmr(flag){
		//var Link="doccure.patemrque.csp?&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
		var Link="dhcem.patemrque.csp?&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
		websys_showModal({
			url: Link,
			title: $g("����"),
			width: 1280,
			height: 600,
			InsQuote:InsQuote
		})
	}

	function InsQuote(innertTexts,id){
		//���ƿ����������ݱ�����idԪ��CBAss_ConsTrePro
		//������������ ����idֵ
		if((typeof(id)=="undefined")||(id=="undefined")||(id=="")){
			id="CBAss_ConsTrePro";
		}
		innertTexts=innertTexts.replace(/\t/g," ")
		var InsObj=$("#"+id);
		if(InsObj.length>0){
			var InsVal=InsObj.val();
			if (InsVal == ""){
				InsObj.val(innertTexts);  		/// ��Ҫ����
			}else{
				InsObj.val(InsVal  +"\r\n"+ innertTexts);  		/// ��Ҫ����
			}
		}
		/*if (flag == 1){
			if ($("#CBAss_ConsTrePro").val() == ""){
				$("#CBAss_ConsTrePro").val(innertTexts);  		/// ��Ҫ����
			}else{
				$("#CBAss_ConsTrePro").val($("#CBAss_ConsTrePro").val()  +"\r\n"+ innertTexts);  		/// ��Ҫ����
			}
		}else{
			if ($("#ConsOpinion").val() == ""){
				$("#ConsOpinion").val(innertTexts);  		/// ��Ҫ����
			}else{
				$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ innertTexts);  		/// ��Ҫ����
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