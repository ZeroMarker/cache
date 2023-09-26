var MARowID="";   ///ģ��ID
var PageWidth="";
var PageHeight="";
var TempType="";
var TempLine="";
var HistArr=[];   ///������ʷ�洢(ֻ֧��Table��Td�ϲ�)
$(function(){

    initMethod();   //���¼�
    
    OpenTempInitParams();
    
    OpenTempInitMethod();
    
    initDatagrid();
    
    initCombobox();
    
})

function initCombobox(){
	
	$("#tempType").combobox({
		valueField: "value", 
		textField: "text",
		editable:true,
		data:[
			{
				"value":1,
				"text":"��ͨ"
			},{
				"value":2,
				"text":"���"
			},
		]
	})
	$("#tempType").combobox("setValue",1);
}

function initDatagrid(){
	var columns=[[
		{field:'MARowID',align: 'center',title: 'MARowID',hidden:true,width:50},
		{field:'MACode',align: 'center',title: 'ģ������',width:50},
		{field:'MADesc',align: 'center',title: 'ģ������',width:50},
		{field:'MAWidth',align: 'center',title: 'ģ����',width:50},
		{field:'MAHeight',align: 'center',title: 'ģ��߶�',width:50},
		{field:'LineNum',align: 'center',title: 'ģ������',width:50},
		{field:'Type',align: 'center',title: 'ģ������',width:50,
			formatter:function(value){
				if(value==1){return "��ͨ";	}
				else{return "���";	}
			}
		},
	]]
	
	$("#prtTempTable").datagrid({
		url: 'dhcapp.broker.csp?ClassName=web.DHCPRTMain&MethodName=JsonList',
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		toolbar:'#toolbar',
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		onDblClickRow:function(index,row){
			initTempPage(row.MARowID);
		},
		onLoadSuccess:function(data){

		}
    })	
}

function initMethod(){
    $(".p-itma").on("keydown",setDomStyle);                 //���Ե�keyCode�¼�
    $(".p-itmEle").on("click",addItmEle);
    $("#tempCode").on("change",validCodeUniq);
    ///�����ݼ�
    $(document).keypress(function(event){
		
		if(event.shiftKey && event.keyCode==79){  //shift+O ��
			openPage();
			stopDefault(event);
			return;    
		}

		if(event.shiftKey && event.keyCode==78){  //shift+N �½�
			addPage();
			stopDefault(event);
			return;    
		}

		if(event.shiftKey && event.keyCode==83){  //shift+S ����
			saveHtml();
			stopDefault(event);
			return;    
		}
	});
	 
	$(document).on("keydown",function(event){
		if(event.keyCode==38){  //��
			_tdp=$(".p-selItm").parent().prevAll().length;
			for(i=0;i<_tdp;i++){
				if(!$(".p-selItm").parent().prevAll().eq(i).find("td").eq(0).is(":hidden")){
					$(".p-selItm").parent().prevAll().eq(i).find("td").eq(0).mousedown();
					break;	
				}
			}
			stopDefault(event);
			return; 
		}
		
		if(event.keyCode==40){  //��
			_tdp=$(".p-selItm").parent().nextAll().length;
			for(i=0;i<_tdp;i++){
				if(!$(".p-selItm").parent().nextAll().eq(i).find("td").eq(0).is(":hidden")){
					$(".p-selItm").parent().nextAll().eq(i).find("td").eq(0).mousedown();
					break;	
				}
			}
			stopDefault(event);
			return;    
		}
		
		if(event.keyCode==37){  //��
			_tdp=$(".p-selItm").prevAll().length;
			for(i=0;i<_tdp;i++){
				if(!$(".p-selItm").prevAll().eq(i).is(":hidden")){
					$(".p-selItm").prevAll().eq(i).mousedown();
					break;	
				}
			}
			stopDefault(event);
			return;    
		}
		
		if(event.keyCode==39){  //��
			_sir=$(".p-selItm").attr("colspan")==undefined?1:$(".p-selItm").attr("colspan");
			$(".p-selItm").nextAll().eq(_sir-1).mousedown();
			stopDefault(event);
			return;    
		}
	});
}

