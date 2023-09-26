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
		$.messager.alert("��ʾ","��ѡ����ȷ���·�!");
		return;
	}
	ChangeColumnData(MonthDay,paraval);	
}
//ûʲô����
function InitMonth(){
	//����ѡ�����
	var p = $('#Month').datebox('panel');
	//����ѡ��������·�
	var tds = false;
	//��ʾ�·ݲ�Ĵ����ؼ�
	var span = p.find('span.calendar-text'); 
	$('#Month').datebox({
       //��ʾ����ѡ�������ٴ��������·ݲ���¼�����ʼ��ʱû�������·ݲ�
       onShowPanel: function () {
			//����click�¼������·ݲ�
			span.trigger('click'); 
			if (!tds){
				//��ʱ������ȡ�·ݶ�����Ϊ������¼������Ͷ���������ʱ����
				setTimeout(function() { 
				tds = p.find('div.calendar-menu-month-inner td');
				tds.click(function(e) {
					//��ֹð��ִ��easyui���·ݰ󶨵��¼�
					e.stopPropagation(); 
					//�õ����
					var year = /\d{4}/.exec(span.html())[0] ,
					//�·�
					//֮ǰ��������month = parseInt($(this).attr('abbr'), 10) + 1; 
					month = parseInt($(this).attr('abbr'), 10);  

					//�������ڶ���                     
					$('#Month').datebox('hidePanel') 
					//�������ڵ�ֵ
					.datebox('setValue', year + '-' + month); 
				});
				}, 0);
       		}
        },
        onSelect:function(date){
	        MonthAppReportDataLoad();
	    },
        //����parser������ѡ�������
        parser: function (s) {
            if (!s) return new Date();
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
        },
        //����formatter��ֻ��������
        formatter: function (d) { 
            var currentMonth = (d.getMonth()+1);
            var currentMonthStr = currentMonth < 10 ? ('0' + currentMonth) : (currentMonth + '');
            return d.getFullYear() + '-' + currentMonthStr; 
        }
	});
	var curr_time = new Date();
	//����ǰ����
	$("#Month").datebox("setValue", myFormatter(curr_time));
}

function myFormatter(date) {
    //��ȡ���
    var y = date.getFullYear();
    //��ȡ�·�
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
			$.messager.alert("��ʾ","ѡ���ѯ������");
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
	//����
	for(var i=1;i<=_DataCount;i++){
	    var timeRet = cspRunServerMethod(ServerObj.GetMonthAppTimeInfoMethod,i,UserID);
	    var rowTemplate = '<tr align="left" class="tr_'+i+'"><td>'+timeRet+'</td>';
	    for(var j=1;j<=MonthDay;j++){ //��
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
			$.messager.alert("��ʾ","δ��ȡ����������");
			return false;
		}
		//��ӡ
		var PrintNum = 1; //��ӡ����
		var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
		var SelDate=$('#Month').datebox('getText');
	   	if(SelDate==""){
			return false;
		}
		var SelDateArr=SelDate.split('-');
		SelDate=SelDateArr[0]+"-"+SelDateArr[1]; 
		var MonthDay=getDaysInMonth(SelDateArr[0],SelDateArr[1]);
		var GroupDesc=$('#ResGroup').combobox('getText');
		var Title=SelDate+"��"+GroupDesc+"ԤԼ��";
		var TaskName=Title; //��ӡ��������
		var UserID=session['LOGON.USERID'];
		//��ϸ��Ϣչʾ
		var Cols=[
			{field:"0",title:"ʱ��",width:60,align:"center"}
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
		   	$.messager.alert("��ʾ","ѡ���ѯ�·�");
			return false;
		}
		var GroupDr=$('#ResGroup').combobox('getValue');
		var GroupDr=CheckComboxSelData("ResGroup",GroupDr);
		if(GroupDr==""){
		   	$.messager.alert("��ʾ","ѡ�������");
			return false;
		}
		var GroupDesc=$('#ResGroup').combobox('getText');
		var Title=GroupDesc+"ԤԼ��";	
	   	var SelDateArr=SelDate.split('-')
		SelDate=SelDateArr[0]+"-"+SelDateArr[1]; 
		var MonthDay=getDaysInMonth(SelDateArr[0],SelDateArr[1]);
		var StartDate=SelDate+"-"+1;
		var EndDate=SelDate+"-"+MonthDay;
		var UserID=session['LOGON.USERID'];
		
		//var _DataCount=tkMakeServerCall("DHCDoc.DHCDocCure.WordReport","MonthAppReport",StartDate,EndDate,GroupDr,UserID);
		if(_DataCount==0){
			$.messager.alert("��ʾ","δ��ȡ����������");
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

    	xlsheet.cells(2,2)=SelDate+" ��";

    	var xlsrow=3;
    	
	    for(var i=1;i<=_DataCount;i++){
		    xlsrow=xlsrow+1;
		    var ret = cspRunServerMethod(ServerObj.GetMonthAppTimeInfoMethod,i,UserID);
		    xlsheet.cells(xlsrow,1)=ret;
		    for(var j=1;j<=MonthDay;j++){ //��
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