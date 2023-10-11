
var itemSelFlag = 0;   //页签选中
var stateFlag = 0;	   //状态
var res = ""
var auditId = "";	   //审核Id
var imgurl = "../scripts/dhcnewpro/dhcpresc/images/"; //图标路径
var color = ["#2AB66A","#FFB519","#FF5219","#000000"];	//颜色，提示、提醒、警示、禁止
var stdate = formatDate(0);
var enddate= formatDate(0);
var selectIndex = -1	//审核列表索引
var admId = "";
var patientId = "";
var patNumFlag=""; //是否点击了姓名旁边的数字
var loopPointer = "";
/// 页面初始化函数
function initPageDefault(){
	
	initCompent();				//判断是否在线	
	initCombobox();				//初始化下拉框
	initButton();				//初始化页面方法
	initAuditList();			//初始化审核列表
	initDateBox();				//初始化查询条件
	initLisDatagrid();			//初始化检验列表
	initInsDatagrid();			//初始化检查列表
	loopPointer = setInterval("reloadAuditList()",5000);		//刷新审核列表列表
	
	
}

//判断是否在线
function initCompent()
{
	runClassMethod(
		"web.DHCPRESCAudit",
		"Isactive",
			{
				"userId":LgUserID
			},
			function(data){
				
				if((data == 0)||(data == "-1")){
					var tipstr = "";
					if(data == 0){
						tipstr = "您正处于离线状态~";
					}
					if(data == "-1"){
						tipstr = "您未选择监测科室，请先选择~";
					}
					$HUI.dialog('#onlinedialog').open();
					$("#tips").html(tipstr);
				}
	},'text');
	
}
///初始化审核列表
function initAuditList()
{
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'审核列表',width:160,formatter:setCellLabel,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onSelect:function(rowIndex, rowData){
	        if(!rowData) return;
	        if(rowData.auditId!=auditId){
		    	patNumFlag = "";
		    	LoadPatInfo(rowData);					//加载患者基本信息
				LoadPrescNo(rowData.auditId);			//加载处方信息
				LoadPrescPro(rowData.auditId);			//加载审查问题
				LoadAuditRes(rowData.auditId);			//药师处理结果
		    }
		    admId = rowData.admId;
			patientId = rowData.patientId;
		    initLisDatagrid();			
			initInsDatagrid();
			
			auditId = rowData.auditId;
			
			
			//setTimeout("initContentfold()", 100 );
			selectIndex = rowIndex;
			
	    },
	    onClickRow:function(rowIndex, rowData){
		    LoadButtons();
		    ChangeStyle(rowData.auditId);
	        if(rowData.status=="0")
	        {
				setReadFlag(rowData.auditId);           //信息加载完成添加阅读标记 2022-3-7  shy
				if(stateFlag==0){
	        		$("#adtRedFlag"+rowData.auditId).css({"display":"block"});;
	        	}
	        }
	    },
		onLoadSuccess:function(data){
			if ("string" == typeof data )		//超时结束轮询
			{     
				if (data.toLowerCase().indexOf("logon")>-1 || data.toLowerCase().indexOf("login")>-1)
				{      
					clearInterval(loopPointer);
				} 
			}
			var newtask = data.newtask;
			var contask = data.contask;
			var comtask = data.comtask;
			var mustedit = data.mustedit;
			var dblcheck = data.dblcheck;
			var pass = data.pass;
			$("#tt-keywords ul li").each(function(index){
				if(index==0){
					newTitile = "新任务("+ newtask +")";
				}
				if(index==1){
					newTitile = "已完成("+ comtask +")";
				}
				if(index==2){
					newTitile = "必须修改("+ mustedit +")";
				}
				if(index==3){
					newTitile = "双签通过("+ dblcheck +")";
				}
				if(index==4){
					newTitile = "通过("+ pass +")";
				}
				if(index==5){
				}
				updTabsTitle(index,newTitile);
				
		    });
			///选中已选列表
			var rows = $("#auditList").datagrid('getRows');
            for(var i=0; i<rows.length; i++ )
            {
	            if(rows[i].auditId==auditId)
	            {
		            $('#auditList').datagrid('selectRow',i);
				}
				if((rows[i].readFlag=="Y")&&(stateFlag==0)){
					$("#adtRedFlag"+rows[i].auditId).css({"display":"block"});
				}
	         }
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            
            itemSelFlag = 1;  /// 已选列表当前状态值
            $("#auditList").datagrid('selectRow',selectIndex);
            var rowData = $("#auditList").datagrid('getSelected');
            if(rowData != null){
	            var overReadTime = rowData.overReadTime;
	            var readFlag = rowData.readFlag;
	            var time = "";
	           	if(overReadTime>OverTime){
		           	time = overReadTime;
		        }else{
			       	time = OverTime;
			    }
	            $("#rematime").html(time-rowData.imdtime);
	            if((time-rowData.imdtime)<5){
		            $("#rematime").html(0);
		        }
            }
            //BindTips(); /// 绑定提示消息
		},
		rowStyler:function(index,rowData){   
	        if (rowData.repStatCode == "停止"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onLoadError:function(){
		  	console.log("审方列表获取数据异常,停止自动轮训!");
			if(loopPointer) clearInterval(loopPointer); 
		}
	};
	var searchNo=$("#search").searchbox('getValue');  //xww 2022-03-03 处方号，登记号或就诊号
	var params = stdate + "^" + enddate + "^" + stateFlag + "^"+ LgUserID + "^" + res + "^" + searchNo + "^" + "" + "^" +MenuModule;
	var uniturl = $URL +"?ClassName=web.DHCPRESCAudit&MethodName=QueryAuditList&params="+params;
	new ListComponent('auditList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#auditList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  隐藏分页图标
    var panel = $("#auditList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
    
}

///刷新审核列表
function reloadAuditList(serachFlag)
{
	var selectPatientId = "";
	if((patNumFlag==1)&&(serachFlag!=1)){
		selectPatientId = patientId;
	}

	var searchNo=$("#search").searchbox('getValue');  //xww 2022-03-03 处方号，登记号或就诊号
	var params = stdate + "^" + enddate + "^" + stateFlag + "^"+ LgUserID + "^" + res + "^" + searchNo + "^" + selectPatientId + "^" +MenuModule; 
	$("#auditList").datagrid("reload");
}

//xww 2022-03-03
function reloadAuditListByPat(){
	patNumFlag=1;
	reloadAuditList();
}

function searchAuditList(){
	
	var inPatNo = $('#search').searchbox('getValue');
	var patNo = GetWholePatNo(inPatNo);
	$('#search').searchbox("setValue",patNo)
	reloadAuditList(1);
}

// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){
	var patType='';
	if(rowData.patType=="E"){
		patType='<span style="color:red">(急)</span>'
	}
	var htmlstr = '<div class="celllabel">'
	 	htmlstr = htmlstr + '<h3 style="float:left;background-color:transparent;">'+ rowData.patName +patType+'</h3><span style="float:right;background-color:transparent;font-size:5px;">'+ rowData.prescNo +'</span><br>'
	 	htmlstr = htmlstr + '<span style="float:right;color:rgb(1,123,206);background-color:transparent;font-size:10px;padding-top:5px;font-weight:bold;display:none;" id=adtRedFlag'+rowData.auditId+'>阅 '+rowData.readTime+'</span><br>';	 	
	 	htmlstr = htmlstr + '<span style="float:left;background-color:transparent;font-size:10px;padding-top:5px;">'+ rowData.locDesc+'</span>'
		htmlstr = htmlstr + '<span style="float:right;color:red;background-color:transparent;font-size:10px;padding-top:5px;">'+ rowData.imdtime +'</span><br>';
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

///加载患者基本信息
function LoadPatInfo(rowData)
{
	var patNameHtml='<a style="text-decoration:underline" href="#" onclick="reloadAuditListByPat()">('+rowData.patNum+')</a>';  //\''+rowData.patientId+'\'
	$("#patName").html(rowData.patName);		
	$("#sex").html(rowData.patSex);	
	$("#age").html(rowData.patAge);
	var weight = rowData.weight;
	if(weight!="")
	{
		weight = weight+"kg";
	}
	$("#weight").html(weight);
	$("#patNo").html(rowData.patNo);
	$("#admNo").html(rowData.admNo);
	$("#loc").html(rowData.locDesc);
	$("#doc").html(rowData.docDesc);
	$("#diag").html(rowData.spdiag);
	$("#chndiag").html(rowData.dischdiag)
	$("#docname").html(rowData.docDesc);
	$("#docimg").attr('src',"../scripts/dhcnewpro/dhcpresc/images/doc.png");
	$("#docimg").css({'width':50});
	$("#admId").val(rowData.admId);
	$("#patientId").val(rowData.patientId);
	$("#mradm").val(rowData.mradm);
	$("#locTelphone").html(rowData.locTelPhone);
	$("#docTelphone").html(rowData.docPhone);
	$("#audremark").html(rowData.docremark);
	var params = "Audit"+"^"+rowData.docId;
	//againFlushNumber(params);
	//setInterval(function(){
	//		againFlushNumber(params)
	//},5000);
	
	BindTips(rowData.diag,rowData.chndiag);
}

///加载处方信息
function LoadPrescNo(auditId)
{
	runClassMethod("web.DHCPRESCAudit","GetPrescNo",{"auditId":auditId},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			if(json.length!=0)
			{
				if(json[0].cat=="中草药"){
					AppendHerbaHtml(json);
				}else{
					AppendPrescHtml(json);
				}
			}
	},'text');
}
///处理的中草药的html
function AppendHerbaHtml(json)
{
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	var prescNo = json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >处方</span>");
	$row.append("<span class='presc-no'>"+prescNo+"</span>");
	$prescInfo.append($row);
	
	for(var i=0;i<length;i++){
		var drugDesc = json[i].drugDesc;
		var drugCode = json[i].drugCode;
		var onceDose = json[i].onceDose; //剂量 单位
		var $cols = $("<div class='presc-drug' style='float:left;min-width:160px;width:30%'></div>");
		$prescInfo.append($cols);
		var spanHtml = "<span class='presc-text'>"+drugDesc+" "+onceDose+"</span><a href='javascript:void(0);' onclick='litratrue(this)' style='float:right;padding-right:5px;' value='"+drugDesc+"'";
		spanHtml = spanHtml + "data-code='"+drugCode+"' data-libId= '"+json[i].libDrugId+ "' data-libCode='"+json[i].libDrugCode+"' data-libDesc='"+json[i].libDrugDesc+ "'><img src='../scripts/dhcnewpro/dhcpresc/images/lit.png' style='height:18px'/></a>";
		if(((i+1)%3)==0){
			spanHtml=spanHtml+"<br>";
		}
		$cols.append(spanHtml);
	}
	
	var $dashline = $('<div class="dasline" style="clear:both"></div>');
	$prescInfo.append($dashline);
	
	var freq = json[0].freq;
	var treatment = json[0].treatment;
	var preMet = json[0].preMet;
	var PrescQty = json[0].PrescQty;
	var $usecols = $("<div class='presc-pre'></div>");
	$prescInfo.append($usecols);
	$usecols.append("<span>共"+treatment+"</span>");
	$usecols.append("<span class='presc-use'>用法：</span>");
	$usecols.append("<span>"+ preMet + " " + freq +"</span>");
	$usecols.append("<span class='presc-use'>一次用量：</span>");
	$usecols.append("<span>"+ PrescQty +"</span>");



	
}
///处理处方的html
function AppendPrescHtml(json)
{
	
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	var prescNo = json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >处方</span>");
	$row.append("<span class='presc-no'>"+prescNo+"</span>");
	$prescInfo.append($row);
	
	for(var i=0;i<length;i++){
		var drugDesc = json[i].drugDesc;
		var drugCode = json[i].drugCode;
		var onceDose = json[i].onceDose;
		var preMet = json[i].preMet;
		var freq = json[i].freq;
		var treatment = json[i].treatment;
		var $cols = $("<div class='presc-drug'></div>");
		$prescInfo.append($cols);
		$cols.append("<span>"+(i+1)+"</span>");
		var spanHtml = "<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class='presc-text'>"+drugDesc+"</span><a  href='javascript:void(0);' onclick='litratrue(this)' style='float:right;padding-right:20px;' value='"+drugDesc+"'";
		spanHtml = spanHtml + "data-code='"+drugCode+"' data-libId= '"+json[i].libDrugId+ "' data-libCode='"+json[i].libDrugCode+"' data-libDesc='"+json[i].libDrugDesc+ "'><img src='../scripts/dhcnewpro/dhcpresc/images/lit.png' style='height:18px'/></a><br>";
	
		$cols.append(spanHtml);
	
		
		var $usecols = $("<div class='presc-pre'></div>");
		$prescInfo.append($usecols);
		$usecols.append("<span class='presc-use'>单次剂量：</span>");
		$usecols.append("<span>"+ onceDose +"</span>");
		$usecols.append("<span class='presc-use'>给药途径：</span>");
		$usecols.append("<span>"+ preMet +"</span>");
		$usecols.append("<span class='presc-use'>频次：</span>");
		$usecols.append("<span>"+ freq +"</span>");
		$usecols.append("<span class='presc-use'>疗程：</span>");
		$usecols.append("<span>"+ treatment +"</span>");
		
		var $entrust = $("<div class='entrust'></div>");
		$prescInfo.append($entrust);
		var $contmore = $("<div class='contmore'></div>");
		$entrust.append($contmore);
		if(i<1){
			$contmore.append("<span></span>")

		}
		var $dashline = $('<div  id="dasline"></div>');
		if(i<length-1){
			$prescInfo.append($dashline);
		}
	}
}

///加载审查问题
function LoadPrescPro(auditId){
	
	runClassMethod("web.DHCPRESCAudit","GetAuditInfo",{"auditId":auditId},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendProbHtml(json);
	},'text');
}

///处理问题html
function AppendProbHtml(retJson)
{
	var $probInfo = $("#proInfo");
	$probInfo.empty();
	if ($.isEmptyObject(retJson)){
		return;	
	}
	var itemsArr = retJson.items;
	var arr = [];
	var keyArr = [];
	var manLevArr = [];
	//抽取json内容，获取一组对象
	for (var i = 0; i < itemsArr.length; i++){
		var warnsArr = itemsArr[i].warns;
		for (var j = 0; j < warnsArr.length; j++){
			var msgItmsArr = warnsArr[j].itms;
			for (var k = 0; k < msgItmsArr.length; k++){
				var valItemArr = msgItmsArr[k].itms;
				for (var x = 0; x < valItemArr.length; x++){
					var obj = {};
						obj.item = itemsArr[i].item;
						obj.manLev = warnsArr[j].manLev;
						obj.keyname = warnsArr[j].keyname;
						obj.val = valItemArr[x].val;
						arr.push(obj);
				}
			}
		}		
	}
	
	//按照提示等级和种类分类，去重
	for (var n = 0; n < arr.length; n++){
		keyArr.push(arr[n].keyname);
		keyArr = unique(keyArr);
	}
	for (var m = 0; m < keyArr.length; m++){
		//创建卡片
		var $keyCard = $("<div style=\"background-color:#FFFCF7;margin:20px 10px 10px 10px;height:auto;border:1px dashed #ccc;padding:10px;position:relative\"></div>");
		$probInfo.append($keyCard);	
		var manLevArr = [];
		for (var p = 0; p < arr.length; p++){
			if (arr[p].keyname == keyArr[m]){
				manLevArr.push(arr[p].manLev);	
			}	
		}
		manLevArr = unique(manLevArr);
		for (var o = 0; o < manLevArr.length; o++){
			//三目运算符处理图标和边框颜色
			var manLevIcon = (manLevArr[o] == "提示") ? "tips.png" : (manLevArr[o] == "提醒" ? "remind.png" :(manLevArr[o] == "警示" ? "warn.png" : (manLevArr[o] == "禁止" ? "forbid.png" : "")))
			var manLevcolor = (manLevArr[o] == "提示") ? color[0] : (manLevArr[o] == "提醒" ? color[1] :(manLevArr[o] == "警示" ? color[2] : (manLevArr[o] == "禁止" ? color[3] : "")))
			var $manLev = $("<div><img style=\"height:30px;position:absolute;left:-5px;top:-15px\" src = \""+ imgurl +""+manLevIcon+"\"/></div>");
			var $infoCard = $("<div style=\"margin-top:-20px;padding:5px;width:70%;\"></div>");
			$keyCard.append($manLev);
			$keyCard.append("<div style=\"width:25%;text-align:right;float:right;margin-top:15px;margin-right:30px;color:"+ manLevcolor +"\"><b>"+keyArr[m]+"</b></div>");
			$keyCard.append("<div style='clear:both;width:0px'></div>");	//空白容器撑开盒子
			for (var r = 0; r < arr.length; r++){
				if (arr[r].keyname == keyArr[m]&&arr[r].manLev == manLevArr[o]){
					$infoCard.append("<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>")
					$infoCard.append(arr[r].item+"<br/>");
					$infoCard.append("<div style=\"color:#676360;font-size:12px;margin-left:25px;\">"+arr[r].val+"<br/></div>");	
				}	
			}
			$keyCard.append($infoCard);
		}
	}
}

///初始化审核建议
function LoadAuditRes(auditId)
{
	runClassMethod("web.DHCPRESCAudit","GetAuditRes",{"auditId":auditId},
		function(ret){
			if(ret!=""){
				var itmId = ret.split("^")[0];
				
				var result = ret.split("^")[1];
				
				var audres = ret.split("^")[2];
				$("#inselitm").combobox("setValue",itmId);
				$("#remark").val(result);
				$("#audres").html(audres);
			}
			
	},'text');
}
///初始化下拉框
function initCombobox()
{
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#inselitm",{
		url:uniturl+"QueryDicItem&code=RIT&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode:'remote',
		onSelect:function(ret){
			
		 }
	})	
}

