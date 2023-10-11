/*
 * @Author: qunianpeng
 * @Date: 2022-08-11 16:28:44
 * @Descripttion: ˵��
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 12:36:31
 */

var searchDrugId = ""; // ��������ѡ�еľ����ҩƷid
$(function() {

    // ������Ļ���ű���(win10��Ĭ�ϷŷŴ�ҳ��)
    setRatio();
	
	// ��ʼ�������� $('#editable-select').on�ᵼ�²������δ���,���on��Ҫ���ڳ�ʼ����λ��
	$('#editable-select').editableSelect({}).on('select.editable-select', function (e,dom) {
		searchDrugId = dom.attr("data-id");
    	$('.searchbtn').click();    
	});	 

    // ��ʼ��tab
    initTab('#tab');    
   
    // ��ʼ����ť���¼�
	initButton();
	
	//return false����������ҳ��
	/* window.onmousewheel=function(){
	    return false
	} */
	/* //return true����������ҳ��
	window.onmousewheel=function(){
	    return true
	} */
	
})
/**
 * @description:  ������Ļ���ű���(���ڷ�ֹwin10Ĭ�ϷŴ�)
 * @param {*} 
 * @return {*}
 */
function setRatio(){
    
    var defaultRatio = 1;//Ĭ�����ű�
    var ratio=0;
    var screen=window.screen;
    var ua=navigator.userAgent.toLowerCase();
 
    if(window.devicePixelRatio !== undefined)
    {
        ratio=window.devicePixelRatio;    
    }
    else if(~ua.indexOf('msie'))
    {
        if(screen.deviceXDPI && screen.logicalXDPI)
        {
            ratio=screen.deviceXDPI/screen.logicalXDPI;        
        }
    
    }
    else if(window.outerWidth !== undefined && window.innerWidth !== undefined)
    {
        ratio=window.outerWidth/window.innerWidth;
    }
 
    if(ratio > 1)
    {
        
        var setZoom = defaultRatio/window.devicePixelRatio; //Ĭ��zoom
        document.body.style.zoom = setZoom.toFixed(6);
        //var a = setZoom.toFixed(6);

    }
    // return ratio;
}

/**
 * @Author: qunianpeng
 * @Date: 2022-08-11 20:52:46
 * @Description: ��ʼ��tab
 */
function initTab(id) {

    var tabData = initTabData();
    var option = {
        id: id,
        data: tabData,
        goPage:goPage,
        userinfo:LoginInfo
    }
    var tab = new Tab(option);
}

/**
 * @Author: qunianpeng
 * @Date: 2022-08-11 20:55:43
 * @Description: ��ʼ��tab����
 */
function initTabData(params) {

	var tabData = ""
	runClassMethod("web.DHCCKBPdssIndex","queryDrugCat",{},function(res){
		tabData = res;
	},'json',false);
						
	return tabData;
 
}

/**
 * @description: ��ҳ��ת����
 * @param {*} pageIndex ��תҳ��
 * @param {*} total ����
 * @return {*}
 */
function goPage(pageIndex,option) {

   /* if (typeof option == "string"){
	   option = eval('(' + option + ')');
   } */
   jsPage('divpage',12, pageIndex, 'goPage',option,showDrugBox);

}

/**
 * @description: ҩƷ�б����ݼ���
 * @param {*} drugData ҩƷ����
 * @return {*}
 */
function showDrugBox(drugData,option){
	if ((JSON.stringify(drugData) === "{}")||(drugData.total <= 0)){
		notDataTips();		
		return;
	}
	$(".t_cont").hide();
	//$('.drugcont').show();
	$('.drugcont .notdatatips').remove();
	$('.drugcont .drugbox').empty();
    var drubbox = createDrugBox(drugData['data']);
    $('.drugcont .drugbox').append(drubbox);
    
    showControl('list');
    createDrugTips(option.params.input,option);

}

/**
 * @description: û��ҩƷ���ݵ���ʾ
 * @param {*} 
 * @return {*}
 */
