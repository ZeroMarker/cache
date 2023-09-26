/*
LODOP��ӡ
*/
/*ͨ�õ��ݴ�ӡ
PrintNum����ӡ����
IndirPrint���Ƿ�Ԥ����ӡ Y��N
TaskName����ӡ��������
Title����ͷ
Head��ҳü
Foot��ҳβ
Cols������ж���
DetailData�����������
*/
function PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData) {
	
	if(PrintNum==""){PrintNum=1}
	if(IndirPrint==""){IndirPrint="Y"}
	if(TaskName==""){TaskName="���ݴ�ӡ"}
	
	/*�ж�Lodop�ؼ�*/
	var LODOP=getLodop();
	/*��ʼ��*/
	LODOP.PRINT_INIT(TaskName);
	var intOrient=2; //��ӡ����
	var PageWidth=2410; //���ӵ�λ,Ĭ��0.1mm
	var PageHeight=1430; //���ӵ�λ,Ĭ��0.1mm
	var strPageName="A4"; //��width��height��������ʱ��������
	LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
	LODOP.SET_PRINT_STYLE("FontSize", 11); //��λ��pt
	
	/*ģ������*/
	/*����*/
	LODOP.ADD_PRINT_TEXT(5,5,925,30,Title);  //������
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
	
	/*ҳü*/
	LODOP.ADD_PRINT_TEXT(35,5,925,30,Head);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	/*ҳβ*/
	LODOP.ADD_PRINT_TEXT(330,1,700,30,Foot);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.ADD_PRINT_TEXT(330,800,130,30,"��#ҳ/��&ҳ");
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	/*���*/
	//ģ����Ϣ����
	var TableFootsPage="Y";//ÿҳ�ϼ�
	var TableFootsTotal="Y";//�ܺϼ�
	var HeadTrHeight=20;//��ͷ
	var HeadFontsize="9pt";
	var DataTrHeight=20;//����
	var DataFontsize="9pt";
	var FootTrHeight=20;//��β
	var FootFontsize="9pt";
	
	//�Ƿ���
	var ifnewline=0;
	var nowrap="",newlinetable="",newlinedata="";
	if (ifnewline==1){
		//��񲻳ſ����ַ��������У����ֻ��У�ע���ַ������Ḳ����һ�У�
		newlinetable="table-layout:fixed;";
		newlinedata="";
	}else if(ifnewline==2){
		//����ſ����ַ����ͺ��ֶ�������
		nowrap="nowrap";
		newlinetable="";
		newlinedata="";
	}else{
		//��񲻳ſ����ַ����ͺ��ֶ�����
		newlinetable="table-layout:fixed;";
		newlinedata="word-wrap:break-word;";
	}
	
	var strTableStyle = "<style type='text/css'>table{}</style>";
	var strTableStartHtml = "<table width='100%' style='border-right:1px solid gray;border-bottom:1px solid gray;"+newlinetable+"' cellpadding='0' cellspacing='0' align='center'>";
	var strTableEndHtml = "</table>";
	//����
	var strTableTheadHtml = "<thead style='height: "+HeadTrHeight+"' ><tr style='height: "+HeadTrHeight+"'>";
	var colslen=Cols.length;
	for (var i = 0; i < colslen; i++){
		var tmobj=Cols[i];
		var title=tmobj.title;
		var width=tmobj.width;
		var td = "<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+HeadFontsize+";' width='"+width+"'>"+ title+ "</th>"; 
		strTableTheadHtml += td;
	}
	strTableTheadHtml += "</tr></thead>";
	//������
	var strTableTrHtml = "";
	for (i = 0; i < DetailData.length; i++) {
		var DetailObj = DetailData[i];
		var td = "<tr style='height: "+DataTrHeight+"'>"
		for (var j = 0; j < colslen; j++){  //ѭ����
			var tmobj=Cols[j];
			var field=tmobj.field;
			var align=tmobj.align;
			var format=tmobj.format;
			if (field=="Num"){
				var data=i+1;
			}else{
				var data=DetailObj[field];
			}
			if(format!=""&&format!=undefined){  //��ʽ�� ����ʾ��40
				//data=LODOP.FORMAT("FLOAT:"+format+"",data)
			}
			td += "<td "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+DataFontsize+";"+newlinedata+"' align='"+align+"'>" + data + "</td>";
		}
		td += "</tr>";
		strTableTrHtml += td;
	}
	//�ϼ���
	var strTableFootHtml = ""
	var strTableFootP="<tr style='height: "+FootTrHeight+"'>"  //��ҳ
	var strTableFootT="<tr style='height: "+FootTrHeight+"'>"  //��
	for (var j = 0; j < colslen; j++){  //ѭ����
		if(j==1){
			strTableFootP+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";'><font>��ҳ����:</font></th>";
			strTableFootT+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";'><font>������:</font></th>";
		}
		else if(j==2){
			strTableFootP+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";' align='right' tdata='SubCount' format='#'>###</th>";
			strTableFootT+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";' align='right' tdata='AllCount' format='#'>###</th>";
		}
		else if(Cols[j].sum=="Y"){
			strTableFootP+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";' align='"+Cols[j].align+"' tdata='SubSum' format='"+Cols[j].format+"'>###</th>";
			strTableFootT+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";' align='"+Cols[j].align+"' tdata='AllSum' format='"+Cols[j].format+"'>###</th>";
		}
		else{
			strTableFootP+="<th style='border-left:1px solid gray;border-top:1px solid gray;'></th>";
			strTableFootT+="<th style='border-left:1px solid gray;border-top:1px solid gray;'></th>";
		}
	}
	strTableFootP+="</tr>"
	strTableFootT+="</tr>"
	var tableFootheight=0
	if(TableFootsPage=="Y"){strTableFootHtml+=strTableFootP;tableFootheight+=FootTrHeight};//ÿҳ�ϼ�
	if(TableFootsTotal=="Y"){strTableFootHtml+=strTableFootT;tableFootheight+=FootTrHeight};//�ܺϼ�
	
	var tableheight=255;//���߶ȣ������ϼ��У�
	if(strTableFootHtml!=""){tableheight-=tableFootheight;strTableFootHtml="<tfoot>"+strTableFootHtml+"</tfoot>";}
	LODOP.ADD_PRINT_HTM(50, 0, 800, 1000, strTableStyle);
	LODOP.ADD_PRINT_TABLE(65, 0, "100%", tableheight, strTableStartHtml
					+ strTableTheadHtml + strTableTrHtml + strTableFootHtml
					+ strTableEndHtml);
	//LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Width");  //������
	
	/*������ӡ*/
	LODOP.SET_PRINT_COPIES(PrintNum)  //���ô�ӡ����
	if (IndirPrint == "N") {
		LODOP.PRINT ();  //ֱ�Ӵ�ӡ
	}
	else{
		LODOP.PREVIEW();  //Ԥ����ӡ
	}
	
	//LODOP.PRINT ();  //ֱ�Ӵ�ӡ
	//LODOP.PREVIEW();  //Ԥ����ӡ
	//LODOP.PRINT_SETUP();  //Ԥ��ά�����ɵ���λ�����ô�С��
	//LODOP.PRINT_DESIGN();  //��ӡ��ƣ�������Ƹ��ƴ��룩
}