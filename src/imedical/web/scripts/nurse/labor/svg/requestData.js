if (SVG.supported) {
    var draw = SVG('drawing').style({height:'100%',width:'100%',overflow:'visible'});//fill('#f03');
	if (ifHorizontalPrint=="Y")
	{
		draw.viewbox({ x: 0, y: 0, width: A4H, height: A4W }); 
	}else{
		draw.viewbox({ x: 0, y: 0, width: A4W, height: A4H }); 
	}
    var table=draw.group().attr("id","table");    
    //var tabStyle=JSON.parse(json);
    getTable();
    getCurData(page);
    //getContent();
    //getCurve();    
} else {
    alert('SVG not supported')
}
var tableObj={},conObj={},curveObj={};
function getTable(){
    $cm({
        ClassName:"Nur.NIS.Service.Labor.Draw",
        MethodName:"getTable",
        ConfigID:configID
    },function(tabStyle){
	    tableObj=tabStyle;
        darwTable(tabStyle);
    });
}

function getCurData(page){
	$(".content").css("visibility",'hidden');
	var contentElem=$("#content-"+page);
	if(contentElem.length>0){
		contentElem.remove();
	}
	contentElem=draw.group().attr("id","content-"+page).attr("class","content");	
	getContentCurve(page,contentElem);	
}

function getContentCurve(page,contentElem){
    $cm({
        ClassName:"Nur.NIS.Service.Labor.Draw",
        MethodName:"getContentCurve",
        EpisodeID:episodeID, 
        Page:page, 
        ConfigID:configID
    },function(ret){
	    conObj[page]=ret.content;
	    curveObj[page]=ret.curve;
	    darwContent(ret.content,contentElem);
        darwCurve(ret.curve,contentElem);   
        window.parent.disLoad();     
    });
}

var loadSuccess=false;
function multiRequest(total,maxNum,ifPreview) {
	//var myDate=new Date();
	//var start=myDate.getTime();
	// ����������
	var len = total;
	if(total<maxNum) maxNum=total;
	// ����������������һ����������������Ľ��
	var result = [];
	for(var i=0;i<len;i++){
		result.push(false);	
	}
	// ��ǰ��ɵ�����
	var count = 0;
	return new Promise(function(resolve, reject){
		// ����maxNum��
		while (count < maxNum) {
			next(); 
		}
		function next() {
			var current = count++;
			// ����߽�����
			if (current >= len) {	
				//var myDate2=new Date();
				//var end=myDate2.getTime();
				//console.log("diff: "+(end-start)/1000);		
				// ����ȫ����ɾͽ�promise��Ϊ�ɹ�״̬, Ȼ��result��Ϊpromiseֵ���� 
				!result.includes(false) && resolve(result);
				//return; 
				if(!result.includes(false)){
					loadSuccess=true;
					window.parent.printAll(ifPreview,loadSuccess);
					return;			
				}								
			}			
			var pagenum=current+1;
			if(pagenum>total) return;		
			if( $("#content-"+pagenum).length>0){
				result[current] = true;
				if (current < len) {
					next(); 
				} 
				return;	
			}	
			//if(pagenum<rangeFrom || pagenum>rangeTo) return; // ���˵�������ѡ��ҳ�뷶Χ�ڵ�
			//if(parity=="O" && (pagenum%2)!=1) return; // ���˵���������ҳ��
			//if(parity=="E" && (pagenum%2)!=0) return; // ���˵�����ż��ҳ��
			//if($("#content-"+pagenum).length>0) return; // ���˵��Ѵ��ڵ�ҳ��
			var contentElem=draw.group().attr("id","content-"+pagenum).attr("class","content");	
			$("#content-"+pagenum).css("visibility",'hidden');
			$cm({
				ClassName:"Nur.NIS.Service.Labor.Draw",
				MethodName:"getContentCurve",
				EpisodeID:episodeID, 
				Page:pagenum, 
				ConfigID:configID
		    },function(ret){
			    conObj[pagenum]=ret.content;
	    		curveObj[pagenum]=ret.curve;
			    darwContent(ret.content,contentElem);
		        darwCurve(ret.curve,contentElem);
		        // ���������� 
				result[current] = true;				
				// ����û��ȫ�����, �͵ݹ�
				if (current < len) {
					next(); 
				} 
		    });
		} 
	});
}

