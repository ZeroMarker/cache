//页面Gui
function InitASPOrdItemWin(){
	var obj = new Object();
	
	$.form.SelectRender("cboRuleAnti");  //渲染下拉框
	//初始化高度
	var wh = $(window).height();
	$("body").height(wh-10);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("body").height(wh-10);
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	//初始化
	obj.column = 20;   //默认列数
	//表头日期默认昨天
	obj.DateTo = (EndDate == '') ? $.form.DateArr($.form.GetCurrDate("-"),2)[0] : EndDate;
	obj.ViewIcon = [		//图例
		["div","#FFE1E1","长期医嘱"],
		["div","#FFCC66","临时医嘱"],
		["div","#FF0000","长期医嘱+临时医嘱"],
		["img","../Scripts/dhchai/img/timeline.png","干预"]
	];
	obj.MethodCodes	= {		//合理/不合理/需关注处置方案Code-对应字典IRASPOpinionType
		"inReason" : {
			"title" : "备注",
			"CodeList" : [7]
		},
		"outReason" : {
			"title" : "建议调整方式",
			"CodeList" : [1,2,3,4,5,6]
		},
		"follow" : {
			"title" : "备注",
			"CodeList" : [7]
		}
	};
	
	// 渲染图例
	for(var i=0; i<obj.ViewIcon.length; i++){
		if (obj.ViewIcon[i][0]=="div") {
			var tmpViewIcon = '<div><div class="pull-left" style="background-color:'+ obj.ViewIcon[i][1] +';width:14px;height:14px;margin-top:3px;"></div>&nbsp;'+ obj.ViewIcon[i][2] +'</div>';
		}else{
			var tmpViewIcon = '<img src='+ obj.ViewIcon[i][1] +'>'+ obj.ViewIcon[i][2];
		}
		$('#img_span').append(tmpViewIcon);
	}
	//绘制表头
	obj.Viewtitle   = "<tr><td>日期</td>";
	var DataListArr = $.form.DateArr(obj.DateTo, obj.column);
	for (var i=0; i<DataListArr.length; i++) {
		obj.Viewtitle += '<td id="dateTitle_' + (i+1) + '">'+ parseDate(DataListArr[i]).Format("MMdd") +'</td>';
	}
	obj.Viewtitle += "</tr>";
	$("#gridItemView").append(obj.Viewtitle);
	
	//计算抗生素种类
	var runQuery = $.Tool.RunQuery("DHCHAI.IRS.ASPOrdItemSrv","QryAspOrdList",PaadmID,obj.DateTo,obj.column,PowerType);
	if (!runQuery) {
		$.Tool.alert('抗生素数据为空 ！');
		return;
	}else{
		obj.Viewtitle = runQuery.record;
		
		//按抗生素名称分解为三维数组
		var tmpSide = new Array();
		var tmpiIndex = 0;
		for (var i=0; i<obj.Viewtitle.length; i++){
			if (obj.Viewtitle[i]["OEGeneric"] != -1){
				var tmpjIndex = 0;
				tmpSide[tmpiIndex] = new Array();
				tmpSide[tmpiIndex][tmpjIndex] = {"ID":obj.Viewtitle[i]["ID"],"OEGeneric":obj.Viewtitle[i]["OEGeneric"],"OEPriority":obj.Viewtitle[i]["OEPriority"],"OESttDate":obj.Viewtitle[i]["OESttDate"],"OEXDate":obj.Viewtitle[i]["OEXDate"],"IsOpinion":obj.Viewtitle[i]["IsOpinion"]};
				for (var j=i+1; j<obj.Viewtitle.length; j++){
					if (obj.Viewtitle[i]["OEGeneric"] == obj.Viewtitle[j]["OEGeneric"]){
						tmpjIndex += 1;
						tmpSide[tmpiIndex][tmpjIndex] = {"ID":obj.Viewtitle[j]["ID"],"OEGeneric":obj.Viewtitle[i]["OEGeneric"],"OEPriority":obj.Viewtitle[j]["OEPriority"],"OESttDate":obj.Viewtitle[j]["OESttDate"],"OEXDate":obj.Viewtitle[j]["OEXDate"],"IsOpinion":obj.Viewtitle[j]["IsOpinion"]};
						obj.Viewtitle[j]["OEGeneric"] = -1;
					}
				}
				tmpiIndex += 1;
			}
		}
		var AntiList = tmpSide;
		//填充下拉框
		$("#cboRuleAnti").append("<option value=''>--请选择--</option>");
		for (var i=0; i<AntiList.length; i++){
			$("#cboRuleAnti").append("<option value='"+AntiList[i][0].ID+"'>"+AntiList[i][0].OEGeneric+"</option>");
		}
		//绘制表格
		var chartHtml = "";
		for (var i=0; i<AntiList.length; i++){
			chartHtml += '<tr>';
			chartHtml += '<td>'+ AntiList[i][0].OEGeneric +'</td>';
			for (var j=1; j<=obj.column; j++){
				chartHtml += '<td id="View_'+i+'_'+j+'" data-colDate="'+$("#dateTitle_"+j).text()+'" align="center"></td>';
			}
			chartHtml += '</tr>';
		}
		$("#gridItemView").append(chartHtml);
		//填充数据
		for (var i=0; i<AntiList.length; i++){
			for (var j=1; j<=obj.column; j++){
				var colDate = $("#View_"+i+"_"+j).attr("data-colDate");
				for (var k=0; k<AntiList[i].length; k++){
					//解析日期为-分割,/无法正常解析
					AntiList[i][k].OESttDate = changeDateForm(AntiList[i][k].OESttDate, "/", "-");
					AntiList[i][k].OEXDate = ((AntiList[i][k].OEPriority=="长期医嘱")&&(AntiList[i][k].OEXDate=="")) ? obj.DateTo : AntiList[i][k].OEXDate; //不存在停医嘱时间
					AntiList[i][k].OEXDate = changeDateForm(AntiList[i][k].OEXDate, "/", "-");
					//取当天的月日
					var tdSttDate =  parseDate(AntiList[i][k].OESttDate).Format("MMdd");
					var tdXDate =  parseDate(AntiList[i][k].OEXDate).Format("MMdd");
					
					var bgColorType = $("#View_"+i+"_"+j).attr("data-type"); //1长期,2临时,3长期+临时
					var Priority = AntiList[i][k].OEPriority;
					colDate = parseInt(colDate);
					tdSttDate = parseInt(tdSttDate);
					tdXDate = parseInt(tdXDate);
					if ((Priority == "长期医嘱")&&(colDate >= tdSttDate)&&(colDate <= tdXDate)){
						//抗菌药物
						if ((bgColorType == 2)||(bgColorType == 3)){
							$("#View_"+i+"_"+j).css("background-color", obj.ViewIcon[2][1]);
							$("#View_"+i+"_"+j).attr("data-type", 3);
						}else{
							$("#View_"+i+"_"+j).css("background-color", obj.ViewIcon[0][1]);
							$("#View_"+i+"_"+j).attr("data-type", 1);
						}
						//干预
						if (AntiList[i][k].IsOpinion == 1){
							$("#View_"+i+"_"+j).html('<img src="'+obj.ViewIcon[3][1]+'" />');
						}
					}else if((Priority == "临时医嘱")&&(colDate == tdSttDate)){
						//抗菌药物
						if ((bgColorType == 1)||(bgColorType == 3)){
							$("#View_"+i+"_"+j).css("background-color", obj.ViewIcon[2][1]);
							$("#View_"+i+"_"+j).attr("data-type", 3);
						}else{
							$("#View_"+i+"_"+j).css("background-color", obj.ViewIcon[1][1]);
							$("#View_"+i+"_"+j).attr("data-type", 2);
						}
						//干预
						if (AntiList[i][k].IsOpinion == 1){
							$("#View_"+i+"_"+j).html('<img src="'+obj.ViewIcon[3][1]+'" />');
						}
					}
					
				}
			}
		}
	}
	
	//医嘱详情列表
	obj.gridViewDetail = $("#gridViewDetail").DataTable({
		dom: "rt",
		select: "double",
		paging: false,
		ordering: true,
		info: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.ASPOrdItemSrv";
				d.QueryName = "QryAspOrdList";
				d.Arg1		= PaadmID;
				d.Arg2		= obj.DateTo;
				d.Arg3		= obj.column;
				d.Arg4		= PowerType;
				d.ArgCnt 	= 4;
			}
		},
		columns: [
			/*
			{"data": null, 
				"render":function (data, type, row ,index) {
					return '<input type="checkbox" id="OEOrd_'+ index.row +'" />';
				}
			},
			*/
			{"data": "OEGeneric"},
			{"data": "OESttDate"},
			{"data": "OEPriority"},
			{"data": "OEDoseQty"},
			{"data": "OEDoseQtyUom"},
			{"data": "OEFreqDesc"},
			{"data": null,
				"render":function (data, type, row ,index) {
					return data.PharOpinion!="未处置" ? data.PharOpinion +"(<a href='#' class='Program' data-type='0'>" + data.PharProID + "</a>)" : "";
				}
			},
			{"data": null,
				"render":function (data, type, row ,index) {
					return data.ExperOpinion!="未处置" ? data.ExperOpinion +"(<a href='#' class='Program' data-type='1'>" + data.ExperProID + "</a>)" : "";
				}
			},
			{"data": "OEXDate"},
			{"data": "OEOrdLoc"},
			{"data": "OEDoctor"}
		]
	});
	
	//加载各处置方案
	var runQuery = $.Tool.RunQuery("DHCHAI.IRS.ASPOrdItemSrv","QryAspMethods","","1");
	if (!runQuery) {
		$.Tool.alert('处置方案为空 ！');
		return;
	}else{
		obj.Methods = runQuery.record;
		
		var inReasonStr=	'<div class="page-header">'
				+		'<a class="Info"><img src="../scripts/dhchai/img/baseInfo.png"><span>'+ obj.MethodCodes.inReason.title +'</span></a>'
				+	'</div>'
				+	'<div class="report-content">';
		
		var outReasonStr=	'<div class="page-header">'
				+		'<a class="Info"><img src="../scripts/dhchai/img/baseInfo.png"><span>'+ obj.MethodCodes.outReason.title +'</span></a>'
				+	'</div>'
				+	'<div class="report-content">';
				
		var followStr=	'<div class="page-header">'
				+		'<a class="Info"><img src="../scripts/dhchai/img/baseInfo.png"><span>'+ obj.MethodCodes.follow.title +'</span></a>'
				+	'</div>'
				+	'<div class="report-content">';
		
		$("#PharinReason, #ExperinReason").html(inReasonStr);
		$("#PharoutReason, #ExperoutReason").html(outReasonStr);
		$("#Pharfollow, #Experfollow").html(followStr);
		
		for (var i=0; i<obj.Methods.length; i++) {
			var DicDescArr = obj.Methods[i].DicDesc.split("|");
			
			$.each(obj.MethodCodes ,function(k,n) {
				//k合理inReason,k不合理outReason,k需关注follow
				if ($.inArray( parseInt(obj.Methods[i].DicCode), n.CodeList) > -1) {
					var PharhtmlStr = makePharMethods(k, DicDescArr[1], obj.Methods[i].DicCode, DicDescArr[0]);
					$("#Phar"+k).append(PharhtmlStr);
					var ExperhtmlStr = makeExperMethods(k, DicDescArr[1], obj.Methods[i].DicCode, DicDescArr[0]);
					$("#Exper"+k).append(ExperhtmlStr);
				}
			});
			
		}
		//$("#PharinReason,#PharoutReason,#Pharfollow,#ExperinReason,#ExperoutReason,#Experfollow").append('<div class="form-group form-group-sm"><label class="text-gray" id="">最后提交：2018-11-02 11:00:21 张大为</label></div>');
		$("#PharinReason,#PharoutReason,#Pharfollow,#ExperinReason,#ExperoutReason,#Experfollow").append('<div class="layui-layer-btn layui-layer-btn-c"><a class="layui-layer-btn0 btnOpinion">提交</a></div>');
		
	}
	
	/* 组成药师处置方案 */
	function makePharMethods(resultCode, methodType, methodCode, methodDesc) {
		var PharhtmlStr=""; //药师
		if (methodType == 'txt') {
			PharhtmlStr = '<div class="form-group form-group-sm" style="margin:10px;"><label for="Phar-'+ resultCode +'-text-'+ methodCode +'">'+ methodDesc +'：</label><input type="text" id="Phar-'+ resultCode +'-text-'+ methodCode +'" style="width:80%;"></div>';
		} else if (methodType == 'textarea') {
			PharhtmlStr = '<div class="form-group form-group-sm" style="height: auto; margin:10px;"><label for="Phar-'+ resultCode +'-text-'+ methodCode +'">'+ methodDesc +'：</label><br /><textarea rows="3" id="Phar-'+ resultCode +'-text-'+ methodCode +'" style="width:85%;margin-left:20px;"></textarea></div>';
		} else {
			PharhtmlStr = '<div class="form-group form-group-sm" style="margin:10px;"><input id="Phar-'+ resultCode +'-text-'+ methodCode +'" type="checkbox"><label for="Phar-'+ resultCode +'-text-'+ methodCode +'">'+ methodDesc +'</label></div>';
		}
		return PharhtmlStr;
	}
	/* 组成专家处置方案 */
	function makeExperMethods(resultCode, methodType, methodCode, methodDesc) {
		var ExperhtmlStr=""; //专家
		if (methodType == 'txt') {
			ExperhtmlStr = '<div class="form-group form-group-sm" style="margin:10px;"><label for="Exper-'+ resultCode +'-text-'+ methodCode +'">'+ methodDesc +'：</label><input type="text" id="Exper-'+ resultCode +'-text-'+ methodCode +'" style="width:80%;"></div>';
		} else if (methodType == 'textarea') {
			ExperhtmlStr = '<div class="form-group form-group-sm" style="height: auto; margin:10px;"><label for="Exper-'+ resultCode +'-text-'+ methodCode +'">'+ methodDesc +'：</label><br /><textarea rows="3" id="Exper-'+ resultCode +'-text-'+ methodCode +'" style="width:85%;margin-left:20px;"></textarea></div>';
		} else {
			ExperhtmlStr = '<div class="form-group form-group-sm" style="margin:10px;"><input id="Exper-'+ resultCode +'-text-'+ methodCode +'" type="checkbox"><label for="Exper-'+ resultCode +'-text-'+ methodCode +'">'+ methodDesc +'</label></div>';
		}
		return ExperhtmlStr;
	}
	
	
	/* 解析日期indexOfStr为changeStr分割 */
	function changeDateForm(myDate, indexOfStr, changeStr){
		if (myDate.indexOf(indexOfStr) > -1){
			var arrStaDate = myDate.split(indexOfStr);
			myDate = arrStaDate[2]+changeStr+arrStaDate[1]+changeStr+arrStaDate[0];
		}
		return myDate;
	}

	InitASPOrdItemWinEvent(obj);
	return obj;
}
