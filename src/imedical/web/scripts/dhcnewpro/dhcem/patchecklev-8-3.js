
/// �°�Ǽ�ע���Ԥ�������JS  bianshuai 2016-04-25
var RowDelim=String.fromCharCode(1);  //�����ݼ�ķָ���
var m_CardNoLength = 0;               //���ų���

/// ҳ���ʼ������
function initPageDefault(){
	initView();
	initCombobox();  ///  ҳ��Combobox��ʼ����
	
	initBlButton();  ///  ҳ��Button ���¼�
	initCheckBoxEvent();     /// ��ʼ��ҳ��CheckBox�¼�
	initRadioEvent();        /// ��ʼ��ҳ��radio�¼�
	initCardTypeCombobox();  /// ��ʼ��ҳ�濨���Ͷ���
	initLoadEmPatLevDic();   /// ��ʼ�������ֵ�����
	initSymptomLevTree();    /// ��ʼ��֢״��
	initDataGrid();  ///  ҳ��DataGrid��ʼ����
	
	
}

function initView(){
	if(parPatientID==""){
		return;	
	}
	
	$("#PatientID").val(parPatientID)
	GetEmRegPatInfo()	
}
/// ҳ��Combobox��ʼ����
function initCombobox(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	
	/// ������
	var option = {
		onSelect:function(option){
			
	        var CardTypeDefArr = option.value.split("^");
	        m_CardNoLength = CardTypeDefArr[17];
	        
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#emcardno').attr("readOnly",false);
		    }else{
				$('#emcardno').attr("readOnly",true);
			}
			$('#emcardno').val("");  /// �������
	    }
	};
	var url = uniturl+"CardTypeDefineListBroker";
	new ListCombobox("emcardtype",url,'',option).init();

	/// �Ա�
	var url = uniturl+"jsonCTSex";
	new ListCombobox("empatsex",url,'').init();
	
	/// ����
	var url = uniturl+"jsonCTNation";
	new ListCombobox("emnation",url,'').init();
	
	/// ����
	var url = uniturl+"jsonCTCountry";
	new ListCombobox("emcountry",url,'').init();
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=";
	
	/// ���ķּ�ԭ��
	var url = uniturl+"jsonEmUpdLevReson&HospID="+LgHospID;
	new ListCombobox("EmUpdLevRe",url,'').init();
	
	/**	
	/// �������
	var url = uniturl+"jsonGetEmPatLoc";
	var option = {
        onSelect:function(option){
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+option.value;
	        $("#EmCheckNo").combobox('reload', url);
	    }
	};
	new ListCombobox("EmLocID",url,'',option).init();
	$("#EmLocID").combobox('setValue',LgCtLocID);
	
	/// �ű�
	var url = uniturl+"jsonGetEmPatChkCare&LocID="+LgCtLocID;
	var option = {
        onSelect:function(option){
	        if ($('input[name="SelEmCheckNo"][value="'+option.value+'"]').length == 0){
				var html = '<span><input type="checkbox" name="SelEmCheckNo" value="'+ option.value +'" checked>'+ option.text +'</input>&nbsp;&nbsp;</span>';
				$('#SelEmCheckNo').append(html);
	        }
	    }
	};
	new ListCombobox("EmCheckNo",url,'',option).init();
	**/
	/// �Ƽ��ּ�
	var EmRecLevelArr = [{"value":"1","text":'һ��'}, {"value":"2","text":'����'}, 
		{"value":"3","text":'����'}, {"value":"4","text":'�ļ�'}];
	new ListCombobox("EmRecLevel",'',EmRecLevelArr).init();
		
	/// ��ʹ��Χ
	var EmPainRangeArr = [{"value":"1","text":'����'}, {"value":"2","text":'����'}];
	new ListCombobox("EmPainRange",'',EmPainRangeArr).init();
	
	/// ��ʶ״̬
	var url = uniturl+"jsonPatAWare&HospID="+LgHospID;
	new ListCombobox("EmAware",url,'').init();
	
	$( "#slider" ).slider({
		onSlideEnd:function(value){
			/// ������ʹ�ּ���Ŀֵ
			$("#EmPainLev").val(value);
			$(".face-regin-title span").css({"color":""});
			$(".face-regin-title span:contains('["+value+"]')").css({"color":"#ff7a00"});
		}
	});
	
	///  ����ʱ��
	$("#emvistime").datebox("setValue",formatDate(0));

}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:'Ԥ�����',width:185,formatter:setCellLabel},
		{field:'PatNo',title:'����',width:100,hidden:true},
		{field:'PatName',title:'�ǼǺ�',width:100,hidden:true},
		{field:'PatSex',title:'�Ա�',width:100,hidden:true},
		{field:'PatAge',title:'����',width:100,hidden:true},
		{field:'PatientID',title:'PatientID',width:100,hidden:true},
		{field:'Adm',title:'Adm',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		//title:'�����б�',
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        clearEmPanel();				///  ���
	        setRegPanelInfo(rowData);   ///  ���õǼ������
	    },
		onLoadSuccess:function(data){
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            ///  ���÷�������
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	$("#tb .btn-success").html(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$("#tb .btn-warning").html(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$("#tb .btn-danger").html(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);
			$('.panel-title:contains("δ����")').html("�����б�(δ����:"+data.EmPatLevNotCnt+"��)");
		}
	};

	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryEmRegPatlist";
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  ����ˢ�°�ť
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false});  
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ����
	$('a:contains("����")').bind("click",readCard);
	
	///  �Ǽ�
	$('a:contains("�Ǽ�")').bind("click",register);
	
	///  �޸�
	$('a:contains("�޸�")').bind("click",modify);
	
	///  ȷ�Ϸ���
	$('button:contains("����")').bind("click",triage); 
	
	///  ���
	$('a:contains("���")').bind("click",clearEmPanel); 
	
    ///  �ǼǺŲ�ѯ
    $('#search').searchbox({ 
	   searcher:function(value,name){
		   QueryEmPatListByPatNo(value);
	   }
    });
	
	///	 �ǼǺ�
	$('#EmPatNo').bind('keypress',GetEmPatInfo);
	
	///  ����
	$('#emcardno').bind('keypress',GetEmPatInfoByCardNo);
	
	///	 ��ʹ�ּ�
	$('a:contains("��ʹ�ּ�")').bind("click",EmPatPainLevWin);
	
	///  ��ʹ�ּ�Ц����ť�¼�
	$(".face-regin li").bind("click",EmPainFaceEvt);
	
	///  ȡ��
	$('a:contains("ȡ��")').bind("click",cancelEmPainWin);
	
	///  ȷ��
	$('a:contains("ȷ��")').bind("click",sureEmPainWin);
	
	///  ֢״
	//$('.item��list li span').live("click",symItemListClick);
	
	$("#symList .button").live("click",symItemListClickNew);
	/// ���֤
	$('#emidentno').bind("blur",setEmBorth);
	
	///  ������ť�¼�
	$('#tb .btn-danger,#tb .btn-warning,#tb .btn-success').bind("click",EmPatWardClick);
	
	///  ��������
	$('input[name="EmPcs1"],input[name="EmPcs2"]').bind("blur",setEmRecLevel); 
	
	///  �ѷ��� / δ����
	$('#menu').menu({    
	    onClick:function(item){    
		    QueryEmPatList(item.name);
	    }    
	});
	
	///  ��ѯ����
	$('[title^="��ʾ"]').bind("click",function(e){
		
		$('#menu').menu('show', {    
		    left: e.pageX,
		    top: e.pageY
		}); 
	});
	
	///  ��������
	$('#emborth').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	///  ��ʹ����
	$('#EmPainTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
}

