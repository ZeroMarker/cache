var EmChkFlag=""; ///  已分诊 / 未分诊 2016-09-20 congyue
var EmBtnFlag=""; ///  分区按钮事件 2016-09-20 congyue
/// 新版登记注册和预检分诊类JS  bianshuai 2016-04-25
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var arr=[],gcsArr=[],htmlStr1="",htmlStr2="",gcsArr2=[],aisArr=[],aisArr2=[],gcsStr="",gcsStr2="",aisStr="",aisStr2="";  //gcsStr,aisStr 用于保存上次分级时候选中的元素
var eascapeFlag=0;
var defaultCardTypeDr;
var num=0,EPnum=0    //yuliping 格拉斯哥总分，创伤总分
var m_CardNoLength = 0;symItemListClickNew
var m_CCMRowID = "" ;
var SecurityNO = ""; /// 安全码 bianshuai 2017-03-30
var EmCardNoFlag = 0;
var LgLocID = session['LOGON.CTLOCID'];
var TmpNurLev = "";  /// 护士分级
var EmNurReaID = ""; /// 护士修改分级原因

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
	
	//回车键跳入下一元素 2016-09-19 congyue add ggm 2016-11-24
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
	
	//绿色通道时效启用 zhouxin
	if(GreenEffectSwitch>0){
		$("#greenHours").val(GreenEffectSwitch)
		//是否可以修改时长
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
	/// 第1、3种模式：转诊不显示； bianshuai 2017-02-25
	/// 以下都是查到td标签的父元素tr进行隐藏
	if (PatRegType == 1){
		/// 隐藏分诊科室
		$("td:contains('分诊科室')").parent().css("display","none");
		/// 隐藏转诊科室
		$("td:contains('转诊科室')").parent().css("display","none");
		/// 隐藏已挂号
		$("td.input-label-t3:contains('已挂号')").parent().css("display","none");
		/// 默认勾选未分诊
		$('input[name="EmCkLvFlag"][value="N"]').attr("checked",true);
	}
	if (PatRegType == 2){
		/// 隐藏已分诊
		$("td.input-label-t3:contains('已分诊')").parent().css("display","none");
		/// 隐藏已挂号别
		$("td:contains('已挂号别')").parent().css("display","none");
		/// 默认勾选未挂号
		$('input[name="EmEpiFlag"][value="N"]').attr("checked",true);
	}
	if (PatRegType == 3){
		/// 隐藏转诊科室
		$("td:contains('转诊科室')").parent().css("display","none");
		/// 隐藏已挂号
		$("td.input-label-t3:contains('已挂号')").parent().css("display","none");
		/// 默认勾选未分诊
		$('input[name="EmCkLvFlag"][value="N"]').attr("checked",true);
	}
	if (PatRegType == 4){
		/// 隐藏已分诊
		$("td.input-label-t3:contains('已分诊')").parent().css("display","none");
		/// 隐藏已挂号别
		$("td:contains('已挂号别')").parent().css("display","none");
		/// 默认勾选未挂号
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
/// 页面Combobox初始定义
function initCombobox(){
	$('#EmLocID').combobox({disabled:false})
	$('#EmCheckNo').combobox({disabled:false})
	$('#EmToLocID').combobox({disabled:true})

	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	
	/// 卡类型  卡类型的combobox的onSelect事件。
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
	var url = uniturl+"jsonEmDocUpdReson&HospID="+LgHospID+"&Type=Nur";
	var option = {
		panelHeight:"auto"
		}
	new ListCombobox("EmUpdLevRe",url,"",option).init();
	
	
	/// 分诊科室
	var url = uniturl+"jsonGetEmPatLoc";
	var option = {
        onSelect:function(option){
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+option.value;
	        $("#EmCheckNo").combobox('reload', url);
	        $("#EmCheckNo").combobox('setValue',"");
	    },
	    onLoadSuccess: function () { //数据加载完毕事件
            var data = $('#EmLocID').combobox('getData');
             if (data.length > 0) {
	            if(($('#EmToLocID').combobox('getValue')==0)){
                	//$("#EmLocID").combobox('select', data[0].value);
	            }
            } 
        }
	};
	new ListCombobox("EmLocID",url,'',option).init();
	
	/// 抢救病区
	var url = uniturl+"jsonWard&HospID="+LgHospID;
	var option = {
		panelHeight:"auto"
		}
	new ListCombobox("EmPatWard",url,'',option).init();
	$('#EmPatWard').combobox({disabled:true});  /// 初始化时，抢救病区不可用
	
	/// 号别
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
	//转向科室 
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
	/// 推荐分级
	var EmRecLevelArr = [{"value":"1","text":'1级'}, {"value":"2","text":'2级'}, 
		{"value":"3","text":'3级'}, {"value":"4","text":'4级'}];
	var option = {
		panelHeight:"auto"
		}
	new ListCombobox("EmRecLevel",'',EmRecLevelArr,option).init();
		
	/// 疼痛范围
	var EmPainRangeArr = [{"value":"1","text":'中枢'}, {"value":"2","text":'外周'}];
	new ListCombobox("EmPainRange",'',EmPainRangeArr).init();
	
	$("#slider" ).slider({
		step:1,
		onSlideEnd:function(value){
			/// 设置疼痛分级项目值
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
	
	///  来诊时间
	$("#emvistime").datebox("setValue",formatDate(0));
	
	/// 意识状态
	var url = uniturl+"jsonPatAWare&HospID="+LgHospID;
	var option = {
		panelHeight:"auto",
		onSelect:function(record){
	        setEmRecLevel();
	        }
		}
	new ListCombobox("EmAware",url,'',option).init(); 

	//开始日期 congyue 2016-08-30
	$('#stadate').datebox("setValue","");
	
	//结束日期 congyue 2016-08-30
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
	
	//年龄
	$("#empatage").on('change',function(){

		date=$(this).val();
		if(date.trim()==""){
			return;
		}
		now=new Date();
		if(parseInt(date)<0){
			$(this).val("")
			$.messager.alert("提示:","年龄不能为负！");
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
			$("#emborth").val(nowdate);
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
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// 出生年龄在24小时至1个月，显示天，如19天
		if(date.indexOf("天") != "-1"){
			dateArr=date.split("天")
			newtimems=now.getTime()-(dateArr[0]*24*60*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// 出生年龄在1小时至24小时之间，显示小时，如4小时；
		if(date.indexOf("小时")>=0){
			dateArr=date.split("小时")
			newtimems=now.getTime()-(dateArr[0]*60*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// 出生年龄在1小时以内， 显示分钟，如36分钟；
		if(date.indexOf("分钟")>=0){
			dateArr=date.split("分钟")
			newtimems=now.getTime()-(dateArr[0]*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		if(parseInt(date)>120){
			$.messager.alert("提示:","年龄不能大于120！");
			$(this).val("")
			return;
		}
		
		/// 默认数字按照岁来处理
		new Date(now.setMonth((new Date().getMonth()-$(this).val()*12)));
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#emborth").val(nowdate);
	})

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
	
	var Params = "^^N^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	
	$('#dgEmPatList').datagrid({
		
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryEmRegPatlist&params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        clearEmPanel();				  ///  清空
	        setRegPanelInfo(rowData,1);   ///  设置登记面板数据
	        if(rowData.QueDoc){
		      $("#queDoc").html(rowData.QueDoc)  
		    }
		    if (typeof rowData.uniqueID != "undefined"){
			    /// 取登记队列
				if (rowData.uniqueID == "A"){
					$("td:contains('已挂号别')").parent().css("display","none");
					$("td:contains('分诊科室')").parent().css("display","");
				}
				/// 取挂号队列
				if (rowData.uniqueID == "B"){
				    $("td:contains('分诊科室')").parent().css("display","none");
				    $("td:contains('已挂号别')").parent().css("display","");
				}
		    }
	    },
		onLoadSuccess:function(data){
		//clearEmPanel();				///  清空
            	//setRegPanelInfo(data.rows[0],1);   ///  设置登记面板数据
	    if($('#regNo').val()=="OK"){
		setRegPanelInfo(data.rows[0],1);   ///  设置登记面板数据
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
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            ///  设置分诊区域
            if (typeof data.EmPatLevTotal == "undefined"){
				data.EmPatLevTotal = "0";data.EmPatLevCnt1 = "0";data.EmPatLevCnt2 = "0";data.EmPatLevCnt3 = "0";
	         }
        	$("#tb .btn-success").html(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$("#tb .btn-warning").html(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$("#tb .btn-danger").html(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);
			//$('.panel-title:contains("未分诊")').html("病人列表(未分诊:"+data.EmPatLevNotCnt+"人)");
		}
	});
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false});  
}

/// 页面 Button 绑定事件
function initBlButton(){
	///  打印
	//$('a:contains("打印")').bind("click",LevPrintout);
	$('#print').on("click",LevPrintout); 
	///  读卡
	$('a:contains("读卡")').bind("click",readCard);
	
	///  登记
	$('a:contains("登记")').bind("click",register);
	
	///读身份证
	$('a:contains("读身份证")').bind("click",readPatID);
	
	///  修改
	$('a:contains("修改")').bind("click",modify);
	
	///  确认分诊
	$('#triage').on("click",triage); 
	
	///  清空
	$('a:contains("清屏")').bind("click",clearEmPanel); 
	
    ///  登记号查询
    /*$('#search').searchbox({ 
	   searcher:function(value,name){
		   QueryEmPatListByPatNo(value);
	   }
    });
    ;*/
	 $('#search').searchbox({ 
	   searcher:function(value,name){
		   clearEmPanel();
		   clearCheckBox(); // 清空复选框 bianshuai 2018-03-09
		   QueryEmPatListByPatNo(value);
	   }
    })
    $('#Regno').bind('keypress',GetCardPatInfo);
	///	 登记号
	$('#EmPatNo').bind('keypress',GetEmPatInfo);
	
	///  卡号
	$('#emcardno').bind('keypress',GetEmPatInfoByCardNo);
	
	///	 疼痛分级
	$('a:contains("疼痛分级")').bind("click",EmPatPainLevWin);
	
	///	 创伤评分
	$('a:contains("创伤分级")').bind("click",EmPatHurtLevWin);
	
	///格拉斯哥分级
	$('a:contains("格拉斯哥分级")').bind("click",GlasgowLevWin);
	
	///  疼痛分级笑脸按钮事件
	$(".face-regin li").bind("click",EmPainFaceEvt);
	
	///  取消
	$('#cancelEmPain').bind("click",cancelEmPainWin);
	
	///  创伤评分取消
	$('#cancelEmHurt').bind("click",cancelEmHurtWin);
	
	///  取消
	$('#cancelEmGls').bind("click",cancelGlasgowLevWin);
	
	///  确认
	$('#sureEmPain').bind("click",sureEmPainWin);
	
	///  创伤评分保存
	$('#sureEmHurt').bind("click",sureEmHurtWin);
	
	///  确认
	$('#sureEmGls').bind("click",sureGlasgowLevWin);
	
	///  格拉斯哥确认
	//$('#Glasgow_Btn_Qr').bind("click",sureGlasgowLevWin);
	
	///  症状
	//$('.item—list li span').live("click",symItemListClick);
	
	$("#symList .buttonsymptoms").live("click",symItemListClickNew);
	/// 身份证
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
	$('#emborth').bind('keydown',setBrith);
	
	$('#emborth').blur(blurBrith);
	
	/// 病人姓名
	$('#empatname').keydown(function(e){
		if(e.keyCode==13){
			$('#emborth').focus();
		}
	});
	
	///  疼痛日期
	$('#EmPainTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

	//日期查询 2016-08-26 congyue
	$('[title^="日期查询"]').bind("click",function(e){
		$('.datetime-search').each(function(){
	   		if ($(this).css('display')=='none'){
		   		$(this).css('display','block');
		   		$('#stadate').datebox("setValue",formatDate(0));
		   		$('#enddate').datebox("setValue",formatDate(0));
				QueryEmPatListByTime();
		   	}else{
			   	$(this).css('display','none');
				$('#stadate').datebox("setValue","");  //开始日期 2016-09-19 congyue
				$('#enddate').datebox("setValue","");  //结束日期 2016-09-19 congyue
				QueryEmPatListByTime();
			 }    
	   });
	});

	///  取消
	$('#nurcancel').bind("click",cancelNurLevWin);
	
	///  确认
	$('#nursure').bind("click",surePatEmLev);
}

/// 初始化页面卡类型定义
function initCardTypeCombobox(){
	
	/// 获取默认卡类型
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
        m_CCMRowID = CardTypeDefArr[14];
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
		
		///六大病种可以多选
		if (this.name == "EmPatSixSick") {
			return;
		}
		
		///  号别
		if (this.name == "SelEmCheckNo") {
			$(this).parent().remove();
			
			if($.trim($("#SelEmCheckNo").html())==""){
				//$('#EmToLocID').combobox({disabled:false})	
			}else{
				//$('#EmToLocID').combobox({disabled:true})
			}
			return;
		}
		///  症状
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
				$("#EmSymFeildTitle").html("病人主诉...")	
			}
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
		/// 格拉斯哥分级
		if((this.name == "GlasgowFlag")&(this.value == "N")) {
			$("#GlasgowDesc").val("");  ///  格拉斯哥分级描述
			htmlStr2="";
			gcsStr="";
			//$("#EmPainRange").combobox('setValue',"");    ///  疼痛范围
			//$("#EmPainTime").datetimebox('setValue',"");  ///  疼痛时间
			//$("#EmPainLev").val("");  ///  疼痛指数
		}
		/// 创伤分级
		if((this.name == "AISActiveFlag")&(this.value == "N")) {
			$("#EmHurtDesc").val("");  ///  格拉斯哥分级描述
			htmlStr1="";
			aisStr="";
			//$("#EmPainRange").combobox('setValue',"");    ///  疼痛范围
			//$("#EmPainTime").datetimebox('setValue',"");  ///  疼痛时间
			//$("#EmPainLev").val("");  ///  疼痛指数
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
		/// 创伤评分
		if(this.name == "AISActiveFlag") {
			if (this.value == "Y") {
				$('a:contains("创伤分级")').linkbutton('enable');
			}else{
				$('a:contains("创伤分级")').linkbutton('disable');
			}
		}
		/// 格拉斯哥昏迷分级
		if(this.name == "GlasgowFlag") {
			if (this.value == "Y") {
				$('a:contains("格拉斯哥分级")').linkbutton('enable');
			}else{
				$('a:contains("格拉斯哥分级")').linkbutton('disable');
			}
		}
		///号别
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

		/// 已分诊、未分诊
		if(this.name == "EmCkLvFlag") {
			var EmCkLvFlag = "";
			if ($("input[name='EmCkLvFlag']:checked").length){
				EmCkLvFlag = $("input[name='EmCkLvFlag']:checked").val();
			}
			
			QueryEmPatList(EmCkLvFlag); /// 调用查询列表
		}
		
		/// 已挂号、未挂号
		if(this.name == "EmEpiFlag") {
			var EmEpiFlag = "";
			if ($("input[name='EmEpiFlag']:checked").length){
				EmEpiFlag = $("input[name='EmEpiFlag']:checked").val();
			}
			QueryEmPatList(EmEpiFlag); /// 调用查询列表
		}
		
		/// 转诊是否可用
		if(this.name == "EmToLocFlag") {
			if($("input[name='EmToLocFlag']").is(':checked')) {
				$('#EmLocID').combobox('setValue',"");    	         /// 分诊科室
				$('#EmLocID').combobox({disabled:true});
				$('#EmCheckNo').combobox({disabled:true});
				$('#EmToLocID').combobox('enable');
				$("input[name='EmGreenFlag']").attr("disabled",true); /// 绿色通道
			}else{
				$('#EmLocID').combobox('enable');
				$('#EmCheckNo').combobox('enable');
				$('#EmToLocID').combobox({disabled:true});
				$("input[name='EmGreenFlag']").attr("disabled",false); /// 绿色通道
			}
		}
	});
}

/// 初始化页面radio事件
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
/// 初始化加载字典数据
function initLoadEmPatLevDic(){
	
	///  特殊人群 2016-09-05 丛悦
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatChkType",{"":""},function(jsonString){
		var jsonObjArr = jsonString;
		var htmlstr = "";
		for (var i=1; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + ((i % 10 == 0)&(i != 0)? "<br>" : "");
			htmlstr = htmlstr + '<input type="checkbox" name="EmPatChkType" value="'+ jsonObjArr[i].ID +'"><span>'+ jsonObjArr[i].Desc +'</span></input>&nbsp;&nbsp;';
		}
		$('#EmPatChkType').html(htmlstr);
	},'json',false)
	
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
	
	///   六大病种
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

/// 读取身份证
function readPatID(){
	
	try{
		var myInfo=DHCWCOM_PersonInfoRead("1");
	}catch(e){
		alert(e.message)   
	}
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		//str="<IDRoot><Age>24</Age><Name>王伟</Name><Sex>男</Sex><NationDesc>01</NationDesc><Birth>1988-08-19</Birth><Address>山东省东营市东营区北一路739号</Address><CredNo>37078419880819641X</CredNo></IDRoot>"
		var str=myary[1];
		var result = $.parseXML(str);
		var EmIdentno = $(result).find('CredNo').text();
		if (GetPatientID(EmIdentno) != ""){
			setEmPatBaseInfo(EmIdentno);
		}else{
			$("#empatname").val($(result).find('Name').text());
			$("#emidentno").val($(result).find('CredNo').text());
			/// 设置出生日期
			var mybirth = $(result).find('Birth').text();
			if (mybirth != ""){
				if (mybirth.length==8){
					var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8);
				}
				var mybirth = GetSysDateToHtml(mybirth);  /// 根据His系统配置转换日期格式
				$('#emborth').val(mybirth);
			}
			$("#empatage").val($(result).find('Age').text());
			$("#empatname").val($(result).find('Name').text());
			$("#emaddress").val($(result).find('Address').text());
			/// 设置民族
			var PatNation = $(result).find('NationDesc').text();
			if (PatNation != ""){
				$("#emnation").combobox('setValue',TransNationToID(PatNation));
			}
			/// 设置性别
			var PatSex = $(result).find('Sex').text();
			if (parseInt(PatSex) % 2 == 1) {
				$("#empatsex").combobox("setValue",TransPatSexToID("男"));
			}else{ 
				$("#empatsex").combobox("setValue",TransPatSexToID("女"));
			}
		}
		
		//使用读取得照片数据文件 2018-03-17 bianshuai
		var src = ""
		if ($(result).find('PhotoInfo').text() != ""){
			src="data:image/png;base64," + $(result).find('PhotoInfo').text();
			$("#imgPic").attr("src",src);
		}
		
	}
}

/// 读卡
function readCard(){
	
	/*  留着老项目备用
	
	/// 卡类型ID
	var CardTypeRowId = "";
	var CardTypeValue = $("#emcardtype").combobox("getValue");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardTypeValue);
	if (myrtn==-200){ //卡无效
		$.messager.alert("提示","卡无效-1!");
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
	}*/
	ReadMagCard_Click();
	
}

// 读空白卡 QQA 
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
	   			$.messager.alert("提示","卡无效!");
	   		}
   			
			if ((myary[0]=="0")&&(myary[1]!="undefined")){
				//$("#EmPatNo").val(myDataArr[2]);      /// 登记号;
				//$("#PatientID").val(myDataArr[3]);  /// 病人ID
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
	
	var myCardNo = $('#emcardno').val();   //卡号
	 
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
		 'CardTypeDR':CardTypeRowId,   //全局变量
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
								$("#EmPatNo").val(myDataArr[2]);      /// 登记号;
								$("#PatientID").val(myDataArr[3]);  /// 病人ID
								GetEmRegPatInfo();
								return;
						}
					},"text"
				)
			}else{
				clearEmPanel();   //清空卡号信息
				
				switch(myary[0]){
					case "-340":
						$.messager.alert("提示","发卡时,此卡已经有对应的登记号了,不能在新增了");
						break;
					case "-350":
						$.messager.alert("提示","此卡已经使用,不能重复发卡!");
						break;
					case "-351":
						$.messager.alert("提示","此卡已经被挂失,不能使用!");
						break;
					case "-352":
						$.messager.alert("提示","此卡已经被作废?不能使用!");
						break;
					case "-356":
						$.messager.alert("提示","发卡时,配置要求新增卡记录,但是此卡数据被预先生成错误!");
						break;
					case "-357":
						$.messager.alert("提示","发卡时,配置要求更新卡记录,但是此卡数据没有预先生成!");
						break;
					case "-358":
						$.messager.alert("提示","发卡时,此卡已经有对应的登记号了,不能在新增了");
						break;
					default:
						$.messager.alert("Error Code:" +myary[0]);
						break;
				}
				
					
			}
			
		},"text",false
	)
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
	if (!checkSex())return;	
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
	var EmBorth = $("#emborth").val();        /// 出生日期
	
	var EmPatSex = $("#empatsex").combobox("getValue");     /// 性别
	var EmNation = $("#emnation").combobox("getValue");     /// 民族
	var EmCountry = $("#emcountry").combobox("getValue");   /// 国籍
	
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	var EmFamTel = $("#emfamtel").val();          /// 家庭电话
	
	var EmVisTime = $("#emvistime").datebox("getValue");   /// 来诊时间
	var EmAddress = $("#emaddress").val();        /// 家庭住址
	
	var EmCardType = $("#emcardtype").combobox("getValue"); /// 卡类型定义
	var empatage=$("#empatage").val()
	/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardType[0]+"^"+empatage;
	/// Session
	var LgParams = LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	/// 保存数据
	runClassMethod("web.DHCEMPatCheckLev","saveEmRegPat",{"PatListData":PatListData,"EmPatModFlag":EmPatModFlag,"LgParams":LgParams},function(jsonString){
		
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
	var emborth =$('#emborth').val();
	emborth=new Date(Date.parse(emborth.replace(/-/g,"/")))
	minBorth=new Date("1841","00","01")
	/*
	curdate=new Date()
	if (emborth>curdate){
		$.messager.alert("提示:","生日不能大于今天！");
		return;
	}
	*/
	if (emborth<=minBorth){
		$.messager.alert("提示:","生日不能小于1841！");
		return;
	}
	var age=$("#empatage").val();
	if(parseInt(age)>120){
		$.messager.alert("提示:","年龄不能大于120！");
		return;
	}
	if(parseInt(age)<0){
		$(this).val("")
		$.messager.alert("提示:","年龄不能小于0！");
		return;
	}
	if (!checkSex())return;	
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
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.PatSex +'/'+ rowData.PatAge +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.NurseLevel!=""){
			if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
			if(rowData.NurseLevel==2) {classstyle="color: #f22613"};
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.NurseLevel+'级</span></h4>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 设置登记面板数据
function setRegPanelInfo(rowData,flag){
		
	$("#EmCardNoID").val(rowData.CardNoID);   		/// 卡号ID
	$("#EmRegID").val(rowData.EmRegID);   		    /// 登记ID
	$("#emcardno").val(rowData.PatCardNo);   		/// 卡号
	$("#PatientID").val(rowData.PatientID);   		/// PatientID
	//$("#Adm").val(rowData.Adm);
	$("#SelEmCheckNo").val(rowData.EpiRegData);
	
	$("#EmPatNo").val(rowData.PatNo);   		    /// 登记号
	$("#empatname").val(rowData.PatName);   		/// 姓名
	$("#empatage").val(rowData.PatAge);        		/// 年龄
	
	$("#empatsex").combobox("setValue",rowData.sexId);    	 /// 性别
	$("#emnation").combobox("setValue",rowData.nationdr);    /// 民族
	$("#emcountry").combobox("setValue",rowData.countrydr);  /// 国籍
	$("#emborth").val(rowData.birthday);    /// 出生日期
	
	$("#emidentno").val(rowData.IdentNo);   /// 证件号码
	$("#emfamtel").val(rowData.PatTelH);    /// 家庭电话
	$("#emaddress").val(rowData.Address);   /// 家庭住址
	
	GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  设置卡类型
	
	if(flag==0){
		return;
	}
	$("#Adm").val(rowData.Adm);             /// 就诊ID
	$("#emvistime").datebox("setValue",rowData.EmRegDate);   /// 来诊时间
	$("#EmPCLvID").val(rowData.EmPCLvID);   		/// 分诊ID
	var EmPatLevWard = "红";
	if (rowData.NurseLevel == "3"){EmPatLevWard = "黄";}
	if (rowData.NurseLevel == "4"){EmPatLevWard = "绿";}
	if (rowData.NurseLevel == ""){EmPatLevWard = "未分";}
	
	var NurseLevel = "";
	if (rowData.NurseLevel == ""){ NurseLevel = "未分";}
	else{NurseLevel = rowData.NurseLevel;}
	var html = "";
	var FontColor = "";
	if (EmPatLevWard == "红"){ FontColor = "#ff6248";}
	if (EmPatLevWard == "黄"){ FontColor = "#ffb746";}
	if (EmPatLevWard == "绿"){ FontColor = "#2ab66a";}
	if (EmPatLevWard == "未分"){FontColor = "#787878";} //huaxiaoying 2018-02-03 未分加底色
	
	var SexImg=""
	if (rowData.PatSex == "女"){ //huaxiaoying 2018-02-03 st 加性别图标
		SexImg = "nursewomano";
	}else if(rowData.PatSex == "男"){
		SexImg = "nursemano";
	}else{
		SexImg = "nurseunmano";
	}
	html = html +'<img style="width:30px;heigth:30px;border-radius:50%;margin-left:10px;margin-bottom:-5px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/'+SexImg+'.png">' //hxy ed
	html = html + '<span style="font-size:16px;color:#000;margin-left:10px;margin-right:10px;font-weight:bold;">' + rowData.PatName + '</span><span class="patother"></span>';
	//html = html + '<span style="color:' + FontColor + '">' + EmPatLevWard + '</span><span class="patother"></span>'; hxy 2018-01-29
	html = html + '<span style="border-radius:5px;padding:1px 3px 0 3px;color:#fff;background-color:' + FontColor + '">' + EmPatLevWard + '</span><span class="patother"></span>';
	html = html + '<span style="color:' + FontColor + '">' + NurseLevel + '级</span><span class="patother">|</span>';
	html = html + rowData.PatSex + '<span class="patother">|</span>';
	html = html + rowData.PatAge + '<span class="patother">|</span>';
	html = html + "ID:" + rowData.PatNo + '<span class="patother">|</span>';
	html = html + rowData.BillType + '<span class="patother">|</span>';
	html = html + rowData.EmRegDate + '<span class="patother">|</span>';
	html = html + rowData.EmRegTime + '<span class="patother"></span>';
	
	/*	
	var html = '<span class="word-green-deep font-18"><b>'+ rowData.PatName +'</b></span>';
		html = html + '<span class="padding-l25 word-green-deep">'+EmPatLevWard+'区</span>';
	    html = html + '<span class="padding-l25 fontsize-14 word-deep-gray">'+rowData.PatSex+'/'+rowData.PatAge+'/'+NurseLevel+'级/ID:'+rowData.PatNo+'/'+rowData.BillType+'/'+rowData.EmRegDate+" "+rowData.EmRegTime+'</span>';
	
	*/
	
	$(".item-label").html(html);
	
	LoadEmPatCheckLevInfo(rowData.EmPCLvID);     ///  如果病人已经进行分级,显示分级数据
}

/// 获取病人信息
function GetEmRegPatInfo(){
	var EmPatNo = $("#EmPatNo").val();      /// 登记号;
	var PatientID = $("#PatientID").val();  /// 病人ID
	
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			QueryEmPatListByPatNo(rowData.PatNo);
			setRegPanelInfo(rowData,0);
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
	
	var params = GetParams(EmPatNo) //2016-09-20 congyue
	
	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}

///  登记号回车
function GetEmPatInfo(e){
	
	 if(e.keyCode == 13){
		var EmPatNo = $("#EmPatNo").val();
		///  登记号补0
		var EmPatNo = GetWholePatNo(EmPatNo);
		clearEmPanel();				///  清空
		clearCheckBox(); // 清空复选框 bianshuai 2018-03-09
		$("#EmPatNo").val(EmPatNo);
		runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
			
			if (jsonString ==-1){
				$.messager.alert("提示:","当前卡无效,请重试！");
				return;

			}else{
				GetEmRegPatInfo();
				$("#empatname").focus();  /// 登记号回车后,病人姓名栏获得焦点
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
		
		clearEmPanel(1);				///  清空
		
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
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("提示:","小时数不能大于23！");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("提示:","分钟数不能大于59！");
		$('#'+ id).val("");
		return "";
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
		var html = '<span><input type="checkbox" name="EmSymFeild" value="'+this.id+'" checked><span class="EmSymSpan">'+ $(this).text() +'</span></input>&nbsp;&nbsp;';
		html = html+'</span>'
		$("#EmSymFeild").append(html);
		$(this).addClass("btn-successsymptoms");
		setEmRecLevel();
		$('.panel-title:contains("症状")').html("症状:"+$("#SymptomLev").tree("getSelected").text);
		arr.push(this.id);
		$("#EmSymFeildTitle").html("")
	}else{
		/// 取消症状 bianshuai 2018-02-09
		$('[name="EmSymFeild"][value="'+this.id+'"]').parent().remove();
		$(this).removeClass("btn-successsymptoms");
		arr.splice($.inArray(id,arr),1);
		/// 重新计算分级
		setEmRecLevel(); 
	}
	
}

///  分区图标点击事件 2016-09-20 congyue
function EmPatWardClick(){
	
	//$('#dgEmPatList').datagrid('load',{'params':"^"+this.id});
    //EmChkFlag="";
	EmBtnFlag=this.id;

	var EmPatNo=$('#search').searchbox('getValue');

	var params = GetParams(EmPatNo) 
	
	clearEmPanel();                        //清空面板

	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}

/// 已分诊/未分诊 2016-09-20 congyue
function QueryEmPatList(ChkFlag){

    EmBtnFlag="";
	EmChkFlag=ChkFlag;
	clearEmPanel(); 				//QQA 清空面板
	var Params = "^^"+ EmChkFlag +"^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	$('#dgEmPatList').datagrid('load',{'params':Params});
}

/// 确认病人分级
function surePatEmLev(){
	
	EmNurReaID = $("#EmNurRea").combobox("getValue");
	if (EmNurReaID == ""){
		$.messager.alert("提示:","请填写分级变更原因！");
		return;
	}
	$("#EmNurRea").combobox("setValue","");
	$('#newNurWin').window('close');
	surePatEmTriage();
}

/// 预检分诊
function surePatEmTriage(){
	
	
	//分诊需要建卡
	if(parNeedCardFlag==1){
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
	var emborth =$('#emborth').val();
	emborth=new Date(Date.parse(emborth.replace(/-/g,"/")))
	minBorth=new Date("1841","00","01")

	if (emborth<minBorth){
		$.messager.alert("提示:","生日不能小于1841！");
		return;
	}
	var age = $("#empatage").val();
	if(parseInt(age)>120){
		$.messager.alert("提示:","年龄不能大于120！");
		return;
	}
	if(parseInt(age)<0){
		$(this).val("")
		$.messager.alert("提示:","年龄不能小于0！");
		return;
	}

	//检验性别
	if (!checkSex())return;
	
	var EmPatName = $("#empatname").val();       /// 姓名    
	if (EmPatName == ""){
		$.messager.confirm('提示', '姓名为空,确定要以无名氏身份进行分诊吗?', function(result){  
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
	
	/// 转向科室 2016-09-12 congyue 
	var EmToLocID = $("#EmToLocID").combobox("getValue");   
	
	var EmRegID = $("#EmRegID").val();   			/// 登记ID
	if (EmRegID == ""){
		//$.messager.alert("提示:","请登记后,再进行分诊操作！");
		//return;
	}
	var PatientID = $("#PatientID").val();   		/// PatientID
	if (PatientID == ""){
		//$.messager.alert("提示:","请选中病人后重试！");
		//return;
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
	
	var AISActiveFlag = "";
	if ($("input[name='AISActiveFlag']:checked").length){
		AISActiveFlag = $("input[name='AISActiveFlag']:checked").val();       /// 创伤级别
	}
	
	var GlasgowFlag = "";
	if ($("input[name='GlasgowFlag']:checked").length){
		GlasgowFlag = $("input[name='GlasgowFlag']:checked").val();       /// 格拉斯哥级别
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
	
	var EmHurtDesc = $("#EmHurtDesc").val();             
	if ((AISActiveFlag == "Y")&(EmHurtDesc == "")){
		$.messager.alert("提示:","创伤分级不能为空！");           /// 创伤分级
		return;
	}
	
	var GlasgowDesc = $("#GlasgowDesc").val();
	if ((GlasgowFlag == "Y")&(GlasgowDesc == "")){
		$.messager.alert("提示:","格拉斯哥不能为空！");           /// 格拉斯哥分级
		return;
	}
	
	var EmPainLev = $("#EmPainLev").val();                       /// 疼痛级别
	if ((EmPainFlag == "Y")&(EmPainLev == "")){
		$.messager.alert("提示:","疼痛级别不能为空！");
		return;
	}
	
	var EmAware = $("#EmAware").combobox("getValue");    	     /// 意识状态
	var EmUpdLevRe = $("#EmUpdLevRe").combobox("getValue");    	 /// 护士更改分级原因
	EmAware = EmAware==undefined?"":EmAware;
	EmUpdLevRe = EmUpdLevRe==undefined?"":EmUpdLevRe;
	
	var EmNurseLevel = "";
	if ($('input[name="NurseLevel"]:checked').length){
		EmNurseLevel = $('input[name="NurseLevel"]:checked').val();  /// 护士分级
	}
	if (EmNurseLevel == ""){
		$.messager.alert("提示:","请先选择病人病情分级！");
		return;
	}
	
	 /// 是否修改护士分级
	if ((EmPCLvID !="")&(TmpNurLev != EmNurseLevel)&(EmNurReaID == "")){
		showNurWin(EmPCLvID);  /// 护士修改分级窗体
		return;
	}
	
	var EmRecLevel = $("#EmRecLevel").combobox("getValue");        	 /// 推荐分级
	
	var EmArea = "";
	if ($('input[name="Area"]:checked').length){
		EmArea =  $('input[name="Area"]:checked').val();   			 /// 去向分区
	}
	
	
	///  症状
	var EmSymDesc = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDesc.push(this.value +"!"+ $.trim($(this).parent().text()));
	})

	EmSymDesc = EmSymDesc.join("#");
	
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
	var EmPcsBreath = $("#EmPcsBreath").val();    ///  呼吸频率
	var EmPatChkSign1 = EmPcsTime + RowDelim + EmPcsTemp + RowDelim + EmPcsHeart + RowDelim + EmPcsPulse + RowDelim + EmPcsSBP + RowDelim + EmPcsDBP + RowDelim + EmPcsSoP2 + RowDelim + EmPcsBreath;
	var EmPatChkSign2 = EmPcsTime1 + RowDelim + EmPcsTemp1 + RowDelim + EmPcsHeart1 + RowDelim + EmPcsPulse1 + RowDelim + EmPcsSBP1 + RowDelim + EmPcsDBP1 + RowDelim + EmPcsSoP21;
	var EmPatChkSign = EmPatChkSign1; // +"||"+ EmPatChkSign2;
	
	/// 既往史
	var EmPatChkHisArr = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHisArr.push(this.value);
	})
	var EmPatChkHis = EmPatChkHisArr.join(RowDelim);
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
	
	///  六大病种
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

	///  其他
	var EmOtherDesc = $("#EmOtherDesc").val();

	///就诊号
	var Adm = $("#Adm").val();
	
	/// 号别
	var EmPatChkCaArr = []; var EmPatChkCarePrv = "";
	if ((PatRegType != 1)&&(Adm=="")&&(EmToLocID=="")){
		var EmPatChkCare = $("#EmCheckNo").combobox("getValue")
		if ((EmPatChkCare == "")&&(EmToLocID=="")&&(PatRegType != 1)&&(Adm=="")){
			$.messager.alert("提示:","请先选择号别或指向科室！"); ///2016-09-14 congyue 
			return;
		}
		/// 分诊科室
		var EmLocID =$("#EmLocID").combobox("getValue"); 	      ///2016-09-06 congyue    /// 分诊科室
		if ((EmLocID == "")&&(EmToLocID=="")&&(PatRegType != 1)&&(Adm=="")){
			$.messager.alert("提示:","请先选择分诊科室或指向科室！"); ///2016-09-14 congyue 
			return;
		}
		EmPatChkCaArr.push(EmPatChkCare+","+EmLocID);
		EmPatChkCarePrv = EmPatChkCaArr.join("#");
	}else{
		EmPatChkCarePrv = $("#SelEmCheckNo").val();
	}
	
	/// 病人姓名为空,默认三无人员打钩
	var EmPatName = $("#empatname").val();       /// 姓名
	if (EmPatName == ""){
		$('span:contains("三无")').prev().attr("checked",true);
	}
	        	
	/// 特殊人群 2016-09-08 congyue 
	var EmPatChkType = [];var EmPatType = "";
	$('input[name="EmPatChkType"]:checked').each(function(){
		EmPatChkType.push(this.value);
		if ($(this).next().text() == "三无人员"){ EmPatType = this.value;}
	})
	EmPatChkType = EmPatChkType.join(RowDelim);
	///congyue 2016-08-26
	var PatientID = $("#PatientID").val();  /// 病人ID

	/// 绿色通道 2017-02-28 bianshuai
	var EmGreenFlag = "N";
	if ($("input[name='EmGreenFlag']:checked").length){
		EmGreenFlag = $("input[name='EmGreenFlag']:checked").val();
	}
	
	/// 抢救病区 2017-03-08 bianshuai
	var EmPatWardID = $("#EmPatWard").combobox("getValue");
	if (typeof EmPatWardID == "undefined"){
		EmPatWardID = "";
	}
	
	/// 第1种模式:先挂号模式下;未挂号病人不允许进行分诊 
	/// 2017-03-08 bianshuai
	if ((PatRegType == 1)&(Adm == "")){
		$.messager.alert("提示:","此病人未挂号不能分诊！");
		return;
	}
	
	/// 第3种模式:先挂号模式下;需要先分诊时，必须是绿色通道或危重病人
	/// 2017-03-08 bianshuai
	var InsEpiFlag = "";
	if ((PatRegType == 3)&(Adm == "")){
		if ((EmGreenFlag != "Y")&&(EmPatWardID == "")&&(EmPatType == "")){
			$.messager.alert("提示:","非绿色通道、抢救病人、三无人员不能直接分诊！");
			return;
		}else{
			InsEpiFlag = "1";
		}
	}
	
	/// 第4种模式:先分诊;绿色通道、危重病人或三无人员默认插入挂号记录
	/// 2017-03-08 bianshuai
	if ((PatRegType == 4)&(Adm == "")){
		if ((EmGreenFlag == "Y")||(EmPatWardID != "")||(EmPatType != "")){
			InsEpiFlag = "1";
		}
	}
	
	/// 非第一种模式,在更新分诊信息时，就诊ID取上次存储内容
	/// 2017-03-08 bianshuai
	if ((PatRegType != 1)&(EmPCLvID != "")&(Adm == "")){
		Adm=$("#EmPatAdm").val();
	}
	
	/// 分诊护士^推荐分级^护士分级^护士分级原因^去向分区^分诊科室^重返标识^成批就诊^成批就诊人数^既往史
	/// 病人来源^来诊方式^意识状态^筛查^用药情况^用药情况描述^辅助物^辅助物描述
	/// 生命体征^症状表^症状描述^复合伤^ECG^中毒^疼痛^疼痛分级^疼痛范围^疼痛日期^疼痛时间^吸氧^请假^其他^病人ID^登记ID^已挂号别
	var EmListData = LgUserID +"^"+ EmRecLevel +"^"+ EmNurseLevel +"^"+ EmUpdLevRe +"^"+ EmArea +"^"+ LgLocID +"^"+ EmAgainFlag +"^"+ EmBatchFlag +"^"+ EmBatchNum +"^"+ EmPatChkHis;
	var EmListData = EmListData +"^"+ EmPatSource +"^"+ EmPatAdmWay +"^"+ EmAware +"^"+ EmScreenFlag +"^"+ EmHisDrug +"^"+ EmHisDrugDesc +"^"+ EmMaterial +"^"+ EmMaterialDesc;
	var EmListData = EmListData +"^"+ EmPatChkSign +"^"+ "" +"^"+ EmSymDesc +"^"+ EmCombFlag +"^"+ EmECGFlag +"^"+ EmPoisonFlag +"^"+ EmPainFlag +"^"+ EmPainLev +"^"+ EmPainRange +"^"+ EmPainDate +"^"+ EmPainTime;
	var EmListData = EmListData +"^"+ EmOxygenFlag +"^"+ EmPatAskFlag +"^"+ EmOtherDesc +"^"+ PatientID +"^"+ EmRegID +"^"+ EmPatChkCarePrv +"^"+ Adm +"^"+EmPatChkType+"^"+EmToLocID+"^"+ LgHospID +"#"+ LgCtLocID +"#"+ LgUserID +"#"+ LgGroupID;
	var EmListData = EmListData +"^"+ EmGreenFlag +"^"+ EmPatWardID +"^"+ InsEpiFlag +"^"+AISActiveFlag+"^"+GlasgowFlag +"^"+ EmNurReaID+"^"+EmPatSixSick+"^"+$("#greenHours").val();
	var PatientID = $("#PatientID").val();       /// PatientID
	var EmCardNoID = $("#EmCardNoID").val();     /// 卡号ID
	var EmCardNo = $("#emcardno").val();         /// 卡号
	var EmPatNo = $("#EmPatNo").val();           /// 登记号
	var EmPatName = $("#empatname").val();       /// 姓名
	var EmPatAge = $("#empatage").val();         /// 年龄
	var EmBorth = $("#emborth").val();        	 /// 出生日期
	var EmPatSex = $("#empatsex").combobox("getValue");     /// 性别
	var EmNation = $("#emnation").combobox("getValue");     /// 民族
	var EmCountry = $("#emcountry").combobox("getValue");   /// 国籍
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	var EmFamTel = $("#emfamtel").val();          /// 家庭电话
	var EmVisTime = $("#emvistime").datebox("getValue");   /// 来诊时间
	var EmAddress = $("#emaddress").val();        /// 家庭住址
	var EmCardType = $("#emcardtype").combobox("getValue"); /// 卡类型定义
	var empatage=$("#empatage").val()
	//集中处理combobox存在问题
	EmPatSex = EmPatSex==undefined?"":EmPatSex;
	EmNation = EmNation==undefined?"":EmNation;
	EmCountry = EmCountry==undefined?"":EmCountry;
	EmCardType = EmCardType==undefined?"":EmCardType;
	
	var mySecrityNo = "";
	if ((EmCardNoID == "")&(EmCardNo != "")){
		/// 提取安全码异常
		mySecrityNo = GetSecurityNO();
		if (mySecrityNo == ""){
			$.messager.alert("提示:","提取安全码异常！");
			return;
		}
		/// 写卡 [把安全码写到卡里]
		if (!WrtCard(mySecrityNo)){
			$.messager.alert("提示:","写卡异常！");
			return;
		}
	}

	/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardType[0]+"^"+empatage+"^"+LgHospID+"^"+mySecrityNo;
    //保存创伤评分
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
	    
     ///保存格拉斯哥昏迷  2016-10-14 guoguomin 
     GlasgowLevWin();
     cancelGlasgowLevWin();
     var strGCS=""; //格拉斯哥昏迷子表ID串
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
	/// 保存分诊数据
	runClassMethod("web.DHCEMPatCheckLev","saveEmPatCheckLev",{"EmPCLvID":EmPCLvID,"EmListData":EmListData,"PatListData":PatListData,"strAIS":strAIS,"strGCS":strGCS,"LgParams":LgParams},function(jsonString){
	  
		var retArr = jsonString.split("^");
		ret=retArr[0]
		if (ret > 0){
			$.messager.alert("提示:","保存成功！");
			$("#EmPCLvID").val(ret);   			/// 分诊ID
			$("#dgEmPatList").datagrid("reload");
			$("#PatientID").val(retArr[1])
			GetEmRegPatInfo(); /// 加载病人登记信息
			LoadEmPatCheckLevInfo(ret);            /// 重新加载分诊信息
		}else if (ret==-101){
			$.messager.alert("提示:","没有找到出诊记录,或者从未排班!");
		}else if (ret==-200){
			$.messager.alert("提示:","病人已经在留观/抢救室,请先办理离院！");
		}else if (ret==-102){
			$.messager.alert("提示:","此病人已经存在相同的登记记录,请使用病人列表查询!");
		}else if (ret==-301){
			$.messager.alert("提示:","超过患者每天挂号限额!");
		}else if (ret==-202){
			$.messager.alert("提示:","该号别已挂完!");
		}else if (ret==-98){
			$.messager.alert("提示:","已就诊，不允许修改或更换号别");
		}else if (ret==-99){
			$.messager.alert("提示:","号别已收费，请先退号!");
		}else if (ret==-9){
			$.messager.alert("提示:","号别级别不同!");
		}else{
			msg=retArr[1]==undefined?ret:retArr[1];
			if (msg.indexOf("证件号码不能为空") != "-1"){
				msg=msg.replace("证件号码不能为空","身份证号不能为空！");
			}
			$.messager.alert("提示:","保存失败！"+msg);
		}
	},'text')
}
///  如果病人已经进行分级,显示分级数据
function LoadEmPatCheckLevInfo(EmPCLvID){
	/// 提取分级数据
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
				/// 转向科室 2016-09-12 congyue
				$("#EmToLocID").combobox('select',EmPatCheckLevObj.EmToLocID);


			}
			if(EmPatCheckLevObj.EmLocID!=0){
				$('#EmToLocID').combobox('setValue',"");
				$("#EmLocID").combobox('setValue',EmPatCheckLevObj.EmLocID)
			} 
			///	 总人数
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			///  推荐分级
			$("#EmRecLevel").combobox('setValue',EmPatCheckLevObj.EmRecLevel);
			
			///  护士更改分级原因
			$("#EmUpdLevRe").combobox('setValue',EmPatCheckLevObj.EmUpdLevRe);

			///  分诊科室
			///$("#EmLocID").val(EmPatCheckLevObj.EmLocID);  //2016-09-06 congyue

			///  意识状态
			$("#EmAware").combobox('setValue',EmPatCheckLevObj.EmAware);

			///  护士分级
			$('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').attr("checked",'checked'); 
			TmpNurLev = EmPatCheckLevObj.NurseLevel;
			EmNurReaID = ""; 
			
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
	
			///  六大病种
			if(EmPatCheckLevObj.SixSick!==""){
				sixSickArr = EmPatCheckLevObj.SixSick.split("#");
				for(x in sixSickArr){
					$('[name="EmPatSixSick"][value="'+ sixSickArr[x] +'"]').attr("checked",true);		
				}
			}
			
			
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
			
			/// 疼痛分级 按钮可用
			if (EmPatCheckLevObj.EmPainFlag == "Y"){
				$('a:contains("疼痛分级")').linkbutton('enable');
			}
			
			///创伤分级
			$("#EmHurtDesc").val(EmPatCheckLevObj.AisDataStr);
			var aisdatastr = EmPatCheckLevObj.AisDataStr;
			if(EmPatCheckLevObj.EmAisFlag=="N"){
				$('[name="AISActiveFlag"][value="'+ 'N' +'"]').attr("checked",true);
			}else{
				var AISActiveFlag = "";
				if (aisdatastr != ""){
					$('[name="AISActiveFlag"][value="'+ 'Y' +'"]').attr("checked",true);
					$('a:contains("创伤分级")').linkbutton('enable');
				}
			}
			for (x=1;x<aisdatastr.split(",").length-1;x++){
				aisStr = aisStr+aisdatastr.split(",")[x]+"^";
			}
			
				
			///格拉斯哥
			$("#GlasgowDesc").val(EmPatCheckLevObj.GCSDataStr);
			var gcsdatastr = EmPatCheckLevObj.GCSDataStr;
			if(EmPatCheckLevObj.EmGcsFlag=="N"){
				$('[name="GlasgowFlag"][value="'+ 'N' +'"]').attr("checked",true);
			}else{
				var GlasgowFlag ="";
				if (gcsdatastr != ""){
					$('[name="GlasgowFlag"][value="'+ 'Y' +'"]').attr("checked",true);
					$('a:contains("格拉斯哥分级")').linkbutton('enable');
				}
				}
			for (y=0;y<gcsdatastr.split(",").length-1;y++){
					gcsStr = gcsStr+gcsdatastr.split(",")[y].split(":")[1]+"^";
					//alert(gcsStr)
				}
			

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
					arr.push(EmSymFeildID)
				}
			}

			///	 既往史
			var EmPatChkHisArr = EmPatCheckLevObj.EmPatChkHis.split("#");
			for(var i=0;i<EmPatChkHisArr.length;i++){
				$('[name="EmPatChkHis"][value="'+ EmPatChkHisArr[i] +'"]').attr("checked",true);
			}
			
			///  预检号别
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
				$("#EmPcsBreath"+flag).val(EmPcsArr[7]);      ///  呼吸频率
			}
			///  特殊人群 2016-09-05 congyue
			$('[name="EmPatChkType"][value="'+ EmPatCheckLevObj.EmPatChkType +'"]').attr("checked",true);
			
			/// 绿色通道 2017-02-28 bianshuai
			if (EmPatCheckLevObj.EmPatGreFlag == 1){
				$('[name="EmGreenFlag"][value="Y"]').attr("checked",true);
				$("#greenHours").val(EmPatCheckLevObj.EmPatGreHours);
				$("#greenHours").attr("disabled",true)
			}
			
			/// 抢救病区 2017-03-08 bianshuai
			if (EmPatCheckLevObj.EmWardID != ""){
				$('#EmPatWard').combobox({disabled:false});
				$("#EmPatWard").combobox('setValue',EmPatCheckLevObj.EmWardID);
			}else{
				$('#EmPatWard').combobox({disabled:true});
			}
			
			/// 预检就诊ID 2017-03-08 bianshuai
			$("#EmPatAdm").val(EmPatCheckLevObj.EmPatAdm);

		}else{
			$('#EmBatchNum').attr("disabled",true);	
		}
	})
}