function notDataTips(){
	
	$(".t_cont").hide();
	$('.drugcont').show();
	$('.drugcont .notdatatips').remove();
	$('.drugcont .drugbox').empty();
	$('.drugcont .divpage').empty();
	$('.drugcont').append('<div class="notdatatips"><img src="../scripts/dhcnewpro/dhcckb/pdss/images/notdata.png"><h3>���޼�¼��ȥ�����ط�������~</h3></div>');
   
}

/**
 * @description: ��̬����ҩƷ��Ƭ(ʹ����ģ���ַ�����m��js����ʾ����������ʹ��)
 * @param {*} data ҩƷ��������arr
 * @return {*}
 */
function createDrugBox(dataArr) {
	if ((dataArr == undefined)||(dataArr == "")||(dataArr.length == 0)){
		return;
	}
    var str = `<li>
        <div class="boxtop">
            <em>{{index}}</em>
            <i></i>
            <h4 class="nowrap">{{genername}}</h4>
            <h5 class="nowrap">{{name}}</h5>
        </div>
        <div class="boxbd" data-id="{{id}}">
            <h4 class="nowrap"><span>���:</span><span>{{spec}}</span></h4>
            <h4 class="nowrap"><span>����:</span><span>{{form}}</span></h4>
            <h4 class="nowrap"><span>�ɷ�:</span><span>{{ingr}}</span></h4>
            <h4 class="nowrap"><span>����:</span><span>{{manf}}</span></h4>
            <h4 class="nowrap"><span>��׼�ĺ�:</span><span>{{approvalnum}}</span></h4>
            <div class="foot">{{useflaghtml}}<button data-id="{{id}}" onclick="goinstrucion(this)">����</button></div>       
        </div>
    </li>`;

    var useflaghtml = '<div class="useflag"><i></i><span>��Ժ����</span></div>';
    var drugboxArr = [];
    dataArr.forEach(function(item, index) {
        //item.index = index + 1;
        item.useflaghtml = item.useflag == 'Y' ? useflaghtml : '';
        var reghtml = str;
        for (var key in item) {
            var reg = new RegExp('{{' + key + '}}', 'g');
            reghtml = reghtml.replace(reg, item[key] || "")
        }
        drugboxArr.push(reghtml);
    });

    return drugboxArr.length > 0 ? '<ul class="clearfix">' + drugboxArr.join('') + '</ul>' : '';

}

/**
 * @description:  ˵������������¼�
 * @param {*} event:��ǰ�����event
 * @return {*}
 */
function goinstrucion(event) {

    var drugId = $(event).attr('data-id');
    if ((drugId || "") == "") {
        return;
    }
	
	var drugData = ""
	runClassMethod("web.DHCCKBPdssIndex","queryDrugDetail",{"drugId":drugId,"userInfo":LoginInfo},function(res){
		drugData = res;
	},'json',false);
	
    //  ��̬����ҩƷ��ϸ
    createDrugDetails(drugData.data);  
	initDrugStep();
}

/**
 * @description:  ��̬����ҩƷ˵������������
 * @param {*} drugData
 * @return {*}
 */
function createDrugDetails(drugData) {
    
    if (drugData == '') {
        return;
    }    
    var details = new DrugDetail(drugData);   
    var html = details.init(); 
    $('.details').empty();   
    $('.details').append(html);
    //$('.details').show();
    //$('.drugtips').show();
    //$('#tab .t_cont').hide();
    //$('.drugcont').hide();    
    showControl('detail');
}


/**
 * @description:  ��ť�󶨳�ʼ������
 * @param {*} 
 * @return {*}
 */