///ADDTEMP:������֤Code�Ƿ�Ψһ
function validCodeUniq(){
	var tempCode = $("#tempCode").val();
	if(tempCode==""){
		$("#isHasTemp").html("");
		return;	
	}
	runClassMethod("web.DHCPRTMain","IsHasTempCode",{MACode:tempCode},
        function(ret){
            if(ret==0){
	            $("#isHasTemp").html("");    
	        }else{
		    	$("#isHasTemp").html("ģ�������ظ���");
		    }
        },'text'
    )
}

///����ģ���ʱ�����
function OpenTempInitMethod (){
	$("#p-panel").on("mousedown",".p-itmp",setAttrPanel);   //����Ԫ���ƶ��¼�
    $("#p-panel").on("mouseup",".p-itmp",setAttrPanel);     //Ԫ��up��ʱ����ʾֵ
}
function OpenTempInitParams(){
	HistArr=[]; 
}

//ģ���ʼ��
function addPage(){
	$("#tempCode").val("");
	$("#tempDesc").val("");
	$("#tempWidth").val("197");
	$("#tempHeight").val("285");
	$("#tempLineNum").val("12");
    $("#p-window-add").window("open");
    $("#tempCode").focus();
}

///ѡ��ģ�壺
function openPage(){
	
	$("#prtTempTable").datagrid("reload");
	$("#p-window-open").window("open");
}

///ѡ��ĳ��ģ������
function deleteTemp(){
	var itmData=$("#prtTempTable").datagrid('getSelected');
	if(itmData==null){
		$.messager.alert('��ʾ',"δѡ��ģ�壡");
		return;
	}
	
	runClassMethod("web.DHCPRTMain","DelTmpData",{MARowID:itmData.MARowID},
        function(ret){
            if(ret==0){
	        	$.messager.alert("��ʾ","����ɹ���");
	        	$("#prtTempTable").datagrid("reload");
	        	return;    
	        }
        },'text'
    )
}

///ѡ��ĳ��ģ������
function openTemp(){
	var itmData=$("#prtTempTable").datagrid('getSelected');
	if(itmData==null){
		$.messager.alert('��ʾ',"δѡ��ģ�壡");
		return;
	}
	initTempPage(itmData.MARowID);
}

///��ȡ��������
function initTempPage(MARowID){
    runClassMethod("web.DHCPRTMain","GetTmpData",{MARowID:MARowID},
        function(ret){
            initTempPageData(ret);
        },'text'
    )
}

function initTempPageData(data){
	var tempDataArr = data.split("&&");
	MARowID = tempDataArr[0];
	PageWidth = tempDataArr[3]+"mm";
	PageHeight = tempDataArr[4]+"mm";
	TempType = tempDataArr[5];
	TempLine = tempDataArr[6];

	$("#p-opitm-temp").html(tempDataArr[1]);
	$("#p-opitm-tempLine").html("("+TempLine+"��)");
	if(tempDataArr[7]==""){
		var cssObj={};
		cssObj.width=tempDataArr[3]+"mm";
		//cssObj.height=tempDataArr[4]+"mm";
		cssObj.position="relative";
		$("#p-panel").css(cssObj);
		$("#p-panel").html(tempDataArr[7]);
	}else{
		$("#p-prtArea").html(tempDataArr[7].saveOrShowDataFormat("show"));	
	}
	panelElem = document.getElementById("p-panel");
	
	OpenTempInit();
	
	$("#p-window-open").window("close");
}

///ÿ�δ�ģ�嶼�����
function OpenTempInit(){
	OpenTempInitParams();	
	OpenTempInitMethod();
	return;
}