///	 清空
function clearEmPanel(flag){
	$('a:contains("疼痛分级")').linkbutton('disable');//hxy add 2016-11-28
	$('a:contains("创伤分级")').linkbutton('disable');
	$('a:contains("格拉斯哥分级")').linkbutton('disable');
	gcsStr="";   //参数重置
	aisStr="";   //参数重置
	EmNurReaID = ""; /// 参数重置
	/// 复选框
	$('input[type="checkbox"][name!="EmEpiFlag"][name!="EmCkLvFlag"]').attr("checked",false);
	
	/// 单选
	$('input[type="radio"]').attr("checked",false);
	
	/// 文本框
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
	
	/// 日期
	$('input.datebox-f').each(function(){
		if(this.id == "emcardtype"){return;}
		if((this.id == "stadate")||(this.id == "enddate")){return;}
		if(this.id=="emvistime") {
			$("#"+ this.id).datebox("setValue",formatDate(0));
			return;	
		} 
		$("#"+ this.id).datebox("setValue","");
	})
	
	/// 预检号别
	$('#SelEmCheckNo').html("");
	
	/// 症状
	$("#EmSymFeild").html("");
	
	$('#EmLocID').combobox({disabled:false})
	$('#EmCheckNo').combobox({disabled:false})
	$('#EmToLocID').combobox({disabled:true})
	$('#EmBatchNum').attr("disabled","disabled")
	
	/// 分诊科室
	if (PatRegType == "3"){
		$("td:contains('分诊科室')").parent().css("display","");
	}
	
	/// 已挂号别
	$("#queDoc").html("");
	
	/// 清除症状内容栏
	$("#symList").html("");
	/// 清空症状已选中列表
	arr=[];
	
	/// 清除症状树选中状态
	$('#SymptomLev').find('.tree-node-selected').removeClass('tree-node-selected');
	
	/// 清空身份证图片区域  bianshuai 2018-03-17
	$("#imgPic").attr("src","../images/uiimages/patdefault.png");
	initGreenHours(); //zhouxin
	 $(".item-label").html(""); ///清空病人信息栏  bianshuai 2018-03-17
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
/// 创伤评分窗口
function EmPatHurtLevWin(){
	var AISActiveFlag = "";
	if ($("input[name='AISActiveFlag']:checked").length){
		AISActiveFlag = $("input[name='AISActiveFlag']:checked").val();       /// 创伤级别
	}
	if (AISActiveFlag != "Y"){
		return;
	}
	aisArr=[];
	///创伤评分
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
				$.messager.alert("提示","创伤评分维护不正确!");
				}
			htmlstr=htmlstr+"<td>"
				for(j=0;j<trData.split("#")[1].split("$").length;j++){
					var tdData = trData.split("#")[1].split("$")[j];
					htmlstr = htmlstr + '<input type="checkbox" name="AISActiveFlag'+i+'" strAIS="'+tdData.split("^")[0]+'"scoreAIS ="'+tdData.split("^")[2]+'" text="'+AISName+':'+'('+tdData.split("^")[2]+'分)'+'" value="'+(j+1)+'">'+ tdData.split("^")[1]+' (' +tdData.split("^")[2] +'分)'+'</input>&nbsp;&nbsp;';
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
		aisStr="";   //参数重置
	},'text',false)
	
	
	
	
	if($('#EmPatHurtLevWin').is(":hidden")){
		$('#EmPatHurtLevWin').window('open');
		return;}  //窗体处在打开状态,退出