///更新TabsTitle
function updTabsTitle(index,newtitle)
{
	var  tab = $('#tt-keywords' ).tabs( 'getTab' ,index); 
	$( '#tt-keywords' ).tabs( 'update' , {
         tab: tab,
         options: {
            title:  newtitle
         }
	});
}

///初始化按钮
function initButton()
{
	$("#mody").bind('click',modify);    	//必须修改
	//$("#signrev").bind('click',signrev);    //双签复核
	$("#signpass").bind('click',signpass);  //双签通过
	$("#pass").bind('click',auditpass);    	//通过
	
	/// tabs 选项卡
	$("#tt-keywords").tabs({
		onSelect:function(title){
		   if (itemSelFlag == 1){
			  clearInfo()
			  patNumFlag="";
			  auditId = "";
		   	  LoadPrescList(title);
		   	  LoadPrescNo(auditId);			//加载处方信息
			  LoadPrescPro(auditId);		//加载审查问题
			  LoadButtons();				//处理页面按钮
		   }
		}
	});
	
	/// tabs 选项卡
	$("#presc-keywords").tabs({
		onSelect:function(title){
		   if (title == "检验信息"){
				initLisDatagrid();
		   }else if(title == "检查信息"){
			   initInsDatagrid();
		   }
		}
	});
	
	//$("#docname").bind('click',linkChat);    	//姓名链接
	
	$("#away").bind('click',leademobil);		//离开
	
	$("#batch").bind('click',OpenBatchWin);		//批量审核
	
	$("#collection").bind('click',OpenCaseCollectionWin);			//案例收藏
	
	$("#aa").bind('click',ChangeStyle);			//案例收藏
	
	$("#admNo").bind('click',panoview);			//跳转全景视图
	
}

