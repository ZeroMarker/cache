
/// Creator: bianshuai
/// CreateDate: 2014-06-22

var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫���м��ɱ༭]</span>';
var titleOpNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫�������/ɾ��]</span>';
var adrEvtArr = [{"value":"S","text":'����'}, {"value":"G","text":'һ��'}];
var currEditRow="";currEditID="";adrRepID="";PatientID="";EpisodeID="";editFlag="";AdrRepInitStatDR="";currEditOeori="";
var disEditRow="";
///�Ǻű�ʾ
var AstSymbol='<span style="color:red;">*</span>';

$(function(){
	PatientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	adrRepID=getParam("adrRepID");
	editFlag=getParam("editFlag");
	
	//��ѡ�����
	InitUIStatus();
	
	/* �Ա� */
	var patSexCombobox = new ListCombobox("PatSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	patSexCombobox.init();
	
	/* ���� */
	var NationCombobox = new ListCombobox("PatNation",url+'?action=selNation','',{});
	NationCombobox.init();
	
	/* ҽԺ */
	var HospCombobox = new ListCombobox("Hospital",url+'?action=SelCTHospital','',{panelHeight:"auto"});
	HospCombobox.init();

	/* ��λ���� */
	var UnitCombobox = new ListCombobox("adrrRepDeptName",url+'?action=SelCTHospital','',{panelHeight:"auto"});
	UnitCombobox.init();
	
	/* ���沿�� */
	var RepDeptCombobox = new ListCombobox("adrrSignOfRepDept",url+'?action=SelAllLoc','',{});
	RepDeptCombobox.init();
		
	InitPageDatagrid();  ///��ʼ�� ����/����ҩƷdatagrid
	
	$('#disfind').click(function(){
		createDisWindow();
	})
	$('#adrEvtFind').click(function(){
		createAdrEvtWindow();
	})
	
	$('#adrrEventHistDesc').click(function(){
		createAdrEvtEHWindow();
	})
	
	$('#adrrEventFamiDesc').click(function(){
		createAdrEvtEFWindow();
	})
	
	//��������Ϊ����ʱ,������
	$('#RT11').click(function(){
		if($('#'+this.id).is(':checked')){
			createAdrEvtRetWindow();
			$('#serdesc').val("");
		}else{
			$('#modser').css("display","none");
			$('#serdesc').css("display","none");
			$('#serdesc').val("");
		}
	})
	$('#modser').bind('click',createAdrEvtRetWindow); //�޸�������������
	
	if(adrRepID == ""){
		InitPatientInfo(PatientID,EpisodeID);
	}else{
		InitAdrReport(adrRepID);
	}
	
	$('input').live('click',function(){
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	});

	$('#DateOccu').datebox({
		onSelect:function(date){
			if(!compareSelTimeAndCurTime($('#DateOccu').datebox('getValue'))){
				$.messager.alert("��ʾ:","��������Ӧ/�¼�����ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
				$('#DateOccu').datebox('setValue',"");
			}
		}
	})
	
	//editFlag״̬Ϊ0,�����ύ���ݴ水ť
	if(editFlag=="0"){
		$("a:contains('�ύ')").css("display","none");
		$("a:contains('�ݴ�')").css("display","none");
	}
	
	//������Ӧʱ�����
	$('#DateOccu').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	//����ʱ�����
	$('#adrrEventRDRDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
})

///=====================================����/����ҩƷdatagrid===================================
function InitPageDatagrid(){
	
	//����
	var serBatNoEditor={  //������Ϊ�ɱ༭
		type: 'combobox', //���ñ༭��ʽ
		options: {
			//required: true, //���ñ༭��������
			panelHeight:"auto",
			valueField: "value", 
			textField: "text",
			url: url+'?action=getBatNoList',
			onSelect:function(option){
				var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'batnodr'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'batno'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			},
			onBeforeLoad: function(param){
				/*
				if(currEditID != ""){
					var rows=$('#'+currEditID).datagrid('getRows');//��ȡ���е�ǰ���ص�������
					param.oeori=rows[currEditRow].orditm;
				}
				*/
				param.oeori=currEditOeori;
			}
		}

	}
	
	//����columns
	var columns=[[
		{field:"dgID",title:'dgID',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
	    {field:'apprdocu',title:'��׼�ĺ�',width:80},
	    {field:'incidesc',title:'��Ʒ����',width:180},
		{field:'genenic',title:AstSymbol+'ͨ������',width:100},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'manf',title:AstSymbol+'��������',width:100},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'batnodr',title:'batnodr',editor:'text',hidden:true},
		{field:'batno',title:AstSymbol+'��������',width:80,editor:serBatNoEditor},
		{field:'usemethod',title:AstSymbol+'�÷�����',width:140},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'dosqty',title:'dosqty',width:80,hidden:true},
		{field:'starttime',title:AstSymbol+'��ʼʱ��',width:80,editor:dateboxditor},
		{field:'endtime',title:AstSymbol+'����ʱ��',width:80,editor:dateboxditor},
		{field:'usereason',title:AstSymbol+'��ҩԭ��',width:100,editor:texteditor},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	//����datagrid
	$('#susdrgdg').datagrid({
		title:'����ҩƷ'+titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: rowhandleClick
	});

	//����datagrid
	$('#blenddg').datagrid({
		title:'����ҩƷ'+titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: rowhandleClick
	});
	
	//��ʼ����ʾ���������
	InitdatagridRow('susdrgdg'); 
	InitdatagridRow('blenddg');
	var TipFieldList = "apprdocu^incidesc^genenic^manf^usereason";
	LoadCellTip(TipFieldList);
}

var rowhandleClick=function (rowIndex, rowData) {//˫��ѡ���б༭
	currEditOeori = rowData.orditm;
	if ((currEditRow != "")||(currEditRow == "0")) {
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	} 
	$("#"+this.id).datagrid('beginEdit', rowIndex);

	currEditID=this.id;
	currEditRow=rowIndex;
}

// ��������
function insertRow()
{
	$('#susdrgdg').datagrid('appendRow', {//��ָ����������ݣ�appendRow�������һ���������
		row: {
			orditm:'', phcdf:'', incidesc:'', genenic:'', 
	    	genenicdr:'', usemethod:'', dosuomID:'',
	    	instrudr:'', freqdr:'', durId:'', apprdocu:'', 
	    	manf:'', manfdr:'', formdr:''}
	});
}

// ɾ����
function delRow(datagID,rowIndex)
{
	//�ж���
    var rowobj={
		orditm:'', phcdf:'', incidesc:'', genenic:'', 
	    genenicdr:'', usemethod:'', dosuomID:'',
	    instrudr:'', freqdr:'', durId:'', apprdocu:'', 
	    manf:'', manfdr:'', formdr:'',starttime:'',endtime:'',
	    usereason:'',batno:''
	};
	
	//��ǰ��������4,��ɾ�����������
	//var selItem=$('#'+datagID).datagrid('getSelected');
	//var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	var rows = $('#'+datagID).datagrid('getRows');
	if(rows.length>4){
		 $('#'+datagID).datagrid('deleteRow',rowIndex);
	}else{
		$('#'+datagID).datagrid('updateRow',{
			index: rowIndex, // ������
			row: rowobj
		});
	}
	
	// ɾ����,��������
	$('#'+datagID).datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}
///==============================================================================================
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

/// ���治����Ӧ�¼���д����
function saveAdrEventReport(flag)
{
	

	///����ǰ,��ҳ���������м��
	if((flag)&&(!saveBeforeCheck())){
		return;
	}


	//1���������ȼ�
	var adrrPriority="";
    $("input[type=checkbox][name=adrrPriority]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrPriority=this.value;
		}
	})
	
	//2���������
	var adrrRepCode=$('#adrrRepCode').val();
	adrrRepCode=adrrRepCode.replace(/[ ]/g,""); //ȥ�������еĿո�

	//3����������
	var adrrRepType="",adrrRepTypeNew="",adrrRepTSDesc="";
	if($("#new").is(':checked')){
		adrrRepTypeNew="Y";
	}
    $("input[type=checkbox][name=adrrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepType=this.value;
		}
	})
	
	//4�����浥λ���
	var adrrRepDeptType="";
	var adrrRepDeptTypeDesc="";
    $("input[type=checkbox][name=adrrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepDeptType=this.value;
		}
	})
	adrrRepDeptTypeDesc=$('#RepDeptTypeOther').val();

	//5��������Ϣ
	var adrrPatID=$('#adrrPatID').val(); //����ID
	var adrrPatName=$('#PatName').val(); //��������
	var adrrPatSex=$('#PatSex').combobox('getValue');;  //�Ա�
	var adrrPatAge=$('#PatAge').val();  //����
	var adrrPatDOB=$('#PatDOB').datebox('getValue');  //��������
	var adrrPatNation=$('#PatNation').combobox('getValue');  //����
	var adrrPatWeight=$('#PatWeight').val();  //����
	var adrrPatContact=$('#PatContact').val(); //��ϵ��ʽ
	
	//6��ԭ������
	var adrrPatOriginalDis=$('#adrrPatOriginalDis').val();
	
	//7��ҽԺ����
	var adrrHospital=$('#Hospital').combobox('getText');
	
	//8��������/�����
	var adrrPatMedNo=$('#PatMedNo').val();
	
	//9������ҩƷ������Ӧ�¼�
	var adrrEventHistory="";
	var adrrEventHistoryDesc="";
	$("input[type=checkbox][name=adrrEventHistory]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventHistory=this.value;
		}
	})

	// �еĻ�ȡ������
	if(adrrEventHistory=="10"){
		adrrEventHistoryDesc=$('#adrrEventHistDesc').val();
	}

	//10������ҩƷ������Ӧ�¼�
	var adrrEventFamily="";
	var adrrEventFamilyDesc=""; 
	$("input[type=checkbox][name=adrrEventFamily]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventFamily=this.value;
		}
	})
	// �еĻ�ȡ������
	if(adrrEventFamily=="10"){
		adrrEventFamilyDesc=$('#adrrEventFamiDesc').val();
	}

	//11���¼�����
	var adrrAdrEvent=""; //$('#AdrEvent').val(); //DHC_PHAdrEvent DR

	//12���¼���������
	var adrrDateOccu=$('#DateOccu').datebox('getValue');

	//13���¼��Ľ��
	var adrrEventResult="";
	var adrrEventResultDesc=""; //�������
	var adrrEventResultDate=""; //��������
	$("input[type=checkbox][name=adrrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventResult=this.value;
		}
	})
	// ����֢����
	if(adrrEventResult=="13"){
		adrrEventResultDesc=$('#adrrEventRSeqDesc').val();
	}

	// ֱ������
	if(adrrEventResult=="14"){
		adrrEventResultDesc=$('#adrrEventRDRDesc').val();
		adrrEventResultDate=$('#adrrEventRDRDate').datetimebox('getValue'); //����/��ת����
	}
	
	//14����ת(����)���� ʱ��
	var adrrEventDateResult="",adrrEventTimeResult="";
	if(adrrEventResultDate!=""){
		adrrEventDateResult=adrrEventResultDate.split(" ")[0];
		adrrEventTimeResult=adrrEventResultDate.split(" ")[1];
	}

	//15��ͣҩ���Ƿ����
	var adrrEventStopResultt="";
    $("input[type=checkbox][name=adrrEventStopResultt]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventStopResultt=this.value;
		}
	})

	//16���ٴ�ʹ��ʱ�Ƿ��ٴγ���ͬ����Ӧ
	var adrrEventTakingAgain="";
    $("input[type=checkbox][name=adrrEventTakingAgain]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventTakingAgain=this.value;
		}
	})

	//17����ԭ������Ӱ��
	var adrrEventEffectOfTreatment="";
    $("input[type=checkbox][name=adrrEventEffectOfTreatment]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventEffectOfTreatment=this.value;
		}
	})

	//18������������֮����������
	var adrrEventCommentOfUser="";
    $("input[type=checkbox][name=adrrEventCommentOfUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventCommentOfUser=this.value;
		}
	})

	var adrrEventUserOfReport=$('#adrrEventUserOfReport').val(); //������ǩ��

	//19������������֮���浥λ����
	var adrrEventCommentOfDept="";
    $("input[type=checkbox][name=adrrEventCommentOfDept]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventCommentOfDept=this.value;
		}
	})

	var adrrEventDeptOfReport=$('#adrrEventDeptOfReport').val(); //����λǩ��

	//20����������Ϣ
	var adrrReportUserTel=$('#adrrReportUserTel').val();  //��������ϵ�绰
	var adrrCareerOfRepUser=""; //������ְҵ
	var adrrCareerOfRepUserDesc=""; //������ְҵ����
	$("input[type=checkbox][name=adrrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrCareerOfRepUser=this.value;
		}
	})
	// ����
	if(adrrCareerOfRepUser=="99"){
		adrrCareerOfRepUserDesc=$('#adrrCareerOfRepUserOthers').val();
	}
	
	var adrrEmailOfRepUser=$('#adrrEmailOfRepUser').val(); //����������
	var adrrSignOfRepUser=$('#adrrSignOfRepUser').val();   //������ǩ��
	var adrrSignOfRepDept=$('#adrrSignOfRepDept').combobox('getValue'); //���沿��
	
	//21�����浥λ��Ϣ
	var adrrRepDeptName=$('#adrrRepDeptName').combobox('getText');       //���浥λ
	var adrrRepDeptContacts=$('#adrrRepDeptContacts').val(); //���浥λ��ϵ��
	var adrrRepDeptTel=$('#adrrRepDeptTel').val();           //���浥λ��ϵ�绰
	var adrrRepDate=$('#adrrRepDate').datebox('getValue');   //��������
	if(adrrRepDate==""){
		$.messager.alert("��ʾ:","�������ڲ���Ϊ�գ�");
		return;
	}
	
	//22��������ҵ
	var adrrProCompany="";
	var adrrProCompanyDesc="";
	$("input[type=checkbox][name=adrrProCompany]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrProCompany=this.value;
		}
	})
	// ����
	if(adrrProCompany=="99"){
		adrrProCompanyDesc=$('#adrrProCompanyDesc').val();
	}

	//23����ע
	var adrrRepRemark=$('#adrrRepRemark').val(); //���浥λ��ϵ�绰
	
	var adrAudStatusDr="";adrRepAuditList="";
	if(flag==1){
		adrAudStatusDr=AdrRepInitStatDR;  //��ʼ״̬
		adrRepAuditList=AdrRepInitStatDR+"^"+LgUserID;
	}
	
	var adrRepDataList=adrrRepCode+"^"+adrrPriority+"^"+adrrRepType+"^"+adrrRepDeptType+"^"+adrrRepDeptTypeDesc+"^"+adrrPatID;
	adrRepDataList=adrRepDataList+"^"+adrrPatName+"^"+adrrPatSex+"^"+adrrPatAge+"^"+adrrPatDOB+"^"+adrrPatNation+"^"+adrrPatWeight+"^"+adrrPatContact;
	adrRepDataList=adrRepDataList+"^"+adrrPatMedNo+"^"+adrrEventHistory+"^"+adrrEventHistoryDesc+"^"+adrrEventFamily+"^"+adrrEventFamilyDesc;
	adrRepDataList=adrRepDataList+"^"+adrrAdrEvent+"^"+adrrDateOccu+"^"+adrrEventResult+"^"+adrrEventResultDesc;
	adrRepDataList=adrRepDataList+"^"+adrrEventDateResult+"^"+adrrEventTimeResult+"^"+adrrEventStopResultt+"^"+adrrEventTakingAgain;
	adrRepDataList=adrRepDataList+"^"+adrrEventEffectOfTreatment+"^"+adrrEventCommentOfUser+"^"+adrrEventUserOfReport+"^"+adrrEventCommentOfDept+"^"+adrrEventDeptOfReport;
	adrRepDataList=adrRepDataList+"^"+adrrReportUserTel+"^"+adrrCareerOfRepUser+"^"+adrrCareerOfRepUserDesc+"^"+adrrEmailOfRepUser;
	adrRepDataList=adrRepDataList+"^"+adrrRepDeptName+"^"+adrrRepDeptContacts+"^"+adrrRepDeptTel+"^"+adrrRepDate+"^"+adrrProCompany+"^"+adrrProCompanyDesc;
	adrRepDataList=adrRepDataList+"^"+adrrRepRemark+"^"+adrrRepTSDesc+"^"+adrrRepTypeNew+"^"+adrAudStatusDr+"^"+adrrSignOfRepDept;
	
	//24�������Ҫ��Ϣ
	var smokhis="",drinhis="",gestper="",hepahis="",nephhis="",allehis="",iiothers="",iiothersdesc="";
    if($("#II10").is(':checked')){smokhis="10";}; //����ʷ
    if($("#II11").is(':checked')){drinhis="11";}; //����ʷ
    if($("#II12").is(':checked')){gestper="12";}; //������
    if($("#II13").is(':checked')){hepahis="13";}; //�β�ʷ
    if($("#II14").is(':checked')){nephhis="14";}; //����ʷ
    if($("#II15").is(':checked')){allehis="15";}; //����ʷ
    if($("#II99").is(':checked')){ 	//����
	    iiothers="99";
	    iiothersdesc=$('#iiothersdesc').val();
	};
	//������Ҫ��Ϣ
	var adrRepImpInfodataList=smokhis+"||"+drinhis+"||"+gestper+"||"+hepahis+"||"+nephhis+"||"+allehis+"||"+iiothers+"^"+iiothersdesc;
	
	//25��ҩƷ
	var tmpItmArr=[],phcItmStr="";
	//����ҩƷ
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		    var tmp="10"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
		    item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+
		    trsUndefinedToEmpty(item.usereason);
		    tmpItmArr.push(tmp);
		}
	})
	//����ҩƷ
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		 	var tmp="11"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		  	item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
		  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+
		    trsUndefinedToEmpty(item.usereason);
		  	tmpItmArr.push(tmp);
		 }
	})
	phcItmStr=tmpItmArr.join("!!");

	//26��ԭ������
	var MRCICItms=$('#MRCICItms').val();
	
	//27��������Ӧ�¼�
	var adrEvtItems=$('#AdrEventItms').val();
	if(adrEvtItems==""){
		adrEvtItems="^"+$('#AdrEvent').val()+"[]";
	}
	
	//28��������Ӧ/�¼���������������֢״���������ٴ�����ȣ������������
	var adrrTherapMeas=""; 	//$('#adrrTherapMeas').val();
	var adrrSymptom=""; 	//$('#adrrSymptom').val();
	var adrrOtherExplanation=""; //$('#adrrOtherExplanation').val();
	var adrrProcessDesc=$('#adrrProcessDesc').val();
	var adrrEvtProcessDesc=adrrTherapMeas+"^"+adrrSymptom+"^"+adrrOtherExplanation+"^"+adrrProcessDesc;

	var param="adrRepID="+adrRepID+"&adrRepDataList="+adrRepDataList+"&ImpInfo="+adrRepImpInfodataList+"&ItmStr="+phcItmStr;
	    param=param+"&MRCICItms="+MRCICItms+"&AdrEvtItems="+adrEvtItems+"&AdrEvtProcessDesc="+adrrEvtProcessDesc+"&adrRepAuditList="+adrRepAuditList; 
    
