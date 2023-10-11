//===========================================================================================
// ���ߣ�      nk
// ��д����:   2021-05-21
// ����:	   ��������ά��ҳ��JS,ͬ�²�Ʒ ����ά������
//===========================================================================================
var PageLogicObj={
	m_CureLocListDataGrid:"",
	m_CureArcimListDataGrid:"",
	editRow:undefined,
	imageSrc:"../scripts/dhcdoc/dhcdoccure_hui/image/assscale/"
}
var grpobj = "";    /// ��ǰѡ�������
var itemobj = "";   /// ��ǰѡ����Ԫ��
var EditFlag = "";  /// ���༭��־

var o,   //���񵽵��¼�
	X,   //boxˮƽ���
	Y;   //box��ֱ�߶�
	
/// JQuery ��ʼ��ҳ��
$(function(){
	Init();
	InitEvent();
})
function Init(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("DHC_DocCureAssScale",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		AssScaleListDataGridLoad();
		ExportAssScaleListDataGridLoad();
		Clear();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPageDataGrid(); /// ҳ��DataGrid��ʼ����
		InitPageComponents(); /// ��ʼ���������
	}
	$('#RelType').parent().hide();
}

function Clear(){
	$("#EditForm").attr("data-id","");   /// ��ID
	$("#EditForm").text("");  /// ������
	$("#FormTitle").text("");          /// ������
	$(".form").html("");   /// ��Html	
}

/// ��ʼ���������
function InitPageComponents(){
	var ComboObj={
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&MethodName=GetAssScaleCat",
		valueField:'value',
		textField:'text',
		mode:'remote'
	}
	$("#ScoreCat").combobox(ComboObj); //�½��޸ı�ʱ�ķ���
	$.extend(ComboObj,{
		placeholder:"��ѡ�������������",
		onSelect:function(option){
			AssScaleListDataGridLoad();
	    },onChange:function(n,o){
			if(n==""){
				$(this).combobox("select","");	
				AssScaleListDataGridLoad();
			}
		}
	});
	$("#ScaleCat").combobox(ComboObj);  //����ʱ�ķ���
	$.extend(ComboObj,{
		placeholder:"��ѡ�������������",
		onSelect:function(option){
			ExportAssScaleListDataGridLoad();
	    },onChange:function(n,o){
			if(n==""){
				$(this).combobox("select","");	
				ExportAssScaleListDataGridLoad();
			}
		}
	});
	$("#EScaleCat").combobox(ComboObj);  //����ʱ�ķ���
	
	/// ����
	$HUI.combobox("#RelType",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&MethodName=JsRelType",
		valueField:'value',
		textField:'text',
		mode:'remote',
		editable:false,
		onSelect:function(option){
			InsRelType(option.value);
	    }	
	})
}