///初始化列表
function LoadPrescList(title)
{
	if (title.indexOf("新任务")>=0){ 
		stateFlag = "0";
		res = "";
	}else if (title.indexOf("待确认")>=0){
		stateFlag = "1";
	}else if (title.indexOf("必须修改")>=0){
		stateFlag = "2";
		res = "STA01";	
	}else if(title.indexOf("双签通过")>=0){
		stateFlag = "2";
		res = "STA03";	
	}else if (title.indexOf("通过")>=0){
		stateFlag = "2";
		res = "STA04";	
	}else{
		stateFlag = "2";
		res = "";	
	}
	var searchNo=$("#search").searchbox('getValue');  //xww 2022-03-03 处方号，登记号或就诊号

	var params = stdate + "^" + enddate + "^" + stateFlag + "^"+ LgUserID + "^" + res + "^" + searchNo + "^" + "" + "^" +MenuModule;
	$("#auditList").datagrid("load",{"params":params});
}

///必须修改
function modify()
{
	var code = "STA01";
	saveAuditRes(code);
	
}

///双签复核
function signrev()
{
	var code = "STA02";
	saveAuditRes(code);
	
}

///双签通过
function signpass()
{
	var code = "STA03";
	saveAuditRes(code);
	
}

///通过
function auditpass()
{
	var code = "STA04";
	saveAuditRes(code);
	
}