//����
    $.ajax({
   	   type: "POST",
       url: url,
	   data: "action=saveAdrReport&"+param,
       success: function(jsonString){
	      var retObj = jQuery.parseJSON(jsonString);
	      if (retObj.ErrCode == "0") {      	
			 adrRepID=retObj.AdrRepID;
			 $('#adrrRepCode').val(retObj.AdrRepCode); //���
			 if(flag==1){
				  $.messager.alert("��ʾ:","�ύ�ɹ���");	                 //liyarong 2016-10-09
				  $("a:contains('�ύ')").linkbutton('disable');
				  $("a:contains('�ݴ�')").linkbutton('disable');
			}else if(flag==0){
				  $.messager.alert("��ʾ:","�ݴ�ɹ���");
			  }			 
	      }else{
		  	 $.messager.alert("��ʾ:",val);
		  }
       },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });
}

/// ����ҩƷ����
function patOeInfoWindow()
{
	$('#mwin').window({
		title:'������ҩ�б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520
	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//��ʼ��������ҩ�б�
function InitPatMedGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'���ȼ�',width:80},
		{field:'StartDate',title:'��ʼ����',width:80},
		{field:'EndDate',title:'��������',width:80},
		{field:'incidesc',title:'����',width:280},
		{field:'genenic',title:'ͨ����',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'��׼�ĺ�',width:80},
		{field:'manf',title:'����',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];

	/// ��ʼ�� datagrid
	var option = {queryParams:{action:'GetPatOEInfo',params:EpisodeID}};
	var medListComponent = new ListComponent('medInfo', columns, url, option);
	medListComponent.Init();
}

//��ӻ���ҩƷ
function addSuspectDrg()
{
	///�ж�ҩƷ�Ƿ��ظ����
    if(!AppBeforeCheck("susdrgdg")){return false;}
    
	//��ҩ�б�
	var rows = $('#susdrgdg').datagrid('getRows');
	for(var i=0;i<rows.length;i++){
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("��ʾ:","��ѡ������ҩƷ��");
		return;
	}
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu,starttime:item.startdate,
		    endtime:item.enddate,manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'susdrgdg'
		}

	    if((i>3)||(rows.length<=i)){
			$("#susdrgdg").datagrid('appendRow',rowobj);
		}else{
			$("#susdrgdg").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
				index: i, // ������0��ʼ����
				row: rowobj
			});
		}
		i=i+1;
    })
    $.messager.alert("��ʾ:","��ӳɹ���");
    clsDrgWin();
}

