var EmChkFlag=""; ///  �ѷ��� / δ���� 2016-09-20 congyue
var EmBtnFlag=""; ///  ������ť�¼� 2016-09-20 congyue
/// �°�Ǽ�ע���Ԥ�������JS  bianshuai 2016-04-25
var RowDelim=String.fromCharCode(1);  //�����ݼ�ķָ���
var arr=[],gcsArr=[],htmlStr1="",htmlStr2="",gcsArr2=[],aisArr=[],aisArr2=[],gcsStr="",gcsStr2="",aisStr="",aisStr2="";  //gcsStr,aisStr ���ڱ����ϴηּ�ʱ��ѡ�е�Ԫ��
var eascapeFlag=0;
var defaultCardTypeDr;
var num=0,EPnum=0    //yuliping ����˹���ܷ֣������ܷ�
var m_CardNoLength = 0;symItemListClickNew
var m_CCMRowID = "" ;
var SecurityNO = ""; /// ��ȫ�� bianshuai 2017-03-30
var EmCardNoFlag = 0;
var LgLocID = session['LOGON.CTLOCID'];
var TmpNurLev = "";  /// ��ʿ�ּ�
var EmNurReaID = ""; /// ��ʿ�޸ķּ�ԭ��

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
	
	//�س���������һԪ�� 2016-09-19 congyue add ggm 2016-11-24
	var $inp = $('.enter');//input:text
	$inp.bind('keydown', function (e) {
		var key = e.keyCode;
		if (key == 13) {
			var nxtIdx = $inp.index(this) + 1;
			$(".enter:eq(" + nxtIdx + ")").focus();
		}
	});
}
function initGreenHours(){
	
	//��ɫͨ��ʱЧ���� zhouxin
	if(GreenEffectSwitch>0){
		$("#greenHours").val(GreenEffectSwitch)
		//�Ƿ�����޸�ʱ��
		if(GreenModifyTime>0){
			$("#greenHours").attr("disabled",false)
		}else{
			$("#greenHours").attr("disabled",true)
		}	
	}else{
		$("#greenHours").parent().hide()	
	}
}
function initView(){
	initGreenHours();
	/// ��1��3��ģʽ��ת�ﲻ��ʾ�� bianshuai 2017-02-25
	/// ���¶��ǲ鵽td��ǩ�ĸ�Ԫ��tr��������
	if (PatRegType == 1){
		/// ���ط������
		$("td:contains('�������')").parent().css("display","none");
		/// ����ת�����
		$("td:contains('ת�����')").parent().css("display","none");
		/// �����ѹҺ�
		$("td.input-label-t3:contains('�ѹҺ�')").parent().css("display","none");
		/// Ĭ�Ϲ�ѡδ����
		$('input[name="EmCkLvFlag"][value="N"]').attr("checked",true);
	}
	if (PatRegType == 2){
		/// �����ѷ���
		$("td.input-label-t3:contains('�ѷ���')").parent().css("display","none");
		/// �����ѹҺű�
		$("td:contains('�ѹҺű�')").parent().css("display","none");
		/// Ĭ�Ϲ�ѡδ�Һ�
		$('input[name="EmEpiFlag"][value="N"]').attr("checked",true);
	}
	if (PatRegType == 3){
		/// ����ת�����
		$("td:contains('ת�����')").parent().css("display","none");
		/// �����ѹҺ�
		$("td.input-label-t3:contains('�ѹҺ�')").parent().css("display","none");
		/// Ĭ�Ϲ�ѡδ����
		$('input[name="EmCkLvFlag"][value="N"]').attr("checked",true);
	}
	if (PatRegType == 4){
		/// �����ѷ���
		$("td.input-label-t3:contains('�ѷ���')").parent().css("display","none");
		/// �����ѹҺű�
		$("td:contains('�ѹҺű�')").parent().css("display","none");
		/// Ĭ�Ϲ�ѡδ�Һ�
		$('input[name="EmEpiFlag"][value="N"]').attr("checked",true);
	}
	
	runClassMethod("web.DHCEMPatCheckLev","GetConfigBySession",{"Type":"AISSCORE"},function(data)
	{
	var trFlag = data
	if(trFlag == "N")
	{
	   $("#trFlag").hide();
	}
	},'text',false)
	runClassMethod("web.DHCEMPatCheckLev","GetConfigBySession",{"Type":"GLSSCORE"},function(data)
	{
	var trglsFlag = data
	if(trglsFlag == "N")
	{
	   $("#trglsFlag").hide();
	}
	},'text',false)
	if(parPatientID==""){
		return;	
	}
	
	$("#PatientID").val(parPatientID)
	GetEmRegPatInfo()	
}
/// ҳ��Combobox��ʼ����
function initCombobox(){
	$('#EmLocID').combobox({disabled:false})
	$('#EmCheckNo').combobox({disabled:false})
	$('#EmToLocID').combobox({disabled:true})

	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	
	/// ������  �����͵�combobox��onSelect�¼���
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
	        var CardTypeDefArr = option.value.split("^");
	        m_CardNoLength = CardTypeDefArr[17];
	        m_CCMRowID = CardTypeDefArr[14];
	        
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
	var url = uniturl+"jsonEmDocUpdReson&HospID="+LgHospID+"&Type=Nur";
	var option = {
		panelHeight:"auto"
		}
	new ListCombobox("EmUpdLevRe",url,"",option).init();
	
	
	/// �������
	var url = uniturl+"jsonGetEmPatLoc";
	var option = {
        onSelect:function(option){
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+option.value;
	        $("#EmCheckNo").combobox('reload', url);
	        $("#EmCheckNo").combobox('setValue',"");
	    },
	    onLoadSuccess: function () { //���ݼ�������¼�
            var data = $('#EmLocID').combobox('getData');
             if (data.length > 0) {
	            if(($('#EmToLocID').combobox('getValue')==0)){
                	//$("#EmLocID").combobox('select', data[0].value);
	            }
            } 
        }
	};
	new ListCombobox("EmLocID",url,'',option).init();
	
	/// ���Ȳ���
	var url = uniturl+"jsonWard&HospID="+LgHospID;
	var option = {
		panelHeight:"auto"
		}
	new ListCombobox("EmPatWard",url,'',option).init();
	$('#EmPatWard').combobox({disabled:true});  /// ��ʼ��ʱ�����Ȳ���������
	
	/// �ű�
	var url = uniturl+"jsonGetEmPatChkCare&LocID="+LgCtLocID;
	var option = {
        onSelect:function(option){
	        //if ($('input[name="SelEmCheckNo"][value="'+option.value+'"]').length == 0){
		    //		var html = '<span><input type="checkbox" name="SelEmCheckNo" value="'+ option.value +'" checked>'+ option.text +'</input>&nbsp;&nbsp;</span>';
			//	$('#SelEmCheckNo').append(html);
	        //}
	    },
		onShowPanel:function(){
			var EmLocID =$("#EmLocID").combobox("getValue"); 
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+EmLocID;
	        $("#EmCheckNo").combobox('reload', url);
		}
	};
	new ListCombobox("EmCheckNo",url,'',option).init();
	
	/**	2016-09-12 congyue **/
	//ת����� 
	var url = uniturl+"GetEmToLoc&HospID="+LgHospID;

	$('#EmToLocID').combobox({
    	url:url,
    	valueField:'value',
    	textField:'text',
    	onSelect:function(option){
	       $('#EmLocID').combobox({disabled:true})
	       $('#EmCheckNo').combobox({disabled:true})
	        
	    },
	    onChange:function(n,o){
			if(((n=="")&&(o!=""))){
				$('#EmLocID').combobox({disabled:false})
				$('#EmCheckNo').combobox({disabled:false})
			}	    
		}
	});	
	/// �Ƽ��ּ�
	var EmRecLevelArr = [{"value":"1","text":'1��'}, {"value":"2","text":'2��'}, 
		{"value":"3","text":'3��'}, {"value":"4","text":'4��'}];
	var option = {
		panelHeight:"auto"
		}
	new ListCombobox("EmRecLevel",'',EmRecLevelArr,option).init();
		
	/// ��ʹ��Χ
	var EmPainRangeArr = [{"value":"1","text":'����'}, {"value":"2","text":'����'}];
	new ListCombobox("EmPainRange",'',EmPainRangeArr).init();
	
	$("#slider" ).slider({
		step:1,
		onSlideEnd:function(value){
			/// ������ʹ�ּ���Ŀֵ
			$("#EmPainLev").val(value);
			$(".face-regin-title span").css({"color":""});
			$(".face-regin-title span:contains('["+value+"]')").css({"color":"#ff7a00"});
			if (value == 0){
				$('#EmPainRange').combobox({disabled:true});
				$('#EmPainTime').datebox({disabled:true});
			}else{
				$('#EmPainRange').combobox({disabled:false});
				$('#EmPainTime').datebox({disabled:false});
			}
		},
		onChange:function(newValue,oldValue){
			$("#EmPainLev").val(newValue);
			$(".face-regin-title span").css({"color":""});
			$(".face-regin-title span:contains('["+newValue+"]')").css({"color":"#ff7a00"});
		}
	});
	
	///  ����ʱ��
	$("#emvistime").datebox("setValue",formatDate(0));
	
	/// ��ʶ״̬
	var url = uniturl+"jsonPatAWare&HospID="+LgHospID;
	var option = {
		panelHeight:"auto",
		onSelect:function(record){
	        setEmRecLevel();
	        }
		}
	new ListCombobox("EmAware",url,'',option).init(); 

	//��ʼ���� congyue 2016-08-30
	$('#stadate').datebox("setValue","");
	
	//�������� congyue 2016-08-30
	$('#enddate').datebox("setValue","");
	
	/*
	$('#emborth').datebox('calendar').calendar({
    	validator: function(date){
        	var now = new Date();
        	var d1 = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        	var d2 = new Date("1840", "00", "01");
        	return ((date<=d1)&(date>=d2));
    	}
	});
	*/
	
	//����
	$("#empatage").on('change',function(){

		date=$(this).val();
		if(date.trim()==""){
			return;
		}
		now=new Date();
		if(parseInt(date)<0){
			$(this).val("")
			$.messager.alert("��ʾ:","���䲻��Ϊ����");
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
			$("#emborth").val(nowdate);
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
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// ����������24Сʱ��1���£���ʾ�죬��19��
		if(date.indexOf("��") != "-1"){
			dateArr=date.split("��")
			newtimems=now.getTime()-(dateArr[0]*24*60*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// ����������1Сʱ��24Сʱ֮�䣬��ʾСʱ����4Сʱ��
		if(date.indexOf("Сʱ")>=0){
			dateArr=date.split("Сʱ")
			newtimems=now.getTime()-(dateArr[0]*60*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// ����������1Сʱ���ڣ� ��ʾ���ӣ���36���ӣ�
		if(date.indexOf("����")>=0){
			dateArr=date.split("����")
			newtimems=now.getTime()-(dateArr[0]*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
			$("#emborth").val(nowdate);
			return;	
		}
		
		if(parseInt(date)>120){
			$.messager.alert("��ʾ:","���䲻�ܴ���120��");
			$(this).val("")
			return;
		}
		
		/// Ĭ�����ְ�����������
		new Date(now.setMonth((new Date().getMonth()-$(this).val()*12)));
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// ����Hisϵͳ����ת�����ڸ�ʽ
		$("#emborth").val(nowdate);
	})

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
	
	var Params = "^^N^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	
	$('#dgEmPatList').datagrid({
		
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryEmRegPatlist&params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        clearEmPanel();				  ///  ���
	        setRegPanelInfo(rowData,1);   ///  ���õǼ��������
	        if(rowData.QueDoc){
		      $("#queDoc").html(rowData.QueDoc)  
		    }
		    if (typeof rowData.uniqueID != "undefined"){
			    /// ȡ�ǼǶ���
				if (rowData.uniqueID == "A"){
					$("td:contains('�ѹҺű�')").parent().css("display","none");
					$("td:contains('�������')").parent().css("display","");
				}
				/// ȡ�ҺŶ���
				if (rowData.uniqueID == "B"){
				    $("td:contains('�������')").parent().css("display","none");
				    $("td:contains('�ѹҺű�')").parent().css("display","");
				}
		    }
	    },
		onLoadSuccess:function(data){
		//clearEmPanel();				///  ���
            	//setRegPanelInfo(data.rows[0],1);   ///  ���õǼ��������
	    if($('#regNo').val()=="OK"){
		setRegPanelInfo(data.rows[0],1);   ///  ���õǼ��������
		 if(data.rows[0].QueDoc){
		      $("#queDoc").html(data.rows[0].QueDoc)  
		 }
		$('#regNo').val("");
	    }		
	    if($('#regNo').val()){
		QueryEmPatListByPatNo($('#regNo').val());
		$('#regNo').val("OK");
		return;
		}	
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            ///  ���÷�������
            if (typeof data.EmPatLevTotal == "undefined"){
				data.EmPatLevTotal = "0";data.EmPatLevCnt1 = "0";data.EmPatLevCnt2 = "0";data.EmPatLevCnt3 = "0";
	         }
        	$("#tb .btn-success").html(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$("#tb .btn-warning").html(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$("#tb .btn-danger").html(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);
			//$('.panel-title:contains("δ����")').html("�����б�(δ����:"+data.EmPatLevNotCnt+"��)");
		}
	});
	///  ����ˢ�°�ť
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false});  
}

/// ҳ�� Button ���¼�
function initBlButton(){
	///  ��ӡ
	//$('a:contains("��ӡ")').bind("click",LevPrintout);
	$('#print').on("click",LevPrintout); 
	///  ����
	$('a:contains("����")').bind("click",readCard);
	
	///  �Ǽ�
	$('a:contains("�Ǽ�")').bind("click",register);
	
	///�����֤
	$('a:contains("�����֤")').bind("click",readPatID);
	
	///  �޸�
	$('a:contains("�޸�")').bind("click",modify);
	
	///  ȷ�Ϸ���
	$('#triage').on("click",triage); 
	
	///  ���
	$('a:contains("����")').bind("click",clearEmPanel); 
	
    ///  �ǼǺŲ�ѯ
    /*$('#search').searchbox({ 
	   searcher:function(value,name){
		   QueryEmPatListByPatNo(value);
	   }
    });
    ;*/
	 $('#search').searchbox({ 
	   searcher:function(value,name){
		   clearEmPanel();
		   clearCheckBox(); // ��ո�ѡ�� bianshuai 2018-03-09
		   QueryEmPatListByPatNo(value);
	   }
    })
    $('#Regno').bind('keypress',GetCardPatInfo);
	///	 �ǼǺ�
	$('#EmPatNo').bind('keypress',GetEmPatInfo);
	
	///  ����
	$('#emcardno').bind('keypress',GetEmPatInfoByCardNo);
	
	///	 ��ʹ�ּ�
	$('a:contains("��ʹ�ּ�")').bind("click",EmPatPainLevWin);
	
	///	 ��������
	$('a:contains("���˷ּ�")').bind("click",EmPatHurtLevWin);
	
	///����˹��ּ�
	$('a:contains("����˹��ּ�")').bind("click",GlasgowLevWin);
	
	///  ��ʹ�ּ�Ц����ť�¼�
	$(".face-regin li").bind("click",EmPainFaceEvt);
	
	///  ȡ��
	$('#cancelEmPain').bind("click",cancelEmPainWin);
	
	///  ��������ȡ��
	$('#cancelEmHurt').bind("click",cancelEmHurtWin);
	
	///  ȡ��
	$('#cancelEmGls').bind("click",cancelGlasgowLevWin);
	
	///  ȷ��
	$('#sureEmPain').bind("click",sureEmPainWin);
	
	///  �������ֱ���
	$('#sureEmHurt').bind("click",sureEmHurtWin);
	
	///  ȷ��
	$('#sureEmGls').bind("click",sureGlasgowLevWin);
	
	///  ����˹��ȷ��
	//$('#Glasgow_Btn_Qr').bind("click",sureGlasgowLevWin);
	
	///  ֢״
	//$('.item��list li span').live("click",symItemListClick);
	
	$("#symList .buttonsymptoms").live("click",symItemListClickNew);
	/// ���֤
	$('#emidentno').bind("blur",function(e){
		if (EmCardNoFlag == 1) return;
		setEmPatBaseInfo($(this).val());
	});
	
	$('#emidentno').keydown(function(e){
		if(e.keyCode==13){
			EmCardNoFlag= 1;
			setEmPatBaseInfo($(this).val());
			setTimeout("EmCardNoFlag= 0",1000);
		}
	})
	
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
	$('#emborth').bind('keydown',setBrith);
	
	$('#emborth').blur(blurBrith);
	
	/// ��������
	$('#empatname').keydown(function(e){
		if(e.keyCode==13){
			$('#emborth').focus();
		}
	});
	
	///  ��ʹ����
	$('#EmPainTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

	//���ڲ�ѯ 2016-08-26 congyue
	$('[title^="���ڲ�ѯ"]').bind("click",function(e){
		$('.datetime-search').each(function(){
	   		if ($(this).css('display')=='none'){
		   		$(this).css('display','block');
		   		$('#stadate').datebox("setValue",formatDate(0));
		   		$('#enddate').datebox("setValue",formatDate(0));
				QueryEmPatListByTime();
		   	}else{
			   	$(this).css('display','none');
				$('#stadate').datebox("setValue","");  //��ʼ���� 2016-09-19 congyue
				$('#enddate').datebox("setValue","");  //�������� 2016-09-19 congyue
				QueryEmPatListByTime();
			 }    
	   });
	});

	///  ȡ��
	$('#nurcancel').bind("click",cancelNurLevWin);
	
	///  ȷ��
	$('#nursure').bind("click",surePatEmLev);
}

/// ��ʼ��ҳ�濨���Ͷ���
function initCardTypeCombobox(){
	
	/// ��ȡĬ�Ͽ�����
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
        m_CCMRowID = CardTypeDefArr[14];
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
		
		///�����ֿ��Զ�ѡ
		if (this.name == "EmPatSixSick") {
			return;
		}
		
		///  �ű�
		if (this.name == "SelEmCheckNo") {
			$(this).parent().remove();
			
			if($.trim($("#SelEmCheckNo").html())==""){
				//$('#EmToLocID').combobox({disabled:false})	
			}else{
				//$('#EmToLocID').combobox({disabled:true})
			}
			return;
		}
		///  ֢״
		if (this.name == "EmSymFeild") {
			$(this).parent().remove();
			id =this.value
			$("#symList .buttonsymptoms").each(function(i,obj){
				if(obj.id==id){
					$(obj).removeClass("btn-successsymptoms")
				}
				
			})
			arr.splice($.inArray(id,arr),1);
			if(arr.length==0){
				$("#EmSymFeildTitle").html("��������...")	
			}
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
		/// ����˹��ּ�
		if((this.name == "GlasgowFlag")&(this.value == "N")) {
			$("#GlasgowDesc").val("");  ///  ����˹��ּ�����
			htmlStr2="";
			gcsStr="";
			//$("#EmPainRange").combobox('setValue',"");    ///  ��ʹ��Χ
			//$("#EmPainTime").datetimebox('setValue',"");  ///  ��ʹʱ��
			//$("#EmPainLev").val("");  ///  ��ʹָ��
		}
		/// ���˷ּ�
		if((this.name == "AISActiveFlag")&(this.value == "N")) {
			$("#EmHurtDesc").val("");  ///  ����˹��ּ�����
			htmlStr1="";
			aisStr="";
			//$("#EmPainRange").combobox('setValue',"");    ///  ��ʹ��Χ
			//$("#EmPainTime").datetimebox('setValue',"");  ///  ��ʹʱ��
			//$("#EmPainLev").val("");  ///  ��ʹָ��
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
		/// ��������
		if(this.name == "AISActiveFlag") {
			if (this.value == "Y") {
				$('a:contains("���˷ּ�")').linkbutton('enable');
			}else{
				$('a:contains("���˷ּ�")').linkbutton('disable');
			}
		}
		/// ����˹����Էּ�
		if(this.name == "GlasgowFlag") {
			if (this.value == "Y") {
				$('a:contains("����˹��ּ�")').linkbutton('enable');
			}else{
				$('a:contains("����˹��ּ�")').linkbutton('disable');
			}
		}
		///�ű�
		if(this.name == "EmCheckNo") {
			
			//alert($(this).attr("data_loc"))
			if ($('input[name="SelEmCheckNo"][value="'+this.value+'"]').length == 0){
				var html = '<span><input type="checkbox" data_loc='+$(this).attr("data_loc")+' name="SelEmCheckNo" value="'+ this.value +'" checked >'+ $(this).parent().text() +'</input>&nbsp;&nbsp;</span>';
				//$('#SelEmCheckNo').append(html);
				//$("#EmLocID").val($(this).attr("data_loc"));
				//$('#EmToLocID').combobox({disabled:true}); //2016-09-12  congyue
				//$('#EmToLocID').combobox('setValue',""); //2016-09-12  congyue
	        }else{
		        //$('input[name="SelEmCheckNo"][value="'+this.value+'"]').parent().remove();
		        //$("#EmLocID").val();
		        //$('#EmToLocID').combobox({disabled:false}); //2016-09-21 congyue
		     }
		}

		/// �ѷ��δ����
		if(this.name == "EmCkLvFlag") {
			var EmCkLvFlag = "";
			if ($("input[name='EmCkLvFlag']:checked").length){
				EmCkLvFlag = $("input[name='EmCkLvFlag']:checked").val();
			}
			
			QueryEmPatList(EmCkLvFlag); /// ���ò�ѯ�б�
		}
		
		/// �ѹҺš�δ�Һ�
		if(this.name == "EmEpiFlag") {
			var EmEpiFlag = "";
			if ($("input[name='EmEpiFlag']:checked").length){
				EmEpiFlag = $("input[name='EmEpiFlag']:checked").val();
			}
			QueryEmPatList(EmEpiFlag); /// ���ò�ѯ�б�
		}
		
		/// ת���Ƿ����
		if(this.name == "EmToLocFlag") {
			if($("input[name='EmToLocFlag']").is(':checked')) {
				$('#EmLocID').combobox('setValue',"");    	         /// �������
				$('#EmLocID').combobox({disabled:true});
				$('#EmCheckNo').combobox({disabled:true});
				$('#EmToLocID').combobox('enable');
				$("input[name='EmGreenFlag']").attr("disabled",true); /// ��ɫͨ��
			}else{
				$('#EmLocID').combobox('enable');
				$('#EmCheckNo').combobox('enable');
				$('#EmToLocID').combobox({disabled:true});
				$("input[name='EmGreenFlag']").attr("disabled",false); /// ��ɫͨ��
			}
		}
	});
}

/// ��ʼ��ҳ��radio�¼�
function initRadioEvent(){

	$('input[type="radio"][name="NurseLevel"]').on('click',function(){
		var tmpvalue = this.value;
		if (tmpvalue != 1){
			tmpvalue = this.value - 1;
		}
		$('input[name="Area"][value="'+ tmpvalue +'"]').attr("checked",true);
		setComponentEnable("",tmpvalue);
	})
	
	$('input[type="radio"][name="Area"]').on('click',function(){
		var tmpvalue = this.value;
		if (tmpvalue != 1){
			tmpvalue = parseInt(this.value) + 1;
		}
		$('input[name="NurseLevel"][value="'+ tmpvalue +'"]').attr("checked",true);
		setComponentEnable("",tmpvalue);
	})
}
/// ��ʼ�������ֵ�����
function initLoadEmPatLevDic(){
	
	///  ������Ⱥ 2016-09-05 ����
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatChkType",{"":""},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=1; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatChkType" value="'+ jsonObjArr[i].ID +'"><span>'+ jsonObjArr[i].Desc +'</span></input>&nbsp;&nbsp;';
		}
		$('#EmPatChkType').html(htmlstr);
	},'json',false)
	
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
	
	///   ������
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatChkSpec",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatSixSick" value="'+ jsonObjArr[i].ID +'">'+ jsonObjArr[i].Desc +'</input>&nbsp;&nbsp;';
		}
		$('#EmPatSixSick').html(htmlstr);
	},'json',false)
}

