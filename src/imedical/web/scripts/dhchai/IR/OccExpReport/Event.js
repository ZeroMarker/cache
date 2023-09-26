//ҳ��Event
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function InitExpReportWinEvent(obj){
	$.form.CheckBoxRender();
	$.form.iCheckRender();
	CheckSpecificKey();
    $.form.DateTimeRender1("ExpDateTime","")
    $.form.SetValue("txtRegUser",$.LOGON.USERDESC);
    $.form.SetValue("txtRegLoc",$.LOGON.LOCDESC); 
	$("#cboExpLoc").data("param",$.LOGON.HOSPID+"^^^^1"); 	
    $.form.SelectRender('cboExpLoc');	

    var currDate = $.form.GetCurrDate('-');
    obj.AdminPower  = AdminPower;
    obj.GroupDesc =session['LOGON.GROUPDESC'];
    var SupNurFlg = 0;
    var SupDocFlg = 0;
    if (obj.GroupDesc.indexOf('��ʿ��')>-1) {
	    SupNurFlg = 1;
    }
    if (obj.GroupDesc.indexOf('����')>-1) {
	    SupDocFlg = 1
    }
    
    // ��ʼ��ְҵ��¶������Ϣ
    obj.refreshRegInfo = function(){
		obj.RegInfo = $.Tool.RunQuery('DHCHAI.IRS.OccExpRegSrv','QryRepInfo',ReportID);
		if (obj.RegInfo!=''){
			if (obj.RegInfo.total!=0){
				var RegInfo = obj.RegInfo.record[0];
				$.form.SetValue("txtName",RegInfo.Name);
				$.form.SetValue("txtRegNo",RegInfo.RegNo);
				//����
				var sex = $("#cboSex").find(":contains('"+ RegInfo.Sex +"')").val(); //ͨ��textȡvalue
				$('#cboSex').select2(); //��ʼ��select2
				$("#cboSex").val(sex).trigger("change");
				
				$.form.SetValue("txtAge",RegInfo.Age);
				$.form.SetValue("txtWorkAge",RegInfo.WorkAge);
				$.form.SetValue("txtTelPhone",RegInfo.TelPhone);
				$.form.SetValue("txtDuty",RegInfo.Duty); 
				$.form.DateTimeRender("ExpDateTime",RegInfo.ExpDate+ ' ' + RegInfo.ExpTime);
				$.form.SetValue("cboExpLoc",RegInfo.ExpLocID,RegInfo.ExpLocDesc);
				$.form.SetValue("txtRepStatus",RegInfo.StatusDesc);
				$.form.SetValue("txtExpAddr",RegInfo.ExpAddr);
				$.form.SetValue("txtRegLoc",RegInfo.RegLocDesc);
				$.form.SetValue("txtRegUser",RegInfo.RegUserDesc);
				obj.RepStatusCode = RegInfo.StatusCode;
			}
		}
    }
    obj.refreshRegInfo();
    // ��ʼ��ְҵ��¶��չ��Ϣ
    obj.refreshExtInfo  = function(){
	    //��ʼ���������ڡ������б�
	    var ExtDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryOccExpTypeExt',RegTypeID);
		if(ExtDataQuery){
			var arrDT = ExtDataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				if (!rd) continue;
				var ItemDr   = rd["ID"];
				var DataType  = rd["DatCode"];
				var ItemCode = rd["Code"]; 
		        if (DataType=="DD"){
		        	$.form.DateRender("txt"+ItemCode,"");
			    }
			    if (DataType=="S"){
				    $.form.SelectRender("cbo"+ItemCode);	
			    }
			   
			}
		}
		//���ر�����д����
		obj.RegExt = $.Tool.RunQuery('DHCHAI.IRS.OccExpRegSrv','QryExpExtInfo',ReportID);
		if (obj.RegExt!=''){
			if (obj.RegExt.total!=0){
			    var arrDT = obj.RegExt.record;
				for (var ind = 0; ind < arrDT.length; ind++){
					var rd = arrDT[ind];
					if (!rd) continue;
					var DataType   = rd["DataType"];
					var ItemCode   = rd["Code"];
					var ResultID   = rd["ResultID"];
					var ResultCode = rd["ResultCode"];
					var ResultDesc = rd["ResultDesc"];
					var ResultTxt  = rd["ResultTxt"];
			        var ResultList = rd["ResultList"];
			         
			        if ((DataType=="DS")||(DataType=="DSL")){
		        		var selector = '#chk'+ItemCode+' #'+ResultID;
		        		$(selector).iCheck('check');
		        		//$("#"+ResultID).iCheck('check');
			        }
			        if ((DataType=="B1")||(DataType=="B2")){  //�������ж���Ƿ�����ʱ ��ֵ��ʽ
				        var selector = '#chk'+ItemCode+' #'+ResultID;
						$(selector).iCheck('check');
			        }
			        if ((DataType=="DB")||(DataType=="DBL")){
				         var Len = ResultList.split(",").length;
		        		 for (var indx=0;indx<Len;indx++) { 
				        	var Result = ResultList.split(",")[indx];
				        	$("#"+Result).iCheck('check');
				        }
			        }
			        if ((DataType=="T")||(DataType=="TL")||(DataType=="N0")||(DataType=="N1")||(DataType=="TB")) {
		        		$.form.SetValue("txt"+ItemCode,rd["ResultTxt"]);
			        }
			        if (DataType=="DD"){
		        		$.form.DateRender("txt"+ItemCode,rd["ResultTxt"],"top-right");
			        }
			        if (DataType=="S"){
		        		$.form.SetValue("cbo"+ItemCode,rd["ResultID"],rd["ResultDesc"]);
			        }
			      
				}
			}
   		 }
    }
    obj.refreshExtInfo();
    
    // ��ʼ��ְҵ��¶������Ϣ
    obj.refreshLabInfo = function(){
	    //��ʼ���м�����Ŀ��Ϣ
	    var LabDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryOccExpTypeLab',RegTypeID);
		if(LabDataQuery){
			var arrDT = LabDataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				if (!rd) continue;
				var LabTimDr  = rd["ID"];
				var SubID = LabTimDr.split("||")[1];
		        $.form.DateRender("txtLabDate"+SubID,"","top-right");
			}
		}
        //���ؼ�����Ŀ��д��Ϣ
		obj.RegLab = $.Tool.RunQuery('DHCHAI.IRS.OccExpRegSrv','QryExpLabInfo',ReportID);
		if (obj.RegLab!=''){
			if (obj.RegLab.total!=0){
			    var arrDT = obj.RegLab.record;
				for (var ind = 0; ind < arrDT.length; ind++){
					var rd = arrDT[ind];
					if (!rd) continue;
			        var SubID   = rd["LabTimID"].split("||")[1];
					$.form.DateRender("txtLabDate"+SubID,rd["LabDate"],"top-right");
					$.form.SetValue("txtLabItem"+SubID,rd["LabItem"]);
					$.form.SetValue("txtResult"+SubID,rd["Result"]);
			    }	
			}
		}	   
    }
    obj.refreshLabInfo();
    //���������Ϣ
    obj.Reg_Save = function (StatusCode){
		var RegDate = '';
		var RegTime = '';
		var RegLoc  = $.LOGON.LOCID;
		var RegUser = $.LOGON.USERID;
		        
        var Name     = $.form.GetValue("txtName");
        var RegNo    = $.form.GetValue("txtRegNo");
        var ExposerDr = $.Tool.RunServerMethod("DHCHAI.BT.SysUser","GetIDByCode",RegNo);
        var Sex      = $.form.GetValue("cboSex"); 
        var Birthday = '';
        var Age      = $.form.GetValue("txtAge");
        var WorkAge  = $.form.GetValue("txtWorkAge");
        var Duty     = $.form.GetValue("txtDuty");
        var ExpLoc   = $.form.GetValue("cboExpLoc");
        var ExpDateTime   = $.form.GetValue("ExpDateTime");   // ��¶����ʱ��
			ExpDateTime   = ExpDateTime.replace(" ","")
	    var ExpDate       = ExpDateTime.substring(0,10);        // ��¶����
	    var ExpTime       = ExpDateTime.substring(10,15);       // ��¶ʱ��
        var ExpAddr  =  $.form.GetValue("txtExpAddr");
        var TelPhone =  $.form.GetValue("txtTelPhone");
      
        if (Name==''){
    		layer.msg('��¶����������Ϊ��!',{icon: 2});
			return false;
    	}
    	if (ExpDateTime ==''){
    		layer.msg('��¶ʱ�䲻��Ϊ��!',{icon: 2});
			return false;
    	}
    	if (ExpLoc ==''){
    		layer.msg('���ڿ��Ҳ���Ϊ��!',{icon: 2});
			return false;
    	}
    	if (Age ==''){
    		layer.msg('��¶�����䲻��Ϊ��!',{icon: 2});
			return false;
    	}
    	if (TelPhone ==''){
    		layer.msg('��¶����ϵ�绰����Ϊ��!',{icon: 2});
			return false;
    	}
    	if (!$.form.CompareDate(currDate,ExpDate)){
    		layer.msg('��¶���ڲ����ڵ�ǰ����֮��!',{icon: 2});
			return false;
    	}
    	
		var InputReg = ReportID;
		InputReg = InputReg + CHR_1 + RegTypeID;
		InputReg = InputReg + CHR_1 + RegDate;
		InputReg = InputReg + CHR_1 + RegTime;
		InputReg = InputReg + CHR_1 + RegLoc;
		InputReg = InputReg + CHR_1 + RegUser;
		InputReg = InputReg + CHR_1 + StatusCode; //״̬	
		InputReg = InputReg + CHR_1 + ExposerDr;		
		InputReg = InputReg + CHR_1 + Name;
		InputReg = InputReg + CHR_1 + RegNo;
		InputReg = InputReg + CHR_1 + Sex;
		InputReg = InputReg + CHR_1 + Birthday;
		InputReg = InputReg + CHR_1 + Age;
		InputReg = InputReg + CHR_1 + WorkAge;
		InputReg = InputReg + CHR_1 + Duty;		
		InputReg = InputReg + CHR_1 + ExpLoc;
		InputReg = InputReg + CHR_1 + ExpDate;
		InputReg = InputReg + CHR_1 + ExpTime;
		InputReg = InputReg + CHR_1 + ExpAddr;		   //�����ص�
		InputReg = InputReg + CHR_1 + TelPhone;
		
		return InputReg;
	}
	
	//������־
	obj.RegLog_Save = function(StatusCode,Opinion){
		var InputRegLog = ReportID;
		InputRegLog = InputRegLog + CHR_1 + '';
		InputRegLog = InputRegLog + CHR_1 + StatusCode;		//״̬
		InputRegLog = InputRegLog + CHR_1 + Opinion;
		InputRegLog = InputRegLog + CHR_1 + '';
		InputRegLog = InputRegLog + CHR_1 + '';
		InputRegLog = InputRegLog + CHR_1 + $.LOGON.USERID;
		
    	return InputRegLog;  
	}
	
	//������Ŀ����
	obj.RegExt_Save =function (aExtType){
		
	    var Parref   = ReportID;
	    var InputRegExts="";
	    if (aExtType) {
		   var ExtTypeID = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","GetIDByCode","OEExtType",aExtType)
		   if (ExtTypeID) {
		   		var ExtDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryExtByType',RegTypeID,ExtTypeID);
		   }else {
			   return false;
		   }
	    }else {
	    	var ExtDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryOccExpTypeExt',RegTypeID);
	    }
		if(ExtDataQuery){
			var arrDT = ExtDataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				if (!rd) continue;
				var ItemDr     = rd["ID"];
				var ItemCode   = rd["Code"];
				var ItemDesc   = rd["Desc"];
				var DataType   = rd["DatCode"];
				var Required   = rd["IsRequired"];
				var ResultDr   = '';
				var ResultList = '';
				var ResultTxt  = '';
				var ActUserDr  = $.LOGON.USERID;
				var TypeDesc   = rd["TypeDesc"];
				var TypeCode   = rd["TypeCode"];
			
		        var display =$("#"+TypeCode).css('display');
			    if (display=='none')  continue; //���ص���Ŀ������Ƿ����
			     
				if ((DataType=="DS")||(DataType=="DSL")||(DataType=="B1")||(DataType=="B2")){
					$('input:radio',$("#chk"+ItemCode)).each(function(){
			       		if(true == $(this).is(':checked')){
			            	ResultDr=$(this).attr("id");
			       		}
    				});
			    }
		        if ((DataType=="DB")||(DataType=="DBL")){
			        $('input:checkbox',$("#chk"+ItemCode)).each(function(){
			       		if(true == $(this).is(':checked')){
			            	ResultList+=$(this).attr("id")+"#";
			       		}
			    	});
		        }
		        if ((DataType=="T")||(DataType=="TL")||(DataType=="TB")||(DataType=="N0")||(DataType=="N1")||(DataType=="DD")){
			        var ResultTxt = $.form.GetValue("txt"+ItemCode);
			       
			        var type = /(^[0-9]\d*$)/;����//������+0
			        var regu = /^[0-9]+\.?[0-9]*$/; //С��
			        if ((ResultTxt!="")&&(DataType=="N0")){    //��������   
						if (!type.test(ResultTxt)) {
							layer.msg(ItemDesc+'ֻ��������0-9������!',{icon: 2});
							return false;
						}
			        }
			        if ((ResultTxt!="")&&(DataType=="N1")){    //С������
				        if (!regu.test(ResultTxt)) {
							layer.msg(ItemDesc+'ֻ��������С��������!',{icon: 2});
							return false;
						}
			        }
			        if ((ResultTxt!="")&&(DataType=="DD")){  //��������
						if (!$.form.CompareDate(currDate,ResultTxt)){
			    			layer.msg(ItemDesc+'�����ڵ�ǰ����֮��!',{icon: 2});
			    			return false;
			   			}
			        }
		        }
		        if (DataType=="S"){
	        		var ResultDr=$.form.GetValue("cbo"+ItemCode);
		        }
			    
			    if ((Required=='1')&&((ResultDr=="")&&(ResultList=="")&&(ResultTxt==""))) {             
	                layer.msg(TypeDesc+'�е�'+ItemDesc+'������Ϊ��!',{icon: 2});
			    	return false;
                }
                 
                if ((ResultDr=="")&&(ResultList=="")&&(ResultTxt=="")) {  //ֵΪ�ղ�����
	                continue;
                }
                
                var ChildSub = $.Tool.RunServerMethod("DHCHAI.IR.OccExpRegExt","GetIDByItemDr",Parref,ItemDr);
                
				var InputRegExt = Parref;
				InputRegExt = InputRegExt + CHR_1 + ChildSub;
				InputRegExt = InputRegExt + CHR_1 + ItemDr;		//������Ŀ
				InputRegExt = InputRegExt + CHR_1 + ItemDesc;
				InputRegExt = InputRegExt + CHR_1 + DataType;   //5
				InputRegExt = InputRegExt + CHR_1 + ResultDr;
				InputRegExt = InputRegExt + CHR_1 + ResultList;
				InputRegExt = InputRegExt + CHR_1 + ResultTxt;
				InputRegExt = InputRegExt + CHR_1 + '';
				InputRegExt = InputRegExt + CHR_1 + '';         //10
				InputRegExt = InputRegExt + CHR_1 + ActUserDr;
				InputRegExts = InputRegExts + CHR_2 + InputRegExt;	 //�������
			}
			if(InputRegExts=="")
			{
				layer.msg('��¶��Ϣ����Ϊ��!',{icon: 2});
				return false;
			}				
    	    return InputRegExts;
		}
	}
	
	 obj.RegLab_Save =function(){ 
	    var Parref    = ReportID;
	    if (!Parref) {
		    layer.msg('����дְҵ��¶�����Ϣ!',{icon: 2});
			return false;
	    }
	    var InputRegLabs="";
	    var LabDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryOccExpTypeLab',RegTypeID);
		if(LabDataQuery){
			var arrDT = LabDataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				if (!rd) continue;
				var LabTimDr  = rd["ID"];
				var SubID = LabTimDr.split("||")[1];
				var LabDate   = $.form.GetValue("txtLabDate"+SubID);
				if (LabDate =="") continue;   //δ��д������
				var LabItem   = $.form.GetValue("txtLabItem"+SubID);
				var Result    = $.form.GetValue("txtResult"+SubID);
				var DeptDesc  = '';
				var Collector = '';
				var Reterence = '';
				var Examiner  = '';
				var ChildSub = $.Tool.RunServerMethod("DHCHAI.IR.OccExpRegLab","GetIDByTimDr",Parref,LabTimDr);
                
                if (!$.form.CompareDate(currDate,LabDate)){
		    		layer.msg(rd["BTDesc"]+' '+rd["Resume"]+' '+'�������ڲ����ڵ�ǰ����֮��!',{icon: 2});
					return false;
		    	}
    	
                if (LabItem==''){
			    	layer.msg(rd["BTDesc"]+' '+rd["Resume"]+' '+'������Ŀ����Ϊ��!',{icon: 2});
					return false;
			    }
			    if (Result==''){
			    	layer.msg(rd["BTDesc"]+' '+rd["Resume"]+' '+'����������Ϊ��!',{icon: 2});
					return false;
			    }
			    var InputRegLab = Parref;
				InputRegLab = InputRegLab + CHR_1 + ChildSub;
				InputRegLab = InputRegLab + CHR_1 + LabTimDr;		//ʱ��
				InputRegLab = InputRegLab + CHR_1 + LabDate;
				InputRegLab = InputRegLab + CHR_1 + LabItem;
				InputRegLab = InputRegLab + CHR_1 + Result;
				InputRegLab = InputRegLab + CHR_1 + DeptDesc;
				InputRegLab = InputRegLab + CHR_1 + Collector;
				InputRegLab = InputRegLab + CHR_1 + Reterence;
				InputRegLab = InputRegLab + CHR_1 + Examiner;
				InputRegLabs = InputRegLabs + CHR_2 + InputRegLab;	 //�������	    	
			}
			return InputRegLabs;
		}
	}

   	obj.InitButtons = function(){
	   	$('#btnSave').hide();
		$('#btnCheck').hide();
		$('#btnUnCheck').hide();
		$('#btnDelete').hide();
		$('#btnReturn').hide();
	    $('#btnSubmit').hide();
		$('#btnSaveLab').hide();
		$('#btnSuperNur').hide();
		$('#btnSuperDor').hide();
		$('#btnAdminDep').hide();
		$('#btnSaveFlup').hide();
		$('#btnExport').hide();
		
		switch (obj.RepStatusCode){
			case '1':       // �ύ
				$('#btnSave').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1){	// ����Ա
					$('#btnCheck').show();
					$('#btnReturn').show();
					$('#btnDelete').show();
					$('#btnSaveLab').show();
					$('#btnExport').show();
					$("#ExpLab").removeAttr("style");
				}
				if (SupNurFlg==1) {
					$('#btnSuperNur').show();
				}
				if (SupDocFlg==1) {
					$('#btnSuperDor').show();
				}
			
				if(document.getElementById("blzsf")) {//js�ж�Ԫ���Ƿ����
					$('#btnSaveFlup').show();
					$("#blzsf").removeAttr("style");
				}
                if((document.getElementById("blpg"))||(document.getElementById("bljl"))||(document.getElementById("ygksf"))) {//js�ж�Ԫ���Ƿ����
					$('#btnSubmit').show();
					$("#blpg").removeAttr("style");
					$("#bljl").removeAttr("style");
					$("#ygksf").removeAttr("style");
				}
				break;
			case '2':       // ���
	   			$('#btnExport').show();
				if (obj.AdminPower==1){	// ����Ա
					$('#btnUnCheck').show();
					$('#btnSaveLab').show();
					$('#btnExport').show();
					$("#ExpLab").removeAttr("style");
				}
				if (SupNurFlg==1) {
					$('#btnSuperNur').show();
				}
				if (SupDocFlg==1) {
					$('#btnSuperDor').show();
				}
				if(document.getElementById("blzsf")) {//js�ж�Ԫ���Ƿ����
					$('#btnSaveFlup').show();
					$("#blzsf").removeAttr("style");		
				}
                if((document.getElementById("blpg"))||(document.getElementById("bljl"))||(document.getElementById("ygksf"))) {//js�ж�Ԫ���Ƿ����
					$('#btnSubmit').show();
					$("#blpg").removeAttr("style");
					$("#bljl").removeAttr("style");
					$("#ygksf").removeAttr("style");
				}
				break;
			case '5':       // ȡ�����
				$('#btnSave').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1){	// ����Ա
					$('#btnCheck').show();
					$('#btnReturn').show();
					$('#btnSaveFlup').show();
				}
				if (SupNurFlg==1) {
					$('#btnSuperNur').show();
				}
				if (SupDocFlg==1) {
					$('#btnSuperDor').show();
				}
				if (!obj.RegLab_Save()) {
				    $("#ExpLab").attr("style","display:none");
			    }
				break;
			case '3':       // ɾ��
			    if (!obj.RegLab_Save()) {
				    $("#ExpLab").attr("style","display:none");
			    }
			    $("#blzsf").attr("style","display:none");
			    $("#blpg").attr("style","display:none");
		        $("#bljl").attr("style","display:none");
		        $("#ygksf").attr("style","display:none");
				break;
			case '4':       // �˻�
				$('#btnSave').show();
				$('#btnDelete').show();
				if (!obj.RegLab_Save()) {
				    $("#ExpLab").attr("style","display:none");
			    } 
			    $("#blzsf").attr("style","display:none");
				$("#blpg").attr("style","display:none");
		        $("#bljl").attr("style","display:none");
		        $("#ygksf").attr("style","display:none");
				break;
			default:
				$('#btnSave').show();
				$("#ExpLab").attr("style","display:none");
				$("#blzsf").attr("style","display:none");			   
				$("#blpg").attr("style","display:none");
		        $("#bljl").attr("style","display:none");
		        $("#ygksf").attr("style","display:none");
				break;
		}
	}
	obj.InitButtons();

   // �ύ
	$('#btnSave').click(function (e) {
		if (!obj.CheckInputData(1)){
			return;
		}
    	if (obj.Save()){
    		layer.msg('�ύ�ɹ�!',{icon: 1});
    	}else{
    		layer.msg('�ύʧ��!',{icon: 2});
    	};
    	
	});

	// ���
	$('#btnCheck').click(function (e) {
		if (obj.SaveStatus(2,"")){
    		layer.msg('��˳ɹ�!',{icon: 1});
    	}else{
    		layer.msg('���ʧ��!',{icon: 2});
    	};
	});

	// ɾ��
	$('#btnDelete').click(function (e) {
    	if (obj.SaveStatus(3,"")){
    		layer.msg('ɾ���ɹ�!',{icon: 1});
    	}else{
    		layer.msg('ɾ��ʧ��!',{icon: 2});
    	};
	});
    
    // �˻�
	$('#btnReturn').click(function (e) {
		layer.prompt({
			title: '����д�˻�ԭ��(����)', 
			formType: 0,  //��������ͣ�֧��0���ı���Ĭ��1�����룩2�������ı���
			closeBtn: 0,
			btnAlign: 'c',
			maxlength: 50  //�������ı�����󳤶ȣ�Ĭ��500
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveStatus(4,value)){
		    		layer.msg('�˻سɹ�!',{icon: 1});
		    	}else{
		    		layer.msg('�˻�ʧ��!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
	});

	// ȡ�����
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveStatus(5,"")){
    		layer.msg('ȡ����˳ɹ�!',{icon: 1});
    	}else{
    		layer.msg('ȡ�����ʧ��!',{icon: 2});
    	};
	});	
	
	// ��ʿ��ǩ��
	$('#btnSuperNur').click(function (e) {
		layer.prompt({
			title: '��ʿ��ǩ�����(����)', 
			formType: 2,  //��������ͣ�֧��0���ı���Ĭ��1�����룩2�������ı���
			closeBtn: 0,
			btnAlign: 'c'
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveLog(8,value)){
		    		layer.msg('��ʿ��ǩ�ֳɹ�!',{icon: 1});
		    	}else{
		    		layer.msg('��ʿ��ǩ��ʧ��!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
    	
	});
	// 	������ǩ��
	$('#btnSuperDor').click(function (e) {
		layer.prompt({
			title: '������ǩ�����(����)', 
			formType: 2,  //��������ͣ�֧��0���ı���Ĭ��1�����룩2�������ı���
			closeBtn: 0,
			btnAlign: 'c'
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveLog(9,value)){
		    		layer.msg('������ǩ�ֳɹ�!',{icon: 1});
		    	}else{
		    		layer.msg('������ǩ��ʧ��!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
    	
	});
	// 	���ܲ���ǩ��
	$('#btnAdminDep').click(function (e) {
		layer.prompt({
			title: '����ǩ�����(����)', 
			formType: 2,  //��������ͣ�֧��0���ı���Ĭ��1�����룩2�������ı���
			closeBtn: 0,
			btnAlign: 'c'
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveLog(10,value)){
		    		layer.msg('���ܲ���ǩ�ֳɹ�!',{icon: 1});
		    	}else{
		    		layer.msg('���ܲ���ǩ��ʧ��!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
    	
	});
	
	// ��Ⱦ���ύ
	$('#btnSubmit').click(function (e) {
		obj.ExpRegLog  = obj.RegLog_Save(6,"");	            // ��־
		obj.ExpRegExt = "";
		if(document.getElementById("blpg")){
			obj.ExpRegExt  += obj.RegExt_Save("blpg");	        // ��չ��
		}
	    if (document.getElementById("bljl")) {
		    obj.ExpRegExt  += obj.RegExt_Save("bljl");	        // ��չ��
	    }
	    if(document.getElementById("ygksf")) {
		    obj.ExpRegExt  += obj.RegExt_Save("ygksf");	        // ��չ��
	    }
		
		if (!obj.ExpRegExt) {
			layer.msg('����Ϊ��!',{icon: 2});
	        return false;
        }
    	if (obj.SaveRegExt()){
    		layer.msg('�ύ�ɹ�!',{icon: 1});
    	}else{
    		layer.msg('�ύʧ��!',{icon: 2});
    	};
    	
	});
	
	// 	�ύ���
	$('#btnSaveFlup').click(function (e) {
		obj.ExpRegLog  = obj.RegLog_Save(12,"");	            // ��־
		obj.ExpRegExt  = obj.RegExt_Save("blzsf");	            // ��չ��
        if (!obj.ExpRegExt) {
	        layer.msg('����Ϊ��!',{icon: 2});
	        return false;
        }
    	if (obj.SaveRegExt()){
    		layer.msg('�ύ�ɹ�!',{icon: 1});
    	}else{
    		layer.msg('�ύʧ��!',{icon: 2});
    	};
    	
	});
	
	// ����
	$('#btnExport').click(function(e){  
	   var url="dhccpmrunqianreport.csp?reportName=OccExpReg.raq&aRepID="+ReportID;
       websys_createWindow(url,1,"width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");

	})
	
	
	// ������������֤
	obj.CheckInputData = function (StatusCode){
		
		obj.ExpReg 	   = obj.Reg_Save(StatusCode);		// ����������Ϣ
		obj.ExpRegLog  = obj.RegLog_Save(StatusCode,"");	// ��־
    	obj.ExpRegExt  = obj.RegExt_Save("");	            // ��չ��
     
        if (!obj.ExpReg) {
		    return false;
        }
    	if (!obj.ExpRegExt){
			return false;
        }
    	return true;
	}

	// ���汨������+״̬
	obj.Save = function (){
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveExpReport',obj.ExpReg,obj.ExpRegExt,obj.ExpRegLog)
    	if (parseInt(ret)>0){
	    	ReportID = parseInt(ret);
    		obj.refreshRegInfo();
			obj.refreshExtInfo();
    		//�����治��Ҫˢ��
			//obj.refreshLabInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}

	// ���汨��״̬
	obj.SaveStatus = function(StatusCode,Opinion){
		obj.ExpRegLog  = obj.RegLog_Save(StatusCode,Opinion);

		var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveRepStatus',ReportID,StatusCode,obj.ExpRegLog)
    	if (parseInt(ret)>0){
	    	ReportID = parseInt(ret);
	    	obj.refreshRegInfo();
	    	obj.refreshLabInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}
	// �����ͼ�
	$('#btnSaveLab').click(function (e) {
		obj.ExpRegLog  = obj.RegLog_Save(7,"");	            // ��־
    	obj.ExpRegLab  = obj.RegLab_Save();				    // Ѫ��ѧ���� 

    	if (!obj.ExpRegLab){
			 layer.msg('�޼�����!',{icon: 2});
	    	 return false;
    	}
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveExpLab',obj.ExpRegLab,obj.ExpRegLog);
    	
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshLabInfo();
    		obj.InitButtons();
    		layer.msg('����������ɹ�!',{icon: 1});
    	}else{
    		layer.msg('����������ʧ��!',{icon: 2});
    	}
	});
	
	// ������־
	obj.SaveLog = function(StatusCode,Opinion){
		obj.ExpRegLog  = obj.RegLog_Save(StatusCode,Opinion);
			
		var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveRepLog',ReportID,obj.ExpRegLog)
    	if (parseInt(ret)>0){
	    	ReportID = parseInt(ret);
	    	obj.refreshRegInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}
	
	// �������
	obj.SaveRegExt = function(){
		
		var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveRegExt',obj.ExpRegExt,obj.ExpRegLog)
    	if (parseInt(ret)>0){
	    	ReportID = parseInt(ret);
	    	obj.refreshExtInfo();
    		return true;
    	}else{
    		return false;
    	}
	}
}