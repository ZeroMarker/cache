
/// Creator: congyue
/// CreateDate: 2016-01-13

var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "��" }, { "val": "2", "text": "Ů" },{ "val": "3", "text": "����" }];
var editRow="";CurRepCode="blood";
var bldrptID="";patientID="";EpisodeID="";editFlag="";adrDataList="";
var BldrptInitStatDR="";bldrptCurStatusDR="";bldrptReportType="";
var medadrNextLoc="";medadrLocAdvice="";medadrReceive=""; 
var LocDr="";UserDr="";ImpFlag="", patIDlog=""; 
var typeArray= [{"value":"A","text":'��������'}, {"value":"B","text":'�ٴ�֢״'}];
var typeBldBasA="A";typeBldBasB="B";
var patTypeArr= [{"val":"1","text":'��ϸ����Һ'}, {"val":"2","text":'����Ѫ��'}, {"val":"3","text":'����ѪС��'}];
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
$(function(){
	patientID=getParam("patientID");
	EpisodeID=getParam("EpisodeID");
	bldrptID=getParam("bldrptID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
	if ((adrDataList=="")&&(bldrptID=="")){
	    var frm = dhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
	        $.ajax({
		   	   type: "POST",
		       url: url,
		       async: false, //ͬ��
		       data: "action=getPatNo&patID="+papmi,
		       success: function(val){
			      	 papmi=val;
		       }
		    });
	        //var papmi=getRegNo(papmi);
	        EpisodeID=adm;
	        getBldrptPatInfo(papmi,adm);//��ȡ������Ϣ
		}
	}
    //�жϰ�ť�Ƿ�����
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	
	//����cols
	var cols=[[
		{field:'bldid',title:'��Ѫ���id',width:90,hidden:true},
		{field:'bldtype',title:'ѪҺ���',width:170},
		{field:'bldone',title:'��Ѫ���1',width:170},
	    {field:'bldtwo',title:'��Ѫ���2',width:170},
	    {field:'bldthree',title:'��Ѫ���3',width:170},
		{field:'bldfour',title:'��Ѫ���4',width:170}
	]];
	//����datagrid
	$('#bldBldTypedg').datagrid({
		title:'��Ѫ��Ϣ',    
		url:'',
		border:false,
		fitColumns:true, //�Զ�չ��/�����еĴ�С
		//pagination:true,
		columns:cols,
		loadMsg: '���ڼ�����Ϣ...',
		height:200
	});
	if(bldrptID!=""){
    	$('#bldBldTypedg').datagrid({
			url:url+'?action=getBldTypeInfo&params='+bldrptID
		});
	}
	//Type����
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:typeArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#BldB").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:'Select',title:'ѡ��',width:70,formatter:
			 function SetCellUrl(value, rowData, rowIndex)
			{	
				return "<input type=\"checkbox\"  name=\"bldbox\"  value=\"" + rowData.ID + "\">";
			} 
		},
		{field:"ID",title:'ID',width:50,align:'center',hidden:true},
		{field:"Code",title:'����',width:160,hidden:true},
		{field:'Desc',title:'����',width:200},
		{field:'flag',title:'��־',width:160,hidden:true},
		{field:'Selectt',title:'ѡ��',width:70,formatter:
		function SetCellUrl(value, rowData, rowIndex)
			{	
				return "<input type=\"checkbox\"  name=\"bldboxt\"  value=\"" + rowData.IDt + "\">";
			} 
		},
		{field:"IDt",title:'ID',width:50,align:'center',hidden:true},
		{field:"Codet",title:'����',width:160,hidden:true},
		{field:'Desct',title:'����',width:200},
		{field:'Typet',title:'����',width:160,hidden:true},
		{field:'flagt',title:'��־',width:160,hidden:true}
	]];
	//����datagrid
	$('#BldA').datagrid({
		title:'��Ѫ��������',
		url:url+'?action=QueryBldBasRpt&params='+typeBldBasA+"^"+bldrptID,
		fitColumns:true, //�Զ�չ��/�����еĴ�С
		columns:columns,
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10 
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		checkOnSelect: false,
		selectOnCheck: false,
        onLoadSuccess:function(data){
			 if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){ 
						$("input[type=checkbox][name=bldbox]").each(function(){
							if($(this).val()==item.ID){
								//$("input[name='bldboxt']:checked")
								$(this).attr("checked",true);
							}
						})
					}
					if(item.flagt=="Y"){ 
						$("input[type=checkbox][name=bldboxt]").each(function(){
							if($(this).val()==item.IDt){
								$(this).attr("checked",true);
							}
						})
					}
				});
			}
		}
	});
	//����datagrid
	$('#BldB').datagrid({
		title:'��Ѫ�ٴ�֢״',
		url:url+'?action=QueryBldBasRpt&params='+typeBldBasB+"^"+bldrptID,
		fitColumns:true, //�Զ�չ��/�����еĴ�С
		columns:columns,
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10 
        //pageList: [5,10,15],//��������ÿҳ��¼�������б�
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		checkOnSelect: false,
		selectOnCheck: false,
        onLoadSuccess:function(data){
			 if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){ 
						$("input[type=checkbox][name=bldbox]").each(function(){
							if($(this).val()==item.ID){
								$(this).attr("checked",true);
							}
						})
					}
					if(item.flagt=="Y"){ 
						$("input[type=checkbox][name=bldboxt]").each(function(){
							if($(this).val()==item.IDt){
								$(this).attr("checked",true);
							}
						})
					}
				});
			}
		}
	});
	//���˵ǼǺŻس��¼�
	$('#PatID').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 var bldrptPatID=$('#PatID').val();
			 if (bldrptPatID=="")
			 {
				 	$.messager.alert("��ʾ:","����id����Ϊ�գ�");
					return;
			 }
			 var bldrptPatID=getRegNo(bldrptPatID);
			if ((patIDlog!="")&(patIDlog!=bldrptPatID)&(bldrptID=="")){
				$.messager.confirm("��ʾ", "��Ϣδ����,�Ƿ��������", function (res) {//��ʾ�Ƿ�ɾ��
					if (res) {
						location.reload();
					}else{
						$('#PatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=bldrptPatID)&(bldrptID!="")){
				location.reload();
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
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+bldrptPatID ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
			 //alert(bldrptPatID);
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});
	
	
	//����
	$('#bldrptWard').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelwardDesc'
		
	});
	//�Ա�
	$('#PatSex').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:patSexArr
	});
	
	
	//��Ѫ���
	$('#bldrptBldType').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:patTypeArr
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
	
	//������ת��Ϊ����ʱ����ʾ���ص�ʱ���
     $("input[type=checkbox][name=bldrptPatInfo]").click(function(){
		if($(this).is(':checked')){
			var bldrptPatInfo=this.value;
			var bldrptDeathDateTime=document.getElementById("deathdate");
			if (bldrptPatInfo==1) {
				bldrptDeathDateTime.style.display='inline';
			} else {
				bldrptDeathDateTime.style.display='none';
			}  
		}
	})
	
 	$('#BP1').click(function(){
		var bldrptDeathDateTime=document.getElementById("deathdate");
		if ($(this).is(':checked')) {
			bldrptDeathDateTime.style.display='inline';
		} else {
			bldrptDeathDateTime.style.display='none';
		}   
	}); 	
	
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
	
	InitBldrptReport(bldrptID);//��ȡ������Ϣ
	InitPatientInfo(bldrptID,adrDataList);//��ȡҳ��Ĭ����Ϣ
	getBldrptPatInfo(patientID,EpisodeID);//��ȡ������Ϣ
	

	//editFlag״̬Ϊ0,�����ύ���ݴ水ť
	if(editFlag=="0"){
		$("a:contains('�ύ')").css("display","none");
		$("a:contains('�ݴ�')").css("display","none");
	}
})

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
 

