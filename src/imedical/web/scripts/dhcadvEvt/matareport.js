
/// Creator: congyue
/// CreateDate: 2015-09-22
///  Descript: ��е������Ӧ����

var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "��" }, { "val": "2", "text": "Ů" },{ "val": "3", "text": "����" }];
var editRow="";matadrID="";patientID="";EpisodeID="";editFlag="";adrDataList="",assessID="";
var MatadrInitStatDR="";mataReportType="";matadrCurStatusDR="";
var medadrNextLoc="";medadrLocAdvice="";medadrReceive="";
var CurRepCode="material"; ImpFlag="", patIDlog="";
var frmflag=0; //�Ƿ��ȡ�����б���־ 0 ��ȡ��1 ����ȡ
var winflag=0; //���ڱ�־ 0 �����  1 �޸Ĵ��� 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	matadrID=getParam("matadrID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag");
    assessID=getParam("assessID"); //����id
	if ((adrDataList=="")&&(matadrID=="")&&(frmflag==0)){
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
	        getMataRepPatInfo(papmi,adm);//��ȡ������Ϣ
	        if((papmi!="")&(adm!="")){
				$('#PatNo').attr("disabled","true");  ///2017-07-20 bianshuai ���ò���ID���ɱ༭
	        }
		}
	}
    //�жϰ�ť�Ƿ�����
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	//�ж�����Ĳ���ID�Ƿ�Ϊ���� 2016-10-10
	 $('#PatNo').bind("blur",function(){
	   var	matadrPatNo=$('#PatNo').val();
	   if(isNaN(matadrPatNo)){
		    $.messager.alert("��ʾ:","���������֣�");
	    }
	})
	//���˵ǼǺŻس��¼�
	$('#PatNo').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 var matadrPatNo=$('#PatNo').val();
			 if (matadrPatNo=="")
			 {
				 	$.messager.alert("��ʾ:","����id����Ϊ�գ�");
					return;
			 }
			 var matadrPatNo=getRegNo(matadrPatNo);
			if ((patIDlog!="")&(patIDlog!=matadrPatNo)&(matadrID=="")){
				$.messager.confirm("��ʾ", "��Ϣδ����,�Ƿ��������", function (res) {//��ʾ�Ƿ�ɾ��
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.matareport.csp?adrDataList='+''";//ˢ�´���adrDataListΪ��
						ReloadJs();//ˢ�´���adrDataListΪ��
					}else{
						$('#PatNo').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=matadrPatNo)&(matadrID!="")){
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
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+matadrPatNo ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
			 var win=new CreatMyDiv(input,$("#PatNo"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
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
	 
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			setCheckBoxRelation(this.id);
		});
	});
	
	//��ѡ�����
	InitUIStatus();
	//���¼����Ϊ����ʱ����ʾ���ص�ʱ���
	
	 $("input[type=checkbox][name=matadrResult]").click(function(){
		if($(this).is(':checked')){
			var matadrResult=this.value;
			var matadrEventResultDate=document.getElementById("deathdate");
			if (matadrResult==10) {
				matadrEventResultDate.style.display='inline';
			} else {
				matadrEventResultDate.style.display='none';
			}  
		}
	})
	$('#TR10').click(function(){
		var matadrEventResultDate=document.getElementById("deathdate");
		
		if ($(this).is(':checked')) {
			matadrEventResultDate.style.display='inline';
		} else {
			matadrEventResultDate.style.display='none';
		}   
	}); 
	InitMataReport(matadrID);  //��ȡ������Ϣ
	InitPatientInfo(matadrID,adrDataList);//��ȡҳ��Ĭ����Ϣ
	getMataRepPatInfo(patientID,EpisodeID);//��ȡ������Ϣ
	
	//editFlag״̬Ϊ0,�����ύ���ݴ水ť
	if(editFlag=="0"){
		$("a:contains('�ύ')").css("display","none");
		$("a:contains('�ݴ�')").css("display","none");
	}
	
})

