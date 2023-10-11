function InitCCScreeningWin(){
	var obj=new Object();
	var arrDate		= new Array;
	var arrTitle    = new Array;
	var arrAbFlg    = new Array;
	$.parser.parse();
	
	//获取病程日期
	$cm({
		ClassName:"DHCHAI.DPS.EmrRecordSrv",
		QueryName:"QryDocDate",
		aEpisodeID:PaadmID,
		aDocType:'',
		page: 1,
		rows: 99999
	},function(rs){
		if (rs.total>0) {
			$('#divNoResult').attr("style","display:none");
			$('#divpage').attr("style","display:block");
			obj.GetDate(rs);		
		}else {
			$('#divNoResult').attr("style","display:block");
			$("#divMian").empty();
			$('#divpage').attr("style","display:none");
		}
	});
	
	obj.GetDate = function (runQuery){
		if (!runQuery) return;
		var DateLine = runQuery.rows;
		var Datelength = DateLine.length;
		
		for (var indRd = 0; indRd < Datelength; indRd++){
			var rd = DateLine[indRd];
			var DocDate = rd["DocDate"];
			var DocTitle = rd["DocTitle"];
			var IsAbFlg = rd["IsAbFlg"];
			arrDate.push(DocDate);
			arrTitle.push(DocTitle);
			arrAbFlg.push(IsAbFlg);
		}
		
		$('#divPage').pagination({
			total:arrDate.length,
			pageSize:5,
			pageNumber:1,
			pageList:[5,6,7,8]
		});
		obj.getUserList(1,5);
		obj.DateInfo();
	}
	obj.DateInfo = function(){
		$("#ulDateList").empty();

		var str="";
		for (var indRd = 0; indRd <arrDate.length; indRd++){
			var tmp = arrDate[indRd];
			var tmpTitle = arrTitle[indRd];	
			tmpTitle=tmpTitle.replace(/,/g,"<br>")	
			var IsAbFlg = arrAbFlg[indRd];
			if (IsAbFlg==1) {
				str += ("<li text='"+tmp+"' style='line-height:25px;'><a class='icon-star' style='line-height:30px;'>&nbsp;&nbsp;&nbsp;&nbsp;</a><a id='DateList"+tmp+"' href='javascript:void(0)' onclick='Date_Click()'>{0}</a>");
			}	else {			
				str += ("<li text='"+tmp+"' style='line-height:25px;'><a id='DateList"+tmp+"' href='javascript:void(0)' onclick='Date_Click()'>{0}</a>");			
			}
			str=str.format(tmp+"</br>"+tmpTitle);						
			str+="</li>";
		}
		$("#ulDateList").append(str);		
	}
	//日期选中事件
	Date_Click =function(){ 
		$('#ulDateList > li').click(function (e) {
			e.preventDefault();
			$('#ulDateList > li').removeClass('active');
			$(this).addClass("active");			
	
			var txt = $(this,"a").attr("text");  //text
			var DateFrom = txt
			var NumFrom = arrDate.indexOf(txt);
			var number = NumFrom+5
			if(number>(arrDate.length-1)){
				var DateTo = arrDate[arrDate.length-1];
			}else{
				var DateTo = arrDate[number];
			}

			$cm({
				ClassName:"DHCHAI.IRS.CCRMEWordSrv",
				QueryName:"QryEmrRecordNew",
				aEpisodeID:PaadmID,
				aDocType:'',
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				page: 1,
				rows: 99999
			},function(rs){
				obj.HTMlInfo(rs);   
			});
		});				
	}
		
		
	$('#divPage').pagination({
		onSelectPage:function(pageNumber, pageSize){
			$("#divMian").empty();
			obj.getUserList(pageNumber,pageSize);
			//$(this).pagination('loading');
			$(this).pagination('loaded');
		},
		onBeforeRefresh:function(pageNumber,pageSize){
			$("#divMian").empty();
			obj.getUserList(pageNumber,pageSize);
		}
	});
	
	obj.getUserList = function(page,pageSize){
		
		var DateFrom = arrDate[(page-1)*pageSize];
		var ToNum = page*pageSize-1;
		if(ToNum>arrDate.length-1){
			var DateTo = arrDate[arrDate.length-1];		
		}else{
			var DateTo = arrDate[ToNum];
		}
		$cm({
			ClassName:"DHCHAI.IRS.CCRMEWordSrv",
			QueryName:"QryEmrRecordNew",
			aEpisodeID:PaadmID,
			aDocType:'',
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			page: 1,
			rows: 99999
		},function(rs){
			obj.HTMlInfo(rs);   
		});
	} 
	
	InitCCScreeningWinEvent(obj);
	return obj;
}