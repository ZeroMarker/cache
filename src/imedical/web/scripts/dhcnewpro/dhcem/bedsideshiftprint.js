$(document).ready(function(){
	PrintCons();
})


function PrintCons(){
	try{
		runClassMethod("web.DHCEMBedSideShift","GetExpEmShiftDetail",{"BsID":BsID},function(jsonString){
			if (jsonString == null){
				$.messager.alert("��ʾ:","��ӡ�쳣��","warning");
			}else if(jsonString.length==0){
				$.messager.alert("��ʾ:","�޴�ӡ���ݣ�","warning",function(){
					window.close();	
				});
			}else{
				var jsonItemArr = jsonString;
				Print_Html(jsonObjMain, jsonItemArr);
				setTimeout("UlcerPrint()","500");  //500�����ִ��print()������ִֻ��һ�Ρ�
			}
		},'json',true)	
	}catch(e){alert(e.message)}

	$('input,textarea').not("#print").attr("readonly","readonly");
}

//��ӡ
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

/// ��ӡ�����¼
function Print_Html(jsonObjArr, jsonItemArr){
	
	$("#Title").html( jsonObjMain );
	
	var htmlstr = "";
	for (var i=0; i<jsonItemArr.length; i++){
		
		var bsSuggest = "";
		if (jsonItemArr[i].bsSuggest != ""){
			bsSuggest = jsonItemArr[i].bsSuggest.replace(/<\/?[^>]*>/g,'')
		}
		
		htmlstr = htmlstr + '<tr height="35px">';
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatLoc +'</td>';       /// ����
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatBed +'</td>';       /// ����
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatName +'</td>';      /// ����
		// htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatNo +'</td>';        /// �ǼǺ�
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatAge +'</td>';       /// ����
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatSex +'</td>';       /// �Ա�
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].ObsTime +'</td>';      /// ����ʱ��
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].PatDiag +'</td>';      /// ���
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].WaitToHos +'</td>';    /// ����Ժ
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].bsBackground +'</td>'; /// ����
		htmlstr = htmlstr + '	<td>'+ jsonItemArr[i].bsAssessment +'</td>';  /// ����
		htmlstr = htmlstr + '	<td>'+ bsSuggest +'</td>';              /// ����
		htmlstr = htmlstr + '</tr>';
	}
	$("#printTable tbody").append( htmlstr );
	return;
}