/// ��ʼ������¼� 
function InitEvent(){
	
	$(".container").on("click",".list-panel",function (){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(this).addClass('select').siblings().removeClass('select');
		grpobj = this;
		InsPropPanel("P"); /// ��ս�����������
	});
		
	$(".container").on("click",".list-ul-item",function (e){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(".list-ul-item").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("L");   /// ��ս�����������
		if ($(this).find("input").attr("data-reltype") != ""){
			$HUI.combobox("#RelType").setValue($(this).find("input").attr("data-reltype"));
		}
	});
	
	//�ı� ���ڿ�
	$(".container").on("click",".itemClass",function (e){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(".itemClass").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E"); /// ��ս�����������
	});
	
	//����
	$(".container").on("click",".item_par",function (e){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(".item_par").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("S"); /// ��ս�����������
	});
	
	//ͼƬ
	$(".container").on("click",".item_img",function (e){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(".item_img").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("I"); /// ��ս�����������
	});
	
	/// table
	$(".container").on("click","td",function (e){
		/// �ж��Ƿ���Ctrl��
		if(!window.event.ctrlKey){
			$("td").removeClass("tb-select");
		}
		$(this).addClass("tb-select");
		$(".list-ul .list-ul-item").removeClass("select-li");
		$("table").removeClass("tb-select-tr");
		var parobj=$(this).parent().parent().parent();
		parobj.addClass("tb-select-tr");
		grpobj = this;
		e.stopPropagation();
		InsPropPanel("T"); /// ��ս�����������
		$("#GrpTitle").focus();
	});
	
	/// �����
	$('#GrpTitle').on('keydown keyup',function(){
		if (grpobj){
			if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
				if($(grpobj).find('.grp-title').length==0){
					$(grpobj).text(this.value);
				}else{
					$(grpobj).find('.grp-title').text(this.value);
				}
				
			}else{
				$("div.select .list-title label").text(this.value);
			}
		}
		//$("div.select .list-title label").text(this.value);
	})
	
	/// �����߶�
	$('#GrpHeight').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$("div.select").css("min-height",this.value+"px");
				$("div.select .list-item").css("min-height",this.value+"px");
				$("div.select").css("height",this.value+"px");
				$("div.select .list-item").css("height",this.value+"px");
			}
		}
	})
	/*$('#GrpHeight').on('keydown keyup',function(){
		$("div.select").css("min-height",this.value+"px");
		$("div.select .list-item").css("min-height",this.value+"px");
		$("div.select").css("height",this.value+"px");
		$("div.select .list-item").css("height",this.value+"px");
	})*/
	
	/// ѡ��
	$('#Question').on('keydown keyup',function(){
		if (itemobj){
			if($(itemobj).prop("tagName")=="IMG"){
				$("img.select-li").attr("title",this.value)
			}
			else if ($(itemobj).prop("outerHTML").indexOf("</p>") != "-1"){
				$(itemobj).html(this.value);
			}else{
				$(".select-li span.item").text(this.value);
			}
		}
	})

	$('#TextWidth').numberbox({
		onChange:function(n,o){
			if((n!="")&&(itemobj)){
				if ($(itemobj).prop("outerHTML").indexOf("<input") != "-1"){
					$(".select-li input[type=text]").css("width",parseFloat(n)+"px");
				}
			}
		}
	})
	/// ͼƬ·��
	$('#ImgSrc').on('keydown keyup',function(){
		$("img.select-li").attr("src",PageLogicObj.imageSrc+this.value);
		$("img.select-li").attr("alt","���,ͼƬ����");
	})
	
	/// ��ֵ
	$('#Score').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$(".select-li input").attr("value",this.value);
				$(".select-li .item-score").text(this.value != ""?"��"+ this.value+"�֡�":"");
			}
		}
	})
	/*$('#Score').on('keydown keyup',function(){
		//$("div.select .select-li input").attr("value",this.value);
		$(".select-li input").attr("value",this.value);
		$(".select-li .item-score").text(this.value != ""?"��"+ this.value+"�֡�":"");
	})*/
	
	/// ����
	$('#rows').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$("table.tb-select-tr tr td").removeClass("tb-select");
				if ($("table.tb-select-tr tr").length > this.value){
					var rows = $("table.tb-select-tr tr").length - this.value;
					for (var i=$("table.tb-select-tr tr").length; rows > 0; i--, rows--){
						$("table.tb-select-tr tr:nth-child("+ i +")").remove();
					}
				}else{
					var html = $("table.tb-select-tr tr").prop("outerHTML");
					var o = $("table.tb-select-tr tr");
					var rows = this.value - $("table.tb-select-tr tr").length;
					for (var i=0; i<rows; i++){
						$("table.tb-select-tr tbody").append(html);
					}	
				}
			}
		}
	})
	/*$('#rows').on('keydown keyup blur',function(event){
		if((event.keyCode==13)||(event.type=="blur")){
			$("table.tb-select-tr tr td").removeClass("tb-select");
			if ($("table.tb-select-tr tr").length > this.value){
				var rows = $("table.tb-select-tr tr").length - this.value;
				for (var i=$("table.tb-select-tr tr").length; rows > 0; i--, rows--){
					$("table.tb-select-tr tr:nth-child("+ i +")").remove();
				}
			}else{
				var html = $("table.tb-select-tr tr").prop("outerHTML");
				var o = $("table.tb-select-tr tr");
				var rows = this.value - $("table.tb-select-tr tr").length;
				for (var i=0; i<rows; i++){
					$("table.tb-select-tr tbody").append(html);
				}	
			}
		}
	})*/
	
	/// ����
	$('#cols').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$("table.tb-select-tr tr td").removeClass("tb-select");
				if ($("table.tb-select-tr tr:nth-child(1) td").length > this.value){
					var rows = $("table.tb-select-tr tr:nth-child(1) td").length - this.value;
					for (var i=$("table.tb-select-tr tr:nth-child(1) td").length - 1; rows > 0; i--, rows--){
						$("table.tb-select-tr tr td:nth-child("+ i +")").remove();
					}
				}else{
					var html = $("table.tb-select-tr tr:nth-child(1) td").prop("outerHTML");
					var o = $("table.tb-select-tr tr:nth-child(1) td");
					var rows = this.value - $("table.tb-select-tr tr:nth-child(1) td").length;
					for (var i=0; i<rows; i++){
						$("table.tb-select-tr tbody tr").append(html);
					}	
				}
			}
		}
	})
	/*$('#cols').on('keydown keyup blur',function(event){
		if((event.keyCode==13)||(event.type=="blur")){
			$("table.tb-select-tr tr td").removeClass("tb-select");
			if ($("table.tb-select-tr tr:nth-child(1) td").length > this.value){
				var rows = $("table.tb-select-tr tr:nth-child(1) td").length - this.value;
				for (var i=$("table.tb-select-tr tr:nth-child(1) td").length - 1; rows > 0; i--, rows--){
					$("table.tb-select-tr tr td:nth-child("+ i +")").remove();
				}
			}else{
				var html = $("table.tb-select-tr tr:nth-child(1) td").prop("outerHTML");
				var o = $("table.tb-select-tr tr:nth-child(1) td");
				var rows = this.value - $("table.tb-select-tr tr:nth-child(1) td").length;
				for (var i=0; i<rows; i++){
					$("table.tb-select-tr tbody tr").append(html);
				}	
			}
		}
	})*/

	$("#EditForm").bind("click",function (e){
		editScore();  /// �޸�
	})
	
	$(".container").on("mousedown",".draggable",function (e){
		getObject($(this),e||event);       //box�����¼�������  e-->FF  window.event-->IE
	});
	
	document.onmousemove = function(dis){    //����ƶ��¼�����
		if(!o){    //���δ��ȡ����Ӧ�����򷵻�
			return;
		}
		if(!dis){  //�¼�
			dis = event ;
			//    dis = arguments[0]||window.event;   //��������Ǿ���FF���޷���ȡ�¼�����˵����ͨ�� arguments[0]��ȡFF�µ��¼�����
		}
		o.css('left',dis.clientX - X +"px");     //�趨box��ʽ������ƶ����ı�
		o.css('top',dis.clientY - Y + "px");
	};
	document.onmouseup = function(){    //����ɿ��¼�����
		if(!o){   //���δ��ȡ����Ӧ�����򷵻�
			return;
		}
		// document.all��IE��ʹ��releaseCapture����󶨣��������FFʹ��window��������¼��Ĳ�׽
		document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP)
		o = '';   //���ն���
	};
	$("#btnHelpMsg").popover({
		title:'',
		content:"1.ѡ������,�����ǰ�༭��,���޸�ѡ�����������;"
		+"<br>2.��������ʱ,�������ڡ�ҽ��վ����ģ������ά��-���ƹ���վ����ά������������������ࡿģ�飬����ģ����ά�������������;"
		+"<br>3.���ӵ�ѡ����ѡ������Ԫ��ʱ�������Ӷ�Ӧ���,ѡ��������������Ҫ��Ԫ��;"
		+"<br>4.�����Ҫȷ���������������ٽ��кϲ��С��в������������ֱ�񲻶�Ӧ;"
		+"<br>5.�����ÿ����Ԫ�����Ӷ����ѡ���һ���ѡ��,��Ԫ���뵥Ԫ��֮��ĵ�ѡ�򲻻���;"
		+"<br>6.�����ÿ����Ԫ��������һ����ѡ��,��Ԫ���뵥Ԫ��֮��ĸ�ѡ��ѡ�񻥳�;"
		+"<br>7.����еĵ�Ԫ���޷���Ӷ���,����д����;"
		+"<br>8.ͼƬ������Ҫ���Ƚ���Ҫ��ӵ�ͼƬ�ŵ�scripts/dhcdoc/dhcdoccure_hui/image/assscale�ļ�����;"
		
	});
	
	$('#B_GenExport').click(function(){
		GenExportHandle();
	});
	$("#EchkSel").checkbox({
		onCheckChange:function(e,value){
			var data=$('#tabExportAssScaleList').treegrid("getData");
			if(value){
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						$('#tabExportAssScaleList').treegrid('checkNode',data[i].ID);	
					}
				}
			}else{
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						$('#tabExportAssScaleList').treegrid('uncheckNode',data[i].ID);	
					}
				}
			}
		}
	})
}

