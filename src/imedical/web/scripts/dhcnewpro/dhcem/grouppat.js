///Creator:qqa
///Date:2018-09-12
$(function(){
	initParams();
	
	initCombobox();	
	
	initMethod();
	
	QueryGroupHurt();   // 默认查询一次
})

function initMethod(){
	///  群伤病人查找 lp 18-1-22
	$('#QueryGroupHurt').bind("click",QueryGroupHurt);  
	
	//生日
	$('#GroupHurtBirth').blur(blurBrith);	
	
	//年龄
	$("#GroupHurtAge").on('change',changeAge)
}

function initCombobox(){
	//群伤登记性别
	$('#GroupHurtSex').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTSex',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//$HUI.combobox('#GroupHurtSex').setValue(3);
	
	
	//群伤民族
	$('#GroupHurtNation').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTNation',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	
	
	//群伤事件类型
	$('#GroupHurtType').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetGroupHurtType&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true 
	})
}


/// 群伤病人查询 lp 18-1-22
function QueryGroupHurt(){
	var GroupHurtStDate=$('#GroupHurtStDate').combobox('getValue');
	var GroupHurtEndDate=$('#GroupHurtEndDate').combobox('getValue');
	var params=GroupHurtStDate+"^"+GroupHurtEndDate+"^"+LgHospID;
	$('#GroupPatGrid').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryGroupHurt',	
		queryParams:{
			params:params
		},onDblClickRow:function(index,row){
			if(parent.top.frames[0]){
				parent.top.frames[0].initDefaultValue(); //hxy 2020-06-01 调用清屏
				parent.top.frames[0].$("#EmPatNo").val(row.GroupHurtReg);		/// 登记号
				parent.top.frames[0].GetEmRegPatInfo();
				parent.top.frames[0].websys_showModal("close");
			}
		}
		
	});	
}

/// 群伤病人保存 lp 18-1-22
function SaveGroupHurtPat(){
	var GroupHurtType="";
	GroupHurtType=$('#GroupHurtType').combobox('getValue');
	if(GroupHurtType==""||typeof GroupHurtType=="undefined"){
		$.messager.alert('提示：','请选择群伤类型！');	
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
		$.messager.alert('提示：','请录入群伤人数！');
		return;	
	}
	
	total=parseInt(total);
	if(total==0){
		$.messager.alert('提示：','群伤人数不能为0！');
		return;	
	}
	
	var reg=/^[1-9]\d*$|^0$/;
	if(reg.test(total)==false){
    	$.messager.alert('提示：','请录入正确人数！');
    	return;
	}
	
	var GroupHurtDate = $HUI.datetimebox("#GroupHurtDate").getValue();
	
	//IE不支持：后台验证
	//if(GroupHurtDate!=""){
	//	if(new Date(GroupHurtDate)>new Date()){
	//		$.messager.alert('提示:','群伤日期不能大于当前日期！');
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
				$.messager.alert('提示：','群伤日期不能大于当前日期！');
				return;		
			}else{
				$.messager.alert('提示：','登记失败！');
				return;		
			}
		}else{
			$.messager.alert('提示：','登记成功！');
			clearGroupHurtRegWin(); //清空table数据
			QueryGroupHurt();
		}
	})
}

/// 群伤病人双击事件 lp 18-1-22
function ConveyInfo(rowIndex, rowData){
	$('#EmPatNo').val(rowData.GroupHurtReg);
	$('#empatname').val(rowData.GroupHurtName);
	$('#GroupHurtBirth').val(rowData.GroupHurtBirth);
	$('#GroupHurtAge').val(rowData.GroupHurtAge);
	$('#empatsex').combobox('setValue',rowData.GroupHurtSexDr);
	$('#emnation').combobox('setValue',rowData.GroupHurtNationDr);
	$('#emcountry').combobox('setValue',rowData.GroupHurtcountrydr);
	$('#PatientID').val(rowData.PatientID);
	$('#GroupHurtRegWin').window('close');
}


/// 群伤病人录入 lp 18-1-22
function GroupHurtReg(){
	clearGroupHurtRegWin(); //清空table数据
	QueryGroupHurt(); //查询群伤病人
	if($('#GroupHurtRegWin').is(":hidden")){
		$('#GroupHurtRegWin').window('open');
		return;
	}  //窗体处在打开状态,退出
		
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('群伤病人录入', 'GroupHurtRegWin', '600', '450', option).Init();
}


