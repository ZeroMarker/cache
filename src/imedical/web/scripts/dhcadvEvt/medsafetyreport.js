
/// Creator: congyue
/// CreateDate: 2015-12-16
/// Description:��ҩ�����
var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "��" }, { "val": "2", "text": "Ů" },{ "val": "3", "text": "����" }];
var OccBatNo= [{ "val": "�װ�", "text": "�װ�" }, { "val": "ҹ��", "text": "ҹ��" },{ "val": "���Ӱ�", "text": "���Ӱ�" }];
var WeekNo= [{ "val": "����һ", "text": "����һ" },{ "val": "���ڶ�", "text": "���ڶ�" },{ "val": "������", "text": "������" }, 
			{ "val": "������", "text": "������" },{ "val": "������", "text": "������" },{ "val": "������", "text": "������" },{ "val": "������", "text": "������" }];
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var editDoRow="";editApRow="";editDiRow="";editNuRow="";editPaRow="";
var CurRepCode="drugerr";
var medsrID="";patientID="";EpisodeID="";editFlag="";adrDataList="",assessID="";
var MedsrInitStatDR="";medsrReportType="";medsrCurStatusDR="";medsrAdmNo="";medsrOrdItm="";
var medadrNextLoc="";medadrLocAdvice="";medadrReceive="";
var LocDr="";UserDr="";ImpFlag="", patIDlog="";
var inci="";//ҩƷid
var DocL="DocL";ApoL="ApoL";DispL="DispL";NurL="NurL";PatL="PatL";MedUseCode="";Codedata="";OrdInfo="";
var frmflag=0; //�Ƿ��ȡ�����б��־ 0 ��ȡ��1 ����ȡ
var winflag=0; //���ڱ�־ 0 �����  1 �޸Ĵ��� 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');