//����ģ��
function saveTemp(){
	var Limit= "^" ; //String.fromCharCode(2);
    var prtID = $("#p-prtId").val();
    var tmpCode = $("#tempCode").val();
    var tmpDesc = $("#tempDesc").val();
    var tmpWidth = $("#tempWidth").val();
    var tmpHeight = $("#tempHeight").val();
    var tempType = $("#tempType").combobox("getValue");
    var tempLineNum = $("#tempLineNum").val();
    var params=prtID+ Limit +tmpCode+ Limit +tmpDesc+ Limit +tmpWidth+ Limit +tmpHeight+ Limit +tempType;
    params= params+ Limit +tempLineNum;

    runClassMethod("web.DHCPRTMain","SaveOrUpdate",{Params:params},
        function(ret){
            if(ret==0) {
	            saveTmpOK(ret);
	            $("#p-window-add").window("close");
            }
            if(ret<0) saveTmpNo(ret);
        },'text'
    )

}

///�����ӡģ��
function saveHtml(){
	$(".p-selItm").removeClass("p-selItm");
	var allHtml=$("#p-prtArea").html().saveOrShowDataFormat("save");
	var html="",html1="",html2="",html3=""
	html=allHtml.substring(0,30000);
	html1=allHtml.substring(30000,60000);
	html2=allHtml.substring(60000,90000);
	html3=allHtml.substring(90000,120000);
	
	runClassMethod("web.DHCPRTMain","SaveHtml",{MARowID:MARowID,MALineNum:TempLine,Html:html,Html1:html1,Html2:html2,Html3:html3},
        function(ret){
            if(ret==0) saveTmpOK(ret);
            if(ret<0) saveTmpNo(ret);
        },'text'
    )	
}


//��ӡԤ��
function viewPage(){
    var tmpCode = $("#p-opitm-temp").text();
    var panelWidth = $("#p-panel").width();
    var panelHeight = $("#p-panel").height();
    var winWinth = $(window).width();
    var winHeight= $(window).height();
    var openWinWidth="",openWinHeight="",openWinLeft="";
    openWinWidth = (panelWidth<winWinth?panelWidth:winWinth);
    openWinWidth= (panelHeight>winHeight?openWinWidth+40:openWinWidth)
    openWinHeight = winHeight;
    openWinLeft = (winWinth-openWinWidth)/2;
    if(openWinLeft<0) openWinLeft=0;

    var winCss = "toolbar=no,location=no,directories=no,status=no,menubar=no,";
    winCss=winCss+"scrollbars=yes, resizable=no, copyhistory=no, width="+openWinWidth+", height="+openWinHeight+",left="+openWinLeft;
    window.open("dhcemviewprt.csp?TmpCode="+tmpCode,"_blank",winCss);
}


function saveTmpOK(){
    $.messager.alert("��ʾ","����ɹ���");
}

function saveTmpNo(err){
    $.messager.alert("��ʾ","����ʧ�ܣ�����"+err);
}

///�س��¼�
function setDomStyle(e){
    var id = $(e.target).attr("id");
    var value = $(e.target).val();
	if(e.keyCode!=13){
		return;
	}
    setElemAttr(id,value);
}
///ʧȥ�����¼�
function blueSetDomStyle(e){
    setElemAttr($(e.target).attr("id"),$(e.target).val());
}

///ɾ��Ԫ��
function deletItm(){
	if($(".p-selItm")[0].tagName=="TD"){
		$(".p-selItm").parent().remove();	
	}else{
		$(".p-selItm").remove();
	}
	return;
}

///ITM:
function keypressItmp(e){
	console.log(e.keyCode);
}

///ITM:
function setAttrPanel(e){
	$("#p-itma-text").focus();
    setAttrPanelByEle(e.target);
}