///保存审核结果
function saveAuditRes(stateCode)
{
	var rowData = $("#auditList").datagrid('getSelected');
	if(rowData==null){
		$.messager.alert("提示","请选择待审核数据！","info");
		return;
	}
	var itemId = $HUI.combobox("#inselitm").getValue();		//便捷录入项目
	var remark = $("#remark").val();						//备注
	var readCode = 0;
	var listData = auditId +"^"+ itemId +"^"+ LgUserID +"^"+ stateCode +"^"+ readCode +"^"+ remark+"^"+LgCtLocID;
	runClassMethod(
		"web.DHCPRESCAudit",
		"saveAuditInfo",
		{
			"listData":listData
		},
		function(ret){
			if(ret==0){
				$.messager.alert('提示',"处理成功！","info");
				reloadAuditList();
				clearInfo();
				return;
			}else{
				$.messager.alert('提示',"处理失败！"+ret,"error");
				return;
			}
		}
	,'text');
	$HUI.combobox("#inselitm").setValue("");
	$("#remark").val("");
	
}

///处理折叠内容
function initContentfold()
{
	var slidHeight = 40;
	$(".contmore").each(function(){
         var curHeight = $(this).height();
         if(curHeight>slidHeight) {
              $(this).css("height",slidHeight); 
              $(this).after("<a class='toggle-btn' value="+curHeight+">展开</a>");
         }
    });
    
    $(".toggle-btn").click(function(){
	    debugger;
	     var oldheight = $(this).attr("value");
	     var curHeight = $(this).parent().children(".contmore").height();
	     if(curHeight == slidHeight){
				$(this).parent().children(".contmore").animate({
					'height':oldheight
				},'normal')
				$(this).html('折叠');
				$(this).css("background","url(../images/fa-angle-double-up_40a2de_12.png) no-repeat center");
		 }else{
				$(this).parent().children(".contmore").animate({
					'height':slidHeight
				},'normal')
				$(this).html('展开');
				$(this).css("background","url(../images/fa-angle-double-down_40a2de_12.png) no-repeat center");
		 }
    });
}

