/// Description: ��ҩ���󱨸浥
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	if ((recordId=="")){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
	        var adm = frm.EpisodeID.value;
		    EpisodeID=adm;
	        InitPatInfo(adm);//��ȡ������Ϣ
		}
	}
	$('#OccuLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //���������������
		onShowPanel:function(){ 
			$('#OccuLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	
	/*//����1
	$('#DeptLocOne').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocCombox',
		mode:'remote',  //���������������
		onSelect: function(rec){  
           var LocOneDr=rec.value; 
			ComboboxLocTwo(LocOneDr);        
	  }
	});*/
	$("#SaveBut").on("click",function(){
		SaveDrugErrReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveDrugErrReport(1);
	})
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//��Ժʱ�����
	$('#PatAdmDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//�������ڿ���
	$('#ReportDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//��ҩ�������ڿ���
	$('#GiveDrugHappenTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	PatMedNoEnter();//�����Żس��¼�
	PatIDEnter();//�ǼǺŻس��¼�
	InitDrugErrReport(recordId);//����ҳ����Ϣ
	
});
//���ر�����Ϣ
function InitDrugErrReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //��������
		$('#RepHospType').val(LgHospDesc); //���浥λ
		$('#RepHospType').attr("readonly","readonly"); //���浥λ
		$('#RepUserName').val(LgUserName); //�������Ϊ��¼��
		$('#RepUserName').attr("readonly","readonly");//�������Ϊ��¼��
		if(LgGroupDesc=="����"){
			$('#ReportDate').datebox({disabled:false});//��������
		}else{
			$('#ReportDate').datebox({disabled:'true'});//��������
		}
		$('#ReportDate').datebox("setValue",RepDate);   //��������

		//$('#HospPhone').val("64456715");//��ϵ�绰
		//$('#HospPhone').attr("readonly","readonly"); //��ϵ�绰
		//������Ϣ	 
		$('#DisMedThingPatName').attr("readonly","readonly");//��������	
	}else{
		//������Ϣ	 
		$('#DisMedThingPatName').attr("readonly","readonly");//��������
		$('#PatSexinput').attr("readonly","readonly"); //�Ա�
		$('#PatAge').attr("readonly","readonly"); //����
		//$('#PatMedicalNo').attr("readonly","readonly"); //������
		$('#PatAdmDate').datebox({disabled:'true'});//��Ժ����     
		$('#PatDiag').attr("readonly","readonly");//���
		var date=$('#ReportDate').datebox("getValue");//��������
		if(LgGroupDesc=="����"){
			$('#ReportDate').datebox({disabled:false});//��������
			$('#ReportDate').datebox("setValue",date);   //��������
		}else{
			$('#ReportDate').datebox({disabled:'true'});//��������
			$('#ReportDate').datebox("setValue",date);   //��������
		}
		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //�����չ�����
    	$('#RepHospType').attr("readonly","readonly"); //���浥λ
    	$('#RepUserName').attr("readonly","readonly");//�������Ϊ��¼��
    	//$('#HospPhone').attr("readonly","readonly"); //��ϵ�绰
    	$("#from").form('validate');			
	} 
}
//���汣��
function SaveDrugErrReport(flag)
{
	if($('#DisMedThingPatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReport(flag);
}
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+""+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
			//������Ϣ
			$('#PatID').val(tmp[0]); //�ǼǺ�
			$('#DisMedThingPatName').val(tmp[1]); //��������
			$('#DisMedThingPatName').attr("readonly","readonly");
			$('#PatSexinput').val(tmp[3]);  //�Ա�
			$('#PatSexinput').attr("readonly","readonly");
			$('#PatAge').val(tmp[4]);  //����
			$('#PatAge').attr("readonly","readonly");
			$('#PatMedicalNo').val(tmp[5]); //������
			$('#PatMedicalNo').attr("readonly","readonly");
			if(tmp[24]!=""){
	      		$('#PatAdmDate').datebox({disabled:'true'});	
	      	}
			$('#PatAdmDate').datebox("setValue",tmp[24]);  //��Ժ����
      		$('#PatDiag').val(tmp[10]);  //���
      		if(tmp[10]!=""){
	      		$('#PatDiag').attr("readonly","readonly");	
	      	}
	      	$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //�����չ�����
	      	if((tmp[22]=="סԺ")||(tmp[22]=="����")||(tmp[22]=="����")||(tmp[22]=="�ռ䲡��")||(tmp[22]=="����")){
		      	$("input[type=radio][value='"+tmp[22]+"']").click(); //������Դ
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //�����չ�����
	      	}else{
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //�����չ�����
		    }
	      	$("input[type=radio][value='"+tmp[23]+"']").click(); //������
      		$("#from").form('validate');
		}
	})
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	//������Դ
	var PatOriginoth=0;
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94109']").val()=="")){
				PatOriginoth=-1;
			}
		}
	})
	if(PatOriginoth==-1){
		$.messager.alert("��ʾ:","��������Դ����ѡ'����'������д���ݣ�");	
		return false;
	}
	//�����ص�
	var HappenPlaceoth=0;
	$("input[type=radio][id^='DrugUseHappenPlace-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94125']").val()=="")){
				HappenPlaceoth=-1;
			}
		}
	})
	if(HappenPlaceoth==-1){
		$.messager.alert("��ʾ:","�������ص㡿��ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//���
	var Rankoth=0;
	$("input[type=radio][id^='DrugUseErrRank']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94136']").val()=="")){
				Rankoth=-1;
			}
		}
	})
	if(Rankoth==-1){
		$.messager.alert("��ʾ:","����ݡ���ѡ'����'������д���ݣ�");	
		return false;
	}

	//�������� ��ҩʱ�����
	var dosetimeerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94617']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94617-94204").val()=="")||($("#DrugUseErrType-94617-94205").val()=="")){
				dosetimeerr=-1;
			}
		}
	})
	if(dosetimeerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��ҩʱ�����'������д���ݣ�");	
		return false;
	}
	//�������� ��ҩ;������
	var dosewayerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94618']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94618-94208").val()=="")||($("#DrugUseErrType-94618-94209").val()=="")){
				dosewayerr=-1;
			}
		}
	})
	if(dosewayerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��ҩ;������'������д���ݣ�");	
		return false;
	}
	//�������� ��©��ҩ
	var missdose=0;
	$("input[type=checkbox][id^='DrugUseErrType-94619']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94619-94212").val()=="")||($("#DrugUseErrType-94619-94213").val()=="")){
				missdose=-1;
			}
		}
	})
	if(missdose==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��©��ҩ'������д���ݣ�");	
		return false;
	}
	//�������� ��Һ�ٶȴ���
	var infusionspeed=0;
	$("input[type=checkbox][id^='DrugUseErrType-94620']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94620-94215").val()=="")||($("#DrugUseErrType-94620-94216").val()=="")){
				infusionspeed=-1;
			}
		}
	})
	if(infusionspeed==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��Һ�ٶȴ���'������д���ݣ�");	
		return false;
	}
	//�������� ��������
	var dosageerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94621']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94621-94219").val()=="")||($("#DrugUseErrType-94621-94220").val()=="")){
				dosageerr=-1;
			}
		}
	})
	if(dosageerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��������'������д���ݣ�");	
		return false;
	}
	//�������� ���ʹ���
	var dosageformerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94622']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94622-94223").val()=="")||($("#DrugUseErrType-94622-94224").val()=="")){
				dosageformerr=-1;
			}
		}
	})
	if(dosageformerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'���ʹ���'������д���ݣ�");	
		return false;
	}
	//�������� ҩ�����
	var drugerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94623']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94623-94227").val()=="")||($("#DrugUseErrType-94623-94228").val()=="")){
				drugerr=-1;
			}
		}
	})
	if(drugerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'ҩ�����'������д���ݣ�");	
		return false;
	}
	//�������� ����
	var otherr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94625']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94152'][class='lable-input']").val()=="")){
				otherr=-1; 
			}
		}
	})
	if(otherr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'����'������д���ݣ�");	
		return false;
	}

	//ȱ������ĺ��
	var DefectResultoth=0;
	$("input[type=radio][id^='DrugUseDefectResult-label']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94158'][class='lable-input']").val()=="")){
				DefectResultoth=-1; 
			}
		}
	})
	if(DefectResultoth==-1){
		$.messager.alert("��ʾ:","��ȱ������ĺ������ѡ'����'������д���ݣ�");	
		return false;
	}
	
	return true;
}