/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('创伤分级', 'EmPatHurtLevWin', '1050', '400', option).Init();
	$(".panel-tool-close ").bind("click",cancelEmHurtWin)// yuliping 关闭按钮绑定清除
}
///  格拉斯哥昏迷分级窗口
function GlasgowLevWin(){
	var GlasgowFlag = "";
	if ($("input[name='GlasgowFlag']:checked").length){
		GlasgowFlag = $("input[name='GlasgowFlag']:checked").val();       /// 疼痛级别
	}
	if (GlasgowFlag != "Y"){
		return;
	}
	gcsArr=[];
	///格拉斯哥昏迷
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
				$.messager.alert("提示","格拉斯哥昏迷维护不正确!");
				} 
			htmlstr=htmlstr+"<td>"
				for(j=0;j<trData.split("#")[1].split("$").length;j++){
					var tdData = trData.split("#")[1].split("$")[j];
					htmlstr=htmlstr+"<td align='left' width=''>"
					htmlstr = htmlstr + '<input type="checkbox" name="GlasgowFlag'+i+'" strCode="'+tdData.split("^")[2]+'" strGCS="'+tdData.split("^")[0]+'" text="'+gcsName+':'+tdData.split("^")[1]+'(' + tdData.split("^")[2]+ '分)'+'" value="'+(j+1)+'" >'+ tdData.split("^")[1]+'(' + tdData.split("^")[2]+ '分)' +'</input>';
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
		gcsStr="";   //参数重置
		//$("input[text*='睁眼反应']").attr("checked", true);
		
	},'text',false)
	
	
	
	if($('#GlasgowLevWin').is(":hidden")){
		$('#GlasgowLevWin').window('open');
		num=0
		return;}  //窗体处在打开状态,退出
		
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('格拉斯哥分级', 'GlasgowLevWin', '1000', '400', option).Init();
	$(".panel-tool-close ").bind("click",cancelGlasgowLevWin)     //yuliping 关闭按钮绑定清除事件
}