///链接聊天窗口
function linkChat()
{
	/*_openMassTalkPage(auditId);
	return;*/

	if ('undefined'!==typeof websys_getMWToken){
		var url = "dhcpresc.newscontact.csp?";
		url += "MWToken="+websys_getMWToken();
		url += "&userType=Audit&auditId="+auditId;
	}else{
		var url = "dhcpresc.newscontact.csp?";
		url += "userType=Audit&auditId="+auditId;
	}
	
	$("#newsContact").attr("src",url);
	
	if($("#newsWin").hasClass("panel-body")){
		$("#newsWin").window("open");
	}else{
		$("#newsWin").window({
			iconCls:'icon-w-save',
			resizable:true,
			modal:false,
			isTopZindex:true
		});
	}
}

///批量审核界面
function OpenBatchWin()
{
	var width = (document.documentElement.clientWidth-100);
	var height = (document.documentElement.clientHeight-100);

	var lnk = "dhcpresc.batchview.csp?MenuModule="+MenuModule;
	websys_showModal({
		url:lnk,
		title:'批量审核',
		iconCls:'icon-w-save',
		width:width,
		height:height,
		top:(document.documentElement.clientWidth-width)/2,
		left:(document.documentElement.clientHeight-height)/2,
		onClose: function() {
			
		}
	});
}

