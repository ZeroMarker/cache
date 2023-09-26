var rowspanCol = "arcimDesc^dosage^phcinDesc^phcfrCode^notes^patName";  //�ϲ���:ĳ��ҽ������ִ�м�¼�Ƿ���Ҫ�ϲ�
var tdTextCol="execCtcpDesc^execDateTime^sttDateTime"; //һ��ִ�м�¼���ڶ��ҽ��ʱ�Ƿ�ֻ��ʾ��ҽ��������
$(document).ready(function(){	
	try{
		runClassMethod("web.DHCEMNurPrintHtml","GetPrintDate",{"Orders":orders,"QueryCode":queryType,"Params":params},function(jsonData){
			printTitle = jsonData.printTitle;
			prtinPatInfo = jsonData.printPatInfo;
			var columns = jsonData.columns;
			var printData = jsonData.printData;
			
			setPrintPagePatInfo(prtinPatInfo);  //���ô�ӡ������Ϣ������
			setPrintPageTh(columns);  			//���ô�ӡ����Column
			htmlTemplateHtml=$("body").html();  //��ȡ�����ģ�壺������������ӡ���ݱ�ͷ�ͱ�β
			setPrintPageTd(columns,printData);  //���ô�ӡ��������
			setTimeout("printPage()","500");   ///����LODOP��׼��ʱ�� 
		})
	}catch(e){
		alert(e.message);	
	}
})


//��ӡ
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
	var text="������Ϣ:"+prtinPatInfo.split("^")[2]+"/"+prtinPatInfo.split("^")[4]+"/"+prtinPatInfo.split("^")[5];
	LODOP.ADD_PRINT_TEXT("10mm","0mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="�ǼǺ�:"+prtinPatInfo.split("^")[3];
	LODOP.ADD_PRINT_TEXT("10mm","55mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="����:"+prtinPatInfo.split("^")[6];
	LODOP.ADD_PRINT_TEXT("10mm","100mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="��Χ:"+params.split("^")[2]+"��"+params.split("^")[3];
	LODOP.ADD_PRINT_TEXT("10mm","135mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="��ӡ��:"+LgUserName;
	LODOP.ADD_PRINT_TEXT("280mm","65mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="��ӡʱ��:"+prtinPatInfo.split("^")[7]+" "+prtinPatInfo.split("^")[8];
	LODOP.ADD_PRINT_TEXT("280mm","100mm","100mm","10mm",text);
	LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	lodopIndex++;
	var text="��#ҳ,��&ҳ";
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
		setHtmlPrintFlag();   //���ô�ӡ���
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

///�����������Ӵ�ӡִ�е����ݣ��ж��Ƿ��ҳ����
///��ʽ����[[[{},{},{}],[{},{},{}],[{},{},{}]],[[{}],[{}],[{}]]]
/// 	:[ [],[],[] ]
///��ʽ���ж�����ҽ��,ÿ��ѡ���˶��ٴ�,ÿ�ΰ�������ҽ��
function setPrintPageTd(columns,printDatas){

	for (j in printDatas){
		var tabPreAddHtml =  $("#nurPrintTable").html();  //�����Tr֮ǰ
		var onGroupHtml="";			   //��ǰ��ӡ���ӹ����ٴ�
		var printData = printDatas[j]; //����:��Ϊ��ӡ���������ҽ�����ڶ��ٴ�ִ�д���
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
		$(tableID).html(preHtml); 				//��ԭ���ǰ����
		$("body").append("<div class='pageNext'></div>  ");
		$(tableID).removeAttr("id");
		$("body").append(htmlTemplateHtml);    	//��һ��ģ��
		$(tableID).append(trHtml);
	}	
}

///��ȡֵ��������ҽ������ƴ�ӣ��м��û��з��ָ��Ҫ����
function getPrintValue(printData,Code){
	var ret="";
	if(printData.length==1){
		ret = $g(printData[0][Code]);
	}else{
		///���һ��ҽ������ִ�м�¼���ϲ�ÿ��ִ�м�¼������Ҫ���Ƶ�����Ŀ
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
	$("#dateArea").html(params.split("^")[2]+"��"+params.split("^")[3]);
	//$("#printUser").html(LgUserName);
	//$("#printDate").html(patInfo.split("^")[7]+" "+patInfo.split("^")[8]);
}