/// ɾ������Ԫ����ʽ
function ClrDocElStyle(){	
	//$("table").removeClass("tb-select-tr");
	//$("td").removeClass("tb-select");
		
	$('.select').removeClass('select');
	$('.select-li').removeClass('select-li');
}

function getObject(obj,e){    //��ȡ���񵽵Ķ���
	o = obj;
	// document.all��IE��ʹ��setCapture�����󶨣��������FFʹ��Window��������¼��Ĳ�׽
	document.all?o.setCapture() : window.captureEvents(Event.MOUSEMOVE);  
	X = e.clientX - parseInt(o.css("left"));   //��ȡ��ȣ�
	Y = e.clientY - parseInt(o.css("top"));    //��ȡ�߶ȣ�
	//    alert(e.clientX+"  -- " + o.style.left+" -- "+ X);
}

/// ����Ԫ�ع�������
function InsRelType(relType){
	
	$(".select-li input").attr("data-reltype",relType);
}

/// ɾ������Ԫ����ʽ
function InsPropPanel(FlagCode){
	//$('#GrpTitle,#GrpHeight,#Question,#ImgSrc,#Score,#rows,#cols').val("").removeAttr("disabled");
	$("div.propdiv input").val("").removeAttr("disabled");
	var _$label = $("label[for='Score']");
	if (_$label.length > 0){
	   $(_$label[0]).html("ѡ���ֵ");
	}
	if (FlagCode == "P"){
		//���
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().show();
		$('#Question').parent().hide();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($("div.select .list-title label").text());       /// �����
		$('#GrpHeight').val(parseFloat($("div.select").css("height")).toFixed(2));
	}
	else if (FlagCode == "E" || FlagCode == "L"){
		//���б�/�ı�
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		if(FlagCode=="E"){
			$('#TextWidth').parent().show();
			$('#TextWidth').val(parseFloat($(".select-li input[type=text]").css("width")).toFixed(2));
		}else{
			$('#TextWidth').parent().hide();
		}
		$('#ImgSrc').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li span").text());       /// ѡ��
		if ($(itemobj).hasClass("validatebox")){
			$('#Score').parent().show();
			$('#Score').val($(".select-li input").attr("value"));  /// ��ֵ
			var _$label = $("label[for='Score']");
			if (_$label.length > 0){
			   $(_$label[0]).html("Ĭ������");
			}
		}else if ($(itemobj).hasClass("datebox")){
			$('#Score').parent().hide();
		}else{
			$('#Score').parent().show();
			$('#Score').val($(".select-li input").attr("value"));	
		}
		$HUI.combobox("#RelType").enable();
	}else if (FlagCode == "I"){
		//ͼƬ
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().show();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li").text());       /// ѡ��
		$HUI.combobox("#RelType").disable();
		$('#Question').val($("img.select-li").attr("title"));       /// ѡ��
		var ImgSrc=$("img.select-li").attr("src");
		var reg=new RegExp(PageLogicObj.imageSrc,"g"); //��������RegExp����   
		var ImgSrc=ImgSrc.replace(reg,"");
		$('#ImgSrc').val(ImgSrc); 
	}
	else if (FlagCode == "S"){
		//����
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li").text());       /// ѡ��
		$HUI.combobox("#RelType").disable();
	}
	else if (FlagCode == "T"){
		//���
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().hide();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().show();
		$('#cols').parent().show();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($(grpobj).text());       /// �����
	}else{
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().show();
		$('#Question').parent().show();
		$('#TextWidth').parent().show();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().show();
		$('#rows').parent().show();
		$('#cols').parent().show();
		$HUI.combobox("#RelType").disable();
		//$('#GrpTitle,#GrpHeight,#Question,#ImgSrc,#Score,#rows,#cols').attr("disabled","disabled");
		$("div.propdiv input").attr("disabled","disabled");
	}
	$HUI.combobox("#RelType").setValue("");
	$('#RelType').parent().hide();
}