$(function(){
	patientID=getParam("patientID");
	EpisodeID=getParam("EpisodeID");
	medsrID=getParam("medsrID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag"); //2016-09-28
    assessID=getParam("assessID"); //����id
	if ((adrDataList=="")&&(medsrID=="")&&(frmflag==0)){
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
	        getMedsrRepPatInfo(papmi,adm);//��ȡ������Ϣ
	        
			if((papmi!="")&(adm!="")){
				$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai ���ò���ID���ɱ༭
	        }

		}
	}
    //�жϰ�ť�Ƿ�����
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				
				var ed=$("#DocL").datagrid('getEditor',{index:editDoRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'����',width:35},
		{field:"Desc",title:'����',width:150},
		{field:"Active",title:'�Ƿ����',width:100,editor:activeEditor,hidden:true},
		{field:"Correct",title:'Ӧ����',width:300,editor:texteditor},
		{field:"Error",title:'������',width:300,editor:texteditor},
		{field:"OtherDesc",title:'����',width:150,editor:texteditor},
		{field:"flag",title:'�Ƿ�ѡ��',width:150,hidden:true}
	]];
	
	//����datagrid
	$('#DocL').datagrid({
		title:'ҽ������',
		url:'',
		columns:columns,
		//pageSize:50,  // ÿҳ��ʾ�ļ�¼����
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
		height:300,
		onSelect: function (rowIndex, rowData) {//����ѡ���б༭
			MedUseCode=DocL;
			Codedata=rowData.Code;
			if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}           
           	
           	if ((editDoRow != "")||(editDoRow == "0")) {
            	$("#DocL").datagrid('endEdit', editDoRow );
			}
            $("#DocL").datagrid('beginEdit', rowIndex); 
			editDoRow = rowIndex;
           
            var ed = $('#DocL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#DocL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="1-2")
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
						if(rowData.Code=="1-4")//��ҩ;��
			            {
				            var PhcIn=$(e.target);
				            QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode);
						}
						if(rowData.Code=="1-5")//��ҩƵ��
			            {
				            var PhcFreq=$(e.target);
				            QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode);
						}
					}
				});

        },
        onUnselect:function (rowIndex, rowData) {//����ѡ���б༭
			$('#DocL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //ҩ�����    ҩƷ����
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){    
						$('#DocL').datagrid('checkRow', index);  //�����Ƿ�ѡ���ֶ����жϸ�ѡ���Ƿ�ѡ
					}
				});
			}
           if (medsrOrdItm!=""){
				$.post(url+'?action=getRepOrdInfo',{"params":medsrOrdItm}, function(data){
					OrdInfo=data;
				});
           }
		}
	});
	$('#DocL').datagrid({
		url:url+'?action=QueryMULinkItm',	//��ѯҽ������ѡ��
		queryParams:{
			params:DocL+"^"+medsrID}
	});
	//����datagrid
	$('#ApoL').datagrid({
		title:'ҩʦ����',
		url:'',
		columns:columns,
		//pageSize:50,  // ÿҳ��ʾ�ļ�¼����
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
		height:200,
		onSelect: function (rowIndex, rowData) {//����ѡ���б༭
            MedUseCode=ApoL;
            Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	} 
            
            if ((editApRow != "")||(editApRow == "0")) {
            	$("#ApoL").datagrid('endEdit', editApRow);
			}
            $("#ApoL").datagrid('beginEdit', rowIndex); 
            editApRow = rowIndex; 
            
            var ed = $('#ApoL').datagrid('getEditors', rowIndex);
	        var e = ed[1];//�̶� field:'Error' �д��ڻس��¼�
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#ApoL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="2-1")
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//����ѡ���б༭
			$('#ApoL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //ҩ�����    ҩƷ����
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#ApoL').datagrid('checkRow', index);
					}
				});
			}
		}
	});

	$('#ApoL').datagrid({
		url:url+'?action=QueryMULinkItm',	//��ѯҩʦ����ѡ��
		queryParams:{
			params:ApoL+"^"+medsrID}
	});
	//����datagrid
	$('#DispL').datagrid({
		title:'���ͻ���',
		url:'',
		columns:columns,
		//pageSize:50,  // ÿҳ��ʾ�ļ�¼����
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
		height:200,
		onSelect: function (rowIndex, rowData) {//����ѡ���б༭
            MedUseCode=DispL;
            Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}
           	
            if ((editDiRow != "")||(editDiRow == "0")) {
            	$("#DispL").datagrid('endEdit', editDiRow);
			}
            $("#DispL").datagrid('beginEdit', rowIndex);             
            editDiRow = rowIndex;
            
            var ed = $('#DispL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#DispL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="3-1")
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//����ѡ���б༭
			$('#DispL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //ҩ�����    ҩƷ����
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#DispL').datagrid('checkRow', index);
					}
				});
			}

		}
	});

	$('#DispL').datagrid({
		url:url+'?action=QueryMULinkItm',	//��ѯ���ͻ���ѡ��
		queryParams:{
			params:DispL+"^"+medsrID}
	});
	//����datagrid
	$('#NurL').datagrid({
		title:'��ʿ����',
		url:'',
		columns:columns,
		//pageSize:50,  // ÿҳ��ʾ�ļ�¼����
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
		height:300,
		onSelect: function (rowIndex, rowData) {//����ѡ���б༭
			MedUseCode=NurL;
            Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}
           	
			if ((editNuRow != "")||(editNuRow == "0")) {
            	$("#NurL").datagrid('endEdit', editNuRow);
			}
            $("#NurL").datagrid('beginEdit', rowIndex);            
            editNuRow = rowIndex;
            
            var ed = $('#NurL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#NurL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="4-2")//ҩ��
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
						if(rowData.Code=="4-4")//��ҩ;��
			            {
				            var PhcIn=$(e.target);
				            QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode);
						}
						if(rowData.Code=="4-5")//��ҩƵ��
			            {
				            var PhcFreq=$(e.target);
				            QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//����ѡ���б༭
			$('#NurL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //ҩ�����    ҩƷ����
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#NurL').datagrid('checkRow', index);
					}
				});
			}
		}
	});

	$('#NurL').datagrid({
		url:url+'?action=QueryMULinkItm',	//��ѯ��ʿ����ѡ��
		queryParams:{
			params:NurL+"^"+medsrID}
	});
	//����datagrid
	$('#PatL').datagrid({
		title:'���߻���',
		url:'',
		columns:columns,
		//pageSize:50,  // ÿҳ��ʾ�ļ�¼����
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
		height:300,
		onSelect: function (rowIndex, rowData) {//����ѡ���б༭
			MedUseCode=PatL;
			Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}
			
			if ((editNuRow != "")||(editNuRow == "0")) {
            	$("#PatL").datagrid('endEdit', editPaRow);
			}
            $("#PatL").datagrid('beginEdit', rowIndex); 
            editPaRow = rowIndex;
			
            var ed = $('#PatL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#PatL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			           
						if(rowData.Code=="5-2")//��ҩ;��
			            {
				            var PhcIn=$(e.target);
				            QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode);
						}
						if(rowData.Code=="5-3")//��ҩƵ��
			            {
				            var PhcFreq=$(e.target);
				            QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//����ѡ���б༭
			$('#PatL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //ҩ�����    ҩƷ����
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#PatL').datagrid('checkRow', index);
					}
				});
			}
		}
	});
	$('#PatL').datagrid({
		url:url+'?action=QueryMULinkItm',	//��ѯ���߻���ѡ��
		queryParams:{
			params:PatL+"^"+medsrID}
	});
	
	//�ж�����Ĳ���ID�Ƿ�Ϊ����
	 $('#PatID').bind("blur",function(){
	   var	medsrPatID=$('#PatID').val();
	   if(isNaN(medsrPatID)){
		    $.messager.alert("��ʾ:","���������֣�");
	    }
	})
	//���˵ǼǺŻس��¼�
	$('#PatID').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var medsrPatID=$('#PatID').val();
			if (medsrPatID=="")
			{
				$.messager.alert("��ʾ:","����id����Ϊ�գ�");
				return;
			}
			var medsrPatID=getRegNo(medsrPatID);
			if ((patIDlog!="")&(patIDlog!=medsrPatID)&(medsrID=="")){
				$.messager.confirm("��ʾ", "��Ϣδ����,�Ƿ��������", function (res) {//��ʾ�Ƿ�ɾ��
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.medsafetyreport.csp?adrDataList='+''";//ˢ�´���adrDataListΪ��
						ReloadJs();//ˢ�´���adrDataListΪ��
					}else{
						$('#PatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=medsrPatID)&(medsrID!="")){
				ReloadJs();//ˢ�´���adrDataListΪ��
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
				url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+medsrPatID ,
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
	
	//����
	$('#medsrOccDateTime').datetimebox({
  		onChange:function(){
	  		var medsrOccDateTime=$('#medsrOccDateTime').datetimebox('getValue');   
			if(medsrOccDateTime!="")
			{
				var medsrOccDate=medsrOccDateTime.split(" ")[0];  //��������
				var medsrOccTime=medsrOccDateTime.split(" ")[1];  //����ʱ��
			}
			getWeek(medsrOccDate);
   		}
	});
	
	//���� 2017-08-01 cy �޸� �����򴫵ݲ�������
	$('#medsrRepLocDr').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#medsrRepLocDr').combobox('reload',url+'?action=SelLocDesc')
		}
	});
	//�Ա�
	$('#PatSex').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		editable:false,
		//data:patSexArr
		url:url+'?action=SelSex'
	});
	//����
	$('#medsrWeek').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:WeekNo
	});
	//���
	$('#medsrOccBatNo').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:OccBatNo
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
	
	//��  ����ҽ����ѡ��ʽҽ��ʱ����ʾ���ؿ�
	$('#DM10').click(function(){
		var dm1=document.getElementById("dm1"); //ְ��
		if ($(this).is(':checked')) {
			dm1.style.display='inline';
		} else {
			dm1.style.display='none';
		}   
	});
	//��  ����ҩʦ��ѡ��ʽҩʦʱ����ʾ���ؿ�
	$('#AM20').click(function(){
		var am1=document.getElementById("am1");
		if ($(this).is(':checked')) {
			am1.style.display='inline';
		} else {
			am1.style.display='none';
		}   
	});
	//��  ���»�ʿ��ѡ��ʽ��ʿʱ����ʾ���ؿ�
	$('#NM30').click(function(){
		var nm1=document.getElementById("nm1");
		if ($(this).is(':checked')) {
			nm1.style.display='inline';
		} else {
			nm1.style.display='none';
		}   
	});
	
	//����� ��ѡ����ﻼ�ߣ����ң�ʱ����ʾ���ؿ�
	$('#RD2').click(function(){
		var rd=document.getElementById("rd");
		if ($(this).is(':checked')) {
			rd.style.display='inline';
		} else {
			rd.style.display='none';
		}   
	});
	
	InitMedsReport(medsrID);
	InitPatientInfo(medsrID,adrDataList);//��ȡҳ��Ĭ����Ϣ
	getMedsrRepPatInfo(patientID,EpisodeID);//��ȡ������Ϣ
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