//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		//��ҩʱ�����
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').attr("readonly",false);//ҽ����ҩʱ��
			$('#DrugUseErrType-94617-94205').attr("readonly",false);//�����ҩʱ��
		}
		//��ҩ;������
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').attr("readonly",false);//ҽ����ҩ;��
			$('#DrugUseErrType-94618-94209').attr("readonly",false);//�����ҩ;��
		}
		
	}else{
		///��ҩʱ�����
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').val("");
			$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //ҽ����ҩʱ��
			$('#DrugUseErrType-94617-94205').val("");
			$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //�����ҩʱ��
		}
		//��ҩ;������
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').val("");
			$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //ҽ����ҩ;��
			$('#DrugUseErrType-94618-94209').val("");
			$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //�����ҩ;��
		} 
	}
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//��ҩʱ�����
	if($('#DrugUseErrType-94617').is(':checked')){
		$('#DrugUseErrType-94617-94204').attr("readonly",false);//ҽ����ҩʱ��
		$('#DrugUseErrType-94617-94205').attr("readonly",false);//�����ҩʱ��
	}else{
		$('#DrugUseErrType-94617-94204').val("");
		$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //ҽ����ҩʱ��
		$('#DrugUseErrType-94617-94205').val("");
		$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //�����ҩʱ��
	}
	//��ҩ;������
	if($('#DrugUseErrType-94618').is(':checked')){
		$('#DrugUseErrType-94618-94208').attr("readonly",false);//ҽ����ҩ;��
		$('#DrugUseErrType-94618-94209').attr("readonly",false);//�����ҩ;��
	}else{
		$('#DrugUseErrType-94618-94208').val("");
		$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //ҽ����ҩ;��
		$('#DrugUseErrType-94618-94209').val("");
		$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //�����ҩ;��
	}
	//��©��ҩ
	if($('#DrugUseErrType-94619').is(':checked')){
		$('#DrugUseErrType-94619-94212').attr("readonly",false);//��©����
		$('#DrugUseErrType-94619-94213').attr("readonly",false);//ҽ����ҩʱ��
	}else{
		$('#DrugUseErrType-94619-94212').val("");
		$('#DrugUseErrType-94619-94212').attr("readonly","readonly"); //��©����
		$('#DrugUseErrType-94619-94213').val("");
		$('#DrugUseErrType-94619-94213').attr("readonly","readonly"); //ҽ����ҩʱ��
	}
	//��Һ�ٶȴ��� 
	if($('#DrugUseErrType-94620').is(':checked')){
		$('#DrugUseErrType-94620-94215').attr("readonly",false);//ҩ������
		$('#DrugUseErrType-94620-94216').attr("readonly",false);//�����ҩ�ٶ�
	}else{
		$('#DrugUseErrType-94620-94215').val("");
		$('#DrugUseErrType-94620-94215').attr("readonly","readonly"); //ҩ������
		$('#DrugUseErrType-94620-94216').val("");
		$('#DrugUseErrType-94620-94216').attr("readonly","readonly"); //�����ҩ�ٶ�
	}
	//��������  
	if($('#DrugUseErrType-94621').is(':checked')){
		$('#DrugUseErrType-94621-94219').attr("readonly",false);//ҽ����ҩ����
		$('#DrugUseErrType-94621-94220').attr("readonly",false);//�����ҩ����
	}else{
		$('#DrugUseErrType-94621-94219').val("");
		$('#DrugUseErrType-94621-94219').attr("readonly","readonly"); //ҽ����ҩ����
		$('#DrugUseErrType-94621-94220').val("");
		$('#DrugUseErrType-94621-94220').attr("readonly","readonly"); //�����ҩ����
	}
	//���ʹ��� 
	if($('#DrugUseErrType-94622').is(':checked')){
		$('#DrugUseErrType-94622-94223').attr("readonly",false);//ҽ����ҩ����
		$('#DrugUseErrType-94622-94224').attr("readonly",false);//�����ҩ����
	}else{
		$('#DrugUseErrType-94622-94223').val("");
		$('#DrugUseErrType-94622-94223').attr("readonly","readonly"); //ҽ����ҩ����
		$('#DrugUseErrType-94622-94224').val("");
		$('#DrugUseErrType-94622-94224').attr("readonly","readonly"); //�����ҩ����
	}
	//ҩ����� 
	if($('#DrugUseErrType-94623').is(':checked')){
		$('#DrugUseErrType-94623-94227').attr("readonly",false);//ҽ����ҩ����
		$('#DrugUseErrType-94623-94228').attr("readonly",false);//�����ҩ����
	}else{
		$('#DrugUseErrType-94623-94227').val("");
		$('#DrugUseErrType-94623-94227').attr("readonly","readonly"); //ҽ����ҩ����
		$('#DrugUseErrType-94623-94228').val("");
		$('#DrugUseErrType-94623-94228').attr("readonly","readonly"); //�����ҩ����
	}
	
	
}
//ʱ�� ����У��
function CheckTimeornum(){
	//ʱ������У��
	//����ʱ��
	$('#OccurTime').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#OccurTime').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#OccurTime').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//��ҩʱ����� ҽ����ҩʱ��
	$('#DrugUseErrType-94617-94204').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94617-94204').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94617-94204').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//��ҩʱ����� �����ҩʱ��
	$('#DrugUseErrType-94617-94205').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94617-94205').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94617-94205').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//��©��ҩ ҽ����ҩʱ��
	$('#DrugUseErrType-94619-94213').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94619-94213').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94619-94213').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	
	//��������У��
	//��©��ҩ ��©����
	$('#DrugUseErrType-94619-94212').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//�����˹�������(��)
	$('#DrugUsePartyWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��������(��)
	$('#WLManWorkLife').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��˹�������
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
}
//�ǼǺ��Զ���0
function getRePatNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//ͨ��סԺ�ţ������ţ���ȡ���˻�����Ϣ
function PatMedNoEnter(){
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("��ʾ:","���˲����Ų���Ϊ�գ�");
				return;
			}
			var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			var mycols = [[
				{field:'RegNo',title:'����id',width:80},
				{field:'AdmTypeDesc',title:'��������',width:60}, 
				{field:'AdmLoc',title:'�������',width:120}, 
				{field:'AdmDate',title:'��������',width:80},
				{field:'AdmTime',title:'����ʱ��',width:70},
				{field:'Adm',title:'Adm',width:60,hidden:true} 
			]];
			var mydgs = {
				url:'dhcadv.repaction.csp'+'?action=GetAdmList&Input='+patientNO ,
				columns: mycols,  //����Ϣ
				nowrap:false,
				pagesize:10,  //һҳ��ʾ��¼��
				table: '#admdsgrid', //grid ID
				field:'Adm', //��¼Ψһ��ʶ
				params:null,  // �����ֶ�,��Ϊnull
				tbar:null //�Ϲ�����,��Ϊnull
			}
			var win=new CreatMyDiv(input,$("#PatMedicalNo"),"drugsfollower","460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
			win.init();
		}
	});
}
//��ȡ������ѡ���¼����
function SetAdmIdTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID="";
	}
	InitPatInfo(EpisodeID);
}
//���ݿ���1��ѯ����2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //���������������
	});   

}
//�ǼǺŻس��¼�
function PatIDEnter(){
	$('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var PatID=$('#PatID').val();
			 if (PatID=="")
			 {
				 	$.messager.alert("��ʾ:","���˵ǼǺŲ���Ϊ�գ�");
					return;
			 }
			 var PatID=getRegNo(PatID);
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'�������',width:220}, 
			 	{field:'AdmDate',title:'��������',width:80},
			 	{field:'AdmTime',title:'����ʱ��',width:80},
			 	{field:'RegNo',title:'����id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+PatID ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});	
}
//��ȡ�ǼǺ�ѡ���¼����
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	InitPatInfo(EpisodeID);
	
}

