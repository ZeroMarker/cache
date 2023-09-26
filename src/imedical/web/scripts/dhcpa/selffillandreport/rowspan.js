//合并单元格
function rowspanFun(grid,schemNum){
	/*
		合并单元格，值相同的，只保留一个名称
	*/
	//按列处理
	var nameArray=[];
	var spanObj=new Object();
	var numObj=$("div[class='x-grid3-cell-inner x-grid3-col-numberer']"); //number列
	var rowCount = grid.getStore().getCount();    //行数
	for(var i=0;i<schemNum;i++){
	var schemName=$("div[class='x-grid3-cell-inner x-grid3-col-schemLevel_"+i+"']");
	var notSameName=undefined;
	var count=0;
	$.each(schemName,function(k,o){
		
		if(k==0){
			notSameName=$(o).text();
		}else{
			var nextName=$(o).text();
		}
		if(notSameName==nextName && k!=0){
			$(o).text("");
			//要先得到父元素原有的style的值，再加上border的值
			//var parentStyle=$(o).parent().attr("style");
			//var newStyle=parentStyle+";border-top:0px;";
			$(o).parent().css("border-top","0px");
			
		}else{
			
			//不相等，获得前面的行号，需要得到一共有多少个单元格same啦，用来把值放在合并的中间
			var rowNum=$(o).parent().parent().find("div[class='x-grid3-cell-inner x-grid3-col-numberer']").text(); //去到第一个合并的行号
			notSameName=$(o).text();
			nameArray.push(notSameName+"#"+rowNum);
			
			
		}
		
	});
	//====================这里处理将合并的单元格 居中显示=============================//
	var arrLen=nameArray.length;
	$(schemName).text("");
	for(var n=0;n<arrLen;n++){
		var nameA=nameArray[n].split("#");
		var name=nameA[0];
		var num=nameA[1]-0;
		if(n==arrLen-1){
				var pos =num+parseInt((rowCount-num)/2)-1;
		}else{
			var pos = num+parseInt((nameArray[n+1].split("#")[1]-num)/2)-1;
		}
		//位置确定啦，现在要赋值了
		
		var posObj=$(numObj[pos]).parent().parent().find("div[class='x-grid3-cell-inner x-grid3-col-schemLevel_"+i+"']");
		$(posObj).text(name);
		
	}
	nameArray=[];
	
	}
	//===================================界面优化=============================//
	//填报内容隔行换色
	 $(".x-grid3-body div:odd table td[class='x-grid3-col x-grid3-cell x-grid3-td-URDContent ']").css("background-color","#FAFAFA");  //改变偶数行背景色
	 $(".x-grid3-body div:odd table td[class='x-grid3-col x-grid3-cell x-grid3-td-UDRsubmitState x-grid3-cell-last  ']").css("background-color","#FAFAFA");  //改变偶数行背景色
	 
}