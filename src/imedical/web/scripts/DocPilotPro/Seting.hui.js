$(function(){
	//ҳ��Ԫ�س�ʼ�� ��������ͬ��������ᵼ��ҳ�����ݳ�ʼ��ʱ����
	PageHandle();
	//ҳ�����ݳ�ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
});
function Init(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPPGroupSeting",
		MethodName:"GetInitInfo",
		dataType:"text"
	},function(rtnStr){
		var PilotExpression=rtnStr.split("^")[0];
		var SuperDepRowId=rtnStr.split("^")[1];
		var ProRegList=rtnStr.split("^")[2];
		var SubConfigStr=rtnStr.split("^")[3];
		var ProCodeLenght=rtnStr.split("^")[4];
		var EntryOrdBillPad=rtnStr.split("^")[5];
		var PilotPatAdmReason=rtnStr.split("^")[6];
		var PatAddNeedProRem=rtnStr.split("^")[7];
		var IPPilotPatAdmReason=rtnStr.split("^")[8];
		var AutoProCode=rtnStr.split("^")[9];
		if (AutoProCode==1){AutoProCode=true;}else{AutoProCode=false;}
		var ProCodeStart=rtnStr.split("^")[10];
		var ArchivesFilesNoStart=rtnStr.split("^")[11];
		var OPOrdAutoBilled=rtnStr.split("^")[12];
		var o=$HUI.checkbox("#PatAddNeedProRem");
		if (PatAddNeedProRem==1){
			o.setValue(true);
		}else{
			o.setValue(false);
		}
		if (OPOrdAutoBilled=="Y") {
			$("#OPOrdAutoBilled").checkbox('check');
		}else{
			$("#OPOrdAutoBilled").checkbox('uncheck');
		}
		$("#PilotExpression").val(PilotExpression);
		var cbox=$HUI.combobox("#SuperLoc");
			cbox.select(SuperDepRowId);
		var cbox=$HUI.combobox("#ProRegList");
			cbox.select(ProRegList);
		$("#ProCodeLenght").val(ProCodeLenght);
		var cbox=$HUI.combobox("#PilotPatAdmReason");
			cbox.select(PilotPatAdmReason);
		var cbox=$HUI.combobox("#IPPilotPatAdmReason");
			cbox.select(IPPilotPatAdmReason);		
		var o=$HUI.checkbox("#AutoProCode");
			o.setValue(AutoProCode);
		AutoProCodeClick(AutoProCode);
		$("#ProCodeStart").val(ProCodeStart);
		$("#ArchivesFilesNoStart").val(ArchivesFilesNoStart);
		var SubObj=document.getElementById('PilotProSubCatList')
		if (SubObj){
			for(var i=0;i<SubObj.length;i++){
				if(("!"+SubConfigStr+"!").indexOf("!"+SubObj.options[i].value+"!")!=-1){
					SubObj.options[i].selected=true;
				}
			}
		}
	});
	$("#PilotProSubCatList").css('height',$(window).height()-340)
}
function InitEvent(){
	$("#BSave").click(SaveClickHandle);
	$HUI.checkbox("#AutoProCode",{
        onCheckChange:function(e,value){
            AutoProCodeClick(value);
        }
    });
}
function AutoProCodeClick(value){
	if (value) {
		$('#ProCodeStart').attr("disabled",false);
	}else{
		$('#ProCodeStart').attr("disabled",true);
		$("#ProCodeStart").val("");
	}
}
function SaveClickHandle(){
	if (!CheckDataValid()) return false;
	var PilotExpression=$('#PilotExpression').val();
	var SuperDepRowId=$('#SuperLoc').combobox("getValue");
	var ProRegList=$('#ProRegList').combobox("getValue");
	var SubConfigStr="";
	var SubObj=document.getElementById('PilotProSubCatList')
	if (SubObj){
		for(var i=0;i<SubObj.length;i++){
			if(SubObj.options[i].selected==true){
				if(SubConfigStr=="") SubConfigStr=SubObj.options[i].value;
				else SubConfigStr=SubConfigStr+"!"+SubObj.options[i].value;
			}
		}
	}
	var ProCodeLenght=$("#ProCodeLenght").val();
	//��ҽ��ֱ�ӼƷ�Ĭ�ϲ���ѡ
	var EntryOrdBillPad=0 //DHCC_GetElementData('EntryOrdBillPad'); 
	var PilotPatAdmReason=$("#PilotPatAdmReason").combobox("getValue");
	var IPPilotPatAdmReason=$("#IPPilotPatAdmReason").combobox("getValue"); 
	var o=$HUI.checkbox("#PatAddNeedProRem");
	if (o.getValue()){
		var PatAddNeedProRem=1;
	}else{
		var PatAddNeedProRem=0;
	}
	var o=$HUI.checkbox('#AutoProCode');
	if (o.getValue()){var AutoProCode=1;}else{var AutoProCode=0;}
	var ProCodeStart=$('#ProCodeStart').val();
	var ArchivesFilesNoStart=$('#ArchivesFilesNoStart').val();
	var OPOrdAutoBilled=$('#OPOrdAutoBilled').checkbox('getValue')?"Y":"N";
	var myStr=PilotExpression+"^"+SuperDepRowId+"^"+ProRegList+"^"+SubConfigStr+"^"+ProCodeLenght+"^"+EntryOrdBillPad+"^"+PilotPatAdmReason;
	var myStr=myStr+"^"+PatAddNeedProRem+"^"+IPPilotPatAdmReason+"^"+AutoProCode+"^"+ProCodeStart+"^"+ArchivesFilesNoStart+"^"+OPOrdAutoBilled;
	$.cm({
		ClassName:"web.PilotProject.DHCDocPPGroupSeting",
		MethodName:"Save1Method",
		dataType:"text",
		ParaStr:myStr,
		myExpStr:""
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","����ɹ�");
		}else{
			$.messager.alert("��ʾ","����ʧ��");
		}
	});
}
function CheckComboxSelData(id,selId){
	 var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="SuperLoc"){
			var CombValue=Data[i].RowId;
		 	var CombDesc=Data[i].Desc;
	     }else{
		    var CombValue=Data[i].id
		 	var CombDesc=Data[i].text
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function CheckDataValid(){
	var r = /^[0-9]*[1-9][0-9]*$/����//������ 
	var ProCodeStart=$('#ProCodeStart').val();
	if (ProCodeStart!="" && !r.test(ProCodeStart)) {
		$.messager.alert("��ʾ","��Ŀ�����ʼ������д���ڵ���1��������","info",function(){
			$("#ProCodeStart").focus();
		});
		return false;
	}
	var ArchivesFilesNoStart=$('#ArchivesFilesNoStart').val();
	if (ArchivesFilesNoStart!="" && !r.test(ArchivesFilesNoStart)) {
		$.messager.alert("��ʾ","�����ļ��б����ʼ������д���ڵ���1��������","info",function(){
			$("#ArchivesFilesNoStart").focus();
		});
		return false;
	}
	var AutoProCode=$('#AutoProCode').checkbox('getValue');
	if ((AutoProCode) && (ProCodeStart=="")) {
		$.messager.alert("��ʾ","������Զ�������Ŀ���,��Ŀ�����ʼ�Ų���Ϊ��","info",function(){
			$("#ProCodeStart").focus();
		});
		return false;
	}
	var SuperDepRowId=$('#SuperLoc').combobox("getValue");
	if (SuperDepRowId!=""){
		SuperDepRowId=CheckComboxSelData("SuperLoc",SuperDepRowId);
		if (SuperDepRowId==""){
			$.messager.alert("��ʾ","������������ѡ�񳬼�����!","info",function(){
				$('#SuperLoc').next('span').find('input').focus();
			});
			return false;
		}
	}
	var ProRegList=$('#ProRegList').combobox("getValue");
	if (ProRegList!=""){
		ProRegList=CheckComboxSelData("ProRegList",ProRegList);
		if (ProRegList==""){
			$.messager.alert("��ʾ","������������ѡ��ҺŴ���!","info",function(){
				$('#ProRegList').next('span').find('input').focus();
			});
			return false;
		}
	}
	var PilotPatAdmReason=$("#PilotPatAdmReason").combobox("getValue");
	if (PilotPatAdmReason!=""){
		PilotPatAdmReason=CheckComboxSelData("PilotPatAdmReason",PilotPatAdmReason);
		if (PilotPatAdmReason==""){
			$.messager.alert("��ʾ","������������ѡ��ҩ����Ŀ���˷ѱ�!","info",function(){
				$('#PilotPatAdmReason').next('span').find('input').focus();
			});
			return false;
		}
	}
	var IPPilotPatAdmReason=$("#IPPilotPatAdmReason").combobox("getValue");
	if (IPPilotPatAdmReason!=""){
		IPPilotPatAdmReason=CheckComboxSelData("IPPilotPatAdmReason",IPPilotPatAdmReason);
		if (IPPilotPatAdmReason==""){
			$.messager.alert("��ʾ","������������ѡ��סԺҩ����Ŀ���˷ѱ�!","info",function(){
				$('#IPPilotPatAdmReason').next('span').find('input').focus();
			});
			return false;
		}
	}
	return true;
}
function PageHandle(){
	//��������
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindLoc",
		dataType:"json",
		Loc:"",
		rows:99999
	},false);
	//Desc:%String,Code:%String,RowId:%String,Alias
	var cbox = $HUI.combobox("#SuperLoc", {
			valueField: 'RowId',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onChange:function(newValue,oldValue){
				if (newValue=="") $(this).setValue("");
			}
	 });
	//�ҺŴ���
	var cbox = $HUI.combobox("#ProRegList", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: [
		  {"id":"1","text":"һ��"}
		 ,{"id":"2","text":"ÿ��"}
		] 
   });
   //�ѱ�
   var Data=$.m({
		ClassName:"web.PilotProject.DHCDocPPGroupSeting",
		MethodName:"ReadAdmReasonListBroker",
		JSFunName:"GetAdmReasonToHUIJson",
		ListName:""
	},false);
	var cbox = $HUI.combobox("#PilotPatAdmReason,#IPPilotPatAdmReason", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			data: JSON.parse(Data),
			onChange:function(newValue,oldValue){
				if (newValue=="") $(this).setValue("");
			}
	 });
	 //����
	 var SubCat=$.cm({
		ClassName:"web.PilotProject.DHCDocPPGroupSeting",
		MethodName:"FindSubCat",
		dataType:"text"
	},false);
	var obj=document.getElementById("PilotProSubCatList");
	for (var i=0;i<SubCat.split(String.fromCharCode(2)).length;i++){
	 	var tempStr=SubCat.split(String.fromCharCode(2))[i];
	 	var SubRowId=tempStr.split(String.fromCharCode(1))[0];
	 	var SubDesc=tempStr.split(String.fromCharCode(1))[1];
	 	obj.options[i]=new Option(SubDesc,SubRowId);
	 }
}