/// ������ҩ������
function saveMedsReport(flag)
{
	 ///����ǰ,��ҳ���������м��
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	if(editDoRow>="0"){
		$("#DocL").datagrid('endEdit', editDoRow);
	}
	if(editApRow>="0"){
		$("#ApoL").datagrid('endEdit', editApRow);
	}
	if(editDiRow>="0"){
		$("#DispL").datagrid('endEdit', editDiRow);
	}
	if(editNuRow>="0"){
		$("#NurL").datagrid('endEdit', editNuRow);
	}
	if(editPaRow>="0"){
		$("#PatL").datagrid('endEdit', editPaRow);
	}	
	//1������
	var medsrRepLocDr=$('#medsrRepLocDr').combobox('getValue');
	medsrRepLocDr=LocDr;
	//2����������
	var medsrCreateDateTime=$('#medsrCreateDateTime').datetimebox('getValue');   
	var medsrCreateDate="",medsrCreateTime="";
	if(medsrCreateDateTime!=""){
		medsrCreateDate=medsrCreateDateTime.split(" ")[0];  //��������
		medsrCreateTime=medsrCreateDateTime.split(" ")[1];  //����ʱ��
	}
	//3����������
	var medsrOccDateTime=$('#medsrOccDateTime').datetimebox('getValue');   
	var medsrOccDate="",medsrOccTime="";
	if(medsrOccDateTime!=""){
		medsrOccDate=medsrOccDateTime.split(" ")[0];  //��������
		medsrOccTime=medsrOccDateTime.split(" ")[1];  //����ʱ��
	}
	
	//4������
	var medsrWeek=$('#medsrWeek').combobox('getValue');

	//5�����
	var medsrOccBatNo=$('#medsrOccBatNo').combobox('getValue');
	
	//6������ID
	var medsrPatID=$('#PatID').val();
	if(medsrPatID==""){
		$.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return;
	}
	//7��������
	var medsrPatNo=$('#PatNo').val();
	
	//8����������
	var medsrName=$('#PatName').val();
	if(medsrName==""){
	  $.messager.alert("��ʾ:","�����뻼��ID,ѡ����Ӧ����");
		return;
	}
    //9�������Ա�
	var medsrSex=$('#PatSex').combobox('getValue');
    //10����������
	var medsrAge=$('#PatAge').val();  
	//11��Ӧ��ҩ��
	var medsrDrugName=$('#medsrDrugName').val(); 
	medsrDrugName=inci;
	//12��Ӧ������
	var medsrDosage=$('#medsrDosage').val();  
	//13���ۼƴ����ҩ����
	var medsrErrNum=$('#medsrErrNum').val();   

	//14��ҽ������
	var DocLitmList="";
	var docLitmdatalist=[];
	var Doselflag="";
	var selDLItems = $('#DocL').datagrid('getSelections');
	$.each(selDLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //������
		docLitmdatalist.push(tmp);
		DocLitmList=docLitmdatalist.join("$c(1)");
		Doselflag=item.ID;
	})
	//15������ҽ����Ϣ
	var medsrDoctorMes="";
	var medsrDOtherDesc="";
	var medsrDCProv="";
	var Doflag="";
	$.each(selDLItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrDoctorMes]").each(function(){
				if($(this).is(':checked')){
					medsrDoctorMes=this.value;				
				}
			})
			medsrDOtherDesc=$('#medsrDOtherDesc').val();
		}
		Doflag=(item.ID!="")&(medsrDoctorMes=="");
	})
	if(Doflag){
		$.messager.alert("��ʾ:","ҽ������Ϊ�գ�");
		return;	
	}
	// Ϊ��ʽҽ��	
	if(medsrDoctorMes=="10"){
		medsrDCProv=$('#medsrDCProv').val(); 
		if(medsrDCProv==""){
			$.messager.alert("��ʾ:","Ϊ��ʽҽ��ʱ,����дְ�ƣ�");
			return;
		}
	}	

	var DoctorMesList=medsrDoctorMes+"^"+medsrDCProv+"^"+medsrDOtherDesc;
	//16��ҩʦ����
	
	var ApoLitmList="";
	var apoLitmdatalist=[];
	var Apselflag="";
	var selALItems = $('#ApoL').datagrid('getSelections');
	$.each(selALItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //������
		apoLitmdatalist.push(tmp);
		ApoLitmList=apoLitmdatalist.join("$c(1)");
		Apselflag=item.ID;
	})
	
	//17������ҩʦ��Ϣ
	var medsrApothecaryMes="";
	var medsrAOtherDesc="";
	var medsrACProv="";
	var Apflag="";
	$.each(selALItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrApothecaryMes]").each(function(){
				if($(this).is(':checked')){
					medsrApothecaryMes=this.value;
				}
			})
			medsrAOtherDesc=$('#medsrAOtherDesc').val();
		}
		Apflag=(item.ID!="")&(medsrApothecaryMes=="");
	})
	if(Apflag){
		$.messager.alert("��ʾ:","ҩʦ����Ϊ�գ�");
		return;
	}
	// Ϊ��ʽҩʦ
	if(medsrApothecaryMes=="20"){
		medsrACProv=$('#medsrACProv').val(); 
		if(medsrACProv==""){
			$.messager.alert("��ʾ:","Ϊ��ʽҩʦʱ,����дְ�ƣ�");
			return;
		}
	}	
	var ApothecaryMesList=medsrApothecaryMes+"^"+medsrACProv+"^"+medsrAOtherDesc;
	//18�����ͻ���
	
	var DispLitmList="";
	var dispLitmdatalist=[];
	var Diselflag="";
	var selDiLItems = $('#DispL').datagrid('getSelections');
	$.each(selDiLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //������
		dispLitmdatalist.push(tmp);
		DispLitmList=dispLitmdatalist.join("$c(1)");
		Diselflag=item.ID;
	})
	
	//19����ʿ����
	var NurLitmList="";
	var nurLitmmdatalist=[];
	var Nuselflag="";
	var selNLItems = $('#NurL').datagrid('getSelections');
	$.each(selNLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //������
		nurLitmmdatalist.push(tmp);
		NurLitmList=nurLitmmdatalist.join("$c(1)");
		Nuselflag=item.ID;
	})
	
	//20�����»�ʿ��Ϣ
	var medsrNurseMes="";
	var medsrNOtherDesc="";
	var medsrNCProv="";
	var Nuflag="";
	$.each(selNLItems, function(index,item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrNurseMes]").each(function(){
				if($(this).is(':checked')){
					medsrNurseMes=this.value;
				}
			})
			medsrNOtherDesc=$('#medsrNOtherDesc').val();
		}
		Nuflag=(item.ID!="")&(medsrNurseMes=="");
	})
	if(Nuflag){
		$.messager.alert("��ʾ:","��ʿ����Ϊ�գ�");
		return;
	}
	// Ϊ��ʽ��ʿ
	if(medsrNurseMes=="30"){
		medsrNCProv=$('#medsrNCProv').val(); 
		if(medsrNCProv==""){
			$.messager.alert("��ʾ:","Ϊ��ʽ��ʿʱ,����дְ�ƣ�");
			return;
		}
	}
	var NurseMesList=medsrNurseMes+"^"+medsrNCProv+"^"+medsrNOtherDesc;
	//21�����߻���
	var PatLitmList="";
	var patlitmdatalist=[];
	var Paselflag="";
	var selPLItems = $('#PatL').datagrid('getSelections');
	$.each(selPLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //������
		patlitmdatalist.push(tmp);
		PatLitmList=patlitmdatalist.join("$c(1)");
		Paselflag=item.ID;

	})
	
	var Itmflag=((Doselflag=="")&&(Apselflag=="")&&(Diselflag=="")&&(Nuselflag=="")&&(Paselflag==""))
	if(Itmflag){
		$.messager.alert("��ʾ:","������Ŀ���ٹ�ѡһ�֣�");
		return ;
	}
	
	//22�����
	var medsrReslutDr="";
	var medsrReslutDra="";
    $("input[type=checkbox][name=medsrReslutDr]").each(function(){
		if($(this).is(':checked')){
			medsrReslutDr=this.value;
			if(medsrReslutDr=="2"){
				$("input[type=checkbox][name=medsrReslutDra]").each(function(){
					if($(this).is(':checked')){
						medsrReslutDra=this.value;
					}
				})
			}
		}
	})
	// �¼����Ϊ  ����ﻼ�ߣ�����
 	var medsrReslutList=medsrReslutDr+","+medsrReslutDra;
  	
  	//23����ʱ�ж�/��Ԥ
	var medsrNurAction=$('#medsrNurAction').val();  //��ʱ�ж�/��Ԥ
 	//24�������˹���
	var medsrCreator=$('#medsrCreator').val();  //�����˹���
	medsrCreator=UserDr;
 	//25��������ְ��
	var medsrCreatorCareProv=$('#medsrCreatorCareProv').val();  //������ְ��

	var medsrReportNo=$('#medsrReportNo').val(); //�������
	medsrAdmNo=EpisodeID;  //����id
    var medsrRepImpFlag="N"; //�ص��ע  
         if(ImpFlag==""){  
		   medsrRepImpFlag=medsrRepImpFlag;
		 }else{
           medsrRepImpFlag=ImpFlag;
		 }
	if(flag==1){
		medsrCurStatusDR=MedsrInitStatDR;  //��ʼ״̬
	}	
	var medsrDataList=medsrRepLocDr+"^"+medsrCreateDate+"^"+medsrCreateTime+"^"+medsrOccDate+"^"+medsrOccTime+"^"+medsrOccBatNo+"^"+medsrPatNo+"^"+medsrPatID;
	medsrDataList=medsrDataList+"^"+medsrName+"^"+medsrSex+"^"+medsrAge+"^"+medsrDrugName+"^"+medsrDosage+"^"+medsrErrNum;
	medsrDataList=medsrDataList+"^"+medsrCreator+"^"+medsrCreatorCareProv+"^"+medsrCurStatusDR+"^"+medsrReportNo+"^"+medsrReportType+"^"+medsrAdmNo+"^"+medsrOrdItm+"^"+medsrRepImpFlag;
	medsrDataList=medsrDataList+"$c(2)"+DoctorMesList+"$c(2)"+DocLitmList+"$c(2)"+ApothecaryMesList+"$c(2)"+ApoLitmList+"$c(2)"+DispLitmList+"$c(2)"+NurLitmList;
	medsrDataList=medsrDataList+"$c(2)"+NurseMesList+"$c(2)"+PatLitmList+"$c(2)"+medsrReslutList+"$c(2)"+medsrNurAction;
	
	//var medsrRepAuditList="";
	//if(flag==1){
	var medsrRepAuditList=medsrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+medadrNextLoc+"^"+medadrLocAdvice+"^"+medadrReceive+"^"+medsrReportType;
	//}
	var param="medsrID="+medsrID+"&medsrDataList="+medsrDataList+"&medsrRepAuditList="+medsrRepAuditList+"&flag="+flag ; 
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
       			data: "action=saveMedsafetyReport&"+param,
       			success: function(val){
	      			var medsrArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (medsrArr[0]=="0") {
	      	 			$.messager.alert("��ʾ:",mesageShow+"�ɹ�!");
			 			medsrID=medsrArr[1];
						if(winflag==0){
						 	if (((adrDataList!="") ||((adrDataList=="")&&(frmflag==1)) )&&(flag==1)){
				  				window.parent.CloseWin();
				  			}
				 	    }else if(winflag==1){
						    window.parent.CloseWinUpdate();
						}			 			
			 			if (adrDataList==""){    //wangxuejian 2016/10/18
			 				InitMedsReport(medsrID);//��ȡ������Ϣ(��ȡ������Ϣ) qunianpeng 16/09/29 update
					 		winflag=0;
					 	}	
			 			if(flag==1){
							//$("a:contains('�ύ')").attr("disabled",true);
							//$("a:contains('�ݴ�')").attr("disabled",true);
							var buttondiv=document.getElementById("buttondiv");
							buttondiv.style.display='none';
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

//�滻������� 2015-12-25 congyue
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
function InitMedsReport(medsrID)
{
	if(medsrID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	var medsrDataList="";
	winflag=1; //2016-10-10
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getMedsRepInfo&medsrID="+medsrID+"&params="+params,
       //dataType: "json",
       success: function(val){
	      	medsrDataList=val;
	      	var tmp=medsrDataList.split("!");
			$('#medsrRepLocDr').combobox('setValue',tmp[1]);    //����
			$('#medsrCreateDateTime').datetimebox({disabled:true});
			$('#medsrCreateDateTime').datetimebox("setValue",tmp[2]+" "+tmp[3]);   //��������
			if(tmp[4]!=""||tmp[5]!=""){
				$('#medsrOccDateTime').datetimebox("setValue",tmp[4]+" "+tmp[5]);   //��������
			}	 
			$('#medsrOccBatNo').combobox('setValue',tmp[6]);     //���
			//������Ϣ
			$('#PatNo').val(tmp[7]);    //������
			$('#PatNo').attr("disabled","true");
			$('#PatID').val(tmp[8]);    //���˵ǼǺţ�ID��
			$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai ���ò���ID���ɱ༭
			$('#PatName').val(tmp[9]);    //��������
			$('#PatSex').combobox('setValue',tmp[10]);     //�Ա�
			$('#PatAge').val(tmp[11]);    //����
			$('#medsrDrugName').val(tmp[12]);    //ҩƷ����
			$('#medsrDosage').val(tmp[13]);    //Ӧ������
			$('#medsrNurAction').val(tmp[14]);    //��ʱ�ж�
			$('#medsrCreator').val(tmp[15]);    //������
			$('#medsrCreator').attr("disabled","true");
			$('#medsrCreatorCareProv').val(tmp[16]);    //������ְ��
			
			$('#medsrErrNum').val(tmp[17]);    //�������
			$('#medsrReportNo').val(tmp[19]);    //������
			$('#medsrReportNo').attr("disabled","true");
				
			var repLinkList=tmp[22] //����ҽ����ҩʦ����ʿ��Ϣ��
			var List=repLinkList.split("&");
			for (i=0;i<List.length;i++){
				var messList=List[i].split("^");
				if (messList[4]==DocL){
					//����ҽ����Ϣ
					$('#DM'+messList[1]).attr("checked",true);
					if(messList[1]=="10")
					{	
						var dm1=document.getElementById("dm1");
						dm1.style.display='inline';

					}
					$('#medsrDCProv').val(messList[2]);
					$('#medsrDOtherDesc').val(messList[3]);
					if(messList[1]=="13"){
						$('#medsrDOtherDesc').attr("disabled",false);
					}
				}else if (messList[4]==ApoL){
					//����ҩʦ��Ϣ
					$('#AM'+messList[1]).attr("checked",true);
					if(messList[1]=="20")
					{	
						var am1=document.getElementById("am1");
						am1.style.display='inline';
					}
					$('#medsrACProv').val(messList[2]);
					$('#medsrAOtherDesc').val(messList[2]);
					if(messList[1]=="23"){
						$('#medsrAOtherDesc').attr("disabled",false);
					}
				}else if (messList[4]==NurL){
					//���»�ʿ��Ϣ
					$('#NM'+messList[1]).attr("checked",true);
					if(messList[1]=="30")
					{	
						var nm1=document.getElementById("nm1");
						nm1.style.display='inline';
					}
					$('#medsrNCProv').val(messList[2]);
					$('#medsrNOtherDesc').val(messList[3]);
					if(messList[1]=="33"){
						$('#medsrNOtherDesc').attr("disabled",false);
					}
				}	
				
			}
				
				
			
			//�¼����
			var MedsRepResult=tmp[23];
			var tmpstr=MedsRepResult.split(",");
			$('#RD'+tmpstr[0]).attr("checked",true);
			if(tmpstr[0]=="2"){
				var rd=document.getElementById("rd");
				rd.style.display='inline';
				$('#RD'+tmpstr[1]).attr("checked",true);
			}
			
	//S medsrDataList=medsrDataList_"!"_medadrNextLoc_"!"_medadrLocAdvice_"!"_medadrReceive_"!"_medsrAdmNo_"!"_medsrOrdItm
	//S medsrDataList=medsrDataList_"!"_medsrRepLocDr_"!"_medsrCreator_"!"_medsrDrugDr_"!"_medsrRepImpFlag

			
			medsrCurStatusDR=tmp[18];
			medsrReportType=tmp[20]
			MedsrInitStatDR=tmp[21];
			
			medadrNextLoc=tmp[24]
			medadrLocAdvice=tmp[25]
			medadrReceive=tmp[26];
			
			medsrAdmNo=tmp[27]
			medsrOrdItm=tmp[28];
			EpisodeID=medsrAdmNo;
			
			UserDr=tmp[30];//������ID
			LocDr=tmp[29];//����ID
			inci=tmp[31]; //ҩƷid
			ImpFlag=tmp[32]; //��Ҫ���
			//editFlag״̬Ϊ0,�ύ���ݴ水ť������
			if (medsrCurStatusDR==""){
				medsrCurStatusDR=medsrCurStatusDR;
				medadrReceive="";
			}else{
				MedsrInitStatDR=tmp[18];
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
			if (tmp[18]!=""){  //������ύ״̬
				$('#submitdiv').hide();//�����ύ��ť
				//��ȡ����Ȩ�ޱ�־ 2016-10-19
				var Assessflag=GetAssessAuthority(medsrID,params);
				if (Assessflag=="Y"){
					$('#assessment').show(); //��ʾ������ť 
				}
			}
			$('#clearbt').hide();//������հ�ť			
     },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });    
}

//���ر���Ĭ����Ϣ
function InitPatientInfo(medsrID,adrDataList)
{
   if(medsrID!=""){return;}
   if(adrDataList==""){
		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	}
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMedsrInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			$.messager.alert("��ʾ:","�������ù�������Ȩ��,Ȼ�����");
			return;
		}else{
			var tmp=val.split("^");
			$('#medsrCreateDateTime').datetimebox({disabled:true});
			$('#medsrCreateDateTime').datetimebox("setValue",tmp[0]);   //��������
			MedsrInitStatDR=tmp[1];  //����ĳ�ʼ��,״̬ 
			medsrReportType=tmp[2];  // ���������
			//$('#medsrReportNo').val(tmp[3]);    //�������
			$('#medsrReportNo').attr("disabled","true");
			UserDr=tmp[4];
			$('#medsrCreator').val(tmp[5]);    //�����˹���
			//$('#medsrCreator').attr("disabled","true");
			LocDr=tmp[6];
			$('#medsrRepLocDr').combobox('setValue',tmp[6]);    //����ID
			$('#medsrRepLocDr').combobox('setText',tmp[7]);    //��������
			//$('#bldrptRepLocDr').attr("disabled","true");

			$('#medsrCreatorCareProv').val(tmp[8]);    //������ְ��
			//$('#medsrCreatorCareProv').attr("disabled","true");
		}
   }})
}
//��ȡ������Ϣ
function getMedsrRepPatInfo(patientID,EpisodeID){
	
	//var medsrPatID=$('#PatID').val();
	//var medsrPatID=getRegNo(medsrPatID);
	if(patientID==""||EpisodeID==""){return;}
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       success: function(val){
	       
	   	var medsrRepPatInfo=val;
	    var tmp=medsrRepPatInfo.split("^");

		$('#PatID').val(tmp[0]); //����ID  �ǼǺ�
		$('#PatName').val(tmp[1]); //�������� 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //�Ա�
		$('#PatAge').val(tmp[4]);  //����
		$('#PatAge').attr("disabled","true");
		$('#PatNo').val(tmp[5]);  //������
		$('#PatNo').attr("disabled","true");
		patIDlog=$('#PatID').val();
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
	//1������
	var medsrRepLocDr=$('#medsrRepLocDr').combobox('getValue');
	if(medsrRepLocDr==""){
		$.messager.alert("��ʾ:","�����ҡ�����Ϊ�գ�");
		return false;
	}
	//2����������
	var medsrCreateDateTime=$('#medsrCreateDateTime').datetimebox('getValue');   
	if(medsrCreateDateTime==""){
		$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
		return false;
	}
	var medsrCreateDate=medsrCreateDateTime.split(" ")[0];  //��������
	if(!compareSelTimeAndCurTime(medsrCreateDate)){
		$.messager.alert("��ʾ:","������ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}

	//3����������
	var medsrOccDateTime=$('#medsrOccDateTime').datetimebox('getValue');   
	if(medsrOccDateTime==""){
		$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
		return false;
	}
	var medsrOccDate=medsrOccDateTime.split(" ")[0];  //��������
	if(!compareSelTimeAndCurTime(medsrOccDate)){
		$.messager.alert("��ʾ:","������ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	}

	//6������ID
	var medsrPatID=$('#PatID').val();
	if(medsrPatID==""){
		$.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return false;
	}
	//7��������
	var medsrPatNo=$('#PatNo').val();
	if(medsrPatNo==""){
		$.messager.alert("��ʾ:","�������š�����Ϊ�գ�");
		return false;
	} 
	
	//8����������
	var medsrName=$('#PatName').val();
	if(medsrName==""){
		$.messager.alert("��ʾ:","����������������Ϊ�գ�");
		return false;
	}
    //9�������Ա�
	var medsrSex=$('#PatSex').combobox('getValue');
	if(medsrSex==""){
		$.messager.alert("��ʾ:","�������Ա𡿲���Ϊ�գ�");
		return false;
	}
    //10����������
	var medsrAge=$('#PatAge').val();  
	if(medsrAge==""){
		$.messager.alert("��ʾ:","���������䡿����Ϊ�գ�");
		return false;
	}
 	//15������ҽ����Ϣ
	var medsrDoctorMes="";
	var medsrDOtherDesc="";
	var medsrDCProv="";
	var Doflag="";
	var selDLItems = $('#DocL').datagrid('getSelections');
	$.each(selDLItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrDoctorMes]").each(function(){
				if($(this).is(':checked')){
					medsrDoctorMes=this.value;
				}
			})
			medsrDOtherDesc=$('#medsrDOtherDesc').val();
		}
		Doflag=(item.ID!="")&(medsrDoctorMes=="");
		
	})
	if(Doflag){
		$.messager.alert("��ʾ:","ҽ������Ϊ�գ�");
		return false;	
	}
	// Ϊ��ʽҽ��
	if(medsrDoctorMes=="10"){
		medsrDCProv=$('#medsrDCProv').val(); 
		if(medsrDCProv==""){
			$.messager.alert("��ʾ:","��Ϊ��ʽҽ��ʱ,����дְ�ƣ���");
			return false;
		}
	}
	//17������ҩʦ��Ϣ
	var medsrApothecaryMes="";
	var medsrAOtherDesc="";
	var medsrACProv="";
	var Apflag="";
	var selALItems = $('#ApoL').datagrid('getSelections');
	$.each(selALItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrApothecaryMes]").each(function(){
				if($(this).is(':checked')){
					medsrApothecaryMes=this.value;
				}
			})
			medsrAOtherDesc=$('#medsrAOtherDesc').val();
		}
		Apflag=(item.ID!="")&(medsrApothecaryMes=="");
	})
	if(Apflag){
		$.messager.alert("��ʾ:","��ҩʦ������Ϊ�գ�");
		return false;
	}
	// Ϊ��ʽҩʦ
	if(medsrApothecaryMes=="20"){
		medsrACProv=$('#medsrACProv').val(); 
		if(medsrACProv==""){
			$.messager.alert("��ʾ:","��Ϊ��ʽҩʦʱ,����дְ�ƣ���");
			return false;
		}
	}
	//20�����»�ʿ��Ϣ
	var medsrNurseMes="";
	var medsrNOtherDesc="";
	var medsrNCProv="";
	var Nuflag="";
	var selNLItems = $('#NurL').datagrid('getSelections');
	$.each(selNLItems, function(index,item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrNurseMes]").each(function(){
				if($(this).is(':checked')){
					medsrNurseMes=this.value;
				}
			})
			medsrNOtherDesc=$('#medsrNOtherDesc').val();
		}
		Nuflag=(item.ID!="")&(medsrNurseMes=="");
	})
	if(Nuflag){
		$.messager.alert("��ʾ:","����ʿ������Ϊ�գ�");
		return false;
	}
	// Ϊ��ʽ��ʿ
	if(medsrNurseMes=="30"){
		medsrNCProv=$('#medsrNCProv').val(); 
		if(medsrNCProv==""){
			$.messager.alert("��ʾ:","��Ϊ��ʽ��ʿʱ,����дְ�ƣ���");
			return false;
		}
	}
	//22�����
	var medsrReslutDr="";
	var medsrReslutDra="";
    $("input[type=checkbox][name=medsrReslutDr]").each(function(){
		if($(this).is(':checked')){
			medsrReslutDr=this.value;
		}
	})
	if(medsrReslutDr==""){
		$.messager.alert("��ʾ:","���¼����������Ϊ�գ�");
		return false;
	}
	
	// �¼����Ϊ  ����ﻼ�ߣ�����
	if(medsrReslutDr=="2"){
		$("input[type=checkbox][name=medsrReslutDra]").each(function(){
			if($(this).is(':checked')){
				medsrReslutDra=this.value;
			}
		})
		if(medsrReslutDra==""){
			$.messager.alert("��ʾ:","���Ի��ߴﵽ���˺�ѡ�����Ϊ�գ�");
			return false;
		}
	}
	
 	//23����ʱ�ж�/��Ԥ
	var medsrNurAction=$('#medsrNurAction').val();  //��ʱ�ж�/��Ԥ
	if(medsrNurAction==""){
		$.messager.alert("��ʾ:","����ʱ�ж�/��Ԥ������Ϊ�գ�");
		return false;
	}
 	//24�������˹���
	var medsrCreator=$('#medsrCreator').val();  //�����˹���
	if(medsrCreator==""){
		$.messager.alert("��ʾ:","�������˹��š�����Ϊ�գ�");
		return false;
	}
 	//25��������ְ��
	var medsrCreatorCareProv=$('#medsrCreatorCareProv').val();  //������ְ��
	/* if(medsrCreatorCareProv==""){
		$.messager.alert("��ʾ:","��������ְ�ơ�����Ϊ�գ�");
		return false;
	} */	
	
	return true;
}
//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///ҽ��
		if(id=="DM13"){
			$('#medsrDOtherDesc').attr("disabled",false);
		}
		if(id=="DM10"){
			$('#dm1').show();
			$('#medsrDCProv').attr("disabled",false);
			$('#medsrDWage').attr("disabled",false);
		}		
		///ҩʦ
		if(id=="AM23"){
			$('#medsrAOtherDesc').attr("disabled",false);
		}
		if(id=="AM20"){
			$('#am1').show();
			$('#medsrACProv').attr("disabled",false);
			$('#medsrAWage').attr("disabled",false);
		}
	    ///��ʿ
		if(id=="NM33"){
			$('#medsrNOtherDesc').attr("disabled",false);
		}
		if(id=="NM30"){
			$('#nm1').show();
			$('#medsrNCProv').attr("disabled",false);
			$('#medsrNWage').attr("disabled",false);
		}
		///���
		if(id=="RD2"){
			$("input[type=checkbox][name=medsrReslutDra]").each(function(){
				if($(this).is(':checked')){
					var medsrReslutDra=this.value;
				}
			})
			$("[name=medsrReslutDra]:checkbox").prop("checked",false);
		}  
		if(id=="RD1"){
			$("#rd").hide(); //���δ���ﻼ�����غ����Ϣ
			$("[name=medsrReslutDra]:checkbox").prop("checked",false);
		}    
	}else{
		///ҽ��
		if(id=="DM13"){
			$('#medsrDOtherDesc').val("");
			$('#medsrDOtherDesc').attr("disabled","true");
		}
		if(id=="DM10"){
			$('#medsrDCProv').val("");
			$('#dm1').hide();
			$('#medsrDCProv').attr("disabled",true);
			$('#medsrDWage').val("");
			$('#medsrDWage').attr("disabled",true);
		}
		///ҩʦ
		if(id=="AM23"){
			$('#medsrAOtherDesc').val("");
			$('#medsrAOtherDesc').attr("disabled","true")

		}
		if(id=="AM20"){
			$('#medsrACProv').val("");
			$('#am1').hide();
			$('#medsrACProv').attr("disabled",true);
			$('#medsrAWage').val("");
			$('#medsrAWage').attr("disabled",true);
		}	
	    ///��ʿ
		if(id=="NM33"){
			$('#medsrNOtherDesc').val("");
			$('#medsrNOtherDesc').attr("disabled","true");
		}
		if(id=="NM30"){
			$('#medsrNCProv').val("");
			$('#nm1').hide();
			$('#medsrNCProv').attr("disabled",true);
			$('#medsrNWage').val("");
			$('#medsrNWage').attr("disabled",true);
		}  
		///���
		if(id=="RD2"){
			$("input[type=checkbox][name=medsrReslutDra]").each(function(){
				if($(this).is(':checked')){
					var medsrReslutDra=this.value;
					medsrReslutDra="";
					$("[name=medsrReslutDra]:checkbox").val("");
					$("[name=medsrReslutDra]:checkbox").prop("checked","");
					$("[name=medsrReslutDra]:checkbox").prop("checked",true);

				}
			})
		}   
	}
}