///  疼痛分级笑脸按钮事件
function EmPainFaceEvt(){
	
	$(this).find("span").css({"color":"#ff7a00"});
	$(this).siblings().find("span").css({"color":""});
	
	/// 设置疼痛分级项目值
	$("#EmPainLev").val($(this).index() * 2);
	
	/// 设置 数字评分法（VAS） 指标位置
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

///  创伤评分取消
function cancelEmHurtWin(){
	aisStr=aisStr2;
	aisArr2=[];
	try{
	$('#EmPatHurtLevWin').window('close')
		clearEmPain();
	;}catch(e){}
}
///  创伤评分确定
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
		$.messager.alert("提示:","未打分,请选择打分！")
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
///  取消
function cancelEmPainWin(){
	
	$('#EmPatPainLevWin').window('close');
}

///  取消护士分级窗口
function cancelNurLevWin(){
	
	$("#EmNurRea").combobox("setValue","");
	$('#newNurWin').window('close');
}

///  格拉斯哥取消
function cancelGlasgowLevWin(){
	gcsStr=gcsStr2;
	gcsArr2=[];
	try{
		$('#GlasgowLevWin').window('close');
		num=0
		clearGlasgow()
	}catch(e){}
}
///  格拉斯哥确定
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
		$.messager.alert("提示:","未打分,请选择打分！")
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

///  确定
function sureEmPainWin(){
	
	///  疼痛指数
	var EmPainLev = $("#EmPainLev").val();
	if (EmPainLev == ""){
		$.messager.alert("提示:","疼痛指数不能为空！");
		return;
	}
	
	///  疼痛范围
	var EmPainRange = $("#EmPainRange").combobox('getText');
	if ((EmPainRange == "")&(EmPainLev != 0)){
		$.messager.alert("提示:","疼痛范围不能为空！");
		return;
	}
	///  疼痛时间
	var EmPainTime = $("#EmPainTime").datetimebox('getValue');
	if ((EmPainTime == "")&(EmPainLev != 0)){
		$.messager.alert("提示:","疼痛时间不能为空！");
		return;
	}
	
	if (!isValidTime(EmPainTime)){
		$.messager.alert("提示:","疼痛时间不能大于当前时间点！");
		return;	
	}
	
	setEmRecLevel()

	if (EmPainLev == 0){
		$('a:contains("疼痛分级")').linkbutton('disable');
		/// 无
		$('input[name="EmPainFlag"][value="N"]').attr("checked",true);
		$('input[name="EmPainFlag"][value="Y"]').attr("checked",false);
	}else{
		var EmPainDesc = "疼痛范围:"+EmPainRange+", 疼痛时间:"+EmPainTime+", 疼痛分级:"+EmPainLev+"级";
		$("#EmPainDesc").val(EmPainDesc);
	}
	$('#EmPatPainLevWin').window('close');
}

/// 初始化症状树
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

///  加载症状知识库
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
			m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
			m_CCMRowID = CardTypeDefArr[14];
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
	var EmPatChkHisArr = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHisArr.push(this.value);
	})
	EmPatChkHis = EmPatChkHisArr.join("$$");
	//EmParSym=$('#SymptomLev').tree('getSelected').text;
	//alert(EmParSym)
	EmPainLev1=$("#EmPainLev").val();
	//
	///  症状
	var EmSymDescArr = [];
	$('input[name="EmSymFeild"]:checked').each(function(){
		EmSymDescArr.push($.trim($(this).parent().text()));
	})
	var EmSymDesc = EmSymDescArr.join("$$");
	//alert(EmSymDesc)
		
	/// (2)生命数据
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  体温
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  心率
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  血压(BP)收缩压
	var EmPcsDBP = $("#EmPcsDBP").val();
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  血氧饱合度SoP2
	var EmPcsPulse = $("#EmPcsPulse").val();    ///  脉搏 2016-12-06 congyue
	var EmPcsBreath = $("#EmPcsBreath").val();    ///  呼吸频率
	var age=$("#empatage").val();            ///年龄
	var pGCS=""
	
	//qqa 2018-02-27 增加荒诞值判断
	if((EmPcsTemp!="")&&(EmPcsTemp<=34)||(EmPcsTemp>=43)){
		$.messager.alert("提示","体温值荒诞,范围34-43!");
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
		EmPcsListData = EmPcsSBP +"^"+ EmPcsSoP2 +"^"+ EmPcsHeart +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp+"^"+EmSymDesc+"^"+EmPainLev1+"^"+EmPcsDBP+"^"+EmPcsPulse+"^"+age+"^"+EmPcsBreath+"^"+pGCS; //2016-12-06 cy 添加脉搏 EmPcsPulse
	}