function initButton(){
	
	/// ���������ı�
	$('#editable-select').bind('input propertychange',iputDebounce(searchKeyWord,500));
	/*
	 function() {

   		if(timeout){
	    	clearTimeout(timeout)
	  	}
		timeout = setTimeout('searchKeyWord('+this.value+')', 500) // 500ms��ִ�� search ����
	
		//searchKeyWord(this.value);
	}*/
	// ������ʧȥ����
	/*$("#keyword").blur(function() {
		$("#searchlist").empty();
		$("#searchlist").hide();		
	});*/
	
	// ������ť����¼�
	$('.searchbtn').bind('click', function() {
		var input = $('#editable-select').val().trim();
		var type = $(".searchnav li a[class='active']").parent().attr("data-type");	
		type = (type == "")||(type==undefined)?"drug":type;		
		$('#editable-select').editableSelect('hide');
		if ((type == "edu")||(type == "book")||(type == "check")){
			createEduInfo(searchDrugId);
		}
		else{
			var option= {params:{type:type,input:input,userInfo:LoginInfo}}	 
			goPage(1,option);
		}
				
	});
	
	// �������Ϸ���tab����¼�
	$(".searchnav li").on('click',searchNavClick);
	
	 $(document).off('click', '.anchor_list li').on('click', '.anchor_list li',function(){
		$(this).siblings().removeClass('active');
		$(this).addClass('active');
		$(this).siblings().children('.circle_check').removeClass('circle_check').addClass('circle');
		$(this).children('.circle').removeClass('circle').addClass('circle_check');
		$(this).siblings().children('.anchor_txt_check').removeClass('anchor_txt_check').addClass('anchor_txt');
		$(this).children('.anchor_txt').removeClass('anchor_txt').addClass('anchor_txt_check');
	
	});	
	
	// ����ͷ���¼�
	$(".totop").on('click',function(){
		//window.scrollTo(0,0);
		// �ɿ쵽��  ��ÿ�ο�����ʱ�������¼����ٶȣ�
        timer = setInterval( function(){
            //��ȡ�������Ĺ����߶�
            var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
            //���������ٶȲ����������Ч��
            var speed = Math.floor(-scrollTop / 8);
            document.documentElement.scrollTop = document.body.scrollTop = scrollTop + speed;//�ô����ָ�ֵ
            isTop =true;  //������ֹ�����¼������ʱ��
            if(scrollTop == 0){
                clearInterval(timer);
            }
        },20 );
	});
	
	window.onscroll = function () {
        //��˭���й��� body html���е��������ȡ����body��html����������һ�����ݵķ�ʽ
        //scrollTop�ݶ����Ļ����ľ���
        var res = document.body.scrollTop || document.documentElement.scrollTop;
        if (res >= 300) {//������400px����ť����
           $('.totop').show();
        } else {
	       $('.totop').hide();
        }

    }

}

/// input��������
function iputDebounce(fn, delay) {
	var delays=delay||500;
    var timer;
    return function(){
        var th=this;
        var args=arguments;
        if (timer) {
            clearTimeout(timer);
        }
        timer=setTimeout(function () {
                timer=null;
                fn.apply(th,args);
        }, delays);
    };
}

/**
 * @description:  �������ѯ�¼�
 * @param {*} val:¼�������
 * @return {*}
 */
function searchKeyWord(e){
	
	var type = $(".searchnav li a[class='active']").parent().attr("data-type");	
	type = (type == "")||(type==undefined)?"drug":type;
	if ((type != "drug")&&((type != "edu"))){
		return;
	}	
	//var val = e.target.value||e;
	var val = e.target.value||"";		
	if (val == ""){
		$(".es-list").empty();
		$('#editable-select').editableSelect('clear');	
		return;
	}
	if (val.trim() == ""){
		$(".es-list").empty();
		$('#editable-select').editableSelect('clear');	
		return;
	}
	runClassMethod("web.DHCCKBPdssIndex","SearchKeyList",{"input":val},function(res){	
	 	if ((res == "")||(res.length == 0)) {
		 	return;
		 }
	 	keyArr = res;
	 	var keyArr = [];		 	
	 	res.forEach(function (item,index) {
		 	var tmpli = ""
		 	if ((val!="")&&(item.name.indexOf(val)!= -1)){
			 	tmpli = '<li class="es-visible" data-key="'+item.name+'" data-id="'+item.id+'">'+item.name.replace(val,'<span style="color:#018EE8">'+val+'</span>')+'</li>';			 
			}else{
				tmpli = '<li class="es-visible" data-key="'+item.name+'" data-id="'+item.id+'">'+item.name+'</li>';
			}
	
            keyArr.push(tmpli);   
            
        }); 
        $(".es-list").empty().append(keyArr.join(''));
        $(".es-list").show();
        $(".es-list li").show();  
	
	},'json',false)
}

