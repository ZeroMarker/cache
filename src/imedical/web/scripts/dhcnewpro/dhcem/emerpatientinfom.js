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
			$("#EmScreenFlag").val(EmPatCheckLevObj.EmScreenFlag=="Y"?"��":"��");
			
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
	if((param=="��")||(param=="1��")){
		css = {"color":"red","font-weight":"bold"};
	}
	if((param=="��")||(param=="2��")){
		css = {"color":"orange","font-weight":"bold"};
	}
	if((param=="��")||(param=="3��")){
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if((param=="��a��")||(param=="��b��")||(param=="4��")||(param=="5��")){
		css = {"color":"green","font-weight":"bold"};	
	}//ed
	return css;
}

function StyleCheckLevAreaColor(param){
	var css={};
	if(param=="����"){
		css = {"color":"red","font-weight":"bold"};
	}
	if(param=="����"){ //hxy 2020-02-21 st
		css = {"color":"orange","font-weight":"bold"};
	}//ed
	if(param=="����"){
		css = {"color":"#f9bf3b","font-weight":"bold"};
	}
	if(param=="����"){
		css = {"color":"green","font-weight":"bold"};	
	}

	return css;
}


//��ʽ������Y->�ǣ�N->��
function FormatterData(data){
	if(data.trim()=="Y"){
		return "��";	
	}else if(data.trim()=="N"){
		return "��"	
	}else{
		return ""	
	}	
}

//hxy 2020-02-21
function setCell(value){
	if(value=="1��"){value="��";}
	if(value=="2��"){value="��";}
	if(value=="3��"){value="��";}
	if(value=="4��"){value="��a��";}
	if(value=="5��"){value="��b��";}
	return value;
}