/// ҳ��DataGrid��ʼ����
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		//{field:'DCASCat',title:'�����������',width:100},
		{field:'DCASDesc',title:'��������',width:190},
		{field:'DCASCode',title:'�����������',width:100}
	]];
	$HUI.treegrid("#tabAssScaleList",{
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=QryAssScaleTree&rows=99999",
		loadMsg : '������..',  
		pagination : false,  
		pageSize : 20,
		pageList : [10,20,50],
		rownumbers : false, 
		idField:"ID",
		treeField:'DCASDesc',
		columns :columns,
		onClickRow:function(rowIndex, rowData){
			if(rowData._parentId!=""){
				InsPropPanel();
				InsEditForm(rowData.ID, "");      /// ��ʼ�����ص�ǰ���������
				GetScoreTabHtml(rowData.ID, "");  /// ȡ��������ά����Html
			}
	    },
		onBeforeLoad:function(row,param){
			var ScaleCat=$HUI.combobox("#ScaleCat").getValue();
			var hospID=Util_GetSelHospID();
			var ScaleDesc=$("#ScaleDesc").searchbox("getValue");
			$.extend(param,{Desc:ScaleDesc,HospID:hospID,ScaleCat:ScaleCat});
			$HUI.treegrid("#tabAssScaleList").unselectAll();
		}
	});
	
	var EColumns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		//{field:'DCASCat',title:'�����������',width:100},
		{field:'DCASDesc',title:'��������',width:190},
		{field:'DCASCode',title:'�����������',width:100}
	]];
	$HUI.treegrid("#tabExportAssScaleList",{
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkbox:true,
		fitColumns : true,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=QryAssScaleTree&rows=99999",
		loadMsg : '������..',  
		pagination : false,  
		pageSize : 20,
		pageList : [10,20,50],
		rownumbers : false, 
		idField:"ID",
		treeField:'DCASDesc',
		columns :EColumns,
		onBeforeLoad:function(row,param){
			var ScaleCat=$HUI.combobox("#EScaleCat").getValue();
			var hospID=Util_GetSelHospID();
			var ScaleDesc=$("#EScaleDesc").searchbox("getValue");
			$.extend(param,{Desc:ScaleDesc,HospID:hospID,ScaleCat:ScaleCat});
			$HUI.treegrid("#tabExportAssScaleList").unselectAll();
		}
	});
}

function AssScaleListDataGridLoad(){
	$HUI.treegrid("#tabAssScaleList").reload();
}
function ExportAssScaleListDataGridLoad(){
	$HUI.treegrid("#tabExportAssScaleList").reload();
}
/// ����
function sort(){
	
	if (grpobj == ""){
		$.messager.alert("��ʾ:","����ѡ�д�����ķ��飡","warning");
		return;
	}
	if (!$(grpobj).find('.list-ul-item').hasClass('sort-x')){
		$(grpobj).find('.list-ul-item').addClass('sort-x');
	}else{
		$(grpobj).find('.list-ul-item').removeClass('sort-x');
	}
}

function html(){
	alert($(".form").html());
}

function add(){
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.popover({msg: '��ѡ����Ҫ�༭��������',type:'alert',timeout: 1000});
		return;
	}
	var grpno = $(".form .list-panel").length + 1;
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="list-panel" id="grp-'+ grpno +'">';
		htmlstr = htmlstr + '	<div class="list-title">';
		htmlstr = htmlstr + '		<div class="list-icon">';
		//htmlstr = htmlstr + '	 		<img src="images/infomation.png" border=0/>';
		htmlstr = htmlstr + '	 	</div>';
		htmlstr = htmlstr + '   	<label class="grp-title">'+ grpno +'�������</label>';
		htmlstr = htmlstr + '	 	<div class="list-tools">';
		htmlstr = htmlstr + '		</div>';
		htmlstr = htmlstr + '	</div>';
		htmlstr = htmlstr + '	<div class="list-item">';
		htmlstr = htmlstr + '		<ul class="list-ul list-ul-panel">';
		htmlstr = htmlstr + '		</ul>';
		htmlstr = htmlstr + '	</div>';
		htmlstr = htmlstr + '</div>';
	$(".form").append(htmlstr);
}

function addItem(className){
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.popover({msg: '��ѡ����Ҫ�༭��������',type:'alert',timeout: 1000});
		return;
	}
	
	if(className=="par"){
		var css = "";
		var htmlstr = "";
		htmlstr = htmlstr + '<p class="item_par">�����ı�</p>';
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			// $(grpobj).html(htmlstr);
		}else{
			$(grpobj).find('.list-item .list-ul').before(htmlstr);
		}
	}else if(className=="img"){
		var css = "";
		var htmlstr = "";
		htmlstr = htmlstr + '<img class="item_img" />';
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			$(grpobj).html(htmlstr);
		}else{
			$(grpobj).find('.list-item .list-ul').before(htmlstr);
		}
	}else{
		var css = "";
		if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
			css = 'sort-x';
		}
		var grpname = $(grpobj).attr("id");  /// ���
		var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
		var id = GetFormEleID(ScoreID);      /// �Զ����ɱ�Ԫ��ID
		if((grpname=="")||(typeof grpname=="undefined")){
			if($(grpobj).hasClass('tb-select')){
				var rowIndex=$(grpobj).parent().parent().find("tr").index($(grpobj).parent()[0]);
				var colIndex=$(grpobj).index();
				grpname="grp-table-row"+rowIndex+"-col"+colIndex;
			}else{
				grpname="grp-"+className;
			}
		}
		var css = "";
		var htmlstr = "";
		if((className=="validatebox")||(className=="datebox")){
			if (grpobj){
				if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
					css = className;
				}else{
					css = "draggable"+" "+className;
				}
			}
			
			htmlstr = htmlstr + '<div class="itemClass '+ css +'"><span class="item"></span><input id="'+ className+"-"+id +'" type="text" class="hisui-'+ className+'" /></div>';
		}else{
			htmlstr = htmlstr + '<li class="list-ul-item"><label><input id="'+ className+"-"+id +'" name="'+ grpname +'" type="'+className+'" value="" /><span class="item">��ѡ��</span><span class="item-score"></span></label></li>'; //+'" class="hisui-'+ className 	
		}
		
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			if ($(grpobj).hasClass("tb-select")){
				if((className=="radio")){//||(className=="checkbox")
					if($(grpobj).find('.list-ul').length==0){
						htmlstr='<ul class="list-ul list-ul-tab">'+htmlstr+'</ul>'
						$(grpobj).html(htmlstr);
						//$(grpobj).find('.tb-select').append(htmlstr);		
					}else{
						$(grpobj).find('.list-ul').append(htmlstr);
					}
				}else{
					$(grpobj).html(htmlstr);
				}
			}else{
				$(grpobj).find('.list-item .list-ul-panel').append(htmlstr);
			}
		}else{
			$(grpobj).find('.list-item .list-ul').append(htmlstr);
		}
	}
	//$.parser.parse($(".list-ul"));
	//$.parser.parse(".list-ul-item");
}