//��ʼ���б�ʹ��
function InitdatagridRow()
{
    
	var bldrptBldType=$('#bldrptBldType').combobox('getText');//ѪҺ���
	var bldone=$('#bldone').val();//��Ѫ���1
	var bldtwo=$('#bldtwo').val();//��Ѫ���2
	var bldthree=$('#bldthree').val();//��Ѫ���3
	var bldfour=$('#bldfour').val();//��Ѫ���4
	
		$('#bldBldTypedg').datagrid('insertRow',{
			index: 0, // ������
			row: {
				bldid:'', bldtype:bldrptBldType, bldone:bldone, bldtwo:bldtwo, 
			    bldthree:bldthree, bldfour:bldfour
			}
		});
}

/// �������ҽ����е�����¼������
function saveBldrptReport(flag)
{
	 ///����ǰ,��ҳ���������м��
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	
	//1������
	var bldrptRepLocDr=$('#bldrptRepLocDr').val();
	bldrptRepLocDr=LocDr;
	//2����ˣ�������ǩ����
	var bldrptCreator=$('#bldrptCreator').val();
	bldrptCreator=UserDr;
	//3���������
	var bldrptRepNo=$('#bldrptRepNo').val();

	//4����������
	var bldrptCreateDateTime=$('#bldrptCreateDateTime').datetimebox('getValue');   
	var bldrptCreateDate="",bldrptCreateTime="";
	if(bldrptCreateDateTime!=""){
		bldrptCreateDate=bldrptCreateDateTime.split(" ")[0];  //��������
		bldrptCreateTime=bldrptCreateDateTime.split(" ")[1];  //����ʱ��
	}
	//5�����˲���
	var bldrptWard=$('#bldrptWard').combobox('getValue');
	//alert(bldrptWard);
	//6�����˾���ID
	var bldrptAdmNo=EpisodeID;  //$('#AdmNo').val();
	
	//7��������
	var bldrptPatNo=$('#PatNo').val();
	//8������ID
	var bldrptPatID=$('#PatID').val();
	if(bldrptPatID==""){
		$.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return;
	}
	//9����������
	var bldrptName=$('#PatName').val();
    //10�������Ա�
	var bldrptSex=$('#PatSex').combobox('getValue');
    //11����������
	var bldrptAge=$('#PatAge').val();  
	//12�����˳�������
	var bldrptBrithDate=$('#BrithDate').datetimebox('getValue');   
	//13�����֤��
	var bldrptPatCardNo=$('#PatCardNo').val();  
	//14���в�ʷ
	var bldrptGestation="";
    $("input[type=checkbox][name=bldrptGestation]").each(function(){
		if($(this).is(':checked')){
			bldrptGestation=this.value;
		}
	})
	//15��������Ѫʷ
	var bldrptBloodhis="";
    $("input[type=checkbox][name=bldrptBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodhis=this.value;
		}
	})
	//16����Ѫ��Ӧʷ
	var bldrptADVBloodhis="";
    $("input[type=checkbox][name=bldrptADVBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptADVBloodhis=this.value;
		}
	})
	
	//17����ѪǰѪ�ͼ����
	var bldrptBloodType=$('#bldrptBloodType').val();   
	var bldrptBloodAttr=$('#bldrptBloodAttr').val();  //������ 
	//18�����⿹��ɸ�飨�����ԣ�	
	var bldrptAntibody=$('#bldrptAntibody').val();  //������ 
	//19��������ע��ѪҺ��Ϣ
	var bldrptCurrBloodType=$('#bldrptCurrBloodType').val();   
	var bldrptCurrBloodAttr=$('#bldrptCurrBloodAttr').val();  //������ 
	//20����עѪ��
	var bldrptDiscNum=$('#bldrptDiscNum').val();   
	//21��������������
	var bldrptTemp=$('#bldrptTemp').val();  //���� 
	var bldrptBloodPress=$('#bldrptBloodPress').val();  //Ѫѹ 
	var bldrptSphygmus=$('#bldrptSphygmus').val();  //���� 
	var bldrptBreathes=$('#bldrptBreathes').val();  //����Ƶ�� 
	//22����ѪǰԤ����ҩ
	var bldrptDrugDesc="";
	var bldrptDrugRemark="";
    $("input[type=checkbox][name=bldrptDrugDesc]").each(function(){
		if($(this).is(':checked')){
			bldrptDrugDesc=this.value;
		}
	})
	bldrptDrugRemark=$('#bldrptDrugRemark').val();  // ��ϸ˵��
	
	//23��������Ѫ��ʼʱ��
	var bldrptStartDateTime=$('#bldrptStartDateTime').datetimebox('getValue');   
	var bldrptStartDate="",bldrptStartTime="";
	if(bldrptStartDateTime!=""){
		bldrptStartDate=bldrptStartDateTime.split(" ")[0];  //��ʼ����
		bldrptStartTime=bldrptStartDateTime.split(" ")[1];  //��ʼʱ��
	}
	var bldrptOperator=$('#bldrptOperator').val();   //�����߹���
	
	//24����Ѫ��Ӧ����ʱ��
	var bldrptOccDateTime=$('#bldrptOccDateTime').datetimebox('getValue');   
	var bldrptOccDate="",bldrptOccTime="";
	if(bldrptOccDateTime!=""){
		bldrptOccDate=bldrptOccDateTime.split(" ")[0];  //��������
		bldrptOccTime=bldrptOccDateTime.split(" ")[1];  //����ʱ��
	}
	var bldrptDisUser=$('#bldrptDisUser').val();   //�����߹���
	//25����Ѫ������/����
	var bldrptManf=$('#bldrptManf').val();   
	//26��ʣ��Ѫ��(ml)
	var bldrptRemain=$('#bldrptRemain').val();   
	//27����Ѫ������Ӧ����
	var bldrptAnalyze=$('#bldrptAnalyze').val();   
	//28�����س̶�
	var bldrptSerLevel="";
    $("input[type=checkbox][name=bldrptSerLevel]").each(function(){
		if($(this).is(':checked')){
			bldrptSerLevel=this.value;
		}
	})
	//29�������
	var bldrptRelation="";
    $("input[type=checkbox][name=bldrptRelation]").each(function(){
		if($(this).is(':checked')){
			bldrptRelation=this.value;
		}
	})
	//30���ٴ�����
	var bldrptWardOp=$('#bldrptWardOp').val();
	//31������ת��
	var bldrptPatInfo="";
	var bldrptDeathDateTime="";
	var bldrptDeathDate="";bldrptDeathTime="";

     $("input[type=checkbox][name=bldrptPatInfo]").each(function(){
		if($(this).is(':checked')){
			bldrptPatInfo=this.value;
		}
	})
	if(bldrptPatInfo=="1"){
		bldrptDeathDateTime=$('#bldrptDeathDateTime').datetimebox('getValue'); 
		if(bldrptDeathDateTime==""){
			$.messager.alert("��ʾ:","����ת��Ϊ��������,����д����ʱ�䣡");
			return;
		}else{
			bldrptDeathDate=bldrptDeathDateTime.split(" ")[0];  //��������
			bldrptDeathTime=bldrptDeathDateTime.split(" ")[1];  //����ʱ��
		}
	}	
	//32������Ѫ�����
	var bldrptBloodRelat="";
    $("input[type=checkbox][name=bldrptBloodRelat]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodRelat=this.value;
		}
	})
	
	//��Ѫ������Ӧ����������������
	var bldAList="";
	var bldAdatalist=[];
	var bldAListt="";
	var bldAdatalistt=[];
	var selBldAItems = $('#BldA').datagrid('getRows');
	$.each(selBldAItems, function(index, item){
		var items = $("input[name='bldbox']:checked");
		$.each(items, function (index, items) {
			if (items.value==item.ID){
				var tmp=item.ID;   //������
				bldAdatalist.push(tmp);
				bldAList=bldAdatalist.join("$c(1)"); 
			}
		});
		var itemst = $("input[name='bldboxt']:checked");
		$.each(itemst, function (index, itemst) {
			if (itemst.value==item.IDt){
				var tmp=item.IDt;   //������
				bldAdatalistt.push(tmp);
				bldAListt=bldAdatalistt.join("$c(1)"); 
			}
         });          
     
	});
	var BloodAList=bldAList+"$c(1)"+bldAListt  ;
	//��Ѫ������Ӧ�������ٴ�֢״��
	var bldBList="";
	var bldBdatalist=[];
	var bldBListt="";
	var bldBdatalistt=[];
	var selBldBItems = $('#BldB').datagrid('getRows');
	$.each(selBldBItems, function(index, item){
		var itemb = $("input[name='bldbox']:checked");
		$.each(itemb, function (index, itemb) {
			if (itemb.value==item.ID){
				var tmp=item.ID;   //������
				bldBdatalist.push(tmp);
				bldBList=bldBdatalist.join("$c(1)"); 
			}
		});
		
		var itembt = $("input[name='bldboxt']:checked");
		$.each(itembt, function (index, itembt) {
			if (itembt.value==item.IDt){
				var tmp=item.IDt;   //������
				bldBdatalistt.push(tmp);
				bldBListt=bldBdatalistt.join("$c(1)"); 
			}
         });  
         
                 
	});
	var BloodBList=bldBList+"$c(1)"+bldBListt  ;
	var rows = $("#bldBldTypedg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].bldtype+"^"+rows[i].bldone+","+rows[i].bldtwo+","+rows[i].bldthree+","+rows[i].bldfour;
		dataList.push(tmp);
	} 
	var BloodType=dataList.join("$c(1)");
    var bldrptRepImpFlag="N"; //�ص��ע
         if(ImpFlag==""){  
		   bldrptRepImpFlag=bldrptRepImpFlag;
		 }else{ 
             bldrptRepImpFlag=ImpFlag;
		 }
	if(flag==1){
		bldrptCurStatusDR=BldrptInitStatDR;  //��ʼ״̬
	}	
	var bldrptDataList=bldrptRepLocDr+"^"+bldrptRepNo+"^"+bldrptCreateDate+"^"+bldrptCreateTime+"^"+bldrptCreator;
	bldrptDataList=bldrptDataList+"^"+bldrptAdmNo+"^"+bldrptPatNo+"^"+bldrptPatID+"^"+bldrptName+"^"+bldrptSex+"^"+bldrptAge+"^"+bldrptBrithDate+"^"+bldrptPatCardNo;
	bldrptDataList=bldrptDataList+"^"+bldrptGestation+"^"+bldrptWard+"^"+bldrptBloodhis+"^"+bldrptADVBloodhis+"^"+bldrptBloodType+"^"+bldrptBloodAttr+"^"+bldrptAntibody+"^"+bldrptCurrBloodType;
	bldrptDataList=bldrptDataList+"^"+bldrptCurrBloodAttr+"^"+bldrptDiscNum+"^"+bldrptTemp+"^"+bldrptBloodPress+"^"+bldrptSphygmus+"^"+bldrptBreathes+"^"+bldrptDrugDesc;
	bldrptDataList=bldrptDataList+"^"+bldrptDrugRemark+"^"+bldrptStartDate+"^"+bldrptStartTime+"^"+bldrptOperator+"^"+bldrptOccDate+"^"+bldrptOccTime+"^"+bldrptDisUser;
	bldrptDataList=bldrptDataList+"^"+bldrptManf+"^"+bldrptRemain+"^"+bldrptAnalyze+"^"+bldrptSerLevel+"^"+bldrptRelation+"^"+bldrptWardOp+"^"+bldrptPatInfo+"^"+bldrptDeathDate;
	bldrptDataList=bldrptDataList+"^"+bldrptDeathTime+"^"+bldrptBloodRelat+"^"+bldrptCurStatusDR+"^"+bldrptReportType+"^"+bldrptRepImpFlag;
	bldrptDataList=bldrptDataList+"$c(2)"+""+"$c(2)"+BloodType+"$c(2)"+BloodAList+"$c(2)"+BloodBList;
	
	var bldrptRepAuditList="";
	if(flag==1){
		bldrptRepAuditList=bldrptCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+medadrNextLoc+"^"+medadrLocAdvice+"^"+medadrReceive+"^"+bldrptReportType;
	}
	var param="bldrptID="+bldrptID+"&bldrptDataList="+bldrptDataList+"&bldrptRepAuditList="+bldrptRepAuditList; 
	//alert(param); 
	
	//����
	$.messager.confirm("��ʾ", "�Ƿ���б�������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.ajax({
   	   			type: "POST",
      			url: url,
       			data: "action=saveBldrptReport&"+param,
       			success: function(val){
	      			var bldrptArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (bldrptArr[0]=="0") {
	      	 			$.messager.alert("��ʾ:","����ɹ�!");
			 			bldrptID=bldrptArr[1];
			 			InitBldrptReport(bldrptID);//��ȡ������Ϣ(��ȡ������Ϣ)

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
//����ѪҺ����б�
function InitBldTypeInfo(bldrptID)
{
    if(bldrptID==""){return;}
    $('#bldBldTypedg').datagrid({
		url:url+'?action=getBldTypeInfo',	
		queryParams:{
			params:bldrptID}
	});
}
//���ر�����Ϣ
function InitBldrptReport(bldrptID)
{
	if(bldrptID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getBldrptRepInfo&bldrptID="+bldrptID+"&params="+params,
       success: function(val){
	      	 bldrptDataList=val;
	      	 //alert(bldrptDataList);
	      	    var tmp=bldrptDataList.split("!");
				$('#bldrptID').val(tmp[0]);    //����ID
				$('#bldrptRepLocDr').val(tmp[1]); //����	
				$('#bldrptRepLocDr').attr("disabled","true");
				$('#bldrptCreator').val(tmp[2]); //��ˣ�������ǩ����
				$('#bldrptCreator').attr("disabled","true");
				$('#bldrptRepNo').val(tmp[3]); //�������
				$('#bldrptRepNo').attr("disabled","true");
				$('#bldrptCreateDateTime').datetimebox({disabled:true});
				$('#bldrptCreateDateTime').datetimebox("setValue",tmp[4]+" "+tmp[5]);   //��������
				$('#bldrptWard').combobox('setValue',tmp[6]); //���˲���
	
				$('#AdmNo').val(tmp[7]); //���˾���ID
				EpisodeID=tmp[7];
				$('#PatNo').val(tmp[8]); //������
				$('#PatID').val(tmp[9]); //����ID
				$('#PatName').val(tmp[10]);    //��������
				$('#PatSex').combobox('setValue',tmp[11]);     //�Ա�
				$('#PatAge').val(tmp[12]);    //����
				$('#BrithDate').datebox("setValue",tmp[13]);   //���˳�������
				$('#PatCardNo').val(tmp[14]);    //���֤��
				
				$('#BG'+tmp[15]).attr("checked",true);	//�в�ʷ
				var bldrptSex=$('#PatSex').combobox('getValue');
				if(bldrptSex==1){
					$("[name=bldrptGestation]:checkbox").attr("disabled",true);//�������Ͳ��ɹ�ѡ
				}
				$('#BB'+tmp[16]).attr("checked",true);	//������Ѫʷ
				$('#BA'+tmp[17]).attr("checked",true);	//��Ѫ��Ӧʷ
				
				$('#bldrptBloodType').val(tmp[18]);  //��ѪǰѪ�ͼ����
				$('#bldrptBloodAttr').val(tmp[19]);  //Ѫ�ͼ��������
				$('#bldrptAntibody').val(tmp[20]);  //���⿹��ɸ�飨�����ԣ�
				$('#bldrptCurrBloodType').val(tmp[21]);  //������ע��ѪҺ��Ϣ
				$('#bldrptCurrBloodAttr').val(tmp[22]);  //��ע��ѪҺ������
				$('#bldrptDiscNum').val(tmp[23]);  //��עѪ��
				$('#bldrptTemp').val(tmp[24]);  //���� 
				$('#bldrptBloodPress').val(tmp[25]);  //Ѫѹ 
				$('#bldrptSphygmus').val(tmp[26]);  //���� 
				$('#bldrptBreathes').val(tmp[27]);  //����Ƶ��
				//��ѪǰԤ����ҩ
				$('#BD'+tmp[28]).attr("checked",true);
				$('#bldrptDrugRemark').val(tmp[29]);
				if(tmp[28]=="1"){
					$('#bldrptDrugRemark').attr("disabled",false);
				}
				if(tmp[30]!=""||tmp[31]!=""){
					$('#bldrptStartDateTime').datetimebox("setValue",tmp[30]+" "+tmp[31]);   //������Ѫ��ʼʱ��
				}
				$('#bldrptOperator').val(tmp[32]);   //�����߹���
				if(tmp[33]!=""||tmp[34]!=""){
					$('#bldrptOccDateTime').datetimebox("setValue",tmp[33]+" "+tmp[34]);   //��Ѫ��Ӧ����ʱ��
				}
				$('#bldrptDisUser').val(tmp[35]);   //�����߹���
				$('#bldrptManf').val(tmp[36]);  //��Ѫ������/����
 				$('#bldrptRemain').val(tmp[37]);  //ʣ��Ѫ��(ml)
				$('#bldrptAnalyze').val(tmp[38]);  //��Ѫ������Ӧ����
				$('#BS'+tmp[39]).attr("checked",true);	//���س̶�
				$('#BR'+tmp[40]).attr("checked",true);	//�����
				$('#bldrptWardOp').val(tmp[41]);	//�ٴ�����
				
				//����ת��
				$('#BP'+tmp[42]).attr("checked",true);
				$('#bldrptDeathDateTime').datetimebox("setValue",tmp[43]+" "+tmp[44]);
				var deathdatetime=tmp[42];
				if(deathdatetime==1){
					var bldrptDeathDateTime=document.getElementById("deathdate");
					bldrptDeathDateTime.style.display='inline';
		
				}
				$('#BBR'+tmp[45]).attr("checked",true);	//����Ѫ�����
				
				
				bldrptCurStatusDR=tmp[46];
				bldrptReportType=tmp[47];
				BldrptInitStatDR=tmp[48];
				
				medadrNextLoc=tmp[49];
				medadrLocAdvice=tmp[50];
				medadrReceive=tmp[51];
				UserDr=tmp[52];//������ID
				LocDr=tmp[53];//����ID
                ImpFlag=tmp[54];//��Ҫ���
                
                $('#PatDiag').val(tmp[55]);  //�������
                
				if (bldrptCurStatusDR=="")
				{
					bldrptCurStatusDR=bldrptCurStatusDR;
					medadrReceive="";
				}
				else
				{
					BldrptInitStatDR=tmp[46];
					medadrReceive="1";
				} 
				
     },
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
    });   
}

//���ر���Ĭ����Ϣ
function InitPatientInfo(bldrptID,adrDataList)
{
   if(bldrptID!=""){return;}
   if(adrDataList==""){
   		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   }
   //var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getBloodInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
	       alert('�������ù�����,Ȼ���');
	       return;
		}else{
			var tmp=val.split("^");
			$('#bldrptCreateDateTime').datetimebox({disabled:true});
			$('#bldrptCreateDateTime').datetimebox("setValue",tmp[0]);   //��������
			BldrptInitStatDR=tmp[1];  //����ĳ�ʼ��,״̬ 
			bldrptReportType=tmp[2];  // ��������
			//$('#bldrptRepNo').val(tmp[3]);    //�������
			$('#bldrptRepNo').attr("disabled","true");
			UserDr=tmp[4];
			$('#bldrptCreator').val(tmp[5]);    //����������
			$('#bldrptCreator').attr("disabled","true");
			LocDr=tmp[6];
			$('#bldrptRepLocDr').val(tmp[7]);    //��������
			$('#bldrptRepLocDr').attr("disabled","true");
		}
   }})
}
//��ȡ������Ϣ
function getBldrptPatInfo(patientID,EpisodeID)
{
	if(patientID==""||EpisodeID==""){return;}
	//var patientID=getRegNo(patientID);
	//��ȡ������Ϣ
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       success: function(val){
	   	var bldrptPatInfo=val;
	    var tmp=bldrptPatInfo.split("^");
		//alert(bldrptPatInfo);
		$('#PatID').val(tmp[0]); //����ID  �ǼǺ�
		$('#PatName').val(tmp[1]); //�������� 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //�Ա�
		var bldrptSex=$('#PatSex').combobox('getValue');
		if(bldrptSex==1){
			$('#BG0').attr("checked",true);
			$("[name=bldrptGestation]:checkbox").attr("disabled",true);//�������Ͳ��ɹ�ѡ	
		}
		$('#PatAge').val(tmp[4]);  //����
		$('#PatAge').attr("disabled","true");
		$('#PatNo').val(tmp[5]);  //������
		//$('#PatNo').attr("disabled","true");
		$('#BrithDate').datebox({disabled:true}); //��������
		$('#BrithDate').datebox("setValue",tmp[6]);  
		$('#PatCardNo').val(tmp[7]);  //���֤��
		$('#PatCardNo').attr("disabled","true");
        $('#bldrptWard').combobox('setValue',tmp[12]);  //����
        $('#PatDiag').val(tmp[10]);  //�������
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
	var bldrptRepLocDr=$('#bldrptRepLocDr').val();
	if(bldrptRepLocDr==""){
		$.messager.alert("��ʾ:","�����ҡ�����Ϊ�գ�");
		return false;
	}
	//2����ˣ�������ǩ����
	var bldrptCreator=$('#bldrptCreator').val();
	if(bldrptCreator==""){
		$.messager.alert("��ʾ:","��������ǩ��������Ϊ�գ�");
		return false;
	}
	//3���������
	var bldrptRepNo=$('#bldrptRepNo').val();
	/*if(bldrptRepNo==""){
		$.messager.alert("��ʾ:","��������롿����Ϊ�գ�");
		return false;
	}*/ 
 	
	//4����������
	var bldrptCreateDateTime=$('#bldrptCreateDateTime').datetimebox('getValue');   
	if(bldrptCreateDateTime==""){
		$.messager.alert("��ʾ:","���������ڡ�����Ϊ�գ�");
		return false;
	}
	
	//8������ID
	var bldrptPatID=$('#PatID').val();
	if(bldrptPatID==""){
		$.messager.alert("��ʾ:","������ID������Ϊ�գ�");
		return false;
	}
	//9����������
	var bldrptName=$('#PatName').val();
	if(bldrptName==""){
		$.messager.alert("��ʾ:","����������������Ϊ�գ�");
		return false;
	}
    //10�������Ա�
	var bldrptSex=$('#PatSex').combobox('getValue');
	if(bldrptSex==""){
		$.messager.alert("��ʾ:","�������Ա𡿲���Ϊ�գ�");
		return false;
	}
    //11����������
	var bldrptAge=$('#PatAge').val();  
	if(bldrptAge==""){
		$.messager.alert("��ʾ:","���������䡿����Ϊ�գ�");
		return false;
	}
	//14���в�ʷ
	var bldrptGestation="";
    $("input[type=checkbox][name=bldrptGestation]").each(function(){
		if($(this).is(':checked')){
			bldrptGestation=this.value;
		}
	})
	if(bldrptGestation==""){
		$.messager.alert("��ʾ:","���в�ʷ������Ϊ�գ�");
		return false;
	}
	//15��������Ѫʷ
	var bldrptBloodhis="";
    $("input[type=checkbox][name=bldrptBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodhis=this.value;
		}
	})
	if(bldrptBloodhis==""){
		$.messager.alert("��ʾ:","��������Ѫʷ������Ϊ�գ�");
		return false;
	}
	//16����Ѫ��Ӧʷ
	var bldrptADVBloodhis="";
    $("input[type=checkbox][name=bldrptADVBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptADVBloodhis=this.value;
		}
	})
	if(bldrptADVBloodhis==""){
		$.messager.alert("��ʾ:","����Ѫ��Ӧʷ������Ϊ�գ�");
		return false;
	}
	//23��������Ѫ��ʼʱ��
	var bldrptStartDateTime=$('#bldrptStartDateTime').datetimebox('getValue');   
	if(bldrptStartDateTime==""){
		$.messager.alert("��ʾ:","����Ѫ��ʼʱ�䡿����Ϊ�գ�");
		return false;
	}
	var bldrptStartDateResult=bldrptStartDateTime.split(" ")[0];
	if(!compareSelTimeAndCurTime(bldrptStartDateResult)){
		$.messager.alert("��ʾ:","����Ѫ��ʼʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	//24����Ѫ��Ӧ����ʱ��
	var bldrptOccDateTime=$('#bldrptOccDateTime').datetimebox('getValue');   
	if(bldrptOccDateTime==""){
		$.messager.alert("��ʾ:","����Ѫ��Ӧ����ʱ�䡿����Ϊ�գ�");
		return false;
	}
	var bldrptOccDateResult=bldrptOccDateTime.split(" ")[0];
	if(!compareSelTimeAndCurTime(bldrptOccDateResult)){
		$.messager.alert("��ʾ:","����Ѫ��Ӧ����ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
		return false;	
	} 
	//25����Ѫ������/����
	var bldrptManf=$('#bldrptManf').val();   
	if(bldrptManf==""){
		$.messager.alert("��ʾ:","����Ѫ������/���š�����Ϊ�գ�");
		return false;
	}
	//27����Ѫ������Ӧ����
	var bldrptAnalyze=$('#bldrptAnalyze').val();
	if(bldrptAnalyze==""){
		$.messager.alert("��ʾ:","����Ѫ������Ӧ�������Ϊ�գ�");
		return false;
	}
	//28�����س̶�
	var bldrptSerLevel="";
    $("input[type=checkbox][name=bldrptSerLevel]").each(function(){
		if($(this).is(':checked')){
			bldrptSerLevel=this.value;
		}
	})
	if(bldrptSerLevel==""){
		$.messager.alert("��ʾ:","�����س̶ȡ�����Ϊ�գ�");
		return false;
	}
	//29�������
	var bldrptRelation="";
    $("input[type=checkbox][name=bldrptRelation]").each(function(){
		if($(this).is(':checked')){
			bldrptRelation=this.value;
		}
	})
	if(bldrptRelation==""){
		$.messager.alert("��ʾ:","������ԡ�����Ϊ�գ�");
		return false;
	}
	//30���ٴ�����
	var bldrptWardOp=$('#bldrptWardOp').val();
	if(bldrptWardOp==""){
		$.messager.alert("��ʾ:","���ٴ����á�����Ϊ�գ�");
		return false;
	}
	//31������ת��
	var bldrptPatInfo="";
	var bldrptDeathDateTime="";
	var bldrptDeathDate="";bldrptDeathTime="";

     $("input[type=checkbox][name=bldrptPatInfo]").each(function(){
		if($(this).is(':checked')){
			bldrptPatInfo=this.value;
		}
	})
	if(bldrptPatInfo==""){
		$.messager.alert("��ʾ:","������ת�顿����Ϊ�գ�");
		return false;
	}
	if(bldrptPatInfo=="1"){
		bldrptDeathDateTime=$('#bldrptDeathDateTime').datetimebox('getValue'); 
		if(bldrptDeathDateTime==""){
			$.messager.alert("��ʾ:","����ת��Ϊ��������,����д����ʱ�䣡");
			return false;
		}else{
			bldrptDeathDate=bldrptDeathDateTime.split(" ")[0];  //��������
			bldrptDeathTime=bldrptDeathDateTime.split(" ")[1];  //����ʱ��
		}
		if(!compareSelTimeAndCurTime(bldrptDeathDate)){
			$.messager.alert("��ʾ:","����ת��Ϊ���������ġ�����ʱ�䡿���ܴ��ڵ�ǰʱ�䣡");
			return false;	
		} 
	}	
	//32������Ѫ�����
	var bldrptBloodRelat="";
    $("input[type=checkbox][name=bldrptBloodRelat]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodRelat=this.value;
		}
	})
	if(bldrptBloodRelat==""){
		$.messager.alert("��ʾ:","������Ѫ����ԡ�����Ϊ�գ�");
		return false;
	}
	
	return true;
}
//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///��ѪǰԤ����ҩ
		if(id=="BD1"){
			$('#bldrptDrugRemark').attr("disabled",false);
		}
		///����ת��
		if(id=="BP1"){
			$('#bldrptDeathDateTime').datetimebox({disabled:false});
		}
	}else{
		///��ѪǰԤ����ҩ
		if(id=="BD1"){
			$('#bldrptDrugRemark').val("");
			$('#bldrptDrugRemark').attr("disabled",true);
		}
		///����ת��
		if(id=="BP1"){
			$('#bldrptDeathDateTime').datetimebox('setValue',"");
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
//��.js������function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	var bldrptPatID=$('#PatID').val();
	var bldrptPatID=getRegNo(bldrptPatID);
	$('#bldsgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatBldRecord&EpisodeID='+EpisodeID
	});
	getBldrptPatInfo(bldrptPatID,EpisodeID);
}
//ѡ���˵���Ѫ��¼
function GetPatBldRecord(EpisodeID)
{
			 
			 if (EpisodeID=="")
			 {
				 	$.messager.alert("��ʾ:","����ѡ���˾����¼��");
					return;
			 }

			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'issueId',title:'ID',width:60}, 
			 	{field:'issueDate',title:'��������',width:80}, 
			 	{field:'issueTime',title:'����ʱ��',width:80},
			 	{field:'IsTransBlood',title:'IsTransBlood',width:80},
			 	{field:'IsReaction',title:'IsReaction',width:80},
				{field:'IsReaction',title:'Parity',width:80},
			    {field:'IsReaction',title:'Gravidity',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetPatBldRecord&EpisodeID='+EpisodeID ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#bldsgrid', //grid ID
				 field:'issueId', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
			 var win=new CreatMyDiv(input,$("#BldRecBtn"),"bldsfollower","650px","335px","bldsgrid",mycols,mydgs,"","",SetBldTxtVal);	
			 win.init();
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
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+bldrptID+'&RepType='+bldrptReportType+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
}
function SetBldTxtVal()
{
}
//�жϱ�������Ƿ����
function RepNoRepet(){
	var IDflag=0;
	if (bldrptID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //��������Ԫ�ظ�ֵ
	/* //�������
	var bldRepNo=$('#bldrptRepNo').val();
	bldRepNo=bldRepNo.replace(/[ ]/g,""); //ȥ�������еĿո�
	$.ajax({
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=SeaBldRepNo&bldRepNo="+bldRepNo,
		async: false, //ͬ��
		success: function(data){
			$('#repnoflag',window.parent.document).val(data); //��������Ԫ�ظ�ֵ
		}
	}); */
}