/// ��ʼ��ҳ�濨���Ͷ���
function initCardTypeCombobox(){
	
	/// ��ȡĬ�Ͽ�����
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		var defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
        if (CardTypeDefArr[16] == "Handle"){
	    	$('#emcardno').attr("readOnly",false);
	    }else{
			$('#emcardno').attr("readOnly",true);
		}
		$("#emcardtype").combobox("setValue",defaultCardTypeDr);
	},'',false)
}

/// ��ʼ��ҳ��CheckBox�¼�
function initCheckBoxEvent(){

	$("input[type=checkbox]").live('click',function(){
		///  ����ʷ�����ѡ
		if (this.name == "EmPatChkHis") {
			setEmRecLevel();
			return;
		}
		///  �ű�
		if (this.name == "SelEmCheckNo") {
			$(this).parent().remove();
			return;
		}
		///  ֢״
		if (this.name == "EmSymFeild") {
			$(this).parent().remove();
			id =this.value
			$("#symList .button").each(function(i,obj){
				if(obj.id==id){
					$(obj).removeClass("btn-success")
				}
				
			})
			setEmRecLevel();
			return;
		}
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
		})
		
		/// ��ʹ�ּ�
		if((this.name == "EmPainFlag")&(this.value == "N")) {
			$("#EmPainDesc").val("");  ///  ��ʹ�ּ�����
			$("#EmPainRange").combobox('setValue',"");    ///  ��ʹ��Χ
			$("#EmPainTime").datetimebox('setValue',"");  ///  ��ʹʱ��
			$("#EmPainLev").val("");  ///  ��ʹָ��
		}
		
		/// ��������
		if(this.name == "EmBatchFlag") {
			if (this.value == "N") {
				$("#EmBatchNum").val("");  ///  ��ҩ���
				$('#EmBatchNum').attr("disabled",true);
			}else{
				$('#EmBatchNum').attr("disabled",false);
			}
		}
			
		/// ��ҩ���
		if(this.name == "EmHisDrug") {
			if (this.value == "N") {
				$("#EmHisDrugDesc").val("");  ///  ��ҩ���
				$('#EmHisDrugDesc').attr("disabled",true);
			}else{
				$('#EmHisDrugDesc').attr("disabled",false);
			}
		}
		
		/// ������
		if(this.name == "EmMaterial") {
			if (this.value == "N") {
				$("#EmMaterialDesc").val("");  ///  ������
				$('#EmMaterialDesc').attr("disabled",true);
			}else{
				$('#EmMaterialDesc').attr("disabled",false);
			}
		}
		
		/// ��ʹ�ּ�
		if(this.name == "EmPainFlag") {
			if (this.value == "Y") {
				$('a:contains("��ʹ�ּ�")').linkbutton('enable');
			}else{
				$('a:contains("��ʹ�ּ�")').linkbutton('disable');
			}
		}
		
		///�ű�
		if(this.name == "EmCheckNo") {
			
			//alert($(this).attr("data_loc"))
			if ($('input[name="SelEmCheckNo"][value="'+this.value+'"]').length == 0){
				var html = '<span><input type="checkbox" name="SelEmCheckNo" value="'+ this.value +'" checked>'+ $(this).parent().text() +'</input>&nbsp;&nbsp;</span>';
				$('#SelEmCheckNo').append(html);
				$("#EmLocID").val($(this).attr("data_loc"))
	        }else{
		        $('input[name="SelEmCheckNo"][value="'+this.value+'"]').parent().remove();
		        $("#EmLocID").val();
		     }
		}	
	});
}

/// ��ʼ��ҳ��radio�¼�
function initRadioEvent(){

	$('input[type="radio"][name="NurseLevel"]').live('click',function(){
		var tmpvalue = this.value;
		if (tmpvalue != 1){
			tmpvalue = this.value - 1;
		}
		$('input[name="Area"][value="'+ tmpvalue +'"]').attr("checked",true);
	})
	
	$('input[type="radio"][name="Area"]').live('click',function(){
		var tmpvalue = this.value;
		if (tmpvalue != 1){
			tmpvalue = parseInt(this.value) + 1;
		}
		$('input[name="NurseLevel"][value="'+ tmpvalue +'"]').attr("checked",true);
	})
}

/// ��ʼ�������ֵ�����
function initLoadEmPatLevDic(){
	
	///   ����ʷ
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatChkHis",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatChkHis" value="'+ jsonObjArr[i].ID +'">'+ jsonObjArr[i].Desc +'</input>&nbsp;&nbsp;';
		}
		$('#EmPatChkHis').html(htmlstr);
	},'json',false)
	
	///   ������Դ
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatSource",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatSource" value="'+ jsonObjArr[i].ID +'">'+ jsonObjArr[i].Desc +'</input>&nbsp;&nbsp;';
		}
		$('#EmPatSource').html(htmlstr);
	},'json',false)
	
	///   ���﷽ʽ
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatAdmWay",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatAdmWay" value="'+ jsonObjArr[i].ID +'">'+ jsonObjArr[i].Desc +'</input>&nbsp;&nbsp;';
		}
		$('#EmPatAdmWay').html(htmlstr);
	},'json',false)
}

/// ����
function readCard(){
	
	$.messager.alert("��ʾ","����");
	/// ������ID
	var CardTypeRowId = "";
	var CardTypeValue = CardTypeComBo.getValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	if (myrtn==-200){ //����Ч
		$.messager.alert("��ʾ","����Ч!");
		return;
	}
	
	var myary = myrtn.split("^");
	var rtn = myary[0];
	
	switch (rtn) {
		case "0":
			//����Ч
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$("#emcardno").val(CardNo);     /// ����
			$("#EmPatNo").val(PatientNo);   /// �ǼǺ�
			GetEmRegPatInfo();
			break;
		case "-200":
			//����Ч
			$.messager.alert("��ʾ","����Ч!");
			break;
		case "-201":
			//�ֽ�
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$("#emcardno").val(CardNo);     /// ����
			$("#EmPatNo").val(PatientNo);   /// �ǼǺ�
			GetEmRegPatInfo();
			break;
		default:
	}
}