function setAttrPanelByEle(eTargetElem){
    var elemTop = eTargetElem.style.top;
    var elemLeft = eTargetElem.style.left;
    var elemWidth = eTargetElem.style.width;
    var elemHeight = eTargetElem.style.height;
    var elemFontSize = eTargetElem.style.fontSize;
    var elemMargin = eTargetElem.style.margin;
    var elemSrc= $(eTargetElem).attr("src");
    var elemID= $(eTargetElem).attr("id");
    var colspan= $(eTargetElem).attr("colspan");
    var rowspan = $(eTargetElem).attr("rowspan");
    var elemText= $(eTargetElem).text();
    var elemParentExtend= $(eTargetElem).parent().attr("id");
    if(!$(eTargetElem).hasClass("p-selItm")){
		$(".p-selItm").removeClass("p-selItm");
		$(eTargetElem).addClass("p-selItm");
    }else{
	    
	}
    $("#p-itma-posx").val(elemLeft);
    $("#p-itma-posy").val(elemTop);
    $("#p-itma-width").val(elemWidth);
    $("#p-itma-height").val(elemHeight);
    $("#p-itma-id").val(elemID);
    $("#p-itma-text").val(getElemText(elemText));
    $("#p-itma-colspan").val(colspan);
    $("#p-itma-rowspan").val(rowspan);
    $("#p-itma-fontsize").val(elemFontSize);
    $("#p-itma-extend").val(elemParentExtend);
    $("#p-itma-margin").val(elemMargin);
    $("#p-itma-imgurl").val(elemSrc);
    return;	
}

///�Ҳ�input�س��ı�
function setElemAttr(id,value){
	selItmElem = $(".p-selItm")[0];
	value = value.trim();
	$("#"+id).val(value);
    switch (id){
        case  "p-itma-posy" :
            selItmElem.style.top = value;
            break;
        case  "p-itma-posx" :
            selItmElem.style.left = value;
            break;
        case  "p-itma-width" :
            selItmElem.style.width = value;
            break;
        case  "p-itma-height" :
            selItmElem.style.height = value;
            break;
        case  "p-itma-margin" :
            selItmElem.style.margin = value;
            break;
        case  "p-itma-id" :
            $(selItmElem).attr("id",value);
            $(selItmElem).html(getItmHtml(selItmElem))
            break;
        case  "p-itma-text" :
        	$(selItmElem).html(value);
            $(selItmElem).html(getItmHtml(selItmElem));
            break;
        case  "p-itma-colspan" :
        	if(parseInt(value)>parseInt(TempLine)){
	        	$.messager.alert('��ʾ',"������ֻ��"+TempLine+"�У�");
				return;	
	        }
        	
        	if(!isAllowMergeCol(value)){
		    	$.messager.alert('��ʾ',"�ϲ��и߶Ȳ�ͳһ�����ܺϲ���");
		    	$("#p-itma-rowspan").val("");
				return;	    
		    }
        	
        	if($(selItmElem).attr("colspan")!=undefined){
	        	splitTd();
	        	_tdp=$(selItmElem).prevAll().length;
		        _rsp = $(selItmElem).attr("rowspan");
				for (var i=1;i<_rsp;i++) {
					$(selItmElem).parent().nextAll().eq(i-1).find("td").eq(_tdp).attr("colspan",value);
				}
	        	$("#"+id).val(value);
	        }
	       
	        $(selItmElem).attr("colspan",value);
            var tdWidth = parseInt(PageWidth)*value/TempLine+"mm";
             $(selItmElem).css({"width":tdWidth,"max-width":tdWidth});
            for(i=1;i<value;i++){
	        	$(selItmElem).nextAll().eq(i-1).hide();    
	        }
            break;
        case  "p-itma-rowspan" :
        	
        	if($(selItmElem).attr("colspan")!=undefined){
	        	$("#"+id).val(value);
	        }
	        if(!isAllowMerge(value)){
		    	$.messager.alert('��ʾ',"�ϲ��п�Ȳ�ͳһ�����ܺϲ���");
		    	$("#p-itma-rowspan").val("");
				return;	    
		    }
	        mergeLine(value);
	       
            break;
        case  "p-itma-fontsize" :
            $(selItmElem).css({"font-size":value});
            break;
        case  "p-itma-extend" :
            $(selItmElem).parent().attr("id",value);
            break;
        case  "p-itma-imgurl" :
            $(selItmElem).attr("src",value);
            break;    
        default :
            break;
    }
}

