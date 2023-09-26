//页面Gui
function InitSummaryWin(){
	var obj = new Object();
	obj.DateFrom	= "";
	obj.DateTo		= "";
	obj.column      = 60;   //默认列数
	obj.AdmDays     = 0;    //住院天数
	obj.ViewIcon    = [];	//图例
	obj.Viewtitle   = [];	//表头
	obj.ViewResult  = [];	//视图数据
	obj.ViewBackColor=[];	//背景色
	
	obj.ViewBackColor = [
		["KSS1","#FFE1E1","非限制级"],
		["KSS2","#F9E79F","限制级"],
		["KSS3","#A9DFBF","特殊级"]
	];
	//初始化高度
	var wh = $(window).height();
	$("body").height(wh-10);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("body").height(wh-10);
	});
	
	// 渲染图例
	var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewIcon");
	if (!runQuery) {
		$.Tool.alert('图例信息为空 ！');
		return;
	}
	else{
		obj.ViewIcon = runQuery.record;
		for(var i = 0 ;i<obj.ViewIcon.length;i++){
			var desc = obj.ViewIcon[i].desc;
			var src = obj.ViewIcon[i].src;
			var html = '<div><img src = "' + src + '"/>'+desc+'</div>' ;
			$('#img_span').append(html);
		}
		//背景色类型特殊处理
		for(var i = 0 ;i<obj.ViewBackColor.length;i++){
			var desc = obj.ViewBackColor[i][2];
			var src = obj.ViewBackColor[i][1];
			var html = '<div><div class="pull-left" style = "background-color:' + src + ';width:14px;height:14px;margin-top:4px;"></div>&nbsp;'+desc+'</div>' ;
			$('#img_span').append(html);
		}
	}

	// 生成空白视图表格
	var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewTitle",PaadmID,obj.column);
	if (!runQuery) {
		$.Tool.alert('图例信息为空 ！');
		return;
	}else{
		obj.Viewtitle = runQuery.record;
		obj.columnList=[];
		for (var i = 0; i <=obj.Viewtitle.length; i++) {
			if (i==0){
				var objC = {};
				objC["title"] = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日 期&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';//&nbsp;解决IE下出现表头无法对齐
				objC["data"] = "column_Data_"+i;
				obj.columnList.push(objC);
			}else{
				var objC = {};
				objC["title"] = obj.Viewtitle[i-1].DateShow;
				var TransFlag=obj.Viewtitle[i-1].TransFlag;
				if ((TransFlag == '1')||(TransFlag == '3')){
					objC["title"] = obj.Viewtitle[i-1].DateShow + '<br>' + '<span style="display:block;width:40px;overflow:hidden;background-color:#00FFFF;font-size:75%;">' + obj.Viewtitle[i-1].TransLoc + '</span>';
				}
				objC["data"] = "column_Data_"+i;
				obj.columnList.push(objC);
			}
		};
		
		// 生成空白表格数据
		obj.dataSet = [];
		for (var i=-1; i<obj.ViewIcon.length; i++)
		{
			// 表格内容增加显示入院天数
			if (i==-1){
				var desc = "入院天数";
				var tmpMap = {'column_Data_0':desc}
				for (var j=0;j<obj.Viewtitle.length;j++)
				{
					if (obj.Viewtitle[j].AdmDays!=""){
						var AdmDays = obj.Viewtitle[j].AdmDays;
						if (AdmDays > obj.AdmDays) obj.AdmDays = AdmDays;
						var evalStr = 'tmpMap.column_Data_' + (j + 1) + '=' + obj.Viewtitle[j].AdmDays;
					}else{
						var evalStr = 'tmpMap.column_Data_'+(j+1)+'=""';
					}
					eval(evalStr);
				}
			}else{
				var desc = obj.ViewIcon[i].desc;
				var tmpMap = {'column_Data_0':desc}
				for (var j=0; j<obj.Viewtitle.length; j++)
				{
					var evalStr = 'tmpMap.column_Data_'+(j+1)+'=""';
					eval(evalStr);
				}
			}
			obj.dataSet.push(tmpMap);
		};
		obj.gridItemView = $("#gridItemView").DataTable({
			dom: 'rt<"row">'
			,columns: obj.columnList
			,data: obj.dataSet
			,ordering:false
			,paging: false
			,fixedColumns: true
			,scrollX: true
	 	});
		
	 	// 视图表格td、th添加id
		$("#gridItemView tbody").find("tr").each(function (i) {
			$(this).children("td").each(function(j){
				$(this).attr("id","td_view_"+i+"_"+j);
			})
		});
	}

	//图标代码、位置、图标路径的对照关系
	var iconIndexMap = {};
	for (var i=0;i<obj.ViewIcon.length;i++)
	{
		var code = obj.ViewIcon[i].code;
		var index = obj.ViewIcon[i].index
		var evalstr = "iconIndexMap."+code+"="+index;
		eval(evalstr);
	}
	var iconSrcMap = {};
	for (var i=0;i<obj.ViewIcon.length;i++)
	{
		var code = obj.ViewIcon[i].code;
		var src = obj.ViewIcon[i].src;
		var evalstr = "iconSrcMap."+code+"='"+src+"'";
		eval(evalstr);
	}

	//根据后台数据改变已经渲染表格样式
	var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewResult",PaadmID);
	var DateIndex = obj.Viewtitle[0].DateIndex;
	if (!runQuery) {
		return;
	}else{
		obj.ViewResult = runQuery.record;

		for (var i =0;i<obj.ViewResult.length;i++)
		{
			var ItemCode = obj.ViewResult[i].IVItemCode;
			var ItemDate = obj.ViewResult[i].IVDate;
			var IVFlag = obj.ViewResult[i].IVFlag;
			var IVResult = obj.ViewResult[i].IVResult;
			var IVDateType = obj.ViewResult[i].IVDateType;
			var KSS = "";
			//判断抗生素最高等级
			if (ItemCode=="ANT") {
				if (IVResult.indexOf("KSS3")>-1) {
					KSS="KSS3";
				}else if(IVResult.indexOf("KSS2")>-1){
					KSS="KSS2";
				}else{
					KSS="KSS1";
				}
			}
			
			var dayMaxTmp=0; //当日最高体温
			var arryIVResult = IVResult.split('^');
			for (var j=0;j<arryIVResult.length;j++)
			{
				if (arryIVResult[j]=="") continue;
				if (j==0){
					IVResult = arryIVResult[j];
				}else{
					IVResult = IVResult+'\n'+arryIVResult[j]
				}
				
				//获取最高体温
				if (ItemCode == 'TMP') {
					var TempTmp = arryIVResult[j].split(' ')[0];
					TempTmp = TempTmp.replace(/[^\d.]/g,''); //非数字或小数替换为空
					TempTmp = parseFloat(TempTmp);
					
					if (dayMaxTmp < TempTmp) dayMaxTmp = TempTmp;
				}
			}
			if (IVFlag==0) continue;
			//获取图标路径、行号、列号
			var evalstr = "var row = iconIndexMap."+ItemCode;
			eval(evalstr);
			var evalstr = "var src = iconSrcMap."+ItemCode;
			eval(evalstr);
			var column = ItemDate-DateIndex+1;
			
			if (ItemCode=="ANT")		//抗生素特殊处理
			{
				var IVRows = obj.ViewResult[i].IVRows;	//抗生素行号为后台结果
				var eleID = 'td_view_'+(IVRows-1)+'_'+column;
			}else{
				var eleID = 'td_view_'+ (row-1)+'_'+column;
			}
			
			/***************报告日期显示不同的图标 start*******************/		
			var RepSrc=''; //报告日期的src
			switch (ItemCode) {
				case 'RBT':
					RepSrc = '../Scripts/dhchai/img/血常规-线.png';
					break;
				case 'RUT':
					RepSrc = '../Scripts/dhchai/img/尿常规-线.png';
					break;
				case 'ROT':
					RepSrc = '../Scripts/dhchai/img/其他常规-线.png';
					break;
				case 'MDR':
					RepSrc = '../Scripts/dhchai/img/多重耐药菌-线.png';
					break;
				case 'BUG':
					RepSrc = '../Scripts/dhchai/img/细菌-线.png';
					break;
				case 'HAI':
					RepSrc = '../Scripts/dhchai/img/院感报告.png';
					break;
			}	
			/***************报告日期显示不同的图标 End*******************/
			
			
			//添加图标
			if (ItemCode=="ANT"){
				$("#"+eleID).attr("title", IVResult);
				//抗生素背景
				if (KSS=="KSS1"){
					$("#"+eleID).css("background-color",obj.ViewBackColor[0][1]);
				}else if(KSS=="KSS2"){
					$("#"+eleID).css("background-color",obj.ViewBackColor[1][1]);
				}else{
					$("#"+eleID).css("background-color",obj.ViewBackColor[2][1]);
				}
				
			} else if (ItemCode=='TMP') {
				var html = '<span id="tip" title="'+IVResult + '" style="color:red;">'+dayMaxTmp+'</span>';
				$("#"+eleID).append(html);
			} else {					
				//是否已经添加图标
				if ($("#"+eleID).find('span').length){
					//替换图片
					$("#"+eleID+'>span>img').attr("src",src);				
					//修改提示内容
					var oldTitle = $("#"+eleID+'>span').attr("title");
					var Title = oldTitle+'\n'+IVResult;
					$("#"+eleID+'>span').attr("title",Title);
				} else { //当前没有图标
					if (IVDateType==2) {   
						src = RepSrc;
					}
					var html = '<span id="tip" title="'+IVResult + '">'+'<img src = "' + src + '"></img>'+'</span>';
					$("#"+eleID).append(html);
				}
			}
		}
	}
	
	// 视图表格使用滚动条插件
	$("#gridItemView_wrapper .dataTables_scrollBody").mCustomScrollbar({
		// scrollButtons: { enable: true },
		theme: "dark-thick",
		axis: "x",
		callbacks:{
			whileScrolling:function(){
				$('#gridItemView_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
			}
		}
	});
	
	// 视图滚动条默认滚动到最右边
	setTimeout(function(){
		if (obj.AdmDays > 30) {
			$("#gridItemView_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridItemView tr td:last"));
		}
	}, 100);
	
	InitSummaryWinEvent(obj);
	return obj;
}