/// ���ز����б�
function hiddenPatListPanel(){
	
	runClassMethod("web.DHCEMPatCheckLevQuery","CheckIfHideEmPatList",{},function(val){

		if (val == "1"){
			$(".layout-panel-west").css({"display":"none"});
			$("#EmPatCenPanel").panel('resize',{
				width: $("#EmPatCenPanel").width()+210,
				height: $("#EmPatCenPanel").height(),
				left:0
			});
		}else{
			$("#EmPatCenPanel").panel({border:false});
		}
	},'',false)
}

/// �Ǽ�
function register(){
	
	var emcardtype = $("#emcardtype").combobox("getText");         /// ��������
	if (emcardtype == ""){
		$.messager.alert("��ʾ","����ѡ�����ͣ�");
		return;
	}
	
	var message = "";
	var CardTypeDr = $("#emcardtype").combobox("getValue");         /// ��������
	var CardTypeDefArr = CardTypeDr.split("^");
	if (CardTypeDefArr[16] == "Handle"){
		message = "���Ų���Ϊ��,�������뿨�ţ�";
	}else{
		message = "���Ų���Ϊ��,���ȶ�����";
	}
	
	var EmCardNo = $("#emcardno").val();         /// ����
	if (EmCardNo == ""){
		$.messager.alert("��ʾ",message);
		return;
	}
	if (m_CardNoLength != EmCardNo.length){
		$.messager.alert("��ʾ","����¼������,���ʵ�����ԣ�");
		return;
	}
	
	var EmIdentNo = $("#emidentno").val();        /// ֤������
	if (!$("#emidentno").validatebox('isValid')){
		$.messager.alert("��ʾ:","�����֤ʧ�ܣ�������¼�룡");
		return;
	}
		
	var EmFamTel = $("#emfamtel").val();         /// ��ͥ�绰
	if (!$("#emfamtel").validatebox('isValid')){
		$.messager.alert("��ʾ:","�绰��֤ʧ�ܣ�������¼�룡");
		return;
	}
	
	var EmPatName = $("#empatname").val();       /// ����
	if (EmPatName == ""){
		$.messager.confirm('��ʾ', '����Ϊ��,ȷ��Ҫ����������ݽ��еǼ���?', function(result){  
        	if(result) {
	        	regEmPatChkLv("");
	        }else{
		    	return;
		    }
	    })
	}else{
		regEmPatChkLv("");
	}
	
}

///  �Ǽ�
function regEmPatChkLv(EmPatModFlag){
	
	var PatientID = $("#PatientID").val();       /// PatientID
	var EmCardNoID = $("#EmCardNoID").val();     /// ����ID
	var EmCardNo = $("#emcardno").val();         /// ����
	
	var EmPatNo = $("#EmPatNo").val();           /// �ǼǺ�
	var EmPatName = $("#empatname").val();       /// ����
	var EmPatAge = $("#empatage").val();         /// ����
	var EmBorth = $("#emborth").datebox("getValue");        /// ��������
	
	var EmPatSex = $("#empatsex").combobox("getValue");     /// �Ա�
	var EmNation = $("#emnation").combobox("getValue");     /// ����
	var EmCountry = $("#emcountry").combobox("getValue");   /// ����
	
	var EmIdentNo = $("#emidentno").val();        /// ֤������
	var EmFamTel = $("#emfamtel").val();          /// ��ͥ�绰
	
	var EmVisTime = $("#emvistime").datebox("getValue");   /// ����ʱ��
	var EmAddress = $("#emaddress").val();        /// ��ͥסַ
	
	var EmCardType = $("#emcardtype").combobox("getValue"); /// �����Ͷ���
	
	/// ����ID^�ǼǺ�^����^���֤^�Ա�^��������^����^����^��ϵ�绰^��ͥ��ַ^����ID^����^�Ǽ���
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardType[0];

	/// ��������
	runClassMethod("web.DHCEMPatCheckLev","saveEmRegPat",{"PatListData":PatListData,"EmPatModFlag":EmPatModFlag},function(jsonString){
		
		var PatientID = jsonString;
		if (PatientID > 0){
			$.messager.alert("��ʾ:","����ɹ���");
			$("#dgEmPatList").datagrid("reload");
			$("#PatientID").val(PatientID);
			GetEmRegPatInfo(); /// ���ز��˵Ǽ���Ϣ
		}else if (PatientID == "-12"){
			$.messager.alert("��ʾ:","�˿��ѱ�ռ��,��¼���µĿ���Ϣ��");
		}else{
			$.messager.alert("��ʾ:","����ʧ�ܣ�");
		}
	})
}

/// �޸�
function modify(){
	
	var PatientID = $("#PatientID").val();       /// PatientID
	if (PatientID == ""){
		$.messager.alert("��ʾ:","��ѡ���ߣ����޸ļ�¼!");
		return;
	}
		
	var EmIdentNo = $("#emidentno").val();        /// ֤������
	if (!$("#emidentno").validatebox('isValid')){
		$.messager.alert("��ʾ:","�����֤ʧ�ܣ�������¼�룡");
		return;
	}
		
	var EmFamTel = $("#emfamtel").val();         /// ��ͥ�绰
	if (!$("#emfamtel").validatebox('isValid')){
		$.messager.alert("��ʾ:","�绰��֤ʧ�ܣ�������¼�룡");
		return;
	}
	
	regEmPatChkLv("M");
}

/// ȷ�Ϸ���
function triage(){
	surePatEmTriage();
}

/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	
	/*
	var htmlstr =  '<span style="margin-left:5px;">'+ rowData.PatName +'</span><span style="margin-left:30px;">'+ rowData.PatSex +'/'+ rowData.PatAge +'</span>';
		htmlstr = htmlstr + '<span style="display:block;margin-top:5px;margin-left:5px;">ID:'+ rowData.PatNo +'</span>';
	return htmlstr;
	*/
	var htmlstr =  '<div class="celllabel"><h3 style="float:left">'+ rowData.PatName +'</h3><h3 style="float:right"><span>'+ rowData.PatSex +'/'+ rowData.PatAge +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left">ID:'+ rowData.PatNo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.NurseLevel!=""){
			if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
			if(rowData.NurseLevel==2) {classstyle="color: #f22613"};
			htmlstr = htmlstr +'<h4 style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.NurseLevel+'��</span></h4>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// ���õǼ��������
