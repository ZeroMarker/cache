/// Description: ҩƷ�������浥
/// Creator: yuliping
/// CreateDate: 2018-07-17
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����

$(document).ready(function(){
	InitCheckRadio();
	InitButton(); 				// �󶨱����ύ��ť ��ҽ
    ReportControl()  			//������
    InitReport(recordId) 	//��ʼ������
	
})
// �󶨱����ύ��ť
function InitButton(){
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})

}
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();
}

function InitCheckRadio(){
	//�¼��ּ�
	$("input[type=checkbox][id^='drugreportlevel']").click(function(){
		var id=this.id;
		$("input[type=checkbox][id^='drugreportlevel']").each(function(){
			if((this.id!=id)&($('#'+this.id).is(':checked'))){
				$('#'+this.id).removeAttr("checked");
				$("#"+this.id).nextAll(".lable-input").hide()
			}
		})
	})
	
	//�Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ��������
	$("input[type=checkbox][id^='cancopyinfoma']").click(function(){
		var id=this.id;
		$("input[type=checkbox][id^='cancopyinfoma']").each(function(){
			if((this.id!=id)&($('#'+this.id).is(':checked'))){
				$('#'+this.id).removeAttr("checked");
				$("#"+this.id).nextAll(".lable-input").hide()
			}
		})
	})
	//����ʱ��
	if($('#admheartlevel-94645').is(':checked')){
		var deathdate=$('#admheartlevel-94646').datebox("getValue");
		$('#admheartlevel-94646').datebox({disabled:false});
		$('#admheartlevel-94646').datebox("setValue",deathdate);
		$("input[type=checkbox][id^='admheartlevel-94652-']").removeAttr("checked");
		$("input[type=checkbox][id^='admheartlevel-94652-']").attr("disabled",true);
	}else{
		$('#admheartlevel-94646').datebox({disabled:'true'});
		$('#admheartlevel-94646').datebox("setValue","");
		$("input[type=checkbox][id^='admheartlevel-94652-']").attr("disabled",false) ;
	}
	//�����˺����
	$("input[type=checkbox][id^='admheartlevel']").click(function(){
		var id=this.id;
		if(id.split("-").length==2){
			$("input[type=checkbox][id^='admheartlevel']").each(function(){
				if((this.id!=id)&($('#'+this.id).is(':checked'))&&(this.id.split("-").length==2)){
					$('#'+this.id).removeAttr("checked");
					$("#"+this.id).nextAll(".lable-input").hide();
				}
			})
		}
		if(id.split("-").length==3){
			$("input[type=checkbox][id^='admheartlevel']").each(function(){
				if((this.id!=id)&($('#'+this.id).is(':checked'))&&(this.id.split("-").length==3)){
					$('#'+this.id).removeAttr("checked");
					$("#"+this.id).nextAll(".lable-input").hide();
				}
			})
		}
	})
}
function showDrugList(id){
	if(EpisodeID==""){
	   $.messager.alert('Warning',$g('����ѡ���߾����¼��'));
	   return;
	}
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:$g('����'),width:140},
		{field:'genenic',title:$g('ͨ����'),width:140},
	    {field:'batno',title:$g('��������'),width:60,hidden:true}, //,hidden:true
	    {field:'staDate',title:$g('��ʼ����'),width:60,hidden:true},//,hidden:true
	    {field:'endDate',title:$g('��������'),width:60,hidden:true},  //
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('����'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('�÷�'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('Ƶ��'),width:40},//priorty
		{field:'priorty',title:$g('���ȼ�'),width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('�Ƴ�'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:$g('��׼�ĺ�'),width:140},
		{field:'manf',title:$g('����'),width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:$g('����'),width:80},
		{field:'spec',title:$g('���'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'vendor',title:$g('��Ӧ��'),width:80},
		{field:'OrderPackQty',title:$g('����'),width:80}
		
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo'+'&params='+EpisodeID ,
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#admdsgridnew', //grid ID
		field:'Adm', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null, //�Ϲ�����,��Ϊnull
	}
	var rownum=id.split(".")[1];
	var win=new CreatMyDiv(input,$("input[id^='quadruglist-'][id$='."+rownum+"']"),"drugsfollower","1000px","335px","admdsgridnew",mycols,mydgs,"","",addDrgTest);	
	win.init();	
}

//���ҩƷ
function addDrgTest(rowData)
{   
     var row = rowData;
    if(row==""){
	    return;
	    }
      var $td =$("input[name='"+drugname+"'][type=input]").parent().parent().children('td');
	if(checkSusAndBleIfRepApp(row.incidesc)){
		$td.eq(0).find("input").val(row.genenic);  // ͨ����
		$td.eq(1).find("input").val(row.vendor); // ��Ӧ��
		$td.eq(2).find("input").val(row.manf); // ���� ������ҵ
		$td.eq(3).find("input").val(row.apprdocu);  // ����  ��׼�ĺ�
		$td.eq(4).find("input").val(row.OrderPackQty);  // ����
		$td.eq(5).find("input").val(row.form); // ����
		$td.eq(6).find("input").val(row.spec); // ���
		$td.eq(7).find("input").val(row.PackUOMDesc); // ��װ����
		$td.eq(8).find("input").val(row.incidesc); // ��Ʒ����
		//TableControl();
		
		/// 2021-02-09 cy �����ҽ��id
		if(OrdList!=""){ 
			OrdList=OrdList+"$$"+row.orditm+"&&"+drugname;
		}
		if(OrdList==""){
			OrdList=row.orditm+"&&"+drugname;
		}
	}
  
}
function checkSusAndBleIfRepApp(incidesc){
	var flag=0
	$("#quadruglist").next().find("tbody tr").each(function(i){  // ҩƷ�б�
		//ҽ��id
		var tdincidesc=$(this).children('td').eq(8).find("input").val()
		if(tdincidesc==incidesc){
			flag=1;
		}
	})
	if(flag!=0){
		$.messager.alert($g("��ʾ:"),$g("��ҩƷ�����,�����ظ���ӣ�"));
		return false;
	}
	return true;
}

function ReportControl(){
	$("input[id^='quadruglist-']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   drugname=$(this).attr("name")
           showDrugList(this.id);
        }
    });
    //��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//����ʱ��
	chkdate("admheartlevel-94646")
}
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!checkRequired()){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}	
	SaveReportCom(flag);
}
//���ر�����Ϣ
function InitReport(recordId){
	
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');			
	} 				
}
//���table�еı���
//�����д�˳���ߣ��������Ϣ��Ϊ���������ζ
function checkTableRequired(){
	var errMsg=""
	
	$("#quadruglist").next().find("tbody tr").each(function(i){
		var rowMsg=""
		// ��Ʒ����
		var str=$(this).children('td').eq(0).find("input").val();
		if(str.length==0){
			rowMsg=rowMsg+"��Ʒ����,"
		}
		/*// ͨ����
		var str1=$(this).children('td').eq(1).find("input").val();
		if(str1.length==0){
			rowMsg=rowMsg+"ͨ����,"
		}
		 // ��Ӧ��
		var str2=$(this).children('td').eq(2).find("input").val();
		if(str2.length==0){
			rowMsg=rowMsg+"��Ӧ��,"
		}
		// ������ҵ
		var str3=$(this).children('td').eq(3).find("input").val()
		if(str3.length==0){
			rowMsg=rowMsg+"������ҵ,"
		}
		// ����
		var str4=$(this).children('td').eq(4).find("input").val()
		if(str4.length==0){
			rowMsg=rowMsg+"����,"
		} 
		// ����
		var str5=$(this).children('td').eq(5).find("input").val()
		if(str5.length==0){
			rowMsg=rowMsg+"����,"
		}
		// ����
		var str6=$(this).children('td').eq(6).find("input").val()
		if(str6.length==0){
			rowMsg=rowMsg+"����,"
		}
		// ���
		var str7=$(this).children('td').eq(7).find("input").val()
		if(str7.length==0){
			rowMsg=rowMsg+"���,"
		}
		// ��װ����
		var str8=$(this).children('td').eq(8).find("input").val()
		if(str8.length==0){
			rowMsg=rowMsg+"��װ����,"
		}*/
		
		if(rowMsg!=""){
			errMsg=errMsg+"\n"+rowMsg+"����Ϊ��."
		}	
	
	})
	if(errMsg!=""){
		//$("html,body").stop(true);$("html,body").animate({scrollTop: $("#quadruglist").offset().top}, 1000);
		$.messager.alert($g("��ʾ:"),errMsg);
	}
	return errMsg;
}
function add_event(){
	
}
