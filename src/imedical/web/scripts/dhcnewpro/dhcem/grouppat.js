///Creator:qqa
///Date:2018-09-12
$(function(){
	initParams();
	
	initCombobox();	
	
	initMethod();
	
	QueryGroupHurt();   // Ĭ�ϲ�ѯһ��
})

function initMethod(){
	///  Ⱥ�˲��˲��� lp 18-1-22
	$('#QueryGroupHurt').bind("click",QueryGroupHurt);  
	
	//����
	$('#GroupHurtBirth').blur(blurBrith);	
	
	//����
	$("#GroupHurtAge").on('change',changeAge)
	
	///�ǼǺ� �س��¼�
	$('#patRegNo').bind('keydown',GetEmPatInfo);
	
	$("#PatNo").bind('keydown',GetEmPatInfo);
	
    //Ⱥ���¼��ǼǺŻ��߲�ѯ 
    $('#QueryPatInfo').bind("click",QueryPatInfo); 
    
    //Ⱥ���¼����߹���
    $('#LinkPat').bind("click",LinkPat);
     
    //Ⱥ���¼�����ȡ������
    $('#CanLinkPat').bind("click",CanLinkPat); 
}

function initCombobox(){
	//Ⱥ�˵Ǽ��Ա�
	$('#GroupHurtSex').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTSex',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//$HUI.combobox('#GroupHurtSex').setValue(3);
	
	
	//Ⱥ������
	$('#GroupHurtNation').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTNation',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	
	
	//Ⱥ���¼�����
	$('#GroupHurtType').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetGroupHurtType&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true 
	})
}


/// Ⱥ�˲��˲�ѯ lp 18-1-22
function QueryGroupHurt(){
	var GroupHurtStDate=$('#GroupHurtStDate').combobox('getValue');
	var GroupHurtEndDate=$('#GroupHurtEndDate').combobox('getValue');
	var params=GroupHurtStDate+"^"+GroupHurtEndDate+"^"+LgHospID;
	$('#GroupPatGrid').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryGroupHurtNew',	
		queryParams:{
			params:params
		}
	});	
	ReloadPatList("");
}

/// Ⱥ�˲��˱��� lp 18-1-22
function SaveGroupHurtPat(){
	var GroupHurtType="";
	GroupHurtType=$('#GroupHurtType').combobox('getValue');
	if(GroupHurtType==""||typeof GroupHurtType=="undefined"){
		$.messager.alert('��ʾ��','��ѡ�������Ⱥ���¼���');	
		return;
	}
	var GroupHurtPatName="";
	GroupHurtPatName=$('#GroupHurtName').val();

	var GroupHurtPatSex=$('#GroupHurtSex').combobox('getValue');
	
	var GroupHurtPatAge =$('#GroupHurtAge').val();
	var GroupHurtPatBirth=$('#GroupHurtBirth').val();
	var GroupHurtPatNation=$('#GroupHurtNation').combobox('getValue');
	if(typeof GroupHurtNation=="undefined"){
		GroupHurtNation="";
	}
	
	var total=$('#GroupHurtPatTotal').val();
	if(total==""){
		$.messager.alert('��ʾ��','��¼��Ⱥ��������');
		return;	
	}
	
	total=parseInt(total);
	if(total==0){
		$.messager.alert('��ʾ��','Ⱥ����������Ϊ0��');
		return;	
	}
	
	var reg=/^[1-9]\d*$|^0$/;
	if(reg.test(total)==false){
    	$.messager.alert('��ʾ��','��¼����ȷ������');
    	return;
	}
	
	var GroupHurtDate = $HUI.datetimebox("#GroupHurtDate").getValue();
	
	//IE��֧�֣���̨��֤
	//if(GroupHurtDate!=""){
	//	if(new Date(GroupHurtDate)>new Date()){
	//		$.messager.alert('��ʾ:','Ⱥ�����ڲ��ܴ��ڵ�ǰ���ڣ�');
	//		return;	
	//	}	
	//}
	
	var GroupHurtSite = $("#GroupHurtSite").val();
	var GroupHurtDesc = $("#GroupHurtDesc").val();
	var params=GroupHurtType+"^"+GroupHurtPatName+"^"+GroupHurtPatSex+"^"+GroupHurtPatAge+"^"+GroupHurtPatNation+"^"+GroupHurtPatBirth+"^"+total+"^"+LgUserID;
	params=params+"^"+GroupHurtDate+"^"+GroupHurtSite+"^"+GroupHurtDesc+"^"+LgHospID;
	
	runClassMethod("web.DHCEMPatCheckLev","GroupHurtPatReg",{"params":params},function(data){
		var teg=data;
		if(teg<0){
			if(teg==-1){
				$.messager.alert('��ʾ��','Ⱥ�����ڲ��ܴ��ڵ�ǰ���ڣ�');
				return;		
			}else{
				$.messager.alert('��ʾ��','�Ǽ�ʧ�ܣ�');
				return;		
			}
		}else{
			$.messager.alert('��ʾ��','�Ǽǳɹ���');
			clearGroupHurtRegWin(); //���table����
			QueryGroupHurt();
		}
	})
}