/**
 * @description:  �������Ϸ���tab����¼�
 * @param {*}
 * @return {*}
 */
function searchNavClick(){
	initPageStatus();
	var sel = $(".searchnav li a[class='active']").text();	
	if ($(this).text() != sel){			
		$(this).siblings().find('a').removeClass('active');
		$(this).find('a').addClass('active');
		$('#editable-select').val("");		
		$('#editable-select').editableSelect('clear');		
	}	
	
	var type = $(this).attr("data-type");	
	if ((type == "drug")||(type == "edu")){
		$('.es-input').css('background','url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAALCAYAAACgR9dcAAAAAXNSR0IArs4c6QAAARFJREFUKFNjZGBgYAic97juP8N/R0YGBkYQnxD4/5/hPjc7dz5j4MInav///L1JSAO6PBMjQwZjw/7/LBfvP7r8/z+DBrEGMDIyfmdiZNQHOzNw0SOd/78ZTjIw/OcixgBGJsbk9Yly8+B+DJz7MO4/A8NCwpoZF2xIlksEqUMJoMC5D2f9Z2BIxWkAI+NlVh5G89Vhst8xNCfM/8/x4f+j4wz/GQywGPCZkYXZZH28zC2YHEbUBCx4pMz49//Z/wwM/MgGMDIxhK1PlF+NIobNiUFzHwf+Y/i3Dm4DI8Ok9Uny+ehqcSaKwLmPWv8z/K9iZGQ8KKon6zrLhPE30ZpBCoMWv5bUixF52cDI+A+bCwGVoVI44tXl+gAAAABJRU5ErkJggg==) right center no-repeat');
		//$('#editable-select').bind('input propertychange',iputDebounce(searchKeyWord,500));
	}else{
		$('#editable-select').editableSelect('hide');	
		$('.es-input').css('background','none');
		//$('.es-list').hide();
		//$('#editable-select').unbind();
	}
	//if ((type == "indic")||(type == "contr")||(type == "check")||(type == "book"))
	
}

/**
 * @description:  ҳ�����ʾ����
 * @param {*}
 * @return {*}
 */
function showControl(flag){
	
	if ((flag == "cat")||((flag == ""))||((flag == undefined))){	// ��ʾ�弶����ҳ��
		$("#tab").show();
		$(".drugtips").hide();
		$(".details").hide();
		$(".drugcont").hide();		
	}
	else if (flag == "list"){
		$("#tab .t_cont").hide();
		$(".drugtips").show();
		$(".details").hide();
		$(".drugcont").show();	
	}
	else if (flag == "detail"){
		$("#tab .t_cont").hide();
		$(".drugtips").show();
		$(".details").show();
		$(".drugcont").hide();	
	}    
	
	return;
}


/**
 * @description: 
 * @param {*}
 * @return {*}
 */
