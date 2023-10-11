/// JQuery ��ʼ��ҳ��
$(function(){ 
	initAnchor();
	initCrumbs();
	initData();
})
//��̬�Ҳർ���� sunhuiyong 2021-8-5
function initAnchor(){
	/**������ʱִ�к���**/
    var timeFun = null;
    
    /**�ҵ���ǰҳ���������ê��λ��**/
    var findHref = function(){
        var $links = $('div .para-title');
        var windowScrollTop = $(window).scrollTop();
        var maxDistance = 10000;
        var result = $links.eq(0);
        $.each($links,function(i,link){
            var curDistanceToTop = Math.abs($links.eq(i).offset().top - windowScrollTop);
            /**if(maxDistance > curDistanceToTop && ($links.eq(i).offset().top < (windowScrollTop + $(window).height()))){
                maxDistance = curDistanceToTop;
                result = $links.eq(i);
            }**/
            maxDistance > curDistanceToTop && $links.eq(i).offset().top < windowScrollTop + $(window).height() && (maxDistance = curDistanceToTop,result = $links.eq(i))
        });
        return result;
    };
    
    /***ʹ��jQuery�����ƶ�����*/
    $('div #anchor').css("overflow-y","hidden");  //�Ż�ȥ�������� shy 2022-1-1
    var move = function (dis) {
        $('div #anchor').animate({  
		  scrollTop:dis 
		}, 'normal');
    }
    
	/**�����¼�Handler**/
	var wheelHandler = function(e){
	    clearTimeout(timeFun);
	    timeFun = setTimeout(function(){
	        var href = findHref();
	        /**����id��ʽ������ӸĽ�**/
	       // $('div ul li div').removeAttr("style");   	   //�������ѡ�б�ʶ
	        $('div ul li div').attr("class","circle");
	        var id =  href[0].id;
	        id="li #"+id;
	        id=id.replace("-List","");
	        //$(id).prev().css("background-color","black");  //����ѡ�б�ʶ
	        $(id).prev().attr("class","circle-check") //addClass("circle-check");  �Ż�copy�ٶ�gif shy 2022-1-1
	        
	        var curtext = href[0].innerText;
	        var index = 0;
	        $.each(href.prevObject,function(i){
	        if(href.prevObject[i].innerText == curtext)
	        {
	        	index=i;    //�������Ƽ��㵼������
	        }
	        });
	        
	        var dis = 30*(index-1)+10;  //�����������и� �ж� scrollTop ��ֵ
	        move(dis);
	    },600);
	};
    
    /***ע������¼�*/
    $('body').on('mousewheel',wheelHandler);
    
    /**����¼�**/
	$('.anchor-point').click(function() {
		var id=$(this).attr("id")
		id="#"+id+"-List"
		$(window).scrollTop($(id).offset().top);
		//������ӦЧ��
		//$('div ul li div').removeAttr("style");          //�������ѡ�б�ʶ
		$('div ul li div').attr("class","circle");
		//$(this).prev().css("background-color","black")   //���ѡ�б�ʶ
		$(this).prev().attr("class","circle-check") //addClass("circle-check");  �Ż�copy�ٶ�gif shy 2022-1-1
	})
	if (window.parent.resize){
		window.parent.resize();	
	}
	
}

function initCrumbs(){

	var catId=$("#catId").val(),incId=$("#IncId").val(),input=$("#input").val(),inputType=$("#inputType").val();
	var crumbHtml=getCrumbs(catId,incId,input,inputType);
	$("#tableTb").html(crumbHtml);
}

/// ����������ʾ
function initData(){
	
	if ((IncId == "")||(IncId == undefined)){
		$(".side-content").hide();
		$(".no-data").show();
	}
}
//���ҩƷ��ת
function goCrumb(id,hospID){
	goCrumbWiki(id,"","","","",hospID)
	
	}
//���������ת
function openLiter(url){
	if(url !=""){
		window.open(url)
	}
	}