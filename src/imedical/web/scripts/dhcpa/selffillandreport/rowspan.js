//�ϲ���Ԫ��
function rowspanFun(grid,schemNum){
	/*
		�ϲ���Ԫ��ֵ��ͬ�ģ�ֻ����һ������
	*/
	//���д���
	var nameArray=[];
	var spanObj=new Object();
	var numObj=$("div[class='x-grid3-cell-inner x-grid3-col-numberer']"); //number��
	var rowCount = grid.getStore().getCount();    //����
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
			//Ҫ�ȵõ���Ԫ��ԭ�е�style��ֵ���ټ���border��ֵ
			//var parentStyle=$(o).parent().attr("style");
			//var newStyle=parentStyle+";border-top:0px;";
			$(o).parent().css("border-top","0px");
			
		}else{
			
			//����ȣ����ǰ����кţ���Ҫ�õ�һ���ж��ٸ���Ԫ��same����������ֵ���ںϲ����м�
			var rowNum=$(o).parent().parent().find("div[class='x-grid3-cell-inner x-grid3-col-numberer']").text(); //ȥ����һ���ϲ����к�
			notSameName=$(o).text();
			nameArray.push(notSameName+"#"+rowNum);
			
			
		}
		
	});
	//====================���ﴦ���ϲ��ĵ�Ԫ�� ������ʾ=============================//
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
		//λ��ȷ����������Ҫ��ֵ��
		
		var posObj=$(numObj[pos]).parent().parent().find("div[class='x-grid3-cell-inner x-grid3-col-schemLevel_"+i+"']");
		$(posObj).text(name);
		
	}
	nameArray=[];
	
	}
	//===================================�����Ż�=============================//
	//����ݸ��л�ɫ
	 $(".x-grid3-body div:odd table td[class='x-grid3-col x-grid3-cell x-grid3-td-URDContent ']").css("background-color","#FAFAFA");  //�ı�ż���б���ɫ
	 $(".x-grid3-body div:odd table td[class='x-grid3-col x-grid3-cell x-grid3-td-UDRsubmitState x-grid3-cell-last  ']").css("background-color","#FAFAFA");  //�ı�ż���б���ɫ
	 
}