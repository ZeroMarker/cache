/// Creator: LiangQiang congyue(�޸�)
/// CreateDate: 2015-09-06
/// Description:ҽ�Ʋ����¼�����
var url="dhcadv.repaction.csp";
var patSexArr = [{ "value": "1", "text": "��" }, { "value": "2", "text": "Ů" },{ "value": "3", "text": "����" }];
var adrRepID="",EpisodeID="",patientID="",editFlag="",ID="",assessID="";
var adrCurStatusDR="",adrInitStatDR="";
var ReportTypeCode="med" ;
var adrNextLoc="";adrLocAdvice="";adrReceive="";
var LocDr="";UserDr="";ImpFlag="", patIDlog="";
var adrDataList="",RepUser="",RepDept="";
var frmflag=0;//�Ƿ��ȡ�����б��־ 0 ��ȡ��1 ����ȡ
var winflag=0; //���ڱ�־ 0 �����  1 �޸Ĵ��� 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
$(function(){
	patientID=getParam("patientID");
	EpisodeID=getParam("EpisodeID");
    adrRepID=getParam("adrRepID");
	editFlag=getParam("editFlag");
    satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag"); //2016-09-28
    assessID=getParam("assessID"); //����id
	if ((adrRepID=="")&&(frmflag==0)){
	    var frm = dhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
		    //var papmi=getRegNo(papmi);
	        $.ajax({
		   	   type: "POST",
		       url: url,
		       async: false, //ͬ��
		       data: "action=getPatNo&patID="+papmi,
		       success: function(val){
			      	 papmi=val;
		       }
		    });	    
		    EpisodeID=adm;
		    patientID=papmi;
	        InitPatientInfo(papmi,adm);//��ȡ������Ϣ
	        if((papmi!="")&(adm!="")){
				$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai ���ò���ID���ɱ༭
	        }

		}
	}
	//�ж�����Ĳ���ID�Ƿ�Ϊ���� 2016-10-10
	$('#PatID').bind("blur",function(){
	   var	PatID=$('#PatID').val()	
	   if(isNaN(PatID)){
		    $.messager.alert("��ʾ:","���������֣�");
		   }
	})
    $('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var medrptPatID=$('#PatID').val();
			 if (medrptPatID=="")
			 {
				 	$.messager.alert("��ʾ:","����id����Ϊ�գ�");
					return;
			 }
			 var medrptPatID=getRegNo(medrptPatID);
			if ((patIDlog!="")&(patIDlog!=medrptPatID)&(adrRepID=="")){
				$.messager.confirm("��ʾ", "��Ϣδ����,�Ƿ��������", function (res) {//��ʾ�Ƿ�ɾ��
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.medicalreport.csp?adrDataList='+''";//ˢ�´���adrDataListΪ��
						ReloadJs();//ˢ�´���adrDataListΪ��
					}else{
						$('#PatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=medrptPatID)&(adrRepID!="")){
				ReloadJs();//ˢ�´���adrDataListΪ��
			}
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'�������',width:220}, 
			 	{field:'AdmDate',title:'��������',width:80},
			 	{field:'AdmTime',title:'����ʱ��',width:80},
			 	{field:'RegNo',title:'����id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+medrptPatID ,
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

	//�Ա�
	$('#PatSex').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		editable:false,
		//data:patSexArr
		url:url+'?action=SelSex'
	});
	//���� 2017-08-01 cy �޸� �����򴫵ݲ�������
	$('#PatWard').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#PatWard').combobox('reload',url+'?action=SelwardDesc')
		}
		
	});
	
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
		});
	});

	//��ѡ�����
	InitUIStatus();
	
	
	//��  �¼���������Ϊҽ��ʱ����ʾ���ص��ݴ��ύ��ť
	$('#RT10').click(function(){
		var buttondiv=document.getElementById("buttondiv");
		if ($(this).is(':checked')) {
			buttondiv.style.display='inline';
		} else {
			buttondiv.style.display='none';
		}   
	});	
	//��  �¼���������Ϊ��Ѫ�����¼�ʱ����ʾ���ص��ݴ��ύ��ť
	$('#RT15').click(function(){
		var buttondiv=document.getElementById("buttondiv");
		if ($(this).is(':checked')) {
			buttondiv.style.display='inline';
		} else {
			buttondiv.style.display='none';
		}   
	});	

	InitAdrInfo(adrRepID);
	InitAdrReport(adrRepID);
	InitPatientInfo(patientID,EpisodeID);
	
	$('#AF1').click(function(){  //���ϱ��˲��ܲ�������  qunianpeng 2016/11/15 
		var checkStaus=$(this).is(':checked');
		if(adrRepID==""){
			 CheckUser(checkStaus);
		}else if(RepUser == LgUserName){  
				 CheckUser(checkStaus);
		}else{
			$.messager.alert("��ʾ:","���ϱ��˲����޸�����");
			$("#AF1").attr("checked",!checkStaus);
		}			
	});  
})