/// Ⱥ�˲���˫���¼� lp 18-1-22
function ConveyInfo(rowIndex, rowData){
	return;
	$('#EmPatNo').val(rowData.GroupHurtReg);
	$('#empatname').val(rowData.GroupHurtName);
	$('#GroupHurtBirth').val(rowData.GroupHurtBirth);
	$('#GroupHurtAge').val(rowData.GroupHurtAge);
	$('#empatsex').combobox('setValue',rowData.GroupHurtSexDr);
	$('#emnation').combobox('setValue',rowData.GroupHurtNationDr);
	$('#emcountry').combobox('setValue',rowData.GroupHurtcountrydr);
	$('#PatientID').val(rowData.PatientID);
	$('#GroupHurtRegWin').window('close');
	ReportView(rowData)
	
}

function LoadPatList(rowIndex, rowData){
	ReloadPatList(rowData.Index);
}

function CheckThisPat(index,row){
	if(parent.top.frames[0]){
		parent.top.frames[0].initDefaultValue(); //hxy 2020-06-01 ��������
		parent.top.frames[0].$("#EmPatNo").val(row.PatNo);		/// �ǼǺ�
		parent.top.frames[0].GetEmRegPatInfo();
		parent.top.frames[0].CheckThree(); //hxy 2023-01-03
		parent.top.frames[0].websys_showModal("close");
	}
	return;
}

/// Ⱥ�˲���¼�� lp 18-1-22
function GroupHurtReg(){
	clearGroupHurtRegWin(); //���table����
	QueryGroupHurt(); //��ѯȺ�˲���
	if($('#GroupHurtRegWin').is(":hidden")){
		$('#GroupHurtRegWin').window('open');
		return;
	}  //���崦�ڴ�״̬,�˳�
		
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('Ⱥ�˲���¼��', 'GroupHurtRegWin', '600', '450', option).Init();
}


function clearGroupHurtRegWin(){
	$('#GroupHurtType').combobox('clear');//���
	$('#GroupHurtName').val("");
	$('#GroupHurtSex').combobox('clear');//���
	$('#GroupHurtAge').val("");
	$('#GroupHurtNation').combobox('clear');//���
	$('#GroupHurtPatTotal').val("");
	$('#GroupHurtBirth').val("");
   	$('#GroupHurtStDate').datebox("setValue",formatDate(0));
	$('#GroupHurtEndDate').datebox("setValue",formatDate(0));
	$HUI.datetimebox("#GroupHurtDate").setValue("");
	$("#GroupHurtSite").val("");
	$("#GroupHurtDesc").val("");
}


function blurBrith(){
	var mybirth = $('#GroupHurtBirth').val();
	if (mybirth != ""){
		if ((mybirth != "")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
			$('#GroupHurtBirth').val("");
			$.messager.alert("��ʾ:","��������ȷ������!");
			return;
		}
		
		if (mybirth.length==8){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8);
		}
		
		var mybirth = GetSysDateToHtml(mybirth);  /// ����Hisϵͳ����ת�����ڸ�ʽ
		if (mybirth == ""){
			$.messager.alert("��ʾ:","��������ȷ������!");
			return;
		}
		
		if(mybirth=="ERROR!"){
			$.messager.alert("��ʾ:","��������ȷ������!");
			$('#GroupHurtBirth').val("");
			return;	
		}
		
		$('#GroupHurtBirth').val(mybirth);
		setPatAge(mybirth);
	}
}

