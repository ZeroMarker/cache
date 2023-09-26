//页面Event
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
    if (obj.GroupDesc.indexOf('护士长')>-1) {
	    SupNurFlg = 1;
    }
    if (obj.GroupDesc.indexOf('主任')>-1) {
	    SupDocFlg = 1
    }
    
    // 初始化职业暴露主表信息
    obj.refreshRegInfo = function(){
		obj.RegInfo = $.Tool.RunQuery('DHCHAI.IRS.OccExpRegSrv','QryRepInfo',ReportID);
		if (obj.RegInfo!=''){
			if (obj.RegInfo.total!=0){
				var RegInfo = obj.RegInfo.record[0];
				$.form.SetValue("txtName",RegInfo.Name);
				$.form.SetValue("txtRegNo",RegInfo.RegNo);
				//年龄
				var sex = $("#cboSex").find(":contains('"+ RegInfo.Sex +"')").val(); //通过text取value
				$('#cboSex').select2(); //初始化select2
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
    // 初始化职业暴露扩展信息
    obj.refreshExtInfo  = function(){
	    //初始化所有日期、下拉列表
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
		//加载报告填写内容
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
			        if ((DataType=="B1")||(DataType=="B2")){  //界面中有多个是否、有无时 赋值方式
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
    
    // 初始化职业暴露检验信息
    obj.refreshLabInfo = function(){
	    //初始所有检验项目信息
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
        //加载检验项目填写信息
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
    //保存基本信息
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
        var ExpDateTime   = $.form.GetValue("ExpDateTime");   // 暴露日期时间
			ExpDateTime   = ExpDateTime.replace(" ","")
	    var ExpDate       = ExpDateTime.substring(0,10);        // 暴露日期
	    var ExpTime       = ExpDateTime.substring(10,15);       // 暴露时间
        var ExpAddr  =  $.form.GetValue("txtExpAddr");
        var TelPhone =  $.form.GetValue("txtTelPhone");
      
        if (Name==''){
    		layer.msg('暴露者姓名不能为空!',{icon: 2});
			return false;
    	}
    	if (ExpDateTime ==''){
    		layer.msg('暴露时间不能为空!',{icon: 2});
			return false;
    	}
    	if (ExpLoc ==''){
    		layer.msg('所在科室不能为空!',{icon: 2});
			return false;
    	}
    	if (Age ==''){
    		layer.msg('暴露者年龄不能为空!',{icon: 2});
			return false;
    	}
    	if (TelPhone ==''){
    		layer.msg('暴露者联系电话不能为空!',{icon: 2});
			return false;
    	}
    	if (!$.form.CompareDate(currDate,ExpDate)){
    		layer.msg('暴露日期不能在当前日期之后!',{icon: 2});
			return false;
    	}
    	
		var InputReg = ReportID;
		InputReg = InputReg + CHR_1 + RegTypeID;
		InputReg = InputReg + CHR_1 + RegDate;
		InputReg = InputReg + CHR_1 + RegTime;
		InputReg = InputReg + CHR_1 + RegLoc;
		InputReg = InputReg + CHR_1 + RegUser;
		InputReg = InputReg + CHR_1 + StatusCode; //状态	
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
		InputReg = InputReg + CHR_1 + ExpAddr;		   //发生地点
		InputReg = InputReg + CHR_1 + TelPhone;
		
		return InputReg;
	}
	
	//保存日志
	obj.RegLog_Save = function(StatusCode,Opinion){
		var InputRegLog = ReportID;
		InputRegLog = InputRegLog + CHR_1 + '';
		InputRegLog = InputRegLog + CHR_1 + StatusCode;		//状态
		InputRegLog = InputRegLog + CHR_1 + Opinion;
		InputRegLog = InputRegLog + CHR_1 + '';
		InputRegLog = InputRegLog + CHR_1 + '';
		InputRegLog = InputRegLog + CHR_1 + $.LOGON.USERID;
		
    	return InputRegLog;  
	}
	
	//保存项目定义
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
			    if (display=='none')  continue; //隐藏的项目不检查是否必填
			     
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
			       
			        var type = /(^[0-9]\d*$)/;　　//正整数+0
			        var regu = /^[0-9]+\.?[0-9]*$/; //小数
			        if ((ResultTxt!="")&&(DataType=="N0")){    //整数类型   
						if (!type.test(ResultTxt)) {
							layer.msg(ItemDesc+'只允许输入0-9的数字!',{icon: 2});
							return false;
						}
			        }
			        if ((ResultTxt!="")&&(DataType=="N1")){    //小数类型
				        if (!regu.test(ResultTxt)) {
							layer.msg(ItemDesc+'只允许输入小数的数字!',{icon: 2});
							return false;
						}
			        }
			        if ((ResultTxt!="")&&(DataType=="DD")){  //日期类型
						if (!$.form.CompareDate(currDate,ResultTxt)){
			    			layer.msg(ItemDesc+'不能在当前日期之后!',{icon: 2});
			    			return false;
			   			}
			        }
		        }
		        if (DataType=="S"){
	        		var ResultDr=$.form.GetValue("cbo"+ItemCode);
		        }
			    
			    if ((Required=='1')&&((ResultDr=="")&&(ResultList=="")&&(ResultTxt==""))) {             
	                layer.msg(TypeDesc+'中的'+ItemDesc+'不允许为空!',{icon: 2});
			    	return false;
                }
                 
                if ((ResultDr=="")&&(ResultList=="")&&(ResultTxt=="")) {  //值为空不保存
	                continue;
                }
                
                var ChildSub = $.Tool.RunServerMethod("DHCHAI.IR.OccExpRegExt","GetIDByItemDr",Parref,ItemDr);
                
				var InputRegExt = Parref;
				InputRegExt = InputRegExt + CHR_1 + ChildSub;
				InputRegExt = InputRegExt + CHR_1 + ItemDr;		//关联项目
				InputRegExt = InputRegExt + CHR_1 + ItemDesc;
				InputRegExt = InputRegExt + CHR_1 + DataType;   //5
				InputRegExt = InputRegExt + CHR_1 + ResultDr;
				InputRegExt = InputRegExt + CHR_1 + ResultList;
				InputRegExt = InputRegExt + CHR_1 + ResultTxt;
				InputRegExt = InputRegExt + CHR_1 + '';
				InputRegExt = InputRegExt + CHR_1 + '';         //10
				InputRegExt = InputRegExt + CHR_1 + ActUserDr;
				InputRegExts = InputRegExts + CHR_2 + InputRegExt;	 //保存多条
			}
			if(InputRegExts=="")
			{
				layer.msg('暴露信息不能为空!',{icon: 2});
				return false;
			}				
    	    return InputRegExts;
		}
	}
	
	 obj.RegLab_Save =function(){ 
	    var Parref    = ReportID;
	    if (!Parref) {
		    layer.msg('先填写职业暴露相关信息!',{icon: 2});
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
				if (LabDate =="") continue;   //未填写不保存
				var LabItem   = $.form.GetValue("txtLabItem"+SubID);
				var Result    = $.form.GetValue("txtResult"+SubID);
				var DeptDesc  = '';
				var Collector = '';
				var Reterence = '';
				var Examiner  = '';
				var ChildSub = $.Tool.RunServerMethod("DHCHAI.IR.OccExpRegLab","GetIDByTimDr",Parref,LabTimDr);
                
                if (!$.form.CompareDate(currDate,LabDate)){
		    		layer.msg(rd["BTDesc"]+' '+rd["Resume"]+' '+'检验日期不能在当前日期之后!',{icon: 2});
					return false;
		    	}
    	
                if (LabItem==''){
			    	layer.msg(rd["BTDesc"]+' '+rd["Resume"]+' '+'检验项目不能为空!',{icon: 2});
					return false;
			    }
			    if (Result==''){
			    	layer.msg(rd["BTDesc"]+' '+rd["Resume"]+' '+'检验结果不能为空!',{icon: 2});
					return false;
			    }
			    var InputRegLab = Parref;
				InputRegLab = InputRegLab + CHR_1 + ChildSub;
				InputRegLab = InputRegLab + CHR_1 + LabTimDr;		//时机
				InputRegLab = InputRegLab + CHR_1 + LabDate;
				InputRegLab = InputRegLab + CHR_1 + LabItem;
				InputRegLab = InputRegLab + CHR_1 + Result;
				InputRegLab = InputRegLab + CHR_1 + DeptDesc;
				InputRegLab = InputRegLab + CHR_1 + Collector;
				InputRegLab = InputRegLab + CHR_1 + Reterence;
				InputRegLab = InputRegLab + CHR_1 + Examiner;
				InputRegLabs = InputRegLabs + CHR_2 + InputRegLab;	 //保存多条	    	
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
			case '1':       // 提交
				$('#btnSave').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1){	// 管理员
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
			
				if(document.getElementById("blzsf")) {//js判断元素是否存在
					$('#btnSaveFlup').show();
					$("#blzsf").removeAttr("style");
				}
                if((document.getElementById("blpg"))||(document.getElementById("bljl"))||(document.getElementById("ygksf"))) {//js判断元素是否存在
					$('#btnSubmit').show();
					$("#blpg").removeAttr("style");
					$("#bljl").removeAttr("style");
					$("#ygksf").removeAttr("style");
				}
				break;
			case '2':       // 审核
	   			$('#btnExport').show();
				if (obj.AdminPower==1){	// 管理员
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
				if(document.getElementById("blzsf")) {//js判断元素是否存在
					$('#btnSaveFlup').show();
					$("#blzsf").removeAttr("style");		
				}
                if((document.getElementById("blpg"))||(document.getElementById("bljl"))||(document.getElementById("ygksf"))) {//js判断元素是否存在
					$('#btnSubmit').show();
					$("#blpg").removeAttr("style");
					$("#bljl").removeAttr("style");
					$("#ygksf").removeAttr("style");
				}
				break;
			case '5':       // 取消审核
				$('#btnSave').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1){	// 管理员
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
			case '3':       // 删除
			    if (!obj.RegLab_Save()) {
				    $("#ExpLab").attr("style","display:none");
			    }
			    $("#blzsf").attr("style","display:none");
			    $("#blpg").attr("style","display:none");
		        $("#bljl").attr("style","display:none");
		        $("#ygksf").attr("style","display:none");
				break;
			case '4':       // 退回
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

   // 提交
	$('#btnSave').click(function (e) {
		if (!obj.CheckInputData(1)){
			return;
		}
    	if (obj.Save()){
    		layer.msg('提交成功!',{icon: 1});
    	}else{
    		layer.msg('提交失败!',{icon: 2});
    	};
    	
	});

	// 审核
	$('#btnCheck').click(function (e) {
		if (obj.SaveStatus(2,"")){
    		layer.msg('审核成功!',{icon: 1});
    	}else{
    		layer.msg('审核失败!',{icon: 2});
    	};
	});

	// 删除
	$('#btnDelete').click(function (e) {
    	if (obj.SaveStatus(3,"")){
    		layer.msg('删除成功!',{icon: 1});
    	}else{
    		layer.msg('删除失败!',{icon: 2});
    	};
	});
    
    // 退回
	$('#btnReturn').click(function (e) {
		layer.prompt({
			title: '请填写退回原因(必填)', 
			formType: 0,  //输入框类型，支持0（文本）默认1（密码）2（多行文本）
			closeBtn: 0,
			btnAlign: 'c',
			maxlength: 50  //可输入文本的最大长度，默认500
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveStatus(4,value)){
		    		layer.msg('退回成功!',{icon: 1});
		    	}else{
		    		layer.msg('退回失败!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
	});

	// 取消审核
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveStatus(5,"")){
    		layer.msg('取消审核成功!',{icon: 1});
    	}else{
    		layer.msg('取消审核失败!',{icon: 2});
    	};
	});	
	
	// 护士长签字
	$('#btnSuperNur').click(function (e) {
		layer.prompt({
			title: '护士长签字意见(必填)', 
			formType: 2,  //输入框类型，支持0（文本）默认1（密码）2（多行文本）
			closeBtn: 0,
			btnAlign: 'c'
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveLog(8,value)){
		    		layer.msg('护士长签字成功!',{icon: 1});
		    	}else{
		    		layer.msg('护士长签字失败!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
    	
	});
	// 	科主任签字
	$('#btnSuperDor').click(function (e) {
		layer.prompt({
			title: '科主任签字意见(必填)', 
			formType: 2,  //输入框类型，支持0（文本）默认1（密码）2（多行文本）
			closeBtn: 0,
			btnAlign: 'c'
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveLog(9,value)){
		    		layer.msg('科主任签字成功!',{icon: 1});
		    	}else{
		    		layer.msg('科主任签字失败!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
    	
	});
	// 	主管部门签字
	$('#btnAdminDep').click(function (e) {
		layer.prompt({
			title: '主管签字意见(必填)', 
			formType: 2,  //输入框类型，支持0（文本）默认1（密码）2（多行文本）
			closeBtn: 0,
			btnAlign: 'c'
		   },function(value, index, elem){
			if (value!="") {
				if (obj.SaveLog(10,value)){
		    		layer.msg('主管部门签字成功!',{icon: 1});
		    	}else{
		    		layer.msg('主管部门签字失败!',{icon: 2});
		    	};
			}			
			layer.close(index);
		});
    	
	});
	
	// 感染科提交
	$('#btnSubmit').click(function (e) {
		obj.ExpRegLog  = obj.RegLog_Save(6,"");	            // 日志
		obj.ExpRegExt = "";
		if(document.getElementById("blpg")){
			obj.ExpRegExt  += obj.RegExt_Save("blpg");	        // 扩展表
		}
	    if (document.getElementById("bljl")) {
		    obj.ExpRegExt  += obj.RegExt_Save("bljl");	        // 扩展表
	    }
	    if(document.getElementById("ygksf")) {
		    obj.ExpRegExt  += obj.RegExt_Save("ygksf");	        // 扩展表
	    }
		
		if (!obj.ExpRegExt) {
			layer.msg('内容为空!',{icon: 2});
	        return false;
        }
    	if (obj.SaveRegExt()){
    		layer.msg('提交成功!',{icon: 1});
    	}else{
    		layer.msg('提交失败!',{icon: 2});
    	};
    	
	});
	
	// 	提交随访
	$('#btnSaveFlup').click(function (e) {
		obj.ExpRegLog  = obj.RegLog_Save(12,"");	            // 日志
		obj.ExpRegExt  = obj.RegExt_Save("blzsf");	            // 扩展表
        if (!obj.ExpRegExt) {
	        layer.msg('内容为空!',{icon: 2});
	        return false;
        }
    	if (obj.SaveRegExt()){
    		layer.msg('提交成功!',{icon: 1});
    	}else{
    		layer.msg('提交失败!',{icon: 2});
    	};
    	
	});
	
	// 导出
	$('#btnExport').click(function(e){  
	   var url="dhccpmrunqianreport.csp?reportName=OccExpReg.raq&aRepID="+ReportID;
       websys_createWindow(url,1,"width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");

	})
	
	
	// 数据完整性验证
	obj.CheckInputData = function (StatusCode){
		
		obj.ExpReg 	   = obj.Reg_Save(StatusCode);		// 报告主表信息
		obj.ExpRegLog  = obj.RegLog_Save(StatusCode,"");	// 日志
    	obj.ExpRegExt  = obj.RegExt_Save("");	            // 扩展表
     
        if (!obj.ExpReg) {
		    return false;
        }
    	if (!obj.ExpRegExt){
			return false;
        }
    	return true;
	}

	// 保存报告内容+状态
	obj.Save = function (){
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveExpReport',obj.ExpReg,obj.ExpRegExt,obj.ExpRegLog)
    	if (parseInt(ret)>0){
	    	ReportID = parseInt(ret);
    		obj.refreshRegInfo();
			obj.refreshExtInfo();
    		//不保存不必要刷新
			//obj.refreshLabInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}

	// 保存报告状态
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
	// 保存送检
	$('#btnSaveLab').click(function (e) {
		obj.ExpRegLog  = obj.RegLog_Save(7,"");	            // 日志
    	obj.ExpRegLab  = obj.RegLab_Save();				    // 血清学检查表 

    	if (!obj.ExpRegLab){
			 layer.msg('无检验结果!',{icon: 2});
	    	 return false;
    	}
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.OccExpRegSrv','SaveExpLab',obj.ExpRegLab,obj.ExpRegLog);
    	
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshLabInfo();
    		obj.InitButtons();
    		layer.msg('检验结果保存成功!',{icon: 1});
    	}else{
    		layer.msg('检验结果保存失败!',{icon: 2});
    	}
	});
	
	// 保存日志
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
	
	// 保存随访
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