///���ô�ӡģ������б�������
function addItmEle(e){
	e = event||e;
	var id = $(e.target).attr("id");
	switch (id){
        case  "lable" :
            addLable();
            break;
        case  "table" :
        	addTable();
            break;
        default :
            break;
    }	
}

///LableԪ��
function addLable(){
    var lableEle ='<div class="p-itmp  p-itmp-drag" style="position: absolute;left:0mm;top:0mm">'+"LableItm1"+'</div>';
    $("#p-panel").append(lableEle);
}

///tableԪ��
function addTable(){
	
    var tableEle ='<table cellspacing="0" cellpadding="0" style="table-layout:fixed;box-sizing:border-box;border-right:1px solid #000;border-bottom:1px solid #000;width:'+PageWidth+'">' 
	tableEle =tableEle+getTrHtml();
    tableEle = tableEle+'</table>';
    $("#p-panel").append(tableEle);
    return;
}

///OP:���һ��
function addTableTr(){
	$("#p-panel").find("table").append(getTrHtml());
	return;
}

///OP:���һ��
function addTableLine(){

	TempLine = parseInt(TempLine)+1;
	
	synTdTempLine();
	
	$("table td",".p-panel").each(function(){
		synTdWidth($(this));	
	})
	
	$("table tr",".p-panel").each(function(){
		$(this).append(getTdHtml());	
	})
}

///OP:����һ��
function insertTableLine(){
	
	if(!$(".p-selItm").length){
		$.messager.alert('��ʾ',"δѡ��Ԫ�أ�");
		return;
	}
	
	if($(".p-selItm")[0].tagName!="TD"){
		$.messager.alert('��ʾ',"ѡ��Ԫ�ط�TDԪ�أ�");
		return;
	}

	TempLine = parseInt(TempLine)+1;

	_an=0;  ///Insert td position
	$(".p-selItm").prevAll().each(function(){
		_n =$(this).attr("colspan")==undefined?1:$(this).attr("colspan");
		_an+=parseInt(_n);
	})
	
	for (var i=0;i<$("table tr",".p-panel").length;i++) {
		if(_an==0){
			$("table tr",".p-panel").eq(i).prepend(getTdHtml());
		}else{
			var _ian=0;
	        $("table tr",".p-panel").eq(i).find("td").each(function(){
		        _in =$(this).attr("colspan")==undefined?1:$(this).attr("colspan");
				_ian+=parseInt(_in);
				if(_an==_ian){   ///need to increase
					$(this).after(getTdHtml());
					return false;
				}else if(_ian>_an){
					$(this).attr("colspan",parseInt(_in)+1);
					return false;
				}
		    })
		}
    }
    $("table td",".p-panel").each(function(){
		synTdWidth($(this));	
	})
    
    synTdTempLine();
	
	return;
}

///OP:���ƬͷIMG
function addImg(){
	$("#p-panel").prepend(getImgHtml());
	return;
}

///OP:���ƬͷDIV
function addHeardDiv(){
	if($(".p-heardDiv").length){
		$.messager.alert('��ʾ',"����ӣ���ͨ���Ҳ����ø߶ȣ�");
		return;
	}
	if($(".p-heardImg").length){
		$(".p-heardImg").after(getHeardDivHtml());	
	}else{
		$("#p-panel").prepend(getHeardDivHtml());
	}
	return;
}