function setRegPanelInfo(rowData){
		
	$("#EmCardNoID").val(rowData.CardNoID);   		/// ����ID
	$("#EmRegID").val(rowData.EmRegID);   		    /// �Ǽ�ID
	$("#emcardno").val(rowData.PatCardNo);   		/// ����
	$("#PatientID").val(rowData.PatientID);   		/// PatientID
	$("#Adm").val(rowData.Adm);
	
	$("#EmPCLvID").val(rowData.EmPCLvID);   		/// ����ID
	$("#EmPatNo").val(rowData.PatNo);   		    /// �ǼǺ�
	$("#empatname").val(rowData.PatName);   		/// ����
	$("#empatage").val(rowData.PatAge);        		/// ����
	
	$("#empatsex").combobox("setValue",rowData.sexId);    	 /// �Ա�
	$("#emnation").combobox("setValue",rowData.nationdr);    /// ����
	$("#emcountry").combobox("setValue",rowData.countrydr);  /// ����
	$("#emborth").datebox("setValue",rowData.birthday);      /// ��������
	
	$("#emidentno").val(rowData.IdentNo);   /// ֤������
	$("#emfamtel").val(rowData.PatTelH);    /// ��ͥ�绰
	$("#emaddress").val(rowData.Address);   /// ��ͥסַ
	$("#emvistime").datebox("setValue",rowData.EmRegDate);   /// ����ʱ��
	
	var EmPatLevWard = "��";
	if (rowData.NurseLevel == "3"){EmPatLevWard = "��";}
	if (rowData.NurseLevel == "4"){EmPatLevWard = "��";}
	if (rowData.NurseLevel == ""){EmPatLevWard = "δ��";}
	
	var NurseLevel = "";
	if (rowData.NurseLevel == ""){ NurseLevel = "δ��";}
	else{NurseLevel = rowData.NurseLevel;}
		
	var html = '<span class="word-green-deep font-18"><b>'+ rowData.PatName +'</b></span>';
		html = html + '<span class="padding-l25 word-green-deep">'+EmPatLevWard+'��</span>';
	    html = html + '<span class="padding-l25 fontsize-14 word-deep-gray">'+rowData.PatSex+'/'+rowData.PatAge+'/'+NurseLevel+'��/ID:'+rowData.PatNo+'/'+rowData.BillType+'/'+rowData.EmRegDate+" "+rowData.EmRegTime+'</span>';
	$(".item-label").html(html);
	
	GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  ���ÿ�����
	
	LoadEmPatCheckLevInfo(rowData.EmPCLvID);     ///  ��������Ѿ����зּ�,��ʾ�ּ�����
}

/// ��ȡ������Ϣ
function GetEmRegPatInfo(){
	
	var EmPatNo = $("#EmPatNo").val();      /// �ǼǺ�;
	var PatientID = $("#PatientID").val();  /// ����ID
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			setRegPanelInfo(rowData);
		}
	},'json',false)
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

///  ��ѯ�Ǽǲ����б�
function QueryEmPatListByPatNo(EmPatNo){
	
	///  �ǼǺŲ�0
	var EmPatNo = GetWholePatNo(EmPatNo);
	
	$(".searchbox-text").val(EmPatNo);
	var params = EmPatNo;
	$("#dgEmPatList").datagrid("load",{"params":params});
}

///  �ǼǺŻس�
function GetEmPatInfo(e){
	
	 if(e.keyCode == 13){
		var EmPatNo = $("#EmPatNo").val();
		///  �ǼǺŲ�0
		var EmPatNo = GetWholePatNo(EmPatNo);
		clearEmPanel();				///  ���
		$("#EmPatNo").val(EmPatNo);
		runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
			
			if (jsonString ==-1){
				$.messager.alert("��ʾ:","��ǰ����Ч,�����ԣ�");
				return;

			}else{
				GetEmRegPatInfo();
			}
			
		},'text',false)
		
	}
}

///  ���Żس�
function GetEmPatInfoByCardNo(e){

	if(e.keyCode == 13){
		var CardNo = $("#emcardno").val();
		var CardNoLen = CardNo.length;
		if (m_CardNoLength < CardNoLen){
			//$("#emcardno").focus().select();
			$.messager.alert("��ʾ:","�����������,������¼�룡");
			return;
		}

		/// ���Ų���λ��ʱ��0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		
		clearEmPanel();				///  ���
		
		$("#emcardno").val(CardNo);

		///  ���ݿ���ȡ�ǼǺ�
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){

			if (jsonString ==-1){
				$.messager.alert("��ʾ:","��ǰ����Ч,�����ԣ�");
				return;

			}else{
				EmPatNo = jsonString;
				$("#EmPatNo").val(EmPatNo);
			}
			
		},'text',false)

		GetEmRegPatInfo();
	}
}

///  Ч��ʱ����¼�����ݺϷ���
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		$.messager.alert("��ʾ:","��¼����ȷ��ʱ���ʽ��<span style='color:red;'>����:18:23,��¼��1823</span>");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("��ʾ:","Сʱ�����ܴ���23��");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("��ʾ:","���������ܴ���59��");
		return $('#'+ id).val();
	}
	
	return hour +":"+ itme;
}

/// ��ȡ�����ʱ��������
function SetEmPcsTime(id){
	
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}

///  ֢״�б����¼�
function symItemListClick(){

	if ($('input[name="EmSymFeild"][value="'+this.id+'"]').length == 0){
		var html = '<span><input type="checkbox" name="EmSymFeild" value="'+this.id+'" checked>'+ $(this).text() +'</input>&nbsp;&nbsp;</span>';
		$("#EmSymFeild").append(html);
	}
}

function symItemListClickNew(){
	if ($('input[name="EmSymFeild"][value="'+this.id+'"]').length == 0){
		var html = '<span><input type="checkbox" name="EmSymFeild" value="'+this.id+'" checked>'+ $(this).text() +'</input>&nbsp;&nbsp;</span>';
		$("#EmSymFeild").append(html);
		$(this).addClass("btn-success");
		setEmRecLevel();
		$('.panel-title:contains("֢״")').html("֢״:"+$("#SymptomLev").tree("getSelected").text);
	}
	
}

///  ����ͼ�����¼�
function EmPatWardClick(){
	
	$('#dgEmPatList').datagrid('load',{'params':"^"+this.id});
}

/// �ѷ���/δ����
function QueryEmPatList(EmChkFlag){

	$('#dgEmPatList').datagrid('load',{'params':"^^"+EmChkFlag});
}

