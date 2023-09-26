/**
  *打印统计界面
**/

function printHtml(JSONData)
{
	if(!JSONData)return;
    //转化json为object
    var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
    var tableHtml=HtmlStyles(arrData,"","")
    LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	//LODOP.SET_PRINT_PAGESIZE(2,"297mm","210","A4");
	LODOP.ADD_PRINT_HTM("2mm","5mm","","BottomMargin:1cm",tableHtml);
	

	//LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED",1);//横向时的正向显示
	var prtRet="";
	prtRet=LODOP.PRINT();
	//prtRet=LODOP.PREVIEW();
	return prtRet
}

///生成table
function createTable(arrData,title,filter) {

	var htmlStr="";
	htmlStr = "<head><w:SnapToGridInCell/><w:WrapTextWithPunct/><w:UseAsianBreakRules/> <w:DontGrowAutofit/><w:SplitPgBreakAndParaMark/><w:DontVertAlignCellWithSp/><w:DontBreakConstrainedForcedTables/><w:DontVertAlignInTxbx/> <w:Word11KerningPairs/><w:CachedColBalance/><w:UseFELayout/></w:Compatibility><w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel> <m:mathPr><m:mathFont m:val='Cambria Math'/><m:brkBin m:val='before'/><m:brkBinSub m:val='--'/><m:smallFrac m:val='off'/> <m:dispDef/><m:lMargin m:val='0'/> <m:rMargin m:val='0'/><m:defJc m:val='centerGroup'/><m:wrapIndent m:val='1440'/> <m:intLim m:val='subSup'/><m:naryLim m:val='undOvr'/></m:mathPr></w:WordDocument></xml><![endif]-->\n<style>\n_styles_\n</style>\n</head>\n",
	htmlStr = '<div id="p-panel" class="p-panel" onselectstart="return false;" style="font-weight:normal;position: relative; display: inline-block; width: 200mm; height: 285mm;">'
    htmlStr = htmlStr+'<table style="width:100%;" border="1" cellspacing="0" cellpadding="0"  id="table">';
    var row=$(".dhc-table").find("thead").html()
   
    /**
    var row = "<tr>";
    if(title)
    {
	    var titleArr=title.split("^");
	    for(var i=0;i<titleArr.length;i++){
		    if (titleArr[i].length>=4){
                row += "<th align='center'  width='100px'>" + titleArr[i] + '</th>';
            }else{
                row += "<th align='center'>" + titleArr[i] + '</th>';
            }
		}
    }
    else{
        //不使用标题项
        for (var i in arrData[0]) {
            row += "<th align='center'>" + i + '</th>';
        }
    }
    excel += row + "</tr>";
    */
   
    htmlStr += row
    //设置数据
    for (var i = 0; i < arrData.length; i++) {
        var row = "<tr style='height:8mm'>";
        var rowArr=arrData[i].value.split("^");
        
        for (var index=0;index<rowArr.length;index++) {
            var value = rowArr[index] == null ? "" : rowArr[index];
            row += "<td align='center'>" + value + "</td>";
        }
        htmlStr += row + "</tr>";
    }
    htmlStr += "</table></div>";
    return  htmlStr;
}
///处理table样式
function HtmlStyles(arrData,title,filter)
{
	var static = {
            mhtml: {
                top: "<!DOCTYPE html><html>\n_html_</html>",
                head: "<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n<style>\n_styles_\n</style>\n</head>\n",
                body: "<body>_body_</body>"
            }
     };
    var styles = "table{border-collapse:collapse;border:none;}\ntd{border:solid #000 1px;}";
    var TableHtml = createTable(arrData,title,filter);
    var fileContent = static.mhtml.top.replace("_html_", static.mhtml.head.replace("_styles_", styles) + static.mhtml.body.replace("_body_", TableHtml));
	return fileContent;
}