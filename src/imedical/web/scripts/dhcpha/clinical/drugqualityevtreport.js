/// Creator: bianshuai
/// CreateDate: 2014-10-31
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;">ҩƷ�б�<span style="color:red;">[˫���м��ɱ༭]</span></span>';
//var patSexArr = [{ "val": "1", "text": "��" }, { "val": "2", "text": "Ů" },{ "val": "3", "text": "����" }]
var patientID="",EpisodeID="",dqEvtRepID="";
var editRow="";
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	dqEvtRepID=getParam("dqEvtRepID");
	curStatus=getParam("curstatus"); //liyarong 2016-09-26
	if ((EpisodeID == "")&&(dqEvtRepID == "")){//lbb 2018-09-13
    var frm = dhcsys_getmenuform();
    if (frm) {
        var adm = frm.EpisodeID.value;
        EpisodeID = adm;
       InitPatientInfo(EpisodeID);
       }
    }

	//���ý��渴ѡ��
/*	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).toggleClass('cb_active');
			setCheckBoxRelation(this.id);
		});
	});
*/	
	//���ý��渴ѡ�����
/*	var tmpid="";  //qunianpeng  2016-07-26
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).hasClass('cb_active')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($(this).hasClass('cb_active'))){
					$(this).toggleClass('cb_active');
					$('#'+this.id).removeAttr("checked");	// qunianpeng 2016-07-25
					setCheckBoxRelation(this.id);
				}
			})
		}
	});
*/
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
				setCheckBoxRelation(this.id);	
			}			
			setCheckBoxRelation(this.id);
		});	
		
	//����columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
	    {field:'incidesc',title:'��Ʒ����',width:200,align:'left'},
	    {field:'genenic',title:'ͨ����',width:160,align:'left'},
	    {field:'genenicdr',title:'genenicdr',width:80,hidden:true},
	    {field:'vendor',title:'��Ӧ��',width:200,align:'left',editor:texteditor},
	    {field:'manf',title:'������ҵ',width:100,align:'left'},
	    {field:'batexp',title:'����~Ч��',width:100,align:'left',editor:texteditor},
	    {field:'manfdr',title:'manfdr',width:80,hidden:true},
	    {field:'qty',title:'����',width:60,align:'left',editor:texteditor},
	    {field:'form',title:'����',width:80,align:'left'},
	    {field:'formdr',title:'formdr',width:80,hidden:true},
	    {field:'spec',title:'���',width:80,align:'left'},
	    {field:'packtype',title:'��װ����',width:80,align:'left',editor:texteditor},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	//����datagrid
	$('#susdrgdg').datagrid({
		title:titleNotes,    
		url:'',
		fit:true, //ҩƷ��������4,���ɹ�����  duwensheng  2016-09-05
		border:false,
		columns:columns,
		singleSelect:true,
		rownumbers:true,//�к� 
 		remoteSort:false,			//��������
		fitColumns:true,    //quninapeng 2016-09-10 ����Ӧ��С����ֹ���򻬶�
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow.toString() != "") {
               $("#susdrgdg").datagrid('endEdit', editRow); 
            } 
            $("#susdrgdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	InitdatagridRow();
	
	$('#adddrg').bind('click',addSuspectDrg); //���ҩƷ
	$('#cancel').bind('click',closeWin);  //ȡ��
	
	//�Ա�
	/*$('#PatSex').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:patSexArr
	});*/
	//hezg 2018-7-2
	var LINK_CSP="dhcapp.broker.csp"
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMCOMMON&MethodName=";
	var url = uniturl+"jsonCTSex";
	new ListCombobox("PatSex",url,'',{panelHeight:"auto"}).init();

	InitPatientInfo(EpisodeID); //��ȡ������Ϣ
	
	//����ID��Ϊ�յ������,�����Ѵ��ڱ�����Ϣ
	if(dqEvtRepID!=""){
		LoadDrgQuaEvtReport(dqEvtRepID);
		if(curStatus=="�ύ"){           //liyarong 2016-0923
		 $("a:contains('�ύ')").linkbutton('disable');
	     $("a:contains('����')").linkbutton('disable');
		 	}
	}
	
	$('input').live('click',function(){
		$("#susdrgdg").datagrid('endEdit', editRow);
	});
})

