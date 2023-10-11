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
confObj:其他选项
	subText:标题下方需要带的某些内容
	hospTitle:是否需要单独打印医院标题
*/
var _LODOP_PrintFunObj={
	LODOP:""
}
function PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData,confObj) {
	var _confObj={
		subText:"",
		hospTitle:"N"
	}
	_LODOP_PrintFunObj.LODOP=getLodop();
	$.extend(_confObj,confObj)
	if(PrintNum==""){PrintNum=1}
	if(IndirPrint==""){IndirPrint="Y"}
	if(TaskName==""){TaskName="单据打印"}
	if(typeof _confObj.subText=="undefined"){_confObj.subText="";}
	/*判断Lodop控件*/
	
	/*初始化*/
	_LODOP_PrintFunObj.LODOP.PRINT_INIT(TaskName);
	var intOrient=3; //打印方向
	var PageWidth='0'; //不加单位,默认0.1mm
	var PageHeight='0'; //不加单位,默认0.1mm
	var strPageName="A4"; //当width和height不起作用时，才有用
	_LODOP_PrintFunObj.LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLE("FontSize", 11); //单位是pt
	_LODOP_PrintFunObj.LODOP.SET_PRINT_MODE("RESELECT_PAGESIZE",true); //允许重选纸张
	/**
	*Alignment的值：数字型，1--左靠齐 2--居中 3--右靠齐，缺省值是1。
	*ItemType的值：	数字型，0--普通项 1--页眉页脚 2--页号项 3--页数项 4--多页项 
					缺省（不调用本函数时）值0。
					0--普通项只打印一次；
					1--页眉页脚项则每页都在固定位置重复打印；
					2--页号项和3--页数项是特殊的页眉页脚项，其内容包含当前页号和全部页数；
					4--多页项每页都打印，直到把内容打印完毕，打印时在每页上的位置和区域大小固定一样（多页项只对纯文本有效）
              		在页号或页数对象的文本中，有两个特殊控制字符：“#”特指“页号”，“&”特指“页数”。
	*/
	var SttHeight=5;
	/*模板内容*/
	/*医院*/
	if(_confObj.hospTitle=="Y" && session['LOGON.HOSPDESC']!=""){
		AddHeight=30;
		_LODOP_PrintFunObj.LODOP.ADD_PRINT_TEXT(SttHeight,0,850,30,session['LOGON.HOSPDESC']);  //上左宽高
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
		SttHeight+=30;
	}
	/*标题*/
	_LODOP_PrintFunObj.LODOP.ADD_PRINT_TEXT(SttHeight,0,850,30,Title);  //上左宽高
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
	SttHeight+=30;
	/*标题下带的某些内容*/
	if(_confObj.subText!=""){
		_LODOP_PrintFunObj.LODOP.ADD_PRINT_TEXT(SttHeight,5,925,15,_confObj.subText);  //上左宽高
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "FontSize", 9);
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "Bold", 0);
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"Alignment",1);
		SttHeight+=15;
	}
	
	_LODOP_PrintFunObj.LODOP.ADD_PRINT_TEXT(0,800,130,20,"第#页/共&页");
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0, "Bold", 0);
	_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
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
	var tabWidth=800;//表格宽度
	//if(strTableFootHtml!=""){tableheight-=tableFootheight;strTableFootHtml="<tfoot>"+strTableFootHtml+"</tfoot>";}
	var tableStyle={
		HeadTrHeight:HeadTrHeight,
		HeadFontsize:HeadFontsize,
		DataTrHeight:DataTrHeight,
		DataFontsize:DataFontsize,
		FootTrHeight:FootTrHeight,
		FootFontsize:FootFontsize,
		ifnewline:0,
		tabSttHeight:SttHeight,
		tabWidth:tabWidth
	}
	
	var strTableStyle = "<style type='text/css'>table{}</style>";
	_LODOP_PrintFunObj.LODOP.ADD_PRINT_HTM(SttHeight+20, 0, tableStyle.tabWidth, 980, strTableStyle);
	var TableHtml=GetPrintTableHtml(tableStyle,Cols,DetailData)
	_LODOP_PrintFunObj.LODOP.ADD_PRINT_TABLE(SttHeight, 0, "100%", '100%', TableHtml);
	//_LODOP_PrintFunObj.LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Width");  //按整宽
	/*结束打印*/
	_LODOP_PrintFunObj.LODOP.SET_PRINT_COPIES(PrintNum)  //设置打印次数
	if (IndirPrint == "N") {
		_LODOP_PrintFunObj.LODOP.PRINT ();  //直接打印
	}
	else{
		_LODOP_PrintFunObj.LODOP.PREVIEW();  //预览打印
	}
}
///tanjishan
///将json数据转换成表格代码段
///tableStyle:表格的一些样式;Cols:列头；DetailData：数据列
///CA签名图片打印需求，将某一列imageFlag设为true，目前仅支持一列
function GetPrintTableHtml(tableStyle,Cols,DetailData){
	var HeadTrHeight=tableStyle.HeadTrHeight;//表头高度
	var HeadFontsize=tableStyle.HeadFontsize;//表头字体大小
	var DataTrHeight=tableStyle.DataTrHeight;//每行数据高度
	var DataFontsize=tableStyle.DataFontsize;//每行数据字体大小
	var FootTrHeight=tableStyle.FootTrHeight;//表尾高度
	var FootFontsize=tableStyle.FootFontsize;//表尾数据字体大小
	var tabSttHeight=tableStyle.tabSttHeight;//表格起始高度
	var tabWidth=tableStyle.tabWidth;//表格宽度
	var imgSttHeight=tabSttHeight+HeadTrHeight; //拿来计算图片打印位置-上边距
	var imgSttWidth=-20;//拿来计算图片打印位置-左边距
	var imgWidth=0,imgHeight=DataTrHeight;
	if (!websys_isIE){imgHeight+=10};
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
	var base64RegExp=RegExp(/data:image\/.*;base64,/);
	var numRegExp=RegExp(/^([0-9]\d{0,1}|100[%]{1}$)(\.\d{1,2})?%?$/);
	var findImg=false;
	
	for (var i = 0; i < colslen; i++){
		var tmobj=Cols[i];
		var title=tmobj.title;
		var width=tmobj.width;
		//计算ca图片的宽度和左边距
		var imageFlag=tmobj.imageFlag;
		var acWidth=(numRegExp.test(width))?((parseFloat(width)/100)*tabWidth):width;
		acWidth=parseFloat(acWidth);
		if(!imageFlag){
			if(!findImg)imgSttWidth+=acWidth;
		}else{
			imgWidth=(50<acWidth)?50:acWidth;
			findImg=true;	
		}
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
			if((data==undefined)||(typeof data=="undefined")){
				data="";	
			}
			if(format!=""&&format!=undefined){  //格式化 参照示例40
				data=_LODOP_PrintFunObj.LODOP.FORMAT("FLOAT:"+format+"",data)
			}
			if(base64RegExp.test(data)){
				td += "<td "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+DataFontsize+";"+newlinedata+"' align='"+align+"'></td>";
				_LODOP_PrintFunObj.LODOP.ADD_PRINT_IMAGE(imgSttHeight,imgSttWidth,imgWidth,imgHeight,data); //上边距、左边距、图片宽度、高度
				//_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"Stretch",1);//图片的(可变形)扩展缩放模式
				_LODOP_PrintFunObj.LODOP.SET_PRINT_STYLEA(0,"Stretch",2);//图片的(等比例缩放)扩展缩放模式
			}else{
				td += "<td "+nowrap+" style='border-left:1px solid gray;border-top:1px solid gray;font-size:"+DataFontsize+";"+newlinedata+"' align='"+align+"'>" + data + "</td>";
			}
		}
		imgSttHeight+=(DataTrHeight);
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