var CureReportDataGrid;
var _DataCount=0;
$(document).ready(function(){
	Init();
	InitEvent();
	MonthAppReportDataLoad(1);
});

function Init(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		InitResGroup();	
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitResGroup();	
	}	
	InitMonth();
	$('#Month').datebox("disableValidation");
}

function MonthAppReportDataLoad(paraval){
	if(typeof(paraval)=="undefined"){
		paraval="";	
	}
	var date=$('#Month').datebox("getValue");
	if((date!="")&&(date!=undefined)){
		var y=date.split("-")[0]
		var m=date.split("-")[1]
	}else{
		var date=new Date();
	    var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
	}
    var MonthDay=getDaysInMonth(y,m);
	if (!MonthDay) {
		$.messager.alert("提示","请选择正确的月份!");
		return;
	}
	ChangeColumnData(MonthDay,paraval);	
}
//没什么卵用
function InitMonth(){
	//日期选择对象
	var p = $('#Month').datebox('panel');
	//日期选择对象中月份
	var tds = false;
	//显示月份层的触发控件
	var span = p.find('span.calendar-text'); 
	$('#Month').datebox({
       //显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层
       onShowPanel: function () {
			//触发click事件弹出月份层
			span.trigger('click'); 
			if (!tds){
				//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔
				setTimeout(function() { 
				tds = p.find('div.calendar-menu-month-inner td');
				tds.click(function(e) {
					//禁止冒泡执行easyui给月份绑定的事件
					e.stopPropagation(); 
					//得到年份
					var year = /\d{4}/.exec(span.html())[0] ,
					//月份
					//之前是这样的month = parseInt($(this).attr('abbr'), 10) + 1; 
					month = parseInt($(this).attr('abbr'), 10);  

					//隐藏日期对象                     
					$('#Month').datebox('hidePanel') 
					//设置日期的值
					.datebox('setValue', year + '-' + month); 
				});
				}, 0);
       		}
        },
        onSelect:function(date){
	        MonthAppReportDataLoad();
	    },
        //配置parser，返回选择的日期
        parser: function (s) {
            if (!s) return new Date();
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
        },
        //配置formatter，只返回年月
        formatter: function (d) { 
            var currentMonth = (d.getMonth()+1);
            var currentMonthStr = currentMonth < 10 ? ('0' + currentMonth) : (currentMonth + '');
            return d.getFullYear() + '-' + currentMonthStr; 
        }
	});
	var curr_time = new Date();
	//设置前当月
	$("#Month").datebox("setValue", myFormatter(curr_time));
}

function myFormatter(date) {
    //获取年份
    var y = date.getFullYear();
    //获取月份
    var m = date.getMonth() + 1;
    return y + '-' + m;
}

function InitEvent(){
	$('#btnFind').click(MonthAppReportDataLoad);
    $('#btnExport').click(PrintReport);
	$('#btnPrint').click(PrintReport);
    $HUI.combobox("#ResGroup",{
		onSelect:function(){
			//MonthAppReportDataLoad();
		}    
	})
}

function getDaysInMonth(year,month){
	return new Date(year, month, 0).getDate();
 }
 
function ChangeColumnData(MonthDay,paraval){
	_DataCount=0;
	$("#tabRecordReportList th").size();
	var lie = $("#tabRecordReportList").find("tr").find("th").length-1; 
	if(MonthDay>lie){
		for(var i=(MonthDay-lie);i>0;i--){
			var Day=MonthDay-i+1;
			var colstr="<th style='width:30px' align='left' field='Day"+Day+"'>"+Day+"</th>"
			$col = $(colstr);  
			$("#tabRecordReportList>tbody>tr").append($col);  
		}	
	}else if(MonthDay<lie){
		for(var i=(lie-MonthDay);i>0;i--){
			$("#tabRecordReportList tr :last-child").remove();    
		}
	}
	var tabtrlen=$("#tabRecordReportList").find("tr").length;
	for(var i=1;i<tabtrlen;i++){
		$("#tabRecordReportList tr:not(:first):last").remove();       	
	}
	
	var SelDate=$('#Month').datebox('getText');
   	if(SelDate==""){
		return false;
	}
	var GroupDr=$('#ResGroup').combobox('getValue');
	var GroupDr=CheckComboxSelData("ResGroup",GroupDr);	
	if(GroupDr==""){
		if((paraval=="")){
			$.messager.alert("提示","选择查询服务组");
		}
		return false;
	}
   	var SelDateArr=SelDate.split('-')
	SelDate=SelDateArr[0]+"-"+SelDateArr[1]; 
	var MonthDay=getDaysInMonth(SelDateArr[0],SelDateArr[1]);
	var StartDate=SelDate+"-"+1;
	var EndDate=SelDate+"-"+MonthDay;
	var UserID=session['LOGON.USERID'];
	var HospDr=Util_GetSelUserHospID();	 //workreport.inititem.js
		
	_DataCount = cspRunServerMethod(ServerObj.MonthAppReportMethod,StartDate,EndDate,GroupDr,UserID,HospDr);
	//行数
	for(var i=1;i<=_DataCount;i++){
	    var timeRet = cspRunServerMethod(ServerObj.GetMonthAppTimeInfoMethod,i,UserID);
	    var rowTemplate = '<tr align="left" class="tr_'+i+'"><td>'+timeRet+'</td>';
	    for(var j=1;j<=MonthDay;j++){ //列
		    var ret = cspRunServerMethod(ServerObj.GetMonthAppInfoMethod,j,i,UserID);
		    var Time="";
		    var Count="-";
		    if(ret!=""){
				 Time=ret.split("^")[0];
				 Count =ret.split("^")[1];
			}
			rowTemplate = rowTemplate+'<td align="left">'+Count+'</td>';
	    }
	    rowTemplate = rowTemplate+'</tr>';
	    var tableHtml = $("#tabRecordReportList tbody").html();
	    tableHtml += rowTemplate;
	    $("#tabRecordReportList tbody").html(tableHtml);
    }
}