function createDrugTips(catId,option){
	
	$('.drugtips .tipstext').empty();
  	option.id = catId;
  /* 	var option = {
	  	id:"22"
	  	} */
  	var input = 1
	var dataArr = [];
	runClassMethod("web.DHCCKKBIndex","GetCrumb",{"queryCat":catId},function(res){		
		dataArr = res;	
		if((dataArr == "") || (dataArr.length == 0)){
			return;
		}
		var htmlstr = ""
		var len = dataArr.length-1;
		for (var i=len; i>=0; i--){
			if(i<len){
				htmlstr += "<span  style='padding:0px 5px 0px 5px;color: #017bce'>/</span>";	
			}
			htmlstr += "<a href='javascript:void(0);' ";
			if(dataArr[i].type=="cat"){
				htmlstr += "onclick='goPage(\""+input+"\",\""+JSON.stringify(option).replace(/\"/g, "'")+"\")' "
			}else if(data[i].type=="input"){				
				htmlstr += "onclick='goCrumbList(\""+input+"\",\""+inputType+"\")' "
			}else{
				htmlstr += "onclick='goPage("+dataArr[i].id+")' "
			}
			htmlstr += " >" +dataArr[i].desc+"</a>";
		}
		$('.drugtips .tipstext').append(htmlstr);
	},'json',false);
	
}

/**
 * @description: ������ҩ������Ϣ
 * @param {*}
 * @return {*}
 */
function createEduInfo(drugId){

	$(".tab").hide();
	$(".drugtips").hide();
	$(".details").hide();
	$(".drugcont").hide();
	$('#edu').show();
	$('#edu').html("");	
	if ((drugId == "")||(drugId == undefined)){
		var html = '<div class="detail_notdata"><div class="detail_notdata-tips">���޼�¼��ȥ�����ط�������~</div></div>';
		$('#edu').append(html);
		return;	
	}	
	runClassMethod("web.DHCCKBPdssIndex","GetEduInfo",{"drugId":drugId},function(res){			
		if (res.state == "104"){
			var html = '<div class="detail_notdata"><div class="detail_notdata-tips">���޼�¼��ȥ�����ط�������~</div></div>';
			//var html = '<div class="notdatatips"><img src="../scripts/dhcnewpro/dhcckb/pdss/images/notdata.png"><h3>���޼�¼��ȥ�����ط�������~</h3></div>';
			$('#edu').append(html);
			return;
		}	
		
		var dataArr = res.data;	
		if((dataArr == "") || (dataArr.length == 0)){
			return;
		}
		var htmlstr = ""
		var len = dataArr.length-1;
		var contArr = [];
		for (var i=0; i<=len; i++){
			var guideObj = dataArr[i];
			contArr.push('<div class="e_edu_title">');
            contArr.push('<h3 class="nowrap">'+ guideObj.name +'</h3>');
            contArr.push('</div>');
            
            for (var j=0; j<=guideObj.book.length-1; j++){
	            var msgObj = guideObj.book[j];
	            if (j == 0){
	        		contArr.push('<div class="e_edu_type">');
            		contArr.push('<span>'+ "ҩƷ˵����:" +'</span>');
           			contArr.push('</div>'); 
		        }	            
	        	contArr.push('<div class="e_edu_text">');
            	contArr.push('<span>'+ msgObj.msg +'</span>');
           		contArr.push('</div>');  
	        }
	        
            for (var k=0; k<=guideObj.outBook.length-1; k++){
	            var msgObj = guideObj.outBook[k];
	            if (k == 0){
	        		contArr.push('<div class="e_edu_type">');
            		contArr.push('<span>'+ "���ײο�:" +'</span>');
           			contArr.push('</div>'); 
		        }	            
	        	contArr.push('<div class="e_edu_text">');
            	contArr.push('<span>'+ msgObj.msg +'</span>');
           		contArr.push('</div>');  
	        }
            
           
		}
		$('#edu').append(contArr.join(''));
	},'json',false);
}

/**
 * @description: ��ʼ��ҳ����ʾ״̬
 * @param {*}
 * @return {*}
 */
function initPageStatus(){
	
	$("#tab").show();
	$(".drugtips").hide();
	$(".details").hide();
	$(".drugcont").hide();
	$(".drugedu").hide();		
}

/**
 * @description: ��ʼ���̶�������
 * @param {*}
 * @return {*}
 */
function initDrugStep() {
    var nav = $(".scrollbar");
    var win = $(window);
    var sc = $(document);
	win.scroll(function() {
		console.log(sc.scrollTop());
		if(sc.scrollTop() >= 800) {
			nav.addClass("fix");
		}
		else {
			nav.removeClass("fix");
		}
	});
}