/// ����Check
function check(){
	addItem("checkbox");
}

/// ����Radio
function radio(){
	addItem("radio");
}

/// ����Input
function input(){
	addItem("validatebox");
}

/// ����Input
function datebox(){
	addItem("datebox");
}

/// ����p ����
function ins_p(){
	addItem("par");
}

/// ���� ͼƬ
function ins_img(){
	addItem("img");
}

/// ����Textarea
function textarea(){
	
	var htmlstr = "";
	//htmlstr = htmlstr + '<div class="itemLabel"><label>����</label></div>';
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	var id = GetFormEleID(ScoreID);                 /// �Զ����ɱ�Ԫ��ID
	htmlstr = htmlstr + '<div style="height:120px;"><textarea id="'+ id +'" style="width:100%;height:112px;resize:none;"></textarea></div>';
	if (grpobj){
		$(grpobj).find('.list-item').append(htmlstr);
	}
}

/// ����table
function table(){
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.popover({msg: '��ѡ����Ҫ�༭��������',type:'alert',timeout: 1000});
		return;
	}
	
	var htmlstr = "";
	htmlstr = htmlstr + ' <table id="itemList" border="1" cellspacing="0" cellpadding="1" class="form-table">';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' </table>';
	if (grpobj){
		$(grpobj).find('.list-item').append(htmlstr);
	}
}

/// ����label
function label(){

	var htmlstr = "";
	htmlstr = htmlstr + '<label></label>';
	if (grpobj){
		$(grpobj).append(htmlstr);
	}
}
				
/// ��������Ԥ��
function review(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��ѡ����ҪԤ������������","warning");
		return;
	}
	var link = "doccure.assscale.view.hui.csp?AssScaleID="+ ScoreID +"&AssScaleCode=" +"&EditFlag=0";
	if(typeof websys_writeMWToken=='function') link=websys_writeMWToken(link);
	window.open(link, '_blank', 'height=500, width=1200, top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ������������
function InsScoreTabMain(){
	
	var ScoreCode = $("#ScoreCode").val();  /// ����
	var ScoreDesc = $("#ScoreDesc").val();  /// ����
	var ScoreCat = $("#ScoreCat").combobox("getValue");  /// ����
	if (ScoreCode == ""){
		$.messager.alert("��ʾ:","�����벻��Ϊ�գ�","warning");
		return;
	}
	if (ScoreDesc == ""){
		$.messager.alert("��ʾ:","�����Ʋ���Ϊ�գ�","warning");
		return;
	}
	if (ScoreCat == ""){
		$.messager.alert("��ʾ:","��ѡ��������࣡","warning");
		return;
	}
	
	var ScoreID = "";
	if (EditFlag == 2){
		ScoreID = $("#EditForm").attr("data-id");   /// ��ID
		if (ScoreID == ""){
			$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
			return;
		}
	}
	var hospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"Insert",
		ID:ScoreID,
		Code:ScoreCode,
		Desc:ScoreDesc,
		Cat:ScoreCat,
		HospID:hospID,
		dataType:"text"
	},function(ret){
		if (ret < 0){
			if(ret=="-1"){
				$.messager.alert("��ʾ:","�����벻���ظ���","warning");
			}else if(ret=="-2"){
				$.messager.alert("��ʾ:","�����Ʋ����ظ���","warning");
			}else{ //ed
				$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
			}
		}else{
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
			CloseWin();    /// �رշ���
			AssScaleListDataGridLoad();
			InsEditForm(ret);              /// ��ʼ�����ص�ǰ��
		}	
	})
}

/// ������������Html
function InsScoreTabHtml(){
	
	ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		
	var ID = $("#EditForm").attr("data-id");   /// ��ID
	if (ID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}

	var Html = $(".container").html(); /// ��Html
	
	/// ������������
	var itemArr = [];
	var items = $("input[name^='grp']");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ $("#"+items[i].id).next().text() +"^"+ items[i].type);
	}
	
	var FormEls = itemArr.join("@"); /// ��Ԫ��
	var hospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"InsHtml",
		_headers:{'X-Accept-Tag':1},
		ID:ID,
		Html:Html,
		FormEls:FormEls,
		HospID:hospID,
		dataType:"text"
	},function(ret){
		if (ret != 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ��������:"+ret,"warning");
		}else{
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
		}
	})
}

/// ��ʼ�����ص�ǰ��
function InsEditForm(ScoreID, ScoreCode){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetAssScale",
		ID:ScoreID,
		dataType:"text"
	},function(ret){
		if (ret !="" ){
			var retArr=ret.split("^");
			$("#EditForm").attr("data-id",retArr[0]);   /// ��ID
			$("#EditForm").text(retArr[5] +"-"+ retArr[1] +"-"+ retArr[2]);  /// ������
			$("#FormTitle").text(retArr[2]);          /// ������
			if (EditFlag == 1) $(".form").html("");   /// ��Html
		}else{
			$.messager.alert("��ʾ:","��ȡ������Ϣ����","warning");
		}	
	})
}

/// ȡ��������Html
function GetScoreTabHtml(ID, Code){
	grpobj = ""
	$(".form").html("");   /// ��Html
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetAssScaleTabHtml",
		ID:ID,
		ScaleCode:Code,
		dataType:"text"
	},function(ret){
		if (ret !="" ){
			$(".container").html(ret);
		}	
	})
}