/// Ԥ�����
function surePatEmTriage(){
	
	var EmRegID = $("#EmRegID").val();   			/// �Ǽ�ID
	if (EmRegID == ""){
		$.messager.alert("��ʾ:","��ǼǺ�,�ٽ��з��������");
		return;
	}
	var PatientID = $("#PatientID").val();   		/// PatientID
	if (PatientID == ""){
		$.messager.alert("��ʾ:","��ѡ�в��˺����ԣ�");
		return;
	}
	var EmPCLvID = $("#EmPCLvID").val();   			/// ����ID
	
	var EmBatchNum = $("#EmBatchNum").val();        /// ������

	var EmAgainFlag = "";
	if ($("input[name='EmAgainFlag']:checked").length){
		EmAgainFlag = $("input[name='EmAgainFlag']:checked").val();    /// �ط���ʶ
	}
	
	var EmBatchFlag = "";
	if ($("input[name='EmBatchFlag']:checked").length){
		EmBatchFlag = $("input[name='EmBatchFlag']:checked").val();    /// ��������
	}
	
	if ((EmBatchFlag == "Y")&($("#EmBatchNum").val() == "")){
		$.messager.alert("��ʾ:","����д������!");                     /// ��������Ϊ��,����������Ϊ��
		return;
	}
	
	var EmScreenFlag = "";
	if ($("input[name='EmScreenFlag']:checked").length){
		EmScreenFlag = $("input[name='EmScreenFlag']:checked").val();   /// ɸ��
	}
	
	var EmCombFlag = "";
	if ($("input[name='EmCombFlag']:checked").length){
		EmCombFlag = $("input[name='EmCombFlag']:checked").val();		/// ������
	}
	
	var EmECGFlag = "";
	if ($("input[name='EmECGFlag']:checked").length){
		EmECGFlag = $("input[name='EmECGFlag']:checked").val();	    	/// ECG
	}

	var EmPoisonFlag = "";
	if ($("input[name='EmPoisonFlag']:checked").length){
		EmPoisonFlag = $("input[name='EmPoisonFlag']:checked").val();   /// �ж�
	}
	
	var EmOxygenFlag = "";
	if ($("input[name='EmOxygenFlag']:checked").length){
		EmOxygenFlag = $("input[name='EmOxygenFlag']:checked").val();   /// �Ƿ�����
	}
	
	var EmPatAskFlag = "";
	if ($("input[name='EmPatAskFlag']:checked").length){
		EmPatAskFlag = $("input[name='EmPatAskFlag']:checked").val();   /// �ѿ�����
	}

	var EmPainFlag = "";
	if ($("input[name='EmPainFlag']:checked").length){
		EmPainFlag = $("input[name='EmPainFlag']:checked").val();       /// ��ʹ����
	}
	
	var EmPainRange = $("#EmPainRange").combobox('getValue');    /// ��ʹ��Χ
	if ((EmPainFlag == "Y")&(EmPainRange == "")){
		$.messager.alert("��ʾ:","��ʹ��Χ����Ϊ�գ�");
		return;
	}
	
	var EmPainTime = $("#EmPainTime").datetimebox('getValue');   /// ��ʹʱ��
	var EmPainDate = ""
	if (EmPainTime != ""){
		EmPainDate = EmPainTime.split(" ")[0];
		EmPainTime = EmPainTime.split(" ")[1];
	}
	if ((EmPainFlag == "Y")&(EmPainTime == "")){
		$.messager.alert("��ʾ:","��ʹʱ�䲻��Ϊ�գ�");
		return;
	}
	
	var EmPainLev = $("#EmPainLev").val();                       /// ��ʹ����
	if ((EmPainFlag == "Y")&(EmPainLev == "")){
		$.messager.alert("��ʾ:","��ʹ������Ϊ�գ�");
		return;
	}
	
	var EmAware = $("#EmAware").combobox("getValue");    	     /// ��ʶ״̬

	var EmUpdLevRe = $("#EmUpdLevRe").combobox("getValue");    	 /// ��ʿ���ķּ�ԭ��
	var EmLocID = $("#EmLocID").val()  //.combobox("getValue");    	     /// �������
	if (EmLocID == ""){
		$.messager.alert("��ʾ:","����ѡ�������ң�");
		return;
	}
	
	//var EmChekkNo = $("#EmCheckNo").combobox("getValue");    	 /// �ű�
	
	var EmNurseLevel = "";
	if ($('input[name="NurseLevel"]:checked').length){
		EmNurseLevel = $('input[name="NurseLevel"]:checked').val();  /// ��ʿ�ּ�
	}
	if (EmNurseLevel == ""){
		$.messager.alert("��ʾ:","����ѡ���˲���ּ���");
		return;
	}
	
	var EmRecLevel = $("#EmRecLevel").combobox("getValue");        	 /// �Ƽ��ּ�
	
	var EmArea = "";
	if ($('input[name="Area"]:checked').length){
		EmArea =  $('input[name="Area"]:checked').val();   			 /// ȥ�����
	}
	
	/// ��������
	var EmPcsTime = $("#EmPcsTime").val();      ///  ʱ��
	var EmPcsTime1 = $("#EmPcsTime1").val();    ///  ʱ��
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  ����
	var EmPcsTemp1 = $("#EmPcsTemp1").val();    ///  ����
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  ����
	var EmPcsHeart1 = $("#EmPcsHeart1").val();  ///  ����
	var EmPcsPulse = $("#EmPcsPulse").val();    ///  ����
	var EmPcsPulse1 = $("#EmPcsPulse1").val();  ///  ����
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  Ѫѹ(BP)����ѹ
	var EmPcsSBP1 = $("#EmPcsSBP1").val();      ///  Ѫѹ(BP)����ѹ
	var EmPcsDBP = $("#EmPcsDBP").val();        ///  ����ѹ
	var EmPcsDBP1 = $("#EmPcsDBP1").val();       ///  ����ѹ
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  Ѫ�����϶�SoP2
	var EmPcsSoP21 = $("#EmPcsSoP21").val();    ///  Ѫ�����϶�SoP2
	var EmPatChkSign1 = EmPcsTime + RowDelim + EmPcsTemp + RowDelim + EmPcsHeart + RowDelim + EmPcsPulse + RowDelim + EmPcsSBP + RowDelim + EmPcsDBP + RowDelim + EmPcsSoP2;
	var EmPatChkSign2 = EmPcsTime1 + RowDelim + EmPcsTemp1 + RowDelim + EmPcsHeart1 + RowDelim + EmPcsPulse1 + RowDelim + EmPcsSBP1 + RowDelim + EmPcsDBP1 + RowDelim + EmPcsSoP21;
	var EmPatChkSign = EmPatChkSign1 +"||"+ EmPatChkSign2;
	
	/// ����ʷ
	var EmPatChkHis = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHis.push(this.value);
	})
	EmPatChkHis = EmPatChkHis.join(RowDelim);

    ///  ������Դ
	var EmPatSource = "";
	if ($('input[name="EmPatSource"]:checked').length){
		EmPatSource = $('input[name="EmPatSource"]:checked').val();
	}

    ///  ���﷽ʽ
	var EmPatAdmWay = "";
	if ($('input[name="EmPatAdmWay"]:checked').length){
		EmPatAdmWay = $('input[name="EmPatAdmWay"]:checked').val();
	}
	
    ///  ��ҩ���
	var EmHisDrug = "",EmHisDrugDesc = "";
	if ($('input[name="EmHisDrug"]:checked').length){
		EmHisDrug = $('input[name="EmHisDrug"]:checked').val();
	}
	if (EmHisDrug == "Y"){
		EmHisDrugDesc = $("#EmHisDrugDesc").val();
	}
	
	///   ������
	var EmMaterial = "",EmMaterialDesc = "";
	if ($('input[name="EmMaterial"]:checked').length){
		EmMaterial = $('input[name="EmMaterial"]:checked').val();
	}
	if (EmMaterial == "Y"){
		EmMaterialDesc = $("#EmMaterialDesc").val();
	}

	///  ֢״
	var EmSymDesc = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDesc.push(this.value +"!"+ $.trim($(this).parent().text()));
	})
	EmSymDesc = EmSymDesc.join("#");

	///  ����
	var EmOtherDesc = $("#EmOtherDesc").val();
	
	/// ��ѡ�ű�
	var EmPatChkCare = [];
	$('input[name="SelEmCheckNo"]:checked').each(function(){
		EmPatChkCare.push(this.value);
	})
	EmPatChkCare = EmPatChkCare.join(RowDelim);
	if (EmPatChkCare == ""){
		$.messager.alert("��ʾ:","����ѡ��ű�");
		return;
	}
	
	///�����
	var Adm = $("#Adm").val();
	/// ���ﻤʿ^�Ƽ��ּ�^��ʿ�ּ�^��ʿ�ּ�ԭ��^ȥ�����^�������^�ط���ʶ^��������^������������^����ʷ
	/// ������Դ^���﷽ʽ^��ʶ״̬^ɸ��^��ҩ���^��ҩ�������^������^����������
	/// ��������^֢״��^֢״����^������^ECG^�ж�^��ʹ^��ʹ�ּ�^��ʹ��Χ^��ʹ����^��ʹʱ��^����^���^����ID^�Ǽ�ID^�ѹҺű�
	var EmListData = LgUserID +"^"+ EmRecLevel +"^"+ EmNurseLevel +"^"+ EmUpdLevRe +"^"+ EmArea +"^"+ EmLocID +"^"+ EmAgainFlag +"^"+ EmBatchFlag +"^"+ EmBatchNum +"^"+ EmPatChkHis;
	var EmListData = EmListData +"^"+ EmPatSource +"^"+ EmPatAdmWay +"^"+ EmAware +"^"+ EmScreenFlag +"^"+ EmHisDrug +"^"+ EmHisDrugDesc +"^"+ EmMaterial +"^"+ EmMaterialDesc;
	var EmListData = EmListData +"^"+ EmPatChkSign +"^"+ "" +"^"+ EmSymDesc +"^"+ EmCombFlag +"^"+ EmECGFlag +"^"+ EmPoisonFlag +"^"+ EmPainFlag +"^"+ EmPainLev +"^"+ EmPainRange +"^"+ EmPainDate +"^"+ EmPainTime;
	var EmListData = EmListData +"^"+ EmOxygenFlag +"^"+ EmPatAskFlag +"^"+ EmOtherDesc +"^"+ PatientID +"^"+ EmRegID +"^"+ EmPatChkCare+"^"+Adm;

	/// �����������
	runClassMethod("web.DHCEMPatCheckLev","saveEmPatCheckLev",{"EmPCLvID":EmPCLvID,"EmListData":EmListData},function(jsonString){
		
		var EmPCLvID = jsonString;
		if (EmPCLvID > 0){
			$.messager.alert("��ʾ:","����ɹ���");
			$("#EmPCLvID").val(EmPCLvID);   			/// ����ID
			$("#dgEmPatList").datagrid("reload");
			LoadEmPatCheckLevInfo(EmPCLvID);            /// ���¼��ط�����Ϣ
		}else{
			$.messager.alert("��ʾ:","����ʧ�ܣ�");
		}
	})
}

