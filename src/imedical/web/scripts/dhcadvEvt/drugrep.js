/// Description:ҩƷ�����¼�
/// Creator:guoguomin
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
var EpisodeID="";
var drugid="";
var drugnamelist="";
$(function(){

	InitButton(); 			// �󶨱����ύ��ť ��ҽ
	ReportControl(); 		// ������    ��ҽ
	CheckTimeorNum();		//ʱ��У��
	InitCheckRadio();		//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	InitReport(recordId);  		//���ر�����Ϣ  ��ҽ
	
});

// �󶨱����ύ��ť
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}
//����
function SaveReport(flag){
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺ�/�����Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	}
	
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}

//������
function ReportControl(){
	
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	
	// ������Ӧ/�¼��Ľ��  �к���֢ ����
	$('#EventNewResult-label-97002-97013').live("keyup",function(){
		$("input[type=radio][id^='EventNewResult-label-']").removeAttr("checked");
		$("input[type=radio][id='EventNewResult-label-97002']").click();	
		$("#EventNewResult-label-97014-97016").datebox("setValue","");  //����ֵ����Ϊ��
		$("#EventNewResult-label-97014-97015").val("");  //����ֵ����Ϊ��
	})
	$("#EventNewResult-label-97014-97015").live("keyup",function(){
		var EventNewResultdate=$('#EventNewResult-label-97014-97016').datebox('getValue');
		$("input[type=radio][id^='EventNewResult-label-']").removeAttr("checked");
		$("input[type=radio][id='EventNewResult-label-97014']").click();	
		$("#EventNewResult-label-97002-97013").val("");  //����ֵ����Ϊ��
		$('#EventNewResult-label-97014-97016').datebox("setValue",EventNewResultdate);
	})
	$('#EventNewResult-label-97014-97016').datebox({
	    onChange: function(){
		    if($('#EventNewResult-label-97014-97016').datebox('getValue')!=""){
		    $("input[type=radio][id^='EventNewResult-label-']").removeAttr("checked");
			$("input[type=radio][id='EventNewResult-label-97014']").click();
			$("#EventNewResult-label-97002-97013").val("");  //����ֵ����Ϊ��
	    }}
	})
	 //����ҩƷ��ʼ���ڿ���
	if($("input[id^='SuspectNewDrug-96655']").length>0){
		$("input[id^='SuspectNewDrug-96655']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	//����ҩƷ�������ڿ���
	if($("input[id^='SuspectNewDrug-96656']").length>0){
		$("input[id^='SuspectNewDrug-96656']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	//����ҩƷ��ʼ���ڿ���
	if($("input[id^='BlendNewDrug-96681']").length>0){
		$("input[id^='BlendNewDrug-96681']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	//����ҩƷ�������ڿ���
	if($("input[id^='BlendNewDrug-96683']").length>0){
		$("input[id^='BlendNewDrug-96683']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	
	$("input[id^='SuspectNewDrug-96650']").live('keydown',function(event){	
	
		 if(event.keyCode == "13")    
		 {
		   drugname=$(this).attr("name");
		   drugid="SuspectNewDrug";
		  
           showDrugList(this.id,this.value);
        }
    });
    $("input[id^='BlendNewDrug-96675']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   drugname=$(this).attr("name");
		   drugid="BlendNewDrug"; 
           showDrugList(this.id,this.value);
        }
    });
   TableControl(); 
    
}
//���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');				
	} 
}

//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	$("input[type=radio][id^='EventNewResult-label-']").each(function(){
		if ($(this).is(':checked')){
			//�Ƿ����֢
			if(this.id!="EventNewResult-label-97002"){
				$("#EventNewResult-label-97002-97013").val("");  //����ֵ����Ϊ��
			}
			//����
			if((this.id!="EventNewResult-label-97014")){
				$("#EventNewResult-label-97014-97015").val("");  //����ֵ����Ϊ��	
				$("#EventNewResult-label-97014-97016").datebox("setValue","");  //����ֵ����Ϊ��
		        
			}
		}
	})
}

//����ҩƷ�б�
function showDrugList(id,inpdesc){
	if(EpisodeID==""){
		$.messager.alert($g("��ʾ:"),$g("����ѡ���߾����¼��"));
		return;
	}
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:$g('����'),width:140},
		{field:'genenic',title:$g('ͨ����'),width:140},
	    {field:'batno',title:'��������',width:60,hidden:true}, //,hidden:true
	    {field:'staDate',title:'��ʼ����',width:60,hidden:true},//,hidden:true
	    {field:'endDate',title:'��������',width:60,hidden:true},  //
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
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo'+'&params='+EpisodeID+'&inpdesc='+encodeURI(inpdesc) ,  //2021-01-26 ��������ҩƷ���ܣ�encodeURI() ������������
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#admdsgridnew', //grid ID
		field:'Adm', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null, //�Ϲ�����,��Ϊnull
	}
	var rownum=id.split(".")[1];
	var win=new CreatMyDiv(input,$("input[id^="+drugid+"-][id$='."+rownum+"']"),"drugsfollower","1000px","335px","admdsgridnew",mycols,mydgs,"","",addDrgTest);	
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
		$td.eq(0).find("input").val(row.apprdocu);
		$td.eq(1).find("input").val(row.incidesc);
		$td.eq(2).find("input").val(row.genenic+"/["+row.form+"]");
		$td.eq(3).find("input").val(row.manf); 
		$td.eq(4).find("input").val(row.batno); 
		$td.eq(5).find("input").val(row.dosage+"/"+row.instru+"/"+row.freq);
		$td.eq(6).find(".combo-value").val(row.staDate);
		$td.eq(6).find(".combo-text").val(row.staDate);
		$td.eq(7).find(".combo-value").val(row.endDate);
		$td.eq(7).find(".combo-text").val(row.endDate);
		TableControl();
		
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
	$("#SuspectNewDrug").next().find("tbody tr").each(function(i){//����ҩƷ
		//ҽ��id
		var tdincidesc=$(this).children('td').eq(1).find("input").val()
		if(tdincidesc==incidesc){
			flag=1;
		}
	})
	$("#BlendNewDrug").next().find("tbody tr").each(function(i){//����ҩƷ
		//ҽ��id
		var tdincidesc=$(this).children('td').eq(1).find("input").val()
		if(tdincidesc==incidesc){
			flag=2;
		}
	}) 
	if((drugid=="BlendNewDrug")&&(flag==1)){
		$.messager.alert($g("��ʾ:"),$g("��ҩƷ��Ϊ����ҩƷ,����ͬʱΪ����ҩƷ��"));
		return false;
	}
	if((drugid=="SuspectNewDrug")&&(flag==2)){
		$.messager.alert($g("��ʾ:"),$g("��ҩƷ��Ϊ����ҩƷ,����ͬʱΪ����ҩƷ��"));
		return false;
	}
	if(flag!=0){
		$.messager.alert($g("��ʾ:"),$g("��ҩƷ�����,�����ظ���ӣ�"));
		return false;
	}
	return true;
}
//ʱ�� ����У��
function CheckTimeorNum(){
	//ʱ������У��
		
}
function doOther(){
}
function add_event(){
	//����ҩƷ��ʼ���ڿ���
	$("input[id^='SuspectNewDrug-96655']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	//����ҩƷ�������ڿ���
	$("input[id^='SuspectNewDrug-96656']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	})
	//����ҩƷ��ʼ���ڿ���
	$("input[id^='BlendNewDrug-96681']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	})
	//����ҩƷ�������ڿ���
	$("input[id^='BlendNewDrug-96683']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	TableControl();
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	//������Ӧ/�¼��Ľ��
	var EventNewResultFlag=0;
	$("input[type=radio][id^='EventNewResult-label-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value==$g("�к���֢"))&&($("#EventNewResult-label-97002-97013").val()=="")){
				EventNewResultFlag=-1;
			}
			if ((this.value==$g("����"))&&(($("#EventNewResult-label-97014-97015").val()=="")||($("#EventNewResult-label-97014-97016").datebox('getValue')==""))){
				EventNewResultFlag=-2;
			}
		}
	})
	if(EventNewResultFlag==-1){
		$.messager.alert($g("��ʾ:"),$g("��������Ӧ/�¼��Ľ������ѡ'")+$g("�к���֢")+$g("'������д���֣�"));	
		return false;
	}
	if(EventNewResultFlag==-2){
		$.messager.alert($g("��ʾ:"),$g("��������Ӧ/�¼��Ľ������ѡ'")+$g("����")+$g("'������дֱ������������ʱ�䣡"));	
		return false;
	}
	
	///�жϻ���ҩƷ�Ͳ���ҩƷ����ͬʱΪ��
	if(!(getDgData("SuspectNewDrug"))&&(!getDgData("BlendNewDrug"))){
		if(MKIOrdFlag!="1"){
			$.messager.alert($g("��ʾ:"),$g("����ҩƷ")+"��"+$g("����ҩƷ")+"����ͬʱΪ�գ��б��ֶ�����ҩƷ��Ч����س�ѡ��ҽ������");
		}else{
			$.messager.alert($g("��ʾ:"),$g("����ҩƷ")+"��"+$g("����ҩƷ")+"����ͬʱΪ�գ��б�����ҩƷ��Ϣ�٣��貹����Ϣ����");
		}
		return false;
	}
	
	
	return true;
}
///ȡ�б�ǰ�������� sufan 2019-12-09
function getDgData(dgkey)
{
	var retval=true;
	$("#"+dgkey).next().find("tbody tr").each(function(i){
		var rowMsg=""
		// ��׼�ĺ�
		var str=$(this).children('td').eq(0).find("input").val();
		if(str.length==0){
			rowMsg=rowMsg+$g("��׼�ĺ�,")
		}
		// ��Ʒ����
		var str1=$(this).children('td').eq(1).find("input").val();
		if(str1.length==0){
			rowMsg=rowMsg+$g("��Ʒ����,")
		}
		// ͨ������
		var str2=$(this).children('td').eq(2).find("input").val();
		if(str2.length==0){
			rowMsg=rowMsg+$g("ͨ������,")
		}
		
		if(rowMsg!=""){
			retval=false;
			return false;
		}	
	
	})
	
	return retval;
}

function TableControl(){
	// ���� �Ƿ������ֹ�����ҽ�� ����
	    $("[id^='SuspectNewDrug-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="SuspectNewDrug-96650")&&(rowid!="SuspectNewDrug-96653")&&(rowid!="SuspectNewDrug-96657")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				/* if((rowid=="SuspectNewDrug-96655")||(rowid=="SuspectNewDrug-96656")){
					$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				} */
			}
		})
		$("[id^='BlendNewDrug-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="BlendNewDrug-96675")&&(rowid!="BlendNewDrug-96678")&&(rowid!="BlendNewDrug-96685")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				/* if((rowid=="BlendNewDrug-96681")||(rowid=="BlendNewDrug-96683")){
					$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				} */
			}
		})
		
}
function removeRow(obj){
	/// 2021-02-09 cy �����ҽ��id
	$.messager.confirm("��ʾ", "�Ƿ����ɾ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			var delname=$(obj).parent().parent().children('td').eq(1).find("input").attr("name");
			var tmpItmArr=[]
			if(OrdList!=""){
				var OrdListarr=OrdList.split("$$");
				for (var i=0;i<OrdListarr.length;i++)
				{
					if(OrdListarr[i].indexOf(delname)<0){
						tmpItmArr.push(OrdListarr[i]);
					}
				}
				OrdList=tmpItmArr.join("$$");
			}
			$(obj).parent().parent().remove()	
		}
	})
		
	
}
