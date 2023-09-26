function getLodop(oOBJECT,oEMBED){
/**************************
  本函数根据浏览器类型决定采用哪个对象作为控件实例：
  IE系列、IE内核系列的浏览器采用oOBJECT，
  其它浏览器(Firefox系列、Chrome系列、Opera系列、Safari系列等)采用oEMBED,
  对于64位浏览器指向64位的安装程序install_lodop64.exe。
**************************/
        var strHtmInstall="<br><font color='#FF00FF'>打印控件未安装!点击这里<a href='install_lodop32.exe'>执行安装</a>,安装后请刷新页面或重新进入。</font>";
        var strHtmUpdate="<br><font color='#FF00FF'>打印控件需要升级!点击这里<a href='install_lodop32.exe'>执行升级</a>,升级后请重新进入。</font>";
        var strHtm64_Install="<br><font color='#FF00FF'>打印控件未安装!点击这里<a href='install_lodop64.exe'>执行安装</a>,安装后请刷新页面或重新进入。</font>";
        var strHtm64_Update="<br><font color='#FF00FF'>打印控件需要升级!点击这里<a href='install_lodop64.exe'>执行升级</a>,升级后请重新进入。</font>";
        var strHtmFireFox="<br><br><font color='#FF00FF'>注意：<br>1：如曾安装过Lodop旧版附件npActiveXPLugin,请在【工具】->【附加组件】->【扩展】中先卸它。";
        var LODOP=oEMBED;		
	try{		     
	     if (navigator.appVersion.indexOf("MSIE")>=0) LODOP=oOBJECT;
	     if ((LODOP==null)||(typeof(LODOP.VERSION)=="undefined")) {
		 if (navigator.userAgent.indexOf('Firefox')>=0)
  	         document.documentElement.innerHTML=strHtmFireFox+document.documentElement.innerHTML;
		 if (navigator.userAgent.indexOf('Win64')>=0){
		 	if (navigator.appVersion.indexOf("MSIE")>=0) document.write(strHtm64_Install); else
		 	document.documentElement.innerHTML=strHtm64_Install+document.documentElement.innerHTML;		 
		 } else {
		 	if (navigator.appVersion.indexOf("MSIE")>=0) document.write(strHtmInstall); else
		 	document.documentElement.innerHTML=strHtmInstall+document.documentElement.innerHTML;
		 }
		 return LODOP; 
	     } else if (LODOP.VERSION<"6.1.0.6") {
		if (navigator.userAgent.indexOf('Win64')>=0){
	            if (navigator.appVersion.indexOf("MSIE")>=0) document.write(strHtm64_Update); else
		    document.documentElement.innerHTML=strHtm64_Update+document.documentElement.innerHTML; 
		} else {
	            if (navigator.appVersion.indexOf("MSIE")>=0) document.write(strHtmUpdate); else
		    document.documentElement.innerHTML=strHtmUpdate+document.documentElement.innerHTML; 
		}
		 return LODOP;
	     }
	     //*****如下空白位置适合调用统一功能:*********	     


	     //*******************************************
	     return LODOP; 
	}catch(err){
		if (navigator.userAgent.indexOf('Win64')>=0)	
		document.documentElement.innerHTML="Error:"+strHtm64_Install+document.documentElement.innerHTML;else
		document.documentElement.innerHTML="Error:"+strHtmInstall+document.documentElement.innerHTML;
	     return LODOP; 
	}
}
/*------------ PrintExtgrid参数说明：------------------------
pgrid:要打印的表格；
stitle、报表标题；
intOrient：
	打印方向及纸张类型，数字型，
	1---纵(正)向打印，固定纸张； 
	2---横向打印，固定纸张；  
	3---纵(正)向打印，宽度固定，高度按打印内容的高度自适应；
	0(或其它)----打印方向由操作者自行选择或按打印机缺省设置；
	
PageWidth：	设定自定义纸张宽度，整数或字符型，整数时缺省长度单位为0.1毫米。
PageHeight：固定纸张时设定纸张高；高度自适应时设定纸张底边的空白高。
strPageName：
	设为标准纸张，纸张类型名，字符型，只能在如下名称中选择，不限大小写：
	Letter, LetterSmall, Tabloid, Ledger, Legal,Statement, Executive,A3, A4, A4Small, A5, B4, B5, Folio, Quarto, qr10X14,
	qr11X17, Note, Env9, Env10, Env11, Env12,Env14, Sheet, DSheet, Esheet
	注：PageWidth、PageHeight 和strPageName都无效时，本函数对纸张大小不起作用，控件则采用所选打印机的默认纸张，但intOrient仍可起作用。
	如果打印程序未采用扩展方式（PRINT_INITA）初始化，本函数的固定纸张功能所定制的纸张大小，会起到PRINT_INITA中Width和Height的相同功能。



*/
function PrintExtgrid(pgrid, stitle,intOrient, PageWidth,PageHeight,strPageName) {

	LODOP = getLodop(document.getElementById('LODOP'), document
					.getElementById('LODOP_EM'));

	// LODOP.PRINT_INITA(0, 0, 800, 1600, "herpgrid打印");
	stitle = "herpgrid表格打印"
	LODOP.PRINT_INIT("herp表格打印")
	if(intOrient==""){
	intOrient=1
	}
	if(PageWidth==""){
	PageWidth=0
	}
	if(PageHeight==""){
	PageHeight=0
	}
	if(strPageName==""){
	strPageName="A4"
	}
	LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth, PageHeight,strPageName)
	
	if (typeof(pgrid.title) == "undefined") {
		LODOP.ADD_PRINT_TEXT(25, 300, 355, 30, stitle);
	} else {
		LODOP.ADD_PRINT_TEXT(25, 300, 355, 30, pgrid.title);
	}

	AddGridText(pgrid);
	LODOP.ADD_PRINT_TEXT(3, 653, 135, 20, "第#页/共&页");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 1);
	LODOP.ADD_PRINT_TEXT(3, 34, 196, 20, "DHCC-HERP");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);

	// LODOP.ADD_PRINT_TEXT(3, 34, 196, 20, "DHCC-HERP");
}
function AddGridText(pgrid) {

	LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
	// 设置表格样式
	var strTableStyle = "<style type='text/css'>table{width:'100%';border-collapse: collapse;} table thead td b{font-size: 25px;} table tr td{font-size: 13px;} table tfoot td{font-size: 15px;}</style>";
	// 将数据拼成一个table
	var strTableStartHtml = "<table border='1' width='100%' bordercolor='#336699' cellpadding='0' cellspacing='0' align='center'>";
	var strTableEndHtml = "</table>";
	var strTableTheadHtml = "<thead style='height: 30px' bgcolor='#efefef'>";
	var strTableTrHtml = "";
	for (var i = 0; i <= pgrid.getColumnModel().getColumnCount(true); i++) {
		var indx = pgrid.getColumnModel().getColumnId(i)
		var tmobj = pgrid.getColumnModel().getColumnById(indx)
		if (tmobj != null) {
			// 列增加是否打印print属性，true：打印，false：不打印
			if ((typeof(tmobj.print) == "undefined") || (tmobj.print == true)) {
				var td = "<td nowrap align='center' style=font-size: 15px><b>"
						+ pgrid.getColumnModel().getColumnHeader(i)
						+ "</b></td>";
				strTableTheadHtml += td;
			}
		}
	}

	strTableTheadHtml += "</thead>";
	var zjeTotal = 0;
	for (var i = 0; i < pgrid.getStore().getCount(); i++) {
		var td = "<tr style='height: 30px'>";
		for (var n = 0; n < pgrid.fields.length + 1; n++) {

			var indx = pgrid.getColumnModel().getColumnId(n)
			var tmobj = pgrid.getColumnModel().getColumnById(indx)

			if ((typeof(tmobj.print) == "undefined") || (tmobj.print == true)) {
				// alert(Ext.get(indx).dom.value)

				var reValue = pgrid.getStore().getAt(i).get(indx);
				if ((tmobj.type != null) && (typeof(tmobj.type) != "")) {

					if ("combo" === tmobj.type.getXType()) {
						var editor = tmobj.editor;
						var myStore = tmobj.editor.store;
						var rec = myStore.find(editor.valueField, reValue);
						if (rec >= 0) {
							reValue = myStore.getAt(rec)
									.get(editor.displayField);
						}
					}
				}
				if (typeof(reValue) == "undefined") {
					reValue = "";
				}
				td += "<td align='center'>" + reValue + "</td>";
			}
		}
		td += "</tr>";
		strTableTrHtml += td;
	}
	var strTableTfoot = "<tr style='height: 30px'><td align='center'><b>合计</b></td><td>&nbsp;</td><td>&nbsp;</td><td align='right'><b>"
			+ Ext.util.Format.number(zjeTotal, '0,0.00')
			+ "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
	var strPageFooter = ""; 

	LODOP.ADD_PRINT_HTM(50, 0, 800, 1000, strTableStyle);
	LODOP.ADD_PRINT_TABLE(75, 0, "100%", "85%", strTableStartHtml
					+ strTableTheadHtml + strTableTrHtml + strPageFooter
					+ strTableEndHtml);

};
function printDesign(pgrid, stitle){
 PrintExtgrid(pgrid, stitle) 
 LODOP.PRINT_SETUP(); //打印维护

}