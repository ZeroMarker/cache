///住院发药lodop打印公共JS
///Creator:dinghongying
///CreateDate:2018-08-28
///dhcpha.inpha.lodopprint.js

///住院发药汇总单打印
function CreatDispTotalPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");	
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ColDate=ColDate+" "+ColTime ;
    LODOP.PRINT_INIT("发药汇总表");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+ "发药汇总表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 80, "100%", 28, "申请科室：" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "发药类别：" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 80, "100%", 28, "单号：" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "发药时间：" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "制单人：" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "打印时间：" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td >" + "药品名称" + "</td>"; 
    html += "<td >" + "规格" + "</td>"; 
    html += "<td >" + "发药数量" + "</td>"; 
    html += "<td >" + "货位" + "</td>"; 
    html += "<td >" + "总价" + "</td>";
    html += "<td >" + "医嘱数" + "</td>"; 
    html += "<td >" + "冲减数" + "</td>"; 
    html += "<td >" + "床位数量" + "</td></tr>"; 
    html +="</thead>";
    html +="<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.FacQty + "</td>";
		html += "<td>" + printData.StkBin + "</td>";
		html += "<td>" + printData.Amt + "</td>";
		html += "<td>" + printData.Qty + "</td>";
		html += "<td>" + printData.ResQty + "</td>";
		html += "<td>" + printData.bedInciTotal + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "打印时间：" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='2'>" + "制单人：" + User + "</th>";
	html += "<th colspan='2'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(125, 0, "100%", "100%", html);
}

///住院发药明细单
function CreatDispDetailPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");	
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ColDate=ColDate+" "+ColTime ;
    LODOP.PRINT_INIT("发药明细表");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+ "发药明细表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 60, "100%", 28, "申请科室：" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "发药类别：" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 60, "100%", 28, "单号：" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "发药时间：" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "制单人：" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "打印时间：" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "床号" + "</td>"; 
    html += "<td>" + "姓名" + "</td>"; 
    html += "<td>" + "药品名称" + "</td>"; 
    html += "<td>" + "剂量" + "</td>"; 
    html += "<td>" + "单位" + "</td>";
    html += "<td>" + "频率" + "</td>"; 
    html += "<td>" + "用法" + "</td>"; 
    html += "<td>" + "时间" + "</td>";
    html += "<td>" + "规格" + "</td>"; 
    html += "<td>" + "总量" + "</td></tr>"; 
    html +="</thead>";
    html += "<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.BedNo + "</td>";
		html += "<td>" + printData.PatName + "</td>";
		html += "<td>" + printData.ArcimDesc + "</td>";
		html += "<td>" + printData.DoseQty + "</td>";
		html += "<td>" + printData.DoseUomDesc + "</td>";
		html += "<td>" + printData.Freq + "</td>";
		html += "<td>" + printData.Instruction + "</td>";
		html += "<td>" + printData.TimeDosingStr + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.Qty + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "打印时间：" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='3'>" + "制单人：" + User + "</th>";
	html += "<th colspan='3'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(125, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

///住院发药冲减汇总打印
function CreatDispTotalResPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");	
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ColDate=ColDate+" "+ColTime ;
    LODOP.PRINT_INIT("发药汇总表");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+ "发药冲减汇总表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 80, "100%", 28, "申请科室：" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "发药类别：" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 80, "100%", 28, "单号：" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "发药时间：" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "制单人：" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "打印时间：" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "药品名称" + "</td>"; 
    html += "<td>" + "规格" + "</td>"; 
    html += "<td>" + "发药数量" + "</td>"; 
    html += "<td>" + "货位" + "</td>"; 
    html += "<td>" + "总价" + "</td>";
    html += "<td>" + "医嘱数" + "</td>"; 
    html += "<td>" + "冲减数" + "</td>"; 
    html += "<td>" + "床位数量" + "</td></tr>";
    html +="</thead>";
    html += "<tbody>"; 
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.FacQty + "</td>";
		html += "<td>" + printData.StkBin + "</td>";
		html += "<td>" + printData.Amt + "</td>";
		html += "<td>" + printData.Qty + "</td>";
		html += "<td>" + printData.ResQty + "</td>";
		html += "<td>" + printData.bedInciTotal + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "打印时间：" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='2'>" + "制单人：" + User + "</th>";
	html += "<th colspan='2'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(145, 0, "100%", "100%", html);
    LODOP.PREVIEW();

}
//住院发药明细单(冲减)
function CreatDispDetailResPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ResDetail=1 
	var ColDate=ColDate+" "+ColTime ;
    if (ResDetail==""){
	    return;
	}
    LODOP.PRINT_INIT("发药冲减明细表");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+"冲减明细表"+"-"+Ward);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 60, "100%", 28, "发药单号：" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "退药申请单号：" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 60, "100%", 28, "病区：" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "发药时间：" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "制单人：" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "打印时间：" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "床号" + "</td>";
    html += "<td>" + "登记号" + "</td>";
    html += "<td>" + "姓名" + "</td>"; 
    html += "<td>" + "药品名称" + "</td>"; 
    html += "<td>" + "规格" + "</td>"; 
    html += "<td>" + "申请数量" + "</td>";
    html += "<td>" + "冲减数量" + "</td></tr>"; 
    html +="</thead>";
    html += "<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.BedNo + "</td>";
		html += "<td>" + printData.PatNo + "</td>";
		html += "<td>" + printData.PatName + "</td>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.ReqQty + "</td>";
		html += "<td>" + printData.ResQty + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "打印时间：" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='1'>" + "制单人：" + User + "</th>";
	html += "<th colspan='2'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(145, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

