
/// 新版登记注册和预检分诊类JS  bianshuai 2016-04-25
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var m_CardNoLength = 0;               //卡号长度

/// 页面初始化函数
function initPageDefault(){
	initView();
	initCombobox();  ///  页面Combobox初始定义
	
	initBlButton();  ///  页面Button 绑定事件
	initCheckBoxEvent();     /// 初始化页面CheckBox事件
	initRadioEvent();        /// 初始化页面radio事件
	initCardTypeCombobox();  /// 初始化页面卡类型定义
	initLoadEmPatLevDic();   /// 初始化加载字典数据
	initSymptomLevTree();    /// 初始化症状树
	initDataGrid();  ///  页面DataGrid初始定义
	
	
}

function initView(){
	if(parPatientID==""){
		return;	
	}
	
	$("#PatientID").val(parPatientID)
	GetEmRegPatInfo()	
}
/// 页面Combobox初始定义
function initCombobox(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	
	/// 卡类型
	var option = {
		onSelect:function(option){
			
	        var CardTypeDefArr = option.value.split("^");
	        m_CardNoLength = CardTypeDefArr[17];
	        
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#emcardno').attr("readOnly",false);
		    }else{
				$('#emcardno').attr("readOnly",true);
			}
			$('#emcardno').val("");  /// 清空内容
	    }
	};
	var url = uniturl+"CardTypeDefineListBroker";
	new ListCombobox("emcardtype",url,'',option).init();

	/// 性别
	var url = uniturl+"jsonCTSex";
	new ListCombobox("empatsex",url,'').init();
	
	/// 民族
	var url = uniturl+"jsonCTNation";
	new ListCombobox("emnation",url,'').init();
	
	/// 国籍
	var url = uniturl+"jsonCTCountry";
	new ListCombobox("emcountry",url,'').init();
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=";
	
	/// 更改分级原因
	var url = uniturl+"jsonEmUpdLevReson&HospID="+LgHospID;
	new ListCombobox("EmUpdLevRe",url,'').init();
	
	/**	
	/// 分诊科室
	var url = uniturl+"jsonGetEmPatLoc";
	var option = {
        onSelect:function(option){
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+option.value;
	        $("#EmCheckNo").combobox('reload', url);
	    }
	};
	new ListCombobox("EmLocID",url,'',option).init();
	$("#EmLocID").combobox('setValue',LgCtLocID);
	
	/// 号别
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
	/// 推荐分级
	var EmRecLevelArr = [{"value":"1","text":'一级'}, {"value":"2","text":'二级'}, 
		{"value":"3","text":'三级'}, {"value":"4","text":'四级'}];
	new ListCombobox("EmRecLevel",'',EmRecLevelArr).init();
		
	/// 疼痛范围
	var EmPainRangeArr = [{"value":"1","text":'中枢'}, {"value":"2","text":'外周'}];
	new ListCombobox("EmPainRange",'',EmPainRangeArr).init();
	
	/// 意识状态
	var url = uniturl+"jsonPatAWare&HospID="+LgHospID;
	new ListCombobox("EmAware",url,'').init();
	
	$( "#slider" ).slider({
		onSlideEnd:function(value){
			/// 设置疼痛分级项目值
			$("#EmPainLev").val(value);
			$(".face-regin-title span").css({"color":""});
			$(".face-regin-title span:contains('["+value+"]')").css({"color":"#ff7a00"});
		}
	});
	
	///  来诊时间
	$("#emvistime").datebox("setValue",formatDate(0));

}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'预检分诊',width:185,formatter:setCellLabel},
		{field:'PatNo',title:'姓名',width:100,hidden:true},
		{field:'PatName',title:'登记号',width:100,hidden:true},
		{field:'PatSex',title:'性别',width:100,hidden:true},
		{field:'PatAge',title:'年龄',width:100,hidden:true},
		{field:'PatientID',title:'PatientID',width:100,hidden:true},
		{field:'Adm',title:'Adm',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		//title:'病人列表',
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        clearEmPanel();				///  清空
	        setRegPanelInfo(rowData);   ///  设置登记面板数
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            ///  设置分诊区域
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	$("#tb .btn-success").html(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$("#tb .btn-warning").html(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$("#tb .btn-danger").html(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);
			$('.panel-title:contains("未分诊")').html("病人列表(未分诊:"+data.EmPatLevNotCnt+"人)");
		}
	};

	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryEmRegPatlist";
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false});  
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  读卡
	$('a:contains("读卡")').bind("click",readCard);
	
	///  登记
	$('a:contains("登记")').bind("click",register);
	
	///  修改
	$('a:contains("修改")').bind("click",modify);
	
	///  确认分诊
	$('button:contains("分诊")').bind("click",triage); 
	
	///  清空
	$('a:contains("清空")').bind("click",clearEmPanel); 
	
    ///  登记号查询
    $('#search').searchbox({ 
	   searcher:function(value,name){
		   QueryEmPatListByPatNo(value);
	   }
    });
	
	///	 登记号
	$('#EmPatNo').bind('keypress',GetEmPatInfo);
	
	///  卡号
	$('#emcardno').bind('keypress',GetEmPatInfoByCardNo);
	
	///	 疼痛分级
	$('a:contains("疼痛分级")').bind("click",EmPatPainLevWin);
	
	///  疼痛分级笑脸按钮事件
	$(".face-regin li").bind("click",EmPainFaceEvt);
	
	///  取消
	$('a:contains("取消")').bind("click",cancelEmPainWin);
	
	///  确认
	$('a:contains("确认")').bind("click",sureEmPainWin);
	
	///  症状
	//$('.item—list li span').live("click",symItemListClick);
	
	$("#symList .button").live("click",symItemListClickNew);
	/// 身份证
	$('#emidentno').bind("blur",setEmBorth);
	
	///  分区按钮事件
	$('#tb .btn-danger,#tb .btn-warning,#tb .btn-success').bind("click",EmPatWardClick);
	
	///  生命体征
	$('input[name="EmPcs1"],input[name="EmPcs2"]').bind("blur",setEmRecLevel); 
	
	///  已分诊 / 未分诊
	$('#menu').menu({    
	    onClick:function(item){    
		    QueryEmPatList(item.name);
	    }    
	});
	
	///  查询条件
	$('[title^="显示"]').bind("click",function(e){
		
		$('#menu').menu('show', {    
		    left: e.pageX,
		    top: e.pageY
		}); 
	});
	
	///  出生日期
	$('#emborth').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	///  疼痛日期
	$('#EmPainTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
}

/// 初始化页面卡类型定义
function initCardTypeCombobox(){
	
	/// 获取默认卡类型
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		var defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
        if (CardTypeDefArr[16] == "Handle"){
	    	$('#emcardno').attr("readOnly",false);
	    }else{
			$('#emcardno').attr("readOnly",true);
		}
		$("#emcardtype").combobox("setValue",defaultCardTypeDr);
	},'',false)
}

/// 初始化页面CheckBox事件
function initCheckBoxEvent(){

	$("input[type=checkbox]").live('click',function(){
		///  既往史允许多选
		if (this.name == "EmPatChkHis") {
			setEmRecLevel();
			return;
		}
		///  号别
		if (this.name == "SelEmCheckNo") {
			$(this).parent().remove();
			return;
		}
		///  症状
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
		
		/// 疼痛分级
		if((this.name == "EmPainFlag")&(this.value == "N")) {
			$("#EmPainDesc").val("");  ///  疼痛分级描述
			$("#EmPainRange").combobox('setValue',"");    ///  疼痛范围
			$("#EmPainTime").datetimebox('setValue',"");  ///  疼痛时间
			$("#EmPainLev").val("");  ///  疼痛指数
		}
		
		/// 成批就诊
		if(this.name == "EmBatchFlag") {
			if (this.value == "N") {
				$("#EmBatchNum").val("");  ///  用药情况
				$('#EmBatchNum').attr("disabled",true);
			}else{
				$('#EmBatchNum').attr("disabled",false);
			}
		}
			
		/// 用药情况
		if(this.name == "EmHisDrug") {
			if (this.value == "N") {
				$("#EmHisDrugDesc").val("");  ///  用药情况
				$('#EmHisDrugDesc').attr("disabled",true);
			}else{
				$('#EmHisDrugDesc').attr("disabled",false);
			}
		}
		
		/// 辅助物
		if(this.name == "EmMaterial") {
			if (this.value == "N") {
				$("#EmMaterialDesc").val("");  ///  辅助物
				$('#EmMaterialDesc').attr("disabled",true);
			}else{
				$('#EmMaterialDesc').attr("disabled",false);
			}
		}
		
		/// 疼痛分级
		if(this.name == "EmPainFlag") {
			if (this.value == "Y") {
				$('a:contains("疼痛分级")').linkbutton('enable');
			}else{
				$('a:contains("疼痛分级")').linkbutton('disable');
			}
		}
		
		///号别
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

/// 初始化页面radio事件
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

/// 初始化加载字典数据
function initLoadEmPatLevDic(){
	
	///   既往史
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatChkHis",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatChkHis" value="'+ jsonObjArr[i].ID +'">'+ jsonObjArr[i].Desc +'</input>&nbsp;&nbsp;';
		}
		$('#EmPatChkHis').html(htmlstr);
	},'json',false)
	
	///   病人来源
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatSource",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatSource" value="'+ jsonObjArr[i].ID +'">'+ jsonObjArr[i].Desc +'</input>&nbsp;&nbsp;';
		}
		$('#EmPatSource').html(htmlstr);
	},'json',false)
	
	///   来诊方式
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

/// 读卡
function readCard(){
	
	$.messager.alert("提示","读卡");
	/// 卡类型ID
	var CardTypeRowId = "";
	var CardTypeValue = CardTypeComBo.getValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	if (myrtn==-200){ //卡无效
		$.messager.alert("提示","卡无效!");
		return;
	}
	
	var myary = myrtn.split("^");
	var rtn = myary[0];
	
	switch (rtn) {
		case "0":
			//卡有效
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$("#emcardno").val(CardNo);     /// 卡号
			$("#EmPatNo").val(PatientNo);   /// 登记号
			GetEmRegPatInfo();
			break;
		case "-200":
			//卡无效
			$.messager.alert("提示","卡无效!");
			break;
		case "-201":
			//现金
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$("#emcardno").val(CardNo);     /// 卡号
			$("#EmPatNo").val(PatientNo);   /// 登记号
			GetEmRegPatInfo();
			break;
		default:
	}
}

/// 隐藏病人列表
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

/// 登记
function register(){
	
	var emcardtype = $("#emcardtype").combobox("getText");         /// 卡号类型
	if (emcardtype == ""){
		$.messager.alert("提示","请先选择卡类型！");
		return;
	}
	
	var message = "";
	var CardTypeDr = $("#emcardtype").combobox("getValue");         /// 卡号类型
	var CardTypeDefArr = CardTypeDr.split("^");
	if (CardTypeDefArr[16] == "Handle"){
		message = "卡号不能为空,请先输入卡号！";
	}else{
		message = "卡号不能为空,请先读卡！";
	}
	
	var EmCardNo = $("#emcardno").val();         /// 卡号
	if (EmCardNo == ""){
		$.messager.alert("提示",message);
		return;
	}
	if (m_CardNoLength != EmCardNo.length){
		$.messager.alert("提示","卡号录入有误,请核实后再试！");
		return;
	}
	
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	if (!$("#emidentno").validatebox('isValid')){
		$.messager.alert("提示:","身份验证失败，请重新录入！");
		return;
	}
		
	var EmFamTel = $("#emfamtel").val();         /// 家庭电话
	if (!$("#emfamtel").validatebox('isValid')){
		$.messager.alert("提示:","电话验证失败，请重新录入！");
		return;
	}
	
	var EmPatName = $("#empatname").val();       /// 姓名
	if (EmPatName == ""){
		$.messager.confirm('提示', '姓名为空,确定要以无名氏身份进行登记吗?', function(result){  
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

///  登记
function regEmPatChkLv(EmPatModFlag){
	
	var PatientID = $("#PatientID").val();       /// PatientID
	var EmCardNoID = $("#EmCardNoID").val();     /// 卡号ID
	var EmCardNo = $("#emcardno").val();         /// 卡号
	
	var EmPatNo = $("#EmPatNo").val();           /// 登记号
	var EmPatName = $("#empatname").val();       /// 姓名
	var EmPatAge = $("#empatage").val();         /// 年龄
	var EmBorth = $("#emborth").datebox("getValue");        /// 出生日期
	
	var EmPatSex = $("#empatsex").combobox("getValue");     /// 性别
	var EmNation = $("#emnation").combobox("getValue");     /// 民族
	var EmCountry = $("#emcountry").combobox("getValue");   /// 国籍
	
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	var EmFamTel = $("#emfamtel").val();          /// 家庭电话
	
	var EmVisTime = $("#emvistime").datebox("getValue");   /// 来诊时间
	var EmAddress = $("#emaddress").val();        /// 家庭住址
	
	var EmCardType = $("#emcardtype").combobox("getValue"); /// 卡类型定义
	
	/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardType[0];

	/// 保存数据
	runClassMethod("web.DHCEMPatCheckLev","saveEmRegPat",{"PatListData":PatListData,"EmPatModFlag":EmPatModFlag},function(jsonString){
		
		var PatientID = jsonString;
		if (PatientID > 0){
			$.messager.alert("提示:","保存成功！");
			$("#dgEmPatList").datagrid("reload");
			$("#PatientID").val(PatientID);
			GetEmRegPatInfo(); /// 加载病人登记信息
		}else if (PatientID == "-12"){
			$.messager.alert("提示:","此卡已被占用,请录入新的卡信息！");
		}else{
			$.messager.alert("提示:","保存失败！");
		}
	})
}

/// 修改
function modify(){
	
	var PatientID = $("#PatientID").val();       /// PatientID
	if (PatientID == ""){
		$.messager.alert("提示:","请选择患者，再修改记录!");
		return;
	}
		
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	if (!$("#emidentno").validatebox('isValid')){
		$.messager.alert("提示:","身份验证失败，请重新录入！");
		return;
	}
		
	var EmFamTel = $("#emfamtel").val();         /// 家庭电话
	if (!$("#emfamtel").validatebox('isValid')){
		$.messager.alert("提示:","电话验证失败，请重新录入！");
		return;
	}
	
	regEmPatChkLv("M");
}

/// 确认分诊
function triage(){
	surePatEmTriage();
}

/// 病人信息列表  卡片样式
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
			htmlstr = htmlstr +'<h4 style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.NurseLevel+'级</span></h4>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 设置登记面板数据
function setRegPanelInfo(rowData){
		
	$("#EmCardNoID").val(rowData.CardNoID);   		/// 卡号ID
	$("#EmRegID").val(rowData.EmRegID);   		    /// 登记ID
	$("#emcardno").val(rowData.PatCardNo);   		/// 卡号
	$("#PatientID").val(rowData.PatientID);   		/// PatientID
	$("#Adm").val(rowData.Adm);
	
	$("#EmPCLvID").val(rowData.EmPCLvID);   		/// 分诊ID
	$("#EmPatNo").val(rowData.PatNo);   		    /// 登记号
	$("#empatname").val(rowData.PatName);   		/// 姓名
	$("#empatage").val(rowData.PatAge);        		/// 年龄
	
	$("#empatsex").combobox("setValue",rowData.sexId);    	 /// 性别
	$("#emnation").combobox("setValue",rowData.nationdr);    /// 民族
	$("#emcountry").combobox("setValue",rowData.countrydr);  /// 国籍
	$("#emborth").datebox("setValue",rowData.birthday);      /// 出生日期
	
	$("#emidentno").val(rowData.IdentNo);   /// 证件号码
	$("#emfamtel").val(rowData.PatTelH);    /// 家庭电话
	$("#emaddress").val(rowData.Address);   /// 家庭住址
	$("#emvistime").datebox("setValue",rowData.EmRegDate);   /// 来诊时间
	
	var EmPatLevWard = "红";
	if (rowData.NurseLevel == "3"){EmPatLevWard = "黄";}
	if (rowData.NurseLevel == "4"){EmPatLevWard = "绿";}
	if (rowData.NurseLevel == ""){EmPatLevWard = "未分";}
	
	var NurseLevel = "";
	if (rowData.NurseLevel == ""){ NurseLevel = "未分";}
	else{NurseLevel = rowData.NurseLevel;}
		
	var html = '<span class="word-green-deep font-18"><b>'+ rowData.PatName +'</b></span>';
		html = html + '<span class="padding-l25 word-green-deep">'+EmPatLevWard+'区</span>';
	    html = html + '<span class="padding-l25 fontsize-14 word-deep-gray">'+rowData.PatSex+'/'+rowData.PatAge+'/'+NurseLevel+'级/ID:'+rowData.PatNo+'/'+rowData.BillType+'/'+rowData.EmRegDate+" "+rowData.EmRegTime+'</span>';
	$(".item-label").html(html);
	
	GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  设置卡类型
	
	LoadEmPatCheckLevInfo(rowData.EmPCLvID);     ///  如果病人已经进行分级,显示分级数据
}

/// 获取病人信息
function GetEmRegPatInfo(){
	
	var EmPatNo = $("#EmPatNo").val();      /// 登记号;
	var PatientID = $("#PatientID").val();  /// 病人ID
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			setRegPanelInfo(rowData);
		}
	},'json',false)
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

///  查询登记病人列表
function QueryEmPatListByPatNo(EmPatNo){
	
	///  登记号补0
	var EmPatNo = GetWholePatNo(EmPatNo);
	
	$(".searchbox-text").val(EmPatNo);
	var params = EmPatNo;
	$("#dgEmPatList").datagrid("load",{"params":params});
}

///  登记号回车
function GetEmPatInfo(e){
	
	 if(e.keyCode == 13){
		var EmPatNo = $("#EmPatNo").val();
		///  登记号补0
		var EmPatNo = GetWholePatNo(EmPatNo);
		clearEmPanel();				///  清空
		$("#EmPatNo").val(EmPatNo);
		runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
			
			if (jsonString ==-1){
				$.messager.alert("提示:","当前卡无效,请重试！");
				return;

			}else{
				GetEmRegPatInfo();
			}
			
		},'text',false)
		
	}
}

///  卡号回车
function GetEmPatInfoByCardNo(e){

	if(e.keyCode == 13){
		var CardNo = $("#emcardno").val();
		var CardNoLen = CardNo.length;
		if (m_CardNoLength < CardNoLen){
			//$("#emcardno").focus().select();
			$.messager.alert("提示:","卡号输入错误,请重新录入！");
			return;
		}

		/// 卡号不足位数时补0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		
		clearEmPanel();				///  清空
		
		$("#emcardno").val(CardNo);

		///  根据卡号取登记号
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){

			if (jsonString ==-1){
				$.messager.alert("提示:","当前卡无效,请重试！");
				return;

			}else{
				EmPatNo = jsonString;
				$("#EmPatNo").val(EmPatNo);
			}
			
		},'text',false)

		GetEmRegPatInfo();
	}
}

///  效验时间栏录入数据合法性
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		$.messager.alert("提示:","请录入正确的时间格式！<span style='color:red;'>例如:18:23,请录入1823</span>");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("提示:","小时数不能大于23！");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("提示:","分钟数不能大于59！");
		return $('#'+ id).val();
	}
	
	return hour +":"+ itme;
}

/// 获取焦点后时间栏设置
function SetEmPcsTime(id){
	
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}

///  症状列表单击事件
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
		$('.panel-title:contains("症状")').html("症状:"+$("#SymptomLev").tree("getSelected").text);
	}
	
}

///  分区图标点击事件
function EmPatWardClick(){
	
	$('#dgEmPatList').datagrid('load',{'params':"^"+this.id});
}

/// 已分诊/未分诊
function QueryEmPatList(EmChkFlag){

	$('#dgEmPatList').datagrid('load',{'params':"^^"+EmChkFlag});
}

/// 预检分诊
function surePatEmTriage(){
	
	var EmRegID = $("#EmRegID").val();   			/// 登记ID
	if (EmRegID == ""){
		$.messager.alert("提示:","请登记后,再进行分诊操作！");
		return;
	}
	var PatientID = $("#PatientID").val();   		/// PatientID
	if (PatientID == ""){
		$.messager.alert("提示:","请选中病人后重试！");
		return;
	}
	var EmPCLvID = $("#EmPCLvID").val();   			/// 分诊ID
	
	var EmBatchNum = $("#EmBatchNum").val();        /// 总人数

	var EmAgainFlag = "";
	if ($("input[name='EmAgainFlag']:checked").length){
		EmAgainFlag = $("input[name='EmAgainFlag']:checked").val();    /// 重返标识
	}
	
	var EmBatchFlag = "";
	if ($("input[name='EmBatchFlag']:checked").length){
		EmBatchFlag = $("input[name='EmBatchFlag']:checked").val();    /// 成批就诊
	}
	
	if ((EmBatchFlag == "Y")&($("#EmBatchNum").val() == "")){
		$.messager.alert("提示:","请填写总人数!");                     /// 成批就诊为是,总人数不能为空
		return;
	}
	
	var EmScreenFlag = "";
	if ($("input[name='EmScreenFlag']:checked").length){
		EmScreenFlag = $("input[name='EmScreenFlag']:checked").val();   /// 筛查
	}
	
	var EmCombFlag = "";
	if ($("input[name='EmCombFlag']:checked").length){
		EmCombFlag = $("input[name='EmCombFlag']:checked").val();		/// 复合伤
	}
	
	var EmECGFlag = "";
	if ($("input[name='EmECGFlag']:checked").length){
		EmECGFlag = $("input[name='EmECGFlag']:checked").val();	    	/// ECG
	}

	var EmPoisonFlag = "";
	if ($("input[name='EmPoisonFlag']:checked").length){
		EmPoisonFlag = $("input[name='EmPoisonFlag']:checked").val();   /// 中毒
	}
	
	var EmOxygenFlag = "";
	if ($("input[name='EmOxygenFlag']:checked").length){
		EmOxygenFlag = $("input[name='EmOxygenFlag']:checked").val();   /// 是否吸氧
	}
	
	var EmPatAskFlag = "";
	if ($("input[name='EmPatAskFlag']:checked").length){
		EmPatAskFlag = $("input[name='EmPatAskFlag']:checked").val();   /// 已开假条
	}

	var EmPainFlag = "";
	if ($("input[name='EmPainFlag']:checked").length){
		EmPainFlag = $("input[name='EmPainFlag']:checked").val();       /// 疼痛级别
	}
	
	var EmPainRange = $("#EmPainRange").combobox('getValue');    /// 疼痛范围
	if ((EmPainFlag == "Y")&(EmPainRange == "")){
		$.messager.alert("提示:","疼痛范围不能为空！");
		return;
	}
	
	var EmPainTime = $("#EmPainTime").datetimebox('getValue');   /// 疼痛时间
	var EmPainDate = ""
	if (EmPainTime != ""){
		EmPainDate = EmPainTime.split(" ")[0];
		EmPainTime = EmPainTime.split(" ")[1];
	}
	if ((EmPainFlag == "Y")&(EmPainTime == "")){
		$.messager.alert("提示:","疼痛时间不能为空！");
		return;
	}
	
	var EmPainLev = $("#EmPainLev").val();                       /// 疼痛级别
	if ((EmPainFlag == "Y")&(EmPainLev == "")){
		$.messager.alert("提示:","疼痛级别不能为空！");
		return;
	}
	
	var EmAware = $("#EmAware").combobox("getValue");    	     /// 意识状态

	var EmUpdLevRe = $("#EmUpdLevRe").combobox("getValue");    	 /// 护士更改分级原因
	var EmLocID = $("#EmLocID").val()  //.combobox("getValue");    	     /// 分诊科室
	if (EmLocID == ""){
		$.messager.alert("提示:","请先选择分诊科室！");
		return;
	}
	
	//var EmChekkNo = $("#EmCheckNo").combobox("getValue");    	 /// 号别
	
	var EmNurseLevel = "";
	if ($('input[name="NurseLevel"]:checked').length){
		EmNurseLevel = $('input[name="NurseLevel"]:checked').val();  /// 护士分级
	}
	if (EmNurseLevel == ""){
		$.messager.alert("提示:","请先选择病人病情分级！");
		return;
	}
	
	var EmRecLevel = $("#EmRecLevel").combobox("getValue");        	 /// 推荐分级
	
	var EmArea = "";
	if ($('input[name="Area"]:checked').length){
		EmArea =  $('input[name="Area"]:checked').val();   			 /// 去向分区
	}
	
	/// 生命体征
	var EmPcsTime = $("#EmPcsTime").val();      ///  时间
	var EmPcsTime1 = $("#EmPcsTime1").val();    ///  时间
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  体温
	var EmPcsTemp1 = $("#EmPcsTemp1").val();    ///  体温
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  心率
	var EmPcsHeart1 = $("#EmPcsHeart1").val();  ///  心率
	var EmPcsPulse = $("#EmPcsPulse").val();    ///  脉搏
	var EmPcsPulse1 = $("#EmPcsPulse1").val();  ///  脉搏
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  血压(BP)收缩压
	var EmPcsSBP1 = $("#EmPcsSBP1").val();      ///  血压(BP)收缩压
	var EmPcsDBP = $("#EmPcsDBP").val();        ///  舒张压
	var EmPcsDBP1 = $("#EmPcsDBP1").val();       ///  舒张压
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  血氧饱合度SoP2
	var EmPcsSoP21 = $("#EmPcsSoP21").val();    ///  血氧饱合度SoP2
	var EmPatChkSign1 = EmPcsTime + RowDelim + EmPcsTemp + RowDelim + EmPcsHeart + RowDelim + EmPcsPulse + RowDelim + EmPcsSBP + RowDelim + EmPcsDBP + RowDelim + EmPcsSoP2;
	var EmPatChkSign2 = EmPcsTime1 + RowDelim + EmPcsTemp1 + RowDelim + EmPcsHeart1 + RowDelim + EmPcsPulse1 + RowDelim + EmPcsSBP1 + RowDelim + EmPcsDBP1 + RowDelim + EmPcsSoP21;
	var EmPatChkSign = EmPatChkSign1 +"||"+ EmPatChkSign2;
	
	/// 既往史
	var EmPatChkHis = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHis.push(this.value);
	})
	EmPatChkHis = EmPatChkHis.join(RowDelim);

    ///  病人来源
	var EmPatSource = "";
	if ($('input[name="EmPatSource"]:checked').length){
		EmPatSource = $('input[name="EmPatSource"]:checked').val();
	}

    ///  来诊方式
	var EmPatAdmWay = "";
	if ($('input[name="EmPatAdmWay"]:checked').length){
		EmPatAdmWay = $('input[name="EmPatAdmWay"]:checked').val();
	}
	
    ///  用药情况
	var EmHisDrug = "",EmHisDrugDesc = "";
	if ($('input[name="EmHisDrug"]:checked').length){
		EmHisDrug = $('input[name="EmHisDrug"]:checked').val();
	}
	if (EmHisDrug == "Y"){
		EmHisDrugDesc = $("#EmHisDrugDesc").val();
	}
	
	///   辅助物
	var EmMaterial = "",EmMaterialDesc = "";
	if ($('input[name="EmMaterial"]:checked').length){
		EmMaterial = $('input[name="EmMaterial"]:checked').val();
	}
	if (EmMaterial == "Y"){
		EmMaterialDesc = $("#EmMaterialDesc").val();
	}

	///  症状
	var EmSymDesc = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDesc.push(this.value +"!"+ $.trim($(this).parent().text()));
	})
	EmSymDesc = EmSymDesc.join("#");

	///  其他
	var EmOtherDesc = $("#EmOtherDesc").val();
	
	/// 已选号别
	var EmPatChkCare = [];
	$('input[name="SelEmCheckNo"]:checked').each(function(){
		EmPatChkCare.push(this.value);
	})
	EmPatChkCare = EmPatChkCare.join(RowDelim);
	if (EmPatChkCare == ""){
		$.messager.alert("提示:","请先选择号别！");
		return;
	}
	
	///就诊号
	var Adm = $("#Adm").val();
	/// 分诊护士^推荐分级^护士分级^护士分级原因^去向分区^分诊科室^重返标识^成批就诊^成批就诊人数^既往史
	/// 病人来源^来诊方式^意识状态^筛查^用药情况^用药情况描述^辅助物^辅助物描述
	/// 生命体征^症状表^症状描述^复合伤^ECG^中毒^疼痛^疼痛分级^疼痛范围^疼痛日期^疼痛时间^吸氧^请假^病人ID^登记ID^已挂号别
	var EmListData = LgUserID +"^"+ EmRecLevel +"^"+ EmNurseLevel +"^"+ EmUpdLevRe +"^"+ EmArea +"^"+ EmLocID +"^"+ EmAgainFlag +"^"+ EmBatchFlag +"^"+ EmBatchNum +"^"+ EmPatChkHis;
	var EmListData = EmListData +"^"+ EmPatSource +"^"+ EmPatAdmWay +"^"+ EmAware +"^"+ EmScreenFlag +"^"+ EmHisDrug +"^"+ EmHisDrugDesc +"^"+ EmMaterial +"^"+ EmMaterialDesc;
	var EmListData = EmListData +"^"+ EmPatChkSign +"^"+ "" +"^"+ EmSymDesc +"^"+ EmCombFlag +"^"+ EmECGFlag +"^"+ EmPoisonFlag +"^"+ EmPainFlag +"^"+ EmPainLev +"^"+ EmPainRange +"^"+ EmPainDate +"^"+ EmPainTime;
	var EmListData = EmListData +"^"+ EmOxygenFlag +"^"+ EmPatAskFlag +"^"+ EmOtherDesc +"^"+ PatientID +"^"+ EmRegID +"^"+ EmPatChkCare+"^"+Adm;

	/// 保存分诊数据
	runClassMethod("web.DHCEMPatCheckLev","saveEmPatCheckLev",{"EmPCLvID":EmPCLvID,"EmListData":EmListData},function(jsonString){
		
		var EmPCLvID = jsonString;
		if (EmPCLvID > 0){
			$.messager.alert("提示:","保存成功！");
			$("#EmPCLvID").val(EmPCLvID);   			/// 分诊ID
			$("#dgEmPatList").datagrid("reload");
			LoadEmPatCheckLevInfo(EmPCLvID);            /// 重新加载分诊信息
		}else{
			$.messager.alert("提示:","保存失败！");
		}
	})
}

///  如果病人已经进行分级,显示分级数据
function LoadEmPatCheckLevInfo(EmPCLvID){

	/// 提取分级数据
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheckLev",{"EmPCLvID":EmPCLvID},function(jsonString){
		//alert(jsonString)
		//return
		if (jsonString != null){
			var EmPatCheckLevObj = jsonString;
			
			///	 总人数
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			///  推荐分级
			$("#EmRecLevel").combobox('setValue',EmPatCheckLevObj.EmRecLevel);

			///  护士更改分级原因
			$("#EmUpdLevRe").combobox('setValue',EmPatCheckLevObj.EmUpdLevRe);

			///  分诊科室
			$("#EmLocID").val(EmPatCheckLevObj.EmLocID) //.combobox('setValue',EmPatCheckLevObj.EmLocID);

			///  意识状态
			$("#EmAware").combobox('setValue',EmPatCheckLevObj.EmAware);

			///  护士分级
			$('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').attr("checked",'checked'); 
			
			///  去向
			$('input[name="Area"][value="'+ EmPatCheckLevObj.Area +'"]').attr("checked",'checked'); 
			
			//alert(EmPatCheckLevObj.EmAgainFlag)
			///  设置复选框组
			/*
			$('input[type="checkbox"]').each(function(){
				if (this.name == "EmPatChkHis"){return;}
				$('[name="'+ this.name +'"][value="'+ EmPatCheckLevObj[this.name] +'"]').attr("checked",true);
			})
			*/
			//重返标识
			$('[name="EmAgainFlag"][value="'+ EmPatCheckLevObj.EmAgainFlag +'"]').attr("checked",true);
			//成批就诊
			$('[name="EmBatchFlag"][value="'+ EmPatCheckLevObj.EmBatchFlag +'"]').attr("checked",true);
			///  病人来源
			$('[name="EmPatSource"][value="'+ EmPatCheckLevObj.EmPatSource +'"]').attr("checked",true);
			
			///  来诊方式
			$('[name="EmPatAdmWay"][value="'+ EmPatCheckLevObj.EmPatAdmWay +'"]').attr("checked",true);
			
			///  中毒
			$('[name="EmPoisonFlag"][value="'+ EmPatCheckLevObj.EmPoisonFlag +'"]').attr("checked",true);

			///  是否吸氧
			$('[name="EmOxygenFlag"][value="'+ EmPatCheckLevObj.EmOxygenFlag +'"]').attr("checked",true);

			///  筛查
			$('[name="EmScreenFlag"][value="'+ EmPatCheckLevObj.EmScreenFlag +'"]').attr("checked",true);

			///  复合伤
			$('[name="EmCombFlag"][value="'+ EmPatCheckLevObj.EmCombFlag +'"]').attr("checked",true);

			///  ECG
			$('[name="EmECGFlag"][value="'+ EmPatCheckLevObj.EmECGFlag +'"]').attr("checked",true);

			///  用药情况
			$('[name="EmHisDrug"][value="'+ EmPatCheckLevObj.EmHisDrug +'"]').attr("checked",true);

			///  辅助物
			$('[name="EmMaterial"][value="'+ EmPatCheckLevObj.EmMaterial +'"]').attr("checked",true);

			///  疼痛分级
			$('[name="EmPainFlag"][value="'+ EmPatCheckLevObj.EmPainFlag +'"]').attr("checked",true);

			///  已开假条
			$('[name="EmPatAskFlag"][value="'+ EmPatCheckLevObj.EmPatAskFlag +'"]').attr("checked",true);
			
			
			///	 成批就诊			
			if (EmPatCheckLevObj.EmBatchNum != "") {
				$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
				$('#EmBatchNum').attr("disabled",false);
			}
															
			///	 用药情况
			if (EmPatCheckLevObj.EmHisDrugDesc != "") {
				$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrugDesc);
				$('#EmHisDrugDesc').attr("disabled",false);
			}
			
			///	 辅助物
			if (EmPatCheckLevObj.EmMaterialDesc != "") {
				$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterialDesc);
				$('#EmMaterialDesc').attr("disabled",false);
			}
						
			///	 其他
			$("#EmOtherDesc").val(EmPatCheckLevObj.EmOtherDesc);
			
			///  症状
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

			///	 既往史
			var EmPatChkHisArr = EmPatCheckLevObj.EmPatChkHis.split("#");
			for(var i=0;i<EmPatChkHisArr.length;i++){
				$('[name="EmPatChkHis"][value="'+ EmPatChkHisArr[i] +'"]').attr("checked",true);
			}
			
			///  预检号别
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
						
			///	 疼痛范围
			var EmPainVal = [];
			$("#EmPainRange").combobox('setValue',EmPatCheckLevObj.EmPainRange);
			if (EmPatCheckLevObj.EmPainRange != "") {
				EmPainVal.push("疼痛范围:"+EmPatCheckLevObj.EmPainRangeDesc);
			}
			
			///	 疼痛指数
			$("#EmPainLev").val(EmPatCheckLevObj.EmPainLev);
			if (EmPatCheckLevObj.EmPainTime != "") {
				EmPainVal.push("疼痛分级:"+EmPatCheckLevObj.EmPainLev+"级");
			}
			
			///	 疼痛时间
			$("#EmPainTime").datetimebox('setValue',EmPatCheckLevObj.EmPainTime);
			if (EmPatCheckLevObj.EmPainTime != "") {
				EmPainVal.push("疼痛时间:"+EmPatCheckLevObj.EmPainTime);
			}
			EmPainVal = EmPainVal.join("，");
	
			$("#EmPainDesc").val(EmPainVal);
			
			/// 设置 数字评分法(VAS)指标位置
			$("#slider").slider("setValue",EmPatCheckLevObj.EmPainLev);
			/// 疼痛面部图片选中
			//var $li = $(".face-regin li:eq('" +EmPatCheckLevObj.EmPainLev+ "')");
			//$li.find("span").css({"color":"#ff7a00"});
			//$li.siblings().find("span").css({"color":""});
			
			///	 生命体征
			var flag="";
			var EmPatChkSignArr = EmPatCheckLevObj.EmPatChkSign.split("#");
			for(var i=0;i<EmPatChkSignArr.length;i++){
				if (i!=0){flag=1};
				var EmPcsArr = EmPatChkSignArr[i].split("@");
				$("#EmPcsTime"+flag).val(EmPcsArr[0]);   ///  时间
				$("#EmPcsTemp"+flag).val(EmPcsArr[1]);   ///  体温
				$("#EmPcsHeart"+flag).val(EmPcsArr[2]);  ///  心率
				$("#EmPcsPulse"+flag).val(EmPcsArr[3]);  ///  脉搏
				$("#EmPcsSBP"+flag).val(EmPcsArr[4]);    ///  血压(BP)收缩压
				$("#EmPcsDBP"+flag).val(EmPcsArr[5]);    ///  舒张压
				$("#EmPcsSoP2"+flag).val(EmPcsArr[6]);   ///  血氧饱合度SoP2
			}	

		}else{
			$('#EmBatchNum').attr("disabled",true);	
		}
	})
}

