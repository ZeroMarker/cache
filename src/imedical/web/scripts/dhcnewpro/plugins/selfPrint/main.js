var MARowID="";   ///ģ��ID
var PageWidth="";
var PageHeight="";
var TempType="";
var TempLine="";
var HistArr=[];   ///������ʷ�洢(ֻ֧��Table��Td�ϲ�)
var CopyMode="";
var CopyObj={};
var BlankTempHtml=$("#p-prtArea").html();
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
			}
		]
	})
	$("#tempType").combobox("setValue",1);
	
	
	$("#p-itma-txttype").combobox({
		valueField: "value", 
		textField: "text",
		editable:true,
		data:[
			{"value":"checkbox","text":"checkbox"},
			{"value":"radio","text":"radio"}
		],
		onSelect: function(rec){
			txtTypeSelect(rec);
            return;
        },onChange:function(newValue, oldValue){
	        if(MARowID=="") return;
	        
			if ((newValue == "")||(newValue == undefined)){
				txtTypeSelect({value:""});
            	return;
			}
		}
	})
	
}

function initDatagrid(){
	var columns=[[
		{field:'op',align: 'center',title: '����',width:50,formatter:setCellOp},
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
		url: 'dhcapp.broker.csp?ClassName=web.DHCPRTMain&MethodName=JsonList&HospDr='+window.parent.HospDr,
		fit:true,
		border:false,
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
		onDblClickRow:function(index,row){
			initTempPage(row.MARowID);
		},
		onLoadSuccess:function(data){

		}
    })	
}

function queryPrtTempTable(){
	$("#prtTempTable").datagrid("load",{
		Code:$("#queryTempCode").val(),
		Desc:$("#queryTempDesc").val(),
		HospDr:window.parent.HospDr
	})
	return;	
}