/// ��������
function setPatAge(borthdate){
    /// ȡ��������
    runClassMethod("web.DHCEMPatCheckLevQuery","GetPatientAgeDesc",{"PatientDOB":borthdate},function(jsonstring){
		if (jsonstring != null){
			$("#GroupHurtAge").val(jsonstring);
		}
	},'',false)
}


/// ȡHis����ά����ʾ��ʽ bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){
	//qqa 2018-01-09 �޸ĵ��õ�����
	runClassMethod("web.DHCEMPatCheckLevCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}

///��ʼ������
function initParams(){
	DateFormat = "";
	runClassMethod("web.DHCEMRegister","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
}

function changeAge(){

	date=$("#GroupHurtAge").val();
	if(date.trim()==""){
		return;
	}
	now=new Date();
	if(parseInt(date)<0){
		$.messager.alert("��ʾ:","���䲻��Ϊ����","",function(){
			$("#GroupHurtAge").val("")
			$("#GroupHurtAge").focus();
		});
		return;
	}

	/// ����������1����14��֮�䣬��ʾ����·ݣ���12��5�£�
	if (date.indexOf("��") != "-1"){
		dateArr=date.split("��");
		if (dateArr[1].indexOf("��") != "-1"){
			new Date(now.setMonth((new Date().getMonth()-dateArr[0]*12)));
			new Date(now.setMonth((new Date().getMonth()-parseInt(dateArr[1]))));
		}else{
			new Date(now.setMonth((new Date().getMonth()-dateArr[0]*12)));
		}
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// ����������1������1��֮�䣬��ʾ�·ݼ���������5��7�죻
	if (date.indexOf("��") != "-1"){
		dateArr=date.split("��");
		if (dateArr[1].indexOf("��") != "-1"){
			new Date(now.setMonth((new Date().getMonth()-dateArr[0])));
			newtimems=now.getTime()-(parseInt(dateArr[1])*24*60*60*1000);
			now.setTime(newtimems);
		}else{
			new Date(now.setMonth((new Date().getMonth()-dateArr[0])));
		}
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// ����������24Сʱ��1���£���ʾ�죬��19��
	if(date.indexOf("��") != "-1"){
		dateArr=date.split("��")
		newtimems=now.getTime()-(dateArr[0]*24*60*60*1000);
		now.setTime(newtimems);
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// ����������1Сʱ��24Сʱ֮�䣬��ʾСʱ����4Сʱ��
	if(date.indexOf("Сʱ")>=0){
		dateArr=date.split("Сʱ")
		newtimems=now.getTime()-(dateArr[0]*60*60*1000);
		now.setTime(newtimems);
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// ����������1Сʱ���ڣ� ��ʾ���ӣ���36���ӣ�
	if(date.indexOf("����")>=0){
		dateArr=date.split("����")
		newtimems=now.getTime()-(dateArr[0]*60*1000);
		now.setTime(newtimems);
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	if(parseInt(date)>175){
		$.messager.alert("��ʾ:","���䲻�ܴ���176��","",function(){
			$("#GroupHurtAge").val("")
			$("#GroupHurtAge").focus();
		});
		return;
	}

	/// Ĭ�����ְ�����������
	new Date(now.setMonth((new Date().getMonth()-$(this).val()*12)));
	var date = new Date().Format("dd/MM/yyyy");
	var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
	$("#GroupHurtBirth").val(nowdate);	
}


Date.prototype.Format = function (formatStr) {
    var str = formatStr;
    var Week = ['��', 'һ', '��', '��', '��', '��', '��'];

    str = str.replace(/yyyy|YYYY/, this.getFullYear());
    str = str.replace(/yy|YY/, (this.getYear() % 100) > 9 ? (this.getYear() % 100).toString() : '0' + (this.getYear() % 100));

    str = str.replace(/MM/, this.getMonth() > 9 ? (this.getMonth() + 1).toString() : '0' + (this.getMonth() + 1));
    str = str.replace(/M/g, this.getMonth());

    str = str.replace(/w|W/g, Week[this.getDay()]);

    str = str.replace(/dd|DD/, this.getDate() > 9 ? this.getDate().toString() : '0' + this.getDate());
    str = str.replace(/d|D/g, this.getDate());

    str = str.replace(/hh|HH/, this.getHours() > 9 ? this.getHours().toString() : '0' + this.getHours());
    str = str.replace(/h|H/g, this.getHours());
    str = str.replace(/mm/, this.getMinutes() > 9 ? this.getMinutes().toString() : '0' + this.getMinutes());
    str = str.replace(/m/g, this.getMinutes());

    str = str.replace(/ss|SS/, this.getSeconds() > 9 ? this.getSeconds().toString() : '0' + this.getSeconds());
    str = str.replace(/s|S/g, this.getSeconds());

    return str;
}


/// ��ʽ������  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}
//�༭����
function ReportView(rowData)
{
	
	var RegNO=rowData.GroupHurtReg
	var lnk = "dhcem.patchecklev.hisui.csp?RegNO="+RegNO;
	var openCss = 'width='+(window.screen.availWidth-100)+',height='+(window.screen.availHeight-100)+ ', top=100, left=50, location=no,toolbar=no, menubar=no, scrollbars=yes, resizable=no,status=no'
	window.open(lnk,'newwindow',openCss)
}


/// ������Ϣ��ѯ wxj-2020-09-27
function QueryPatInfo()
{
	var RowData = $("#GroupPatGrid").datagrid("getSelected");
	if(!RowData){
		$.messager.alert("��ʾ","δѡ��Ⱥ���¼���");
		return;
	}
	var Params = RowData.Index;
	var patRegNo=$('#patRegNo').val();  //���˵ǼǺ�
	ReloadPatList(Params);	
}
function ReloadPatList(Params){
	$('#GetpatInfo').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=GetPatInfo',	
		queryParams:{
			Params:Params
		}
	});	
}

///  �ǼǺŻس�
function GetEmPatInfo(e)
{
	 if(e.keyCode == 13)
	 {
		var EmPatNo = $("#PatNo").val();
		var EmPatNo = GetWholePatNo(EmPatNo);
		$("#PatNo").val(EmPatNo)
		SetPatMessage();
	 }
}

function SetPatMessage(){
	var EmPatNo = $("#PatNo").val();
	var QsIndex = $("#QsIndex").val();
	$.cm({ 
		ClassName:"web.DHCEMPatCheckLevQuery",
		MethodName:"GetPatientData",
		QsIndex:QsIndex,
		PatNo:EmPatNo,
		LgHospID:LgHospID
	},function (data){
		if(data=="-2"){
			$.messager.alert('��ʾ',"δ�ҵ���Ӧ���ߣ�");
			$("#PatNo").val("");
			$("#PatMessage").html("");
			$("#QsPatientID").val("");
			return;	
		}
		
		if(data=="-1"){
			$.messager.alert('��ʾ',"�����Ѿ�λ�ڴ�Ⱥ���¼��У�");
			$("#PatNo").val("");
			$("#QsPatientID").val("");
			$("#PatMessage").html("");
			return;	
		}
		
		var showPatMessage="<table cellspacing='0' cellpadding='0'><tr><td class='labeltitle'>"+$g("����")+":</td><td class='labeltext'>"+data.PatName+"</td><td class='labeltitle'>"+$g("�Ա�")+":</td><td class='labeltext'>"+data.PatSex+"</td></tr><tr><td class='labeltitle'>"+$g("����")+":</td><td class='labeltext'>"+data.PatAge+"</td><td class='labeltitle'>"+$g("��������")+":</td><td class='labeltext'>"+data.Birthday+"</td></tr></table>";
		$("#PatMessage").html(showPatMessage);
		$("#QsPatientID").val(data.PatientID);
	})
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

/// Ⱥ�˹�������
/// wxj 2020-09-27
function LinkPat(){
	var row = $('#GetpatInfo').datagrid('getSelected');
	if(!row){
		$.messager.alert('��ʾ��','��ѡ������Ļ��ߣ�');	
		return;
	}
	//alert(row.PatName)
	
	
    var patRegNo=$('#patRegNo').val();  //���˵ǼǺ�
    var GroupHurtType="";
	GroupHurtType=$('#GroupHurtType').combobox('getValue');
	if(GroupHurtType==""||typeof GroupHurtType=="undefined"){
		$.messager.alert('��ʾ��','��ѡ�������Ⱥ���¼���');	
		return;
	}
	var GroupHurtPatName="";
	    GroupHurtPatName=row.PatName;
	var GroupHurtPatSex=row.PatSex;
    var GroupHurtPatAge =row.PatAge;
    var GroupHurtPatID =row.PatID;
	var GroupHurtPatBirth=row.birthday;
	var GroupHurtPatNation=$('#GroupHurtNation').combobox('getValue');
	if(typeof GroupHurtNation=="undefined"){
		GroupHurtNation="";
	}
	var total=""
	var GroupHurtDate = $HUI.datetimebox("#GroupHurtDate").getValue();
	var GroupHurtSite = $("#GroupHurtSite").val();
	var GroupHurtDesc = $("#GroupHurtDesc").val();
	var params=GroupHurtType+"^"+GroupHurtPatName+"^"+GroupHurtPatSex+"^"+GroupHurtPatAge+"^"+GroupHurtPatNation+"^"+GroupHurtPatBirth+"^"+total+"^"+LgUserID;
	params=params+"^"+GroupHurtDate+"^"+GroupHurtSite+"^"+GroupHurtDesc+"^"+GroupHurtPatID;
	
	runClassMethod("web.DHCEMPatCheckLev","InsGroupHurtPat",{"params":params},function(data){
		var teg=data;
		if(teg<0){
			$.messager.alert('��ʾ��','�û����Ѿ�����Ⱥ���¼���');
			return;		
		}else{
			$.messager.alert('��ʾ��','�����ɹ���');
			//clearGroupHurtRegWin(); //���table����
			QueryGroupHurt();
		}
	})
   
}

/// Ⱥ��ȡ����������
/// wxj 2020-09-27
function CanLinkPat(){
	var row = $('#GetpatInfo').datagrid('getSelected');
	if(!row){
		$.messager.alert('��ʾ��','��ѡ��ȡ�������Ļ��ߣ�');	
		return;
	}
    var QsRowID =row.GPSRowID;
	runClassMethod("web.DHCEMPatCheckLev","DelGroupHurtPat",{"QsRowID":QsRowID},function(data){
		var teg=data;
		if(teg<0){
			$.messager.alert('��ʾ��','ȡ������ʧ�ܣ�');
			return;		
		}else{
			$.messager.alert('��ʾ��','ȡ�������ɹ���');
			QueryGroupHurt();
			$('#GetpatInfo').datagrid("reload");
		}
	})
   
}


function formatOp(value, rowData, rowIndex){
	return "<a href='#' onclick='AddGroupPat(\""+rowData.Index+"\")'>Add</a>"	
}
/// �¼����߹���
function LinkPat(){
	var row = $('#GroupPatGrid').datagrid('getSelected');
	if(!row){
		$.messager.alert('��ʾ��','��ѡ����������ݣ�');	
		return;
	}
	AddGroupPat(row.Index);
}

function AddGroupPat(Params){
	$("#QsIndex").val(Params);
	$("#AddGroupPatWin").window("open");
}

function qxAddGroupPat(){
	$("#PatNo").val("");
	$("#PatMessage").html("");
	$("#QsPatientID").val("");
	$("#QsIndex").val("");
	$("#AddGroupPatWin").window("close");
}

function qdAddGroupPat(){
	var PatientID = $("#QsPatientID").val();
	var QsIndex = $("#QsIndex").val();
	
	if(PatientID===""){
		$.messager.alert('��ʾ��','δѡ������Ļ��ߣ�');
		return;
	}
	
	$.cm({ 
		ClassName:"web.DHCEMPatCheckLev",
		MethodName:"InsGroupHurtPatNew",
		QsIndex:QsIndex,
		PatientID:PatientID
	},function (data){
		if(data==0){
			$.messager.alert('��ʾ��','��ӳɹ���');
			UpdateGroupHurtPatNum();
			qxAddGroupPat();
			ReloadPatList(QsIndex);
		}else{
			$.messager.alert('��ʾ��','���ʧ�ܣ�');
			return;
		}
	})
}

function UpdateGroupHurtPatNum(){
	
	var rowData = $('#GroupPatGrid').datagrid("getSelected");
	var rowIndex = $('#GroupPatGrid').datagrid("getRowIndex",rowData);
	var GroupHurtPatNum = parseInt(rowData.GroupHurtPatNum)+1;
	
	
	$('#GroupPatGrid').datagrid("updateRow",{
		index:rowIndex,
		row:{
			"GroupHurtPatNum":GroupHurtPatNum
		}
	});		
}