// �ı��༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ���ڱ༭��
var dateboxditor={
	type: 'datebox',//���ñ༭��ʽ
	options: {
		//required: true //���ñ༭��������
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

/// �������ҽ����е�����¼������
function saveMataEventReport(flag)
{

	///����ǰ,��ҳ���������м��
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	
	//1����������
	var matadrCreateDate=$('#matadrCreateDate').datetimebox('getValue');   
	var matadrCreateDateResult="",matadrCreateTimeResult="";
	if(matadrCreateDate!=""){
		matadrCreateDateResult=matadrCreateDate.split(" ")[0];  //��������
		matadrCreateTimeResult=matadrCreateDate.split(" ")[1];  //����ʱ��
	}
	//2���������
	var matadrNo=$('#matadrNo').val();
	matadrNo=matadrNo.replace(/[ ]/g,""); //ȥ�������еĿո�
	//A��������Ϣ
	//����ID
	var matadrPatID=$('#PatID').val();
	
	//���˵ǼǺ�
	var matadrPatNo=$('#PatNo').val();
	if(matadrPatNo==""){
		$.messager.alert("��ʾ:","�����˵ǼǺš�����Ϊ�գ�");
		return;
	}
	//��������
	var matadrName=$('#PatName').val();
	if(matadrName==""){
	  $.messager.alert("��ʾ:","�����뻼��ID,ѡ����Ӧ����");
		return;
	}
    //�����Ա�
	var matadrSex=$('#PatSex').combobox('getValue');
    //��������
	var matadrAge=$('#PatAge').val();  
	//Ԥ�����Ƽ���������
	var matadrExpectEff=$('#matadrExpectEff').val();  
	//��������
	var matadrAdmDate=$('#matadrAdmDate').datetimebox('getValue');   
	var matadrAdmDateResult="",matadrAdmTimeResult="";
	if(matadrAdmDate!=""){
		matadrAdmDateResult=matadrAdmDate.split(" ")[0];  //��������
		matadrAdmTimeResult=matadrAdmDate.split(" ")[1];  //����ʱ��
	}
	
	//B.�����¼����
	var matadrMainExp=$('#matadrMainExp').val();  //�¼���Ҫ����
	//1.�¼���������
	var matadrAdrDate=$('#matadrAdrDate').datebox('getValue');   
	//2.���ֻ���֪Ϥʱ��
	var matadrDiscDate=$('#matadrDiscDate').datebox('getValue');   
	//3.ҽ����еʵ��ʹ�ó���
	var matadrUsePlace="";
	var matadrUsePlaceOth="";
    $("input[type=checkbox][name=matadrUsePlace]").each(function(){
		if($(this).is(':checked')){
			matadrUsePlace=this.value;
		}
	})
	matadrUsePlaceOth=$('#matadrUsePlaceOth').val();
	//4.�¼����
	var matadrResult="";
	var matadrEventResultDate="";
	var matadrDeathDate="",matadrDeathTime="";
     $("input[type=checkbox][name=matadrResult]").each(function(){
		if($(this).is(':checked')){
			matadrResult=this.value;
		}
	})
	if(matadrResult=="10"){
		matadrEventResultDate=$('#matadrEventResultDate').datetimebox('getValue'); 
		if(matadrEventResultDate==""){
			$.messager.alert("��ʾ:","�¼����Ϊ��������,����д����ʱ�䣡");
			return ;
		}else{
			matadrDeathDate=matadrEventResultDate.split(" ")[0];  //��������
			matadrDeathTime=matadrEventResultDate.split(" ")[1];  //����ʱ��
		}
	}		
	
	//5.�¼�����
	var matadrEventDesc=$('#matadrEventDesc').val();
	
	//C.ҽ����е���
	var matadrProName=$('#matadrProName').val();  //��Ʒ����
	var matadrInciName=$('#matadrInciName').val();  //��Ʒ����
	var matadrRegNo=$('#matadrRegNo').val();  //ע��֤��
	var matadrManf=$('#matadrManf').val();  //������ҵ����
	var matadrManfAddress=$('#matadrManfAddress').val();  //������ҵ��ַ
	var matadrManfTel=$('#matadrManfTel').val();  //��ҵ��ϵ�绰
	var matadrSpec=$('#matadrSpec').val();  //�ͺŹ��
	var matadrProCode=$('#matadrProCode').val();  //��Ʒ���
	var matadrProBatNo=$('#matadrProBatNo').val();  //��Ʒ����

	//1.������
	var matadrOperator="";
	var matadrOperatorOth="";
    $("input[type=checkbox][name=matadrOperator]").each(function(){
		if($(this).is(':checked')){
			matadrOperator=this.value;
		}
	})
	matadrOperatorOth=$('#matadrOperatorOth').val();
	//2.��������
	var matadrProDate=$('#matadrProDate').datebox('getValue');   
	//3.��Ч����
	var matadrExpDate=$('#matadrExpDate').datebox('getValue');   
	//4.ֲ������(��ֲ��)
	var matadrUseDate=$('#matadrUseDate').datebox('getValue');   
	//5.ͣ������
	var matadrDisDate=$('#matadrDisDate').datebox('getValue');   
	//6.�¼���������ԭ�����
	var matadrReasonDesc=$('#matadrReasonDesc').val();
	//7.�¼������������
	var matadrHandInfo=$('#matadrHandInfo').val();	
	//8.�¼�����״̬
	var matadrHandStatus="";
    $("input[type=checkbox][name=matadrHandStatus]").each(function(){
		if($(this).is(':checked')){
			matadrHandStatus=this.value;
		}
	})	
	//D. �����¼����� 
	//1.ʡ����⼼�������������
	var matadrProAdvice=$('#matadrProAdvice').val();	
	//2.���Ҽ�⼼�������������
	var matadrCountryAdvice=$('#matadrCountryAdvice').val();	
	//3.������ְ��
	var matadrCarPrvTp="";
    $("input[type=checkbox][name=matadrCarPrvTp]").each(function(){
		if($(this).is(':checked')){
			matadrCarPrvTp=this.value;
		}
	})
	//������
	var matadrRepName=$('#matadrRepNameID').val();
	//�����˿���
	var matadrRepLocDr=$('#matadrRepLocID').val();
	var matadrRepTel=$('#matadrRepTel').val();   //��������ϵ�绰
	var matadrRepEmail=$('#matadrRepEmail').val();   //����������
	var matadrRepImpFlag="N"; //�ص��ע
	if(ImpFlag==""){
		matadrRepImpFlag=matadrRepImpFlag;
	}else{ 
		matadrRepImpFlag=ImpFlag;
	}
	var matadrAdmNo=EpisodeID; //����ID
	if(flag==1){
		matadrCurStatusDR=MatadrInitStatDR;  //��ʼ״̬
		
	}
	
	// ʹ��ҽ����е���ѷ���/���ܷ������˺��¼�֮���Ƿ���к������Ⱥ�˳��
	var matadrIfReaOrder="";
    $("input[type=checkbox][name=matadrIfReaOrder]").each(function(){
		if($(this).is(':checked')){
			matadrIfReaOrder=this.value;
		}
	})
	// ����/���ܷ������˺��¼��Ƿ�������ʹ��ҽ����е���ܵ��µ��˺�����
	var matadrIfDamageType="";
    $("input[type=checkbox][name=matadrIfDamageType]").each(function(){
		if($(this).is(':checked')){
			matadrIfDamageType=this.value;
		}
	})
	// �ѷ���/���ܷ������˺��¼��Ƿ�����úϲ���ҩ�����á����߲����������ҽ����е����������
	var matadrIfReasonable="";
    $("input[type=checkbox][name=matadrIfReasonable]").each(function(){
		if($(this).is(':checked')){
			matadrIfReasonable=this.value;
		}
	})
	// ���������۽��
	var matadrRelEvaluation="";
    $("input[type=checkbox][name=matadrRelEvaluation]").each(function(){
		if($(this).is(':checked')){
			matadrRelEvaluation=this.value;
		}
	})
	
	var matadrDataList=matadrNo+"^"+matadrSex+"^"+matadrAge+"^"+matadrName+"^"+matadrPatNo+"^"+matadrExpectEff+"^"+matadrAdmDateResult;
	matadrDataList=matadrDataList+"^"+matadrAdmTimeResult+"^"+matadrMainExp+"^"+matadrAdrDate+"^"+matadrDiscDate;
	matadrDataList=matadrDataList+"^"+matadrUsePlace+"^"+matadrUsePlaceOth+"^"+matadrResult+"^"+matadrDeathDate;
	matadrDataList=matadrDataList+"^"+matadrDeathTime+"^"+matadrEventDesc+"^"+matadrProName+"^"+matadrInciName+"^"+matadrRegNo;
	matadrDataList=matadrDataList+"^"+matadrManf+"^"+matadrManfAddress+"^"+matadrManfTel+"^"+matadrSpec+"^"+matadrProCode;
	matadrDataList=matadrDataList+"^"+matadrProBatNo+"^"+matadrOperator+"^"+matadrOperatorOth+"^"+matadrExpDate+"^"+matadrProDate;
	matadrDataList=matadrDataList+"^"+matadrDisDate+"^"+matadrUseDate+"^"+matadrReasonDesc+"^"+matadrHandInfo+"^"+matadrHandStatus;
	matadrDataList=matadrDataList+"^"+matadrProAdvice+"^"+matadrCountryAdvice+"^"+matadrCarPrvTp+"^"+matadrRepName+"^"+matadrRepLocDr;
	matadrDataList=matadrDataList+"^"+matadrRepTel+"^"+matadrRepEmail+"^"+matadrCreateDateResult+"^"+matadrCreateTimeResult;
	matadrDataList=matadrDataList+"^"+matadrCurStatusDR+"^"+mataReportType+"^"+matadrRepImpFlag+"^"+matadrAdmNo;
	matadrDataList=matadrDataList+"^"+matadrIfReaOrder+"^"+matadrIfDamageType+"^"+matadrIfReasonable+"^"+matadrRelEvaluation; //���� �ж�����
	//var matadrRepAuditList="";
	//if(flag==1){
	var matadrRepAuditList=matadrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+medadrNextLoc+"^"+medadrLocAdvice+"^"+medadrReceive+"^"+mataReportType;
	//}
	
	var param="matadrID="+matadrID+"&matadrDataList="+matadrDataList+"&matadrRepAuditList="+matadrRepAuditList+"&flag="+flag ; 
	//alert(param);
	//���ݱ���/�ύ
	var  mesageShow=""
	if(flag==0){
		mesageShow="����"
	}
	if(flag==1){		
		mesageShow="�ύ"		
	}
	$.messager.confirm("��ʾ", "�Ƿ����"+mesageShow+"����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.ajax({
   	   			type: "POST",
      			url: url,
       			data: "action=saveMataReport&"+param,
       			success: function(val){
	      			var mataArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (mataArr[0]=="0") {
	      	 			$.messager.alert("��ʾ:",mesageShow+"�ɹ�!");
			 			matadrID=mataArr[1];
			 			if(winflag==0){
						 	if (((adrDataList!="") ||((adrDataList=="")&&(frmflag==1)) )&&(flag==1)){
			  					window.parent.CloseWin();
					  		}
					 	}else if(winflag==1){
							window.parent.CloseWinUpdate();
			  			}
			 				if(adrDataList=="")  //wangxuejian 2016/10/18
                                               {
			 			InitMataReport(matadrID);  //��ȡ������Ϣ(��ȡ������Ϣ) qunianpeng 16/09/29 update
			 			winflag=0;
                                                }
			 			ID=matadrID;
			 			if(flag==1){
							//$("a:contains('�ύ')").attr("disabled",true);
							//$("a:contains('�ݴ�')").attr("disabled",true);
							var buttondiv=document.getElementById("buttondiv");
							buttondiv.style.display='none';
						}
						if(editFlag!=0){
							window.parent.Query();
						}
	      			}else
	      			{
		  	 			if(val==-1){
							$.messager.alert("��ʾ:","��Ȩ��");	
						}else if(val==-2){
							$.messager.alert("��ʾ:","�������һ��Ȩ��");	
						}else if(val==-3){
							$.messager.alert("��ʾ:","����Ȩ������");	
						}else if(val==-4){
							$.messager.alert("��ʾ:","����������");	
						}else{
							$.messager.alert("��ʾ:","����");
						}
		  			
		  			}
       			},
       			error: function(){
	       			alert('���ӳ���');
	       			return;
	   			}
    		});
		}
	});
	//����
   /*  $.ajax({
   	   type: "POST",
       url: url,
       data: "action=saveMataReport&"+param,
       success: function(val){
	      var mataArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      if (mataArr[0]=="0") {
	      	 $.messager.alert("��ʾ:","����ɹ�!");
			 matadrID=mataArr[1];
	      }else{
		  	 $.messager.alert("��ʾ:",val);
		  }
       },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    }); */
    
}
//��дģ��
function Mould()
{
	    $('#MouldTable').window({
		title:'��дģ��',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:430,
		height:520
	}); 
		$('#MouldTable').window('open');
		//$('#matadrEventDesc').val();
		$('#MT1').datebox("setValue","");;   
		$('#MT2').val("");
		$('#MT3').val("");
		$('#MT4').val("");
		$('#MT5').val("");
		$('#MT6').val("");
		$('#MT7').datebox("setValue","");
		$('#MT8').val("");
		$('#MT9').datebox("setValue","");
		$('#MT10').val("");
		$('#MT11').val("");

}
function saveMouldTable(){
	var EventDesc=$('#matadrEventDesc').val()
	var MT1=$('#MT1').datebox('getValue');   
	var MT2=$('#MT2').val();
	var MT3=$('#MT3').val();
	var MT4=$('#MT4').val();
	var MT5=$('#MT5').val();
	var MT6=$('#MT6').val();
	var MT7=$('#MT7').datebox('getValue');
	var MT8=$('#MT8').val();
	var MT9=$('#MT9').datebox('getValue');
	var MT10=$('#MT10').val();
	var MT11=$('#MT11').val();
	var Str1="",Str2="",Str3="",Str4="",Str5="",Str6="",Str7="",Str8="",Str9="",Str10="",Str11="";
	if (MT1!==""){
		if(!compareSelTimeAndCurTime(MT1)){
			$.messager.alert("��ʾ:","����еʹ��ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
			return false;	
		}
		Str1="��еʹ��ʱ��:"+MT1+"��";
	}
	if (MT2!==""){
		Str2="ʹ��Ŀ��:"+MT2+"��";
	}
	if (MT3!==""){
		Str3="ʹ������:"+MT3+"��";
	}
	if (MT4!==""){
		Str4="ʹ�����:"+MT4+"��";
	}
	if (MT5!==""){
		Str5="�����¼����:"+MT5+"��";
	}
	if (MT6!==""){
		Str6="���ܺ���Ӱ��:"+MT6+"��";
	}
	if (MT7!==""){
		if(!compareSelTimeAndCurTime(MT7)){
			$.messager.alert("��ʾ:","����ȡ���ƴ�ʩʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
			return false;	
		}
		Str7="��ȡ���ƴ�ʩʱ��:"+MT7+"��";
	}
	if (MT8!==""){
		Str8="��ȡ���ƴ�ʩ:"+MT8+"��";
	}
	if (MT9!==""){
		if(!compareSelTimeAndCurTime(MT9)){
			$.messager.alert("��ʾ:","�������¼���תʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
			return false;	
		}
		Str9="�����¼���תʱ��:"+MT9+"��";
	}
	if (MT10!==""){
		Str10="��е����ʹ�����:"+MT10+"��";
	}
	if (MT11!==""){
		Str11="�¼�����ҽԺ:"+MT11+"��";
	}
	var EventDesc=EventDesc+Str1+Str2+Str3+Str4+Str5+Str6+Str7+Str8+Str9+Str10+Str11;
	$('#matadrEventDesc').val(EventDesc);
	$('#MouldTable').window('close');
}
//Ѫ������
function BloodCheck()
{
	$('body').append('<div id="BloodCheck"><table id="BClist"></table></div>');
		$('#BloodCheck').window({
		title:'Ѫ������',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#BloodCheck').window('open');
	BloodCheckPanel();
}
function BloodCheckPanel()
{
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BClist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BClist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
	
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'����',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'��������',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'��������',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'��λ',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'���',width:150,align:'center',editor:typeEditor,hidden:true}
		
	]];
	//����datagrid
	$('#BClist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		toolbar: [{
			text:'����',
			iconCls: 'icon-save',
			handler: function(){
				SaveBloodCheck();
			}
		},{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				BloodCheckOK();
			}
		},{
			text:'ȡ��',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#BloodCheck').window('close');
			}
		}],
		onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	$("#BClist").datagrid('endEdit', editRow);
			}
            $("#BClist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#BClist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"Ѫ����"}
	});
}
//�����޸�����
function SaveBloodCheck(){
	if(editRow>="0"){
		$("#BClist").datagrid('endEdit', editRow);
	}
	var rows = $("#BClist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������Ʋ���Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	}  
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
			$('#BClist').datagrid('reload'); //���¼���
	});
	
}
//ȷ�ϣ�����������д����Ӧ���ı�����
function BloodCheckOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#BClist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#BClist').datagrid('getRowIndex',data); 
		$('#BClist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"��";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#BloodCheck').window('close');
}		