// �ı��༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ��������
function insertRow()
{
	$('#susdrgdg').datagrid('appendRow', {//��ָ����������ݣ�appendRow�������һ���������
		row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:'',packtype:''}
	});
}

// ɾ����
function deleteRow(rowIndex)
{
	//�ж���
    var rowobj={orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:'',packtype:'',vendor:'',batexp:'',qty:''};
	//��ǰ��������4,��ɾ�����������
	var rows = $('#susdrgdg').datagrid('getRows');

	if(rows.length>4){
		 $('#susdrgdg').datagrid('deleteRow',rowIndex);
	}else{
		$('#susdrgdg').datagrid('updateRow',{
			index: rowIndex, // ������
			row: rowobj
		});
	}

	// ɾ����,��������    quninapeng 2016-09-10 
	$('#susdrgdg').datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	return "<a href='#' onclick='deleteRow("+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}
//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#susdrgdg").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:'',packtype:''}
		});
	}
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
		height:520,
		minimizable:false,					/// ������С����ť
		maximized:true						/// ���(qunianpeng 2018/5/2)
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
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'spec',title:'���',width:80},
		{field:'Vendor',title:'Vendor',width:80,hidden:true},
		{field:'BatExpStr',title:'BatExpStr',width:80,hidden:true},
		{field:'qty',title:'qty',width:80,hidden:true}

	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
                pageNumber:1,  //ҳ�����ʾ��һҳ  duwensheng  2016-09-05
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		rowStyler:function(index,row){
			if (row.EndDate!=""){
				return 'background-color:pink;';
			}
		}
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
var thisrows=$('#medInfo').datagrid("getRows").length;    //wangxuejian 2016-08-31
			if (thisrows<=0){
				$('#medInfo').datagrid('loadData',{total:0,rows:[]});
			}
}

//��ӻ���ҩƷ
function addSuspectDrg()
{
	//��ҩ�б�
	var rows = $('#susdrgdg').datagrid('getRows');
	var k=0;
	for(var i=0;i<rows.length;i++)
	{
	if(rows[i].orditm!=""){
	k=k+1;}
	}
	//��ѡ��ʾ duwensheng 2016-09-12
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems==""){
	 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
	 return;
	}
		 $.each(checkedItems, function(index, item){
		 var rowobj={
	orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic,
		genenicdr:item.genenicdr, form:item.form,
		manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,spec:item.spec,vendor:item.Vendor,
		batexp:item.BatExpStr,qty:item.qty
	}
	//�б��Ѵ������ݵĻ�,��ʾ���˳�
	//duwensheng 2016-09-12
	for(var j=0;j<rows.length;j++){
	if(item.incidesc==rows[j].incidesc){
	//alert("ҩƷ�б��Ѵ���'"+rows[j].incidesc+"',���ʧ��!");
	return;
	}
	}
	if(k>3){
	$("#susdrgdg").datagrid('appendRow',rowobj);
	}else{
	$("#susdrgdg").datagrid('updateRow',{ //��ָ����������ݣ�appendRow�������һ���������
	index: k, // ������0��ʼ����
	row: rowobj
	});
	}
	k=k+1;
		 })
		$('#mwin').window('close');
    }
    
 //�رմ���
function closeWin()
{
	$('#mwin').window('close');
}

///���ز�����ҩ�б�
///�ٵ����ť��ʱ��Ϊ������ֵ�����ֵΪ���ȼ����룬��'S',����ҽ��
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID, 
			PriCode:priCode} //���ȼ�ɸѡ duwensheng 2016-09-05
	});
}