/// ��ȡ���֤
function readPatID(){
	
	try{
		var myInfo=DHCWCOM_PersonInfoRead("1");
	}catch(e){
		alert(e.message)   
	}
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		//str="<IDRoot><Age>24</Age><Name>��ΰ</Name><Sex>��</Sex><NationDesc>01</NationDesc><Birth>1988-08-19</Birth><Address>ɽ��ʡ��Ӫ�ж�Ӫ����һ·739��</Address><CredNo>37078419880819641X</CredNo></IDRoot>"
		var str=myary[1];
		var result = $.parseXML(str);
		var EmIdentno = $(result).find('CredNo').text();
		if (GetPatientID(EmIdentno) != ""){
			setEmPatBaseInfo(EmIdentno);
		}else{
			$("#empatname").val($(result).find('Name').text());
			$("#emidentno").val($(result).find('CredNo').text());
			/// ���ó�������
			var mybirth = $(result).find('Birth').text();
			if (mybirth != ""){
				if (mybirth.length==8){
					var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8);
				}
				var mybirth = GetSysDateToHtml(mybirth);  /// ����Hisϵͳ����ת�����ڸ�ʽ
				$('#emborth').val(mybirth);
			}
			$("#empatage").val($(result).find('Age').text());
			$("#empatname").val($(result).find('Name').text());
			$("#emaddress").val($(result).find('Address').text());
			/// ��������
			var PatNation = $(result).find('NationDesc').text();
			if (PatNation != ""){
				$("#emnation").combobox('setValue',TransNationToID(PatNation));
			}
			/// �����Ա�
			var PatSex = $(result).find('Sex').text();
			if (parseInt(PatSex) % 2 == 1) {
				$("#empatsex").combobox("setValue",TransPatSexToID("��"));
			}else{ 
				$("#empatsex").combobox("setValue",TransPatSexToID("Ů"));
			}
		}
		
		//ʹ�ö�ȡ����Ƭ�����ļ� 2018-03-17 bianshuai
		var src = ""
		if ($(result).find('PhotoInfo').text() != ""){
			src="data:image/png;base64," + $(result).find('PhotoInfo').text();
			$("#imgPic").attr("src",src);
		}
		
	}
}