//��Ӳ���ҩƷ
function addMergeDrg()
{
	///�ж�ҩƷ�Ƿ��ظ����
    if(!AppBeforeCheck("blenddg")){return false;}
	
	//��ҩ�б�
	var rows = $('#blenddg').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("��ʾ:","��ѡ������ҩƷ��");
		return;
	}
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu,starttime:item.startdate, 
		    endtime:item.enddate,manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'blenddg'
		}
	    if((i>3)||(rows.length<=i)){
			$("#blenddg").datagrid('appendRow',rowobj);
		}else{
			$("#blenddg").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
				index: i, // ������0��ʼ����
				row: rowobj
			});
		}
		i=i+1;
    })
    $.messager.alert("��ʾ:","��ӳɹ���");
    clsDrgWin();
}

//��ʼ���б�ʹ��
function InitdatagridRow(id)
{
	for(var k=0;k<4;k++)
	{
		$('#'+id).datagrid('insertRow',{
			index: 0, // ������
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:'', 
			    genenicdr:'', usemethod:'', dosuomID:'',
			    instrudr:'', freqdr:'', durId:'', apprdocu:'', 
			    manf:'', manfdr:'', formdr:'',dgID:id
			}
		});
	}
}

//�رղ�����ҩ����
function clsDrgWin()
{
	$('#mwin').window('close');
}

//����¼��
function createDisWindow()
{
	$('#diswin').window({
		title:'������Ŀ�б�'+titleOpNotes,
		collapsible:true,
		border:false,
		closed:"true",
		width:860,
		height:520
	}); 

	$('#diswin').window('open');
	InitDisWinPanel();
	//���datagrid
    $('#dislist').datagrid('loadData', {total:0,rows:[]});
    $('#seldislist').datagrid('loadData', {total:0,rows:[]});
}