//	var EmPcsTemp1 = $("#EmPcsTemp1").val();    ///  体温
//	var EmPcsHeart1 = $("#EmPcsHeart1").val();  ///  心率
//	var EmPcsSBP1 = $("#EmPcsSBP1").val();      ///  血压(BP)收缩压
//	var EmPcsSoP21 = $("#EmPcsSoP21").val();    ///  血氧饱合度SoP2
//	var EmPcsPulse1 = $("#EmPcsPulse1").val();    ///  脉搏 2016-12-06 congyue
//	if ((EmPcsTemp1!="")||(EmPcsHeart1!="")||(EmPcsSBP1!="")||(EmPcsSoP21!="")||(EmPainLev1!="")||(EmSymDesc!="")){
//		//EmPcsListData2 = EmPcsSBP1 +"^"+ EmPcsSoP21 +"^"+ EmPcsHeart1 +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp1 +"^"+ EmSymDesc +"^"+ EmPainLev1;
//	}
	/// 系统推荐分级
	if(EmPcsListData!= ""){
		//if(EmPcsListData2!=""){EmPcsListData=EmPcsListData2}
		GetEmRecLevel(EmPcsListData);
	}
	
}

///  获取系统推荐分级
function GetEmRecLevel(EmPcsListData){
	runClassMethod("web.DHCEMCalPatLevel","calPatLevel",{"EmPCLvID":EmPcsListData},function(jsonString){
		if (jsonString != null){
			var EmRecLevel = jsonString;
			if(EmRecLevel!=0){
				///  推荐分级
				$("#EmRecLevel").combobox('setValue',EmRecLevel);
				var EmPCLvID = $("#EmPCLvID").val();
				if (EmPCLvID == ""){
					///  护士分级
					$('input[name="NurseLevel"][value="'+ EmRecLevel +'"]').attr("checked",'checked');
					///  去向
					$('input[name="Area"][value="'+ ((EmRecLevel - 1)||1) +'"]').attr("checked",'checked'); 
					// 动态设置控件可用和不可用 bianshuai 2017-03-09
					setComponentEnable(EmRecLevel,EmRecLevel);
				}
			}else{
				$("#EmRecLevel").combobox('setValue',"");
			}
		}
	},'',false)
}

