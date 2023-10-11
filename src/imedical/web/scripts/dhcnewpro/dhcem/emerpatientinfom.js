$(function (){
	if(!EpisodeID&&!PatientID){
		alert("����ID����Ϊ�պͲ���ID����ͬʱΪ�գ�");
		return;
	}

	//��ȡ������Ϣ
	runClassMethod("web.DHCEMECheck","GetAdmInfoByAdmAdnPatID",{
		EpisodeID:EpisodeID,
		PatientID:PatientID,
		EmPCLvID:EmPCLvID
		},function (data){
			if(data == null){
				return;
			}else{
				console.log(data);
				var DocCheckLevCss={};
				$("#PatCardNo").val(data.PatCardNo)  	//����
				$("#PatNo").val(data.PatNo);			//�ǼǺ�
				$("#PatName").val(data.PatName)  		//����
				$("#PatAge").val(data.PatAge);			//����
				$("#PatBoD").val(data.birthday)  		//��������
				$("#PatSex").val(data.PatSex);			//�Ա�
				$("#PatNation").val(data.PatNation)  	//����
				$("#PatCountry").val(data.PatCountry);	//����
				$("#PatIdNo").val(data.Ident+":"+data.IdentNo)  		//���֤��
				$("#PatTelH").val(data.PatTelH);		//��ͥ�绰
				$("#PatAddress").val(data.Address)      //��ͥסַ
				$("#EmDocCheckLev").val(setCell(data.DocCheckLev));  //ҽ���ּ� //hxy 2020-02-21			
				$("#EmDocCheckLevReason").val(data.DocCheckReason);  //ҽ���ּ�ԭ��
				DocCheckLevCss = StyleCheckLevColor(data.DocCheckLev);
				$("#EmDocCheckLev").css(DocCheckLevCss);
				
				if(EmPCLvID==="") EmPCLvID = data.EmPCLvID;
				if(!EmPCLvID) return;
				GetEmPatCheckLev(EmPCLvID);   //���طּ���Ϣ
			}
		})
})

function GetEmPatCheckLev(EmPCLvID){

			//��ȡ������Ϣ
	runClassMethod("web.DHCEMECheck","GetEmPatCheckLev",{"EmPCLvID":EmPCLvID},function(jsonString){
		if (jsonString != null){
			var EmPatCheckLevObj = jsonString;
			///	 ������
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			///  �Ƽ��ּ�
			$("#EmRecLevel").val(EmPatCheckLevObj.EmRecLevel);
			
			///  ��ʿ���ķּ�ԭ��
			$("#EmUpdLevRe").val(EmPatCheckLevObj.EmUpdLevRe);

			///  �������
			$("#EmLocDesc").val(EmPatCheckLevObj.EmLocID);  //2016-09-06 congyue

			///  ��ʶ״̬
			$("#EmAware").val(EmPatCheckLevObj.EmAware);

			///  ��ʿ�ּ�
			//$('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').attr("checked",'checked'); 
			$("#NurseLevel").val(EmPatCheckLevObj.NurseLevel);
			
			///  ȥ��
			$("#Area").val(EmPatCheckLevObj.Area) 
			
			//�ط���ʶ
			$("#EmAgainFlag").val(FormatterData(EmPatCheckLevObj.EmAgainFlag))
			
			//��������
			$("#EmBatchFlag").val(FormatterData(EmPatCheckLevObj.EmBatchFlag))
			
			//������Դ
			$("#EmPatSource").val(EmPatCheckLevObj.EmPatSource);
			
			///  ���﷽ʽ
			$("#EmPatAdmWay").val(EmPatCheckLevObj.EmPatAdmWay);
			
			///  �ж�
			$("#EmPoisonFlag").val(FormatterData(EmPatCheckLevObj.EmPoisonFlag));

			///  �Ƿ�����
			$("#EmOxygenFlag").val(FormatterData(EmPatCheckLevObj.EmOxygenFlag));
			
			///  ɸ��
			$("#EmScreenFlag").val(EmPatCheckLevObj.EmScreenFlag=="Y"?$g("��"):$g("��"));
			
			///  ������
			$("#EmCombFlag").val(FormatterData(EmPatCheckLevObj.EmCombFlag));

			///  ECG
			$("#EmECGFlag").val(FormatterData(EmPatCheckLevObj.EmECGFlag));
			
			///  ��ҩ���
			$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrug);

			///  ������
			$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterial);

			///  ��ʹ�ּ�
			$("#EmPainLev").val(EmPatCheckLevObj.EmPainLev);

			///  �ѿ�����
			//$('[name="EmPatAskFlag"][value="'+ EmPatCheckLevObj.EmPatAskFlag +'"]').attr("checked",true);
			
			//��������
			$("#EmPatChkSign").val(EmPatCheckLevObj.EmPatChkSign)
			
			///	 ��������			
			//$("#EmBatchFlag").val(EmPatCheckLevObj.EmBatchFlag);
															
			///	 ��ҩ���
			$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrugDesc);
			
			///	 ������
			$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterialDesc);
				
						
			///	 ����
			$("#EmOtherDesc").val(EmPatCheckLevObj.EmOtherDesc);

			///  ֢״
			$("#EmSymDesc").val(EmPatCheckLevObj.EmSymDesc)
			
			///	 ����ʷ
			$("#EmPatChkHis").val(EmPatCheckLevObj.EmPatChkHis)
			
			///  Ԥ��ű�
			$("#EmPatChkCare").val(EmPatCheckLevObj.EmPatChkCare)
			
			//����ʱ��	
			$("#EmRegDate").val(EmPatCheckLevObj.PCLDate+" "+EmPatCheckLevObj.PCLTime)  		
			///  ������Ⱥ 2016-09-05 congyue
			//$('[name="EmPatChkType"][value="'+ EmPatCheckLevObj.EmPatChkType +'"]').attr("checked",true);
			CheckLevColor(EmPatCheckLevObj);  //�ּ���ɫ
		}
	})
}