///	 清空
function clearEmPanel(){
	
	/// 复选框
	$('input[type="checkbox"]').attr("checked",false);
	
	/// 单选
	$('input[type="radio"]').attr("checked",false);
	
	/// 文本框
	$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})

	/// Combobox
	$('input.combobox-f').each(function(){
		if(this.id == "emcardtype"){return;}
		$("#"+ this.id).combobox("setValue","");
	})
	
	/// 日期
	$('input.datebox-f').each(function(){
		if(this.id == "emcardtype"){return;}
		$("#"+ this.id).datebox("setValue","");
	})
	
	/// 预检号别
	$('#SelEmCheckNo').html("");
	
	/// 症状
	$("#EmSymFeild").html("");
}

///  疼痛分级窗口
function EmPatPainLevWin(){
	
	var EmPainFlag = "";
	if ($("input[name='EmPainFlag']:checked").length){
		EmPainFlag = $("input[name='EmPainFlag']:checked").val();       /// 疼痛级别
	}
	if (EmPainFlag != "Y"){
		return;
	}
	
	if($('#EmPatPainLevWin').is(":hidden")){
		$('#EmPatPainLevWin').window('open');
		return;}  //窗体处在打开状态,退出
		
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('疼痛分级', 'EmPatPainLevWin', '850', '400', option).Init();
}