///  设置病人基本信息
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
						$.messager.alert("提示:","身份证:"+PatIdentNo+";此证件号码已经存在！");
						$('#emidentno').val("");
						return;
					}
					if (EmCardNo != ""){
						$.messager.alert("提示:","身份证:"+PatIdentNo+";此证件号码已经存在,如需办卡,请办理其他卡或办理补卡！");
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
	$("#empatage").val(jsGetAge(d)+"岁")  //setEmPatAges(d));      /// 年龄
	d = GetSysDateToHtml(d) /// 根据His系统配置转换日期格式
	$("#emborth").val(d);      /// 出生日期
	
	/// 设置性别
	if (parseInt(value.substr(16, 1)) % 2 == 1) {
		$("#empatsex").combobox("setValue",TransPatSexToID("男"));
	}else{ 
		$("#empatsex").combobox("setValue",TransPatSexToID("女"));
	}
}

/// 取His日期维护显示格式 bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){
	
	//qqa 2018-01-09 修改调用的类名
	runClassMethod("web.DHCEMPatCheckLevCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}

/// 取His性别 bianshuai 2017-08-17
function TransPatSexToID(PatSex){
	
	var PatSexID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","SexToId",{"desc":PatSex},function(jsonString){
		PatSexID = jsonString;
	},'',false)
	return PatSexID;
}