function CheckLevColor(data){
	var StyleCss={};
	StyleCss = StyleCheckLevColor(data.EmRecLevel);
	$("#EmRecLevel").css(StyleCss)
	StyleCss = StyleCheckLevColor(data.NurseLevel);
	$("#NurseLevel").css(StyleCss)
	StyleCss = StyleCheckLevAreaColor(data.Area);
	$("#Area").css(StyleCss);
	
}

function StyleCheckLevColor(param){
	var css={};
	/*if(param=="1��"){ //hxy 2020-02-21 st
		css = {"color":"red","font-weight":"bold"};
	}
	if(param=="2��"){
		css = {"color":"red","font-weight":"bold"};
	}
	if(param=="3��"){
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if(param=="4��"){
		css = {"color":"green","font-weight":"bold"};	
	}*/
	if((param==$g("��"))||(param==$g("1��"))){
		css = {"color":"red","font-weight":"bold"};
	}
	if((param==$g("��"))||(param==$g("2��"))){
		css = {"color":"orange","font-weight":"bold"};
	}
	if((param==$g("��"))||(param==$g("3��"))){
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if((param==$g("��a��"))||(param==$g("��b��"))||(param==$g("4��"))||(param==$g("5��"))){
		css = {"color":"green","font-weight":"bold"};	
	}//ed
	return css;
}

function StyleCheckLevAreaColor(param){
	var css={};
	if(param==$g("����")){
		css = {"color":"red","font-weight":"bold"};
	}
	if(param==$g("����")){ //hxy 2020-02-21 st
		css = {"color":"orange","font-weight":"bold"};
	}//ed
	if(param==$g("����")){
		css = {"color":"#f9bf3b","font-weight":"bold"};
	}
	if(param==$g("����")){
		css = {"color":"green","font-weight":"bold"};	
	}

	return css;
}


//��ʽ������Y->�ǣ�N->��
function FormatterData(data){
	if(data.trim()=="Y"){
		return $g("��");	
	}else if(data.trim()=="N"){
		return $g("��");	
	}else{
		return ""	
	}	
}

//hxy 2020-02-21
function setCell(value){
	if(value==$g("1��")){value=$g("��");}
	if(value==$g("2��")){value=$g("��");}
	if(value==$g("3��")){value=$g("��");}
	if(value==$g("4��")){value=$g("��a��");}
	if(value==$g("5��")){value=$g("��b��");}
	return value;
}