///��ѡ������ʱ�����ر����˺ͱ��沿��	qunianpeng 2016/11/15 
function CheckUser(checkStaus){
	if(checkStaus) {
		$("#adrRepUser").val(""); 
		$("#adrRepDept").val(""); 
	}else{
		$("#adrRepUser").val(RepUser); 
		$("#adrRepDept").val(RepDept); 
	}  
}

///��ʼ�����渴ѡ���¼�
function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
					setCheckBoxRelation(this.id);
				}
			})
		}
		setCheckBoxRelation(this.id);
	});
}

/// ���治���¼�����
function saveAdrEventReport(flag)
{

	///����ǰ,��ҳ���������м��
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	//�¼��������
	var adrRepType="";
    $("input[type=checkbox][name=adrRepType]").each(function(){
		if($(this).is(':checked')){
			adrRepType=this.value;
		}
	})
	if(adrRepType==""){
		$.messager.alert("��ʾ:","���¼�������𡿲���Ϊ�գ�");
		return;
	}
	ReportTypeCode=adrRepType;
	GetStatus(adrRepID,ReportTypeCode); //��ȡ��ʼ״̬
	var adrNo=$('#adrNo').val();		//�������
	var adrPatSex=$('#PatSex').combobox('getValue');	//�Ա�
	var  PatName=$('#PatName').val();	//����
	if(PatName==""){
	  $.messager.alert("��ʾ:","�����뻼��ID,ѡ����Ӧ����");
		return;
	}
	var adrPatAge=$('#PatAge').val();	//����
	var adrPatJob=""	//ְ��
	var adrAdmDate=""	//��������
	var adrAdmTime=""	//����ʱ��
	var adrLiveLoc=""	//�ֳ���ؿ���
	var adrResult=""	//�������
	var adrResultDesc=""	//�����������
	//�¼���������
	var adrProcDesc=$('#adrProcessDesc').val();
	var adrLevel="";//�¼��ȼ�
	//��������
	var adrReason=$('#adrReason').val();
	//�Ľ�����  �������
	var AdrHandInfo=$('#adrHandInfo').val();
	var adrAdvice=""	//�������
	var adrImprovie=""	//�Ľ����
	
	var adrRepUserCareer=""	//������ְҵ
    //�ϱ���ְҵ���
	var adrPartyType="";
	$("input[type=checkbox][name=reppepletype]").each(function(){
		if($(this).is(':checked')){
			adrPartyType=this.value;
		}
	})
	//�ϱ���ְ��
    var adrCarPrvTp="";
	$("input[type=checkbox][name=repCarPrv]").each(function(){
		if($(this).is(':checked')){
			adrCarPrvTp=this.value;
		}
	})
	//����������
	var adrRepUser=$('#adrRepUser').val();
    adrRepUser=UserDr;

	//�����˲���
	var adrRepDept=$('#adrRepDept').val();
	adrRepDept=LocDr;
    //��ϵ�绰
	var adrRepTel=$('#ReportUserTel').val();

	//��ϵ����
	var adrEmail=$('#ReportUserEml').val();
	
	//����ID
	var adrPatID=$('#PatID').val();
	if (adrPatID != patientID.replace(/[\'\"\\\/\b\f\n\r\t]/g, '')){
		$.messager.alert("��ʾ:","������ID����ҳ�没����Ϣ����,���ʵ�����ԣ�");
		return;
	}
	if(adrPatID==""){
		$.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return;
	}
    //�¼������ص�
	var adrPlace="";
    $("input[type=checkbox][name=adrplace]").each(function(){
		if($(this).is(':checked')){
			adrPlace=this.value;
		}
	})
	
	//����ʱ��  adrRepDate
	var adrCreateDatetime=$('#adrRepDate').datetimebox('getValue');  
	var adrCreateDate="",adrCreateTime="";
	if(adrCreateDatetime!=""){
		adrCreateDate=adrCreateDatetime.split(" ")[0];  //��������
		adrCreateTime=adrCreateDatetime.split(" ")[1];  //����ʱ��
	}
	if(!compareSelTimeAndCurTime(adrCreateDate)){
		$.messager.alert("��ʾ:","������ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}
	//var adrCurStatusDR=""	//��ǰ״̬
	var adrRemark=""	//��ע
	
	//�¼������ص�����
	var adrPlaceOth=$('#adrPlaceOth').val(); 
	//������־	
	var adrAnonymFlag="";
    $("input[type=checkbox][name=adrAnonymFlag]").each(function(){
		if($(this).is(':checked')){
			adrAnonymFlag=this.value;
		}
	})
	
	//�¼���������
	var adrTimeDateOccu=$('#adrOccDate').datetimebox('getValue');
	var adrDateOccu="",adrTimeOccu="";
	if(adrTimeDateOccu!=""){
		adrDateOccu=adrTimeDateOccu.split(" ")[0];  //�¼���������
		adrTimeOccu=adrTimeDateOccu.split(" ")[1];  //�¼�����ʱ��
	}
	if(!compareSelTimeAndCurTime(adrDateOccu)){
		$.messager.alert("��ʾ:","���������ڡ����ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}  
	var adrRepImpFlag="N"; //�ص��ע
	if(ImpFlag==""){ 
		adrRepImpFlag=adrRepImpFlag;
	}else{
		adrRepImpFlag=ImpFlag;
	}
	var adrAdmNo=EpisodeID;
	if(flag==1){
		adrCurStatusDR=adrInitStatDR;  //��ʼ״̬
	}
    //var adrRepAuditList="" ;
	//if(flag==1){
	var adrRepAuditList=adrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive+"^"+ReportTypeCode;
	//}
	var repdatalist=adrNo+"^"+adrPatSex+"^"+adrPatAge+"^"+adrPatJob+"^"+adrAdmDate+"^"+adrAdmTime+"^"+adrLiveLoc;
	var repdatalist=repdatalist+"^"+adrResult+"^"+adrResultDesc+"^"+adrProcDesc+"^"+adrLevel+"^"+adrReason;
	var repdatalist=repdatalist+"^"+AdrHandInfo+"^"+adrAdvice+"^"+adrImprovie+"^"+adrRepUserCareer+"^"+adrPartyType;
	var repdatalist=repdatalist+"^"+adrCarPrvTp+"^"+adrRepUser+"^"+adrRepDept+"^"+adrRepTel+"^"+adrEmail;
	var repdatalist=repdatalist+"^"+adrPatID+"^"+adrPlace+"^"+adrCreateDate+"^"+adrCreateTime+"^"+adrCurStatusDR;
	var repdatalist=repdatalist+"^"+ReportTypeCode+"^"+adrRemark+"^"+adrPlaceOth+"^"+adrAnonymFlag+"^"+adrRepImpFlag+"^"+adrAdmNo+"^"+adrDateOccu+"^"+adrTimeOccu;
	
	var param="adrRepID="+adrRepID+"&adrRepDataList="+repdatalist+"&adrRepAuditList="+adrRepAuditList+"&flag="+flag ;
	//alert(param);
	//���ݱ���/�ύ
	var  mesageShow=""
	if(flag==0){
		mesageShow="����"
	}
	if(flag==1){		
		mesageShow="�ύ"		
	}
	$.messager.confirm("��ʾ", "�Ƿ����"+mesageShow+"����", function (res) {//��ʾ�Ƿ񱣴�
		if (res) {
    		$.ajax({
   	   			type: "POST",
       			url: url,
       			data: "action=saveMedReport&"+param,
       			success: function(val){
					var medrArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
					if (medrArr[0]=="0") {
						$.messager.alert("��ʾ:",mesageShow+"�ɹ�!");
						adrRepID=medrArr[1];
						if(winflag==1){
							 window.parent.CloseWinUpdate();
						}
						InitAdrReport(adrRepID);//��ȡ������Ϣ  qunianpeng 16/09/29 Update
						winflag=0; //2017-05-24
						var adrRepType="";
					    $("input[type=checkbox][name=adrRepType]").each(function(){
							if($(this).is(':checked')){
								adrRepType=this.value;
							}
						})
						if(adrRepType=="bldevent"){
							var rflag=confirm('��ò����¼�ͬʱ�鷢��Ѫ������Ӧ��������д��Ѫ������Ӧ�����')
				    		if (rflag==true){ 
				    			adrRepType="blood";
								showRepTypeWin(adrRepType);   
				       			 return true;   
				    		}
						}
						if(flag==1){
							$("[name=adrRepType]:checkbox").attr("disabled",true);//�������Ͳ��ɹ�ѡ
							$("#buttondiv").hide(); //2017-05-24
						}
						if(editFlag!=0){
							window.parent.Query();
						}
					}else{
		  	 			if(val==-1){
							$.messager.alert("��ʾ:","��Ȩ��");	
						}else if(val==-2){
							$.messager.alert("��ʾ:","�������һ��Ȩ��");	
						}else if(val==-3){
							$.messager.alert("��ʾ:","����Ȩ������");	
						}else if(val==-4){
							$.messager.alert("��ʾ:","����������");	
						}else{
							$.messager.alert("��ʾ:","����"+val);
						}
		  			}
				},
				error: function(val){
					alert('���ӳ���');
					return;
				}
			});
		}
	});
}

//���ر�����Ϣ
function InitAdrReport(adrRepID)
{

	if(adrRepID==""){return;}
	//var assessment=document.getElementById("assessment");
	//assessment.style.display='inline';  //������ť��ʾ
	//assessment.style.display=''; 
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+ReportTypeCode;
	winflag=1; //2016-10-10
	//��ȡ������Ϣ
 	$.ajax({
   	   type: "POST",
       url: url,
       async: false, //ͬ�� 2017-05-24
       data: "action=GetMedRepInfo&adrRepID="+adrRepID+"&params="+params,
       success: function(val){
	        var tmp=val.split("!");
			$('#adrNo').val(tmp[0]);    //�������
			$('#adrNo').attr("disabled","true");
			$('#PatSex').combobox('setValue',tmp[1]);     //�Ա�
			$('#PatAge').val(tmp[2]);    //����
		    $('#PatAge').attr("disabled","true");
			//$('#PatJob').val(tmp[3]);    //ְҵ
			//$('#PatAdmDate').datetimebox("setValue",tmp[4]+" "+tmp[5]); //��������
			//$('#RepLiveLoc').val(tmp[6]); //�ڳ������Ա 
            //$('#ret'+tmp[7]).attr("checked",true); //�������
			//if(tmp[7]=="11"){
				//$('#adrresultdesc').val(tmp[8]);  //�����������
				//$('#adrresultdesc').attr("disabled",false);
			//}
			$('#adrProcessDesc').val(tmp[9]);    //�¼���������
			$('#adrlevel'+tmp[10]).attr("checked",true);  //�����¼��ȼ�
			$('#adrReason').val(tmp[11]);    //��������  �����¼��Ŀ���ԭ��
			$('#adrHandInfo').val(tmp[12]);    //�Ľ�����  �¼��������
	
            //$('#adrAdvice').val(tmp[13]); //�������
            //$('#adrImprovie').val(tmp[14]); //�Ľ���ʩ
			//$('#ty'+tmp[15]).attr("checked",true); //������ְҵ
			$('#ty'+tmp[16]).attr("checked",true);   //�ϱ���ְҵ���
            $('#prv'+tmp[17]).attr("checked",true); //�ϱ���ְ��
	
			$('#adrRepUser').val(tmp[18]);    //����������
			RepUser=tmp[18];
			$('#adrRepUser').attr("disabled","true");
            $('#adrRepDept').val(tmp[19]); //���沿��
            RepDept=tmp[19];
            $('#adrRepDept').attr("disabled","true");
			$('#ReportUserTel').val(tmp[20]); //��ϵ�绰
            $('#ReportUserEml').val(tmp[21]); //��ϵemail
	      	$('#PatID').val(tmp[22]);    //����ID
			patientID = tmp[22];
			$('#adrRepDate').datetimebox({disabled:true});
			if(tmp[24]!=""||tmp[25]!=""){
				$('#adrRepDate').datetimebox("setValue",tmp[24]+" "+tmp[25]); //��������
			}
			ReportTypeCode=tmp[27];
			adrCurStatusDR=tmp[26]
			//$('#adrRepRemark').val(tmp[28]); //��ע
            $('#PL'+tmp[23]).attr("checked",true); //�¼������ص�
			$('#adrPlaceOth').val(tmp[29]); //�¼��������� ���� 
			if(tmp[23]=="15"){
				$('#adrPlaceOth').attr("disabled",false);
			}
						
			$('#PatDiag').val(tmp[30]); //�ٴ���� 
			$('#PatNo').val(tmp[31]); //������ 
			$('#PatName').val(tmp[36]); //�������� 
			
			adrInitStatDR=tmp[32];
			adrNextLoc=tmp[33];
			adrLocAdvice=tmp[34];
			adrReceive=tmp[35];
			UserDr=tmp[37];
			LocDr=tmp[38];
			ImpFlag=tmp[42];//��Ҫ���
			EpisodeID=tmp[43];//����ID	
			if(tmp[44]!=""||tmp[45]!=""){
				$('#adrOccDate').datetimebox('setValue',tmp[44]+" "+tmp[45]); //�¼���������
			}
			$('#AF'+tmp[39]).attr("checked",true);  //����
			if(tmp[39]=="1"){
				$('#adrRepUser').val("");    //����������
            	$('#adrRepDept').val(""); //���沿��
			}
			$('#PatWard').combobox('setValue',tmp[40]);     //����ID
			$('#PatWard').combobox('setText',tmp[46]);     //��������
			//�������
			if (tmp[41]=="med"){
            	$('#RT'+"10").attr("checked",true); 
            	var buttondiv=document.getElementById("buttondiv");
				buttondiv.style.display='inline';
				//�жϰ�ť�Ƿ�����
				if (satatusButton==1) {
					buttondiv.style.display='none';
	            }
            }
			if (tmp[41]=="bldevent"){
            	$('#RT'+"15").attr("checked",true); //�������
            	var buttondiv=document.getElementById("buttondiv");
				buttondiv.style.display='inline';
				//�жϰ�ť�Ƿ�����
				if (satatusButton==1) {
					buttondiv.style.display='none';
	            }
            }
			$("[name=adrRepType]:checkbox").attr("disabled",true);//�������Ͳ��ɹ�ѡ
            
            
         
			if (adrCurStatusDR==""){
				adrCurStatusDR=adrCurStatusDR;
				adrReceive="";
			}else{
				adrInitStatDR=tmp[26];
				//adrReceive="1";
				if(((UserDr==LgUserID)&&(adrReceive=="2"))||(UserDr!=LgUserID)){
					adrReceive="1";
				}
			}
			//2017-06-12 �����������������޸�
			if(assessID!=""){
				$("#savebt").hide();
				$("#submitdiv").hide();
			}
			if (tmp[26]!=""){  //������ύ״̬
				$('#submitdiv').hide();//�����ύ��ť
				//��ȡ����Ȩ�ޱ�־ 2016-10-19
				var Assessflag=GetAssessAuthority(adrRepID,params);
				if (Assessflag=="Y"){
					$('#assessment').show(); //��ʾ������ť 
				}
			}
			$('#clearbt').hide();//������հ�ť
			
	   } ,
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
	});
}

//���ر���Ĭ����Ϣ
function InitAdrInfo(adrRepID)
{
   if(adrRepID!=""){return;}
   var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+ReportTypeCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMedInfo&params="+params,
   success: function(val){
		if(val==-1){
			$.messager.alert("��ʾ:","�������ù�������Ȩ��,Ȼ�����");
	       return;
		}else{
			var tmp=val.split("^");
			//$('#adrNo').val(tmp[0]);    //�������
			$('#adrNo').attr("disabled","true");
			$('#adrRepDate').datetimebox({disabled:true});
			$('#adrRepDate').datetimebox("setValue",tmp[1]);   //��������
			//adrInitStatDR=tmp[2];  //����ĳ�ʼ��,״̬ 
			//ReportTypeCode=tmp[3];  // ���������
			$('#adrRepUser').val(LgUserName);    //����������
			$('#adrRepUser').attr("disabled","true");
			$('#adrRepDept').val(tmp[4]);     //�����˲���
			$('#adrRepDept').attr("disabled","true");
	
			LocDr=LgCtLocID;
			UserDr=LgUserID;
			RepUser=LgUserName;
		    RepDept=tmp[4];
	   }
   }})
}

function GetStatus(adrRepID,ReportTypeCode)
{
	if(adrRepID!=""){return;}
	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+ReportTypeCode;
	$.ajax({
		type: "POST",
		url: url,
		async: false, //ͬ��
		data:"action=getMedInfo&params="+params,
		success: function(val){
			var tmp=val.split("^");
			adrInitStatDR=tmp[2];  //����ĳ�ʼ��,״̬ 
			ReportTypeCode=tmp[3];  // ���������
		}
	})
}
//���ر�������Ϣ
function InitPatientInfo(patientID,EpisodeID)
{
	if((patientID=="")||(EpisodeID=="")){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
			//������Ϣ
			$('#PatID').val(tmp[0]); //����ID
			$('#PatName').val(tmp[1]); //��������
			$('#PatName').attr("disabled","true");
			$('#PatSex').combobox({disabled:true});
			$('#PatSex').combobox('setValue',tmp[2]);  //�Ա�
			$('#PatAge').val(tmp[4]);  //����
			$('#PatAge').attr("disabled","true");
			$('#PatNo').val(tmp[5]); //������
			$('#PatNo').attr("disabled","true");
			//$('#PatAdmDate').datebox({disabled:'true'});
			//$('#PatAdmDate').datebox("setValue",tmp[24]);  //��������
			//$('#PatAdmDate').datetimebox({disabled:'true'});
			//$('#PatAdmDate').datetimebox("setValue",tmp[24]+" "+tmp[23]);  //��������
           	$('#PatDiag').val(tmp[10]);  //���
			$('#PatDiag').attr("disabled","true");
           	$('#PatWard').combobox('setValue',tmp[12]);  //����ID
           	$('#PatWard').combobox('setText',tmp[11]);  //��������
			patIDlog=$('#PatID').val();
		}
	})
}

//��.js������function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	patientID=$('#PatID').val();
	patientID=getRegNo(patientID);
	InitPatientInfo(patientID,EpisodeID);
	
	//InitPatientInfo(EpisodeID);
}
//����ǰ,������������Լ��
function saveBeforeCheck()
{
	//�¼��������
	var adrRepType="";
    $("input[type=checkbox][name=adrRepType]").each(function(){
		if($(this).is(':checked')){
			adrRepType=this.value;
		}
	})
	if(adrRepType==""){
		$.messager.alert("��ʾ:","���¼�������𡿲���Ϊ�գ�");
		return false;
	}
	var adrNo=$('#adrNo').val();		//�������
	var adrPatSex=$('#PatSex').combobox('getValue');	//�Ա�
	if(adrPatSex==""){
		$.messager.alert("��ʾ:","�������Ա𡿲���Ϊ�գ�");
		return false;
	}
	var adrPatAge=$('#PatAge').val();	//����
	if(adrPatAge==""){
		$.messager.alert("��ʾ:","���������䡿����Ϊ�գ�");
		return false;
	}
	//�¼���������
	var adrProcDesc=$('#adrProcessDesc').val();
	if(adrProcDesc==""){
		$.messager.alert("��ʾ:","���¼���������������Ϊ�գ�");
		return false;
	}else if(adrProcDesc.length>300){
		var beyond=adrProcDesc.length-300;
		$.messager.alert("��ʾ","���¼���������������"+beyond+"����");
		return false;
	}
	
	//��������
	var adrReason=$('#adrReason').val();
	if(adrReason==""){
		$.messager.alert("��ʾ:","����������������Ϊ�գ�");
		return;
	}else if(adrReason.length>300){
		var beyond=adrReason.length-300;
		$.messager.alert("��ʾ","����������������"+beyond+"����");
		return false;
	}
	//�Ľ�����  �������
	var AdrHandInfo=$('#adrHandInfo').val();
	if(AdrHandInfo==""){
		$.messager.alert("��ʾ:","���Ľ����顿����Ϊ�գ�");
		return false;
	}else if(AdrHandInfo.length>300){
		var beyond=AdrHandInfo.length-300;
		$.messager.alert("��ʾ","���Ľ����顿����"+beyond+"����");
		return false;
	}
	
	//����ID
	var adrPatID=$('#PatID').val();
	if(adrPatID==""){
		$.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return false;
	}
	return true;
}

//ҳ���������
function setCheckBoxRelation(id){
	
	if($('#'+id).is(':checked')){	
		//�¼������ص�����
		if(id=="PL15"){
			$('#adrPlaceOth').attr("disabled",false);
		}
		//�¼���������
		if(id=="RT11"||id=="RT12"||id=="RT13"||id=="RT14"){
			var adrRepType="";
			var buttondiv=document.getElementById("buttondiv");
			var medhidinfo=document.getElementById("medhidinfo");
			$("input[type=checkbox][name=adrRepType]").each(function(){
				if($(this).is(':checked')){
					adrRepType=this.value;
					buttondiv.style.display='none';
					medhidinfo.style.display='none';
				}
			})
			if ((patientID!="")&(EpisodeID!="")){
				showRepTypeWin(adrRepType);	
			}else{
	      	 	$.messager.alert("��ʾ:","����id����Ϊ��!");
				$("[name=adrRepType]:checkbox").prop("checked",false);
	       		return;
			}

		}
		//�¼���������
		if(id=="RT10"||id=="RT15"){
			var adrRepType="";
			var buttondiv=document.getElementById("buttondiv");
			var medhidinfo=document.getElementById("medhidinfo");
			$("input[type=checkbox][name=adrRepType]").each(function(){
				if($(this).is(':checked')){
					adrRepType=this.value;
					buttondiv.style.display='inline';
					medhidinfo.style.display='inline';
				}
			})
		}
		//����
		if(id=="AF1"){ //ע�� qunianpeng 2016/11/15
		//	$("#adrRepUser").val(""); 
		//	$("#adrRepDept").val(""); 
		}
	}else{
		//ȡ���¼������ص�����
		if(id=="PL15"){
			$('#adrPlaceOth').val("");
			$('#adrPlaceOth').attr("disabled",true);
		}

	}
}

//�༭����(����)
 function assessmentRep()
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'��������',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+adrRepID+'&RepType='+ReportTypeCode+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
}
function closeRepWindow(assessID)   //wangxuejian 2016-10-09      �ر���������
{   
	//2017-06-12 �����������������޸�
	if(assessID!=""){
		$("#savebt").hide();
		$("#submitdiv").hide();
	}
	$('#win').window('close');
}
	
//�༭����
function showRepTypeWin(adrRepType)
{
	if($('#winds').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winds"></div>');
	$('#winds').window({
		title:'�����¼�����',
		collapsible:true,
		border:false,
		closed:"true",
		width:1300,
		height:600,
		onBeforeClose:function(){
			child.window.RepNoRepet();
			var repnoflag=$('#repnoflag').val();
			if (repnoflag==0){	
	 			var rflag=confirm('δ���棬ȷ�Ϲرմ�����')
	    		if (rflag==true){    
	       			 return true;   
	    		}else{
		    		return false;
		    	}
	    	} 
		}
	});
		
	adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrRepType;
 	if(adrRepType=="material"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
	}
	if(adrRepType=="drugerr"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
 	} 
	if(adrRepType=="blood"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
	}
	if(adrRepType=="drug"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
	}
}
//2016-10-10
function CloseWin(){
		$('#winds').window('close');
}
//ˢ�½��� 2016-09-26
function ReloadJs(){
	window.location.href="dhcadv.medicalreport.csp?frmflag="+"1";//ˢ�´���adrDataListΪ��
}			