///案例收藏界面 $('#aaa').validatebox({required:false});
function OpenCaseCollectionWin()
{
	if (auditId=="")
	{
		$.messager.alert("提示","请选择处方收藏分享！","warning")
		return ;	
	}
	
	var width = (document.documentElement.clientWidth-100);
	var height = (document.documentElement.clientHeight-100);
	var lnk = "dhcpresc.casecollection.csp?AuditId="+auditId;
	websys_showModal({
		url:lnk,
		title:'案例收藏分享',
		iconCls:'icon-w-save',
		width:width,
		height:height,
		top:(document.documentElement.clientWidth-width)/2,
		left:(document.documentElement.clientHeight-height)/2,
		onClose: function() {
			
		}
	});
}
///案例收藏分享图标样式修改 lidong	
function ChangeStyle()
{	
	/* $('#collection').linkbutton({iconCls:'icon-star'}); */
	runClassMethod("web.DHCPrescCaseCollection","CheckCollect",{"AuditId":auditId},function(getString){
		if (getString == 'Y'){
			$('#collection').linkbutton({iconCls:'icon-star'});	
		}else if (getString == ''){
			$('#collection').linkbutton({iconCls:'icon-star-empty'});
			}
	},'text');
}
///调用说明书
function litratrue(obj)
{
	var drugCode = $(obj).attr("data-code");
	var drugDesc = $(obj).attr("value");
	var libId = $(obj).attr("data-libid");
	if(isOwnSys==1){
		getDrugIns_click(drugCode,drugDesc);
	}else{
		
		if (libId!="0"){
			
			if ('undefined'!==typeof websys_getMWToken){
				var url = "dhcckb.pdss.instruction.csp?";
				url += "MWToken="+websys_getMWToken();
				url += "&IncId="+libId;
			}else{
				var url = "dhcckb.pdss.instruction.csp?";
				url += "IncId="+libId;
			}
			
		}else{
			
			if ('undefined'!==typeof websys_getMWToken){
				var url = "dhcckb.pdss.instruction.csp?";
				url += "MWToken="+websys_getMWToken();
				url += "&IncId=&IncCode="+drugCode+"&IncDesc="+encodeURI(drugDesc);
			}else{
				var url = "dhcckb.pdss.instruction.csp?";
				url += "IncId=&IncCode="+drugCode+"&IncDesc="+encodeURI(drugDesc);
			}
			
		}
		var width = (document.documentElement.clientWidth-100);
		var height = (document.documentElement.clientHeight-100);

		websys_showModal({
			url:url,
			title:'药品说明书',
			width:width,
			height:height,
			top:(document.documentElement.clientWidth-width)/2,
			left:(document.documentElement.clientHeight-height)/2,
			onClose: function() {
				
			}
		});
	}
}

///引用数据
function OpenEmrO()
{
	var admId = $("#admId").val();
	var patientId = $("#patientId").val();
	var url="dhcem.consultpatemr.csp?";
	if ('undefined'!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	url += "&EpisodeID="+admId+"&PatientID="+patientId+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.open(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1'); 
	try{
		if (result){
			if ($("#remark").val() == ""){
				$("#remark").val(result.innertTexts);  		/// 简要病历
			}else{
				$("#remark").val($("#remark").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
			}
		}
	}catch(ex){}
}

///离开
function leademobil()
{
		$.messager.confirm("提示", "选择离开，将不再新增审核任务？", function (res) {//提示是否删除
			if (res) {
				runClassMethod(
					"web.DHCPRESCAudit",
					"updScheState",
					{
						"userId":LgUserID,
						"state":"离线",
					},
					function(ret){
						if(ret==1){
							$.messager.alert('提示',"您未选择审核科室，请先在审方资源管理页面维护！","warning");
							return;
						}else if(ret==0){
							initCompent();      //操作成功直接判断离线状态显示 shy 2023-1-16
							//$.messager.alert('提示',"操作成功！");
							return;
						}else{
							$.messager.alert('提示',"处理失败！"+ret,"error");
							return;
						}
					}
				,'text');
			}
		});
}

///开始监测
function auditStart(){
		runClassMethod(
			"web.DHCPRESCAudit",
			"updScheState",
			{
				"userId":LgUserID,
				"state":"在线",
			},
			function(ret){
				if(ret==1){
					$.messager.alert('提示',"您未选择审核科室，请先在审方资源管理页面维护！","warning");
					return;
				}else if(ret==0){
					$HUI.dialog('#onlinedialog').close();
					return;
				}else{
					$.messager.alert('提示',"处理失败！"+ret,"error");
					return;
				}
			}
		,'text');
}
///影藏演示页面内容
function LoadButtons(){
	if(stateFlag == 0){
		$("#timelabel").show();
		$("#rematime").show();
		$("#QueEmr").show();
		$("#mody").show();
		$("#signpass").show();
		$("#pass").show();
		$("#audreslabel").hide();
		$("#audres").hide();
		
		
	}else{
		$("#timelabel").hide();
		$("#rematime").hide();
		$("#QueEmr").hide();
		$("#mody").hide();
		$("#signpass").hide();
		$("#pass").hide();
		$("#audreslabel").show();
		$("#audres").show();
	}
}

/*检验信息*/
/*查询日期*/
function initDateBox(){
	$HUI.datebox("#sel-stDate",{});
	$HUI.datebox("#sel-edDate",{});	
	$HUI.datebox("#sel-stDate").setValue(formatDate(0));
	$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

/*更新列表*/
function upLisDate(event,value){	
	if(value){
		switch ($(event.target).attr("id")){
			case "radio1":
				$HUI.datebox("#sel-stDate").setValue(formatDate(0));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio2":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-30));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio3":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-180));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio4":
				$HUI.datebox("#sel-stDate").setValue("");
				$HUI.datebox("#sel-edDate").setValue("");
				break;
		}
	}
}

/*检验报告*/
function initLisDatagrid()
{
	///  定义columns
	var columns=[[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '检验号', width: 105, sortable: false, align: 'center' },
          { field: 'OrdItemName', title: '医嘱名称', width: 200, sortable: false, align: 'left' },
          { field: 'AuthDateTime', title: '报告日期', width: 150, sortable: false, align: 'center' },
          { field: 'PatName', title: '姓名', width: 80, sortable: false, align: 'center' },
          { field: 'Order', title: '预报告', width: 55, sortable: true, align: 'center'},
          { field: 'ResultStatus', title: '结果状态', width:100, sortable: false, align: 'center'},
		  { field: 'PrintFlag', title: '打印', width: 40, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
				if (rowData.ResultStatus != "3") return "";
				if(value=="Y"){
					return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="已打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}else if(value=="N"){
					return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="本人未打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}
             }
          },
          { field: 'ReadFlag', title: '阅读', width: 40, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") return "";
	        	if (value == "1") {
		        	return "<span class='icon-book_open' color='red' title='已阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}else {
		        	return "<span class='icon-book_go' color='red' title='未阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}  	
	        } 
          },
          { field: 'WarnComm', title: '危急提示', width: 150, sortable: false, align: 'left'},
          { field: 'ReceiveNotes', title: '标本备注', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '报告评价', width: 150, sortable: false, align: 'left' },
          { field: 'ReqDateTime', title: '申请日期', width: 150, sortable: false, align: 'center' },
          { field: 'SpecDateTime', title: '采集日期', width: 150, sortable: false, align: 'center' },
          { field: 'RecDateTime', title: '接收日期', width: 150, sortable: false, align: 'center' },
          { field: 'VisitNumberReportDR', title: '报告ID', width: 100, sortable: false, align: 'center' },
        ]]
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		toolbar:[],
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        
			reloadOrdDetailTable(rowData.VisitNumberReportDR);
	    },
		onLoadSuccess:function(data){
			
		}
	};
	
	var params = admId +"^"+ patientId +"^"+ "" +"^"+ "" + "^^0^^^"+""+"^0^^^^Y"+"^"+""+"^"+""+"^"+""+"^"+"";
	var uniturl = $URL +"?ClassName=web.DHCPRESCQuery&MethodName=GetLisHisList&params="+params;
	
	new ListComponent('lisOrdTable', columns, uniturl, option).Init();
	
	var columns=[[
    	{ field: 'Synonym',align: 'center', title: '缩写',width:45},
        { field: 'TestCodeName',align: 'center', title: '项目名称',width:60},
        { field: 'Result',align: 'center', title: '结果',width:45},
		{ field: 'ExtraRes',align: 'center', title: '结果提示'},
		{ field: 'AbFlag',align: 'center', title: '异常提示',width:45},
		{ field: 'HelpDisInfo',align: 'center', title: '辅助诊断',width:65},
		{ field: 'Units',align: 'center', title: '单位'},
		{ field: 'RefRanges',align: 'center', title: '参考范围',width:49},
		{ field: 'PreResult',align: 'center', title: '历次',width:35}, 
		{ field: 'PreAbFlag', align: 'center',title: '前次异常提示',hidden: true}
 	]];
 	
 	///  定义datagrid
	var option = {
		//showHeader:false,
		toolbar:[],
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			
		}
	};
	
	var uniturl = $URL +"?ClassName=web.DHCPRESCQuery&MethodName=GetLisDetList&reportId=";
	new ListComponent('lisOrdDetailTable', columns, uniturl, option).Init();
}