///OP:���ƬͷIMG
function addSpan(){
	if($(".p-selItm").length){
		if($(".p-selItm")[0].tagName=="DIV"){
			$(".p-selItm").append(getSpanHtml());
		}else{
			$("#p-panel").append(getSpanHtml());	
		}
	}else{
		$("#p-panel").append(getSpanHtml());
	}
	return;
}

///OP:����һ��
function insertTableTr(){
	if($(".p-selItm").length){
		$(".p-selItm").parent().after(getTrHtml());
	}
	return;
}

///OP:��ֵ�Ԫ��
function splitTd(){
	if($(".p-selItm").length){
		_tw = getTW();
		_sir = $(".p-selItm").attr("colspan");
		_rsp = $(".p-selItm").attr("rowspan");
		_tdp=$(".p-selItm").prevAll().length;  ///td position
		$(".p-selItm").attr("colspan",1);
		$(".p-selItm").css({"width":_tw,"max-width":_tw});
		for (var i=1;i<_rsp;i++) {
			$(".p-selItm").parent().nextAll().eq(i-1).find("td").eq(_tdp).attr("colspan",1);
		}
		for(i=1;i<_sir;i++){
			$(".p-selItm").nextAll().eq(i-1).attr("rowspan",_rsp)
			$(".p-selItm").nextAll().eq(i-1).show();
		}
		setAttrPanelByEle($(".p-selItm")[0]);
	}
	return;
}

///OP:�в��
function splitLineTd(){
	_rsp=$(".p-selItm").attr("rowspan")
	_tdp=$(".p-selItm").prevAll().length;  ///td position
	for (var i=1;i<_rsp;i++) {
		$(".p-selItm").parent().nextAll().eq(i-1).find("td").eq(_tdp).show();
	}
	
	$(".p-selItm").attr("rowspan",1);
	return;
}

///OP:�����
function alignLeft(){
	if($(".p-selItm").length){
		$(".p-selItm").css({"text-align":"left"});
	}
	return;
}
///OP:����
function alignCenter(){
	if($(".p-selItm").length){
		$(".p-selItm").css({"text-align":"center"});
	}
	return;
}
///OP:�Ҷ���
function alignRight(){
	if($(".p-selItm").length){
		$(".p-selItm").css({"text-align":"right"});
	}
	return;
}

///OP:�Ӵ�
function overstriking(){
	if($(".p-selItm").length){
		if($(".p-selItm")[0].style.fontWeight){
			$(".p-selItm").css({"font-weight":""});
		}else{
			$(".p-selItm").css({"font-weight":"600"});
		}
	}
	return;
}


///OP:�ϱ߿�
function borderTop(){
	if($(".p-selItm").length){
		if($(".p-selItm")[0].style.borderTop=="none"){
			$(".p-selItm").css({"border-top":"1px solid #000;"});
		}else{
			$(".p-selItm").css({"border-top":"none"});
		}
	}
	return;
}

///OP:��߿�
function borderLeft(){
	if($(".p-selItm").length){
		if($(".p-selItm")[0].style.borderLeft=="none"){
			$(".p-selItm").css({"border-left":"1px solid #000;"});
		}else{
			$(".p-selItm").css({"border-left":"none"});
		}
	}
	return;
}

///OP:�ұ߿�
function borderRight(){
	if($(".p-selItm").length){
		if($(".p-selItm")[0].style.borderRight=="none"){
			$(".p-selItm").css({"border-right":"1px solid #000;"});
		}else{
			$(".p-selItm").css({"border-right":"none"});
		}
	}
	return;
}

///OP:�±߿�
function borderBottom(){
	if($(".p-selItm").length){
		if($(".p-selItm")[0].style.borderBottom=="none"){
			$(".p-selItm").css({"border-bottom":"1px solid #000;"});
		}else{
			$(".p-selItm").css({"border-bottom":"none"});
		}
	}
	return;
}