//����ҩƷ�����¼�����
function saveDrgQEvtRep(flag)
{
	if ((editRow != "")||(editRow == 0)){
		$("#susdrgdg").datagrid('endEdit', editRow); 
	}
	if((flag)&&(!saveBeforeCheck())){   //liyarong 2016-09-29
		return;
	}
	//1���������/����
	var RepLoc=$('#RepLocID').val();
	//2������ʱ��
	var RepDate=$('#RepDate').datebox('getValue');
	var RepCode=$('#RepCode').val();  //����
	
	//3��������Ϣ
	var PatID=$('#PatID').val(); //����ID
	var PatName=$('#PatName').val(); //��������
	var PatSex=$('#PatSex').combobox('getValue');;  //�Ա�
	var PatAge=$('#PatAge').val();  //����
	var PatDOB=$('#PatDOB').datebox('getValue');  //��������
	var PatMedNo=$('#PatMedNo').val(); //������/�����
	
	//�������
	var AdmLocDr=$('#AdmLocID').val();
	
	//�¼�����ʱ��
	var EvtOccDate=$('#EvtOccDate').datebox('getValue');
	
	//�¼�����ʱ��
	var DisEvtDate=$('#DisEvtDate').datebox('getValue');
	
	
		///1���¼��ּ�
	var ErrLevel="";
    	$("input[type=checkbox][name=ErrorLevel]").each(function(){ //qunianpeng 2016-07-26
	    if($(this).is(':checked')){
			ErrLevel=this.id;
		}
	})
	
	
		///2���¼������ص�
	var EvtOccLoc="",EvtOccLocDesc="",EvtOccLocId="";
    $("input[type=checkbox][name=EvtOccLoc]").each(function(){
	     if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  EvtOccLocId=this.id;
		  EvtOccLoc=$("#"+this.id).val();   
		}
	})
	
	//����-ȡ������
	if(EvtOccLocId=="EOL99"){
		var EvtOccLocDesc=$('#EvtOccLocDesc').val();
	}
		///4���Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ��������
	var RelateInfo="",RelateInfoDesc="";
    $("input[type=checkbox][name=RelateInfo]").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  RelateInfo=$("#"+this.id).val();
		}
	})
	
	RelateInfoDesc=$('#EvtRelaDesc').val();
		///5���¼���������
	var GeneProc=$('#dqEvtProc').val();
	
	
	//7���¼��������
	var HandleInfo=$('#dqEvtHandleInfo').val();
	
	//�Ƿ�����[ֱ������]��ʱ��
	var Death="N",ImCauseOfDeath="",DeathTime="";
	var dgEvtDDate="",dgEvtDTime="";
	if($('#death').is(':checked')){
		Death="Y"; //������־
		ImCauseOfDeath=$('#facOfdeath').val(); //ֱ������
		//$("#deathdate").datetimebox({disabled:false});  //zhaowuqiang
		dgEvtDeathDate=$('#deathdate').datetimebox('getValue'); //��������
		//�������� ʱ��
		if(dgEvtDeathDate!=""){
			dgEvtDDate=dgEvtDeathDate.split(" ")[0];
			dgEvtDTime=dgEvtDeathDate.split(" ")[1];
		}
		else{
			window.alert("����ʱ�䲻��Ϊ�գ���ѡ������ʱ��!!!");
			return ;
		}
	}
	
	//�ָ�����
	var RecProc="";
    $("input[type=checkbox][name=RecProc]").each(function(){
	    if($(this).is(':checked')){
	    //if($(this).hasClass('cb_active')){
			RecProc=$("#"+this.id).val();
		}
	})
	
	//�˺��̶�
	var HarmLevel="";HarmDesc="";
    $("input[type=checkbox][name=HarmLevel]").each(function(){
	    if($(this).is(':checked')){ 
		//if($(this).hasClass('cb_active')){
		HarmLevel=$("#"+this.id).val();
		}
	})
	if (HarmLevel>10){
		var HarmDesc=$('#HarmDesc'+HarmLevel).val();
	}

	//סԺʱ���Ƿ��ӳ�
	var ExtHospTime="N";
	if($('#dgExtHospTime').is(':checked')){
	//if($('#dgExtHospTime').hasClass('cb_active')){
		ExtHospTime="Y";
	}
	
	//�Ƿ�������Σ
	var CriticallyIll="N";
	if($('#CriticallyIll').is(':checked')){
	//if($('#CriticallyIll').hasClass('cb_active')){
		CriticallyIll="Y";
	}
	var CriIllReport=$('#CriIllReport').val();;
	
	
	//9���Ľ���ʩ
	var ImproMeasure=$('#dqEvtImproMeasure').val();
	
	//10����������Ϣ
	var RepUser=$('#RepUserID').val();
	
	//11�����Ҳ��Ÿ�����
	var PriOfDept=$('#PriOfDept').val();
	
	var dqEvtRepList=RepLoc+"^"+RepDate+"^"+PatID+"^"+PatName+"^"+PatSex+"^"+PatAge+"^"+PatDOB+"^"+PatMedNo+"^"+AdmLocDr+"^"+EvtOccDate;
		dqEvtRepList=dqEvtRepList+"^"+DisEvtDate+"^"+ErrLevel+"^"+EvtOccLoc+"^"+EvtOccLocDesc+"^"+RelateInfo+"^"+RelateInfoDesc+"^"+Death;
		dqEvtRepList=dqEvtRepList+"^"+ImCauseOfDeath+"^"+dgEvtDDate+"^"+dgEvtDTime+"^"+RecProc+"^"+HarmLevel+"^"+HarmDesc+"^"+ExtHospTime+"^"+CriticallyIll;
		dqEvtRepList=dqEvtRepList+"^"+CriIllReport+"^"+GeneProc+"^"+HandleInfo+"^"+ImproMeasure+"^"+RepUser+"^"+PriOfDept+"^"+RepCode;
	
	//12��ҩƷ
	var tmpItmArr=[],phcItmStr="";
	//����ҩƷ

	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm+"^"+item.phcdf+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		    item.formdr+"^"+item.manfdr+"^"+trSpecialSymbol(item.spec)+"^"+trsUndefinedToEmpty(item.packtype)+"^"+
		    trsUndefinedToEmpty(item.vendor)+"^"+trsUndefinedToEmpty(item.batexp)+"^"+trsUndefinedToEmpty(item.qty);
		    tmpItmArr.push(tmp);
		}
	})
	
	dqEvtRepDrgItmList=tmpItmArr.join("!!");

	//13���շ�����
	var dqEvtRepTriFacList=[];
	//����ȱ��
	if($("#DR10").is(':checked')){
    //if($("#DR10").hasClass('cb_active')){
		dqEvtRepTriFacList.push("10");
	}; 
	//���治��
	if($("#DR11").is(':checked')){
    //if($("#DR11").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("11");
	};
	//������� 
	if($("#DR12").is(':checked')){
   // if($("#DR12").hasClass('cb_active')){
		dqEvtRepTriFacList.push("12");
	};
	//ʹ�÷�������
	if($("#DR13").is(':checked')){
   // if($("#DR13").hasClass('cb_active')){
		dqEvtRepTriFacList.push("13");
	};
	//����
	if($("#DR99").is(':checked')){
   // if($("#DR99").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("99"+"^"+$('#DRdesc').val());
	};
	dqEvtRepTriFacList=dqEvtRepTriFacList.join("||");
	
	var dqEvtRepID=$('#dqEvtRepID').val(); //����ID
      if(flag==0){
	   var CurStatusDr="N";
	   var dqEvtRepList=dqEvtRepList+"^"+CurStatusDr;
	   }else if(flag==1){
	    var CurStatusDr="Y";
	     var dqEvtRepList=dqEvtRepList+"^"+CurStatusDr;
	   } 
	//����
    $.ajax({
   	   type: "POST",
       url: url,
       data: "action=saveDrgQEvtReport&dqEvtRepID="+dqEvtRepID+"&dqEvtRepList="+dqEvtRepList+"&dqEvtRepDrgItmList="+dqEvtRepDrgItmList+"&dqEvtRepTriFacList="+dqEvtRepTriFacList,
        success: function(jsonString){
		   var dqEvtObj = jQuery.parseJSON(jsonString);   //liyarong 2016-09-28	
	      if(dqEvtObj.ErrCode==0){	//liyarong 2016-09-28
	         if(flag==1){
				   $.messager.alert("��ʾ:","�ύ�ɹ���");	 //liyarong 2016-10-09	
				   $("a:contains('�ύ')").linkbutton('disable');
				   $("a:contains('����')").linkbutton('disable');
	
		     }else if(flag==0){
			      $.messager.alert("��ʾ:","����ɹ���");
			   }
	      }else{
		      if(flag==1){
			         $.messager.alert("��ʾ:","�ύʧ�ܣ�");
			      }else if(flag==0){
				     $.messager.alert("��ʾ:","����ʧ�ܣ�");
			      }
		     
		  }
	      LoadDrgQuaEvtReport(dqEvtObj.dqEvtRepID);   //���¼���  liyarong 2016-09-28
	        parent.Query();                 //liyarong 2016-09-28
       },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });
}