/// 取His民族 bianshuai 2017-08-17
function TransNationToID(Nation){
	
	var PatNationID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","NationToId",{"Nation":Nation},function(jsonString){
		PatNationID = jsonString;
	},'',false)
	return PatNationID;
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
function jsGetAge(strBirthday)
{    
	var bDay = new Date(strBirthday),
	nDay = new Date(),
	nbDay = new Date(nDay.getFullYear(),bDay.getMonth(),bDay.getDate()),
	age = nDay.getFullYear() - bDay.getFullYear();
	if (bDay.getTime()>nDay.getTime()) {return '日期有错'}
	return nbDay.getTime()<=nDay.getTime()?age:--age;  


}
///  按日期查询登记病人列表 2016-08-29 congyue
function QueryEmPatListByTime(){
	
	var EmPatNo=$('#search').searchbox('getValue');
    
	var params = GetParams(EmPatNo) 
	
	clearEmPanel();     //QQA 清空面板

	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}

///  按日期查询登记病人列表 2016-09-20 congyue
function GetParams(EmPatNo)
{
    
	///  登记号补0
	if (EmPatNo!="")
	{
		var EmPatNo = GetWholePatNo(EmPatNo);
	}

	
	$(".searchbox-text").val(EmPatNo);
	var EmStaDate=$('#stadate').datebox('getValue');  //开始日期 cy
	var EmEndDate=$('#enddate').datebox('getValue');  //结束日期 cy
	
	var EmChkFlag = "";  ///挂号/未挂号/分诊/未分诊标志 bianshuai 2018-03-24
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

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
///congyue 2016-08-26  分诊挂号单打印
function LevPrintout() {
	
	var EmPCLvID = $("#EmPCLvID").val();  /// 2017-04-13 bianshuai 分诊ID
	if (EmPCLvID == ""){
		$.messager.alert("提示:","请先选中一条分诊数据！");
		return;
	}
	
	var PrintData="";
	
	/// 获取打印分诊数据
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
		var EmRegDate=PrintArr[11]; //登记日期
		var EmCreator=PrintArr[12];
		var PrintDate=PrintArr[13];
		var PrintTime=PrintArr[14];
		var EmRegTime=PrintArr[15]; //登记时间
		var CreateDate=PrintArr[16]; //分诊日期 2016-09-19
		var CreateTime=PrintArr[17]; //分诊时间 2016-09-19
		var EmAware=PrintArr[18]; //意识状态 2016-09-19
		var HospName = PrintArr[19];  //医院名称 QQA  2016-10-21
		var DontNo =PrintArr[20];
		///	 生命体征
		var flag="";
		var EmPcsTime="",EmPcsTemp="",EmPcsHeart="",EmPcsPulse="",EmPcsSBP="",EmPcsDBP="",EmPcsSoP2="",EmPcsR="";  
		var EmPcsTime1="",EmPcsTemp1="",EmPcsHeart1="",EmPcsPulse1="",EmPcsSBP1="",EmPcsDBP1="",EmPcsSoP21="",EmPcsR1="";  
		var EmPatChkSignArr = EmPatChkSign.split("#");
		for(var i=0;i<EmPatChkSignArr.length;i++){
			if (i==0){
			EmPcsArr = EmPatChkSignArr[i].split("@");
			EmPcsTime=EmPcsArr[0];   ///  时间
			EmPcsTemp=EmPcsArr[1];   ///  体温
			EmPcsHeart=EmPcsArr[2];  ///  心率
			EmPcsPulse=EmPcsArr[3];  ///  脉搏
			EmPcsSBP=EmPcsArr[4];    ///  血压(BP)收缩压
			EmPcsDBP=EmPcsArr[5];    ///  舒张压
			EmPcsSoP2=EmPcsArr[6];   ///  血氧饱合度SoP2
			EmPcsR = EmPcsArr[7]     ///  呼吸频率
			}if (i!=0){
			EmPcsArr1= EmPatChkSignArr[i].split("@");
			EmPcsTime1=EmPcsArr1[0];   ///  时间
			EmPcsTemp1=EmPcsArr1[1];   ///  体温
			EmPcsHeart1=EmPcsArr1[2];  ///  心率
			EmPcsPulse1=EmPcsArr1[3];  ///  脉搏
			EmPcsSBP1=EmPcsArr1[4];    ///  血压(BP)收缩压
			EmPcsDBP1=EmPcsArr1[5];    ///  舒张压
			EmPcsSoP21=EmPcsArr1[6];   ///  血氧饱合度SoP2
			EmPcsR1 = EmPcsArr[7]       ///  呼吸频率
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

//checkBox 只能选中一个
function singleSelect(){
	alert($(this).attr("checked"));
	if($(this).checked=="true"){
		$(this).siblings().removeAttr('checked');	
		}
	}
//检查身份证性别	
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
	    $.messager.alert("提示:","身份证号错误！");
	    return false;
	}
	tmpStr = GetSysDateToHtml(tmpStr);    /// 根据His系统配置转换日期格式
	date2=$("#emborth").val();
   	if(tmpStr!=date2){
	   	$.messager.alert("提示:","出生日期和身份证号不一致！");
	    return false;
	}
    var tempid=sexno%2;
    if((tempid==0)&&(sex!=2)){
	    $.messager.alert("提示:","身份证号对应的性别是女！");
	    return false;
	}
	
    if((tempid!=0)&&(sex!=1)){
	    $.messager.alert("提示:","身份证号对应的性别是男！");
	    return false;
	}
	return true;	
}
//病人列表登记号查询 
function GetCardPatInfo(e){
	 if(e.keyCode == 13){
		var Regno = $("#Regno").val();
		///  登记号补0
		var Regno = GetWholePatNo(Regno);
		clearEmPanel();				///  清空
		$("#Regno").val(Regno);
		QueryEmPatListByPatNo(Regno);
		
	}
}
//病人列表登记号查询 按钮
function GetCardPatInfoOnclick(){
	 
		var Regno = $("#Regno").val();
		///  登记号补0
		var Regno = GetWholePatNo(Regno);
		clearEmPanel();				///  清空
		$("#Regno").val(Regno);
		QueryEmPatListByPatNo(Regno);
		

}
function initTooltip(){
	//alert($("#SymptomLev").find("li").length);
	$("#SymptomLev").find("li").each(function(){
		$(this).tooltip({
		position:'bottom',      //left,right,top,bottom 位置
		content :"提示内容",		//内容，支持HTML
		trackMouse : true		//是否跟随鼠标移动
		})
		})
	}

/// 时间点效验
function isValidTime(EmPainTime){

	if (EmPainTime == "") return true;
	/// 当前时间
	var date = new Date();
	var currYear = date.getFullYear();
	var currMonth = date.getMonth() + 1;
	var currDate = date.getDate();
	var currHour = date.getHours();
	var currMinute = date.getMinutes();

	var PainArr = EmPainTime.split(" ");
	var DateArr = PainArr[0].split("-");
	/// 年
	if (DateArr[0] > currYear){
		return false;
	}
	/// 月
	if ((DateArr[0] == currYear)&(DateArr[1] > currMonth)){
		return false;
	}
	/// 日
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
//页面退出，清除checkbox yuliping
function clearGlasgow(){
	
	for(x=0;x<gcsArr2.length;x++){
		$('input[name="'+gcsArr2[x]+'"]').each(function(){
			
			$(this).attr("checked","");
				
		});	
	}
}
//获取格拉斯哥总分数 yuliping
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
//获取创伤总分数 yuliping
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
//获取格拉斯哥总分数对应的提示信息 yuliping
function getGlasgowLevel(num){

	var str=""
	if(num==15){
		str='意识清楚(总分'+num+'分)'
		}else if((num>=12)&&(num<=14)){
			str='轻度意识障碍(总分'+num+'分)'
		}else if((num>=9)&&(num<=11)){
			str='中度意识障碍(总分'+num+'分)'
		}else{
			str='昏迷(总分'+num+'分)'
		}
	return str;
}
//获取创伤总分数对应的提示信息 yuliping
function getEmPatPainlev(num){
	
	var str=""
	 if((num>=14)&&(num<=16)){
			str='生理变化小，生存率为96%(总分'+num+'分)'
		}else if((num>=1)&&(num<=3)){
			str='生理变化很大，死亡率>96%(总分'+num+'分)'
		}else if(num==0){
			str='(总分'+num+'分)'
		}else{
			str='生理变化显著，抢救效果亦显著(总分'+num+'分)'
			}
	return str;
}
//页面退出，清除checkbox yuliping
function clearEmPain(){
	
	for(x=0;x<aisArr2.length;x++){
		$('input[name="'+aisArr2[x]+'"]').each(function(){
			
			$(this).attr("checked","");
				
		});	
	}
}
 
/// 动态设置控件可用和不可用 bianshuai 2017-03-09
function setComponentEnable(LvFlag, AreFlag){
	
	/// 分级为1、2级或去向为红区时,抢救病区可用否则不可用
	if ((LvFlag == 1)||(LvFlag == 2)||(AreFlag == 1)){
		/// 抢救病区可用
		$('#EmPatWard').combobox({disabled:false});
	}else{
		 /// 抢救病区不可用
		$('#EmPatWard').combobox({disabled:true});
	}
}

function blurBrith(){
		var mybirth = $('#emborth').val();
		if (mybirth != ""){
			if ((mybirth != "")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
				$('#emborth').val("");
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
			$('#emborth').val(mybirth);
			setPatAge(mybirth);
		}
	}

/// 验证输入出生日期
function setBrith(e){
	
	if(e.keyCode == 13){
		
		$('#empatage').focus();
		
	}

}

/// 设置年龄
function setPatAge(borthdate){
	
    /// 取患者年龄
    runClassMethod("web.DHCEMPatCheckLevQuery","GetPatientAgeDesc",{"PatientDOB":borthdate},function(jsonstring){
		if (jsonstring != null){
			$("#empatage").val(jsonstring);
		}
		
	},'',false)
}

/// 随机获取系统安全码
function GetSecurityNO(){
	var securityNO = "";
    runClassMethod("web.UDHCAccCardManage","GetCardCheckNo",{"PAPMINo":''},function(jsonstring){
		if (jsonstring != null){
			securityNO = jsonstring;
		}
		
	},'',false)
	return securityNO;
}

/// 写卡 bianshuai 2017-03-30
function WrtCard(mySecrityNo){
	
	var myCardNo = $("#emcardno").val();         /// 卡号
	var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
	if (rtn!="0"){
		return false;
	}
	
	return true;
}

/// 根据证件号获取病人ID
function GetPatientID(PatIdentNo){
	var PatientID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatientID",{"PatIdentNo":PatIdentNo},function(jsonString){
		if (jsonString != null){
			PatientID = jsonString;
		}
	},'',false)
	return PatientID;
}
/// 清空已挂号/未挂号、已分诊/未分诊 复选框 bianshuai 2018-03-09
function clearCheckBox(){
   
   /// 复选框
   $('input[name="EmEpiFlag"]').attr("checked",false);
   $('input[name="EmCkLvFlag"]').attr("checked",false);
}