///初始化检查列表
function initInsDatagrid()
{
	var Params=""
	var stDate = "";
	var edDate = "";
	Params= admId +"^"+ patientId +"^"+ stDate +"^"+ edDate +"^"+ LgUserID+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	ReqNo = "",OEORIID="";
	var columns=[[
		{ field: 'lx',align: 'center', title: '类型',formatter:formatterlx},
    	{ field: 'AdmLoc',align: 'center', title: '就诊科室'},
    	{ field: 'ReqNo',align: 'center', title: '申请单号'},
    	{ field: 'StudyNo',align: 'center', title: '检查号'},
    	{ field: 'strOrderName',align: 'center', title: '检查名称'},
    	{ field: 'strOrderDate',align: 'center', title: '申请日期'},
    	{ field: 'ItemStatus',align: 'center', title: '检查状态'},
    	{ field: 'recLocName',align: 'center', title: '检查科室'},
    	{ field: 'IsCVR',align: 'center', title: '危急值报告'},
    	{ field: 'IsIll',align: 'center', title: '是否阳性',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '是';} 
				else {return '否';}
			}}, 
    	{ field: 'IshasImg',align: 'center', title: '是否有图像',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '是';} 
				else {return '否';}
    		}
    	},
    	{ field: 'Grade',align: 'center', title: '评级',hidden:true},
    	{ field: 'OEORIId',align: 'center', title: '医嘱ID'},
    	{ field: 'PortUrl',align: 'center', title: 'PortUrl',hidden:'true'}
 
 	]]; 

 	$HUI.datagrid('#inspectDetail',{
		url:$URL+"?ClassName=web.DHCPRESCQuery&MethodName=GetInspectOrd&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:false,
		pageSize:10,  
		pageList:[10,15,20], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		border:false,//hxy 2018-10-22
		rowStyler: function(index,row){
			
		},
		onLoadSuccess:function(data){
			if((data.rows.length=="1")&&(ReqNo!="")){
				
			}
		}
	});	
}
/*调用打印标记*/
function ShowPrintHistory()
{
	
}

/// 数组去重方法
function unique(arr) {
    if (!Array.isArray(arr)) {
        console.log('type error!')
        return
    }
    var array = [];
    for (var i = 0; i < arr.length; i++) {
        if (array .indexOf(arr[i]) === -1) {
            array .push(arr[i])
        }
    }
    return array;
}