///��ʼ��������Ŀ����
function InitDisWinPanel()
{
	var columns=[[
		 {field:'MRCID',title:'MRCID',width:40},   
		 {field:'MRCDesc',title:'����',width:300,editor:texteditor}
	]];
  
  	/// ��ʼ��ԭ������ datagrid
	var option = {onDblClickRow:disListClick,singleSelect:true};
	var disListComponent = new ListComponent('dislist', columns, '', option);
	disListComponent.Init();

  	/// ��ʼ��ԭ��������ѡ datagrid
	var option = {
		singleSelect:true,
		toolbar: [{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				var disItemArr=[],disItemDescArr=[],disItems="";
				var items = $('#seldislist').datagrid('getRows');
				$.each(items, function(index, item){
					var row = $('#seldislist').datagrid('getRowIndex',item); 
					$('#seldislist').datagrid('endEdit',row); 
					if(item.MRCDesc!=""){
						disItemArr.push(item.MRCID+"^"+item.MRCDesc);
						disItemDescArr.push(item.MRCDesc);
					}
				})
				disItems=disItemArr.join("||");
				$('#adrrPatOriginalDis').val(disItemDescArr.join(","));
				$('#MRCICItms').val(disItems);
				$('#diswin').window('close');
			}
		},{
			text:'��ӿ���',
			iconCls: 'icon-add',
			handler: function(){
				if(disEditRow>="0"){
					$("#seldislist").datagrid('endEdit', disEditRow);//�����༭������֮ǰ�༭����
				}
				$("#seldislist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
					index: 0, // ������0��ʼ����
					row: {MRCID: '',MRCDesc:''}
				});
				$("#seldislist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
				disEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seldislist').datagrid('deleteRow',rowIndex);
		}
	};
	var selDisListComponent = new ListComponent('seldislist', columns, '', option);
	selDisListComponent.Init();
    //�����������ı������
	$('#textAlise').val('');
	//�������ƻس��¼�
	$('#textAlise').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input=$.trim($("#textAlise").val());
			if (input!=""){
				$('#dislist').datagrid({
                                        pageNumber:1,  //����ǿ  ʹÿ�β�ѯ���ӵ�һҳ��ʼ
					url:url+'?action=GetMRCICDDx',	
					queryParams:{
						params:input
					}
				});
			}	
		}
	});
	modAdrDisList(); //�����Ѿ����ڵ�ԭ�������б�
}

/// ���input���ݵ�datagrid
function modAdrDisList()
{
	if($('#MRCICItms').val()==""){return;}
	var MRCICItms=$('#MRCICItms').val(); //��ȡ�Ѵ��ڲ�����Ӧ����
	var MRCICItmsArr=MRCICItms.split("||");
	var tempArr=[];
	for(var i=0;i<MRCICItmsArr.length;i++){
		var MRCItmArr=MRCICItmsArr[i].split("^");
		tempArr.push("{\"MRCID\":\""+MRCItmArr[0]+"\",\"MRCDesc\":\""+MRCItmArr[1]+"\"}");		
	}
	var jsdata = '{"total":'+MRCICItmsArr.length+',"rows":['+tempArr.join(",")+']}';
	var data = $.parseJSON(jsdata);
	$('#seldislist').datagrid("loadData",data);//�����ݰ󶨵�DataGrid��
}

/// ����¼�
function disListClick(rowIndex, rowData)
{
	if(disEditRow>="0"){
		$("#seldislist").datagrid('endEdit', disEditRow);//�����༭������֮ǰ�༭����
	}

	var tmpMRCID=rowData.MRCID;
	var tmpMRCDesc=rowData.MRCDesc;

	 $('#seldislist').datagrid('insertRow',{
		 index: 0,	// index start with 0
		 row: {
			MRCDesc: tmpMRCDesc,
			MRCID: tmpMRCID
		}
     });	
}

//������Ӧ�¼�
function createAdrEvtWindow()
{
	$('#AdrEvtWin').window({
		title:'������Ӧ�¼�'+titleOpNotes,
		collapsible:true,
		border:false,
		closed:"true",
		width:860,
		height:520
	}); 

	$('#AdrEvtWin').window('open');
	InitAdreEvtwinWinPanel();
	 $('#seladrevtlist').datagrid('loadData', {total:0,rows:[]});
}

///��ʼ��������Ӧ�¼�����
function InitAdreEvtwinWinPanel()
{
	var adrEvtEditRow=""; //��ǰ�༭��
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'������Ӧ����',width:300,editor:texteditor}
	]];
  
    /// ��ʼ��������Ӧ datagrid
	var option = {onDblClickRow:function(rowIndex, rowData){ 
			if(adrEvtEditRow>="0"){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//�����༭������֮ǰ�༭����
			}
			var tmpAdrEvtID=rowData.AdrEvtID;
			var tmpAdrEvtDesc=rowData.AdrEvtDesc;
			 //zhaowuqiang  2016-09-13
			var items = $('#seladrevtlist').datagrid('getRows');
			var quitflag=0;
			$.each(items, function(index, item){
					if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("��ʾ:","������Ӧ���س̶Ȳ���Ϊ�գ�");
						quitflag=1;
						return;
					}		
			})
			if(quitflag==0){
				var temp=$('#seladrevtlist').datagrid('insertRow',{
				index: 0,	// index start with 0
				 row: {AdrEvtDesc: tmpAdrEvtDesc,AdrEvtID: tmpAdrEvtID}
	         		}).datagrid('getRows').length;
	         	$("#seladrevtlist").datagrid('beginEdit',temp)
			}
		},singleSelect:true
	};
	var tmpurl=url+'?action=GetAdrEvent'
	var adrEvtListComponent = new ListComponent('adrevtlist', columns, tmpurl, option);
	adrEvtListComponent.Init();
    $('#adrevtlist').datagrid('load',{params:""}); 
	//���ؼ���
	var serLvEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:adrEvtArr,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#seladrevtlist").datagrid('getEditor',{index:adrEvtEditRow,field:'AdrEvtSerLvID'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$("#seladrevtlist").datagrid('getEditor',{index:adrEvtEditRow,field:'AdrEvtSerLvDesc'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			} 
		}
	}
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'������Ӧ����',width:300,editor:texteditor},
		{field:'AdrEvtSerLvID',title:'AdrEvtSerLvID',width:60,editor:texteditor},
		{field:'AdrEvtSerLvDesc',title:'���س̶�',width:100,editor:serLvEditor}
	]];
	
	var option = {	
        singleSelect:true,
		toolbar: [{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtItemArr=[],adrEvtItmDescArr=[],adrEvtItems="";
				var items = $('#seladrevtlist').datagrid('getRows');
				var quitflag=0;
				$.each(items, function(index, item){
					var row = $('#seladrevtlist').datagrid('getRowIndex',item); 
					$('#seladrevtlist').datagrid('endEdit',row);
					
					if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("��ʾ:","������Ӧ���س̶Ȳ���Ϊ�գ�");
						quitflag=1;
						return;
					}
					if(item.AdrEvtDesc!=""){
						adrEvtItemArr.push(item.AdrEvtID+"^"+item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
						adrEvtItmDescArr.push(item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
					}
				})
				if(quitflag==1){return;}
				adrEvtItems=adrEvtItemArr.join("||");
				$('#AdrEvent').val(adrEvtItmDescArr.join(","));
				$('#AdrEventItms').val(adrEvtItems);
				$('#AdrEvtWin').window('close');
			}
		},{
			text:'��ӿ���',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEditRow>="0"){
					$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//�����༭������֮ǰ�༭����
				}
				//zhaowuqiang 2016-09-13
				var items = $('#seladrevtlist').datagrid('getRows');
				var quitflag=0;
				$.each(items, function(index, item){
					if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("��ʾ:","������Ӧ���س̶Ȳ���Ϊ�գ�");
						quitflag=1;
						return;
					}		
				})
				if(quitflag==0){
						var temp=$("#seladrevtlist").datagrid('insertRow',{//��ָ����������ݣ�appendRow�������һ���������
						index: 0, // ������0��ʼ����
						row: {AdrEvtID: '',AdrEvtDesc:''}
						}).datagrid('getRows').length-items.length;
						$('#seladrevtlist').datagrid('beginEdit',temp)

						adrEvtEditRow=0;
				}
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seladrevtlist').datagrid('deleteRow',rowIndex);
		},
		onClickRow:function(rowIndex, rowData){
			if(adrEvtEditRow==""){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);  //����ǿ  2016-09-09
				}
			if (adrEvtEditRow !="") {
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow); 
				var rows = $("#seladrevtlist").datagrid('getSelections');
				if(rows[adrEvtEditRow].AdrEvtSerLvID==undefined){
					alert("���س̶�  ����Ϊ��");
					return ;
				}
			}
			 $("#seladrevtlist").datagrid('beginEdit',rowIndex);//�����༭������Ҫ�༭����
			 adrEvtEditRow=rowIndex;
		}
	}
	
	var selAdrEvtListComponent = new ListComponent('seladrevtlist', columns, '', option);
	selAdrEvtListComponent.Init();
 
  $('#textAdrEvtAlise').val("");
	//������Ӧ/�¼����ƻس��¼�
	$('#textAdrEvtAlise').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input=$.trim($("#textAdrEvtAlise").val());
			if (input!=""){
				$('#adrevtlist').datagrid({
					url:url+'?action=GetAdrEvent',	
					queryParams:{
						params:input
					}
				});
			}	
		}
	});
	modAdrEvtList(); //�����Ѿ�ѡ��ķ�Ӧ��Ϣ
}

