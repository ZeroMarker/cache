
var url="dhcadv.repaction.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫���м��ɱ༭]</span>';
var titleOpNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫�������/ɾ��]</span>';
var patSexArr = [{ "val": "1", "text": "��" }, { "val": "2", "text": "Ů" },{ "val": "3", "text": "����" }];
var adrEvtArr = [{"value":"S","text":'����'}, {"value":"G","text":'һ��'}];
var currEditRow="";currEditID="";advdrID="";editFlag="";patientID="";EpisodeID="";adrDataList="";
var AdvdrNextLoc="";AdvdrLocAdvice="";AdvdrReceive="";
var AdvdrInitStatDR="";AdvdrReportType="";advdrCurStatusDR=""; 
var LocDr="";UserDr="";ImpFlag="", patIDlog=""; 

var CurRepCode="drug";
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
///�Ǻű�ʾ
var AstSymbol='<span style="color:red;">*</span>';
 
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	advdrID=getParam("advdrID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
	if ((adrDataList=="")&&(advdrID=="")){
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
	        InitPatientInfo(papmi,adm);//��ȡ������Ϣ
		}
	}
    //��ѡ�����
	InitUIStatus();
	
    //�жϰ�ť�Ƿ�����
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	
 //����columns
	var columns=[[
		{field:"dgID",title:'dgID',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
	    {field:'apprdocu',title:'��׼�ĺ�',width:80,align:'left'},
	    {field:'incidesc',title:'��Ʒ����',width:180,align:'left'},
		{field:'genenic',title:AstSymbol+'ͨ������<br>(������)',width:100,align:'center'},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'manf',title:AstSymbol+'��������',width:100,align:'left'},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'batno',title:AstSymbol+'��������',width:80,align:'center',editor:texteditor},
		{field:'usemethod',title:AstSymbol+'�÷�����<br>(�μ�����;�����մ���)',width:140,align:'center'},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'dosqty',title:'dosqty',width:80,hidden:true},
		{field:'dosage',title:'dosage',width:80,hidden:true},
		{field:'starttime',title:AstSymbol+'��ʼʱ��',width:80,align:'left',editor:dateboxditor},
		{field:'endtime',title:AstSymbol+'����ʱ��',width:80,align:'left',editor:dateboxditor},
		{field:'reasondr',title:'reasondr',width:100,align:'left',editor:'text',hidden:true},
		{field:'usereason',title:AstSymbol+'��ҩԭ��',width:100,align:'left',editor:texteditor}, //medreason
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcadvEvt/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
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
	
	
	//�Ա�
	$('#PatSex').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:patSexArr
	});
		//����
	$('#PatNation').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=selNation'
	});
	
	InitdatagridRow('susdrgdg'); //��ʼ����ʾ���������
	InitdatagridRow('blenddg');  //��ʼ����ʾ���������
    //����  ��ʼ	 
   	$('#disfind').click(function(){
		createDisWindow();
	})
	$('#adrEvtFind').click(function(){
		createAdrEvtWindow();
	})
	
	$('#advdrEventHistDesc').click(function(){
		createAdrEvtEHWindow();
	})
	
	$('#advdrEventFamiDesc').click(function(){
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
	
	 //����  ����	
	
	//���˵ǼǺŻس��¼�
	$('#advdrPatID').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 var advdrPatID=$('#advdrPatID').val();
			
			 if (advdrPatID=="")
			 {
				 	$.messager.alert("��ʾ:","����id����Ϊ�գ�");
					return;
			 }
			 var advdrPatID=getRegNo(advdrPatID);
			if ((patIDlog!="")&(patIDlog!=advdrPatID)&(advdrID=="")){
				$.messager.confirm("��ʾ", "��Ϣδ����,�Ƿ��������", function (res) {//��ʾ�Ƿ�ɾ��
					if (res) {
						location.reload();
					}else{
						$('#advdrPatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=advdrPatID)&(advdrID!="")){
				location.reload();
			}
			 var input='' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'�������',width:220}, 
			 	{field:'AdmDate',title:'��������',width:80},
			 	{field:'AdmTime',title:'����ʱ��',width:80},
			 	{field:'RegNo',title:'����id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+advdrPatID ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
				
			 var win=new CreatMyDiv(input,$("#advdrPatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});
	
	//���¼����Ϊ����ʱ����ʾ���ص�ʱ���
	$('#TR10').click(function(){
		var matadrEventResultDate=document.getElementById("deathdate");
		
		if ($(this).is(':checked')) {
			matadrEventResultDate.style.display='inline';
		} else {
			matadrEventResultDate.style.display='none';
		}   
	});
	
	InitAdvReport(advdrID);//��ȡ������Ϣ
	InitRepInfo(advdrID,adrDataList);//��ȡҳ��Ĭ����Ϣ
	InitPatientInfo(patientID,EpisodeID);//��ȡ������Ϣ
	
	
	
	
   $('input').live('click',function(){
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	});

	/* $('#DateOccu').datetimebox({
		onSelect:function(date){
			if(!compareSelTimeAndCurTime($('#DateOccu').datetimebox('getValue'))){
				$.messager.alert("��ʾ:","��������Ӧ/�¼�����ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
				$('#DateOccu').datetimebox('setValue',"");
			}
		}
	}) */
	
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
	$('#advdrEventRDRDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
})


var rowhandleClick=function (rowIndex, rowData) {//˫��ѡ���б༭ 
	if ((currEditRow != "")||(currEditRow == "0")) {
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	} 
	$("#"+this.id).datagrid('beginEdit', rowIndex); 
	currEditID=this.id;
	var Sttime = $("#"+currEditID).datagrid('getEditor', {index:rowIndex, field:'starttime'});
	var Edtime = $("#"+currEditID).datagrid('getEditor', {index:rowIndex, field:'endtime'});
    
	if((rowData.starttime!="")&(rowData.starttime!=undefined)) {
		$(Sttime.target).datebox({disabled:true});
		$(Sttime.target).datebox("setValue",rowData.starttime);   //��ʼ����
	}
	if((rowData.endtime!="")&(rowData.endtime!=undefined)) {
		$(Edtime.target).datebox({disabled:true});
		$(Edtime.target).datebox("setValue",rowData.endtime);   //��������
	}
	currEditRow=rowIndex;
}
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
		editable:false
		//required: true //���ñ༭��������
	}
}


// combox�༭��
var medreason={  //������Ϊ�ɱ༭
	type: 'combobox', //���ñ༭��ʽ
	options: {
		//required: true, //���ñ༭��������
		panelHeight:"auto",
		valueField: "value", 
		textField: "text",
		url: url+'?action=SelAdrReaForMed',
		onSelect:function(option){
			var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'reasondr'});
			$(ed.target).val(option.value);  //���ÿ���ID
			var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'usereason'});
			$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
		}
	}
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
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcadvEvt/jQuery/themes/icons/edit_remove.png' border=0/></a>";
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




/// ���治����Ӧ�¼���д����
function saveAdrEventReport(flag)
{    
	///����ǰ,��ҳ���������м��
	 if((flag)&&(!saveBeforeCheck())){
		return;
	} 
	
		if(currEditRow>="0"){
		
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	}
	
	
	
	
	
	//1���������ȼ�
	var advdrPriority="";
    $("input[type=checkbox][name=advdrPriority]").each(function(){
	    if($('#'+this.id).is(':checked')){
			advdrPriority=this.value;
		  
		}
	})
	 //����ʱ��
	var advdrRepDateTime=$('#advdrRepDate').datetimebox('getValue');
	var advdrRepDate="",advdrRepTime="";
	if(advdrRepDateTime!=""){
		advdrRepDate=advdrRepDateTime.split(" ")[0];  //��������
		advdrRepTime=advdrRepDateTime.split(" ")[1];  //����ʱ��
	}
	  if(advdrRepDateTime==""){
	  $.messager.alert("��ʾ:","���桶����ʱ�����ڡ�����Ϊ�գ�");
		return;
	}
                
	//2���������
	var advdrRepCode=$('#advdrRepCode').val();
	
	advdrRepCode=advdrRepCode.replace(/[ ]/g,""); //ȥ�������еĿո�

	//3����������   4������ʱ����
	var advdrRepType="",advdrRepTSDesc="",advdrRepTypeNew="";//�Ƿ��µ�
		 if($("#new").is(':checked')){
		advdrRepTypeNew="Y";
	} 
	
    $("input[type=checkbox][name=advdrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepType=this.value;
			
		}
	})
    if(advdrRepType=="11"){
		advdrRepTSDesc=$("#serdesc").val();  //����Ϊ����ʱ,��ȡ������
	}
	if((advdrRepTSDesc=="")&(advdrRepType=="11")){
		$.messager.alert("��ʾ:","��������Ϊ����ʱ,��ѡ����������������");
		return;
	}
	                
	//5�����浥λ���
	var advdrRepDeptType="";
	//6�����浥λ����
	var advdrRepDeptTypeDesc="";
    $("input[type=checkbox][name=advdrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepDeptType=this.value;
		}
	})
	advdrRepDeptTypeDesc=$('#RepDeptTypeOther').val();

           
	//��������Ϣ

	//var advdrAdm=$('#advdrAdm').val(); //����adm��  7
	      
	var advdrPatID=$('#advdrPatID').val(); //����ID  8
	 if(advdrPatID==""){
	  $.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return;
	}
	
	var advdrPatName=$('#PatName').val(); //�������� 9
	var advdrPatSex=$('#PatSex').combobox('getValue');;  //�Ա�  10
	var advdrPatAge=$('#PatAge').val();  //����  11
	var advdrPatDOB=$('#PatDOB').datebox('getValue');  //��������  12
	var advdrPatNation=$('#PatNation').combobox('getValue');  //����  13
	var advdrPatWeight=$('#PatWeight').val();  //����   14
	var advdrPatContact=$('#PatContact').val(); //��ϵ��ʽ  15
	 
	if(advdrPatNation==""){
		$.messager.alert("��ʾ:","���������塿����Ϊ�գ�");
		return false;
	} 
	  
	//6��ԭ������
	var adrrPatOriginalDis=$('#adrrPatOriginalDis').val(); //����ID
	 
	//16��ҽԺ����
	var advdrHospital=$('#Hospital').val(); //ҽԺ����
	
	//17��������/�����
	var advdrPatMedNo=$('#PatMedNo').val(); //������/�����
	
	
	
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
	var advdrepImpInfodataList=smokhis+","+drinhis+","+gestper+","+hepahis+","+nephhis+","+allehis+","+iiothers;

	//19  20������ҩƷ������Ӧ�¼�
	var advdrEventHistory="";
	var advdrEventHistoryDesc="";
	$("input[type=checkbox][name=advdrEventHistory]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventHistory=this.value;
		}
	})
	
	// �еĻ�ȡ������
	if(advdrEventHistory=="10"){
		advdrEventHistoryDesc=$('#advdrEventHistDesc').val();
		 if(advdrEventHistoryDesc==""){
			$.messager.alert("��ʾ:","����д����ҩƷ������Ӧ�¼�������");
			return;
		} 
	}
	
	//21 22������ҩƷ������Ӧ�¼�
	var advdrEventFamily="";
	var advdrEventFamilyDesc=""; 
	$("input[type=checkbox][name=advdrEventFamily]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventFamily=this.value;
		}
	})
	
	// �еĻ�ȡ������
	if(advdrEventFamily=="10"){
		advdrEventFamilyDesc=$('#advdrEventFamiDesc').val();
		 if(advdrEventFamilyDesc==""){
			$.messager.alert("��ʾ:","����д����ҩƷ������Ӧ�¼�������");
			return;
		} 
	}
	
	//25��ҩƷ
	var tmpItmArr=[],phcItmStr="";
	//����ҩƷ
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			if(item.dosqty!=undefined){
			    var tmp="10"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
		    
		    }else{
				 var tmp="10"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosage+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
			    }
		}
	})
	//����ҩƷ
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			if(item.dosqty!=undefined){
			    var tmp="11"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
		    
		    }else{
				 var tmp="11"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosage+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
			    }
		 }
	})
	phcItmStr=tmpItmArr.join("!!");

   
	
     //26��ԭ������
	var MRCICItms=$('#MRCICItms').val();
	

	//23���¼�����  
	var advdrAdvEvent=$('#AdrEvent').val(); //DHC_PHAdrEvent DR

	//24��25�¼���������
	var advdrTimeDateOccu=$('#DateOccu').datetimebox('getValue');
	var advdrDateOccu="",advdrTimeOccu="";
	if(advdrTimeDateOccu!=""){
		advdrDateOccu=advdrTimeDateOccu.split(" ")[0];  //�¼���������
		advdrTimeOccu=advdrTimeDateOccu.split(" ")[1];  //�¼�����ʱ��
	}
	
	//26 27 ���¼��Ľ��
	var advdrEventResult="";
	var advdrEventResultDesc=""; //�������
	var advdrEventResultDate=""; //��������
	var advdrEventDateResult="",advdrEventTimeResult="";
	$("input[type=checkbox][name=advdrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventResult=this.value;
		}
	})          
	// ����֢����
	if(advdrEventResult=="13"){
		advdrEventResultDesc=$('#advdrEventRSeqDesc').val();
	}
     
    //22������ҩƷ
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
			//�������ڱ�����ڿ�ʼ����
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("��ʾ:","����ʼʱ�䡿���ܴ��ڡ�����ʱ�䡿��");
				quitflag=1;
				return false;
				}
			
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ҩԭ�򡿲���Ϊ�գ�");
				quitflag=1;
				return false;
			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("��ʾ","����ҩƷ�б���ҩԭ�򡿳���"+beyond+"����");
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
			//�������ڱ�����ڿ�ʼ���� 
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("��ʾ:","����ʼʱ�䡿���ܴ��ڡ�����ʱ�䡿��");
				quitflag=1;
				return false;
				}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ҩԭ�򡿲���Ϊ�գ�");
				quitflag=1;
				return false;

			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("��ʾ","����ҩƷ�б���ҩԭ�򡿳���"+beyond+"����");
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
		
	// ֱ������
	if(advdrEventResult=="14"){
		advdrEventResultDesc=$('#advdrEventRDRDesc').val();
		advdrEventResultDate=$('#advdrEventRDRDate').datetimebox('getValue'); //����/��ת����
		if(advdrEventResultDesc==""){
			$.messager.alert("��ʾ:","��ֱ�����򡿲���Ϊ�գ�");
			return false;
		}
		if(advdrEventResultDate==""){
			$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
			return false;
		}else{
			advdrEventDateResult=advdrEventResultDate.split(" ")[0];
			advdrEventTimeResult=advdrEventResultDate.split(" ")[1];
		}
	}
	
	//30��ͣҩ���Ƿ����
	var advdrEventStopResultt="";
    $("input[type=checkbox][name=advdrEventStopResultt]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventStopResultt=this.value;
		}
	})

	//31���ٴ�ʹ��ʱ�Ƿ��ٴγ���ͬ����Ӧ
	var advdrEventTakingAgain="";
    $("input[type=checkbox][name=advdrEventTakingAgain]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventTakingAgain=this.value;
		}
	})

	//32����ԭ������Ӱ��
	var advdrEventEffectOfTreatment="";
    $("input[type=checkbox][name=advdrEventEffectOfTreatment]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventEffectOfTreatment=this.value;
		}
	})

	//33������������֮����������
	var advdrEventCommentOfUser="";
    $("input[type=checkbox][name=advdrEventCommentOfUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventCommentOfUser=this.value;
		}
	})

	 // 34
	var advdrEventUserOfReport=$('#advdrEventUserOfReport').val(); //������ǩ��

	//35������������֮���浥λ����
	var advdrEventCommentOfDept="";
    $("input[type=checkbox][name=advdrEventCommentOfDept]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventCommentOfDept=this.value;
		}
	})

     //36
	var advdrEventDeptOfReport=$('#advdrEventDeptOfReport').val(); //����λǩ��

	//����������Ϣ 
	var advdrReportUserTel=$('#advdrReportUserTel').val();  //��������ϵ�绰  37
	var advdrCareerOfRepUser=""; //������ְҵ  38
	
	var advdrCareerOfRepUserDesc=""; //������ְҵ����  39
	$("input[type=checkbox][name=advdrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrCareerOfRepUser=this.value;
			
		}
	})
	// ����
	if(advdrCareerOfRepUser=="99"){
		advdrCareerOfRepUserDesc=$('#advdrCareerOfRepUserOthers').val();
	}
	var advdrEmailOfRepUser=$('#advdrEmailOfRepUser').val(); //����������  40
	var advdrRepName=$('#advdrRepNameID').val();  //������ǩ��  41
	 advdrRepName=UserDr;
	
	//var advdrSignOfRepUser=$('#advdrSignOfRepUser').val();   //������ǩ��  41
	// �����˿���
	var advdrRepLocDr=$('#advdrRepLocID').val(); //42
	 advdrRepLocDr=LocDr;
	//��������ְ��
	var advdrCarPrvTp=$('#advdrCarPrvTp').val();  //43

	//var advdrSignOfRepDept=$('#advdrSignOfRepDeptID').val(); //���沿��
	
	//22�����浥λ��Ϣ
	var advdrRepDeptName=""//$('#advdrRepDeptName').val();       //���浥λ  44
	var advdrRepDeptContacts=""//$('#advdrRepDeptContacts').val(); //���浥λ��ϵ�� 45
	var advdrRepDeptTel=""//$('#advdrRepDeptTel').val();           //���浥λ��ϵ�绰 46
	
	//23����ע
	var advdrRepRemark=$('#advdrRepRemark').val(); //��ע  47
	
	//��������Ӧ/�¼���������������֢״���������ٴ�����ȣ������������54  $('#advdrProcessDesc').val();
	var advdrProcessDesc="";
	var advdrProcessDesc=$('#advdrProcessDesc').val();


	//27��������Ӧ�¼�
	var adrEvtItems=$('#AdrEventItms').val();
	
	//28���ص���
	var  advdrRepImpFlag="N";
	     if(ImpFlag==""){  
		   advdrRepImpFlag=advdrRepImpFlag;
		  }else{  
	         advdrRepImpFlag=ImpFlag;
	      }
	   
	if(flag==1){
		advdrCurStatusDR=AdvdrInitStatDR;  //��ʼ״̬	
	}                   
	var advdrepDataList=advdrRepCode+"^"+advdrPriority+"^"+advdrRepType+"^"+advdrRepTSDesc+"^"+advdrRepDeptType+"^"+advdrRepDeptTypeDesc;
	advdrepDataList=advdrepDataList+"^"+EpisodeID+"^"+advdrPatID+"^"+advdrPatName+"^"+advdrPatSex+"^"+advdrPatAge+"^"+advdrPatDOB+"^"+advdrPatNation+"^"+advdrPatWeight+"^"+advdrPatContact;  //15
	advdrepDataList=advdrepDataList+"^"+advdrHospital+"^"+advdrPatMedNo+"^"+advdrepImpInfodataList+"^"+advdrEventHistory+"^"+advdrEventHistoryDesc+"^"+advdrEventFamily+"^"+advdrEventFamilyDesc; //22
	advdrepDataList=advdrepDataList+"^"+advdrAdvEvent+"^"+advdrDateOccu+"^"+advdrTimeOccu+"^"+advdrEventResult+"^"+advdrEventResultDesc;   //27
	advdrepDataList=advdrepDataList+"^"+advdrEventDateResult+"^"+advdrEventTimeResult+"^"+advdrEventStopResultt+"^"+advdrEventTakingAgain;  //31
	advdrepDataList=advdrepDataList+"^"+advdrEventEffectOfTreatment+"^"+advdrEventCommentOfUser+"^"+advdrEventUserOfReport+"^"+advdrEventCommentOfDept+"^"+advdrEventDeptOfReport; //36
	advdrepDataList=advdrepDataList+"^"+advdrReportUserTel+"^"+advdrCareerOfRepUser+"^"+advdrCareerOfRepUserDesc+"^"+advdrEmailOfRepUser; //40
	advdrepDataList=advdrepDataList+"^"+advdrRepName+"^"+advdrRepLocDr+"^"+advdrCarPrvTp+"^"+advdrRepDeptName+"^"+advdrRepDeptContacts+"^"+advdrRepDeptTel+"^"+advdrRepRemark  //47
	advdrepDataList=advdrepDataList+"^"+advdrCurStatusDR+"^"+AdvdrReportType //49
	advdrepDataList=advdrepDataList+"^"+iiothersdesc+"^"+advdrRepDate+"^"+advdrRepTime //52
	advdrepDataList=advdrepDataList+"^"+advdrProcessDesc+"^"+advdrRepTypeNew+"^"+advdrRepImpFlag //55
	

	var advdrRepAuditList="";
	if(flag==1){
		advdrRepAuditList=advdrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+AdvdrNextLoc+"^"+AdvdrLocAdvice+"^"+AdvdrReceive+"^"+AdvdrReportType;
	} 
	
	var param="advdrID="+advdrID+"&advdrepDataList="+advdrepDataList+"&ItmStr="+phcItmStr+"&AdrEvtItems="+adrEvtItems+"&advdrRepAuditList="+advdrRepAuditList; 
	//alert(param);
	$.messager.confirm("��ʾ", "�Ƿ���б�������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.ajax({
   	   			type: "POST",
      			url: url,
       			data: "action=SaveMadrReport&"+param,
       			success: function(val){
	                   //alert(val)
	      			var advdrArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (advdrArr[0]=="0") {
	      	 			$.messager.alert("��ʾ:","����ɹ�!");

			 			advdrID=advdrArr[1];
			 			InitAdvReport(advdrID);//��ȡ������Ϣ(��ȡ����)	

			 			if(flag==1){
							//$("a:contains('�ύ')").attr("disabled",true);
							//$("a:contains('�ݴ�')").attr("disabled",true);
							var buttondiv=document.getElementById("buttondiv");
							buttondiv.style.display='none';
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
		{field:'incidesc',title:'����',width:240},
		{field:'genenic',title:'ͨ����',width:140},
	    {field:'batno',title:'����',width:60,hidden:true},
	    {field:'staDate',title:'��ʼ����',width:60,hidden:true},
	    {field:'endDate',title:'��������',width:60,hidden:true},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:40},//priorty
		{field:'priorty',title:'���ȼ�',width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'��׼�ĺ�',width:80},
		{field:'manf',title:'����',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
}

//��ӻ���ҩƷ
function addSuspectDrg()
{  
	///�ж�ҩƷ�Ƿ��ظ����
   if(!AppBeforeCheck("susdrgdg")){return false;}
    
	//��ҩ�б�
	var rows = $('#susdrgdg').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var sucflag=0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("��ʾ:","��ѡ������ҩƷ��");
		return;
	}
	
    $.each(checkedItems, function(index, item){
	    //alert(item.dosage)
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    batno:item.batno,starttime:item.staDate,endtime:item.endDate,genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu, 
		    manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'susdrgdg'
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
		sucflag=1;
    })
    if(sucflag=="1"){
    	$.messager.alert("��ʾ:","��ӳɹ���");
    }
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
	
	var sucflag=0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("��ʾ:","��ѡ������ҩƷ��");
		return;
	}
	
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    batno:item.batno,starttime:item.staDate,endtime:item.endDate,genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu, 
		    manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'blenddg'
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
		sucflag=1;
    })
    if(sucflag=="1"){
    	$.messager.alert("��ʾ:","��ӳɹ���");
    }
}