//�滻������� 2014-07-25 bianshuai
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

//���ر���Ĭ����Ϣ
function InitPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   
   $.ajax({
   type: "POST",
   url: url,
   data: "action=getRepPatInfo&AdmDr="+EpisodeID+"&LocID="+LgCtLocID,
   //dataType: "json",
   success: function(val){
		var tmp=val.split("^");
		//������Ϣ
		$('#PatID').val(tmp[0]); //����ID
		$('#PatName').val(tmp[2]); //��������
		//$('#PatName').attr("disabled","true");
		//$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[3]);  //�Ա�
		$('#PatAge').val(tmp[5]);  //����
		//$('#PatAge').attr("disabled","true");
		//$('#PatDOB').datebox({disabled:'true'});
		$('#PatDOB').datebox("setValue",tmp[6]);  //��������
		$('#PatMedNo').val(tmp[8]); //������
		//$('#PatMedNo').attr("disabled","true");
		$('#PatContact').val(tmp[10]); //��ϵ��ʽ
		$('#Hospital').val(tmp[11]);
		$('#AdmLoc').val(tmp[13]); //�������
		//$('#AdmLoc').attr("disabled","true");
		$('#AdmLocID').val(tmp[14]);
		//$('#RepDate').datebox({disabled:'true'});
		$('#RepDate').datebox("setValue",tmp[15]); //��������
		$('#EvtOccDate').datebox("setValue",tmp[15]);  //�¼���������,Ĭ�ϵ���
		$('#DisEvtDate').datebox("setValue",tmp[15]);  //�¼���������,Ĭ�ϵ���
		//$('#RepLoc').combobox('setValue',session['LOGON.CTLOCID']);  //�������,Ĭ�ϵ�ǰ��¼����
		
		$('#RepUserID').val(LgUserID);
		$('#RepUser').val(LgUserName);  //������,Ĭ�ϵ�ǰ��¼��
		//$('#RepUser').attr("disabled","true");
		
		$('#RepLocID').val(LgCtLocID);
		$('#RepLoc').val(tmp[19]);   //�������,Ĭ�ϵ�ǰ��¼����
		//$('#RepLoc').attr("disabled","true");
		
		//$('#RepCode').val(tmp[20]);    //����  qunianpeng 2016-09-23
   }})
}