/// �����Ѿ�ѡ��ķ�Ӧ��Ϣ
function modAdrEvtList()
{
	if($('#AdrEventItms').val()==""){return;}
	var adrEventItms=$('#AdrEventItms').val(); //��ȡ�Ѵ��ڲ�����Ӧ����
	var adrEventItmArr=adrEventItms.split("||");
	var tempArr=[];
	for(var i=0;i<adrEventItmArr.length;i++){
		var adrEvtItmArr=adrEventItmArr[i].split("^");
		var adrEvtItmDesc=adrEvtItmArr[1].split("[")[0];
		var adrEvtItmSerLvDesc=adrEvtItmArr[1].split("[")[1].replace(/]$/gi,"");
        AdrEvtSerLvID="G"
		if (adrEvtItmSerLvDesc=="����")
		{
			AdrEvtSerLvID="S";
		}
		tempArr.push("{\"AdrEvtID\":\""+adrEvtItmArr[0]+"\",\"AdrEvtDesc\":\""+adrEvtItmDesc+"\",\"AdrEvtSerLvID\":\""+AdrEvtSerLvID+"\",\"AdrEvtSerLvDesc\":\""+adrEvtItmSerLvDesc+"\"}");		
	}
	var jsdata = '{"total":'+adrEventItmArr.length+',"rows":['+tempArr.join(",")+']}';
	var data = $.parseJSON(jsdata);
	$('#seladrevtlist').datagrid("loadData",data);//�����ݰ󶨵�DataGrid��
}

/// ����ҩƷ������Ӧ�������δ���
function createAdrEvtRetWindow()
{
	$('#AdrEvtRetWin').window({
		title:'����ҩƷ������Ӧ��������',
		collapsible:false,
		border:false,
		closed:false,
		width:500,
		height:300,
		onClose:function(){
			$("input[type=checkbox]").each(function(){
				if($('#'+this.id).is(':checked')){
					$('#serdesc').val($('#'+this.id+"S").html());
					$('#modser').css("display","");
					$('#serdesc').css("display","");
				}
			});

			if($('#serdesc').val()==""){
				$.messager.alert("��ʾ:","ѡ������ʱ,���빴ѡ��������!");
				return false;
			}
		}
	}); 

	$('#AdrEvtRetWin').window('open');
}

//���ر�����Ϣ
function InitAdrReport(adrRepID)
{
	if(adrRepID==""){return;}
		
	var adrRepDataList="";
	//��ȡ������Ϣ
	$.ajax({
   	    type: "POST",
        url: url,
	    data: {action:'getAdrRepInfo',adrRepID:adrRepID},
        success: function(jsonString){
	        var adrRepObj = jQuery.parseJSON(jsonString);
		    $('#adrRepID').val(adrRepObj.adrRepID);    //����ID
		    $('#adrrRepCode').val(adrRepObj.adrRepNo); //���
			if (adrRepObj.adrRepPri == "10"){             //���ȼ�
				$('#firrep').attr("checked",'true');
			}
			if(adrRepObj.adrRepPri == "11"){
				$('#trarep').attr("checked",'true'); 
			}
	
			//�Ƿ��µ�
			if(adrRepObj.adrRepNew == "Y"){
				$('#new').attr("checked",'true'); 
			}
			
			//��������
			$('#RT'+adrRepObj.adrRepType).attr("checked",'true'); 
			if(adrRepObj.adrRepType == "11"){  //������������
				$('#modser').css("display","");
				$('#serdesc').css("display","");
				$('#serdesc').val(adrRepObj.adrrRepTSDesc); 
			}
				
			//���浥λ���
			$('#RD'+adrRepObj.adrrDeptType).attr("checked",'true'); 
			$('#RepDeptTypeOther').val(adrRepObj.adrrDeptElse);
			if(adrRepObj.adrrDeptType == "99"){
				$('#RepDeptTypeOther').attr("disabled",false);
			}
			
			//������Ϣ
			$('#adrrPatID').val(adrRepObj.adrrPatID); //����ID
			$('#PatName').val(adrRepObj.adrrPatName);   //��������
			$('#PatSex').combobox('setValue',adrRepObj.adrrPatSex);     //�Ա�
			$('#PatAge').val(adrRepObj.adrrPatAge);  //����
			$('#PatDOB').datebox("setValue",adrRepObj.adrrPatDOB);      //��������
			$('#PatNation').combobox('setValue',adrRepObj.adrrPatNation);  //����
			$('#PatWeight').val(adrRepObj.adrrPatWeight);  //����
			$('#PatContact').val(adrRepObj.adrrPatContact); //��ϵ��ʽ
			$('#PatMedNo').val(adrRepObj.adrrPatMedNo);   //������
			
			//����ҩƷ�����¼�
			$('#EH'+adrRepObj.adrrEvtHis).attr("checked",'true'); 
			$('#adrrEventHistDesc').val(adrRepObj.adrrEvtHisDesc); 
			if(adrRepObj.adrrEvtHis == "10"){
				$('#adrrEventHistDesc').attr("disabled",false);
			}
			
			//����ҩƷ�����¼�
			$('#EF'+adrRepObj.adrrEvtFam).attr("checked",'true'); 
			$('#adrrEventFamiDesc').val(adrRepObj.adrrEvtFamDesc); 
			if(adrRepObj.adrrEvtFam == "10"){
				$('#adrrEventFamiDesc').attr("disabled",false);
			}
			
			//�¼����
			$('#DateOccu').datebox("setValue",adrRepObj.adrrEvtDateOcc);
			$('#RR'+adrRepObj.adrrEvtRes).attr("checked",'true'); 
			if(adrRepObj.adrrEvtRes == "13"){
				$('#adrrEventRSeqDesc').val(adrRepObj.adrrEvtResDesc);
				$('#adrrEventRSeqDesc').attr("disabled",false);
			}else if(adrRepObj.adrrEvtRes == "14"){
				$('#adrrEventRDRDesc').val(adrRepObj.adrrEvtResDesc);
				$('#adrrEventRDRDesc').attr("disabled",false);
				$('#adrrEventRDRDate').datebox({disabled:false});
				//����ʱ��
				$('#adrrEventRDRDate').datetimebox('setValue',adrRepObj.adrrEvtDRes+" "+adrRepObj.adrrEvtTRes);
			};
				
			//ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ�����
			$('#ES'+adrRepObj.adrrEvtSRes).attr("checked",'true'); 
			
			//�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
			$('#ET'+adrRepObj.adrrEvtTakAg).attr("checked",'true'); 
			
			//��ԭ��������Ӱ��
			$('#RE'+adrRepObj.adrrEvtEff).attr("checked",'true'); 
			
			//�������
			$('#ECU'+adrRepObj.adrrEvtCUser).attr("checked",'true'); 
			$('#adrrEventUserOfReport').val(adrRepObj.adrrEvtRepUser);
				
			//���浥λ����
			$('#ECD'+adrRepObj.adrrEvtCDept).attr("checked",'true'); 
			$('#adrrEventDeptOfReport').val(adrRepObj.adrrEvtRepDept);
				
			//��������Ϣ
			$('#adrrReportUserTel').val(adrRepObj.adrrEvtUserOfRepTel);
			$('#RU'+adrRepObj.adrrEvtCarOfRepUser).attr("checked",'true'); 
			$('#adrrCareerOfRepUserOthers').val(adrRepObj.adrrEvtCarOfRepElse);
			$('#adrrEmailOfRepUser').val(adrRepObj.adrrEvtEOfRepUser);
			$('#adrrSignOfRepUser').val(adrRepObj.adrrEvtProDeptCon);
			$('#adrrSignOfRepDept').combobox('setValue',adrRepObj.adrrEvtProDeptID);
			if(adrRepObj.adrrEvtCarOfRepUser == "99"){
				$('#adrrCareerOfRepUserOthers').attr("disabled",false);
			} 
				
			//���浥λ
			$('#adrrRepDeptName').combobox('setValue',adrRepObj.HospID);
			$('#adrrRepDeptContacts').val(adrRepObj.adrrEvtProDeptCon);
			$('#adrrRepDeptTel').val(adrRepObj.adrrEvtProDeptTel);
			
			$('#adrrRepRemark').val(adrRepObj.adrrEvtRemark);//��ע
			$('#adrrRepDate').datebox("setValue",adrRepObj.adrRepDate); 	 //��������
			EpisodeID=adrRepObj.adrRepPaAdm; //����ADM
			
			//ҽԺ����
			$('#Hospital').combobox('setValue',adrRepObj.HospID);
			AdrRepInitStatDR=adrRepObj.adrrEvtInitStatDR;
			//editFlag״̬Ϊ0,�ύ���ݴ水ť������
			var adrRepCurStatDR=adrRepObj.adrrEvtCurStatDR;
			if(adrRepCurStatDR!=""){
				//$("a:contains('�ύ')").attr("disabled",true);
				$("a:contains('�ݴ�')").attr("disabled",true);
			}
				
			//ԭ������
			$('#adrrPatOriginalDis').val(adrRepObj.adrRepDiagDesc);
			$('#MRCICItms').val(adrRepObj.adrRepDiagList);
			
			//������Ӧ
			$('#AdrEvent').val(adrRepObj.adrRepEvtDesc);
			$('#AdrEventItms').val(adrRepObj.adrRepEvtList);
				
			var adrRepImpInfo=adrRepObj.adrRepImpInfo;
			adrRepImpInfoArr=adrRepImpInfo.split("||");
			for(var k=0;k<adrRepImpInfoArr.length;k++){
				var tmpstr=adrRepImpInfoArr[k].split("^");
				$('#II'+tmpstr[0]).attr("checked",'true'); 
				if(tmpstr[0]=="99"){
					$('#iiothersdesc').val(tmpstr[1]);
					$('#iiothersdesc').attr("disabled",false);
				}
			}
			
			//������Ӧ��������
			var adrRepProcDesc=adrRepObj.adrRepProcDesc;
			var adrRepProcArr=adrRepProcDesc.split("^");
			$('#adrrProcessDesc').val(adrRepProcArr[3]);

       },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });
    
    //���ɺͲ��ÿ��Ǻϲ���һ��,��ʱ�ȷֿ�ȡ����
	$('#susdrgdg').datagrid({
		url:url+'?action=getAdrRepDrgItm&adrRepID='+adrRepID,	
		queryParams:{
			params:10
		}
	});
	
	//����
	$('#blenddg').datagrid({
		url:url+'?action=getAdrRepDrgItm&adrRepID='+adrRepID,	
		queryParams:{
			params:11
		}
	});
}