function getWeek(data)
{
	var SelDateArr="",SelYear="",SelMonth="",SelDate="";
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		SelDateArr=data.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[1])-1;
		SelDate=parseInt(SelDateArr[0]);
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		SelDateArr=data.split("-");
		SelYear=SelDateArr[0];
		SelMonth=parseInt(SelDateArr[1])-1;
		SelDate=parseInt(SelDateArr[2]);
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		SelDateArr=data.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[0])-1;
		SelDate=parseInt(SelDateArr[1]);
	}
	var dt = new Date(SelYear,SelMonth,SelDate), dt2 = new Date();
	var weekDay = ["������", "����һ", "���ڶ�", "������", "������", "������", "������"];
	a=weekDay[dt.getDay()];
	$('#medsrWeek').combobox('setValue',a);
}

//��.js������function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	medsrAdmNo=rowData.Adm;
	if(EpisodeID==undefined)
	{
		EpisodeID=""
	}
	var medsrPatID=$('#PatID').val();
	var medsrPatID=getRegNo(medsrPatID);
	$('#admordgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetAdmOrdList&EpisodeID='+EpisodeID 
	})
	getMedsrRepPatInfo(medsrPatID,EpisodeID);
}
//ѡ���˵�ҩ��ҽ��
function GetAdmOrdList(EpisodeID)
{
			 
	if (EpisodeID=="")
	{
		$.messager.alert("��ʾ:","����ѡ���˾����¼��");
		return;
	}
	var input='';
	var mycols=[[
		{field:"ck",checkbox:true,width:20,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'���ȼ�',width:80},
		{field:'startdate',title:'��ʼ����',width:80},
		{field:'enddate',title:'��������',width:80},
		{field:'incidesc',title:'����',width:280},
		{field:'inci',title:'incidr',width:80,hidden:true},
		{field:'spec',title:'���',width:100},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'qty',title:'��Ŀ',width:80},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'��׼�ĺ�',width:80,hidden:true},
		{field:'genenic',title:'ͨ����',width:160},
		{field:'manf',title:'����',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];

	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetAdmOrdList&EpisodeID='+EpisodeID ,
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#admordgrid', //grid ID
		field:'orditm', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null //�Ϲ�����,��Ϊnull
	}
	var win=new CreatMyDiv(input,$("#medsrDrugName"),"bldsfollower","850px","335px","admordgrid",mycols,mydgs,"","",SetAdmOrdTxtVal);	
	win.init();
}