///OP:������չ
function downExtend(){
	if($(".p-selItm").length){
		selItmParent = $(".p-selItm").parent()
		if(($(selItmParent).attr("class")=="")||($(selItmParent).attr("class")==undefined)){
			$(selItmParent).attr("class","extendTr");
		}else{
			$(selItmParent).removeClass("extendTr");
		}
		
		for (i=0;i<selItmParent.find("td").length;i++){
			downExtendItm(selItmParent.find("td")[i]);
		}
	}
	return;
}

///OP:������չItm
function downExtendItm(ele){

	if(($(ele).attr("idExtend")=="")||($(ele).attr("idExtend")==undefined)){
		$(ele).attr("idExtend","1");
		$(ele).html(getItmHtml($(ele)[0]));
	}else{
		$(ele).removeAttr("idExtend");
		$(ele).html(getItmHtml($(ele)[0]));
	}

	return;
}

///OP:tdԪ��ͬ�����
function synTdWidth(tdEvent){
	_n =$(tdEvent).attr("colspan")==undefined?1:$(tdEvent).attr("colspan");
	_tw = _n*parseInt(PageWidth)/TempLine;
	_tw=_tw.toFixed(2)+"mm";   ///TempLine��td
	$(tdEvent).css({"width":_tw,"max-width":_tw});
}

///OP:tdԪ��ͬ����ֵ
function synTdTempLine(tdEvent){
	$("#p-opitm-tempLine").html("("+TempLine+"��)");	
}

///OP:�кϲ�
function mergeLine(merNum){
	if(merNum==1){
		splitLineTd();
		return;	
	}
	_an=0;  ///Merge td position
	_sir=$(".p-selItm").attr("colspan")==undefined?1:$(".p-selItm").attr("colspan");
	_an = $(".p-selItm").prevAll().length;
	
	for (var i=1;i<merNum;i++) {
		_ian=0;
		_itd=$(".p-selItm").parent().nextAll().eq(i-1).find("td").eq(_an);
        _in =$(_itd).attr("colspan")==undefined?1:$(_itd).attr("colspan");
	    $(".p-selItm").parent().nextAll().eq(i-1).find("td").eq(_an).hide();
    }
    $(".p-selItm").attr("rowspan",merNum);
    return;
}

///Query:�кϲ���֤tdͳһ���Ƿ�����ϲ�
function isAllowMerge(merNum){
	_cop=true;
	_an=0;  ///Merge td position
	_sir=$(".p-selItm").attr("colspan")==undefined?1:$(".p-selItm").attr("colspan");
	_an = $(".p-selItm").prevAll().length;
	
	for (var i=1;i<merNum;i++) {
		var _ian=0;
		_itd=$(".p-selItm").parent().nextAll().eq(i-1).find("td").eq(_an);
		if(_itd.is(":hidden")){
			_cop=false;
			break;
		}
		_in =$(_itd).attr("colspan")==undefined?1:$(_itd).attr("colspan");
		if(_sir!=_in){
			_cop=false;	
			break;
		}
    }
    return _cop;
}

///Query:�кϲ���֤tdͳһ���Ƿ�����ϲ�
function isAllowMergeCol(merNum){
	_cop=true;
	_an=0;  ///Merge td position
	_sir=$(".p-selItm").attr("rowspan")==undefined?1:$(".p-selItm").attr("rowspan");

	for(i=1;i<merNum;i++){
    	_itd=$(selItmElem).nextAll().eq(i-1);  
    	if($(_itd).is(":hidden")) continue; 
    	_in =$(_itd).attr("rowspan")==undefined?1:$(_itd).attr("rowspan");
		if(_sir!=_in){
			_cop=false;	
		}
    }
    return _cop;
}

///Get:tableԪ��
function getTrHtml(){
	_tw = getTW();   ///TempLine��td
   	var trHtml="";
   	trHtml = trHtml+'<tr style="height:8mm">';
	for(i=0;i<TempLine;i++){
		trHtml = trHtml+'<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;max-width:'+_tw+';width:'+_tw+'"></td>';
	}
	trHtml = trHtml+'</tr>'
    return trHtml;
}