//���ر�����Ϣ
function LoadDrgQuaEvtReport(dqEvtRepID)
{	
	if(dqEvtRepID==""){return;}
	var dqEvtRepDataList="";
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getDQEvtRepInfo&dgEvtRepID="+dqEvtRepID,
       //dataType: "json",
       success: function(val){
			dqEvtRepDataList=val;
			var tmp=dqEvtRepDataList.split("!");

			$('#dqEvtRepID').val(tmp[0]); //����ID
			//$('#RepLoc').attr("disabled","true");
			$('#RepLocID').val(tmp[1]);    //�������/����
			$('#RepLoc').val(tmp[2]);      //�������/����
			//$('#RepDate').datebox({disabled:'true'});
			$('#RepDate').datebox("setValue",tmp[3]); //��������

			//������Ϣ
			$('#PatID').val(tmp[4]);   //����ID
			EpisodeID=tmp[5];
			$('#PatName').val(tmp[6]); //��������
			//$('#PatName').attr("disabled","true");
			//$('#PatSex').combobox({disabled:true});
			$('#PatSex').combobox('setValue',tmp[7]);  //�Ա�
			$('#PatAge').val(tmp[8]);                  //����
			//$('#PatAge').attr("disabled","true");
			//$('#PatDOB').datebox({disabled:'true'});
			$('#PatDOB').datebox("setValue",tmp[9]);  //��������
			$('#PatMedNo').val(tmp[10]);              //������
			//$('#PatMedNo').attr("disabled","true");
			$('#AdmLocID').val(tmp[11]);
			$('#AdmLoc').val(tmp[12]);                //�������
			//$('#AdmLoc').attr("disabled","true");
			
			$('#EvtOccDate').datebox("setValue",tmp[13]);  //�¼���������
			$('#DisEvtDate').datebox("setValue",tmp[14]);  //�¼���������

			//�¼��ּ�
			$('#'+tmp[15]).toggleClass('cb_active').attr("checked",'checked');

			//�¼�������
			$('#EOL'+tmp[16]).toggleClass('cb_active').attr("checked",'checked');
			$('#EvtOccLocDesc').val(tmp[17]);
			if(tmp[16]=="99"){
				$('#EvtOccLocDesc').attr("disabled",false);
			}

			//�Ƿ���ṩ�������
			$('#ER'+tmp[18]).toggleClass('cb_active').attr("checked",'checked');
			$('#EvtRelaDesc').val(tmp[19]);
			if(+tmp[18]=="99"){
				$('#EvtRelaDesc').attr("disabled",false);
			} 

			//�Ƿ�����
			if(tmp[20]=="Y"){
				$('#death').toggleClass('cb_active').attr("checked",'checked');
				$('#facOfdeath').val(tmp[21]);
				$('#facOfdeath').attr("disabled",false);
				$('#deathdate').datetimebox("setValue",tmp[22]);
			}
			
			//�ָ�����
				$('#RP'+tmp[23]).toggleClass('cb_active').attr("checked",'checked');
			
			//�˺�����
				$('#HL'+tmp[24]).toggleClass('cb_active').attr("checked",'checked');
			$('#HarmDesc'+tmp[24]).val(tmp[25]);
			///�������˺�(��λ���̶�)
			if(tmp[24]=="12"){
				$('#HarmDesc12').attr("disabled",false);
			}
			///��ʱ�˺�(��λ���̶�)
			if(tmp[24]=="11"){
				$('#HarmDesc11').attr("disabled",false);
			}
			
			//סԺʱ���ӳ�
			if(tmp[26]=="Y"){
					$('#dgExtHospTime').toggleClass('cb_active').attr("checked",'checked');
			}
			
			//������Σ��������
			if(tmp[27]=="Y"){
				$('#CriticallyIll').toggleClass('cb_active').attr("checked",'checked');
				$('#CriIllReport').val(tmp[28]);
				$('#CriIllReport').attr("disabled",false);
			}

			//�¼���������
			$('#dqEvtProc').val(tmp[29]);

			//�¼��������
			$('#dqEvtHandleInfo').val(tmp[30]);

			//�Ľ���ʩ
			$('#dqEvtImproMeasure').val(tmp[31]);

			$('#RepUser').val(tmp[33]);  //������
			$('#RepUserID').val(tmp[32]);
			$('#PriOfDept').val(tmp[34]);  //����(����)������
			$('#RepCode').val(tmp[35]);    //����
			
			//�շ�����
			var dqEvtTriFacStr=tmp[36];
			dqEvtTriFacArr=dqEvtTriFacStr.split("||");
			for(var k=0;k<dqEvtTriFacArr.length;k++){
				var tmpstr=dqEvtTriFacArr[k].split("^");
				$('#DR'+tmpstr[0]).toggleClass('cb_active').attr("checked",'checked');
				if(tmpstr[0]=="99"){
					$('#DRdesc').val(tmpstr[1]);
					$('#DRdesc').attr("disabled",false);
				}
			}
       },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });
    
    //����ҩƷ�б�
	$('#susdrgdg').datagrid({
		url:url+'?action=getDQEvtRepDrgItm&dgEvtRepID='+dqEvtRepID,	
		queryParams:{
			params:10
		}
	});
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
function saveBeforeCheck()   //liyarong 2016-09-29
{
		///1���¼��ּ�
	var ErrorLevel=""; 
	$("input[type=checkbox][name=ErrorLevel]").each(function(){ //qunianpeng 2016-07-26
		if($(this).is(':checked')){
	//	if($(this).hasClass('cb_active')){ //qunianpeng 2016-07-26
			ErrorLevel=this.val;
		}
	})
	if(ErrorLevel==""){
		$.messager.alert("��ʾ:","���¼��ּ�������Ϊ�գ�");
		return false;
	}
	
	///2���¼������ص�
	var EvtOccLoc="",EvtOccLocDesc="",EvtOccLocId="";
    $("input[type=checkbox][name=EvtOccLoc]").each(function(){
	     if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  EvtOccLocId=this.id;
		  EvtOccLoc=$("#"+this.id).val();   
		}
	})
	if(EvtOccLoc==""){
		$.messager.alert("��ʾ:","�¼������ز���Ϊ�գ�");
		return false;
	}
	
	///3��ҩƷ�б�
	///ҩƷ�б�����༭״̬
	$("#susdrgdg").datagrid('endEdit', editRow);
	var tmpItmArr = [];
	var suspItems = $('#susdrgdg').datagrid('getRows');
		$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm+"^"+item.phcdf+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		    item.formdr+"^"+item.manfdr+"^"+trSpecialSymbol(item.spec)+"^"+trsUndefinedToEmpty(item.packtype)+"^"+
		    trsUndefinedToEmpty(item.vendor)+"^"+trsUndefinedToEmpty(item.batexp)+"^"+trsUndefinedToEmpty(item.qty);
		    tmpItmArr.push(tmp);
		}
	})
	if(tmpItmArr==""){
		$.messager.alert("��ʾ:","��ҩƷ�б�����Ϊ�գ�");
		return false;
		}

   ///4���Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ��������
	var RelateInfo="",RelateInfoDesc="";
	 $("input[type=checkbox][name=RelateInfo]").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  RelateInfo=$("#"+this.id).val();
		}
	})
		if(RelateInfo==""){
		$.messager.alert("��ʾ:","�ܷ��ṩ������ϲ���Ϊ�գ�");
		return false;
	    
	}
	 RelateInfoDesc=$('#EvtRelaDesc').val();
	///5���¼���������
	var GeneProc=$('#dqEvtProc').val();
	if($('#dqEvtProc').val()==""){
		$.messager.alert("��ʾ:","���¼���������������Ϊ�գ�");
		return false;
	}

	 ///6�������¼�������
	var dqEvtRepTriFacList=[];
	//����ȱ��
	if($("#DR10").is(':checked')){
    //if($("#DR10").hasClass('cb_active')){
		dqEvtRepTriFacList.push("10");
	}; 
	//���治��
	if($("#DR11").is(':checked')){
    //if($("#DR11").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("11");
	};
	//������� 
	if($("#DR12").is(':checked')){
    //if($("#DR12").hasClass('cb_active')){
		dqEvtRepTriFacList.push("12");
	};
	//ʹ�÷�������
	if($("#DR13").is(':checked')){
    //if($("#DR13").hasClass('cb_active')){
		dqEvtRepTriFacList.push("13");
	};
	//����
	if($("#DR99").is(':checked')){
    //if($("#DR99").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("99"+"^"+$('#DRdesc').val());
	};
	dqEvtRepTriFacList=dqEvtRepTriFacList.join("||");
	if(dqEvtRepTriFacList==""){
		$.messager.alert("��ʾ:","�������¼����ء�����Ϊ�գ�");
		return false;
	};
		//7���¼��������
	var HandleInfo=$('#dqEvtHandleInfo').val();
	if($('#dqEvtHandleInfo').val()==""){
		$.messager.alert("��ʾ:","���¼��������������Ϊ�գ�");
		return false;
	}
		//8�����Ҳ��Ÿ�����
	var PriOfDept=$('#PriOfDept').val();
	if(PriOfDept==""){
		$.messager.alert("��ʾ:","����(����)�����˲���Ϊ�գ�");
		return false;
		}
      return true ;
}