function setCellOp(value, rowData, rowIndex){
	var html = "<a href='#' onclick='openTemp("+rowData.MARowID+")'><img src='../scripts/dhcnewpro/images/prt-openTemp.png' border=0/></a>";
	    html += "<a style='margin-left:10px' href='#' onclick='deleteTemp("+ rowData.MARowID +")'><img src='../scripts/dhcnewpro/images/prt-remTemp.png' border=0/></a>";
	return html;
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
		if((event.keyCode==38)&&(event.altKey)){  //��
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
		
		if((event.keyCode==40)&&(event.altKey)){  //��
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
		
		if((event.keyCode==37)&&(event.altKey)){  //��
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
		
		if((event.keyCode==39)&&(event.altKey)){  //��
			_sir=$(".p-selItm").attr("colspan")==undefined?1:$(".p-selItm").attr("colspan");
			$(".p-selItm").nextAll().eq(_sir-1).mousedown();
			stopDefault(event);
			return;    
		}
		
		if((event.shiftKey)&&(event.keyCode==81)){
			//��������ӡģ����ڵ����⣬���ҽ����޸�
			
		}
		if(event.ctrlKey && ((event.keyCode==67)||(event.keyCode==99))){  //ctrl+c ����
			if(CopyMode!=1) return;
			stopDefault(event);
			if(!$(".p-selItm").length) {
				$.messager.popover({msg: 'Ŀ��Ԫ��Ϊ�գ�',type:'error',timeout: 2000});
				return;
			}
			$(".p-copyItm").length?$(".p-copyItm").removeClass("p-copyItm"):"";
			CopyObj.Mode="c";
			CopyObj.Dom=$(".p-selItm");
			$(".p-selItm").addClass("p-copyItm");
			return;    
		}
		
		if(event.ctrlKey && ((event.keyCode==88)||(event.keyCode==120))){  //ctrl+x ����
			if(CopyMode!=1) return;
			stopDefault(event);
			if(!$(".p-selItm").length) {
				$.messager.popover({msg: 'Ŀ��Ԫ��Ϊ�գ�',type:'error',timeout: 2000});
				return;
			}
			$(".p-copyItm").length?$(".p-copyItm").removeClass("p-copyItm"):"";
			CopyObj.Mode="x";
			CopyObj.Dom=$(".p-selItm");
			$(".p-selItm").addClass("p-copyItm");
			
			return;    
		}
		
		if(event.ctrlKey && ((event.keyCode==86)||(event.keyCode==118))){  //ctrl+v ճ��
			if(CopyMode!=1) return;
			stopDefault(event);
			if(!$(".p-selItm").length) {
				$.messager.popover({msg: 'Ŀ��Ԫ��Ϊ�գ�',type:'error',timeout: 2000});
				return;
			}
			if(CopyObj.Dom=="") {
				$.messager.popover({msg: 'ճ����Ϊ�գ�',type:'error',timeout: 2000});
				return;
			}
			$(".p-selItm").html(CopyObj.Dom.html());
			CopyObj.Dom.attr("id")==undefined?"":$(".p-selItm").attr("id",CopyObj.Dom.attr("id"));
			
			setAttrPanelByEle($(".p-selItm")[0]);
			if(CopyObj.Mode=="x"){
				CopyObj.Dom.removeClass("p-copyItm");
				CopyObj.Dom.removeAttr("id");
				CopyObj.Dom.html("");
				CopyObj.Mode="";
				CopyObj.Dom="";	
			}
			
			return;    
		}
		console.log(event.keyCode);

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
    $("#p-panel").on("dblclick",".p-itmp",openOrCloseCopyMode);   //����Ԫ���ƶ��¼�
}

function openOrCloseCopyMode(){
	if(!event.ctrlKey) return;
	CopyMode==""?CopyMode=1:CopyMode="";
	if(CopyMode){
		$.messager.popover({msg: '����ģʽ�ѿ���',type:'success',timeout: 2000});
	}else{
		CopyObj.Mode="";
		CopyObj.Dom="";	
		$(".p-copyItm").removeClass("p-copyItm");
		$.messager.popover({msg: '����ģʽ�ѹر�',type:'success',timeout: 2000});
	}
	
	return;	
}
function OpenTempInitParams(){
	HistArr=[]; 
}

//ģ���ʼ��
function addPage(){
	$("#p-prtId").val("");
	$("#tempCode").val("");
	$("#tempDesc").val("");
	$("#tempWidth").val("197");
	$("#tempHeight").val("285");
	$("#tempLineNum").val("12");
	$("#isHasTemp").html("");
	
	$("#tempWidth").attr("disabled",false);
	$("#tempHeight").attr("disabled",false);
	$("#tempLineNum").attr("disabled",false);
	$("#tempType").combobox("enable");
	$HUI.validatebox("#tempCode").isValid();
	$HUI.validatebox("#tempDesc").isValid();
	$("#p-window-add").window({
		title:"����",
		iconCls:"icon-w-add"	
	}).window("open");
	
    $("#tempCode").focus();
}

///ѡ��ģ�壺
function openPage(){
	$("#prtTempTable").datagrid("load",{
		Code:$("#queryTempCode").val(),
		Desc:$("#queryTempDesc").val(),
		HospDr:window.parent.HospDr
	})
	$("#p-window-open").window("open");
}

///ѡ��ĳ��ģ������
function deleteTemp(MARowID){
	
	 $.messager.confirm('��ʾ', '�Ƿ�ȷ��ɾ��?', function(r){
	    if (r){
	   		runClassMethod("web.DHCPRTMain","DelTmpData",{MARowID:MARowID},
		        function(ret){
		            if(ret==0){
			        	$.messager.alert("��ʾ","ɾ���ɹ�!");
			        	$("#prtTempTable").datagrid("reload");
			        	return;    
			        }
		        },'text'
		    ) 	
		}
	});
}

///ѡ��ĳ��ģ������
function openTemp(MARowID){
	initTempPage(MARowID);
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
	MARowID = parseInt(tempDataArr[0]);
	PageWidth = tempDataArr[3]+"mm";
	PageHeight = tempDataArr[4]+"mm";
	TempType = tempDataArr[5];
	TempLine = tempDataArr[6];
	
	$("#p-opitm-tempRowID").val(MARowID)
	$("#p-prtId").val(MARowID);
	$("#p-opitm-temp").html(tempDataArr[1]);
	$("#p-opitm-tempLine").html("("+TempLine+"��)");
	$("#p-opitm-tempWidth").html(PageWidth);
	if(tempDataArr[7]==""){
		var cssObj={};
		cssObj.width=tempDataArr[3]+"mm";
		cssObj.position="relative";
		$("#p-panel").css(cssObj);
		$("#p-demoArea").is(":hidden")?$("#p-prtArea").html(BlankTempHtml):$("#p-demoArea-text").val(BlankTempHtml);
	}else{
		$("#p-demoArea").is(":hidden")?$("#p-prtArea").html(tempDataArr[7].saveOrShowDataFormatNew("show")):$("#p-demoArea-text").val(tempDataArr[7].saveOrShowDataFormatNew("show"));	
	}
	
	upgradeUpd(); ///����bug�޸�
	
	$(".p-panel").length?$(".p-panel").removeCss("min-height"):""; ///��Բ����¼��Ĵ�ӡ����ʵ�ǹ̶���ȣ��߶Ȳ��̶�
	panelElem = document.getElementById("p-panel");
	OpenTempInit(); ///��ʼ�������Ͱ󶨵ķ���
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
    
    if((tmpCode=="")&&(tmpDesc=="")){
		$.messager.alert("��ʾ","ģ�����ƺ�ģ����������Ϊ�գ�");
		return;   	 
	}
    
    var params=prtID+ Limit +tmpCode+ Limit +tmpDesc+ Limit +tmpWidth+ Limit +tmpHeight+ Limit +tempType;
    params= params+ Limit +tempLineNum;

    runClassMethod("web.DHCPRTMain","SaveOrUpdate",{Params:params,"HospDr":window.parent.HospDr},
        function(ret){
            if(ret==0) {
	            saveTmpOK(ret);
	            $("#p-window-add").window("close");
            }else if(ret==-2) {
	        	$.messager.alert("��ʾ","ģ�������ظ���");
				return;   
	        }else if(ret==-3) {
	        	$.messager.alert("��ʾ","����ҽԺ����ʧ�ܣ�");
				return;   
	        }else{
		        saveTmpNo(ret);
		    }
        },'text'
    )

}

///�����ӡģ��
function saveHtml(){
	$HUI.linkbutton("#p-opitm-save").disable();
	var d1=new Date();
	$(".p-selItm").removeClass("p-selItm");
	var allHtml=$("#p-prtArea").html().saveOrShowDataFormat("save");
	var html="",html1="",html2="",html3="";
	html=allHtml.substring(0,30000);
	html1=allHtml.substring(30000,60000);
	html2=allHtml.substring(60000,90000);
	html3=allHtml.substring(90000,120000);
	var d2=new Date();
	console.log("ǰ̨�����ʱ:"+(d2-d1));
	runClassMethod("web.DHCPRTMain","SaveHtml",{MARowID:MARowID,MALineNum:TempLine,Html:html,Html1:html1,Html2:html2,Html3:html3},
        function(ret){
	        var d3=new Date();
	        console.log("��̨�����ʱ:"+(d3-d2));
	        $HUI.linkbutton("#p-opitm-save").enable();
            if(ret==0) saveTmpOK(ret);
            if(ret<0) saveTmpNo(ret);
        },'text'
    )	
}


///�����ӡģ��
function saveHtmlNew(){
	$HUI.linkbutton("#p-opitm-save").disable();
	var d1=new Date();
	$(".p-selItm").removeClass("p-selItm");
	var allHtml=($("#p-prtArea").is(":hidden")?$("#p-demoArea-text").val().saveOrShowDataFormatNew("save"):$("#p-prtArea").html().saveOrShowDataFormatNew("save"));
	
	var d2=new Date();
	console.log("ǰ̨�����ʱ:"+(d2-d1));
	runClassMethod("web.DHCPRTMain","SaveHtmlNew",{MARowID:MARowID,MALineNum:TempLine,MAWidth:parseInt(PageWidth),Html:allHtml,_headers:{'X-Accept-Tag':1}},
        function(ret){
	        var d3=new Date();
	        console.log("��̨�����ʱ:"+(d3-d2));
	        $HUI.linkbutton("#p-opitm-save").enable();
            if(ret==0) saveTmpOK(ret);
            if(ret<0) saveTmpNo(ret);
        },'text'
    )
}

///�����ӡģ��
function saveHtmlNewBak(){
	$HUI.linkbutton("#p-opitm-save").disable();
	var d1=new Date();
	$(".p-selItm").removeClass("p-selItm");
	var allHtml=($("#p-prtArea").is(":hidden")?$("#p-demoArea-text").val().saveOrShowDataFormatNew("save"):$("#p-prtArea").html().saveOrShowDataFormatNew("save"));
	
	var html="",html1="",html2="",html3="";
	html=allHtml.substring(0,30000);
	html1=allHtml.substring(30000,60000);
	html2=allHtml.substring(60000,90000);
	html3=allHtml.substring(90000,120000);
	var d2=new Date();
	console.log("ǰ̨�����ʱ:"+(d2-d1));
	runClassMethod("web.DHCPRTMain","SaveHtml",{MARowID:MARowID,MALineNum:TempLine,MAWidth:parseInt(PageWidth),Html:html,Html1:html1,Html2:html2,Html3:html3,_headers:{'X-Accept-Tag':1}},
        function(ret){
	        var d3=new Date();
	        console.log("��̨�����ʱ:"+(d3-d2));
	        $HUI.linkbutton("#p-opitm-save").enable();
            if(ret==0) saveTmpOK(ret);
            if(ret<0) saveTmpNo(ret);
        },'text'
    )	
}

function closeWin(){
	if(typeof arguments[0]=="string"){
		$HUI.window("#"+arguments[0]).close();	
	}
	return;
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
    openWinWidth= (panelHeight>winHeight?openWinWidth+40:openWinWidth);
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
		_rsp = $(".p-selItm").attr("rowspan");
		if(_rsp!=undefined){
			if(_rsp>1) splitLineTd();  ///�в��	
		}
	
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
    var elemParentExtType=$(eTargetElem).parent().attr("exttype");
    
    var texttype = $(eTargetElem).attr("texttype");
    var tabTop = $("#p-panel").find("table").length?$("#p-panel").find("table")[0].style.marginTop:"0mm";
    var tdBorder = $("#p-panel").find("td").length?$.trim($("#p-panel").find("td").eq(0).returnCss("border-top")):"";
    var trMinHeight=$(eTargetElem).parent()[0].style.minHeight;
    
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
    $("#p-itma-text").val(getElemText(elemText,texttype));  /// 2021-06-09 cy radio checkbox ������Ԫ��
    $("#p-itma-colspan").val(colspan);
    $("#p-itma-rowspan").val(rowspan);
    $("#p-itma-fontsize").val(elemFontSize);
    $("#p-itma-extend").val(elemParentExtend);
    $("#p-itma-exttype").val(elemParentExtType);
    $("#p-itma-margin").val(elemMargin);
    $("#p-itma-imgurl").val(elemSrc);
    $("#p-itma-txttype").combobox("setValue",texttype);
    $("#p-itma-tabbledown").val(tabTop);
    $("#p-itma-tabbleBorder").val(tdBorder);
    $("#p-itma-trMinHeight").val(trMinHeight);
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
            $(selItmElem).html($("#p-itma-text").val());
            $(selItmElem).html(getItmHtml(selItmElem));
            break;
        case  "p-itma-text" :
        	$(selItmElem).html(value);
        	$(selItmElem).attr("id",$("#p-itma-id").val());
            $(selItmElem).html(getItmHtml(selItmElem));
            break;
        case  "p-itma-colspan" :
        	var maxMergNum = $(selItmElem).nextAll().length+1;
        	if(parseInt(value)>maxMergNum){
	        	$.messager.alert('��ʾ',"��Ԫ�����ֻ�ܺϲ���Ϊ"+maxMergNum+"!");
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
        	var maxMergNum = $(selItmElem).parent().nextAll().length+1;
        	if(parseInt(value)>maxMergNum){
	        	$.messager.alert('��ʾ',"��Ԫ�����ֻ�ܺϲ���Ϊ"+maxMergNum+"!");
				return;	
	        }
        	
        	if($(selItmElem).attr("colspan")!=undefined){
	        	$("#"+id).val(value);
	        }
	        if(!isAllowMerge(value)){
		    	$.messager.alert('��ʾ',"�ϲ��п�Ȳ�ͳһ�����ܺϲ���");
		    	$("#p-itma-rowspan").val("");
				return;	    
		    }
		    
		    if(value==1){
				splitLineTd();		//�в��
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
        case  "p-itma-exttype" :
            $(selItmElem).parent().attr("exttype",value);
            break;
        case  "p-itma-imgurl" :
            $(selItmElem).attr("src",value);
            break;
        case  "p-itma-tabbledown" :
        	$("#p-panel").find("table").length?$("#p-panel").find("table").css({"margin-top":value}):"";
            break; 
        case  "p-itma-tabbleBorder" :
        	$("#p-panel").find("td").length?$("#p-panel").find("td").css({"border-top":value,"border-left":value}):"";
        	$("#p-panel").find("table").length?$("#p-panel").find("table").css({"border-right":value,"border-bottom":value}):"";
            break;
        case  "p-itma-trMinHeight" :
         	$(selItmElem).parent().css({"min-height":value,"height":value});
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
	if(!isCanWriteTemp()){
		return;	
	}
    var lableEle ='<div class="p-itmp  p-itmp-drag" style="position: absolute;left:0mm;top:0mm">'+"LableItm1"+'</div>';
    $("#p-panel").append(lableEle);
}

///tableԪ��
function addTable(){
	
	if(!isCanWriteTemp()){
		return;	
	}
	
	if($("#p-panel").find("table").length){
		
		if($("#p-panel").find("table").attr("style").indexOf("word-break")==-1){
			$("#p-panel").find("table").css({"word-break":"break-all"});
			$.messager.popover({msg: '�ɹ�ͬ��table��break-all����,��Ч��Ҫ�ֶ��������!',type:'success',timeout: 3000});
			return;
		}
		$.messager.alert("��ʾ","����Ѿ����,��ʱ��֧����Ӷ�����ͨ�����еȲ����ı�ģ�壡");	
		return;
	}
	
    var tableEle ='<table cellspacing="0" cellpadding="0" style="word-break:break-all;table-layout:fixed;box-sizing:border-box;border-right:1px solid #000;border-bottom:1px solid #000;width:'+PageWidth+'">' 
	tableEle =tableEle+getTrHtml();
    tableEle = tableEle+'</table>';
    $("#p-panel").append(tableEle);
    return;
}

///OP:���һ��
function addTableTr(){
	if(!isCanWriteTemp()){
		return;	
	}
	$("#p-panel").find("table").append(getTrHtml());
	return;
}

///OP:ɾһ��
function deletTableLine(){
	if(!$(".p-selItm").length){
		$.messager.alert('��ʾ',"δѡ��Ԫ�أ�");
		return;
	}
	
	if($(".p-selItm")[0].tagName!="TD"){
		$.messager.alert('��ʾ',"ѡ��Ԫ�ط�TDԪ�أ�");
		return;
	}
	
	var thisCol = $(this).attr("colspan")==undefined?1:$(this).attr("colspan");	
	if(thisCol>1){
		$.messager.alert('��ʾ',"ѡ��Ԫ�ذ����˶��У�");
		return;	
	}

	TempLine = parseInt(TempLine)-1;

	_an = $(".p-selItm").prevAll().length+1; 

	for (var i=0;i<$("table tr",".p-panel").length;i++) {
		var _ian=0;
		var thisCol = "";
		var isHide=false;
		var mp="",mpc="";
        $("table tr",".p-panel").eq(i).find("td").each(function(){
			thisCol = $(this).attr("colspan")==undefined?1:$(this).attr("colspan");	
			_ian++;
			if(thisCol>1) mp=_ian,mpc=thisCol;
			if(_an==_ian){   ///need to increase
				isHide= $(this).is(":hidden");
				if(thisCol>1){  ///���������Һϲ������
					$(this).attr("colspan",thisCol-1);
					$(this).next().remove();
					return false;	
				}
				
				if(isHide){     ///���Һϲ������ص�Ԫ��
					$(this).prevAll().eq(_an-mp-1).attr("colspan",mpc-1);
					$(this).remove();
					return false;	
				}
				$(this).remove();
				return false;
			}
	    })
    }
    synAllTdWidth();
    
    synTdTempLine();
	
	return;
}

///OP:���һ��
function addTableLine(){
	if(!isCanWriteTemp()){
		return;	
	}

	TempLine = parseInt(TempLine)+1;
	
	synTdTempLine();
	
	synAllTdWidth();
	
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

	
	_an = $(".p-selItm").prevAll().length+1;   ///Insert td position
	
	for (var i=0;i<$("table tr",".p-panel").length;i++) {
		var _ian=0;
		var isHide=false;
		var mp="",mpc="";
        $("table tr",".p-panel").eq(i).find("td").each(function(){
	        thisCol = $(this).attr("colspan")==undefined?1:$(this).attr("colspan");	
			if(thisCol>1) mp=_ian,mpc=thisCol;
			_ian++;
			if(_an==_ian){   ///need to increase
				isHide= $(this).is(":hidden");
				$(this).before(getTdHtml());
				if(isHide){
					$(this).prev().hide();
					$(this).prevAll().eq(_an-mp-1).attr("colspan",parseInt(mpc)+1);
				}
				return false;
			}
	    })
		
    }
    synAllTdWidth();
    
    synTdTempLine();
	
	return;
}

///OP:���ƬͷIMG
function addImg(){
	if(!isCanWriteTemp()){
		return;	
	}
	$("#p-panel").prepend(getImgHtml());
	return;
}

///OP:���ƬͷDIV
function addHeardDiv(){
	if(!isCanWriteTemp()){
		return;	
	}
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
	if(!isCanWriteTemp()){
		return;	
	}
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
		$(".p-selItm").parent().before(getTrHtml());
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
			$(".p-selItm").nextAll().eq(i-1).attr("rowspan",_rsp);
			$(".p-selItm").nextAll().eq(i-1).removeCss("display");
		}
		setAttrPanelByEle($(".p-selItm")[0]);
	}
	return;
}

///OP:�в��
function splitLineTd(){
	_rsp=$(".p-selItm").attr("rowspan");
	_tdp=$(".p-selItm").prevAll().length;  ///td position
	for (var i=1;i<_rsp;i++) {
		$(".p-selItm").parent().nextAll().eq(i-1).find("td").eq(_tdp).removeCss("display");
	}
	
	$(".p-selItm").attr("rowspan",1);
	return;
}

///OP:�϶���
function alignTop(){
	if($(".p-selItm").length){
		if($getValue($(".p-selItm").attr("valign"))==""){
			$(".p-selItm").attr("valign","top");
		}else{
			$(".p-selItm").removeAttr("valign");
		}
	}
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
			$(selItmParent).removeAttr("id");
			$(".p-selItm").mousedown();
		}
		
		for (var i=0;i<selItmParent.find("td").length;i++){
			downExtendItm(selItmParent.find("td")[i]);
		}
	}
	return;
}

function setTableTitle(){
	if($(".p-selItm").length){
		var selItmTagName = $(".p-selItm")[0].tagName;
		var selItmPos = $getValue($(".p-selItm")[0].style.position);
		var isImg=(selItmTagName=="IMG");
		var isWb =(selItmTagName=="DIV"&&selItmPos=="absolute");
		
		if(!(isImg||isWb)){
			$.messager.alert('��ʾ',"��LOGO�ͱ�ͷ�ı��������ô����ԣ�");
			return;
		}
		
		if($(".p-selItm").hasClass("p-itmp-tabTitle")){
			$(".p-selItm").removeClass("p-itmp-tabTitle");
			$.messager.popover({msg: 'ȡ����ͷ����',type:'success',timeout: 2000});
		}else{
			$(".p-selItm").addClass("p-itmp-tabTitle");
			$.messager.popover({msg: '�Ѿ�����Ϊ��ͷ',type:'success',timeout: 2000});
		}
		
	}
	return;	
}

///OP:������չItm
function downExtendItm(ele){

	if(($(ele).attr("idExtend")=="")||($(ele).attr("idExtend")==undefined)){
		$(ele).attr("idExtend","1");
		$(ele).html(getItmHtmlNoMoreId($(ele)[0]));
	}else{
		$(ele).removeAttr("idExtend");
		$(ele).html(getItmHtmlNoMoreId($(ele)[0]));
	}

	return;
}

///OP:����tdԪ��ͬ�����
function synAllTdWidth(){
	$("table td",".p-panel").each(function(){
		synTdWidth($(this));	
	})
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
   	trHtml = trHtml+'<tr style="min-height:8mm;height:8mm;">';
	for(i=0;i<TempLine;i++){
		trHtml = trHtml+'<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;max-width:'+_tw+';width:'+_tw+'"></td>';
	}
	trHtml = trHtml+'</tr>';
    return trHtml;
}

///Get:ImgԪ��
function getImgHtml(){
	var locationString = window.location.href;
	var locationArr = locationString.split("/");
	var imgUrl = locationArr[0]+"//"+locationArr[2]+"/"+locationArr[3]+"/"+locationArr[4];
	var imgWidth = parseInt(PageWidth)/2+"mm";   ///TempLine��td
	var imgHeight = "30mm"; 
	var imgMargin = "0mm 0mm 0mm "+parseInt(PageWidth)/4+"mm";
   	var imgHtml="";
   	imgHtml = imgHtml+'<img class="p-itmp p-heardImg" src="'+imgUrl+'/skin/default/images/logon/1.jpg" style="width:'+imgWidth+';height:'+imgHeight+';margin:'+imgMargin+';"/>'
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
function setSelItmID(id,desc,isAdd){
	desc=desc==""?"":desc+":"; 
	if($(".p-selItm").length){
		$(".p-selItm").html(desc);
		$("#p-itma-text").val(desc);
		var hasId=$(".p-selItm").attr("id");
		if(isAdd) id=hasId==""?id:hasId+","+id;
		setElemAttr("p-itma-id",id);
	}
	return;
}

//Ԫ��ֵ��ID
function getItmHtml(ele){
	var idValue=$("#p-itma-id").val();
	var idValArr = idValue.split(",");
	var textValue=$("#p-itma-text").val();
	var textValArr=textValue.split(",,");
	
	if(idValue==""){
		return textValue;
	}
	var eleTxtType = $(ele).attr("textType")==undefined?"":$(ele).attr("textType");
	//var eleId = $(ele).attr("id")==undefined?"":$(ele).attr("id");
	var ret="";
	var retIdValue="";
	/// 2021-06-09 cy radio checkbox ������Ԫ��
	if((eleTxtType=="radio")||(eleTxtType=="checkbox")){
		runClassMethod("web.DHCADVRepPrint","listHtml",{code:idValue},
        function(datalist){
            ret=datalist;
        },'text',false)
       ret=$getValue(textValArr[0])==""?ret:$getValue(textValArr[0])+ret; 
	}else{
	
		for (i in idValArr){
			if (idValArr[i]=="") continue;
			idValArr[i]=eleTxtType==""?"["+idValArr[i]+"]":"<input type='"+eleTxtType+"' id='"+idValArr[i]+"'/>"+"["+idValArr[i]+"]";
			//retIdValue=retIdValue==""?$getValue(textValue[i])+idValArr[i]:retIdValue+$getValue(textValue[i])+idValArr[i];
			ret=ret==""?$getValue(textValArr[i])+idValArr[i]:ret+$getValue(textValArr[i])+idValArr[i];
		}
	}
	//ret = textValue+retIdValue;
	return ret;
}

function getItmHtmlNoMoreId(ele){
	var eleTxtType = $(ele).attr("textType")==undefined?"":$(ele).attr("textType");
	var eleId = $(ele).attr("id")==undefined?"":$(ele).attr("id");
	var eleIsExtend = $(ele).attr("idExtend")==undefined?"":$(ele).attr("idExtend");
	eleIsExtend = eleIsExtend==""?"":"��";
	$(ele).html($(ele).html().substring(0,$(ele).html().indexOf("[")==-1?$(ele).html().length:$(ele).html().indexOf("[")));
	var ret = eleId==""?$(ele).html():$(ele).html()+"["+eleId+"]";
	return eleTxtType==""?ret:"<input type='"+eleTxtType+"' id='"+idValArr[i]+"'/>"+ret;
}
///Ԫ��ֵ:����ֵ
function getElemText(value,texttype){
	//return value.substring(0,value.indexOf("[")==-1?value.length:value.indexOf("["));
	var retArr=[],isOneText=true;
	if((texttype=="radio")||(texttype=="checkbox")){
		var valArr = value.split("[");
		var text="";
		if(valArr[0].indexOf(":")>=0){
			text=valArr[0].split(":")[0]+":";
		}
		retArr.push(text);
	}else{
		var valArr = value.split("]");
		var len = valArr.length;
		for(var i=1; i<len ;i++){
			if(valArr[i].split("[")[0]!=""){
				isOneText=false;				///�Ƿ���Ψһ���ݵ����	
			}
		}
		
		if(isOneText){
			retArr.push(valArr[0].split("[")[0]);		
		}else{
			for(var j in valArr){
				if(j!=(valArr.length-1)){
					retArr.push(valArr[j].split("[")[0]);
				}
			}
		}
	}
	return retArr.join(",,");
}

function txtTypeSelect(comboItm){
	if($(".p-selItm").length){
		$(".p-selItm").attr("textType",comboItm.value);
		$(".p-selItm").html(getItmHtml($(".p-selItm")[0]));
		return;
	}
}


//��ӡ
function print(){
	var prtCode = $("#p-opitm-temp").html();
	var setObj = {"model":"print","marginLeft":"5mm","orient":1};
	var dataObj={"PatName":"qqa","EmPatName":"��"};
	var ret = dhcprtPrint(prtCode,dataObj,setObj);
	
	if(ret.code<0){
		$.messager.alert('��ʾ',ret.errInfo);
	}
	return true;
 }
 
//��ӡԤ��
function printView(){
	var prtCode = $("#p-opitm-temp").html();
	var setObj = {"model":"view","marginLeft":"5mm","orient":1};
	var dataObj={"id1":"qqa","id2":"��","yes":"��","CheckItem":"id,yes"};
	var ret = dhcprtPrint(prtCode,dataObj,setObj);
	if(ret.code<0){
		$.messager.alert('��ʾ',ret.errInfo);	
	}
	return;
 }
 
function isCanWriteTemp(){
	var prtCode = $("#p-opitm-temp").html();
	if(prtCode===""){
		$.messager.alert('��ʾ',"δ�򿪲���ģ��,��ѡ���ӡģ�壡");
		return false;	
	}
	return true;
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


///��չ���ܣ����jq�ṩɾ��ĳ��cssԪ�صĹ���
$.fn.removeCss=function(toDelete) {
	var props = $(this).attr('style').split(';');
	var tmp = -1;
	for( var p=0; p<props.length; p++) {
		if(props[p].indexOf(toDelete)!== -1 ) {
		    tmp=p
		}
	}
	if(tmp !== -1) {
        props.splice(tmp,1);
    }
    
	return $(this).attr('style',props.join(';'));
}

$.fn.hasCss=function(cssName) {
	var thisStyle = $(this).attr('style');
	return thisStyle.indexOf(cssName)!=-1?true:false;
}

///��չ���ܣ����jq�ṩ��ȡĳ��Ԫ��css�Ĺ���
$.fn.returnCss=function(toReturn) {
	var props = $(this).attr('style').split(';');
	var tmp = -1;
	for( var p=0; p<props.length; p++) {
		if(props[p].indexOf(toReturn)!== -1 ) {
		    tmp=props[p];
		}
	}
	
	if(tmp !== -1) {
        tmp=tmp.split(":")[1];
    }
	return tmp;
}



function updTemp(){
	var ID = $("#p-opitm-tempRowID").val()
	$("#p-prtId").val(ID);
	
	if(ID==""){
		return;
	}
	$("#p-window-add").window({
		title:"�޸�",
		iconCls:"icon-w-edit"	
	}).window("open");
	
	var data = serverCall("web.DHCPRTMain","GetTmpDataNoPrintData",{MARowID:MARowID});
	var tempDataArr = data.split("&&");
	var Code = tempDataArr[1];
	var Desc = tempDataArr[2];
	var Widh = tempDataArr[3];
	var Height = tempDataArr[4];
	var Type = tempDataArr[5];
	var Line = tempDataArr[6];
	$("#tempCode").val(Code);
	$("#tempDesc").val(Desc);
	$("#tempWidth").val(Widh);
	$("#tempHeight").val(Height);
	$("#tempLineNum").val(Line);
	$("#tempType").combobox("setValue",Type);
	
	$("#tempWidth").attr("disabled",true);
	$("#tempHeight").attr("disabled",true);
	$("#tempLineNum").attr("disabled",true);
	$("#tempType").combobox("disable");
	$HUI.validatebox("#tempCode").isValid();
	$HUI.validatebox("#tempDesc").isValid();
	return;
}

function updTempWidth(){
	$("#p-opitm-tempWidth").hide();
	var tempWidth = parseInt($("#p-opitm-tempWidth").html());
	$("#p-opitm-tempWidthVal").val(tempWidth);
	$("#p-opitm-tempWidthVal").show();
	$("#p-opitm-tempWidthVal").focus();
	return;
}

function updQueTempWidth(){
	$("#p-opitm-tempWidthVal").hide();
	var tempWidth = $("#p-opitm-tempWidthVal").val()+"mm";
	PageWidth = tempWidth;
	$("#p-panel").css("width",PageWidth);
	$("table","#p-panel").css("width",PageWidth);
	
	$("#p-opitm-tempWidth").html(tempWidth);
	$("#p-opitm-tempWidth").show();
	synAllTdWidth();
	return;	
}

function demoMode(){
	if(!$("#p-demoArea").is(":hidden")){
		return;	
	}
	$("#p-prtArea").hide();
	$("#p-demoArea").show();
	$("#p-demoArea-text").val($("#p-prtArea").html());
	$("#p-prtArea").html("");
	return;
}

function viewMode(){
	if(!$("#p-prtArea").is(":hidden")){
		return;	
	}
	$("#p-prtArea").show();
	$("#p-demoArea").hide();
	$("#p-prtArea").html($("#p-demoArea-text").val());
	$("#p-demoArea-text").val("");
	OpenTempInit();
	return;
}

///ҳ������
function pageSet(){
	var prtCode = $("#p-opitm-temp").html();
	if(prtCode===""){
		$.messager.alert('��ʾ',"δ�򿪲���ģ��,��ѡ���ӡģ�壡");
		return false;	
	}
	var printerName = $getValue($("#p-panel").attr("printerName"));
	var prtDirection = $getValue($("#p-panel").attr("prtDirection"));
	var prtPageName = $getValue($("#p-panel").attr("prtPageName"));
	var pagingGranularity = $getValue($("#p-panel").attr("pagingGranularity"));
	
	var marginTop = $getValue($("#p-panel").attr("marginTop"));
	var marginBottom = $getValue($("#p-panel").attr("marginBottom"));
	var marginLeft = $getValue($("#p-panel").attr("marginLeft"));
	var marginRight = $getValue($("#p-panel").attr("marginRight"));
	var heardAndBot = $getValue($("#p-panel").attr("heardAndBot"));
	var heardAndBotArr = heardAndBot.split("!!");
	var len = heardAndBotArr.length;
	
	for(var i=1;i<len;i++){
		prtHeadAdd();	
	}
	
	for(var j=0;j<len;j++){
		var itmArr = heardAndBotArr[j].split("@@");
		$("#prtHeadTable").find("tr").eq(j+1).find(".prtHead-text").val(itmArr[0]);
		$("#prtHeadTable").find("tr").eq(j+1).find(".prtHead-x").val(itmArr[1]);
		$("#prtHeadTable").find("tr").eq(j+1).find(".prtHead-y").val(itmArr[2]);
		$("#prtHeadTable").find("tr").eq(j+1).find(".prtHead-pf").val(itmArr[3]);
	}
	
	$("#prtHead-printerName").val(printerName);
	$("#prtHead-prtDirection").val(prtDirection);
	$("#prtHead-prtPageName").val(prtPageName);
	$("#prtHead-pagingGranularity").val(pagingGranularity);

	$("#prtHead-marginTop").val(marginTop);
	$("#prtHead-marginBottom").val(marginBottom);
	$("#prtHead-marginLeft").val(marginLeft);
	$("#prtHead-marginRight").val(marginRight);
	
	
	$("#p-window-page").window("open");	
}

///ҳ������
function prtHeadCancel(){
	$("#p-window-page").window("close");
	$("input[name^='prtHead-']").val("");
	$("#prtHeadTable").find("tr").not(".prtHeadFixed").remove();
	return;
}

///ҳ������
function prtHeadAdd(){
	var len = $("#prtHeadTable").find("tr").length;
	var trHtml = $("#prtHeadTable").find("tr").eq(len-1).removeClass("prtHeadFixed")[0].outerHTML;
	if(len==2){
		$("#prtHeadTable").find("tr").eq(1).addClass("prtHeadFixed");	
	}
	$("#prtHeadTable").append(trHtml);
	return;
}

///ҳ������
function prtHeadDel(){
	var len = $("#prtHeadTable").find("tr").length;
	if(len==2){
		$("#prtHeadTable").find("tr").find("input").val("");
		return;	
	}
	$(event.target).parent().parent().remove();
	return;
}

///ҳ������
function prtHeadSave(){
	var printerName = $("#prtHead-printerName").val();
	var prtDirection = $("#prtHead-prtDirection").val();
	var prtPageName = $("#prtHead-prtPageName").val();
	var pagingGranularity = $("#prtHead-pagingGranularity").val();
	
	var marginTop = $("#prtHead-marginTop").val();
	var marginBottom = $("#prtHead-marginBottom").val();
	var marginLeft = $("#prtHead-marginLeft").val();
	var marginRight = $("#prtHead-marginRight").val();
	var heardAndBot="";
	$("#prtHeadTable").find("tr").each(function(){
		var heardAndBotItm="";
		if(!$(this).find(".prtHead-text").length) return true;
		if($(this).find(".prtHead-text").val()=="") return true;
		heardAndBotItm = $(this).find(".prtHead-text").val()+"@@"+$(this).find(".prtHead-x").val()+"@@"+
						$(this).find(".prtHead-y").val()+"@@"+$(this).find(".prtHead-pf").val()
		heardAndBot==""?heardAndBot=heardAndBotItm:heardAndBot=heardAndBot+"!!"+heardAndBotItm;
	})
	
	if($("#p-panel").length){
		$("#p-panel").attr("printerName",printerName);
		$("#p-panel").attr("prtDirection",prtDirection);
		$("#p-panel").attr("prtPageName",prtPageName);
		$("#p-panel").attr("pagingGranularity",pagingGranularity);
		
		$("#p-panel").attr("marginTop",marginTop);
		$("#p-panel").attr("marginBottom",marginBottom);
		$("#p-panel").attr("marginLeft",marginLeft);
		$("#p-panel").attr("marginRight",marginRight);
		$("#p-panel").attr("heardAndBot",heardAndBot);
	}
	
	prtHeadCancel();
	
	return;
}

///IEͼƬ
function testPrint1(){
	LODOP = getLodop();
	var imgUrl="<img src='http://127.0.0.1/imedical/web/skin/default/images/logon/2.jpg' border='0'>";
	LODOP.ADD_PRINT_IMAGE("0mm","0mm","100mm","30mm",imgUrl);
	LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",1000)//������һ���ӳٳ��ı�����1000����
	LODOP.SET_PRINT_STYLEA(0,"Stretch",1);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.PREVIEW();
	return;
}

//LODOP��ҳ
function testPrint(){
	var ret = $(".p-selItm").returnCss("border-top");
	alert(ret);
	return;
	LODOP = getLodop();
	LODOP.ADD_PRINT_TEXT("0mm","0mm","100mm","100mm","���Է�ҳ");
	LODOP.NEWPAGE();
	LODOP.ADD_PRINT_TEXT("0mm","0mm","100mm","100mm","���Է�ҳ");
	LODOP.NEWPAGE();
	LODOP.ADD_PRINT_TEXT("0mm","0mm","100mm","100mm","���Է�ҳ");
	LODOP.PREVIEW();
	return;
}


///nice small method
function $getValue(value){
	return value==undefined?"":value;
}
/// 2021-07-06 cy  ��ȡ��ѡ���ӡģ��������
function GetSelectData(){
	var rowData=$("#prtTempTable").datagrid('getSelected');
	return rowData;
}