//���ر���Ĭ����Ϣ
function InitPatientInfo(PatientID,EpisodeID)
{
	if(EpisodeID==""){return;}
		$.ajax({
			type: "POST",
			url: url+'?action=GetPatEssInfo',
			data: {PatientID:PatientID,EpisodeID:EpisodeID},
			success: function(jsonString){

				var PatientInfoObj = jQuery.parseJSON(jsonString);
				//������Ϣ
				$('#adrrPatID').val(PatientInfoObj.PatientID); //����ID
				$('#PatName').val(PatientInfoObj.patname); //��������
				$('#PatSex').combobox('setValue',PatientInfoObj.sexId);  //�Ա�
				$('#PatAge').val(PatientInfoObj.patage);  //����
				$('#PatDOB').datebox("setValue",PatientInfoObj.patdob);  //��������
				$('#adrrPatOriginalDis').val(PatientInfoObj.patdiag);  	 //ԭ������
				var patdiagArrList = [];
				var patdiagArr = PatientInfoObj.patdiag.split(",");
				for(var k=0; k<patdiagArr.length; k++){
					patdiagArrList.push("^"+patdiagArr[k]);
				}
				$('#MRCICItms').val(patdiagArrList.join("||"));
				$('#PatNation').combobox('setValue',PatientInfoObj.nationdr);  //����
				$('#PatMedNo').val(PatientInfoObj.patno); //������
				$('#PatWeight').val(PatientInfoObj.weight);  //����
				$('#PatContact').val(PatientInfoObj.modphone); //��ϵ��ʽ
				$('#Hospital').combobox('setValue',LgHospID);   //ҽԺ����
				$('#adrrRepDeptName').combobox('setValue',LgHospID); //���浥λ
				$('#adrrRepDate').datebox("setValue",PatientInfoObj.sysdate); //��������
				$('#adrrEventUserOfReport').val(LgUserName);   //����������
				$('#adrrSignOfRepUser').val(LgUserName);       //��������Ϣ
				$('#adrrRepDeptContacts').val(LgUserName);     //��ϵ��
				$('#adrrSignOfRepDept').combobox('setValue',LgCtLocID);     //���沿��
				$('#adrrEventRDRDate').datebox({disabled:true}); //����ʱ��
				AdrRepInitStatDR = PatientInfoObj.adrrEvtInitStatDR;
				$('#RD10').attr("checked",'true');  //���浥λ���Ĭ��Ϊҽ�ƻ���
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

///����ǰ,������������Լ��
function saveBeforeCheck()
{
	if(currEditRow >= 0){
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	}
	//1���������ȼ�
	var adrrPriority="";
    $("input[type=checkbox][name=adrrPriority]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrPriority=this.value;
		}
	})
	if(adrrPriority==""){
		$.messager.alert("��ʾ:","���������ȼ�������Ϊ�գ�");
		return false;
	}
	
	//2���������
	var adrrRepCode=$('#adrrRepCode').val();
	if(adrrRepCode==""){
		//$.messager.alert("��ʾ:","��������롿����Ϊ�գ�");
		//return false;
	}
	adrrRepCode=adrrRepCode.replace(/[ ]/g,""); //ȥ�������еĿո�

	//3����������
	var adrrRepType="",adrrRepTSDesc="",adrrRepTypeNew="";
    $("input[type=checkbox][name=adrrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepType=this.value;
		}
	})
	if($("#new").is(':checked')){
		adrrRepTypeNew="Y"; 
	}
	if((adrrRepType=="")&&(adrrRepTypeNew=="")){
		$.messager.alert("��ʾ:","���������͡�����Ϊ�գ�");
		return false;
	}else if(adrrRepType=="11"){
		adrrRepTSDesc=$("#serdesc").val();  //����Ϊ����ʱ,��ȡ������
	}
	if((adrrRepTSDesc=="")&(adrrRepType=="11")){
		$.messager.alert("��ʾ:","���������͡�Ϊ����ʱ,��ѡ����������������");
		return false;
	}
	
	//4�����浥λ���
	var adrrRepDeptType="";
	var adrrRepDeptTypeDesc="";
    $("input[type=checkbox][name=adrrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepDeptType=this.value;
		}
	})
	adrrRepDeptTypeDesc=$('#RepDeptTypeOther').val();
	if(adrrRepDeptType==""){
		$.messager.alert("��ʾ:","�����浥λ��𡿲���Ϊ�գ�");
		return false;
	}
	
	//5����ϵ��ʽ
	if($('#PatContact').val()==""){
		$.messager.alert("��ʾ:","����ϵ��ʽ������Ϊ�գ�");
		return false;
	}
	
	//6��ԭ������
	if($('#adrrPatOriginalDis').val()==""){
		$.messager.alert("��ʾ:","��ԭ������������Ϊ�գ�");
		return false;
	}
	
	//7������ҩƷ������Ӧ/�¼�
	if($('#EH10').is(':checked')){
		if($('#adrrEventHistDesc').val()==""){
			$.messager.alert("��ʾ:","����д������ҩƷ������Ӧ/�¼�����");
			return false;
		}
	}
	
	//8������ҩƷ������Ӧ/�¼�
	if($('#EF10').is(':checked')){
		if($('#adrrEventFamiDesc').val()==""){
			$.messager.alert("��ʾ:","����д������ҩƷ������Ӧ/�¼�����");
			return false;
		}
	}
	
	//9��������Ӧ/�¼�����
	//if($('#AdrEvent').val()=="")
	if ($('#AdrEventItms').val()==""){
		$.messager.alert("��ʾ:","��������Ӧ/�¼����ơ�����Ϊ�գ�");
		return false;
	}
	
	//10��������Ӧ/�¼�����ʱ��
	if($('#DateOccu').datebox('getValue')==""){
		$.messager.alert("��ʾ:","��������Ӧ/�¼�����ʱ�䡿����Ϊ�գ�");
		return false;
	}
	
	//11��������Ӧ/�¼���������
	if($('#adrrProcessDesc').val()==""){
		$.messager.alert("��ʾ:","��������Ӧ/�¼���������������Ϊ�գ�");
		return false;
	}
	
	//12��������Ӧ/�¼��Ľ��
	var adrrEventResult="";
	$("input[type=checkbox][name=adrrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventResult=this.value;
		}
	})
	if(adrrEventResult==""){
		$.messager.alert("��ʾ:","��������Ӧ/�¼��Ľ��������Ϊ�գ�");
		return false;
	}
	if(adrrEventResult=="13"){
		if($('#adrrEventRSeqDesc').val()==""){
			$.messager.alert("��ʾ:","��������Ӧ/�¼��Ľ��Ϊ�к���֢��,����д��������֡���");
			return false;
		}
	}
	if(adrrEventResult=="14"){
		if($('#adrrEventRDRDesc').val()==""){
			$.messager.alert("��ʾ:","��������Ӧ/�¼��Ľ��Ϊ������,����д��ֱ�����򡿣�");
			return false;
		}
		var adrrEventResultDate=$('#adrrEventRDRDate').datetimebox('getValue');
		if(adrrEventResultDate==""){
			$.messager.alert("��ʾ:","��������Ӧ/�¼��Ľ��Ϊ������,����д������ʱ�䡿��");
			return false;
		}
		var adrrEventDateResult=adrrEventResultDate.split(" ")[0];
		if(!compareSelTimeAndCurTime(adrrEventDateResult)){
			$.messager.alert("��ʾ:","������ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
			return false;	
		}
	}
	
	//13��ͣҩ���Ƿ����
	var adrrEventStopResultt="";
    $("input[type=checkbox][name=adrrEventStopResultt]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventStopResultt=this.value;
		}
	})
	if(adrrEventStopResultt==""){
		$.messager.alert("��ʾ:","����д��ͣҩ���˲����Ƿ���᡿��");
		return false;
	}
	
	//14���ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
	var adrrEventTakingAgain="";
    $("input[type=checkbox][name=adrrEventTakingAgain]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventTakingAgain=this.value;
		}
	})
	if(adrrEventTakingAgain==""){
		$.messager.alert("��ʾ:","����д���ٴ�ʹ�ÿ���ҩƷ���˲��顿��");
		return false;
	}
	
	//15����ԭ��������Ӱ��
	var adrrEventEffectOfTreatment="";
    $("input[type=checkbox][name=adrrEventEffectOfTreatment]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventEffectOfTreatment=this.value;
		}
	})
	if(adrrEventEffectOfTreatment==""){
		$.messager.alert("��ʾ:","����д������������Ӧ��ԭ��������Ӱ�졿��");
		return false;
	}
	
	//16������������
	var adrrEventCommentOfUser="";
    $("input[type=checkbox][name=adrrEventCommentOfUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventCommentOfUser=this.value;
		}
	})
	if(adrrEventCommentOfUser==""){
		$.messager.alert("��ʾ:","���桶����������֮���������ۡ�����Ϊ�գ�");
		return false;
	}
	
	if($('#adrrEventUserOfReport').val()==""){ //������ǩ��
		$.messager.alert("��ʾ:","��������ǩ�֡�����Ϊ�գ�");
		return false;
	}
	
	//17����������ϵ�绰
	if($('#adrrReportUserTel').val()==""){
		$.messager.alert("��ʾ:","����������ϵ�绰������Ϊ�գ�");
		return false;
	}
	
	//19����������
	if($('#adrrEmailOfRepUser').val()==""){
		$.messager.alert("��ʾ:","�������˵������䡿����Ϊ�գ�");
		return false;
	}
	
	//20��ǩ��
	if($('#adrrSignOfRepUser').val()==""){
		$.messager.alert("��ʾ:","��������ǩ��������Ϊ�գ�");
		return false;
	}
	
	//21�����沿��
	if($('#adrrSignOfRepDept').combobox('getValue')==""){
		$.messager.alert("��ʾ:","�����沿�š�����Ϊ�գ�");
		return false;
	}
	
	//22��������ְҵ
	var adrrCareerOfRepUser="";
	$("input[type=checkbox][name=adrrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrCareerOfRepUser=this.value;
		}
	})
	if(adrrCareerOfRepUser==""){
		$.messager.alert("��ʾ:","��������ְҵ������Ϊ�գ�");
		return false;
	}
	// ����
	if(adrrCareerOfRepUser=="99"){
		if($('#adrrCareerOfRepUserOthers').val()==""){
			$.messager.alert("��ʾ:","����д��������ְҵ������������");
			return false;	
		}
	}
	
	//23������ҩƷ
	var quitflag=0;semptyflag=0;bemptyflag=0;
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			semptyflag = 1;
			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б����š�����Ϊ�գ�");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ʼʱ�䡿����Ϊ�գ�");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б�����ʱ�䡿����Ϊ�գ�");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ҩԭ�򡿲���Ϊ�գ�");
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	//24������ҩƷ
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			bemptyflag = 1;
			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б����š�����Ϊ�գ�");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ʼʱ�䡿����Ϊ�գ�");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б�����ʱ�䡿����Ϊ�գ�");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ҩԭ�򡿲���Ϊ�գ�");
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	if((semptyflag==0)&(bemptyflag==0)){
		$.messager.alert("��ʾ:","���ɺͲ���ҩƷ�б���ͬʱΪ�գ�");
		return false;
		}
	return true;
}

