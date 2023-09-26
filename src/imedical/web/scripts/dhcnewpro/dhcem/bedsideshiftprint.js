$(document).ready(function(){
	PrintCons();
})


function PrintCons(){
	try{
		runClassMethod("web.DHCEMBedSideShift","GetExpEmShiftDetail",{"BsID":BsID},function(jsonString){
			if (jsonString == null){
				$.messager.alert("提示:","打印异常！","warning");
			}else if(jsonString.length==0){
				$.messager.alert("提示:","无打印数据！","warning",function(){
					window.close();	
				});
			}else{
				var jsonItemArr = jsonString;
				Print_Html(jsonObjMain, jsonItemArr);
				setTimeout("UlcerPrint()","500");  //500毫秒后执行print()函数，只执行一次。
			}
		},'json',true)	
	}catch(e){alert(e.message)}

	$('input,textarea').not("#print").attr("readonly","readonly");
}

//打印
function UlcerPrint(){
	LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	LODOP.ADD_PRINT_HTM(0,0,"210mm","297mm",document.documentElement.innerHTML);
	var LODOPPRTSTATS=LODOP.PRINT();
	if(LODOPPRTSTATS){
		window.close();	
	}
	return;	
 }

/// 打印交班记录
function Print_Html(jsonObjArr, jsonItemArr){
	
	$("#Title").html( jsonObjMain );
	
	var htmlstr = "";
	for (var i=0; i<jsonItemArr.length; i++){
		
		var bsSuggest = "";
		if (jsonItemArr[i].bsSuggest != ""){
			bsSuggest = jsonItemArr[i].bsSuggest.replace(/<\/?[^>]*>/g,'')
		}
		
		htmlstr = htmlstr + '<tr height="35px">';
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatLoc +'</td>';       /// 科室
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatBed +'</td>';       /// 床号
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatName +'</td>';      /// 姓名
		// htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatNo +'</td>';        /// 登记号
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatAge +'</td>';       /// 年龄
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatSex +'</td>';       /// 性别
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].ObsTime +'</td>';      /// 滞留时间
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatDiag +'</td>';      /// 诊断
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].WaitToHos +'</td>';    /// 待入院
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].bsBackground +'</td>'; /// 背景
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].bsAssessment +'</td>';  /// 评估
		htmlstr = htmlstr + '	<td>'+ bsSuggest +'</td>';              /// 建议
		htmlstr = htmlstr + '</tr>';
	}
	$("#printTable tbody").append( htmlstr );
	return;
}
