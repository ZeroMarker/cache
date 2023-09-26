//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-08-20
// ����:	   ���ֱ�ά��ҳ��JS
//===========================================================================================

var grpobj = "";    /// ��ǰѡ�������
var itemobj = "";   /// ��ǰѡ����Ԫ��
var EditFlag = "";  /// ���༭��־

var o,   //���񵽵��¼�
	X,   //boxˮƽ���
	Y;   //box��ֱ�߶�
	
/// ҳ���ʼ������
function initPageDefault(){
	
	InitDomElEvent();   /// ��ʼ������¼� 
	InitPageDataGrid(); /// ҳ��DataGrid��ʼ����
	InitPageComponents(); /// ��ʼ���������
}

/// ��ʼ���������
function InitPageComponents(){
	
	/// ��������
	$HUI.combobox("#RelType",{
		url:$URL+"?ClassName=web.DHCEMCScoreTabMain&MethodName=JsRelType",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
			InsRelType(option.value);
	    }	
	})
}

/// ��ʼ������¼� 
function InitDomElEvent(){
	
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
		InsPropPanel("E");   /// ��ս�����������
		if ($(this).find("input").attr("data-reltype") != ""){
			$HUI.combobox("#RelType").setValue($(this).find("input").attr("data-reltype"));
		}
	});
	
	$(".container").on("click",".itemClass",function (e){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(".itemClass").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E"); /// ��ս�����������
	});
	
	$(".container").on("click",".item_par",function (e){
		ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		$(".item_par").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E"); /// ��ս�����������
	});
	
	/// �����
	$('#GrpTitle').on('keydown keyup',function(){
		if (grpobj){
			if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
				$(grpobj).text(this.value);
			}else{
				$("div.select .list-title label").text(this.value);
			}
		}
		//$("div.select .list-title label").text(this.value);
	})
	
	/// �����߶�
	$('#GrpHeight').on('keydown keyup',function(){
		$("div.select .list-item").css("min-height",this.value+"px");
	})
	
	/// ѡ��
	$('#Question').on('keydown keyup',function(){
		if (itemobj){
			if ($(itemobj).prop("outerHTML").indexOf("</p>") != "-1"){
				$(itemobj).html(this.value);
			}else{
				$(".select-li span.item").text(this.value);
			}
		}
	})
	
	/// ��ֵ
	$('#Score').on('keydown keyup',function(){
		//$("div.select .select-li input").attr("value",this.value);
		$(".select-li input").attr("value",this.value);
		$(".select-li .item-score").text(this.value != ""?"��"+ this.value+"�֡�":"");
	})
	
	/// ����
	$('#rows').on('keydown keyup',function(){
		
		if ($("table.tb-select-tr tr").length > this.value){
			var rows = $("table.tb-select-tr tr").length - this.value;
			for (var i=$("table.tb-select-tr tr").length - 1; rows > 0; i--, rows--){
				$("table.tb-select-tr tr:nth-child("+ i +")").remove();
			}
		}else{
			var html = $("table.tb-select-tr tr").prop("outerHTML");
			var rows = this.value - $("table.tb-select-tr tr").length;
			for (var i=0; i<rows; i++){
				$("table.tb-select-tr tbody").append(html);
			}	
		}
	})
	
	/// ����
	$('#cols').on('keydown keyup',function(){
		
		if ($("table.tb-select-tr tr:nth-child(1) td").length > this.value){
			var rows = $("table.tb-select-tr tr:nth-child(1) td").length - this.value;
			for (var i=$("table.tb-select-tr tr:nth-child(1) td").length - 1; rows > 0; i--, rows--){
				$("table.tb-select-tr tr td:nth-child("+ i +")").remove();
			}
		}else{
			var html = $("table.tb-select-tr tr:nth-child(1) td").prop("outerHTML");
			var rows = this.value - $("table.tb-select-tr tr:nth-child(1) td").length;
			for (var i=0; i<rows; i++){
				$("table.tb-select-tr tbody tr").append(html);
			}	
		}
	})
	
	/// table
	$(".container").on("click","td",function (e){
		/// �ж��Ƿ���Ctrl��
		if(!window.event.ctrlKey){
			$("td").removeClass("tb-select");
		}
		$(this).addClass("tb-select");
		$("table").removeClass("tb-select-tr");
		$(this).parent().parent().parent().addClass("tb-select-tr");
		grpobj = this;
		e.stopPropagation();
		InsPropPanel("T"); /// ��ս�����������
	});

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
	
	if (FlagCode == "P"){
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().show();
		$('#Question').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($("div.select .list-title label").text());       /// �����
	}
	if (FlagCode == "E"){
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		$('#Score').parent().show();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li span").text());       /// ѡ��
		$('#Score').val($(".select-li input").attr("value"));  /// ��ֵ
		$HUI.combobox("#RelType").enable();
	}
	if (FlagCode == "T"){
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().hide();
		$('#Score').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().show();
		$('#cols').parent().show();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($(grpobj).text());       /// �����
	}
	$HUI.combobox("#RelType").setValue("");
}