/// �Զ����ɱ�Ԫ��ID
function GetFormEleID(ID){
	
	var EleID = "";
	EleID=$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetFormEleID",
		ID:ID,
		dataType:"text"
	},false)
	
	return EleID;
}

/// �½�
function newScore(){
	
	EditFlag = 1;   /// ���༭��־
	mdtPopWin('�½���������');
	$("#ScoreCat").combobox("setValue","");
	$("#ScoreCode").val("");   /// ������
	$("#ScoreDesc").val("");   /// ������
}

/// �޸�
function editScore(){
	
	EditFlag = 2;  /// ���༭��־
	mdtPopWin('�޸���������');
	initScore();
}

/// window����
function mdtPopWin(title){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};
	new WindowUX(title, 'newWin', 400, 230, option).Init();
}

/// ��ս�����������
function ClsPropPanel(){
	
	$('input').val("");
}
				
/// �رշ���
function CloseWin(){
	
	$("#newWin").window('close');
}

/// �������������
function TakScore(){
	
	InsScoreTabMain(); 
}

/// ɾ�����
function del_table(){
	if (grpobj){
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			$.messager.confirm("��ʾ", "�Ƿ�ȷ��ɾ�����?",function(r) {
				if (r) {
					if ($(grpobj).hasClass("tb-select")){
						$(grpobj).parent().parent().parent().remove();
					}else{
						var grplist=$(grpobj).find('table');
						grplist.remove();
					}
				}
			})
		}else{
			$.messager.popover({msg: '��ǰѡ������ޱ��',type:'alert',timeout: 3000});
		}
	}else{
		$.messager.popover({msg: 'Ҫɾ��ʲô?',type:'alert',timeout: 3000});
	}
}

/// ɾ��
function del(){
	if((!grpobj)&&($(".select-li").length==0)){
		$.messager.popover({msg: 'Ҫɾ��ʲô?',type:'alert',timeout: 3000});
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ�ȷ��ɾ��?",function(r) {
		if (r) {
			if (grpobj){
				if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
					if ($(grpobj).hasClass("tb-select")){
						$(grpobj).empty();
					}else{
						$(grpobj).remove();
					}
				}else{
					var grplist=$(grpobj).find('.list-item .list-ul');
					if(grplist.length>0){
						var grpchild=$(grplist[0]).children(".select-li");
						if(grpchild.length>0){
							$(grpchild).remove();
						}else{
							$(grpobj).remove();
						}
					}else{
						$(grpobj).remove();
					}
				}
			}
			$(".select-li").remove();
		}
	})
}

/// ��ʼ������������������������
function initScore(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetAssScale",
		ID:ScoreID,
		dataType:"text"
	},function(ret){
		if (ret !="" ){
			var retArr=ret.split("^");
			$("#ScoreCat").combobox("setValue",retArr[4]);
			$("#ScoreCode").val(retArr[1]);   /// ������
			$("#ScoreDesc").val(retArr[2]);   /// ������
		}else{
			$.messager.alert("��ʾ:","��ȡ����������Ϣ����","warning");
		}	
	})
}

/// �ϲ���Ԫ��
function merge(){
	
}

/// �кϲ�
function merge2() { //��ʵ�ֺϲ���Ԫ��,���������Ƚ�
    var totalCols = $("table.tb-select-tr").find("tr:eq(0)").find("td").length;
    var totalRows = $("table.tb-select-tr").find("tr").length;
    for ( var i = totalCols-1; i >= 0; i--) {
        for ( var j = totalRows-1; j >= 0; j--) {
            startCell = $("table.tb-select-tr").find("tr").eq(j).find("td").eq(i);
            targetCell = $("table.tb-select-tr").find("tr").eq(j - 1).find("td").eq(i);
	        if (startCell.hasClass('tb-select') && targetCell.hasClass('tb-select')) {
                targetCell.attr("rowSpan", (startCell.attr("rowSpan")==undefined)?2:(eval(startCell.attr("rowSpan"))+1));
                startCell.remove();
            }
        }
    }
}

///  �кϲ�
function merge3() { //��ʵ�ֺϲ���Ԫ��,���������Ƚ�
    var totalCols = $("table.tb-select-tr").find("tr:eq(0)").find("td").length;
    var totalRows = $("table.tb-select-tr").find("tr").length;
    for ( var j = totalRows-1; j >= 0; j--) {
	    for ( var i = totalCols-1; i >= 0; i--) {
            startCell = $("table.tb-select-tr").find("tr").eq(j).find("td").eq(i);
            targetCell = $("table.tb-select-tr").find("tr").eq(j).find("td").eq(i - 1);
	        if (startCell.hasClass('tb-select') && targetCell.hasClass('tb-select')) {
                targetCell.attr("colspan", (startCell.attr("colspan")==undefined)?2:(eval(startCell.attr("colspan"))+1));
                startCell.remove();
            }
	    }
    }
}

/// ��ֵ�Ԫ��
function split(){

	var itemCell = $("table td.tb-select");
	
	var rows = itemCell.attr("rowSpan");
	var cols = itemCell.attr("colspan");
	if ((rows != "")&&(rows > 1)){
		var rowIndex = $("table tr").index(itemCell.parent());
		var cols = $("table tr td.tb-select").parent().find("td");
		var colIndex = cols.index(itemCell);
		var totalRows = $("table.tb-select-tr").find("tr").length;
		for ( var j = rowIndex + 1; j < totalRows-1; j++) {
			if (j <= (parseInt(rows) + parseInt(rowIndex) - 1)){
	        	$("table.tb-select-tr").find("tr").eq(j).find("td").eq(colIndex).before("<td></td>");
			}
	    }
	    itemCell.attr("rowSpan",1);
	}
	
	var cols = itemCell.attr("colspan");
	if ((cols != "")&&(cols > 1)){
		for ( var i = 1; i < cols; i++){
			itemCell.after("<td></td>");
		}
		itemCell.attr("colspan",1);
	}
}