///Get:ImgԪ��
function getImgHtml(){
	var imgWidth = parseInt(PageWidth)/2+"mm";   ///TempLine��td
	var imgHeight = "30mm"; 
	var imgMargin = "0mm 0mm 0mm "+parseInt(PageWidth)/4+"mm";
   	var imgHtml="";
   	imgHtml = imgHtml+'<img class="p-itmp p-heardImg" src="http://172.19.19.63/imedical/web/skin/default/images/logon/1.jpg" style="width:'+imgWidth+';height:'+imgHeight+';margin:'+imgMargin+';">'
    return imgHtml;
}

///Get:DivԪ��
function getHeardDivHtml(){
   	var heardDivHtml="";
   	heardDivHtml = heardDivHtml+'<div class="p-itmp p-heardDiv" style="width:'+PageWidth+';height:10mm;"></div>'
    return heardDivHtml;
}

///Get:spanԪ��
function getSpanHtml(){
    return '<span class="p-itmp p-itmp-drag" style="font-size:4mm;position:relative;left:0mm;top:0mm">ItmSpan</span>';
}


///Get:tdԪ��
function getTdHtml(){
	_tw = getTW();
   	return tdHtml='<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;max-width:'+_tw+';width:'+_tw+'"></td>';
}

function getTW(){
	return (parseInt(PageWidth)/TempLine).toFixed(2)+"mm";   ///TempLine��td
}

///�ṩ���շ�ʹ���Զ���ID
function setSelItmID(id,desc){
	desc=desc==""?"":desc+":"; 
	if($(".p-selItm").length){
		$(".p-selItm").html(desc);
		$("#p-itma-text").val(desc);
		setElemAttr("p-itma-id",id);
	}
	return;
}

//Ԫ��ֵ��ID
function getItmHtml(ele){
	var eleId = $(ele).attr("id")==undefined?"":$(ele).attr("id");
	var eleIsExtend = $(ele).attr("idExtend")==undefined?"":$(ele).attr("idExtend");
	eleIsExtend = eleIsExtend==""?"":"��";
	$(ele).html($(ele).html().substring(0,$(ele).html().indexOf("[")==-1?$(ele).html().length:$(ele).html().indexOf("[")));
	return eleId==""?$(ele).html():$(ele).html()+"["+eleId+"]"+eleIsExtend
}
///Ԫ��ֵ:����ֵ
function getElemText(value){
	return value.substring(0,value.indexOf("[")==-1?value.length:value.indexOf("["));
}


//��ӡ
function print(){
	var prtData={"PatName":"�շ�","Sex":"Ů","PatInfo":[{},{}]};
	var prtCode = $("#p-opitm-temp").html();
	var setObj = {"model":"print"};
	dhcprtPrint(prtCode,prtData,setObj);
	return;
 }
 
//��ӡԤ��
function printView(){
	var prtData={"PatName":"�������� qqa","PatSex":"��","PatInfo":[{},{},{}]};
	var prtCode = $("#p-opitm-temp").html();
	var setObj = {"model":"view"};
	dhcprtPrint(prtCode,prtData,setObj);
	return;
 }
 
var LINK_CSP="dhcapp.broker.csp";
/**
 * �����к�̨����
 * @creater zhouxin
 * @param className ������
 * @param methodName ������
 * @param datas ����{}
 * @param �ص�����
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
}

//��ֹ�����Ĭ����Ϊ������ͨ�÷��� 
function stopDefault(e) {
    if (e && e.preventDefault) {
        e.preventDefault();//��ֹ�����Ĭ����Ϊ(W3C) 
    } else {
       window.event.returnValue = false;//IE����ֹ�������Ϊ 
    }
    return false;
}