/// ɾ������Ԫ����ʽ
function ClrDocElStyle(){
	
	$('.select').removeClass('select');
	$('.select-li').removeClass('select-li');
}

/// ҳ��DataGrid��ʼ����
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'Code',title:'���ֱ����',width:205,align:'center',hidden:true},
		{field:'Desc',title:'���ֱ�',width:190}
	]];
	
	///  ����datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			InsEditForm(rowData.ID, "");      /// ��ʼ�����ص�ǰ��
			GetScoreTabHtml(rowData.ID, "");  /// ȡ����ά����Html
	    },
		onLoadSuccess:function(data){
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
		}
	};

	var params = "";
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreTabMain&MethodName=QryScoreScale";
	new ListComponent('ScoreList', columns, uniturl, option).Init();
	
	///  ����ˢ�°�ť
	$('#ScoreList').datagrid('getPager').pagination({ showRefresh: false});
	
	///  ���ط�ҳͼ��
    var panel = $("#ScoreList").datagrid('getPanel').panel('panel');
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide();
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
		htmlstr = htmlstr + '		<ul class="list-ul">';
		htmlstr = htmlstr + '		</ul>';
		htmlstr = htmlstr + '	</div>';
		htmlstr = htmlstr + '</div>';
	$(".form").append(htmlstr);
}

/// ����Check
function check(){
	
	var css = "";
	if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
		css = 'sort-x';
	}
	var grpname = $(grpobj).attr("id");  /// ���
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	var id = GetFormEleID(ScoreID);      /// �Զ����ɱ�Ԫ��ID
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="list-ul-item '+ css +'"><label><input id="'+ id +'" name="'+ grpname +'" type="checkbox" value="" /><span class="item">��ѡ��</span><span class="item-score"></span></label></li>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		$(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item .list-ul').append(htmlstr);
	}
}

/// ����Radio
function radio(){
	
	var css = "";
	if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
		css = 'sort-x';
	}
	var grpname = $(grpobj).attr("id");  /// ���
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	var id = GetFormEleID(ScoreID);      /// �Զ����ɱ�Ԫ��ID
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="list-ul-item '+ css +'"><label><input id="'+ id +'" type="radio" name="'+ grpname +'" value=""/><span class="item">��ѡ��</span><span class="item-score"></span></label></li>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		$(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item .list-ul').append(htmlstr);
	}
}

/// ����Input
function input(){
	
	var css = "";
	if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
		css = 'sort-x';
	}
	var grpname = $(grpobj).attr("id");  /// ���
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	var id = GetFormEleID(ScoreID);      /// �Զ����ɱ�Ԫ��ID
	var css = "";
	if (grpobj){
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			css = "";
		}else{
			css = "draggable";
		}
	}
	var htmlstr = "";
	htmlstr = htmlstr + '<div class="itemClass '+ css +'"><span>��ѡ��</span><input id="'+ id +'" type="text" name="'+ grpname +'"/></div>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		$(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item').append(htmlstr);
	}
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
	var htmlstr = "";
	htmlstr = htmlstr + ' <table id="itemList" border="1" cellspacing="0" cellpadding="1" class="form-table">';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
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

/// ����p
function ins_p(){
	
	var css = "";
	var htmlstr = "";
	htmlstr = htmlstr + '<p class="item_par">�����ı�</p>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		// $(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item .list-ul').before(htmlstr);
	}
}
				
