/*
LODOP打印
*/
/*通用单据打印
PrintNum：打印次数
IndirPrint：是否预览打印 Y，N
TaskName：打印任务名称
Title：表头
Cols：表格列定义
DetailData：表格列数据
*/
function PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData) {
	
	if(PrintNum==""){PrintNum=1}
	if(IndirPrint==""){IndirPrint="Y"}
	if(TaskName==""){TaskName="单据打印"}
	
	/*判断Lodop控件*/
	var LODOP=getLodop();
	/*初始化*/
	LODOP.PRINT_INIT(TaskName);
	var intOrient=3; //打印方向
	var PageWidth='0'; //不加单位,默认0.1mm
	var PageHeight='0'; //不加单位,默认0.1mm
	var strPageName="A4"; //当width和height不起作用时，才有用
	LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
	LODOP.SET_PRINT_STYLE("FontSize", 11); //单位是pt
	LODOP.SET_PRINT_MODE("RESELECT_PAGESIZE",true); //允许重选纸张
	/*模板内容*/
	/*标题*/
	LODOP.ADD_PRINT_TEXT(5,5,925,30,Title);  //上左宽高
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
	
	LODOP.ADD_PRINT_TEXT(330,800,130,30,"第#页/共&页");
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	/*表格*/
	//模板信息设置
	//var TableFootsPage="Y";//每页合计
	//var TableFootsTotal="Y";//总合计
	var HeadTrHeight=20;//表头
	var HeadFontsize="9pt";
	var DataTrHeight=20;//数据
	var DataFontsize="9pt";
	var FootTrHeight=20;//表尾
	var FootFontsize="9pt";
	var tableFootheight=0
	//if(TableFootsPage=="Y"){strTableFootHtml+=strTableFootP;tableFootheight+=FootTrHeight};//每页合计
	//if(TableFootsTotal=="Y"){strTableFootHtml+=strTableFootT;tableFootheight+=FootTrHeight};//总合计
	
	var tableheight=255;//表格高度（不含合计行）
	//if(strTableFootHtml!=""){tableheight-=tableFootheight;strTableFootHtml="<tfoot>"+strTableFootHtml+"</tfoot>";}
	var tableStyle={
		HeadTrHeight:HeadTrHeight,
		HeadFontsize:HeadFontsize,
		DataTrHeight:DataTrHeight,
		DataFontsize:DataFontsize,
		FootTrHeight:FootTrHeight,
		FootFontsize:FootFontsize,
		ifnewline:0
	}
	
	var strTableStyle = "<style type='text/css'>table{}</style>";
	LODOP.ADD_PRINT_HTM(50, 0, 800, 1000, strTableStyle);
	var TableHtml=GetPrintTableHtml(tableStyle,Cols,DetailData)
	LODOP.ADD_PRINT_TABLE(30, 0, "100%", '100%', TableHtml);
	//LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Width");  //按整宽
	/*结束打印*/
	LODOP.SET_PRINT_COPIES(PrintNum)  //设置打印次数
	if (IndirPrint == "N") {
		LODOP.PRINT ();  //直接打印
	}
	else{
		LODOP.PREVIEW();  //预览打印
	}
}
///tanjishan
///将json数据转换成表格代码段
///tableStyle:表格的一些样式;Cols:列头；DetailData：数据列
function GetPrintTableHtml(tableStyle,Cols,DetailData){
	
	var HeadTrHeight=tableStyle.HeadTrHeight;//表头高度
	var HeadFontsize=tableStyle.HeadFontsize;//表头字体大小
	var DataTrHeight=tableStyle.DataTrHeight;//每行数据高度
	var DataFontsize=tableStyle.DataFontsize;//每行数据字体大小
	var FootTrHeight=tableStyle.FootTrHeight;//表尾高度
	var FootFontsize=tableStyle.FootFontsize;//表尾数据字体大小
	//是否换行
	var ifnewline=tableStyle.ifnewline;;
	var nowrap="",newlinetable="",newlinedata="";
	if (ifnewline==1){
		//表格不撑开，字符串不换行，汉字换行（注：字符串长会覆盖下一列）
		newlinetable="table-layout:fixed;";
		newlinedata="";
	}else if(ifnewline==2){
		//表格会撑开，字符串和汉字都不换行
		nowrap="nowrap";
		newlinetable="";
		newlinedata="";
	}else{
		//表格不撑开，字符串和汉字都换行
		newlinetable="table-layout:fixed;";
		newlinedata="word-wrap:break-word;";
	}
	
	
	var strTableStartHtml = "<table width='100%' style='border-right:1px solid gray;border-bottom:1px solid gray;"+newlinetable+"' cellpadding='0' cellspacing='0' align='center'>";
	var strTableEndHtml = "</table>";
	//列名
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
	//数据行
	var strTableTrHtml = "";
	for (i = 0; i < DetailData.length; i++) {
		var DetailObj = DetailData[i];
		var td = "<tr style='height: "+DataTrHeight+"'>"
		for (var j = 0; j < colslen; j++){  //循环列
			var tmobj=Cols[j];
			var field=tmobj.field;
			var align=tmobj.align;
			var format=tmobj.format;
			if (field=="Num"){
				var data=i+1;
			}else{
				var data=DetailObj[field];
			}
			if(format!=""&&format!=undefined){  //格式化 参照示例40
				data=LODOP.FORMAT("FLOAT:"+format+"",data)
			}
			td += "<td "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+DataFontsize+";"+newlinedata+"' align='"+align+"'>" + data + "</td>";
		}
		td += "</tr>";
		strTableTrHtml += td;
	}
	//合计行
	var strTableFootHtml = ""
	var strTableFootP="<tr style='height: "+FootTrHeight+"'>"  //本页
	var strTableFootT="<tr style='height: "+FootTrHeight+"'>"  //总
	for (var j = 0; j < colslen; j++){  //循环列
		if(j==1){
			strTableFootP+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";'><font>本页行数:</font></th>";
			strTableFootT+="<th "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+FootFontsize+";'><font>总行数:</font></th>";
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
	strTableFootP+="</tr>";
	strTableFootT+="</tr>";
	return strTableStartHtml+ strTableTheadHtml + strTableTrHtml + strTableFootHtml+ strTableEndHtml;
}