///  ��������Ѿ����зּ�,��ʾ�ּ�����
function LoadEmPatCheckLevInfo(EmPCLvID){

	/// ��ȡ�ּ�����
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheckLev",{"EmPCLvID":EmPCLvID},function(jsonString){
		//alert(jsonString)
		//return
		if (jsonString != null){
			var EmPatCheckLevObj = jsonString;
			
			///	 ������
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			///  �Ƽ��ּ�
			$("#EmRecLevel").combobox('setValue',EmPatCheckLevObj.EmRecLevel);

			///  ��ʿ���ķּ�ԭ��
			$("#EmUpdLevRe").combobox('setValue',EmPatCheckLevObj.EmUpdLevRe);

			///  �������
			$("#EmLocID").val(EmPatCheckLevObj.EmLocID) //.combobox('setValue',EmPatCheckLevObj.EmLocID);

			///  ��ʶ״̬
			$("#EmAware").combobox('setValue',EmPatCheckLevObj.EmAware);

			///  ��ʿ�ּ�
			$('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').attr("checked",'checked'); 
			
			///  ȥ��
			$('input[name="Area"][value="'+ EmPatCheckLevObj.Area +'"]').attr("checked",'checked'); 
			
			//alert(EmPatCheckLevObj.EmAgainFlag)
			///  ���ø�ѡ����
			/*
			$('input[type="checkbox"]').each(function(){
				if (this.name == "EmPatChkHis"){return;}
				$('[name="'+ this.name +'"][value="'+ EmPatCheckLevObj[this.name] +'"]').attr("checked",true);
			})
			*/
			//�ط���ʶ
			$('[name="EmAgainFlag"][value="'+ EmPatCheckLevObj.EmAgainFlag +'"]').attr("checked",true);
			//��������
			$('[name="EmBatchFlag"][value="'+ EmPatCheckLevObj.EmBatchFlag +'"]').attr("checked",true);
			///  ������Դ
			$('[name="EmPatSource"][value="'+ EmPatCheckLevObj.EmPatSource +'"]').attr("checked",true);
			
			///  ���﷽ʽ
			$('[name="EmPatAdmWay"][value="'+ EmPatCheckLevObj.EmPatAdmWay +'"]').attr("checked",true);
			
			///  �ж�
			$('[name="EmPoisonFlag"][value="'+ EmPatCheckLevObj.EmPoisonFlag +'"]').attr("checked",true);

			///  �Ƿ�����
			$('[name="EmOxygenFlag"][value="'+ EmPatCheckLevObj.EmOxygenFlag +'"]').attr("checked",true);

			///  ɸ��
			$('[name="EmScreenFlag"][value="'+ EmPatCheckLevObj.EmScreenFlag +'"]').attr("checked",true);

			///  ������
			$('[name="EmCombFlag"][value="'+ EmPatCheckLevObj.EmCombFlag +'"]').attr("checked",true);

			///  ECG
			$('[name="EmECGFlag"][value="'+ EmPatCheckLevObj.EmECGFlag +'"]').attr("checked",true);

			///  ��ҩ���
			$('[name="EmHisDrug"][value="'+ EmPatCheckLevObj.EmHisDrug +'"]').attr("checked",true);

			///  ������
			$('[name="EmMaterial"][value="'+ EmPatCheckLevObj.EmMaterial +'"]').attr("checked",true);

			///  ��ʹ�ּ�
			$('[name="EmPainFlag"][value="'+ EmPatCheckLevObj.EmPainFlag +'"]').attr("checked",true);

			///  �ѿ�����
			$('[name="EmPatAskFlag"][value="'+ EmPatCheckLevObj.EmPatAskFlag +'"]').attr("checked",true);
			
			
			///	 ��������			
			if (EmPatCheckLevObj.EmBatchNum != "") {
				$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
				$('#EmBatchNum').attr("disabled",false);
			}
															
			///	 ��ҩ���
			if (EmPatCheckLevObj.EmHisDrugDesc != "") {
				$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrugDesc);
				$('#EmHisDrugDesc').attr("disabled",false);
			}
			
			///	 ������
			if (EmPatCheckLevObj.EmMaterialDesc != "") {
				$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterialDesc);
				$('#EmMaterialDesc').attr("disabled",false);
			}
						
			///	 ����
			$("#EmOtherDesc").val(EmPatCheckLevObj.EmOtherDesc);
			
			///  ֢״
			if (EmPatCheckLevObj.EmSymDesc != ""){
				$("#EmSymFeild").html("");
				var EmSymFeildArr = EmPatCheckLevObj.EmSymDesc.split("#");
				for(var i=0;i<EmSymFeildArr.length;i++){
					var EmSymFeildID = EmSymFeildArr[i].split("!")[0];
					var EmSymFeildDesc = EmSymFeildArr[i].split("!")[1];
					var html = '<span><input type="checkbox" name="EmSymFeild" value="'+EmSymFeildID+'" checked>'+ EmSymFeildDesc +'</input>&nbsp;&nbsp;</span>';
					$("#EmSymFeild").append(html);
				}
			}

			///	 ����ʷ
			var EmPatChkHisArr = EmPatCheckLevObj.EmPatChkHis.split("#");
			for(var i=0;i<EmPatChkHisArr.length;i++){
				$('[name="EmPatChkHis"][value="'+ EmPatChkHisArr[i] +'"]').attr("checked",true);
			}
			
			///  Ԥ��ű�
			if (EmPatCheckLevObj.EmPatChkCare != ""){
				$("#SelEmCheckNo").html("");
				var EmPatChkCareArr = EmPatCheckLevObj.EmPatChkCare.split("#");
				for(var i=0;i<EmPatChkCareArr.length;i++){
					var EmPatChkCareID = EmPatChkCareArr[i].split("@")[0];
					var EmPatChkCareDesc = EmPatChkCareArr[i].split("@")[1];
					var html = '<span><input type="checkbox" name="SelEmCheckNo" value="'+ EmPatChkCareID +'" checked>'+ EmPatChkCareDesc +'</input>&nbsp;&nbsp;</span>';
					$('#SelEmCheckNo').append(html);
				}
			}
						
			///	 ��ʹ��Χ
			var EmPainVal = [];
			$("#EmPainRange").combobox('setValue',EmPatCheckLevObj.EmPainRange);
			if (EmPatCheckLevObj.EmPainRange != "") {
				EmPainVal.push("��ʹ��Χ:"+EmPatCheckLevObj.EmPainRangeDesc);
			}
			
			///	 ��ʹָ��
			$("#EmPainLev").val(EmPatCheckLevObj.EmPainLev);
			if (EmPatCheckLevObj.EmPainTime != "") {
				EmPainVal.push("��ʹ�ּ�:"+EmPatCheckLevObj.EmPainLev+"��");
			}
			
			///	 ��ʹʱ��
			$("#EmPainTime").datetimebox('setValue',EmPatCheckLevObj.EmPainTime);
			if (EmPatCheckLevObj.EmPainTime != "") {
				EmPainVal.push("��ʹʱ��:"+EmPatCheckLevObj.EmPainTime);
			}
			EmPainVal = EmPainVal.join("��");
	
			$("#EmPainDesc").val(EmPainVal);
			
			/// ���� �������ַ�(VAS)ָ��λ��
			$("#slider").slider("setValue",EmPatCheckLevObj.EmPainLev);
			/// ��ʹ�沿ͼƬѡ��
			//var $li = $(".face-regin li:eq('" +EmPatCheckLevObj.EmPainLev+ "')");
			//$li.find("span").css({"color":"#ff7a00"});
			//$li.siblings().find("span").css({"color":""});
			
			///	 ��������
			var flag="";
			var EmPatChkSignArr = EmPatCheckLevObj.EmPatChkSign.split("#");
			for(var i=0;i<EmPatChkSignArr.length;i++){
				if (i!=0){flag=1};
				var EmPcsArr = EmPatChkSignArr[i].split("@");
				$("#EmPcsTime"+flag).val(EmPcsArr[0]);   ///  ʱ��
				$("#EmPcsTemp"+flag).val(EmPcsArr[1]);   ///  ����
				$("#EmPcsHeart"+flag).val(EmPcsArr[2]);  ///  ����
				$("#EmPcsPulse"+flag).val(EmPcsArr[3]);  ///  ����
				$("#EmPcsSBP"+flag).val(EmPcsArr[4]);    ///  Ѫѹ(BP)����ѹ
				$("#EmPcsDBP"+flag).val(EmPcsArr[5]);    ///  ����ѹ
				$("#EmPcsSoP2"+flag).val(EmPcsArr[6]);   ///  Ѫ�����϶�SoP2
			}	

		}else{
			$('#EmBatchNum').attr("disabled",true);	
		}
	})
}