//�����ܼ��
function RenalCheck()
{
	$('body').append('<div id="RenalCheck"><table id="RClist"></table></div>');
	$('#RenalCheck').window({
		title:'�����ܼ��',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#RenalCheck').window('open');
	RenalCheckPanel();
}
function RenalCheckPanel()
{
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#RClist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#RClist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'����',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'��������',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'��������',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'��λ',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'���',width:150,align:'center',editor:typeEditor,hidden:true}
		
	]];
	//����datagrid
	$('#RClist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		toolbar: [{
			text:'����',
			iconCls: 'icon-save',
			handler: function(){
				SaveRenalCheck();
			}
		},{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				RenalCheckOK();
			}
		},{
			text:'ȡ��',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#RenalCheck').window('close')
			}
		}],
		onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	$("#RClist").datagrid('endEdit', editRow);
			}
            $("#RClist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#RClist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"������"}
	});
}
//�����޸�����
function SaveRenalCheck(){
	if(editRow>="0"){
		$("#RClist").datagrid('endEdit', editRow);
	}
	var rows = $("#RClist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������Ʋ���Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	}  
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#RClist').datagrid('reload'); //���¼���
	});
	
}
//ȷ�ϣ�����������д����Ӧ���ı�����
function RenalCheckOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#RClist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#RClist').datagrid('getRowIndex',data); 
		$('#RClist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"��";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#RenalCheck').window('close');
}		
//Ѫ֬����ģ�� BloodLipid
function BloodLipid()
{
	$('body').append('<div id="BloodLipid"><table id="BLlist"></table></div>');
	$('#BloodLipid').window({
		title:'Ѫ֬����',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#BloodLipid').window('open');
	BloodLipidPanel();
}
function BloodLipidPanel()
{
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BLlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BLlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'����',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'��������',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'��������',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'��λ',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'���',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//����datagrid
	$('#BLlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		toolbar: [{
			text:'����',
			iconCls: 'icon-save',
			handler: function(){
				SaveBloodLipid();
			}
		},{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				BloodLipidOK();
			}
		},{
			text:'ȡ��',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#BloodLipid').window('close');
			}
		}],		
		onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	$("#BLlist").datagrid('endEdit', editRow); 
			}
            $("#BLlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#BLlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"Ѫ֬����"}
	});
}
//�����޸�����
function SaveBloodLipid(){
	if(editRow>="0"){
		$("#BLlist").datagrid('endEdit', editRow);
	}
	var rows = $("#BLlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������Ʋ���Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#BLlist').datagrid('reload'); //���¼���
	});
}
//ȷ�ϣ�����������д����Ӧ���ı�����
function BloodLipidOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#BLlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#BLlist').datagrid('getRowIndex',data); 
		$('#BLlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"��";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#BloodLipid').window('close');
}
//��������  VitalSigns
function VitalSigns()
{
	$('body').append('<div id="VitalSigns"><table id="VSlist"></table></div>');
	$('#VitalSigns').window({
		title:'��������',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#VitalSigns').window('open');
	VitalSignsPanel();
}
function VitalSignsPanel()
{
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#VSlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#VSlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'����',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'��������',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'��������',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'��λ',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'���',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//����datagrid
	$('#VSlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		toolbar: [{
			text:'����',
			iconCls: 'icon-save',
			handler: function(){
				SaveVitalSigns();
			}
		},{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				VitalSignsOK();
			}
		},{
			text:'ȡ��',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#VitalSigns').window('close');
			}
		}],
		onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	$("#VSlist").datagrid('endEdit', editRow); 
			}
            $("#VSlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#VSlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"��������"}
	});
}
//�����޸�����
function SaveVitalSigns(){
	if(editRow>="0"){
		$("#VSlist").datagrid('endEdit', editRow);
	}
	var rows = $("#VSlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������Ʋ���Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#VSlist').datagrid('reload'); //���¼���
	});
}
//ȷ�ϣ�����������д����Ӧ���ı�����
function VitalSignsOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#VSlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#VSlist').datagrid('getRowIndex',data); 
		$('#VSlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"��";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#VitalSigns').window('close');
}
//Ѫ��ģ��  BloodGas
function BloodGas()
{
	$('body').append('<div id="BloodGas"><table id="BGlist"></table></div>');
	$('#BloodGas').window({
		title:'Ѫ��ģ��',
		collapsible:false,
		border:false,
		resizable:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		width:500,
		height:360
	}); 
	$('#BloodGas').window('open');
	BloodGasPanel();
}
function BloodGasPanel()
{
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BGlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BGlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'����',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'��������',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'��������',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'��λ',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'���',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//����datagrid
	$('#BGlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		toolbar: [{
			text:'����',
			iconCls: 'icon-save',
			handler: function(){
				SaveBloodGas();
			}
		},{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				BloodGasOK();
			}
		},{
			text:'ȡ��',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#BloodGas').window('close');
			}
		}],
		onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	$("#BGlist").datagrid('endEdit', editRow); 
			}
            $("#BGlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#BGlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"Ѫ��"}
	});
}
//�����޸�����
function SaveBloodGas(){
	if(editRow>="0"){
		$("#BGlist").datagrid('endEdit', editRow);
	}
	var rows = $("#BGlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������Ʋ���Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#BGlist').datagrid('reload'); //���¼���
	});
}
//ȷ�ϣ�����������д����Ӧ���ı�����
function BloodGasOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#BGlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#BGlist').datagrid('getRowIndex',data); 
		$('#BGlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"��";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#BloodGas').window('close');
}
//�ι��� LiverFunction
function LiverFunction()
{
	$('body').append('<div id="LiverFunction"><table id="LFlist"></table></div>');
	$('#LiverFunction').window({
		title:'�ι���',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#LiverFunction').window('open');
	LiverFunctionPanel();
}
function LiverFunctionPanel()
{
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#LFlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#LFlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'����',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'��������',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'��������',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'��λ',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'���',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//����datagrid
	$('#LFlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		toolbar: [{
			text:'����',
			iconCls: 'icon-save',
			handler: function(){
				SaveLiverFunction();
			}
		},{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				LiverFunctionOK();
			}
		},{
			text:'ȡ��',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#LiverFunction').window('close');
			}
		}],
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
         	if ((editRow != "")||(editRow == "0")) {
            	$("#LFlist").datagrid('endEdit', editRow); 
			}
         	$("#LFlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#LFlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"�ι���"}
	});
}
//�����޸�����
function SaveLiverFunction()
{
	if(editRow>="0"){
		$("#LFlist").datagrid('endEdit', editRow);
	}
	var rows = $("#LFlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������Ʋ���Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#LFlist').datagrid('reload'); //���¼���
	});
}
//ȷ�ϣ�����������д����Ӧ���ı�����
function LiverFunctionOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#LFlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#LFlist').datagrid('getRowIndex',data); 
		$('#LFlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"��";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#LiverFunction').window('close');
}
//�滻������� 2015-10-25 congyue
function trSpecialSymbol(str)
{
	if(str.indexOf("%")){
		var str=str.replace("%","%25");
	}
	if(str.indexOf("&")){
		var str=str.replace("&","%26");
	}
	if(str.indexOf("+")){
		var str=str.replace("+","%2B");
	}
	return str;
}
//���ر�����Ϣ
function InitMataReport(matadrID)
{
	if(matadrID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	var matadrDataList="";
	winflag=1; //2016-10-10
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getMataRepInfo&matadrID="+matadrID+"&params="+params,
       //dataType: "json",
       success: function(val){
	      	 matadrDataList=val;
	      	    var tmp=matadrDataList.split("!");
				$('#matadrID').val(tmp[0]);    //����ID
				$('#matadrCreateDate').datetimebox({disabled:true});
				$('#matadrCreateDate').datetimebox("setValue",tmp[43]+" "+tmp[44]);   //��������
				$('#matadrNo').val(tmp[1]);    //�������
				$('#matadrNo').attr("disabled","true");
				//������Ϣ
				$('#PatSex').combobox('setValue',tmp[2]);     //�Ա�
				$('#PatAge').val(tmp[3]);    //����
				$('#PatName').val(tmp[4]);    //��������
				$('#PatNo').val(tmp[5]);    //���˵ǼǺ�
				$('#PatNo').attr("disabled","true");  ///2017-07-20 bianshuai ���ò���ID���ɱ༭
				$('#matadrExpectEff').val(tmp[6]);    //Ԥ�����Ƽ���������
				if(tmp[7]!=""||tmp[8]!=""){
					$('#matadrAdmDate').datetimebox("setValue",tmp[7]+" "+tmp[8]);   //��������				
				}				
				$('#matadrMainExp').val(tmp[9]);    //�¼���Ҫ����
				$('#matadrAdrDate').datebox("setValue",tmp[10]);   //�¼���������
				$('#matadrDiscDate').datebox("setValue",tmp[11]);   //���ֻ���֪Ϥʱ��
				//ҽ����еʵ��ʹ�ó���
				$('#UP'+tmp[12]).attr("checked",true);
				$('#matadrUsePlaceOth').val(tmp[13]);
				if(tmp[12]=="99"){
					$('#matadrUsePlaceOth').attr("disabled",false);
				}
				//�¼����
				$('#TR'+tmp[14]).attr("checked",true);
				$('#matadrEventResultDate').datetimebox("setValue",tmp[15]+" "+tmp[16]);
				var deathdatetime=tmp[14];
				if(deathdatetime==10){
					var matadrEventResultDate=document.getElementById("deathdate");
					matadrEventResultDate.style.display='inline';
		
				}
				
				$('#matadrEventDesc').val(tmp[17]);    //�¼�����
				//C.ҽ����е���
				$('#matadrProName').val(tmp[18]);    //��Ʒ����
				$('#matadrInciName').val(tmp[19]);    //��Ʒ����
				$('#matadrRegNo').val(tmp[20]);    //ע��֤��
				$('#matadrManf').val(tmp[21]);    //������ҵ����
				$('#matadrManfAddress').val(tmp[22]);    //������ҵ��ַ
				$('#matadrManfTel').val(tmp[23]);    //��ҵ��ϵ�绰
				$('#matadrSpec').val(tmp[24]);    //�ͺŹ��
				$('#matadrProCode').val(tmp[25]);    //��Ʒ���
				$('#matadrProBatNo').val(tmp[26]);    //��Ʒ����
				//������
				$('#OP'+tmp[27]).attr("checked",true);
				$('#matadrOperatorOth').val(tmp[28]);
				if(tmp[27]=="99"){
					$('#matadrOperatorOth').attr("disabled",false);
				}
				$('#matadrExpDate').datebox("setValue",tmp[29]);   //��Ч����
				$('#matadrProDate').datebox("setValue",tmp[30]);   //��������
				$('#matadrDisDate').datebox("setValue",tmp[31]);   //ͣ������
				$('#matadrUseDate').datebox("setValue",tmp[32]);   //ֲ������(��ֲ��)
				$('#matadrReasonDesc').val(tmp[33]);    //�¼���������ԭ���
				$('#matadrHandInfo').val(tmp[34]);    //�¼������������
				//�¼�����״̬
				$('#HS'+tmp[35]).attr("checked",true);				
				//D. �����¼�����
				$('#matadrProAdvice').val(tmp[36]);    //ʡ����⼼�������������
				$('#matadrCountryAdvice').val(tmp[37]);    //���Ҽ�⼼�������������
				//������ְ��
				$('#CP'+tmp[38]).attr("checked",true);
				$('#matadrRepNameID').val(tmp[39]);    //������
				$('#matadrRepName').val(tmp[48]);    //������
				$('#matadrRepName').attr("disabled","true");
				$('#matadrRepLocID').val(tmp[40]);    //�����˿���
				$('#matadrRepLocDr').val(tmp[47]);    //�����˿���
				$('#matadrRepLocDr').attr("disabled","true");
				$('#matadrRepTel').val(tmp[41]);    //��������ϵ�绰
				$('#matadrRepEmail').val(tmp[42]);    //����������
				mataReportType=tmp[49];
				medadrNextLoc=tmp[50]
				medadrLocAdvice=tmp[51]
				medadrReceive=tmp[52];
				ImpFlag=tmp[53]; //��Ҫ���
				EpisodeID=tmp[54]; //����ID
				MatadrInitStatDR=tmp[45];
				//editFlag״̬Ϊ0,�ύ���ݴ水ť������
				matadrCurStatusDR=tmp[46];
				if (matadrCurStatusDR=="")
				{
					matadrCurStatusDR=matadrCurStatusDR;
					medadrReceive="";
				}
				else
				{
					MatadrInitStatDR=tmp[46];
					//medadrReceive="1";
					if(((UserDr==LgUserID)&&(medadrReceive=="2"))||(UserDr!=LgUserID)){
						medadrReceive="1";
					}
				}
				//2017-06-12 �����������������޸�
				if(assessID!=""){
					$("#savebt").hide();
					$("#submitdiv").hide();
				}
				if (tmp[46]!=""){  //������ύ״̬
					$('#submitdiv').hide();//�����ύ��ť
					//��ȡ����Ȩ�ޱ�־ 2016-10-19
					var Assessflag=GetAssessAuthority(matadrID,params);
					if (Assessflag=="Y"){
						$('#assessment').show(); //��ʾ������ť 
					}
				}
				
				// �Ƿ���к������Ⱥ�˳��
				$('#IRO'+tmp[55]).attr("checked",true);
				// �Ƿ�������ʹ��ҽ����е���ܵ��µ��˺�����
				$('#IDT'+tmp[56]).attr("checked",true);
				// �Ƿ�����úϲ���ҩ�����á����߲����������ҽ����е����������
				$('#IR'+tmp[57]).attr("checked",true);
				// ���������۽��
				$('#RE'+tmp[58]).attr("checked",true);

				$('#clearbt').hide();//������հ�ť	
     },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });   
}
//���ر���Ĭ����Ϣ
function InitPatientInfo(matadrID,adrDataList)
{
   if(matadrID!=""){return;}
   if(adrDataList==""){
   		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   }
   //var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMataInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			$.messager.alert("��ʾ:","�������ù�������Ȩ��,Ȼ�����");
			return;
		}else{
			var tmp=val.split("^");
			$('#matadrCreateDate').datetimebox({disabled:true});
			$('#matadrCreateDate').datetimebox("setValue",tmp[0]);   //��������
			MatadrInitStatDR=tmp[1];  //�����ĳ�ʼ��,״̬ 
			mataReportType=tmp[2];
			//$('#matadrNo').val(tmp[3]);                //�������
			$('#matadrNo').attr("disabled","true");
			$('#matadrRepNameID').val(tmp[4]);	//������id
			$('#matadrRepName').val(tmp[5]);    //������
			$('#matadrRepName').attr("disabled","true");
			$('#matadrRepLocID').val(tmp[6]);    //�����˿���id
			$('#matadrRepLocDr').val(tmp[7]);    //�����˿���
			$('#matadrRepLocDr').attr("disabled","true");
		}
   }})
}
//��ȡ������Ϣ
function getMataRepPatInfo(patientID,EpisodeID){
	//var matadrPatNo=$('#PatNo').val();
	//var matadrPatNo=getRegNo(matadrPatNo);
	if(patientID==""||EpisodeID==""){return;}
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       //dataType: "json",
       success: function(val){
	       
	    var mataRepPatInfo=val;
	    var tmp=mataRepPatInfo.split("^");
	      
		$('#PatNo').val(tmp[0]); //�ǼǺ�
		$('#PatName').val(tmp[1]); //�������� 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //�Ա�
		$('#PatAge').val(tmp[4]);  //����
		$('#PatAge').attr("disabled","true");
		if ((tmp[8]!="")&(tmp[9]!="")){
			$('#matadrAdmDate').datetimebox({disabled:true}); //��������    wangxuejian 2016-10-08 
		}
		$('#matadrAdmDate').datetimebox("setValue",tmp[8]+" "+tmp[9]);   //��������
		patIDlog=$('#PatNo').val();
       }
    })

	
}
//δ����Ĭ��Ϊ��
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}
//����ǰ,������������Լ��
function saveBeforeCheck()
{
	//1����������
	var matadrCreateDate=$('#matadrCreateDate').datetimebox('getValue');
	if(matadrCreateDate==""){
		$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
		return false;
	}
	var matadrCreateDateResult=matadrCreateDate.split(" ")[0];
	if(!compareSelTimeAndCurTime(matadrCreateDateResult)){
		$.messager.alert("��ʾ:","������ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}
	
	//2���������
	var matadrNo=$('#matadrNo').val();
	/* if(matadrNo==""){
		$.messager.alert("��ʾ:","��������롿����Ϊ�գ�");
		return false;
	} */
	matadrNo=matadrNo.replace(/[ ]/g,""); //ȥ�������еĿո�
	//���˵ǼǺ�
	var matadrPatNo=$('#PatNo').val();
	if(matadrPatNo==""){
		$.messager.alert("��ʾ:","�����˵ǼǺš�����Ϊ�գ�");
		return false;
	}
	//��������
	var matadrName=$('#PatName').val();
	if(matadrName==""){
		$.messager.alert("��ʾ:","����������������Ϊ�գ�");
		return false;
	}
    //�����Ա�
	var matadrSex=$('#PatSex').combobox('getValue');
	if(matadrSex==""){
		$.messager.alert("��ʾ:","�������Ա𡿲���Ϊ�գ�");
		return false;
	}
    //��������
	var matadrAge=$('#PatAge').val();  
	if(matadrAge==""){
		$.messager.alert("��ʾ:","���������䡿����Ϊ�գ�");
		return false;
	}
	//Ԥ�����Ƽ���������
	var matadrExpectEff=$('#matadrExpectEff').val();  
	if(matadrExpectEff==""){
		$.messager.alert("��ʾ:","��Ԥ�����Ƽ��������á�����Ϊ�գ�");
		return false;
	}
	//��������
	var matadrAdmDate=$('#matadrAdmDate').datetimebox('getValue');   
	if(matadrAdmDate==""){
		$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
		return false;
	}
	var matadrAdmDateResult=matadrAdmDate.split(" ")[0];
	if(!compareSelTimeAndCurTime(matadrAdmDateResult)){
		$.messager.alert("��ʾ:","���������ڡ����ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	
	//�¼���Ҫ����
	var matadrMainExp=$('#matadrMainExp').val();  
	if(matadrMainExp==""){
		$.messager.alert("��ʾ:","���¼���Ҫ���֡�����Ϊ�գ�");
		return false;
	}	
	//3.�¼���������
	var matadrAdrDate=$('#matadrAdrDate').datebox('getValue');   
	if(matadrAdrDate==""){
		$.messager.alert("��ʾ:","���¼��������ڡ�����Ϊ�գ�");
		return false;
	}
	if(!compareSelTimeAndCurTime(matadrAdrDate)){
		$.messager.alert("��ʾ:","���¼��������ڡ����ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	
	//4.���ֻ���֪Ϥʱ��
	var matadrDiscDate=$('#matadrDiscDate').datebox('getValue');   
	if(matadrDiscDate==""){
		$.messager.alert("��ʾ:","�����ֻ���֪Ϥʱ�䡿����Ϊ�գ�");
		return false;
	}
	if(!compareSelTimeAndCurTime(matadrDiscDate)){
		$.messager.alert("��ʾ:","�����ֻ���֪Ϥʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	//5.ҽ����еʵ��ʹ�ó���
	var matadrUsePlace="";
	var matadrUsePlaceOth="";
    $("input[type=checkbox][name=matadrUsePlace]").each(function(){
		if($(this).is(':checked')){
			matadrUsePlace=this.value;
		}
	})
	matadrUsePlaceOth=$('#matadrUsePlaceOth').val();
	if(matadrUsePlace==""){
		$.messager.alert("��ʾ:","��ҽ����еʵ��ʹ�ó���������Ϊ�գ�");
		return false;
	}
	//6.�¼����
	var matadrResult="";
	var matadrDeathDate="",matadrDeathTime="";
     $("input[type=checkbox][name=matadrResult]").each(function(){
		if($(this).is(':checked')){
			matadrResult=this.value;
		}
	})
	if(matadrResult==""){
		$.messager.alert("��ʾ:","���¼����������Ϊ�գ�");
		return false;
	}
	if(matadrResult=="10"){
		var matadrEventResultDate=$('#matadrEventResultDate').datetimebox('getValue'); 
		if(matadrEventResultDate==""){
			$.messager.alert("��ʾ:","�¼����Ϊ��������,����д����ʱ�䣡");
			return false;
		}else{
		matadrDeathDate=matadrEventResultDate.split(" ")[0];  //��������
		matadrDeathTime=matadrEventResultDate.split(" ")[1];  //����ʱ��
	}
	
	if(!compareSelTimeAndCurTime(matadrDeathDate)){
		$.messager.alert("��ʾ:","�¼����Ϊ���������ġ�����ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	}	
	//7.�¼�����
	var matadrEventDesc=$('#matadrEventDesc').val();
	if(matadrEventDesc==""){
		$.messager.alert("��ʾ:","���¼�����������Ϊ�գ�");
		return false;
	}
	//������
	if($('#matadrRepName').val()==""){
		$.messager.alert("��ʾ:","�������ˡ�����Ϊ�գ�");
		return false;
	}
    
	//�����˿���	
	if($('#matadrRepLocDr').val()==""){
		$.messager.alert("��ʾ:","�������˿��ҡ�����Ϊ�գ�");
		return false;
	}
	//��Ʒ����    wangxuejian 2016-10-08
	if($('#matadrProName').val()==""){
		$.messager.alert("��ʾ:","����Ʒ���ơ�����Ϊ�գ�");
		return false;
	}
	if((LgGroupDesc.indexOf("����")>=0)||(LgGroupDesc.indexOf("�̶��ʲ�")>=0)||(LgCtLocDesc.indexOf("����")>=0)||(LgCtLocDesc.indexOf("��е")>=0)||(LgCtLocDesc.indexOf("�豸")>=0)){  //���Ĵ���ҽ���豸�ƣ�������
		//ע��֤��    wangxuejian 2016-10-08
		if($('#matadrRegNo').val()==""){
			$.messager.alert("��ʾ:","��ע��֤�š�����Ϊ�գ�");
			return false;
		}
		//������ҵ����    wangxuejian 2016-10-08
		if($('#matadrManf').val()==""){
			$.messager.alert("��ʾ:","��������ҵ���ơ�����Ϊ�գ�");
			return false;
		}
		//��ҵ��ϵ�绰    wangxuejian 2016-10-08
		if($('#matadrManfTel').val()==""){
			$.messager.alert("��ʾ:","����ҵ��ϵ�绰������Ϊ�գ�");
			return false;
		}
		//�¼������������    wangxuejian 2016-10-08
		if($('#matadrHandInfo').val()==""){
			$.messager.alert("��ʾ:","���¼������������������Ϊ�գ�");
			return false;
		}
	}
	//��������
	var matadrProDate=$('#matadrProDate').datebox('getValue');   
	if(!compareSelTimeAndCurTime(matadrProDate)){
		$.messager.alert("��ʾ:","���������ڡ����ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}
	
	//��Ч����
	var matadrExpDate=$('#matadrExpDate').datebox('getValue');
	
	if(matadrExpDate==""){
		
	}else if(!compareSelTowTime(matadrProDate,matadrExpDate)){
		$.messager.alert("��ʾ:","���������ڡ����ܴ��ڡ���Ч���ڡ���")
		return false;
	}
	
	//ֲ������(��ֲ��)
	var matadrUseDate=$('#matadrUseDate').datebox('getValue');   
	if(!compareSelTimeAndCurTime(matadrUseDate)){
		$.messager.alert("��ʾ:","��ֲ�����ڡ����ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}else if(matadrUseDate=="")
	{

	} else if(!compareSelTowTime(matadrProDate,matadrUseDate)){
		$.messager.alert("��ʾ:","���������ڡ����ܴ��ڡ�ֲ�����ڡ���")
		return false;
	}
	
	//ͣ������
	var matadrDisDate=$('#matadrDisDate').datebox('getValue');
	if(matadrUseDate==""||matadrDisDate==""){
			
	}else if(!compareSelTowTime(matadrUseDate,matadrDisDate)){
		$.messager.alert("��ʾ:","��ֲ�����ڡ����ܴ��ڡ�ͣ�����ڡ���");
		return false;	
	}
	else if(!compareSelTowTime(matadrProDate,matadrDisDate)){
		$.messager.alert("��ʾ:","���������ڡ����ܴ��ڡ�ͣ�����ڡ���")
		return false;
	}
	
	var MT1=$('#MT1').datebox('getValue');  
	if(!compareSelTimeAndCurTime(MT1)){
		$.messager.alert("��ʾ:","���¼��������С���еʹ��ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	var MT7=$('#MT7').datebox('getValue');
	if(!compareSelTimeAndCurTime(MT7)){
		$.messager.alert("��ʾ:","���¼��������С���ȡ���ƴ�ʩʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	var MT9=$('#MT9').datebox('getValue');
	if(!compareSelTimeAndCurTime(MT9)){
		$.messager.alert("��ʾ:","���¼��������С������¼���תʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	// ʹ��ҽ����е���ѷ���/���ܷ������˺��¼�֮���Ƿ���к������Ⱥ�˳��
	var matadrIfReaOrder="";
    $("input[type=checkbox][name=matadrIfReaOrder]").each(function(){
		if($(this).is(':checked')){
			matadrIfReaOrder=this.value;
		}
	})
	if(matadrIfReaOrder==""){
		$.messager.alert("��ʾ:","��ʹ��ҽ����е���ѷ���/���ܷ������˺��¼�֮���Ƿ���к������Ⱥ�˳�򡿲���Ϊ�գ�");
		return false;
	}
	// ����/���ܷ������˺��¼��Ƿ�������ʹ��ҽ����е���ܵ��µ��˺�����
	var matadrIfDamageType="";
    $("input[type=checkbox][name=matadrIfDamageType]").each(function(){
		if($(this).is(':checked')){
			matadrIfDamageType=this.value;
		}
	})
	if(matadrIfDamageType==""){
		$.messager.alert("��ʾ:","������/���ܷ������˺��¼��Ƿ�������ʹ��ҽ����е���ܵ��µ��˺����͡�����Ϊ�գ�");
		return false;
	}
	// �ѷ���/���ܷ������˺��¼��Ƿ�����úϲ���ҩ�����á����߲����������ҽ����е����������
	var matadrIfReasonable="";
    $("input[type=checkbox][name=matadrIfReasonable]").each(function(){
		if($(this).is(':checked')){
			matadrIfReasonable=this.value;
		}
	})
	if(matadrIfReasonable==""){
		$.messager.alert("��ʾ:","���ѷ���/���ܷ������˺��¼��Ƿ�����úϲ���ҩ�����á����߲����������ҽ����е���������͡�����Ϊ�գ�");
		return false;
	}
	
		
	return true;
}

//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///ҽ����еʵ��ʹ�ó���
		if(id=="UP99"){
			$('#matadrUsePlaceOth').attr("disabled",false);
		}		
		///�¼����
		if(id=="TR10"){
			//$('#matadrEventResult').attr("disabled",false);
			$('#matadrEventResultDate').datetimebox({disabled:false});
		}
	    ///������
		if(id=="OP99"){
			$('#matadrOperatorOth').attr("disabled",false);
		}    
	}else{
		///ȡ��ҽ����еʵ��ʹ�ó���
		if(id=="UP99"){
			$('#matadrUsePlaceOth').val("");
			$('#matadrUsePlaceOth').attr("disabled","true");
		}
		///ȡ���¼����
		if(id=="TR10"){
			//$('#matadrEventResult').val("");
			//$('#matadrEventResult').attr("disabled","true")
			$('#matadrEventResultDate').datetimebox('setValue',"");

		}	
	    ///������
		if(id=="OP99"){
			$('#matadrOperatorOth').val("");
			$('#matadrOperatorOth').attr("disabled","true");
		}    
	}
}
//��.js������function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	var matadrPatNo=$('#PatNo').val();
	var matadrPatNo=getRegNo(matadrPatNo);

	getMataRepPatInfo(matadrPatNo,EpisodeID);
}
//�༭����  zhaowuqiang  2016-09-22
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
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+matadrID+'&RepType='+mataReportType+'"></iframe>';
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
//�жϱ�������Ƿ����
function RepNoRepet(){
	var IDflag=0;
	if (matadrID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //��������Ԫ�ظ�ֵ
	/* //�������
	var matadrNo=$('#matadrNo').val();
	matadrNo=matadrNo.replace(/[ ]/g,""); //ȥ�������еĿո�
	$.ajax({
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=SeaMataRepNo&matadrNo="+matadrNo,
		async: false, //ͬ��
		success: function(data){
			$('#repnoflag',window.parent.document).val(data); //��������Ԫ�ظ�ֵ
		}
	}); */
}
//ˢ�½��� 2016-09-26
function ReloadJs(){
	if ((adrDataList!="")||(frmflag==1)){
		frmflag=1;
	}else{
		frmflag=2;
	}
	window.location.href="dhcadv.matareport.csp?adrDataList="+""+"&frmflag="+frmflag;//ˢ�´���adrDataListΪ��
}