//ҳ���������
function setCheckBoxRelation(id){
//	if($('#'+id).hasClass('cb_active')){
	if($('#'+id).is(':checked')){  // qunianpeng 2016-07-26
		///�����¼�����
		if(id=="DR99"){
			$('#DRdesc').attr("disabled",false);
		}		
		///�������˺�(��λ���̶�)
		if(id=="HL12"){
			$('#HarmDesc12').attr("disabled",false);
		}
		///��ʱ�˺�(��λ���̶�)
		if(id=="HL11"){
			$('#HarmDesc11').attr("disabled",false);
			//$('#adrrEventRDRDate').datebox({disabled:false});
		}
	    ///������Σ��������(����)
		if(id=="CriticallyIll"){
			$('#CriIllReport').attr("disabled",false);
		}    
		///����(ֱ������)
		if(id=="death"){
			$('#facOfdeath').attr("disabled",false);
			$("#deathdate").datetimebox({disabled:false});  //zhaowuqiang
		}
		///�Ƿ��ܹ��ṩҩƷ��ǩ��</br>������ӡ��������
		if(id=="ER99"){
			$('#EvtRelaDesc').attr("disabled",false);
		}
		///�¼������ص�
		if(id=="EOL99"){
			$('#EvtOccLocDesc').attr("disabled",false);
		}
	}else{
		///�����¼�����
		if(id=="DR99"){
			$('#DRdesc').val("");
			$('#DRdesc').attr("disabled","true");
		}
		///�������˺�(��λ���̶�)
		if(id=="HL12"){
			$('#HarmDesc12').val("");
			$('#HarmDesc12').attr("disabled","true");
		}	
		///��ʱ�˺�(��λ���̶�)
		if(id=="HL11"){
			$('#HarmDesc11').val("");
			$('#HarmDesc11').attr("disabled","true");
		}    
	    ///������Σ��������(����)
		if(id=="CriticallyIll"){
			$('#CriIllReport').val("");
			$('#CriIllReport').attr("disabled","true");
		}
		///����(ֱ������)
		if(id=="death"){
			$('#facOfdeath').val("");
			$('#facOfdeath').attr("disabled","true");
			$("#deathdate").datetimebox({disabled:true});  //zhaowuqiang
		}
		///�Ƿ��ܹ��ṩҩƷ��ǩ��</br>������ӡ��������
		if(id=="ER99"){
			$('#EvtRelaDesc').val("");
			$('#EvtRelaDesc').attr("disabled","true");
		}
		///�¼������ص�
		if(id=="EOL99"){
			$('#EvtOccLocDesc').val("");
			$('#EvtOccLocDesc').attr("disabled","false");
		}
	}
}