//��ʼ���б�ʹ��
function InitdatagridRow(id)
{
	for(var k=0;k<4;k++)
	{
		$('#'+id).datagrid('insertRow',{
			index: k, // ������
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
		width:800,
		height:520
	}); 

	$('#diswin').window('open');
	InitDisWinPanel();
}

///��ʼ��������Ŀ����
function InitDisWinPanel()
{
	var disEditRow="";
	var columns=[[
		 {field:'MRCID',title:'MRCID',width:40},   
		 {field:'MRCDesc',title:'����',width:100,editor:texteditor}
	]];
  
	$('#dislist').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		idField:'rowid', 
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,//�к� 
		pageSize:20,
		pageList:[20,40],
		columns:columns,
		onDblClickRow:function(rowIndex, rowData){ 
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
	});


	$('#seldislist').datagrid({
		//title:'��ѡ�б�(˫�����)',
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		idField:'drgid', 
		nowrap: false,
		striped: true, 
		rownumbers:true,//�к�
		columns:columns,
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
	});

	//�������ƻس��¼�
	$('#textAlise').bind('keypress',function(event){
		 if(event.keyCode == "13"){
			 var input=$.trim($("#textAlise").val());
			 if (input!=""){
				$('#dislist').datagrid({
					url:url+'?action=GetMRCICDDx',	
					queryParams:{
						params:input
					}
				});
			 }	
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
		width:800,
		height:520
	}); 

	$('#AdrEvtWin').window('open');
	InitAdreEvtwinWinPanel();
}

///��ʼ��������Ӧ�¼�����
function InitAdreEvtwinWinPanel()
{
	var adrEvtEditRow=""; //��ǰ�༭��
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'������Ӧ����',width:100,editor:texteditor}
	]];
  
	$('#adrevtlist').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,//�к� 
		pageSize:20,
		pageList:[20,40],
		columns:columns,
		onDblClickRow:function(rowIndex, rowData){ 
			if(adrEvtEditRow>="0"){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//�����༭������֮ǰ�༭����
			}
			var tmpAdrEvtID=rowData.AdrEvtID;
			var tmpAdrEvtDesc=rowData.AdrEvtDesc;
			
			//�жϲ����¼���������Ƿ��ظ�
			var  dataList=$('#seladrevtlist').datagrid('getData'); 
			for(var i=0;i<dataList.rows.length;i++){
				if(tmpAdrEvtID==dataList.rows[i].AdrEvtID){
					$.messager.alert("��ʾ","���ݲ����ظ�!"); 
						return false;
				}
			}

			$('#seladrevtlist').datagrid('insertRow',{
				index: 0,	// index start with 0
				row: {
					AdrEvtDesc: tmpAdrEvtDesc,
					AdrEvtID: tmpAdrEvtID
				}
		    });
		}
		
	});
	//���ؼ���
	var serLvEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:adrEvtArr,
			valueField: "value", 
			textField: "text",
			required:true,
			editable:false, 
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
		{field:'AdrEvtDesc',title:'������Ӧ����',width:100,editor:texteditor},
		{field:'AdrEvtSerLvID',title:'AdrEvtSerLvID',width:60,editor:texteditor},
		{field:'AdrEvtSerLvDesc',title:'���س̶�',width:60,editor:serLvEditor}
	]];
	
	$('#seladrevtlist').datagrid({
		//title:'��ѡ�б�(˫�����)',
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		rownumbers:true,//�к�
		columns:columns,
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
					if(item.AdrEvtDesc==""){
						$.messager.alert("��ʾ:","������Ӧ���Ʋ���Ϊ�գ�");
						quitflag=1;
						return;
					}
                  /*if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("��ʾ:","������Ӧ���س̶Ȳ���Ϊ�գ�");
						quitflag=1;
						return;
					} */
					
					if(item.AdrEvtDesc!=""){
		
						adrEvtItemArr.push(item.AdrEvtID+"^"+item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
						adrEvtItmDescArr.push(item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
					}
				})
				
				if(quitflag==1){return;}
				adrEvtItems=adrEvtItemArr.join("||");
				
				//�жϲ�����Ӧ���س̶��Ƿ�Ϊ�գ�
				var advSerLv="undefined";
				AdrEvtSerLv=adrEvtItems.indexOf(advSerLv);
				if(AdrEvtSerLv>=0){
					$.messager.alert("��ʾ:","������Ӧ���س̶Ȳ���Ϊ�գ�");
					quitflag=1;
					return;
				}
				  
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
				$("#seladrevtlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
					index: 0, // ������0��ʼ����
					row: {AdrEvtID: '',AdrEvtDesc:''}
				});
				$("#seladrevtlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
				adrEvtEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seladrevtlist').datagrid('deleteRow',rowIndex);
		},
		onClickRow:function(rowIndex, rowData){
			 $("#seladrevtlist").datagrid('beginEdit',rowIndex);//�����༭������Ҫ�༭����
			 adrEvtEditRow=rowIndex;
		}
	});
    //����ά���ֵ���еĲ����¼����Ƶ���Ϣ
	$('#adrevtlist').datagrid({
		url:url+'?action=GetAdvEvent',	
		queryParams:{
			params:""
		}
	});

	//������Ӧ/�¼����ƻس��¼�
	$('#textAdrEvtAlise').bind('keypress',function(event){
		 if(event.keyCode == "13"){
			 var input=$.trim($("#textAdrEvtAlise").val());
			 if (input!=""){
				$('#adrevtlist').datagrid({
					url:url+'?action=GetAdvEvent',	
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
//�滻������� 
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
function InitAdvReport(advdrID)
{
	if(advdrID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	var advdrepDataList="";
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetMadrRepInfo&advdrID="+advdrID+"&params="+params,
       //dataType: "json",
       success: function(val){
	      	 advdrepDataList=val;
	      	 
	      	    var tmp=advdrepDataList.split("!");
	      	    
				$('#advdrID').val(tmp[0]);    //����ID
				$('#advdrRepCode').attr("disabled",true);
				$('#advdrRepCode').val(tmp[1]); //���
				if (tmp[2]=="10"){             //���ȼ�
					$('#firrep').attr("checked",true);
				}else if(tmp[2]=="11"){
					$('#trarep').attr("checked",true);
				}
				//$('#PL'+tmp[23]).attr("checked",true);
			
				//��������
				$('#RT'+tmp[3]).attr("checked",true);
				if(tmp[3]=="11"){  //������������
					$('#modser').css("display","");
					$('#serdesc').css("display","");
					$('#serdesc').val(tmp[4]);  //����ʱ����
					
				}
				
				//���浥λ���
				$('#RD'+tmp[5]).attr("checked",true);
				$('#RepDeptTypeOther').val(tmp[6]);  //��������
				if(tmp[5]=="99"){
					$('#RepDeptTypeOther').attr("disabled",false);
				}
				 
				//������Ϣ
				$('#advdrPatID').val(tmp[8]); //����ID
				$('#PatName').val(tmp[9]);   //��������
				$('#PatSex').combobox('setValue',tmp[10]);     //�Ա�
				$('#PatAge').val(tmp[11]);  //����
				$('#PatDOB').datebox("setValue",tmp[12]);      //��������
				$('#PatNation').combobox('setValue',tmp[13]);  //����
				$('#PatWeight').val(tmp[14]);  //����
				$('#PatContact').val(tmp[15]); //��ϵ��ʽ
				
				$('#Hospital').val(tmp[16]); //ҽԺ����
				
				$('#PatMedNo').val(tmp[17]);   //������
				
				//����ҩƷ�����¼�
				$('#EH'+tmp[19]).attr("checked",true);
				$('#advdrEventHistDesc').val(tmp[20]); 
				if(tmp[19]=="10"){
					$('#advdrEventHistDesc').attr("disabled",false);
				}
				//����ҩƷ�����¼�
				$('#EF'+tmp[21]).attr("checked",true);
				$('#advdrEventFamiDesc').val(tmp[22]); 
				if(tmp[21]=="10"){
					$('#advdrEventFamiDesc').attr("disabled",false);
				}
				//�¼�����
				$('#AdrEvent').val(tmp[23]);
				if(tmp[24]!=""||tmp[25]!=""){
					$('#DateOccu').datetimebox('setValue',tmp[24]+" "+tmp[25]);  //����
				}
				//�¼����
				$('#RR'+tmp[26]).attr("checked",true);
				if(tmp[26]=="13"){
					$('#advdrEventRSeqDesc').val(tmp[27]);
					$('#advdrEventRSeqDesc').attr("disabled",false);
				}else if(tmp[26]=="14"){
					$('#advdrEventRDRDesc').val(tmp[27]);
					$('#advdrEventRDRDesc').attr("disabled",false);
					$('#advdrEventRDRDate').datebox({disabled:false});
					//����ʱ��
					$('#advdrEventRDRDate').datetimebox('setValue',tmp[28]+" "+tmp[29]);
				};
				
				//ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ�����
				$('#ES'+tmp[30]).attr("checked",true);
				
				//�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
				$('#ET'+tmp[31]).attr("checked",true);
				
				//��ԭ��������Ӱ��
				$('#RE'+tmp[32]).attr("checked",true);
				
				//�������
				$('#ECU'+tmp[33]).attr("checked",true);   
				
				$('#advdrEventUserOfReport').val(tmp[34]);
				
				//���浥λ����
				$('#ECD'+tmp[35]).attr("checked",true);
				$('#advdrEventDeptOfReport').val(tmp[36]);   //����λǩ��
				
				//��������Ϣ
				$('#advdrReportUserTel').val(tmp[37]);  // ��ϵ�绰
				
				//������ְҵ
				$('#RU'+tmp[38]).attr("checked",true);
				
		        $('#advdrCareerOfRepUserOthers').val(tmp[39]); //����

			      if(tmp[38]=="99"){
					$('#advdrCareerOfRepUserOthers').attr("disabled",false);
				}
				
				$('#advdrEmailOfRepUser').val(tmp[40]); //����������  40
	    
		        $('#advdrRepNameID').val(tmp[59]);	//������
		        $('#advdrRepName').val(tmp[41]); //������
		        $('#advdrRepName').attr("disabled",true);
		 		
		        $('#advdrRepLocID').val(tmp[60]);    //�����˿���
		        $('#advdrRepLocDr').val(tmp[42]);    //�����˿���
		        $('#advdrRepLocDr').attr("disabled",true);
		        
		        $('#advdrCarPrvTp').val(tmp[43]);    //������ְ��
		 
				$('#advdrRepDeptName').val(tmp[44]);//���浥λ
				$('#advdrRepDeptName').attr("disabled","true");
				
				//$('#advdrRepDeptContacts').val(tmp[45]);  //���浥λ��ϵ��
				//$('#advdrRepDeptTel').val(tmp[46]);   //���浥λ��ϵ�绰
				
				$('#advdrRepRemark').val(tmp[47]);//��ע
				$('#advdrRepDate').datetimebox({disabled:true});
				$('#advdrRepDate').datetimebox('setValue',tmp[51]+" "+tmp[52]);	 //��������
				
				EpisodeID=tmp[7]; //����ADM  �����	
				
               /*
            	
		        //ԭ������
				$('#adrrPatOriginalDis').val(tmp[48]);
				$('#MRCICItms').val(tmp[47]);
				
				//������Ӧ
				$('#AdrEvent').val(tmp[50]);
				$('#AdrEventItms').val(tmp[49]); */
				
				var adrRepImpInfo=tmp[18];
				adrRepImpInfoArr=adrRepImpInfo.split(",");
				for(var k=0;k<adrRepImpInfoArr.length;k++){
					var tmpstr=adrRepImpInfoArr[k].split("^");
					$('#II'+tmpstr[0]).attr("checked",true);
					if(tmpstr[0]=="99"){
						$('#iiothersdesc').val(tmpstr[1]);
						$('#iiothersdesc').attr("disabled",false);
					}
				}
		
                //������Ӧ
				$('#AdrEvent').val(tmp[62]);

				$('#AdrEventItms').val(tmp[61]);
                 
             	//��������Ӧ/�¼���������������֢״���������ٴ�����ȣ������������
             	$('#advdrProcessDesc').val(tmp[53]);
				//�Ƿ��µ�
				if(tmp[54]=="Y"){
					$('#new').attr("checked",true);
				}
				
			    advdrCurStatusDR=tmp[48];
			    AdvdrReportType=tmp[49];	
			    AdvdrInitStatDR=tmp[55];	
				
				AdvdrNextLoc=tmp[56]
				AdvdrLocAdvice=tmp[57]
				AdvdrReceive=tmp[58];
				
				UserDr=tmp[59];//������ID
				LocDr=tmp[63];//����ID
		        ImpFlag=tmp[64];//��Ҫ���
			    if (advdrCurStatusDR=="")
				{
					advdrCurStatusDR=advdrCurStatusDR;
					AdvdrReceive="";
				}
				else
				{
					//advdrCurStatusDR=AdvdrInitStatDR;
					AdvdrInitStatDR=tmp[48];
					AdvdrReceive="1";
				}
				
       },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });
    //���ɺͲ��ÿ��Ǻϲ���һ��,��ʱ�ȷֿ�ȡ����
	$('#susdrgdg').datagrid({
		url:url+'?action=getAdvRepDrgItm&advdrID='+advdrID,	
		queryParams:{
			params:10
		}
	});
	
	//����
	$('#blenddg').datagrid({
		url:url+'?action=getAdvRepDrgItm&advdrID='+advdrID,	
		queryParams:{
			params:11
		}
	});

}

//���ر���Ĭ����Ϣ
function InitRepInfo(advdrID,adrDataList)
{    
	if(advdrID!=""){return;}
   	if(adrDataList==""){
		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode; 
	}
   //var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMadrInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			alert('�������ù�����,Ȼ���');
			return;
		}else{
			var tmp=val.split("^");
			$('#advdrRepDate').datetimebox({disabled:true});
			$('#advdrRepDate').datetimebox("setValue",tmp[1]);   //��������
		
			//$('#advdrRepCode').val(tmp[0]);                //�������
			$('#advdrRepCode').attr("disabled","true");    //
		
			$('#advdrEventDeptOfReport').val(LgUserName) //���浥λǩ��
			$('#advdrEventDeptOfReport').attr("disabled","true");
			$('#advdrEventUserOfReport').val(LgUserName)   //������ǩ��
			$('#advdrEventUserOfReport').attr("disabled","true");
			
			$('#advdrRepName').val(LgUserName);    //������
			$('#advdrRepName').attr("disabled","true");
		    $('#advdrRepNameID').val(LgUserID);	//������id
			$('#advdrRepLocDr').val(tmp[4]);    //�����˿���
			$('#advdrRepLocDr').attr("disabled","true");
			$('#advdrRepLocID').val(LgCtLocID);    //�����˿���id
		
			$('#advdrCarPrvTp').val(tmp[5]);    //������ְ��
			//$('#advdrCarPrvTp').attr("disabled","true");
		
			UserDr=tmp[6]
			LocDr=tmp[7]     
			AdvdrInitStatDR=tmp[2];  //����ĳ�ʼ��,״̬ 
			AdvdrReportType=tmp[3];  //��������
		}
   }})
}

//��ȡ������Ϣ
function InitPatientInfo(patientID,EpisodeID){

	//var advdrPatID=$('#advdrPatID').val(); //����ID 
	//var advdrPatID=getRegNo(advdrPatID);
    if(patientID==""||EpisodeID==""){return;}
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       success: function(val){
	  
	   	var advRepPatInfo=val;
	    var tmp=advRepPatInfo.split("^");

		$('#advdrPatID').val(tmp[0]); //����ID  �ǼǺ�
		$('#PatName').val(tmp[1]); //�������� 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //�Ա�
		$('#PatMedNo').val(tmp[5]);  //������
		$('#PatMedNo').attr("disabled","true");
		$('#PatDOB').datebox({disabled:true}); //��������
		$('#PatDOB').datebox("setValue",tmp[6]);  
		$('#PatNation').combobox('setValue',tmp[13]);  //����
		$('#PatContact').val(tmp[15]); //��ϵ��ʽ
		$('#PatWeight').val(tmp[17]);  //����
		patIDlog=$('#advdrPatID').val();
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
	if(currEditRow>="0"){
		
	 $("#"+currEditID).datagrid('endEdit', currEditRow);
	}
	
	//2���������
	var advdrRepCode=$('#advdrRepCode').val();
	/* if(advdrRepCode==""){
		$.messager.alert("��ʾ:","��������롿����Ϊ�գ�");
		return false;
	} */
	advdrRepCode=advdrRepCode.replace(/[ ]/g,""); //ȥ�������еĿո�

	//3����������
	var advdrRepType="",advdrRepTSDesc="";
    $("input[type=checkbox][name=advdrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepType=this.value;
		}
	})
    if(advdrRepType=="11"){
		advdrRepTSDesc=$("#serdesc").val();  //����Ϊ����ʱ,��ȡ������
	}
	if((advdrRepTSDesc=="")&(advdrRepType=="11")){
		$.messager.alert("��ʾ:","���������͡�Ϊ����ʱ,��ѡ����������������");
		return false;
	}
	
	//4�����浥λ���
	/* var advdrRepDeptType="";
	var advdrRepDeptTypeDesc="";
    $("input[type=checkbox][name=advdrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepDeptType=this.value;
		}
	})
	advdrRepDeptTypeDesc=$('#RepDeptTypeOther').val();
	if(advdrRepDeptType==""){
		$.messager.alert("��ʾ:","�����浥λ��𡿲���Ϊ�գ�");
		return false;
	} */
	
	
	//5����ϵ��ʽ
	if($('#PatContact').val()==""){
		$.messager.alert("��ʾ:","����ϵ��ʽ������Ϊ�գ�");
		return false;
	}
	
	//6��ԭ������
	/* if($('#adrrPatOriginalDis').val()==""){
		$.messager.alert("��ʾ:","��ԭ������������Ϊ�գ�");
		return false;
	} */
	 
	 
	//7������ҩƷ������Ӧ/�¼�if($('#'+this.id).is(':checked')){
	if($('#EH10').is(':checked')){
		if($('#advdrEventHistDesc').val()==""){
			$.messager.alert("��ʾ:","����д������ҩƷ������Ӧ/�¼�����");
			return false;
		}
	}
	
	//8������ҩƷ������Ӧ/�¼�
	if($('#EF10').is(':checked')){
		if($('#advdrEventFamiDesc').val()==""){
			$.messager.alert("��ʾ:","����д������ҩƷ������Ӧ/�¼�����");
			return false;
		}
	}
	
  /*   //23���¼�����  
	if($('#AdrEvent').val()==""){
		$.messager.alert("��ʾ:","�������¼����ơ�����Ϊ�գ�");
		return false;
		};  */

	//24��25�¼���������
	var advdrTimeDateOccu=$('#DateOccu').datetimebox('getValue');
	var advdrDateOccu="",advdrTimeOccu="";
	if(advdrTimeDateOccu!=""){
		advdrDateOccu=advdrTimeDateOccu.split(" ")[0];  //�¼���������
		advdrTimeOccu=advdrTimeDateOccu.split(" ")[1];  //�¼�����ʱ��
	}
	 if(advdrTimeDateOccu==""){
	  $.messager.alert("��ʾ:","���桾�����¼��������ڡ�����Ϊ�գ�");
		return false;
	}
     //������Ӧ/�¼���������������֢״���������ٴ�����ȣ������������54
     if($('#advdrProcessDesc').val()==""){ //������ǩ��
		$.messager.alert("��ʾ:","��������Ӧ/�¼���������������Ϊ�գ�");
		return false;
	}
	
	//26 27 ���¼��Ľ��
	var advdrEventResult="";
	var advdrEventResultDesc=""; //�������
	var advdrEventResultDate=""; //��������
	var advdrEventDateResult="",advdrEventTimeResult="";
	$("input[type=checkbox][name=advdrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventResult=this.value;
		}
	}) 
	 
	 if(advdrEventResult==""){
		$.messager.alert("��ʾ:","�������¼��Ľ��������Ϊ�գ�");
		return false;
	}        
	// ֱ������
	if(advdrEventResult=="14"){
		advdrEventResultDesc=$('#advdrEventRDRDesc').val();
		advdrEventResultDate=$('#advdrEventRDRDate').datetimebox('getValue'); //����/��ת����
		if(advdrEventResultDesc==""){
			$.messager.alert("��ʾ:","��ֱ�����򡿲���Ϊ�գ�");
			return false;
		}
		if(advdrEventResultDate==""){
			$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
			return false;
		}else{
			advdrEventDateResult=advdrEventResultDate.split(" ")[0];
			advdrEventTimeResult=advdrEventResultDate.split(" ")[1];
		}
	}
	