/// ���ֱ�Ԥ��
function review(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}
	var link = "dhcemc.scoretabreview.csp?ScoreID="+ ScoreID +"&ScoreCode=" +"&EditFlag=0";;
	window.open(link, '_blank', 'height=500, width=1200, top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// �������ֱ�
function InsScoreTabMain(){
	
	var ScoreCode = $("#ScoreCode").val();  /// ����
	var ScoreDesc = $("#ScoreDesc").val();  /// ����
	if (ScoreCode == ""){
		$.messager.alert("��ʾ:","�����벻��Ϊ�գ�","warning");
		return;
	}
	if (ScoreDesc == ""){
		$.messager.alert("��ʾ:","�����Ʋ���Ϊ�գ�","warning");
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
	
	runClassMethod("web.DHCEMCScoreTabMain","Insert",{"ID":ScoreID, "Code":ScoreCode, "Desc":ScoreDesc},function(jsonString){

		if (jsonString < 0){
			if(jsonString=="-1"){ //hxy 2020-03-04 st
				$.messager.alert("��ʾ:","�����벻���ظ���","warning");
			}else if(jsonString=="-2"){
				$.messager.alert("��ʾ:","�����Ʋ����ظ���","warning");
			}else{ //ed
			$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
			}
		}else{
			$.messager.alert("��ʾ:","����ɹ���","success");
			CloseWin();    /// �رշ���
			$("#ScoreList").datagrid("reload");   /// �����б�
			InsEditForm(jsonString);              /// ��ʼ�����ص�ǰ��
		}
	},'',false)
}

/// �������ֱ�Html
function InsScoreTabHtml(){
	
	ClrDocElStyle();  /// ɾ������Ԫ����ʽ
		
	var ID = $("#EditForm").attr("data-id");   /// ��ID
	if (ID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}

	var Html = $(".container").html(); /// ��Html
	
	/// ���ֱ�����
	var itemArr = [];
	var items = $("input[name^='grp']");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ $("#"+items[i].id).next().text() +"^"+ items[i].type);
	}
	
	var FormEls = itemArr.join("@"); /// ��Ԫ��
	runClassMethod("web.DHCEMCScoreTabMain","InsHtml",{"ID":ID, "Html":Html, "FormEls":FormEls},function(jsonString){

		if (jsonString != 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
		}else{
			$.messager.alert("��ʾ:","����ɹ���","success");
		}
	},'',false)
}

/// ��ʼ�����ص�ǰ��
function InsEditForm(ScoreID, ScoreCode){
	
	runClassMethod("web.DHCEMCScoreTabMain","GetScoreScale",{"ScoreID":ScoreID, "ScoreCode":ScoreCode},function(jsonObj){

		if (jsonObj != ""){
			$("#EditForm").attr("data-id",jsonObj.ScoreID);   /// ��ID
			$("#EditForm").text(jsonObj.ScoreCode +"-"+ jsonObj.ScoreDesc);  /// ������
			$("#FormTitle").text(jsonObj.ScoreDesc);          /// ������
			if (EditFlag == 1) $(".form").html("");   /// ��Html
		}
	},'json',false)
}

/// ȡ����ά����Html
function GetScoreTabHtml(ScoreID, ScoreCode){
	
	$(".form").html("");   /// ��Html
	runClassMethod("web.DHCEMCScoreTabMain","GetScoreTabHtml",{"ScoreID":ScoreID, "ScoreCode":ScoreCode},function(jsonString){

		if (jsonString != ""){
			$(".container").html(jsonString);   /// ��Html
		}
	},'',false)
}

/// �Զ����ɱ�Ԫ��ID
function GetFormEleID(ScoreID){
	
	var ID = "";
	runClassMethod("web.DHCEMCScore","GetFormEleID",{"ID":ScoreID},function(jsonString){

		if (jsonString != ""){
			ID = jsonString;   /// Ԫ��ID
		}
	},'',false)
	return ID;
}

/// �½�
function newScore(){
	
	EditFlag = 1;   /// ���༭��־
	mdtPopWin('�½����ֱ�');
	$("#ScoreCode").val("");   /// ������
	$("#ScoreDesc").val("");   /// ������
}

/// �޸�
function editScore(){
	
	EditFlag = 2;  /// ���༭��־
	mdtPopWin('�޸����ֱ�');
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

/// �������ֱ�
function TakScore(){
	
	InsScoreTabMain();  /// �������ֱ�
}

/// ɾ��
function del(){
	
	if (grpobj){
		$(grpobj).remove();
	}
	
	$(".select-li").remove();
}

/// ��ʼ���������ֱ����������
function initScore(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// ��ID
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}
	
	runClassMethod("web.DHCEMCScoreTabMain","GetScoreScale",{"ScoreID":ScoreID},function(jsonObj){
		if (jsonObj != ""){
			$("#ScoreCode").val(jsonObj.ScoreCode);   /// ������
			$("#ScoreDesc").val(jsonObj.ScoreDesc);   /// ������
		}
	},'json',false)
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

var LINK_CSP="dhcemc.broker.csp";
//��ǰ����
var editIndex = undefined;
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

/// �Զ�����ҳ�沼��
function onresize_handler(){

}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })