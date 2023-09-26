var rowspanCol = "arcimDesc^dosage^phcinDesc^phcfrCode^notes^patName";  //合并列:某个医嘱多条执行记录是否需要合并
var tdTextCol="execCtcpDesc^execDateTime^sttDateTime"; //一条执行记录存在多个医嘱时是否只显示主医嘱的内容
$(document).ready(function(){	
	try{
		runClassMethod("web.DHCEMNurPrintHtml","GetPrintDate",{"Orders":orders,"QueryCode":queryType,"Params":params},function(jsonData){
			printTitle = jsonData.printTitle;
			prtinPatInfo = jsonData.printPatInfo;
			var columns = jsonData.columns;
			var printData = jsonData.printData;
			
			setPrintPagePatInfo(prtinPatInfo);  //设置打印病人信息处内容
			setPrintPageTh(columns);  			//设置打印界面Column
			htmlTemplateHtml=$("body").html();  //获取界面大模板：这个包含界面打印内容表头和表尾
			setPrintPageTd(columns,printData);  //设置打印界面内容
			setTimeout("printPage()","500");   ///给与LODOP的准备时间 
		})
	}catch(e){
		alert(e.message);	
	}
})


//打印
function printPage(){
	LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	
	var lodopIndex=0;
	
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4");
	
	lodopIndex++;
	LODOP.ADD_PRINT_TEXT("0mm","40mm","155mm","10mm",printTitle);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",15);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="患者信息:"+prtinPatInfo.split("^")[2]+"/"+prtinPatInfo.split("^")[4]+"/"+prtinPatInfo.split("^")[5];
	LODOP.ADD_PRINT_TEXT("10mm","0mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="登记号:"+prtinPatInfo.split("^")[3];
	LODOP.ADD_PRINT_TEXT("10mm","55mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="科室:"+prtinPatInfo.split("^")[6];
	LODOP.ADD_PRINT_TEXT("10mm","100mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="范围:"+params.split("^")[2]+"至"+params.split("^")[3];
	LODOP.ADD_PRINT_TEXT("10mm","135mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="打印人:"+LgUserName;
	LODOP.ADD_PRINT_TEXT("280mm","65mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="打印时间:"+prtinPatInfo.split("^")[7]+" "+prtinPatInfo.split("^")[8];
	LODOP.ADD_PRINT_TEXT("280mm","100mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="第#页,共&页";
	LODOP.ADD_PRINT_TEXT("280mm","165mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	
	
	var allHtml=$("body").html();
	$(".noPrintItm").remove();
	var printHtml=$("body").html();
	$("body").html(allHtml);
	
	LODOP.ADD_PRINT_HTM("15mm",0,"210mm","297mm",printHtml);
	LODOP.SET_PRINT_STYLEA(0,"TableRowThickNess",100)
	var Ret=LODOP.PRINT();
	if(Ret){
		setHtmlPrintFlag();   //设置打印标记
		window.close();	
	}
	return;
 }

function setPrintPageTh(columns){
	var $table = $("#nurPrintTable");  //table
	var trHtml="<tr>";
	for (i in columns){
		trHtml =trHtml+"<th style='width:"+columns[i].Width+"mm;max-width:"+columns[i].Width+"mm'>"
		trHtml =trHtml+columns[i].Desc
		trHtml =trHtml+"</th>"
	}
	trHtml =trHtml+"</tr>"
	$table.append(trHtml);
}

///这个方法：添加打印执行单数据：判断是否分页处理
///格式描述[[[{},{},{}],[{},{},{}],[{},{},{}]],[[{}],[{}],[{}]]]
/// 	:[ [],[],[] ]
///格式中有多少种医嘱,每种选中了多少次,每次包含几条医嘱
function setPrintPageTd(columns,printDatas){

	for (j in printDatas){
		var tabPreAddHtml =  $("#nurPrintTable").html();  //在添加Tr之前
		var onGroupHtml="";			   //当前打印单子工多少次
		var printData = printDatas[j]; //数组:即为打印单子中这个医嘱存在多少次执行次数
		var trHtml="";
		for(k in printData){
			var printDataItm = printData[k];
			var rowspanNum = printDataItm[0].RowSpan;
			trHtml="<tr>";
			for (i in columns){
				if((rowspanNum==0)&&(rowspanCol.indexOf(columns[i].Code)!=-1)) continue;
				if(rowspanCol.indexOf(columns[i].Code)!=-1) trHtml =trHtml+"<td rowspan='"+rowspanNum+"' style='width:"+columns[i].Width+"mm;max-width:"+columns[i].Width+"mm'>"
				if(rowspanCol.indexOf(columns[i].Code)==-1) trHtml =trHtml+"<td style='width:"+columns[i].Width+"mm;max-width:"+columns[i].Width+"mm'>"
				trHtml =trHtml+getPrintValue(printDataItm,columns[i].Code);
				trHtml =trHtml+"</td>"
			}
			trHtml =trHtml+"</tr>";
			onGroupHtml = onGroupHtml+trHtml;
		}
		$("#nurPrintTable").append(onGroupHtml);
	}
}

function nextPageOp(tableID,preHtml,trHtml){
	if($(tableID).height()>onePageHeight){
		$(tableID).html(preHtml); 				//还原添加前代码
		$("body").append("<div class='pageNext'></div>  ");
		$(tableID).removeAttr("id");
		$("body").append(htmlTemplateHtml);    	//又一个模板
		$(tableID).append(trHtml);
	}	
}

///获取值：包含子医嘱的是拼接，中间用换行符分割：主要区别
function getPrintValue(printData,Code){
	var ret="";
	if(printData.length==1){
		ret = $g(printData[0][Code]);
	}else{
		///针对一组医嘱多组执行记录，合并每组执行记录的所需要控制的列项目
		if(tdTextCol.indexOf(Code)!=-1){
			ret = $g(printData[0][Code]); 
		}else{
			for(l in printData){
				if (ret!="") ret = ret+"<br/>"+$g(printData[l][Code]);	
				if (ret=="") ret = $g(printData[l][Code]);	
			}
		}
	}
	return ret;
}

function setHtmlPrintFlag(){
	var queryTypeCode=$("#QueryTypeCode").val();
	window.opener.SetPrintFlag(orders, "Y");
	window.opener.SavePrintRecord("PAT",queryTypeCode,orders,LgUserID);
	return;
}

function $g(value){
	return value==undefined?"":value;
}

function setPrintPagePatInfo(patInfo){
	
	$("#pritTitle").html(printTitle);
	$("#patName").html(patInfo.split("^")[2]);	
	$("#patSex").html(patInfo.split("^")[4]);
	$("#patAge").html(patInfo.split("^")[5]);
	$("#patNo").html(patInfo.split("^")[3]);
	$("#patLoc").html(patInfo.split("^")[6]);
	$("#dateArea").html(params.split("^")[2]+"至"+params.split("^")[3]);
	//$("#printUser").html(LgUserName);
	//$("#printDate").html(patInfo.split("^")[7]+" "+patInfo.split("^")[8]);
}