/* 	if($('#advdrEventUserOfReport').val()==""){ //������ǩ��
		$.messager.alert("��ʾ:","��������ǩ�֡�����Ϊ�գ�");
		return false;
	} */
	
	//17����������ϵ�绰
	if($('#advdrReportUserTel').val()==""){
		$.messager.alert("��ʾ:","����������ϵ�绰������Ϊ�գ�");
		return false;
	}
	
	//19����������
	if($('#advdrEmailOfRepUser').val()==""){
		$.messager.alert("��ʾ:","�������˵������䡿����Ϊ�գ�");
		return false;
	}
	
	//20��ǩ��
 	if($('#advdrSignOfRepUser').val()==""){
		$.messager.alert("��ʾ:","��������ǩ��������Ϊ�գ�");
		return false;
	} 
	
	//21�����沿��
	if($('#advdrSignOfRepDept').val()==""){
		$.messager.alert("��ʾ:","�����沿�š�����Ϊ�գ�");
		return false;
	}
	
	//22��������ְҵ
	var advdrCareerOfRepUser="";
	$("input[type=checkbox][name=advdrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrCareerOfRepUser=this.value;
			
		}
	})
	
	if(advdrCareerOfRepUser==""){
		$.messager.alert("��ʾ:","��������ְҵ������Ϊ�գ�");
		return false;
	}
	// ����
	if(advdrCareerOfRepUser=="99"){
		if($('#advdrCareerOfRepUserOthers').val()==""){
			$.messager.alert("��ʾ:","����д��������ְҵ������������");
			return false;	
		} 
	}
	
	//21�����沿��
	if($('#advdrSignOfRepDept').val()==""){
		$.messager.alert("��ʾ:","�����沿�š�����Ϊ�գ�");
		return false;
	}
		
	//22������ҩƷ
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
			//�������ڱ�����ڿ�ʼ����
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("��ʾ:","����ʼʱ�䡿���ܴ��ڡ�����ʱ�䡿��");
				quitflag=1;
				return false;
				}
			
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ҩԭ�򡿲���Ϊ�գ�");
				quitflag=1;
				return false;
			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("��ʾ","����ҩƷ�б���ҩԭ�򡿳���"+beyond+"����");
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
			//�������ڱ�����ڿ�ʼ���� 
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("��ʾ:","����ʼʱ�䡿���ܴ��ڡ�����ʱ�䡿��");
				quitflag=1;
				return false;
				}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("��ʾ:","����ҩƷ�б���ҩԭ�򡿲���Ϊ�գ�");
				quitflag=1;
				return false;

			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("��ʾ","����ҩƷ�б���ҩԭ�򡿳���"+beyond+"����");
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
	//if($('#'+id).hasClass('cb_active')){
		
		if($('#'+id).is(':checked')){
		///���浥λ���
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}		
		///ȡ������֢
		if(id=="RR13"){
			$('#advdrEventRSeqDesc').attr("disabled",false);
		}
		///ȡ��ֱ������
		if(id=="RR14"){
			$('#advdrEventRDRDesc').attr("disabled",false);
		    $('#advdrEventRDRDate').datetimebox({disabled:false});
		}
	    ///������ְҵ
		if(id=="RU99"){
			$('#advdrCareerOfRepUserOthers').attr("disabled",false);
		}    
		///���浥λ���
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EH10"){
			$('#advdrEventHistDesc').attr("disabled",false);
			createAdrEvtEHWindow();
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EF10"){
			$('#advdrEventFamiDesc').attr("disabled",false);
			createAdrEvtEFWindow();
		}
		///�����Ҫ��Ϣ
		if(id=="II99"){
			$('#iiothersdesc').attr("disabled",false);
		}
		///��������
		if(id=="RT11"){
			$('#serdesc').attr("disabled",false);
		}
	}else{
		///ȡ������֢
		if(id=="RR13"){
			$('#advdrEventRSeqDesc').val("");
			$('#advdrEventRSeqDesc').attr("disabled","true");
		}
		///ȡ��ֱ������
		if(id=="RR14"){
			
			$('#advdrEventRDRDesc').val("");
			$('#advdrEventRDRDesc').attr("disabled","true")
			$('#advdrEventRDRDate').datetimebox('setValue',"");
			$('#advdrEventRDRDate').datetimebox({disabled:true});
			
		}	
	    ///������ְҵ
		if(id=="RU99"){
			$('#advdrCareerOfRepUserOthers').val("");
			$('#advdrCareerOfRepUserOthers').attr("disabled","true");
		}    
		///���浥λ���
		if(id=="RD99"){
			$('#RepDeptTypeOther').val("");
			$('#RepDeptTypeOther').attr("disabled","true");
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EH10"){
			$('#advdrEventHistDesc').val("");
			$('#advdrEventHistDesc').attr("disabled","true");
		}
		///����ҩƷ������Ӧ/�¼�
		if(id=="EF10"){
			$('#advdrEventFamiDesc').val("");
			$('#advdrEventFamiDesc').attr("disabled","true");
		}
		///�����Ҫ��Ϣ
		if(id=="II99"){
			$('#iiothersdesc').val("");
			$('#iiothersdesc').attr("disabled","true");
		}
		///��������
		if(id=="RT11"){
			$('#serdesc').val("");
			$('#serdesc').hide();
			$('#serdesc').attr("disabled",false);
			
		}
	}
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
  
	$('#adrEvtEHList').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		rownumbers:true,//�к� 
		columns:columns,
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
				$('#advdrEventHistDesc').val(adrEvtEHItems);
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
	});
	///����ҳ�����ݵ��б���
	if($('#advdrEventHistDesc').val()!=""){
		var advdrEventHistDesc=$('#advdrEventHistDesc').val();
		var advdrEventHistDescArr=advdrEventHistDesc.split(",");
		var tempArr=[];
		for(var k=0;k<advdrEventHistDescArr.length;k++){
			tempArr.push("{\"AdrEvtEHDrug\":\""+advdrEventHistDescArr[k].split("_")[0]+"\",\"AdrEvtEHDesc\":\""+advdrEventHistDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+advdrEventHistDescArr.length+',"rows":['+tempArr.join(",")+']}';
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

	$('#adrEvtEFList').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		rownumbers:true,//�к� 
		columns:columns,
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
				$('#advdrEventFamiDesc').val(adrEvtEFItems);
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
	});
	///����ҳ�����ݵ��б���
	if($('#advdrEventFamiDesc').val()!=""){
		var advdrEventFamiDesc=$('#advdrEventFamiDesc').val();
		var advdrEventFamiDescArr=advdrEventFamiDesc.split(",");
		var tempArr=[];
		for(var k=0;k<advdrEventFamiDescArr.length;k++){
			tempArr.push("{\"AdrEvtEFDrug\":\""+advdrEventFamiDescArr[k].split("_")[0]+"\",\"AdrEvtEFDesc\":\""+advdrEventFamiDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+advdrEventFamiDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEFList').datagrid("loadData",data);//�����ݰ󶨵�DataGrid��
	}
}

//��.js������function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	var advdrPatID=$('#advdrPatID').val();
	var advdrPatID=getRegNo(advdrPatID);
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
	InitPatientInfo(advdrPatID,EpisodeID);
}
//�жϱ�������Ƿ����
function RepNoRepet(){
	var IDflag=0;
	if (advdrID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //��������Ԫ�ظ�ֵ
	/* //�������
	var advRepNo=$('#advdrRepCode').val();
	advRepNo=advRepNo.replace(/[ ]/g,""); //ȥ�������еĿո�
	$.ajax({
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=SeaAdvRepNo&advRepNo="+advRepNo,
		async: false, //ͬ��
		success: function(data){
			$('#repnoflag',window.parent.document).val(data); //��������Ԫ�ظ�ֵ
		}
	}); */
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
//�༭����
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
	
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+advdrID+'&RepType='+AdvdrReportType+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
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