//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///���浥λ���
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}		
		///ȡ������֢
		if(id=="RR13"){
			$('#adrrEventRSeqDesc').attr("disabled",false);
		}
		///ȡ��ֱ������
		if(id=="RR14"){
			$('#adrrEventRDRDesc').attr("disabled",false);
			$('#adrrEventRDRDate').datebox({disabled:false});
		}
	    ///������ְҵ
		if(id=="RU99"){
			$('#adrrCareerOfRepUserOthers').attr("disabled",false);
		}    
		///���浥λ���
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EH10"){
			$('#adrrEventHistDesc').attr("disabled",false);
			createAdrEvtEHWindow();
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EF10"){
			$('#adrrEventFamiDesc').attr("disabled",false);
			createAdrEvtEFWindow();
		}
		///�����Ҫ��Ϣ
		if(id=="II99"){
			$('#iiothersdesc').attr("disabled",false);
		}
	}else{
		///ȡ������֢
		if(id=="RR13"){
			$('#adrrEventRSeqDesc').val("");
			$('#adrrEventRSeqDesc').attr("disabled","true");
		}
		///ȡ��ֱ������
		if(id=="RR14"){
			$('#adrrEventRDRDesc').val("");
			$('#adrrEventRDRDesc').attr("disabled","true")
			$('#adrrEventRDRDate').datetimebox('setValue',"");
			$('#adrrEventRDRDate').datebox({disabled:true});
		}	
	    ///������ְҵ
		if(id=="RU99"){
			$('#adrrCareerOfRepUserOthers').val("");
			$('#adrrCareerOfRepUserOthers').attr("disabled","true");
		}    
		///���浥λ���
		if(id=="RD99"){
			$('#RepDeptTypeOther').val("");
			$('#RepDeptTypeOther').attr("disabled","true");
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EH10"){
			$('#adrrEventHistDesc').val("");
			$('#adrrEventHistDesc').attr("disabled","true");
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EF10"){
			$('#adrrEventFamiDesc').val("");
			$('#adrrEventFamiDesc').attr("disabled","true");
		}
		///�����Ҫ��Ϣ
		if(id=="II99"){
			$('#iiothersdesc').val("");
			$('#iiothersdesc').attr("disabled","true");
		}
	}
}