///  疼痛分级笑脸按钮事件
function EmPainFaceEvt(){
	
	$(this).find("span").css({"color":"#ff7a00"});
	$(this).siblings().find("span").css({"color":""});
	
	/// 设置疼痛分级项目值
	$("#EmPainLev").val($(this).index() * 2);
	
	/// 设置 数字评分法（VAS） 指标位置
	$("#slider").slider("setValue", $(this).index() * 2);
}

///  取消
function cancelEmPainWin(){
	
	$('#EmPatPainLevWin').window('close');
}

///  确定
function sureEmPainWin(){
	
	///  疼痛范围
	var EmPainRange = $("#EmPainRange").combobox('getText');
	if (EmPainRange == ""){
		$.messager.alert("提示:","疼痛范围不能为空！");
		return;
	}
	///  疼痛时间
	var EmPainTime = $("#EmPainTime").datetimebox('getValue');
	if (EmPainTime == ""){
		$.messager.alert("提示:","疼痛时间不能为空！");
		return;
	}
	///  疼痛指数
	var EmPainLev = $("#EmPainLev").val();
	if (EmPainLev == ""){
		$.messager.alert("提示:","疼痛指数不能为空！");
		return;
	}
	$("#EmPainDesc").val("疼痛范围:"+EmPainRange+", 疼痛时间:"+EmPainTime+", 疼痛分级:"+EmPainLev+"级");
	$('#EmPatPainLevWin').window('close');
}