function clearGroupHurtRegWin(){
	$('#GroupHurtType').combobox('clear');//清空
	$('#GroupHurtName').val("");
	$('#GroupHurtSex').combobox('clear');//清空
	$('#GroupHurtAge').val("");
	$('#GroupHurtNation').combobox('clear');//清空
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
			$.messager.alert("提示:","请输入正确的日期!");
			return;
		}
		
		if (mybirth.length==8){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8);
		}
		
		var mybirth = GetSysDateToHtml(mybirth);  /// 根据His系统配置转换日期格式
		if (mybirth == ""){
			$.messager.alert("提示:","请输入正确的日期!");
			return;
		}
		
		if(mybirth=="ERROR!"){
			$.messager.alert("提示:","请输入正确的日期!");
			$('#GroupHurtBirth').val("");
			return;	
		}
		
		$('#GroupHurtBirth').val(mybirth);
		setPatAge(mybirth);
	}
}

/// 设置年龄
function setPatAge(borthdate){
    /// 取患者年龄
    runClassMethod("web.DHCEMPatCheckLevQuery","GetPatientAgeDesc",{"PatientDOB":borthdate},function(jsonstring){
		if (jsonstring != null){
			$("#GroupHurtAge").val(jsonstring);
		}
	},'',false)
}


/// 取His日期维护显示格式 bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){
	//qqa 2018-01-09 修改调用的类名
	runClassMethod("web.DHCEMPatCheckLevCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}

///初始化参数
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
		$.messager.alert("提示:","年龄不能为负！","",function(){
			$("#GroupHurtAge").val("")
			$("#GroupHurtAge").focus();
		});
		return;
	}

	/// 出生年龄在1岁至14岁之间，显示岁加月份，如12岁5月；
	if (date.indexOf("岁") != "-1"){
		dateArr=date.split("岁");
		if (dateArr[1].indexOf("月") != "-1"){
			new Date(now.setMonth((new Date().getMonth()-dateArr[0]*12)));
			new Date(now.setMonth((new Date().getMonth()-parseInt(dateArr[1]))));
		}else{
			new Date(now.setMonth((new Date().getMonth()-dateArr[0]*12)));
		}
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// 出生年龄在1个月至1岁之间，显示月份加天数，如5月7天；
	if (date.indexOf("月") != "-1"){
		dateArr=date.split("月");
		if (dateArr[1].indexOf("天") != "-1"){
			new Date(now.setMonth((new Date().getMonth()-dateArr[0])));
			newtimems=now.getTime()-(parseInt(dateArr[1])*24*60*60*1000);
			now.setTime(newtimems);
		}else{
			new Date(now.setMonth((new Date().getMonth()-dateArr[0])));
		}
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// 出生年龄在24小时至1个月，显示天，如19天
	if(date.indexOf("天") != "-1"){
		dateArr=date.split("天")
		newtimems=now.getTime()-(dateArr[0]*24*60*60*1000);
		now.setTime(newtimems);
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// 出生年龄在1小时至24小时之间，显示小时，如4小时；
	if(date.indexOf("小时")>=0){
		dateArr=date.split("小时")
		newtimems=now.getTime()-(dateArr[0]*60*60*1000);
		now.setTime(newtimems);
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	/// 出生年龄在1小时以内， 显示分钟，如36分钟；
	if(date.indexOf("分钟")>=0){
		dateArr=date.split("分钟")
		newtimems=now.getTime()-(dateArr[0]*60*1000);
		now.setTime(newtimems);
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#GroupHurtBirth").val(nowdate);
		return;	
	}

	if(parseInt(date)>175){
		$.messager.alert("提示:","年龄不能大于176！","",function(){
			$("#GroupHurtAge").val("")
			$("#GroupHurtAge").focus();
		});
		return;
	}

	/// 默认数字按照岁来处理
	new Date(now.setMonth((new Date().getMonth()-$(this).val()*12)));
	var date = new Date().Format("dd/MM/yyyy");
	var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
	$("#GroupHurtBirth").val(nowdate);	
}


Date.prototype.Format = function (formatStr) {
    var str = formatStr;
    var Week = ['日', '一', '二', '三', '四', '五', '六'];

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


/// 格式化日期  bianshuai 2014-09-18
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
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}