function SetAdmOrdTxtVal(rowData)
{
	if(rowData!=""){
		medsrOrdItm=rowData.orditm;
		var DrugName="";
		var dosage="";
		if(medsrOrdItm==undefined)
		{
			medsrOrdItm=""
		}
		if(medsrOrdItm!=""){
			DrugName=rowData.incidesc;
			dosage=rowData.dosage;
			inci=rowData.inci;
			$('#medsrDrugName').val(DrugName);
			$('#medsrDosage').val(dosage);
			$("#DocL").datagrid('reload');
			$("#ApoL").datagrid('reload');
			$("#DispL").datagrid('reload');
			$("#NurL").datagrid('reload');
			$("#PatL").datagrid('reload');
			//��ȡҽ����Ϣ
			$.post(url+'?action=getRepOrdInfo',{"params":medsrOrdItm}, function(data){
				OrdInfo=data;
			});	
		}
	}

}
function SetDrugTxtVal(rowData)
{
	MedUseCode=rowData.MedUseCode;
	if (MedUseCode==DocL){
		///ҽ������
		var Docrows = $("#DocL").datagrid("getRows"); 
		for(var i=0;i<Docrows.length;i++){
			var code=Docrows[i].Code;
			if (code=="1-2")
			{

				$('#DocL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //ҩ�����    ҩƷ����
					}
				});
			}
		 	if (code=="1-4")
			{

				$('#DocL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcInDesc  //��ҩ;������  �÷�
					}
				});
			}
			if (code=="1-5")
			{

				$('#DocL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcFreqDesc  //��ҩƵ�ʴ���    Ƶ��
					}
				});
			}
		
		}
	}
	
	if (MedUseCode==ApoL){
		///ҩʦ����
		var Aporows = $("#ApoL").datagrid("getRows"); 
		for(var i=0;i<Aporows.length;i++){
			var code=Aporows[i].Code;
			if (code=="2-1")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //Ʒ�ִ���   ҩƷ����
					}
				});
			}
		}
	}
	if (MedUseCode==DispL){
		///���ͻ���
		var Disprows = $("#DispL").datagrid("getRows"); 
		for(var i=0;i<Disprows.length;i++){
			var code=Disprows[i].Code;
			if (code=="3-1")
			{

				$('#DispL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //���ʹ���  ҩƷ����
					}
				});
			}
		
		}
	}
	if (MedUseCode==NurL){
		///��ʿ����
		var Nurrows = $("#NurL").datagrid("getRows"); 
		for(var i=0;i<Nurrows.length;i++){
			var code=Nurrows[i].Code;
			if (code=="4-2")
			{

				$('#NurL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //ҩ�����    ҩƷ����
					}
				});
			}
			if (code=="4-4")
			{

				$('#NurL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcInDesc  //��ҩ;������  �÷�
					}
				});
			}
			if (code=="4-5")
			{

				$('#NurL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcFreqDesc  //��ҩƵ�ʴ���    Ƶ��
					}
				});
			}
		}
	}
	if (MedUseCode==PatL){
		///���߻���
		var Patrows = $("#PatL").datagrid("getRows"); 
		for(var i=0;i<Patrows.length;i++){
			var code=Patrows[i].Code;
			if (code=="5-2")
			{

				$('#PatL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcInDesc  //��ҩ;������  �÷�
					}
				});
			}
			if (code=="5-3")
			{

				$('#PatL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcFreqDesc  //��ҩƵ�ʴ���    Ƶ��
					}
				});
			}
		}
	}	
}