///	 ���
function clearEmPanel(){
	
	/// ��ѡ��
	$('input[type="checkbox"]').attr("checked",false);
	
	/// ��ѡ
	$('input[type="radio"]').attr("checked",false);
	
	/// �ı���
	$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})

	/// Combobox
	$('input.combobox-f').each(function(){
		if(this.id == "emcardtype"){return;}
		$("#"+ this.id).combobox("setValue","");
	})
	
	/// ����
	$('input.datebox-f').each(function(){
		if(this.id == "emcardtype"){return;}
		$("#"+ this.id).datebox("setValue","");
	})
	
	/// Ԥ��ű�
	$('#SelEmCheckNo').html("");
	
	/// ֢״
	$("#EmSymFeild").html("");
}

///  ��ʹ�ּ�����
function EmPatPainLevWin(){
	
	var EmPainFlag = "";
	if ($("input[name='EmPainFlag']:checked").length){
		EmPainFlag = $("input[name='EmPainFlag']:checked").val();       /// ��ʹ����
	}
	if (EmPainFlag != "Y"){
		return;
	}
	
	if($('#EmPatPainLevWin').is(":hidden")){
		$('#EmPatPainLevWin').window('open');
		return;}  //���崦�ڴ�״̬,�˳�
		
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('��ʹ�ּ�', 'EmPatPainLevWin', '850', '400', option).Init();
}