/// ����
function readCard(){
	
	/*  ��������Ŀ����
	
	/// ������ID
	var CardTypeRowId = "";
	var CardTypeValue = $("#emcardtype").combobox("getValue");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardTypeValue);
	if (myrtn==-200){ //����Ч
		$.messager.alert("��ʾ","����Ч-1!");
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
	}*/
	ReadMagCard_Click();
	
}

// ���հ׿� QQA 
function ReadMagCard_Click()
{

	runClassMethod ("web.DHCOPConfig","GetVersion",{},
		function(myVersion){
			if (myVersion=="12"){
				M1Card_InitPassWord();
   			}
   			
   			var CardTypeRowId = "";
			var CardTypeValue = $("#emcardtype").combobox("getValue");
			var m_CCMRowID=""
			if (CardTypeValue != "") {
				var CardTypeArr = CardTypeValue.split("^");
				m_CCMRowID = CardTypeArr[14];
			}
			var rtn=DHCACC_ReadMagCard(m_CCMRowID,"R", "2");  //QQA
			
   			var myary=rtn.split("^");
   			if (myary[0]!="0"){
	   			$.messager.alert("��ʾ","����Ч!");
	   		}
   			
			if ((myary[0]=="0")&&(myary[1]!="undefined")){
				//$("#EmPatNo").val(myDataArr[2]);      /// �ǼǺ�;
				//$("#PatientID").val(myDataArr[3]);  /// ����ID
				$('#emcardno').val(myary[1]);
				GetValidatePatbyCard();
			}			
		},"text",false
	)
}

function M1Card_InitPassWord()
{
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
  }catch(e)
  {
  	}
}

