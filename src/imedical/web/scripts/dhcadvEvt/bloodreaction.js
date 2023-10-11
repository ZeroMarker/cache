
/**
*Description:	��Ѫ������Ӧ���浥
*Creator: 	cy	
*CreDate: 	2021-07-15	
**/
var RepDate=formatDate(0);			// ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitButton();					// ��ʼ����ť
	ReportControl();				// ������ 
	InitCheckRadio(); 	
	InitReport(recordId);			// ����ҳ����Ϣ
	add_event();
})

function InitButton(){
	
	// ����
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})	
	
}

// ������
function ReportControl(){
	
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});

	// ��Ѫ������Ӧʱ�����
	chkdate("AdvBloodSereaOccTime");

	/* 2018-06-06 ��ɾ�����ӵ�table����*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-4px"})
	//��Ѫ��ʼ���ڿ���
	$("input[id^='BloodGiveList-97701-97708-97715']").datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//��Ѫ�������ڿ���
	$("input[id^='BloodGiveList-97701-97709-97716']").datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	///�в�ʷ����  sufan 2019-11-14
	// �� û�л��й���û��������
	$('input[id^="isPregnancy"][type="radio"]').click(function(){
		if($(this).val()=="��"){
			$('input[id^="isGive"][value="��"]').attr('checked','true');
		}
	})
	/// �� �����������й�
	$('input[id^="isGive"][type="radio"]').click(function(){
		if($(this).val()=="��"){
			$('input[id^="isPregnancy"][value="��"]').attr('checked','true');
		}
	})
	TableControl();
	/// ��Ѫ�����������仯��� �ⶨʱ�� cy 2021-07-15
	chktime("BRVitSigns-99969-99987-99988","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99970-100001-100009","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99971-100017-100025","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99972-100033-100041","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99973-100049-100057","AdvBloodSereaOccTime");	
	
	/// ��Ѫ�����������仯��� ���£��棩 cy 2021-07-15
	chknum("BRVitSigns-99969-99989-99990",1,34,43);
	chknum("BRVitSigns-99970-100002-100010",1,34,43);
	chknum("BRVitSigns-99971-100018-100026",1,34,43);
	chknum("BRVitSigns-99972-100034-100042",1,34,43);
	chknum("BRVitSigns-99973-100050-100058",1,34,43);
	
	/// ��Ѫ�����������仯��� ��������/�֣� cy 2021-07-15
	chknum("BRVitSigns-99969-99991-99992",0,10,50);
	chknum("BRVitSigns-99970-100003-100011",0,10,50);
	chknum("BRVitSigns-99971-100019-100027",0,10,50);
	chknum("BRVitSigns-99972-100035-100043",0,10,50);
	chknum("BRVitSigns-99973-100051-100059",0,10,50);
	/// ��Ѫ�����������仯��� ��������/�֣� cy 2021-07-15
	chknum("BRVitSigns-99969-99993-99996",0,50,180);
	chknum("BRVitSigns-99970-100004-100012",0,50,180);
	chknum("BRVitSigns-99971-100020-100028",0,50,180);
	chknum("BRVitSigns-99972-100036-100044",0,50,180);
	chknum("BRVitSigns-99973-100052-100060",0,50,180);
	/// ��Ѫ�����������仯��� Ѫѹ��mmHg�� cy 2021-07-15
	checkBP("BRVitSigns-99969-99994-99997");
	checkBP("BRVitSigns-99970-100005-100013");
	checkBP("BRVitSigns-99971-100021-100029");
	checkBP("BRVitSigns-99972-100037-100045");
	checkBP("BRVitSigns-99973-100053-100061");
	/// ��Ѫ�����������仯��� Ѫ�����Ͷȣ�%�� cy 2021-07-15
	chknum("BRVitSigns-99969-99995-99998",0,68,100);
	chknum("BRVitSigns-99970-100006-100014",0,68,100);
	chknum("BRVitSigns-99971-100022-100030",0,68,100);
	chknum("BRVitSigns-99972-100038-100046",0,68,100);
	chknum("BRVitSigns-99973-100054-100062",0,68,100);

	// ֢״��������
	chkdate("SymRelDate");
	/// ֢״����ʱ��
	chktime("SymDisTime","AdvBloodSereaOccTime");
	/// ʵ��������(ml)
	chknum("InputQuantity",0);
	/// ������(ml)
	chknum("Surplus",0);
	/// �¼�����ʱ�ڸ����λ�ʿ����
	chknum("OccuChaNurNum",0);
	/// �¼�����ʱ������Ժ��������
	chknum("OccuWardPatNum",0);
	
	
}

// ���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');				
	} 
}

//���汣��
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺ�/�����Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkother()&&checkRequired())){
		return;
	}
	SaveReportCom(flag);
}

//������Ϣ��ֵ���س��¼���
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
function add_event(){
	//ReportControl();
	/* 2018-06-06 ��ɾ�����ӵ�table����*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-4px"})
	 //����
	 $("input[id^='BloodGiveList-97701-97708-97715']").each(function(){
		if((this.id.split("-").length==4)){
			var BloodDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (BloodDate!=""){
				$("#"+this.id).datebox("setValue",BloodDate);
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
	//��������
	 $("input[id^='BloodGiveList-97701-97709-97716']").each(function(){
		if((this.id.split("-").length==4)){
			var BloodDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (BloodDate!=""){
				$("#"+this.id).datebox("setValue",BloodDate);
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
	
	
	$("input[id^='BloodGiveList-97701-97703-97710']").live('keydown',function(event){	
		if(event.keyCode == "13"){
			if(EpisodeID==""){
				$.messager.alert($g('��ʾ:'),$g('����ѡ���߾����¼��'));
				return;
			}
			ShowBldWin()
		}
    });
    TableControl();
	
}
function ShowBldWin(){
	
	$('#bldwin').show();
	$('#bldwin').window({
		title:$g('��Ѫ���б�'),
		collapsible:true,
		closed:"true",
		modal:true,
		minimizable: false, 
		maximizable: false,
		resizable: false,
		width:600,
		height:400
	}); 

	$('#bldwin').window('open');
	SetBldTxtVal(this.id);
}
//��Ѫ�� 2016-10-25
function SetBldTxtVal(BloodGiveListID)
{
	
	var columns = [[
		{field:'issueId',title:$g('��Ѫ��ID'),width:60,hidden:true}, 
		{field:'issFormNo',title:$g('���뵥��'),width:60,hidden:false}, 
		{field:'issueDate',title:$g('��������'),width:80}, 
		{field:'issueTime',title:$g('����ʱ��'),width:80},
		{field:'IsTransBlood',title:$g('�Ƿ��м�����Ѫʷ'),width:80},
		{field:'IsReaction',title:$g('�Ƿ�����Ѫ��Ӧʷ'),width:80},
		{field:'Parity',title:$g('�д�'),width:80},
		{field:'Gravidity',title:$g('����'),width:80}
	]];
	//����datagrid
	$('#bldgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatBldRecordNew&EpisodeID='+EpisodeID,	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,400],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		onDblClickRow: function (rowIndex, rowData) 
		{
			var issueId=rowData.issueId; //��Ѫ��id
			if((issueId!="")&&(issueId!=undefined)){
				$('#BB'+rowData.IsTransBlood).attr("checked",true); 	//������Ѫʷ BloodtransfusionHistory-label-97440
				if((rowData.IsTransBlood!="��")&&(rowData.Parity!=undefined)){
					$('#BloodtransfusionHistory-label-97440').attr("checked",true);//������Ѫʷ ��
					$('#BloodtransfusionHistory-label-97440').nextAll(".lable-input").show();
				}else{
					$('#BloodtransfusionHistory-label-97443').attr("checked",true);//������Ѫʷ ��
					$('#BloodtransfusionHistory-label-97440').nextAll(".lable-input").val("");
					$('#BloodtransfusionHistory-label-97440').nextAll(".lable-input").hide();
				}
				if((rowData.Parity!="0")&&(rowData.Parity!=undefined)){
					$('#isPregnancy-97293').attr("checked",true);//��ʷ ��
				}else{
					$('#isPregnancy-97294').attr("checked",true);//��ʷ ��
				}
				if ((rowData.Gravidity!="0")&&(rowData.Gravidity!=undefined)){
					$('#isGive-97307').attr("checked",true);//��ʷ ��
				}else{
					$('#isGive-97308').attr("checked",true);//��ʷ ��
				}
				
				GetbldBldTypedgInfo(issueId,BloodGiveListID);
			}
  			$('#bldwin').window('close');
		}
	});		 
	
}
			
//��ȡ��Ѫ����Ϣ��ʼ����Ѫ��Ϣ�б�  2016-10-27
function GetbldBldTypedgInfo(issueId,BloodGiveListID)
{  
	var BldList="";
	//	Ѫ����Ϣ(Ѫ����� ^ Ѫ������(Ѫ��Ʒ)^Ѫ��^��Ѫ����^Ѫ��Ѫ��)  ���������ݣ��� $$ ���зָ�
	runClassMethod("web.DHCADVINTERFACE","GetPatBldRecordPacksList",{'BldRecordId':issueId},
		function(val){ 
			BldList=val;
		},"text",false)
	if(BldList==""){
		$.messager.alert($g('��ʾ:'),$g('����Ѫ����Ѫ����Ϣ��������ѡ��'));
		return;
	}
	var BldListArr=BldList.split("$$")
	var Bldlen=BldListArr.length; //��Ѫ��¼���� ʵ����1
	
	var num=0,rowid="",rownum="";
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
			num=num+1;
			if(num!=1){
				$(this).parent().parent().remove(); /// ɾ��֮ǰ�����ݣ���һ�г��⣬��һ�лᱻ�����滻��
			}
			
	})
	for(var k=1;k<=Bldlen;k++){
		if(k>1){  // k>num
			$('a:contains("����")').click(); //�Զ����������
		}
	}
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
		if(rowid==""){
			rowid=this.id.split(".")[0];
		}else{
			rowid=rowid+"^"+this.id.split(".")[0];
		}
		if(rownum==""){
			rownum=this.id.split(".")[1];
		}else{
			rownum=rownum+"^"+this.id.split(".")[1];
		}
	})
	for(var k=0;k<Bldlen;k++){
		var BldpackID=BldListArr[k].split("^")[0]; //Ѫ�����
		var BloodProductName=BldListArr[k].split("^")[1]; //Ѫ������(Ѫ��Ʒ)
		var BDType=BldListArr[k].split("^")[2].split("��")[0]+"��"; //Ѫ��
		var BDTypeHD=BldListArr[k].split("^")[2].split("��")[1]; //������
		var packVolumn=BldListArr[k].split("^")[4]; //Ѫ��Ѫ��
		var rowidarr=rowid.split("^"),rownumarr=rownum.split("^");
		var value=$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[k]+"']").val();
		
		//if(value==""){
			$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[k]+"']").val(BldpackID);
			$("input[id^='BloodGiveList-97701-97704-97711']input[id$='"+rownumarr[k]+"']").val(BloodProductName);
			$("input[id^='BloodGiveList-97701-97705-97712']input[id$='"+rownumarr[k]+"']").val(BDType);
			$("input[id^='BloodGiveList-97701-97706-97713']input[id$='"+rownumarr[k]+"']").val(BDTypeHD);
			$("input[id^='BloodGiveList-97701-97707-97714']input[id$='"+rownumarr[k]+"']").val(packVolumn);
		//}
		if((BldList!="")&&(Bldlen==num)){ //��λ������ת��������ͬʱ���������һ������
			//$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[num]+"']").parent().parent().hide();
		}
		$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").attr('readonly','readonly')
		//$('a:contains("����")').parent().hide();
		//$('a:contains("ɾ��")').parent().hide();
	}
	TableControl();
			
}
function TableControl(){
	// ���� �Ƿ������ֹ�����ҽ�� ����
	    $("[id^='BloodGiveList-97701-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="BloodGiveList-97701-97703-97710")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
			}
		})
		
}

//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//�Ƿ���Ѫ������Ӧ
	if($("input[type=radio][id='AdvBloodsereactions-97445']").is(':checked')){
		var DeathDate=$('#AdvBloodSereaOccTime').datebox('getValue');
		RepSetRead("AdvBloodSereaOccTime","datebox",0);
		RepSetValue("AdvBloodSereaOccTime","datebox",DeathDate); 	//��Ѫ������Ӧʱ��
	}else{
		RepSetRead("AdvBloodSereaOccTime","datebox",1);
		$("#AdvBloodSereaOccTime").datebox("setValue","");  //����ֵ����Ϊ��
	}
	// ��Ѫ������Ӧ����ʱ - �Ƿ���  �� / ��
	if($("input[type=radio][id^='BRVitSigns-99969-99983-99985']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99969-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99969-']").val("");
		$("input[type=input][id^='BRVitSigns-99969-']").attr("readonly","readonly");
	}
	// ��Ѫǰ���һ�� - �Ƿ���  �� / ��
	if($("input[type=radio][id^='BRVitSigns-99970-100000-100007']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99970-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99970-']").val("");
		$("input[type=input][id^='BRVitSigns-99970-']").attr("readonly","readonly");
	}
	// ��Ѫ��ʼ15������ - �Ƿ���  �� / ��
	if($("input[type=radio][id^='BRVitSigns-99971-100016-100023']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99971-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99971-']").val("");
		$("input[type=input][id^='BRVitSigns-99971-']").attr("readonly","readonly");
	}
	// ��Ѫ��ʼ4Сʱ�� - �Ƿ���  �� / ��
	if($("input[type=radio][id^='BRVitSigns-99972-100032-100039']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99972-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99972-']").val("");
		$("input[type=input][id^='BRVitSigns-99972-']").attr("readonly","readonly");
	}
	// ��Ѫ��ʼ4Сʱ�� - �Ƿ���  �� / ��
	if($("input[type=radio][id^='BRVitSigns-99973-100048-100055']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99973-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99973-']").val("");
		$("input[type=input][id^='BRVitSigns-99973-']").attr("readonly","readonly");
	}
	
	
	//����-����֢״����
	if($("#BRRctCliniMan-5324-5326").is(':checked')){
		$("label[id^='BRTreFever'").css("display","inline-block");
		$("label[id^='lableBRTreFever'").css("display","inline-block");
	}else{
		$("label[id^='lableBRTreFever'").css("display","none");
		$("label[id^='BRTreFever'").css("display","none");
	}

	
	//Ƥ��-����֢״����
	if($("#BRRctCliniMan-5325-5329").is(':checked')||$("#BRRctCliniMan-5325-5331").is(':checked')||$("#BRRctCliniMan-5325-5330").is(':checked')||$("#BRRctCliniMan-5325-5332").is(':checked')||$("#BRRctCliniMan-5325-5334").is(':checked')){
		$("label[id^='BRTreSkinAllergy'").css("display","inline-block");
	}else{
		$("label[id^='BRTreSkinAllergy'").css("display","none");
	}	
	
	//BRRctCliniMan-5325-5337 ���
	if($("#BRRctCliniMan-5325-5337").is(':checked')){
		$("label[id^='BRTreSkinPurpura'").css("display","inline-block");
	}else{
		$("label[id^='BRTreSkinPurpura'").css("display","none");
	}	
	//��������  BRRctCliniMan-5338-5339
	if($("#BRRctCliniMan-5338-5339").is(':checked')){
		$("label[id^='BRTreBreathing'").css("display","inline-block");
		$("label[id='BRTreBreathing-5397-5398-5400'").css("display","none");
	}else{
		$("label[id^='BRTreBreathing'").css("display","none");
	}
	
	
	//��Ѫ֢״ 
	if($("#BRRctCliniMan-5371-5372").is(':checked')||$("#BRRctCliniMan-5371-5373").is(':checked')||$("#BRRctCliniMan-5371-5374").is(':checked')||$("#BRRctCliniMan-5371-5375").is(':checked')||$("#BRRctCliniMan-5371-5376").is(':checked')){
		$("label[id^='BRTreHemolysis'").css("display","inline-block");
	}else{
		$("label[id^='BRTreHemolysis'").css("display","none");
	}
	//������ BRStrarttype-5320
	if($("#BRStrarttype-5320").is(':checked')){
		$("label[id^='BRSpeInspection'").css("display","inline-block");
	}else{
		$("label[id^='BRSpeInspection'").css("display","none");
	}
	if($("#BRTreBreathing-5397-5398").is(':checked')){
		$("label[id='BRTreBreathing-5397-5398-5400'").css("display","inline-block");
	}else{
		$("label[id='BRTreBreathing-5397-5398-5400'").css("display","none");
	}
	
	/// ����-�������Ѵ���-���߳��ֺ������ѣ����ȶԷ���ԭ����г����ж�--���1:TACO TRALI TAD �������޼��Է�����Σ������ �� ȡ���� �� �Ĺ�ѡ��Ĺ�ѡ
	if($("input[type=checkbox][id^='BRTreBreathing-5397-5398-5400-5403-").is(':checked')){
		if(id=="BRTreBreathing-5397-5398-5400-5403-5429"){
			$("input:not([id='BRTreBreathing-5397-5398-5400-5403-5429'])input[type=checkbox][id^='BRTreBreathing-5397-5398-5400-5403-']").removeAttr("checked");
		}else{
			$("#BRTreBreathing-5397-5398-5400-5403-5429").removeAttr("checked");
		}
	}
	/// ����ٴ�����-Ƥ��
	if($("input[type=checkbox][id^='BRRctCliniMan-5325-").is(':checked')){
		/// �ֲ�Ƥ��
		if(id=="BRRctCliniMan-5325-5331"){
			$("#BRRctCliniMan-5325-5332").removeAttr("checked");
		}
		/// ȫ��Ƥ��
		if(id=="BRRctCliniMan-5325-5332"){
			$("#BRRctCliniMan-5325-5331").removeAttr("checked");
		}
	}
	/// ����ٴ�����-��Ѫ��
	if($("input[type=checkbox][id^='BRRctCliniMan-5362-").is(':checked')){
		/// Ѫѹ�����쳣����
		if(id=="BRRctCliniMan-5362-5365"){
			$("#BRRctCliniMan-5362-5364").removeAttr("checked");
		}
		/// Ѫѹ�����쳣����
		if(id=="BRRctCliniMan-5362-5364"){
			$("#BRRctCliniMan-5362-5365").removeAttr("checked");
		}
	}

}
///�ж���Ѫ�б��Ƿ�Ϊ�� sufan 2019-11-14
function checkother()
{
	//������Ѫ�б���Ϊ��
	var ret=1
	$("input[id^='BloodGiveList-97701-97704-97711']").each(function(){
			if($(this).val()=="")
			{
				return true;
			}else{
				ret=0
			}
			
	})
	if(ret==1){
		if(MKIOrdFlag!="1"){
			$.messager.alert($g("��ʾ:"),$g("��ά����Ѫ��¼�����б��ֶ�������Ѫ��Ϣ��Ч����س�ѡ����Ѫ������"));
		}else{
			$.messager.alert($g("��ʾ:"),$g("��ά����Ѫ��¼�����б�������Ѫ��Ϣ�٣��貹����Ϣ����"));
		}
		return false;
		
	}
	///������Ѫ�б���Ѫ��ʼ���ںͽ�������
	var num=0,rowid="",rownum="";
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
			num=num+1;
	})
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
		if(rowid==""){
			rowid=this.id.split(".")[0];
		}else{
			rowid=rowid+"^"+this.id.split(".")[0];
		}
		if(rownum==""){
			rownum=this.id.split(".")[1];
		}else{
			rownum=rownum+"^"+this.id.split(".")[1];
		}
	})
	rownumarr=rownum.split("^");
	var clorec=0;
	for(var i=0;i<num;i++){
		var stDateTime=$("input[id^='BloodGiveList-97701-97708-97715'][id$='"+rownumarr[i]+"']").datetimebox('getValue');
		var endDateTime=$("input[id^='BloodGiveList-97701-97709-97716'][id$='"+rownumarr[i]+"']").datetimebox('getValue');
		if(!DateTimecontrast(stDateTime,endDateTime)){
			clorec=i+1;
			break;
		}
	}
	if(clorec>0){
		$.messager.alert($g("��ʾ:"),$g("��Ѫ�б��")+clorec+$g("����Ѫ��ʼʱ�������Ѫ����ʱ�䣡"));
		return false;
	}
	return true;
}
function DateTimecontrast(stDateTime,endDateTime)
{
	var ret=1;
	var reg = new RegExp(":","g")
	var stDate=stDateTime.split(" ")[0];
	var stTime=stDateTime.split(" ")[1]==undefined?"":stDateTime.split(" ")[1].replace(reg,"");
	var endDate=endDateTime.split(" ")[0];
	var endTime=endDateTime.split(" ")[1]==undefined?"":endDateTime.split(" ")[1].replace(reg,"");
	if(!compareSelTowTime(stDate,endDate)){
		ret=0;
	}else if((stDate==endDate)&&(stTime>endTime)){
		ret=0
	}else{
		ret=1;
	}
	return ret;
}