/// 初始化症状树
function initSymptomLevTree(){

	var url = LINK_CSP+'?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmPatSymptomLev';
	var option = {
        onClick:function(node, checked){
	        GetSymptomFeild(node.id)
	    }
	};
	new CusTreeUX("SymptomLev", url, option).Init();
}

///  加载症状知识库
function GetSymptomFeild(EmSymLevId){
	
	var htmlstr = "";
	runClassMethod("web.DHCEMPatCheckLevQuery","GetSymptomFeild",{"EmSymLevId":EmSymLevId},function(jsonString){
		var jsonObjArr = jsonString;

		for (var i=0; i<jsonObjArr.length; i++){
			//htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].EmSymFId +'">'+ jsonObjArr[i].EmSymFDesc +'</span></li>';
			htmlstr = htmlstr + '<button class="button" id="'+ jsonObjArr[i].EmSymFId +'" type="button">'+ jsonObjArr[i].EmSymFDesc +'</button>';
		}
		//$('.item—list ul').html(htmlstr);
		$('#symList').html(htmlstr);
	},'json',false)
}

/// 获取病人对应卡类型数据
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

///  计算推荐分级
///  $('input[name="EmPcs1"],input[name="EmPcs2"]')
function setEmRecLevel(){

	var EmPcsFlag = 1;
	var EmPcsListData = "";
	var EmPcsListData2 = "";
	
	/// 意识状态
	var EmAware = $("#EmAware").combobox("getValue");
	
	/// 既往史
	var EmPatChkHis = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHis.push(this.value);
	})
	EmPatChkHis = EmPatChkHis.join("$$");
	//
	EmPainLev=$("#EmPainLev").val();
	//
	///  症状
	var EmSymDesc = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDesc.push(this.value);
	})
	EmSymDesc = EmSymDesc.join("$$");
	
	/// (2)生命数据
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  体温
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  心率
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  血压(BP)收缩压
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  血氧饱合度SoP2
	if ((EmPcsTemp!="")||(EmPcsHeart!="")||(EmPcsSBP!="")||(EmPcsSoP2!="")||(EmPainLev!="")||(EmSymDesc!="")){
		EmPcsListData = EmPcsSBP +"^"+ EmPcsSoP2 +"^"+ EmPcsHeart +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp+"^"+EmSymDesc+"^"+EmPainLev;
	}
	var EmPcsTemp1 = $("#EmPcsTemp1").val();    ///  体温
	var EmPcsHeart1 = $("#EmPcsHeart1").val();  ///  心率
	var EmPcsSBP1 = $("#EmPcsSBP1").val();      ///  血压(BP)收缩压
	var EmPcsSoP21 = $("#EmPcsSoP21").val();    ///  血氧饱合度SoP2
	if ((EmPcsTemp1!="")||(EmPcsHeart1!="")||(EmPcsSBP1!="")||(EmPcsSoP21!="")||(EmPainLev!="")||(EmSymDesc!="")){
		EmPcsListData2 = EmPcsSBP1 +"^"+ EmPcsSoP21 +"^"+ EmPcsHeart1 +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp1+"^"+EmSymDesc+"^"+EmPainLev;
	}

	/// 系统推荐分级
	if((EmPcsListData != "")||(EmPcsListData2!="")){
		if(EmPcsListData2!=""){EmPcsListData=EmPcsListData2}
		GetEmRecLevel(EmPcsListData);
	}
}

///  获取系统推荐分级
function GetEmRecLevel(EmPcsListData){
	
	runClassMethod("web.DHCEMCalPatLevel","calPatLevel",{"EmPCLvID":EmPcsListData},function(jsonString){
		
		if (jsonString != null){
			var EmRecLevel = jsonString;
			///  推荐分级
			$("#EmRecLevel").combobox('setValue',EmRecLevel);
		}
	},'',false)
}

///  设置出生日期
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
	$("#emborth").datebox("setValue",d);      /// 出生日期
	$("#empatage").val(setEmPatAges(d));      /// 年龄
}

///  设置年龄
function setEmPatAges(dd){   
	var r = dd.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);     
	if(r == null){
		return "";
	}     
	var d = new Date(r[1],r[3]-1,r[4]);     
	if (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]){   
		var Y = new Date().getFullYear();   
		return (Y-r[1])+"岁";   
	}   
	return "";   
}



/// JQuery 初始化页面
$(function(){ initPageDefault(); })

