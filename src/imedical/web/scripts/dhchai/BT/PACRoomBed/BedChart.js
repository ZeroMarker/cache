// OpenType  打开床位图类型: 1 爆发预警    2 疑似病例筛查
function InitBedChart(obj,WardID,WarnDate,WarnItems,WarnItemsArray,OpenType){
	obj.WardDesc="";
	var objWard="";
	var htmlStr = '<div class="layer" id="layerbed" style="display:none;overflow-y:auto;height:100%;">'
				+	'<div id="LayerWard">'
				+ 	'</div>'
				+ '</div>';
	if ($(".container-fluid").siblings().is("#layerbed")) {
		$("#LayerWard").html();   // 清除 LayerWard 下面的内容
	}else {
		$(".container-fluid").after(htmlStr);
	}	
	// 把病区的床位信息转换成数组对象,初始化预警床位信息
	obj.WarnBedArray = new Array();
	obj.CurrBedArray = new Array();
	obj.BedEpisodeDr = new Array();
	obj.NoBedArray = new Array();   // 未安排床位
	
	if (OpenType=="2") {   // 疑似筛查床位图
		// 科室当前疑似患者
		var status = $("#ulPaadmStatus").val();
		var start = $.form.GetCurrDate('-');
		var end = $.form.GetCurrDate('-');
		var locID = $("#ulLoc").val();  //科室ID
		var IsMessage = $.form.GetValue("chkIsMessage");
		var IsFollow = $.form.GetValue("chkIsFollow");
		var IsFinDel = "";
		var IsFinish = $.form.GetValue("chkIsFinish");
		var IsDelete = $.form.GetValue("chkIsDelete");
		if ((IsFinish==1)&&(IsDelete==0)) {IsFinDel = "1";} //确诊
		if ((IsFinish==0)&&(IsDelete==1)) {IsFinDel = "2";} //排除
		if ((IsFinish==1)&&(IsDelete==1)) {IsFinDel = "3";} //确诊+排除
		
		var IsAttFlg = "";
		var IsScreenAtt = $.form.GetValue("chkIsScreenAtt");
		var IsScreenNoAtt = $.form.GetValue("chkIsScreenNoAtt");
		if ((IsScreenAtt==1)&&(IsScreenNoAtt==0)) {IsAttFlg = "1";} //已关注
		if ((IsScreenAtt==0)&&(IsScreenNoAtt==1)) {IsAttFlg = "2";} //未关注
		if ((IsScreenAtt==1)&&(IsScreenNoAtt==1)) {IsAttFlg = "3";} //已关注+未关注
			
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCScreeningSrv','QryScreenPatToBed',status,start,end,locID,IsMessage,IsFollow,IsFinDel,IsAttFlg);
		if (!runQuery) {
			layer.alert("患者信息查询失败！",{icon: 0});
		}else{
			arrDT = runQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				// 当前筛查出的疑似患者床位信息
				if ((rd["BedDr"]!="")&&(obj.WarnBedArray.indexOf(rd["BedDr"])<0)){
					obj.WarnBedArray.push(rd["BedDr"]);
					obj.BedEpisodeDr[rd["BedDr"]]=rd["EpisodeDr"];
				}
			}
		}
		// 科室当前床位信息
		var DataQuery = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryBedDrByDate',start,start,"",locID);
		if(DataQuery){
			var arrDT = DataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				// 当前床位数组
				if ((rd["BedDr"]!="")&&(obj.CurrBedArray.indexOf(rd["BedDr"])<0)){
					obj.CurrBedArray.push(rd["BedDr"]);
					obj.BedEpisodeDr[rd["BedDr"]]=rd["EpisodeDr"];
				}
			}
		}
	}
	
	if (OpenType=="1") {   // 爆发预警床位图
		var DataQuery = $.Tool.RunQuery('DHCHAI.IRS.CCWarningSrv','QryWarnPatList',WardID,WarnDate,WarnItems,"");
		if(DataQuery){
			obj.BedEpisodeDr.length=0;
			var arrDT = DataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				// 预警床位数组
				if (rd["WarnBedDr"]!=""){   
					obj.WarnBedArray.push(rd["WarnBedDr"]);
					obj.BedEpisodeDr[rd["WarnBedDr"]]=rd["EpisodeDr"];
				}
				// 当前床位数组
				if (rd["AdmBedDr"]!=""){
					obj.CurrBedArray.push(rd["AdmBedDr"]);
					obj.BedEpisodeDr[rd["AdmBedDr"]]=rd["EpisodeDr"];
				}
			}
		}
		var DataQuery = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryBedDrByDate',WarnDate,WarnDate,"",WardID);
		if(DataQuery){
			var arrDT = DataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				// 当前床位数组
				if ((rd["BedDr"]!="")&&(obj.CurrBedArray.indexOf(rd["BedDr"])<0)){
					obj.CurrBedArray.push(rd["BedDr"]);
					obj.BedEpisodeDr[rd["BedDr"]]=rd["EpisodeDr"];
				}
			}
		}
	}
    var data=$.Tool.RunServerMethod("DHCHAI.BTS.PACWardSrv","BuildBedRoomJson",WardID);
	objWard=$.parseJSON(data);
	var maxHeight=0;
	var maxWidth=0;
	var html='';
	// 生成DOC元素
	objWard.PACWard.forEach(function(ward){
		obj.WardDesc = ward.LocDesc;
		html+='<div class="ward-bed-header"><h1>'+ward.LocDesc+ward.Floor+"层"+ward.Area+'</h1></div><div id="PACWard'+ward.WardID+'">';
		ward.RoomJson.forEach(function(room){
			if (room.TypeDesc!="病房") {
				room.RoomDesc=room.RoomDesc.replace(/[^\u4e00-\u9fa5|,]+/,""); //非病房去掉编号
				if (room.RoomDesc == "") room.RoomDesc=room.TypeDesc;
			}
			//html+='<div id="Room'+room.RoomID+'" style="width:'+room.PosWidth+'px;height:'+room.PosHeight+'px;top:'+room.PosTop+'px;left:'+room.PosLeft+'px;transform:rotate('+room.PosRotate+'deg);-ms-transform:rotate('+room.PosRotate+'deg);-moz-transform:rotate('+room.PosRotate+'deg);-webkit-transform:rotate('+room.PosRotate+'deg);-o-transform:rotate('+room.PosRotate+'deg);">'+'<div>'+room.RoomDesc+'<div id="Icon'+room.RoomID+'"></div></div>';
			html+='<div id="Room'+room.RoomID+'" title="'+room.TypeDesc+'" style="transform:rotate('+room.PosRotate+'deg);-ms-transform:rotate('+room.PosRotate+'deg);-moz-transform:rotate('+room.PosRotate+'deg);-webkit-transform:rotate('+room.PosRotate+'deg);-o-transform:rotate('+room.PosRotate+'deg);">'+'<div id="RoomDesc'+room.RoomID+'">'+room.RoomDesc+'</div><div id="Icon'+room.RoomID+'"></div>';
			room.BedJson.forEach(function(bed,i){
				// EpisodeDr html+='<div id="Bed'+bed.BedID+'" style="width:'+room.BedWidth+'px;height:'+room.BedHeight+'px;top:'+bebTop+'px;left:'+bedLeft+'px;"><p>'+bed.BedDesc+'</p></div>';
				// 增加就诊ID
				var tmpEpisodeDr="";
				if (obj.BedEpisodeDr[bed.BedID]){
					var tmpEpisodeDr = obj.BedEpisodeDr[bed.BedID];
				}
				html+='<div name="'+tmpEpisodeDr+'" id="Bed'+bed.BedID+'"><p>'+bed.BedDesc+'</p></div>';
			});
			html+='</div>';
			//计算边框的高宽
			if ((parseInt(room.PosHeight) + parseInt(room.PosTop))>maxHeight){ 
				maxHeight = (parseInt(room.PosHeight) + parseInt(room.PosTop))
			}
			if ((parseInt(room.PosWidth) + parseInt(room.PosLeft))>maxWidth){
				maxWidth = (parseInt(room.PosWidth) + parseInt(room.PosLeft))
			}
		});
		html+='</div>';
	});
	if ((maxWidth!=0)&&(maxHeight!=0)){
		$("#LayerWard").html(html);
	}else{
		$("#LayerWard").html("");
	}
	//获取缩放系数
	var widthRatio = ($(document.body).width()-50)/maxWidth;
	var heightRatio = ($(document.body).height()-100)/maxHeight;
	var ratio = (widthRatio > heightRatio) ? heightRatio : widthRatio;
	maxWidth = maxWidth * ratio;
	maxHeight = maxHeight * ratio;
	// 根据后台设置DOC CSS样式
	objWard.PACWard.forEach(function(ward){
		$("#PACWard"+ward.WardID+"").addClass("pac-ward");
		$("#PACWard"+ward.WardID+"").css({"width":(maxWidth+20)+"px","height":(maxHeight+20)+"px"});
		ward.RoomJson.forEach(function(room){
			$("#Room"+room.RoomID+"").css({"width":(room.PosWidth*ratio)+"px","height":(room.PosHeight*ratio)+"px","top":(room.PosTop*ratio)+"px","left":(room.PosLeft*ratio)+"px"});
			if(room.TypeDesc=="护士站") {
				$("#Room"+room.RoomID+"").addClass("nurse-station");
			}else if(room.TypeDesc=="楼梯间") {
				$("#Room"+room.RoomID+"").addClass("pac-stairs");
			}else if(room.TypeDesc=="电梯间") {
				$("#Room"+room.RoomID+"").addClass("pac-elevator");
			}else if(room.TypeDesc=="男厕") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room wc-man");
			}else if(room.TypeDesc=="女厕") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room wc-woman");
			}else if(room.TypeDesc=="卫生间") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room wc-room");
			}else if(room.TypeDesc=="保洁室") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room cleanin-room");
			}else if(room.TypeDesc=="杂物间") {
				$("#Room"+room.RoomID+"").addClass("gray-room");
				// 对于有房间描述的,文字可能覆盖图标,在房间里增加了IconDIV
				// 由于没有内容,要显示图标,必须设置高度,高度基本是图标的大小高度
				$("#Icon"+room.RoomID+"").addClass("debris-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="杂用室") {
				$("#Room"+room.RoomID+"").addClass("gray-room");
				$("#Icon"+room.RoomID+"").addClass("debris-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="女更衣室") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room clothes-woman");
			}else if(room.TypeDesc=="男更衣室") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room clothes-man");
			}else if(room.TypeDesc=="库房") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("treasury-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="临床数据库") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("data-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="机房") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("data-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="管井") {
				$("#Room"+room.RoomID+"").addClass("gray-room");
				$("#Icon"+room.RoomID+"").addClass("tube-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="处置室") {
				$("#Room"+room.RoomID+"").addClass("orange-room");
				$("#Icon"+room.RoomID+"").addClass("disposal-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="检查室") {
				$("#Room"+room.RoomID+"").addClass("orange-room");
				$("#Icon"+room.RoomID+"").addClass("inspect-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="治疗室") {
				$("#Room"+room.RoomID+"").addClass("orange-room");
				$("#Icon"+room.RoomID+"").addClass("treatment-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="血气室") {
				$("#Room"+room.RoomID+"").addClass("orange-room");
				$("#Icon"+room.RoomID+"").addClass("blood-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="换药室") {
				$("#Room"+room.RoomID+"").addClass("orange-room");
				$("#Icon"+room.RoomID+"").addClass("dressing-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="被服室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("quilt-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="教室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("class-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="配膳室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("panther-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="会议室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("meet-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="洗澡间") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("bath-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="男浴室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("bath-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="女浴室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("bath-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="医生办公室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("doctor-office-room");
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="护士办公室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("nurse-office-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="医生值班室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("doctor-duty-room");
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="护士值班室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("nurse-duty-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="病区入口") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room ward-entrance");
			}else if(room.TypeDesc=="墙") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room wall-room");
			}else if(room.TypeDesc=="阳台") {
				$("#Room"+room.RoomID+"").html("<div></div>");
				$("#Room"+room.RoomID+"").addClass("gray-room balcony-room");
			}else if(room.TypeDesc=="开水房") {
				$("#Room"+room.RoomID+"").addClass("gray-room");
				$("#Icon"+room.RoomID+"").addClass("hot-water");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="配电室") {
				$("#Room"+room.RoomID+"").addClass("gray-room");
				$("#Icon"+room.RoomID+"").addClass("elect-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="更衣室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("clothes-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="休息室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("rest-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="科研室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("staff-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="仪器室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("instrument-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="值班室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("duty-room");  
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="办公室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("doctor-office-room");
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.TypeDesc=="手术室") {
				$("#Room"+room.RoomID+"").addClass("blue-room");
				$("#Icon"+room.RoomID+"").addClass("oper-room");
				$("#Icon"+room.RoomID+"").css("height","24px");
			}else if(room.BedJson.length==0) {  // 其他不同样式 
				$("#Room"+room.RoomID+"").addClass("pac-other-room");
				$("#Room"+room.RoomID+" div").addClass("div-center");
			}else{  // 病房
				$("#Room"+room.RoomID+"").addClass("pac-room");
				if (room.DescPos=="2") {  // 房间号位置 1:上 2：下 3：左 4：右
					var top = room.PosHeight*ratio-30;
					$("#Room"+room.RoomID+" div:first").css({"padding-top": top+"px"});
					var bedTopRadio = 0.05; //房间号距离顶部系数
				} else if (room.DescPos=="3"){
					var top = (room.PosHeight*ratio)/2;
					$("#Room"+room.RoomID+" div:first").css({"position":"absolute","top":top+"px","left":"10px","-webkit-transform-origin":"left","-ms-transform-origin":"left","-ms-transform":"rotate(270deg)","-moz-transform":"rotate(270deg)","-webkit-transform":"rotate(270deg)","-o-transform":"rotate(270deg)"});
					var bedTopRadio = 0.05;
				} else if (room.DescPos=="4"){
					var top = (room.PosHeight*ratio)/2;
					$("#Room"+room.RoomID+" div:first").css({"position":"absolute","top":top+"px","right":"10px","-webkit-transform-origin":"right","-ms-transform-origin":"right","-ms-transform":"rotate(90deg)","-moz-transform":"rotate(90deg)","-webkit-transform":"rotate(90deg)","-o-transform":"rotate(90deg)"});
					var bedTopRadio = 0.05;
				} else {
					var bedTopRadio = 0.2;
				}
			}
			var sideBedMax = (room.LeftBedCnt>room.RightBedCnt) ? room.LeftBedCnt : room.RightBedCnt;	//侧边最大床位数
			var bedheightRadio = ((sideBedMax!=0)&&(sideBedMax>3)) ? 0.6/sideBedMax : 0.2;	//床位高度系数,默认0.2
			var bebLeftTop = room.PosHeight * bedTopRadio;	// 默认病区里的床位距离顶部
			var bebRightTop = room.PosHeight * bedTopRadio;	// 默认病区里的床位距离顶部
			var bebTop=0;
			room.BedJson.forEach(function(bed,i){
				room.BedWidth = room.PosWidth * 0.4;				//床位宽度系数
				room.BedHeight = room.PosHeight * bedheightRadio;	//床位高度系数
				if(i<room.LeftBedCnt) {
					bedLeft=0;
					if(i!=0){
						bebLeftTop+=parseInt(room.BedHeight)+(room.PosHeight*0.05);   // 10：垂直床位之间的间隔
					}
					bebTop=bebLeftTop;
				}else {
					bedLeft=parseInt(room.PosWidth)-parseInt(room.BedWidth)-2;   // 2:边框的宽度,避免边框重复
					if(i!=room.LeftBedCnt){
						bebRightTop+=parseInt(room.BedHeight)+(room.PosHeight*0.05);  // 10：垂直床位之间的间隔
					}
					bebTop=bebRightTop;
				}
				//床位按系数缩放
				$("#Bed"+bed.BedID+"").css({"width":room.BedWidth*ratio+"px","height":room.BedHeight*ratio+"px","top":bebTop*ratio+"px","left":bedLeft*ratio+"px"});
				$("#Bed"+bed.BedID+"").addClass("pac-bed-empty"); // 默认床位为空
				if (obj.CurrBedArray.indexOf(""+bed.BedID+"")>=0){
					$("#Bed"+bed.BedID+"").removeClass("pac-bed-empty");
					$("#Bed"+bed.BedID+"").addClass("pac-bed-full");
				}
				if (obj.WarnBedArray.indexOf(""+bed.BedID+"")>=0){
					$("#Bed"+bed.BedID+"").removeClass("pac-bed-full");
					$("#Bed"+bed.BedID+"").removeClass("pac-bed-empty");
					$("#Bed"+bed.BedID+"").addClass("pac-bed-abnormal");
				}
			});
		});
	});
	// 增加显示未安排房间的床位
	var data=$.Tool.RunServerMethod("DHCHAI.BTS.PACRoomBedSrv","BuildBedJson",WardID);
	objNoBed=$.parseJSON(data);
	var html='<div class="ward-bed-header"><h1>未关联房间的床位列表</h1></div><div class="pac-nobed" id="PACNoBed">';
	objNoBed.PACNoBed.forEach(function(NoBed){
		obj.WardDesc=NoBed.LocDesc;
		// 增加就诊ID
		var tmpEpisodeDr="";
		if (obj.BedEpisodeDr[NoBed.BedID]){
			var tmpEpisodeDr = obj.BedEpisodeDr[NoBed.BedID];
		}
		html+='<div class="pac-bed-noward" name="'+tmpEpisodeDr+'" id="NoBed'+NoBed.BedID+'">'+NoBed.BedDesc+'</div>';
		obj.NoBedArray.push(NoBed.BedID);   // 未关联房间的床位
	});
	html+='</div>';
	if (objNoBed.PACNoBed.length>0){
		$("#LayerWard").append(html);
		// 未关联房间的床位 设置预警样式
		for(j = 0,len=obj.NoBedArray.length; j < len; j++) {
			var NoBedRowID=obj.NoBedArray[j];
			if (obj.WarnBedArray.indexOf(""+NoBedRowID+"")>=0){
				$("#NoBed"+NoBedRowID+"").css("background-color","#F67163");
			}else{
				$("#NoBed"+NoBedRowID+"").css("background-color","#40CCB0");
			}
		}
	}
	// 爆发预警床位图,当预警日期不等于空,说明是爆发预警,需要增加指标按键列表 
	if (OpenType=="1") {
		var html ='<div style="height:30px;margin: 10px 0px 0px 0px;" class="form-group">';
		html+='<label class="control-label" for="WarnDate" style="float: left;margin-left:5px">预警日期:</label>';
		html+='<fieldset class="" style="display: block;float: left;"><div class="input-group">';
		html+='<input id="WarnDate" class="form-control input-sm" placeholder="">';
		html+='<span class="input-group-addon"><span class="icon-calendar"></span></span></div></fieldset></div>';
		
	   	html +='<div style="display:block;margin:10px 0 -15px 0;"><span style="margin-left:10px">预警指标: </span>';
	    for (var i = 0; i < WarnItemsArray.length; i++) {
	    	html+='<div style="display:inline;"><input id ="'+i+'" type="checkbox" name="'+WarnItemsArray[i]+'"><label style="padding-left:2px;margin-right:10px;font-weight:normal;" >'+WarnItemsArray[i].replace("人数","")+'</label></div>';
	    }
	    html+='</div>';
		$("#LayerWard").prepend(html);
		
		$('input:checkbox').iCheck({
         	checkboxClass: 'icheckbox_square-blue'  //class类名，控制选框样式
   		});
   		var ItemList="";
   		//预警日期改变
		$("#WarnDate").on('changeDate',function(ev){
			var BedWarnDate = $.form.GetValue("WarnDate");
			obj.SetBedStyle(BedWarnDate,WardID,ItemList);
		});
		// 预警指标改变
		$("input:checkbox").on('ifChanged',function(){
			if(true == $(this).is(':checked')){
	        	ItemList+=$(this).attr("name")+",";
	   		}else{
		   		ItemList=ItemList.replace($(this).attr("name")+",","")
		   	}
		   	obj.WarnBedArray.length=0;
		   	obj.CurrBedArray.length=0;
		   	var BedWarnDate = $.form.GetValue("WarnDate");
			obj.SetBedStyle(BedWarnDate,WardID,ItemList);
		});
	}
	
	// 设置床位样式
	obj.SetBedStyle = function(BedWarnDate,WardID){
		obj.WarnBedArray.length=0;
	   	obj.CurrBedArray.length=0;
	   	obj.BedEpisodeDr.length=0;
	   	var DataQuery = $.Tool.RunQuery('DHCHAI.IRS.CCWarningSrv','QryWarnPatList',WardID,BedWarnDate,WarnItems,ItemList);
		if(DataQuery){
			var arrDT = DataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				// 预警床位数组
				if (rd["WarnBedDr"]!=""){   
					obj.WarnBedArray.push(rd["WarnBedDr"]);
					obj.BedEpisodeDr[rd["WarnBedDr"]]=rd["EpisodeDr"];
				}
				// 当前床位数组
				if (rd["AdmBedDr"]!=""){
					obj.CurrBedArray.push(rd["AdmBedDr"]);
					obj.BedEpisodeDr[rd["AdmBedDr"]]=rd["EpisodeDr"];
				}
			}
		}
		var DataQuery = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryBedDrByDate',BedWarnDate,BedWarnDate,"",WardID);
		if(DataQuery){
			var arrDT = DataQuery.record;
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				// 当前床位数组
				if ((rd["BedDr"]!="")&&(obj.CurrBedArray.indexOf(rd["BedDr"])<0)){
					obj.CurrBedArray.push(rd["BedDr"]);
					obj.BedEpisodeDr[rd["BedDr"]]=rd["EpisodeDr"];
				}
			}
		}
	 	objWard.PACWard.forEach(function(ward){
			ward.RoomJson.forEach(function(room){
				room.BedJson.forEach(function(bed,i){
					// 去除预警床位样式根据当前指标添加样式
					if($("#Bed"+bed.BedID+"").hasClass("pac-bed-abnormal")){
						$("#Bed"+bed.BedID+"").removeClass("pac-bed-abnormal");
						$("#Bed"+bed.BedID+"").addClass("pac-bed-empty");
					}
					if($("#Bed"+bed.BedID+"").hasClass("pac-bed-full")){
						$("#Bed"+bed.BedID+"").removeClass("pac-bed-full");
						$("#Bed"+bed.BedID+"").addClass("pac-bed-empty");
					}
					if (obj.CurrBedArray.indexOf(""+bed.BedID+"")>=0){
						$("#Bed"+bed.BedID+"").removeClass("pac-bed-empty");
						$("#Bed"+bed.BedID+"").addClass("pac-bed-full");
					}
					if (obj.WarnBedArray.indexOf(""+bed.BedID+"")>=0){
						$("#Bed"+bed.BedID+"").removeClass("pac-bed-full");
						$("#Bed"+bed.BedID+"").removeClass("pac-bed-empty");
						$("#Bed"+bed.BedID+"").addClass("pac-bed-abnormal");
					}
					// 增加就诊ID
					var tmpEpisodeDr="";
					if (obj.BedEpisodeDr[bed.BedID]){
						var tmpEpisodeDr = obj.BedEpisodeDr[bed.BedID];
						$("#Bed"+bed.BedID+"").attr("name",tmpEpisodeDr);
					}else{
						$("#Bed"+bed.BedID+"").attr("name","");
					}
				});
			});
		});
		// 未关联房间的床位 设置预警样式
		for(j = 0,len=obj.NoBedArray.length; j < len; j++) {
			var NoBedRowID=obj.NoBedArray[j];
			if (obj.WarnBedArray.indexOf(""+NoBedRowID+"")>=0){
				$("#NoBed"+NoBedRowID+"").css("background-color","#F67163");
			}else{
				$("#NoBed"+NoBedRowID+"").css("background-color","#40CCB0");
			}
			// 增加就诊ID
			var tmpEpisodeDr="";
			if (obj.BedEpisodeDr[NoBedRowID]){
				var tmpEpisodeDr = obj.BedEpisodeDr[NoBedRowID];
				$("#Bed"+NoBedRowID+"").attr("name",tmpEpisodeDr);
			}else{
				$("#Bed"+NoBedRowID+"").attr("name","");
			}
		}
	}
	
	obj.Layer_bed = function(){
		layer.open({
			type: 1,
			//zIndex: 101, //IE8下echarts 层数高，浮在上面
			area: ['100%','100%'],
			maxmin: false,
			title: obj.WardDesc+'--床位图分布情况', 
			skin: 'layer-class',
			content: $('#layerbed'),
			success: function(layero, index){
				$("#layerbed").parent().css("background-color","#F9FDFF");
				if (OpenType=="1"){
					$.form.DateTimeRender("WarnDate",WarnDate);
				}
			}
		});
	}
	
	obj.Layer_bed();
	$("#layerbed").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	// 点击床位显示摘要
    $('.pac-room > div').on('click', function (e) {
		if ($(this).attr("id").indexOf("Bed")<0){    // 非床位信息
			return;
		}
		if (($(this).attr("name")=="")||(typeof($(this).attr("name"))=="undefined")){
			layer.msg('该床位无患者!',{icon: 2});
			return;   
		}
		var EpisodeID = $(this).attr("name");
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
    });
    $('.pac-nobed > div').on('click', function (e) {
		if (($(this).attr("name")=="")||(typeof($(this).attr("name"))=="undefined")){
			layer.msg('该床位无患者!',{icon: 2});
			return;   
		}
		var EpisodeID = $(this).attr("name");
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
    });
}