function AssScaleSet(){
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��ѡ����Ҫ���õ���������","warning");
		return;
	}
	var dhwid=$(document.body).width()-400;
	var dhhei=$(document.body).height()-100;
	$('#set-dialog').window('open').window('resize',{
		width:dhwid,
		height:dhhei,
		top: 50,
		left:200
	});
	InitCureLocListDataGrid();
	InitCureArcimListDataGrid();
	
	function InitCureLocListDataGrid(){
		var CureLocListDataGrid=$('#tabCureLocList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			checkOnSelect:true,
			selectOnCheck:true,
			fitColumns : true,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=FindLoc&rows=99999",
			loadMsg : '������..',  
			pagination : false,
			rownumbers : true,
			idField:"LocRowID",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
	    			{ field: 'LocRowID', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
	    			{ field: 'RowCheck',checkbox:true},     
					{ field: 'LocDesc', title:'���ƿ���', width: 120, align: 'left', sortable: true},
					{ field: 'selected', title:'', width: 20, align: 'left', hidden: true}
			 ]],
			onBeforeLoad: function(param){
				var hospID=Util_GetSelHospID();
				$.extend(param,{Hospital:hospID,AssScaleID:ScoreID});
				$("#tabCureLocList").datagrid("unselectAll");
			},onLoadSuccess: function(data){
				var rows=data.rows;
				for(var i=0;i<rows.length;i++){
					if(rows[i].selected==1){
						$("#tabCureLocList").datagrid("selectRow",i);
					}	
				}
			},
			 toolbar : [{
				id:'BtnSaveAssScaleLoc',
				text:'����',
				iconCls:'icon-ok',
				handler:function(){
					SaveAssScaleLoc();
				}
			}]
		});
		PageLogicObj.m_CureLocListDataGrid=CureLocListDataGrid;
	}
	function InitCureArcimListDataGrid(){
		var CureArcimListDataGrid=$('#tabCureArcimList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=FindArcim&rows=99999",
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"ID",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
	    			{ field: 'ID', title: 'ID', width: 10, align: 'left',hidden:true}, 
	    			{ field: 'ArcimID', title:'ArcimID', width: 10, align: 'left',hidden:true},
	    			{ field: 'arcitmcode', title:'ҽ�������', width: 150, align: 'left'},
					{ field: 'arcitmdesc', title:'ҽ��������', width: 300, align: 'left',
						editor:{
							type:'combogrid',
							options:{
								required: true,
								panelWidth:450,
								panelHeight:350,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//ȱʡֵ 
								mode:'remote',
								pagination : true,//�Ƿ��ҳ   
								rownumbers:true,//���   
								collapsible:false,//�Ƿ���۵���   
								fit: true,//�Զ���С   
								pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
								pageList: [10],//��������ÿҳ��¼�������б�  
								delay: 500,
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
								columns:[[
									{field:'ArcimDesc',title:'����',width:400,sortable:true},
									{field:'ArcimRowID',title:'ID',width:120,sortable:true},
									{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
								]],
								onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.m_CureArcimListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
									rows.ArcimID=rowData.ArcimRowID;
								},
								onBeforeLoad:function(param){
									var desc=param['q'];
									param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							}
		        		}},
					{ field: 'arcitmprice', title:'ҽ����۸�', width: 150, align: 'left'}
			 ]],
			onBeforeLoad: function(param){
				var hospID=Util_GetSelHospID();
				$.extend(param,{Hospital:hospID,AssScaleID:ScoreID});
				$("#tabCureArcimList").datagrid("unselectAll");
			},onLoadSuccess: function(data){
				PageLogicObj.editRow = undefined;
			},
			toolbar : [{
	            text: '����',
	            iconCls: 'icon-add',
	            handler: function() { 
	            	if (PageLogicObj.editRow != undefined) {
		            	$.messager.confirm("��ʾ", "�������ڱ༭����,ȷ�������õ�ǰ�༭��.",function(r) {
				            if (r) {
					            PageLogicObj.m_CureArcimListDataGrid.datagrid("rejectChanges");
								PageLogicObj.m_CureArcimListDataGrid.datagrid('unselectAll');
								InsertEditRow();
				            }
				        })
	            	}else{
		            	InsertEditRow();
		            }
	            }
	        },{
	            text: 'ɾ��',
	            iconCls: 'icon-cancel',
	            handler: function() {
	                DeleArcim();
	            }
	        },{
	            text: 'ȡ���༭',
	            iconCls: 'icon-redo',
	            handler: function() {
	                PageLogicObj.editRow = undefined;
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("rejectChanges");
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("unselectAll");
	            }
	        },{
				text: '����',
				iconCls: 'icon-save',
				handler: function() {
					SaveArcim();
				}
			}]
		});
		PageLogicObj.m_CureArcimListDataGrid=CureArcimListDataGrid;
	}
}

function InsertEditRow(){
	PageLogicObj.m_CureArcimListDataGrid.datagrid("insertRow", {
	    index: 0,
	    row: {}
	});
	PageLogicObj.m_CureArcimListDataGrid.datagrid("beginEdit", 0);
	PageLogicObj.editRow = 0;
}

function SaveArcim(){
	if(PageLogicObj.editRow==undefined){
		return;	
	}
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��ѡ����Ҫ���õ���������","warning");
		return;
	}
	var rows=PageLogicObj.m_CureArcimListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	if(rows){
		var editors = PageLogicObj.m_CureArcimListDataGrid.datagrid('getEditors', PageLogicObj.editRow);
		var arcrowid = rows.ArcimID;
		if(typeof(arcrowid)=="undefined"){
			arcrowid=""
		}
		if(arcrowid==""){
			$.messager.alert('��ʾ',"����ȷѡ��ҽ����Ŀ.","warning");
			return false;
		}
		
		SaveSet(ScoreID,"ARCIM",arcrowid,PageLogicObj.m_CureArcimListDataGrid);
	}
}