function GetValidatePatbyCard()
{
	
	var myCardNo = $('#emcardno').val();   //����
	 
	var SecurityNo=""
	var myExpStr=""
	var CardTypeRowId=""
	
	var CardTypeValue =$("#emcardtype").combobox("getValue");

	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}

	runClassMethod("web.DHCBL.CARDIF.ICardRefInfo","ReadPatValidateInfoByCardNo",
		{'CardNO':myCardNo,
		 'SecurityNo':SecurityNo,
		 'CardTypeDR':CardTypeRowId,   //ȫ�ֱ���
		 'ExpStr':myExpStr
		},
		function(data){
			
			if (data=="") { return;}
			var myary=data.split("^");
			if(myary[0]=="0"){
				
			}else if(myary[0]=="-341"){
				runClassMethod("web.DHCEMPatientSeat","GetPatInfo",{'CardNo':$('#emcardno').val(),'RegNo':''},
					function(myData){
						var myDataArr= myData.split("^");
						if(myDataArr[0]=="0"){
								$("#EmPatNo").val(myDataArr[2]);      /// �ǼǺ�;
								$("#PatientID").val(myDataArr[3]);  /// ����ID
								GetEmRegPatInfo();
								return;
						}
					},"text"
				)
			}else{
				clearEmPanel();   //��տ�����Ϣ
				
				switch(myary[0]){
					case "-340":
						$.messager.alert("��ʾ","����ʱ,�˿��Ѿ��ж�Ӧ�ĵǼǺ���,������������");
						break;
					case "-350":
						$.messager.alert("��ʾ","�˿��Ѿ�ʹ��,�����ظ�����!");
						break;
					case "-351":
						$.messager.alert("��ʾ","�˿��Ѿ�����ʧ,����ʹ��!");
						break;
					case "-352":
						$.messager.alert("��ʾ","�˿��Ѿ�������?����ʹ��!");
						break;
					case "-356":
						$.messager.alert("��ʾ","����ʱ,����Ҫ����������¼,���Ǵ˿����ݱ�Ԥ�����ɴ���!");
						break;
					case "-357":
						$.messager.alert("��ʾ","����ʱ,����Ҫ����¿���¼,���Ǵ˿�����û��Ԥ������!");
						break;
					case "-358":
						$.messager.alert("��ʾ","����ʱ,�˿��Ѿ��ж�Ӧ�ĵǼǺ���,������������");
						break;
					default:
						$.messager.alert("Error Code:" +myary[0]);
						break;
				}
				
					
			}
			
		},"text",false
	)
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
	if (!checkSex())return;	
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
	var EmBorth = $("#emborth").val();        /// ��������
	
	var EmPatSex = $("#empatsex").combobox("getValue");     /// �Ա�
	var EmNation = $("#emnation").combobox("getValue");     /// ����
	var EmCountry = $("#emcountry").combobox("getValue");   /// ����
	
	var EmIdentNo = $("#emidentno").val();        /// ֤������
	var EmFamTel = $("#emfamtel").val();          /// ��ͥ�绰
	
	var EmVisTime = $("#emvistime").datebox("getValue");   /// ����ʱ��
	var EmAddress = $("#emaddress").val();        /// ��ͥסַ
	
	var EmCardType = $("#emcardtype").combobox("getValue"); /// �����Ͷ���
	var empatage=$("#empatage").val()
	/// ����ID^�ǼǺ�^����^���֤^�Ա�^��������^����^����^��ϵ�绰^��ͥ��ַ^����ID^����^�Ǽ���
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardType[0]+"^"+empatage;
	/// Session
	var LgParams = LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	/// ��������
	runClassMethod("web.DHCEMPatCheckLev","saveEmRegPat",{"PatListData":PatListData,"EmPatModFlag":EmPatModFlag,"LgParams":LgParams},function(jsonString){
		
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
	var emborth =$('#emborth').val();
	emborth=new Date(Date.parse(emborth.replace(/-/g,"/")))
	minBorth=new Date("1841","00","01")
	/*
	curdate=new Date()
	if (emborth>curdate){
		$.messager.alert("��ʾ:","���ղ��ܴ��ڽ��죡");
		return;
	}
	*/
	if (emborth<=minBorth){
		$.messager.alert("��ʾ:","���ղ���С��1841��");
		return;
	}
	var age=$("#empatage").val();
	if(parseInt(age)>120){
		$.messager.alert("��ʾ:","���䲻�ܴ���120��");
		return;
	}
	if(parseInt(age)<0){
		$(this).val("")
		$.messager.alert("��ʾ:","���䲻��С��0��");
		return;
	}
	if (!checkSex())return;	
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
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.PatSex +'/'+ rowData.PatAge +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.NurseLevel!=""){
			if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
			if(rowData.NurseLevel==2) {classstyle="color: #f22613"};
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.NurseLevel+'��</span></h4>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// ���õǼ��������
function setRegPanelInfo(rowData,flag){
		
	$("#EmCardNoID").val(rowData.CardNoID);   		/// ����ID
	$("#EmRegID").val(rowData.EmRegID);   		    /// �Ǽ�ID
	$("#emcardno").val(rowData.PatCardNo);   		/// ����
	$("#PatientID").val(rowData.PatientID);   		/// PatientID
	//$("#Adm").val(rowData.Adm);
	$("#SelEmCheckNo").val(rowData.EpiRegData);
	
	$("#EmPatNo").val(rowData.PatNo);   		    /// �ǼǺ�
	$("#empatname").val(rowData.PatName);   		/// ����
	$("#empatage").val(rowData.PatAge);        		/// ����
	
	$("#empatsex").combobox("setValue",rowData.sexId);    	 /// �Ա�
	$("#emnation").combobox("setValue",rowData.nationdr);    /// ����
	$("#emcountry").combobox("setValue",rowData.countrydr);  /// ����
	$("#emborth").val(rowData.birthday);    /// ��������
	
	$("#emidentno").val(rowData.IdentNo);   /// ֤������
	$("#emfamtel").val(rowData.PatTelH);    /// ��ͥ�绰
	$("#emaddress").val(rowData.Address);   /// ��ͥסַ
	
	GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  ���ÿ�����
	
	if(flag==0){
		return;
	}
	$("#Adm").val(rowData.Adm);             /// ����ID
	$("#emvistime").datebox("setValue",rowData.EmRegDate);   /// ����ʱ��
	$("#EmPCLvID").val(rowData.EmPCLvID);   		/// ����ID
	var EmPatLevWard = "��";
	if (rowData.NurseLevel == "3"){EmPatLevWard = "��";}
	if (rowData.NurseLevel == "4"){EmPatLevWard = "��";}
	if (rowData.NurseLevel == ""){EmPatLevWard = "δ��";}
	
	var NurseLevel = "";
	if (rowData.NurseLevel == ""){ NurseLevel = "δ��";}
	else{NurseLevel = rowData.NurseLevel;}
	var html = "";
	var FontColor = "";
	if (EmPatLevWard == "��"){ FontColor = "#ff6248";}
	if (EmPatLevWard == "��"){ FontColor = "#ffb746";}
	if (EmPatLevWard == "��"){ FontColor = "#2ab66a";}
	if (EmPatLevWard == "δ��"){FontColor = "#787878";} //huaxiaoying 2018-02-03 δ�ּӵ�ɫ
	
	var SexImg=""
	if (rowData.PatSex == "Ů"){ //huaxiaoying 2018-02-03 st ���Ա�ͼ��
		SexImg = "nursewomano";
	}else if(rowData.PatSex == "��"){
		SexImg = "nursemano";
	}else{
		SexImg = "nurseunmano";
	}
	html = html +'<img style="width:30px;heigth:30px;border-radius:50%;margin-left:10px;margin-bottom:-5px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/'+SexImg+'.png">' //hxy ed
	html = html + '<span style="font-size:16px;color:#000;margin-left:10px;margin-right:10px;font-weight:bold;">' + rowData.PatName + '</span><span class="patother"></span>';
	//html = html + '<span style="color:' + FontColor + '">' + EmPatLevWard + '</span><span class="patother"></span>'; hxy 2018-01-29
	html = html + '<span style="border-radius:5px;padding:1px 3px 0 3px;color:#fff;background-color:' + FontColor + '">' + EmPatLevWard + '</span><span class="patother"></span>';
	html = html + '<span style="color:' + FontColor + '">' + NurseLevel + '��</span><span class="patother">|</span>';
	html = html + rowData.PatSex + '<span class="patother">|</span>';
	html = html + rowData.PatAge + '<span class="patother">|</span>';
	html = html + "ID:" + rowData.PatNo + '<span class="patother">|</span>';
	html = html + rowData.BillType + '<span class="patother">|</span>';
	html = html + rowData.EmRegDate + '<span class="patother">|</span>';
	html = html + rowData.EmRegTime + '<span class="patother"></span>';
	
	/*	
	var html = '<span class="word-green-deep font-18"><b>'+ rowData.PatName +'</b></span>';
		html = html + '<span class="padding-l25 word-green-deep">'+EmPatLevWard+'��</span>';
	    html = html + '<span class="padding-l25 fontsize-14 word-deep-gray">'+rowData.PatSex+'/'+rowData.PatAge+'/'+NurseLevel+'��/ID:'+rowData.PatNo+'/'+rowData.BillType+'/'+rowData.EmRegDate+" "+rowData.EmRegTime+'</span>';
	
	*/
	
	$(".item-label").html(html);
	
	LoadEmPatCheckLevInfo(rowData.EmPCLvID);     ///  ��������Ѿ����зּ�,��ʾ�ּ�����
}

/// ��ȡ������Ϣ
function GetEmRegPatInfo(){
	var EmPatNo = $("#EmPatNo").val();      /// �ǼǺ�;
	var PatientID = $("#PatientID").val();  /// ����ID
	
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			QueryEmPatListByPatNo(rowData.PatNo);
			setRegPanelInfo(rowData,0);
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
	
	var params = GetParams(EmPatNo) //2016-09-20 congyue
	
	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}

///  �ǼǺŻس�
function GetEmPatInfo(e){
	
	 if(e.keyCode == 13){
		var EmPatNo = $("#EmPatNo").val();
		///  �ǼǺŲ�0
		var EmPatNo = GetWholePatNo(EmPatNo);
		clearEmPanel();				///  ���
		clearCheckBox(); // ��ո�ѡ�� bianshuai 2018-03-09
		$("#EmPatNo").val(EmPatNo);
		runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
			
			if (jsonString ==-1){
				$.messager.alert("��ʾ:","��ǰ����Ч,�����ԣ�");
				return;

			}else{
				GetEmRegPatInfo();
				$("#empatname").focus();  /// �ǼǺŻس���,������������ý���
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
		
		clearEmPanel(1);				///  ���
		
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
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("��ʾ:","Сʱ�����ܴ���23��");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("��ʾ:","���������ܴ���59��");
		$('#'+ id).val("");
		return "";
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
		var html = '<span><input type="checkbox" name="EmSymFeild" value="'+this.id+'" checked><span class="EmSymSpan">'+ $(this).text() +'</span></input>&nbsp;&nbsp;';
		html = html+'</span>'
		$("#EmSymFeild").append(html);
		$(this).addClass("btn-successsymptoms");
		setEmRecLevel();
		$('.panel-title:contains("֢״")').html("֢״:"+$("#SymptomLev").tree("getSelected").text);
		arr.push(this.id);
		$("#EmSymFeildTitle").html("")
	}else{
		/// ȡ��֢״ bianshuai 2018-02-09
		$('[name="EmSymFeild"][value="'+this.id+'"]').parent().remove();
		$(this).removeClass("btn-successsymptoms");
		arr.splice($.inArray(id,arr),1);
		/// ���¼���ּ�
		setEmRecLevel(); 
	}
	
}

///  ����ͼ�����¼� 2016-09-20 congyue
function EmPatWardClick(){
	
	//$('#dgEmPatList').datagrid('load',{'params':"^"+this.id});
    //EmChkFlag="";
	EmBtnFlag=this.id;

	var EmPatNo=$('#search').searchbox('getValue');

	var params = GetParams(EmPatNo) 
	
	clearEmPanel();                        //������

	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}

/// �ѷ���/δ���� 2016-09-20 congyue
function QueryEmPatList(ChkFlag){

    EmBtnFlag="";
	EmChkFlag=ChkFlag;
	clearEmPanel(); 				//QQA ������
	var Params = "^^"+ EmChkFlag +"^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	$('#dgEmPatList').datagrid('load',{'params':Params});
}

/// ȷ�ϲ��˷ּ�
function surePatEmLev(){
	
	EmNurReaID = $("#EmNurRea").combobox("getValue");
	if (EmNurReaID == ""){
		$.messager.alert("��ʾ:","����д�ּ����ԭ��");
		return;
	}
	$("#EmNurRea").combobox("setValue","");
	$('#newNurWin').window('close');
	surePatEmTriage();
}

/// Ԥ�����
function surePatEmTriage(){
	
	
	//������Ҫ����
	if(parNeedCardFlag==1){
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
	var emborth =$('#emborth').val();
	emborth=new Date(Date.parse(emborth.replace(/-/g,"/")))
	minBorth=new Date("1841","00","01")

	if (emborth<minBorth){
		$.messager.alert("��ʾ:","���ղ���С��1841��");
		return;
	}
	var age = $("#empatage").val();
	if(parseInt(age)>120){
		$.messager.alert("��ʾ:","���䲻�ܴ���120��");
		return;
	}
	if(parseInt(age)<0){
		$(this).val("")
		$.messager.alert("��ʾ:","���䲻��С��0��");
		return;
	}

	//�����Ա�
	if (!checkSex())return;
	
	var EmPatName = $("#empatname").val();       /// ����    
	if (EmPatName == ""){
		$.messager.confirm('��ʾ', '����Ϊ��,ȷ��Ҫ����������ݽ��з�����?', function(result){  
        	if(result) {
	        	surePatEmTriage2();
	        }else{
		    	return;
		    }
	    })
	}else{
		surePatEmTriage2();
	}
}
function surePatEmTriage2(){
	
	/// ת����� 2016-09-12 congyue 
	var EmToLocID = $("#EmToLocID").combobox("getValue");   
	
	var EmRegID = $("#EmRegID").val();   			/// �Ǽ�ID
	if (EmRegID == ""){
		//$.messager.alert("��ʾ:","��ǼǺ�,�ٽ��з��������");
		//return;
	}
	var PatientID = $("#PatientID").val();   		/// PatientID
	if (PatientID == ""){
		//$.messager.alert("��ʾ:","��ѡ�в��˺����ԣ�");
		//return;
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
	
	var AISActiveFlag = "";
	if ($("input[name='AISActiveFlag']:checked").length){
		AISActiveFlag = $("input[name='AISActiveFlag']:checked").val();       /// ���˼���
	}
	
	var GlasgowFlag = "";
	if ($("input[name='GlasgowFlag']:checked").length){
		GlasgowFlag = $("input[name='GlasgowFlag']:checked").val();       /// ����˹�缶��
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
	
	var EmHurtDesc = $("#EmHurtDesc").val();             
	if ((AISActiveFlag == "Y")&(EmHurtDesc == "")){
		$.messager.alert("��ʾ:","���˷ּ�����Ϊ�գ�");           /// ���˷ּ�
		return;
	}
	
	var GlasgowDesc = $("#GlasgowDesc").val();
	if ((GlasgowFlag == "Y")&(GlasgowDesc == "")){
		$.messager.alert("��ʾ:","����˹�粻��Ϊ�գ�");           /// ����˹��ּ�
		return;
	}
	
	var EmPainLev = $("#EmPainLev").val();                       /// ��ʹ����
	if ((EmPainFlag == "Y")&(EmPainLev == "")){
		$.messager.alert("��ʾ:","��ʹ������Ϊ�գ�");
		return;
	}
	
	var EmAware = $("#EmAware").combobox("getValue");    	     /// ��ʶ״̬
	var EmUpdLevRe = $("#EmUpdLevRe").combobox("getValue");    	 /// ��ʿ���ķּ�ԭ��
	EmAware = EmAware==undefined?"":EmAware;
	EmUpdLevRe = EmUpdLevRe==undefined?"":EmUpdLevRe;
	
	var EmNurseLevel = "";
	if ($('input[name="NurseLevel"]:checked').length){
		EmNurseLevel = $('input[name="NurseLevel"]:checked').val();  /// ��ʿ�ּ�
	}
	if (EmNurseLevel == ""){
		$.messager.alert("��ʾ:","����ѡ���˲���ּ���");
		return;
	}
	
	 /// �Ƿ��޸Ļ�ʿ�ּ�
	if ((EmPCLvID !="")&(TmpNurLev != EmNurseLevel)&(EmNurReaID == "")){
		showNurWin(EmPCLvID);  /// ��ʿ�޸ķּ�����
		return;
	}
	
	var EmRecLevel = $("#EmRecLevel").combobox("getValue");        	 /// �Ƽ��ּ�
	
	var EmArea = "";
	if ($('input[name="Area"]:checked').length){
		EmArea =  $('input[name="Area"]:checked').val();   			 /// ȥ�����
	}
	
	
	///  ֢״
	var EmSymDesc = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDesc.push(this.value +"!"+ $.trim($(this).parent().text()));
	})

	EmSymDesc = EmSymDesc.join("#");
	
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
	var EmPcsBreath = $("#EmPcsBreath").val();    ///  ����Ƶ��
	var EmPatChkSign1 = EmPcsTime + RowDelim + EmPcsTemp + RowDelim + EmPcsHeart + RowDelim + EmPcsPulse + RowDelim + EmPcsSBP + RowDelim + EmPcsDBP + RowDelim + EmPcsSoP2 + RowDelim + EmPcsBreath;
	var EmPatChkSign2 = EmPcsTime1 + RowDelim + EmPcsTemp1 + RowDelim + EmPcsHeart1 + RowDelim + EmPcsPulse1 + RowDelim + EmPcsSBP1 + RowDelim + EmPcsDBP1 + RowDelim + EmPcsSoP21;
	var EmPatChkSign = EmPatChkSign1; // +"||"+ EmPatChkSign2;
	
	/// ����ʷ
	var EmPatChkHisArr = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHisArr.push(this.value);
	})
	var EmPatChkHis = EmPatChkHisArr.join(RowDelim);
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
	
	///  ������
	var EmPatSixSick = "";
	if ($('input[name="EmPatSixSick"]:checked').length){
		//EmPatAdmWay = $('input[name="EmPatAdmWay"]:checked').val();
		$('input[name="EmPatSixSick"]:checked').each(function(){
			if(EmPatSixSick){
				EmPatSixSick=EmPatSixSick+"#"+$(this).val();	
			}else{
				EmPatSixSick=$(this).val();
			}
		})
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

	///  ����
	var EmOtherDesc = $("#EmOtherDesc").val();

	///�����
	var Adm = $("#Adm").val();
	
	/// �ű�
	var EmPatChkCaArr = []; var EmPatChkCarePrv = "";
	if ((PatRegType != 1)&&(Adm=="")&&(EmToLocID=="")){
		var EmPatChkCare = $("#EmCheckNo").combobox("getValue")
		if ((EmPatChkCare == "")&&(EmToLocID=="")&&(PatRegType != 1)&&(Adm=="")){
			$.messager.alert("��ʾ:","����ѡ��ű��ָ����ң�"); ///2016-09-14 congyue 
			return;
		}
		/// �������
		var EmLocID =$("#EmLocID").combobox("getValue"); 	      ///2016-09-06 congyue    /// �������
		if ((EmLocID == "")&&(EmToLocID=="")&&(PatRegType != 1)&&(Adm=="")){
			$.messager.alert("��ʾ:","����ѡ�������һ�ָ����ң�"); ///2016-09-14 congyue 
			return;
		}
		EmPatChkCaArr.push(EmPatChkCare+","+EmLocID);
		EmPatChkCarePrv = EmPatChkCaArr.join("#");
	}else{
		EmPatChkCarePrv = $("#SelEmCheckNo").val();
	}
	
	/// ��������Ϊ��,Ĭ��������Ա��
	var EmPatName = $("#empatname").val();       /// ����
	if (EmPatName == ""){
		$('span:contains("����")').prev().attr("checked",true);
	}
	        	
	/// ������Ⱥ 2016-09-08 congyue 
	var EmPatChkType = [];var EmPatType = "";
	$('input[name="EmPatChkType"]:checked').each(function(){
		EmPatChkType.push(this.value);
		if ($(this).next().text() == "������Ա"){ EmPatType = this.value;}
	})
	EmPatChkType = EmPatChkType.join(RowDelim);
	///congyue 2016-08-26
	var PatientID = $("#PatientID").val();  /// ����ID

	/// ��ɫͨ�� 2017-02-28 bianshuai
	var EmGreenFlag = "N";
	if ($("input[name='EmGreenFlag']:checked").length){
		EmGreenFlag = $("input[name='EmGreenFlag']:checked").val();
	}
	
	/// ���Ȳ��� 2017-03-08 bianshuai
	var EmPatWardID = $("#EmPatWard").combobox("getValue");
	if (typeof EmPatWardID == "undefined"){
		EmPatWardID = "";
	}
	
	/// ��1��ģʽ:�ȹҺ�ģʽ��;δ�ҺŲ��˲�������з��� 
	/// 2017-03-08 bianshuai
	if ((PatRegType == 1)&(Adm == "")){
		$.messager.alert("��ʾ:","�˲���δ�ҺŲ��ܷ��");
		return;
	}
	
	/// ��3��ģʽ:�ȹҺ�ģʽ��;��Ҫ�ȷ���ʱ����������ɫͨ����Σ�ز���
	/// 2017-03-08 bianshuai
	var InsEpiFlag = "";
	if ((PatRegType == 3)&(Adm == "")){
		if ((EmGreenFlag != "Y")&&(EmPatWardID == "")&&(EmPatType == "")){
			$.messager.alert("��ʾ:","����ɫͨ�������Ȳ��ˡ�������Ա����ֱ�ӷ��");
			return;
		}else{
			InsEpiFlag = "1";
		}
	}
	
	/// ��4��ģʽ:�ȷ���;��ɫͨ����Σ�ز��˻�������ԱĬ�ϲ���Һż�¼
	/// 2017-03-08 bianshuai
	if ((PatRegType == 4)&(Adm == "")){
		if ((EmGreenFlag == "Y")||(EmPatWardID != "")||(EmPatType != "")){
			InsEpiFlag = "1";
		}
	}
	
	/// �ǵ�һ��ģʽ,�ڸ��·�����Ϣʱ������IDȡ�ϴδ洢����
	/// 2017-03-08 bianshuai
	if ((PatRegType != 1)&(EmPCLvID != "")&(Adm == "")){
		Adm=$("#EmPatAdm").val();
	}
	
	/// ���ﻤʿ^�Ƽ��ּ�^��ʿ�ּ�^��ʿ�ּ�ԭ��^ȥ�����^�������^�ط���ʶ^��������^������������^����ʷ
	/// ������Դ^���﷽ʽ^��ʶ״̬^ɸ��^��ҩ���^��ҩ�������^������^����������
	/// ��������^֢״��^֢״����^������^ECG^�ж�^��ʹ^��ʹ�ּ�^��ʹ��Χ^��ʹ����^��ʹʱ��^����^���^����^����ID^�Ǽ�ID^�ѹҺű�
	var EmListData = LgUserID +"^"+ EmRecLevel +"^"+ EmNurseLevel +"^"+ EmUpdLevRe +"^"+ EmArea +"^"+ LgLocID +"^"+ EmAgainFlag +"^"+ EmBatchFlag +"^"+ EmBatchNum +"^"+ EmPatChkHis;
	var EmListData = EmListData +"^"+ EmPatSource +"^"+ EmPatAdmWay +"^"+ EmAware +"^"+ EmScreenFlag +"^"+ EmHisDrug +"^"+ EmHisDrugDesc +"^"+ EmMaterial +"^"+ EmMaterialDesc;
	var EmListData = EmListData +"^"+ EmPatChkSign +"^"+ "" +"^"+ EmSymDesc +"^"+ EmCombFlag +"^"+ EmECGFlag +"^"+ EmPoisonFlag +"^"+ EmPainFlag +"^"+ EmPainLev +"^"+ EmPainRange +"^"+ EmPainDate +"^"+ EmPainTime;
	var EmListData = EmListData +"^"+ EmOxygenFlag +"^"+ EmPatAskFlag +"^"+ EmOtherDesc +"^"+ PatientID +"^"+ EmRegID +"^"+ EmPatChkCarePrv +"^"+ Adm +"^"+EmPatChkType+"^"+EmToLocID+"^"+ LgHospID +"#"+ LgCtLocID +"#"+ LgUserID +"#"+ LgGroupID;
	var EmListData = EmListData +"^"+ EmGreenFlag +"^"+ EmPatWardID +"^"+ InsEpiFlag +"^"+AISActiveFlag+"^"+GlasgowFlag +"^"+ EmNurReaID+"^"+EmPatSixSick+"^"+$("#greenHours").val();
	var PatientID = $("#PatientID").val();       /// PatientID
	var EmCardNoID = $("#EmCardNoID").val();     /// ����ID
	var EmCardNo = $("#emcardno").val();         /// ����
	var EmPatNo = $("#EmPatNo").val();           /// �ǼǺ�
	var EmPatName = $("#empatname").val();       /// ����
	var EmPatAge = $("#empatage").val();         /// ����
	var EmBorth = $("#emborth").val();        	 /// ��������
	var EmPatSex = $("#empatsex").combobox("getValue");     /// �Ա�
	var EmNation = $("#emnation").combobox("getValue");     /// ����
	var EmCountry = $("#emcountry").combobox("getValue");   /// ����
	var EmIdentNo = $("#emidentno").val();        /// ֤������
	var EmFamTel = $("#emfamtel").val();          /// ��ͥ�绰
	var EmVisTime = $("#emvistime").datebox("getValue");   /// ����ʱ��
	var EmAddress = $("#emaddress").val();        /// ��ͥסַ
	var EmCardType = $("#emcardtype").combobox("getValue"); /// �����Ͷ���
	var empatage=$("#empatage").val()
	//���д���combobox��������
	EmPatSex = EmPatSex==undefined?"":EmPatSex;
	EmNation = EmNation==undefined?"":EmNation;
	EmCountry = EmCountry==undefined?"":EmCountry;
	EmCardType = EmCardType==undefined?"":EmCardType;
	
	var mySecrityNo = "";
	if ((EmCardNoID == "")&(EmCardNo != "")){
		/// ��ȡ��ȫ���쳣
		mySecrityNo = GetSecurityNO();
		if (mySecrityNo == ""){
			$.messager.alert("��ʾ:","��ȡ��ȫ���쳣��");
			return;
		}
		/// д�� [�Ѱ�ȫ��д������]
		if (!WrtCard(mySecrityNo)){
			$.messager.alert("��ʾ:","д���쳣��");
			return;
		}
	}

	/// ����ID^�ǼǺ�^����^���֤^�Ա�^��������^����^����^��ϵ�绰^��ͥ��ַ^����ID^����^�Ǽ���
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardType[0]+"^"+empatage+"^"+LgHospID+"^"+mySecrityNo;
    //���洴������
	//$('#EmPatHurtLevWin').css('display','none');   
    //$('#EmPatHurtLevWin').window('open');
    EmPatHurtLevWin();
    //$('#EmPatHurtLevWin').window('close');
    cancelEmHurtWin();
   
    //$('#EmPatHurtLevWin').css('display','');
     var strAIS="";
	 for(x=0;x<aisArr.length;x++){
		$('input[name="'+aisArr[x]+'"]:checked').each(function(){
			strAIS=strAIS+$(this).attr("strAIS")+"#";
		})
	    }
	    
     ///�������˹�����  2016-10-14 guoguomin 
     GlasgowLevWin();
     cancelGlasgowLevWin();
     var strGCS=""; //����˹������ӱ�ID��
     //alert(gcsArr.length)
	for(x=0;x<gcsArr.length;x++){
		$('input[name="'+gcsArr[x]+'"]:checked').each(function(){
			strGCS=strGCS+$(this).attr("strGCS")+"#";
			
		})
	}

	if (AISActiveFlag == "N"){
		strAIS="";
	}
	 if (GlasgowFlag == "N"){
		strGCS="";
	}
	/// Session
	var LgParams = LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	/// �����������
	runClassMethod("web.DHCEMPatCheckLev","saveEmPatCheckLev",{"EmPCLvID":EmPCLvID,"EmListData":EmListData,"PatListData":PatListData,"strAIS":strAIS,"strGCS":strGCS,"LgParams":LgParams},function(jsonString){
	  
		var retArr = jsonString.split("^");
		ret=retArr[0]
		if (ret > 0){
			$.messager.alert("��ʾ:","����ɹ���");
			$("#EmPCLvID").val(ret);   			/// ����ID
			$("#dgEmPatList").datagrid("reload");
			$("#PatientID").val(retArr[1])
			GetEmRegPatInfo(); /// ���ز��˵Ǽ���Ϣ
			LoadEmPatCheckLevInfo(ret);            /// ���¼��ط�����Ϣ
		}else if (ret==-101){
			$.messager.alert("��ʾ:","û���ҵ������¼,���ߴ�δ�Ű�!");
		}else if (ret==-200){
			$.messager.alert("��ʾ:","�����Ѿ�������/������,���Ȱ�����Ժ��");
		}else if (ret==-102){
			$.messager.alert("��ʾ:","�˲����Ѿ�������ͬ�ĵǼǼ�¼,��ʹ�ò����б��ѯ!");
		}else if (ret==-301){
			$.messager.alert("��ʾ:","��������ÿ��Һ��޶�!");
		}else if (ret==-202){
			$.messager.alert("��ʾ:","�úű��ѹ���!");
		}else if (ret==-98){
			$.messager.alert("��ʾ:","�Ѿ���������޸Ļ�����ű�");
		}else if (ret==-99){
			$.messager.alert("��ʾ:","�ű����շѣ������˺�!");
		}else if (ret==-9){
			$.messager.alert("��ʾ:","�ű𼶱�ͬ!");
		}else{
			msg=retArr[1]==undefined?ret:retArr[1];
			if (msg.indexOf("֤�����벻��Ϊ��") != "-1"){
				msg=msg.replace("֤�����벻��Ϊ��","���֤�Ų���Ϊ�գ�");
			}
			$.messager.alert("��ʾ:","����ʧ�ܣ�"+msg);
		}
	},'text')
}
///  ��������Ѿ����зּ�,��ʾ�ּ�����
function LoadEmPatCheckLevInfo(EmPCLvID){
	/// ��ȡ�ּ�����
	$('#EmLocID').combobox('enable')
	$('#EmCheckNo').combobox('enable')
	//$('#EmToLocID').combobox('enable')
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheckLev",{"EmPCLvID":EmPCLvID},function(jsonString){
		
		if (jsonString != null){
			var EmPatCheckLevObj = jsonString;
			eascapeFlag=1;
			if(EmPatCheckLevObj.EmToLocID!=0){
				$("#EmLocID").combobox('setValue',"");
				$("#EmCheckNo").combobox('setValue',"");
				$('#EmLocID').combobox({disabled:true})
				$('#EmCheckNo').combobox({disabled:true})
				$('#EmToLocID').combobox('enable');
				/// ת����� 2016-09-12 congyue
				$("#EmToLocID").combobox('select',EmPatCheckLevObj.EmToLocID);


			}
			if(EmPatCheckLevObj.EmLocID!=0){
				$('#EmToLocID').combobox('setValue',"");
				$("#EmLocID").combobox('setValue',EmPatCheckLevObj.EmLocID)
			} 
			///	 ������
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			///  �Ƽ��ּ�
			$("#EmRecLevel").combobox('setValue',EmPatCheckLevObj.EmRecLevel);
			
			///  ��ʿ���ķּ�ԭ��
			$("#EmUpdLevRe").combobox('setValue',EmPatCheckLevObj.EmUpdLevRe);

			///  �������
			///$("#EmLocID").val(EmPatCheckLevObj.EmLocID);  //2016-09-06 congyue

			///  ��ʶ״̬
			$("#EmAware").combobox('setValue',EmPatCheckLevObj.EmAware);

			///  ��ʿ�ּ�
			$('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').attr("checked",'checked'); 
			TmpNurLev = EmPatCheckLevObj.NurseLevel;
			EmNurReaID = ""; 
			
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
	
			///  ������
			if(EmPatCheckLevObj.SixSick!==""){
				sixSickArr = EmPatCheckLevObj.SixSick.split("#");
				for(x in sixSickArr){
					$('[name="EmPatSixSick"][value="'+ sixSickArr[x] +'"]').attr("checked",true);		
				}
			}
			
			
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
			
			/// ��ʹ�ּ� ��ť����
			if (EmPatCheckLevObj.EmPainFlag == "Y"){
				$('a:contains("��ʹ�ּ�")').linkbutton('enable');
			}
			
			///���˷ּ�
			$("#EmHurtDesc").val(EmPatCheckLevObj.AisDataStr);
			var aisdatastr = EmPatCheckLevObj.AisDataStr;
			if(EmPatCheckLevObj.EmAisFlag=="N"){
				$('[name="AISActiveFlag"][value="'+ 'N' +'"]').attr("checked",true);
			}else{
				var AISActiveFlag = "";
				if (aisdatastr != ""){
					$('[name="AISActiveFlag"][value="'+ 'Y' +'"]').attr("checked",true);
					$('a:contains("���˷ּ�")').linkbutton('enable');
				}
			}
			for (x=1;x<aisdatastr.split(",").length-1;x++){
				aisStr = aisStr+aisdatastr.split(",")[x]+"^";
			}
			
				
			///����˹��
			$("#GlasgowDesc").val(EmPatCheckLevObj.GCSDataStr);
			var gcsdatastr = EmPatCheckLevObj.GCSDataStr;
			if(EmPatCheckLevObj.EmGcsFlag=="N"){
				$('[name="GlasgowFlag"][value="'+ 'N' +'"]').attr("checked",true);
			}else{
				var GlasgowFlag ="";
				if (gcsdatastr != ""){
					$('[name="GlasgowFlag"][value="'+ 'Y' +'"]').attr("checked",true);
					$('a:contains("����˹��ּ�")').linkbutton('enable');
				}
				}
			for (y=0;y<gcsdatastr.split(",").length-1;y++){
					gcsStr = gcsStr+gcsdatastr.split(",")[y].split(":")[1]+"^";
					//alert(gcsStr)
				}
			

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
					arr.push(EmSymFeildID)
				}
			}

			///	 ����ʷ
			var EmPatChkHisArr = EmPatCheckLevObj.EmPatChkHis.split("#");
			for(var i=0;i<EmPatChkHisArr.length;i++){
				$('[name="EmPatChkHis"][value="'+ EmPatChkHisArr[i] +'"]').attr("checked",true);
			}
			
			///  Ԥ��ű�
			if (EmPatCheckLevObj.EmPatChkCare != ""){
				var EmPatChkCare = EmPatCheckLevObj.EmPatChkCare;
				var EmPatChkCareID = EmPatChkCare.split("@")[0];
				var EmPatChkCareDesc = EmPatChkCare.split("@")[1];
				$("#EmCheckNo").combobox('setValue',EmPatChkCareID);
				$("#EmCheckNo").combobox('setText',EmPatChkCareDesc);
//				$("#SelEmCheckNo").html("");
//				var EmPatChkCareArr = EmPatCheckLevObj.EmPatChkCare.split("#");
//				for(var i=0;i<EmPatChkCareArr.length;i++){
//					var EmPatChkCareID = EmPatChkCareArr[i].split("@")[0];
//					var EmPatChkCareDesc = EmPatChkCareArr[i].split("@")[1];
//					var EmPatChkCareLocId = EmPatChkCareArr[i].split("@")[2];
//					var html = '<span><input type="checkbox" name="SelEmCheckNo" data_loc="'+EmPatChkCareLocId+'" value="'+ EmPatChkCareID +'" checked>'+ EmPatChkCareDesc +'</input>&nbsp;&nbsp;</span>';
//					$('#SelEmCheckNo').append(html);
//				}
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
				$("#EmPcsBreath"+flag).val(EmPcsArr[7]);      ///  ����Ƶ��
			}
			///  ������Ⱥ 2016-09-05 congyue
			$('[name="EmPatChkType"][value="'+ EmPatCheckLevObj.EmPatChkType +'"]').attr("checked",true);
			
			/// ��ɫͨ�� 2017-02-28 bianshuai
			if (EmPatCheckLevObj.EmPatGreFlag == 1){
				$('[name="EmGreenFlag"][value="Y"]').attr("checked",true);
				$("#greenHours").val(EmPatCheckLevObj.EmPatGreHours);
				$("#greenHours").attr("disabled",true)
			}
			
			/// ���Ȳ��� 2017-03-08 bianshuai
			if (EmPatCheckLevObj.EmWardID != ""){
				$('#EmPatWard').combobox({disabled:false});
				$("#EmPatWard").combobox('setValue',EmPatCheckLevObj.EmWardID);
			}else{
				$('#EmPatWard').combobox({disabled:true});
			}
			
			/// Ԥ�����ID 2017-03-08 bianshuai
			$("#EmPatAdm").val(EmPatCheckLevObj.EmPatAdm);

		}else{
			$('#EmBatchNum').attr("disabled",true);	
		}
	})
}