function PrintReport(){
	try{
		if(_DataCount==0){
			$.messager.alert("提示","未获取到导出数据");
			return false;
		}
		//打印
		var PrintNum = 1; //打印次数
		var IndirPrint = "N"; //是否预览打印
		var SelDate=$('#Month').datebox('getText');
	   	if(SelDate==""){
			return false;
		}
		var SelDateArr=SelDate.split('-');
		SelDate=SelDateArr[0]+"-"+SelDateArr[1]; 
		var MonthDay=getDaysInMonth(SelDateArr[0],SelDateArr[1]);
		var GroupDesc=$('#ResGroup').combobox('getText');
		var Title=SelDate+"月"+GroupDesc+"预约表";
		var TaskName=Title; //打印任务名称
		var UserID=session['LOGON.USERID'];
		//明细信息展示
		var Cols=[
			{field:"0",title:"时段",width:60,align:"center"}
		];
		for(var j=1;j<=MonthDay;j++){
			Cols.push({field:j,title:j,width:"10%",align:"center"});
		}
		var DataArr=new Array();
		for(var i=1;i<=_DataCount;i++){
			var _$tb=$(".tr_"+i+" td");
			var obj=new Object();
			for (var j=0;j<_$tb.length;j++){
				var text=$(_$tb[j])[0].innerHTML;
				obj[j]=text;
			}
			DataArr.push(obj);
		}
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DataArr);
		PrintDocument(PrintNum,"Y",TaskName,Title,Cols,DataArr)
		return;
		
		/*var SelDate=$('#Month').datebox('getText');
	   	if(SelDate==""){
		   	$.messager.alert("提示","选择查询月份");
			return false;
		}
		var GroupDr=$('#ResGroup').combobox('getValue');
		var GroupDr=CheckComboxSelData("ResGroup",GroupDr);
		if(GroupDr==""){
		   	$.messager.alert("提示","选择服务组");
			return false;
		}
		var GroupDesc=$('#ResGroup').combobox('getText');
		var Title=GroupDesc+"预约表";	
	   	var SelDateArr=SelDate.split('-')
		SelDate=SelDateArr[0]+"-"+SelDateArr[1]; 
		var MonthDay=getDaysInMonth(SelDateArr[0],SelDateArr[1]);
		var StartDate=SelDate+"-"+1;
		var EndDate=SelDate+"-"+MonthDay;
		var UserID=session['LOGON.USERID'];
		
		//var _DataCount=tkMakeServerCall("DHCDoc.DHCDocCure.WordReport","MonthAppReport",StartDate,EndDate,GroupDr,UserID);
		if(_DataCount==0){
			$.messager.alert("提示","未获取到导出数据");
			return false;
		}
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureMonthAppReport.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	xlsheet.cells(1,1)=Title;

    	xlsheet.cells(2,2)=SelDate+" 月";

    	var xlsrow=3;
    	
	    for(var i=1;i<=_DataCount;i++){
		    xlsrow=xlsrow+1;
		    var ret = cspRunServerMethod(ServerObj.GetMonthAppTimeInfoMethod,i,UserID);
		    xlsheet.cells(xlsrow,1)=ret;
		    for(var j=1;j<=MonthDay;j++){ //列
	    		xlsheet.cells(3,j+1)=j;
			    var ret = cspRunServerMethod(ServerObj.GetMonthAppInfoMethod,j,i,UserID);
			    var Time="";
			    var Count="-";
			    if(ret!=""){
					 Time=ret.split("^")[0];
					 Count =ret.split("^")[1];
				}
			   
			    xlsheet.cells(xlsrow,j+1)=Count;
		    }
	    }
	    //xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,32)
		xlsheet.printout;
		//xlApp.ActiveWorkBook.Saved = false;
		xlBook.Close (savechanges=true);
		//xlApp.Visible=false;
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;*/
	}catch(e){
		alert(e.message);	
	}
}