//ҩƷ����
function QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode)
{
	var input='';
	// ����columns	
	var mycols=[[
		{field:'MedUseCode',title:'���ڴ���',width:100,hidden:true},
		{field:'DrugID',title:'ID',width:100},
		{field:'DrugCode',title:'ҩƷ����',width:120},
		{field:'DrugDesc',title:'ҩƷ����',width:300}
		]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=QueryDrugDesc&Input='+inputCorrect+'&MedUseCode='+MedUseCode ,
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#druggrid', //grid ID
		field:'DrugID', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null //�Ϲ�����,��Ϊnull
		}
	var win=new CreatMyDiv(input,QueryDrug,"drugfollower","600","335","druggrid",mycols,mydgs,"","",SetDrugTxtVal);	
	win.init();	
}
//��ҩ;��  
function QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode)
{  
      inputCorrect=encodeURI(inputCorrect)  //�������Ϊ��������
	var input='';
	// ����columns	
	var mycols=[[
		{field:'MedUseCode',title:'���ڴ���',width:100,hidden:true},
		{field:'PhcInID',title:'ID',width:100},
		{field:'PhcInCode',title:'��ҩ;������',width:120},
		{field:'PhcInDesc',title:'��ҩ;������',width:300}
		]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=QueryPhcInDesc&Input='+inputCorrect+'&MedUseCode='+MedUseCode ,
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#phcIngrid', //grid ID
		field:'PhcInID', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null //�Ϲ�����,��Ϊnull
		}
	var win=new CreatMyDiv(input,PhcIn,"phcInfollower","600","335","phcIngrid",mycols,mydgs,"","",SetDrugTxtVal);		
	win.init();	
}
//��ҩƵ��
function QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode)
{
        inputCorrect=encodeURI(inputCorrect)  //�������Ϊ��������
	var input='';
	// ����columns	
	var mycols=[[
		{field:'MedUseCode',title:'���ڴ���',width:100,hidden:true},
		{field:'PhcFreqID',title:'ID',width:100},
		{field:'PhcFreqCode',title:'��ҩ;������',width:120},
		{field:'PhcFreqDesc',title:'��ҩ;������',width:150},
		{field:'PhcFreqDescs',title:'��ҩ;������',width:200}
		]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=QueryPhcFreqDesc&Input='+inputCorrect+'&MedUseCode='+MedUseCode ,
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#phcFreqgrid', //grid ID
		field:'PhcFreqID', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null //�Ϲ�����,��Ϊnull
		
		}
	var win=new CreatMyDiv(input,PhcFreq,"phcFreqfollower","650","335","phcFreqgrid",mycols,mydgs,"","",SetDrugTxtVal);	

	win.init();	
}

function GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo)

{	
		var tmp=OrdInfo.split("^");
		var a=rowIndex;
		//ҽ������
		if(MedUseCode==DocL){
			if (Codedata=="1-1")
			{
				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
						Error: $('#PatName').val()  //���ߴ���    ��������
					}
				});
			}
			            
			if (Codedata=="1-2")
			{
				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //ҩ�����    ҩƷ����
					}
				});
			}
			if (Codedata=="1-3")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[3]  //��������      ����
					}
				});
			}
			if (Codedata=="1-4")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[8]  //��ҩ;������  �÷�
					}
				});
			}
			if (Codedata=="1-5")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[6]  //��ҩƵ�ʴ���    Ƶ��
					}
				});
			}
			if (Codedata=="1-6")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[19]  //��ҩʱ�����  ��ʼ����
					}
				});
			}
		}
		//ҩʦ����
		if(MedUseCode==ApoL){
			if (Codedata=="2-1")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //Ʒ�ִ���   ҩƷ����
					}
				});
			}
			if (Codedata=="2-2")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[18]   //������  ���
					}
				});
			}
			if (Codedata=="2-3")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[23]  //��Ŀ����
					}
				});
			}
		}
		//���ͻ���
		if(MedUseCode==DispL){
			if (Codedata=="3-1")
			{

				$('#DispL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //���ʹ���  ҩƷ����
					}
				});
			}
		}
		//��ʿ����
		if(MedUseCode==NurL){
			if (Codedata=="4-1")
			{
				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
						Error: $('#PatName').val()  //���ߴ���    ��������
					}
				});
			}
			if (Codedata=="4-2")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //ҩ�����    ҩƷ����
					}
				});
			}
			if (Codedata=="4-3")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[3]  //��������      ����
					}
				});
			}
			if (Codedata=="4-4")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[8]  //��ҩ;������  �÷�
					}
				});
			}
			if (Codedata=="4-5")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[6]  //��ҩƵ�ʴ���    Ƶ��
					}
				});
			}
			if (Codedata=="4-6")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[19]  //��ҩʱ�����  ��ʼ����
					}
				});
			}
		}
		//���߻���
		if(MedUseCode==PatL){
			if (Codedata=="5-1")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[3]  //��������      ����
					}
				});
			}
			if (Codedata=="5-2")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[8]  //��ҩ;������  �÷�
					}
				});
			}
			if (Codedata=="5-3")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[6]  //��ҩƵ�ʴ���    Ƶ��
					}
				});
			}
			if (Codedata=="5-4")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[19]  //��ҩʱ�����  ��ʼ����
					}
				});
			}
		}
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
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+medsrID+'&RepType='+medsrReportType+'"></iframe>';
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
	if (medsrID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //��������Ԫ�ظ�ֵ
	/* //�������
	var medsrRepNo=$('#medsrReportNo').val(); 
	medsrRepNo=medsrRepNo.replace(/[ ]/g,""); //ȥ�������еĿո�
	$.ajax({
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=SeaMedsrRepNo&medsrRepNo="+medsrRepNo,
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
	window.location.href="dhcadv.medsafetyreport.csp?adrDataList="+""+"&frmflag="+frmflag;//ˢ�´���adrDataListΪ��
}			