///	 ���
function clearEmPanel(flag){
	$('a:contains("��ʹ�ּ�")').linkbutton('disable');//hxy add 2016-11-28
	$('a:contains("���˷ּ�")').linkbutton('disable');
	$('a:contains("����˹��ּ�")').linkbutton('disable');
	gcsStr="";   //��������
	aisStr="";   //��������
	EmNurReaID = ""; /// ��������
	/// ��ѡ��
	$('input[type="checkbox"][name!="EmEpiFlag"][name!="EmCkLvFlag"]').attr("checked",false);
	
	/// ��ѡ
	$('input[type="radio"]').attr("checked",false);
	
	/// �ı���
	$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})

	/// Combobox
	$('input.combobox-f').each(function(){
		if(this.id == "emcardtype"){return true;}
		if(this.id == "EmUpdLevRe"){return true;}
		//if(!$("#"+ this.id).length){return true;}
		$("#"+ this.id).combobox("setValue","");
	})
	if(flag!=1){
		$("#emcardtype").combobox("select",defaultCardTypeDr);
	}
	
	/// ����
	$('input.datebox-f').each(function(){
		if(this.id == "emcardtype"){return;}
		if((this.id == "stadate")||(this.id == "enddate")){return;}
		if(this.id=="emvistime") {
			$("#"+ this.id).datebox("setValue",formatDate(0));
			return;	
		} 
		$("#"+ this.id).datebox("setValue","");
	})
	
	/// Ԥ��ű�
	$('#SelEmCheckNo').html("");
	
	/// ֢״
	$("#EmSymFeild").html("");
	
	$('#EmLocID').combobox({disabled:false})
	$('#EmCheckNo').combobox({disabled:false})
	$('#EmToLocID').combobox({disabled:true})
	$('#EmBatchNum').attr("disabled","disabled")
	
	/// �������
	if (PatRegType == "3"){
		$("td:contains('�������')").parent().css("display","");
	}
	
	/// �ѹҺű�
	$("#queDoc").html("");
	
	/// ���֢״������
	$("#symList").html("");
	/// ���֢״��ѡ���б�
	arr=[];
	
	/// ���֢״��ѡ��״̬
	$('#SymptomLev').find('.tree-node-selected').removeClass('tree-node-selected');
	
	/// ������֤ͼƬ����  bianshuai 2018-03-17
	$("#imgPic").attr("src","../images/uiimages/patdefault.png");
	initGreenHours(); //zhouxin
	 $(".item-label").html(""); ///��ղ�����Ϣ��  bianshuai 2018-03-17
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
/// �������ִ���
function EmPatHurtLevWin(){
	var AISActiveFlag = "";
	if ($("input[name='AISActiveFlag']:checked").length){
		AISActiveFlag = $("input[name='AISActiveFlag']:checked").val();       /// ���˼���
	}
	if (AISActiveFlag != "Y"){
		return;
	}
	aisArr=[];
	///��������
	///w ##class(web.DHCEMPatientSeat).GetEmAISData(LgHospID)
	runClassMethod("web.DHCEMPatientSeat","GetEmAISData",{"LgHospID":LgHospID},function(dataString){
		var dataString = dataString;
		var scoreAIS = "";
		var strAIS =  "";
		var htmlstr = "";
		for(i=0;i<dataString.split("!").length;i++){
			var trData = dataString.split("!")[i]	;
			var AISName=trData.split("#")[0];
			aisArr.push("AISActiveFlag"+i);
			aisArr2.push("AISActiveFlag"+i);
			htmlstr=htmlstr+"<tr>"
			htmlstr=htmlstr+"<td align='right' style='width:100' class='input-label'>"+AISName+':'+"</td>"
			if(trData.indexOf("^")=="-1"){
				$.messager.alert("��ʾ","��������ά������ȷ!");
				}
			htmlstr=htmlstr+"<td>"
				for(j=0;j<trData.split("#")[1].split("$").length;j++){
					var tdData = trData.split("#")[1].split("$")[j];
					htmlstr = htmlstr + '<input type="checkbox" name="AISActiveFlag'+i+'" strAIS="'+tdData.split("^")[0]+'"scoreAIS ="'+tdData.split("^")[2]+'" text="'+AISName+':'+'('+tdData.split("^")[2]+'��)'+'" value="'+(j+1)+'">'+ tdData.split("^")[1]+' (' +tdData.split("^")[2] +'��)'+'</input>&nbsp;&nbsp;';
				}
			htmlstr=htmlstr+"</td>"
			htmlstr=htmlstr+"</tr>"
		}
		$('#EmPatHurtLevWinTable').html(htmlstr);
		//alert(aisStr);
		for(k=0;k<(aisStr.split("^").length-1);k++){   //ZHL  2016-10-24
			//alert(aisStr.split("^")[k]);			

			var lsText="input[text*='"+aisStr.split("^")[k]+"']";
   		
			$(lsText).attr("checked", true);
		}
		getScore();						//yuliping  
		for(x=0;x<aisArr2.length;x++){
			$('input[name="'+aisArr2[x]+'"]').change(function (){
				
				setTimeout(function(){
	 			getScore();
  					},100);
				
			});
		}
		aisStr2=aisStr;
		aisStr="";   //��������
	},'text',false)
	
	
	
	
	if($('#EmPatHurtLevWin').is(":hidden")){
		$('#EmPatHurtLevWin').window('open');
		return;}  //���崦�ڴ�״̬,�˳�
/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('���˷ּ�', 'EmPatHurtLevWin', '1050', '400', option).Init();
	$(".panel-tool-close ").bind("click",cancelEmHurtWin)// yuliping �رհ�ť�����
}
///  ����˹����Էּ�����
function GlasgowLevWin(){
	var GlasgowFlag = "";
	if ($("input[name='GlasgowFlag']:checked").length){
		GlasgowFlag = $("input[name='GlasgowFlag']:checked").val();       /// ��ʹ����
	}
	if (GlasgowFlag != "Y"){
		return;
	}
	gcsArr=[];
	///����˹�����
	///w ##class(web.DHCEMPatientSeat).selAllData(LgHospID)
	runClassMethod("web.DHCEMPatientSeat","selAllData",{"LgHospID":LgHospID},function(dataString){
		var dataString = dataString;
		var htmlstr = "";
		var strGCS="";
		for(i=0;i<dataString.split("!").length;i++){
			var trData = dataString.split("!")[i];
			var gcsName=trData.split("#")[0];
			gcsArr.push("GlasgowFlag"+i);
			gcsArr2.push("GlasgowFlag"+i);
			htmlstr=htmlstr+"<tr>"
			htmlstr=htmlstr+"<td align='left' width=''>"+gcsName+":"+"</td>"
			if(trData.indexOf("^")=="-1"){
				$.messager.alert("��ʾ","����˹�����ά������ȷ!");
				} 
			htmlstr=htmlstr+"<td>"
				for(j=0;j<trData.split("#")[1].split("$").length;j++){
					var tdData = trData.split("#")[1].split("$")[j];
					htmlstr=htmlstr+"<td align='left' width=''>"
					htmlstr = htmlstr + '<input type="checkbox" name="GlasgowFlag'+i+'" strCode="'+tdData.split("^")[2]+'" strGCS="'+tdData.split("^")[0]+'" text="'+gcsName+':'+tdData.split("^")[1]+'(' + tdData.split("^")[2]+ '��)'+'" value="'+(j+1)+'" >'+ tdData.split("^")[1]+'(' + tdData.split("^")[2]+ '��)' +'</input>';
				    htmlstr=htmlstr+"</td>"
				}
			htmlstr=htmlstr+"</td>"
			htmlstr=htmlstr+"</tr>"
		}
		$('#GlasgowLevTable').html(htmlstr);
		for(k=0;k<(gcsStr.split("^").length-1);k++){
			//alert(gcsStr.split("^")[k]);
			var lsText="input[text*='"+gcsStr.split("^")[k]+"']";
   			//alert(lsText);
			$(lsText).attr("checked", true);
		}
		
		getGlasgowScore();					//yuliping
		
		for(x=0;x<gcsArr2.length;x++){
			$('input[name="'+gcsArr2[x]+'"]').change(function (){
				setTimeout(function(){
	 			getGlasgowScore();
  					},100);
				
			});
		}
		gcsStr2=gcsStr;
		gcsStr="";   //��������
		//$("input[text*='���۷�Ӧ']").attr("checked", true);
		
	},'text',false)
	
	
	
	if($('#GlasgowLevWin').is(":hidden")){
		$('#GlasgowLevWin').window('open');
		num=0
		return;}  //���崦�ڴ�״̬,�˳�
		
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('����˹��ּ�', 'GlasgowLevWin', '1000', '400', option).Init();
	$(".panel-tool-close ").bind("click",cancelGlasgowLevWin)     //yuliping �رհ�ť������¼�
}


///  ��ʹ�ּ�Ц����ť�¼�
function EmPainFaceEvt(){
	
	$(this).find("span").css({"color":"#ff7a00"});
	$(this).siblings().find("span").css({"color":""});
	
	/// ������ʹ�ּ���Ŀֵ
	$("#EmPainLev").val($(this).index() * 2);
	
	/// ���� �������ַ���VAS�� ָ��λ��
	$("#slider").slider("setValue", $(this).index() * 2);
	
	if ($(this).index() == 0){
		$('#EmPainRange').combobox({disabled:true});
		$('#EmPainTime').datebox({disabled:true});
	}else{
		if($('#EmPainRange').combobox('options').disabled){
			$('#EmPainRange').combobox({disabled:false});
			$('#EmPainTime').datebox({disabled:false});
		}
	}
}

///  ��������ȡ��
function cancelEmHurtWin(){
	aisStr=aisStr2;
	aisArr2=[];
	try{
	$('#EmPatHurtLevWin').window('close')
		clearEmPain();
	;}catch(e){}
}
///  ��������ȷ��
function sureEmHurtWin(){
	var htmlStr="";
	var scoreAIS = "";
	for(x=0;x<aisArr2.length;x++){
		$('input[name="'+aisArr2[x]+'"]:checked').each(function(){
			htmlStr=htmlStr+$(this).attr("text")+","
			//alert(htmlStr);
			aisStr=aisStr+$(this).attr("text")+"^"
			scoreAIS=Number(scoreAIS)+Number($(this).attr("scoreAIS"));
		})
	}
	
	if (htmlStr == ""){
		$.messager.alert("��ʾ:","δ���,��ѡ���֣�")
		return;
	}
	htmlStr=htmlStr.substring(0,htmlStr.length-1);
	//alert(htmlStr);
	var str=getEmPatPainlev(EPnum)   //yuliping 2211-2212
	htmlStr=str+htmlStr             
	$("#EmHurtDesc").val(htmlStr);
	htmlStr1=htmlStr;
	aisArr=aisArr2;
	aisArr2=[];
	$('#EmPatHurtLevWin').window('close');
}
///  ȡ��
function cancelEmPainWin(){
	
	$('#EmPatPainLevWin').window('close');
}

///  ȡ����ʿ�ּ�����
function cancelNurLevWin(){
	
	$("#EmNurRea").combobox("setValue","");
	$('#newNurWin').window('close');
}

///  ����˹��ȡ��
function cancelGlasgowLevWin(){
	gcsStr=gcsStr2;
	gcsArr2=[];
	try{
		$('#GlasgowLevWin').window('close');
		num=0
		clearGlasgow()
	}catch(e){}
}
///  ����˹��ȷ��
function sureGlasgowLevWin(){
	var htmlStr="";
	for(x=0;x<gcsArr2.length;x++){
		$('input[name="'+gcsArr2[x]+'"]:checked').each(function(){
			//alert($(this).attr("text"));
			htmlStr=htmlStr+$(this).attr("text")+","
			gcsStr=gcsStr+$(this).attr("text").split(":")[1]+"^"
		})
	}
	
	if (htmlStr == ""){
		$.messager.alert("��ʾ:","δ���,��ѡ���֣�")
		return;
	}
	htmlStr=htmlStr.substring(0,htmlStr.length-1);
	var str=getGlasgowLevel(num);
	
	htmlStr=str+htmlStr
	$("#GlasgowDesc").val(htmlStr);
	
   	
   	htmlStr2=htmlStr;
   	gcsArr=gcsArr2;
	gcsArr2=[];
	$('#GlasgowLevWin').window('close');
	clearGlasgow()
}