///  ��ʹ�ּ�Ц����ť�¼�
function EmPainFaceEvt(){
	
	$(this).find("span").css({"color":"#ff7a00"});
	$(this).siblings().find("span").css({"color":""});
	
	/// ������ʹ�ּ���Ŀֵ
	$("#EmPainLev").val($(this).index() * 2);
	
	/// ���� �������ַ���VAS�� ָ��λ��
	$("#slider").slider("setValue", $(this).index() * 2);
}

///  ȡ��
function cancelEmPainWin(){
	
	$('#EmPatPainLevWin').window('close');
}

///  ȷ��
function sureEmPainWin(){
	
	///  ��ʹ��Χ
	var EmPainRange = $("#EmPainRange").combobox('getText');
	if (EmPainRange == ""){
		$.messager.alert("��ʾ:","��ʹ��Χ����Ϊ�գ�");
		return;
	}
	///  ��ʹʱ��
	var EmPainTime = $("#EmPainTime").datetimebox('getValue');
	if (EmPainTime == ""){
		$.messager.alert("��ʾ:","��ʹʱ�䲻��Ϊ�գ�");
		return;
	}
	///  ��ʹָ��
	var EmPainLev = $("#EmPainLev").val();
	if (EmPainLev == ""){
		$.messager.alert("��ʾ:","��ʹָ������Ϊ�գ�");
		return;
	}
	$("#EmPainDesc").val("��ʹ��Χ:"+EmPainRange+", ��ʹʱ��:"+EmPainTime+", ��ʹ�ּ�:"+EmPainLev+"��");
	$('#EmPatPainLevWin').window('close');
}

/// ��ʼ��֢״��
function initSymptomLevTree(){

	var url = LINK_CSP+'?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmPatSymptomLev';
	var option = {
        onClick:function(node, checked){
	        GetSymptomFeild(node.id)
	    }
	};
	new CusTreeUX("SymptomLev", url, option).Init();
}

///  ����֢״֪ʶ��
function GetSymptomFeild(EmSymLevId){
	
	var htmlstr = "";
	runClassMethod("web.DHCEMPatCheckLevQuery","GetSymptomFeild",{"EmSymLevId":EmSymLevId},function(jsonString){
		var jsonObjArr = jsonString;

		for (var i=0; i<jsonObjArr.length; i++){
			//htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].EmSymFId +'">'+ jsonObjArr[i].EmSymFDesc +'</span></li>';
			htmlstr = htmlstr + '<button class="button" id="'+ jsonObjArr[i].EmSymFId +'" type="button">'+ jsonObjArr[i].EmSymFDesc +'</button>';
		}
		//$('.item��list ul').html(htmlstr);
		$('#symList').html(htmlstr);
	},'json',false)
}

/// ��ȡ���˶�Ӧ����������
function GetEmPatCardTypeDefine(CardTypeID){

	runClassMethod("web.DHCEMPatCheckLevCom","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#emcardno').attr("readOnly",false);
			}else{
				$('#emcardno').attr("readOnly",true);
			}
			$("#emcardtype").combobox("setValue",CardTypeDefine);
		}
	},'',false)
}

///  �����Ƽ��ּ�
///  $('input[name="EmPcs1"],input[name="EmPcs2"]')
function setEmRecLevel(){

	var EmPcsFlag = 1;
	var EmPcsListData = "";
	var EmPcsListData2 = "";
	
	/// ��ʶ״̬
	var EmAware = $("#EmAware").combobox("getValue");
	
	/// ����ʷ
	var EmPatChkHis = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHis.push(this.value);
	})
	EmPatChkHis = EmPatChkHis.join("$$");
	//
	EmPainLev=$("#EmPainLev").val();
	//
	///  ֢״
	var EmSymDesc = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDesc.push(this.value);
	})
	EmSymDesc = EmSymDesc.join("$$");
	
	/// (2)��������
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  ����
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  ����
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  Ѫѹ(BP)����ѹ
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  Ѫ�����϶�SoP2
	if ((EmPcsTemp!="")||(EmPcsHeart!="")||(EmPcsSBP!="")||(EmPcsSoP2!="")||(EmPainLev!="")||(EmSymDesc!="")){
		EmPcsListData = EmPcsSBP +"^"+ EmPcsSoP2 +"^"+ EmPcsHeart +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp+"^"+EmSymDesc+"^"+EmPainLev;
	}
	var EmPcsTemp1 = $("#EmPcsTemp1").val();    ///  ����
	var EmPcsHeart1 = $("#EmPcsHeart1").val();  ///  ����
	var EmPcsSBP1 = $("#EmPcsSBP1").val();      ///  Ѫѹ(BP)����ѹ
	var EmPcsSoP21 = $("#EmPcsSoP21").val();    ///  Ѫ�����϶�SoP2
	if ((EmPcsTemp1!="")||(EmPcsHeart1!="")||(EmPcsSBP1!="")||(EmPcsSoP21!="")||(EmPainLev!="")||(EmSymDesc!="")){
		EmPcsListData2 = EmPcsSBP1 +"^"+ EmPcsSoP21 +"^"+ EmPcsHeart1 +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp1+"^"+EmSymDesc+"^"+EmPainLev;
	}

	/// ϵͳ�Ƽ��ּ�
	if((EmPcsListData != "")||(EmPcsListData2!="")){
		if(EmPcsListData2!=""){EmPcsListData=EmPcsListData2}
		GetEmRecLevel(EmPcsListData);
	}
}

///  ��ȡϵͳ�Ƽ��ּ�
function GetEmRecLevel(EmPcsListData){
	
	runClassMethod("web.DHCEMCalPatLevel","calPatLevel",{"EmPCLvID":EmPcsListData},function(jsonString){
		
		if (jsonString != null){
			var EmRecLevel = jsonString;
			///  �Ƽ��ּ�
			$("#EmRecLevel").combobox('setValue',EmRecLevel);
		}
	},'',false)
}

///  ���ó�������
function setEmBorth(){
	
	if (!$("#emidentno").validatebox('isValid')){
		return;
	}
	var d;
	var value = $("#emidentno").val();
	var number = value.toLowerCase();
	var re = number.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/);
	if (re == null) return false;
	if (re[2].length == 9) {
		number = number.substr(0, 6) + '19' + number.substr(6);
		d = ['19' + re[4], re[5], re[6]].join('-');
	} else{
		d = [re[9], re[10], re[11]].join('-');
	}
	$("#emborth").datebox("setValue",d);      /// ��������
	$("#empatage").val(setEmPatAges(d));      /// ����
}

///  ��������
function setEmPatAges(dd){   
	var r = dd.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);     
	if(r == null){
		return "";
	}     
	var d = new Date(r[1],r[3]-1,r[4]);     
	if (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]){   
		var Y = new Date().getFullYear();   
		return (Y-r[1])+"��";   
	}   
	return "";   
}



/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