//住院发药库存不足
function CreatNoStockDetailPrint(LODOP,colarray,mainData){
	var	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
    LODOP.PRINT_INIT("发药库存不足明细单");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+"库存不足明细单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    //LODOP.ADD_PRINT_HTM(45,700,"100%",28,"<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    //LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "病区" + "</td>";
    html += "<td>" + "床号" + "</td>";
    html += "<td>" + "登记号" + "</td>";
    html += "<td>" + "姓名" + "</td>"; 
    html += "<td>" + "性别" + "</td>";
    html += "<td>" + "药品名称" + "</td>"; 
    html += "<td>" + "规格" + "</td>"; 
    html += "<td>" + "单位" + "</td>";
    html += "<td>" + "数量" + "</td></tr>"; 
    html +="</thead>";
    html += "<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
        html += "<td>" + printData.Ward + "</td>";
		html += "<td>" + printData.BedNo + "</td>";
		html += "<td>" + printData.PatNo + "</td>";
		html += "<td>" + printData.PatName + "</td>";
		html += "<td>" + printData.PatSex + "</td>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.Uom + "</td>";
		html += "<td>" + printData.Qty + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='6'>" + " "+ "</th>";
	html += "<th colspan='3'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(75, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

///住院发药草药单
function CreatDispCYPrint(LODOP,colarray,mainArr){
	var	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var mainArr=mainArr.split("||");
	var patstr=mainArr[0];  //主信息
	var drgstr=mainArr[1];  //药品明细
	var patArr=patstr.split("^");		
	var PrescNo=patArr[9];  //处方
	var PatNo=patArr[0];    //登记号
	var Ward=patArr[4];     //病区
	var AdmLoc=patArr[8];   //就诊科室
	var BedNo=patArr[7];    //床号
	var PhaLoc=patArr[5];   //药房
	var PatName=patArr[1];  //病人姓名
	var PatSex=patArr[2];   //性别
	var PatAge=patArr[3];   //年龄
	var Diagn=patArr[11];   //诊断
	var Doctor=patArr[10];  //医生
	var FyName=patArr[6];   //发药人
	var PyName=patArr[6];   //审核人
	var Amt=patArr[20];     //处方金额 //一付的价格
	var Factor=patArr[13];     //处方剂数
	var AmtSum=(Amt*Factor).toFixed(2)
	var drgArr=drgstr.split("&");
	var tmpStr="";
	for(var n=1;n<=drgArr.length;n++){
		var drgStrArr=drgArr[n-1].split("^");
		var temp=drgStrArr[0]+"*"+drgStrArr[3]+";;";
		if(tmpStr==""){
			var tmpStr=temp;
		}else{
			tmpStr=tmpStr+temp;
		}
	}
    LODOP.PRINT_INIT("发药明细表");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+"中药处方签");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 20, "100%", 28, "处方号：" + PrescNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 300, "100%", 28, "登记号：" + PatNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 500, "100%", 28, "就诊科室：" + AdmLoc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 20, "100%", 28, "病区：" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 300, "100%", 28, "床号：" + BedNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 500, "100%", 28, "药房：" + PhaLoc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "姓名：" + PatName);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 300, "100%", 28, "性别：" + PatSex);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 500, "100%", 28, "年龄：" + PatAge);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(145, 20, "100%", 28, "临床诊断：" + Diagn);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(145, 300, "100%", 28, "医师：" + Doctor);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td colspan='1'>" + "Rp:" + "</td>";
    html += "<td colspan='2'>" + "" + "</td></tr>"; 
    html +="</thead>";
    html +="<tbody>";
	html += "<tr><td colspan='1'>" + "" + "</td>";
	html += "<td colspan='2'>" + tmpStr + "</td></tr>";
	html += "</tbody><tfoot>";
    html += "<tr>";
    html += "<th colspan='1'>" + "剂数：" + Factor + "</th>";
	html += "<th colspan='1'>" + "药费：" + Amt + "</th>";
	html += "<th colspan='1'>" + "" + "</th></tr>";
	html += "<tr>";
	html += "<th colspan='1'>" + "审核/调配签名(签章)：" + PyName + "</th>";
	html += "<th colspan='1'>" + "核对/发药签名(签章)：" + FyName + "</th>";
	html += "<th colspan='1'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>"+ "</th></tr>";
	html += "<tr>";
	html += "<th colspan='3'>" + "药师提示：1、请遵医嘱服药；2、请在窗口点清药品；3、处方当日有效；4、发出药品不予退换"+ "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(175, 0, "100%", "100%", html);
    /*LODOP.ADD_PRINT_TEXT(320, 20, "100%", 28, "剂数：" + Factor);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(320, 300, "100%", 28, "药费：" + Amt);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(320,700,"100%",28,"<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    LODOP.ADD_PRINT_TEXT(350, 20, "100%", 28, "审核/调配签名(签章)：" + PyName);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(350, 300, "100%", 28, "核对/发药签名(签章)：" + FyName);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(380, 20, "100%", 28, "药师提示：1、请遵医嘱服药；2、请在窗口点清药品；3、处方当日有效；4、发出药品不予退换 ");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);*/
    LODOP.PREVIEW();

}