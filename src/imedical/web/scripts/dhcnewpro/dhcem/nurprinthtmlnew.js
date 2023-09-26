var rowspanCol = "arcimDesc^dosage^phcinDesc^phcfrCode^notes^patName";  //合并列:某个医嘱多条执行记录是否需要合并
var tdTextCol="execCtcpDesc^execDateTime^sttDateTime"; //一条执行记录存在多个医嘱时是否只显示主医嘱的内容

function nurPrintExecForm(orders,queryType,params){
	runClassMethod("web.DHCEMNurPrintHtml","GetPrintDate",{"Orders":orders,"QueryCode":queryType,"Params":params},function(jsonData){
		printTitle = jsonData.printTitle;
		prtinPatInfo = jsonData.printPatInfo;
		var columns = jsonData.columns;
		var printData = jsonData.printData;
		var html=getPrtTempDomObj();
		html=html.setPrintPageTh(columns);
		html=html.setPrintPageTd(columns,printData);
		endGivePrintData();
		
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
		
		LODOP.ADD_PRINT_HTM("15mm",0,"210mm","297mm",html);
		LODOP.SET_PRINT_STYLEA(0,"TableRowThickNess",100)
		var Ret=LODOP.PRINT();
		if(Ret){
			setHtmlPrintFlag();   //设置打印标记
		}
		return;
	})
}

function endGivePrintData(){
	if($("#domFomatArea").lenght){
		$("#domFomatArea").remove();
	}
	return;
}

function getPrtTempDomObj(){
	var prtTmpHtml="";
	prtTmpHtml=prtTmpHtml+"<div id='prtBody' style='width: 195mm;'>";
	prtTmpHtml=prtTmpHtml+"<style>";
	prtTmpHtml=prtTmpHtml+"* {";
	prtTmpHtml=prtTmpHtml+"		font-size:13;";
	prtTmpHtml=prtTmpHtml+"	}";
	prtTmpHtml=prtTmpHtml+"	table,table tr th, table tr td {";
	prtTmpHtml=prtTmpHtml+"		border:1px solid #000000;";
	prtTmpHtml=prtTmpHtml+"		height:40px;";
	prtTmpHtml=prtTmpHtml+"		font-size:13;";
	prtTmpHtml=prtTmpHtml+"		box-sizing: border-box;";
	prtTmpHtml=prtTmpHtml+"		border-collapse:collapse;";
	prtTmpHtml=prtTmpHtml+"	}";
	prtTmpHtml=prtTmpHtml+"	span{";
	prtTmpHtml=prtTmpHtml+"		display:inline-block;";
	prtTmpHtml=prtTmpHtml+"	}";
	prtTmpHtml=prtTmpHtml+"</style>";
	
	prtTmpHtml=prtTmpHtml+"<div class='bodyDiv' style='width: 195mm;'>";
	prtTmpHtml=prtTmpHtml+"<table id='nurPrintTable'  border='0' cellspacing='0' style='table-layout: fixed;word-break:break-all;'><table>";	
	prtTmpHtml=prtTmpHtml+"</div>";	
	prtTmpHtml=prtTmpHtml+"</div>";	
	return prtTmpHtml;
}


String.prototype.formaterDomObj=function(){
	var _s = this;
	var _doc;
	if (typeof window.DOMParser != "undefined") {
		parser = new DOMParser();
		_doc = parser.parseFromString(_s, "text/html");
	}else{
		if(!$("#domFomatArea").lenght){
			$("body").append("<div style='display:none' id='domFomatArea'></div>");
		}
		$("#domFomatArea").html(_s);
		_doc = $("#domFomatArea")[0];
	}
	return _doc;
}

String.prototype.setPrintPageTh=function(){
	var _doc=this.formaterDomObj();
	var columns=arguments[0];
	
	var $table = $("#nurPrintTable",_doc);  //table
	var trHtml="<tr>";
	for (i in columns){
		trHtml =trHtml+"<th style='width:"+columns[i].Width+"mm;max-width:"+columns[i].Width+"mm'>"
		trHtml =trHtml+columns[i].Desc
		trHtml =trHtml+"</th>"
	}
	trHtml =trHtml+"</tr>"
	$table.append(trHtml);
	return $("#prtBody",_doc)[0].outerHTML;
}

///这个方法：添加打印执行单数据：判断是否分页处理
///格式描述[[[{},{},{}],[{},{},{}],[{},{},{}]],[[{}],[{}],[{}]]]
/// 	:[ [],[],[] ]
///格式中有多少种医嘱,每种选中了多少次,每次包含几条医嘱
String.prototype.setPrintPageTd=function(){
	var _doc=this.formaterDomObj();
	var columns=arguments[0];
	var printDatas=arguments[1];
	
	for (j in printDatas){
		var tabPreAddHtml =  $("#nurPrintTable",_doc).html();  //在添加Tr之前
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
		$("#nurPrintTable",_doc).append(onGroupHtml);
	}
	return $("#prtBody",_doc)[0].outerHTML;
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
	SetPrintFlag(orders, "Y");
	SavePrintRecord("PAT",queryTypeCode,orders,LgUserID);
	return;
}

function $g(value){
	return value==undefined?"":value;
}