///  ȷ��
function sureEmPainWin(){
	
	///  ��ʹָ��
	var EmPainLev = $("#EmPainLev").val();
	if (EmPainLev == ""){
		$.messager.alert("��ʾ:","��ʹָ������Ϊ�գ�");
		return;
	}
	
	///  ��ʹ��Χ
	var EmPainRange = $("#EmPainRange").combobox('getText');
	if ((EmPainRange == "")&(EmPainLev != 0)){
		$.messager.alert("��ʾ:","��ʹ��Χ����Ϊ�գ�");
		return;
	}
	///  ��ʹʱ��
	var EmPainTime = $("#EmPainTime").datetimebox('getValue');
	if ((EmPainTime == "")&(EmPainLev != 0)){
		$.messager.alert("��ʾ:","��ʹʱ�䲻��Ϊ�գ�");
		return;
	}
	
	if (!isValidTime(EmPainTime)){
		$.messager.alert("��ʾ:","��ʹʱ�䲻�ܴ��ڵ�ǰʱ��㣡");
		return;	
	}
	
	setEmRecLevel()

	if (EmPainLev == 0){
		$('a:contains("��ʹ�ּ�")').linkbutton('disable');
		/// ��
		$('input[name="EmPainFlag"][value="N"]').attr("checked",true);
		$('input[name="EmPainFlag"][value="Y"]').attr("checked",false);
	}else{
		var EmPainDesc = "��ʹ��Χ:"+EmPainRange+", ��ʹʱ��:"+EmPainTime+", ��ʹ�ּ�:"+EmPainLev+"��";
		$("#EmPainDesc").val(EmPainDesc);
	}
	$('#EmPatPainLevWin').window('close');
}

/// ��ʼ��֢״��
function initSymptomLevTree(){

	var url = LINK_CSP+'?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmPatSymptomLev';
	var option = {
        onClick:function(node, checked){
	        GetSymptomFeild(node.id)
	        $("#symListTitle").html("")
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
			htmlstr = htmlstr + '<button class="buttonsymptoms';
			if($.inArray(jsonObjArr[i].EmSymFId,arr)>=0){
				htmlstr = htmlstr + " btn-successsymptoms"
			}
			htmlstr = htmlstr + '" id="'+ jsonObjArr[i].EmSymFId +'" type="button">'+ jsonObjArr[i].EmSymFDesc +'</button>';
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
			m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
			m_CCMRowID = CardTypeDefArr[14];
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
	var EmPatChkHisArr = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHisArr.push(this.value);
	})
	EmPatChkHis = EmPatChkHisArr.join("$$");
	//EmParSym=$('#SymptomLev').tree('getSelected').text;
	//alert(EmParSym)
	EmPainLev1=$("#EmPainLev").val();
	//
	///  ֢״
	var EmSymDescArr = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDescArr.push($.trim($(this).parent().text()));
	})
	var EmSymDesc = EmSymDescArr.join("$$");
	//alert(EmSymDesc)
		
	/// (2)��������
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  ����
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  ����
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  Ѫѹ(BP)����ѹ
	var EmPcsDBP = $("#EmPcsDBP").val();
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  Ѫ�����϶�SoP2
	var EmPcsPulse = $("#EmPcsPulse").val();    ///  ���� 2016-12-06 congyue
	var EmPcsBreath = $("#EmPcsBreath").val();    ///  ����Ƶ��
	var age=$("#empatage").val();            ///����
	var pGCS=""
	
	//qqa 2018-02-27 ���ӻĵ�ֵ�ж�
	if((EmPcsTemp!="")&&(EmPcsTemp<=34)||(EmPcsTemp>=43)){
		$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ34-43!");
		$("#EmPcsTemp").val("");
		return;
	}	
	
	try{
	for(x=0;x<gcsArr.length;x++){
		$('input[name="'+gcsArr[x]+'"]:checked').each(function(){
			pGCS=pGCS+$(this).attr("strGCS")+"#";
			
		})
	}
	}catch(e){}
	
	
	if ((EmPcsTemp!="")||(EmPcsHeart!="")||(EmPcsSBP!="")||(EmPcsSoP2!="")||(EmPainLev1!="")||(EmSymDescArr.length>0)||(EmAware!="")||(EmPcsPulse!="")||(age!="")||(EmPcsBreath!="")||(pGCS!="")){
		EmPcsListData = EmPcsSBP +"^"+ EmPcsSoP2 +"^"+ EmPcsHeart +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp+"^"+EmSymDesc+"^"+EmPainLev1+"^"+EmPcsDBP+"^"+EmPcsPulse+"^"+age+"^"+EmPcsBreath+"^"+pGCS; //2016-12-06 cy ������� EmPcsPulse
	}
//	var EmPcsTemp1 = $("#EmPcsTemp1").val();    ///  ����
//	var EmPcsHeart1 = $("#EmPcsHeart1").val();  ///  ����
//	var EmPcsSBP1 = $("#EmPcsSBP1").val();      ///  Ѫѹ(BP)����ѹ
//	var EmPcsSoP21 = $("#EmPcsSoP21").val();    ///  Ѫ�����϶�SoP2
//	var EmPcsPulse1 = $("#EmPcsPulse1").val();    ///  ���� 2016-12-06 congyue
//	if ((EmPcsTemp1!="")||(EmPcsHeart1!="")||(EmPcsSBP1!="")||(EmPcsSoP21!="")||(EmPainLev1!="")||(EmSymDesc!="")){
//		//EmPcsListData2 = EmPcsSBP1 +"^"+ EmPcsSoP21 +"^"+ EmPcsHeart1 +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp1 +"^"+ EmSymDesc +"^"+ EmPainLev1;
//	}
	/// ϵͳ�Ƽ��ּ�
	if(EmPcsListData!= ""){
		//if(EmPcsListData2!=""){EmPcsListData=EmPcsListData2}
		GetEmRecLevel(EmPcsListData);
	}
	
}

///  ��ȡϵͳ�Ƽ��ּ�
function GetEmRecLevel(EmPcsListData){
	runClassMethod("web.DHCEMCalPatLevel","calPatLevel",{"EmPCLvID":EmPcsListData},function(jsonString){
		if (jsonString != null){
			var EmRecLevel = jsonString;
			if(EmRecLevel!=0){
				///  �Ƽ��ּ�
				$("#EmRecLevel").combobox('setValue',EmRecLevel);
				var EmPCLvID = $("#EmPCLvID").val();
				if (EmPCLvID == ""){
					///  ��ʿ�ּ�
					$('input[name="NurseLevel"][value="'+ EmRecLevel +'"]').attr("checked",'checked');
					///  ȥ��
					$('input[name="Area"][value="'+ ((EmRecLevel - 1)||1) +'"]').attr("checked",'checked'); 
					// ��̬���ÿؼ����úͲ����� bianshuai 2017-03-09
					setComponentEnable(EmRecLevel,EmRecLevel);
				}
			}else{
				$("#EmRecLevel").combobox('setValue',"");
			}
		}
	},'',false)
}

///  ���ò��˻�����Ϣ
function setEmPatBaseInfo(PatIdentNo){

	if (!$("#emidentno").validatebox('isValid')){
		return;
	}
	if (PatIdentNo != ""){
		runClassMethod("web.DHCEMPatCheckLevCom","GetPatientID",{"PatIdentNo":PatIdentNo},function(jsonString){
			if (jsonString != null){
				var PatientID = jsonString;
				if (PatientID != ""){
					var EmCardNo = $("#emcardno").val();
					var mPatientID = $("#PatientID").val();
					if (PatientID == mPatientID) return;
					if ((PatientID != mPatientID)&(mPatientID != "")){
						$.messager.alert("��ʾ:","���֤:"+PatIdentNo+";��֤�������Ѿ����ڣ�");
						$('#emidentno').val("");
						return;
					}
					if (EmCardNo != ""){
						$.messager.alert("��ʾ:","���֤:"+PatIdentNo+";��֤�������Ѿ�����,����쿨,��������������������");
						$('#emidentno').val("");
						return;
					}
					$("#PatientID").val(PatientID);
					GetEmRegPatInfo();
				}else{
					setEmBorth();
				}
			}
		},'',false)
	}
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
	$("#empatage").val(jsGetAge(d)+"��")  //setEmPatAges(d));      /// ����
	d = GetSysDateToHtml(d) /// ����Hisϵͳ����ת�����ڸ�ʽ
	$("#emborth").val(d);      /// ��������
	
	/// �����Ա�
	if (parseInt(value.substr(16, 1)) % 2 == 1) {
		$("#empatsex").combobox("setValue",TransPatSexToID("��"));
	}else{ 
		$("#empatsex").combobox("setValue",TransPatSexToID("Ů"));
	}
}

/// ȡHis����ά����ʾ��ʽ bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){
	
	//qqa 2018-01-09 �޸ĵ��õ�����
	runClassMethod("web.DHCEMPatCheckLevCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}

/// ȡHis�Ա� bianshuai 2017-08-17
function TransPatSexToID(PatSex){
	
	var PatSexID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","SexToId",{"desc":PatSex},function(jsonString){
		PatSexID = jsonString;
	},'',false)
	return PatSexID;
}

/// ȡHis���� bianshuai 2017-08-17
function TransNationToID(Nation){
	
	var PatNationID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","NationToId",{"Nation":Nation},function(jsonString){
		PatNationID = jsonString;
	},'',false)
	return PatNationID;
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
function jsGetAge(strBirthday)
{    
	var bDay = new Date(strBirthday),
	nDay = new Date(),
	nbDay = new Date(nDay.getFullYear(),bDay.getMonth(),bDay.getDate()),
	age = nDay.getFullYear() - bDay.getFullYear();
	if (bDay.getTime()>nDay.getTime()) {return '�����д�'}
	return nbDay.getTime()<=nDay.getTime()?age:--age;  


}
///  �����ڲ�ѯ�Ǽǲ����б� 2016-08-29 congyue
function QueryEmPatListByTime(){
	
	var EmPatNo=$('#search').searchbox('getValue');
    
	var params = GetParams(EmPatNo) 
	
	clearEmPanel();     //QQA ������

	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}