//ѡ��ʱ���뵱ǰʱ��Ƚ�
function compareSelTimeAndCurTime(SelDate)
{
	var SelDateArr=SelDate.split("-");
	var SelYear=SelDateArr[0];
	var SelMonth=parseInt(SelDateArr[1]);
	var SelDate=parseInt(SelDateArr[2]);
	
	var myDate=new Date();
	var curYear=myDate.getFullYear();
	if(SelYear>curYear){
		return false;
	}
	var curMonth=myDate.getMonth()+1;
	if((SelYear==curYear)&(SelMonth>curMonth)){
		return false;
	}
	var curDate=myDate.getDate();
	if((SelYear==curYear)&(SelMonth==curMonth)&(SelDate>curDate)){
		return false;
	}
	return true;
}

//����ҩƷ������Ӧ/�¼�����
function createAdrEvtEHWindow()
{
	$('#AdrEvtEHWin').window({
		title:'����ҩƷ������Ӧ/�¼�',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:400
	}); 

	$('#AdrEvtEHWin').window('open');
	InitAdrEvtEHWinPanel();
}

///��ʼ������ҩƷ������Ӧ/�¼�����
function InitAdrEvtEHWinPanel()
{
	var adrEvtEHEditRow=""; //��ǰ�༭��
	var columns=[[
		{field:'AdrEvtEHDrug',title:'ҩƷ����',width:200,editor:texteditor},
		{field:'AdrEvtEHDesc',title:'������Ӧ����',width:120,editor:texteditor}
	]];
  
  	var option = {
	  	toolbar: [{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtEHItemArr=[];adrEvtEHItems="";
				if(adrEvtEHEditRow>="0"){
					$("#adrEvtEHList").datagrid('endEdit', adrEvtEHEditRow);//�����༭������֮ǰ�༭����
				}
				var items = $('#adrEvtEHList').datagrid('getRows');
				$.each(items, function(index, item){
					if(item.AdrEvtEHDrug!=""){
						adrEvtEHItemArr.push(item.AdrEvtEHDrug+"_"+item.AdrEvtEHDesc);
					}
				})
				adrEvtEHItems=adrEvtEHItemArr.join(",");
				$('#adrrEventHistDesc').val(adrEvtEHItems);
				$('#AdrEvtEHWin').window('close');
			}
		},{
			text:'��ӿ���',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEHEditRow>="0"){
					$("#adrEvtEHList").datagrid('endEdit', adrEvtEHEditRow);//�����༭������֮ǰ�༭����
				}
				$("#adrEvtEHList").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
					index: 0, // ������0��ʼ����
					row: {AdrEvtEHDrug:'',AdrEvtEHDesc:''}
				});
				$("#adrEvtEHList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
				adrEvtEHEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#adrEvtEHList').datagrid('deleteRow',rowIndex);
		}
	};
  	var adrEvtEHListComponent = new ListComponent('adrEvtEHList', columns, '', option);
	adrEvtEHListComponent.Init();
	
	///����ҳ�����ݵ��б���
	if($('#adrrEventHistDesc').val()!=""){
		var adrrEventHistDesc=$('#adrrEventHistDesc').val();
		var adrrEventHistDescArr=adrrEventHistDesc.split(",");
		var tempArr=[];
		for(var k=0;k<adrrEventHistDescArr.length;k++){
			tempArr.push("{\"AdrEvtEHDrug\":\""+adrrEventHistDescArr[k].split("_")[0]+"\",\"AdrEvtEHDesc\":\""+adrrEventHistDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+adrrEventHistDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEHList').datagrid("loadData",data);//�����ݰ󶨵�DataGrid��
	}
}

//����ҩƷ������Ӧ/�¼�����
function createAdrEvtEFWindow()
{
	$('#AdrEvtEFWin').window({
		title:'����ҩƷ������Ӧ/�¼�',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:400
	}); 

	$('#AdrEvtEFWin').window('open');
	InitAdrEvtEFWinPanel();
}

///��ʼ���������ҩƷ������Ӧ/�¼�����
function InitAdrEvtEFWinPanel()
{
	var adrEvtEFEditRow=""; //��ǰ�༭��
	var columns=[[
		{field:'AdrEvtEFDrug',title:'ҩƷ����',width:200,editor:texteditor},
		{field:'AdrEvtEFDesc',title:'������Ӧ����',width:120,editor:texteditor}
	]];

	var option = {
		toolbar: [{
			text:'ȷ��',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtEFItemArr=[];adrEvtEFItems="";
				if(adrEvtEFEditRow>="0"){
					$("#adrEvtEFList").datagrid('endEdit', adrEvtEFEditRow);//�����༭������֮ǰ�༭����
				}
				var items = $('#adrEvtEFList').datagrid('getRows');
				$.each(items, function(index, item){
					if(item.AdrEvtEFDrug!=""){
						adrEvtEFItemArr.push(item.AdrEvtEFDrug+"_"+item.AdrEvtEFDesc);
					}
				})
				adrEvtEFItems=adrEvtEFItemArr.join(",");
				$('#adrrEventFamiDesc').val(adrEvtEFItems);
				$('#AdrEvtEFWin').window('close');
			}
		},{
			text:'��ӿ���',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEFEditRow>="0"){
					$("#adrEvtEFList").datagrid('endEdit', adrEvtEFEditRow);//�����༭������֮ǰ�༭����
				}
				$("#adrEvtEFList").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
					index: 0, // ������0��ʼ����
					row: {AdrEvtEFDrug:'',AdrEvtEFDesc:''}
				});
				$("#adrEvtEFList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
				adrEvtEFEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#adrEvtEFList').datagrid('deleteRow',rowIndex);
		}
	};
  	var adrEvtEFListComponent = new ListComponent('adrEvtEFList', columns, '', option);
	adrEvtEFListComponent.Init();
	
	///����ҳ�����ݵ��б���
	if($('#adrrEventFamiDesc').val()!=""){
		var adrrEventFamiDesc=$('#adrrEventFamiDesc').val();
		var adrrEventFamiDescArr=adrrEventFamiDesc.split(",");
		var tempArr=[];
		for(var k=0;k<adrrEventFamiDescArr.length;k++){
			tempArr.push("{\"AdrEvtEFDrug\":\""+adrrEventFamiDescArr[k].split("_")[0]+"\",\"AdrEvtEFDesc\":\""+adrrEventFamiDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+adrrEventFamiDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEFList').datagrid("loadData",data);//�����ݰ󶨵�DataGrid��
	}
}

/// ���ǰ���
function AppBeforeCheck(drgdgid)
{
	var quitflag = 0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
    $.each(checkedItems, function(index, item){
	    if(!checkSusAndBleIfRepApp(drgdgid,item.incidesc)){
		    quitflag = 1;
		    return false;
		}
    })
    if(quitflag==1){return false;}
    return true;
}
/// �жϻ��ɺͲ���ҩƷ�Ƿ��ظ����
function checkSusAndBleIfRepApp(drgdgid,phcdesc)
{
	var quitflag = 0; message = "";
	
	/// 1������
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){

		if(item.incidesc!=""){
			if(item.incidesc == phcdesc){
				if(drgdgid == "susdrgdg"){
					message = "��ҩƷ�����,�����ظ���ӣ�";
				}else{
					message = "��ҩƷ��Ϊ����ҩƷ,����ͬʱΪ����ҩƷ��";
				}
				$.messager.alert("��ʾ:",message);
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	
	/// 2������
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){

		if(item.incidesc!=""){
			if(item.incidesc == phcdesc){
				if(drgdgid == "blenddg"){
					message = "��ҩƷ�����,�����ظ���ӣ�";
				}else{
					message = "��ҩƷ��Ϊ����ҩƷ,����ͬʱΪ����ҩƷ��";
				}
				$.messager.alert("��ʾ:",message);
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	
	return true;
}