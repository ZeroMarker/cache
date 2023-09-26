$(function(){
	

	
	
	//alert(rptID);
	var showType="";
	$('#gridSearchCondition').propertygrid({
		scrollbarSize: 0,
		fitColumns:true,
		url:$URL,
		showHeader:true,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.BKCUIServ",
			MethodName:"GetSearchCondData",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			rptID:rptID,
			rptTool:rptTool
		},
		columns:[[
			{field:'name',title:'名称',width:100,align:'left'},
			{field:'value',title:'值',width:150,align:'left'},
			{field:'code',title:'编码',hidden:true}
			]],
		toolbar:[{
			iconCls:'icon-apply-check',
			text:'统计',
			plain:"false",
			handler:statRptData
		}],
		onAfterEdit:function(rowIndex, rowData, changes) {
			$("td.datagrid-value-changed").removeClass("datagrid-value-changed");
		}

	});

	$('#gridRptConfigs').propertygrid({

  		scrollbarSize: 0,
		//fitColumns:true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.BKCUIServ",
			MethodName:"GetRptConfigs",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			rptID:rptID,
			rptTool:rptTool
		},
		columns:[[
			{field:'name',title:'名称',width:100,align:'left'},
			{field:'value',title:'值',width:150,align:'left'
				,formatter: function(value,row,index){
					return '<span title='+value.replace("->","-&gt;")+'>'+value.replace("->","-&gt;")+'</span>'
				}
			},
			{field:'code',title:'值',hidden:true}
			]]
	});

	///Creator：      wz
	///CreatDate：    2018-11
	///Description:：   解析日期字符串
	///Table：       
	///Input：            日期字符串
	///Output：          
	///Return：         date对象
	///Others：        	
	///	example:		

	function dhcwlDateParser(strDate) {
		return $.fn.datebox.defaults.parser(strDate);
	}
	///Creator：      wz
	///CreatDate：    2018-11
	///Description:：   将date对象转换成字符串
	///Table：       
	///Input：          date：日期对象；format：字符串格式。目前支持"YMD"。separator:字符串分隔符
	///Output：          
	///Return：         
	///Others：        	
	///	example:
	function dhcwlDateFormat(date,format,separator) {
		if (!format) format="YMD";
		if (!separator) separator="-";
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		
		if (format=="YMD") {
			//return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;
			return y+separator+(m<10?('0'+m):m)+separator+(d<10?('0'+d):d);
		}
		//其他格式在此添加。
		/*else if () {	
			
			
		}
		*/
	}



	function statRptData(){
		$('#rptShowDiv').empty();
		
		var rows=$('#gridSearchCondition').datagrid('getData').rows;
		var startDate=rows[0].value;			
		var endDate=rows[1].value;
		
		if (startDate=="" || endDate=="") {
			$.messager.alert("提示","请录入‘开始日期’和‘结束日期’后再执行统计！");
			return;	
		}
		
		var strDate=startDate;
		var objDate =dhcwlDateParser(strDate);
		startDate=dhcwlDateFormat(objDate);
		
		strDate=endDate;
		objDate =dhcwlDateParser(strDate);
		endDate=dhcwlDateFormat(objDate);		
		

		//更新最近使用报表清单
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"SaveRecentRptList",
			rptID:rptID,
			rptTool:rptTool,
			userID:userID
		},function(jsonData){
			if (jsonData.success!=1) {
				$.messager.alert("提示",jsonData.msg);
			}
		})
		
		
		
		if (rptTool=="CommonDataQuery"){
			
			/*
			var rows=$('#gridRptConfigs').datagrid('getData').rows;
			var dataObj=new Object();
			for(var i=0;i<rows.length;i++){
				dataObj[rows[i].code]=rows[i].value;
			}
			*/
			var src='dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-commonDataQry2_1.raq';
			src=src+'&startDate='+startDate+'&endDate='+endDate;
			src=src+'&rptID='+rptID;
			//var compand='<iframe src='+src+' width=100% height=100% display=block frameborder="0"></iframe>'
			var compand='<iframe src="'+src+'" style="width:100%;height:100%;display:block;" frameborder="0"></iframe>'
			
			/*
			var src='dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-commonDataQry.raq';
			src=src+'&startDate='+startDate+'&endDate='+endDate+'&routineName='+dataObj["routine"];
			src=src+'&functionName='+dataObj["fun"]+'&nameSpaceName='+dataObj["nameSpace"]+'&params=""'
			src=src+'&rptTitle='+dataObj["rptTitle"];
			var compand='<iframe src='+src+' width=100% height=100%  frameborder="0"></iframe>'
			*/
			$(compand).appendTo("#rptShowDiv");	
		}else if (rptTool=="BaseDataQuery" || rptTool=="KpiDataQuery") {
			var queryconf=""
			for (var i=2;i<rows.length;i++) {
				if (!rows[i].value) continue;
				var code=rows[i].code;
				var code=code.replace(/>/,"&gt;")
				var strRec=code+":"+rows[i].value;	
				if (queryconf!="") queryconf=queryconf+"^";
				queryconf=queryconf+strRec;
			}
			
			var raqName="";
			if (showType=="网格报表") {
				raqName="DTHealth-DHCWL-BaseDataQryDetail2_1.raq"
			}else if (showType=="交叉报表") {
				raqName="DTHealth-DHCWL-DaseDataQryCross2_1.raq"
				
			}
			var src='dhccpmrunqianreport.csp?reportName='+raqName;
			src=src+'&startDate='+startDate+'&endDate='+endDate+'&queryconf='+queryconf+'&rptID='+rptID;
			//var compand='<iframe src="'+src+'" width=100% height=100% display=block frameborder="0"></iframe>'
			var compand='<iframe src="'+src+'" style="width:100%;height:100%;display:block;" frameborder="0"></iframe>'
			$(compand).appendTo("#rptShowDiv");				
		}/*else if (rptTool=="KpiDataQuery") {
			var queryconf=""
			for (var i=2;i<rows.length;i++) {
				if (!rows[i].value) continue;
				var code=rows[i].code;
				var code=code.replace(/>/,"&gt;")
				var strRec=code+":"+rows[i].value;	
				if (queryconf!="") queryconf=queryconf+"^";
				queryconf=queryconf+strRec;
			}
			//DTHealth-DHCWL-BaseDataQry2.raq
			var src='dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KpiDataQryDetil2_1.raq';
			src=src+'&startDate='+startDate+'&endDate='+endDate+'&queryconf='+queryconf+'&rptID='+rptID;
			var compand='<iframe src="'+src+'" width=100% height=100%  frameborder="0"></iframe>'
			$(compand).appendTo("#rptShowDiv");				
		}*/

		
		
	}
	
	if (rptTool=="BaseDataQuery" || rptTool=="KpiDataQuery") {
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"GetShowTypeByRptID",
			rptID:rptID
		},function(jsonData){
			if (jsonData.success==1) {
				if (jsonData.ShowType!="") {
					showType=jsonData.ShowType;
				}
			}
		})
	};	
});