///  �����ڲ�ѯ�Ǽǲ����б� 2016-09-20 congyue
function GetParams(EmPatNo)
{
    
	///  �ǼǺŲ�0
	if (EmPatNo!="")
	{
		var EmPatNo = GetWholePatNo(EmPatNo);
	}

	
	$(".searchbox-text").val(EmPatNo);
	var EmStaDate=$('#stadate').datebox('getValue');  //��ʼ���� cy
	var EmEndDate=$('#enddate').datebox('getValue');  //�������� cy
	
	var EmChkFlag = "";  ///�Һ�/δ�Һ�/����/δ�����־ bianshuai 2018-03-24
	if ((PatRegType == 1)||(PatRegType == 3)){
		EmChkFlag=$("input[name='EmCkLvFlag']:checked").val();
	}else{
		EmChkFlag=$("input[name='EmEpiFlag']:checked").val();
	}
	
	//alert(EmStaDate+"!!!!"+EmEndDate)
	if($("#StartTimeQ").val()){
		EmStaDate=$("#StartTimeQ").val();    //QQA 2016-11-12
		EmEndDate=$("#EndTimeQ").val();      //QQA 2016-11-12
	}
  	var ChekLevId=$("#ChekLevId").val();   //QQA 2016-11-12  
	var Params = EmPatNo+"^"+EmBtnFlag+"^"+EmChkFlag+"^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID+"^"+EmStaDate+"^"+EmEndDate+"^"+ChekLevId;
	$("#ChekLevId").val("");   //QQA 2016-11-12
	$("#StartTimeQ").val("");  //QQA 2016-11-12
	$("#EndTimeQ").val("");    //QQA 2016-11-12
	return  Params;

}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
///congyue 2016-08-26  ����Һŵ���ӡ
function LevPrintout() {
	
	var EmPCLvID = $("#EmPCLvID").val();  /// 2017-04-13 bianshuai ����ID
	if (EmPCLvID == ""){
		$.messager.alert("��ʾ:","����ѡ��һ���������ݣ�");
		return;
	}
	
	var PrintData="";
	
	/// ��ȡ��ӡ��������
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheLevPriInfo",{"EmPCLvID":EmPCLvID,hospDr:LgHospID},function(jsonString){
		PrintData=jsonString
	},"",false)
	try {
		if (PrintData=="") return;
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_CheckLev");
		var PrintArr=PrintData.split("^");
		var PatientID=PrintArr[0];
		var PatNo=PrintArr[1];
		var PatCardNo=PrintArr[2];
		var PatName=PrintArr[3];
		var PatSex=PrintArr[4];
		var PatAge=PrintArr[5];
		var EmRecLevel=PrintArr[6];
		var EmNurseLevel=PrintArr[7];
		var EmUpdLevRe=PrintArr[8];
		var EmLocDesc=PrintArr[9];
		var EmPatChkSign=PrintArr[10];
		var EmRegDate=PrintArr[11]; //�Ǽ�����
		var EmCreator=PrintArr[12];
		var PrintDate=PrintArr[13];
		var PrintTime=PrintArr[14];
		var EmRegTime=PrintArr[15]; //�Ǽ�ʱ��
		var CreateDate=PrintArr[16]; //�������� 2016-09-19
		var CreateTime=PrintArr[17]; //����ʱ�� 2016-09-19
		var EmAware=PrintArr[18]; //��ʶ״̬ 2016-09-19
		var HospName = PrintArr[19];  //ҽԺ���� QQA  2016-10-21
		var DontNo =PrintArr[20];
		///	 ��������
		var flag="";
		var EmPcsTime="",EmPcsTemp="",EmPcsHeart="",EmPcsPulse="",EmPcsSBP="",EmPcsDBP="",EmPcsSoP2="",EmPcsR="";  
		var EmPcsTime1="",EmPcsTemp1="",EmPcsHeart1="",EmPcsPulse1="",EmPcsSBP1="",EmPcsDBP1="",EmPcsSoP21="",EmPcsR1="";  
		var EmPatChkSignArr = EmPatChkSign.split("#");
		for(var i=0;i<EmPatChkSignArr.length;i++){
			if (i==0){
			EmPcsArr = EmPatChkSignArr[i].split("@");
			EmPcsTime=EmPcsArr[0];   ///  ʱ��
			EmPcsTemp=EmPcsArr[1];   ///  ����
			EmPcsHeart=EmPcsArr[2];  ///  ����
			EmPcsPulse=EmPcsArr[3];  ///  ����
			EmPcsSBP=EmPcsArr[4];    ///  Ѫѹ(BP)����ѹ
			EmPcsDBP=EmPcsArr[5];    ///  ����ѹ
			EmPcsSoP2=EmPcsArr[6];   ///  Ѫ�����϶�SoP2
			EmPcsR = EmPcsArr[7]     ///  ����Ƶ��
			}if (i!=0){
			EmPcsArr1= EmPatChkSignArr[i].split("@");
			EmPcsTime1=EmPcsArr1[0];   ///  ʱ��
			EmPcsTemp1=EmPcsArr1[1];   ///  ����
			EmPcsHeart1=EmPcsArr1[2];  ///  ����
			EmPcsPulse1=EmPcsArr1[3];  ///  ����
			EmPcsSBP1=EmPcsArr1[4];    ///  Ѫѹ(BP)����ѹ
			EmPcsDBP1=EmPcsArr1[5];    ///  ����ѹ
			EmPcsSoP21=EmPcsArr1[6];   ///  Ѫ�����϶�SoP2
			EmPcsR1 = EmPcsArr[7]       ///  ����Ƶ��
			}
		}
		var MyPara="HospName"+String.fromCharCode(2)+HospName+"^"+"PatNo"+String.fromCharCode(2)+PatNo+"^"+"PatName"+String.fromCharCode(2)+PatName+"^"+"PatCardNo"+String.fromCharCode(2)+PatCardNo+"^"+"PatSex"+String.fromCharCode(2)+PatSex+"^"+"PatAge"+String.fromCharCode(2)+PatAge;
		var MyPara=MyPara+"^"+"EmNurseLevel"+String.fromCharCode(2)+EmNurseLevel+"^"+"EmLocDesc"+String.fromCharCode(2)+EmLocDesc+"^"+"DontNo"+String.fromCharCode(2)+DontNo+"^"+"EmCreator"+String.fromCharCode(2)+EmCreator+"^"+"CreateDate"+String.fromCharCode(2)+CreateDate+" "+CreateTime;
		var MyPara=MyPara+"^"+"EmAware"+String.fromCharCode(2)+EmAware+"^"+"PrintDate"+String.fromCharCode(2)+PrintDate+" "+PrintTime;       
		var MyPara=MyPara+"^"+"EmPcsTemp"+String.fromCharCode(2)+EmPcsTemp+"^"+"EmPcsHeart"+String.fromCharCode(2)+EmPcsHeart;
		var MyPara=MyPara+"^"+"EmPcsPulse"+String.fromCharCode(2)+EmPcsPulse+"^"+"EmPcsSBP"+String.fromCharCode(2)+EmPcsSBP+"^"+"EmPcsDBP"+String.fromCharCode(2)+EmPcsDBP+"^"+"EmPcsSoP2"+String.fromCharCode(2)+EmPcsSoP2;
		var MyPara=MyPara+"^"+"EmPcsR"+String.fromCharCode(2)+EmPcsR+"^"+"EmPcsTime"+String.fromCharCode(2)+EmPcsTime
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,MyPara,"");
	} catch(e) {alert(e.message)};
}

//checkBox ֻ��ѡ��һ��
function singleSelect(){
	alert($(this).attr("checked"));
	if($(this).checked=="true"){
		$(this).siblings().removeAttr('checked');	
		}
	}
//������֤�Ա�	
function checkSex(){
	
	psidno=$("#emidentno").val();
	sex=$("#empatsex").combobox("getValue");
	if(psidno.length==0){
		return true;	
	}
	var tmpStr;
	if(psidno.length==18){
        sexno=psidno.substring(16,17);
        tmpStr = psidno.substring(6, 14);
		tmpStr = tmpStr.substring(0, 4) + "-" + tmpStr.substring(4, 6) + "-" + tmpStr.substring(6);
    }else if(psidno.length==15){
        sexno=psidno.substring(14,15)
        tmpStr = psidno.substring(6, 12);
		tmpStr = "19" + tmpStr;
		tmpStr = tmpStr.substring(0, 4) + "-" + tmpStr.substring(4, 6) + "-" + tmpStr.substring(6);
    }else{
	    $.messager.alert("��ʾ:","���֤�Ŵ���");
	    return false;
	}
	tmpStr = GetSysDateToHtml(tmpStr);    /// ����Hisϵͳ����ת�����ڸ�ʽ
	date2=$("#emborth").val();
   	if(tmpStr!=date2){
	   	$.messager.alert("��ʾ:","�������ں����֤�Ų�һ�£�");
	    return false;
	}
    var tempid=sexno%2;
    if((tempid==0)&&(sex!=2)){
	    $.messager.alert("��ʾ:","���֤�Ŷ�Ӧ���Ա���Ů��");
	    return false;
	}
	
    if((tempid!=0)&&(sex!=1)){
	    $.messager.alert("��ʾ:","���֤�Ŷ�Ӧ���Ա����У�");
	    return false;
	}
	return true;	
}
//�����б�ǼǺŲ�ѯ 
function GetCardPatInfo(e){
	 if(e.keyCode == 13){
		var Regno = $("#Regno").val();
		///  �ǼǺŲ�0
		var Regno = GetWholePatNo(Regno);
		clearEmPanel();				///  ���
		$("#Regno").val(Regno);
		QueryEmPatListByPatNo(Regno);
		
	}
}
//�����б�ǼǺŲ�ѯ ��ť
function GetCardPatInfoOnclick(){
	 
		var Regno = $("#Regno").val();
		///  �ǼǺŲ�0
		var Regno = GetWholePatNo(Regno);
		clearEmPanel();				///  ���
		$("#Regno").val(Regno);
		QueryEmPatListByPatNo(Regno);
		

}
function initTooltip(){
	//alert($("#SymptomLev").find("li").length);
	$("#SymptomLev").find("li").each(function(){
		$(this).tooltip({
		position:'bottom',      //left,right,top,bottom λ��
		content :"��ʾ����",		//���ݣ�֧��HTML
		trackMouse : true		//�Ƿ��������ƶ�
		})
		})
	}

/// ʱ���Ч��
function isValidTime(EmPainTime){

	if (EmPainTime == "") return true;
	/// ��ǰʱ��
	var date = new Date();
	var currYear = date.getFullYear();
	var currMonth = date.getMonth() + 1;
	var currDate = date.getDate();
	var currHour = date.getHours();
	var currMinute = date.getMinutes();

	var PainArr = EmPainTime.split(" ");
	var DateArr = PainArr[0].split("-");
	/// ��
	if (DateArr[0] > currYear){
		return false;
	}
	/// ��
	if ((DateArr[0] == currYear)&(DateArr[1] > currMonth)){
		return false;
	}
	/// ��
	if (((DateArr[0] == currYear)&(DateArr[1] == currMonth))&(DateArr[2] > currDate)){
		return false;
	}
	var TimeArr = PainArr[1].split(":");
	if (TimeArr[0] > currHour){
		return false;
	}
	if (TimeArr[1] > currMinute){
		return false;
	}
	return true;
}
//ҳ���˳������checkbox yuliping
function clearGlasgow(){
	
	for(x=0;x<gcsArr2.length;x++){
		$('input[name="'+gcsArr2[x]+'"]').each(function(){
			
			$(this).attr("checked","");
				
		});	
	}
}
//��ȡ����˹���ܷ��� yuliping
function getGlasgowScore(){
	num=0
	
	for(x=0;x<gcsArr2.length;x++){
		$('input[name="'+gcsArr2[x]+'"]:checked').each(function(){
			
			var nums=$(this).attr("strCode")
			num=(num-0)+(nums-0)	
		});	
	}
	
	var str=getGlasgowLevel(num)
	$("#GlasgowScoe").html(str);
	
}
//��ȡ�����ܷ��� yuliping
function getScore(){
	EPnum=0
	
	for(x=0;x<aisArr2.length;x++){
		$('input[name="'+aisArr2[x]+'"]:checked').each(function(){
			
			var nums=$(this).attr("scoreais")
			
			EPnum=(EPnum-0)+(nums-0)	
		});	
	}
	var str=getEmPatPainlev(EPnum)
	$("#EmPatScoe").html(str);

	
}
//��ȡ����˹���ܷ�����Ӧ����ʾ��Ϣ yuliping
function getGlasgowLevel(num){

	var str=""
	if(num==15){
		str='��ʶ���(�ܷ�'+num+'��)'
		}else if((num>=12)&&(num<=14)){
			str='�����ʶ�ϰ�(�ܷ�'+num+'��)'
		}else if((num>=9)&&(num<=11)){
			str='�ж���ʶ�ϰ�(�ܷ�'+num+'��)'
		}else{
			str='����(�ܷ�'+num+'��)'
		}
	return str;
}
//��ȡ�����ܷ�����Ӧ����ʾ��Ϣ yuliping
function getEmPatPainlev(num){
	
	var str=""
	 if((num>=14)&&(num<=16)){
			str='����仯С��������Ϊ96%(�ܷ�'+num+'��)'
		}else if((num>=1)&&(num<=3)){
			str='����仯�ܴ�������>96%(�ܷ�'+num+'��)'
		}else if(num==0){
			str='(�ܷ�'+num+'��)'
		}else{
			str='����仯����������Ч��������(�ܷ�'+num+'��)'
			}
	return str;
}
//ҳ���˳������checkbox yuliping
function clearEmPain(){
	
	for(x=0;x<aisArr2.length;x++){
		$('input[name="'+aisArr2[x]+'"]').each(function(){
			
			$(this).attr("checked","");
				
		});	
	}
}
 
/// ��̬���ÿؼ����úͲ����� bianshuai 2017-03-09
function setComponentEnable(LvFlag, AreFlag){
	
	/// �ּ�Ϊ1��2����ȥ��Ϊ����ʱ,���Ȳ������÷��򲻿���
	if ((LvFlag == 1)||(LvFlag == 2)||(AreFlag == 1)){
		/// ���Ȳ�������
		$('#EmPatWard').combobox({disabled:false});
	}else{
		 /// ���Ȳ���������
		$('#EmPatWard').combobox({disabled:true});
	}
}

function blurBrith(){
		var mybirth = $('#emborth').val();
		if (mybirth != ""){
			if ((mybirth != "")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
				$('#emborth').val("");
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
			$('#emborth').val(mybirth);
			setPatAge(mybirth);
		}
	}

/// ��֤�����������
function setBrith(e){
	
	if(e.keyCode == 13){
		
		$('#empatage').focus();
		
	}

}

/// ��������
function setPatAge(borthdate){
	
    /// ȡ��������
    runClassMethod("web.DHCEMPatCheckLevQuery","GetPatientAgeDesc",{"PatientDOB":borthdate},function(jsonstring){
		if (jsonstring != null){
			$("#empatage").val(jsonstring);
		}
		
	},'',false)
}

/// �����ȡϵͳ��ȫ��
function GetSecurityNO(){
	var securityNO = "";
    runClassMethod("web.UDHCAccCardManage","GetCardCheckNo",{"PAPMINo":''},function(jsonstring){
		if (jsonstring != null){
			securityNO = jsonstring;
		}
		
	},'',false)
	return securityNO;
}

/// д�� bianshuai 2017-03-30
function WrtCard(mySecrityNo){
	
	var myCardNo = $("#emcardno").val();         /// ����
	var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
	if (rtn!="0"){
		return false;
	}
	
	return true;
}

/// ����֤���Ż�ȡ����ID
function GetPatientID(PatIdentNo){
	var PatientID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatientID",{"PatIdentNo":PatIdentNo},function(jsonString){
		if (jsonString != null){
			PatientID = jsonString;
		}
	},'',false)
	return PatientID;
}
/// ����ѹҺ�/δ�Һš��ѷ���/δ���� ��ѡ�� bianshuai 2018-03-09
function clearCheckBox(){
   
   /// ��ѡ��
   $('input[name="EmEpiFlag"]').attr("checked",false);
   $('input[name="EmCkLvFlag"]').attr("checked",false);
}