///加载检验列表
function reaLoadLis()
{
	var params = admId +"^"+ patientId+"^"+ "" +"^"+ "";
	params = params + "^^0^^^"+""+"^0^^^^Y"+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	$HUI.datagrid('#lisOrdTable').load({
		params:params
	})

}

function reloadOrdDetailTable(portId){
	
	$HUI.datagrid('#lisOrdDetailTable').load({
		reportId:portId
	})
}

function formatterlx(value,rowData){
	if(rowData.BLOrJC==0){
		return "检查";
	}
	
	if(rowData.BLOrJC==1){
		return "病理";
	}
}
//审方主表添加阅读标记
function setReadFlag(auditId)
{
	runClassMethod("web.DHCPRESCAudit","SetReadFlag",{"AuditId":auditId},
		function(jsonString){
		//重新计时 超时自动通过
		//setTimeout("ReadOverTime()", OverTime*1000);   //18000需要改为配置     阅读18s超时自动通过
	},'text',true);	
}
//shy 阅读超时自动通过
function ReadOverTime()
{
	runClassMethod("web.DHCPRESCAudit","OverPrescAuditStatus",{"auditId":auditId},
		function(jsonString){
		$.messager.popover({
				msg: '审核超时自动通过！',
				timeout: 2000,
				type: 'alert'
			});
		reloadAuditList();
		$HUI.combobox("#inselitm").setValue("");
		$("#remark").val("超时自动通过");
		//隐藏按钮
		$("#timelabel").hide();
		$("#rematime").hide();
		$("#QueEmr").hide();
		$("#mody").hide();
		$("#signpass").hide();
		$("#pass").hide();
		$("#audreslabel").hide();
		$("#audres").hide();
		
	},'text');	
}

///跳转到全景视图
function panoview()
{
	var admId = $("#admId").val();
	var patientId = $("#patientId").val();
	var mradm = $("#mradm").val();
	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'病历浏览列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	if ('undefined'!==typeof websys_getMWToken){
		var link="websys.chartbook.hisui.csp?";
		link += "MWToken="+websys_getMWToken();
		link += "&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=&SwitchSysPat=N&ChartBookID=70&PatientID="+ patientId +"&EpisodeID="+ admId +"&mradm="+ mradm +"&WardID=";

	}else{
		var link="websys.chartbook.hisui.csp";
		link += "&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=&SwitchSysPat=N&ChartBookID=70&PatientID="+ patientId +"&EpisodeID="+ admId +"&mradm="+ mradm +"&WardID=";

	}
	

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+link+'"></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
}
function againFlushNumber(params)
{
	$cm({
			ClassName:"web.DHCPRESCAuditPopup",
			MethodName:"MainUnReadList",
			Params:params
		},function(data){
			var allMsgNum=data.AllMsgNum;
			$("#msgnum").html(allMsgNum);
		}
	)
}
function OpenEmr()
{	
	var admId = $("#admId").val();
	var patientId = $("#patientId").val();
	$HUI.dialog('#oeordWin').open();
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'ck',title:'操作',checkbox:'true',width:80,align:'left'}, 
		{field:'Code',title:'医嘱代码',width:250,align:'center'},
		{field:'Desc',title:'医嘱描述',width:250,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		bordr:false,
		fit:true,
		fitColumns:true,
		//singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90]
	};
	var uniturl = $URL+"?ClassName=web.DHCPRESCQuery&MethodName=GetAdmOeordInfo&Adm="+admId;
	new ListComponent('oeordList', columns, uniturl, option).Init(); 
}
function DrawInfo()
{
	var selecItmStr=$("#oeordList").datagrid('getChecked');
	var resinfo = '';
	    for (var k = 0; k < selecItmStr.length; k++) {
	        if (resinfo != '')
	            resinfo += ',';
	        resinfo += selecItmStr[k].Desc;
	    }	
	    var remarkinfo = $("#remark").val()+""+resinfo;
	    $("#remark").val(remarkinfo)
	    $HUI.dialog('#oeordWin').close();
	    
}

///清空页面信息
function clearInfo()
{
	$("#patName").html("");
	$("#sex").html("");
	$("#age").html("");
	$("#weight").html("");
	$("#patNo").html("");
	$("#admNo").html("");
	$("#loc").html("");
	$("#doc").html("");
	$("#diag").html("");
	$("#chndiag").html("");
	$("#audremark").html("");
	$("#locTelphone").html("");
	$("#docTelphone").html("");
	$("#rematime").html("");
	//$("#inselitm").combotree("setValue","");
	$("#remark").html("");
	$("#audres").html("");
	$("#docname").html("");
	$("#proInfo").html("");
	$("#prescInfo").html("");
	$("#msgnum").html("");
	
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

function BindTips(diag,chndiag)
{
	var html='<div id="tip" style="border-radius:3px;display:none;border:1px solid #000;padding:10px;position:absolute;background-color:#000;color:#fff;"></div>'
	$('body').append(html);
	/// 鼠标离开
	$('#diag,#chndiag').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('#diag').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text(diag);    // .text()
		}
	})
	
	/// 鼠标移动
	$('#chndiag').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text(chndiag);    // .text()
		}
	})
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