function DeleArcim(){
	var rows = PageLogicObj.m_CureArcimListDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
        $.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
        function(r) {
            if (r) {
				var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].ID);
                }
                var IndexS=ids.join(',');
                if (IndexS==""){
                    PageLogicObj.editRow = undefined;
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("rejectChanges");
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("unselectAll");
	                return;
                }
                var value=$.m({
					 ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
					 MethodName:"DelAssScaleSet",
					 ID:IndexS
				},false);
		        if(value=="0"){
			       PageLogicObj.m_CureArcimListDataGrid.datagrid('reload');
			       PageLogicObj.m_CureArcimListDataGrid.datagrid('unselectAll');
			      $.messager.popover({msg: '"ɾ���ɹ�!',type:'success',timeout: 1000});
		        }else{
			       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
				   return false;
		        }
		        PageLogicObj.editRow = undefined;
            }
        });
    } else {
        $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "warning");
    }	
}

function SaveAssScaleLoc(){
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��ѡ����Ҫ���õ���������","warning");
		return;
	}
	var ConfigIdStr="";
	var rows=$("#tabCureLocList").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (ConfigIdStr=="") ConfigIdStr=rows[i].LocRowID;
		else ConfigIdStr=ConfigIdStr+"^"+rows[i].LocRowID;
	}
	
	if(ConfigIdStr==""){
		$.messager.confirm('��ʾ',"δѡ�����,ȷ����ȡ�����й���,�Ƿ����?",function(r){
			if(r){
				SaveSet(ScoreID,"CTLOC",ConfigIdStr,PageLogicObj.m_CureLocListDataGrid);
			}else{
				PageLogicObj.m_CureLocListDataGrid.datagrid("reload");
			}
		});
	}else{
		SaveSet(ScoreID,"CTLOC",ConfigIdStr,PageLogicObj.m_CureLocListDataGrid);
	}
	
}

function SaveSet(ID,key,ConfigIdStr,Grid){
	var hospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"SaveAssScaleSet",
		ID:ID,
		Key:key,
		ConfigIdStr:ConfigIdStr,
		HospID:hospID,
		dataType:"text"
	},function(value){
		if (value != 0){
			var ErrorMsg=value;
			if(value=="-100"){
				ErrorMsg="����IDΪ��"
			}else if(value=="-101"){
				ErrorMsg="��������ʧ��"
			}else if(value=="-102"){
				ErrorMsg="��������ʧ��"
			}else if(value=="-103"){
				ErrorMsg="�����ظ���ҽ����"
			}
			$.messager.alert('��ʾ',"����ʧ��:"+ErrorMsg,"error");
			return;
		}else{
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
			Grid.datagrid("reload"); 
			if(key=="ARCIM"){
		       	PageLogicObj.m_CureArcimListDataGrid.datagrid('unselectAll');
		        PageLogicObj.editRow = undefined;
			}
		}	
	})
}

function CopyToHosp(){
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��ѡ����Ҫ��Ȩ����������","warning");
		return;
	}
	
	var GenHospObj=GenHospWin("DHC_DocCureAssScale",ScoreID);
	$HUI.dialog("#_HospListWin",{
		onClose:function(){
			AssScaleListDataGridLoad();
		}
	})
	return;
	
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"CopyAssScaleToHosp",
		ID:ID,
		HospID:HospID,
		dataType:"text"
	},function(value){
		if (value != 0){
			var ErrorMsg=value;
			if(value=="-100"){
				ErrorMsg="����IDΪ��"
			}else if(value=="-101"){
				ErrorMsg="��������ʧ��"
			}else if(value=="-102"){
				ErrorMsg="��������ʧ��"
			}
			$.messager.alert('��ʾ',"����ʧ��:"+ErrorMsg,"error");
			return;
		}else{
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
		}	
	})
}

//������
function B_Exoport(){
	var dhhei=$(document.body).height()-100;
	$('#Export-dialog').dialog('open').dialog('resize',{
		width:500,
		height:dhhei,
		top: 50,
		left:($(document.body).width()-500)/2
	});
	$('#tabExportAssScaleList').treegrid("unselectAll");
	var data=$('#tabExportAssScaleList').treegrid("getData");
	if(data.length>0){
		for(var i=0;i<data.length;i++){
			$('#tabExportAssScaleList').treegrid('uncheckNode',data[i].ID);	
		}
	}

}

function GenExportHandle(){	
/*  	var rtn = $cm({
		dataType:'text',
		ResultSetType:'Excel',
		ExcelName:"��������������",
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		QueryName:"QryAssScaleToExcel",
		HospID:""
	}, false);
	location.href = rtn;
	return  */
	var ExportIDArr=[];
	var CheckedNodes =$('#tabExportAssScaleList').treegrid('getCheckedNodes','checked');
	if(CheckedNodes.length>0){
		for(var i=0;i<CheckedNodes.length;i++){
			var rowData=CheckedNodes[i];
			if(rowData._parentId==""){
				continue;
			} 
			ExportIDArr.push(rowData.ID);
		}
		
	}
	if(ExportIDArr.length==0){
		$.messager.alert("��ʾ","��ѡ��Ҫ����������","warning");
		return;
	}
	$cm({
		ResultSetType:'ExcelPlugin',
		ExcelName:"DHCCureAssScaleToExcel",
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		QueryName:"QryAssScaleToExcel",
		ExportID:ExportIDArr.join("^"),
		HospID:""
	});
	return;
}
//������
function B_Import(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=DHCDoc.DHCDocCure.AssScaleConfig&mMethodName=ImportTotalExcel&SplitCount=1&NotShowDetail=Y";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='96%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	com_Util.createModalDialog("importDiag","����", 600, 240,"icon-w-import","",$code,"");
}